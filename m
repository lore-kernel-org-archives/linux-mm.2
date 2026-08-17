Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3528DC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C7A6B00BC; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CE86B00C1; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5063B6B00C2; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAA06B00BC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BCD3A077E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:05 +0000 (UTC)
X-FDA: 85110726330.20.71D4346
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id BAEC440003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bvasQ0fe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfHHmTAX9KFDfSupTJahIh3zGovtGMOsbiiwMzb7abo=;
	b=8di74obxLpXkUP1gcEXW0oyL6uZw+aDtONEqgEizmWGsvxafgyIq6Kkg4MPLYdFMHToKhF
	kjB4JGh3zUlftLl7zHPb2ir2C7G/fK/8XAjvQvRiDmG0TZZQSKkfkjQyO7dr8umstplHLw
	6exu1AGiwn8qMTyEFs9Oq9fK5hLrIE0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bvasQ0fe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970583;
	b=8h/lf0lb4/0ByeufXWPw+KywTZ5NDbyMRE3R+VIoOXPG+NVUo1KngMt2K2TT5EF1/csFut
	2/1CcqYI1mlTQXLh8K2FYBt+erBeBXyXPrsQ8LuQCEIL3iuHBbfx4YPnVa92RnN5MtiCbb
	LU3RXrYtyA/1nw++BrBsrSzDVuFWHW8=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2020421077so548399766b.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970582; x=1787575382; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gfHHmTAX9KFDfSupTJahIh3zGovtGMOsbiiwMzb7abo=;
        b=bvasQ0feX2+ZjkIasLFfyXRkwXinjwcXz9YG1rXca3lOe54XF0SANMjY6oKk/S4FRk
         QMJpzadfP5JGUlXeuHkwkDH9jIILn0/koagIHLXvisMUVFhyDoa8seI7wgux1jFqXejI
         OjMJrHBoxBhpfZ3Yf1GgrjtmzXf+Y/ISuAY/67y8ZNvaQthtKBIeJbWPUFeMpaRKGklJ
         c5j/BIHDdAhSTUOyvendF8pWGJeFzoVfQJcAD0rGIWR5OZPrA+swSxPivE/taFckgSPX
         B3RL+0lO1d60PiXXXdgNFhxqzJ+27jXCAj1PI2QXf6UH4dLoWcTfUeHI1Xq1YKaJ333j
         dWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970582; x=1787575382;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gfHHmTAX9KFDfSupTJahIh3zGovtGMOsbiiwMzb7abo=;
        b=b7/vlngFkaumO9qvu4zlWfp5fbe1Ep208e8J8tXBhO9jgU5DKEHhslpsA942xukZsp
         RIe79kFIsUzJCasa2mLznug3LLZeqEVstIAyfpWE9A3Y5YcvGdRgq4rsH49D0q9awOGJ
         GqNVuTw/OH9pv+0NrQRy7JgZlmsmCozaqyiuVIh4ZN+nI8Jyj9NPwDBlRlmZBPoTJpg9
         QvpOHYgbLGmMs3xbFUE9BfynYBCg/TQoBezepozTuDo3bLonqU5ecPPOiCiRS7EdP99m
         esLkIruRQzhFKYb5c2ve+9EI5azhWUH6FA9MGP/pE5m7JQywUMS0xJC6sTVLZqTFRO9D
         k3+w==
X-Gm-Message-State: AOJu0YzdcVh2Iw1+Za9USTPGOIjjLq/GqHnS70hmWaqEt7Vh+/rQRcl0
	dn7mb4VDEp1eVYCVT8nGsV6SoOv7G6DkefPovirx4INcLztJuXOXYGOc
X-Gm-Gg: AR+sD118fQ+KEJ3VAKcR90hspTyA8GVF5tPSHepfkMyKJlLwRBmlEIa9tav4htW0KAV
	W+STqLtB3/GByfM4uln39J6B9bQY368NZgk3QwGp3Rd7YL4ob7BeTPcbpBpkGGpDH1AcQKj+v8s
	EI84riHfJj2AtFYby9jmnWmmlxZ33nvyxS+/s+y+UVJfD4RAozR/8+cOurzC2Zp48x0c7JLMEkD
	2wEMnFgnVt+yhQwaUJIpJ69NN982LbEd3bJjDtZG+3GHci0Qk3ek4u9WrBpM964JKYhahC0ISHJ
	JUGbYF92/NdW5GnetylrEc7dtVgE1m2b0zYRM6LNQfrtJtvxeYleLTGaXaNKkYPAoj0555m5BQU
	FoN0LOj3QmDTb5HFN0pgx1QCHIRdQ/lXcUetBfKKppGcwhRu07J4AR01WPy91gF+cttbBx4pPoG
	kN/siTM4YEuVzaiKfOGREOTK1VX8//Jcs1riUuytizcVRjbn9fDA==
X-Received: by 2002:a17:906:4fc8:b0:c16:66dc:3ab7 with SMTP id a640c23a62f3a-c2129b5b0c3mr1072891266b.10.1786970581919;
        Mon, 17 Aug 2026 05:43:01 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:01 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:42 +0100
Subject: [PATCH RFC 2/9] stackdepot: add KUnit tests for trie storage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-2-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Queue-Id: BAEC440003
X-Rspamd-Server: rspam07
X-Stat-Signature: cqxc9eo8dgfy4zakd67c43i1hayz1tez
X-HE-Tag: 1786970583-423595
X-HE-Meta: U2FsdGVkX1+Zu1PmeMeS5VMX9/hreKBRpQACYccwTDPS8qEiF/7t7o4+DPs4bCuqYNi/iBBbxjxwlxJw1dodnAyelJDR+xeHOn0lLfhDQ/TXSQZe2qKdpog7M4iQWDsmEzge2KOs8NxK64qmgCesT25GxGONhkGkomc47+jsEHJBextvq+n+r0yj6bpMbQNpRLUmqyngjKcNQsQFO9Mx41Uk3HQyVZtdGzpa5sztrBhnDaFb/AjqiKM9YvIqg6iot2oH5gIKBFAk8KLVkTRiTNDoDzttIxsY6kveG8w+ubvlvE4uRHvIoIQzdAA3mDM4UJxLRtw106cs/eab1V2AvRVTW2miQhb4N0U/YTL+PHZeRQfRGAqdvgRhFii4x7BEU8WwUS1XE6MSmeEdYwEafvIP91VEvY68VDEVyz/bIr3x2fXNGawTP6OpHtg2WeN2bx5OLO6KtT8hrdM2gET27I4DpOCmlfpSvdLtcD2DCFL+qeqsLC5B7JL8TJ3ehzUmYiUJDcP6atJmdtOin2jcXEbrfVYx0JHfOjbGSM2/oTHatSTIojYyl4rbX+w6usM5qQRamywMG7jiApvqM+i7N8jRhHS0PHL7TyD1D7/zVCo9wpQix0tVSGqXfe6at+Mvxj11MfArshWd/K1w/d4CIEJMV+3v6xGa6ELYGaAPl3hKVTcC6FcrQ4rRCg6BFPgC40lMSHfvzUnabpiwT3SinKYBSwJNfR0mnf6ALd/GYpwOD9XB/4IxCqwXffU3ddO/gyERUhnCLE4+QA+izuGk7MrKzdSNP802jkYw22YThvDRewt5zpHEknI6RICZgAeTgImkTvyrp7q+W60Z1AJdSInNiHWJX3/qiyQnkAIZF49BDdJhWbKN7O0yzCipBuLbBBqRBAX41hTvr4TTrdm8uuSqNvGc/7LLcpMmUXT7I2cwULz9VaC+nNtKd45gS/cVwPsi+D1BWOl+2zrc0nd
 I7cPBddx
 nLpoctAP7DMYckrK+gH3hRJ3znaVSKwED/yUj/xsVmlt33sgdp3T/58fA18/6LwZON2ReY3h/ufayJAGJ7IxEw2h5j8I4hNj4nX/xwO/U5bgsBrbeNCDSn5/AsEqHXi5KTCi2FYqnH4UoBAP3sLm7buLVNorPQKPYmDnxNWqZY20tMPVf0EF/Yt3/4JvAQPEyrZkfSw1MdavWzlbdZ0ZxHnRDkIyZ9twNeMESYjwH2rA87vA4QOuhPcJIpiu/xfqU/PwUFt13ep6JfR4Xy9uWhRK4Zd0uolASaTNNOFDt6wJjsn12DicPVStuVZWzcSEXCKFW4dPLFbw8V/t4rsDlmqRGHQqIMqhOZAmmHHzqulm32998II02iTr4CCZGqsBoSjHXmwAOODpiwExg+7A3RrqxSvK9YpBhOFcm4W4DCveqbAST/wbZWfCUGASi2N0gCcPUXetIrXyR1FwxWKFUrNFMB28abWv5ePgzsV3y8C0rWjAtgG9l23mrSEgZgpcGH0XjfcFnw3cf3LY9+OVIuUOTvd4jtswX7DbA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

Trie insertion mutates shared topology, but handles returned before later
splits, promotions, and child-array replacements must continue to fetch and
deduplicate the same traces. Add a built-in KUnit suite for stack depot's
public APIs and trie internals. The backend-neutral cases run immediately
against hash storage. Once the final patch makes trie activation reachable,
the same cases also exercise trie storage.

Cover save and deduplication behavior, maximum-depth and overlong stacks,
allocation-constrained hits and misses, GET records, extra bits,
caller-owned fetching, short destinations, and formatted output. Exercise
append, descent, split, promotion, child-array growth, and tail append
paths. Also cover lockless duplicate lookups while verifying that earlier
handles still materialize and deduplicate after later mutations.

Add mixed compressed and raw frame round trips together with generic,
arm64, and native x86-64 codec coverage. Keep fixtures portable to 32-bit
architectures, skip the native x86 codec case on UML, and require at least
three configured frames for the topology fixtures. On 4 KiB arm64 and
native x86-64 builds configured for 256 frames, an alternating
compressed/raw maximum-depth trace creates one node per frame and exercises
a two-pool insertion and its bounded retry path.

Build the suite into the kernel because it exercises non-exported stack
depot helpers. Skip trie-specific cases unless
stackdepot_kunit.trie_pool_limit matches the stack_depot_max_pools
value used at boot. On the complete series, run them with
stackdepot.trie_enabled=1 and matching values for both parameters; this
prevents optional initialization failure from silently exercising hash
storage.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 lib/Kconfig.debug            |  17 ++
 lib/tests/Makefile           |   1 +
 lib/tests/stackdepot_kunit.c | 418 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 436 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 00921b1676e8..af238949fb7a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2771,6 +2771,23 @@ config RESOURCE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config STACKDEPOT_KUNIT_TEST
+	bool "KUnit test for stack depot" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && STACKDEPOT
+	depends on STACKDEPOT_MAX_FRAMES >= 3
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test stack depot API behavior at boot.
+	  This test is built in because it exercises internal, non-exported
+	  stack depot helpers, so KUNIT must also be built in.
+
+	  KUnit tests run during boot and output the results to the debug log
+	  in TAP format (https://testanything.org/). Only useful for kernel
+	  developers running the KUnit test harness, and not intended for
+	  inclusion into a production build.
+
+	  If unsure, say N.
+
 config SYSCTL_KUNIT_TEST
 	tristate "KUnit test for sysctl" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 4ead57602eac..2d40bd21a8ef 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_SCANF_KUNIT_TEST) += scanf_kunit.o
 obj-$(CONFIG_SEQ_BUF_KUNIT_TEST) += seq_buf_kunit.o
 obj-$(CONFIG_SIPHASH_KUNIT_TEST) += siphash_kunit.o
 obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
+obj-$(CONFIG_STACKDEPOT_KUNIT_TEST) += stackdepot_kunit.o
 obj-$(CONFIG_TEST_SORT) += test_sort.o
 CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
 obj-$(CONFIG_STACKINIT_KUNIT_TEST) += stackinit_kunit.o
diff --git a/lib/tests/stackdepot_kunit.c b/lib/tests/stackdepot_kunit.c
new file mode 100644
index 000000000000..75fa16268c0b
--- /dev/null
+++ b/lib/tests/stackdepot_kunit.c
@@ -0,0 +1,418 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+#include <linux/array_size.h>
+#include <linux/gfp.h>
+#include <linux/limits.h>
+#include <linux/moduleparam.h>
+#include <linux/stackdepot.h>
+#include <linux/stacktrace.h>
+#include <linux/string.h>
+
+#include <asm/stackdepot.h>
+
+static int expected_trie_pool_limit = -1;
+module_param_named(trie_pool_limit, expected_trie_pool_limit, int, 0);
+MODULE_PARM_DESC(trie_pool_limit, "Expected stackdepot hash/trie pool split");
+
+#ifdef CONFIG_ARM64
+#include <asm/sections.h>
+
+static inline unsigned long stackdepot_arm64_frame(long offset)
+{
+	return (unsigned long)((long)_text + offset);
+}
+#endif
+
+static void stackdepot_trie_max_path_roundtrip(struct kunit *test)
+{
+	union handle_parts parts;
+	unsigned long *entries;
+	unsigned long *fetched;
+	depot_stack_handle_t handle;
+	size_t size = CONFIG_STACKDEPOT_MAX_FRAMES * sizeof(*entries);
+	u32 pool_index_plus_1;
+	unsigned int i;
+
+	if (expected_trie_pool_limit < 0)
+		kunit_skip(test, "trie pool limit was not provided");
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+	entries = kunit_kcalloc(test, CONFIG_STACKDEPOT_MAX_FRAMES,
+				sizeof(*entries), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, entries);
+	fetched = kunit_kcalloc(test, CONFIG_STACKDEPOT_MAX_FRAMES,
+				sizeof(*fetched), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, fetched);
+	for (i = 0; i < CONFIG_STACKDEPOT_MAX_FRAMES; i++) {
+#ifdef CONFIG_ARM64
+		entries[i] = i & 1 ? 0x1000UL + i * 0x1000UL :
+			stackdepot_arm64_frame(i * 4);
+#elif defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+		entries[i] = i & 1 ? 0xffff888000000000UL + i * 0x1000UL :
+			0xffffffff10000000UL + i * 0x10UL;
+#else
+		entries[i] = 0x1000UL + i * 0x1000UL;
+#endif
+	}
+
+	handle = stack_depot_save(entries, CONFIG_STACKDEPOT_MAX_FRAMES,
+				  GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+	parts.handle = handle;
+	pool_index_plus_1 = parts.pool_index_plus_1;
+	KUNIT_EXPECT_GT(test, pool_index_plus_1, (u32)expected_trie_pool_limit);
+	KUNIT_EXPECT_EQ(test,
+			stack_depot_fetch_into(handle, fetched,
+					       CONFIG_STACKDEPOT_MAX_FRAMES),
+			(unsigned int)CONFIG_STACKDEPOT_MAX_FRAMES);
+	KUNIT_EXPECT_MEMEQ(test, fetched, entries, size);
+	KUNIT_EXPECT_EQ(test,
+			stack_depot_save(entries, CONFIG_STACKDEPOT_MAX_FRAMES,
+					 GFP_KERNEL),
+			handle);
+}
+
+static void stackdepot_save_flags_public(struct kunit *test)
+{
+	unsigned long entries[] = { 0x501000UL, 0x502000UL, 0x503000UL };
+	unsigned long get_entries[] = { 0x601000UL, 0x602000UL };
+	unsigned long missing_entries[] = { 0x701000UL, 0x702000UL };
+	unsigned long fetched[ARRAY_SIZE(entries)] = {};
+	depot_stack_handle_t noalloc_handle;
+	depot_stack_handle_t overlong_handle;
+	depot_stack_handle_t plain_handle;
+	depot_stack_handle_t get_handle;
+	depot_stack_handle_t again;
+	depot_stack_handle_t extra;
+	gfp_t no_spin = GFP_NOWAIT & ~__GFP_RECLAIM;
+	unsigned long *overlong_fetched;
+	unsigned long *overlong_entries;
+	unsigned int overlong_nr = CONFIG_STACKDEPOT_MAX_FRAMES + 1;
+	unsigned int nr_entries;
+	size_t overlong_size;
+	unsigned int i;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+	overlong_entries = kunit_kcalloc(test, overlong_nr,
+					 sizeof(*overlong_entries), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, overlong_entries);
+	overlong_fetched = kunit_kcalloc(test, CONFIG_STACKDEPOT_MAX_FRAMES,
+					 sizeof(*overlong_fetched), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, overlong_fetched);
+	for (i = 0; i < overlong_nr; i++)
+		overlong_entries[i] = 0x800000UL + i * 0x1000UL;
+
+	plain_handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, plain_handle, (depot_stack_handle_t)0);
+	again = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, again, plain_handle);
+
+	nr_entries = stack_depot_fetch_into(plain_handle, fetched,
+					    ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, entries, sizeof(entries));
+
+	noalloc_handle = stack_depot_save_flags(entries, ARRAY_SIZE(entries), no_spin, 0);
+	KUNIT_EXPECT_EQ(test, noalloc_handle, plain_handle);
+	if (expected_trie_pool_limit >= 0) {
+		noalloc_handle =
+			stack_depot_save_flags(missing_entries,
+					       ARRAY_SIZE(missing_entries),
+					       no_spin, 0);
+		KUNIT_EXPECT_EQ(test, noalloc_handle, (depot_stack_handle_t)0);
+	}
+
+	get_handle = stack_depot_save_flags(get_entries, ARRAY_SIZE(get_entries),
+					    GFP_KERNEL,
+					    STACK_DEPOT_FLAG_CAN_ALLOC |
+					    STACK_DEPOT_FLAG_GET);
+	KUNIT_ASSERT_NE(test, get_handle, (depot_stack_handle_t)0);
+	stack_depot_put(get_handle);
+
+	overlong_handle = stack_depot_save(overlong_entries, overlong_nr,
+					   GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, overlong_handle, (depot_stack_handle_t)0);
+	nr_entries = stack_depot_fetch_into(overlong_handle, overlong_fetched,
+					    CONFIG_STACKDEPOT_MAX_FRAMES);
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)CONFIG_STACKDEPOT_MAX_FRAMES);
+	overlong_size = CONFIG_STACKDEPOT_MAX_FRAMES * sizeof(*overlong_entries);
+	KUNIT_EXPECT_MEMEQ(test, overlong_fetched, overlong_entries, overlong_size);
+
+	extra = stack_depot_set_extra_bits(plain_handle, 7);
+	KUNIT_ASSERT_NE(test, extra, (depot_stack_handle_t)0);
+	KUNIT_EXPECT_EQ(test, stack_depot_get_extra_bits(extra), 7U);
+	memset(fetched, 0, sizeof(fetched));
+	nr_entries = stack_depot_fetch_into(extra, fetched, ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, entries, sizeof(entries));
+}
+
+static void stackdepot_snprint_public(struct kunit *test)
+{
+	unsigned long entries[] = { 0x1000UL, 0x2000UL, 0x3000UL };
+	char expected[256];
+	char actual[256];
+	depot_stack_handle_t handle;
+	unsigned int expected_len;
+	int actual_len;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+
+	expected_len = stack_trace_snprint(expected, sizeof(expected), entries,
+					   ARRAY_SIZE(entries), 2);
+	actual_len = stack_depot_snprint(handle, actual, sizeof(actual), 2);
+	KUNIT_EXPECT_EQ(test, actual_len, (int)expected_len);
+	KUNIT_EXPECT_STREQ(test, actual, expected);
+}
+
+static void stackdepot_fetch_into_roundtrip(struct kunit *test)
+{
+	unsigned long entries[] = {
+		0x101000UL,
+		0x102000UL,
+		0x103000UL,
+	};
+	unsigned long exact[ARRAY_SIZE(entries)] = {};
+	unsigned long fetched[ARRAY_SIZE(entries) + 1] = {
+		[ARRAY_SIZE(entries)] = 0xa5a5a5a5UL,
+	};
+	unsigned long expected_tail = fetched[ARRAY_SIZE(entries)];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+
+	nr_entries = stack_depot_fetch_into(handle, exact, ARRAY_SIZE(exact));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, exact, entries, sizeof(entries));
+
+	nr_entries = stack_depot_fetch_into(handle, fetched, ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, entries, sizeof(entries));
+	KUNIT_EXPECT_EQ(test, fetched[ARRAY_SIZE(entries)], expected_tail);
+}
+
+static void stackdepot_fetch_into_rejects_missing_or_short_stack(struct kunit *test)
+{
+	unsigned long entries[] = {
+		0x111000UL,
+		0x112000UL,
+		0x113000UL,
+	};
+	unsigned long fetched[ARRAY_SIZE(entries)] = {
+		0xa1a1a1a1UL,
+		0xb2b2b2b2UL,
+		0xc3c3c3c3UL,
+	};
+	unsigned long expected[ARRAY_SIZE(fetched)];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+	memcpy(expected, fetched, sizeof(expected));
+
+	nr_entries = stack_depot_fetch_into(0, fetched, ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
+
+	nr_entries = stack_depot_fetch_into(0, NULL, 0);
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+
+	nr_entries = stack_depot_fetch_into(handle, fetched,
+					    ARRAY_SIZE(fetched) - 1);
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
+}
+
+static void stackdepot_trie_topology_roundtrip(struct kunit *test)
+{
+	union handle_parts parts;
+	unsigned long stacks[][3] = {
+		{ 0x201000UL, 0x202000UL },
+		{ 0x201000UL, 0x203000UL },
+		{ 0x201000UL },
+		{ 0x201000UL, 0x203000UL, 0x204000UL },
+		{ 0x201000UL, 0x205000UL },
+		{ 0x201000UL, 0x204000UL },
+		{ 0x201000UL, 0x206000UL },
+		{ 0x201000UL, 0x207000UL },
+		{ 0x301000UL, 0x302000UL },
+		{ 0x301000UL, 0x302000UL, 0x303000UL },
+		{ 0x301000UL, 0x304000UL },
+		{ 0x401000UL, 0x402000UL, 0x403000UL },
+		{ 0x401000UL, 0x402000UL },
+	};
+	unsigned int nr_entries[] = { 2, 2, 1, 3, 2, 2, 2, 2, 2, 3, 2, 3, 2 };
+	depot_stack_handle_t handles[ARRAY_SIZE(stacks)];
+	unsigned long fetched[ARRAY_SIZE(stacks[0])];
+	u32 pool_index_plus_1;
+	unsigned int i;
+
+	if (expected_trie_pool_limit < 0)
+		kunit_skip(test, "trie pool limit was not provided");
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	for (i = 0; i < ARRAY_SIZE(stacks); i++) {
+		handles[i] = stack_depot_save(stacks[i], nr_entries[i], GFP_KERNEL);
+		KUNIT_ASSERT_NE(test, handles[i], (depot_stack_handle_t)0);
+	}
+	parts.handle = handles[0];
+	pool_index_plus_1 = parts.pool_index_plus_1;
+	KUNIT_ASSERT_GT(test, pool_index_plus_1,
+			(u32)expected_trie_pool_limit);
+
+	for (i = 0; i < ARRAY_SIZE(stacks); i++) {
+		memset(fetched, 0, sizeof(fetched));
+		KUNIT_EXPECT_EQ(test,
+				stack_depot_fetch_into(handles[i], fetched,
+						       ARRAY_SIZE(fetched)),
+				nr_entries[i]);
+		KUNIT_EXPECT_MEMEQ(test, fetched, stacks[i],
+				   nr_entries[i] * sizeof(fetched[0]));
+		KUNIT_EXPECT_EQ(test,
+				stack_depot_save(stacks[i], nr_entries[i], GFP_KERNEL),
+				handles[i]);
+	}
+}
+
+static void stackdepot_frame_storage_roundtrip(struct kunit *test)
+{
+	union handle_parts parts;
+	unsigned long fetched[3] = {};
+	depot_stack_handle_t handle;
+	u32 pool_index_plus_1;
+	unsigned int nr_entries;
+#if defined(CONFIG_ARM64)
+	unsigned long entries[] = {
+		stackdepot_arm64_frame(S32_MIN),
+		0x1000UL,
+		stackdepot_arm64_frame(S32_MAX),
+	};
+#elif defined(CONFIG_X86_64)
+	unsigned long entries[] = {
+		0xffffffff10001000UL,
+		0xffff888000001000UL,
+		0xffffffff20002000UL,
+	};
+#else
+	unsigned long entries[] = { 0x301000UL, 0x302000UL, 0x303000UL };
+#endif
+
+	if (expected_trie_pool_limit < 0)
+		kunit_skip(test, "trie pool limit was not provided");
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+	parts.handle = handle;
+	pool_index_plus_1 = parts.pool_index_plus_1;
+	KUNIT_ASSERT_GT(test, pool_index_plus_1,
+			(u32)expected_trie_pool_limit);
+
+	nr_entries = stack_depot_fetch_into(handle, fetched, ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, entries, sizeof(entries));
+}
+
+static void stackdepot_frame_raw_fallback(struct kunit *test)
+{
+	unsigned long frame = 0x1000UL;
+	bool compressed;
+	u32 payload;
+
+#ifdef CONFIG_ARM64
+	frame = (unsigned long)_text + (unsigned long)S32_MAX + 1UL;
+#endif
+
+	compressed = arch_stack_depot_frame_try_compress(frame, &payload);
+	KUNIT_EXPECT_FALSE(test, compressed);
+}
+
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+static void stackdepot_frame_x86_64(struct kunit *test)
+{
+	unsigned long direct_map = 0xffff888000001000UL;
+	unsigned long frame = 0xffffffff81234567UL;
+	unsigned long out;
+	bool compressed;
+	u32 low;
+
+	compressed = arch_stack_depot_frame_try_compress(frame, &low);
+	KUNIT_EXPECT_TRUE(test, compressed);
+	KUNIT_EXPECT_EQ(test, low, (u32)0x81234567);
+	arch_stack_depot_frame_decompress(low, &out);
+	KUNIT_EXPECT_EQ(test, out, frame);
+
+	compressed = arch_stack_depot_frame_try_compress(direct_map, &low);
+	KUNIT_EXPECT_FALSE(test, compressed);
+}
+#endif /* CONFIG_X86_64 && !CONFIG_UML */
+
+#ifdef CONFIG_ARM64
+static void stackdepot_frame_arm64(struct kunit *test)
+{
+	long negative_offset = S32_MIN;
+	long positive_offset = S32_MAX;
+	long offset = 0x123456;
+	unsigned long frame = stackdepot_arm64_frame(offset);
+	unsigned long out;
+	bool compressed;
+	u32 payload;
+
+	compressed = arch_stack_depot_frame_try_compress(frame, &payload);
+	KUNIT_EXPECT_TRUE(test, compressed);
+	KUNIT_EXPECT_EQ(test, payload, (u32)(s32)offset);
+	arch_stack_depot_frame_decompress(payload, &out);
+	KUNIT_EXPECT_EQ(test, out, frame);
+
+	frame = stackdepot_arm64_frame(negative_offset);
+	compressed = arch_stack_depot_frame_try_compress(frame, &payload);
+	KUNIT_EXPECT_TRUE(test, compressed);
+	KUNIT_EXPECT_EQ(test, payload, (u32)(s32)negative_offset);
+	arch_stack_depot_frame_decompress(payload, &out);
+	KUNIT_EXPECT_EQ(test, out, frame);
+
+	frame = stackdepot_arm64_frame(positive_offset);
+	compressed = arch_stack_depot_frame_try_compress(frame, &payload);
+	KUNIT_EXPECT_TRUE(test, compressed);
+	KUNIT_EXPECT_EQ(test, payload, (u32)(s32)positive_offset);
+	arch_stack_depot_frame_decompress(payload, &out);
+	KUNIT_EXPECT_EQ(test, out, frame);
+}
+#endif /* CONFIG_ARM64 */
+
+static struct kunit_case stackdepot_test_cases[] = {
+	KUNIT_CASE(stackdepot_trie_max_path_roundtrip),
+	KUNIT_CASE(stackdepot_save_flags_public),
+	KUNIT_CASE(stackdepot_snprint_public),
+	KUNIT_CASE(stackdepot_fetch_into_roundtrip),
+	KUNIT_CASE(stackdepot_fetch_into_rejects_missing_or_short_stack),
+	KUNIT_CASE(stackdepot_trie_topology_roundtrip),
+	KUNIT_CASE(stackdepot_frame_storage_roundtrip),
+	KUNIT_CASE(stackdepot_frame_raw_fallback),
+#if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+	KUNIT_CASE(stackdepot_frame_x86_64),
+#endif
+#ifdef CONFIG_ARM64
+	KUNIT_CASE(stackdepot_frame_arm64),
+#endif
+	{}
+};
+
+static struct kunit_suite stackdepot_test_suite = {
+	.name = "stackdepot",
+	.test_cases = stackdepot_test_cases,
+};
+
+kunit_test_suite(stackdepot_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for stack depot");
+MODULE_AUTHOR("Caleb Kan <ckan@cloudflare.com>");
+MODULE_LICENSE("GPL");

-- 
Git-155)


