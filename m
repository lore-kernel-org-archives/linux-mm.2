Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0504D4A608
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 06:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C1F6B0088; Fri, 16 Jan 2026 01:26:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF436B0089; Fri, 16 Jan 2026 01:26:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D20B6B008A; Fri, 16 Jan 2026 01:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B73B6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:26:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27FE61BD37
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:26:20 +0000 (UTC)
X-FDA: 84336842520.05.F725623
Received: from mailgw01.mediatek.com (mailgw01.mediatek.com [216.200.240.184])
	by imf21.hostedemail.com (Postfix) with ESMTP id 455EC1C0002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:26:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=i5OppwCC;
	dmarc=pass (policy=quarantine) header.from=mediatek.com;
	spf=pass (imf21.hostedemail.com: domain of robin.kuo@mediatek.com designates 216.200.240.184 as permitted sender) smtp.mailfrom=robin.kuo@mediatek.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768544778; a=rsa-sha256;
	cv=none;
	b=iPUPFxM+pMsVx+bdDymoKfJqLrRzBGJR8FeISVONz818MxmFtwvUo1aa4DG8Hj697QcOYj
	PJpqeW6F3iiPgyiL/zdhTimcmyz+mw+tRMEtpeiokstYZ8LAnaUyN9YTKodGD0e3qbUTsq
	qMvB+Hi9M8vrRAzjQjWLGY+R2zKrK/Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=i5OppwCC;
	dmarc=pass (policy=quarantine) header.from=mediatek.com;
	spf=pass (imf21.hostedemail.com: domain of robin.kuo@mediatek.com designates 216.200.240.184 as permitted sender) smtp.mailfrom=robin.kuo@mediatek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768544778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89kM6DqaNI0SVDHAhqFeo0gmvjmHcOVivNaMRoE3IB8=;
	b=cgh3Vutr8be6HCCdobs/VgKDEiAxZlj1gi5vY4xjL2/qCymjfOkaDPuayIs+58Z5AUpclO
	EUP7X44I2YWxZ0P2+q8uw1dUwskOBR1Rtxx8+8oTJRD14B7GDA8QzNcUCH7x/QtaPJ15Xd
	QO16gxb97W9quxUZ1Lh/nWlicHqn0J4=
X-UUID: 3fc7d058f2a411f09f706fa2197c6ceb-20260115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=89kM6DqaNI0SVDHAhqFeo0gmvjmHcOVivNaMRoE3IB8=;
	b=i5OppwCCpw8PFG1ly/ec7lDbQ9u2hFI36lndZ1hg5wkbMZjJpLAgZ9LKMoyCCMAxCPue5Hxp41X7RH7mh7eDyXtpzB0qOcY+4+3hzU5AB+1ytbbJpY/ZGOUVVRXxR5hPzZZXKIG+JoLLHgz/l14ljMJci+2962MH2ysq3sQiG4g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:39710277-9d49-4516-aaf8-b09c85e2cd58,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:4b8c94e8-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3fc7d058f2a411f09f706fa2197c6ceb-20260115
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <robin.kuo@mediatek.com>)
	(musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1546757166; Thu, 15 Jan 2026 23:26:10 -0700
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 14:26:07 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 14:26:07 +0800
From: <robin.kuo@mediatek.com>
To: <robin.kuo@mediatek.com>, <akpm@linux-foundation.org>, <ryncsn@gmail.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
	<bhe@redhat.com>, Barry Song <baohua@kernel.org>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: <wsd_upstream@mediatek.com>, <casper.li@mediatek.com>,
	<chinwen.chang@mediatek.com>, <Andrew.Yang@mediatek.com>,
	<Qun-wei.Lin@mediatek.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>
Subject: [PATCH v2 1/1] mm, swap: Restore swap_space attr aviod krn panic
Date: Fri, 16 Jan 2026 14:25:00 +0800
Message-ID: <20260116062535.306453-2-robin.kuo@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260116062535.306453-1-robin.kuo@mediatek.com>
References: <CAMgjq7Db38sNdsGe121oBFshiJz+vUrKWf5BjB3djAYUr40LLA@mail.gmail.com>
 <20260116062535.306453-1-robin.kuo@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Rspamd-Queue-Id: 455EC1C0002
X-Rspamd-Server: rspam06
X-Stat-Signature: w7bt5aehken9muwqz9zddxwumgrwppnn
X-Rspam-User: 
X-HE-Tag: 1768544777-88356
X-HE-Meta: U2FsdGVkX18ek4uN/EmvV6SKHGOVnEviHY6146uGLkuEcn0xXAWSWBL7QBgae/dObbT3y1NIF7r36XQJYUc3wO/OK//Dyed/rC2wQRyse7UGcdlLsUO91doWh0qpHSQN4+vhg1ffQRvtUA++ezR9HX8MyjKQm3y76JjWZr7/XH3sRUINWacvw2yMOFkZLlNtEiwA1YQ97N+e75+L/BxnpOIkzJmZ1qWOzXLsXOKUlrA7PuK/tEYUp7UIhGQGf43+o/RmHLIjWIbY7Xoqf8PKlkaXvi6VkgsMgxPseni1fqEl+KiWYnAccXSVXRNDHVZXxEHn1XXPlzTEnLx6tBi7dKJaO7otkQJGx/bHHV5jkbURMXv3YE+2DYxbqfHIfqJuOE36skxvsmNvFRwpysG5ZtKS5GaZG0jTEy+cGIH7YoDAebKURRyzQn/F1aM4P7GBtKovSCi00P/LvasEOEPTHZRal0zNeqx9dvYqk6eO7BER0rBWfrpNHsKTNB/1jT5la8opbun3NBx3IGtbDRQLbucIIw+/pLOdQSAtDGQnRcNFASwNu/llsRwpiBTY8WUp3WOpbRNdxlDGV79j1sSBCNOvn1Um4n3rXYGi3nIg/Z8BdUQcYUYeOL+cF6qj+djcOzW8o2YhLkhWKK1TQdlN83P69dZG2yRlsPuWDoxEX6DdOuJUMOhf176w9wx/1Zw9wu6ocQZg3KmxncML8lZor+luW1BCS3mW1PFxJoXFDvYoSZBQuPMa59If6Ef+8Aft1j3Dsjzdece5vp+ZglUPZ+Vp7D0UxIwoD4Ic2pksJbj7KLpJUNUpa+p0ogtPVEfgfoFPuaDVSW9ChdGbgJvx8eCf/52IymgGyD4VibOJY0FQ5K64GGZJ0evDPQyBKRSsO5797xomWmxWB7Y1OUKFbHdewT8Yo/Utew9JL4jJ5yOF8fcyWNG/ZVaBERLMbiOGD6sUYbwZber+z7hx5DY
 z9dfILtV
 /3XJjnnEDWrZCqgV/1QbTcpGEzP4+LZ4WFJ0r7Zi3MgMdPAIFEW17RQHDVNsWaYKceOkIrzDO+9O2jge2O/jxtBausfKR+ZUjcsgo2ZwWD1WCtp9MaoWh6DLgjCc/hCmuHIJS8BGyg4WagHdS2E6P/x9FEEVjK+64exKU9DZLmiPmXx5ZXheEzRcpYDn7GgwPDb7AIAj3PG93rxf7Ds8UIeAa3rZsOFjUH3HDADAQfu7DZWWcCAlQ76xeZn+tOv662729eCzDVAXgnYaNeYlPYv/ElXQEZmF1N1KXI1YZusmLCED4HgRIQMmjgjTY7U+SmXh4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "robin.kuo" <robin.kuo@mediatek.com>

commit 8b47299a411a ("mm, swap: mark swap address space ro and add
context debug check") made the swap address space read-only.
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


