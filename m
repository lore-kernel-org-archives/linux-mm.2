Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7820CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE878E0001; Mon,  8 Sep 2025 18:23:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA5E6B0007; Mon,  8 Sep 2025 18:23:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE968E0001; Mon,  8 Sep 2025 18:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB2436B0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:23:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A256B140329
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:23:22 +0000 (UTC)
X-FDA: 83867510244.21.1361F8C
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id BDFB480007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:23:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="gH+gX0Y/";
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757370200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7abeCEsm9hQSHKcfKnUycTIfAV4deoEGxrAOakrims=;
	b=MeR05+4kfak2+3oJxZJmRCXLzzX304qIVt0c0B4603rC+HtZzb53ZkLBd4yo1EtgwQYpRF
	UnAQ2qr0LmEQg9fCSnh61fBVoeK7S9+5FcJwdRuXRWxdf4z1f1eCEJVo3oQ52Gal6TNfsh
	N0ARVYrSswOoI075lWUoF9zoIFY6yUs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="gH+gX0Y/";
	spf=pass (imf30.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757370200; a=rsa-sha256;
	cv=none;
	b=uHu063+5UF2EHGbtTsc4TBPPvYIvCrzQO8O/gEeZj0SNWDVu9RtuuwKdhM9IVpgiG9CurG
	8Ejk9oZOv1YElYRqrTFA/6mcMchDWxgjnFWdbmIDkcf14ZxdYgbQCkIAw5uQ51a4gU22Qr
	0JTXJyLPtMLsq5aD78UxPh7h4Odo+ss=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d5fe46572so50860657b3.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757370200; x=1757975000; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g7abeCEsm9hQSHKcfKnUycTIfAV4deoEGxrAOakrims=;
        b=gH+gX0Y/sFF5p6avIwLjmP6RlSaBndYafr3P5eMqck2ynN7cTYXJxKojc9f8XQlpCK
         0OMfsxAYUw4hry/MdZ/gDvcQvuNIN48+7fJFAMcmEC8UYQ7DSWBDVU9Hf7x1F0hhLdOq
         ykIoK1XgXlg8atTsbTxbpZk1BVWjgvD3DivNms2MXoZUzxWO4l+evW/hU6mz54rdo4El
         6eeo4AW2NBsgRxwICemdBYcmFd2TJbME8CtxP4Lw5ZAX+Mafwol9erFVCMYJ6JYnQm20
         qlaZa5lv6nBPbKBJYWRVEdNVppt58zOWvQJFhy7wVdJgkjF8KzOBijR85JKJbsFYFVD6
         NOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757370200; x=1757975000;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g7abeCEsm9hQSHKcfKnUycTIfAV4deoEGxrAOakrims=;
        b=b33aT9EvMpQlgMlmzl3p9HXtqbTnMNFNq2fqXqDm6UsCrZLmSxD1U0wRA38yjrPoSQ
         CRnyyu4aVMA3W0ywnPCxaBpNGfYrxgat2rv+gUWs5Tc7Rk3s8w9YqAeM6DudLHh6w986
         OaTG7T8MOEua7bNWNqrGFTb4wh2IRl1Oaj6y9UxRmklMsmvEiIT/KCF/tjqZnFKJ+5qD
         LMrwyf69xeu9q1CmAQFyYbq0FwzihHa7WtEb/177hQa3F2BtbVbywGdrOrHdwWOGElXg
         n+u82UJMVgWF1RGynj6vuEheArlyoGEiRQgvs/VJg6POyPSh5UbFfJZr9i3sG92JcYQR
         znVA==
X-Forwarded-Encrypted: i=1; AJvYcCXndZvBxOjEQn0sTuLuVvzfXTlKY+qe7O4KDuTb1ubs9qofO9wYSJJ58q0eCYfPZOLDttZBlwxYNQ==@kvack.org
X-Gm-Message-State: AOJu0YxM567tVVvOZv3OVBd5UAhAJSW/9fyQyZd0x4+bVJ+aV6OTKGRu
	yuYQCIxn76cB+z1B3WQCHw+u+FahnX0P4lOAnRyW4rC/d15k1Z4tooUa728Gmb9lDg==
X-Gm-Gg: ASbGncuRdwmg6ipdCUIERTv/qx7xZu/NxEtvTd/dEHUjqO4Y2BbjxVXv6yzuqcp3EI2
	6FMcSTcqcCiLrJebcjK+pgssIypOsjN5lgp4E/htnQgm4mx1NN0SRagZpdIu3z4faLPLTbUk2Zn
	Mam90I7gDUDtnjBX6cHexfs6PNrv8K7qNI5/yEhHnETz5H5sYe8yy2T14VikzNIpxnpbEcbItQi
	XvHs3zifggy3Pz0P+purfN/TWqzyMNbUm1FZ6hJRaGE70fKNWr2LkXuuWp21X18paoQ3Y85ov/y
	/VpBwLe3PZXkMzwCydAIvytbl0ZQCOAU4xCPYuYhjby5gUvGME2nmnLfJQBjzg+ipBFwRAcBhER
	Q8kdlbt7NzbOVvoUVf6cxnPboox69h29HVI0tiA0H1ORHPGiLjKe9U1eRc1KHNSdFPujUw8VMqb
	x2b9SIbxte/iSsW0sL8w==
X-Google-Smtp-Source: AGHT+IGaXcFHRTY5jFLccQQrjPx7QNGVNECmiV5ybnGf1NXLoPyxyEw6ZGSR0hlBxX5NCPzGYoRJWA==
X-Received: by 2002:a05:690c:c8e:b0:71b:f0ae:1d6d with SMTP id 00721157ae682-7280a4487a6mr78339217b3.18.1757370199485;
        Mon, 08 Sep 2025 15:23:19 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-724c8ba45b2sm36567057b3.53.2025.09.08.15.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 15:23:18 -0700 (PDT)
Date: Mon, 8 Sep 2025 15:23:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexander Krabler <Alexander.Krabler@kuka.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>, 
    Christoph Hellwig <hch@infradead.org>, 
    David Hildenbrand <david@redhat.com>, Frederick Mayle <fmayle@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
    Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>, 
    Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 5/6] mm: folio_may_be_lru_cached() unless
 folio_test_large()
In-Reply-To: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
Message-ID: <57d2eaf8-3607-f318-e0c5-be02dce61ad0@google.com>
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BDFB480007
X-Stat-Signature: 4ec3y5g59ae449fnmka4nr3i7pgqng8k
X-HE-Tag: 1757370200-208188
X-HE-Meta: U2FsdGVkX1/z7UoyNyX/NEQMiT2mzQFQaBClHRiSwm/KssGfc1XnHyEkwDCVEkV8etXg1Nyj4UjgFEtJhPqC1PHB3frd9xMn0taCXMpWwfr0u4lQXq0OWkaw8rHEVibtGGpl17tm8VDgulAp+bhk05ckXjgVBr7evsKmjsheQSlXHRRcdi2nZC7e+m51VYyMG64SIDRo4YUeId6ILQpKbMIyeNPiSa2i+SVvogHeAI1JNKsrcHnxAHMqbPSmIp6TgFOsCnAVbIVSBUf7sQm8yHQ8K/qLcIDWANqGDAi4j1iHJuOTZs5HZcMd2eWbYJxlzhhZEQuyHDCGoYgXpzzLcsjyuShoZ1m3HFrYzJE5KU11YWVWRb8WipK+uiJrZVzGrw5IIrpGHyuPAallIf5hOl4xQy5/8HyVZMS4PH1oc68pErnnfTCbr8H+YtR2PwKoSZ6wz8q+dtQ25LUztJLfv6VLDikrwjNRdoFc4TF81s40xL/XqDTwH1c17W64O10fpmGx6+hYseZqJDdkbqtVcro1BUWehDhIURyTMqD1sbpv5jUXoOlZMwMHMfPGc4/lKKSKH/KmPlntxWckr80LGD6oMGgytEvCTEhipv0ODYiXscvZqpBHJ1kGUAs3/3VnFxJ5TFP6NXCS4YSwUC8nQKFRZUTB3rb9XWikM6znVn7l23WLOx3SgqxuKPvXu0YP+KIl0X7jD4NHNGurNrjnP7APK1c4CQl5dKcgC5igCSfyqQHqHntJP85ZNKxt3qgWMARe/aOrmWTo0m9QtWr/4eBx/D5ppzA76JMHj1m5FzrvK4F+2H3krdoT5ZvSZsYIQIiVy4HPxeHcTz8F7CYtsEK5kI0r58AmASy5TVlLPNxW4m5qyyXdMNfP9Nsr6MLvmijIJAonLTp2hfBRanjjf5tGG5x9Maame2xP2epqETzWSm31dSQgqmF7jwJyFfR7Uophmn9z/1OcKL99zET
 OndUQtWH
 c9bYtdGJ8QE7+zC7IbTTav4nDgfd/JO57h9alc05nZUHJ4ql9vZdbgD+d7at7+co8FTetpSrL815ss2MgXNu36rynwbyUCq9tkKvrk4qgFROBRKY4ywz2bZkDcW0Ye8oCtb71+1hWZMI9NHVuGC6zL8i0ozV2OTanUND9ef0ZuShB7s9CMs+s9tqz7CxvgP+YU44KYNNg3FWQZAQk35R9y/Q1kfDzNXjQSiiNUDKTvN+f2SS8FwZQglhKgKPwadhjeVBfD1FVS2B+GFKB/DOPj6iMQxhMxnkKNJuveHeFzIZ/Wx+5CF2HYtxKnKBKpEyMDKJTarc6uEQD2hPAay1pecDucVft4eiOlfvyWvGOawT4CzzPMUL3BBwKYreoDAYPVoIKG499bLPUbttP/795Epv5v01aBR28QNyUPGxmQ5BZdR+hT941NJ7GAKsvg/UGSzfCQWBNchJJdnusmmde1tORYp56GxOU6sGU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as
a large folio is added: so collect_longterm_unpinnable_folios() just
wastes effort when calling lru_add_drain[_all]() on a large folio.

But although there is good reason not to batch up PMD-sized folios,
we might well benefit from batching a small number of low-order mTHPs
(though unclear how that "small number" limitation will be implemented).

So ask if folio_may_be_lru_cached() rather than !folio_test_large(), to
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
 mm/gup.c             |  4 ++--
 mm/mlock.c           |  6 +++---
 mm/swap.c            |  2 +-
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2fe6ed2cc3fd..7012a0f758d8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -385,6 +385,16 @@ void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
 void folio_mark_accessed(struct folio *);
 
+static inline bool folio_may_be_lru_cached(struct folio *folio)
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
index b47066a54f52..0bc4d140fc07 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2307,13 +2307,13 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (drained == 0 &&
+		if (drained == 0 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
 				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain();
 			drained = 1;
 		}
-		if (drained == 1 &&
+		if (drained == 1 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
 				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
diff --git a/mm/mlock.c b/mm/mlock.c
index a1d93ad33c6d..bb0776f5ef7c 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -255,7 +255,7 @@ void mlock_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -278,7 +278,7 @@ void mlock_new_folio(struct folio *folio)
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
@@ -299,7 +299,7 @@ void munlock_folio(struct folio *folio)
 	 */
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
-	    folio_test_large(folio) || lru_cache_disabled())
+	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
 }
diff --git a/mm/swap.c b/mm/swap.c
index 6ae2d5680574..b74ebe865dd9 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -192,7 +192,7 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_lock(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
-			folio_test_large(folio) || lru_cache_disabled())
+			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
-- 
2.51.0


