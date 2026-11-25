Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D78B606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b9nyDQ2J
Received: by kanga.kvack.org (Postfix)
	id 908076B0AFD; Wed, 25 Nov 2026 17:35:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DEB96B0AFF; Wed, 25 Nov 2026 17:35:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5D16B0B00; Wed, 25 Nov 2026 17:35:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54D4C6B0AFD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:35:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC7E48014A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:35:04 +0000 (UTC)
X-FDA: 85475098128.24.ADB72FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2525540010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:35:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9nyDQ2J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646103;
	b=C61sKA2BcNlyM16TYw6boCbNp1tp52nmPtZOqpSYEMa03x8KJ/FLBw8pgisXN05uVFLcuu
	tiV0KtdtKA39y7TpCMhufxuijml2NmM3iAAZ669GHelct74Acz712pzFglTkV99UV/hYd6
	9X39S4Ngd215p+rAW0Qb2hrSsnrkNyc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfL5x6QN4uMtbxP3f8hbUSFP2Tb3L1Ge5tQU0VKhPiU=;
	b=to/nBoqS2jJnUa1vIed1RGFsEYg+LbpVr7LpsnSZtsN6eYLdGOR52qNcY7vQHtv5XLv+yA
	W/ul98CExGpk00I3Ir7KVZqZ8Or3Q30oaZHFdUk+Zug6JOvSWnWYO63Pu47pD/xWprT+SV
	BPITaYIwyq6HLtb5VoXs+wMy+m9ROlE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9nyDQ2J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5800623BA;
	Wed, 25 Nov 2026 22:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E2E1F000D8;
	Wed, 25 Nov 2026 22:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646102;
	bh=rfL5x6QN4uMtbxP3f8hbUSFP2Tb3L1Ge5tQU0VKhPiU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b9nyDQ2J/RIU42aEm7BmZJbfvXcRFNipTjhfwdSgRn0KzkRLJdvdxcUi9aMl1YWyy
	 TMHtFurAtb3rTwa/SqNviyHbah/r8l0b9Jj7s43SnuUcATIvotOlhb91ZJGwL1W9M8
	 Ip9bBn89Ra7CmDp/hoab/W4xrVJS6qW4XbFBQMct+5eso2M/+mWCzUfSUjhaX79JVK
	 h8DYuAWlix+O3sgFNPzVew0i8bcRct4KI0fiYeEbJ0JQH3SstmPi8gQte0qYzfsMYP
	 EcT6sgUk9AqPVGaMPCTh+LNfFYpAIKt90ZC/1tdl47XLlkSKII75q4vHiiMfUpzzGz
	 qGK/u2K08DVjg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:04 +0100
Subject: [PATCH 06/21] hugetlbfs: fix deadlock between hole punching and
 memory failure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-6-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5106; i=david@kernel.org;
 h=from:subject:message-id; bh=8Ks2EUC02lGqJ75Fw8MnkFmyG7Ap+d4rJhnmmYI1Rhc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1RcNk/jPB8lsK6CY6/E85woho3/zc0WJMVvMX3g7
 /D7xfopHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExE8jzDf8fJ9sIrVruEJDzt
 lPhmECz0s2C7kZcZi/S5vZP+qO9hKWdkeJb0ILqSp4Zr/3OtJBHnRRb9h9SeSs/Vvmt0Q++LUfk
 eFgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2525540010
X-Stat-Signature: qfecfxh63artmkpnqm489rt85k9y61z5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795646102-45894
X-HE-Meta: U2FsdGVkX19XzTyyl/U8r8UFwrDuzEKF9Ap48nPMYNYDoWtCGxVAywZ13Bln5ZasV6ngkjT8ah2VbxFhLwc/ja0TEx6vwev6TnjxK6ksQ84xvcRWw71h3J6c6UW4sAKz1byei0ICEi5T6BXio13mB04pLxzoIYcIijOgTcBi6CdVz8QH+WE2Kgx3K6T94KBf2kfVhrmmIiPaB7Hv+SG4KPugwoHmT3dex7CbBtE2mGSEl7tp87fNmGe9xkxVlgOmtlTV/WGgwcLvdZ8oi1KBZv4WMdvmrBHw7uAvJn/Z3u/O6HzdMaSniYJELPwtyUwOwZHw+JnzhFb1CRsYi3tQbO9wrYYfoN0hKznr3hVOGXhj79DtX7/viDSw7tYcX2NLL0YVHU4aroCPfXn3TOgdyJtP3EjgGmikZYO3dVO1Vkjny8Yh3UhvT3A7AfI0cdQHkBI/4uTPLXvV0rl+ysXA+IOFKrh2a6+Buk+3LQBSA3Uu7wXTIoOqRYS6Zgb5l8/+sBD5rlp0R7ZIPV+nP4J4UExBD6DgxnT16DmCHwozdMNJs0rnMq6nh6JBwRnUjMZ5kLeCzY1z5hPTkRRJbm7jMJPNQU1zWK4H1Rn+Jeex83XcStoQtkJgqWVx+1fKOqU8ZNDqidRdE+qTeCx/e22QbJYi590dd5DS+p3cNHbv72suEBDeq5yznoAMs7DFd22te/zOeuiuHPBf6RSSv4ke073aE8tpeqLtxciAFISryRkd1hjjsYHRawowL21vho92rEc8RQo+xH8CYyOWFbhuv9HAlvGVqAWerUW3xDeCDoUwzGcgDclRGR7sCxB7uB5qDcMVc+9dTcroz4xDsj6YFiD23kmkoJDSZTrm252bZKx86Bcwo7+6y0rwjL439MefQ7RSbMjtgXHzJ4swnYlAxOqfSEqXfOTh507QvcqJe0I/OFaiMxglBbl9fb+ZuBfvZpwk4ISfLb1vtMrM2rh
 E2abDnGY
 WAHONXU0BlfbpOtZ5VgzNEJT0HgxbpAYyR1QYbzXuCjgSQu0kHEPOOdsrF3zYme7klalOlgAq3WDgY+iJvJtxPgwIXfxO2X47GnSis+mkXuePdMO3tW++sfcc2ECcmCHqdcThZTZ4iGq6BxoI0pZClWlW5+rmVMcRV4Q8aYhZqdwdWoH2lTk8oqxh5hiqEjVMJMqzVEOE+9LyCOdFqjKsBWF72jhw6qcF3YtY8AJGCk99XjzF3mVXdEbXxuPl8wlagixUDoNIn2150MKY1N3WPghvYDTLO1++GaypqezLTFOzei5nkJiX2s+SWWySQDwuG17wjWT2y7r4d7X+RND8y3qF054RGqhbHS7ZeQx05aplRZw3IMBWrABHvoneP09FQF63D5XQGcwtj5wssNYQAs9f2pLmwd+tOxKCY9/eup9yx4tNqBRzXhfV+SMZd9yNcKZelzC/xqRdcuIYfuuwZJDQ1F5lcc6omQoPg8FVUOXNp743idtvk4uhtcPFQuaVofJyqsCvQSjLD35ehdgsdbQEVMBehBa6mmfmFB+fO23VP8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Punching a hole that isn't aligned to the huge page size can deadlock
against memory_failure() on a mapped folio at the edge of the hole.

hugetlbfs_punch_hole() locks and zeroes the partial folios with
i_mmap_rwsem held for write, following the hugetlbfs locking order
documented in mm/rmap.c: i_mmap_rwsem before the folio lock.

However, try_memory_failure_hugetlb() locks the folio first, and then
collects the processes to kill under i_mmap_rwsem:

    hugetlbfs_punch_hole()              try_memory_failure_hugetlb()
    ======================              ============================
    i_mmap_lock_write()
                                        folio_lock()
    hugetlbfs_zero_partial_page()       hwpoison_user_mappings()
      filemap_lock_hugetlb_folio()        collect_procs_file()
        waits for the folio lock            i_mmap_lock_read()
                                              waits for the writer

In fact, the documentation is outdated: hugetlbfs_punch_hole() is the
*only* one that still takes i_mmap_rwsem before the folio lock. All
other scenarios always take the folio lock before the i_mmap_rwsem.

Only memory failure can deadlock with the hole punch:

* truncation and hole punching of full folios are serialized against it
  through the inode lock
* unmap_ref_private() holds the lock of an anon folio, not of a page
  cache folio that the hole punch zeroes
* migration only tries to take the i_mmap_rwsem.

There is no need to zero the partial folios under i_mmap_rwsem. The lock
only protects the VMA tree and PMD table sharing, nothing about zeroing;
the inode lock and the folio lock are sufficient.

Let's fix it by only holding i_mmap_rwsem while unmapping the full
folios of the hole.

Update the documented locking order in mm/rmap.c and the function
comment above hugetlb_folio_mapping_lock_write().
hugetlb_folio_mapping_lock_write() could now take the lock
unconditionally, but we leave that for a separate change.

The order of the folio lock and i_mmap_rwsem now matches the one for
other folios, which is nice.

This has low urgency, as the race shouldn't really happen all that often
in practice (never seen).

Fixes: 68d32527d340 ("hugetlbfs: zero partial pages during fallocate hole punch")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust comment and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 6 ++----
 mm/hugetlb.c         | 3 +--
 mm/rmap.c            | 4 ++--
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4a92f31c88e1a..2e8672ae2fd52 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -684,8 +684,6 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		return -EPERM;
 	}
 
-	i_mmap_lock_write(mapping);
-
 	/* If range starts before first full page, zero partial page. */
 	if (offset < hole_start)
 		hugetlbfs_zero_partial_page(h, mapping,
@@ -693,10 +691,12 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
+		i_mmap_lock_write(mapping);
 		if (mapping_mapped(mapping))
 			hugetlb_vmdelete_list(mapping,
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
+		i_mmap_unlock_write(mapping);
 	}
 
 	/* If range extends beyond last full page, zero partial page. */
@@ -704,8 +704,6 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		hugetlbfs_zero_partial_page(h, mapping,
 				hole_end, offset + len);
 
-	i_mmap_unlock_write(mapping);
-
 	/* Remove full pages from the file. */
 	if (hole_end > hole_start)
 		remove_inode_hugepages(inode, hole_start, hole_end);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0f3db932266d7..befa2670cb03f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1871,8 +1871,7 @@ void init_new_hugetlb_folio(struct folio *folio)
  * Find and lock address space (mapping) in write mode.
  *
  * Upon entry, the folio is locked which means that folio_mapping() is
- * stable.  Due to locking order, we can only trylock_write.  If we can
- * not get the lock, simply return NULL to caller.
+ * stable. If we cannot get the lock immediately, we simply return NULL.
  */
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 {
diff --git a/mm/rmap.c b/mm/rmap.c
index fe354fa6cc43a..f35b671d26514 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -49,8 +49,8 @@
  *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
  *     vma_lock (hugetlb specific lock for pmd_sharing)
  *       mapping->invalidate_lock (when allocating page cache folios)
- *         mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
- *           folio_lock
+ *         folio_lock
+ *           mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
  */
 
 #include <linux/mm.h>

-- 
2.56.1


