Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF1FC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2977F6B007B; Thu,  6 Aug 2026 03:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270746B0088; Thu,  6 Aug 2026 03:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1881F6B0092; Thu,  6 Aug 2026 03:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9F726B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:48:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BFF41A06A4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:48:56 +0000 (UTC)
X-FDA: 85070068272.27.7D99FBE
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id 84C61160007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:48:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VWMdc8Rd;
	spf=pass (imf08.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786002534;
	b=EfSQKdAz3K9hA9gGh98y5Ky8NOHKLJ1M06fugLjdm1wtwjMaif/W2GAb/ieiv6L3npCLdb
	Qzm6UVip9LIPuGTlJUfUINMyNZxT9oCdpevt+t38xn59JntseII8VC1vxj/fnRVTxn4K4I
	2ODo9VLTLYW+Dv+z8nrWHZIkCicroIM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VWMdc8Rd;
	spf=pass (imf08.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786002534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awi5f3XjRTk7KwCF/uSqRsetJq/tyZPjOmjYhX47qpA=;
	b=evpO7VTLwdosVLWGuxKSs5E7OKAn2FS7EoOeDh9uWh2I0bkh29BXZGocACoM+F2g/LFcvb
	dzmOUOeZlx/nLp/QKqsg6+mbuSjK8EqVViQhwUAsH5pkqD/vIeSN+54jloQCi9c+w4y1c7
	aQvbtC84WLmnWyQvJVzdc3/wHFlxpvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=awi5f3XjRTk7KwCF/uSqRsetJq/tyZPjOmjYhX47qpA=;
	b=VWMdc8RdTdvFR1f8adxHxcRqGN8MA77Kxc3Y5t66g+6QbHSfiFvz9pFA9AnQih
	D+KCaappImVb5qbpcxXHvu5XyHX8/0REEHZPNuu6BOmuHU33m+FO2XZDZuq5vK02
	3acycWDj9cVc+inq6MFeIneI+m2CCWbigwz2xCsWcVvxY=
Received: from [198.18.0.1] (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wCHTZNSPHRqudjdNg--.16566S2;
	Thu, 06 Aug 2026 15:48:35 +0800 (CST)
Message-ID: <e3700884-ee6c-4671-977e-2694535b8443@163.com>
Date: Thu, 6 Aug 2026 15:48:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: validate KSM rmap items before hwpoison kill
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 xialonglong@kylinos.cn
References: <20260803151151.3472893-1-xialonglong2025@163.com>
 <20260805162937.1795310-1-xialonglong2025@163.com> <anNl1SSA3fidOrTy@lucifer>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <anNl1SSA3fidOrTy@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHTZNSPHRqudjdNg--.16566S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3GFyrCr48Xr4xtr4UAFW5KFg_yoWxCr1xpa
	s3G3WDArW8tw1a9r97Xw4q9FyFvwn8Ja1jyF47Ja4av3Z0qa1fCF18Jrnxua9YkryxGas2
	qr4UZFn8uFWYqrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UsqXLUUUUU=
X-Originating-IP: [240e:46c:1000:421:34db:efe:597b:d439]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xPa02p0PFPXEAAA3b
X-Rspamd-Queue-Id: 84C61160007
X-Stat-Signature: bhp6kdzzegoccbcrr945s6jhqgbd6hrw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786002532-177158
X-HE-Meta: U2FsdGVkX19nCcai+76W0G7wCZ9P2etGFPObjIHlqiuqH+QPd9Fgat45hxBAP71sVVNEwtvhWl5ovKSTz7gORw62U/CSu5IrgJyJU/XZ3585Q80X6JQwqn6oGQGmCzST0DQt8epLjWief+qh6QZUAeoC3ACTDqS5mpw7D+DPuxENdlmEKJKHRkaepO388OD1STgdYnIAUpAq9IT1yxtGVF6IllB3R/G8q7fBfbBC2DJoqKy88ZqKde/U9mAEjVL2JaqCffyohAlbwnV2pc+NjNgN6agV8B4W+kcG838O7/7rGuo6GJI28S+65UQPywh5v0SARFlgNTQ6i+kP6uYNKMEbl2yjksozJ5GI6CkDB6B9seW6Kyqa5UURjrkx3TciTdZFtTJREp/Ohq7T+2HsvcDyCIyOUSEq9aaQddG5gFN+3ygcPopnlllne/N4jgiJedOuvRqIPZqxPaaxWsBY7Z3t922K+vkwwKBKtRSIi5L+SM9hn8naKIzWZVTgtIzMEarCItpODP0mGNNqhdhPEEJiKhOkQ5PRKgkmO+m5+zcyYvYCqrEzvDDCBVv+EGlfHVHN1QogPyy+1KeZcubTecvBQGW4hSKUWuAiu6CGByCWEtw7Z8xMU+3Za8MXrGg18ib9Lg5RCXcKgNh2xCRsqqOMy0sqIbbv1t6VZPtBghF4JjK6KbUYGrQZkJLJm9XYH++17YXSgOeaSdY6e8kdLRx4fOGU6lELnNW+ZmUoRlAetFGkkjpyJREqbXpC34a4kdDZHU/BTpDEz/M8YhRNdXJ88Z9BHYjPn3pFEyL06MuKS+kCIb6bfe+T/RhrWk0W4QTJ1btQxIaLcFr18pW7wMbunahWjOhY43qDu0Kdv1MwLiyA1tw/j9PvZLxjuYh994sktdj9xzTWu6MYgRiQd1Fm8QsIJtI2GQMZ7nNMhjWCWB/j6leeQRj6x3GwfJ5GZxzQs04tEsSU/2nKmxq
 O/Hkevi0
 4ydXcHfzQMuTbuMJGhwKqKghYgmdJtR2N/+oAAC/u4MUFE4hl1iDxL9SisoTqkMhAmtm1RzKm1zwN8oMjzHPt7qNomgHxBveRgOWTGiaYY5rJg945xi1WLGjraqzl73odGd2okCoxVR7wK9nMRPyNQLVDR2T2CGOP8vzj2W6eL+G4L/pXrP2a2X8VgwJvw3lrfm1Fk5CaR8OE6twTRvdROs0LVLAcz9hmzMk+evFIgEh9LEZKJrXMby7ASDpnUG5eP/UM7oBN2rIzh1rqFxF9XFndVBCBNfJ3CNVyOvLfbYlfqdVBwzNg1dhwHbPNfgMdpJ8dRRu96U0tDqJjFpOdskaqGN/OA/aNLotcwuHLdLnIZIGqzBfrMzSB6B4CvidtTA3PjTcOX3sRRK91rAjjMiGJg02978GqMCLxuNLgrxw8+w717N3seCsuC9HnSjNPfhwB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Sorry, you are right. I messed up the process here -- I should not have
resent it so quickly, or sent v2 as a reply to v1.

I did use AI tooling while working on this, but the patch is my
responsibility. I did just follow the anonymous-page handling here, without
thinking it carefully enough.

Thanks,
Longlong


在 2026/8/6 0:47, Lorenzo Stoakes (ARM) 写道:
> :))) I did just say don't send a v2 but I guess you didn't see it.
>
> Basics:
>
> - Please don't respin when somebody's literally asked for feedback from somebody
>    else.
>
> - Please don't send v2 of a patch in-reply-to a v1 send it separately.
>
> - Please don't send a v2 on the same day as a v1.
>
> - Attach a changelog under the --- with a link to prior versions (using b4 makes
>    this easy).
>
> Anyway I guess I am forced to reply here... *grumble*.
>
> Thanks, Lorenzo
>
> On Thu, Aug 06, 2026 at 12:29:37AM +0800, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> collect_procs_ksm() walks the stable-node rmap list and queues an
>> early kill for every task whose mm appears on the anon_vma chain.
>>
>> That rmap item can be stale by the time memory failure handles the
>> poisoned KSM page. A VMA may have been split, unmapped or remapped
>> after the rmap item was recorded, so matching only vma->vm_mm can send
>> SIGBUS with an address that no longer maps the poisoned page.
> I'm very confused as to where memory poisoning comes into it? What exactly
> made you aware of this? Do you have a bug report you've observed?
>
>> Factor page_mapped_in_vma_at_address() out of page_mapped_in_vma() so
>> callers that already know the virtual address can validate it directly.
>> This avoids deriving the address from page_pgoff(), which is invalid
>> for KSM pages. Use the address saved in the KSM rmap item to check that
>> it still belongs to the VMA and that page_vma_mapped_walk() still finds
>> the poisoned page before adding the task to the kill list.
>>
>> Fixes: 4248d0083ec5 ("mm: ksm: support hwpoison for ksm page")
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> Honestly I have to ask - is this your own work or AI-generated? As I'm not
> confident you really understand this and it's tricky stuff so if a
> backportable patch is in the works I'd prefer somebody who understands it
> contributes it.
>
>> ---
>>   mm/internal.h        |  2 ++
>>   mm/ksm.c             | 10 +++++++---
>>   mm/page_vma_mapped.c | 36 +++++++++++++++++++++++-------------
>>   3 files changed, 32 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 181e79f1d6a2..4c9e601b2d95 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1424,6 +1424,8 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
>>   		     unsigned long ksm_addr);
>>   unsigned long page_mapped_in_vma(const struct page *page,
>>   		struct vm_area_struct *vma);
>> +unsigned long page_mapped_in_vma_at_address(const struct page *page,
>> +		struct vm_area_struct *vma, unsigned long addr);
>>
>>   #else
>>   static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 7d5b76478f0b..5104e442fcb2 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -3237,13 +3237,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>>   	if (!stable_node)
>>   		return;
>>   	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
>> +		const unsigned long addr = rmap_item->address & PAGE_MASK;
>>   		struct anon_vma *av = rmap_item->anon_vma;
>>
>>   		anon_vma_lock_read(av);
>>   		rcu_read_lock();
>>   		for_each_process(tsk) {
>>   			struct anon_vma_chain *vmac;
>> -			unsigned long addr;
>>   			struct task_struct *t =
>>   				task_early_kill(tsk, force_early);
>>   			if (!t)
>> @@ -3253,9 +3253,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>>   			{
> OK so you're literally doing an anon rmap walk here, with the anon lock held.
>
>>   				vma = vmac->vma;
>>   				if (vma->vm_mm == t->mm) {
>> -					addr = rmap_item->address & PAGE_MASK;
>> +					const unsigned long mapped_addr =
>> +						page_mapped_in_vma_at_address(page, vma, addr);
> Now you're doing another anon rmap walk? Why on earth are you doing that? And
> won't this deadlock?
>
> Why aren't you just checking the whether addr is contained in the range here?
>
> Like:
>
> 	/* Make sure VMA wasn't split/remapped */
> 	if (!in_range(addr, vma->vm_start, vma_pages(vma)))
> 		continue;
>
> Or something?
>
>> +
>> +					if (mapped_addr == -EFAULT)
>> +						continue;
>>   					add_to_kill_ksm(t, page, vma, to_kill,
>> -							addr);
>> +							mapped_addr);
>>   				}
>>   			}
>>   		}
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index bac2eb5de63d..f7c5dc9248bc 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -336,6 +336,26 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>   }
>>
>>   #ifdef CONFIG_MEMORY_FAILURE
>> +unsigned long page_mapped_in_vma_at_address(const struct page *page,
>> +		struct vm_area_struct *vma, unsigned long addr)
>> +{
>> +	struct page_vma_mapped_walk pvmw = {
>> +		.pfn = page_to_pfn(page),
>> +		.nr_pages = 1,
>> +		.vma = vma,
>> +		.address = addr,
>> +		.flags = PVMW_SYNC,
>> +	};
>> +
>> +	if (addr < vma->vm_start || addr >= vma->vm_end)
>> +		return -EFAULT;
>> +	if (!page_vma_mapped_walk(&pvmw))
>> +		return -EFAULT;
>> +	page_vma_mapped_walk_done(&pvmw);
>> +
>> +	return pvmw.address;
>> +}
> I hate this name I hate that it's CONFIG_MEMORY_FAILURE only.
>
> Also it sounds like a predicate but returns an address? I have no idea what this
> is supposed to do? And no kdoc?...
>
>> +
>>   /**
>>    * page_mapped_in_vma - check whether a page is really mapped in a VMA
>>    * @page: the page to test
>> @@ -350,20 +370,10 @@ unsigned long page_mapped_in_vma(const struct page *page,
>>   		struct vm_area_struct *vma)
>>   {
>>   	const struct folio *folio = page_folio(page);
>> -	struct page_vma_mapped_walk pvmw = {
>> -		.pfn = page_to_pfn(page),
>> -		.nr_pages = 1,
>> -		.vma = vma,
>> -		.flags = PVMW_SYNC,
>> -	};
>> +	const unsigned long addr = vma_address(vma, page_pgoff(folio, page), 1);
>>
>> -	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
>> -	if (pvmw.address == -EFAULT)
>> -		goto out;
>> -	if (!page_vma_mapped_walk(&pvmw))
>> +	if (addr == -EFAULT)
>>   		return -EFAULT;
>> -	page_vma_mapped_walk_done(&pvmw);
>> -out:
>> -	return pvmw.address;
>> +	return page_mapped_in_vma_at_address(page, vma, addr);
> Oh yes, make the !CONFIG_MEMORY_FAILURE build break *eye roll*
>
>>   }
>>   #endif
>> --
>> 2.43.0
>>
> --
> Cheers, Lorenzo


