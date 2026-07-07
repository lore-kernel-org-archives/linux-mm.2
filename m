Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F24EC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1886B00A4; Tue,  7 Jul 2026 04:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A6A6B00A6; Tue,  7 Jul 2026 04:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A1B6B00A7; Tue,  7 Jul 2026 04:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 018626B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:26:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8737CC1E8A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:26:50 +0000 (UTC)
X-FDA: 84961299780.15.173AFEE
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id D9ED3C0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:26:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iF90jdy1;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hKIIEJl3WKu1bJOCbl82x7ScTc+umlVXZysFmiodbQ=;
	b=JTYwIKzfMpe3C4HPIdoVVcMHC2fZeyj/kXsjYSm1aK2HJVQXtvi/SQyQanMDnJrGaqtiyx
	WI2bjRp0FCiUkUEfx+qOvz7ZN6+UlezDm+rw5OCXHpCbzsKOvzKjIXFdxXr0D6wJRVZGEZ
	vEcc4J4XtRMYbIqAN7PYxRcikihGI5s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iF90jdy1;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412809;
	b=bWyz5dFLiDgnH7lvMey6dFiyfMgxSjd40BqU9/AjsGhsxO4+hfc0vRgxQSvAn3Z/YS93bw
	P/2piS+tHzkS5IQSW5tzidiK4t+PQHkHFmvpXbV29pOtnqqUYyo2qQfs3Sf+MYx4gpKAny
	VMlzCs1RDp07fyrLDOSBX6k5H9nAghA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3hKIIEJl3WKu1bJOCbl82x7ScTc+umlVXZysFmiodbQ=;
	b=iF90jdy1nuou2/+Rjg4M6C5f7Xwi/rloSo2iIH6pAgdG87gXAeL+1C22Ka8hAuEVsABf+A
	OTZTbQCEdUXa/lnGF7nHydqtnd0QekToPdz27udDdEK9m/Kfh9uVcRTpIKP+cJhHvsSZZu
	s/74lM60TfXtTv7oPfC7Hv9UEgqgnEw=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 03/10] mm/swap: add redirect_xa field and ghost redirect helper declarations
Date: Tue,  7 Jul 2026 16:26:05 +0800
Message-ID: <20260707082614.95030-4-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9ED3C0003
X-Stat-Signature: mm6ku65fq4535asr3dq5sami43bwzgq5
X-HE-Tag: 1783412808-90486
X-HE-Meta: U2FsdGVkX18dwYEkduy8ePG3eFzMwEWmvJ+MkRMHi/z3SwBl55FY2L/x0iONkBXdU93HSlYRxgexe7/Xpy6gQYs+jNbiimU8riVEXCRQ+G1hnaZHPn2CU2oGUnnB6alpuKcNsTZO+DYwWvl+xS9S/crdvHQ7/5ML9vzdCvfSu6bz5bKvSPwkhdUzaNi/Il65yR1f8FIkEA5JQhawSbpQwXwZTt0FoKFlxqUFHiid4e80XMQpUtSSatNAnpIPmtX1o90TPiuEMXPhBTRZSyYVZyBCjobHI63XxnB86R6gulcp84pwZiecGd3GH5/YJoy/rJMRgi5TztlnY5EcuF3kSegTm4K8WQa0inupZemqCrkQicTQ5pxIoOt2KOWjQu+3/yrmOE6pjpKhZtl15QgUmtwbWolLz3z/lPBiVf3hpkn1kmNjdQlIoJj2Dq8t7l3SVXzcRzaJ81qQiuQgjmOnqzcS+OcJa65ZWEn/LQUSPv59frcAD+T72vf26K+aahGdEk9IiK3mXfXnREk7ixEOyaCFSKMoA4WGAUxzkoZCKG1J52QG/72vSPbJUSd3x4WB3exqeHeC2p3dL2silvsm+1t5s58Jqjgn+JGlpYYgGMWtrkFeNmFVmAxWXHLSENwR1IyaJqZVxZAffe7by6DKG2mAhWjyPTMObMDpYJygHfwqRF/t/jzSrXjywv9saLr1Jg9f1GiLlSCnovQbj1br57MlgIasnIkB09Uw4G6CyA0HLiEWOFb2pBeX4HoHrEYaMeP3MSDP1pqqs8TOqOP29CfRUaXpo3cDUokJrsZE9AhaxEC3BcPjcRoLlCNxQxJlHf1Ubry0muT7MZnbLVdxQ81Fh0/4jEjaLVM9jsjlPe53MK/3lVFrz5IHd5+uJx5t4rR6Mlgef5DxyYSbq/0EpgX+366vwjHWCf1LDPEkJFJoezxfWzJ6KBHoxAfkTODrom2jRzC7CPkhgqk7bFV
 vo/R3lqw
 rbmvFvtTBlFK62M3j7NHF+BP3SmVt4IIQTKU8hJf6gotXSs2Yk46opiSaA0HzDfx/sJq84MS96hmmNmQsPGldN98IBZ7EtBa9vmlOmWV/UgwLyWp/NbJ4vmezZXwgPfga/5Zxg3hHEK6t5L1PBT3p+PYt7B1bHwlWbted2p497geYqSH+zTlZ04CoFdUo9SDE7H2O7t0bhFqX+cf4cFq/hTlgbcbYnIjYBuzMv4RwVXygiu3ZDP5eyHJUrDJCjj593aBdJEEobm50Q5OWQZFm03ySwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a 'struct xarray redirect_xa' to swap_info_struct (guarded by
CONFIG_ZSWAP) to persist ghost_offset -> phys_swp_entry_t mappings
across swap-cache PFN cycles.

Declare the ghost redirect helper functions in mm/swap.h.
All are no-ops when CONFIG_ZSWAP=n.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |  3 +++
 mm/swap.h            | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 9829a31a541e..a4d6851e0921 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -277,6 +277,9 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+#ifdef CONFIG_ZSWAP
+	struct xarray redirect_xa;	/* ghost offset → phys swp_entry_t */
+#endif
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/swap.h b/mm/swap.h
index 2d29e41d3323..bc51ee5dbf51 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -287,6 +287,20 @@ void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
 int __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
+/* Ghost swapfile redirect helpers (mm/swapfile.c) */
+#ifdef CONFIG_ZSWAP
+swp_entry_t ghost_redirect_to_phys(struct swap_info_struct *si,
+				    pgoff_t offset);
+swp_entry_t alloc_phys_swap_slot(void);
+void free_phys_swap_slot(swp_entry_t phys_entry);
+#else
+static inline swp_entry_t ghost_redirect_to_phys(struct swap_info_struct *si,
+						  pgoff_t offset)
+{ return (swp_entry_t){}; }
+static inline swp_entry_t alloc_phys_swap_slot(void) { return (swp_entry_t){}; }
+static inline void free_phys_swap_slot(swp_entry_t phys_entry) {}
+#endif
+
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
-- 
2.54.0


