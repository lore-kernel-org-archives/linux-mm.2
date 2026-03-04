Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4FBAEFCE44
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 20:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787A86B0089; Wed,  4 Mar 2026 15:34:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F646B008C; Wed,  4 Mar 2026 15:34:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E90E6B0092; Wed,  4 Mar 2026 15:34:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C59C6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CC408C16A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:34:07 +0000 (UTC)
X-FDA: 84509532534.06.46CCEDB
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5C52B14000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:34:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Np0WFrvU;
	spf=pass (imf23.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772656445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pD4cx+Qs8foK5AODwyhhW7E99pbqcu5bSXgXaDf43Y=;
	b=uAiIx7/ku9j8lPKeGJYLpulJGZitazDq/6xNmJaIMz3OORnCEC42pNDCHX97GOu2uplcCx
	KnX/sbL98cprmqwMlybHhePPVVvVrLRD7lzTr/F0fQmRy8ng7AKZnh1K4JIdq4bh8Q9zPY
	V2BbDqai07mBHa7x+uwrC6KeL66QeA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772656445; a=rsa-sha256;
	cv=none;
	b=LsWdPzzVnCqd7XGjSIYnyVdlIJjOfvU1dr71looJvlFkyG0kv45ieOe8FE3TOdJESmjFIS
	RtvuOpeJWY5Bf+APuSArICCa4yJO12IO4rlbNIpovjAwjFUxysUfu0mHFZUCaN7oluSk+5
	IGpfr0ZF8YnnX0xLfIpFbqAwTW2kOyQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Np0WFrvU;
	spf=pass (imf23.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6pD4cx+Qs8foK5AODwyhhW7E99pbqcu5bSXgXaDf43Y=; b=Np0WFrvU46WW/Tonff+PtKMIKl
	BP6b+Q/cy0Evhm/iiw02rzIO1aSULGQLghwd4jD/jWldxrFCH5xs9IXojfjH9XM0cPYyvOFsJX9ou
	T7yZ7sbbQPba4hDGT+AQS5SZ5GjkBwgAlOhRRw6QhVK7DnkqU59p4YMbzKJZ1yy5B7/qDYDiczpA8
	6IwomZRjtoMcdGeWHOvucEbQQdmnl2LCnzPj05PSB9IIsT7nemp9DWM6sEnW5bHRNOTJPeuMnPVwR
	TYxRGMKK77cIFqxRnIy4i/RM+JEp685ZQJ81KhSb1vOEJdmgv7Qv0GH6p6zND9Yk5KEChr0oap8H1
	EowTfv/w==;
Received: from [187.90.181.146] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vxsux-0095KN-9M; Wed, 04 Mar 2026 21:34:03 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org,
	rppt@kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	gpiccoli@igalia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH V2 2/2] mm/memblock: Add reserve_mem debugfs info
Date: Wed,  4 Mar 2026 17:14:11 -0300
Message-ID: <20260304203300.1414286-4-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260304203300.1414286-2-gpiccoli@igalia.com>
References: <20260304203300.1414286-2-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: urpth3jfbgofpan4gi7a1c7hnatj1iq6
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C52B14000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1772656445-139071
X-HE-Meta: U2FsdGVkX190bUhpmu0sH8UZqK095qxfc3re+X7O38T786oX2OEJ+Qx0PVdMhA1JrbJJ83Bbr98KLz0w+/WSE+9kzynxqtvQCWJUsM1oo0EDYDfnZP7MVepl3B4CwoW9yjVR+40jglhuA+y+943tCDyNAwsSZQjNv6HFWAWo2JtQrzehubYnNeHbZxDfyOOwZBXAmGXYParMvv5w813iMO/Z+cS4AE6PuxEqm/Vpj0moTiSSXsesrDB53xl+Rw4r5eF1tAJHAfP1pRrWyWBjxKaripZ25s2cwNgsMWfIOqQWPgS5qPzNQg8WLrFoh+Jp3PRbfb0i7mTuhshpCuc13niWmJkxr5O8hPeOYGJ0twlz28xV0e07CWbf8WTgosnQ+z3DbPL1sUUXW/XOuydcd+/a0Wzo9HnZb+JyybtAvSLUd9ukWzudC4U4QwBkUlOdiZBOE7fUSj5iR9UvISEi1BTKhMD8R4pzSNm3GVbA5SGZRXRuZD1hPpA0GZnfAlcg5qnGBAuqLjyyMp6ziwEhKuU8EqPXI7DMPSoMP0uvVefruDPqMWpSuZVv7eupsYU0kcpC0OhE6MY5MBagFAafFUhV/0f+gLcq3wllnuwCDBCtPYsf9ALKbi3Tq5nuDhPXnK0hkHjWnMpVRqDyOxqIydQLmJiPHQuAivM1iXg5oqTbW0onsDwr1H+hCKeO2I/elnz/cmyYOnIqNSD+RGmsMDwC3lgrG4MQEEYzf5sp0p9DmPsORZJR3fLAV95nTlN9y4GEqkQKKpYtoXaLxydZZmOkaWT+KeQsDbMz5zE5vBG4r6tcWAl0zuQ2KC1H7yXdobAqU5QZqm5btA2VF/J5h91BRBTPybRoCQ5dlGcMDxy+EqHAv2827bvAH5hpZu4N09wOGPImBuoXx3AYOvHmlRBIgUCvxUpU0ntujrnnodL6XCyq+waD6uOcwGtq8LC+T0b6JZGXRHBMzJkgmko
 Z8jtU3Mt
 GNxh30gkkvcTayo2MkFRbcntjw9wlcCYU6mw0R8wBMmqm68aEFOT+FwR8XZSn60Zlly0y9Qdackl/n+sLXYHFli6Stbpkf13v/WsECxwnFEBlw+WncpqUrfIM/uxyqsp2EO8SWF3nMG1brmeJiRW7CgLNwpi4ivCo51lrRQaiQ79bRp6YLgm04S0mbjeIBh+Nheipg9pv5hXCLBQm4t8perOfGjo9mKPNcO4wwJOotlTOplR1Hn4AAS+t2mzECQ2uYw6L/g3v9y6nb21Cgs4ttOtfafnhBTGOudpsFg3B+Rjt1WWiwzKhseSJEG4OCggtjpDoF67dBFn/OGJOzf+v2yFEIxn6Ed/T7sQaKHtkvR6C8P+j0reISQ7igAiL54j8QsGxhF/hkp4tE35YwRbaiDZ1rqhbiHYl+IOeW4ho17juc/+qNC3uW7W/srZuEAE17OcOtL7hggLhT9wDxiuPDrnqep8hUtyUinwwUCtUJSfja8E=
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
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---


Thanks a lot for the suggestions Mike! I'm not sure if you would
prefer a Co-Developed-by or Suggested-by instead of CC, you helped
a lot improving the code. Lemme know and either I can re-submit
(with potential other changes) or even, you can change while merging.

V2: (all suggestions by Mike Rapoport)

- Commit message (showing use case);
- Drop ifdef on include "string_helpers.h";
- Don't show the address of reserve_mem, only name and size;
- Fixed flag names inside ARCH_KEEP_MEMBLOCK ifdef;
- Make use of its own show_attribute instead of refactoring
  the memblock one;
- Use sizeof() instead of magical numbers for the size;
- Don't show memblock directory if no reserve_mem succeeded
  and ARCH_KEEP_MEMBLOCK isn't defined (keeping current behavior).


 mm/memblock.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 2d2646f7a120..d816796ab919 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -17,6 +17,7 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
+#include <linux/string_helpers.h>
 
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
@@ -2711,7 +2712,8 @@ static int __init reserve_mem(char *p)
 }
 __setup("reserve_mem=", reserve_mem);
 
-#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_ARCH_KEEP_MEMBLOCK)
+#ifdef CONFIG_DEBUG_FS
+#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
 static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
 	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
@@ -2758,10 +2760,40 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 }
 DEFINE_SHOW_ATTRIBUTE(memblock_debug);
 
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
 static int __init memblock_init_debugfs(void)
 {
-	struct dentry *root = debugfs_create_dir("memblock", NULL);
+	struct dentry *root;
 
+	if (!(IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) || reserved_mem_count))
+		return 0;
+
+	root = debugfs_create_dir("memblock", NULL);
+
+	if (reserved_mem_count)
+		debugfs_create_file("reserve_mem_param", 0444, root, NULL,
+				    &memblock_reserve_mem_fops);
+#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
 	debugfs_create_file("memory", 0444, root,
 			    &memblock.memory, &memblock_debug_fops);
 	debugfs_create_file("reserved", 0444, root,
@@ -2771,6 +2803,7 @@ static int __init memblock_init_debugfs(void)
 			    &memblock_debug_fops);
 #endif
 
+#endif /* CONFIG_ARCH_KEEP_MEMBLOCK */
 	return 0;
 }
 __initcall(memblock_init_debugfs);
-- 
2.50.1


