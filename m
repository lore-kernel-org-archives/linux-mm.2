Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF00DCA6CAA
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185A56B0088; Tue, 27 Jan 2026 04:06:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133856B0089; Tue, 27 Jan 2026 04:06:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B436B008A; Tue, 27 Jan 2026 04:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E142A6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:06:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 821C613C093
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:06:22 +0000 (UTC)
X-FDA: 84377162604.25.2096B29
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7070940005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:06:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1WgzOlZV;
	spf=pass (imf17.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769504780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uJeg8f4t2zYbqXiq32TpqT6FSOTJrwTSh1OSPxciUMU=;
	b=c72arhAmKN1763kQ5srKKLJiRoK2ihJ4q3b5Ud/dL0EfAX1aWToi46eJlp0PRh0bPnO/Hz
	aUiYJ0rqe5alYa6wGannMG+RAIARB9FexDQpod+bT4lmMJIcEd8cAp5HhI7Adx9zg7uXYg
	smxD4fMy5BF4cbJf9kcWCVGB3lcoQQ0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1WgzOlZV;
	spf=pass (imf17.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769504780; a=rsa-sha256;
	cv=none;
	b=VFYShhb8K/jISzszMJ93ZiNigkV/i/7xDjVkw8BxqEH5QyKimTUJPSJGisPnBz2dvA2MC0
	SsNIOBkffP5llIQ04vN6Jvseh0Y99OSfj3NWjLC6AGl6/QFpkJESzCpMP0XlZ4+OZAwCqc
	O7PVBfZCJkAE0Ri79tQXKCHP8QHm4Wc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uJeg8f4t2zYbqXiq32TpqT6FSOTJrwTSh1OSPxciUMU=;
	b=1WgzOlZVb3RhIr0gJ0+4zvdAXrt0bQGHzNlwLwiW9Q8bozduzVQwbzsRFjtQFKE3feyowtUhr
	q76H4m0x8zdMxWUjrZ6FMVNheNLVHs/AVTwiu5P6OQqTF3D/bmdmA/o3aMQ9H+iJTMRygj2qpAV
	QKkfjanKarkhFarmx6ZNbvA=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4f0fYz4vHtzmVB2;
	Tue, 27 Jan 2026 17:02:47 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id AAD0040566;
	Tue, 27 Jan 2026 17:06:15 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 27 Jan
 2026 17:06:14 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <zengheng4@huawei.com>,
	<ryan.roberts@arm.com>, <anshuman.khandual@arm.com>,
	<wangkefeng.wang@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>
CC: <tujinjiang@huawei.com>
Subject: [PATCH v2] arm64: mm: fix pass user prot to ioremap_prot in generic_access_phys
Date: Tue, 27 Jan 2026 17:01:29 +0800
Message-ID: <20260127090129.412084-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Stat-Signature: dcmocg8p6kug6tc76j5abqtnaycwctt3
X-Rspamd-Queue-Id: 7070940005
X-Rspam-User: 
X-HE-Tag: 1769504779-751537
X-HE-Meta: U2FsdGVkX18hvQRWMotthAkSLxV/+fmRBnAOlYjO1TndFHfhtKP/zKRfLzjMSU6CGZtnK3gLcGttd6mJOWX+ndbERabWJPrWoJQHMw+FddHxv89gU/4lxlcy1Gax/CEDXJ6ozI7HiNKqsLpUHMTvrmHhEAc4s6Nic5IdcKTthbglhs3SB5q7slAONlMa6rO9U3v7nDkAZuqRyKVNN2jXOLHlksA8r8ab5FgtGKmXBcB965T9JCbokwTWKcFNifEXwCBQauuCGkHIGK/9FDO7iItD2szJXnDR6UrZwcqmR1OJL4bMWvYT5g9EYbf2jfrmK1cWizILh1FRzaYxfr4gHoTyh911GWdE0IZKVhtqFUHGGp/aFxOYdjoU24OtlY9eu8p5ofo7LB9Jr4pwQgG+i/37DrQZ7pUgXUrupvbMRlyRYr7sm+JU9tbC9UVB4z1CaK2P2CMFiEKz9YXEALQN+oI09gH4jcx4D9/olK38cTaCCaFgMVErq5MkpGI4oD3aliY3n94/27ZRVvYvKpgKABT0wGbA+UkU8+J2d8ycxqcf2xFZpybaIlT5BwGTAI+oYABRrwIs850BgbOybCiUNU2Gq99JGLJaVPE+uaBmLiYf12Q1EEP6YuHWfLe2IHRHCx2MALWW/jz+qdHRnlCbZeAdgE9igU9kuRfmD+SMqgUePPgmFbV2JwT0PknPL3fe9X6QQw7YeBDVMmCngRm035f0BY8KTg5sVd3NqGzV+vjsh9cEjDj+hlKOzMGG0i1qAco1Aw80i0GrfjZnmIIkvweur164ZeImFZ/ByOLYTB2tfRt4z2qBDFw3DlxmJPvwZjRh1iCdVvcBJjq+/KnHFpb8BrNVlb0DdVpR9YVhI/cMjP6whhNKs3V1XTGGThgUuIi1EWgDBCUnj4m1XYBOG75eMiUM8th8d6ulEP+F2R4CpMBNf19xrjVH2ZVLzEPo5nwiGzY4iPRGElxcF24
 iZsugAAq
 3/qEHP95wJwb350rqIwH3tghor8ijpYDLNWuH3E8eSc5a6Gh00KDlulg/dwBRYg+mx5vqSNgvCTFVvgGQhlQWzLH/BK1/jgSs0LMZPukuJd2c7hnDqxvfcyECofk50nznWdf9xXc7vIToSUIAGbDVjJ0BT1X9PSs8e6azdgERHtvl6OzFC6MF0Id0sVopM+0NhGPUyABJwr4RIk6mDF6qWWYGV651+zzKat1OJITFCiLIEQ8FYkm1om/pQ827lv3bl5S8QeQrob7SosLlVZvR3v7wOyuv3/67/C4HIHzxVzx7pccre42MOjOSbhvTdJ7LBxDPyOUXrVPqn6yUX4na5QgscQ==
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
Change since v1:
 * fix in ther caller generic_access_phys(), suggested by Catalin Marinas.

 arch/arm64/include/asm/io.h | 11 +++++++++++
 mm/memory.c                 | 12 +++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 83e03abbb2ca..fe8607eafab6 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -267,6 +267,17 @@ int arm64_ioremap_prot_hook_register(const ioremap_prot_hook_t hook);
 
 #define ioremap_prot ioremap_prot
 
+#define arch_mk_kernel_prot arch_mk_kernel_prot
+static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
+{
+	unsigned long kernel_prot_val;
+
+	kernel_prot_val = _PAGE_KERNEL & ~(PTE_WRITE | PTE_ATTRINDX_MASK);
+	kernel_prot_val |= pgprot_val(user_prot) & (PTE_WRITE | PTE_ATTRINDX_MASK);
+
+	return __pgprot(kernel_prot_val);
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


