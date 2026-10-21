Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F21360A2606
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485356B06C0; Wed, 21 Oct 2026 07:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED586B06C2; Wed, 21 Oct 2026 07:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE916B06C3; Wed, 21 Oct 2026 07:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 010B36B06C0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:24:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF9E380503
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:57 +0000 (UTC)
X-FDA: 85346401434.23.B4BA8DB
Received: from mail-m128247.netease.com (mail-m128247.netease.com [103.209.128.247])
	by imf11.hostedemail.com (Postfix) with ESMTP id 67CAB40008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792581896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XNod+BDD/BkSwCVYSyt2PbUacsNtMgi+MLEdpjX47ak=;
	b=YErYm9xZEvQdPOQVulFug+xe8EsdTG7c7VLdN8j/sArJNTxZ02wnFMRMGyKbLyQBk9TMKx
	Kirkbem0bl14HMhw0eodmpE0TZ0R+4g2Ty1rlFj2eJVI4WEAqIgWIbaeUp05nmS41bO4MN
	ZNsCjtzpLqqj5CfDTABmm2sfthPI1d8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792581896;
	b=BV9PYfQFzqcthWon8evnNCzi6mBL8jywaZRSJt5Hp+gjoQkhBASQxERn7UfUz2iQaisc4D
	DsKeLKmS7yILhodjXLYYiSePfK3fzvLv8OB4LXSPPRCBTCcUzPD30NqnQnhPE4uR+vWBP3
	kiSy8MAMid277ADjjbTles5NHgITOKM=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 204f151a7;
	Wed, 21 Oct 2026 19:24:50 +0800 (GMT+08:00)
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
Subject: [PATCH v3 2/7] mm/page_owner: protect page access with mem-hotplug read lock
Date: Wed, 21 Oct 2026 19:24:32 +0800
Message-Id: <20261021112437.1799213-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa15e34f2a30229kunme08c1fd526acd7
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSx5PVhoeSE1LGB5LTEpMH1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 67CAB40008
X-Stat-Signature: ezbydofq18zn67q4d1tns1s67ghnaeqq
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792581894-294478
X-HE-Meta: U2FsdGVkX19dpCuqbtweyH8N8yvPoMoemWeaPz8PZ9viFmshh9G83hE2/3UyV4KQBFxEOKfrMx4GMlQljIOASRtjRelUOkMDDUpHGxB229s0LFx8W016PZ+aEOUr7n0ICl29qBgAu7Q5hQh7x6NcewuFn4G8G6Sp26uj87tHz20wvUITyrt8bdRawIHQfWLCt2Hq8rjRSkMaGvOjwWQSdV4x32nOmCIAps1F8vU2IRMEo8d8iKw6I7WZx/uzml22qbXWSNuSEFEQALGCIhCyR5O7SBN6PYUGZq3ISqbrbLhWAuykxtuFzrRLAFX7iRzo/avgHrZLjkjBa4eQyOaIBUsIpp5M+ogzudsdm4UDUSmrsJ11/4ms4x4PgHdcPTD5LGCh4WNzXxTT6nACrWzHpHbc0+MQkvIBpj79fHC9bxWSS/iZUH8keAOleJscHbt0KDmyrtUlP90Zee7dH0/8NajToVW/DzkbC04ScjCevgfPZnaWP+PuB7dnkGM/V4hGdiSuaWzzePALSFOJsdnRAYnZvcNJCzDei2OvudQgpvt/4wbEkDiqgeU2nsP5BLIfAz+y5216yrgq2Nt53nzBpnKxHQQqSm/D2h+43q/SaN1bKUfoMlRegKDB3N5fxKVG9KLkxC497/m9HxS415SQOEl/DseNXFlGiFWZv55H1FywjQLcS+ZDPwmRg4IZCawjrU0L+Tr93ihFS1SxmswdTg5rtND3qe1b5e/e/DzTitHcWhN842AeBL3M3orLlby8sLFwatL1/zP2o6Xl5Ounujb20sMQ+YZUHPAYdt7G0xMnv+mWPiO/JCbG5qiumqH9BkpwjS5HAuoBqzyBxXSigsdajRX7bSha8M2gJLlbATDwhgajjzd0g+qnGfc5YZQefZYTGL1JdCpTyI7FSSzaCqEoMonNtaZqKHP1h21qHxKUd6DGCmB8xUg57SjkW9p6Pzag26Wela2VLjekeWH
 meGdhESB
 FQQTtjUelHWLbPx+AUtJ65Vm8QwYRG2MA/BNgBEW76nVSfRauDc4KWZKDwGttVOVo8di0kLtzuQtuMkIrEY3iwoh9NbHKML46w3k5IKCAb+GoBUYUdWZt5kZNqkwxe+syiXb9uaoCVZ75U3Nsn1aAJmCC24DvlPD5r0aRcoyfrBS7pMB2EEvLf5XAzRKWCvcukJ+lw08tDYSNTuMB661Hde0zecdSRxD+vgHUTunbwjUSswM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The page_owner scan walks PFNs locklessly and dereferences the resolved
struct page in the scan itself and in print_page_owner(). With
CONFIG_MEMORY_HOTREMOVE, a concurrent remove_memory() can tear down the
section's vmemmap, so a dereference after a stale validity check may
fault.

Take a mem-hotplug read lock across each page's check-then-deref. In the
scan, gate every PFN with pfn_to_online_page() under the reader and drop
it before cond_resched(), so hotplug can still interleave between pages;
in print_page_owner(), re-resolve the page under a reader covering just
the print of one record.

The reader is cheap: get_online_mems()/put_online_mems() are just
per-CPU counter increments/decrements when no hotplug is active, so
they contend only with an actual add/remove. Taking the lock per-page
bounds the writer's wait to a single page's check-and-deref, keeping
hot-remove stalls brief while all accesses stay protected.

This makes the traversal crash-free. A recycled-but-present page can
still yield stale data -- the lockless scan is best-effort and
unchanged by this patch.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- New patch. Add the mem-hotplug protect.
---
 mm/page_owner.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 92a92cdf74ec..8e72a85c663c 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -762,13 +762,22 @@ static bool page_owner_next_eligible(struct page_owner_scan *scan)
 			continue;
 		}
 
-		page = pfn_to_page(pfn);
+		/*
+		 * Hold a mem-hotplug reader across the page derefs so the
+		 * vmemmap isn't torn down mid-scan; released before
+		 * cond_resched().
+		 */
+		get_online_mems();
+		page = pfn_to_online_page(pfn);
+		if (!page)
+			goto put_online_continue;
+
 		if (skip_buddy_pages(&pfn, page))
-			continue;
+			goto put_online_continue;
 
 		page_ext = page_ext_get(page);
 		if (unlikely(!page_ext))
-			continue;
+			goto put_online_continue;
 
 		/*
 		 * Some pages could be missed by concurrent allocation or free,
@@ -805,10 +814,13 @@ static bool page_owner_next_eligible(struct page_owner_scan *scan)
 			goto ext_put_continue;
 
 		page_ext_put(page_ext);
+		put_online_mems();
 		return true;
 
 ext_put_continue:
 		page_ext_put(page_ext);
+put_online_continue:
+		put_online_mems();
 		cond_resched();
 	}
 
@@ -831,7 +843,17 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	/* Find an allocated page */
 	while (page_owner_next_eligible(&scan)) {
-		struct page *page = pfn_to_page(scan.pfn);
+		struct page *page;
+		ssize_t ret;
+
+		/*
+		 * The scan is lockless. Re-resolve the page under a mem-hotplug
+		 * read-side lock so that we never access a hot-removed section.
+		 */
+		get_online_mems();
+		page = pfn_to_online_page(scan.pfn);
+		if (!page)
+			goto skip_continue;
 
 		if (state->nid_filter_enabled) {
 			int nid;
@@ -851,10 +873,13 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		/* Record the next PFN to read in the file offset */
 		*ppos = scan.pfn + 1;
 
-		return print_page_owner(buf, count, scan.pfn, page,
+		ret = print_page_owner(buf, count, scan.pfn, page,
 				&scan.po_snap, scan.po_snap.handle, state);
+		put_online_mems();
+		return ret;
 
 skip_continue:
+		put_online_mems();
 		scan.pfn++;
 		cond_resched();
 	}
-- 
2.20.1


