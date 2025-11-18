Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC6C9CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE146B0006; Tue, 18 Nov 2025 00:42:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36ED76B0007; Tue, 18 Nov 2025 00:42:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DAF8E0014; Tue, 18 Nov 2025 00:42:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5B26B0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:42:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F4E3B8B46
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:42:49 +0000 (UTC)
X-FDA: 84122633658.12.BBD7B91
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0109880012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:42:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=p1iwR+hn;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763444568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF5oceMSXViySxysMkUNPeCJ07Zgu8R8pwpIbBxZfJs=;
	b=uuC9yFwTqMbHMdBUYozg0634Vj0Jq68Tv00h2ZxGJv8zqxJOZ3tlWApq0JIK3G/f2QiICY
	hDv/tv7hnghMVqQvMlNX0wK0gnGehNjK+U242o81heR7tN1x8akbtQ6iknINw0mTG5HO7V
	fUCy7ruad/jAUtKcHxdNzQ3iHBHsU1M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=p1iwR+hn;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763444568; a=rsa-sha256;
	cv=none;
	b=dBuv1JcMvj8JCYxtbOfvHXMFwZqogzkaHY4P/BDSLNznWnxmBywTx81FTpG1IrFGs4qmti
	wGetqaMipfmcjw8YLMixjLLEO4Zt8vPG7k6wUy6rRkb5ftt1ZD9EiaqtWtrVCLWqmCr9nO
	I3V0ZxPR5T/kjCGfZTUcgkAin/hAAjE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wF5oceMSXViySxysMkUNPeCJ07Zgu8R8pwpIbBxZfJs=; b=p1iwR+hn8eQdKdM3Wg/ANXtfCj
	TipRsYDiAz2VNqxV7sNr0hMSJsc660aN9n7ij5Md6J4McBUo7fexK3H3p3/I+eMEq9mXFldv/xLhh
	yFTHIg5AxvmHJZvHAtqPxKicTGvtSDquxhI3/v9jeXl/uDIypJzi7bUBv2fB6Col4wqstkXB5rqoM
	+2aKg9moxFSQBNSXzhhr7ueXB11I4MUKMRxfO7RJikPBt8tjzwCZk1cAsjwUgQwsbzwolD2ctiqZC
	+IlN8GRfsekf4G77YdQzs9zGULzK3qD62xQUFOgfQTg0VNQXTHCb2leQ2qo4cSh41LB5CQNL8iW3d
	y2L9SriA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4X-0000000GEWd-2fos;
	Tue, 18 Nov 2025 05:16:09 +0000
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
Subject: [PATCH v4 43/54] convert gadgetfs
Date: Tue, 18 Nov 2025 05:15:52 +0000
Message-ID: <20251118051604.3868588-44-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0109880012
X-Stat-Signature: js7wyi7gkyz3uqftx8mfkopiu3wmzt4c
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763444567-686351
X-HE-Meta: U2FsdGVkX1+69NC3kLAmakqGuYcRnNZwsSzaGyFHjUrgFZOFgvOQ7K7TUo8NoW9/x/gqvXKGb/nbnKILd2h4/+OOSL9GGXuJ0fvIDBLpEgmx1S9+tMQoxsA3l1ESv+FDmDKfHNyrvJKZLbL9rNTVLWNPR/pluiiCnZ5QPd8AqbVipowdvDW4btni0Jp0zzc2ofsxcA8lkJjs9b3sgqZsSVZoPU74e/Ny6z5VGiCyRLd5nKp7aXO4J6ZYRFbytdKDaC2mXcJos8EmCyfq50VSnDAk7gDWTEeLDQoc7axd+9aFuhHfcburDEeIKXzO6iYuBvBs7udtQ2sjyvbCqI4a29hKq69fq5TazfbUNfRQc6HFVYa7/8DWxHqMrKvo3df+wJ61ZNmGpDb2cDhjDRWqGPFOhpu/s9pEGaDZv7aqjPWjrNBQKqt7L9/oSEwgipZxASfVze2diKvjIvYlfyUOteJjyfOepHViEwqqU3iKrrHmKs+07/QQNWhPk9j+jQv+2hGBpzEDkNFRxh3h3VeciuumahfCKQMJAzod6Jo8R9I54RnIBTwoPfk5MNsV6vqK253vH1uFa30o10OQEfjrGL7m88uUpHxAaVOn44SIYy+vJ8rtdC3NCsr8G68HWaZzR1MNZkk9G2pd9haeogeIGWsbPznVp+p9ZRnY3Yz3CAO1ttLYkm2ifGypFnIbAHfajUSo7Y081sJbowYHhFqdp4eFXkzgIqQqrK43PbARdIqjkvG1hWeSNW0OTHCRZlb5LsMtZg/Ps1T0UiDsz3WwX2/qup5vZGV+v4xpXCVyBPoxDC1+pRTT5Indume7+p+A9FuSBeprExj70g/5eicAV/KQ5H4yxwf+RavIWyLwW6X4Qjn5xt4+u/0jVAbiAFKXYYrlElV8lKRYPizRmge+S6NMGp6eY7DX9zNZJ0Su16U0q3uaEEqs//vE5bV6+NstPXG9G5GE/M1bP/FOqE5
 lf1oxeLb
 MykEUQV1FjV1YaAl1TZ7Vjn/TK7WD2zfDSO8Q8bmThVEb8nfKhPfVrp1aYKN2CzSKODx5pSbxvwnle7O4Oc0Sm8VtqavlR9aeArN2SLDEiHIVHeWKqp3PhsaxxoYyde5BEVCyCYZx64Mdfo8JwGEAiUssfPQyGhmOb9JriQ0/K64zL4wbeyZMK0juaZDaf3C5sVklUv2VmN57BUvfp+tyYpW1vhNGgXHih2mv56LB3WlOY+ej0FQ2ZsAENooHKKCHtadvO3Kwxv8Frv9tDKAJD/PUIW0zAXVegcr0ITvIvu3jF+2JJO+jNkHNhUJevYo91l3adpEk7XhBeBLPRm1hmpb0zc572XURDUNLxSDg19vGblkGcHXMaaUQmSiAv8IKvO0zLdibHqkQhWG8OOcVBi3UXE7qMkENbJWH
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


