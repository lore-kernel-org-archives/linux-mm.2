Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32B0CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080568E0012; Tue, 11 Nov 2025 03:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030468E0002; Tue, 11 Nov 2025 03:41:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88708E0012; Tue, 11 Nov 2025 03:41:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D72B18E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:41:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 958F01A0471
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:41:40 +0000 (UTC)
X-FDA: 84097682760.24.04020BF
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id D969714000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:41:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=m9R6mf51;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762850499;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jitbeNxbeSwoLaO1GW63OWcQzV6dbGiBbZYgEsubm2E=;
	b=0q6lszmXnrbIiypZ7Uq+8PacC16qvXjGKpLFimzZOtIgT4aIYLvfdAw7MOc28sj8VS0mkq
	Ra+LMfHfcyA/zjr0KQKM0NcGgrOiOYaeWtSVmBUo3SACs2lJhDeZ65GQ++Po1PisxW4hNj
	CXE7whO64F477iAxLGNDS+tapTbsbwo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=m9R6mf51;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762850499; a=rsa-sha256;
	cv=none;
	b=GqhvmSqo4xFW3GTns4F6ei4tH7ZzmrDsE+CzT43knsw6+P0VItRrn01FK1X92UvPmFjRa0
	iuw1ktZxZSvFEnnRRSbZUmCJVbtlufuGAqRD3vYCkPpMsF4zdhcOwtMN73OdqbW5rJ5jjS
	dhZ9t5GrveQZOLYLeBqYSVomxewQiIw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jitbeNxbeSwoLaO1GW63OWcQzV6dbGiBbZYgEsubm2E=; b=m9R6mf51Go0SgMCw1YQi0QXZgW
	EyEDA3mrdd+Xjdc8EP55fxHY3ZVHvcC31RtBHNSQgCsfzeNqTK9w+olpHpy/tnKKOSCqeAmKuScoa
	pUKqXnr7u4y83LLprUDaV/ArG4DF68auUhiUB4wwLmO2QrN5KiiHTdH9fQqTA1suUH2Rif7WKh3eW
	PTW4fB/8QQOLO7z3HjLqgHRpHJv1XOVsG3tWfys3RiZBnG8IDExyWgpw1jBjmd793ymisdgf4ev0H
	NHdpI95KjyuLQ84zGf8WP4io9nLiO0zNh8dHhtL5teHCf/5MSvrN/1a2rmWvfeTCk0AkwnKIHf6hu
	iv0AyxUg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHo-0000000Bx6h-0ucI;
	Tue, 11 Nov 2025 06:55:28 +0000
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
Subject: [PATCH v3 37/50] convert functionfs
Date: Tue, 11 Nov 2025 06:55:06 +0000
Message-ID: <20251111065520.2847791-38-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D969714000A
X-Stat-Signature: 8jpjhsm5if364bw7wu7ykwyig59pibdt
X-Rspam-User: 
X-HE-Tag: 1762850498-249813
X-HE-Meta: U2FsdGVkX1/wf+1c0V8r9oTRnkzrYVL6ic8KY+KfmaFnozypTU0o2A/2gu18czUwrhRpB9MSY1PKJnVGTl/8PhJdgPagY9cKiI5HfmuOFYGQqGjlc/DnGE0GycgWvuYOa5I4CXAcr3P0/ngtgNRu34DycOcy/v2/Gd/bmOn6XxfWLM+UiNC9PZ9Cnwu3Z9PRK0FBGq1FINwohuSZ33eEXMLE24IgOjFPdWtkMx3yCYVTAgMa/Adxav30RslhdiPzrMEKHtpQWC3gLalo+1JqYcYnwlxnLmeBCklFTIvCyw+qS9I7+d6CHdfSHMwPxg/v8nW6S9n3OTe5mUdNF6xLpaUeqkslyuNq26zN8a9CXgMPYSoMF6nU7r4pKgS+PCWueSGTA2lMPRk9TBrKP3AoqGP2Ao8xNOACFaDyG1gwDlLkgMX8Ut8bWKkTSgMPRreaYEgW1Kl8AjegOjWaF1njbcHFdnEGhctz/uGjl0CHprL+NQ7ct02R9miLz3hWKlLbl4D5fmRQLXKqrGYsvwYKsqfgfiSJE5FERDvBhza0EXfahjP7vdgh+W52ygrDAg4rNrm1M0hzq4EplgQeaIWzRoCU3yTl0pna2Oi4yoAsgrWaTPOOgYqw101rnqZsby0TPFLQ9MDzweqGM8cc879bYZrNvBI9l7kI6NdRdhqZu0LvwQKAe0IC5v9rKAWFDu9d7wRf2lLrvve+xaDgODBzsKVKAuSOpt8DbK/cvBlBgRaNd3bbXk/BBocfKk7RjAAwu4NFoFTsXwLqwjblNWG7KQTSrv5DTGcO6lxflJkxHgsx9ouHi2mgI+VJzSSaDZkqwoKLCr+cE1bhwK7c9S4xSeLR5W71y9jkITV4MV3n6s6s7l2bytc7KqS1NHxRfh0X3bVwDSQuM8WwJHKMzq+MPPTJQ2vSVSeapj6OySYKqosK0cH30JvOUw0Pi35Fkyvopgo/JF4RxZlSUxQQ/8s
 2BusjlBf
 gnB5ogMyvysleqWv30dGMdBWO9UmoS7gHsjDZOUsb7NIScjsLyljjpNpzA4Xduin4lKyPho07qqtZnCZc2kr96aLERJjQ3d2vUGXJUZa8IZdxKk3U/WjaF2C0D/uxoA2mY5drpkI5Z3R3j78q5dfH600Lvj1rBrSWzOlYq2LJDwgw7lS4gaaNxdqR1mr+ax7Mf//caij1H4pJkvSwMkHSpnMvscXsxHGdaGce0oR9BwqKR5Vp6u6kp0ccpcMBOMGW2eMH1AuXDJL6L8Fwfh2DRUTWBxzVBCKomMeih5MnX7z6IZsZFA8qJ7wJUAzsAW0hKs1D2ZhWI+AURY0di8HTgotuveFtf235aHYysYgnRcQ/LHlniG5G2pHnGd8MZxKWCS2qQ79pJ3L7zxL24GuFUO6OKimNCbIX7kgs
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


