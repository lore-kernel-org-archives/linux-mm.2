Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F995CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6526A6B008C; Tue, 29 Sep 2026 03:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB366B0096; Tue, 29 Sep 2026 03:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47FD76B0098; Tue, 29 Sep 2026 03:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C88C6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:20:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6ABEE40442
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:20:21 +0000 (UTC)
X-FDA: 85265951442.23.78754F0
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id A95D640011
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:20:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mDbXSF52;
	spf=pass (imf17.hostedemail.com: domain of 3sWa7agUKCMg025p2u22uzs.q20zw18B-00y9oqy.25u@flex--morbo.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3sWa7agUKCMg025p2u22uzs.q20zw18B-00y9oqy.25u@flex--morbo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790666419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWPIKm0R00qZrqpqFbbPuyKWkI2RzsxoZ6cWRG3D+E8=;
	b=klnyS7Tq+mo7oiMnuMwdzgKpAjrmvoHFCG13ZDAlecIomnG7IiAOPpLzAbEXsFQ77qpz1i
	LAwaAnWvn99CQWWm+BBY/JzX3tNsNWSkx+RI0XTZ1XG3IZ55iN/0tQ1poizil1ahQNNR3F
	+v0sb34SC3dT3RvDgt5R69EY4zLteK0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mDbXSF52;
	spf=pass (imf17.hostedemail.com: domain of 3sWa7agUKCMg025p2u22uzs.q20zw18B-00y9oqy.25u@flex--morbo.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3sWa7agUKCMg025p2u22uzs.q20zw18B-00y9oqy.25u@flex--morbo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790666419;
	b=tmM/0izijtcptv2FA05Xfh7s3T4M6C6wqKapo/MiP05PvIBoHc52JC14OmzpdXcwbnotHn
	3pFlw4gr9/DxJ3kunpzva69+UTOlx4ee6qjsRGTCCG/t292kf8gR7K7+u3cJ4qKgzI5/AA
	7L7OfxjEWn+XS2qWA60Zzq8w3iH6HhU=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-86917d18880so2927560b3a.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790666418; x=1791271218; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NWPIKm0R00qZrqpqFbbPuyKWkI2RzsxoZ6cWRG3D+E8=;
        b=mDbXSF529ChUuq4IG3bxM9KfwY12ZuDcBSkbOKjh/ptx7zyw5k1jxhkYYvUMKQCGoe
         iLp7/GcRVwqpv/Ykqn4rRvgL/4h9tFadn4qK6urrUMkUzTQkS1uoFhKj7LloVS6ESBl9
         l3LQdczAFGwZTbJxKx1QAdHALeTfRdgjc5TL0clx7u+wOJ/Pmt0ORw9An4Cva0WnSZ7b
         0j0os9M1PWpLlu4DMSMG4G1uRACvX9R/LiD0p0ZtajlsRMuf49EB4YAskVHcRWDexSL3
         9GAseKHFjglYFeSj4Hb4BTGKHYWPm/DqNyyPT4Nh0FapE7krvrzhse8YiQXQ34Y6QCPg
         U2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790666418; x=1791271218;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NWPIKm0R00qZrqpqFbbPuyKWkI2RzsxoZ6cWRG3D+E8=;
        b=ua1l8fYdOb52unWqJUCt/S0OhGMJN8N7V2lgjaJVKCzPEfjbbXiE1BOwkdoLBKPCUe
         hxyXxQK7wcBa6Jz6i//xhyMDZOiq9kv5pSXvIzQeRbMkqJnchrcjOqiGQC3DusYTd6In
         YIJWjmdph6SQtYNBfmj/F4wdr7O9TUcKzUNw8QefJmXZfdN4HpLpB+F2t4nsbSq2is2P
         kaGDotmnWVCPdt9u+dq56qGl9t40vkLWFmFWH/Vklj343iGNpN2vOyFARGDxNTsUN7Tc
         ZI5CaVbJT+F5S5Y+AlWnGx6YtiA/9JsLIMoe8PZjAe0m05+91HPgqtWbzXC2oBwLB5mo
         /uKA==
X-Forwarded-Encrypted: i=1; AKwUvByTvFVX+HaCZ7a0yu3WAFxKfnPMzMcg37MX/uCWFIlzMiMZ60rSOBFZFMc3TQSKQNMrd7Rjh5BVtA==@kvack.org
X-Gm-Message-State: AFuF++nM7rkdyKguNfZdjJibIN5zgggnnzCjCOxs1ztHCk3Owcqmh2Zi
	5qt4jBUTbQs0CgyPn0hST++WQV+shVKoOhntxyti7mAsivn0+x3R6rJeCL1eUaP4yIc44PBmdsz
	i
X-Received: from pfri23.prod.google.com ([2002:aa7:8d97:0:b0:880:ce97:3519])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4fce:b0:884:db57:2d5c
 with SMTP id d2e1a72fcca58-884db575d22mr2732742b3a.41.1790666417974; Tue, 29
 Sep 2026 00:20:17 -0700 (PDT)
Date: Tue, 29 Sep 2026 07:20:16 +0000
In-Reply-To: <20260929010031.2186255-1-morbo@google.com>
Mime-Version: 1.0
References: <20260929010031.2186255-1-morbo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929072016.2360806-1-morbo@google.com>
Subject: [PATCH v3] fortify: add KUnit tests for __counted_by and __counted_by_ptr
From: Bill Wendling <morbo@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, thomas.weissschuh@linutronix.de, 
	Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A95D640011
X-Rspam-User: 
X-Stat-Signature: 69r35nqhycr3wozb6pktiahcf14iwjzs
X-HE-Tag: 1790666419-515958
X-HE-Meta: U2FsdGVkX1+MkXcoyBpsqQpah4rRvze4WyE48Wv+YAKhw6rz4qw04XTTod8k4Udurvd8X2q8CVG5bp/Zuo0YGxRM1+zKZqqdy9b4D5sSAfMaccU3QKoNKJPZtnse+b1lc+EJ/zN/AQ7Oesyab6vmgOFj5SF1qJa+y8x1kIUlLGkG+WWFdfNS7blIo6yjQg4XHe5oTUFJXmyW8UbZTLLg4+f5w93yxWHCl35rkz1tyeQ4emMKSojsxgRKek5H+/HvQiDnxSnJDNPFCDb0M3/7BM2zeb+dr3sHbrYJxR1OHj3wftUIXYEWodZhPxp+15EjcUWqpiFx+ihmiQGb78dV41AoBLqvUwgjeq6HzElQjSujUloA/lpC+X8DqO2bYT20hv6j+lmlpHdsJBGaw7gD2/TKY6C3zceySrtEEVzsnfq+5AeEkrvBbNPw51JJOmFbQAtvwauYLZzaXEGkuSoODxA2c9G9dSZygN9RjA2gie1mEpMNrDzWiXy28LJ4v6V9F3Y4oKGf9IR6XKesRPD6JrRX1pfJ8o1rFwcBHZz9E+aQowBbJSx+8qDHa4Evucc9Pk94o8f4Vt3iyFuKMbU5ybrBlbM3j0JvsFG1ncGzuTDBJw7S9l6mZwCY00/wHJ2XGE/vwa88jRgVLpNJ74X8A/xgNJrbiny6XSD/YmAaeRNSwjAwyUj1e3fRdqyi/Wzeu9NLx9kUp5mQ4/rgWk4oGOdeSePn7gPB1iT3hiBngMF0xY9wwwjowHgD9NPS6mfZ08N88zC8JT6A1p4tHIRrfj+pdXW4wNo9cCuDxVUYZjDz+anXYZZ/A5NNbOsMvy21pl8XmBCxwgnnV4Z3qkyDCCTAJjnD/HhYD+yyTNEV+vRbVooxEOv+c9aGJhzAJvCKfqlcFb+BFVyy0KAN13Echpcbpti/7mM2Lr9X5T+uKfuFOCqULwL2Ke+qcyE/3IdoihOGxy5mznBHdvfbylO
 RNRuEYm1
 ZGoYCEWAY2mmhErxFB8VRPdjdmVnV+o0O+x6pGGc/IDU8Y2xq3nBHi79ittlAZBFI0kV3SdhSr/B/zfnkuj2XkyWjnYVXcsmRzKxXMhZsF1ZzHBd60kDIwZgpdWAQPE5PNkkek7w8lcuydeCRzBchxDzbKMMfulr0S28LWGNNwmcFfSe1Frv0mwIJNjthR1tRQSHNKJXHlZW3h7wwlpHmSqBnlALeBscvd7vrAuXHFJ6if8VeB7phldpwBt2BBPLWT3hz1qjllyN02XWg+vXLMqnstuuByhnj9ALiQDFmAbeCpgUwqSEsjIvIasohbTPTtnWv39Du9d4YCL31H0hC82+SaMXPnZk1LSxZub/p8rvf797OZ4TBGl06toVFdSAs+zthOg6V0ALv9czfWFyj0EHt/AQpPU1+qsopfe0zebgjmD324PsmGj8hxvP0G6iQQf517SnY2ILeHWP4crf+19uaBQyMhsmmi3DKmSKWhwnsJTtKJ+eZQc+tgGICiZxxyH/Ex+RwgPKbUmnoDaJ8stJrgCj2X8WiFkGF+Ocb3LdvQlIG+OCiyzbDLx3SQ/k2T0iGkSA91ScFSkBDZ7UYQX7Jad+dvC4KUmpKKBGOrGPSLaeEh9lMD4GNdvHW/URK/tCRt/ffqojDe/Zvpf19bPFTrOkXrDSRtlEN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The '__counted_by' and '__counted_by_ptr' attributes associate a
flexible array member or pointer member with a struct field that holds
its element count. Supporting compilers use these annotations to
compute dynamic object sizes via '__builtin_dynamic_object_size()' for
runtime bounds checking with CONFIG_FORTIFY_SOURCE.

Add KUnit tests ('fortify_test_counted_by_flex' and
'fortify_test_counted_by_ptr', guarded by CONFIG_CC_HAS_COUNTED_BY and
CONFIG_CC_HAS_COUNTED_BY_PTR respectively) to verify that:

 - '__builtin_dynamic_object_size()', if available, returns the expected
   logical byte size for annotated flexible array and pointer members.
 - Fortified operations ('memset()' and 'memchr()') succeed within the
   logical bounds and detect out-of-bounds read and write accesses
   beyond the annotated count.

Allocate the test buffers with extra physical capacity (2 * size) in
'noinline' helpers and hide the returned pointers with
OPTIMIZER_HIDE_VAR() so allocation-size attributes, physical slab
bounds, and compiler optimizations do not mask the '__counted_by' and
'__counted_by_ptr' checks.

Signed-off-by: Bill Wendling <morbo@google.com>
---
v3: - Use "IS_ENABLED(CONFIG...)" instead of "#ifdefs". It's a lot cleaner
      and documents better when skipped.
    - Use "kunit_kzalloc" and "struct_size" for the flexible array member.
    - Use KUNIT_EXPECT_BDOS which skips the test if BDOS isn't available.
v2: - Move tests to the 'fortify' KUnit tests. It uses UBSAN, which is
      what gets triggered by 'counted_by'.
---
 lib/tests/fortify_kunit.c | 114 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/lib/tests/fortify_kunit.c b/lib/tests/fortify_kunit.c
index 413cdbf3dc0d..8baf6dc96bab 100644
--- a/lib/tests/fortify_kunit.c
+++ b/lib/tests/fortify_kunit.c
@@ -1011,6 +1011,118 @@ static void fortify_test_kmemdup(struct kunit *test)
 	kfree(copy);
 }
 
+struct counted_by_flex_struct {
+	size_t size;
+	int array[] __counted_by(size);
+};
+
+/*
+ * Allocate the struct out-of-line with extra physical capacity so that
+ * __alloc_size() and physical slab bounds do not mask the __counted_by()
+ * logical bounds check.
+ */
+static noinline struct counted_by_flex_struct *
+alloc_counted_by_flex_struct(struct kunit *test, size_t size)
+{
+	struct counted_by_flex_struct *s;
+
+	s = kunit_kzalloc(test, struct_size(s, array, 2 * size), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
+
+	/* Intentionally fake the size so that we can trigger a trap. */
+	s->size = size;
+	return s;
+}
+
+static void fortify_test_counted_by_flex(struct kunit *test)
+{
+	size_t size = 128;
+	struct counted_by_flex_struct *s;
+	size_t elem_bytes = size * sizeof(s->array[0]);
+
+	if (!IS_ENABLED(CONFIG_CC_HAS_COUNTED_BY))
+		kunit_skip(test, "requires CONFIG_CC_HAS_COUNTED_BY");
+
+	s = alloc_counted_by_flex_struct(test, size);
+
+	OPTIMIZER_HIDE_VAR(s);
+	OPTIMIZER_HIDE_VAR(elem_bytes);
+
+	/* __builtin_dynamic_object_size() should return the logical length. */
+	KUNIT_EXPECT_BDOS(test, s->array, elem_bytes,
+			  "struct counted_by_flex_struct");
+
+	/* Within-bounds write and read succeed. */
+	memset(s->array, 0x42, elem_bytes);
+	KUNIT_EXPECT_EQ(test, fortify_write_overflows, 0);
+	KUNIT_EXPECT_NOT_NULL(test, memchr(s->array, 0x42, elem_bytes));
+	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 0);
+
+	/* Out-of-bounds write and read past logical size are caught. */
+	memset(s->array, 0x42, elem_bytes + 1);
+	KUNIT_EXPECT_EQ(test, fortify_write_overflows, 1);
+	KUNIT_EXPECT_NULL(test, memchr(s->array, 0x42, elem_bytes + 1));
+	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 1);
+}
+
+struct counted_by_ptr_struct {
+	char *ptr __counted_by_ptr(size);
+	size_t size;
+};
+
+/*
+ * Allocate the struct out-of-line with extra physical capacity so that
+ * __alloc_size() and physical slab bounds do not mask the __counted_by_ptr()
+ * logical bounds check.
+ */
+static noinline struct counted_by_ptr_struct *
+alloc_counted_by_ptr_struct(struct kunit *test, size_t size)
+{
+	struct counted_by_ptr_struct *s;
+
+	s = kmalloc_obj(struct counted_by_ptr_struct);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
+
+	/* Intentionally fake the size so that we can trigger a trap. */
+	s->size = size;
+	s->ptr = kzalloc(2 * size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s->ptr);
+
+	return s;
+}
+
+static void fortify_test_counted_by_ptr(struct kunit *test)
+{
+	size_t size = 128;
+	struct counted_by_ptr_struct *s;
+
+	if (!IS_ENABLED(CONFIG_CC_HAS_COUNTED_BY_PTR))
+		kunit_skip(test, "requires CONFIG_CC_HAS_COUNTED_BY_PTR");
+
+	s = alloc_counted_by_ptr_struct(test, size);
+
+	OPTIMIZER_HIDE_VAR(s);
+	OPTIMIZER_HIDE_VAR(size);
+
+	/* __builtin_dynamic_object_size() should return the logical length. */
+	KUNIT_EXPECT_BDOS(test, s->ptr, size, "struct counted_by_ptr_struct");
+
+	/* Within-bounds write and read succeed. */
+	memset(s->ptr, 0x42, size);
+	KUNIT_EXPECT_EQ(test, fortify_write_overflows, 0);
+	KUNIT_EXPECT_NOT_NULL(test, memchr(s->ptr, 0x42, size));
+	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 0);
+
+	/* Out-of-bounds write and read past logical size are caught. */
+	memset(s->ptr, 0x42, size + 1);
+	KUNIT_EXPECT_EQ(test, fortify_write_overflows, 1);
+	KUNIT_EXPECT_NULL(test, memchr(s->ptr, 0x42, size + 1));
+	KUNIT_EXPECT_EQ(test, fortify_read_overflows, 1);
+
+	kfree(s->ptr);
+	kfree(s);
+}
+
 static int fortify_test_init(struct kunit *test)
 {
 	if (!IS_ENABLED(CONFIG_FORTIFY_SOURCE))
@@ -1054,6 +1166,8 @@ static struct kunit_case fortify_test_cases[] = {
 	KUNIT_CASE(fortify_test_memchr_inv),
 	KUNIT_CASE(fortify_test_memcmp),
 	KUNIT_CASE(fortify_test_kmemdup),
+	KUNIT_CASE(fortify_test_counted_by_flex),
+	KUNIT_CASE(fortify_test_counted_by_ptr),
 	{}
 };
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


