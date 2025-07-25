Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F34C83F27
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 05:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E667E6B007B; Fri, 25 Jul 2025 01:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9316B0088; Fri, 25 Jul 2025 01:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7516B0089; Fri, 25 Jul 2025 01:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7EB26B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:16:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 539D9805FE
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:16:17 +0000 (UTC)
X-FDA: 83701625994.22.91F76C2
Received: from mailgw02.mediatek.com (mailgw02.mediatek.com [216.200.240.185])
	by imf28.hostedemail.com (Postfix) with ESMTP id 98603C0007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=Gff68kFJ;
	spf=pass (imf28.hostedemail.com: domain of akash.tyagi@mediatek.com designates 216.200.240.185 as permitted sender) smtp.mailfrom=akash.tyagi@mediatek.com;
	dmarc=pass (policy=quarantine) header.from=mediatek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753420575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46G8DD90VVrhpEQm7Mku51SwaoXM/jFS2E0FifwksX4=;
	b=3dHZe3lKE26o1WKBI3vbZra8rQgjanFEktjGJFnqP3Urz/aHafZ91oQB7y2MbSodJ+SRNT
	bIjCqnXHoBIIrCSObH83RwYFuGB8TRJsCJ1D+kufc6pWZr5O3YuJ7f0U+ysHbuc+6fk+A/
	EWWcJYpoURzuG5hpUj5j20NSAObTiAU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=Gff68kFJ;
	spf=pass (imf28.hostedemail.com: domain of akash.tyagi@mediatek.com designates 216.200.240.185 as permitted sender) smtp.mailfrom=akash.tyagi@mediatek.com;
	dmarc=pass (policy=quarantine) header.from=mediatek.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753420575; a=rsa-sha256;
	cv=none;
	b=e1OhRLuzojRK8V4C9uhCxNvxfjZDrbXMXJ42Pb0LWIEraZ30b6vc+3/dnQYtLvVM1QZKpm
	HG9f7+VVA3O944gV7Zjnv0x/vfhKB8PhidsOgq7miteRjfd5lQZqOPKbMgGq53OqufaGGc
	5SB4FPFLu7q5AZh9/IyzgPgjKOc73z8=
X-UUID: 780cd6ec691611f09eb0dd999d3936bf-20250724
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=46G8DD90VVrhpEQm7Mku51SwaoXM/jFS2E0FifwksX4=;
	b=Gff68kFJapmJYc1HJaAaIb2H6p55MIXAlkoUokMjyuvf2WMs1ies4gkkUfrr86bbec0LBCpNpdlSqzBvJbE+kLxlRm0Uo0vUITNoXU/rbePsr9jPGCS9XN74GSYgxPp7nTc6w1YazN7s6sSy99n4ZWZtkyMMWnpvfbGvcnYmWiM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:094aa427-1588-4db7-aaa4-c7e785b1e73a,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:cef9280f-6968-429c-a74d-a1cce2b698bd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102,TC:nil,Content:0|50,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 780cd6ec691611f09eb0dd999d3936bf-20250724
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <akash.tyagi@mediatek.com>)
	(musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 613910120; Thu, 24 Jul 2025 22:16:07 -0700
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 25 Jul 2025 13:16:04 +0800
Received: from mtisdccf01.mediatek.inc (10.18.1.155) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 25 Jul 2025 13:16:02 +0800
From: akash.tyagi <akash.tyagi@mediatek.com>
To: <david@redhat.com>
CC: <akash.tyagi@mediatek.com>, <akpm@linux-foundation.org>, <vbabka@suse.cz>,
	<matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
	<chinwen.chang@mediatek.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
Date: Fri, 25 Jul 2025 10:38:10 +0530
Message-ID: <20250725050810.1164957-1-akash.tyagi@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <67a54f31-e568-427a-8fc8-9791fd34e11b@redhat.com>
References: <67a54f31-e568-427a-8fc8-9791fd34e11b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 98603C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: piuuynp6trbnx38poi5rjnpoa7et6ohu
X-HE-Tag: 1753420574-333405
X-HE-Meta: U2FsdGVkX1/b2s66+0C5LxQKtp/hNeTAjZYp4LzWL8/kLdMmUHOkqvzpy7ec2gvLjoOz3JDQkAvFlj4no0pnWyu8KKSbRr1wKZ7Ka23kUid52mMcDN4cFH8F3uVspf2h7NLuSyI1OU2fUlal95cOiM5APzfewOXHTzniFVi37vxHJwqIMjJhawRGEUBfqR0NgwIanmregUtNjM8wkkiF3Htc1Tq2JUVxyi5+s30Ej7QuGuFE0aszGjXY8AUBMu49gFol6mghHrwJWVcL9Ld4cWzza7WVSNyOvda2LOPMYlu17FaUL3gC9u6PfWgHiVOvcZek9Z0JwELx9E5M1UZ+thYIsKV/drR9tLzrdHrNbWpyor5Z1enlMCGS6PU5qPL/hoT7qtf7WVuTPNL8a5pzCHg6rypRVnv6rsMayB1tYpWmkEKcPn9j8452iROC5pxLx54pF1xpv5lUp1Ve5SVGVjCfXHHt9bsL1wL4h904bpNZ3Y3cQzsP9mB+vgmST/JscMerFlu1/lhtnaGHA2bpamJn+dRcn33VGI2S6agpGIPa/2O3rX4nT3qoN/nxZ+XCRgSfMHUo8ZYe1xNXQRyHxmbyJ99Fz6cLDAiehipeUpaEupbgunfSjo+JgXKGFzNlx94SRbqVlEsa9z77YDofVyi4FbK+WbnD81qJkvS+UWv1cL6Idya7FijF7ld2PQuSEpGUgdZCCofcpCLxDuU1um3iO6B/rV8PPSQ7R9fJZmsrKF3pzKI8ee2TX7UseKiRgxN7+xz5vldpUDyu8kf+vSdAxPrkXftkQO2r8v/WhxVu2h4a+9cHAZZ32pbYWjmgUNjcXy+e9wK6fP5ZoETJ0eA/5Fiy+BDAqdYeKjhKzLyMxarX9UjnHwsze9ED6w79MXRaFdyigrXXme4JKKhqySePNZfifkZjwtyZ4IN+iNBoxm88NCKHsqSNiU2MG+weDpsV1hfCy/dCJ2m5Lds
 BILJR+oU
 9NDpo3tZZgLQJc4zFrLWEDauiIPH2QJoA40R6kkBEgPm33Dz6chpGOelAazLgni9kA8u+WK4RBLi2JivjnvP+eYFBw94xpDPQRzgTJ7H544g9pJwTEh4B18CC1r5EzTdxSL76Y6/6B1uCWLfhp8sICmra3wZZOuq5QC7vJH+qmLcMERjLmmHNI4aXwZldSmFZKJvmq02VqZsoB434E4vJQuF3l6lOWABdE4kqBIc5KGNlndt3FWX4d96+SRqrK7YPYLpT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thank you for your feedback.

We encountered this issue in the Android Common Kernel (version 6.12), which uses PCP lists for CMA pages.

page_owner trace-
Page allocated via order 9, mask 0x52dc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_ZERO), pid 1, tgid 1 (swapper/0), ts 1065952310 ns
PFN 0x23d200 type Unmovable Block 4585 type CMA Flags 0x4000000000000040(head|zone=1|kasantag=0x0)
 post_alloc_hook+0x228/0x230
 prep_new_page+0x28/0x148
 get_page_from_freelist+0x19d0/0x1a38
 __alloc_pages_noprof+0x1b0/0x440
 ___kmalloc_large_node+0xb4/0x1ec
 __kmalloc_large_node_noprof+0x2c/0xec
 __kmalloc_node_noprof+0x39c/0x548
 __kvmalloc_node_noprof+0xd8/0x18c
 nf_ct_alloc_hashtable+0x64/0x108
 nf_nat_init+0x3c/0xf8
 do_one_initcall+0x150/0x3c0
 do_initcall_level+0xa4/0x15c
 do_initcalls+0x70/0xc0
 do_basic_setup+0x1c/0x28
 kernel_init_freeable+0xcc/0x130
 kernel_init+0x20/0x1ac
 
This UNMOVABLE page was allocated from CMA, but it could not be migrated - so CMA alloc failed
At first, we fixed this by adding CMA THP pages to the movable THP PCP list.  
This fixed the issue of CMA pages being put in the wrong list, but now any movable allocation can use these CMA pages.

Later, we saw that a movable allocation used a CMA page and was pinned by __filemap_get_folio(). This page was pinned for too long, and eventually, CMA allocation failed

page_owner trace-
Page allocated via order 0, mask 0x140c48(GFP_NOFS|__GFP_COMP|__GFP_HARDWALL|__GFP_MOVABLE), pid 1198, tgid 1194 (ccci_mdinit), ts 17918751965 ns
PFN 0x207233 type Movable Block 4153 type CMA Flags 0x4020000000008224(referenced|lru|workingset|private|zone=1|kasantag=0x0)
 post_alloc_hook+0x23c/0x254
 prep_new_page+0x28/0x148
 get_page_from_freelist+0x19d8/0x1a40
 __alloc_pages_noprof+0x1a8/0x430
 __folio_alloc_noprof+0x14/0x5c
 __filemap_get_folio+0x1bc/0x430
 bdev_getblk+0xd4/0x294
 __read_extent_tree_block+0x6c/0x260
 ext4_find_extent+0x22c/0x3dc
 ext4_ext_map_blocks+0x88/0x173c
 ext4_map_query_blocks+0x54/0xe0
 ext4_map_blocks+0xf8/0x518
 _ext4_get_block+0x70/0x188
 ext4_get_block+0x18/0x24
 ext4_block_write_begin+0x154/0x62c
 ext4_write_begin+0x20c/0x630
Page has been migrated, last migrate reason: compaction
Charged to memcg /


Currently, free_unref_page treats CMA pages as movable. So, some MOVABLE allocations may use these CMA pages and pinned them. Later, when CMA needs these pages, these pages failed to migrate.
free_unref_page()/free_unref_folios
	migratetype = get_pfnblock_migratetype(page, pfn);
	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
		migratetype = MIGRATE_MOVABLE;
	}


Best Regards,
Akash Tyagi

