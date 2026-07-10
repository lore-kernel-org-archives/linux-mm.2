Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECB0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F6F6B00C4; Fri, 10 Jul 2026 05:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F586B00C6; Fri, 10 Jul 2026 05:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F5B6B00C7; Fri, 10 Jul 2026 05:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7B486B00C4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:34:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 721671A02DB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:07 +0000 (UTC)
X-FDA: 84972355734.14.06D894B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BFF3680003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIpRCako;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXliMhF9wchTM8HndPmuEzU03cAlC7HEcmkW9Z3q90Q=;
	b=s6cbjMJPLPAoGRJLHdtF+kdFcQo15wVNRC29bytzHFY3/S32yNFyitBQKimgIciVO0EKOQ
	hYk0LeThCXpb33D6cR+hj/+sZ1ITLFGPCsyyzml4Bjju3IKQwIiXnjZ77vHBZdMfJl4wHl
	v7yrpXMpHHdwx0lxZcVfx20ageMWpaY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIpRCako;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676045;
	b=WnZE2t0y0PSan+9rq1QX9QYnNJFqjEp5H+Et9BQ/Z+jgmppt4aVcgjgRgMl7pspWsEsTa2
	78dhLdyas/V1Y4U36eVl6IGes0+QbMsCc4cM9Di+oJ7scPz8wpRYldEF+NesdwkFXgPlaZ
	pJwNMWYe+Tm4x8bQ/452DK8kORlmRkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 66EEF601D9;
	Fri, 10 Jul 2026 09:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86A31F000E9;
	Fri, 10 Jul 2026 09:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676045;
	bh=jXliMhF9wchTM8HndPmuEzU03cAlC7HEcmkW9Z3q90Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CIpRCako4iYtW5mJmd/n9uefv3LEN8Wf8XtkujJTIZDqEYSa5BNWNoOOpxcZMqM9+
	 1TtBqye4tzQTliRM08aUDBLeYbtoHVkDBzV2+tDZ60GlwTfq6U66PlxqmDPkmuLtGA
	 pHc4Y2o+5Y6yfUGs/8OhVDjMrrhIBYwjvRINNfm7S+M7VvhdpXuDczRLeYogQ5iDQu
	 sMhyFyAqbVG4FbExbXvl0UUfLem7bnyuRtHoQBnwbTT8J8CrE79KrGJmkonF6uMWAm
	 0b1KH8H0v4p/3ueDWUwd5+04FhI2R+aL7vE1kMITs7OroqFxh37L2yhO7i7DcPj6Gb
	 3j3G3UsbtzLZg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:24 +0200
Subject: [PATCH v3 23/24] binfmt_misc: include what is used
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-23-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2398; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4GuuVyRng9OHFmylgBpD5RM8zjdQhkp8WOAwJFEG7Us=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7IlnXGx/ZcVPrzfb1ERO2t7bvvthus3Xvs4W9tdX7
 7o9iJ7wvqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiPbwMPxmn9hnu2DQxXGhh
 3xOWxgmdiUmFyU83RPy3zbueN9VTdwfD/5qynQYTr23gN+q6FaT44NH9XrVd32RWPXWqrT+p9P7
 ZC14A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BFF3680003
X-Stat-Signature: s6k7fzcza5uiou6g8rdfncb1fk6e77f6
X-HE-Tag: 1783676045-538330
X-HE-Meta: U2FsdGVkX19IXtQgfv8ZuklF1uhixjEEJAvZEx0nnPvo1G8ZypkXplx444xys2i8FQvIBhc+AmPLUWIYfyjWFZiD/OlYP+gKjD4Ljlc/UXPNPsl2m5+qDrfUdVT4SG4loETuxVgOMIY3XMfG+x+xDEsNcYjHgowWIZfjmX1ZpDwRFsluUbGJOFHz1JH+/hGmn9RTcWvfFFfX33qV/WInJ7FHzKl+zTQgW77hk7T3Fi0ma18C4oeGDMd/I05OjxLJRtym0oIuT7qaYz5lOEXW2vriK2Q2qrvMNSNd02dtFnz7S+B4PxrKt2Ko4C8uJV0Xvkpr3DvU8/4eTpBd7mEKlziv1i/j4/N2earyGQ5qw+4Js+yzC8G7EeBpMfmxI2WZKXdZcUy/DUJL61a/lCdUcLxK0D6h8p+SAt5Vt16+px5HvxsfRwSIxrGZi/kzo28PVMsrEOAjYETkW1NYBMyXJBpQvc1Xc8MAaRAMk6VznrpkW6SmGyY+E9VN2JI2k2qoooQrbLW2D361L1HRcKJGruBULADfFRnXpqvgR8JTDPyKWkTNPf+UyEPixgMDWdCYrsEpgPrtDNN6zhQWs/tcaeYD9QrnIuqlmaq2zUAwA5nkIFnWgkuoEh0xqZ7ncB+sBzjZTH/QWAHTBYzGoFEQWB5Kfhl2Zf5SAL8Erg2Ts+PJ6rJx8h7oxG8aHRHveUwNLD3ZEpZyDa5spuvadDz4F4wQP9W8u6O1RYr1FtK2RVCO6ZLhyD3SBcfyukFh68RJroC7xBaOlAY5tqgjmRM5C4IZ4LGCrtyO6ObVL+sanyvIqK04l+fXhdN/y7KBD4UaMoGvr50TmW9G9vzH4sy0Hjp1isie8StkCrU/8lffJkhCQMo86s4dn5Vn86nbQ9fi/a8Sk0Cy0GlaX+OZomRKUIWwaOIl+i6R+rjEUCpSxEaFiR7zQwU44IWq2cSXeQhNa4tdjyvdHrZzZ3yeWw/
 UkICtmAg
 1yp1Stjd33foBU4iv5Vt5xaKG49tgx0paP5P3KDTWgiJdW8FCIV1WX88TbnQKdpCVDFJBq5mnIndXRaQCecknJlWiD4+rRrkMavxmK9ZjVJmggPkNS+Sfk7nMu4/PL56nnvC+C5Kq+DBWkYYYuJXLiy7M4YVd/KcaAAxqMZrAbWpALJOsFLj9zUm3PErSsN3+PVxGFCWWmH1c1LInyDEBvJxwxPuPC7iaXItYz24+tZxGL65rCbfR7TvxxG6ixuLBol5zHOskkqMU5dsd01c9FkRqqxodMymVxlm46QAoL0mN3ABfgAVs54ksj9ZYNpT9JFYRzWCqAGtRNOsCsqHQFTBEG1T1vInsctT9Yo7km4EHpz8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The include list still reflects code that left this file years ago:
nothing here uses sched/mm.h, pagemap.h, namei.h, syscalls.h or
anything from fs/internal.h anymore, mount.h and the bm_fs_type
forward declaration lost their last user when the pinned bm_mnt
machinery was removed. Drop all of that and instead spell out the
headers the file actually relies on but so far pulled in
transitively: bitops, bits, bug, cleanup, cred, kstrtox, printk,
refcount, string and user_namespace. With that nothing needs the
kernel.h grab bag anymore, so it goes too, and the list is sorted
alphabetically.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 189b9218e5a6..46c65a618b19 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -10,27 +10,29 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/sched/mm.h>
-#include <linux/magic.h>
 #include <linux/binfmts.h>
-#include <linux/slab.h>
+#include <linux/bitops.h>
+#include <linux/bits.h>
+#include <linux/bug.h>
+#include <linux/cleanup.h>
+#include <linux/cred.h>
 #include <linux/ctype.h>
-#include <linux/string_helpers.h>
 #include <linux/file.h>
-#include <linux/pagemap.h>
-#include <linux/namei.h>
-#include <linux/mount.h>
+#include <linux/fs.h>
+#include <linux/fs_context.h>
+#include <linux/init.h>
+#include <linux/kstrtox.h>
+#include <linux/magic.h>
+#include <linux/module.h>
+#include <linux/printk.h>
 #include <linux/rculist.h>
+#include <linux/refcount.h>
 #include <linux/seq_file.h>
-#include <linux/fs_context.h>
-#include <linux/syscalls.h>
-#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/uaccess.h>
-
-#include "internal.h"
+#include <linux/user_namespace.h>
 
 /* Entry status and match type bit numbers. */
 enum binfmt_misc_entry_bits {
@@ -62,8 +64,6 @@ struct binfmt_misc_entry {
 	char buf[];			/* register string, fields point in here */
 };
 
-static struct file_system_type bm_fs_type;
-
 /*
  * Max length of the register string.  Determined by:
  *  - 7 delimiters

-- 
2.53.0


