Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65532CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB476B0088; Mon, 28 Sep 2026 21:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B9A6B008A; Mon, 28 Sep 2026 21:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A1E6B0096; Mon, 28 Sep 2026 21:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE4D06B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:00:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62C0B1C2993
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:00:37 +0000 (UTC)
X-FDA: 85264994514.03.ADFB4BF
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf04.hostedemail.com (Postfix) with ESMTP id A728D40004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:00:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EDqbxVGT;
	spf=pass (imf04.hostedemail.com: domain of 3sg27agUKCBc9BEyB3BB381.zB985AHK-997Ixz7.BE3@flex--morbo.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3sg27agUKCBc9BEyB3BB381.zB985AHK-997Ixz7.BE3@flex--morbo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790643635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UISvcsFKvzVXeDB4zfTPatmPbuHHAhWug9QZEMeCtU8=;
	b=m1gLtZrVyHucgynQCPxwUV2PIL6huIQ5mR48+FOHscZBPMgwneOlMcFNToFFZKIFnV6IUz
	vlwezxNKPYJlg7h6A5Y1tgGySDI+LXnAZKllTHXT/pQ2LDOQt/GMRUawjZn8Zo+tVorZgz
	eX4Q9uipUTlgYLDWzJy4w6G1XKTTNqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790643635;
	b=qxCueDnZD584bgH5xGwcZ21yi/SOsYVUOEFMhIWTX/hGEB5EbZpXRteHy09UCtnQrppeNn
	lMBCnSJWcYjaCicEGGRpKddd5ikstFmT0ZXBxYadIQyjVrZcHYlkEaXRRGw28Hrl6opyA9
	b0RSqmqb3wEo6Wsm5c94NDvP1oU6SJ8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EDqbxVGT;
	spf=pass (imf04.hostedemail.com: domain of 3sg27agUKCBc9BEyB3BB381.zB985AHK-997Ixz7.BE3@flex--morbo.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3sg27agUKCBc9BEyB3BB381.zB985AHK-997Ixz7.BE3@flex--morbo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39deda201bcso5978527a91.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790643634; x=1791248434; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UISvcsFKvzVXeDB4zfTPatmPbuHHAhWug9QZEMeCtU8=;
        b=EDqbxVGTXi7Fp9UCTlrO/DQ2mmb4bERT8dcgAyS0TR79QlD84O3Yn1DtFXNnO+BMA6
         fpysoMjnF7Oyw9tmL3D4yHVM5wWNr0XhmaIKzK0qHP+mn9giKmwErnrrXcH6/WqW2zfh
         OetWTlys5QU7h0l8IdDIAvtdNcdNsT6c3j1w3S288v/IdmibRWCRCUTVqJfI0meh0HqT
         boLxhIYA8QgVDO2GfIzi3CDVNOTJKLZhMV4SCPuye29FrW+ypabEjdawWioVEsk7A9G9
         7s1dMblrwVb81Yt8REEcDa76PYFFKIm961GMqY8/2f7PtL7R3GlmCwq8fSZcI73xCAoH
         dfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790643634; x=1791248434;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UISvcsFKvzVXeDB4zfTPatmPbuHHAhWug9QZEMeCtU8=;
        b=uwpn+Q6EJkK/l0/NohL9i/6rOf96FlY2zQQ/3HX0JkXeVwPOzgBnwWLBXLCQMSG/jJ
         +fPx4LbyRrx+UbiInKfCec51yxzBNGLVZHUDh5LhWRGxajE7i59vZG17EyzofUKOggsZ
         46ScyB6tdbQ/gR7NHEA10JNCIq21YsY4MMaBBGvbzKqGJYOHsSGzhz+kwtgcjxj2bLLD
         8WIJsmOJuDhd+CG/RfYgNASUS+oFr0CrcwpFcRWzrlALku5nVD/btugCp1qeZ6jAFv5I
         7ZhvkM/nlnt7C42sh+2Z9OUdbmhyPNdjsRpXPSSJn8A68GhtqNN2ALeCQ8sf+gulabti
         sYjg==
X-Forwarded-Encrypted: i=1; AKwUvBzS3BbQRwiUrN14R7X/MecfzzsHBm9NFmbQJ03IvdDlAl92S1LCYmxl+4+9H5c8Gh/L7laX5EMnkw==@kvack.org
X-Gm-Message-State: AFq9FYKz6Eyc7p78Cpm7lRTPNYd+2pxQb34ZoYPUK9kBL3KUjvLWkqu3
	r0SLN+FIzzrBA5UvVmfGF1dSGrPsdVN8wo/7AyjvkjzsbkYnPLNBBziV+6xXKfybw39lmrD2tBC
	6
X-Received: from pjbsp5.prod.google.com ([2002:a17:90b:52c5:b0:3a4:75db:9277])
 (user=morbo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4406:b0:39e:261:4e0d
 with SMTP id 98e67ed59e1d1-3a098b4b1a6mr13781108a91.25.1790643634205; Mon, 28
 Sep 2026 18:00:34 -0700 (PDT)
Date: Tue, 29 Sep 2026 01:00:31 +0000
In-Reply-To: <20260928231737.2092716-1-morbo@google.com>
Mime-Version: 1.0
References: <20260928231737.2092716-1-morbo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929010031.2186255-1-morbo@google.com>
Subject: [PATCH] fortify: add KUnit tests for __counted_by and __counted_by_ptr
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
X-Stat-Signature: 4uquujrjqp1g7e8yqyh3prxbcj1c13gy
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A728D40004
X-HE-Tag: 1790643635-766693
X-HE-Meta: U2FsdGVkX1+oO68KTsBfXYlQN0NXPXT+Cu+9CGdJYQc214Pth3e1mxDvPEz806tjU4y3NV0pTvkUIVjM3zSc+WJWaRdgrijiW6SvAXjWHu3Ull9mG52sGt0bZkypgzKK7XGnMNFKMwD/Z6W/K7IvoDPLqSm4J6rxiQqnUya03SLjYE+cSlrfp601b7zzuHtXdGT+yG5M2n0I/Tm4dZ+suawsNLxmsapeZ+6Lcop3ZBUfGSzuwGW2IxXy6+Y4hP5a2nL7qPYywFF7iSNk+CdOJCA2YGWk6mVQVeCfgE8pPvtBHBIO4hVCZZBDeMmTEnCP+pCKVm7IX9ByWl0T+zte+REzp2k9rVwSbQ69aCsxxgYZz9kPsh9yYmn5UtIEM50QddGTN2ZjWakfTTiBd8s4fmpGGz3nmOxPXDPUdxcAo9ZghRHFLYDyW7s4bCUJK2kMia2eUIJvZPAgu60BTBDY6kt7ye+6KmrTLFeSkqkTWhwQa4Ca7WxSUZ5N/39EdsC5Cs4pJyCAdkUSqSWG2+kaSzTacvfZdFaZWElEf3CDp9P287nZ5P54AIEFoGbW4fCLM5i/WHTXsfvdCSZBCRTFhlxOvnPKgRlbmg3W9QuXMNkVlKmtb0DQbgBNH2QTpv5eXsJU5A7LGeaAJSvj+6eEmOfFjdV801JLWAfI8tvnq+CKc+xVFWr7OLgexNvkqOsZjuQvexxOPRyiGieNDfi7g/BgQaEO1fCSwrC0R8XK2qjX9PKOzEXL7zbDOa4Dd/q46SsO2+3L5doVezZ9PomiQ11h60KTLOQQMXujLG0mcJGOS7iSMFzqQSdufJg6/kBpDXDOuPNryjfIoMrqqMV6BUrpoeKE2obi5N8eq6mKiTp3ly7CyKsmafXmh0IGIBirQG1PT1wRoHiCPNOqYEvo8ShQ97z+bo6gUV8pP+l/tNnVOsglQOyJhGTDRJdwUw5QV7sb/gCbtQ/Uzz7gCkS
 e6Ut8HRB
 ayz9KdwKY1K7yIdmcRXstlOYx4U+KnGCkCuNIdKWIi0b8UdW/3A/uw+J64TQ1vMMObCXl54FWwTPR4VYrQaapcN2/1xTx+fT1xyTSTRFOFEwnsxu6AesVsZi4r+PsnE8ZtqW/SxEYlZ6mxzZQAv77nYStzS8kkn0PexRTdbjcyAlbilLELWRuozHS/lF/ce/s92UzqD4avFquTr0oQbC43U6o5R0ohPHcWMhv6tkxJUih/dMzFf11Wq+LywvYSpVjCDsAXl9sJ9pq5qMNxhUNf0LOgVQ05jLDWhwIsVxSaNa0gHb9q1QSBogMrQUOaF9WEaqT0Kytz3NQ13hGftZn55xe+50nY1onBCRyPIO/QTGWZCyi7B6jW1Dtl29Gm9ctjggQWK3bcHzSPChQWCBDyeWUYDzNCXX3eeVvtLDFnnl7X6An2xZFEnqMQIyzMLiaNDeaAHmixGpQrRWoegwrzyVL0CMThbWiv8nnDFQNTSDQNLQzoDiq9os/wf7TIeNAJ+5nbYSnS1FpgEWpvmbfAeyDF9s4Rufpe749oX9xqrXtyJZObWvQmoJpjlYiXCoxyXIz8S5mbJ+aNshjvanZ4L/u+L6Cl3XTIJBYNmwN8dX2I3HoGf/Qas1jAPdMn2dlfmMAstSi2plX4/rxFa+fBwqrByeUNdBsr9lk
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

 - '__builtin_dynamic_object_size()' (both types 0 and 1) returns the
   expected logical byte size for annotated flexible array and pointer
   members.
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
v2: Move tests to the 'fortify' KUnit tests. It uses UBSAN, which is
    what gets triggered by 'counted_by'.
---
 lib/tests/fortify_kunit.c | 119 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/lib/tests/fortify_kunit.c b/lib/tests/fortify_kunit.c
index 413cdbf3dc0d..2335171f84d8 100644
--- a/lib/tests/fortify_kunit.c
+++ b/lib/tests/fortify_kunit.c
@@ -1011,6 +1011,119 @@ static void fortify_test_kmemdup(struct kunit *test)
 	kfree(copy);
 }
 
+#ifdef CONFIG_CC_HAS_COUNTED_BY
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
+	s = kzalloc(sizeof(*s) + 2 * size * sizeof(s->array[0]), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
+
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
+	s = alloc_counted_by_flex_struct(test, size);
+
+	OPTIMIZER_HIDE_VAR(s);
+	OPTIMIZER_HIDE_VAR(elem_bytes);
+
+	/* __builtin_dynamic_object_size() should return the logical length. */
+	KUNIT_EXPECT_EQ(test, elem_bytes,
+			__builtin_dynamic_object_size(s->array, 0));
+	KUNIT_EXPECT_EQ(test, elem_bytes,
+			__builtin_dynamic_object_size(s->array, 1));
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
+	s = alloc_counted_by_ptr_struct(test, size);
+
+	OPTIMIZER_HIDE_VAR(s);
+	OPTIMIZER_HIDE_VAR(size);
+
+	/* __builtin_dynamic_object_size() should return the logical length. */
+	KUNIT_EXPECT_EQ(test, size, __builtin_dynamic_object_size(s->ptr, 0));
+	KUNIT_EXPECT_EQ(test, size, __builtin_dynamic_object_size(s->ptr, 1));
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
+#endif /* CONFIG_CC_HAS_COUNTED_BY_PTR */
+#endif /* CONFIG_CC_HAS_COUNTED_BY */
+
 static int fortify_test_init(struct kunit *test)
 {
 	if (!IS_ENABLED(CONFIG_FORTIFY_SOURCE))
@@ -1054,6 +1167,12 @@ static struct kunit_case fortify_test_cases[] = {
 	KUNIT_CASE(fortify_test_memchr_inv),
 	KUNIT_CASE(fortify_test_memcmp),
 	KUNIT_CASE(fortify_test_kmemdup),
+#ifdef CONFIG_CC_HAS_COUNTED_BY
+	KUNIT_CASE(fortify_test_counted_by_flex),
+#ifdef CONFIG_CC_HAS_COUNTED_BY_PTR
+	KUNIT_CASE(fortify_test_counted_by_ptr),
+#endif /* CONFIG_CC_HAS_COUNTED_BY_PTR */
+#endif /* CONFIG_CC_HAS_COUNTED_BY */
 	{}
 };
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


