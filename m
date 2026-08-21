Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 587F7C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552226B00A6; Fri, 21 Aug 2026 06:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC316B00A7; Fri, 21 Aug 2026 06:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA886B00AA; Fri, 21 Aug 2026 06:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18BE56B00A6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:26:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B22A160417
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:36 +0000 (UTC)
X-FDA: 85124897592.07.B35D24B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 18994A000B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kW2WO3wS;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787307995;
	b=yZXV/8FAjMoqqPQOwJ7YprZT8wAECs9Og3IBEiRRl5Hjmh7uBUXRY3puDmlS/3eFgZcLVQ
	lV2XD1l/Uo8aDN5ZN+0XNG5fm4WOscTvGhPQXCTI1RpkUBepvt01hKqgyzMcrZ2Yg1Few/
	G81KxOXPZediwa4Nx63vb6lAOgnIbvE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kW2WO3wS;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787307995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXd8/5/IV3VgMHX6Urv7GKHnjSeWG6/GogM3Cg3sztY=;
	b=vzKwkcgXpi9EqqK/E2fY6dIXIgcHmO6DyCSsygLzT5pm6eIXTzuRmnZXoh0vpTQRaOE3w9
	s0QYhdUORrVMpAOliVKBfEdZSHo+345W80iOLqruQ7JA1HWD7Isi0em+57jUglr/NtIecC
	3Xt601RWBhzDVlm/CHd1g/kG7upnMrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AF4461834;
	Fri, 21 Aug 2026 10:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECE61F00A3E;
	Fri, 21 Aug 2026 10:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787307994;
	bh=bXd8/5/IV3VgMHX6Urv7GKHnjSeWG6/GogM3Cg3sztY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kW2WO3wSoJLtg6Inb8AuPoDn9JZnzj0GUZW9aneFAAlpqUlseMqxCN/Vjt2rwZItD
	 Wmak52jD6QObp8iy5+IXAi2lk9KhwYUN+4httBpijukH+I0275HsnTWQi4Jij9OkmO
	 9DPBuk/0Fed3ckWV3uSVkA5H7uoQTdjtJdQYrzNhM00kAzfiOJuTueH3W65JYz35hj
	 NDJv0eQQpQWRT/9HsRtyOTBPcNP4rY32LOHA35D6TJ3YrDIq+CpQWDcEtcF/YOffAB
	 FOezdPShO5gmkBzyKjzBKYcJWPnqwqDY053pkCDvAbP1yzVgdQPSQROJmp1VBZCTBs
	 3G08JcFDPOLzg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH 4/6] mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
Date: Fri, 21 Aug 2026 18:25:36 +0800
Message-Id: <20260821102538.22642-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260821102538.22642-1-baohua@kernel.org>
References: <20260821102538.22642-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18994A000B
X-Stat-Signature: 4p6m3m6n9z8cbkhg9bj1geneqb8xr3yh
X-HE-Tag: 1787307994-545160
X-HE-Meta: U2FsdGVkX19WeAT8Q38vAklhpyf22Qd0Xyhdd6/eToAVymIgANUwQeed7ysuKvhSiB+1C7VQKmjy4JBUZ3XcJc868eYUio5xYcb1hUM228fNHxtndw/Lr2QFJAIyVn7r7Lw56ojutftIA4ujCT4jB8YMjBjKqd4BXuPYPHjlHezKS0B+QOgEudXp1wgXR7hTv/ndWTRcZ+0FQ5QLQQmPCUjilZmQTOe76aEDa2nlcV32Dh5vjxN+w8OrVhUfuM3QQiLNYhmrGDiZwEcpek7X+Rl9YtjL3kO7UwiK7x4gwUKrlxZYKo4iFEMfk2ly13vFXkpVAv+Ui7jj5mHd9u72pFa+WyhJKHfMwkJW7W/9Hj8kwNA6yD0ls8Vr4n4u+0n8Ts3fZNm7SxTwKdAe/eeUwxQF0qePpxL4CUNVVk2oEHM9dQNikI6+wDsMnZwXTXAyG7dmrGG32yBXC+zThPjjQWMVHTM1+pINdFf+vKdXT1dwuC1ZDOdiBMhr6LxpSWLBlvwIw9MxK0jbK4gjY7mbOBtlZvvi2bsK5YEmlj8jLi5LzOU146Es2SFZRsA10PVAUyLcFH2utraOJybRwNQ1cOFqC8XfU6l2bvZny73wElqMkv64H2+brMaN/jXEAjwMacc9ZDfOkt7AWlQBQBm6PN3Wk2fJz3ylv6Fxk0luKVUBC0+DIoxXOiuXMbkYEqQ+jrYhAmojzxe/WHBAZyt3lZrDkYyRAxd/Fnc4D4iN+7CpDEnNHQLhR8TusCeV1iMEDHXVI7DhHu3yQskzynP+hH2+VRvsAvHr8gJJssCRq8lDP4VR+CVMkQIStOApdMF8dRI9cKOPakagT0mN+z65+gIpI4+IGacceddR3OKcYnjdJJzARLugcRu3zCwQdUZlIKW4PlYhEalL9iDyY2/VUik0DsbrQBaJw8ejfjMOQtf3NLLF6ET9JxlWtIbE9UpcTn3evhArCMAiBq+3rjl
 2cLyZ0wd
 Gg80eblCHjek1I/8vksz/dc/CiwS2wCeP7ssYgT7IvBHRVE+cs4pFfk/kNZUgjuYzatC4n4JkptTP+7mXYJSMWyxgU6tJTD2h9DlPADUuBXm20RiDvSjVLfHQ/5H9XpjA418TBj2MBYMUyiAhXLog3tElRSGVdmtDaUWkgZeP1PuJo0qOhultteelu8Gd9ICHdAXZR6VqcOCb7MmYFu9x3Bg5oPSHBlPAL4aWptfJ7C0JgYl2fS24CH/3fzH7daAk5mmvV7Uk+THX3hC3ZPti0XiEaGB/YK1TN5u7AgZCiyJfF7dYGWo1yTk0mLaQZhymriZDb9hBCqq7M5eOkxdrm0jV7sqnx0hY2wHt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some folios may have been promoted during aging, so don't count them
as protected, similar to sort_folio().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3b618a51cde2..7bd01875fade 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3949,16 +3949,15 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			if (gen_increased) {
 				delta += nr_pages;
 				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+				/* don't count the workingset being lazily promoted */
+				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
+					int tier = lru_tier_from_refs(refs, workingset);
+
+					protected[tier] += nr_pages;
+				}
 			} else {
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
-			/* don't count the workingset being lazily promoted */
-			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
-				int tier = lru_tier_from_refs(refs, workingset);
-
-				protected[tier] += nr_pages;
-			}
-
 			if (!--remaining)
 				break;
 		}
-- 
2.34.1


