Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D055B606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BNoPTNH2
Received: by kanga.kvack.org (Postfix)
	id DAC616B0749; Tue, 27 Oct 2026 09:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D476B074B; Tue, 27 Oct 2026 09:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28316B074C; Tue, 27 Oct 2026 09:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99B266B0749
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:37:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A2531C43F2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:37:13 +0000 (UTC)
X-FDA: 85368507546.18.8108720
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6EFDC100007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:37:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNoPTNH2;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793108231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xeh0h8/al9334KMAYnmna8mlBpnyruhKQ6eKh9bOxag=;
	b=y05KZB1iUDsckZ92PmG1nOLcUMvVbZ7mgZ1xADoMd2oZl/qZm8qefdmNT241OplrlI3CoR
	UtPYfX5kCTgey1Xm6Qa2aVluYYChYRUMwaUnblekYmMSb/oMJkE0U/GLIyuYWmwTpTr24K
	g8NXDPChvQJLTfD/WuCEtr+XDbrZtsA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793108231;
	b=tLxkra8OOnE1Ilcd7lwE8b2DLTzvAimGF2rGDvUdCrITKef1IRjHakzClwLzJHTeiJNWjR
	Yrabc0Wyhl8tgRLIrsDltYtaY2TYiPf9CY81q7SPPCkZrIk+emRX8GKQaSiADYRoZNgp3W
	RFmWUob197lXcQfgtco5efTuLLbkYTE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNoPTNH2;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEC84601FE;
	Tue, 27 Oct 2026 13:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAB21F01825;
	Tue, 27 Oct 2026 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793108230;
	bh=xeh0h8/al9334KMAYnmna8mlBpnyruhKQ6eKh9bOxag=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BNoPTNH2mY6hAGlBSJMX1nCiPi/BoGcEcnnfFq6+h+wDjw1G0y3hs+ebQAtAiOELD
	 yJgwrrd+Ds0GpFEn8jauqMs8Ehpf+VQDtoj4/b6jGVizI7Ad9DgH0pv2uuAGGif266
	 OEHVIx4AvTC1axwF8GssWq1nVxDxxYHCzUnB9V7JIgH/pNrP9bqVUhtnJW/Ac4lRbX
	 fIDxYERC1b21qEqhiEx+KpoEDgSx9BuagIKuqrxTN4GJvtB90vSRNFLEQgrldSHxxm
	 LsT5zfRiRhFmJ0HPZLYF4fdDqnqwgIEqAH7zIVU2uyHIUGvEyYpQ3IINiIuWcUgelT
	 o6ASz9eiq/Z3w==
Message-ID: <a4fc92b5-7d99-49f4-94ac-89fdee699042@kernel.org>
Date: Tue, 27 Oct 2026 14:37:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm/page_alloc: don't undo another isolation in
 alloc_contig_range
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev,
 iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-5-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027042204.3741307-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6EFDC100007
X-Stat-Signature: pdotffsqzqexbbpuw18oxpn6f8thjxwd
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793108231-537711
X-HE-Meta: U2FsdGVkX1/bm5q5Baj4YaPPSUbzlyzniqEW7oN32GHyHRGlCMMzIq4bZ81C7bIiDsIP3krRodeS+9QP7i3+OVWqdgrhsZrQLwkVYSjbcTHBoeyRicFEHxbibXoQ7AcIwkwuKBkEnR+yIlzQaDja87dmn6sus57FqMvC3uxHRj7eBiJcIdQPyKIX2ZQyeja8og47j/RJ2PAI8U7Z5HlmLArWUs7YSvyS3vp9JyHHVlJuNw7wRNyjWG+ll0tH3wYXOXIuFpWqFhLmAazh3GXRvHshn4N8QuCqpvGqbc9e/cy4eCADn+5EinyG49t7aPX1sxlmlXN9XyXeRyoanGpNxoGm772L6h30TH4AbcfN3mNPWRyF5n+1qoiWQQTdRf6IHM3ikDsWZbWORm25r2IQNzAFwwrAox6OVKRMY18Re+J9eTONOzJ29k2Z2Ay+ACt87mqhyU5T+FyuOCQv2cIpWXamc7Ppl/q8kAwKa9R+fcquytnm+PZJmpJSPORK5P9mETGSjeAMSiB6rWe5TZ6Y1o42a2cnUDS0kK09i8Og2EjFUFonwSwxHhzxMEzC9wwbh2n8SxfI4zz+vTBLO7JeyFzOkLbAKsZg628E9O6DySPrCRjKVyCMA67pi5FVR3v0eTf4VLEKXoDm+Mdg9DPEg1JsHCELIcECHKZnAjb+9sx2+cNtDsIG7eyZu2IFqDJb8GpHmL9aznhRwbqEUhTCedceRDxmWctG9mYuxDeelHUTYT/Mlk+uvkQnPa/Z+1rA44xu/k66GLZhzo3NAyL1ZaSdsMfwPGhRpeMnoe5QEuBxljUXV4q6Kt6JF7emGxAVYhS4bTCMAwBw1cf2RgP3mHex86t4IGoHhVU7Mab9oTXVNKwcKUOgIETZFZo19Wcu8ho6SfcYdQq3NOvaglFGSWdYl5ZIOnkvXzJL+AAsig0tKRQJfRvfxzDzekdUY9BHkmNoNpmy7XsX5t89Y8t
 Xuk5bcwk
 kqz0RdwYY3C9epcbr+o1wsRTRBS+YYC6J2UjeWXK6Djy39s9E/2g2gwcNJxb44FfCtcIKu5r6qnfH5LbRQDCEUA7SuJ4bNlEl9c1ZKMxlF/VfME7LbEIsg6SNNYR+5fQkuQFnp45dUZz/ZObjj+RME1LznvJrNNF8WgGfpKO3zXDV5iMaee0p6EqSGVe/dVQ8oud5oxCHcgBQcL55lgTIVVE/ZxNhVUgAy8pvt2BYYhwYkkZ1YW+In0cqVexJrr/iVccoQXRSYykUClt5OrYtnJ00dnIsCx4Fp5vnFhf/boKohXhkE+tO81X7TTwbwm96v04v0ePfnN9l5UvkFXVgouUhOCVegvEigHjMq4sjPTMQgoM81EEAEDxoECqBnHthyGVLOpveyu/gw0t3C/KlKPEzPbyBEcc7r+9/lj9EE2K9gidofxx71YjFLeQie0bkLL/NOUeS4I8Fyi4jcpfbr7620w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 05:22, Gregory Price (Meta) wrote:
> An alloc_contig_range() that overlaps a block going offline can leave
> the offline spinning until it gets a signal, holding the device hotplug
> lock.  When isolation fails, alloc_contig_frozen_range() undoes it over
> the whole range, clearing the offline's MIGRATE_ISOLATE too:
> 
>   CPU 1 (offline_pages)               CPU 2 (alloc_contig_range)
>   start_isolate_page_range()
>     blocks are MIGRATE_ISOLATE
>                                       start_isolate_page_range()
>                                         -EBUSY on CPU 1's blocks
>                                       undo_isolate_page_range()
>                                         blocks are MIGRATE_MOVABLE
>   test_pages_isolated()
>     never succeeds again
> 
> start_isolate_page_range() fails only on a block someone else isolated,
> after undoing its own, so this undo only ever clears another caller's.
> Return directly, as before alloc_contig_range() went pageblock granular.
> 
> With offline_pages() parked after isolating a DIMM block and a 1G
> hugetlb allocation made over it, the offline on base still loops 30s
> later in 4 of 4 runs:
> 
>   offline_pages+0x5b2/0x1570
>   memory_subsys_offline+0x17e/0x470
>   device_offline+0x250/0x340
>   state_store+0x88/0x110
> 
> With this patch the allocation still fails, and the offline completes in
> 3 of 3 runs.
> 
> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

We have an existing AI fix for that as well already handled by Vlasta.

I think we'll have to establish some model of "ask David first before posting"
because otherwise we just create duplicate work for everyone.

-- 
Cheers,

David

