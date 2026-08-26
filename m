Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC91C61DC7
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9846B00F4; Wed, 26 Aug 2026 05:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9837B6B00F5; Wed, 26 Aug 2026 05:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7863F6B00F6; Wed, 26 Aug 2026 05:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A63A6B00F4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD5AA40316
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:44 +0000 (UTC)
X-FDA: 85142888208.23.7C98289
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1556EA000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=a4FvfvUu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzYnNWc+0aB4Y51Iy+zQKodek72TzHHBhe+K3gEl70Y=;
	b=R1DuXfoeqE3h9uX4P54y5rLDfarwmwtAim7sisQBR8iUvap5Bb+2j3I7sUOmUxkpYlARrS
	AK62egrlsIj3Q+9iUR1S9FYfuc4nwo4rYxCN+xa71jQQAtaX2RNL6B0TxUH3HKlxrzsW2o
	bvR9ZtuHpqXTIOVINqM2ZUXkxnaqVjQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736343;
	b=byHKaR+T0tFwX5zmSeix6uB2254dcDhVJ9IvVQ1KoFn3dyX11jjCNey8aVCe1VLnrv389C
	LkwQRRvA5PCIVKdbCw5J4bu975EbYrmiof/icV2vCwWKq32T4VAh3hWikC6m58wee6Ufup
	R142Acd4BPX6n7Ur0JbGJ2ZzIVSN7SA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=a4FvfvUu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KzYnNWc+0aB4Y51Iy+zQKodek72TzHHBhe+K3gEl70Y=;
	b=a4FvfvUuiPTNABc2iMv3KAutqTC9WA6DvBebvxBhfcer3DCSOZtOe8dnu5/s6ElI+Hz6bAesu
	k9ZrFJCpO2/U2n4yp9si+ZX4XbqFPVdaqbXWYPHgTDZXPRlwV7Noj7RLHuPe1f5ibu5kf737x31
	Mw6bPQPLfS53XujdFwjx/Bk=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hVJsB6sKyz1T4gh;
	Wed, 26 Aug 2026 17:15:26 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EF8940537;
	Wed, 26 Aug 2026 17:25:37 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:34 +0800
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
Subject: [PATCH v3 12/17] x86/crash: Use num_possible_cpus() for elfcorehdr size
Date: Wed, 26 Aug 2026 17:25:36 +0800
Message-ID: <20260826092541.3905933-13-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1556EA000C
X-Stat-Signature: j8gkmoqybjxutbqswsm7ydhz4mayyi7b
X-Rspam-User: 
X-HE-Tag: 1787736341-543351
X-HE-Meta: U2FsdGVkX1+lUKk+rBTNpwbXDwxC0cIg48hqJbpKL/AIS3iVv3Np1p1pYcKAJ6XSz/ZiGHjNYAZmf6EAm9l+JGdGLMt2sC/hqA1g0uV3RpZWa2z28mRvhz71ZH3OzkJmig6amdNl89c2G9L4U9FRIX2xduhvsVkDr+OggkmQW7NP8PRb/7k+aRPQpE57OQ3OfzF6xe5TXZLUKzdXB8VP4Yq2HQiZLGaIgEy7KsljMg/XwCGpinI8MueTSDqOHgyG3AwyUqq8lQdLGj8wh34cAGHn62aZvkpg9ZsuxPhbKV1W5fyhXEquhjkJrH17avDEIDQ5bUxRliy3d16nOovDL4GZovzgdQ4/tFxK7Ub0tWVWH6iIFYdEmPGhlQUW4/49wD5lqARefzXYXy1uB8WtxjtDoONIUBSd526dhMpwuBsHhJZpRaw/j6k5SM1KR/MNN6XT10wDuLhbL5nZKm6H75KbMB4CE671j/PBXM83yfNC6du6yoLL70KlZ9rkS1Ldl6xF+iAMgyeWz640F0+RvoFtLb2xgqzOyw8icXWquzSBbxnmcNfyHssBOZwKKCoOkLPVcE+t29gj9VX0bk0HlIRgz7pNuun7zrlKXGxteq0hLjz05dl15WH7QL8Etv9zcm9RZVqRPCep38/6I7fiVWs8ZGyPj0GMkFTiCZer2zqow87aBHzpdTtDtRV8JVmdGj2jkKLAUf1BpqEmAS/j5v3BtjBgnd8q07A5h7LJWBsLm0SyU/DfKeyFdANTbUyJiubywvRnwb5p8L89okDDrlsCwTE/FryZ4iW5YC5yaRtJokYQX8HsN3wH6zi3leJ7A9vPwO9G0Dg/qfxFBbzvV+hathYXiHzSVhuE66N/iRQuveh63RPmCZOLwvbF3d7dYMPH43+2AGhNM9zAIvDK+6ORnkNtcPWitLQL+HVb8j3Z3NxmCJuzcEAVc37dhUWwNzomqQ2QHN310yMWdX6
 vflYez1m
 inrPCCKJEETn2uIQrn29E7qUWI/WZ4ZELdFkuAV4iDW8nyM574srJU1kAI82TGq7PWXw/sKkHblC6oruuy86+B/YbzHQVIlSytlNQbZWUy6P22dHV3aYZdhca6XGA2GK/la+8IZjfUDfUivtHg1hL/EWayI6qYPTzeH4G0m/5quApIMFUrTmITIW6gZje7gfR5stcZSi1N2FA82beBtD1XO8KIYkGvrsKL60HOOZm2mPncqduduCqNXAJCuYBXbJiKAVOweX4j+mTMeMco4ijUK3O9NE62LI5O/GxY472gsOA6Ws2/NGHfVXzdIfFTIv2AuvD7b01hMG4XFNzeSRvvsto9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use num_possible_cpus() instead of CONFIG_NR_CPUS to calculate the
elfcorehdr buffer size, matching what crash_prepare_elf64_headers()
already uses for the actual header content.

This avoids over-allocation when the system has fewer possible CPUs
than the compile-time limit, and aligns x86 with PowerPC.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/x86/kernel/crash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a3bf786286d4..afe2aea19f47 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -369,9 +369,9 @@ int crash_load_segments(struct kimage *image)
 	 * maximum CPUs and maximum memory ranges.
 	 */
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
-		pnum = 2 + CONFIG_NR_CPUS + CONFIG_CRASH_MAX_MEMORY_RANGES;
+		pnum = 2 + num_possible_cpus() + CONFIG_CRASH_MAX_MEMORY_RANGES;
 	else
-		pnum += 2 + CONFIG_NR_CPUS;
+		pnum += 2 + num_possible_cpus();
 
 	if (pnum < (unsigned long)PN_XNUM) {
 		kbuf.memsz = elf64_phdr_size(pnum);
@@ -429,7 +429,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 	unsigned int sz;
 
 	/* kernel_map, VMCOREINFO and maximum CPUs */
-	sz = 2 + CONFIG_NR_CPUS;
+	sz = 2 + num_possible_cpus();
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
 	sz *= sizeof(Elf64_Phdr);
-- 
2.34.1


