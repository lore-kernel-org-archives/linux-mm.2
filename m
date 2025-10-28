Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F44ECCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918F5800E0; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6829C800EE; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4112C800EF; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF67800DC
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA33EC02E5
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.12.123F247
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 067A740009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=P4uEkjCT;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jitbeNxbeSwoLaO1GW63OWcQzV6dbGiBbZYgEsubm2E=;
	b=OsZHNRF0yCWjF45Q2Uc6kkguLu/ALQq7zlL/wse2uA5vJm5yu5tDMT0gVcwfXFGYbYjo5i
	C6xjhXeYHDdYqRjW0L+1FPw+LE+Z0fYhXId4lItVLUT5Mt7cUCcytTSlniE67gCIr33LIq
	aYMZIm1KlzCZu4kEiT4DgOL5bydC3Y0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=nn1X3hoF/Fk/IlfOG7crQJdLNu8MfsBMhffadijHDVQKefZWZdWfD6yy0Kq0UdT9KZNZae
	cGI9Q+wDdvPunIBBdXE9tY2bZ0RnmGk/rUYI0uljC4iIH+NpIQ84iNAL9wcNK9s99+5qog
	vjc54QLNENRFptztpyNRcT41A42IOHc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=P4uEkjCT;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jitbeNxbeSwoLaO1GW63OWcQzV6dbGiBbZYgEsubm2E=; b=P4uEkjCTyL5ky5sZuR9OWttzb8
	1WtjZySwgxMTOcsO7EyFM7ZrpbjLhPZh0/78fq0J85noTRo5K8kWF/mqs5yb4MtcIp7z2n+aiswPd
	Ssf/yomfHA948L+cP6ZFIoyR1+vWABiYhVf09H1r6RK/sHW+2RTgXLyozkRpSuMh4UrlfYf8sU2xz
	jMLlebGiKMxkEFDtaIROIwKwoRwHo4WQDHCkAQHg16PefzizyjJsrDUNQ77jsaGjTfTUsAgQjkTJK
	uTsiOAaQkUWFVytdKTeLnEiwQSNLq4tpx+egccTvh6J5riM3747P1/+F+Q1be+liNveZ6MHjcFaRw
	1U1qDhYA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001eaj-2ITx;
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
Subject: [PATCH v2 37/50] convert functionfs
Date: Tue, 28 Oct 2025 00:45:56 +0000
Message-ID: <20251028004614.393374-38-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: djonjg3gmpzttd5gek1z8mw15fepyc6u
X-Rspam-User: 
X-Rspamd-Queue-Id: 067A740009
X-HE-Tag: 1761612383-197346
X-HE-Meta: U2FsdGVkX18fuKIbtsCXXDG7RA2wQX7u3P+Wb9hm9zPw7wcwLo48wXRdbrcUJPsw2oR/kBQt9xWPR52SEcHxl8uCO0ulCy2g5QGQvO6IKIcbiqYXMP4Xu5UDeFYUzasQyPsBGhFSJu1ua4ywJyYD0xjpGJGF5NsBlAk+qqx99INLYDcEupzTgy1GfL19B3XE2ansXWYsnDc7xYLO+OZkLm9Qh2rvSXJC8ilDYmT6PBz0lKexkab41BjIxR7vZ2TvgiKNs4/zT7l1xohKbMZQTbdiMUdvIQUnXw/Z/0OaslmbFZl+kgBP7XC3XimY1uNvw9CSUEOjYgzwKdmJA21vK75XrkTl2hcTLFp4cL6f7NnV8qpEiB2zBTyJ5NaWXB8tl7yH6LBzSE0z4bAcAiZJqsF7G08u+n16OAC/9Yvu3NDr0+S8J3BQhi2bN4mtiFDTAa4Wps62BVuKBhhAgCjW9P7c20Jcy7rYvvNPXQzYlssIeTXbQ7V3CLrOTW9tC/z3jDt3SNdcjXgPpeXJhUTZXrUSfwT7aEYBrm9sTIgthUvM3UrUtlhjvbOqGHF0ImzzbHHaTryiC8UyHT3Q9FCrl0cOj09HN29yLvwE0ctq3NHU01aGKGoWikcAEnxGRTJQ4rABYZN1m24+kHJ+kjlKNv40OJg/zeg6nMrL3mRKwReCsVZv/47zLlnlNfrzbApDD5iz7+n0KyzSPyKASAsTr2jeGWrhimqZ/A51TsJmgcl0J+BngSKNsMNaEmH9ppO6os1vzwtPFbZtQiXlo8+6fCL9QA0tNxhYjIay+r+7WdEOYi78kuXA9Zo0WVrACgXbu+cTAYaesv4o5MkqopZZKhhgyCPee3uehPhCaslFdkQu5lBKSSZnnCICiAYhDpPdE+YuBz656AStumgI0Go4BOGSn3jIp1pAm6q4we7YNZp8bZEeTqfsU6MKNNfU0OCfG/ZuqCGdMmKZbEDD19r
 ydn2J5Qz
 fixZHLB+iOn6GX6lAfuqJeooqDqP2TtaKdjdSDjzACs1A73wtE3xo2dKBbfgWhLqIn3LBcBqty82Br4M5az0jEjO+rtsPAhZdkjUtXzxoaAs0m6pDE1m5h/atkbkSSRIQbmnQbWVwToASsTu7BdsN2jPFM6N/HgweL1cDWU5NqnnmHPST1kTJnCiGGKiqifpAyF4/3y46/asmd1p6Fqi2g3h/YrbcoFjyYGa/3AcMbrN8IslX//VgpR4k6hz+sNwNY2ngqZ8RNMOyXJ+47w4XIUYTlrU52xkfvsF52q4XrDO3spk7M939J1xXh3zByaI2XSJAK9bFlSH24if9UxjIM+LQnaENzmbn8MaRTEfCPKPHP25iZW+z0J4EyhyXEECP6JmmMByZmQX756sd05mk9g7WaGzontSPkUGM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All files are regular; ep0 is there all along, other ep* may appear
and go away during the filesystem lifetime; all of those are guaranteed
to be gone by the time we umount it.

Object creation is in ffs_sb_create_file(), removals - at ->kill_sb()
time (for ep0) or by simple_remove_by_name() from ffs_epfiles_destroy()
(for the rest of them).

Switch ffs_sb_create_file() to simple_start_creating()/d_make_persistent()/
simple_done_creating() and that's it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 43dcd39b76c5..8b27414a424e 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1870,17 +1870,18 @@ static int ffs_sb_create_file(struct super_block *sb, const char *name,
 	struct dentry	*dentry;
 	struct inode	*inode;
 
-	dentry = d_alloc_name(sb->s_root, name);
-	if (!dentry)
-		return -ENOMEM;
-
 	inode = ffs_sb_make_inode(sb, data, fops, NULL, &ffs->file_perms);
-	if (!inode) {
-		dput(dentry);
+	if (!inode)
 		return -ENOMEM;
+	dentry = simple_start_creating(sb->s_root, name);
+	if (IS_ERR(dentry)) {
+		iput(inode);
+		return PTR_ERR(dentry);
 	}
 
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+
+	simple_done_creating(dentry);
 	return 0;
 }
 
@@ -2067,7 +2068,7 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 static void
 ffs_fs_kill_sb(struct super_block *sb)
 {
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	if (sb->s_fs_info)
 		ffs_data_closed(sb->s_fs_info);
 }
-- 
2.47.3


