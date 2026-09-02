Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A64C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85CE06B0098; Wed,  2 Sep 2026 03:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834256B0099; Wed,  2 Sep 2026 03:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7233E6B009B; Wed,  2 Sep 2026 03:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 527D46B0098
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:32:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD098A4661
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:27 +0000 (UTC)
X-FDA: 85168004334.14.F69E211
Received: from mail-pz2-f8.google.com (mail-pz2-f8.google.com [74.125.228.8])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A5EDA000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GZRzSkWf;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cwr70l9V39DZcorg71LVRPBxIRt7bXPqTCF0S2pUJMg=;
	b=CKPYF7/RCcL8pfEskv88FIkZQTkLjx01FOOdH81fo96b3VpGEdIk8kKcvFlzk1TqWy4KsL
	8JmyOUvtN9mO/uonhBBpsCLJDG1fRc316+hb8MTmdMgLR/YmCzUhjJChkvfOBX/WsqyuQ7
	E/ZVo0K3BQZHoneE/DC6GRshtgUH3cg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334346;
	b=fMapmh83XlrSrW2ay3izBbOadopLUkAgdBbURBd9QqyEXLsShl4BhZlRAcP+TW/BTi0RTw
	rmKmwfliDWwipoSbjskgrXlrjNbaabOAe05wZZvw5pxZWthUR/1kKlN0wO5MlpTJI8man1
	0AGlqt40VTp56IDmnd6HoJ8SXT2jvLo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GZRzSkWf;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f8.google.com with SMTP id 41be03b00d2f7-cc1d7f6f26aso411023a12.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334345; x=1788939145; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cwr70l9V39DZcorg71LVRPBxIRt7bXPqTCF0S2pUJMg=;
        b=GZRzSkWfKh5x2+2I5D7x+pK//uMviTIhdI1LGhKHoudThoWCMKqtnFURl8ja8i8Ml3
         piXlmWegz2t1ucYYhlukMdDCWJF5N+Hu74AtoV/Fq2Zh7tqo3iSExqXH5dUlNy43qEx5
         JGtrkzwsKZ5FUddjVHDssE0u9gK0sjn9kuFKYN9r589/4eh1vH5buoRw/qbNpNb1bC18
         RJ6WwnYkz8cwdcSO1cmGDJDpZ//OG2tMGzovi+nJeaQUoE/7ZCIP84of7M4kcImcWvmj
         bKPt/h107Zm1eQ89Hf6vl2cbBTxBWV9dMijGdSvOXufABOUFroHzBQWShw4owkmnGgWM
         bCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334345; x=1788939145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cwr70l9V39DZcorg71LVRPBxIRt7bXPqTCF0S2pUJMg=;
        b=PWVh3ujJySOCai0yZIT5FocTPwqbVFQiw/qxaycdjPxFA+KAMXLYlGwT4SiaonaVs4
         oj0aW9X7ntTY4NvzgwRWkWIcVrYWP5mpuMbJ0giHQpgOCrIpNZuC/swvwLNpZFdBBoY7
         t1Qs7islvVtkT8HWUIbQf0V7KAAU15OszfDmd5rPvjADWb4hQgxTcuv03qvGwzKaoQqr
         QrBqNk08i/q7E6YCpDdzKuGoFg7PBggsRsr6Ylf1ruHDHCflnhLfl/oCY4nn+K7S7uFn
         8mteUnwMJR7ELU1vnDjJXiC8dRGAX3y13UwCsRGzKKC0ebKPNqMAzIzrD86SyzeYRAMV
         MWXA==
X-Forwarded-Encrypted: i=1; AKwUvBz8052/i7YgdEbxWwB6lW2RMNlKQurmLhS0NFQLM2aCBPfl2xCG3nbOMmcZl6MSdsvO+brK8b+qtg==@kvack.org
X-Gm-Message-State: AFuF++lJ155VciLNNGfrOL0H6m3Phky7PTy1GwTk7/AFM8xAHAR7SCMp
	i3PawOKGxb+wMD3VGvoIQ5lPGGnl+otqf9dsHrTjhrVB9AQomCK8W/3T
X-Gm-Gg: AYBFou11M9xkPi1zTX83mE18UkfQYa7Ioy1/FFXVNGQ5QAEoict/O2ew9SlMKJvxR+F
	44SJeTCap15SsTaNNP9ppV3U4AZpiZKdhLawD98nT3NSzqC4xoVOIcdwHgFzp450+N0+Yq4arhF
	EUi0FqWR8skqqrgO4QdK7wvMUTyjU17RK3RTffHe66LDyWk+IXk/WltP/BwKwMmuiC4/c8Jp0Jd
	FkZdSkWNbRgePvEVX5fZHMQZRWTypL77cYTztHq5ubjfY9wXqCZ/2FFm5a7aarHbd1zRPcc5AlZ
	5oR5k7zdqyJdyVaVW4H5edoXvqD99GmES5ZxH3P7lxH4SGkkGExtgjQtvxeuFyYE1diwvKPFXXE
	9j+Tsvq68NAdCTjnScUspyQLIixTtp4KwShpImAqYKlWsrHVrdwoy+umBXQiceBciFaZfuKMgCW
	UJs/JxUKjvxEsZNqG5B0eCdsaFRUs0FoYpjnP+oRFWjTUWxYGaOisPbGqFSG1/XiB9G6duULKaU
	lMAVsJQkag=
X-Received: by 2002:a05:6a00:238b:b0:85c:c8db:8e4b with SMTP id d2e1a72fcca58-85ed23dea9emr4650515b3a.6.1788334344871;
        Wed, 02 Sep 2026 00:32:24 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:32:24 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
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
Subject: [PATCH v6 04/10] crash_core: serialize crash header preparation against hotplug
Date: Wed,  2 Sep 2026 15:31:10 +0800
Message-ID: <20260902073116.802752-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A5EDA000A
X-Stat-Signature: ihsrg1od7e6zig63hux7thgydbhmi6we
X-HE-Tag: 1788334345-294873
X-HE-Meta: U2FsdGVkX1/e/Ly7MZYP2InnellR9TKn+jxdNVOe62PKswStPwpes32WCUlLiUqGVD51wFMgrAGN2lacTHxdnJBeOz1H8tnBDVmFYA/u8g7rzBN4cozQLkHIHvdfOhABrFzaoPSNHZ3dHzW96M482fVnc7nZI+QCmM1YBslls+B+9UEhCUQuK9cVM87YyBzLDuqSG6geNHqNpUnRBkNTWprZHypPUTUn/aHWM3+AdrQG0IU3N7R+hzmK16l43kEs/OQ613vCvPBw/SqOoYEx/UPzEaFvbkxPMmwNSFo4Ns7XvjZygw1NWeSqx3peovlqd0dEnIPxjOmHYE0JAZ6+mmVFHKD9Oyz/EDDXMicAYk74svNgtLQDrMowd0oGY4R3GCsZt8RjE7gRlotT4+I5NavxXtgmw9MfoZZ0H8V8OIXp6ggkp0KoQRtb14KOa7XjfvsJ1pV8JPZXklTJHadOayQeYB4evuqEoedady3fvwHCI8mCF6aSvbr/hupKo6/FrgxN1PmZRCaOo4pygqAqG+SzGlmlfEsuDp7GHlhjNlsiFHw1fOmJed5RHOlal9K//qPFBb6lmSap6XH2p68HRGii6w4OtPlXSd94QzFoi2riLOi9V7qU604p8dGPE6NJ0sGuu024AkIkr8cgoHJ8VeCwL/sTJfinVgdiWOqFZMBbJecxVKOTXjBE5kYFdkxW1l0yWC0MOQKdDP/5dSye+la9ANIM+AyJICIXntAdGVHec88CVr4HoiECT+gH0QbrSr0dXsQc0MnBDV8jP4/M59bZ14RsQJOE1IIrUzuciOm1VgFxRA/KjP1uvyyPSjYitZaq6z2BAjqi7MNmn/JCxueXixKh6oiH3dSpvYf+69sS6KeotsBgZDWiFktkJpzcOSICqJEdHSYf52aMs/AyTk80a/l9AWsj9O7uWIygmkOxl+1g58bH9N2UA4ct6Vly5zxr4Ui0cJYdFvmpeXC
 xWhcmK5u
 XSBapQERhTQiT1GPP8CwBx1jp0iyw3UHl9gX4/WKikN5f1scQWvmuuxUl0ovQX2SXf0OY4CXkkUaoPbJZsG5J8DqUWUV/HRqRRhhismIrvWU0LH5wYhBil+/edGPED49fnHr3iYXoCqFLBDiZvRDYHYLad3qeWQofMrXBpojmNtNwMYiNMjDz3Yon9FRskv6+VuiRM4L7WeZU4yvUPI0/4aMMvkvIpRvjeQ4il1rChHc+1EkV+6phTpWcvELIEewsldP+VyDC/wDdatJM7jUsk2qctC4MDiJpohFD6ZCn0w74OVuhiGXV9O0A78NAzlyavHeoA/VtV1JytipmxWlEMijdQ0LVZ8l74A3sUfvSYoBD6F3oBtoFj2K3WWMT8Ne70Aku82Fe22385ZqaXUt4SCB/EGpeVAMbJkcbs/58mUUgiTgfg2j+fwZJTVtHfnHBkvSPykibmzV3ky7K9m0a/V3yEqWKa3UlZYuVRRmvOXbNxSRojeet+AwwkPT4B2n7s9DUB5wVnm+YS241dMtsjBjljCvXgUx8K5YfdxayAl2eAGVjMuUTuvQ4Hfu9QHsZzjrNc/4jttYY+M8=
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
---
 arch/x86/kernel/crash.c    |  2 +-
 include/linux/crash_core.h |  2 ++
 kernel/crash_core.c        | 17 +++++++++++++++--
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e681ec9cf1dc..284d78bc3fd0 100644
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
index 77285ae3ce60..3adee1ae120c 100644
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


