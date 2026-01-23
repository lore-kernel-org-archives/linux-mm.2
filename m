Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D0AD6CFBE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FABB6B039D; Thu, 22 Jan 2026 23:25:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5466B039E; Thu, 22 Jan 2026 23:25:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F89D6B039F; Thu, 22 Jan 2026 23:25:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA136B039D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:25:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3740314085E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:07:18 +0000 (UTC)
X-FDA: 84361742556.12.67CBB63
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf16.hostedemail.com (Postfix) with ESMTP id 163DA18000C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:07:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DjPSqhCh;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769137636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=StPYHwUSDQufhHQWKnr8XsQlJ7qmJI/TO11gqzFkJJE=;
	b=pLpLdsu0FZcquGl8xduXKT9FnKm9hjyUt9c4R0+ZwlOWvsb2ypd0luKf6oOMqJmoa7spU1
	R/TLK0Py+bwx8umqEeW/zqzyNgylnhhvdiAfp20hC3mtlVWIkBxyx4EX+jaA+D9pRRokZk
	e9g2qJbxAruAmIhAlb9wCtjobE4ZcW8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DjPSqhCh;
	spf=pass (imf16.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769137636; a=rsa-sha256;
	cv=none;
	b=7EePa6ysCsukDuzb+qRKA3YYUjkN/R1xra+5MmZMuBPbBXzQpJEn5OD6+aDhd7mnr3JYPU
	AFFShqXOsdZXnvvenhJztDC4BGadaRsBmdacDn6JOT1wnYaUF8E66iDAIMqYF5XRnHYxDz
	sXqwJovNRnLdKeu/ryqCq00zPK6z0qA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=StPYHwUSDQufhHQWKnr8XsQlJ7qmJI/TO11gqzFkJJE=;
	b=DjPSqhChlLeKEVvdwep7OhMdiR4wUbke766gZUGGVFjPEjwHkGNWatRFsGG5VcBAvZhKSYssu
	b3MSkRYIc963vleNWzIxNPeElso4WhaLiw2f4ogfnGf1C3jfqz0XVmrb5uym8Pehj8Zu4tAfiiP
	hifE9iN7DxTnfdhZSDPT4r4=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dy2nX0D0czmVX8;
	Fri, 23 Jan 2026 11:03:44 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7969A40565;
	Fri, 23 Jan 2026 11:07:09 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 11:07:08 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <zengheng4@huawei.com>,
	<tujinjiang@huawei.com>, <ryan.roberts@arm.com>, <anshuman.khandual@arm.com>,
	<wangkefeng.wang@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>
Subject: [PATCH] arm64: mm: explicitly use kernel pte for ioremap_prot()
Date: Fri, 23 Jan 2026 11:02:38 +0800
Message-ID: <20260123030238.835748-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 163DA18000C
X-Stat-Signature: 8f3tcidbxzgdbiskbswtocexg1t7dkum
X-Rspam-User: 
X-HE-Tag: 1769137634-499620
X-HE-Meta: U2FsdGVkX18M0kuV4b5Ibb9CBWiOrWCqeJRbgug5bzCGw/198N2GlDwWzg/TYm3NHm1QYCj/u/284BiphTxLn+p6/sBdm2mZ8IvoQ9iBL25j0QUgd4MfFFIwD7cDk4PznTBKqDIXauymxQFNO238Cw0V6usllM+UDXnLTml9RwoM/EmgZuQ6g0LBI9oAOR1D/ezZbUq++vTIgCvJOhIxRzvRTJ6xby0KZIPvvOVm7R91dZwa+/PSew+JMMqxDc8Gsf4d4TNLdLLWfdCFbOJQ3BK2t3JthfOKIJdpBxV7lzGpLYnqL+UzOVLCe05P974furj0x5JOkaT/E8AaJu3oQqk7WXjVozaX5J2W0nUID6ZUetm4Xzkjb5v0otbxNNnxalsDGgLmA6pjMHAkvOmvnB08Zbzc62V+gJcDHaYr92WIQ/g3j/vBMLcCKZBiK5RwGW7TbC+9rVptJwBQXEZ2hA2fl3+eK5yZdkoAy1onaDYT7712CeOHJx4L8UuSoSNaP5zJ8XBqdobRo0ZCuSO8u7zsPWESn4fBpqKNT5bGOKR3MpXlSIPXFF3wV2BJI1qC9GlIxFP6FGKZ4fp68ifyft2izFzRLNEVbUpsJcBCBHeWnQZYLwn0jekvMSFRCJf7qPO6vm/8JWfwA3/5JyIh5CqWyGjhBTni+Nx5Ppqh8oeO005F/9yHjCKOk3v58RmVPqYSTRVTf5QxnOUGUiSzceTZv+3MA2UDB1pjWqG2fqkgol5w+OrH9WUWiDABIJZW4wTzAvLn+cncDPRl24uctOlEM5p/q3OQqFGJAi0EDl6xL3rzSPWEZy8em7EYksKODa4AsRXPOy+rVX99QzBcL3mFiw/T+55mj2YxiLNsbGBq4uHJLAdp1bd8X2yX5qNJX7NDhbbKKh9VDtiPd0dtJnFV65NdxWCHxwJMTZ9ETDjeaxUm6c0+q1B8PC2Ehoc9DM3VJOC5et8YsBXeJen
 eyfu7bP4
 e2toZz/HxsT7RYjC0rY6mZgY/XFol2GwwT28TbfrI/dLcRoiYo54kB2OgdoS20ycpZ/5GRyFV4gHunJbJnYXEu4/s6nKP+7RCpB15XWT9c/Z8jeHJ2Yw1XDJuXda2cYteRoYP0AZRQoc95NTQB4t1TXuVA1V0rii4MLK+Gwv759rH+aRdnz4v2AUddQysJPotzzcsr9IwUFK3LHuAQet8kW7tH++p+v4giVsgYZNkm87JOT2IXUlQaxeke9E+ve+yRoH7J1XIAGxnZVZkcrDYuAMcqGiFYWyxhsOpJUl5xDUHB8FNsBWqeaJsIPgFfFvzGRkt0kCAFAIeFz0wedF+pNc+iw==
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

To fix it, similar to ioremap_prot() in x86, use _PAGE_KERNEL as template,
and update PTE_WRITE and PTE_ATTRINDX according to the pgprot argument.

Fixes: 893dea9ccd08 ("arm64: Add HAVE_IOREMAP_PROT support")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 arch/arm64/mm/ioremap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 10e246f11271..78a63a14465f 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -18,6 +18,7 @@ void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 			   pgprot_t pgprot)
 {
 	unsigned long last_addr = phys_addr + size - 1;
+	unsigned long new_pgprot_val;
 
 	/* Don't allow outside PHYS_MASK */
 	if (last_addr & ~PHYS_MASK)
@@ -27,6 +28,11 @@ void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 	if (WARN_ON(pfn_is_map_memory(__phys_to_pfn(phys_addr))))
 		return NULL;
 
+	new_pgprot_val = _PAGE_KERNEL & ~(PTE_WRITE | PTE_ATTRINDX_MASK);
+	new_pgprot_val |= (pgprot_val(pgprot) & PTE_WRITE)
+				| (pgprot_val(pgprot) & PTE_ATTRINDX_MASK);
+	pgprot = __pgprot(new_pgprot_val);
+
 	/*
 	 * If a hook is registered (e.g. for confidential computing
 	 * purposes), call that now and barf if it fails.
-- 
2.43.0


