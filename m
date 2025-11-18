Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C072DCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672428E0026; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B44E8E0033; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0E28E0002; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 393208E002D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D597D1403A6
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.17.58D043A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0B3F44000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=FkUHaqpP;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=8TLvq5x7m9rGB1bwVSq2I8PgyyqDB93huY9uXhwRaGNcv4uB2v0SdSwmYXznAWnH3TEpOa
	AQigiDK86JYMZZqlZLUrnF3y8EbNRL/jmCmO8Tvi1JnoSe8LJCLNmSaSUK1m9xPs+baSvj
	5oKIpez208CwNRVxNV6eFQxfI+rXCNM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=FkUHaqpP;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DcJDdyyw+9mZFsLI1pNHpwtOdVFfzDBEUjJvLA9jflQ=;
	b=PiPxZMW7WrFir3r1KlGy4lITzWtuVavH4jdBeA8AsBbC1aH6i7OtMcMsK1hm7JQxkhPpMa
	jFNj3k21t1LoZy79phBKh8psY0fQrQJDGf/XgpxP815N+xsQBHhE53kwYW0mPvG1O3bRA/
	Tpin+5S8OtULGl9r4fWdFOz++qmQBSE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DcJDdyyw+9mZFsLI1pNHpwtOdVFfzDBEUjJvLA9jflQ=; b=FkUHaqpPlLEPJ5vDVwvDjKssLJ
	NGc/9kDZwbBHoUXj1aImGAOqPNAm/OEBRH9e2JsaS7bS3xn8au2YrZF+iUY/GqO6Cv7+vb5wPdsph
	riz89b9xKivq4rwEeUSAQhbZruTyAHLQZUpMJagJsD6e2mauhgaaUEQ7xD6cAE7f2IjC4Yazl/wUt
	WvgbzN9Qswmq05hv6LK25ATXj8rqnUUtvccBmF2nrkZFOB1gPIr8IqhbtsRMZwxq0zjp/GC9wHzY1
	YsBiIwpErIUhXzRHICcofmNrkpcYpe2XpkXAgOW/PVw8+N3P4bN8wiSnBP8pNeXSRhgApLPAikiCN
	qnhCwY9w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GERN-42q2;
	Tue, 18 Nov 2025 05:16:06 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 17/54] convert fuse_ctl
Date: Tue, 18 Nov 2025 05:15:26 +0000
Message-ID: <20251118051604.3868588-18-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B3F44000E
X-Stat-Signature: t5zgwhacashzcqw7pc49m76i5s77eopi
X-HE-Tag: 1763442973-210710
X-HE-Meta: U2FsdGVkX19qKz8QkuHL+5mcSIzkEBjtvEadYySQLVtn7YuP1nfjQGjNF+Po6qo+Dnsz1MgZlc3yzqOFYSR6nj5TAQ9rrY7qY184NDPuGWMrb+IeP2F09TM0s8VA9QzOxx/hpGVe74bYfzcO/YZ3D5k7mPwTnnp7VqOvGN3Rj2WXeJ75E8YhN3G3LOrrKHZiqbRXSzHuH3Imy+7AYhk/3dD0sOVRZaI4rNgmtWu7Dmg9eoDcFTNdhK9hl6umQE4vwgTg9lXP75sr3UYP/g+v7D4yJusXsJS+qZWYTCj4TYnnJqYuNdvJnuxeKy+0fA01/Ft0PQxSZZrtLhtFHmaM6OYzf47TQaSQp32A0/LlqBBHIvXJAZTR5mLal9YZVFQfgOB0J/tYSxczg95V8hrJ36YKhzg6kpoLxLP7Slc4wZfLqKRB4fjI0IPW5dvOfqMChRElhG7p5vZ5Ll71SHNA2MeMzfca2NdgiReBdxFPyeCjVV93Zm9CvycbLf8rw1CzE5ONYdbzGo6NQyw2IyotVJhj4hdH7q0v/setsBNA0VQJLy1LUrceN8RI13MUc8gS++1eGwPyTUb5jddAqyvsOIuYtstjDrUFapsxZUzoY0nfdJRBfAIyV0sqvMyluy0/4TFa+ATHN5dcoMeugHTXma/Wjxc7WZYmoRv3MhQIV8stvgF2jf4vE2U0F848tlLHo3iBcJG7s6oD21tbJm6GbLApUQnKmyblmg73BpZ8Z1ddqpOB8j9hcHtzP4Tog0I1l2qIX/JW0zNZlPYU54uPM7XoMpWJjq3nBVwKNOndab1faFersgn2W9Kjm1jCg4a9OtlSiFZjV2CSMi8QgXUaq6ZctUNfWqIOpcqEoWJDuqtOan29dw5F+o7vVWoXmAIeAgv/C1nWOFwquaz9bvTyJhhbOp/6Z3NQ+doAq6TXhNIanIZmjbasSwC9rXWdzmycMROHV1D6rCyn+gFoTP5
 mmqSdisj
 mwNsmyqzUxnXNlYtU3FtlHkypM0NTLILgLO5UMNieYdDsay3du6jZoh1k/+UAqWEvbW0s7M8UOR+A9uWNSucBoX2UttIHLrH5gQWnawrLAvsOMTV1lAiO35vgThizqaj2OCcfccW/mfQM29taWodwUANfQGf79g7rl2ksuN8g2RTzjy/lXuFz20Uyj2+oETu8pdZGKPMVfg1VWj/wICf6KDLae05aJpeLVfBShk5Cc89qfcVjpn6xrz6Dl1mbsWZL4BN0bNpFUNnCm2F+KXsN8GZK6PoqSqpNVdrN8bWV21ZTFs5OjRvDUAtx/5ztBjg98biRf49unifD2H4lQk/4hFmdE28h5fyzGrGgq8wBd/vNtCq/nuZ2TimkpjFsRwOAru3fgNFD/w9koCx/EH73MLLh0vd1knIPsjETLjp2oof/+58nuVpjew4QXuqN01OtMIQjf56LuwBKEgRq3Ecjs5X6AOVnSmHB7ujZSwFPHPWHKRA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

objects are created in fuse_ctl_add_dentry() by d_alloc_name()+d_add(),
removed by simple_remove_by_name().

What we return is a borrowed reference - it is valid until the call of
fuse_ctl_remove_conn() and we depend upon the exclusion (on fuse_mutex)
for safety.  Return value is used only within the caller
(fuse_ctl_add_conn()).

Replace d_add() with d_make_persistent() + dput().  dput() is paired
with d_alloc_name() and return value is the result of d_make_persistent().

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/control.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 3dca752127ff..140bd5730d99 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -236,8 +236,14 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 		inc_nlink(inode);
 	}
 	inode->i_private = fc;
-	d_add(dentry, inode);
-
+	d_make_persistent(dentry, inode);
+	dput(dentry);
+
+	/*
+	 * We are returning a borrowed reference here - it's only good while
+	 * fuse_mutex is held.  Actually it's d_make_persistent() return
+	 * value...
+	 */
 	return dentry;
 }
 
@@ -346,7 +352,7 @@ static void fuse_ctl_kill_sb(struct super_block *sb)
 	fuse_control_sb = NULL;
 	mutex_unlock(&fuse_mutex);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type fuse_ctl_fs_type = {
-- 
2.47.3


