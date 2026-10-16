Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39160CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8E16B0099; Fri, 16 Oct 2026 02:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA496B009B; Fri, 16 Oct 2026 02:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0026B009D; Fri, 16 Oct 2026 02:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 068886B0099
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:16:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73B70160354
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:46 +0000 (UTC)
X-FDA: 85327480812.13.607D67A
Received: from mail-pz2-f8.google.com (mail-pz2-f8.google.com [74.125.228.8])
	by imf27.hostedemail.com (Postfix) with ESMTP id A38C940002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sYInpT6t;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
	b=uPt94iQcS4tbLoAvJau8LLqZNTD1PsLZuoBiqoxGHw7QFwIF+wRoFFin4ufrb0O85Yng4V
	zLtzGdmILGC3dZeGEv9VOY86UA1qj69gzxW778ug1v1F9x42KRjveEEWepD0746jLwtpTk
	pvBTTlgVz+42BfgCywnsMVT9ydKDyuM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sYInpT6t;
	spf=pass (imf27.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131404;
	b=W8IODvJnK536j8q2vWJTUeUjiopbwL9HcNaV1/CITvO3gFUs2rYQR1zMsUl72FvdtCzB8W
	oKcSdBpvA3xqd2P3ypqo4bkxrOkEjFfKRi4sXcxy9I3xCq4vx0rdNeT2uEMhl9iTqWakXQ
	k+gJpjFFULm6rXQUvmYUC794jQVpME8=
Received: by mail-pz2-f8.google.com with SMTP id 41be03b00d2f7-ccb794ce92fso507497a12.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131403; x=1792736203; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
        b=sYInpT6tQUbhfUNSjztENu4k4STWuFOa0x1aTfZK9PAZjunM4jfKR4DlePF/I2oAlh
         oY3dQyQpHSeq2HAyT32J60VGPIrsrNAD5fragktxP4A1R0UDXn9nuWUgwn7wkj7eCCKX
         ywKWzGy5iHzIUk7u7PZktmjJS3hNu5RvyDV+Pq5qu+EaQbNVzE2JxTcNu6pEdGN6VECf
         MuELwFYjEbL/e7Vra1ZQOE1/F0OFjJQ+uPB0E59S0XifESCYDXgtM3fVGZsUXqXM84K1
         VUNvKa3vLSOLMCOvmQ3lZm0YnIQqXhpGB661FCq0Ykyi66kfCeDsJghR/U3Vx0hWFXwn
         SfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131403; x=1792736203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
        b=NJmjwXO/vuEwoEzw7tNnjDeb5VLF6AO0KZHSxN0/K8emyw+mXth5o2of29bBAYFKhV
         n0ja9urRGq/nrljTyCIQwiG7WRYfp2CZv1JCoLnR8tgXGLxRFMztTJxI3FnB4nj211bC
         U8J5wzO77YB3g1UyqtYPBQoQjIRYVooYpvH8Gitr9rZ3Qbmxg8+NGsfN7hxhEwb59/bw
         mCm1yHkDofchJKR595RjPAoO9mlJx7boxDvtVEZ7qNdlgMBVFqO6vqj7XkhyNQFwrIa5
         DJgfPFaC/cgap9+xQ2CaLOB05XQHPJYcb7AUtOKjxqTnqFsmsiVXfXAoPJNHSBIbM7ot
         DNAw==
X-Forwarded-Encrypted: i=1; AKwUvBxA0jUMIcYYQaOtzVmgxuAkVXJYpVs2xBy8nq+nwyG7VsupMGYwoBSUjlK1DAAK0PzHu5guh/P/JQ==@kvack.org
X-Gm-Message-State: AFq9FYJD+zOZ8aGdTdOymi3hDP9374pcZL+OKs5cnOOfwh5BcFHl5gSQ
	YbnV5YIBfeHjjk9ffqL5gATezh/LYT+e9CuPlNe3zuBwVDdO9pixslRu
X-Gm-Gg: AYBFou0gFCV78FPsDmT3Qth/MXIqMqzHT1Exsr0imyfMLPgigYC1WL9CyDfBhLYhQWb
	T+rQl861U+mqfAM8KCP3QW22HRECWqXQUpMfsFg0wBkyGdeSqryD6C/Z5pvM3rttdD8a+MbdYHm
	HRCVZAqQwhiMYBuZzcZm0WHkQ3GN9bC1aDlpMhHLlanW8Xdo46kdCiekYbF0F2wAgS46RR8rXj8
	OfBc4h3IbQ+jmUjGKD6aVOsSiHBcJXsRUPCS50RCIh4iyoJ5MEhvI3GikrCHKvfhmQTY18VnFut
	LUb13D7m4+FU1LwzokrP8P9X02QvKOUyqrASmmZcNFLE/C1wyNARf5ZH2cKp1MhHND/yn/JaNt2
	k8rpjZMbKkVgQm/PT1FG8cuVDLggCFssx0dk06nGEuptV973oOoCqRxdV2fSgJjhm+FifwnEpm0
	GpjwD1PZn/hvx3zM83gEedmMC5l21F3eWsSYN50mENT3/0HzuOqNnTr9PP7SSDToHEgcuH3MNKV
	44ru6RUMQY=
X-Received: by 2002:a05:6a00:2e87:b0:881:c881:96e8 with SMTP id d2e1a72fcca58-897c6a340eamr18515355b3a.23.1792131403430;
        Thu, 15 Oct 2026 23:16:43 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:16:42 -0700 (PDT)
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
Subject: [RESEND PATCH v8 3/8] crash_core: serialize crash header preparation against hotplug
Date: Fri, 16 Oct 2026 14:15:44 +0800
Message-ID: <20261016061549.4181390-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061549.4181390-1-chenwandun1@gmail.com>
References: <20261016061549.4181390-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A38C940002
X-Stat-Signature: 6wnb84edhfmea1c71466wbz6qjap5h7o
X-HE-Tag: 1792131404-480474
X-HE-Meta: U2FsdGVkX1+mWK6crcRiD2DBC4TBNZNb9aRatpUsTW22gbo6BAFuCwiBOyOQMLw7thyMQzfhiRyfl8W9p+qmWYxBbRaz+8wHzdKI9c11hUExlwnajhHHosTGpMpUJsaUY7vbpww9whIP7bC9mLqBBlA05+gz3JSUiUkHmFp2g214iZDbOwZJyrvck167FLO/yKIrhtb/i1CaCTDSPAaSjgxfY3zFlGbn72g+MwrEiakBQVUqEjYyyXtv5/QeFf6T6m/XWeU1U43cCnlbeSWj6GIS9iLgo8IQtaDpSFK7vcmz3kGc35VvfkU8qURnyG+ekSSjbHRhh8BDGB2VzQ3nSVI/PnbYA92HKKHIJZB2z28fq8gXm+NyD8o9QWRWUMSCxwGvr7ly5UmPxXa6pya6+mzj9hHxaYBP4JFVXp1/oQp/x+TBpkW5qgxzssL2ZRtf4k3omHwo/XEgbwmpvIXYeiA/1r+rpEeqJheKAt42S2DXFoDoSm1Xr2oNTepIfybHDDrtEahA1kE4dINdf8GFFj9IyMr4gnUs41wyWZQHTp/sSLU2gaZQu5b/jRsSNIF38unAiolXKLEjtvj2aIjAPBJvYgFZ5wAL8lP3/vhrWgQcCaPN0cQsGYaKxEkFrsHUp+xfSIp8vSxTdqBN8wjlcjGY7IfyJjTfVsug0R1b4mKe8bSTvh5d2xMktIOb12bNfj3M92FFEhXLtU6+RyTVzVJJ1e8n720VyBMa5ZiywSVr9tkfZiGTbzpMkkwG6Aiu00dTXN0zNKY2J+IvGwjh/GDijs5QDq1O8jqS8OmBQLSdmY/y97hZOm1Iw1oPQYjyT6aRrt08LRybS58UB7p0Z/qq9KpFpGQx9P5eqHO/UJAQiphj5hwHQ0kZH1W2ZaEYvhs+EjoGTjv0C2FrPO4lupdpW+Hi6rZ9w2FLs5h4tkJUbfy69cVhdBjtd1LRDA1aRdjtN6p5QH4ibLvwhyI
 ynyEMvb/
 IdZ2Wb7V1mbJ+02hOA5tKnrLfq7ffGy2asxjfU0NH9quHDwjnZPfGWu+uKPj2utW/XVV8hquBGpIsW1dpatcVACBW7Z7+3wxzWGsWzjccovmr4axfTvgjU+iU0SKSiig0ygms37T6Il18kFqripP+AiYjyD8eVpG3fHJuQb8MsT3yo20FdW9aKpi5yL+MYivHY26fD/1rMCMKPOVTANh2jPk6jw17ON1bG+kUTbl2+WV+bSdlGcgxrm/HKEcLn2X84V4gbOpmIG8DTALmf1mv/NBwIEYAwhRlAC2ev42CgAyZP8Nq8IxdFv8Q82Qgg9Ua86l+4tvtKNqVoeqRLhKq8Dfk1ftEfJk2dKHHZYzj+eLqnOgwMiotTtWGRT3ArH5iCv4BYJ3+UNPZFtmpglMr5oUAWF2bNkl3YrdpaqbQoAfJNoK2dbuOGg2FxiIKjmRC8ZdG7FRlvUdk5ifsskldWjzRYxgmAnhU9U8BTxAjMn3sMLyGlP97bBr4EF3r/cJGcib7GotmzYk336jZ+6g1p3J29Ztk/kvDs9WMIySTpQmgBe12nLW9esgSDkG7lcYAOvEhPOFw1Rh1IPWXSvDLvux3GSN01A3ow7DwAzQx5kwryFfMtvAYqVlpJOWWap4N2qUIFNHimL2SHgKxlD7SuTytHKWQKS/exCc7MpaCuetB2G8k7fDk0aVC9CfQBfqY3ZFik/m9wUbc22I=
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


