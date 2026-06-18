Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65412CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0B36B009B; Thu, 18 Jun 2026 08:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A576B009E; Thu, 18 Jun 2026 08:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132CB6B009F; Thu, 18 Jun 2026 08:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D73666B009B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:01:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1830B8FF9C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:30 +0000 (UTC)
X-FDA: 84892492860.22.0031528
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7A63B1A0008
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Uo81QmTz;
	spf=pass (imf19.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sgsf8RzjsXerwuZjuCBzolB1nDtZkh04rgvz44IY/VY=;
	b=mWoHwEIZy73l7FdW1i7hgHs0LAUao2mgAHCRDZ7KMh6RKPFAvC4HGoghl+cvdaXjSJvUG8
	lwZTa+yGXtGZ6yHMrHq4BNDaf4c+fs7bbY3XhOYqoVUic6Jo3GqpcAqckqYo9W2HpbiQ5X
	SBuZphNu5LAl6A08IOS5/p1fmDkQ65k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774548;
	b=W1syL6aF/WeuWwzur9LQcK2zkMQ5m2MGHjL6b3wdX3rrTGqOhT77Z8vHzhclrnkKmqc+D9
	Ox3UL0CkyuSxnJ5RcebiXS+NwSIs0a0+UwJFVojqaV2YMbFMTbDXqdx8DrthFTxCPJPFk2
	vHRefd7YyNdv3I/1YcYKpl5EMKJxVLM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Uo81QmTz;
	spf=pass (imf19.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774545; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Sgsf8RzjsXerwuZjuCBzolB1nDtZkh04rgvz44IY/VY=;
	b=Uo81QmTztTCGXPRKhRNzvfHe+XVNRaS5fTTI4l0SMyp7CCyQv3muvnRUh7czXipWivf1TWsBnmLC+R0FORvVdRyxgN6QcI2TA8TwnXYYI07BKITYL7kJoxX23UinOZ4oTXNW2+kPhqudbXEQXGAcF5YAeTqlvZpuCk5q4YWWz8Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X56TKGA_1781774534;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56TKGA_1781774534 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:22:21 +0800
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
Subject: [PATCH v15 9/9] lib/tests: memcpy_kunit: add memcpy_mc() and memcpy_mc_large() test
Date: Thu, 18 Jun 2026 17:21:23 +0800
Message-ID: <20260618092124.3901230-10-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
References: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A63B1A0008
X-Rspam-User: 
X-Stat-Signature: fgead8wwdfreuit9dbkygzx8amsyjoaa
X-Rspamd-Server: rspam08
X-HE-Tag: 1781774547-22009
X-HE-Meta: U2FsdGVkX18Oy6DJ0HWfr5ZTY6OfEhHwNOL4bYD/DuqoJCMWh69RJgmVuh1t5bm3DK6AH6pRc0bJyDO5A8OpRqSdiZYJJBZPxkxLndKbNtVYVfkHYkkdT6QSoHRT7PLypaouzHRVzhuOUMqR9Z3iC3Ezjm4z28WJ00PRLZmsTQ3/BXVfO/gV7UuKo/27YwrW4WWJ31h9V6cNsEMctLfapM1aVqGUO9RJ+vXhKsHK/87mBY/4LeesKh9UEGgdhWgornQDvacDPeG/Q/4B+1y/ac0rHorut1L2by2Az66KOckfG6pLxnhss1zu/yPk5acvcVhDc/bt+raVFexakm/IUneiFCaCGvOgKqqa5cAPOVuuj2IIhi1YSPI/27z48jmsGRHVI0NOOzTVBMS9XNLd7dNXV9J0GWeon5zRE2HMRzorHcr23jfo/JENTYSeWAinqaIzCAnYfr+6TxAyS5EUJyVcwk+mK0aZTc7GNRfK4zS4nedlUc6o+z2l7IDbG6RiLgkMDHWJiFpUWVrYrNU8/lJzsus8SjIX9c72+ZfyehnyI4JHxFdBfNyV6rdR5iHOfzFADtd+lRDEu6vRgjkf0zOpr4nxtWbsJ7vhC7DbpK6JWWJrHJ1EgkF1GKfxDNuHxdV+PeqIZF3n99bck5I2bnbVvlYjkrnD3Mhq2zS6puScJQb2ab20sopRuvPxeGfzhtbbzCDgJexmk8aIMp/BH9EfUJq+R0j8zN8oTCp0BuR3NDpbb9ri5JTyX6RLgzQPVxpy1CbvFzQCBhBCwrUb82zHw9GissqIdE1Wqu14JOi//YcEPAqYD7QxdlQN/OJoIgKE2W9MRryZTUUtFjpBINoozjTcBWJh+3txVMXeicRuTIGbYKSBMbAkGAP57Un94a0kHM/t5MBY95n9dlSoo/nRLePAuTsco0M22DcyIg3PfGovwy5knGEGM6AXPWKaZ3joLW/oQXvQ63WkAnx
 2+hhLuWl
 B4ayZ7RwuURWUF+j6kAgPqs4mMqb6MORuupuiSZnNjL1NQyksqbeVl2704XO2ahrnj56yVbCtmYbzVT8FWXogE7aqeHKuFJ9Eb4wZxOufUMl4c4KrAOpPUkAVasHZ+/GM8spKnoNZ86fkHVm2VQ6bUgZUa8RyXHquD11RTuyfQRiMl90tgfPbqKntcdnzw9F7KfEaOxcHE8nZeaKQaF5/y0aqTH50Siw6stdwhawzktxepaDKvnZDfvSymUF2NGwt+l9lNDgQGTaa0nNPcmXKuE+nzQP3KV0fJW1whDWeXMottXyBG8tjsUorALbfOffwzIMJTnw8MLw6ouuGNmWiIrzGRlR5YMtwO0JtWxWAET7i8AtrRvrDkO5ciA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcpy_mc() is the Machine-Check safe memcpy variant that returns the
number of bytes NOT copied on a hardware memory error, or 0 on success.

Add two test cases modeled after the existing memcpy_test() and
memcpy_large_test() implementations.

Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
---
 lib/tests/memcpy_kunit.c | 121 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 1 deletion(-)

diff --git a/lib/tests/memcpy_kunit.c b/lib/tests/memcpy_kunit.c
index 812c1fa20fd9..87585fbe78c7 100644
--- a/lib/tests/memcpy_kunit.c
+++ b/lib/tests/memcpy_kunit.c
@@ -554,6 +554,121 @@ static void copy_mc_page_test(struct kunit *test)
 }
 #endif /* __HAVE_ARCH_COPY_MC_PAGE */
 
+#ifdef __HAVE_ARCH_MEMCPY_MC
+/*
+ * memcpy_mc() is a Machine-Check safe memcpy variant.
+ * Signature: int memcpy_mc(void *dst, const void *src, size_t len)
+ * Returns:   0 on success, or number of bytes NOT copied on MC error.
+ *
+ * In the normal (no-poison) path it must behave identically to memcpy()
+ * and always return 0.
+ */
+static void memcpy_mc_test(struct kunit *test)
+{
+#define TEST_OP "memcpy_mc"
+	struct some_bytes control = {
+		.data = { 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+		},
+	};
+	struct some_bytes zero = { };
+	struct some_bytes middle = {
+		.data = { 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0x00,
+			  0x00, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+		},
+	};
+	struct some_bytes three = {
+		.data = { 0x00, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			},
+	};
+	struct some_bytes dest = { };
+	unsigned long ret;
+	int count;
+	u8 *ptr;
+
+	/* Verify static initializers. */
+	check(control, 0x20);
+	check(zero, 0);
+	compare("static initializers", dest, zero);
+
+	/* Verify assignment. */
+	dest = control;
+	compare("direct assignment", dest, control);
+
+	/* Verify complete overwrite. */
+	ret = memcpy_mc(dest.data, zero.data, sizeof(dest.data));
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	compare("complete overwrite", dest, zero);
+
+	/* Verify middle overwrite: 7 bytes at offset 12. */
+	dest = control;
+	ret = memcpy_mc(dest.data + 12, zero.data, 7);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	compare("middle overwrite", dest, middle);
+
+	/* Verify zero-length copy is a no-op. */
+	dest = control;
+	ret = memcpy_mc(dest.data, zero.data, 0);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	compare("zero length", dest, control);
+
+	/* Verify argument side-effects aren't repeated. */
+	dest = control;
+	ptr = dest.data;
+	count = 1;
+	ret = memcpy_mc(ptr++, zero.data, count++);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ptr += 8;
+	ret = memcpy_mc(ptr++, zero.data, count++);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	compare("argument side-effects", dest, three);
+#undef TEST_OP
+}
+
+static void memcpy_mc_large_test(struct kunit *test)
+{
+	init_large(test);
+
+	/* Sweep 1..1024 bytes x shifting offset to cover all template paths. */
+	for (int bytes = 1; bytes <= ARRAY_SIZE(large_src); bytes++) {
+		for (int offset = 0; offset < ARRAY_SIZE(large_src); offset++) {
+			int right_zero_pos = offset + bytes;
+			int right_zero_size = ARRAY_SIZE(large_dst) - right_zero_pos;
+			int ret;
+
+			ret = memcpy_mc(large_dst + offset, large_src, bytes);
+			KUNIT_ASSERT_EQ_MSG(test, ret, 0,
+				"memcpy_mc returned %d with size %d at offset %d",
+				ret, bytes, offset);
+
+			/* No write before copy area. */
+			KUNIT_ASSERT_EQ_MSG(test,
+				memcmp(large_dst, large_zero, offset), 0,
+				"with size %d at offset %d", bytes, offset);
+			/* No write after copy area. */
+			KUNIT_ASSERT_EQ_MSG(test,
+				memcmp(&large_dst[right_zero_pos], large_zero,
+				       right_zero_size), 0,
+				"with size %d at offset %d", bytes, offset);
+			/* Byte-for-byte exact. */
+			KUNIT_ASSERT_EQ_MSG(test,
+				memcmp(large_dst + offset, large_src, bytes), 0,
+				"with size %d at offset %d", bytes, offset);
+
+			memset(large_dst + offset, 0, bytes);
+		}
+		cond_resched();
+	}
+}
+#endif /* __HAVE_ARCH_MEMCPY_MC */
+
 static struct kunit_case memcpy_test_cases[] = {
 	KUNIT_CASE(memset_test),
 	KUNIT_CASE(memcpy_test),
@@ -564,6 +679,10 @@ static struct kunit_case memcpy_test_cases[] = {
 	KUNIT_CASE(copy_page_test),
 #ifdef __HAVE_ARCH_COPY_MC_PAGE
 	KUNIT_CASE(copy_mc_page_test),
+#endif
+#ifdef __HAVE_ARCH_MEMCPY_MC
+	KUNIT_CASE(memcpy_mc_test),
+	KUNIT_CASE_SLOW(memcpy_mc_large_test),
 #endif
 	{}
 };
@@ -575,5 +694,5 @@ static struct kunit_suite memcpy_test_suite = {
 
 kunit_test_suite(memcpy_test_suite);
 
-MODULE_DESCRIPTION("test cases for memcpy(), memmove(), memset() and copy_page()");
+MODULE_DESCRIPTION("test cases for memcpy(), memmove(), memset(), copy_page() and memcpy_mc()");
 MODULE_LICENSE("GPL");
-- 
2.39.3


