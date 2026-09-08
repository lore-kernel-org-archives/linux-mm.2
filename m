Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D462FC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506966B009B; Tue,  8 Sep 2026 09:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF276B009D; Tue,  8 Sep 2026 09:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE6C6B009E; Tue,  8 Sep 2026 09:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 164556B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:14:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D080A406C7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:58 +0000 (UTC)
X-FDA: 85190637756.23.A74DD19
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf04.hostedemail.com (Postfix) with ESMTP id 13D844000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YtMKQGL4;
	spf=pass (imf04.hostedemail.com: domain of calebkan1106@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxLP4rXMEUOlBTXUJ41qDJ2wD0esY5E0fZn3mGsmNX4=;
	b=kOGPmLrvOKU5limzCyZI9XpvOP+AxgiTYyoyMhhyTuYEYEHdvIALeEvTw7MZrUgI4QQByj
	Q9hQnowl9m8Ea0getH8QbUSvupSEp/FfGo5WLR7gglALCKM3X1QqvSi8UDWm8IHhTQHc5h
	TtJoS5tUTurXCsqXcmlXDLsGaVqF1r8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YtMKQGL4;
	spf=pass (imf04.hostedemail.com: domain of calebkan1106@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873237;
	b=VE3emmhETUf6bKwQVmV8MgcRkTuIa+kYWU05+LV2WrVNabVXVOjx05a6BKfzzfTBqM63bC
	YDToQzkOT9ZU/2z2fMee2jy4rca9YJdnZJqm3yeWTpL70PYGRMTi+wDUoWEVaivSgW54Nt
	bw51nZLNm/t1kpNkCdCnjAtSFbuAEkw=
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a91e06e2f9so286605a12.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873236; x=1789478036; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YxLP4rXMEUOlBTXUJ41qDJ2wD0esY5E0fZn3mGsmNX4=;
        b=YtMKQGL4XiZxbqd+JuCSxNCMMNTVocqL5l2dVJ2LL8POcI9Wt5dTTk2HRUAo1Xt7ML
         aHsCZtlgKHmtHUksR/AX1/nVrHtmLmAAq1KgjMEqDLScaNt8IDBUmv2xM/arGG2LjMbS
         KwjwoTNHtEDhQvIpeuJgCJTqVtI7KJWhhi1h1ifXAJLJ56p34VjG6Y77mcJFmAnMAXDs
         a6ldPglvjsMYnCn9IrUSAy2wK5+1dzGVxWxYCg9unsLv1rySdR4LqJfHLJq4Gka2Mzbo
         Qbnvra0ajqAy7dKqOwh0wPckr/HNFEtyBeGPHczfwnPUhjrSiYxQZc2JjXBAuTNuexYR
         nK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873236; x=1789478036;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YxLP4rXMEUOlBTXUJ41qDJ2wD0esY5E0fZn3mGsmNX4=;
        b=bOqhDe+E6uUQTQVJ89f1m0mJqXSsjc9yyaOZrhAUXkLZVMAAgpOb1hPi59uwPodPjQ
         8L/yP5ZVVK4FF95CYzWoBdl0Ug3XaIfvNge/NssSqEsyLMvxe+9UJiDVPASX8cp+NX18
         KVLweiVv5jK4cDBE9CDPk2fNCGfZPOdinxfHZYILFAfycpdu2Jsx0jHaIfqz3HnMndFY
         fLdRpTdxmy/y40bPfamxJGJfNNDn5NcgOcnXsX6GKEx3EsA7sVR/KgR8bre+VR2i+xhn
         bMlWEne5HwfUUQb+h0EW10TnhA2EZDy0vewAtH0fRawNyHIu9GF7HIQo8KLHh2iX4mAS
         Yx0Q==
X-Gm-Message-State: AFuF++nZd88CPtcQAtEWF8bFBWBMWUrWHIB++ZaVeVXPXJnVb1l1s1QA
	rE4LzSMKCmtxbNF1UThXzpcNgWf5ILX1l9cm/6j8EGseGo60ML4jbQQf
X-Gm-Gg: AYBFou2pmeQ3mjxHMYYYZC0WDl/8e5PkNcH+2fNGiSyURHpj7TZVVFkuEvIPYQp+YqY
	9mFIl9RqvcGgGmS2MFLOQYk/vTOU9tlAwVzQC40js4DpZxrUWbjxcd0jXEqc891HmfFRv5ULrv0
	/Ag5Lo3atsovo07LcpJHbF7jBq5lJHFsIVpvBFDV2rkRtLcfgKksZeCxa4oZ2HQxYKihVrYu5xH
	EdOQR8wt0WE7+ra0d5kH0wSmqknGdi991xF+T+UkLQo7HamFB8e+QUlfVUkr/7CglS0NZTgWgP9
	TcqBkMez1HO/zShUN78c3mxyb5p9MzXoLr5id8+5Oh4IUc3PF1UuL/1Le74EilG91NZDYlmkkOb
	MIg8iZjjlgWXFobSqGHREOaUG5R9xYFxkzE+uFQksSRwzU45MbZKjiq5/+yxAPTDDvrSRAf7F+0
	bdFhXI27+EvzOBC6uIYKiGo8t2aHPezObzaNhx2lLbNKNC0qI9Kesv9lB1IF6T
X-Received: by 2002:a17:907:3f09:b0:c25:f7db:4bea with SMTP id a640c23a62f3a-c290446b88cmr319041366b.16.1788873235525;
        Tue, 08 Sep 2026 06:13:55 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:13:55 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:38 +0100
Subject: [PATCH RFC v2 05/11] kmsan: report trie-backed stack depot traces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-5-1996d5cef732@cloudflare.com>
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
X-Rspam-User: 
X-Stat-Signature: 8mm897z5uumukkyq9f1t4hohshd699t9
X-Rspamd-Queue-Id: 13D844000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1788873236-274394
X-HE-Meta: U2FsdGVkX19R+FleWZPOpJF10mRvjgRIBkWNGp9x7BbxGe43SuCB2uvZmlmH+kgkFL4p82VrbnZSn57L6bYKPhQJUpZmlTrCRUk9lbbuHhgg9YI6qksz6T+IM2m+rK3r2X9MYWEV4G/L8gQYGXKfDRMcMvvkCes8eym8FsqG3GGTR2AwMx1b7Pf+nrQX/yqFlZioI4AVEVzQ6Go6QMER8i3lbJmUOek3hm3xWOflTQWJMasGSfvie2uKXcPBFGD031Omcfmw/RzusMHLQclrMTLu80k8esIxk513ur7MvS/v9YIRubcoJnSYJHUEKqDDR/ifRv5DvCFyA/CeItbRI7Zv8uNhO7WJZAItSBKHoBK05ihRw4V1616aXilCNzZBCNqP7SaymSBLUChf6qty86DLzXfiZHpkhlCjucBY7St+j+EYmCUc+PsfjcNnmtrkKYoEFqE9/NEexPCDJqUzF2VaIlAW/g3qyvgnpka7K0uexw32k5nGUAWp3iciWUHP3Wi1LVquCWS0QGEkf2gOUybazBn4hqQCEXWVyPqT5KN72IB9ivvfnIMQbCdb1Qay/Cxk9G91/Iv2/klIV5/3IMlI+z5BoTVtnhaTm0s2QXDIyickNqLhrcKDE7V7NJYZZt+ba5hrisj5CurwVGIrijECxAbbnk+wRPnwRkTdkWiUppkfrbktyyQ/szFu9r/HPcku7JS9o9owvVrdXYNblkGPuAdiI5Q5Gw91FWcMwYbkVy33c0gJ4ULrFsFJ6r5vOuEB3B2DrgL7OW/09o9VUleoO1G/mtRf6ykRrzQzoHQ1a4xxAdtQryTnDg8kfV5BWM38Y9bgrTT+6gtgqA5Oin2PjObfspz4P9xB17mMD8uEDlZwGSlrwBPG3TTTq9iQYY3HPXxttWNiBaNeaQbnHc4zJ0+u+fFiBxEucSoYO6rjEFp26DpxN4sG14BKVz+z0gAScsmdu7O5gqZCvg9
 GrbTjpZ3
 CS6w0iCw9unIHy6TMnqBM4cdjh+sWQizjaehTioJUO9bGHVdqmN3/ukrcORw2xSGS/LRl+Cl49XyX9AGNdu8Saov0Hql+OQP2bVsCl44wDwGZ/7OhJbG9kBCtR9ZnnujO+7CI5ylI9oLaG0nUVvKsl1JOqoVN5Sic1yJl5SpNa4u1LQ0YznEn1No5aACFGPUFuFFmfnVb4hiIvcbBQcFoeG0wgS3V1EDWM6dD7XsqFKc7h80j7cONMFx5Jx+CVw5b1sxg0zeP522cTouc3T+ZNHkL0I28G2qzTbjeeyqJm8Ahky3pazgwJO0Xl/lzfEFZ/Z/n2BBQdXJ6JklALsSfM/mpGTFZBDLeZmzi47u8GreAn7tmms/gfBu3QSdRz4BXGk87h6lUK1mI/7M6BdM3IVYgtu2KYtppPYQ/oakWli+ukTZnyFIWXUeah2cDqc73wugKeE+rQW646RreM0Qy/Zp/xkdBhJRbi+Tx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

KMSAN stores ordinary origin stacks and synthetic alloca and chain origins
in stack depot and retains the resulting persistent handles. Once trie
storage is enabled, these handles can refer to trie-backed entries, while
kmsan_print_origin() still relies on the hash-only stack_depot_fetch() API.

Use one KMSAN_STACK_DEPTH array to materialize each origin and chained
stack in turn. Preserve the chain's head and next-origin handles before
reusing the array for the chained stack. The array covers both the regular
save limit and the smaller synthetic records.

Pass the scratch array into a common origin-printing helper. Keep local
storage for standalone kmsan_print_origin() calls, but let kmsan_report()
reuse its existing stack_entries array after printing the report stack.
With x86-64 Clang 19, the regular nested report path uses 752 bytes, below
its 768-byte size before this conversion.

lib/stackdepot.c is uninstrumented, so stack_depot_fetch_into() unpoisons
the successfully copied range before returning it to KMSAN. Remove the
now-redundant explicit unpoisoning of chained entries. Origin depth and
use-after-free metadata remain in the handle's extra bits and are
unchanged.

Update test_stackdepot_roundtrip() to use caller-owned storage while
retaining its frame-count and kmsan_check_memory() checks. This verifies
that the copy-out API returns initialized entries to instrumented callers.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 mm/kmsan/kmsan_test.c |  4 ++--
 mm/kmsan/report.c     | 28 ++++++++++++++++------------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index 31f47cc4dab4..7c04e4b21873 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -669,7 +669,7 @@ static void test_long_origin_chain(struct kunit *test)
  */
 static void test_stackdepot_roundtrip(struct kunit *test)
 {
-	unsigned long src_entries[16], *dst_entries;
+	unsigned long src_entries[16], dst_entries[16];
 	unsigned int src_nentries, dst_nentries;
 	EXPECTATION_NO_REPORT(expect);
 	depot_stack_handle_t handle;
@@ -680,7 +680,7 @@ static void test_stackdepot_roundtrip(struct kunit *test)
 		stack_trace_save(src_entries, ARRAY_SIZE(src_entries), 1);
 	handle = stack_depot_save(src_entries, src_nentries, GFP_KERNEL);
 	stack_depot_print(handle);
-	dst_nentries = stack_depot_fetch(handle, &dst_entries);
+	dst_nentries = stack_depot_fetch_into(handle, dst_entries, ARRAY_SIZE(dst_entries));
 	KUNIT_EXPECT_TRUE(test, src_nentries == dst_nentries);
 
 	kmsan_check_memory((void *)dst_entries,
diff --git a/mm/kmsan/report.c b/mm/kmsan/report.c
index d6853ce08954..0770658ba932 100644
--- a/mm/kmsan/report.c
+++ b/mm/kmsan/report.c
@@ -83,9 +83,9 @@ static char *pretty_descr(char *descr)
 	return report_local_descr;
 }
 
-void kmsan_print_origin(depot_stack_handle_t origin)
+static void kmsan_print_origin_with_buf(depot_stack_handle_t origin,
+					unsigned long *entries)
 {
-	unsigned long *entries = NULL, *chained_entries = NULL;
 	unsigned int nr_entries, chained_nr_entries, skipnr;
 	void *pc1 = NULL, *pc2 = NULL;
 	depot_stack_handle_t head;
@@ -97,7 +97,8 @@ void kmsan_print_origin(depot_stack_handle_t origin)
 		return;
 
 	while (true) {
-		nr_entries = stack_depot_fetch(origin, &entries);
+		nr_entries =
+			stack_depot_fetch_into(origin, entries, KMSAN_STACK_DEPTH);
 		depth = kmsan_depth_from_eb(stack_depot_get_extra_bits(origin));
 		magic = nr_entries ? entries[0] : 0;
 		if ((nr_entries == 4) && (magic == KMSAN_ALLOCA_MAGIC_ORIGIN)) {
@@ -123,14 +124,10 @@ void kmsan_print_origin(depot_stack_handle_t origin)
 			origin = entries[2];
 			pr_err("Uninit was stored to memory at:\n");
 			chained_nr_entries =
-				stack_depot_fetch(head, &chained_entries);
-			kmsan_internal_unpoison_memory(
-				chained_entries,
-				chained_nr_entries * sizeof(*chained_entries),
-				/*checked*/ false);
-			skipnr = get_stack_skipnr(chained_entries,
-						  chained_nr_entries);
-			stack_trace_print(chained_entries + skipnr,
+				stack_depot_fetch_into(head, entries,
+						       KMSAN_STACK_DEPTH);
+			skipnr = get_stack_skipnr(entries, chained_nr_entries);
+			stack_trace_print(entries + skipnr,
 					  chained_nr_entries - skipnr, 0);
 			pr_err("\n");
 			continue;
@@ -147,6 +144,13 @@ void kmsan_print_origin(depot_stack_handle_t origin)
 	}
 }
 
+void kmsan_print_origin(depot_stack_handle_t origin)
+{
+	unsigned long entries[KMSAN_STACK_DEPTH];
+
+	kmsan_print_origin_with_buf(origin, entries);
+}
+
 void kmsan_report(depot_stack_handle_t origin, void *address, int size,
 		  int off_first, int off_last, const void __user *user_addr,
 		  enum kmsan_bug_reason reason)
@@ -193,7 +197,7 @@ void kmsan_report(depot_stack_handle_t origin, void *address, int size,
 			  0);
 	pr_err("\n");
 
-	kmsan_print_origin(origin);
+	kmsan_print_origin_with_buf(origin, stack_entries);
 
 	if (size) {
 		pr_err("\n");

-- 
Git-155)


