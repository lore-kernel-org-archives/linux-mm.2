Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3299D109190F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616986B0561; Thu, 19 Mar 2026 14:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6E16B0562; Thu, 19 Mar 2026 14:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467D16B0563; Thu, 19 Mar 2026 14:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34EA36B0561
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:23:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 019485A0D6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:56 +0000 (UTC)
X-FDA: 84563636514.27.3BEA07F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 45E674000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:23:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MaZTObag;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxCgybqMsttz9tBvYrTyr1I8WUH1X6DE5Fq3Vt2/+Mo=;
	b=13GapXmYRGUo3nqCHFauC50u/YKfl5yHLnnrBVZ8L3HXK6xF51/WRZHcPOu+n7jNegT258
	PZOoETCTX+KwsFdWbuHwxh8Ac0KbAbfHcWz59fJn0AQOQ8IEuEBk81UzUnplIUriVzVStc
	0JNaNHrju7MBnQ5hpkQ8ZQ/2QtND38Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MaZTObag;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944635; a=rsa-sha256;
	cv=none;
	b=vYdXsUGFiH1GY2N6Ou0yNuenJuc7C6VhbQhGNSv4B8SmiFXp2JAIjJ/DDQ8oyc0xly1Ao7
	szAH1yP3ZoRLS5OsdQ/fcbLZ3x0CTJshnA63CMR4+K9RqkHaeeQEeIuElywjHV4q0XPSHP
	uZDd/HjjXvpvrdADYiMmuVSb1l0U9sE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72B6D43F9C;
	Thu, 19 Mar 2026 18:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BA5C19425;
	Thu, 19 Mar 2026 18:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944634;
	bh=5Tw+CvMJ/jv/meNwzLAY6fkMGHWjyuoE3XwxJ8B9LXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaZTObagrzlF+hl3XbFw2JtTCmbKnqNi3t6CqzD4hNYU680kO24lq7WshtcPMpAP6
	 cGDai0fDa2TxZ/S3NYHCSIDdRQgJwU764FLz2pC3hsYA6qrB4ZLj94bm20zPZB2UMW
	 OIBte6f4yK3FFp1Pbn/yYxzVbJghQ4dKcWdYCmz4YqRPsUANonIGgeK5MlXjU+Qadw
	 fUSTxxHimR5oBfPieF/xOzVBgFliUSyS4RXAmbLVPQcRhkUVpE81E03R7REeUr9uts
	 QKBmKC/eHcHVm4TCrshN/g8dlToiHs5ShnSaxrLTtjTqCJ9MGOHHGL+NbcehLC0Ppn
	 EmMKuze7Z5fCg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v3 03/16] mm: document vm_operations_struct->open the same as close()
Date: Thu, 19 Mar 2026 18:23:27 +0000
Message-ID: <808919eaae0b682ec631301b3c06d85c62ba428d.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 45E674000B
X-Rspamd-Server: rspam08
X-Stat-Signature: q55bbsrkjw79wb1wod9ecfetz3oz7qfc
X-HE-Tag: 1773944635-122368
X-HE-Meta: U2FsdGVkX1/vohLKV9l5wyVLhdcEk7GKRk/E6UwKmeoNsUYYKuvKaR2Jceerp2GnbrIC7COS7mm+Gq6g153hJxU/XAr16PrJEcxW8BD87CASon5Q1y043nL5MRMuPt9xLx8nmIQ5znnK/x5UpsM0gWnM76oFum4dSD+Bp5sXBnw1C3spED7K7w/VUHrheunHHPg8S8wbcFJR1R44uDz21mh2Mb0GkTJnyTqIp1hAlkhtkTnMqV55APBL9JkpbuFg4k7BPYG30xY2HKHVUj45HrjZsxZDuxggzQgaau4Qnw8UEt89YC8RdyJmBJ749L2oY82L8NhoxTcORW8eNKl3jNe/kN5R9L/qhmG0oSclVVS8KJpTIlcpbvCQRZFkXPM6+qmLFlFoHPHsm/s8r+sqTyJllXo2v9QF7zyvaxRP5mNXXwOY9EyOegUROlRpzCzSrJzBlaoEfusBzbX/HzUbDDj+H14dPMozhU/lS18PODyzPq0izo6qmw1gNqN0CjpSE/YdZzSIGLnVy9JGXqNEY9xmCsM7B8kEfeSom5l1iipFneaYGTXMFqrawwnkyR9GfrSagVXz5oYgZdvPLDS6i/cScIm5Ig1dl30aJuMFAH/cpWF/sINy9vQ7af3/vK7y2r1ZhMG8WTWpqEEf/C+/9zRKjfDkiaXShdeTSaJVmhT1rNnTiCLUzayDPU4vd7/fDUzBjSHAzo1ZqVSawqf4tt6nc/He9HuZ2/iSkg6ydCMMcKxLCTvbClUm415/X2Z57XJ5GNSgURw3d9xtCo91OOmEaxCEe+cWy6qWo3Swi7TKkjDb2MMhlqCKiyKoE+RvmOa0EaC++V9QRk5xa4kMqTuQCaObHs0fvjyUq/X+wPN8g8k0sPVW0Gp3/wZE3uaaHiFVPmyHMgWAdw+Lv4Rdyps9UZlRHrrC/eTmd2Vxq5hwSSYb6PNSuqMEjUp9o4SDY7JKuBH1i2E2Pa+gMqj
 Z+22phnk
 J3I5B2S/OF2fCWtJTIxIjYHsEdzPffKirOTt60hKBMKGx5BTepHJztKqBsLkB7SXU7GRfPeiR4pRyRalrRSsVObrnAQ2bO7BLhXnIlb7AC7J44EFZnq+cWMbzLNN9ofo4Wsl21U8TjAscTKiXgHPIay4uEziqfVCOzLvsmSbtiD/gyqXqjJdTn4LTtb8Y1EQqW/1ytWTLzq7DTPr5cQc/jhJ+DLbvOoPj+DG7HNO7FXm8U20roS39V8ak7osO8WVZSCs1BoXtefFMinam1GrhH/OQvF3A3gFjPUPdkso9WLQPlGvz2UPTm/t95zhfy3T0l6BBrLSQDnFfZPMWkpuap5KFMKmGsqwMFICb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe when the operation is invoked and the context in which it is
invoked, matching the description already added for vm_op->close().

While we're here, update all outdated references to an 'area' field for
VMAs to the more consistent 'vma'.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 15 ++++++++++-----
 tools/testing/vma/include/dup.h | 15 ++++++++++-----
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1e63b3a44a47..da94edb287cd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -766,15 +766,20 @@ struct vm_uffd_ops;
  * to the functions called when a no-page or a wp-page exception occurs.
  */
 struct vm_operations_struct {
-	void (*open)(struct vm_area_struct * area);
+	/**
+	 * @open: Called when a VMA is remapped, split or forked. Not called
+	 * upon first mapping a VMA.
+	 * Context: User context.  May sleep.  Caller holds mmap_lock.
+	 */
+	void (*open)(struct vm_area_struct *vma);
 	/**
 	 * @close: Called when the VMA is being removed from the MM.
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
 	 */
-	void (*close)(struct vm_area_struct * area);
+	void (*close)(struct vm_area_struct *vma);
 	/* Called any time before splitting to check if it's allowed */
-	int (*may_split)(struct vm_area_struct *area, unsigned long addr);
-	int (*mremap)(struct vm_area_struct *area);
+	int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
+	int (*mremap)(struct vm_area_struct *vma);
 	/*
 	 * Called by mprotect() to make driver-specific permission
 	 * checks before mprotect() is finalised.   The VMA must not
@@ -786,7 +791,7 @@ struct vm_operations_struct {
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf, unsigned int order);
 	vm_fault_t (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
-	unsigned long (*pagesize)(struct vm_area_struct * area);
+	unsigned long (*pagesize)(struct vm_area_struct *vma);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 9eada1e0949c..8ae525ed1738 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -632,15 +632,20 @@ struct vm_area_struct {
 } __randomize_layout;
 
 struct vm_operations_struct {
-	void (*open)(struct vm_area_struct * area);
+	/**
+	 * @open: Called when a VMA is remapped, split or forked. Not called
+	 * upon first mapping a VMA.
+	 * Context: User context.  May sleep.  Caller holds mmap_lock.
+	 */
+	void (*open)(struct vm_area_struct *vma);
 	/**
 	 * @close: Called when the VMA is being removed from the MM.
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
 	 */
-	void (*close)(struct vm_area_struct * area);
+	void (*close)(struct vm_area_struct *vma);
 	/* Called any time before splitting to check if it's allowed */
-	int (*may_split)(struct vm_area_struct *area, unsigned long addr);
-	int (*mremap)(struct vm_area_struct *area);
+	int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
+	int (*mremap)(struct vm_area_struct *vma);
 	/*
 	 * Called by mprotect() to make driver-specific permission
 	 * checks before mprotect() is finalised.   The VMA must not
@@ -652,7 +657,7 @@ struct vm_operations_struct {
 	vm_fault_t (*huge_fault)(struct vm_fault *vmf, unsigned int order);
 	vm_fault_t (*map_pages)(struct vm_fault *vmf,
 			pgoff_t start_pgoff, pgoff_t end_pgoff);
-	unsigned long (*pagesize)(struct vm_area_struct * area);
+	unsigned long (*pagesize)(struct vm_area_struct *vma);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
-- 
2.53.0


