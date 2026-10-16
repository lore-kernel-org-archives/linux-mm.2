Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4281CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801EA6B0088; Fri, 16 Oct 2026 06:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1316B008A; Fri, 16 Oct 2026 06:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDCA6B008C; Fri, 16 Oct 2026 06:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF3F6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:08:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40634A7BFA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:03 +0000 (UTC)
X-FDA: 85328063646.03.1FECE73
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5DA7980005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MQf7W0nF;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792145281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dRaBZ4Wnf4MZxIj7HRRtZzh73axE+AkcQj1zppMo21o=;
	b=drxhnlnp1rJksZl2iJCCH+Zg/b9wDZRvUQSPPGavm6wT8eF/zpILf3rrc5fVe0M+hVmtTt
	sopVY6o5aWLzzWgQqn5fjK+/kLFJLeYME43uuoXr+kYl71Vap7JeTyQJAEL3tbPs5thwJt
	J8mbGxhBlE0CJnyxP0jklBD2XnefBL8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792145281;
	b=c4yqamrFElBK7JzTzjFkhnBumb2sTXemJ4CyWH3eKwTxRXFEqeB3FRzSGEB63GYofK7jPp
	cDgBj5DjzRC2vy1IFxi9O9JZwYQiWmwZuM+dTIpkei52vULliCDzBNnykljuRakMsl9gKF
	lZPxGz5uBGxtoN/b3YQUz6vlRVz6fSg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MQf7W0nF;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M5i4E8R+4zkQmXtJTPgvfcZ/9TP4y/h6sujbbR2qN60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792145280; v=1; x=1792750080;
 b=MQf7W0nFin7uRaO3zdWcEFEsObxHhp+gEpFeacB7wkDQiMVyxkendkpUTHkLYgapvuwq5Kvd
 DMSg9wQ6BA2SKFPVp7Z8X1Lu8XuB0/XI3jP676PA9jXxsJiC9z4KbK6YYdOcgc40Vpsk6i5a359
 hbID2qhZLdx4e5GCTjii7kn4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d2bfab94065a6938;
	Fri, 16 Oct 2026 10:07:59 +0000
X-Mizu-Trace-ID: d2bfab94065a6938
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
Date: Fri, 16 Oct 2026 18:07:31 +0800
Message-ID: <cover.1792136742.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5DA7980005
X-Stat-Signature: 6aj7x3ci9g7jbfwwdjb8j3ydhwuge86b
X-HE-Tag: 1792145281-59571
X-HE-Meta: U2FsdGVkX19NrQMHCezo0ew1giT/lBsBOpkBXzUm5jVDOpNS+AdS09clTYLvzGyg2tRsQRF85WeX4LgR2KvfSiq7vVa3CgSRWyoMXSDr6Tm1QUvZALnbCjbRbVF37chbzI0QTv++SfpGw/JctJ0V434C7sMls3axmfkOZNTV/puD/mqXOykN2bAongwMC41BAR/WDtEut2dk9aOgwm7O+WeOENDbxlaX5pi0a/bujlzWQvQySdrkVywVywBXC7rPl2nZAZbV0xd6CqyulXp8C+pzvJH6sY52oRMib7RdPsaQs3dTHjihZoyfklork7Edb4aPPnR2tK6hZiPf/g5FaV0N4yr116SaKKSPWwB34wLRznpC8696XesgUgRPaYANGdmURFvEuKuq0JIN+Lg64HdMQu42gsGr2ZYH1rTZ+tSSXV08iaHwaQPy53A+gddO/2qP2mKXS7Twg4vVS52o5J+jvzyDDATH1MdtdJQTZjLqXAilIs+GfRQtEu5bJ7dOAN7z7GHvUQi8pfnE8rq0ZRI7AeYjft6WFHHEHVRGjMxTmmT80s3iIqHlPMLgsJqrvoL1NeV48n95IYot5g9q3HUqLzlWwUJt77kfO2DN5Un/P/BDEPBqKRi7R8Ak1YOfZ9E1C8P3rx6jQmphmBuT7jeDjtabxL4Npt8p5D+vhIC6o3kDNeCUb6hMo/j0aUSnC2AFr7emTqPvnLOH26zDhnDbsZaYjV7RPAQyXIQAHdu1GwbMufYNjEDLVBKwy9jPV2wLljVze1TbUPm7+YZJqXNumj6wuxL5JQ0E2cUCd0YNzCwKgQ9FQdkP9rAgiA2CX9LdCEgnxyZuotR5ONcFB/hMUM0fMCsLKHsozyi/doI0lHg4P7uMfLhvire7cU+BaHWFP2Rukzk09tDSOWdoBA4iN+gdBOZ4jVFz7A2qwGB57rV1rXGar85SfmjrelfLhL8l4fFkYQUxV9U3XBn
 S3FXIfY0
 OXZ2/WOptwByjFuJ/ka8IgMsEDK7XaKrieQjTEgPby7quCCUPCFfvRTg8HwjYKjGjRVABxGF+u46ZctDAFA8hRswa0P2erFHv9PJwLCrbwUMEx4PJu0mafISA1io3XxdA6tdyaCo8CFkvobrmy667BAFK1Mp3jtCjIVKv3nwRaYIbx2mEgvwkcHeTRquP5QYi0upY5br1t3lqoBE0FNVAVgXCMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

Allocating PMD-sized HugeTLB pages at runtime can become slow or fail
as physical memory becomes fragmented. Reserving HugeTLB pages at boot
avoids this problem, but keeps unused pages unavailable to ordinary
allocations.

Live upgrades are one example: they need additional HugeTLB pages only
during the upgrade. HugeTLB already supports CMA for gigantic pages,
but reserving a CMA pool for 1 GiB pages can fail when physical KASLR
and other early reservations leave too few suitable 1 GiB-aligned
ranges. At runtime, 1 GiB allocations can also fail when pages cannot
be migrated out of a suitable contiguous range.

Extend CMA support to PMD-sized pages so their backing memory can be
reserved at boot while remaining usable for movable allocations until
needed. This relaxes the reservation alignment requirement and reduces
the contiguous range required per allocation.

The series adds an optional @<page-size> suffix to hugetlb_cma and a
separate PMD-sized pool. For example, on x86-64:

	hugetlb_cma=4G hugetlb_cma=1G@2M

This reserves 4G for the existing gigantic-page pool and 1G for the
PMD-sized pool. Existing unsuffixed parameters and gigantic-page pool
sharing are preserved. The new size follows the architecture's PMD
size rather than being fixed at 2M.

The preparatory patches introduce per-pool state and prevent recursive
CMA allocation during migration before enabling PMD-sized allocation.

Thanks,
Qi

Qi Zheng (5):
  mm: hugetlb: add explicit page size to hugetlb_cma
  mm: hugetlb: group CMA pool and reservation state
  mm: hugetlb: track CMA reservations by page order
  mm: hugetlb: avoid recursive CMA allocation during migration
  mm: hugetlb: enable CMA allocation for PMD-sized pages

 .../admin-guide/kernel-parameters.txt         |  39 ++-
 include/linux/hugetlb.h                       |   4 +-
 mm/hugetlb.c                                  |  80 +++--
 mm/hugetlb_cma.c                              | 328 ++++++++++++------
 mm/hugetlb_cma.h                              |  11 +-
 mm/mempolicy.c                                |   2 +-
 mm/migrate.c                                  |   3 +-
 7 files changed, 306 insertions(+), 161 deletions(-)


base-commit: b810335a0699d1810683796b0e3ffe8827ddfe6c
-- 
2.54.0


