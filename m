Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81722CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2006B0199; Fri,  8 May 2026 11:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924776B019B; Fri,  8 May 2026 11:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6266B019C; Fri,  8 May 2026 11:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 561946B0199
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:56:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC2F5160126
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:29 +0000 (UTC)
X-FDA: 84744704898.25.559B012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB661100007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ut21CvQK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lm46fnrboymLQUfB59zr/w7Yi4doUkb84inuZ/vTrKY=;
	b=TAgegeh0z27PpRo+I2d60yErxasz362hIxp+UYfCXxcqT0HUCCLL5aqN3LjMbe4g3gYyIp
	Ugi7jq4CdWrrm5Rkh1JFv5xM/h/6nqq9RCuQw6InA6ezT3GWmts2cB/sX4XDg4S26ELsPM
	3B6AK3j/DzjrkLxI9pOehMLgVAW5lPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255787; a=rsa-sha256;
	cv=none;
	b=6kzpL1E8v9Cf/fNAVcZnuqG43SOaCeUzjLA68StVF7Z+s3hMB220AqV23FzsnkhbJsZfWm
	c8cMy/6adY/6Q1W8HcADNQ02UTpivKVbCUUlhSti/qFGNwZ597L5U1jE3L3TAiONz9O5wv
	t6b7Bddmaozym63ClOZ/o6I8MbWC9Os=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ut21CvQK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C24260582;
	Fri,  8 May 2026 15:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BA3C2BCF6;
	Fri,  8 May 2026 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255786;
	bh=kJbcMJlpsyLEDywKd3yLGpkL6ZqjGtsC4/OESxF6sXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ut21CvQKZ7B1IRb2LJ7n+pKlySG8EZ24E3qD7UuJj355EFu6yqzCMvIll5Ie9Xtq0
	 DfGsaRoRkuzUal3umSAAmUwDEpB+Ec99/L5qG+CV6JhvDo4AZ3+8g15exidnoX0hs8
	 bj7UdFXb4qAYAPFI5Y7nLF8INraJ22lWpA9wag3M4PVu0pf1c3e99zoSG1ku/XAMmm
	 pKpUMzLMV8GGuIN0LRLwwC/gV9gKuvY8R2G4jrO7BQ1iuWGzra8LegvkaYFh/i9X+7
	 3tAU1K8iNaRovMvYL8nh84qZrG66jcatkOUyC++n9Bx9Gf6VE89/DpFrtU8huiqF0D
	 J8gfRaxOIHonw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id BD533F4006C;
	Fri,  8 May 2026 11:56:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 08 May 2026 11:56:25 -0400
X-ME-Sender: <xms:qQf-aXhI-16iR0LgLn0twqL2gSHfdw0qgUAy5VqyrJeZSPL_o4v0OA>
    <xme:qQf-aX_y4-CKWkYbcjzDgjKx4Rg2YDQq17KY8Gs0xzBVK-sSVLSDL1HaYbOydq6bf
    xEU6KMfdUSNM7Hp6azjKbKz0MODSZXyrklsC16M1WR_LfcqDgkCdQ>
X-ME-Received: <xmr:qQf-afmZvYT6oCWKGhAG6gxip541G3HbP7aSvGhWXx3gOGfB9tcfdyeoMjrYBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpedfmfhirhihlhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcu
    oehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhephfdujeefvdegke
    fffedvkeehkeekueevfedtleehgeetlefgfeevveeukefhtdetnecuvehluhhsthgvrhfu
    ihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtph
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
X-ME-Proxy: <xmx:qQf-ad1VeC4-xLgVEAuXQQUu8uPnx7bAAcvNPzspenCbnShY-HV1ag>
    <xmx:qQf-acRv5YKPhlZs8EqP2wL05J02YgDpsZScUNTCyhF1XdaTwHxvEw>
    <xmx:qQf-aVPAE968a_q7arCGaSCaOCE0LD_dJq2nDHByzbqGR2fQRR56Hg>
    <xmx:qQf-aYibqONQuKJWTFHPXRjcDR8GssIm3dCWyh9jbDCozdri9QINpQ>
    <xmx:qQf-adKXiBTGOjlqCwFRSmV6fyVnj79NYk5EfS4_WVoBJPT6W4len4mR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:56:25 -0400 (EDT)
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
Subject: [PATCH v2 09/14] mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
Date: Fri,  8 May 2026 16:55:21 +0100
Message-ID: <454b3381cb7ead65291b2d7e24c0bff62e55c41b.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BB661100007
X-Stat-Signature: fj5r9wzkd1jgridybuotqkx96ybch5ae
X-Rspam-User: 
X-HE-Tag: 1778255787-439377
X-HE-Meta: U2FsdGVkX183wpp7mXeTAFfxuMA/2C4jMxeMW55XaUbAl9UyX6ItJ8wFtg1HWuQG4adMpXzFYtBaRodVpCfi15dyM18zDmCylFxjcdUXSh2qlzxgz9ggI4XGt6kJ9PfUDOOZgTidlwhnvwU7hrnx8dPUha3tc0kbx6Td4aKR0uJ5XWxXNTdzZ7wt2YrWKPXF8UcMJ6xUMIt5ETKseMytR69mO1Sl0/xc1QKh8GqoZkCd11lgLNbjp+giqVdj+sPpDTEguqfaJAkDPlurTLs17HFzRMW1t83HdVKKGJtzJp4r29OmVXl4FmPECL0N7lqgb+Bj7BORZBefZs/NMQrNxulN3Fz0sQdrGEz7KG9a5h4RM1mvP7dD1FzdAyGOZYJnnxgfGOEhHcx2mFkUwuupeIr3yeSCfUZgfE02Jg36iCSlVKYDjD3LldBQOHbAG/nWmzj8z2DVaDHjkaMopv0wmd5DIFD+0mCsdH4ZXbqGS/0IqBtavbhVWslhcemVjSh6NnNHwJJ4er056Tk+HcjriVfchnHjXdL22AuoTxAlNb5+VCeISAXZKq3qs+8Z6uCheNlN4w8RX1iQ3TZfmVoqw3IMof8VMUtGwBixZVryfQL6x6sFgRNbokfwVV/o3syt/JbWfH5eE8RcXEZIse+1tpOJJUuZg1SqDRTngcJKDWnOU65c0kwwnG5mKJ0lG4y+1NtsexFKco/UAFy4kJxRO/i5Jkj2JcxbIgXmkOoaA3etLI+I1MD3GXblWKHAgdhCI0fDJQ5H+kqC1oLtG0So6kGOxovcgrYSj3o4KBlSRDTj2jaAfteaLSbWY96DbEFthZRINT9rG+XlGQ6Ip9Vf/p2ijTW3+b1MYdzJMI6Rt8tDVga13SxGYocJCd5ZDTUkWDUwCMHbjOZ3MawA3wcrGje4GhY8dbvMqF/IR2VupCYQMcPWrGZJKHnybAUkLpKFkD/UJHAr1ZQdEu4vStJ
 gAE8QIL0
 Q//ffluuFZG+UK2JYDqniQtsqQcVFrlvf8QH2C1aklj4QeJsbzSsdG/Q6m3+o0PAtLBaQi3DgvAt9fcVgaF5xsoECr/f/hrevAF5KepeC2zRatfmTArZsqR8/Iv/jcvBuG7N+gfY0Oeqaf3JdBc+X/Ik4FnSFNhGwdkInY4kOGOFZk2dcmRmAiWI/NQ83FW8uaqy85Dry9ULtW3hIOer1aA7Y3m8MIRlk+pfWmZO6597A+VY4KglF8bg6lsRbWoCxX+VAqoZNY4BQC3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wire the fault side of read-write protection tracking and turn the
userspace interface on.

An RWP-protected PTE is PAGE_NONE with the uffd bit set. The
PROT_NONE triggers a fault on any access; the uffd bit distinguishes
it from plain mprotect(PROT_NONE) or NUMA hinting.

Fault dispatch, per level:

  PTE     handle_pte_fault()    -> do_uffd_rwp()
  PMD     __handle_mm_fault()   -> do_huge_pmd_uffd_rwp()
  hugetlb hugetlb_fault()       -> hugetlb_handle_userfault()

The RWP branches gate on userfaultfd_pte_rwp() / userfaultfd_huge_pmd_rwp()
(VM_UFFD_RWP plus the uffd bit) and fall through to do_numa_page() /
do_huge_pmd_numa_page() otherwise. Each delivers a
UFFD_PAGEFAULT_FLAG_RWP message through handle_userfault(); the handler
resolves it with UFFDIO_RWPROTECT clearing MODE_RWP.

userfaultfd_must_wait() and userfaultfd_huge_must_wait() add matching
protnone+uffd waiters so sync-mode fault handlers block correctly.

Expose the UAPI:

  UFFDIO_REGISTER_MODE_RWP   -> UFFD_API_REGISTER_MODES
  UFFD_FEATURE_RWP           -> UFFD_API_FEATURES
  _UFFDIO_RWPROTECT          -> UFFD_API_RANGE_IOCTLS
                                UFFD_API_RANGE_IOCTLS_BASIC

UFFD_FEATURE_RWP is masked out at UFFDIO_API time when PROT_NONE is
not available or VM_UFFD_RWP aliases VM_NONE (32-bit), so userspace
never sees an advertised-but-broken feature.

Works on anonymous, shmem, and hugetlb memory.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 fs/userfaultfd.c                 | 33 ++++++++++++++++++++++++++++++--
 include/linux/huge_mm.h          |  7 +++++++
 include/linux/userfaultfd_k.h    | 24 +++++++++++++++++++++++
 include/uapi/linux/userfaultfd.h | 12 ++++++++----
 mm/huge_memory.c                 |  5 +++++
 mm/hugetlb.c                     | 11 +++++++++++
 mm/memory.c                      | 21 ++++++++++++++++++--
 7 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index f2097c558165..6e577c4ac4dd 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -261,6 +261,12 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
 		return true;
+	/*
+	 * PTE is still RW-protected (protnone with uffd bit), wait for
+	 * resolution. Plain PROT_NONE without the marker is not an RWP fault.
+	 */
+	if (pte_protnone(pte) && huge_pte_uffd(pte) && (reason & VM_UFFD_RWP))
+		return true;
 
 	return false;
 }
@@ -321,8 +327,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	if (!pmd_present(_pmd))
 		return false;
 
-	if (pmd_trans_huge(_pmd))
-		return !pmd_write(_pmd) && (reason & VM_UFFD_WP);
+	if (pmd_trans_huge(_pmd)) {
+		if (!pmd_write(_pmd) && (reason & VM_UFFD_WP))
+			return true;
+		if (pmd_protnone(_pmd) && pmd_uffd(_pmd) &&
+		    (reason & VM_UFFD_RWP))
+			return true;
+		return false;
+	}
 
 	pte = pte_offset_map(pmd, address);
 	if (!pte)
@@ -347,6 +359,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
 		goto out;
+	/*
+	 * PTE is still RW-protected (protnone with uffd bit), wait for
+	 * userspace to resolve. Plain PROT_NONE without the marker is not
+	 * an RWP fault.
+	 */
+	if (pte_protnone(ptent) && pte_uffd(ptent) &&
+	    (reason & VM_UFFD_RWP))
+		goto out;
 
 	ret = false;
 out:
@@ -2086,6 +2106,15 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
 		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
 	}
+	/*
+	 * RWP needs both PROT_NONE support and the uffd-wp PTE bit. The
+	 * VM_UFFD_RWP check covers compile-time unavailability; the
+	 * pgtable_supports_uffd() check covers runtime (e.g. riscv
+	 * without the SVRSW60T59B extension) where the PTE bit is declared
+	 * but not actually usable.
+	 */
+	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
+		uffdio_api.features &= ~UFFD_FEATURE_RWP;
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..e980909ee49e 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -520,6 +520,8 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf);
+
 vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 extern struct folio *huge_zero_folio;
@@ -702,6 +704,11 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
 	return NULL;
 }
 
+static inline vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
+{
+	return 0;
+}
+
 static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
 	return 0;
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 3dfcdc3a9b98..37e8d0d29353 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -247,6 +247,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return userfaultfd_wp(vma) && pmd_uffd(pmd);
 }
 
+static inline bool userfaultfd_pte_rwp(struct vm_area_struct *vma,
+				       pte_t pte)
+{
+	return userfaultfd_rwp(vma) && pte_uffd(pte);
+}
+
+static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
+					    pmd_t pmd)
+{
+	return userfaultfd_rwp(vma) && pmd_uffd(pmd);
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return vma->vm_flags & __VM_UFFD_FLAGS;
@@ -399,6 +411,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline bool userfaultfd_pte_rwp(struct vm_area_struct *vma,
+				       pte_t pte)
+{
+	return false;
+}
+
+static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
+					    pmd_t pmd)
+{
+	return false;
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 7b78aa3b5318..d803e76d47ad 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -25,7 +25,8 @@
 #define UFFD_API ((__u64)0xAA)
 #define UFFD_API_REGISTER_MODES (UFFDIO_REGISTER_MODE_MISSING |	\
 				 UFFDIO_REGISTER_MODE_WP |	\
-				 UFFDIO_REGISTER_MODE_MINOR)
+				 UFFDIO_REGISTER_MODE_MINOR |	\
+				 UFFDIO_REGISTER_MODE_RWP)
 #define UFFD_API_FEATURES (UFFD_FEATURE_PAGEFAULT_FLAG_WP |	\
 			   UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
@@ -42,7 +43,8 @@
 			   UFFD_FEATURE_WP_UNPOPULATED |	\
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
-			   UFFD_FEATURE_MOVE)
+			   UFFD_FEATURE_MOVE |			\
+			   UFFD_FEATURE_RWP)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -54,13 +56,15 @@
 	 (__u64)1 << _UFFDIO_MOVE |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_POISON)
+	 (__u64)1 << _UFFDIO_POISON |		\
+	 (__u64)1 << _UFFDIO_RWPROTECT)
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_POISON)
+	 (__u64)1 << _UFFDIO_POISON |		\
+	 (__u64)1 << _UFFDIO_RWPROTECT)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2aecb6d01c44..631e0355919f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2264,6 +2264,11 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 	return pmd_dirty(pmd);
 }
 
+vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
+{
+	return handle_userfault(vmf, VM_UFFD_RWP);
+}
+
 /* NUMA hinting page fault entry point for trans huge pmds */
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f2f1eb6cf66e..bac9aa852f6b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6067,6 +6067,17 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_mutex;
 	}
 
+	/*
+	 * Protnone hugetlb PTEs with the uffd bit are used by
+	 * userfaultfd RWP for access tracking. Plain PROT_NONE (without the
+	 * marker) is not an RWP fault and is not expected on hugetlb (no
+	 * NUMA hinting), so let normal hugetlb fault handling proceed.
+	 */
+	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
+	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
+		return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+	}
+
 	/*
 	 * If we are going to COW/unshare the mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that any
diff --git a/mm/memory.c b/mm/memory.c
index ea9616e3dbaf..e0dcf2c28d9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6172,6 +6172,12 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 	}
 }
 
+static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
+{
+	pte_unmap(vmf->pte);
+	return handle_userfault(vmf, VM_UFFD_RWP);
+}
+
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -6446,8 +6452,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	if (!pte_present(vmf->orig_pte))
 		return do_swap_page(vmf);
 
-	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
+	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
+		/*
+		 * RWP-protected PTEs are protnone plus the uffd bit. On a
+		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
+		 * NUMA hinting and must still fall through to do_numa_page().
+		 */
+		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
+			return do_uffd_rwp(vmf);
 		return do_numa_page(vmf);
+	}
 
 	spin_lock(vmf->ptl);
 	entry = vmf->orig_pte;
@@ -6561,8 +6575,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return 0;
 	}
 	if (pmd_trans_huge(vmf.orig_pmd)) {
-		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
+		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
+			if (userfaultfd_huge_pmd_rwp(vma, vmf.orig_pmd))
+				return do_huge_pmd_uffd_rwp(&vmf);
 			return do_huge_pmd_numa_page(&vmf);
+		}
 
 		if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
 		    !pmd_write(vmf.orig_pmd)) {
-- 
2.51.2


