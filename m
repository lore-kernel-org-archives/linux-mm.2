Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A10CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 09:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A588E0010; Thu, 23 Oct 2025 05:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3629C8E0002; Thu, 23 Oct 2025 05:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278358E0010; Thu, 23 Oct 2025 05:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 168318E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 05:33:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBBB6C0AB1
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:33:02 +0000 (UTC)
X-FDA: 84028865004.06.58BD772
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf08.hostedemail.com (Postfix) with ESMTP id C9E5716000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:33:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="C CzFkff";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=xXGELQH5;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761211980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSWJfa0tNzZL7EkXGx3ofWACGkiJntrMeTcvW3FI7xo=;
	b=rr5EXjN+SJV1lB9G3w1smeqryR8rnQvcPjP9q97kgZJ4TEud2tKjTeeN/BlwFNqbJn3g5S
	A3jn32kqIg1wOMxGpbPH2a/YQ6y8/BFtV/SQHmDCk2u4wwGfcTVQgZ4VnrEr+9JiJkkGkf
	PMfr+8EEXgfevVacH4h+Xs6P7TUM0Fg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="C CzFkff";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=xXGELQH5;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761211980; a=rsa-sha256;
	cv=none;
	b=PAy1/UGW4FVYcUCredILl4KbS+92eY6IC6LYO74IJSvhIC5vLpMc0Xf0avwfO3U4WN0/D0
	gvDEuslAPJt260QLoZH3knCZAhkoNyemN3x/wPll+utVg7q7rgStMD9a3YLwlhczQdfSQB
	vXbA8PQr+u6LtwG6qiRSIrj5Cy4w1Yo=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.stl.internal (Postfix) with ESMTP id 844ED13000C9;
	Thu, 23 Oct 2025 05:32:59 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 23 Oct 2025 05:33:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761211979; x=
	1761219179; bh=eSWJfa0tNzZL7EkXGx3ofWACGkiJntrMeTcvW3FI7xo=; b=C
	CzFkff8zaY4jHxSD/AuSy9I23IMVJ30+9sypRnQ4ilDL2f8hJz7g3yZko5et8s+A
	VCgqcc/Aj2gTrf6c260JqZG/pcOvUGYgRHGyzJujWuDR6X14wrXU0hvkC00liJi9
	8purOIASvsx2q/1w9GkZuZR347y7jPSr+bjDlazT4TlE8+PUM3U0Y2rGoWhGbz4t
	LrSR8mOUc6e5oYXniAW1yzHHgRqGmSkcTzjx0x+PNuiw1luGfs2Q70EPewFtg4vF
	eyVaQUFPtumbyJiprDoEOvFn4IGhdzaSIvFkgOvjNfjsKnLY4V3pMInD5mEGKawz
	WXU19U6qXaPL4on57Z+NA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1761211979; x=1761219179; bh=e
	SWJfa0tNzZL7EkXGx3ofWACGkiJntrMeTcvW3FI7xo=; b=xXGELQH52XDILByGO
	W5dQT8AW78a8CZHG5gR/x8hzylulJzqmlKoKDIrELDJOYP+F20Q6/OmNcJkOZ+QN
	GUGfjBo4NQTdXk4ev9xInGotMAy92aNoPYvno11p4PKDgrdqU2WZKo59QrfPRYE5
	cZhkOUcZPLKPsPfCDsapZnSVjh2MRdGMr99soyMvmIroV25Y6VJ/m6XMcBwk1WI5
	k2j0SpIcTjV5uv5Rd+ibctTKKUGsoJKpm7bypUwuGohGn1gOOxkY5gXqSRSZnEO0
	ViAvFwbW7TIMlpRjChPvXjLFbPvPh6BCXmMw/emyUy5jb3ZqYl7MQ2mHOROIEQX2
	YxIBA==
X-ME-Sender: <xms:Svb5aKOSoEPyYzNv19zPPDkdJjvRrMnHCJCHg2K0ptkC1qCaMnFA3Q>
    <xme:Svb5aN3UsZmXUCHESji7mQ6umz0Ww0bV9ZyBWpuwd8RxSL-gxtuKUgT5ipxGZwRuo
    GtI-XDCqCHnrhBLmc3r1Z9xU4SAVMqO7IrJAIBb4r5eqI6joOfys4gK>
X-ME-Received: <xmr:Svb5aO1A3m-oG_J539knUel9JXbUm2EpjinTrN_Yh5lJh8LlaWIr8BoGeZG1IQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeiudduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepgeevhedtgfdvhfdugeffueduvdegveejhfevveeghfdvveeiveet
    iedvheejhfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    fedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfoh
    hunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:Svb5aMxiFb1Ve2v-PugLKykEJVfKEGfBPNwUI5YB3591Ar76vrw4Kg>
    <xmx:Svb5aBmyNlGqO85Q3K6dRgDKgr7HGEaF624JTnZnjhNtaKQlEtaIMg>
    <xmx:Svb5aAySgmO8TRRd4gvegy1-0fxksihPny9h1eL5piRP16VzVOvAig>
    <xmx:Svb5aAI3nAGCEsKuG3jyA2xSKKvog6DwM3W8PC3e85L6Pi_V5fBEsg>
    <xmx:S_b5aMXhIFpLwxb-8LwZHmWgAjXjnHLOkMLwCvMialYqQvcXXDBvep9M>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 05:32:58 -0400 (EDT)
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
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 1/2] mm/memory: Do not populate page table entries beyond i_size
Date: Thu, 23 Oct 2025 10:32:50 +0100
Message-ID: <20251023093251.54146-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251023093251.54146-1-kirill@shutemov.name>
References: <20251023093251.54146-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C9E5716000C
X-Rspamd-Server: rspam03
X-Stat-Signature: dfkhq7apun18myd87q64rca4jrgnnxbn
X-HE-Tag: 1761211980-379247
X-HE-Meta: U2FsdGVkX1+JxogOZWUJmA0+V2hq/a5vlOSSEm2sI2/T/JIdeWENlrzlZyxBG0wvWl1a3gdo1RGjOXpW9IHspIGdBJYk/m8tzIT41LaZI8GQG+TjtJl2Mw0FYzjgFjbR589DKKKk+TY3ig+/LsEEgcZZv13gEpG05D/99jxS5Oo++jKg/YHW+Jde0+B9qe6jVDs4XYNt58w1X1PkoKiksLvM9Q/UveyXzVxGJABSW3o1m1PbEMv4UK5csauIYCKIm40agltsNxdbBK5qsgfregeBJQVjxziky3AsUxhM5mhN5jRs2X+brcp7UEZWgZeDIfCf2TtWIUWhqTmStZxF9BzU6W8j3ogeRKyUg1piv06ulXhTX5PwfKHyXEctfqyGC1r/BxjEl6gBEC2T+2tYHwDN0Y602MAjijmAQ9jlbisS0h5KBF9HbqxCo9x9IrbRyeu6v1ysuYNcjvQzTq93chFCDXMXc1oXe3ccyqkmLjgGh/5Gx6uMU24voA1eSIgA6IVkJ0CB3dZ+ZxP8EyDtT9U+V1ji+2jQjZeqMctP1StZ7KZaBQ5jh17NsfZtKbZWZcO6GKNwFKJ2bJUNaN1A694zoNdbKWL4Miw2wI8cIQPJyR1Xf+V64/6pN67EFrdf9JDWJdbBwLeQbPl6HjornNtJ88hLd6QGFF1aQ+OBod7MoHHDvDxBKKrO4go+o7q4y1IlsgrhU96fH766XwOH+y6yH9ZnSpI4pw2YR2oWsIm10UzacNakTwmV/KDDqxIj4XNllSn1mhBwbeTSkiyXiNCdGNbrajW0sZ4p0j0IQQsG990jhV6W6CKixJD+jLY7yYDJtMqwzJsEnJD61F7eK2CGtdOFNQv1Jb4K7F+5yuoAa+VNZBsuPp7/i6EyMitpXGlRBTPwDvNpcfw7/IvznLs2tYi2AuMZvYyYQwlH4siMZrN4e6o0NztIX8PkF7l+/AxXVoEBp1U3qb5bn2j
 j4ixcHGx
 IspWUX+IHMG4Jfd0yXmIF/63U5A/4kCaQ8WFo+DRjomVBzzm1HVOmSw8TaYPNJi2eI/yGtDIVmpSGuYD57sG2XlBOIjU3TV/7XROcDyifCFW/XjUzOwrzDkEgYDlFrWXpDony2C9TgEp7qNLKaBEsO+fH3O5XVbPjjKfk9TOcABT7lWWwR3mHnAfpTqFLEG/unwWqBxn4xNQTiBjDJL8/vk8ElWqgkpOPEKEJAMnAz5fCCuJBO+B7QKcaksuvsxCo4Gu6t711eEllt7fOHGS1wJ0eJwcANCBIKkg5e8LeBo0XojqZanqQEMNn2XIaDPdX9IeALZ6AshASllj7Cw36tqmFBFxHsDf054l9E7fz+6kJTLQx8gs3R9bpg1tHsD0y9y5y3uIo6R4xUeminN+4kGVBcpNUceEaXrgNCUhSPFpLC5MKCCgoNRhEbHEjkB0XJIxu6a5An0BaMjI=
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
 mm/memory.c  | 13 +++++++++++--
 2 files changed, 21 insertions(+), 10 deletions(-)

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
index 74b45e258323..9bbe59e6922f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5480,6 +5480,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	int type, nr_pages;
 	unsigned long addr;
 	bool needs_fallback = false;
+	pgoff_t file_end = -1UL;
 
 fallback:
 	addr = vmf->address;
@@ -5501,8 +5502,15 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return ret;
 	}
 
+	if (vma->vm_file) {
+		struct inode *inode = vma->vm_file->f_mapping->host;
+
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
@@ -5533,7 +5541,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 		if (unlikely(vma_off < idx ||
 			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
 			    pte_off < idx ||
-			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
+			    pte_off + (nr_pages - idx) > PTRS_PER_PTE ||
+			    file_end < folio_next_index(folio))) {
 			nr_pages = 1;
 		} else {
 			/* Now we can set mappings for the whole large folio. */
-- 
2.50.1


