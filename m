Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9A9C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6112B6B0088; Sun,  2 Aug 2026 14:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8AE6B008A; Sun,  2 Aug 2026 14:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7996B0092; Sun,  2 Aug 2026 14:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21CF96B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:01:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FA24A0522
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:01:00 +0000 (UTC)
X-FDA: 85057095480.25.FDE0EB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3674920010
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:00:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KEmN+I/S";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785693658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdUbIeEA0NY1lpHQDcBWvRIKEibZrc5Dbd8chU0BwRo=;
	b=BlQLRGuuj3msK9Fd/PD6tmA2gfBovbfxXRSD+JDBSjjvz3BXI8aCe7U4zG+z9GoRaaWmrs
	GEClq+3V/Dom/B3Fd8QpTTOX49jHj26LdWF01O2Jbk+7cFxH2sao9EJypem+j5/VpxC8P1
	Pr9/bwaeaHFRTze2xo6HEayB7aa51Ok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785693658;
	b=sFQdFUQl+PKrw8GqKb2Db2E3ODO2AQpXhRQ4JRGEmeQISBOVL0DdW3yN47OVFR6ByvnO3o
	5wtEEavsa42cdsK39PdA3JVlXtE076hry6su2ehWsdYzSerICVyCyc4ZQOc4iZgsKcq1k4
	YzKWVu9Ku+Efcm5kEFz0IT8+ejYELh8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KEmN+I/S";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5ED3743C37;
	Sun,  2 Aug 2026 18:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9499C1F00A3A;
	Sun,  2 Aug 2026 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785693657;
	bh=xdUbIeEA0NY1lpHQDcBWvRIKEibZrc5Dbd8chU0BwRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KEmN+I/SzbZDPFVG5b+3QkXRjLgREbM+/2vvRmaf+cf1uLFmH0QmTJ7eRMDyfQkZx
	 KYyl8n27eLCcuWRj0cVMkOyr/sMOsqnB6/r9/pOOLwshk+u+z91lRzg6FFy5n3eaL/
	 oEcNCZ5Ku3fY18PxIxdyxi6cVKRxws4t9qH6culmVY/z22HG1+U2SK0ofG7WRSVzE0
	 5M5Z4JLXwVzHBy83kPIC+eE8rkB7h4XkuvV1oVyfXJd5RINtFbX8moKeQ6LCHSKby1
	 6on/Zvmrn/E9J6jkqn/SeP6elDZneHITEpCxmNlYK9zTDZ8J8sUHutnIvGCR8GVv1G
	 dvsStJhE1MSqA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 02 Aug 2026 20:00:43 +0200
Subject: [PATCH 1/3] ovl: don't warn when the mount is completed from
 another user namespace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
In-Reply-To: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Laurent Vivier <laurent@vivier.eu>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=2481; i=brauner@kernel.org;
 h=from:subject:message-id; bh=M6JZlR8i5Q+W2IPwr6zZOJ0eNJQ8egqcpk2wTkdtdRQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTlt15ulrh9w/j6jAsRNdGduTJdQcsuXHv196O76IeHV
 179ydL40VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRf7EM/wxMtkR+f+SQKNO5
 KuHPZa9lVa4B+5be38Lz4+z6hV+Pz6xlZJigarTw8hkG/i3eByZJhAdUSBvtPPG5JOWL0rLJPTp
 /+fkB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: wh1rsmzfn9funamd147sq84t5umpth5f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3674920010
X-HE-Tag: 1785693658-589829
X-HE-Meta: U2FsdGVkX1/OjWGtG7VgVfSYhhvQEXB7G5k5wirXkpNwEnPG9eoOh81aFmy3V9qw5IbGQ3KCFaoVcUFxbvIfHIIi+V68aOx/aeRYkIPTiJPpoJHfJuPbDRikIopkPL6t+zuhpZJjvfDP7h6fiesWO1RwbTZFKp0Xk7AxzKjffriCKojMhcEy2JeSJu8stKNFKCWJhqPm6pYiAtySqJ3n6nXIy8lCdwCF8D1dQlQ+GZSvaFpTJHC12EwcsURMptGpbwugUpejT0/OjUPyh1ufVBKPbZZukJxIJhkVbVyvJdsX6XHstxbE+99eyrdTDKm6Fca3oDjQS9IC7Eh6n8MiwJ0Qpcq0VtWKENqW2SDPCfFz3rV3vIW/enkm8ZLGFY9fqSSZH+9EkcAhv50ugEq3/7MxvyQhGbzTGlOOyHvU/F8rdcnCE5q8PtAcxNNjWSq6g1qht5RUShedxfTVowj0eEfX1DW3XgJP2WSRI0wplc7vgi++OoUaxcYT0Px4couplwg52cmEvR2cqwJluJ3dRwt6DTZw3MkXI7lvf9XL9TAOsHIkoy6Bj21EKAUSA55MJM6KS5k9ClzVBTulXXikVZeYiUyZrhhtAG/GjXy0UtnipgwHR+ZRL33BjXpQi0vWu7SU1yMD+HHUc74u8EdiTnLUItjQENpyj/sT+0B8iinlEykUsArtodll3UJHIk+fUyN/KfqoKe+BTNwg+sXaQ5GsfFnoD1bcSLUFOlybGkE97eshmgvh/LJM9wvIBu9nY56QlbnzSpKCHTmmCHoPMevoosSrDbX/LtH6PoloOwr8xKXPLTILznV7YlBiuadUN6z+eY/us1rNHa/dsqQbgcIZ/n4Y85kx04amxv05UoHmIXWKjSD5KyWN9r9Rww75afwKMSJc4iCbUS3wZsu60gLLlrtvAfWI5HciDOoJ5mf8KE0BE59zAbh3B+/fEJl8GjVbXv1aDJO5BLDQeRX
 nXa8K2k/
 qjyvuz7xLpfJD2N+AnEhGCta3azIWihIFZiynWqANZ5bmwoAB5Jz6YqRP2XyTlAik/KFhWVfPwedmGA58GwCCorsWZDJtpSeiji+VauCWrqbjValjmkO3387Xh1uwEmYHNuDKdkbEZXPrH46QlpOOxuluCvsTdb1asQwl0OE8rp6XhRsH2RaKCteXwRHGQSGS/2VTDkd9V+MgYZIwnqWcA+l9N/R0rJAhHZyqZd9MfBLVryLbUNHY6/53esLQUZ4zBAVSIrMZf1P7DWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fsopen() records the caller's user namespace in fc->user_ns and hands
back an ordinary file descriptor. Nothing ties the task that calls
fsconfig(FSCONFIG_CMD_CREATE) to the task that created the context. The
fd is inherited across fork() and exec() and it can be passed over a
unix socket.

Completing a context from another user namespace is allowed on purpose.
vfs_cmd_create() authorizes the create with mount_capable(), which for
FS_USERNS_MOUNT checks ns_capable(fc->user_ns, CAP_SYS_ADMIN), and that
succeeds for a task holding CAP_SYS_ADMIN in an ancestor of fc->user_ns.
So an unprivileged task can reach the WARN_ON() in ovl_fill_super():
create a user and a mount namespace in a child, call fsopen("overlay")
there, send the fscontext fd to the parent and let the parent issue
FSCONFIG_CMD_CREATE. Both namespaces come from a plain unshare(1) and no
capability is needed anywhere:

  WARNING: fs/overlayfs/super.c:1551 at ovl_fill_super+0x7b9/0x1e20 [overlay]
  CPU: 3 UID: 1000 PID: 3243376 Comm: fswarn
  Call Trace:
   get_tree_nodev+0x71/0xa0
   ovl_get_tree+0x15/0x20 [overlay]
   vfs_get_tree+0x2a/0x100
   vfs_cmd_create+0x60/0xf0
   __do_sys_fsconfig+0x4b2/0x500

The child needs the mount namespace because fsopen() itself gates on
may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
the caller's mount namespace. fsconfig() doesn't repeat that check.

It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
raised in a loop to taint the kernel and flood the log, and it panics a
kernel booted with panic_on_warn.

Keep refusing the mount and stop warning about it. ovl_parse_param()
already spells a user namespace check this way for Opt_override_creds.

Fixes: 1784fbc2ed9c ("ovl: port to new mount api")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 60f0b7ceef0a..60b808b85fc4 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1544,7 +1544,8 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	int err;
 
 	err = -EIO;
-	if (WARN_ON(fc->user_ns != current_user_ns()))
+	/* The fscontext fd may have been passed to another user namespace. */
+	if (fc->user_ns != current_user_ns())
 		goto out_err;
 
 	ovl_set_d_op(sb);

-- 
2.53.0


