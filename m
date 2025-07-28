Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A16DC87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 15:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F375B6B0092; Mon, 28 Jul 2025 11:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D636B0093; Mon, 28 Jul 2025 11:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21476B0096; Mon, 28 Jul 2025 11:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D383F6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:25:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F12B1D9FE5
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:25:18 +0000 (UTC)
X-FDA: 83714047116.29.544AEEF
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9065810000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:25:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U9zl+8Ap;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753716316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FmtiBSyLbULt1UA1JWlLsO3uP2X4WloH9sMbWEu3NzA=;
	b=6dhBJk4/gT9rMAzlml/i0b7yTTJIWWpNTuvcsHyXfgUnLb3o6T7luTVBypq0O+NCncqkte
	X0+8gGMbh419NWjfkQdi+zn3Eow6UWRm+saNa9+HITEgWbMwRGxLYIrTadeTF+vlNt0lLw
	mSAUBnk85rARVfI7bzEgYngPAaTt3Hg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753716316; a=rsa-sha256;
	cv=none;
	b=cXMQTEsG5SuSjd4oCEAnziMlg8VkRKyBAYny4KRrITf3Ypz2BjZvK34cOlACkn96AvwtAN
	f/u4GneZLJ08y6n/hGOmvoL3v2Mg5oqgYDAqseZWkO7bUBTaxbbfq/27l7skK7l4SS5CoO
	e2pzreQ965ZvKBlvMnHfrMUPTXeHeDE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U9zl+8Ap;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-455b63bfa52so77735e9.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753716315; x=1754321115; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FmtiBSyLbULt1UA1JWlLsO3uP2X4WloH9sMbWEu3NzA=;
        b=U9zl+8ApRD0H0cMYE8RVmP1eQALkjlEhR2u20og9Z0HTNyXi6jSc3Y5jJFdJiMDWIP
         btROqV2ABr3yq0/uXqI87WwxtGUSYZ7G4SZ6y7tWseR8rTS7GudQd1Sk2ccM/CE0ID5Y
         e+Sjn09kV0jvP6N2+zC/GOeaA0gfKDTRo5LBwkQN+sPFUPLONd344MRiQWOv/lzImdwc
         dx7lKyytCghU31nmF2H0P1DHtQ8oG0EXk/rsHgRNVzGdFgsgz0tBDQLJYm5pJmp5vlYY
         rnlIoG1HdYbh8M2HJfOL4XWyH0JxHqR1L0k3mYCCaka55Jn4MKuJNqgK7iZPklWenhCf
         9HQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753716315; x=1754321115;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FmtiBSyLbULt1UA1JWlLsO3uP2X4WloH9sMbWEu3NzA=;
        b=aWrfoAmqmCl1K92F/XKNWGDJHqx8k2TOJCQKkqjqgH3+ad0XKJWXNrfYSHSVJnFyOx
         Fu+Ra993jHMAUUc2wWXhuzR0P//Pf/EyI1av2TkNuoxG+sqU4X59yrAzZdxy3iRcObvS
         ygGL9NcpgY2AeeH7ESyDzwve4APKGPDPKGzByF/TcC3QjFipTKhCIVz7xK2XHp6+j6UG
         AKRCn+3kNF467SrXXoEQiJrOPcCfPC34foiqRL3nCC4BPPfbu+IWfZFY8U3mCyJV3sLE
         +RUGBSqGJA0BPZFn9Alio3Gahe2CIOSDAaJaJwh0LqWJGu2cY2740OnS0nOa76Wje8+/
         yCMg==
X-Forwarded-Encrypted: i=1; AJvYcCWXuOejsX7ThoiTVfLtdRjZ0vZ/UUrhBIGQV8cfIRX3/xf4K8WtF26dNYuSKf2f05b7mSHqE6kimg==@kvack.org
X-Gm-Message-State: AOJu0Yz1nVeo/HqLFpvBgslurd5XfRMuy7081SyVOehNHI0liCF+d4zw
	zspn5T0tpt1aPYnHrEjGO5eJhknsqXIXW9JrbMR/5Wy+hdtBgVvGQkB0QIZaUKVJNA==
X-Gm-Gg: ASbGnctlv6XeXq5HziY5HZO9CpiOgdLoHRS1cv7MbAxd1+odTDrhg6bPRkm63pzfPln
	DSn82+RMTGlblBqiw/aBPRY7YfGlqc3rBK2MGzRDYlJmNqD4IE6x01UB8l+4tHoEYRrwfxLZNaB
	vZrO/dSJLIOdFGy0fVlpK1uvCL6HVl7Nbn5CvFZHCyLcZGCFBFWvit1I9P+Qso/UnXSBRCkomxD
	Ts0zyomuM30RurasRrF14P5SXb/kgxdTtNvQMaFhYkowQLBG3Sp5uH61lRsvCrW+1DUel57udIt
	LX2FpmIQ+LQhZ1HjwWAeGQHQzLap9jROM2nIZeI50rWG0HpIb+KJL3FrzxOAkBoTwW24ZOK7XNU
	S6yf79p6vZA==
X-Google-Smtp-Source: AGHT+IFz2/khpbmE7QV+OLQd11BAr9Xk4dyOjWbrlD/05Yad/FhrSGmzWSDF//LF5el6BhaDH3YZQw==
X-Received: by 2002:a05:600d:11:b0:455:fd3e:4e12 with SMTP id 5b1f17b1804b1-4587c203b63mr3367205e9.4.1753716314556;
        Mon, 28 Jul 2025 08:25:14 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:ec3e:2435:f96c:43d])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-458705c4fdasm166070335e9.28.2025.07.28.08.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 08:25:14 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 28 Jul 2025 17:25:07 +0200
Subject: [PATCH] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine
 skipping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-kasan-tsbrcu-noquarantine-test-v1-1-fa24d9ab7f41@google.com>
X-B4-Tracking: v=1; b=H4sIAFKWh2gC/33NSwrCMBSF4a2EOzaQJqax2Yp0kMSrBuHW5lGE0
 r0brODM4X8G51shY4qYwbIVEi4xx4ladAcG4e7ohjxeWoMUUgsjT/zhsiNesk+hcprm6pKjEgl
 5wVy4DkYq1RsUuod28kx4ja8PcB73TjjX5pR9/DGWfRH1B0EpjPfDIFAe7dLBuG1vXjjTucQAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753716310; l=2679;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=Kptubjw33lIYXvj73r+Ak5WjJnBxiCJjjkNyZ62pUp4=;
 b=63awq6A643TMQphYSCgAxn8VRGNZqIMqOct7AU3rsaLfhYPVM3wE6iOhb9oBMDvAWudz6meau
 daIFkzIVpRXBf+8r00bPgCO+mafWmDLqF24NHkkqsPzSiRM+jBHA/Z8
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: 9065810000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: f1e4z798g4ue8kw37azubp8mjbqqsm99
X-HE-Tag: 1753716316-937256
X-HE-Meta: U2FsdGVkX195OvohBBnETEu/eyAQ/mdg7tEQvSZEhjjx3aiB8vk+cCHadyOG/dW9Fy04E6Ov2UTLBDqSXonFBiFj1YA0L075UuxFZsjLhESmhMCttb7wsAibT/ne4uPTVNnTUHyhDQ4+vGapmN9Snr9N5PzisQmGdndNkE+2Km9LthCpwsMk8hhTmvQ4rdD77YoabVQh0CNh9+ANrbxWBd6wLcuYnfULtD/rKjcnU0i6Zyb7YoLDA4ehHSNYI1mvE0/YAjO5hqm1IAbN2me9E78x96jhrmcZzm8NN7sCp71VxNSHmxCpnH3Nt/2EkUR0VNYCR8srKAb1FXOr+09PyMn4nvSQbLnVmhzm+peiw24blaMXZoIlRPW+FRWWp9lmcvPgaJFJ8pbLyJ72swF7c7oZPl7IrCB/CP8qO6OFSxKb80kZuYrMg70WkFNukAF1d3Urhqg8/b+DRZIVfIvzkMHj93aeW+X3OR+jop6UJHF10JQTKopki5EcIwlUYcpm7Rahejmf8qmKk9GLd37M9Gjq158GRpQemQ/86vqhrSBJfc3F9h1E1GKACnIDzJqgMWf9sVnNtHaCYnmrfUCja0SajnRMvSqgRhwKlHjUenqVfAlfl9gjrusjsdDdhEIaVSZuvEVwNexAb70mmxTUsoPGEIoAxLfm6Sz1km+LcjzyjjaBBEPjYalOKbImX5ysPoJg5RX18xIgizC2xCOeyYE7nJvJDL1/kKmCcG33fuOJSvpEOjhSz4D0up2/ysIRrgVlwkbOlkPPNTrbs5a89vmR9YHzeeQ8SWgpP3a/D6F8bCYDU7IT6GMq7XtfiqP5V9y6+0frtxlkKN6ekSgIinCvwi10TrQkmdQ8nGMiQmjEUqKe4uCoMytgc2vVgjATDEkuG6MU62ImMuHDLBdda+6rK2rhAsnUdF+4/7VqoyZw59Rfhr2YxahWQzUAj7Y3BI3U1ucPDEh9hC1F/ij
 bKzJV+T1
 sez2ppB6JozFUvyXJHLUm2pCgcGSMJa0SYkMt3SNczgevo+r153FUYqYLN2+8NTiTpARXjaNuMFxghLVAEg5oMoaiKpTf3zJAhgEm820q6gBvL8fGKqon7E0vP5A8GUA1VIWMlQatBR1vDMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU slabs
if CONFIG_SLUB_RCU_DEBUG is off.

Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Jann Horn <jannh@google.com>
---
Feel free to either take this as a separate commit or squash it into the
preceding "[PATCH] kasan: skip quarantine if object is still accessible
under RCU".

I tested this by running KASAN kunit tests for x86-64 with KASAN
and tracing manually enabled; there are two failing tests but those
seem unrelated (kasan_memchr is unexpectedly not detecting some
accesses, and kasan_strings is also failing).
---
 mm/kasan/kasan_test_c.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 5f922dd38ffa..15d3d82041bf 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1073,6 +1073,41 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
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
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		kmem_cache_destroy(cache);
+		return;
+	}
+
+	kmem_cache_free(cache, p);
+	p2 = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p2) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		kmem_cache_destroy(cache);
+		return;
+	}
+	KUNIT_ASSERT_PTR_EQ(test, p, p2);
+
+	kmem_cache_free(cache, p2);
+	kmem_cache_destroy(cache);
+}
+
 static void kmem_cache_double_destroy(struct kunit *test)
 {
 	struct kmem_cache *cache;
@@ -2098,6 +2133,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
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


