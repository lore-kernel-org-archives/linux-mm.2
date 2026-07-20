Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 288ACC4452B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4ED6B00A2; Mon, 20 Jul 2026 10:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956B76B00A3; Mon, 20 Jul 2026 10:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894B06B00A4; Mon, 20 Jul 2026 10:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 675866B00A2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:17:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6C094019B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:01 +0000 (UTC)
X-FDA: 85009356642.11.FDA4E9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3A9CCA0009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/pkkBJT";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2cb0SC7Ft0dMHSHileX02Rth4klsLBw5vrXUr6czBQ=;
	b=djxHrL6NCUZu9aq/Vwpf/xGujp3xIb0oCqAkjoj76jCm+EM9prwSixZHoVN5JcKkyOh3ok
	HxU2kcurr7OqDE1wfW7uePDSAYCPBhx0a7JuKH0L9kzqY0pabyImAlzrN6znUY3abBFojp
	nogWchB7OX2hZMs3W908GCIVNKOsrXU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/pkkBJT";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557020;
	b=sI7mZMEBzJJWFXiwBvRPD7vqy6ybvt9b/ozHvwxkWvwCjQjFWNQG/shXN0/ekowbiqFIUb
	mcIPxlogtZ7hI5HD1ysNPE3SoHeACrrhNXgGHgGlkg8IMbuQj9NaLQb8jHEtuRNIollHKZ
	JknTGujdhryPwZvtI4aOjCN5AUJL5bY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B6694349F;
	Mon, 20 Jul 2026 14:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6FF1F00A3A;
	Mon, 20 Jul 2026 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557019;
	bh=p2cb0SC7Ft0dMHSHileX02Rth4klsLBw5vrXUr6czBQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E/pkkBJTKEu06X2E0MtqbAqYG9hOrori+/Hbw0Q15iKK2xoCJuysaSbUjQnTjr4v/
	 /sTpoSxqfoJHBP5gshywigUIIVPwl0y6AldIvzDUc1t7LW+t+/Wy2DKN3jL5k9+BZq
	 iXnq+W94dP+4WXVmojEjornHrVlpBFywNqv2qk4gyo3snXvWHHi8OKPz5ov+g+vpgf
	 lvtTEVgxdkGSoANsjGKvL28F1b71Tgmpzi6j2LGN7mDAHeEV0OiaP+PajPeWFhHk/q
	 cQx4wexLQr5akB2uGT+LQagSMZfrbAFm7fJ3e+x4BVBeRZAcBvwIR4MvSxyMZX+joL
	 4LFq343++leMw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:24 +0200
Subject: [PATCH v2 10/13] mm/slab: introduce slab_obj_ext_has_codetag()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-10-2fa7c6f60dbe@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A9CCA0009
X-Stat-Signature: k7cow17wo5ke5z4gw4bks1chettz9osn
X-HE-Tag: 1784557020-425572
X-HE-Meta: U2FsdGVkX1/GsCHxwlOdo6yPEJcgCjNM+N29o5mNeTNCz+GNdLwINtxoTg6sht2QMHtNkIq+Y54THlZg+ncdQcEY88Ekm2cm4e79qxjfhwwSwJ4e4mFgSg8Tr3tuF2jWlsMC37Q7DwNyGAIxi0dCKJ3tNHOCjU5DmZqVWg/jfqvt9jdP3qM5qxlwjQj3//YT8K8cbBW7HKAJ5IGWr+OOxLxlxkBP9Dq1Y/Vstpgt3hxqu76VCSmmDkskyO/1EyDxSvTA9pYzbGjl6mmtefUL6DNONWvyGECfKQCkt1mNjgA1y5PgxP7kkS9uY+GEpyW4s4AdzLqaOkKMMODrBooaHdiBXdEtiI9WIW20KtvcrVzcWlvimBURY+Y+7nPztXOfAnMeEb1ZClKSNilo1tyWa8xl7+O8GRM5I/O7vRSZQIytpE/AkFdxsam2T+nXNpH7CYD5r/anSzio2AHMLLBKs3/6CU0xm4vkCQumEio33EM3UMYisQTO+UGdHa2M9W8YjxxpSO1NQDodJwn4gaNmJe7+u8J0zDbS2BDW9wdm1F1CcqiCaFdqMK46mO+mWABZSzGgYEa0nao+3ZzQXhLhCC9BlfPdcCWYnNXg/YdoyB4b8hIoFj5dpVpr68CWQJKOq1/VcNiuaTQvFSYxVJGZnFqM25SxPRnq90KOlNMPAaR5DnMe2nytE9SCBbyxkdiuKOaCWXgi5VoZ8yEqlrawQsnEeig48PFaLOfFWk9OaEExUJU5nbOWpb7ArihoNDOmWrHAlGn734mqzfZLqjBRlGU1H2WUmjyROVWqfBClniTpfAgy8JmNTKq0K5Gja9k21TznV9wVvr2/GupCsmNPb8be23mDSro8A/hURreC8CfLrs2tIgmaHJJqORmHgdmIiecFervgNPV/jW97ni2xrS2FKxgG95r3+NevcfE/EIsohG+PJtFSI2tBBOAam/WaFE8RhGsMktznxNuH/PW
 96763E52
 AAq+BD/JdBslGoOHiwsCCsTHYSg8No+4zOQ2r7rPqogGxVde9R4a+rdPi8jCqWGi6LKTtwAkwRILrudKERW3Kxi6EFX/+MtSULif7Bz6B3ZvGqy+sAn8s+8c9TpFJnj1dPE5qQPJ4sNBlyRLqPCXoJnQS6nI9QfNsp6j22BNEsTftVxMR0CEQFh1kFt/2Kta+650Oul5RuqwFtN6k5oLlKselO+V2zGMqS9TGtYOx/to53O/3FDNjuV/5GHKIWoi529z35Hu9LnKR1dHbKzwwK9j9yiEKTK6s4Bmi+MIYznEGI43iaW+CJMzFIVs4B95Q+7WH
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
index f8446167e175..983cb1119a76 100644
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
index 287cbf3eddcc..d78d3e50c877 100644
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
@@ -2425,6 +2430,25 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
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
@@ -2439,6 +2463,10 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 {
 }
 
+static inline void slab_obj_ext_has_codetag_init(void)
+{
+}
+
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
 
@@ -8551,6 +8579,8 @@ void __init kmem_cache_init(void)
 		boot_kmem_cache_node;
 	int node;
 
+	slab_obj_ext_has_codetag_init();
+
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 

-- 
2.55.0


