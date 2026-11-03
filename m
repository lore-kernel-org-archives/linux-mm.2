Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FE4606A33A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=foTj8Nvh
Received: by kanga.kvack.org (Postfix)
	id EA4FC6B05DD; Tue,  3 Nov 2026 03:09:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73BF6B05DC; Tue,  3 Nov 2026 03:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62DE6B05DD; Tue,  3 Nov 2026 03:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B31EF6B05DB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:09:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EEAB4035D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:49 +0000 (UTC)
X-FDA: 85393084098.20.A6D5345
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf13.hostedemail.com (Postfix) with ESMTP id 49E7720002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=foTj8Nvh;
	spf=pass (imf13.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3gZPUQLWwPhGV6D4A+78sPcL2sUrR6F9w4Qn0I0nOg=;
	b=dBzkaDNOU81q/V9SmvjHt43UsJLyrM3hZePtaO1/GDWzO3P1I4VmfKMvHZI6sNZ02gtUj3
	zYVUf9IJ57LgM563Fl8skJLshpUwVq4mpB35rzi/9PMnSzp6XL/WYYvofPDfpaZsEAhpkh
	RkAJ3gSz+YScS+BdOcdHCoTmee+D3Ls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693387;
	b=2KkFS2xuUkR8e/Rm91ItgNxUczyOR0zkEwm3OE/Nku5ntrCD5dhbH0U+TDJ9SvEcoD+9ym
	BSIE1pSIj9qFZ1/ebbVa7bh7qUNfuXUvF/8H1rssp3qbUaK+igWLg7uHiSOs18677qAEx5
	YBVzWMKo9ZSmSe89yajUBalGvuwVSDA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=foTj8Nvh;
	spf=pass (imf13.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793693383; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=o3gZPUQLWwPhGV6D4A+78sPcL2sUrR6F9w4Qn0I0nOg=;
	b=foTj8NvhwHJ8LrqJZz8NLfh2gIGkLDqGDqvF4R5zmt9ndVuyNwzaRIk6lVPQxHX2MO60qkRAkNXfyZiId/wCg2FXlU7W4Blk0zUnTLKB0BWb77C7mODbyXvTwXAp4jBklevnjERTGP+H3FraGRBhvNb29W6eY0YNSx4+YCw/uok=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XE27L.Y_1793693380;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XE27L.Y_1793693380 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 16:09:40 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH v2 1/5] kho: Do not translate the handover FDT address in is_kho_boot()
Date: Tue,  3 Nov 2026 16:09:22 +0800
Message-ID: <20261103080926.2079-2-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103080926.2079-1-cp0613@linux.alibaba.com>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5drw8g431u87yyc4rb5cixkei34hboxj
X-Rspamd-Queue-Id: 49E7720002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793693385-310568
X-HE-Meta: U2FsdGVkX1+8WrAX4i0F5aAYilLMX2hL6xUfwyix+d9gqNQhctrg61uOu1IkGGOVs3BN0Ez9j+HKxlHik2szWhh5rwxvKpFbG05mSk4AQSwArqssD3nPz4gAuMOIBJlgv9EbjHKy5efJ1k6IgVCNMSzK1XMwNwW3unq5dklGCPul3qpna2j7fK23l9KlzC6ZuMtzjwBG92+FO/1qtl6SgUmQNSTP9uXgIKCj9qGxhaPTQQDVv9t1qTYIjygnHtkW1y6CycW3p0gHIWRayWS+s8csoSCWePscwrWaRhTdEW27zBrb17WdLifrPONWenyVPuv7dpXKcqE5EiM62AFybhRDsCg6FfUs6cGfK0AZ9dOjHG+Nd+x4OHWHi/6KbvD1UEB0faov9QA+eP24b3JtbQ9BXhnAn10Tu1FbiGNxaFFY4nuzP33ybPh/tJFzIG7SFfWiJtQgLZCroqsikZ0OQdMBkMTNGneVgUk6hAL80CFo3AwkWYtHCf5+CR10qhkozg6RMhhfulwk/K31+GAzKKIu/6rnJX2EhuN01SK98uA32f/IYNY6jY5Goj5UhIePFd2ppy9dJRtGtEGrUGIShzp1NYcryt0gpDyb/lyXBL01KpqGFkD+qugilZO5DLK0F+sdPWpBw3xJSvhvgqMnxmC6GmkfHBjah94VlqAABfn+phYkEBQLxpAnaCuux0RY4ppIPqTKoD1pShvmzBrGLV8Q3WDgb7pRQpIu9sbcVElQsPjqZcCf99nQv7lr5/kXAlM7gSpjM6DbKy2wxY53eu6eHRVL8gJF4V9RqSuRnZC71t6DaMPiS22d24//SYgCVG0KzMhaf/krlbDc8Ta2bEtUXL1mIP4pJ9oWJ2Hb2c05GzAZgOSDRiRwCWLNakTmwdKaEp5Yc8Fw05bx8zr81MPeh+Tubm3UWtnU4VSiCZazCwdyZlcN5EapxMfuc3SkHUwr69Xaxd8ibCdVNpi
 Q0NxJJF7
 FbhT7gxjwSZ4/Y/1JoPEnAOZkXSSbaVF2fD0sqNKs66Uf8Zy7mh5BOpH9spYWLE4kRnxT6lCAvgWLGO/3FTRjwIaBxs9ON71K7DUByvAHynS/eHANunR5azfzVGLzLV4Dle2yimXNX1ywN1yOPoJ+ZGc19uTD0Nh0mNOnImwUJoBu1o541LgFv5FoGw5wGwC/s+rs0RF87ajiTLxgRleBFesVJY/oj+1vYARhZA4G8lsWZNvl6D3CsMCzYqfbNODA2eJvdfsHMYUZWXlfmbgWcb9QGPM2nOK6ifvG+3QdfSlUP+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

is_kho_boot() only has to say whether a handover FDT was recorded, but
it asks kho_get_fdt() for one and so converts kho_in.fdt_phys with
phys_to_virt() just to throw the pointer away. Both callers use it as a
boolean and never dereference the result.

On riscv64 that conversion is not valid yet when efi_init() reaches it:
setup_vm() leaves kernel_map.va_pa_offset at 0 and setup_bootmem()
assigns it later, so a handover boot that came through UEFI panics in
linear_mapping_pa_to_va(). Only debug builds fail -- without
CONFIG_DEBUG_VIRTUAL __va() degenerates to "phys + 0" and the boolean
stays correct -- but the panic also goes unnoticed without an earlycon.

Check the physical address instead. Nothing needs the translation, and
architectures stay free to bring their linear mapping up whenever they
like.

Fixes: d6d511639185 ("kexec: introduce is_kho_boot()")
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---

Tested on qemu-system-riscv64 (virt, -cpu max, TCG): edk2
RISCV_VIRT_CODE.fd/VARS.fd on pflash with OpenSBI fw_dynamic.bin below
it, and a GPT disk holding an ESP with grub plus the kernel and an ext4
partition as rootfs.  Kernel config is riscv defconfig plus
DEBUG_KERNEL, DEBUG_VIRTUAL, KEXEC_FILE, KEXEC_HANDOVER and the kho
selftest fragment; the outgoing kernel gets "kho=on" and the kho
selftest init does kexec_file_load() followed by reboot(RB_KEXEC).

Before, the first handover panics.  earlycon= is needed to see it: the
BUG precedes console registration, so without an earlycon the machine
goes silent right after kexec.

  KHO: found kexec handover data.
  efi: EFI v2.7 by EDK II
  kernel BUG at arch/riscv/mm/physaddr.c:47!
  epc : linear_mapping_pa_to_va+0x1c/0x1e
   ra : is_kho_boot+0x18/0x28

After, the same setup keeps handing over until the window closes, 29
consecutive boots and no BUG.

  KHO: found kexec handover data.
  KHO: exec from: 7.4.0-rc1-next-20261102-00005-gfca49e548231 (count 29)

 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3181..6ab181de345c 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1643,7 +1643,7 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
  */
 bool is_kho_boot(void)
 {
-	return !!kho_get_fdt();
+	return kho_in.fdt_phys != 0;
 }
 EXPORT_SYMBOL_GPL(is_kho_boot);
 
-- 
2.50.1


