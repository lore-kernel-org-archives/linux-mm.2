Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5092DFD7F9C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92696B009F; Fri, 27 Feb 2026 14:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E716B00B1; Fri, 27 Feb 2026 14:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A826B00B2; Fri, 27 Feb 2026 14:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 916986B009F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 532BCC2D97
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:59 +0000 (UTC)
X-FDA: 84491229438.12.BF91CA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29D4EA000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n3AwiUGj;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XOk9plGhk/cgTnCcz5EBmiBCnMN9CNw2pw2wcV3WY0=;
	b=Q5JG/eDSsjVtJkSan2GrfteSCOgry2BdqRdIdgT+Jx+wpUeGqBvL5Zr05dxLUEussTRYyi
	ba5cAONGfqE52ZJSpTr1QctzaCMWNBH7m8lt8nvXcLCU5OHmbSGJCAKHPE9YpdJUF9qAwF
	4kKLKtQzndOgLXPQt2KR/MGTrWMt1Dk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220657; a=rsa-sha256;
	cv=none;
	b=NjOhiobrAoG14L/uDBPu2wFS3eoRMraHVSFYLxFKgWhuS9M56HYyLy9IBKTpc2nabAQ4sv
	7GuhsATQlSImR1RCdSRbU2yedynvRjbp4KxhzTZeHrF/0OKRxcThcRPZ317wjb9UPtrNwM
	Jj9D2+38I8dt/+Rim24I8G10WfqaKhA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n3AwiUGj;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88A7A6057A;
	Fri, 27 Feb 2026 19:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9983AC2BCB3;
	Fri, 27 Feb 2026 19:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220656;
	bh=FHdzeRKulPcy6fiq+UUCtu6gFm6WIXAqf8YglnUe5co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3AwiUGjqbDNzIuRFLObcbbqNVz5xrlDt+QEUAbr4OJZ9EHhtmX+Fu6vfueyT0YoQ
	 5c6NhTKYmjpBLnI5eqbyoh4bG2Wx46j+yLsgvPFiu6M6KwZN3Ss3UGZ2ijAGDGt1Ml
	 n/l68isWY0MiXc2OtBuqGY2iFuVtqvgT3h/Cdp2Xlqo68Emt65Zhu0SsW3n6IP3jVv
	 t1XFo/TkKJdU5hsvwYNbRLzcKmYRao5iaJVfo39wPH9jpD4hCw3x7kS3tMElg7Y/jn
	 sb779UVtFJ4jFV6R1gIxc5IjdcCiOgqZ3+gYHeBg4Oy5RPuN89KCcja6pCNb05YHVQ
	 0NbCGhcmG71Ig==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id B222BF40069;
	Fri, 27 Feb 2026 14:30:54 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 27 Feb 2026 14:30:54 -0500
X-ME-Sender: <xms:7vChaT_T_oNfGLJ-NPGGuiSfK88pamySplpo_nYZhEXpIuPzDn7s4w>
    <xme:7vChaQfqNIA2ebcqI6wb8vHHNT1ekeUNhmNzaKYxw95WMmdLKpYyqePFY9qU0dClk
    koeH5OXmFuEnzX5OaHsp4Mt2u32RZMM0J8La81yf4my0BD0HtMtRMI>
X-ME-Received: <xmr:7vChaU0uM4WzosPOxCvgUUUS--WpkFeCgmC0roKSH4a4nrrbFgM5i0ViJ1UVgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:7vChaRCTeYHTfC2CEBOBKrNprtN_1RffpoLANYGJ87JrsF0985kQ4A>
    <xmx:7vChaXTxKX35zkwDrKecdDeEE2I3uCM46RflWSP6zF6T4Y1jkRf9ig>
    <xmx:7vChabIsLAwv_VTCYxN8QAJN3nh1-J_UGEZBudY6PH1ND2S1Zm3tzQ>
    <xmx:7vChaWH1oWjN20dIOzmn4twPNY63qhEuuJjyig7Nu1VQ8E6nKsRwBA>
    <xmx:7vChaaJLl-4R-reywvADD_pfe7EQA4LaFsLxOzJ8z2AYlGDx37MgiIMl>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:54 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCHv7 14/18] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
Date: Fri, 27 Feb 2026 19:30:15 +0000
Message-ID: <20260227193030.272078-14-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ntj3upnhnmut1azuajrym5fmdgo6xsde
X-Rspamd-Queue-Id: 29D4EA000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1772220656-404601
X-HE-Meta: U2FsdGVkX18WA/nbKwPMXPpdjtDhk0j4NbzZz3zxldVUjvaY0gKw70JCGQt4UUPndVZ4X/yi+D6ddvxOwbBu9VF9ggJemjZezTr79E5l3HeqnUVyD4cJtml7qZy3gh2GOlzMCozJEd4LFjhF8dAPrl+RFY2jwwPAE6Ef0n4Qie1f88NrUXC1QMF4/BxViXRzrHyS/BrJsQ/jr1G4Wmd6MyKDUMSAVYjVa9guMu5wqjpECF924fstlvs5V31S+hLB3BlV8ul4JIeTN7jlxTB2IvF+BJmIXvjL8fN0EKMJ+l5Cvk1hfWFDJLBNgBf6yDnYxHHybcGctXZKHuFG8exqofN768ZWLRtgNiY1aXLyshQBvBXZMvTvqchudMgJGruHPN+6tmgmIxJ3NszlOTa1gwYhCUaC+TnugUupmU8WYb06xaKzGODLiWP69Eoj71XLlHU40GEKAybj1WL0TkWo9MHS9oCMgaA7j3Q1AniTRyL///yhhztFfyPlenmD2eICTf2I+U5D2rUvs5B5IKNBv8+7IggShcMoRzhzBS+rPvogbsn/otsr19sxEp5btojpZBnLKq6/YRR8mbtmD6CB7Afp85Xk0fDvef+s6sIzQzfiioV/MJU3EY0X6BKTsjkdeGE2bP+f7LT5071fovnlMEhDcHTIQ7JiNZKx22DiTpyGZpi2qEqNJ+YM4Qo8fvjSsF8UPmjCJrZReBfj9D9LhnQJR74K+5O+599uob8Mg/eigxU5SFPoPUgzI9TEpNhBozXO76u/5PQBhi3UomsFBy/AJw/D193sgdsUBBsYO2aKaKF1+yuO5ZPjAVr+VRUg9sp2Xa+rzRDl/Q/s4rI2UBGmZ71WEuLS9yt1+qiySGKSlXUbRTHkEOGzw4wXD/wexGKm3CtU3zgg1TZDlwFz208NygSMCVEflTx27UXpTeKBphNrAcFGRqnBF6bwavcptsINeJVgqi1rzUNlMGw
 WS41fSZD
 F8tHkWwVb60fKdKyqKyhKh39+0pEUnjU3yUDNgV9kY5v3OqvKMawf5aXGk7psm2flg+mGh2TUMqRKXqb4z6UxvJFI+zPo6nVMJ9cynNyUurOjCY4+pzE03JdFlNeKMub2eeaN/Ry6J17ARGP0mt9n+TxCvBJzBXqiX0qEUSVonqqMAmOU3YgzYzEtMbS69BCJVQYq1MM2Ndb6Cv5thM1Fbpppa4KpkvZHcx0ciwh44ED2GPcK0GLVW6TTFqOxY0PKy2zzqxYfMwlfTweI3d+qluY80zZS3KA+ksas3jEpor3jjvoNBPM+aFJ13g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The VMEMMAP_SYNCHRONIZE_RCU flag triggered synchronize_rcu() calls to
prevent a race between HVO remapping and page_ref_add_unless(). The
race could occur when a speculative PFN walker tried to modify the
refcount on a struct page that was in the process of being remapped
to a fake head.

With fake heads eliminated, page_ref_add_unless() no longer needs RCU
protection.

Remove the flag and synchronize_rcu() calls.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb_vmemmap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 92330f172eb7..fd1d5d5d12b4 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -47,8 +47,6 @@ struct vmemmap_remap_walk {
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
 #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
-/* synchronize_rcu() to avoid writes from page_ref_add_unless() */
-#define VMEMMAP_SYNCHRONIZE_RCU		BIT(2)
 	unsigned long		flags;
 };
 
@@ -409,9 +407,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
-
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
@@ -444,7 +439,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore_folio(h, folio, VMEMMAP_SYNCHRONIZE_RCU);
+	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
 /**
@@ -467,14 +462,11 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
 			ret = __hugetlb_vmemmap_restore_folio(h, folio, flags);
-			/* only need to synchronize_rcu() once for each batch */
-			flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
-
 			if (ret)
 				break;
 			restored++;
@@ -554,8 +546,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -613,7 +603,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -641,7 +631,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	struct folio *folio;
 	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
@@ -694,8 +684,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		int ret;
 
 		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
-		/* only need to synchronize_rcu() once for each batch */
-		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
-- 
2.51.2


