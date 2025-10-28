Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27A6CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 04:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3717380111; Tue, 28 Oct 2025 00:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34901800E4; Tue, 28 Oct 2025 00:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285AD80111; Tue, 28 Oct 2025 00:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17C12800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:31:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D225F58B8E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:31:36 +0000 (UTC)
X-FDA: 84046249392.12.975563E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 310B840013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:31:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=aKgSFnQ7;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761625895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lB/gWST5s3/zNGGpGrNmQn0s9XjLn6XUo6NFB74HdeU=;
	b=GIbdtiods7DtH24f0Z0OFl600XLcfEMkLXKYWXWrxq8qS+a0OZQ34xoZ5vvBOo523kp5BV
	Izpr8/OvG/c7PXZs0SALGnSkWbmL4wrDxYrPaphV+7v7t9Tm+rcjRXvTzRSNu0DiwB8iK+
	DN3Ck/F3v5evGMBAVuJ+YviaDSCIiV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761625895; a=rsa-sha256;
	cv=none;
	b=nkeyNTYa6zo68FJETqEkyHxpBrvYn22s3H9lsLJiqDAm6hYt9Eh9+ePEcvKtm/gfnqHnJD
	EwJ+gtDzZDib9bppBZkYmBig1SaYNLd1imgbekq2MyJCCdqm2LaJqSFmgIYNHjel6nE/LW
	1mUg7KGtwRsw4fRRjm0ZPL8u2pcUhBM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=aKgSFnQ7;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lB/gWST5s3/zNGGpGrNmQn0s9XjLn6XUo6NFB74HdeU=; b=aKgSFnQ7mHktGBue0g6K+6EkEx
	yPg6jNB6IfrQN7c7y3GiGDy5JsQdbHtLLZ/ufzdbXOCN9tTFeVhTjTGOwj6jdMpJCS71rbdGsPtXF
	J5nHuKHf+YgcMl4M66XhcKyzBYwOMtSzA1J11SZ6Lnqjmha93MLi8gO41C4Ter4l0KitdQddDJRBO
	MGUC4OuBSMpxJrDWeMkiRHDL9WsOgze/x2VJpc02QZxCicwPS8vC5ffbzQSj2+SkGTWSzqgS+q3XT
	SMuQd3Y9kNLfqB0SJxG6lTsh80Dzk6o88SdjtaIQJwj8ZK/euoyNbvzdy/JPPv6ssrRCYlJDP9vPj
	S99jIZlQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqo-00000001eVB-2uqQ;
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
Subject: [PATCH v2 01/50] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
Date: Tue, 28 Oct 2025 00:45:20 +0000
Message-ID: <20251028004614.393374-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 66fiyasqn3jppkunyp6a1ien5yaqnq3p
X-Rspam-User: 
X-Rspamd-Queue-Id: 310B840013
X-HE-Tag: 1761625894-544726
X-HE-Meta: U2FsdGVkX1+S4ZJWADFuIzOzn++wr0CiSgpQXRDbtpyfAjr08KBxmNuRC/OXF6Qr4JRTaq1DwYGL01TF0HSVNxm+bvDnb67JOGYDiZOea0WkuV6YxirRGuHXi/NLm/U5V4fB7kxlWd0PfVn/u22bIIoXUf4NFw5NjjA5tRnKq4rhkUniWDUC0eRKCNpSzbclpWylkKBcJAnD55DRIFsfWiMXOFi663HRUKh81HiQv0RRG2ituEmTuAxkH3lRVkTEgy1WOazo5yDYsYSDdG5uF002Nz15B42xprbYXIHRb1aRhnJvQEZGk/VchizF7bh+HMCp5H86JqftNtrfo6hyjDdgwRTzLb4DecLtAC4oUdaD/Ep6MxrIjtlvy31OPmJADZGq2aNXbagf5iWsCMo3uKsT2PQotxs9VO/qAed7HWrh0DRAfwtNFt5+FmODLgbcet0SC1PkvMeLWxzHm/EpUUOCgNf5VM+wuqCbGzfE5Gpf7l7zABwIjv2dDRpcM9ufrt/CFyUNXmcqf1toUGaLIhlJl5sN1MV+6YBidr5yTFaU1Atg3wjKtuOMKY43AwsPL0L/cd0QfweAgro4SOjWPnbyfgu0MSy/yM9Pz5crrT7PXR9chq5xp5Broai2SPAEllkD0oyHFUh16SPR8Hg9p4o3NEReUFGrolHdVHAQxFET5cJs0Zbx3LqYpMNdmuiZ6MVuYN4oPiQB8w3TsoWE2TQysRtbUPROPpmUk1J5FnA0HI8agFHQTdbHDVgxa6eov7NKlBrxbvVBfHGcIWLESwkEMJa+CiUzOWidydClvLyxhGNvgb4rruhzaVVewToZuoGhj1Dai6YPBtXZmrCWafBHvrxT9f2/s5KtMxdFbZeI9GnAI248LihiJTrNDvR11hlhroto3e3i0lr6XTurbVYD+MVQUBm/VaBgXt8PsWHw3ekROZEXiuzP9H5KGlH3kyLugZTngntVboeDV/u
 BrpzQvtA
 /eXshltJshU4+tyi/9cTw9hSm8j2CKEk9XEl8V5yEtYgGzUhFKn7Tor6SO9WQC6a3IgLFQ7Gj/t+bDpfrw67k9vj30l+Hx/Wx/3Tdep62Jsao9ATt3vP05Dfg+RWUGSM9L52a1PBSfs+dP7CfpXzKZlR341BTm9yMhCILHvJC2yQI6S42D4xYsU11g8pqiTAqFOsF5u3lVIV+au6NohOdROnRJWEXDhxjmwrKELkorr/17YR+ncuCv4OSuLqz8TQnIgx2Q4qRsUhISOnBlMMlQfKg2hDHEu0/ZHD/O8ZHwGtukPOcXCVrWg4q0ju4wEmZaXZXO5WO8N9rO5wDnpnTLr8uzXEhThqwJx7zJb6JB69XZOjpJA7YyhaEYV5GBPI40wxOO8c5pU8ZFlry5558PhE1wP2pYtwoSAxqBLfJqal8nFe8/qZBp5qXogvXTnGbvgGvXFx2HtijuX3ScYimB3/QQQ==
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


