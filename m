Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80128C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971906B00A2; Fri, 18 Sep 2026 06:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921A96B00A3; Fri, 18 Sep 2026 06:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775696B00A4; Fri, 18 Sep 2026 06:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A33A6B00A2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7628A120637
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:34 +0000 (UTC)
X-FDA: 85226448468.13.33C2DE8
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf28.hostedemail.com (Postfix) with ESMTP id 365BBC0008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ecL8AZSB;
	spf=pass (imf28.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcjawUwcF+Ipqrmkc8OrDyT490KlVJ99NxRKRbRdpXA=;
	b=v5O0pfZq4q9BCGAmxOV3iHB8UTKXD1TvRZrtbJa+Ax65NIalo60IDT+g0GraCwqBCrwKRr
	VPgftbUtdW+8PTjCnFEnjvq0fGQXHOUAjbbnvfYyAKewoO74qCPgtIWZ27TIuOy7hph8hf
	+ymZjCGYbfK57bKBESVURN54Cc31zcs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ecL8AZSB;
	spf=pass (imf28.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725872;
	b=hasRmPQp5AYeNGAMuHnFW5NSscBeQgGUTVy6L383SCt/bWSqB0NsYpkADKetepUNF8ETue
	kdOubxAjYNU+lx0hJP9jUFBpL0tvBeOiyQyBLARAcu69k+2WTQryxP/vjLCYkHSdVNerE9
	I3GImuE1PtlLr1aRuuS1NZC3a088IOE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fcjawUwcF+Ipqrmkc8OrDyT490KlVJ99NxRKRbRdpXA=;
	b=ecL8AZSBtNZyNEDhb7BkDVSF7YYpJKkdn+Gr4NAiy2DW2kneIO5+g5PmiFfrGKL5IsFrau7oz
	vJR7SAcg2qXV6KQen8h3kFQFaWecc7ZPX+Uxz1BuGMnZIWUhkXy3p4JcCeGOa99CANsaYD4jLJE
	M1oAwIx3bIJ0dBf+uImYDDI=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hmScQ3fDWzmVX8;
	Fri, 18 Sep 2026 17:53:26 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 948334057C;
	Fri, 18 Sep 2026 18:04:26 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:24 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<ruanjinjie@huawei.com>, <gshan@redhat.com>, <ardb@kernel.org>,
	<james.morse@arm.com>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <liukexin@kylinos.cn>, <guodongtai@kylinos.cn>,
	<maqianga@uniontech.com>, <zhangtianyang@loongson.cn>, <blum@kernel.org>,
	<adityag@linux.ibm.com>, <chao.gao@intel.com>, <kas@kernel.org>,
	<vishal.l.verma@intel.com>, <seanjc@google.com>, <piliu@redhat.com>,
	<jbouron@amazon.com>, <me@linux.beauty>, <mclapinski@google.com>,
	<graf@amazon.com>, <bgwin@google.com>, <eric.devolder@oracle.com>,
	<hbathini@linux.ibm.com>, <takahiro.akashi@linaro.org>,
	<lizhengyu3@huawei.com>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<driver-core@lists.linux.dev>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v5 12/17] crash: Fix TOCTOU race in crash memory range collection
Date: Fri, 18 Sep 2026 18:04:37 +0800
Message-ID: <20260918100442.3841135-13-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 365BBC0008
X-Stat-Signature: j41wzrg9wrmp8gb1btj4115k68swtn15
X-Rspam-User: 
X-HE-Tag: 1789725872-424938
X-HE-Meta: U2FsdGVkX1/Nv1rh4UW4KyTtLioe9J7Rc9RWogp5PVo6Qwe+ObvC9blO9ZlCAicpo7lXowQjzDDUOT9RAw9/mZvWgbc6mHBbq7kFs69KeBGOVjr/il/pXH2kiBY5K8K9YM34FPM7avK23yHf9vFirZfMViXUJFl2fQfO2ESjKEuoMrD3QSV53BNnOYYgRreczSGbRO91FlPvkEU632g4cpAUY/NXN8prvQTkwlA0rghqhb08WPdW9o+TNkOPUlyZt6seX0FUC0Hlo49LV13eYg5jbS0HFtTZsf5Nkc7Z6D76EATOvohrna/9hZEUp3MuvQCnZH3QC5YzoV0YWFj9uFSaqa31sSLL/ENUKYu4XGBxrOmPTMXDzuZzFd2L0Ru04xCBzbzxh4uTDu/Mv1jCGW5w5RM0jOqlFyMaptREHRdaon5h4zW7saBRjwMwy3qoiob64JKGUf+gzHbSTtBQjHxcbwnM94Ke1g2rCCSR5uw5ImtTz85Y62YDIjdJzAqIgY9dIAmTXjm48tqhCoXCRqbPNTl1cVMysTFwUF/FQcxj+LXLeWEw8OJTcQOOmmxRU8+ozGTWlfa3DWgZAO4panYpBZB045Bwo2GPw3nQUML2RRABL9TBjV4TJ1k4yVY9rU2vFWWeBf6WCL9wGVeUr5eBWXJTlHWmEsZchmsyIWrQ4Qs1/3yW2e7nm2KzRRSkxH9ac2AOYZaNBBkVbea4TqNpdwN++vexLDdgroCufq9b5xvSNbTNGqo1nCrBYIaStqXQuv5LmA62j1R46Qz/EK3NLeKdth734NufGqE7/xUG75R75LHd4SdbX5ENNXnqzo4luc4nEQ33u52VfjgTRubgO89RSqXkhNoL/ArG53oQ4xDMEpQF7rW55st+PsCFSiBsmpcszz+4h7vZRj3u6jzuhFdTXmj2S3EX/YQ/FGAPggXquAtl1eSTOwe+Uktq9x1kvo7yPEuPMBhhJY5
 /KclSEgE
 sxfqVG2vyzb9gMpAg4kEP9mX2Mzlj9Y402FXCey9et7dpkcOOxCGnxHuFCwHwKW2S0JwbINdX4reIS/Qdk2RQVr142FrPmlkEshHpwlWnNPgYS26CH0QlJ59pZdIs/R9y7h6ojx3Kekmmrf6zcuN8buxY7XKMMid4F6xIAk3a8n0fQ1qMk0Y2FdSCa5h7tk3aF0CWNQZzoz+83QxPciM61InEcE/abN43reWlDfg6EUqlG2xujGb3JYRC0HMbPJEMvqTPa2mY0SkaLOAGZgKxINQ7+EkHUunqE/4Ikg3Zyi2sjUG0jbHRPNqCIeLSEyUU/rHqOX0RClZiW0YSmzms1Az1r1DLpZ3R8ZNg/FBYbAb8KcWz6Qqa39iZGdU/ol6Ay2BUW6PSSha5IKhercAIcByiYfBbxFXaFlRsmssWl0/hHZraPeqCS45JGhgzUvLLp0NIchufGAw9iHh0MLRqO+U1iGRIVLpOp0U8O4YwHxLss/mDQg0lLOgVAXEKTwUl9KPMeyBB/Pmtls4iyzZHeuzMsT/nqybQ/eK7//+x8VW0NpPV5vaAYYF3aLqD0u/eZxoWB+j2CMjqgd7lL7yv+t/zhCIBQt9JfmFPXafIUZnwiFa95rjWtxZ4tWb6U9S2OPzYpuPeNoMgVLUW3vcBtFWEloVQZKP4nQdLULvirf/2GFxhB6Be9hFIjGehpq3Qq12qVvPrgJqCnsNnuI3W0YgJu/bMqmVr9KWhBo03/hfvAtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The crash kernel ELF core header construction counts system memory
ranges via `arch_get_system_nr_ranges()`, allocates the crash_mem
buffer, and then populates it via `arch_crash_populate_cmem()`.
This sequence has a time-of-check-to-time-of-use (TOCTOU) race with
memory hotplug: a concurrent hotplug event between the count
and populate steps can increase the number of ranges beyond the allocated
capacity, causing an out-of-bounds write. If the event triggers
memblock_double_array(), the memblock array can be freed and reallocated
during iteration, leading to a use-after-free.

Protect the entire range collection with device_hotplug_lock. Since
the hotplug notification path already holds that lock, add a lockless
helper, crash_get_memory_ranges_nolock(), for use there. The regular
crash_get_memory_ranges() acquires the lock and calls the helper.

Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>
Fixes: 8d5f894a3108 ("x86: kexec_file: lift CRASH_MAX_RANGES limit on crash_mem buffer")
Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/x86/kernel/crash.c    |  9 ++++++++-
 include/linux/crash_core.h |  2 +-
 kernel/crash_core.c        | 28 +++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index f34fa8dba028..7fa139725514 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -447,6 +447,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
  */
 void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 {
+	struct crash_mem *cmem = NULL;
 	unsigned long mem, memsz;
 	unsigned long elfsz = 0;
 	void *elfbuf = NULL;
@@ -461,11 +462,16 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	    image->hp_action == KEXEC_CRASH_HP_REMOVE_CPU)
 		return;
 
+	if (crash_get_memory_ranges_nolock(&cmem)) {
+		pr_err("Failed to get crash mem range\n");
+		goto out;
+	}
+
 	/*
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
+	if (crash_prepare_elf64_headers(cmem, IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
@@ -501,6 +507,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	pr_debug("updated elfcorehdr\n");
 
 out:
+	kvfree(cmem);
 	vfree(elfbuf);
 }
 #endif
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index a740757dff35..1296a9b29974 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -63,7 +63,7 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
 extern int crash_prepare_headers(int need_kernel_map, void **addr,
 				 unsigned long *sz, unsigned long *nr_mem_ranges);
 extern int crash_exclude_core_ranges(struct crash_mem **cmem);
-int crash_get_memory_ranges(struct crash_mem **mem_ranges);
+int crash_get_memory_ranges_nolock(struct crash_mem **mem_ranges);
 
 struct kimage;
 struct kexec_segment;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 47a4579eb97e..760ca9822a13 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -7,6 +7,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/buildid.h>
+#include <linux/device.h>
 #include <linux/init.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
@@ -317,7 +318,21 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
 	return 0;
 }
 
-int crash_get_memory_ranges(struct crash_mem **mem_ranges)
+/**
+ * crash_get_memory_ranges_nolock - Collect crash kernel memory ranges
+ * @mem_ranges: Output parameter for the allocated crash_mem structure
+ *
+ * Gathers the system memory ranges to be included in the crash kernel's
+ * ELF core header, excluding the crashkernel reserved region and other
+ * architecture-specific areas.
+ *
+ * Context: Caller must hold device_hotplug_lock.
+ *
+ * Return: 0 on success, in which case *@mem_ranges points to a newly
+ * allocated struct crash_mem that the caller must free with kvfree().
+ * Returns a negative error code on failure.
+ */
+int crash_get_memory_ranges_nolock(struct crash_mem **mem_ranges)
 {
 	unsigned int max_nr_ranges;
 	struct crash_mem *cmem;
@@ -351,6 +366,17 @@ int crash_get_memory_ranges(struct crash_mem **mem_ranges)
 	return ret;
 }
 
+static int crash_get_memory_ranges(struct crash_mem **mem_ranges)
+{
+	int ret;
+
+	lock_device_hotplug();
+	ret = crash_get_memory_ranges_nolock(mem_ranges);
+	unlock_device_hotplug();
+
+	return ret;
+}
+
 int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
 			  unsigned long *nr_mem_ranges)
 {
-- 
2.34.1


