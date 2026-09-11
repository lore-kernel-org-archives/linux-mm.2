Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73635C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FFC6B009F; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8A96B009D; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F79B6B00A0; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 134F16B009D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A96A2801B7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:15 +0000 (UTC)
X-FDA: 85201300590.17.1BE0E72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B807A1C0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTmK0by5;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127113;
	b=I/eNSfbVjciqw1cTcKAYn2as94W58+T6VT43JUdSJLZfWjLjUW999vW81ZjQMbxqJ0ZsV5
	j4D7qpoOQugfRznW+u0+W0Ok1EzPA8cg4avIaya9DSA7mFMe6rCaBa2bKJcTDFDkQpiBhq
	2rQvsvZl12xJ6N2zOXoLNF01HH5D8DI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTmK0by5;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3rufMlUnsr/k/vWb9c+lZHw2VgSRz8NyoDQ/WsCurI=;
	b=OIJrZS/cPbNnhMp+c2cCaZvR8FwRntf4b2NbPPWiW+GOmtYv0mnV7roC55fkeK2sDUXiSf
	GAOWFQYTvhnaD5mnewoXnj1f0OqUqzsePuFKKXYYy4+fvHzS0rLxkAQ1nLHjfW0ypva8+g
	hZyltZmAcqhHYWuKxp/uVUg4jPkqNAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FB2543EB2;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C13DC2BCFB;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=d9QhD7pUxx+qjGulkGZZ65rU0vamSq3hj2DTDFAghUU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KTmK0by5vM4NCxxSA4xlx2RhPCUWk4h0RQPBTtyshSNr6V15lj33xmyJIfCtDl13/
	 v4QYlbQ/OHu/BVuwfH3pNWUi4vGf1MtkRoxmYmN1AXjIJ/Ft7MFHhXT8gzv/6SnOL9
	 UXYujhhypUxnKFQ+z77+s17US0Mb4OWsz/UeQVWCcSIoXQfcGzAxZVJIyyQxpVjJaY
	 bDz+IsMAydtNfkQvCzTIqKcUD0FUGkuPaWHwObNz5cErVmKpBbh7qYjJp74yjLv+ip
	 i0lWI3EcbDZmzoMgig9aGjBD+Ks098/DqIe5pRYysMDb9J6b8PJiBNwa+tSezwox+k
	 /BJm1SYCccVtA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F63C88E4A;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:11 +0800
Subject: [PATCH RFC v2 08/15] mm/smap: convert to LRU refs based operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-8-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=2654;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HXO5gwClyDxia1jxGpm9V9P3/YbOdlVcEqlSn7qAT1k=;
 b=Fdkhhl4v1znpzampw4t/OvUwYvz+mRHHNoOG27pPcgbl+BBiTNjNLJ3mj8LifcHwbvHDT9ZHo
 7FfnH5bZ6ffA38pZL3nPEw5wpbT995npKwBnooE+V6ZedJ7G7+gAXhx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B807A1C0006
X-Stat-Signature: z9nnr5i1r5njacmcrpu6baephpy97s6k
X-Rspam-User: 
X-HE-Tag: 1789127113-131029
X-HE-Meta: U2FsdGVkX1/d2Opw24RdwziwO+03UfpgXxcakOv99mzyS5e5FJMzz4EhdYT9TSiBAUEcZC/hPUArxc5lmERxJYSZG0JGAQSjmt05iw9wuDPaKlslhQgtoUOHOashV/f5gx62gq7xs1gg+LG4z72a+gd4HDEcB0T5OiCiVJUmkhq3HojqwLPZH90obSjElHPk0O4WnoElxkNer+VQ8ctK6jZpDe2tPZ9bAPTXbqXH21CXmFp/fPElljj7+j8nJnuomb6nglghxrkXIqqSzwhWFLYhijAZkcgvBlzveLSjWj/+tua8JIS8tYGhpfHybYUoEEOfhwZ4u3T9BdwNVK3sEalSReCLYa8ET6FJHsgRi1VcAXY5xQ6tJCFM1RY0AMm6R5S47898YfYk/FesMSgKoGh7XpXEKYlIDcX78Z+cekqvsu1cemBAqIsyaKo0Aca7zpZ4KvOVHrAIQE1j9wPlezAd3j715V/a7NPVifx8JVppSBmMmZN9JThUI3z4hdA+1JG/07uIFWQKVINucIKR1DgRo+s6tOA0ZL8zd9dsWuX/7b3BlPozhf6KIMiiNQvRTPokimtYaR79wXuKbRhTnHbMFgOVvBJjS9B8SLrgWn3kw9kFFLrdlD3HlY6YVWNur/XjnTVyX9914UKHc7EtfQL6euzKksfqLMn5aOuVJzcgJpbMTzK10cgzKq75nWM6Ow90ORbcnE+kmwsuRBn3GWA5vvbQ57knQ8tj/XZQuIyH5djcHF3qnsZy8pdkq3MS4LqWzywee0226ZdPXyUDavv4nFb5hnX/K3Jw4DF+QzGShcmHxkJUK8wbdv2jwi+e8LF/yHAYTT+Kn+2P+FyKeI1eK1LKlx5V8hapWNhIYmeQmSVadqqDKeKi+7x6QK5W/pi2Sx5Crqm5cjaPpz2mQJ4hQHBpHWdluM8KAxzO9T90mDNQ5cRMVDXth4o2xYiBqhLhQu9apZGG/KrYc6H
 R/5CbiBH
 tu3na740eGkcBZFbQKgf+2mvlfnXHzTO5UhL80qFUxpfcjmJZzCv/vgDZxRZDH+/bz7hjhyMza0dtUcS7MCR/Dg43Ao75c9pmIo/GaCLk+fUys3jDNBPDFeV/75wDWVEve8+N6/kuc6JFBD9UpOXoRuwRRwf6oTedrq+O4ms5S1ZM+Q4fDOHmPufmAMBACEkbFaqk6tyO33AAbPqdkZeKYyTwhYlWUKvNtPefKCdV4xT2Nm1T0mzwESCUWpTmrUrAk7Y+TTSMUlw+8MJBYmvhiPDSPqPtlueNuPdtOfErHB7/vihbK+fy3zOaRVISe94Sc6vcb4qrQtAa7SzuxHKpcz+y5LQAUMXdQaBVZTIUewJOeShmcxsF7i8I3AStgD5kQOE7LHRCSYebNJzDDvlmTccwJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For MGLRU, switch smap to use the folio refs count API so smap will
report all folio with referenced count >= 1 as "Referenced". Current
smap checking PG_referenced is causing folios to flick between
referenced and not-reference status, because for both MGLRU and
active/inactive LRU, PG_referenced may got cleared on second access.
(Increase of LRU referenced times count for MGLRU, and movig to active
list active/inactive all clears that bit).

After this, we will have a more reliable and useful reading for MGLRU
after the FG change. The behavior is basically identical to what we had
before the series. And there is no behavior change for classical LRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e671b4fd8ded..9cc47efbaa51 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -880,6 +880,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 	}
 }
 
+static bool smap_check_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_lru_refs(folio);
+	else
+		return folio_test_referenced(folio);
+}
+
+static void smap_clear_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced(folio);
+}
+
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
 		bool present)
@@ -906,7 +922,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || smap_check_folio_referenced(folio))
 		mss->referenced += size;
 
 	/*
@@ -1709,7 +1725,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1738,7 +1754,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();

-- 
2.55.0



