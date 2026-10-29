Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB25606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=odGKC4Xb
Received: by kanga.kvack.org (Postfix)
	id 164E26B05E9; Thu, 29 Oct 2026 16:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CB56B05EA; Thu, 29 Oct 2026 16:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052A86B05EB; Thu, 29 Oct 2026 16:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9C8E6B05E9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:42:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7051E140476
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:42:37 +0000 (UTC)
X-FDA: 85376837154.25.9DA4408
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id BCFFC120006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:42:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odGKC4Xb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzohAuTFTF3f/1hrG58iOYYkxgWAfRYzNd87kJom8ew=;
	b=udIM+XwWPXVDIePivo/nMR2wjvZy05IxM+fpZl+nG8YGgFEkRDrtExS0JL4XWjf0JU04lK
	C6MSXr2KOwhV0D9e3NnodjPOoBgL2H0PZ+UI54B0qZZeVOWBwHIOrPEASf343aHbJOcdKY
	rv1AQ3Me5Z3uOnV/pjgDG12h8ylirzs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odGKC4Xb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306555;
	b=Gr4fUNB/4BkigJBumXDsBU18TxCk09OEkaI7vYSNDbdljnyjTE+tsNkP6BtFwrJCDhwU94
	2f5q4sy79AtYhAkKsxWGTbhcETcCVl9Y/G+KQgsBXYo6cfm9EM9hagrEn6OlL0yc7PnzSm
	OxD0w4AloN3KYE7IwoU4RSnnR9yinE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A1F7601EE;
	Thu, 29 Oct 2026 20:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038A81F01816;
	Thu, 29 Oct 2026 20:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306555;
	bh=GzohAuTFTF3f/1hrG58iOYYkxgWAfRYzNd87kJom8ew=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=odGKC4XbmYtEAL0Gbsmsvx/WY4VvPYy77ntTduDNGVxTee9x8eCFs1dlirZrbm7zy
	 iC+kt5OPi0b7fGJlGk807OCvIbOWr/Z78TV/dFDtdfnfrPq2aHFVXyMPhLCSOvB1Y2
	 ZrN4hFhr9U2G7pJPJRhXKDaX8gWNjGlvbNVUoesFXn/q0rr+u58Qom2mW6f0Q09dKe
	 3q0AyCRIpFeQddnbKDlVIMB1qh/ZQ3BtSWnCL5WPB7IN9/D8mom8vqt7yZu9Csa5jg
	 BDnVwDUFvXRY6YrP7saZiBtyJiwIROc+tG9ELKoNHPe8loZEUzoVScdiDJdLpehZRi
	 /RsACXHCoLgfQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:32 +0100
Subject: [PATCH v2 37/47] mm: fix unkillable fault loop on MAP_DROPPABLE
 memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-37-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=david@kernel.org;
 h=from:subject:message-id; bh=yoxwQ2Y6qIbeUiwHGT1Y0HumpGAEonmZ/vQerxKuLzY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+3czvM5O0THx//vtoUbudj7mWSPupTa/Tnr4Jkd8
 Tn+Vk51RykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABNZl8XI8FEnafGyvrx5M6Kn
 sCw4PefgS4/ySwEXYgxE4k5desdXsorhf+JjyZr1Ze+2Bc4VtlpxsJI/8JO19IGImflnzH06jdO
 qmAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: BCFFC120006
X-Stat-Signature: y61b679atyc1b86cjogck3swm6wjdb7x
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793306555-742289
X-HE-Meta: U2FsdGVkX18X8wKFyNq73wWYALIq6r1ZT9O3QWwsscKkM56wgF6Ol8Gx0lRke9iTJNKvM2HjOff3DscV6mo3K09OdZ4/j+RabeX8CFbpfZgGkblbJV1CwNNaPuGbVXpnsYGCOKqQ91MvJNdcBFV0XKWSRo4QE6ckml7zMRn5YPOwoRqrovXMjXEx7lZWLMUyFyptP/2BaVUfaZStZg+lB/XZIZfVwWZTmlQiF9ly+2fxHhPB0oCwb7q5hHUwYNJAqOf3dlYdlbyPmEl86sD3NHNOqtL/sHbxVZUyspYP9d26QFB6y/xeTlKMRwFPh7Byvj7vo+f5oq4dNkS2qnKSy+KHKRDl+cIOlHWzNd1VcX0IADsSxeRdLhdET35VXc5eGazefFLh1AGEKdhHTbZISKKEzPfNdmoPxKZBINnK0UIU86BOgOWyd6C02oZ2/uCZDX6R5tOHwy0BLQtp1IeDYpffgVcblDd1QnLssrFRj849heUBNjMby9Lzk7XI/dTElD0/3ww0r9PyvJBsAKEIBcmPNlWS9IAPzgCwccMPwt8/Se9fQVp2iG7fkx0HRYAlT2gzTVq7HcTXgtsrWzO/FqnPu/4+356KyHlofjjpYjb6SyIRLvnkjt5L2mKNsZ9RmfJkPBokGF8E1SSX2FKKBS5yfb6KJK8siIjAkIv/UrtnshF5Zz7xOG8NE1NtnW+qG51/clp1WWX6JItocp1EOHdjIl+mZr9CY87+kOxBPzwAyJTOdPiFD1LAH+me6nt5xT8uF1VRgLBTEezattzN4N7tXsS7sOs8teXGtHakZCSQFUPKHSDXkUmPZv8dvcx8depVNw1XfHUYSqqEcD+InGWlbtw2huPYQJsDwxBR6ZOBK1SbMtU4vSHpPdcy8927d/Sc1EaGNQlpuovIQZfLeUNEoq793ZXhtMUdG7s57vMdovnEFnZNme557mnxiTl3HmDsvj0qkIf5u9T+zXn
 u5+IiXhx
 k3m+dNL2JcaJ1wd971DsNSjinEv4Gl2G2wrKduJJ2tsP4miAwF2ecsbj9BgpHzR3T6ZErooEcFENTxGOpG+LGiw+6MjibqaMMRLJ8dL6Pab14jWTz/BXSe2noMdXVY363tJ1XvEfJqlP0rWNLZgnhVOT/dZ4Wx/UsvIK/3BnLeOuQ4XGwiiPCQJBzUbWF5bw/4ps1xVp9dPlowgrw93UQqeAMO+E4kpjnbIUdYDn5iWn35aPJJRlMDDiEAxSZJa8KrxjIhrvJlAd6pHFgVKUhYLzCKx7u376EbQhQ+Rry/U1kx9UYXY4L4xf/qZ2gwwUW55zaiqEDBuTQlUuq3NKodNMIhjkxH03S2sVSaowwuAx8RDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

handle_mm_fault() suppresses VM_FAULT_OOM for VM_DROPPABLE mappings.

For user-mode faults, pending signals are processed before retrying the
access. Kernel-mode faults on user buffers instead return directly to
the faulting instruction.

With persistent allocation failures (esp. memcg limits), a syscall,
such as write(), can therefore loop while not dropping locks.

Only suppress VM_FAULT_OOM when FAULT_FLAG_USER is set, allowing
kernel-mode faults and GUP to fail and signal allocation errors.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: simplify description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 732b8f926de6..77d4bbf444bc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6957,8 +6957,12 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 
 	lru_gen_exit_fault();
 
-	/* If the mapping is droppable, then errors due to OOM aren't fatal. */
-	if (is_droppable)
+	/*
+	 * If the mapping is droppable, then errors due to OOM aren't fatal: the
+	 * task returns to user mode, handles its signals and tries again. A
+	 * fault from kernel mode has no such return, so it must see the error.
+	 */
+	if (is_droppable && (flags & FAULT_FLAG_USER))
 		ret &= ~VM_FAULT_OOM;
 
 	if (flags & FAULT_FLAG_USER) {

-- 
2.43.0


