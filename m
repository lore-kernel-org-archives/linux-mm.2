Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9BFFEE4F2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 18:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A6B6B0005; Sat, 28 Feb 2026 13:48:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538116B0088; Sat, 28 Feb 2026 13:48:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436A76B0089; Sat, 28 Feb 2026 13:48:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31B3B6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 13:48:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2A768AB8F
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 18:48:15 +0000 (UTC)
X-FDA: 84494750550.12.52A86AD
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D96540005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 18:48:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZSZePC8Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772304494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=H74amec8CzfoXlkOB0wYAzjTcma3Xj5McSUr/wEvuqA=;
	b=sWFRsiGPNBj8VqGmdkKdereNpThP0DJ0x+wR2equgSxJxocGfLfkF3icvrrqPYzEomrA1z
	knk3rVkoRDGZcPT9/Ky6PjOU3U6mPOqLvtbRc1qMV0WiqC67W87xdER9gI+cWbpkNfQatR
	ZaH2urg1wdcsdcvpNidBORnFn5OAOvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772304494; a=rsa-sha256;
	cv=none;
	b=kz+4tHP0t4JCBhWdNqI7VyGuE/co22M0r/NQR7YS5ThkSZfZ9giAMpvwf9HVf8HY/GWa4H
	Kh60s/U1tbnmv/BBEgAvYcUW/zzEhcI+BYOYQyUMPZRXRv6X+EVyGJ/aJ6mTs5seTK858o
	Ev/EIkZl/QKf0kp/4AxCOM5KvLul2TA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZSZePC8Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2adbd435864so12045345ad.2
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 10:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772304493; x=1772909293; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H74amec8CzfoXlkOB0wYAzjTcma3Xj5McSUr/wEvuqA=;
        b=ZSZePC8Qh1K/Iiy6R1tZlZjtaCZu/CbqwT+faT52R3LJrRZ4ab4VqY39so11Orz6Lj
         JGrdUzaPJAvgUqYbQylEw26qpBD/MXAqdY2bjT6+wvDBLYzonbuBwvwO6QIUDo5erHlM
         mq3TlMzPHq9uzS7vgjBzkQKq99J9Cg9o4BAFRBZV+EedMgnTX3YlfppSWI9l5bquZvXo
         22A/iXfk7rkzscE6Rk/3dx+u9AngTI++mEnRAco7yq/XFcPsxdij4T2dpd92I0yDsMUw
         /yOMSbzMPO9qXGuHXx05gktoAQph6Dh+H0dmj/07hc/NhyjD5xWt6hXIGkwEGGFMQ8Y2
         8BYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772304493; x=1772909293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H74amec8CzfoXlkOB0wYAzjTcma3Xj5McSUr/wEvuqA=;
        b=TkXoYw7ClQf4FK7iT/DKMaU1dXWXo8kFhL4N8qG5VPc3nTuVClh9FNVJu4zdrMPvxf
         qowOkgbjPS36HJx3eiocZ3qYQru0aUbCoHbT5xC27RUdqb4Kya1nLcp2A4QBFArZrzvM
         IDZKFW14aundrFM/QasJjb60QLC/+sSZETUXkhnII8IbA/sAYuJSNnU6m4m0zoR1rD6E
         Ne1UZ17lOnabK+6YFiqhsXTnhDGAyXki8Wtve1G2lytwC65mydy6QMO8qLaJ4vkbOqzi
         Ew/Z0j1o4g08HVpIwyf4/yGyc5dITrXqli72VB4VshEbPaSfygvuyqLXZHF4IrjEPcdb
         8xEQ==
X-Gm-Message-State: AOJu0Yw8lLP6q9HM4vfiJvgEpmZBu32Hmm/3V/nic1tD9x6hPizcFs1N
	MYQTkRuGVobstzdsFVn8nNXYBkv9XnI/1tqI5yHTuDyARw5EOWiRIoa5
X-Gm-Gg: ATEYQzxGuYq+0/zeLFtPxgFA24KFqkHp/6X9ARIybCaMRm8fBMpUYkSLsMrz6cATQPU
	iJloHE+WPF0Z5kQBgcoWFhAJFoz9NbbcIj4XiCtqpGKO77CcpIwhZUyUbqyav7fu+8PFWYtroPa
	Ao9CR6RlnUjbWp/1Z2Ak3p9yxQqcdhW4Uu7o1yMNiuxR3Iji9XE0CDFBKVV+4TYt4ut6NrxTcOS
	UIIQnjJP3LNhktzoRTvS3PwlMgdvkrCbAggJxzg9Q47JvwwZsE2sDKm01sYvgX/mGlLZhD29JGc
	BPdFZ6WacrqdvyKJllpOJLFP8cEhu6l5a/5ZMorkVXKRA7CCtt+YoaNDcJnNv9mOuOMczbF+oQO
	zXYdAUFvlJ6L/eml1BwTqr5ryeJ5SjE3NwJt3n4qEt8QkpDQ+XsmMoT7o6XxRdE4A7WN1+h3mQy
	tsUYMiVY/7QDq65vCct5dS3vOVl0RuGQ==
X-Received: by 2002:a17:902:cec2:b0:2ad:9326:3c3d with SMTP id d9443c01a7336-2ae2e4e2dbfmr73522225ad.54.1772304492646;
        Sat, 28 Feb 2026 10:48:12 -0800 (PST)
Received: from dw-tp.ibmuc.com ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69f996sm89975365ad.50.2026.02.28.10.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 10:48:12 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Donet Tom <donettom@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH] powerpc/mem: Move CMA reservations to arch_mm_preinit
Date: Sun,  1 Mar 2026 00:17:59 +0530
Message-ID: <6e532cf0db5be99afbe20eed699163d5e86cd71f.1772303986.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D96540005
X-Stat-Signature: jsbruab8q1wz5i4q3bfftxcxdhdd5jsi
X-Rspam-User: 
X-HE-Tag: 1772304493-270457
X-HE-Meta: U2FsdGVkX1+gsu1+kC0f2+W7m4O2djH1PCNRp2XI9/dg9ud7hOl0OQ31TQuB+9CDksg4jQiG54I7Rlp71W9e84r4OQg3JwG2W+E50xuy6zjdlMOlGymxzWZZYgESmkxt7HKizY4/xP/OsYq7hkqWMNV86ntTZlebv2OAD/dfd7Jcif45JJ4l5ZQ+T75Cx41cZ4sEyrCUa5Vztqjem7NuyLv4rp7YjJ5dYa7fZrLb+ScHPz4vJd+r12fQHEfMinSNfXiFYYOGeKs596zLkB1hQR0/D95PwvrahD43Hzaxo2mZ3t+sDnVVAcoioPu86RkJ3nX4IHWGt4h+p8Qpk7RDNbgt1yjTjJCw1VITL5WE4LwPELTAAX9edghXuCVgjhYDx0DIHqj7g0Jql3NQJf6RHk7WPde5/rsSjCvQZIuD6ghHNE5ncr4fCcxN5ieB2XhxtBmUzXsL/hfEhQxQynEQtksfERe5MQnDT/hxL1nGvynIloIVpuVqcFC8Rsghtfa+NcWUglHQUTofNrl9gIlBaaievQO7eH8ia/vf0CoM+6yyUkLNxpPwk255E9SqSrZFFAPcr2rSKKcJRqR0Yiwmr5NPYUJi4FTBJcYBQ/suruPeTXse5sEKpe1GNqM1W2jhuSz9b+rmeA/TLOFKRVM35eWjHyULo72FMHfOZfuETVE3ZDi2JryqG2e/svshJGH8J2codlSTAuUfCS214U/k41wYCvsTvUZeclo5ep2I9/IoROrw+9i6PNshjXzYy9PeAcPvt+mAasiccaooQD89tzp1j5ZGwv7PLLDHQhlokCTGpsubyYCWmFj0szo6bplafA+0k1cGPev67tdhjO7NkXviWTPbzgD+Tqe+eQm9345QlZ2J7qXekHvJuHUsmaimHY5cOaa39ZhFZCQyKSjm8y68gNB022t9yGEbqozEPFbp5xh+b/mK/kbxP0tSVF+ewm+Bx8/ehOBiVtZoNMq
 HhjIuGok
 leo7rp22tOgntqpPfieN6CJ3+CD7PFMB+uV2lE9HE5AyQHr2fxVjFiSmy9tueyc70vBpYa2Cp/QnilRzzWtOO2usn/aUtCugQpDdZbIJimY3HzZQ9Yzp+yGWMsjJGchibYVgbKg4W2tDtq0K6t7Y1Ne42TPaGOScIabtRxCkoax4cfSqZ+ZZeike1dclVAWb+xIqiQuY3i4/hg/f3NX2hIZX+hbREj9WlnhlidDDkCBK2XQ/uEhYOreVv4kQJbdGnvmtzJ28YkXS9/kFZfWryFQDhhjIQv8wgRNqUu+vT4+iCL/jxRNfzAf7CV8+7KUpCIagXU0qs3ChMWl8zk6enrZpP8Nq9NaP23AY4P8uOxwTmdK3bVmxJEUSlw91VGvMTnKkSjHu36bP/jp3VT1ap6QDN2gKh7rl+jdoeh5/aN/nvzm9YlVFx7s8DgCdizq5G8FLYLl+wYaEYOCRtwZEsdV5vY1uLM/d15RgwElISzkQSNfETdYVObppSROs7QOKUV2HbNajwQkelCybZupdXfE+BNKb7aVIM9PlVsqc97uzT5HBWSBDl8ikuo/W+X5fd6L+7Nsoev75QQryURgJqqM849dIhtxOcpElJfLQyUKNuMw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE memory model"),
changed the initialization order of "pageblock_order" from...
start_kernel()
    - setup_arch()
       - initmem_init()
         - sparse_init()
           - set_pageblock_order();  // this sets the pageblock_order
       - xxx_cma_reserve();

to...
start_kernel()
    - setup_arch()
       - xxx_cma_reserve();
    - mm_core_init_early()
       - free_area_init()
          - sparse_init()
             - set_pageblock_order() // this sets the pageblock_order.

So this means, pageblock_order is not initialized before these cma
reservation function calls, hence we are seeing CMA failures like...

[    0.000000] kvm_cma_reserve: reserving 3276 MiB for global area
[    0.000000] cma: pageblock_order not yet initialized. Called during early boot?
[    0.000000] cma: Failed to reserve 3276 MiB
....
[    0.000000][    T0] cma: pageblock_order not yet initialized. Called during early boot?
[    0.000000][    T0] cma: Failed to reserve 1024 MiB

This patch moves these CMA reservations to arch_mm_preinit() which
happens in mm_core_init() (which happens after pageblock_order is
initialized), but before the memblock moves the free memory to buddy.

Fixes: 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE memory model")
Suggested-by: Mike Rapoport <rppt@kernel.org>
Reported-and-tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Closes: https://lore.kernel.org/linuxppc-dev/4c338a29-d190-44f3-8874-6cfa0a031f0b@linux.ibm.com/
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/kernel/setup-common.c | 10 ----------
 arch/powerpc/mm/mem.c              | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index cb5b73adc250..b1761909c23f 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -35,7 +35,6 @@
 #include <linux/of_irq.h>
 #include <linux/hugetlb.h>
 #include <linux/pgtable.h>
-#include <asm/kexec.h>
 #include <asm/io.h>
 #include <asm/paca.h>
 #include <asm/processor.h>
@@ -995,15 +994,6 @@ void __init setup_arch(char **cmdline_p)

 	initmem_init();

-	/*
-	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM and
-	 * hugetlb. These must be called after initmem_init(), so that
-	 * pageblock_order is initialised.
-	 */
-	fadump_cma_init();
-	kdump_cma_reserve();
-	kvm_cma_reserve();
-
 	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);

 	if (ppc_md.setup_arch)
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index a985fc96b953..b7982d0243d4 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -30,6 +30,10 @@
 #include <asm/setup.h>
 #include <asm/fixmap.h>

+#include <asm/fadump.h>
+#include <asm/kexec.h>
+#include <asm/kvm_ppc.h>
+
 #include <mm/mmu_decl.h>

 unsigned long long memory_limit __initdata;
@@ -268,6 +272,16 @@ void __init paging_init(void)

 void __init arch_mm_preinit(void)
 {
+
+	/*
+	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM
+	 * and hugetlb. These must be called after pageblock_order is
+	 * initialised.
+	 */
+	fadump_cma_init();
+	kdump_cma_reserve();
+	kvm_cma_reserve();
+
 	/*
 	 * book3s is limited to 16 page sizes due to encoding this in
 	 * a 4-bit field for slices.
--
2.53.0


