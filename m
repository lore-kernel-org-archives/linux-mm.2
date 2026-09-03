Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA8FC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800B06B0092; Thu,  3 Sep 2026 10:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9A06B0095; Thu,  3 Sep 2026 10:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7155E6B0096; Thu,  3 Sep 2026 10:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D95E6B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:46:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D50411C2143
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:46:28 +0000 (UTC)
X-FDA: 85172726856.06.D9D59C5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id E6C75160006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:46:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hjTRzTQh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788446787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzFgJX8L/F/3g4+vyWfbofjtk1ZS4BnMG0fV0edpcNQ=;
	b=0IOca33nItAxsXQ6jFVZVMj+i4LFNGlE1UQYa83X62KlQgJsPwjXxwCxKxvme/lhA4OEmB
	GcSe3DY9SLSPIV4NvK15gbPp7VbpAVWCvcefAYMp8USzR+W2F6D4UT083c0mcWc3s/hCPc
	7Dlv6afCpzdEWbWl9e1M9zjeFqONfhs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hjTRzTQh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788446787;
	b=gD+a9kYzQ3T+P0oQzBd/9fAX8yB1PDq5zvCk6yclVadbNtGW+2BawbJgAiYvHDjPaDgTnS
	VJ77yFIFNvDoM/I2cVvb8M6hf2BdADfPiTLf19fLJvCOZjOrrSzUYPUhRsrO8REjPZM45z
	8D9xGowW80qMGcmr46ZrbajKtedgHEc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F9C11596;
	Thu,  3 Sep 2026 07:46:22 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B85303F673;
	Thu,  3 Sep 2026 07:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788446785; bh=V1MYFobTbnEL6kAKgq5oSPS511/yGOzsW7VYGNkNJwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hjTRzTQhrGrGXreHhtxzCPKMstH81ZqdFJXMiKKPaDbIb3cfqd/mUIbc8mHYsyvG+
	 l/csTpx224sNXmdPeUtQnRv+gAKk4KvRfV22L94ohNMBv5aFPnJ64j9rkmfIiyawDk
	 m3Y553UojSQDz8Maps8tBTZWJnbrs7byvOigk6EQ=
Date: Thu, 3 Sep 2026 15:46:20 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	kas@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Message-ID: <apmIPJKj7JGwF7nz@e129823.arm.com>
References: <20260902175611.1241118-1-yeoreum.yun@arm.com>
 <apk1WVEDYtQhRxWR@gremlin>
 <aplcf7sDnfKQTYo0@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aplcf7sDnfKQTYo0@e129823.arm.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E6C75160006
X-Stat-Signature: 13dj67ypq566fattyd6npojt1wjzr4jd
X-Rspam-User: 
X-HE-Tag: 1788446786-700369
X-HE-Meta: U2FsdGVkX19zS5lZ9bM028EgZ8AnmGj4AQ4C3Zfr/OHIsxNgreJuHyIdIrPu3wpbGpXwgMQCWFu0BsyUw2ilNdNhSO7sqjIM2XROXeheCpj7v+QYMz6l3d/dq+RU+eeogBgCG5EYwxOWtm8pELJlto9xzFfEvcl0yxS/zlMVA8jONRbk7tWZktHNuopOXlPTUy2IGAL9czi9jhRkpsdKmZ8MV9o5fkQJMFI0lWqDRM+mWXj4AMOh2ViMcUra8nilQFb5A4l83lctS2tgFpA+ScUEDQfEDzdg6dX866WPZwamTcuU555TNT5DgdGK46h/9D/LjVB/9aoM+3ljKUXN1NRk7gtesHEy+dvrbQPnvYP4T2pfonMVLhRkj3Pj5/fAhFyijIlWDntP//hy5rqSV2tMUj8aeC+0wvtih36+cfROlB/MzSxrr7dFvVRL2q8R+pie91+mxxpbeaRfbusDu4EfnkevGReEu0xBZbQvfR2nWA5DfHZVtg6nAFAeN0JuxDZ/F48ejXbPenrqgStmokUUuQtMqX/zGJJW9yUxqu9KpGLvcV5BINarQpSsIiyE7y5IE6d6ImpJ0pKuKSAwB3IBfur6MWaa5UYDCEWsGnV1OQKInHamVkvOK8NFzJba+UaR82Xb1XXBC/tyjAlXzezCiaalcL/5n4jechCTz3dmG395nmhzyrv29k172GNsBSyqfsUQtE2f8SyGQosh2dugJckmEsIZBfzE839sDYRD53toM3YluUZaybHgaePl0CdbZvfJXPkTgl/Sraic7JggPs/FfPSnryPXRxDoUm+vhgeBAzpRzKmVaOCh9ClQAudaScEw1R1eVYCJln1QEfopxpaZNeQstiba7gfr+ZqNewxtWdAPMze52x9G5HZYzrQAe1/y4US7V9IrR28r0wG03OE51fParncja9IWs1P5kpRueRQQdxbg4/70r9GB1Z4+7MW1DqYq2VNNyAc
 5ocGaIJf
 qqlBfxhX1A3h+/8Y101sqfPFyTDjRAvaM93hV2pu3MMPtUFDQ5BJuBK45311ssEN99Y1Wz3TXwlmiIN/aqLLGIa/FXakniupidWZrMD9WyMvUT6UmEjhIqriv3OaeLbMKhVS/F0m2f0PEWm6nMhLfDQruNqia9rTj2MG16+cj6+RzXV4q06rLPqECBLD76F4xgaA47FwfUoQ6L06Smsv9X0qWKzIdUc6SIMVc0Q6TyYA39Xhvjcq7FOSh2IHg3HLq+ikjS7AS5OdmIlJojZeTpKrG4A7CA5hYb93O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > On Wed, Sep 02, 2026 at 06:56:11PM +0100, Yeoreum Yun wrote:
> > > HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> > > When this macro is used in some test, test result would be strange in
> > > the system where PAGE_SIZE is more than 4KB.
> > >
> > > Here is example with transhuge-stress test with 16KB PAGE_SIZE:
> > >
> > >   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
> > >     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
> > >     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > >     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > >     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > >     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > >     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > >     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
> > >     ...
> > >   ok 1 Completed
> > >
> > > Remove the HPAGE_SIZE and HPAGE_SHIFT macro. and introduce hpshift()
> > > helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-exist
> > > helper, read_pmd_pagesize().
> > >
> > > Also, do KSM_MERGE_TIME_HUGE_PAGES test with size of 512 MiB which
> > > is the LCD pmd_size among 4KB, 16KB and 64KB page_size.
> > 
> > Probably worth spelling out Least Common Denominator for those who might
> > mistaken this for a kind of display panel :P
> 
> Bad typo :( LCM (least common multiple) :(
> 
> > 
> > I also wonder if it's worth pulling that out as a separate patch in a series for
> > better bisectability?
> 
> Okay. I'll separate it.

Hmm, I think it would be better to keep the change as is, including the
updated ksm_tests parameter. Although allocate_transhuge() correctly
allocates mappings aligned to the PMD page size, `ksm_tests -H -s 100`
would otherwise fail because 100 MiB is not a multiple of the PMD page
size.

[...]

-- 
Sincerely,
Yeoreum Yun

