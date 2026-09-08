Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EBDC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380976B00A1; Tue,  8 Sep 2026 09:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358B26B00A3; Tue,  8 Sep 2026 09:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1EB6B00A4; Tue,  8 Sep 2026 09:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBD9F6B00A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:14:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74912C0691
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:06 +0000 (UTC)
X-FDA: 85190638092.17.36181B3
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8635B18000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T5DnMrzr;
	spf=pass (imf06.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAyR6h5/4ojoKsK6CQz1j0Z55ZNB06yaKFwRajx+NlY=;
	b=hQgs4lcr+Vlnv9R/xMIT6mbNowAOnqPe/4+EyjDm47FHtepcYfU4PZWdMM3QMTDEuD+48Q
	8OBLUI13WMQDGwl2rGA7a6i51dXoBpVp8axR9tGvm0LwGkbfAXU/QV5EGR0bTpGxinktOk
	cHuwS0S9jyQg3g3IVYJkuUqitYwrHe0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873244;
	b=KN3tH5eUNW+leX0EqswhmlgE8ZIkr2gam+HKt084qB7ux1ra6tPvrFqChEX2OHsTnoevY8
	smweFafAwdLDok6UqF28HiPbkvG126gQF5h0pebyVRV4ODdJFgxBn7rvJEiTJdjgc7iAM7
	dQ0TkL/Ah9pQG01xtTHpVcXwuTcUF2M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T5DnMrzr;
	spf=pass (imf06.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1677c91969so462637066b.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873243; x=1789478043; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WAyR6h5/4ojoKsK6CQz1j0Z55ZNB06yaKFwRajx+NlY=;
        b=T5DnMrzrpla3jjjTF4Kz1IoTx56DD8/c/xmcJHJUup1Qz7gQjQjXhcRAjHwyhopRct
         99nfnu3kF0o0cQFG+MDGxR56YZCBwNtuSCZglGi+2SI03ohDcnAFV81uuu/Dy4zTTxn0
         rZzPdlJ6DjxvzMwdHeeWRHHcE1PL2TS20JT8fdFyLj/JgIoB2k0DXqGlfJmGo+rBLRpp
         V+2dOOc7L5pnwOlCdYr3JwpayG9r6qRue0C/XJABwmCUpFYFz9g1yljG5VbeYXdJgH3V
         8O9Y4KUwyv/k6cOjxFKne5KbaSDvZFlxrKRVT/1ysEipd6DdPqxy7zxIRORJmZdndjDf
         umnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873243; x=1789478043;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WAyR6h5/4ojoKsK6CQz1j0Z55ZNB06yaKFwRajx+NlY=;
        b=HtIRyUcvctncxXLvsNbt5LkqMnAYj/z0e1XDe1NaVdnzLOwsk9Wd6zqdkee71RJ+4x
         AbS+dCdTXgPwkN4BM7jOJDH1y7XmPfEVy9Mei/RU0Xypz72kRq49MZNB9aeJOqQFRq+V
         N9WObF3xyeC1QsD+hfN2VLSgAaFg2SOPuoMU6goo5WfNNAUcLvTt35SiuPdhVxYPXtah
         u6Jj70LIQJN999yAtpOmti+V5PvHHQSJCvJckz52da8BvET1UJgvOqGGDWKr9ErmggO9
         qlW8JRmWmYixq/Jg4pbVhG+IU3xuRHEDtWc/eoEqKXTlpXBQ74752OZFhNELkr0Rcv/v
         AiZQ==
X-Gm-Message-State: AFuF++niyVYXGECWkztvairUqEga8eK+6CdkspUBw1UZQuOy83Ci2l/x
	0DJrRZf6gkXZOkte2oR0Duf6s5rvG1S0vu2CUxV7HQKbk5cIXYFIE8cS
X-Gm-Gg: AYBFou1pvalCJK17aLQM8PftU4ILYdYlpQMzptOlo/Z7XtMgcNrZ3y+plC6eQNePo+h
	fS/WhBh7dg61k1+dbTPWI3atKiIN0YxyTr5EyiuXqjtgHMWMFbvebhfuqzWypqPV7rAUXue3nrb
	hCYTXnTPOA6BUotCdZH6sXfe7O13VK0FY8SBqrXCDstifL/BdII8W4tdOAuw82mV+IxQM8CJkRM
	vw8vP0h0b6eszPE2tnjUj67keHsFwvG7PqfVEq0LzARLFqeByK32ZVm29QeKa0CfPi3n2pDSBq2
	W+hvtYtYooJjPzqDVRHVS9narIhUZEITEsyH7SbwsfBtGx//v5iJ1zWl0SKjyROO17Ne5Jaw3vL
	W+SGJdflmSAuPxOV7ZthdU5lEuv0r29zGEc08HBIbKiXYLLnfxzubrvlXH4hhOLdYrsT4RS+FFC
	DXVQQ+x+kB+0TBbkK9MvpNhnPOzRzHx7EsZfxTa4cNGoxnySzCtmszQYGRnlaV
X-Received: by 2002:a17:907:7287:b0:c26:1649:47b0 with SMTP id a640c23a62f3a-c261649564fmr960747966b.38.1788873243007;
        Tue, 08 Sep 2026 06:14:03 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:14:02 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:44 +0100
Subject: [PATCH RFC v2 11/11] stackdepot: add KUnit tests for trie storage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-11-1996d5cef732@cloudflare.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: y1cen5qe9mc6w959ypeief8f4i5jof6e
X-Rspamd-Queue-Id: 8635B18000B
X-HE-Tag: 1788873244-529072
X-HE-Meta: U2FsdGVkX1+jeq7potghgrcO5an4dqZLxt8L+7kUmVvtOg8qv9LiAT2s+6wiDIEREEEN6MltIBAA/sp+m3GWfCIbmCkIM9GpodV8X8YxX1/XxDBZ8LU6cvvllzsrUGnpJEbe0oophjTpOIFztUTB2qAuZ6NfBYRH6n7go7i0E2Wnt045PcFbGh1cozwjd5FFlWxHldRQtbHtUuW9EAJTLMCVFW8o0RaArbtldwaQA8DEJG6LZuRMUa9e+oqwXcrL0qTMuHh/lsWEH/ScHcvMbuVP75uSSbpB6isJvOvLVoLX8DwwTr5pkc1+q1KPt7hQXlu+/s5Bin9kYcVCI4TE4CjRETo4tlS8dLjOWtCPRGtyw6akU+H7pOVD34a94glvGDDZ1jwelYW3jhtQRIjveisyjESdsY+7WlpHl9T1eeg4+jPVmLG4q6OsSVP9WVgTtC0gV7Jo86y6SJKO+Tnl6aAUgPQ1Swcz2oaPhZ+qnnjNlbt+pPlfSJZieEUmvldS2R2WItaF5XUJgO1y/3Y5Z1auWK2AeJHJcHo6vvEEVSTyU+0MLM4UsPLhF2/s2xck60CbNdBMv/8WobM6MTsEZ3qsbjW1mxTAhHWHgecuCA3NJIicnyOp+b6eTlDn0blW8zsp5v8NYWS7FM6Reci5Vs2RhqReMNUWuOgefM9wUM5Z8Rv8AcUJJhILE1hKcO3U9vtjBmvAZj+73DY6WSugDHzfyh5AR7IKyPzA/trvVRgk4jdWG/UHn1zQbS0x4efx2ZWp6HTFPs0xmR7W0yiIsRyr93oqxe0si0iff5h3h4umxQnZGT+wHbhN+48PQuT7xsxlaP98S0psMptB3J6taIty7unbuTMBmCD2cbhRTHwd5pKSGjy2hlXZPjhGbCyRBasiDLsDRBhEQI213R3CSMwB5LSXz04JMv8rbQHRgsx111YYBV6tiAXc1kaNWF+ptx6I9C/kfSkSY+Ee7mN
 K2z+IjVp
 lIw8lL12QOjUqau4UrvL1JqYQkPfVXGcRkhWYzyVgYOxJxwwEAqyEpoaUJF9sy/7FDjbXbGIItWCsiitR6kbxHHqmsoHuzk/NZKnopIYq15j+6AetoueQmq17W9TUyPdODCAoRuG2wtxp/sYF3vY0egLMQ4yaBR78fzYDzqfPtHAcDz06HpQjHPoaQqvMp+HzaDdJFEamN4/eq/8J7sOOgDH9w9e/6TscP2PjDp4EbOEdLboK83YvcQKWvmfxaUY/mLF5NTbGljguN9WwOsc5KMMy9fBwzUEjv7XcXuFfwX8+EojXakpSs/OsnJpeYGIYkIkqKgib34C4F+pLQrVhLiYn8A5sC9Doaqv5dU8sKfldeYldFkZaZBDGQ9hzkNrVZAPktvo8hg2Rt3TYJjDxJGz1dN5RjqugUmrgMIPWK80NTXzEZyTl0wslxdcUEOAOVqAVr3TQqme155ZUhBLlUyGNKYzEaJ4FGxzF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

Trie insertion changes shared topology, but handles returned before later
splits, promotions, and child-array replacements must continue to fetch
and deduplicate the same traces.

Extend the built-in stack depot KUnit suite to test trie storage through
the public APIs and direct insertion cases. The public cases continue to
run against the hash backend by default and exercise the trie when it is
enabled.

Cover save and deduplication behavior, maximum-depth and overlong stacks,
insertion when allocation is not permitted, GET records, extra bits,
caller-owned fetching, and complete and truncated formatted output.
Exercise append, descent, split, promotion, child-array growth, and
tail-append paths. Verify that handles returned before these changes still
fetch the same trace and are returned again when that trace is saved.

Add round-trip tests for compressed and full-width frames on arm64 and
native x86-64, plus an architecture-independent full-width test. Keep the
topology fixtures portable to 32-bit architectures. On 4 KiB arm64 and
native x86-64 builds configured for 256 frames, a maximum-depth trace that
alternates compressed and full-width frames creates one node per frame and
requires more space than one otherwise-empty trie pool.

Require stackdepot_kunit.trie_pool_limit to match the
stack_depot_max_pools value used at boot before running trie-only cases.
This makes backend selection explicit and prevents an initialization
failure from silently running the hash tests instead. The save-flags and
snprint cases also check that saves return trie handles when a trie pool
limit is supplied.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 lib/tests/stackdepot_kunit.c | 352 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 352 insertions(+)

diff --git a/lib/tests/stackdepot_kunit.c b/lib/tests/stackdepot_kunit.c
index e4a7f1c83457..b86b84d56176 100644
--- a/lib/tests/stackdepot_kunit.c
+++ b/lib/tests/stackdepot_kunit.c
@@ -3,12 +3,19 @@
 #include <kunit/test.h>
 #include <linux/array_size.h>
 #include <linux/gfp.h>
+#include <linux/kallsyms.h>
 #include <linux/limits.h>
+#include <linux/moduleparam.h>
 #include <linux/stackdepot.h>
+#include <linux/stacktrace.h>
 #include <linux/string.h>
 
 #include <asm/stackdepot.h>
 
+static int expected_trie_pool_limit = -1;
+module_param_named(trie_pool_limit, expected_trie_pool_limit, int, 0);
+MODULE_PARM_DESC(trie_pool_limit, "Expected stackdepot hash/trie pool split");
+
 #ifdef CONFIG_ARM64
 #include <asm/sections.h>
 
@@ -18,6 +25,222 @@ static inline unsigned long stackdepot_arm64_frame(long offset)
 }
 #endif
 
+static unsigned long stackdepot_test_frame(unsigned int i)
+{
+#ifdef CONFIG_ARM64
+	return i & 1 ? 0x1000UL + i * 0x1000UL :
+		stackdepot_arm64_frame(i * 4);
+#elif defined(CONFIG_X86_64) && !defined(CONFIG_UML)
+	return i & 1 ? 0xffff888000000000UL + i * 0x1000UL :
+		0xffffffff10000000UL + i * 0x10UL;
+#else
+	return 0x1000UL + i * 0x1000UL;
+#endif
+}
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
+	for (i = 0; i < CONFIG_STACKDEPOT_MAX_FRAMES; i++)
+		entries[i] = stackdepot_test_frame(i);
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
+	union handle_parts parts;
+	unsigned long entries[] = { 0x501000UL, 0x502000UL, 0x503000UL };
+	unsigned long get_entries[] = { 0x601000UL, 0x602000UL };
+	unsigned long missing_entries[] = { 0x701000UL, 0x702000UL };
+	unsigned long blocking_entries[] = { 0x711000UL, 0x712000UL };
+	unsigned long fetched[ARRAY_SIZE(entries)] = {};
+	depot_stack_handle_t blocking_handle;
+	depot_stack_handle_t noalloc_handle;
+	depot_stack_handle_t overlong_handle;
+	depot_stack_handle_t plain_handle;
+	depot_stack_handle_t get_handle;
+	depot_stack_handle_t again;
+	depot_stack_handle_t extra;
+	gfp_t no_spin = GFP_NOWAIT & ~__GFP_RECLAIM;
+	u32 pool_index_plus_1;
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
+	noalloc_handle = stack_depot_save_flags(missing_entries,
+						ARRAY_SIZE(missing_entries),
+						GFP_KERNEL, 0);
+	KUNIT_ASSERT_NE(test, noalloc_handle, (depot_stack_handle_t)0);
+	if (expected_trie_pool_limit >= 0) {
+		parts.handle = noalloc_handle;
+		pool_index_plus_1 = parts.pool_index_plus_1;
+		KUNIT_EXPECT_GT(test, pool_index_plus_1,
+				(u32)expected_trie_pool_limit);
+	}
+	nr_entries = stack_depot_fetch_into(noalloc_handle, fetched,
+					    ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries,
+			(unsigned int)ARRAY_SIZE(missing_entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, missing_entries, sizeof(missing_entries));
+	KUNIT_EXPECT_EQ(test,
+			stack_depot_save_flags(missing_entries,
+					       ARRAY_SIZE(missing_entries),
+					       no_spin, 0),
+			noalloc_handle);
+
+	blocking_handle = stack_depot_save_flags(blocking_entries,
+						 ARRAY_SIZE(blocking_entries),
+						 GFP_KERNEL, 0);
+	KUNIT_ASSERT_NE(test, blocking_handle, (depot_stack_handle_t)0);
+	if (expected_trie_pool_limit >= 0) {
+		parts.handle = blocking_handle;
+		pool_index_plus_1 = parts.pool_index_plus_1;
+		KUNIT_EXPECT_GT(test, pool_index_plus_1,
+				(u32)expected_trie_pool_limit);
+	}
+	memset(fetched, 0, sizeof(fetched));
+	nr_entries = stack_depot_fetch_into(blocking_handle, fetched,
+					    ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries,
+			(unsigned int)ARRAY_SIZE(blocking_entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, blocking_entries,
+			   sizeof(blocking_entries));
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
+	const unsigned int nr_entries = CONFIG_STACKDEPOT_MAX_FRAMES;
+	const size_t buf_size = nr_entries * (KSYM_SYMBOL_LEN + 4);
+	unsigned long *entries;
+	char *expected;
+	char *actual;
+	depot_stack_handle_t handle;
+	unsigned int expected_len;
+	unsigned int prefix_entries;
+	unsigned int prefix_len;
+	size_t output_size;
+	unsigned int i;
+	int actual_len;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+	entries = kunit_kmalloc_array(test, nr_entries, sizeof(*entries),
+				      GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, entries);
+	expected = kunit_kzalloc(test, buf_size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, expected);
+	actual = kunit_kzalloc(test, buf_size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, actual);
+	for (i = 0; i < nr_entries; i++)
+		entries[i] = stackdepot_test_frame(i);
+
+	handle = stack_depot_save(entries, nr_entries, GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+	if (expected_trie_pool_limit >= 0) {
+		union handle_parts parts = { .handle = handle };
+
+		KUNIT_EXPECT_GT(test, (u32)parts.pool_index_plus_1,
+				(u32)expected_trie_pool_limit);
+	}
+	expected_len = stack_trace_snprint(expected, buf_size, entries,
+					   nr_entries, 2);
+	actual_len = stack_depot_snprint(handle, actual, buf_size, 2);
+	KUNIT_EXPECT_EQ(test, actual_len, (int)expected_len);
+	KUNIT_EXPECT_STREQ(test, actual, expected);
+
+	prefix_entries = nr_entries / 2 + 1;
+	prefix_len = stack_trace_snprint(expected, buf_size, entries,
+					 prefix_entries, 2);
+	KUNIT_ASSERT_LE(test, (size_t)prefix_len + 2, buf_size);
+	output_size = prefix_len + 2;
+	memset(expected, 0, buf_size);
+	memset(actual, 0, buf_size);
+	expected_len = stack_trace_snprint(expected, output_size, entries,
+					   nr_entries, 2);
+	actual_len = stack_depot_snprint(handle, actual, output_size, 2);
+	KUNIT_EXPECT_EQ(test, actual_len, (int)expected_len);
+	KUNIT_EXPECT_STREQ(test, actual, expected);
+}
+
 static void stackdepot_countable_public(struct kunit *test)
 {
 	unsigned long plain_entries[] = {
@@ -137,6 +360,129 @@ static void stackdepot_fetch_into_rejects_missing_or_short_stack(struct kunit *t
 	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
 }
 
+static void stackdepot_trie_topology_roundtrip(struct kunit *test,
+					       bool constrained)
+{
+	union handle_parts parts;
+	unsigned long seed[] = { 0x191000UL, 0x192000UL };
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
+	depot_stack_handle_t seed_handle;
+	unsigned long fetched[ARRAY_SIZE(stacks[0])];
+	gfp_t no_spin = GFP_NOWAIT & ~__GFP_RECLAIM;
+	u32 pool_index_plus_1;
+	unsigned int j;
+	unsigned int i;
+
+	if (expected_trie_pool_limit < 0)
+		kunit_skip(test, "trie pool limit was not provided");
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+	if (constrained) {
+		seed_handle = stack_depot_save(seed, ARRAY_SIZE(seed), GFP_KERNEL);
+		KUNIT_ASSERT_NE(test, seed_handle, (depot_stack_handle_t)0);
+		for (i = 0; i < ARRAY_SIZE(stacks); i++)
+			for (j = 0; j < nr_entries[i]; j++)
+				stacks[i][j] += 0x10000000UL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(stacks); i++) {
+		if (constrained)
+			handles[i] = stack_depot_save_flags(stacks[i], nr_entries[i],
+							    GFP_KERNEL, 0);
+		else
+			handles[i] = stack_depot_save(stacks[i], nr_entries[i],
+						      GFP_KERNEL);
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
+		if (constrained)
+			KUNIT_EXPECT_EQ(test,
+					stack_depot_save_flags(stacks[i], nr_entries[i],
+							       no_spin, 0),
+					handles[i]);
+		else
+			KUNIT_EXPECT_EQ(test,
+					stack_depot_save(stacks[i], nr_entries[i],
+							 GFP_KERNEL),
+					handles[i]);
+	}
+}
+
+static void stackdepot_trie_topology_allocating(struct kunit *test)
+{
+	stackdepot_trie_topology_roundtrip(test, false);
+}
+
+static void stackdepot_trie_topology_constrained(struct kunit *test)
+{
+	stackdepot_trie_topology_roundtrip(test, true);
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
 static void stackdepot_frame_raw_fallback(struct kunit *test)
 {
 	unsigned long frame = 0x1000UL;
@@ -205,9 +551,15 @@ static void stackdepot_frame_arm64(struct kunit *test)
 #endif /* CONFIG_ARM64 */
 
 static struct kunit_case stackdepot_test_cases[] = {
+	KUNIT_CASE(stackdepot_trie_max_path_roundtrip),
+	KUNIT_CASE(stackdepot_save_flags_public),
+	KUNIT_CASE(stackdepot_snprint_public),
 	KUNIT_CASE(stackdepot_countable_public),
 	KUNIT_CASE(stackdepot_fetch_into_roundtrip),
 	KUNIT_CASE(stackdepot_fetch_into_rejects_missing_or_short_stack),
+	KUNIT_CASE(stackdepot_trie_topology_allocating),
+	KUNIT_CASE(stackdepot_trie_topology_constrained),
+	KUNIT_CASE(stackdepot_frame_storage_roundtrip),
 	KUNIT_CASE(stackdepot_frame_raw_fallback),
 #if defined(CONFIG_X86_64) && !defined(CONFIG_UML)
 	KUNIT_CASE(stackdepot_frame_x86_64),

-- 
Git-155)


