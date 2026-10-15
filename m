Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B4ECC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD856B0092; Thu, 15 Oct 2026 12:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E416B0095; Thu, 15 Oct 2026 12:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256A36B0096; Thu, 15 Oct 2026 12:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1FF36B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:07:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E7F7120AA7
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:38 +0000 (UTC)
X-FDA: 85325340996.09.5231996
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6FD7A16000D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:07:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Srjq4clX;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080456;
	b=FpKzzVBd68qaJQHvAlqrCZG9RIEctJPgp+z4LpI5yhGx+X26Bpz/G+CQzii9rSV1X7trMW
	qAc4jWEtvvGpu6h1+GumyrExmUB5OZnlu2CPFZ4eI9J8aCIPYiCAH7DSeUZqCyD4m0tf1d
	yiyqNiM20GR7d1gseLMQdvbceiEirzE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Srjq4clX;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36klJXXC0aAnOR97CHQ7Hc6li6xJpMIjRx0K78eNZ4U=;
	b=Ipvz1bP774oDudsvMg8oBbhKa7dtU7aEVQLvKJgrbVI3UX+r4342/QX975Ovl/FARhwEZG
	9zT779SbshaZ6013KQ8j+lHVjKb1m9yVEtsVRFgrH3rUqpzuj/DuAa69Tt4qgvAVdP2xw4
	O9y3H9RpN6xp+oZiqizPtbuoYJ/uYOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E949141E99;
	Thu, 15 Oct 2026 16:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699971F000C9;
	Thu, 15 Oct 2026 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080454;
	bh=36klJXXC0aAnOR97CHQ7Hc6li6xJpMIjRx0K78eNZ4U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Srjq4clXVSQXEKQQlseICrzLRzIL6wBQhcIt4doE6Kwl5gbMmc0wlsf6RN8bK1LLn
	 zhWDaGukT2jrCeQzR2HzZ3LozLDLPs39jjDarJ15nC6DD23d8gb3jazVZqXv21R+AF
	 v9w8crQBLYPFVy1/JBxiOdNYElWhXNJE193aSkpDaqlg8QTSA7oC1szVNXNkY7uh3R
	 OCdxnZGaJtcVHFF13Mox6RIxXCbJoIghfz3LrFcsyV7Y42FhpXp+/H+zk2ngsQVUzw
	 cIvoFw3KkFURsSvPVUyJUqiQOsYU+sAy29s7hQg92vQR+mSRS+J8ehoikT9/fn5Eup
	 HVFEXI1FOkPpQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:08 +0200
Subject: [PATCH 02/10] mm/hugetlb: fix use-after-free of a new anon folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-2-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3241; i=david@kernel.org;
 h=from:subject:message-id; bh=/+TVzqw3aRMIyr8brH6Ah9l55OImF6leRLWzdkIev/I=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DJeq/J/o3CE/kphCbsFRw9VzbnyqWO/yvPul9WtO
 1YpnG1M6ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAih+4z/M/M1Fbq81TtXKcW
 fiPFQoOh8nS3l9TJw1sFVwre2LunYi0jw97l0wt0ndl1HFWPhOy5eKTqrmHievE75rtz30h47L2
 kzw0A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6FD7A16000D
X-Rspam-User: 
X-Stat-Signature: xioxm93gg7hrxukii7p5cx8ezqaw4xtj
X-HE-Tag: 1792080456-1233
X-HE-Meta: U2FsdGVkX192ZJyoU9uBtUk3uUpN6JoHbjQs2W4p+t9cq3qB2/3KYPeRE7EnHP/pDZjOIOuJcjO8NDl2KJEvl6daBMGRxf4Z3CFPKbicUi1hQAm+lFoSmizGtpKl4jKYlMlIQUVw3ayVXCXKsgLdlTcnBHTZ3hhWUkeKuLEl2swrQCcAzHNTxS6Ai3FLw2w/T5sDc7SsCeXm/h93lLLBg983Ppd7mwBKn+P96Z5dY2440W6MmJ1j4YO4F1o5FE54rwELtPYkwM/bKLnf9eZnF5UlzaKxTFhr6f1/RG6xUqyx2e44UbVUjRsn7CDngplVGqposWmuW3XDSt3P87/MafkJu7Jsp3MceNSXfXxk+ovk4QgW/X2vr/l0ReznFdJtO9BlDyQif3lin4gOpjJYWvlka4XCwBtyV1lbZkC475UzqKx1yBTBQqq6DJeWzJ9O1c/81OWfZZ21M6aTuki1jztD7URFXYRTmJNDo2xTR5QqrcvxNL/++3Mt24Z9ZHNsGsaZon0UbN0gUjkp7CU5NJcUxznyWgOsZjw3qaqCCeXBFi4cviRTXQdSde5kjOlcsU9AfcJX3iy0OQF31Nsed0mI9l1mFU7X5t19liUxcnVYS0IcYdFfUAL0n3lFv8SZprVHBJOlJRMyFo/mbXXSQXkZdibSuTdSoOcVLp/DaDZtDMuylA4RNE9M8tVgXr/XIdGmDhVZzYDdq1GpA6cn5cW9U2SkpuZnlQdkB1w6mHHvO3vUf3rOlSLZZ9GDGL0ZH3lJNXVMBt7ajNa9/nHUapiveekKZ833yYJw88mB3JeqnenTRjJoVRJacKIIqZUBSpr44BE+Rxbs8o28w1iRJCdpbjP4RqADa218hBaDhohs61xNmXzoD5R75rCJaRjD/b1H0/hb9Ey9hfjK3uLPzN1EdYhAU6HccABAmfygYxFS7dA5OCmFvkhHi1qQmmLLV4KU2eVC/URKmlwrHY/
 CgijUePs
 KwyD8SmK3Ym31buBM6k5aXjIyEUWzJreScliqJ5Sztb93+dUKqYd9rM0y0ZqdxSo9poStHFCY3WGaLsjbPdGLfVAvuWTlUld4vuidC4R/h1bf2jokSWbkjtynDqByvyuYrYV/nsaq7hv5nvSylCkdxKbVWNlyrflMXCttI3Z4GtYu10VkGTg7VBpOnZ7S68JfDhqeW6Wsz7Armw87qqQ/6ZTpq0IyKwBdbkVD1OEryYf/ZaKoGdm2nyQZw87pqnJRR0/Ua51HpA5hbkTjr30wv05wpPLoxy20DYn/lw6sxrSYx1IPMfDNlIdt8kTFAtfcXBhcK5sKwyShkFNwuNxKZv3IbPRh5d4UuUO4KfxglD+Mz8MCg8e3FqPSNXTs6jZFBioP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josef Bacik <josef@toxicpanda.com>

For a fault in a private mapping with nothing in the page cache,
hugetlb_no_page() allocates a folio, locks it and maps it.  The folio has
one reference, which belongs to the page table entry from then on.  After
dropping the page table lock the function still sets the migratable flag
of the folio and unlocks it.

Whoever zaps the entry in between frees the folio.  The fault holds the
fault mutex and the lock of the vma.  MADV_DONTNEED and the first unmap of
a hole punch, hugetlb_vmdelete_list(), do not take the fault mutex, and a
private vma only has a lock if it owns a reservation map: not with
MAP_NORESERVE, and not in the child after fork().

Then the flag is set in, and folio_unlock() is called on, a folio that is
free or has a new owner.  A surplus page goes back to the page allocator
while it is locked:

  BUG: Bad page state in process init  pfn:108e00
  flags: 0x200000000000059(locked|uptodate|dirty|head|node=0|zone=2)
  page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set

A page of the pool can be given to the next user, of any file, who locks
it and loses the lock to the late folio_unlock():

  kernel BUG at mm/filemap.c:1532!
   hugetlb_no_page+0x111b/0x23e0
   hugetlb_fault+0x3a9/0x14a0

An unprivileged process is enough: threads that write to a MAP_PRIVATE |
MAP_NORESERVE hugetlb mapping, threads that call MADV_DONTNEED on it, and
one that takes the freed pages for another file.

Until commit 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more
pmd sharing synchronization") the fault held i_mmap_rwsem for reading,
which everybody who zaps takes for writing.  The lock that commit
bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs") gave
to private vmas closed the window again, but only for those with a
reservation map.

Be done with the folio before the page table lock is dropped, as
hugetlb_wp() is with its copy.  The function already unlocks page cache
folios under that lock.

Original fix generated by an LLM and sent in private by Josef.

Fixes: 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more pmd sharing synchronization")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: simplify+move comment ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cea25773a6c95..ce9e87228ec62 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5949,8 +5949,6 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		ret = hugetlb_wp(vmf);
 	}
 
-	spin_unlock(vmf->ptl);
-
 	/*
 	 * Only set hugetlb_migratable in newly allocated pages.  Existing pages
 	 * found in the pagecache may not have hugetlb_migratable if they have
@@ -5961,6 +5959,12 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 
 	if (folio_locked)
 		folio_unlock(folio);
+
+	/*
+	 * Hold the PTL until we're done with the folio: the page table owns the
+	 * folio reference now.
+	 */
+	spin_unlock(vmf->ptl);
 out:
 	hugetlb_vma_unlock_read(vma);
 

-- 
2.43.0


