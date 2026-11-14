Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A11A606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=cmG9Ke6G
Received: by kanga.kvack.org (Postfix)
	id 386626B05B7; Sat, 14 Nov 2026 11:47:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336AA6B05B8; Sat, 14 Nov 2026 11:47:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274476B05B9; Sat, 14 Nov 2026 11:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE7366B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 710DD120480
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:20 +0000 (UTC)
X-FDA: 85434305040.13.53298DC
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf06.hostedemail.com (Postfix) with ESMTP id 00300180004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=cmG9Ke6G;
	spf=pass (imf06.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794674838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lKD0U2CuZDhQxNZbru0tthW0rYWxO15r0jmxh9WCA6Y=;
	b=kVWZVvf4dxV5TTSsTJ6cvhlLjLJMnO9KsXfrFC8XxFun1GcwhLKBFO3C6CNJiXfQNLwDGv
	5DnUX3LU/+pRC3rISFdL7Q3l09bAR4oRjT56t8gmydlB4JXoOKqZUdEwqPIElKYT7vu/SF
	CdMcRvElzOBm8SSVvWqntZuqyR6y4i0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794674838;
	b=Ooz3X2AKEoEy4nCTXyRdh+Bn7GI91jF3pE2H4Kc1W7hI2jEol8RqSpIx0BwAEEVzk00XhY
	h+pJY61MP/C7Qm1CXoIFKe1jCJ+XgTXpMPjWeh4+5L0V/lACuCdSmldrq/+nDS2SM4bwu0
	8Es8hOlGSkHIgg0+LY8i3Fpu3wIjQWo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=cmG9Ke6G;
	spf=pass (imf06.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jRg5b6L8sz8Xrr9;
	Sun, 15 Nov 2026 00:47:15 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794674835;
	bh=vXZ7ifNNDA+zvjg8BaDg3JPnpiyXNI5kp36x0qW2fkU=;
	h=Date:From:To:Cc:Subject;
	b=cmG9Ke6G4eshwup+LWfSSpP2VCA8eeh+VLwv3IPq34kr/4QBfv3JR0bp1u8C8R2+L
	 WNGKsYnZpJNvPavNo+2h3pdJY2MYPB7+bAQMVQLhFsmsgjLl1+n3c5dKvaaMx5ZwiF
	 aH6cHzKoYHQJnw5x6OXO2oKh/lq/YM1usQqB/iF0tfB8XTSWpridW9OsN3LrCfnP3L
	 Wc5DM4MrD1Sxl46I9REuA2xs9lw9H8BahQOKpYfYCdBxWqTq+XTlTOt71lWkNjcgSB
	 Y2bDVMcWyohsVYSiki6HgIDswq43dcmKNntpI+268dTFYuGyK4JM6XnWNykVAjaMrl
	 2r6uF68tFB1qw==
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 6AEGl76a094707;
	Sun, 15 Nov 2026 00:47:07 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 00:47:11 +0800 (CST)
X-Zmail-TransId: 2af96af8908faa3-34a6f
X-Mailer: Zmail v1.0
Message-ID: <20261115004711126EXlXUnHk7NZz7rkWhDkyP@zte.com.cn>
Date: Sun, 15 Nov 2026 00:47:11 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <surenb@google.com>, <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>, <hao.ge@linux.dev>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbTogc25hcHNob3QgYWxsb2MgdGFncyBpbiBhbGxvY190YWdfdG9wX3VzZXJzKCkgdG8gYXZvaWQgVUFG?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6AEGl76a094707
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sun, 15 Nov 2026 00:47:15 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF89093.000/4jRg5b6L8sz8Xrr9
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00300180004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: hyfk35r5ag18fnqte95mdxdboo67bpsr
X-Rspam-User: 
X-HE-Tag: 1794674837-991991
X-HE-Meta: U2FsdGVkX1+Mw6SY/0feFtBLAb3crXfC7V6OS5fU8pTCeUfwDlpdF446TxP27Fb9u2hrDGwe/0+rTaVRTAHEtOqVWBTpN+dVsFVVKE02igFHE5CPAN1CmWf5ScRw24l6ZpYAwRs0ctT/YUzfkg5HMVpLirLUfO9nM71PctSPUXUY3C01jTETFDpANXjfU7x+gkiBtnVbjf8GLaz+HZ8jhWTZ9lz3pvFHAqZY9JBRwzopoEbSJ2FDcWNBJijJRQ7FiFNjYAwGowb5gMK9uCrAw9KL9r0+tAgIBbsUUom4x1Xf0PFjRuBakT95KdRz0ku4OCzvjRI/SZkqDGCFuq4kApQVGnbt8XElNAC3TJ/AgM5hzmzhusMQoSIaeg6crtnShefF1htsJWau6q/E8qYjf2GFMXFFQTT9HMz4NJXxBHFKRVZaq9h23MEpJQhuX5rgNyBlyNhJSLENDOGLoLnWnNXTH1+0r8yaQI2E71XNcelBcr7d9RI0bcX8CWQTkKXX6RAATwZN9BkRf4nWtL26Aj9GkPOfMdwSERkcwc3PK6Q7dswx+sq37lA+Wgw3aHTI0mufvnSSgPqTIwPWQMMoRyyrbJfiRSw+NQa64KM/WIHb3uAsLY5NKyv6XX2eIn22gRglPr53vNfJMe6fIEh+bQuUKQaRMX8MxdHOBwstkPpGjAy6BuS95Z2P/Ot4SxfV3Srke9MlA9Tro9IlCcIYyHqcpys3+6InTZkjMxZh9GhQeUEqueAXANpFXw+f7XZohRTeFZhm9sO253YneUlJHA7kvdWW0C1FO9mTxkEHyj7r0SIGO8ZOT4k1nLZspJ+I0EJGJEek9qoF/uYhiGRsX/a40W/k2ZDXkHH/aGDWTTfC5rvC+Zeedv4VgRxuP8+XUZYBaAKM134Ei7+ifYY3bpMq/Pj4WLx6Za6cEo8KNgAB5hZyyno1qFfarxSG3hN08lN6DGzT5ypbS8EAIkT
 GkHn5pWS
 v+YddTGsIKp7ShOSNhkhvsQrqp/32NvYQEhs6Oomrwgrrdn0TwxkuzP8S3PQlME73LPckZXjXicsfthVSSlQnjAkRT+JFbrSGGJXyMYhIeMj5x6lTuiLlvrfPu6iM7AcGbtu0GDk48FYRZy/TYmeP/YG178d+OWrckEhyehkQzaW81vVtddhbKwUZ4i4bFwMf41d7lvUmuvjrAqBcMxajHzU3zSPXiRGjdpG7EqyrDwkojnLE5FBJLuD9pYwRCYf7UdpBk2PpbwER/9O3nQAkTYFV/W4uCuuZlb4FadXwogmGVf+o5vkiYDpIznVNAM4UEYTqx9na3ign8ZbJied53WgoebQTDLWxPhKmOeJqGIjcnVzLHByG1QjUpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm: snapshot alloc tags in alloc_tag_top_users() to avoid UAF

alloc_tag_top_users() selects tags under the codetag module-list lock,
then returns raw codetag pointers. __show_mem() dereferences the tags,
their strings and per-CPU counters after that lock has been released.
Concurrent module unloading can invalidate those objects before they
are printed in the OOM or SysRq-m report.

Copy the selected tags and counters while holding the module-list lock,
and print only the copies. Reuse allocinfo_to_params(), which copies
names into fixed-size buffers and retains at most their last 63
characters. Preserve the signed comparison used to select the top tags.

Keep the larger output array static under the existing show_mem lock
to avoid increasing the stack frame. The counters remain approximate
lockless per-CPU observations; the copy protects object lifetime.

Fixes: 1438d349d16b ("lib: add memory allocations report in show_mem()")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Build-tested mm/alloc_tag.o and mm/show_mem.o with W=1 and
CONFIG_MEM_ALLOC_PROFILING=y on x86_64. The lock lifetime was reviewed
statically. No module-unload race was reproduced under KASAN.


 include/linux/alloc_tag.h |  9 +++------
 mm/alloc_tag.c            | 17 ++++++++++-------
 mm/show_mem.c             | 29 +++++++++++++++++------------
 3 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 9e42f23577b9638a8cad3ce42db7c7a2fb1a3d5a..018dbfc9db12e178c50ed0a67063db4e024bfccc 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -7,6 +7,7 @@
 
 #include <linux/bug.h>
 #include <linux/codetag.h>
+#include <uapi/linux/alloc_tag.h>
 #include <linux/container_of.h>
 #include <linux/preempt.h>
 #include <asm/percpu.h>
@@ -76,12 +77,8 @@ static inline void set_codetag_empty(union codetag_ref *ref)
 
 #define ALLOC_TAG_SECTION_NAME	"alloc_tags"
 
-struct codetag_bytes {
-	struct codetag *ct;
-	s64 bytes;
-};
-
-size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep);
+size_t alloc_tag_top_users(struct allocinfo_tag_data *tags, size_t count,
+			   bool can_sleep);
 
 static inline struct alloc_tag *ct_to_alloc_tag(struct codetag *ct)
 {
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index e9b70268eacb046f429107dc493cb5ade3620690..fe8269694c7dbc68a0c7188dcf87b3bbefbfb751 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -610,11 +610,11 @@ void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag,
 }
 EXPORT_SYMBOL(alloc_tag_trace_mem_free);
 
-size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
+size_t alloc_tag_top_users(struct allocinfo_tag_data *tags, size_t count,
+			   bool can_sleep)
 {
 	struct codetag_iterator iter;
 	struct codetag *ct;
-	struct codetag_bytes n;
 	unsigned int i, nr = 0;
 
 	if (IS_ERR_OR_NULL(alloc_tag_cttype))
@@ -629,11 +629,8 @@ size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sl
 	while ((ct = codetag_next_ct(&iter))) {
 		struct alloc_tag_counters counter = alloc_tag_read(ct_to_alloc_tag(ct));
 
-		n.ct	= ct;
-		n.bytes = counter.bytes;
-
 		for (i = 0; i < nr; i++)
-			if (n.bytes > tags[i].bytes)
+			if ((s64)counter.bytes > (s64)tags[i].counter.bytes)
 				break;
 
 		if (i < count) {
@@ -642,7 +639,13 @@ size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sl
 				&tags[i],
 				sizeof(tags[0]) * (nr - i));
 			nr++;
-			tags[i] = n;
+			/*
+			 * Snapshot the strings and counters while still
+			 * holding the module list lock, so the caller does
+			 * not dereference a module codetag that may have
+			 * been unloaded by then.
+			 */
+			allocinfo_to_params(ct, &tags[i], &counter);
 		}
 	}
 
diff --git a/mm/show_mem.c b/mm/show_mem.c
index b938cbcd774a1e2ec732f8c3703cae0dbe57d488..8d99a809f27fa9ca40a5184770ad0ec5b43f2aa1 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -436,7 +436,11 @@ void __show_mem(unsigned int filter, const nodemask_t *nodemask,
 	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
 
 	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
-		struct codetag_bytes tags[10];
+		/*
+		 * Protected by mem_alloc_profiling_spinlock; kept static to
+		 * avoid a large stack frame in this potentially atomic path.
+		 */
+		static struct allocinfo_tag_data tags[10];
 		size_t i, nr;
 
 		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
@@ -444,22 +448,23 @@ void __show_mem(unsigned int filter, const nodemask_t *nodemask,
 			pr_notice("Memory allocations (profiling is currently turned %s):\n",
 				mem_alloc_profiling_enabled() ? "on" : "off");
 			for (i = 0; i < nr; i++) {
-				struct codetag *ct = tags[i].ct;
-				struct alloc_tag *tag = ct_to_alloc_tag(ct);
-				struct alloc_tag_counters counter = alloc_tag_read(tag);
+				struct allocinfo_tag *tag = &tags[i].tag;
+				struct allocinfo_counter *counter = &tags[i].counter;
 				char bytes[10];
 
-				string_get_size(counter.bytes, 1, STRING_UNITS_2, bytes, sizeof(bytes));
+				string_get_size(counter->bytes, 1,
+						STRING_UNITS_2, bytes,
+						sizeof(bytes));
 
 				/* Same as alloc_tag_to_text() but w/o intermediate buffer */
-				if (ct->modname)
-					pr_notice("%12s %8llu %s:%u [%s] func:%s\n",
-						  bytes, counter.calls, ct->filename,
-						  ct->lineno, ct->modname, ct->function);
+				if (tag->modname[0])
+					pr_notice("%12s %8llu %s:%llu [%s] func:%s\n",
+						  bytes, counter->calls, tag->filename,
+						  tag->lineno, tag->modname, tag->function);
 				else
-					pr_notice("%12s %8llu %s:%u func:%s\n",
-						  bytes, counter.calls, ct->filename,
-						  ct->lineno, ct->function);
+					pr_notice("%12s %8llu %s:%llu func:%s\n",
+						  bytes, counter->calls, tag->filename,
+						  tag->lineno, tag->function);
 			}
 		}
 		spin_unlock(&mem_alloc_profiling_spinlock);

base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.43.0

