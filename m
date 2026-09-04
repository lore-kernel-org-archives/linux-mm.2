Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31993C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 19:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2316B0088; Fri,  4 Sep 2026 15:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A99C6B008A; Fri,  4 Sep 2026 15:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0976B008C; Fri,  4 Sep 2026 15:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C44E6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:01:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77065C01C4
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:01:00 +0000 (UTC)
X-FDA: 85176997080.20.B8AE5FB
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8F38E140019
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:00:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=l3rBDNTj;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf26.hostedemail.com: domain of guanwentao@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788548458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UcOmkfW2ZFxthOlyo7oYIE1Vjb1R2Z7a4/GWDq7I1Ck=;
	b=uEIK57wv1nrq8Vw3kZojjGRo6ZdQufOplVWFZdIac8kFZQjAVvnjp/GXjHTXGbrGj5OT1Y
	hO0ydrkHOucUdTUCcfwO3nJ7vrwkvH71cdW2ol9iZ4pnO7STa/YK4NeKPqKOdKT+MYDskw
	9H2M63+H/3Ybb8W/utnhJHkOEzcUpFA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=l3rBDNTj;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf26.hostedemail.com: domain of guanwentao@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788548458;
	b=gYYSashZB2mi5BmbR5JGxFaaT93tAwvOBe2x9Cuamu3XbFESm9HU6/Gx4vmbbVCX4BW6wA
	Ix+dT9w7qDPCDyOl/5eVbcc0yefhb0yQetrX2Ou+eEtzFR4eei502yf4EFwb7maG8znlMy
	MQwk68yF39WW95Yv2ei98BJldxLTDU4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788548440;
	bh=UcOmkfW2ZFxthOlyo7oYIE1Vjb1R2Z7a4/GWDq7I1Ck=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=l3rBDNTjTL0yF0NP3My9oCBCABG3IrqEUxi76wdLf3tOV9uJeaCUtmNbFUAwqC2v8
	 NY3HprGqFd+4gJI4l0EX3urdxQMd4rXC+Jt1MZrzPJWnfGAcNFoc4RkT0CRc4ePoSH
	 vISNYpWRHA25JqnRg+5iyCgCg/s67qJl7goIWgvI=
X-QQ-mid: esmtpsz10t1788548434t4ffa4808
X-QQ-Originating-IP: tPtF9edAtIQDM30B6GGR5BAuwcOTCe2L8C0nf2UkaZM=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 05 Sep 2026 03:00:32 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9379820658307783900
EX-QQ-RecipientCnt: 9
From: Wentao Guan <guanwentao@uniontech.com>
To: david@fromorbit.com,
	hannes@cmpxchg.org
Cc: qinyuntan@linux.alibaba.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH] mm: list_lru: clear shrinker id when disabling memcg awareness
Date: Sat,  5 Sep 2026 03:00:28 +0800
Message-Id: <20260904190028.21542-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: M5znx2hx04lbpoOMoO88JiSBtTYP6nekwxgAzfuIjrO7fQdi5Su1fYp6
	Q6PciVO8CAKv8wSI0XzUCxSVbI+06MYLhnSw2ZZGLewCM1dMYXjjgMezH7VyioOCOxH0dDn
	dp1ve+PPz06DpXhJDFnwF7/66HRoBF9f4BqnHP2/qBtIVOIKYhgXLDslj5yOkf3BazjnQ8B
	brHpOhUUgVLrV0pyI/73CM2GU9juec00CSPfqkjFreOF3sUD+GWftIxZ5ytk/G8SyUunll8
	ggTTPFTk+VfamEbRY3ikGuXs3c9zZOcfDeYPEkjLS7ZjMnaNaOOAYCsqOltkBahTGPifsgz
	K+6E86b4ryKRlclq7/oS+QSV2YV2PpufafD5T3J/lzjsBpAovlXaVvTYsIpN4RSl7rEvlNd
	f5qZWCqusJY28FHaniG7j+nOxsL2tNDQmiaXzMzod2ySblW7l22cVo1lCKIe7v6/EntLXrO
	U1feJlpSlOzykklyi6EHVS3TI8LMtvE+28Wf92HHpAdYijBG3BLklxgtuPg38wG46ptkJYA
	/etV7W9acW3EOpjqq19JWN85MiPy67Nh8vaMK4+h627PRwjgnmA2Rvjv9XIPxaXScGm7ptn
	anz8ekM1Hy3sD1XWeBfjLrigiYmnY4qCx+K0OKvMNGHAC8/oY+Xvs1zpSzyPS2odLBmWPD1
	R9zKoMR470gyF0njLzCqtazs1nzIe7YppFnN5BW/7sAKku9Ck64vxf7IUAmt2FzW5rEU+9Z
	3NWhRtOS/lookT4aTvoKDqA2RBA1enumqJN2piOZMU+hGQIM5jtt4U6fEsqKBngdc/vMStE
	VEnrHVv9D+z8CKtKlyUNtDWDUzRMDeAK8qZU4iYqff9FS8CQrR9PEnTR7iv7ede5C0pP+tb
	4WYZVb/0Q7qMS2dwoihT7inJ7jdXp5HLLBHd/Zx/J5Up8qM4StqO0bKFoD3/63NGXx/3FU7
	64inMkTpfWn4qcWQVNcGM3IGfjWdr0MmfUBBW2MZLkqt68UdK8FprLjbkGHclwTjrzQS6DO
	o3Pxly0aCxmYtCnOUe3OMS0R1fdffj3m2qNessKU7GszfhNTJtFmL2In3CZ/E7RKqbh7ufU
	Q==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: m7atrb9gyrf36urm85m6youjtz484tx4
X-Rspamd-Queue-Id: 8F38E140019
X-HE-Tag: 1788548456-443140
X-HE-Meta: U2FsdGVkX1+0IaUVAjkSI8fbAiOqoc/SOm/1GKF85+Hulzpzk5nV+Mt1jAsPXFXXryxKp5YhASEiN9ef0l3unZHWppwFmEg98B5iYIxX90fLTjvHdu2eO3pKlJ7dnTDCohw9HLkaxvUFeOVokSeIrXNANoFhziVeXIYJIOYLOCxQCBSc5GsqTJoleNrznnD/zhzIYj1GdHD7H9Lg/zniKk02kWbCdQe5iTSvaftP0nxMn9IfBB7tE420k1oiIMSmHrHwSPm+3p/mmcYEjQEvAsxLbcNFrQJL/PMLDzDuQQSZmFQLYfCBCZ1If//YF++BUEayR9uvrQl8RxxO+xvS1LJi6a70dXvf+tVnkkmdfAeAz1xliUwk8t0bmNSaxYglbAyW1XfsTomj/YGsswlvnK0HJ+Qqb11oWnLqadCRW4KMGkhiOD5F3MmChk3YlaMcy+skigVwhzC+MwJ4hHNf7bHsijOxPt/CqcNMcHdZEEWIg3aVTM0u6sQbu7HKRCfyFZo0ivva+Zy2PTIL+JQ8DEBG0WO0wmVz4Gi77mxoSv3BRc20KkhSXPTjc9KT1TTGE1sUsC/SRnaAOT6VOgvL8jwntDBnZQEuwSfWeHEN1dXZdt9/oHPLnEPD5zKExG9ayiL2WX8IkKiUAhYks+gwmC3QvOSkdXRl21XBESqpv+7Ecug1U8AA34SlUepQ9NwfpAOSM70mxz3YXcOC5sHzbPaIvF1jereBNbOMKDmswawQbYNGdxqaoTxPHSSaM8A+1jFc7xHhO3k5OKHssbDs6dbpyllWHSW9Utj6MQ2vuZM4AYKg2Yum4S4J6+nWs0hQ3GUklU9k9j7UHYEapsN6Wv43wUIiTEKWmyJsTszB3IiyV35twoFng8RoIiNhF3tx33R7zOWrDLEelCHYkfR9DeUGjWzfS579n8FClsgHTm69HXzPx/xUj7xFiKgiXgK2l+OkiZMzEaehs16IqOX
 0lps7tFv
 636/em8qr2vtBANRBjigK2ryuWjI3E671JyTb/hw6hgmWIHmta1z1i8FxE2PfA0Sqiz8fXJ87X5gYr/rg/AEiFbwCzWwU3oqR7BRPyB2TqRIYx9zdgD60H8hMptQPaiTJV6HCTxlObFRRb2CmamzYf60CbNZ0n6l7qbPeR/Qfx7CBvE8VnX0HlNIm1m21qO6XBy55vHmZznEWGEborRh3UgKCQd44QsJbdtvjE6wRLdsc/xOEBGInv2EdSvd2YjKrbW53TJnWnNVng8EX3lmP2IE9Ef9Gi5tsn5Bm+ZQ7fC16oWa2M5/rtAOQUKqjzaBL9Bn4w5kOyhwAFi/YtoKN70fO9ZjXvzkyQQokEGvMzsEABIT/EwOBbsIE9Gl03Ztb+sxD0wzS7N+HuuBmYVtfmCS0KB+kyYEL1f8JqnaTkcRFB2Fh/fxXO0Doiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cgroup.memory=nokmem is in effect, __list_lru_init() disables
memcg awareness for the list_lru, but it leaves lru->shrinker_id copied
from the supplied shrinker.

This used to be mostly harmless for memcg-aware slab list_lrus because,
with kmem accounting disabled, slab objects are not charged to memcgs and
list_lru_add_obj() passes NULL memcgs. The THP deferred split conversion
changed that: it initializes a memcg-aware list_lru with the THP shrinker
and later adds anon THPs with the folio memcg, even when kmem accounting
is disabled. The list_lru itself has been collapsed to plain per-node
lists, but the stale shrinker id still makes __list_lru_add() call
set_shrinker_bit().

This was reproduced on a kernel with CONFIG_MEMCG=y and
CONFIG_TRANSPARENT_HUGEPAGE=y, booted with kernel memory accounting
disabled. The same condition can be reproduced by booting with:

  cgroup.memory=nokmem

and then faulting in anonymous THPs so that they are queued on the THP
deferred split list_lru. The warning showed that the memcg had no kmem id
and no memcg shrinker bitmap capacity, while the list_lru still carried a
valid shrinker id:

  set_shrinker_bit: memcg=ffff8d23cbe60000 css_id=31 kmem_id=-1 \
    dying=0 nid=0 shrinker_id=0 shrinker_nr_max=0 map_nr_max=0 \
    info=ffff8d23d68c60c0
  WARNING: mm/shrinker.c:218 at set_shrinker_bit+0xdb/0x100

The stack was:

  set_shrinker_bit
  __list_lru_add
  deferred_split_folio
  map_anon_folio_pmd_nopf
  map_anon_folio_pmd_pf
  __do_huge_pmd_anonymous_page
  do_huge_pmd_anonymous_page
  __handle_mm_fault
  handle_mm_fault
  do_user_addr_fault
  exc_page_fault
  asm_exc_page_fault

The list_lru code already uses shrinker_id == -1 as the sentinel that
prevents set_shrinker_bit() from doing any memcg bitmap operation. Keep
that invariant when memcg awareness is forced off due to disabled kmem
accounting.

This is related to the cgroup_disable=memory case fixed by Qinyun Tan,
where __list_lru_init() also needs to collapse list_lrus to plain
per-node lists when the memory controller is disabled entirely. That
patch makes the memcg awareness decision complete; this patch keeps the
shrinker id in sync with that decision.

Link: https://lore.kernel.org/linux-mm/20260902093202.609559-1-qinyuntan@linux.alibaba.com/
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Assisted-by: atomcode:gpt-5.5-medium
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 mm/list_lru.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..c08a5e2367106 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -671,8 +671,10 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_kmem_disabled())
+	if (mem_cgroup_kmem_disabled()) {
 		memcg_aware = false;
+		lru->shrinker_id = -1;
+	}
 #endif
 
 	lru->node = kzalloc_objs(*lru->node, nr_node_ids);
-- 
2.30.2


