Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CBECAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8E78E0007; Wed,  1 Oct 2025 05:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F828E0006; Wed,  1 Oct 2025 05:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99FAE8E0007; Wed,  1 Oct 2025 05:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82DCE8E0006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:38:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 301C0BC508
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:38:38 +0000 (UTC)
X-FDA: 83949045516.24.8E0DC63
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 45263A0005
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:38:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gJ3r1JI5;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759311516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GV4zvLAZCIS+DJquNo2kGvLSwP9qlPaKfOY4TEmQGuw=;
	b=h9ROT3/rPXr9qypQdyzJbDQh9yJDNEmrpR9PpWz34RHL7KR7p673PfylquSiPo3elfzKMJ
	z3MF0dRt7g/Y/2z+RJ4cYjsOxIDDQ2oBNaF/dkkckza5Zkc9NhRirB3AzmxF3EAj8bHYCQ
	eZRycxBjKZyGEKLIvn8c6ywUaNNWp/Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gJ3r1JI5;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759311516; a=rsa-sha256;
	cv=none;
	b=BhBEh8a8Pwh/wGNZbnCJxbYd8vXS8+ayLmxksC8Ynk76KuKie9gMhcGnTWmMfJUG1JFmSz
	FySUyrFnON0h/8uGxDK/fsUt2q1k7vak7OgwRVV1e9NvDMdmFJsOGSWtHZFfUEMkvql9NE
	zs/OXSE3FfVMFfm3Dj8PmuCb1MFjrl0=
Message-ID: <4640ec4f-57ee-40f1-92c1-6bc703de7933@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759311513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GV4zvLAZCIS+DJquNo2kGvLSwP9qlPaKfOY4TEmQGuw=;
	b=gJ3r1JI5yO396r9SYNygihameJKZ6f9cXVO1ivaQvB4rLWWT2b9k+EWJydC9FYOwu9QUe1
	JSjK/3oFbWbQ8+theezba8BRMS83uSkYEYJOj4UKekV3eOEeFi7IxVUKfnUOYWfT6VVg2g
	QsTD+DmU8dHl8a0y0ATkGDi3LPbe7Ko=
Date: Wed, 1 Oct 2025 17:38:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com,
 akpm@linux-foundation.org
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <f07edfc2-0952-486f-ae47-5e3bbd77e4c0@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f07edfc2-0952-486f-ae47-5e3bbd77e4c0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 45263A0005
X-Stat-Signature: 7g7ke6jo9ojif3ecu4bq5n8mxjab4xee
X-HE-Tag: 1759311516-947011
X-HE-Meta: U2FsdGVkX1/MmdaGDC1o/UOWM90DcI65QH3xiviTCL3Rt9dQlSAgAmMluHBVsbRO1i26eLv9CJlL1HLkZjlQdiKvgdvBrrBgO0aJBJ1Z/dLVL5mDiM0lL3XrHnb4YIRP8o5sMOHLU9fyQ+XhUUwcWK/y+xBHy7SFTNGCZymUc8ISwUr9oZjLsWW44XHskoXPWPOMpsEOIWmlqzqehehwo/76tvvm7/vVSBlsxTZjkiRaEIJ6OnuCPVD4RZztVZy7zD35Sc1b3vp2XvT3bySQahiUkJHpudicpIcGuYs7zUxoRTbn7Rl8cx7ej56dgVv79VHwF2c6/bpDdA24mOKaw0thyP7aFqc68i9mLy1KOHAo2gjKz2XlYUwLopPDZvQ45ecqLoQkppVhj7FiQT2hC4BGaIWLsi1HJfXq/BVx65vVRpALExHA/g74g1nFz7v9N2249jrZ2Ie0lWctHli3uv2/LjJkuV9O4epSmjRgx9YkH1k8i0F6nwrzQXyGt97IW6alLmYvfyvJQilo6uPRqHxSNEwcIgF6Xi97v+cgyRnyITftaS1MXK7uYyWXsKovAIS7i7AGdzlI0wHGUA3AmfZ7wnCSX0hUQtQDP+z3EE2G9mCQ6z3ZJnS93yeFZDw9RKBCizF54AiDOxVpKNiBDH9I9WU5P/beNRq4vLKV8zfHO7mQ0VmdFDbzJlzEx7AMwT+0bNRoCG87BTXhNfCNos6P6s02UxtkCgSPjTu6/ePpBm+ijq5Xhux+7l5llug3vEIsr6A+PxqGgUxY/CW6TGKS/x+/y7gDHyAokdpqlzmTqR4yuYvuXmKTXx/6zUapJ53TguEZA/48SGpt2d08wEZUSKUOAqFNCx/ZUl3NBVL+yH95q6mKlKhRnPmcsKFqqZ9QXtpBYqHYndQf14Cy7+QevHiOe1QNd4lrWWI2WoO8NuuyidheR6isw65mu87Qks5P5e2BV0Es5osatc/
 dzjd51h3
 WZ3DJvqwr/IbKRd3eF20lwo85HZ8CE9+gbV7cR4bul9qzEmvkX29sa3192EALUENYPXluZrADcLfmEmy3MbxQwHG+12/n3nvrGnZ1KQToGx52yiy8xJzrri3tpf6Unzf5dKmgpXVe+lHWK6d/SVUxjuoXhJl/ddk5m+gfYHNChhJ+FDEZPNkPi4xhOUI8JG1ZGWO+qM+LTa6czAoJvdhIRQ6lDU0oXoyEWfVicc3xXTDx8qWW6WuWxjoImRy1tbeXNJImylyZRAnniWCvgD2D9ENO96VaF/QIKUeFvtKvWFUwUbXg0okhfO/GcvMYyWpewkDxyu0OuMN2O3zsvkv5tNIpbrkgCmxpATkCqUbLjULNtApAVIX+T5ERQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/1 16:31, David Hildenbrand wrote:
> On 01.10.25 05:22, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Currently, special non-swap entries (like migration, hwpoison, or PTE
>> markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>> failures deep in the swap-in logic.
>>
>> hpage_collapse_scan_pmd()
>>   `- collapse_huge_page()
>>       `- __collapse_huge_page_swapin() -> fails!
>>
>> As David suggested[1], this patch skips any such non-swap entries
>> early. If any one is found, the scan is aborted immediately with the
>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>> work.
>>
>> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb- 
>> a7c8-1ba64fd6df69@redhat.com
>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680- 
>> dcd55219c8bd@lucifer.local
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
> 
> Could have mentioned you adjust the flow of code to resemble what we 
> have in __collapse_huge_page_isolate().

Thanks for pointing that out! Let's do that separately. I'm working
on a follow-up patch that will unify the scanning with the
almost-duplicated code as you suggested ;)

> 
> Acked-by: David Hildenbrand <david@redhat.com>

Cheers!

