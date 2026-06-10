Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACDC1CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C185F6B0005; Wed, 10 Jun 2026 08:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8C26B0088; Wed, 10 Jun 2026 08:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6DD6B008A; Wed, 10 Jun 2026 08:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8B16B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:13:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 471E0A09AC
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:13:39 +0000 (UTC)
X-FDA: 84863893758.21.8F8C1A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 82632C0007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:13:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rci2HN3O;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781093617;
	b=3ejAsF2LWz+tAXf91/EBTyHdLgw9A2rslfgYryNh5qEs/PQ71pIsikUU1A9GSQ7kM6pDkJ
	fg/c43UuOpodPdoyHc8fSp+bFLvau1BiiOd+e0GQGIiMc1HRNehXmyA/c+i7VFCQvLH3PB
	tdBsvC8z2EGPgRlW3KfWBuP/8kKrhmQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rci2HN3O;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781093617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW9fi4n70DTe0jKQWNlCCgMLZ+31F8mfQuXRgyJyVkY=;
	b=kFVQ18rIxVPzEwB9P71jICVeOFnbWYDAcmcM2u3+wHNOY0fCPPOWdLzB/QobvdyTGsg30k
	5HlN5FdndC5gDV2VX+Aj79/Kvokjrx2F2AylWJSagsvgwQ9ildwv2X1rCHX7aYMApDArSQ
	eVQ0UNqhTS1Ns9hrpk2Y03a6Ae5HrqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEF3E60098;
	Wed, 10 Jun 2026 12:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFC41F00893;
	Wed, 10 Jun 2026 12:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781093616;
	bh=tW9fi4n70DTe0jKQWNlCCgMLZ+31F8mfQuXRgyJyVkY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rci2HN3OwO1ymyDTMsxaimtVz61j1SVR5a1HNNnAqYipxSKlcNyVnY3LL+c5Pb/ax
	 uBXF/JllYXjV1DVOaRBnh6s6SnErpWvoVYAsddnG9UGfZJnuF+PDj2nAaXDYFkidy+
	 ZqfMdTghIj2OJjDPjMVdGXwFQeYLHf9l+dyd6KkK3ncxNz6WjUshmZdJZC1LCOVHw7
	 tFHf5lAaNXIDo5fpZ2S7zTjQUaO2toCeTGXj1agHlEy0YTEcJAHfizQ2eayRRWuNtz
	 thsa2u1gelx/VznzPbkX5udLYmLm7BIIKWuIFmfvoL4OAdjpQCvp1bCn22vTlbUY3K
	 fNtm7sbTRzEiw==
Message-ID: <60082692-b7f7-45a4-bcfb-0df0b6eb6329@kernel.org>
Date: Wed, 10 Jun 2026 14:13:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] mm/rmap: convert page -> folio for hwpoison
 checks
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-2-dev.jain@arm.com>
 <f487d61c-844d-46b6-8522-375549d49346@kernel.org>
 <acb66e5d-188c-4239-95f8-172bbbb7f114@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acb66e5d-188c-4239-95f8-172bbbb7f114@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 82632C0007
X-Stat-Signature: z1i6yk67w6jc94o5tq9wm9yowpwg7hce
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781093617-808201
X-HE-Meta: U2FsdGVkX1857SKIQ3wFscGe76K45s+nwOpc7Jp8PJIua010SgrCPnqqImUhKJlM1CmJ9X3JyOOnu1zNAQ26Mt2PvDmkDWfyqHwIQsHgbtWCbafcjNTD48K3pB5eBt8wTSQBSIPw5R4fZnDVAdaexzk/Mc7zalosGMvsRXPMIpb1+XNyOrxorXlRbYeLH+6CiCXN9a94Wr3XJTwT01LNeWIE1k41KiNXzFPy0x7ZKMfyHECMr0ZR+H89oMLYBi/uVKppf3dNSL8qdGwGix4V6BhQb6iZE0rwXdvwRx3eel4VdasWjgdZf5mSx8GYtNQqxyvd2bg+2A0wJWpWl1cvCjJJeapLDrJgnA5Va3xIEcMnB7FeDtzf0ZY4B3GV1FRMYFsHW6x2Y6KhcblI+og+PP1q53bpxGvwJL80FzjYmj1lioGQg0kNXenZm4ATOZzXY2nNzwv9zl+rDTiuSpdUhohXahVXZLpSGv2iQZkbbTwtUtu6Lj4LtfPveBEWK765CpkCXN/3awyOS2T5Zufiq1Q8M4WSDojfFADfkW1jbrcy5tQPvTX9qF+svKSCp9TpkdxXwtuHPRuEDSDL8lAradxy4YiK228VQWBWEyGFUyDexZJgs2p7I5jTR7KYbQyKPaaD/Q6r8sCSWw0zpaWbjZB1gnLDOHEWyepDNBFdK+4MKeSWeFb9I8MNaneqJMgD4b1T3TENMXRagWcfx0dVGursWqbxHIz8GdjAlNZFDeOxcLwFfMKcMe/OERTHHVxMjKOXs6rhC/AkJS//Z1HjpzEpHdDT+KfKGh7pd4laX2zm3E0z9mJG69ZFxurn4ESHbf7fELNTVz4Q1aJ8Ri4DkOnABzBCLotYtmBNQc7omyHzrtp6hCbcS4YKIsG3Oio876ueVuqFK0cCgkLDwfc3KcUs1e8FKwtmeL6HO5oEp2p/oGr4SOUYeBHYyvEEd+po9UQ5CVyOBh0e3BABvWQ
 zbrl8A2v
 PtpQt8fJYNQK7vOKJD6kITAd6XLryPnKk77X2Z9SIDZIxJBIUDmHvkLp5AUg41Bcgo/TpiGLcw+HUj3BzJwIT/keFrnF14EU56EiyPLPc0WO4uai7lLjKIZY1FIRtelyvTdsXQQE1kDj4w1oHtTPtpSQdHbhnkDIbQ2/KxdeZvn1480r2h/Cr3VvTCC1zVIfKBUAru4UYJPisIze/cJg60sKgfpd8ND3d8JYGynzExuEYc1L3Eg3NYGk5DJoMxYATtMCh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 09:02, Dev Jain wrote:
> 
> 
> On 09/06/26 7:14 pm, David Hildenbrand (Arm) wrote:
>> On 5/26/26 08:36, Dev Jain wrote:
>>> If any page of a folio is poisoned, try_to_unmap() is called with the
>>> intent to remove any mappings pointing to any part of the folio.
>>>
>>> Therefore, an hwpoison check on a single page does not make sense
>>> (although everything works out because the memory-failure path sets
>>> hwpoison on the head page too). Convert these checks to check whether
>>> the folio has at least one hwpoisoned page.
>>
>> I think the reasoning is different and should better be described:
>>
>> 1) For hugetlb, we will always get subpage == head page (single PTE -> first PFN).
>>
>> try_memory_failure_hugetlb()->try_memory_failure_hugetlb()->hugetlb_update_hwpoison()
>> will do the folio_test_set_hwpoison().
>>
>> folio_test_set_hwpoison() is the same as setting it on the head page.
>>
>> For hugetlb, subpage==headpage
>>
>> That's why PageHWPoison(subpage) used to work.
>>
>>
>> 2) try_to_unmap() cannot handle large folios (besides hugetlb folios).
>>
>> unmap_poisoned_folio() spells that out. That's why subpage==headpage right now.
> 
> Should have mentioned: subpage != headpage for contpte mapped hugetlb folios
> on arm64.
No, hugetlb code always walks "logical" PTEs, not physical ones. So it will walk
each hugetlb folio only once, and always hit the head page.

That is, for cont-pte/pmd, it will always return the first PTE in the cont-pte
group.

See page_vma_mapped_walk()->hugetlb_walk machinery.

-- 
Cheers,

David

