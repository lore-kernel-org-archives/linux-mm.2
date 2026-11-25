Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817FB606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YJEKNsew
Received: by kanga.kvack.org (Postfix)
	id 7FCD46B0B0F; Wed, 25 Nov 2026 17:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D31D6B0B11; Wed, 25 Nov 2026 17:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9E96B0B12; Wed, 25 Nov 2026 17:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40AA36B0B0F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:37:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C654616017A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:37:28 +0000 (UTC)
X-FDA: 85475104176.03.F75BB17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1452B1C000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:37:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJEKNsew;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646247;
	b=gNhb+KSAhXFPRMZUF3U/OXW+tMtfqEK6k35f3Z578w/7MDinnPEgB5EZjax7jP24rmNWkT
	cvnxYfNsQlePaoogbSKT1xKmAnZRetuzT04WDb/lrNqsqELnaSlRZPsJ1FbISrRXP84rz2
	xy8ZOz8G1PaBGfA/21pqhbNgihyas40=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/88ZmpA7ofzoMgWfgW+R9YyORRfy205haZxhA2urC0=;
	b=Q+VtsZZyWS/e12Xu0+h47uERgPk323sX+wc/5FRDPPTKjm810JKjtth4+94SsMeLMOKLBZ
	N004McA2vk+GlQ4KJbuwA7sNQK/dHGE9qj/R6bqHFdvVf0DFlvZOA7WfA2KsN/J1ow0Tep
	Su4HeRvIF3q5y3R38GEKInRaFLjQWbA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YJEKNsew;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A706461D08;
	Wed, 25 Nov 2026 22:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4252B1F000CF;
	Wed, 25 Nov 2026 22:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646245;
	bh=r/88ZmpA7ofzoMgWfgW+R9YyORRfy205haZxhA2urC0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YJEKNsewmLI2r18oxstIpVnByWfyrcBn6xzzvapfFHD1JVPvOLaFRvDpplT/GBlud
	 GxAcgZQbQaqlAy7PQnj201vX8pgyoYiDrp4ZxoW+0DybXurghchrZUBbrxSQgVugQ7
	 zWqmufBhrC3MMeZfcm7v4o9SbFWg58U7UmXX/b97O181tlYyXEaEdwsQ9XROgNWZD7
	 dcKa20kW+EAGZOc18ONlXxjhVZGJp/NXcEQwp461Y69pB4NLisNIB1IMqY9/63Xsj5
	 QUSZbxnNr6t2Iv1gGR0kGrw4ZV5TDJltnZNXPFbZrVZcStWRc9Ksyx1nlY4AfU5DZk
	 Y/qnIDWEZv/5w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:13 +0100
Subject: [PATCH 15/21] mm/hugetlb: stop accounting HugetlbPages once PMD
 tables were shared
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-15-db27fd2f71a8@kernel.org>
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
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3111; i=david@kernel.org;
 h=from:subject:message-id; bh=K65bx0/PtdyC5pc7uEgYhhGf7zKSOQWw4kDznZNplgg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1S7z76RWxGrM3GtanjsH9u8zLUHszoyMrtX16v0K
 S2WL/7aUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwERMAxkZPjDptDIbrc0y8lkg
 db3DYeqRRtP/EhPXLpiqcHdfR8/MhQz/I+9YG1yY9WPudHOBvAeXo797x7Dpx+5pjVtcrjT9dUY
 IAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1452B1C000A
X-Stat-Signature: rzwf6rh5cwtko7zgnq6em49bejmx87uq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646246-54352
X-HE-Meta: U2FsdGVkX18Aim3peqvoyDqkVOjUmDyvn4LkS3JXyub22ZX/XPDMgg00i6K8q4NDZpB6DV74DR66N0hy6w5+01fst8aoizW4wYhlVy1BK7LeQMvqH5aI/kOSPOBoSAr2zwLkirHYjpxXlID/AxJkt87sztXGG8zNH5ZIKPoIyJGvsZ6QXGEmETmJrMd/4hmq1Zwr0IBu1K+pn/RpWApuBV6GypBmnzhzh4bptXZFxgyr4vbBsVf9ejkYOUTN/9O7BauWgZn+jhZ+3x8wzGS2BgHdYyzZjxwdVoohBSi0Dtzcn+c0lAKgCFSGAr31tjcKj3OEGygh2aj+6+1Uk92FmMM3kHLlZtzHF4MdF3eTBnt4Sv/1j2uumkpeJX9HO4WrFcXBE8anMmpf4hXNyoUQ21iZXhsrRkstJW+dWDUPQIAb62XqebcEypa7iLi4S1C08sk4Rswrkhd2UpY5STwjzGlVZ0z12UM3dowJ22FfFolWfXzjOWwNTuU/73ho3vJ/MpTaSfLcX3t09WwChmvPu+nVZH58waJk5YPuWpsGSWvPG5QCNV2EeSrmv9eH5hoYqW64PlgC9pxPgNTxBcYsyZreXRsSZhDZQYxN6aCsd0LGoToga24SNSBZPoQk4GmEhz6cMPHUUkdFq3b1EcSKUIqSDnPsLQcH5MLZMh9kTtyWmNCCpAa6SlmSBm5WGzfJCfg+aDWh92ecatbdNPYzj7aznCCGtZyrM3k8gTVTMXLgU2xT0L19psewCG7lKkwUsyG+m6FgjvfkFOeS4vcnUvHUeFULmdXKjBpPHT9sLvwJHVf6b9kQVnqp0SYjAn7lGsaFC1KeYi2GIJuoOyOI5twtEeR8gRibGGlCbPe2Y8weNbGx97ERx5q8tBwyl9by9cADl2ki3x24Qu0vrnEsY4QtxLDU48ElraJRlfLsFRd/MaYgHgC9u1QTxhP3jhWq4Vb524koCa5yMN5BCEB
 dOmDyHZf
 iGxpPWou8UDqwF+1+xe8DcHyAlcKpe9Rjxb73Rh+8/PJSJygxjz3Gm63R5ACJTT0YcZ1MxNrbbzouxDsnW42b4hcPBrx0YFQA6ysq42Ok5WzIElEGbvr031x7GyPkeHMIpb1SYPfLpAZgUP8F1KT4dbAgtZ+9XzagcDpwqcI0CvBTpdTDMbdJPZNnDxG6vhT61RyZR5U22WOdJHJbXnJ5OGVF5CPKjnajmOEI6i5MI8lLbwGNsE/qvDaILLGw5If6TdJHFy3QS9jtEDm9pBYXeAijxdUdr5jOBCHYkVKjeL6jhg5hFkIqR/mmiydpvvBl0PbSS40b6gEd3iQ2JiqulQgnbTAXtwtEI9BuXBuZG0ZFa96RCn2QC3+yFtFvQVTSYXnKTbRtbpxaW3Eotzt37MbXWjzyS/AnPovXcOSM6WZbwkC6AaSzellOBgy60w2g8s7lof6D/+5Ox2UXFBwveY5YffxBGCgq5JfK9wPIGhAeCM0K6x6g+sd1jqOYwPfDdcjzrUMXWjTrJKnAnkAXpu7ssNYQDt5JyUXZiGFqPgVyOKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sharing hugetlb PMD tables can leave HugetlbPages in /proc/<pid>/status
too low or too high, or make it underflow: when (un)mapping a folio in a
shared PMD table, we only adjust mm->hugetlb_usage of the MM we process,
not of the other sharers.

Accounting this precisely is not worth it for a statistic, so let's just
give up: once an MM shares a PMD table, set mm->hugetlb_usage of both
MMs to LONG_MIN / 2, and report negative values as 0. Later updates
cannot realistically make it positive again, as PMD table sharing is
64-bit only.

Document that HugetlbPages is 0 once a process shared hugetlb PMD page
tables.

This has low urgency, as it only affects a statistic. Let's not CC
stable.

Fixes: 5d317b2b6536 ("mm: hugetlb: proc: add HugetlbPages field to /proc/PID/status")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/filesystems/proc.rst | 3 ++-
 mm/hugetlb.c                       | 9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index bcbcb41814d96..8696359b06498 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -268,7 +268,8 @@ It's slow but very precise.
  VmPTE                       size of page table entries
  VmSwap                      amount of swap used by anonymous private data
                              (shmem swap usage is not included)
- HugetlbPages                size of hugetlb memory portions
+ HugetlbPages                size of hugetlb memory portions (0 once the
+                             process shared hugetlb PMD page tables)
  CoreDumping                 process's memory is currently being dumped
                              (killing the process may lead to a corrupted core)
  THP_enabled                 process is allowed to use THP (returns 0 when
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 89d71e3dadd77..796f02a4ded63 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4744,8 +4744,9 @@ void hugetlb_show_meminfo_node(int nid)
 
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
 {
+	/* Negative once the MM shared PMD tables, see huge_pmd_share(). */
 	seq_printf(m, "HugetlbPages:\t%8lu kB\n",
-		   K(atomic_long_read(&mm->hugetlb_usage)));
+		   K(max(atomic_long_read(&mm->hugetlb_usage), 0L)));
 }
 
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
@@ -7310,6 +7311,12 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
 		hugetlbfs_pmd_sharing_inc(file_inode(vma->vm_file));
 		mm_inc_nr_pmds(mm);
+		/*
+		 * (Un)mapping folios with shared PMD tables would require
+		 * updating statistics of all MMs. Instead, give up accounting.
+		 */
+		atomic_long_set(&mm->hugetlb_usage, LONG_MIN / 2);
+		atomic_long_set(&svma->vm_mm->hugetlb_usage, LONG_MIN / 2);
 	} else {
 		ptdesc_pmd_pts_dec(virt_to_ptdesc(spte));
 	}

-- 
2.56.1


