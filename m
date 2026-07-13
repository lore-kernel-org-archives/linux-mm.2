Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB398C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B66C6B0139; Mon, 13 Jul 2026 12:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E386B013B; Mon, 13 Jul 2026 12:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A46B6B013C; Mon, 13 Jul 2026 12:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC266B0139
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:32:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 590B6168990
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:38 +0000 (UTC)
X-FDA: 84983921316.29.B6C76E6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id A479E14001D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nFe7xAlP;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Js5Ujza7BY6FmgGSCwaA2kFEpxH3uyI0e2g6qTYXLJg=;
	b=JJSr8ByClCZegjRqG02JoeY/nEssCnBiodwMrAIVkIkSidUUgbHtBeO6L2eSCAlGIvRkon
	y3puzN9+xxObb442aOcHlzEw9YPYjXp/0ObQs3CHq0UqC27K2X+yUxL01qCe47w2kb2IWi
	tAnoEXrLW+LeuE4ja3/Teq2NmIbwwnY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nFe7xAlP;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951416;
	b=0NCfU2Ypc4eB9dYhK5K0wB0BHFhbGDz/RZBu9aQ5UBPy6K9V6hW/G5KnS9vfmT1h9CvbqI
	y16FoY9HeF/zNIx42jfwC/e8sagCGjmGJJ655BwXhKWcab3mPC2Wz09uZF8biebeWuiJjS
	X8ZcI9XrfD7EOJo9nhQ6ek75hNKEUkc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D6A62309;
	Mon, 13 Jul 2026 07:03:31 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AF31A3F7B4;
	Mon, 13 Jul 2026 07:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951415; bh=QAL4GYmN8cF0pmxGGh9bWrEOsYJOq6TzQh5SyXgApoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFe7xAlP2LDvWkRo0KA0ExYj7kOvwZ3/PeBr/ZxemEskfg5Bkh306EL0w/W9x9JIN
	 6Rx+rn4+oXKAD3tpAI7lV/BuzB2WGkXK7sBpbgChBd8nXbW9Icfb0KCMOKBYCtCIox
	 XMYIO7XpJyV2WpqTO0aUkz0XGFIpt8zutTPK0j+A=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org
Cc: david@kernel.org,
	linux@armlinux.org.uk,
	akpm@linux-foundation.org,
	ankur.a.arora@oracle.com,
	rppt@kernel.org,
	linmag7@gmail.com,
	chleroy@kernel.org,
	klarasmodin@gmail.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	kas@kernel.org,
	zhangtianyang@loongson.cn,
	wangyuli@aosc.io,
	tsbogend@alpha.franken.de,
	ljs@kernel.org,
	jgg@ziepe.ca,
	catalin.marinas@arm.com,
	will@kernel.org,
	arnd@arndb.de,
	ryan.roberts@arm.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	kevin.brodsky@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com,
	yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com,
	ardb@kernel.org,
	guoren@kernel.org,
	yang.li85200@gmail.com,
	viro@zeniv.linux.org.uk,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn,
	junhui.liu@pigmoral.tech,
	muchun.song@linux.dev,
	vishal.moola@gmail.com,
	namcao@linutronix.de,
	pavel@kernel.org,
	djbw@kernel.org,
	yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com,
	Jonathan.Cameron@huawei.com,
	coxu@redhat.com,
	andreas@gaisler.com,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	geert@linux-m68k.org,
	shorne@gmail.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH 34/34] arm64: pgtable: convert pte_present() from macro to static inline
Date: Mon, 13 Jul 2026 14:56:13 +0100
Message-ID: <20260713135614.1618183-35-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A479E14001D
X-Stat-Signature: dqw8sbn6gcki5dscmmctcgcbhuf4trnc
X-HE-Tag: 1783951416-315440
X-HE-Meta: U2FsdGVkX1/sLhK91EDN3hDd2rd1kZOE3j4Z8IPdjf+4+oPsdMU6iCn/yYKV8ShBJi7vMhFSQ5+hmALK4dmuVX107Z0+PSvp9UWaYXI3vHEIkPSVJTCX0+4zE1RT0/eDJpKePP8WYolsXNNylKMZxwydqje5mHu5V5HM9ZKwqPR1wbnGknFx6eP/1hqVDqoW6299zY6MbcnE7dMxl5HIOnhGVAMt0WvmK4Ow89Uf0F15beVc4nLClEsMqzUq7mh7vRXU75kPmPEBpek5q+1Fr5zEwWXyiruq1VeEeSXc/g3YBepdILw9kmKxSgZm284GFa2ctir8t6V/9fOMkJKmYmsVfd4U7j8SC8KzdhSbAbcerYTfNb9QdhHD7CMMZmUT5ceYTO7O/saDVvnMG0ajTi7u+oed0i0SNp1rKowWXEA3PpfWgR+sT8mqj2eFX35x2/f6uGDUYLqiR182BzB4+DEI9+ZvYAxLiqWhBiggxbGwwhoJMw/MX3Rr/RJC1GxVLEtdJbS0qpU0AnHRpBdnBtn3ZSMjhWSDoDsMnxH4eEd0TUGDrYw6Fu7A2xnUQf7GZHyctW9O67PZk/MITN+9AKFm0fPf/VwT+NSzvtUyd36XCPoiBszsGJBg9tmmQpjOCsE0jXSJ9n2qEpSc6zKjJEElqxrizJxEwmzDVEuB19z1ZTdvJet8pvGt7g7e9FNsX5cGE1jmhgfx1c1NXeKUm3BZPQxuAuQWSePz4V54EUCj+icnrsLeE0XfZ9foqE/uDW/txX6UDLTzryaALyXbN+t+rAyjgbsI2NQ2zcJI3uFcXZ2O5rYSsZA7Nv8lXVJNp+2CHUc7gPfSocC4yrgGmQEMNSxDcWoCC1v6suwkhRxz0F72F08aONwrNT4k4//azsxPJRfiA85g+UBu+Wj9kWeDrPgnI4YpuXJe5v3wZNzOS2GRt0J4Lq1CbWTG0fCRBAVHXDqRu3+JCGMqa2g
 m3AUYRgP
 XeUqAWbPTP/4E/R+lNTJ0tFafmJZUp9Tmb4PtuVbuV80NkAQ2pq2/KozVRd36g4XeeP6WajL5Ywc8813oj0qNCsCtvscYKSiwWA5tnmMo4YmCDijoaluQ5mUxbO9j1G7IXrmYdIUBtooBpmzIiWxv/I12MvMoFwwZoZUVn/AQ6F3kx6D7vWaB0q+knNpnNwNdIUhlZSR2SbQXNeo5D0Q7/+WLtoOv3hwTCFvpBF114RfdvYxuckjY1Ona22gpZbdXFhaGlW3SP5xEVZezO/J6Ukm5l0ZnPzYmQc6VybncczgoD/VEMCgjHSAmLINWZWxmBsohYxQ7fKrZd6Aw/W4slvKoHGTwthVrpOEEJekm4cZV+4u057KCORU82crJaUvZiYX/E9luUjFUzuccpzE+VCDrYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_present() is used as the basis for both pmd_present() and pud_present().
It is currently implemented as a macro composed of pte_val() and
pte_present_invalid().

When pte_present() or its higher-level variants are used directly with
ptep_get() or pXdp_get(), for example:

  pte_present(ptep_get(pte));
  pmd_present(pmdp_get(pmd));
  pud_present(pudp_get(pud));

the macro expansion causes the compiler to evaluate the argument twice,
resulting in redundant loads. For example, pte_present() expands to:

  !pte_val(READ_ONCE(*pte) || pte_present_invalid(READ_ONCE(*pte))

A typical example is pud_free_pmd_page(), where the expansion of
pmd_present() generates:
    ...
    /* pmd_present() (x20 = pmdp) */
    1b88: f9400288     ldr	x8, [x20]        // read pmdp.
    1b8c: f9000fa8     str	x8, [x29, #0x18]
    1b90: 3707fec8     tbnz	w8, #0x0, 0x1b68 <pud_free_pmd_page+0xd0>
    1b94: f9400288     ldr	x8, [x20]        // redundant read of pmdp.
    1b98: 8a170109     and	x9, x8, x23
    1b9c: f9000fa8     str	x8, [x29, #0x18]
    1ba0: f120013f     cmp	x9, #0x800
    1ba4: 54fffe20     b.eq	0x1b68 <pud_free_pmd_page+0xd0>
    1ba8: 17fffff4     b	0x1b78 <pud_free_pmd_page+0xe0>
    ...

Convert pte_present() to static inline function so that prevent the
generation of redundant code and move pte_valid() and
pte_present_invalid() further up so the inline function can use them.

After this change, the generated code becomes:
    ...
    /* pmd_present() (x20 = pmdp) */
    1a30: f9400288     ldr	x8, [x20]
    1a34: 8a170109     and	x9, x8, x23
    1a38: f9000fa8     str	x8, [x29, #0x18]
    1a3c: f120013f     cmp	x9, #0x800
    1a40: 54fffe80     b.eq	0x1a10 <pud_free_pmd_page+0xd0>
    1a44: 3607fee8     tbz	w8, #0x0, 0x1a20 <pud_free_pmd_page+0xe0>
    1a48: 17fffff2     b	0x1a10 <pud_free_pmd_page+0xd0>
    ...

This eliminates the redundant load and also reduces code size at
call sites using this pattern. For example, pud_free_pmd_page() shrinks
from 7,500 bytes to 7,148 bytes, a reduction of approximately 4.7%.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6185fc291fd7d..aaae3d14895f6 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -140,10 +140,17 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
 #define pte_none(pte)		(!pte_val(pte))
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 
+#define pte_valid(pte)		(!!(pte_val(pte) & PTE_VALID))
+#define pte_present_invalid(pte) \
+	((pte_val(pte) & (PTE_VALID | PTE_PRESENT_INVALID)) == PTE_PRESENT_INVALID)
+
 /*
  * The following only work if pte_present(). Undefined behaviour otherwise.
  */
-#define pte_present(pte)	(pte_valid(pte) || pte_present_invalid(pte))
+static __always_inline bool pte_present(pte_t pte)
+{
+	return pte_valid(pte) || pte_present_invalid(pte);
+}
 #define pte_young(pte)		(!!(pte_val(pte) & PTE_AF))
 #define pte_special(pte)	(!!(pte_val(pte) & PTE_SPECIAL))
 #define pte_write(pte)		(!!(pte_val(pte) & PTE_WRITE))
@@ -168,9 +175,6 @@ static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
 #define pte_sw_dirty(pte)	(!!(pte_val(pte) & PTE_DIRTY))
 #define pte_dirty(pte)		(pte_sw_dirty(pte) || pte_hw_dirty(pte))
 
-#define pte_valid(pte)		(!!(pte_val(pte) & PTE_VALID))
-#define pte_present_invalid(pte) \
-	((pte_val(pte) & (PTE_VALID | PTE_PRESENT_INVALID)) == PTE_PRESENT_INVALID)
 /*
  * Execute-only user mappings do not have the PTE_USER bit set. All valid
  * kernel mappings have the PTE_UXN bit set.
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


