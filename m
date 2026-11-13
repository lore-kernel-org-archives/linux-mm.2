Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928C3606F2CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=d6A95ldW
Received: by kanga.kvack.org (Postfix)
	id 7A2ED6B05D7; Fri, 13 Nov 2026 13:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759AD6B05D8; Fri, 13 Nov 2026 13:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4D06B05D9; Fri, 13 Nov 2026 13:57:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 388E06B05D7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 603EF160186
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:14 +0000 (UTC)
X-FDA: 85431003588.09.1DC6239
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DB8F40006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=d6A95ldW
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMKilXOc8iF9aDdrmQW0L2QZLW9z0erSCAgXdVbBET0=;
	b=svsZHDGmc7GH2bW0kkQoZZiJVy8/w9+Pbf1DY4csyHrbGe5qz+u31JtqpoT+0F3hMOTtWO
	K/8rDB7ihu1BZvjucNcRtT/yuiuhoj2j/ZPqG4vCQqUb+XWFUMtP6lYh/9Cmybopy4fZiN
	PKRpWWG/hRRTeZX+YslaLsvcx+Gnjzo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596232;
	b=UwJC0NhOjJDDuN/nViW6rtIPVToVqN2VF07adfCqNaU+1fbnZYZLtc72qsLxofb9lreO3l
	Jc/FvzH760qcBp/taB3RTqpW8x9bScR70aByr4XNbgJ87zeUBpFmxPIcLSBCC6ei5HfKSN
	5RqwfF7Db4T41NobioEeNx9iI/+Z+X0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=d6A95ldW;
	spf=none (imf01.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.45) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so672278f8f.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596231; x=1795201031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eMKilXOc8iF9aDdrmQW0L2QZLW9z0erSCAgXdVbBET0=;
        b=d6A95ldWRZL5nnVWjsR1TKIBcSQtTUa0pJkyDoW9yCoxpbkBr4InqpmL8RnjfWiCEe
         b1Qdd3LgQDTAZV9ygLpAMNdu+rljaHjvAGfzE+TcJXlfqKxEgRDhrHysVgxEovc/EXSP
         yVcXCJJtvxXTJYhw8Amk1hPivse9V6nv5zxErfBetlXUqT3q9urP5FEPolEHI/AuDg8W
         Ys1biLiOCi6I7PE83eiGLCMhTztwi0l2+0Ziww00YIY0m2pVHvfxNO6NKEqovn2NdatD
         nwRhC3uyN9l3gp3Xxlfdqi3Y2ITzY1XMfsZ79JWYgwlhaFd9ubQW2cArlt4dALzRCTjw
         SfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596231; x=1795201031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eMKilXOc8iF9aDdrmQW0L2QZLW9z0erSCAgXdVbBET0=;
        b=OYU+8nX0uKu35vaDqWWEqywTYKm+mSf0NIWXbNQ0EwLnsMXianPxXwZLsWdfWgJV7g
         c35GmZrsJksR7R0hCiZDCn8c1/5jxC785uHuDQ2tJUZKXcdjwF6DAwLyKqUjEANkw2jH
         yZZSJIYrP5Jzc9xII6ZAUKOWhS3BDhKfKeOyGyN1uNdXodm/RNdhSUbPRRa/+GtJeT8o
         lJsk5NUe/yLM9WXNazOzUvZNPAZJBWYvQlsiKKtw9APjqAVIwjphjlMWhIdsRo9jZMC7
         +ihdGSrozOJF+pG2LhO8ZMHmrLeOO3exj6Zyq6+3pK4/9SBHXvT5aMBGj+pe11aD3ON/
         POCA==
X-Forwarded-Encrypted: i=1; AL+hErHbWosoP+i2jqPd0LGQdTiP5jWvPoyC/EQ9aumP+/aLv0qaDJ8ord7QQJqTkjwU4M0+yNNGBxGsXw==@kvack.org
X-Gm-Message-State: APuU4Z8mmZ55HBlR2nruM1Je5hm9FECx95j2/BqT+Zzk0R1ML6Zk73aD
	St2+2AXKdjvbWWzWyEg/7vgVoMcIemxF8TqDIWhTbwfrWno7A6ny0ILR3LuteLveS0Q=
X-Gm-Gg: AYBFou3vr1H2GqNXGTEZm5zHjal6A4wsUshm9e6UPl1HfzhqCjbGD6zVhhLzPA54/vA
	Njp5cxnnkpFGs1IGINoZTh0OLH1R8yh6k0jyfFug5klArs9/hem2brprF8Ohfd5lytDtVs2rR8E
	NzA43GIJxW61Kj7ZUdP9t3jvGJv4fB2YM20R+AgVuTvagUyqRbvL+PoYJ1cotLtcQd9GfuzZROo
	0bph17sAR0Yr0w4yANNyWeU5bm0zb0lv/I6pkJQxdDT0GtYDjek1x65V8U1zXLojVA8zx/PrBTq
	JEgwX4iiji62qJA5bj/IjJq32iwjU7IWwOjQzg998Vi79NE1Vex31HMYJ/Sksx5Ma7l4Y+864Jf
	7YgVkZfCnVK0PpBZrMP0g2zcDL9xh+ZOcqCQi838aBx2E0NJik3CGSczRGadCpvLJINVO0pYn9y
	bzv32/Kt8iPp2HbcpkWAfbeHzGarLAAfpyncOjSvrejOE+6goIAvp9bQ00r1phq/ZI1anu/Z4Vn
	80And3Z3tjAuCeijauJJOiNQDhst219JFyJvVCsMvwEYqnbJJU2INbT/voxmGlnlpkZ8sJH0zho
	mvNz+VSp0V9IxBVhXCEjXnhyjeAdsA==
X-Received: by 2002:a05:6000:2204:b0:48a:f59f:8b70 with SMTP id ffacd0b85a97d-49c7467aa37mr8267530f8f.46.1794596231138;
        Fri, 13 Nov 2026 10:57:11 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:10 -0800 (PST)
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
Subject: [PATCH v3 03/10] kmsan: use stack_depot_fetch_into() for origin reports
Date: Fri, 13 Nov 2026 18:56:55 +0000
Message-ID: <20261113185702.1332171-4-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: m3daifnzxkeekdek5hhayyk9gmwskk6o
X-Rspamd-Queue-Id: 6DB8F40006
X-Rspam-User: 
X-HE-Tag: 1794596232-637205
X-HE-Meta: U2FsdGVkX18nQHdr346W6YI+lBK4LLtKVQb7ZsUahSJXmvIyh2zAzRhEuCp3cI9YSYHzFJlVM8X0EsAQwdyhvYBD4neOj2euEChZLA5+AoSq0kgeOnmRMMO3a+KtSGycTqIdxy9y4xLubEOELa7nAwS65XhbbtXxBGxrfAyIuFHTX68NI43xq3voQNFbfagOl/X06vkQphNvLOnwnbc5W9I/v1qg50dQjlkoSeCBA28McWacrVL6sVVQ991/SBbQLXIIjQ9hM39M3H/lZsyOZy4pewiwNJdIW2nhS5Ttvu260nTkdi5ZMsWy2ujMKDGQ1x7JtxkDpZg7HALaO2bGxv48xz8UpClU5zDG4vhGqwHbEK1iQWXqdlY2M2Ai5HnsUSdDOy9yuaVJCUEtDTex8YYvRi9MsKszwy+1aED95QdudiVhcxeiZePvJnWMZ7TIwsIfEbKFblIBuBImiBayALYn8XqluLVEQy1Z+iYn+XQ+zR+mFKcER+zZurJVgyX7TI63l+LivPpokP3a6oJnGf4zhlz2vKbJO68dZZ9qMacIMwtygNZtYUhTOJTNOEWt4m/o84HRqfMNu7Iz6npjkr/1W2buFp8W4atD1Z4Ej35cnN6nJmSUpkycuo70TlfTCMwd3CEynnmz3QpvPqsJL8Fncmd3G4ig4eR3VLnM8zMn8olBEhmkOsYDSn1F4kmPKz+2g2pLqTVYw/sBJq7cDN47Jh/xts7yXG+zqUcsiB6t03g385DJLb8xkuRxwsxNKWY6Z0mmstMrckfgHMV6D93etnHYGYxd0D5UJVwPvRscnGan8Khsrqs7wjRrblRNMEVbN4YKVizhWclx/8W+GlGA67GOzFtjWufedBi8OjnOsGI64fN/uNCSICx9BjbeBKa/A6Qc+TaYQ5uu+36eQMHqc1Zac3z4i7OzkEJCIj28QbcqEA7BPcarIR6taPkTh31lNGPip+FbyurWukW
 PRlGt9gc
 p4Qd1SiH+zdTMHog0aRdEze5lmoRl3Brr2ozPFt42MJSrz/RDnZdKE2eoUQUBAZqD1oMDM8thgtwn23bhvsxoqHInjD4CXJtdBz5cws+Bs3ZEExCQOKkMsIf8z2DoxxcTV5hOSJXWjZE0QeEVJ3QJlHWip3447vPNWWh+LLhuKbLbvlH6ZVN4ESPmD23E+u8cR1RqQGdM/q17wkB91mUpX+3F4L7NbuS0DP4nwLhxqwMarNwUlHHUTIZFmoBdWIhRZ0MVDms6/zDPUaFmnn9xKVJRXRuie+6C4N/Vo6PmjWxHHGmQs5Cx99PdwWLbtU4OqjN/ipuPJOJWtzahL+Z/86NpVv02Aal1lqg4eD9gP8teiOkSE/e55Vav/rHpYozZ7RlkyEiVnfWQstm6F4WQBcSpCAON0u1FVXN1JfpujlvZMdn+hbKQRgponnq7S9lsMw+J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

KMSAN stores ordinary origin stacks and synthetic alloca and chain origins
in stack depot and retains the resulting persistent handles. Once a later
patch stores compressed frames, these handles can refer to records whose
frames must be decompressed before use, while kmsan_print_origin() still
relies on the pointer-returning stack_depot_fetch() API.

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
[mfleming: reworded for compressed frames]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
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
2.43.0


