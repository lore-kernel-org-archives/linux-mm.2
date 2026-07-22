Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2792DC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870A36B00A7; Wed, 22 Jul 2026 11:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8482B6B00AA; Wed, 22 Jul 2026 11:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8646B00AB; Wed, 22 Jul 2026 11:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2096B00A7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:00:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B91AD1401F1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:17 +0000 (UTC)
X-FDA: 85016723274.13.AB41205
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 948BC140014
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hJFhfcdc;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784732415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzWEJqU7j0ZiAwHq29jiPVthqAQlNA5+hbQ4+opl0xY=;
	b=4c/JdBBCYztLPgnzkUof5klyFe2tP5BwKCUUvs1TaHoF9+NDY6t+5ij//BpSWS+RqL+0Di
	uJeToFTCMrCqucNHjbNHELnpTCXcxGf1OzvssyauI+esGktjtE9wb4Pq6X5nUs6pj4PKyq
	tKBWFuTi1NBjji48ksKzEGhiMbe7//A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784732415;
	b=J3fKQOXFMlAuFZYbb4RVvCaMycBhagwAC1RYJUQZVNzR8F9IdcDIFJctq341lfh0sXmwn+
	OTWyJGjhuiIV2MugTB05In0LcO4CsBz0NpVUhOmsTs9Qwchj4yVzN6vrGquk/35Iahz5Cx
	/h+2HLCymKnBw8x9EPC8hh64dBA9LXI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hJFhfcdc;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e6a434cabso693484785a.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784732414; x=1785337214; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WzWEJqU7j0ZiAwHq29jiPVthqAQlNA5+hbQ4+opl0xY=;
        b=hJFhfcdcCronIVah+H+BoY4cYq2ylSuQCD1YLzmHRXhSNGhpSQkJsCc8n90+BvM79u
         4Gd3H+In36S2HrzmjqVFhezPVLCiDa+xZkLP6Xo3CBLalk5+GfkEu43eqwd8djj9F5on
         okXXqxz2kMQ9YJNTGEjPNCYBd2v8tdOH046XRgmVF4OT3lKSt5uGMb1smEUP54YKJza9
         GIviUzdWyyGRhYhPTAbF+0/C6FisHOuzex6FzqUfFloFaUy6YaeYVSuBCFDnPwH9FOxv
         5+a+qNuCkXKEqk4V9O1qRJTh2l4aSIkXaioubWVouYVeIZ4/5K2ebhCE7PUdjwMtLIIb
         SKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784732414; x=1785337214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WzWEJqU7j0ZiAwHq29jiPVthqAQlNA5+hbQ4+opl0xY=;
        b=o1v5SAv4aOGUDV7Q55ejJndKqWHQ/oV9rZuTS/bn95+7HYTLhoqcLUJxOaX0AdqFrE
         slAqGfBJXahx2WxM0PB37ZDZAUIcFYzllv9py1Vb9bGo4h3VhZgxYC08mtbIdWV7yMx2
         j+AU/uoPCsKMswlrFtp1+xG6Nu9cqlf/TUbAGBedOubLXhly98SKshfguLHmXuqrG9nU
         DZcvx4FRbeS9Gwn4TGAQJaaTheK8qPYpI0vlSHR7VJIYxTwfBp5nsygPmDGskjn1Ot7O
         5AgRNxT/bDuv3Ux1pEdv8qk7wAdZnZFh3Fo+vVyT7VyLFOKLOtEaMhrIrgI2aUqqCFu0
         7Dlw==
X-Forwarded-Encrypted: i=1; AHgh+RqN0hsifVDzHe5/J6wZinc9mtqm3QSZ7xjEMf28/D5cVHapY9R7gBvWCWmNaPEm94kc3pMfQRv72g==@kvack.org
X-Gm-Message-State: AOJu0YxilqME2FDgpUNDI7Vj5IK0cYcglurwsBTFxuciTJnYQQaaRS4U
	gTUddud283QF+fx/37WCed8hfT2bpSvBkFlp4nGydvmFzOu865AGntiYR2ONKhNyejI=
X-Gm-Gg: AR+sD133mZdwToFENObxUtgIBTyypI2ywslgjfqY2Bt/xRWDB+citb3LIzRDZoHwr4v
	dDLbqy01uS0XLdeHhQH/tcTzi/fPDM7UvtbQfUCUgLYkmW2WJbNXYmIU1ihPQStHJmo2cwO+pj8
	YFyzs+piiYSBi6yrh/D7f+Tj1NqALv/5LGC2qhx1qDF6g3xhvkZ6wRBF6/Mra4pgzgVA1ajHmwc
	OI7xshmoo2T7Sxk5yMntoTXn0VKFUthheT8F3x+2IOFWy8jCReM5K3LWv9m5X0Ej9H6+VCEPSPV
	VXprJppHNmpX9/6HvXVFI/g0zrJAzByJyaJqmYe1lwGsXhRguwV5uh/QSSfmq/Ncbn1jVVmiECS
	0Qf/RbEhJXBjBHdTqu/rX7Tfczn/yZntgJxPlW2VP6kit3bKC/os6p3AwucFG7dppA0FZWi1CuT
	Dh9NskbfXbhn8=
X-Received: by 2002:a05:620a:4008:b0:92d:5504:72dd with SMTP id af79cd13be357-930b3ed9d45mr2222220285a.10.1784732414019;
        Wed, 22 Jul 2026 08:00:14 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba672806sm23149956d6.0.2026.07.22.08.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 08:00:13 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] mm: compaction: support non-movable compaction for pageblock requests
Date: Wed, 22 Jul 2026 10:56:45 -0400
Message-ID: <20260722150006.3848560-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722150006.3848560-1-hannes@cmpxchg.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 948BC140014
X-Stat-Signature: u3ajagiaztkst9zdx7sb9xy9ig6xrf7c
X-Rspam-User: 
X-HE-Tag: 1784732415-407827
X-HE-Meta: U2FsdGVkX19T9ZKj/FRTjucHIjElSs4++3+MomLcH16NyfiUZhEfnmpNM5+DMIvkQNpdJ9DCgRKNn1ocFFEmyhnKe01TqZ57TbM7B6UITH9yfM/FsOkL/nhm9gaM4PXE2pUZlE31+bzSNYa80/b/JYuABh05hvEJGxxKNfsTaTgF8kwaMgUL7ObofUFQzDHAeA5BQT2I5kVU347iSzkJI6zDXs21ZrmCUhnQMHGjrtwhc3g5q7tJB19QgV94w/2lWCpr+InbkNtDrtTV/XfoZwPqvZrlO8da1oult7PS9prISPJEOsfis1in2CmDZp3rICOq/BTLoYBZ3bRC+CgZc1jJWcYbJGfF3Rs5xWL7wF//ofXz4GC/lQAMJ3WfIKGZ84z4ysr84mdfhHhozY9KuX+PU7siW88yFG17gtwUofjddzz8Dl0852Pk7aR0o0xcqY9FKDKCePpVWn2kGPd4c0hbtFzdEMMEL1Aik1f0QhwYBNrbLPRYezC/6Vlagp3LwmNbZ9Jetb1bbUDQ9O6lpSoecNvnB0CK2ZxFIJElsiZZX6LjBBkO8yUc3RLto4HkCv3Nw+lkHNy7M7q8acvhQg/cYlfMkkvDpok7lxpQsqxqxZ4XnyaJCwhF9L55tITyA0yqXzzBHHAbL+/2oTsYvMmuUe3/4rnutPk8o4RPnbsUeX1miH5HaOsO1Oh0BRWH7vs+y4O5AVFSH+zH9ZawRDO0sezV1wZ1tjBSVwSFv57R9+njj4MnxDx5Ni6Y0wDKd7CWSHQd1GC+RffKUvTj7kE3+PND6UGEzaG8uSAWXL0/R+x+2dbP7nxpPbrym2PmgRf3oXgMAhxb89H+f7BKOqqXYn6zvG4eSPo9daU259XWW4gPObca4QX0qMGb0RPesr/q1atkdM4airhLM/HEhj/d50aOEz2Z/Cq7kQ8iNN8LcBf1NovuyRsrSmr53mWWUjEz8gpI5QlbHfLeKDd
 k3e4lWjd
 68gL3ZqknXi9OrZXNeZj9cRGRGCeVXOY4UmAIbLtltNs18dg8lzkALjcV6Np4Z0u3kD3jvYb4KwuU81MQWSKFsxii+ZEhC717FUZAxLmcNxRnabNS9pMNBPLw62p1sqoUzWXZTYSV8QOBip+xBTeZPT0OZfBlHo/+f+u+n2GWLBxjBWsinH60N0ZB3+peERkCHj0/PCyndFtvisFOrdh1F3fAs4R4uvoVjjkAuwUZKnDLxF+hKKqr5632fQRR24drWNy96vAQ6/CtW+fo9RAtvw7gLy6f2J0QALwbBhPpCh6dOJblKRnEoaGItH4H49iLgH12ax4Bukd92CXWj6ZKFliM/HuVUK8E9IgkRNHTCTK0Yoxwvb61uMO1qWMSXc2GJe3AEM7GGpVNmaGmM8X/+7mdHP0cI1zNRvAv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While trying to fix a reclaim storm in defrag_mode, I noticed that
non-movable direct compaction is extremely inefficient.

When searching for space to evacuate, compaction only allows blocks of
the same type as the incoming request. This is to prevent migratetype
pollution, where a small non-movable request frees space in a movable
block and provokes the allocator to fall back and pollute it.

This protection is reasonable on one hand, but the downside is that it
makes non-movable direct compaction nearly useless: if we get the type
annotations right, by definition there aren't any movable pages inside
the non-movable blocks it is allowed to scan.

With defrag_mode, the goal is the production of whole blocks, which
are essentially type neutral: __rmqueue_claim() will convert them
wholesale on alloc. This makes type mixing and pollution a non-issue.

Fix the pollution gates to take the requested order into account, and
allow whole-block requests to scan blocks of other types.

The only exception is CMA blocks. That type is sticky and these blocks
cannot be claimed to other types. Continue to be strict with them, and
allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/compaction.c | 46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f08765ade014..225862a00380 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1381,12 +1381,44 @@ static bool suitable_migration_source(struct compact_control *cc,
 	if (pageblock_skip_persistent(page))
 		return false;
 
-	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
+	/*
+	 * Background compaction produces blocks for the zone at
+	 * large, with no particular allocation context. Allow all
+	 * block types, including CMA.
+	 */
+	if (!cc->direct_compaction)
 		return true;
 
 	block_mt = get_pageblock_migratetype(page);
 
-	if (cc->migratetype == MIGRATE_MOVABLE)
+	/*
+	 * CMA pages can only be taken by ALLOC_CMA requests. For anybody
+	 * else, vacating a CMA block consumes free pages the caller
+	 * could have used, and produces free pages it cannot.
+	 */
+	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
+		return false;
+
+	/*
+	 * Per default, scans are restricted to blocks compatible with
+	 * the request, to prevent cross-contamination. Once
+	 * compaction priority escalates to synchronous scans, though,
+	 * scan all blocks to try to make forward progress. For
+	 * movable request, this likely helps little: there shouldn't
+	 * be many migratable pages inside non-movable blocks besides
+	 * allocator fallbacks. For non-movable requests, this helps a
+	 * lot, as they can finally scan movable blocks.
+	 */
+	if (cc->mode != MIGRATE_ASYNC)
+		return true;
+
+	/*
+	 * Prevent <pageblock_order unmovable/reclaimable requests from
+	 * polluting movable blocks through fallbacks. Whole-block production
+	 * (directly requested, or defrag_mode) is exempt as the allocator
+	 * claims and converts these.
+	 */
+	if (cc->migratetype == MIGRATE_MOVABLE || cc->order >= pageblock_order)
 		return is_migrate_movable(block_mt);
 	else
 		return block_mt == cc->migratetype;
@@ -1974,12 +2006,12 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		return pfn;
 
 	/*
-	 * Only allow kcompactd and direct requests for movable pages to
-	 * quickly clear out a MOVABLE pageblock for allocation. This
-	 * reduces the risk that a large movable pageblock is freed for
-	 * an unmovable/reclaimable small allocation.
+	 * Prevent <pageblock_order unmovable/reclaimable requests from
+	 * polluting movable blocks through fallbacks. Whole-block production
+	 * is exempt as the allocator claims and converts these.
 	 */
-	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE)
+	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE &&
+	    cc->order < pageblock_order)
 		return pfn;
 
 	/*
-- 
2.55.0


