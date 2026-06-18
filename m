Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B97CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163F16B00C7; Thu, 18 Jun 2026 05:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B716B00C9; Thu, 18 Jun 2026 05:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029E76B00CA; Thu, 18 Jun 2026 05:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 333FA6B00C7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E043214062E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:19 +0000 (UTC)
X-FDA: 84892492398.18.5A28757
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf03.hostedemail.com (Postfix) with ESMTP id CCFAC20003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="qC70ke/P";
	spf=pass (imf03.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kx58UzGJ5PzxcjTsuUEJwFleVBmeQq5F4w9/tyaV6pU=;
	b=mdxYzzShlc6xhsvYO6DS5yy5k2YQ5wEHsl0KF79ey1O6M+PkkASi0HBp5J8WUxbiVZL111
	FzSIHEhTNYlOTgBN1wlG5bAX0oac5UwFo8FXAD9vzNPEE3kD2++1iUKEqUH7G9AEQYlvAZ
	i5ZUBPfxvh0SDZPPHExlXwoZrpdxIKI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="qC70ke/P";
	spf=pass (imf03.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774538;
	b=QqKoMl64eZMK1WsoINroXjRUHCiTClIO9s7zisyhIXjnT24QEdGO8QCe+4QN9XjtMOmPs3
	I+Rj7VX6Tvlt277kdGCeVjWRZGFZkshteAhTkOmxNPcY0FunC893z9KFug28ZzbfwJx8LL
	z9nhhhUvlbmu41G111dOCRZpuvFjf3g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774535; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kx58UzGJ5PzxcjTsuUEJwFleVBmeQq5F4w9/tyaV6pU=;
	b=qC70ke/PUy5yPgdmlATG0uffwHsPqVGf4BBM050EKu1ntCMa1djwtlWv9PH9O9iPDXXAq0bAqLfD6HhdpZlOEtPBzlrZt92KnRu/hqlRqwEisNnskuOmeHUBjQlX1V3qd/Z5bJUz7U8O4CvSzd5JUymsXXjkM9I0czkqY5Om1RM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X56UT.A_1781774529;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56UT.A_1781774529 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:22:12 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com
Subject: [PATCH v15 8/9] lib/test: memcpy_kunit: add copy_page() and copy_mc_page() tests
Date: Thu, 18 Jun 2026 17:21:22 +0800
Message-ID: <20260618092124.3901230-9-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
References: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCFAC20003
X-Stat-Signature: z7o3cy7tp9zaqqq83wy5n9xnr3jqkpjt
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781774537-521033
X-HE-Meta: U2FsdGVkX19tldx9QK++RwTLzRTESDLcJUumaKmh1bO7jeTlvPGbpwEo5zCO8R60A6ACzpk2ynvKE3FiMHhKp4BSDWI/LANI7WJOlpwX+eCBxsqzCjXUg7h0/MXBR9p5gKyS90eXmthixHYwbSOZ0jAjFo1QudTvmvXAf1Zq8nBiCDUUQtxIqNa0WwrtJdBcHPumBT2XzCWPqFyGbJzp15rGRfzCXKUUm5dLdtJ06PxQF3BTqIGIQTSZbZye4rLOT1GuFUOsaQ1nWBiXasUBnMtJSyV/4NGvUso62ijZT+AFYxPXEntWSS0xzrhIVKrVrgDNq5zXFaWRdpm6ydro6VDsUcbn0zt5zSUyzlg+IbI/3lZUovUM3iUVwWbMjkluc2bOofv969vYKPN0bGYzuHoAHcvREsGh2/aN5W17qISqiEKncWDBoWUKO7Bye45sNEUt5e6L8TepCPlyA0eNv0NKuqnU7yGIUeiXSaVOotQ2Jj0RX9E1R0Y7ZKGQy/JlNE7h4nP+Z816wRPuZX5rHhwre4RsFSL9b2j5hUfiKdOL+bj/IpcvLpSYYKT//UFwCDUMB2d4644qzrL2tFfpnoipg8ZWOEmZZe9OLjy/7lg6e6XkU6HaZVWGNp17OWAxDCRyEsFn0UOQ/o7YG4IhfuE3cpDcF1uGeUzMRezPevxjytY28++9dCAyS3BsZZKw+s4T79dU3cCjQeyya4IbtymqOb2KTkKjWWL28WaujpnCefcZ4hd+tWRDSUVcxUb6e4eI7yg7zWr3ZHvEGiysywm/HAZc2aGbsMtku0gQJCGFuzXVLq/Zz1KCcq0uGVEJFqkLjsUwFzE8c7D6ooq3fmvYRDw85hwAsQaz7Sgn2iB2kelGx2CLCZ7RCcgP3eKqBuajq4iZibee2Qnzlp2B8ZFEMKmHInQuYAuBbsrQN7T1RZpk42le7TX7cSS60P9wc0AU14BxUYt41QQyA+d
 qFFmkcF4
 G5T2bLRFZ0Lr4EwSUa2ze/M1yuYISyD+k5couZCMOa/wQ+mavP98mcrZ6+LhDKnqkUHILG93ybdjixQkJ1lK8xtf41Kw4pDzWRDZ0iwHC9SZYjcsXOabSTlZle0SfzUhn92IoBsWgVRfEwYYuvkBJ1AxpDLNPLDTagJDL35TG/Cz/FikBWgLtk4oILtTd0Qf2SluQaBanyqYXN4vSKINgWKCoDWQ0jVcaFWPjcInPBOQ3bUqfr15QzOhx1hA2a4NsnYpfa5qM0LoO8ahuyhMhLJHXXjAUOTwXPHqr9CGrsX6Zf0RfLGzwAvawshE01zMElGvb4QkZ/EIxBbJlcSu/O/Vp9R8EokGgGD33VLPEwqtF+RrcGsAPTBfoRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KUnit tests for copy_page() and copy_mc_page(), modeled after
the existing memcpy_test() style: a static page-aligned src and a
two-page dst, filled with random bytes plus non-zero edges, then
verify byte-for-byte equality and that the adjacent page is
untouched.

Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
---
 lib/tests/memcpy_kunit.c | 67 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/lib/tests/memcpy_kunit.c b/lib/tests/memcpy_kunit.c
index d36933554e46..812c1fa20fd9 100644
--- a/lib/tests/memcpy_kunit.c
+++ b/lib/tests/memcpy_kunit.c
@@ -493,6 +493,67 @@ static void memmove_overlap_test(struct kunit *test)
 	}
 }
 
+/* --- Page-sized copy tests --- */
+
+static u8 page_src[PAGE_SIZE] __aligned(PAGE_SIZE);
+static u8 page_dst[PAGE_SIZE * 2] __aligned(PAGE_SIZE);
+static const u8 page_pattern[PAGE_SIZE] __aligned(PAGE_SIZE);
+
+static void init_page(struct kunit *test)
+{
+	/* Get many bit patterns. */
+	get_random_bytes(page_src, PAGE_SIZE);
+
+	/* Make sure we have non-zero edges. */
+	set_random_nonzero(test, &page_src[0]);
+	set_random_nonzero(test, &page_src[PAGE_SIZE - 1]);
+
+	memset(page_dst, 0xA5, ARRAY_SIZE(page_dst));
+	memset(page_pattern, 0xA5, PAGE_SIZE);
+}
+
+static void copy_page_test(struct kunit *test)
+{
+	init_page(test);
+
+	/* Copy. */
+	copy_page(page_dst, page_src);
+
+	/* Verify byte-for-byte exact. */
+	KUNIT_ASSERT_EQ_MSG(test,
+		memcmp(page_dst, page_src, PAGE_SIZE), 0,
+		"copy_page content mismatch with random data");
+
+	/* Verify no overflow into second page. */
+	KUNIT_ASSERT_EQ_MSG(test,
+		memcmp(page_dst + PAGE_SIZE, page_pattern, PAGE_SIZE), 0,
+		"copy_page overflow into adjacent page");
+}
+
+#ifdef __HAVE_ARCH_COPY_MC_PAGE
+static void copy_mc_page_test(struct kunit *test)
+{
+	int ret;
+
+	init_page(test);
+
+	/* Copy and check return value. */
+	ret = copy_mc_page(page_dst, page_src);
+	KUNIT_ASSERT_EQ_MSG(test, ret, 0,
+		"copy_mc_page returned %d on clean memory", ret);
+
+	/* Verify byte-for-byte exact. */
+	KUNIT_ASSERT_EQ_MSG(test,
+		memcmp(page_dst, page_src, PAGE_SIZE), 0,
+		"copy_mc_page content mismatch with random data");
+
+	/* Verify no overflow into second page. */
+	KUNIT_ASSERT_EQ_MSG(test,
+		memcmp(page_dst + PAGE_SIZE, page_pattern, PAGE_SIZE), 0,
+		"copy_mc_page overflow into adjacent page");
+}
+#endif /* __HAVE_ARCH_COPY_MC_PAGE */
+
 static struct kunit_case memcpy_test_cases[] = {
 	KUNIT_CASE(memset_test),
 	KUNIT_CASE(memcpy_test),
@@ -500,6 +561,10 @@ static struct kunit_case memcpy_test_cases[] = {
 	KUNIT_CASE_SLOW(memmove_test),
 	KUNIT_CASE_SLOW(memmove_large_test),
 	KUNIT_CASE_SLOW(memmove_overlap_test),
+	KUNIT_CASE(copy_page_test),
+#ifdef __HAVE_ARCH_COPY_MC_PAGE
+	KUNIT_CASE(copy_mc_page_test),
+#endif
 	{}
 };
 
@@ -510,5 +575,5 @@ static struct kunit_suite memcpy_test_suite = {
 
 kunit_test_suite(memcpy_test_suite);
 
-MODULE_DESCRIPTION("test cases for memcpy(), memmove(), and memset()");
+MODULE_DESCRIPTION("test cases for memcpy(), memmove(), memset() and copy_page()");
 MODULE_LICENSE("GPL");
-- 
2.39.3


