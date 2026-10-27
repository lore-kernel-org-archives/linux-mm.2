Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C902260A2610
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Jpe+3fgk
Received: by kanga.kvack.org (Postfix)
	id BC3226B05F9; Tue, 27 Oct 2026 03:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73F66B05FB; Tue, 27 Oct 2026 03:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A456B05FC; Tue, 27 Oct 2026 03:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87CCF6B05F9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:36:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 156631A08FF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:13 +0000 (UTC)
X-FDA: 85367597826.06.A09AE1C
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3DF29C0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Jpe+3fgk;
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.176 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NjMmv6pm0tIRvcDaHQJ8L51He0Pq3qbg9jRbmDfBhFY=;
	b=r5gIU+dDQLywDaiG/lKVSBmmPZIAEpuOCoEj92x0llXCMsny8qPZRJCMylcPBLhPWvJHzr
	ReF5pciYov6mAZLzphmbD9LGtLy7Nm9ig5lIQpdXAcYGTgg2+KvH26ygZO3jaszZxl7D0c
	8YL3hw+7B27cdRLhbuDgA2l19uRqQfQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Jpe+3fgk;
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.176 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086571;
	b=tSrfg6+mnXkC8pBPhbult+AqrU6xaI+KvGXhJ3XtpJjN2fNoUhFQu1oL5eX3ohAtXdahIY
	nk2o9afr40nukpq0w4XqsEJy1gi72OBO7HGlVyIFrLUjlKuONxGvVt9wT3WzhTuw5wgMje
	Gngzdvs3rMfKdff65PyEPiGOCsNAc+g=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ccca948203aso1188369a12.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086570; x=1793691370; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=NjMmv6pm0tIRvcDaHQJ8L51He0Pq3qbg9jRbmDfBhFY=;
        b=Jpe+3fgklmB3H6EkAXAqENB/p1VhX3j+AbUV3Gxt62n1Hu/gi+ugBCQ96mWK0JWwsF
         KhvaNtVDBU5T1A/mNPxagQjdwRLrJScsnLUBKp9OgiFa5vd3/5BZhGcueAJqSdLYagMt
         oRRoFi2oCZJVXq/pL15gayd2CzFx3ZCtPYn1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086570; x=1793691370;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NjMmv6pm0tIRvcDaHQJ8L51He0Pq3qbg9jRbmDfBhFY=;
        b=Nnkipr0zGtE10trNFeACE9k/9lpMmfH9rLtPSRmFoqu7DS1WspTcoXM/zaBE9DzynF
         LnZLLdBBae4/Bx46Wof+t1oaqdZ4WDXvc3rGkpFHm9B93ucu65aZqJKXZ+bw4oFYot7e
         gq+lIbnLKeSSHzIq80CNuFZ/Xf4FZM7anvrEj5c7jZSmbMEd8DCH7L0gMQyjosKVV9c+
         /BgX0QFhnc5kbfzRjOnDCY/FpTm55bLF00FDpNR+I+Yy34XjCT5nAnnIByqKHMwmZllB
         l+CBuUzZJh8TrwmMLLfWKAXe1zyvxNvlci8lckLt1wM70/5WN1aG3qzJjLueE7tNEOWQ
         Ra+Q==
X-Forwarded-Encrypted: i=1; AKwUvBxWlSqbDJxHhGTZDHsyyUi3fMymkB5xk9Aa77ooDzOjaJZyH+QnGuTSywGzcvSgFdM4jYEA81+1bw==@kvack.org
X-Gm-Message-State: AFq9FYKxigqN078D0MnQmuQW8MfiSBMy2E9aRQ6nqas/gvjFaiPpYxfr
	6NZRDKk0nrrNj96QM+ZVI66U57gEek0wS9YswgEpr9N+foQtrW57MpS5mO1vTgKINDI=
X-Gm-Gg: AYBFou1JEUyZmJX6YIcsh/JOX8qfLG2a8xLpflennklf9V6To3hw7/3nnELQ5yy2Qcy
	fKjTBuoaGZ1uQEt6IW9VE+ka4SnVB7qJDboLaDQB8L98FD/sP3bDo3Sp6fHZOQkRGajCKNxWJDE
	UmLOH+/v1Zw0UQVTXSfaAjGE2W9GvhBeYnpNM4+4cYyxb8asUeku7LJMP3LclpeU0SzvqUS7r20
	Sf+g6NMVngIJVNv3oeaesgUpj5Tyy47qrjSbkYa4rCIPSA31iuU23/cP92z8JTH4rMwnzSFq9nj
	pi8X3SccK0UQ+G6vXIBYzSamn+PZL7CsTWyc7FGs00Nl/iZ9MRXmcS0IE0yPCl/FsXaMBxBSEAP
	VisnZEUA2nzBopS+IJe1cn8NWo0pyPD+lzcA5QXVzXyx64WSN026xMGWp4/6gCWfRzHkixozoQe
	fIOcIPEx8pLv4kHDLNxRDH8/LTa8mNJM9ye34MkEvaWz9xfzE77SmDEn5Lio47Q5J/MaFHhdiCu
	Fi9opv78/aHi1kDCfOMi4BjQByJ3W1SL32mPkssIubNLoKInVh0mCL2N1LQa7pWEDAzv5gqRsdL
	RvYB/cbRT5HE8kkiALooGFY6i9PZq03niyn++7W1WYYAZACQFJfrLNff4rWhZ3CCFYH1e8+Gwoz
	whkxnclItGhpnxW6LX9L+4Xo=
X-Received: by 2002:a17:90b:4c92:b0:3a6:fc30:ce16 with SMTP id 98e67ed59e1d1-3adeafc7dd4mr7341488a91.51.1793086570089;
        Tue, 27 Oct 2026 00:36:10 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adf8f3f22csm6639832a91.3.2026.10.27.00.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:36:09 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:36:05 +0800
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
Subject: [PATCH 6/8] slub_kunit: Add a test for the slab_buckets boot
 parameter
Message-ID: <92d3b7ad95c9b7cdc76eb8f361cc2b374c018edb.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DF29C0006
X-Stat-Signature: k1ggezgy9491p8i9c976ywqqh563ym7o
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793086570-722521
X-HE-Meta: U2FsdGVkX1/7w5bwX+O3qMrtS2p0Du6H7oJtGDIri6f/z+5CrnI5sj0RKmt9XDOQj5JQzdpWjWf+F2Oca3Cy7aparX8seEE0N+O2XjY8qz6rL6h6yO9HTv7wY3yPkPzd6nn1bNdowor7ZalsZPcn4WmczomSWE0yUCpLvae2oxcpv7ODXze+LPL6ICgPMfskFrR7GvC2RZOyWGMP8jEImlmSfvZ2o/Lx5a3TFNJGL+1jjhKimigAWG4uTGyPdQFlVDxlTdaeBlwQJqmzpUty3Ov8KSpwk5SurIX2ClexJfgPdZdZYhw1EVfp1aSgKZuwt4Phnrru2+pdMS6kYMHvwZL4hErV3qPTClD4mmQ3hYUn9T0oKJ24gdcU21lUSS6xvvUnWQwr2WjT78t7yOyQ8AJEaWNjxh5JytkCCX1GssDafYqDoapPsjMrVLuMtSQZI6wXwINZ6CPM96qHSxXoYKieajjzB2aAE5/ZhbD0oEVbXW8d8Bxf+YsiMD1+ch7lgNwVFXi8qRPhvWs4zRSRiT1L7xUOt90zd6HRwLzdRLk6Gg3W0Hp4lOjBlzuB/LSFYDRdAJxVUAUKKO4+h7SN8m3h2a31rCIpFawSVzHTnYNDQCSiHGtgnKrGKBWK0nko1K+h1l9Uvs/9qa1jjVG2OAaMT+plovdyfO03csqh8LRueq0qpJd4PiQ8iEV0syAdBoyC/CfCoD2AxQRsytf51bx2LhsKfLfzZFwa3BeHNOx41dPuLIwzNdOj4+bu2GVz8Dxx6YY8z/F3Q4bzsetkknZo46PJPpt9sJXdHHnvL5MsU466YMU5AjnUuKwTxkY7Ih98mdKyphoJHLzbaRiKSHtUQq4qX7oa25YM2Fmcu/xFPpdmRJBalaDQIdCMWB5nNVwyNlb/n5hS8UCypbRkKjoC9yDHaL6Hkufda+NSsyOmS2Bx1L3ZNQOTQxvXkcFUU30D6FAmdLRFy0Meeqq
 iaobqgCO
 baSNeVA/Js6v1SHfKR3CZa3Va5afqd36YkEthwM6VP87zyyOulvgKwrgOmeYc8Mah3R9OuqjqOMV9n/6yMUUCzaMY08i61PBnkwjSp6p66TT04X2Z2q2+MGD5wCEMmxwtuultOuJ55MzS4/BIE9OYpceSMktCvf5yBXg+D2/+cza8E1/SYNOCQmLECAr/0hzsyOj0W8bceUBK1zWUi2LGZ2dZ0hPK5x++gQPvfpE3zHhhPvvHnQCGI+snenJq3zeu/kYdz1V2AZZvg9cTylh3280tNEadJpvkl8fFa4TqCXWY6HJjC0oY/kzWXxQidFj9F9U7H43W+eMKhte1iEhLAUShkhgVjqzjqFHCl7Vr5j6tYrp1mWnX69oEoMaunm7vEFV5hV5Kq3Dqw7w0ezxQtH1/1+t7mZyL0Ua8yuOdo2SYzJISpXu+8ATwecYg8d1vfcCZpt2iGP2nOX4AtaEsvRSCJo6pgRNy4XjXsV7TWjNeVT9OeWHPTDViNVFGEvOyIkMY9+ikeFueTw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 lib/tests/slub_kunit.c | 37 +++++++++++++++++++++++++++++++++++++
 mm/slab.h              |  4 ++++
 mm/slab_common.c       |  4 +++-
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 49b9942bc564..646596663b33 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -11,6 +11,8 @@
 #include <linux/kprobes.h>
 #include <linux/string_choices.h>
 #include <linux/swab.h>
+#include <linux/mman.h>
+#include <linux/string.h>
 #include "../mm/slab.h"
 
 static struct kunit_resource resource;
@@ -396,6 +398,38 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
+#ifdef CONFIG_SLAB_BUCKETS
+static void test_slab_buckets(struct kunit *test)
+{
+	unsigned long user_addr;
+	const char *name;
+	void *p;
+
+	if (!slab_buckets_enabled)
+		KUNIT_EXPECT_NULL(test, kmem_buckets_create("TestSlub_buckets",
+							    0, 0, INT_MAX, NULL));
+
+	user_addr = kunit_vm_mmap(test, NULL, 0, PAGE_SIZE,
+				  PROT_READ | PROT_WRITE,
+				  MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	KUNIT_ASSERT_NE_MSG(test, user_addr, 0, "Could not create userspace mm");
+	KUNIT_ASSERT_LT_MSG(test, user_addr, (unsigned long)TASK_SIZE,
+			    "Failed to allocate user memory");
+
+	p = memdup_user((void __user *)user_addr, 64);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p);
+
+	name = virt_to_slab(p)->slab_cache->name;
+	if (slab_buckets_enabled)
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(name, "memdup_user-"),
+				      "allocated from %s", name);
+	else
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(name, "kmalloc-"),
+				      "allocated from %s", name);
+	kfree(p);
+}
+#endif
+
 #if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
 #define NR_ITERATIONS 1000
 #define NR_OBJECTS 1000
@@ -591,6 +625,9 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
+#ifdef CONFIG_SLAB_BUCKETS
+	KUNIT_CASE(test_slab_buckets),
+#endif
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
 #endif
diff --git a/mm/slab.h b/mm/slab.h
index b648b33f25c3..185df5e68419 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -390,6 +390,10 @@ extern struct list_head slab_caches;
 /* The slab cache that manages slab cache information */
 extern struct kmem_cache *kmem_cache;
 
+#if IS_ENABLED(CONFIG_KUNIT)
+extern bool slab_buckets_enabled;
+#endif
+
 /* A table of kmalloc cache names and sizes */
 extern const struct kmalloc_info_struct {
 	const char *name[NR_KMALLOC_TYPES];
diff --git a/mm/slab_common.c b/mm/slab_common.c
index b7a46c368ab1..9fe48da12010 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -29,6 +29,7 @@
 #include <linux/memcontrol.h>
 #include <linux/stackdepot.h>
 #include <trace/events/rcu.h>
+#include <kunit/visibility.h>
 
 #include "../kernel/rcu/rcu.h"
 #include "internal.h"
@@ -410,7 +411,8 @@ EXPORT_SYMBOL(__kmem_cache_create_args);
 
 static struct kmem_cache *kmem_buckets_cache __ro_after_init;
 
-static bool slab_buckets_enabled __ro_after_init = IS_ENABLED(CONFIG_SLAB_BUCKETS);
+VISIBLE_IF_KUNIT bool slab_buckets_enabled __ro_after_init = IS_ENABLED(CONFIG_SLAB_BUCKETS);
+EXPORT_SYMBOL_IF_KUNIT(slab_buckets_enabled);
 
 #ifdef CONFIG_SLAB_BUCKETS
 static int __init setup_slab_buckets(char *str)
-- 
2.54.0


