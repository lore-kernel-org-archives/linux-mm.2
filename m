Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FFDBC9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88F516B008C; Mon, 12 Jan 2026 09:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A3F6B0093; Mon, 12 Jan 2026 09:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7870F6B0095; Mon, 12 Jan 2026 09:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 610F86B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:51:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2045E58CC7
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:51:58 +0000 (UTC)
X-FDA: 84323601516.05.6B692B2
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5C6921A0006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:51:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="V/XpdNBn";
	spf=pass (imf19.hostedemail.com: domain of 3igplaQYKCIUpurmn0pxxpun.lxvurw36-vvt4jlt.x0p@flex--glider.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3igplaQYKCIUpurmn0pxxpun.lxvurw36-vvt4jlt.x0p@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768229516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zb8lxCUKflLPJGxewVRt/oFLWki5YH9LqEd9Zx/sLAc=;
	b=RgQXmwdp5wxUweeaxYXUBaN5x/pM20cSKooHsbMDeDBZeUv0Uqao1eN2KCrs8KVP6FrXex
	lMuzRM5b6EtIMfjoJXlpdGcpPi3BVS26f2ukssOIRAt2ku7EP4kaggUePgVeOMfIvtxEoA
	hP/A3LL8ePB5i1++6VwgnZmXYtGghEE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="V/XpdNBn";
	spf=pass (imf19.hostedemail.com: domain of 3igplaQYKCIUpurmn0pxxpun.lxvurw36-vvt4jlt.x0p@flex--glider.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3igplaQYKCIUpurmn0pxxpun.lxvurw36-vvt4jlt.x0p@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768229516; a=rsa-sha256;
	cv=none;
	b=Qk1DblMaSbWuu1CnzycO5BeL0fx1FDE2mBpXFlqAbGCzpgXTBeIdN14QPEmvANke0goZGO
	GHx9+Ar2NWohqM1ZsOodsjWFyhJujM1mtkDH1YFN/xKSVd8REugmOGMCOoCO2dlz2sMaIY
	HVEoZS6A4d/ssnfC1//1bJKl6pnzeIk=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64b4b64011dso10994166a12.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768229515; x=1768834315; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zb8lxCUKflLPJGxewVRt/oFLWki5YH9LqEd9Zx/sLAc=;
        b=V/XpdNBnJt6JWLNCb1tGIeWIsC1TEEScE4IT0Nh2ZG7ubvWCOsjunsb9RcTY5LXS2P
         WpaUQtm9BRNyl1hHzqwbqvZWyonxhelvslyaPuM6hINXy52xL3AtiOMdoMr8espPUN8Y
         60MVcAeQqArJ15+nZO4zFsuCFRVULzlHJRYk8Y40dRp1xuUmZDmiZb/LGmMfZo24PUCP
         tyQDOLDGkRFTmycwzpyelfg5tMsIfHv0Bjto2toa5Wr1v4f6Eg2YfkuxhIVQ+2L/IzTH
         0mEPCRw0b2yMM0/wtObVyC3rD8azZzZe+dDRVy23App2E7fxhkko3SKRl6pyOkIX639R
         uv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229515; x=1768834315;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zb8lxCUKflLPJGxewVRt/oFLWki5YH9LqEd9Zx/sLAc=;
        b=m+UNnaomf2unarrhaKMTIj+Ej5xVy/ld4KFvykdz1Ajkl1e2Yn8R1VWiedfqBqkbl2
         dyW2Rs6S/MR9v+XbZwTdT1ljaktYy0TD6CqsLpowzpLpcoaoa7iikgSG6nM3u+WTPAzW
         v06PlwC9X6dUY882wFGr8zI6312bd14UYF2SOY+zUzjV3D3xYwizPzq54oaPbo+L+Jqs
         sHl/vcda2ahB23Kw7DiVknPy/JjsYD13H9j5GSPOO36rCyUAC8BzfrKzc/u8UIT+Rpr5
         /lMk5f83Y1ZH9hsgcmvOVtfO1dDnkC3YkP4IZn2VqdhZIsmDro/KByUaKlPQ2J0W0Qf+
         1VKA==
X-Forwarded-Encrypted: i=1; AJvYcCWJTcOOJns8vtL/bgW28wJVPE592F+qLfxilWsZnXU0nyWDVkW9oJa8rOYdJUZjtY2Ypk/QiKAg9w==@kvack.org
X-Gm-Message-State: AOJu0YzoWNPzk8/2o4tLUp7oBJb+MEcmlaKCeEuMhO5ZWJllS/6hVTFH
	P80b0UbdtSU6D2U9EMpmvN9sfBpV++UuIxJBXCDGnnW/Gzk3ZmaYn78J1DxEoQeFuX14D6Mn70E
	QPpo4MQ==
X-Google-Smtp-Source: AGHT+IGvtmybmEn6Uoh/uHwnBdalPGDJ6a15O2TO1I8WItVDFvaFD3uns5oSaCtlbSDdK8/QzTt42R3jc2w=
X-Received: from edbbq21.prod.google.com ([2002:a05:6402:2155:b0:641:6f6c:f930])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3fa3:b0:b87:253a:dd39
 with SMTP id a640c23a62f3a-b87253ae4a3mr232543166b.26.1768229514739; Mon, 12
 Jan 2026 06:51:54 -0800 (PST)
Date: Mon, 12 Jan 2026 15:51:50 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112145150.3259084-1-glider@google.com>
Subject: [PATCH v1] mm: kmsan: add tests for high-order page freeing
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, elver@google.com, dvyukov@google.com, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5C6921A0006
X-Stat-Signature: 4mq3g5r6d7usjjrkp3m9sq4317dih8wz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768229516-127424
X-HE-Meta: U2FsdGVkX18otHA7BIFYwrBISIdThgqizSynFjmQvKnZSb/kv5tEdmq6JTuOPY76AETbiujRs771O82Ucx+FhbkhsLBHZhgdQSpi7nshWbyDDGh4V9I7I6siLzZCCHG/Lhm9UDgVSGO9Tv3MqBiY/DQV/dd3eAmRQdFiShul+p1L6YHMPZZx+JXebRs633cPAZa/YPW8OTlFJNjSHb+08mW6BMgyiDdWq+SsBGgwjK8lNStbaSPv2jKbBCJDYlcKVtNmkR1wMnAhJLpzv4Q96P7fzoxxTo9q5WCZcEiNwbCvTPQUG42r7073PKMttdu+wxhxsJRHwEEJzcyJsI/IlpfcFXiKu9S0EPqBf9iHq3SOPpJnYxChmely59MvqywEPXD6J/gbr+VG3w8mKbSzr8PF28Qg2G3PZC2Ek9ATR5+weqYRW8J2upRhUYxGaLVEXGCUNenqb2v5Glu5cLoC64YoIhwE5PUiJ7mZwRU4bqa3MqxE4SzVVDX5UZ5i3R1FHi1wxyukXqNpCqJaM4cMUh3M+uBeWZ+zbugZKsnJJMady19IA19FIRSU3/U16vpjynYxSHkujxDQHof8pyIhs/rxgw5OUHzTcnVhV0a3ZDEE2osKRB271YkULfH9GjklZgPRN/oWVAtgsvrjmoKMJhi52jnRp79grcuBpaiDLzWqV+EtTfzjO5JIQb5JD4wlLPD8cgdqDJFKE52nXHDJfShkFOkiM/NshWId1mrNxsvCDMHlWsI8cbLzHNgtEykiPGRQ4DaKASGDuL0ymoR8UJbusw+CX7b1kGmHfUxBTcnYsRB6HQE42u75ZLG313xky0PZx2gtctXegVsmBVI0rovc0/lyLTQ9/7g1O/Kq/+c+cYmw0MHXuuzQOrkSHsFKwPv2bFcMlC+rIl2ImbSNWTrp+cnmwlya2Z2TEvYE+vPFe6uJNkIhL5lJMEF87+gHvhRCVNlPnwL5uiFVi6v
 FXiijDSr
 sYchDa8p/51e+ky0EZx9Lnijwo93M0FOl8v3dGQZDC7c0wUWGrJEItwGirzoVPlla3+X9hsadB9p3XyGsaIzK1KLkctAea4cD0T/ydIVbBXtb0a1Bv3MsAlmddn6I+zkaaPMclLFL9trYHbuQrI6htW+ib73A7D8uaU0RDKcTpjgcmDif6cO0rW7D+EG1JyHYkSZ0teYUm3lIrzabSAGpGCErHX3T4j0db+s8MzdAyJlAydiuqbVnmGHxJzWHmX9phZge8PvwXKhTmU2yXH9qu461dhJgHG3tHrMtZqlvIxlWQZ19YS5HrsJ8rydmf4EbNqWvvIncVnWhtJSFOjvv1mE18u/aWHEN1nopE92z6m9wBnpz5W9JM/GIkzdvS7JQnGbpY8GjAGMykO79GKpnisKdRq4BifHJSYGSu/NoeW9cpvk2ofAZdWTR0/1InrbIcv10nIusZxnGLQP1SN3Gtgaf1MgIQzWwgR3Tnf33lFJraSqQWLLY90aaGeX82+wX7GkfBHBjqaQ1krpPXc9HlEiC2zSyC/MPxIaCdXJxbUURibjNfJSznfSImsFh8BVBV3sWGbbS8JziKN1Cto6XifY2rQK1KdKcze9y9ZmGHqy+juRJlP4t1LEm1Jidq4e7x4NRLcE8qAhpw6c6mPJfu3+DFG+NOdD7MC31AqD3NKHrF1ZXdNMAav9jLGsRkA+jGhdmKxdBznut2LI=
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
---
 mm/kmsan/kmsan_test.c | 48 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index 902ec48b1e3e6..25cfba0db2cfb 100644
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
@@ -378,6 +378,50 @@ static void test_uaf(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+/* Test case: ensure that use-after-free reporting works for freed pages. */
+static void test_uaf_pages(struct kunit *test)
+{
+	EXPECTATION_USE_AFTER_FREE(expect);
+	const int order = 0;
+	volatile char value;
+	struct page *page;
+	volatile char *var;
+
+	kunit_info(test, "use-after-free on a freed page (UMR report)\n");
+
+	/* Memory is initialized up until __free_pages() thanks to __GFP_ZERO. */
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	var = page_address(page);
+	__free_pages(page, order);
+
+	/* Copy the invalid value before checking it. */
+	value = var[3];
+	USE(value);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
+/* Test case: ensure that use-after-free reporting works for alloc_pages. */
+static void test_uaf_high_order_pages(struct kunit *test)
+{
+	EXPECTATION_USE_AFTER_FREE(expect);
+	const int order = 1;
+	volatile char value;
+	struct page *page;
+	volatile char *var;
+
+	kunit_info(test,
+		   "use-after-free on a freed high-order page (UMR report)\n");
+
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	var = page_address(page) + PAGE_SIZE;
+	__free_pages(page, order);
+
+	/* Copy the invalid value before checking it. */
+	value = var[3];
+	USE(value);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 /*
  * Test case: ensure that uninitialized values are propagated through per-CPU
  * memory.
@@ -683,6 +727,8 @@ static struct kunit_case kmsan_test_cases[] = {
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


