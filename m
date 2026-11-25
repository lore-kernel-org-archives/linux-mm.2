Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99321606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m630vnF8
Received: by kanga.kvack.org (Postfix)
	id AB4D66B0AF9; Wed, 25 Nov 2026 17:34:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BCF6B0AFB; Wed, 25 Nov 2026 17:34:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1906B0AFC; Wed, 25 Nov 2026 17:34:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9C26B0AF9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:34:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04CDC80173
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:34:33 +0000 (UTC)
X-FDA: 85475096868.05.AF4060C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3E23920003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:34:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m630vnF8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646072;
	b=A7tnV3rNmC1PcWgzgNEqzKmJ4/jGZwrz+BigMzk3rK6mejMbijG8Nz1yy3iVvyhowbcBuS
	lIYUxOIAOsSLgGAG53aJR8xQuQU1Bm2eZQRLuSxXnoIqai8x6IBRkro05zsjYfpCYbq5Js
	qdyO3NBhUvhkEYi7GqC61OixpFzwx/0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fTo2Z8MBd6ECzqB32nwIsRFTY+y4eGXyeXoke+qtck=;
	b=rhW+lTkde9ie1F0w+cVOL4a9aLYHdSI4bLiMM0A6XkPEziCUz3+QrpJ+8LXFekfyTojIrK
	M8i9aBUvMjWI33QOF0Gd6yQDJj64EMYTlIcQG+lCECnaXhPCwoxpFj0COQ5QXG5MvdWnfh
	PqTlgbBEai5GKPvyEb2ftSqihysJCu0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m630vnF8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D14761907;
	Wed, 25 Nov 2026 22:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7955E1F000CF;
	Wed, 25 Nov 2026 22:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646070;
	bh=8fTo2Z8MBd6ECzqB32nwIsRFTY+y4eGXyeXoke+qtck=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m630vnF8CBqdvferMVJw3+VLwe1fZh4JBEzWxfp12Xy8MH1d6IKJWmVQ63ZJIyvyr
	 SUuChcUOJLomXlHQcsTpfBfLK8B/Of/ubxETq+/LNTvUD+KEhax9Osjswyc4EWvqAr
	 IeJPVdEZB2rYyNB8BAGbVK/J86rRctBEYE9udDp91QgkduO9HGZUsFWH8I9jxSEE4t
	 iu1MkhUIxBcdMJPuz9v75QJnGoVmSuHApHDUH+Sp1vfu5prmOKdVNFhkFdzxIlRJIh
	 9zo8c/2iZgscF0PlsAkpPgyFXGuIUe29Mzp2RU9mMFL4zoWMdffOk4JYDZHlp67gx2
	 0gSC2V9mpM9Sg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:02 +0100
Subject: [PATCH 04/21] mm/memfd: mark new hugetlb folios migratable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-4-db27fd2f71a8@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1263; i=david@kernel.org;
 h=from:subject:message-id; bh=3/a8tud39mF9CLqnRD7ju9MjzM6vMjDpQCZWW0NPirI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1Rqtm3aekvro5vjhFDVz06enxdvcZm8/cjmDNmts
 1Zs2XlMqKOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJuFxn+B96X6vfrGjy6dIT
 ReI8HgHuVbpJDhOOnrvZcUyX68tCs08M/8yLc//qb5RTFxTOvv2lSV1yUuYLL+bQd7e87n8MZLR
 azgcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 3E23920003
X-Stat-Signature: 8yof8pqdwb3jxxrnqoobmddpk4eb7bqr
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795646072-434150
X-HE-Meta: U2FsdGVkX195cav8YHzm9LTUfuODV3v5uovrxr2suHQKmRGZgwG33LIS0fjJDdrh9EMAIgu7AbEBFPHembIlNjp9P+JYSGVlsZNs0WU++cpNTMOaJoKllfTmICtzDWa3xw63FQu7FxLJQnIsAYm21BcysVaTsVeL0LYFwUHxi1sPA2VRMqY6VHOv1XD6XJBXECsU4ZgArJSrx4ZXTCY5oRyBaJiA741Smprnf1eHXXWYBQbjLMlVmk4E6prbvUp/bRRXRDp4ViaZ74EBJMHHdoAJ+BFTa5vdtmKp7Qh/G2hMN2iP1u9V1qjACw19R3fytdTVfUOAyoTg8wKgw4GYwU/rzrCI3l0B6r6A4RPmdVtpDKJlGrmA9kAQYSG10IA1VZ24CIexxPOGR9TWEWwZEHh4nwDZehzpMyDgZOC1K/GCxiqVG+ImtlJ/bP3RIcmSxlZk09wrk7BJfIbYONrA9WUm2Auyhu+89WRIiATLa4rJhLmL/4icw2XZ2bJ0kWDoNRjbtRgnHaO/IKs3at7DTwDt/+3L3AGMyNvxCbn2LG9A5lqT362bmA0N7HLHn8qoqXnvGoFj2bIVh7wRBTvne89YOu9lgNoLBNT7TB27o0Y0ssIfdYs4MzWiLRe4XPPdRNrrZtQGwj9vJ0QncNKlvyhRp5XzIna3dBY64HljuhWNVsbRriLni04sP9UWkTzjBwRbtkXWo6oaNMktL6a9rADLW/jKZai0cgQG/k6sIkBQ5u5Xbz7EeEY5xPmu0Sa2//5+4dovfHvhRKCRUYUyQMqbXCiRVDHI8TBb1ztN9FpW/d0fzJgA31imR0J0cJiUpY82Wy8aKFR3AjwQPmV45T3pCWvdWhS4aXM6ciBGqbF0LBjDFzgRRkvw0JrNJ5WXoi80bR3UvQy72k1NqyRl13YM/20YyaHUGnEFFG/Y0tKSmI1Cmjmh+R4kpqBeeaofleeHzTrZDSNw0dNd25Q
 9x1KqVtk
 j+UpLIsTaaU0D0zdh6CpIazQZWWw7J2tiKTW+uOdtcra9iHCjSg/1xcQrYCCXXfvSVF4W81P4QAEAUNaOPSUVtGUdtWT42W+eT6kTOTKfqsbvqDmp7GA5gt2NdxupLyV3sMKHZ0xE+5AGv6jpGOR1928T+1qAi2O4PLK5ZDUhgaukAgKEPVZMlEIATKgPsxzfgnNw0lydrR5mylbdBZlkozoi2obSzNzXmS6fRJzJjHnrXoyUxqEFmG4jKnff2IG9qkpffYo3lWd4IQSPJCtnodbMEfiXj93GwzS+4Xh0AP0Tvu+rpTN0blGaupmLThYkjGtXw/xxEQ/Sg2/E0Yc6LJMBlvCDirf8bZdEkWn7QzfTXxla1q+GbHmZfZoc9fyveS42YbVYEF8H7vLHjb/tXKUu8aRs4v4etqO9fNduOf6fFuN06FOj7HhNbjXTL2Ft2YjS0AZjTYLfge2N6bb55n+7eHYWFXBgsHagqF6/mS353pJo9XkkYnt50xNgjWai8B8W6H3t3Sjsejy1nBOsB8AJbOuw65msuzfJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memfd_alloc_folio() adds a new hugetlb folio to the page cache, but
never sets it migratable, unlike hugetlb_no_page() and
hugetlbfs_fallocate().

Later faults will find it as an existing folio and never set the
migratable flag.

Such a folio can never be isolated for migration, even once it is no
longer pinned, which breaks memory offlining, alloc_contig_range() and
memory failure handling.

Let's fix it by setting the new folio migratable after adding it to the
page cache, like hugetlbfs_fallocate() already does.

This has low urgency.

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 0e02ca69d27cb..6340e8a7c4355 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -152,6 +152,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			}
 
 			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
+			folio_set_hugetlb_migratable(folio);
 			folio_unlock(folio);
 			filemap_invalidate_unlock_shared(memfd->f_mapping);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);

-- 
2.56.1


