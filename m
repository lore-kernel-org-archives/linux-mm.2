Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CB3C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE9D6B00A7; Mon, 24 Aug 2026 10:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFB26B00A9; Mon, 24 Aug 2026 10:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4AA6B00AA; Mon, 24 Aug 2026 10:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 833A96B00A7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:09:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21707140126
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:09:43 +0000 (UTC)
X-FDA: 85136346246.06.C78973E
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5B06040006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:09:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lnr3Fukd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCdAyHrZb4E51CG+1fE1lJJ+Rs+kWhPosCUCdWMIdjI=;
	b=Eembg1FN48L366ZpNHBT+fFuCfaWd8FR8bYLkHXTb80QfUPY3dbZRnUYSy8nDWKshOEJM1
	UmDpr4T0raoI3Ct9O50DcYbFXN5U8V/KkxzTLMS+AWNgiVUw1HTKA67L2HgtjNtlf89GOW
	Ww1XyM3RHVWj3nnUXvfI7WB3iGvxlnw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lnr3Fukd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580581;
	b=dSnGvLo1qGTt6zyxKoY2IQHA5Jo62UEOIswWL2z94S0SKIn71bgTq/jhnd++fWnhDQxpCh
	TfVY3GZ1xy2FxDJwRa9tNTNayPnzOCwWU4Oro7cEF0FN6kSXMoj7bToWMRgrhe3fg+ped4
	bI1hd8Ryu9iZVf0bpTBMIrTBVHisORA=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-84c4d4f68c7so37891907b3.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787580580; x=1788185380; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lCdAyHrZb4E51CG+1fE1lJJ+Rs+kWhPosCUCdWMIdjI=;
        b=lnr3FukdvyV/eAyyw/e77o/sw8F6wO5/knuEvc3bGAThjQgIJiEJYL5gOdEREGAYpM
         3GwxGVVWtHA5yPAUVAG3e2p81eCqep4g3YBe6Z9+rp2K/hnQLAVIE4auWwDp+hNySoQ/
         1AIilW31LhTLKRmKuZqpuhP4SWj5fiZuPaxidvRZcLx0X1mCqZ7BLffWz1UMrbOrah6M
         NKXz3dUE6o/Ai2MgottomUraatLFlNTEQoZo2uI4aIHiR1UEqPHvgPFlaCat6kMOHd7o
         3TvskmpG5z1cEkyCs75WXwWSrjwIZ4Rw/jFqgjfp1L7sihDuqEikbx7cvE4cSj7Z+w77
         wtDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787580580; x=1788185380;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lCdAyHrZb4E51CG+1fE1lJJ+Rs+kWhPosCUCdWMIdjI=;
        b=WV611YGhQ6GjBlegO2pCwvcSzS2tZaEkZkNz39k854Uq8tb1JGtQtQUUdypwzydK5p
         5/JnZ6/xqbT3LiyTc50x0LoA/hnQx/uaToWeI1mQIuJ/4kZP0jksT6i42nx0PzB1QQZf
         ygq85Tkvpo4gpytrFjvvTeBCsDV/N4sRCvGny+DcwRcPTzpYGyszUr1uOgXkVbSvYzHa
         gkcHsigp1nVt7DUHLksdbVRhJA3p2kIprYCqUBryCXx3XSMi7aomuwUnTZDxOlIU28M2
         16lAhtLhz5SO2ruv9BXcnYE0kj4UYt8RjdPPYO5tGXOAI0StazInOKlFQ6Hxx+0NFrIL
         Uttg==
X-Forwarded-Encrypted: i=1; AHgh+Rr0SJL+9UBIXZ3D28ZyB1kydgW0rqIcHvWTJH5mk7Y1wSgxoD1UpkN4U4UpnAStXA2KGmllWkQrTw==@kvack.org
X-Gm-Message-State: AFuF++mhzcI9Tf31RqgNLJmP4lM9RLwv5/u7wcwss1FZewkJkq5ilg2r
	xGFrbvpBlQD0lrdL6sUADS60G5VIbaKcIFc+EcqTgBOY2FTMdRasl5jsji2VDqa2qA==
X-Gm-Gg: AR+sD12wn8SXjr37BPjTyH/NScJehlmNtKD2+7iv5/jiWcmo/Hh+GxwFc7bv5wEac5U
	ggAN/NB1nkgBrfK1BAwp38hAg/yXvS52/vZBDANKnWD1imTTFXRiELttJ3iigGCxO9e5TR8S1lU
	XTwdbb+3dhtly6gBFjt90MU/YhNICbiZhbF8t1y1wPRzLCxHlRc5Wrp32kBUMm93uCSb2riB0N/
	7AptpKcHE9Z6Mdl4+dZariPOFvBV/RSSYpIcprZ+VA3QnpiFtF2pyoj6/+7qifhQSk7j5xzr7ZY
	Gr1bi/Y3kXsdjfCUgpSZu8YGef+kkmeu212Ny197pYF+ZPHEhXKn0OUZoyRxGK4vFKLpmZP2MM3
	tTKyJpVG9s5OOEtIXCg8aFnLzWg2NVhNMmesJm/LyPJgv1LeJFwbUQYmV7lsrhxl9sos3YUiQFU
	fpeytdE0EFTeP//MaKeKLckGJOTSryg78ewzvf2wLQZFDnDnROHRbf/wBJmJx6YuMRqgoi2ptOD
	TlbAhWgdfsxA8zMaYlLcIw21GuPoYTKAAVyO6RMpn0BjaUQ
X-Received: by 2002:a05:690c:e1c1:20b0:836:ec3d:b5e6 with SMTP id 00721157ae682-849f5dfebc0mr66916777b3.28.1787580579812;
        Mon, 24 Aug 2026 07:09:39 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84ca5d252f0sm33979987b3.13.2026.08.24.07.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:09:38 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:09:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
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
Subject: [PATCH 07/25] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <16b39f43-d91e-7b23-900e-90cec13837ff@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: ayf3fyc1e7ejr9f7esnu93c3pqfkbid9
X-Rspamd-Queue-Id: 5B06040006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787580581-681716
X-HE-Meta: U2FsdGVkX1+V9XMo4AOCYNh80aG0mRkGaMhOP9NE3fki1yUtDQOt7awZeyI100opY2/Hnw3rwo0wxxjq+qKDqlRR/ywSwhvzbfd4I1+lInj429P+HlmV9rr6c4ll0Pe38G4GoJLqq4T6b7UYvHAHfn714Lj+q29rhZIsF9mtegA8jvGD1/HksARDuoZZUAs/om9Bf0l5s0JjSTERZCqr2j9v7C2jNHqdRk9/+SZJO0FloSlx08lee12iknGy5p695P7BZIvRNlgut90j8Bb2XX0ngfxtV878+r6zcIUjZDiUdq+bv4UNcnUGYOmKvevOqmdekkNjVvsDgvJ8TCRFDNhhTFl+x+2+NmI0TJMuiXFCwLrNe7dyDgr+sgHqAFqFVt6qNRmy5xD/79LSbUaQDMfvzfGaaR54xHfafwcySodkskkvQQ/83LR9NbYGsBSmf/EOxO4SqTmvPFEPTRadRrfrihkOfbqD4jfzEDaOTtTyt5YeZ9dBSF0zYSwgaEWfq5zvHnZIk7bVlvHk51eTEw7zfGkYhPnMR/DHdqlRipo51SxmL/2YU2g1oSbOLQ2X9m0ozvBpPC5mZ/wiO/WqpqYA5o43DDKphYA1oQGeKUtvbDzRi6Z7m2vl8Cxx4M+ijBaVKEg8tHVA14uk3IaxbdGr9JCiAOf8ze4nMvBn3vPsWWVDI9aJBlmvPB4+5A2pbsBsQnggK1yXBwaQ6bxziMFfmXeFxeoE8uvjiz02y3dbuCa591BzJyoLoZVbjXwTH5m550cjGB/s9Afv0aRswxphuDMQBnXCYupVAMkFpegPx3LIr/3dvUq2LsssTv9vfEydVt2xa6d1SuiSzTBYtYtLjCdvUYc+u3dJTZGW0TLv3vjK+1O+SMAlSzgxvasUz6KBXx58X4gCbUNCA/Yx+5N3SUyR7anPoXccZAJd7sZDzjpT20l2IqfWCojf4+QuEBigwIqk8BbP5aXh/nh
 8naSCBUh
 5oxMYMXZyGaebEpZZbDo9yUG63souop0YLZrW22uqumKyohuCQgRCc6CC8LjeWPzZLJofIT6Njqcl/9WvVnZF6mk2HyEGNDaXJeo+47JjxkhiLropT+DbJK8WOr/n20VTDB7+iChf3U7Nu10JDm7aHWMnTw+/+UPYoQvtAluFPWfaLJZXtXJMRWA5w1FA4UFdnRxO8uAp7ol2fTGHGQnt9MnHomo3R7jTuO4xPctajrnJLwGCimS8sTIBRxbOklBXl48KmAQe+aYUsTsGVwwM5ls7IxejhV7JwlP4mXw4mTodE7KpFuMpnokLQI9e7WFqJsiUT2X6bWfsGOS0311A4OvDv2PBgwsAQme1+nQ7plLuWBKG0K39fyfEy8CTOIr0JXjrpjQsfCBW13wVj1hqGMbrf3ycRKpURktKhNjely1ye1pn7vWR9kbfRJg+CCLXgKfR3oxdhhYt81CspNnjHe7StefSFQ45MKSO
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
 include/linux/mm_inline.h |  3 +++
 mm/folio.c                | 23 ++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 1ecaf2ef9f2b..1b54900e87f0 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -346,6 +346,7 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
 enum {
 	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
 	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
+	LRU_NEXT_ACTIVATE,
 	NR_LRU_NEXT_FLAGS
 };
 
@@ -355,6 +356,8 @@ bool lru_add_del_folio(struct folio *folio)
 	/* BUG_ON(folio_test_lru(folio)); */
 	if (!(folio->lru_next & BIT(LRU_NEXT_BATCHED)))
 		return false;
+	if (folio->lru_next & BIT(LRU_NEXT_ACTIVATE))
+		folio_set_active(folio);
 	folio->lru.next = LIST_POISON1;
 	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
 	return true;
diff --git a/mm/folio.c b/mm/folio.c
index e76868c95acc..0d8eb9cf5ad5 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -322,15 +322,32 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 
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


