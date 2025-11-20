Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A2BCF887B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 16:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2DE6B0006; Thu, 20 Nov 2025 11:14:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0AF6B00B9; Thu, 20 Nov 2025 11:14:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068F86B00BA; Thu, 20 Nov 2025 11:14:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6DBB6B0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:14:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93D1112EC36
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:14:22 +0000 (UTC)
X-FDA: 84131482764.11.0377FD8
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8CAE2180024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:14:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=Ygo5lO9J;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=F+kzihpN;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763655260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w3ITVi2CUUn4IEwzmugFVygQp9ksK3seEQUoC2PwEdQ=;
	b=e7jNb9OlazZ/c+fmVMasV+EUl2uhnv2QT+9DAb1pDX95ifSDF4M4L7hj2DTffQbg20CdJh
	Dtb6u5K3E/m/KHI+rzAi4lFkLIhrkqVT3WTBZ5fpbaz3EPG3wPdbXAl7wP/jotUlnF/lZH
	FLG92QwQ9+A/lkozplAuWbMRC4qDxrM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=Ygo5lO9J;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=F+kzihpN;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763655260; a=rsa-sha256;
	cv=none;
	b=7Pl2qXwjU2vObUktnc6qGJdj8Nb3dXQjZMnyqcBplQ9iOAQ8+49QmJqWUwTDx4M7VnVlYD
	f23mfNNhaiguvAnxKT2hsruwABi6AzNNN2lsKVd4AsK32YFq76QEkJJr1n9OBAsiHXxTWb
	N+IldDh2V++F6FOgknBuTwZwVFzTulo=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 1593F1301AB6;
	Thu, 20 Nov 2025 11:14:19 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 20 Nov 2025 11:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1763655258; x=1763662458; bh=w3ITVi2CUU
	n4IEwzmugFVygQp9ksK3seEQUoC2PwEdQ=; b=Ygo5lO9JLp0PQjn0B+/AJFxgK0
	WDJb+5Rl8o0jI+ObDuUSFxNd6bjOVO3bXdIKpPu1YYxZxurvrQ7M84FxqYTbTG1O
	Ac6hEWAvuHLum4PhDCaBPRI0euawIpfWaYFsZLxQ1BxGUosPRPicyoxSRFbcTAUI
	v/IDoDAA3AJpwb1V54wXNd34ZsAbGDcpXYX2NU5U78DXvyaXSc9NLtR5P4Z7yZC9
	k7WuM8G8NU9Lol8hJ6maUzL1SkBjmDT5O86a6PZn6f2AAVMrmd8Yy0cXpPEu+Cz5
	7FqAXVpYlGeQRu7dSwQ91HaS6p2YuL3nLg4/zlcTgE1U3VyatlCP7IxbjVyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1763655258; x=1763662458; bh=w3ITVi2CUUn4IEwzmugFVygQp9ksK3seEQU
	oC2PwEdQ=; b=F+kzihpNgyuBkLbA7iNVidrVNmxF/OgnO9jJhjCVgtrDgrzRJUr
	iPnv3AKFdSTbJM8RzUJXYHc/gLean1LiHgtb+sSzQxoPFODKcVl3EvAkgmGx5n/b
	fBDIHJkC2etPRMySWPTJociSZu/QtqutkzUCyM1pmqfK8Fc3YYLsrCBgSNth1c/v
	pzSXsCjZnNs8p0Y9Al8dvyqu2V9noR6t0mh1qKzFYp/izud/3w2VGTZ13Lb4mU9d
	ttSEvHiulESZeEiTOQk0I40mniepHChE0aKrM99hnA2pLPgkRGlRlucJJz++uXsU
	XI+yEjzvdWLAm3dL+VzmHbvH9rV0L3QKoJg==
X-ME-Sender: <xms:WD4faVHy_yPTbqYnOnV8YDHMkPT5jGF_orIt9-49BfpqADWtKHy5mg>
    <xme:WD4faShFI7e3FnwPM3Rc6AWnZRAFeOFQtWs69nIW19nscTyeOogmjbP_OT-R2SCph
    SdI3rXQyAM8lMtCu5XjrDgjbv9UK2997iIY9nFf5MtSo__9OddcoLI>
X-ME-Received: <xmr:WD4faedzTxpzLXZHeFnhRREi82DyiWNSHHYaNIhu7yobPHpUPodSu7JK27j0gw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvvdejheefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepteffudduheevjeefudegkedttdevtdfhheefheetffelteeiveehvdef
    gedtheefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvgedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdp
    rhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllh
    ihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhvrdhl
    ihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtgho
    mhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtg
    hpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:WD4faYwJ2xAl3WaP8MMmACe7XZYqLOp7aeFcdch-MO9GmGEis4KFLw>
    <xmx:WD4faYYHiYU3eYlPfEoUfWNjBH0JgbhU4B-e6elz8YP4XgizSDKQoQ>
    <xmx:WD4faWLk7EOLTDbLMUrasTTVH_fgOieMiGXhbNzs_pSDVCmLRCndzw>
    <xmx:WD4faf3kwdqwsn4y7l-i280L89u1D2nelmphZRyVKB94uxuDnU1TkQ>
    <xmx:Wj4faddSi4rte6x2oQ_oQRHUv3odrGH19LUpfwiXaFJ3LNAewiFALoT1>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Nov 2025 11:14:15 -0500 (EST)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>,
	Chris Mason <clm@meta.com>
Subject: [PATCH] mm/filemap: Fix logic around SIGBUS in filemap_map_pages()
Date: Thu, 20 Nov 2025 16:14:11 +0000
Message-ID: <20251120161411.859078-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8CAE2180024
X-Stat-Signature: 53knsbrspnmankae5xjb6oxit9edh7h4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763655260-654045
X-HE-Meta: U2FsdGVkX19tblmS0m8/Z8S492ZFk+XVzgFpS2Fmitg31lSn16vr1V6z1B14PHr6wNd0+DwXSoX9JrCugQKP6mSIUVDpCljCkPi+cBJ0D8niwvkWJzQkEGtotG9N6W+g+e/+6ZkjOgPq72zbvB1wSgC+vP3SD49wuOHPlPybIjMfVqfGWMErsLBUMkRsjCUCGau8p7AOQKR1clOPEuQw0CmRA+7lgRWFb/aMNSati7P3bvKmIa9YqlaFUjl5elCks1D/9davcBk/6xryGTyBUkURc5ZCxSl1kg02YQ15b3Apugr67YncAyhQNWv3dsXmYGdTLwjfngNruMU6Oo5e6eAMlLrSboHwX934M/qbC7wjJHJD41ry65GlMLmTa4LzqNSV7rWy8+AO/kOwRea9/UnD0S1inIhCLOYw3wRlHiSJ/EfjlQa9qRRfWTBrtZVd5jog0VmLr5opEnGX9m6afcR0hq4MEztB76oDIBB0bRU+NO9J+5CuUSCkfS/EmC0JVKLkwx7Tawx5z2gfIqag6P9CbbHiiWQRQyI96tZYfVKi4Vm+yZEOgP3EnU21kILhr2B2k31V8lEhRN1Py9vAXQAxcgDamgB+KOX8cfG4xhtW/gvXEMzufh73pjFmdujIYyYFm97YciXpXTMBmUYN4wR+VrgzLF4mGZG4dGQUvi3hdsztg/meS0PHqqJ25KBCFz8Paq/7WrU5YsQekaiO1+7IBMengTomoC6Ucp/qJ8PgROWzeCqBkrnmnb0aIMtZsgkCoxwuAOB2ce+m7n9184DEimvPnx9qsoCmfx8VeorImfkPFN23QyBeW8TQ+wixtp+OMxHhgZCcPlT/8iUY9y08i+qWrX5/rg1GbPHCLZzC5DibHbgDUWuU0oczXLEOvjq12a/fACBh6vtIAqqXS7iDXb3jkBokyCJjzX2rkXHtX5c7ukm+7DU/EvGhZ0ZKe6F1lkYS7rRh4cuNSLs
 1MdnU4j2
 TM7nfdiJYvZyXMe4rFVRC3zEqbnbs4Iqjw0ClrBXSEXXMRI0O+lydQ00Injzmfs+bLseeEWtzMRSzKkywJ0fNJlb2X1KpUMoQG9z0Fr+pVyeyTzO1hlEVZYIqLAOOez8ktXRcN6IKqA+MU3iasQnqyhVXE8D3/PI0dn6tLvsMXwK23MQJJ1CfKyhyd8mP/LREgUZG3M4QIJMaIrS7iyOJUJJvCtjL6qqr+kLBoJOVaWjaCLVzWxPtVTQEiR4yYm0oqXwMhVHNyk3YuUvAeFdZ0PpOag8a5B7hzN0RM0lmnwOeTbEP5TMSC4jRDSqa+TNHme43LhcArrOyT380UWQWzLHGa/1kMfHvn8hjw2nHDkSxdAeSR+ALcenvkFXmhjwww/1OyzaD+RH9BgP0kOv/ZiZzO59IVWQy1cRGX0nK9wZI4grJcZXVvieJLygNlBrVpQVa07APGcXIOQL1yXQmF5p6xDOn+vheSdeknpQ0YCf7EK/NBX7DsPhf+ifzGgDBT2qBe0QXAzIBPryxz+TPT7EV1vd7nW0giGJe+87LcooXOuc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Chris noticed that filemap_map_pages() calculates can_map_large only
once for the first page in the fault around range. The value is not
valid for the following pages in the range and must be recalculated.

Instead of recalculating can_map_large on each iteration, pass down
file_end to filemap_map_folio_range() and let it make the decision on
what can be mapped.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Chris Mason <clm@meta.com>
Fixes: 74207de2ba10 ("mm/memory: do not populate page table entries beyond i_size")h
---
 mm/filemap.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 2f1e7e283a51..024b71da5224 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3682,8 +3682,9 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
 			unsigned long *rss, unsigned short *mmap_miss,
-			bool can_map_large)
+			pgoff_t file_end)
 {
+	struct address_space *mapping = folio->mapping;
 	unsigned int ref_from_caller = 1;
 	vm_fault_t ret = 0;
 	struct page *page = folio_page(folio, start);
@@ -3692,12 +3693,16 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	unsigned long addr0;
 
 	/*
-	 * Map the large folio fully where possible.
+	 * Map the large folio fully where possible:
 	 *
-	 * The folio must not cross VMA or page table boundary.
+	 *  - The folio is fully within size of the file or belong
+	 *    to shmem/tmpfs;
+	 *  - The folio doesn't cross VMA boundary;
+	 *  - The folio doesn't cross page table boundary;
 	 */
 	addr0 = addr - start * PAGE_SIZE;
-	if (can_map_large && folio_within_vma(folio, vmf->vma) &&
+	if ((file_end >= folio_next_index(folio) || shmem_mapping(mapping)) &&
+	    folio_within_vma(folio, vmf->vma) &&
 	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
 		vmf->pte -= start;
 		page -= start;
@@ -3812,7 +3817,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 	unsigned long rss = 0;
 	unsigned int nr_pages = 0, folio_type;
 	unsigned short mmap_miss = 0, mmap_miss_saved;
-	bool can_map_large;
 
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
@@ -3823,16 +3827,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 	end_pgoff = min(end_pgoff, file_end);
 
 	/*
-	 * Do not allow to map with PTEs beyond i_size and with PMD
-	 * across i_size to preserve SIGBUS semantics.
+	 * Do not allow to map with PMD across i_size to preserve
+	 * SIGBUS semantics.
 	 *
 	 * Make an exception for shmem/tmpfs that for long time
 	 * intentionally mapped with PMDs across i_size.
 	 */
-	can_map_large = shmem_mapping(mapping) ||
-		file_end >= folio_next_index(folio);
-
-	if (can_map_large && filemap_map_pmd(vmf, folio, start_pgoff)) {
+	if ((file_end >= folio_next_index(folio) || shmem_mapping(mapping)) &&
+	    filemap_map_pmd(vmf, folio, start_pgoff)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
@@ -3861,8 +3863,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		else
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio->index, addr,
-					nr_pages, &rss, &mmap_miss,
-					can_map_large);
+					nr_pages, &rss, &mmap_miss, file_end);
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
-- 
2.51.0


