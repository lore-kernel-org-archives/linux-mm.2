Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60DA606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mcGV1irF
Received: by kanga.kvack.org (Postfix)
	id BA6C56B0B15; Wed, 25 Nov 2026 17:38:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E396B0B17; Wed, 25 Nov 2026 17:38:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D3D6B0B18; Wed, 25 Nov 2026 17:38:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3A96B0B15
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:38:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0891F1C3C9E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:38:19 +0000 (UTC)
X-FDA: 85475106318.25.5F91D9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 387F12000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:38:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcGV1irF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646297;
	b=W2S7qD59fT+V6CHCSreCLbdLIzTtuRSggPtLEwWbuHDUHYI6qOHPDH3kXaD9uKNfnM9l8B
	N7etiSBJoAzqFZCWr0qGEbwNrJXy/Uu8gvpEDRtFmQAKZMx5J5bFPu2bSQdaiB38A3sSHm
	p1pTLvY5QkuRd9hlZpZgW/Iww1JQAC8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5sCadhkwY9UanmmId4XEWhXMASQtuWsR/mG1JPVDXI=;
	b=glV8aY3FaAsbfZgDzceH5ZkFHN38tP0i+ueHWtk7nDJx+IPVEbnlcaDSLbW7XbzPELOp4R
	ycZ8K9v69PcpPHBaKdKvUMpFXUPTDhb8BzIU1I9WzJOnNe9OF+t7/uHEGGeGLxGuOhtoIa
	lB2Fd394GN2uqRMttwROUEqbtT8daps=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcGV1irF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8BD843B07;
	Wed, 25 Nov 2026 22:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CA81F000C0;
	Wed, 25 Nov 2026 22:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646295;
	bh=c5sCadhkwY9UanmmId4XEWhXMASQtuWsR/mG1JPVDXI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mcGV1irFRfXDZP7eEVn2PE6y0zqMjBz3R4YH3XVsY1dIM8vndetGzsNVRLSa9MHqH
	 Hl8tPm3IHHw8Q+AWHbAmKVE8Eokao7NczVWg8nPhKPR1BZ9rGJoernBmso/wi+Lvmn
	 I1oNfQ86/7bW+rb+gZM3Sr9iVsB0iUxRM+nd6p3ha72bJMyr4FvbaQnt+EQPcQhZDF
	 xmmEK1Ro+b8WaD1DQn4PQv8jOyiIt5Q8LY+q5ei+PGW6+Ud9+cpmHuOCatVBkqyr6Y
	 lpvOFTcZtHdIOmkTP6GZ7zxp2qtV9fIRjDzqLM0Ep6XUzFQ42c4NcdPFrDEK/hSR1A
	 sk6LwO1VZkHZQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:16 +0100
Subject: [PATCH 18/21] fs/proc/task_mmu: don't clear VM_SOFTDIRTY on
 hugetlb VMAs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-18-db27fd2f71a8@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1880; i=david@kernel.org;
 h=from:subject:message-id; bh=+sv+UhDuOwJztPqdlwWWA+euIQWZKN3bwN8oaLd2OMA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1RjN1gnhsRf/3P15CPRqcePHrc9xZkad2Pdwldv2
 2d6xawS7ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiu5Yx/I/o3civLLybU1m6
 1z3Qdp/Q7vdu6p+t9rxujPg/YU3NK1dGhtfpgcuaM5e8/G12cbkh71vRn9cr38Tqv9XZ8iC0ILr
 MnQsA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 387F12000B
X-Stat-Signature: oi7jhk5sp44x3rntkewcw9zgcpkgwfwd
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795646297-767330
X-HE-Meta: U2FsdGVkX1/87YyNlRVphmD68XwjQ8zjFF+LsT/1Rl7Uj7Q79hnwIhUSXGUsST6o4nE8FvG5C2/YR0Pl6xXzXnm0fI0DlCwud6mNn/URvWPfjzMHrMCP+pT/rkp3bkfrxiGe7LyonwC5rNUHW/G0CA6UzkEjnXWIrTajwGPTH5W5Fq13lWAOt86TjHoGg6AsJ5sGZGXFV/lgh+366iEdFmoH+978JboJ8yVrqMefCgAKbUDbSRGH9SHWaZgdeUcYrfgglfuNq+4t5wCu3mTd8u5kV6swx9/8UEykzaNMqcbwATOQovUv83tv/ytjfSEkFVAuk4E2T3gGAKJKp8x86s/A2LyEa6AVs/Q8USs+cyHB28jicc7l8cFcQAfGm1zP7KmELuF4G6nXF84BM9ejkDxzpUV9kT6KUKSQmYUi7YIJVJeEMF2FJxejBFYVO90O/bmIOWpejydMTdF3l+gTcF/RBRkAoV1wGG5mbhbemQaEuCYrpF56Ban+fblYUKPCS3x2eMFPGa5uE9zd+X3BMygUEZySLsheXAwncBM0F0ITwIw/aDylEJHx5f6+IIcUct7k44RcSezAjrg4uuKByy94JloWz+GQx9xHM6j3DxyvkBjM+E3DxayLutVX84/WQR49+ejKlwkjbQdh72Gh2q7wq9qBlDs7sIBTyoGK8P+wMFUzNBljrKJg6zqYrwFlbZ4VUx+2ZITIyuAMq4J0R3bwfyFWO91DFkcYqwM/S5zfEexZTg3HudmUdCC5fm24H6Kr/dZnvrOVSDrNqoGxqrf0ZQNWeTj2IC+92FYPQc+GM8FaPHxjKv1KOgyokmVjquljZxANF8fk39BD5pqTevZqV8fZXgrytA2zo2QeoB/089CswZjoQRj2CZem24Zfvu7kzffjjw5dkP+wdJjUBK3FOayTUF6qdFOwxDADSB0/1AQf04FDG1bFHvTqmnzP8NZw5w08ts0Kjjf1w2W
 NvQCb+tp
 /hk3H2nSyJZxN14B1LrJusS+uCWySXZQZtq44JO4FHBzJQG/T/sShNwPsBVtbJV4GaRM0wtAJzSU6Oedls/GCb6LyoLdd1wog1oDF6nwzD3UfrZnIZfbnS1FM0Vw9GqntdJKydCnV6dnmxHhw/gOESFRr6kzCU66IBZjFygToJaXy6W3jSllEBjt2KPqz7o+a+TOS3le4BVGtSL+vtEy4vLHp1iOIsC7hIUzRn8VkIknyt5D5g6DfmaPHz74bmN8q9pOcJSPOaHOqKx9kawbXGVNsHTGrsiFFp/MnOM+Qy88zlGkIIMUgD0P2pYfJAf7qzC11HDpioE8sygPQb/Ojdq5lpnW2ToG0cuyHGx3MoR2qB8lDQ84FhmYjmuXquFb4T+lP6goZd1AVJsHJEk4PgKnCaezoye/lx66OTAc40+P0gxk/+I6I+sT4Y4PYIgnsStjDMO4+6w9D3dd358CVSidi0NlVrUtY6bpb2tGyWKvjWEbOLPJh5A384aDtDcOBGyUyeZEKE4YBNV8fg7cq53JgELBAOCMgQ30KrSa2nvD/WplY8o/YKVreVZr9Cu/b62xbBCGQW5+lDdQPctydNCThHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlb does not support soft-dirty tracking: since commit f96f7a40874d
("mm/hugetlb: fix hugetlb not supporting softdirty tracking"),
vma_wants_writenotify() ignores VM_SOFTDIRTY for hugetlb VMAs, and
clear_refs never clears the soft-dirty bits of hugetlb entries.

However, clear_refs still clears VM_SOFTDIRTY on hugetlb VMAs. With
CONFIG_MEM_SOFT_DIRTY, a FOLL_FORCE write to a private hugetlb mapping
without VM_WRITE can then loop in __get_user_pages() until the task is
killed, with the mmap_lock held for reading:

    __get_user_pages()
    retry:
      follow_page_mask()
        follow_huge_pmd()
          can_follow_write_pmd()
            pmd_needs_soft_dirty_wp() is true
          returns NULL
      faultin_page()
        hugetlb_wp()
          set_huge_ptep_maybe_writable()
            no VM_WRITE: the entry stays as it is
        returns 0
      goto retry

Let's fix it by not clearing VM_SOFTDIRTY on hugetlb VMAs, so we always
treat hugetlb pages as soft-dirty.

This has low urgency, as the loop can be killed.

Fixes: 052ccfbcc6cd ("mm/hugetlb: support FOLL_FORCE|FOLL_WRITE")
Cc: <stable@vger.kernel.org>
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 41b280ab7b19d..d9ecb94f4daa5 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1801,6 +1801,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			for_each_vma(vmi, vma) {
+				/* hugetlb does not support soft-dirty tracking. */
+				if (vma_is_hugetlb(vma))
+					continue;
 				if (!(vma->vm_flags & VM_SOFTDIRTY))
 					continue;
 				vm_flags_clear(vma, VM_SOFTDIRTY);

-- 
2.56.1


