Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D932606F2CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=iY7TEU92
Received: by kanga.kvack.org (Postfix)
	id 4969B6B05DC; Fri, 13 Nov 2026 13:57:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447EC6B05DD; Fri, 13 Nov 2026 13:57:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F046B05DF; Fri, 13 Nov 2026 13:57:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F06446B05DC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D80DA1A0249
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:20 +0000 (UTC)
X-FDA: 85431003840.13.6DB6E0C
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id F02FB40008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=iY7TEU92
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596239;
	b=ksBxEhtXELYrNp8P7VInHwdIq+BAFQAxmvMy7+CXmGXNo9V2m5cDmhovhvOIp1GaYlcHwA
	5eitmEWfKd1eQVSovHQtSWXInGKw6d5rxcCiRiO8dOrCZvIiJ3Y5XRmWdDxW4lZMtS7qZL
	c5uMMAzB9oKsgxcySHH17ei8dvk8jr4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=iY7TEU92;
	spf=none (imf07.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.41) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKLsDxKgeNyTR2N6X6bMkhCfSN7v5jMUZuKftv1qAXY=;
	b=XiFgdMrjG0n3TFbgv5Z5k1sUFKsKsip9Bc6DTVU19/m4iqjxmcuyP3RlOYFi0jii/0If6O
	tiGBbVJNrHLXYreWrXbZEsAB4dw03I4meE+RLGQaktm8zt4OnCDPaW5rgm9PuZgeXTEJLe
	7jA/6n5iSsInwHvYT2opZPLj5daufl4=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-49a92144733so530440f8f.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596238; x=1795201038; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OKLsDxKgeNyTR2N6X6bMkhCfSN7v5jMUZuKftv1qAXY=;
        b=iY7TEU923zwZSr7/lMTFSJCybbns/pwMHp1pZV+2hnEiE6zArktv0gpYLNSPu54E9E
         YqR8M2q471ZW9NxJWI++SnUP5jaY5/XnKG3NN8TaCFoo0ZXNqTGtm4Ze8iOIefXgDMyS
         xdeUrbkGA1HhIhwEjIOTvZFLue75gbHOb/6TxHl1J+khf1OgVDWegt47FfTVQad/hJks
         DR2XYAMw6Isdd7eu5eLrTzY2CgYvGZtzxLlfQPZOZPWsySdctN8yiKxBvS/gFRkP72Jv
         Z8noxKmoTjisZFkVdYrI0PUnviRuVUMV3B4M3Re2JTsq69E5+/GcnXdGu1VgLf2LuAGl
         k6+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596238; x=1795201038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OKLsDxKgeNyTR2N6X6bMkhCfSN7v5jMUZuKftv1qAXY=;
        b=r2nQcwvTwyhP+YT5YrQ5sK+VP8u8WKWF3l+Hq0z6LM/kbeVsX81YAPA+gaywdI2n8W
         wvSuQG2OqoAdZX+fb1SmpUj8UjqEHta8V2ROQQmW1MZ9lwe0HVDBh6BrtS3SBkzzFYUd
         kyrVsKbCPRjitkWETpWh4qKANfolFoyCRjvnG5dQOZimYwIfqc32NNiDJS4Pxq8PC2CK
         kZky2I3/vskuBkBqzBXVixUh7S6Xzv5o5ABBDQXLvNeARsq29g3n7Cg82Yy8qgeYWV17
         I7sALPVBZltzNBSe5Mq/CZ1He07S+nIezYIDjsxFlhIQDBRGWMYrIW/fJzy/mj7Fhtxi
         lYqA==
X-Forwarded-Encrypted: i=1; AL+hErFfqdVaqAsqitxdZTJ+OR2D0MwsbeHRfmGIUklj5n3CqduxC96xPeXxWykv/FDAYNvPPDOtPxzX5w==@kvack.org
X-Gm-Message-State: APuU4Z/6Ushl4HYVXqNbccHwnssPlmy7fuDlAEl98Wp4lU2mgOwAByjy
	NrimThJI+zf7nhTtiw+XLa7fmCcKGWLb5T80muukaA5/wNq9oguBcK07iAbUZiUxrVk=
X-Gm-Gg: AYBFou15gaArpk5lfq7iXHZd36lrZd612/ISfR6uPIzNycyXl0DPG9sBP5NRRmUF/Bo
	mIsqZMsuTvjhyh/GEx4b2NE9jLGFhs2UwSUVQKadyveALmfTonsbF2X7XBEuf5fmAeHmgMhas2l
	oOWVP/F0D8jBfkyY1XAsegvlezGIqhgTN986f+g1MGbDm7QKa5NH1tqEJd3Ro4Dw/CjgiG7B4CR
	TGzj+TfjohmNGU5SZsgv1p5+Ud6QOTxHWNFqXol00Z3w3mg57IGVO7jlgWD2UnJ861m9RktE8Zy
	IOF0HuM2yRzeeqUU7pjCKCHl+mmLO2YJ1SnPpM15+mVTSS+XUTnvl++KFCUZP9mRzKUHER2ReIA
	qGcxDRLR7ObPI7Nmtp/RZVi2aiFJPFpIR6PfnoxoQExvKnbmSaecmZT55yx0EPvMhyl8vG0+uYK
	+QLQIo9N7XTlQhlomsnJPrW4yhdUClSB9bMe7gBxbhEXfQbv362rrKx5Blq7M/GNMZr3ZZZL3+k
	NLkHkp+X/guTejRBirUZDIv3atgAqV/bDGpR0GdvGTGqWuutibUctAxVqrvoVZZS0z8wp25/Fgq
	42kXJweZSyAKuVU9a0sFssLy3XUjpg==
X-Received: by 2002:a05:6000:430d:b0:48f:bbf3:cf52 with SMTP id ffacd0b85a97d-49c73350e7bmr8591785f8f.52.1794596237596;
        Fri, 13 Nov 2026 10:57:17 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:16 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 07/10] stackdepot: Remove stack_depot_fetch()
Date: Fri, 13 Nov 2026 18:56:59 +0000
Message-ID: <20261113185702.1332171-8-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u46re7xqg7xtry7zmt64z5fpms9xirmp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F02FB40008
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596238-646870
X-HE-Meta: U2FsdGVkX18O5JvoE4dSO0CccUxZ8xwOcrZhJvOKwhkKwQ3jCM24xPkkICmaZr6KL4MDfcLA9dmh4/y3p+zFiBjA9ZHZm9UpyLBf3AoOb5yxu7QLUXkg6BnXgqg2ztYShWBpazF4uc0wH1DpGVn354O2jpO7R2FsHK7S6tuSW8R4GDh2C4Lq12GnMYK19zygLOH2QAh2YySf9PfvDqNeYzUzWixQkVleMLLKO0gGf7PPF+W3i5TjiBJ5pGnLg/62zOOl7LZcMjLq6bFzN1G7qeBFnKyiSuUTb1KvfEHfCV9ZnTtivOj+v8duf2wpSMgsaSCl7MKjhN6dBlvgvW7E0/+tt6ZzXcUgnMaC6SKmbSDW/OU74Nis1qMGEboR2kmSbIEFXp2F8vN/wVDAUqUZuXP25bbh7WmwJO8DvzbEqxevjDgUaJ6Bp1+l+oTrH/HVAiIrRjf5CD29fVKeUX7PWQ1FH0O++VYSbQ2reLvtTNet2kr8SdCk4W6h3ubprmj/jC6Qhex/e2dopELxPJUjSd6gI98y3fbRe1cuLOmK/WL025RPN5PVxx1jGmCoG42YHhWcPmyUl9/cR7bGVkU6xYhcAtuCq3g2U0PWRsW+XHX5dMYHF2sqFcKefih1i+sjJU7jP6bvwseimWQO87e1ih5ydQQgJpjt2B/kUeWn+cnDj6r3DRdDSnyxYyGN1yr/OjJcdl3PfMsgbhvWXZdeBUSvlQQafLVUjYqwKVe4eMq5jrfmdEl+J/XP0DhV8xXqHIrhw/BUf1XBV6Gd1ov8kUlTOIBxNu0cu7ek/N5INmJ9zsFSDSAXyjuAfKkiQYOljGz4jQ0HncXhpGAnKIgdWUBXQDlG3umaveWBsPt7fRUALyXgF1UMqW7TYXxcNJKdDUqn2ItChxdR63M4dW52pH2mMLOb1P4iNZHnMw3kcvz7U40GP6wHQNHEVMV0WcucNcXl8TTMRg7IadXO3qX
 /zslZu2l
 qSIKNzFZeQj3KcCk4ZWZjBJdDCnSIyeJd2pUHOiorMAZeKjxe/vOrEvclla0py/ALcgTyhIClFIGsBLmO/jrSJzi6DRhrBgdQR0jAHu/vjaj9XlVkZIJ6nLTLNiCvZOnnCuuiJB8DAilFyI0XoMW6p3LN7PmD1wHadFXFm/YaxN7BsZYdvShs92ewlzZCK7gq8xIPx45h+K+lBpCHgUMD0cEm47e0MA39riG93LmrntKe6Abuu8ByRxjlaF5pjq7Tm8ifGSbTLsXm3Nx6FZBChZ/vERnU5i3y/2Noyv66wZyQ3DFEiIsEIeXwR1Z5fr94950SQjYQjK7aHiV1UN7HBmjIMx2axcA6u/NxjqIcAFQ9gcIZEXUp7ZP3Uncpa1pzOSkK2TOPCSwn7TsxMbDCZIyvWhAnsbBaWx3YVJPL1xmmtQDsIb0K4fi8V4x1WmvbcyvG
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


