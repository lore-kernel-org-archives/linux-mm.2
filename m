Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71938C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A446B00F0; Wed, 26 Aug 2026 05:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6DA96B00F1; Wed, 26 Aug 2026 05:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90FF46B00F2; Wed, 26 Aug 2026 05:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66BD96B00F0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD0E6C02F0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:40 +0000 (UTC)
X-FDA: 85142888040.02.C6F95A2
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf26.hostedemail.com (Postfix) with ESMTP id A156C140004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GB6QEE65;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjFAkRrhVUTBFTsQMyUNsvLp/GHcd37S7PEMXZOcAZ4=;
	b=kR5AEbbEg0gEeFEOOWaUJhp5kNruoHKsiphZa9nmgAHbCYEExW7HDWkKpABHE6Zc1XGySU
	jO1oP0spEGJJfwyGa5yKScabunKtJMYJ+D2++xVNCoOE0IbH37IciETwwMaRg/mdI00WHo
	lxHPKp7Ptw7MCCAzPkXP2R9HBceDTsE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GB6QEE65;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736339;
	b=yDp4xr/HskEe1Pn8Ftgd79f9aX3SXbFqLAvA8MxJ9LE+NumDFKmo7svYZQ3IKeGlEjvxWT
	kFAWzRU2vnOZDdeXI5XdEaGl/IE0WADFNNkhXa52rHLvLbET8XiYCzK3Kdvj+R6Rynt6cf
	HWLMngqGeqI7Y3xR0ZeRMtTVxZNCpN8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AjFAkRrhVUTBFTsQMyUNsvLp/GHcd37S7PEMXZOcAZ4=;
	b=GB6QEE65ILKvCbQpXecQEb/ua/x3iezR7nE2mn7WyYvYlY4SUXxQ83iR38qyJiKIbAgDODNlH
	MU8cWojiXPCrCQ5dhsBQrS1ENBNRxVIcl10fi/R92xWzffLm8zRiqYcpNm7ebeVpN3c6nk/FktV
	hqwqWG9q2cn4HV8W9tiTxUc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hVJr24p4czpTHV;
	Wed, 26 Aug 2026 17:14:26 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D1434056D;
	Wed, 26 Aug 2026 17:25:35 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:32 +0800
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
Subject: [PATCH v3 11/17] crash: Introduce crash_extra_elfcorehdr_size() helper
Date: Wed, 26 Aug 2026 17:25:35 +0800
Message-ID: <20260826092541.3905933-12-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: s5pjusoidjdwtcditzeex5xaxh5pbc39
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A156C140004
X-Rspam-User: 
X-HE-Tag: 1787736338-781252
X-HE-Meta: U2FsdGVkX1+QWqwviQtkEls+q5a8Xxl4yr5DLrvFLgcMOeumIeXf6V82j4yOd8qtZWUkvLrqC25Siuhu5ife4brngi1UySHD0kMx9efytDeAguah8n2PdD+gcozMTg97SsCE1u0pGOpI3vCLn9N5G++8Xyx8xtaHXKGcvh1khC8BWIoUUVeJW3DpgGN2R4NlayZx/wvoom2mU9UyvAbDR4NKqmFEu8631DylaVsv1ZXVmRzsMOO/7Fzet7TNMR0p5GF9umvVOIzd6BvB8acyl4JDgjf5hUp5BjCNd8etelFFT60qwPX1TZUrC2OFdjg6tXuQIs2ZdTTDhyDg9ZBDNqj6BnfqXv1Omd6Xw04gzgkwDzvMCcZj+ObthViUPdYtk1bJjCDtPVhtQUXVesreJBAwG8KVliEj0IIv+ZfPX6Vn68OG2Ox2CIVsjhPMA3q/tXuJa3MYIEpkumjsHU9DpHEDukcscHBAZoQCljfH4h3onErk+5+mzJNp18m82SaC2oco15VOGMiXrHWklSdc6n0dxMsMoesIU+DQ8069AsdkeAz/cwnrTLvPRamQOAWov2nQqcEMc4OA/I6CboXilRNAR+inxpPoXKEGaB5iPdcilY8PbkYfFAEfmAbnX4SuzEBEJcTMW+XWp+2bikm3l5/j67dup1CazpSMO2X9UfmqlNOb5PkbGcMOIxdNvAraBptuRanDxCncKoKZ27d5nhQbtaLr1m51eRIaGahWcNqAI5DmoB1bGjh0VEnzbCuuz9chNoQFSPegQaYM2TSSJaiKmFl7LZXi+01uFdXhqB5KBz7XxWsIIqWjmFG3tNB8scgOVtyVqwWKrz4MXNG3jjZ3EFplmLZiuXMAzCmU04xy9/EXJPeUaSkVlRyKrynlv8mB2LveIF8KZ5RbLtplJb6TInIvpPV/WkUgSMoeyiUUWRsOg244mqxpDOhKTtiBs5yBjua8x/zn71QrFIe
 nKwTMl8P
 rO0HrxbV+m4P8/l5BgYYOw+saPg6gOeBy51jhv0/rP/losVivzeSEdmYIoMp58SRjKMwTQ9IUeHUG062lCSNsfhl5k78ITS3WSeN9veGVX9jM+o66l4GEqfIWpm54BJJoczab81U8f5cBIwHc6oWOjON6pkwzCv2oPppmxheiXALpAFvvgJuf0en1Zs5hymagQ7VGtfUcQp/F+chY3LZGvTxvb8v1l1wNHudPq6caOceVvw1X+M5QbOaqVtckyzUCEAr5dL1NJA94Q3lKS2Ux/j669tcIQzWEXui4tPgbQXP45xKxEYDcdJc5J5DZqusA/Xep13IgJx8aSm1Oe9paqwlRvMyQJgo059yzgvJIhg3BMRj7rSREK8wHwYGrDJtZraHjB8q3ftToaL2sdLAL+snbEeTQsfcc/jwGQ4LxDDsQoZeL4vNM7mda/p22JnfyFVmDEwpyS4DEM47+yxIMNQUy8LBl69LEo3s2gt62KODSdXMaAg4Zg5tlmckOEH6hbfx41iKQxCThSNHh8aWcrriO8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the elfcorehdr extra space calculation from powerpc into a
generic helper crash_extra_elfcorehdr_size() for use by other
architectures.

The helper includes compile-time and runtime checks, it also checks
whether the total number of program headers (including fixed headers for
kernel_map, VMCOREINFO, and CPU notes) exceeds PN_XNUM, and provides a
stub when crash/memory hotplug is disabled.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/powerpc/kexec/file_load_64.c | 19 +------------------
 include/linux/crash_core.h        | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 6075b1c88511..2b0325e4a628 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -374,23 +374,6 @@ static int load_backup_segment(struct kimage *image, struct kexec_buf *kbuf)
 	return 0;
 }
 
-static unsigned int kdump_extra_elfcorehdr_size(struct crash_mem *cmem)
-{
-#if defined(CONFIG_CRASH_HOTPLUG) && defined(CONFIG_MEMORY_HOTPLUG)
-	unsigned int extra_sz = 0;
-
-	if (CONFIG_CRASH_MAX_MEMORY_RANGES > (unsigned int)PN_XNUM)
-		pr_warn("Number of Phdrs %u exceeds max\n", CONFIG_CRASH_MAX_MEMORY_RANGES);
-	else if (cmem->nr_ranges >= CONFIG_CRASH_MAX_MEMORY_RANGES)
-		pr_warn("Configured crash mem ranges may not be enough\n");
-	else
-		extra_sz = (CONFIG_CRASH_MAX_MEMORY_RANGES - cmem->nr_ranges) * sizeof(Elf64_Phdr);
-
-	return extra_sz;
-#endif
-	return 0;
-}
-
 /**
  * load_elfcorehdr_segment - Setup crash memory ranges and initialize elfcorehdr
  *                           segment needed to load kdump kernel.
@@ -428,7 +411,7 @@ static int load_elfcorehdr_segment(struct kimage *image, struct kexec_buf *kbuf)
 	 * Account for extra space required to accommodate additional memory
 	 * ranges in elfcorehdr due to memory hotplug events.
 	 */
-	kbuf->memsz = headers_sz + kdump_extra_elfcorehdr_size(cmem);
+	kbuf->memsz = headers_sz + crash_extra_elfcorehdr_size(cmem->nr_ranges);
 	kbuf->top_down = false;
 
 	ret = kexec_add_buffer(kbuf);
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index 6789ff0af39e..d5981008a812 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -106,4 +106,30 @@ ssize_t dm_crypt_keys_read(char *buf, size_t count, u64 *ppos);
 static inline int crash_load_dm_crypt_keys(struct kimage *image) {return 0; }
 #endif
 
+#if defined(CONFIG_CRASH_HOTPLUG) && defined(CONFIG_MEMORY_HOTPLUG)
+static inline unsigned int crash_extra_elfcorehdr_size(unsigned int nr_mem_ranges)
+{
+	unsigned int total_phdrs = 2 + num_possible_cpus() + CONFIG_CRASH_MAX_MEMORY_RANGES;
+
+	BUILD_BUG_ON(CONFIG_CRASH_MAX_MEMORY_RANGES > (unsigned int)PN_XNUM);
+
+	if (nr_mem_ranges >= CONFIG_CRASH_MAX_MEMORY_RANGES) {
+		pr_warn_once("Configured crash mem ranges may not be enough\n");
+		return 0;
+	}
+
+	if (total_phdrs >= (unsigned int)PN_XNUM) {
+		pr_warn_once("number of Phdrs %u exceeds max\n", total_phdrs);
+		return 0;
+	}
+
+	return (CONFIG_CRASH_MAX_MEMORY_RANGES - nr_mem_ranges) * sizeof(Elf64_Phdr);
+}
+#else
+static inline unsigned int crash_extra_elfcorehdr_size(unsigned int nr_mem_ranges)
+{
+	return 0;
+}
+#endif
+
 #endif /* LINUX_CRASH_CORE_H */
-- 
2.34.1


