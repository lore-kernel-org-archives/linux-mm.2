Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6343CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 08:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6CAB8E0005; Sat, 20 Sep 2025 04:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1DAE8E0002; Sat, 20 Sep 2025 04:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B788E0005; Sat, 20 Sep 2025 04:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B739F8E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:11:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BCC5C08C1
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:11:36 +0000 (UTC)
X-FDA: 83908909392.16.CDDE5B9
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id A6D5040007
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:11:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pD4mFh9B;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758355894;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2I7OUIWBFRscgYYRdCjjF8wTtyFfkGTFabZVJfLoxo=;
	b=BeBfKLbkffFRNtGDeHCo+6KoxsoRZqYfxwtdENuPdfelEqb1sEP/dfMgldxBsfyVEa3kDE
	bHp9KsLoGVBfGg8XG6peCoODFpgaqqxD6zFPYLbULKyoOqH1NJxYTeTDfezi9RhK7iHYVH
	rcqrZjeRuM7Pw2mmqHR0xZEOYueNDAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758355894; a=rsa-sha256;
	cv=none;
	b=7Q0Npl7/BfScQc0lBE66iGvmSgwp639YQ4SXHTOl4fMYVSm5acFlkDOb6mN8X0cwICk0aw
	DjCBaD1NZnUrPKEjaViaZ6GidCTUCLXVAIeaVus2QfnEtWr0//cIdBqWlZvR27VAJprokv
	kHSyqQmqnFBiLFmR6PAy9EJXMNaIlm0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pD4mFh9B;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=V2I7OUIWBFRscgYYRdCjjF8wTtyFfkGTFabZVJfLoxo=; b=pD4mFh9BRC1dnf7SHGUZrVB5mK
	DAk58StnHJnuz34FnQl1HvRD1TDl7iszbrHoYPbCnfwpkOZ4dMuc3AqXH1j+jPnxfvYbNcAbJJiFx
	VP36scCd152zIzcX4mPaDfgvAoAxZ3WA5qaNbw+gIMfly4BtzasSyDqP4MrJGi6QtPbNdRTPcMW81
	kvAFyxYkNsNfG8mtqR8OeIfZ5dE1tOHl9wEUBz4jlw2Yo1JdSpey0kK4JhBqHh+jzIVmrR63gbild
	iDbqrfLYFJj3lRworHvKrFPvSn+sxdmkiSFcU11T0z/7RsZ8F0nT8ANZ7dCoQE9nbuWzk2b9tC1Ld
	eidcKYJA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKH-0000000ExMv-23xH;
	Sat, 20 Sep 2025 07:48:09 +0000
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
Subject: [PATCH 35/39] convert gadgetfs
Date: Sat, 20 Sep 2025 08:47:54 +0100
Message-ID: <20250920074759.3564072-35-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6D5040007
X-Stat-Signature: ihhp9s9bpk3jzmeao16cerjigubptm5h
X-Rspam-User: 
X-HE-Tag: 1758355894-462881
X-HE-Meta: U2FsdGVkX1/9YFd4n3mqzU0usUqlZ+5tz97WDiop86hwx8e/0wP8oMrFG7EjuipMWa80+w1z4fq3Ha7oNdVxPqwGkIT+tNcGFdnjXJSnYllP4BH0T+UAq/TQLWcL4t/XFFtJ6eeWw7Hpglv2iPjuNgb2B2dZBSNkaGeZkbRXGcFNp8ODVdYB6X3VGiXRQG+ePdIMJKTbRraH8bcBJAsJg9ptqb2obWaKONJv4MC72KLtIV5BwbnCT3+uiduZYk7Cm2ThayjlLuPGo9T8aBsgoLjspfcedI32YM11kcqdVfzNXGupnE7O0IQPYAO2xBobuRyTfQX6obxvEDNQJRhMssHQRDlSwsklTVV+o1g36y++pcg8LJ08ED8+J7X6uVCkjQqFb8ebvPJRBHTEA7MQMxhJ1Ey9sX1f2Ll1HM5QFTy1hYHybGf1cNzQ7/8ZeeX8H5dR/4w2Qh2o1eL/r8IaebbykiADUKKNjnWBby1sH7e1twMLarMX+6jZ5FiaNtBfjbbOyZIYeiiLgRbLhEeBrWvkEiO97MvXALuJCKCyQt5+JePHjh5QHA1AmiK+s9XPRJpcMeAcZq4xD9lII9W+LhY9wqeRUagLk9JMBUeyZOLbsKnA2hdGFgAs83nfBsqdavvBIgSNe5OmvWoojTDUaxDCIpEKku0fxjTwogRek0zKuD4jIZMrS5DF9aRNM9jMDzq2q9lxZ2hO1B172HqnziYo2FwkyIJftVHjzi5rxCTR0GAb/YZfqS9HurQjyV7x5jHir0AXZTs67RBpFTcyDK2lbESJ8DP7Xqem8HdUrfWgkFod+6kLjjynbadcFEKVhPMu14V1af9lktIsV/EAAxqwjgDv9QtWYvUyQK8mqsKANslTuItqe/x0qHSAJlcQ/gdY7h4dm8Akqsc3Lvd0AEi58KSgmMM5UvmbHPeLnNSvAhvDQNt9GdzDzIPwoF44csSK5z8F+N0LKNKLwak
 QCHXl/6F
 cbhIXTkJHSyD8pRa3UpkQW4chiUAXVTdUdIbWpnXkRf+w51TwBPYxlNGLA36pPdvKkvW1Vb10Uv1F9NY6fu24BtVz2GvjapCPWqyUzyL9KLu54yi56OUUkQ9dfFfnvEKsc5suW3nT6/jMClho6Zzo7EVTD77ScxMiJQoZ0NGO7j7yv2GKqm9tvrlLZE6f43S/lrB0CqbuiA7FffpMbnG9Bf+X6HWzgcA6Q6dYipLf2ITl4yQ40I80rVEUSgNCpdHLQPyLexR+ce0UdBd6+hRdsVdntIGoay2J/xxdelGNyST1L+FmenHhcw3zqm6OqKpI0n8txmKKGdY3OI79BpyJUGHjaGRCrnInZAyskCv9NAhJsCEv9ZVp73prWgGrjQEl97W7dljW6V2KZdaBLasAQlSs9+GSPfN+rBPh
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
index fcc5f5455625..6b7adf153407 100644
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


