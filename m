Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF44606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NmYEF5Ft
Received: by kanga.kvack.org (Postfix)
	id 385F36B0AF3; Wed, 25 Nov 2026 17:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337206B0AF5; Wed, 25 Nov 2026 17:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225D66B0AF6; Wed, 25 Nov 2026 17:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9DB36B0AF3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:33:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E046160177
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:33:45 +0000 (UTC)
X-FDA: 85475094810.30.A86CDAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A927818000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:33:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NmYEF5Ft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646023;
	b=Nchx9ahBDXTpcK++wAEJ/234B4sPaY6c9A7Nmra4I2z/8d6m0pmDHPaAcZYjd2nmjst7og
	fP4NC3+kKWt6ZPWRrLzj7TTJB7cl85C3y87egUt8B8oRj81ek/tfaIgmlkodFxOLcU65hh
	jNIxqpCbvqif/Ne1nLg7BC7NxddH5zo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXzNfGo7RfddoR5dRtUrH7smQbzk3tlvBFxiBJPCKVk=;
	b=WCLUuO5NN047NCXHef/vsxq+NPxQsSustO55oxEnYUCE8U7wFOeRgoz4Ech+T/rLrBbfCv
	RoH201sDw6VcljRSyBZbSSrLyMsCNgIsdxOeMXZfrmcAdBPMvLuC8uVhVUS76aauWtiupJ
	/UirevwNwFoP+p36EnpitNKsaYI4eSk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NmYEF5Ft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A3D56123D;
	Wed, 25 Nov 2026 22:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5351F000C0;
	Wed, 25 Nov 2026 22:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646022;
	bh=fXzNfGo7RfddoR5dRtUrH7smQbzk3tlvBFxiBJPCKVk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NmYEF5FtX6uDI4qQqeJ26Pi4q7EkUp7H9qXmB+5VFWNUj0H7Lmevbqo+IwECQy0US
	 Gzi27CL25JJNKCkmrMQZH8U1+eeac5ljt2zihFcIjGZH8IA1N1cbOlStAX0wbmBa/q
	 trk736gQ1b2+GcOsSwVSGK9aWe0QBsOEdC5Qipg3JCi1+iYUfH01y4nje16Wz6NEvY
	 esLL13GSFWNe+4ESBtAVcOyX0slwHcGsslTY83n/HNm6RKej8uCOpS8hOo/6ERIEDA
	 KRByR6HZ/krdf8FgVgQ3FOkgN8ZbxY/HJv4RLNv94Ic0noflkaUZcIOmNcMhc2HBfA
	 rBGq+fN9NCX9Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:32:59 +0100
Subject: [PATCH 01/21] mm/hugetlb: charge the copy made at fork to the
 parent
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-1-db27fd2f71a8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3025; i=david@kernel.org;
 h=from:subject:message-id; bh=2bk4PJ9Bi2fWpYOfBgjZCtpD6hSW3oRGiP3OyVjpNlM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk5R/n7v2dSOzb41n7rspJSwMBjsiju1PTdvqYWi/s
 /J98N7yjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbC3srIsHpN3uQpJWdPKmml
 mkou3sKd1ZT2+hlHo+vS2Y8Y9rw9m87wz/4V+3ax/zaKxnyGK17pyR7bKHg6ou9GlkPCtppfizJ
 38gAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A927818000E
X-Stat-Signature: sn6csbkw58qjqdkttpbr69bhwb1dmd6k
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795646023-171555
X-HE-Meta: U2FsdGVkX1+GzvO19bkZeVEFXs2yXko+G8YQ9jFy8N7APll0Zqoe6uYVax0wrwYk1KCzWhCDLooToPAEt14B7hoN+LydmYhD1yJzjK3gr8elX49fe9hCbVNfKr9Tv/muB8/waaaD9rcsDYrdg3MfKqPUbgylOAXmeTj5DTRqLsfVLpWs4B7DDEXHMWCV8ntafDdausjqj8wXXS7UfDND/zEuKa6QcmcyDV8pzwUaDfegBhrPUyA5G75sY83zgKB/+b/zxgBohJJyWzvPN3b5HWtWIEsaLhGyx0hszTWKeqBBq1OYzkpxQ+oltpi9mlGgSM5vh/Qs/+6t+kUtQuhCz86ECip6zsJIK9lhS6bxWoQkhntoTx5ZxzZrtn4CorCpVGEPdd7DjNKVJlwVT2S+XKHSwnJtv5Gm0ZpQrDPULJ2QkY5rVoyM4c2unR2VYM4yU26jVCETPofBLgen6z9mUHSeT8X6g2ZSq2FHcalZqMA+jOiR8KaenvC0yopgPueCZkoY2IU6RuFMj496N69ZgP6Kj/pm2y/dYaPvIhnlxD1/AQnRuHQB997hEXK8uKKMEIyOpnWSTa2hI4IKfbwoFCo3kXgcF0aYHgesFKoev6S0Mg8xuPvZHf3sIuYHHjS+60ieF4URLcW59f/8ko0RotJi+UP/LbKuPOFInaqT7fMltOAXt9uanDUji9NYc/JOL5EDVE8Rk7tJsSwtWvkOGhpH4kFkofLSUkdOUnv2kkKJ+UyIkK9Qnjog2Yogm5/QepJXNgxzgk2qIamlfGDaVhOpluK4Xp5y97xVZyUSkBAwUpsJ+wGm19Vu0ILBF7jkabiVluumL6oilO7hq5CWHbJXN2wTedxF/no4TNKVsdwi2A0NI/dcCGFFUBkEn4J0nPxG52WajOo+bgkR+vAcRNDvqbAABZvz3Vo00e00P7DC/tI4xfZYM6kSfJyiNOjHYrK073TCJd33N312viK
 leRSeT7h
 +G5UVpNWQPhza0WwYZpuBty7qeAaX74Ygm/YC1W1owvjUJ8VJzPARA58NhmS/3Y0LBjJ4sfFBQrE1qSS7t+drhVlz5+GQKSusGn/Drp4jlSC4ahgm8i+2TQglqsxn23nTiab5m1vueCjzxuXyqFBYg4hex1WFGWXgQ891/vPOFBgicC5AhAbOo/dhaH4rfCq+M+w6TdQUOrd4D5+7n592Mi/olWOLTh/yBW0Oq9oHAFIX/G3IifSovNu+2BylbERtI+1CQD6gqy/Mmf49FtV3BR+DTuZU3sHxHX9ii+3Ws54msVP+APlWzdsbfDqtsNrL1uF7axqLP9PU7fkJ461GlzKTDn1CmXKwe4pwPBjGNAkjFTLSPwwllErwA50Y1cVPJDCVTbY7jmHPzt3GAizb9nIZanWmnXTWF1Wa8PSmTp+3iCLLLJxmezItiVH4QO4QKcS4LD7ByxL1F+FP+9XxZ7+BYA1mwsIB/AKJpi9P/3jgH715cJwg/6yqcma/6EHcOfjLF53YjhODB8JL8/y9vWf0Ju1jSdsIFelOFhEXgNe8sdLvakeYXU7Q5gjMSA29+0ZCoxELJ2EsPCkdzeAaCUyZMMeqya3ehp+J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When copying page tables during fork(), the child is not yet assigned to
the right memcg. When copying possibly pinned anon hugetlb folios, we
must charge them to the parent's memcg, otherwise we can end up
allocating more hugetlb folios than allowed.

Let's fix it by charging the copy to the parent's mm, like we do when
copying small folios in copy_present_page(), introducing a new helper
function alloc_hugetlb_folio_for_fork().

This is a hotfix for v7.4.

Fixes: c2deb1356d82 ("mm/hugetlb: charge folios to the target mm's memcg")
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d0e66fb306221..f46c85fc0cd0b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3103,8 +3103,9 @@ typedef enum {
  * allocation).  New call sites should (probably) never set it to true!!
  * When it's set, the allocation will bypass all vma level reservations.
  */
-struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				    unsigned long addr, bool cow_from_owner)
+static struct folio *__alloc_hugetlb_folio(struct vm_area_struct *vma,
+		unsigned long addr, bool cow_from_owner,
+		struct mm_struct *memcg_mm)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
@@ -3187,7 +3188,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		.nodemask = nodemask,
 	};
 
-	folio = hugetlb_alloc_folio(h, &mpoli, vma->vm_mm, alloc_flags);
+	folio = hugetlb_alloc_folio(h, &mpoli, memcg_mm, alloc_flags);
 
 	mpol_cond_put(mpol);
 
@@ -3249,6 +3250,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	return ERR_PTR(ret);
 }
 
+struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
+		unsigned long addr, bool cow_from_owner)
+{
+	return __alloc_hugetlb_folio(vma, addr, cow_from_owner, vma->vm_mm);
+}
+
+/*
+ * Allocate a folio for a copy in the child VMA during fork(), charged to the
+ * parent's mm: the child is not in its memory cgroup yet.
+ */
+static struct folio *alloc_hugetlb_folio_for_fork(struct vm_area_struct *dst_vma,
+		unsigned long addr, struct mm_struct *src_mm)
+{
+	return __alloc_hugetlb_folio(dst_vma, addr, /* cow_from_owner = */ false,
+				     src_mm);
+}
+
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
 	if (hugetlb_early_cma(h))
@@ -5110,7 +5128,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
+				new_folio = alloc_hugetlb_folio_for_fork(dst_vma, addr, src);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);

-- 
2.56.1


