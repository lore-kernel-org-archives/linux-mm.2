Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6893060A2620
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNFiylac
Received: by kanga.kvack.org (Postfix)
	id 0CFF46B05B8; Wed, 18 Nov 2026 16:03:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030FB6B05BB; Wed, 18 Nov 2026 16:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E137E6B05B9; Wed, 18 Nov 2026 16:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6ACF6B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:03:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C26712084A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:50 +0000 (UTC)
X-FDA: 85449466620.17.0971F03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 237E7A000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNFiylac;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035828;
	b=TCeBT8BT7PVX92jA0mF1iiDEskZMZyV9kp4Rqyqxp1HWSJ8aKJyWxGKDHGZFEKDEvSDSIh
	2qWQQ5EMHd7C51I1RKBAJA5sW8S6B6XqN6Sq6taGy7qpcnGEHHOx89XXn1mOW3BPPryrbH
	Vtyxw3sE99JjN/cGx37Gtt7DB4mKpfg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rn/XVV3lJb0TjTij3sIrE+aEoTpSeaOajKlzbk7waNE=;
	b=XrYYG0fpS5CFJSBNKEvD/cnRIdA3aM8MiPD5xtdJcKWmrNCFIVXyA7FVVSvjD11NkV7Zjs
	VEsFeqZtuBHjUnz/WdSU29ywlMtMxIRUbtGAHAS+ovrcaahnoErwaQ1essQAlGjQ5RW6tH
	VBQ+6rik7Owcfh5MyBDEppMM/6y78IY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNFiylac;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BAEE46279;
	Wed, 18 Nov 2026 21:03:46 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035826;
	b=kAyAj9/z9S/tvn/7BDj7BaFbfqFE0Q+yZfVthcSaASNv9gRE7oVCw8uV/2snc0IcCxUc
	 5z4jH7Xi5THxKX1qmGQljO6CQLZ14kfURe9h2rG8c9Re2J2f6o4Jl9S98IaTFeFm9Hl8s
	 nFlrCgxQ6lwC/whBX3YoX3M4GU0S5S3BvzzHt4Kr4ZGIvmd6H8h8KHY3QXp+PC4vh+ZKK
	 tY8/bidpQHl/ZklAK3s1jwoVT7o/xXkX9nAVw+Dt4eWfphaVf+8PKbkiQ/eblW5Cx2FJQ
	 gAJfXYI8eFAu5cCdEbdMF8PsHADls+x83oWGmmj4sUJfolISt8sXmCeOoqxfJZfJ71A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Rn/XVV3lJb0TjTij3sIrE+aEoTpSeaOajKlzbk7waNE=;
	b=VDrZaYbNNIx5DFYtpkwfkKGSNAkiHoi3ei0oYIVJZifr7tOnAPpzNVqdSGaSnEaBZwDZ
	 dKGE/7AthiLX74VEHsP5s2xkZjniqdPyGEpznTbM5Dy34Q8xeQ4NeAuVej1JxKy2BaHb6
	 0c84TxC1ZNH8xaDkfqdJ6bTQA0RaHpBVnxuOWRojfBDhXhwnp+eFtFfR4nw37fbI4WZ1b
	 OLGEC8u6FTXefAk6t/Ek1zTTx02QKufC8XTo67BX/d3J75AgdDs4eQoiwkrrUqPyu+z5r
	 fm3F7BBFIRLvV1SRz76/nQSOz4DV7WKdkoY/elE8DsfgGdps5bJuaNsu4B2yBmIqYuw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BFE6E1F000D2;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035826;
	bh=Rn/XVV3lJb0TjTij3sIrE+aEoTpSeaOajKlzbk7waNE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=hNFiylacSDkpUO63Z7zELJ42BPJJG6YKdeQb2U+m20Y47uham6njZowSJNic2f+hE
	 PdDwQfVkBxwJDHHNG4i9tL9jYuWjLU1krdGIa0VY5DQaVgA2RVrbh0Rvk234L5+upA
	 M/oa0DWUs8hnFgIaIwVQesv0NjBhj12X8+2zui7EUrhV0+oVdiCO5e087ZJ3lqa74b
	 Od+rPd/bgctjHbe4K9JtXV1ioNIioxqeYR0cXb0Ahg2sqEVeW1G3KBtKumdDiD/nKK
	 OBPF34uvE4dyAVgCJidL1eMZndzNK388I534WFEPpHwsWq/cv3iXamsypaqET7jDGC
	 gmKkOydZVt4fA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 44A1D4AF8C;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:34 +0800
Subject: [PATCH v5 02/17] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=1182;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=G0nnA5K3vgx6DnvgX5PBKRNHiMmd0ZDMM0I+7unVnUs=;
 b=Or384oTYmhezGr12VgUCqXcg3RIjHRi1VIREbML7u8xdTtJvzi8P8v1XYtrkZ/MyxcN22pjLV
 ZU7Emfb4fcGBc4PgU9uzX0rG1VNuzCTFopsvPnTDBNOyD35qOIS9jAr
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 237E7A000E
X-Rspam-User:
X-Stat-Signature: kgc85wp3wo3r9qbtpqfm81ig7kak3prs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795035827-72045
X-HE-Meta: U2FsdGVkX19pRaMeQxrogIzuxJEVZ18YoRYLSY1hWyN0nuYoVM4buCL6Pn9XBIz+qOCozgsTIWuV4kfymHOIWi2SLkoRWEA5uVhZyBDLiJP7kkS9aB7r94f68oiz5CRKqxUMMO8QWOPubtUiKIN+kv3oGfWOGUEAth8+Bxp/dPDi0sYiGoDtEXo8mO4JY0dqIShRRSaXVKQovEsqz1o2tOHCW8XBdOD9JoTicBtLRC7v5wR8Up8Zpu14smplhgHrU5OO8q2TFmdV0L57F2o359H/AgqE8EknavjQgXA6aMjM/vXgRkCHpdRn3w/iSpTyi9A+/fnHU9nDRhtRHxaGhQifiHSaU5rtg3yUm9ZjXqPun0mNCQkHhwH7KQD+6DftjP+maUssiTQD/1QeCGOWpkZ0G9deJLM/p8xgGyn9EffM+7l4OsgtiKXiLxykCPmAIM+a5ORXOwcfT2k18kF++OnCKMHoTQsHQQ9ZNMsD44FkRVBr3K18ujiu6wKjH4j2vx/C11xZR/LpLRq7BCo5wUHK61cPr+Ng20yeTzAHFgDLuHI57z7QtRny5uNRt/AwdFd4Pz8n3D3sB+L0riRr8fEE1GgP0NospGK6ObVOtNh2sbe9P7RXDdxFERwPEObhO7h3KrJBgdP5gC5WSVwAFzRPatMqamPa+T7fjQus0wqpT50isgmRnuwl3QrWRdPF328Ri9YIK+SN1AnzLhPh829WKsBxinQvB8yQUELAY76AHfosessMwzKryF7d5GRFYIzZL5WYNQY57Mlw0dusHoIXFZjdMbtB+0xPSGJRpuwhgd+t6ZOKWCE8EPJ/EI31Mj/GBcaSN08K98tAbU1/hMZiEm0AGAG++TRYss6Ra4Df31TPjVHjEHr7bIZa+03kWw88l7ttJPYGYOHnKUNtzHdpbV70wCQKM8+1+aZM4MamWe9OP2RIy9hfycxRi0GE0vG3F0PtdZOseRapE64
 RY7o385d
 PW1JROONuZGPCXVh22RqwGI8b5n/KyQ1dB5oI3I8wqGWVdk7+A+kuuI36aCsjjdWDCcsT+AsXEAfAUo8A6CoWIgMTQToU0XQxAfSOMI5nXVxyjL5PnXmmLyVb/2yO11KffMI57aYzDmbFUT1HsRzmz/G9/22YdAyoRo+1Ba03Lhl7FXDbAkOFnqqIG1ZGeZEWGk5vxqm5eHJ1s/eIN1pir9SO0QTMeuTwSsiJ35znndNr85P44NDRc14h8zkFGqL2OkXprUGvXVYMFjv+lCAdDgV9wCuukHCs6Onq//b1M2omz08td6YTfxSzlhe0+Y7KV/bWe2NjyeELlg0jIemMk4iQ8cfbJyQf18pzgKO/vMpTVUJXrjxkIf3x03Apo0zKxPhg6Kia9J+fs1Sui7w7RTTJ2wIS24eSNScoflPFeb5iRLQkex/huXf/3TyfnzyWrzR6JYuDpngKO6awSbX2X95KkSJWqb8RwKmDpCDan2fMC8ZwVuD/42/2/I9TWOR1PfzdGgDqCKRo4dQCUd2vRCoHM++6MGUat2pOapbWCMnhkmNZNpwrX5DsxHhijhJ9h+1XYFI7ax4tTXABLUuc6bfKuEbIgCABh2KnSLagQsc8uzXRUL6QTtoc2nOyXcN51ZpuVAqmR+Vj72SKDWHVsfPG3vC4W/v5l8Yb
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



