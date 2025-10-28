Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 453F4CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7743E800D7; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F84800E9; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A538800E6; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 103E9800E6
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD70487662
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.29.B6C13C5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16E6918000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Nox/vfUc";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf16.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=CX+mu+maqb8PR945zOWKLYL6O5CuvsVvaDOI37jQuUj2J/Bj3TnQ6DFN/QPJC2ho9xhTIX
	jNhWcX8lls5qqOSheENQ41O5p7Oj/fgWcB940YRle4AObr52M9FiLRu0MmqsvIjDxN+1bs
	SxYLujS7UEPDjjs+RkyP7k89hB9+I5A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Nox/vfUc";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf16.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF5oceMSXViySxysMkUNPeCJ07Zgu8R8pwpIbBxZfJs=;
	b=tbvKy6Nn8ocUI5Hgh1h23su7fxIJduZ7zG/PlSdSsisv43zM6DZ63RIlTNqChnkbImfSA6
	c+sAdFVwLMRCE7YXHCwSITaISCXfwAC9U00T/LZegAeVfkeCudtwQlCbBwg/d3hxEE2tzh
	JNfW9z1Ibce2/nuZ94BVRJgxlZIyN8Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wF5oceMSXViySxysMkUNPeCJ07Zgu8R8pwpIbBxZfJs=; b=Nox/vfUcgx/TdeOwjzOvIBCDcH
	n9sXl5MTg6aGwD3FdblklBCbekJf8k1VNaIfHkTysh8rHxqlTbDJ/t3Elsggu3Q8NZgpFPmz/N0WH
	erYPHUrU44BhDD2BW+OYKt6Nh1+Wi/YQIld2OAuPrfyTCBSrmjVV1qJfZiJcoHM/lEtI5aheobi42
	o8Eaw1L7+Wcws8iEzDES8PjbGLiRsPv3gyLEvaHn5OP/E/vRRUjW6sfKVf5yLIGi5nbrImW7RHxqW
	rHwcCYmYY6i586c1OKYGUe9PNX+DoM/1FugO+0xqUcw2o5JBBKON8yxD4xOITf0ubS+ds+4pZE8Ec
	5nJDTKTg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001ebX-377o;
	Tue, 28 Oct 2025 00:46:18 +0000
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
Subject: [PATCH v2 39/50] convert gadgetfs
Date: Tue, 28 Oct 2025 00:45:58 +0000
Message-ID: <20251028004614.393374-40-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7tiddohu8nx5aqq5aac8h6ib34aamfne
X-Rspamd-Queue-Id: 16E6918000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761612383-618017
X-HE-Meta: U2FsdGVkX18wv9nmP1FgmGbwgayfbpdVLZ7KHRbFiuEKotOrRaUZx7qQSTo5HTDaU6WXBxjZ5BxaqDMCmrV0Y3YXayea3CT0JKOhWrXSfYD5JiuXK5RaR91huU3CTjS/+ADYl/mNDPUuMrRwHjVF3ROoDmGdgyouDihJxkIRWZdbDaUAbzQ6XesieZNczMjFQ2TwCeqjmvVFMgE9Fj9S3UXaqC07HIK945eEquuGNYaT7tIKSoqckf7n77LdK155AG1OBXmQ0nN1CWXQUj96eo0T8ST+EJ4Ddh3qY1AgcuSnupXKVANiCSsHujQnduQtx2vEQtzgr0TAqihXb7kP8bi++mtCZoy9MpZgG7K4nVz4jrV6dIU7bXeuuqZ7p0Uk3vjuQ+HsVnOWVe/rXdARLwGf9q7xZL4QbgA+zFxOPG5yl0X75jlcf/kc44q0tqpsp8t+an/KDTtVg9J4+lvx5mMsneHLlUxD/4aSHXnNvlqPUTEL6o5unU6f+K84dQvi4PXVUZY+jTZYY68uNV0CWAdNHVm0UMf6WitrmHY57MCSe0t5Q3hZNYahc7cHvP0QAGQLR406XEpYxKJEKCRFM7K1c9p9V5UVg1zNvuUi+UkkrYTTEbZZHJo9juPEWX0p2oD9VXEvE8Cs0vwhECSFX3oJ56zKDzLTh35gTit+SU0dezJMxmI9zAvMdbmFovDE7YUSXaDaVYTmmwQa7RBGsHo4Cg1MWnpfRr89KWXTWVPPveZYhCGKv6dRT/IDjNDF4sCRTKM7fJEb8SBaJXi2dy1FuK/RrnmU0uENHhGPYS4Ofp7xbquLoLzG/OixlOcWyL8CwYXwDIwijDAR9nSDFUk2rW1gPbOJgQnFe6uC4iwrPO20umOk4X8POTi2fwNLUrmbXh+32pWu5hZGFDoyfbsApXdOk89LxJfyjq5FtEZFB8fuPBO1NIH1xyGXmNJllKl3bGPHu7NjeMsKf3p
 jfMpCNJm
 AQEeCz+Wc6Ab7ltIEExEVrfb85R2eVcpXDu0qXQSoFr+Lx3MiFH0KCpidF4lBtvgEDQojLEK75Fe9I2y0UAjYeI0LIoUfIOyJRYbVPwRgPpIoy6sV6ZpILChdYWiyaSRfo2U6UUZzsAxMIi80kpxXjkn7Y5DiX4gGNEmNeX3mfjhA8FCgD5NJsgU9frmDDjF0JJpTIx9bTQfuosaR3MsgT4w/snRHwlNYqgPTx/J4Rk1AiazQvdLiolkXU+iiDknEZyZZWLsjgNUiXiTERFnhvEhlOzsqCC8poBwpv9Wid2IXI1ircoMmEIrrVgKQJfUPkwn6it/M8ngtTOq9FdkrW5PkCqBc+d9aCz9CzFy/xoQLD1U66y4p2OG4vFFwQL6IYwxz7PQhnxLLuWhj6CgIf305eMpcWd4Po9AJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

same as functionfs

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/legacy/inode.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index bcc25f13483f..62566a8e7451 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1989,17 +1989,20 @@ static int gadgetfs_create_file (struct super_block *sb, char const *name,
 	struct dentry	*dentry;
 	struct inode	*inode;
 
-	dentry = d_alloc_name(sb->s_root, name);
-	if (!dentry)
-		return -ENOMEM;
-
 	inode = gadgetfs_make_inode (sb, data, fops,
 			S_IFREG | (default_perm & S_IRWXUGO));
-	if (!inode) {
-		dput(dentry);
+	if (!inode)
 		return -ENOMEM;
+
+	dentry = simple_start_creating(sb->s_root, name);
+	if (IS_ERR(dentry)) {
+		iput(inode);
+		return PTR_ERR(dentry);
 	}
-	d_add (dentry, inode);
+
+	d_make_persistent(dentry, inode);
+
+	simple_done_creating(dentry);
 	return 0;
 }
 
@@ -2096,7 +2099,7 @@ static void
 gadgetfs_kill_sb (struct super_block *sb)
 {
 	mutex_lock(&sb_mutex);
-	kill_litter_super (sb);
+	kill_anon_super (sb);
 	if (the_device) {
 		put_dev (the_device);
 		the_device = NULL;
-- 
2.47.3


