Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D62606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D3lo9h+g
Received: by kanga.kvack.org (Postfix)
	id ABAE96B05C3; Wed, 18 Nov 2026 16:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B766B05C4; Wed, 18 Nov 2026 16:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959C46B05C5; Wed, 18 Nov 2026 16:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6C36B05C3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:04:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A47DA1603F1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:59 +0000 (UTC)
X-FDA: 85449466998.17.991F814
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7F3CC40011
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3lo9h+g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzxS8FucW3HiaXjFt3oHPV/7/cOrPnUfOI6umwv44A8=;
	b=dUP69F8TYzyku2GH975xXjhRASqqiAbSIteZK7iMz9Wll2E3UQVbeRKOjCtmgOxcsQuH5H
	fV8lvbpfS49sAIZbiLWmI/wFp653yl2IE0qKuQfw5ifpGtcrY0t29EjujCGvabvftjfrOl
	j9n0d0VfNfemvmgn93oJnj63v5fgGj4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3lo9h+g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035837;
	b=MsqLsPH3R0fvoPHOz5QoTZvKnzx+pqtyLCaxfnNNVHDyYlB02EaNgdXOKu9wDVqlj8BFXJ
	op6KGA6cW8DA34xmSovXSlk0UERKT98QTQrNV9fKmpTSo5hpN4ZhRGltFgL9JMO8ZxV473
	+XJaWqRI4/9SQCVJD+1oxAoy8rZPNO8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE5CE475AB;
	Wed, 18 Nov 2026 21:03:56 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035836;
	b=uh+xdzm07rqzRQ3Ja2W6WHwX0sOidRrC4gDFML+SknfQZKf0u1Um2HSppEZL/lz40sS7
	 X2qj3Bc9/WhDQqLI4l/lQMNbGEYDM/V1PvOmVx8EylE7BgTyrjXR770eNp4FgTXFA4Gq7
	 /70mCINeDhLKA86ei52OqR9sp69htmsG9qjevBfy6u/0hf8FxcOBsP2XhAr5GcPuUUztp
	 7IYp8WRWoB1ATIUM1cxCjP6oAEC8XCafOuEJQBLzXgPkAV+ZwQ08YIVmltMVCD9dlXtr2
	 Z/3irkzsm1LqQOG5lZpNBotm+Wn5NQQKhk6ozML51TsTC5BepjwUdt7rl3n3CwO30eA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035836;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OzxS8FucW3HiaXjFt3oHPV/7/cOrPnUfOI6umwv44A8=;
	b=axJF7Oo0N50wKMFvs0myxDJZzH0HhX5LUroBUTcQ/8eUwcrnSmk4wsnBdb//TI1ucIU0
	 v4aRWapU4v5SIDlCPrzQI9XakW/71MOIzFjd0bLIW4MNdnYzjZeJ49Qga6Bp1ayquMS15
	 WsJMp9A3NckBNvAQzonOryRJk/qVj83W0v+E9VGmDiCUdb2CKphw0wEzdvJiQQ32mKi7H
	 Jr6QN3xMLwWxoeE/O+ekM4hYdUQl7Hltt/5R5pbibnESph02YIYkc+rsgDqCg9/NNmXB/
	 39v7aHY0sW8pIo2ZTiT8sHPktcjRDzVMvZAoKSXTEE97AkhB7HCHN2mTCC6kSr+I+sw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BCB4A1F000CF;
	Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035836;
	bh=OzxS8FucW3HiaXjFt3oHPV/7/cOrPnUfOI6umwv44A8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=D3lo9h+gigqV3OulDUq27LKMkLt6nSjTbaVo2FxfQ/xK0hdn3RlotwC0ngw/LM9rn
	 8hA6UeaLi7c9m58rb87FOsp4UdJ2AP5RHcTNeY2YR5+dqdWfGHH6243V2zuSqPeKtv
	 8/zNvgyc7nRyGxlh2qyBbzXXHF0b133NONr6KbKrf2Tf8jBrEzEM7oadh16YY4XYy+
	 kSvm27BAy3ukpGOdmqpqKBvrRk901GbQhUgIpPGCo93G/1G8v1fZuDWZET7D6XSzmw
	 aC8cpwT8Fpbdbw7hKXhq/zMuPWe3i6xJUHAdXRRnlYRmm7t+c6i6LijQc8IQ0Eo/Qs
	 1kFD3fMq3y4vw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 53A354AFB4;
	Wed, 18 Nov 2026 21:03:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:44 +0800
Subject: [PATCH v5 12/17] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-12-9eee2fe97a2d@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035820; l=1308;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=GSfbPNgLMnXCEtSfL4kSp4PCNV1ejnHpWoKv9fS/jaE=;
 b=fzCjWB4x5yy6GmzZuPiQKuZftrRJcednIvgNY0u6IIjiMANZVD50MXigQUOLXSTn1Tj0Ir4M5
 KAHzmaqS4cFBX+0o23LoWpkoJV6E899oz/mVRQoPRYaHozTcuf+K8pv
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hjnuo8yudhtt3364bmz8rf8qh8wjnm3a
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F3CC40011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795035837-629990
X-HE-Meta: U2FsdGVkX1+l5D7l20OSAGlR+EO9ks3X/WvCAmXP0LETRNBGb5RDb7+hozxnOD6gs4wB9yDxJ/bSdjW/FPptBVW6itgbqCHJsvJP0H2x6FysiZMWs8exlRaqpm/HWPOHV4d1POZOqwKJJmD/0u0rpvhcA7MWHtjGCsmunKilPtNGsF++SMFsLD9mvJSKilbCxHj+YZHwhJ2dtI9PTlsjlFdV5w35P6Xm+YPl7LeZ3RIrZrcJMFnZwcwHOvBySUDl4xW9GwiaMo+HWLWrNFk9hSwU55aZjQNDqzko6ZecDnQvGRTC/7aWRoCnyuEgzhCLfAw6EPUPnEfppKq4wxlETgRYD+utmq1mJLwOoKtwJXARyvzt+DH1fBLTRBTcVDGuiO1fqu9hBO43+zCVNnolj7gbNbxpJrIdm/fYdCB7U3eF5PMD5ZciGFypsB3fxkUV3X5JT7vg2jdtZYvuzWY6asEHNUtp3Uj0uNGdcUSx6VfEfYgsdlUP7/GgcVc3k6Hp7g9FeKhUQJyYMG9N6wDt7+jfzD/p5tl6gM9kpTH9BNl4OalUqsDdgMkHAGy3j0IiLisA2AznuMley1+REtvoZChcMFSCfSx0kp8uURdpAbj7VCpqbk+GPFhhFsba6Wz5aDXi3OSNPu6pQvrPUI1K9c77XKSKmag2WALRuhF7lfTzetfsdd3eNBX4qMwmNkLSgtiiM51UI7yO5jo3l8mIDrBjHEg0FDgSVAArFTCD+7lI0dAnw4SYPEWecxYs6d2MFWpUOhE/qebKvL1/PAJ8gW6pGnIy72boFLZibYHb3q81+UQHHxyL09w4tpRhakMQGsfKnrWPFIoBqYu7urkDwBJjCMmUgQ1x4YaQC5K2/BYyo1tulWCJfVPnxYBr+VNww8C+UU/QkRoYNqgwF17/vPR1FJmEVBXnThk2eqX1yOEudWKSyFFpyKvxsEgCc2zZyFrI/MI9KH5Qk2BAX+E
 FKV3RAWt
 aT3k9LW1J6KzmvtKGUaetE+ihIsQVBIoyRcPbrlTj26B83Gs+IuZ4eKGwFBauV8azGikFgZgsTcuzri36uOQuuoFIqiNR14CcyBkaGYFoUHOfZVwVzht07Z3E6MoKV4iwL3orL3PslUc8Ku7JAmXsYSXbkV30ez6R2CDTxXpgFKt0+re8fgXo1cvEvefjDx8CrbYKiZvzyoITkxjGHZzE8j+IKjTTublZYv4C/90GQS9Tf7e9yFZErM9/EeqBrArtlQ0k7fe32O5KRIEP5V3ASoAkwypyKXtrdsaqbDCuuPsEQNTs5OcRwr8MAecpAvKjX/hwuT2Bn+YhrxA1HNhD6uF1E01DJlsZA9WjBBkNEuwx/cUsF/17IVs05rnFzLWMztRYbF/5Sh9fLJeN/YB4Xg7xLtFLxONOTY80PmCGlYJECEDHGoM2feA6wd/pqD6STwgGJrv7zzXsCaXDho5rso6gdD4hwX7Pfjhs3MEwyIKIFb+FXXMHGqez9djqt6hKKhjhuVWiBqLgqxkhdLPk1jI4eKDgSSPb2H2HORY6a64qm2UwpbwoPvBUzZZ9+C6sr+vB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
count, so folios with nonzero even refs no longer have the bit set.
folio_pte_referenced() testing the raw bit misses hot folios at
refs 2, 4 or 6, under-counting the referenced folios of a candidate range
and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.

Test the refs count directly when MGLRU is enabled, mirroring the
smaps conversion.  The classical LRU keeps the plain bit test.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4bbe319ef86f..68f7a30e36be 100644
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
2.56.1



