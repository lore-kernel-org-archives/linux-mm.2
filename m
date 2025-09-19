Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828A7CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 03:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C068E00A6; Thu, 18 Sep 2025 23:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23DB8E0008; Thu, 18 Sep 2025 23:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60AE8E00A6; Thu, 18 Sep 2025 23:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B567A8E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:34:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50A9F11A5DE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:34:22 +0000 (UTC)
X-FDA: 83904581964.29.C0369E8
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78CED120006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:34:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SG4ZYQLK;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758252860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMjFu7SVR95qSNzgCJYmzYUNzwf9n1HS7Sx7fQIOgfY=;
	b=VnMvLValIx7DxnfKWaSbXRPEng10fZBLMFGbRnFzBS4IG5zjJlP+l37xYFCHbRU58qse+M
	WP7hdz4UiAEiiZ1eMxr2FQnbMiKI66XdrIkl41v7bQLAzE9nuEpSOMgqPY9MJgzm1rDY6V
	prkZpI4PSHQBLVLgL/zuZbSo4/GSNnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758252860; a=rsa-sha256;
	cv=none;
	b=qLjV18FAxMOvJWjgE8DQflf8kY0Kcdsw9V6udwnxD6SzXHvZo1Sn122G6RvY3YuQEYXGj2
	lmoVBXBUl1jG5gSbRWl1Ry1mnwFYmjluiXkjGIdpB9GjUuSxecT8U3olzdAhIJ+Petbh/i
	B7H75EDg3F680zMnluoChI8TSVuZKkE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SG4ZYQLK;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <af66aaaa-9652-497a-9ff3-9ce8d9417acb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758252857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IMjFu7SVR95qSNzgCJYmzYUNzwf9n1HS7Sx7fQIOgfY=;
	b=SG4ZYQLKRvqHXnEoTxh1cvMz3hiaM6ZElAjyjuHPKfUn38WjqZWgHb5fOhLCQdaTGVRD+K
	Jop2ChIZ7x3SXAvdh2Eu1HIkcE//1SEKc6qw1gdr+IBHu/Kb+gCeT4NA3TSX7tDasm7pWI
	Z6R+2Tf8GatMpaUW4oX4h4zAej9nP0Q=
Date: Fri, 19 Sep 2025 11:34:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
Content-Language: en-US
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 kirill@shutemov.name, hughd@google.com, mpenttil@redhat.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <6BAE5498-D0AB-40F5-85F8-B92A05CA72AD@nvidia.com>
 <20e0fb73-3476-4b1c-959e-c1af38f8e1a0@linux.dev>
 <7ca12da2-4ddc-4b4e-a8da-a1d9d2c44e03@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7ca12da2-4ddc-4b4e-a8da-a1d9d2c44e03@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: h8ixtorkgmnobyenz3mjz5tpg7ahwytg
X-Rspam-User: 
X-Rspamd-Queue-Id: 78CED120006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758252860-897419
X-HE-Meta: U2FsdGVkX1+2BFKcOQDxY8wioo8wupmCEPU0DVhl88nAhtMX1iPffwfwS2D7qnUeJhIq7MAAsLolvZeGyQQn6ovC+SwtXRnRuxwp6hZfN4duKMfeapzilYOwjVFxG/oAeEf/S9tvso3lKzcZYOrspOpmWqwhjqSmx0jvwfQemS+azI/2UGBwzzjQG9NSIRyCgEK9qXR6BOXdF55QPE8kl9jTCwHXEc6f7XomYiafPJr/RFK1h529urStzcDvtCjfF4ajoQjwsa5DGJzZMTYaJNAQObD0VJJ5AQ7zRCT+d7Ox+nied/EoV0xiixZbbm/sF+L0qGKU9AEkzO7VaUp+B/axS0L7l4xFRVrNcTorcFA8MQVUvwYG4hGzxWNglRwkoBQszR9ACUkG7u6/dfEShSycVYVcBRiZ+zFNS5AdJbGv6zXb/q/PJmmJs+8uVEdKmtohNrK5rMqKgB/no+vcue7GSYFWGjmELp/fYR7G9iknmnSt34o4aLZ2PG3CCMYP8m4ChnY8rYm1jrmU6jGDPc1BSraxeTUEeh1bLJnKiIm6R+cELLGHPPSvITBnllRlBxAfzY/TrhTGl8d/gZoqSdKO4pmtMHJwcQvsFpmn4zYCPAO64ZSUZ2ngJibduKDhO3nBvGeHB0/bhzEOHJmRo3H2qlXPx4XoQD6/ukP0teLf1q94WkYuGNJrxlin7+b5aQTgMISS0jeC+mhuNbKMQhHwNUkdn4m77HzMzu3XAXvMXe6Qg1Of5Cw525pO9O8lz/LGV8YRk87Ksc+fYZjIdN1g2OLvFGFMW5o3MeQngWRVvqEYft/uZ3/ehBDyA5pJTBlTMDt8sXlnU9BwoMbKZ4hbS2iNvi1tMXZcU5IZ0KRlJX+HKBB5Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 11:18, Baolin Wang wrote:
> 
> 
> On 2025/9/19 10:44, Lance Yang wrote:
>>
>>
>> On 2025/9/19 03:12, Zi Yan wrote:
>>> On 18 Sep 2025, at 1:04, Lance Yang wrote:
>>>
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>>>> lightweight guard regions.
>>>>
>>>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail 
>>>> when
>>>> encountering such a range.
>>>>
>>>> MADV_COLLAPSE fails deep inside the collapse logic when trying to 
>>>> swap-in
>>>> the special marker in __collapse_huge_page_swapin().
>>>>
>>>> hpage_collapse_scan_pmd()
>>>>   `- collapse_huge_page()
>>>>       `- __collapse_huge_page_swapin() -> fails!
>>>>
>>>> khugepaged's behavior is slightly different due to its max_ptes_swap 
>>>> limit
>>>> (default 64). It won't fail as deep, but it will still needlessly 
>>>> scan up
>>>> to 64 swap entries before bailing out.
>>>>
>>>> IMHO, we can and should detect this much earlier.
>>>>
>>>> This patch adds a check directly inside the PTE scan loop. If a guard
>>>> marker is found, the scan is aborted immediately with 
>>>> SCAN_PTE_NON_PRESENT,
>>>> avoiding wasted work.
>>>>
>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>   mm/khugepaged.c | 10 ++++++++++
>>>>   1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 9ed1af2b5c38..70ebfc7c1f3e 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct 
>>>> mm_struct *mm,
>>>>                       result = SCAN_PTE_UFFD_WP;
>>>>                       goto out_unmap;
>>>>                   }
>>>> +                /*
>>>> +                 * Guard PTE markers are installed by
>>>> +                 * MADV_GUARD_INSTALL. Any collapse path must
>>>> +                 * not touch them, so abort the scan immediately
>>>> +                 * if one is found.
>>>> +                 */
>>>> +                if (is_guard_pte_marker(pteval)) {
>>>
>>> pteval is already is_swap_pte(), would is_guard_swp_entry() be a better
>>> choice here? Save one is_swap_pte() call.
> 
> Agree. Then seems we don't need to move the is_guard_pte_marker() into a 
> header file.

Got it. I'll only remove the redundant check in #01 patch.


