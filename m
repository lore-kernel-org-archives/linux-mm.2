Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85330C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411226B007B; Fri, 24 Jul 2026 11:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2C66B0088; Fri, 24 Jul 2026 11:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28CA86B008A; Fri, 24 Jul 2026 11:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D815E6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:58:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 601A31A037D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:58:42 +0000 (UTC)
X-FDA: 85024128084.17.69C5A84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id AAF9340009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:58:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ShtoNFDV;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784908720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFqqg9i7LZjv08q4O6WVX5vzanG/kxsPHPC8mdLPdug=;
	b=bKlPdunrWCg0rG+enKGLdObocy+aYs9EWFJGXQo8lmAWVLdubbSFVfA33eLAWlVtlXfsfY
	vwrJZnN0gLVP6U7q+EIQqJHb3P8k0wEH3h+F8jxlkfTV6fVOfeZ0EsMAGuopMpz2ugf3Kf
	k8+cg+PLa7BKOcRIIwI41h4g1/p2LE8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ShtoNFDV;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784908720;
	b=gGKYPTW5tWrucpEdOiAQo19MVbcOjCUA9PW7xNUu50rYDBCRA23Njxlohda+5dlX8t5J/w
	QQR4xIe9x2B69akFv3f9Cx8jKq6dU8l+n3gdnVgMBFvU5o8yu1TTiR5Dp+Qriwo3cWBIUY
	OKuDAofuJ6m0U0vPh6SfozUReYW2cDM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29639601E0;
	Fri, 24 Jul 2026 15:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC9B1F000E9;
	Fri, 24 Jul 2026 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784908719;
	bh=EFqqg9i7LZjv08q4O6WVX5vzanG/kxsPHPC8mdLPdug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ShtoNFDV1LMQuwtlmWoiusiSz/y/w2lCScRwcZoD6jzHMQ8LkFpIBR14LLslY4lhU
	 ap68H0EbJYx/aqPikqAObCXM+9iwTPWAYIBzH48xKhSo9oc/t5+5SmkdVCNdaPj+s3
	 IGgdk2O9W8Jf4d/1SYvYb0+jxL23PCjjV4tzuWsmKQGT5yvvaggl91UFj3++34pOfU
	 vFmUJLB6/SrCpr2J3xngtCPtK58yHFu0VD0vODyO7iwckbMFjpFV2rFu7gT3GIFoyv
	 tkHXddKI6woAmu6uJIG2C29IbvxawyFdRRHIq057HW9JgYaqw6j3xuUvo7Sok8xNmj
	 i1csXQ4eSpwlA==
Message-ID: <caddd662-a88d-4f04-8f04-01e3cd29c788@kernel.org>
Date: Fri, 24 Jul 2026 17:58:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
 <amC6frE3LoWYjTMh@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amC6frE3LoWYjTMh@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AAF9340009
X-Stat-Signature: q7n5d34bg8n1adfjoh7ht5gjbkwbw14w
X-HE-Tag: 1784908720-213101
X-HE-Meta: U2FsdGVkX1+Tn3YnrKrxafinIBUmZmk49CaAhyk7EzhcGGzU5SHlfI+cd0eQs3DXjpjJXo72J+l3NDUEp9GBsgQjghtfO/cxmxcIYhC1KE0bDDX7h0lGbOnn7VbXVXXTB91ohAk7EDsyaYgJxl4MPHvrBVbkFnzN/ESAfxYZ4zt1+1b1KlqEaEyWqaspQl3Yf/Apk2t0ZOx7S69sgEh/mMSwUncr5gB5tM/5u+lDhDCIBPBpgM7MZfEek1mjo130p2DT7yc/emTBTbrILe5usGWs1qD4vM+0fHb0ZU1+rtBjqx3bwbMo5yMkZrPpgc6JklxhdZZhHJL/AQzoUF2/9rDKVoiBzBR9ZLeGvb0nGcTlL4PcsdWWT8GrPS67NOuAmIqRkVbOa//w93XEFt4lR/MpTPJ9zimasSLt3iChLT98e4XQSk4jt1GAabTu8HTAWeXFFovXIeBN7+ObW0IiiKZys3yV08KNZOGd0ResL3bwPQbgs5jjenzT2wNJQRvlR5kUwxwIBLrQEfLRmUn9rLQOIn+5HCIBdjL0TOafG90TCuAK2XOM+EHcsDAuZkpPXJ6b+RINMkjfM/6R7pYSBLAPdQr/kxOgnHNJ8yJaVxf/4AnVv/DaLQGq1+badOi+BGyJXRqnydtQB3uzZTkNKzBgTMfr4q4+SvvpzOXo9wVmllwGQFn1qrjkTZ1kDA68lwmDgr272NeGamfEiARKBhCvPwDUXYBzEiNxKjq8j/+Qs0eBarw7N3Y2pFnAstP/Jhh/64/rSBAcyP8FL/bOJ7Nw+cTsSMTYKGJiy+6fp/tePs+5IDAGUmy0BMdTrHom1rY6r63i9cpM/H8d/zmD2Ub2fEDAd5ciYL2q57hugIq8rZnrSzOAPQ0cmwgM4cK0CLiBItrUhQnScKTU9e83LJXKj5FhdUHFtTBhCodlbTdOAUUK8b+YxCwBVJf8ZrHiVD/FzHvm9iHiax+zprq
 6I+HULnW
 BTHcQqqutPjoYoGzPh42HXsFuHzWX6c84gSD3Tna6iNPLzFKrvktcnqGMEF1k0Zdb83DCO8uwFYfhSuV8TC2P+y0n8XhO8sUEpEKkYglcKzi1KDMIovV/7o5CI8jtt/mCdQscbVKAvB2YVxAs6LJEWB5+7LBLudyxBPcPNGSy9o5zddtHs8pyXWCUotEo/A8w39nnpmHVEqPVVhMVC1VMZyNeCdEkfLSiHLo7dTCr15HC99rWqL6VYopjcRgQrBMmFX3BUkBcEx9B3Rj2j+B88zRzuqN0URuUNA0q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 14:47, Hao Li wrote:
> On Mon, Jul 20, 2026 at 04:16:15PM +0200, Vlastimil Babka (SUSE) wrote:
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
>> 
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
> 
> I noticed obj_to_index also does the `if (is_kfence_address(obj))` check, so
> maybe we could use:
> 
> if (is_kfence_address(p[i]))
> 	continue;
> off = __obj_to_index(cache, slab_address(slab), obj);

Hm it would work, but go away after patch 5/13 anyway, so will leave as is.
Thanks!

>>  
>> +		if (is_kfence_address(p[i]))
>> +			continue;
>> +
>>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>>  	}
>>  	put_slab_obj_exts(obj_exts);
>> 
>> -- 
>> 2.55.0
>> 
> 


