Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D2B106ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15FE36B00A1; Thu, 12 Mar 2026 16:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101386B00A3; Thu, 12 Mar 2026 16:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBDE56B00A4; Thu, 12 Mar 2026 16:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC6996B00A1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9875058A31
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:05 +0000 (UTC)
X-FDA: 84538547730.27.30C2EC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9FDC40002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r1EElmIn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQgMPAlrhenwmW0IMEa6IfJi4qKnT4RSlCWPR0H7+iY=;
	b=MuCifbyOku5/eIGQEPWWVZUqo7I4WNOhtTNeorYEJTpBHd/qHX85APyhP8FQJ4I/qdWRUs
	19NG4TwGM0bT5JnZ+cWBAWkyifIN5ozAYknJnGJ3VAJetJazkrB2sPS4hBx8KFBSDrwYvv
	T/DuMNURnvDK6fs+UOgruDIQWiIGw30=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r1EElmIn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347284; a=rsa-sha256;
	cv=none;
	b=tQ8U7n8sjX8pA7HAE3s1rilO1NnanJzzf1AfvWdwWF/TBhIPc/yQoec1gBtSZvGn6RfY6y
	rd+2TVL0CbJ7QG0w4vO+LbadTLPQcdfjzO3QnthodbBcyE9ahtvna1r/gmV6iBb/uBQbeY
	DCdd88MzddLER6rwZD3qV8fSE0+nMag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49E1661338;
	Thu, 12 Mar 2026 20:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC13C2BCB2;
	Thu, 12 Mar 2026 20:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347282;
	bh=CS7p54p5QUHRpJDXJbe9luiQlJvT4C0agtt6b43kDd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1EElmInywHolKPD30p3FD2s/FXtEKeagIM2wdtfTwKJLwIFTKfP01j+7+Q7abd99
	 9wsJZfSfCLQIvo1cAPawwjbA7JGssLBKza3tqtuaeg90FUVBmcq/rZXHn7h5HXC+/w
	 fnmXGEHJQON+ihg9JBsheOnn3H4IMhDLYtL0extYpgwykBFQTGXCyhcHrT3HO94wha
	 baMD+1po3KmjGyqWwPvgEVFmlLMyr8MibRADrQZtVt3/Ygb/l4ZhmJ/RJ42KXefdKo
	 PJMwyac6uLz6aDSgHupW4UdeTjJsZOvbfqs9gXSBgvx3jyYfZh8fAvwWku5DxAavX0
	 SppPa8RoTQ/Ow==
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
Subject: [PATCH 06/15] mm: add mmap_action_simple_ioremap()
Date: Thu, 12 Mar 2026 20:27:21 +0000
Message-ID: <461328bd1e62a2be79f4ae9a392c96f62ea35081.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9FDC40002
X-Stat-Signature: u9rrpk76msszed6p46yr79mpcn1zn68e
X-Rspam-User: 
X-HE-Tag: 1773347283-841259
X-HE-Meta: U2FsdGVkX1+/LW0vntzUTYCbF7Y+3hOuhFsOtqN94HkXjws5pJHdWLAVetyPG+QYo7btfEjzFHli7TkE3x+MlTI81EXjbtNhTfWcgUs7OaVenIDAeFi2XAGspLqk4Tzh1kwAGoLkSwC8xCCp7eQlQQsNPcod1ChSpsuEIE+VhaoxCE3OHfRPbfeUA8SVuFX2XnqSn3M1fjrcLYQd+qBCC2uQDZ0bgUsno2gC7ZiQxtVEYZ8oPQaPbAUSbrKEvWCDLXoK1Hb0cyrXy+MKL4fLChMVg0q8KuxvrRo9fJJVQYR2YNUnzAnsPCJ6X/AMt/YpM2pWnQSQ+iYi//LwzwBabpAgw3oj523fh7YR2+l5wzrXsQoy8tZER5Emmu5f71tp0c1rY5Ln/5ocMwNCPjUs2ZnBY0S7ovK6AYdcSwuBrbowug56JCEmY8vP48KHBPHvJZ8HRRWb2S2bBGxHsPZfMVcz1cUuSd+h7tHDFl2H4T/wTnRRFEVphddl1IO1x0aCAOYwSIVIhikS7MoewiWvlpp/iYT7jlTAhXeuJMliQ+RbMVoMLWI2HKhXUzEej2NxzKIY3NYqaCJjpW2Djg1tUhpGXUIRnypFf/AOhbNAinljGp59FwCthxGa1CiOZfVZG02hqVEg/tx5FHGSP3/17/maGEAZl5bMfej+gAQqGWR4OelYpMekOlnknAFLHXkOx6O5WulM7QKE6PY4W2+2ddHa1FsTzIXpSkNGCvynOmAUW1SJ3BgorwWBk5GG11Pt02zBss1ihgbe4W5i8m6f2Eh09DwDlBoEKpm+SJq/WfRLtNkPcImJe8hfzme3IjDoIT5OIvLbzUv4KIPigCiuB14F8iMRvtxK8bnIIVeWJfZRsFPzWO+YBQeKFVLPSlOaT89Gsn8eAjq1dAcK1KaaEd9zRUOTEUhV0Jif+EzKpkRYJeyOKCSQ/olCJSsB7ERDNQ7v4CtFv8GoiVWG38M
 mQKb8Se5
 4clsfCnVX76FchcWFuu60+55OOTx2+T4WMvr2yOm2FEkaOdfrZEKHtI6A+HexOSN9wTfMB+lj9S1yq1q6o/Lhj+NDdvFZVUxSl9plZ/7lS0H9r3xeSieY8Jsh025xmcqgAny7+ESDfxAlNE1Vbrp+pHHlKjEiplEaQ5YJIYQVqQPgRpzdlAKm5R9KYOmdqVyO/ZUdrSvBsBrGk4jV8ssl+WyfCc037aOvPzk4EMM/CrenSLtOm/w5IVrTGFuM5hZT7q1N7YFun2g4Kf96D2g/hoAScuSgFHF3Bry/LzE7xGt9TS3VaAhZtdiMhtytf6TXhfUb2MyNiwR9yAJhd/MwG9IV/otu0OXrx/ahe2ZZj/kRseUFRKZhi8HHMPC31xRMTv12
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently drivers use vm_iomap_memory() as a simple helper function for I/O
remapping memory over a range starting at a specified physical address over
a specified length.

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

We update the mmap_prepare documentation to describe this mode.

Finally, we update the VMA tests to reflect this change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 Documentation/filesystems/mmap_prepare.rst |  2 +
 include/linux/mm.h                         | 24 +++++-
 include/linux/mm_types.h                   |  6 +-
 mm/internal.h                              |  3 +
 mm/memory.c                                | 87 +++++++++++++++-------
 mm/util.c                                  | 12 +++
 tools/testing/vma/include/dup.h            |  6 +-
 7 files changed, 112 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/filesystems/mmap_prepare.rst
index 76908200f3a1..d21406848bca 100644
--- a/Documentation/filesystems/mmap_prepare.rst
+++ b/Documentation/filesystems/mmap_prepare.rst
@@ -126,6 +126,8 @@ pointer. These are:
 
 * `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, only remaps
   the entire mapping from `start_pfn` onward.
+* `mmap_action_simple_ioremap()` - Sets up an I/O remap from a specified
+  physical address and over a specified length.
 
 **NOTE:** The 'action' field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7333d5db1221..88f42faeb377 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4133,11 +4133,33 @@ static inline void mmap_action_ioremap(struct vm_area_desc *desc,
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
 int mmap_action_prepare(struct vm_area_desc *desc,
 			struct mmap_action *action);
 int mmap_action_complete(struct vm_area_struct *vma,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3944b51ebac6..1c94db0fcfb4 100644
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
index f0f2cf1caa36..2509fd952f4c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1789,6 +1789,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc,
 			    struct mmap_action *action);
 int remap_pfn_range_complete(struct vm_area_struct *vma,
 			     struct mmap_action *action);
+int simple_ioremap_prepare(struct vm_area_desc *desc,
+			   struct mmap_action *action);
+/* No simple_ioremap_complete, is ultimately handled by remap complete. */
 
 static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc,
 					     struct mmap_action *action)
diff --git a/mm/memory.c b/mm/memory.c
index 364fa8a45360..351cc917b7aa 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3170,6 +3170,59 @@ int remap_pfn_range_complete(struct vm_area_struct *vma,
 	return do_remap_pfn_range(vma, start, pfn, size, prot);
 }
 
+static int __simple_ioremap_prep(unsigned long vm_start, unsigned long vm_end,
+				 pgoff_t vm_pgoff, phys_addr_t start_phys,
+				 unsigned long size, unsigned long *pfnp)
+{
+	const unsigned long vm_len = vm_end - vm_start;
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
+int simple_ioremap_prepare(struct vm_area_desc *desc,
+			   struct mmap_action *action)
+{
+	const phys_addr_t start = action->simple_ioremap.start_phys_addr;
+	const unsigned long size = action->simple_ioremap.size;
+	unsigned long pfn;
+	int err;
+
+	err = __simple_ioremap_prep(desc->start, desc->end, desc->pgoff,
+				    start, size, &pfn);
+	if (err)
+		return err;
+
+	/* The I/O remap logic does the heavy lifting. */
+	mmap_action_ioremap(desc, desc->start, pfn, vma_desc_size(desc));
+	return mmap_action_prepare(desc, &desc->action);
+}
+
 /**
  * vm_iomap_memory - remap memory to userspace
  * @vma: user vma to map to
@@ -3187,32 +3240,16 @@ int remap_pfn_range_complete(struct vm_area_struct *vma,
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
+	err = __simple_ioremap_prep(vm_start, vm_end, vma->vm_pgoff, start,
+				    len, &pfn);
+	if (err)
+		return err;
 
 	/* Ok, let it rip */
 	return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
diff --git a/mm/util.c b/mm/util.c
index 2b0ed54008d6..3205bb9ab5d2 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1394,6 +1394,8 @@ int mmap_action_prepare(struct vm_area_desc *desc,
 		return remap_pfn_range_prepare(desc, action);
 	case MMAP_IO_REMAP_PFN:
 		return io_remap_pfn_range_prepare(desc, action);
+	case MMAP_SIMPLE_IO_REMAP:
+		return simple_ioremap_prepare(desc, action);
 	}
 }
 EXPORT_SYMBOL(mmap_action_prepare);
@@ -1422,6 +1424,14 @@ int mmap_action_complete(struct vm_area_struct *vma,
 	case MMAP_IO_REMAP_PFN:
 		err = io_remap_pfn_range_complete(vma, action);
 		break;
+	case MMAP_SIMPLE_IO_REMAP:
+		/*
+		 * The simple I/O remap should have been delegated to an I/O
+		 * remap.
+		 */
+		WARN_ON_ONCE(1);
+		err = -EINVAL;
+		break;
 	}
 
 	return mmap_action_finish(vma, action, err);
@@ -1436,6 +1446,7 @@ int mmap_action_prepare(struct vm_area_desc *desc,
 		break;
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
+	case MMAP_SIMPLE_IO_REMAP:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1454,6 +1465,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		break;
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
+	case MMAP_SIMPLE_IO_REMAP:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 47d8db809f31..f95c4b8af03c 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -424,6 +424,7 @@ enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
 	MMAP_REMAP_PFN,		/* Remap PFN range. */
 	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
+	MMAP_SIMPLE_IO_REMAP,	/* I/O remap with guardrails. */
 };
 
 /*
@@ -432,13 +433,16 @@ enum mmap_action_type {
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
+			phys_addr_t start;
+			unsigned long len;
+		} simple_ioremap;
 	};
 	enum mmap_action_type type;
 
-- 
2.53.0


