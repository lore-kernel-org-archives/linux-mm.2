Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8BFC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC3F6B009B; Tue, 11 Aug 2026 10:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768BE6B009D; Tue, 11 Aug 2026 10:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F256B009E; Tue, 11 Aug 2026 10:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42C326B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:12:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D74351A044C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:12:54 +0000 (UTC)
X-FDA: 85089179868.27.37F11D5
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18B3780008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:12:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m5OXSSWj;
	spf=pass (imf02.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786457573;
	b=y/01jwBcw679VKBpt3fxj7/c/AggMBfVNVaYiD7OQepx7F+7Ieh+Rd6lOUElY0PBg10f6M
	D/VXSWh+HTMPkFZt1J4cBhqkSYrQzbrdBXgxShX3suJB/W1eONIRhfu8tSwFhXaGTH2KVR
	/a5MjnT2uthukk95nqm9tplK4kniR3I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m5OXSSWj;
	spf=pass (imf02.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786457573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o80QnEVKUcuUdd3OZFAdxnODo4B1zikCcE/tvO9NxHk=;
	b=QPjI4OesTq94J4vl73bCy/od2yInOw689MG92pNUFdlY8TZG2t1Y3NGGMQwCxhjaiYtYLo
	iTQELfxgNGLLq0z7SDRjrqFMUWe272pl9HF3aajUHP0YbKlJirqNUZ78Pm9E05EM4fL8vi
	XzDbHxNqls5ijCRnRzdz6YyqBbURVKg=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49802c418b5so30638195e9.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786457572; x=1787062372; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o80QnEVKUcuUdd3OZFAdxnODo4B1zikCcE/tvO9NxHk=;
        b=m5OXSSWjP8hjXn0AWxSqFkiwV26CHfGgGSN516zPtdC1oTELlS6FAvEhj+JIMHqoad
         hM8pXrHYhfPAdXS2fsBby4TBymxNzlC4OhDoWAEu7NsFIW3BqAaoRhzX80WWzW/0WASI
         qZ/8Nkn6M5GfQLdYihAS/2mPwAwPGG94YYCBWc/vo8s3zJVzgGiEhysUYAfOUjrBZD4z
         AtevofXdlQ75ZjMtWQNh65DvlPwzKtoyJARpZ2w1sUzy4Bp0q8Y/QDL5QSSPe+mhcJtV
         2Hiin0iDHky6jHzu9HGb9tgt0afequTgpbh0UYUPvbw37Rmndsow75rSJQpro5he9fYX
         mk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786457572; x=1787062372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o80QnEVKUcuUdd3OZFAdxnODo4B1zikCcE/tvO9NxHk=;
        b=Inv/B0QTDoZyZU1J0RhjHEjcYG5aQUT9YsCOgpMjkDNB2ZxT7FDdCgp/DfowKwtDWi
         h7XfuF7rCSZ8Na9AK/QFU77yI6aWzL2RIseSPIxxZxhRKcc7qZYEopW006kGO4WrBU39
         kOuLXRtBhK3yeLxIs7JTRcY55qnH+WVjaODv8o5/in/UEYYLvmP6X4SN8pN2aOJmA52O
         ayfG1QS0nMvMxfVaZhSNBSDxt+MTtAKmF7rWMF1cnHtZxCn/T5k5dgR/4CsDTYDslrh1
         4zr50WAdxfHyBQ2DL4I1/79x+Fu0u/KoZCPMelcbCoY/sSdo7toCvqhzaCGfLreu+jd5
         G+tw==
X-Forwarded-Encrypted: i=1; AHgh+RrvXyLUdaeM3p1wLI/Nvd+wUZoIO43UN0SOUURSTnA08g//rGvyExG1L9SDNgBV6HMO6N7GVMaygw==@kvack.org
X-Gm-Message-State: AOJu0YwiTnaVKNINf9yLeyEziDriCVu4F5n3jZYLShM0HsVdASaZDWPj
	Hdv9kyHXUhBrb6Mpfdv1NwmWUR3GSXrYg27Mvgk6MDegG3u+K9Z3HWWV
X-Gm-Gg: AR+sD11RNuaegQRKenRvUsQA2zP4I10tlKxcqU54xth7Nt0zn90zuGYp1wLZBc415IV
	PII8EfKKXUpOywSLoR3Q0+ny0VLTGEAbTILvFVSgjM04mTs+DBPZj8WY2kmmleNnFWKnd+/hEIs
	nu8MBPYWlXWcBnG7gTghy9/rfeD1O0kAKzKyutwHp1T/ClnrhTwBLCzTuRIImjmJKne0gEpYIOI
	3tPCC9qKCMNLWwIbp68RDG0MsDPJOOdlHe249f6sx36KJfwgKJPPiIdVkEl08JmNP2blR8wzbZ9
	iv0d49SUMSSyXg4wj6JnsSvq2WVpOJBiSUIoQ1ukmYM3SXeeYbcQAIserG8wWT5rfCjbtlnvmNb
	peVujlWUdzSHDyIG7bOHhIcUUIZqdjW6UVgqEdPqtphPW09n7KPG1AQ9N+GJPTpdLNUrGmOza6Q
	ZP/fjbKekFAy5CmIlAGQ4ZDSTk8rC4cIB31n0r9O4HnxfRmkRCAWbFowOM5E5lcs1f8x9qTF4x9
	E6nVuVwi8CP9QyMt6DvdSxdoF8H6J4dVTP8X4T19OIFZALXkcVODR5mAUxsNAX36rrCiHT1w2GX
	BrT9TMuyVRdAQqaqgnVnXg2AIPO5jNcsKNDcLGYWUUwxv+22oV36CJsAYYNX1mPWDRQ4aGKOnw=
	=
X-Received: by 2002:a05:600c:4709:b0:495:4d88:e630 with SMTP id 5b1f17b1804b1-4997844c55emr61209035e9.10.1786457571515;
        Tue, 11 Aug 2026 07:12:51 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a133-e401-bc8e-d36c-2d08-c5e0.310.pool.telefonica.de. [2a02:3100:a133:e401:bc8e:d36c:2d08:c5e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5be29fsm4464099f8f.12.2026.08.11.07.12.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 11 Aug 2026 07:12:51 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 3/3] slab: test zero-size allocations in slub_kunit
Date: Tue, 11 Aug 2026 16:12:40 +0200
Message-Id: <20260811141240.62519-4-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260811141240.62519-1-kmehltretter@gmail.com>
References: <20260811141240.62519-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 18B3780008
X-Stat-Signature: 8q8g4t5mefejxii6thh9mcgkokm9egu4
X-Rspam-User: 
X-HE-Tag: 1786457572-222556
X-HE-Meta: U2FsdGVkX199jFRRxhIQnpgLQ7GQH6qaRsKxE3RcqEdMWA4EIaTebpF//8vv6ygi0CWOIfnDccAknnCqpeuvrwfL+vc7ZGpQTuvnAmep6OGAZ1+vYdhFm0CjDlIppHJzuMoTSUr5rEdsEkxIyLXsh3UoqiqSVsgjgX3Rg7lvNynz/wdDovxw+TgGg6cjeHYTuKTIU3xIwu0J3RkwtgwmWqiNkLwGhoJVK4Gj3O2eznmlbbsK9RRaQxk1vMTtmOVuCYyWdUDdJHYlsdN5XrexlmxxBhrtFa/HuiyXgRsOZKAXReCjtQI6zJOhNKoW9BZVdkLXgBHgLH+SOdkmdksV8fSizjASzAx61PbOv6uyu7+qU2fFlgtzqiz3XljULOPrCl5/7VSH0TfCbqYUiY3kUiQnSAtkfVU3kJauCF7AOtn8RbPjWZdknqL/ElAS7Ey2yHWf93U2Nn7L4IZGWTAEzf+JQic1fxTwTuy7Y8+AfU3sfqNnBwc9vYe9BdGPbozMJBxpHpBdCcsVkiFyWvOe+U9nQfVjiZlZCun4A5TtCQY4AnO7cEt6alTn+zW55gaLLwpnUwd9HYfHclPMPoBKczaM5IjTaAHTYKFQLA0dEvM9mKjWw8+paiNh+M+RwH9FeVxn97aHdiiFOgE1g2bJT3Zm/qQrIJBtakT9cFIHwGhWjDMYLGtiN5D4ISuK78HG8jo5qmAlcEBqRVQIvSJKoxOmsiXuTqjBzt+gfBEKTsTv1tWD1L0H+vwG/iNYGzckIgAJ9arvXcHzc/rh8DR1HBsdqWWYFQzSpPzgid+YyMM26GKTnZA9Jml/7DtcuHQ71uPV16COpCVCrosDKcTHnoTri9woIqUdMl3CBVv6GPQ2Vkmfu1SCsZlkeDgMxNde4aSqexG79hS/UpLIi+mUFNhFPfc/3ufXufYFfddaG803FbdmUc9dqPN5ZbWWv/Y4+bps6up1RTQJ7RYPMEe
 Vu9iGKZy
 A0/S4GqgIdwu4iYI+zic1GPc0pQJzinnMGu0MZzXEd9a1gDfFqgPwrStd/ci0BOYkzaElXBRQF2MMA/rrhsUzcLHLue0kG6HaRtBAIZY+3TgdR3Jk8ULD/r2wlDYsbIRlcUPSXEqzBzQpD+aEM81lUt0igEVTOZMxYXCitxxu9OusweUwaWCZCkYe1aXok6I2nVBo0tyJQKZ481vBjdK2BVRvDW1yvvtPF3F+V7rGlB8IDsXENQboWXc6Tc+laowR5S8/yyaGtRhry9ZX85jnqY3shfapTkzgLoLA1Vvd2E1zOIAr9674rCBRQVAKW3tFJcrZq2IYKLyswpKgzkdRjtROrDbzMEkHdvDeq+obYzyXn9/Ce32z0F3TsSQLaWgsb/b1q7c2UsOtZgCjMh4v38D2I1t/WKCSJZToEjHy+r88jjohwlvrGHMYE7DbSHhL16TCtI1U0htaEYWp96nugWINHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KUnit coverage for the zero-size allocation contract, including
ZERO_SIZE_PTR alignment and exact ZERO_OR_NULL_PTR() matching.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 lib/tests/slub_kunit.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index fa6d31dbca166..a02fc6b401e3e 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -380,6 +380,48 @@ static void test_kmalloc_kfree_nolock(struct kunit *test)
 }
 #endif
 
+static void test_zero_size_alloc(struct kunit *test)
+{
+	unsigned long zsp = (unsigned long)ZERO_SIZE_PTR;
+	void *p, *r;
+
+	static_assert((unsigned long)ZERO_SIZE_PTR % ARCH_KMALLOC_MINALIGN == 0);
+
+	p = kmalloc(0, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_EQ(test, p, ZERO_SIZE_PTR);
+	KUNIT_EXPECT_EQ(test, ksize(p), 0);
+	kfree(p);
+
+	KUNIT_EXPECT_PTR_EQ(test, kzalloc(0, GFP_KERNEL), ZERO_SIZE_PTR);
+	KUNIT_EXPECT_PTR_EQ(test, kmalloc_array(0, 8, GFP_KERNEL), ZERO_SIZE_PTR);
+	KUNIT_EXPECT_PTR_EQ(test, kcalloc(4, 0, GFP_KERNEL), ZERO_SIZE_PTR);
+
+	p = kvmalloc(0, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_EQ(test, p, ZERO_SIZE_PTR);
+	kvfree(p);
+
+	p = krealloc(NULL, 0, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_EQ(test, p, ZERO_SIZE_PTR);
+	r = krealloc(p, 64, GFP_KERNEL);
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR(r));
+	p = krealloc(r, 0, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_EQ(test, p, ZERO_SIZE_PTR);
+	kfree(p);
+
+	/* Only NULL and the zero-size sentinel match. */
+	KUNIT_EXPECT_TRUE(test, ZERO_OR_NULL_PTR(NULL));
+	KUNIT_EXPECT_TRUE(test, ZERO_OR_NULL_PTR(ZERO_SIZE_PTR));
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR((void *)1));
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR((void *)(zsp - 1)));
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR((void *)(zsp + 1)));
+	KUNIT_EXPECT_FALSE(test, ZERO_OR_NULL_PTR((void *)(zsp * 2)));
+
+	/* freeing the sentinel must stay a no-op */
+	kfree(ZERO_SIZE_PTR);
+	kfree_sensitive(ZERO_SIZE_PTR);
+	kvfree(ZERO_SIZE_PTR);
+}
+
 static int test_init(struct kunit *test)
 {
 	slab_errors = 0;
@@ -404,6 +446,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
+	KUNIT_CASE(test_zero_size_alloc),
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
 #endif
-- 
2.53.0


