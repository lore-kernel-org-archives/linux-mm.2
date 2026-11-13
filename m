Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99EA0606B37C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=cN9U0c0H
Received: by kanga.kvack.org (Postfix)
	id AFF026B0625; Fri, 13 Nov 2026 03:51:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD79C6B0627; Fri, 13 Nov 2026 03:51:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DF86B0628; Fri, 13 Nov 2026 03:51:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 709856B0625
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:51:39 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F17484023D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:38 +0000 (UTC)
X-FDA: 85429477476.24.34E28B7
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1BD1F20003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=cN9U0c0H;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnWUSSllMVMhg7PktgO/3YoCDA/za9YFOUp/rF6lTqM=;
	b=Tiun1E6YjC8nl8gLN+ZRlC1Hf8jg3x4CIOe85BjWedBnWMiKpLfQnuA04ORh9D5s7w15xE
	yUMEuBOwW4cvkhcdyuPkMmTMXoNnIjFDx3YNYndQb0q5ovWGC6/D8diSVOdBtOJGkVJo/4
	WZTcoGqozkLMKEBXuofBvkvuYlQ2vvk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=cN9U0c0H;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559897;
	b=K+swNM05VmwqixejS/x5HFMZ0sZ0PXE5DY81KujI+gtb1cj1pVSXbc3MZAi8HsaN295SFh
	/QnwO7Q/U8ygYy7QZiSz0dTFdC+Nv1aClaqp2nmqkjlGGb0kOEg8dM0o96czycHOzKenBL
	7DnhAwodaKODwUHN0wf3pQrJQ+uUmLU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ed11653a91so6645275ad.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559896; x=1795164696; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UnWUSSllMVMhg7PktgO/3YoCDA/za9YFOUp/rF6lTqM=;
        b=cN9U0c0H09Zz29QY0VQEiFwwCumKGdEKz2qXoO/SH8hEeFEqVkmjQTD10bE5ulcqmI
         WiaE0F/u8xqxJ282BfFzzFE3X8Euu+pZwx4ER2DSmYLLtMd/sDq5/6HFo7G/0XCDIUrI
         GIyAWKdkgbOrx7J/h+Py4+LNjlSOTkGH7zxOQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559896; x=1795164696;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UnWUSSllMVMhg7PktgO/3YoCDA/za9YFOUp/rF6lTqM=;
        b=aRi0p6ob997azOwi9PwzY4LIeej3tVRnibsYbUFVGqWMq3aCa67bbLkb1fzgDiGlqM
         Dvz4zggyptClUYzRSDUueO4Ef4i/U6JoQboPZ3wMDIf8KEsqfb1VZLx3rMPaJEbTwMjZ
         1rBEaGZTxlnVW7wvxw1oAB8JbUDifNyxBdFN8IQq/I1C2rcMyYjPGpn74+xVtmF1E8Tn
         zKkWcaYiOTZOogQc23xlsFybeZ0BC4CckhYM3MhxQA/XdRrO+zM/Bap/U4kwNhywa+Fd
         BhA+0TCG8QtrFrtN4rWLenKT9YXtMGqm1mHRlsmrWAalcA87wV7VbpKp+aUgPXjmV2AC
         f9nQ==
X-Forwarded-Encrypted: i=1; AL+hErGgK4+hOvKVDEnUbGnWn+TCmJRpDgDv+LeugdUkX3ngK1my8MDEZ0lGrIPyb13WTvf8zNuw21/56Q==@kvack.org
X-Gm-Message-State: APuU4Z+CjTH36Jesh2eMyqMy1gPPVctW/Pk+Iu/6/3fYQSdreiTqvdkV
	n5jQNM0PA4JmxLAmxHUGyS8oWWYmD348avz6WKyHPCYEyI12bddkIr4Q/cCgTvdnvXY=
X-Gm-Gg: AYBFou1b2zD17wGHKCvNHFYl1AVKeY/OfFfTWc2wbyAtK0QIjeLeKV1Bs5+E+eFjuzL
	Dr79XJOUNyfNh01PCPuZFK/E9Jo7VP4PG16OWGClOLskJX5iouKgZUT4xfa7LrVRjmTBm5egkyo
	glhM9Ymo1otSbZGuVqOfvVfxYFi4VMCtLuDbBEIgAEvveMDovhODRl+3q5fqJYKKL1v7RXagY6b
	VAEVfJN5+1L63JE2sMyISurOlkQRQ7iFPLXZOU2cYDBAJj/l1ESvGEe4HKHtLQTP33qn5aSotaM
	ycnYHeyuamTUL2f0oKKQGqTVNAfGdKY/HE5kLHGFqExU77D5v5kALN9pQeuQMoxhAzKVWYlJ8al
	v9eFYLUxEKtawj5eC9lADFYHLzHIacBUgGypfqKV1zwZ7hFCRJZaRwhQCkLQaOFZNQ2YUPPq2sr
	CgpBmZF2eMtGk+VtNkZqh6FJp2JXAWU9YjY/htXNI/6l48HoJhzYsRhAM80La1eGqsNvxwAyX3g
	Ge1Uw0vl+Mwo3yf84C1jEnftkwiFNkGMbyKcyWhRlJl6tzkKZ/YYrwdVrehSHKTCGK+KAeVJIaa
	xQQH6sC61pHGGPzgObIiGp46kSljYcMWsNyTppe3F4sRmLowWhK1lcpGFZABSsqjqTrVbPc9zG0
	f7YxMYFfbF50G740MLraRlaLAz7mebWajOYdf8w4sEA+Wc/A1O85cNJw0zOJc7f4il3i6hDUK0L
	h+tyg8zHMk8dGothCph4PuYgUa4ABoouDLhWTDfciBu+dXGh7jGXTy4fBAJmE=
X-Received: by 2002:a17:902:e88d:b0:2ed:acb:aa96 with SMTP id d9443c01a7336-2ee0dad0247mr21324925ad.24.1794559895887;
        Fri, 13 Nov 2026 00:51:35 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f75c86asm7039685ad.23.2026.11.13.00.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:51:35 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:32 -0800
Message-ID: <843f0f05bbe3ff36efd22d490e83b0260f8d2f81.1794506262.git.chris@chrisdown.name>
In-Reply-To: <cover.1794506262.git.chris@chrisdown.name>
References: <cover.1794506262.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 3/6] mm/slab: Support disabling SLAB_BUCKETS at boot
To: Vlastimil Babka <vbabka@kernel.org>,
    Harry Yoo <harry@kernel.org>,
    Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
    Christoph Lameter <cl@gentwo.org>,
    David Rientjes <rientjes@google.com>,
    Roman Gushchin <roman.gushchin@linux.dev>,
    Kees Cook <kees@kernel.org>,
    Marco Elver <elver@google.com>,
    GONG Ruiqi <gongruiqi@huaweicloud.com>,
    Jonathan Corbet <corbet@lwn.net>,
    linux-mm@kvack.org,
    linux-hardening@vger.kernel.org,
    linux-doc@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: 15ed1pxpkdr7mxjdr1adtq84wo88ymd8
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 1BD1F20003
X-HE-Tag: 1794559896-102738
X-HE-Meta: U2FsdGVkX18Rjb8F+gujfzUnyCyIo7nv5MIgTy1dtuOnew/KC5namGhgNAF8rA6sOyg3LgISxShn5TNjntCRJX5uyMh8d4Y2aExCrXu+wGiZFNVTYCpXtiNKtuOg/ajWbwViGlYuBDG41up4oSLk9CQ42JWTAtxBnOb79i/ocs4sAn/4l0nP2gLfqANP6KMYcAn1p1lshFpyqI8Oin7w9yjszynzI+XBRiqYjxoAPMxojtvWf3dk7gqybbBH3GReaVODBKdc/O6cgNND8xW3WpRnjW6f4cBcDjAphTR5aeEh9L5QpHLQS5c6dsgzkLoGAOyF5IVq1QlaZtj/SR+Jn9kjOUqZug/xQDLTDMUkKKnt310X65mfhOBM9TA2wjN0kuvrEUHitA0O3DCXi2zviyir4dLmvvQRnBagxaE3SOE3aO+tuxxSkN6RxMyWo+N4oWdr46+IdyC37OIQRkxr87x9PEZOIZVVjPGd1/jHg6xovDKYOLLeVwRPbrfgEsOt0OQX56RLdJZhIjJzqqi410aP76Y3S2l9YJCXbRtKsVAIjjZTxWnlTLjaUCMAhQ+P4IxoIquYQxn6N8JvIumkX/KPMhHaY97tERaK+0j/g9AlWPiwDG8pusAgq5sBdOn6ew9hnS/+aHHfs3XEtUpy7K/HXOGLvIdHL5Dcxvjfe2erOUiJOwS3XMmQTWZgDGfsrriys2c2ur+rZ/V6wiMz5WctNK/vZu0gxyaksrbtHf+1cj2SmcRyzmmMvz2aQmI/7Rt2HxPZWh5wBWBIaaDMPImXeoSBkK5Ga+hBtAPIaSzFMpT2Z6mhUmULdThOjl2PhSZv507lMFZ+rVWx2NS3brXAmPmIGQ24uNBgwyOtLGpzlebKieqDV1r11zZOIeinyPhDk6a0kYXBLwQEHkJOExDfwao1ZM8Z1LKUNyiTOO1nNx/ohR4sRhVFycyHPf04OQh41QlJpQDNCwQdfyn
 zoS5466Z
 HD6URq8plcxJ3mWmqh0lczmyn4PQhrM+acapAmFM+zplTsnP7Iu1nopzYCSnhkzCUZcaIOB7AyHKwRFD9UpQv7a7dHMKyo9u5iZz0AqjmPK1Wg861K1SA/8glUe4+gLz0Lt31UWImdKxd0AiBIiSNjZ+UDJasqoFyD0xr1XfHkVjKqXNXbx7fZUvmBAVhlsdHSyWKKmy8LLIgvE3xDP326UvDGatCY6EMn7tAasdfkkZ+DHBeu0jI2fbjuhtvKHOA39HnJPn5HVq+9bnxdf5ed+1n0c7Qd2rmcJU7GT9sRZIZuNcExqJ9HtP56QE9KQv4Elp0JZ9ytztxc8Li+kL1UM7kDJVxqbTHOg+cih4lmjLSragMQHPshD7mUmZj0mvY3QCJZk1h14Ecim3y+AoCavrA8GxZSQdN5xIVYPQzvsgyVP92f4/kmeQnsCqa/fWyoeGUTjRb0p2/vjXPhVXmfJMGbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SLAB_BUCKETS gives allocations with user-controlled size and contents,
like memdup_user() and msg_msg, their own set of kmalloc caches, at the
cost of the memory for those caches. It can only be chosen at build
time, so hosts which want it and hosts which would rather not pay for it
need separate kernels.

Add a slab_buckets= early parameter, enabled by default on kernels built
with CONFIG_SLAB_BUCKETS=y, so that it can be turned off at boot.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |  8 ++++++
 mm/Kconfig                                    |  4 +++
 mm/slab_common.c                              | 26 +++++++++++++++----
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..c27bbe205051 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6990,6 +6990,14 @@ Kernel parameters
 			apic=verbose is specified.
 			Example: apic=debug show_lapic=all
 
+	slab_buckets= [MM,EARLY]
+			Format: <bool>
+			Enable or disable separate kmalloc buckets on kernels
+			built with CONFIG_SLAB_BUCKETS=y. When disabled,
+			allocations use regular kmalloc caches. Ignored
+			without that option.
+			Default: on.
+
 	slab_debug[=options[,slabs][;[options[,slabs]]...]]	[MM]
 			Enabling slab_debug allows one to determine the
 			culprit if slab objects become corrupted. Enabling
diff --git a/mm/Kconfig b/mm/Kconfig
index d174537d941e..e602ebabd6e4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -231,6 +231,10 @@ config SLAB_BUCKETS
 	  of extra pages since the bulk of user-controlled allocations
 	  are relatively long-lived.
 
+	  The separate buckets can be disabled at boot with the
+	  "slab_buckets=0" kernel parameter, in which case these
+	  allocations use the regular kmalloc caches.
+
 	  If unsure, say Y.
 
 config SLUB_STATS
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 01c64ef661e7..272d22f411c2 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -410,6 +410,16 @@ EXPORT_SYMBOL(__kmem_cache_create_args);
 
 static struct kmem_cache *kmem_buckets_cache __ro_after_init;
 
+static bool slab_buckets_enabled __ro_after_init = IS_ENABLED(CONFIG_SLAB_BUCKETS);
+
+static int __init setup_slab_buckets(char *str)
+{
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		return 0;
+	return kstrtobool(str, &slab_buckets_enabled);
+}
+early_param("slab_buckets", setup_slab_buckets);
+
 /**
  * kmem_buckets_create - Create a set of caches that handle dynamic sized
  *			 allocations via kmem_buckets_alloc()
@@ -424,10 +434,12 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *
  * Context: Cannot be called within an interrupt, but can be interrupted.
  *
- * Return: a pointer to the cache on success, NULL on failure. When
- * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
- * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
- * (i.e. callers only need to check for NULL on failure.)
+ * Return: a pointer to the cache on success, NULL on failure or when the
+ * separate buckets were disabled with the "slab_buckets=0" boot parameter.
+ * When CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned. In all
+ * of these cases subsequent calls to kmem_buckets_alloc() with the returned
+ * value fall back to kmalloc(), so callers that can live without separate
+ * buckets do not need to check the return value.
  */
 kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 				  unsigned int useroffset,
@@ -448,6 +460,10 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
 		return ZERO_SIZE_PTR;
 
+	/* NULL makes kmalloc_slab() use the regular kmalloc caches. */
+	if (!slab_buckets_enabled)
+		return NULL;
+
 	if (WARN_ON(!kmem_buckets_cache))
 		return NULL;
 
@@ -1059,7 +1075,7 @@ void __init create_kmalloc_caches(void)
 	/* Kmalloc array is now usable */
 	slab_state = UP;
 
-	if (IS_ENABLED(CONFIG_SLAB_BUCKETS))
+	if (IS_ENABLED(CONFIG_SLAB_BUCKETS) && slab_buckets_enabled)
 		kmem_buckets_cache = kmem_cache_create("kmalloc_buckets",
 						       sizeof(kmem_buckets),
 						       0, SLAB_NO_MERGE, NULL);
-- 
2.56.1


