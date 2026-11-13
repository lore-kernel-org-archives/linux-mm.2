Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608BE606C185
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=me6DRyxe
Received: by kanga.kvack.org (Postfix)
	id 114336B0629; Fri, 13 Nov 2026 03:51:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE4E6B062B; Fri, 13 Nov 2026 03:51:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C9C6B062C; Fri, 13 Nov 2026 03:51:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6AF86B0629
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:51:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41EBF8022E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:45 +0000 (UTC)
X-FDA: 85429477770.12.BCE4B41
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4CC141C0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=me6DRyxe;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559903;
	b=wHm1B27t8ejtekl2U++mL5ySN3e4TdVn6rosb4KTHgfQcsdkJ2f6X232p3ef+BZwI0ZwrG
	1kIfbL1PL8EnQqrWFS+GaXaX8VXWB+dF++r0z6+cyN7damWV8dEUH3fvHgiPXSxMo6nY/i
	gqXr6EEs6RTgfLjh8sW58RD2dsre2s8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7JpIOJtGBaq2Xw74Bm81qRvbnlUv386MdM8N1c/N3M=;
	b=kvYASqWPJf2dIAtfMkb9VKB7WfjIud/37xX4odSMEgapzg2T3/0tMxIcjELQW0VIMaaJgB
	inuq80PAPviF+kSyQQYuOJT2c1GfJWoXz2x9ifR8ElKR+9TpvAIrCP+fmFeTt4X1YevZqi
	pWLPM6u9EHapdgdyjQlTTdbo56KNB48=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=me6DRyxe;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf18.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.182 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-886e61fa30fso270230b3a.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559902; x=1795164702; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E7JpIOJtGBaq2Xw74Bm81qRvbnlUv386MdM8N1c/N3M=;
        b=me6DRyxeZ4i07aEbFlUzoMTkewIH5eVPfPAA6JeoGWffcwikagDmbfEjh587byLZCk
         6FYlcFbWhMmB0CrX88h4wBlyYopjdIqoYuOQOGVT1R4CvTxYiV7KD1nsYGkRNPL6hXAO
         uY6QkdF9tDBUVP1GROrdxTQ52+mnh9lhuiMnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559902; x=1795164702;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E7JpIOJtGBaq2Xw74Bm81qRvbnlUv386MdM8N1c/N3M=;
        b=MenXa75nZAXBHH7J6Bu8Z1w9M/T2AOpx/07+wiNV7cQJdlj26mlzorTMCv8BPCPhbn
         VCNrrhHd69xHATkmW5czRA1XlBIksPyphlhCbTI+XPxqYUUS+wZwnSI+Y5OXCsrWxpnr
         YqDeHF6Zc1v7J7Aw4ZQuAGE70jDD+EFKsY+PCd7HdbgFD9+2IWjzfGin3J1DNT1nRd0Y
         sFoadyRXEZeNll0wOZJLSsFIbBKnIWPar3mVCpXBSglsPlzzZD72u3Y6FAcGGsoPtWSJ
         eFUVCcKMIX6KUiz7lGjl+s9Abpex1Ne+kudbdugcoFCWCWdth67EB+CreDDmxcDwF6Uw
         4miQ==
X-Forwarded-Encrypted: i=1; AL+hErE1P7o4fnBAfyM0kitHHuvVZUTUF00z8kXMRjEYtWawADDx5oRwv/+zxwOrelKwLZLqHfv6/K2SLw==@kvack.org
X-Gm-Message-State: APuU4Z8Uy0C318cFugCYRrfy++K9assTDMDurq8GIAozsxjQeuAtbeeO
	E2dvCuF2ywZdrP09UY9Zd58pDMEOOnWSXnezcAVlW9KdnAjS/QVXK2ofiFkw3d8+X30=
X-Gm-Gg: AYBFou2QiAYnKVjp5BRLfhng8crml9fPsD21KQxnJnqb/3tad4zhhOIYei+JnHBI+Hr
	eU8qyvhAh7oVmuzndjd1RWFlEjkizx4bvp03e4XXlwj56kB4MzRL55RNhMpdwul+fpizglCvePk
	gP2wQDLJxZXTz49LOkoZYSLzhmdp6WGWUEUW+uUtnPCYLU6I+Teu7dpaU4iKDw7NavZVQfoNNY6
	TD+sM14aXwneLowMDJPFYrb9pDXsXKCCHilsFYkROfCHbyuwHIkTYRdeUxTU4NSgu3lTZWw6Rg7
	Sy01kb4f9mLUbJWEoLDnghQO4D0YQJcmWM68BBhgdcbj2DYXgzdHgnU9sV7xguG40KsiS1Rre6C
	jvwHHfwj4l5GHoTsrtYqHTrNxOP3fjowB+xa+ps6XdswoS9cLVcTKbkXmBPK6QIaxRzN8gp08ag
	gR8X8VEC1ucOeUwLG/BfM2vMw6nYOuyEhqgMni9xLw2gVMX0c0P4/gDxa7AN3ZJ4zfkvanWzB80
	nnrXBWpYKVyrzBeM28GoOAw/HSnV0+jlzEqRpf+Qi18nobIkF+kqm2DbY+P5gkyJb6yvyWfVGxS
	H3hG69uhY27mKrxzxDxjqxswgz7PZjxnlp/VhuvcFvKJDmqKXWhCVs9G1ZOXlr0sGj4JNgfgrs9
	rIzBc6+mXUcxqW5ISJULVtNGD8xvxiye9VCIg2L+9PmXLI6Fdz7a/bDX3QeAefiEMXpSIW2BIt6
	Ocdba727mixOwmEpg/u1Qn68enyQhHJatNOB3tWY1p6ehVkaxiAsPynIMyEa9ChfJ5sPGWyzry+
	FOEloBo
X-Received: by 2002:a17:903:3d10:b0:2ed:a8bc:6d48 with SMTP id d9443c01a7336-2ee0dc06844mr17927715ad.43.1794559902021;
        Fri, 13 Nov 2026 00:51:42 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7d9971sm6839925ad.34.2026.11.13.00.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:51:41 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:35 -0800
Message-ID: <14d2fcd42e3e8aa20ac8dcb736a9411cbfc9bcd0.1794506262.git.chris@chrisdown.name>
In-Reply-To: <cover.1794506262.git.chris@chrisdown.name>
References: <cover.1794506262.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 4/6] slub_kunit: Add a test for the slab_buckets boot
 parameter
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
X-Rspamd-Queue-Id: 4CC141C0002
X-Rspamd-Server: rspam12
X-Stat-Signature: qdf8rtc9h5dsggbnqiyuhi6yfo5ay6h5
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794559903-496831
X-HE-Meta: U2FsdGVkX1/4/tef0Rlu/fpYYcOAlzmmaBJ/IhJ1AGxm0k6ts9Gp994Qo1+1sfMR7HvJZk6jQOKtqlAEONRBufMumG89R7TuuBXMCD7HfsPBaYbbzveTTmvlDFHEhAlPbe+EQelM0T93dl6Ubk1fE7I6MSWb8q7Y9+9cZLCu52CRJBxhFXpJTE1ixwWv7CO9LuburFt/RjB6Hro6t9FlrJDqhDng4+rHd7oxTbVGm4YwMyeBMU4uiTeGAqI+Yqts4IbNl8d6mQsrKFwCfuwE6Tqi4RXjxusqw7xi7WJ63d107J/ZkCCD75DlHbvZXrN8gUPUBC/c3MPwOyoq6IzC2eej2HDR6B6/cj7UnrzChqaQIlSop/BlX2wukBwwBN9w1f17BOAtXgqsaaWSBCNoUIdrrXWSFMeJEKzOWgv7nx8W3zAGV3UwU9zPHNmL6Pi+wryiVVuIKbo8Wo6bmrCAyGSg+Hq/Z376VN3OgP8PaylQ25nuttHN+DnEmILPEekTYasKrTzXm9CKq3Uvb3oWw/T6DocCzj2OwsPbFsUj9eyBGbz9WCE6TpTCTvbCo2gc/aZIp4Ur50ncSNNmE/4JIn3bPlPARcntQ9ZyOsFL/tBIiW9bEVvJ93zbfld7MEOUkcrlo6FP+OqqcVfgGRJL6i7/VbhizfZrU/wvyC1GNBxaQdP+Q3K6d9BD+SoSGF7CWI2LTrPRzFsZ3sLfxsGTbvp4eLYmqL26QzLV3d5/R9yKxy6gSYZZ4gNorDWTBXVrKKwYR7wj398Iwg3Hr46pS2pdmjXOIEOPuRdi94uEBQUYgWET59gWKTW0Z7YpSziVyKCTZMy0zyl/hKKnYIQCmhp6R/vdm+9tKNjgyB2nn8uLR8+q8GgervO7WkpbSG8bKlWM2aIPLR4FIVYg/cNDTghlZbTKXwXv+/i+11vQ3Ayu6lzBe0BEr6zCv52hT/XOjhE0gbHCeFB3VVU055g
 tBLEeRx8
 cvypTajqsVtYYrAIOExqRWeM7H8Th5DLKxb3D2cVNcJOuHsQTZwdBzBFvlodCEognYWp3JncVUk3O8P/WOU8ukkpGoT0LrwWWXbKtcga/5/1JsOhkfZWaBk0WiEuO/ruCo4uHOzRV9mFkkBSPF0d9IG8S3iraPE0qaZrYatq/OBXYtGuHrP2LJOQBrEvkDWP3l4ANSm+udd9tg8QP6udKdePcC6qvJIdjL+S4A0APLpegCB8cIxMWNsNno+jcTvMCW9C9y83b4e63d7KxI8vUOJ7+xH0r1IPCdlr05wqozNrpknvzJTQ4AHsRpFqgvnfgxJvBcY3iOJvydYaRZs5vm3fhoN0a78gaWDIDGAwumHzqvCxQH/VC38mBgBOOE/CRpJHXe8saAuM6r8LNaOnuIkwPumNOok7Rer0X4XowygsrImRyQ/e+X/A9SCTqDY/+uk3knG5kTntCqs4zQq25PTg8jW3/dBowEegG0fdmgCJchoamqo72hjMAP0aVScyklNIdl31O93p3qzZKgo3kCRA/NCBGd/GoQdkvjfrBBrAykZgROleHSHSyRKDh1j52XJ03jhjH4We1kre+sRZHJhKL3UhXJ5cZMqivEEb5Tld+uOAuqyUjW62wIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that memdup_user() allocates from the memdup_user buckets by
default, and from the regular kmalloc caches when they're turned off
with slab_buckets=0. The test is skipped on kernels built without
CONFIG_SLAB_BUCKETS.

Make slab_buckets_enabled global and export it to KUnit so that the
test can see it.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 lib/tests/slub_kunit.c | 40 ++++++++++++++++++++++++++++++++++++++++
 mm/slab.h              |  2 ++
 mm/slab_common.c       |  4 +++-
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index e3b63f0338d5..1af3f087134f 100644
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
@@ -296,6 +298,42 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
+static void test_slab_buckets(struct kunit *test)
+{
+	unsigned long user_addr;
+	const char *name;
+	void *p;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "requires CONFIG_SLAB_BUCKETS");
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
+
 #if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
 #define NR_ITERATIONS 1000
 #define NR_OBJECTS 1000
@@ -489,6 +527,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
+	KUNIT_CASE(test_slab_buckets),
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
 #endif
@@ -505,5 +544,6 @@ static struct kunit_suite test_suite = {
 };
 kunit_test_suite(test_suite);
 
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 MODULE_DESCRIPTION("Kunit tests for slub allocator");
 MODULE_LICENSE("GPL");
diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc..6a28951f6d5d 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -390,6 +390,8 @@ extern struct list_head slab_caches;
 /* The slab cache that manages slab cache information */
 extern struct kmem_cache *kmem_cache;
 
+extern bool slab_buckets_enabled;
+
 /* A table of kmalloc cache names and sizes */
 extern const struct kmalloc_info_struct {
 	const char *name[NR_KMALLOC_TYPES];
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 272d22f411c2..5575706b8938 100644
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
+bool slab_buckets_enabled __ro_after_init = IS_ENABLED(CONFIG_SLAB_BUCKETS);
+EXPORT_SYMBOL_IF_KUNIT(slab_buckets_enabled);
 
 static int __init setup_slab_buckets(char *str)
 {
-- 
2.56.1


