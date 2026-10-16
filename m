Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3B3CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3F56B0095; Fri, 16 Oct 2026 02:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C2D6B0096; Fri, 16 Oct 2026 02:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1B76B0098; Fri, 16 Oct 2026 02:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49A8D6B0095
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:16:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9345D1402BE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:33 +0000 (UTC)
X-FDA: 85327480266.23.B62616F
Received: from mail-pz2-f2.google.com (mail-pz2-f2.google.com [74.125.228.2])
	by imf02.hostedemail.com (Postfix) with ESMTP id CFFCA80008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:16:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d2krstFV;
	spf=pass (imf02.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.2 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
	b=J9U7PJXbrJ9ghRDsZIJoEcDVkHNuBInVUvWQ7oxD4o4Ilhl7Lbdo9a5UCU0nwI1/R5NirJ
	vYuv5bMsUMhfbcsp3Vy9unTQPESyYVppDwZBs7XqdNZfSHM6L/UpNH3OZysQMaybeTKVEA
	TNviYWDxp9DuCG3DDCs8yXVcZNaVLSc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d2krstFV;
	spf=pass (imf02.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.2 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131391;
	b=s3kE7o0nqAiiDF6JnBSgytAeFgB+RiGC7RmtoqJ0+tEE2oX8l4W/v9vccewSw8IyLILWzk
	pOt97AhZnDjMHeYHcqvaNbBD6CD9FyOOpwKds/U3UbB78lAJf2Jn9Ka3uJAIWnAWbAf9o2
	SZZmoxKt0ItzeiJVfxZlMhL+LOMCZt8=
Received: by mail-pz2-f2.google.com with SMTP id 41be03b00d2f7-ccc451ef3a7so604413a12.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131391; x=1792736191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
        b=d2krstFVkxufPIHjQXavkgb6MZfGUDnBbklZzYZTuBpuNqnN5W+v1JExKCok9Ihjud
         leLz4ti2QSdX3AHYrz8ymGiSkb6Jcqy1xvw10vlZweuuU0MO+c24URCDrqWLt0XMp/B1
         wtaJLde7eflLzE6WP4kZr7iWMq2fLsd6Ipzwo9rrQQBkHl0PTeWthBBGkzNAaL7QFPL3
         zCDNIpg8Sk6WxQSve2E/Oft0XSHuwRz86/4zTBQMGs17bK/ApGAIcKu2lMw1PtxYcgHj
         EtL2Vo/5SPakiLrUHlP/3yj9KEI1upLztKnCRWfZeGiR/YwYGf81ndAIPO1lWv1ofvTV
         TRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131391; x=1792736191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ChIsG9Vgmjf7e0EG0U79egn378mU9W7gdCp3fG4lF2s=;
        b=0YVqZVtr+1CpD8c/nU30J5rNpCjo/slPnt7zxFlGzJRZ0X9uBC8J/PXmHc/gEPy/rx
         jxBaHENhU/zFY5TMLPLI1kAnNmdDITyc75Qk0Pr2YoUtFPQuc/Htgqg8UWdC/ZtcLa0i
         KHIg7NlFw2UadnNX0P9y4NrGYFr+p31zs5aKV8lorqgYZEolcGwgYIxfTr4q1kb0dYbg
         LkWFNmTg10g3HxTejAVbxl39P6c7TzznpTtQ0hCoZeoW4eB1SLSe33ixGXuO8tEydwFK
         DhE3cn4Tmf/+msW1Tw1efJv21HIMHnZOCbzcjkh0eZjPqCA9KqapdiRijwzU8/Lftd4V
         8O1g==
X-Forwarded-Encrypted: i=1; AKwUvByK43G/OrOI0T6zRcwGY+bwALpQaFYPLu6t8Px2BV+3PYq+JVMNugkMd7gr8Tm8G7MjfD1RtQgdZg==@kvack.org
X-Gm-Message-State: AFq9FYJc9diG3zmA6Bjg9rDUf+biT6W6ZjkbYL/RoPGOvg7ZlpLYK0et
	C8xhs1sZButq78NJYA/Ni6eOJYUqB9N5vOvMKtgy88H6gEYFv4zIFzH3
X-Gm-Gg: AYBFou1thCfV3+CGxS7mgR7m6eUs5QbWGVLB55zpxoHwjPzlQ5AMiXIGOS2xAxFSxVx
	QgcBdF7JsyyXfkjl9Nxvd2jv1SfCg0AeiFuRRWLimnC8acQHiNZbdnL2U9tenPRXdOV7XzmLWtc
	oLHAVNrg/IP3gzZ3LmoeUGCWaJJatTYRyRCBvZZHdhfpFgQnoSBs0EGBedfti0jLanyEEXighBe
	JVrrBUjtL0wSspoCIQ0iKMeW8/PKY00S4+WrMfbhByis1QsrXwin7WqGJCz181X3IwCqTmmZwxJ
	X5KaX5ruKByRMH7uH9ttdWhUPPDUPiVtVF4CYaSEwjQdAvm4kzURJzAoYLJZ0gYFeof901FHr32
	d7JglbPM/GOGvFl+MdkDkPttuTO1WXAf3v9jVbFG4JbwQFFgB8Dl2nHUpEH0XPrzhSWN3xVEjqp
	TvaLTAgt49dMsh3qONhK+fPlDzvk+NMIjoSIySxS9sqZgogK3mw9cKqE1SeOmJyxDn8AS5VOsYc
	YP7UN6JG7tHHzbLdExTfg==
X-Received: by 2002:a05:6a00:99b:b0:881:5dcb:400e with SMTP id d2e1a72fcca58-897c8991295mr20719510b3a.56.1792131390645;
        Thu, 15 Oct 2026 23:16:30 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:16:29 -0700 (PDT)
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
Subject: [RESEND PATCH v8 2/8] crash_core: fold duplicated memblock arch hooks into the weak default
Date: Fri, 16 Oct 2026 14:15:43 +0800
Message-ID: <20261016061549.4181390-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061549.4181390-1-chenwandun1@gmail.com>
References: <20261016061549.4181390-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CFFCA80008
X-Rspam-User: 
X-Stat-Signature: nuub5uishmeqcrk9tyg8jj6iejrn83pn
X-HE-Tag: 1792131391-662117
X-HE-Meta: U2FsdGVkX19g4fx7d50CdY0D5m+lM3AFgYl/FiBtodHm5u9Fe8tSAHQQizfwMkrzuJD3BG65G874vHnixu9mMR/zp3PPwFCWYh+87K8xL6qUjkb+h84shClGEkl53n+feUHIl7D1AwDs6ww2qEQH3gAKn4grMTAsA1fQXBNbrgrBvVoaf+zJN8cWNLcGTcrYlYyRhmVkMercL2mTmnbaTmJnv3HT7vJJwXSNEdkuQcrKJ1ESrE8VeI/AtAl3YJBxSSzJfIquxonnF/leeu8IBSCpIbEmVG96TbW6RJ26VGzZgr64cIK/MMVME+U9/h+Ei1epzdtD8eCWmfVMa429ZRehUPejSzf90AIrhIdBW63EmKH1Fi3piFHcDGpLD1ycMtKrWMZpg+6SbDs3ziCmXC9Xtras6WgemiJqFbNWIQdvK+o/aCnw1EgEkNjzvpv57iDMSH7MzCgrbZRuN4HtpNhMEVUOWC1oJdMt3fhT454cH0mIb7oyyAwpWcZZbTnW8a3RuqAwXCrrxb3f8hgaBsOSBfh7NNBOR9RVzCvcmUQIVQjLxm3cCfJwJavg21alaWhCj85ajdx/Apj0xZCEFUQe0VRxsaYE2dKIyidKU30X9oCuyt8uxh7oOEKKIujnIl8ePDNhiAuZ6DNJk7f4mMI4nIuKprqn+1khOujRQkNXkwHr+fxQOgYu9BCJtbHskM1ck+5WJZ4GDZ2B+f8607FVy4K+2rJBKhzrgMIz973L3YoH3dCMPVbT6fpLbEYT5zcHVLm2jNR8QeLt4s6nU68+ACM367bTjd4kSjrUkr1KdLTWZY7MIJAc/KWnhT08xbfrtL3snMbCRwl+kVXeKhyYJc0fIyw0ToBUG6HokTw0KT0dzN+lq0UUvm7gNsTt/ETaq9OwfZOyA/d7fOsrprq81BCDqzgkriKWgUQJg6nK+f2dxn5EJVNni4N8xe34iILQHC8cNPOWorMQahs
 8f9YW/Uv
 lx3l/+WBExFuzbzg6C9sTGnEkgZ2W4nuwaazxwNMOcrwvWCdYT5AupS14bO80N5eMIYj3hs69axJKWJN4fMLEvPWGwWsPlXEi5vVpi5bGwpvDeMfmroXaj8ZvqcDBFop7kUli5L/2DIthN1XmbRya446aOCOMNOX/sm/B57qxvqT3whBKRPOyF1rZgW6vX40m7calWbgktv3c05C+LnLDGVbQ5UkOGu4gfQWjkN8Ev0858FA+bpnpoxSvGE2msGbgb946Y+wXKwvL8FQtvyFlTWDomzvIN41pA8emXvafQhRRBjEkeLJ3wT96JdkpCPQvnTkFsXI4ZeULcw8AkT/TuzUKfdmlT7mONZ8C0hFEy7ykK1cwK2ejhHFL3SzR+2Yq8nkpt282+HEFn2yMmutbz+wOnaUHkBZfmCvaeHLwqJAliaXPSAY7ffqpmhsX4C+UfUEymX4XBLP4ExZCQlpKGNRzBFNz4sBAsGuv7ljsDI4zFyeZIB5yu8m2hdEuIiU2s7pf/SHYjNyDz8dgSD9SrAsJ0zZGulos5sNS/Tk3rBXx0hJ8fqwkMWI2q3W2hWY6K/M/0mOyTBusyo105J7qYwDQZaunBwYRRyreEXpBSAu+zM1R56r3vbnkTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

arm64, loongarch and riscv open-code the same memblock walk in
arch_get_system_nr_ranges() and arch_crash_populate_cmem(). Move it into
the __weak defaults in kernel/crash_core.c and delete the arch copies.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 arch/arm64/kernel/machine_kexec_file.c     | 29 ----------------------
 arch/loongarch/kernel/machine_kexec_file.c | 27 --------------------
 arch/riscv/kernel/machine_kexec_file.c     | 26 -------------------
 kernel/crash_core.c                        | 27 ++++++++++++++++++++
 4 files changed, 27 insertions(+), 82 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 854d872dfd0f..34d944d3f22f 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/kexec.h>
 #include <linux/libfdt.h>
-#include <linux/memblock.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/slab.h>
@@ -39,34 +38,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return kexec_image_post_load_cleanup_default(image);
 }
 
-#ifdef CONFIG_CRASH_DUMP
-unsigned int arch_get_system_nr_ranges(void)
-{
-	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* for exclusion of crashkernel region */
-	phys_addr_t start, end;
-	u64 i;
-
-	for_each_mem_range(i, &start, &end)
-		nr_ranges++;
-
-	return nr_ranges;
-}
-
-int arch_crash_populate_cmem(struct crash_mem *cmem)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
-		cmem->nr_ranges++;
-	}
-
-	return 0;
-}
-#endif
-
 /*
  * Tries to add the initrd and DTB to the image. If it is not possible to find
  * valid locations, this function will undo changes to the image and return non
diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index 5412aa9f3568..481b8f906a56 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -13,7 +13,6 @@
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
-#include <linux/memblock.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -56,32 +55,6 @@ static void cmdline_add_initrd(struct kimage *image, unsigned long *cmdline_tmpl
 }
 
 #ifdef CONFIG_CRASH_DUMP
-unsigned int arch_get_system_nr_ranges(void)
-{
-	int nr_ranges = 2; /* for exclusion of crashkernel region */
-	phys_addr_t start, end;
-	uint64_t i;
-
-	for_each_mem_range(i, &start, &end)
-		nr_ranges++;
-
-	return nr_ranges;
-}
-
-int arch_crash_populate_cmem(struct crash_mem *cmem)
-{
-	phys_addr_t start, end;
-	uint64_t i;
-
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
-		cmem->nr_ranges++;
-	}
-
-	return 0;
-}
-
 /*
  * Add the "mem=size@start" command line parameter to command line, indicating the
  * memory region the new kernel can use to boot into.
diff --git a/arch/riscv/kernel/machine_kexec_file.c b/arch/riscv/kernel/machine_kexec_file.c
index 808e872f4063..fdc6695e8588 100644
--- a/arch/riscv/kernel/machine_kexec_file.c
+++ b/arch/riscv/kernel/machine_kexec_file.c
@@ -37,32 +37,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 }
 
 #ifdef CONFIG_CRASH_DUMP
-unsigned int arch_get_system_nr_ranges(void)
-{
-	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* For exclusion of crashkernel region */
-	u64 i;
-	phys_addr_t start, end;
-
-	for_each_mem_range(i, &start, &end)
-		nr_ranges++;
-
-	return nr_ranges;
-}
-
-int arch_crash_populate_cmem(struct crash_mem *cmem)
-{
-	u64 i;
-	phys_addr_t start, end;
-
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
-		cmem->nr_ranges++;
-	}
-
-	return 0;
-}
-
 static char *setup_kdump_cmdline(struct kimage *image, char *cmdline,
 				 unsigned long cmdline_len)
 {
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index d0bd2d0cf899..faa0f22dbb41 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -281,8 +281,35 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 	return cmem;
 }
 
+#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
+unsigned int __weak arch_get_system_nr_ranges(void)
+{
+	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
+	phys_addr_t start, end;
+	u64 i;
+
+	for_each_mem_range(i, &start, &end)
+		nr_ranges++;
+	return nr_ranges;
+}
+
+int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
+{
+	phys_addr_t start, end;
+	u64 i;
+
+	for_each_mem_range(i, &start, &end) {
+		cmem->ranges[cmem->nr_ranges].start = start;
+		cmem->ranges[cmem->nr_ranges].end = end - 1;
+		cmem->nr_ranges++;
+	}
+	return 0;
+}
+#else
 unsigned int __weak arch_get_system_nr_ranges(void) { return 0; }
 int __weak arch_crash_populate_cmem(struct crash_mem *cmem) { return -1; }
+#endif
+
 int __weak arch_crash_exclude_ranges(struct crash_mem *cmem) { return 0; }
 
 int __weak arch_crash_exclude_mem_range(struct crash_mem **mem,
-- 
2.43.0


