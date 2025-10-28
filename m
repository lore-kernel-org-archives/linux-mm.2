Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F90CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7C2800DF; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B69800EA; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC61B800E4; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 168A9800EA
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4E1D5848A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.14.9F32565
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id E9FF7140006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=phZVBEpG;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjlhtDhBu18/9JmgPyyx9lDuBAywfgEoPZuaBcmvHHc=;
	b=i+girZ6ZBlhRpp5Usi/lkyYvdK8+2zKthiJIyTQkwccmv2AXC1ZfgVBBg1H3SeHNNgEUZm
	saOG+/+SJIKr+dNNp2bFXKBAXyOlgys0ooB9pkoA3ImcLiPmT3zpUDJz9vsNhULHvKZBiE
	jUg5xV8ApwXKtPmYthgExrCkDVQNjnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=Mpga9RdJOs+6hdZpx8jGNWStlDijidYNot1D/VFaMtE8WhRSV5V9ngBpJn05/Prx65QhCZ
	KpcooJyvr6YTNqQK0VHS00wlbaRKI8JFs0EreJXx+snDii821RuC95oMfuigMet+BfwkdB
	85ZBYcz4BEjE9JJoFQdJQF+61tvRZiI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=phZVBEpG;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KjlhtDhBu18/9JmgPyyx9lDuBAywfgEoPZuaBcmvHHc=; b=phZVBEpGiYICQyEE9X/keIVY/a
	CmhYmQ8VOyIHYl2COlyCH2bMlcgZVwhskAuU0zEBihISwgQZ3Xdms6rzKWduPKsZZwouTfNOJq2v7
	mk2ZsgZ9vYND+utkyglLqPp0K8aN2Tdltcu7EHR3T1qKuMd/wfSEFNStRKKAFMJEffwJTNPuRJObb
	YYwNC3ZZnpcS9MHYSijdehjaE6XcuRtB7a4FmWUjpYSK5Wb0TVn2YxvyaJ0cepqq7f0eN2+qseEWm
	4aqpOM+SJDuyH4b/awxgssyJShv1mo9PTSWTfbzphmTK1Np0FCjREro3MHoYhRL3vjHNu5a33bLvJ
	ylojuCcg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqo-00000001eVf-3zhD;
	Tue, 28 Oct 2025 00:46:14 +0000
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
Subject: [PATCH v2 03/50] new helper: simple_remove_by_name()
Date: Tue, 28 Oct 2025 00:45:22 +0000
Message-ID: <20251028004614.393374-4-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: hp1ue4uzd1rof1mcpymqs1p85p9np3nh
X-Rspam-User: 
X-Rspamd-Queue-Id: E9FF7140006
X-HE-Tag: 1761612383-833006
X-HE-Meta: U2FsdGVkX18NP8qMoyl1THrznREBt3V4KpGUWr7v9o9BFeWCJ9l3cYZRiEIIe0TjhpY/fos3egb+YmmFr1fNYDwusN0XQezSZxIyszMa6HNO973Bs0hkURzY38r78ogElCyee7vtiVqy1zTzKyyFj2RIhCOlOXJLrgiZW5/H5zllbroD55FkZhDMoPT3BJ1PpskHcynluP/LJOcCqgSEZPGVPkE8nvZxgAgj4hqikVQPpSXB/x+WKw3BpmNZoDWUOeQEyeARAisRtIwLbrHf9e0ZGvdZBTlkv+oxS0cb9lpWMDINGwJkOONB6BTg9EBoGkwkX/JEc6hH2kNJNB8FrlSuiRCzvr7JDxxe+XulLK0PAjemPVwbfAJ4bO6s15xwAYo3R60UNN8u9aAdvI//wuBOj45E0BLFpqYM+IxBDV5HLVtJ1E/MmzbbHH5HZPMexDUerUXA3JokbpFfX9YwAWaaMKreAuU/301kkObYt3IsCgqm/dLJBI3X2ApbB2PvbreSW1xy53c540PKYUeVjSlFVrhXS29MKZDE8DTs1SWPViQcKz0YrCn0Z1lEnnEWR8jCTDyCE+kwqxycryohyAyBXyFYgL/WjdtarlHZoRGfPAi6D/WZLdS/En6MGn6Bmi/+DE2rdggpVt2mIxlS+pB8d8txJ9NvwSbPF4nRaypp+Sfhd5oloZHucvcSgRGv2RrL1QdnrzS7OJtrz96xUePyc8vaoFnhmE00MIzoCspN4AeASe6FGzs7WwsILhXqaWW5e5cG1uBqJhSGStD2+q2C3Ph3xZKX1O34c20TC6zRAVT0f+PVb5gBrFMUyCzRAEwASHtoMU5WTX49KiiInMQqYI7wYWIll/gzM63+rOuhR6OYZuhzcyTcuNrUJkQMgrP3AIVHAMskPKH0zX7OVOxfh66xUOscuSVGs3Ov+lmns3h6fpH/AVcQHa+FJwiXgsag3RFGh5yCKbRnVmH
 jQN4YbBs
 KXfEN1j6bzDaSpgGU5yKeVdaTM05hVpSCVhZGNSlRfpwZ52nlULvFD/Vz7A4y2oy5TVXAtxhScDsYEFux4iZ6J6vYIM/bchtxfiPG16SV/riVwst45MJDz7LP8H/YDbLNAZH+DB0Gisoad8eNjErmvpi1ORJ+MJrf5OxMTy6WZwnGKEIiVJa7/ekbzuJ1uHZ6hJGNAUs4RK3ywSQ1CuTW2dZiJx1Fg2r3gYJI1GA4xxB99vWPQ/7L3fjZ4sovakGJLqeZAVhcc+0cPEB6sXdfC9m0/mWl9jTFILyHGVMMWw6j6YilFiRW/u1g4hk5ePf0KFBqqGvEWxD+sQkdOwEzbZNalMcvms2ju5lZvSwif75474kGCTy45hGAcSkc4meMYEHeVvQVY4Oi3JLe4QdG8jzcIuEXKmdMxghotrRCenEM+L0KvZtgFBQNS+4G0HArOou4MZg1IDSXnGMRToCl8QGsr+9tl/AmHcKUHJf9tRrNbYHt5lNRKOw4QA==
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


