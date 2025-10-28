Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C502BCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 05:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EADD8011C; Tue, 28 Oct 2025 01:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C216800E4; Tue, 28 Oct 2025 01:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF008011C; Tue, 28 Oct 2025 01:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8B3800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:51:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B959B13AAEA
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:51:32 +0000 (UTC)
X-FDA: 84046450824.12.1ABC997
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE99C180008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:51:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uy6yCSmK;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761630691;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiG9nHcsxcwZpHb/L0Tx41DaV7imD29tLb/ai1sU578=;
	b=xUlt/HkiWG/2RnrUnN4lEeY+5Ei8nQL6QMeXYlemNnFUzJkcniDMcbr9oz2wWtAHNKPG7A
	OeJki9+3j1RjLLJRv0+r7JwaKIun3nQ5G5HowBeDWGHlRwPWR3AtzMWaGecTMIjE6dnJeA
	SwVl/VOQn/0CypH9r8MTlchLBu8v7c8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uy6yCSmK;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761630691; a=rsa-sha256;
	cv=none;
	b=ga2v/gwOHXUfEqCprvKVm0EL0ofQ+7yyFoRnCKu/tPKUQnllzb4NaATO+cIaI8HneqBMJ2
	rxuRehcQdwHCmi8R+yNnbp6kEkUcP4pu0NChbrgnVS8Lf59pauIJ2CRj9mzAFDoKuFIwxc
	dUpNMu2HpW+T9wNEl4TiXnZG5M/6Fy4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JiG9nHcsxcwZpHb/L0Tx41DaV7imD29tLb/ai1sU578=; b=uy6yCSmKcS+lDQ9yS3I0kkadjO
	MomsFzmhLaBK2huX54Avbto6nY9SitzSncGkbtogsfBNo9tXrkJ1CmW/b2IUyPd7xtkVXzPANIs8x
	1pp+RCIkBnPzLazOP4ZqLnfM3fqZ1RmT3ZtzuUtP9Fzcntv5GmnwcUhp5X0sJxMOicH36YKp/uwlK
	5G/Oicf+u19OYeqF7PSBgKm5Xbz0464+HAh3HAbXyc8Dn58al/Y/KKVIQLMsfYdjFgYpyo/u9BtY0
	Amywa21TljAAEjyMoyuxn7FKTOOk4hKq/q8BtCxwwuapWcESPiEqaLV9iKF3OwrZvWelyauABPOrD
	EPdmjzzg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eXL-0Fbk;
	Tue, 28 Oct 2025 00:46:16 +0000
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
	bpf@vger.kernel.org
Subject: [PATCH v2 14/50] convert mqueue
Date: Tue, 28 Oct 2025 00:45:33 +0000
Message-ID: <20251028004614.393374-15-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE99C180008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ksua548tkndsicun6ekrc3m9tr6owfym
X-HE-Tag: 1761630690-389603
X-HE-Meta: U2FsdGVkX19t5MQcne8+VLtOdHvt/PR951pi1MTXwEr2rcY9/XkdiKOboP8U03gfvcUoYCwfCMLKgW6wnnrtf6eQwYUW05JDaM4f1NQvtMy/xO3B5SPHm9V05/GbpO78wp64bcTTOiXJKlcujPw6SVyVuUG07rVt8EvTOlr7PhKH7oyaK67jMslVgRBq5DplESWa3EjXgRO8nl5B+czvx8zD7xh19VYgmItstQF9Vj3Nf33jj87wC/wix51dGzaxDQsoDqDzJ3qEVwxEYejhUMx4jvFpUosH9iLBRqkKAvhXF77+JYbbjHzylXvvlR1HHs4jsCTEr4VjbOX0wATnPhg+jM77bMyJxH9NScuLK309Mq1qVeYeiOM22GO6CZpgAMs9SYgoHoEeTMwIndVvKGC+su7WRa96F/Hu9dYbMJ2xndfn/WlrF+cklwqOZlzYl4zIecIY8OA5jdmjTO+0oZmpbP482X9XJdmNUiDReyYSYe9NGo54xrlAk5vPagEHB4+3zpYkQow30IqA0hUsyg3dIOLs9QnvbURM5MWy6SHQDx4eakhC9zxqHscYqOXKG+Z3iS5G474cx3ee26zlC5AgTeZLgXlbgIds8jELsncyX7IfQyCmE4RSMpOFlw8/faEDNZ6/oFPPeHW4havqG2PEebKWwp32bj3Joi2TSJNF+7zyA7DFpMt9fPoqEgsotKEkOSWWbNKofyGvsegN4S63ADtBplMLNJE+bLyG8xas9lM1unRVyUga5K5lKELCXYkL94rYDcUtnDY9u2NY457BuOiOxai4gWjL6S2VW4YWFqPi6S4uOVuxmHC+V1rkNXFrB8gu8QqlsiYK0CowFRDRDgDiankikFeE5EFbtH0x7pBOTxn0QNvgdvGeInLIOgLk4Ys0I7xRwedCDaJGgL7XIt+XqSqGrwYNw/zZmSFLZ4GsUhvmw4U+ILIttxWBn9He9I8UiiMscjvym6U
 6cYqv6OD
 Kclb4Po1joxPvEY9/T2wt4GL7ziHWRcbDq1YeRSKRkbxxsXHRb49cznwIjL9r2qmlQC/5hJ9Z5pvflpuW6Vq1xhQIxnh37cQNCGg7yA/kU+AVsy+kpEOI4ESrc4BgX3ulQijenmdy+D5pWxLdAcUJZjEbfA7VGqVsh/t/8jVDlnsxeolBObvq5+sJV1ecolSxiwpszMZuFyFIcqqW8EJZXGnR5Z8i82T/o0SwmzMZV3MkTurs/cuO/8C3bLknKcp6bS+LGbVnHghENuy88hkVuQDqXd+bZmLV+osHlLA18NRPz9f//bmjJbq/0B8zaLJbxiZ22Yr+k2QW/OI24nBmgqcjiMi5W0jhuCA4s4CFXISOXuVEegsFwUCAHkSlmxDw76q8cqGG9DAuBVinZd3PKVvnCXIJW3uPoqYW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All modifications via normal VFS codepaths; just take care of making
persistent in in mqueue_create_attr() and discardable in mqueue_unlink()
and it doesn't need kill_litter_super() at all.

mqueue_unlink() side is best handled by having it call simple_unlink()
rather than duplicating its guts...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 ipc/mqueue.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 093551fe66a7..5737130137bf 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -599,8 +599,7 @@ static int mqueue_create_attr(struct dentry *dentry, umode_t mode, void *arg)
 	dir->i_size += DIRENT_SIZE;
 	simple_inode_init_ts(dir);
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	return 0;
 out_unlock:
 	spin_unlock(&mq_lock);
@@ -617,13 +616,8 @@ static int mqueue_create(struct mnt_idmap *idmap, struct inode *dir,
 
 static int mqueue_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct inode *inode = d_inode(dentry);
-
-	simple_inode_init_ts(dir);
 	dir->i_size -= DIRENT_SIZE;
-	drop_nlink(inode);
-	dput(dentry);
-	return 0;
+	return simple_unlink(dir, dentry);
 }
 
 /*
@@ -1638,7 +1632,7 @@ static const struct fs_context_operations mqueue_fs_context_ops = {
 static struct file_system_type mqueue_fs_type = {
 	.name			= "mqueue",
 	.init_fs_context	= mqueue_init_fs_context,
-	.kill_sb		= kill_litter_super,
+	.kill_sb		= kill_anon_super,
 	.fs_flags		= FS_USERNS_MOUNT,
 };
 
-- 
2.47.3


