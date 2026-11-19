Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6AD606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XhZwHJGv
Received: by kanga.kvack.org (Postfix)
	id DFDE86B068A; Thu, 19 Nov 2026 10:32:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFC26B068B; Thu, 19 Nov 2026 10:32:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6306B068C; Thu, 19 Nov 2026 10:32:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 967556B068A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E23C61C4549
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:08 +0000 (UTC)
X-FDA: 85452259536.25.0DA11A4
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 012ACA001F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=XhZwHJGv
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMKilXOc8iF9aDdrmQW0L2QZLW9z0erSCAgXdVbBET0=;
	b=meh4FLyK1zxhBr3VXM/UqMSbxt8Ua9+OIgIqM+NWHawbFQzAbLdcaV7u5w/uPOJHQarm3O
	iQYsyoE2ZiTF8CLGOOuf0jhUA37UVEadEGPTnD6m+83OTT/mTfPREMRksZ6lCBlWiLE4ST
	6nllDxSBWtVXD0dR8MdsfiYkBBbzDRo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=XhZwHJGv;
	dmarc=none;
	spf=none (imf15.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.52) smtp.mailfrom=matt@readmodwrite.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102327;
	b=Yr46Ltgv/7IzzIcFcj7WC1UGsvqi0cyjvmU3RDKI5Z1bdPsMkeXA+5H15qF4Yez+PqQks4
	ezPhQAIhXfLYGFbBsSYSSS6EUcuZ7e/GpB6+2EG3DEK+LgiEq9PJtRnsT/WRMK8h1kizXU
	TShR9GwTon2hrCGammG/2u90R8KcXZQ=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4aa5833c263so607786f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102326; x=1795707126; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eMKilXOc8iF9aDdrmQW0L2QZLW9z0erSCAgXdVbBET0=;
        b=XhZwHJGvWs6SEl2NFtje9czDKD+v+IttHHYBG2hx9pCbI+honQrZIULJeI3tR5KFzl
         ztlFliTvW6GA0W0kzgrbpLLNNWqQp3ClmWTmvqnmJgGvHNQ6ktkW0Wsk6JVbbKDalesZ
         H+aVdTMWm1z5IPjwALTo8ajYUpd6+s7U8bcDakOfvWq6WCzGcIINHHBX8HQ8ce0BYHw3
         0gUho/82bV+Ytt1isVpg8epSOSNcjkTptB+17Gj02fvOGD9LHWxJSdgL43PCCBwMe0yw
         dGObN5ea61kABOf2dXiEPRpdq8WrC6/0OHPbNEX+eeMHJfrTDG2QOyROSZwDgO/6FzEO
         9JqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102326; x=1795707126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eMKilXOc8iF9aDdrmQW0L2QZLW9z0erSCAgXdVbBET0=;
        b=mpSsInrHs+rCAhrApJcccpLbyoOFF4gA6OzIGC39ZKhFE/gZqw2mmEqqKdB9mqPJ8f
         m2TbJH3XfmfhEk1UNznlHZ/okDoaQWGwVJFkunR91YSkZJ5ZigdeicvRhKQ36UvV8p8j
         4STXYt90wu6+pxyyyCRhRO2Iykl6WCEQ90HN9w6mKqUg+UAw7X2fPJ0vNGaBKjxyLpbC
         Lsop9dTynyJSPff8saW/JzO4wFKN33hxFeqkdv4wRgmcZjMmlhfIGySA3qfnSL7OfoEx
         UaiEmyXu2P+4Nkv4pjqUzzCI9aYox1xYUcdlMPtwNP20dDrhu/Iz8fYb/1JZ+ya3IMzp
         fr2Q==
X-Forwarded-Encrypted: i=1; AL+hErFRWTbH5w5jrtZ4eyE+qJJ7AxD3HnPDlQnwuGuyq1ZZ5LXN6XFu5YYrwWRzS8o5HoiqdBMAk7rHUw==@kvack.org
X-Gm-Message-State: APuU4Z8qiQzs+Zr1qiDfcmUoH/1rYb5J4pw89ikaXR6iUjFDdhbmqRGn
	eNe9q6aaAWRO+95KrAoq//HiAP9FoJvqnxBDXwuHDsmOPtOk5BkMFQPDLP+HKp8Y2lE=
X-Gm-Gg: AZFdTZemQQLuedL1IQjlWNrx+cc9pEyRS73Ffrz9d1udGW8tqxNRTQoOOdjIAV4Ysrj
	do9Lrdd28m7Y5kERss6IePrmMSCWjhSzuZWdf08UEbsCxC+0zNoT1OFuu/tVIbwkZFca5mlU7yo
	todpixnfvwBKgdVEgaVahoqWI3bmVIlQbMNZ57arkL3zWv+ZZ+W21LGSL9D8XkPqofrD34UAML1
	yUC/OXoBAF8MAdFzAW3EohrkOIfMzaFP5H5Uez59SjI3IwKdNnciCZtfH7ifiWjaafuql8tjs11
	HXvUBAy7iyMlWH86DBq0279V50mb97VNHegcZLrNFUTx2XHo/O1759c3R6v+v5kOtzZdwWCFswp
	IWs2qnXjLA8CGIpwzcELy9kylG2Drm9kSVtABsl4WgRb4G845srgmHfRwUvoW5dRGoaWhmFqfV6
	18fpF+SsmKO8R9S6/x450cdsaLdAEL9PJVKPWEtE9uWElo9GO35qP2osGQcCYn13QWsoL/m2oBP
	e0OCgf8NENjvNH+xlvNqxB7jMZgbf+wG9Hip5BRZvZKQHFL8TFv43ogN6yN30l+vOaoFnNO82nV
	DLwG3pJ4PHw85xYX98JPD5dm77fD6do=
X-Received: by 2002:a05:6000:29d4:b0:492:ac00:b3b7 with SMTP id ffacd0b85a97d-4a63928a279mr8773276f8f.27.1795102325605;
        Thu, 19 Nov 2026 07:32:05 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:05 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 03/10] kmsan: use stack_depot_fetch_into() for origin reports
Date: Thu, 19 Nov 2026 15:31:36 +0000
Message-ID: <20261119153143.4099483-4-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pg4h3ncngg9kqfh7gk4p64cw1pwq6y83
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 012ACA001F
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795102326-42887
X-HE-Meta: U2FsdGVkX19JThmX1T/5In3vAhkoxI0jnoa8DIWujOL+SQlTSU6rNfC+0FkKCVC7ivfsz0Z+IhlVUdtewLdZ5kx6XHzWpRDxSS3QKwgGgXd+Af7OmDhI0QDQUbu4cNC45pUxtdpueFyRpLW43Wpmc5ZgQM8oBBgVDf/qzCxmvJKw6buTd5PLhfhSWUBd0mD88TrdoXcCLEB09NVhmLVrTPv88GQVETtKnilWJZQjhV3Er5JkrD5vs4RNSCpP/Dw6kKmPNa/nsZr5IoKfyQsq95q3qWEeHkw2LVMv/vrtdaVKAg/8fZmFYomf3NCXqEGkl6V7k3MKygvpoioc4Z3qQhybqh+wMs2yl7+PYtheesN1FbmZikrWZWQSMd50LUw2MV0o1EqRxqFYxXKuyowfJ4mz8P9HsOW5dGs/URM40GUllyRc/Czv6e98w1/MKAHyf/aGAnoWSKq1sGEiUDlJLB6/lvXv8FkKv2/g9oNT9RS48C8ri4HIyd4LuG1v+zkmCWEX7qgoBUmGuWFEOkpvJBq/2/MpcAQR6iNLQWhB/AWl3K12V32jq/cN9jORY9gfHElIJ9dQBVF9fgpTOv7FUTdkCkMGEoayFPcg5DvPZc0wu3EsXFoAWlbQ9nkCX6aho5ZzGUYJAVj1ZvW82LjihiaMPwYt4fXYi8W7GyB0HkzBNRYg2GB0aNdivhn0fLByGhV9NbdN5sOHeudhAfuWjDxYrivSy1Jzm6dPG/JEqWZbEqNjNUnM3/Il5ihBRiOq5RBDNiN83bZw4lg94Wlv4FypP/SVv/jJ52zRYgRjeJiymjJ3K3jF+dVO6ZQDRdGoINGdDU+KbTk671b2ay16PCZ/pRYOjjDU7/Pubvvhalxj8NnzVwxu51GPtrkSTDwGKUUbqqSiwdxDyM7eP/Xy00DMgw8Zyhhi2XACaRaFbubRF7CBUHs90i7bYib+KIyNt4ePqXRuLj0VaiNh33j
 OruQ3IqG
 7COoT1pIhrwWHeNTANeadFrF9U1RVsDyMDYrhjNfi4ms+AGw24U3oG8vevVmLx8hhslAjhyyBNjx1wX4rF1p8riByKHFhbQgbf8GXD1BB9Cs125baMdOIFiRcMsbo3rImTAEt//Nf9HYvlgm9HdZ5ReHp+eaxd/HipdDQOBQuZ8eAfgl2HTk3MrIE+fnzpKO0odLrnxz/dXQXC1490AcTXxXxOl21+0gUEsYj+heETBelsK6aP4ezI4d+naW172MS6GWbtXQOM67zb4AvouXpioaz6WFYCtBmOR2DO4Z6fTgDMdC1zwoAQ4CDUGJ527eu3Kss84aJDchtgk0fICg32EgbPkyUJcoUthGnx3CkrdXXBf7mt2p3vP3GjVTR7zeTn43pXSBGVaY+HF3KEU6tZBZRyt1EDM8wJp01zkq9+DZvl7vZD4I8DytxSiiCObt4rKIF
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


