Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D6ACD1297
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663088E000F; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56F68E0014; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E878E0018; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B82EE8E001F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 485E91A0418
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.02.D838965
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id B1984140009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qH7TBk+e;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=x+0zzrPsJ4dJTgdeb07oHkO1XJIxQohJ9Fxas0816v0SFdQlJukyfZhzKANG/B37SFS2nh
	sfvK0grXtnEjtruCdw9U7mAkH2apIx0WcmtfuiiKHNAb/CiKuC2B02VT9hpYYNCQPvcryW
	cARr+hsPlRa9J8sFpamZT1cnTL9T/Kg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qH7TBk+e;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTvrbo3mOzTGCel3agLEDWiwlpX39p3niSGJ7gA+srw=;
	b=zEXrfJOs3dM4g8LIeccGSBT2QfdT0u+pFlkPWY/0AYjHma5DgI9PWNvsOJZdO/pK3SgdZQ
	JKvnFbRXkSDTAoNhsF0RKe2a1xOokwNREjLP6MvSZEONm1RUoCy4muUlOChbOCzr1sFjR1
	C5Mnm/YCK/i2DWGpvRi6+bXpaYeYlL8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fTvrbo3mOzTGCel3agLEDWiwlpX39p3niSGJ7gA+srw=; b=qH7TBk+eHDvm5siQkKlw8FrzJW
	5Jui0fzA1zXpfadChbrGfDRhwWzG9A5d3XeSOOD9mgbukwwt8ilhKYsGWlBDSIwpBddE6btAAtNO1
	Q+UfbQyrVcMNQ6/tVYxuZ11sG1+GQLxgGfZ6/dzMsBqwd7J4360gzf1wxR/Ha9FhGqS7Q7RPS/Z19
	7nm0ndxcMPWJn1kWEBx+YxLOZz5dZlD+HOAVoPRbQBr+KLbYHRTaXR/j7mT3o1NzDnCTzvSyaGs4t
	ot+pnKsJnuiV+NRDNWD4nZHhKUnDl7BjtUBnp6m+dEeVUEtt52QIfrLLCGG074PcsdayQbP7DUbrZ
	ze0yilYA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000BwyB-1e67;
	Tue, 11 Nov 2025 06:55:23 +0000
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
Subject: [PATCH v3 13/50] convert hugetlbfs
Date: Tue, 11 Nov 2025 06:54:42 +0000
Message-ID: <20251111065520.2847791-14-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B1984140009
X-Stat-Signature: x6b8kyxae4afkoyxijcu4qinh5yqnux4
X-Rspam-User: 
X-HE-Tag: 1762844130-274786
X-HE-Meta: U2FsdGVkX18KruP4PyO+iGQqtzJpQupLgiamxGUK5CyQioZgpPwDjlvvq6D2m2Q7w6uHmqNRNLO8FnACjsTNhiy0TLQiYLn8Ryovi9gMaut5r7w1ox4reA9rBvF9cNEQTOZhHeo6Q0ZDwxKoB3D8AiNGOgOm7eVdxGM6ipubvWYvk/ngR2amfo/tPbPHo55UBFArOhM/uc9qSqB7k0el97Vbfzja71wsvyXhQACsF8zpfJYGXBjwzJOT5i8VGiMlZWVfwKDvfqM+Gjs9Rb3NxKLakzttKCDWvd6ckS8W/u7ZBiE3PmC7+Gx7NHYIeTXe0VQ9aMph133wTk8CGimIRaPVsyFC7won/vYAYPRJxs8u1ROTMv7G2Z7D6r5AqIJtxpU5U16tAtQHEIsiIV6uEFTCFLl17IeXy95Cc2uyUMQjcAfqB0v9EkP57QqqTXNFdyH5vF23OC9rS19PgxfwMOqIgzfDQeRu9OUIKXzPM6EhoUvL+54etPQ2nbPAcRI3ZdQ0HWAxrdy9gcpL/Odc2yJFfMQUw21gdK+aEx2QUbUvYGJXZi5YKye3jF7Uxs3dIaVXNNp7ujWEwCIGZYSi8Ja4qLxjDO5Be8tC3pWSZcV8uT5G9SFQ5LXgPu6VDQMi5IO4bRdAPrXurB/Z0T5mB6P2cspi1ZIdC+sAR7glGd+rmlkDdcI+A8YmTmgy5WxBEm+tk9ScHFTRa+uruFQJZmh/8nOTbicMw4eL4DeFYll3EwnmOL70ioskIyJJRJeHSUlULr3AzN7aXN7mqOgsb3EBq43eyYHNbgVUdwTxYp4X1W42GmePqXNznU8rsU3oobx/mdsXweOeeUQZy4aYCKhsF3hBlB33q1BXc79sLzYwbnjdta8bkLYSGaaSvJTQ1c/vvMv2AyQuCmobpjyoPpopk7RXAsWVM9k74QUvFj6GY8Dx94YpQJ/QbuVNcpLCY+32ZEF3RFS8GqxIxer
 ysuAhpRE
 bVZA4H+RiAyyaTEXDAMe9t4egZpU0KWiUjiixo9BMxYng+H6kj19rH856jfXlO4zZdkmT7XoE28UVotssiC3RXm0QVrD8qX6Tfklr/VByKuJNPeE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Very much ramfs-like; dget()+d_instantiate() -> d_make_persistent()
(in two places) is all it takes.

NB: might make sense to turn its ->put_super() into ->kill_sb().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hugetlbfs/inode.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f42548ee9083..83273677183d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -975,8 +975,7 @@ static int hugetlbfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	if (!inode)
 		return -ENOSPC;
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	d_instantiate(dentry, inode);
-	dget(dentry);/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 	return 0;
 }
 
@@ -1023,10 +1022,9 @@ static int hugetlbfs_symlink(struct mnt_idmap *idmap,
 	if (inode) {
 		int l = strlen(symname)+1;
 		error = page_symlink(inode, symname, l);
-		if (!error) {
-			d_instantiate(dentry, inode);
-			dget(dentry);
-		} else
+		if (!error)
+			d_make_persistent(dentry, inode);
+		else
 			iput(inode);
 	}
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
@@ -1483,7 +1481,7 @@ static struct file_system_type hugetlbfs_fs_type = {
 	.name			= "hugetlbfs",
 	.init_fs_context	= hugetlbfs_init_fs_context,
 	.parameters		= hugetlb_fs_parameters,
-	.kill_sb		= kill_litter_super,
+	.kill_sb		= kill_anon_super,
 	.fs_flags               = FS_ALLOW_IDMAP,
 };
 
-- 
2.47.3


