Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206FE109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5876B0564; Thu, 19 Mar 2026 14:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FA36B0565; Thu, 19 Mar 2026 14:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700446B0567; Thu, 19 Mar 2026 14:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8786B0564
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3738816071B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:05 +0000 (UTC)
X-FDA: 84563636850.25.2645796
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 82335140015
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PUlhN8ha;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QN8ahiwQ0hLCc5fsVsj1ZvS6VAuKgKBxeV8x9I2ZDmE=;
	b=z9Jam9xFRvzaeu0JtFs0A0gGd6rl3bKLuqfipklBg57rJEmmf8snPnQzyaGLWRyq7VZ6nU
	uWW3v+HWnqNO1ahR7AqXeoQ5dow2p9KXofRbTdC3Zltw/VFr/p3xMaFJ0W1yQRmDzo5e6y
	yK4T8GG0kbca3+1QFA2iRINSksiNQrk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PUlhN8ha;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944643; a=rsa-sha256;
	cv=none;
	b=oeH/sAaAc15D6yyTwYWzJ9DtXrHo00xVvRgla5iPmtTpFAAQaGfmsY5rzPKI2lZD/s6kEs
	qZZsPef2v4tSWXhN3wrpwg9cgYlDqR9n4CQvzHR+g7ONG92pNsI87+Hjecl9OaLy5OAKhs
	SyHM4Yrypc9HGw/+5b4NMzjMSLC4AFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB10C600AD;
	Thu, 19 Mar 2026 18:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10260C19424;
	Thu, 19 Mar 2026 18:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944642;
	bh=6Gs389cDcfbWp+CxLW+X4AJWAHdnJe2WbDq0Ac8c1Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUlhN8haks8iHpDvH0wIqg5gSdCrrEldNyOlgD9TsNyj0dXbYG6fnWoWpEQUFWx5q
	 rTg1zx8L0sjbLEazEVdBi75GgyRFBkBC/PQzEl0CH9VAX0X/HeLOi28lekyh4tHlHL
	 yuuNnNAEv1380wGAIGx5hEKAO+j9nXu9ijB5DcWoplNfM+EvpT/cTrZb222pK+KhBD
	 sH7f+F/tco8dLn58XHzoh2T+tXJPX17exc73Ql4kyWYH7IKG89vuFHwbo1UQdXVEmk
	 22QXHLGub2U1S3Qa+c31qYqQwJohwzKf9NScIGmL9qFhYUaRju6YRw+2gcVSMSbXqp
	 tHS2OmWhECtEw==
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
Subject: [PATCH v3 06/16] mm: add mmap_action_simple_ioremap()
Date: Thu, 19 Mar 2026 18:23:30 +0000
Message-ID: <cd8492e65adc48ab75596293c821efd21fea1283.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 82335140015
X-Stat-Signature: mxuoufj364w1f9wx7egyrpsu3oj5ut18
X-Rspam-User: 
X-HE-Tag: 1773944643-54534
X-HE-Meta: U2FsdGVkX1/IlHxpFq6JIU2HTaSVH3TW6y1HfbQkBbJObdzvOq3orNvUmOAy1Au3ETBuft+ork5tP2NdXaqq/M/AtAk83a0dvdcFA8eMqOHHUAK84n4Lcvrx4nYnNEx+0QqZF6i6Pp0QT3tffvVViVAnjuQ6RRECbaBkaIxe+PT3IEegmQ37ytc2g90252t+u2D38yp42njc5YFpRiQNY+ooZ9BT+KzowQTVypNkhcHuIEhG3mLotnlx4ijWbMqCj6joJNx5WjRZjVak6/E2xTF5TAlPiLvUBv9GsxcwR61VS9qkigqU06U6CP0Lk4yfCFxyvWPguRDXv0CP8oF5KSZGMvk6zJpQdQoaNe16+GEEoIqnXOKoMMCbrG04xejAX72dxA0pocPFfPKbu1SptPXDSr4GN9OEFojvuHRR/kl0nXPUJKf5htg3ew7JbRvhjK+G4lbtfSQ8HQKlnbP6MvYwzexj5csrEowv06WH0nfkjOJZzHhq4hVqLGPsBeyQcHGhEt2b8aUV6SmnTpOi8KsjFMLVxJjcYZS/BCtsE9fDDYVA5LRfu4YOo0uOzRTxnMV2d2Gadx+1smWKXdy4BiUJ8Hb+HI8kZNCzxqpcYq/SFe359oPGO7eDP6PcSGhtfCvrIa/Nq+RunC4SIRhb8zy+W+i1UxKaZtsz/wpBA6zawwOyBzOcuhGfzkdNgjZsM6Ox5p9uLu+PzwqI/gXI3/a3oLdAYFE62Sxxa+DJWT+Ix2M4luKpdQSTQRK+SPG+u2h1B0gO87zbDQRajKM2ojY/a57O3seJB1ThY5qQyFbiu8Vr23f93sCzYDdw/ss1Z+FYyf4iIBa/sPfmdKLrILM4zfnOS0qusiQ0VH+t/uEgfFxx5xE/ezkLUKoI8B15/cWfiv8k9IBpuS9H8S1jQy6ZA03X13bbNMuEe2K+NV+G9lI5nTlXcU5NNjGIF5725F3KrZU0AB1acEQYcuR
 ZvUUCcj3
 RFrZTc4PzjZSMi+d48qKNF2qhg1mSgAqs1PO/otpfmlp1pJ7tVloqnYkgod1DHUJ0e+cu5sDhhaCLhXtyTRxwuwc/okobkZyVm35L5AZQsHTGNAUFUNcX8QG0qFtDfAiRMi8YBmGh4jNGYMx8ie3T7nKfE3fg14O7JBawcbXjfERcKDWKi3hMbgu3pt4B0duHktIX1MZchjSgiAZMfLhCp/VaEsrBQOsHSNN3WFN1ARIDQiS34zDxKxn9sG0l4qst7YFp81WHkTAvMSMVl6RDOVc3LMDQaUO3pmtcteVJMs89c5Gx1At24egMYyLkuDOToTLVclpyAqbVAASOEd4v2UR/Y9npRujwH1fD52oo9q1eCVGGykfVtVE60RhUNkRjzItI1Lg4mFz/KCSasT3ekEpeBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently drivers use vm_iomap_memory() as a simple helper function for
I/O remapping memory over a range starting at a specified physical address
over a specified length.

In order to utilise this from mmap_prepare, separate out the core logic
into __simple_ioremap_prep(), update vm_iomap_memory() to use it, and add
simple_ioremap_prepare() to do the same with a VMA descriptor object.

We also add MMAP_SIMPLE_IO_REMAP and relevant fields to the struct
mmap_action type to permit this operation also.

We use mmap_action_ioremap() to set up the actual I/O remap operation once
we have checked and figured out the parameters, which makes
simple_ioremap_prepare() easy to implement.

We then add mmap_action_simple_ioremap() to allow drivers to make use of
this mode.

We update the mmap_prepare documentation to describe this mode.  Finally,
we update the VMA tests to reflect this change.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst |  3 +
 include/linux/mm.h                         | 24 +++++-
 include/linux/mm_types.h                   |  6 +-
 mm/internal.h                              |  1 +
 mm/memory.c                                | 85 +++++++++++++++-------
 mm/util.c                                  |  5 ++
 tools/testing/vma/include/dup.h            |  6 +-
 7 files changed, 102 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 20db474915da..be76ae475b9c 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -153,5 +153,8 @@ pointer. These are:
 * mmap_action_ioremap_full() - Same as mmap_action_ioremap(), only remaps
   the entire mapping from ``start_pfn`` onward.
 
+* mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
+  physical address and over a specified length.
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 68dee1101313..ef2e4dccfe8e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4337,11 +4337,33 @@ static inline void mmap_action_ioremap(struct vm_area_desc *desc,
  * @start_pfn: The first PFN in the range to remap.
  */
 static inline void mmap_action_ioremap_full(struct vm_area_desc *desc,
-					  unsigned long start_pfn)
+					    unsigned long start_pfn)
 {
 	mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(desc));
 }
 
+/**
+ * mmap_action_simple_ioremap - helper for mmap_prepare hook to specify that the
+ * physical range in [start_phys_addr, start_phys_addr + size) should be I/O
+ * remapped.
+ * @desc: The VMA descriptor for the VMA requiring remap.
+ * @start_phys_addr: Start of the physical memory to be mapped.
+ * @size: Size of the area to map.
+ *
+ * NOTE: Some drivers might want to tweak desc->page_prot for purposes of
+ * write-combine or similar.
+ */
+static inline void mmap_action_simple_ioremap(struct vm_area_desc *desc,
+					      phys_addr_t start_phys_addr,
+					      unsigned long size)
+{
+	struct mmap_action *action = &desc->action;
+
+	action->simple_ioremap.start_phys_addr = start_phys_addr;
+	action->simple_ioremap.size = size;
+	action->type = MMAP_SIMPLE_IO_REMAP;
+}
+
 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
 			 struct mmap_action *action,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 4a229cc0a06b..50685cf29792 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -814,6 +814,7 @@ enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
 	MMAP_REMAP_PFN,		/* Remap PFN range. */
 	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
 };
 
 /*
@@ -822,13 +823,16 @@ enum mmap_action_type {
  */
 struct mmap_action {
 	union {
-		/* Remap range. */
 		struct {
 			unsigned long start;
 			unsigned long start_pfn;
 			unsigned long size;
 			pgprot_t pgprot;
 		} remap;
+		struct {
+			phys_addr_t start_phys_addr;
+			unsigned long size;
+		} simple_ioremap;
 	};
 	enum mmap_action_type type;
 
diff --git a/mm/internal.h b/mm/internal.h
index e0f554178143..2aa04d87ac10 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1804,6 +1804,7 @@ int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 int remap_pfn_range_prepare(struct vm_area_desc *desc);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
+int simple_ioremap_prepare(struct vm_area_desc *desc);
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 9dec67a18116..b3bcc21af20a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3170,6 +3170,58 @@ int remap_pfn_range_complete(struct vm_area_struct *vma,
 	return do_remap_pfn_range(vma, start, pfn, size, prot);
 }
 
+static int __simple_ioremap_prep(unsigned long vm_len, pgoff_t vm_pgoff,
+				 phys_addr_t start_phys, unsigned long size,
+				 unsigned long *pfnp)
+{
+	unsigned long pfn, pages;
+
+	/* Check that the physical memory area passed in looks valid */
+	if (start_phys + size < start_phys)
+		return -EINVAL;
+	/*
+	 * You *really* shouldn't map things that aren't page-aligned,
+	 * but we've historically allowed it because IO memory might
+	 * just have smaller alignment.
+	 */
+	size += start_phys & ~PAGE_MASK;
+	pfn = start_phys >> PAGE_SHIFT;
+	pages = (size + ~PAGE_MASK) >> PAGE_SHIFT;
+	if (pfn + pages < pfn)
+		return -EINVAL;
+
+	/* We start the mapping 'vm_pgoff' pages into the area */
+	if (vm_pgoff > pages)
+		return -EINVAL;
+	pfn += vm_pgoff;
+	pages -= vm_pgoff;
+
+	/* Can we fit all of the mapping? */
+	if ((vm_len >> PAGE_SHIFT) > pages)
+		return -EINVAL;
+
+	*pfnp = pfn;
+	return 0;
+}
+
+int simple_ioremap_prepare(struct vm_area_desc *desc)
+{
+	struct mmap_action *action = &desc->action;
+	const phys_addr_t start = action->simple_ioremap.start_phys_addr;
+	const unsigned long size = action->simple_ioremap.size;
+	unsigned long pfn;
+	int err;
+
+	err = __simple_ioremap_prep(vma_desc_size(desc), desc->pgoff,
+				    start, size, &pfn);
+	if (err)
+		return err;
+
+	/* The I/O remap logic does the heavy lifting. */
+	mmap_action_ioremap_full(desc, pfn);
+	return io_remap_pfn_range_prepare(desc);
+}
+
 /**
  * vm_iomap_memory - remap memory to userspace
  * @vma: user vma to map to
@@ -3187,32 +3239,15 @@ int remap_pfn_range_complete(struct vm_area_struct *vma,
  */
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len)
 {
-	unsigned long vm_len, pfn, pages;
-
-	/* Check that the physical memory area passed in looks valid */
-	if (start + len < start)
-		return -EINVAL;
-	/*
-	 * You *really* shouldn't map things that aren't page-aligned,
-	 * but we've historically allowed it because IO memory might
-	 * just have smaller alignment.
-	 */
-	len += start & ~PAGE_MASK;
-	pfn = start >> PAGE_SHIFT;
-	pages = (len + ~PAGE_MASK) >> PAGE_SHIFT;
-	if (pfn + pages < pfn)
-		return -EINVAL;
-
-	/* We start the mapping 'vm_pgoff' pages into the area */
-	if (vma->vm_pgoff > pages)
-		return -EINVAL;
-	pfn += vma->vm_pgoff;
-	pages -= vma->vm_pgoff;
+	const unsigned long vm_start = vma->vm_start;
+	const unsigned long vm_end = vma->vm_end;
+	const unsigned long vm_len = vm_end - vm_start;
+	unsigned long pfn;
+	int err;
 
-	/* Can we fit all of the mapping? */
-	vm_len = vma->vm_end - vma->vm_start;
-	if (vm_len >> PAGE_SHIFT > pages)
-		return -EINVAL;
+	err = __simple_ioremap_prep(vm_len, vma->vm_pgoff, start, len, &pfn);
+	if (err)
+		return err;
 
 	/* Ok, let it rip */
 	return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
diff --git a/mm/util.c b/mm/util.c
index fc1bd8a8f3ea..879ba62b5f0c 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1392,6 +1392,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return remap_pfn_range_prepare(desc);
 	case MMAP_IO_REMAP_PFN:
 		return io_remap_pfn_range_prepare(desc);
+	case MMAP_SIMPLE_IO_REMAP:
+		return simple_ioremap_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1423,6 +1425,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		err = remap_pfn_range_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
+	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
 		WARN_ON_ONCE(1);
 		err = -EINVAL;
@@ -1441,6 +1444,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		break;
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
+	case MMAP_SIMPLE_IO_REMAP:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1460,6 +1464,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		break;
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
+	case MMAP_SIMPLE_IO_REMAP:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index aa34966cbc62..1b86c34e1158 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -453,6 +453,7 @@ enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
 	MMAP_REMAP_PFN,		/* Remap PFN range. */
 	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
 };
 
 /*
@@ -461,13 +462,16 @@ enum mmap_action_type {
  */
 struct mmap_action {
 	union {
-		/* Remap range. */
 		struct {
 			unsigned long start;
 			unsigned long start_pfn;
 			unsigned long size;
 			pgprot_t pgprot;
 		} remap;
+		struct {
+			phys_addr_t start_phys_addr;
+			unsigned long size;
+		} simple_ioremap;
 	};
 	enum mmap_action_type type;
 
-- 
2.53.0


