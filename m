Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24236E9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 19:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843AB6B008A; Tue, 17 Feb 2026 14:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821FF6B008C; Tue, 17 Feb 2026 14:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F596B0092; Tue, 17 Feb 2026 14:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 591736B008A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:58:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8520140336
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:58:49 +0000 (UTC)
X-FDA: 84455011578.10.CD55AE1
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 403B2100003
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:58:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=qhDBichY;
	spf=pass (imf14.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdGM+3FwIaQuf6hPkPkSLAphz0/4CuAqXxirGxGLDPc=;
	b=gmaYXxPeP6fKESNfdQ6zF+ryoLphdO42DTLhUVg5+0XF2/J8CTxdzQGy0rLQEw+Q2kp/2g
	CTORUqCdnduGzmVnNegsDKFsT3iMyM5dsSTWjx01r+N45Jp2OJafRcPBC9EZjKTA0utqUw
	/tYDgUiBlTknYfOXmNulmkYo3ASs1iA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=qhDBichY;
	spf=pass (imf14.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358328; a=rsa-sha256;
	cv=none;
	b=HzzLnWPko+wqBmeZnd6Buf/KSbpO8CZL6CDAi+1oirMHLxmeJilEjd04Q3OvHChfAiVqDO
	mIHlU2jRj9L5AlgZQRtv64dmg+6Tv+3c7tFKuQ9QOwIk0EOzy1x4Vq/fywzZbqKuqk03LU
	pLg80EC7anJEazBmtMQjNC2yfABxnng=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wdGM+3FwIaQuf6hPkPkSLAphz0/4CuAqXxirGxGLDPc=; b=qhDBichYhwo1xrMfx+LlNeZNyu
	WN8w/c3qh4fwEJKdklUDc1KbQfGhsgjhLc2KevtcSpIK0blzrNwyScHCDSE7HyRKFfY70pbhKP3C2
	SP2fvYGqrUGf0PDBmjQKgXATF0iC0tZ0e93dux7tD5mbqbKzvPgs3sLJwlhExukH/DDu+/eg5rFSc
	6JsIfLwOzQUA+OA1XPVUZug0sdo6mA/poMIi1+omJRHDySExtCM+CoSiIc44/UNldBTWo8NDFQL6e
	YClBqAMT344tFwoMdQd4UfhnljM897Ebi5wiZV/SocsSCq9PNIpksSYDFFg106A/Endm/gpwEhCPD
	TutEO5Qg==;
Received: from [177.45.213.208] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vsRDa-001nLM-80; Tue, 17 Feb 2026 20:58:46 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	gpiccoli@igalia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
Date: Tue, 17 Feb 2026 16:45:07 -0300
Message-ID: <20260217195816.861684-3-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260217195816.861684-1-gpiccoli@igalia.com>
References: <20260217195816.861684-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kfe659w1swtgi86cmqhomq1onpa1uz36
X-Rspam-User: 
X-Rspamd-Queue-Id: 403B2100003
X-Rspamd-Server: rspam01
X-HE-Tag: 1771358327-143089
X-HE-Meta: U2FsdGVkX18tv5rCj/lwQT8zOfQ52uM8e3ScKteEDQhKzVxIrmJ9NJ4OYO1gTGwddEu8nNnJTE2G9IINkeKM/tTS69AqMOhURPo63Ugtk01kTEbvXYs+nakGDNZ1EvIjvWEyLx7kZMWbC/8LIjgYXNf2Ahkie8NvYg98WenIbANOksMQscaTiz8ztW725MniMe1i7KurhWOVUrUlFTEXlPPaNcIdh6yNGUYvySuvn1Q561g0FMpa+fT43Zwb83Zjru6JHUiotVL8YRmmS5fbg+hBW3i2G9VpTBQL+s8PLQ5txkP9ic79JwW+464LSuFfH3m5OmiUIpDCYLMPQTDaUg6+yQNE7XjDSy2KJcp8V5axOkDY82LnaC6LFCpSxQuTVFJ2DgqJ5haoMI1P/+PkOL5w0REy2QymJQP1kwX1n8OI42hPP8sc/sBxQmmjdPXb3HIqP5XS8iD/HXczYVewNHPLtRrcE0cUsoT7H8xy6+jctgpH3TWJ/vS6+kwsc12r80jSG2vUlE3B4jn+RjOhZtqlXlIBq15C1UXI/fei9gARwa3Up6IIXyuTj3N0epQFJ1X3pxefhaVv3ZVeqjGzbNpNC4gKrgGKN8UGKuUry2pJ8Yfx8fJohFQnHLDtub7mW0kaCN17iDwTcHkaubrCTMGkP7C3yOtoKsNCzVh9rmcS3cPrZuI8nL4BvHuCRgUp3C55NgBDSIEWESWr3y2+5Y265TZLwtiK7Ioeg/eTfh0s9lik7CHEP3WKXbNXrxCJdeqTbmp/Q8hWUXMCNw+OoEgHEi8jdpl8IpYJ0c5AFDG3q5RHq+twoPUAVAvEw7J4514f7DAcotVxC/pUrZJm5aQtKoGadPOu+O/Szx8HhXBRJt5ePKlx8Qe0oEIvq5Wp3EZ+F4SMpLuNKrNsSzNwS93b/sztwhorRUjMAG0plNdmEuRtzVylsgnDTJWXP0AHb0dVccRyWsCp54hXcAe
 1U6g3wS2
 cKNb77eXn9Vi9zzi4pzFbGQAQVNNdUWGWPEo/dVTrF7zEZAEuAjrVDxmuTk1UwvXocamJB7ZjEzqwbhuGp1VjsyQmZvMXBmZzp9ggiDPGiP3jzeNfyI2j4bZHKOPs3m0bHa8NvFvh2wh8gxbXNuc80PaUukTkjVQn3ipWV7pWARovvGmVkLoQL1nyfhBjia46vC9g7sZb4nBhOpejALeU7mOLBVOe/10ICoRZkqDjxf8Vie2iYMITQl15p2RopPx4A3uz/K9/dp7tEhVcSqIk0pBch78Ecy5AGabBHms45nNp6Zf+Zx3GeKKiwy6QKj0xfSqMDttWnVOAI6BufvVk/K6JkkTMTVJFH8+6LEQsMl8nx0OjFk/xha90Zd8uxgVbmuCbm3RQFYZRej9WWy4best1bZI4a8jt39Vsout2kT+eW9BoIG3QWGNhfKjF020fKoc0vXAa3L911GM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
memblock debugfs, neither in /proc/iomem (like unused memory "set" using
"mem=") nor in the kernel log (like the "crashkernel" parameter does).

Add here a new file under memblock debugfs showing properly set memory
reservations, with name, address and size as passed to "reserve_mem".

Notice this addition makes the memblock folder *always available* under
debugfs, regardless of ARCH_KEEP_MEMBLOCK and even if there is no
"reserve_mem=" setting in the command-line.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 mm/memblock.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 2d2646f7a120..58439de0a59b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -18,6 +18,10 @@
 #include <linux/memblock.h>
 #include <linux/mutex.h>
 
+#ifdef CONFIG_DEBUG_FS
+#include <linux/string_helpers.h>
+#endif
+
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
 #include <linux/kexec_handover.h>
@@ -2711,7 +2715,7 @@ static int __init reserve_mem(char *p)
 }
 __setup("reserve_mem=", reserve_mem);
 
-#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_ARCH_KEEP_MEMBLOCK)
+#ifdef CONFIG_DEBUG_FS
 static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
 	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
@@ -2722,7 +2726,8 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
 };
 
-static int memblock_debug_show(struct seq_file *m, void *private)
+#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
+static void memblock_debugfs_files(struct seq_file *m)
 {
 	struct memblock_type *type = m->private;
 	struct memblock_region *reg;
@@ -2754,6 +2759,30 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 			seq_printf(m, "%s\n", "NONE");
 		}
 	}
+}
+#else
+static void memblock_debugfs_files(struct seq_file *m) {}
+#endif /* CONFIG_ARCH_KEEP_MEMBLOCK */
+
+static int memblock_debug_show(struct seq_file *m, void *private)
+{
+	if (m->private == &reserved_mem_table[0]) {
+		struct reserve_mem_table *map;
+		char txtsz[16];
+
+		for (int i = 0; i < reserved_mem_count; i++) {
+			map = &reserved_mem_table[i];
+			if (!map->size)
+				continue;
+
+			memset(txtsz, 0, 16);
+			string_get_size((u64)(map->size), 1, STRING_UNITS_2, txtsz, 16);
+			seq_printf(m, "%s\t\t%pa\t(%s)\n",
+				map->name, &map->start, txtsz);
+		}
+	} else
+		memblock_debugfs_files(m);
+
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(memblock_debug);
@@ -2762,6 +2791,9 @@ static int __init memblock_init_debugfs(void)
 {
 	struct dentry *root = debugfs_create_dir("memblock", NULL);
 
+	debugfs_create_file("reserve_mem_param", 0444, root,
+			    &reserved_mem_table[0], &memblock_debug_fops);
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


