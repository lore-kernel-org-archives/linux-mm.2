Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEC7CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 01:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947AF6B00A6; Sun, 31 May 2026 21:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB606B00D0; Sun, 31 May 2026 21:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D946B00EB; Sun, 31 May 2026 21:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E5E6B00A6
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:55:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F6CF1405AB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:55:26 +0000 (UTC)
X-FDA: 84829676652.13.1DA8EDC
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id AF854A000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:55:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GnCTJd3B;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780278924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQCbMRkdqdDT9GLUSMLXaeh0gg478vZBNxmXwoTOz6U=;
	b=jkYX6BKFPlkcXQSaC0/BiC48cOkb/Em2u52EOq91aTbb5Sqq0X7r7CsvQj9mF+/JtIrFth
	WRe7jJLEftJW0q5qH43AXgeOWRFHBnLVjVRROTtGp29MalBl5noPmwk/h6xoMQVnZoWeCS
	xRlewPz7+VE/aVYm9sEvDMLNklpg7kE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GnCTJd3B;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780278924; a=rsa-sha256;
	cv=none;
	b=ojREjzRbpBU0KqJ4wDyM2FbroBQWjca5vuHyW+Pmw7kn2b/fyUdsYknGA4w+VmR4qY859o
	yYAK8gzAsEhp8FxtEXCg0SdMxs0xOTscdpKIYetSflpd8+569hDdUUQ7YhzkwASXVGrpLV
	E14y6iao7E/rIOiJBgXbTtlfjY08smw=
Message-ID: <bb855309-422b-418d-ae34-54969e01375f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780278918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQCbMRkdqdDT9GLUSMLXaeh0gg478vZBNxmXwoTOz6U=;
	b=GnCTJd3BSfUClP+EsrGgz2anJizI1lNps8XDR/4ezY3+8U5Tb14abeAfZv2bzXchAihLYN
	fo8bwJf0yz6X2MYCySFso5RSnCLFQzVrw/qGsL4jzIsdFzY9+5xj6RAlNCwd23SGSJ8xRa
	aMauQxDjTgID35xkiQSfsyXbn9R29L4=
Date: Mon, 1 Jun 2026 09:53:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v18 12/14] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, npache@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <20260522150009.121603-13-npache@redhat.com>
 <20260531073102.20318-1-lance.yang@linux.dev>
 <65e201dd-10d6-43f6-8758-0fc313158fe7@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <65e201dd-10d6-43f6-8758-0fc313158fe7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: b7fr7n9hsem4r54fyog99krzo79r3pgy
X-Rspamd-Queue-Id: AF854A000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780278922-401771
X-HE-Meta: U2FsdGVkX191qWN3qkqwpz6E9KIpVa2bYGfbpn9h3L3DLuoC2lhkDOSzYpxRU7qY8PB0UMQdwLgiwHd/8hluNysU7SW9THf8V7OHepR6mqV3bfN6ex4nMeT3Pgp/6tFcHrJUwbg74+aDG0KRcAW7VflhHsmKkbr2cFL3H5quVSERBiInUVVlSZuHR/oKjmC/XGEqA1C3BbLo8CZEIjRjJ+18vg7lpyisq80cu59otbdf4XRasnk+1P0h8bxSwBiJPREXWRkkoIvks3sVHjDO7L62RYSALzEJlwM3dMBqYfOLr0s+izpCUhDcsVYCxcIxiK+yvALZGfAqaQKm8cFBO7VOtdadOhFPJBdwET7Nc6N1Os6OrjxCeI69r1gI2ik/o7NilFt/Q+kt9l2oWW9c7Q5zNAvVlK8YSyCL55Xh6loLA+uPrLBcLluF+82PDpKYq/jv1ccJbQA/aiRB5mj8AaRx/3JLI1rEDWza+QIMkzRPZsL7aB7JQOm2nuf0WSIvWxgZHbLTQdkxt2neK58gMVkww4jiKG4kYlZj3y1C+a3q8L/vKryrKARqcGApD4snWZ2qsh69JITLesqg1vP5oDrUFs9y6Y7gK3WGu/BzV1AWCmDHqwfg0Hid8etwB8BGzwxgXxlGsHdmFzxsYrkaiZA3+UhPfqeRrDOf4LZGzgUrCpdCzERSjE847iXFjw1calAmeu3tkiWffA1wPczyQ/z6mRGdyYrBCatadcnVSkShU5bN6lNhim7iNEcxhpVEBpv8HWW4dpF0ZAPN3tqMXaraTaNd+N0ZfNj3ERPgWcG0bwLHuWGb+qkgK5zDqtOY/oigXpYd8gdfgYQgVpjrjmGydGgETzZYptBG3KnMDFexPkNuKsznGEjoYuIXeGz+9rG1hq8xZvNpzE46dO+QTUdb+DT094WjMYtOUymz4nyZizYwHAhgSPRy/+NLW2maHKTGTBOtr0Fiyng4hMJ
 d874ReWM
 dXkj3vYgKaOUIKzlcNstvjcjV/LnCHcoCU/pe3S82nNuevRdLl+0CbY/OGU/AKzW5Lmpb8IAl/8IkNvNeMlewBe7H0AEIN1F7UIko2dlJRUEuUFbI8F8b4h8utazAwbswIuu3QoOmHOEBpYuhFxqmerxjVXXXFrVhv/9Bzr5wNCL7zm/vd3YSlH4h1ZbZEGv1a//tSv/2FHz9uLWm4OGIdB9O3Mqu7ZxJ7INNEp31Wbw0dQllyMuc/80jskc3iug12CHAAydat2p2Tf+jrPNR59KSqgqbxujmD7fW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/1 04:02, David Hildenbrand (Arm) wrote:
> On 5/31/26 09:31, Lance Yang wrote:
>>
>> On Fri, May 22, 2026 at 09:00:07AM -0600, Nico Pache wrote:
>>> There are cases where, if an attempted collapse fails, all subsequent
>>> orders are guaranteed to also fail. Avoid these collapse attempts by
>>> bailing out early.
>>>
>>> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>> mm/khugepaged.c | 24 +++++++++++++++++++++++-
>>> 1 file changed, 23 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d3d7db8be26c..15b7298bc225 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1535,9 +1535,31 @@ static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
>>> 			collapse_address = address + offset * PAGE_SIZE;
>>> 			ret = collapse_huge_page(mm, collapse_address, referenced,
>>> 						 unmapped, cc, order);
>>> -			if (ret == SCAN_SUCCEED) {
>>> +
>>> +			switch (ret) {
>>> +			/* Cases where we continue to next collapse candidate */
>>> +			case SCAN_SUCCEED:
>>> 				collapsed += nr_ptes;
>>> +				fallthrough;
>>> +			case SCAN_PTE_MAPPED_HUGEPAGE:
>>> 				continue;
>>> +			/* Cases where lower orders might still succeed */
>>> +			case SCAN_LACK_REFERENCED_PAGE:
>>> +			case SCAN_EXCEED_NONE_PTE:
>>> +			case SCAN_EXCEED_SWAP_PTE:
>>> +			case SCAN_EXCEED_SHARED_PTE:
>>> +			case SCAN_PAGE_LOCK:
>>> +			case SCAN_PAGE_COUNT:
>>> +			case SCAN_PAGE_NULL:
>>> +			case SCAN_DEL_PAGE_LRU:
>>> +			case SCAN_PTE_NON_PRESENT:
>>> +			case SCAN_PTE_UFFD_WP:
>>> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
>>
>> Nit: shouldn't SCAN_CGROUP_CHARGE_FAIL go with SCAN_ALLOC_HUGE_PAGE_FAIL
>> here?
>>
>> If charging the current order fails, a smaller order might still fit :)
> 
> I think the reasoning was here, that if we are already that close to our mem
> limit, we should just give up instead of trying to squeeze it in .. :)

Fair point. Just a nit, nevermind :)

