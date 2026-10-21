Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A795560A261D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71BF06B06C6; Wed, 21 Oct 2026 07:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F31F6B06C7; Wed, 21 Oct 2026 07:25:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC906B06C9; Wed, 21 Oct 2026 07:25:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25DFC6B06C6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:25:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1813740397
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:02 +0000 (UTC)
X-FDA: 85346401644.04.491F7D4
Received: from mail-m607.netease.com (mail-m607.netease.com [210.79.60.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8F44C0007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.7 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792581900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBXfKVl4/Kl4meR18VHWKqXqUs3LmwtSo20MC6ZTq7c=;
	b=VBQR2vjFtDOInQOsurIcsdG0erY1O5eKtfDGhK7eHkEANjfsFLxN6QTV2JD07tfi39zC7F
	2ibNyNOUhqL6CrhxB3Y1fVm7IQ8RkgvbogjwJBfPuMDAgN29c1wjHtZ48ZSc5M+/VtxgKa
	ugikwPj1NOcC3fARpgTxu+JNm2ybtUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792581900;
	b=ers+UQb5e7DBpSl5P2SbGqsy9jAANrsG4aWy6GoamWfgqu9bbX11rJiVz7M1xm2U6nJbHP
	gzYgF+qzAIjQZP+5Hu5SKdm3IuvgQc4d/8vfj2V+3f2miaqiJBC0MZnc7zIuLqWN5ChzMq
	YguS5BeNj5PSeRqCKLUmSPdwoIff4O8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.7 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 204f151ad;
	Wed, 21 Oct 2026 19:24:55 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v3 5/7] mm/page_owner: record the NUMA node in the scan cursor
Date: Wed, 21 Oct 2026 19:24:35 +0800
Message-Id: <20261021112437.1799213-6-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa15e35045c0229kunme08c1fd526ace7
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGkkdVk4fTklKTR5KHUlOHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8F44C0007
X-Stat-Signature: cx3dfn8guffyjaec4zw7qwfrun3xy9nu
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792581899-790423
X-HE-Meta: U2FsdGVkX19Z43rgUFtRhTkbM3zmoWpx0WxWlekdVL5lt7BZlu3MYeIoXNFUKZ46BOADOMc/6SrL+QKdTuzqh87EZvF6kjw9adjCOGGAt9SCAeEzluS+Jx8CG6MmsZuNY4C7aTI0MuYXGk3+62/0xAlS7up9FvrRaj2oE3OeUUl8vzgvqt1XXdXBw7sZCldSqdFPWVYPvo8OXpVcr4DMowVdOuMQ1yCYh7nT9U8hDJ1l/u/miJdzLP3WP4RPG1adxhXFzqDc5Rvs8s6EDeTJbrpvtgoZZc5mWGQCFL7R7JDbfIx8XMIj11Qu6lUXKP9xed3arEqxmDqtNVT63Kk6A6yZ86wdy5Cg3oMFPf4nUcal3fBRYzLrfd7mADGUhaMcv7uzYu1cOa7qrhM6fRLhafuqMmIeR8oaOljKrWJO12RZfKtfPpwp0G/QdYM07POxCU/I9JT0aqwB2vaw4j3hBi50cuC/QaTKnCQJB8grxQA3CdBzhI+I81Lv9+WQ498acAMSmaaVTDPJKejMZqmJbEVGQyuS1Iyl6imEuDG4+oCiRtmCCPpFTaXGiL0cMFQf4ffcGXs4XXQW9VHM+Xa8DlRiQzX33e+27db7wxUfTEc+Kk4DX+fMG7mElTsJFC9qkdPVJxkV/NlCLQjSVZb8lSMTiz5svwEeGqVcI+cJ62v0FE3GW1qgqmw2vzrhYi/8oGoRXLO2AhqBGudQRfKXdTYmSPqFsVgaOjZUdzb6tYUjpYEwx5bBrQcdvzTo5QcvwrqOckrMFQAwZtDr8CaxW/6wC+NM9fNxNcI4dI1JitTFWRSr2B6riPjw+nLw8lSYhQmbpY1yh55fR6uSpHJgimSQibHC56bWfYejiT5ORV0iG0q3BgavHfXgPJBUfZAeib6YYFaw6fFabYDHkmbED5/buM30lnlx6zvpSVw5sLspe/WvJvVGvdBPElf9mIlMlgELb3wyzpGJYELB0I5
 zLYMNBwa
 h8RCXl4sBERT02T5qhLaoXjdzvGn23IGjl8LU1BC0bZS29pwXjMA7PDloewbQtRcYTJOmtVBbnec8IpM4BroBM5SBr1Uc4xFZoyOB5RdaO1zqVp/FnVpZrVwfyhQMfaSkRLJSqCSYYc7Hvt1rqf1v2fa6xosRIG9xu0CkSQqyiDkLXibbp9k30fWeL6TRrt6t6Pl/TSqpGTiYkUraErxRte2wcaUQgahUJI8No1ywE1QXuGDxj/pDMx3NbTg6w2ThyPRV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Compute the page's NUMA node in page_owner_next_eligible() while the
page is still valid, and store it in scan->nid.

The debugfs nid filter reads scan->nid instead of recomputing it, and a
BPF program iterating the cursor reads the node straight from scan->nid.

Resolve nid at scan time to avoid dereferencing a possibly-unmapped page.
Keep it in the transient scan cursor rather than struct page_owner, so
nid does not add per-page memory overhead.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- Add @scan->nid to the comment describing what is filled.

Changes in v2:
- Removes the v1 get_nid() kfunc. The node is now stored in scan->nid.

v2: https://lore.kernel.org/linux-mm/20261013122125.843451-5-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20261009112308.240769-5-zhen.ni@easystack.cn/
---
 mm/page_owner.c      | 29 +++++++++++++++++------------
 mm/page_owner.h      |  1 +
 mm/page_owner_iter.c |  4 +++-
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index ece3b69a2579..8bc15bcdc24e 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -711,9 +711,22 @@ void __dump_page_owner(const struct page *page)
 	page_ext_put(page_ext);
 }
 
+/*
+ * NUMA node of @page, bypassing PF_POISONED_CHECK() in page_to_nid() to
+ * avoid VM_BUG_ON on poisoned pages; -1 for poisoned pages.
+ */
+static int page_owner_get_nid(struct page *page)
+{
+	memdesc_flags_t page_flags = READ_ONCE(page->flags);
+
+	if (page_flags.f == PAGE_POISON_PATTERN)
+		return -1;
+	return memdesc_nid(&page_flags);
+}
+
 /*
  * Advance @scan to the next page eligible for page_owner output.
- * On a hit, fill scan->pfn/po_snap and return true; the caller
+ * On a hit, fill scan->pfn/po_snap/nid and return true; the caller
  * must advance scan->pfn past the hit before calling again to resume
  * the scan.
  */
@@ -790,6 +803,7 @@ bool page_owner_next_eligible(struct page_owner_scan *scan)
 		if (!scan->po_snap.handle)
 			goto ext_put_continue;
 
+		scan->nid = page_owner_get_nid(page);
 		page_ext_put(page_ext);
 		put_online_mems();
 		return true;
@@ -833,17 +847,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 			goto skip_continue;
 
 		if (state->nid_filter_enabled) {
-			int nid;
-			memdesc_flags_t page_flags = READ_ONCE(page->flags);
-
-			/*
-			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
-			 * VM_BUG_ON when accessing poisoned pages.
-			 */
-			if (page_flags.f == PAGE_POISON_PATTERN)
-				goto skip_continue;
-			nid = memdesc_nid(&page_flags);
-			if (!node_isset(nid, state->nid_filter))
+			if (scan.nid < 0 ||
+			    !node_isset(scan.nid, state->nid_filter))
 				goto skip_continue;
 		}
 
diff --git a/mm/page_owner.h b/mm/page_owner.h
index 4ab513f17fc9..934bc9f84d6f 100644
--- a/mm/page_owner.h
+++ b/mm/page_owner.h
@@ -38,6 +38,7 @@ struct page_owner_scan {
 	/* resume point */
 	unsigned long pfn;
 	struct page_owner po_snap;
+	int nid;
 };
 
 bool page_owner_next_eligible(struct page_owner_scan *scan);
diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
index 4b9741a2de53..b7e0ce1dfa80 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -12,10 +12,11 @@ struct bpf_iter__page_owner {
 	__bpf_md_ptr(struct bpf_iter_meta *, meta);
 	__bpf_md_ptr(struct page_owner *, po);
 	u64 pfn;
+	int nid;
 };
 
 DEFINE_BPF_ITER_FUNC(page_owner, struct bpf_iter_meta *meta,
-		     struct page_owner *po, u64 pfn)
+		     struct page_owner *po, u64 pfn, int nid)
 
 static void *page_owner_seq_start(struct seq_file *seq, loff_t *posp)
 {
@@ -52,6 +53,7 @@ static int page_owner_prog_seq_show(struct bpf_prog *prog,
 		/* @po: hit-time snapshot, no RCU window needed. */
 		ctx.po = &scan->po_snap;
 		ctx.pfn = scan->pfn;
+		ctx.nid = scan->nid;
 	}
 
 	return bpf_iter_run_prog(prog, &ctx);
-- 
2.20.1


