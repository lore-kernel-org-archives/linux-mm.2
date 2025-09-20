Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB11CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670FF8E000A; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD808E0001; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69FF8E000D; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9808E000C
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F35B411B102
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.06.BE6E261
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5751F1A000C
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=vtuBnJp1;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiG9nHcsxcwZpHb/L0Tx41DaV7imD29tLb/ai1sU578=;
	b=oB5GCHJ+UJu8LVL15Y4F9mEsC19gUDlhlV56Am/I5HQ5RzYtg+8Z1gPxDlTjmJtBqx2GZ6
	BCGuDQVP52nj58wg+4n0cpekpCmPkC4a9+nJ/HL+3A7o/Ih+j12oqrs89lMOgp1A8T6Exl
	GsihSwxoLG/6v9noW+t6zBWi0mA7ceM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=0MF5ZURnN0pg3SMogNKiqIWekL1pIfI13BzUYX2BFqCJQVEIuw4leSX9YKK8vQ6PXxEAM3
	GwsIMIg/Zk3gIvc54xUAG7eOgNwXA/suvoLJTd5bMvsalEJyAnSBpdvfLgin9xgXau2KeY
	jLv9Jbo5UaAzOx8KjSoSvLyUVKv1qOg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=vtuBnJp1;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JiG9nHcsxcwZpHb/L0Tx41DaV7imD29tLb/ai1sU578=; b=vtuBnJp1FKdRJaUi9wf6dBa+cw
	yFyba5mUeAFRsUmJroWbhRl2eUzKZlVVNqj5veAhvT6EC9M+C9P1/Y8zGdTeqZE/bI1HCme8sHdO9
	GcPjmOj3eT9y485+3rjAUNq69uFkp69CbzOdiVe81V46rzs0RvAuwHALDxEHK9F+mtRy7IyEHwrkQ
	W48r8UtFZtMv4LD8awybcvRGhiXenr5wHvuktQ8hFQb+XjdjbkZfFpItsbQfdQktAwp+/VAEU1+5f
	6XYhchXPqQgz+DLx4WbjOi5xYPuroCrhW+UL2w1nNz90dt4otfrX1DERefvNIrWozjB1cTQ8oHCXr
	q1esPHew==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK9-0000000ExD1-2NQ8;
	Sat, 20 Sep 2025 07:48:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 12/39] convert mqueue
Date: Sat, 20 Sep 2025 08:47:31 +0100
Message-ID: <20250920074759.3564072-12-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5751F1A000C
X-Stat-Signature: ecyydox5r6rubsnwfp44xpnoumq9eftx
X-Rspam-User: 
X-HE-Tag: 1758354486-892026
X-HE-Meta: U2FsdGVkX19aPLleVz0iV+xbcrwjuAkEFYGYiODo2Sn4w6YAJ3b21FVl5YjeUfg+O4Q7oD4ADCOSqQeQNb6+FhK7/sD3oQ5K9gq9HsBDdpagnrZnev015GV2RN6qfruL3XQy3MxExxYnbEMQeWLHoHbeEeRxmhFWOJL2j4cAI/x+RCvu5V8sv1Okmy9bYcpqoBvbtxcSrK2iczmJ3y/zYF/4HD22f+OeMM8xz7U3KCVbCzKg9PG70db2vO5x1x7nSTEk16KE1W5WCiXx25Qs0ojjYjStmLzUd7KEkElDn+YxhI+OsJ93nWx6xqGFfII9a1yZf/1WOaGYRFAywhi8oddhBfAfmKlXS90ns0h3LIxAhLaSwDSwTXbhOJGjcRmRyFa/4j0u2qSTytvyqyK0k2z0QVw6n/0rnN/ZlDsaK4Vo0/2pmD04WffoYJqxp/iTunAu9eprtozLwI0DlwnVBH1jWkLFDyiWK6OEaOnWzQW9dNPb8rmjrn5vttv0J7dbcEtT5aq5n9Kua69fIA0XUnFOH9kA49Kr8osFGT1iQferkuOpSR0nLd/2qZBuwtrvKYtKe3ozffTG10JEwln+px0bZoJEDM/DeqXLHl9DUjz5h7BbsHiHJxg8ekLeAL8HP7Ayh23R849nGJH/ZPy1WesIeuc+WreA3b5BS5qyWuIGRcEMdqUVjaeqnmRUmI9gBpQtXQgbdINITYUdxDCx+/EltJvjXUY2jGm18y8/5MdcNCtXesCWF2sRpslo9ehWefvd82V9PXDl1+bXxqrjFmkEwRk6fRIBvhON4WsOrn1RiV9/Q7UJegPdRLQBAvLVg+1kgy5xFijiQefT61IptfX0QP1GHzKnYD7aL+8c55UpEfufvLxkTfoWF8fQ/yjxjvWkP5ITrehUQaCG91j1vl5voFT/B+SZ49agCAl8NIjIM6o+qvWVy9dXlqVXa6IY2Ihfxg8NZ9VCVN35QbZ
 1nF25OCX
 Q362bgOZvPLD3fY3QnssZ1LihB0yoMxuvoNjMlb8HB9VPgo/f538J9Y/eFEbd/6VSZVyJ6p02hqjB54t2VQOeppc0UFuqMQs7rnX+omK+NrOrK7ZuwaLEi1tHuViuHwGun0a8fU911p4ex2ON9BLq6eMyJQsHm2oVtLvCJmWjdgiGd69zb8s/xI/eJDvx7DGA7nAZP2yrE5s1jYphNdM6TSmnjxOKa6bt1ravUTGCR2B8oPql2ASPsEOEH3QotL8ueFWQgNPIb+9vEL7H5LQ1GWo7PAAxs+iggTWvnZrCReCnwkHN4kz24C4H/cL4G0AQS82FwTG5eVzH3BoP+zc6dse/VEkfc5BnojhxciQZTJFqSLUSsJFPsROvkfExJpPt77psl6asU7Kut60mEntaUiTnzVF/ZPl+jWJ6
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


