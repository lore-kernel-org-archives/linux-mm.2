Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F66E606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmsTCXIE
Received: by kanga.kvack.org (Postfix)
	id 7F8D16B0B07; Wed, 25 Nov 2026 17:36:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0056B0B09; Wed, 25 Nov 2026 17:36:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6156B0B0A; Wed, 25 Nov 2026 17:36:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 468D26B0B07
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:36:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C902714016D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:36:24 +0000 (UTC)
X-FDA: 85475101488.04.9917972
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2099716000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:36:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BmsTCXIE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646183;
	b=6AmF0IvG8I0uB8rj02r29YvYgFYLCMmV383jS01xWlzjnXAWrWtQLv/kJkTAMnAYJ6cGoH
	ci6oDvFsoZ/5wDZIXmxKD4N6URceIyY+3vsFMjPUGZJE+bZvREvtZ9Ljn6C14/PmlwvE9Z
	j8mUd9x7SXke+qitzWQFnodO55+zux4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZpBmqbQgXgMnTQ2l4D3Ajs1IvGXdBhBJX97XEhXrFw=;
	b=3whvm2jMuyps6KJzIvBoQ/KzzH5/ky3nGCsSTkXlLePEGlPxXlJHL8ZCchyENErhFZIOie
	ckr4JECq/VRlfDkxXlecCagcqIICToeg1cRhhBkYvDJuHVTlAY2cEru89CxvLZBO4t/N5E
	L4mSo2i7bR+UBREdZtzdwIPfp2jNpPw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BmsTCXIE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95118628F1;
	Wed, 25 Nov 2026 22:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598C71F000C6;
	Wed, 25 Nov 2026 22:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646182;
	bh=mZpBmqbQgXgMnTQ2l4D3Ajs1IvGXdBhBJX97XEhXrFw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BmsTCXIEHzyk1Iz3UrAmJqsf3yHx5toX3cmpJM5kGRORGuPeuzYOlsDrF8XRi+99N
	 j9evxWo6rcK8doMUD9vmK1thBCtMq5uX8vc8TxGnfOgvgN0sK1afqV4d/TbeAsN+bv
	 b8BiNeoB4vopglr3JXsfHw5M37KsLQN0BwCEJytLA1a6wCSRHFe4RJHYqC1L9XfI7k
	 qUKpnSUFKJuQaiXSMEM4PWhJoL/P+br2Twoofuuz2Uvtfi5ubkKhgkpKQN64s84iGN
	 eT+TMY/5RBB7nmUvqsexw1/SyyTQISQBuiOOdYDcBDEssVNYa4BSoEdNjJtV7SOmch
	 Yn7sJqQjyEgFw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:09 +0100
Subject: [PATCH 11/21] mm/migrate: check hugetlb PMD sharing in
 move_pages()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-11-db27fd2f71a8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2908; i=david@kernel.org;
 h=from:subject:message-id; bh=LCKF5BA45+5q+zlGMmgNQ58xhaVraHm1MhKbZUIdXxE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1SOsM2XOqg9/+16iS+zL/m5bQuprN2nbVLyaMWcm
 VaTnnh87ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi0r2MDJviahiD/OV+Mjuk
 H7d1XiSutsrqw38Di6cGh6vvLgy042X4Z3d13c6okD9K3F/OWp2R+rN7yptrPq47wnvqp3bU8Of
 cZwAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 2099716000D
X-Stat-Signature: j3rts5dcbdyrzs4hae1rmoatfj3unwmf
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795646182-992053
X-HE-Meta: U2FsdGVkX19rblpsCKB//w4yeUuqRmNFncZ1IXKpefQB23QNcC7cxBOYGUxO33XDFDSugbIDQ0HlVkbqXIAZodn5IWVta2MISeehQV1nHJ63ALd62PD+9XlBetihoN+CjQ5Iel1Orn//lVeIAa6CzB74iy4SHjDX1UzAhW3BPXz768poTvOUjnd1y4YqS0br6haEchxvjRPR/+K5ybnQcto5VYEO3+qJ8RfJ7I8brCn/viFfK/4JikIkc8Zq6EcVHd+zYg/MU2xVxihfWprrTwnUGFN1IHqXTV2HA1/3IoQ8iBrVFrosPO2aVE2PRHaj3Dr4AVHoqAT2c6olDLfo1cVzIOMjAOFj71s0xP2JVC6L7B5GFpYce/jUneZaPmj16j3p5tW0YET7LMdNyO0xSHJ2t3FXCFdtwu0JmF5SPb5EaGgLQ+AuQNYVL+Wp95aYId7osAZhsaenbqAwGtL2iaMZz6JGDUhw2H1Z1BN00R62nlJSE8M/VyKZ9nywchfwIaSNRNgcnF4ItBUGwCfGTZGqT8H149b+Kb0xm2BYbxECkSizu131IWdT5F9PrZ8YaDOONzIzpfHg9mfCgCkPdrv44Ws4AlbxaHje0kvXh2vunuEvOLdRHJP8FIUQLlkZae4uif8zDKKwBnhXjrbhoBDMdIx134OGlUphBR4pCDdZu6zr2gdcIzFoMe1qDMpgsA6f7cudNx7uH1i6gfiPPg7kEGxcg3PmoST6AzgnJ56zSotmqNTms1wh3Tz+8fQEbwwRpvPu3fyUxpT13asZTz2gjs+goj2pg0s+BiAnhBJHf66X5fNmz+hlOK+rVbbTQNpVivk51VZ464PWK5pYrU5nvyjZEQ2AoHP0a3/zAaqaClvoj9RfgdJznFBHCf3nmFN0zYJklvrYSAYOJ+EIh97wae7R5hj+ZkuPypS4YvEHC/y1pIETptgLQs+NdbhRg9jt46Gy7r/lzugB74K
 PnaIEaUl
 ZaVX2TX2lJB2sRzj3N1Wl36OKYcqch3glKTlcUqoPUlMbmEqx3hUM/MGsFm4HU1PrZfluIvx+D3hdISvj2wpVt7Xwj3CHy5bqMT8AwOjxHpW35PbPYNm85KiZkr8BKEG4uFCG0AynggXAmEKEc9PWSSI+XfoJsDyWfgxc1j6GxGWCz5iu9Y9PObqqFsYrZ9a1wrgcQtQMBYbCiopD5jhN0LNAGYk3RR2cQk/gjXX+MTISBIZyhHZ3CVXaFoxOzsLHdMmmW0yuFduJRs9Z4ebhEIbVwTPUCDt7K8jf72ypgAinQI9MhQ37Vdqe2fuut2tJ6q5aD9lwmQkKinVHAPZI2pyqeQDJM84FTikiAF9Lsr98vqM3v1ckd4o0ALi3t8LHFmNG2LWrrzLAipCNLOPBfn2p1+FmsT9VqfgCVXZFOnxPLE4rXAZb1EUgZay19cFpgVXnJ+QMwvtembghP325gGWukxEnNbmF21KNL85ZriuAHErE6iZ/QtmfI9JJOXGtiWhtujKKV3Ur0omX9lW1IeotGLeluH8xHvCJSGMFHQfNEL8l5IC2Sfk298s7WANHTI37d9JKAZWAPkqBFx+XwwKSO9Dvmh3n9NnFaVHJAthzOkXtg4ndfbVUL1cMl8I8KdHu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Without MPOL_MF_MOVE_ALL, which requires CAP_SYS_NICE, move_pages(2)
refuses to migrate folios that might be mapped by other processes.

However, folio_maybe_mapped_shared() does not check for page table
sharing. So move_pages(2) with MPOL_MF_MOVE can migrate hugetlb
folios that other processes map.

mbind(2) and migrate_pages(2) already handle PMD table sharing since
commit 73bdf65ea748 ("migrate: hugetlb: check for hugetlb shared PMD in
node migration"), but we missed move_pages(2).

Let's fix it by using hugetlb_folio_maybe_mapped_shared() for hugetlb
folios in move_pages(2). Such folios are now reported with -EACCES in
the status array.

Rework the code to have separate checks for hugetlb vs. !hugetlb.

This has low urgency.

Fixes: e632a938d914 ("mm: migrate: add hugepage migration code to move_pages()")
Cc: <stable@vger.kernel.org>
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/migrate.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 0430197fdc04b..194d74152e8e3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2279,8 +2279,9 @@ static int do_move_pages_to_node(struct list_head *pagelist, int node)
 	return err;
 }
 
-static int __add_folio_for_migration(struct folio *folio, int node,
-		struct list_head *pagelist, bool migrate_all)
+static int __add_folio_for_migration(struct folio *folio,
+		struct folio_walk *fw, int node, struct list_head *pagelist,
+		bool migrate_all)
 {
 	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 		return -EFAULT;
@@ -2291,13 +2292,19 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 	if (folio_nid(folio) == node)
 		return 0;
 
-	if (folio_maybe_mapped_shared(folio) && !migrate_all)
-		return -EACCES;
-
 	if (folio_test_hugetlb(folio)) {
+		/* fw->ptep aliases fw->pmdp and fw->pudp. */
+		if (!migrate_all && hugetlb_folio_maybe_mapped_shared(folio, fw->ptep))
+			return -EACCES;
 		if (folio_isolate_hugetlb(folio, pagelist))
 			return 1;
-	} else if (folio_isolate_lru(folio)) {
+		return -EBUSY;
+	}
+
+	if (!migrate_all && folio_maybe_mapped_shared(folio))
+		return -EACCES;
+
+	if (folio_isolate_lru(folio)) {
 		list_add_tail(&folio->lru, pagelist);
 		node_stat_mod_folio(folio,
 			NR_ISOLATED_ANON + folio_is_file_lru(folio),
@@ -2332,8 +2339,8 @@ static int add_folio_for_migration(struct mm_struct *mm, const void __user *p,
 	if (vma && vma_migratable(vma)) {
 		folio = folio_walk_start(&fw, vma, addr, FW_ZEROPAGE);
 		if (folio) {
-			err = __add_folio_for_migration(folio, node, pagelist,
-							migrate_all);
+			err = __add_folio_for_migration(folio, &fw, node,
+							pagelist, migrate_all);
 			folio_walk_end(&fw, vma);
 		} else {
 			err = -ENOENT;

-- 
2.56.1


