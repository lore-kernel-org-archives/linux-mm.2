Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794F0606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=dJbuoTcB
Received: by kanga.kvack.org (Postfix)
	id 88E446B05EE; Tue, 27 Oct 2026 03:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866566B05EF; Tue, 27 Oct 2026 03:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C1D6B05F0; Tue, 27 Oct 2026 03:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7A56B05EE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:35:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D8231C4330
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:43 +0000 (UTC)
X-FDA: 85367596566.08.CC2C5F1
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9D8FA120005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=dJbuoTcB;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HiOeizALgL+htPryz91jPJKAKWQ4nNVAQkQrkPjqDpY=;
	b=fNbEIk5xTIKbmHyllqkgI3AeG9FpvKO0GM8qkST5q+pjWTlcDZUwZpq4T9bSwyhznP1Sbj
	ts4ORYpgza3fnjvSrxAsAwSZ3c5laCCZOP7E9o06rxgc+7IQdTF1vi0fYuRUBS9oqLxUye
	TqO2cxpNOFNDJxlK3JQ5+4tdIWMpka8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=dJbuoTcB;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086541;
	b=qW8DBLk7mX1lNPVWmyiCp/vA/o8MItjhAzOkqeZf3ktPS01Vc/+Fz1/diyNgXtGT6UQPrz
	qyf9ygfdz7FgaKHdXN9X3XAX/hgrYmrN4gU92V4aWNJb47RRQRsZx+WrrSyyA+URS9abLT
	U2Bclk+c/Lmkpv0kaQcQ/gVcldD/NTU=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so2503727a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086540; x=1793691340; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HiOeizALgL+htPryz91jPJKAKWQ4nNVAQkQrkPjqDpY=;
        b=dJbuoTcBZ9YbohMW2mQgCP0Q53e+V4IzlXOftUvDlJvS+8j8QYFSYCvPD0U3k1zdL5
         zM9rRoODIXq++/UiH86Mq+rmjbu94Vy0Rp+Ja3KeQ7v4wGIc2DtIfGIT7rddxQDYCeG+
         87jNPVofSLQBv3HCZfbAXe/N4xvpRWETxYJno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086540; x=1793691340;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HiOeizALgL+htPryz91jPJKAKWQ4nNVAQkQrkPjqDpY=;
        b=kxx0lRzDhaOFK8E0w+OwmbdUXzoM0SBXrYEQdDAeM9ztqg5D7IilBpuGzJlm+Eqw2Z
         dxcy1zbaQd94gqtlOgc2RJ6BzKWXjYMSMI8K3jsmcHvMQgsweWivjbedpD9mVD5WAegI
         QAvpvWL+IA/Sw1oQ8PpM1KlrlYpqOSHC5YZTlrsqcyKPl4EWmwzHQmVi9iRaKHmFiqQL
         nwstvE/lrhFGU6O213W/tezBi/PCoxnRqwd9IlYq5SFqpobb2Crf4alJtXAa4LzIpV4H
         cmL1lfBYvwYdwgyOAkeufWt5/Nwx9xTBGNEZlsa1G4ktICBA3KQU09K8RWFpJXmSoXYk
         DTNQ==
X-Forwarded-Encrypted: i=1; AKwUvBwkPDbRCR/75MYnkzjw9spXfg+PoL3Z9lB1ye52PyjLNQfDrtCOVOpayYQCO0cTyh9O1U4qFbMKKg==@kvack.org
X-Gm-Message-State: AFq9FYJF26IAUkMylb/ccNtSTHO1eLuU4de9r+W/CaJ2cAZOHv+VSpiN
	bmBcuj7cljt+YZME6asdR77Gmj1xm9/oFXDZh4jM0UbSs3VM4umMMTLPtpWlnsNi8Zs=
X-Gm-Gg: AYBFou1q1eLQInla1ihQmBxvPGOFCzBhJJnRNUwvn/JAY0aJsAVJBX3Tz71xOvfFZIz
	a0Adp2XornI7bxh7bu4kft/26vigaBTRjSA0qgl/HxrbWP8EgGROK8WPSG/N4im749p6Xcbw08R
	aNGANgJBUEp3rLV/0et++SbzUMQUkjtfN27JSe4cKYDSL0wHoNBvDUqOBtriFfjJEW3bwNlvwlg
	YX59S+k0Ns+sSQtDTlDff3P+rja1jjGpNJ05zt5SoOcRvJ3C9RuoswFmvwtSYiSkDMq80aPDWaD
	90+yyZilf4ZBUw6KmKSJrLdMGsvy47AZnZZilGHL6AhEK/EaBLrLzAFNgjhcBOs0ohBDv64Cpwe
	8UOkE4Wsv8HtHqK3JXEpbj0LzM1JFdUqwImoJ/3+sP9+MsH+I8e7PZC3Ul+VzB1aIj0a/c4xvtd
	iPMXjkOkvxf7r8ij77/rez1WxS/LEOEhk0daOrEL7qcpj6wB9/U/7NurNTdmrFrliAs03P92wuw
	P6ajThQFLFPvVifEKG5TJf2br2oIzgIlodRs6g6xhaisFU67Nngl/uutoTroaG1b0zwbfVl4qwt
	oJAYs8l3+zkfUSh1i7E+ZFLclG6agrhBPLoSQ9SWqWbgvB5fAO7LMGmHLhpxbtSVrqN4K+OmcE7
	eAhkXxjHBZn1mfOVOXzAaMnA=
X-Received: by 2002:a17:90b:3b45:b0:3a8:7096:9b48 with SMTP id 98e67ed59e1d1-3ade9b2cff5mr8340964a91.1.1793086540437;
        Tue, 27 Oct 2026 00:35:40 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebb06c57sm7546810a91.3.2026.10.27.00.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:35:39 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:35:35 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 1/8] mm/slub: Support disabling freelist hardening at boot
Message-ID: <d244124ec287b576470a405c828432df69b4e9cb.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D8FA120005
X-Stat-Signature: yqnsmhs7p1m7o16ydqisqem1pwfqghzx
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793086541-359062
X-HE-Meta: U2FsdGVkX1+fF8tgG6Gv5gX9YlqQeyod/ciZOOSvN3NpDcQokzUykI10HckH+gsLiLbLcpjkQGMCczxqcTby8goDsarwIcyUI9zq68ns61A4ub89xqcLjaZfkLYMVJt1eHs8cUunQbsGlcajBkkG1EnSRUFlxzdhRn4z8w9lDBa3vIXXhfEJLan2fqJueI1U5gHAzdEgQ+ge6+VVfAbMDklTCGgn/Txi6gWknXLtIY424Qq2hoSXXpNvY0zN1i/AI7A2GA3auXTVN5GEtTNHJd1gNKylFefqs9d1evybNWZiG/nKBykMUYOKBxOtPF+bYmjQ/nr49IJERfLaGwTUXd11v0t2MzfuP5Zvrf21gBoEIEUaMDLTWgQHXmiVxn8STXsrahvRHbEUw+EV+hnavm7nU3xE0lOPYIDhfYGb6oDrphbtfXx9bbB4UkfqaT4anOXmJdM2AXXKuWpYbphut2SAW8AbiGD3dKrZ5GVHU4QXdw1HydZQhpwkE226c7FWZYh0pQhGAz8romOmjWh1lkdDrEawiOBEpLDTsF0SG1TkWomioCbBy6yB7qzkNUYTM00NARP1KhHoaPTGTxQU20y7cJ4QRLUEYlJRA+tjcnQC6nWWiW9S9s/dofaY56kYnf20n89NntlyJyPa+7gj6Ywxxbb+paxA6JMaa6vLQdzETSuhRYtsN6zowYxNnEBWEbZH60bnZ2xiTUTok5r9NwBDIaBwPyfPZnADzjTAhdABHmu7SKdFGK7fEIeOa44XczFqPV4x7Uib6E2FpqXj+XNgbmBghwLzVnXRgkVTvx4XimNq1RtUgtSzSAueFVtzJY4ud6RR6SjnjBTdFsNPHNxt/2bTbylHGk9h+katvasQLIT2y7SDRC7vbjUhuoItNw2bJAAPLHCbOPJs651wwMM9xc/i2pLtXw6WfLSMMVCQ5wPh5H47QwCgf05RHQm1i2jbcEeUuZ0RR0MMvGW
 qgEmnF8d
 Pu4slYTYH7YwGXLIROWQmfNo5iMpw8rIunVu+W3AcXPg1owg+Fg5du/lNYUnlFGmUj9ET0RDM10utmdnDoZR+GsZMTELWNG2ATXXmR2UTddjCdwW/nVCoqZihfbxS1mXpXIdUgk5FsK2OfgY5TUfC7w3+NfVFD1C6UJpoDWGAPRhM/m2scebSxzyB3nI9OmIBTuSCnAyqyiZe11BdesnVtPoi7dwgAZsrHrMECCZBjibJKPRfJoGNmqvf5Af4rce6+Qa5LvN+0VT//NJ80veWlZxO+CzjJSTYeo1zJzGMq0VI3GNWZSGOwClGhNaSoZfUQ23KTJt4rtT5bUqYBHRFqU8a+ZHlaqr/TJ6uUVvIXktV/KqwtEC5p8g0FtoktkTJmrBa9g3sX6oYiQphEuAWwLXcsd6+uST4KOu0STE1gJrBLRSZRzmLp4T9L4TkPa/1YM5bT8kB9J8bfQvlidKwofLHvzAwmkEay1xlxREJZCn8/aJ8mSvrwKgYwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the slab_freelist_hardened= early parameter, enabled by default on
kernels built with CONFIG_SLAB_FREELIST_HARDENED=y.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++
 mm/Kconfig                                    |  3 ++
 mm/slab.h                                     | 13 +++++
 mm/slub.c                                     | 49 +++++++++++++++----
 scripts/gdb/linux/slab.py                     |  8 ++-
 5 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..ddf2f6fd60be 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7014,6 +7014,13 @@ Kernel parameters
 			option which can be undone by adding the
 			"hash_pointers=always" option.
 
+	slab_freelist_hardened= [MM,EARLY]
+			Format: <bool>
+			Enable or disable slab freelist hardening on kernels
+			built with CONFIG_SLAB_FREELIST_HARDENED=y. Ignored
+			without that option.
+			Default: on.
+
 	slab_max_order= [MM]
 			Determines the maximum allowed order for slabs.
 			A high setting may cause OOMs due to memory
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..3ae97fec9946 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -214,6 +214,9 @@ config SLAB_FREELIST_HARDENED
 	  sacrifices to harden the kernel slab allocator against common
 	  freelist exploit methods.
 
+	  The hardening is enabled by default and can be disabled at boot
+	  with "slab_freelist_hardened=0".
+
 config SLAB_BUCKETS
 	bool "Support allocation from separate kmalloc buckets"
 	depends on !SLUB_TINY
diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc..8187ddb2face 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -540,6 +540,19 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
 	return false;
 }
 
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+DECLARE_STATIC_KEY_TRUE(slab_freelist_hardened);
+#endif
+
+static inline bool slab_freelist_hardened_enabled(void)
+{
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	return static_branch_likely(&slab_freelist_hardened);
+#else
+	return false;
+#endif
+}
+
 #if IS_ENABLED(CONFIG_SLUB_DEBUG) && IS_ENABLED(CONFIG_KUNIT)
 bool slab_in_kunit_test(void);
 #else
diff --git a/mm/slub.c b/mm/slub.c
index 8fbc6bf8ebc5..c82bc626b657 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -214,6 +214,32 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
 #endif
 
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+/*
+ * Free pointers stored inside free objects are encoded according to this key,
+ * so it must not change once the first slab has been populated.
+ */
+DEFINE_STATIC_KEY_TRUE_RO(slab_freelist_hardened);
+static bool slab_freelist_hardened_early __initdata = true;
+
+static int __init setup_slab_freelist_hardened(char *str)
+{
+	return kstrtobool(str, &slab_freelist_hardened_early);
+}
+early_param("slab_freelist_hardened", setup_slab_freelist_hardened);
+
+static void __init init_freelist_hardening(void)
+{
+	if (slab_freelist_hardened_early)
+		return;
+
+	static_branch_disable(&slab_freelist_hardened);
+	pr_info("SLUB: freelist hardening disabled\n");
+}
+#else
+static inline void init_freelist_hardening(void) { }
+#endif
+
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			slab_obj_ext_has_codetag_key);
@@ -565,10 +591,10 @@ static inline freeptr_t freelist_ptr_encode(const struct kmem_cache *s,
 {
 	unsigned long encoded;
 
-#ifdef CONFIG_SLAB_FREELIST_HARDENED
-	encoded = (unsigned long)ptr ^ s->random ^ swab(ptr_addr);
-#else
 	encoded = (unsigned long)ptr;
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	if (slab_freelist_hardened_enabled())
+		encoded ^= s->random ^ swab(ptr_addr);
 #endif
 	return (freeptr_t){.v = encoded};
 }
@@ -578,10 +604,10 @@ static inline void *freelist_ptr_decode(const struct kmem_cache *s,
 {
 	void *decoded;
 
-#ifdef CONFIG_SLAB_FREELIST_HARDENED
-	decoded = (void *)(ptr.v ^ s->random ^ swab(ptr_addr));
-#else
 	decoded = (void *)ptr.v;
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	if (slab_freelist_hardened_enabled())
+		decoded = (void *)(ptr.v ^ s->random ^ swab(ptr_addr));
 #endif
 	return decoded;
 }
@@ -601,9 +627,9 @@ static inline void set_freepointer(struct kmem_cache *s, void *object, void *fp)
 {
 	unsigned long freeptr_addr = (unsigned long)object + s->offset;
 
-#ifdef CONFIG_SLAB_FREELIST_HARDENED
-	BUG_ON(object == fp); /* naive detection of double free or corruption */
-#endif
+	/* naive detection of double free or corruption */
+	if (slab_freelist_hardened_enabled())
+		BUG_ON(object == fp);
 
 	freeptr_addr = (unsigned long)kasan_reset_tag((void *)freeptr_addr);
 	*(freeptr_t *)freeptr_addr = freelist_ptr_encode(s, fp, freeptr_addr);
@@ -6730,7 +6756,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 
 	slab = virt_to_slab(x);
 
-	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) ||
+	if (slab_freelist_hardened_enabled() ||
 	    kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
 
 		/*
@@ -8766,6 +8792,9 @@ void __init kmem_cache_init(void)
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 
+	/* Must be settled before any free pointer is written. */
+	init_freelist_hardening();
+
 	/* Inform pointer hashing choice about slub debugging state. */
 	hash_pointers_finalize(__slub_debug_enabled());
 
diff --git a/scripts/gdb/linux/slab.py b/scripts/gdb/linux/slab.py
index ddde25aeca8d..eab6cf44b54b 100644
--- a/scripts/gdb/linux/slab.py
+++ b/scripts/gdb/linux/slab.py
@@ -96,8 +96,14 @@ def swab64(x):
     ((x & 0xff00000000000000) >> 56))
     return result
 
+def freelist_hardened():
+    if not constants.LX_CONFIG_SLAB_FREELIST_HARDENED:
+        return False
+    key = gdb.parse_and_eval("slab_freelist_hardened")
+    return int(key['key']['enabled']['counter']) > 0
+
 def freelist_ptr_decode(cache, ptr, ptr_addr):
-    if constants.LX_CONFIG_SLAB_FREELIST_HARDENED:
+    if freelist_hardened():
         return ptr['v'] ^ cache['random'] ^ swab64(int(ptr_addr))
     else:
         return ptr['v']
-- 
2.54.0


