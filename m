Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA74606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TIJj5UHr
Received: by kanga.kvack.org (Postfix)
	id 05D446B05B3; Thu, 29 Oct 2026 05:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E026B05B4; Thu, 29 Oct 2026 05:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66236B05B5; Thu, 29 Oct 2026 05:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C28406B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:19:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB0851C3168
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:19:30 +0000 (UTC)
X-FDA: 85375115700.21.3E149A6
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7696C40006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:19:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TIJj5UHr;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793265568;
	b=geOO1lrasIQbn6OSoYoJTT4+ASJ8xyvKDEICmM+CIaJB9sYlxbEnlj79OqN1T8b0iXA/mi
	BVDXIyrSziz+JexIyY2SAI8eg3/hTjtJGqfXzv3BD42qyDawMg+YVD05tQMHY2qg0DereH
	ddsbGy6crvTQPhd00LQVq1ZeuOKCstg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TIJj5UHr;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793265568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1+HNg4GxAnYIKh4c9wgbbtWDKA59dTO5M6YtuRoSCM=;
	b=sdZ5LuT9ODd2F0dRoBAJfB7u3y/cFOI0SnPiY/kCdqVOmKFh9GRKcppRG5LuULS9YVHBw8
	5yG/IJ3RlReN0X3zFuM6ZKljEOnxofjNcd0UHqijyhIo4uZrQTDylYf9SlfJ0RWDlVlDeu
	ElXEkPHHGGGPafvT6kX2aQCPNisflMU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f9G3wbBJcJEnE9ab3Vc7C6KZ4odr0LAbZB5DXG/9MZg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793265567; v=1; x=1793870367;
 b=TIJj5UHr50AuOCWtV9yYJmlh4vTn6S2QrFOeZzf1tSW9N4+pmgHLntBoIfb+0W4XIrPjm72y
 hNDY/1Db44uOE7TYgrvnrFks8dXzWdST9bHz4uyIuRBdNVf9IrljVBysVGnTbKLei5Kfl9L1pSR
 /bd7bbvYDD2rZLD0puVlXS0s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 80beaf41a08f849a;
	Thu, 29 Oct 2026 09:19:27 +0000
X-Mizu-Trace-ID: 80beaf41a08f849a
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Thu, 29 Oct 2026 17:19:07 +0800
Subject: [PATCH v2 1/2] mm/vmalloc: drop VM_DMA_COHERENT from
 remap_vmalloc_range_partial
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-vmalloc_remap-v2-1-c4705cbf26c2@linux.dev>
References: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
In-Reply-To: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Stat-Signature: 7o8fmii8ihidey7utj8fz77151yxtc56
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7696C40006
X-Rspam-User: 
X-HE-Tag: 1793265568-795704
X-HE-Meta: U2FsdGVkX19DO+hQ6AWtB5WYHR6FvOazvoYkkrTElI4xZQs+p6h+fIoIOsVK5tWEI1qyLSjEmpG0MvbRhwT+YWa6uh5zGjNahKAnMm/4qD4rCyTRv+pOxwfdgrW9m9e+B7mN4NcDYGI9EJuoDFOUK3j2zQNBZRvF4IKsGK/EdRLqorkC1V5IocYpILww+LUlphuCqWsSKLMBtMkwwmcMk4/4hHKN/ZHfd/qnuET0vsrhJ326AGONdnADmlg3BtyI0Yb4NmdVjIdQybPSB1iPFsVAdoFL5wGcDNmhhMY6ydKIY6G6Dyk1hEU0/NU2LEmn6kBgQUcqVUxrfFL8cfjXpeu6YI0HiJp2wJvZbKxqDXy7ukMxI1kkCmBQsgzcSHJEZJaPOjgycRLIifAZWrBQdqdLtZaqd+k2bDaljP8bp90l3s0dHzrGTvSPfdDW7bDbQDQJzR/T63nfUyphW4nnyvLraLbV3v3c1yCTr/mhMnjwCeuAQk8fBO8PD2ReemhIYKg3MsegHM5r3Gh0WykdQbPanKzM3Nv2PEYqmgtq6ZC0i1mcdmt9HS+jHJt/toh/RD9/8esNDvm5so+ufMI+h2hbPnDwyCZH6KBICLbxkbSc1nYccX14184hEAo8KeAsDigQBfpznQ6h2EEVNhJpGC9zWT+j+I/70oN1pxbBm81CInnrhefgr9t3XB07KbFsc3zCVvvqUGgozditJQ5UkeiuUYw7Z8amR8EdB11EN0Zv7Pgna/LTWD3GkUHCpaZMM9NyEEqyOspJi9djlu7FDsU73s+ARek66yAnelFZguiEzWEdnvycfN/zApIsP6gBKFJ+uh1pY4yitX5L8GbAMBRfWf+p8RuyQv3ekj6fD9tP7xSLBgVay5qz2wHidZt0gSuCIP0LLsqXmGbeGI80kgfQejXfB9Kra4JyN2P2Q0pqLE1lXLX5srlA6gGy1kGelHYDGn8pybMRl+NDrK6
 BdBK2+pJ
 IEPNX2ZmM/t+/Dg35tG9rwiqUGP1pkKwmE+5OxCJ+W+WtHGc5oaEgBkub/tauKevlWVhfbzA8yRUrNNW+zXm1+YMlYFlZA/Z8GfqZiRPVJkRmip3YpgnXerl83/TKyTQfhgPjASz///EzJQg9Q+srSl+xccj80/esKtxQ8EV2W1c3YfpD8IRHd36VhYCLuURFlcmz+TyWDmvAL1wh0F0fXyHBhxTfKV77F2ki3y+PBpcXLm2cBq8HTp5LP+pdlLUZF+bJC+zUMqEwpndczclHyFdSeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ye Liu <liuye@kylinos.cn>

No caller maps a VM_DMA_COHERENT area through this path: such areas
come from dma_alloc_coherent() internals and are freed via vunmap(),
never through remap_vmalloc_range[_partial](); all 13 callers pass
vmalloc_user()/vmalloc()-backed addresses.

The flag was added in commit fe9041c245196 ("vmalloc: lift the arm
flag for coherent mappings to common code") as a mechanical
translation of ARM's VM_ARM_DMA_CONSISTENT.

Drop it so DMA-coherent areas can never enter the path.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index db669103dc66..a888eca016a8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4894,7 +4894,7 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
 	if (!area)
 		return -EINVAL;
 
-	if (!(area->flags & (VM_USERMAP | VM_DMA_COHERENT)))
+	if (!(area->flags & VM_USERMAP))
 		return -EINVAL;
 
 	if (check_add_overflow(size, off, &end_index) ||

-- 
2.43.0


