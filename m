Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 011EC1077609
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6022D6B02EC; Wed, 18 Mar 2026 15:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3776B02EE; Wed, 18 Mar 2026 15:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0336B02EF; Wed, 18 Mar 2026 15:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1B16B02EC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:09:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB7E81B67C6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:09:54 +0000 (UTC)
X-FDA: 84560123508.16.F0FD759
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33CAC180007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:09:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=mEMl3BB8;
	spf=pass (imf16.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773860993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9aQ9DqpNpZmEebvsRHFhSx+09H/nA+yNH+hxL6fCjs=;
	b=scaE1jR39R+whintG6uMa/17hP2dHIWdt35Bdj54L5M+YHbWivwAC2IjXv2pw9KC097yeO
	i9Eb6oIZ30gjseFQlyrMGsO5X0Hjk+Q8QeQbcQUPib2HQO0IEM7/iNI9bOsk5OQHP2ZHg7
	35+2xsU5TsM+Vql2n5lTUBGD5nyl1t0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=mEMl3BB8;
	spf=pass (imf16.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773860993; a=rsa-sha256;
	cv=none;
	b=l5IKVcVLxh8oUIjcef1alnKWYQ9ZVriymV0K6kx84i6AKgd3ntsuKPxavk/XVYPDl/BN6S
	VwwjwkIJuoDquYBY7bOet3jjnyWd3pmkFxOvz4VANW3oM5fVDw3gLrOiJHWl6T9YafF8cd
	s69GGGxPuxF2DsEJmRxGHLfv/BcoSgk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s9aQ9DqpNpZmEebvsRHFhSx+09H/nA+yNH+hxL6fCjs=; b=mEMl3BB8rYYMAsvbZBVmtVsl9s
	yrkMpj60e++5MMR4RsqQiF5ugE2gsz9q70Sj6emPfXbl/T56VIrtcLn2AkVcyhveZtoiOju0p+rU/
	UpY4xpCfTBaaEWS1KwjrJNwbpqEw6VXsurRah48NbvW9FS9Mm5akDaRijndqkybNJKygXJq+Rdyus
	ZKktJMO9bCWzOvMvT3oodRsYaAbZ0y0gjB4yQBzeEInUDzIsHApgJtedxC+vB4ExY4GEt9MyOFPD6
	7/akArpQK7PPycQjhOz5BcbkYc2ooMaFeLZkzkNJyA7skvN4WCHB7MPzICt0IHSYE9iKEIXh7EC03
	CMs9BQ6A==;
Received: from [179.93.15.111] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w2wH8-002x66-Uv; Wed, 18 Mar 2026 20:09:51 +0100
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
Subject: [PATCH v3 2/2] mm/memblock: Add reserve_mem debugfs info
Date: Wed, 18 Mar 2026 15:56:33 -0300
Message-ID: <20260318190816.1811325-3-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260318190816.1811325-1-gpiccoli@igalia.com>
References: <20260318190816.1811325-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 33CAC180007
X-Rspamd-Server: rspam07
X-Stat-Signature: f9j49q1q5ekp8pxqcjxke7i1mdgms5xn
X-Rspam-User: 
X-HE-Tag: 1773860992-256185
X-HE-Meta: U2FsdGVkX18+rZ3F5s7CZrKpHG+dVeh9EapZJG/UyxAsnsrwlRHnWeqWskmDxYl6QncdOm5FRUNwcDELCmOFDh2wZLLrp+EVvXY4bQDG0FMjYCuFziAAyQjLm74TbwgFHecS+GcEPf1KGfFtDD9rBz0ozqALV869FfQAegoaGAQ4FIT5hRGLdKNg0NeWUPLVpDo7Xx1lEJGDOFBhZXjjrTJdxwMqy1BgcmH9ZDr0N4tDeE76yLbRkhKOhPQ/d7BeSLGWhFmqXLtglAABvZY+XiJiWS8v6u8Rih05P7QXkFo0RL4QfFIsyZ/K9UmHb1tZUNcLgrung+0IvwVBbpmx91qToE6isd/d7CmslXfqS38GaTkiey9D3gvZRc23yeGKw+9G+iXGKynuTdLdHyrxRbZFxMU9cniUi57pqFPM6kAnXRApmXckyjSEe8Ojx5O0sKD9sDZkOUwhKVuy/rym8e7o0mRNA9lTXq7HVg4NH2uCjROb/Con1L5/Ps9ftkXHo5aWsUmpRUz0oHEji08byjrZjQmm5ZKT/dRseh84T29SKaSw/8yYUZ7muacJ8axU0G0kxcx2NpUD5Besk7GR9F5pi6M6xaOzCyVgKQUfYGe7ntX7brog7WjD/8fJEfnPZZhu9Do+G8r/qPrg17qr7Q8Dox628QYt6YYrsTcBh2oV2mUZlSq0GZFesIRHQ0FzOlQkjz+hEv0nmkDQWhBMzRdSCWREIZReUM5UNYWSCyNFBjFBXjkRH4zcfYVuJVg3zvxQTtentxmaesgxyMkZIMfch155LU7pH6d+9WVWOFikVJM2qZ03fSkuXw37CsCukw04bjJW6xX7lCWzaXtVRxnLmM6mpJ+KD+SD4NUH3wGX21Te9wWnn38MBPna5YhlC+qdG1ufNFthN4Tq98aDi9gcglnbOLp+3e8LThK4sGHWYbsLpURGi1EqZzYu+BWNo4S1woAfYogcUpDczCf
 M4qWhN15
 YiDpm5Pbse16s2v1saRxhBgMC3uOphdiibmM+Ge9Hh06LBqvBlj4+fSMtmigTrlWXh5XZjnIEz8LCOi/I0MYNiTb7S+xKml44jzS6n82O50oLZ9VJptG6zGWB0dboOZW6NMo4F0aRIsVfzwRIDofEfBq7jcVI4DMvq13qH1GUNNyU/vjJXf6L+PiwvWHqVLzoVKwZPN7Zl3FE8+Zn5jgDZiRG0vBcu480Nb4smuKSrIRF4OftIB3Lh3Y4F37gTevlr5FaOL4CsJ8j1y89n/6Aj9MBNsBjOjpRUzM/YdyYmym0kQvC9MHacyEY3HGsIzrFF7cj7racXTAN+/a2e4zd4JkZ24Sr/rgtna9z9t7xOOrXcWr+eqeGvZO1EP/fdDCc7ryL1FH+TIy5fcHyddJCGOPC3VJfGmDytskvlaYYKmTAP33I9oQNcdf83pwddzlWhPmGidZE/yGaXCnedXk+JtJS2A==
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

V3:
- Added header stub to avoid build failure (thanks Mike!).

- Refactored the debugfs creation routine to avoid too many
ifdefs, also changing (!(a || b)) to (!a && !b) in the function
(thanks SJ and Mike for the suggestions in this one!).

Notice that I've inverted the order of file creation, putting
physmem (and its ifdef) *before* - the reason for that is purely
because in my view, the code looks better this way, the ifdefs
are a bit more far from each other. I'm totally OK in changing
it, up yo you folks.

Cheers!


 mm/memblock.c                                 | 56 ++++++++++++++++---
 tools/testing/memblock/linux/string_helpers.h | 10 ++++
 2 files changed, 58 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/memblock/linux/string_helpers.h

diff --git a/mm/memblock.c b/mm/memblock.c
index ac08d7f8c15e..f4219f434ce5 100644
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
@@ -2757,19 +2759,57 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 }
 DEFINE_SHOW_ATTRIBUTE(memblock_debug);
 
-static int __init memblock_init_debugfs(void)
+static inline void memblock_debugfs_make_dirs(struct dentry *root)
 {
-	struct dentry *root = debugfs_create_dir("memblock", NULL);
-
-	debugfs_create_file("memory", 0444, root,
-			    &memblock.memory, &memblock_debug_fops);
-	debugfs_create_file("reserved", 0444, root,
-			    &memblock.reserved, &memblock_debug_fops);
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
 	debugfs_create_file("physmem", 0444, root, &physmem,
 			    &memblock_debug_fops);
 #endif
+	debugfs_create_file("memory", 0444, root,
+			    &memblock.memory, &memblock_debug_fops);
+	debugfs_create_file("reserved", 0444, root,
+			    &memblock.reserved, &memblock_debug_fops);
+}
 
+#else
+
+static inline void memblock_debugfs_make_dirs(struct dentry *root) { }
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
+	memblock_debugfs_make_dirs(root);
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


