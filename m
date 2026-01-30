Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A2E5D49C69
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 07:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68246B0005; Fri, 30 Jan 2026 02:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40476B0089; Fri, 30 Jan 2026 02:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BFF6B008A; Fri, 30 Jan 2026 02:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4AB46B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 02:43:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A21F1605B1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:43:12 +0000 (UTC)
X-FDA: 84387839424.12.1F15151
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68471180004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:43:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GWNUy35Q;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769758990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=11cXqOE4/gdoo6u3580eS2INLLA4u6w0uZfJF73EzU4=;
	b=jZEPkjlGZAyTfpHtcSQGAPpuMDRWJmachsR1g3H51/nCiCnLNA451433nYGy0L68SkpBQH
	OrAqi7QxeIUbEwCubx9BFaFPKPhQFjw6A8MOQ/YiuBfkhGSMg3ndMLmC9zGr6KjcpuPykb
	zYPKDuXNAqEOYxXPMoeX9so/mfJd2yM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GWNUy35Q;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769758990; a=rsa-sha256;
	cv=none;
	b=eKql/IdCE5iqOTRrJR3FGpOP2TnvS9Yj0nnB/6/hQ2JFO9j6ufwEAbwxjTfMUDv8qm8C5V
	XZSoI2Qyv98HwkEvamsSfhfV+At4izupcXnFgi9MYzEBWnFJhp+cIQWziyk4od6vuOrXUa
	W/eMt1w+dUeeFnpnZCCgqqmYDfhQQtY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=11cXqOE4/gdoo6u3580eS2INLLA4u6w0uZfJF73EzU4=;
	b=GWNUy35Q7OcTVsB/6bzDkOlCyEDSgEA4ysZRIJ0UfcmMHWXSNGpfP7+BKZRWRW7TMJeszBxAP
	FMeWtQGkJvA9WUo8MyhyaCaPRe/fm1LXOkUSiPnh9CVBS84NUS/0c5SxhRc2fG/2NWu2i0vyKXR
	GCfz94ssFDLoDHuVod3STPw=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f2SZ72hF5znTVF;
	Fri, 30 Jan 2026 15:39:11 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 251CC40565;
	Fri, 30 Jan 2026 15:43:04 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 30 Jan
 2026 15:43:03 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <zengheng4@huawei.com>,
	<ryan.roberts@arm.com>, <anshuman.khandual@arm.com>,
	<wangkefeng.wang@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>
CC: <tujinjiang@huawei.com>
Subject: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in generic_access_phys
Date: Fri, 30 Jan 2026 15:38:07 +0800
Message-ID: <20260130073807.99474-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68471180004
X-Stat-Signature: kxrjhzhjadzsn1a8sy31uhztbowbh98j
X-Rspam-User: 
X-HE-Tag: 1769758987-978171
X-HE-Meta: U2FsdGVkX1+CVnYf3bBarSORelP0tEybyPcOsFhVZeIBkdA14PbXOJJEQazQbzROy/yG1A6k7YtwyyEUZPUfdbXYM9B7xLbKUvI1pnmQSlMHyPo0Tc0HuaElQYbmkiPYiAIqGgI2hjo1Wrme78ZKxI4rBh8x5gfjgtxaeH1APpLTQ6OAGdLm/mZXR9xK6FLzXuIbR1CGUOHcf0+FLMhEv57IlSmgsJKVx5V7/5Kywi+0MtPCticFGUIIFpOMrja1gYmEWb/NAfBqafWagOy+9YpKYeNt1NnlTHIOG0NGThyGizrIDoFLbWf4Zx0cAAJVVLjhG+tiOgjl6v1MuUCa2Ikf+KFk1OB2SEFIy+2XMTWnyx11UEIbSYlofqPztjbeGYQd0Rz2my2XgvGp+XL2q62u9fHiBTkJ1djXn5GSVXzsJHe073ShECCvYeUSbu/8xfcJMcr95Utp6+6qcEvueGdvje7e8Oh4fikoOW6/pcXob0rIKd6RZi8MXpF06gS/Ig8iicqT+s+xjziZZ8HweGQVGE54h/vC2/b2G+nl2m0XPAgFzjYLhKnMvb8pYP0dYUvDv8u14PajJgVyXeLfQrznuvR7NtsNbEL0CpXevwOAN3NJwBVxfCc3LXElaPwppXFV1SkzrOY7C3RsMfNUOSz/SZOGTfGyNQZcf0tDAoaLoq2SUTLIBAhh6A3GjXZMI8aepNQGXfZdJjaUsFjcxXRfzZOfd76WL77kpmHDbgFo/B+LIIyHzEH2EnR7Zl84oK+lKDw+2ob88s0mFpgDcRHOcNgsC8rdjM6kaCOU1+thri1cfjn2Y9xVFuEzbotkCoSBUTqFjJdqtHptgXmTuMNP9fDsjLM5sdco6Md8iKFuPT5Ja34FMdjCyI+neoYjr/o4FCW7d65W41cucAVYPQpoc8/r1Wr8FuF5+3M/mHaEI9htmGKVVW8i4jC6mMD6lA9XDL7MgLdTfmVg4y4
 09uDljAB
 AYlafbjksxkUGO1kbukTKgpanjn3G1ZBQq1yzsg3sX9poDEtNMwTip6GOevmddaXAYBsg/NTUXBSfyIvPayYJpvExpBwtTPYyATekFab9qvR6gK+AwE8zizBTJkptviwJWHMnsdFcXqr0+q0/LsGZxW5TEIGVnsvlTFnT63KgnWPptyI9O4R36BtQ7SzvgLAWMThXndB4XXZfWpOwWFth6p9/Tj2evY09955VSLTu6rOk+vDypeRNYS5CTm2E2rDMX9U6VGJmchANHj99DMRvsJt1VIzOrkXs2hUS6dIMxN1DYz/eK/p4X+RsN7BqZ4cS4xq1Kz0sw+KqSzO/Dw9g5S9wmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here is a syzkaller error log:
  [0000000020ffc000] pgd=080000010598d403, p4d=080000010598d403, pud=0800000125ddb403,
                     pmd=080000007833c403, pte=01608000007fcfcf
  Unable to handle kernel read from unreadable memory at virtual address ffff80008ea89000
  KASAN: probably user-memory-access in range [0x0000000475448000-0x0000000475448007]
  Mem abort info:
    ESR = 0x000000009600000f
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
    FSC = 0x0f: level 3 permission fault
  Data abort info:
    ISV = 0, ISS = 0x0000000f, ISS2 = 0x00000000
    CM = 0, WnR = 0, TnD = 0, TagAccess = 0
    GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001244aa000
  [ffff80008ea89000] pgd=100000013ffff403, p4d=100000013ffff403, pud=100000013fffe403,
		     pmd=100000010a453403, pte=01608000007fcfcf
  Internal error: Oops: 000000009600000f [#1] SMP
  Modules linked in: team
  CPU: 1 PID: 10840 Comm: syz.9.83 Kdump: loaded Tainted: G
  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
  pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : __memcpy_fromio+0x80/0xf8
  lr : generic_access_phys+0x20c/0x2b8
  sp : ffff8000a0507960
  x29: ffff8000a0507960 x28: 1ffff000140a0f44 x27: ffff00003833cfe0
  x26: 0000000000000000 x25: 0000000000001000 x24: 0010000000000001
  x23: ffff80008ea89000 x22: ffff00004ea63000 x21: 0000000000001000
  x20: ffff80008ea89000 x19: ffff00004ea62000 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000806f1e3c
  x14: ffff8000806f1d44 x13: 0000000041b58ab3 x12: ffff7000140a0f23
  x11: 1ffff000140a0f22 x10: ffff7000140a0f22 x9 : ffff800080579d24
  x8 : 0000000000000004 x7 : 0000000000000003 x6 : 0000000000000001
  x5 : ffff8000a0507910 x4 : ffff7000140a0f22 x3 : dfff800000000000
  x2 : 0000000000001000 x1 : ffff80008ea89000 x0 : ffff00004ea62000
  Call trace:
    __memcpy_fromio+0x80/0xf8
    generic_access_phys+0x20c/0x2b8
    __access_remote_vm+0x46c/0x5b8
    access_remote_vm+0x18/0x30
    environ_read+0x238/0x3e8
    vfs_read+0xe4/0x2b0
    ksys_read+0xcc/0x178
    __arm64_sys_read+0x4c/0x68
    invoke_syscall+0x68/0x1a0
    el0_svc_common.constprop.0+0x11c/0x150
    do_el0_svc+0x38/0x50
    el0_svc+0x50/0x258
    el0t_64_sync_handler+0xc0/0xc8
    el0t_64_sync+0x1a4/0x1a8
  Code: 91002339 aa1403f7 8b190276 d503201f (f94002f8)

The local syzkaller first maps I/O address from /dev/mem to userspace,
overiding the stack vma with MAP_FIXED flag. As a result, when reading
/proc/$pid/environ, generic_access_phys() is called to access the region,
which triggers a PAN permission-check fault and causes a kernel access
fault.

The root cause is that generic_access_phys() passes a user pte to
ioremap_prot(), the user pte sets PTE_USER and PTE_NG bits.  Consequently,
any subsequent kernel-mode access to the remapped address raises a fault.

To fix it, define arch_mk_kernel_prot() to convert user prot to kernel
prot for arm64, and call arch_mk_kernel_prot() in generic_access_phys(),
so that a user prot is passed to ioremap_prot().

Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
Changes in v3:
 * arch_mk_kernel_prot() always grant read/write permissions.

 arch/arm64/include/asm/io.h |  8 ++++++++
 mm/memory.c                 | 12 +++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 83e03abbb2ca..fe3040d59119 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -267,6 +267,14 @@ int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
 
 #define ioremap_prot ioremap_prot
 
+#define arch_mk_kernel_prot arch_mk_kernel_prot
+static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
+{
+	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
+
+	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
+}
+
 #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
 
 #define ioremap_wc(addr, size)	\
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..68fcfc3bbad8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6836,6 +6836,14 @@ void follow_pfnmap_end(struct follow_pfnmap_args *args)
 EXPORT_SYMBOL_GPL(follow_pfnmap_end);
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
+#ifndef arch_mk_kernel_prot
+#define arch_mk_kernel_prot arch_mk_kernel_prot
+static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
+{
+	return user_prot;
+}
+#endif
+
 /**
  * generic_access_phys - generic implementation for iomem mmap access
  * @vma: the vma to access
@@ -6853,6 +6861,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 {
 	resource_size_t phys_addr;
 	pgprot_t prot = __pgprot(0);
+	pgprot_t kernel_prot;
 	void __iomem *maddr;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
@@ -6870,7 +6879,8 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if ((write & FOLL_WRITE) && !writable)
 		return -EINVAL;
 
-	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
+	kernel_prot = arch_mk_kernel_prot(prot);
+	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), kernel_prot);
 	if (!maddr)
 		return -ENOMEM;
 
-- 
2.43.0


