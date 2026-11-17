Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E72606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BLELYYOI
Received: by kanga.kvack.org (Postfix)
	id 608B26B00EF; Tue, 17 Nov 2026 02:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592D46B05B0; Tue, 17 Nov 2026 02:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A5E6B05B1; Tue, 17 Nov 2026 02:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19A6E6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:53:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2F0BA7DA4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:53:11 +0000 (UTC)
X-FDA: 85443845382.04.626F531
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6FDC120004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:53:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BLELYYOI;
	spf=pass (imf29.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=danjwade95@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794901990;
	b=BIo/TmuOaPH3mpCHup00bf0F+LSY8XZoJLwI3VAK7phN76lK/Nb3GZ4ooHaATeUQG17jHr
	KZCYiKA8bWrko6qxDdXSrpje5d4sRwG5kUC/A62Z37Gb59Ef62xmM5UFzzcnDyrV3IM7q2
	9rB/n3DyE1ruwQeaHGzZTGcuWUSfw34=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BLELYYOI;
	spf=pass (imf29.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=danjwade95@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794901990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bIaB3xViS8vRwH7p7m0nqayQxCVJVBaNFTxNi69Cb5s=;
	b=jN8WRP2+tSI+Wi8/riDkWuCAdbNFMCpjX5pr012JgQ0KF3lGjD9CppzIfiMdeCGOdUAesM
	lyHpd47i10Krg5UGr0kdP+s09bBsjqe9GM6UhAxIdwEwO/h4U5Cz4U3Y+ltSMzUirC9Pdn
	YZgy7gYizWgC80wcOUAkNCQhUsud9Fg=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cdd9d0c9bbdso3231817a12.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794901989; x=1795506789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bIaB3xViS8vRwH7p7m0nqayQxCVJVBaNFTxNi69Cb5s=;
        b=BLELYYOI5X8pk1lkKTAssWfMkKsvgVE7AiicBU+w/MQCYeL7FZ3Vsp0qH1aMrhksa4
         oZqlxMuJWGhYxr98dUe3uHlMHTdjiv0ZNG1qp+EJM7SKeK2wTYmEN1OKhebsWKtIvMgD
         Qq5ruiZ5wMJX/AxE0dAzD8CIfL7EjI8oDLxPAa4RbNjxxdzIgfnE6biujDi72QHcKtRo
         oLXIMyGslMZ3+/gb5/p2sME1f4H9WZiPDpH60lPCOf6OtrCp4Nskuy90+q8xna+vVYVq
         tVj22KNV3qGArvmyNAQ0jpo6+sigfsTVvxwSQXsdnfbapPbbB/pDUceKinfi2K+2rJYa
         tn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794901989; x=1795506789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bIaB3xViS8vRwH7p7m0nqayQxCVJVBaNFTxNi69Cb5s=;
        b=CHjyE4Z7KHXEeaHFOqZaVIpvPrijLitzA9NxElQBb8wZKLSZYd96BFqItK+2DajCgm
         eoyqMEZ2XBz3CuCWv7OfK4me5BwQq1rzG4VvHt68yHnjnKP3Kn67I1T2ma/zWGM6hTK1
         Pc0IfLuh6yO68PrYt4EF1YRhcNb6UArcCq+xD96bZtUvqvaroNzuKTr7Ep9OegMY64Ll
         K8Q9grEvoje7ltFBQZ8qmk7+hoX9qMqyz5aySw7QF4Z0Dayu5BKtY37LYSZ3wUhLtaVY
         QATbW6dAy6GSDV+mt0gERg0/T6zzF2FzALD6jdydH6JkAWkRudSVe8L/ckAnGOzN/SUU
         KUCQ==
X-Forwarded-Encrypted: i=1; AL+hErGpPFVGK5tyZBAl5SOxZJrIjF3w4QUp8NYg2KL/OInYMCJn3JrfRsi/qGng75eV+p6tBm1R7Vk2nA==@kvack.org
X-Gm-Message-State: APuU4Z/WyR9f4zYnVRSstG6RqLgpM/efAXkAKmRFC3R3gl/TZ1jSWXxJ
	G9DXQzrjpkPFtQg12897o0MbrocHM7qqttq4mzKFfaZ/UHqQjCXtNIXo
X-Gm-Gg: AZFdTZeIvtOHN/P1YI75BjRmQ2FUcmvZkZVDXtC5ePwp0Kec5sORxBa0c6/pK/RwMZ5
	vulb0TeuyDLCCDnxeiBL98WuHnFlGxklohPFLDuFvHQadeyvAXBo+DCU4pTlAYZdBxXmbwu3cju
	EQVmxJ0XnfqVkXF4IahYSGwD48PmDf7jlpALVAY3Y8lFoFgXxHcxXmA0H2xWyCXrjM70yLVV7kj
	3RvlSPxNDpxJxoyAcy7krj0cRqF6xnqG0NBiWR7dtwt0V0DGSa6WODENF0TgXlffLO5ERiV9Wgs
	d2pndLLCIrWGKXlk5ssmpWdvwifqP8dwYl6Khh5lOKnHEHNdo7vrVRR4oybNvk1lGovj5J1bT1p
	7eS9AXxy0XOPt6gCcRpZyL3x/yjUoAgM56waD4pnIgHeX47+Dvbz1RZScny1wXAZOGRn5+5yRkz
	MUsn1MKk6epD3gyCkoanAg3/f2CF/xsm9gVtQqv2VkaXpuuMGIOURTfqUzofhyCrxssYBr8a2NI
	vdjqCHK4tipu34Y6ujextS76K4Rr5IBAHKgNl1AUKaq0/DYad9xILkcHP++0bF0ryv6BvkcGu6L
	AxIRSeWDeOkNJae69qH3ifLsQfxWigQ86fC7p7zxnoxeE35bSc8AABtMt++oD3aU4wHVcrhR62b
	1ALdv/C+gt7LftTUG1QIeNeq/OoMKJ03wQRoCV1N/D7tADHn+eXduypLkh4wUdci1HPrZTAQ2vj
	hNwz1gm3odL4R0PJU1YID6HaJVAYiXYU0A8bU1HvfBsm43tNflMw2UltpsWZ96xyikJYImoTLsS
	yGpOzrmHU1yYcMotvV/MYyXQUMS1dYDDl4sP4qRvfwZBkVqP8eiJoSxu3xxo2ZF
X-Received: by 2002:a17:90b:17ca:b0:3b1:fad:b1bc with SMTP id 98e67ed59e1d1-3b1b0d77ad2mr13468030a91.63.1794901988543;
        Mon, 16 Nov 2026 23:53:08 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abe77179sm2791862a91.11.2026.11.16.23.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 23:53:08 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/khugepaged: mark a collapsed mTHP dirty
Date: Tue, 17 Nov 2026 18:22:46 +1030
Message-Id: <20261117075246.61336-1-danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6FDC120004
X-Stat-Signature: g8yr1x7e54e6diwbe1wz86y7wqftw8di
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794901989-251341
X-HE-Meta: U2FsdGVkX1+qwFddi9Yxh+s96aemHlPZugClTkPzYjqB1kxZxOZdugaMRrhq8T8L0sCemPGgfEy9q9U5k2Sm4owcivIOUk8geawiAKawziMkobf4b07x4wY5v/QYcMSjuIGqAFx4/DBAi4zY5MrTvO+ULbd8LncdIbNczmwOH1tLbswT/g6DZRD65+N+gRcCxAgJ6g4+9Oy/hWoFuVuVwOhHHK3FsM4BDUrXvxyXcYWrinzJe1ZeygDRKgHUo2tpQnNfjkigev7QOAn2g8BpPVt4EjVEZKDzSggVLGGfNMnOYLdwHjnHuzC6PoOcAQSAOk5Sm9zGVOi/CWvlrnfwBjXzqQIX1QTW5YvenelLFl0QZkHXH+f/T0H5Mkmlj0vc35rF22WP21LziTFVnb+8ZMJGMz9y5VYRvjhzbYZd5qBbz0+vnY/5AQD1Lb6BBI03WanYJUlBzpZyaQKf6NDm2ngKuDcG66FCjchNuW929HuN7oTPXH9McK2jqqNOywG2uMLlPlhflWF5tb/gvLeoWfseKgb8trtkNOTXPjOHYAb7nt8DGy/zcDg1Ze7yNU5SeU9OyyG16u5VEg4T5gxu/PTqqlPnn35qYtTRpDLJpOhCUmzmBcq7dwg24HwHkLPh8957Nyg69wY6RIO6/zLGHTd1pUcai2ZIJ4NWG76vfChWpJFjkzldIs3yfxQp7ei9la4TDvAKRMLnWGkMujHmC+ED9caQQKRZWqoY8ROUmoNhyBbCTTy6IvDlmCndl9hrngNlZjgh7rRxeZ8ko0xnczsrVmj3Fc4N1tMxKPh6I6Z+leT/muHy5p30pEbvoFuJ31XwHKRfR4ofr1TM/x73KkjSJU2O4SuCKfe8+EzWaXFkqx4T8z4sMX5oqjvud+9FNf3fZuDfonGk5LpvMWK4xtzO3dPYQGQKlbqEp/cURTAYPSf2oRlW0htHpZLpd3//K0c9okheF21jnQ2rfCl
 mbNjaeSG
 zXdCjfL0J0nguDVw+uxGbjBJLFHuHtZ4CP4JdpMwXOZqeerUqWWQfebFMhQrHHs4biZyDLmpOB3uBADuNrh3K9UPqEaQ2/su2zbT9LN+phK35n0pQ28lAzHXw33X4+1n8/uC+SRpdPZhNdgy4tSF/5IJ2/Xz3pqV/UV9XzbO+XuUYoGxOSvip09s+9S/I9zFKVrZBv7I5NBb1+r/H23asQxtFQjysQZeiZA0TDwyHq8u4FLoMOLDz8+kHSwzSr1cC/H4DmBhPXYhV1XgTdJzV+o6jE58q3bfeIlYiEHqrQSAUrvFuNGeW7bqUAJ+OXujcBTLqo/9nWSkuiG29ZWVh8zh5/TfQhePVjALigLUuzech17VT/8IWbOKms8LB4dVOTC057sF7HKFPdRVVk2aLruihOi1Vuhf0YLAPTG7i+8oS6afXNA5/5wUBVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When khugepaged collapses an anonymous range into a folio below PMD
size, collapse_huge_page() copies the pages in, but
map_anon_folio_pte_nopf() marks the PTEs dirty only when the VMA has
VM_WRITE and nothing marks the folio itself dirty. After
mprotect(PROT_READ) the folio therefore holds the only copy of the data
while looking clean, so MADV_FREE in one mapping marks it lazyfree,
reclaim frees it, and another process that maps it reads zeroes. Mark
the folio dirty before mapping it.

Found by static analysis with an AI coding assistant and reproduced with
a test program on an unmodified kernel.

Fixes: e22f2fe72c74 ("mm/khugepaged: generalize collapse_huge_page for mTHP collapse")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
Claude (claude-mythos-5-2) found the bug and wrote the fix, this
description and the test program, which is available on request.

Tested on b3dfbde62cf1 with KASAN and lockdep: as uid 65534, write
64 KiB, mprotect(PROT_READ), wait for khugepaged, fork, MADV_FREE in
the parent. Unpatched the child reads 65536 wrong bytes; patched it is
intact.

 mm/khugepaged.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4bbe319..8a81cab 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1422,6 +1422,11 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
 		if (pte_ptl != pmd_ptl)
 			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+		/*
+		 * The PTEs are clean in a read-only VMA, but the folio holds
+		 * copied data: mark it dirty so reclaim cannot drop it.
+		 */
+		folio_set_dirty(folio);
 		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
 					  /*uffd_wp=*/ false);
 		if (pte_ptl != pmd_ptl)

