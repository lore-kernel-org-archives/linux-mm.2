Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B776CC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B002D6B00AF; Tue, 21 Jul 2026 05:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0716B00B1; Tue, 21 Jul 2026 05:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979636B00B3; Tue, 21 Jul 2026 05:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 662B16B00AF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:20:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4AF040426
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:20:19 +0000 (UTC)
X-FDA: 85012237758.12.CC3A9F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03980180003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:20:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bw5OEAe2;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784625618;
	b=e4zYpHpSL5w17+8nGYj5p61Igv2O8M0MBW16JwKkQpErj4Bu/A5P/sJ7mfS4aX7h6GC73o
	i6tWBfg8BSvSbsZHidfWescQ1usSOp/oEn2FlKsUhicYwpat8NaaBiZzu6q8+CAw9K4g5+
	DMCYECL5qqBbGPdRQZBK1aCctTobF5M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bw5OEAe2;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784625618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXbi65g0B2x3zSEY3/jiZ4q6NSDtzWd4WeQahT18Nm8=;
	b=2nREK7C45hXs1BcbctEdj55NOQFwnaj2V4NG6/5VazzWfEGIyIE20N9RYc5NoZ9B/4/S53
	LQvqEqdbUAmthtqAgO0Xl0QQsfT0ELV3bvFuGO1qIrH0XijRsHnheCpyyz9FmMKXnD/FXq
	ABBIdg4dtA189AiJAvzn4+/hpHMZbdw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 319BF43A37;
	Tue, 21 Jul 2026 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57911F00A3D;
	Tue, 21 Jul 2026 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784625617;
	bh=RXbi65g0B2x3zSEY3/jiZ4q6NSDtzWd4WeQahT18Nm8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bw5OEAe2QR/KdmtZ71poTClbJsrEiBVJ/goxjbCH9efpvu50jRYD8zq8hbUOwOYpA
	 a3To6pkAdT8nhq3oTSkBuChpYOURbkETb6xN1sXW+hUy8Oqrfya5K5tdwkc5p4x4DY
	 7C6Zk4NAUQJLSaI7MuvFQrK79x1JkZG5wk7soKjmyS/D6J6zaHfMpCDvCOEoignLiR
	 x7ivuy/MsauqvrCuiCF1oGpDXoe/dOch98Ul8FuxUR3ebVEzEXjopke5FYmLw3jV/Z
	 A4EFiXkvrqGM37n+66VmBl8OLX90+n8hzRaNfVAFps/cSf6U0Yxw/hv+2XklT1q12G
	 veSMpIW1blnNg==
Message-ID: <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>
Date: Tue, 21 Jul 2026 11:20:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
 <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oi43ezdedst5jk6fz57qkf5b9odrjmhw
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 03980180003
X-Rspam-User: 
X-HE-Tag: 1784625617-59315
X-HE-Meta: U2FsdGVkX19cA5x1SMK26ZVyNcQigOIdLE67Kf2QsEcnaovkAUpKDvjxLcOFYwhPdvn5+ZvMSZW1WCvarg1U+4mGT8mC6NTWX9sj9DP5x7AqAJ48hR3LKvwB/szVQa/iMsc104SyxFGNtkhpUiahPiRfmvdUepQElMXTPqlL1a6J47zal8CnnRdNTYoFYOMkIVgSExjNIR7oKzmgTfTLlaZnIqK09bcCnCxXw4u06oSQnUjLA3B1xwjq61YexAxCw/RGHBzTEkVSK9/6oQ+k9qG2gOEu8ekeldh0HIvOMHhtfCZ3qKZzpvfM1s0nna+1n35iSq7DCUcsq1MpBcxL1WmqiZqSg5cR0yvAzQbAFi3s/KxmMs9fZubOkpCbAJ/QRXCNimuBS4TqgmRBDNyzchQj5K88+tN7xHkHZJGKOgE68vCoJY7rhA2OzeF+xjR5iIngkBIr7Wey10OXShMr+j+JrTlm41rKkO3oqg5s2sjxIxfiMY8r9NXrLkUI7lY0abrzpJM5i7PIWKOqpdzLDFLU6GMXDkKSzbzD38/VLUTSUhJVUgVYfao7QaKtxi1CBumpvTxPd3xs4C6BnDKkFZk62FdkdtIC8ec3bN353C4Vk9/t+smbCEhg87Ron1bbK2Ls1rUpuvSyRKyrb8yGq/UdyHrfKOS3TmSUXaHnGPohDHymKB4cInIvdq8//PCM9lrJvyqiFARcgYSireIQbgb8Pt4kSVtymKZQhajToWyfUUtbOydH2UK1tfJumzJvW5dsm8f+muyMrzOj42aKcKbO5QISVKu8qc/y0Sz0a7rMv84OFQT6PONy65LihW2gSQpzN7YsxEPmkjn4t33QCaMddamm3R1zoFJEB+vlfYuMgazRBA5mf5M75rLp+IOW28sT3rdOAr4DgNjncqVtvnVr/fzTqTmfPILcpxxMY38gGTSw8Mk79M0wOAfHnFXkhtUxg4QA7jUCMgcdp/R
 VjTXVoQC
 59JQlS1mg9o7W4SHLZ/z98g3Ov1f2Yd7tyR0mgPW401vYAxx7eYZQ6BWUTxfVcJ5EJ73b2VWIsoYNd1o6N0c6NjInWlL4ioaw5gAtFYzvH87mdshDjqc0uDp42uU2fTiEKatbob3EP9bL696zsp6fqlhQ186sdX2GqcyEtolebdz+lWsUfLhpR3zFIxutKhQLVf+06TC5sVHNm+x8kstulGOm/wy5QtgwqBKmBiRqVx3fa2X2OLlDCPz0UjrFQaRRzrOmwPhUbakgiIP7fiKga6rCNsH5P/NPbEGc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 07:43, Harry Yoo wrote:
> On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
>> struct kfence_metadata only contains struct slabobj_ext with
>> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
>> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
>> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
>> enabled, it will end up allocating its obj_exts via
>> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
>> These will probably then never be freed.
>> 
>> So things sorta work, but not always in the intended and optimal way.
>> The upcoming changes to slabobj_ext layout would additionally need a
>> proper refactoring to keep working.
>> 
>> However, there's little benefit in accounting KFENCE objects. KFENCE
>> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
>> (default to 255) outstanding ones at any time. For any callsite
>> prominent enough in the memory allocation profiling stats, allocations
>> served from KFENCE will be lost in the noise.
> 
> For a similar reason I wonder if we can drop obj_exts completely.

To make it clear, you mean kfence objects wouldn't have objcg accounting and
would essentially behave as if obj_exts for them could not be allocated.

> The idea that kfence objects might have different slabobj_ext layout
> isn't really worth the extra complexity if we have very limited amount
> of kfence objects. The amount of objects that escape memcg accounting
> will be quite limited.

Indeed. I think the main point wasn't to have everything accounted, but to
avoid specially cased kfence paths.

But I think this would probably just require adding is_kfence checks to
objext allocation paths to fail them, so that's manageable. Should perhaps
allow moving some of the checks added by this patch to more generic shared
places.

> Any thoughts from KFENCE & MEMCG folks?
> 
>> Thus let's not complicate things and simply stop accounting KFENCE
>> objects in allocation profiling and skip them in the related slab hooks.
>> 
>> We also need to skip kfence objects in mark_obj_codetag_empty() in case
>> a sheaf is allocated from kfence, per earlier sashiko review.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  Documentation/mm/allocation-profiling.rst |  7 +++++++
>>  mm/slub.c                                 | 11 +++++++++++
>>  2 files changed, 18 insertions(+)
>> 
>> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
>> index 5389d241176a..d02eb54ee8f2 100644
>> --- a/Documentation/mm/allocation-profiling.rst
>> +++ b/Documentation/mm/allocation-profiling.rst
>> @@ -112,3 +112,10 @@ break it out by rhashtable type.
>>  
>>  - Then, use the following form for your allocations:
>>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
>> +
>> +Notes
>> +=====
>> +
>> +- When a slab object is allocated from KFENCE, its accounting is skipped.
>> +  KFENCE allocations are rare and limited to a small number, so this omission
>> +  is negligible.
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 0337e60db5ac..76acb78f2655 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const void *obj)
>>  		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
>>  						       slab_exts, offs);
>>  
>> +		if (is_kfence_address(obj)) {
>> +			put_slab_obj_exts(slab_exts);
>> +			return;
>> +		}
> 
> I think we should check this before get_slab_obj_exts()?
> 
> Checking if the object is from kfence after slab_obj_ext_codetag_ref()
> looks bit weird.

Hm indeed.

> Otherwise LGTM.

Thanks!

>> +
>>  		if (unlikely(is_codetag_empty(&ext->ref))) {
>>  			put_slab_obj_exts(slab_exts);
>>  			return;
>> @@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
>>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>>  		return;
>>  
>> +	if (is_kfence_address(object))
>> +		return;
>> +
>>  	slab = virt_to_slab(object);
>>  	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
>>  	/*
>> @@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
>>  	for (i = 0; i < objects; i++) {
>>  		unsigned int off = obj_to_index(s, slab, p[i]);
>>  
>> +		if (is_kfence_address(p[i]))
>> +			continue;
>> +
>>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>>  	}
>>  	put_slab_obj_exts(obj_exts);
>> 
> 


