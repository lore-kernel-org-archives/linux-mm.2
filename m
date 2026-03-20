Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8061099B34
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F98C6B00E0; Fri, 20 Mar 2026 14:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE3D6B0108; Fri, 20 Mar 2026 14:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACE56B0109; Fri, 20 Mar 2026 14:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 977A66B00E0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 163371CCE5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:10 +0000 (UTC)
X-FDA: 84567265860.04.4D36745
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3ECFB40006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D+JFfG8Q;
	spf=pass (imf17.hostedemail.com: domain of 3xpC9aQgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3xpC9aQgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4tHzLv2BIce7TOZ68EmuhqmY6Sg+by5v9VmsY48yBI=;
	b=R+udwu/4l19GuFpTs4VWCck19rIgAeqzIojBN9rzFfMh4sQMrMR9rQEUzc0EIXE2jwfx4P
	7fsVlZNkUvUAs6KNm4wztoRwASmZUgsGZIFuKqq79eZrO6vdXQEKTQFIAEd0SANc3GOsP3
	pNTemirhA7t50mJTNPnylTfC1vVeO9E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D+JFfG8Q;
	spf=pass (imf17.hostedemail.com: domain of 3xpC9aQgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3xpC9aQgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031048; a=rsa-sha256;
	cv=none;
	b=bYO4IHLtnCorIcKIxiE3y/oebIV+KYWrkEPYIHt6YBHH0uuxM+cx2+PCovPUl0df+VJRvB
	gIgLVW5vgSa7WcD7PSfGKbE2tKIjQKSgeV0CX2Ek6QMYuhdiSLwLdQnpDgYAXEzDnteBv0
	WrcXb0HEyxH6k8KGnnxUKQGhl0A2JL8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-483786a09b1so24621775e9.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031047; x=1774635847; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A4tHzLv2BIce7TOZ68EmuhqmY6Sg+by5v9VmsY48yBI=;
        b=D+JFfG8QsKzEO3TzhXFFyTix0d5whrHGKJLB2GAGuLdHc3BHoaFGjL5QbADYcmFJl2
         bRkNbm19bUWa92LaiCxgRNyZkDUCPWNti8Nkpdt9q6HAYv/b1eLYPXc0OuozjeuKGdbM
         U8fEfj9TyaLiEM24UTaZeQQso231KhX3yOhWVevitc+SOrgGa7zqN+mGBQ8KuK7PzlOI
         3KsD59M6qrFvVRbaKy0URbXNquRQek66SzR5F30KeRSe0qiHYDClIrK8/H/+TAUaxXtV
         Cf82Zf7YFlXPIH3Iw30mWviG6s+z5QTO7Nmuafy08N1ONCPuMW1g7pOXqNPtGfNG7TTQ
         fhFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031047; x=1774635847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A4tHzLv2BIce7TOZ68EmuhqmY6Sg+by5v9VmsY48yBI=;
        b=mBMaozMGSa2PuGuyQ4BiAIeVvmHP0oQ+ZkalO81DFL6DeYJ4yQwugo59asynkXHMg8
         6PxLSHBxEUBaw9CArxsTD9k69W+f23kIRXwYTWQYaRSUqKxQQ4dm6vxbZbggIfdkF0/T
         piadjgUumMewNK01GsgJ4wczKroCdhXWILl7wqJAlfu1uQVHoBY0i9GNXoGDdao9e8Ij
         FFO3UtdvMyI3yqFRroBpjaMvePnWBK/RsVxrdsCU4Tw94YyU64GinBx6biQlo0knaco6
         rpJBui5z3nRvn9wbAjLlyP4FM/mO9xEUaQfEDAj4q269q1wsZSsZr1k8WPINMkvxY693
         +f3w==
X-Gm-Message-State: AOJu0Yz5HkqSnHR9RxDV3AYr/NpTsuF6ULnD0K4NRnDpFaO6mt1ip8/o
	xJ3z+rSUZpJKTrds+fwmqjQmBj83qUzVE6BbV+cisV0Qhputq+4IkA42pcx5uvVVTSP0AdNOnLK
	f4R86bpOY1IU9VA==
X-Received: from wmi11.prod.google.com ([2002:a05:600c:20b:b0:477:5a4b:d57f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8508:b0:485:3b00:f92e with SMTP id 5b1f17b1804b1-486fedab7dbmr58230605e9.2.1774031046800;
 Fri, 20 Mar 2026 11:24:06 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:42 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-18-28bf1bd54f41@google.com>
Subject: [PATCH v2 18/22] mm/page_alloc: introduce ALLOC_NOBLOCK
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ECFB40006
X-Rspamd-Server: rspam08
X-Stat-Signature: 4biwjamh55yo6r37xgu6cut5ufq7h8q4
X-HE-Tag: 1774031048-100932
X-HE-Meta: U2FsdGVkX18NvIVEkbFUe8nF+w/E1I+blCPKs2lNFjAvDbewYm/MVfVI0EXWvSMUL3bL/fV+CHJ+wpjBB3Y5hbTRuiw0whwx1XHQLoaqXYgr+++cLadf1x2tJcJ2B6YIAa6jkfcy/D0ANBXJHHqkUFPXplFYfwG+1X48ZV8suqBYXNQUpZdU2MlWgAYdLLUcdKpNhvsH5tA1X6x8KSnKvDsSeYyyaAGxeDrA4Z4gl8HjYq2b/tcZGIvjrdczrlvYEmkxsofbMHhmblbb38aW1BpgGKcTIP7em+ir2UQnz7kd/otZ82TF56SRmtp4TwX4SEIC+VJKFTZqdTuV+OcCOQEsVvQMY3SHMqxCBTPWAr3Mg+CBd5Sf72lvyxg2KEGUOYsqeNlrBx8RMhUvd4IsuwgFDgZG1d+xUMEMsfgLiJfv1jkduV6R6F3JXFGlCZqNpB4skscOpnSixg3FjKK1jtlB+M/Sm0cGAzKCF/NXPWA5h9i0Zvz4QwGYKOrNXR2l2wRHzXzRZuCvJEvDaTErMiavfei9Uj8LgDpAw+QXeVOWLJxZkMoJMUaKJ89Gtyv1d2543j6OE7Y71nq6HhS354ECJFoxCo9gKbGQ6O009AzsR5kNbtLQMkq85n0XJ6ByBJ4/uuovbX2qaz2N+Yt0if39qzXJXUDtqRBTiIS4hHZy/5qoFu9JNyrE213p47eCVuyQT8sMJjel4O/uSCQO5UAqCnpW7l2do7CEFlCQ3YGdaaErEHlGfH51SNnb5cGa7FL/JwDGT50qn3X01hKZGLhpIL9GAhSYhcrnnnpD+41QUvreCUUuLnm10eKzwmj/fM6hxF2lGGUudo9+HIq1KCRQ6y7zBwb4w8imbJRy05fens/lC9qj1uufCIOzjqobegLU4IDifToCbzR1mCi4nkLqfa+6FTvZt+j8hyDLpxAXSxAJG2+oyX5oHkhoyde/PF55pKxXRBfEoOQnVbv
 5HOPl+1h
 5aOqBVlSg5OJ3woHmNSzasgxsOlbRrJEccI9PXiiKh8sAKe6OHB0MqSXhUQod96dytUvNUVKSoBTYwMOwB0HJ0x3O60D4x11zKrVsA4WbaA1vjtUx30HRzKDvxTGxYy39Df81B3dlI0VgZL2Wx6JIqG5fAckrtPIbecE11vdyZFv8hbtUSF6YBMBk3kXCYHuyaf3f3GX9zueW3GwnIdsOKG/5DrKsYUkvijnr5S9cbR20p7cWBOaraUagx+Pyf7vSEQM602MYiKhiV6FD5p0Mit6Sdtx9A/uT/bWO8nNiy3nGHBjdYTau7+B5oVuTT/m78DLDKCpHQQK5oWzC3zP739gp9OVqBfjEASN4iVfrVCPzjtWrDAKIWBnuAAmQquWuvsnmwLbEXlRCGqiLaBu+XcrGgZfCmiCN/wHR5ZMHOZdknhJiygEMIA6pYYTRWDrP2txvbR12SJ03XOrkGiIUOMcCCRGOxgRhci42hRQ1kuDI0ePOG0Y/lPdVb1USCwDL/NH6iJWrnysGFguSLhPtj/DpWANXvknp+0U16p1tnkgNThCTtHknE8lOwr+LpOJeY7nPeCtOiJig+UC5RCtzREHqjm+hm3ugyNxY6DYiQfYg7L4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This flag is set unless we can be sure the caller isn't in an atomic
context.

The allocator will soon start needing to call set_direct_map_* APIs
which cannot be called with IRQs off. It will need to do this even
before direct reclaim is possible.

Despite the fact that, in principle, ALLOC_NOBLOCK is distinct from
__GFP_DIRECT_RECLAIM, in order to avoid introducing a GFP flag, just
infer the former based on whether the caller set the latter. This means
that, in practice, ALLOC_NOBLOCK is just !__GFP_DIRECT_RECLAIM, except
that it is not influenced by gfp_allowed_mask. This could change later,
though.

Call it ALLOC_NOBLOCK in order to try and mitigate confusion vs the
recently-removed ALLOC_NON_BLOCK, which meant something different.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   |  1 +
 mm/page_alloc.c | 29 ++++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cc19a90a7933f..865991aca06ea 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1431,6 +1431,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define ALLOC_NOBLOCK	       0x1000 /* Caller may be atomic */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9a07c552a1f8a..83d06a6db6433 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4608,6 +4608,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
+		alloc_flags |= ALLOC_NOBLOCK;
+
 		/*
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
@@ -4801,14 +4803,13 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
-						struct alloc_context *ac)
+		       struct alloc_context *ac, unsigned int alloc_flags)
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
 	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
-	unsigned int alloc_flags;
 	unsigned long did_some_progress;
 	enum compact_priority compact_priority;
 	enum compact_result compact_result;
@@ -4860,7 +4861,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
 	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
+	alloc_flags |= gfp_to_alloc_flags(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
@@ -5086,6 +5087,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
+static inline unsigned int init_alloc_flags(gfp_t gfp_mask, unsigned int flags)
+{
+	/*
+	 * If the caller allowed __GFP_DIRECT_RECLAIM, they can't be atomic.
+	 * Note this is a separate determination from whether direct reclaim is
+	 * actually allowed, it must happen before applying gfp_allowed_mask.
+	 */
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
+		flags |= ALLOC_NOBLOCK;
+	return flags;
+}
+
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_gfp,
@@ -5166,7 +5179,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct list_head *pcp_list;
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int alloc_flags = init_alloc_flags(gfp, ALLOC_WMARK_LOW);
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5307,7 +5320,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask)
 {
 	struct page *page;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int alloc_flags = init_alloc_flags(gfp, ALLOC_WMARK_LOW);
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
@@ -5352,7 +5365,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 */
 	ac.nodemask = nodemask;
 
-	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
+	page = __alloc_pages_slowpath(alloc_gfp, order, &ac, alloc_flags);
 
 out:
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
@@ -7872,11 +7885,13 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
+	unsigned int alloc_flags = init_alloc_flags(alloc_gfp, ALLOC_TRYLOCK);
 	struct alloc_context ac = { };
 	struct page *page;
 
 	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
+	VM_WARN_ON_ONCE(!(alloc_flags & ALLOC_NOBLOCK));
+
 	/*
 	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
 	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current

-- 
2.51.2


