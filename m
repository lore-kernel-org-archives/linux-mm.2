Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCAEC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE0C6B00A7; Fri, 21 Aug 2026 06:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37FD86B00A9; Fri, 21 Aug 2026 06:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1BE6B00AA; Fri, 21 Aug 2026 06:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD0116B00A7
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:06:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B3FC1403F9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:57 +0000 (UTC)
X-FDA: 85124848074.08.976D2B9
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id A46B6120003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MlayavnH;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clgEu5ocwrJ3/2sMRprXhyjnlGpexA9HwN+YHsN7hWE=;
	b=6TJmejcAS4Yqp8PD7hL+Xlx6jRz/oOWEy3BD/4dWCOqmrAeoCqvzXHQuelpDpGl/17shwt
	HAmEtDjhEIAZ4m1JekBpsMBVplOW60npidXT1ApepxEzg3YHHkVyoxDapx0bKH9YyOe0jC
	KCusCdLSPXSxKblREjyiL/oSA5xiccM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MlayavnH;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787306815;
	b=xYDJ7OQQZ781JvcTd1ZaBBMTgs+ehbrXz3IUky4RurjrPxsVTuXfhiTgjX5XUUutcZSW/a
	LKj2HnsZnmgBjm1zK6uasPrECzgums83Lc01tF3oL1LfHArqro3FglpiwQSeL4ve6+4tUC
	FR6R4e0cfdyij6iiYUq78zxMhVsxd2Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=clgEu5ocwrJ3/2sMRprXhyjnlGpexA9HwN+YHsN7hWE=; b=MlayavnHGn93lBnpvs956q0XXD
	CVT+1RGs2pahyXBKzbABxG5K9HCaqueKoaMRMlRJlxoYTruWY+ViP9hC9ggDwSa7p/xp6CVXfiYBF
	Vkb/5h/+iGhZ0SMb/usYLoXRqfu8B/Uv5ZRg4+wIA5XCYg/Moojlgz9XZyHEOHSQzTYImSZLRx0gp
	ndgIoMz1pVbt7Q/NTZCvVtwgLmRdkToCfEc3gneLx1YnsXyu7jJvSRBwaA80QVPm4VIZeECOFIYgV
	6D5EmSzBV7DP1LTe+NSG1FAB2NfipYX1D4LlenITVvl8Y97FvZBFlyDnkEvEVhayB86P05bQZwG0D
	tPbmeQvQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM9C-00BGCh-0e;
	Fri, 21 Aug 2026 10:06:50 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:06 -0700
Subject: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=4736; i=leitao@debian.org;
 h=from:subject:message-id; bh=Xsp5t/AjlrO67qweZEiBvofZ/A1yR4ej/H2a8cEi3f8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMaLD0gMUB4x31WYY7Fkyu5rCsTlY48ZbsVw
 Nj6u6XVr3uJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bX8cD/kBHVlSr41tBzDeV+jCDztGEjkDtT4IWUNxuOkogpCQezn/v6qS40A8wDFiNHJFSXDbAKx
 rtgqpRfApNGBuCI3kw6A1v/hmQGPaqdIo7Z4qSwy0ThsszkBZ2I2TBvDwL8C/eEEV9NklYeiF0y
 Jaav/ViHoSnLsaq77+gX3G1vLYYA8BhkRFazDF9imjYp8+vT+WTEIblxYzXG2B/a0ptHQaLn2VB
 ig/KL/jhwH7ncyfMig0bC0z/LbmQa7s0JdTXUSM7amzpllpgNW5yiV/CBIJ2xxcJtJnnRceU9dG
 BeInri9f9Ph27Zhyw2kRB7vVC/7uDGw/s1r6RjAUrCTeamf5sB2vdGl3Zg2xJ8bpYBXHkyBNFb8
 sGmmVIRJw+aZNplMEtGSUMceZoWGFXnrmaOCi3TUNxUfGtuZMF8Zc6ZrJBOpJ6fYW6/WqmRrKBA
 uqIsr0cE4uNUxBWSzO5YsTeuutpBfJYmulEBwIQSZjQAbeoNHjtIZLuMSAzAgPeJMdxOEaVLalc
 IzWFCsG0L/dTguYbx7Jxm9sWwP4krI3vzqYy/yKaLtwTCFg26qY8oJKydmVGZWNgapQsXjyj/cL
 blpYLbmyzaDkOL8RomhW5VZxKMKR079hL+ZT0EklfZwjKhv1vLLVsoLfc8nr05AY6n8KZemvcaD
 G5RQ0RnqrD7GxtQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: ty3s8op7fwkh8hs9w474tiqkae1g89t6
X-Rspamd-Queue-Id: A46B6120003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787306815-775373
X-HE-Meta: U2FsdGVkX18ozFB/9dJbFYJbY81ITFB8Z5niJWEOoKLe1YOBPSAeP8C+3yH07cOc0yNhnNC3lNr6yAKXTgFoA82H/M86e+WT1QZnRRHIg6n7/McnpZclpSf4g7qKEAMwS8sme9tSOfqWn7UX5txflvtbJFIM1f76wndH877Rpcq4d175sgc0qXvsDfijDzm/7p4JMh/9ppDx3VUajiWcpIrCviGjmHydG1bANdvY9EEuGrCz5j0IxwenbCl9qdm87OHeBuAlbzNHZX3te+ri5SLsBjHOyzXDxP10T6yppBj40RtXJ2X4J3VoqTYt1tJjzo3M+kaHX5Y0lOCwcMKA7HmejlvKZhbOeRiKacY0DQna2fCnm+qLg9yoIZlRbOzvl15e2vrsuhPLbPTE1+tg9VVpqV9MzOLj4Xz2f+gbagaRvDLBp77LXe3QwOJ++DuGBkwsEs6z1IeQMKbCviuoFYgbQhfKx6FPcdQm8CbCRJytLuvkZUmEz27TlhNNZtozUmkXvvzBA2awOCQPXDVLmEtyHQB9kFPLGipDrO2selNqH0B1JT4a61KIRq3shPwLGGm0Y/PL+mvuDjfVOBt02aYap6rbfRKOzMpTIsVuqNpOAf39RAM6jtgUWnKNkwl40vDeKB+275xZaUq9j665yh/uZiN71eBClQKkgk8a8q3ztNPAw6SHJYjow6YFZRHM6s+s+NS2lYmK07qJfv7mvzSSHTHETi9JLBKs4/yxXaDLv3rDuYWMn88qObZraOUfltYGsQhiljX49mefh5qoPTAlqijiC+MGjZjNX2RmQfG+lOxp3QLUQRNrkUCRKd+Z2tqa5mXVg0fNBcDzXBhEzEe4I54yIBXvWfqQgTpSh8Lk1DO6rT5U8UZVaxNyPBA8+8yMumTrOsZL0B2Senx7IAozQcAKMRFKXck2t3KSwT4Wq8tigFN3xD8sxJjyBvH//IJj3tgHX+psmCusD47
 ijeTq1W5
 PI71tExfkYD0ot8ia6S2lcIP8klyAvYw27OBUiHJmsKehAPiKzaIrl197iBASGshyum0L2KwRONRgKM49PWvnLuf+t0v4pCa5gOPceL7WSe5KbW9Oj0Tr7foyIdT9LjB5/S0kouIRPluvICfjvemWOa1FaIkB7bi3bLeFmRz8IWnwBAp2P7sNSCJZFUoJIj001/ysnWdFPtqOUEVrYfjeeegTZQBYPXzg4FYqIi9J1STjVtGWNwM+K6ms8RRQoCjVlR/UmqJrsViHER2ycjkudoE7ThSWrTMAhcBOjLbl8lQm6RxHSNOpuKvAYcHpRqtZ556ZKTRrnkUzhkzZ7qPCFTdFE6+PJtng5bKX0Moti7ftkU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On kexec next kernel, walk the LINUX_EFI_POISONED_MEMORY bitmap during
EFI init -- before memblock hands memory to the buddy allocator -- and
memblock_reserve() every unit whose bit is set. So a frame poisoned
under a previous kernel is never handed back out across a kexec.

This runs from efi_config_parse_tables(), early enough to keep the
frames out of memblock and the buddy allocator.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/efi.c    |  2 ++
 drivers/firmware/efi/poison.c | 71 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/efi.h           |  2 ++
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 111e60479211a..7474eeebb0add 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -812,6 +812,8 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 		}
 	}
 
+	efi_reserve_poisoned_memory();
+
 	if (rt_prop != EFI_INVALID_TABLE_ADDR) {
 		efi_rt_properties_table_t *tbl;
 
diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index 2f47293a4e45f..e418c6b3aab81 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -3,8 +3,9 @@
  * Runtime handling for the LINUX_EFI_POISONED_MEMORY configuration table: a
  * bitmap with one bit per EFI_POISON_UNIT_SIZE of physical memory that records
  * hardware-poisoned frames so the next kexec kernel can keep them out of its
- * allocator. The stub installs the (empty) bitmap; this kernel sets bits at
- * runtime.
+ * allocator. The stub allocates and installs the (empty) bitmap; this kernel
+ * sets bits at runtime; the next kernel reserves the set units before the
+ * allocator comes up.
  *
  * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
  * Copyright (c) 2026 Breno Leitao <leitao@debian.org>
@@ -16,6 +17,8 @@
 #include <linux/efi.h>
 #include <linux/io.h>
 #include <linux/log2.h>
+#include <linux/memblock.h>
+#include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/overflow.h>
 
@@ -128,3 +131,67 @@ void efi_hwpoison_record_pfn(unsigned long pfn)
 
 	set_bit(unit, efi_poison->bitmap);
 }
+
+void __init efi_reserve_poisoned_memory(void)
+{
+	u64 ppm = efi.poisoned_memory, phys_base, unit_size, bitmap_size, off;
+	struct linux_efi_poisoned_memory *pm;
+	unsigned int nr_units = 0;
+
+	if (ppm == EFI_INVALID_TABLE_ADDR)
+		return;
+
+	pm = early_memremap(ppm, sizeof(*pm));
+	if (!pm) {
+		pr_warn("Could not map poisoned-memory table\n");
+		return;
+	}
+
+	if (!efi_poison_table_valid(pm)) {
+		/* Keep the runtime side off a table this pass rejected. */
+		efi.poisoned_memory = EFI_INVALID_TABLE_ADDR;
+		early_memunmap(pm, sizeof(*pm));
+		return;
+	}
+
+	phys_base = pm->phys_base;
+	unit_size = pm->unit_size;
+	bitmap_size = pm->size;
+
+	early_memunmap(pm, sizeof(*pm));
+
+	/* Reserve the table itself so it survives a further kexec. */
+	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
+			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
+			 PAGE_ALIGN_DOWN(ppm));
+
+	/*
+	 * Walk the bitmap a page at a time and reserve each poisoned unit.
+	 * memblock.memory is not populated this early, so memblock_remove()
+	 * and memblock_mark_nomap() would be no-ops; a reservation is what
+	 * keeps the units away from the allocator.
+	 */
+	for (off = 0; off < bitmap_size; off += PAGE_SIZE) {
+		u64 chunk = min_t(u64, PAGE_SIZE, bitmap_size - off);
+		unsigned long bit, nbits = chunk * BITS_PER_BYTE;
+		unsigned long *map;
+
+		map = early_memremap(ppm + offsetof(struct linux_efi_poisoned_memory,
+						    bitmap) + off, chunk);
+		if (!map) {
+			pr_warn("Could not map poisoned-memory bitmap\n");
+			return;
+		}
+		for_each_set_bit(bit, map, nbits) {
+			u64 unit = off * BITS_PER_BYTE + bit;
+
+			memblock_reserve(phys_base + unit * unit_size, unit_size);
+			nr_units++;
+		}
+		early_memunmap(map, chunk);
+	}
+
+	if (nr_units)
+		pr_info("reserved %u poisoned unit(s) (%lluK each) inherited across kexec\n",
+			nr_units, unit_size >> 10);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index f03b1bb576133..350a3cb0babdd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1285,8 +1285,10 @@ struct linux_efi_poisoned_memory {
 #define EFI_POISON_UNIT_SIZE	SZ_2M
 
 #ifdef CONFIG_EFI_POISONED_MEMORY
+void efi_reserve_poisoned_memory(void);
 void efi_hwpoison_record_pfn(unsigned long pfn);
 #else
+static inline void efi_reserve_poisoned_memory(void) { }
 static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
 #endif
 

-- 
2.53.0-Meta


