Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC68CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8A36B009D; Thu, 11 Jun 2026 02:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1166B009B; Thu, 11 Jun 2026 02:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F0D6B0099; Thu, 11 Jun 2026 02:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5516B6B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:21:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D854C1404B5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:21:51 +0000 (UTC)
X-FDA: 84866636022.19.F4C788B
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf24.hostedemail.com (Postfix) with ESMTP id 552B218000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:21:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781158910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdHy4eP3so8s4kqwMKPF2sqeivAtp8KE8R4aJsH6LH8=;
	b=5ljb7K21fPd0yM4Q0vyJ0cXLg04LNDaxjD2hcslBTEQJjL3mAZq/ge/g53a+Y4S51ZfaSF
	0n1Vzkhs7cp3GfIhNvIyRjK9G/ljZhhNBhIyxHOTGpCcdjvuHWEEJuuL62DhdI23jObrIX
	A4v/MMw0QvL3KsaHnPsGlzeyTVZiBZ4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781158910;
	b=OPeJ5cDubfuGa8Rq1+CCGV5Cn28KzjhqzeKTb3D3AwdyKEfmHLRzQVZTMHGqq04IXlsmnL
	eE7TRFp+RE5W5TGHhfnNSvihmrMA03oDmGH1JfbtdfXhZhxk0WXZPu1MaY6xfQBi/gN1dB
	d+fLohZdOTFdnCvl9/pb2bbPpb7wUEg=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbn74Ckz12NXN;
	Thu, 11 Jun 2026 14:21:41 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbn6tJgz12NXN;
	Thu, 11 Jun 2026 14:21:41 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id D585816CF;
	Thu, 11 Jun 2026 14:21:23 +0800 (CST)
Received: from hsj-2U-Workstation.hygon.cn (172.19.20.61) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:21:36 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>
CC: <surenb@google.com>, <mjguzik@gmail.com>, <liam@infradead.org>,
	<ljs@kernel.org>, <vbabka@kernel.org>, <shakeel.butt@linux.dev>,
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux@armlinux.org.uk>, <dinguyen@kernel.org>,
	<schuster.simon@siemens-energy.com>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <djbw@kernel.org>, <willy@infradead.org>,
	<peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
	<namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Date: Thu, 11 Jun 2026 14:18:57 +0800
Message-ID: <20260611061915.2354307-2-huangsj@hygon.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611061915.2354307-1-huangsj@hygon.cn>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.61]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 552B218000D
X-Stat-Signature: 41yrpgefabi8ont8tod1n8n5dmd6a81m
X-Rspam-User: 
X-HE-Tag: 1781158906-496849
X-HE-Meta: U2FsdGVkX1/5KGIeVcDT67kcFs/KvQca6E4DMRzGx0kinR0qbm+JxqNpN68NhAZIgA8Vp3v4jyDRv1VEe/hXAYJBra8ajToJX6d9bVwPS1OoMayVNTldjLCruAJzOXTzBW1G2JjbKUTgSEYvVN8IcGSFkk/bw0yNKtWJP/ou9OTSayxItY6+Et7Ulyi31vusaWyYM0WZG94Xp1ixhyfasMUUMxpNzJgYBQjr0SrpYeVpxHTfPV4628xjsuVDWVHbyWPUXX5EBvoKTG/Xb+UHHeq8TdtL9tOsLaNzAP3J9x9BtyEy9yBqVOFNQ9lggigygf2xAEi0FEZJy1u7aAMJFE7KdwIzvmjW55V5w9XNBO4Y+QDMFL56x+xakIYTM8N/tZYq25shQ3sPcHqCBnEAsk5ieEqjdZtwU9NrouaV4t33ky96ugOsq+meNVs7xTFIef2Y/wI57tfyvE9FY7z9EygchOYxYbbwgHnckyXoG7EZrOHU7DRKnBcQyMzsEXD9AU2p9yROWlvmaSKtDx2i5Xvpd0SR8+s1jGvPTGjaFOvKveoJuROPO2RXH1c3PHyc6bEKyLRx0Rii4vPZaXrg8PyJkI8fQwBOFSBE4KWQbleTMIDEtQl6Ucr5rt7p0Nfra7dAbXQE6eHIIgFQm5DvsNZHDnl0ucRiDQF9N9fErQoRVLrQc6OA/MeedAp9/W4AyxeUKPpwrXj5ug/aiVjn+xVVqpokbhADH77OgsvQ2C4eRk/Qut4T1rzJXHTJdGwPzcnGrbDvs9HvRavqql40NmexsmUaTix7wU1sfwI9JVuhn7DYvgR/DWjWAb0MWSRDYPXD4EREDK2BI6e2zSqIbuipwSWxn2iuJawn2+xvG57V5uHwncC16g4UGzuulws0afY6bpdi+ORJEf3imRc3AP5DoFPRIW53pYn1vOI5Nru9vByAW3wAjbU/c35RgsPgdKIBnqUmXt0LEYcBPYu
 tBRiSwQx
 +KQBJoCN8O8YL1Cbl7AfrSHiwSyHtqb7o1BrSVPwxLiav0ePpPcmFz1Hp0WC+LPRdzfkKEPM7JWF1MG98Kv/OYhpJfq6GdIRoj0ZpfbDAzLaUk6u1bWkcoQkjuQdyDmIabzvGw2gfgOGMCHSscQ1Shjpwxkyphi7BABe30imeqXlaJJgTrAS1XbkYpJgdcMH4kLwNgiYHT0z6fsOxZ92JAQypd/IB69jeyxFAl4CNiEZDCcJKEz8Y1vOxVg2H3XTiNc8JEU/ms9+/148JrdXT/SugnW7W8Rw/6i4WBXaQxPHGGif03+XhrUT6F9lu3Eike507fJ3t/uy6huRPI9YoOejqCF4K57gYpNyHqymzMdX2UnGb8CBZQlycKkfBksbt2EYGZKDuLkpOIU/pAzZvtpKDw4ZBR24AZdKtK1sno79mkqo6jPu7HtgQvWo9zveBtB20
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use mapping_mapped() to simplify the code, make
the code tidy and clean.

Signed-off-by: Huang Shijie <huangsj@hygon.cn>
---
 fs/hugetlbfs/inode.c | 4 ++--
 mm/memory.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 78d61bf2bd9b..216e1a0dd0b2 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -614,7 +614,7 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
-	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+	if (mapping_mapped(mapping))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
@@ -675,7 +675,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
-		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
+		if (mapping_mapped(mapping))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..5335077765e2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4386,7 +4386,7 @@ void unmap_mapping_folio(struct folio *folio)
 	details.zap_flags = ZAP_FLAG_DROP_MARKER;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
@@ -4416,7 +4416,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 		last_index = ULONG_MAX;
 
 	i_mmap_lock_read(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
+	if (unlikely(mapping_mapped(mapping)))
 		unmap_mapping_range_tree(&mapping->i_mmap, first_index,
 					 last_index, &details);
 	i_mmap_unlock_read(mapping);
-- 
2.53.0



