Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39B8CD1A623
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E6B6B0089; Fri,  9 Jan 2026 08:26:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C546B008A; Fri,  9 Jan 2026 08:26:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDAC6B008C; Fri,  9 Jan 2026 08:26:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 411886B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:26:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E59A51AC77E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:26:15 +0000 (UTC)
X-FDA: 84312499110.13.8B3D9C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 002AE1C0006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:26:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EC11Tbxf;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767965174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGGUJRc5W9PjkPDSow9ZwoIBiKmD804d9WqiLU62KGQ=;
	b=G+kcSH4z/fZW9QY1leLUnAChmMhUdkKSA2ZG1NsU2srcz4Hd1rwOOGI/35zQPhfFMCmuyv
	2wc1qu6iWBwH8Wy3mEbvaDZV3CpWft/z2wmHte/OVHHRniPLxlcd0S3mjnNLvWO8s0YYoE
	dDK7b949kdVF3aL3zt/bDb/DiLAV3CE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EC11Tbxf;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767965174; a=rsa-sha256;
	cv=none;
	b=BmuYdQzg31IIMJwsQpybJQiCP5m61em77h4CLYSVwOI9bjLHqCni6ZKNlrczjnZiU8Vtjh
	mRyeDjJke+UrVQfZgqpHcoqwZayFyp15/RKo4j5/f/kMO+hsq7bgBxkpp2gnKXn28eK5L9
	OFdLMwAOdKSMiwJFC+vsjHAfHI6NA7k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD3D643524;
	Fri,  9 Jan 2026 13:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDB3C4CEF1;
	Fri,  9 Jan 2026 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767965172;
	bh=rSrNZz5QuO35JMfXkvRl29RhRhrRLAhpa1h/+u6Awa4=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=EC11TbxfibS1rBJPwUU4vRuK8VxuKYxP9cvyX8DaK2CEm8mfuCEZOQwc4FOovjNzm
	 0dHm04BVq+fpWRcZQY8g1rtsOtp1Th8tVI9DF5yvZzC8om5m8NAUZaMgicpbOGGbdr
	 vws+agyWs6qGOT/DwErVkiWe19qf9F1K+jkIvgs89LwjCIx+Cbd9OUgxPlBjx67hhw
	 3D8cDOJlkUpuw7+OZb4MrDTdHL0jr32bSoJgFvRSfgtnSw6obeGFwCMgv+OcTPTG3U
	 cfDOcjYLTbVrw7QYMEsq/4VzoiU6E/DXEKBqyu0kl44nimp8bCQoDLWLIKihODpLcE
	 R9JyrmzsmDy0A==
Message-ID: <1319a24a-bcfc-47e5-a022-f5d00994acc9@kernel.org>
Date: Fri, 9 Jan 2026 14:26:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] mm: Add folio_split_unref helper
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Balbir Singh <balbirs@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alistair Popple <apopple@nvidia.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-2-francois.dugast@intel.com>
 <59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 002AE1C0006
X-Stat-Signature: t1zhjx7bxn7o3h74szsnabpbpzdbi1co
X-HE-Tag: 1767965173-11433
X-HE-Meta: U2FsdGVkX18Ubr/BItgALwVGzyZkJ0UV7dqiQxrZneqx7Po4zCYybdYGFwzdzezPvQMgfnTQhwgNhOnBKKW06k+TTYLABmhixhmlqGGdCCcEndjufSvsV1HDL0Heb+K3P6KHy5qS9CZqhoFARI9K1KARXwuTCO04Esn9X/K1PV06VZMzXnP0j8Hmm0rJo1vDfUyU254W2+rTsKxzq56G9wF4JNUOyE3K9PptLO/2du12uA/PiUGzyecW2gNpNJKpDKAEuDs9XmVlxkWPcNPmcquhtak31v7FImY0NzADqp81r/N4m1trRi58lQBJ+u4/MHCPnu0Jul1idaPmHIgayNXFjs7OiD0wyDGz8R/IULwbf9YfjDoYHbg3zeNvjwNqPa9hr+e97+6FNdODoZ/fzbb1HZ0w/B1O+dtjN99p++kGw5XKVNoz6DIV7fGazw1BfKMuebfHx+NA1WiwxtffpoVa+suXz0gmyMkLJD7CMOOHpZ2gsEiK9jz8bPYkju0IOBMxuFn0mhYD0k1HwjS1tw3gbTPmqvnKGzcovU7kEmStSrft1PnLi+jSDyEVrGV5cNWbcI/BO7rybCkLyWbNWBVhDRNi+4lr5++hJV73AxziPXDe8I8HSshTMVyPkb3VtqWADoiHyg1FSapnn84YmGedLWK7y5n2SJVUGLpaVcyzXWBrQIZm3x9qPHdRJksMpxA70gdS4jJVm6RXSI4FezgvV1UH/N/NdvNTX5pzkLGuGwBxcpvz/Jjqs1PPr/6TQE3Gqptcguhc/dgWAVGRpq6F005GoMdtABgM9Oq+HO8g/O9I1U/KF21LXAylsCCeAGTQ+x44PhgvaviflMfeBJ8rwxrbMRZmLCABXBQJni/+WSFTMBNjqs3Ym6Vg5Vyv+rY40PjsQnrqWL7yhfFeJk07pFyNiJwUE4ejTp5yZXPKTgWRZUluiJJguXlC7Lzk+h88L9v4FFVFrIZmIuI
 +KHGwL6M
 nRiOh0SypjPPo5C6cU/X4VUfiqlGeah+v7aINzz3VMkHmNbgfQBjw/HHrs04TT+Cky7fHtjy5eHvutg7ZY6PSHuxjadwWLcIoGIZIVrPwRBSZgs6m3DWhe5kC/MpxOrL4rKVKDwMeGAJrQJU5LL0ykjvrrQYCvE7ZdCQM6/TuuxPbrBXLNsobdVr3+wyu87Yy4X1dLeMmbqC/JbLoi4zl3ewWBhxGLQdi0n/GzxSS+brG7+OpjfKAEfBeOuMnBlDRhzOaAc1eC9zivGuECRywmrQPyMXDFf+0mGz41VD+VsdpWjR45mMJlmrNUvJSkkIW2yY0KJjVz2flPTQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 14:19, David Hildenbrand (Red Hat) wrote:
> On 1/9/26 09:54, Francois Dugast wrote:
>> From: Matthew Brost <matthew.brost@intel.com>
>>
>> Add folio_split_unref helper which splits an unreferenced folio
> 
> split_unref reads like "split and unref".
> 
> You probably want to call this something like "folio_split_frozen" ?
> 
> The very definition of "frozen" is "refcount = 0 ", so you can simplify
> the documentation.
> 
> Are the folios you want to pass in there completely unused (-> free) or
> might they still be in use (e.g., migration entries point at them during
> folio split)
> 
> So I am not sure yet if this should be "folio_split_frozen()" or
> "folio_split_freed()" or sth like that.
> 
> I'm not CCed on the other patches in the series or the cover letter, so
> I don't see the context.
> 

Ah, I was CCed on #3 where we call this function on folios that are 
getting freed.

In that case it would be acceptable to initialize folio->mapping (and 
folio->index?) of the split folios. Do we also have to initialize 
folio->flags, folio->private etc?

See __split_huge_page_tail().

folio_split_freed() would likely be best, because then it is clearer 
that there is absolutely no state to copy from the large folio.

> You should describe in this patch here in which context the function is
> supposed to be used in later commits.

-- 
Cheers

David

