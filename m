Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1379606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iRjHqKNq
Received: by kanga.kvack.org (Postfix)
	id 5C5B46B05B6; Thu, 26 Nov 2026 12:31:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F8E6B05B7; Thu, 26 Nov 2026 12:31:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4276B05B8; Thu, 26 Nov 2026 12:31:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C55436B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:31:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AB5F16036A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:30:51 +0000 (UTC)
X-FDA: 85477960302.25.F150B54
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 411DA1C0017
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:30:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iRjHqKNq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795714249;
	b=xVqvyEKQbYvQEyLg9L2lhMnIx9Z8kr1KRZmBi/kypC1I3mmR++BSWGgzdPJLc3R7ntbub1
	bKT0dxqdilZCGn7XPScNkLDTuMaZCiBGj97Cm42ZCt/XfXVXo4YO5skeKTMOQ0rF7ucmLE
	VPuCUp7hWmBtiMzo6kaVhX44F51ZUq8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795714249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYk5wAcyTKA1us6S0oQwHk/cu9RUlgZp57aA9h4156M=;
	b=CT08j/j5DVrdoQbct6iSRKa9eqZdOzsWSQ4Ss1Y9gngFqg5HGL+Te5eCzB7mx09vhZ3uO6
	r5S3isnlIC6XoJw6kaZBru7V2TvRL0XNpRvZTPoXkO0KD6Vb85jxxiq8bolZmQirC9+hRi
	ui7ZUA82//hCBx5XPd3JulAcARlaRb0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iRjHqKNq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-53634b8328eso67802741cf.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:30:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795714248; cv=none;
        d=google.com; s=arc-20260327;
        b=kHH+XTgsXevJeCNJ5zGP49vFBASgpfVR0CbrZuw0+7lIn4ocNxdZmuXIAy6W4Rbo73
         N7WTPydHF9R8bdqKovkOZYRlCqu4HIVh+Od3pHJeb0jbGdhnxsAM+xRiAu7niBU+ggVQ
         bPVBOHajnVqpcm4qhx5UZJ/OjGVyd6ah3VaycOc+iRrd1wK9MZsh71il7uLkF5oSTpki
         zZb4aL9S0WcMy4uPB8CY/8BbDGU5sWfi4FtN+m3SdTPl5CuVRAscJ+OQSYlpJCWIgmsK
         yWmowklyfuYJNK72gFomxqgyJSn5DemNHvjtUtRLaq/VeQbVluQPmw4VdGlzc85EFN0g
         Xv7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pYk5wAcyTKA1us6S0oQwHk/cu9RUlgZp57aA9h4156M=;
        fh=ZPvpVRxQ5MXRo8o9wTWlstJOmfpHC2Pw2a7vLg7i9CY=;
        b=hye8Jj+lo9AgRbmyhb90KzGONEEZ0CXHZUxTXWvv0sdJOYeukxg+IlsVdhcLJ6U4Md
         +BWCWVvjfce026VvDOHt7HbS7tHAu6E3877Z0t6XQwod8NfpL6p3L3KlQm/W0vHnNarI
         B7Oo4ahlu+gzvFp+sSOuhZt+27aAOGzXcC0J+X1XHjPh8A0SiM7LUHRgO0Kzan5cxj7n
         UWL2IyCVCuscqTMCdO337vnY7fWKp0ekhrbsSgEODmDELp0pThCiaC5DKuzPPRnDxCPN
         HoNokFRWzLoLqyJyPMCBAaSqNGHS457ao0XDfJHjp1vma3PKMrFEvDARjHpr6cUBehM3
         WTrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795714248; x=1796319048; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pYk5wAcyTKA1us6S0oQwHk/cu9RUlgZp57aA9h4156M=;
        b=iRjHqKNqAD/gHztvPE3l/2aIjzbVuw2jxhWY1yCfR5N7PKsw2Rqi348WNPceoQZAfi
         M6KqAG+blO0VbzkzEI1uVUjLzQOeTxcVpcwXGmcYPcj2gd/2/zWhrYavtE4//XFJZbtG
         /o3KKUgcE+4RXkWqTVQqq6RvWJ/yyUWTTP2Bbd6JS/VTRaXnKVnt6SnfxYbxLtXi4xdB
         BEH+w0JvhayMSLiQnJNGjiWFODA5DvkiYy7XxiuGUo0DMbxQed2Akj7ovcxI9HKelcYP
         FVOLmDPHRLjpVBHaw2SJoyqDcthpqFQMuvxFOHBk7tcqKHTIZ3U8M/gp53vmy1r79Gnk
         2boQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795714248; x=1796319048;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pYk5wAcyTKA1us6S0oQwHk/cu9RUlgZp57aA9h4156M=;
        b=fhYiqVyyxDIC8j72HawJ0FNDHIPkcq2c6hSH94AQ6RCGlqjVHrpUFjXt54ak/FVCR4
         +5I4dDS1pzAQOKzeNLWfZKdygfFWJONIYvfHatnAuQLuwOpI7UAfUqo4HLl9Ih2NUUfm
         pb+D6CsYNBEmnbmFlUXjlahP/Trl8Fnsck0ZPWqRBISaQl5oosnSpHJbYeB7hPd0wBRU
         gkSlOlJ1Z0TNMGY1bod6Nrci7aZS1ALj9cVSZhSENLm3mH+gPVTcHPlQKsKZCk+tJ7NY
         nnrMmMxMBnbaGRjf03KBn5Zpx4vluc7BWQVbTR8Rtmnji7qimlQiRHev2QXKW2LOJUZE
         ZxGQ==
X-Forwarded-Encrypted: i=1; AL+hErHFzemKNH/WQ/T4kD1kZcjT5Ni4F/+D9sGoZ/rQulNw1Ujh3ivTxtEihKCYO3xPD+w/kOQ5GjfKfg==@kvack.org
X-Gm-Message-State: APuU4Z90X7vR1xrbdYd7Uo1tSPfJvj7JB3ffm7dkPiOMG3XBeQmbUBFt
	78bd/1gv2N01CO1kaE8N0DP64jk13nhi2Nga2zlz2InN3kdY1z5OCqzaYjQGdjikygEcf0lSKme
	wbwv4ACIQBucEmhyuRDh6Pyenbkh1U3I=
X-Gm-Gg: AZFdTZdz9dqZN7EIxP20l6049R6BlPH1SyDXT6x5vico1QfJYClTLY/g2RHfMxI3fbG
	y4kvEk8jhEcHvF8BlXuS3QPyzESfj8HOWUu7FT6mH/B28uAcEl0VUtnJbt2bSrGchmZmUXUbeeW
	XRCdoVdb+/pS3yPBvr8nN1Wx0fyOG3nqsM23Owtf4DQg7FC5Ol04ogdizppdPFPnPOj4BCT5zhj
	CIkhYqottSSPK8csJIa6TOi41Vd3uqlX5pUkXV3XP9TS81Q536XqWikDOaHnSE/eEHWEmP0DqKh
	XqsrYebjuJGoTn7AjNP6E30JCYk085rNNj23rzmhqLhum5k3CAfmgV8IVSDwrR4naN7T1Vmh/bt
	OBG+V5ZjI7vPC+COXNfddeO3toefqepXGnmUe
X-Received: by 2002:ac8:5d49:0:b0:536:6047:5223 with SMTP id
 d75a77b69052e-55d76a89c91mr393754511cf.49.1795714248209; Thu, 26 Nov 2026
 09:30:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
 <20261124.225103.2152350984946270550.tomo@flapping.org> <DN59EXEWINPV.3UUBOIK6EROAC@garyguo.net>
In-Reply-To: <DN59EXEWINPV.3UUBOIK6EROAC@garyguo.net>
From: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
Date: Thu, 26 Nov 2026 19:30:37 +0200
X-Gm-Features: Aa3M54pUd2g0wgweuLBmsRg_pmRKl67kEJhI-Zk8ycWIZFLVampA67QmR6GpFLc
Message-ID: <CA+YDrKCiL9p7h5DrjW3iGn3ckJg6bbvdsW=OwYC0GeXkUD0p8w@mail.gmail.com>
Subject: Re: [PATCH] rust: bug: add warn_once! macro
To: Gary Guo <gary@garyguo.net>
Cc: FUJITA Tomonori <tomo@flapping.org>, fujita.tomonori@gmail.com, ojeda@kernel.org, 
	boqun@kernel.org, bjorn3_gh@protonmail.com, lossin@kernel.org, 
	a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu, 
	dakr@kernel.org, daniel.almeida@collabora.com, tamird@kernel.org, 
	acourbot@nvidia.com, work@onurozkan.dev, liam@infradead.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 411DA1C0017
X-Rspam-User:
X-Stat-Signature: 9xn8zooutu3ruxak8ipq7sju6k9zxbkm
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795714249-880541
X-HE-Meta: U2FsdGVkX18BQP+DQxrFwqc1G3bU8G4IHUwYYzNntWOcjcXalrK8khglh4vAufCfObqrO7Sgt32cAjA/eWit2JHuEmY3OyT1aAbSmgVx7Gvv0o+IOSlWUBgVkQG8iGL36A35ap+AgtV1Hreg9OEZI1KkTdSp+L/AQR/1UU0qpjc/y4bRW7+yzxHsiMfCTDDiaxhXX5TdFy7WUiXRmozg1rOku8KalJMwrzPmrFl6PFphtvbVjdON+sOFkdRXh3k8wYRZ/+b7tQF0aruu36ZISx40p8HG0yhYfT/4ODrOkGPiOHHN0lM5askQ3GuOdcZGUVYNwAD6au1FiRp+oUjAHxCJx2/zjCA5YgnaH6m7O4TDW0JT1VYon67qASvrTJvi5Rdh03b1U/NZWEh1k/USvE1K8lRy0MawYGWsc4dvG2TpDVeK81PCjkGfnSrvGO308tMM0rEhrXFCh+Yo9ZMdYYe/FxF3CzY/TeUcg4N4laKZQYbS6puMHc0MyJMNDgocxvNzaIKPMR0razJmHwS2SGYL0OG594uOf3cdRptCcESsGVqqBiKUjBL17ea8DhWzO6woY7lzLJfKhTIhRujdQgBAtYEutf8cAY9vOCbHG6V4z/z1FT33nrr1zj2GHiVstoSUO9LFVj8mjle7eNizTBYIeezH69fqBFbshY5/8kanRSI/DyJimtm2f10xJUQOqCYY2hRVCuXQwCW1Mnm83EFkgeoYjFyIskPKYvXXRvc5IO4nNLOGbMOWCkKt8PR6pnAA4ASY8QUe9NcMCGCscekCBloRCSZ8RnuaDXTVd3RxcASYjzKaocCZ90jrDAKBotTroOPx77Auko9p5y3lIjmLWYhsxwf18WTSZV+0K+ZqHgQyVSZIFM0v9OdfSThC3/OnVf82mV26MxcgW+alU4mqbVfCW2QSjnKPsREGaVrT5yuGwYX2C6uwf7ZO/pNzQL6ocjvBuIW+/bFAm6h
 4rPbwAO8
 6d1aUbS1GTEGG8wMAN0iwN5sG+xTxsj57PAUD9EeeTxXebPvFeBvpTQVxGevJVDDW6cfb2YGL59iUEdRSkyjFiJNAL7R+BZlOmCpG5Tdza2CA4127/hTw3mLSwdM2saRUj3CZBmBv3Io8BJDIz9EH8XK1b0X2mYFFMdi6Y5oG286ufqB7A7aZWUi1bHtsDe97FAw31/jquyWED4cIaTyY14HwOoWZSRMiWH/s24EgqEsJrDOfW3FqQAqg3WVPqvS5lecD736ai/+aIXW71YHdl4SzkosNjhd5RBVnmQvzusqXggWZ2DmVjgDu22RKIOOcz8GoLsU6y6r4nIMMHpRVNDDAcQz/m/dEYqtlsMkJcvWHgkRfgfFUrcc3HKqQpYLMQkfQ5yMTjs7kkHbhV/GQvLRJ4HzX3JlBQPnRBM0Oid9Doo72XhaZMZ+yPZfJ6ZUcLa1npguVpDbQGtUwtEfgLSAc3erxl4hkvjRgBRk32j+SROu5sNXJnggHIb+6GSqd599hqbGsmf+x+/2cfIhGHFHYFXuJ8FR9GTb5PCAm/MFLOZYh94/UCqci96sANLtQK8VqH7CsQL2CXisc8r2yjhLFhxyzt4NEuICsWNoddPYm7byDBdZTua2NRmKmQLLBzXPG3nrjt6SRLkotc4/qURUSlF3L9V0IXqEGe0iNtkMd93OBSEAPVnbDa5hhryHIl5zILpk5p+KwZCe3B0hF+p0aYZe9+QnERrzPXmTWx+pE49Z37qeBN3RJ0THaYZZmxRMvnfip+3mG5I2V+F40f9lMPiNFOJu1B8lXE76tSSFOYsP7fxEr4XblbmdzvubROIK0YARCzRPqYQdS7IV9YWci0thzSLzR0fRHzJmnp+0vSvyf4mfpWpCNgdEluR4tEY0SsX/AwEXL7n3IS8+D+KTalMVEZ66DaHVW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Gary,
Thanks for the feedback!

I've actually already sent out v2 and v3, where I dropped the
warn_once!() macro and switched to debug_assert!() and pr_warn_once!()
(gated behind CONFIG_DEBUG_VM) in Vma::zap_vma_range(), following
suggestions from Miguel and Nicol=C3=A1s.
You can find the v3 thread here:
https://lore.kernel.org/rust-for-linux/20261126145257.192636-1-mbkcheloffic=
ialdev@gmail.com/T/#u
Let's continue the discussion there if you think we should still
reconsider bringing back WARN_ONCE!
Best,
Ivan

=D1=87=D1=82, 26 =D0=BD=D0=BE=D1=8F=D0=B1. 2026=E2=80=AF=D0=B3. =D0=B2 17:4=
9, Gary Guo <gary@garyguo.net>:
>
> On Tue Nov 24, 2026 at 1:51 PM GMT, FUJITA Tomonori wrote:
> > On Tue, 24 Nov 2026 15:27:07 +0200
> > Ivan Tverdokhleb <mbkchelofficialdev@gmail.com> wrote:
> >
> >> Add a Rust counterpart of the C WARN_ONCE() macro. It behaves like
> >> warn_on!(), but additionally sets BUGFLAG_ONCE, so the warning is
> >> reported only the first time a given call site triggers.
> >
> > C WARN_ONCE() takes a format string. This macro is the Rust version
> > of WARN_ON_ONCE().
> >
> >> The macro returns the evaluated condition, like warn_on!(), so it can =
be
> >> used directly in an `if`.
> >>
> >> Use it in Vma::zap_vma_range() to report an invalid range, which
> >> resolves the pending TODO there.
> >>
> >> On configurations where warn_flags!() ignores the flags (UML, ARM and
> >> LoongArch), the macro behaves like warn_on!() and warns every time.
> >
> > C WARN_ON_ONCE() warns only once on these architectures too. I have a
> > local warn_on_once!() patch that does the same on all architectures.
> > I can post it if needed.
> >
> > Also, this patch does not build on UML, and test_warn_once fails on
> > x86_64.
> >
> >> --- a/rust/kernel/mm/virt.rs
> >> +++ b/rust/kernel/mm/virt.rs
> >> @@ -115,8 +115,7 @@ pub fn end(&self) -> usize {
> >>      #[inline]
> >>      pub fn zap_vma_range(&self, address: usize, size: usize) {
> >>          let (end, did_overflow) =3D address.overflowing_add(size);
> >> -        if did_overflow || address < self.start() || self.end() < end=
 {
> >> -            // TODO: call WARN_ONCE once Rust version of it is added
> >> +        if crate::warn_once!(did_overflow || address < self.start() |=
| self.end() < end) {
> >
> > Miguel said that "Erroneous Behavior" cases like this should use
> > debug_assert!() plus pr_warn_once!() [1]. Also, the C side uses
> > VM_WARN_ON_ONCE() in __zap_vma_range(), which warns only with
> > CONFIG_DEBUG_VM.
> >
> > [1] https://lore.kernel.org/rust-for-linux/CANiq72=3DtKVD13GD2Bzmt_LnC4=
SiOX1nkHQPcz2BS=3DP=3Db23e0Yw@mail.gmail.com/
>
> For zap_vma_range I think we do actually want WARN_ONCE. For something im=
portant
> like zapping a VMA range if thngs are used incorrectly we do want to figu=
re out.
>
> A debug_assert is not as useful because it's not enabled on kernel shippe=
d to
> end users. A pr_warn_once is not useful because you don't know who's call=
ing the
> library and causing issue, and also a dmesg warning is mostly ignored by =
people
> like a WARN.
>
> I think a condition is unlikely to be triggered from invalid userspace in=
puts,
> and the misuse is actually a bug, we should prefer WARN_ON because that's=
 how
> can get things fixed.
>
> Best,
> Gary

