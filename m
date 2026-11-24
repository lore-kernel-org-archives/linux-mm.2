Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8494A606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=k8/dNHyd
Received: by kanga.kvack.org (Postfix)
	id 99ABC6B06CF; Tue, 24 Nov 2026 08:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924476B06D2; Tue, 24 Nov 2026 08:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813546B06D4; Tue, 24 Nov 2026 08:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5635F6B06CF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:15:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 814E5140B98
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:37 +0000 (UTC)
X-FDA: 85470059514.27.9500A9A
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf01.hostedemail.com (Postfix) with ESMTP id 31DFC40011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:15:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="k8/dNHyd";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf01.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526135;
	b=5D4odAV1oWUilKm+AxP1kUxbf2Vvja59AZvuM5zi2eJU59PW6pYrvAhimRu4qGguepnleo
	WKT9iU21KQAzV/d/6f20tnRDzOP7cdN/Jn/emCmRBqxYk5s4NFYFxM/tVaW01ZzDTqYm5Y
	+rX8mp7rj/Bot9WfUtlPezpRET/1oyQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXlgIqpcSYGINvhQ3k7390QHQGDaKd3fFZ6n6AkmfLA=;
	b=F86y626sBXihwiqQRZU1aEYooy9/vKVE5TZyjyNOFPO3otXr/zuUTgg2Tfr9Hzmj+Ultl5
	E28U3ui+L2G/rZ8MfT96p7QXwPUzERb/77Utvm8wrxWzcg3Fh3tj/3chDQ6HHeV+GaVWdy
	hXxEKa4t2fr9tWRcGWnEsFMvRkZ2a/Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="k8/dNHyd";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf01.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795526135; x=1827062135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wXlgIqpcSYGINvhQ3k7390QHQGDaKd3fFZ6n6AkmfLA=;
  b=k8/dNHydV5m/9ucEo2w85wpnd/Kn7suUIEbLuElbz7MUjB8YnhlzelEb
   o18vdwqBDWGUIXFSwFzs0tvfB+ojd12+KB1JCJVNW2zNklrAl18Tf9WJ/
   /kgjSynI9lYYsbQmz+7YSJCZPOwQYie56/z3jUzyDvA8nwx2/6fHTR94C
   44etwJsHc72XBv6pKLWY/EWpIVOZew9lP7TCIlnF5/cxZLy+pjrIF/8ga
   SxY6ILyIm0qER0c0BSphvjcsWcT/S41S2NUzLLJxAwzNJuOurlJQKaBzG
   HLUAhGpRMFsxV+DcRYkSnoi+NhZXGC1SV8eOekKFl0ltuqzH6BnNxUXNC
   w==;
X-CSE-ConnectionGUID: rtEDJBx8ScKDsM4wFWboOQ==
X-CSE-MsgGUID: uxFdIkepTleQEfWqhopzzg==
X-IronPort-AV: E=Sophos;i="6.27,230,1787011200"; 
   d="scan'208";a="34834369"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 13:15:31 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:5445]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.13.177:2525] with esmtp (Farcaster)
 id d553cf85-9979-4820-b45b-f44d2c8bdc90; Tue, 24 Nov 2026 13:15:31 +0000 (UTC)
X-Farcaster-Flow-ID: d553cf85-9979-4820-b45b-f44d2c8bdc90
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Tue, 24 Nov 2026 13:15:31 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Tue, 24 Nov 2026
 13:15:27 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zi Yan
	<ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v3 4/5] mm/char-mem: implement huge_fault support for /dev/mem
Date: Tue, 24 Nov 2026 13:15:09 +0000
Message-ID: <20261124131510.38745-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124131510.38745-1-farbere@amazon.com>
References: <20261124131510.38745-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: n65uwpo3cfarkg4ipxp3h9w6ns9cs1ht
X-Rspamd-Queue-Id: 31DFC40011
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795526134-390224
X-HE-Meta: U2FsdGVkX1+EcBz73k0E3JsTjIvciTUU3A0H4tr+w8l4j0BPHaIXi7qX2GFKAalNcYuoH/QlSDMT12oSLvJxFlem9aqbBRhjYqABO1gx1s/M7+w58sBB+EPNAZRHoCPA5v9AnZLpyUw5aQ2PKAIBh2FRbQVEgHpFO2FU7VlK43Pzkvxi4k1e/M+6XGd1st+G8hLOL44aHbUYslGAGzrAxXkNivJVoV9+QaoGdWGs8F5kYPTl5+SQ2xAczIrDqlqYG1R7oCsV1+0AmGzxenggWwUS230EkjRa9t+hUZGvfA5vhORqlnHjzV3EFlKsCbbe1ta4E693uUEgmSwI6bzDSQiiieCq1DfBKEZ/3zrOmJnqYHIj9JXdg799v9K5DYpFWQ1dtkyXtlqhO6paewkJf0IyK38ADOnXWxyufLjToL16lNxlnS/ZYt96DsA3tVrfemMUjsml8vPvAH9WjhIucSw3895PvsxTCz6BCVoYBN3zFXj/K2iF4xr6CTC93ZObUZobCYEldcpMaQiLu44S7idLAsp9VM2Kz/JQyJAvFpe26XmK4m+GidJ7eUmxDQQ2wN8ksIBB+wBxl9LyxSQRpft/kwcBiMr0d+HaNLs2txaCshdhaC7iIG2Q1K4bqEC4oqLDp80mqjU07Hgy2+9vbvEc3/YXxr7OtYkO/eGjViuSoa5pkiK6uWlI2zXIoMgiKPcfnQHCFZI3LxZaqVli1s8YSN7WfnqmWEwTEBafgw4qxR7FG5rSWCIwjzmH7q7B1sxx/ypXewpiPcixxS68rwwUIC/fOzRdn3qGMooETfBPF7IULIQFItJI2vbS4/s9ReRuAgaIRqcndqv9XyTvELQnTgzdP/1RujNn2DpEwGXxeGHlg9DvoqQJSv7wRSF+jI3HhDYGhbXm0mdwzP51W3hXmcQo0QXZ/Y1h5nNxL5Jzom2dRciKRbC/zuqyJ/6S7CA0m6DL49C5jTulQRu
 kfxa4Ser
 No8dvGF7xrhTbjUSOAsWdVUdlKipZWSLEt4DPWEHZfQDOCsUBc3LnQDmIdrEARab5Sp+eGV0yl3iwUiwk9pwI0T+AcaMJyJ8OEsMHa9tSq2QikO9gh4yDMns4MOEDQDJkdE13SIM3H9txJT02G3b4f9hTONzUOMDfYM6gCWpB9z0czfpCAKNJ1RvTY3EIWSNCo68YV9N/Gfb5MMQShJJVSvI5Fbv6d8ZQzIc5pQFmwotPiCm/9a3kIjzGW4cIHV2vTxxrqeJSuDFW0RoHq46Sr315CHuAw8G2/sxDiff5cWD9ZW5O3IGyAeXbPDrYFO2gQMU7PwdSmyfni5Jrd62rqSvWCmL7YAgaGomzQlgT+SeeNlHQJCdKgr8lDBPgua9+QOPG1FicCqKGI3QdfV/AzHbLbU09I+9/bIG7/P8lqiphnZAKELILZz2q24qx4NTnWV5W4oxSh2fNvr3gOpky5FE+tZLW4Q6+4p+ZX9FyMwZKJRo8rkuK1njOkD5OHa0MWOk9CMXSbyR8ZJGgO+tTtgxrx+h4WV4raCb+WQrvWthu/xGEWKgeFR1lsNy29NgMWZROIQuxDkxg+4pV267Ek0A8KHilNPEINUAS8l+TrYZzl5pH9gJ+Arv/x/HWj+FnNoJ56gI1Hhi8ntk4ukEewrKGcDEh8WnZ4tspHZS4bfasFdP7mq5KL8wcopfC1XcnLUnIP9bM8+XHy8T/yQ1xKfTsdBjIo5Y2qYnPeFPgGwANMpxtygxREonETXyc6Qo5QM0godtygn7Dt81+Ddzbc0y3MquRZGvBpFizpUsyEXx3KCfu5VB3WMe7Stqbk3JrTYldld0iqyN7xa/KGNiicf97VhXVl08C7vGUFX8/TJX50g9EtnjtWwqn9cx56+v/jhOJBja2U11U5CGTvze6tpHqYkEzryLYB8d/JECUHQAtIhMH94UPMLLrA69z1X6gjMCqp9VicXMzyaXz+E7Oey+Uyk02
 /ylWdnyI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mmap_mem_prepare() maps /dev/mem at mmap() time with 4KiB PTEs, however
large and aligned the region is. Populate on fault instead, as vfio-pci
does since commit f9e54c3a2f5b ("vfio/pci: implement huge_fault
support"): request MMAP_TRACK_PFN rather than an eager remap, and add
->fault and ->huge_fault handlers using vmf_insert_pfn_order(). A large
enough aligned region is then mapped with PMD or PUD entries.

Two cases keep the eager remap: COW, which vmf_insert_pfn*() cannot
populate, and CONFIG_IO_STRICT_DEVMEM, where a fault can race
revoke_iomem() and leave a claimed range mapped.

ptrace and /proc/pid/mem keep working, because .access faults the page
in first. They now fail on a mapping with no VM_READ. The eager remap
used to leave a present pte for them to follow.

The order-0 insert refuses the zero pfn, which remap_pfn_range() mapped.
With CONFIG_STRICT_DEVMEM on, mmap() of that pfn fails with -EPERM.

Signed-off-by: Eliav Farber <farbere@amazon.com>
---

Changes in v3:
- Keep the eager mapping when CONFIG_IO_STRICT_DEVMEM is set, instead of
  re-checking range_is_allowed() on every fault.
- Return fixup_user_fault()'s error from .access instead of ignoring it.

Changes in v2:
- Give COW mappings their own vm_operations_struct, rather than test for
  COW inside the fault handler.
- Corrected the L1TF claim in the commit message.

 mm/char-mem.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 77 insertions(+), 4 deletions(-)

diff --git a/mm/char-mem.c b/mm/char-mem.c
index c5761ddedbd7..283531645f18 100644
--- a/mm/char-mem.c
+++ b/mm/char-mem.c
@@ -318,9 +318,68 @@ static inline int private_mapping_ok(struct vm_area_desc *desc)
 }
 #endif
 
+#ifdef CONFIG_MMU
+/* Populate /dev/mem on fault, huge where the arch and alignment allow */
+static vm_fault_t mmap_mem_huge_fault(struct vm_fault *vmf, unsigned int order)
+{
+	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long pfn;
+
+	/* An order-aligned addr below the VMA would wrap the subtraction */
+	if (addr < vma->vm_start)
+		return VM_FAULT_FALLBACK;
+
+	pfn = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
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
+/* generic_access_phys() needs a present PTE; a lazy mapping may have none */
+static int mmap_mem_access(struct vm_area_struct *vma, unsigned long addr,
+			   void *buf, int len, int write)
+{
+	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+	int ret;
+
+	if (write)
+		fault_flags |= FAULT_FLAG_WRITE;
+
+	/* unlocked == NULL keeps the mmap lock held and the vma valid */
+	ret = fixup_user_fault(vma->vm_mm, addr, fault_flags, NULL);
+	if (ret)
+		return ret;
+
+	return generic_access_phys(vma, addr, buf, len, write);
+}
+#endif
+
+/*
+ * vm_ops for an eagerly populated mapping. Must exist even when empty: a NULL
+ * vm_ops would make the VMA anonymous.
+ */
+static const struct vm_operations_struct mmap_mem_eager_vm_ops = {
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
 
@@ -355,11 +414,25 @@ static int mmap_mem_prepare(struct vm_area_desc *desc)
 					       size,
 					       desc->page_prot);
 
+	desc->action.error_override = -EAGAIN;
+
+	/*
+	 * COW can't be populated on fault: vmf_insert_pfn*() BUG_ON() it. And
+	 * with IO_STRICT_DEVMEM a fault can install an entry after
+	 * revoke_iomem() has zapped it, so keep the revoke final.
+	 */
+	if (IS_ENABLED(CONFIG_IO_STRICT_DEVMEM) ||
+	    vma_desc_is_cow_mapping(desc)) {
+		/* Remap-pfn-range will mark the range with the I/O flag. */
+		desc->vm_ops = &mmap_mem_eager_vm_ops;
+		mmap_action_remap_full(desc, desc->pgoff);
+		return 0;
+	}
+
 	desc->vm_ops = &mmap_mem_ops;
 
-	/* Remap-pfn-range will mark the range with the I/O flag. */
-	mmap_action_remap_full(desc, desc->pgoff);
-	desc->action.error_override = -EAGAIN;
+	/* Tracking reserves the memory type, for PAT conflict detection */
+	mmap_action_track_pfn(desc, desc->pgoff);
 
 	return 0;
 }
-- 
2.47.3


