Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4043EC5321C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE1E6B00A3; Mon, 27 Jul 2026 08:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57EEE6B00AD; Mon, 27 Jul 2026 08:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492756B00A3; Mon, 27 Jul 2026 08:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4AA6B00A3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A67AD8070C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:39 +0000 (UTC)
X-FDA: 85034550678.27.CE67CFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2717080011
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PM7EE0wP;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMR10wzWOC3iWDE6DrvrWcfSrkQzPUkWCEv11fQdpQY=;
	b=WhQbqGC+vFSJ4rPsfVl9ZQmUzirS8Trqo8UENNDymz3d7OXgO8b6HgEewtJzXf3IyBj1LO
	HPSrkNMhCyHfdFnbFjbror1nRHGftV2VmLLZoEJghRZ1laDlQ19ImmsK72R9q9wr5KX5g4
	Vhac1YbElYy55ZLullmEG5/9Z4oL28Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PM7EE0wP;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156878;
	b=XpXEY+ut/ZgRxU4le3g17h8q2AeViZULLr81qqrRIFMlqX5hlCEDVVyLfU8czDKWuqz8+3
	UHrqg4CVigWtTZYf9KnSUM2bkCe2bz98VQVB6oBxfy5+kJgysy/QpvaH53LYNikDtrQxSL
	cYr1QihWbOGpXMsx3QxO4R1o3t7gCQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD4F160A64;
	Mon, 27 Jul 2026 12:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E021F00A3D;
	Mon, 27 Jul 2026 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156877;
	bh=MMR10wzWOC3iWDE6DrvrWcfSrkQzPUkWCEv11fQdpQY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PM7EE0wP1nRdstfCP22TIZ3AP/RdJYjnz8S9dhp3/nIeUmgmQ7135ZWmfDKq7BYUa
	 6Csn5N/TjSOe6cc/Px6PmatZc3+G6h8ez+r7PfrkZsXTRheOi0wRALbeyMCYR+dLq0
	 r2s02WqAkJRNYi7+hY7Ahf9B864+ewdhAKs1o/dcJ4XvGYoUTGCLQcsUzkJO8+Fmz8
	 J1euZnp/iBku9SqYOSxKkvgS8tmKlYCHPY5Mf3+FgUt7rR8Dw7mevSavJu/4gsAvcp
	 PvMryzt6yLHhvVRORiCyXjmgSHrgrTtAaQRQN3FBK8/wdqaBBPB9+pJIeJV/siu+yH
	 OsK5q5jk9ONjw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:03 +0200
Subject: [PATCH v3 09/13] mm/slab: introduce slab_obj_ext_has_codetag()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-9-c29ef0f1f257@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 2717080011
X-Rspamd-Server: rspam01
X-Stat-Signature: 1fdigw93kkw1pq4deucjr76u3aoedsuk
X-HE-Tag: 1785156877-534795
X-HE-Meta: U2FsdGVkX1/+zogck7Z4MmQ+PfeFDcpTAgE1cnn52gCT/QX1paDHFZq84FMakk6/swb2enZajZ6X7Q8gQwL/83m8BuH46Yduu+RYZ55x/qwLz+dxeUruykkDItRm17wM6jfacpiPbU4iQcUHNza191jbiLjt7Kp+LAmcxfHgeXtFAJ+Ede9SGAS9HkulzohPPQjSB7EkV56sqyVNO9XUnVQsk60szn+5K+qhm/ZGlNwkreRP7zPDVmi/drCXFdbykRkxgw09sRKl7nME0y+z9hD31fNVzaH1XM7Wewd2CJvH7qeA/f0yccMQxAv4fHocsQM2hyAJez7QWDen7CZNRCdiTzYpE7g9jo0rIY7aNBTokdUvV80qQa6LarDmWcklHIJm7Rw1emOmlLKAGI45oWUfchteS5wGgKBvSRqLbIW60Hs6kEHCX5IYshJlQwWN1GfbOKFm1+1GxVPxDk6A3ZkZjqs11i1ZiGIiUzYEIBPhVu14f9+QD2Q19NgUmM3bL4/HTDiGuJR4JdOATxd5ECeDTeoDsBLduTtNn99/JUf/vc1k5s/vczYlCPBZSNfCzwwyxnIadFFwJMqVjJsc5QU3XoXy5XbGcPbEshN5auESN7cEe98pvqs/utHmouX3k4pZN53+RCuhpqSaTq4vlEwKLi//T/LEauOd+zdijAS0S0jPAxZfkzPm9uslw9wlpnZZiyr6xZXoYw0aT/gyNvEaLz2W7/He5S7dVt4gThKEcJLpCiexo+qPC5w6TFC8bJOyMYFN5sxOA9QoLm58lU3784vJ46mWwwWJCZlyl/++ow/sSI72r1+/CtwrR0E3Lp39G8qi4NUKG+xgLanKrr+9zBLG/KpzgDu13vgP53ws5jNZ8WV62NOgbrK7Tl/HCdVkCD+ntKUISgSt3LEBovBORWGsRCvE6UpblwM872N3mCiN+gtuV05DSftwuUM/A10X5yNj1KWypwiMhPf
 HabdTauv
 JhQyHWRgysruU184snn99wXgNeXyFi0JcRjZ72YzkZzLJT6hV2yoe31+k8nEaprJhBsKE50NjLmam0zV6Io7OOXRQcIwYsGY7Kwd0W+ujqFPDeE9OBnUtMFj3AAYPGex7sl14QXjGyS3166ALFg2xq/E6peMbgaJ8v86qifH4UMf0srq5MnR3jb6agkZjA2OuBRs+DL8OjxlDc4XcghictivSSIlBv7WISRhWYdeGJo9v7ZQdQ/VErigkOOjSE5QfdU4V92XrqYABN1BOtZqOczLbuMN5seKUciICW8850HQl4x2g4YgRitJ7gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_alloc_profiling_enabled() allows evaluating (with a static key) if
memory profiling is currently enabled. mem_profiling_support is a
variable where false means it's not possible to enable it anymore,
because the system was booted with "never" or it was later shut down.
This is possible to query by mem_alloc_profiling_permanently_disabled().

To make slabobj_ext array size handling dynamic, we need a snapshot of
mem_alloc_profiling_permanently_disabled() early in boot, so that's not
affected by a later shutdown. We also need it to be static key based for
performance. Neither mem_alloc_profiling_enabled() nor
mem_alloc_profiling_permanently_disabled() satisfy this.

Therefore introduce slab_obj_ext_has_codetag() with an underlying static
key for that use case. Its state is made to reflect the result of
mem_alloc_profiling_permanently_disabled() during kmem_cache_init(),
which does happen after setup_early_mem_profiling().

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 16 ++++++++++++++++
 mm/slub.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/mm/slab.h b/mm/slab.h
index 3f8144b9b9d8..8f352d9f4d91 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -568,6 +568,22 @@ struct slabobj_ext {
 	};
 } __aligned(8);
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
+			 slab_obj_ext_has_codetag_key);
+
+static inline bool slab_obj_ext_has_codetag(void)
+{
+	return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
+				   &slab_obj_ext_has_codetag_key);
+}
+#else
+static inline bool slab_obj_ext_has_codetag(void)
+{
+	return false;
+}
+#endif
+
 static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 {
 	size_t sz = 0;
diff --git a/mm/slub.c b/mm/slub.c
index 9079aaab3235..67958f2b3bab 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -213,6 +213,11 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
 #endif
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
+			slab_obj_ext_has_codetag_key);
+#endif
+
 /* Structure holding extra parameters for slab allocations */
 struct slab_alloc_context {
 	unsigned long caller_addr;
@@ -2420,6 +2425,25 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 		__alloc_tagging_slab_free_hook(s, slab, p, objects);
 }
 
+/*
+ * Make sure the static key used by slab_obj_ext_has_codetag() reflects the
+ * value of !mem_alloc_profiling_permanently_disabled()
+ *
+ * Any later mem alloc profiling shutdown won't be reflected in the static key
+ * because obj_exts with codetags might already exist.
+ */
+static void __init slab_obj_ext_has_codetag_init(void)
+{
+	bool need_codetag = !mem_alloc_profiling_permanently_disabled();
+
+	if (need_codetag != static_key_enabled(&slab_obj_ext_has_codetag_key)) {
+		if (need_codetag)
+			static_branch_enable(&slab_obj_ext_has_codetag_key);
+		else
+			static_branch_disable(&slab_obj_ext_has_codetag_key);
+	}
+}
+
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void
@@ -2434,6 +2458,10 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 {
 }
 
+static inline void slab_obj_ext_has_codetag_init(void)
+{
+}
+
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
 
@@ -8546,6 +8574,8 @@ void __init kmem_cache_init(void)
 		boot_kmem_cache_node;
 	int node;
 
+	slab_obj_ext_has_codetag_init();
+
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 

-- 
2.55.0


