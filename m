Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D239C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167DF6B008A; Mon, 20 Jul 2026 10:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140FB6B008C; Mon, 20 Jul 2026 10:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C846B0092; Mon, 20 Jul 2026 10:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9E0C6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CC07C01C0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:34 +0000 (UTC)
X-FDA: 85009355508.14.2903473
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 971D6140011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M9l2/0LE";
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784556992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOrfQ3lYA2720DIdcg2lgwZAAppgr0gM7i8Eaojwjq8=;
	b=C/Tvdr6y4aEgCySHXGWmSutd1g+FwPErqsknAwpI6dzc8e/ByKVAOhQBI7GBsx4T3iV51O
	cOrZw8dnHOojyoNHydx853HpUB5sO+A+2DAAPLjtGt8jEpDTaNI8mpeR4LXMcRVboO0DZq
	90K4/3poiEhjr10s53NGI60Saw+7aUU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M9l2/0LE";
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784556992;
	b=Q3kF9sNQEbMPS818H11u3YSv4RJ+ovE4S7MyxnxvPI0Atg6Vs2qCL4rj+h6p3rOBZVB3NP
	AMNwvIMhfhHoBRIGHa6VhAxP5dxCK5yz8XWoYW26xhao0GFQp+f9oM5NLqWkB78CXkWHD9
	NR3I7VFHqvuB3dJVlJ4mK1TRw7VBuUo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D73760A84;
	Mon, 20 Jul 2026 14:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FBC1F00AC4;
	Mon, 20 Jul 2026 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556991;
	bh=bOrfQ3lYA2720DIdcg2lgwZAAppgr0gM7i8Eaojwjq8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M9l2/0LEB2GWQY1CtKBsbLdSJT/yAB7qZ29jms3ke7nnXI9Iv69tyJTQCnwDEuF2I
	 BrW0Kie0BuwlqXg1NPRo2fO2PmnXhLHzLW1YjNPp4qxsIgQZiYT7T8nuwr6GrFaxvb
	 IYlx8TawcJvWfkOd+jwUZCT5WS6xKpXWeZlK0nqMu5Zn+FN9AgyK+ep+18QhB/gGrV
	 fq62Fo2D0oYsmXHTwrbNXOPeQWKL6T7CbmLqc0UNhSnyB8LpAs+ir0nrunWZwNMdAU
	 aSUS9frX+xSXA5CsOg2JOpYPRvk0WyqAhdcBM0oWXGkyeXC8FtkybA6hvS3RNONaUk
	 3V2kLT6dZW8jQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:15 +0200
Subject: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 971D6140011
X-Rspam-User: 
X-Stat-Signature: ibyss35c948bi1fawm33kpaaru9xac9d
X-Rspamd-Server: rspam04
X-HE-Tag: 1784556992-815524
X-HE-Meta: U2FsdGVkX1/NTfMSMjoW/CKUelvI14ioAJK7g91F7Qr9ooq/sz3H1ipwGGO09Zv8vN7SFz3k1eHjBJ8RSFlKLmp2KJeOtCGVyda0fbXb3sq6h/MEQi31hFYwtAJIYI4mn/RslUa3+hcvump6mGlWTlyTg/mSsIlputxAD1oga1lg0Ripwkn9Hc3vkVmXGzKeERwXIh+5NFMeF9MaETTe8CB8hdv6lPPF7m6uX6uVlcs+IPi+F5tOcNPk1c3/VXeFqxIXiwBE6hbmbM3V+LFVwVlh5pAoj3hj6FiwKdxCFLugOGk1Sgq+0UolSQOfveY93qpcgny0BBxkwnHX6YnjIcfg8F3lkporiC3OYQGv9X7r47ZOtTbhbQRUS2sECOHHAoDyLPNKwAlmXnJLuG06EtLeYW1Fpyogzzi0G1GGNjfiq8ybz5jlrw1KwrKjHN+P9BegvtAOzM9cpKuWxmk5ayTu1cNNkrQN510Gm+rc2+hcgA6CDB7Xlu81JHA0LHKceNxazSK34J+J1nlW+K/p3AOioaAsnefhQYBrYLLPq5WS5jQWkxY5NFTCwHc9fMk73tpAwUUYazcyKJRYcQKN4NcgBoHuQSKOYy8VNc94y9kQ7SVyDwKqydUNRpL6IveMuHTTgBo59KarkmGgobW/cHXVOF1R6qB2HBhgviwjfHvBKG/uRZJMLzBu4mRqJi1ev1D8MYTvxuFkAS4knMFu2AtyhPTAXd/O7Gbs6HjlzprQb560WsIRkHHnpArtZBgpp89XMbgVtMcWwG0T8Myth2C2gZ02fOrHTl4Q+dWz6D1uR1pHgdutvASOcxA7jkA2aBzGTIPnmOxc66L5k3cIHLpeRm1N5iELbi2c4EVuWmsoahwU+speaoiQpJjJg16em8o7X7qS6qLlQ/SWE1b7YIQIsdh26UpUxaGhEv1fPgnvbA/hEVkRX4Oymxv6crJXXgdzlCLtjP17EkAmMra
 rVbgtisE
 OSIXfKx/LMreqbvnjgwMpa7fhbXax0663cjkI3t3qHh/HImiTLTUvSXjJKEfU18w+M+nrLW3qE6F3F03XYs3aL9fdHWvcYiLJwMJGJcc8etxX8sI3iD9UWq1ach4cn6ApWOhWzo7dodlWj48X9rp7StjYxrzXO9DR6uDGWZE4ta2XcvX6WWwfeuwXodptpVGplf0BTUe6u/SEunrSAgoSX2ehSbhcVBTNbn39U7oix4mVGnRla48Kl/umyUw+VFcrHXBXIRbOcK/aGj9p3Mr6gMfGXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct kfence_metadata only contains struct slabobj_ext with
CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
If CONFIG_MEMCG is enabled, the struct can also end up used for memory
allocation profiling. If CONFIG_MEMCG is disabled but profiling is
enabled, it will end up allocating its obj_exts via
prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
These will probably then never be freed.

So things sorta work, but not always in the intended and optimal way.
The upcoming changes to slabobj_ext layout would additionally need a
proper refactoring to keep working.

However, there's little benefit in accounting KFENCE objects. KFENCE
allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
(default to 255) outstanding ones at any time. For any callsite
prominent enough in the memory allocation profiling stats, allocations
served from KFENCE will be lost in the noise.

Thus let's not complicate things and simply stop accounting KFENCE
objects in allocation profiling and skip them in the related slab hooks.

We also need to skip kfence objects in mark_obj_codetag_empty() in case
a sheaf is allocated from kfence, per earlier sashiko review.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 Documentation/mm/allocation-profiling.rst |  7 +++++++
 mm/slub.c                                 | 11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index 5389d241176a..d02eb54ee8f2 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -112,3 +112,10 @@ break it out by rhashtable type.
 
 - Then, use the following form for your allocations:
   alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
+
+Notes
+=====
+
+- When a slab object is allocated from KFENCE, its accounting is skipped.
+  KFENCE allocations are rare and limited to a small number, so this omission
+  is negligible.
diff --git a/mm/slub.c b/mm/slub.c
index 0337e60db5ac..76acb78f2655 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const void *obj)
 		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
 						       slab_exts, offs);
 
+		if (is_kfence_address(obj)) {
+			put_slab_obj_exts(slab_exts);
+			return;
+		}
+
 		if (unlikely(is_codetag_empty(&ext->ref))) {
 			put_slab_obj_exts(slab_exts);
 			return;
@@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
+	if (is_kfence_address(object))
+		return;
+
 	slab = virt_to_slab(object);
 	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
 	/*
@@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 	for (i = 0; i < objects; i++) {
 		unsigned int off = obj_to_index(s, slab, p[i]);
 
+		if (is_kfence_address(p[i]))
+			continue;
+
 		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
 	}
 	put_slab_obj_exts(obj_exts);

-- 
2.55.0


