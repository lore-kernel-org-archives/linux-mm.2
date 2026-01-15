Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7644D3CC8B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 00:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C786B0005; Wed, 14 Jan 2026 19:14:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09776B0089; Wed, 14 Jan 2026 19:14:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08DA6B008A; Wed, 14 Jan 2026 19:14:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9EF6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:14:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F45014015E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:14:26 +0000 (UTC)
X-FDA: 84332276532.02.073469D
Received: from mailgw02.mediatek.com (mailgw02.mediatek.com [216.200.240.185])
	by imf02.hostedemail.com (Postfix) with ESMTP id 32FF180002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:14:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=Nn0FNCwH;
	spf=pass (imf02.hostedemail.com: domain of robin.kuo@mediatek.com designates 216.200.240.185 as permitted sender) smtp.mailfrom=robin.kuo@mediatek.com;
	dmarc=pass (policy=quarantine) header.from=mediatek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768436064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C2EzlVROqB2WDA6Pfe0fjYxuGy8i+tTBtHgwz97po6Q=;
	b=vGHQcg3m7qnqN7vrHv515PQsf/hYb+57Hq6bXprE2VekqGEf/Hiez422f+pBloGuayoY5f
	7f8EHp6rmGhntUHUNeu5W+8dePVnMSffvLtjA9kEZT/wYchxNDJ8pJ5YYmRw3z+MpQG4Qt
	UAh/ov2b03hQnFvS8ALjcfoojxS43zE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=Nn0FNCwH;
	spf=pass (imf02.hostedemail.com: domain of robin.kuo@mediatek.com designates 216.200.240.185 as permitted sender) smtp.mailfrom=robin.kuo@mediatek.com;
	dmarc=pass (policy=quarantine) header.from=mediatek.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768436064; a=rsa-sha256;
	cv=none;
	b=S1dokY266B09BW5YurXqKGjEMteiRY2epjBJi1dxR/cs2btEh6RWu1ACGOzRl8iyOmXW0i
	YHaR7mLw1t5tcK6RNx94359DbBVvwmNYB0dJQ3gQG586Altr9PpZoVwbEagLtlX3h4iMEH
	WGm41RNFHHT8X4tL91fDHccN1jLfKh0=
X-UUID: 225394baf1a711f08b17dd397dc63300-20260114
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=C2EzlVROqB2WDA6Pfe0fjYxuGy8i+tTBtHgwz97po6Q=;
	b=Nn0FNCwHPIVkg7NjqU5uE28QJEb5jHxVFvvycJfwYSnCK/K/4ezcxzqGtArdt8KW2Uhfq4oaAHjKfvdPpy2fJKUW4634zRo6TL+2hatWduPRJr9+NY6W5USxU27r7Vosanwm5iukxBgjsM4kfG01udRtwSx74NwMYSE4k83NzR0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:34ab7bb1-5998-4531-9740-8110a6c747b5,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:f05285e8-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 225394baf1a711f08b17dd397dc63300-20260114
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <robin.kuo@mediatek.com>)
	(musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 856363866; Wed, 14 Jan 2026 17:14:18 -0700
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 08:14:15 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 08:14:15 +0800
From: <robin.kuo@mediatek.com>
To: <robin.kuo@mediatek.com>, Andrew Morton <akpm@linux-foundation.org>, Chris
 Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
	<bhe@redhat.com>, Barry Song <baohua@kernel.org>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: <wsd_upstream@mediatek.com>, <casper.li@mediatek.com>,
	<chinwen.chang@mediatek.com>, <Andrew.Yang@mediatek.com>,
	<Qun-wei.Lin@mediatek.com>, <oliver.sang@intel.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>
Subject: [PATCH 1/1] Restore swap_space attr aviod krn panic
Date: Thu, 15 Jan 2026 08:13:43 +0800
Message-ID: <20260115001405.3513440-1-robin.kuo@mediatek.com>
X-Mailer: git-send-email 2.45.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Rspamd-Queue-Id: 32FF180002
X-Stat-Signature: pqu8tw3zdnu48h3fg64af8qojwf6c9km
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768436063-453220
X-HE-Meta: U2FsdGVkX19UQaE+t4w0nls+Go0gLsRMtBaU3Lv+hF1h19XbXbcByu1rDzJKvyIEUWdzBPj/VB+LyvhQNNopckRGji1JMZBHUhfEIOQn+o7Ul0H4Bt3qrE8TAJnk3HrpQIXUu2S539CKY72RuIPnHyrURyhfVTP4E3I/XaLh5XT2JRaszpk3GYPHzomSGT8Z3V82/fMDc8PbpKTuqXYXPReF8n26I3A8bQW+THR2699gzsVrlcOERyFBBqNIwLK5fA2xekR64bfIUxBNBV2IkDe4GAVaqC0TeAI0Jftc6G0qL/HN6MoaGIZezunS69biDHBQasirBs0uTn56ueJGPkSlZGhIw+YFIauatSGhRP8PtDEk+yTrm13nxSglzWU/eG4WV+UKi0Np7xJLFR+PQrwgrwS4QIeYiOraz1YXhoXadebaU6r4CzNxRaMTsgeXyQmGrEv7A9QELca0qGSl3J/JDm7kXZeg96aOCHLMUSW5dnkDGCuAavbQhAU8omL06K/tJTqTaYSdjEOGSCe4QIjAbX+5A8CNP4tIoTw1VBHkQymSCmo1PxnV04EAdZPUsAlepFl8o9sxFiWuH3w2TwIR9NPEJglmVNsxeYhCs+kQeWWEeyg5Go4hPAk0HZWNZe2HT6lbF0fQi9POej+NTtvvevsSO1KfcdY1J6Pj8k5s71ckso+dbaPGczEnpILgrJSn46Ea59XXvW7mJ7OIL9JOga+vexmYCP1f8brdrv6rYpsgkZFTHwVesGZHSahYjqHUiYWFobVc9VSud+rxdK23YLrWJuiiBbxYHLFJb2UWq/8+Yc0e6yB6SqBTqTIP5GDJ6lYnNQ9jq72OJRsGPh+hn9ytJfNagAHixim6cSvVJNZQOtBaRo2daRZwgmSHk/xtxqE1Xt0EVrr+7aSlKLvs9Ok0oU9u3dWULUFLm3zJyQCOXBFp/xKbjpB+HBvp0cu1kkSWpUJV/Bt81X7
 bBpFxFSc
 GrPaRA5zD0TCxXif7nTlmszdF9LjjzkcXzJRKbThACgGAOmfkQ1fIQKP8jSdmPM6roY8A+ZbhVYPel3Kn/eTneyCkdxJ01GD5xLQRJkZgxXWT6MWJSw+t+nr7ZlV4AaMbRJHsQhpjBMn59zQRBc7CF4AHoXVzVYsJmCCoNJAggfT8ddrOGn/oo4eafd6oH0Z/vN3dNtd1lfkaB2pwj7JUmnor6JHqgtxOcLXS/N8Flkv/tb0EdFvc3Tm5FGl0uI9HnCXevIgrHw3aPk68yrfgfrw8TrbvpTWCBVDq6/biV2EjAGA+oX3/kYvhw8lShRdnhdwq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "robin.kuo" <robin.kuo@mediatek.com>

Restore swap_space attr avoid krn panic

Commit 8b47299a411a ('mm, swap: mark swap address space ro and add
context debug check') made the swap address space read-only.
It may lead to kernel panic if arch_prepare_to_swap returns a failure 
under heavy memory pressure as follows,

el1_abort+0x40/0x64
el1h_64_sync_handler+0x48/0xcc
el1h_64_sync+0x84/0x88
errseq_set+0x4c/0xb8 (P)
__filemap_set_wb_err+0x20/0xd0
shrink_folio_list+0xc20/0x11cc
evict_folios+0x1520/0x1be4
try_to_shrink_lruvec+0x27c/0x3dc
shrink_one+0x9c/0x228
shrink_node+0xb3c/0xeac
do_try_to_free_pages+0x170/0x4f0
try_to_free_pages+0x334/0x534
__alloc_pages_direct_reclaim+0x90/0x158
__alloc_pages_slowpath+0x334/0x588
__alloc_frozen_pages_noprof+0x224/0x2fc
__folio_alloc_noprof+0x14/0x64
vma_alloc_zeroed_movable_folio+0x34/0x44
do_pte_missing+0xad4/0x1040
handle_mm_fault+0x4a4/0x790
do_page_fault+0x288/0x5f8
do_translation_fault+0x38/0x54
do_mem_abort+0x54/0xa8

Restore swap address space as not ro to avoid the panic.

Signed-off-by: robin.kuo <robin.kuo@mediatek.com>
---
 mm/swap.h       | 2 +-
 mm/swap_state.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d034c13d8dd2..1bd466da3039 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -198,7 +198,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
-extern struct address_space swap_space __ro_after_init;
+extern struct address_space swap_space __read_mostly;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5f97c6ae70a2..44d228982521 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -37,8 +37,7 @@ static const struct address_space_operations swap_aops = {
 #endif
 };
 
-/* Set swap_space as read only as swap cache is handled by swap table */
-struct address_space swap_space __ro_after_init = {
+struct address_space swap_space __read_mostly = {
 	.a_ops = &swap_aops,
 };
 
-- 
2.45.2


