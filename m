Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D5ECD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0246B0088; Tue, 12 May 2026 04:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2869D6B008A; Tue, 12 May 2026 04:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3026B008C; Tue, 12 May 2026 04:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1326B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:14:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75C0D1C02E0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:14:33 +0000 (UTC)
X-FDA: 84758056026.15.2900D27
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id B5747140009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:14:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aTF6EOSu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778573671; a=rsa-sha256;
	cv=none;
	b=M24mpI2asMmG4tPcWiXc0sc3pXEAEsqVDPnASfWxHlsVZycsNgXe0Eu8ySVA7uk3G1m7hx
	HqEprk+YAEkIjWJV0UPB48IEj1S+XnYLFLbY6az2hd+9jc+9DUSKpEetjpJKcXB83kub3i
	1hVMsPpEOXmb+xFVXCu/4axGvZhjASE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aTF6EOSu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778573671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A82ABZIOeABdLXm8OnENRdl1gJ1ixDkUAD765TrhjiM=;
	b=jSOJUmrv43QHcBgrh0bRNCFMc6kAziQD/ARqLZXNjPxlqTvP5PN9RgLsZeDophUPVYu0y6
	UvaU+cTYBzJsiak6W2hkqzEMVnnd8k6PuhzUW1g+ZMUJt4drSIlcPklvMbBCwNP4U1kNrV
	uJf7GngDIK8Zx/NE30XtIfSR3+Zd1nU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E479A168F;
	Tue, 12 May 2026 01:14:23 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 583873F7B4;
	Tue, 12 May 2026 01:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778573669; bh=9oqjyNYscSC0WE7CI1fcw+cCu/Y0jMgg2jlO3/9Q4o0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aTF6EOSuBXDnXDhvTriG3DTM2OocbLeRsfgT1HNYAA9r8QmZJszb/DuTMO4Aiz/TL
	 jrWQcnsai9zqUgvjewssaV6N2khvsXwTZLO6DLL7Sc/GozHPyqcNqWTwS26qw7wutG
	 b99UceABZVlKHnOBuUAGT6F6yELm4Ytcdnlt0RIo=
Message-ID: <2a749617-d70a-4931-9aa3-c9b680783b82@arm.com>
Date: Tue, 12 May 2026 13:44:10 +0530
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <771a8ee7-0a7c-4d70-9e7a-cc08abebd4aa@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pngiezbxn83u7ir564ai4cepuc3aedsm
X-Rspam-User: 
X-Rspamd-Queue-Id: B5747140009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778573670-900554
X-HE-Meta: U2FsdGVkX1/UL2atvqUe7hfC9lmyAeJHjg49BVC/UMGeAHiviMaQ/TJS7EGC2BLssxUNjbswx324IREN/C4sepwZXuQs7xgdzgvNFasX00XqFqmSKf5mIlNXehg1SmLcGfY+9T5DwBDNsUFMpYt0qfprNUgpkLcHgGnPw57VG6U/3jVOUTww6FMEaQMTUcRFHroW47rzi8Vn4vjrlWQVQSwulj18gRUuq/Ba2Byy2dyK5pntiv+zyBZwmvCblt1NnhKOSp6uuoy9H3WlTOb5E9Hf2dkM+QSh7z47wGu7cQdzwWiADkieQISsMqotWDR5ZQFsWu2Q++djPLcEHSv6pA7Aubnb6KL/N+dP/SjowUk/lxGLO5AC047rLP822YYEVpSzKlMNbK/fWYQ2lLFJXFUcWtMRWliCpQm1Ua0F9UoRH/ebJf8ekPBj5X9kNvvuvRBj0tJLHwiK+FGo40vjhvi5s+uOKEdJiuvxB4JWCEPhtH7NFngb2oBmxYEECOakesRvK+fE8yoc9hOv0uSr5i0KOQLbyrFvWSEUYxCi5Ke4KEZ73/rrqe3XvtHjdSYr/ke8SnVeDojHiBnxSugj1HBXPYB0cg4mLGPPanS8AUYSPGlSgXvEsOw0Yt8ptGiFsE8PAxz+YVgcN3WsqtTYjnT6o2f5kjV/fqj86kTiI9CMkEo1T+sB46AToOw3SfOlj5IKGzBCqTPcMfaBrgRE/bmK+LQZi0Jz6pNPydoG2eXL5IN3HSGUgEwZwjjZ+7XbkUsuPvAnqP//Cv+V/Yn6vI2jzd7R0PUtIoPxvkppaNz2bYXbs2GrFM9z7ZwKyB5zzPJEuY9ckwQZDRluYimx4JElrdCHG0G4ISnvnri2OUmeYEFLLgivk+qt4O7/CVEA9JmiX+wa54uaIsmjUbAQEjPIKtbGS68AKaYeiNPW8yCHPmRJsdeSPWSxUmsa8La33TJd6iQKK12d+I58st4
 zxkBWjoC
 5y3QgqNJ7e75etN993k07lUVWqJWA9j8Zgfhl2IAkF5c6c7KWot1DPl8z8+Sp8yony1YTs35T81Qwnuo/wy5zXZiJiM3JqJ9eWjIcfiS2whSikj8KHboDheEAllHaxWYGW9YUy78QX/LafRea5BqcwxnczX+p8rLKjnAb3a5XYMFE6f6Jbssw/dVj1hkQIpN0KXGzPDcS1mFLaBjM1kX/f6KvuxFMPyr87p4Whk5tdO9TWiGDLhdlUGMLG/XMRlOWqNtakRAnGOA6a1CmlgFwFyvOLYapB++pUlUKvDKx1iZM6Hk5YhGeP2uzjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 2:02 pm, David Hildenbrand (Arm) wrote:
> On 5/11/26 10:18, Dev Jain wrote:
>>
>>
>> On 11/05/26 12:18 pm, David Hildenbrand (Arm) wrote:
>>> On 5/6/26 11:44, Dev Jain wrote:
>>>> Initialize nr_pages to 1 at the start of each loop iteration, like
>>>> folio_referenced_one() does.
>>>>
>>>> Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
>>>> can be reused on a later iteration that does not run
>>>> folio_unmap_pte_batch() again.
>>>>
>>>> I don’t think this is causing a bug today, but it is fragile.
>>>>
>>>> A real bug would require this sequence within the same try_to_unmap_one()
>>>> call:
>>>>
>>>> 1. Hit the pte_present(pteval) branch and set nr_pages > 1.
>>>> 2. Later hit the else branch and do pte_clear() for device-exclusive PTE,
>>>>    and execute rest of the code with nr_pages > 1.
>>>
>>> Right, for hugetlb folios it should always stay at 1.
>>>
>>>>
>>>> Executing the above would imply a lazyfree folio is mapped by a mix of
>>>> present PTEs and device-exclusive PTEs.
>>>
>>> Why lazyfree? We use nr_pages also for
>>>
>>> 	folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
>>>
>>> and
>>>
>>> 	folio_put_refs(folio, nr_pages);
>>>
>>> Given that make_device_exclusive() operates on individual PTEs, wouldn't it be
>>> possible to trigger that?
>>
>> At the point of this patch, batching is supported for lazyfree and file folios.
>> make_device_exclusive does not operate on file folios.
> 
> That makes sense.
> 
> You write "In practice, device-exclusive PTEs imply a GUP pin on the folio, and
> lazyfree unmapping aborts try_to_unmap_one() when it detects that
> condition. ".
> 
> But I don't think the get_user_page_vma_remote() will set the pte/folio dirty?
> 
> And the pin is only temporary. The caller of make_device_exclusive() will
> essentially immediately drop that reference.
> 
> So can't we just hit that?
> 
> 1) Mark PTE-mapped folio lazyfree. Folio+ptes are clean. Can still be writable.
> 
> 2) Convert last PTE to device-exclusive. get_user_page_vma_remote() only need
> writable ptes, not dirty ptes. Caller drops the reference.
> 
> 3) try_to_unmap_one()
> 
> 
> Note that make_device_exclusive() documents: "device-exclusive entries are
> considered "clean" and "old" by core-mm. Device drivers must update the folio
> state when informed by MMU notifiers."
> 
> But if it wasn't dirtied, there should be nothing guaranteeing that MMU
> notifiers will set the folio dirty when MMU notifiers are triggered.

You are correct.

I did some changes in hmm-tests.c, to mmap and fault in 64K folios,
MADV_FREE them, then trigger make_device_exclusive() via hmm_dmirror_cmd()
on the last 4K part of the mapping, then trigger reclaim. I get:


[   96.896674] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x800030000 0x800040000)
[   96.897857] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x800020000 0x800030000)
[   96.898181] HMM test module loaded. This is only for testing HMM.
[   97.136132] page: refcount:17 mapcount:1 mapping:0000000000000000 index:0xfffff7bf0 pfn:0xc1a00
[   97.136160] head: order:4 mapcount:16 entire_mapcount:0 nr_pages_mapped:16 pincount:0
[   97.136211] memcg:ffff00019d433040
[   97.136219] anon flags: 0x1ffff000000085d(locked|referenced|uptodate|dirty|owner_2|head|node=0|zone=0|lastcpupid=0x1ffff|kasantag=0x0)
[   97.136264] raw: 01ffff000000085d dead000000000100 dead000000000122 ffff0000030f8781
[   97.136391] raw: 0000000fffff7bf0 0000000000000000 0000001100000000 ffff00019d433040
[   97.136587] head: 01ffff000000085d dead000000000100 dead000000000122 ffff0000030f8781
[   97.136828] head: 0000000fffff7bf0 0000000000000000 0000001100000000 ffff00019d433040
[   97.137083] head: 01ffff0000000a04 fffffdffc2068001 000000100000000f 00000000ffffffff
[   97.137090] head: ffffffff0000000f 0000000000000021 0000000000000000 0000000000000010
[   97.137096] page dumped because: VM_WARN_ON_FOLIO(!((!!(((pte).pte) & (((pteval_t)(1)) << 0))) || ((((pte).pte) & ((((pteval_t)(1)) << 0) |
((((pteval_t)(1)) << 11)))) == ((((pteval_t)(1)) << 11)))))
[   97.137122] ------------[ cut here ]------------
[   97.137125] WARNING: mm/internal.h:346 at folio_pte_batch+0x54/0x360, CPU#4: hmm-tests/2283
[   97.137206] Modules linked in: test_hmm
[   97.137234] CPU: 4 UID: 0 PID: 2283 Comm: hmm-tests Not tainted 7.1.0-rc1+ #17 PREEMPT
[   97.137237] Hardware name: linux,dummy-virt (DT)
[   97.137238] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[   97.137247] pc : folio_pte_batch+0x54/0x360
[   97.137253] lr : folio_pte_batch+0x54/0x360
[   97.137254] sp : ffff80008e7a3490
[   97.137263] x29: ffff80008e7a3490 x28: 0000000000000001 x27: 0000fffff7dff000
[   97.137266] x26: ffff0000451ceff0 x25: ffff000040fcaf00 x24: 00000000c1a0f780
[   97.137269] x23: 0000000000001000 x22: fffffdffc2068000 x21: fffffdffc2068000
[   97.137272] x20: ffff0000451ceff8 x19: 0000000000000001 x18: 0000000000000010
[   97.137274] x17: 3030303030303020 x16: 3030303030303030 x15: 5f6c617665747028
[   97.137276] x14: 282828207c202930 x13: 29312829745f6c61 x12: 7665747028282828
[   97.137277] x11: 2929292929313120 x10: ffff8000838feb80 x9 : ffff800080287cb8
[   97.137280] x8 : 3fffffffffffefff x7 : ffff8000838feb80 x6 : 0000000000000000
[   97.137281] x5 : ffff0002fe74a0c8 x4 : 0000000000000000 x3 : 0000000000000000
[   97.137282] x2 : 0000000000000000 x1 : ffff00014e120000 x0 : 00000000000000bb
[   97.137284] Call trace:
[   97.137285]  folio_pte_batch+0x54/0x360 (P)
[   97.137288]  folio_referenced_one+0x398/0x638
[   97.137295]  rmap_walk_anon+0x100/0x250
[   97.137296]  folio_referenced+0x17c/0x248
[   97.137297]  shrink_folio_list+0xf38/0x1968
[   97.137307]  shrink_lruvec+0x610/0xae8
[   97.137311]  shrink_node+0x218/0x888
[   97.137314]  __node_reclaim.constprop.0+0x98/0x328
[   97.137318]  user_proactive_reclaim+0x2b0/0x350
[   97.137320]  reclaim_store+0x3c/0x60
[   97.137321]  dev_attr_store+0x20/0x40
[   97.137338]  sysfs_kf_write+0x84/0xa8
[   97.137351]  kernfs_fop_write_iter+0x130/0x1c8
[   97.137352]  vfs_write+0x2c0/0x370
[   97.137360]  ksys_write+0x74/0x118
[   97.137362]  __arm64_sys_write+0x24/0x38
[   97.137363]  invoke_syscall+0x5c/0x120
[   97.137374]  el0_svc_common.constprop.0+0x48/0xf8
[   97.137376]  do_el0_svc+0x28/0x40
[   97.137377]  el0_svc+0x38/0x168
[   97.137396]  el0t_64_sync_handler+0xa0/0xe8
[   97.137398]  el0t_64_sync+0x1a4/0x1a8
[   97.137400] ---[ end trace 0000000000000000 ]---

the warning happens in folio_referenced_one -> folio_pte_batch -> !pte_present().
Not sure why it happens in folio_referenced_one instead of try_to_unmap_one.

I set nr_pages = 1 at the start of the pvmw walk in try_to_unmap_one and this
goes away.

Will send this as a separate fix patch.




