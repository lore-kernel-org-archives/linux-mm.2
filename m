Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7604C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC73F6B008C; Mon, 20 Jul 2026 08:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E774A6B0098; Mon, 20 Jul 2026 08:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3E16B009D; Mon, 20 Jul 2026 08:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7ED36B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:43:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EAC914016C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:43:09 +0000 (UTC)
X-FDA: 85009120098.16.3B95530
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id C10EF12000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:43:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4M1CtP9Z;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvnMsH75BzLyLzw2Se0FFbIlNBhTvJL8or25tQjpDPQ=;
	b=YqlhVnzyhAy6fwy+Z9hqD6LKK22ZhQ6EolxnJlAM4HG8TD74pc01OC3+a8yGSEYlDXUPmt
	045GvrIVFg0PQv6lBdhKeRWUSGVZ4L0uMPJphrCcUY+GkXPCTb/MRwdNIfdIOoX5dNIPTy
	hwbWMcdlZt9RGuMjY9tPsJRtpjqDiuw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551387;
	b=s+8qbe0jdzwZ5OooHuPqyhzn57prJkvc5dSAfbBlY1E/9ovt+g4hoUEKPKmTdph0JQjaWP
	hEh97rDddCN9coTPJN2B77B3FpPKYds/3auyMPH2JFC4GOS3/9JEuW/nZCoq4aZsr4O0VE
	d0Sq3+0nG0jx0kYpS6eZJcGG0TON/R0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4M1CtP9Z;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VvnMsH75BzLyLzw2Se0FFbIlNBhTvJL8or25tQjpDPQ=;
	b=4M1CtP9ZfftZIIQHUVWox/zEwEoYZse7tNnIZSXLtDMOSuXbNvja64Ca0e2ev1lnuScaqbyCo
	z0mJTrvvNRvKcXdMGK8Qc7vuA0Mp1LMSPWtuduNXp8N1Uw5zqa5wdBpyIwxf24UBtaDUInPOzK0
	e5GRuO3REE77b06Gynq9RUQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h3g0s6m8yzcb0W;
	Mon, 20 Jul 2026 20:33:33 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 51BD1202E6;
	Mon, 20 Jul 2026 20:42:59 +0800 (CST)
Received: from ubuntu (10.50.87.83) by dggpemf100008.china.huawei.com
 (7.185.36.138) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Jul
 2026 20:42:58 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v3-fixup 5/6] mm: mincore: fixup improve mincore_hugetlb()
Date: Mon, 20 Jul 2026 20:42:52 +0800
Message-ID: <20260720124252.1483984-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260717091347.1144789-6-wangkefeng.wang@huawei.com>
References: <20260717091347.1144789-6-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: C10EF12000A
X-Stat-Signature: cbqzkz6w4fq8k9wk7mxcuc43nmmqce6z
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784551385-461322
X-HE-Meta: U2FsdGVkX1/IDQ8lEhCsaITYPrPEjSsPv0FSC13pjbxBTa125B8N5elJaQ9NBAWX47jHxE9tgCTnQPY0PYqBEwdWTxYPPMbVTsSc0lIYoBOqSQqK77PMu/kvdY4rqCzEqEuBOEb6oWZiZAckoBKN34GIMRCkGGHHQfJ8VxmpgRyIUtRHwT02WgsGdzWwbunvgqCgRd0o+B64dy81gGXuIcxsaCaggl0rwdDyjF9mWGL/Dd1Z3vVNJO7qvJv7BDWPMEt9+1mJOLmvrbDaN6OLMs/QvUKbqYl4azMJMRC4pGVBwoTXg6BSbIE4+VGI7hl1//MrIiUuZhGWSDTSU8MsCimyZLYSC6obLpE8udqe3bIMAGuIO52skiSoL2voeV9hlvbX3eFJPA9MtfD0LoD6lCAqPnQvSWYopuzZgSXUhYP4v8yO7LePyUr2cZUrc0d305xIgU6jBvzQ0MRPwITy6frmvWagM+r1VlaFRGxTRx+vBAgXoLK86abS7MvSC0xQPh2CbKcnipP15ZStqZ8mtEIuD1kgtmo5jRJ5MuDsWqhmvEwy/Pd6H6IrBJfuFcs91pzGD4TIzrxdjMOXMS8iv6DgTU2Rp2nBrWH96OOq/j3fsak43zL26H2K7UP6R3qrxnjUmzK/ZyWvzbEqZwttf0Z+skEUaF/EPTo4VD1xQsCBfpXi9e6TgbfCBD4aREypo4rroXFMqNZK0ysjvf1d4y05/ZjmrlPtr9EaW1dVdKFdVNuit3PC7dBAJPwYlhiUZ6Q1x2IIMzqML35xer1e1btNrmTBy/FCpMSJiCRRH99KUVDRV88sXCNpgbvIvqKnhfMPXg4CgxdLxC+sF/Rly0VofFuqh6mWuwHAz4/j1WYMyCQ3bw5XTgdfKtSZxq6eFqsLc6DYZRKv2FCjWMmG00YZ+8Ps/iS1Mh0/xYOvFvhJYdxApIDhdaVnzxMoRcKX0M530niJuL/muY0ASsN
 7OtFZCgL
 JcrWWTRmVOC7i//aIGt7iw7iObnMTcZftrnnEnniEQndwdoyL4Ri+bBm5ivYHKiitvEqxkQhpr5j1Sc25EGEZF2dPRp6omy4SZTyguWpa1S0kk+P6wE7XN2bR6I7pb/IoWoAMuLHZc85nXC72mvvJNcw/hebawXht4WQbZxsyd1McSSkSN4eq5yv2tu7iX46N0ABRZwC42cLgw/q6UN/1tsCb4F5WNhKtgNg31+Mzm3ZT4ol4gYHYiUvxXRsVFe7jFbwVqMcF2P6nPG68OL+88JfbMqyn1AKZzwHU7Bspf/QUC3au6GtRTMVogSASC7nH9dCsRwy+JZp+zkhX1FwYnzkZyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- change unsigned long nr to const
- remove a local vec variable

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 9ea81638d09f..ff4ac8281768 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -28,8 +28,7 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
-	unsigned long nr = (end - addr) >> PAGE_SHIFT;
-	unsigned char *vec = walk->private;
+	const unsigned long nr = (end - addr) >> PAGE_SHIFT;
 	unsigned char resident;
 	spinlock_t *ptl;
 	pte_t ptep;
@@ -37,7 +36,7 @@ static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
 	ptep = huge_ptep_get(walk->mm, addr, pte);
 	resident = !huge_pte_none(ptep) && !pte_is_marker(ptep);
-	memset(vec, resident, nr);
+	memset(walk->private, resident, nr);
 	walk->private += nr;
 	spin_unlock(ptl);
 #else
-- 
2.55.0


