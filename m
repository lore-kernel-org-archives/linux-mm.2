Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1399AF30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF896B00B7; Thu,  5 Mar 2026 06:57:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4056B00B9; Thu,  5 Mar 2026 06:57:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED4A6B00BA; Thu,  5 Mar 2026 06:57:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA816B00B7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:57:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CE8558F8D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:30 +0000 (UTC)
X-FDA: 84511859460.06.996E088
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60D4018000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O0ym4ixk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ai/SdLNl7tLi9uYAWt04inUE82NVSwYAydx9AFMCLgs=;
	b=jUl6c3gR7LrmT2wzVyWPYm6FVt5s61oFBGcEXX2VwoWzOCtQcy7me1i5cG8AX36vuq/hzw
	ulfT2UMUF6BDKQ4SrJdbHCX/of98owbaiCwD/MIojOQ7NBEuf+G1LJk4FgEAfKkXR06hkV
	4o4riCI4GXof5cvDs4+c/+IKWSGLWv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711848; a=rsa-sha256;
	cv=none;
	b=0W3cQQqD52TkKGPtpleF8c0usYU3rav/GyuZ02zo9byjafz12dKLX2eDYnqRdYYwvZ6htX
	ZjLKvHPZWkQQSTJs8JwID9dLCTVCYnSzuWxnvVcuuhec+vp5lcXJPPcrSnUp7opm3npvtD
	WjF3KlYF2nLDSNc0eTN1gA2e7Rxaeaw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O0ym4ixk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ai/SdLNl7tLi9uYAWt04inUE82NVSwYAydx9AFMCLgs=;
	b=O0ym4ixk8FzaJ7HFtYmOOYBLKfjfYWDjCZjhkK2LYTeSQPb8f0NOUV2UvbOXWY0yjhQU+4
	BptwqbI4fRWd2u+PtjvzfSzHtuyIz0GL5dgQyo0RGLo4BuSfGeEtMHogBq4uNW1m2F5FG+
	jVuMqQaOq0J8WoGdp/eKdWwBrWbjSLE=
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
Subject: [PATCH v6 19/33] mm: workingset: prevent lruvec release in workingset_refault()
Date: Thu,  5 Mar 2026 19:52:37 +0800
Message-ID: <e3a8c19a9b18422b43213f6c89c451c5b6ca1577.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60D4018000F
X-Stat-Signature: osmx7ywkk5byzmu7z17q1n75oois386d
X-Rspam-User: 
X-HE-Tag: 1772711848-230053
X-HE-Meta: U2FsdGVkX19CjlLx1aI0+KglMN0t0KqspPXOmFKSdd8G7jOa31gDn0X0kntjRg0K0kjrLK9X8RDAAIfcrt21egPWogjZQNbVUIcTcHhLq4WUilR2a7SeLsfo96gIU/hVMLeZfFjMbumRzShBDAxG6cTIKtGnrIQo53oZxKqsMKf86lKVF4S8O/ILZEcUC+xPqL+lnJ+u/nioHHWHS4vdOeliuEhx9uOLnnbCeX5IXabSQHg59ionHHBoMrGi0Am8Zds0QHHcKUV+aAcZ5t81STNBjW/DbiRf/PJUMf3ZcNczUtStqEGHfwzz4BQFUxjYM3ZnLSTFqXO1smkixgyrlhP6gLCCZfIL0+fI1PFY9CQ+Ew3pGQDrq1MJ3jyRwgxIOXOQ5L1Ar2JryEXwOxzbqIUHmxyzZEfSr6uguYbPcG9LfF8EJyj6lSeUlxjHMLIEL5RlWJxEWUvIZg4pnq1Dg9NOBheKR5cN5aIZ+B3ihsDn//4mcK6+SBYRZOyPdcjZy9kjk5O0waGq50j1jwOwl/MuqMp8UIo4HLMs7V5/MvCRFrAECOTSPTY25Oz/nogCa4OLeEXV0ijnsME9bO8/LcjfeBJrnEsTMuCva6RQVZMr9+T/WWhX5t0JNqyfRif85k507cWwaSlN1Qd/yYY61b1lpKZBbOiGSQdJCPuVpY/ZOQ1NdXiq4OiA9FGFYLjS0+S81fOofULK2LO7OJ39tBkuUiMpfWcsiC8ntljGhURuQMCXnbvkXbESJKzCFCx7xK8r4dOEsReXLu9ZIYWr72jmPEEg0XT7Y2D34WyxK63k3NXPn9SlPPKIocSVXVNWkyXY7Nr21tkREogxcIbzk75mHOMCf/DQrBmaNmWYuVyxNKHQ73bXA5fY2f/Zkt91JRKoFtyJjyhtjDCyICKxmVsTn+MNdwD2GZilm8wSV9NJDFnN77xz0zHcCzaftyBVf8arpgJs88JLptgScfF
 38ua15dq
 MGTYXpemAKuNTF3nBzfY1/BuT/+5lAusg47XeE2cCZcAdc03ITdgPAW3t8p2kUoR2nv9yFm6itCHKaTMn6hymgSbztAlmscPJqnSXZc27arpQFR+WsOaa+TvcQPhRwX2VnAqsY2OFql/IzH3LvmcJfPSTwtgXCDy5Gj3bSEhc91KG0DgvAzUDiNScLwKI7bqqL21sOhemjKadSE603lMGnoYO8L+NiDA1HUY6yZTn3Zl8VTcmF9Y7pfw3zAOoWJflSmt9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in workingset_refault().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 6971aa163e466..2de2a355f0f86 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -546,6 +546,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
+	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -567,11 +568,12 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	lruvec = folio_lruvec(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
+	lruvec = mem_cgroup_lruvec(memcg, folio_pgdat(folio));
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-		return;
+		goto out;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -587,6 +589,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
+out:
+	mem_cgroup_put(memcg);
 }
 
 /**
-- 
2.20.1


