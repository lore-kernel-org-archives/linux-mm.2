Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E533C9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876806B00B2; Mon, 12 Jan 2026 10:46:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F76B6B00B3; Mon, 12 Jan 2026 10:46:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674346B00B4; Mon, 12 Jan 2026 10:46:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 506966B00B2
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:46:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19C558BFE2
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:54 +0000 (UTC)
X-FDA: 84323739948.12.0B7EEED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F48F18000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768232812; a=rsa-sha256;
	cv=none;
	b=XR6BpdJ4HiRR18l+yMumBLil/1jOrgvCAfsPtoWLebeq0CL2JZfDcwViC/zLgRwQ+QFBIz
	3fENIaz1sRY3dRFvKA7rXhLKr0/Tkk3EYIIjZMi4A/9nuur/TKEprezh1RSJskdSsX+LEg
	Bb9JO/lId4FsU0covfoViCE+2LRk/5Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768232812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lmuw39q/3Y6QyG/jeYKH/YKiMr58EjbcUKfX2NwatWo=;
	b=oIMBzlxk45Ztxiz77l3JHK/26+ML0caD8GgRN0N3qfgBawR1r822RP/dcbwYWrjULdEO/B
	Jcb8PfgASHVnZ1/sbjBhPvfjDuJPvSij51fMv63B6I46aZX3U5ovilEsTpYSOf0qjArW/Z
	4XsSYD3Lg/Ert2Lf5qOW2EH/5hlXA6M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0768C153B;
	Mon, 12 Jan 2026 07:46:45 -0800 (PST)
Received: from 010265703453.arm.com (unknown [10.57.48.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 508153F694;
	Mon, 12 Jan 2026 07:46:49 -0800 (PST)
From: Robin Murphy <robin.murphy@arm.com>
To: m.szyprowski@samsung.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	david@kernel.org
Cc: bhe@redhat.com,
	iommu@lists.linux-foundation.org,
	linux-mm@kvack.org,
	vladimir.kondratiev@mobileye.com,
	s-adivi@ti.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Subject: [PATCH 2/3] mm_zone: Generalise has_managed_dma()
Date: Mon, 12 Jan 2026 15:46:37 +0000
Message-Id: <bd002d2351074e57be1ca08f03f333debac658fb.1768230104.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1768230104.git.robin.murphy@arm.com>
References: <cover.1768230104.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F48F18000B
X-Stat-Signature: puee11kdszt9ebq6meqhwmpe8986tdsp
X-Rspam-User: 
X-HE-Tag: 1768232812-835871
X-HE-Meta: U2FsdGVkX1+8na24LeltjVFuVWA3CZJy99W/7eehoP2+jgJfFEYNeFhff/Pt2oVTFRrS5coavSbgdrR7ZSQPNEoywY2Jk09BDnl47z7U3VzggcqswzZk8DGU2T7xwDKr1vDCsywGdAOcaBILS1rYBACO9tD/luBP0gTG/G6G0ZlSyMfTXJKCJhnuUfo3wpmCDKtlA+KhDKlrjIBh5xh9OAwGPHaJFh85mNNk4xXItGGpdlBaXDfllhQNPMpJs/wNheIbIYJK8bshu2jwz2mA5+ptc6eL0VWflCpDy8wWPk4nUK5YmUV/ZRiIIkNXQh6hhI3WWCPbzZcvhHpfqoJp+seYZR7EAh9+3Zs6Ej7yNiu5rkGyFOQ0KUoFodnuv3HO2n270cIbImZrwn8wScBqDluKwY0lLhLUS6NsnFM5vK1Szze00jDSYI7jYTrIbRcSX+i/dDnGdYEilQ3BwaDsK76PLZzYnGKFTJkqp8e70Z/t5tNrAWpNCagG4SpCLNpj8fzSZ1r3D0qqNzXS+nHEBoHJke+2gBRq3OGWGmbpNbBuy7v47fJ/PRBJgh4j4w9ZEmSaXfiV4oPtX2a1XdGnIc530gss8JxfhcOW/HPyoa/1lZLGrG1MTs5OVonGwJpJ+Iu47pBi7YApP2CFC9XZOZEKO1+9YQ5rmBHFneAJAgaPi6UiQnZYKyIJXokyh7nZukOYW4uj5aulhjVIIsmjZsl2/RDvdLyoTCmRZtXEoVcpP/8qVP6IKBQMGJ/xRIZMpdva3TIqb66AM9Ym3d3DT+z+JVRuuuDObbiClpnw4DNBDyHexP29PXVpQeqE+j00ZSi5GpBurirzy9667svYtbS/3THbzB8sPBUsJ+vDmCilkwQLzv/hYEPf3A2yCiKx4RXl6L6pNRXTm43KAVUp6am2NnCGcIW3DmAdnlNHtPKBQqC1HVn9RlvhFCTxPiYfttFk8pNE0ls2dRdstmM
 XIQW73C0
 qEJS8AfssKrH3woJHAbhXPiGvflb76xMDokkGNg1FDYk02l4oLp3NtXpzWeiIYszlHy5tnHejJ5dX9jChT5LNRVmWBC9tyONZsAEmXM0TZjeoBHk7O6TStcqWUKMT1jejX1ap0Gp5P+8iP49ptMEP0dCog5GggJhfiF2ruXgl76jHddqoZGAGIPbltpxjcOS1dPWY5FADHDfT3JY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It would be useful to be able to check for potential DMA pages beyond
just ZONE_DMA - generalise the existing has_managed_dma() function to
allow checking other zones too.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 include/linux/mmzone.h | 9 +++++----
 mm/page_alloc.c        | 8 ++------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..fc5d6c88d2f0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1648,14 +1648,15 @@ static inline int is_highmem(const struct zone *zone)
 	return is_highmem_idx(zone_idx(zone));
 }
 
-#ifdef CONFIG_ZONE_DMA
-bool has_managed_dma(void);
-#else
+bool has_managed_zone(enum zone_type zone);
 static inline bool has_managed_dma(void)
 {
+#ifdef CONFIG_ZONE_DMA
+	return has_managed_zone(ZONE_DMA);
+#else
 	return false;
-}
 #endif
+}
 
 
 #ifndef CONFIG_NUMA
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..36ccc85c5073 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7418,20 +7418,16 @@ bool put_page_back_buddy(struct page *page)
 }
 #endif
 
-#ifdef CONFIG_ZONE_DMA
-bool has_managed_dma(void)
+bool has_managed_zone(enum zone_type zone)
 {
 	struct pglist_data *pgdat;
 
 	for_each_online_pgdat(pgdat) {
-		struct zone *zone = &pgdat->node_zones[ZONE_DMA];
-
-		if (managed_zone(zone))
+		if (managed_zone(&pgdat->node_zones[zone]))
 			return true;
 	}
 	return false;
 }
-#endif /* CONFIG_ZONE_DMA */
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 
-- 
2.34.1


