Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E18ECD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3686B0088; Thu, 11 Jun 2026 12:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB276B0095; Thu, 11 Jun 2026 12:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1626B0098; Thu, 11 Jun 2026 12:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF476B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:29:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1068A14074C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:29:04 +0000 (UTC)
X-FDA: 84868166208.22.4E3D930
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 35F732000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:29:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jOReuXIR;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781195342;
	b=EXdyi95pdc5jfDRvCKTXg4q1M6dWR9DwEuPSAR+vgxx9K0UuXQzQaeokDHdgO7xSlA0w3d
	GKalDVxgSobEQ0XIB3Q3xqT3r5fI3Zj2hMJOX5LsLZAakpu100dpSm4oYR4Ta6Y5igjX8N
	EUsziuPDR5YswEEjUVUUH8Tkd/TUSE0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jOReuXIR;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781195342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFO9PrlKWUdZ371SSeOwADUsueEbVUBHL0tzrlGjCbQ=;
	b=P5u/lehY7Jtvwky0G/z4iEiogMgO363tOKyFUkXwJE51+lfRj7o33Tdf6MresNynDeAVkP
	KWRqxE+lDyUTDwObQ3Zk/5FZ0iS39jBUCjZDEjNNy9rhRaoy8jmCNq6utIZDjugSIBIC+w
	Ef3ZN2Be9KKUJ6ooplftCm41XbnDorA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42033437EB;
	Thu, 11 Jun 2026 16:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F0F1F00893;
	Thu, 11 Jun 2026 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781195341;
	bh=zFO9PrlKWUdZ371SSeOwADUsueEbVUBHL0tzrlGjCbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jOReuXIRmEjh18yo6hQMRXe3pzeKqJHWt7xU7PmsWG5/BDmspraKVXqznLoLzzGK8
	 kYIhBBwoaHRcIvuIzfeUpmvHE2cVgUaxbs235Es3prqRn8SEHcXaYYaX+A/LdpSSqQ
	 7vVkklTqsBmfbtAUt7m78KWuK/g++bohtCxmcpLwqpP0eLRp6mQMl0SRPl+GoLA4cx
	 ojuVNc8XepIq0+dbLYw4PtirEV1hjWW3bDtv4F/RA1BtlOqgX+7XgZqJowIIce6JJY
	 BekMe54d/ts5wsxHQK5fgeWvXr6YHmSBPd2g7Y6v/zHOGOPudsbkTJpiL0lCeUjcbv
	 cJmOKxN7E9KcQ==
Message-ID: <ccc244cc-19ef-4cf8-b8d3-c4f55ed58748@kernel.org>
Date: Thu, 11 Jun 2026 18:28:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/16] mm/slab: remove __GFP_NO_OBJ_EXT usage from
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
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35F732000F
X-Rspam-User: 
X-Stat-Signature: p41uzo7cwmdr8j1yujnpmkxoditwzq51
X-HE-Tag: 1781195342-679971
X-HE-Meta: U2FsdGVkX1+RFzLPbXetSN/KBYNpvyiarc8ftVuYkbX37b+J/fgeKrPkWPajjh8pLmUdAiBJfzc4nP8QfIG6NsTwJfn3GO+SFlhd7dkzYVHiXjEo8ZQKvbvMSqZY+qtVGpT0mRkAdTzyEWRTSlyqyMftHJVLCodP4sUlQ0UUn3dtS7xjGJq4iwzwwjSh44GM3wWZYFVblO8XTHaMuYuK71hrmgl4q98BWfBDQM0m55EA39nGkgEYD5X3ERme4MBXZ56dW1JL/EJzz7w4uW5h6cmqCGz9GhEUxaUTiOBNph2ko7+omGCYTjziU6y+Kbi6gPgoE08zblIMYRSnXs/YZ/fbKctHRqIGzxhc3bBU9PDkULLVqSqO+OYDqlbBfNO/7Ps+bnevyy3+jF9k3GIlHHB1FyHk6YSHzp/OH10sU4OlFwWc9WPdAMDMQCW0JZ9aMlRWsUzgeaQkhvuDmnnV17KhJTTfgjZ8NGCmh6nI2EX4fZZm+ccSQ+bQNIrg3/2iXha+8BsoQrp3V9+4htQQqUF3U/+g5aD8NVVqxR5KuJ9W0ZdZ4mgGJARwYml425PSXVlsqD/Eb7AksoIglg/PJi7dP6/2VL0gPOdWKxAtuSRlFJ24TsL3VXaMPKgPobdiLvpNsmXMv+lPo1j8rpe/HYt6XvEQy+CskX6VZDnpLMgZwbTUSEr7ovgF+WsSBBfAtQeR9jl143begZCdkN2yzcMNn0nv1XijAuh+r6ivLgA5QLtOwp9KhvZ0b58QXOvT9PiGCYGOFcLCmG98mKzzi/FCi0qgtWqDId97qLDOQyUis/Q07zJmEuTpRsc0lb8jhTZGFM6EXsQ1Ac7ZCaTZ31yHZ89xmWsXDSAkKqIduWHP0EiH0ZDv4PGv16UtMWEpR+NiaxDLNolsE1xiGTJvFI5gbyBsevie33Vgqu+xE2hPwS0ssDkH2gDXNdMlsFEj2DB/p0yLWlaZEPKojQK
 v1cZam5n
 wd/QoMyzePh8C+CFWl/Yn1DGmSQpa5vpmr0i1DxFqxm6UmwxZH0BAPB8l4Eqx9PULhqjOklSHZ1BCCdjpigUMEA33KHobyuPmkPd/slu+JzaWl1CWvYX2slo0silyNKitIlOlLia7xDzQHUrEY3duKrifNV9pMFDz8Fjz6J8B0iso3NWObkru58AuzRXi0qzaBgNhIOlA+kaf8gjf/axEPQxjIsn42s4IFmsiYM8d5ABuV0abrsYZv3UjwB2/L9yJrPxASa0PjF5FCjEKo8EZSy3Qym5e7/z9x3QIICir8ttrJzvvUaUNZDhBZQUfEgyoq+GuM/oKX3GY3pQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 17:40, Vlastimil Babka (SUSE) wrote:
> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and
> gfp flags are a scarce resource, unlike slab's alloc_flags.
> 
> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
> family function should not recurse into another kmalloc*() for the
> purposes of allocating auxiliary structures (obj_ext arrays or sheaves).
> 
> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
> added. This will also pass through SLAB_ALLOC_TRYLOCK so we don't need
> to special case kmalloc_nolock() anymore.
> 
> Note that until now the kmalloc_nolock() ignored the incoming gfp flags
> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
> the incoming gfp flags (only augmented with __GFP_ZERO), because if
> alloc_flags contain SLAB_ALLOC_TRYLOCK, the incoming gfp flags have to
> be also compatible with it.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

As pointed out by Sashiko, this piecemeal approach creates a bisection
hazard where sheaves -> obj_ext -> sheaves -> ... recursion can happen.
So I'll changes this as follows to make obj_ext accept and pass both the
gfp and alloc_flags preventing recursion, and change the next patch
to revert that temporary change again.

diff --git a/mm/slub.c b/mm/slub.c
index a81f1f6bad67..c60f3a252ae5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2167,6 +2167,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
+	gfp |= __GFP_NO_OBJ_EXT;
 	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 
 	sz = obj_exts_alloc_size(s, slab, gfp);
@@ -2371,7 +2372,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
 		return;
 
-	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
+	if (alloc_flags & SLAB_ALLOC_NO_RECURSE || flags & __GFP_NO_OBJ_EXT)
 		return;
 
 	slab = virt_to_slab(object);


