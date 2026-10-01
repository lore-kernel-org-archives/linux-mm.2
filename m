Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99665CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 06:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271856B0088; Thu,  1 Oct 2026 02:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC046B008A; Thu,  1 Oct 2026 02:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3066B008C; Thu,  1 Oct 2026 02:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD73D6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 02:27:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 381314031C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:27:04 +0000 (UTC)
X-FDA: 85273074768.25.2ED3BB2
Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE4D2100008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:27:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CEemQOQ/";
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790836022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhMSQG6hRBc7MCFQw7VlminGPi7txsoH55rGfB0yQd4=;
	b=EshhF6wRVb/GGUuCLE0Y9Mq4ZraLGrsKr+3jXRrKhwxK4MZFCuHRFJmaXBMCqUR43WKuOJ
	P7eEAHIZQq0AdM6eg0XMLddgHpn2TnzPzPKOufPd8xa0xx8XWuehDUuTgOX14ZpHtoX9mI
	b80GCaWsVa8PIwILHblNm4yJ0BFvEdE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CEemQOQ/";
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790836022;
	b=rIMBXjfCZwMBuUEY9bRVMp74v8l9lQboI/N+AKihdvQW0TBQqZtLtG+VqzNicdpCciZxrl
	9pTo2x7yYdGT31artfufq98Qce46qSKH4xo/XL2BABFL2P+gXyYk4zayJENcDjQwCaVZF8
	OK2ADolG1w8RshPJYYZArfFn0BrWUBE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=b7R/BWq8BN8iE36KRPryjNAMMMnC47/fFTxU2yAxCr0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790836019; v=1; x=1791440819;
 b=CEemQOQ/u8pxGSLM9tp0H4G/b6FBscwOghCC0pfFlKddEkWcc0Q0Hq1sj5ESayHYXBRkG4vB
 Gc9wylnLSniCyAai4bsk+4Q97LC9XXbZFNSxLE+qlEe7QvFINTmF/UZGNjhtiBPIRw8XShIophC
 AFXvxD2cOPvFHpA00MbSft/Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 686293e332799156;
	Thu, 01 Oct 2026 06:26:59 +0000
X-Mizu-Trace-ID: 686293e332799156
X-Migadu-Flow: FLOW_OUT
Message-ID: <004b2299-3d7a-42bf-baf0-942715f5c548@linux.dev>
Date: Thu, 1 Oct 2026 14:26:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/memory_hotplug: fix missing rollback in
 __add_pages()
Content-Language: en-US
To: Muchun Song <muchun.song@linux.dev>
Cc: david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260930160432.5564-1-lance.yang@linux.dev>
 <D52186EB-026B-4C9D-BBCE-875F259634AB@linux.dev>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <D52186EB-026B-4C9D-BBCE-875F259634AB@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE4D2100008
X-Stat-Signature: cpejyh87hg31mwsky5xbmteheexskouu
X-Rspam-User: 
X-HE-Tag: 1790836021-374675
X-HE-Meta: U2FsdGVkX19+hnUgsWkPeJA2ZgzYiHIayuKq2Eqb0CfAYQeMuKq122fPh1RzLaY+e/vEr0824Sc3B9FNMza3jF2tDDxW+a3odeHHwJF3NPsO4LCl3b4jpUlFcOHnymBOBW41l7nzfncK5ogjuZm22GSaNRA3Y0q72DcbmN6orCicYnauyXd59s9P/wvHRb3QnuTr5AppEWc1W9KvyuMPdJkFr90tjmlWU5uspM145loCoy+x9stm4NF79nOohjr1J8YDiusQV02O2C2QiXkVKdPDsC/HvBo6ABHP09UFDuOo8t4F/ANq3bafMRnE51LvrDw4eIt9fVoUSzWuYyOramUJA1bEPBikPJNl3AKVChhwQqY56666j7R0+L5iFvkqSh+GwjJz8hVyXzm7Neu+drkxViPx1UIebvkE5KGutwHcg56ngCcH3+ZBFtmc4YtSAo9kvo7mtObUDibT4wvZjjdsQ3v7wFnd6buSyROpxqW0SK3IE18genWtYBBNdgT7CAkZ3VaSwOLU96fx9se+Hp+gz5/1ClX4xJYLXdN+Tp/A4NXbYejE0OqQVNf1MFwv7FQoQ/WWLa3bv8EG08s86e07OcUWOUWXQP5if52LUfYYMWXtWE0guQiAc/dZfypEYVDeBCznaySkOJlG2jY/6rn50OzCB+3XxPZhf/VzVWZD0NzjrMVUWKIeeYJg9yvKQQaAqTuWbjwEQUUlTvwIspehi6L7rEeAYsKVBaSPj2c/M/Uzo8b4SoqEMpXjULpGQfpKYMiL2+We/YPVNSzQUATlwIv7sxzbCqBUWwHY288Pq75XfDhRvHdjys1urwu2CRmCPOO3yZ1joAgZqK63ezetuemcBejLnjCUqslSekLsyV9bVlpVbOngdY2OYkZeD4p9ZUAid2631C5ZhCqG1hk287AicE/d+wNKQzRLfhzfi7Y5bAaOnJP/SdCt9sn4EKDQe6cUMPSEZIuVuRQ
 RCZ6l3yp
 lG/cZ6HK2x3P9NoGWBLa0k7skUOC+n02ggMExNge4tzllE+MkYATIHJc6MPfmO5Kmya3+zwuc+W8woXVG2xtRenW5joPP3ad2K/dREIMP0eYc6iyYo0YaCgxVlRug4PhpM0TjYcC36vEnzbwqyWDcU1kNtmdUfKxVuq2RE+7Cg67kN0l24xW9Rx+p3RsYfKTWPp7lTfdVc61El0VZ/4QbQ+pM0B3FUS2nMs+Lx1VUisIBmytaqQkovh/MQYl3meAFuDRVxM1vpVNOqS5MVJMDmesCRUdbY49NpNcDr7ittXwszoB+ZRpWGa3Sm200PLBYTa6DQc2PQCz6WfTH3WSHw/2P5KEw7S8EdZhJn1dwBFa61v2oBSVLNCKHKyCR/l5MyPK5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/1 10:05, Muchun Song wrote:
> 
> 
>> On Oct 1, 2026, at 00:04, Lance Yang <lance.yang@linux.dev> wrote:
>>
>> __add_pages() returns on a sparse_add_section() failure without removing
>> the sections already added in the same request.
>>
>> For memremap_pages(), the failed range is not counted in pgmap->nr_range,
>> so memunmap_pages() skips it. The sections already added in that range
>> retain their vmemmap mappings and subsection bits. Retrying a
>> section-aligned range can then fail with -EEXIST.
>>
>> Save the initial PFN and remove [start_pfn, pfn) on failure. For a vmemmap
>> population failure, section_activate() already cleans up the current
>> section, so the rollback excludes it. If the first section fails,
>> __remove_pages() receives an empty range and does nothing.
>>
>> Link: https://lore.kernel.org/all/BAD58999-1EDD-4A37-ABA0-DB1BD8AB3453@linux.dev/
>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> No Fixes tag, as I couldn't identify the commit that introduced this issue.
> 
> Hi Lance,
> 
> LLMs are quite good at tracing this kind of code history, so I used one
> to go through the relevant commits and identify the correct Fixes tag.
> 
> Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")
> 
> Before that commit, __add_pages() ignored -EEXIST and continued with
> the remaining sections. After a partial failure, a retry could therefore
> reuse the vmemmap of sections added by the failed attempt and continue
> with the later sections.
> 
> Commit ba72b4c8cf60 made -EEXIST a hard error because
> sparse_add_section() began using it to report an actual subsection
> collision. That semantic change was correct, but without rolling back
> the sections added earlier in the request, stale subsection bits make the
> retry stop at the first previously added section.
> 
> The vmemmap removal infrastructure had already been added by commit
> 0197518cd367 ("memory-hotplug: remove memmap of sparse-vmemmap").
> Therefore, ba72b4c8cf60 appears to be the commit that made this bug
> observable in the way described by this patch.

Thanks, Muchun!

>>
>> mm/memory_hotplug.c | 6 +++++-
>> 1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 796af1028ee2..ca4656698148 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -380,6 +380,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
>> int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>> struct mhp_params *params)
>> {
>> + 	const unsigned long start_pfn = pfn;
>> 	const unsigned long end_pfn = pfn + nr_pages;
>> 	unsigned long cur_nr_pages;
>> int err;
>> @@ -413,8 +414,11 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>>    SECTION_ALIGN_UP(pfn + 1) - pfn);
>> 		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
>> 					params->pgmap);
>> - 		if (err)
>> + 		if (err) {
>> + 			__remove_pages(start_pfn, pfn - start_pfn, altmap,
>> +       				params->pgmap);
>> 			break;
>> + 		}
>> 		cond_resched();
>> 	}
>> 	vmemmap_populate_print_last();
> 
> Acked-by: Muchun Song <muchun.song@linux.dev>

Cheers! Lance

