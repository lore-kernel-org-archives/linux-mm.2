Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE38CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A78800E3; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5FF1800DC; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E58800DC; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9BD800E0
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B95EA13A7ED
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.15.FA9D4D2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05E7D4000E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=mZm3qIcQ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AovK4oTG8i9mD8KDrbZrZDCi+2Kh5o4vX35c5oMMEjA=;
	b=E/JrB9ecW9LH7dRpVeRsyatyLMkB6vT56XZtLtVmW9Q/0qwygZHbjcTOviEkm1H7Zg2rZP
	rnQqF3BTgvX7B58PbLB4g3rJOXpi08Ebl0x6OU8vCx5dWgz+/3C4AQgQmmCbV9dIY2Kx8y
	J1QPqMJ26HMDcIvm316MwKO6qIK2Ybw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=Kj/D45lEpV7laRFN6/ROqjmD2UtjRPXubipgDvmKQLlMEnOiUlVLqxjutMFTT8zT7qCaF6
	D1kiz2vBo77Aqz1wcsYjhlBS57YMs7vZHZ3juSSc5D1JbZMixv9EEhVfFB9rfhc+nLlqBz
	WF62YicIQq62eb/r/DW4Tl9bVjNEDdQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=mZm3qIcQ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AovK4oTG8i9mD8KDrbZrZDCi+2Kh5o4vX35c5oMMEjA=; b=mZm3qIcQePpnJyEcsH2GF3lRaa
	0e4996QFXgXq2c0ReB/hQGwGdpUNf/1df2YVHWrlLszIlcg3KAT0gTNHH5TFh64MBd3r1mXE5ppuY
	G6H3+MfifD10Mry27hkYV66FvIo52d/U5q6hu4C6FaEsvaMNwcUDTTLOWTWaBW2jSy6LO3ThgDIZ9
	r5BXIu9QVukWUjsthtNBRGpPUbvSvpKScRpHUAEXw1YS+thW/UYn0XpW1vhtcmjs+h7dzPgLkuAme
	ScxYOf2U0QYqPj0W9MdXfysJ9q5OCPlKX/TSkaLBCqo10TlvmtqSSH/2kxBXwlDBIZyj1rX+9OTyW
	HoO/U3pQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eYj-1BZN;
	Tue, 28 Oct 2025 00:46:17 +0000
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
Subject: [PATCH v2 25/50] ibmasmfs: get rid of ibmasmfs_dir_ops
Date: Tue, 28 Oct 2025 00:45:44 +0000
Message-ID: <20251028004614.393374-26-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 05E7D4000E
X-Rspamd-Server: rspam02
X-Stat-Signature: nj8pwzf7toui8gwytcyhw4tqgsxx66rt
X-HE-Tag: 1761612383-811521
X-HE-Meta: U2FsdGVkX19FHIYmXsHsd5z2lI25EdUxn5v+Fke427NpmVfMA43RSOzYXUmbDWG0039+4gxBhaw5P0A9F5vxq2zKaLiJegmgGkuR8B7/NWRKrdVNvVk2YU8ViGQ+BD6o6T7DsJgjHnrrU40yK/+vu6+6RoAJof/+kz98MpNzQGJGjgZdEFpZ/IhJdNpeVQrtV8fPiotHs7DIvMBqwnoaH3d7kKXR+EK+FzvSrky/0GyPQ+GPLENVOvUyBGwE8KYqTXezHvGYJRDsSXD97FkahTL9ZX6fqxxthm+0+UGtEAPZ6eGR+hS1o135ms6C+LsNXposHQp4EkqM4YPhVy7J7X23/w6A7hLRWQOn6PYxkNADW6fxj2z1LS5AZEyYsO/DlBgpulrFMXVcIsNuOMP9Dr8RYc5AKiYo67qY5f1hYWqhgV3t2z3IVmyVIed1spDtACaXDnGkmmEBNt8yDaDdbatqQ5EeGvjDPEFxDGsOS7jXpSeyZWBtleR62jSvM0RwkQWrMGDHn4OcfJqt0ngONQ34wkNiXWeDb5uEj8H0bvNVsPT2W/drGYvG0djkxReeFiGjKeI0dTK5snBTu8nO81z9h7p2qvr66BKwweDij9z3VI6ZSC+ibg1ytfZkoyJLeVNFg1g9fesdfn1bYQjVpCiYhpSIwclQrwW8qmdFPxQBIMxJtWiZDW6HPVchkelL+RiO2KDAqEnRzO9R/cyNn/tI+jKk79srG3YVh5griL2iCKYQYQ4JzPLhPP7cfFSkLUfa1QprXOFoTbfuLYZs+VPGep1q9o3suYqTTOzLaXY1dvrXuii+1gTUCUz0qK4P/kUC1Avks4BBlrtyLhgB8+TZWcH3U2Gr8QSKRQEiWFcl8/ZCBRzQlKk0hI/lQ6M1FIBnKAk5XJzLLLT9EeqSRJD1smhU20MaBqmqQ965YteWX3eR0Y4Nxio9T/ETvICRFFuQmUH3vREQrdKcqig
 Oc61Pg9T
 ocwUp5KK8+xFo7JL8X8qvarxlxV5FN0SKYTnhsu4Spov4rq8OfY2UJJcvsRPLOo0HCxrdjmqyglSKi2c4EegTuElsImAuRgZZKpGByCxqLvEkHuPWtIEs5NycTU3+7HAh5FsIiMCj9RV7yPIZTXbdHHvzmtLxKCbcLC5Q0CS3x2yor2T+bx6B1Y37lIiOibMJCT8ncFNJxq53bfgkdWjueV6hB1wZV1NwVf0pVKIim+ngJsFyQNIcrDmD3TgeWe0mHsm1E/+rbfGUrv8dUmU+avlOpKs6PAYPHKh8tCflhs3k9DRYTt7EpQTUjJHCbP5F+aSsKTxwq7i2ll9BJ3P5EAVvRLEowqUuzVmknHqG5PjAcrauc1Waj/LISSUnpAO5qKcsIiZUY///WQ+/+0e5KqJONWDayGxaC5umH+RuCJPgqGMac3/d58Xpti5TmEY8jWwdyj5nntO/Irkzue2z1LIqAg==
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


