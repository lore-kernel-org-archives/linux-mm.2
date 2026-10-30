Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6EEB606A333
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hpnpoQlS
Received: by kanga.kvack.org (Postfix)
	id EA5EA6B05B1; Thu, 29 Oct 2026 20:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30CF6B05B2; Thu, 29 Oct 2026 20:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7EC6B05B3; Thu, 29 Oct 2026 20:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0C76B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:07:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F498140583
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:07:52 +0000 (UTC)
X-FDA: 85377354384.17.2DBBC0C
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F5D8120005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:07:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hpnpoQlS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793318870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jVUIageg/XI3VA6PRbnnsPlVRr/N3qezw2iOOgJuil4=;
	b=Nj8wgzG8aG6sY6POgTo29il/QMfD5qMRWw1oT19cwfMKRyWgiZR2aqoXdLHGX3aeaD0uza
	lk8rrgV0JEfsP9KzfL8WR9ga1xH7zGl7DPI05thReU9NqfLyp6SOJUWDLanNdxj3XFveiE
	IVFMVLR6Vh0YDY7VLzgHsCk1HDR/jjk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hpnpoQlS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793318870;
	b=5q9qcz0/xA2RTFI6LE0ycz+j+TU2j8eDNBt7gtGNevNuAUIJ4IGNqGxkV1Aay164UOMGn0
	fzpZO9Dq2yNMke+QvyrvCslMsJ2qHu/UdcF+zy+5JlJokdD6WWLOOodtaOiJEc4P/EE1Vq
	QnMfkGt1YCzZKNILlgbt0bc/naAoq1I=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso279807eec.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793318869; x=1793923669; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jVUIageg/XI3VA6PRbnnsPlVRr/N3qezw2iOOgJuil4=;
        b=hpnpoQlSvzhNzDq3SU5rch9q61hJgEuSBVGDhNyb/6aDwaW8wyoeOvFqmTTp5NHIY6
         xFh9mxCVro2yYSmq8pNeFABsWN8sEsES2OUPGatTABlSWhpETdZKp/ZLnXH9yI3pkm6P
         27T77ZanrhvG29zskL6Ogho4xOlKjahrml5o84bmRk4/h3wYCwVkNglkF5PMPOmPo/xV
         rLBvHS3OzI/4lmNGl7KU6kcAgP9ugdOdC0RmwGdi8GSDLuVS2MWCcLDwTpqttrB7OR09
         q4YYqGEcQcxwklYSc8wGI3RvsOLg60ec00Z009bbXpPDLoXULonqXMYNDoIhs9Hkleko
         IoQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793318869; x=1793923669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jVUIageg/XI3VA6PRbnnsPlVRr/N3qezw2iOOgJuil4=;
        b=JqTDdsLOrQFHQeBZ878zQrbc4pBstX6nFyajdvYRlf7xmgFXv1FcPMGac6x0pqW9S7
         U2jzrbesA6g1yaTE3t46Zth0uzB8w/QMbWYzc+06u+xix/QsYw2A81Qb+HCHmfJwwVb+
         dyy2fhYq40OG4Z9RDTXOGUeR5WuySX56vvAsbp+HHV1IQyKazg8YEcvsvrW9SFTuxNe8
         txiAmL4lIawI3eCYQxGo8u9de/ab3r2A5pCEA9nmXcmrO3iCIyNDpjtF6StAjVSSsGQ7
         Auqy92i/upDLZ5og2H+PofUchtLKdOYU8FtzhIaIAgc5NPUttXA3K3ck5iUfGHrHoYsi
         nnzg==
X-Gm-Message-State: AFq9FYKxBL3p83KBiCex0SqIi1WjcV76q2c0CIxvB/knfb3yZNdC5l2L
	o4djf/PXdUKLv0THFOLHO2oobAC+z6mdVpR3UCGcE1OWqw+bkNKkhhca6G/+hA==
X-Gm-Gg: AYBFou0VIyeJPYQucdXkqBSn9h5joZRQQHQospj3amsLsnbUBs8mN9VQy7a3BGEHY1+
	nrUbwMkko6Y6eKVYs6PZkxlIsFYbuDIXfz0EO6iOr/aDffvxsLIqa2PlvEjo0q/Buu8S/s1dyXp
	Cd2l0xIQovRepDuOyyflKDBB/UYyI+UKvUAk5XJP9et/WAIt5Mb2EHQpuq+6ZGm6qPowS2uB/bi
	NCAWXx2SN4P4RmsqYkY0xIBcS1YHZhzsdyrT1gzd6J/FKvZn+/fOrxBbSY2CZGEVYrrIQVdy998
	aZl0S39YsfWkIjwkO0jIXgVg6l9iGb+Af5rGgsKDWQOffpg1AeLhG/M/A0TmTg+7Gw8/VxUNuts
	ussTCs1MmSp91EU+qKh+bn+K3XNsyxh5hIZvZeassqQYYpT7aAwmTQbgOb+VGYSQ9/xt0hX3I73
	g/Bz+vHSUevbA73JvNCD5KVh+ScHVqYY4mYewq2TNcd/8Z4RLwJqbQ60xWAl19h2dRljL3SKJKt
	wiqJjv/iXHrDod8PiqIXbH6UGyegeHNRoKJodGCEXTIqjnHNqDbkbNsIJRvZQ+Gt/3Tsp7YO0Xj
	ieMnFbX7laifvTHM3WAxPitH7v5zxX1a7Q==
X-Received: by 2002:a05:693c:880d:10b0:34e:9923:e372 with SMTP id 5a478bee46e88-36a4241a810mr1410914eec.29.1793318868940;
        Thu, 29 Oct 2026 17:07:48 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42669128sm2111682eec.3.2026.10.29.17.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 17:07:48 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Pavithra <pavrampu@linux.ibm.com>
Subject: [PATCHv2] mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
Date: Fri, 30 Oct 2026 05:37:36 +0530
Message-Id: <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F5D8120005
X-Stat-Signature: 8ukukc5urjg1g58f15dgidoc6cr9hkjy
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793318870-305821
X-HE-Meta: U2FsdGVkX1+uBP9+ThfMUK6BdOAKF3BteWAg0I9l5erKeCnrXnchGwKIn9pys27OQ0ZFzMzCvFtnqVjCJEon2r/JubNXjgAyeMzwwFnHpaNsJCmuHULEiZ/gemqncvZgIE3+DefP2HxILrXrTtXkcNpw0uWZqHwv2SZ0LohnmAN/n1WNSNr4LCnPg3eutvPIzhgd8yq6Y5Ai5gaVt4VrdYw0Q9YlaVeN4Kdx/GQnq6HDXI5obdutRtmnFOKgXINAY4NmcD2pH0PjhMv92yquBSkh1fUMfgl3lUbOJ5p2VjtpLSrqMcbLrjZZncqWrXCo9B0Cl0MeuUkZwxiKvbaRi6svd5ZjjBv0Fyuyfs/7qlXIbSjwsczBpf1qH297zZE7RQtRb5r7sTFV778pZqHTuYvDGXEZql7yOZ7PxBArOk7YAlG15d9B5C/RAa6khCP0Wl14SeFTBQ0N/bazCdEl2gnDVMFnqZfG4dFwb9dS231WQcz23EZtW61fqGcB3SQxZO8Vo4WRtBGCLq1sGkMk3BHGHrfdlI7j7lDmqtLdbI0Pm/ImgKv1t+qn5a41/2qOfqAi3gQJ+Ag0bqppeAdG+xdV8f04zLC4wyn/GYPY7vXG4bxCbMk+8Fl6G8xWlkj7pg6+8zerL4Nc9eV94/6bVWkIwiKrrWcS7bgBLCG04WaZRYZJEXIOFSsx5Pxfxq9H3PJvm6em8nNsXiCbX8Esg48ZkXQJlIGho4c/F41tHO+e+iOv06OrZAJRbaxx+E06+YbtCzQeUC/ZthfF5c6embhgC59xw7ZQbi0ZGbXXHOr0ZF7I8kmu5KjF37MOXKDNq6lpjie5Y5YTOWSoAHORditQIaSvmhsf1aQyFi5dSsLgYbOZqXNuxqfcGVV/hwV9wF18UrVQoYuE3BfH+xMrv0arxKD1TWyUFvLsrQQnpH3lOmhnkZ3jU3OOwq7ayvQm2cWwk/7aUyunxc4ZtlK
 C50NI82a
 f+uCyF4rl/e63Hll1Hng/U0kXJEKAPanm4Z/CyzQ3QQX6j0ockdnxEpBB5yoYPr9Ek/zu48etCYzL3uLYjSuKXQP5S7fQUydY/D3DnDz8kLoM4XU8NjOkolRsXmWX65ZhYkLlJelWXKuqbiE01HrgNoTNLxhds5OgvZcalK9LtquL8wCAR0RDO2+UM0SobSX4H7ofOZWubK64TlYgxOECcV027S5aP3wXG/fn0k5ZlHXrdyxvAkGcRgwK0JsV9w9iIorjD4lLBQf+nLOri67ulm9gDhxPsCdseegrOZqQ6DxlPhfiOtf/sNtTTdNQEkOcY1VA/DmztbChJo6R39BdLvn0b8GWIYpNdT9MZle3qyCs10eE6VYSUC8Yy3PpaoIU72zQSj8Vakilw7EVESGate8cFj4R05hpZ4SwF+k+PGlQheJ6Y/FJurdMoyP/8HokeF96F+y+Lcc5JzhxE8IvWqa9kjBrCTucTx2Ze/c0yBCP90w1PziJptl7nti6urVmj6bj0ILapO8Up1r3yt7hgxq8UMLkfEoOIlwhgfIfteq2S56r7FSqQmRCVXXyu65JZSQN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unmapping a device-dax mapping with 1G alignment on powerpc radix kernel
built with CONFIG_DEBUG_VM triggers this warning on every munmap:

    WARNING: mm/mmu_gather.c:176 at __tlb_remove_folio_pages_size+0x38/0x230
    NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
    LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
    Call Trace:
     zap_huge_pud+0x170/0x2d0 (unreliable)
     __zap_vma_range+0x1604/0x1e20
     unmap_vmas+0xa0/0x1f0
     unmap_region+0xb0/0x130
     vms_complete_munmap_vmas+0x120/0x310
     do_vmi_align_munmap+0x1ec/0x240
     __vm_munmap+0x148/0x220
     sys_munmap+0x28/0x40

To trigger this - it is enough to mmap() /dev/dax0.0, touch the first
byte so that the whole 1G is mapped by a single PUD and then munmap()
it.

PowerPC needs MMU_GATHER_PAGE_SIZE in which mmu_gather needs to record
the page size for which tlb flush is needed. zap_huge_pmd(),
zap_pte_range(), change_huge_pud() etc all do this already. However,
since commit:
  dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")

a device-dax PUD maps a real folio and zap_huge_pud() now hands it to
tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE). At that point
tlb->page_size is still whatever the previous user left behind, which is
0 for the fresh gather set up by munmap() and so the check fires.

Fix this in the same way like how other similar paths do.

Fixes: dbe54153296d0 ("mm/huge_memory: add vmf_insert_folio_pud()")
Reported-by: Pavithra <pavrampu@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
[v1]->v2:
=========
- Split the 2 part patch series. Patch-1 is now superseded by a different patch
  from Muchun which he already posted [2].
- No difference in this patch from v1.

[v1]: https://lore.kernel.org/all/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com/
[2]: https://lore.kernel.org/all/20261029063601.1961415-1-songmuchun@bytedance.com/

 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..7e589a2fb02d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3040,6 +3040,8 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pud_t orig_pud;

+	tlb_change_page_size(tlb, HPAGE_PUD_SIZE);
+
 	ptl = __pud_trans_huge_lock(pud, vma);
 	if (!ptl)
 		return 0;
--
2.39.5


