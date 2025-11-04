Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C949CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8D68E0103; Tue,  4 Nov 2025 04:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BF8D8E00E7; Tue,  4 Nov 2025 04:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC568E0103; Tue,  4 Nov 2025 04:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E04E8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:05:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 351CC13AE4F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:05:08 +0000 (UTC)
X-FDA: 84072340296.28.723BD76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 691FF4000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:05:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eM9HRWR5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNwZqLRjw5xhxgzOTSYOFhIoZRaKFS2xI8vcooaSq5M=;
	b=kpF9CI5D4DbP866+Me6QXJb4BRZpbm0nGB/ojgbj4V51tdfVT+cjrKhRIfoOnO79NITDfk
	cVVqYXhP/ABWFsDwy79pKjbPD6/GueGfh4Bx6bVEQJPoA0GceZ19+Nftv62XWMyItc7Vkg
	7MBksGT5apokT/dTow1l5ifn+RT4Z1c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eM9HRWR5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247106; a=rsa-sha256;
	cv=none;
	b=EdESm8Q7rtpQ39nfR21lbf13XKNH2eK7OwO5CnTvBGWHg/4XESsV3c83Wlo4I+S/fKgESl
	5Bs1bakAAbPsaUdd0Pl9Q5LcLor0g6zofpoKCL7RTIoPSS4732p5yXhRPryiuNM+Bc59l2
	a5VD2xngxwDFI74c4dqnKiFhmJT6rMY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FA8D43F1D;
	Tue,  4 Nov 2025 09:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFC3C116B1;
	Tue,  4 Nov 2025 09:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762247105;
	bh=MvsTRVEUb4pz4cYJ7CqvDk7q15x53H+jVN10gNSeAEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eM9HRWR5JmUWRtndmMk6sdic8Q5cEco9rIlTg+CoNAIALbbMMalNePhWqgTUpAo/6
	 jjEg/vGmtp1kW34Q37eluMKvGmQ7rAcb97hrmzVoQ3iytzTv3KI86RuTkTIJ8yKynm
	 9Eh1uMx4NvDQLdMihRpOZhPuSrmOxX097149ox3HvgkNjxs+cLN/PbL4Um2CnzpO0W
	 Q+gGaCKMRn7VkKqlTJiY8dAC6gcue5fkl/J6/odIG/V3GpXlMONaNv/0Y4WC9YRkls
	 bbosyHWrRexPPhNhQFKDfV9v1Gcn7B01hMsaX5cuPt/l7/Hm9cNQLctcYYQMtiKvPz
	 Tl89hWgesCbuQ==
Message-ID: <02740344-a773-4c04-af72-72d277c7c6e5@kernel.org>
Date: Tue, 4 Nov 2025 10:05:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/hugetlb: extract sysfs into hugetlb_sysfs.c
To: hui.zhu@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Geliang Tang <geliang@kernel.org>, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1762156954.git.zhuhui@kylinos.cn>
 <fa0fee2b8c2e54cb2437db44579475492c19e94d.1762156954.git.zhuhui@kylinos.cn>
 <cbee126b-5a3b-4f03-a049-2d8b86b4e5f9@kernel.org>
 <1ecbb7b6b6c1cc85e9a52d32d968a2ad987a1922@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <1ecbb7b6b6c1cc85e9a52d32d968a2ad987a1922@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 691FF4000C
X-Stat-Signature: oc7fh3eju1nic5qoa55qaphch9389e1j
X-Rspam-User: 
X-HE-Tag: 1762247106-839176
X-HE-Meta: U2FsdGVkX1/WomRWVuHg6oXeOr+phdHZwKW7Dhgfa2Vv6rZU5FGZgGxbYK4WeiTjvkKXUeUMv5K5rMHu3fOB3QAF/cObTyLn+8XXLKknGKM3W1GNhwUh+TTDe3wYgEORuPCOPuQTPQzJfaD0X/9KOh/GFCG9Ty1sdsMIx79Jn/DJCfPDGOFU98zuGHfbqCXwquHMNI2OTld6y7H4Y7+P/eLWcAPEitbHODj6DeX+2TxyvuCnCrT8+mb1g3F+MDKMSqaB2W85SEyIFvv2dAik1qcxXjcNfB1jfVBUriymyX2Y7bfKJnYrXt+7Refp75qE2RQttMXcKPS21JWN0kHUtBoidl70fiw84XDLirs6MWNWB730D7qdS722H6RoUjW3gkvgnd/PZ0yAfojY7va3CKYqEWDSB3PTeSCc9XcZSFwR3hfGzY2c52kxpEc8wTdafJgDkY25FzCB9BgaoyrE7QUg2qg0pZgrRsv2v3U36RoX0jbg11Q1gJRpRwewlHzguDjP7NqDsrYETElYX535RdGQW1mQGJdLgVssemcWWQhvF3M3gH8JNMs2xxTpCKHrNH6bPWxtz9ZxSfHd6t9lZUNpGbdICn6nI/nXpiGLT7LqSnBIy1Ol1zsnHNkg1Snpe5opcuGfMMeQCljMhwD4PBaBJQtLg2Jr/4wv8qyM3JsSevaABMK+yPNauvrVrrBbbD6Xto5Q/5cObC9h6tV4mYQNmmAkhncUcyhak+ji3b/kRsWMORXxKBAtRTZqJ+7XVJn+vwaoBDLejvsvwDCXOhnyaTmcIuSYGxRNUUZv008pGZl6UBCgTJ4HNVehXkgbD8nkFuotLYIFL+qGHTfzTb9g7DrdCHk5Du+lrk298YvZUMHPrRUZ1eRk9b4nB1EIsqCvb9ZYpbCjjv/uX6SEtM+1fheUqY8GW4yrmNkaN24T4e2xX7ZtQYqe9+biltNmRQo3GeV9/FEBZEf/K7u
 qCHBLDz/
 raq3HqiYWCtQgFHw6hNbJ3m9+jclK68J4Psjh4TatoitwadQqrtqzPPBoT5CpaRjv696/IGl1Ho5wuzHWjAjqLQ8jSmmo6XSg/NuzRhIcKPaGjtsA6Yb+HIqT+g6tb1yScVhU/JLKpRa+n4mE8X2oSrYNysUIbrHxtr+f8IuShy/0ez0KEm6wyNT5ptLbXFJwFbU32fbV7Dkds++AfhCFw+19XvNbLKFy2/V7qONGeWYUfMZwr2jaUMacnTy0dgaa7XNK+/hNNQe3v8vC1grqAzEd+Dif5bLmzNo9ky7LNunDKQk7g7veQLLi7OMawAENpnN1MBVrM19mYyQxHQ8hCMSqVo0osa2d8luIfCiKra4VkelVJFVxfcorv6yLATRAfy7DmP+ZUE6amsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.11.25 03:41, hui.zhu@linux.dev wrote:
> 2025年11月4日 00:28, "David Hildenbrand (Red Hat)" <david@kernel.org mailto:david@kernel.org?to=%22David%20Hildenbrand%20(Red%20Hat)%22%20%3Cdavid%40kernel.org%3E > 写到:
> 
> 
>>
>> On 03.11.25 09:22, Hui Zhu wrote:
>>
>>>
>>> From: Geliang Tang <geliang@kernel.org>
>>>   Currently, hugetlb.c contains both core management logic and sysfs
>>>   interface implementations, making it difficult to maintain. This patch
>>>   extracts the sysfs-related code into a dedicated file to improve code
>>>   organization.
>>>   The following components are moved to mm/hugetlb_sysfs.c:
>>>   - hugetlb page demote functions (demote_free_hugetlb_folios,
>>>   demote_pool_huge_page)
>>>   - sysfs attribute definitions and handlers
>>>   - sysfs kobject management functions
>>>   - NUMA per-node hstate attribute registration
>>>   Several inline helper functions and macros are moved to
>>>   mm/hugetlb_internal.h:
>>>   - hstate_is_gigantic_no_runtime()
>>>   - next_node_allowed()
>>>   - get_valid_node_allowed()
>>>   - hstate_next_node_to_alloc()
>>>   - hstate_next_node_to_free()
>>>   - for_each_node_mask_to_alloc/to_free macros
>>>   To support code sharing, these functions are changed from static to
>>>   exported symbols:
>>>   - remove_hugetlb_folio()
>>>   - add_hugetlb_folio()
>>>   - init_new_hugetlb_folio()
>>>   - prep_and_add_allocated_folios()
>>>   - __nr_hugepages_store_common()
>>>   The Makefile is updated to compile hugetlb_sysfs.o when
>>>   CONFIG_HUGETLBFS is enabled. This maintains all existing functionality
>>>   while improving maintainability by separating concerns.
>>>   Signed-off-by: Geliang Tang <geliang@kernel.org>
>>>   Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>>   ---
>>>
>> [...]
>>
>>>
>>> index 000000000000..63ab13cfb072
>>>   --- /dev/null
>>>   +++ b/mm/hugetlb_internal.h
>>>   @@ -0,0 +1,110 @@
>>>   +// SPDX-License-Identifier: GPL-2.0-only
>>>   +/*
>>>   + * Internal HugeTLB definitions.
>>>   + *
>>>   + * Copyright (C) 2025 KylinSoft Corporation.
>>>   + * Author: Geliang Tang <geliang@kernel.org>
>>>   + */
>>>
>> So, you move some code and suddenly have copyright and authored that code.
>>
>> Especially given the cove letter says "The code is moved
>> as-is, with only minor formatting adjustments for code style
>> consistency."
>>
>> ?
> 
> Thanks for your remind.
> Remove the wrong copyright according to your comments.

You should keep/use the ones from where you move the code originally. Do 
the same for patch #2, obviously.

-- 
Cheers

David

