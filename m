Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412AA606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=hBUqDH9+
Received: by kanga.kvack.org (Postfix)
	id 85A916B05BD; Thu, 12 Nov 2026 07:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5136B05BE; Thu, 12 Nov 2026 07:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3046B05BF; Thu, 12 Nov 2026 07:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4694C6B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:56:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB0D9C031B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:56 +0000 (UTC)
X-FDA: 85426466832.13.6B5BDDB
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id 883EE180003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hBUqDH9+;
	spf=pass (imf24.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Gt83+fxMlROkzHsSkTZbFg0XGnf3ZdikmYRaQBMHvc=;
	b=bYvAYXVCZa8xS6YkCiWElsb3FJnUKf3wOyK8k42m9q7vZevfTNNJ97o9/mib/FtTprWJWn
	MKpEMb6RYba77uo/I6/C23ku1FW0ZtB6T/2Exh/1JF8apxjCkLFAbgrlut12vJEk6V/ipu
	dtHcwTi4EyIdro5YpQ9/Rgz3L9VIcUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488214;
	b=U5eiJ9QL60MxmxxQg96wNxforeVX4XR6Duu0KKCblTz0PCvmX5jteFr12jAze3GP+12me6
	tapnTJcdyISt0tNB2kqe55WbL5WPXX3qMWQBAqvBZgIKi8UhkJuVKetYdUdmOhMz3jVeYX
	bevNSxTgb+KDgOMXtt7DafuIjdiPlUA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hBUqDH9+;
	spf=pass (imf24.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794488214; x=1826024214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Gt83+fxMlROkzHsSkTZbFg0XGnf3ZdikmYRaQBMHvc=;
  b=hBUqDH9+nID4eRuEoKWRoYf7DmvwSOnRASi6Uj/7s5IpyNK73dDvtHJO
   K/q8rkH19n+M5XX1qzEQDa9OIKEgh/m3FLg94B0/sA1F1YWrhkhWr6hhN
   TjqLy5nsTJXDhtv4vuVhVr5uZq7TgmSyGAKZhKqS/wsnX2y//Vm8mYfsa
   BYfg9Pf0ptMPRi/yXmfYI4ONbu0nzn6HmFIwcv6H3HgSXMFx8IRYgwhOK
   drO+9h1KYrMXM7q3zaS1cUQvTyCBcVhZGC3vFSCc3Q1x1BnQLgMwDN4yS
   5BypKfmR4aT3yWYEClKmBuGuZMlTqZ+/Bpy3hiFAiyGXp5rpgQpJpG/+T
   g==;
X-CSE-ConnectionGUID: 1QyHUlQgTrakZbRh7HeLzg==
X-CSE-MsgGUID: yoSc2calRBWdh6F3k2s9/w==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33728090"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:56:52 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:31229]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id d063ba05-e049-4b16-a1e0-ffebd400aeab; Thu, 12 Nov 2026 12:56:52 +0000 (UTC)
X-Farcaster-Flow-ID: d063ba05-e049-4b16-a1e0-ffebd400aeab
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 12:56:52 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 12:56:49 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Eliav Farber <farbere@amazon.com>
Subject: [PATCH v2 3/4] mm/char-mem: implement huge_fault support for /dev/mem
Date: Thu, 12 Nov 2026 12:56:37 +0000
Message-ID: <20261112125638.12209-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112125638.12209-1-farbere@amazon.com>
References: <20261112125638.12209-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 883EE180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: i5qappqzd81xh84meyz93pdjbje1jrig
X-Rspam-User: 
X-HE-Tag: 1794488214-577098
X-HE-Meta: U2FsdGVkX19A0dSwGsSisZbzB6Jee9XRs/XwuP680bUFRUKlCTjGOj4AvEK7SfMaihC5NDaa/zOHRu82FNQMgIfQv1IKML+ld10ppYw/mSd1FUnxuIg1DhYcDi2KbbCcKh/uaiKG2A9BuiCdQZlo/6qqzw4mgFc/q2NFqmalzELtLF9Ap7VvZbwvRpTqPfqCy22vHtAAyBaU2qGIFh+cLeQ/qSsFMtu+zdlyjit391ZjFkFJ3mtaGGJt63m+1mNoSsGCq6nJSAtf8vSWU2NTMpLOY7QUQAF1b7LtJqPRzsK51t/K6QU/tuaEUjZI5FPExSdtDxRI/XtW2GDCKieiUrnS06KZLsmxiQSBMeqZDeTgKwvdz68RcbH/4UFb36HXXiSKS/sa9iHE8caQcP4AGP1jdERlxMvqyXvrFvPEeeUKcZKrb4aOJX44fswzEsZ/eCoUm9SB6bhcAJzVc7ZZlSUQ9DhHixfKRf964Ud0hKIGsNt6m2c+WoO13EPi5NI1UX/1/vtbl67T2zpxkOgOA2Wrq8NzXybWVMGhLCEePyVOIXXWoXWb6LjBNNnznSgHJPDXtjvs2DJl9d4qpY4DTNS5te3dleOO/uLrbhjGmW5CUWeVRK2lZRV+2f51YU+Kg0WzoWraWDUdeBbwkLU5WDhAqtsqDbOIzyHVmkP9bwEC9tho39yrMFaxzuMk6zLcu57k6126GtI2iikH5M73eZP4KsgMEklsq0PsXb2MIxpXrvSnMF8D6ak8dT91EcgpGhtJb52M3rk7Ez2BJZUF/f1HSAJcP1eRdr/fAIfwzJALHW8zJM87W0Ab3PjYHbpVjf5WTZ1efIXWUgoiBTjd6NmN0iucfyzkagzxj0/9AsCC0fveryRWs3tRF9zo3tIy8WXIQopI/E5dk0PcgjWlox/5faFR9PCt3mNCoLjHNOZqmYLY6stRQev1L+4aJTEtdgbEYf0z6WRr6qYViRG
 sfpUnTPv
 LwI+Ya63In5UqQZeGKnh9rbiFMUmgJ7I8irc9FMCoN30kDK3TOukocA2nUsB4BbsOC7Uw3j2hJ+qhHPaOxzfnworZYH+7zzlzUnajR2I1XeXbXUJVMeWDvjWb5Iu27IzaX1lFzarIVySREzfwqkb9ELIOxKKeu5HmijESlEOyDxX1FO8j9SCoVIpaWgVYICQU912LoPk12l/1YEGGSh8VVNwjX/G49BnDRwhTKZZe8E+eDlBU/yeKqc1jkYmYsOTaF1aQZFos/fj25f0MU8JWNPAgaDQ+dQlQi3AY4Prz6r5kkj1eOOyrVHYHW290lbNvmdeKfZ84jZMHuhZD+28BweeD8wwPY2xblnsa6BWMToFvOuHMXiUDOtkGRQoY50NFAqXNoTG9jpA44RmXCXqZFDHEHY94MABn4S+VWC7XALTd+xvuoNHRVRL50RQ/NYIed7VsveH8+8tduwuAoKhCpPgHd+mgjQo2Wybkl0CVDCxqM5OMyIPnxrC7AIbpgXJA6RTuCvQochOOAKBlmDC/4V3aMLG8Gp3SKdE/Gn3xM25ni2YCvxIqmcU7nbHHkWZCN3ThOUCb8Dvx4FCnEk8JjIFyI7Qwtv6Q6t7XXSM5MnawFqgpfytZ2RrF4VovZgqyS2/E7/EkJ/0aDbTzbmc+NpM3N/OIJQWmyLyPSep9ROo51PBAl1ozd17+dAidUwe3uLIBAIhQ0aJNfnUOGKyinVY/PjyOw8rRPxyVx0UdPbOWYeockqCefr7qm3lYkH8YXpYt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

/dev/mem is commonly used to map large physical regions (reserved
memory, device memory) into userspace. mmap_mem_prepare() maps the whole
range at mmap() time with 4K PTEs, however large and well aligned it is,
which costs many page-table entries and TLB misses.

Map non-COW mappings on fault instead, as vfio-pci does since commit
f9e54c3a2f5b ("vfio/pci: implement huge_fault support"): request
MMAP_PFN_TRACK rather than an eager remap, so the VMA is set up and its
memory type tracked as before, and add ->fault/->huge_fault handlers
that map the faulting window with vmf_insert_pfn_order(), using a PMD or
PUD where alignment allows.

COW mappings cannot be populated by vmf_insert_pfn*(), which BUG_ON()s
a COW VM_PFNMAP vma, so they stay eager and keep a vm_ops without
fault handlers. do_fault() then rechecks a pte it found cleared under
the page table lock, and refuses it with SIGBUS only once it is really
gone, as after revoke_iomem(); a PMD-aligned COW mapping is also not
reported as THP eligible in smaps.

The handler re-checks range_is_allowed(): with CONFIG_IO_STRICT_DEVMEM,
revoke_iomem() zaps a range once a driver claims it, and a fault must
not map it back in. With CONFIG_STRICT_DEVMEM this costs one
devmem_is_allowed() call per page of the faulting window.
Unlike the eager mapping, a revoke is not permanent: once the driver
releases the range, a fault repopulates the mapping, as a fresh mmap()
of it would.

Without CONFIG_IO_STRICT_DEVMEM the re-check still changes behaviour. A
driver can take an IORESOURCE_EXCLUSIVE region at any time, which makes
devmem_is_allowed() refuse those pages, and revoke_iomem() is a no-op
in that configuration. The eager mapping therefore kept serving them,
while a fault now returns SIGBUS for any page not already touched.

generic_access_phys() only follows present PTEs, so .access now faults
the page in first; otherwise remote access (ptrace, /proc/pid/mem) to an
untouched page would fail. A mapping that does not permit the fault,
PROT_NONE for example, keeps that gap: fixup_user_fault() refuses it,
where the eager mapping left a present PTE.

Validation at mmap() time is unchanged, except for the L1TF pfn check.
remap_pfn_range() rejected a disallowed pfn at mmap() time, which
error_override turned into -EAGAIN, so an unprivileged mmap(PROT_NONE)
of a pfn above l1tf_pfn_limit() failed. It now succeeds. Nothing fails
later instead: pfn_modify_allowed() only denies a prot that needs PTE
inversion, i.e. a non-present one, and no pte is installed for an
inaccessible vma.

vmf_insert_pfn() refuses the zero pfn, where remap_pfn_range() mapped
it, so a page of RAM that happens to be the zero page now SIGBUSes.
That needs /dev/mem access to RAM, i.e. a kernel without
CONFIG_STRICT_DEVMEM.

Without huge PFN mappings, or for small or unaligned mappings, the
range is populated one page per fault, paid only for pages that are
actually touched.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---
v2:
COW mappings get their own vm_operations_struct defining only .access,
instead of a COW test inside the fault handler, which was not enough:
installing ->fault at all skips do_fault()'s recheck of a pte cleared under
the page table lock. Corrected the L1TF claim in the commit message -
mmap(PROT_NONE) above l1tf_pfn_limit() now succeeds, and nothing fails
later - and documented what the fault-time range_is_allowed() re-check
changes without CONFIG_IO_STRICT_DEVMEM. Reported by sashiko-bot.

 mm/char-mem.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 104 insertions(+), 4 deletions(-)

diff --git a/mm/char-mem.c b/mm/char-mem.c
index c5761ddedbd7..99f02d6a8b07 100644
--- a/mm/char-mem.c
+++ b/mm/char-mem.c
@@ -318,9 +318,95 @@ static inline int private_mapping_ok(struct vm_area_desc *desc)
 }
 #endif
 
+#ifdef CONFIG_MMU
+/*
+ * Populate /dev/mem mappings on fault, using a PMD or PUD mapping where the
+ * architecture, the fault address and the pfn allow it.
+ */
+static vm_fault_t mmap_mem_huge_fault(struct vm_fault *vmf, unsigned int order)
+{
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long pfn;
+
+	/*
+	 * vm_pgoff is the base pfn of the mapping. vmf_pfn_order_ok() ignores
+	 * pfn if the window starts below vm_start.
+	 */
+	pfn = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
+	if (!vmf_pfn_order_ok(vmf, pfn, order))
+		return VM_FAULT_FALLBACK;
+
+	/*
+	 * Access was checked at mmap() time, but with CONFIG_IO_STRICT_DEVMEM
+	 * revoke_iomem() zaps the mapping once a driver claims part of the
+	 * range. Re-check here so a revoked page is not faulted back in. Like
+	 * the mmap()-time check, it is not serialised against revoke_iomem(),
+	 * so a fault that passed it can still install a page revoked right
+	 * after.
+	 */
+	if (!range_is_allowed(pfn, PAGE_SIZE << order))
+		return order ? VM_FAULT_FALLBACK : VM_FAULT_SIGBUS;
+
+	return vmf_insert_pfn_order(vmf, pfn, order);
+}
+
+static vm_fault_t mmap_mem_fault(struct vm_fault *vmf)
+{
+	return mmap_mem_huge_fault(vmf, 0);
+}
+#endif /* CONFIG_MMU */
+
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+/*
+ * generic_access_phys() only follows present PTEs, and a lazily populated
+ * mapping has none for pages the target has not touched yet. Fault the page in
+ * first, so that remote access (ptrace, /proc/pid/mem) keeps working.
+ *
+ * fixup_user_fault() refuses a fault the vma does not permit, so an untouched
+ * page of a mapping without VM_READ stays unreadable, where the eager mapping
+ * left a present PTE.
+ */
+static int mmap_mem_access(struct vm_area_struct *vma, unsigned long addr,
+			   void *buf, int len, int write)
+{
+	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+
+	if (write)
+		fault_flags |= FAULT_FLAG_WRITE;
+
+	/*
+	 * With unlocked == NULL, fixup_user_fault() keeps the mmap lock held
+	 * and the vma valid.
+	 */
+	fixup_user_fault(vma->vm_mm, addr, fault_flags, NULL);
+
+	return generic_access_phys(vma, addr, buf, len, write);
+}
+#endif
+
+/*
+ * COW mappings are mapped eagerly by remap_pfn_range() and cannot be populated
+ * on fault: vmf_insert_pfn*() BUG_ON() a COW VM_PFNMAP vma. Leave them without
+ * fault handlers, so that do_fault() rechecks a pte it found cleared under the
+ * page table lock, and fails only once the pte is really gone, as after
+ * revoke_iomem(), and so that they are not reported as THP eligible in smaps.
+ */
+static const struct vm_operations_struct mmap_mem_cow_vm_ops = {
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+	.access = generic_access_phys,
+#endif
+};
+
 static const struct vm_operations_struct mmap_mem_ops = {
+#ifdef CONFIG_MMU
+	.fault = mmap_mem_fault,
+#endif
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+	.huge_fault = mmap_mem_huge_fault,
+#endif
 #ifdef CONFIG_HAVE_IOREMAP_PROT
-	.access = generic_access_phys
+	.access = mmap_mem_access,
 #endif
 };
 
@@ -355,11 +441,25 @@ static int mmap_mem_prepare(struct vm_area_desc *desc)
 					       size,
 					       desc->page_prot);
 
+	desc->action.error_override = -EAGAIN;
+
+	if (vma_desc_is_cow_mapping(desc)) {
+		/*
+		 * vmf_insert_pfn*() cannot populate COW mappings: map them now.
+		 * Remap-pfn-range will mark the range with the I/O flag.
+		 */
+		desc->vm_ops = &mmap_mem_cow_vm_ops;
+		mmap_action_remap_full(desc, desc->pgoff);
+		return 0;
+	}
+
 	desc->vm_ops = &mmap_mem_ops;
 
-	/* Remap-pfn-range will mark the range with the I/O flag. */
-	mmap_action_remap_full(desc, desc->pgoff);
-	desc->action.error_override = -EAGAIN;
+	/*
+	 * Populate on fault (see mmap_mem_huge_fault()). Tracking the PFN range
+	 * keeps its memory type reserved, for PAT conflict detection.
+	 */
+	mmap_action_pfn_track(desc, desc->pgoff);
 
 	return 0;
 }
-- 
2.47.3


