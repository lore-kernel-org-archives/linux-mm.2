Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1034FCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC2B6B0005; Mon, 18 May 2026 04:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594536B009B; Mon, 18 May 2026 04:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4835F6B009D; Mon, 18 May 2026 04:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36FCE6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:50:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 058661A0867
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:33 +0000 (UTC)
X-FDA: 84779919546.21.AA75966
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf26.hostedemail.com (Postfix) with ESMTP id C29A7140003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uJoZGfGR;
	spf=pass (imf26.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779094231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZlFlL/ldqFxlJ/mCuoKEqDloBHgz/6+XLcrhP5/h8w=;
	b=MSWaCGE0zwJiL5XTiRRz8BfMrh1iIVhMVEZ0tK5SfRi4cIt88ab2kCA5lK5f8RJQLrC92Q
	yw+pdCZLFzrlA1pXkOuFgi39UtmGcMs9rxJbtXrcvyARlEzqQ6Bd4TedRIf80J61l7Uxsn
	TR9WPFgnb4YltsKDXHhvHMD23g4sjt0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uJoZGfGR;
	spf=pass (imf26.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779094231; a=rsa-sha256;
	cv=none;
	b=UC5Z6/jiIj4pZN0twIJyxj+PejtlykkjV47mzCURGuCnt/MtZNv6K0i40u49fBxTmUYet8
	hmfIajAThR8KVOhVQS0WLVZEM+rsSwcxSu/U9W6wSl05aszDCLjSnh/8UHZuPND7VBgD9C
	Dn255wQkA6IfT79YhRIsq+KuOk09liY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779094227; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4ZlFlL/ldqFxlJ/mCuoKEqDloBHgz/6+XLcrhP5/h8w=;
	b=uJoZGfGR2uabJ0rfA3C8SFKfpGjjGGUQuFOZlnA8fZcspelZrbuRcVnJ3RI4zeamr2LYLH4AZPW9DSJxXcUoTjCtT4R+pCcSI0S/l1pcw2eJji3+Y9Tu5YbsprOcziR2kj0GcU6QxNoOz00AGfukC30ObrQeOy9GdvzLa4pctV8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X365dBE_1779094223;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X365dBE_1779094223 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 16:50:25 +0800
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
Subject: [PATCH v14 8/8] lib/tests: memcpy_kunit: add memcpy_mc() and memcpy_mc_large() test
Date: Mon, 18 May 2026 16:49:52 +0800
Message-ID: <20260518084956.2538442-9-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C29A7140003
X-Rspam-User: 
X-Stat-Signature: 8qo3opg618r8h3zcmwo5hbdo6iae1f8y
X-HE-Tag: 1779094230-893426
X-HE-Meta: U2FsdGVkX1/c9/pvdHbncEEF1PnDKBA8r+y2MFflLdE0AnIhkLRXyptiondm8PoyR1IvkjUNhQxjqPCAVLA0e/yZlADuOorpkFEWQaXVV0AMGBtFiW2LYJ17HZxIdL+kFLcsTkmlhW5QDJt/OTwG33+fF+4ioRctcRTEqQ3qcWfYEkN9l080VycaR7vfw0P6qhlBdbPlzpQSkh7thv2Us9SQCfkzxAGKp5bRkAlcIUSmIccBHVLZQ9Hns0HO9LZfhllTxStr9YmpYrhBFGsIFLkchAscO4EADJRmCe3UPW8EdJjfFJq/tqZ34hcwj/LkR/BT5+UQ0FPQCuQfgXIBRumQQLhKc32Zp1U0YtzWFkVybiWJQFArtryyCnQaaFGmdCP4vGSuHkQnEaGl2LqjCKQWSDng3Z/Y9F6BF98Xg9uM3jtCzd25qjS5bDE0fVoMU77R7wjyfGPLl7OX0VLM8C8FLH3uudG1+RU0ycRRjLBVzvYWOGewsCkxCNHxJQfzFFJRhExkWGNAQlIJrQcxg/ulnYPxQ0tnihENAxou4D09jO3+r8rtG+zwfc2wovUTEuzKvJACvm7ZguOGJ6u4SIsOydW0ioccdIjLi2bXoOflqfFdr9NRKs2RF2uKvlJ65qyW9Kn+0ZyD/I6SnzPRQl7TdbsWbTCJ9rQ3rIloAKHVsWKSGH3nJFhfrksl2IIYvEs8qyaQ54FWk98VJsoIjkmRnfBnJzwdDCLqHTO6x/E/XBVGCxDlvDtkH0RycPU9vt14SABLqZ6LtZpu7xC1BJIhw9GdSuPfj2JjsPTpzwl1LPlxQlJG7F6+JtqnGWqjbr7P97uwz0hdKIdVFgzeYtsHNue82pWNhW/b+RfaSm93QrO7Igxy/q/WZCBN3p5fexCc1y7PSK2f9zOBmARncHXZxxANvEmB7obLCGpt/9E66lTKBOa6AIsGUj2PZUF5yXErMfVQV3cZgpqAovU
 qFS4Gq94
 Zt2ws2gDUBSLPDRgSNhMnO6ZqTFjpKKqKIkRdUYcnDGNcuBcQAEjq7J8qQktuqsYrb1FPSDmGpU7ZeInr8d8grAxmJGV+dBPHlUXe0/TGUtcvt/AJXUR83biSPrwjxEB/NFRf7uSmYwMYnKZbT+PQDoWY2Y1rZGMxaPXA2biMBF7fwLC5lCSUs3ESKOiLt+x5oi3Olun9dLlLhR+60MgGht01kuffkRdSa571Z3RGj0Ff2AvOg83Esl7T70QzGPsGTVSSZMc08QxMheYl0DkSAaYvZbxVHH0krSxP3Ru5igdKAEmIRkPVXZMEEuwRFWcWgEZ8pscXr8/Mne0woSKJ25rWCk8f6wMSXq+5MZ14D9GkxNL0WtRV/83uXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcpy_mc() is the Machine-Check safe memcpy variant that returns the
number of bytes NOT copied on a hardware memory error, or 0 on success.

Add two test cases modeled after the existing memcpy_test() and
memcpy_large_test() implementations:

Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
---
 lib/tests/memcpy_kunit.c | 113 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

diff --git a/lib/tests/memcpy_kunit.c b/lib/tests/memcpy_kunit.c
index 85df53ccfb0c..b4b2dafb50f1 100644
--- a/lib/tests/memcpy_kunit.c
+++ b/lib/tests/memcpy_kunit.c
@@ -552,6 +552,115 @@ static void copy_mc_page_test(struct kunit *test)
 		memcmp(page_dst + PAGE_SIZE, page_zero, PAGE_SIZE), 0,
 		"copy_mc_page overflow into adjacent page");
 }
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
+	int ret, count;
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
+	ret = memcpy_mc(dest.data, control.data, sizeof(dest.data));
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	compare("complete overwrite", dest, control);
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
+	memcpy(ptr++, zero.data, count++);
+	ptr += 8;
+	memcpy(ptr++, zero.data, count++);
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
 #endif /* CONFIG_ARCH_HAS_COPY_MC */
 
 static struct kunit_case memcpy_test_cases[] = {
@@ -564,6 +673,8 @@ static struct kunit_case memcpy_test_cases[] = {
 	KUNIT_CASE(copy_page_test),
 #ifdef CONFIG_ARCH_HAS_COPY_MC
 	KUNIT_CASE(copy_mc_page_test),
+	KUNIT_CASE(memcpy_mc_test),
+	KUNIT_CASE_SLOW(memcpy_mc_large_test),
 #endif
 	{}
 };
@@ -575,5 +686,5 @@ static struct kunit_suite memcpy_test_suite = {
 
 kunit_test_suite(memcpy_test_suite);
 
-MODULE_DESCRIPTION("test cases for memcpy(), memmove(), memset() and copy_page()");
+MODULE_DESCRIPTION("test cases for memcpy(), memmove(), memset(), copy_page() and memcpy_mc()");
 MODULE_LICENSE("GPL");
-- 
2.39.3


