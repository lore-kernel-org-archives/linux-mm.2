Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8862F94CB5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5F26B0005; Tue, 21 Apr 2026 19:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0CC6B0088; Tue, 21 Apr 2026 19:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB64C6B008A; Tue, 21 Apr 2026 19:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B44496B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:02:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AAD3C5ED8
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:43 +0000 (UTC)
X-FDA: 84684089406.04.FE96869
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6CF7240019
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QiFl/SLa";
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776812561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wpfh3VTTjIoOUTpMJKA6+K8v9ePL412U6DaImYXsdfk=;
	b=okEaKD0Im+EN92WHrY4CP5DCA/zr38VkKQYxgPUBit+/aCvlHwhsC/VKZg2P++wtR4S/3F
	nA65SpyCt1nuVJQ+FopKD3syHQTUZHCXPOp5ZK1HOQPTm3CZxtdgersI9HSIXHP7wQOF2Q
	KIT9ewxht9HIo0lXRPsFQU03E869dSE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QiFl/SLa";
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776812561; a=rsa-sha256;
	cv=none;
	b=JNSIHe3pNr2ukF1vKGahc80dKRVUlaGmWbFRV4FNO0TIL9Fwxd2dRl2nkcQUCGLUZ0I2xf
	Y5D8p6nWdUccF2cFmjh4GhGnCOjG1/gAMfPanUg15BTG2G9RpsHuGkeAbh6c7TO4ujPHh6
	FQgoZyzEvxbXPxf0TM+j8pbnB31o6mw=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-36146ae9dd4so3693214a91.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776812560; x=1777417360; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wpfh3VTTjIoOUTpMJKA6+K8v9ePL412U6DaImYXsdfk=;
        b=QiFl/SLadN98ma4fQzmvOsxqGMswc6Pi//xeVY0aE9p0VIlWu4dT9nwceces+J2rPH
         1P82SdnLMD+8X5tPFZvoL9NCrE38P5Yyg8wbTUga+lFzHE6VNd8EgvS7P5+hEC6/Tfqq
         rztcvJUbdlBmr7spEuDBsdNK3kYkmSY2klG920OBjCCLotOYTSiZWs2qzdcIm5NrqnjV
         EL4Hbib/qSZlTkyPw0q5jRWH2PmnxJvY0aZlQ/3wjbr/9sEZ7JktqIYzazhntGA3u9HQ
         nut7gg6VW/+fGGxOtZ6zGqArkW1ZwotWmEQJ9tFh5DU0qbcAHgFY5oR07y4q7co/lMpC
         2X7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776812560; x=1777417360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wpfh3VTTjIoOUTpMJKA6+K8v9ePL412U6DaImYXsdfk=;
        b=dezLbwu+q3adqom1MOhRI18xOUVZgLp4xmJ9DusC6M9fmC1Xf3q9te+7YeNH89TTVR
         1Ie5mo3YPDam3a40DJk+ECEGWwI0IGb4yvaBw1w8s2eZcJaGfIdjYGoboBzDsWfEccNt
         LBD4A0GedryCoucGK+z2j6vWKCpPyLBuWbPyIMM00eqodM4MMXG/VmCsixJZY8hMrt6e
         KnBlojnYPrmodCC6t/jtCO80+vEOOnIhxB2qU9bVSMp24s5mRlMKMJBvjKWjENQ/WROS
         4rHkyGVMGXMFMfn+/sXOOKoJ3PD7JGuQUcfOKHw4QIJYi3VEMl0SkfFS8A3tVhc4+Ems
         o4uw==
X-Gm-Message-State: AOJu0YyQ4DmpXnFQ2rUTKhBpgt2TniZXMmJ37saxcnXgUOBpiF2rm5Ox
	7TPtNEWbfZvqXlz/no3nv3Pj4rGOLm/+g1VQnI/H1rTDuk1lSv/8ZGZJ
X-Gm-Gg: AeBDieus9ifw5mrrdoF5uHgov7FON6kMDtZ+8Nza7UPooNr6KN8ihRVvREYQY0m9KLs
	AA332G6cZWJMNTU97VL+WHWxfsQuBdLqFwgtyQyju5XlHnu+DchmtTpayLKquwGj/xh7iMbqXmh
	ew0P8Jh9elkQA7O7LCZvEL2/2pDZ+okTHjN6BwfwY2C55yL9y6D+7qjvWqIeTU7pnzqSELp6nBG
	qI0o5pGQPBrapD8AILGwmp8noRUISVDeraI7BcK1xAWH/tI+NxhVZLDRfi7tRHHPTxxr4+zJDnT
	1xJMyfmugRknWj6BzjTvkivtumgSlygV/j2JaWrXtVITubXeTdKxmH47/H45ksCShQLiNhpU5rJ
	HRuLEV641pG+m1xMxCO0YD0LHLBHD4mej6PiWYdcQNPoflcuu8UDbTmTfrWlfYl9Y76X6zgDmap
	w9MIFrmMw5iB8ku6Q1Beh1y8NXKuzWr0EgFxSHt0k=
X-Received: by 2002:a17:903:380b:b0:2b7:8787:f492 with SMTP id d9443c01a7336-2b78787f62emr52224395ad.38.1776812559426;
        Tue, 21 Apr 2026 16:02:39 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab4cc47sm148400775ad.82.2026.04.21.16.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 16:02:38 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [RFC PATCH] mm/hugetlb_cma: round up per_node before logging it
Date: Wed, 22 Apr 2026 08:02:20 +0900
Message-ID: <20260421230220.4122996-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6CF7240019
X-Stat-Signature: zzdnp3pcxkyzige4bjfbenzrbd8phm36
X-Rspam-User: 
X-HE-Tag: 1776812561-116676
X-HE-Meta: U2FsdGVkX18UOVdvU/fNnVaybViVToS+255BwykJGSrhnoCoLplPGlUoxsv1l45zUu0bZRWwLXqjEUHBjxJPy2a6/egja6SkmLPJQH4UMy6pqLRZOKbZ1tZ5WIzQnJXyVp5/KYizHvqgk3mjPk3yn4mYMTO6IUdfC/+OOxYvo9bPGa323+c9T5Pr6G+wifzX2lEQaByPBIu/bO07f0QvnIoEkfuYnlgZ5K7wpYWDyjKjRydlL3/F41Am5Scd6l1WHdDuJGGmBsjtXBKJFhUrTGCfLfbuEFz+jV0O7/HGY70fBPhfNzBtaeqVkrlXoi6EDa42jkMDP1vQSkN7pewru/RVpCjl4xyK9Aol96v7njAPF8vevoZbVTNFsf/4d0YytBFTU3W28JLotjl1Yfcpet4LzNLW3ez8uVD18KeRDLKHcyNT1PsTPkKzzYooHD2vcfuz8Q80WGeeRhC6FVyXzVAK3luhsdCXsJuf0etuhIujpw5YtUPMx79lduz0m2x6cBU1RmxCFsjp5JkRtHcbDHTUjuj97fo6QL6Mm/9vIvRFNywIlZHZOzLU55FWzBSVxbIFEaU1hAGkJ7erMaHhb8hCFuaM+uLzKLPVz0DsmWiQnz3+ICPX5x+lreYVQ6YdOZOwX20Ix7Qg5+f+I9SA8hXCeUID+jZvLL91iRTaJglvCQdXCNylYu0bxktbupFgaR8+KHPlHv0Syz5op+x6t93on9e1/2DaWRABWtxLRScaW/Ox0Cjsts9ZLxNVl1GdbvuJ69c4rmi6UYwtVxi6/6SR7AxdUfM68hZ3SRpFKMLETJatqQ1azgya0kyLd2jVgeAqxvBt9F9R5Cu6G6UQa/B7zdT4dxfe7w0PIOuyOEydsYYDkP/d2UXZoKOlZPWgmF+H0ok3BwKPHvjVTph5PyQbIsPgR+uB7EDCe4BMrADClHJQ0h5HqTpUjRwFawmcu/etCo+sY3kYtvfjKI1
 UxMoo2EZ
 a6KS3cYgoCAIYSAvUSiqQ7ow4xUpPR7kKhtHVDv9gQeM/7gblE/On8u/Gfb3ahbCutoHTMpqs6Gz572SEw6V9w7wSdfD4DUtM6OqfJH3kRrcvoLnwdXvDOOehhkCXkXmlpygV7UpkITo6IZKtROm4d838lukkC9wrugki0F6Y/Rqh9ywGraALiKWl5RXp6NkoBAjpiPpww7ItsTUigJQswKy3P2HbkSUee4kYU+VCENIzBEKTZiz5GwnxejnpksXmcp/KUtccCg7gpO4cGwOKaaAYmfzQ9YdGmtCU1uE3wNhDPxpv43ldqtCtMhfsh5rPSDUVMdfPhAwKzPo0hEQwX8fvE9QJJyqluvjrLL4F1zOc75KT5hB1sKwiLZJwVcaDxZ564ay2DbiKddPheWrHIJUYo4d4/vFIoO10
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the user requests a total hugetlb CMA size without per-node
specification, hugetlb_cma_reserve() computes per_node from
hugetlb_cma_size and the number of nodes that have memory

        per_node = DIV_ROUND_UP(hugetlb_cma_size,
                                nodes_weight(hugetlb_bootmem_nodes));

The reservation loop later computes

        size = round_up(min(per_node, hugetlb_cma_size - reserved),
                          PAGE_SIZE << order);

So the actually reserved per_node size is multiple of (PAGE_SIZE <<
order), but the logged per_node is not rounded up, so it may be smaller
than the actual reserved size.

For example, as the existing comment describes, if a 3 GB area is
requested on a machine with 4 NUMA nodes that have memory, 1 GB is
allocated on the first three nodes, but the printed log is

        hugetlb_cma: reserve 3072 MiB, up to 768 MiB per node

Round per_node up to (PAGE_SIZE << order) before logging so that the
printed log always matches the actual reserved size. No functional change
to the actual reservation size, as the following case analysis shows

1. remaining (hugetlb_cma_size - reserved) >= rounded per_node
 - AS-IS: min() picks unrounded per_node; 
    round_up() returns rounded per_node
 - TO-BE: min() picks rounded per_node;
    round_up() returns rounded per_node (no-op)
2. remaining < unrounded per_node
 - AS-IS: min() picks remaining;
    round_up() returns round_up(remaining)
 - TO-BE: min() picks remaining;
    round_up() returns round_up(remaining)
3. unrounded per_node <= remaining < rounded per_node
 - AS-IS: min() picks unrounded per_node;
    round_up() returns rounded per_node
 - TO-BE: min() picks remaining;
    round_up() returns round_up(remaining) equals rounded per_node

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Hello,

While looking into boot information, I found a minor issue.
I am sending this patch as an RFC because of the two additional
questions below (one directly related, the other indirectly related)

1. This patch only fixes the log output, not the reservation result itself.
Do I need to add Fixes tag on this case? (i.e., Does this patch need backporting?)
If so, I'll add below commit.

  Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma") # 5.7

2. When node_specific_cma_alloc is true, the reservation loop can break
out early due to round_up() before all specified nodes are reserved.
Is this intentional or a bug?

For example, with hugetlb_cma=0:1300M,1:1300M,2:1300M and (PAGE_SIZE
<< order) is 1GB

  hugetlb_cma_size_in_node[0..2] = 1300MB
  hugetlb_cma_size = 3900MB

Actual reserved size is rounded up from 1300MB to 2GB

  iter 1 (node 0): reserved: 2GB, 2GB < 3900MB, continue
  iter 2 (node 1): reserved: 4GB, 4GB >= 3900MB, break

As a result, node 2 was specified but no CMA area is reserved. If this is
unintended, I would be happy to send a follow-up patch to fix it.

If I misunderstood anything, please feel free to let me know.

Best Regards,
Sang-Heon Jeon
---
 mm/hugetlb_cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index f83ae4998990..4a92a9e38500 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -204,6 +204,7 @@ void __init hugetlb_cma_reserve(void)
 		 */
 		per_node = DIV_ROUND_UP(hugetlb_cma_size,
 					nodes_weight(hugetlb_bootmem_nodes));
+		per_node = round_up(per_node, PAGE_SIZE << order)
 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}
-- 
2.43.0


