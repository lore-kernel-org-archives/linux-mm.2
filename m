Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99554CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B91B6B0005; Wed, 20 May 2026 09:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769DB6B0088; Wed, 20 May 2026 09:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658416B008A; Wed, 20 May 2026 09:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5099D6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:48:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E83121C0F20
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:48:10 +0000 (UTC)
X-FDA: 84787927140.16.B9B3CFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0AB0A20007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:48:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nyjoZ12t;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779284889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=185YzoVZAvduTf7Tui5JFCCnk7l01KEcoY3DvLgQHFg=;
	b=ZQDVpieDfviOReSN6Vc+OCR485S+9fafdbNp2Lf0tyaqEiTvvPaNodHCVBeEhltff6RvlK
	/u1eAkOdLgTQP/zAoEaowZBZJE4Xqjo6b/cZiSmIwvfJu+ndhiCyo16PeDd0JFZs0NAFic
	+FcrbW4lLi7P5BE0EkD9qyw7seYMlf8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nyjoZ12t;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779284889; a=rsa-sha256;
	cv=none;
	b=VEHHs2tXKJxYnJ/csI2Q3nwZ38shTO+8Bc+L1KC9xs443RoHd6pvnt78UB6xwOpmobCHol
	h1EaNwZyOpiNErlKT+Z0tbZB8UUY6UYdmFuE7IyzQaQsPWgsCK0gKWAWV5wAwgRWmhF/j1
	0dpBLYwegaBLE8E6n2Za/6/DRUCF9GM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E52484099C;
	Wed, 20 May 2026 13:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC8F1F000E9;
	Wed, 20 May 2026 13:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779284887;
	bh=185YzoVZAvduTf7Tui5JFCCnk7l01KEcoY3DvLgQHFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nyjoZ12te/DXr15nzGK0DHNPpf16mWxWK7jmiu3bKIRYD81t4cWYUnk3wCWot0DWo
	 YHsqdSsOrJNd+EEcHUeS7Qc+dh+mXSWd14MRxIytd5vRwO/M+fX5WikWRHCht2h814
	 3SI+IFeScD1Oz3MRbD2TOobopQT2olFikInLbtSJ8J/w6rmbo1ct9gHw7mlH1281H/
	 sjIpxhPO3dqslspNvvfU53IYkQZDOgZRkfnwHiqOuBKqKz9A3LEELlL21SDs+QC2YI
	 QIPF6McB4XY4KWx8bh1tpLgiZXQFMgf9q+JqC+mSZQ7SvNmW7V5L8ZObpOUQJejR8x
	 TxeRqPM8X+Zyw==
Message-ID: <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
Date: Wed, 20 May 2026 15:48:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across UFFDIO_COPY
 retry
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Carlier <devnexen@gmail.com>, Heechan Kang <gganji11@naver.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu
 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ag2uzVgx2Xl7zi58@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0AB0A20007
X-Stat-Signature: ffoyxm8obs75pr5h4r6qhxhnknu4dbng
X-HE-Tag: 1779284888-250981
X-HE-Meta: U2FsdGVkX1/7+6+v370hmHcU9tXL45zd9MQ0uO/DVfSNVrnkQD1CZOHOCZBg4u6CCw1Gx/6wKChk5Bu1b+fiGRKSFmZm3DyrzzwH84QWenl4oKVTZ2fCMmGL35avDtE3pcDjsrNpJ7VSoD+qlaSHvt5P6D8pUNs0ahGtJ53JX19RQoiKBrY6sEv/9pnV8PP4dp4INzLf6Gw4BmbcQ27I2vFQin5qTAJXAtX76DUSOb0l8G/fcASx6lxImfegCzT1rrrRsDUVNaxdUn/Cmd6OO2yp8C/0Gz1L2HdYzUHOss+GMvyrVIPePc1oA9mOSn5zegjiquJu5wz8naZ7/6rEphedVWMGV9u/ozMNpNWTrzW2I32PeV5xhxT4/R3MeuxHECPzgklM8mhsOk1iMJwjjeAvrE4AilCjUR7/iymAt2uMg/uNgqlEfJEVrhKuxlKF93BywWsx0O7HlcNqAjau8PNZG0IWsmQpHaUBcA1665DwN4wK6LXKStZZ+kLGdjXZpM8lEXoBv+Bx6ns0iyzDzXninH5AR8jOpMBdZWi0kbQHmdQtPLq2ZeKJDF7+AlZ/k/8JZMouhn74yV2hdscR1M5BlxjHjezhF+QarWch/NRFeDpAyDZhRCJBRpkJmsQaFivmomXCakNEIJGiRPaBwu6pB+nQDg/YQI7o4SLQwrwXYNpew9OrGVUpJd7DmzxvDuuNowTDY36EQGA0rLRgufhze3ps/kK5A3dhiThJfmu0+BsccR76FJzBYOHhga6X5+mExMCIRyKWd5wUNw4XgasYzHibGe3IDw431YO6N6o/hihU3R+hdidIjj7YhT5JeLz7J/8dFLt09Fsq5vTVO/l1Smt8lHpSMaApSaJu4nnhG6Hv6YckJjnVwM2kTWFK1HT0Yflm1k7hknS/qf+IrgWYASiH5Sy4CV8muS7NlhU2daTaMhoqv/B21qL0CzJbZhhPySjMkQZJD1FT8XA
 Nb54V3Vk
 aYNuJuCJZjmPVTk3QJBjx/JFXXyAiX2h6DJ41x7hm5aclhHssoPXmJHFrDVjlMcfeJhvnxlMqg0UODAZ8ku1v8IIjc/pkunFsUdTfKRAQ6LQtNeOkfjkefuEy37yed/e8USkkXpF4p1ggR4sbzmVdNitIRq1Ut1qQfhQJxdCa2/A2RqzEjG+rjqIn9UrZm3if277JnDP3BDKYjdU5agt+Utogv9tBv4r2xeX3iJNnHD9elOJryt0fmJZkLaqbhUH5hjfSZwVLtS6bx8tINsZ10q5FZvHMxaTfIrLodNWx8FAJV5Jnv9julmmrHRU1A7xEhOoL132vDV4PkkvGP4rSu6Kf6h+dPQL1YWc+TBqu7C9FiE6NyeL0ndUIVcNMRIAddkR8m5pGKlEIXDkbU/2njUqS0JKiFR1IqqJjGdG1MWj1962jA+23pAYz1689raKsCVqKJ2JlZP4YdWe01BWLiEx2ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 14:53, Mike Rapoport wrote:
> On Wed, May 20, 2026 at 01:09:04PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/19/26 07:25, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
>>> reacquires it afterwards. The destination VMA can be replaced during that
>>> window.
>>>
>>> The existing check compares vma_uffd_ops() before and after the retry, but
>>> if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
>>> MAP_PRIVATE (or vice versa) the replacement goes undetected.
>>>
>>> The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
>>> with shmem_alloc_folio() as anonymous and this will cause BUG() when
>>> mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().
>>>
>>> The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
>>> the page cache of the original VMA.
>>>
>>> Introduce helpers for more comprehensive comparison of VMA state:
>>> - vma_snapshot_get() to save the relevant VMA state into a struct
>>>   vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
>>>   vm_file and pgoff) before dropping the lock
>>> - vma_snapshot_changed() to compare the saved state with the state of the
>>>   VMA acquired after retaking the locks
>>> - vma_snapshot_put() to release vm_file pinning.
>>>
>>> Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
>>> error handling paths in mfill_copy_folio_retry().
>>>
>>> Add vma_uffd_copy_ops() to avoid code duplication when original ops of
>>> shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.
>>>
>>> Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
>>> Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
>>> Tested-by: Heechan Kang <gganji11@naver.com>
>>> Suggested-by: Peter Xu <peterx@redhat.com>
>>> Co-developed-by: David Carlier <devnexen@gmail.com>
>>> Signed-off-by: David Carlier <devnexen@gmail.com>
>>> Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
>>> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  mm/userfaultfd.c | 99 ++++++++++++++++++++++++++++++++++++++----------
>>>  1 file changed, 79 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>>> index 180bad42fc79..b70b84776a79 100644
>>> --- a/mm/userfaultfd.c
>>> +++ b/mm/userfaultfd.c
>>> @@ -14,6 +14,8 @@
>>>  #include <linux/userfaultfd_k.h>
>>>  #include <linux/mmu_notifier.h>
>>>  #include <linux/hugetlb.h>
>>> +#include <linux/file.h>
>>> +#include <linux/cleanup.h>
>>>  #include <asm/tlbflush.h>
>>>  #include <asm/tlb.h>
>>>  #include "internal.h"
>>> @@ -69,6 +71,24 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
>>>  	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
>>>  }
>>>  
>>> +static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)
>>> +{
>>> +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>>> +
>>> +	if (!ops)
>>> +		return NULL;
>>> +
>>> +	/*
>>> +	 * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
>>> +	 * memory. This is an effective ops override, so retry validation must
>>> +	 * compare the override result, not just vma->vm_ops->uffd_ops.
>>> +	 */
>>> +	if (!(vma->vm_flags & VM_SHARED))
>>> +		return &anon_uffd_ops;
>>> +
>>> +	return ops;
>>> +}
>>> +
>>>  static __always_inline
>>>  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
>>>  {
>>> @@ -443,14 +463,70 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>>>  	return ret;
>>>  }
>>>  
>>> +#define VMA_SNAPSHOT_FLAGS append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
>>> +
>>> +struct vma_snapshot {
>>> +	const struct vm_uffd_ops *copy_ops;
>>> +	const struct vm_uffd_ops *ops;
>>> +	struct file *file;
>>> +	vma_flags_t flags;
>>> +	pgoff_t pgoff;
>>> +};
>>
>> As this is all uffd specific, I wonder whether that should be "struct
>> uffd_vma_snapshot"/"vma_uffd_snapshot" etc.
> 
> It's local to this file, I wouldn't worry about namespacing until there's
> an actual need if it will ever arise.

Indeed, fair enough.

>  
>> From a high level, this LGTM.
>>
>> I wish we could identify relevant VMA changes more easily. Like, using a per-MM
>> sequence counter that we simply increment on any VMA changes.
> 
> Do you mean per-VMA?
> Per-MM counter would capture unrelated changes, e.g. an masvise() for
> unrelated range.

I was thinking about a per-MM thing for simplicity. If there were any changes,
we'd retry (-EAGAIN).

IOW, something like &mm->mm_lock_seq, which we have for per-vma locks already.

Not sure if unrelated changes would really be a problem in practice (another
thread gabbing the mmap_lock in write mode until we serviced the fault).

> 
> We kinda have an infrastructure to detect VMA changes that affect uffd
> operation for non-cooperative, we can also hook on that even if
> UFFD_EVENT_* are not requested, but that's way more involved that this VMA
> snapshot.

Yeah, that sounds too complicated and what you have here is simpler.

-- 
Cheers,

David

