Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD8FCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C798E0013; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280568E001D; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7CF8E0022; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8FE68E0021
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67B7FB9803
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.23.5802D62
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95EAB120010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=odzar9we;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AovK4oTG8i9mD8KDrbZrZDCi+2Kh5o4vX35c5oMMEjA=;
	b=eHjnOZ7T+zefAtu4pT4JseRaWYa5Pqwo+dsPCyHlIfSKoh7++GZJiGqP25Eoj9mOz9+u41
	TnMKNga12fs9xyXnFmQnCBvv91Y4I3Lm44/R1FJCSWovicfWp4sRD0vYqmKj1YEiin1h2K
	KhT/pYlP9LY6GnHj11ccy5U8exoCDJE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=odzar9we;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=lkWB5qLOWUs1CJRVWmn0U2vSQ3da2ctSBSSMz2ILeVIPNODn+Uk4oOJAivN2N65hnBDP7H
	zcEhifP52+UfVDiJNdBp7qeLgR+mX42dAmPCnP2tl4O0yuMjPkdhWvndimLfhvlkBOx+WQ
	Kl+CnUE4k+iiQmSnyXuNaru5xhaiOIU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AovK4oTG8i9mD8KDrbZrZDCi+2Kh5o4vX35c5oMMEjA=; b=odzar9weixBzYX42VUwPE8PYUf
	DnpEWbjsupemEddy27qT0QEladdomZrTuxiiYhnT0M3EgQ774jwpEHRyJniCoyxXzBmW61bHT5Qxn
	WMeToZUkmaW/5WUOL3G6/um5bstbPf0PLLijdD8s2ltQG6JOeiOTR4MoOnuzgb8d3bTmn2faGk2FP
	K5KJ3To7GTbCuzAssuAQ1Cow7i4xvRz7BVXCVE8gWQPNGtbw8ePBzXInYNoEF0DQFNFs9cTs+khFJ
	rzOoaoUTkPzhr4mKruj4ilzPBx2woTM4O/0sHKSLOoiVFVSmR0DRMkQO/Ua5XjjdZ79/YBdCfLOd3
	xMemXTYA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHl-0000000Bwzb-2GZL;
	Tue, 11 Nov 2025 06:55:25 +0000
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
Subject: [PATCH v3 25/50] ibmasmfs: get rid of ibmasmfs_dir_ops
Date: Tue, 11 Nov 2025 06:54:54 +0000
Message-ID: <20251111065520.2847791-26-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 95EAB120010
X-Stat-Signature: 7bp4jecegq8y9au93sdb97kx3i785d5i
X-Rspam-User: 
X-HE-Tag: 1762844130-537728
X-HE-Meta: U2FsdGVkX18nzkUc3YZ6UYkZTC1M1r6/uY9yhg9E6qH6qmJaV+c1NIvk3BAmbo3FmEjlJHZV8TWS4kJzqBX7mtGie+i9CSBGhidaIrpCH1Qkn5gMWcTGtU/82NVLvw65xCPNYAc7vM+S3JBWSgL3HQzDboUpcB/pWxLpamtRzS0N8gV+dUi/14XCbS0EEuU4fWMZTzIjzZmfFmeMeQeBZNTjYsRn2VL3thHPVo56ZjBGkXCYkOr+pBNzWdMFyVH+HK3gie3zwiER+H4pIo+XeE3XzrVpFmZOZR1B7yMJpVKpGJSIucxZpEUQciq01f2NOxMnsyeyJFr16DpAt2dCz/zoqlusbl10x39xNKAp5xuZM+RjG3j/DiAvlwHVTM6w9dkFjzAgfdEkoWRTKnwRf1t89TsUSMx6iTqPJSwIwObTOyDaNJcFjk8wClv+F2X34WhQrsYGUoQW63HnX5Ia7dLjroGWCNhK4CPjc6725kg0Fh0vZKSUzj67+fFS68Ub9dqdGXWYsfHWexgKqgi3mTGPUNgADT0LtT6zVNsgs9GZCWwUEUOQZDwVgMo2pSpe9/d/Q6weAlX8f8lXR5eyy/ndMp2L3nE4nnRpld1B/AChFxbIWDOVVbTqCCUZTFyqla5/PEy/BC3uXeVpY4krbX31FQ5R1PSKGXunfIYX+urYx+vCYgqcRoWW5vGp/yIOAKO/b1DgaqGLIv4Z/0Jz3YUafeyQBqbmhhP0eXdVYmgfUoJaFgC2UIh4A01QDOlNBfVaOBXsg9a7kKejWS8fhYZssVMh9DKRTQwP9KcdWougiD8WmeEZwJcWxGCUXDnxaj4eJkGEN9R819QEzmX5O6Nb/3ZNwU4pnihAYbdXmmo8Xmje1sPZCdoSkZo3ZgfXDVIinSyNnFyG8SPJ8IRFDdWPWW64HnwXZhyNJ7w8D19QU/yI2abKYJAmCTt8gEwuZONkciEp4cnJwAaVFPj
 FVY/4qYw
 +pWuk7ng35otRZKlhYxT425i3EZq900QBBNW+D1Xsx2SyHR6Ozdr8Z2wuQwSCG4sWjW2DEq341feec273ZZq0qIIDUoK6GcRaNJAqj++r+Tg6QNZuVJWIK2+m4p0p8UIq6Ec2LuBVnNaLUFqWCSDk94fNotHUtua20kp6V0ccayI+yfHAq9Q9xHtYQ7kir1xztya6+4rfyQ28UDwXuarg+TtRUo0jtRcVQxEgSDw3PIGOKw/EaQ3canN6CsmosOGr6Ry8LwPK8zyOnDrj61xc3+mFvUEKe7yPZ71ipQxTsbzlTtHSVnan5U5MIrx+6pmVUl7lY/IA4L8FfoRDZ4BEuhZ/yhtE/e2+Y3KgbDAVyvAw/ivzoONQKoszSvJhf+s/FxCJgqRoc59rzXPs8DTXEM888KorjlOJXIGlXpzY1n0/6UG9vKUxNm8JcpDbOr/e4VjvDv7yoWhGzXL8y6HKAI6F0A==
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
index a6cde74efb68..824c5b664985 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -97,8 +97,6 @@ static const struct super_operations ibmasmfs_s_ops = {
 	.drop_inode	= inode_just_drop,
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


