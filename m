Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4538DCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05AB46B009D; Thu, 25 Jun 2026 03:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00CBD6B00AA; Thu, 25 Jun 2026 03:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E662B6B00AB; Thu, 25 Jun 2026 03:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C39746B009D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:56:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E7631205BE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:56:55 +0000 (UTC)
X-FDA: 84917678790.24.A4AA7C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94ACB1C0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:56:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sx5k9p5v;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782374213;
	b=eo+D7SR+OnG6/5rxYbZRe/s/bomuecea663vEV9qRhObIPrk8lVBvYWoYbBuRwfuJeUIkH
	dM/jnJkvsdNTI631h84CM76huJqUvS+JPkPD7rbI3Jimst9PM+leGGbHFtGaMIB296G2Xh
	+zjlKj4Z5HHlVsQlItWm1PN1XplHkmY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782374213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkLdmWeXxP7Oi0BCM7+2L8XOA1JIZ57KBqhE89bZ8/s=;
	b=JEuV9i9YeJRhhZCcf0D/n+e6BkE+YewnnZElpLTp61PG1fu2qNKnS+muU/wf40+TLPqfIW
	9hJWhoYSWVIwaIheLYeRSIPkw6kOFXMSDbC+7GOB+tEv0LUBrvY6eIJANzi3czVCc1cCqN
	dgKn6BNlBmA5vKMUpriTWz1ZCqbkYK4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sx5k9p5v;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22A9E60217;
	Thu, 25 Jun 2026 07:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AA01F000E9;
	Thu, 25 Jun 2026 07:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782374212;
	bh=OkLdmWeXxP7Oi0BCM7+2L8XOA1JIZ57KBqhE89bZ8/s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Sx5k9p5v665BEWYXTxcVC05749Bo32HMTyJnP22MWIscfGJRosgdU4N4F3+X2x0Af
	 ouRSAUStQ1CzNOywznEuK8Iwoe/YO8uA08/oE2kxQEIFDO8cXz3L/Z4pqABaQqk97m
	 0OkcRXML+4r5jCn31IloBPUwpKgaMfRv3D/Etz+yF+CIe8VKXQzQc407nRE6ETSIR5
	 1B+OMnpIEkfKlm1267ul9r9YUnU+yBTrokB6ECiwSKPqecAXYLZKZsHgqMtAj2GvIE
	 PZBm3l7NoGsfpclQ57vspDvPMY+CYXe2O7zsDrfOPO4j9a6Z4sHGWIfRi2geCmKoYU
	 V0NrO+POW9FCw==
Message-ID: <ca31c254-504f-4857-bec7-10b8c2de94ed@kernel.org>
Date: Thu, 25 Jun 2026 09:56:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260625042853.2752898-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625042853.2752898-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94ACB1C0005
X-Stat-Signature: 6kmiyrifc5ekpqsgefjsqqfkqbrg4bis
X-HE-Tag: 1782374213-270474
X-HE-Meta: U2FsdGVkX19KcVTbPrDZKsav8j0jxtYZtNhWEMBWbQN59SbPOoLWu8jIj7yutUCAM25SAGg3iciQQUo6kFeajItzARpANP0984PDpIN62+Wjtg5+zoUmECXc5xEupFcuLUHxNALMVS9ygyMOdw6anGvZ9QyYMV+G5drgIoYD67Pplsm/YxODpuUV5QX5iNvlZlnBXBNYzxKe726H6bdu3oW598Hf60uXReLBXoxviyuiHHqXj6dBNl+sZBtyBdXfGS+nbnn1C646qysAgiOt2KFW0ztRpcNZVheoES4V0NxxaP38eazYxiAOd0heD+b+h+dEi7a2zYujL2ag5i5avofy/qE3vDpwXjlamgpvxZDgLePtxNEZWePexEk8sgVwNZwns9nCOIxY2t74tVvkDpBrl3hDvu+Lec9xECknMLkgDz1YaeKfGbEPFc4Tec/78ie9cRzdztpmgV8oNaxjLGrtOxtTIjuEyYdVmJvq3uagXOb+h1cAzgUtDGpxQstTLMKMtRAByaasU/cXnq7oZQ+Y4j7M3DdEDnFGE63+gC8pHbwvqepjmhMxhL6I+m/bhiyEoXXIyGlTvRfXT9HMxFsq7Dt0HVkpzF7gJ4qBNZVeLAOcgu1+U9X4axtGeSVAaZfyLYU4/1U3w4XuzWZ/eJ+T3HPDdYV00RqZdA1HquPujI3pb9KikRmIPGjLDfPFRuRYHkjH4sLE5sHBrtJUv733/RMXfrWbjK7GT0mwXfBZ0WK5Xeqrnb51pErI7cvvKXXaVw2KABcnvB3mh2gSSMW4bCNPuAXTrIi8PjmizVfYEn/GH/9ajXXQRLslwWwOPmVr88d3FDNNrgAc1ilZG1BX9QBPvdVnzHtgpk83v2nW/MByhQW4rWlAUCPQJ/vRoD8RSuXJIbHmyN6eCIuP4hTTbjyUlZGNGwLM4Bl9XN/cAo4yvdWs/Q9SnxpaAxMniw/Uw1tFk/aMx5lSJQd
 xqiMaJnH
 /42CJZnbdMqKLvbrBEZ3MnBooi+AQ2BD+0FHTjAXfTi/1k86D5sCi/HTAHpMc6ni1R3qCnuRsfwURNmwEt9uDQsheRgVkOFZNqLtCrHlE2ZHL0zhWODmScbdFGdvdgQTH/dBIwUw894VKaIKzNtxeXgpKdKwi/QhbiLAzJ8uW06F6ew9pTXSyTcfkQWTZqDXouavnOf1JPGdUwym6Qo+R8HQS/5+R+wrM6uQpkgfY8oH2tG0syKx7yw6MdoImEzkzEKC05GTAsj6+cL7YMWWAzOp5oyERJ+/zyEsyM2JWhJmCMMS33CCpJXNfZwTRCJeQjSqK5/tQUVZk2PaMmEy6uMuVaeOdBpO8p6e/JI5IjSmWgie0bbB/9lTMKZ9biUjTJxZgHy5nb4Mu6X8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 06:28, Dev Jain wrote:
> try_to_unmap_one() handles hugetlb folios when memory failure needs
> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
> case page_vma_mapped_walk() returns the hugetlb entry in pvmw.pte, but
> the code reads it with ptep_get() before decoding the PFN.
> 
> That is wrong on architectures where hugetlb entries are not encoded as
> regular PTEs. On s390, for example, a raw huge RSTE must be converted
> by huge_ptep_get() before helpers such as pte_pfn() can inspect it. A
> raw decode can select the wrong subpage, so try_to_unmap_one() can
> install a hwpoison entry for the wrong PFN.
> 
> The userspace-visible result is that a later access to the poisoned
> hugetlb subpage can miss the expected SIGBUS. With DEBUG_VM, the wrong
> subpage can also trip the PageHWPoison check.
> 
> Use huge_ptep_get() for hugetlb mappings before decoding the PFN.
> 
> Before c7ab0d2fdc84, the bug existed in the form of a plain dereference:
> we would check the head page pfn of the hugetlb with pte_pfn(*pte), and
> bail out on mismatch. This would mean that the hwpoisoned entry will not
> get installed.
> 
> I am not sure what is the procedure on such kinds of very old bugs - how
> back should I really go?
> 
> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Applies on mm-unstable (d17fe8a046a2).
> There are similar old bugs present, in try_to_migrate_one(), check_pte(),
> remove_migration_pte(), prot_none_hugetlb_entry().

Yeah, we should handle all these cases properly. Can you send fixes?

Using ptep_get() on something that's not a PTE entry is shaky on some architectures.

-- 
Cheers,

David

