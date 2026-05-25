Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95430CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4D06B009B; Mon, 25 May 2026 02:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC0D6B009D; Mon, 25 May 2026 02:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8A16B009E; Mon, 25 May 2026 02:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8DD26B009B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:28:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C3F5A017C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:33 +0000 (UTC)
X-FDA: 84804963306.01.9F1C573
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf11.hostedemail.com (Postfix) with ESMTP id CBDB74000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vUYWyZ1C;
	spf=pass (imf11.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpXKe3wAdCVMwU6Llg7SIPesFhMG6uKuOmrHw+vv3aU=;
	b=04oYGYOUtF80TFj2ahgQVbnmmf1fTOLS55ju0OKfxbFKjPnaxTzk4uFwRaQtiRC3AUFcwT
	3qpJ4u7t5vm8+ad+zwbE2aUO7k/eSomK/dgXtApATL/sokKSXEU8WMwIgS3LOainYqCziq
	XciIHInZZsNoFXZJlkTwJ2FIdcXyIlI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vUYWyZ1C;
	spf=pass (imf11.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690511; a=rsa-sha256;
	cv=none;
	b=Q3TAW14GtYV+BbsIIYC5LIkn4Exn1HsmgYHqwxG+4sgIUTXbZ8dCpv0CWW+uskxXVSfp81
	pjCwkyJcyfo2FRdCsqM4wf51ekN41p18BkxnWSmwtMyGZkTctommvNcy3cemOkrDSh4PoD
	Hf6RCAA1LtCIEi8wc3CP8qT1TLHM774=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779690510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RpXKe3wAdCVMwU6Llg7SIPesFhMG6uKuOmrHw+vv3aU=;
	b=vUYWyZ1CdvfZMVBvkgDZVbpei57KgtJs9mNpdIt8reqlu40mKSoS6h5RB2R2LDIOZMvIA3
	7wD1tTsQvzyaW5cW3fY+xdCoerMSlFATNZAzoiFX+PB+IxAQ6fG/swWTRU8fGQxzBcT63L
	bQbqgORkRf7hUz3cU/du0doFMLefN78=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kernel@xen0n.name,
	graf@amazon.com,
	shuah@kernel.org,
	loongarch@lists.linux.dev,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4/7] LoongArch: kexec: avoid overwriting QEMU's machine FDT at 0x100000
Date: Mon, 25 May 2026 14:28:07 +0800
Message-Id: <20260525062810.103367-5-dongtai.guo@linux.dev>
In-Reply-To: <20260525062810.103367-1-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9soy8s8etmt53wr4duarcqnz7zykfxkr
X-Rspamd-Queue-Id: CBDB74000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779690511-970942
X-HE-Meta: U2FsdGVkX18GnP+TvmlM0s2DEsVibpHLwe5V99xj2YWKcH98uq6zdWZu94W6KrKQw4MJ6vzqGayZFpupb5bwp0TA30KTxG9YWRI5Ef6fS/e4lJEaErVD0U/BtwtcvB8zO+1MndcdUOnWk515TyVUqCGP4je4O5wArd7Hlqk5av7P6914DjiThc31nGMMKNb18sPwbdqSHirKDkU7yZt3++vLa/QeH7Pm7evmT4jqJ0dQ1SAxMW3zK3ecGyUJmR5dwfnzRXnEKW2jlUAoH57OJNxBqJCbWU2fWXt45qdIPpU538t/Hu4GJAnfz2P3tJ2u+g0auKINHF0Y6lkYRc/ovV49iaFdMLpe90+8hjWOudWAa7dc1Vvs8Lifl84NAIbTWIYHQaZ4Bhp8UPhooqropMkh8Nzu6Fe9BO1T/ut99a4pK0kMt2sI9dyRdrcmRuAUZPJfnHEloK2NM3iq89/6Dr2l2156WZoopMnES3pdndhxUuz052V1dmPXV+XH5dfXu1W2xvccnHtByXO/awQaNcc2yH2OKzpXe6QqjxpaUiT/ElwVdz+cLVJyXQu/ZRgudZhP6agwbCaNbkuBl9xBSQrGPebap+cRoWFgslnUhmhSo0shVR8pNCr+1Yaf1l/EB6WEP3sztCm633rWPqWdvbkATCcvN2WPS0kueOEIR7+GDwtyQ7O1kOYVVZMx9vBHuCO6ZHwQ65SmfdCG/NoM86GEdRjwMeYG0pEfweVmBvHTBJ+I/TZFah+ruPeRda4wb2YINX0mekhqAdC5CBj7RuMhyOH+iTcFNATuz15EXLeuaf1YTXPf3jLxdr5ghFvr47gHTpY0fTcc92X4nEKJfu2tzY5+U+fa1nVNos5FUVBJ+tCr9QYPKG1mcp5srOoFOUbbFcqOEr22GMpuNobaDS+B8aPpBW00T1PQDutcOM9VIPCW/45GAFoj3C3TWARdaxir89/lHFMxu4kMKAa
 9WtFP5Jx
 aWPsDatZwl67zDwchpcHA01BHx7d6B96n2YWYJyPBheu4ae/AJMiuy4KU1HbQb2ogaO1xNmYSwNASlAl6abdzI+3bhlkpBpZr493FiFEzYh3TOKYiM9MaUWmE5E5qdmRBgGBJ48iSFrdOGACkH/Ak7LwHPIrNScrqTMLoSmgSesaKlu8WhCQVZK8BHvNyQ++GSR6y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

QEMU places its machine FDT at physical address 0x100000 when booting
with '-kernel'.  KEXEC_CONTROL_CODE was defined at the same address, so
machine_kexec_prepare() overwrites the FDT with the relocation trampoline
before jumping to the new kernel.

The kexec'd kernel's fdt_setup() reads the FDT pointer from the EFI
config table (FDTPTR = 0x100000) and finds trampoline code instead of a
valid FDT, so earlycon auto-detection fails and the second kernel boots
silently with no console output.

Move KEXEC_CONTROL_CODE to 0x180000, which is still within the first 2MB
reserved by memblock_init() and does not conflict with the QEMU FDT.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/kernel/machine_kexec.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index d7fafda1d541..44df7dbd3de5 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -21,8 +21,13 @@
 #include <asm/cacheflush.h>
 #include <asm/page.h>
 
-/* 0x100000 ~ 0x200000 is safe */
-#define KEXEC_CONTROL_CODE	TO_CACHE(0x100000UL)
+/*
+ * Both addresses are within the first 2MB which is always reserved by
+ * memblock_init().  Avoid 0x100000 because QEMU places its machine FDT
+ * there when using '-kernel'; overwriting it silences earlycon in the
+ * kexec'd kernel.
+ */
+#define KEXEC_CONTROL_CODE	TO_CACHE(0x180000UL)
 #define KEXEC_CMDLINE_ADDR	TO_CACHE(0x108000UL)
 
 static unsigned long reboot_code_buffer;
-- 
2.25.1


