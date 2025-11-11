Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE35CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE118E000D; Tue, 11 Nov 2025 03:41:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97ED58E0002; Tue, 11 Nov 2025 03:41:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BBFC8E000D; Tue, 11 Nov 2025 03:41:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF2D8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:41:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E866559105
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:41:37 +0000 (UTC)
X-FDA: 84097682634.06.2B26EF5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 32C1F1C000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:41:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=NvA4L2Zw;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762850496; a=rsa-sha256;
	cv=none;
	b=LvXu5u34oXMejusWKHjLlYx/9WL1fdnoAZaNKtm0mqUbnQ2ClXrK8ynWhljN8KL4mzADiR
	EuMKVdSnM1aiuPt/t5tYhxaolgLE+AdbL5K+EOwRKwg5LU/h66u26ZV4hshniKdryauDnv
	XFZcW4WJIT//lglAcbMkjKbaecLFsWs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=NvA4L2Zw;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762850496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjlhtDhBu18/9JmgPyyx9lDuBAywfgEoPZuaBcmvHHc=;
	b=EDiDEsKwAV7yF4IXQTZBRLdA8R9ysjinu7ZuzhCfZdaJDMLCfqZX+vhYO6un4rKf+gGgNo
	XxNwWF87bbAtBobxgoqLnozIc+zTJdTT7ZLBcb1/dq76JwpShKRbjNiK8tUbA9FqrYr425
	i7CLgl4sXSGmUTHtPt+ZTTFiyHFgPyg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KjlhtDhBu18/9JmgPyyx9lDuBAywfgEoPZuaBcmvHHc=; b=NvA4L2ZwRtUeHW7QuJvY2SyLmK
	RV8qnqzYay1FuvT3UE6H/54cBzg4DqPMeUKeJSdgeNeO9GmXF94fsND+sL+kHe2P/SEz/SzruMejC
	KC+vAFArMaR4Ab2WBlEhCiNphiaWVR/RSO1HFienvay3iqhf5PaLC0KcKeuFjdEvwYxidZN7ylSeZ
	lHhRmrqaTzX2ctZFOtAQ1ASzsxi923LvOSaksum1niBBc/aXEOfT7i9Xr+cAzQAQKVr+JuHbRn34K
	18XCZshuF9YyNevfgXnWMq6+t6aQK9xTZjd7wkgoorB+bOwQIMSp4onK30UsLV5x8ND5Wb5eqKLft
	Y3mHOsnQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHh-0000000Bwv2-34MT;
	Tue, 11 Nov 2025 06:55:21 +0000
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
Subject: [PATCH v3 03/50] new helper: simple_remove_by_name()
Date: Tue, 11 Nov 2025 06:54:32 +0000
Message-ID: <20251111065520.2847791-4-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 32C1F1C000E
X-Stat-Signature: mftfxu4ya9jbmxpn1f7yio1bq1kbttyk
X-Rspam-User: 
X-HE-Tag: 1762850495-48367
X-HE-Meta: U2FsdGVkX19MuTaKWWGd1wiD2w3F5yX0CitaUY1BvhASG0lHDRKlF2zQ1wWwwsWyTGBRVxVaw4E7WPJZFPJ6bkong0iAgJiulWXAcBTF70rwN4d+sTQCcLHaPtWNZDxez5zXYfg/RyS4v9sGuPY+77kClmUSZGNJq9fUBSzEdIGK/YCxwg7iL2LVL7VXJXBOnnpR+laGCNNO9aXmFhTN2wb0kWIZaGTL1t+fjYfja+LWoUfA0R8Ve1BwXG/LeCc0e8iGMW3OYm68Vkopxv+H91PgoAiy3XX205H9GJTTP0MK7YGRoeMUpl/QJt9tkRMGbqRvcCZfL28t3IwauIH7hzLmPgIuvbAKDcLtaGEZRFnyOZ9y86fnpmwcOhQJfmXexpK1osi2z+7890tkul0aIo+b3S5tt1VijwE+0xTQzmNESrarParUwg0KDnZFJBYP5Nkag6Mmitz/fRy2iHeSkEUksSdR+9Ea2npNcNx0cgt79rVk5rsEj1QnzRusgvtJx7AslytW0RUXLewYFkLSJRcFhcohbiEvKlO4qAB6OEBi2p0Aya6bkxaRqf4LAIfgDrJTSHjq9PBm97UFjRTUKcoNaBhblwzCQ4bPBBX2q0IFM48bj8CGwH3GlZb/PRa4Z+vzijyGzA/FvC2Abc/j1Y3mqtSF4fKlwDcOxhIzrS26K+2/Fs8sUgEpXzrWhS8MD2kLgjjItoA07l/BT1plm9qcm0ISDWmHF/vgohRbvziUaYLOp5Lw0IsgWEIvxVDJ85ZURibOeyVRD4F+hypPtJNylSaU6NWdOGR+My+Hh+0XwKepqwS+rqbnZvieqJ0N6RmImGkUGtIulMjMOjHFCIdAq8PTGsdgpIqdWVLlFUUZypAsNjN37Mp2GPKKRtAUoEf/oRA02bowLNWzqHyI6edKteZX13okQfdPQdNL7Kwmc1/9CjZp0AEQH2SZEyXQBk8V7DDqh+h4/pqRrZ/
 D1nxgu2+
 hQZaJhFX1Br+fiRJzHhoXRCBp2d/kokvx9kIqbFry6ctAEzihJMOges5F8KJGF6Bw5VbwKvGBv7hq6RmK4W3bsTXXHhgl06vnMMxnXGaCOuAuJaYx4A1jAuY8lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

simple_recursive_removal(), but instead of victim dentry it takes
parent + name.

Used to be open-coded in fs/fuse/control.c, but there's no need to expose
the guts of that thing there and there are other potential users, so
let's lift it into libfs...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/control.c  |  7 +------
 fs/libfs.c         | 13 +++++++++++++
 include/linux/fs.h |  2 ++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 5247df896c5d..3dca752127ff 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -290,18 +290,13 @@ static void remove_one(struct dentry *dentry)
  */
 void fuse_ctl_remove_conn(struct fuse_conn *fc)
 {
-	struct dentry *dentry;
 	char name[32];
 
 	if (!fuse_control_sb || fc->no_control)
 		return;
 
 	sprintf(name, "%u", fc->dev);
-	dentry = lookup_noperm_positive_unlocked(&QSTR(name), fuse_control_sb->s_root);
-	if (!IS_ERR(dentry)) {
-		simple_recursive_removal(dentry, remove_one);
-		dput(dentry);	// paired with lookup_noperm_positive_unlocked()
-	}
+	simple_remove_by_name(fuse_control_sb->s_root, name, remove_one);
 }
 
 static int fuse_ctl_fill_super(struct super_block *sb, struct fs_context *fsc)
diff --git a/fs/libfs.c b/fs/libfs.c
index ce8c496a6940..d029aff41f66 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -655,6 +655,19 @@ void simple_recursive_removal(struct dentry *dentry,
 }
 EXPORT_SYMBOL(simple_recursive_removal);
 
+void simple_remove_by_name(struct dentry *parent, const char *name,
+                           void (*callback)(struct dentry *))
+{
+	struct dentry *dentry;
+
+	dentry = lookup_noperm_positive_unlocked(&QSTR(name), parent);
+	if (!IS_ERR(dentry)) {
+		simple_recursive_removal(dentry, callback);
+		dput(dentry);	// paired with lookup_noperm_positive_unlocked()
+	}
+}
+EXPORT_SYMBOL(simple_remove_by_name);
+
 /* caller holds parent directory with I_MUTEX_PARENT */
 void locked_recursive_removal(struct dentry *dentry,
                               void (*callback)(struct dentry *))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..28bd4e8d3892 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3631,6 +3631,8 @@ extern int simple_rename(struct mnt_idmap *, struct inode *,
 			 unsigned int);
 extern void simple_recursive_removal(struct dentry *,
                               void (*callback)(struct dentry *));
+extern void simple_remove_by_name(struct dentry *, const char *,
+                              void (*callback)(struct dentry *));
 extern void locked_recursive_removal(struct dentry *,
                               void (*callback)(struct dentry *));
 extern int noop_fsync(struct file *, loff_t, loff_t, int);
-- 
2.47.3


