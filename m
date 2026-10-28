Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2284D606A330
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EFqeG8xC
Received: by kanga.kvack.org (Postfix)
	id 09BC86B05C9; Wed, 28 Oct 2026 16:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C4B6B05CA; Wed, 28 Oct 2026 16:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E564B6B05CB; Wed, 28 Oct 2026 16:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBFFF6B05C9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:15:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35BA0801AC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:55 +0000 (UTC)
X-FDA: 85373141070.14.C65D9CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 583AB10000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:15:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFqeG8xC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PD4hDhqXAiKFSflF7fULM3AAKFj+yDTHa7fJ5vGqNRQ=;
	b=IykdmulcofNVTBdKNOa9OXegSQVy1pVPNFSTRcslNit9QcDBHXkuMzbCz+IN/GLxDDx4Ao
	ScW/V1h8dtwltxCwDNeAVAaG43FMryGM9TvdKc1HHbDgZmxhYNGsGzJNLl4QdGiXimRytu
	z1qyviQOL1yyNlqPc/0JFjDMjFTfsB4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFqeG8xC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218553;
	b=YC2HFW/I/gkjTmDqntkEu4bKTkFwovdDiLdSKoKDs+veGAd31lm7jszC+QRLRJGQ692UBQ
	4TSai8Ni26zW7qwxMkRLFCupnnjHL53GNpzn+0yrTMXVpy5M8rN8/51cUwp04qUQK/p9GV
	sei8Mm/kf231nsYpX86lIcSAaiBvLhE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B46F41437;
	Wed, 28 Oct 2026 20:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA231F01829;
	Wed, 28 Oct 2026 20:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218552;
	bh=PD4hDhqXAiKFSflF7fULM3AAKFj+yDTHa7fJ5vGqNRQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EFqeG8xC5Mwi0UZUzqPwuieIuWaq9ZyZgwDIxWXkII2L/P/PHr0qV8jMBbtSdKAC9
	 AOZ6HfEN3h2XaPhzF6ibD4Cu2x0rs1DsAzHggynmtm9pKTYt/OE8H5thdZcMDOQKVR
	 XDEEEaqhW72tk4o43Nm/R7jfSWsfWM1j4b7tvIQxXpSl+OU48MXWcRojnn0oLlmppe
	 2PSNAsXd3xDKkrXuc8C7qKr8GkN2MoIINkXDc0ShqvKBandfQWmoJaojETBvk56xfx
	 UupoRquhv8uXkKegpdvG7yPBDhXgpUwUK1z9sLkIVrJ71zFbmHPjieAjhmEvZG6YAB
	 CTKdWmE2ePXvw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:40 +0100
Subject: [PATCH 12/15] mm/hugetlb: keep surplus folios that are reserved
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-12-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2040; i=david@kernel.org;
 h=from:subject:message-id; bh=/mlxy/iaq1GeHcDtTEJ64LQetJjrHzqcoYxh6NLur8s=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZdN+Xi05eUjzYILfC+fuJ1Y2aXUbPSp52qkL6919
 ONM3gm3OkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhIUzTDP2Wea2ev6vxQPPag
 xdXkcdHF6UWLH7ap3bx8PKUi4OF7m3KG/wEXcix2KZzf+/nGKpbonqSCqwu5q7ZtNnG4GZa+KPn
 jdWYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 583AB10000C
X-Stat-Signature: umo17499e7tdsf1yn9fi9wdmw1rsxr4i
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793218553-531168
X-HE-Meta: U2FsdGVkX19jfIvI491tDryglvfQc+CGb30lv09eBDvYhaMsC6cHXk0ot++Fk/ZSE7R5Vui/wKMiynzmdt4u4F3FOcxLj9MmC36ZZHXnTGtXbUOPwpRlexS7/Tde627uODxiKrU1VJ5GhplBkvofJHZbIJG0y5Ny+fIQeEGI/XinXwyt2nG9r8p1j6bttFZ1ZW/eSpt0QrgIkRwy0IwvAFRlhEVL2k0TsHOuJOKux8XlV4rx6i62CTPkQIX0f0u7pvjx7LlkxuSqKcHUSw9fcpyffkPoWW3Mub3Bh4mYxPzRin+SlSMnrKvqLJZGD1cUx0dnK/CufB2CPgamqoHbiKJYtD+1GVlpO2eeF/VIcq4PFtG5byMiaM211aRsRukLGRfHS8NpWMA81SnTYQnZXkMrJedoTQjWZP/Fse+HIYdTbUR1YyQaC4/i9jfLTL+IJCXM+ZlGawSN2gzea1ERYQAubCFxcRSi0JLiE6Uex1h6tG8wurWXO8Q41ovbij5VemoAlnqLvDH2EwrP9RX8H/F31HpQdPMuBf2YMd54Phe0lkB9vnfQ/bwIDswwhQUrvXZnwLmOMz+H9jp3TXFrXUPUPxXIQ+yK1EPAiYvHx+UgNZKli7UfAWA8or2/REGCneX5RRZF7VbNUlXzLHg1S+5Fw4TZNBC/tphYaR8EZ5nZUymuglwjZvR2kbQMWQ1Rfz6QerKr6fiZZYF8oTe2jsgD5yfvkrm/vLtQ7Kekv1xi08a0dMwz49mSRNri4z+TyUSe2tWIc7wE2zZ/FkcXZE73YAE/fhy/fpqJGuFsrYu4wmlkvyvgDZAw0y5e1G0gFD6kIggz5T3WK69XeiEmyuzpBa1x4KW7FvZ9xdIUekbpDBmBCbYJE8mHFFrkYgKtJU+3qiOcONiJB1zc4XdsAd3odoouxOHItwwVz7BCpPOECNgQyAHKdZaBBVIBySWIqEfE1sncBnJfwdd9NV1
 +g6jrTRR
 C6vQiVCRYtPVXsboQOEBG0HOZ4F3NOIwOFlhnkYZpEsy5nmMiSC04Du3T58EhRH+lPUVstVQ2tD6FMqfNMNDpX+pHmecS4AJPWZzYY5WfaGUvk3lAbiaxiD8JthfCtVqAVnzoJjQoV3X3fDl6NVKcu6ayBwAvpGhtClNKK6y1aaS3aBpjEMpNJaj/lFgvo9Y0miXkUbjGvdQdWNKAF4ojw2EUfnm+2lVGDMoo7j0JXTlEvW/0b11FhkMmM+/YCYN56fH9rKaSsL2l74pk1tnAc4rJ2D1FJxBaTXX3tZ2owit+9TpGwpvsK3xT7x3cQx6qGDEO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

free_huge_folio() may restore a reservation, but still returns the folio
to the page allocator if its node has surplus huge pages.

For example, start with no hugetlb folios and allow one surplus 2 MiB
folio:

  1. Mount hugetlbfs with pagesize=2M,min_size=2M. This allocates and
     reserves one surplus folio: free=1, reserved=1.
  2. Create a 2 MiB file and write to a shared mapping of it. The fault
     consumes the folio and its reservation: free=0, reserved=0.
  3. Unmap the file and truncate it to zero. The mount's reservation is
     restored, but the surplus folio is freed: free=0, reserved=1.

Besides losing a hugetlb folio that is required for a reservation, this
can also make available_huge_pages() underflow and cause other issues.

Keep the folio in the pool if it is needed to cover reservations,
including any reservation we just restored.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 07443a85ad90 ("mm, hugetlb: return a reserved page to a reserved pool if failed")
Cc: stable@kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify comment and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 06d2a78c7170..32ecac4e0d3e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1774,8 +1774,9 @@ void free_huge_folio(struct folio *folio)
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
-	} else if (h->surplus_huge_pages_node[nid]) {
-		/* remove the page from active list */
+	} else if (h->surplus_huge_pages_node[nid] &&
+		   h->free_huge_pages >= h->resv_huge_pages) {
+		/* Free this surplus folio that is not required globally. */
 		remove_hugetlb_folio(h, folio, true);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);

-- 
2.43.0


