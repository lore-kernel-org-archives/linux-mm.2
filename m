Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F02DCCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31E798E00CB; Thu, 18 Sep 2025 04:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CEF38E0093; Thu, 18 Sep 2025 04:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E56C8E00CB; Thu, 18 Sep 2025 04:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D39E8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:11:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFCE7BAEF4
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:11:37 +0000 (UTC)
X-FDA: 83901651834.24.D4A0040
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id F38B41C0013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:11:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M5YnV4AA;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758183096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hchChWtwLQOxGyljAivB4hYgL0w8MxSX4qQYtSpmXc=;
	b=hvWrWuatYEVJ8B8b6n9ZMsylN7AChJRAcQTHHqTi2vDnnxVVnIAXVLVq89SGdsZpegLOsN
	fQq8a3T0HF8PsS3z6CdQlTb5Y3i4Q6HIytUJihE3LXwXaqjBQEU+LZ44mhl3Vyw2CT2TKE
	0hsnT0y4CRHZzQ7rVgFaoc5UMyiBW9E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M5YnV4AA;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758183096; a=rsa-sha256;
	cv=none;
	b=gR3RO3NxbeLdqoukeBVSQE1e8lNyY6UJ+Z4m7Z/5zDz9AGoSMz1qauexcYY9DZv70ZI/gN
	pG7q6qG00DPVQQhndkJtX5I78a64aZH1iPcsaao1+IHAySLF/QYKYTcGJbIiV+TI6oVY4V
	l6D3n+elOLiCg+uEeGWzFp22zrI2p8o=
Message-ID: <db182c88-04d6-408a-b36e-a708dc7eb3de@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758183093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0hchChWtwLQOxGyljAivB4hYgL0w8MxSX4qQYtSpmXc=;
	b=M5YnV4AAlwAIyMsfjkSwpmcD1EeIFgGdofp5XRQmaOtLY8h87Q8IE+iWJg5O4r7HWnqzNP
	R4Di5InjHFUxI1aeV20Iox2vG1nLWpu66cztX6dN0du3p7c/mD/infBxiQAnTnAlkPMZrd
	DNc9R+TQ1TST6OUdp3N7fP6+9nVWynI=
Date: Thu, 18 Sep 2025 16:11:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, kirill@shutemov.name, hughd@google.com,
 mpenttil@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
 <f6073afe-a604-485a-8cea-7aa08e46a0cf@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f6073afe-a604-485a-8cea-7aa08e46a0cf@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3z8mcu8wqz8ep6jixzxjjpi6o75kzny9
X-Rspam-User: 
X-Rspamd-Queue-Id: F38B41C0013
X-Rspamd-Server: rspam04
X-HE-Tag: 1758183095-311546
X-HE-Meta: U2FsdGVkX18s8HXFfpBooH/f464AWQIKdoS4JLO2zjNFawQ/7W/8jn2sykP8ymv3T1bC0R6t3YYjNjINFnhTq9FP//95t1IgS0G8mXYOB8wrXitOsNw5anBxevdr7Lj7Y+jA8VLGJTGRMA6uobB8d+9VBxjPaIlyf16/fJj62rASbAy8gj9K0fM8IFIFhfG6O7u0EY+iXLnTfP4FwXEU+VINmICuXwZjD23TefQNg2H0iJr5iNfe6GU/Xcse7eeKkwtTJ8pgcaVZR7nGDOEwmrwQfFG8T/Z6O0NYHGtMj/Vgypg7Qezq+mYf7MZzLmp67wS6S2+/HRFE9H+Q3NCVPfMhHDX3DDig+adncfteEtfSf6TYcahcQ+eYw/mAwLP/yKmLJG8OFPpLtZfjNmLZ5ZPCuvj/ZO6uyQ726ff9Yoxqk6Cc3OuhKCUwxWPiUqVDteHJP7Sl0l0Tkk8TzuJzT2bOsmqyio/KS3uvjs0AwWgy31FELcOUdKtTgBACulkwrIOv1+QPWmB7K1z4uhZjJRCKTHIDKdNy2vZ4s+Ls5eBvvZ0W5WMnmx7A+9hxQzCc31L0VzCfYpjMHkW1Xwekeb/3ZHc+DAxWqvBx/cpwq3ia0C8FMCFlRtAskI5Ve1nTDD9LS2I5sTKq8CaYl11cnkRlM9vTvvdpxRN/Wc92TRR2WCDk2TXuWoRtmB/VYLqX/jVBjpBSg72RwNYbHAXVQ7yvF6Ll9t8TEy9DDKr7r57LsOOZMAdKqJ/b1VOOsJhTkn/y4Ntqu3C4QgqX1zYEMAR6RA9kVNsg/FrRNB1laM5AOjCxFgL9LvKh9DwD6pzwQvdJyg658Y6bFYCLO0wlH6QZpQpCgpsgAHpU/mMVtfZIjSw1kjD6bAsKMygapmTCJsGeKhoNNuddJrKgMmfU1TZV6hO5yg+kmIVrR6MZUDy4wKuUvXMQEb/BLQw6Lsf9s+jkbAYdAw5zMlZ4tK3
 QJSotdCk
 /OXWsrgp9yWWtyeTp87t41k1dH14BoFq6hhVsKiOPw28LZztc8urAJeAT4RsfsJTJw9L5OhbT5RVogp4IWTWxYoA07suVjnpSuzUxAUycvasNaj792TsrNfUVSkOwokhmAYvBo7/4DVHq8t/YDu66Jxw1D7OlHRPgZkeRTE05yOq17ePDjDT+Mdl2BoRZh33WhbbtHflHEvWyJsLW92QHtz8G9bCiodxp8vY+siD8AQ+g+NX5zrKvLdrgjf2SrKUcfXwQJkNMIscmlLEJ4i87oA2xYBidAsEm5z/CdmsbEnrLub4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/18 15:37, Dev Jain wrote:
> 
> On 18/09/25 10:34 am, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
>> lightweight guard regions.
>>
>> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
>> encountering such a range.
>>
>> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
>> the special marker in __collapse_huge_page_swapin().
>>
>> hpage_collapse_scan_pmd()
>>   `- collapse_huge_page()
>>       `- __collapse_huge_page_swapin() -> fails!
>>
>> khugepaged's behavior is slightly different due to its max_ptes_swap 
>> limit
>> (default 64). It won't fail as deep, but it will still needlessly scan up
>> to 64 swap entries before bailing out.
>>
>> IMHO, we can and should detect this much earlier.
>>
>> This patch adds a check directly inside the PTE scan loop. If a guard
>> marker is found, the scan is aborted immediately with 
>> SCAN_PTE_NON_PRESENT,
>> avoiding wasted work.
>>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 9ed1af2b5c38..70ebfc7c1f3e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>                       result = SCAN_PTE_UFFD_WP;
>>                       goto out_unmap;
>>                   }
>> +                /*
>> +                 * Guard PTE markers are installed by
>> +                 * MADV_GUARD_INSTALL. Any collapse path must
>> +                 * not touch them, so abort the scan immediately
>> +                 * if one is found.
>> +                 */
>> +                if (is_guard_pte_marker(pteval)) {
>> +                    result = SCAN_PTE_NON_PRESENT;
>> +                    goto out_unmap;
>> +                }
>>                   continue;
>>               } else {
>>                   result = SCAN_EXCEED_SWAP_PTE;
>>
>>
> 
> I would like to hear everyone else's thoughts on
> https://lore.kernel.org/linux-mm/750a06dc-db3d-43c6- 
> b234-95efb393a9df@arm.com/
> wherein I suggest that we should not continue to try collapsing other 
> regions
> but immediately exit. The SCAN_PTE_NON_PRESENT case does not exit.

Yes! Let's hear what other folks think on that[1].

[1] 
https://lore.kernel.org/linux-mm/c9d4d761-202f-48ce-8e3d-fb9075671ff3@linux.dev

Cheers,
Lance





