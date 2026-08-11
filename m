Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DE5C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97D76B0093; Tue, 11 Aug 2026 03:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6FD66B0095; Tue, 11 Aug 2026 03:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD496B0096; Tue, 11 Aug 2026 03:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93A316B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:17:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02F4AA0B18
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:17:44 +0000 (UTC)
X-FDA: 85088133690.05.4664EEB
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 110551C0003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:17:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=whoONuDu;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786432663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DFqAUEtZlp1HILfzDd0oPsCphQU6caRSwneCZ/ZFUY4=;
	b=uQiPoSzbLUQB+mjbvsSmuXZreO3eWWUxTnjuV1mPdP4YH+P8LRW8NBx6oClnFlUJj7Cvm2
	PxcxVAmJFAhha15GZrE8B9yet0jkuOFUiDdwSIYb/R396KluIM/oMGhREWLbppy0nqpYUH
	cS5W0D3HfppA181TGH921MeKCy+810k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786432663;
	b=wr3NUDEEnLHTeo1xzf3c52BYRlZ3HwI+wWyzJuHUe2AbS2zH63sYy6xvoP/w8w3LDbRaBV
	BmZFVeckXbJcZVrNZc0bQb7Xpb7V2XgdI9Io5qknUZadb08e7InS/vgwqVXtLjl691YLMs
	9q6BRfXdSmSmFEgX/8NFEVUCdWK0es0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=whoONuDu;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786432660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DFqAUEtZlp1HILfzDd0oPsCphQU6caRSwneCZ/ZFUY4=;
	b=whoONuDu4SqWYGhHUyluEz9yRLfR/ZXL/2SKmsZWb8CiowXhfuaJ05TsqP0GPl0HeYApFg
	T8W7wP99yuX1co/MxBRGF6n2pjSB3PUq7Rh3Fux4PaXPua3fAvhAXInWyH8CZ4eAcNI71/
	dc38iPAJf9F1Uj0vZwgaMWar4Qk3zAA=
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Tue, 11 Aug 2026 15:17:03 +0800
Message-ID: <20260811071703.425097-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 110551C0003
X-Stat-Signature: 77bqzw7ur8jwh9ttddnr1mgp4m6tftyb
X-HE-Tag: 1786432662-233179
X-HE-Meta: U2FsdGVkX1/y55bauwivxP7Bzfcj4VaG1w+raX0hlJeTT4b696tkWvAJb2zPYzj8iCTbXa4C0w0IkqU9MWWO9PJL0jji55f5t9HTtGRAOgt5i2MRlbDtgZGX5MSqUt8UYTb3DS/b94FZ3gpysS0azok22uIPiUw4ZzD3qhgYZYu1yGzJDhFXUZpwH9lIFY6IM4X8H3LvCKh+MX0NQz6bcrD37ITcEj+fXuAx7c7OVTgUkMiiAYvkuUEuHeQEhyTsF4MHsqKihvBNofO0vsnNa9cJNKKfCcqUnp/R/q1DAVDAKX05ylBl5rNrtEd1jENY7765Lm18SfXZGzPu2DCCp5dTnCb7t1jmC7tP8e7jDpELU85XsjeCAwmRym4y63Mhew5g8Y0oKqOuMB5g8yJ1IMqAFbNwkzo50E369IVhnqGz9jJyUOcP+1IZ89rEtzzYG1Bmqjp3jxxF9Y1/JqMBXozmPL6E7z+ZLISUS5dQvpkiZ3kkZlfauVhaLPeoLgfNdezP1IcWwOt8CAsDyTV1Fv3RN99yYTIgAwYXLIokPsKdZJW72LtecevO08kqXdbkzWHeC580jWy+65elvCMfrQmgd41pbDM3vj81yNuHW7SNFVgaOGiCkjaUGe5uWtKPWYOrYigZBZTL4s/UQjQ+z7t5Y7ouUGzLJfciJjwlpSe9f/wFmX2RhRDU1MzH+StSqPns1+C6OBaGf0a23qjd9QQ5MhHXht2cWI7QTCblxaUepPHXKBbJ5fa5wk83/Ws0xBgyquDoYZapwaw+l0yNIhdjXUNUdebzLa18p+S3p5Zs4D8wgWfBVlpIE8QuyI/OFrWYh4aHTWOj2YctIGxJT246CyntHevqRe6hWewKpItvNthyTE/6Lg5EXGCNUFPiCoC5PS2M5moS2B+AK+O441vDdYynHTjDsuohp7QJvMu8N0lyUd4OSZJfHSenoHbEb93gTLEARUssMjGrXdm
 LLmzTUIP
 tnaQzKqBkSVxMS9d/5XXombGjGPbOCXG176wOfZZRE0SjxuLlGgdQOx8lV9eiWWv4eAFSui6khUOMzsKPXAV7m1P4Pu2zBxk/34DdiHFEGw/nryYsr/kkCx5emA/mTSS3VvE1Y/iLVLwUqYwG7+IR85Z4B1RJNkjgPKP1OEHoaqdcUBx3PVi5fHF9/YmPiE8pbtyPA5Bi2bL3eliKw0jxYszwadqWv93zJATkEmeFRvxSvmh9Ut6/Ei6fIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The MGLRU evict_folios() isolates folios from the LRU without updating
NR_ISOLATED_ANON/FILE counters, unlike the legacy shrink_inactive_list()
path.
This causes compaction's too_many_isolated() check and the OOMkiller to
under-count isolated pages when MGLRU reclaim is active, potentially
leading to unnecessary compaction attempts or incorrect OOM decisions
under memory pressure.

Add NR_ISOLATED counter updates in evict_folios(): increment after
isolate_folios() and decrement after all retry passes complete, using
the original isolated count saved before retry.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/vmscan.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc324e37c5f1..723b513574b3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4817,6 +4817,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct lru_gen_mm_walk *walk;
 	int scanned, reclaimed;
 	int isolated = 0, type, type_scanned;
+	int isolated_orig = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4829,6 +4830,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
 
+	isolated_orig = isolated;
+	if (isolated)
+		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				      isolated);
+
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
 		try_to_inc_min_seq(lruvec, swappiness);
@@ -4891,6 +4897,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	if (isolated_orig)
+		mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				    -isolated_orig);
+
 	return scanned;
 }
 
-- 
2.53.0


