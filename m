Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53052E9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DBA6B00A2; Tue, 17 Feb 2026 15:25:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5786B00A4; Tue, 17 Feb 2026 15:25:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7E56B00A5; Tue, 17 Feb 2026 15:25:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C79A6B00A2
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:25:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2C54C0D9C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:25:46 +0000 (UTC)
X-FDA: 84455079492.10.AF9DDB3
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9BB37C0002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:25:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gDLDFRFs;
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771359944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtDUesrtBPEYQJ391tb6gvhG3srtiHA9wFHnN9DgsNU=;
	b=37BaGt/KM1DQjiXvBI86YqmudkBzeju2myFMd07DkJY4D7uDJLcarU2NOTP6k5AWrrDOQ0
	RszAVcp0NrxGPwyw4k/LmiEl9j7yZWt1+bd31oKr1KAo1/66UlJA4M7M0ZrVfPP2vJZdDK
	wyORrwpCKB1MA/74J4ojTQTJOBI9Lkk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gDLDFRFs;
	spf=pass (imf28.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771359944; a=rsa-sha256;
	cv=pass;
	b=8HgcOYz2xoQI8yDg4vG5zxQeXdLZ+ZRjX+S/M2sx6jf7rks0/DNI3cpNTNh4SkkG7oIzuk
	fBGEYaquHWyGHVCTaE6syN++/LvRgMpFjiM+dD7zNNctDlRWtBtdNlQUHO+NekOByAcB6Q
	W59PjZyO7BMmmeY0biKdXxpWJaQsOo0=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso401a12.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:25:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771359943; cv=none;
        d=google.com; s=arc-20240605;
        b=OLaO/qw8Xx5cv4nuCwoL8KKtvivcCUV7D8tad6YhZqbPqMTnXNO2Q+CEc7dox5fPsE
         ioEMPUEXpoGFGNyUMAeMBwWU7O+Orp7BO9HSMZrP+Q/ifNWaAWMzIzRxh7PdaF/fGUjo
         Pt4rUornb8tTBiJ6KQeUf0K5kqG9wECvBosWSo9Vh5jiLJdIGc+u/y33R+BxTz7Cx3Ou
         +S+earPdq1O3Zscbriqew3PO2Ud04rA4osQOjWZRmzGYzLgxgqyADQlL+7P9dM1Xlc3l
         TSEjiicN9gTM5V2FEa1Wsl6AwZtVPPDb0JSsPTujoztLM/UR1+039iggg61bX18Lqpss
         AGpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GtDUesrtBPEYQJ391tb6gvhG3srtiHA9wFHnN9DgsNU=;
        fh=7BhaulyZuXEXWZTfI0+IlVHOG+pzFkaw/zwhAI5zANQ=;
        b=ZhogHefPwzFK8ZorXTnBwVmqKND1iYp7ocgLDkUA0rdz/hQIG6u0HcR7HB03ZtN66B
         X37fct5YNUFg5LgUg0kE+aupPgaQgP2QzoCe+cNABktTxCpyjkco4Bs47Z2uxISthqGB
         ew5nC3olO6XjAmyPitn9yDtqTNPLSZwWpHCRkUEkrWsErP2Llm2LtAp7PxngjwteoRZS
         LZbCgpyqU+fOVVaWE7dXubHcIhqvHgzkuqiMjH3BhE/K2S9YCfQoajtcTUBk9xahE7Ww
         VCR9isOQMgVxXcJik/fb6T0yb0y2XoUGQflw3AtubF1OaWxTDUYwLfB25rl9cjvx76EY
         iTmQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771359943; x=1771964743; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtDUesrtBPEYQJ391tb6gvhG3srtiHA9wFHnN9DgsNU=;
        b=gDLDFRFs08guWgEwpTwwLRd4vUwp2wDaTvpmSlTI15K0Xmd78EbPHjg3SPbYjJWwQd
         ukywjv31MQcSslej0JmlSEkmSM15whgF4qXwhMycBf9Fjkid7GDF5UiPbUKOnmLDdLtv
         6smBhvjlAkD6eTya6COLaIkpWuYxaFJ3WnxKEwFSRmA69DzCx54YdOwHUPoveccISxxw
         LFU3MjaHPauyohed9rOHoKFwQh3bJostbkP+QQcWomRjqn8UGecqlvgVlWV0UMCNhBXG
         avYYAp838IscLJsUPD8IYgSCIkPtjZLLuoAjKBIAleEhKq6kgXUgf+8PBfrCGHJvvcl5
         5h5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771359943; x=1771964743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GtDUesrtBPEYQJ391tb6gvhG3srtiHA9wFHnN9DgsNU=;
        b=dkuBGfR6CReZLsE5z8E5L8bo8pCyb2amMc4yIYuqyv7iYsYtiJwepockjh1g25a52p
         8qcQBMUsKEHBcALVccB1nwYWbN1SEp3pTmFM5G7IqY2TqC+zK6BntsrTgPzaN5ce9j/p
         ZuQvexWF3Thd4d3X5tTZdecmiw9h6tgxqhx3xEkXAJmNBNj/znZA3CO24HtUYx7Eq8/5
         GiF4A04XfkeNxiqklz2BGBIUrMI+F8a8FkJQ5dExfyMkYD7LcnK6B8HZ1l/IO/UXqne8
         c/bQBAGLjUl+oLhPHz/KLHllBOwaOnIjTb4slydHPKy/LpFpTa+Pf89mH5h4EQLhT1aO
         p/Og==
X-Forwarded-Encrypted: i=1; AJvYcCVo0FEsZEEiH/D0Hi961MYeKZsPNQFm197hxNzXsdcyh3vAXFxdCg8WZKSbJw//XrpDiRsNzcqjRQ==@kvack.org
X-Gm-Message-State: AOJu0Yxrsgujytl9M+5Ig4IzJ2ZMeNUMvn/EBAHLicXRxFeanLOO6hyS
	pGpzfagvc2J3sv1bCX+IdHjDhBOlFSu5fxh5jV5bH/fZA9G355y4KUnaS5N2wgF6hi4pkFHq+O1
	Suyw72mcYEm8mOoHGcN4GBS0nx2u28SjuyysQtNt2
X-Gm-Gg: AZuq6aKTbEInD5b1BL8uxZ8WwnyEaAQ5HuKwGkoczL/as5UdsWEYu5SgP+jUTP7lhO+
	0P6wZtab6MPA8Qr9qH3qTRboa690XoaC8Q6E3A4n6/T+SQ+b4fs9+TLhxIyvdv0Yq0LqR1uF8oX
	LXXA6lpiptF+njbyCXzXHC+yhLnpwdKus7EMRLUi3Glu+00tlxcK/IMPq/GrKhFAW8Q1tNFBSOg
	6Ypnm+s5nwgjeSxqWOKUVWBbTmLr5qiZdoH+6TShEU5ZhNpE+mNm1IybowsnX36d7uYsUXCqMBy
	sUL5zdv2w+YQe+1rquSwlhv53XH2OXZcm+I77Q==
X-Received: by 2002:aa7:d783:0:b0:649:8aa1:e524 with SMTP id
 4fb4d7f45d1cf-65c14a4eca3mr72486a12.11.1771359942517; Tue, 17 Feb 2026
 12:25:42 -0800 (PST)
MIME-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
 <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com> <CAG48ez2mUQ-D3jpPbvdZzcOz16LMXRnzcudOZsfdoftBF5yvPA@mail.gmail.com>
 <CAH5fLghCCAvOi+xRtPnD4ToQmyignjkn-PJ6xG6Y1DAUHgBKVA@mail.gmail.com>
In-Reply-To: <CAH5fLghCCAvOi+xRtPnD4ToQmyignjkn-PJ6xG6Y1DAUHgBKVA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 17 Feb 2026 21:25:05 +0100
X-Gm-Features: AaiRm51ZqfX4kH-xRbv10dGnYSdGZ5HZG-5FCY7NO40gcIrlsCslxHPpR6pvA5c
Message-ID: <CAG48ez1vuJMmVyFw9BLePaMskOJ0ig3LwZw5FL34RFAjqyOW5w@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust_binder: check ownership before using vma
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BB37C0002
X-Stat-Signature: 1ajejb61ifp7pwrhkrx5zyqy1r7pf5it
X-HE-Tag: 1771359944-406306
X-HE-Meta: U2FsdGVkX1/4IPpRww0UHSPZA/9K618hhr3oBfJGlN7ChYwJ4JpATp+hI+KhLCgHSlptJGNnpxykD6UPjv+VMqXgqcDjryoLMzTWhFoFEidayCrg5ZKnhnyAvaP+LNtc0YFqNN60ZzDqz1nzkCDsho6o7ZV4ndqWjKJRNN39KLTz6xJNs0rpAjRTqo1rj4MId0Ep80yvOID2DJcNeaMcvTUOo1Zor4Ee7mPAxwX9bEvrFIazrnrLGAx/RB27rJ9Y7K6zYQlAe61aQHdfzcdfSqvy4pmV0ldjlfedtiI0CxtIwa+2oCzrqSPzqKZZXJnqI+CtIr8a91KifcJj71SKv5rmDEcFR5Pm3cAcq+MSVpDn38PKtwddrwLI7/exUYthotahw9R/nAnjWo2TICrNhXlqIIeDYldg/Gm9umGwaFIB6qHihNU/P55yQBpWwOtHufhqyNUw6/KXY09dnWrVQNJVHTim5s6o5SUPhuGMgyntKebLjJhV/YSiFl4IBEbRfJlU2cqgSkSTmhmFRHncB+eLOQK2JwybGGUii2N+JO6dHhla5pjmuvHFIAkYsi7AfyhSoINbgVXPJpO/yoEApYb1vne9AR2xTYbLomQ/+ZdRMKalcQK0iYF7T9X40xNdqU3dmy0Xhu/b9RSBowT36IRjeeaXM8r3Q6K066t7K6Q1ml9MnqGP1AbZGsU4Z1Gkui2wo/EM28A8ST5WEhJKwpYeSE1tFpBapparuVU85s/SuNlgOdXPlVfH3jhWyM4uJ7FRRt889UkSTfVuorb9rTnYPy+0ir7Q8f2usO69m9LEDqwrm7xZafbnjuGL7kaaDM3I8Psftn1emYUHGwvjRu4s8lQ4UMEfiP4NHEPOyWgAimsauXvC9VhqOO9BIhMVacz6KaLmgY1uYKsxSmACVMIf/SblNblI311F4AJM6b7BBalqV1m/b1VNzgWmq5N3AwRQqIhkv706BAx60U1
 sEbddQcs
 LZW31oWSdUnkIVFSsN6vGZpDQP/FslvEHkPgFk67nI3IG5heA032RSFxa2DCBkrFeSceXCe3E/00aFubNqY91GW87vWHaL5MwC+RIltGUKhK9BmVYyXxUFlY1Kr5aM4oBNKX1J8IAm0wJdfrOg1r0qjjm87tTUR32DBmEvGBraFzxqwiAQ9fzkB9CQsy6N/B6u8+R6JD5JTCjxlZTajcSlRPMHL6SDScLTnl5ro5oPuNi0bMMo0w2IVuzaZjABxPz36jjY9ebvlfRrcym8gCjU5JAzSASgmsIWAsKY/B/Jun83Vui6RRZEt9Q4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 9:15=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
> On Tue, Feb 17, 2026 at 5:55=E2=80=AFPM Jann Horn <jannh@google.com> wrot=
e:
> > On Tue, Feb 17, 2026 at 3:22=E2=80=AFPM Alice Ryhl <aliceryhl@google.co=
m> wrote:
> > > When installing missing pages (or zapping them), Rust Binder will loo=
k
> > > up the vma in the mm by address, and then call vm_insert_page (or
> > > zap_page_range_single). However, if the vma is closed and replaced wi=
th
> > > a different vma at the same address, this can lead to Rust Binder
> > > installing pages into the wrong vma.
> > >
> > > By installing the page into a writable vma, it becomes possible to wr=
ite
> > > to your own binder pages, which are normally read-only. Although you'=
re
> > > not supposed to be able to write to those pages, the intent behind th=
e
> > > design of Rust Binder is that even if you get that ability, it should=
 not
> > > lead to anything bad. Unfortunately, due to another bug, that is not =
the
> > > case.
> > >
> > > To fix this, I will store a pointer in vm_private_data and check that
> > > the vma returned by vma_lookup() has the right vm_ops and
> > > vm_private_data before trying to use the vma. This should ensure that
> > > Rust Binder will refuse to interact with any other VMA. I will follow=
 up
> > > this patch with more vma abstractions to avoid this unsafe access to
> > > vm_ops and vm_private_data, but for now I'd like to start with the
> > > simplest possible fix.
> >
> > This sounds good to me.
> > (Userspace could still trick Rust Binder into accessing the VMA at the
> > wrong offset, but nothing will go wrong in that case.)
>
> Vma is tricky stuff.

Well, they try to give userspace a lot of flexibility, and then things
like the rmap are supposed to abstract away this complexity so that
normal drivers don't have to deal with this complexity...

> I think if I add the vm_ops->close callback this one isn't possible anymo=
re?

Yeah. (Or you could explicitly check that vma_pgoff_offset(vma,
virtual_address) returns the expected index. But either way, from a
security perspective it shouldn't really matter.)

