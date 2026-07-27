Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F1BC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161106B00DC; Mon, 27 Jul 2026 08:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115906B00DD; Mon, 27 Jul 2026 08:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027596B00DE; Mon, 27 Jul 2026 08:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D05546B00DC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4ED858070E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:14 +0000 (UTC)
X-FDA: 85034549628.03.2448A9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E283C0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B47qnmcg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/vImmk4nZ0kFMnvMNBhkco3GaYwW1/WU6MdK9cUjwU=;
	b=7PUYgrW6CfwY6dUJERILicP8kLaFiY9gtoUusY54G9X0TEbSVr+najnsPmOqKPuPLXQ+XQ
	I2uMn2t09AgrYv7u3xuok4pE5Zzok/IvFt3s3rC/VGUNdRWsN6KZcMCsNKiDxFbaLgNMu2
	TL/TzlqtjG7UqYURbLBRd8N5XW/dOjM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B47qnmcg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156852;
	b=yGwdyLq9WMgV0WeqzJpqGvNS5S7MixYb2YB430P0wuCVJRUJha0mbx3S49leDj147BXU1N
	CAJ+WbwOhpdng8uExQa1xObPtjAV4650mQv/enWR86WURogtWXkJ2mEv4KigyJyVGJEKvQ
	m6iVTifRABvEahoXSerMvxXOYVEZsnw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7621601E0;
	Mon, 27 Jul 2026 12:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939171F000E9;
	Mon, 27 Jul 2026 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156851;
	bh=O/vImmk4nZ0kFMnvMNBhkco3GaYwW1/WU6MdK9cUjwU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B47qnmcgwRsFsMJxuSxk0f5mzdJZ+5GeKmwROVitFo0a9eMIXuTQYWq7XouWASSY5
	 hRR5MbmSJFAj6MOsQApHxDUZJY8Cf55wzD7358Pg3C8Z2LDwSUPWa9pfMuUgoPSWGY
	 ZK2JxlFppOqODg9RfawieUFDbfyGM9CqxK9CUuloqeioD4cFi+E50xOckjTdOXRa8b
	 V798UEHVLhAH9eIVX1wr6/GqPRm3TifGFU4tMWI0+uIK3XJKvTg6VzkQvb02673Cg6
	 6uwCCrDl7zT394Q8MQeKjy+JyHxCr+c7yhR/LzdnTqsZcPQnqmr/omHZl5+hGHirgx
	 MhtojOWuoe8+w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:55 +0200
Subject: [PATCH v3 01/13] mm/slab: skip kfence objects in allocation
 profiling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-1-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E283C0009
X-Rspam-User: 
X-Stat-Signature: gnom85cym1twnhsyr7ocnk116p3m4rf6
X-HE-Tag: 1785156851-253509
X-HE-Meta: U2FsdGVkX1/5rTr+e5rGNxvnbM4zMcrLlnOQI6tzZe/3YVWHbI/7r7ioTpDX76neHr+i/BLXHnjPfaUcLUwKQGstap9XLtoVtjfP0Vzkdc/fDsH/18Qlihtt2xH5V1GoNn281ooOB0eKhF2hKHXQuHc2mzWqu3sDEIkfz+eHb+DsYUGcSAZLIzQSauKzVInGYNq4695sU1UxAFNYxdef5X9ktiHrSTwpeE4GV1o6JRf+tC7++DkpQNU+nmH8CdkYggapLk8pqymW/RGywl6C47FgLeIfR/PDWcfOWO0QVoLStz/ibRxN+dn+YSQat+OAzHPZViIwvqzYFg1Evl/n8dZ/aZdl9JGhH6IjWeqrLOaaly3C7PTHF4x9yPG5IpKF6z8GZSxrrX9w2DY2xs2NU2OcNlcIYHhRTPso7+UA8QuWvmtop1N8xMIpyO/uu7k1DuYeyvVHTe9ciqCDcAxH8OH6z3ZWX1L7J5FBh/2sGxMMgOjVOua0Dr4REkF2k06M6sS3SgtQvVL4j65qdOFJ0cc/HI98QTrpDmC0JTYSUpWo5w9vZr28PFT+KJw8cnV/pZo5xna9egtarnYSdxWoL3dE6gBLa+72KfYTxaJ67NAsEdZxeR0HIMAUkY8nRQsZDHsKp3NzvwjJwbeC5U8Vnf7AE22TwNlaF96q7Ihd4rvHdfrng7idGpA4iPsqfiLEVhpSdjfCMJTnGRduMTs9M6t9ICm04jBpX/HbeH2ogM3QujPqCc0E3JkB1owzw9WdkcqMDi5mN92knmxevv5M6Vhg5r7zxcbOxTF/dt1YiFBdI964/9G2v2xuO+pe0pjhiGRtj1y4x89ypXoaKjev5CvPipNtHTWPbZk0zPTNAbF7/vrLTPpHXaAslWXSRcrPt3sl8fT3ptWeOjYZ+7vowKwVeUtyucpoU3+EUySkHm2mSulnNXpZqDn7+6NdAy2BlTIy2Nv2NcKrQLb0Hk2
 aiqxtukf
 uhM0GEtMT4/W1vJenqN6rdi1H/DswrBq63m/ElSuorzFe2seex1LkMwlpE4MqKdQTYWRdy6Sf69TjXj1EowNYcNIP1W34c5u375ICTSj76aOwtEvs+hJN64vkS01NypfoCu9BPiPzhaBLDi2P9AsvDbpRiB6NWU5PhhBBhmlUVT6/LJLpewyS0DyzwMaNNB9FqANSESLVX0h/crES6oThsFU7i/VskwL5eJzoiII5YxJO1JjrqJQTOdb26JZ0tarKru8dTvbbViAUyugnV+Z13oX6wQ==
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
 Documentation/mm/allocation-profiling.rst | 7 +++++++
 mm/slub.c                                 | 9 +++++++++
 2 files changed, 16 insertions(+)

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
index 0337e60db5ac..d702d273253c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2067,6 +2067,9 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	struct slab *obj_slab;
 	unsigned long slab_exts;
 
+	if (is_kfence_address(obj))
+		return;
+
 	obj_slab = virt_to_slab(obj);
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
@@ -2352,6 +2355,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
+	if (is_kfence_address(object))
+		return;
+
 	slab = virt_to_slab(object);
 	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
 	/*
@@ -2399,6 +2405,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
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


