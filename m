Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5A9C61DCD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB016B00F6; Wed, 26 Aug 2026 05:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB25E6B00F7; Wed, 26 Aug 2026 05:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06516B00F8; Wed, 26 Aug 2026 05:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6A796B00F6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 198AD1202EE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:49 +0000 (UTC)
X-FDA: 85142888418.22.C757605
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf11.hostedemail.com (Postfix) with ESMTP id C9FCF40004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="sd/H+UNC";
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yLl9In8Wv4o0ZdsQbHCo1Df/gDSHHkfLMajcmTmIOU=;
	b=aDCYdW8/FEcQQYhkDxuWDlwbU27W1eMZAkiHco3XdEOEz1tClUhKvb/C5FK54VGtn8stMr
	H6WEfYNcwyIrbU3vkzEPMTLZFudi53Ww4kqpzmdCuoMp49hPPIO1lUjviO6lK1pK2UPMX7
	5pMvfh8g3T/gq9HKtz3/KUPAZAi7qFk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="sd/H+UNC";
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736347;
	b=h5ZtuFF8bYTSoDkZXLxMiKt7B/C5UsNUaBOQgX6Bu1HESikK+S7tEU631YSdcpr91uElNK
	YTmMXl4hPcyBhkaM6aXAq4Fp3SymZcZfmgeHfGzv8CcQjYh7iLaKE6n513je+qjjvOsz/M
	CN+7QWq57r33gqlzjPutzo5xd60g3CI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3yLl9In8Wv4o0ZdsQbHCo1Df/gDSHHkfLMajcmTmIOU=;
	b=sd/H+UNCaNAatBnZBdwzX8iqrWgk9CvZKeHro8YXwCBizriBg8j/ic2nCnNuWmYjOd30NiN+s
	o0gHA+GVWfBZxWfQc5kddUQtVkrxsFSTSz7Qz2UeV8XoAt1UtBiJcSp4/Oy1mZg78qh4xUuqL3O
	bguC9nDFMKh9jB1NsetGV8w=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrf3mV2zLlXB;
	Wed, 26 Aug 2026 17:14:58 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 298AF4057C;
	Wed, 26 Aug 2026 17:25:44 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:41 +0800
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
Subject: [PATCH v3 15/17] crash: Simplify CRASH_MAX_MEMORY_RANGES handling
Date: Wed, 26 Aug 2026 17:25:39 +0800
Message-ID: <20260826092541.3905933-16-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: nfjccj8pdxy784y7addkzhjccdey99oi
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9FCF40004
X-Rspam-User: 
X-HE-Tag: 1787736346-905234
X-HE-Meta: U2FsdGVkX18NbVzLMcn9bPMZUULLKkbwNG9IQzb5o3dY9JZADf2/81Dcp4mnfveaIqgzK2nShRkbDXLeYAuGveCc0GkAuvWGmCrsVCfMWZvNXTf6mOFsEAdWwvFY+MvCUrE0mfAC+9W+joL3a+ZjgY47/Prp3mJTlQATevxa7NlcfONqZj/qcZ4NquOTDHdjglD12CTT8Ujw1Yo52X2wTGgcBQ/q3yK99Ws7Sq3JVaZM+3yBAWmqdqvNaXSc4AXW0MSWhaitSrMsV2AijSuVkDwyPliIA2MaxU6skG7H0RqRLj0SOGuslG5NDQL5v+zhI0xk4GoqGcLv/Ero7bSMNdlnEaqVSnJEherVW6Pe90LVN9I1hINr7YtyPNcpTjq82C3CMn+UB2g3brhl8i8Q1ljlhYbd0GQWsXEBuQFEz3K+TwiVzNunkbZiIFl5ra4jAiguPely7bUURZeZn0Uz9yxMgMx6UVk0Uc0Ionpz7RMfdz+IPkEEpUgj4D/BIplsQ6xpgyE0kM6SuGJgAjlDbdAUYRAL5UyED6HGqnCA8i1RsBzCdlVf1etlhZKPmpHEBN6sFWqnbk3Yus/SsqqfkzvqX0wR5vRFKejxSpAsLXCK24yArtKS277IlofN3wCEMUr7AHwHouLYQkBz7VB49WWnb/7BRTbeRY+qOh/cuybh5Hh+5IUFnWmjCd93sxbiJgpdhuwXBbKXQmH4A8LwGv0uGrwtWewudRGvZomqS+vgrf30zH5mIXCOBqja2i7fN4EeEH83atnpyi8E79b9OpMcLNGzn2q0dS6m7Qwo2efQNwipoDt4rZYEnGK6SLbDxuKNGLc5SHY8+GsLoajwMFW9GYxgsbDLjiD0hrxy+kQStbxcoxWaw77WaFS34Pks/hL1DuKYgRqkD+gnY9GFprpz34q/KwJy9PJ9OPbXt64WtKlOCz2k+JIRwR8gjvfMSEIVUTvm0+RtabRrvHF
 HYbAiyKr
 TXmnVeSL3YuIylHnkznWJw/sLyxd1/1sKKhzznL+sf7hLe7E8MD8txXLeTbmvRK+bTZ2kdADVIkMA/oWl7TG17ALN7sNgGIRNd+1K3eFHLx5lHuetas0kwOWdYX5ysOBrRIc3UyYvNkZL3M3k4e5bRXM85/0c+C44eq4OztwaiD39TgBvYc7w4EL+hlyW7SqvXECHVEibUfJHqnhccB0urz7BYZ1vNwSm7lrNfDgjtixxJBlT8T2prRb6Br5ZN8vgt+AZN5jAD1OUQJyFGscwxQM5yALrtPIDMw/1h5JhLgeBO/NGqQUQbXNvXAUqA6iihAuKgQ4DxrHbUE5v6PAAZUQE5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set CRASH_MAX_MEMORY_RANGES to 0 when MEMORY_HOTPLUG is disabled, then
remove the now unnecessary IS_ENABLED(CONFIG_MEMORY_HOTPLUG) checks in
powerpc and x86 arch_crash_get_elfcorehdr_size().

No functional change intended.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/powerpc/kexec/crash.c | 4 +---
 arch/x86/kernel/crash.c    | 4 +---
 kernel/Kconfig.kexec       | 3 ++-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index fc0105c7af4c..c47e3f867ea1 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -474,9 +474,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	unsigned long phdr_cnt;
 
 	/* A program header for possible CPUs + vmcoreinfo */
-	phdr_cnt = num_possible_cpus() + 1;
-	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
-		phdr_cnt += CONFIG_CRASH_MAX_MEMORY_RANGES;
+	phdr_cnt = num_possible_cpus() + 1 + CONFIG_CRASH_MAX_MEMORY_RANGES;
 
 	return elf64_phdr_size(phdr_cnt);
 }
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 99eb8583d932..116410ac90fb 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -407,9 +407,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	unsigned int sz;
 
 	/* kernel_map, VMCOREINFO and maximum CPUs */
-	sz = 2 + num_possible_cpus();
-	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
-		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
+	sz = 2 + num_possible_cpus() + CONFIG_CRASH_MAX_MEMORY_RANGES;
 	sz *= sizeof(Elf64_Phdr);
 	return sz;
 }
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index a97ed9605602..e6251dfe451a 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -160,7 +160,8 @@ config CRASH_HOTPLUG
 
 config CRASH_MAX_MEMORY_RANGES
 	int "Specify the maximum number of memory regions for the elfcorehdr"
-	default 8192
+	default 8192 if MEMORY_HOTPLUG
+	default 0 if !MEMORY_HOTPLUG
 	depends on CRASH_HOTPLUG
 	help
 	  For the kexec_file_load() syscall path, specify the maximum number of
-- 
2.34.1


