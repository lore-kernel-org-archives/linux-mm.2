Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F30E9CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592B86B0095; Wed, 17 Jun 2026 10:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56AFE6B0096; Wed, 17 Jun 2026 10:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458F66B0098; Wed, 17 Jun 2026 10:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11BEC6B0096
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:37:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E9DE140456
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:37:07 +0000 (UTC)
X-FDA: 84889656894.16.2C838D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AED1B1C0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:37:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IcHt3Y0P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1K7NdwWrShKdIgD+8OvjC8OfnEWC3QHLcX5exYj1THI=;
	b=EAEuS9F/7dZfhKQwwWvc1aZNWatJZ6tTTk4mFVtxYl/ebbUtToUq2SYkOQxacz4RcugB0q
	yJ39ukHuYB38Sr+dX+BeRKt2y/CruwyzCAYSxj73SzeJVZRCUnBovZ/42TNyx2qZkUd1O0
	zPZBDHsJLdnVF0pPpWFuKkLSQRDePl0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IcHt3Y0P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707025;
	b=jZLBFPl1o1ktuix6s+oTo9jGClyfw25F6j4ALRqJVv7le53ag6jdivWpesh+rASsBe2KLe
	VuCqLNrkLVfqD5CVSZ/76qm6Tu0C3Tk7LPIhiBmg8NhJ6P9L2iKLs/7WYlFYA3kYmPt8Wb
	FG4Al3heMhcdLO/aZH7WFXo44M2oB40=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1D9243846;
	Wed, 17 Jun 2026 14:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA2B1F00A3A;
	Wed, 17 Jun 2026 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707024;
	bh=1K7NdwWrShKdIgD+8OvjC8OfnEWC3QHLcX5exYj1THI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IcHt3Y0PPyWEmxddWmKgfJU/e4Yw/MO27OJ7f4o1fS1EolxhseUUSqYF8iWgMlOdl
	 SLVbKiYVS9Duyfw0e1s1Q7lwrJ98twNMQKNB9PfA5rzqOLG+XgCJGlezC2z2H88MG6
	 P9apbRVSKmAJ+bx/kYzGpBYNaLae3XeeQv6s4XHbPGDK31wkUep/7n2SdsPHjZeJ7g
	 mBQ6bDPcTBJrj61zubrd4G+KXjFcZDfwcwYVbdrQWBgyYTfqO26e9YKzI4w1isGdOg
	 WPBLE8bM1RoD3g05soaZHOdU/KViE3adlqRjC+MLaOjH/H0AWDtEBjq1BHjsQzr65M
	 KyOPKxc05SWew==
Message-ID: <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
Date: Wed, 17 Jun 2026 16:36:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
 <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: k3uts5bm71ifo9erhxxskiqf91xt8ksf
X-Rspamd-Queue-Id: AED1B1C0003
X-HE-Tag: 1781707025-587947
X-HE-Meta: U2FsdGVkX19P1FFX4htyRceOIsikXkaq5p9pLUIb4PWWXGq0S0roQRRsT4Rdao4Dl+yZaw1Pg53KtzVWAfchx3UAeHAr7bbMEix7kj637CikXsAi+dz341a8qnFBIeFwcXdcOKnfjSy93apWA+lzLh8p56Nm/qHu84pE81TuU0aG+KOnovoiYzYQah52qMPbQukwXGhdS6uernHY01u0JHUGu7nWKbEnAc3p7KT+DBgtFUG8FD2ald1zaxhmFIRU9Gv3o4Ze6ZceDJU/v0V6gUW8U+Gxbf3Z5ggxb2D/AbzLIu+mkUnPzHYiZs9+M5SWXrDC4+rFq5xzu3C2i4NyX6RpZvBkBEes6Prin2YjyNVS07cK+5hQfFDgDbcqASSraw/2tnTcOxL7QUjOecQvUkcwhl1EfHWZJK3iADKrL1szoddvGr3H9aB1s2YXbtV8u+icIG9zHnZoDXbDXr2Sl//roJnVHc2zH1lKrXTvytX21xS9T5TnOyAKqmr9bDT9SpSc7mHZcz1kivLo7a5dz39vT0YL5y6Rsu/lieAq3XTj9TgxmtG+RwdPqQvgjUmTeKoFFFgObjeenTNG/UUxrm9or60csgBl3+VxhE3ZqfvN8SgYk4JliRGokR3MsSrZ0XPDGGXU/iahFJrROtHauJ3dylC7Tf9t5F9eQ6MJx/N76FRqo6fDOJXUW4DPWWpm97StUAckSmdhWOTPRmccCBkhL3OYxrkZw1RVeaNmQrfI8QqJoqpVIiAwMQcjG4PI2IXdztIdK4ZUKSWz48LLvRW+wbJXmyMVur5PH12Dybo/ndtKmGp4XhH6NPIKHwcvjRqU2heYta8gnRITSqkmhxxDBsvUkFY8Jo6igSb5+ohI/EDaf7hNglNWqr1qswLiU1Uk0p1aKyWlJNtSgsI38LCOa8TiCdY/hdhCbQAst5jyjOCFzlKT6RtPmZW8fYM345ur0Jb8zLuHuZ5iEjF
 8ED6xwVn
 699mrT/1Ax5llhrEn4TwWnX4u0Suk7SY0vBMgpI3V9+EerOmh/ZhkW4re921AYuN83+q+LeqCuvHk+z6VRJzu7TcpT5ML7IF49zU5z5+FpYAaaH3+hxcQ2EUeM69DriXpmB31t7gl1AhSRgSh57+hgzrMKCfTsoJ0XWjSuRC2u/XMD0wiCwiJtYaq2Tu3Aq/0AKEDRut2c0WR/f+mwQt6BrT7GH/odsWeuRST2JiJvCpkftgHu7WWWTwR/jtnlhRYWO+oCufuh69tyFrGwHa4pO9TVaJi1IXUtsgB5lJWpu6Zu5KwqHcmvRViHWw6OMLXpv0MwuPrXD6wIsCdkPE9y1r8DSPJ3plOZk4b1rhkyl7Yu/mnDsH5ypCe51xfuk6EDC7It9y0O5qRKMom7unxHmpKjwYp80ZbIrIa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 15:56, Harry Yoo wrote:
> 
> 
> On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
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
>> added. This will also pass through SLAB_ALLOC_NOLOCK so we don't need
>> to special case kmalloc_nolock() anymore.
>> 
>> Note that until now the kmalloc_nolock() ignored the incoming gfp flags
>> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
>> the incoming gfp flags (only augmented with __GFP_ZERO), because if
>> alloc_flags contain SLAB_ALLOC_NOLOCK, the incoming gfp flags have to
>> be also compatible with it. However, we might have added __GFP_THISNODE
>> for opportunistic slab allocation, as pointed out by Hao Li, and
>> __GFP_COMP by allocate_slab() as pointed out by Shengming Hu. Solve this
>> by adding both flags to OBJCGS_CLEAR_MASK as it makes sense to strip
>> them anyway for non-kmalloc_nolock() allocations of sheaves or obj_ext
>> arrays as well.
>> 
>> To avoid recursion of sheaf -> obj_ext -> sheaf -> ... allocations at
>> this patch, until the next patch converts sheaves to
>> SLAB_ALLOC_NO_RECURSE, use both gfp and alloc_flags for obj_ext. The
>> next patch will remove the gfp part.
>> 
>> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!
 
> With some comments below.
> 
> I was worried that perhaps replacing SLAB_ALLOC_NO_RECURSE with
> __GFP_NO_OBJ_EXT will create a cycle of
> 
> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
> -> kmalloc_flags(SLAB_ALLOC_NO_RECURSE)
> -> alloc_from_pcs(SLAB_ALLOC_NO_RECURSE)
> -> refill_objects(SLAB_ALLOC_DEFAULT)
> -> new_slab(SLAB_ALLOC_DEFAULT)
> -> account_slab(SLAB_ALLOC_DEFAULT)
> -> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
> 
> with __GFP_NO_OBJ_EXT, it would have been passed to refill_objects(),
> but SLAB_ALLOC_NO_RECURSE is not. However this cycle does not exist
> because alloc_slab_obj_exts() clears __GFP_ACCOUNT (as part of
> OBJCG_CLEAR_MASK) and memory profiling itself does not invoke
> alloc_slab_obj_exts() when allocating new slabs if SLAB_ACCOUNT is not
> set (which is interesting, by the way).

Hm yeah I think we should propagate alloc_flags to refill_objects() etc, to 
avoid later surprise. But can be done as a later cleanup.
 
> Also alloc_slab_obj_exts() propagating SLAB_ALLOC_NEW_SLAB to
> kmalloc_flags() is little bit confusing because it does not have any
> effect due to SLAB_ALLOC_NO_RECURSE.

OK let's address this one by this fixup:

diff --git a/mm/slub.c b/mm/slub.c
index fc5b8c85b690..dc4b4ae874ce 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2164,6 +2164,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 {
 	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
 	unsigned int objects = objs_per_slab(s, slab);
+	bool new_slab = alloc_flags & SLAB_ALLOC_NEW_SLAB;
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
@@ -2173,6 +2174,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	/* Prevent recursive extension vector allocation */
 	gfp |= __GFP_NO_OBJ_EXT;
 	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
+	alloc_flags &= ~SLAB_ALLOC_NEW_SLAB;
 
 	sz = obj_exts_alloc_size(s, slab, gfp);
 
@@ -2203,7 +2205,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
 
-	if (alloc_flags & SLAB_ALLOC_NEW_SLAB) {
+	if (new_slab) {
 		/*
 		 * If the slab is brand new and nobody can yet access its
 		 * obj_exts, no synchronization is required and obj_exts can


