Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79FD3606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ij2vQusM
Received: by kanga.kvack.org (Postfix)
	id 9157E6B05B2; Mon, 23 Nov 2026 13:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC616B05B3; Mon, 23 Nov 2026 13:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8018A6B05B5; Mon, 23 Nov 2026 13:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C42E6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E57EC12097D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:14 +0000 (UTC)
X-FDA: 85467281508.27.672EB08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B25321C000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ij2vQusM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795459992;
	b=ZUrMkH5zFH5ldwj5NuixtHFaPYoY9pT79khjoWAE6bJDUj9KoBkE8fvMMyi0luBO/2StH6
	NvLu2Bj+t+WoRmIdjD7nhUUHxmMYVIuQ2loBlRPEko0h3lzUiKCBO87P+C9egIfxyOTggb
	xHf8rrqkAfyeKtlbrw3YSrWC8v468KM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795459992;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asmN6q2HefJieUr+/zgw0602de6l9KxgRm2+Pk/d8bI=;
	b=E/qnHetw4I5uFDpAUa4xAklaOwwpKYnPLj3Z0hbF5c8z/krGQDvcS7ktVS0CG3oPIXcCwU
	guLbnH25rnJL6L5l0HkHuKuUWyE2fuYsdesY6e14FB9jyMX0A6YCxXDQDtO0Rid4t1k92p
	T96FP9Zimw9AJ4tErvYladnRYI+/OO4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ij2vQusM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00200442C2;
	Mon, 23 Nov 2026 18:53:12 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795459991;
	b=ViE7+Y9J79ybUg3vFucirNU33s05Excg6q07imM82lnVOeFusNCkha0c/EqADUcBwi09
	 vyCQXWEQcGP/n5US8ZobJVCVpmd8mhnnZ8e/9oHK4z6cCitNpflRg07dO6P0eNygHEppE
	 OIBFhISwIytwYKtNCutMAll+eUMiFEObimSF8pkYPF6pofJ0vw+Z9zM/V2oy4bciWi3Hf
	 YAogCYNEBob5Y6pxYXM3aQHeifYQbOrRcDHLXYQqW4EYUounQS3MQj9VK5+Dd7QJbpSj5
	 e2bHrFnrNU9JVIEPsqpFDD6SdjNXLAvO2L6t+Hs5JZujRuhOua+R5F5MA8e82hons7w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795459991;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=asmN6q2HefJieUr+/zgw0602de6l9KxgRm2+Pk/d8bI=;
	b=VW/N6zwng1OrgZJM/pRrGoNrxGOwC8AVmMTwUbGLXhtbDy6LT0ViMPpPOZEc8RDzOeKJ
	 xqrqFZa4+fE5He1hCqoiqPFFbu2kGhKCk0rD0HDZJjk6ASjVtGN/7Vs068OgXBE/MgWYY
	 JUIVNLDLCCBalkUc7g4v/xQJhlKzl5wgeD59/rOmbKoDojpcF7yGxPgq2uGgYezT7gY/4
	 y5CnEVzXmBJ+JIGVk+3wf3G/tXw4tWTrnupnu6+WbcLPb4UGRdjia7n4bhwetPjPWdR4/
	 ZrNumN4ebvNl5qqjfMZnnX1MHg5Pk2uA5YjErbliBNuWSWB6mm7JY5i3+uKANq0psgA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ACB0E1F000EB;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459991;
	bh=asmN6q2HefJieUr+/zgw0602de6l9KxgRm2+Pk/d8bI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Ij2vQusMe3Qdf3aQGCdCxhwJ91oiAMrxHvuW0Hf01GR9vIm58GZza4T/Fxsus3tW5
	 9LSt5X9tEMbTiVP0PZc0NYNLp7eVFWDYqmCpPUsk3t6QbJZnqDkGnKVjOX9hH5EJ5C
	 ewXRtZVxaSVue0hWMciN5QIEsJRr+Gcp3yQNQschm8UPbUFHURAzVDjGCQGI6TqVFf
	 2twdpVpwdSU8nIHb1eUeerg7/TCIr8UkmtRWzrwToKD+Q/W9m/lQAErzli5nF8Fs1q
	 Hox05J5TUex+YlwFDD1bLK3Elv7TzoxDoRokV3yEVKRz2Vm3ElPNuh50RK1mOIZjee
	 x05T4mrGi0EUw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3A66A4C631;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:54 +0800
Subject: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=1434;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=uwS4fBCD5iPVACjO21QQfl2NP0AqWyZwBPx9Plu/+9U=;
 b=2pyXTqy8HzStaaOCjTzObU1npNvY6ZTpilr+RXfXelh2BoV3pXDzkQDh7YtNKuBinOgbf7HIr
 Mou6SAdaUjTCLlAY7r+pWaP7/QlkLcjr09/iTRLHgrkUcRHYDfXKH4T
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: z1i5hnfhzy4b4ix8jiwtj3pnyw8x38r9
X-Rspamd-Queue-Id: B25321C000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795459992-886587
X-HE-Meta: U2FsdGVkX18A3uTydLm0N4yiCQuv0ILlerUttATdKLiavx7Wkv+B6REo7pNAUCAB0gTUxOxqOXxsJS8LdMT8NeVtOhAIc/UMbly+hgObAs/CUf2hOymykgEKvdW3aqgPZAtid3Szhg/bouXuuYgblVzfZIfNFkfSEcv+XxpUH/hUBG/pOeEipvXpE+RlWPt9pIvT5pciLRx0eN0P54BUV0xRzuWDghJ2GFKHnsn9iElFwg0BagSxUBOdGptm6kj1/ViV3WTSnLtXKl/7nTl2EtnKWGPeMN9aqD0r7fvVQPHnIUPD/gzSJRemoyfw/PQXBLlE7gFFbNxbwwDaehFobTTtN92wGZK0W2TeLIN3Ri+ahkM1L1n850vTB5JUQE1/eUlz88jCkrdil8bgFG3n/52NVRT6vdQ/MRnfZgDQJcF3AygD4kQH2kltjBpEvZy1SyiopHwEQIOMz23HxtL0/Nntm54/VL0dMT+f6tnuw9lXnLlJnMo1A12MGCq6/z7s833BY1U9z5QUaE7mfTy1OIqLlBkV2TUlAkNKty2wt0B7EThwlMyZWtbreLiZspa8RStZgPRBXkiPPNEaTWgmwBZO81Gb2RFYJdKF5BfZgTiqMELSlM7wf2x2nCrbviwadAFP9jQTZjUVQ2hB6xTN8jBh4D5JYrdNCwq34BLZSjyFK1avgVxrUZ+E9yLczSxjmlvrtbEIs6im8S/q1DvZblGaLimpG+AqC0OO4RcFVk24usY2Xlaem8W55WeLu2W1gv9r5FkqfE2nd1zlj+cARASZc9sdkidUvTGjCelsBKJR2Cc6YIxybuEz2I1JjEkxGafFefwDThx8fM3N/SOX3M0Lkz48KYpOFqFsXilfEwhitv3ExIcGh5/kf0KvFk/ofeLsGcmGoeNqx1cOC7CLioKqmfZVIcAmLloUkDWg+6zPl61JGVO9ewJK+AA9W7ioV+8mGCX/NHcHrdRS9eg
 JcWW/kpO
 xLNkX9P1EnD4XudzaPVlFGaUT5XUxPn0Hi3x+iBIhoksNlrAwvh3DdRGmAdEJ+hJRQE350komb3C/0bl7oh+DKU8i7TQ3+bPZIfPGuQvas8Ocnt7XRKmdkqkwA27/L9noNYO8vF9RrFNtX2GkCSgeH4kl1XoZvQ1Had2VYr3UISo4tFABHdPxkdrXEQJRliPEJ/o269vLqklqFXa8Om4SdVu5SHf590nFlKjaVRWmHy6nvdc7x6qAfJOUwOMcp+MaCpieGAuZ84LOS+crho/t4G5UylCZ30zEmRmEd94hyRSMAlap2BhSYudUL8EcI0Pw1n3fQq61y9yVcMDvx/ekzZqlQPyCC1lUOaziBUGg6tnmjJ/K9VnoJumWgNNyjJeqoipOTwfQuvcxttlX/Wyu5XTiicgZDFxQZGXLkohCMIMvHArtBsVs1Ore4gl+WpUVYuQCIbw6y6/Fv9PY5BZYXwZaBZElJ8bBQliO2PRjjvPWx25wVnXLWRWp2dGl2aDIanhJqy8fKnWLL6rgcmv65rx8g+oFpcLtu5QA5s22fkm/DOCoe6PyIMWwgBhBF2yEYxwPTnDNt+KXsLrpgRqOqXI9ebNRNBRgW4ZF0SMZHzG60E3wivQu9isaMErjVQJxbCaSFzMItvpA5u/peOBvoCIsAr4IaZ0f3NOAg0Eko2Tgv8TcQeNEzFDXBIhLsEuAKbwT/7G+B6IgAysfhvGw2XMYC8XnGrbl5SexdnHJLYj/ThnAVdtelv2AXqnjcvnbppMEARUHmFWNITJEGNeT7d7y6PmRfLqcNiqqjle+8J8fyK0MypCATdVSSzOsno5j4FXHnlYf0LnRDFredTBSFNVXzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

To enable moving file pages in folio_mark_accessed directly and lazily
for MGLRU, allow updating the LRU statistic atomically without holding a
lock. It may cause temporary counter underflow, which should be fine as
the counter is eventually consistent and only serves as an estimate.

Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 2395ca8ee305..2edb9beef6d3 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
 	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
-	__mod_zone_page_state(&pgdat->node_zones[zid],
-				NR_ZONE_LRU_BASE + lru, nr_pages);
+	mod_zone_page_state(&pgdat->node_zones[zid],
+			    NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 
 static __always_inline void update_lru_size(struct lruvec *lruvec,

-- 
2.56.1



