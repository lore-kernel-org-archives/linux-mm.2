Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5032CCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE386B0098; Thu, 15 Oct 2026 23:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6C16B0099; Thu, 15 Oct 2026 23:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC616B009B; Thu, 15 Oct 2026 23:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85DAE6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:09:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11811C029C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:09:53 +0000 (UTC)
X-FDA: 85327009866.21.AB69D5C
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf21.hostedemail.com (Postfix) with ESMTP id 443031C0005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:09:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EH4OEca0;
	spf=pass (imf21.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
	b=GlO2MJSfiOjfO8I0GHY/SsxXhMzX0TqKH/O8hXiv62jxUc8Hps0KXNUfDODb71VjFWHNB4
	FZJeOHwDW1p8R8PEw/V18vE7/DlkBP99sjMdOJKk8I9PZ/xwk9sH57FVbgmZr58EHa5KKB
	+F4ks8+iBNmLqLgBH39hqwwEdwgCX7s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EH4OEca0;
	spf=pass (imf21.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120191;
	b=XKdgpLDY9MvVHB3hp9L35IIGlb69/XoVHBN9c68E1ifkYT2NA54T0pgsCypNb7c+aAl2BE
	3zrdvXh/QtAuUn1LaK3j3N2pKsrzh+h6Hc/w+VkaxAoHmqsX8IBcaJTywqwQ8ZOQ11tMe7
	hlkOoK4DahxypeppUoUNcqQVviPfpcw=
Received: by mail-pj2-f9.google.com with SMTP id 98e67ed59e1d1-3a51696a650so3488968a91.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792120190; x=1792724990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
        b=EH4OEca0RU+fEATlyEwSNdNTn/xSqicKr5HhRMPU6W64jhSy9KAyZwuVO+9ygxLZAo
         JyF5XfwEyOffvDB7J8Rh+cPQebtFijWHjR7dcWluc5eOUZ5s0TWjB4dilmIP0a8+l12U
         u8yB1C6VPNZ9NjDR2FcfvtWVH1HeQe+xDObHmm/7Lts2P1zXy0wO3wHg1N6uykFnLYBJ
         WQLw/vKxMOawi+a5Mm7iCEcNi1oe0QUyIOIoUD2ITM5OqGbt3KlDQIndMc0/XWpOWxZP
         m1OACXEpAbspF94knqUaLdIVFFGSeE8SrKMvV3Dm/kNLy6z8fGYPln0mKTthgI2UX3Jb
         N2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120190; x=1792724990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
        b=dOOaTqE6FAhU10jHNwZ26r4lptmHAL+te/KhyQ40+4zEQZNWBXFnNkHZhYYkYNmd42
         mQoedfV2PaKXdH5cFCUykdwVlcfirehXX4sRg7fmEAp/zPiO+hUN+noXHXsv6weQmqp4
         IqyK83knb/MrBo0mauU/7d6bEmoRakUCoAl1Xu+F//UVXybcTM8Gb+02WGZwZV6FoeNY
         41/ubZSWnuAK+cFQprCjzDs5LJFqEwx/t0QqgYDuU0dzStpJVSfSzo/ac0JwX4cGHwOR
         VV55+x9gaXeeCnXUH0Z76WiHOwIDyb8EKb0FzqizTsWbDCDP03lu2UGa5vzdMCP0/NVr
         hexg==
X-Forwarded-Encrypted: i=1; AKwUvByzUWb6zlH+GQlubc+psBAIZtokdIodXXrUR9GrMPXtGe8sZMKP9/DekHHZGd/3jU9fbXEqIrnwRg==@kvack.org
X-Gm-Message-State: AFq9FYKV61XGgFCjEoLB1YphLcC26xtkwOscFjbvUC7efln6A6W/tZWf
	TkHY0d712ZJcTUNTBAOQFI2T1e5GjzO5hI/YCfegubADGMf0uLGHdY8v
X-Gm-Gg: AYBFou0U+mU4WfhPnoPrnBaP8FqXkMkGNYU+ERELYSt0BjIXyy27GXa8CqsClU7aUBG
	4KWA/LK6XzEfaSOHDUzV1fy4fsoAFx3FM/SL1ex2dWd9+2Lorzm44twyb1V8husfSVfSxuzjagu
	VIYyqaw4I1UWDva974DTiEik473euRFEGehzghblPXKJDcd889laWD7vnE1SCicVpey1oqpiy93
	Iyw6EmdyBdoGUUuoRMrZ7jOmQt/1bybYlDLi6R7hDG7T/jF03VrWePtpLh7WSK+o9vdApnyy8Hp
	K7q9u5XLemT/avo9D2apC3aFwEyK29BwjeaKxm21QYu+tjpW1pxU+tOCjK1RRJBQMPjAtloDMwF
	nrXNw4u0XjzHOyiA2BJdS8tkPpRVkGO8jrkWNznblB4aLI0Qnk15ihzPsisZse9BQ9UBmcvyiWV
	TmXFrne1GM1NmrQj+X/Uh5PwEDgqylVQCjfbNWcQew/ELkwKXt4opoZNq1XFJ9F7A9Z3TT6prlK
	g5MPWvVewk=
X-Received: by 2002:a17:90b:35cc:b0:3a5:147a:3b63 with SMTP id 98e67ed59e1d1-3ab3a33db36mr18094196a91.8.1792120190079;
        Thu, 15 Oct 2026 20:09:50 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm370085a91.4.2026.10.15.20.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:09:49 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v8 3/8] crash_core: serialize crash header preparation against hotplug
Date: Fri, 16 Oct 2026 11:08:50 +0800
Message-ID: <20261016030855.4062882-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016030855.4062882-1-chenwandun1@gmail.com>
References: <20261016030855.4062882-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 443031C0005
X-Rspam-User: 
X-Stat-Signature: 6cqsuturxn4qnergbyfw7wtuppu6j7cg
X-HE-Tag: 1792120191-89330
X-HE-Meta: U2FsdGVkX1/4B2XXu+/D+rh/u8u0adp0Wxt8FTSQc/MS59KOK3cloFcdxIkriOX3Bx3SUqP8hdWFSujU3nUGbPmBcD3VX1iWa7QirH+wf1GRkzlaH29VWu7C2xv+RqEf9rawlJtuW4pCBuAXSnfad6Olhmc6hl8/5askrhywW02C773qz9/8zVlc+6X5pg6e7VX6LrjPRGigEsZBSwv5vKd3oLP3fW0JjDhOsLNJ0AfdJ+xbMc5/TptnxBiK7IQDAVWSsKjiSFUb51BWsaCAK353ZobMHvbzedYA5I66zPjUgMavtYRg7q55e3988GXYxKSXY0YcVeCgCijs1mFMryWDqkUKNvxce40pEEyc+rwFwxyxqP2VkA/eCHEdla1FhXMM62QzNQBZeqmrmiRcYWR1T5R/8GrxzM44acWeNvd9UIKY3L9PuBtPKnBgQVmNCl1RzwtmlNGbcMEwJt1FRTO+DmUxTKYH7JqWqeaJsbAF89TX/zae6vbM2uzIIx+E83MQu7jUqmQF5xelBNqxpm3GtfpIEM9oX7PeQ2nSYqEeLxUMkGJrDXc/EVpTHXqqt21oXi+L8ndzAc1Eyyr+MmUXetG7UFzPDsCcv0VVhunuKbDSN1gkiJs6zQPzETWkM9MO1a2Bwzpa0671rcYcth8bJ7H4WzM6fVkl6gDEo76q71YP+oSrSKsrVbBcO+2kXcBU1uf21lP+5Ljd37ak1U9X6B7lrmX4t/RP6Iz4ObKL/xcLAeQTQLfm1nosA3mwOrgI6ciNuuJxV/CU2WsqFaECtkjjYTNAh5AkYQRgV3k5Tcg4S4JEqpxNK3/wzuj9lVC3/YaLE1/IOaQQMQwoZt5WHybetmUGKocqe7St4AxP4Rh5ELBG5tulKNi44F8g517cjokY0XQbhBu+vEtLRnRfRRLtdwC1lLic7Nm3kU++EKwWg5sT/1feBT6Vqt7Xpn+D/Hvz5gMy8N2iAGb
 ZcBzXnc/
 cXPxqpQbUz4z4WnerOVxKLfhEwiKV2fccZ1qLWMjDy5YK4InP3+Pyds4lQGxKEAEGn7+Qq7fKxENNeQyA2yvLhGe1du3iOXPzMxx8u5rUEt8y0Nzyjtja4gnCwXAk6ud+JIMcoRoKNTXC7wdmzUxkbfoPkd+WcdrLsIc9fFIIkQXePg5fNMEEeAAHW++F/mP3tdTPI0enWF9zibpePe3mgwTxATpvHmEClF/EJ2RivuAgqbCuEbsoiTibOM6l1k/+ut5r83ATfoZqLboGIiCxbj2KASUf7wpttusfWvOBMkmcSgq5RBvbAQDoi8RM5e6L5LtHQtnkbAKJNQ35hORV4Kd8ES+O609+u0nWXJ5657PUSpBFp+bB9BTo5MwAqA/y42YwTEZa9MTkvPaJqQgCMYVPQt3na/v47cDIwRjR1MlxgJLKqnnlgJgXDEX00+MSNlBawQ9PH67jLt4EAFB7i6g3Ljsqh1ipq8TkQyxTm16ty9dxGxDshkVaCVbbsT5MZ43futR9+P2AzmP5Ssm0UT2+ttcHDw5snJ8eiTgZJN5AH+jvQFxFrPSGGqsSwoyZq0Jf8FmPB47qZvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

crash_prepare_headers() counts memory ranges before populating the
allocated crash_mem array. The weak implementation used by ARM64,
RISC-V and LoongArch walks memblock.memory, while x86 performs the same
two-pass operation over system RAM resources. Concurrent memory hotplug
can change range source between the two walks and make the populate
pass overflow cmem->ranges.

Take device_hotplug_lock when preparing crash headers during
kexec_file_load(). The x86/riscv memory hotplug path already takes
device_hotplug_lock, so call __crash_prepare_headers() directly
to avoid recursive locking.

Sashiko reported this issue in [1].

Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel.org [1]
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 arch/riscv/kernel/crash.c  |  2 +-
 arch/x86/kernel/crash.c    |  2 +-
 include/linux/crash_core.h |  2 ++
 kernel/crash_core.c        | 17 +++++++++++++++--
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/crash.c b/arch/riscv/kernel/crash.c
index fe5a4b306aae..ac8df2edf2a7 100644
--- a/arch/riscv/kernel/crash.c
+++ b/arch/riscv/kernel/crash.c
@@ -70,7 +70,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
+	if (__crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e6f23933a6df..bef008a0cb22 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -465,7 +465,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
+	if (__crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index bc087124cd78..28e7a81cf263 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -61,6 +61,8 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
 				       void **addr, unsigned long *sz);
 extern int crash_prepare_headers(int need_kernel_map, void **addr,
 				 unsigned long *sz, unsigned long *nr_mem_ranges);
+int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			    unsigned long *nr_mem_ranges);
 extern int crash_exclude_core_ranges(struct crash_mem **cmem);
 
 struct kimage;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index faa0f22dbb41..8a861a946e26 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
+#include <linux/device.h>
 #include <linux/kmemleak.h>
 #include <linux/crash_core.h>
 #include <linux/reboot.h>
@@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
 	return 0;
 }
 
-int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
-			  unsigned long *nr_mem_ranges)
+int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			    unsigned long *nr_mem_ranges)
 {
 	unsigned int max_nr_ranges;
 	struct crash_mem *cmem;
@@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
 	return ret;
 }
 
+int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			  unsigned long *nr_mem_ranges)
+{
+	int ret;
+
+	lock_device_hotplug();
+	ret = __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_ranges);
+	unlock_device_hotplug();
+
+	return ret;
+}
+
 /**
  * crash_exclude_mem_range - exclude a mem range for existing ranges
  * @mem: mem->range contains an array of ranges sorted in ascending order
-- 
2.43.0


