Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D5A606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 06:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OiNBrtpG
Received: by kanga.kvack.org (Postfix)
	id DECAD6B05BB; Tue, 27 Oct 2026 02:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76276B05BD; Tue, 27 Oct 2026 02:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17C86B05BE; Tue, 27 Oct 2026 02:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 967AC6B05BB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04E2040967
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:57:56 +0000 (UTC)
X-FDA: 85367501394.28.A90C906
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3427740002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:57:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OiNBrtpG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of trilith.zheng@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=trilith.zheng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793084275;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFHNeMzU6lF6SlEzmc33S/YQH+LNSV+pccbe3Fm4Sbo=;
	b=MKb6nQKzHvp1blI8tOZyheMdMLHUbtbrvmZaZ4uxImnr/OJuT0wtv4VGeGJkkEUxZ8zFPg
	VFbCSITpe2FTd4Iyjhuau0ebbd0jNcr98vPtg85yK445GxLeRefBj4skLOvTtGhJzdTJdi
	vpvuPa4UAaler4RhaNoMAFF6QsVPpaw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OiNBrtpG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of trilith.zheng@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=trilith.zheng@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793084275;
	b=TpBDQnmWBws7MXEqdt+JllrIQVNKgu0KOws1Bn2dgU+Uad3i/+lpKkflA2rC1ZlMje8w3E
	p3u2MWHOFCzNEiCtwgrf6k+M8eHu1J0OnDczEi210G0SLdBs6CAD8YOAoPuA1ALehsD+ye
	d8LFArrtSCP1t42PFL0T7z6cjRdVtfM=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a06b27bf9bso1992198b3a.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793084274; x=1793689074; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rFHNeMzU6lF6SlEzmc33S/YQH+LNSV+pccbe3Fm4Sbo=;
        b=OiNBrtpGTvgCMuvUJ2xeN1UdDdTL6No3sLUdsg4UcxG5A2TKGFHQA5/Zl77olFrUuW
         LGmB2h3NiwiKDQ96Qcd6X1zYC1tarM+RgKhD+K4qk7jFJs2lkR3+W6aYScPeV1E/f16X
         dJty5IXtlell0CdorSKLRYe36kHMunx7J5EgfrRC2ceWr9Zv/p6/7HGqbOBsaalfeP0F
         QsjNNtqzSHrVsew26yP2us+H9n5y+49BO+A4HiesU3/hnBIn30+fBUPY+jo4SnTVM940
         qSy2YdfhE1G9YRAhhVQ+YITYSSwm5qkOpzspqZdG6KYitfGWy7zRP2EMHo/RRAxRzG0l
         SgFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793084274; x=1793689074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rFHNeMzU6lF6SlEzmc33S/YQH+LNSV+pccbe3Fm4Sbo=;
        b=NRDcRxjVqcGskJQGN+BEoCiCVd+GMZFfiQExeaULz4TN1LKrZSuBvPCnZ5oCm8YWH1
         z+0FaGoEi3YInY6hGD7mCl/0MXFpWHX6naq54QCiQ30yBTeO3U568wnugH3NVsBkV3JK
         AsauoAVVi84IOX1cpytfgOWDp5LkulXoCw17g46JmAtPBVWzz2T6heYExhoaEg9pM2sF
         PHUUnYpxX7CNfB9CUE6zwGJl4SkV+h+lbEmyNj3KRPimFIuCITdmHiDBifZFUAYZnHx1
         mV1XHIIeeUPAkCf85q8nGFLZ+ktdgrt/E/SPjFGIpigcPROTg9foyUvjuy22lOhT4wOu
         fZcw==
X-Forwarded-Encrypted: i=1; AKwUvByQn+oZNp/zUwe97A2Pg4A51/KrHeS6fejwdC+VZTRv7mGZsnjXJ0wjfzg+IM8bfQSocgeSIjxl+g==@kvack.org
X-Gm-Message-State: AFq9FYIti8OhxPbcc38y+e0j+/pCcOpGqerwBRVIw0mOQxi5Rwvcz9kd
	XNXbAM9vBZj2iBqrTB0+O51PxVxKlTv7xaTZWW34Fk7lShnneBQCxAOP
X-Gm-Gg: AYBFou27ncPOXGIC7TREze6XXLWYXEIOUpJsBgzD4tZOXRrvQ2dQ8ruwr7tdjJ/yUQB
	4brNMQoY6WudWgZAUiS6YfrseOKREKT7DZjEMDQDPImvnY0e9rFqTkUC1jZgVvKxfm7UlHEMh2a
	86E/LmTwjsgANOayWCWi8cf3wCxxDFYXV7YSGPdDlHyRO3mpx5dmcjC9FG+Uho4250jcxAciWyo
	Zz1bXnQ6iDvY/9DiSVtlHVolV+Of5YZHbflBA4liJ/Z2vwmAocfteeqoSLA7Iz0vFz1fqVa/kaj
	CAHnWRGrgR5DOmYAtKuUjfw1PkBR4t3AfiAbEfs8W53eUVSRTs+BloAEqI1JZLPVnvGqbjorQLb
	FUfyJ1OPPXMHk3tKyVcc1PvuSHrYlE+KrmNKon/njAO8hcJMXJshQrJVlfzeV/vsXvGHy7+VGtV
	m6553Dw2ogP/z4aTyNchKMqcUq1FVru2Zl1w44TqQ5DsZC0QIUH+6FNoFPmhAAHpj6nuLt79KRG
	6mfQ1iASZNgMXW34ldl2YzLMUb+TqZzP7RlZ747l6tsA1L1Umer2ful+M1FSGEkEcPvsSR29cSe
	2itP
X-Received: by 2002:a05:6a20:a110:b0:3de:53c1:b627 with SMTP id adf61e73a8af0-3e7bfa975admr5738301637.43.1793084273864;
        Mon, 26 Oct 2026 23:57:53 -0700 (PDT)
Received: from localhost.localdomain ([101.44.96.6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdac68402a1sm1398700a12.1.2026.10.26.23.57.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 Oct 2026 23:57:53 -0700 (PDT)
From: Yilei Zheng <trilith.zheng@gmail.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Date: Tue, 27 Oct 2026 14:57:23 +0800
Message-Id: <20261027065723.66564-1-trilith.zheng@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260903122128.12264-4-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com> <20260903122128.12264-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3427740002
X-Stat-Signature: 94kc5359sx3hmd88cfemqjk4n7q8kg48
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793084275-723132
X-HE-Meta: U2FsdGVkX19p10CHAiqZBgG7t300iUIqLvJZa/FK/gNidA/nTP1rFeq3uMDbQhznY/mKZPfYd2Dw5xMKcIrX8sCcLyBWwZ+Zlf+WR8FEaLraIim7Z5XlLA9O/OwHDTdqbDWf17NdUL9FHuWVFJEqJ9soaLthG/PlQqiwiXegNtjuVU887FPzkMYE/UwDhKTPQF91mUJ8naQA9oeToBP5ABoF4J9itnEosKEvTtRpeqHu8of530DYA6ApQZthoY49an279a0PbgYDEalc6nJdU0L7xkXqAAJWsXwtUrOjfYKYo6riAamZcGx5Uy/wPrwY//bLDXQ7el7Egx+V8j5ixD9TvLEWGba4vgHX6htHA6Cd2VQQYjP2Z4ushaqjJPGv1hl3LrWi+hznMECjeDmMNwH7DJmnPMYjFHFayJj8t0g4RgeBfdcVApmluwSKc9Z7uljWE4+4rMUF/yERG52+DBx7ShzmB4hOXgJEeYfNPTa1cUgEdCZPQ67IKA/NsXcnvscWowYyvT/21dSusdpDx5Si1ANAmNZUghPbx5bcbjDhPpqruiabi/+5uTghjjorgbiz7zT2JVWPctG9MEZhx5agCoI51KL/pe55Bym/ZsFNWXOwNhMr0QQxKPVoczZz6Tenh5mok8BXX0fNULNQBUbJ2FgAFay29HZALPDBDfH1abRjSLJs/KmPDWjzZ/RBjzb2xzVphvbJH0Ky6UQNc39Va5cb7aO0AHrBA/GzuTYB4no3BL+ytW2RRw6VEqLq7R2EPCA7Feo2umT0HLIYjUWqwQ2rAgzrytt5Imq/tTTO0b+dyJCoohMauyrmJXP76gDX45VmZMr6RdbyPT51+gtGWS8ylSMSnRq0evW7sc/tTLNyHx19RB1FB0l+J30R+2i7UuxEKVs+pPjIHGb8TZDVUg+ABGR5TgtKj6AF2aGBdeU8lYMhfZl5VM/LIQarVYfSr4sNk2XfhBfieS/
 V/3hZqLF
 ElwL/QvN/eq21fdhMD9KMwBNyAB+K9zf6QAFAZiRZoqBQKywrmf9htasj0GBcJbkoPxFMfbpjsI8v5wIdzNtz7ZcUzOD2uA7LmGTQeG+gemTKKz2Gw/rOAZMT3fTRDdNdINcVLH2zjiaLEUiGnbji/sGsk+x5a8+z72P+MdCD7Ep5Q6DT4emwXuVv4cS3jXHiqVNaplDkdBmAoi4k7rT/cVyvRGjO27w8xAXporyhebrjng0SDG6kaRK5DXCEX38XffE5OeFaUCX74h+VJJk78j0DkurTBAebfMir65sOVULOopDl8439fZWKWFEt+WVMyZXjkKzNbSEUmgUmPriKTAFLO87L+8Pywe3ZRdCLmIQV43gnkFB7s1yOqJsOBJcZsQ9wf8gufKIvMVuHtDXb/+UF3Lc7OozLaicgrzNSxNAy5LNck5VjkyzsIvWN0onUb3J5WlSO2KjReLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

I have been testing this series for microVMs that mount a read-only
rootfs over virtio-pmem with FS-DAX. In this setup, most file data is
accessed through read/write rather than mmap, so most PFNs never need
private writable metadata. This optimization is very useful for
reducing guest memory overhead and running more VMs on a host.

While testing, I ran into two issues, both in patch 3, including a
crash when initializing the shared template page during probe, and the
128 MiB alignment check preventing our 2 MiB-aligned rootfs images from
using the optimization, even though the check can be relaxed without
changing the registration or teardown paths. I have included a patch
for both at the end of this email.


First, regarding the shared template initialization in
memmap_init_zone_device():

> @@ -1133,6 +1134,15 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	if (!nr_pages)
>  		return;
>  
> +	if (pgmap_vmemmap_optimizable(pgmap)) {
> +		struct page *page = page_address(pgmap->vmemmap_shared_page);
> +
> +		for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +			__init_zone_device_page(page + i, start_pfn + i,
> +						ZONE_DEVICE, nid, pgmap);
> +		goto pageblock_init;
> +	}

pgmap->vmemmap_shared_page is allocated from normal kernel memory
(direct map). It is just a template buffer, not a real struct page
inside the vmemmap space, so passing it to __init_zone_device_page()
causes page_to_pfn(page) to compute an invalid, out-of-bounds PFN.

I first hit this when backporting the series to a 6.6.117 guest kernel,
where set_pageblock_migratetype() uses that invalid PFN and crashes
during device probe.

On your base commit (next-20260902), a normal boot does not crash
because pageblock init was moved to the end of the function. However,
set_page_count() still calls page_to_pfn(page) inside the page_ref_set
tracepoint. Booting with CONFIG_DEBUG_PAGE_REF=y and
trace_event=page_ref:page_ref_set triggers the same NULL pointer
dereference during probe:

  BUG: kernel NULL pointer dereference, address: 0000000000000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Call Trace:
   trace_event_raw_event_page_ref_set+0x4e/0xa0
   __init_zone_device_page+0x98/0xd0
   memmap_init_zone_device+0x1c3/0x2e0

To fix this, I added init_fsdax_page_template() to initialize the
template fields (ZONE_DEVICE links, Reserved flag, pgmap, and refcount/
mapcount via atomic_set()) directly without calling page_to_pfn(). It
also preserves the WANT_PAGE_VIRTUAL handling from __init_single_page(),
since patch 1 enables this optimization on LoongArch where KFENCE
selects WANT_PAGE_VIRTUAL. I only have x86-64 to test on, so please let
me know if that part looks right to you.


Second, regarding the alignment check in
pgmap_vmemmap_shared_page_alloc():

> The initial implementation is deliberately limited to a single
> memory-block-aligned range. That is not a fundamental requirement, but keeps
> the registration and teardown paths simple; support for multiple ranges or
> less strict alignment can be added later.
...
> +	if (pgmap->nr_range != 1 ||
> +	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
> +		return 0;

After fixing the crash above, the optimization still did not take
effect for my 130 MiB test rootfs image. Because MIN_MEMORY_BLOCK_SIZE
is 128 MiB on x86-64, the 130 MiB device failed this check and fell
back to allocating all 520 vmemmap pages.

In our microVM setup, rootfs images are sized to fit the filesystem and
aligned to 2 MiB rather than 128 MiB. In fact, 2 MiB (SUBSECTION_SIZE)
is already the native alignment for FS-DAX (via memremap_compat_align())
and for ZONE_DEVICE vmemmap population and teardown. To keep those paths
simple, we only need to make sure a shared vmemmap page never crosses a
pgmap boundary, which 2 MiB alignment already guarantees on 4K-page
kernels.

So I relaxed the check from MIN_MEMORY_BLOCK_SIZE to SUBSECTION_SIZE.
I also added an alignment check on (PAGE_SIZE / sizeof(struct page))
PFNs, so the same boundary guarantee holds on large page kernels,
where one vmemmap page covers more than 2 MiB of device memory (such
as 16K/64K pages on LoongArch).


With both changes applied on next-20260902 (QEMU x86-64), probing with
CONFIG_DEBUG_PAGE_REF=y and trace_event=page_ref:page_ref_set works
cleanly. The 130 MiB test device now uses one shared vmemmap backing
page instead of 520 private pages, and DAX faults materialize private
metadata on demand as expected. Mounting two 2 MiB-aligned virtio-pmem
devices side by side also works properly, and unbinding/rebinding either
device does not affect the other.

If these changes look good to you, could you fold them into patch 3 for
v2? (Note that the patch is against v1 and still uses the
PGMAP_VMEMMAP_OPTIMIZATION flag.)

I also noticed that next-20261023 has refactored
memmap_init_zone_device() to use zone_device_page_init_from_template().
The mm/mm_init.c change will need to be adapted when rebasing the
series, while the mm/memremap.c change should remain applicable. I am
happy to help retest v2.

Signed-off-by: Yilei Zheng <trilith.zheng@gmail.com>
---
 mm/memremap.c |   10 +++++++++-
 mm/mm_init.c  |   29 +++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/mm/memremap.c b/mm/memremap.c
index a53d09b..34d8d89 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -93,8 +93,16 @@ static int pgmap_vmemmap_shared_page_alloc(struct dev_pagemap *pgmap, int nid)
 	    !(pgmap->flags & PGMAP_VMEMMAP_OPTIMIZATION))
 		return 0;
 
+	/*
+	 * Subsections can be populated and removed independently, but a
+	 * shared vmemmap page must never span across different pgmaps
+	 * (which can exceed a subsection on large-page kernels). Check
+	 * both boundaries instead of requiring a full memory block.
+	 */
 	if (pgmap->nr_range != 1 ||
-	    !IS_ALIGNED(range->start | range_len(range), MIN_MEMORY_BLOCK_SIZE))
+	    !IS_ALIGNED(range->start | range_len(range), SUBSECTION_SIZE) ||
+	    !IS_ALIGNED(PHYS_PFN(range->start | range_len(range)),
+			PAGE_SIZE / sizeof(struct page)))
 		return 0;
 
 	pgmap->vmemmap_shared_page = alloc_pages_node(nid, GFP_KERNEL, 0);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7dd03b8..1c3e269 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1030,6 +1030,31 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+/*
+ * Initialize struct page slots in the shared backing page. Because this
+ * page is a direct-map template buffer rather than a real vmemmap entry,
+ * set_page_count() must not be used here as its tracepoint calls
+ * page_to_pfn(). Keep the initialized state in sync with
+ * __init_single_page() and __init_zone_device_page().
+ */
+static void __ref init_fsdax_page_template(struct page *page,
+					   unsigned long pfn, int nid,
+					   struct dev_pagemap *pgmap)
+{
+	mm_zero_struct_page(page);
+	set_page_links(page, ZONE_DEVICE, nid, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(ZONE_DEVICE))
+		set_page_address(page, __va(pfn << PAGE_SHIFT));
+#endif
+	atomic_set(&page->_refcount, 0);
+	atomic_set(&page->_mapcount, -1);
+	page_cpupid_reset_last(page);
+	page_kasan_tag_reset(page);
+	__SetPageReserved(page);
+	page_folio(page)->pgmap = pgmap;
+}
+
 static void zone_device_page_init_from_template(struct page *page,
 		unsigned long pfn, struct page *template)
 {
@@ -1138,7 +1163,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		struct page *page = page_address(pgmap->vmemmap_shared_page);
 
 		for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-			__init_zone_device_page(page + i, start_pfn + i,
-						ZONE_DEVICE, nid, pgmap);
+			init_fsdax_page_template(page + i, start_pfn + i,
+						 nid, pgmap);
 		goto pageblock_init;
 	}
-- 
2.39.5

