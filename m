Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4124BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820616B00D7; Thu,  2 Jul 2026 20:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF8D6B00D8; Thu,  2 Jul 2026 20:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD196B00DA; Thu,  2 Jul 2026 20:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22B336B00D7
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:32:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35324167AA8
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 19:44:02 +0000 (UTC)
X-FDA: 84944862324.01.886D6D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8B6DDC0007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 19:44:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h0yrWKeM;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783021440;
	b=dpIu2OsXuMCoMoyVW9BwDSntG3iMEMxckTADV3OwelcK+IiOG3Amyqyq3JQ/gNQaKU8bZs
	TpGsBKF4zdUz9oFOGn3KKL6YPrgxRTrddtqB5Xh8btpNEkjEF3AeUgoBd943j7G/YkG5xv
	kKDxL4efzFOnY0LgFi1uosmqhZqsroQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783021440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2PsvY3R2LHOj6IcES5Ab5eU1XEwA3syZT/3P9Yzi04=;
	b=0lOGQbv563DVeVJhMWTvLpGA4VOeLcjtBtPCT+2+Mj6v50aYPN3NtvJ48PVhzuS7Zu5EOe
	NQ0fwucOf/RkLyd/mv6D+riM+rXRX/UEdzjkTsjBn2id6/USzybRfXPKoTswaLSjIZWaLS
	PBQ1PBU8hCXDMQ2egB+C48+sWqofti0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h0yrWKeM;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EAAD7601CB;
	Thu,  2 Jul 2026 19:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9D51F00A3A;
	Thu,  2 Jul 2026 19:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783021439;
	bh=q2PsvY3R2LHOj6IcES5Ab5eU1XEwA3syZT/3P9Yzi04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0yrWKeMu9pwVpTJjikV0jmmd1jEtIMRZ+SZnV7SwS0BdLuCK1iKhdY/64SN7bas1
	 3RrBgfdoK+hNu4xb9GVyAGtuljGeW68cliYQPstJ58lX2RvBcutSp4IsCMRJ4eTXvz
	 cBnhrbOcrRAGIblXQ99ELUniJLxylQGRA01RJLQj41tXdMan+9Uw6Ca6bqSiyKNhj8
	 DzjRx0tN7AuQKLdJLAunLiL4HHMkXl27XJnGa0r1UpdGsciLoJswaGZo5X8PwTS4sV
	 o/EfsllG7pK0e0r/MMJk2ORwnn6JQ+lBbMP9r3sHDySAY+6dlFoycxmP0JeyehcI3m
	 HtzduSrhZ3RVQ==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 2/5] mm/khugepaged: add damon_collapse_folio_range() for external callers
Date: Thu,  2 Jul 2026 12:43:53 -0700
Message-ID: <20260702194353.91778-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <akZDj6s8U5_Mnetv@lucifer>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u59o7hpcdtagfgjrqnc9k48sbwg9w966
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B6DDC0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1783021440-821265
X-HE-Meta: U2FsdGVkX1+NRBnfDmvBzX60pzEAhaA00/eroZILEA1m91DqAJutMFSMTnBF/DzPlszQyIwnBE9H/cMxernNRzguq6kqNr/frhfYTAraddXz96rdDveatniG8m/DiLkYN0+GHk59aqOI2cdakQX4NzZhItvF+wC3b1wnhkfS7+MUJP/Ipx09+N36hEccOjsBwhoVpPzGFDrDDh1MYZbXmkxbv80p9dwkfOXvnI4e1lPtzT9maOgMyBSIVSCvzQ0djfBlveVL+lsf9p39c4qqsyxmi7eCPgaG1oQ73bzy7LeQK8geoOR4QEcuVR3yXY2McapZpZWcQBmgaM1yqAaUwglLguCL7aK+o0MDIFonvoqwPVIPcq97IHcGjNE2V4+Brhh/byEnuJJOEGZepPPTDFwmSQ2kukvRI8rMLxwV0jeuVwiIoEplfogKtrh7WZnf3xgbauJyiaU5JgacIBORnWbH0GjKBlFn2z3e8GlYDucUntQxLOGf7JceK5qj4YKkvidv7T3MxzXJEuYjWW6dZdZh96NqotnymS6FKh3edWW634nuo1bA179iSxFdsqGoiQd+KP1RvWy2Dxvx8Oawn4reka+b5lOel/T/bikZSgwrtV01e+7KaHihXA5DsZAO76j2k6yLXEV+FvBJitGXLsQiQNBkfu3MhCedE+Cflt8psdXiNxS348sNGtVEZZsI9ZkxdjedpbOu/BRp85emFAKCCkJ6tyD+HeRqdt5oRH2LG1ItV+AusJStdCkdI1RcouZQCVuHiT3b0rzyKfzLFMEhKA1LlgfRiemT0CsgW0xe+SRrBOLG4oixue8JLl+zItUrv5MbKol228/m5thswcLnaVpsWXlVwFNNwUlGUTMHIV7x0sWllw2IBMqHgNqiee/gTBgv8HqpyKRF2FR+vQ3783esmvzERu9QHRG7efHtq+HiH2zlco5fVQLch4QUci/pxeeOfFezfz116Ho
 HCxY/Jc/
 1O2i49lt1F3NCk6T8D9mWhiz9+4YOMujCI0jWe474E90SidLc+hhVNGYcE7EuOCsfYfvEP2yg/+P+DNv3IUO+65AnJwiAlh7u846dq+mnBfMdU6//0KWiLnaGGMJuvfnbNO2dkVFM8M15Q3s028kZo4CPcaejdRWS0jWTEgS4GUf/LKR0xswpoKPkLG+fRqvVwV1vc+2RKXEHfTQN6TE8jDjE0Dj2xZPsYYp7PYDomcA11yjpGDJ9nEsnJsTvpRl07tFjPPbyv6f/LZlvbFsqKhchjTsg+0sCF3OpXefLuLEE1KPKm23BVqgKBJa5ZLlFvq33nfo3Uphy0ZKncDaO+FOnxsrZ1nVNxu22bmN++sOR/TeYoD71CwzJI5vEoETrp81+sFLmrV+DFUJUWB2vcWOoPIMNXlIqDhLGiJe8xD6Piejt8pSVMlXw/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Jul 2026 12:07:01 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> (+cc missing people again)

Thank you for adding the recipients, and review, Lorenzo!

> 
> Sorry but we're not going to accept anything that exports THP logic like this at
> all.
> 
> And a damon wrapper in core mm code is just a non-starter, so you really need to
> rethink your approach.
> 
> I think SJ already commented on this in your v1 from what I can see? I'd listen
> to his advice on this :)

Lorenzo is right.  Not disrupting the world outside of mm/damon/ is the first
principle of DAMON development.  Sometimes we may have to make some changes
outside of mm/damon/, but we MUST make it not disruptive, small, and perfectly
aligned with the developers of the area with respects.

> 
> On Thu, Jul 02, 2026 at 05:46:30PM +0800, Lian Wang wrote:
> > Export a thin wrapper around collapse_huge_page() that allows external
> > subsystems such as DAMON to trigger THP collapse on a target address
> > range.
> >
> > Currently restricted to PMD order (HPAGE_PMD_ORDER), since
> > collapse_huge_page() does not yet support arbitrary mTHP orders.
> > The restriction can be relaxed when khugepaged gains mTHP support.
> >
> > The caller must hold a reference to @mm.  Do not hold mmap lock:
> > collapse_huge_page() acquires mmap_read_lock for validation, releases
> > it, then acquires mmap_write_lock for the actual collapse.  Holding
> > an outer mmap_read_lock would cause a self-deadlock when the same
> > thread attempts the inner mmap_write_lock.
> >
> > Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> > Signed-off-by: Lian Wang <lianux.wang@processmission.com>
> 
> This patch is exporting internal mm logic without proper safeguards so it's just
> not something we're going to accept, sorry.
> 
> (Also not sure it's correct to have multiple S-o-b for the same person (unless
> re-tagging a backport or something)? I'm not sure though)

I agree to Lorenzo.

As I replied [1] to patch 1, if you just want to give a credit to your
employer, you could add your employer name on the single tag, like "Lian Wang
(processssmission) <lianux.mm@gmail.com>".

If it is for ensure the replies goes to not only your private inbox but also
corporate email inbox, you can simply Cc: your corporate email address.

> 
> > ---
> >  include/linux/khugepaged.h |  9 ++++++++
> >  mm/khugepaged.c            | 46 ++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 55 insertions(+)
> >
> > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > index d7a9053ff4fe..f7d49cba712f 100644
> > --- a/include/linux/khugepaged.h
> > +++ b/include/linux/khugepaged.h
> > @@ -20,6 +20,9 @@ extern bool current_is_khugepaged(void);
> >  void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
> >  		bool install_pmd);
> >
> > +int damon_collapse_folio_range(struct mm_struct *mm, unsigned long start_addr,
> > +			       unsigned int target_order);
> 
> No thanks. We're not putting damon wrappers into core code. This is breaking the
> abstraction and letting arbitrary users invoke internal mm logic.

I agree.  First of all, having something with 'damon_' prefix in khugepaged.h
makes no sense.  If we have to expose something, maybe mm/internal.h could be
considered in my opinion.  But for only DAMON usage, include/linux/khugepaged.h
is definitely wrong.

> 
> Plus you're literally exporting this so it can be abused by drivers.

I was raising my eyebrows here.  I show this patch adds EXPORT_SYMBOL_GPL() at
the end.  Lorenzo is completely right.  I believe Lian added that only by a
mistake.

> 
> > +
> >  static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
> >  {
> >  	if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm))
> > @@ -47,6 +50,12 @@ static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
> >  {
> >  }
> >
> > +static inline int damon_collapse_folio_range(struct mm_struct *mm,
> > +		unsigned long start_addr, unsigned int target_order)
> > +{
> > +	return -EINVAL;
> > +}
> > +
> >  static inline void khugepaged_min_free_kbytes_update(void)
> >  {
> >  }
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 617bca76db49..7fe9ce1e0533 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -3272,3 +3272,49 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
> >  			: madvise_collapse_errno(last_fail);
> >  }
> > +
> > +/**
> > + * damon_collapse_folio_range() - Collapse base pages in range into a THP
> > + * @mm:         mm_struct of the target process
> > + * @start_addr: start address (must be order-aligned)
> > + * @target_order: page order of the collapse result (currently only
> > + *                HPAGE_PMD_ORDER is supported)
> > + *
> > + * Thin wrapper around collapse_huge_page() for external callers such as
> > + * DAMON.  The caller must hold a reference to @mm.  Do not hold mmap
> 
> This is really fragile and bug bait.
> 
> > + * lock: collapse_huge_page() acquires mmap_read_lock for validation,
> 
> This is just gross, you're now collapsing based on an outdated concept of
> what the current VMA state is...
> 
> You're also losing literally everything that madvise_collapse() does.
> 
> AND you're overriding THP limitations like max_ptes_none, which is horrible...
> 
> > + * releases it, then acquires mmap_write_lock for the collapse.  Holding
> > + * an outer mmap_read_lock would self-deadlock.
> 
> This is a sign the interface is wrong!
> 
> > + *
> > + * Return: 0 on success, -EINVAL on bad arguments, negative error from
> > + *         madvise_collapse_errno() otherwise.
> > + */
> > +int damon_collapse_folio_range(struct mm_struct *mm, unsigned long start_addr,
> > +			       unsigned int target_order)
> > +{
> > +	struct collapse_control *cc;
> > +	enum scan_result result;
> > +
> > +	if (target_order != HPAGE_PMD_ORDER) {
> > +		pr_warn_once("%s: only PMD order (%u) is supported, got %u\n",
> > +			     __func__, HPAGE_PMD_ORDER, target_order);
> > +		return -EINVAL;
> > +	}
> > +	if (start_addr & ((PAGE_SIZE << target_order) - 1))
> > +		return -EINVAL;
> > +
> > +	cc = kmalloc_obj(*cc);
> > +	if (!cc)
> > +		return -ENOMEM;
> > +	cc->is_khugepaged = false;
> > +	cc->progress = 0;
> > +
> > +	lru_add_drain_all();
> 
> This is quite literally a copy/paste from madvise_collapse(). No no no :) code
> duplication like this is also unacceptable.

Thank you for kind review, Lorenzo.

I believe Lorenzo's concerns are valid and should all be addressed before
dropping RFC tag of this patch.  Also, if you "have to" post the next revision
before addressing those to get reviews of changes on other parts of this
series, let's make sure the fact is very clearly described.  In the way, we
can avoid wasting time of reviewers.  For example, you could add a note like
below at the beginning of the next revision of this patch.

"""
NOTE to THP reviewers: This patch is not yet addressing problems that are found
on the previous revision.  This version is posted for review of only other
parts in the series.  Please ignore this patch for now.
"""

> 
> > +
> > +	result = collapse_huge_page(mm, start_addr, 1, 0, cc, target_order);
> > +	kfree(cc);
> > +	if (result == SCAN_SUCCEED || result == SCAN_PMD_MAPPED)
> > +		return 0;
> > +	return madvise_collapse_errno(result);
> > +}
> > +EXPORT_SYMBOL_GPL(damon_collapse_folio_range);
> 
> We _definitely_ cannot have internal mm logic _exported_.

I completely agree.  Please drop this from the next version.

> 
> Yeah sorry you need to rethink this.

I wonder if we could extend madvise_collapse() for mTHP and use it.

I initially thought this is a silly idea, but
'Documentation/admin-guide/mm/transhuge.rst' is saying "currently",
madvise_collapse only supports collapsing to PMD-sized THPs and does not attemp
mTHP collapse.  It reads to me like supporting mTHP from MADV_COLLAPSE is a
possible TODO.  And it makes sense to me.  Users who do MADV_COLLAPSE may want
it to at least have a best-effort mTHP.  The interface of madvise_collapse() is
already receiving arbitrary address range, so fit with DAMON's purpose.

If supporting mTHP with MADV_THP is not a real TODO but just a silly idea that
better not to be implemented, I wonder if we can split out the core of
madvise_collapse(), extend it for mTHP, and expose it on mm/internal.h.

I concern if the above idea makes call depth unnecessarily deep, though.  A
shallower approach would be renaming madvise_collapse() to somewhat general (I
fail at making an example, but whatever without maddvise_ prefix) and extending
it for mTHP support.

Off the topic of this patch, but I find 'madvise_collapse()' is declared in
include/linux/huge_mm.h, while it is being used only inside mm/.  Would it make
sense to move the declaration to mm/internal.h?

[1] https://lore.kernel.org/20260702185137.91227-1-sj@kernel.org


Thanks,
SJ

[...]

