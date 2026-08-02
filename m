Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403F3C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DD76B008A; Sun,  2 Aug 2026 14:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A075C6B0092; Sun,  2 Aug 2026 14:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CF066B0093; Sun,  2 Aug 2026 14:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 686A96B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:01:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDBE040531
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:01:02 +0000 (UTC)
X-FDA: 85057095564.13.F360D61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 230FA8000F
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:01:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCxNHeld;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785693661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7xpeM8pp0DEe6UpBgAa7dvpst5pAAcHLBVezKeavwU=;
	b=mBY8a+G+62H06qqpH+7SVY09BtbjFAQaR53RD12lrNgmE4PvySWDzuwmauWim8ebFg4XfW
	6JFwT2Er9VdzNyTKeuvstAD1qLifOOf0DTKIH4KEC7cBT3ROovgJpZLBh+4Ig9K1vFOhye
	LL6XXG1+Bu4QLCfqz6gtAFLaHFw0Eb4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCxNHeld;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785693661;
	b=VNujGtrBJjuARta/H+vcRXMm5laa8ETF0WcCz7qNpIiYF9dJXR61lF7JAX318X/1/id4o8
	72+ArO+cNAvbQ6Gjr9nCACgNzA69xQW5OndJAWc9nT6iym+D4gP3wV7Ph3E2fX5j7C5e3Z
	8sqLWAbjerriDEpUsQTy9P8XgNAej64=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65ABB411AD;
	Sun,  2 Aug 2026 18:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4D31F000E9;
	Sun,  2 Aug 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785693660;
	bh=j7xpeM8pp0DEe6UpBgAa7dvpst5pAAcHLBVezKeavwU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KCxNHeldigD1lW+k0J4+fYSDsP5PV9V+qNTxpXefIV3PlRJnqSTHvjth8Rhn7dPnF
	 zmrbcxKtFERtySp6iLCRHQAR5bxVnvWhC9jRFPALjlmDjf7N0oQjIeraRU2CEz8EJx
	 F9bAm3xTC9CI9S5E7m1Z/HfyXjWtqT/PnRqHYi9H3VjlJrDrkFpIcyG7Q+w9qIoMj/
	 iOU2iH/Yms8vbyolzzaY1ojq9JNXOIPy3wGq9edZhG3RwBfTro7xm992awkccbNYcH
	 2vGJ+BmXq23AloX9ykUNU07HnWTmEgaLfv3xCS9gOKSAF6G4M8hJ930zIX1MA3IkhW
	 UJ4ExxKPwzCQw==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 02 Aug 2026 20:00:44 +0200
Subject: [PATCH 2/3] binfmt_misc: don't warn when the mount is completed
 from another user namespace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-work-fill_super-warn-v1-2-4e987911a39a@kernel.org>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
In-Reply-To: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, Laurent Vivier <laurent@vivier.eu>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=2548; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oUEgEb1v4z/alxWWTvQ5NBBZo0HFrYjN+ySUTY9PsOc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTlt17Wf2lV0JMRe85k8qrdh4LEvaZFlOkFLxHbKqfHs
 EIyJ+J+RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETu/Wb4HyVi0Xuq+udHza8c
 t7aH8Hz1OvbCd+MOsUw5N/tTl51t5jL8Dwle+i4xZPvpaxqVHk/+t/3ao/Kzt1TK+t33C9a3y23
 aOQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 230FA8000F
X-Stat-Signature: 7d6j87z14iajcx8pux686ea34csoeuxm
X-HE-Tag: 1785693661-152447
X-HE-Meta: U2FsdGVkX1+xS+BSpWGsVgAGvDCEJbEnBDv431DSnV5Or9FJ9lSthpanSlivfRU34/0B9L+2I6PxBjdOJnMPIBV5JvTQ6pJDk+30U7GTQPmFsshEwnHWKnPQ7fK+CcfiSbMzCqPOnMddLgdVap0cJ1+4GVJ5W+NnRCzRznWUZEYPXRllnnswt6aXwsWhx9xnGs1LEj2wwBofPb5+4dn+/G811B+M2m566HpiZmhah0TmUw6/rZXOe6RrRoSiiZffMmVyR6tdr1dGMzDqoHfCSig6+JFXhaF322uFbFqZAQS8uNRrk9AFUkgZEmFywBWdwyuAmGXJCiuD6/F+pzZjtJ93Zl+Pcrw04/33g23PfHjTgDnHeF8fjAj0UlCjd96a4AHDPXGO4i+TzQKjCylyIZbiVub3JONZIshWgzAGNtXdSGc9WW7jFpjTGHrHG1QMDxEWnWPrRp5HXvxHLT5ce3T9HzdybmohDIVvtxf4PBOeJms5v/a1JDSk0KaZki6P8O/hOpeGOFGtQgeK6gDBdp/fH4cr6Ownd8AV3MENxk5QHNaKUKIDFmq6aM4VLQJjhmu5En6snLj397oR6ps1NwxoQwadombYA26v78SHiwwARuYpvgYeooiS3vY//D4hPsQiE11YOqn/QappphVfZNg9eNxvGrbUmTtPAKP7NRjLoa8cMaMBy8YIKFfDCwcf3NHtN62Yrn14PoMw2x0AB8UKnV4WWOIegJAWMHFCMWakwfl+4TER/GSC4rSbzFKlBknSGQN/qT6JZYFIH5qx2ydHYNnABe2fNNMpFbrADg6eTrWQLLiH+n1tSiyGYFOBqBzl9oU1dPT+lQhoJFDBPEQWhy/wIW3p1N5PCL7ny3ymGBwBziu2Wounm+49rAzdnsAmXM6fhxeZeRipyWMfaw6setPHaVozI19gUwTuzv/EFT5FjNL867vKraqCQwP1ondi36mKO2VrRElCTgG
 ogcOBRJl
 VjW3AQ/gsuMEzSgLZG9lyenWXsMM+iJ5fRSpQBSlXsmeUwypSTWQqLWt/i4h8wDLdFcict2rmAfbAL3oqJL2xAtui0XAD25Kg5/MWgauK9vz6HsDGwbBRTTdiYNVhtkFkv69Dqy3mCnvf/07TdEyN86bL8pysonpBmRrzDFrQ3oiHAuSgcQl4a7vGZps4RdduYp/7+qiOqXlfrS7FpQLjtsRApLxmyneKlDAlTfhSOV4HJiOLWOOLrIDkBDqxEuAw9LGtpCyoZQMO5hDMtiTpT49OD7iuO9nv56rnO66Ahacx+8LeCyyvh8fI8t6bFQA6dAnO
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
So an unprivileged task can reach the WARN_ON() in bm_fill_super():
create a user and a mount namespace in a child, call
fsopen("binfmt_misc") there, send the fscontext fd to the parent and let
the parent issue FSCONFIG_CMD_CREATE. Both namespaces come from a plain
unshare(1) and no capability is needed anywhere:

  WARNING: fs/binfmt_misc.c:938 at bm_fill_super+0xa2/0xc0 [binfmt_misc]
  CPU: 15 UID: 1000 PID: 3243382 Comm: fswarn
  Call Trace:
   get_tree_keyed+0x7d/0xb0
   bm_get_tree+0x34/0x90 [binfmt_misc]
   vfs_get_tree+0x2a/0x100
   vfs_cmd_create+0x60/0xf0
   __do_sys_fsconfig+0x4b2/0x500

The child needs the mount namespace because fsopen() itself gates on
may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
the caller's mount namespace. fsconfig() doesn't repeat that check.

It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
raised in a loop to taint the kernel and flood the log, and it panics a
kernel booted with panic_on_warn.

Keep refusing the mount and stop warning about it. Nothing in
bm_fill_super() depends on the two namespaces matching, it derives
everything from sb->s_user_ns.

Fixes: 21ca59b365c0 ("binfmt_misc: enable sandboxed mounts")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c97f10b48b5b..613dd28e3f1a 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -937,7 +937,8 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 		/* last one */ {""}
 	};
 
-	if (WARN_ON(user_ns != current_user_ns()))
+	/* The fscontext fd may have been passed to another user namespace. */
+	if (user_ns != current_user_ns())
 		return -EINVAL;
 
 	/* Never exec off this instance and never let anything stack on it. */

-- 
2.53.0


