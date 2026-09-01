Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BC47C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA266B0152; Tue,  1 Sep 2026 07:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1DD6B0153; Tue,  1 Sep 2026 07:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6FE6B0154; Tue,  1 Sep 2026 07:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34E2E6B0152
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:49:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 218BD802CC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:48:59 +0000 (UTC)
X-FDA: 85165021998.23.B71C3E0
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5F28220005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:48:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RPfLq8Nb;
	spf=pass (imf31.hostedemail.com: domain of trintaeoitogc@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788263337;
	b=NuVn+PevELYdHr+ePSxIstdMlG5pgYsGsLRn4WnjxnrL/48h64R8Gc4YdPAKYhBi4Nj+Ge
	en2t8asW+hpzUXGZOaKixxht4tnj8781TbE9CJqqwOXqrCnVtD3nufGNEmevdXaQlt9FAw
	e7DnbjVKdds9kr04DTb51c8fhqJdETc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RPfLq8Nb;
	spf=pass (imf31.hostedemail.com: domain of trintaeoitogc@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788263337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejUSHiFxX4WgJYi/9Qrca3qXd7EjxgH/hPKoCC8GwYg=;
	b=Db3/KyPasgrVa268ABHC4Cax/o00BDSF2jxSZFDKqK4HdyYQcsprXZxoLwe7PXEuySvdTM
	PQN37jo4DxNK07zbFdIhv94J56U1U7tTJJecQrTg1AFL/xeE3LIQ879zERRyqI5e1iRdcH
	u3STnMk3b9gpi+xh4+QJ4MFyZrZOz+c=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66e5e33a9d0so1140543d50.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 04:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788263336; x=1788868136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ejUSHiFxX4WgJYi/9Qrca3qXd7EjxgH/hPKoCC8GwYg=;
        b=RPfLq8NbyzOmOCj36qrKIvSWgRXjSAvjLCaD6xDd0Vwd6Qi4Or+qO/j2XIfobdlyP2
         nQ+CDiIQR7dycy5kDTLQOkliIPu2A9vKMCTUX+Aau/+PKn7PKNwN6m3stIx4R65VuwtG
         09cRVTmA/shbHGlYRWOOEj1fwoP5IeHEQUN/TtjcA2AJ7jYZHLiubl3mSQsDM9oIVkNl
         M3TDmR+I1JA3ePM0F93wB4eSNJ2z5RY6DD6aHYdy18lAjjafJml41zhg1g588L0vobJv
         Yz2oeTB5QAAjWngqvzfLZFq0tFyTPMbOQBpHt5pwxjVvRHPO1w+5GyvdcQB87bF/G8Zw
         NN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788263336; x=1788868136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ejUSHiFxX4WgJYi/9Qrca3qXd7EjxgH/hPKoCC8GwYg=;
        b=cAbyIPA80p7kl2quhdv6fQXF1YR3FSjA74nrEnhNMzu7lpP78rrtwtvb/npFQ2qVaF
         wfuL8+W7N/uDhqplnrawk/sMF+x3n5BzlJIZ/rOFQqkHgU9iWMsIXyANW3i4KiViMmhS
         a2hwXmlU58kW5daKi5EylFbTFCYoKTBoqtnKtbavpiaDYV3Rw9XkLWegQebDiFkFiWJ8
         Ohf7SUhXEhBCkovl7RsmgKyxczJ+bBBZmVYbCzAGO6dzCFLKAyvISk7KfBvLHyIvWzNP
         47KRyWTaJo3Lfxyy+HVx3xSnk/nRQCP51uiYkkxPArIVDDNUCbRL2/BXFPmn/c5xI/PZ
         z2Ag==
X-Forwarded-Encrypted: i=1; AKwUvBwUVhFcDCP59gasWPm1PXf+NhPqHnHlfdiyMRx6kjmjv6Beu3MiqSdbh6sMz0nOd3dfvxRSq3prlQ==@kvack.org
X-Gm-Message-State: AFuF++m3aMDNaOLyI0XEVgYHcARsAdeUEnVpjNyD2KTbYFtlfJyZVrXU
	v0nF+BWHni629JsEJ58hwYMSiq72dtAg5NL5geVW/so6JP8KmH2yYrLc
X-Gm-Gg: AYBFou2CZSs2ENaDu9ZOlg807Y2PdViCDOtF0yFoHLVTP510igV0iXotuG/X8VLi+9V
	/N/r0LFkIiDUfNf80a/4SZeCwrUf9VGu2/0OEz8MLNihRun0W7YVA2BKLiVUr1S9Xnuv83w3/No
	Xs4AvWOET0mte1vDDEe0q5xhUyewn40iaAhOJW7S26dzbI94PsixgHd119fgbnfDjhD3pPpOTWL
	q14czx5FS0nvWvGbghicuh7ybXwMn+rugb0HjBoReDHad5JwyL+u91mVq+9ab/Qv11BiUGlRv3a
	aHuak7pfykxMTuq9QHbBq5vvbvoIh9keRjJkMSFsjHzjYw25j2JEx+rNmW1qFVMv79izUgEusL7
	x0fbp1K6A7g7Ao6sDuuNsytsjUQ80EtVoaUapS97QQFYUzEbSH5IAkDQvf+xA9zSdG8D889H70z
	CbwMi10mJj364+H3jUMtjJ6Ay8XrrYaGc+yMUmRBnXTIpIxZHclEuF9grGk4pip/XA9qJdI4WbJ
	A4+ul5cR+ussy/KYJN7fnErNQZl/LkzcMiFBMaPzXXd
X-Received: by 2002:a05:690c:6604:b0:80c:ebd4:762 with SMTP id 00721157ae682-85d65ee75fdmr133413267b3.7.1788263336196;
        Tue, 01 Sep 2026 04:48:56 -0700 (PDT)
Received: from fedora ([177.21.143.191])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e679512easm71847747b3.48.2026.09.01.04.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 04:48:54 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: pfalcato@suse.de
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	riel@surriel.com,
	rppt@kernel.org,
	surenb@google.com,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com,
	trintaeoitogc@gmail.com,
	vbabka@kernel.org,
	willy@infradead.org
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Date: Tue,  1 Sep 2026 08:48:42 -0300
Message-ID: <20260901114842.26532-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <apQxGMgLWWlfn3cd@pedro-suse.lan>
References: <apQxGMgLWWlfn3cd@pedro-suse.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hyuu4yqwgjo3ckjwjpb31jconx59hku5
X-Rspamd-Queue-Id: 5F28220005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788263337-38006
X-HE-Meta: U2FsdGVkX196OBuPnCQcCDfJf0HKL6p97e0W/i4F3by7S4OWU5Y9EldGUSNW30UwX99OsaWCSmE3KWmEfGVaXPgfMerib2ND0Lp6ibisLjM5YgnDUxwPwCCmXeackHLMTFnEWwZD2OSWvSGdu/Cvlm51d9bzERM98KhLgI2c3cKyGxWRr4yfyfprzEc024dFXQskzjC70mghJtgx3gd64USfBm/mr3PTPXgwVq4sniAVr57M2DlHPWgWL1m1Zn6tcUOMZVeuh63fjjKoHcGVrwPNDI3XFatLKH5Q2t9ui4qfKRmC6BEGYJ940RauGc3aWjc34xJbfA6fTeeiIH6glb1MBUtKogUnskUFweV2q49flL3ZzCsLBXnq7K8kBhsPbdZW5rEfcaT5qgodm5uelUbg1+ofJu4pTAJaJSzNDKeVNExY+J15wXjjL/S5cs1/mw91bwgfwsf9zoiaz0klSfjP8jssnDjx6nVtE2M5xzLHvygNCq3gioARISUbaX++SDF2MNd3lgKWVUCsRJAKUs38U9SON+JAFJoqmlR7pRnXR99ll0JIQu7+Tc6QoHym+Ntu7QKzlRGA9ObR7V4TecXtHVfvXXTzjqshNzXs+FLjQbmlDSK5G8ZC/fxCDYhdaE+JfiZWawa/gibaQXgELIrnptpaW8ITEgi3sq7Z2mtiMWD85U9ikxRk7YJf1D2Q1mxH4U+njbRk+l7i9j5GFxFJ0uoBBeJ98/uaDa1R0e9Vapwt8wH8jcowRK7BDjaHumjOpR6do1pNf0p/yEHVE+k0xh0YciCVQyeC5FJdgESf+OslSwIH1lQ310JSIw+i+KHDHq6JDnxXR1P9ffcdGkaCq2RwHSPOxLe9J84CEfxFHETZ8K852ZuQIzt3+v+i5cG4+0286N07n+r6TxeaGU7E2T0UfTIUId6H5Rw+nmVNVs//z8QFgYl6j+SJJQHkqnrHv+ryE24aWhgxZ8X
 ob9BsYdY
 01XSoRiLuNe0ilwH97lavcrDjWJs3jHtErBJq2BQu4e1XB/qn68uypELtEKaldwqIEpY5K7BP6uCGIiWTa7BgmFNj1pjzH9DWtrMcwjLQaZwxHlXOe8w6fwdIGYdewdr3JAwzpQkC9xlckvZiZoXUsYxOWFFdIlAeA2C5uz+Q4cJvWAXomuNSYRI9OKawpNY7NUjLVx1teMFXNkWYRIrKiqcBirVdbwfCFaP67/3SdZ8fpclVfyKz4JpdC+2cEuwoFAsH5kNndRE6O7nuFA0M2jIm2ZUds+3MyUZMJ8RUfHLWF5q6hbucLlSeH6mLHvOiB8DWpxSLX6DdRnRy218pdrrRwZETUb/a5ZaHOfSmUjNRaWhbRZc7qzo6K6M/59ybfI7EyXc2qm9iLwt+dKmCz0Z9PXLbfCCOVTeMqy5wSMH4roXNLHDq11Lmx79Mf4/ugZSJMYdV0HGW7fx6CrlHU4RMc2h3+HbQHbgkyT7Ija7z+MGAxESfzMziKFGTMcG41sr0cbE+gAz6RJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please, forgive the delay. I really needed spend a long time to understand your
explanation about why this race is safe.

Pedro Falcato <pfalcato@suse.de> wrote:
> > > So it's inappropriate to use READ_ONCE() / WRITE_ONCE() to "solve"
> > > this problem, because we don't need those semantics.  It's sufficient
> > > to wrap the read side in data_race() to indicate to KCSAN that we know
> > > what we're doing.
> > you sure? 
> > 
> > the __anon_vma_prepare(..) is write on vma->anon_vma and the
> > __vmf_anon_prepare(..) is reade from the same vma->anon_vma at the same time,
> > you sure that is not a problem? (I'm asking as a curious layperson.) 
> 
> 99.9% sure. Here's the basic logic laid out:
> 
> 1) Fault needs to fault in anonymous pages
> 2) Fault needs to possibly create an anon_vma
>  2a) Thus it does the lockless check, where indeed we only
>      care if it's non-null or not.
>  2b) if the lockless check fails, we get into __anon_vma_prepare()
>      logic, which crucially takes the page_table_lock to write the
>      anon_vma to the vma. If it takes the lock and something is already
>      there, it backs out.
> 3) Now, into the weeds of anon page faulting, we end up in __folio_set_anon(),
>    which reads the anon_vma from vma. This function always (AFAIK?) runs with
>    the PTE lock held. Thus we can be sure the anon_vma value is correct. In
>    any case, we only need to have held the page table lock once in the fault
>    for it to be valid; any change to its value from non-null to null needs
>    the vma/mmap write lock. Because we take a bunch of locks and do a bunch of
>    stuff between that initial check in __vmf_anon_prepare and this, the compiler
>    cannot validly cache the load (which can, in theory, tear).
> 
> Now, for memory ordering and its wonderful transitive properties:
> 1) writing anon_vma takes the page_table_lock. therefore if you acquire
>    page_table_lock, you obsreve the anon_vma store and all preceding stores
>    (due to spin_unlock providing RELEASE semantics, and spin_lock providing
>    ACQUIRE semantics)
> 2) say you install e.g a PUD entry, you take the page_table_lock. So you fully
>    observe the anon_vma that was installed (by doing an ACQUIRE on the lock).
>    you also issue a smp_wmb() which makes sure the ptdesc setup is visible.
> 3) others using that PUD entry will (should?) transitively observe everything
>    you have observed, data-dependent loads will help you there. If we _ever_
>    observe a page table without seeing an associated anon_vma, it's broken.
> 
> [Yes, I spent quite a bit of time thinking through this; it isn't trivial to prove
> that 2->3 transition is correct, but it looks vaguely _handwavely_ correct]

So, this race condition is safe just because the ordering (very briefly):

if `if (likely(vma->anon_vma))` is TRUE return 0 (OK)
if `if (likely(vma->anon_vma))` is fail __anon_vma_prepare() is called
6 lines below and inside __anon_vma_prepare() he try to get a lock
`spin_lock(&mm->page_table_lock);` that have ACQUIRE semantics and ensure the
ordering mapping...

if `if (likely(!vma->anon_vma))` (recheck the anon_vma like __vmf_anon_prepare)
fail then `spin_unlock(&mm->page_table_lock);` else alloc anon_mmap.
	
Thanks for spend time to explain this in detail for me Pedro.

