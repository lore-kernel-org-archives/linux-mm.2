Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AB1EB26EA
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50FBD6B0005; Tue, 10 Feb 2026 11:55:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE046B0089; Tue, 10 Feb 2026 11:55:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CAA56B008A; Tue, 10 Feb 2026 11:55:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CCE26B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:55:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD6F81B38B6
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:55:58 +0000 (UTC)
X-FDA: 84429149196.29.6C918B3
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6F37A000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:55:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C8UAP8HC;
	spf=pass (imf25.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770742556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkE6wX1mSJ65eu9tW2JxtPMNM6UoIxgvLwNvwjU7SoE=;
	b=lmrch5uNp8lli3uKWta+BRE5LDsWLgX3D0XDIkabL0JnKfEUSK6OAIPPxI9ANfOWgCdXH5
	5t3xirsVOH9k6hiBtKPALVOijK/lci08RsTu4SxYTUejaZgGubfaJbtip42FnxERRGrRCI
	zEHuT737ZDTS9L2IPmmK6pg8yGDPXjs=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C8UAP8HC;
	spf=pass (imf25.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770742556; a=rsa-sha256;
	cv=pass;
	b=P35PHw3mJXAQl6mheQ5nVznjWMriDGbRWz+oRsaqsgWkQQqNtoSCtgf6kUVdrXwMGUIrgU
	vPZqoeYatbo6MA8VaYtHWNlTdjFyX/49TDVlfQrVnDyZ+HJfkzgmPL/PqqldbCRD1Mde3M
	hgmm5yGGvZj+UY4FVU8RD1RRrTQPzZA=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-386914b8e81so232001fa.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:55:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770742555; cv=none;
        d=google.com; s=arc-20240605;
        b=VL7qVazw2FXyj0I1ZarIyWzHDJSB+f6fWqSbImIgIte9S6TV/Z53VkipV+gfW9bPYR
         Cn4pt/HXESV6/y8XQ2GVhvD7GLfiprNEJ+0UL9gfnlXy1wdy9eDGE+eXG9YKS2RGAgVO
         0dihb5T2HqOAt3eaKyFon0mADXeVc5ccokOGA3rMdvOfLs9Xd1RkG7ymQdzrzabuA4cS
         CP6JQI8yR0QPIlowvI6GyyG0a9v9uFkvpg/RdtO5o+4aGieETyzlfTTUT/8gMl6BnUC6
         YU3lX+n0RPDIV2rNqdm2PmV9+B/i3exU+pD2OLOUEJ7Sobkv+abBYWS1ZH257yY9mQFk
         SMlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fkE6wX1mSJ65eu9tW2JxtPMNM6UoIxgvLwNvwjU7SoE=;
        fh=dgCiQmi1GrIT4Xt6qAWQZShu5rty6VLuVJniAeq5srs=;
        b=VL+KxwyhHd7IiewNOBFWVNch63svhGuhpTSqMmmnFK+j1yzoRhLecmz92+2fvAcIkd
         U/+2RbT2pAtbYQT1acV5CGOv2gh9bOT6o39Int9vaJ2wwt2w7+08mQ1QybGs/BRnJY/n
         wWIb8fDTGdDTVgQ/zr3iiQ2QyNkN0z/qizAcC2U/OHOQ3bSiea+ehR9aCwniZmnVSEXh
         SFyGSTvQssSgMweYdbI8eB2DALJ9JDZTSrfTMxkA8n5EDVevT2CexLuG/T0rVolkZk3s
         jJTOh45NeRGma00+XjRrUPHP9qmzxUxhQS6TCesPvibXCufAmfaBmCIjuMHLu6QGrKsA
         ylxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770742555; x=1771347355; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkE6wX1mSJ65eu9tW2JxtPMNM6UoIxgvLwNvwjU7SoE=;
        b=C8UAP8HCT9CA7hOlsfFT2Ush+CFXCaJABCb1v34n1zBJbo8+3GgFbh0uxeZh5K2hHe
         flUEUGacm72O6Qa9tf18I/VwDdLqKdK1AhEFsCIGYyNyjIlO88+/cQvhBhY10tl70Rwt
         6tLfR7aLUAKaH5RPrlVev4pjoH9rDTRnLS+wesk4w6XXSXL96w4WZ8jEBC0Ihvrsgubw
         L1nLDRVHXd9K33DDcTxi0yzk9Anhgw+KbH7L5NTw1bLrUVToM+8qROq42tVB6YDyOw57
         pX6vhH0MIEHBS7o2b6H7vRmPS0v6qy4RwCqJP0X32+fWyEmL3lQf33NKVh5NOWSpOgYe
         vfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770742555; x=1771347355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fkE6wX1mSJ65eu9tW2JxtPMNM6UoIxgvLwNvwjU7SoE=;
        b=GNYLzIlZFbq3RnyKyG0C57jXn9+QUq1aysTmnhoeS+B5V1a7+3Jh1wBvHJC1qsVOjb
         hGB1nhlVBaE/8N86AH8To1P7N1uEQ4I8v08objmOCI6tENqhb4UFxWV0twGapvUz7Pvr
         YBc6wQgECjHtbjIBzz9xyjbHsDTB5Zl3HwlKEdMz6pm3gL0tNzH0gowjO4+uQzfzcq9C
         YMFuSj2D6gcnjKWX0yjWoQDSHkoESAto7RVH3cBu+vGbrErTWK0Iw2PWcTWcB9r/oaz8
         60uuMW/nnbsLnBjgIIrlBGiz6puH11/54ZKv2JmqcdlU3lSBkS8dwnjOFXbW/pFbFzna
         HKEw==
X-Forwarded-Encrypted: i=1; AJvYcCUKtjBaJU/jvK/8kSf+WTGnAR3sntwuVjnx3Km61UwBuYQduAdKLHjZILGlsVEECaxYVFY3lobckg==@kvack.org
X-Gm-Message-State: AOJu0YyxMnok7v3UmdwSYxjAmkVmee8AFc0HrSDSLFjGpWuCPIWP4Plx
	M2wcA3znWndSxTfv3alrCDzzWeWw1qAVLQC/Uu9VcbkCg5NgNlfbBfH1sEDiqDiT3IjmJzkYaed
	m0bNliY4S7XopNqHrHtOz06aT1cry0Ck=
X-Gm-Gg: AZuq6aJXZN3ztTwaX3OcfZMU4VMSnqoQHISutHApG56ss02RgETZ1d1yrWmhC8fI9SJ
	BGk2ldmJ3AvSVJ0vCgM4ocEfyxq7vQ/zrt8C7CldJAUthu2KJlNvu1dcpe9SNuS4s6AbyusZCVT
	1MVCN2BWJ4O8lS1FpE/IB6T2Y4epZmMN8OtHIADQCpFKIuu+Fwl8AIWaqEPd5f5K0+vhyp7xkg7
	GP+A1Z5VoTNS5gb0zXd3HQjiZJLwZsrTapo/JLqTroctnpkNJeoIkovj156ejMvJUfDGBBA6XPF
	HmhlQqXbNpiYRHH3i3Qqad0HSJRz7Qt9YGuGqx3uEma7chZaHOARg2AFWNuB7GvtUZAQFfS2dcd
	CYz1rK1DhWifRO4ERfi84
X-Received: by 2002:a2e:a99c:0:b0:385:c15f:6bd with SMTP id
 38308e7fff4ca-386ee5df4afmr10380621fa.10.1770742554544; Tue, 10 Feb 2026
 08:55:54 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-2-f777c65b8ae2@kernel.org> <aYr-gyQN_AaIJkSH@macos>
In-Reply-To: <aYr-gyQN_AaIJkSH@macos>
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 10 Feb 2026 11:55:17 -0500
X-Gm-Features: AZwV_Qj3n2_xEKJZHh_pbAQqJQF7fvAcEJlcOkIYSsdo9vdtJYW7WyHeI0xwRFg
Message-ID: <CAJ-ks9k5=jGFWRsTmHbsvzJF3YTYzbDTQ43-uUNe8gaZfsnc8w@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] rust: xarray: add debug format for `StoreError`
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5yddnmf6e374m8pijhiiongftyemcq9t
X-Rspamd-Queue-Id: A6F37A000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770742556-109762
X-HE-Meta: U2FsdGVkX1+tU5Noln0L3r4s3JSYzFShq5/b/VU6RJ9uZmwP4szrZJo4wa7zJ5Y8T/DdjCD+PyBdQmRV3Sr8A2fMP911WI3UC6Bk8bS9pky4y8tjTdnLnYwVWWpEchWIExpLMNGBybWDfJUgkMdyk6I/YEE6YA/lx8U3PBFa1m4xfDEwULGRXrQwclFWkUlFLrCUTKf6SwLwy4KEuYT/KZUihCSMJI2bjsq2oGESS8o/PjEoVY4tXFjH8oGf+m7NlMeaSI3kmQBrLOmgqrMKsxH3oR0CmZSpTgfsAHMxykZmeFQq7qQoGYHPiKEia3iZt2TGc2avyzUtMP9/cOIBp5vuOlQ/gOEsWZukWTtMEq5f2YEvAd3KtRrNvLiNU3dUxK9hbqIgLgZP681DBkXvpsO7mZzDnbiay7XzPBvvhcKMBIhMgOzzz3AnkQ0Kyc8N00WVvF2IsjBmQ2ftb2dA5IEhBXQ2bQqsfP5/tUorVBfpW78/tXTocdMPPIpblZNCUo5uGybjKV61GzOdzx2PfWPxADd8RfZkglOCIiRjEb9C2tP6KZIAZaj52E0rZO4SyKFjb4MB6yzUXGr8IX9AMFH1rl+G6txcv6mCEE5ZzRLIm7E50yOhJ4UB4EalAkA3P5caPy+zj7PrgspS6lU9pUBVCmhpdWpnU9F1Skg8zeWFeDrLwAcQNSBJ4cBDTaSMfnrdLTKDQUZgvs3iRH/rdypLJeX2ABknjwNCgmfOLse9Stm6DjSVl42aBQIRZYDCHlT4tZNJKtjM8dT+DRP1fUe1GUi46FonYAkOVKUank6oh0mZbCRnTyPQ32Iyadua8LJk8Qoq2aTNEAv0Vx7F+5INLk45LGcsMCtTZbgHGxdvZhj2VOUZVdkpU+v4H8mdQ3Vr5sO6BoDW2jfaBCsgtthRazH5pFZWCjQCI/symq6mugWRPCZ541p92ndxoyXxMn3hIkNnSwpKoPabtTE
 YImqLTDU
 ifj/GAucizgMJHoHgZQOswbfQSiHtduHMGqHY9Zx4L1z9OsM718PGqgBHQQEfZbT0eSHnpBtdwlOcSlW/bWqaisQaY8L7fm7t9kJW++87u0ATfo55Ee7DQrBxbR0/vgO4JfrZ5UabHB4RJE8Vwp5KdrWBhwm4vKGxu7WNb5d/PbmDTofgzImGd5+SKeid+BcvpvLH46qaWIrIxJJ9ND8QvxKdZZN3+1AM3n2mC1ukAM8zDtP6kHw9UBmn2WYPiXhI6KTqjslK6Z6Hp1wfe2lGl4ZpylTBTM5NQ9sB1lLOanTCvVddGycSJ+XYf1n9mb2DB2rfAcoDdatgH4RRA9fGRUBLbuUTKVk1mqGKTeeK0EZF8vKxrWFAnESmG8UDLtOFsHOo3AtmFdcn5VAVvVulejML1hecUGhXLLuhtFXIo2bnD851SzGsxiucSQvQprCSGWkcj4+aB1Ck0JY2iCGmgYmAAW2OEJ4XX4w9utnFFv2iPQQEx8VjA8h6qjGOtWFAf0eSmXf8dpwVYDRKUgDQXVVMyUEjCqzOiNJUv+Q6M+EXJLMCqUfN/sqpBYhILp6wcgr1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 8:45=E2=80=AFAM Daniel Gomez <da.gomez@kernel.org> =
wrote:
>
> On 2026-02-09 15:38, Andreas Hindborg wrote:
> > Add a `Debug` implementation for `StoreError<T>` to enable better error
> > reporting and debugging. The implementation only displays the `error`
> > field and omits the `value` field, as `T` may not implement `Debug`.
> >
> > Reviewed-by: Gary Guo <gary@garyguo.net>
> > Acked-by: Tamir Duberstein <tamird@gmail.com>
> > Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> > ---
> >  rust/kernel/xarray.rs | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> > index 88625c9abf4ef..d9762c6bef19c 100644
> > --- a/rust/kernel/xarray.rs
> > +++ b/rust/kernel/xarray.rs
> > @@ -193,6 +193,14 @@ pub struct StoreError<T> {
> >      pub value: T,
> >  }
> >
> > +impl<T> core::fmt::Debug for StoreError<T> {
> > +    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Resu=
lt {
> > +        f.debug_struct("StoreError")
> > +            .field("error", &self.error)
> > +            .finish()
> > +    }
> > +}
> > +
>
> Is there any best practice for when to include use core::fmt::*, so you c=
an
> avoid being verbose here?
>
> I see other cases like this, but I couldn't find anything in the code
> guidelines.

It would probably be better to use kernel::fmt::* rather than
core::fmt so that we can interpose our own trait in the future, if we
want.

