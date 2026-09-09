Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6F7C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C1A6B0096; Wed,  9 Sep 2026 05:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC1F6B009B; Wed,  9 Sep 2026 05:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE27C6B009E; Wed,  9 Sep 2026 05:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE6D6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:55:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CBD4C0167
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:55:50 +0000 (UTC)
X-FDA: 85193767260.11.DC39178
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf22.hostedemail.com (Postfix) with ESMTP id DC834C0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:55:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s4Wg4R5i;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947748;
	b=MVa80QZLrbpM8rTA32KoN8P3TVZX66n8VapYEg+avUl3KCiRp1aJ5xsCrN1cTAHplQfSs5
	o2rN2nqN9r0qYrgRLPiXcLvvWDoHPYLDuzCUGe9pU8FAW9YpfImpqXvvgGKnAR6nt/s8t7
	csCmpnbaxgCERjMh8VKMkMcQ2t0A5ZU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s4Wg4R5i;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OZ5HJWp6Sq+cHPfV8As3zDywlXal3eQY4p7OoCaDH4=;
	b=OakM+p6u4pAoUa9k4yzhoo2oh1yNbHCKuCZZkgse0wk800aGQ/9Am1a0EGf8Hq1HiUie0q
	e0ImcdVjFPgZSqzrKZSUsY3ToPzkpU3+5FhLrF4dUMDTQHvynzGSQOsn5US3qpQgR3jPBF
	BhHb626NX8fd/+GZ7mgiIjs5sfSf4qg=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d46e4cdcdso9364887b3.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788947748; x=1789552548; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9OZ5HJWp6Sq+cHPfV8As3zDywlXal3eQY4p7OoCaDH4=;
        b=s4Wg4R5iFE97a4Z7LNdLJhETCYKqwgEpscn5EZANZh9CFVYhVcqPDCKl3JvuMrk4R4
         YLwioyj6SaplVhPw6ymqy/xgJd5f9ygL55alH4cQEPfRC+KDNtTf6ajg+fap+VRTGXFx
         iUm6/mGqiT0TaXrRJ3TqBshOZ4VvnKxdrR4RLXMX6VoBd074an6/BgX91g+2uRbwYxDx
         n5vNpLjvTdzhCZtPcYW6p4ubNFYMazT63XaBp0wqwlNX72SV6fsYOkPYfvb2UNhoULyT
         n3lalfHKWHDdC5cybT2x/HKAaEcgFovr8+Vx/LyVrlUkzVyQJCoh3KgcOEng0nePgggX
         odtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947748; x=1789552548;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9OZ5HJWp6Sq+cHPfV8As3zDywlXal3eQY4p7OoCaDH4=;
        b=cVmc3VoVpdUtADoucM9vN1D88CT45MFsRfexeaVjfsNsqcKK0IqM81UgzB3C3NSutL
         nRGC4zmJM/RCF1BWQWUzrpsWznC3V+Sh6xVqfqHWBlRS6aA3PkNGM0MEgLocRKx5GyWz
         zIFs5jt+SBY243J1VQwAsazwItFBKnNDbCvaQB3+NBrNs/Vn10MQEmx1SFz1Swr5P6ER
         AFxX6PL/Dir3zTdS7MUk/1Mgme70/cUqCRtGp4IyNDX5+NSqEVqt8a+OfQc0fpk1cIs3
         N0n2NP8w4pHIIyknKj78Pq6Goj5+Zk/QKbPPH2zkrEAiD4D+GyDyObEDr9jVu+VIvQSY
         uYgg==
X-Forwarded-Encrypted: i=1; AKwUvBx+4uhcqfRIcCThc0350KQBqXzwJwv1+leapAKEpkjaVwRcnMYgWgro1QEYftYatukPSfjsOTI2RA==@kvack.org
X-Gm-Message-State: AFuF++lJDowEi0Ott7HtO3NO/5z79HrOZx4AVNb7pLyzaCTnYKA3Uv1W
	k3a5xzTa7acZszHryBA8ITbypw7KrWCtzalNMKHQ6yZsgU0d4EQdt4jmfO+ontum3Q==
X-Gm-Gg: AYBFou0q3n4PWfQMR75TLKAiWwuxNpq5w/m46mTNBIFgRKWARYO3OvehjB2U/afGgYs
	tDa2XKO70WqH5VP8p2HPmzaPw3/jQWOfkg2tV18CQ9NfmSrbfcHFuAnFm20abelXHugJur/R+0z
	AkbtiSwrN3y7maWuZnTlj5N6tm0zwvoKisu0on6HUjtmsS/lTIYCLvH4yggMpkMCpBG/pskhzev
	EXmVFjGxlsW8qs6M7rynEouaEXG0D+jPGVahmwyAldx5FsWScBhihXr9OWCO3Q2NRjaTWNVjaiu
	ee48ut18LnTlz12sGNyjfpXjaa62lxQaPSULQ1SGeryF0LEVDAB3QV41IbNgv2396yLFpsWXIhT
	v7Vhmeia2ccQCgC1WNBVW21wzGxr02C0weIntf+7wImtRiWM9E2baSWnh6vv0o4xZ9WkGIm3+WK
	BK72tCPw7pmGosBHG69RlM/i5hRY+J/qxR1fkdN5ndizMtdYQ0+VvWXg/cOQAVKfm/tY5muchak
	rYQK7eic139egDNO9Z7QzIjd2HnLMYfg07qcoAOdwZh8xsGVmY4j9OeJKIJGHpluCZDSw==
X-Received: by 2002:a05:690c:5885:b0:854:9062:73ae with SMTP id 00721157ae682-87f29d02667mr18443457b3.33.1788947747384;
        Wed, 09 Sep 2026 02:55:47 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714ab77c5csm107163607b3.32.2026.09.09.02.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:55:46 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:55:41 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 07/26] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DC834C0005
X-Stat-Signature: tisejmz7q1h19jhz9d8dw5sgbtpmgkhs
X-HE-Tag: 1788947748-165231
X-HE-Meta: U2FsdGVkX19mhgEqgB1AXF66fHqkpbqFKiswhF6W5Roj/d74kaNeEL6tFGfIuvKk6SXDYG+vOHqrPeuRMCll+srF2b/+7DV8746py5F0ISfFomxWT1TBjfvZavrmn0iImp1NpkNqDU6HKYm1clS5maDkulRMotCebkydHsQHUx/SfBomtYTiJdhu2wVVdKgPj2t8cdWEF42wwnsC4CoJ7/kDen6mMpr4l0SofbDMBharo9k6hJxEsW19+vwZJrlL+N+q3tvnq8BuBZ7VO4qh7wdaiPz33AdZFFDLF7FQAQnAGrg8k3TBGWVAf0rgPc4ZZfFAii1aUjkj8xVPKJrtoDNI2MsKAuFGH7pN95No5WcDQsHjKxmNLA+CztbInqzziXWWzpaaeTYGZ7xDFyvujRR74DJpsMewbOmw6dWN/446NGicrr5w8lgklMGqTxquKoe25mNoYi/MNJgnhfep3tRqBx0EzCEEU+21PNn7SGdgR7ONpGXBEg6gUasbJGTANA5LFQF6jtEajlN1PmkSCyLHF9PhN4O3PqatytzFsAd2Gv9N4jhTNZsJE2jXkWgEVbzXZODVE03SlK45/bYLFbgT8F4nX07PDCoagly+2oQ7kctpiPAKsUUjpEMM4oi40QFc/fEE94H156lH7DMLnetGZ42MqFiRy5Z2Kl+YTM1WogTWn8ze4/4e2ghaDFqPn10+P+8RAvqhfZHBbsU/qpyhZyhzvozcbgAbLXgpW/hMeaBS9/HA95Ew7/QWMhCgJIVXbmaFVzQx7wm2/yuWGvGqYCZL2o/46I1d5oiZhjMVFTppr6CuFQue/hDwj7GktTKJZzze7/IaCINyA/v/wQe1MZqpIP+Sc4g/+C78v3k875p2jegeA/xL0sr7enSXCYiUXC8MIGiful/xO4yOVmBpAHXvuVFA9OqJSVUDr5yQd7rWATWKieOkLHSmofIueM1L6TWcIv12w2YRh+Q
 BJwY61bo
 oDk0F4TsIBJW0UPtBy4rHrKd1YSbNidCWgCxVi1J2+TwVKcCNslY70DsQiSVp61dWgLKKzKhhjYnSmwHF1lGhdm0LBr6NNsRoQYMS8snOTkHUY9CE07Y9TOBcpi039GSvLapvXHJ8UbYo440EiZacYsgVIfCRff+UKFfl8EYqmrEifd4mlyeYvz2cV63rf8rkrL0xqBYoHdvEJCh/MKTTirpacZxQ6MzhA7lQdEGp+qh4IDvuTQXNxysBzBTtITJmXL5FqQXNLqTHoPVlxd9ge/MuSJhrPggg0fQARdeDKoVVbd6EqBxfGQ/5mrh/SEN4PPslJRogf2ybr/XdeNUYQbr7XhIunwgY/PL0ES5RiEnzsnIFDl8jIG4uI9Bm0rX9bBPO5B+zXKCMU0zbGsVhW4oEa8Edl/E58tm6cGj7skTWsuRNpa81Yrv/VBUDq9EwzEmpmwvoI85d+PbH4mmaREVGxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement an equivalent to the old __lru_cache_activate_folio()
optimization, to activate a folio recently put in the lru_add fbatch,
without having to put it through the lru_activate fbatch too. Neither
lruvec lock nor lru bit can guard this safely and efficiently, so resort
to try_cmpxchg() on a further, LRU_NEXT_ACTIVATE bit in folio->lru_next.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/mm_inline.h |  4 ++++
 mm/folio.c                | 23 ++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 8420b1276535..8f5efadf9c7c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -346,6 +346,7 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
 enum {
 	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
 	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
+	LRU_NEXT_ACTIVATE,
 	NR_LRU_NEXT_FLAGS
 };
 
@@ -358,6 +359,9 @@ bool lru_add_del_folio(struct folio *folio)
 	if (!(lru_next & BIT(LRU_NEXT_BATCHED)))
 		return false;
 
+	if (lru_next & BIT(LRU_NEXT_ACTIVATE))
+		folio_set_active(folio);
+
 	WRITE_ONCE(folio->lru.next, LIST_POISON1);
 	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
 
diff --git a/mm/folio.c b/mm/folio.c
index a18d8ef6afd5..0b75c3b69d5a 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -256,15 +256,32 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 
 void folio_activate(struct folio *folio)
 {
+	unsigned long lru_next;
+
 	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
 	    !folio_test_lru(folio))
 		return;
 
 	/*
-	 * XXX: It is curiously difficult to recreate safely the old
-	 * __lru_cache_activate_folio() optimization (folio_set_active()
-	 * directly if it's on the local lru_add fbatch): revisit later.
+	 * This optimization is intended for the common case of folio
+	 * having been recently added to this CPU's lru_add fbatch.
+	 * But since other CPUs can now take it at any instant (after
+	 * a folio_test_clear_lru()), and we may be migrated to another
+	 * CPU, it is simplest just to extend the optimization to all CPUs.
+	 *
+	 * folio_set_active() would be unsafe without the lruvec lock, and
+	 * a folio_test_clear_lru() here might cause a racing drain of the
+	 * lru_add fbatch to skip its lru_add(): so use try_cmpxchg().
 	 */
+	lru_next = READ_ONCE(folio->lru_next);
+	while (lru_next & BIT(LRU_NEXT_BATCHED)) {
+		if (lru_next & BIT(LRU_NEXT_ACTIVATE))
+			return;
+		if (try_cmpxchg(&folio->lru_next, &lru_next,
+				lru_next | BIT(LRU_NEXT_ACTIVATE)))
+			return;
+	}
+
 	folio_batch_add_and_move(folio, lru_activate);
 }
 
-- 
2.51.0


