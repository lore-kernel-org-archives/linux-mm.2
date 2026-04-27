Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B064FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82FD6B00A5; Mon, 27 Apr 2026 07:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5ADE6B00A6; Mon, 27 Apr 2026 07:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D714E6B00A7; Mon, 27 Apr 2026 07:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C429B6B00A5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:47:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8659E140180
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:47:15 +0000 (UTC)
X-FDA: 84704160030.18.3BCE20F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92ADB10000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:47:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n8J2Oa8R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVxDpO3C24Xoxf7gic3UNkVZn7Rq4FyWxyLDl5v6NUM=;
	b=vGNI6PiszOmOp2f0fp6oHbSUAXDpQQO2Wsy3gDknVL9iAccm2yckQYIwijOXF8TE4iTztK
	1csyzQyZ//K4d6TW/EffLLnPdsIXquucWMKyX8QI9HLmzrkEvfRZUVndKh+GkMJN2YrWub
	O8CF2BkmXMgNI+OMdaynxl0AsJ/RcSE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290433; a=rsa-sha256;
	cv=none;
	b=ZBHM4GrWRWu6XlilNeQq0N5/v32SwQHwZgMaFHXz97FJK3i8Fl1rwwfQVj0W2hWFRYy8iV
	RZrN1MvZpQiiObu+iifZ/4spNtztPI7SqPtJD4TBkIVz/nfuv00V22wozz4RmwPBnq96CF
	1NgEEKm4Yqbrt+5dMRJF979Od87uYh4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n8J2Oa8R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13CD96015B;
	Mon, 27 Apr 2026 11:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40361C19425;
	Mon, 27 Apr 2026 11:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290432;
	bh=6KqTjREg/f3OEz7aTNTkTQsj2SxH2HMauSfeIrq1M7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8J2Oa8RHfqQGGpcfP84JqzLXPAzfOI0bGAvVPNGUSV0NER+uwlgxnV0fK6rXTyof
	 3S9hBbIlEISC20SHU5Zd8KcqZurwv0lx0/VEV30QQlB6g1AelKZgnyIg/Ez3O8xzqJ
	 X4G5cWk8fz70GZ85rFIe4XIqAV2rzEVTjKlkbQFFXJJueFZbj/BLRy5KmYGVvYIKTO
	 lsL8MlWo5zTSzxsOIafT+AC8ppWlMx/cH8INSHzlcb9Rqb0aojFgMnXZ6BCbpOn7+d
	 oBRuqjdFtfNoUoaNLhOe72C1Xj3JAfLZUkFAiz3qf/IUfVRRXrI54Mi1lSOA5ZCykF
	 2sQCAEz8uV7zA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6F7C7F40069;
	Mon, 27 Apr 2026 07:47:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 27 Apr 2026 07:47:11 -0400
X-ME-Sender: <xms:v0zvaU9HYq_cevM2ugt-h3AOmz5bfyJAvxJl2j_FJDVqgJ_RdPcNDg>
    <xme:v0zvaQqe5wVoexq0ktr2lR71YAiLL45Fax42YMI0obOR0JB95FtbfgFjvLM2ctrY4
    9W7gJrm2z3jadnaOu89D2n4rOAkWrclc3UdF1v91HHqH-umIyjZ_527>
X-ME-Received: <xmr:v0zvaSiGkEHMCFnppKJDzjerSWGTFigdCnXHJvA30sWsiCYpsxxLKxN3vbTREw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgjfhggtgfgsehtkeertd
    ertdejnecuhfhrohhmpedfmfhirhihlhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcu
    oehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhephfdvfedvveejve
    ehhffhvedufedujeefuddvkeehleduhfeihfehudejffffiefgnecuvehluhhsthgvrhfu
    ihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtph
    gruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedq
    khgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtg
    hpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgt
    phhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrd
    hhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughi
    rgdrtghomh
X-ME-Proxy: <xmx:v0zvaeAfzZFYhLX8NBen-_S3sx_6TJbxX5U35LOKEJS9YUUK_UJyww>
    <xmx:v0zvaQslQtAJNIaOekIXcjOYe6wUbKhf0JVN2OfJyVGVa7JFaP5-Kg>
    <xmx:v0zvaY653sgpf3EjbV7-rj1FgUV5uHr6no8Kv3ne355hsybutBDimQ>
    <xmx:v0zvaae7YyQARNkc0rE6ylr6KJKJgqSkHKgAszsEX9kN7z-Po3yY-g>
    <xmx:v0zvaQUfpUES66_Pw_XK8e9pwzFeLPnM32FjQB_vakdX48DQXF-z8C4->
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 07:47:10 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 07/14] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Mon, 27 Apr 2026 12:45:55 +0100
Message-ID: <20260427114607.4068647-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427114607.4068647-1-kas@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92ADB10000D
X-Stat-Signature: gguhj776a6a74czgjmqgepdib54n1by4
X-Rspam-User: 
X-HE-Tag: 1777290433-847314
X-HE-Meta: U2FsdGVkX1+/cbaI6yNVSqzXdDkkvWj92MAyhdNbssl4xAz1/1vZc/YlWnFfdPYFkUbvOZJkBRDWlOKdTLCG7MJ9dFLEzu2IUW/X9bIm+BTdkmP3PV/8H1mIb3IINX8ItHTS1MehHL0HKo3qnz4RBmBTfIh3kRoHUNgsaRsD/CcottVCV/vWb9A8NTIrrijjQPybkgfSf7tAHScvjttgrMwDIWxGdKXLAvEm5zYiRKX2X7e5O1VmL4Ie7LP8Kj5d5Ng2BKc012nzWKbGw4AS/+c/dHE/KFGE2us600Vnisx1rQlVrYDHqpkeZvY+g1L94g5D/L1jhN65fqnyO4ggC4KmHM8Tzb+YX15nzTu7FzwDgGviXehI7Q/dl+E+4z/MOYIwtAEbJwggJy0kqTC843ds+EyLsBHc1qsAYe406nzwKNYK6VzI0A/ouHeS6tV1j6QfgrpvyHO/mXMBmDwDjcZYasQ1YuIxNpBe1IPX1MaK/Zi9QycJ6dK8DiCZ1AiDJq3XIUbcuNmsBcBp47J33fEzzCcmeR4VvHodsavcElc8lN9ixmDCq5Z4GprjiPP3aRPXexECaOkPTopvwdmdnbxrJjqjCtP/ihje0wdod03wejvPCLYxlxaL/QdPh9BGfQJSN7LA9ovTmVtk+KTwK4w/GecB4knitnqwsWqgsvbOozlYEEXK1+M/vrV0viHrODPm+NfYzZt1hs8ar5jZG4krEsV/BdFr9PI4lbgFeDJcp0nakWlzyqWEtSNThnUILCjUrSzeR5y+CaiokUqcLdNQm4rTmXQ+2TrzfdWmw+tyykD6CXowdzxUmsFuJA93NTWX7PRDaigh3zYrWUcvC02vAHaULtusluIFLKVOrtRD557DoEJnLsKuHT/0t3bRiyPNaNjPXWggBuYdO10mAV626fvuYmnIrAwzWrzkQI2Ur+03QdMJ2oKBrR4NA25tJc6ML7CtruOqZA3jV26
 EAq26zjE
 3stPgn71FVm0Pz9+773LCqwP8FGVlw7RGdE8vA/GJy+63EgS37NpiTpPiqFOZtpKLwik/MuJoszqivpuLMuF1sPfyeK/khRJxgE+pywctMOobzWr6tyWsREuKwyM6/A1bAm/pn7pTmiUoMqCBwnj8PZKrNf0s+gwRs2ufL1xyr/qJxVatLW21jK+ApnPcNDDdVfEsa8kd9oRsT8zvPcieYns8geOfcrsrBt+cnHHlhCKvMEo1DUUrUy9P1cAIf2hchmUDuUzZDhAhnL17rxO991/r/QyLL9GlujRw0/FHURMSmaPEWZ5QsvNIhuwdM1oqlPygsWgxXG4agRkCQzxtaeeT5vwMoUJ+AQpFN8RxB/eDXFvs3+6YRe2H5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 include/linux/mm.h | 10 +++++++++-
 mm/khugepaged.c    | 18 +++++++++++-------
 mm/rmap.c          |  2 +-
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1f2b6c6cc572..675480c760a7 100644
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


