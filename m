Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B26C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B156B00BD; Thu,  9 Jul 2026 18:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24B56B00BF; Thu,  9 Jul 2026 18:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60426B00C0; Thu,  9 Jul 2026 18:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97A056B00BD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:31:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08D701A02EC
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:31:02 +0000 (UTC)
X-FDA: 84970684764.10.1A15ECC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 50A1E4000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:31:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AwM3V6va;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPDx1vQrB1AgHb6k+MV04TDD1FmulFHOlgEYVxZySHA=;
	b=4MiEhxImYJqqN+BBVS22JoJZebalSMpwV1DGGaDZa3LUQXaWyoZ3AtoiN8LA3j3fS6ui8N
	sJHrwcZZ2qVTWB5Ni8XUyWOHhS1bPNLaEYiEZt5G3fQmlKxC8QQNO4Ul+rew4jMmFS973X
	wz3UH3TQJlz6lUSxCA7ieq7fMoggnnk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AwM3V6va;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636260;
	b=ocsgualZFsPVpVIP7naM1I7vZntANJnpWzt0tR2+1rbyDh3lzD/mCOSlLq7WF/9f1vcxd1
	k3MgzqjkYoAq5fcBm0Lj4tWqEZ5INcUmL68JlF0d/ckiQzYX18TJUWeoRxm2TT3IRf0zDP
	IAts/RH3ctO0pc1IyEQnNuYU2naXy4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E730861833;
	Thu,  9 Jul 2026 22:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B4B1F00A3A;
	Thu,  9 Jul 2026 22:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636259;
	bh=DPDx1vQrB1AgHb6k+MV04TDD1FmulFHOlgEYVxZySHA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AwM3V6vagPHO+whU7hM1PBJbul2gJsXD/5TBEUtSaX3pvxNDeU7GvYydu/FrgczCH
	 t3NDO0JRYc5Lep8ZGfIfVFA/UNgIOIkE610FnlJxc0x5rrlUwfqDvJmIvC0Q2ZUIZ3
	 B8m39v7VxzyBa841xmWM30FuDGNpsi2RjN1Pxb2w97vf18l0WpxZ8HLYFY+BsbYPo2
	 U2HHSYjMJCYboAepPZ/BIrIioCsIFtsuGyF4c7vv53CXW6za/i8eLPY1eF4BLsAbUI
	 ZanfbI24GPFGticXgVvsFGQS7RixCFQVtotrxuShMded4oBcND0roqgqcWEvOpDC6X
	 enW9U0GDkMnNw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:17 +0200
Subject: [PATCH v2 22/23] binfmt_misc: include what is used
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-22-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2398; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zjcToFTi/b8LBXp7pn3SKXOJi5PklAi6PPGbhZqIVt4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHzjf1rBbcnSoXqLxaur+7PAp1UH6hLm1r7ftuARQ
 z1PnfGijlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIk8E2b4HzNFOmqKciyP77LL
 Pcu+LVPe4a3ZnqYyN2Ha0g8Bhx1XBzD8j5srcDkm66uMuGDupd1fIq/+63gy78akpRnvVzo1NH8
 05wUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50A1E4000D
X-Stat-Signature: s4ayub35tzqoqw3eatm79zj8hqbf588g
X-HE-Tag: 1783636260-774780
X-HE-Meta: U2FsdGVkX1+S/fIh/WqjiPRXd92tIhnKJUithflJ0Dy6m21xqeXINfglBDky/lVzG8wCTYpn7CYAvX7dIhMWdTt4BV3SQhMtOA2Z7rGTZOiPicKFwFcwPaHJJZBcfQoo2PLJKSZinDgwFmNqPFY7k+AbVJWGINlFRLaxbsHrx5EiHFE4odc9vAaDz+h7eG9jnluvTaWYPFoBFG4NzQ8MRmbUI4Oj4LTiXnd7A84ImFQJFEyPRgW+H5F6uVikmaUwykyIVQJ0eAVdJDu+KvBpJ2JRjaCD8HnHJX3SRpzE1Z5w9NZ4q3yc7YCVkiG6b8/Bu6YXJsKUYTIuH8ojAWWJHWCukGD72dRdUzWKA0k1RF4rgO0tfnx4xqWpTX068MFE19pPtwyYPdFEcAskg0IYYLY7Q5kYFZq21YYWIiD8NMOdq/njNf3g2NVl1rhz7/DJuNYBGODTqcrGnYNUBtFgnk4byAf+rjaDwAW7s9fn7YdincMDkFhp0RUIQDhWoGRSoabW82Rwx+wbdU293vKEJgWPUtwW962qa/zbHpVOJ+GOpjtP7GcUmZpkCLMmaDwzIHRdPpmBAJUMokBEDK7DOqRfI3IW3u/t6FLktc78DQtROdr0R64YDSqe5dZvqAS1l/Cmk1XQYv85IRyHpo73HBb2HGIP+0NomZSFVbve966Mkpafw2+TiNskQdONLEcHpm69BE5P/7pbjhcy/xn60XQ9E6UltSkJ2IBfF6BrWIKe/P7qDdLonRwzzqHrRRQCPg9xr2cA9Q2Xsfj53YkcitgNpq5tEdEU53is/zy5AUl9pOahalJUV3L1uH0DCxoq66DHccTA6FNHkNDjfpFVFxdUXx8iqsYgf72dYMwO0pnqLXMKU3CvVkZlMjpC8oXHwWHVn+KcmrmqkAm8zf1S1lywMrfHcAuQShMH9OzJyhVYJR/++N0mo80JAR24gqm7tlwXDjovbEFFbdP2PQd
 um0VIS4W
 LcK1gvfKcgku8QmpramHwSsdFwZhvZ4p/Ft3u3RAoSiX8AC0Iyj5jxRC/jJwk6P05UsWc13xQ4i+EiyDdEP/P+86s0Mov8ZY1SUx/eN/P9vDWWoaDt8v+4z2yDAIOg0XTkcQLWi2md3dk1D/Te8Wa+BN5tHgF2YVCZql6tDhXGMkPNt4+AFQdzeJCDdsEOPa4f3Y5ufflzEOIsjoS/UFxFqQXMuSC02w0LLeb6xz35vFkLaV/7e6O1wxBxNW4QKuNewQ5wnEeoIyvEfei+ZpxvaVdIO7fRczBfSGoxgYgJONdB6g7SiZou/Nq3HJ1PjL4WRs11JTXXVBqXB64sedmoqc7eDOpnxkZdcmx8qSIewQmGSw=
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
index 4c641cacdcc9..050e83c8533f 100644
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


