Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0ABF532C8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898986B0093; Mon, 23 Mar 2026 21:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821776B0095; Mon, 23 Mar 2026 21:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737A06B0096; Mon, 23 Mar 2026 21:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D38A6B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:28:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C50A4BE764
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:56 +0000 (UTC)
X-FDA: 84579222672.05.4EE3D7C
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id ECE031C0010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:28:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=UUVp0Lic;
	spf=pass (imf18.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=UUVp0Lic;
	spf=pass (imf18.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774315735; a=rsa-sha256;
	cv=none;
	b=hQNNAVDfcWZOVj4XvwFCc5Qep/4X8mnaF2Ixduiyh9o5HzO9CP2Nn4BVlcCbWT1W0P3hsW
	KWmS2Cg6aBx7ziTsb9aveEJOsKL9PsDwwDv2tCL4AKohn1t+uJ+oEzKIkUUILEvjGD6A05
	ODP86wfN2wf2+EIq6Vu3Z/6reo9QAmM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774315735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vl65OewpyCNb1x+ocrpJYTSNh8NK5VQ+ZXQ5NOHIbn0=;
	b=GIs52UgmQC2CLKyx66oRwXdeuuK5dRD4Nr5QiSAaAV7YGr29uVDdbn1G2gwIFChfbfbI8O
	OZfDkNX7rlysB8+8Rze9aS75P++NP1vhvLdhFAZi+l/Tf9PG/RyA8Ruae9Mx5Ajtxby3HG
	+ysCDu16tako/2SKiRvMY4Czcz4bOk0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vl65OewpyCNb1x+ocrpJYTSNh8NK5VQ+ZXQ5NOHIbn0=; b=UUVp0LicBjb96wh5AXNZ3wFGBA
	BB9wP/mHQWju/1m3lCwIBLKBI96h/oKA6YpMkEWwCQ9AxehRtJ2dqUKZ0O0JX41n6DBd5GJF62DWi
	iVWkGgxxdU8rzQP5w5C4TkhBjEDvlY+g705KMYtY1t4II+OPuuL+uLoNdJgWvDaPZm23AN8zi4wpy
	pg2FvX2YbemW2d9EbjKllhjFcIaShhhBWsqmLLI1qllY/y9P9/T5o2DNbubnq7a2S99uHP8OILlNX
	XA2KLPSybXgezXdrJ8lgSKYocpmnycBhD4cC5JtGkFLw+dG9oV3/rABzvly+YjsbKyHoYFOFmR/4a
	RkqVBzfQ==;
Received: from [179.93.15.111] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w4qZg-0058EG-Bd; Tue, 24 Mar 2026 02:28:52 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 2/2] mm/memblock: Add reserve_mem debugfs info
Date: Mon, 23 Mar 2026 22:22:18 -0300
Message-ID: <20260324012839.1991765-2-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260324012839.1991765-1-gpiccoli@igalia.com>
References: <20260318190816.1811325-1-gpiccoli@igalia.com>
 <20260324012839.1991765-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECE031C0010
X-Stat-Signature: s6un6ruzzrg4x8ytsfe4jtumey6u8ajp
X-Rspam-User: 
X-HE-Tag: 1774315734-621505
X-HE-Meta: U2FsdGVkX19d2fIhfhVWEJ2wJAwbIInIM2HFKO5M9iG7947iK/t6Gohrka4pk1nV0fi5KVKKqWn1lnmpEKIQvWa+QSrDaENfJCJ6Hc29AYz13JczBjqlooeHeI7B5kT8/427Opzh9V+gTHa2bMtLxW6dPQ4emcxIE4a6aGGZKyFt0/YIGfp3JcZRfHuTpQoX8LK4tM+7x93Gl6ekXdBXgX/8ZLC0w2nAIDiIQ1lmQorPo5NmJlG1HpaJstAcEJi8D9HY7BsDdj5neaIKdcA3CYtJkolpFyl4WsUhVh4vCoTxyVc6isuiNRQSmty9LUWdu312KwrLjcbF0XgeZVNKe5jyMfAqizyiM79maoNB7H/mGBrYw5ys0ohYbE2nFUMkDfSS96r+r64I3xp96YwgmzCVk8tLOdYupyeAZwZINvzYXQpDwMiKI9PZgmFhnJ92ot1QEBVLUMjy4iMA1MChdtatl/MuGmW/8Gl4c4WRq2dLGjQBEkWcYAfGh3WOCbnlxYeQjhscqV2A1iuE4SWr763Y2HLuxgIu9mQNWemkB5qYqR+3tX78kV6CFN/AIll//CpFCljautiWxb98KQ/vZDbavlrtEDkbKlGs1jE5BhLa+PsfiaxGOrEJkqLI8UbidT84Q1+jWMr3gV2NwD5M52Vjf4x5rpexhHFecgkpgv7meHPt/H3K0ImFPCLDYUm1Qj10kmHFq2CSV2B5GHlWr8pqqoqP4x9mUJkXx/MVoF8BXQ20TocJnjz8ZletUgCZMraJ+LlSZBTB2/ROUQnNdQj2GjObbloq4ASTJXnOVn8V4he6XtLXGzSvJyLid4yRPBERe5E8X6YCzvIvr0HsoV0xjHew0DZCgIdFhQuU8w1jl6yiuiFWzRDGxMpLWmUjL+vVYXZ1HJVhXgDuU9ztcgQfiwb7QUEhyXBBggOxEF8+ToYGpUfHUUrd0wF1HjUqHVR1zqJ0VfZFoZkBx5a
 XLnsxCt0
 ZPZS4Eb4iqgfXZ4F+Bzva2ZkE7JTEt9uRaiKuTvV74V5o3Epl0cuOTEh6IZVqqMKayB04T98XSyzvyTYo+9LMdP6Q8HJmowqcgHNPQd2+xcZFHWU+r1LF2/dNDMUWL+UxX+Ef3CmOeODavxu3qeyn5waKZZFcZhhGsBAaynql5T8O2YbbtcgjK8wtMA07Zqt2DmNpG4vnNFIYNxVrhbSFzBbAp9Ey9UB7TVMdy+vkL7WSmtjUehRSY/wSgry+S5A5LomeYMPhfrDS51WJATwnyVE8UbdqUtPzQ/Vm0j1I7219Pmp1hnWK7cTCzqQTraUJ2yXKM3xcNvBi8BG3kEtATyxWXAf30xa3miTMj2HznGvutt14NazShi5lLJitAvhd7vLIZY8OXd1eGKHorqwGwqECX+cIgJ5b36CxWflFzpbFyeUlKTdtQeM8o68nuixi7MxczMtz+nSijPx1QRVEZhGGr6e+v6/44sxCofSncT7+8Xg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using the "reserve_mem" parameter, users aim at having an
area that (hopefully) persists across boots, so pstore infrastructure
(like ramoops module) can make use of that to save oops/ftrace logs,
for example.

There is no easy way to determine if this kernel parameter is properly
set though; the kernel doesn't show information about this memory in
memblock debugfs, neither in /proc/iomem nor dmesg. This is a relevant
information for tools like kdumpst[0], to determine if it's reliable
to use the reserved area as ramoops persistent storage; checking only
/proc/cmdline is not sufficient as it doesn't tell if the reservation
effectively succeeded or not.

Add here a new file under memblock debugfs showing properly set memory
reservations, with name and size as passed to "reserve_mem". Notice that
if no "reserve_mem=" is passed on command-line or if the reservation
attempts fail, the file is not created.

[0] https://aur.archlinux.org/packages/kdumpst

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

Hi folks, here is the V4 with the changes suggested.
Thanks for reviews and suggestions!

V4:
- s/memblock_debugfs_make_dirs/memblock_debugfs_expose_arrays/g
  (thanks Mike, apologies for my braino!)

- Didn't change the code order of `#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP`
  (Mike also - thanks)

V3 thread: https://lore.kernel.org/r/20260318190816.1811325-1-gpiccoli@igalia.com/


 mm/memblock.c                                 | 48 +++++++++++++++++--
 tools/testing/memblock/linux/string_helpers.h | 10 ++++
 2 files changed, 54 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/memblock/linux/string_helpers.h

diff --git a/mm/memblock.c b/mm/memblock.c
index ac08d7f8c15e..ef9c0bf59338 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -17,6 +17,7 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
+#include <linux/string_helpers.h>
 
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
@@ -2710,7 +2711,8 @@ static int __init reserve_mem(char *p)
 }
 __setup("reserve_mem=", reserve_mem);
 
-#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_ARCH_KEEP_MEMBLOCK)
+#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
 static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
 	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
@@ -2757,10 +2759,8 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 }
 DEFINE_SHOW_ATTRIBUTE(memblock_debug);
 
-static int __init memblock_init_debugfs(void)
+static inline void memblock_debugfs_expose_arrays(struct dentry *root)
 {
-	struct dentry *root = debugfs_create_dir("memblock", NULL);
-
 	debugfs_create_file("memory", 0444, root,
 			    &memblock.memory, &memblock_debug_fops);
 	debugfs_create_file("reserved", 0444, root,
@@ -2769,7 +2769,47 @@ static int __init memblock_init_debugfs(void)
 	debugfs_create_file("physmem", 0444, root, &physmem,
 			    &memblock_debug_fops);
 #endif
+}
 
+#else
+
+static inline void memblock_debugfs_expose_arrays(struct dentry *root) { }
+
+#endif /* CONFIG_ARCH_KEEP_MEMBLOCK */
+
+static int memblock_reserve_mem_show(struct seq_file *m, void *private)
+{
+	struct reserve_mem_table *map;
+	char txtsz[16];
+
+	for (int i = 0; i < reserved_mem_count; i++) {
+		map = &reserved_mem_table[i];
+		if (!map->size)
+			continue;
+
+		memset(txtsz, 0, sizeof(txtsz));
+		string_get_size(map->size, 1, STRING_UNITS_2, txtsz, sizeof(txtsz));
+		seq_printf(m, "%s\t\t(%s)\n", map->name, txtsz);
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(memblock_reserve_mem);
+
+static int __init memblock_init_debugfs(void)
+{
+	struct dentry *root;
+
+	if (!IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) && !reserved_mem_count)
+		return 0;
+
+	root = debugfs_create_dir("memblock", NULL);
+
+	if (reserved_mem_count)
+		debugfs_create_file("reserve_mem_param", 0444, root, NULL,
+				    &memblock_reserve_mem_fops);
+
+	memblock_debugfs_expose_arrays(root);
 	return 0;
 }
 __initcall(memblock_init_debugfs);
diff --git a/tools/testing/memblock/linux/string_helpers.h b/tools/testing/memblock/linux/string_helpers.h
new file mode 100644
index 000000000000..dbf015cfff31
--- /dev/null
+++ b/tools/testing/memblock/linux/string_helpers.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_STRING_HELPERS_H_
+#define _LINUX_STRING_HELPERS_H_
+
+/*
+ * Header stub to avoid test build breakage; we don't need to
+ * actually implement string_get_size() as it's not used in the tests.
+ */
+
+#endif
-- 
2.50.1


