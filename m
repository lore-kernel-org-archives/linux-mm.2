Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 552FC606A331
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BzFioPWw
Received: by kanga.kvack.org (Postfix)
	id 671136B0AFF; Wed, 25 Nov 2026 17:35:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648016B0B01; Wed, 25 Nov 2026 17:35:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D0C6B0B02; Wed, 25 Nov 2026 17:35:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5346B0AFF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:35:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD681A8EB8
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:35:20 +0000 (UTC)
X-FDA: 85475098800.05.00F6CA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 044A5100005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:35:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BzFioPWw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646119;
	b=ZMky2K7uS/ef99q/yeS47aoyxsxpRwGqdndGVCgnX/oIOzZK/71COyTNEXCANAUzY0WG8v
	m6xs7Ul7u92Ohw3Sgbl9hMrkxfPHHKU36mULLUOtHyEi/5cV/soqiOkTgozRnohFzhgioZ
	1frEBamNB1JWC2G1kjLLAPaxcwHhARQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5mNH968v323dmL6m4gmXpdiBkuKWTr3VPaky7Yir+A=;
	b=dD/ClBJ5OCvnLEYo5Tk6YR8pX+nAlEWYdRlx3nvcDfWi5tojVjZQ9tAt9ETo7SVmuFetRW
	h+hga+dy7tJA/nhNvDHydyjy7z1DyxYE3W8F7xRCyZfGcE/wXPKOXb7EXZdQ6rPJDCV4hX
	XN5j2OD18Bd+f5V3lLzyn9uZ89232Vo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BzFioPWw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4042644D8A;
	Wed, 25 Nov 2026 22:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2721F0089F;
	Wed, 25 Nov 2026 22:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646117;
	bh=w5mNH968v323dmL6m4gmXpdiBkuKWTr3VPaky7Yir+A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BzFioPWwZxbExKLSe08Fa0ivlL6lHi7dvTOisegf5JPDpHT+Lq7ZPzanBnMs77+Fb
	 lGKn/KJ5YC/5v60dOgClKpw2/IxOHB7urFqM0XnGzzpGXTTNSDfJTpLeUvu9Ljb/XG
	 cljMVHxM52grhgfzhAVGzbFI+/0RB28n8ZcPi4+A6sQpPpbhN02ipGG4ebQfkHr/XK
	 55Ak56wAZEETfdTosBo/o3sO4+vHiGPhr5z0xPLyLHobAotHC2EFlUTWYuFItg3Vwg
	 C0JDQBvgWH46Xhe9+SoLZ/ryhXSJ4Z6YxTEEiMHE05x2E+BAjEJOpgHdcEVLBs58gd
	 /S7pvXq0tre5g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:05 +0100
Subject: [PATCH 07/21] hugetlbfs: don't zero poisoned pages in a hole punch
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-7-db27fd2f71a8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1724; i=david@kernel.org;
 h=from:subject:message-id; bh=Og+oDJ5oT+0Zxzn7RN40KfH9k0WlARjP75JU4QfF/So=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1SEFvKmLbU4vGfeg6UVF95WvrSyu348uGB5ZFJ1e
 bHnA7/LHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzkWiojwxNm3YrF/LPDXG89
 +V8bE9NV/lWU/6unmurxP7fbeu5bH2L4X7LnxZlLR+/+/sV2vPWkm3Jwd/MdMWG7jNrnU/5Y3+9
 4ygUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 044A5100005
X-Stat-Signature: 7pjy5esar3iak44iad3ae6f9zd9639kh
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795646118-492210
X-HE-Meta: U2FsdGVkX1+oHZLbdyZ4rHLy72IenTIA1EOfm3QwJgWDnBMZS8rsuLdsv6NBt/FuS7khN90nIpyxu4IUTEHYjf4jzeWx8oqWrUxZrbwmUiaiwaXrDDp3PqydvKeDqxMbjVHMZF9zUEq1LrtreXp/0oqJjoMcO0Fh/icNZvpVLtPbTj1swD0+Xg1XCtzqvl7kVujoHF5foBlVmkmaLfqbm3M8MUHecYIPLS267gmP1p2XKNCBnWZE8Yj47po5i+kliEMsi6XkJRIMgKOhDEzB0H4ZDt8eUdfLxIWVxsE5qJxa78lY7UDWC+xf1XeeJnA2h2ZfvmaW6ePVWRN9P5HeIB66IblkBlMc9w6b8sYh3Xm6sLZ8m+hmOIgOWJskbsog5ysIzxUoSCuqFV6KeaABhSped1bmL8CjaIVfdtCAMt2znvzyD1MA+daZWtSA4j+cayvKbJoiML526opTanpsuW9TuRWUtCWObPWIPBZBQ4e7C+aq8keQLB5WcRWrvdvHezP1WTmxWU98Z5YoL1fuvGnhzd6iFZXc7yN4IpJGzX8p5qH4OLwwRiW/Ug/RsFjPcQGbOcBos8xjMZJHqJmQfLjL4qAf+g7IAV+vt0VtGZlQg2LPsw0MJ3sx73fdzZs8XEsgWzC3qN/8SSVHm6T8B+5AFHY/iKZyOgg0pOZV0uRSB9T8ohqehdRJvGYuZqiAR3Uw+MlKTvf2pRuWCZJhjrimdmRTSU3GiBgO6utQ7MuLCFLDTb6ys0PIQBXA7cpiY/GO/WAEL4ep50eNKlIV9HPN8NXZKEyfIIkfD07almZOILKepSV2HfCebYwlCznNMLOvtl7ZvKE97J/1QUbBxAtWxEBEu9qbdi7Pus1lNKccVlFEh+iAVvbGhxE3t6KQsAisudQI88EJDir3cb6R1mykLsx2aFIEXxZePP7cDGvWkwlVcfwtHpxilSU73lVnERiBqYP/WxWVDOs8lIF
 RsVXzZBM
 nyTbZ3gawMwZNV5gtWiKOYOShW6N40p9oJwbiYMRnBHLBUzm8SxoCyOjMTs16zQr4Om+o2+ArXBAUkcEqpsEMPsP/48MeZMlT0S01VwkcsdLvE4QGThIZdZuTgWYUq+1EqGtBz/soDHa7b8DL+vKimvdQ8PgFnmaYk4k5HiJJQ+EVLsaHCbVNcBQlHLxGUlvgMmH2ayY9gvhpwjwDBXZQRWoCsJT1TbJJNZVaCjQTwbJmZlalUwI5N9rzXqQWJMf3G8I2B32uSb+6DkKfPgTsPcEXQ96XYcEUsOsemfVefqtOlXHaFjjwWA1NHbRwYxVlFNqYq548RFdx2f+WPYE7I1Szn3c+eSSy0IBWQbkPXrvt7w2qcNzQYKpG6I4xgabi5NnUi5mBdGUM8ZQTm2ImerMwNUw+tz/eBGlUya9seej15HskdgHDj4LeTn0VjuToJvKKjXb8/Pzy7SWeaS2NVwE2iXYClLxKr2RoP8pBanIWzUz8th/SzgGesSeWO9mznoBH77/EQo3/0pz+67SBTceLspeegWdx+LGTLB5isBWA7K0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 8625147cafaa ("hugetlbfs: don't delete error page from
pagecache"), a poisoned hugetlb folio stays in the page cache, and we
must not access its poisoned pages.

However, hugetlbfs_zero_partial_page() zeroes the partial folio of an
unaligned hole punch without checking for poison, which can cause
issues like machine-checks.

Let's fix it by simply not zeroing poisoned folios. We don't really care
about their content: the folio can no longer be mapped, and read() only
returns data up to the first poisoned page.

Only zeroing the pages that are not poisoned would need more thought, as
we cannot reliably identify the poisoned pages; that is future work.

Note that a folio that gets poisoned concurrently, after we checked it,
can still be zeroed, and sync'ing with memory failure handling is also
left as future work.

This has low urgency, as it requires a hole punch on a poisoned folio.

Fixes: 8625147cafaa ("hugetlbfs: don't delete error page from pagecache")
Cc: <stable@vger.kernel.org>
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 2e8672ae2fd52..5437a55d14f1c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -656,7 +656,8 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
 	if (!end)
 		end = huge_page_size(h);
 
-	folio_zero_segment(folio, (size_t)start, (size_t)end);
+	if (!folio_test_hwpoison(folio))
+		folio_zero_segment(folio, (size_t)start, (size_t)end);
 
 	folio_unlock(folio);
 	folio_put(folio);

-- 
2.56.1


