Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0421099B4C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54CF16B011B; Fri, 20 Mar 2026 18:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEB36B011F; Fri, 20 Mar 2026 18:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413BB6B0121; Fri, 20 Mar 2026 18:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 33A566B011B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B78BAB8F86
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:17 +0000 (UTC)
X-FDA: 84567911274.09.7A57961
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 065A3C0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dA9XZnpB;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oX/9l7GBuPvJMchf5XKThVYHe+i8ZfivN6ck87129sE=;
	b=TLFcU3e3ZpNpxL/6j5BjLw1kgynTvzefUwzvFMq+5LfWQZ0nm8j9f4gLetKSKOhMlzXWUQ
	Hgl3DdyrTem2/uTiEI2tVPh5inEY+2a6LLALq6S16x+kUb/eekzwrtzyUtYiPvYCJsQWJf
	VXFHOboylk62eNb6btHKrsM4NCWTp2s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046416; a=rsa-sha256;
	cv=none;
	b=awxQQcB5k8vCxjhdgX3onVhizvkT+LZlSgH/Z3csgTF/J0e2BFwj8gkjEhA2iYQk87rZM5
	o3GSIEHVybyKfOiw9xg67NI6ibA17bFcChK5i6ns5yK3QMziPw6fa0iW/Tbtgr2/8eCa/n
	I1R0VPBTtrUpVh8AUL1yQ69jeh8OTng=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dA9XZnpB;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A6934454F;
	Fri, 20 Mar 2026 22:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40016C2BC87;
	Fri, 20 Mar 2026 22:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046414;
	bh=KGyUqER+1KMemEPNwb05yxF1iWQpDSjowRQtc3QKLCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dA9XZnpBcEJcM42a6vjSFyPET/ma7T86PWJqOQGw7Jyg+kRd+83nlRoqc0O7v96SK
	 YvRsSOeFduElA2i9LlLPBrveszNKsV/wEHNPDsjTRuTRE3cLy3G5NskTN8/H53cVFn
	 3Ywq6aUqH5SvMgIF0ep7yj4Snw0UswftBXcYfPQrdKctrim6TYzDgn/Qtd4p5XDqAn
	 ksYAYdoClblLQQ4HNNMt+rmiwkQjH309dGenzWTjBN0noIg1HDWbSeRrCCp0QY7i1+
	 Q3/R3MYNQe23Nn9QayxJ05lxx2gjnsKg3UDM1l+cacq1VVEFTuAkz0zBxU0O822v1t
	 h+KOY6lq/0WEQ==
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
Subject: [PATCH v4 03/21] mm: document vm_operations_struct->open the same as close()
Date: Fri, 20 Mar 2026 22:39:29 +0000
Message-ID: <7d0ca833c12014320f0fa00f816f95e6e10076f2.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1p4by98otgb8bsmkfd18n4z4er959cqf
X-Rspamd-Queue-Id: 065A3C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1774046415-396988
X-HE-Meta: U2FsdGVkX1/qA2r9hAtFOBtWLtjC1kdODrnVBOyDiCIPeP43wkV6waFNBdm23yjfLC23MediUi3m0KWQ042/D6Qp+8f2Kf09SbMJjeyMV4OeTvrtuIX2PM7EIpR2G5nmS8tQr34qX1/eaFnbUNy1hmMJXAlnrXq+Gzjy+alAqU3N9sNM0S6J4ZEO0TfcJ3Q0kaT716um54kAK8OVZz4WH9Ohow7Fg2PVPBEQbIuqikkeDgQ0XPiqYTTuI9uAuAbChT+bzdKyL6T6+5+a8lF8gDLF9jj2L9guZXzvqLSI1C9MSKY/MLySuk4NePJA/Aug8FLk1ByPPyjBENdHikBej9Ftw6OoCWtsIP4ARs6VyWexx3FoffXmXoN7/HgcxlkeG68ziYktku5Es0zN6cTVFe7hUtLVbiyAEgznMErfYLVbaQJN/RzXtPa2FxdOueD7dKgJmateliWRVh4tEwhBtpPDIzBrIMxmbpnACM1MrCpswV7aKnZpCmTNeezpf8JrKHDV9V42xALGNFLh3Y4qL5SAT26qDXftdlQqGwX2cD8qcoEODtM74jB+L2Vmnc6O4tw5nb3WlIMhUQpNfVcocWbQV6RWNZhKUlnv7NLfg+xMNlTJ0JmeZq/Mai2ool6iHQSGtkCLG7dr0QH9VXot2AHr8Ul2qvRKGE3Jd74oNYlz3s9Yaj0bZc8OA0ClnM8FbyoeGYQM3tZroowuUKAAlAV4h7rP5zYbg3yZjySNvZpQBjods2Bb+HWmRcT4O4itF0ucGhrnUMzL1fFj9B5gwgW3BhQdCzFz7OgEytiKHf01VfIH9Q7bYbF8DoOlXw2cL/FpFl+RCQvFdNiJ/jJttqQK8qs9ZDr0VaVdZx1S5zaVvo1Cs1u+wWwrYrTkOyW/7tI+Pk81UlqfaWH2k4VfIfwSoH5W2Kvxvcz+gHH7ozEoY8JAwkLJaBUxsQifngjNUgnJFtaOUCQ4nJQdwwp
 LUoNuHq/
 KpSD782Lnwni8idTrzAyrUDliS4himO5g4u08nNsm7mmTj/1nodZuwbh1K1+7BwCsyhjJvLRDxEn8nUl9Co/w+SFBUQQUmljUeP6OgaLGLl0EHpNen3MIi2AuGDAYM+NKCZHeFv22Yj5/k02kGwgwi6mDfSuF+MTLuqXPCH2/i61DZ/LubQb/Tv2ky/9JEq1cZLNx3BOdXV6b9iTGEQjOhuNxnljsHF8dvNnIb8XyKLNvU2Xs6tGM5JIUt2Sf+hx/XZxzYXs2sC6+TF4seIdag6nfPu7OhqnufWvfFjXTQnrD7CSED28ze3N7u5AsWoWCRR2hAt5QNonBUcV1ueg7E5vPoocsqhRXIHQJ
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

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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
index 477a5be65dd2..26c6c3255a94 100644
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


