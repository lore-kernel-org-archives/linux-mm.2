Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39593606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kvn2eKj2
Received: by kanga.kvack.org (Postfix)
	id A9B786B05C9; Mon, 23 Nov 2026 13:53:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74416B05CA; Mon, 23 Nov 2026 13:53:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989786B05CB; Mon, 23 Nov 2026 13:53:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 749216B05CA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3BEB1A05E9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:49 +0000 (UTC)
X-FDA: 85467282978.04.AC65C91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D842220007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kvn2eKj2;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460028;
	b=1XTBOfvn20mq9t8QZqe5sBz9/N+UROFdROodYDT6OLrY6MtxmO0JMcFbGALtNpz0V+H+ah
	kf0Yfx2w7duQ1d6uIvMMVAAPqGTxG7gJCbM04TTgCM2EGUItWTvoC/ArK9IoDW1AGdAPke
	wsaf7zeHdejj0IoQB4ZoHM05Frv0FWE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460028;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mw7v666B0O0bXEelFGMEGNGOC4m5brM448d+fEgwE4Q=;
	b=nW5zBRtFhWZs0oAsuKWAX7DdiEeKI5+b1jfCkYQTakjm855dYcrYZFMMZMRKwAb86o8iF3
	Efw4ytT2c1kZh2IcA/h2d5PqxjHgEyDF8/5poadH3zFSiFfIR8la3uA1V0NQDcbKxWvI0f
	z4GLSZ3W+B2WQZOi9FohraIdNkSdLlc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kvn2eKj2;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F90962471;
	Mon, 23 Nov 2026 18:53:47 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460027;
	b=s9m8yAcxxNEfbnbupQJ/Kap8lXhNHE9Xj/CDHgO6ZuktYW7bG8P/AmD7cZtSltU3Qozu
	 xN9GfgMnN9FOldIn/x5Z41YINVZsbsXUdsgYQHtfyXG84D/gcqBPZkog8+e86HfD9heqq
	 wXHwpetXKRHZQl5rLPDtiHPgDcDpoMW/5/FJisZEIPIOgxneCFWEePMiVjr3r0XvSYNaC
	 zeBa8BxksbaLcVtMR9CzzrW0kWsNpfMsSKenu2GY0cBnG46j73m51j0xnONhfvDVPQgND
	 hZZrBw4jgqw/UGHpDOmDHNw7IkjNoUasUE9+EvRw8XMIuJMO9i0AyyP7WMBEwuyAugQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460027;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mw7v666B0O0bXEelFGMEGNGOC4m5brM448d+fEgwE4Q=;
	b=nE113oW2+S/0/bma8RU8z+GPlzjKgHNRvOKbTFuYwozuGcn1D9PS6OyUUrwbITi/NFwW
	 OG8k2KlHXwJbuF+m2hAsnH3K6vWfcf3eWSoFNDfaiyzb+VoPsk31Fds/Pd6EFY5eyoKVg
	 GVSoEJ8XWZEzQOvxxVAFISn7WnDNdHyrC1XocUvdEMcNMDhA2s1KqmewSWnJHJjuRaRD1
	 8QSsU/KHP20mGZVu2TCY8zu/jRtZb1FvLwH5wszoFR7DRpTe/qOXgq+HY4HtwhWI1f/j6
	 CZVGk+2PaRW1RyBIRSh3mr0k/unyxPVKR0gNnOTgTIJZ5uld8/c7wZyxYZxnuicbyjw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5983D1F01571;
	Mon, 23 Nov 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460027;
	bh=mw7v666B0O0bXEelFGMEGNGOC4m5brM448d+fEgwE4Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Kvn2eKj27hFMPgJVtAc5d2208LouSMNPLAWPJ+1RLOZsBkB9ZOPuC9KmqTlMtF4Ph
	 PWnFZkkNgKZ9EGPdTTPSDDEaR/HpQu41qc4SJesFWCdOF3TERCnHDOwpSKzHxKKRSZ
	 AG1N/06f+cF+G1K2k1LEh3G7MDZcDC+bSfJnf+AuabRx7FLRPrQ4uVPxG+3yUGqIqG
	 lPbuesoiNS3Rz4AnZHCjutNrurN/FKP6gSf5VmxbHk4jas3ivINnT+TVqGVVyJnzkS
	 FkFbwkcGvTUk2dqtZRrYkIKxTqoXZORj5Gq1g+xG2mMMk4XJAer6M/0Qsb6K7LtQF2
	 yk+gA2mwUDqUA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D6E814C665;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:07 +0800
Subject: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=2081;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=svKswWLQsOqCODPXI2P9d3ZShVpGHldhUm7oZl8WLHs=;
 b=uGyjbdLY9Xmj/REU9NlfpO+n2XY34DVfiQMG2A8ErYXhlavxnUkdesLKD0RF2+NCUWBfn8wnX
 n5ET/23+qQAD8v/x6lWvWEUPWgb1QREe0OKsx1v+54gfQ08nLyRKQjZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bfxig8pyx466kngyif5ziwn784x8gtoj
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D842220007
X-HE-Tag: 1795460027-356440
X-HE-Meta: U2FsdGVkX1/8nuHGHrYSErXHbz1d1g34T2LVJ/DLShMw1BOiEERVQo91ZY1kIpyLJ+wT4Xe5SYSLiyYoxlWPJ7d2VIHCVaKuGzHfUx0/1+L2ERYFuCgt5I+yhIdHkAmU57k3P5d7K/X6lWTQM+Jf6/IfGCH7er1ozM9fkdalFCIe7at5WWy59qJ/M5LUteP8Sg5lkzTG2UuG/lXnDNflVTURlpRmmh5QIPsQ58IKE2cOluj39mfz3ta9LKdPEwdKqr6kAOU6V/GSYjUpeCVSBzD+IB6YTjQMwYYypCdlCg1mXQHNCQs1cdEnTwJOh9tOC7w3Hd67HYrRQ8+m9bG4K1eOfqofAsu1tOZEnuEVLbEcVBIDe2cK1jKss+raWNi6taULSXuDZRjH+qUKO+/EB+uKJggshP+gUc47D7F7UmioWfluvPJDCB71ekCybro3AyGR9+HlrizsuNMa73l/pWZgj39JlvQAwcvFHfByRCMVhY8qmx5azuEiehWhcCHuaD0xiaNeVW9J36clw7XBOpA7h1gPq8uynL4lp4/IVsGto9l6NMp77d2rkMpLq2CLcH1y62ckwTXqZ9reJ/oVwYSfmHculBfurTPZn7W4QgbaA3R7+bjTAyPqaivSkIPx8h+wTknty8XCodJaNlBM1oM+bhr8AeI57kdTEXBxxo0X8Kez+ctgOp8QM8SEb+XMS5LSq9R6LJf4i7o63ewz8RegBQAICWT+A6ApleyqYfVAIPkFYwLcQFEeuYj9uk9/Yzo8gOXZY8lQWE59Aq/3pb0lz3oT4BUDivQY4KilfdRLS07IPLqRCWslYRv5XLpEE4PMXDUisI5jqiZunnoGhpsZpYDdazQ1zmkPJZa/pPjlrbgbLjvAnrX6ndUhJWUxwytQ+wYRLvMGV27ggG6Df733/VXfsDrcQxvbCpMYMBbHpNF34ioJ9+C+T5835w6KGnQyTPF7VNdnldrvGCt
 U9JpcPXG
 dbWwXN/tsLEyRkkijI6eQUn02h18tne786WDx7s4/RhrOi+EO26/HN9VOM/lMNn0Wr/t5iV/mO7gDML57RdEFE6vJI3RVU/sjHmTssB52Mh2LuyvHttvf3cSD3+lVqe7UheYCTUlxFyqo8xxmotXfYHOMKiVWLmvkFqaFbBHN5fRRoWsE7X1l4pd+KSlKtBUJpZMKSvRGCvcnWrMyHJDuifKg523U8ya4AnK1adHYkC1pHVnP+ME+3udjn9Jh+iboE7bQ4nPii2I5f5FiQamPHwgZ0jvXew+iZSHnyKDXPHmvjqDjZBE+qIHbxVIljWP2sU15uM6b8rz8pBW4SLOt4G22huSc8vEdvZiCh1d5Rtw5+bGEStjzqsGmd46HA5VoAUGdQewCPLZWhpuTCbGCa9F4+0KOwb96SkuiDrklXpwWO/IIEDaQ6IepffLPE6O5VMe8qwL+jAxRJta185xV6CGSgQqpuJXMDT3JaT8S9vaA8o8ynHRCP5tapt5+If1lzVG7pVpbMLmZrjkt9ovnPuJxN808rgUKJ7TNJeICHgoAX+bphj4UkmZ8XcnkIl2gYTnGtXZ4HlSei1iTaVpPPLlOUZmG54k7M62DIWAfthlt4Uwi3h9P2YxreNdUiobLvIEGny/lxhIu4It0Sx8pAezK2PA6y3rGxoT1JVczpmTA2ECNySO/6ZIfGyLdLWbU9KjSAdq2ZCEH7CQKn2otZZyOG0lAVtn/e9R+oy/ZR1eZG+B55biN97Usd5R0PqpgAhez1tt4QPiFmCk4SfJ8okVL0EdUVf3f6PX99Dx3QkBzaqEAuCDQCSbH2q+jDLMaNx2ZO1hJZQuaGF7ZnKL8HzgAcoH42eGiq/HwdwgGFHgWY3EX60ICXmoiDSwRoNURWTNOkCG1xxAgLLN8iRIl+k1kk9Az6042vX4+Q/49JWo46oE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The behavior of updating the folio's access info isn't consistent for
huge mapping splitting or ordinary unmapping. The page table's young
flag has to be translated into folio's access info.

Right now it only checks and sets the folio's referenced flag, which isn't
enough since folio flag updates on access have their own rules. Ordinary
unmapping (zapping) calls folio_mark_accessed(), and it also checks
if the VMA has recency to avoid false updates.

So first just use the right helper here to be more consistent. Keep
accounting the young PTE as a cache access, sticking to the current
behavior.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 75e8641bf9ff..fa9f6d21e786 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3122,8 +3122,8 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 
 	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
 		folio_mark_dirty(folio);
-	if (!folio_test_referenced(folio) && pud_young(old_pud))
-		folio_set_referenced(folio);
+	if (pud_young(old_pud) && vma_has_recency(vma))
+		folio_mark_accessed(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
@@ -3245,8 +3245,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
 				folio_mark_dirty(folio);
-			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
-				folio_set_referenced(folio);
+			if (pmd_young(old_pmd) && vma_has_recency(vma))
+				folio_mark_accessed(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
 			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 			folio_put(folio);

-- 
2.56.1



