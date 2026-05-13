Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592EECD4F39
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5BF6B0093; Wed, 13 May 2026 08:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F2F6B0095; Wed, 13 May 2026 08:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525AA6B0096; Wed, 13 May 2026 08:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43F0B6B0093
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:35:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 104281C19AB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:22 +0000 (UTC)
X-FDA: 84762342084.06.9D5EEBD
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 35BF82000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=auohndEM;
	spf=pass (imf03.hostedemail.com: domain of 3BnAEaggKCE80rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3BnAEaggKCE80rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778675720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLzi6slHGxfhu4Y8NlwXvD2GZX7MC6Ih+pKGkr9pVTY=;
	b=USJLDXDi7tylZAJ7JfZt7/7k4zKYS56M3iGi/QtGkIFYpD3m0SeeQU+FRVSNUzDD0exEp2
	l5l/+ZRiSdXqBn0BNxdIJ5y8OLZ81K25Qg8bz75KQKy9e8jaMYH4D5wh9tYFQihRdWmVh7
	OH+mZFgU63ateNaFcDQy7q1ShC4qyFM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=auohndEM;
	spf=pass (imf03.hostedemail.com: domain of 3BnAEaggKCE80rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3BnAEaggKCE80rt13r4sx55x2v.t532z4BE-331Crt1.58x@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778675720; a=rsa-sha256;
	cv=none;
	b=UYvQm+vsAxMpVXmprUOUp41SoSZTHy3qypbQHRicz2tMIfp2lDfPPLPUy7Vmrcg6336Ut0
	3fwuOdzoGV13y/8ikXhEfN1lydp/S2uBY7no6on1ZNyJO9GEmTAKzCgcPxQafp2Dm/aZ0x
	eptafoHjuiCAiBduL49yT7PFwEnL/w8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48919890a95so47148065e9.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 05:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778675719; x=1779280519; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QLzi6slHGxfhu4Y8NlwXvD2GZX7MC6Ih+pKGkr9pVTY=;
        b=auohndEMm97nEi4x3UAgDIamwQLPi2JjRjR/e3cyuiEMPvJ2wBoh3AEHNrLI672gFX
         E97Zu5LEBa+cHT2etbqIadJldli3h7zjMLG3YS3KfCH8LLqs8vka82JdbGZGjbEf5z4U
         pq1ofdTllbEPGJReR3X82Mz4qe652uK8ZqPJ5h8Kh7zR/M9y8A8XN1kfcOoUpqEkUqay
         gjDgfwX49SL863NXD0ZZc4i1B47C6lnpXjiQp1Qc2ruQjN2BIQrW0nKAovIVHSG0qJlC
         RFz+ykJUM9Lwv8VsMWNAzSlrn4lqdYC/P5aQP1ZxA3coKFXCw9CEswYw2ZC99cvWgzaN
         vh7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778675719; x=1779280519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QLzi6slHGxfhu4Y8NlwXvD2GZX7MC6Ih+pKGkr9pVTY=;
        b=nvwyL+7Z5RBj/3aPsqbhezwL2nLd4lFe8b68TBMYkvQISWywQ0z6StG8ODby9PyxgR
         qpT/NKSM8fOwWq2QmY56+L1T8yk7lqPQ9Ab2UvFAY/LlwXEra2TCGdnccsqOqkYlnVSQ
         DBONmzcEfhXWHIPUcOQFAglS6o3HCPj51T5s1XPn/0sJQvjc5MlP/wLA/0E0J2i8AGbS
         XuQkbcrmxaDDTCTfQMVU93M54/ZwdJ6KMiJ4tRfXHE+Pm8Lt+HEqMgoN9ZgQE21/B222
         HdmF8uqATz+tnt5r3JsSeeJEeN61smfcDwUADzEUQ6PUrSSOU6eB3pwh+/RItY/uwFWj
         sUIw==
X-Gm-Message-State: AOJu0YxVi8gfd9ep2cDqbWq5sHGg4Au27xI4QHf29xNASPScXtRmuinu
	aOWjFeW2QbSb2P2DmX7KE55bab6pIBTPmUS+ggro6mprHkuopVt5iVGZxX9O0tKRUpUUq8dmCXF
	PNyut064x0QxURQ==
X-Received: from wmbjd23.prod.google.com ([2002:a05:600c:68d7:b0:48a:5e23:da86])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:1c:b0:48e:526e:1012 with SMTP id 5b1f17b1804b1-48fce99dc29mr26844625e9.5.1778675718495;
 Wed, 13 May 2026 05:35:18 -0700 (PDT)
Date: Wed, 13 May 2026 12:35:15 +0000
In-Reply-To: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
Mime-Version: 1.0
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20260513-page_alloc-unmapped-prep-v1-3-dacdf5402be8@google.com>
Subject: [PATCH 3/4] mm: rejig pageblock mask definitions
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35BF82000F
X-Rspam-User: 
X-Stat-Signature: pnbj563o1gq4xq8aqnyke1w8d9bpajbk
X-HE-Tag: 1778675719-214511
X-HE-Meta: U2FsdGVkX1+68TbJ5XVtjrO0REbJp09tG2cna81yFAgKM2yOAMFsaSBv8usNRNiXBb2M7+169A2lZyrXJRlxuEaDDJIHAUtUcba0BXLTV9YYbp2bmB/gpSxnAO1SLMDeL3xNiErjEEWuExsaRpcAtQM7lhZI+unRqdlf+zBgMHlHfzxe6+Tr2B/4OKotTHeyUTzgGE9Cjg0pyudV1DFo0vg4/16pCkKuXXs1gkZNeeyLwWEUBGMJzR2EjglgboyyRBNCmU4WnJnssQfnZl5A5FqspIjI74hrn9Pm+nzuuuJh0UuFEmINyxc+geuS3lvB5Ak3euno1/cS3Ui2D8SuciChILqpvNBSPatRwwUN1QIhYpxSaquX2zRXPvCAXZu8m7nyGOB3LCJYBHHCh6qWXaHGHBipmYbAG8YblTDlVJlCDXyWhM4uTG8A7RCKxRl5LXgVMGgkNIYULFTevewrkJXx/vE7VTMUmkY5Ct3zQ3sI9PP8lqaOtL3Fta8bgR7KFDOdLhjW8fVXTkRRB9f17CN1YE1S9XguFxx9oKvCiQY6GknCSbsvUkEsiKvsrETVYORDX6v3tAjKdpOkphjbZXszrBXft2EYkMBwhXR2p3r04sd77FTPhFpdkNYRwVIhQasUlX5IrWSjqBedOC3iyCBlwrKMyd+qbYWjK7zBNfpszqi0ri3pbXUbW6bhJrHvHGmmG1Hii2CGSNMupGUZoUP4A2ByfuxaJ5bostRpzt3R23gnqTjTw0ymq3zpoVYhvx6NugeCAfyPe061QytguJtXh4ZOt0tPqAZ1YD9PBxnX5nWCb5ik22Nfr1e4QXak03j0rRHEKIrVSDZKSr3TvP7Xvach802tBr54DPiLEHP1eSxGSeHE9u0EyJuT2vRepqCd759aF7wyY8YC4mZifVsgClQE60In9DScXlXVR5BjXNbyqDgR3VpkO7UC9HL62jgewZEjwnQCOJtIkAa
 yBZ/92UT
 zxlSbgMfq4Va2GeNa1pXI97739DcBCbUcMiAwmQIggGX40j2Ut1JgglCeRTFQQlON1GZSd6qvt+lzPSSo7P+ncHAeuHfzQudGrB7Mzb5y1bBZxvDaILNJrdvaSkdaGFvdMdkUL2yoFq1ZVkVAZRW6RvW49A0pX/Gq4uj0Kp7THRwyG+wQhOjwlFAQjKJhjljzs3zjCvoTIjkQcOngyKkYoSNIuP2d2nUYJsuvO8ftKqXJWcOvGx1+OycOzBQD47OD3V112OgkVrKzi2TsQo37fVCZUuiYq0I9QENLmg0hH+Wtd2sy5KKx2UYpr9XZpW8MWNmdrjqngT1bgM/ZM1qRMORltws9h6fcSOlBxHnx1HQ2dsxKZCT3Uvq8fW8AdUDjbQ08/kepam7MCdKphWmiqy7oj+quE75a2+qIMokpe/DJkOR8i5dwJZuIv+eXsnXcUOWTowSiuYgBgvzUYlxO3MXtl+SITQrvgMejPJ0U4jAE6h82qiYEixJWo4j/3YdTK3vDORy3m1drdkqoQVfPojMb7pmO9X5nOn56+NTMWMC+KFTaOhLwgWNa6jB6o0P0G5ZReVgUL9S0xyjt47ii9v+lTmbguNMVfrB/8mzLxDc/FLCWD1llysJrhiAf23uxqz2oD4LvZDJ2wPvN4Rub6dq4umR2xbbgzaHU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- Add a PAGEBLOCK_ prefix to the names to avoid polluting the "global
  namespace" too much.

- This new prefix makes MIGRATETYPE_AND_ISO_MASK look pretty long. Well,
  that global mask only exists for quite a specific purpose, and is
  quite a weird thing to have a name for anyway. So drop it and take
  advantage of the newly-defined PAGEBLOCK_ISO_MASK.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/pageblock-flags.h |  6 +++---
 mm/page_alloc.c                 | 18 +++++++++---------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index e046278a01fa8c37d898df94114d088933b6747f..9a6c3ea17684d821fde9ec272b0802dfb78249a9 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -36,12 +36,12 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
+#define PAGEBLOCK_MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
+#define PAGEBLOCK_ISO_MASK	BIT(PB_migrate_isolate)
 #else
-#define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
+#define PAGEBLOCK_ISO_MASK	0
 #endif
 
 #if defined(CONFIG_HUGETLB_PAGE)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 91d83c967bd478982e0161a99d47d3a76bd89992..5d6144c8860ed10fd641184f389c4953465d5178 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -364,7 +364,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 #else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
-	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
+	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
@@ -437,7 +437,7 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
 __always_inline enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
-	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;
+	unsigned long mask = PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK;
 	unsigned long flags;
 
 	flags = __get_pfnblock_flags_mask(page, pfn, mask);
@@ -446,7 +446,7 @@ get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 	if (flags & BIT(PB_migrate_isolate))
 		return MIGRATE_ISOLATE;
 #endif
-	return flags & MIGRATETYPE_MASK;
+	return flags & PAGEBLOCK_MIGRATETYPE_MASK;
 }
 
 /**
@@ -534,11 +534,11 @@ static void set_pageblock_migratetype(struct page *page,
 	}
 	VM_WARN_ONCE(get_pageblock_isolate(page),
 		     "Use clear_pageblock_isolate() to unisolate pageblock");
-	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
+	/* PAGEBLOCK_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page),
 				  (unsigned long)migratetype,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 void __meminit init_pageblock_migratetype(struct page *page,
@@ -564,7 +564,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -2130,15 +2130,15 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 	}
 
 move:
-	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
+	/* Use PAGEBLOCK_MIGRATETYPE_MASK to get non-isolate migratetype */
 	if (isolate) {
 		from_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						    MIGRATETYPE_MASK);
+						    PAGEBLOCK_MIGRATETYPE_MASK);
 		to_mt = MIGRATE_ISOLATE;
 	} else {
 		from_mt = MIGRATE_ISOLATE;
 		to_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						  MIGRATETYPE_MASK);
+						  PAGEBLOCK_MIGRATETYPE_MASK);
 	}
 
 	__move_freepages_block(zone, start_pfn, from_mt, to_mt);

-- 
2.51.2


