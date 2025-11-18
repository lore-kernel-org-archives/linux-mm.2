Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18BCCED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FCF8E003C; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE778E0033; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA118E0033; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38C888E002C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9759589BD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.16.5EEA93F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id ECB5B1C0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gGHivrs5;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BK+HD9eFsxlpB9DT0f/M/+bf/xKzOtOP84IbBFRjnBU=;
	b=ieH3D/QSxG2ezMXZMd5PlqwqnEDf517OUNBIYskPBfgW3VhyFCHVIzthMAZNKlOGNnaHyG
	qrya+nLn26VCBF3cPh/3fhb018WgFlQbHjvJmgbNaRN73yXdgku0l3dnR3jmlrL17j+78b
	en/nH4r/UYg1E/OazRTLyHC2xaVG45g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=tyFTVWqzcPWwX7HVOgSmck7KTip4/0RcHYA0nbKd+IyQW1BgDyFeB8DRt2dVAPRvNwqKDg
	M82vD4vLiOEbgY1tHjnPFDhnRSyNBJnncQGIdpO9Y167aPUBsysJLlo7P3Wd2NKYnK6hRT
	RyKLTAR8LbdkbSA+lBOR30OZf3jnhXc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gGHivrs5;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BK+HD9eFsxlpB9DT0f/M/+bf/xKzOtOP84IbBFRjnBU=; b=gGHivrs5VQYbp4P2WHM7xvl1vI
	ax4AH360oXnMEt1pRtc4JNx9Mxj27G7Ntlw1mm2vR1YKwsbAJ7BIDIj7eFRTT5DnvK8JCUY03Da8N
	fSZOXX/fBbd9LVbSGFm1KbrbLVwJmrOCLc3+6IQCZPiNgcegz18/qFCXOQsbpNt3DjC7U07vYtsPs
	9Rhmie54jINi8XG2EuV19IWK3Ct6nuMbf1bu4GhYd7sCTgGxsorbv2ahk2JRFthbRoeXfeiF8W2c5
	DoQk1Kfd0U8wa560MOaJXOVqC5lEJpoM0utWOPXCu1ozCSlbpkmyZddLcoFla63XBFJB319IxTbwC
	cWQnABmg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4T-0000000GEPd-0X8R;
	Tue, 18 Nov 2025 05:16:05 +0000
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
Subject: [PATCH v4 01/54] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
Date: Tue, 18 Nov 2025 05:15:10 +0000
Message-ID: <20251118051604.3868588-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ECB5B1C0005
X-Stat-Signature: m9be14ywcmhrpuzrb4hkcutefirdxbdc
X-Rspam-User: 
X-HE-Tag: 1763442973-255533
X-HE-Meta: U2FsdGVkX18CW1kifyZe+WGOkQEafxQl7lyopm/HivtUP8AUL9kwLyrrciHADKAO3OazqTTH/Q2eHbVybXeLeaxXGOdWAhXpK7xAMswGollyIXZaCam7iGiYWZuMfvfKhcCg2mRteuFfhIV9JDe6WrTpssSV/EpID9qBfPfuJMDKQQVk+vCCqr8UYB7V+TSqe1I0W+yMmNPF6r6qv1H+s8YdYaw6vTdivNxea+TDLPrZauhyaZFwaXWf+zf/q0KN5dymyyPJAOxNLILY+5vbUM301gpRJMiS6E66bu8fq8Z0H3NtcPpTsxoKoazeT5HZiJXgBxjm3L0d7Lx+KGT88XAKXHzAkBbl3aFsCRy4EYjng06zuSrtVI43CjFygs/mlcu9Y4IAmpiH5D3Q1jJR6GrAsZsrdEXJtz+WiXsyLTcRu5h8bkVog/M2rl9Le/p2LM0iRidAykaFLXPRtTt+MCfEESPXPDEDQ9myUztgpCK5mpRxYvZzYkTtx/PXZXee/ZyhPSNs60ZLcRbgF1HBxKcdvFf5MfXuJEQ1nRtC/nvsoF9m6i1+yCYbRQoOLg/qPCeReFZnEgCsXvQh8Bnk5NxMFPV6qyWqEyCDL0/0ySUDJJfecAapbG/lqEdN5EMMW0Owck5ja0XfnM61vScfYs85zKcQMRRTAuRNOtXel54CN9BpaT1+udc2265UFDVIkmqBBgNruGxeIZJD7A7GX2aXMU3GKgScV0Zwdewza3947EE2vcQX5yTpLW8RStMxTr50zSjztFTs4EJq4V8p3oRuQb9pYooTzlj3msykDTuSEcozhlzisxDBg0vaMtawerVxhznk98zR7+fPPL4lxyCHNcmoGUm9wKZaombnBum81uIsB/F+fRepQi+wWdK1v6vMPPPU/Jc0uxtS8waDljsh6wpcF/aqDo46W/WXRewj6UzwKdQO83aqBihtX9cKWNtVuNa6m/w5DlhQeHO
 +KNtn4L9
 PyEb2oPmlmLfj6XLrXifPn9aM7uQTS/B1ECMUWFgUa1vw7zsCMF2xzzkxUsuPa8G68dPjzZ8V6xqLPaO2M8AOQPgApjz1Uc6OCs0qx5dsUSOEJJQcG7kSeAaG2Au2oXukzfOpjFcosJgORlsCLTLQIKIdtG9PVtyqWhunHnZkrQaVClbooK8aKiVi67cIo/bgtXkAMB2auPzlHNSV/jP2zs68QInaJhJgMOy+Fey5KfNm1BG+tvT++BUzWjFtLkWfwW5WKjgKseI58G8Rlz6lJ5ICPD8JOBjHtIh0sx/w6RITJ8GigdbvIXkcaSbR3J2lajOnlyedGf6ov0TssCHEmC5XirHzksY1owZQUm+tUbrv5GCVGaT7brhgsUJYdc+Oc6P2Ye9v10Glh5kx4Z9iBkiIw4mHO5yRaOP6qUEa1unsuFo/JvQxkGq8nhoQzBzb0AkV+kwCRuXefyQMhCrhc7fByuhJLrxICjgUYmuli7CP9pY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fuse_ctl_remove_conn() used to decrement the link count of root
manually; that got subsumed by simple_recursive_removal(), but
in case when subdirectory creation has failed the latter won't
get called.

Just move the modification of parent's link count into
fuse_ctl_add_dentry() to keep the things simple.  Allows to
get rid of the nlink argument as well...

Fixes: fcaac5b42768 "fuse_ctl: use simple_recursive_removal()"
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/control.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index bb407705603c..5247df896c5d 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -205,8 +205,7 @@ static const struct file_operations fuse_conn_congestion_threshold_ops = {
 
 static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 					  struct fuse_conn *fc,
-					  const char *name,
-					  int mode, int nlink,
+					  const char *name, int mode,
 					  const struct inode_operations *iop,
 					  const struct file_operations *fop)
 {
@@ -232,7 +231,10 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 	if (iop)
 		inode->i_op = iop;
 	inode->i_fop = fop;
-	set_nlink(inode, nlink);
+	if (S_ISDIR(mode)) {
+		inc_nlink(d_inode(parent));
+		inc_nlink(inode);
+	}
 	inode->i_private = fc;
 	d_add(dentry, inode);
 
@@ -252,22 +254,21 @@ int fuse_ctl_add_conn(struct fuse_conn *fc)
 		return 0;
 
 	parent = fuse_control_sb->s_root;
-	inc_nlink(d_inode(parent));
 	sprintf(name, "%u", fc->dev);
-	parent = fuse_ctl_add_dentry(parent, fc, name, S_IFDIR | 0500, 2,
+	parent = fuse_ctl_add_dentry(parent, fc, name, S_IFDIR | 0500,
 				     &simple_dir_inode_operations,
 				     &simple_dir_operations);
 	if (!parent)
 		goto err;
 
-	if (!fuse_ctl_add_dentry(parent, fc, "waiting", S_IFREG | 0400, 1,
+	if (!fuse_ctl_add_dentry(parent, fc, "waiting", S_IFREG | 0400,
 				 NULL, &fuse_ctl_waiting_ops) ||
-	    !fuse_ctl_add_dentry(parent, fc, "abort", S_IFREG | 0200, 1,
+	    !fuse_ctl_add_dentry(parent, fc, "abort", S_IFREG | 0200,
 				 NULL, &fuse_ctl_abort_ops) ||
 	    !fuse_ctl_add_dentry(parent, fc, "max_background", S_IFREG | 0600,
-				 1, NULL, &fuse_conn_max_background_ops) ||
+				 NULL, &fuse_conn_max_background_ops) ||
 	    !fuse_ctl_add_dentry(parent, fc, "congestion_threshold",
-				 S_IFREG | 0600, 1, NULL,
+				 S_IFREG | 0600, NULL,
 				 &fuse_conn_congestion_threshold_ops))
 		goto err;
 
-- 
2.47.3


