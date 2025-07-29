Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB563C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 16:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C436B0088; Tue, 29 Jul 2025 12:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5DB6B008A; Tue, 29 Jul 2025 12:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4BB6B008C; Tue, 29 Jul 2025 12:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 185216B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:49:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A295156A64
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:49:57 +0000 (UTC)
X-FDA: 83717889234.17.6B2AB1A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 802E740007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:49:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Rv/EI3n9";
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753807795; a=rsa-sha256;
	cv=none;
	b=pxhQ70IxKF8VNSpqdwfoL2VaNX9TV6TY42u2eSAzrh+MscPd0cv+ZDuOj2ZN7sKa4whhPY
	gssgWIuo5jUzl5FcYhHPI9ihWmzhRBHAdY1o07C5R/ZdFQfLsdn4bZn+e//CqwGZdiPUk8
	Td4NW61jOUT+80soQYIOQIEpXikgLjg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Rv/EI3n9";
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753807795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eqFobIPQpQgCyyuokHwscyB7gthAuwhYB6CrRv1tkIY=;
	b=YzpoZUmzAk6w6t9na2nZa60OTsYekdVpWQZIC+S4cPdbJR6bVXqbf1xHkkFMrR4wt+PHra
	7l2D9bD2ZXvuJwlU39cMaf2oDLMhYqvxS8v4uoMC/ORDGxdurNJaQ1Bc4jEOlMb7iT8iAW
	ykIgv88QUNXhT+Eb36W4zQY1DWhPUCU=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-456007cfcd7so1155e9.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753807794; x=1754412594; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eqFobIPQpQgCyyuokHwscyB7gthAuwhYB6CrRv1tkIY=;
        b=Rv/EI3n9MHuMYpJp2pnM25dliPX+YcdvdWA9D4TwtKwIVt26e7X89NHTFzBjOSeWy8
         NYPqYbg6Kkzqwex7AHihh1neFKcIlxz3xrUriwIvCv1REAE2ke+p4hl5QHF+IpQGwsuJ
         91NtZUFlYYcjmnjLfG+0dd+q1OSYFBrhH+3RfefPee6tmgsBecU+NvwYWaMA140sfSqL
         BxLfoGI78xT+zXGRPsqxixWpmUuHlCw2x828/l+6pTY8rDrc+8aKuIgE0x/ncAjJF9VL
         pVXqsg3/bhKh+G4H6mWEy0CdUdc/1FMHJ3YqBN5VXFZb20sJVX/4kqlx+sxJ9m8hlOE0
         3VkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753807794; x=1754412594;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eqFobIPQpQgCyyuokHwscyB7gthAuwhYB6CrRv1tkIY=;
        b=CBo9F4NmnO0YSvbtUkdThCjpkdFGVJxOwjT1l/JY+WU/yMjnLu9PokQWCc34q4vHrl
         nkd2zXgb1uz11v4+E63UU1/kIrJaF2NHEMWvaOmE3FxcZfxqESqOvL/g4LH79Gk5ZhEH
         8tYq6U2VLhTeQXdIQxV3q4FFoyWRYCXOB9sxKFd3SUGcs/rR70+awavUcm41rMwubrn4
         c1GSdQjHXAW9uRvMIpppi8CtQDGRkPuwkRGv29RZJp8AcGNiM7R2KU/0MAR/SIfL/knW
         2GqOByzgK9qaOtyfcwp5hRtD8FNDkhBVIBOQY5s73oaI2z6HyNB7k7xSAk05wKNvR04P
         JOZw==
X-Forwarded-Encrypted: i=1; AJvYcCV11ScCHa8y0AASnbBohaA+BITPA/SbQJHrADGpt0r9C17n7F9zhRN/RP6aFGTTnaooZnsq8KnNIA==@kvack.org
X-Gm-Message-State: AOJu0YxRFYWxR8gonPpBFPBqyuuVMP7S1fK5C/eodwVlQwDhKi4UZXK8
	NY4Qf2G43z4GOnQ3/knRvj4qcUbImt+Pf8LIW3jtRf6+4BoMYoHiHMpBAsqBHIk0Fw==
X-Gm-Gg: ASbGncvEFqdPBgg1OjWYuy7jitzilQAM4mT5uQhm0qRtQlY3v6iu394fq+B70c9H3zV
	kNl0Yu2Co/FvB+HCLMUC8j3K6QxiopF7UwBAfSE5F/DZ6fOeYHPEhFeAXKpSGDCSgy328AB4wCj
	taL3WfzramCbxGsV5GdPTpivZSJ4kx/xGuw7sBM5zEkp8Z269YHF2+oszaS372V5u8hz7YPwP4e
	m+c25g2EljBLj/3rMh6RzZC5foHVsSF0UksVaZLLD8Gp83ZEfn+HdkOqRc7qPyoh3Om9BMUyL9e
	XK22HuBgjwRaSqPwLpOyZgS3UoPAJwmtcKcMiiHxQgo5MyXXskfnIdBfkYY3RyLIJuh0WtZ+lEm
	yc3CvJUkZM6o=
X-Google-Smtp-Source: AGHT+IE9t3NsTP6znRXjaaDGX7JsRhLn6+ZFRfCZwRKt8rDACg1dE2PX2ZoFelIr5TaoYsY9wUeNiQ==
X-Received: by 2002:a05:600c:1c9e:b0:442:feea:622d with SMTP id 5b1f17b1804b1-4588dc6d080mr2038245e9.1.1753807793858;
        Tue, 29 Jul 2025 09:49:53 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:fcf7:d8ea:691d:7dd3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4588d900725sm24490935e9.1.2025.07.29.09.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 09:49:53 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Tue, 29 Jul 2025 18:49:40 +0200
Subject: [PATCH v2] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine
 skipping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com>
X-B4-Tracking: v=1; b=H4sIAKT7iGgC/33NywrCMBCF4VcpszYQJ6axfRXpIomjDkJqcylC6
 bsbzMKdy/8szrdBosiUYOw2iLRy4jnUwEMH/mHDnQRfawNK1NLgWTxtskHk5KIvIsxLsdGGzIF
 EppSF9gaV6g1J3UM9eUW68fsLXKbWkZZSndzGH1PVhqg/CKE0zg2DJDyN6xGmff8A68MMc8QAA
 AA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753807789; l=2477;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=xC2SGCiiovnqO7RAnpaQ8tLK7DE0kascKCn2FPGbvbY=;
 b=7zrrhKfOV53X6HcBNKhvT/AH+5h+FvXFq+iJcJVzFIKzpNbAkLCHo7AVIcx12OW73XbYHN9uW
 P6My267RH23AaWkKXPCuOAPAQBR5RpcleEVFcaYXJutPWNe59pnR50F
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 802E740007
X-Stat-Signature: a9gih3d8i1fpcxi6hrx7q699y8yzjme6
X-HE-Tag: 1753807795-58749
X-HE-Meta: U2FsdGVkX18noM4Swa+mSgBowOSGzGc5FIFWwbaNUgC4MogzCFYrPPAOIKtoEUT3xdhZScjKHsdi1aex+FyGpmKgDRl418Kc30uZB5+4yAdzeDMhwvJdiNBHeIRRKMpgiLs/eTt/OHw/CBNw39ASdg281KggALF8q1yQQQt+b6UsJEa8/LG/ensMtVMUzfIAnnr5Lcy/dwVG9uxxNNHQmjrErt2z81i4/FqfnlsGU9Ggz25iDDgVcm44E3WWxE8KA1suDqlzvlu/aeZ4UyEKQeBpySL65spnj/9Kq0m7B+pTz2GG5+dbt+i5kQRgHPrwruWzsvjPz169rDIOP3BLZD9l9WRKl/AznZHeoIEi43kWr/Bm/5F2LIgJPt0E3Lr4fty1p2qaZpmmb6HRr0CgnikLRskhBp/E8CgJLr+PnEj1a1K04d3wLWqkJS8tD3wee5OLiW5W6x63v2bV2lVSZuoqklNt8WJbuLz6FnM3TnlaPEFMy/nogBN9pEX71NWGmiIZ8u41nr0yBsuLnG8/INUQ4oFi7Pfx7cPra0clv5NG7WKrslse+bqMQ0y++XmB52yclfw1E0J70SxE6ney/WWWwDjrcnjl34L7BNBQJqqU1x1D7eMMc9xs2LeBD7PbrbigfNZ9QfudsrJEutXokaB8rSDpswIXDUNDvU/0gLBdpliQ42UBy+pVvdu8TuPVZucEc2ldc/c1t/LrkeInnC/3bIASwgc2dcCJPnQVU6ueziTNyyARzbT/2Noo5jGg8fQPXfXtwehWS33acoFez9Vbm02IF7azjCyYdctki1twYHOmnHVC1iZ1WkdiVVtmbG4L+i/ipiktjy4g4gtvX3kLhZ91VfywkFKZ4tDFAY7AYtwCQEqYS0+kaAYz3dBw6mTpTKV0wNyRmUgo80nf+g+8TDKsHWHP18fwaX25+WjhMXJKj32diB7oym69Fs0Hb+nNY/dxcM7mETZJei/
 8lB7aNJ0
 iDRn6Z765MFNeC8yrwZCZ5Tk5AH5OW45t/22VVc/7EDfcJfsx8ZNlrxde+Na6NR8LKJx/WzW7WGZ117Yt92o7Ozc9m5gx6q6Jsi32v7mfoaaz0jwQIgdm+iIzNuZqLeSxZuF0vKK+bE6GsjxQW2Xy4IrRx4d5h6SYhMt33KJsCd+SV5rakvZLkx97oR62kAOl25P4vHRe5Z70JrLiiSXWcM2ZGRF30dlHNIdZS7RzGdiB1b/WpniJpQy4TprWDAaAuTjWgujTsgvjiR5esAUijvY24SckCxu0MJsUQ5cdN8o9ou4nIznttfue01f0wKA+tbUSaCJp1g3q1cV/K3rn92ZiT7aqijWqQS5TF7BXmZYwAAjqlLGD5NHfP53IHGtRG5uChg+W20KnJygIMxfGIcJtomH72Hg+/SZWKjXNWkcP8DDLPKyxrhZAVL9HlF1Kz3W9sNZ8y6IZ+QFfL4ALWO7lh9cw6oeXBr4Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU slabs
if CONFIG_SLUB_RCU_DEBUG is off.

Signed-off-by: Jann Horn <jannh@google.com>
---
changes in v2:
 - disable migration to ensure that all SLUB operations use the same
   percpu state (vbabka)
 - use EXPECT instead of ASSERT for pointer equality check so that
   expectation failure doesn't terminate the test with migration still
   disabled
---
 mm/kasan/kasan_test_c.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 5f922dd38ffa..0d50402d492c 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1073,6 +1073,43 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
 	kmem_cache_destroy(cache);
 }
 
+/*
+ * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
+ * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.
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
@@ -2098,6 +2135,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
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


