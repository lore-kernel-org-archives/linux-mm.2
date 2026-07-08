Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F356AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 10:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F3E6B0005; Wed,  8 Jul 2026 06:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50D86B0088; Wed,  8 Jul 2026 06:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9663D6B008A; Wed,  8 Jul 2026 06:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF826B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:54:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F304D4071F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:54:57 +0000 (UTC)
X-FDA: 84965301834.06.7B68B05
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88AF9A0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:54:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hBGjxBIV;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783508096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JveTwJK57T6ULV8wGRHvMbz3OkN7QKv1Z6kFde8Y6dM=;
	b=auZIeTcYwzobByAzDcODhvmfw13+R9synDZitRI6hS340I/U1zzvs1EA07N1NwcfEoB9no
	DoM5ObNzovgaP5mo3xFuIfYD/DGucFbpFFohtrkUlUYwVj2kHRjch8qdUiyXfr1qtsaeJX
	c7l+x4b1BDIz5LSy1VsBQvtvn5GUTaU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hBGjxBIV;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783508096;
	b=U0vK0M8Y4/SJ4/VPslFbFQwHXdcOt2io2O0a/Rnj7k8ft3Z9GjwQhc3DPuZ1JMxRvkoPLj
	UM/KwiRF27HC/gEkn5XDu71HaL1hjbIMJUi9unOt6D16rnetAO8qh1H5Mczc1d06AxMrLZ
	441Ra59L9bRp2/EDhvFeyF2KmWHiPws=
Message-ID: <ca93162e-346a-4847-8cb3-cbc5baf03950@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783508093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JveTwJK57T6ULV8wGRHvMbz3OkN7QKv1Z6kFde8Y6dM=;
	b=hBGjxBIVkNpmPteQ8+ZqbJNVdiWpgtg4nqsV4oWOHTykXOkHpkIIOo89EalcDLIojQXOwF
	E/q2qOpZ1JsgypIzRkzEmZXKiFaSHjo7CLkcDBm5iAWJwogxzMZdQgKDxnxJ3lJByGFG8M
	AGsZlm6myQAIz2USBc+SzY1KiZUPC0U=
Date: Wed, 8 Jul 2026 11:54:44 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] mm/mempolicy: skip device-private PMDs when queueing
 folios
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, david@kernel.org, dev.jain@arm.com, gourry@gourry.net,
 jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, matthew.brost@intel.com, npache@redhat.com,
 rakie.kim@sk.com, ryan.roberts@arm.com, vbabka@kernel.org,
 ying.huang@linux.alibaba.com, shakeel.butt@linux.dev, hannes@cmpxchg.org
Cc: sashiko-bot <sashiko-bot@kernel.org>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <20260707135255.292870-2-usama.arif@linux.dev>
 <DJSMJDTLDNDJ.1KAP9PWH9H4Y3@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <DJSMJDTLDNDJ.1KAP9PWH9H4Y3@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88AF9A0004
X-Stat-Signature: u911waia1cgy36zortzajxirabocfzcy
X-HE-Tag: 1783508095-114702
X-HE-Meta: U2FsdGVkX1/USVShNyn6Dnn7Rbq26xXLhCq4iTXpWW0UGBjUqXEAjEK/SaXCayHmT69Ja8nU5gZ8u8gPd/Sa2GAlKoPIdSEVwQ4CSHLAf1/xW8sf/kAF4aUVj0cR47YI8cXkQtYoz7P83fgUZUneVJlYy+WHrCzHwn0zDoGJt/WkRQDChST6VOIO3Y25Eb9nQ/tIZsluGl7LgvDn0hEOg/gd3WcJBgn6iRV70zP/JUAbdlTyAQy8/nMn0c8+R4ugvHfmFFgCVCpFw18J4qEnLDgpQKc0l7OnJDGDYL5NdbYQs3kiDnF5ahIy8bodUAvADUS3pfNR8+pbWuvD5ZEa9byRnf66LzW3eT633GGuUqUL3xkyTMtBqG1BBtc44SnBjPfqTB4aH/OHLJsrdh2sHivibgPTx7basxVlGSkYWkbHTX8/yxaFgTvq8dp961+iILirPgRlqbUxIvfyP1gRuM/G7NCdYatU8F7S0UgHggMZ0O0hk4vrj1zZinAOAmWOiCk0AJQcRLXKIcwrykzv2q4GJp7tHoWYxIj8XNLIAg9VD9yIEegY8t9X78UGeyoNBjtnPmAXUeHdmJ4E46eglwNyQ2Usnuj0DVjQzUnjHBvhq4btNPrwmJfKzbfMG1UQiOQvRac5ArDUlcb1+pCnH2Tf0jCWG+PREkLTBX8cLN8yX/LDXijs3+Jj5Qn5hf11gwLf22FbJ5Kh3mXavjUKRXQ7VUNgYprR2gn5J1Z57LkV0RAdAkn7ynUpXmYYBVHFc+tpsOwuLFSU/E3XGnMJSM95Lz1IVxi7SnjPJlAzOm1aardjZa4QVNXMFqQSdU9tuk4KlhpCmXc/xVSWe4ZfoQgLwMg6SsC3KPyqoFRkjrg5MxgeKQqj26AuG2fuCtkfwt9pTbJ9ik5bRQfGLab76hhBKP9ni2sgy7XEmJxj4YiWC8YC2REuX5c3W0tKJE6dZ4BUAfXw6L/dKkgbYzP
 bnL0OkGr
 7Xv+YC1RlUg7IV1Bp+0+BYqQ6gFYScuqzEDemrTjqj87Ar4Hz7gfCcUPYJ88b7pYOjuKunPN3bk8lU2gP1ZokjnY1ZQ2UOGEYomdB1OxzsG9VHEZlTQUc1wprG9ME30k0DdUrCnFLOwBPSbgqpuhprBeGCiOwEPaNzIjcBuc2WATN1rPfDfbNKtu1ry4VHCZddb67eNHKUtj57WBGPi5DtCzzuV+Iu0FeNHetZH/MnFGpYPEK9tNcDIuXdJMTBwtsS4c9OBkDRlXR8d0BoRFVXorpOZMzWooCtwiyarTTi+5CTJcOiCWISNvXWpGwlSRLzwKGhXt2xYywkgOjJDQN0ungR/G1SV+Hk+c3/ZqYdzHmSKBW9YQcFi6shi6o5qWhm+776+y8fbCMyNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/2026 21:33, Zi Yan wrote:
> On Tue Jul 7, 2026 at 9:45 AM EDT, Usama Arif wrote:
>> queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
>> pmd_is_huge() check returns true for any non-present, non-none huge
>> PMD - including a device-private swap entry. Passing such a PMD to
>> pmd_folio() extracts garbage bits as a PFN and returns a bogus folio
>> pointer.
>>
>> Potential trigger: an HMM-based GPU driver migrates an anonymous THP
>> folio to device memory via migrate_vma_pages(), leaving a device-private
>> PMD. Userspace then calls mbind(), migrate_pages() or
>> set_mempolicy_home_node() on that range.
>>
>> Skip device-private PMDs, matching how queue_folios_pte_range() skips
>> device-private PTE entries by checking !pte_present().
>>
>> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
>> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
>> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/mempolicy.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 914f81863db5..eda817539c77 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -659,6 +659,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
>>  		qp->nr_failed++;
>>  		return;
>>  	}
>> +	if (unlikely(pmd_is_device_private_entry(*pmd)))
>> +		return;
> 
> Should it also increase qp->nr_failed like pmd migration entry above?
> It also applies to your "if (unlikely(pmd_is_swap_entry(*pmd)))" in the
> PMD-level swap patchset.

The PTE path only increments nr_failed for migration entries, other non-present
entries, including device-private and swap, are skipped. I kept things aligned
with the PTE path.

> In addition, since pmd_is_huge() returns true for all non-present
> non-none pmds, other softleaf entries should also be excluded here? Oh,
> because there is no PMD level hwpoison or pmd marker.
> 

I think what Joshua recommended in [1] makes sense, I will change the PMD code
to gate on !pmd_present() instead. That keeps migration entry accounting, skips
device-private now, and will also avoid calling pmd_folio() on any future non-present
PMD softleaf such as PMD swap.

[1] https://lore.kernel.org/all/20260707191917.3213033-1-joshua.hahnjy@gmail.com/


