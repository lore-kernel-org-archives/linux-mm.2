Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27980C624D6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 00:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1DE36B0088; Thu,  3 Sep 2026 20:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECED36B008A; Thu,  3 Sep 2026 20:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD7C6B008C; Thu,  3 Sep 2026 20:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B440E6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:00:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33233140637
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:00:41 +0000 (UTC)
X-FDA: 85174123482.08.8F17034
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9BC251C000D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:00:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ei8m0uBo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788480039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+5woYkXUNY0sBD8Nd9g38DB9w7LM9BkTTq7V7hAdS1M=;
	b=uM32Yrmi4z3tERSmQ1ifT7RWc0zsmaAc95C7e4laFuyxryhbe5CrU201verD0UFfSgqv1p
	XmOB0lhCQHVQra6C1mxJkxE1Wx1QG6U3ODEpGfFe99RY7tnHBenJrIRsmxa7C+jdpNWGvI
	EZKHVprf6niq880ICatMiBUkNOCgUOQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ei8m0uBo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788480039;
	b=7wb17x8JPUm7KoPNGCCeGkUmOlQAzqUeQ7rYkt8LHpiVmvdHW8aJv9g6o7MoZeT8QLYEa4
	f3H5DzuRAUuGt5uLKCeB+M7UDvjkqaqgePBui061QiU6jRzwRlIs5VhjFqwMBTLh/7xLHn
	tm/qU1zwiRUpMy3V1Mbpgt/1MOpSPzs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5EDF413D8;
	Fri,  4 Sep 2026 00:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C75F1F000E9;
	Fri,  4 Sep 2026 00:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788480038;
	bh=+5woYkXUNY0sBD8Nd9g38DB9w7LM9BkTTq7V7hAdS1M=;
	h=From:To:Cc:Subject:Date;
	b=ei8m0uBonvKXcFnDJcHgd9rBUbiEcRLvrzjehxC9ABGynj1ZJRS3lVJ+Fkvj+oUFX
	 CTrKNMzxcN93I8HycylEENMNtX6YLqQ/JHUIMVIuF1592XMFAcUof936bCNMUD9PJf
	 kOiDa7V7oBjPldYvpPlo6dnxy0wYdZ34rxnEkDpYNsYUPTucKQDefjxZHYaXOBAA8y
	 B7XGRC91T2tHAAJDf6JjyjEUl7J6Y4mzzh6Kp+3qpOQq1hmK/Xv4ZZDr+Gz74+IYt8
	 q0XPFBNdnGYv1dAXIZty/OHvQ07pZEPJHKGX0/Lm4LmAzwllUKvtF4JZlkmwaIkeUF
	 9qYR2VJA7+Qjw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/memory: fix hugetlb_zap_begin() call in zap_vma_range_batched()
Date: Thu,  3 Sep 2026 17:00:26 -0700
Message-ID: <20260904000028.149656-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BC251C000D
X-Stat-Signature: fkqci43egd96bbi5t9sitpchwmn6tk5x
X-Rspam-User: 
X-HE-Tag: 1788480039-857833
X-HE-Meta: U2FsdGVkX1/MfpN2mHkZ0MSzIcJG1K2mhLxOEfZ+G2ZfVTvuADTLKfoFxin7kUpMBMNTsjxx9Dtrc0ScAgGLAx+J9TixhvqxMZHLqfR5iYw1yvdxbv9D1pZeoQccyWpZjBM5Ac/n2UBtM7kktZH/706tnL933JaiwUPxo5ZUXyPwwvWrAjrCv18yVOvXBn7Aht0i7z5qi36fuXFsKcHowvTZ847EHGrdynw2KEOvReXJqL3Dd3mqX5zJmtdZ2mOw8pfKUoNj3hN/ERdeleNszyzZUKSNhum2I126SOn7UpBekBa9u4iWVcqjnufkca6MGSAGIE0dYjZnkWzTa3Ekho5PnahpJra/+QV5DgSC/vDadULo2/zU1HQT0kF7WQOIomvOM/BIDNWY4lUEAGEu4vmMW47IbrBxjyD0nPG9g7Tq2ydf4czA85O2uBFGNb9n4F9VlDnL6xPPTBBwdDhnNc7i7PerVUJHmOmMuwKBgyM3iifSejFlzjyiIXFL7ZeH89N3vVfubBsT2d1U1/TAlFTMhQJcgjb+S8v8xqdjPZHsszXeYv64+Eic3hoKc3lZcDh2kS/96HlBojI5V8k8cX9GNbOsjtydVTX3WHjNVdoP1lNgYcTF42OkRoqucmVPr9R2SJLXWi1Jmp1O95JVQr65naym1qZLUXaeL4yGTJxiIkl3WkLOB/3/gwjvHW9ExLKvy8XXjTLE7cDBV0+0F87ojXyQtmE49MEkRsklKyx5L1+X1P2oiSdo5/468Dew5LaNMuPH4EPhJzQIOv2Kq6pDz8Wiu0mgv9KLoMBtNThd6RjYiKh7QdR8TvG689ZC5MQNWqVZp2uQ4a+SpaxlaoNqis8iGojYWW+9O+zTRq+EUdmu4Q7XCQbx4JeynA8+RH60lP4sWLAr7TCMF9A8cbhmda6ZniJZkK5i0AIZWloo85aX2ZA4MV2NbecV8ZX5AkD7A8fuVOLImlRq5qt
 By9fziGv
 QVSoz8lU/Wnt6W0yMk3FVfmsaIHvbP7VssT/Xw+vMvK40RSxIDFM5P04Ci6ao/QJ7d9eekzE6Oxb0GMawRdlaeowS89U/JLnT2fbk7+sM/stVmeEJX/n/SbAPqtmWhCvnULgZBa27PK4NO/z4b5XiCpHCxbU3rnW170OPe3plDT56SzEhuLBblRY+kOO8f9OJZ/5gNI2/L7zgeqeddiLxWOaJkDj8njxHOQxocg10Zz3k3O4hZwGophkRcP9zqTF+5XcC3Rss3c7c92ZBn8UCeWsrFvlcwp4e4UZdBNHNyCW4B1lxiehEIB9vEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during
final unmap") added zap_details parameter to hugetlb_zap_begin().  But
the hugetlb_zap_begin() call in zap_vma_range_batched() is not updated.
As a result, build fails as below.  Fix it.

  CC      mm/memory.o
.../mm/memory.c: In function ‘zap_vma_range_batched’:
.../mm/memory.c:2308:9: error: too few arguments to function ‘hugetlb_zap_begin’
 2308 |         hugetlb_zap_begin(vma, &range.start, &range.end);
      |         ^~~~~~~~~~~~~~~~~
In file included from .../mm/memory.c:48:
.../include/linux/hugetlb.h:253:20: note: declared here
  253 | static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
      |                    ^~~~~~~~~~~~~~~~~

/* TODO: move below to commentary */

I didn't read the broken commit in depth.  This fix is only
build-tested.  I wanted to report the issue with this as a temporal fix,
but the broken commit doesn't have Link: tag.  So directly posting this
temporal and not very well verified fix first.

Fixes: Fixes: f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during final unmap")
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index fcf893f4b55e2..151a1bf512e00 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2305,7 +2305,7 @@ void zap_vma_range_batched(struct mmu_gather *tlb,
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
-	hugetlb_zap_begin(vma, &range.start, &range.end);
+	hugetlb_zap_begin(vma, &range.start, &range.end, details);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
 	/*

base-commit: 2d1388907095f676b59fe6dd22f244abc08408cf
-- 
2.47.3

