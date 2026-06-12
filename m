Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D04CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94096B0088; Fri, 12 Jun 2026 06:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43E86B008C; Fri, 12 Jun 2026 06:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B333C6B0092; Fri, 12 Jun 2026 06:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2F166B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:17:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C11FC2564
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:17:53 +0000 (UTC)
X-FDA: 84870859626.29.FD9E896
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7D3DD1C0003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:17:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aa/uH/j8";
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781259471;
	b=G8Ui6Nq1Mjqn2ES7mDu2r94ROHZf7K0lpNciMS4uSvBjo0psgx7yDyHcY0oXgUwE4RrV1l
	0akXiOBV/Kv9xypzhj4769n9N1OM3wW2Axz5zWjOEjmxZCzo0VRIx4AgeKYpc5ovDp3SiJ
	h3OJFosXOZHC8rZ04zT8YAcMfpL7kvU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aa/uH/j8";
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781259471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdZmqyMl3QrZhAhovfmaOPCU7HRmnWwDMXzjqRKD3Ng=;
	b=yq/zhud+2U5KL8by/BqO2xAqTlmFKmaNf5Ba0vNxjs2RfmbfZx5HsoWCHaFASXUC3eBnfe
	NklUusoGJBKp+gC6N77kSpWahu2zJ9vjO6X+dcr+nXqCyUi6Gyk60ZQB91iuG9Sva2h/lL
	aDBc2gJMxVkVQVa1p9JoVIs2Lb4o47M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF1DC40573;
	Fri, 12 Jun 2026 10:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0A61F000E9;
	Fri, 12 Jun 2026 10:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781259470;
	bh=UdZmqyMl3QrZhAhovfmaOPCU7HRmnWwDMXzjqRKD3Ng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aa/uH/j8yoTA9QHwv89Cwnpv1fGtzSTdAeaOE2m9NXMfvE9J+bJsN9SMQMuVp7prn
	 BMWOF9qOcsosAfn3gAwd3w6dsukfXwH2kLVgjNp3dpQsu1+/j2oXltPrumvH80aOO/
	 1e0eaG4jvxqfJHpnCZWP/nUIL7yfjFIY2Z1C6OsIuUYx3TywhkQfKL0z7EpZzAi18q
	 eVwrs2mbLfg1UWKFTqpxTyA2PLablNW1PHY0mTAEniXOpQSuPWtxzZLKfa6I4vQ1QB
	 PgavmWaN+uZA6bAPY2JbXd0gaUcrKuvZo0cEqyc8oxjS9wO7+nYCAx15hZvcIE66h6
	 NtAsSGfqmYIvA==
Message-ID: <49f1bf1e-fcaf-48fa-a7b1-f8ee78b19762@kernel.org>
Date: Fri, 12 Jun 2026 12:17:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/16] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org>
 <aiurbPx1SISBarBy@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aiurbPx1SISBarBy@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D3DD1C0003
X-Rspam-User: 
X-Stat-Signature: tkaomerwrigexut4rkmrynroaekeummi
X-HE-Tag: 1781259471-693950
X-HE-Meta: U2FsdGVkX1+fMHcbpAFDGwvdaUBNaHGWm/8l7QEXdvYhKXbmNQPk1TALFqvw59+x380S42R6MziqiZVlZCS6jQvZuB8bfSnJ4hecfocnsZ3yCqmnquLINUKt5hmBnjGkErY9bZYc1gPE3vCdwsjyqKNIwnSoWd/EaSWnf92+h1hVGoZRQY9kcknsQ5ossht2LDOs9HnF/71/lLdVlCUbxA/917Kb7hbagdsntR+oVKFjEuSoVr3wFqCGPnuYuK1iOW+D++QRK3tlfdbgIQsyRV7gpGNaW/QubyBM/D2gLfs7Oj3WW8CLvh7F8WUkLabwiWBnOviA9PBHZABYJIAvyHXjrVoh1XQ66h9/yut81N59SQZFcQa0pau4ETZKtbshq3l8mmo9NYuFb3iFxoUKUfU1BRuApKy95xqMzBcj9iPspRGUzzkLPNCwuEKBlxA2bw8min2OSZVIKOaZGp46oAqB2E4SUSr42dDlp04e1foetucZymdfWMBTkecuZitZ+qH3fPRqa7YqRm+1Q7RU6vkIyEvSFjM3TtWhm+yEVjORDh0eqUS6kTe58uz9j42q2VEn8py8KOwEndreWLAdh7OSUCQD+YYSgnDSyeu6aXiQgkWxUCRXtJJd37mrbtlWlsHGlW4uFfq5k/VvzUPS5IwdKrjezilzadfJUNGq/d1J+CaQ713cv9BtR/yNMmBxpt5Zdb5d6JUqRLSJIc+6EBeakZpKkDEl7bVC1KeufteKgRd/hhKTV8X4qnp6QKNvuPFPTm9wkdVZ9BtA5TUulnkaqNLXTnDn/iWw1cN5uQc683wfMZLbc+7VBC+JdnSEWe46YtOaBLvlZ2RKSGlIM9LvFFRgw3onUgpnsUsYNOIyCoASDnFA8uKWxFc80IwqQzv1M726l12uuAit46L8dinQ/Ygiu6JtygWn6ot6efrGWOsoBjqUpnTAagHhfCs3ByGOP4JELd/h5WBPP9Q
 O/epS2yV
 ndOVhyxsizATraIpYJyf22eqISPMKQHHtC6nbjvWhVcr6GmzbKRdfdrzgqTX39N+ax8tIKtrySr1phOoe3iaodhX8n3aMGmWy3arzHP1SWSULFo9qS4HpTAhJ0wzkeFrqjETsUXJzsAOlF2SREpewID0iWxcEm/lAPmAN7/D6mB7ujw4/pOW/+Fw89+LY8CXWy38r8rhz22A8MThZKy7zWlj6E7GePL9BEEfw1g9DLLVgm0OCeUgzTAbKZbAdjOaO1GemAq1h3mRuq/DZCj5hsQvEFmG0mO9xmbBUVnSQhat+jE1InbG/R22hkAfALXOCQVj6d4H/sxp9u+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 08:54, Hao Li wrote:
> On Wed, Jun 10, 2026 at 05:40:17PM +0200, Vlastimil Babka (SUSE) wrote:
>> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and
>> gfp flags are a scarce resource, unlike slab's alloc_flags.
>> 
>> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
>> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
>> family function should not recurse into another kmalloc*() for the
>> purposes of allocating auxiliary structures (obj_ext arrays or sheaves).
>> 
>> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
>> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
>> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
>> added. This will also pass through SLAB_ALLOC_TRYLOCK so we don't need
>> to special case kmalloc_nolock() anymore.
>> 
>> Note that until now the kmalloc_nolock() ignored the incoming gfp flags
>> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
>> the incoming gfp flags (only augmented with __GFP_ZERO), because if
>> alloc_flags contain SLAB_ALLOC_TRYLOCK, the incoming gfp flags have to
>> be also compatible with it.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slab.h |  1 +
>>  mm/slub.c | 13 +++++--------
>>  2 files changed, 6 insertions(+), 8 deletions(-)
>> 
>> diff --git a/mm/slab.h b/mm/slab.h
>> index 45bfcfb35a9c..509f330654b8 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -21,6 +21,7 @@
>>  #define SLAB_ALLOC_DEFAULT	0x00 /* no flags */
>>  #define SLAB_ALLOC_TRYLOCK	0x01 /* a kmalloc_nolock() allocation */
>>  #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
>> +#define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
>>  
>>  static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
>>  {
>> diff --git a/mm/slub.c b/mm/slub.c
>> index cbb38bd01e46..7dfbd0251aa2 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2167,15 +2167,12 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>>  
>>  	gfp &= ~OBJCGS_CLEAR_MASK;
>>  	/* Prevent recursive extension vector allocation */
>> -	gfp |= __GFP_NO_OBJ_EXT;
>> +	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
>>  
>>  	sz = obj_exts_alloc_size(s, slab, gfp);
>>  
> 
> For the original calls to kmalloc_nolock and kmalloc_node, I notice a difference:
> 
>> -	if (unlikely(!allow_spin))
>> -		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
>> -				     slab_nid(slab));
> 
> kmalloc_nolock completely discarded `gfp` flags.
> 
>> -	else
>> -		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
> 
> while kmalloc_node preserved and passed it along.
> 
>> +	/* This will use kmalloc_nolock() if alloc_flags say so */
>> +	vec = kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid(slab));
> 
> Now both paths are merged into kmalloc_flags, the gfp flags are
> unconditionally carried through. It seems this might carry some unwanted flags.
> 
> I traced the call path and found that ___slab_alloc sets the __GFP_THISNODE
> for trynode_flags. If this flag propagates all the way into
> kmalloc_flags->...->__kmalloc_nolock_noprof, it will trigger the
> VM_WARN_ON_ONCE warning. Maybe we need to strip the original gfp if
> `!allow_spin`.
 
Thanks. This should do the job in a more generic way I hope?

diff --git a/mm/slub.c b/mm/slub.c
index f9b8dc56bb57..0bf53f70c9be 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2047,12 +2047,15 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
- * The allocated objcg pointers array is not accounted directly.
+ * The allocated objcg pointers array or sheaf is not accounted directly.
  * Moreover, it should not come from DMA buffer and is not readily
- * reclaimable. So those GFP bits should be masked off.
+ * reclaimable. Node restriction for the parent allocation also should
+ * not apply to the slab's internal objects.
+ * So those GFP bits should be masked off.
  */
 #define OBJCGS_CLEAR_MASK      (__GFP_DMA | __GFP_RECLAIMABLE | \
-                               __GFP_ACCOUNT | __GFP_NOFAIL)
+                               __GFP_ACCOUNT | __GFP_NOFAIL |
+                               __GFP_THISNODE )
 
 #ifdef CONFIG_SLAB_OBJ_EXT
 


