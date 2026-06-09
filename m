Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEA4CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40636B00B2; Tue,  9 Jun 2026 05:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0C36B00B4; Tue,  9 Jun 2026 05:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DD86B00B5; Tue,  9 Jun 2026 05:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 817086B00B2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24AF5C18EB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:56 +0000 (UTC)
X-FDA: 84859824672.08.A575881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7484D20003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mfELCQqu;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJajBhmopjl8Hwhv2eDy4ETytAFbNHaX96AYwL3i/hA=;
	b=esy/MiNZXSoahJnc7XyMP2z1P4MB88KPhmwoi4TIIIrPKvraRbWG3VXp1fCr1AfUmeLBlZ
	Im8DqQX7IO769QLeXUJJGM6t4j4wrQzAF2PUvna/L2PYqgcyqtyjM2tC1cwJtNCcNGGRB+
	fqcOsGRgWSWOak7OEnSx9SfF5pakECI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996734;
	b=2vnWd1KOCKZr56LeZFoX8fBUgHlmJgpyH33MMIZ4PFf1y1x7pSKUwz977NXqxroIK3riMR
	TiNDNlFA1pOZHEaGEm0g2TwyExPBh1egT+K+hSKqV+GoLVIWU4ajuUookawVarsa2a6ECd
	VRwdcAtBNCzddMZIq8Nbn9vfIYLrwLY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mfELCQqu;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1A14436FB;
	Tue,  9 Jun 2026 09:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4161F00893;
	Tue,  9 Jun 2026 09:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996733;
	bh=OJajBhmopjl8Hwhv2eDy4ETytAFbNHaX96AYwL3i/hA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mfELCQqul9/aT0coI5OmrsKZe7PO1SayKTXlVzHfo5FdJBS510xBL5TFtBeFv1y3P
	 Z3GvMh2Hwb1/qdm39TsNjQ5D8N9er45dQ5cYq3QdlIjwMOVZFxjCZZV9LJNaQ1MjDk
	 Rh7md2C8uFOyx5bhIbbF5dmc6QW8SCEe4YAsnnFRBGbWrdsTbe/o7w/nyo+Lypqzuh
	 2ess4G9bFRWrg2DvUeVJ5GAlWD1ErJZHnoSJkT858OBpogUyzV+ZJ9EOD612txR2H3
	 fQxsOqVZlNxw3+qjQdeAvxOi2jvHlN6TkOG7rK/Y++TaUsOOJvu5x8Hq+uZqiGRql9
	 hLtXn+P/tGUWw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:18:00 +0200
Subject: [PATCH RFC 15/15] mm: remove the __GFP_NO_OBJ_EXT flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-15-2bf4a4b9b526@kernel.org>
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 7484D20003
X-Rspam-User: 
X-Stat-Signature: 8yrby9fqi3xm7sft86yhkuis6xiz5kwh
X-Rspamd-Server: rspam08
X-HE-Tag: 1780996734-128610
X-HE-Meta: U2FsdGVkX1/6b54Us6HK1m+SuTsP9Ga2hhBniwxWNlO4VP+MXZxYA0zPjoA5vQ2zbfa3Nu1paD8hhZs9HnJjqPoThMWnDBNOC3rzS/4OCKxQX+7AkybDeSaH2iX+MXFQkjubfBYSCdWOF4zTdOFClqQLWtp2VfV/4uFUd96XhfCRvdGohbyeEhT1bAib/Gw2Xo5oh4FZRi9bUzIy1huo6VtzL9u0wHYaoD5V+U82cSiMVfndS9/7Bh6dLWCtKZAH7mOzkhjbmshjF9ZUpPCYZqYCiVPa4qLjHK1kvC9rONpLSu6pstB+y63Uij+dFnoFfpkT04cGTQSZI/HNG0SCIqjYKW41hlcu5pMntyqtDhh47f57i/e9JrCoDhuVvJ8e3dcaFt9QRjgfk4UNeUX+AUFti+iEl0T79Yss+CwKJCBgX9qh+wfxAdTLHpJamUuo0a8PNW+ERiSzb5w/4+s85Vc2uCFGuYn4EnMKr71XMC7gZWmP3NVN97u51UNhOBp0S64XedbPKWBVYZw/AQr0m7RowJC6Znpg4a0jGWWlxRgjWSZYDzWkbXbSiHcd6aSu+MmAtdggBbuOEQorReynXZZN0rKa4kfSRs9keJgcgvBk2JWTSdziKXOlbw1X/5TIzdR5i1sLWqmj2nqlpWbZDmNMVDEKxND6+XIefG+tu1scrFFoymxmWeb7hKS5y7hfwfd8yzHoqwsWJdzGALJMj1M6s4VhdAKev6FcV0pEkKHIuLX9hZFui8IxEax3D5wVnGZwV1zXV4oFjZZl489QMPcgF43QxkCyXTxZSXqHdyfXN/2lveDFU3lo7p2BWjHmJFLuqfCLgv1BgZugcfCTKO11Epf6XrJSHCKWzy+oNAZM+Qx88Gha8DvDxsAJ+/lzDlYaYUsMG/re/+DiH7FOguazRvK23vvywhiOKVXT00NBj+TCeQ2laWk5QyJHqpeZHx6UPcqdAMHF+Yg3JNU
 xG/jX6eD
 4gJJq0hPq979BFBIOHESMj5IgYtL7tmWucVpKpT5t9KD+bfHIoo35yp8swt5UFO1U+ajNDIpzrD/1rYqzEYrBjZF2jDdMRoiLVr3bwrz/MhOWCXe2qJWMbis46FziTfgAgwW6ByDGyHLy2TQLEUgYOdvWW+pFHEkWDk7jj28CZ5rHElYs+L9CvuSDOPRuGS2ZgK72/ZdjF67jDRPpTZljnmRKP28T7D4xY2nuMUjfV9x+6PDuWxRhHR+KYksI7u+Ry/Ut8vUj9D2Jv5mvwMLFD+o6UvLzZ45eQ6c9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All users of the flag are converted to SLAB_ALLOC_NO_RECURSE. Free up
the flag bit.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/gfp_types.h       |  7 -------
 include/linux/slab.h            |  2 +-
 include/trace/events/mmflags.h  | 10 +---------
 lib/alloc_tag.c                 |  2 +-
 tools/include/linux/gfp_types.h |  7 -------
 5 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 6c75df30a281..a93b8bd200b7 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -55,7 +55,6 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-	___GFP_NO_OBJ_EXT_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -96,7 +95,6 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -137,17 +135,12 @@ enum {
  * node with no fallbacks or placement policy enforcements.
  *
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
- *
- * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
- * mark_obj_codetag_empty() should be called upon freeing for objects allocated
- * with this flag to indicate that their NULL tags are expected and normal.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
-#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
 
 /**
  * DOC: Watermark modifiers
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 11e82fdbe8d3..15d1917b81d3 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1043,7 +1043,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 /**
  * kmalloc_nolock - Allocate an object of given size from any context.
  * @size: size to allocate
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO
  * allowed.
  * @node: node number of the target node.
  *
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b42..c1a05ff0feab 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -54,18 +54,10 @@
 # define TRACE_GFP_FLAGS_LOCKDEP
 #endif
 
-#ifdef CONFIG_SLAB_OBJ_EXT
-# define TRACE_GFP_FLAGS_SLAB			\
-	TRACE_GFP_EM(NO_OBJ_EXT)
-#else
-# define TRACE_GFP_FLAGS_SLAB
-#endif
-
 #define TRACE_GFP_FLAGS				\
 	TRACE_GFP_FLAGS_GENERAL			\
 	TRACE_GFP_FLAGS_KASAN			\
-	TRACE_GFP_FLAGS_LOCKDEP			\
-	TRACE_GFP_FLAGS_SLAB
+	TRACE_GFP_FLAGS_LOCKDEP
 
 #undef TRACE_GFP_EM
 #define TRACE_GFP_EM(a) TRACE_DEFINE_ENUM(___GFP_##a##_BIT);
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..63686b44a23d 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -776,7 +776,7 @@ static __init bool need_page_alloc_tagging(void)
  * If insufficient, a warning will be triggered to alert the user.
  *
  * TODO: Replace fixed-size array with dynamic allocation using
- * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
+ * something similar to slab's SLAB_ALLOC_NO_RECURSE to avoid recursion.
  */
 #define EARLY_ALLOC_PFN_MAX		8192
 
diff --git a/tools/include/linux/gfp_types.h b/tools/include/linux/gfp_types.h
index 6c75df30a281..a93b8bd200b7 100644
--- a/tools/include/linux/gfp_types.h
+++ b/tools/include/linux/gfp_types.h
@@ -55,7 +55,6 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-	___GFP_NO_OBJ_EXT_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -96,7 +95,6 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -137,17 +135,12 @@ enum {
  * node with no fallbacks or placement policy enforcements.
  *
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
- *
- * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
- * mark_obj_codetag_empty() should be called upon freeing for objects allocated
- * with this flag to indicate that their NULL tags are expected and normal.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
-#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
 
 /**
  * DOC: Watermark modifiers

-- 
2.54.0


