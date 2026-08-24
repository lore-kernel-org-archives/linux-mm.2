Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B04FC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3666B00A0; Mon, 24 Aug 2026 03:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B2C6B00A1; Mon, 24 Aug 2026 03:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7797E6B00A2; Mon, 24 Aug 2026 03:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2666B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:39:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD7F440475
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:39:14 +0000 (UTC)
X-FDA: 85135362228.04.554A0BC
Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0FAA21A0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:39:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557153;
	b=vASJmO4vNc5C+SmiqlUCVeCsw6DNiaAQMGfQdl2PFE2u42uFZPqkMiSXo0PfJ12RmKGNLh
	v2Pl+b0JqE0qNmU8yRqkaJwZ6HwX8Si0jLWOasHDRx7/t1zm/RDpqIG+ZybC7EGwtlRgGb
	O9pheAEYpf6meNHVUgXh4abSq3Wxv0I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cp8/apVqcMuDE1md5EScO0mtDZc07jOgrLo4FZoJfog=;
	b=ZZpIINjWoejsWxYzq1ze27J6z15GkkokzGn2147LyCrisYxgQ4Cvj+5VSQ28V4V4mdrSIW
	5XhWF/zjG+9c0oZ9BCUldmOGYOAfHCi/fB9N06x/QNT/Z/g0/8rOW2TWOFonjBIhFotJki
	CChHKVuAd7IVHc7dq8C9RenbaePlAE4=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 84b7cfc7939fe395;
	Mon, 24 Aug 2026 07:39:11 +0000
X-Mizu-Trace-ID: 84b7cfc7939fe395
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 8/9] mm/mglru: report hot PUDs from the rmap feedback path
Date: Mon, 24 Aug 2026 15:38:05 +0800
Message-ID: <20260824073806.629593-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0FAA21A0008
X-Rspam-User: 
X-Stat-Signature: ndfunagpnkqbpm788qjqsafbpnjb7ifn
X-Rspamd-Server: rspam06
X-HE-Tag: 1787557152-164096
X-HE-Meta: U2FsdGVkX1+fgmDaSQwLFfbmu1l0OGBWLg0nEIETyh6qXK1BMzFv5cGgO6Y4NYNpRu4fAzRoPyT1iaUJljwyyIhE89ECwVww3+1ar8uv7c5E710UY/g6HJMpPo2JYLXXIyAxdoD2rB3qhvohHaJolY7cfxUIZnC17LOZqu74T477EM8gCbKmLrdwGiWRS3tXn6M/iTAmigy8o0m/DCxK8zuVB2LITRe9bbHJC0Am+k4ZutMUOBNIet2lXLqXmNwg3GYcI7rXRzWvniz5cgAh3b8kOvrZvlD3Pqd7p77DukJBnNkgsTxSy2qA1VlKxkWkMCqwHGAU+g2BcDLVIKXIVsVwgYDMUNwJ3vYsc5GmiNTgppNDbHntYMoGNe+uyAtA52kSTDcdtSj/xeN8s9UVXsNKrvCVRFVlBOXi6bPOJ/8zjM4GMn68Ls1xZ9Vv0AxZ1dU/cLIHMxAle0JdxAFwK4VsfeXu/Tge8B1n2ZTh3eoh+XcXg/nJAlpnR8zg7WXV4fTDcwz/0D1cSWJBrlMqliB6kTyKCm34Lkkd6hn6lXHSkqLfVcBE6SKNwp7tfpiOp8v4YtyNXO5q26ZO00I98FbtJtmXy4BncbwazvDkvIBRxmX9Smrpni7DMt47IJqUo3Tqq9HTPYpk9uNBbUCZfoIqIqiCMU7xAs5vJNgRVIb7QZXqbm5cK8msixuDBEByk+rvmYekY37O8D2Cuost2MmE/6+imZxhVw5oXh7gBUJzORPLoj1HE5bmgydnJjS4FCdiH77Zt8fJI8OgT2WDwPDw+EWiqFqj9IOjQY9FgMR8DdBw6Acuznbj4/rzFGWFZYfL16tZcw02PblGti+OkWLFNoS9VHxNqi+g6z9faArM9oiH+s7ZTakAIHqUPh3VEZd3wMig4R3HstXJrGNaDTRjZg5L8pxd/9ugrql08inW9BRflhpGSZ5JIeA+WKAfs/kSy4kdeybnGg7yufO
 jJbAyx8j
 +kGu6jTgqUq7xADZ/SOsHujiYZUAbcm26ShqChQ5bkzIe+ijzZCcqxfaUEg74yXnHvbW+wGKXdapj3LSVs8+a7fMdaSDxrvxdyeNlVfsrITAQFpPBcHtwJawQWfTeLQFQJafu+5icA1i8NImFdRP0Wh9k+x8CPbsCkoQ5tbsNcLDnREvEVUVmPPtNi5zy2E7vmX09gDVzGLqNFVaVhj2JjLfCReCbuHo6FdV0F+HyrmjXT6IITcdhXsTXweNiF1NKEOp+HR17AgKiOwQpelN0u/aw92FgC9zYUkLXVPiCW2P3TBcpX4c8aii2R7SvkdIUOWYXW5AyRjKEL1sdYPFXTpB297y2GCPU400HmHbKQ0kZBTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lru_gen_look_around() marks the PMD of a young PTE found during the eviction
rmap walk, feeding hot regions back to the aging walker. Mark the covering
PUD as well, so regions whose hotness is only observed by eviction will be
re-scanned.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/vmscan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7a6c15be1c2a..cc41d3692bd5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4470,8 +4470,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
-	if (mm_state && suitable_to_scan(i, young))
+	if (mm_state && suitable_to_scan(i, young)) {
+		/* the PUD entry covering the young PTEs scanned above */
+		pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
+						     pvmw->address), pvmw->address);
+
 		update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
+		update_pud_bloom_filter(mm_state, max_seq, pud_p);
+	}
 
 	mem_cgroup_put(memcg);
 
-- 
2.54.0


