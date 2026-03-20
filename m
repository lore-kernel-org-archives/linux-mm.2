Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C20471099B4F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379D46B0131; Fri, 20 Mar 2026 18:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350D76B0133; Fri, 20 Mar 2026 18:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268036B0134; Fri, 20 Mar 2026 18:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1597E6B0131
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D369F8B645
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:39 +0000 (UTC)
X-FDA: 84567912198.15.9B77C1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B30B180007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BdAFfXV7;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qHMEyxzRoLoMkb5elsnGkbiJSSqyAQrjiZydfcDh5qI=;
	b=jhQNmlYkU81NtsBOOB221s+pweFAsrbUCAPMbvwLcnraqvAQIbjKN/Dh0eQ+9twL1fzMfo
	dsGEJGmiIv1VRCIDNy5z0muq9BPmD25qKC8Lu5jIKPCVCpWfdoWgZl3J/BGcu1C5t5wjq6
	s6sYCx1SO6G2c2ks+PiVakakUp0aFR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046438; a=rsa-sha256;
	cv=none;
	b=JGQWXZ8TEB04+PLak1SnhTccfmpO2YxJgzSkC7z6f0kUtAHqud74AFN+3bJfd326pdoHGg
	G8DWfGJcSukol87CIV4KkH+1eWxsPnNPVxr+44AtZfpXf+JfWxaye9v01L0AX7N92zpn6Z
	IJMleCLsf0RjVPYrSsK8R8JOg7fwNQw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BdAFfXV7;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A72A06111B;
	Fri, 20 Mar 2026 22:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF97C2BCB1;
	Fri, 20 Mar 2026 22:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046437;
	bh=WLjRSxKdtoiEWEPvion/ECuNEhc+IOVRePndNVfMfzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdAFfXV734Lj8dQR7IZAo5MEH25Ec75BNmDza71k5A/MGmWJWabwF3XnhqA9JdZmL
	 pOc0Ti2DICfMKIf4GoXwUzrY/W8YjU+pP0Ph/hxR9g6K1e9k4RmBNj5nKu7ys6+jll
	 SOvAGGv5SD2fAGANGZGhgb2SNUO+ZzEE6IqLnppAIKCRrwLjRt2uh55XKVDgH9KU95
	 86DYh+3A3N7xe7RzjTLmiAZJKI1xgWZWYS56m1KgBdP1U2CDFwPsm+6wxZ+uprkjnn
	 huAzvSWqvNA8tRmYvhT4E4YZcCNODugdKpcX/GAopZqsPpZj3mDlIsm+KAbikdLis8
	 H1jDU6YIHHBDA==
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
Subject: [PATCH v4 11/21] mm: add mmap_action_simple_ioremap()
Date: Fri, 20 Mar 2026 22:39:37 +0000
Message-ID: <a08ef1c4542202684da63bb37f459d5dbbeddd91.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5aw7gwj4wu5f8xi6wrk7bbi1f8xs518r
X-Rspamd-Queue-Id: 4B30B180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1774046438-649931
X-HE-Meta: U2FsdGVkX18cARSh/XdjOGtls436KqWZIixKDmEcmuPuhxyMzwOdVYU9fhFqkmXRnYBSdapkEQg08DhSV2I+xLCxHTxGag0KbsIMldEL0hv4BEOeiraWqU7rbAmikfQcVK7sCvQl3ZWa39yVpzwf0LsBmfYirD89t+2iSmI4dbsvVZyf55Nsjv9+WizMfUbMcW4nKh0UAyCFYL99w1lTmquzNVLdStj+IfayWRiZkg1JMQ+Rordcss1k3NqX02bGWE55wXwe5EL7Age4Dk9sGjdFv57fUFT+dG8Kq2NhefQQzckvCMhGofiOTKTZP0hrQuugUyBTdQ4wi/Fgm0tqxerXHol+0m2wlcycugW2arUrVGnuSlfP03BNb2AgpAvKhmLhD2jD+OXauBZ1yFgZgXAM5l8iEFgmProam2pfq3scd+pHfhNJ1pOAiWYbvCf+G52kPfvqroRSyoVX+4KtwyiZLR9MDDTiNUDA7TXaRQsfZ2oKHttXnsr6619RMAmQUr8NZdJ/7APHdRwGFqE7KUkYTal0+MhJleqOsQautmOd1BrkYdM7ysyuyw/5kp2Ua3w5NS5s1zty9DmiRshaBFgIvea1IUsn7xqSDuI+kg6fKt6n6e6Qodt+kMp0c3EDALW5tR1Sjo1jGaYSCGPvp0ZjnFlb3pctSSfrIt8g1JwhUeu6okzpgJbpFK2LYsJHHSUb3I12+lIT2Bzi/1OydFRmIkKq9mTYX4nzDiS8kxFgkYkZ8hSETfyr0sHFQrRdDaqlstthK7xvlCfdlhNseB1ZAI8C8ZA+61nieimwBDun5hE+y6aIPnT37ftR3xTFQeWvsAeMxsZRCJp5mtNA1YuQJPA30+aVFFoemGxg5kRXsecFCpKS2hQ27R3M4UdpVV1qH6u3i0qdFHZVBhBoK3rN6oJFfZsRezDqKjVDwG2SD7cY0vp1NeNYTJB27qwPp3GMG25QfEYA2fjgu9W
 EtNJHtQJ
 LTbS/E9a4tSM7EpbCon4El0Iknce01APaxYNggEoZ/KpwS36fxXcG04MDEm3gagxucscDVhX8XVxqUpB+Q8zCrylBQ/TSnfFixSUNFOPcSzbSntseW/+Ylc2G024Bca23cYoduchO3Tj06h7iXgDcDgmdj5LulHvePiRfqXevKPRZyrXFkKYWdqycweuA2vgUsmngp0VcVwueNvjmz6UTobOgESKyb1EsG67rSl7F95OzXwYVvR1YvH1vNo46rvGxWtDjJ8ZGoOaTW2Te7jeDJAlMKcgDV8c/zOFoQ9760vhcBCzVO34ACsmG4BQUu1+oMXeC3aOn5VtNpFMSoV9/W/XfbwuyTUrvcZN7AncnlB7oEMU0AuXlijs3x5Ot3+LUG91H3C0mX9/o8kd3Ox2yj1ztrFW5cnFbnEIP
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
index f14b35ee11d5..14bb057be564 100644
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
index ad1b8c3c0cfd..df8fa6e6402b 100644
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
 			 struct mmap_action *action);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 16d31045e26e..174286f9ecf0 100644
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
index 760fbff9c430..46cc1a695a0e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1796,6 +1796,7 @@ int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
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
index df95ae41e09b..a19f062b84dc 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1393,6 +1393,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		return remap_pfn_range_prepare(desc);
 	case MMAP_IO_REMAP_PFN:
 		return io_remap_pfn_range_prepare(desc);
+	case MMAP_SIMPLE_IO_REMAP:
+		return simple_ioremap_prepare(desc);
 	}
 
 	WARN_ON_ONCE(1);
@@ -1421,6 +1423,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		err = remap_pfn_range_complete(vma, action);
 		break;
 	case MMAP_IO_REMAP_PFN:
+	case MMAP_SIMPLE_IO_REMAP:
 		/* Should have been delegated. */
 		WARN_ON_ONCE(1);
 		err = -EINVAL;
@@ -1438,6 +1441,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 		break;
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
+	case MMAP_SIMPLE_IO_REMAP:
 		WARN_ON_ONCE(1); /* nommu cannot handle these. */
 		break;
 	}
@@ -1456,6 +1460,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		break;
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
+	case MMAP_SIMPLE_IO_REMAP:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index b4b12fc742c1..a0c2379bd42b 100644
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


