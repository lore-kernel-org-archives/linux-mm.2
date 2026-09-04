Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF739C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0422D6B0095; Fri,  4 Sep 2026 06:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A296B0096; Fri,  4 Sep 2026 06:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E725B6B0098; Fri,  4 Sep 2026 06:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0F5F6B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:10:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E4E84044D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:31 +0000 (UTC)
X-FDA: 85175660262.14.83D193F
Received: from mta1.migadu.com (out-97.mta1.migadu.com [95.215.58.97])
	by imf22.hostedemail.com (Postfix) with ESMTP id 612DBC000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AYLzmbE/";
	spf=pass (imf22.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788516629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTixsxuGb1ShvX5LUOrF9FQYyrN030TPzy93bsFnjSQ=;
	b=i4+QU4+n9XJLkDaK1k8UOpN2x2siLf2L+J0e2dkA1PL8NLH84Mk9T2t2CoQ0a/RbbsAZJx
	P5yuFfsV8CjKBwRcfIsWY8fGc7N4M+gWWMmxJmBINeAQ4McmiWXKCjD4RyqrCWDqNcbV5A
	Jj+itWDfjsg5WDhUPpBpv+xcOwDhP50=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788516629;
	b=h5D8530vV2XFM1/mh2IecTciLcAZkMOvOE8IyjhBnOVf/3W0/zA7LDpAypJt0LVukEBtgJ
	QqHM86xuIWeHYxO1U+juy4dw1pcbI7Ctc/a7hTBL8KnyOQ9zwNcqtTfGhQR0F8BYHlaPLR
	sSCrhPleVDN3v6He9/WIWYmIvcE7zbI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AYLzmbE/";
	spf=pass (imf22.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PHW2ypkolV+36MeBrIflBY2kZtvuYhFSqnZa7Us0mSc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788516628; v=1; x=1789121428;
 b=AYLzmbE/FGIjqb/RxtzTS+DUSvR0jYavfFzcCkRfshJdUEgZgXhn6WTPep8DaP7n2XdwA43l
 uF6FXivTRhc2Veyw3OUozQ88pX6+XXgimDqqKGuzCl31nBpIXGaWjqwr5rDTl/jKg7ZwV6Mlk3I
 WUckN/ZCqvqkYLWdPEYlL8+o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b181acf3ff0b524f;
	Fri, 04 Sep 2026 10:10:27 +0000
X-Mizu-Trace-ID: b181acf3ff0b524f
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
Subject: [PATCH v5 2/5] liveupdate: synchronize EFI KHO channel at execution
Date: Fri,  4 Sep 2026 18:08:49 +0800
Message-ID: <20260904100852.26006-3-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6m51s4cqow31hbtac4aqazs8wya73ogp
X-Rspamd-Queue-Id: 612DBC000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788516629-49766
X-HE-Meta: U2FsdGVkX18u/OqqLz3zOjxBzp+cgjo8OEuXCJ1ISS7VZes/cytfuHYvAWZWnLP0RrJK/DtkjDhE+UoluVH0OLK4McpwIRfIkOIDevZZfGfmJ0PggleptGKGHncgGIGFEFY6UvoxY4V0BjLNIUextlifpNcTQ9nMI6qB5Azx8jHb9OkMMM9z1aEqbl/pn6aZ2U0amXhiD7mAuiAJQi1Jxyo2KUiW+vq4vHSmxWKaOaeRw8U3w3DUB5cglaFSeieyHTHZ8ul6W4EpYvrFndwo7Tv7Nr+48V3iwFKZG0FfRAdhu3e0b1GwDzJWGKeIWn7+Pge9/dFgjEHLegW12m5SCcaLOqUBW0vcESkX0YSk/Fn7DbwI5QD9a7l/f4BILhGvrq8kxlzKxMhEKQM/IDkxyV9bBfVvHSvwZVwYLtDjRovojw+xk7ocSQBoENlr1hncThnU+bEEImuGQKvFJagBdjTmqSO2w6TV+05cXiL4wsf5+awlftW7s1Yy6CklgznuAYXH6NfxYp4mht+O2boa3icxRatFh0nU+uOjuyLHn+mF8zhBkOUDojOF6FhMZdjiGp9VssSOb3D/LpuznLn7wwTZvcqzndBJ2OGkHiiyCgZ8eNXlusIEODvikurjvL9kZio6MDQCzBEcvpo7i4iBQNeH0jkvRTUQQEVmwz3ZPwkoR5VLEEEELMeacpD+2PAonEMomYwFfWySSoyQipt03NNthA2u/zsNDot2PRtvdo22Bh96Jth16qUXdfzxOKH8BmHqrcKWA9puaJvBH4/g+uWFvhlbZ8JPKm3EpsWR6V2df7OK8yWDFa5BXSzqll57hy5Y0KXvlNUZH+JST5IOwgIZZml4Qo0Qd7BewRNrRyXnv56/yA1psqjWS4xhHKdpXXkn5EEOwMJ3m88pIAXIsmlS7klcAhg0qb3tgJeabZKIXPPAcjZ4DmcDNSiFrEpRkgFU36ksWWp4gQ2NZeZ
 fICjDRC1
 r116utCC9lxw2d86CtZZgxKKHbiDdvce007M3ljtdfdZEgAy39yBPqjEC2RKN80MxmlRkWL+FdMr6G02wb6MZpuFTIy57Birlt35t4czjHXZPLkEoZ+Rmzu0zdcU9+ZO9EG9Zx1hPGkiv9lFIZyRmZeeqRW3yqEAHH5uwFGyklHzLAKDZjsdlusPP++DXKYvCEw15pVhbhPcQ8Bh07V5K+0YuPeRtG2xYMB1/WaBYKl54bCwgFg5E3wIgFfcmtxHi6lGb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

The EFI KHO configuration table is a global channel. Updating it while
a candidate kexec image is still being loaded can leave the channel
pointing at the failed candidate even though the previous image remains
installed. Synchronize it instead from the image selected for execution.

Use the actual scratch payload size rather than its page-aligned segment
size, and propagate update failures before live-update serialization.
Keep clearing the channel for cold and crash images best-effort.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 kernel/crash_core.c                |  7 +++++++
 kernel/kexec_core.c                |  5 +++++
 kernel/kexec_internal.h            |  3 +++
 kernel/liveupdate/kexec_handover.c | 33 ++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 2b36aa9fade0..6166ce4203d3 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -138,6 +138,13 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
+			/*
+			 * A crash image carries no KHO state: clear the
+			 * transport so the crash kernel boots cold instead
+			 * of reviving from stale state.
+			 */
+			(void)kho_sync_channel(kexec_crash_image);
+
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d05..147f5b5b23d4 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1146,6 +1146,11 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	/* Synchronize the handover transport with the image being executed. */
+	error = kho_sync_channel(kexec_image);
+	if (error)
+		goto Unlock;
+
 	if (!kexec_image->preserve_context) {
 		error = liveupdate_reboot();
 		if (error)
diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
index 228bb88c018b..4d4c2290e85c 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -46,6 +46,7 @@ struct kexec_buf;
 int kho_locate_mem_hole(struct kexec_buf *kbuf,
 			int (*func)(struct resource *, void *));
 int kho_fill_kimage(struct kimage *image);
+int kho_sync_channel(struct kimage *image);
 #else
 static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 				      int (*func)(struct resource *, void *))
@@ -54,5 +55,7 @@ static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 }
 
 static inline int kho_fill_kimage(struct kimage *image) { return 0; }
+
+static inline int kho_sync_channel(struct kimage *image) { return 0; }
 #endif /* CONFIG_KEXEC_HANDOVER */
 #endif /* LINUX_KEXEC_INTERNAL_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 39f489a258d9..3aa5c66dfc6d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -14,6 +14,7 @@
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
+#include <linux/efi.h>
 #include <linux/kasan.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -2074,6 +2075,38 @@ int kho_fill_kimage(struct kimage *image)
 	return 0;
 }
 
+/*
+ * Synchronize the handover transport with the image that is about to be
+ * executed.  The EFI config table channel is global, while kexec keeps
+ * separate images for a normal reboot and for crash.  Write the state of the
+ * selected image immediately before it is executed, rather than while a
+ * candidate image is being loaded, so a failed replacement cannot leave the
+ * channel pointing at that failed image.
+ *
+ * An image loaded through the legacy kexec_load() syscall, a crash image, or
+ * an image loaded while KHO is disabled carries no handover state.  Clear the
+ * channel for those images so the next kernel boots cold instead of reviving
+ * from stale state.  Clearing is best-effort because an absent channel cannot
+ * affect a cold boot.
+ */
+int kho_sync_channel(struct kimage *image)
+{
+	int err;
+
+	if (!image->kho.fdt || !image->kho.scratch) {
+		efi_kho_update(0, 0, 0, 0);
+		return 0;
+	}
+
+	err = efi_kho_update(image->kho.fdt, PAGE_SIZE,
+			     image->kho.scratch->mem,
+			     image->kho.scratch->bufsz);
+	if (err)
+		pr_warn("failed to update EFI config table: %d\n", err);
+
+	return err;
+}
+
 static int kho_walk_scratch(struct kexec_buf *kbuf,
 			    int (*func)(struct resource *, void *))
 {
-- 
2.53.0


