Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9402CCA472
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254A58E001A; Tue,  7 Oct 2025 08:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BED8E0005; Tue,  7 Oct 2025 08:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169288E001A; Tue,  7 Oct 2025 08:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0277A8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:24:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A353BC0159
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:24:57 +0000 (UTC)
X-FDA: 83971237434.27.53275CF
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id A0F35C000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:24:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uHDsfr2/";
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWzLkpy6LtsQniRjwahmxwgQkPSDljs/w7uP2yyHpYk=;
	b=rC5u23wnd/h7zeNKBX2TSd3XO7c4l3eaR5x3IaF5pi1htD0PWMpeJLkDTbt2mrY0d87YGX
	8MMrLpuXa31KuhGKJKiLdHSDm6R0DpnmVVNEToZ9titKjvfyO9Z7MI5hmUWqBngpV0ONBz
	r77Sx32g5b4oZ0lkw+rfJhWzcCmWG0Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uHDsfr2/";
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839896; a=rsa-sha256;
	cv=none;
	b=muwUoE0v9SO+eUpLiylHGXTr14mKdaTU4ScRXID10Qg5pbLbeNKJCibigKj4S0F4O3hgdK
	N25b1fVzconK/c/zz8DCgSKG8kGXoJm2KLXj0TkweF8GmFiA3ONDhPbPXNYv6QB4FeAnYi
	XU15BVRps61TmckrXGHMIIhf3gZjoYU=
Message-ID: <e0566f96-09f7-406a-8c7f-da6dc476cd60@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759839893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nWzLkpy6LtsQniRjwahmxwgQkPSDljs/w7uP2yyHpYk=;
	b=uHDsfr2/aYHwlagUtO/bvuB7ubG2nTOg4/rfzangxTB1CmPrdqV8u6b7N9ONycq5UcmypH
	cySSBLyyoq3I4PK1/GCvwEArNT2LAILk+KnUcEZEDEk8UGtT8FR822UR5kkz6OZH+Dh3VH
	F+FrvOlsbbWTDajGCknf01xu0L4gG8Y=
Date: Tue, 7 Oct 2025 20:24:40 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Usama Arif <usamaarif642@gmail.com>,
 baolin.wang@linux.alibaba.com, Matthew Wilcox <willy@infradead.org>,
 david@redhat.com, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 npache@redhat.com, baohua@kernel.org, Liam.Howlett@oracle.com,
 ziy@nvidia.com, akpm@linux-foundation.org,
 Wei Yang <richard.weiyang@gmail.com>
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
 <ed17533d-912c-46a1-8407-29fd989f22b3@arm.com>
 <6253b463-bdbf-4c79-b1a7-65860b76beb4@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6253b463-bdbf-4c79-b1a7-65860b76beb4@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 774zh4k8baecpsqybx5er7jdspp88eju
X-Rspamd-Queue-Id: A0F35C000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759839895-655825
X-HE-Meta: U2FsdGVkX1+Cx9sUVmEkPXZFuBuO89hnPagfP2O5TjF5N8NJcYeVv3G1SzmP7IZXO/2kXLyAmLQ647BGd0w4J3mAVKhy9DdPnQn1VtGgEz/qHzuPSnGS4nW+tOxvbIcmpE76/duUqbKcRfQ2daE+jXutjGDq2IC8bHwInjkHLhCT6BQwQwDJNQGEUqGi7ciohZ2HmUhJpP1B0T/TgX3uRy6m9h40ulpXXMzF/yI+8HtoW21OPLnU2qzpslB/y4hLKYM8g8l6OAIBciu1xy3S+8LZG/FPQDpivDznxJKxg7uQ5sEI/i7QWyKehqyr0qw7oAu5jNPJyBOAvL3hEPOFEfSQOfdtLeeANytxo7WB6T3Wuhq16qyPmu+/uU0nBtLF6xUBaK4DHsyJ2ECeU1A15n220JuMvyFturEjL70UAw6BZtP5Jvut6FWBwp5X6eKMHb0Ci9dWlVVZkKDyxk77cMlMCiI73E5MwQF0yDKfwqpy8CLi7Sgk/P+nFeSiwOz/RAqWTm8M8TjU7DWhfX2Fj5MwCGdRgFwXopqL7d5z6MmCKScheg6g7GJ1Za/c6DE4Pd3T/BNJsaXlo0LBne8zV3oLPa05KJRTHzD6UurMkOsmISnBOWzb77gBe3r5c4BpNgnKxt/ThNvWVUUNVXZ95fs1TTn+hYHOp8AGkldjeH5428MfgI3qtrR5BrVGl+IRUW+X2S8vh6KQcy4J9NX/C4JQxyXOrWAfCUaq+s2utsj/PFPThh8rwH4N/4Pyky1ki1ygsvIiVuLZzy+RG1CxKF6s5vgQ803epB8MprQv+UAUfo6LvvsG+gn2TTDenjszvhPzcNWzu6F81W2ARvHoYnM2wHZGM6kNu4iQYBK3ngRsJRAzmHezySzgMc9kfrpUIpuX+7XJijMDQ0MIPZnAi0TSycA5/7eXVj97qFhJXUaT9CdGt1r0YrjUCd3IHJkBao+FO8A8wGL33YxtO0m
 qp146YDd
 mMOsOKvqiSCBZ6NkKijZpfUFahxUVdHCrEFykvaVXehlcTh08boTDQ9fK2WCmF5Fl0XXiXE4RM2R5QlT70z3wlbF4T7LKucQO1urlvpYUfWykjwsF3/J7Y856Jkcikr2YeuaGPZYWJQcrgurti+tREmC0wF3Uw0FTlw+6Pq+P3JHlm0jevDtzQUg+yK8oFvi9OtUISHXhtbH5I0JVaTADtyxaRRohy5howXHtFsLTxfKObdiTP31w2pV66UWELU14CqGd+R/ucT4UjvksqFozmu02alU859yagBlhvzMS8zTWYhMGKmxt9mdxixYyK7ye4jteXWSHcADAy/YGNhvjdzSkabGRquz79jhCBQxH3oE5pcz953lTFksLt3NWQN0PupH4i/zGOzdKpk22PFiRalLtK4e2gQoIjib/r3W62xl+SckZPlBsQuiT7VGksHigsVBI58wYJyfMygOPGsQuhdjCsDFqdZdtj+mBBSRtUAGwtrwqeaC2HEDpK5JvejmO6XUXXCxG954QURHmf2W6crIdvmg/mfZldkkcJYMGVpGTS37a+d095e8r1iRTdLUu4KGf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/7 17:54, Dev Jain wrote:
> 
> On 07/10/25 9:36 am, Anshuman Khandual wrote:
>>
>> On 07/10/25 6:20 AM, Wei Yang wrote:
>>> Currently we install pmd folio with map_anon_folio_pmd() in
>>> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
>>> collapse_huge_page(), it is done with identical code except statistics
>>> adjustment.
>>>
>>> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
>>> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
>>> in page fault or not respectively.
>>>
>>> No functional change is intended.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Lance Yang <lance.yang@linux.dev>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Usama Arif <usamaarif642@gmail.com>
>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>
>>> ---
>>> v2:
>>>    * split to map_anon_folio_pmd_[no]pf() suggested by Matthew
>> On which branch this patch applies against ?
> 
> +1, does not apply on mm-new for me. There have been multiple patches
> changing the same file so it will be beneficial to say what commit
> it applies against.

I think this patch applies on top of the patch[1], which is based on mm-new.

[1] 
https://lore.kernel.org/linux-mm/20251002013825.20448-1-richard.weiyang@gmail.com


