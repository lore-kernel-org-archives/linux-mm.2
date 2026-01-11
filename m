Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1028FD2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 19:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1F36B0088; Sun, 11 Jan 2026 14:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034816B0089; Sun, 11 Jan 2026 14:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78AC6B008A; Sun, 11 Jan 2026 14:58:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D65A76B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:58:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CF2C1AE6C8
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:58:19 +0000 (UTC)
X-FDA: 84320744718.13.7D7302E
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8C8D31C0006
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:58:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vpiyWZHO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768161497; a=rsa-sha256;
	cv=pass;
	b=omMrqZ9GO/WWWUTYsPqHmIdJuYvS9KCkm2q6mgV6qRLQuKOLtbnqvMHgSJWNmO4PDTePYL
	jDFpPnXc+pODum+TYOyW+Cn4tFD1g6/kxIoGKkHyzCTOUm5jJAngKnG5GFl11UzXbja3XE
	eyvxWNHoyICCYzruKUjuZTsiTKwn7bA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vpiyWZHO;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768161497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zh1Ea0sfF4/38JW+s4dYkrfqw9VrXtKXyOq/yVBUD38=;
	b=46audcBeMJzRQXausC85+wrPBwhwkNMoDjp10ybGrGBAHwtR76Qm0CcemqrhJjLjVXKgdP
	QwonMVyexwicDvWVy+b2MntWm6ABeBscEB1iyzANRGTbn2f+mo7FDDqKvAoKddVW3qgG6L
	SM29oZp8oBPFT6Sbf0i2rfp7GoKfj/M=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee147baf7bso560281cf.1
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 11:58:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768161496; cv=none;
        d=google.com; s=arc-20240605;
        b=WkSobmd8dm3pnc7B0sRVzLLST+CxuQSU18a/niAaAOCbKHtfOW5AVkKq/OBDLMwHoU
         KQkJmp4hEYCncJHf0R6ff6whedB3KEDlcp7HxmztHifOHNMj8SaKIHQ+Qd616kJx5F06
         0xQR5xK6uWGi9ln0HIUObxlPuTc7nFvLPXRBPSynPsXfgj97yM+U4spzTNrXJ5rBWejw
         BqVzXoLLfdtdq1z6iQf0ut+/XoFMFqbiGvT8X1Oe2RXc1jnrSCPGKiPi9AgRPo4o+j+T
         XCGmvSMHglhNugrLFDO9XlV14Jt752DF/gjM5N96XQMOUey/gUDpm97QQQG9RbMkK02P
         zjew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zh1Ea0sfF4/38JW+s4dYkrfqw9VrXtKXyOq/yVBUD38=;
        fh=FPfKdhyldA1zSh8mvhSg0pm8MFX9ibTysrBt8juVi9E=;
        b=SSOiRPmnMLRMtqX2F85uHgn/CgGQUOFUYiEGhVfJCe4oQigjzaOp5EWVDQiltiwscM
         KCG8lFMr22OGJkfscURO8x8pPrtlsInlizh+xDMfMBZUqMTq/CpeI0L27MbRkfLg5lCN
         +tBanQ7L9YsLDN1RgqrE44JAjKfzdVylkzJ4eJuwyDX+Tz790n/Ec/pMGNPrAKhcHWnw
         PToWfZSfojv0+8CYpBpGJFkm1TAnp19bvDQp7bdmLVBemyuQDj1n4q5HOO4RrrgQ81dP
         peHYDEhWriH5nXTY/0DVogbWE2NaTBA2VwcQhT6ZnnMqetk6PrMIPrtbGXV6ia0QHf7e
         E7BA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768161496; x=1768766296; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zh1Ea0sfF4/38JW+s4dYkrfqw9VrXtKXyOq/yVBUD38=;
        b=vpiyWZHOaL/qtfHBxIJ3/jurauSiDQaQ7dGfzjIXFWkczBMn0ChrMrR2K535HrH459
         t5Q/4kwT+/P4iQCDRoLjjaLt814c67kJCkm9uki6DLngZIi6pyqZA4y7PqcJdoC9LXu3
         84G62/dUae29vGmTh+YHPHDIUc3rRpdmg3B8lMuEIt16jwb6gotaq7SVyPemGbM9BTpl
         oWDNNmkWoiVYCCY0JJ/g3ue4J11AsCaaqzzpib8Y25TMvGnuIPh+DJi302MQNZOlJAIN
         yr/5Uw7k9+1ESJywUigYMIpyWS2kOp0F4oPRa1TJ6grAoZYuoPqO/QV27s62sIGNULPO
         hlYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768161496; x=1768766296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zh1Ea0sfF4/38JW+s4dYkrfqw9VrXtKXyOq/yVBUD38=;
        b=nSZBTY7m144Ray+g/pbQcLNN9DLvGdA2DWAHwu5tvb5k2GpdnvkpXO3ifu5qqAPZVh
         Ummi02xjSuoKiJU6rOmmi1M+DhpEqQD84LdXNepCBwL/f7XN6i66XFl8k3XQHFuxEdMg
         XB9ss3S6Oh5NiAbnIxoJWBSmnm1WQRQDvpdKkQg5m5TBlGc3+2PGQK2sNJEGYVt0JaDv
         Nm2WhLi6C025Pwi2lmDAMbhLwqQeHwSiiE3vb8izb71qTypvXzlQpV/54PfLeI0RlP37
         R12W/21bEBOCmHZqustIzxXzxHkxvRfqEyaufoaJG79Q0KJYi16wKWg9b5gt/8HqIjWQ
         VZ7g==
X-Forwarded-Encrypted: i=1; AJvYcCVbeJQAXV4lvYkeHJFPsPi4yChtgn4RTp3nPtRG87RDx8T4/3p/EhA/mA/u1ygiQ5MQTsUhUg5e9g==@kvack.org
X-Gm-Message-State: AOJu0YwiC6TnZHYeqX0M+v+2MtDQGAEur428rmdKFl/xcGqIlmtlDBGU
	VwYr2eJcJRtZIm7GZpIxyGtyrP8P2OpmSY/XZaXbWBQB+6uUwh5di80ZA7Dwwd2+vUBZrshqekZ
	2TGIPxdBmlA92WeJBdwe4uol0z5EITsGsEyhUjXH7kNozNqAOCCi4kL2y
X-Gm-Gg: AY/fxX5LlIHIAPDY2ZplwEnnZrd8iEzm+tfdoIxEjk/yL4sFhYKt/J66rvzcUEuZw6p
	CBT1mt463KrHX64fCitgimPrvx/IvQYHNYeOjux6G9smB+MeF7r4slq+1JXPBw3csTA36CAh8ro
	BINhgUK2c40ysAP2WY+8zuUwjmWCLY9ST3rKLzQcyXHHOsrwWzuIcVl5Cq6mmoDYJA6/sxZK63G
	rrUwJ4LwmucNnIiegffuFeT/1GoyidVfBUok6zH+iLx24UQKmJzG7ylSLY+ahGaBacfZw==
X-Received: by 2002:a05:622a:154:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-501196a752dmr12278101cf.1.1768161496290; Sun, 11 Jan 2026
 11:58:16 -0800 (PST)
MIME-Version: 1.0
References: <20260109104251.157767-1-ranxiaokai627@163.com>
 <20260110162843.ecd8e731bdc281f4cd8e4764@linux-foundation.org> <aWNpTnZKfjb6yLHp@kernel.org>
In-Reply-To: <aWNpTnZKfjb6yLHp@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 11 Jan 2026 11:58:04 -0800
X-Gm-Features: AZwV_QjBBqi5O0NpGPsTawGom2tk53BMZOdWMw0CfFJcH1T5LPOizAOCapIckHs
Message-ID: <CAJuCfpFW+o9LR=VsCPX1XONb859G0QshWyK9NmCt43JEk9+HKw@mail.gmail.com>
Subject: Re: [PATCH] kho: init alloc tags when restoring pages from reserved memory
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ranxiaokai627@163.com, graf@amazon.com, 
	pasha.tatashin@soleen.com, pratyush@kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mhs9ru9fqdhbbuuxfp5s7asnar15bzyi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C8D31C0006
X-Rspam-User: 
X-HE-Tag: 1768161497-494439
X-HE-Meta: U2FsdGVkX19xj/Sl4WbKgNbQAqF7bc5Nkyuo2FdvuW0HlX6EOykYyh4utHzL5U1dCoGQJwaP18fCmzbEP+ZSwS7XQFsO0GdHwHLkFrFXZR6HGgWUf2cJvNoTRKO7Cm61C+h/zxXghLX9xgCS7y9cPI6P0+MdIq3ZJaTaNDBMS+Q3xFm9M+5Uj6AWdQy6MVSej6TTViqpzmWCIxVtc8eEZzSWJs6Yj13JbO2pBkwfSTw1CO7tkkPKVSspvFPfDN1n56Mr8yL3fQYwLNfqU5ma7GEoN5CqnLqvpW02ZjzBBLQIcHIiTNFw7sPDFjGrNmyEhgUi8uc+zykkYZAqqZ6LBPFhqAOUURV8sumcFe620XKbpUfglt9RSy7i88oyw5ehWfANcw/CwxcgQkym+gpapE4clyLDSleKouUaStfY83sLmF/WA9Xs7MRx3MwmP2e16VyD9NCDk97skqKu09VY3lBbNiCO5h2Q6t/xn/4fEULE152HN/fDVoShe/F4MvEb1AnrM/XIBZPs4bxqPjmcBeD2qIjT3yVmX3kbwGlXMAGubjJwk2tsKg5R6UQGAkHWjG9j1NOUcUSgpxyNkfEkRPXDKKYkhp3i5BEUSAZTHYo8pjlYKaif1c3D9AeCi1mtdIe1bmh1RCTi4vJbR2X6AABVXjVM5AWGQ79mr8uTBdf1pPb2wyo1Uce0myU12wP6E0pGahJkKPaPmEYsUPEGUOXSBTt6c9MyFXxEjY8D9oTZb/QGvM1y++nzBCFABfyFagBnvRwUOaHQkV59cS1kD4Jnj9qJInxaLIpXYxbXpUiuBd+wJBZ0SQZmAh3qDff8MvTvmJitQDDbHrTkfG+3MGry+3A4ory48k3o2poIaesUep4YXmYXASrIwWCt7UHgimjhFCUk8MgRynNOW6ADctu9/9+SMwU6B1X3ngeGu7kb/908OgtA4wGb4fU9v1OzH96AbEkkmbmwz7tvYmD
 Bck6viaF
 mZKBYGOdO8Rbgv8rkJh1dRjT1VH2TLatiweEylMDlZj4chUcKtY5HZov1YeZiP83IuoqN1aH10cO9t2nxtwatvQSQRdF0NWQ2r5zS/SQ7YHJwG2UZm9WoHVzCJO3iXiCWimjp7qz4Ikv+mAZZFoBQqw9BXE/J3psK2waG6bKm1gpDYUjvdlfkztmKp+v1Nz2DFtfepbfuLauWiOE4ipPZymMwRXxigD/TVtQn/y2T39eUYDkmZPtCOlb8sIDrN5O+g1HbLaMTYIw6uefCdYjvr4EruT/k2sz1Nv3JZnZoLvM/OIunOkLFwSW+M57qGwml31aiAas/9aittEgI8vSZOyNJPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 1:11=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Jan 10, 2026 at 04:28:43PM -0800, Andrew Morton wrote:
> > On Fri,  9 Jan 2026 10:42:51 +0000 ranxiaokai627@163.com wrote:
> >
> > > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > >
> > > Memblock pages (including reserved memory) should have their allocati=
on
> > > tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before bei=
ng
> > > released to the page allocator. When kho restores pages through
> > > kho_restore_page(), missing this call causes mismatched
> > > allocation/deallocation tracking and warning message:
> > > alloc_tag was not set.
> > >
> > > Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> > > fix this.
> >
> > Great, thanks.
> >
> > It would be helpful to quote that warning message in the patch
> > changelog, please.
> >
> > > --- a/kernel/liveupdate/kexec_handover.c
> > > +++ b/kernel/liveupdate/kexec_handover.c
> > > @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t =
phys, bool is_folio)
> > >     else
> > >             kho_init_pages(page, nr_pages);
> > >
> > > +   clear_page_tag_ref(page);
> > >     adjust_managed_page_count(page, nr_pages);
> > >     return page;
> > >  }
> >
> > Warning splats are pretty bad and it's desirable to fix this in
> > previous kernel versions.
> >
> > To do that it's best for us to identify which kernel version(s) should
> > be patched, via a Fixes: tag in the changelog.
> >
> > From a quick look, it appears that Pratyush's 12b9a2c05d1b ("kho:
> > initialize tail pages for higher order folios properly") is a suitable
> > anchor, what do people think?
>
> I think it should be even earlier:
> fc33e4b44b27 ("kexec: enable KHO support for memory preservation")

I agree.

>
> > Meanwhile I'll queue this up for some testing while awaiting maintainer
> > feedback.
>
> --
> Sincerely yours,
> Mike.

