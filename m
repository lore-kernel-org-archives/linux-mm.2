Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9BBD31A05
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E526B0092; Tue, 13 Jan 2026 21:41:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC746B0093; Tue, 13 Jan 2026 21:41:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822296B0095; Tue, 13 Jan 2026 21:41:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 710196B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:41:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EAE9C187B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:41:14 +0000 (UTC)
X-FDA: 84329017668.10.7574B50
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4AD8E40005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:41:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768358472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvfiCd3ivoDSMe3z/hKKpRN4L0qW7nEB8/kWfx/5Nco=;
	b=qBxtJzf8PNX1+VRCPOQRn5AOsNljQCcEvWuLb7v/Sy4W2AqDN9DCKwLihykSaoJM26w/99
	MvtjHFtCAJZ4xQI1Lk6iZuCzZmS2SMnt1H7tfpdINhI1fHEeARPACr5myQakBdEEGc03gn
	CaLhJMoYHzEC5UTUeaL70WyODJrofk8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768358472; a=rsa-sha256;
	cv=none;
	b=geYZ3dq4fq8V3MAgTRXB4Ky6lC4oRjdy2Mi9nVYdrGfvF8YukjfozQ1PtC/bTjZj+5DuT9
	D+0iFSVPxRdlB6Skgd0AP1kpxqJVE46cdncIsZ24Swi1DgiRbePnojMMNxOwajzrWy9sIG
	22N0Q1cUGE912OcqxR/KS7ps64YH6vg=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4drVjY4rrFz5B17g;
	Wed, 14 Jan 2026 10:41:05 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 60E2ewXv069588;
	Wed, 14 Jan 2026 10:40:58 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 14 Jan 2026 10:40:59 +0800 (CST)
X-Zmail-TransId: 2af96967023b43b-6bfe2
X-Mailer: Zmail v1.0
Message-ID: <202601141040594302w9Pnbc3vzQLMkh8bQ80D@zte.com.cn>
In-Reply-To: <ba03780a-fd65-4a03-97de-bc0905106260@kernel.org>
References: 20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn,ba03780a-fd65-4a03-97de-bc0905106260@kernel.org
Date: Wed, 14 Jan 2026 10:40:59 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <akpm@linux-foundation.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAyLzJdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 60E2ewXv069588
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Wed, 14 Jan 2026 10:41:05 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69670241.000/4drVjY4rrFz5B17g
X-Stat-Signature: 7e6y4ouaojmfgpxzwbe7tkh37a861fpg
X-Rspamd-Queue-Id: 4AD8E40005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768358470-253381
X-HE-Meta: U2FsdGVkX1+wtC5GD7/M+cDjKEWUm19eFoUYjA5TmhgBXeb8POvkzyuAnFenGh6eXjeD488gQD6OqbbEybE2SS26R49KvQE1JeDbq6z/490lChaq0Vmj55louXT069F2hJzu/Lw86xa3O9mHC66eI2OTjNZoOrcZ58ppFNren6WHzr2IlRibmjA3bgwECFe78FYYk/KhRDPbxFsC0S5X5kbXjVKDAlSjZNApeBCf0QwYsKHW8G0JrM6zBPZ7wn3NfFExFIRM4SP6P34yiwAEAAUzmkJngw0muzT3PWOn5yUTdRfEG3wJJsCQX9WFd6T11TuqzZ6MHRhma4IhdD353Xdvgyl/VMCJee9B9Ac168hXMWWElr5iPvmHH/0C0dtwSu5qtCK5MtersdTNmdpPvM+fa2GxMynKcXj4MbVJxZJSTUUwmVOaGj4kgz1SAo3UQysFSOvD6W/vo4NMcTw3b5BiTEFM8bvNv5aDao65jjSkZb4fA5wSOeZFUaKWqGmSY8F9aS+c+GJqjTce20GnShGSqytJCTTPpByo0TDKkEEf+wR/tAii59LNOaRDN+DyRg9pObejkZpv9rdbtB0xfnNSpbDO50rhpFSaGxrJhU8+Qyll1fpYzsJLPRwXKF1lDuf1eYYBUPGXjBAkHG2bPMunp9F+MgUGjQ51EROzOgRadWCLHSRnfzgObP5cQ0uNCdm4UTLlMYHbe4zpubxdmi+BybZCNacqfPmGS5HMYup17ecrqtIDxb1ueHgfSfa8iUx/yFQ0kJkB34UdVd+qSEoVaZPm2BsUDS47ld0hxHC09kNr4hgfToGkXz9hXt8YQMQGeiWvH8KoHjNTBgWf/VEkj9+sTneqZaYg3JvUPJhUf/ENekNeZhXRuEq5YIII
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Solution
> > ========
> > In fact, we can significantly improve performance by passing a more precise
> > range based on the given addr. Since the original pages merged by KSM
> > correspond to anonymous VMAs, the page offset can be calculated as
> > pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
> > defining:
> > 
> > 	pgoff_start = rmap_item->address >> PAGE_SHIFT;
> > 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
> > 
> > Performance
> > ===========
> > In our real embedded Linux environment, the measured metrcis were as follows:
> > 
> > 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> > 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> > 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
> >              and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> > 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
> >              in a loop of anon_vma_interval_tree_foreach.
> > 
> > The result is as follows:
> > 
> >                   Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> > Before patched:  228.65       22169                 22168                    0
> > After pacthed:   0.396        3                     0                        2
> 
> Nice improvement.
> 
> Can you make your reproducer available?

I'll do my best to try it. The original test data was derived from real business scenarios,
but it's quite complex. I'll try to simplify this high-latency scenario into a more
understandable demo as a reproduction program.

> 
> > 
> > Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> > ---
> >   mm/ksm.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 335e7151e4a1..0a074ad8e867 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -3172,6 +3172,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> >   		struct anon_vma_chain *vmac;
> >   		struct vm_area_struct *vma;
> >   		unsigned long addr;
> > +		pgoff_t pgoff_start, pgoff_end;
> > 
> >   		cond_resched();
> >   		if (!anon_vma_trylock_read(anon_vma)) {
> > @@ -3185,8 +3186,11 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> >   		/* Ignore the stable/unstable/sqnr flags */
> >   		addr = rmap_item->address & PAGE_MASK;
> > 
> > +		pgoff_start = rmap_item->address >> PAGE_SHIFT;
> > +		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
> 
> KSM folios are always order-0, so you can keep it simple and hard-code 
> PAGE_SIZE here.
> 
> You can also initialize both values directly and make them const.

Yes, I'll do it in v2.

> 
> > +
> >   		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> > -					       0, ULONG_MAX) {
> > +					       pgoff_start, pgoff_end) {
> 
> This is interesting. When we fork() with KSM pages we don't duplicate 
> the rmap items. So we rely on this handling here to find all KSM pages 
> even in child processes without distinct rmap items.
> 
> The important thing is that, whenever we mremap(), we break COW to 
> unshare all KSM pages (see prep_move_vma).
> 
> So, indeed, I would expect that we only ever have to search at 
> rmap->address even in child processes. So makes sense to me.

Thanks!

