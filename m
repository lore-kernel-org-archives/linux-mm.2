Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DEA1C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A346B0093; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1FA76B0095; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8053C6B0095; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE5A6B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:01:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF5C7120448
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:09 +0000 (UTC)
X-FDA: 84972726258.09.E07854D
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB254140007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2+k23fQs;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684868;
	b=p9/yKRVhLOpCQbIdvYqZLAvE3rVDw0Zc14S/dFvtSA4xeG6kYCTfQRaHEYMcjOuztvT/+E
	VeLOQmK0ZCEbxbJgKd14ZimxGR9Cp/GAPOE+Mz1LJUaOZVCYJDrx6MDNuGAUxI3B3X90pW
	IYBOuVfPAACiPT63evVundMIZxXOlLY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2+k23fQs;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=caCEuS351NxWvvTVauA63xx2TZfiqf9EZBC0YPmZ1/Q=;
	b=YIdOEGMigSHSaOIMMBYFyQkPvdUjiqJpXLvbp5jMzt81nznNaib/vvtoXU99POdopgdFxT
	SPLBhVyGOJ7V4UOUfc2J26LkYcUtw17GvFAUCOUbCfcd1OTogr3y3UeeUti8CAHOnoluuv
	ZDehgBBfN9PotowzOEjgD7D1r3aPTNg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=caCEuS351NxWvvTVauA63xx2TZfiqf9EZBC0YPmZ1/Q=;
	b=2+k23fQs2wRprEtD863z/vvW8GpaJZlfoEcu0rtYUbfVcxwOMXzEjYftUGBBhGv0WJpahVoAu
	MTPMAtCihc8LxZQYcmth/tYJvqAeUY6Ui3gu+/feCLV8jIsZJroYJ3pY8pd8ZKDpfb3V2t1hJnV
	q6A+rAfOeG9Fsfar9YaTyCo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gxVY95p4qz1prQ3;
	Fri, 10 Jul 2026 19:51:41 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 225C740575;
	Fri, 10 Jul 2026 20:00:59 +0800 (CST)
Received: from ubuntu (10.50.87.83) by dggpemf100008.china.huawei.com
 (7.185.36.138) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jul
 2026 20:00:58 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 0/5] mm: mincore: misc cleanups
Date: Fri, 10 Jul 2026 20:00:46 +0800
Message-ID: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB254140007
X-Stat-Signature: 1e66bp34bejy7wp8yqf6dh5z8oamay76
X-HE-Tag: 1783684867-107223
X-HE-Meta: U2FsdGVkX19oJXMFS+ygFN5GDGW0vYpgEoAoSccwk8qQrtzsiFfBIbfiAaWqZxcPaisycANAgmsIJ7rHyvcYdS6q0vhWjiFGKhAN3ty/r8gLK6oHoFSnmWp7x1iGq8dbBd9mv84SGLrI52YKGlIaAYOsdULsbUZurOMOGvwEDX0Bs1neflHYu54i8Mx8rM5TZExOo1mLcffwVzivAYe3/K062dL9PUV9Ylb+m/pKEAM8dHAySlq6jyZr5OflO+COlNVEh6X1aGjmywCejBDYCskGqTPsYg9m+/ybzmi52hcqoqj69IsRIe1e8vgQ7UMQVb5zuRe7vdlBHbY3M7JNq+uXk4g4IOvPBJDpThsndoRwarvl848wJF+B8tQqkaQBdtpqVo1UL4zG8fZzCF7Hi7ghzvxW55ZHSISQ9+cW8RAyvwb5kPJaZSrIwsAbBXelS4XuppQ0+zpkpRubbX6jfZaAtBSrdO6kls1SUo2aAbLKMLxAF3kHHt2pDbhDGrVIOyOCCSr+xExgeBVGsuC2hoZMwtkGWLjXN46F1Ea9ToN975VZGbq3Bv9NgKnuZrjShONBm6JDlkHqwlHHX21fgZtxYoQH8cjp0vIt/ocxXV4yjSPLT7lSEiJj33t7MouzQElz1ztNxcoZC5hhn0LzQpoA6AEZkBtNqWO73GPJZt8yfgDmG2LD/3JTDMo+IaY+CSTwX+Y4QGNuDpWrd04DiOC1fkfyRvAkXVEoiceCkL2qR8AHzydIFgJotpDMejj1SH9B+R54j0M67HOE/8SLRdoKDIuZ5GoVkR8ra+TCP6FUVmasda0bYLYiN3jlCWalunD1xqZ+K3r85DUCNykRtvdivXk9PdgKeMlhE3zu2zQd1L1ryo3lHIU5Q4DdnlrCJgUKhuX1SgMBSn35g19FyocYh8lAiXN6bOHImGhFC3j6fQRzUbi1D++iFmBBrd43m8lQCJs6lSfBumZPqQ5
 qVVG+21n
 xbRyGQ4XRWe7wl3BBgEThizpVoWaXwD9DUEElX3gYqtFqpAWFq5xQFTaBrN8sTrv62OU/m6AUHNlJmbkX7mHJvRp15kjpjGPSFlf15xT5UNaF8GZOAunSqJKfsux74QpHOyYK8bshUzH4POBEM3hfqJ77nzB08Kl8pcq2Cd/lkFmM+XReSc6OkUNwPSOe18MFjqHnleCwM21oE/hIvWFiweiollEpvyDmFljjs4Vqpu+UDyWgLL+n19Nqvc/uDLmmMK9vQMKMJzrfAtjbvdPZFFUzMbe6Nu8T2IRXpyTZZAbp3ugWJS3tjbipPF01eV0gLMAcgt2IHGc1pKgcH2I6USN4yKgg9eMNdGS5DzR4iU/7fzdVTWPsfzdRC6wweG0K33fBtxg7eck7z3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series cleans up and simplifies the mincore. Most importantly,
it removes the historical special handling for VM_PFNMAP mappings,
reporting them as resident memory instead of always being non-resident
memory.

v2:
- Separate per-VMA lock changes as suggested by Pedro, it should be
  based on the new API [1], will resend once new API out. 
- Check VM_PFNMAP explicitly in can_do_mincore() to avoid trigger a
  split in the page table walk, found in sashiko[[2]
- Replace GFP_USER with GFP_KERNEL, suggested by Andrew
- Add Pedro RB and mincore_page() refactor patch

[1] https://lore.kernel.org/linux-mm/20260610230415.C0521C88@davehans-spike.ostc.intel.com/ 
[2] https://sashiko.dev/#/patchset/20260701144047.3786939-1-wangkefeng.wang%40huawei.com?part=2

Kefeng Wang (5):
  mm: mincore: remove special handling for VM_PFNMAP
  mm: mincore: replace __get_free_page() with kmalloc()
  mm: mincore: remove xa_is_value() in mincore_swap()
  mm: mincore: improve mincore_hugetlb()
  mm: mincore: refactor mincore_page()

 mm/mincore.c | 66 ++++++++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 44 deletions(-)

-- 
2.55.0


