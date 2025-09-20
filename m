Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FFFCAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 08:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EF4C8E0005; Sat, 20 Sep 2025 04:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179D68E0002; Sat, 20 Sep 2025 04:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041058E0005; Sat, 20 Sep 2025 04:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E14B18E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:31:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E09A5BCBD
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:31:32 +0000 (UTC)
X-FDA: 83908959624.03.9E8E51F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id E7F992000B
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:31:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=t9UrvmM5;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758357091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GckmVne9aZbxHVaiffTEmOK19oV0Ap0iZoO6zIdeCU=;
	b=KhpxeW/eAO4F7T6kP22bsG9DArSCF65NoXsiogbVX+iJ6x/yN3GHwVMpOZmMtlUspsJiSF
	ABydsLKBJhGIntNAgddXo8jkqIsiS6viKOpNDL/p41Xdb0ayukoOAjQY+yssayEQY0xZF3
	z6UuOD/ByEeeXolDtTHdpHRRyKcDZe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758357091; a=rsa-sha256;
	cv=none;
	b=ZSJyCni95/lE6Sc2hwe9Fjyjl3UIcq/STzV5Q+twUjgUuD+HJMcBgHznqvWBehJITIVqKI
	sqwLH5T3XDZbxBvTbq/iv5/NJc4lhV1RhS07d7kE6hGH+Nld1tZEgdYyFzKfmPt+Niz6li
	O7QHidOXbt0XQYlRmnyfgbpC1JvxUSE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=t9UrvmM5;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4GckmVne9aZbxHVaiffTEmOK19oV0Ap0iZoO6zIdeCU=; b=t9UrvmM5OQYc7vCwJTy5PEGD1w
	+awUfFUgSon14MdW6tOTa/rhGWa25zM5Hn+6VH4wQba64aQj6KKJrnFmJ++OVTlx3P2goKG4EuiJl
	cGk3Gk9ZNT7z7lVdTVgv54XlFDXS/qxKTYgRq2cTYtw8wh0ljsNeLSSQndW42cXEJ2FtV5Ti2vXXk
	C8/t+gbvnHlceS+y5Ov58sDEc40NB84G2TlhtoMZ5m9SiVzwe/BsUoLyqd4kf+mqh/hOGkKGb9gWP
	BhzBVMXzPDO3WcVMFM9Db8xjakJKm1+HRtA+eMRqSfy3zaK9i5mweZWeRkOnIq1e7WDMrNSaP3tWa
	I0eE3Zuw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKB-0000000ExG0-4AXO;
	Sat, 20 Sep 2025 07:48:04 +0000
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
Subject: [PATCH 23/39] ibmasmfs: get rid of ibmasmfs_dir_ops
Date: Sat, 20 Sep 2025 08:47:42 +0100
Message-ID: <20250920074759.3564072-23-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7F992000B
X-Stat-Signature: e6rhd3bmu6ku5ky44611yf1gjz7w7a5g
X-Rspam-User: 
X-HE-Tag: 1758357090-838874
X-HE-Meta: U2FsdGVkX19xqKusnNTi0oEWyKH753NkzSIoWzczdH5XbCPZnbTZHdGtmdtp1aEbRl1G7gRl81S6XCXH3zMfYvrOtn4e3E0b2z4rmgFUiIedArgtSmfIlMLoTnK6fXbLoCdC5EWEGKV3rarBLuLvrQ7W9ZDLdr1WA21QM8EH6bKNYq7pFBauJoas9U6iwUkXbs38UAAzpPuFUKnk564b83enTvTRxhzo4pBnDxvK39ccaEzIMONjN5Y4PoxzvzbB57VPkk7RnEo5P/tpUxsyXnd+W3YheNYutUwI9S1xpopAe5FeItxeyH0ZlyWJMNdH0PivF/e84Gq/eJozT+g1rS66jReNXudd5Kv7/ZLvXJX0hT8gVBEm9Ec/43STQCp8ypgonbeS2SOUF+W/tfBTQ5CjOij2TeUdW4E5de+KcYTS/a3ucaIG4HUYGsD8gaQJC70Pm0gsND6eI85u2YeiR91uR8DCOOj9yib6xSACMtyEupm6dnje2heaoplZ9S8RvD/lmPvs7/o719oO2zNlK1jHdpcZM/CYBWHOqTDOD6e0aN4r0s0bOgGpVc7F90c0DZSDqV1U03yrwIvsQqcds/pkZVSSKvv+h9tSouV932q28up+16mKyDsJNvAvBp4hrAzTCR8D+Ca6xqorrhWEzKQ+VJmT8RfkWyB3l3dahCJ8V4Tf1I0veBzsNslWHLbETsve3Jov9PwjNxHedIKdEWA1DXMEH02LAwKGhUwTPICWQNbv9EkQLbnLBuGHV1bC39STKSoXNSf5p+xvfOf1kgzpfbs7cAzXC5QU6TdO+jkNPKS/n2iTX8Hb7hHqGFyZpATMCH4xOZtmaJsIKzhZQ1EfqLFxLjz7wEKPhf5HNXkXZSjjh4ApyP3XVt65LYisBslrkP0PNKLrNF9pUUqzlnXzOWcYK0TdK8Bn9yeAp+snQGZ4f7CHhI1BCKPL6/j7bMi92ciieqe5TdTtpKt
 v/KZWNj/
 2cH9cEnSOlG4DtvNGk7izBAUBPXrvIgzcbeiIAMnYKwl4kgjmeJXbkj/aUZnhSkw+1pnHE7nJmSrvVAj++x7pkKOrCQ+06/QIrAbIpeg2EqmWKQHt3ExsMdSBBl4shhD1lIHeOHmPHeFeTVkSoNKpoeKZEpT2/gwuSoY0R72YBq5OUNhVgcgpaWNJI23OPaShqX8JVl+F50MNa1nSIYVBwurrdRTOd3bvdgRiS9lEFPGdmpHMj+2dmoNHfbL6L4b3bVmdY+0SRjc0yvxm4yfdoRzxvh5xjtAtzNJJWbm3tQgA83/d0AE1e/OVnxgR8mkNe+OquZsZ2tDvmdHjlFEg+tjaYVYpg1Ow9hcSqsZu18lDWIX/y/mjAhM4DwqMW07QBKN0dUyHCstpjc2aF1152k/ivWBQhkbZoCV48mLl7PpO67Udz4HzeJiWgeBxySU5xGS0kmeSmZsskUBn2EEJR7Zc4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

it is always equal (and always had been equal) to &simple_dir_operations

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/misc/ibmasm/ibmasmfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index 785ce294f4b9..7427adff2a62 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -97,8 +97,6 @@ static const struct super_operations ibmasmfs_s_ops = {
 	.drop_inode	= generic_delete_inode,
 };
 
-static const struct file_operations *ibmasmfs_dir_ops = &simple_dir_operations;
-
 static struct file_system_type ibmasmfs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "ibmasmfs",
@@ -122,7 +120,7 @@ static int ibmasmfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		return -ENOMEM;
 
 	root->i_op = &simple_dir_inode_operations;
-	root->i_fop = ibmasmfs_dir_ops;
+	root->i_fop = &simple_dir_operations;
 
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root)
@@ -188,7 +186,7 @@ static struct dentry *ibmasmfs_create_dir(struct dentry *parent,
 	}
 
 	inode->i_op = &simple_dir_inode_operations;
-	inode->i_fop = ibmasmfs_dir_ops;
+	inode->i_fop = &simple_dir_operations;
 
 	d_make_persistent(dentry, inode);
 	dput(dentry);
-- 
2.47.3


