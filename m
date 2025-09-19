Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D50CA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 03:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 477518E0053; Thu, 18 Sep 2025 23:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428FC8E0008; Thu, 18 Sep 2025 23:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D858E0053; Thu, 18 Sep 2025 23:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 220CE8E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:19:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B595B1DE790
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:19:07 +0000 (UTC)
X-FDA: 83904543534.13.1B7AFB4
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0ABF620005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:19:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ND5wEMmo;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758251946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jyNZcyWmSv57/hy/i7IMAf+J2cMcU8oayGt4OVdOm8=;
	b=wDTrBY48I5aqQdIhI/jWqyGOieEU4OHX7RdiLd2owQok3FwO461z/C2pg+PVkmWqkN/UEv
	4Xs33eNdMmOj9DCakPmxSeGpDXvBwnshM/YA/UEUagqiGy+V2TEHxqQHeN0wlVurRJDv4Z
	da/yWyAJ8jQaGUn6baI+KVfu3ycGM8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758251946; a=rsa-sha256;
	cv=none;
	b=mMXDQBv5gghJDpPwiwJe14UZl/Qrkv/ghHJGrSGANUh/1N8aF3/QXA9gn+kVU3fSW2lqk9
	hcnhUvOU1sI/p8qE66Lfd0Bum7vSnhvXLv6Wkm5dp+JBvL5bFe+bIvWcbh4DUYDfnShJKW
	QEEqyTBkOXfciwAGyzdpyh1xhRxZuwk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ND5wEMmo;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758251935; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3jyNZcyWmSv57/hy/i7IMAf+J2cMcU8oayGt4OVdOm8=;
	b=ND5wEMmojowB73ns9wottu3QoqGaUZJ+doPKGqD+lxxkLFF9m7/TfR08HR97yhCKokw6c83/5oKKqxQYy9T5tBRRfW2vg+/mCpAG+g3Wq6Y4Kvw36/0mQ4xZDEx+UmsnAFBtKAh2s4oBAJjSRA3fP1AM4zTd3fZ5zzfzX+T5Qs0=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoIF9NG_1758251931 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Sep 2025 11:18:52 +0800
Message-ID: <7ca12da2-4ddc-4b4e-a8da-a1d9d2c44e03@linux.alibaba.com>
Date: Fri, 19 Sep 2025 11:18:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
To: Lance Yang <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 kirill@shutemov.name, hughd@google.com, mpenttil@redhat.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <6BAE5498-D0AB-40F5-85F8-B92A05CA72AD@nvidia.com>
 <20e0fb73-3476-4b1c-959e-c1af38f8e1a0@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20e0fb73-3476-4b1c-959e-c1af38f8e1a0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1jkgswrswtuefc7yk5gxi56kwfc6f6kb
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ABF620005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758251941-356982
X-HE-Meta: U2FsdGVkX18VtBYgbfrnB44StZZjgmV9wCqwTFO+48GH2vNyTwlJZzdLej+7EIHuz+CSll3m1TBhB6R5gA2v7VuFqdSc0ThVjGyODsideOZpyqABx+Orv1C/cW9J2XwwpZP+n5m5t1mphKeFi6JCIbinp+EfFqd/IYk0HuIfk6NVXg2K9qNt1meIC0Hu1iz7t+HWtGYUHHn57WhQGTCpnhyBGgUiFiMG0tOiHOh3zi6wvz34w1A0lt0pWTqlZZrdvJEAfaYuVa4f+D86QbgcmWDxxWgQmN6ikjB5SOPZlU8wprn/+yvOQq++HGqWYTxUuIlvo7KS1vhYLLM93rrAIN/NkyTrUgGJljWKIqyCoZozVNoTW63VIvWRN5Yc9iMPyp5IUD3GvefTujAmSCfGZ67vwNSKk+biSO58TGNTxSVYWJwzOusz9CTF5r63vJeR3wCMeo5UUZr8x4DmEW4LvZK+Qar2M3Q9rV4gVe84fduXptQmbh8BDf17Hu0lXypTcWefTIdzXZ1eUt0RjxLkvC7GZnH3wJhK9DuAFOG3M6QsDTz6vdUn0bvdM6DXcgIPUD96GWXVoWUZLaXfgjfMyqXDutlRb8v/ISGqcK++Iuku4UWVTH4XOTDViriB5SogDjwgwYV84nGdEcTIQ7OAAB6bCAKsIuS/t6/HRyG+zrpUBcw73aIXaV1/l2Y3Mt2L2cuZtUqqe9URV32jl5ZVZS5SF1eyoec4rgwa5AYPD3TZfO22y6fv2Yut91n43GjZYTMbiVyjlZ+4PGgEDBmsmexTX6t1ebM5B0L9WrA1cGZMkjuyCKXcow6VdW9Sjs5zHqJqzMbOlgDJLMJ/qSc153fNsHExY1nqiphMvEg9Q7yFf/sGlaYSWlmR8YeZSa9mqNkYd+W55p+dOah1kgZ+x9V8QS5OGwvP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 10:44, Lance Yang wrote:
> 
> 
> On 2025/9/19 03:12, Zi Yan wrote:
>> On 18 Sep 2025, at 1:04, Lance Yang wrote:
>>
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>>> lightweight guard regions.
>>>
>>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail 
>>> when
>>> encountering such a range.
>>>
>>> MADV_COLLAPSE fails deep inside the collapse logic when trying to 
>>> swap-in
>>> the special marker in __collapse_huge_page_swapin().
>>>
>>> hpage_collapse_scan_pmd()
>>>   `- collapse_huge_page()
>>>       `- __collapse_huge_page_swapin() -> fails!
>>>
>>> khugepaged's behavior is slightly different due to its max_ptes_swap 
>>> limit
>>> (default 64). It won't fail as deep, but it will still needlessly 
>>> scan up
>>> to 64 swap entries before bailing out.
>>>
>>> IMHO, we can and should detect this much earlier.
>>>
>>> This patch adds a check directly inside the PTE scan loop. If a guard
>>> marker is found, the scan is aborted immediately with 
>>> SCAN_PTE_NON_PRESENT,
>>> avoiding wasted work.
>>>
>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>   mm/khugepaged.c | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 9ed1af2b5c38..70ebfc7c1f3e 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct 
>>> mm_struct *mm,
>>>                       result = SCAN_PTE_UFFD_WP;
>>>                       goto out_unmap;
>>>                   }
>>> +                /*
>>> +                 * Guard PTE markers are installed by
>>> +                 * MADV_GUARD_INSTALL. Any collapse path must
>>> +                 * not touch them, so abort the scan immediately
>>> +                 * if one is found.
>>> +                 */
>>> +                if (is_guard_pte_marker(pteval)) {
>>
>> pteval is already is_swap_pte(), would is_guard_swp_entry() be a better
>> choice here? Save one is_swap_pte() call.

Agree. Then seems we don't need to move the is_guard_pte_marker() into a 
header file.


