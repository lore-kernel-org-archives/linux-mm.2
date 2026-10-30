Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BEBA606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DRqT7/Wj
Received: by kanga.kvack.org (Postfix)
	id 9C81F6B05B3; Fri, 30 Oct 2026 08:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978776B05B7; Fri, 30 Oct 2026 08:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F506B05B8; Fri, 30 Oct 2026 08:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64B6F6B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:17:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70B15C06B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:17:26 +0000 (UTC)
X-FDA: 85379192892.25.79A5472
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf10.hostedemail.com (Postfix) with ESMTP id CA516C000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:17:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="DRqT7/Wj";
	spf=pass (imf10.hostedemail.com: domain of 304rkagoKCNgD8HB4I6B8HAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jenhaochen.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=304rkagoKCNgD8HB4I6B8HAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jenhaochen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793362644;
	b=Y/vzFDwdvkMJr1gFqfS6w1d3MMP6CctbttYdj6sm9YApGJ7MNoUof9JhtYJOUFxGwQCDs1
	eh2hV+ui+dH5X4gq/8xXlkCtFU+LM9O3Rm185LHVEX/xUGQ1hDSwTnwb3IpN+lYc5gh1FT
	pSr6OA+ua/jvjJcTpYQazoKjiJtuNkU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="DRqT7/Wj";
	spf=pass (imf10.hostedemail.com: domain of 304rkagoKCNgD8HB4I6B8HAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jenhaochen.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=304rkagoKCNgD8HB4I6B8HAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jenhaochen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793362644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HpxrkdHX+pHoxS8QiLrmBd8NFzaZIUXGXtbQN2oLq54=;
	b=Y9MXUgMdXO8I5LSksK/op1uqYKbf5q5BveOVsW3m+qBvsY/WeFAHQC70h0w4PbzamkmT3f
	McwHlcj6d4VT/Q1JWkA1uErKcUgddyVRqanISvLR/9aMXh/QuqPT/6Hs5IARX9cs9YsbbX
	FvXsY/yFocn3jmS0LP7ikZKBAVLvF1I=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3ab2395f104so644744a91.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793362643; x=1793967443; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HpxrkdHX+pHoxS8QiLrmBd8NFzaZIUXGXtbQN2oLq54=;
        b=DRqT7/WjioyK/Xjl+jd+EV7CLKKF7yrTAmxSABeqfMFdJgEArwfd62NIfArKxxQLaj
         gvKdeq20am0WPXRsyy0zWNKiBfHBU1re6tT/KUYMsEy3KdUHSy7d1pbEvbznIJ4A4Yny
         Sf+FSALlN8WjVBKzugFFQhlnQ8TGwQQjjYdyv89Qrwd0O5rP92oZfUlWIlAtwwpXoGag
         lGougV5cpFA4FCtKrVyTwmLvGaEnoZuy0Bv9PmLnbn26PA0zinp+CJHf4JGJTLIqlA94
         d/K72jaT32bTrQFWNvc77iU0pL7sEvDbiFXFsY2zereMdN0RUr4bjqLbRckXRMzf0rqF
         raug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793362643; x=1793967443;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HpxrkdHX+pHoxS8QiLrmBd8NFzaZIUXGXtbQN2oLq54=;
        b=0SLplvjpNMl4mJoOGPQiuUggyT3juxblfr6apXybuAsoqp61zegx77CWf/h9VPY2I7
         BYGXl8VCkEC1MARMKBAxXfzxSpVbEqygkMG+ODnQQLd0J/i4oo4u29Q559pq0PNeKu2L
         WzHs78MdjBJJjUhKJ2KA9ZcAhsPjxna74mzJWQR82FxtITTGwLJrvbGXuKavgAGogzM9
         E9yg67U0d8H6CrHoriGkXx/8FpQdwQIOrI54kRYU7+AsclUoxxZq4C4u1H2XiHomOvEe
         /taiusevfX1VOhuB0Ionkmjde8SLNHr5WzucGs3hJGmCErSumnGocfbhsMzXREnuoUqz
         +n4A==
X-Gm-Message-State: AFq9FYL4MFyOlR4u/TYnobUIf51cIqneOlrE4RcLfjdawEtpe5uhKYin
	5jm9JQKGyomqlyqJxqUYoAtnpAVA5pn/RfthVl1PjX7nLZ54mndpEt0Q6Wns6XohJeI0Pg+pX5T
	WexlApL3lcih2oxz50R1+eQ==
X-Received: from pgby23-n1.prod.google.com ([2002:a05:6a02:6517:10b0:cc7:4919:5ed9])
 (user=jenhaochen job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5106:b0:3ab:e588:c295 with SMTP id 98e67ed59e1d1-3ae8983c798mr1659513a91.42.1793362643165;
 Fri, 30 Oct 2026 05:17:23 -0700 (PDT)
Date: Fri, 30 Oct 2026 12:17:00 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261030121700.260975-1-jenhaochen@google.com>
Subject: [PATCH] mm/zsmalloc: inline obj_malloc() and obj_free()
From: Jenhao Chen <jenhaochen@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	minchan@google.com, liumartin@google.com, benwei@google.com, 
	Jenhao Chen <jenhaochen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: a5eeqad74hty9atcggwt9m87jyxye4sp
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA516C000B
X-Rspam-User: 
X-HE-Tag: 1793362644-129057
X-HE-Meta: U2FsdGVkX1+l7jsp0/lkkLkZXBtnHkAfqw5DCE6n/7WLu5EabjMbdXPDPDt9AJb7jg5mn6Oc3Xtx4z970C012CTOZh+axcmn6mENoUwg2L4OZLtP09GTl0cEkmfJ3w3BBfcEn8KX6TYKKf+UgaLJyTQamb2cwcSla7HLb2tYNRNGz+qkgwMA1Cv0QCWLpiomXklfslt4CfXJ90W9pXviBKE3GTAOvnx8wjEsKtA1Rl2WtmCC0hGqYVG5P6RqRb3OmtS4CjLOqeMVgYzzaWGN8i+t6ozfOl+sFwPTQtqfKAIw1eaRpsSuLZrinfvWSAfhq4cfz/TELqvUplGv9Gq/eIXPOotoF4smIAa2HUpxZc7Pyh2FfB4Iy/ROpHj3mozbR4gm3g0JUKGt4qGFzEMtz7qDMR+6uWDlT1F1m2tD7o5nbqAF2TPjj03YLtoprTdXESSJcddg2RHgMcvNVfqaKP0Z+JItKwLzz0197Xt9Zy54YSQR9OHJtGdi2lpeJNBozf1Amu7B9t1IsB/WNq5Xu3suvaRbnyQbjVupf7Xn6Z+aZZaG4L1J+yWsES5N4vxXkkh5Y93osTvemdYJutVWQ38fuK6P+3p5RYCVnlYmqUOEAIJa6CgM7AoNXuGGJbzJQMFHv22SxXaFzIgz5hzFP3wmmiX5LtY90yBX9zlvRU8blcuD+SuAn3xezGdvbKsWopZW+RngsMG58Wv1PhgBoUK5kxNdDZHslawNuaW1mkC0qAHYS8+gqdDCls/uEVGqsgOi1g5iApkbomjFXqKs0EEw0kiWs/v9/q1SyEg9uvj3k0ULmpUAwn3uAilobvq27zUAKdPDr2Ef7asxMWlAZjnYMiBvNKHW3eibNehYJA4CAbdrQzzMUbknefIwkF/rilgfG6IOCa/cC/b3YXPJ1JbYG+wwCBI2bxAeXP/5mQov6dL7WHU/EbAImC73eXcA+ifDsb4gBvCrPQpeJbG
 XCBg18mE
 lGfYCfcf1zzBDvbNSuGCrrSdTIij03eim+vGhtLxxLY06qt6epHyC9NEUkei0XA3kFKG4m9yk+nRlgfQoGf6oTxqmSqebUVfQsHCPY1yF3flxnFHFLhFDXIdkWtkfTeeDe3vtPiSNERJvNybHd3mht+KSa3uY0YnbjfysVYNoXk4ZW7c4BOnH6eyO7EMwU9+8jBIiDiH9QCDrENiMBMye3Hn82NGxC4o5zCaRZ+/qNslaM8Rj2XFTTiZfO2su6BoCNCg+guD2UXGw4vXhtjilwu0UvDhwu11nw7OxcmyZtD9b8JwCMr8zWiAD+qYD3YwJ6PmEmDH0zmjDgf6ZXe0YUWz6s3YgiOQK9MQH8bK6fBfyjV8qRjoYlpXlNQdk+A4D6qqq/DVafA3Qvw5W8SNu85ptKBQLSXUCw57HlHI4pvxBdMXFswixlAxbl06p+fzAXiGQxn9YpssF+WaTdV3uje9thMJcwFEDjphSDT12j6AP8Y/ZhCSQFJfFMm7PAbqpYu7XR37XuDyb8eMMnBya3ZVfGQDaRNEd0kIGOZzvz9+YzBBWMsvfloS6Cy+yN8WR8eEU4CHOd7twlPSEggj3+/JOlYq65SOmykjA+Rei5FBOIQjQXhxZR6R2bq8KS0fRlPDuGCpsez9bhdDeZcRZarUS0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In zs_malloc(), the fast path (if (likely(zspage))) allocates from an
existing zspage via obj_malloc(), while the slow path allocates a new
zspage via alloc_zspage().

Because obj_malloc() has three call sites across zs_malloc() and
migrate_zspage(), Clang at -O2 leaves obj_malloc() out-of-line, adding a
function call on every fast-path allocation. Conversely, because the
362-instruction slow-path alloc_zspage() is static with a single caller,
single-caller inlining under CONFIG_AUTOFDO_CLANG (e.g. with
CONFIG_ZSMALLOC=m) inlines alloc_zspage() into zs_malloc(), growing it
from 254 to 691 instructions.

Mark obj_malloc() and obj_free() __always_inline and mark alloc_zspage()
noinline to keep the fast path inline and the slow-path page allocation
out-of-line.

Signed-off-by: Jenhao Chen <jenhaochen@google.com>
---
 mm/zsmalloc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6258a4f5e9fce..5d3443f14a48f 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -960,9 +960,9 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 /*
  * Allocate a zspage for the given size class
  */
-static struct zspage *alloc_zspage(struct zs_pool *pool,
-				   struct size_class *class,
-				   gfp_t gfp, const int nid)
+static noinline struct zspage *alloc_zspage(struct zs_pool *pool,
+					    struct size_class *class,
+					    gfp_t gfp, const int nid)
 {
 	int i;
 	struct zpdesc *zpdescs[ZS_MAX_PAGES_PER_ZSPAGE];
@@ -1209,8 +1209,9 @@ size_t zs_huge_class_size(struct zs_pool *pool)
 }
 EXPORT_SYMBOL_GPL(zs_huge_class_size);
 
-static unsigned long obj_malloc(struct zs_pool *pool,
-				struct zspage *zspage, unsigned long handle)
+static __always_inline unsigned long obj_malloc(struct zs_pool *pool,
+						struct zspage *zspage,
+						unsigned long handle)
 {
 	int i, nr_zpdesc, offset;
 	unsigned long obj;
@@ -1321,7 +1322,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
-static void obj_free(int class_size, unsigned long obj)
+static __always_inline void obj_free(int class_size, unsigned long obj)
 {
 	struct link_free *link;
 	struct zspage *zspage;
-- 
2.56.0.317.g454f8302e1-goog

