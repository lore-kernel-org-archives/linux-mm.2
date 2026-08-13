Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B531FC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CDD6B0540; Thu, 13 Aug 2026 12:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D166B0541; Thu, 13 Aug 2026 12:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BFE6B0542; Thu, 13 Aug 2026 12:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 786CA6B0540
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:15:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0ABD61C0A48
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:15:03 +0000 (UTC)
X-FDA: 85096745286.29.2BA9265
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf01.hostedemail.com (Postfix) with ESMTP id DF7D940005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:14:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786637701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tii058bH7KR2mz3ZS5Use52uM0pO6iBDFjRMtMgNxJs=;
	b=UhIikCH6NbgPUf7CWON/RUYer2RI6mJ1edJYNvuedxA7i/490M1zw2Xtr1y1pn7fNQoy+c
	aTyvJq1/TADgDDMIQ9SoxIluZ3hIg9XgtF3cSQf1jw3eiSVkk19YPYY28dv2OEdyWA7pYg
	MsrhAgetR4Pc6VragU3PPYX3xFoVoJw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786637701;
	b=o9XIyKrowTNPm73JxciahYIv/UzPRmcIQFuaEBASIIhZGZOYwvnClDV+NDBuuMarRhthdo
	6qlg+f+IWg6cTZOAQXrvViMXurhgWloSB5cpKw73/kVGTNcvj4i2zhATX90hHD1sbwSR6g
	mVLxtvxaGWoiqtMTp1xFtgUO8KHVBOo=
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowACHWe187X1qrr17BQ--.55428S2;
	Fri, 14 Aug 2026 00:14:52 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2 3/4] mm/slub: test previous lifetime tracking
Date: Fri, 14 Aug 2026 00:14:52 +0800
Message-ID: <20260813161452.75035-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
References: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACHWe187X1qrr17BQ--.55428S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJFy7Xw47Xw4kKr1fCrWxWFg_yoWrWw13pF
	ZakF15Kr4UXF17XrZxCFn2kr1SvF4ktw17ArW2qrWkZr4Yqw1kAF4vkryjqFs7urWkua1a
	vasrt3WfGr4UZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9S14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCV
	W8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr
	1UYxBIdaVFxhVjvjDU0xZFpf9x0pRLIDwUUUUU=
X-Originating-IP: [111.196.241.250]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF7D940005
X-Stat-Signature: g71netoyqx74wwoggwadbr6cyhbbgy5r
X-Rspam-User: 
X-HE-Tag: 1786637699-300583
X-HE-Meta: U2FsdGVkX1/6FV8C8suO3pw16U3QAM+D9FtWjzwFpBYF6LCeqDPf76lLS0f/uhAY0ynaxJxmvJX7dNOk8svfKwV5ZoZwqCdOsIdNv8fjXGPo7VTBQ+HI3yjWiMFMHa/5UDICeSU/ABbjqyUjqT6ZMIkw0aTbdXyoyRp/YUSAavymYVs8hehU4L2t6pJ0YmijM2/lwLSI3x5LFSnFS7DYBMijIJo+EtAyyLSY5Jq+7zygHVrmxFfpXuXOJqKFEQxTCaJuyi38yCCf3Kt047B5kIGHecmndjrrQseq/TGHe4MP0srW/ul6vZ9DJo1t7VixNzQ1xPSHYHelcykImRR+lYutWVRnh4W0C/EOG7tebiRutkmvmG1PqQwMTC92Go63vsazrUii/YBmC64vs3fidWN2aoRNhRMhpyJRgSJje3DFbNMnVVRJEdFgwYqhVyA75wX7Gj0Z+IwdAJe9hLqE0m9qWaA6PDn/591N2T8U4ZcOBNZLUk5jFDNz1/PUb4o4fW5CSFWISoUiLb403Oi19Yr+5snzxrpS+73KPQ95o6HAVqmjFHI1eId1cbz9JwBl1UGqoZNtpOXR7kqld0EKhU/6Paq3L9YLRGIPVTwRauLzDFiyucF9qwopOLrr0a1oCRRnvQ1xR3EThNzd9axki2mU/8ho4qiY0oYqzBVCrCp027Qq+P50dc+j8xTkYqJ5J5dH6U5IlTa1rXGmdv7LxeHfphgyxUtU4y4/tsoxOvEjzdgv9p4fMiKch87eCBj1qdF6gsHpx649egOjjxz2C5qo8h5gxfXfo3/TmY8DkC/9SJbSq1nHyZsCs9nkQRkZw+YryTjL1QsSMRg2Oml3/RSWKh/EpKeV+duMO5tJTXDZ0XShD4d2eLyVXwHvVO6itNjUAuswRMmjp9EIJFparrp4pEQfPH94yPWRrlhGwzLekT7hkT4JxqZrE7ViP2zckSomEgxRYogMWQbzzcZ
 bFsOe1F/
 aMPihprvohwNdQ9DS92jExVBStHyAfzcMB4jIoP5yQmpVb/CSVUvd8XlpAzdkPgT8Oy0gL0VsbujaM465yUkQJ525xCe1vzcY7VeOOhdBmDEJSMY1BA158kxNod3XN8g1mFnGMhi7+51hlcOvcKGqAj/dVRP+Cfhzhedk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KUnit coverage for the SLAB_STORE_USER reuse transition.  The test
creates a non-mergeable cache, pins the task against migration, verifies
that a fresh object has no previous lifetime, then frees and immediately
reallocates the object and verifies that the completed pair was retained.

Exclude KASAN configurations because quarantine can intentionally prevent
immediate reuse.

Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 lib/tests/slub_kunit.c | 35 +++++++++++++++++++++++++++++++++++
 mm/slab.h              |  4 ++++
 mm/slub.c              | 10 ++++++++++
 3 files changed, 49 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index fa6d31dbca16..62d0f5e64268 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/perf_event.h>
 #include "../mm/slab.h"
@@ -106,6 +107,38 @@ static void test_first_word(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
+static void test_store_user_previous_lifetime(struct kunit *test)
+{
+	struct kmem_cache *s;
+	void *p;
+	void *q;
+
+	s = test_kmem_cache_create("TestSlub_prev_lifetime", 64,
+				   SLAB_STORE_USER | SLAB_NO_MERGE);
+	migrate_disable();
+	p = kmem_cache_alloc(s, GFP_KERNEL);
+	if (!p) {
+		KUNIT_FAIL(test, "failed to allocate the first object");
+		goto out_enable;
+	}
+	KUNIT_EXPECT_FALSE(test, slab_test_has_previous_lifetime(s, p));
+
+	kmem_cache_free(s, p);
+	q = kmem_cache_alloc(s, GFP_KERNEL);
+	if (q != p) {
+		KUNIT_FAIL(test, "freed object was not immediately reused");
+		if (q)
+			kmem_cache_free(s, q);
+		goto out_enable;
+	}
+	KUNIT_EXPECT_TRUE(test, slab_test_has_previous_lifetime(s, q));
+
+	kmem_cache_free(s, q);
+out_enable:
+	migrate_enable();
+	kmem_cache_destroy(s);
+}
+
 static void test_clobber_50th_byte(struct kunit *test)
 {
 	struct kmem_cache *s = test_kmem_cache_create("TestSlub_50th_word_free",
@@ -395,6 +428,7 @@ static struct kunit_case test_cases[] = {
 #ifndef CONFIG_KASAN
 	KUNIT_CASE(test_next_pointer),
 	KUNIT_CASE(test_first_word),
+	KUNIT_CASE(test_store_user_previous_lifetime),
 	KUNIT_CASE(test_clobber_50th_byte),
 #endif
 
@@ -419,3 +453,4 @@ kunit_test_suite(test_suite);
 
 MODULE_DESCRIPTION("Kunit tests for slub allocator");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
diff --git a/mm/slab.h b/mm/slab.h
index f5e336b6b6b0..15634d9603f8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -518,6 +518,10 @@ bool slab_in_kunit_test(void);
 static inline bool slab_in_kunit_test(void) { return false; }
 #endif
 
+#if IS_ENABLED(CONFIG_SLUB_KUNIT_TEST)
+bool slab_test_has_previous_lifetime(struct kmem_cache *s, void *object);
+#endif
+
 /*
  * slub is about to manipulate internal object metadata.  This memory lies
  * outside the range of the allocated object, so accessing it would normally
diff --git a/mm/slub.c b/mm/slub.c
index 355fbffb981f..d6b7487fb300 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -46,6 +46,7 @@
 #include <linux/prandom.h>
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
+#include <kunit/visibility.h>
 #include <linux/sort.h>
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
@@ -1148,6 +1149,15 @@ void print_tracking(struct kmem_cache *s, void *object)
 	print_track("Freed", get_track(s, object, TRACK_PREV_FREE), pr_time);
 }
 
+#if IS_ENABLED(CONFIG_SLUB_KUNIT_TEST)
+bool slab_test_has_previous_lifetime(struct kmem_cache *s, void *object)
+{
+	return get_track(s, object, TRACK_PREV_ALLOC)->addr &&
+	       get_track(s, object, TRACK_PREV_FREE)->addr;
+}
+EXPORT_SYMBOL_IF_KUNIT(slab_test_has_previous_lifetime);
+#endif
+
 static void print_slab_info(const struct slab *slab)
 {
 	pr_err("Slab 0x%p objects=%u used=%u fp=0x%p flags=%pGp\n",
-- 
2.50.1 (Apple Git-155)


