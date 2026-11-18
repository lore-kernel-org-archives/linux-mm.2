Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40D060A2604
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AZ1rX3p3
Received: by kanga.kvack.org (Postfix)
	id 69BE26B05C4; Wed, 18 Nov 2026 16:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673B26B05C5; Wed, 18 Nov 2026 16:04:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED776B05C6; Wed, 18 Nov 2026 16:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3B2E6B05C4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:04:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55F0A404C3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:04:00 +0000 (UTC)
X-FDA: 85449467040.27.443F4C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2C27640005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZ1rX3p3;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035838;
	b=JyRRsHdVuFosl3UbBfttxTM4C9tb2h7uTxchCqryMa4ZjWVisQ9Z2tREaB26eZxWx/DPbf
	ArRXqZC6GjPIrpZJbeOaBNJxHTjWxTObKcX/88briOi8NXgay9Nd6ncnBbjaFt8Sv2O/Y1
	8ST7ZsYQ3kceTLf/3MvJq5MYYRF+RZQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035838;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lfMIxrq3hRipEynq2/JnfZMxHCxW1AecXQL4pdwryY=;
	b=lk/AoKVIlK/vrSzowNzYfOyXBZaCPcwXBBNJb+cMWe2QCFzBDMqinhFp/JmOCeiXx+gSyi
	9gI26EexnGZvCoz/bPUVEcyE94/fGdDVJkcyjANj9HVdMu05qYgzA4fxlOA+EFXdk1bvG5
	AiiXsMbLTIb3YuqTIEjK9DVqNbhnlpo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZ1rX3p3;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE7B463D58;
	Wed, 18 Nov 2026 21:03:57 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035837;
	b=EC1HRUyUhREtP/bIwRo1L3doBapD+1n/yp+0zIqGk5zmgzwX2nZqd3gtA8yr/BfMaI3X
	 erSdlwgUsIqgJUvL5HF1xc82/8nHIHk5OJ3lLyqquuQzVHU5vAxkSdGJQ1oLfKn8cR1Lc
	 BOIFBdH1uJND9RvJQjXULW7FVf1y2UVG+3eYKN2km7zD6CtABgHDtuyqs2SR+rxFs6Krp
	 HA/6kOTnAOmwfzniZbOOKL3emG/U6fhZ77a20qdW89Wf+4wSmxQ/b1m4hUgnLJPFpr5x3
	 hn8H9UuM7nGX66uPjNbJ+IAUIh9fr6kn3994/OORIwVT0JhC0if8F4LF+kpRu3svuUg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035837;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9lfMIxrq3hRipEynq2/JnfZMxHCxW1AecXQL4pdwryY=;
	b=nRfNwtipSqltSsbMhgb+xRsOmzBSuXhohVThUCGxx4rFyzMFJAudwV3LXzdyDnmWtnqK
	 7K5qwbrSunkOzrsuIVTerj2xcLDok0kiuGufMBA1z30lHWbyVRsqBrUVdFr9yCIlsHtbY
	 O50EyneceefqYoU3YKMgqznnvUTkUg/yg2MBoUZtJeyAIunY7DXKym7I63yu4l6QHS1D8
	 CZrYJr6VU733ulyZ985HAz0C3ifYL7ipuyR2HVR/Z2I7CgFf7C5w30ag4OBve3LxQ8hgf
	 4q8s0UgSkii0LU7rDYgtvp3LJj6zjlJ+rbsY/X0Oo7yKmDOA6xczK6VSFOI/Uc9Gskg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EA5941F000CA;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035837;
	bh=9lfMIxrq3hRipEynq2/JnfZMxHCxW1AecXQL4pdwryY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=AZ1rX3p3qZ148Ucw/lPIMI8pF6Mhzpc7ghBtxme34TWQtOQGcsu+ZmKN1GqLK3BVr
	 uOo8wbSiKDWpJoqTcPNxsOM2ZI65VTei5D/8sOA7sff9vnVowociSqHbWl0DPipk4s
	 zITMm+V9OJunXo3SGnNHa+WfF4XWNqN0TVm+KFIDb08oLvMprGg52+b8LY00v7RxJk
	 a0rsIcHGvIMKYIvVspGskeSjmCaiCp6C6X0RZXL2PiDIc4g61ipWsX0ZZ1lI7u7wd+
	 0pCOy2h8jUpkinMhWeQ3wyQ0jkl5bimdcOzqT3hh7FeEoir6no+UwGEUdAbN6p+K6Y
	 kaY+48f3B74YQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6CAC64AFB8;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:45 +0800
Subject: [PATCH v5 13/17] mm/madvise: adapt for LRU refs based operations
 for MGLRU
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-13-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=4228;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=e2/wJGzz7UG796pvpeTdS9931gFtuVmfWc7pwiPH3QE=;
 b=+qZfN5m6KQraLSxPw2LvM1FrBRrXilTuqXKSet3TJOUvO75N6rGPtiesIIjGUXb2O85Wj3jA2
 F91Iy7qUcOWDYAZfWjd36BhpmJykCLiDEadB3E+6w5bq5f9AbyMuM1i
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C27640005
X-Rspam-User:
X-Stat-Signature: qeqhnteqg5ntx7j56fzidbh3tcrpa6ba
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795035838-954869
X-HE-Meta: U2FsdGVkX19AB35eJrEzZUwK0rvRnxrWPHs+niNwXZRn5fQtx5pteQYXaSrlGGzdkNk8M+IXem+VTAaDCZ66rk99leMrvmxJhoe8flcamfdZ+1AdvS/+1eStRCH8oRaR2wpuksq4nkJFEjdzuBTdWXV9xz+Iy4ob4IwsILBMhzrwBGI3x6vJjrnr9crX3nEYJ7oPGj1GdZHPd2PqdhBlhh1At5HJ+M7TKNbpYEa5LpqFgMSBTGB1WOeQFiHgLCV5CRwudCW958Yd1LLKVVyMO7XGiot/bDU0eG3YT/4xVHi+Am0rbg8PHC+MIwlhX87n6MRcBGVmkVl2BCGbB6Ax4UZrEXykrmZnxTKqjr38dRpYNhv3YQfBEa0TnmkxsyPf5NtRil88pYzqAz/gQivMY5u3RwsJTvfAYzWWFJ/AToxmKFY93BTRIrY2kryLbveRrO+YxmgVPtjCof+UcDv6M9iyGnOJ3RUeqFhRhLZqa+7sdpnxEedQKk5QCKjJ8b1yTDAMEAccFgF4GtUbZjsoZvtxCsbM8vHYWeHxuThcp5ZAECcNOJJAPMl43Wzf3JvESqXexzdJ5P4JXI3AQqcyrcbRsRwcQ4xCf8VNHoPWuqoEizPU4UbBNHnByWr6YQwgEbsPbIGtkEzPdMCBQC6Wrew840A9AbqUTd/9CRoiUXGgiJz3qI4cHXbtnO+WX7tWMPv7xCL7XHWnULZHwZCPQmWdKZBcyDWfEfZMBfEIsIFS0LuwtWxMhYD0CtO+A/2A1YZuWKi3wSgmwa0EpXCjlG0zKtVCQCzeg0/1RHPs+y6Cd+N/rDuZ6YAcGm5QFPQa9iJvMY/hTEczPboQHoxanJP17X0wLImJuXunG+AIlhH46YpYo6G95zSjA50zQVQfIcT9pufqSmVhyEHpFbRo1Zxw1pfpub0pn3xf/Vgn6Q34Fz4opkIQ3CjEVE3vMey3bLCegcnZc307p5TNDr1
 5Fc1H5xq
 KmwDlaMFWO3fv5rSh5/x/Zwxmlc/KGji32qQ5K9M3ZDq5IcCIfK/aJ/ckarNblM1zHI6Bo1hzaHsXDI1xuGEChj2J8RulW7vDraxTEaZchw9iU+skIhBPEI54tG91y1PTihQ84ZAMT5TCXsTIeG7I0C7WZXjFXo0GxKfEWhQp4N96dz+mIpHiFe7Cvr5Sx3LZtgCXH6lr/Jrba/XCoTRkLWAF+iJlaEHcyeS+rnUciW04fDoqa0YmlsK+51bilZ2sndaHCaozkZYurJViyczYZgvqKNvChquUovRlABAd1JtXUoXJTF7I6R+izBFsUIG5GsAs5W0PB0Q28uJuheTCs+aV9TtkDc7weyMF4vhqvddWsVgWO4QsaDV5+/TONkm1s3oU/SwKMeaKT29aLKE3iNlKxr2SIBIeczhLYLiGYp7NTOzrPnl19JvCgLLZVh78TDpvxiT5Uw/F6iYz/hW7Eyhxhd+kuGcDyO2kPAAUOAdTDOK7fZpWcNxBlBogZw+MiIn/FwudXT9RwCuuNseS68Nv0f7/SC8rHbi4UaJ3zasFuAe+M/rIezsOHw0d+XuUlOMOk9nCelFAiHC4KQ5MCz2OeoxfCDq1XZVjS6s/Nr5jlcitsakSyo5Mpy2bXHKp+hsSlbsWhpG4QR8ssijfkwzxhd6ZpgjYIoua
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

For the active/inactive LRU, madvise clears PG_referenced so that one more
access is not enough to reactivate a folio, and keeps PG_workingset on a
folio demoted out of the active list so its refault is still accounted as
a workingset refault (PSI).

MGLRU keeps that history in the folio's refs count instead, which now
lives in PG_referenced, PG_workingset and LRU_REFS_MASK, so writing to
those bits directly corrupts the count. The two hints want different
things:

- MADV_COLD resets the count in folio_deactivate(), which also requests
  deactivation.
- MADV_PAGEOUT clears non-workingset refs and caps the rest at
  LRU_REFS_WORKINGSET after isolation, before handing the folio to
  reclaim_pages(). The hint marks the folio as cold, so the
  eviction shadow records the capped count and does not inflate the
  eviction/refault counters of the hot tiers that drive aging, while
  folios at or above the workingset threshold keep their PSI
  classification.

PG_young is cleared for both LRUs as before, so the referenced walk does
not count stale history as a recent access.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/madvise.c | 54 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 2d54cb9863ea..7486c492f437 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -360,6 +360,42 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+static void madvise_cold_prep_folio(struct folio *folio)
+{
+	/*
+	 * VM couldn't reclaim the folio unless we clear PG_young.
+	 * As a side effect, idle-page tracking loses recent referenced history.
+	 */
+	folio_test_clear_young(folio);
+
+	/*
+	 * For the active/inactive LRU, a folio demoted out of the active
+	 * list should have PG_workingset so its refault is still accounted
+	 * as a workingset refault, and the referenced bit always needs to
+	 * be cleared even for inactive folios. For MGLRU, MADV_COLD clears
+	 * refs in folio_deactivate(); MADV_PAGEOUT handles refs after isolation.
+	 */
+	if (!lru_gen_enabled()) {
+		folio_clear_referenced(folio);
+		if (folio_test_active(folio))
+			folio_set_workingset(folio);
+	}
+}
+
+static void madvise_pageout_prep_folio(struct folio *folio)
+{
+	unsigned int refs = folio_lru_refs(folio);
+
+	/*
+	 * For MGLRU, clear refs below LRU_REFS_WORKINGSET and cap
+	 * the rest at it: MADV suggests the folio is cold, so the eviction shadow
+	 * should not record its hotness in the high tier counters, but
+	 * the workingset classification is preserved for PSI.
+	 */
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, refs >= LRU_REFS_WORKINGSET ? LRU_REFS_WORKINGSET : 0);
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -434,12 +470,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+		madvise_cold_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
+				madvise_pageout_prep_folio(folio);
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else
@@ -544,18 +578,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 
-		/*
-		 * We are deactivating a folio for accelerating reclaiming.
-		 * VM couldn't reclaim the folio unless we clear PG_young.
-		 * As a side effect, it makes confuse idle-page tracking
-		 * because they will miss recent referenced history.
-		 */
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+		madvise_cold_prep_folio(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
+				madvise_pageout_prep_folio(folio);
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else

-- 
2.56.1



