Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AE8CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408776B008C; Tue, 12 May 2026 06:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9986B0092; Tue, 12 May 2026 06:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1216B0093; Tue, 12 May 2026 06:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4A16B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:49:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCC141A0430
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:49:20 +0000 (UTC)
X-FDA: 84758446080.12.109695D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7CD6F4000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:49:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mjhj2u5N;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778582959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lp+6F2w5IJTNQe1TzlA/C2rjWQL0SHs1uIf63vEaWS8=;
	b=bYrPNSxgfEbZPcT/F1jJuTyoQF9skoxSIIViOLCjFFZUkYbp92q8zZ7MCUhcy19nS354Ul
	TA2FjAwkfP0e1kXdxd2hKoEogJ6iO+h30SqY33VfOn0jUPuCO3hxXNvK/0a3WlNB9AAbCQ
	jl7pQQ1g+X72qn3+5tl3sWtY1Nzlrdk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778582959; a=rsa-sha256;
	cv=none;
	b=5Nwm1vrCvuEqwWrQWubP0Kbwt2EclHqmvAQTpCt15pQF2ksaUMteHs/ozEAvM07xFucOdG
	A1ozoAvNAMbCqS5cGYIYZkfixhs9MFm4xzskXzvLesXleQnSOJNcYRSeUvoW17p3wHrdrM
	0dSoz5BLwKrKt3XtBQDjQHGxNKFQWtk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mjhj2u5N;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CEF9E1691;
	Tue, 12 May 2026 03:49:11 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D19063F7B4;
	Tue, 12 May 2026 03:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778582957; bh=85rURvLb5Wo8GOWdZ8BtaGrNFSAwSsPkKq2J2ALm5+8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mjhj2u5N2VQjkVMXKD4fyYvkC7HKj8duQThh+7BzG+Mi51cSWK66hhU5uTqF2mUuN
	 dA1g6KM8NKeRrzhAgLSscHJnP6tbmxun8z1HRSwJECUAOBtqsWMhGoHttcVQnoC6eT
	 9sbYtbEDx6j5Acdf7mRPJmoXBR7WRBCN7n4LF9m8=
Message-ID: <3a25e7fd-84a7-49a6-92a3-96492fe5d2cc@arm.com>
Date: Tue, 12 May 2026 16:19:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-2-dev.jain@arm.com>
 <de2f992c-dc93-4b79-b841-11f47511dcfe@kernel.org>
 <06029485-9e85-4d2d-a324-abba918eecf3@arm.com>
 <771a8ee7-0a7c-4d70-9e7a-cc08abebd4aa@kernel.org>
 <2a749617-d70a-4931-9aa3-c9b680783b82@arm.com>
 <575f7210-b325-489e-9937-afccf29753a3@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <575f7210-b325-489e-9937-afccf29753a3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CD6F4000A
X-Stat-Signature: otjf513qp7cmxen5wiw1zgosgo4mmxbz
X-Rspam-User: 
X-HE-Tag: 1778582958-686168
X-HE-Meta: U2FsdGVkX1+LBEepBc2N4eYjAXbiWW2auWNQhNnv08KqYr0biW6Y+oce8wiT07T86898lwyCU07Dhl9leyDHK26yyyTs06WaI3/eZ/E/E8oE+1NbRx871ur+5LsAboNZPPQ62wf3Qhk9OeDYR/x7IKT6ivRMfQPlFYnsWUbVUx0jl3Anv4A1JQCTgoi+L+NTDjZA6QTkpFd4+debllmEPnV+8GUF30hFXJ8QdV3Q2FjDBFJckcuTkmVmKyxEHf7qdzNf8cb3vRo0P4o87IntW7RchrQoJxHPw1625bqg5ATTfQoBO1Onr83H7DVyTdEStouh7B6qGU/eR07ltmgaljMalluMi+hUUQDhOye+1im+hBrMNTon36/9pox/s6/K6nHbllDGzSnxzcAcCrqcbUC/BzS8qo0CL2pE8egEB4EoJhmDOZ2gp687h5dGjVfif60OdToP3IWRoj0dPjLT5ONX2VI8B4/tp5pLkuWykv5YQSwieD+kP80l0SyDu0s2rqHLYVXdKXOYqwEpH8qNC138IZobBN/rr7BrNEYFvSIaVbR+lLfGpqq/Vyx41DMx9BTeYmykqCP4RUTmJL4oKcoPfgg8/dil0ZivsaIQNQPejL/EhmHv/qkbrA0GfZ0nDDqgwKfDeXITYcMu5AP6KIkVAPepbPX4uq+0s4TLfy5ZyXa5+7tWBoEDmU+fq6RlUb8BRwa8wV00H1qtj+D7H5jQhTWpAM/m8tK19SAwl9UHCTJd9NXZNQy93b6asrQMZU4aW3GBlNSL1xdt1Jb1hYmv4Yg6X+8vOz9jaXZvdxmHOcr4LvWtASKjGJeLzLkIm3JZDpn9ySJIAceluSbBJXPTpAiKHZtqKvO084Uq4JBpIztKqeX9LF1ieu+Da+T1bQAydHBI1cOsrc91YjVOzH4DXK8QQtNBbJpu4IOxsAwkhq/MZ/AXT4DGAeFNbD0jPfoVNghac+loRnzhyJv
 25VeUFwo
 Lej6eKtGDDr2IpESGW7LOyILRlNCrNifRAdO2k64jlYrdUJyJXOg/z/HEcUdkHk3AW1HGUX1FIDImF5bXLnBnOHAz3spX/D0G2tafaCqv4VevnsduoeyRty928NFokNMUmH1YrB8R+qRJQk6Sz1W8LZkI9aDwYdrNqaBWxKKTh8zpD3Zj1iLcgTEr7uEzlGDOjqFF/uupetheckxpP65xRSu7G34i9kFOmANzE5vnRX0WhsCr3zKJl6o8rchmRUsoAqMRHWVICe5H0M5Uie4S8PteYypwPEkd7m6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/05/26 1:47 pm, David Hildenbrand (Arm) wrote:
> On 5/12/26 10:14, Dev Jain wrote:
>>
>>
>> On 11/05/26 2:02 pm, David Hildenbrand (Arm) wrote:
>>> On 5/11/26 10:18, Dev Jain wrote:
>>>>
>>>>
>>>>
>>>> At the point of this patch, batching is supported for lazyfree and file folios.
>>>> make_device_exclusive does not operate on file folios.
>>>
>>> That makes sense.
>>>
>>> You write "In practice, device-exclusive PTEs imply a GUP pin on the folio, and
>>> lazyfree unmapping aborts try_to_unmap_one() when it detects that
>>> condition. ".
>>>
>>> But I don't think the get_user_page_vma_remote() will set the pte/folio dirty?
>>>
>>> And the pin is only temporary. The caller of make_device_exclusive() will
>>> essentially immediately drop that reference.
>>>
>>> So can't we just hit that?
>>>
>>> 1) Mark PTE-mapped folio lazyfree. Folio+ptes are clean. Can still be writable.
>>>
>>> 2) Convert last PTE to device-exclusive. get_user_page_vma_remote() only need
>>> writable ptes, not dirty ptes. Caller drops the reference.
>>>
>>> 3) try_to_unmap_one()
>>>
>>>
>>> Note that make_device_exclusive() documents: "device-exclusive entries are
>>> considered "clean" and "old" by core-mm. Device drivers must update the folio
>>> state when informed by MMU notifiers."
>>>
>>> But if it wasn't dirtied, there should be nothing guaranteeing that MMU
>>> notifiers will set the folio dirty when MMU notifiers are triggered.
>>
>> You are correct.
>>
>> I did some changes in hmm-tests.c, to mmap and fault in 64K folios,
>> MADV_FREE them, then trigger make_device_exclusive() via hmm_dmirror_cmd()
>> on the last 4K part of the mapping, then trigger reclaim. I get:
>>
>>
>> [   96.896674] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x800030000 0x800040000)
>> [   96.897857] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x800020000 0x800030000)
>> [   96.898181] HMM test module loaded. This is only for testing HMM.
>> [   97.136132] page: refcount:17 mapcount:1 mapping:0000000000000000 index:0xfffff7bf0 pfn:0xc1a00
>> [   97.136160] head: order:4 mapcount:16 entire_mapcount:0 nr_pages_mapped:16 pincount:0
>> [   97.136211] memcg:ffff00019d433040
>> [   97.136219] anon flags: 0x1ffff000000085d(locked|referenced|uptodate|dirty|owner_2|head|node=0|zone=0|lastcpupid=0x1ffff|kasantag=0x0)
>> [   97.136264] raw: 01ffff000000085d dead000000000100 dead000000000122 ffff0000030f8781
>> [   97.136391] raw: 0000000fffff7bf0 0000000000000000 0000001100000000 ffff00019d433040
>> [   97.136587] head: 01ffff000000085d dead000000000100 dead000000000122 ffff0000030f8781
>> [   97.136828] head: 0000000fffff7bf0 0000000000000000 0000001100000000 ffff00019d433040
>> [   97.137083] head: 01ffff0000000a04 fffffdffc2068001 000000100000000f 00000000ffffffff
>> [   97.137090] head: ffffffff0000000f 0000000000000021 0000000000000000 0000000000000010
>> [   97.137096] page dumped because: VM_WARN_ON_FOLIO(!((!!(((pte).pte) & (((pteval_t)(1)) << 0))) || ((((pte).pte) & ((((pteval_t)(1)) << 0) |
>> ((((pteval_t)(1)) << 11)))) == ((((pteval_t)(1)) << 11)))))
>> [   97.137122] ------------[ cut here ]------------
>> [   97.137125] WARNING: mm/internal.h:346 at folio_pte_batch+0x54/0x360, CPU#4: hmm-tests/2283
>> [   97.137206] Modules linked in: test_hmm
>> [   97.137234] CPU: 4 UID: 0 PID: 2283 Comm: hmm-tests Not tainted 7.1.0-rc1+ #17 PREEMPT
>> [   97.137237] Hardware name: linux,dummy-virt (DT)
>> [   97.137238] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>> [   97.137247] pc : folio_pte_batch+0x54/0x360
>> [   97.137253] lr : folio_pte_batch+0x54/0x360
>> [   97.137254] sp : ffff80008e7a3490
>> [   97.137263] x29: ffff80008e7a3490 x28: 0000000000000001 x27: 0000fffff7dff000
>> [   97.137266] x26: ffff0000451ceff0 x25: ffff000040fcaf00 x24: 00000000c1a0f780
>> [   97.137269] x23: 0000000000001000 x22: fffffdffc2068000 x21: fffffdffc2068000
>> [   97.137272] x20: ffff0000451ceff8 x19: 0000000000000001 x18: 0000000000000010
>> [   97.137274] x17: 3030303030303020 x16: 3030303030303030 x15: 5f6c617665747028
>> [   97.137276] x14: 282828207c202930 x13: 29312829745f6c61 x12: 7665747028282828
>> [   97.137277] x11: 2929292929313120 x10: ffff8000838feb80 x9 : ffff800080287cb8
>> [   97.137280] x8 : 3fffffffffffefff x7 : ffff8000838feb80 x6 : 0000000000000000
>> [   97.137281] x5 : ffff0002fe74a0c8 x4 : 0000000000000000 x3 : 0000000000000000
>> [   97.137282] x2 : 0000000000000000 x1 : ffff00014e120000 x0 : 00000000000000bb
>> [   97.137284] Call trace:
>> [   97.137285]  folio_pte_batch+0x54/0x360 (P)
>> [   97.137288]  folio_referenced_one+0x398/0x638
>> [   97.137295]  rmap_walk_anon+0x100/0x250
>> [   97.137296]  folio_referenced+0x17c/0x248
>> [   97.137297]  shrink_folio_list+0xf38/0x1968
>> [   97.137307]  shrink_lruvec+0x610/0xae8
>> [   97.137311]  shrink_node+0x218/0x888
>> [   97.137314]  __node_reclaim.constprop.0+0x98/0x328
>> [   97.137318]  user_proactive_reclaim+0x2b0/0x350
>> [   97.137320]  reclaim_store+0x3c/0x60
>> [   97.137321]  dev_attr_store+0x20/0x40
>> [   97.137338]  sysfs_kf_write+0x84/0xa8
>> [   97.137351]  kernfs_fop_write_iter+0x130/0x1c8
>> [   97.137352]  vfs_write+0x2c0/0x370
>> [   97.137360]  ksys_write+0x74/0x118
>> [   97.137362]  __arm64_sys_write+0x24/0x38
>> [   97.137363]  invoke_syscall+0x5c/0x120
>> [   97.137374]  el0_svc_common.constprop.0+0x48/0xf8
>> [   97.137376]  do_el0_svc+0x28/0x40
>> [   97.137377]  el0_svc+0x38/0x168
>> [   97.137396]  el0t_64_sync_handler+0xa0/0xe8
>> [   97.137398]  el0t_64_sync+0x1a4/0x1a8
>> [   97.137400] ---[ end trace 0000000000000000 ]---
>>
>> the warning happens in folio_referenced_one -> folio_pte_batch -> !pte_present().
>> Not sure why it happens in folio_referenced_one instead of try_to_unmap_one.
>>
>> I set nr_pages = 1 at the start of the pvmw walk in try_to_unmap_one and this
>> goes away.
>>
>> Will send this as a separate fix patch.
> 
> Awesome, thanks! (CC stable)

Okay I think there is another bug. In folio_referenced_one,

	if (folio_test_large(folio)) {
		unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
		unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
		pte_t pteval = ptep_get(pvmw.pte);

		nr = folio_pte_batch(folio, pvmw.pte,
				     pteval, max_nr);
	}

There is no pte_present(pteval) check here. We will encounter a non-present
entry in folio_pte_batch(), giving the trace above.


> 


