Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C479CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 06:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE428E0006; Tue, 21 Oct 2025 02:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196E48E0002; Tue, 21 Oct 2025 02:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0566B8E0006; Tue, 21 Oct 2025 02:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E542E8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:35:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 675A2481F1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:35:18 +0000 (UTC)
X-FDA: 84021159516.07.440CA27
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8929614000F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:35:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=Kc7ML6Oz;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=rzctUJE4;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761028516; a=rsa-sha256;
	cv=none;
	b=m7TmatG4QAPbzTfle44x88HmUyv+RCydu5djOvXYe75nNJyl7xz22Kx/c6UVDLGO1RYDcL
	3/ci1Re2zCmkuIqBsWr6syyy2zb/ggmJLWqokgiDXSfrn7KHlJ3w5wItUG6w43j6VT+Jxc
	iAhk1W7uKnkj+yWpWFpywt/txX4XQrY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=Kc7ML6Oz;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=rzctUJE4;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761028516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=68FepKZWROEYwLH0Rl0RnJf4ml5dmtT6xp2LmJZMNHA=;
	b=DGbJ5MZFtArFV/yrEmIRyKODmfPO85vz5axSibw1Z5lpyDnabsGfrBkUtGX3XsbjMd213X
	10zysHdXtqwp/t90fB0DM5kvFzMvWhZqCYYooRNO3JZeg4GGqopsPxgUkllmi7HyRBj0Hu
	aKxym7N3rEyLsmML0VlGlSOXHAfOhi4=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 4227D1300B91;
	Tue, 21 Oct 2025 02:35:15 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 21 Oct 2025 02:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1761028515; x=1761035715; bh=68FepKZWRO
	EYwLH0Rl0RnJf4ml5dmtT6xp2LmJZMNHA=; b=Kc7ML6OzkYTFIRg1OCSIY0jKna
	XReQ300hPs/UAqCHio63qvQTQJfl0fjRPVu4hDgOdHOOhU54puaJO7fHFwWKgUH4
	qdYdmK34Gk1D4j7nAy7wqPYmF2JT+QWG0tqo0W3UVTqPkc+nQ6vdPClIl+AF0Lwl
	v1+YArgs7q2/SAOJ1gY8rb8qZToAwczpICuypr5Rq1Or81fXoaad8tD0uvYXsp7s
	bgoGDkcgrY8ad6aCH/dzFlnenI4LA/4Sa8bPYNJ1zhqOoz7/8WIWP6C8frILuH+F
	ceScIQQwvnp5exoaImoKyc2l2HywvyUNAFa8TkOnPc+d8FSYoqfK1bCHblmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761028515; x=1761035715; bh=68FepKZWROEYwLH0Rl0RnJf4ml5dmtT6xp2
	LmJZMNHA=; b=rzctUJE4uQWWwnL5mJTmYXf5d+g5wWEbwXBz6eR2OT7aoVCIGWB
	PMVf4UHM2ud/OUcV2p9mUDYxJFbBk0SEwN9XOhyeR91aPFlynDjlK+D6pyS5b7UL
	Imu30J/PCz/I6MdRne/aO2Er+4L/RovoB/iw/cyHlSwNBZGF/yAN7kdazYE5nAGD
	A+nKTm/E/GEXmD4F2rE8UXwBK0XXR3rfkTGSPgi0edwHRCD0wn2gS/55aSzL8cZj
	z8VE9bS49876wooOTqYuA0vwnOBunPdYcqW+WDTw963M9mfCQOhhblK1UOwyrccS
	2PWMYAU/m59Tj5OJ+jbWVUHPIRzKA8SAhMA==
X-ME-Sender: <xms:oCn3aKnXvikA90oRHwL242u0vgNNyRSC1ABH3jw9gSeGfZNl9NQjmg>
    <xme:oCn3aPD_B7CNf-SD-i4LqdDoaNQ4RKdWpDnxy9vMGI7H9xeTYgwkv621-nuQRJIx1
    olIYXnkQ9DwGcMNUaj6sZ7UaP2Jwl2oX7_l2yozS7GXIZPSaj_Ljg>
X-ME-Received: <xmr:oCn3aNIRUSy_CcdwKKPdBwGmYWzPdmIGzuMdO-ASPxXf-HnxAbBXPV6NDWde1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeelleelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepteffudduheevjeefudegkedttdevtdfhheefheetffelteeiveehvdef
    gedtheefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvvddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdp
    rhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllh
    ihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhvrdhl
    ihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtgho
    mhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtg
    hpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:oCn3aKxJ6FO9TUu-3ba83zv9MpLJmi3OstrRZ92bp_e5DGvOEbkUmg>
    <xmx:oCn3aJzLaeWc5eEuX-mIRuKmujFnRw44ep-SrkBX2oUAt_1iBmW3kw>
    <xmx:oCn3aE2A23wqec4rQDP8lBf--vH8HNO8DsNHv3dyhVX6ca1y1NN0tQ>
    <xmx:oCn3aDVrsTk59h40S695CVWupObQd6JgLw9MCvUgEIWUqr4ZBZehEg>
    <xmx:oyn3aOZwqVn97uMIi7gPu4Kvu4eSwwWdn9XQc3om2x1Galq8MiPgXTJl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 02:35:12 -0400 (EDT)
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
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 1/2] mm/memory: Do not populate page table entries beyond i_size.
Date: Tue, 21 Oct 2025 07:35:08 +0100
Message-ID: <20251021063509.1101728-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ss569whbhztfza4434mjpx67zqn3iq4
X-Rspamd-Queue-Id: 8929614000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761028516-934652
X-HE-Meta: U2FsdGVkX1+2jhx7+O/+P0d7Vbs693MI8X0Ooe63R1zdfphroUmHviqWjVZ2ZlNL/JJcOgPoXwDUkX5/Tjg0R6kUX1ncFB3h1VzxjzHaYvOsiyQK2+2u7fGWSXk+/aySibSHbkI9r7gD2sQfqnxP/qKSbYerssawVow+00UrOH+I1mrLyaVkcnXYrjLRIivbSNvQ/xk2pPs/lp2BKZ+8H10naftd9pYLSZQxqPLqV7W7lpG8lMysrAQNuwrkc33xorpWdjPLsyOOSSmAX3zXjhRywDf0wZw8B95lFtJvJ0vaPij+WN+3rBBaUqygxqtlpeuGnRRmLqkH4dFsJVJMm0gWZXXz3fa9yx24ytO/lVzLDCBvTQRQ65/sZF7YsJUAeVMBWlZVGS/3sj7gIvAM/Tvt7lAnYWRkHXNryaex4C6+/fQLAY/chrfCvnNEK7u0z/PNsAmT4QYR01qV6AH2CVPa4QRAcO54KZ64Hq7bNyBnn9MbAWboRCdNDxW8T5SyPwaRxrmQQhPCjsCi0cbG2dRfCLyzB2UlFI2a8mqA5UDMpqpWAmBa69z1aHO39DB31u9RKJOzVPZKflRv/HWjMI7pDUl4uwmHncGUDUa04M1LrhUipEt7qmDxT5FUK+nb9QMGzEXqCC2+bynABBLqL214cK25fTjP/iP9VHi/gmbIBCeerGDnK6i3jEYjilbmbMTsJgg7MjLMTb+yIkJBkqaCBcKhAXwEe6kZ7J6XMwwhPy0mN2cdFb7QqeCMFuWOIa7jgnFxhx2S7ueopqdeUQv6EuhRIP5oxodMvuxXS0toNsKo2Vfqcrx55nOv2benfXKXQx/+TfvF9vI+uWS4MRz91rjy5Z0V8rJU4aAUhqbODigt4ppsxTicYbj6PdkUPRK2BValAJbjTfK8B6Rp4YG1LyktOKNsyAI1Kcz3VJI+MM6JvZBMDeqZLOiktXubIIKq8CbPcLaeX5nnSbT
 aUyLhuMu
 dcclFhoX0wj8UdpoSk/TE1sxHbzN406eOknxite2u5GQJgW+/Yqej3hn/VJWkO90nCg1sacA6KDV+FeRa+kB74gaSovyKS0Bg1LMp+CSFjL5M3YlcVL7djX9cmxIRAVwQJlIsHD34aJDP1yOdKNNvucrjMKN4y05PepYxc7hly70fBJEEfRdhpxtmWigmLWQlMcD9LKAeTC7rT1KmF6RwvnMAeBhqkB0CShuVAJNXSBKxEF2ZGvGiMdFKGXxkyUyaJRT/rjIzHXUbC7Q9Yi/zVMzYJhEDEeCzWMvSbI+xhAW5buU7Rupx6kWCVNqE0VwN/ZfxGfC6Dg+0E7NTOVelb6YZ8egYSrwU6UxrXoJ2fyZCvRTREREIa6PyioQ2/emzN0UwMF4Ja6hVBAVrFx9iSewLIKE5/SFzNE39nqvWOa3Tv5AjK0kq1+ggT4WhQFwjge5hQSm6X4GWY+c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
supposed to generate SIGBUS.

Recent changes attempted to fault in full folio where possible. They did
not respect i_size, which led to populating PTEs beyond i_size and
breaking SIGBUS semantics.

Darrick reported generic/749 breakage because of this.

However, the problem existed before the recent changes. With huge=always
tmpfs, any write to a file leads to PMD-size allocation. Following the
fault-in of the folio will install PMD mapping regardless of i_size.

Fix filemap_map_pages() and finish_fault() to not install:
  - PTEs beyond i_size;
  - PMD mappings across i_size;

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Reported-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mm/filemap.c | 18 ++++++++++--------
 mm/memory.c  | 12 ++++++++++--
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 13f0259d993c..0d251f6ab480 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3681,7 +3681,8 @@ static struct folio *next_uptodate_folio(struct xa_state *xas,
 static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			struct folio *folio, unsigned long start,
 			unsigned long addr, unsigned int nr_pages,
-			unsigned long *rss, unsigned short *mmap_miss)
+			unsigned long *rss, unsigned short *mmap_miss,
+			pgoff_t file_end)
 {
 	unsigned int ref_from_caller = 1;
 	vm_fault_t ret = 0;
@@ -3697,7 +3698,8 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	 */
 	addr0 = addr - start * PAGE_SIZE;
 	if (folio_within_vma(folio, vmf->vma) &&
-	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
+	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK) &&
+	    file_end >= folio_next_index(folio)) {
 		vmf->pte -= start;
 		page -= start;
 		addr = addr0;
@@ -3817,7 +3819,11 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 	if (!folio)
 		goto out;
 
-	if (filemap_map_pmd(vmf, folio, start_pgoff)) {
+	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
+	end_pgoff = min(end_pgoff, file_end);
+
+	if (file_end >= folio_next_index(folio) &&
+	    filemap_map_pmd(vmf, folio, start_pgoff)) {
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
@@ -3830,10 +3836,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		goto out;
 	}
 
-	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
-	if (end_pgoff > file_end)
-		end_pgoff = file_end;
-
 	folio_type = mm_counter_file(folio);
 	do {
 		unsigned long end;
@@ -3850,7 +3852,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		else
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio->index, addr,
-					nr_pages, &rss, &mmap_miss);
+					nr_pages, &rss, &mmap_miss, file_end);
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..dfa5b437c9d9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5480,6 +5480,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	int type, nr_pages;
 	unsigned long addr;
 	bool needs_fallback = false;
+	pgoff_t file_end = -1UL;
 
 fallback:
 	addr = vmf->address;
@@ -5501,8 +5502,14 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return ret;
 	}
 
+	if (vma->vm_file) {
+		struct inode *inode = vma->vm_file->f_mapping->host;
+		file_end = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+	}
+
 	if (pmd_none(*vmf->pmd)) {
-		if (folio_test_pmd_mappable(folio)) {
+		if (folio_test_pmd_mappable(folio) &&
+		    file_end >= folio_next_index(folio)) {
 			ret = do_set_pmd(vmf, folio, page);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
@@ -5533,7 +5540,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 		if (unlikely(vma_off < idx ||
 			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
 			    pte_off < idx ||
-			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
+			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE ||
+			    file_end < folio_next_index(folio))) {
 			nr_pages = 1;
 		} else {
 			/* Now we can set mappings for the whole large folio. */
-- 
2.50.1


