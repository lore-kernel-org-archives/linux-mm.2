Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 060AFC61DC7
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB686B00F1; Wed, 26 Aug 2026 05:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C8E6B00F2; Wed, 26 Aug 2026 05:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033976B00F3; Wed, 26 Aug 2026 05:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C57D36B00F1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB2301C165E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:39 +0000 (UTC)
X-FDA: 85142887998.12.1AAF7C1
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8ACD4A0003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZJrMcXmw;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KafofVQEPWxjkKkXavgX1N/QAvKy21rncyT7kiECYKY=;
	b=32AdiyJl1eTJpnc2HUmSukL3jN3TolileQFtS4xd85qsWaDL0k5d/WFucfFE88Uu2GgHjO
	OJ0xKZ2LwFrpco60j+DaSfXmTtzwaJeXqnIi1sROch2p9dlAyqvhfI5xDvarEqvi0Zn+sM
	YithhBOpW5+7X8Be5bGUFRceAJ3+xjQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZJrMcXmw;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736338;
	b=yYwdROk3GLFVRC4u/dIVZsDWfibko6LNJ4eIiscqVXtSlm2TTGgGk9zxYoQxCLiuoyAcEQ
	pmhjB5I4PekmmolU4etLnrIlyhiMHsr3wvOjG6BX7KKwomNfeYbMK9hYXLKJQb2DX/VYzw
	wIUZ3d8WFkONEY9EqOkaGk+sFrzcNeA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KafofVQEPWxjkKkXavgX1N/QAvKy21rncyT7kiECYKY=;
	b=ZJrMcXmwPlgzadHtphWXfa6syHPyy8XhgReWZ7UmfF+ftCT3E/BT8h8jt/WPwO9Gl7FX0Gdce
	FpBge1xJOiNT4y51fY4AFonznIyQJqB8mR//FJpoYo4ihkvBHHjsaciISJu+jrSzckYhIAuxH6G
	okgGEcDZkqcaw6iUFcDeVKY=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrQ6Fxpz1K96b;
	Wed, 26 Aug 2026 17:14:46 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id A22634057C;
	Wed, 26 Aug 2026 17:25:32 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:30 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<thuth@redhat.com>, <gshan@redhat.com>, <jic23@kernel.org>,
	<james.morse@arm.com>, <ardb@kernel.org>, <leitao@debian.org>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 10/17] elf: Introduce elf64_phdr_size() helper
Date: Wed, 26 Aug 2026 17:25:34 +0800
Message-ID: <20260826092541.3905933-11-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: pcsyebkcq1qok4gbex953mkmonrs64up
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8ACD4A0003
X-Rspam-User: 
X-HE-Tag: 1787736337-304569
X-HE-Meta: U2FsdGVkX18aPBQ6WH+8pLvO8eh9bYvG4AOodIxd89dzxbHEEQ7d8Q5j8JzL95bXYcAQogLYFl6/H8d1zzGHPBgvwIbPaJOr61lQ2/PcKyhBYhemvTiR12cg/TYs77efD7niO7Nu5Dcwf43SW36wxXXlwsKfa5/Ny7g1Hi7NQvYLb0gtT/IGdxnEGExhpPFvBaOUaOzTtv2oGwltu7aqO6A8d7aSE2emYvmDF5GfBhOEJ1bIQGcktUOETJmFMGU0epfGZV6jO7G3glWc5Pww5yQJ12Qv8PHAd8hZyAiMeNrteacx1UpVKF/7gAujutQ3iSXXpd+rClWAjxAxusu3SbEj4/AlNUSKMx3nUUqojKstVwzjdYuz3n/riAGWQvYx+RNQpbWbqXoN5QhgLTUoREDwCqdLQwxu5pV0v5183K2Jb5wffvdq1EMQ+AbH7dIhIlwgiyP4Jf6PVokQbdTxdhehEUwt33JMRBF4jyW68JV7vTPmsH0aucMXUjnm7mJE3xuc77JgSKo6MgnXpCGQoJt/M+oPEcE4ixB7fpZSmdR2EXE1+6TKOHr3sxY08WTpQmnlJkVE71JmtBwRrIViVnbfsO+s/RMRNCHR111MdQ+KMOpCsjSep6Fa2APr/xoFGRyF6k4TRYUH9tiMgU8NPU2ddO5c7r+r7i2jqdmbQhWoAvSPTuucRA7wORl3gAtiwh4abmP5+TjKWo1khODoR78ionzHy4j8AITZcqJzCMRaxIdeP+fzbwFnlnlOm8d/LKNXszt1tsG/E0ap1wNUQHT4TaZJgszwFuePitcEQs+xP2drq3BDiCzXRouqtiN1PJoPFxCAFPyDvz+GF97njXBlGpt3eAqeTIausV+79X5panD8n53kn/fgqeBJYJ8NuSSkvUaUWWEruxhwmMSDlhVWdqHTQH60pONAa0c35Och1lJ+MrJAydwtPkPCiGisPw1/Ev/7ud7NvopJ8+T
 vb245yTD
 3yfFr8RI1qJAt9RWlbdJbpV8krF6gzPHDWkOWuJZToC/1/xlcXOX+xka8bV5lix2YJsiLLsYu7UzpY59nfcrdTXUPWmEuXesi1RSY/j9yFUZAP5CHOCvATmlrDJrPWS8TdYumMBO6bGVciPG8znLw+EAFglcTwBTsa+mEVZF741lPSCPaF20/5NZzGNMxxLmT8hxw+xKdeq5Kcs/BPCt3KBC3bzHSh+XkYgV7gEojTwMmHCCk5kL1ngBwgDQalN6eqw9KDncfg0goppKVHU08FuPGOr4ZVQ8PPVZwJiyHyXpko/fGpY5fMQU8HY8YNZWaP2Xcl6q0VTN+vOjWgMwJniEEBtR/6yJ7pFf9niDcaXQIGjuLjV+HJZiRHS58LFdAzYYAxS3gKpqBZDPI9N+Sv1KCUpx4i0qJAlqI75KVh3U7sYoS4MRc8QNwit3TCz59huKU+UOpSxfcSZ39Bq9Yv5tN3mIk6SWiHI6y8tmvCPadoRh8W0oz6n76dGDDoBEwkaTJo0wQYffRPi56IfDv1x0x0obIXMiEmiAdFnvbS8k5thf23zMBH0xeD31swXCpjUnQ615a6C5hjLCt6BDszWjUECwrwbpGu/2g7Bg8ntpogE/1W0Y9maANk0sFEduixjw0
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
index 8f8c0e592849..a3bf786286d4 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -374,8 +374,7 @@ int crash_load_segments(struct kimage *image)
 		pnum += 2 + CONFIG_NR_CPUS;
 
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
index 05a2a8be083d..bd3f82b62751 100644
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


