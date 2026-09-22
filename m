Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4049C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9DAC6B009F; Tue, 22 Sep 2026 04:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EF56B00A2; Tue, 22 Sep 2026 04:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17056B00A4; Tue, 22 Sep 2026 04:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBC16B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:43:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3172160411
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:49 +0000 (UTC)
X-FDA: 85240760178.14.2DF0F58
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3792E20002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NAwg9xq3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066628;
	b=ao2b4JUCi7OGNhrbjSmUN1Uo1KrfmtCzJ4S91uJJup0PL96mILdY4JBg7xcLCKqZNjZCNX
	7c+d6ZdT1D6gpUNlUN+Arij5f7KdzMAMrBNG7uWc6+u4WGhxvSN37RWhvbLInlwSL8jjQp
	KzHl9fqjhf6JtSkZEZUVWEy5fecZnIs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NAwg9xq3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1DOWyR/dLH3AEbWE3m8aVGig/7kxpUIrM7nXUawY8c=;
	b=kBSMXAhFGxvoBwYfBfQLA/a3UQEBZ7TQXMGWSEuhWMpiRrkvvCLq+nv67mIh68uCD15AaH
	7SxwgSEmIHtmwMluqoePsVMvSes9rjs56r7S/PeSooL/1uHREd4hCAQ3GzKyvw4gqp21H+
	wI2crNXMk6XjAWKy16DEXgN5HwxPzB4=
Received: by mail-pj2-f0.google.com with SMTP id 98e67ed59e1d1-39f1e0b1f21so2644180a91.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066627; x=1790671427; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a1DOWyR/dLH3AEbWE3m8aVGig/7kxpUIrM7nXUawY8c=;
        b=NAwg9xq3rCV39B5ApDuukxcJumHLFEh7lYdBgIRms8pnyC90adBqaXORqQAUN+nRR5
         faeo7YsRABa8Y25YYDhsTTYqVsAdd2ZnpULLBjx4S/wg5bSntsL0tfZHGWIi9O2cMmJv
         YYlOlMRFjd+QCLETaCCHN935whKIhO4Q4i7LRiJAnw+ZmB+2/FMip0jBm7QbsZZS5DMT
         FHCvAdNwywP4Hy2R1wUWrE5cR3x89TuUTa+deEYXX36O0PYWvL/EbGx58rQz/eS4Jhlz
         d8kGOsrSRcPU795W6r2qR40q/v47gyB4gNJcdfWnELSa8lgl1uFYie9XorxTnreFYP7c
         bnnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066627; x=1790671427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=a1DOWyR/dLH3AEbWE3m8aVGig/7kxpUIrM7nXUawY8c=;
        b=NxaSk6ONMBsPmdmRJMcisp0rP2Wtsy0t2rHMyQtZ3Ua8G9ktjn2EgFCRDKqvTt7wBL
         5GxFmhzJtEFqmroJSwMV+rY27TZTUBlizTGIpHHOiUzDS6cPag/oNLnzfoz6z0ehPFbj
         0U7q7rMiRnEq410tHcBzIOrLzCNwdzZR9+hDDalHYvKlA0hxxDzH0/8Ag222hGPyqdim
         s0FvIXBJSWfIKRiEdlVDOYjpKJqy+LLGTmxAzZH8xT31y8y+iz6ziwZ6Vgb4VP5tqVTh
         d/1L0GwvoG8VyHXmdOwihuRCcQzO9/YqNQhewbAlcyVhw6xw7thjD9+4Z01RSRkmeiG0
         y+nA==
X-Forwarded-Encrypted: i=1; AKwUvBzQVwQctKBrR4WQkZqBY3CVtNuFj5Xtnnjvm6JF8bBJd8xQ4G9xmlrTYwbY/wVPSdmWVUbJGOGqFw==@kvack.org
X-Gm-Message-State: AFuF++lLyvqvvOY5aZf5yrpi1CvQB4gThMDo0OGAFDiwx2g0eC0xGLrN
	8B7Y7ICaGQp0gDgg8MiB9cH+q9aST46O6TX/nnmUpdEM7/Kfn/BiKwEg
X-Gm-Gg: AYBFou1El8nBFpxFppj/uAF9gef+j2kBpY3H1M6hps4SAAmZRa42lKbxLOechVWl02r
	zpIaNpPzEE3w670WtlEoeFGrGxSl9XSd+5SzvL+lUbgam1LqMO8toVQ9aPSLWGqjtIWLkfdtYKu
	LOXYl2yRMM8aQqezofEDst3Kl3Zo1canxCKnS75YibKnnm4ZZIhLOpyPUh6uRDgi6UUJwlHmnsS
	OD6KlGAd070a7zvIKgkNiFh18PBt7X2aOEy0mb2ZX1k8DC0WHvmhpNK91yy/u3wGCzsbr6Jwf2T
	+1WOMeAO+DfLVwpWTjx2fHXvZ8cm9nPV2L9xKtbapiL2f6bxAwQvz9UXLElZaT+Wa+7KPJXwNFG
	gZV9ty+5dmiZOwXUAPCcjU5Wj9Wr5FDEWsQbJduLO4b/oSiITlGSFcewgbdnuoxML+Fze3Xaa25
	e2PvXt+7rECo17c8b+PdCS6t48rLU4Fh5ystmfcFoY8ukSvLk+5/bBI9bDx9ETtIuis1Z1cZ1jS
	ZlQQ+oudJ0=
X-Received: by 2002:a17:90b:5546:b0:39e:14db:437c with SMTP id 98e67ed59e1d1-3a07309c886mr542158a91.4.1790066626997;
        Tue, 22 Sep 2026 01:43:46 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:43:46 -0700 (PDT)
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
Subject: [PATCH v7 3/9] crash_core: serialize crash header preparation against hotplug
Date: Tue, 22 Sep 2026 16:42:50 +0800
Message-ID: <20260922084256.1515554-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3792E20002
X-Stat-Signature: ofngzmir7xebzyrz41x99g1t73fesiua
X-HE-Tag: 1790066628-445468
X-HE-Meta: U2FsdGVkX1+x7BZFrWaC6DZ2aqkuwsdyA4lSVPmHGVT6a0Vz5Y+1sBltLqooKkciDS1sKtDzsN9Wd7q6Eagw7Rj7MprpHWWv7SynDwnbigm+2edp8kzmaFzgH8jvGR7DZdLKQ3luxK+mOpuwBH1V09JBM7fmJhQxBTDj1UbLSzREkMcWA6UjMSk7nkFz3mmz9xB7uPqaCH0smRSxAdrBKaiEogJc/rY4jhm0W3cPHoVeCWk6KMbyiBTyomV8q0DWfhFOqCs8vGUQKnAaqbM4TuHBNRj4yZp/u560G3+Oaryfhz2jmk8GoeW1YE/yYSB2I9ssKZCHK1x9txmMW2fPFJEVw4scKQ5NnEAiGCzsNnaKDc56B3svLFlR5I+j0Q4BD4M2qH+gXQ1Gl3Nk1SMPMg1vGX8KgRyP6YzgxtRkEnUEMnbJhZvDtWLuufgj9Huj0zF8uxGVNDyn6i/rvA1/4MYrpGnKMqXzoVi47vadO6wTtUGapXdnmU4yQQzctSxoXpXQjcIZYxfCDZfhUrGw0a7SaC0A2xTnvlhPZSgK4d6NOWrhkjaUmDTFuDVX8mHJmzoBEQd+NQslPVFQwsvibXkVU2puUD8mmerjGvV9/P2eAcTmQFrobsN8cpv894CO+jc+QEyPgDUI5C5EVlFvrTFj2vIPjH8ojNw6Zpj8YsrDWvTD7f2aeqK+u0SRuQBfQea38daMLmIBu9+4svFSgDeCi2Xgr1t/hSakZ5PkCoEkJXgVE6aFghG0KpTUIALLYM7tiMJ5MLTUXSC7i/ySNo/2RsFftTyR9fCLu048mGuOqa9cEb9ud0iR/gEGirbuvNX0xbIzeXFVRko7l9V6xmpUhMzCZVs4wN0tyuYshQbppHD+A3CqAkuSvY7sMSZr2sT05btFoKwVEcQp3qEGkw2MPxatJVWsV5qcOWBjcFfDvq2qvtNlPxf9dx4DQELJGmasMM74HRUngwJualY
 HMRJNDFh
 tofiDjqdNB4zqwKk9xGDYA0PyxsMp1TsAUOMCTpAPkqq6C/RBi8imS5itIqHYt8BJVJe/ItPaRamQbcl1ltVtPh/1T7ajte6OhWxHayAnvAxbuvg+umAW/GLcdIrNzORWQ49MxHx2fD+UmWLWN1irg5GUbSb6G9HMJGuoa3kvAaYCS/De4CZJxhGyxb1jFg7iQGx772Z5bIpPGQOU5GZbqxvNJEBodEsbfCMmq8ioWCCJGfnr8ak792HoQDz8WAtSzYgvFedyRdS756tJf0kiYrVhsO5Tnpc8Y8b+TpeR7dhzSVXzyhlNJPjI4XsUm2wZQg8vy1PKpukh12km0+ZO/mifBhj5/52HoNnLG24gPLIPP6Qr8VJUGs6xTZMgVauEeOyhyZERYl6Jw8cyN6e3Zb/HzgGYcekoBc+GsN75mfWAFP8V59/heQACgUUyCSCsaVML8ZUhQmrfUswuIdjr3xAvwgkDzINcge/48N62lku/s7A4vWAlnEfzj3m7RbDWkhMyf6nbnPRa4lnEeUoU6ep70HzSN0VH0mmZYRaGvqbhirsUrWYqNpmb7nc9bzgfuEWOjPOUQy1yR2I=
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
kexec_file_load(). The x86 memory hotplug path already takes
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
 arch/x86/kernel/crash.c    |  2 +-
 include/linux/crash_core.h |  2 ++
 kernel/crash_core.c        | 17 +++++++++++++++--
 3 files changed, 18 insertions(+), 3 deletions(-)

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
index d201638d11f3..d0cc2496dc09 100644
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
@@ -338,8 +339,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
 	return 0;
 }
 
-int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
-			  unsigned long *nr_mem_ranges)
+int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			    unsigned long *nr_mem_ranges)
 {
 	unsigned int max_nr_ranges;
 	struct crash_mem *cmem;
@@ -376,6 +377,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
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


