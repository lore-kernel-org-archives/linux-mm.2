Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED25CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8CC6B0093; Thu, 11 Jun 2026 02:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B59A6B0092; Thu, 11 Jun 2026 02:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090086B008C; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94DE16B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46BF814032C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:41 +0000 (UTC)
X-FDA: 84866680962.22.F992571
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id BAC6FC000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781159979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tyoBKek67GCOLF32gFXw0uKrBXtUnKrGFDmzr7cdOBU=;
	b=TsD+NYRsWtjBNDDLo5lB6jet2CuxgM2ytyAGKLi5u3AYyZXZMheqrp453RtEGpTZ/gyR4W
	RQkkyMBTIxrm5IY6bV7CdBX8UO/y1qUBjDFzklqsrOGzcLcfNd218rbZMQgrdQ4vEAoVP7
	solplb74oRMw/evh0i6GiWT5Hcw+ZH0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781159979;
	b=bamD62hn9Yfecb29vZhVGdat9ZF9sEjCTX63ugi1bgQRPAmYHE8KtzDkF3djrZA4YtKGdU
	J9rNAqxiYbJ0qzu6EIERP9/74nJXqkKYMCNsXv+/KLyTJnjq5V4O/c562xc+goF/V+oziq
	LMnKOYbkQESAYB96uCuaWCxxlLbFNL0=
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-01 (Coremail) with SMTP id qwCowADHbdYgWCpqYOJFAQ--.1790S4;
	Thu, 11 Jun 2026 14:39:29 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [RFC PATCH 2/5] mm/slub: add optional previous lifetime user tracking
Date: Thu, 11 Jun 2026 14:39:23 +0800
Message-ID: <20260611063926.38111-3-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHbdYgWCpqYOJFAQ--.1790S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtFy7Gr4fWr4kZw4DGF1UGFg_yoW7XF4Dp3
	y8GF1Dtr4Iqr1xC397Jr4UC393Xa1v9r4jk398Xw1S9a48Jw1Yvry0kFyjqryrGFyjk34U
	ZrnYv34Y9FWUZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7sRipB-tUUUUU==
X-Originating-IP: [111.196.245.140]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: nm9iug7hrckwcizsqe7ecconjr5b7cpp
X-Rspamd-Queue-Id: BAC6FC000F
X-HE-Tag: 1781159977-565778
X-HE-Meta: U2FsdGVkX1/AWvp+cMcgpNm33VtPXvU/nHYHVMXZeyhZjlIR2L9AhDYzirHDneB9i5REuh/vvj0L32mLh6ldxg2jKtjE27TAtpV1tgl1HO46nPJAuVva+SKLGyXhneUHCWkp0efDgTdJAkg0ZG+9Ziw1NnUvDyW4Fo4WUUQroTb4LD60imrs+o1TRBuVy6sfumUM9yZuZjrNq4ScXZ1ckzBA9eg2NiWQ+lyMDEvq19gXnMUBqYV8veRX8wnL6m6yRQKIh+C1ffe8yc2BVgImsXdDRfYws43xIGqOgLRie1PoD53VwCmGGxA0PvJxvvxn9l5enA5EE2w1fBmeEnazTOpcfeXuV8UNj9VljdhQi4ZrRSDvRVsP0Wo5QOmXKs5Y6bzgh00nPRNCFjQSw6DniJh/rc0iBWwBxmWjX1Bk+Ss9SVlcHwVqSQoKMVeenzslL29kwsJIXi2ZrwUsvgn8uwzbw5CCl3ijzuu3P5SMbbY0WI/XR6YguSRf8JgioCEkuQM92RmrEfWiXnXPjdn1akcKnUld6vAlUDEIPQkFnoF071ZNp0zz4C7ig30awEwwdaVnxA7T408E1sa2i7jZ6x0HuGfa0FWIYkLDIZyul7cn8pVN8IQKjEucY8r2QAxRXniQcH60iiWY/GE9aEFy9ZFi1JIrqE1Wz7RiA+h2wtIA1dcC3ceu/fbiDG4rS1pwUmJ26MJimCJ6PxRIWxywB8KemGyg4g4ghOlX8L+5SEGrJtUK8gcVUAd/NWlMnDMLWPyuVetTGr7lHSqcNS3osZI5mjOUJlulvCAiqk3aP9hlSJSK9UdU4/Hpj3Ay53bVAqBkBkXfMHsi2Ea+U8TAJdQUU6vlGXmk5hcVNOlReJnSdSIAXZhKcNoCKhDPzhPz6BvHQ8xAvYoqn+utlYxCG5o4DgGKZ3sBgrn+1TFKqzof8OcGckkjm0YY1KYVXCR4byW5UYw2ivLDJDfjSNJ
 h9cO6Jb0
 IUbU5BM8mtnJ8lj2xwGbCbE+/My7Mr9M5PnOZGDtIPHb3MDinT+NDQmdQKdtnLuzrifcXo3ToCqQp0DBkF23rloo6CHdtSYsmNZMBGqht7Ijlxw41Xb0qmpiUYAjTKKDhfJDQxSVnFI3H9I0hN+gmnImW3L/tuNd1obIu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLAB_STORE_USER currently reserves two per-object tracks, one for the
allocation and one for the free. Add an opt-in SLAB_STORE_HISTORY flag
that extends the user tracking area to hold one previous completed
lifetime.

Expose the option as slab_debug=H, but require it to be used together
with U. This avoids silently enabling user tracking and its stack depot
cost when a user only requested H. The option is not part of the default
debug flags.

No history is recorded or printed yet; this only adds the flag, the
object metadata layout, and the sysfs state file.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 include/linux/slab.h |  3 +++
 mm/slab.h            |  3 ++-
 mm/slub.c            | 36 +++++++++++++++++++++++++++++++-----
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2b5ab488e96b..78b9ec5bc17a 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -32,6 +32,7 @@ enum _slab_flag_bits {
 	_SLAB_CACHE_DMA,
 	_SLAB_CACHE_DMA32,
 	_SLAB_STORE_USER,
+	_SLAB_STORE_HISTORY,
 	_SLAB_PANIC,
 	_SLAB_TYPESAFE_BY_RCU,
 	_SLAB_TRACE,
@@ -98,6 +99,8 @@ enum _slab_flag_bits {
 #define SLAB_CACHE_DMA32	__SLAB_FLAG_BIT(_SLAB_CACHE_DMA32)
 /* DEBUG: Store the last owner for bug hunting */
 #define SLAB_STORE_USER		__SLAB_FLAG_BIT(_SLAB_STORE_USER)
+/* DEBUG: Store the previous object lifetime for bug hunting */
+#define SLAB_STORE_HISTORY	__SLAB_FLAG_BIT(_SLAB_STORE_HISTORY)
 /* Panic if kmem_cache_create() fails */
 #define SLAB_PANIC		__SLAB_FLAG_BIT(_SLAB_PANIC)
 /**
diff --git a/mm/slab.h b/mm/slab.h
index bf2f87acf5e3..a6af35829f79 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -417,7 +417,8 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
+			  SLAB_STORE_HISTORY | SLAB_TRACE | \
+			  SLAB_CONSISTENCY_CHECKS)
 
 #define SLAB_FLAGS_PERMITTED (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS)
 
diff --git a/mm/slub.c b/mm/slub.c
index a9114dddc976..803c597351ce 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -277,7 +277,7 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
  * issues when checking or reading debug information
  */
 #define SLAB_NO_CMPXCHG (SLAB_CONSISTENCY_CHECKS | SLAB_STORE_USER | \
-				SLAB_TRACE)
+				SLAB_STORE_HISTORY | SLAB_TRACE)
 
 
 /*
@@ -285,7 +285,8 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
  * disabled when slab_debug=O is used and a cache's min order increases with
  * metadata.
  */
-#define DEBUG_METADATA_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
+#define DEBUG_METADATA_FLAGS (SLAB_RED_ZONE | SLAB_POISON | \
+			      SLAB_STORE_USER | SLAB_STORE_HISTORY)
 
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
@@ -316,14 +317,23 @@ struct track {
 	unsigned long when;	/* When did the operation occur */
 };
 
-enum track_item { TRACK_ALLOC, TRACK_FREE, TRACK_NR };
+enum track_item {
+	TRACK_ALLOC,
+	TRACK_FREE,
+	TRACK_PREV_ALLOC,
+	TRACK_PREV_FREE,
+	TRACK_NR,
+};
 
 static inline unsigned int nr_user_tracks(struct kmem_cache *s)
 {
 	if (!(s->flags & SLAB_STORE_USER))
 		return 0;
 
-	return TRACK_NR;
+	if (s->flags & SLAB_STORE_HISTORY)
+		return TRACK_NR;
+
+	return TRACK_PREV_ALLOC;
 }
 
 static inline unsigned int user_tracking_size(struct kmem_cache *s)
@@ -1837,6 +1847,9 @@ parse_slub_debug_flags(const char *str, slab_flags_t *flags, const char **slabs,
 		case 'u':
 			*flags |= SLAB_STORE_USER;
 			break;
+		case 'h':
+			*flags |= SLAB_STORE_HISTORY;
+			break;
 		case 't':
 			*flags |= SLAB_TRACE;
 			break;
@@ -1855,6 +1868,11 @@ parse_slub_debug_flags(const char *str, slab_flags_t *flags, const char **slabs,
 				pr_err("slab_debug option '%c' unknown. skipped\n", *str);
 		}
 	}
+	if ((*flags & SLAB_STORE_HISTORY) && !(*flags & SLAB_STORE_USER)) {
+		if (init)
+			pr_err("slab_debug option 'H' requires 'U'. skipped\n");
+		*flags &= ~SLAB_STORE_HISTORY;
+	}
 check_slabs:
 	if (*str == ',')
 		*slabs = ++str;
@@ -1969,7 +1987,7 @@ slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 	 * but let the user enable it via the command line below.
 	 */
 	if (flags & SLAB_NOLEAKTRACE)
-		slub_debug_local &= ~SLAB_STORE_USER;
+		slub_debug_local &= ~(SLAB_STORE_USER | SLAB_STORE_HISTORY);
 
 	len = strlen(name);
 	next_block = slub_debug_string;
@@ -9223,6 +9241,13 @@ static ssize_t store_user_show(struct kmem_cache *s, char *buf)
 
 SLAB_ATTR_RO(store_user);
 
+static ssize_t store_history_show(struct kmem_cache *s, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_STORE_HISTORY));
+}
+
+SLAB_ATTR_RO(store_history);
+
 static ssize_t validate_show(struct kmem_cache *s, char *buf)
 {
 	return 0;
@@ -9442,6 +9467,7 @@ static const struct attribute *const slab_attrs[] = {
 	&red_zone_attr.attr,
 	&poison_attr.attr,
 	&store_user_attr.attr,
+	&store_history_attr.attr,
 	&validate_attr.attr,
 #endif
 #ifdef CONFIG_ZONE_DMA
-- 
2.50.1 (Apple Git-155)


