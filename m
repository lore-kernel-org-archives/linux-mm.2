Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF50CCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 15:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420138E0009; Wed,  3 Sep 2025 11:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1408E0001; Wed,  3 Sep 2025 11:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299068E0009; Wed,  3 Sep 2025 11:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 144228E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:00:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD0C4140764
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:00:51 +0000 (UTC)
X-FDA: 83848251102.01.A9147BD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0A9A340015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:00:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756911650; a=rsa-sha256;
	cv=none;
	b=ffH2o7VY12IPc7woDPmoINSoXOeDO8h5prdyooFEZvckCLV+zwAgG9MpACHcazYXn0YUfT
	CiYvihrqOnQ3U3HldZts2vA02iP0iLCpI9+1tIhWHtY41PDmRXApSfFKkJsG10lkGvgmMl
	CSu8/7vmQ109xwZNjbhAZABc+glsjLU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756911650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IUlV7fRKD4qCLQBd01OmqgExGMoO+hJdfCTuTuTDiI4=;
	b=nY4a7JCmMnpbCsEeqyTI2fOOh5Ye75SCK/Z/MZxt6xpTGCWP+AJoIDOORU7C2INwoETK9J
	BjhpURj42tuyB7GiCXH1pHleDkFCYVpRem3RP+kPiIVqMhrSMDktAZO5TxAXDyyuyXBWgE
	urJyWcEbeek504gu4kIWmTWQY2M+8xc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB6AE1688;
	Wed,  3 Sep 2025 08:00:40 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1A8EF3F694;
	Wed,  3 Sep 2025 08:00:44 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	scott@os.amperecomputing.com,
	jhubbard@nvidia.com,
	pankaj.gupta@amd.com,
	leitao@debian.org,
	kaleshsingh@google.com,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io,
	david@redhat.com,
	yang@os.amperecomputing.com
Cc: kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v7 2/2] kasan: apply write-only mode in kasan kunit testcases
Date: Wed,  3 Sep 2025 16:00:20 +0100
Message-Id: <20250903150020.1131840-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903150020.1131840-1-yeoreum.yun@arm.com>
References: <20250903150020.1131840-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A9A340015
X-Stat-Signature: noaxcihhxk51c4tbby45pdwpoqgqdcwr
X-Rspam-User: 
X-HE-Tag: 1756911649-947307
X-HE-Meta: U2FsdGVkX1/VJ2Opzx06HSbRUFhoEUs7L9PvagoTRgyz+3OjlUqubwooabhlFO05Cq8Q6r/5gcpGtZaX+SF9RH7674QgsEk6Pu2ZC0Up2cW2Y3Seo2EmkR1t2SSiHT1XK3WHn3bsuVbN3bNfpGUjGog7lMMaRzptp/AtMXu4tTMdwtacui6kR1dFEwGDMZ0r1Ff82J+kPsx7y3iI7dkPZgc0iIRHiEna7eZDyG7qfnnLTvuT3FjhlSWgFdqY/2lYclpFTd1yPpaY33toGTZKYbvM8zlttM3oS+LHqgpW71XEZONeavAZSewzdxtlnDZYILxUT3Y+4jnOzyXsHdWWMkPWc6z6QrGH/lUOn9V/IX9T+VzGm/1BB56XFG5f+o6bts3SHC7dn07NRjy3h/AeHadOkBk8u4ayKNV2yjlc6VkUPShMRp/gmESzCPZpikqGTQghLoMQQiZff0/LdnYpFwGxFkZhHTwlj/ChjEx4wwdfVGc7yZAU9yVgY50l1JXku9/abGfBE08dnd22H3M7u+i+/4Mp0ySNNz2kZB6sQ+e4CLhcoWsOotat/heJwrztWnCAkQpo+qngYMjMRk9/DHttPc4fzyn3auWYtmURyptgXF6CLJLvlPHtYK0ExWwunDqj86GA3/j/hftmKM4TYDwQLMa+cGfW8//hpYhgXj/Fbmr1id5sFB5NDRfZ6AQTtM3t+dfneEfoTeQZMpat4OHOSGErHukN68sSjN2c768oxd9mMaUFGW5mTcqHILE105DCyW5mF17BOJDUMacTs4nyP9woRCpEErB471YigCTtYfs1bGwbYB6/XtHkFrKEZkdYow0pCCuo7uGnFiBteoa0e1fsOHTpI4ChK2htc9ZyfkRmOAHookZzUt/+RFeFL1nq/Z/xmSpn8wwSUdRRJn/SculD/kkLD11t6pqiFq2erqb0e9vqu06pefa29XKvGOomioxCGONmztbQVvK
 uFBP4lW8
 2wrZTzctitEl3apkqKJ3siz/ctlHPfwKKeWp01hBXQZPGrdjsC/zLHhmLtEBOHKBzC7eUbeU5fP+V3fZ3Ku1CPfLQop6ueh/rjTPEnY4aMrMdIZSXaudHxP2uXo3GHHb2tgE3O9MY3VPq4rMAl1A4iE6xRcsc7vgOJo3y03cZIuGG0/xCQK8PJKBPAnh8tR9cwpjt6/gKXSs/yI/GsHRipx1jO1olOnPyezoElAGmwm5go9TaWa6c4h7z4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KASAN is configured in write-only mode,
fetch/load operations do not trigger tag check faults.

As a result, the outcome of some test cases may differ
compared to when KASAN is configured without write-only mode.

Therefore, by modifying pre-exist testcases
check the write only makes tag check fault (TCF) where
writing is perform in "allocated memory" but tag is invalid
(i.e) redzone write in atomic_set() testcases.
Otherwise check the invalid fetch/read doesn't generate TCF.

Also, skip some testcases affected by initial value
(i.e) atomic_cmpxchg() testcase maybe successd if
it passes valid atomic_t address and invalid oldaval address.
In this case, if invalid atomic_t doesn't have the same oldval,
it won't trigger write operation so the test will pass.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
---
 mm/kasan/kasan_test_c.c | 205 ++++++++++++++++++++++++++--------------
 1 file changed, 136 insertions(+), 69 deletions(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index f4b17984b627..484fbbc8b55e 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -94,11 +94,14 @@ static void kasan_test_exit(struct kunit *test)
 }
 
 /**
- * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
- * KASAN report; causes a KUnit test failure otherwise.
+ * KUNIT_EXPECT_KASAN_RESULT - checks whether the executed expression
+ * produces a KASAN report; causes a KUnit test failure when the result
+ * is different from @fail.
  *
  * @test: Currently executing KUnit test.
- * @expression: Expression that must produce a KASAN report.
+ * @expr: Expression to be tested.
+ * @expr_str: Expression to be tested encoded as a string.
+ * @fail: Whether expression should produce a KASAN report.
  *
  * For hardware tag-based KASAN, when a synchronous tag fault happens, tag
  * checking is auto-disabled. When this happens, this test handler reenables
@@ -110,25 +113,29 @@ static void kasan_test_exit(struct kunit *test)
  * Use READ/WRITE_ONCE() for the accesses and compiler barriers around the
  * expression to prevent that.
  *
- * In between KUNIT_EXPECT_KASAN_FAIL checks, test_status.report_found is kept
+ * In between KUNIT_EXPECT_KASAN_RESULT checks, test_status.report_found is kept
  * as false. This allows detecting KASAN reports that happen outside of the
  * checks by asserting !test_status.report_found at the start of
- * KUNIT_EXPECT_KASAN_FAIL and in kasan_test_exit.
+ * KUNIT_EXPECT_KASAN_RESULT and in kasan_test_exit.
  */
-#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {			\
+#define KUNIT_EXPECT_KASAN_RESULT(test, expr, expr_str, fail)		\
+do {									\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&				\
 	    kasan_sync_fault_possible())				\
 		migrate_disable();					\
 	KUNIT_EXPECT_FALSE(test, READ_ONCE(test_status.report_found));	\
 	barrier();							\
-	expression;							\
+	expr;								\
 	barrier();							\
 	if (kasan_async_fault_possible())				\
 		kasan_force_async_fault();				\
-	if (!READ_ONCE(test_status.report_found)) {			\
-		KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN failure "	\
-				"expected in \"" #expression		\
-				 "\", but none occurred");		\
+	if (READ_ONCE(test_status.report_found) != fail) {		\
+		KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN failure"	\
+				"%sexpected in \"" expr_str		\
+				 "\", but %soccurred",			\
+				(fail ? " " : " not "),		\
+				(test_status.report_found ?		\
+				 "" : "none "));			\
 	}								\
 	if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&				\
 	    kasan_sync_fault_possible()) {				\
@@ -141,6 +148,34 @@ static void kasan_test_exit(struct kunit *test)
 	WRITE_ONCE(test_status.async_fault, false);			\
 } while (0)
 
+/*
+ * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
+ * KASAN report; causes a KUnit test failure otherwise.
+ *
+ * @test: Currently executing KUnit test.
+ * @expr: Expression that must produce a KASAN report.
+ */
+#define KUNIT_EXPECT_KASAN_FAIL(test, expr)			\
+	KUNIT_EXPECT_KASAN_RESULT(test, expr, #expr, true)
+
+/*
+ * KUNIT_EXPECT_KASAN_FAIL_READ - check that the executed expression
+ * produces a KASAN report when the write-only mode is not enabled;
+ * causes a KUnit test failure otherwise.
+ *
+ * Note: At the moment, this macro does not check whether the produced
+ * KASAN report is a report about a bad read access. It is only intended
+ * for checking the write-only KASAN mode functionality without failing
+ * KASAN tests.
+ *
+ * @test: Currently executing KUnit test.
+ * @expr: Expression that must only produce a KASAN report
+ *        when the write-only mode is not enabled.
+ */
+#define KUNIT_EXPECT_KASAN_FAIL_READ(test, expr)			\
+	KUNIT_EXPECT_KASAN_RESULT(test, expr, #expr,			\
+			!kasan_write_only_enabled())			\
+
 #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {			\
 	if (!IS_ENABLED(config))					\
 		kunit_skip((test), "Test requires " #config "=y");	\
@@ -183,8 +218,8 @@ static void kmalloc_oob_right(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + 5] = 'y');
 
 	/* Out-of-bounds access past the aligned kmalloc object. */
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =
-					ptr[size + KASAN_GRANULE_SIZE + 5]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] =
+			ptr[size + KASAN_GRANULE_SIZE + 5]);
 
 	kfree(ptr);
 }
@@ -198,7 +233,7 @@ static void kmalloc_oob_left(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	OPTIMIZER_HIDE_VAR(ptr);
-	KUNIT_EXPECT_KASAN_FAIL(test, *ptr = *(ptr - 1));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, *ptr = *(ptr - 1));
 	kfree(ptr);
 }
 
@@ -211,7 +246,7 @@ static void kmalloc_node_oob_right(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	OPTIMIZER_HIDE_VAR(ptr);
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] = ptr[size]);
 	kfree(ptr);
 }
 
@@ -291,7 +326,7 @@ static void kmalloc_large_uaf(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	kfree(ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
 }
 
 static void kmalloc_large_invalid_free(struct kunit *test)
@@ -323,7 +358,7 @@ static void page_alloc_oob_right(struct kunit *test)
 	ptr = page_address(pages);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] = ptr[size]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] = ptr[size]);
 	free_pages((unsigned long)ptr, order);
 }
 
@@ -338,7 +373,7 @@ static void page_alloc_uaf(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	free_pages((unsigned long)ptr, order);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
 }
 
 static void krealloc_more_oob_helper(struct kunit *test,
@@ -458,7 +493,7 @@ static void krealloc_uaf(struct kunit *test)
 
 	KUNIT_EXPECT_KASAN_FAIL(test, ptr2 = krealloc(ptr1, size2, GFP_KERNEL));
 	KUNIT_ASSERT_NULL(test, ptr2);
-	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, *(volatile char *)ptr1);
 }
 
 static void kmalloc_oob_16(struct kunit *test)
@@ -501,7 +536,7 @@ static void kmalloc_uaf_16(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
 	kfree(ptr2);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 = *ptr2);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, *ptr1 = *ptr2);
 	kfree(ptr1);
 }
 
@@ -640,8 +675,8 @@ static void kmalloc_memmove_invalid_size(struct kunit *test)
 	memset((char *)ptr, 0, 64);
 	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(invalid_size);
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
+			memmove((char *)ptr, (char *)ptr + 4, invalid_size));
 	kfree(ptr);
 }
 
@@ -654,7 +689,7 @@ static void kmalloc_uaf(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	kfree(ptr);
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[8]);
 }
 
 static void kmalloc_uaf_memset(struct kunit *test)
@@ -701,7 +736,7 @@ static void kmalloc_uaf2(struct kunit *test)
 		goto again;
 	}
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr1)[40]);
 	KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
 
 	kfree(ptr2);
@@ -727,19 +762,19 @@ static void kmalloc_uaf3(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
 	kfree(ptr2);
 
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr1)[8]);
 }
 
 static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
 {
 	int *i_unsafe = unsafe;
 
-	KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, READ_ONCE(*i_unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*i_unsafe, 42));
-	KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, smp_load_acquire(i_unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, smp_store_release(i_unsafe, 42));
 
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, atomic_read(unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_set(unsafe, 42));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_add(42, unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub(42, unsafe));
@@ -752,18 +787,31 @@ static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_xchg(unsafe, 42));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_cmpxchg(unsafe, 21, 42));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(unsafe, safe, 42));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, unsafe, 42));
+	/*
+	 * The result of the test below may vary due to garbage values of
+	 * unsafe in write-only mode.
+	 * Therefore, skip this test when KASAN is configured in write-only mode.
+	 */
+	if (!kasan_write_only_enabled())
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, unsafe, 42));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub_and_test(42, unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_and_test(unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_and_test(unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_negative(42, unsafe));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_unless(unsafe, 21, 42));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_not_zero(unsafe));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_unless_negative(unsafe));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_unless_positive(unsafe));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_if_positive(unsafe));
+	/*
+	 * The result of the test below may vary due to garbage values of
+	 * unsafe in write-only mode.
+	 * Therefore, skip this test when KASAN is configured in write-only mode.
+	 */
+	if (!kasan_write_only_enabled()) {
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_unless(unsafe, 21, 42));
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_not_zero(unsafe));
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_unless_negative(unsafe));
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_unless_positive(unsafe));
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_if_positive(unsafe));
+	}
 
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_read(unsafe));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, atomic_long_read(unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_set(unsafe, 42));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add(42, unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub(42, unsafe));
@@ -776,16 +824,29 @@ static void kasan_atomics_helper(struct kunit *test, void *unsafe, void *safe)
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_xchg(unsafe, 42));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_cmpxchg(unsafe, 21, 42));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(unsafe, safe, 42));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(safe, unsafe, 42));
+	/*
+	 * The result of the test below may vary due to garbage values of
+	 * unsafe in write-only mode.
+	 * Therefore, skip this test when KASAN is configured in write-only mode.
+	 */
+	if (!kasan_write_only_enabled())
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(safe, unsafe, 42));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub_and_test(42, unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_and_test(unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_and_test(unsafe));
 	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_negative(42, unsafe));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_unless(unsafe, 21, 42));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_not_zero(unsafe));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_unless_negative(unsafe));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_unless_positive(unsafe));
-	KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_if_positive(unsafe));
+	/*
+	 * The result of the test below may vary due to garbage values of
+	 * unsafe in write-only mode.
+	 * Therefore, skip this test when KASAN is configured in write-only mode.
+	 */
+	if (!kasan_write_only_enabled()) {
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_unless(unsafe, 21, 42));
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_not_zero(unsafe));
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_unless_negative(unsafe));
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_unless_positive(unsafe));
+		KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_if_positive(unsafe));
+	}
 }
 
 static void kasan_atomics(struct kunit *test)
@@ -842,8 +903,8 @@ static void ksize_unpoisons_memory(struct kunit *test)
 	/* These must trigger a KASAN report. */
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
 		KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size + 5]);
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size + 5]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[real_size - 1]);
 
 	kfree(ptr);
 }
@@ -863,8 +924,8 @@ static void ksize_uaf(struct kunit *test)
 
 	OPTIMIZER_HIDE_VAR(ptr);
 	KUNIT_EXPECT_KASAN_FAIL(test, ksize(ptr));
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size]);
 }
 
 /*
@@ -899,9 +960,9 @@ static void rcu_uaf(struct kunit *test)
 	global_rcu_ptr = rcu_dereference_protected(
 				(struct kasan_rcu_info __rcu *)ptr, NULL);
 
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
-		rcu_barrier());
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
+			call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
+			rcu_barrier());
 }
 
 static void workqueue_uaf_work(struct work_struct *work)
@@ -924,8 +985,8 @@ static void workqueue_uaf(struct kunit *test)
 	queue_work(workqueue, work);
 	destroy_workqueue(workqueue);
 
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		((volatile struct work_struct *)work)->data);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
+			((volatile struct work_struct *)work)->data);
 }
 
 static void kfree_via_page(struct kunit *test)
@@ -972,7 +1033,7 @@ static void kmem_cache_oob(struct kunit *test)
 		return;
 	}
 
-	KUNIT_EXPECT_KASAN_FAIL(test, *p = p[size + OOB_TAG_OFF]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, *p = p[size + OOB_TAG_OFF]);
 
 	kmem_cache_free(cache, p);
 	kmem_cache_destroy(cache);
@@ -1068,7 +1129,7 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
 	 */
 	rcu_barrier();
 
-	KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*p));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, READ_ONCE(*p));
 
 	kmem_cache_destroy(cache);
 }
@@ -1207,7 +1268,7 @@ static void mempool_oob_right_helper(struct kunit *test, mempool_t *pool, size_t
 		KUNIT_EXPECT_KASAN_FAIL(test,
 			((volatile char *)&elem[size])[0]);
 	else
-		KUNIT_EXPECT_KASAN_FAIL(test,
+		KUNIT_EXPECT_KASAN_FAIL_READ(test,
 			((volatile char *)&elem[round_up(size, KASAN_GRANULE_SIZE)])[0]);
 
 	mempool_free(elem, pool);
@@ -1273,7 +1334,7 @@ static void mempool_uaf_helper(struct kunit *test, mempool_t *pool, bool page)
 	mempool_free(elem, pool);
 
 	ptr = page ? page_address((struct page *)elem) : elem;
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
 }
 
 static void mempool_kmalloc_uaf(struct kunit *test)
@@ -1532,7 +1593,7 @@ static void kasan_memchr(struct kunit *test)
 
 	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test,
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
 		kasan_ptr_result = memchr(ptr, '1', size + 1));
 
 	kfree(ptr);
@@ -1559,7 +1620,7 @@ static void kasan_memcmp(struct kunit *test)
 
 	OPTIMIZER_HIDE_VAR(ptr);
 	OPTIMIZER_HIDE_VAR(size);
-	KUNIT_EXPECT_KASAN_FAIL(test,
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
 		kasan_int_result = memcmp(ptr, arr, size+1));
 	kfree(ptr);
 }
@@ -1596,7 +1657,7 @@ static void kasan_strings(struct kunit *test)
 			strscpy(ptr, src + 1, KASAN_GRANULE_SIZE));
 
 	/* strscpy should fail if the first byte is unreadable. */
-	KUNIT_EXPECT_KASAN_FAIL(test, strscpy(ptr, src + KASAN_GRANULE_SIZE,
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, strscpy(ptr, src + KASAN_GRANULE_SIZE,
 					      KASAN_GRANULE_SIZE));
 
 	kfree(src);
@@ -1609,17 +1670,17 @@ static void kasan_strings(struct kunit *test)
 	 * will likely point to zeroed byte.
 	 */
 	ptr += 16;
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result = strchr(ptr, '1'));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_ptr_result = strchr(ptr, '1'));
 
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result = strrchr(ptr, '1'));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_ptr_result = strrchr(ptr, '1'));
 
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strcmp(ptr, "2"));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result = strcmp(ptr, "2"));
 
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strncmp(ptr, "2", 1));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result = strncmp(ptr, "2", 1));
 
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strlen(ptr));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result = strlen(ptr));
 
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strnlen(ptr, 1));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result = strnlen(ptr, 1));
 }
 
 static void kasan_bitops_modify(struct kunit *test, int nr, void *addr)
@@ -1638,12 +1699,18 @@ static void kasan_bitops_test_and_modify(struct kunit *test, int nr, void *addr)
 {
 	KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit(nr, addr));
 	KUNIT_EXPECT_KASAN_FAIL(test, __test_and_set_bit(nr, addr));
-	KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, addr));
+	/*
+	 * When KASAN is running in write-only mode,
+	 * a fault won't occur when the bit is set.
+	 * Therefore, skip the test_and_set_bit_lock test in write-only mode.
+	 */
+	if (!kasan_write_only_enabled())
+		KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, addr));
 	KUNIT_EXPECT_KASAN_FAIL(test, test_and_clear_bit(nr, addr));
 	KUNIT_EXPECT_KASAN_FAIL(test, __test_and_clear_bit(nr, addr));
 	KUNIT_EXPECT_KASAN_FAIL(test, test_and_change_bit(nr, addr));
 	KUNIT_EXPECT_KASAN_FAIL(test, __test_and_change_bit(nr, addr));
-	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = test_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result = test_bit(nr, addr));
 	if (nr < 7)
 		KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =
 				xor_unlock_is_negative_byte(1 << nr, addr));
@@ -1767,7 +1834,7 @@ static void vmalloc_oob(struct kunit *test)
 		KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size]);
 
 	/* An aligned access into the first out-of-bounds granule. */
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size + 5]);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)v_ptr)[size + 5]);
 
 	/* Check that in-bounds accesses to the physical page are valid. */
 	page = vmalloc_to_page(v_ptr);
@@ -2044,15 +2111,15 @@ static void copy_user_test_oob(struct kunit *test)
 
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		unused = copy_from_user(kmem, usermem, size + 1));
-	KUNIT_EXPECT_KASAN_FAIL(test,
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
 		unused = copy_to_user(usermem, kmem, size + 1));
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		unused = __copy_from_user(kmem, usermem, size + 1));
-	KUNIT_EXPECT_KASAN_FAIL(test,
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
 		unused = __copy_to_user(usermem, kmem, size + 1));
 	KUNIT_EXPECT_KASAN_FAIL(test,
 		unused = __copy_from_user_inatomic(kmem, usermem, size + 1));
-	KUNIT_EXPECT_KASAN_FAIL(test,
+	KUNIT_EXPECT_KASAN_FAIL_READ(test,
 		unused = __copy_to_user_inatomic(usermem, kmem, size + 1));
 
 	/*
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


