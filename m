Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D726EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1136B00D1; Wed, 25 Feb 2026 02:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B20A6B00D2; Wed, 25 Feb 2026 02:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A71F6B00D3; Wed, 25 Feb 2026 02:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 489146B00D1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:56:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E200C5880B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:55 +0000 (UTC)
X-FDA: 84482222790.01.0A8228C
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3EE4E120009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t5eI0eBp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006214; a=rsa-sha256;
	cv=none;
	b=az1ZOry39aT15LAryhnjadDqaPdD/Fc0iVEG4jpV8FoZFOAwvlQzFEgDLMQHCIJkesspb5
	RzXCMoCP7W8JGJb4zAfFh/2Jic//TSWODjSH+JXz7mgIjK0pK6A5pLWIgyYUQJ0dNOuAC9
	JC8CPdWq7LNRRcwZx51lOVJ5T4JcSc8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t5eI0eBp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ME0/F5y30Uv1s+QbxgHUtCa7ObeVmIsWm7RG/5Co0FY=;
	b=UNsxAWzbo9flu/isNpO4FFUVG1WSw8GnLwKSasFsrWPWMrRlyf/R8NWy0RJk6rRTcox0wU
	hMB7bSxuUrJtlP/L983/xhgzD0r6WCzioDd3Slacy4qKLKpuvFqrKV/qXQPuoT9l66lOfV
	SZbf7ngJPX1cMM7uxNr4hZpPviwCd3Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ME0/F5y30Uv1s+QbxgHUtCa7ObeVmIsWm7RG/5Co0FY=;
	b=t5eI0eBph5ukFLwgWDVMW63HTjsF/nKxNunRL+w1BMRv4OZ+Gnj1y0Ra9yNHKEYQIQOgOx
	YtjJEUibMIUeQLxekC4mxf4IjGMiloxQgCjJI2x/lEmDq5cZ5qf8UyQWPo9hDqBWZAiT6B
	FVebdx87fiB1zJgVldgtNWBcX0Bd7yw=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 32/32] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
Date: Wed, 25 Feb 2026 15:53:15 +0800
Message-ID: <9a0b6ba87112b2bf038ab65c47b6f16311b829cb.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3EE4E120009
X-Stat-Signature: 9jbkumekwnnodgswcsf16rqzjcupneo1
X-HE-Tag: 1772006214-880990
X-HE-Meta: U2FsdGVkX1+eG7LMuL2QEJE+ODCZOCjZBE9eaa9rtvxz41mFp0YpngoCnRQmTCWQyF82n++g0EVyISweTq9MYZd5GEh/HwbA43kGMLoACsfDnc6N6CSvfTotaDaJQ/MVFdiuL1/i2ya4aLi14tzMCWubtjq2I2ZluS2Y+U6vTVlRSsx5xj1Fdmo1BUaxwSulxGWnnpHE07RdIHP/OSL4h69FmJEnS4/0eubHvv/9WpkhDL5yTND8ZtVHcSq+dAMU5tJl7AQv8wBSD8gKzm/u03rWo/eOFdNuPL0ErguHr/qAC1miIJqKc2vhZyeQ4AClsoI2G+kzldW+iXw+1Ml38ZUzLj9zEUL31BBmZuvR9WSQJxeiUDd0z9C2IglMT69MZ0wnaxDnqEq2mlx3Rcr5dfxgfw+fwRUThG653tauVrgZMgb+GGr8CfJrw3l4gXvefJ6c6CI79V/KBVxVJR0x8fOO5lyCjspo/lIIVuunuOfiaosUrHJqPzeI8lbHeTG0iS8ixOxKqqk8vBII16Q+9TPk46dto2VQsnMyk4sqjYPNpFj4Zbo27vVBSVM+r5+B5zx9ZGkzqOURqfKub8VOZKWpAAj+PJykg5riQnq6s0jTKf3hUTqXE9zjVtmfIIGsVhPBHyIxfJS+ej4XaE6rTVLrvGigH55Iw12zn2bogGOWeBwoRihJJ19nGSzQAWkvp90xA5Tc/iA8NzQmwp3SBcqWPX5a77pD9BAlZFJNBG9uzTJLvcVlnxDtikoFTFKC+HMio+hG6PHo4fsJbVZS6KUmdHPzqMAz9fnZqKwFtRw7BssDedR/emoYBlyNhoZylaPbJo1yZzaUH+1lZyJk7vvLRheoxbCM+M8XfoMaOr0bho2fjVqiZuhScLZhIFmUKFShTtta7nw5i1+VCSUwTwf2n8KqCy2yWTAaAO56YJpfVEeZyOdyalcN/r0flm1s1cJPhLS7LZuird3aF7L
 D564spHR
 /FST9myE+dKzqhUdXK+sGaY1tBwEzKOirtg4JmF4ZmSXMbjQ2DzNOV8MpY0imDvs77ezpZGHvhwVEW+S0AvZ8eGvFVZlfhogCBu+OK2UjArydCN8SAu1ZxVoBmCkXMO7YSFa1VNzMNoddUurey0SPKSCPfBXuWE7gQDHc7LW+6qmStUAfP2WUiQ0+PyJWhTuGYeVvoedf+/UhJ+hqX9oZAzA0aP6No2TU2xZKyT1urAs7oOpAZvvX8ygtXooQLmrdvn/NCTAvcYu+DQMPcAMZD4bWGoZUgLbSo18W9tlfNqSM1dsim3H0MrUmKJhv0rA7m0Yik+bnmUIoJJ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

We must ensure the folio is deleted from or added to the correct lruvec
list. So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users. The
VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
add_page_to_lru_list() will perform the necessary check.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/mm_inline.h | 6 ++++++
 mm/vmscan.c               | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b53..ad50688d89dba 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -342,6 +342,8 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, false))
 		return;
 
@@ -356,6 +358,8 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, true))
 		return;
 
@@ -370,6 +374,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_del_folio(lruvec, folio, false))
 		return;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7f9f66e0b40e1..73bfa93696a27 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1920,7 +1920,6 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
-- 
2.20.1


