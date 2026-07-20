Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E3F6C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCEEA6B00A1; Mon, 20 Jul 2026 15:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80F26B00A3; Mon, 20 Jul 2026 15:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20C46B00A4; Mon, 20 Jul 2026 15:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE3D6B00A1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 084441602C6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:13 +0000 (UTC)
X-FDA: 85010158506.13.553BE19
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 506A52000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bXoPZJbJ;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRBuTTcFDLFkxWr76FAXg5UPkm9NjmBW+wSCIxxIlUw=;
	b=N3Q9Ih5RTStYhF9vztNAx2AvD/zVhDho8uBKEAqlLYR1w+twJDx/s0J+6CrZUCDPPo+wh0
	nO5yRaJ5ddRRO3EIf/Lcej1oXr1kg98uHwV/NEjA4EOiCiBo8FfKtvaTa1T0tuojQ3crI1
	DZsm1B9dGOoIXLBI/Yp5rI6Sgl6WwEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576111;
	b=af0QacWfrGRaqyT8UHEQpurz35HQ33uSP/2PsCGd8iK3F3P3+k0rdoC/Ii8puDXNAfsj1l
	prqg8M97lieg8Zq2X4xKai/Qqgho4t8WEMiOScfAOINmeAbAN8vxEsfufY8mCgpQHdTkME
	RsAbDEpED7pAnw+EjLYNgEd8+DsMu6M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bXoPZJbJ;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8eefd4a8057so64824536d6.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576110; x=1785180910; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zRBuTTcFDLFkxWr76FAXg5UPkm9NjmBW+wSCIxxIlUw=;
        b=bXoPZJbJL5t3sEhRK87FfQPWf6BoXzfuOrn41H6Jd13efbOmrGvu8BbnoBjCQSfcKH
         yACmqqoNBqz4sblqdivU4pDyAG9ArilfcL4IVPc2CGdKqpSGgZgVW1f8INCJeGz1QFKA
         DbH2FevyLepEIiL7G2aJ/mJApumNzcIxVlCZ3RGoWSN2Efz3i1wcjYu5y5knBoxwVK3p
         WvTc9jX0KYWNZ9/Fck8zvQTdHZaPwVghkg1KbK7FpKLCVzqsS06jcvNqs+bnCb9CTdNr
         dZSAk2o8Ss/jT89Z8cLo4ME8s31FDO3JHNeLgnjcbxcsU2cHbf1VM7bttgdEoZw8WAvk
         q8QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576110; x=1785180910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zRBuTTcFDLFkxWr76FAXg5UPkm9NjmBW+wSCIxxIlUw=;
        b=Vfi9sdCdkIToeh8NNk/63u9DKQ3K0gbojA0Ocr4RCMvan+V6XyUFjzmcnl77oYR3uE
         SKlE58AmWzJf22kmFMzwCpHt/FV4zw+Z/7awlMcUMw+ex9HsIuwCFZglRt3+cGa3NLMX
         /hxzG67vWpgoEvDdL3GOHrkXWEwGX9GsQf8WhpxYxPm8wy5SV8EUF2MvBEoTG8RyCOD3
         Krolxwkci1fA5G76Q3SiWg+cWFTCJMyNHTS5r7qISJn+UOyTQriKJQV1nR2BBiQ6qz01
         eHFnNKmK6KUHf49dA0NTzJDRlMFHC3lu5LEorfHYCd9H3KxQ19fIPoyk2JcRoOzNuIj3
         9Hxw==
X-Gm-Message-State: AOJu0YwFqcb6BeGVXPrhmWzX+yiCspto9WoFdjwyXp9qEvO2lfx4f7my
	NBdT5+6hEbGd8Y2M73MKO0sz2ygM/pCVBm9cnjyEjk7+befZtBxOQw92Ci0tiDVXk4gWpoU5o8o
	mt3uo
X-Gm-Gg: AfdE7cnYS5MyzhUqU0iHyJjomAKz7PqQn99DW4lL7t8kess+CqXv+tfHsTD9fZgygsd
	ltfFXVv5/Q8spDUQrBSDpeJDEKjXa2H6XcXAHZWW4NDZh1aftM+xA96BdpDODm8l3greAlMiWR5
	9u4x11keaOgdtTIy1/AO5WOGn4R/aaKHxtb1y3w6OoSJfd7u8okwMgN9rVunqhMZEMv6nkYLj+r
	muCJGojaZttxy4q6xz3mcVHdmWT+ZzidO3ZMQLHnd0EBSRozptg+A6CNJhvjSHHT30pWJuvkSyy
	1RA3j7bArVg44BHwsAqxlr0xZ4V3I6LRtvg+JB8oTpJ76ULdlpIyJIWJaka5AOCvK3wktk+6oXT
	TAOFD8A9oUzEHMuFFVicR+za5pRKMZ0xwk1RxWd1xgPNV9x8YDlAnIla/+JYHYAChnWy1bOOrsG
	4vrrliY8ohOXh2CbLUImdecLmCSi+AWhRzqpRprbihz7gWVTlRDp70AIWqyFXZaRM=
X-Received: by 2002:a05:620a:3706:b0:92e:f212:98df with SMTP id af79cd13be357-930b3ec8d4emr1550494985a.34.1784576110290;
        Mon, 20 Jul 2026 12:35:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:09 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 12/36] mm/page_alloc: clear private node watermarks and system reserves
Date: Mon, 20 Jul 2026 15:34:06 -0400
Message-ID: <20260720193431.3841992-13-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 506A52000A
X-Stat-Signature: 7oqkxdxmnypz8gp6rgguj85hjmyaqnxn
X-Rspam-User: 
X-HE-Tag: 1784576111-434844
X-HE-Meta: U2FsdGVkX1+ZU1OizCecGaG18JnRCJGwNtPK6EZyhkt7dbTWtDk9SWi7tTYH80d6AoLWejvuWif484g1cZK1XR+mE6mzBAPxDbZQdUyK/Ua1nFMsdRObkAJJq4v8WwZLxbC8Nwpubo7R4ebKBnSENukBhpFLHTgxvsOLK1Y59fKVoiGGT9NHQIrgAIiqfV6480k0ZVUBiDApaDQSEAqUaJcXYSL9JZipjiie9oY8bvLjSWmopGs1RgMQRucqV1s0cYxEWuzXtSispBqqhTvn6UTsk5RWidGw0qaGG+r1DeMWiaBRNiRYkHnfadvP6rJZ6TEfKAIXDlrO9nbyHow96HwpMpIQfhKMSccfVIJvWsd4isv3uXJTLoAroYgYhvq47d4LYoyRO6WFVphPlSrADwEfxfIe+YEVDsnaVl60nVKHwN7sIietqplZP905/5jYfUlSu5DBt7f6/sZxcc6TOokdEyLZvFNtBtrNDs/lY3W8IWy1p5goZq9XID68PoUxxGuL8ahQpMHvLxCZH3CVybxTPDiwkFbu4pywQd6WXvNuiVmD+owMx75S691M6aEVC3woWhoY6qpNVJN0S9B455aqx7mN+bN7E9u52dg5SBADT7gelQiMo1qY7lESzYyquyvZ7i0Ezkl6zghhF+MGkNkamW9GonW4dk+zVzHPH2PVjaq8HaX0FJN/sPoLAIa7brI0q9AsFVUb8cNutWEZFvvRItt2eEapIXuI5dIe0ONLV140tKgn8yffYRHRJwOUWbW+DynkNRBRaZyOFiG+aa58kO4BsQ7C+S9qWJf8WSqmJfLRHN3EuhC651i8lqic6ARyk60iBcnDWY4dsCoqe1x/NdStiMjspdvI/60DXCRNcqN2G8LRapp79waJ/gsZy+8me0az7udG/qE5izkblRe1F9+fsafZPOpsebsZaGVFqLTxhXlSv1TOCeRxI3g9+NRtlx2CJXJKihBdKFC
 L5ZtNOT7
 fetHkMcktcV2LiSFObmbhK9dMQWXdJ0VECRr8M9fOqLe13ilr+ckEe2Py+odjxykKZ6mBLzatGcK55aJFbokdL+4BKNXp0dKL4zV7WZfwIbewIJSlX2Tug+8V0CQRgbhCzMgF75H8ySwOV1hY9XwcSf3JviqckEvaZTV4HCQDGkNfScpx58LFvwcbp6bAjfZM1uTpF2YBNUGzUf3xZQRE8f1JyMcblz+ophVRZlLjEQeBlCh805AlBPdUc9uRLYW088RuG9ZkAUSxdADY013EE20Qlc6ztTqhvYTmc2DC9HkGpaAsX9drVXTJa/IH/b6mG08dNX3BNZIeUrduPObLiZyL+yqL5GVEMlsDr3N2o7qOxWQelF1KgN5v1RAYjBu2lo6psOdiGF6WOILid+SqxOjph/GgPQLBzo/b1KAGf+x/D3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set private node watermarks to 0 (reclaim isn't supported yet, so they
are pointless), and do not include private nodes in system reserves.

The oom killer can't actually resolve general system pressure by
releasing private node capacity, so including them in system reserve
calculations dilutes DRAM watermarks and causes poor OOM kill behavior.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 78755a55b1540..2b08bea2379a9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6555,6 +6555,10 @@ static void calculate_totalreserve_pages(void)
 
 		pgdat->totalreserve_pages = 0;
 
+		/* private nodes have zero watermarks */
+		if (node_is_private(pgdat->node_id))
+			continue;
+
 		for (i = 0; i < MAX_NR_ZONES; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 			long max = 0;
@@ -6647,9 +6651,15 @@ static void __setup_per_zone_wmarks(void)
 	struct zone *zone;
 	unsigned long flags;
 
-	/* Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages */
+	/*
+	 * Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages
+	 *
+	 * Private nodes are excluded because they are not in the regular
+	 * allocation fallback path - including them dilutes DRAM watermarks.
+	 */
 	for_each_zone(zone) {
-		if (!is_highmem(zone) && zone_idx(zone) != ZONE_MOVABLE)
+		if (!is_highmem(zone) && zone_idx(zone) != ZONE_MOVABLE &&
+		    !node_is_private(zone_to_nid(zone)))
 			lowmem_pages += zone_managed_pages(zone);
 	}
 
@@ -6657,6 +6667,16 @@ static void __setup_per_zone_wmarks(void)
 		u64 tmp;
 
 		spin_lock_irqsave(&zone->lock, flags);
+		if (node_is_private(zone_to_nid(zone))) {
+			zone->_watermark[WMARK_MIN] = 0;
+			zone->_watermark[WMARK_LOW] = 0;
+			zone->_watermark[WMARK_HIGH] = 0;
+			zone->_watermark[WMARK_PROMO] = 0;
+			zone->watermark_boost = 0;
+			spin_unlock_irqrestore(&zone->lock, flags);
+			continue;
+		}
+
 		tmp = (u64)pages_min * zone_managed_pages(zone);
 		tmp = div64_ul(tmp, lowmem_pages);
 		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {
-- 
2.53.0-Meta


