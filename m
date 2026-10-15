Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2061CCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45CD36B00AB; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6716B00AF; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2878C6B00AE; Thu, 15 Oct 2026 14:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E23FD6B00AF
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65CBA4010B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:02 +0000 (UTC)
X-FDA: 85325664564.25.1EFF2D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 51EE5C000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9bXnKJr;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088160;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zn0hVU6xZv5Wo8LV/dBp9Aat863lop2U6jpxQZz+TmQ=;
	b=Te4T2xM7iw6YteUsnFTuyHBm3V7Sxsmd/5zgUaz+amh92p1IBGc1PV93wOt79HY9fyaNmS
	zsdgsGwBgnQ0S5vSyPO+UaM9QBgJxaIbF45RZztAT87oHl0wYKH/SWzBArk2IEfxN8FPa8
	3VathuL3PiYh299R0nkbJZpzvG0lSAM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9bXnKJr;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088160;
	b=2PjlQzXJ5gcb+xObhJB1V9v4tJdOUQB1GAzHh9Xwp4Rpp08w2hoz6JxHZkhLDwWsVFL66X
	t+PdnoZkjvIBTX2wEO3BI0KzIXgSXe8WyFIyPhgHoPni6LhBKto/U67Xj77gBxo7mBvYZj
	HrNvL1HjxYh0zoo9uGnvknDmB/jXzDI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DF2C447F1;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD688C2BCFF;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=IMIPLnANXxcSiolHkXP5An66gjpZDy2DGAjDFMRr3K0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=g9bXnKJrBTQ6Ld6/kpqL1Ajd9NGGt1ufkGztPE8/MeYq6Y7QuILia/Uw05u5r/j4o
	 8b8o7nMWtDmzqBgpfVePSXay61ORbWNthuvoJRsVALw1Orvn7E5gpM+UJD5GBwhzMv
	 08wE1BTkmYHVRtQ5AiT5+E8v1tOt9/TgV3e/ov824ojz86MNf0y1utcklNfTIkKfGS
	 Dq20Hns8fFSd4NTYM/j4uvdIWkwxukrCrNgAXydo6mKfHkbm6xn7UaALuqg4hjuid6
	 dfDSKo8RWsEdVEwv7uJ4Z9n428ZUAtHgWPoF7gc7MsQbih74WXO9F/4joaMGQkbx78
	 3P3r0WGuztjyg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92C9CCA467;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:59 +0800
Subject: [PATCH v4 10/17] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-10-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=1305;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=+Tb0hPQRVBeGNFQursundpLJPnEU7iUig7NZAg5dyxU=;
 b=CyGgF3KwdKpDK/OPe5JsFLV9+9m3zkFUvTK3nxJVeinp1EKn/EhM9YluR8cGMSowDmMM9MQFe
 v00Gu8A/iiFBT95X30QnZS7uBlb25LDBy7tmWh/fvzwrgOY4vWuOcKC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 51EE5C000B
X-Rspam-User: 
X-Stat-Signature: nthmpy4knw1uf8937ghgnb4xb1fd8y6o
X-HE-Tag: 1792088160-3463
X-HE-Meta: U2FsdGVkX188AZv7EVPEDfzZnOX6gGR9iOgf+jp3sRmEcaDG7FGlItL5lQdvC7Xu7SgRcVzeq2zeINtMfn4YW0nuNNJaoY9Wm6R+rO3YljIBPOwwWbSswhvb/tAPwRTbmosLl9PaO/A8sBqaP8Tl6j+hqvv6q4svXslmcYGJ2/KUzYFOZGHSpb36U5zzvH5s8tF2ARwpoVRNzyxu81hGPFqTZ34DPHCEAUoD+wwcL4cQHIkMhwJnzqYEhVFcK+XTnoCfq03nZfxF4ohbN6D78bEC+fCXtyqM1QIdrgF3EqKc8Sz7aeB/4yMo/Ehu4edLTzoWGz3fFzSUvwFZ5O38OCDAEPONKvoPQ+e1w3Q+4efvzP51TtHzzTWVf1W5RNhZLOYZM3Fd9ZgSh4ggUa+K+A1LsGZsatM+jNv+RWBq3i2w2U7PfzIOYUQj1y6AZxoSOW5J1BGaJ1FY53CFzBvpzpdMg7zZzu0CBmxrgfX2Sfz76wttbK+rxGowmKQbfFjKjf1+xjIh+xORTYAo2uPc99ZzshuzQ+TRrqjuwMa2c1SkRzjIlgZTlWD5KcupIfcDG5bOIYCOY64FDpLbcbWF0pVF9PYwIQL7YTZ4N0FtczPovD/s7kLE8CLaHHINPmo5rQtlrpM5b2w0uaOpEUFeJlkzAOy/aVnQ+XgfBkDEUSCkuzvE2wMhaxQDf05GMZsjOFYyCUY8LNw74+whb0OCL8wLdZ7oVU8xAU5clP8gJfEbRR2nv+rgBX4WjfyWABMI/CqUaWp3fRUclhj57fSLkrK5woIxOf1DMT6lGffnHy1mrxycDTX7W2QYYDzCBIJgUQDeeTVkvPtbmj/RrkEsVu91qW6zf7yCPxNVP1gkMPC+PGgRQKqvUGQX1RNR4ZVqhZoOE9+/h2mVvOT/0KxYMetsEpJw7r32aVZNLZbfOmTo/j+hbdqKXIhzOtFehiiilMfVtQRG2nGb/A8oEnS
 fcFqelpw
 sg/720TXjdjyDg4ufJrX+w7J7rJo1mQf7NBCIlI4zPytoY18QZk7X8gHSzGUUxHg/t6HJee0Yrz7Ct2ynm9gAoLI3V4N/TiF8O9VyZalsviwlmdtHrYIjNQKHQGHJ2+36AlQgWeEujhwyqsvVB1zQGsRZVwYFGbHFJVr2Hu6Z7QzAliIptnE0xsG2iBkDmQ0e3UF43yx2noBQl7cxS3vFKPR/mFLqUjbr8vna9EssNtzZI7TGje1cTRNE51AvmIQvCKFsckCkCxYBJd38fDyr9xzT5upRMzxhtfE9tA/+iez+/tjVyxWZWjnjA7MCo+dumfwpwQ/RP5OjMPWIMMZSgGfBjCoIoTAxi66n+/7aO9SedHJVehy7ZGaffALOgq71ib+fV0g6TNzfFDHHfwW/3RHsoJ0SmAMPpjRVZDRsVnPvqdziYEI0pMEmL5FTYeYAno41zOWyaFPCCm5p5BWHZks4+uDtdhnEBN4Zi4znK0gtKEILVW+EVoMO/WJR3UAtY6dD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
count, so folios with a higher refs count no longer have the bit set.
folio_pte_referenced() testing the raw bit misses hot folios at
refs >= 2, under-counting the referenced folios of a candidate range
and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.

Test the refs count directly when MGLRU is enabled, mirroring the
smaps conversion.  The classical LRU keeps the plain bit test.

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ef5cd6fda34f..5332b4c51fec 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
 {
 	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
+	if (folio_test_young(folio))
+		return true;
+	if (folio_check_lru_refs(folio))
 		return true;
 	/* ... or the PTE mapping was recently used */
 	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);

-- 
2.56.0



