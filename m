Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F20EC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 05:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76AAD6B0096; Wed, 16 Sep 2026 01:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CD66B0098; Wed, 16 Sep 2026 01:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B0D6B0099; Wed, 16 Sep 2026 01:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 334D06B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:06:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C61FF1A0601
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:06:03 +0000 (UTC)
X-FDA: 85218438606.12.35762A1
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9AD534000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:06:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=DJrGhvTa;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf11.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.214.225 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=DJrGhvTa;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf11.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.214.225 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789535161;
	b=LjJZNR9eWFnheldQrUq33VBevbMDVirkfCaOs2l4Rrclj2qwvGgTOYEh74HXBMOCiIZe+M
	dcPsTMpBXVU9prvWOYAOOIsCR6D+7DSB+bxo0kYcR3uO1BNjIHCtR+TCfM4LATVwVxygpd
	j024ZMi2VuOL5WjrLqGt52WPux46BjE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789535161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEqGUwhuGtd/IQ00br0ru4/E+DR8RR02AnrUv6Zwxpk=;
	b=XeRtsfJv1Yhj8iiyQWT1zTrFkIEpRpsBhgz1wqeAtXUZh3BxRnym1P71aNWe2kVUqEOVoq
	Ux1gHCjKAnQcp8qa6hfYFbMjkN28kTJ9bU56gTjUC781IBWWXr92erWVANpdnmRf759M3k
	3enQLwLkYCGZJXQr26PPl4m7dFZwptk=
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2dd664da0f5so20373545ad.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:06:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789535160; x=1790139960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qEqGUwhuGtd/IQ00br0ru4/E+DR8RR02AnrUv6Zwxpk=;
        b=CbI1s/ZW8wZ32Tn9j2RTD8uA1v5dUw0NwMlogRnVbWDBRtR7ZjLb3A0wEGbB0jzf2V
         VwofEcYsGIfr9AoUA84lxD51P+ZD+UTB/ei6+6PrFomYZbIg130xHCNsTS3zcnTAOutU
         s5AInvwXA7gFQ6mCGuaGeSvR+0rNghrrTwI+mKBBPXJNrgWlo2+nml9zBy8diI+9atBi
         k0/UqwvoWF2pNevV4f+AL92pv8+j8VHJmbJLzd+lVF5OQZ+LSUHplDMfaymmF5KDaMGu
         a3qyVtpBJg6W3PTYxsLqiRfye6SQxTHrGmNU3gbXRlVURf0Pg4H71nbOXhhrkO99sUrB
         qORg==
X-Forwarded-Encrypted: i=1; AKwUvByDRtF8bnPOsplXGQbhO4wvafVMenFvX9xyv9TbM2/pGME/EXq2yBge2GKYmhilDYYaesjZBpK15A==@kvack.org
X-Gm-Message-State: AFuF++mq9MdyB8NHEusZEYog97AB7lWoAFsR2HJnncd+i4HzYnIef+Q/
	tiLmrSvcFrnfBiGugrQFoQHRH2fT7XRmxCAu2IOcJV7xN6h2i+vTY+nYC5aQbrx1Xp6J3Dt9E5d
	/chKxS390axBfczVEGTlsWlGqsNvHx405/Q+tUzqUfLNW6AON/MEZhgLvhvpQZNSOTveheekz1x
	s+LBIwE4K0ziBKHLwiM01UChSgSP16T4iplxk7sft4xF6EjStmU7S9WqUACo/PX5N/jns8ERb3r
	YM=
X-Gm-Gg: AYBFou1mkpOPGGphw6dTOhpukigWxS+5VZo7jw3mUStHV56qGb6bG4me3p6GYps17fd
	fj2TbUfFiA8/zeLrPqmG+goUEFEL7iCpem1ycoFEKXo6ERj7pGUiTV+IAb63pOb86n3l7fDHs5q
	wWMYILaZ533/OmW3g+UjcdCEKuI5sfa2nzd8itRgXm4giTfYTUvad5bB4vUUDu2inwiXmMfMgL0
	f5on9Hxalmvcnk/HzLx9iGnR76DAQU0G/SPZlxeDUP6ELRQphYThMil6ECl1jlbGShgClcOFk5W
	wlpulmW4oy/LBC6DUX2J1Nf3O9mVkJzYgTKfDydb99F2T/2GpdhkGl+BjPkEhqgZ8iUtARdy6Us
	TTfOkq+YDSwlrAQPDswxS01aADlM3WTdCJTulzZeZinVmKIc/dtOV7+CVw26MWeYMjI76lFFsIG
	db7JgpmkhESktjHtuEEO7y9eUTTsHcSG6Iy3c=
X-Received: by 2002:a05:6a21:4910:b0:3c4:3767:adb2 with SMTP id adf61e73a8af0-3dd5f407ff7mr3083702637.1.1789535160381;
        Tue, 15 Sep 2026 22:06:00 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc50acd74a6sm770455a12.6.2026.09.15.22.05.59
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2026 22:06:00 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1a439db36so4351581a12.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789535158; x=1790139958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qEqGUwhuGtd/IQ00br0ru4/E+DR8RR02AnrUv6Zwxpk=;
        b=DJrGhvTayWFjiqmtyXqhKQSM/vR6bf3Nko8Cgdx0UhZSV3DPQUhfiiMmzc3zwtkt1V
         MKQ8Zw2CaYCbzB0cVuYo9E/Tjz1vb6t6p4iqCHFYEWrCWJRtSrXjxwL+z1i4TR7z8abU
         a/sX9AFxg7zVyqSbFSRdF32Pho7V5ds/x7CjY=
X-Forwarded-Encrypted: i=1; AKwUvBwQ+Nr6yHMIPnaTHzaMID9YqrEuI5Zmieb08yfzuX9wly+EdJYaErb83+SpV7QEryRtmPE0FpVRoA==@kvack.org
X-Received: by 2002:a05:6a21:1343:b0:3da:80a1:f2f with SMTP id adf61e73a8af0-3dd5f5dfd69mr2927552637.14.1789535158385;
        Tue, 15 Sep 2026 22:05:58 -0700 (PDT)
X-Received: by 2002:a05:6a21:1343:b0:3da:80a1:f2f with SMTP id adf61e73a8af0-3dd5f5dfd69mr2927490637.14.1789535157892;
        Tue, 15 Sep 2026 22:05:57 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5e40494sm3951386eec.15.2026.09.15.22.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 22:05:56 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Borislav Petkov <bp@alien8.de>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH v1 2/2] x86/vmware: Decrypt steal-time storage before sharing it
Date: Wed, 16 Sep 2026 01:05:40 -0400
Message-ID: <bbdb89067cd07d07fe4963ad229932faf87b0ef9.1789488039.git.zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789488039.git.zack.rusin@broadcom.com>
References: <cover.1789488039.git.zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AD534000A
X-Stat-Signature: hfwd1fpbcknpp3pijyaz4tn5rak9ar3h
X-Rspamd-Server: rspam01
X-HE-Tag: 1789535161-569753
X-HE-Meta: U2FsdGVkX1+3oyrrfdPQ/jopF5T+vErM5K4Ax9ij2gMDpxpKRwQ+BzgHNmTlpeyG6lLzV58FT75tp12laphwccNowoqrT0gwN1MGsEeqDhro/d5HO6FnyJ56KLXyzgEn+Id89YYSZUHM1uh2T6nHLl0WSr9vbPomi/9SKpUay4s7H3LH9JSpunEST19f4Nt/p+dZIiBHXbbzM5mX95u57wHlLuUuZ3Oromw+ZWbgNgzYLvEgXx/0h34AeSG+blkfN0uk5c/+XFGKxlZpmypzu62oNdONYG5LnmEo9YNM/+HEhkHnfdhzGnZ0yUSLbP2W3QSMLztJ2pLYYMX+fIV+qf8+sgHeTijOuXwMbgRP88OirGieN30SutMNJgUJzFqYu8IlfrAeX4QVvWB1mG2GGWvQupE5l9fN62wsxSgmmQ1PqLmQ2SJXu7+nZ5oF/jZTfm8WhcEjL4u+4+V5zOWNj9vUjxWcgZBkhtqaEoqqi+18BKq21b6e5yQEXBs9SuRgYGfQUxuAbC6pBGwiSoSVb232rZ3Ua0+zjxsjkgnK8h1/xkpyGuxRcM0TTGTAT3/Ue2r8K6jWgysDt7oEA7rIRUJ+cplpVlb/q3poTL1NClNzjqOpoJKkXok3Ntnt22MnDdJ+vsP9pkvLK0cUWLwkEatektKRVS+1A6Wk5Ao5EQSaeHW9qTfrPinuzbWsAZw45uPqNLSTUcLL/5WLq0bQi4li41p1UAxW4T79DNajqIfDibxwOUvH023aPZSrR55W5SQP4pXEuX1Ggh/ba9tWPNT73uug7di/ahIhIQheOKU7hcWjwRPkO/LDilwetwU7Qln3TBTpROaYqQ/ju8yEpBcFUdUsDT//65cPA0eRADX72JB8UEofq+w5Ycs8rbLggs7swLz4JaZZF0hW0AcrLdmt4Pf6cPQOlpRnv/u/Q4e5h2gARH3ClBfvI2ugLkfRYUj4bLLospqbnQsoUd7
 B8H0/5+I
 myJtD/RxiBc6ITFw/e4nztWYavpf+NHv/GLOC+nigdsxfPXqexdtLDNY4HibZLkxmRHI1i/oU2RbW1Aqy06lxsVfpoVZHhuffCTUHxDByl1GFSkAiyKLoOxhpHFpVp2gD6PBv1UHT4b92not+VGn38RD7QdQdYHIUi47qnnFWJ0p8Fl4Hn23GdspVe2e0QC52116E/7gbQjZYPasBUCkdvNLUZU+xLyIlG4c1/CbFOtap9be8AbVrTL7ytvnHF8wQYVbAkoXNnHjErGFoXrpm0aaM20ExHPqpR6/8EMv8Z832TSubHDdUNodnMLWbKXr+NiprcxX4XB9rPV7660kXcUH7Eymk3BA4IUL3N7R+uHm1GL0bkk6LN1Cy8KsBC7oP5qiZKT5mswyeyAWITFfR7SvEDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VMware's steal-time counter must be in shared memory so the host can
update it. Encrypted guests currently register its address without
decrypting the storage. Move their setup to an early initcall, when the
memory allocator is available for page-table splitting, but before
secondary CPUs start. Leave ordinary guests' setup unchanged.

Convert every possible CPU's storage before registering any address.
Zero each object after conversion, since its contents may not survive
conversion and the host initializes only the counter. Register the boot
CPU with preemption disabled; the existing hotplug callbacks handle the
others. If conversion or boot-CPU registration fails, attempt to re-encrypt
all affected ranges, including a partially converted failing range, and
disable steal time.

TDX's conversion path requires directly mapped memory. Check all per-CPU
objects before converting anything, and disable steal time if a TDX guest
uses the page per-CPU allocator, which supplies vmalloc mappings. This
also covers automatic fallback from the embedded allocator. AMD guests
are unaffected by this restriction because their conversion path supports
those mappings.

Link: https://lore.kernel.org/r/20260309235250.2611115-5-alexey.makhalov@broadcom.com
Co-developed-by: Bo Gan <bo.gan@broadcom.com>
Signed-off-by: Bo Gan <bo.gan@broadcom.com>
Co-developed-by: Alexey Makhalov <alexey.makhalov@broadcom.com>
Signed-off-by: Alexey Makhalov <alexey.makhalov@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
---
 arch/x86/kernel/cpu/vmware.c | 96 +++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 34b73573b108..f49898275d87 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -25,14 +25,19 @@
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/clocksource.h>
+#include <linux/cc_platform.h>
 #include <linux/cpu.h>
 #include <linux/efi.h>
+#include <linux/mm.h>
+#include <linux/preempt.h>
 #include <linux/reboot.h>
+#include <linux/set_memory.h>
 #include <linux/static_call.h>
 #include <linux/sched/cputime.h>
 #include <asm/div64.h>
 #include <asm/x86_init.h>
 #include <asm/hypervisor.h>
+#include <asm/cpufeature.h>
 #include <asm/cpuid/api.h>
 #include <asm/timer.h>
 #include <asm/apic.h>
@@ -147,6 +152,7 @@ static struct cyc2ns_data vmware_cyc2ns __ro_after_init;
 static bool vmw_sched_clock __initdata = true;
 static DEFINE_PER_CPU_DECRYPTED(struct vmware_steal_time, vmw_steal_time) __aligned(64);
 static bool has_steal_clock;
+static bool vmw_steal_time_ready;
 static bool steal_acc __initdata = true; /* steal time accounting */
 
 static __init int setup_vmw_sched_clock(char *s)
@@ -280,7 +286,9 @@ static void vmware_disable_steal_time(void)
 
 static void vmware_guest_cpu_init(void)
 {
-	if (has_steal_clock)
+	if (has_steal_clock &&
+	    (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) ||
+	     vmw_steal_time_ready))
 		vmware_register_steal_time();
 }
 
@@ -325,6 +333,92 @@ static int vmware_cpu_down_prepare(unsigned int cpu)
 }
 #endif
 
+static void __init vmware_steal_time_range(int cpu, unsigned long *start,
+					   int *numpages)
+{
+	unsigned long addr = (unsigned long)per_cpu_ptr(&vmw_steal_time, cpu);
+
+	*start = addr & PAGE_MASK;
+	*numpages = DIV_ROUND_UP(offset_in_page(addr) +
+				 sizeof(struct vmware_steal_time), PAGE_SIZE);
+}
+
+static int __init vmware_decrypt_steal_time(void)
+{
+	int cpu, failed_cpu, numpages, ret;
+	unsigned long start;
+
+	if (!has_steal_clock ||
+	    !cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		return 0;
+
+	/*
+	 * TDX's conversion callback derives the physical range with __pa(),
+	 * so the storage must live in the direct map. The page per-CPU
+	 * allocator, which is also the automatic fallback when the embedding
+	 * allocator fails, hands out vmalloc addresses instead. Reject those
+	 * before converting anything, so no page is left converted.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
+		for_each_possible_cpu(cpu) {
+			if (!is_vmalloc_addr(per_cpu_ptr(&vmw_steal_time, cpu)))
+				continue;
+
+			pr_warn("steal time disabled: TDX requires a direct mapping\n");
+			has_steal_clock = false;
+			return 0;
+		}
+	}
+
+	for_each_possible_cpu(cpu) {
+		vmware_steal_time_range(cpu, &start, &numpages);
+		ret = set_memory_decrypted(start, numpages);
+		if (ret) {
+			failed_cpu = cpu;
+			goto rollback;
+		}
+
+		/*
+		 * Conversion need not preserve the zeroes. The host
+		 * initializes only the counter on enable, so the guest
+		 * must initialize the reserved words itself.
+		 */
+		memset(per_cpu_ptr(&vmw_steal_time, cpu), 0,
+		       sizeof(struct vmware_steal_time));
+	}
+
+	vmw_steal_time_ready = true;
+	preempt_disable();
+	vmware_guest_cpu_init();
+	preempt_enable();
+	if (!has_steal_clock) {
+		pr_warn("failed to register boot CPU steal-time memory\n");
+		failed_cpu = nr_cpu_ids;
+		goto rollback_pages;
+	}
+	return 0;
+
+rollback:
+	pr_warn("failed to decrypt steal-time memory for CPU %d: %d\n",
+		failed_cpu, ret);
+
+rollback_pages:
+	for_each_possible_cpu(cpu) {
+		vmware_steal_time_range(cpu, &start, &numpages);
+		ret = set_memory_encrypted(start, numpages);
+		if (ret)
+			pr_warn("failed to re-encrypt steal-time memory for CPU %d: %d\n",
+				cpu, ret);
+		if (cpu == failed_cpu)
+			break;
+	}
+
+	vmw_steal_time_ready = false;
+	has_steal_clock = false;
+	return 0;
+}
+early_initcall(vmware_decrypt_steal_time);
+
 static __init int activate_jump_labels(void)
 {
 	if (has_steal_clock) {
-- 
2.53.0

