Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 793ABC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0D96B00AC; Mon,  7 Sep 2026 08:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A18D6B00AD; Mon,  7 Sep 2026 08:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A106B00AE; Mon,  7 Sep 2026 08:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB68C6B00AC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8106180156
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:46 +0000 (UTC)
X-FDA: 85186958052.12.AEED1F1
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3EC10180007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gR4Oea8z;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWYcbaLX2p2UByqhrLVYGoAeGhCajPS1DD+9MAEVZJI=;
	b=FN+YPtcmN71nLPo3vp/Mebj8UIxWss0/HsXAnZigRPzGBV6e5EzoOVHLZWu9l1v2HSxLuZ
	BKBNbLqIT9XL0vr16FzBlmPLEviuzSDWcPE/fs1AFmqhccIp/7JRlUgkJ9lDzuqwhi26is
	/6swjJJhCO2yPcyCkkkbEZNAFE5nbw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785624;
	b=p1PJwf8XeeBfhuAxUZjU3HgX3f0iyX0XX/2x6nti1t5GoWx3aLqziM8/NNNkshL02fS/8L
	9euuLdXv+JY5Y6RGVdwFDzQPJ/S24hkRAq6NC6q7JjXpmR8lxBXUOp+/28Qq34rOWTpRJq
	ltEzqY6iwJlzaBEnBngTg+MI6fXYX+k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gR4Oea8z;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MWYcbaLX2p2UByqhrLVYGoAeGhCajPS1DD+9MAEVZJI=;
	b=gR4Oea8zK/29aJ7RLHno9CLpbS4RZ5sZw5cTFB2WKWnzxU8xtNxJ2Vh7v1HG5zIZSPs1xEehl
	Xnka2BWgYoSzlwkTab3Mx1Kn8mGPYxZT91iczi4tA+JzWBxS4EWmLjnuDOuoM8o2ii+tfUIM5Qd
	oy3VxnFoymLznncxBOoBxy8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtp0hYSzcb4j;
	Mon,  7 Sep 2026 20:42:42 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 302D7203B8;
	Mon,  7 Sep 2026 20:53:37 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:35 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <jic23@kernel.org>,
	<tan.shaopeng@jp.fujitsu.com>, <zengheng4@huawei.com>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<djbw@kernel.org>, <seanjc@google.com>, <liaoyuanhong@vivo.com>,
	<vishal.l.verma@intel.com>, <fuqiang.wang@easystack.cn>, <makb@juniper.net>,
	<piliu@redhat.com>, <ebiggers@kernel.org>, <jbouron@amazon.com>,
	<mclapinski@google.com>, <me@linux.beauty>, <graf@amazon.com>,
	<bgwin@google.com>, <takahiro.akashi@linaro.org>, <palmer@rivosinc.com>,
	<x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linuxppc-dev@lists.ozlabs.org>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v4 09/12] elf: Introduce elf64_phdr_size() helper
Date: Mon, 7 Sep 2026 20:54:01 +0800
Message-ID: <20260907125404.922123-10-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3EC10180007
X-Stat-Signature: mywqfbh6xoy3krabo4k8dfgrcbg7bk7r
X-Rspam-User: 
X-HE-Tag: 1788785624-506827
X-HE-Meta: U2FsdGVkX192ghWkGEqoAq8dTn46Mqr3KZkpKvFa0ZmYwDc8N2JOT8hhjB48+boji0B13fbqY/0/JO4KS0+L2qKbZxY4wO8wCzbDeTCbPOEwVmIK2fpbAhSXubAHcLw8w03rTcM11cDGUtOWSo1qzrpARdgLQQ8GDfD+YEwm0vZx/tnfavI7qdiKuZMRwcRN7N3pVgrJhW8O8UJBx0uAuJ2rEhiEqUgZSDjWHnsCZlcsiEKqneJSw0fdmXtLIdTAxU6Quyrt0WG+QvZblYIBFuyNNP7kaK5CPtN12kTW8Qm4W3MuzrG9CNBHlGx5MZ0PaWkIodx7M4mJmqs4XIE8xnuWGdQEl2w+EtcE12IYI/6WUdsaEypeNoE6mmXNISLIKtWbhIdpZhu2qlJ4Z+5b7YIPXotZ1kipxKfVPdZ5tEpC9OU1qoIVGkGUe6NZMjXPjUPSbGGx5HawJYcPX3Vk1iIlpM4KhCGWNesEemMHE0DVgnM4Vo614J3ufnUq9QAEWiN5Uu/g1hTQOHyFBy18PEx09C1IYwHoThcOPRpLStYvxuIEo9xKCMXu9KmN4q2Z/XO2NWSV3C7Xrvob0vn9r21TyO2t1eji2aHwqMT5fN7isxxioyt6+m6ICWhekrvBSv9c3OI90SbS0u9iGCoX32eule7J88Z4pLmIkHasnjRRJa4QlpEVdbAPshkoVtSnW9CEPGvcyw7ve7Ln+96d+rwdyGr4zCw41rN7QmeAwKSqjee1eAHaAgtoH7z4hE2QVKGuviM+QSj40/Yk4Ax7/PmHEhHdITPTpRP702svfpKOf/MMnmBzKcgHn5B+LG0ZFpMkzzrIGa/MntmLQv1fbztLyT7Ipu1j8g7GTTiK5I/vyw0tSrv0D/W1c7U0OJ/nkrODdAFOY+TWqo2MZmc4/NjmUfP4YA43Cmj7wbptH26B1VRNIasA13vWgyHxEkG1svLnxuJH/tz0687AbfB
 EKeQ5K+d
 r7EM7MvQOdu/pd521r9omtQZMFWFdxhAhJAuqTp0HEt9RavbSwbVpQ3t837jUQh2DeEj7nN+EXOuj++E3gw7ZQEK7m5Otqm3WuhGNrRvq+tf2AH4+aW73ZZ9HEo3LNvzqIHmUxxIQRQX42/kgc7JpoC1oG1qIDbxz33NcpR3RvBjnoN7apv9LzexZnlo3e7wDRGovb1QwAzynqEalNF0fsFu4TWuXVPZdxSMw4HcH2DukH4lSTAycds7m+Gq2cUu0oXHT52ntb2uM/r2Jz9v1G/uOHvY9lEYiMb+EBmqgvCUZJPKCClDCAS/FjYZ+tCO4tmQoyB2y5QNzafgoPfn6FEfoKp5TCTmtz63nI3dzNuY7vya8BUb6F5z4Xo8wmyKHvbe1CNmxKdNurPOfLULVk7faav6I7y0QdHVVUrZrLRl9IsM95R8efG6mCgaNoARErTru5qPTxIymgKfplYf1CLWB+icQ1Gn/QwGObbfYEHrz015bQ5itqp9Quz7qSsStmAV9Nz4j1E4ApZ2jaqI409QCKnqZBMpIN+81C0xD7k+FMnHVK4lKHPaKlMz6i6SgtddoZXL9wvpzrNskftiwbVQKJG06fAEJqURkbZia5zkAAnBsLXIp+rqXtPxbp4iJ+iWX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a common helper to compute the total size of an ELF64 header
(Ehdr + program headers) from the number of program headers.
Replace open-coded calculations in powerpc, x86, vmcore,
and crash_core.

On ppc64, struct elfhdr maps to elf64_hdr, so the powerpc change
is a pure cleanup.

No functional change intended.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Kees Cook <kees@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/powerpc/kexec/crash.c                 | 2 +-
 arch/powerpc/platforms/powernv/opal-core.c | 3 +--
 arch/x86/kernel/crash.c                    | 3 +--
 fs/proc/vmcore.c                           | 6 ++----
 include/linux/elf.h                        | 4 ++++
 kernel/crash_core.c                        | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index 775895f31037..fc0105c7af4c 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -478,7 +478,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		phdr_cnt += CONFIG_CRASH_MAX_MEMORY_RANGES;
 
-	return sizeof(struct elfhdr) + (phdr_cnt * sizeof(Elf64_Phdr));
+	return elf64_phdr_size(phdr_cnt);
 }
 
 /**
diff --git a/arch/powerpc/platforms/powernv/opal-core.c b/arch/powerpc/platforms/powernv/opal-core.c
index 32662d30d70f..fc0aad61504b 100644
--- a/arch/powerpc/platforms/powernv/opal-core.c
+++ b/arch/powerpc/platforms/powernv/opal-core.c
@@ -309,8 +309,7 @@ static int __init create_opalcore(void)
 	char *bufp;
 
 	/* Get size of header & CPU notes for OPAL core */
-	hdr_size = (sizeof(Elf64_Ehdr) +
-		    ((oc_conf->ptload_cnt + 1) * sizeof(Elf64_Phdr)));
+	hdr_size = elf64_phdr_size(oc_conf->ptload_cnt + 1);
 	cpu_notes_size = ((oc_conf->num_cpus * (CRASH_CORE_NOTE_HEAD_BYTES +
 			  CRASH_CORE_NOTE_NAME_BYTES +
 			  CRASH_CORE_NOTE_DESC_BYTES)) +
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index d6430a593778..e164749c5c1d 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -374,8 +374,7 @@ int crash_load_segments(struct kimage *image)
 		pnum += 2 + CONFIG_NR_CPUS_DEFAULT;
 
 	if (pnum < (unsigned long)PN_XNUM) {
-		kbuf.memsz = pnum * sizeof(Elf64_Phdr);
-		kbuf.memsz += sizeof(Elf64_Ehdr);
+		kbuf.memsz = elf64_phdr_size(pnum);
 
 		image->elfcorehdr_index = image->nr_segments;
 
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 44d15436439f..ff324969d798 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1238,8 +1238,7 @@ static int __init parse_crash_elf64_headers(void)
 	}
 
 	/* Read in all elf headers. */
-	elfcorebuf_sz_orig = sizeof(Elf64_Ehdr) +
-				ehdr.e_phnum * sizeof(Elf64_Phdr);
+	elfcorebuf_sz_orig = elf64_phdr_size(ehdr.e_phnum);
 	elfcorebuf_sz = elfcorebuf_sz_orig;
 	elfcorebuf = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					      get_order(elfcorebuf_sz_orig));
@@ -1605,8 +1604,7 @@ static int vmcore_add_device_ram_elf64(struct list_head *list, size_t count)
 	}
 
 	/* elfcorebuf_sz must always cover full pages. */
-	new_size = sizeof(Elf64_Ehdr) +
-		   (ehdr->e_phnum + count) * sizeof(Elf64_Phdr);
+	new_size = elf64_phdr_size(ehdr->e_phnum + count);
 	new_size = roundup(new_size, PAGE_SIZE);
 
 	/*
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 5c402788da19..400f58a13d92 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -109,4 +109,8 @@ static inline int arch_elf_adjust_prot(int prot,
 }
 #endif
 
+static inline unsigned long elf64_phdr_size(unsigned long phdr_cnt)
+{
+	return phdr_cnt * sizeof(Elf64_Phdr) + sizeof(Elf64_Ehdr);
+}
 #endif /* _LINUX_ELF_H */
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 39feb39b53be..b57a81f38ef4 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -193,7 +193,7 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	 */
 
 	nr_phdr++;
-	elf_sz = sizeof(Elf64_Ehdr) + nr_phdr * sizeof(Elf64_Phdr);
+	elf_sz = elf64_phdr_size(nr_phdr);
 	elf_sz = ALIGN(elf_sz, ELF_CORE_HEADER_ALIGN);
 
 	buf = vzalloc(elf_sz);
-- 
2.34.1


