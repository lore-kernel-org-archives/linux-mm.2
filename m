Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDE01CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 06:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767A78E0008; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F14C8E0005; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A75C8E0003; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F93E8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC14259D81
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:09 +0000 (UTC)
X-FDA: 84017492538.09.4546DFA
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E212C0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PxYsXAKj;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760941208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ce/fKvXZzPgrtfSDefPd5WSi0xQQuvq9E9UTugKiu8M=;
	b=hTCgvwq7janSFOVPV7V+u83CzGx5jg+akJ7rOn555t6wBZsQOJ802HwmihYhpNqfaoSfgn
	vfrv63freoJH68VPQHjl9d1Jg7dVBpXpV7SObZ6ie4pOb+dey9EtSIuD3y+a4jrCHb9evZ
	tdiaIt31p8Tp0ZBoFv0xRy6XLiubGHY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PxYsXAKj;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760941208; a=rsa-sha256;
	cv=none;
	b=cGCRBJZnmSQb30ii7NJM7qbWRZVkr9c1hoTJWr0BZk8uj7hxwhI9VFjSXv2PuTrMQ16ILz
	c7lwEDiqzUrgiCZnr101+IjKyGlOicH/5TQlaNQUCKZhRv87nP4jh/zpm+aZiTPV+EcqZW
	uqkRzIYwuS87j8sjDqUCPXnsIL/sEfg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ce/fKvXZzPgrtfSDefPd5WSi0xQQuvq9E9UTugKiu8M=;
	b=PxYsXAKj+WZnKQdrPCGmTGTpLUoqy5s6cv1AsnIB6Sb1LFA+FMJTwlR/PdXmwMz2xzLQAN1f6
	CiypdaQPTgj3SbY43EbXn319MzSO0Pu9ulHxIQFX8R4YAoRTKRGX7DPPf6rlpW0aHN0gJTP60G/
	qyoDospQw7HvqsC0QoE7qR0=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cqldQ0RLtz1prLM;
	Mon, 20 Oct 2025 14:19:38 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id B45E518006C;
	Mon, 20 Oct 2025 14:20:01 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Oct 2025 14:20:00 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v4 1/4] mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Mon, 20 Oct 2025 14:18:42 +0800
Message-ID: <20251020061845.3347258-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: iegm9b3tez4us5tz5fjez57j894rur1p
X-Rspamd-Queue-Id: 6E212C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760941206-754229
X-HE-Meta: U2FsdGVkX1+TjWOH1QQN58iEWt+UHros3zEZBEqhKKYSJwPfaDdzgwe86Dub6UvJ4rh0eoBDZ2HbFIh28ltdSiPIDTgbXbkI/GzJJQRTfep/Ymg0eYk+Do1BSasLWmeUr2UtNF2akzG5NTcn9mmXW1Kgx/9vpvZNbPNlVI9dL9nquYdzw+P8EwSeELNCS997w9E8yV+0rt9KQt00e8KLEwRRg4JLvvYEDl2fUEsIHtzkMxUE83mKlcBO2Qsx0IRG5C1J7u0hj8gACXTU9rjWVC+JbINFVgA02tmRuKuxohBpWLsrzy/9ndMf8JQPO0HfvHTBETXTtkIZxWb8r+VBvGvLDAMTERCRFyalwBAnHkHKYWL8QrrRaObns7mrkMYkffDQMG+NXOdDGHUEy0CZDX3e+jCStn41K0Bk22y0qLCodTexS2Kf3+moPr7keZMUHwbi0jn6lOWX5vAu13NrMgdMJt9VCQ3RT34j8At3XLS5p7IRpMvNethG//wBJF436rrslCIuGkSNkQ+zyLV43tzHEVRnxrEi6gSk5N0ewEuTTAit5h6Em7tLPaOXYKacliLTZaUU77LxpxZCaB1eI+hlW9c9/+aCUJkD5D31DZNrA1nEW++NdwR0wq9pDbEYWyiFOFKaw3LYJXYtL2DaxuqJnGrsbo6wu7m9snLD+s0E5MZZu9ItR0qGAFpYFXc1W0swTkxM/eiT/gpjTuXE5ZJtiLL1/OtB1rkxjz6qvgHIl+fwlBII+XyXLRIZI3wBnkUu17wVBWwJI1XELFHp+TlTKIHBC5AGqKX6IPiUBr0/oVGuKL3mAVmi/itrR923fqaR1lsRU/hZuyzo8X55yQYt9Ms5mzsRq8WVjufAcxtcCa71utTDer/1M2rQAstj72afPwwMGUE9t5A2FhEBj/1fo5+up7DE1KA/CWraP2vwH9Heob0TKbVhii53v6gnqX/sR+K08Mr+YJTgYi+
 eIBO/t0j
 +uZ0TCdBt3fVrzDY/3k+T4KG+N2JsDRx8znvpGUNx2tUvkEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the folio (even not CoW folio) is dma pinned, it can't be migrated
due to the elevated reference count. So always skip a pinned folio
to avoid wasting cycles when folios are migrated.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 988c366137d5..056986d9076a 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
 		goto skip;
 
-	/* Also skip shared copy-on-write pages */
-	if (is_cow_mapping(vma->vm_flags) &&
-	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		goto skip;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
 		goto skip;
 
 	/*
-- 
2.27.0


