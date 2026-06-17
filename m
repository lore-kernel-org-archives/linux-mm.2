Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C187CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E796B008A; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BF56B0005; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2D36B0005; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65EE26B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2E5B40358
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:46 +0000 (UTC)
X-FDA: 84888726132.12.54210DB
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6E7A620004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1wWSIN48;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781684865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HixRkJ3rrk/W9Jdi9ELOZZkVlVahtkNld3gr0loismQ=;
	b=W0k8qGiYXC3qmyXcEsKEB1u8di8NXuYgoCk0blYbd3GrpT1OxY4wqZPmUhiRdTb7MgpckW
	gUqzqy0PawihWdALh7OYhx35PZarsqrXogF0Ki7wthDfb4sbxtR+H/XGMQFmOkhAap6Pwt
	3HRAPuHDMsyIZnZD8LOuyUlmVpWDO6Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1wWSIN48;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781684865;
	b=C1c1o7n0R83iW/1BUEPNyaIEdF5MjtW3vGLy8z2jrPKNM20z/iLqUYPEW++D0TuYznQwbQ
	gqf6oeWPmAXf84rHIf8voA2ScCKLCnIAdMXByS/0vD20yR6VJUHQunwJanEcF4OZykEJEQ
	i11mUQIJum9QK5VWyKcs8AK29Hyuq3w=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HixRkJ3rrk/W9Jdi9ELOZZkVlVahtkNld3gr0loismQ=;
	b=1wWSIN48oMKK9csi0pCdyRQLkFf2ayOv2p7K0Pvo/5Wba9he80PrpMimbyCj+w3IG6H/U1o+w
	G0fSdpgwZ0pvxBmup7QV1srjyov08xIeguQXAVx5j+Qn5Twzxb0c12DlUpd2QBPdwTAnVJPTxFN
	/CbPrGqSHsrZKLscSLHsVSI=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4ggGx554cgzpSyy;
	Wed, 17 Jun 2026 16:19:37 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id B93D840561;
	Wed, 17 Jun 2026 16:27:40 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 16:27:40 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 2/4] mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
Date: Wed, 17 Jun 2026 16:26:20 +0800
Message-ID: <20260617082622.3397584-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E7A620004
X-Stat-Signature: 1h3xpsish4yp4rgq4hk98i3wk46e6rmp
X-Rspam-User: 
X-HE-Tag: 1781684864-409676
X-HE-Meta: U2FsdGVkX1/Rk7s2keVoWNJ1gvsmbwLipfWyxcKrqwHcbN01UaExcotUGcqolr6Ncf6rCr4i+K/xZERrFJF0aTF3C33fF/mof7yhWn+NPcaYWEtbEiM3cmvtPD6p4QsLDD2XwUB9OvV2zT/3D58I3f2mWXUXj6XVzH0xsFrfxdcFbF6Ra/UjR11/1VT1S4Ot0T1w214nTv35V3pGISSuAGJ2Z+uqjN8s/ksaocjiS+sHDdPdh5s6BOXW8PXH0dMtPzDnE5ODICgZDlV3E+4KUAdjcpFujbQDQjd147YYwo2XjszyA1/GTldTy1UAo/0FTmIjV0ypOAZtG9W08KdVI5ck0/fPhMgWfullodp6nZyKvZW7BuzV5Xq6Hks3xxGrx+EI3Wu6xfoS2XXc6pQ+2gmYvo7mkXrVZv+e/E/oNcL5SRFXhgLaAUGW/HlGIqhlSNJPJ2nQDVV2nVufms9C+NGa6fLmwyxqzqgM/gUAy6HQvBeQen0L+6BFbda7/PRs2aQDzgwHFXDw+UJ3fLaKf59GaeZk4Zb8deTMmJGChdMivLUY0jgNRLv4iLunO1a2GnkDeS4NibIfZ0fEL1Dit26cjHCAGLr5fprRVguF8Lt/TB8JTDJ4XpBNDr9Wx1ZL2NHoAyNQu151wVPNchuLzN+uslT5bTH0Z1LRqv5No3A8Zx1meLK3PvHyi+g24G/5e0zgR/SJW64QyelHIMAp3X6zLDG2M8pwm1/NJJAUriklThRhE+ZZW3XfIOtTMWj1Y6YXI8gewrh248Fv4Qc1w1Ymoj6L4W33ClTc5PDhroZk8gv6kmDx9I9Ss4yAjdDt+9zLg2HpXeIffmNqrLcH9cINdEEaSSydaGUOK5fXTFsq69Ax3028/OXujOc4+hUp6rpCNYPy6Djc9vYfbNXw9r6/03fB+vSmwJQlKKcqK+b+4ZkbWh68igs1Atmham4JbgTEgM02Kgf45/zi3Md
 fgvftG1T
 7tCEYa4s7GGtRTvKDURigbr41ElhjoAZcQRq+EiJEGps61ULI7Szo/lPapTP+iE3oFd/brjLnxYEl3DNjiYHRwtH9bx4ZhzZzkJuWhS37j88fzaUnoXI/3ufhjh2NRS2FyApFEpRSbc/MZtSuAtqA9mV37VrbWTF09HNdOLnvmvlR3WNWQS1ERaTU9G8dV5dhFgbdhsFlTYT4BTuEKtOtbaT1r2HTJw35TDd/vOeynyRW7vFR80YO+lCN+nhJ/MLP1GGCnCdXQWLuwY4NfR2dV4DP8eKtSsAs1ipb1Abkywjz5zHjsRUyHoexGcAiOS/pN6ECbw8XLDr8OT53PgzywLlBgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mprotect_fixup(), the PROT_NONE PFN permission check uses
walk_page_range() to walk the page table. Fortunately, the caller
always passes start/end that falls within a single VMA, the
do_mprotect_pkey() iterates per-VMA via for_each_vma_range(),
and setup_arg_pages() passes the whole VMA.

Note, walk_page_test() isn't called in walk_page_range_vma(),
however, prot_none_test() in prot_none_walk_ops always return 0,
so it's safely replace walk_page_range() with walk_page_range_vma()
to eliminates an unnecessary find_vma() lookup.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028c..d26e09862daa 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -753,7 +753,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
-		error = walk_page_range(current->mm, start, end,
+		error = walk_page_range_vma(vma, start, end,
 				&prot_none_walk_ops, &new_pgprot);
 		if (error)
 			return error;
-- 
2.27.0


