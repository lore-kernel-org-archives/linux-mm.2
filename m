Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E16CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3C9900189; Thu, 14 Aug 2025 11:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A427900172; Thu, 14 Aug 2025 11:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09425900189; Thu, 14 Aug 2025 11:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E571C900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:11:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99EF9C06C2
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:11:28 +0000 (UTC)
X-FDA: 83775701856.16.5F03DFA
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 67D831A0011
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:11:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ll5BnBwV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755184286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SskdpEkHcdWpBQfUP2UXfkwhjkYyC/FVECNBfHZs9y8=;
	b=4m7xzAeOakOZnCYiEV2zgKQQ7FbU06Aa5VjQka6B8FUfcXeycfOj5T3eVilbr7Y4uwO0RW
	uYDKqjxYpKXMSxkwWrTeMeKTiLnhQJXgqDXfMoP2Daf28HNhwKLjfg/pNBto/9KkGs104x
	hnCByKM4tYHBS+TYKe7zSkIV9FOcLjA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ll5BnBwV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of jannh@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755184286; a=rsa-sha256;
	cv=none;
	b=O0Uk1ZSOP5FZgf58Cox5S8eIVC9O51L+XBNsEjaPLbz5RBHSmzFc2fgPf7BXR247XPgMdG
	7OMugTQmdJ5y3i48DNcBXjKRFLWtQKzMd5VlHP+hIGPkXWn58Vw35D7Brl0q2lXVH/vS2H
	aDWk3QSJ9opBv1Iih3wTlc7N23fOPAM=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so68405e9.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755184285; x=1755789085; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SskdpEkHcdWpBQfUP2UXfkwhjkYyC/FVECNBfHZs9y8=;
        b=Ll5BnBwV57jGCsbOayLEBqNZ7HH8Qo6BU2h9KEW65onzPKpdL5KswijEo7ODQtaDXu
         zQWfqWTs8NZo0lN8qOYLeffEnINakvwjoS1m9aryybBPbqTITKpc99cplJtRiIX3At3d
         fd1jqr0CsVZz74EHnvKXoH7y2m78NONhl6O2+flum3YCIyX7diB/+B9SUzNgfy4hngSj
         XD/ppv2o+61ylExbkFmRkf1bx2w4CHvLz1XFwdlcn2kgsNbS5erkLCEO+nsrRHoSYvlq
         hV/uX/vl5t42AyyC/pzU7/knsUHFvSwKIYBaYL+N0/alaBwx/xe+xrn9wGn4o/S670on
         EwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755184285; x=1755789085;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SskdpEkHcdWpBQfUP2UXfkwhjkYyC/FVECNBfHZs9y8=;
        b=rMdlKCHYJeRq5eWwMDPk2AP0TXWlNnlh0nckMq/7WOHxWmhZ/laXutAFcUVHn6705V
         kLziVB9c6AaFmhCZwHIEB6eVjZneueqy17xrtqML5XYDZik+T6KTaYd5MBV5GZwd6FM0
         LVeg9oz/hDWWI9BhJcBwxe8DKdiZfRj6nActsqh3UTnmp4iUQIb/Ca0WLpIGAeCFIRA/
         HPaEkWG9C31zfwxL/mlH5z2GmmVIhPkZ/srCp9/im3QP2kQf9euxdfgNF9c6yQSLaweZ
         qG9YK7f7H2FPIXNzvt/2ho7qHuOZLA5k2q2Z/LeaGV2bUDJ/2uHR7TbYk/Py1ktnFReZ
         Bazg==
X-Forwarded-Encrypted: i=1; AJvYcCUpf5JN2c1X0RynDMjg+RRyZ3a6bwsWuB7KGxWW/c/M0oTV6O9DAZGUV0IXZpQSybBgF0HNe803jg==@kvack.org
X-Gm-Message-State: AOJu0YzyX0vPwypV8wmQ8q21Z+U2ndOPvaUbXhdIlwRBIuNYxlLANdlH
	TXmDKZhPXBaIxqIlKPP/C0z0YfewMySlPpIAq/9fIX9WdgLrtWbFIe69Y16cI8bmfg==
X-Gm-Gg: ASbGncsh7ABUMwYqAKuPpXbxck1YGDeBC1c4xZ0mhwh+SmWjoxjohCrGs2I1Dew5yof
	SMRVPoDc+5WNf+vf/24VWQNY/lNlXQIgHtSGygY5vJ9syLPKnjQe9D7eps9i6Csw0deOLOR0KOX
	Ymc0lGAaLHhZi3f+bA1UemF0kSIJCF1nHOUWc/lyjylhIO5zbROp0gKcIGYrZooNRDDMhJZWWbc
	HzP7QWcuEtUzMFIXdxo9ruwctDbO30yG9xlXocHSsbtU6B//K3WfI+iuJjj8DoYYcTftAk6YwcK
	oAQeRUTvzPLhDvhHWMRaMNE9ZdGtsW+f2AedvRLfbMMv/bwCepv2XTAzGx3R5nz9FCrWRo0ssBB
	tCjbFnw6QiHM/Qvz9
X-Google-Smtp-Source: AGHT+IHFuKzvFCHbuJcOA23BDSSsr0lmibgl/giYWdRmsmNyG65kEdnqrR+zs/DzX5Vpr3zDoXAx/w==
X-Received: by 2002:a05:600c:c4a6:b0:439:8f59:2c56 with SMTP id 5b1f17b1804b1-45a1b177b3amr2085275e9.2.1755184284501;
        Thu, 14 Aug 2025 08:11:24 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:3dd3:b636:a51b:d0a4])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3ba54b6c93fsm1524246f8f.12.2025.08.14.08.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 08:11:23 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Thu, 14 Aug 2025 17:11:10 +0200
Subject: [PATCH v3] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine
 skipping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-kasan-tsbrcu-noquarantine-test-v3-1-9e9110009b4e@google.com>
X-B4-Tracking: v=1; b=H4sIAI38nWgC/4WPwRKCIBRFf8VhHQ1CarjqPxoXgC9lKkhApsbx3
 yN1pl0tz1ucc9+EPDgNHtXZhBxE7bU1CdguQ6oXpgOs28SIElqQih7xVXhhcPDSqREbO4zCCRO
 0ARzAB1yoijJWVkCKEiXJw8FFP5fAuVnZwTCmTliP30ydbRH2IwKUVFJyToAe6pijj7PXPlj3W
 n6IdJFuJv5vbqQ4x21eypZzRrjip87a7gZ7Ze+omef5DVQWozEhAQAA
X-Change-ID: 20250728-kasan-tsbrcu-noquarantine-test-5c723367e056
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755184280; l=2857;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=1jDJoKW+0uL8pCUw24xwM3FK0vdRrfgga7GPmYtrP6Q=;
 b=7eqsCi6f+oUTHibo06jMfimP7X6uftqxmyns3NemnHriDHDs4/42buGL0Ep6842p7TLguABrF
 82V650jX80EB7QQQKwD0jNYibeGS0nG/peuF5xjkz/gf8dq6hlxxyc7
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67D831A0011
X-Stat-Signature: jn6ogmjkj6umy5uo3ih5hxnrupk3jtrh
X-Rspam-User: 
X-HE-Tag: 1755184286-622954
X-HE-Meta: U2FsdGVkX18LeieQCK07CiQQ5IayavgHFO7Ue4IKtNvRPN/GP2VeEBfxzsfQttjP3I/IY18oAEsRIT1liJHHWYw7WfnchFyQPPh0ppESir8+VWtAKKxxBEPKSz+W7OO8mBlsmNasBRArXxNM9xCxlUBJ5aamzhPKF8o6D2Q0WGye+fKDPw9fUyye/i5mq31WGmcA9ztsYSv7sdThq1DBRkt8/ft6PGpF/5VkgOSKQgDG7GzM5FVZay/r528Xo0H0rV5PJ0gRtyeWwKbhlyDyUV+/C+F+CA3Mu+YUHXz231MSj9k7Nk1qjRAe4BG6tASD/tkg06FKNsKQ2D0aomBbzltV56elFfMGRVMxcb40AscboTWuB7n3MY8pRacOZaVPUtG5oer3HNSHzfgjIp7IdBZ2EV9GBXt9M21qdGQKRBvU9LAYTS9nCvIyXr7H8BWhn8sjU4+pc/qsVOQ6IPlgJg4YzByv5dCetOZLVoc6i0emyilnYLJxskLJ9NaXiGuCNAV2ouw10XrBjJlHTG7dYFi+VooFAax3WIf+15FlEUmmz+CJXAXoCtHbu+CRwQ9CMhiU7MKTAiK+nEMQ4Wnoiw4pg4wvVNZtT25ALT8iqvrXnTUomXzIALe+zuFKziM1c+3I3yFg9LbNQh9ZzeA6MRk48wOv6c273z3DAF43M2IKi25x+3kSqkfGwBPRko9wvy7dSQW9GzIbPJaGP3T4VajRsyKDhhrRGRoR68xg/vRUGfTaUfAOkSuuWGg2gKVuLtAYYxDI0/2ZrvGZFDszi7gY6bYdBaohaad/Pd4lFVEZgKFCi21id9yvqsGp/LvLMb6+FcbIqcZltmiznCXWJXMYbx+EwJ6qQIqRLFI8peyOC//8lbRiBkfndzEli/AsIybqL064bbRUyXpTzpodnBEzkDunL1FCexG3+a7HKLXQdLd9Gcm9l8coob7eprvcZbJZT1ye6giLRtni6Df
 TnL9POK4
 EMnL3qWvW0zBAC0cEXRdrVvDNu+axQ6EEaSZKtdBO6SqqqTPAL+ygBCm6nPNB8B0nK/v0HsJPmDI5rwmAed9jheQNAr7ER8lTWkG1IBOpPAqDjXuCwAztRwbzY/zasfCSHbhCt8yq1aa4n9pybbXMtl+YgaCA7Vo3Ib0cgEc9xw/Sgi3GnOKDpp8ALw40v2xSMxBZXxpRobMsFwMsXLKUYsIJWjosTwD1WmT3XhKu7EgqHZYRcATA5kGzbN8rJsP5xK7DkgcLYpusM0h02Eon9gV7HmIThq9uja3AHEznMLPkfKqEsl2Is9Lcb0s5ZSygLohUYNvLigxkgXHwcDYjZssUYowfkbbv1vqHM9ZDfYkkF3QyPO4Zveu9GuwSE64w6Fl3/ZzlwvMScnvUJNNoNqVq5yTaOe+axEY1Vn/Y96blbwLkNWz/sZkoag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU slabs
if CONFIG_SLUB_RCU_DEBUG is off.

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Jann Horn <jannh@google.com>
---
Changes in v3:
 - add vbabka's ack
 - make comment more verbose (andreyknvl)
 - Link to v2: https://lore.kernel.org/r/20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com
Changes in v2:
 - disable migration to ensure that all SLUB operations use the same
   percpu state (vbabka)
 - use EXPECT instead of ASSERT for pointer equality check so that
   expectation failure doesn't terminate the test with migration still
   disabled
---
 mm/kasan/kasan_test_c.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 5f922dd38ffa..0affadb201c2 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1073,6 +1073,45 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
 	kmem_cache_destroy(cache);
 }
 
+/*
+ * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
+ * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.
+ * Without this, KASAN builds would be unable to trigger bugs caused by
+ * SLAB_TYPESAFE_BY_RCU users handling reycled objects improperly.
+ */
+static void kmem_cache_rcu_reuse(struct kunit *test)
+{
+	char *p, *p2;
+	struct kmem_cache *cache;
+
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
+
+	cache = kmem_cache_create("test_cache", 16, 0, SLAB_TYPESAFE_BY_RCU,
+				  NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+
+	migrate_disable();
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		goto out;
+	}
+
+	kmem_cache_free(cache, p);
+	p2 = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p2) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		goto out;
+	}
+	KUNIT_EXPECT_PTR_EQ(test, p, p2);
+
+	kmem_cache_free(cache, p2);
+
+out:
+	migrate_enable();
+	kmem_cache_destroy(cache);
+}
+
 static void kmem_cache_double_destroy(struct kunit *test)
 {
 	struct kmem_cache *cache;
@@ -2098,6 +2137,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmem_cache_double_free),
 	KUNIT_CASE(kmem_cache_invalid_free),
 	KUNIT_CASE(kmem_cache_rcu_uaf),
+	KUNIT_CASE(kmem_cache_rcu_reuse),
 	KUNIT_CASE(kmem_cache_double_destroy),
 	KUNIT_CASE(kmem_cache_accounted),
 	KUNIT_CASE(kmem_cache_bulk),

---
base-commit: 0df7d6c9705b283d5b71ee0ae86ead05bd3a55a9
change-id: 20250728-kasan-tsbrcu-noquarantine-test-5c723367e056
prerequisite-change-id: 20250723-kasan-tsbrcu-noquarantine-e207bb990e24:v1
prerequisite-patch-id: 4fab9d3a121bfcaacc32a40f606b7c04e0c6fdd0

-- 
Jann Horn <jannh@google.com>


