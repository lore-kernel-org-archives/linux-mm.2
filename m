Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17159CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2298E0018; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6775D8E001D; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231A38E0025; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B67DC8E001C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D0A81A041C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.08.8BD853F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8BEF51C0007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HBJvsBb6;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=62RNqT+IA+g7esdZuaAMnSara7kYhYMCobi3++P0YJbZWTsHvka99gLVVc/4h0pu/MiCSI
	K4e6j+Z+9YC6vRCYp5immm3QJEaH91UJw8K7ZGSJgq/+dqOesWT5uP0+Ri9lcVXJ72QZJK
	HDMW1wu9nccFcKAs/hoSiXiHGx0iL7A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HBJvsBb6;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcrjn9Hoyal2qTn93te4BLRuOf8fYSOuLLeBgOIrdbo=;
	b=VaJ4ZXXGpfYWoksVZGrF8pZjIAVYcwLoTZutMMqoE/fGmgHSLpbo4uk5dRsSg5pxlPj5+F
	KDtlSjwNLA2PSkAX3tNIElr89pKJxyrp/VOfPpDw0v8/umOEZ0zM4u8mvhgwN7j7mgXquI
	ZUdvcJPFJS4BSzA0WAs+eC4nFwCv8K8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Zcrjn9Hoyal2qTn93te4BLRuOf8fYSOuLLeBgOIrdbo=; b=HBJvsBb6G3R2lFHWxQJg4yi7EA
	ogEbzwl0kV8/dSI+7YYtUq+3QUM9stYqBDD0U2IOJHdWS1hBvExlcyU/aq+QkwPzt9fFREVG7Xk1I
	5Yp30hFOvB7PfIoU/DXzMICkaIPZ4Lp+c7NZoiQYKvNc2CHe/rt5Kty67e2YrtOWxEdHJp/nBVlrS
	9+WEP2H13utNb91o6Kjmwvc/Zi67++4qcGAWxn6a1OQ2gy5VvsF0amJuiq7e9InvooUce4BPmarmb
	/pf6fZAcOdbfS4S2otE5ZvDz3R3u9ud1UB8vDEUZz3VDn3dOp/ouQV7KkUor7sjEFxDjpXUw1IFwx
	rfQNCOWg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000BwyR-3IKe;
	Tue, 11 Nov 2025 06:55:23 +0000
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
Subject: [PATCH v3 16/50] convert dlmfs
Date: Tue, 11 Nov 2025 06:54:45 +0000
Message-ID: <20251111065520.2847791-17-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BEF51C0007
X-Stat-Signature: nm5dxxzz8r1fdioe6a4g75y1efdgomgb
X-HE-Tag: 1762844130-646974
X-HE-Meta: U2FsdGVkX1934yh85pcrTK34TNwMzAEXbrfDAJfCOccEfk0y4HApUQBdGIPLLw0WV4Xo3ZM2eln6S3uAwEMYmmYgxtMighftE6Csgecw3NEaRgGK5ilwDW3NRFK1qI4ULTtMp5/kxl5PnLvRDLQ1rd+5G9VwS7m2jvp60MK1G0WKrakyFPD+QhtC3+yf3qL0BeSXUgL/Xc+w+jPylsXfOT2RfOz4a4xvXBgWznXBCo9BQ70qWQIuNdLqb65V5nxxGPPcTwWQO1kqLi0icJ66OLEB/yW/r0/89TOuHgQ1IbE/olUft4wbycWM9+arVUNWx6W2D/21MF9BmsQfA57kKvOw9TAM3lDFQB39yyCChX31km8QAdnrNqOq4Uw19xcb+SUTmVJaN848EJ+tCBhDNHLZbfPPEZ9FGQCdlEVa30zvWCyGjAnWctRJZq83HKKiV3FcpVcMb/fc/n+ylDhF36GTRiuzqy33PbaPzKCN6RIPvjka124J3zW2ONeNh4yRomdxUnIHcPel6ukiJbBN4M4Tc/AhCQnw+ojU7JvQY6aFj92O6PoMHjhZ1K1a9xBAmPvn7LeppSQRxk+h6vGm58ZuI9VKOdlBr9ZqTz+96y5+eXCpZpFOCMr71zrakbCSzI346OstH3DPZ0IcOFjsc1SHceL3WkDJT7N1UoJSRD+jdXVgDtMPLLKEII/xamH1Vq2efV98eRHKjQeMnakTa8E0lhSI3VdwOtGWQdXG95f5SzzTfXRCEarNyqseyQyxurFSoyNk5fAfMp2FRu5MIych4FRKKzRwVLPTJiqjFTAxL0o9EiboP0nxbWP+W39TUFMXUuuFm7JAr1/1F44YcZtIfS5uLbeWWfN3se2KE4JkESXcf4WYgshoH8feSSRTGrGPxsHslbTd3km+ryW4kWq5/McKIWvBzPkTr44w2aMF3IDrm5Da1giFuuel/WflLgtaKIQuatWOmlVakOY
 VMl7Cn+v
 jFZjwqsVxiCDAGsvN1OURUtdfNrc5B/TmjjOane6r2r6cQKw07ldXSUD8orqX21bAjWqSOX648xX3UC7oWoLEX2Ll6O5BgCcQDNhWj83Xs+xOLDTsADN+wxsi0QG5/kgvzGgtmOavje1qIDkq5d6fyj2wu/CQCkCuYcRqSL68tYSXZbYvB+kH6DE395nDK36YPFhhOZQRQKKymflgn7l+spzJrdQwp/G7uI+O8niCMiicKpOdJEKFboqWeaBdOgSw5LgUSt/0gVvupIkq2bzV3aY8DqXt00n/75axkn+l2li31688fVmlLOmGllbkdQGA6kFhxOHykS4cZZNg5dbsZb/3gvJwScvWJ10QVBpG0IAkiS4GhMfapiLctVXceGfQYBFmPzad0CqhDrBAs6nnBjNQzESdFavuakvB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All modifications via normal VFS codepaths; just take care of making
persistent in ->create() and ->mkdir() and that's it (removal side
doesn't need any changes, since it uses simple_rmdir() for ->rmdir()
and calls simple_unlink() from ->unlink()).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ocfs2/dlmfs/dlmfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index cccaa1d6fbba..339f0b11cdc8 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -441,8 +441,7 @@ static struct dentry *dlmfs_mkdir(struct mnt_idmap * idmap,
 	ip->ip_conn = conn;
 
 	inc_nlink(dir);
-	d_instantiate(dentry, inode);
-	dget(dentry);	/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 
 	status = 0;
 bail:
@@ -480,8 +479,7 @@ static int dlmfs_create(struct mnt_idmap *idmap,
 		goto bail;
 	}
 
-	d_instantiate(dentry, inode);
-	dget(dentry);	/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 bail:
 	return status;
 }
@@ -574,7 +572,7 @@ static int dlmfs_init_fs_context(struct fs_context *fc)
 static struct file_system_type dlmfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ocfs2_dlmfs",
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 	.init_fs_context = dlmfs_init_fs_context,
 };
 MODULE_ALIAS_FS("ocfs2_dlmfs");
-- 
2.47.3


