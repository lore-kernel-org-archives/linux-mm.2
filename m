Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D34CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 02:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABE46B0088; Tue,  6 Oct 2026 22:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683236B0092; Tue,  6 Oct 2026 22:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598686B0093; Tue,  6 Oct 2026 22:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3606B6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:14:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBC1B1A0304
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:17 +0000 (UTC)
X-FDA: 85294210554.03.0FCB531
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3BD70180002
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="kd5fSF l";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791339256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf956o7Xb3ZAc7snjXqwGB/wRoNyeXb3dU6QTOPLSKg=;
	b=CsfOky7rgHvOFYPjRTnCrWUieBYomepTiRfdlemDNpHELUzs+4SWpTcdARyEnDU5sMv5w7
	5XjWRjXWqQabcFTlVviJL+ZaL3FNoBd2cNRNgg1/O/XBWqnOfJQ8a1MLRMtg8ESkUI4LcI
	GZtjhutnIn3Snn8dmU8IdkNqNhG7u6Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="kd5fSF l";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791339256;
	b=hVNGutsMTEj35eRMmySfTq6AB1LBY9X5oLPGitR4Mol8p9GlLLwM+c1jCSdONK/62ovHpR
	6IJj8E0bblinXFoWQH92TMifQSJwzwoKlfcf3f1uGo8Ao57hLiRJF7c3zzX57Lz9TZtclM
	SIYPHCWUb1WR/uLn7Vrtu4rBNaIZY9I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=zf956o7Xb3ZAc7snjXqwGB/wRoNyeXb3dU6QTOPLSKg=; b=kd5fSF
	l1Et4fuw0fA/NTiBHcgmHsADezDrKr41HJkv4gh4mFoTJaNVite5V94t24F00jvCE2bOUCrs7BDMV
	qvdJt1HTbg58GOIvpC4j+CfpLTCg+uBbAvFYcT/O51TEaV/1UPEqHQ5qYdcTznuTTFAqFe6WYPN1M
	dyjStLuG1fGrtrULibk6ffePjNy9DSnxdUOsrO9fPvIGyfChZr1HfaThA/+C92rUiiOKeoyovp6lf
	9rP1wre5v0LanRQA4zwjyHPueBhS549qRt61dZaw5r7IIODlfa28gmukedY64P80IA2reU008BUbK
	tVsaTISFiH1kj8CBIUqObIgBEi1A==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xEH9M-0000000B2cT-45iF;
	Wed, 07 Oct 2026 02:12:56 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 2/5] mm/page_alloc: count a merged buddy's pages under the merged type
Date: Tue,  6 Oct 2026 22:12:47 -0400
Message-ID: <20261007021250.1665929-3-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007021250.1665929-1-riel@surriel.com>
References: <20261007021250.1665929-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3BD70180002
X-Rspam-User: 
X-Stat-Signature: wz97m3eh9k8hkcbr1bf9t65y79jxjygk
X-HE-Tag: 1791339256-342952
X-HE-Meta: U2FsdGVkX18dOY3WBJCIteBYgCRIOK58TSJaCJXPcGZf8hA/ST+Lnv9LB2bG113mV7MuGAJSZxed/W6Lf2iEXELhyywdk6iEWM+gxarOCeEgBCTd3LSzJ72XdVboxLRBwnhw5DFZMmUEKl2iGMn1BFbFqdOc6joUu3h1rLhKGomspajnWorQHPAyrV50j4dwCKOpjfZen9XOaaEGbr2wlST6I370KVsmorCVFZpopp1xolhimetmEImwdP6zZ4sfnfF1IB5hoDSWPioCuWNHy7O3qkgSvVMSs3GPAsALrymbecaBqJ25AkfsvoVPv6E1ufXY3ZvD8rGyr3M0QyBOxulrFNTgy7ttgmieu/Wr0lgMn2UW3/2WU91A6oZtbPLuN48Nbakjfzf4qVCsVUs9fCZ16JGx2jC8rZyC/8bIasTsbin2PRZKf/SZHieOLXvtQfMhpu4Y3eeC9VZby1deLMANwqXWOLQbUSFhGzT20t+LsswMLS+h73YpY1BqGdSE2Y+/0+MLQNzs3+4v2NW45lBi/hYOkWIcg20ceRkc1E5VEbXE80IOIL3YhAya2r8U48rf2PB/yFeAbbjH5voOepo+IgIrdqVbY05/1hdUhXiHfX07qG2aH6705NXM5m15vQy4wsE4PkLe2sOenVW3UE0fekMqs/y20lovkgDzpKoJb87+cGx2bB65se2/mReeXPQMtRlmjFbHev5uu5DrYCJ8RSNlFBMXYyolHLl+v0CXZkOx/+xi55+6KTgOysrXq8NnzbaXcr6gZfj9qnLn33Ulykuzv/ZCfn2zLdEaRqT3WbNijBtDgr6PWSiIJ35Ez1jivdeOMie1Mx/7OnOSSGjYQSCnVEluUjGmZY+/Ur+IXm4wv3LyhIhPF2oZMQuHwf30FSF/a/gm2u1v7bjOP2nhJ+P1Uj8J8p1gV7Px3c/hmCS/ADq/SePaqS6T5YSWqiolsfBGSfXMwBggRL4
 us91t3gA
 rj5L33598FuWToOXAD9qRkiJpG397HGu/wOTPmbvmfW9ooBy+xkTmWHN1l+guInYZtAeCnEIh/6+9T2HqPbVFgRp2BliXDvDkhV9KDYOZIfX31z7XyA3a4T1se+S9xZWuk+0V5EnzFhRC2leAxoHAinZ+mr9htCqB2AJTx/qpZby6kvFFl6cqtEzcYme8Y4ZhxjoDNBK8Q3OC6oG844FlkGGwBToftBkc1IhMnj1IbxnqynGqJRqVj7G1LB/8z9nVAn9Ul2fUAYumKV1Z40lUPKj4f9y3HA/JCndhWrM8wz/ygmOfpWzfxuMQIwCHcYlifQBbulsuGuoTiCCB+9MqY6KUR8HQmW7PmeXbbHxvXBzTLpHHwV/MpF+CJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__free_one_page() merges a freed page with a free buddy of another
mergeable type at pageblock order and above, and retypes the buddy to
match. The buddy's pages stay counted under the old type: nothing moves
them to the merged type in the free counts.

That is unobservable today. NR_FREE_PAGES does not separate types, so the
missing move nets to zero there.  Any future per-type free count would
undercount on a merge from the other side, and allocating the merged
run later could wrap it.

Move the buddy's pages to the merged type in the count too.

Assisted-by: LLM
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/page_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4658af97be010..ae38e25971559 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -993,6 +993,11 @@ static inline void __free_one_page(struct page *page,
 			account_freepages(zone, 1 << order, migratetype);
 		} else {
 			__del_page_from_free_list(buddy, zone, order, buddy_mt);
+			/* The buddy's free pages join the merged block's type. */
+			if (unlikely(buddy_mt != migratetype)) {
+				account_freepages(zone, -(1 << order), buddy_mt);
+				account_freepages(zone, 1 << order, migratetype);
+			}
 		}
 
 		if (unlikely(buddy_mt != migratetype)) {
-- 
2.53.0-Meta


