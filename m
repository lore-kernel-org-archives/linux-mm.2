Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124B0E67A9C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BB06B0098; Tue,  3 Mar 2026 03:57:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673346B00A0; Tue,  3 Mar 2026 03:57:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F8B6B00A1; Tue,  3 Mar 2026 03:57:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 461A36B0098
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:57:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1C501A01A0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:57:34 +0000 (UTC)
X-FDA: 84504148428.09.7699F44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 098AA4000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:57:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5hEK57E;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772528253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQVdpyAxGlM1YPV7PDeEkdjRnKKAH4t4mzPE5RmFxrM=;
	b=toQVGGqlmX6+B9L83WZ8jypwRsQU2XEfjlvwc2dwuTo9jxuP/Vvq7+mHmqvNg9ONg/PCDR
	KMIyx6/iT1CJwZPtv0smNxAlklo2sBJsutzgS17x/I8uGCIAwBvcK6zYkjiO+3qdZK0MjE
	5b9c2fto9ucdarJoXricy9tZzvGY8Ug=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5hEK57E;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772528253; a=rsa-sha256;
	cv=none;
	b=RurPm89jePfNB1dQCx3dw8mZbumCwvfmYQHtvZPVWjc0TnqhYJi7LSU9Q/9NgmaIhUiNXV
	owtsrmEP7VwmFGwHtupn5ZKK5oUR7jHHzioxnnz6IqQpcRLB3+e9tBISA1+4m8ZtdUHtpo
	KAJIbKpfBQDD88F7PZoLA866cpPw52s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03D5A43EBE;
	Tue,  3 Mar 2026 08:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EC8C116C6;
	Tue,  3 Mar 2026 08:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772528251;
	bh=9iVkSiANjtujwUTPjMcA7Zj0OXuBBdA6W+TyRsKkQnY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O5hEK57Ei8XjMvC7hpqZ/a01ted5za1wlZJWLHFpSnEkGrdR8c7fp5LPt7AlzdGmB
	 o7yVyqgFloJBFvX+xCgz8g/RR59cHBa4bwr+RT2DtN5nSgqQCiCKWwngsrB018JcFZ
	 i6VS12Vyx1rS8VbQajaLcmD+cKS2QiKEjFf/n366wr4Rh5HWgNmpLT68fbQ4dbF/yW
	 CPRh48YwWwx7IxSybdWZSYnvvIf6xcXbKrab5qJk57ofvT8cqm7ot4HtZI53Vrufe2
	 wm3Vhlnl3P0ZHwIiJGi4LRdtKmMPAYFaD2BCxl5xlejc2RaDfQGDFIEZFFnydTzVAP
	 a5e0zcLHMVIrg==
Message-ID: <e2f163d0-db70-4484-b8a3-48e1a347288f@kernel.org>
Date: Tue, 3 Mar 2026 09:57:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] mm: support batched checking of the young flag for
 MGLRU
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
 <f84233f95f209d59c3bc9c72a757af09337f0d40.1772185080.git.baolin.wang@linux.alibaba.com>
 <7f2973f0-0a34-4e4f-8ed6-13c531f77453@kernel.org>
 <3701c315-b19c-4c87-aff3-cc76e1009a43@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3701c315-b19c-4c87-aff3-cc76e1009a43@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 098AA4000A
X-Stat-Signature: 4ew1fafbmckdeawhpentwoiumbohihzi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772528252-498520
X-HE-Meta: U2FsdGVkX1+sI31+hVC1pO72PhjhG/jgwuH8UPmgseTV6h4pCUsZheF1BAkGaa2+orrj7MWp4wH70/go9G47n8I8GHSqtSSmaj9o3N+zsXq5Ryn2DYK8uPOsVxMzZYMJD5mYjzjK4iN3WE7C7WlMmWfrLsEWfa+VGwO2WxtImVKhH5ZqBiNvO0TzYMYhnmGT23ssklfqfK/ebd3fWlz/LggGgLYu6/IZpkcaT2usBb2oOSxMsveESxtVlZHoWcKxn7aWpQ3YoeJPLa1B0Lpa7OySFiZtS/5kRtM0+jyhTkCAZVKf3UDfDQAkpwq6yZYoIkIWKo/WS4ERhNCG8YhZ6K5ghVKpr7b30JnElQ7eww+XXkHCNeGK7IsO/VO2perlr2SJVJO1dWBL7IOqPE/s081ORLvOoj1QSFLWzoo0lt5NpgVGycg2gChHzps1TaXBJ/zX1rzwoMlWRBF46xGgeWOmDcAZv584jQ4MIxlTQkt6Vxu2E8SXDS6NvSLTBIGOocNCey7RRHU00V//iSXqoL251pcorDLbAt/V8iHbIBi5ASMXWYrPCXjg/oqU0FBU/0/wMbgOp9E1pfzY1DEWHBcocnD3SxaTkxrxJPTwo/TegA2t6T9zKgYA7zL3nhenM+V0SugBjBcFTWUux2jAmXFB7Z5K2VrejUWr5iMsDX4dEGQ5XS6ypLz2MrEHqtXC/9F8R7TRWU0HsYr0jrsmO30spU2LYFikd8umfIMHCKCdB02UU3FoiuK677mSwFj2mn42VoBS+ijJx24N1J+fJqlGcvfUEeSiMkmhboZysHKVW96Rj2BQwbb5Ma3JJrS4ptW2V8ybTDv2d9EOd61WE2RD+mHjN8NdPtlHOgmT+ZSlWeYsKSKQZskasomWihis+1zeZY90w9tA/LWIab6lpS8uP0ZM8K9jfoxlMtwph0VpAis/uEGIjnxGvqu0jUE/Tc3VnaMlWGwTVHWZTf9
 sDFsf/Uz
 /udUERDbT+Ss5AocvFnA86Xvomk4VdrnhXGq2G8jyzkpMeYj0WNOYyj6T0Phgkjxpi7amRa9d/7fMDeKsNGi47WF4j4vsQPxUmm4+nkLh+Kli1F2OfpPb2mm+TdBuNM2FikxMMbeIPNbomODpBq2b7JFTNY0SS4m1w/GgRogRPkle0mA7o/MZ762LtBsoVV9tamT2Di7N4Wd/2QGuGSAf6juE7DKIgie3nmPEOKgJQC+cUsAI1GhnBSkWuQXwpDCnm05g+TzX8hv8suE+0OZO7zpwkc//zjwzdxR/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>                  unsigned long pfn;
>>                  struct folio *folio;
>> -               pte_t ptent = ptep_get(pte + i);
>> +               pte_t ptent = ptep_get(pte);
>>   +               nr = 1;
>>                  total++;
>>                  walk->mm_stats[MM_LEAF_TOTAL]++;
>>   @@ -3533,7 +3534,16 @@ static bool walk_pte_range(pmd_t *pmd,
>> unsigned long start, unsigned long end,
>>                  if (!folio)
>>                          continue;
> 
> Thanks for the code. I considered simplifying the logic this way, but
> this logic would be incorrect. Because the 'start' can be updated by the
> get_next_vma() below, when we goto restart, we will get a new 'i' value
> by 'pte_index(start)', so I kept the 'i' variable.

You're right, that's some horrible, horrible code.

-- 
Cheers,

David

