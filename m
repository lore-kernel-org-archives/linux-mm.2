Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA25CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 23:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1626B0088; Mon, 28 Sep 2026 19:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06AF16B008A; Mon, 28 Sep 2026 19:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75C46B008C; Mon, 28 Sep 2026 19:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A602A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:17:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15C28A036C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:17:44 +0000 (UTC)
X-FDA: 85264735248.20.EF32DCF
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf18.hostedemail.com (Postfix) with ESMTP id 749FB1C0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:17:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UD3ZUWiF;
	spf=pass (imf18.hostedemail.com: domain of 3lPW6agUKCMcz14o1t11tyr.p1zyv07A-zzx8npx.14t@flex--morbo.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3lPW6agUKCMcz14o1t11tyr.p1zyv07A-zzx8npx.14t@flex--morbo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790637462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zgYdhHRirzaDeDdzeIxud2Mvl3o2ziyuC0fsYtI2DJw=;
	b=55boOEzA+FuMgBJPEe+1MJjTLlDcp/hv/4wNJSujcYF0TrhQpgLBiBfOGuKH4D0i4QGN1D
	3AvI/b8FHuzsgw5dfamg3k5pgGQZDDBQiHgSUMOA+GlJH5Aw4dihZDNhir1/2u5ZHIg6xb
	cdlsj6J16n3vwB0VcNGRdTzoCtYCNOw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790637462;
	b=m0E9OpeW51f/g+dMS9zAIqjzu+eXfX7oCXX71OTCTn3rSbGQ/g5D73pbLz/Xea32/6RiMQ
	jjoH0WMZht24oY/ULtq+u/JzHpzeMm2vhJHPGyzfc48MvGdyC6H/gKFLfFNDdm5gfgRTEv
	B87uwD5S3iB700mJ9tcsDrmYbwcdSWI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UD3ZUWiF;
	spf=pass (imf18.hostedemail.com: domain of 3lPW6agUKCMcz14o1t11tyr.p1zyv07A-zzx8npx.14t@flex--morbo.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3lPW6agUKCMcz14o1t11tyr.p1zyv07A-zzx8npx.14t@flex--morbo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-86261e66700so2611134b3a.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790637461; x=1791242261; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zgYdhHRirzaDeDdzeIxud2Mvl3o2ziyuC0fsYtI2DJw=;
        b=UD3ZUWiFl7AZAWz7bs4Yekw3kMv75ei26ai9zkKQ5QMju+JAXKXhft+WgS7pbI+uSi
         1IgbTAI6nTM62MZSk9xYb9j6N5bELOjwciLtxDtU8l3lpYv5CrVrLfCymIR5tcl04WqP
         Rkar7R2sguLlmAm1PTKgDI/n2Fx68ZL89vnaz9clkOT6ihd8m96uoRDd14H3gQVkF98k
         OPtMlVO8JN71o+rSCRKdVNnbAek5jU0OQHUgM6qtHkubPRd/KnSj01UGKk++qbrs6zaj
         ImN153rtKwyjO51ljXy1eV+9k2mUjfw2NGIaBWv/Bw6/pX9RmKLIelrK7f69uDFRHFCR
         7X5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790637461; x=1791242261;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zgYdhHRirzaDeDdzeIxud2Mvl3o2ziyuC0fsYtI2DJw=;
        b=c8Aq/+HiPcxI0FjbCyEXiHnQeCR+a7Q1EQua+3TIT+LGdlY/CIXcFaBjfTzqL2URAI
         ftN2TQ6QNc50yUlu/Ee6xlgkoxW1RAcnePVuuHtfbGsOWfpnGA79JJ14kUIPCNhjP92Y
         nEdBfxO6mTKQRenTDXpiWyfHYquAblFNsVz6YLG/jstJ1NZmr7HDK3VaxduPj+/aosQL
         3VwRj03BfZbg7PkUcbFg5lwvYrehCnOrfOsnoQfcK5wnvhHCQmrMlYcKtXlwcSHLZmPr
         gBQ1wPJZZxbs4ofctD4WajvGhWpUW/JRIscLk4i+aZGD6wqV8Ckwp2S1IyWtveqbXCyn
         uO/A==
X-Forwarded-Encrypted: i=1; AKwUvByCjGNDSC4NW1EKfjUjyZgJzWoJQ0vZjtVen4HSDYoP748msA1mTTBiZ58VkH+ALLxVXhHNB2R56A==@kvack.org
X-Gm-Message-State: AFuF++lyF2SYbIYhbq7KpqdUS2MDZKdQnG0lrbz8iZOtZJO3+KNN0Bp7
	nfOk0C+jvzaSlTzM3KKSXRZyTUg/OEzSW9nV32fcQV5zuOSLW/P6S/IXUrqMZ+UOrlVP3roaOK5
	3
X-Received: from pfra18.prod.google.com ([2002:aa7:8e92:0:b0:84a:2e0d:e14f])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e85:b0:881:fffd:26af
 with SMTP id d2e1a72fcca58-881fffd2c53mr4983469b3a.44.1790637460762; Mon, 28
 Sep 2026 16:17:40 -0700 (PDT)
Date: Mon, 28 Sep 2026 23:17:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928231737.2092716-1-morbo@google.com>
Subject: [PATCH] kasan: add KUnit tests for __counted_by and __counted_by_ptr
From: Bill Wendling <morbo@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, thomas.weissschuh@linutronix.de, 
	Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: dt6tuzizwgrwytdsxw6zwnxzo3f48cuw
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 749FB1C0007
X-HE-Tag: 1790637462-460299
X-HE-Meta: U2FsdGVkX18AfZbFmByfs/r0TNCG6lws87OTd68jLj/dXlGjiykvKh3SbLewEXNiUd5QpzAFy6XpI4rxrcpgBUhCUkoHlAbR0gtLTfdKX5ePqSXBnH1dsOwp+Y9dQQFn7X8OvOpQDlg0+jVpo4axxwrWDpsefx+q/9EGG7mrSxyzxcC2usKmQ0QecLzMIf/6+dJMNzA88e+esYum83uRBj/Z3BmM8LiN4DK2Sbpu85jaetKcYiKBNjvCmogn+MEvm9Zjh2Wg3SyGpCDEpGboZJu2XJmNqPZGYMb6euvNG+QTvyxwKC8lNsAomuacMS2B5qYTmN+W37SNi38CRfbodMurHkSTY8VXmezJOqvEdkCDvd8kFf3hPJLso6gjzL9NHxyVUV/V/S+OohAicEzRdA+KWxZvZCqnQDI6+lQMoEAEeQbwaEvpO1n4e1Ya1GBQqCnti8W0dS8l2Lm5rRSHmrNqJmZk71Rl2wlLM4ZL7fDHyEfZKaVZRIBS9NoPhEiMlmPVWWc+Gt30a2C/VyjnfPcUgQjRCpMbpXAzIP6SsOERZBIDD38boxCaz04iyUIrHNv8mNAHjN5XrmLGBVI0KTBQH8hL4esx2iqLObNeia5TJr8XYrp5erL+FZ/M9hZGZvfoIJQ4rVI2Wpd8n85bL1e2XiJZgB5zwL6elNcdO3hJitpSA2K0SnxaFmNxHgtBqsyfNaeT9RzUZdZLlV7xYskXpMkS568sJxYGM5DnyXi47r1yKsolOK1bThwXCBN14wdVm33y9fr5OlRvyFdX424Vi/w5IgyL7hYJVyoBwdseD0203jagD72av4Brl+p7ivSjkpDNpNeQpd8JrTo4IxNZ3bQCm29DAjrL1SY0jhxvaGiTSrqkFM5aZ3ERf+sl5ClgPLtbf12MuxuS9T6YtJF2FKYv6nw5d/WzpSUsr7gZ3xDMDAZ05K0jsuZQ/4S/ZuQc+NjrlE8HEiVM5Gy
 ue5p+1pX
 B/LvsFsxI7apNbYWCLqoNjACMDgsOgKA54EP8Na4DT1xVQlAxFJgzLa6k0+wCGEQOD+kGkybDnVl0vrxq+E98GffPw07IQlybqC7QolPERzzg6BySL6FDmMDwcpGOm54d1VdpI4Z2z6tjGSTazNMmyXSX4tUbm8cw9DS4guUguS0jHduHWzxT8l9bfZ79nkZJsiI/MLJolJF56IvDh/wQcMgukFTWckUkN+BT/WYisu6+HcBw301dINh+2u6RPbZ3WqHHYwtsN86ty39KmQGP6bHTaMU4Mi24xAB4kS6bQWPAUiJ+8iXgLaxYz5GiT7SpU8UEuZZqGq/iTTTfIjoRI+Y/PuXCHpBkZHxSltb027sJfiYkV2jgydN1Tc6F66rUdTrjON7FCP0B7apK9zLnhsWk/KhmS57/8sKAkW3FQDVET1X7cHZ0VwlhojGKsaQ+j6Ek2gYUEz0k96W5Ndu/E9P4IaIjUiOiz5dm4sLiG633NgfjdM1DroQ+9WGAOiOv0eIwVvgJyTGdplCGfSMNtoEQKtodbe+DukzJwyPPp9c7stNSYKclIFDfE1x/RJi4e9WM8R1+eS7XF3ji6F4pyfyfyVTC4SVYv3PwFvK6d140xLjopHrDVlhMx7XhWd7MsSE3VFjmNDb3/frMj6tKd/KLcBwGZB6DeIZm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The '__counted_by' and '__counted_by_ptr' attributes associate a
flexible array member or pointer member with a struct field that holds
its element count. Supporting compilers use these annotations to
compute dynamic object sizes via '__builtin_dynamic_object_size()' and
perform runtime bounds checking with KASAN.

Add KUnit tests ('counted_by_flex_oob_access' and
'counted_by_ptr_oob_access', guarded by CONFIG_CC_HAS_COUNTED_BY and
CONFIG_CC_HAS_COUNTED_BY_PTR respectively) to verify that:

 - '__builtin_dynamic_object_size()' returns the expected byte size for
   annotated flexible array and pointer members.
 - KASAN detects out-of-bounds read and write accesses beyond the
   annotated count.

Allocate the test structures in 'noinline' helpers and hide the
returned pointers with OPTIMIZER_HIDE_VAR() so allocation-size
attributes and compiler optimizations do not mask the '__counted_by'
and '__counted_by_ptr' checks.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 mm/kasan/kasan_test_c.c | 100 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be3..f481183c84f1 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -2201,6 +2201,100 @@ static void copy_user_test_oob(struct kunit *test)
 		unused = strncpy_from_user(kmem, usermem, size + 1));
 }
 
+#ifdef CONFIG_CC_HAS_COUNTED_BY
+struct counted_by_flex_struct {
+	size_t size;
+	int array[] __counted_by(size);
+};
+
+/*
+ * Allocate the struct out-of-line to prevent inherent attributes from
+ * affecting the '__builtin_dynamic_object_size' check.
+ */
+static noinline struct counted_by_flex_struct *
+alloc_counted_by_flex_struct(struct kunit *test, size_t size)
+{
+	struct counted_by_flex_struct *s;
+
+	s = kzalloc(sizeof(struct counted_by_flex_struct) +
+		    size * sizeof(s->array[0]), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
+
+	s->size = size;
+	return s;
+}
+
+static void counted_by_flex_oob_access(struct kunit *test)
+{
+	size_t size = 128;
+	struct counted_by_flex_struct *s;
+
+	s = alloc_counted_by_flex_struct(test, size);
+
+	OPTIMIZER_HIDE_VAR(s);
+
+	/* __builtin_dynamic_object_size() should return the correct length. */
+	KUNIT_EXPECT_EQ(test, size * sizeof(s->array[0]),
+			__builtin_dynamic_object_size(s->array, 0));
+
+	/* Out-of-bounds assignment. */
+	KUNIT_EXPECT_KASAN_FAIL(test, s->array[size + 1] = 42);
+
+	/* Out-of-bounds read. */
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, s->array[0] = s->array[size + 13]);
+
+	kfree(s);
+}
+
+#ifdef CONFIG_CC_HAS_COUNTED_BY_PTR
+struct counted_by_ptr_struct {
+	char *ptr __counted_by_ptr(size);
+	size_t size;
+};
+
+/*
+ * Allocate the struct out-of-line to prevent inherent attributes from
+ * affecting the '__builtin_dynamic_object_size' check.
+ */
+static noinline struct counted_by_ptr_struct *
+alloc_counted_by_ptr_struct(struct kunit *test, size_t size)
+{
+	struct counted_by_ptr_struct *s;
+
+	s = kmalloc_obj(struct counted_by_ptr_struct);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
+
+	s->size = size;
+	s->ptr = kzalloc(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s->ptr);
+
+	return s;
+}
+
+static void counted_by_ptr_oob_access(struct kunit *test)
+{
+	size_t size = 128;
+	struct counted_by_ptr_struct *s;
+
+	s = alloc_counted_by_ptr_struct(test, size);
+
+	OPTIMIZER_HIDE_VAR(s);
+
+	/* __builtin_dynamic_object_size() should return the correct length. */
+	KUNIT_EXPECT_EQ(test, size, __builtin_dynamic_object_size(s->ptr, 0));
+
+	/* Out-of-bounds assignment. */
+	KUNIT_EXPECT_KASAN_FAIL(test, s->ptr[size + 1] = 42);
+
+	/* Out-of-bounds read. */
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, s->ptr[0] = s->ptr[size + 13]);
+
+	kfree(s->ptr);
+	kfree(s);
+}
+#endif /* CONFIG_CC_HAS_COUNTED_BY_PTR */
+#endif /* CONFIG_CC_HAS_COUNTED_BY */
+
 static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmalloc_oob_right),
 	KUNIT_CASE(kmalloc_oob_left),
@@ -2280,6 +2374,12 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 #endif
 	KUNIT_CASE(rust_uaf),
 	KUNIT_CASE(copy_user_test_oob),
+#ifdef CONFIG_CC_HAS_COUNTED_BY
+	KUNIT_CASE(counted_by_flex_oob_access),
+#ifdef CONFIG_CC_HAS_COUNTED_BY_PTR
+	KUNIT_CASE(counted_by_ptr_oob_access),
+#endif /* CONFIG_CC_HAS_COUNTED_BY_PTR */
+#endif /* CONFIG_CC_HAS_COUNTED_BY */
 	{}
 };
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


