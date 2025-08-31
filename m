Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AD2CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0988E0003; Sun, 31 Aug 2025 05:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42AA38E0001; Sun, 31 Aug 2025 05:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340248E0003; Sun, 31 Aug 2025 05:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD5C8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:16:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1F5458D97
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:16:32 +0000 (UTC)
X-FDA: 83836497024.21.E579580
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 005D680008
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:16:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="R0HWzd/0";
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756631791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVj1TJZLZFaRr3ag7GRilGcLLKtSMUW0HsbTS6/7Wj4=;
	b=PeS4e7LQ0kCINMO6DVlY8tYWqCSrglmqldvrJrkvPyR3w3PU69Tt5LJxRdibcS07besXZ7
	k0oxNeWA0sfRv8noSd0WSidCh8wnX8gKQZz14rK6aoTEL6Lz5z8vk1RvijiBkKrn67UoZq
	GFKNOmZ6zClBXTpgS6vpz+LTG7TEWKw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="R0HWzd/0";
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756631791; a=rsa-sha256;
	cv=none;
	b=YR5dPGrHkAoUCO0Mh8ftOS6rV/XM2K+WCbI6MI2BqBpZem+ePbBQUPZspJp5wNZy3tfdwK
	bWQAXdlsK/cqmQUWkI1iT5yOGLpb07YqM5CTqCgB4fSMlEW9QTCe4IlmvsN+rB8SGDVMYT
	qn1/i8eQbp6jcp/3w2fRu+peb59xkqI=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d6059f490so32660087b3.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756631790; x=1757236590; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fVj1TJZLZFaRr3ag7GRilGcLLKtSMUW0HsbTS6/7Wj4=;
        b=R0HWzd/03K6pMdR801SUdOiOHjBFKa/pnjohrTNA2U7buTvIXH+t3YnzYV2ToGEMvm
         cJDzIgP5BEwZ8ivtc7aLcoeDoynuJuEZoTS0BqVopY/rqzTepq0+bPxb+bpRS9uyeVfp
         Sk2gxwrqcIbaA4wKHrsu4i8H1LFhEE51hAzoLYuUNmy5gcJyOyXNJuQvgss3G7OpufnA
         mfm5IOowMk+fV0EG9iX6sQKTx+MWCGXYutpq0UI1FAjsYGoQ/5hqZd48b/GkTWNp7bTC
         JB7+JCG5K24kHdhyTH5uvDsPvhp/kaayiDRcFF1hx04V5kQO5dqolW/1aRcOi9fRFiYw
         jSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756631790; x=1757236590;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fVj1TJZLZFaRr3ag7GRilGcLLKtSMUW0HsbTS6/7Wj4=;
        b=O63qoB92bb7edA85adFc+sZMR/TKM9d/gO1+ToPaLLpIoeqGT3QKwFqjioc8zP6OeB
         Q04cnvZSptnJyL7nsPfpUJF8lsGsGLDa60TYvWHs4uY4kBEAzlCoDmexf/mn5Km+GT59
         +Q5JIIUK+GyJEOxt8ycZyLR3f/zZQkLu7AHRj05YNSSMiqBvNUYeN6H+0VgcvqFYQBnT
         Xg/6mOe6hrLs3mHBdNa6ZAUasitZxZz8Eej+qkaFQlUbCYZ/bl/BNuxiByyT7BLqsK6w
         bLceO0nyQo8cia09TReo9ArMlZu2n5OnZO4pcUyoSV/gTnRw+vCGznionjO6d0pfLHNA
         8Ffw==
X-Forwarded-Encrypted: i=1; AJvYcCWKZSCn9l5GO3aK3acIn+uLv3oUljyYrStZX4Lzw/09jtrliztfw7EGGVSbeMbF+Q2IouO5Y/8SXQ==@kvack.org
X-Gm-Message-State: AOJu0YwZ5kM5/4/tgPclJIqBrJCmoO+HrJvSGK2xW2deJV58yfWjwoq6
	oWfZb1bf1I9n3erEjrLRhsS2mm2DP7Z6RrlKz1feUKybx4lX1uhqL5nZVm09x4DQig==
X-Gm-Gg: ASbGnct+MgSKMwa4JFZFm+ujv6eu3yyH5isfkrSBA1FdvGbrWDUQKbkz/aUiMIOchfA
	U+O2Io63FnSYJ/uWKnKppaStgp71sIVksr1bS/yaLIU/RZKGvSnpjZ665dQ9nS74WAsmrB/XfjY
	KDyIxlD5t4gCuB2xTfaQ8Lut40OdpthjMaGH+heeX+ri7JkEWkTdcpt0YebzjFqS5gdBAuaPc+K
	V64DFdOZAw2Zp2ipXIQC0CjvbOp11s4lKQtDn8v35yg8Oirvf/yrxPxFbVHIaUSz9AfePo5BWx7
	gRerpL8hMYF3KT4AgnZz0cFmMI0kNuEkd8lQQPkJCpz9ykPupvUCFPy+KBKOVv7/k6SAzCvkkTb
	lZGe+c3M2V3LSKFSLgZqnvjxHRsmuyXKC4+vU7YtHfPTtCYAXOyzWwvaztK3gI7fuAVfB0MA9X7
	+7aEFPqYrzXq24RZcPlipQNTYT
X-Google-Smtp-Source: AGHT+IEvYKErI6ke0DEYK4ijjvJ+cTpg/4z2kMEoxFGpg8eCQJg+xtsOc8H11hahONN9PzGte6TGbg==
X-Received: by 2002:a05:690c:e08:b0:71f:b944:1019 with SMTP id 00721157ae682-7227658e0a3mr47176947b3.52.1756631789908;
        Sun, 31 Aug 2025 02:16:29 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7227d634d22sm7255777b3.26.2025.08.31.02.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:16:28 -0700 (PDT)
Date: Sun, 31 Aug 2025 02:16:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, 
    Shivank Garg <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: [PATCH 6/7] mm: folio_may_be_cached() unless folio_test_large()
In-Reply-To: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
Message-ID: <861c061c-51cd-b940-49df-9f55e1fee2c8@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 005D680008
X-Rspam-User: 
X-Stat-Signature: 61q5bex8s3g9z5zetm8q4ir5gqs9bf9d
X-Rspamd-Server: rspam09
X-HE-Tag: 1756631790-167977
X-HE-Meta: U2FsdGVkX1/MuWrxhQzjin87Kl1jUhmtuVTKpF2Hb/fpIyBkykaGEWZkTZSfjqER7UwG8Oufn1f7QPIXbC9eLkCMdSj3QP9jYHpX5SlyPZqqj53vY4xgSx4sHb3MLZqtgovP25UmL1qNnYxEmwgzIlF4FD0Jek5ZbLBceSKksyhnRjNTWf5i7/mv20HbhtCDv+7btgbcg2z/aclQ2X2IVJf8wd/YLrpWn+5fIvJkQnXGGORZggcaYNL1R3dxEL5ggGhL3YkBj2H4LwL6PQTSegJ4zRGt07O4yYxTwiMmf0JboNjTIm5TygvPUmhVTFv0wiV99yajZDTz8bt/TX3CDIpgXcfEbbhbiaZhStSbf8hCInGvkA53xehgNyzIqUlySDiS44IkVH6h2YimWRJ1s9I79ZIZn3x0W6EHsLxaS2qB1c0n+x4FPsUJmsdEXs6PY3/geOTTGLsqMj3RJw+Iodv05UykKusS6i3026rs7qF5jH96PXYo0E6pv6Of4xHDyxwn+4pNzi+k2AkfmUM4aVCn0/l/dd4efvnGCLIzM/xkS84pEA+V6HYFFCFmqp42La2VhFmFhVxs+/MVje1Z6oOP6GeYVCEEGdBw/w26WKpXd0W124hYyKCpmuR/WyM4zJCjI0vc0h4M2vgo2fypJzMA9XnVgfS7Oqx22EbkLXKYirvRU53qsXVUYpkAMBh8IWQqUwQukDA1I0w2XRDbU1rREu+bUzyzh8MTBiTTONZriZjZ8lk9bpKav2ccdnpH2Z+laHpIgCx32fA8rnp9Wj1V494xbEW3XZ0rT6O4XuSE8YgJCnkoQCJYamcxTTocIrv1zpY34HsErlTvpsbdkbkcbXlQYa/cFJKCPHqSqA1184kSKP6VmUmIL1jT18clxPQm1H78xMPtQHcIQ8OWwOTTxPMwjwO9Q+RjtxUZwVelCVV8yaESTy9jpL6RHGMmrpFjmXcm7+K4Auh2xoU
 d1GRMfYO
 cSD9l7IgJHEDoZ+ckBppHWKaqgfED0blNFF73KHCyl+cJiAoNJAqBeBfGEM89dEZnEmleDGAkImbAyABjHlX2TDhgV+DjskXHXNFbgXDnKF4xRCtysFA1vWmMfY1ikNVYwzE7LhQsupyQlHrWbOuRd0JPlAsL4wLVtvFdKGhFuzQljqNoqeXB8XBKnT7m4KyVxWDNcVWrB9U8oxPGG04oxrguLO2n2/bw68w8Y5Pl6MS6J0T6z1ZJiYlT9Z862ibydaz2L4SPAfBZhWZWwveIi3j0LdqoNTJIYQ3YRKZhX2jkQDeoppaNdmT9evUofo20eZtkWyYwJwf7a1d1rmW5BJOub58LIDw49TVVdWO5M15K/JBHBfdQ8gwXwnG6EYNYmRH13U98i2RyA/sj66CDNqNdjCU84DE+0j20VfW8eI9185Cx9FsoyRLIgJC4rj0M3t1jPUjpcu3bJpmaqmncMmqyF3a69vZBWsJR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as
a large folio is added: so collect_longterm_unpinnable_folios() just
wastes effort when calling lru_add_drain_all() on a large folio.

But although there is good reason not to batch up PMD-sized folios,
we might well benefit from batching a small number of low-order mTHPs
(though unclear how that "small number" limitation will be implemented).

So ask if folio_may_be_cached() rather than !folio_test_large(), to
insulate those particular checks from future change.  Name preferred
to "folio_is_batchable" because large folios can well be put on a batch:
it's just the per-CPU LRU caches, drained much later, which need care.

Marked for stable, to counter the increase in lru_add_drain_all()s
from "mm/gup: check ref_count instead of lru before migration".

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/swap.h | 10 ++++++++++
 mm/gup.c             |  5 +++--
 mm/mlock.c           |  6 +++---
 mm/swap.c            |  2 +-
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2fe6ed2cc3fd..b49a61c32238 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -385,6 +385,16 @@ void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
+static inline bool folio_may_be_cached(struct folio *folio)
+{
+	/*
+	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
+	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
+	 * will be sensible, but nobody has implemented and tested that yet.
+	 */
+	return !folio_test_large(folio);
+}
+
 extern atomic_t lru_disable_count;
 
 static inline bool lru_cache_disabled(void)
diff --git a/mm/gup.c b/mm/gup.c
index 9f7c87f504a9..e70544c0f958 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2309,8 +2309,9 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (drain_allow && folio_ref_count(folio) !=
-				   folio_expected_ref_count(folio) + 1) {
+		if (drain_allow && folio_may_be_cached(folio) &&
+				folio_ref_count(folio) !=
+				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
 			drain_allow = false;
 		}
diff --git a/mm/mlock.c b/mm/mlock.c
index a1d93ad33c6d..427339dea380 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -255,7 +255,7 @@ void mlock_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -278,7 +278,7 @@ void mlock_new_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -299,7 +299,7 @@ void munlock_folio(struct folio *folio)
 	 */
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
diff --git a/mm/swap.c b/mm/swap.c
index 6ae2d5680574..17438fd1f51a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -192,7 +192,7 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			folio_test_large(folio) || lru_cache_disabled())
+			!folio_may_be_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
-- 
2.51.0


