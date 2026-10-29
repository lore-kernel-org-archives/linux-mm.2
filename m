Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA04E606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kfZFuq0D
Received: by kanga.kvack.org (Postfix)
	id 034D16B05BB; Thu, 29 Oct 2026 02:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BA16B05BC; Thu, 29 Oct 2026 02:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63C86B05BD; Thu, 29 Oct 2026 02:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B22B36B05BB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:08:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 104CD1402CE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:08:53 +0000 (UTC)
X-FDA: 85374635346.25.7393E65
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D01140004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:08:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kfZFuq0D;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf27.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.177 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fr6lsRVu7pKC2uMXBLAv6yVcpzLAtilFokqfHYV3ttU=;
	b=KreVsdeQfSEa6zxJblBltwaeRtUX/4RFCvaNejgiA6YecuMJbs3mgmhWVbIKl59jnbisxL
	CeBPq6kMZMglZv+g7p+Ey149sgRVHMn6bK5WLhWHfapNsEKhLfaSPBGO1bcm0vLmioueOs
	mjyeRMZbWKddf/syYBkziSse+SqdWBU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kfZFuq0D;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf27.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.177 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254131;
	b=yaXLRZnaW/R4q2iD5ETfC7a+9C1ArVZV5cnhj2O4IdvMYOgoneeTI7VqBGvDuAK85Dqe4a
	7FOQ02BlvqYv5EbIc4UL7jQ9782JasPjfAPJjHmDlqX2CujxlbGB6CKG0/ZllPPP5NlUtG
	jIGv9oXUMmn0L7hyM5zifsiwKwjYWQI=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a01cac8733so1391947b3a.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793254130; x=1793858930; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fr6lsRVu7pKC2uMXBLAv6yVcpzLAtilFokqfHYV3ttU=;
        b=kfZFuq0D+BUMm5ihOMxp7pt3VMtsBBwHQc2FJL1sUTQw3hVWF+bv49U5ZPEAXwFCqo
         q7X0NFtUgW1Ibfp0vxwo59G8HiQVlHBkXdJTCZcKM4sBZpfom2Hht+PhsMKW2vjPr/R6
         8ubRZMaaLzduY57DTcE0T5MJmlUdKJRbChsmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254130; x=1793858930;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fr6lsRVu7pKC2uMXBLAv6yVcpzLAtilFokqfHYV3ttU=;
        b=wAg7yQWe3npq9LSvNuauBRh7twqd+HVR8Ukf0MCEUCAmTbDVMFgtJeTzICDcCdgWnD
         aRYxtcQuqoERgtH9hva35Lp8zp2XYpi6F9K97+wodBcOyIL3zdJYUryRJEk9qVoW9Rq7
         Kza+r72Kun5sZRurH9ajOhHsFdOnPkCyQOSX3UvojvSbQDBFTHXafnBAfmfeJrpQVeR4
         msTODu2pz3UE+FY79LGLf7JhIFrttf1/TQhsDWBGfdZw8SZnVDQevy7bRG9bGv9aTbkX
         zek98L6PRlsAKYXCijUFaoArlD4/J+LMITFpc5+H7rz3OxCWPLVOsknSbC7UzyZLgVA9
         tQmQ==
X-Forwarded-Encrypted: i=1; AKwUvByVkfgPu+aj4ww4/UZMYnn2UfqGkuYFoOmzg/1LGMGkbVs+uIKBfMulJEPd/1K6X+D6DdAVyDq94A==@kvack.org
X-Gm-Message-State: AFq9FYJNc/NxyuVqgZKa3Bc8XUnw14clb4xlM5BKh0hJGANwnnErjbxi
	rvijPuZurlUJd2lxryFf1gX+A8fsFjoUvEXYNSmSQLl0x0pG3+9BzExLc9DF4Us988U=
X-Gm-Gg: AYBFou0bxFIDkcLeoxybMXk0/BHpkSzyCDYhGC8S2AJhIL9U4RjI2ptcgqtNn2xoPSx
	9T7vrE01VJqC7CK8zP9AU6Ru7auBhMaLlou5Gvi7vIMVe2BvcDRUdTNHN8XTYMmbCWVgGXL5LrJ
	8WXhmCjfB74VtVqsfbQbAfd9TjmmI8FxA1RPS72fgCGst1nN9d3pMADQzvHkY+HZ7Zejx95b4O0
	1y85wcxmla1ub4BB1Zq5lqm2rm4ip1dYQ1uAsxfo0qnmGyNr4mbh696sxGynJbWJs6V6i5c64hm
	c5gmndC1nxsqf0BUQS8VeXigEX8XbO2I9bj4lRFwTZPvnJTwn8FE93UCMHiyQ0ZrkDjMe46P812
	x7CRqoPIydnHNDHQAC6SDTox97+cA9d7FuAZy+ebbGfljJPm4ZrrPFODzKUDOytFyHykC8UCzIy
	cXz9RQtKd6OSX2PWY2X53/N5FANmg6d9ASjW4SIiJQQc0VwhBKFAhuIlb3ye1pllbm6pDmk39Yt
	PSY6dBdmHuyaAQLfxirW7Iqfbzg8/GR2QccWXbn4JzB7sLmLAgKrff6kSd1nytwB/JiCsIE8t/h
	QYiYaRAb5cHP3TnWUXckOACH8RdghnYd5nn7YbqWL8Lg/+OdgIcnZNTK36HWRsOUoTEme1IYJmp
	iVbrisCKo1tJ7P8DFfOYuLi/2ukggweV9AodewjYKPju2WfULZwF42o4nkeO6bFN91mHvEzfEGC
	+Lv3COncRoU3uEj1JjcQ==
X-Received: by 2002:a05:6a00:4518:b0:89e:37b1:b81e with SMTP id d2e1a72fcca58-8a6e71e1b92mr3812208b3a.31.1793254130054;
        Wed, 28 Oct 2026 23:08:50 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6df0b52sm1840758b3a.43.2026.10.28.23.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:08:49 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:08:44 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 4/6] slub_kunit: Add a test for the slab_buckets boot
 parameter
Message-ID: <47c0b11109203640122a9b5b030d3f41bfbac609.1793253633.git.chris@chrisdown.name>
References: <cover.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793253633.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D01140004
X-Stat-Signature: qkehp1xkadd1rmimxet37dc567o9bbdz
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793254131-166932
X-HE-Meta: U2FsdGVkX1+kITkYEhtw9XzcQEEGKJ875tKCjyS+39N8n4Pi+oCCm7OgbWS6YDxVLWwJatwp87DMybiPfQK6pj+nKbAsIdyW7nxIkb/izJmKfOr0YDF5xxT1kMFpSWad05P2M2166EbTRv74iFh9U+0MY9bDMwwDZPj+/kHP/82uW+AmG+kQq0m1/6uND9jEa/CSD3W4Kuud5pH3gSHNBYz8SJ+U7ag6F4GHRUjuXuX4zK8SZhHev+nBqEDQ7HAEmDtloii66cPN2RV4jc1kti6ZBYP8/fI2U7nbNi+nFe4uSjqW4AJL5hR2LrmsBTWjz2HO+md1ZqbzOHI7aMtBcJ3NmVAMieYRxSzhnoE3WjTheJfZ8MJM56RZn4bMtvxCDB2vHpqm8MTU5XeccaCej8nSAVxUC/tIlyjP9cucEaSHkJoLoXNVVCoo7LwbeEPD8jHRnwxdumdDAZJziPuz/mIPC4D8pkOZAuTt7xB0KQB/JrdDt0RRcFCqZzMGl0LOfdabAIPLr/sxegPIMYH2WTESnWFqPzM4xFrnOUeWdZ0lM7pkbk6+MmbxvJuHCsaAn6FSjHLmYNeKsLazkcdcR4z08fdvd+UMNpAVCjBktbB09/FjoY19pMBlwq5fI9xWrpyrXmwYdYs1CK3Eyw7CJFq5qCxQ7moXHT6RG9+Q5migXByYW3TwfjEqo5627quS+pax63HFdADkrNGAPd5XDukziBFnyj27IES5cVBizzrw2VwqY0wRberc/4/KqV0DKrWimemYAprs2flB3YD8cmqclHrGSuzR1xQgGxt/osaDbeC/j1IMlg5RnGdMJxAfpINVi2kfpa+nHXz6UEA6Kb8111NOhAyWvGoo9rEBd0B3cOiEYwOUA8LfJdIPeNzifwjQlwk6gocRwtALAgqF52tvLv2wNdKDlmTz3XAMTu+ccG+wed6NPv8ujfjpYuNYa4/lRIWUH7UOACxiwXW
 B8DJ6OYw
 W3np9FrWNkBEfDRlVPJdbK6hnix1L781EwZRUiuJJ/qR/TindGwZH5Y66lrGvS/l62snqKsXc48KnZmDTHnrb6hKkykNVE/hnKmmH8i2KXNBayApvq+hiX7W4OuKYYCFc8DUqx1r78MmX3mmhdA8h9FVdWNL6KceWe8+L6GngEqZkzt58w0ceDDAWogyPtXBMGhH+HC0BEJoNpSRmOoEMwDTPHiXQavlIfRtV0r7ZZYpHVx4dPKRFSw2Uc8iZfeFmux+niMCQ2LsdGS+MfwGmMh7Hw1FZrW3f6nJHS5lP7wjloBVQMfrVq4x6l9hYlNDHkbiyyL3TWdeGuhvEQ0f3ztAhJ+WMU1Mkgk0qRaDYvuR/vVl/cmRUu1B1nU91Na4ElsX3iKc5Eu7TecrSNQwOVqqJtBybg0ua4w1jA2tkSXLHEiw6vkSfJEBGiqSQDaJ92ECZn7jQPaRKORofc4BxVUcrhsvfeNp2Y784qGAUj2Ac0OnN3ulV0mHS3eB1mQegrZjiPv9MOS5yt4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that memdup_user() allocates from the memdup_user buckets by
default, and from the regular kmalloc caches when they're turned off
with slab_buckets=0.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 lib/tests/slub_kunit.c | 41 +++++++++++++++++++++++++++++++++++++++++
 mm/slab.h              |  4 ++++
 mm/slab_common.c       |  4 +++-
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index e3b63f0338d5..670645875b27 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -9,6 +9,8 @@
 #include <linux/delay.h>
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
+#include <linux/mman.h>
+#include <linux/string.h>
 #include "../mm/slab.h"
 
 static struct kunit_resource resource;
@@ -296,6 +298,41 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
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
+	if (!IS_ENABLED(CONFIG_MMU))
+		kunit_skip(test, "userspace allocation needs an MMU");
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
@@ -489,6 +526,9 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
+#ifdef CONFIG_SLAB_BUCKETS
+	KUNIT_CASE(test_slab_buckets),
+#endif
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
 #endif
@@ -505,5 +545,6 @@ static struct kunit_suite test_suite = {
 };
 kunit_test_suite(test_suite);
 
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 MODULE_DESCRIPTION("Kunit tests for slub allocator");
 MODULE_LICENSE("GPL");
diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc..b5b344d6e402 100644
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


