Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E37CD5BB5
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1326B00A1; Fri, 22 May 2026 09:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640E36B00A2; Fri, 22 May 2026 09:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48CB96B00A3; Fri, 22 May 2026 09:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 323866B00A1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2E351A0A5D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:32 +0000 (UTC)
X-FDA: 84795162984.22.6FB388A
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf13.hostedemail.com (Postfix) with ESMTP id 085492000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=RA5ff6QA;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="q ljvxYw";
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXFkEIOrYnd4VzG26u1BkNKtRIzSlJz9bOIkV91NFGs=;
	b=h4r71wOorY1fP2+5cGLAnGHvZ3yYF99+ZvsuTZ6lIqg6gYemhEF3TjkXiRvkOH/U/rMrjN
	Hp/vBCzZtq5lW7egbpF8op5caINpWlQKYA7eNCKikmdvD69ynD24KbbKj4mK7tS1HV7IRd
	1JRQtX7uWtgJf/YgK1e+SGBrouoXcAo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=RA5ff6QA;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="q ljvxYw";
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457171; a=rsa-sha256;
	cv=none;
	b=mdMNGkcsqc0h+I6st4TaUk1mgkequKio3opIQ561C0N7td6P1bt4KR91o30BZYjkvqKZp4
	OJeOFMNrI0yt41g0j/qqZQTsXlhKaBBjjeOfVai7RDjggVetCE/kfnL+Llnl1oZ3KPb0I9
	I0xkEI//F8DT3+196800JZcsaL9kYXo=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BC9837A00C8;
	Fri, 22 May 2026 09:39:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 09:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779457169; x=1779543569; bh=XXFkEIOrYnd4VzG26u1BkNKtRIzSlJz9
	bOIkV91NFGs=; b=RA5ff6QAb99SgTaHhMsQjttPHknxYweHjXAy8UUlWBa16qLQ
	AuUZsRyrNt8HxNbUsJQgbcc8Nkey9IBDhGQxEdrH90LaDaScAVfh1vOH82+AlpNK
	AWXHy+7Lol/WuDWvqmGdXaiRSpyP0N728RUw+ILge4fZJOUSnFg07o1Axjnq+hSC
	tjpUp2q6BDJDcAbhW73782kAZsF9gy8LIVEenOkK8yODFfxyN7xCvFq0u8rcCRHL
	7r8PzgdetgtPMwzwe4RqfwhnLxZnsWpmHyMKUOTaAoGYLqXbIHtBsO+bxE/2piLc
	41UAnC/aVYf5MB9Xut312LhZSXJMPFyo1k2LyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779457169; x=
	1779543569; bh=XXFkEIOrYnd4VzG26u1BkNKtRIzSlJz9bOIkV91NFGs=; b=q
	ljvxYwfY04A9ZYn8H8CQusrqYpvEGioZzjB/OUVYjPtteTkq0sRTVW2t2qkYH6oT
	T/5aE88gU0O5d6JMcWj5cJgmam7KVdDWsrifmr9t9XDDDHeRfuMmer6Diu4MUaht
	rTVlGxD5ioTfyt8AleArDB1RhC1eaZ31w5DEma3IbGkCsDnnU6n5a6yd7ZOFAdMT
	T+qfMOKPuCWX55Tguh3pwQQdj9kj/iUi4T2IIR7BE8edgQZgBtrN57Z/1cO+FAnG
	MirFV5bjxcTduVPWce6jwVTYqp1oHl1UTV0tNcaysHoF7kFfn8zn3oPzTDXaebD9
	cAa/8PMYcLGGRYvSJnyCw==
X-ME-Sender: <xms:kVwQamymoe3I297wzkb0Kh1837N6rNWu0dYoWOPv_YDYDuA6FSLiUA>
    <xme:kVwQajWbmWSfTu6fqRURekkWye1fTpaCwh9NyMD1MdNFYOFBQ5Q2DXq3hYge7r5o2
    AVKcNEz1k0UKmxnFQhQW6kn2q84CmaYfoVPwcJu7q06lku_Yaq2ow>
X-ME-Received: <xmr:kVwQarSIPBhTHVahFiebWh8ITHhmU5Q75FgYZzwpB-2yLcH230xcMY6fdARRbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfgggtgfesthekre
    dtredtjeenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkihhrihhllhes
    shhhuhhtvghmohhvrdhnrghmvgeqnecuggftrfgrthhtvghrnhepteefveejgeffleefff
    egiedtieegiedugeekudehtedvjeetvdegieeikefffeevnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopedviedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvggu
    hhgrthdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehljhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghho
    ohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthht
    ohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:kVwQaqMyYiWrmu6xGWp58hTUxn-2CCKnevJlWzpUixX1p8lZaWQGQw>
    <xmx:kVwQagy94kpw51WVuB8CMgJYGnDQB9w0WFWjnCxZuezjNjBu0CIJKg>
    <xmx:kVwQasret7FEXpV9gr4EvT2TjpOxttQh8nbqnBbsxcY0p4ujBiJiPw>
    <xmx:kVwQakiwb5ZnR0lSphp4iIRuQfPObwDgtMOlq2hCZ86e3k1ihEYRLg>
    <xmx:kVwQakkWPxux-ziEebOd_MioC7VCotmipYnU5ual4LRA9ini_jXDS752>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:28 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	linux-man@vger.kernel.org,
	alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v3 07/16] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Fri, 22 May 2026 14:38:48 +0100
Message-ID: <20260522133857.552279-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wj3jeuwzc9azkpzjzf6ef9p5rbogbtq5
X-Rspamd-Queue-Id: 085492000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779457170-449508
X-HE-Meta: U2FsdGVkX1+elZeSmHLTaHQbOKTDBj9C3fzhTIC0VVuqmBNaIzuNa8asxNL8a0YdleywjqThySjt6eC2xo/JXi4VHWtIBbrH7Caya22qaxir7Z0d0Lk2/zPewhZDksoq3Yu2yT0HQBzIX6C0IH7FHNLEV/Kq3tTwoXXLADiuS0IrFvVfTY1UOLie2NL5fKbjmesNZZWeZCqiuL1hyfFvcJKerbb5oLMnz6W9w3LgFk6R/8r+2Ra5/JQ3yw69rNoe4ejBuTqt9+ln69nmWI650JSwI5JsZnAal15sdS/3x5u46r2gjU4Ph7VSAJli7x/YSwXXCZ7GbhYbAE3TEp46+3bEMXglM/5YdbvOUj3X2dJCpiSlqW2EUZGqmv8UnPcCB+Bp6e+Yh3ydRnu2PgtADxlCvtH9rFJOOF5tEYPUPhaBHcn7UYQl7K/3HotnhNA/Ha3UYcCIcBI67CszQkXrMo91tX5FIsnhYEHtuurRwG1v+9rZKsGiTL2/9jyWM2P/WMEJBSfNj1UQd594ERjUgrk5UabmQ6O3DyZYX8I4w+cfuCOsG/kYznHnRwICDsTmdAQN8hGVdvGdb8Id5u+YYWZNLq4TWFywHXT2NxSnnlsnPvMPSl7aYlAJkAkgpwL9hlNcaP2RqklFLxHlcb7w/3b16QKOcv62Ojw4iZIBQr6u44+Zsf2pxfHeI6SLCuXUrlNZ8/h5W+1u49AH1U4reLqNBKTgLCffHLeO9rt3wEdv82avQp8JdvAo2ebAbcQyruuHn/UAQaguragZ0t5kN+xZod9jUXQG2GrhM0xrLtKMM/lrRH0R2st6CwnZJe5k/8BDsIzHD1JTT9AIRdVbe9Ss3EgpZd6/yLYWgsOhesrkYXsd69916PCcuAyr142U6amjJNeGlz1VodZLZMgUXYLH83meRedBHT6V5/hzTpB9VvAdEo0HT2mOQJBLcPWFV4swfiS2iviQ/l46J6t
 4eVuYuyR
 JzAbqLEDX7FdkKDOzQWUdc+EsNwdcfDL7HoBo6Uvzh3Z8Mq3YECHjshpQ+lDYs+prH45JaBEne61B2E346bF/IdeU6sIszyzvvShDh0KpYbGvEfzP/1M7bPM7ie7yelgBnfM6APm3+rLGbMQ7u+4pK8W8BF0x3B8U8AcD7Ce8MUjolyJz6l/rHvwDCLw+ME/PlV68yOw0dTY8hw638QC6V1MiY8UoT/dnJepgUBp84sjVeFAoKqvmmwUgEpoysPnl70J/3VHB91n4uvNjC/1NRZqW8TildIft9a+qJEHP3WWF2+OSnL3DwI5tai08j4TVXKa4Q7tdNGBthOKdBqCIfLfvHKo4tXfkNFcJXC7zSJsAmEcJuDv9GZznbaUd7xCkgweAlwCMlWfQKqraWrG33tSmapR9i4ZkpeigmrBdw1lMyS/TCFE/dwml8Ao6MAdpufTwHP8QiVx05tlMKDBHh6MlzYkIRXrcKCouk0pcoXHgE5HGgwQVYBZHLwBWTfIBQ0x0+S7G2abm3AGkzWpR/JeOmI1y5WYGjIrlRLamcyIvGM0ic5iSVlMwE5gUg5Cb+f8N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Three mm paths outside the fault handler gate on the uffd PTE bit
today: khugepaged (skip collapse on ranges carrying markers), rmap
(cap unmap batching), and GUP (force a fault through
gup_can_follow_protnone). Extend each to treat VM_UFFD_RWP the same
as VM_UFFD_WP; otherwise per-PTE RWP state is silently destroyed or
bypassed.

khugepaged: try_collapse_pte_mapped_thp() and
file_backed_vma_is_retractable() already refuse to collapse or
retract page tables on ranges carrying the uffd PTE bit. Broaden the
VMA predicate from userfaultfd_wp() to userfaultfd_protected() so
VM_UFFD_RWP ranges get the same protection. hpage_collapse_scan_pmd()
needs no change — its existing pte_uffd() check already catches an
RWP PTE because it carries the uffd bit.

rmap: folio_unmap_pte_batch() caps batching at 1 for VM_UFFD_RWP so
the restore path handles each PTE with its own marker.

GUP: gup_can_follow_protnone() forces a fault on VM_UFFD_RWP VMAs
regardless of FOLL_HONOR_NUMA_FAULT. RWP uses protnone as an
access-tracking marker, not for NUMA hinting, so any GUP — read or
write — must go through the userfaultfd fault path.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h | 10 +++++++++-
 mm/khugepaged.c    | 18 +++++++++++-------
 mm/rmap.c          |  2 +-
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0598b1482aeb..0ecfb0973b01 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4605,11 +4605,19 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 
 /*
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
- * a (NUMA hinting) fault is required.
+ * a (NUMA hinting or userfaultfd RWP) fault is required.
  */
 static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 					   unsigned int flags)
 {
+	/*
+	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
+	 * NUMA hinting. GUP must always take a fault so the access is
+	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
+	 */
+	if (vma->vm_flags & VM_UFFD_RWP)
+		return false;
+
 	/*
 	 * If callers don't want to honor NUMA hinting faults, no need to
 	 * determine if we would actually have to trigger a NUMA hinting fault.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index de0644bde400..a798c542c849 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1532,8 +1532,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
-	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
-	if (userfaultfd_wp(vma))
+	/*
+	 * Keep pmd pgtable while the uffd bit is in use; see comment in
+	 * retract_page_tables().
+	 */
+	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
@@ -1746,13 +1749,14 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 		return false;
 
 	/*
-	 * When a vma is registered with uffd-wp, we cannot recycle
+	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
 	 * the page table because there may be pte markers installed.
-	 * Other vmas can still have the same file mapped hugely, but
-	 * skip this one: it will always be mapped in small page size
-	 * for uffd-wp registered ranges.
+	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
+	 * and cannot be recycled to a shared PMD. Other vmas can still
+	 * have the same file mapped hugely, but skip this one: it will
+	 * always be mapped in small page size for these registrations.
 	 */
-	if (userfaultfd_wp(vma))
+	if (userfaultfd_protected(vma))
 		return false;
 
 	/*
diff --git a/mm/rmap.c b/mm/rmap.c
index 05056c213203..1426d1ece917 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1965,7 +1965,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_wp(vma))
+	if (userfaultfd_protected(vma))
 		return 1;
 
 	/*
-- 
2.51.2


