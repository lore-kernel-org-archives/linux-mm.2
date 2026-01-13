Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F21D29DE8
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2F76B0005; Tue, 13 Jan 2026 04:12:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60566B0089; Tue, 13 Jan 2026 04:12:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59296B008A; Tue, 13 Jan 2026 04:12:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B12536B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:12:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19C881A0201
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:12:04 +0000 (UTC)
X-FDA: 84326373768.03.517C131
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5413A100009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:12:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=daqWI7RW;
	spf=pass (imf14.hostedemail.com: domain of 3YAxmaQYKCGMHMJEFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--glider.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3YAxmaQYKCGMHMJEFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768295522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F46n0Clt9F/caqPQqDQW8qBOZa0FnmposgAtMZSYCf8=;
	b=kgaleRu8zzLWZgg7Ja73DNEO8EZBPun7GB8rVc6iDSkps0T34X5bMlZMBIjcS/x+02UY4y
	m1YTnekmuKEMiT/3a5DeM6yoepB4LDKe8s+SC5tGZJ+BvxSu4/47744yIL8B9VzOURiD5n
	fzWNy5NwgWV1YBm0A7oKaW8WUuPtvSU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=daqWI7RW;
	spf=pass (imf14.hostedemail.com: domain of 3YAxmaQYKCGMHMJEFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--glider.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3YAxmaQYKCGMHMJEFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768295522; a=rsa-sha256;
	cv=none;
	b=DUsuYOddjchkbt9v65mbEqBhL11sdu6WZFZgJTUVGMkZnl7rVcKyyGR4jUyne46LO3Uvhn
	CwV+zWD+k1H9H/YenDYYprUi9r8CLIICkpWpjunMaDuguKSGvVPyBA5fPCRP1nRercgXaL
	oLjMACF3RF8AaU/TfiWIGrLFJb8Reb4=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430fcf10287so5967806f8f.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768295521; x=1768900321; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F46n0Clt9F/caqPQqDQW8qBOZa0FnmposgAtMZSYCf8=;
        b=daqWI7RW/Mu42+bBdGllieLt76Gb0unPyy/3J37E4SeEYZLZMCmkHbXo5r1X5tbOb5
         XVRlEyvBVldHXZgUp/Fq0gHRF8kfcD6HJC75Su2rGJZoCYlGEf70OwCd2G0ppns9ZKpP
         BZQfUejO1DHEmhCSQ8+sSoN/II/5vCXping1JtJhTO7q5KpIq0mBpR38voapeykzDhEY
         IVGhVvs2AIirgA7SBbdvYKmA4N9pJ7p6Z+d3UtKsghhxGkqDzEzb2eQqbGeLb4X1dC/m
         4OCvsY6bqyD7qdsDOYqg/fIOCiqLBpgF+i6ONCprLryMu2Ezeb6Gllq8jHEgnnBLuSYG
         j66Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768295521; x=1768900321;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F46n0Clt9F/caqPQqDQW8qBOZa0FnmposgAtMZSYCf8=;
        b=lPznZ5d/LTH4KtDqDp1HOTbYpAPtwtKLebkdhFgrhQnBbyhjfsiVYN0p9dO/tut/7F
         g/+Vt+o377ZXu3oX9PiIO/jSqJsHD5HBjnPe3vs8CJ2UVtxctVle91MXdBRu7uQMZzha
         fc7JZb8oziWGp3koGZZr/MT5PuHXJJi4Fmc4JqsI/pHtmRUGh8NTgdt7QoKPoqhL9lOJ
         jIQrLZ/pzU9jFCYmJ+uL1R38x2I/H5rOAXpSLXE7qLQyE3meWBWqrNiaWMZ4kHUSYSSq
         cuHEFd3/2IvRDI8jB8P8qdMCyAuKXfr0stqcXFyX8aANTGKNrpBWjyG3BNdhd/Ill9Fd
         MNzA==
X-Forwarded-Encrypted: i=1; AJvYcCU8W02J+hj3RDMPk1hlmKl1aqKzhfcZ/IPM8vZ+lfpu8Fu1K+lzW8uDzCqJDxWebXHLeEn6zODPaA==@kvack.org
X-Gm-Message-State: AOJu0YygTPbfoFDlJV7OrkDLy6dCAmVZLgr1gs7Nbh/+hEhe8nHcpAnS
	Ul+/TljtZ0TmPE7O2aMBwgODhziy1yCe2qhI741CZffbTj7YiV/Ixi1YKIvwxaBD+mypPKtAo9f
	SA3rPUA==
X-Google-Smtp-Source: AGHT+IFvJvCQKlv/UjRYK3bRQMAojNzCZKDToTZHIs7CJTLzk396cU8VuHyU5F6Z4b3YJWtodTjzmRl+JJs=
X-Received: from wrbgk6.prod.google.com ([2002:a05:6000:3106:b0:42f:c9b0:e5f4])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:24c2:b0:431:c73:48a8
 with SMTP id ffacd0b85a97d-432c37c8796mr25385140f8f.29.1768295520722; Tue, 13
 Jan 2026 01:12:00 -0800 (PST)
Date: Tue, 13 Jan 2026 10:11:50 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113091151.4035013-1-glider@google.com>
Subject: [PATCH v2 1/2] mm: kmsan: add tests for high-order page freeing
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, elver@google.com, dvyukov@google.com, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5413A100009
X-Stat-Signature: natxxt4kszid8tewj7dwd98ccuto4bpf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768295522-252599
X-HE-Meta: U2FsdGVkX1/i1QJqD5vT8/OgTGYZdmlSoq8+bbk2waO5kgTVy39DYWq7d7+rf6iEqB/odqYVf2g6njnIbei4oeA1oKErIVxtYVjSw81yOlKSIYUhJ5+8pJfcM+DjiLBHKwd3VW6i4kAeB0tzcr/hHpVnXXY1ot7TuAzRhxrl3di0rItvMFnSCXmQGKl5WYn78vyfdIftb//L+6Sver/7Vi3/hSI4kiz2GhSydGzP7YIXzlGGBxaJhMfGXazRpSlhpwHpALuCqULXnvZeVCAUXQBarsa7VuKTeTuKsoy5PMyaELjEZKbPO/XGmHGaQno+qPVK0pix6L5anbYeTyZYZoWZGZ1tgB57/sL7/VPj2PjyXBKHZZQygmcT3OEOnAIReJI+DJ3Un5rljVOJhyTtop8UmBSNV04DCjzTpDATmMc6IfWAu57x5WfemM3ulVrUZk/yx9YAduDcv62AMiLlmmHxs+8tHRTC+jar5pRME7uhbG84HhrmGn7sYEbu/x2KOSXQNz+36xKnL/EYjIF7NHWg+CqeqyAHFAy6w7MBSpRw5WlPE+QhExm84YXRHK45YNDhRtp0Jj2M88HYARdV+600QmajO5JDGNKwmJKnJCyOym/VRX0HTHaS5AD5tcrqAoOeQ6IMIc5kLL1sHcp6ba94PC7vU7SNgyRF8NdnYK/Bz2+JOHPzKye8/JU5oF+F3PZOTGYZR6A8wmmWrges5bhPNzE3Dh/vc0/Q/eupFM5zlo2QKKWl/1snrvjbvPpe9u4R3HnnS3JOYYZQCETxLrD4f+etYz2e5KC1ULiofj+h8YhG3cTlB2euWN0UcnLdJOuoD8QxDH8X8uSGNhNSQNQzqMvHTfp/oe30injShebOd2f+nwgOayUFXlzJgdz4MFSEN1Pq0gSUUJNl5acl6y/iNLELlQRcjigyd1lzqQ3cVMVZ6Za+V3V3F0PVjsP7XXamdRgUQ4874HqLHUP
 kFe0lki+
 /fV4rY28b8NAjrlTEVJmMUI9EPIPi+JoknHCo2KpAKa5bFmOCboekS2p4iqI96QRTOI+d9YrJhpRMfuVfSM2BdR/7gUVGoJdsyAWi+mi9l9cCKHg7EOqp4ys8YYSAcjTS8mI8i21kS5MWXtNfCqQ2ELyUydCjRYnObCLjt98z4WGop7secMHQcI45NHeoZLEuhiRWnZxaIOH8mA0/pOf22t6O9VEitN9N2NKJq5YJ84YFpejZlz5yNx2Nun3jI0Zn38XPvruUJ4I6LhSFFi5Vf8K5qC5ECrX7mNMtwAFEiorXAiZGsFtlSomwHHYd79VQzRRfB74chZs/M3XtJT0Zui8V37+wDmQeT4BANUMU7CxCpQwvsJAB9IBFz/4I7lt036nkZHEbgNPYTumTXb8aMo5ekL0D1uZnSwJDWXjlNM/S3Y/5ZojwRHRTUElGAcBvIuil70Y3GQT5W/c9r/rXlRKdd/ryq0UKDAwHoqIXVSzLYSY6mcbDKCQnywyWN/rJjM0rFDCM2fJs4aaBlJeB9MYv74v/oHqnzal7SpZW2Q1W/xqQIUHLpId60FPpmM6/eEE2PaG6KLMxCW9pyrIHTDxf11zi2Hdi4kpEUVk9vH1cIPmZuzc9x67Xng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add regression tests to verify that KMSAN correctly poisons the full memory
range when freeing pages.

Specifically, verify that accessing the tail pages of a high-order
non-compound allocation triggers a use-after-free report. This ensures
that the fix "mm: kmsan: Fix poisoning of high-order non-compound pages"
is working as expected.

Also add a test for standard order-0 pages for completeness.

Link: https://lore.kernel.org/all/20260104134348.3544298-1-ryan.roberts@arm.com/
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

---
 v2: factored out the common part of the two tests
---
 mm/kmsan/kmsan_test.c | 49 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index 902ec48b1e3e6..ba44bf2072bbe 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -361,7 +361,7 @@ static void test_init_vmalloc(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
-/* Test case: ensure that use-after-free reporting works. */
+/* Test case: ensure that use-after-free reporting works for kmalloc. */
 static void test_uaf(struct kunit *test)
 {
 	EXPECTATION_USE_AFTER_FREE(expect);
@@ -378,6 +378,51 @@ static void test_uaf(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+static volatile char *test_uaf_pages_helper(int order, int offset)
+{
+	struct page *page;
+	volatile char *var;
+
+	/* Memory is initialized up until __free_pages() thanks to __GFP_ZERO. */
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	var = page_address(page) + offset;
+	__free_pages(page, order);
+
+	return var;
+}
+
+/* Test case: ensure that use-after-free reporting works for a freed page. */
+static void test_uaf_pages(struct kunit *test)
+{
+	EXPECTATION_USE_AFTER_FREE(expect);
+	volatile char value;
+
+	kunit_info(test, "use-after-free on a freed page (UMR report)\n");
+	/* Allocate a single page, free it, then try to access it. */
+	value = *test_uaf_pages_helper(0, 3);
+	USE(value);
+
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
+/* Test case: ensure that UAF reporting works for high order pages. */
+static void test_uaf_high_order_pages(struct kunit *test)
+{
+	EXPECTATION_USE_AFTER_FREE(expect);
+	volatile char value;
+
+	kunit_info(test,
+		   "use-after-free on a freed high-order page (UMR report)\n");
+	/*
+	 * Create a high-order non-compound page, free it, then try to access
+	 * its tail page.
+	 */
+	value = *test_uaf_pages_helper(1, PAGE_SIZE + 3);
+	USE(value);
+
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 /*
  * Test case: ensure that uninitialized values are propagated through per-CPU
  * memory.
@@ -683,6 +728,8 @@ static struct kunit_case kmsan_test_cases[] = {
 	KUNIT_CASE(test_init_kmsan_vmap_vunmap),
 	KUNIT_CASE(test_init_vmalloc),
 	KUNIT_CASE(test_uaf),
+	KUNIT_CASE(test_uaf_pages),
+	KUNIT_CASE(test_uaf_high_order_pages),
 	KUNIT_CASE(test_percpu_propagate),
 	KUNIT_CASE(test_printk),
 	KUNIT_CASE(test_init_memcpy),
-- 
2.52.0.457.g6b5491de43-goog


