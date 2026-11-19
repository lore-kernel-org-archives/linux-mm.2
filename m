Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C3760A2621
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KQs9VQw3
Received: by kanga.kvack.org (Postfix)
	id B18416B068E; Thu, 19 Nov 2026 10:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9366B068F; Thu, 19 Nov 2026 10:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFC16B0690; Thu, 19 Nov 2026 10:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE4E6B068E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E02D840AE3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:14 +0000 (UTC)
X-FDA: 85452259788.01.E4114A0
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E90A4001A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=KQs9VQw3
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKLsDxKgeNyTR2N6X6bMkhCfSN7v5jMUZuKftv1qAXY=;
	b=LGjZYrent8UMQywW6vohvdyRsBvQ4gzLtpbLIOIqkFREoPtPuccutUKIa96rLtt3X/iCt3
	RiEs5z65UvGLTUVPU1ZQnnRbyedkogLFHzhEpA/jEvwSJ3QH28frm3SDp4WANm6h7u/809
	oiDl5A5G6CetWLdytdHEaVk4ykq9oFo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=KQs9VQw3;
	dmarc=none;
	spf=none (imf04.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.208.41) smtp.mailfrom=matt@readmodwrite.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102333;
	b=LqQ3X0bHD8WA76vKdfR4nGKPgQtFdzszKfLfGSkscP/pnGWavNItKhrmPb1DI8A9KZWmqy
	rMgSkoHNXHuBIDSuyifF8eucUa20/h4TcT/o/zCIN5F2Fkl2Sm8Lt/GcGU2fe3szcp5Z6L
	YfzOmvOWueHQXPbRkjA7d65okpMkBhU=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so3097141a12.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102331; x=1795707131; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OKLsDxKgeNyTR2N6X6bMkhCfSN7v5jMUZuKftv1qAXY=;
        b=KQs9VQw3eI/j+IG5uJgmtDB+2nW7Zhy3VYPuv6a96Z1Rku6r3jWdBECFrKLTA7zqa0
         +N8S/1n07yzVGXCrPiSAS3Z+h0iTVK2xZ0ZNiZVwSwracPTpvPGu4qMEVoWVktOZaZVE
         Oh8l9lXnSUDt+Ae823HkuiwQr28k7eFRUMIH4RqYPE6b2IGrg7w+AhTjYsWQjDhvegL1
         8ReFH9YY8ogxt1K2feG0fAp102ppk1dEYTGgoDeHStyb8fQbFvzznsjf0a/6CQBUuOWj
         fIWgvn9wOk37wXhfUKwbCvXnnsLpPwFoBZyWTGqUWcBJe8QlQ8kRixHBDM00uhcGG++g
         QlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102331; x=1795707131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OKLsDxKgeNyTR2N6X6bMkhCfSN7v5jMUZuKftv1qAXY=;
        b=Cr1Q8MOvuwQIQsQYU3NlMzVop9jADRdm1EyePcnllurhFlNFTa6h0TzCNe+hxASXiv
         XHHleoouP1ooT12ujPsANMWXYXKIa4QBO9Kwzwt1GuWGxcxx5n71oDP8oD5zvhOhWDIT
         EX3bNn5VUl0XDGw4PMzX/i8RqDI4WnMRfpW/QNcFweP7PmpCoqp6Kg2r+/Bds4guVxx3
         pFJ/7N2pZqPWD3+mV7Amj0lOrsa51LWLNJ292tdJbIkeX1iWyZvywZ434G7sat/KTQ/6
         RbQPQDY2Op20+QiXt5+SP6dExgWpcXvdTJVsv8Hroj7VCaeBxmHwa36lMl2phrkB01Ae
         pxAQ==
X-Forwarded-Encrypted: i=1; AL+hErEjrzaJUeVhO7RnwWL+bhA6YxWIwBe/FGjnsufA4DAXEI8Ei2pZhTgwnYU+xeSxDoZYT98j9dsYSA==@kvack.org
X-Gm-Message-State: APuU4Z8M9A6PMjScq4HLR30Z2cewyHeKEtkwOPOdx/qJiUzXJDimRgMK
	tg9jJQlVl3MuVR05y9GYZEGn0olkNTNlVuJw4T0IxYUwB5hRxTDHuu5YKACth6QXQHc=
X-Gm-Gg: AYBFou2s2YlzKzSbChHoR1oQx2AgsSdbNaT/GU+sy6pI3tuSYYUdVUQ9kkH5oW14eGL
	W9maXmXrPJV932QBbC9lHETJsVJ32EdTYv6bYX2tCu+qVbAtjupfYEYeuRXGg0RD/a+9tVxvoi8
	oyfPurm984Yl+pwM74caiqHctcxGzten7s5BPg/PJMidGruTHfXLI2jtKIPF1+4VhsogbyCABiK
	yDXctjZH72gwcdlS/96oykcDxNuzIwid4bLJd5A1525KOpNclzMalvNkLCy7W5tSy1VeAv+jr4U
	h3gW3l4u8Uw0PTBgeQoNqJ+EVjWZ+ziYuLhxFhM3LF+4RTHZ3OXdRDo/tx6JoUe+lA5qt8UtfQz
	/vnFeCw21ppqPw1EZdbEOsuVtk3rKKxRr0vZM0fPffy3Ygbhk2WLH3ISosSEet0gscOrfnkdg46
	UHCTBzFrlZpyC9rq2+s5de6tK2xCHFzOJItQjr5stIGveCuU++JYeY8tfjsQOBSAUx9QOgLtUch
	9DUpdYcw7vSk3BNBrx7TZON+7rvBU2Tq6hZPd/hz0twRDUfa/Vo7o0g2003NO7BzsuGUy2/cnTG
	IBqSgDLvMQzzEVAW+NqVJ+bMxg0nUHXM0HDWv1jmeUHbrjCBNYB1
X-Received: by 2002:a05:6402:1d4c:b0:6b9:c43e:19df with SMTP id 4fb4d7f45d1cf-6b9c43e2326mr2926798a12.41.1795102331068;
        Thu, 19 Nov 2026 07:32:11 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:10 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 07/10] stackdepot: Remove stack_depot_fetch()
Date: Thu, 19 Nov 2026 15:31:40 +0000
Message-ID: <20261119153143.4099483-8-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E90A4001A
X-Stat-Signature: s8roxj9mjg9u54761no8o394qzt4xafp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795102332-899749
X-HE-Meta: U2FsdGVkX18tQPADoFBy5yG3IftkADcAV3hyO3PhznW2Qi6/XxCfZPYi+hIEEkTdZaYgUdOm5Gx88njqwesAe1AfPKf9e5U7AoXMLt0ooV6SvOZlzvZSxDQxdgThvHbCNtiObnZnzzsBu/+gKHvUlA183wzcPV+8xWRsiyeongkuOONVZln0KvpfRpSTV08ulXi3OCIeS9N8C1PPg7unC8a7IGVd7n1khuoPRvbd7z5HwaEDpCeBw982BCDNmowOzJ+sUZ0/yZudyNfOYWZlhHXnGzf1qle8uPP25hxO7qSkA3/oYsURPHLHoIrCy6/WVuJ3mVq7XEhZOrcztt6DBQi54Kw3cvhzXC0MJoA9AnKvUK8xRQACyiu/LNYBW4twrm2L3puo10UvvprWjbWTz02Vn3nMfRcDN2aSVwJjXA3TzdZ6MMTPnRkzNjhgJedhShbQAc8wI3jjBjRYWmFfyl7KOgb3+ByFM5fMQbL+ubuFLHZ4DdsO4fuq/1p3gHkQU1RPGQGDnt/JNyu2Qwx5umhrGZWJPOmArwLyyyHjXbVz5Tlk5yoqoq4Jij7Ky9P9DE0NgImXkn5SiB5UWvPv+6kIQ+v7wFoj9JCiRE7zKFkTexq1YycOfhi991XPXgL1H/F5Z4o0EK6T3i+Yv/hkzISJKphSHO8nJMrUwH8Nfl+sLLjn0jXGby4jwlwM1Hf/x7DvgxeiDhnySaqVYTQ0Gjb40SA9kGydwo64673lO+UYsCAR7rlmDHCtKJFLknGhXS/SYUImuwwp7ks2eEHmMWDCwXy5CjOW/80hdfAULzR8HpzYWkPydeRdsJ9kGxNi7oKK3w5ZmcY5zyhUEhML72i795pqG3VwKpTaMRq6s9T72n5dmx8nvnkhu4XJujltLJdZq2iCCtQYoEdjLa7zzykP+9QjQPv8ilvGb3cZJzkKFRjeG8Ztabfh94fWFQV4DAcKWbUCFnKZeh1lZ9G
 SACWYt+k
 9e5Gp0Q7OlMh2YwFcnXguG25o5IEbujR/TH4BPhHSdULXZqleiLETV2dJpZzDszzJW54XohvahcZk+5IY3HWDVgtsNu/FmJz3pPNN1KxK9RT3upenXVKAWBGsczzmTg8JaNcx1tRo6NFRvKfEK97/NMz0QwcnKOUmQSIhIgLVMp0ede/Q7JOV4y5ijCl79AJGXAuEl8S6d8pp/AhHAHwYlGcIhNrRWCEudtmVBKCpVGbBT0tFLOy/X+hP3DGyH2AkrZGSeOo5FEt9xf7G2oOteJQEEH3Ie3AcygcDeufBC3ebx9vD6HK1wCs4FMj1NJmC1Rs2Bb404k8u5DE6SUwwQw0XW7MF0kjsJtXyJLp9WLxWPYhcVlWSlDzovCUqmCiOnk4A3q7exm1kNj0wytcn8CD2oNfhNxGJsyx9nDwGJqe44NNThpvch5Y6MlpB7xVkFJZa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matt Fleming <mfleming@cloudflare.com>

All callers now use stack_depot_fetch_into(), stack_depot_print() or
stack_depot_snprint(). stack_depot_fetch() hands out a pointer into
depot storage, which leaks how frames are stored internally by
stackdepot. This will be undesirable when compressed frame support
lands in a later patch.

Add a KUnit test that stack_depot_snprint() output and return value
match stack_trace_snprint(), including truncation.

Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 include/linux/stackdepot.h   | 11 ------
 lib/stackdepot.c             | 68 ++++++++++++++++--------------------
 lib/tests/stackdepot_kunit.c | 36 +++++++++++++++++++
 3 files changed, 66 insertions(+), 49 deletions(-)

diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index 734529767c8a..dcc2e1d21f92 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -188,17 +188,6 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
  */
 struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle);
 
-/**
- * stack_depot_fetch - Fetch a stack trace from stack depot
- *
- * @handle:	Stack depot handle returned from stack_depot_save()
- * @entries:	Pointer to store the address of the stack trace
- *
- * Return: Number of frames for the fetched stack
- */
-unsigned int stack_depot_fetch(depot_stack_handle_t handle,
-			       unsigned long **entries);
-
 /**
  * stack_depot_fetch_into - Fetch a stack trace into caller-owned storage
  *
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 556f3ecdcc8f..8f1aaa0c6d88 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -757,33 +757,14 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
 	return depot_fetch_stack(handle);
 }
 
-unsigned int stack_depot_fetch(depot_stack_handle_t handle,
-			       unsigned long **entries)
+/* Copy the first @nr_entries frames of @stack into @entries. */
+static void depot_copy_entries(const struct stack_record *stack,
+			       unsigned long *entries, unsigned int nr_entries)
 {
-	struct stack_record *stack;
-
-	*entries = NULL;
-	/*
-	 * Let KMSAN know *entries is initialized. This shall prevent false
-	 * positive reports if instrumented code accesses it.
-	 */
-	kmsan_unpoison_memory(entries, sizeof(*entries));
-
-	if (!handle || stack_depot_disabled)
-		return 0;
-
-	stack = depot_fetch_stack(handle);
-	/*
-	 * Should never be NULL, otherwise this is a use-after-put (or just a
-	 * corrupt handle).
-	 */
-	if (WARN(!stack, "corrupt handle or use after stack_depot_put()"))
-		return 0;
-
-	*entries = stack->entries;
-	return stack->size;
+	memcpy(entries, stack->entries, nr_entries * sizeof(*entries));
+	/* stackdepot.c is not instrumented; tell KMSAN the copy is initialized. */
+	kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
 }
-EXPORT_SYMBOL_GPL(stack_depot_fetch);
 
 unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
 				    unsigned long *entries,
@@ -808,12 +789,27 @@ unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
 	if (nr_entries > max_entries)
 		return 0;
 
-	memcpy(entries, stack->entries, nr_entries * sizeof(*entries));
-	kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
+	depot_copy_entries(stack, entries, nr_entries);
 	return nr_entries;
 }
 EXPORT_SYMBOL_GPL(stack_depot_fetch_into);
 
+static struct stack_record *depot_print_fetch(depot_stack_handle_t handle)
+{
+	struct stack_record *stack;
+
+	if (!handle || stack_depot_disabled)
+		return NULL;
+
+	stack = depot_fetch_stack(handle);
+	/*
+	 * Should never be NULL, otherwise this is a use-after-put (or just a
+	 * corrupt handle).
+	 */
+	WARN(!stack, "corrupt handle or use after stack_depot_put()");
+	return stack;
+}
+
 void stack_depot_put(depot_stack_handle_t handle)
 {
 	struct stack_record *stack;
@@ -834,26 +830,22 @@ void stack_depot_put(depot_stack_handle_t handle)
 }
 EXPORT_SYMBOL_GPL(stack_depot_put);
 
-void stack_depot_print(depot_stack_handle_t stack)
+void stack_depot_print(depot_stack_handle_t handle)
 {
-	unsigned long *entries;
-	unsigned int nr_entries;
+	struct stack_record *stack = depot_print_fetch(handle);
 
-	nr_entries = stack_depot_fetch(stack, &entries);
-	if (nr_entries > 0)
-		stack_trace_print(entries, nr_entries, 0);
+	if (stack)
+		stack_trace_print(stack->entries, stack->size, 0);
 }
 EXPORT_SYMBOL_GPL(stack_depot_print);
 
 int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
 		       int spaces)
 {
-	unsigned long *entries;
-	unsigned int nr_entries;
+	struct stack_record *stack = depot_print_fetch(handle);
 
-	nr_entries = stack_depot_fetch(handle, &entries);
-	return nr_entries ? stack_trace_snprint(buf, size, entries, nr_entries,
-						spaces) : 0;
+	return stack ? stack_trace_snprint(buf, size, stack->entries,
+					   stack->size, spaces) : 0;
 }
 EXPORT_SYMBOL_GPL(stack_depot_snprint);
 
diff --git a/lib/tests/stackdepot_kunit.c b/lib/tests/stackdepot_kunit.c
index b0c44c096976..ae4f7661a48f 100644
--- a/lib/tests/stackdepot_kunit.c
+++ b/lib/tests/stackdepot_kunit.c
@@ -3,6 +3,8 @@
 #include <kunit/test.h>
 #include <linux/array_size.h>
 #include <linux/gfp.h>
+#include <linux/minmax.h>
+#include <linux/stacktrace.h>
 #include <linux/stackdepot.h>
 #include <linux/string.h>
 
@@ -71,9 +73,43 @@ static void stackdepot_fetch_into_rejects_missing_or_short_stack(struct kunit *t
 	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
 }
 
+/* stack_depot_snprint() must match stack_trace_snprint(), with truncation. */
+static void stackdepot_snprint_matches_stack_trace(struct kunit *test)
+{
+	const unsigned int nr = min(40, CONFIG_STACKDEPOT_MAX_FRAMES);
+	const size_t size = 4096;
+	unsigned long entries[40];
+	depot_stack_handle_t handle;
+	char *got, *want;
+	unsigned int i;
+
+	for (i = 0; i < nr; i++)
+		entries[i] = 0x301000UL + 0x1000UL * i;
+	got = kunit_kzalloc(test, size, GFP_KERNEL);
+	want = kunit_kzalloc(test, size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, got);
+	KUNIT_ASSERT_NOT_NULL(test, want);
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+	handle = stack_depot_save(entries, nr, GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+
+	KUNIT_EXPECT_EQ(test, stack_depot_snprint(handle, got, size, 2),
+			stack_trace_snprint(want, size, entries, nr, 2));
+	KUNIT_EXPECT_STREQ(test, got, want);
+
+	/* Truncate part-way through the trace. */
+	memset(got, 0, size);
+	memset(want, 0, size);
+	KUNIT_EXPECT_EQ(test, stack_depot_snprint(handle, got, 700, 0),
+			stack_trace_snprint(want, 700, entries, nr, 0));
+	KUNIT_EXPECT_STREQ(test, got, want);
+}
+
 static struct kunit_case stackdepot_test_cases[] = {
 	KUNIT_CASE(stackdepot_fetch_into_roundtrip),
 	KUNIT_CASE(stackdepot_fetch_into_rejects_missing_or_short_stack),
+	KUNIT_CASE(stackdepot_snprint_matches_stack_trace),
 	{}
 };
 
-- 
2.43.0


