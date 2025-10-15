Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 155E6CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382588E0020; Wed, 15 Oct 2025 09:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331DE8E0015; Wed, 15 Oct 2025 09:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220EF8E0020; Wed, 15 Oct 2025 09:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8098E0015
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:38:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3992138F33
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:38:42 +0000 (UTC)
X-FDA: 84000453684.08.6BD9E3B
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id D8C2E80007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:38:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q3ECz6l3;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760535521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYGfkZ4ebd8zW8yNaQUWakKK3LgMJUyMT/Oxz7oB3+Y=;
	b=H3z6ZszKRC7FdlsGsLqgghbdOLWbyY0D28NCTuyCfKrLAoLH6/mZgFEz1NKg0Og8UP2R1X
	LZIaD81kSFwdHydMRglNneVphKHoHuAYlBARJLWIULB3i5iLyQxGr5J8Jchglf9U/vdpv7
	UK4owCGwuO4h8mCt3hEhKASs2hX1fSg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q3ECz6l3;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760535521; a=rsa-sha256;
	cv=none;
	b=QAtlagG0qw68FM4c2nZqWGE87i4VunYJZMACe1x8AUuTSckO9bofKE5TtczewMgAsERd2m
	sZmuSSCQeTmQTEjk29Vepq5pSnXHR+rmzWNTHnBwBsW/+j5yRsahdLP/eQfDrKrTKIDIgB
	8+q0cBsjPecXFXENJ1rSuU3jQTMZ9kc=
Message-ID: <f00c5229-6c56-4116-8ba9-20a75c5bbde6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760535518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tYGfkZ4ebd8zW8yNaQUWakKK3LgMJUyMT/Oxz7oB3+Y=;
	b=Q3ECz6l31UzPNBENDMDgPx2sWIVb0jSaQr0AwUW32/hbCe29N547wVY8KWfRQUsmp0gWbU
	JULVbrwj2eiz8G853+sOcahbxQOYe8YSl9vnHmmS/fhxHwtZt40ds+XLhdfZAXInQ/Xeci
	w1FGZqsa9fPtQj3c3MjSU9pB1GUNkVQ=
Date: Wed, 15 Oct 2025 21:37:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
To: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
References: <20251015125945.481950-1-hao.ge@linux.dev>
 <06b0c6fb-0123-4482-ac07-80f0faec3532@suse.cz>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <06b0c6fb-0123-4482-ac07-80f0faec3532@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ikpz6ohw9aa5dajzwdo3iymcra9hm53t
X-Rspamd-Queue-Id: D8C2E80007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760535520-855715
X-HE-Meta: U2FsdGVkX1/1dYal2Lx+rrrchRdwoXNBQVmCPt3lVueAZ3FuJxGDU3EKnPfkNos7B/R9ZoT5XHXCF7LOi0Mdzsc+d/GnWAxA4E0UKtbLHy8uiwgg0lm/t4ZBh8YP+7bvw+z4hm5tsMZekfOgbYkTeaLr6qZ9bsJS/kFNTcpA4tb/4pn36G2Yn/Pcz30o5/iyb8Ggbduac/oq4hB+LpTkB7WdBDpJvlw1dHWZyfeEBhDV+5LCHk0+laovmra+KbsryCXt1APTfbZqhPBMnsDPpr+r+gc6WFYu3mSFPf2vAMg+hRgeVYGKtJfi9YnxTvAKGWXZTnhRDcLMdkWDXgC+AMgUml301wM8SlldbaQj0EpYrmeDygLBUNUBgAAZ3QdShW23bZfP0kwOo+G8t8APAT2PLl3DU9l4aT358hS2AHDmWrjkRO+oIr5CqetL3Trhx/9pKWqVYPJg3xqyeD/SYh7RuZ1j7I4sLGFc8ENc/Py7LRG7gHcgE0lk4FQ7iT5KvZsbYrcnjK1y6q5Fu7GZ2qhO81RUA8YOmhnpeHSg18McTKmVcaQPWdu8L3Jej4Y7jEB+/wsCMRkRun/7QXQDL0yBOHhYCdirRvl13rJN+A1pEFXabTqLuRmRtBv/lWcU0SlDeJVE4jhhyGhSmiAbvKJXYiAEZHkowgDtdgaMYmsZ23uu4yO9DM8J9GbpPpuyfe4hsZwjQqhUeldJPRkfPAuc49fMauo75iue8QkKXcC4hhOcnhRndL1SG53Y24xpl1vNjlerzH3mkZIt2VpOq/dDLja4VxXTLDbDNk8FT3RyEUCkb8unmI8uP9sspr89mPenXAi6J98ZfG44kk8HcXsbqZ3cqP/SpFGBlotk42brKGE2F/vZ4rZ/+JTbJMnhOWfJrtZgzrk8B43eC6Zb2Cq/w71OMRisEvRDhmVOZYRp/052RvCLp+TicGOQqxmtxdPTB+O3axcY7nqSId0
 4BwDMdTN
 LzkXTT4xrgSJ9wSPHsYQWiGKezbxt6SnI6rHfiIsJcqtnkqMb8YWhhMUCZM/fQCp2k6vkKhV53AaeBwzrIUlS/mtl/A8ozYPyI+Ku8dv+LIMOPU2BTf9aKxKYLE4KWTT1OCKuy5WrTErQIktsNJSPEWtQj2XZMVPqP1lYinOtvfiqw1HqE7POmGTpBst2n7I51XvCPvN6c9FIJzB3ZsL7w/M5YJeTb9qC4/NsQ+QJk6IT+Ty9dqdwAV/UBNpfi1wdY5f1KXehOv+jba1EOpFYCdTRUF83OUy1Qcpdd54dsyZ6fZDpqBgPD36u/nt1JIY9t0E3ReS7X7BBjxUFia3aPINyvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil


On 2025/10/15 21:11, Vlastimil Babka wrote:
> On 10/15/25 14:59, Hao Ge wrote:
>> From: Hao Ge <gehao@kylinos.cn>
>>
>> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
>> But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
>> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
>> release of the associated folio, a VM_BUG_ON_FOLIO() check in
>> folio_memcg_kmem() is triggered because it was mistakenly assumed that
>> a valid folio->memcg_data was not cleared before freeing the folio.
>>
>> When freeing a slab, we clear slab->obj_exts if the obj_ext array has been
>> successfully allocated. So let's clear OBJEXTS_ALLOC_FAIL when freeing
>> a slab if the obj_ext array allocated fail to allow them to be returned
>> to the buddy system more smoothly.
> Thanks!
>
>> Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
>> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Since we changed the approach completely, I think we should not carry over
> the previously added review tags in this case.
got it.
>
>> ---
>> v4: Based on the discussion between Vlastimil and Harry,
>>      modify the solution to clear OBJEXTS_ALLOC_FAIL when freeing a slab.
>>      This does seem more reasonable. Thank you both.
>> ---
>>   mm/slab.h | 26 ++++++++++++++++++++++++++
>>   mm/slub.c |  6 ++++++
>>   2 files changed, 32 insertions(+)
>>
>> diff --git a/mm/slab.h b/mm/slab.h
>> index 078daecc7cf5..52424d6871bd 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -547,6 +547,28 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
>>   	return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);
>>   }
>>   
>> +/*
>> + * objexts_clear_alloc_fail -  Clear the OBJEXTS_ALLOC_FAIL for
>> + * the slab object extension vector associated with a slab.
>> + * @slab: a pointer to the slab struct
>> + */
>> +static inline void objexts_clear_alloc_fail(struct slab *slab)
>> +{
>> +	unsigned long obj_exts = READ_ONCE(slab->obj_exts);
>> +
>> +#ifdef CONFIG_MEMCG
>> +	/*
>> +	 * obj_exts should be either NULL, a valid pointer with
>> +	 * MEMCG_DATA_OBJEXTS bit set or be equal to OBJEXTS_ALLOC_FAIL.
>> +	 */
>> +	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS) &&
>> +		       obj_exts != OBJEXTS_ALLOC_FAIL, slab_page(slab));
>> +	VM_BUG_ON_PAGE(obj_exts & MEMCG_DATA_KMEM, slab_page(slab));
>> +#endif
>> +
>> +	obj_exts &= ~OBJEXTS_ALLOC_FAIL;
>> +	WRITE_ONCE(slab->obj_exts, obj_exts);
>> +}
> This is much larger than necessary I think. See below.
>
>>   int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>                           gfp_t gfp, bool new_slab);
>>   
>> @@ -557,6 +579,10 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
>>   	return NULL;
>>   }
>>   
>> +static inline void objexts_clear_alloc_fail(struct slab *slab)
>> +{
>> +}
>> +
>>   #endif /* CONFIG_SLAB_OBJ_EXT */
>>   
>>   static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
>> diff --git a/mm/slub.c b/mm/slub.c
>> index b1f15598fbfd..80166a4a62f9 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2169,6 +2169,12 @@ static inline void free_slab_obj_exts(struct slab *slab)
>>   {
>>   	struct slabobj_ext *obj_exts;
>>   
>> +	/*
>> +	 * If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
>> +	 * Therefore, we should clear the OBJEXTS_ALLOC_FAIL flag first when freeing a slab.
>> +	 */
>> +	objexts_clear_alloc_fail(slab);
>> +
>>   	obj_exts = slab_obj_exts(slab);
>>   	if (!obj_exts)
>>   		return;
> It should be enough that this return path does "slab->obj_exts = 0;" no?

I might have had a momentary mental block just now,sorry,

this modification method is indeed much simpler.

I will send v5 as soon as possible.


>
>

