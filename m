Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A05E6F08E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 12:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC486B0089; Tue, 23 Dec 2025 07:51:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492D86B008A; Tue, 23 Dec 2025 07:51:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3888B6B008C; Tue, 23 Dec 2025 07:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 275096B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:51:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A76C557AA3
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:51:06 +0000 (UTC)
X-FDA: 84250720932.18.F5FDDAA
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id C7D234000B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:51:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VkpPOZzL;
	spf=pass (imf07.hostedemail.com: domain of kari.argillander@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=kari.argillander@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766494264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94oLudekiif5HeilrLZvUbicmHfgUxsRz7xoRTDax8c=;
	b=beUpqa6HocyIi0c+jwUVeuFLeVHkDlkOWKidAyPeoAU4TydpKu3cVjxihC79FtC16odCJ/
	B+OhpcVGAfKjoE8k5TkeAC4EFTNK3b146LGSAT4+V0kDVFEGUwZCv+iBp5AEH5xJJKPPO4
	ocJRIueEAxCSNb/2nbIbJEnkWtu2db8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VkpPOZzL;
	spf=pass (imf07.hostedemail.com: domain of kari.argillander@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=kari.argillander@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766494264; a=rsa-sha256;
	cv=none;
	b=WIxK7p23Xc3vcWN5mCMNWGZFwcFN/YOtxrH68Y3QyrydXMD53/BwXWeiPcQh5xDt30odFG
	46DLF335Qsk/y3k6ir+jN7vmFW4U5dJwYBmmRsYgof6fTFNEOagpiPiU9pq1ZO2bIBcEqa
	MBXOPisdSGIJhu9xtXkYUtnCyA2gqls=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34ab8e0df53so4767843a91.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766494263; x=1767099063; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=94oLudekiif5HeilrLZvUbicmHfgUxsRz7xoRTDax8c=;
        b=VkpPOZzLZAHCBYe7lLqH7DJmaBoMR2+JoKkW37p0cTjme1FK2xCLC+GtFObipnPSJn
         edNF/RKF/oT6Rj/cQXGl+l/Ee3jZF0SOFGMaxIr9XdH1mb/PwNKVLKTPYAIZZ8O5geLN
         L5Ga4vnOKEglEKZhSXKz2IeASbZ9Mz4lFYkSlj7ewm+1ks8yoZuWkDl69ZF92qaiJOsX
         FLb+t1WdO0GFSqs32zg67yvzV4HLe9Rlic3w6Nq/ieYq1j6xFQp8mVS0/QhB7LA+XunL
         lAVithSV7kBDTrNa73mWwk0yE/RFq5bJBdR27XlVFO2C/w0FXqEDFkYan30lMs5KetMo
         qOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766494263; x=1767099063;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=94oLudekiif5HeilrLZvUbicmHfgUxsRz7xoRTDax8c=;
        b=T0U7FcgsP0bFdos7INjDcQT4KWr+tW6sxfbrePMpnM7gD1QTVY1281vtNck0RTfQWX
         2eMzs5BiEoXsGTzTUdebyY76VjoVs3vN119qhAjY6ne9cdNEC0243Glf1/ERmcznJCrl
         2ktnfFFYS0x8EwBybNe1fk540ndIaBoD6C9VXbLyLP+aZgrQtX4p/9qjAbScSSvBqtYW
         V8Assi3rzdmluVw0bJNz9zdHcVEXz2SZtTDmddii9uYbj+SCWjfipZt6zYB/uqjI2C09
         ima0IO5/WTHkd47qoqiSPIvJreQsrT0EzTYjDqR+8j/EEJylti2PH1/ko/BOUr6nTS+M
         b2Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWDZLpLdl8yzsQbHYukQDz685F5AY8BzwMi7BRpf7Iijwb6CZCa64ouxcy6nMcy66x3RKtR07Q+nw==@kvack.org
X-Gm-Message-State: AOJu0Yznh6GupQ1u38UkVpCPQe+RGnX/CApGOQvW2+mXVstpI/8vxkTg
	T92GPzdUpcHjVO95faTIGey1/wUkAwuH9QioQqJyhv9wEungROlQCjsk3lH8YkpRQDUIFJnKPva
	g1Dm1pSo4D856r8gqHdLE9DJA4PEqhx4=
X-Gm-Gg: AY/fxX4+c5c1CHf1lJpWq1MpfaqgMoz66FujLLYqdUuixYjeKnLCyk4YDl8EZQCecG/
	kXAAB7EWw2GOSGPoi0BVTYmzlhhhcZ0eqEV8H6b02nLb4+Pd7/Z/Gyzm0NsdCwY0bIkUOL6eu6W
	2zffJmF8DFmOoTzZhp93lXoWhFb0ievd3L8Y1h1Jspvsw/1rpd1IjHVAn8pDC5tvPUN6CyiTtzO
	B/OEz9li7ZZ96zMzKAxH6/oMoBxDadTEO/dJbmJMdukW4nvAxLCoowa/+5ziJWom5goV919Q2JU
	C2B96x+ivy5KySP0wUayP4LuYUEi2kVZ6u816A==
X-Google-Smtp-Source: AGHT+IEyXen1C1B8ovK20y6lttFcVNSX1HJ8t8g6zVHxBqNhBj98DsBKXvaXLLqY6Msx/fJ20+CpJ/vT7PMw8NgCuG4=
X-Received: by 2002:a17:90b:524b:b0:343:6a79:6c75 with SMTP id
 98e67ed59e1d1-34e921e05bcmr12664658a91.29.1766494263489; Tue, 23 Dec 2025
 04:51:03 -0800 (PST)
MIME-Version: 1.0
References: <20251223-rust-page-check-v2-1-fba3dbdde1d8@gmail.com>
 <20251223115726.621bfa38.gary@garyguo.net> <46e188a4-4b74-4206-ba18-f107f45bb98d@gmail.com>
In-Reply-To: <46e188a4-4b74-4206-ba18-f107f45bb98d@gmail.com>
From: Kari Argillander <kari.argillander@gmail.com>
Date: Tue, 23 Dec 2025 14:50:46 +0200
X-Gm-Features: AQt7F2q8qcvJUN3cNbmkB3zGBaUJ3rux4__s9gM96stJQSLixTZEWUtt842AGQI
Message-ID: <CAC=eVgQBrfcWSgmLAqL-RqQr8FrcCS0e1j4aQ-ck5dBSJt4zNA@mail.gmail.com>
Subject: Re: [PATCH v2] rust: page: Simplify overflow check using checked_add()
To: Dirk Behme <dirk.behme@gmail.com>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, 
	Dirk Behme <dirk.behme@de.bosch.com>, Alexandre Courbot <acourbot@nvidia.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8hkt89nw8c7nsgdaomjznywr7b33grng
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7D234000B
X-HE-Tag: 1766494264-323849
X-HE-Meta: U2FsdGVkX1+V3NOYP/sDE+mZswalbC3Y7j3MXoXKWRzICuuOmqaody02tQwTTaw3QBogqpH/jmNBY/BLtBNOFkM9Kvtdl2fmKc/2XJjZBENA8W2HsxqVYBJKh0DKwdRjrSZX9/J12vXONFDQd2oojoHV22/neOwCKq4PJFseC3nz7OTkvZ4sfXPMphvSDfkKO02ZnBtARf7hYM18OXjEw0xbtMXFaRpop/KuyBr0wot7d5yb2+N1CQESv5qHb/GGcPqTiwHfv0Dhak5mjPd8c5eIOa+7kzNK4BAhHYZMFA+rbtAufztHhlNwYXCiKEJb4P4pAHnN9hIxX1SGiSmrpo283XTSxErOVAldpBhlpZVEmWFOp1zuZ0AyT3QJ9t5JqzboYKzPZkXzUE5UyLcNjIRwf3HOYvXNMSTeuaN0OwzMFgTpXgcF8HgFV6jMh38sVOJiJpTVWayblmQJUrXOxyBFFVl+2CLs6G28tdVrTYrJreaPr1ZeYTz2mDWsv9xEUw0Q7DQx7ys8CshF5eAifYnjr9x88BpHZvFl7w5YPyrW3NnN4fYDVvJTn5kgY8SO6A+WQqcaHyLt3CsATqtE7rNtAcXTZoll0j4tVcUFOI93ldGMpK4WTeoSE4b5i4ajv2MgIeeHW7FyoHgPbYsrf+DAoQ/uhBIBRbLqQTLcWgru//XNOjbTdo/aQUWr2qyCJCEg/rljnxrBIgKdMw014YfYZ2uT8hNyALTAPLKooYjxxHpf9LYHX5POmZUrMxczkytifGXnwp+H6G5WH5ytWEt5EhTrNLwYPXzUWUDqXOTY9z435WUlvBXR/6KhDz0oIQG2NuDGTVkTIUqZWDpv9tEtWGLHAps7YNTUYWY4Ff0xIbWAIiyDYEosZFf/dkH4yZAMXiiQ6HkZfzPmSKVpHGBL4i10I5z2ITJ6WUzDAgpBlDWcwxLmSySrwA1FdQcXr9eaAHUsBS0UhbiFvFu
 bLRTg6JA
 CAYfSomLswAgNwaK9IBm3GUjV29G02Bg1wzYJUVe9Kgpz7ogxlYxuaPx/Ef1cTCsxaKKTCVXSR2DtArojJ2dIa8QhowAuotnigMjIjJ0xBxbiCdNzyTUN9eOqLi5z6pcUZWcfS3vKbfaTQRrBnbumOP+jNTH2KqiruCw7/DBq0TNvOpnXnUAEwUlhnJpFASXh1qgeBK9wz+G/MSTQMS/NR/GzOYWDEogXC73MCXVXp3fP1kndQRA0V8sAj8LzVbschdlUMgPwvE9IHOoSk9jxviLV5dPgnxHznnwTYv5RYh2cS13iFOy/fF93rAMFgLm1QoiDX0S+Ga7mKEGvZzVzTYuhvTPvP4y8oTt1c2lS0YPi81TRPqCknRI62F7vvG9nkpVckQ2729fxD6HaGsWB1LrommItxlEQnA/5YJxR2z31uCRW70UtWESE5XtuTmgYNrAQ/Qb4B2/SXKoGrEj0SxYewSoGUUz/yj6ZkxHzjiM8RwV78gJhyrHCS7XgINeuTUWDq3Pxv1A2L0G8XQ3trVorwiRC9R50oPNPqCuE9L06PchU3fpNz4qpGYLCI3OaRb6mrPiZ9xLW0x9pNoKFy8EG9f6Ja1DRohJjVB/whW1IaNajmR+2AeUmWlFb17Tx6MAecYRpOfMHBrOTPc4//M/tNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.12.2025 14.29 +0200 Dirk Behme (dirk.behme@gmail.com) wrote:
>
> On 23.12.25 12:57, Gary Guo wrote:
> > On Tue, 23 Dec 2025 12:06:17 +0200
> > Kari Argillander <kari.argillander@gmail.com> wrote:
> >
> >> Replace the explicit bounds comparisons with a single checked_add()-based
> >> range check. This avoids redundant comparisons, makes the overflow case
> >> explicit, and results in simpler generated code (checked with godbolt
> >> for x86).
> >>
> >> No functional change intended.
> >>
> >> Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
> >> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> >> Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
> >> ---
> >> Changes in v2:
> >> - Added MSVR todo (Dirk Behme)
> >> - Link to v1: https://lore.kernel.org/r/20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com
> >> ---
> >>  rust/kernel/page.rs | 19 +++++++++----------
> >>  1 file changed, 9 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> >> index 432fc0297d4a..cd2af7e4c357 100644
> >> --- a/rust/kernel/page.rs
> >> +++ b/rust/kernel/page.rs
> >> @@ -239,17 +239,16 @@ fn with_pointer_into_page<T>(
> >>          len: usize,
> >>          f: impl FnOnce(*mut u8) -> Result<T>,
> >>      ) -> Result<T> {
> >> -        let bounds_ok = off <= PAGE_SIZE && len <= PAGE_SIZE && (off + len) <= PAGE_SIZE;
> >> -
> >> -        if bounds_ok {
> >> -            self.with_page_mapped(move |page_addr| {
> >> -                // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
> >> -                // result in a pointer that is in bounds or one off the end of the page.
> >> -                f(unsafe { page_addr.add(off) })
> >> -            })
> >> -        } else {
> >> -            Err(EINVAL)
> >> +        // TODO: Replace `map_or` with `is_none_or` once the MSRV is >= 1.82.
> >
> > I was about to suggest just enable the feature gate, but turns out it was
> > only added in 1.81. That's a fast one to stabilize!
>
>
> With Alexandre's `matches!` proposal I was thinking that we could drop
> the TODO comment and we won't need to touch this file again once MSRV
> is >= 1.82. Opinions?

Personally I like `is_none_or` more than `matches!` but then thinking again I
agree that it might be better because we do not have to leave TODO here. I will
respin again tomorrow.

I also checked that output for at least x86 is identical.

> Cheers
>
> Dirk
>
>
> > Reviewed-by: Gary Guo <gary@garyguo.net>
> >
> > Best,
> > Gary
> >
> >> +        if off.checked_add(len).map_or(true, |end| end > PAGE_SIZE) {
> >> +            return Err(EINVAL);
> >>          }
> >> +
> >> +        self.with_page_mapped(move |page_addr| {
> >> +            // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
> >> +            // result in a pointer that is in bounds or one off the end of the page.
> >> +            f(unsafe { page_addr.add(off) })
> >> +        })
> >>      }
> >>
> >>      /// Maps the page and reads from it into the given buffer.
> >>
> >> ---
> >> base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
> >> change-id: 20251219-rust-page-check-819ccc39c53a
> >>
> >> Best regards,
> >
> >
>

