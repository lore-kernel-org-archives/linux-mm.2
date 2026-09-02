Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C7D2C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF8A6B00AB; Wed,  2 Sep 2026 13:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A76C6B00AF; Wed,  2 Sep 2026 13:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295906B00B0; Wed,  2 Sep 2026 13:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2A846B00AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:43:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 506271A027E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:38 +0000 (UTC)
X-FDA: 85169544516.12.19134BF
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6CCEB40007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qPkpbEWq;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371016;
	b=pBEfKf9iQ3Z9k0ti/KDUnwOTHeBlYP9XMUi8euCV7L08iMpYoVC1lwdujPRvoU+rNWlRLJ
	tOkEqpVULtxps51+k5M8M4p/sCFJgm5xtbXMPJdW6sJbhocIgVE+zdgGr9biqCMjD3JNjB
	eKI//MTgwXFtou/DU3KnROBpUAqEtXs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qPkpbEWq;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaLt8VIqT/uLbrkzOlJWu8VKBIxub+00FUX4xLKccSU=;
	b=HrKxgs2EFWgiMZA8u2RdIcYrXMjHTTF2aVOS9RqLshUo1UeNhCmflVwn+GjgA7+OBzucZV
	wc1SyEbIZhseI+7P1IyYQHXP4vhCgsIUQHCA9bVbETqgeBZ5fEtygV8hRXv97YIrZHq66K
	CZIVLD6UQ+bBkUPeyBNT70INbZ/BVNI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yb0bO+jMr8HKLSvckBXSyVmp7KoF8OjxYY9x1SSRZYA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371014; v=1; x=1788975814;
 b=qPkpbEWqSPfFlplLW/5zTmAGsK+Jgvw2LuSv7x9rDbxggeSRB3s6CVgDIsfoeI7oeCwMd7W5
 kiruYEpW/cDGYTJ6M09RoGkjeK8tmrMZ2d+bAvXNYSqgayxFYsggEzS1P8+XSgYY0YrHpwGBqGG
 4GH68oM3b307PecVmXl2tV5o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ea98a50b791055b0;
	Wed, 02 Sep 2026 17:43:34 +0000
X-Mizu-Trace-ID: ea98a50b791055b0
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/8] memcg: remove the per-node soft limit tree fields
Date: Wed,  2 Sep 2026 10:43:09 -0700
Message-ID: <20260902174311.1772372-7-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CCEB40007
X-Stat-Signature: d7jr6enesy7pjz8a1537c74yige4ch9g
X-HE-Tag: 1788371016-60093
X-HE-Meta: U2FsdGVkX1/3TPKcRatIa/cJCS1oFARRtKtMLQfzGLa1v7jHa2Rly+QzWirG3NBP0AWTYoQqzImAY/IRGTRmNm2E3aWm/xGFta8DTP9MVwXWg4PmMqykXmOpNJoDZhGZJjsGNlyC1Gmkzc57dthko/ChkMoowYv96ueVfH+lHuYHlmBQHDK3V5EEUajnTuwmn2JJx4I994BcP+4ZBwFKzGl3NaCkAOTEN4A/2E/dmYdLcbZxYp87iTbxhcnEq81Ln7RGrfpu/a5km3s90TtYdrRyLWF38jnT1mzJ81WTo46dJj4lrGJEDqbxre4N2a+wxPv7ehccgQGaa0xPmneUVXFFpbT9G+vDuyUj2ZQB9nDLnCW/MDYFw9/LiQaJaGEd3vR0dC7iZU4xwavqtKSsr7Zz/WJ4PE2rw8fzVZktt+xXNlC9zcmAcqofqBMco07Yv/vOzMVf+y0m7dhoCx/yjzFLkRpjmWXD3ksBVZHuCyaXNyWxfy/oZW6oHsIrS2z6mrGx3KD29q0le7KtzdHBg4Scbhz9K57iaJC9xSmNhRmF7ypK3IR5a4SQWK/KUrl+d5brWTwtG3fSZkedQ65BOx8LRtw8ruUcEwbJ3q5Br+++ZjgrKJBPaW3x1EA+QyJT5Zyi/dccc7fC6qCgfQswARgmFofYFcS1OiDgggTIGfUl39rbwklT8iBnXtvTAXNnweoFTMvztN+Gh7XPmXLn7ghIkbVvfRn5PD7Jy5VNH+e793KPDGsIIgZBWPIv/u3xfMDXfPm2yS4gMSVfL4YUpHe6idgvELJ927AjWJVB0dgVWk4yQ7bDD8ReZQmWgiiugEGDR5pyOV16EOpRaAsaVa4smibM5dEnAHc63IY3YWh63taXqvFeIg0WRZqZl8WT0n6/Nyw+RdoX7kqYeFOWtU1cj3GRqsry6bbydDE6x+dtVKP6DJBd9j99owI/1cmZSczbvDc7W+oiRv1c3f2
 ZuQSdRsc
 S3l/WOEBIDaoZ6hn+91G6LSQgFENYgo2+rsDNpDivUNtxC6ivf5o5/eRkbBiUy981pAB4gTBBPCjkUrTSQZcrp/08iwPuL6zyYV9AP3ocwlBrBOmlnkZZNP+V6+0IwTCCzkaNJ2gDwNxB9NchmGG/JpQRpAI8cZyxCFHmGIvEDNncMe8t7gkAtoMBEAXdC2+kFQybAwzHq8+V+tk3m6s0V4VaDddQrk8HRVdrhm0zgSvsV6aSq65x4rBvR+qCq52ZsFNLNud+HH1AlnTpIv4/Knrnyu12USBIQ3OXsr0Exab5rEBi++2V/HvObA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree_node, usage_in_excess and on_tree only existed for the soft limit
rbtree. They also doubled as the buffer between the read-mostly head of
struct mem_cgroup_per_node and its update-often tail, so replace them
with the explicit padding that CONFIG_MEMCG_V1=n already used.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/memcontrol.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 11c1fa88d6fd..1eababed16f5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,20 +95,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 
-#ifdef CONFIG_MEMCG_V1
-	/*
-	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
-	 * and update often fields to avoid false sharing. If v1 stuff is
-	 * not present, an explicit padding is needed.
-	 */
-
-	struct rb_node		tree_node;	/* RB tree node */
-	unsigned long		usage_in_excess;/* Set to the value by which */
-						/* the soft limit is exceeded*/
-	bool			on_tree;
-#else
 	CACHELINE_PADDING(_pad1_);
-#endif
 
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
-- 
2.53.0-Meta


