Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA7CCD6E61
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE9A8E0010; Thu, 13 Nov 2025 08:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5648E0002; Thu, 13 Nov 2025 08:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB4C8E0010; Thu, 13 Nov 2025 08:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 798F68E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:56:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EB65140A09
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:56:43 +0000 (UTC)
X-FDA: 84105734286.10.162374E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id E5E7F2000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:56:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NfqGLIP0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6MLVrb1F;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NfqGLIP0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6MLVrb1F;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042201; a=rsa-sha256;
	cv=none;
	b=FFIuNizI+s6E22558xGLQtWuJ/jn2OPLOwtvCk+xZUiclp8VBVFs3hzR6bfPIjHooVmxCG
	ofwzGgZ2pazu8XSyxePCIxMEagnzBwG8wmZ6hg2E4GjQESAhq4iQbHSNx2M7CFUlJUpK9o
	BSjcKjntpYBErfE/5FDL+XsD/GF6yVI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NfqGLIP0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6MLVrb1F;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NfqGLIP0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6MLVrb1F;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=jdelvare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zJihWS4w54QfjbnU9sQxaWaLhLGEz1OXZ/jtjdU3dUg=;
	b=3qEShN+dlU28JhQOeQ+YiAVlC0qvSDeiNaG58L691o0u72khQK4i8jLKQwQF03wdplPvgM
	2wIUtvhWG0MAqzZwkgzQkfLsZvcEjs4D7tRdeyPL5kbOkH7M1QttqKApCpX71j8bO1eZ6C
	xg7cQpyuCGBcQ0zCsMhSCUw7RbGxdjo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D5751F451;
	Thu, 13 Nov 2025 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763042199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zJihWS4w54QfjbnU9sQxaWaLhLGEz1OXZ/jtjdU3dUg=;
	b=NfqGLIP0enj6SYDsbvBYZvNeW3tJSLGRRkky0zrRi8eOsLHiojY27nOPH9RqesLoZDWLaK
	oxNyfjKw+KID3KGSxg9V74ymNqehcaWh/aTTYgW0xfmh73ApGqaZnskoKiOhz98GKjnx8X
	h8ZFJH2pdB1ezRFk9DIvhUhfHEGWWXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763042199;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zJihWS4w54QfjbnU9sQxaWaLhLGEz1OXZ/jtjdU3dUg=;
	b=6MLVrb1FvqGt7UCqGMbo8+LO9YjSUVaqlHxFVSBRgT/B5H6Id9nDuh9jveOIR3zTbQfHSw
	eJytEpoEf+crL+Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763042199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zJihWS4w54QfjbnU9sQxaWaLhLGEz1OXZ/jtjdU3dUg=;
	b=NfqGLIP0enj6SYDsbvBYZvNeW3tJSLGRRkky0zrRi8eOsLHiojY27nOPH9RqesLoZDWLaK
	oxNyfjKw+KID3KGSxg9V74ymNqehcaWh/aTTYgW0xfmh73ApGqaZnskoKiOhz98GKjnx8X
	h8ZFJH2pdB1ezRFk9DIvhUhfHEGWWXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763042199;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zJihWS4w54QfjbnU9sQxaWaLhLGEz1OXZ/jtjdU3dUg=;
	b=6MLVrb1FvqGt7UCqGMbo8+LO9YjSUVaqlHxFVSBRgT/B5H6Id9nDuh9jveOIR3zTbQfHSw
	eJytEpoEf+crL+Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 201F73EA61;
	Thu, 13 Nov 2025 13:56:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7xjSBZfjFWloAwAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Thu, 13 Nov 2025 13:56:39 +0000
Date: Thu, 13 Nov 2025 14:56:36 +0100
From: Jean Delvare <jdelvare@suse.de>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, David Hildenbrand
 <david@redhat.com>
Subject: [PATCH] mm/cma: Remove CONFIG_CMA_SYSFS option
Message-ID: <20251113145636.731a24e4@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5E7F2000B
X-Stat-Signature: crf4ie7zz4npg93e6y5d6ak5yyqfrizr
X-HE-Tag: 1763042200-983169
X-HE-Meta: U2FsdGVkX19LHnv4EZncVPL1gicq3Lc4tqHI7qKV3kFBUiWJ8Ul7FobDf5Z38K7vXR0YsUZbrjmYIQk4UyHff/PCi8Q6p15sVWyTqxQXQfqpsw0bT3/FuHG0lxHlEHdF++gIg13s0U6iSFzVxSqhxyX1lrYYpt+va25uD8lJT9cxzVFf7G6xhMEsVeqbzy18D8/5HqI7EiRjzaUzFKpAhoJ+AKu77jMiOl6pi8u9yYWjodb9vkK8jzqHCiGoojmQlBtrhMQu0x3Kuks191XAcWzh8sM3VPfKLj6MB+JdzerDpP6jcoUolsttUDHa+af8hTHfPCq0iEOkmNSg/V0wrjxwlINr/3YVjppMjcMCaTp4LgNCgAJnTlsD5evah/VE6GbLbne++95DEO3VYaJfj12WlgnNuznO5xr5vo3QelqD4yf+3cWc4G+a5jxqapAOp3esP7RGWsZVuUsjyh6Y2wqbE3ND7j2pIzAQqk/u23bCfo3fTM+gY03WU62llSGRKZuFBx8+tbUdkGX+3VTDNFtctx5zoaydTpzT2IhGc+75VC/exswm3D8GOBSQDjYemuw9AvcusYwnq+SNlCW64lGbfVol/A0qn+MHQDonWVoAchnC+/UgSj0CGTGgHCQVwDgsX6C9kp1dqLG+BUDKmlcdvWgqyLROKsh4RRHhC1SWuVpGjG7ArhcLV9lg2jRfTBl9JMexk4ltcdDHiFSdd7+lqgwAk72N+CsFddfz3Rj0n+QXFWnXgT7XngLYxR0FyeZ7AwK32cm3bnE9FxFtk7D4m3qexJsPnxPYRgkGf5q3kUuT71TmdPVbp7GiuIxFAck9sEWQ+hi6DYujlfgwHxm308C80gN4BHNKg1gs+tFTTrGe6XxbFjJVUpjdI8bPcOI41vWT64yUNxroOX5g1YR8WhP2LoEwu5PjB4JLvJopjDgwOX1Ph4gN3qJ4ThEVJGMEvkjMVeEiBmGZ0Mm
 SNIIsTVJ
 40q6jxwGcy0UdSf3OE48MUHTWousgwOSPdDBLtKMqzXD8dfq2yJMK2xMlOtfui512Frq3dVhsJpyD61LAMRn0TnNRTfY8qSs7knQ8f/Ma6Oa3G741eM+jku/jojocyZMkjIOm2hMMqHe/vUio3EKHWNwVEvYqRSYtXnKbH/lddMKxc9SwR0wWSAsQZOQZZWSf8HxVHxFK+MLebWOZ8Xi9oxzCt/wfQ8O/ugcNeqB8WGd9KOPj6d/2KERArewcsrK5UWvYEime4QjgBZEwmgp17E/ThrHtPcVr9qX1B1Uos7MF9PbQ2XLQ3NKOWsYMu4IUFsXWB5z5eLlPY9G5jibm9zqYRNgiriCEtwwxriK466UqJu3lnsJqM83cBpkJVmh8TjoUq66mC1PaCT4JKFKmJUGR+G6roLC5pG/T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs interface to CMA has a marginal runtime cost and a small
footprint, there's no reason not to include it in all kernels where
the dependencies are satisfied.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
As discussed with David:
  https://lkml.org/lkml/2025/8/6/371

 arch/loongarch/configs/loongson3_defconfig |    1 -
 arch/s390/configs/debug_defconfig          |    1 -
 arch/s390/configs/defconfig                |    1 -
 mm/Kconfig                                 |    7 -------
 mm/Makefile                                |    4 +++-
 mm/cma.h                                   |    4 ++--
 6 files changed, 5 insertions(+), 13 deletions(-)

--- linux-6.17.orig/arch/loongarch/configs/loongson3_defconfig
+++ linux-6.17/arch/loongarch/configs/loongson3_defconfig
@@ -120,7 +120,6 @@ CONFIG_MEMORY_HOTREMOVE=y
 CONFIG_KSM=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_CMA=y
-CONFIG_CMA_SYSFS=y
 CONFIG_USERFAULTFD=y
 CONFIG_NET=y
 CONFIG_PACKET=y
--- linux-6.17.orig/arch/s390/configs/debug_defconfig
+++ linux-6.17/arch/s390/configs/debug_defconfig
@@ -103,7 +103,6 @@ CONFIG_MEMORY_HOTREMOVE=y
 CONFIG_KSM=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
 CONFIG_CMA_DEBUGFS=y
-CONFIG_CMA_SYSFS=y
 CONFIG_CMA_AREAS=7
 CONFIG_MEM_SOFT_DIRTY=y
 CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
--- linux-6.17.orig/arch/s390/configs/defconfig
+++ linux-6.17/arch/s390/configs/defconfig
@@ -95,7 +95,6 @@ CONFIG_MEMORY_HOTPLUG=y
 CONFIG_MEMORY_HOTREMOVE=y
 CONFIG_KSM=y
 CONFIG_TRANSPARENT_HUGEPAGE=y
-CONFIG_CMA_SYSFS=y
 CONFIG_CMA_AREAS=7
 CONFIG_MEM_SOFT_DIRTY=y
 CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
--- linux-6.17.orig/mm/Makefile
+++ linux-6.17/mm/Makefile
@@ -119,6 +119,9 @@ obj-$(CONFIG_ZPOOL)	+= zpool.o
 obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
+ifdef CONFIG_SYSFS
+obj-$(CONFIG_CMA)	+= cma_sysfs.o
+endif
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
 obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
@@ -127,7 +130,6 @@ obj-$(CONFIG_PAGE_EXTENSION) += page_ext
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_SECRETMEM) += secretmem.o
-obj-$(CONFIG_CMA_SYSFS) += cma_sysfs.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
 obj-$(CONFIG_IDLE_PAGE_TRACKING) += page_idle.o
 obj-$(CONFIG_DEBUG_PAGEALLOC) += debug_page_alloc.o
--- linux-6.17.orig/mm/cma.h
+++ linux-6.17/mm/cma.h
@@ -49,7 +49,7 @@ struct cma {
 	char name[CMA_MAX_NAME];
 	int nranges;
 	struct cma_memrange ranges[CMA_MAX_RANGES];
-#ifdef CONFIG_CMA_SYSFS
+#ifdef CONFIG_SYSFS
 	/* the number of CMA page successful allocations */
 	atomic64_t nr_pages_succeeded;
 	/* the number of CMA page allocation failures */
@@ -80,7 +80,7 @@ static inline unsigned long cma_bitmap_m
 	return cmr->count >> cma->order_per_bit;
 }
 
-#ifdef CONFIG_CMA_SYSFS
+#ifdef CONFIG_SYSFS
 void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
 void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
 void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);
--- linux-6.17.orig/mm/Kconfig
+++ linux-6.17/mm/Kconfig
@@ -981,13 +981,6 @@ config CMA_DEBUGFS
 	help
 	  Turns on the DebugFS interface for CMA.
 
-config CMA_SYSFS
-	bool "CMA information through sysfs interface"
-	depends on CMA && SYSFS
-	help
-	  This option exposes some sysfs attributes to get information
-	  from CMA.
-
 config CMA_AREAS
 	int "Maximum count of the CMA areas"
 	depends on CMA


-- 
Jean Delvare
SUSE L3 Support

