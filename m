Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C93C98308
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F2A6B008C; Wed, 23 Sep 2026 03:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A1F6B0098; Wed, 23 Sep 2026 03:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D3836B0099; Wed, 23 Sep 2026 03:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 769706B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:10:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1316AA06F1
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:10:25 +0000 (UTC)
X-FDA: 85244153610.24.62A2223
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 82D32120002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:10:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZktHXeeV;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790147423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9RAe9ZjvGj6dYOYWWXV4UowTJ/0wUjk9Zi0mnvN1Ks=;
	b=TrBtJb3Sc3VwE+lQMKkeVECzPFSs6CsMWP8AsArK7EIkshojZKUn6T6a2jtn5R8kQhqJD/
	A1ZOXscThbmtk2ZuZ5OjgXeQJkkBq7PsgahQ69wCRzljWeFbjhRtAKzuratWdFAaarfSae
	eETF42iHDb2Unv8WI54DXjKivVamxfk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZktHXeeV;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790147423;
	b=lma2pOZhzDB4nFMw+y4y5pP0VjXn2SHH9SsIcY4JFnPXw7R/ocMbMEKTFjCKwGKMNgNiou
	Fvtsi9mwivY9yY54vXIjfyQVl6nQrV6Z3mC0RKpnZtiM2aMNeQXuu8CkWlrojvFxbc9Q0s
	EbgEeIcHzxGOqk9+uOoFi+jMhMyaa1I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8524F60200;
	Wed, 23 Sep 2026 07:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF7D1F00893;
	Wed, 23 Sep 2026 07:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147422;
	bh=t9RAe9ZjvGj6dYOYWWXV4UowTJ/0wUjk9Zi0mnvN1Ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZktHXeeVHUdVX84HQm0s5eTwxdjCgV+/1qk2ubVk78nV17YKtFkiFazEoAUDTsoXc
	 M9HCiTHUQ7J69MHTAi4rLJyLVgYuyNbgSZJz+v4NLmOvNpB/bSTDv4lHPBz5Q4Gbdm
	 cw1DRtF+qN9ZW+I8gS7aCogIW950qmkzAO26UzPGSnMSRMFt2p6bBCYM4H0oUIHroz
	 jtcloLZ16zE9tgGKnollzIYQBpif6cPAzGzXl2ECvovYLZTpgksOX/6bxn4RAYnBNk
	 G5I4qUhKiokal3pqf0QgZTJFeUKOfYndJa8L1dZhaKM+4yq8dKa2tMGYzCO83fHsqT
	 OShYOOxxd3Q4Q==
Date: Wed, 23 Sep 2026 08:09:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, 
	guoren@kernel.org, bcain@kernel.org, geert@linux-m68k.org, dinguyen@kernel.org, 
	schuster.simon@siemens-energy.com, jonas@southpole.se, stefan.kristiansson@saunalahti.fi, 
	shorne@gmail.com, dalias@libc.org, glaubitz@physik.fu-berlin.de, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, linux@armlinux.org.uk, 
	vgupta@kernel.org, monstr@monstr.eu, chris@zankel.net, jcmvbkbc@gmail.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org, 
	davem@davemloft.net, andreas@gaisler.com, richard.henderson@linaro.org, 
	mattst88@gmail.com, linmag7@gmail.com, catalin.marinas@arm.com, mark.rutland@arm.com, 
	chenhuacai@kernel.org, kernel@xen0n.name, tsbogend@alpha.franken.de, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, richard@nod.at, 
	anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	arnd@arndb.de, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, 
	ysato@users.sourceforge.jp, shakeel.butt@linux.dev, corbet@lwn.net, rdunlap@infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, hughd@google.com, 
	qi.zheng@linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 01/12] mm/khugepaged: deposit a newly allocated page
 table on collapse
Message-ID: <arN6TnhWK0j61E3q@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-1-fe1ad1f1e303@kernel.org>
 <20260923022436.61930-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923022436.61930-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 82D32120002
X-Stat-Signature: 9wk636hjispun356cirerg8aw7upfg6s
X-HE-Tag: 1790147423-424131
X-HE-Meta: U2FsdGVkX1+0CUQzqdD5c0AwWHd1XgJK4skJlxA+OrX64BB0aoIlbXtbqEKBDM7xi5vd8iLqGhhFypLAwINnhUAdRVD2cDJa9KkCoe0rsZavN/rqZxzr8r22arqhELLTUpEhlNLlmsk+muAOaeDVVtaY7iM0vVTHwUp4gNbAmM4yyKY1sQuNpXuQERl3DnQNZJpzT2cfmjQCaMx522hN1n0D/mEDvdbolngTuJ3iGrvPlEwanm4DCAugS6kzudynbfDPTXZd0vJSPR/9MV0i27TAE8wE6nhzDFlNX6KO9tnRn2dR4dYreoV55Zb3Ssm7BBVuLoAlmczVVHgM3tJAMex7NjD29caxa5wfpWjJhKXYVtVWfoVtldyfZ0mFEEAYcFLcw7pX96UZb1qNWDxCFS7FaoHJ6CFB8vncVjxk/c/GqRrwBzQpHEc6EL9f6xvRNf6VAhwQI9MEXoaBkPAgkbi1HQdRb7im0e438Eim9vU+PDLPy9ZAwTo2uaBghD+4bOKi0vi2JQaesA+FHqxXFtzI1fpm8JqQwg3f1EXC71jyIX5YdTckGKwX/AY9IPOl93130MONLGKz5QtxDebZM95vvXH+z0N1jIeTgZl8KO2TgXfQQbsk4WEzjphfSnsiIP+f7rqN0sNC6yPrEpZkDYODft5bnXfiWJKo1re2tQGdolEQeMNLClLHqtd0XX5iwfssHZiNlR5VHLz2CtAL5UWeqCv8wym/LVw3We0Wvw9WiZqtmjYh564UzAcpQS43yVfnU0cZIwujWOTZnHS7JJR1KWW5vn7ZT6H+avca1h3uJ50hxYElEkqXb7Gs6FyITu3KR8A35Et/HWyC0NVmLUUpdumy+25jMtaj2wh6AlklxBPoc10m80mPCuqINzJtaqk3P7w73UyD1hT7HNdJoEYgPIpZjA91kZ2pqIw9eCm3GmEz0Mu+v07HOhz/fbstsGhTpQHKbaGgYVwifWp
 b+e3tPCS
 5sYiJCLK+ltAA2Qvmpdm4X/6YLCjD1tyy5noEEHRIZECSCO5/3EhxwPGMvHPnKfoZmDJZmaf81YgN/aQA5viZmPgDcxpf01a9Bw1H3hxv9dfkikuy+z9tkFn6eEE1Iic2LQabmgAvAKWuV4ZGaUf1iqiDi05GllWIy2xHZr9D7x4tZFQXeHHZ+5C15R6Wihskyoo3qOFQ1ATg/bCXK0PyUDYpYc+NhNxQ7CT2FexqsQwna3wLP0zWhnHxpXpgAEGEYgky+YM4EYlB+DZ7UpQ5WtIDg4tFI8cTHggvGmikbsE8B/HpEUYrv4bOkPw5N7ITxQvRb7jKI+YmaKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:24:36AM +0800, Lance Yang wrote:
> > mm/khugepaged.c | 32 ++++++++++++++++++++++++++++++--
> > 1 file changed, 30 insertions(+), 2 deletions(-)
> >
> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >index f49a6710933b..dab421f8233e 100644
> >--- a/mm/khugepaged.c
> >+++ b/mm/khugepaged.c
> >@@ -1278,6 +1278,23 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
> > 	return SCAN_SUCCEED;
> > }
> >
> >+static pgtable_t alloc_deposit_pte(struct mm_struct *mm)
> >+{
> >+	/*
> >+	 * khugepaged is run from a kernel thread, so need to manually set the
> >+	 * correct memcg so the allocation gets charged correctly.
> >+	 */
> >+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
> >+	struct mem_cgroup *old_memcg = set_active_memcg(memcg);
> >+	pgtable_t pgtable;
> >+
> >+	pgtable = pte_alloc_one(mm);
> >+
> >+	set_active_memcg(old_memcg);
> >+	mem_cgroup_put(memcg);
> >+	return pgtable;
> >+}
> >+
> > /*
> >  * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
> >  * will always return with the lock unlocked, to avoid holding the mmap_lock
> >@@ -1293,7 +1310,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
> > 	LIST_HEAD(compound_pagelist);
> > 	pmd_t *pmd, _pmd;
> > 	pte_t *pte = NULL;
> >-	pgtable_t pgtable;
> >+	pgtable_t pgtable = NULL;
> > 	struct folio *folio;
> > 	spinlock_t *pmd_ptl, *pte_ptl;
> > 	enum scan_result result = SCAN_FAIL;
> >@@ -1310,6 +1327,12 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
> > 		goto out_nolock;
> > 	}
> >
> >+	if (is_pmd_order(order)) {
> >+		pgtable = alloc_deposit_pte(mm);
> >+		if (!pgtable)
> >+			goto out_nolock;
>
> One small thing: result is still SCAN_SUCCEED after alloc_charge_folio(),
>
> 	result = alloc_charge_folio(&folio, mm, cc, order);
> 	if (result != SCAN_SUCCEED)
> 		goto out_nolock;
>
> 	if (folio_memcg_alloc_deferred(folio)) {
> 		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
> 		goto out_nolock;
> 	}
>
> 	if (is_pmd_order(order)) {
> 		pgtable = alloc_deposit_pte(mm);
> 		if (!pgtable)
> 			goto out_nolock;
> 	}
>
> so if alloc_deposit_pte() fails, collapse_huge_page() returns success
> without installing a PMD.
>
> I see sashiko pointed that out too :)
>
> Cheers, Lance

Sigh ack yeah oops :) I think SCAN_ALLOC_HUGE_PAGE_FAIL is the closest though
it's not allocating a huge page so much as the page table, but gets the correct
MADV_COLLAPSE -ENOMEM back.

(Another case of local AI review not catchign something btw! Sashiko does lean
towards over-reporting/hallucinating but catches more)

Will ask Andrew to update in reply to this patch as a quick thing rather than
respin so quick, and fix up on any respin.

--
Cheers, Lorenzo

