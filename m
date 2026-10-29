Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276D6606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SZUGvWNW
Received: by kanga.kvack.org (Postfix)
	id 4EC096B05C4; Thu, 29 Oct 2026 13:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C34B6B061D; Thu, 29 Oct 2026 13:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401026B061F; Thu, 29 Oct 2026 13:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5376B05C4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:30:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6F8F1A0501
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:43 +0000 (UTC)
X-FDA: 85376353566.18.F4D938D
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7D9AE180014
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SZUGvWNW;
	spf=pass (imf06.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSsiRYPYB4jWimWdqbg3QYop0paA6TDT/mhOyO7eWso=;
	b=Xp6rzXLQuCghiwLoH84w9BYP5DXIzycGZG3BW6E6VggOT+pR2aKet/m0rOcJx5fLGUFsbf
	s2RFF3iYmL8Y4Qhm4sW3epkhyqh63m49rs2bPfdu/CevwJfEkoOUlD1eyMMXoAe2rvWKqp
	y+Q6Kk21GBzo7d8flPkhAB2QFoN6gsY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SZUGvWNW;
	spf=pass (imf06.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295041;
	b=csu7wHcG6EdE7PHD3yFVRM6bNZPybi8ygGjcKOmXnV07CAn6RdN+M8AQd89gC0uRYuOIDB
	IwJ1QvzH1X9SYRl41fb1svHI6hewJ4O1XYqhRXrDph+XJAg5mDj3DXtnqEybBiwRJkk0CJ
	Dig7eXkJW0FeDjJCPCCBRGtw2BSNnbM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0F/90IUVwRzQHSP39TV73suxQSXvMV7pstypaG7hBwQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295040; v=1; x=1793899840;
 b=SZUGvWNWuC0h8IrfeAwjCz3Xlk9iL5w+UP4R8gW5mrmM6RcMbWjS+yeVP7XMI0jpwSVVjpG7
 Sp9gsSYTsotUC30JsA1imETDvD5zHCpCSuhPZCOLihJT+SifTwf0+eVrJXm/idTs8te6Z3R+4qo
 ZQNIOl9/KYbsYq4gZt2zGWDU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 75f3584368055110;
	Thu, 29 Oct 2026 17:30:16 +0000
X-Mizu-Trace-ID: 75f3584368055110
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 2/8] kho: Write KHO state to the EFI table at kexec time
Date: Fri, 30 Oct 2026 02:29:49 +0900
Message-ID: <20261029172956.20791-3-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D9AE180014
X-Stat-Signature: mzif5mihdpt77rwuk6bfe6i4e7f67efb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793295041-247193
X-HE-Meta: U2FsdGVkX19gp7UxQR2/8moB4jGTgI4MZI50W0O3EmYIj4L2rFVwPQaLJ1W7W0UgAwphDlAZ36HZHemnIKIMJ2NsRXppBvHoF3R0YKngt0Pk7UZrrEZpK/DhPw7pqSsLuCaNGTlSnpsvm7YDeldYgTWLY9WvmrlQ8QTqDaqMOQYpZSTdxEYQ7RnSxsF8Oe62osg2hutxxckXDmAxPoA3plb2JJKozA0w1znDhOdBR2LSvvr0cZB41RR2R+QVNuOxSjOlApBDIJU7P9e/atGYcPZUdz2h9wTHAbI6j5bUL6JaU+hV9hENtzERiiK4d6LxnnCh1CsKuTfzlcVZprQ5LhSAtG+Foh8TwD9LHKDadKD1xwPRurhOd5q7tNEgKGFSB1IQIGSmErK2PfAi/yZ7n+VagK/SLauBNro/O8Q+VuxRrbnBU6NqQgoMe3519pOTyCFxIBWwsUWwGaepPRaa+NBMoZ/mMtp3NEorJOKDSduF/5j3jIPh8K7WAE8pLe5Zy6sRnamRxyolvu1SlK6I+Oi7j3ETo6OiAmLm53U/IxCk7lsDZmnGsIE2rjsNxVr2GT0GSRhhWcFCAHQ08S1zWHqp+hZisAkW+PJR2nMCKRvjYjsEO3SdZY9xd45uWwItcTqemLHlCoQKm8ak5GPbYmfF2lp/zHHQUTt4ulzQ/5ud0Xhc6ucnIOOcyqptWXXpGpeL5LmPfGibxJVDAnkJ1nnWFZHo4edWaJv/SPGmY2lQ2/uFrQEgbf+FwuKGpQLUjISiTdGlKyIIcjmB1TJcwJB3yO6GbBMIkZy6KgiNLW1/Kv0PmTUWQkdKn0uwHQwVv86vzYHBnMKg2TMaNph4QsZCXwADYY9l7Im/40IMbpm3OWsCvcSQ6yyrIU/HlqbqywkU5EGPxyDwZehEtj3TGFGigCzzyxS5RLeTn1v7viqOT8rEUA7bN+HMepG78DwYrJmz4IBqTOfF4qepm1H
 QWv+aPJh
 QJMMUxkRohSLjqlzy4nydIM0XDxgGIj6mVqGUtWdoglwE/2mYIkRvPmM1k11T0Mbjk0gXDz+O049ocV+U+ehmq4LkM8USqnLpoW5lnX8NxGhnT9dyu27hu+0fQXGbsbyp/Vy7Q0B/tD6uXwCmVyxcEUg5qF7Qaylik13dLRAK79sPKDzXxOXJynf2G75FZe1F1Hc1ZKwlMV8rmsI1cNMaB9bI/mNJvn/OZcknBawAH0RPjPqxuM2IUcqja3t83wDxmM31
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

On arm64 and riscv, KHO addresses and sizes are passed through /chosen
properties in the boot FDT prepared for each kexec image. On x86, they
are passed through a SETUP_KEXEC_KHO record linked from the image's boot
parameters. These records are per-image, unlike the shared EFI table.

The EFI table is shared. A KHO-enabled normal image and a crash image
can both be loaded, but need different contents: the normal image needs
the KHO addresses, while the crash image needs an empty table. Updating
the table at load time cannot satisfy both.

Write the table in kernel_kexec() and __crash_kexec(), once the image
that will run is known. kho_update_efi_table() fills the table from that
image, or zeroes it if the image has no KHO state, including images
loaded with kexec_load().

Clear the table even with CONFIG_KEXEC_HANDOVER disabled, since the
kernel may have inherited a populated table. This prevents a later
kernel from trying to revive obsolete KHO state.

The table stores the size of the bootmem area list (bufsz), not of its
page-aligned segment, as the FDT and x86 code do. If updating or clearing
the table fails, kernel_kexec() returns before liveupdate_reboot(), so
LUO does not save state that the next kernel would not find.
__crash_kexec() ignores the error so the crash boot can still proceed.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 kernel/crash_core.c                |  6 ++++++
 kernel/kexec_core.c                |  5 +++++
 kernel/kexec_internal.h            |  8 ++++++++
 kernel/liveupdate/kexec_handover.c | 26 ++++++++++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 2b36aa9fade0..0f77adc0928b 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -138,6 +138,12 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
+			/*
+			 * A crash image has no KHO state.  Zero the EFI
+			 * table so the crash kernel has no inherited KHO state.
+			 */
+			(void)kho_update_efi_table(kexec_crash_image);
+
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d05..37597091770a 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1146,6 +1146,11 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	/* Write this image's KHO state into the EFI table. */
+	error = kho_update_efi_table(kexec_image);
+	if (error)
+		goto Unlock;
+
 	if (!kexec_image->preserve_context) {
 		error = liveupdate_reboot();
 		if (error)
diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
index 228bb88c018b..cfdd0b158f72 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -2,6 +2,7 @@
 #ifndef LINUX_KEXEC_INTERNAL_H
 #define LINUX_KEXEC_INTERNAL_H
 
+#include <linux/efi.h>
 #include <linux/kexec.h>
 
 struct kexec_segment;
@@ -46,6 +47,7 @@ struct kexec_buf;
 int kho_locate_mem_hole(struct kexec_buf *kbuf,
 			int (*func)(struct resource *, void *));
 int kho_fill_kimage(struct kimage *image);
+int kho_update_efi_table(struct kimage *image);
 #else
 static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 				      int (*func)(struct resource *, void *))
@@ -54,5 +56,11 @@ static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 }
 
 static inline int kho_fill_kimage(struct kimage *image) { return 0; }
+
+static inline int kho_update_efi_table(struct kimage *image)
+{
+	/* The previous kernel may have left KHO state in the EFI table. */
+	return efi_kho_update(0, 0, 0, 0);
+}
 #endif /* CONFIG_KEXEC_HANDOVER */
 #endif /* LINUX_KEXEC_INTERNAL_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9a53d7750367..74c4633f5afc 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -15,6 +15,7 @@
 #include <linux/crash_dump.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
+#include <linux/efi.h>
 #include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -2094,6 +2095,31 @@ int kho_fill_kimage(struct kimage *image)
 	return 0;
 }
 
+/*
+ * Write the KHO state of @image into the EFI table, or zero the table if
+ * @image has none.
+ *
+ * There is one table, but the normal and the crash image can both be loaded,
+ * so the table is written just before @image runs rather than at load time.
+ * Crash images, images loaded with kexec_load() and images loaded with KHO
+ * disabled have no KHO state. Zeroing the table for them makes the next
+ * kernel boot without inherited KHO state instead of reading stale addresses.
+ */
+int kho_update_efi_table(struct kimage *image)
+{
+	int err;
+
+	if (!image->kho.fdt || !image->kho.bootmem)
+		return efi_kho_update(0, 0, 0, 0);
+
+	err = efi_kho_update(image->kho.fdt, PAGE_SIZE,
+			     image->kho.bootmem->mem, image->kho.bootmem->bufsz);
+	if (err)
+		pr_warn("failed to update EFI config table: %pe\n", ERR_PTR(err));
+
+	return err;
+}
+
 static int kho_walk_bootmem(struct kexec_buf *kbuf,
 			    int (*func)(struct resource *, void *))
 {
-- 
2.53.0


