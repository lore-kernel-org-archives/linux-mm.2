Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752B3606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jmJJC3qY
Received: by kanga.kvack.org (Postfix)
	id 222846B05B9; Mon, 26 Oct 2026 23:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3936B05BA; Mon, 26 Oct 2026 23:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9E56B05BB; Mon, 26 Oct 2026 23:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF23F6B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:23:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 462AF140843
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:23:05 +0000 (UTC)
X-FDA: 85366959930.05.2D36F44
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9886A160005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:23:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jmJJC3qY;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793071383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mWd1DAd1S4KnKkwjMVvNunqSd6gNRebh+/QyhPldimE=;
	b=XjrSTueCgZz6VmhN+QhNM8SnJuGmxSW0A/9xQmMXEYO7ccEezCDafmKKorrr0/KzQS8xoV
	0JKcQRbPsrp2IaSY0G3lVFQisA4pTa5VeczUSGGP+DhG5PWtE4YNkOBAxmumvRpMj+irs2
	dIfbxJd91c68rgqH9+TJM+Utpdr+J+g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793071383;
	b=r0NvOwKQiZ4PC6zfORwbJ7jEvY1Os8Qz5/TVmt1jH1R3e+ruY1wFe5BNtYUocq7x9Jazey
	7QYNFdO2yn9dQ9hSfa88di0OOZ9tO0NF1V3k93Pknlkr6oJRduIVW+xZh715LFXB2SNjL4
	GwrRDjDjm/x3dSS1BqKu4cECDfqFwqU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jmJJC3qY;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36661f953e4so6818818eec.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793071382; x=1793676182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mWd1DAd1S4KnKkwjMVvNunqSd6gNRebh+/QyhPldimE=;
        b=jmJJC3qYc0Wd8yRDeUUb5YsmTUnboOBCdZQH3YxF0XzkZYT41j+CWshnwPme0bb4Z2
         1HulJjseZNtOmNl4OibTjCPQvg3ykx80Jfi2Ba7DnnyrGmfwDDeUvGkwxTTmFF2hpIOS
         sUE8RS60clTYQctv/8GjGceXUoss5U2a8pFVYiccEpwWEqzOam3K7fBnejJrc/pVudGd
         gz3IeU+dpjafB0TIa/EvURMJoHX9MntLzUUSV+HHtjjE4+odK52ueDkBLM+tEk8Gz/E4
         L/qge3z255m9ZsdHalpvjRekKz4QY/BOAwuia0kkEpUf3qUlRoy2ekEhkT1H9BJXgp7N
         zGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793071382; x=1793676182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mWd1DAd1S4KnKkwjMVvNunqSd6gNRebh+/QyhPldimE=;
        b=lTzoembPy8y6U0W/u5JxDfUaM05hjw9zRmPvWe+kSmnNrzJPIu2F0xI3+dGuO+yznU
         uuXljiMCLvUHR4P8vF61+I5SzezX0Vkr9P8C5Gn8kRWFuvQdGIt6PbiaEir4EDOY2dbI
         CWhA5c8uLKW3bzD+BxGnBzf7+MN1xlZNbgoH9FgvrzbvakFD0eyLDEDagaQEFtThPN5K
         wMxzVE+MwBpQm+lDW5aKf33LhnHMPLf42R0PIx3fq9ndPVYAfFMlLKw4dOVar0ZH7Y0n
         Rim5u/x2m1evMqCrPqAuRn+SfqV/bgQHekn813vZAVO7voNZyDpuzoD09RJhiPMbA4OI
         GWzA==
X-Gm-Message-State: AFq9FYJgP6ZFfw7NI31TtHVwoo+eZXil+i+7PbGYLbGX+YN30IMrCZnt
	Fg31geMgI3HBLgVEKkv7n+YEwPtrtjdK/WJ2pYtmh4a805+tPHEIFMtAAggPBw==
X-Gm-Gg: AYBFou3OmjhbNX2bQD2SXhmOs5ixnafqROMrcgg/Az+ywE6N2771t9vd54hxUlp4RGL
	7/8fGZHk9v74aEGGJsKkA9qKlx5o1gDEmuYEtj11arAtNw/XJka6qugkQoWEoYPz7smwpoY8ggy
	v9kriU+nB+EpTyWnbqMMbtJXShKTPytYOhbsE5ALXCYnaz/PHJslDhas16e0kFA6Ci3wozpFhpc
	jdDEVuaYukEQN/YMpCRaeWX3m60rTEP9SKSNSPVXZmAp9+oFdyiaWfiPwM/HIjJOg2nFSoSaG0n
	mir0s3PYFnl7iSymiI3s11twz0X2LRdFFoo3hxIUFAQNOgJHeLWWJBMVMIxgzhY5/cD6gs/CN1O
	42Yr5JkDE/lDDqzcF/Khs5WktWZ5tiZBSGNkA4E8MnIl/Pcrmr7L1FbIAzGocJvHP97wiXWvpAZ
	o4mVtSdfb3VPdrxJXgrnp3qk+vSiF6uhWOiL703oMNZ/Hpc0esImZ4guqy7iSOyZHAXUQ9LcfhW
	E+4kc+7ud5JU9jK1S4vvfSoYGB1bYMSA0Ppx5TNHbjHNhFSlsZgDCs55uMa
X-Received: by 2002:a05:7301:4388:b0:361:6884:78b1 with SMTP id 5a478bee46e88-369e8507476mr13203756eec.28.1793071382017;
        Mon, 26 Oct 2026 20:23:02 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8ec9276sm49373826eec.25.2026.10.26.20.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:23:01 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Pavithra <pavrampu@linux.ibm.com>
Subject: [PATCH 1/2] powerpc/64s/radix: don't dedup vmemmap covered by an existing PMD leaf
Date: Tue, 27 Oct 2026 08:52:48 +0530
Message-Id: <97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9886A160005
X-Stat-Signature: dpo4hy7f4yafy673pxm87141gx7nnioj
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793071383-449210
X-HE-Meta: U2FsdGVkX1804MpxADQFM6sztBuIo9cfU0ylaM4ExTSzvEBkcH30k2gKImCZKjgeuN7KiSVoLx2cqTNl7yKVTbY1vFPZiWWtIvtZzAhiBpm443XBO2yrLU2nsQVRcOdvCBSS6NTpYhRAUU2VZaTmi4H017v/4rZLvfnubPPFqflrsSa2yPjvY4xcydq66JJjzrfZlz0BUn1fv4QBBsk2d1krw4avWoAhgIRyiuP7k2YyQzQDgAk/pcYS3dfKb2O0d3bJ66iK/2y8/yZo+8ES43C4sEqnAj2ecNm/vtZIINZ+RoXIEZDrpbPpVrxdFNBMFGvclMVbw1DWhGwsBgDcvj7ReeuHJTJhyzpK3bVHw2LStV0fwEfToCbjzE1i1JnyziGDrib/lHebmIZv+MrN1DBR3VOkDxse+Ikr3xCUPovENCtuwANqD4aSa/QCwNpQ8rdrzKyWjzn+qACrpcsUXYMJuy7hgZD0WuiagNJ4nLpCWoc2o6SXizpf342JZQnLWcuVBbqHR8WNjVXSSlGm31RyWzVTDB+XhYaKdJsE8VWj/eCnW+xi86EgqRovQ21uXMwSp+xuEPt+lqZsi3LAtm9kxkfDp9M12NGzNRiCnxi/OGLGKc7RvNDebOTT5Ji5kXkXTL6Xc38m0txMC9ahBSivpqOiZYBKpzuVBvP+cuM6akXLLntstaFoRyzD2aVqiScUO/cNKzny3nVBqR83A5y1ZDcXQSXvzRcwYYQe1PUGFmggwF7eKIFdrRXx9iRYc/BRznXVJ79+vANbmMWcFGzGyLaaC6rYHIaAHXV5PLlCgZ2O2bsA8ceR1ZyREeazEr4p8Y/i8R8QYEhgGsA54qqRjy6ruBjjuMLgtFOUGvC+TAJvf5dU3Mc8yNIjGTTj9Jz0sVJhwJgRNMo4G6JdMf0bwawPaLksOoYTAEVcHVNWZKIm6wRik/33g1eN7I4zawN8eUunnSqStfQgD0Z
 nPkMO2n/
 7fy7fTvBuj83s4l4EdsVyiC4OJsFnsGQhhYdLkfGqhT4ijloKBBXJZUGfRXcxCPApuhoiWQGh1fzDVodjFmuCV87qPbFYx2++07SsWGW3QKBsS51PDAYIKKy9JzKU5FY4RlBBTdrryreJGX4JZazzoFnsqlyuHYcl8Qqe5yQXlchuKFDSZWdNMYZzLNXbpMuARbT9iPbNT++Efhfp7McdRR1/zRBgU6gsB7RX807eyRw7OfytMHbf2WMp6b1dFYslI7czhymBHtocxEFOW9R6kpytUmMkwH+NY/6Z7spkUR1htgZNPTEmiGHC24c3owyGCxbeAxSg+Cfh1bGFgnOdVAmsYRw+qL+VRtI+BV6JHRxkokw2gUFd55gF4H1bfx5Mor/B/2+g4PoQsqnXA8VY5/wphuaV9g1nM8t7L56uixIz0qswYhh5n/GlWxpNrC0k3sAR58DSSRc6fAVp2V15/mvFnC/NQEczsVqMyb6h3/y/G18rEV8vdMtPW0y3H0NRk8VG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

radix__vmemmap_populate() is asked for one 16MB section, which is 16KB of
struct pages. With no altmap it rounds the request down to a PMD leaf.
That leaf describes 2GB of PFNs with 64KB pages (128MB with 4KB pages),
so it also covers sections that are not present yet. It cannot be freed
while any of those sections are still in use.

A devdax namespace that lands in the same window is marked for vmemmap dedup.
vmemmap_populate_compound_pages() treated the leaf as an existing huge mapping
and skipped it. The core then initializes only the head vmemmap page and assumes
the rest is the shared tail. Those remaining tail slots are real struct pages
still holding the page_init_poison() pattern and are not the shared tail pages.
__init_single_page() warns on the zone mismatch and the following pageblock init
faults in __set_pfnblock_flags_mask().

If the section's vmemmap is already a PMD leaf, clear its compound order
and reuse the leaf, so every struct page in the section is initialized.
The shared-tail layout needs base-page PTEs, so it cannot be built on top of
this leaf and dropping the leaf is not an option while the neighbouring range
is still using it. So, fail the compound populate if a leaf is still seen there.

<Call Trace>
============
[    3.467060][    T1] WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4, CPU#0: swapper/0/1
<...>
[    3.477419][    T1] NIP [c000000000576b30] __init_single_page+0xd0/0xf4
[    3.477827][    T1] LR [c0000000005778b0] __init_zone_device_page+0x30/0xb8
[    3.478444][    T1] Call Trace:
[    3.478764][    T1]  0x10000 (unreliable)
[    3.479874][    T1]  memmap_init_zone_device+0x164/0x430
[    3.480392][    T1]  memremap_pages+0x43c/0x93c
[    3.480836][    T1]  devm_memremap_pages+0x3c/0xa4
[    3.481328][    T1]  dev_dax_probe+0x264/0x3d0
[    3.481817][    T1]  dax_bus_probe+0x140/0x1c8
[    3.482237][    T1]  really_probe+0x108/0x580
[    3.482681][    T1]  __driver_probe_device+0xcc/0x284
[    3.483186][    T1]  driver_probe_device+0x5c/0x108
[    3.483656][    T1]  __device_attach_driver+0x10c/0x1e8
[    3.484134][    T1]  bus_for_each_drv+0xc0/0x13c
<...>
[    3.499972][    T1] BUG: Kernel NULL pointer dereference on read at 0x00001400
[    3.500417][    T1] Faulting instruction address: 0xc0000000005f4ecc
[    3.500417][    T1] Faulting instruction address: 0xc0000000005f4ecc
cpu 0x0: Vector: 300 (Data Access) at [c000000006756b50]
    pc: c0000000005f4ecc: __set_pfnblock_flags_mask.constprop.0+0x34/0x160
    lr: c000000000577f38: memmap_init_zone_device+0x358/0x430
    pid   = 1, comm = swapper/0
enter ? for help
  memmap_init_zone_device+0x358/0x430
  memmap_init_zone_device+0x220/0x430 (unreliable)
  memremap_pages+0x43c/0x93c
  devm_memremap_pages+0x3c/0xa4
  dev_dax_probe+0x264/0x3d0
  dax_bus_probe+0x140/0x1c8
  really_probe+0x108/0x580
<...>

Fixes: bd0862382adb ("mm/sparse-vmemmap: drop Device DAX-specific population path")
Reported-by: Pavithra <pavrampu@linux.ibm.com>
Assisted-by: LLM
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
Fixes tag here is added since the fix is dependent upon the change mentioned in
"Fixes" tag. The Fixes commit-id is from mm-new branch. Although this could be
an older pre-existing issue, but got exposed after this patch series.

 arch/powerpc/mm/book3s64/radix_pgtable.c | 57 +++++++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 44868b62b14e..abac39d020ab 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1114,7 +1114,35 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 	return pte_offset_kernel(pmdp, address);
 }

+/*
+ * vmemmap is populated one memory section at a time. A section on PowerPC
+ * is 16MB, so backing its struct pages takes a 16K region of vmemmap.
+ * Without an altmap, radix__vmemmap_populate() satisfies such a request by
+ * mapping a whole PMD_SIZE leaf. One leaf holds the struct pages for
+ * PMD_SIZE / sizeof(struct page) PFNs (2GB of memory with 64K pages, 128MB
+ * with 4K pages) i.e. for many sections, including ones that aren't
+ * present yet.
+ * Return true if any part of [start, end) is already covered by such a leaf.
+ */
+static bool __meminit vmemmap_pmd_leaf_mapped(unsigned long start,
+					      unsigned long end)
+{
+	unsigned long addr;

+	for (addr = start; addr < end; addr = pmd_addr_end(addr, end)) {
+		p4d_t *p4d = p4d_offset(pgd_offset_k(addr), addr);
+		pud_t *pud;
+
+		if (p4d_none(READ_ONCE(*p4d)))
+			continue;
+		pud = pud_offset(p4d, addr);
+		if (pud_none(READ_ONCE(*pud)))
+			continue;
+		if (pmd_leaf(READ_ONCE(*pmd_offset(pud, addr))))
+			return true;
+	}
+	return false;
+}

 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap)
@@ -1128,8 +1156,20 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pte_t *pte;
 	unsigned long pfn = page_to_pfn((struct page *)start);

-	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
-		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
+	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn))) {
+		if (!vmemmap_pmd_leaf_mapped(start, end))
+			return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
+		/*
+		 * A leaf installed for a neighbouring range already backs this
+		 * section with real struct pages and it cannot be freed while
+		 * that range is present, so the shared tail layout would save
+		 * nothing. The core trusts the section's compound order to tell
+		 * which struct pages it must initialize. So, clear it so that
+		 * every struct page of this section is initialized, then reuse
+		 * the leaf like any other section does below.
+		 */
+		section_set_compound_order(__pfn_to_section(pfn), 0);
+	}
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1260,11 +1300,14 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		if (!pmd)
 			return -ENOMEM;

-		if (pmd_leaf(READ_ONCE(*pmd))) {
-			/* existing huge mapping. Skip the range */
-			next = pmd_addr_end(addr, end);
-			continue;
-		}
+		/*
+		 * The struct pages behind a leaf are not the head/shared tail
+		 * layout the core expects for this section and the tails
+		 * would be left uninitialized. radix__vmemmap_populate()
+		 * calls this only when it finds vmemmap optimizable order.
+		 */
+		if (WARN_ON_ONCE(pmd_leaf(READ_ONCE(*pmd))))
+			return -EOPNOTSUPP;
 		pte = vmemmap_pte_alloc(pmd, node, addr);
 		if (!pte)
 			return -ENOMEM;
--
2.39.5


