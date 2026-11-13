Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44195606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=il0P7yYZ
Received: by kanga.kvack.org (Postfix)
	id E80816B05DF; Fri, 13 Nov 2026 13:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11186B05E0; Fri, 13 Nov 2026 13:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD22A6B05E1; Fri, 13 Nov 2026 13:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 990BF6B05DF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28E2D12015D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:24 +0000 (UTC)
X-FDA: 85431004008.22.913EB16
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47B1C140005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=il0P7yYZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPaI81Zahfc4wi9ZED7JB3rtSNfxGWOcBtHGauRoFvk=;
	b=tuzlHH+yi5zNfMdkrXWhVLb7upMEe6ygEhqTk2TwK1Sajp6Acltbj+Pe3vTAZ9oT1swXnD
	nXn5ZPpshRPq4q81AaEwiqanH/qSamXndaaJfnkBFWxh6x5g3qH4+oogoDjp0YzyUocAMe
	KW4kPUrvXc3mSbR1XitmGe2Slh32AOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596242;
	b=xfs5FAzZJiWFVaEvQek3ej6x6q7U2MzFNHf2q8WI+MCcaKdZyhzWHOSP9Bdx4pUwUY67AT
	QpTBqubFKmQ/kPPugFThlJhXP6jajbXaEiws6OfdlLfj6XOkaEIvfdAb18Q9pWmc1a0HJQ
	1Mq4jlYRMnlWD+I7KL6BHw6WbOs/O3E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=il0P7yYZ;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.52) smtp.mailfrom=matt@readmodwrite.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e3b22e971so646664f8f.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596241; x=1795201041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPaI81Zahfc4wi9ZED7JB3rtSNfxGWOcBtHGauRoFvk=;
        b=il0P7yYZ/DAkjdN5jk4OaEt7QrG63pqG4DFHGkLZWykPVCOx69tLU/IzduDG2JCFU5
         XLC/KWmUT0ChEFABrmpzct7QQ8487zfB0kGQdBJROrHpUTZFIV1+7syfDlLIr3nL7Gzd
         riwEYl77wiEGpqOhcz9AcQwdgE7pq5bXa3F9ISPRhBgyF0E8M4P58pTRc+5bRH6cDASP
         pdXGZ/W4iTPK8t7g9rcnT2wcaYOna0nfDwqxwQs+xJ8/se1QgALzZICk9BjS5JOwBQ8N
         2YY3AhG/oHbKWzG8Y23LwNPrBFqY16/eqaWfxRMJrkIjZBmgZds7e6Lrf40i6mS1eajR
         VmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596241; x=1795201041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KPaI81Zahfc4wi9ZED7JB3rtSNfxGWOcBtHGauRoFvk=;
        b=JNnqEXXOTwMOhDbQYW6O01wEMFVVHflQ7zDzCtCxfNsjpPSaXeKGR8V0d0BVp0AKbG
         Ax7VCs7Y9M2r4sL2O4vDm1MmMYrDF+5RgBJZ/QkPgKU5+vV6IxQ6yBOO4wnT4Yw1hyRG
         i6LVDb22g+QxDd+1ak/sLKCyWlmZUsut8Eaf3FGNKNTv9pFAL+DG5VxhbXGUVYmgWcZg
         IuJu+du7wDOn7S1UVpCQ1qm83dcbfhWGKAiyzBYunHtcUr9JJzg/AsGqz97t0CcELKY4
         Ze6GEL4YiaFOuEOE87TuccJB9DMehymDqOs7sPAXa/eg5jMhtl6MQeJ5NLJHaaw3Mk+q
         WhVg==
X-Forwarded-Encrypted: i=1; AL+hErH3oLi/BZTTm+S3amVbot7cyju8PAnCF/vrlbR7Y24/iMxOSiWd1H3c9e4cdiYMuhHinoTSsan+RQ==@kvack.org
X-Gm-Message-State: APuU4Z/6LQxZ0rzmVEXiyQVt1eI7ytDKGwvLrQFCpXv+Hjk9nERRW6w0
	HuuiaJhivZ6L4Amd14Up68+o9tea+x9St1sqUYDDEKA+811A9qpoK91Wtr4JnCLYPtA=
X-Gm-Gg: AYBFou2VczP3j8h6FOsrXiOL6BsFBU9r1gYNzG8AZCK0oxXZh47UTndsFs7URSfELEf
	nfhdiXKF+Bww3eI6fI6UtcXUnT9yqGyXQc2wHwqI0ZIhyZeIHvmbTU7rbhwfdN9DU4vp7EwsNVy
	CfdNl1dD59Iw1RXvXmoJxDRbX6tiFcXAV+33tjUkiuA8eWVt/KUd7kmzefY9MWs4aAJzT+RAOGQ
	f8HrHuMoVxyRPod9e4brFHyH/b7jxoFOqHS4syyou34x4Y42Iw+ayP7/4mYDvAKxhQFfb7U/OLw
	+4si4jPIUqG9abDPRcopBSElSP9CfIWt02Mz77anHi/0T1HPR0y2S+VPxipngvkDjIW2Y30PD74
	bxdTjJeN9gaXBInuTUjNgsGDNkKIVW3cSuLbFCg7NUoyuZzDhC+ikwlQDYoLuZr+uvhQLzXit5+
	XWO2XAF7/rcb15k6UhHFABmks792UKF3HBuYXpv14vNc+Ip10YdWy1RsWQ7sqvjS6Si6FO4Z5Ua
	hUfgw9UOBDB/FMimsNhXQKhBw01Iv6PlHo0wQADpGV4GZC4hw9MUZFGM0pnl2So9jrgFu5GNGRg
	oOu5nexTXdCZJ2cB0mG5Wd17Zgv68Q==
X-Received: by 2002:a05:6000:26c8:b0:491:ed89:a38f with SMTP id ffacd0b85a97d-49c73631471mr8011086f8f.23.1794596240913;
        Fri, 13 Nov 2026 10:57:20 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:20 -0800 (PST)
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
Subject: [PATCH v3 09/10] stackdepot: Store compressed frames in stack records
Date: Fri, 13 Nov 2026 18:57:01 +0000
Message-ID: <20261113185702.1332171-10-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qkurh6obkc4zr6ckn77rwgpruxb168x3
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47B1C140005
X-HE-Tag: 1794596242-726949
X-HE-Meta: U2FsdGVkX1+i6hmCMPiJoW/CpeullluLolCWwjym4WSho7NYDFezrsnRFaFCJWRIQAS3b71Ak0af/nmaqBl3iyz+yDUgv7loJqK/YJeGIUSWWr9iyNJyaS9/EM7PERD03VjOdxr2D2vHgHgMpz0zic5Alfl5WZ/omyRgVnKCZvly42VUAD1HhWQM9VRtz0vGoY+POpidj1iK+ljN+v/grPLNjdChzSkwQJLy82ZIq1Qjifs2AALMREy7bMszgwvf1VzVA1jFaTCiKQNOYgYvCzNy3Hg7kAmOxT6khX7g72SnddVAdzJkekq3JmJ10vFj5R98bRvpV4sB1Axi2gzettHKHAaE3rxbbi6fvnbHv4mpiqLQ1lkunUrrXsUSzxINU3QhDeSkAfQDExcmqsLmd41J/jxI0d9DNGvf8862bOSNzWCviNwnQp5UpiYbne50y9o3kDxVn3GTP6kJy/ftzqAwcDnuqI+CEYbDedOchN7qhV/x+BnXxQf6GkwdChD/WYrlsNlJgC7uf26qns+PGy5/CDZkrR4ffTTqC4RPx6Qb8Zlm+gUYPmgGq8IeBhkWzk3cuE31OMOn8kbnVUz7hz2X3o4XM0nkjM1xuwGLXKYUWmfnjGGDyrnJnYhVFo80a3+yoJtRtxaQJMiJX3bOxCE4wOnTzwORcMXVK0mDTVnkQEVvMDzgbaEGDlQ/JYa7MM6K7Pa6OpD7M7ZXXUpvpw8OvttpBM7/GyYMZai8qOn2eAhLP3CWrRis3uAYHrZR8OoN50khOxcDyNvPT8QZ+TJMhUhkuGOkB5JVvKk7DMvEDRrVKLPmXnyzilbng2G35h6t8qj+Mmo1jD1pi4gNf6Q7w+vjDnQpddIezn9fkECt6NU0xXWMiUNCf3DITlNd7trgU7vllbFBWUYBScw/7llewJb6Ayi4LOOZzIONX+07wBVa6R1bb2EhBpht9r6EWMSPbp3f5tkKZBI6UHn
 mRtncnbC
 cKdsDVcw4BQg/BKsg7+jP0K1Ie9uJWMRoEkcWd7wiFGEcD73B4f9NkqHvXVcMElxfs1eeCwiOu8tOfn4Lsl+8KaLPuJuR22p381YHS3Yd72ia+MJH7A65IcpQdxuKrBH1LShnlum/hu+zu1WusnfZxK2U/DEPSON/MMLOIfq1KEf06BCEa8CpIZain8l4x4hM0LMIL+6GNovneaHfb5/nFchphA4NZrwzm45/qO3lqO5S/M4f4mVVCIGXIBjRKBvuyDJUlDBokI4yy+tPeSACtKnkGtyYICOTLKQyI1Yiw5Vs+kAxUtD/rMGNgTQtymjWpzxAmqoV87Z6+Zdd+8lHzId0hG5l7EFTIr/tXy4sISul+ZfgZEr72AACjVsXfx17QY0ehIXZCDexYRxLsvNSZwqL4eW6cvbwrKdzVAQDcivyeiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matt Fleming <mfleming@cloudflare.com>

On KASAN machines stack depot can exhaust stack_depot_max_pools. Frame
addresses for some architectures (currently x86-64 and arm64) can be
losslessly compressed when stored in stackdepot, thereby reducing the
number of pools and saving memory.

When every frame of a persistent record can be compressed with the arch
hooks, store the 32-bit compressed frames in a new 'compressed_entries'
union member and mark the record STACK_RECORD_COMPRESSED. Narrow 'size'
to u16 and add a u16 'flags' field so the 32-byte header size is
unchanged (CONFIG_STACKDEPOT_MAX_FRAMES is at most 256). A record with
any frame that cannot be compressed keeps all its frames uncompressed.

Evictable records (saved with STACK_DEPOT_FLAG_GET) are not compressed
because those records always allocate the maximum size anyway and
compressing frames doesn't shrink the allocation.

The hash is still computed over the uncompressed frames, so identical
traces deduplicate regardless of representation.

Record sizes for common frame counts:

  frames   uncompressed   compressed   reduction
  ------   ------------   ----------   ---------
       8           96 B         64 B       33.3%
      16          160 B         96 B       40.0%
      28          256 B        144 B       43.8%
      32          288 B        160 B       44.4%
      64          544 B        288 B       47.1%

On production KASAN hosts this reduced the number of stack depot pools
per 1000 stacks:

  arch     uncompressed   compressed   saving
  ------   ------------   ----------   ------
  x86-64          15.80         9.25    41.5%
  arm64           15.97        11.64    27.1%

arm64 saves less because we run a lot of BPF programs whose code
addresses can't be compressed.

Suggested-by: Marco Elver <elver@google.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 include/linux/stackdepot.h   |   8 ++-
 lib/stackdepot.c             | 101 ++++++++++++++++++++++++++++++----
 lib/tests/stackdepot_kunit.c | 103 ++++++++++++++++++++++++++++++++++-
 3 files changed, 199 insertions(+), 13 deletions(-)

diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index dcc2e1d21f92..de42f6540266 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -20,6 +20,7 @@
 #ifndef _LINUX_STACKDEPOT_H
 #define _LINUX_STACKDEPOT_H
 
+#include <linux/bits.h>
 #include <linux/gfp.h>
 
 typedef u32 depot_stack_handle_t;
@@ -50,14 +51,19 @@ union handle_parts {
 	};
 };
 
+/* Frames are compressed into @compressed_entries; see asm/stackdepot.h. */
+#define STACK_RECORD_COMPRESSED	BIT(0)
+
 struct stack_record {
 	struct list_head hash_list;	/* Links in the hash table */
 	u32 hash;			/* Hash in hash table */
-	u32 size;			/* Number of stored frames */
+	u16 size;			/* Number of stored frames */
+	u16 flags;			/* STACK_RECORD_* */
 	union handle_parts handle;	/* Constant after initialization */
 	refcount_t count;
 	union {
 		unsigned long entries[CONFIG_STACKDEPOT_MAX_FRAMES];	/* Frames */
+		u32 compressed_entries[CONFIG_STACKDEPOT_MAX_FRAMES];
 		struct {
 			/*
 			 * An important invariant of the implementation is to
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 8f1aaa0c6d88..f323f1e97e12 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -36,6 +36,8 @@
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
 
+#include <asm/stackdepot.h>
+
 /*
  * The pool_index is offset by 1 so the first record does not have a 0 handle.
  */
@@ -94,6 +96,7 @@ static const char *const counter_names[] = {
 	[DEPOT_COUNTER_PERSIST_BYTES]	= "persistent_bytes",
 };
 static_assert(ARRAY_SIZE(counter_names) == DEPOT_COUNTER_COUNT);
+static_assert(CONFIG_STACKDEPOT_MAX_FRAMES <= U16_MAX);
 
 static int __init disable_stack_depot(char *str)
 {
@@ -419,9 +422,37 @@ static struct stack_record *depot_pop_free(void)
 	return stack;
 }
 
-static inline size_t depot_stack_record_size(struct stack_record *s, unsigned int nr_entries)
+/* Check whether every frame of a stack can be stored in 32 bits. */
+static bool depot_entries_compressible(const unsigned long *entries,
+				       unsigned int nr_entries)
+{
+	u32 payload;
+
+	for (unsigned int i = 0; i < nr_entries; i++) {
+		if (!arch_stack_depot_frame_try_compress(entries[i], &payload))
+			return false;
+	}
+	return true;
+}
+
+static inline unsigned long depot_stack_entry(const struct stack_record *stack,
+					      unsigned int i)
 {
-	const size_t used = flex_array_size(s, entries, nr_entries);
+	unsigned long frame;
+
+	if (!(stack->flags & STACK_RECORD_COMPRESSED))
+		return stack->entries[i];
+	arch_stack_depot_frame_decompress(stack->compressed_entries[i], &frame);
+	return frame;
+}
+
+static inline size_t depot_stack_record_size(struct stack_record *s,
+					     unsigned int nr_entries,
+					     bool compressed)
+{
+	const size_t used = compressed ?
+		flex_array_size(s, compressed_entries, nr_entries) :
+		flex_array_size(s, entries, nr_entries);
 	const size_t unused = sizeof(s->entries) - used;
 
 	WARN_ON_ONCE(sizeof(s->entries) < used);
@@ -436,6 +467,7 @@ depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, dep
 {
 	struct stack_record *stack = NULL;
 	size_t record_size;
+	bool compressed = false;
 
 	lockdep_assert_held(&pool_lock);
 
@@ -452,10 +484,13 @@ depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, dep
 		 * Evictable entries have to allocate the max. size so they may
 		 * safely be re-used by differently sized allocations.
 		 */
-		record_size = depot_stack_record_size(stack, CONFIG_STACKDEPOT_MAX_FRAMES);
+		record_size = depot_stack_record_size(stack,
+						      CONFIG_STACKDEPOT_MAX_FRAMES,
+						      false);
 		stack = depot_pop_free();
 	} else {
-		record_size = depot_stack_record_size(stack, nr_entries);
+		compressed = depot_entries_compressible(entries, nr_entries);
+		record_size = depot_stack_record_size(stack, nr_entries, compressed);
 	}
 
 	if (!stack) {
@@ -468,7 +503,16 @@ depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, dep
 	stack->hash = hash;
 	stack->size = nr_entries;
 	/* stack->handle is already filled in by depot_pop_free_pool(). */
-	memcpy(stack->entries, entries, flex_array_size(stack, entries, nr_entries));
+	if (compressed) {
+		stack->flags = STACK_RECORD_COMPRESSED;
+		for (unsigned int i = 0; i < nr_entries; i++)
+			arch_stack_depot_frame_try_compress(entries[i],
+							    &stack->compressed_entries[i]);
+	} else {
+		stack->flags = 0;
+		memcpy(stack->entries, entries,
+		       flex_array_size(stack, entries, nr_entries));
+	}
 
 	if (flags & STACK_DEPOT_FLAG_GET) {
 		refcount_set(&stack->count, 1);
@@ -588,6 +632,20 @@ int stackdepot_memcmp(const unsigned long *u1, const unsigned long *u2,
 	return 0;
 }
 
+static inline bool depot_stack_equal(const struct stack_record *stack,
+				     const unsigned long *entries,
+				     unsigned int size)
+{
+	if (!(stack->flags & STACK_RECORD_COMPRESSED))
+		return !stackdepot_memcmp(entries, stack->entries, size);
+
+	for (unsigned int i = 0; i < size; i++) {
+		if (depot_stack_entry(stack, i) != entries[i])
+			return false;
+	}
+	return true;
+}
+
 /* Finds a stack in a bucket of the hash table. */
 static inline struct stack_record *find_stack(struct list_head *bucket,
 					      unsigned long *entries, int size,
@@ -615,7 +673,7 @@ static inline struct stack_record *find_stack(struct list_head *bucket,
 		 * management state unioned with @entries. The refcount is zero
 		 * in that case and the below refcount_inc_not_zero() will fail.
 		 */
-		if (data_race(stackdepot_memcmp(entries, stack->entries, size)))
+		if (!data_race(depot_stack_equal(stack, entries, size)))
 			continue;
 
 		/*
@@ -761,7 +819,8 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
 static void depot_copy_entries(const struct stack_record *stack,
 			       unsigned long *entries, unsigned int nr_entries)
 {
-	memcpy(entries, stack->entries, nr_entries * sizeof(*entries));
+	for (unsigned int i = 0; i < nr_entries; i++)
+		entries[i] = depot_stack_entry(stack, i);
 	/* stackdepot.c is not instrumented; tell KMSAN the copy is initialized. */
 	kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
 }
@@ -833,9 +892,15 @@ EXPORT_SYMBOL_GPL(stack_depot_put);
 void stack_depot_print(depot_stack_handle_t handle)
 {
 	struct stack_record *stack = depot_print_fetch(handle);
+	unsigned long frame;
 
-	if (stack)
-		stack_trace_print(stack->entries, stack->size, 0);
+	if (!stack)
+		return;
+	for (unsigned int i = 0; i < stack->size; i++) {
+		frame = depot_stack_entry(stack, i);
+		kmsan_unpoison_memory(&frame, sizeof(frame));
+		stack_trace_print(&frame, 1, 0);
+	}
 }
 EXPORT_SYMBOL_GPL(stack_depot_print);
 
@@ -843,9 +908,23 @@ int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
 		       int spaces)
 {
 	struct stack_record *stack = depot_print_fetch(handle);
+	unsigned int generated, total = 0;
+	unsigned long frame;
 
-	return stack ? stack_trace_snprint(buf, size, stack->entries,
-					   stack->size, spaces) : 0;
+	if (!stack)
+		return 0;
+	for (unsigned int i = 0; i < stack->size && size; i++) {
+		frame = depot_stack_entry(stack, i);
+		kmsan_unpoison_memory(&frame, sizeof(frame));
+		generated = stack_trace_snprint(buf, size, &frame, 1, spaces);
+		total += generated;
+		/* Stop once @buf is full, as stack_trace_snprint() does. */
+		if (generated >= size)
+			break;
+		buf += generated;
+		size -= generated;
+	}
+	return total;
 }
 EXPORT_SYMBOL_GPL(stack_depot_snprint);
 
diff --git a/lib/tests/stackdepot_kunit.c b/lib/tests/stackdepot_kunit.c
index dc3f8e207bdd..abcc34844125 100644
--- a/lib/tests/stackdepot_kunit.c
+++ b/lib/tests/stackdepot_kunit.c
@@ -152,6 +152,98 @@ static void stackdepot_frame_arm64(struct kunit *test)
 }
 #endif /* CONFIG_ARM64 */
 
+#if (defined(CONFIG_X86_64) && !defined(CONFIG_UML)) || defined(CONFIG_ARM64)
+#define STACKDEPOT_TEST_COMPRESSED
+
+/* Return a distinct compressible frame for each @i. */
+static unsigned long stackdepot_compressible_frame(unsigned int i)
+{
+#ifdef CONFIG_ARM64
+	return stackdepot_arm64_frame(0x1000L * (i + 1));
+#else
+	return 0xffffffff81000000UL + 0x1000UL * (i + 1);
+#endif
+}
+
+/* Return a frame that cannot be compressed but has the same 32-bit payload. */
+static unsigned long stackdepot_raw_frame(unsigned int i)
+{
+#ifdef CONFIG_ARM64
+	return stackdepot_compressible_frame(i) + BIT_ULL(32);
+#else
+	return stackdepot_compressible_frame(i) & U32_MAX;
+#endif
+}
+
+static void stackdepot_compressed_frames(struct kunit *test)
+{
+	unsigned long compressible[3], mixed[3], fetched[3];
+	depot_stack_handle_t compressed_handle, mixed_handle;
+	struct stack_record *record;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(compressible); i++)
+		compressible[i] = stackdepot_compressible_frame(0x100 + i);
+	memcpy(mixed, compressible, sizeof(mixed));
+	mixed[1] = stackdepot_raw_frame(0x101);
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	compressed_handle = stack_depot_save(compressible,
+					     ARRAY_SIZE(compressible), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, compressed_handle, (depot_stack_handle_t)0);
+	mixed_handle = stack_depot_save(mixed, ARRAY_SIZE(mixed), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, mixed_handle, (depot_stack_handle_t)0);
+	/* Equal payloads must not make different stacks compare equal. */
+	KUNIT_EXPECT_NE(test, compressed_handle, mixed_handle);
+	KUNIT_EXPECT_EQ(test, stack_depot_save(compressible, ARRAY_SIZE(compressible),
+					       GFP_KERNEL), compressed_handle);
+
+	record = __stack_depot_get_stack_record(compressed_handle);
+	KUNIT_ASSERT_NOT_NULL(test, record);
+	KUNIT_EXPECT_TRUE(test, record->flags & STACK_RECORD_COMPRESSED);
+	record = __stack_depot_get_stack_record(mixed_handle);
+	KUNIT_ASSERT_NOT_NULL(test, record);
+	KUNIT_EXPECT_FALSE(test, record->flags & STACK_RECORD_COMPRESSED);
+
+	KUNIT_EXPECT_EQ(test, stack_depot_fetch_into(compressed_handle, fetched,
+						     ARRAY_SIZE(fetched)),
+			(unsigned int)ARRAY_SIZE(compressible));
+	KUNIT_EXPECT_MEMEQ(test, fetched, compressible, sizeof(compressible));
+	KUNIT_EXPECT_EQ(test, stack_depot_fetch_into(mixed_handle, fetched,
+						     ARRAY_SIZE(fetched)),
+			(unsigned int)ARRAY_SIZE(mixed));
+	KUNIT_EXPECT_MEMEQ(test, fetched, mixed, sizeof(mixed));
+}
+
+/* Evictable records are max-size, so their frames are not compressed. */
+static void stackdepot_get_record_not_compressed(struct kunit *test)
+{
+	unsigned long entries[3], fetched[3];
+	depot_stack_handle_t handle;
+	struct stack_record *record;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(entries); i++)
+		entries[i] = stackdepot_compressible_frame(0x200 + i);
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	handle = stack_depot_save_flags(entries, ARRAY_SIZE(entries), GFP_KERNEL,
+					STACK_DEPOT_FLAG_CAN_ALLOC |
+					STACK_DEPOT_FLAG_GET);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+	record = __stack_depot_get_stack_record(handle);
+	KUNIT_ASSERT_NOT_NULL(test, record);
+	KUNIT_EXPECT_FALSE(test, record->flags & STACK_RECORD_COMPRESSED);
+	KUNIT_EXPECT_EQ(test, stack_depot_fetch_into(handle, fetched,
+						     ARRAY_SIZE(fetched)),
+			(unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, entries, sizeof(entries));
+	stack_depot_put(handle);
+}
+#endif
+
 /* stack_depot_snprint() must match stack_trace_snprint(), with truncation. */
 static void stackdepot_snprint_matches_stack_trace(struct kunit *test)
 {
@@ -162,8 +254,13 @@ static void stackdepot_snprint_matches_stack_trace(struct kunit *test)
 	char *got, *want;
 	unsigned int i;
 
-	for (i = 0; i < nr; i++)
+	for (i = 0; i < nr; i++) {
+#ifdef STACKDEPOT_TEST_COMPRESSED
+		entries[i] = stackdepot_compressible_frame(0x300 + i);
+#else
 		entries[i] = 0x301000UL + 0x1000UL * i;
+#endif
+	}
 	got = kunit_kzalloc(test, size, GFP_KERNEL);
 	want = kunit_kzalloc(test, size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, got);
@@ -195,6 +292,10 @@ static struct kunit_case stackdepot_test_cases[] = {
 #endif
 #ifdef CONFIG_ARM64
 	KUNIT_CASE(stackdepot_frame_arm64),
+#endif
+#ifdef STACKDEPOT_TEST_COMPRESSED
+	KUNIT_CASE(stackdepot_compressed_frames),
+	KUNIT_CASE(stackdepot_get_record_not_compressed),
 #endif
 	{}
 };
-- 
2.43.0


