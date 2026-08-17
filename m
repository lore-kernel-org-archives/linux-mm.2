Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCBAC5DF6D
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 03:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96ED36B08EA; Sun, 16 Aug 2026 23:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0F66B08EB; Sun, 16 Aug 2026 23:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5E96B08EC; Sun, 16 Aug 2026 23:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5697F6B08EA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:00:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8FCD160619
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:00:07 +0000 (UTC)
X-FDA: 85109257254.15.513188C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id E330F100007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:00:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786935605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=bk80QEvBssoz86IAr4r2C70RGThNpp17urglKG6SvyA=;
	b=X0loHC0MfO7dw76geU9wzJPvoQ9z5g7mdF9+E96L/2BYm0ZR8cpw2fqLjipvX5RLoCwgbK
	QH+Uooby6R6NV+zpxYPgDhSJzr/S+De3402UhTrVCgtDroHY4E/RDMvdgheExdwi0oxFXh
	ZK7+7c+sXwUWsaeIQyUuruieuZ8p6C0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786935605;
	b=tK8BJQeuBytRWu0e4nHCZC+T64iAta1Zk1NDcBNfA001XK93fId+gaH8xVMWATFWXDXQmS
	VbypzIdW8owQoV5ivHWETwG/PNFlqOC5L9Bsc2/aVL55iMt90xme/w9lfbQnwsmr1/46zY
	dBZe1JpUL2m2JkEHPO6qgccXFBljPBA=
X-UUID: b951159899e711f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2d6cb092-b4d7-425c-bba2-8622327e898d,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.19,REQID:2d6cb092-b4d7-425c-bba2-8622327e898d,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:7db8b62,CLOUDID:e7b039aea4d664cd40d109712db20148,BulkI
	D:2608171059588DXYCQ5Y,BulkQuantity:0,SF:17|19|66|78|102|127|865|898,TC:ni
	l,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b951159899e711f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 581254986; Mon, 17 Aug 2026 10:59:55 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhuhui@kylinos.cn,
	joshua.hahnjy@gmail.com,
	audra@redhat.com,
	bingfangguo@tencent.com,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg offlining
Date: Mon, 17 Aug 2026 10:59:17 +0800
Message-ID: <20260817025917.66233-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E330F100007
X-Stat-Signature: 3ztfnc1t78udju1rm4ywkxwxuayxfwog
X-Rspam-User: 
X-HE-Tag: 1786935604-505116
X-HE-Meta: U2FsdGVkX1+Of5JHmd9Xakgym7py3hkD9kuccaDx5Of3y6URKaJb7R9cSqdZ/BzvzaSLjMHZxh6uOTXRHdXABdj0U0J2T5R1B08DYHPi//pkKFM+hxZQ4D+/G7yb8izbuLAYulZJECXaMh8ZADrGo20+bqX8KAMojYUTuSqNSjUs/OQ7ybbbYc/aPDLTy1WMuR6Itk5TjDDO0miGuIgyTfx30tt0f+IwyO1LWGJhUfEz5xYwljhz+6O1z46pADDuLXyY0DGx1YZ4B6dz0VcXS1Jk4OIs96Gxr6MRI+2yEse8iRP05PDadj7GMM7MJ3xI09eF1LQUcu6ErCGpUWh43wEW2HdrVzuGiiEO/GEIJuVGlrPovhdVp/FkwPF47dUIv8sGNjaZ6tZmO4bD81c7fihqi9soqtlc+kmtCsioDFZS2YGEBUpMHd0UwdQqywpNmcp/npDxWbjI+3jJzpXI98VduMYsGSAHMpouwaG1Ec4aLaRQ/L36DA5/6CU15AJuinP8ScUuvLxvYS7pVynwBQPFpLnLHHEG8Nya6lwIc5LPhd1LG9DHB1ckwAap+5wm+Y7qaCZQJXLa1A0JAXaJFVzHG8ObM06elZEAppRN6k7vExAMEMmPP6k9b+TGGdRTv59wVxr6yJmAmXOJlasrluLAkpJbMfyDb653BCsCSoSlwQEn6dRTl9pnSR0slnHwFx1EXOxBwXge83ylr1KYW9fd5qi4z/VFTCXR2gu3hZt5kbx71kjkh2XLXHN7zjZC0qUnhfYpbg1EPMNNFESsVYxxGBmSc9039+OPYxY3S4h4RAZAPa9WHBvJh4ShMsWsm4iFcNw+0dk+KzSqHATBBd7CqJ6NHusvBkjocepV+LGsFlwVqINc8BRh3e8YAgoJTpk4bXZX7ICqaI9+lWl1ELvPaIoJgApRsD4HE2R3jW6V4ZcQnKv0g5sEqn8U4iSM8euTo7rIHr5W7dbrvpW
 cBV19NAA
 WL/RZCTtr9QXuH+TeStcPAWjwR6OEswLO+tEMDBc0+/qDJFJrX78DdFu+NcTiXSA7dLAc47mLipctZHnr+hNS1KPIgY16F4Vfy0fQi3YCGWwHSWd4aYbBO+JjYyST/Ay1r+U2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

refill_stock() takes a css reference for each cached memcg slot and
mem_cgroup_css_offline() relies on drain_all_stock() to release those
references before the cgroup can finish dying.

consume_stock() can drive a slot's nr_pages to zero while its cached[]
pointer stays set.  is_memcg_drain_needed() skips such empty slots, so
the offlining drain is a no-op for them: the pinned css reference is
released only if the slot happens to be evicted by later unrelated
charges on the same CPU, or by CPU hotplug.  The memcg then lingers
in the dying state indefinitely.  On a CPU with container churn, a
per-cpu stock can pin up to NR_MEMCG_STOCK (7) zombie memcgs.

The sibling obj_stock_flush_required() has no such gate: a cached
objcgs slot is flushed regardless of its byte count.  Drop the
nr_pages gate from is_memcg_drain_needed() accordingly.  Draining an
empty slot is a single css_put() and a NULL store, and it happens at
most once per slot per drain, so the extra work is negligible.

This is easily reproduced with short-lived cgroups pinned to one CPU:
12 charge/exit/rmdir cycles leave nr_dying_subsys_memory at +2, stable
across later slot displacement.

Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/memcontrol.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..b931ec16bb82 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2291,8 +2291,12 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 		if (!memcg)
 			continue;
 
-		if (READ_ONCE(stock->nr_pages[i]) &&
-		    mem_cgroup_is_descendant(memcg, root_memcg)) {
+		/*
+		 * An empty slot still pins a css reference which
+		 * mem_cgroup_css_offline() relies on drain_all_stock()
+		 * to release.
+		 */
+		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
 			flush = true;
 			break;
 		}
-- 
2.43.0


