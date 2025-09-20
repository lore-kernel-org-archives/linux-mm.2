Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC1BCAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5438E0013; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D248E0011; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FA78E0001; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47C878E0013
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 089F9BC327
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
X-FDA: 83908850256.01.ABC0AEA
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 49B29140004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="OQ5r0/I/";
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWCUlMHi5omKZPse+rHltZIDpXcWWINKvoa2e5LYjd4=;
	b=UdEEur3YzBROdiJnASB/8fyNakdmFx8BZajeJ959DGwdVXHjHlva6PYkJZG2Fq2fhvSDek
	/dmCsz/YHYlYkb4zksLqsvDu36tmAN3vMjOTH5x8JrwDmo+0MG/xv0e9ZcmkUGKFxWyx0C
	rdOxHdbdFXxvHtrMHg/5Q7XrKRyrzbY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="OQ5r0/I/";
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=rEQ+vh2RJrlBjuwDKqdoJf2IRIXey7liil1iCXGOvWyHzEJd7hHBWCP67k/9AvEqhLr9nt
	cVWJajIALNpyIJWb0xB3iwjXnQg3mVAwUyh+kjlCs1A28Tcsr3fUwf0Qza5bdKZsyMinwL
	Wf3cfkyN7vbyCLmRzdCnx/iuyZuGyFo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fWCUlMHi5omKZPse+rHltZIDpXcWWINKvoa2e5LYjd4=; b=OQ5r0/I/W6hUt+8wYII9TXI3wg
	zfMjZaN34q0Ac1B99Lez2+ujRCnk1aQp8ARPfAvAk68N6YSBlmO+HGFatdr1fYzQjHYSMZjRHE1Zt
	kaUyGIy2gHYuaGfG1meTLYQho2c7tPjSRrwm7oaHXte/uU6vFyh3TaNlkVx12zYqg4nHwOwg43JZb
	QqcaKOpff728N/6TdZ0WPMKp1IaidA6NJSGjvwObYSNsO08+R3DLlY5fIsaqw1xiGnD1AW0QABOVF
	7iw2dGUfxkNxRmIkTipCa/rLuayyHJAfnGPslDHNrGXxtoM86CMGESCM9fYweXe0NWDct/PI/7ln+
	cYyomVEA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK9-0000000ExDn-44H6;
	Sat, 20 Sep 2025 07:48:02 +0000
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
Subject: [PATCH 15/39] convert fuse_ctl
Date: Sat, 20 Sep 2025 08:47:34 +0100
Message-ID: <20250920074759.3564072-15-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49B29140004
X-Rspamd-Server: rspam05
X-Stat-Signature: azpwhhn6hz5msd1xt8h54ays317himdr
X-Rspam-User: 
X-HE-Tag: 1758354486-240583
X-HE-Meta: U2FsdGVkX19OR4Q6eDIVyJMy3VKIRr7XuTRKOyplQljGTgbxeDZA8peGhtAOjGT9tXVnR7zkNZnJwHh6sxvZjbcoZtTTyrHvtECCX3rhAwSKt7WMDXt4F4O7b3csAXujQ3SRkk6uE0eXoKIytBgm6UUfO+bpPUrjgJAO6NW9WeiAQcAaOdl7SdJyhIbnbBOvGcYYdRtk6xWWGhVeni4pbmlc3Oyp9IrLgyFtuo/GUSTkhASBmeIvKpQFmMiBvBb6cYpuBfTncWEDWGBHKdhg+lPn2hDj2m57owQCQ7um/8AnMfcvyZpK3gkjWi9frT5TuCHrjkdl3MeUnBcXseKI5+xpgTp6e1ijVOzV27oE+0gXM7WlWob+iJY+SInl/JcO0DwYM7Bgzd2o5axewZJLYB8FFUK2N1gOSquwQ5jxnBXgWvZtYCrI1iDrvUfW08XpRQbNxKOlNP3Dx4rxm2ennFu0/xETGt6VIA47jXHlNLG+u+L+GcJFqtsuLWEGXyq6HlgJlBq3ZMP2G5dtkuOQeVIYRnvELFqb+EJy9HA1IFM+FqSNlcU+QOqr4LrQyL7aEXNDp6JLSRI2u2C+4N6yB0mwADuWUBKGlWHQXoFQeBm16FhpiD1PYtxdaMQLDJdv9yC5DsCSs45XauvP4fnaAjAITSb7JHagD/LG5x/eLf545sdClc/bLrkwlFxW/xSCNYg6J4XFM3hq2Zpw0HuArNMXs4PVfslxUQmwBq5XpYw192hanjHpzDwfon9ziINQuPKrPX8Wr1QOLol/E63jgKKjNy/Y2bgYdQqlJy4Lu5/s/Y0J9XUu5a39cj0QFY2Hg5Ay12TV63NRWefnb5824ExzJAID3DXZPDdEGW4RmHZzgieAZOy3NoRIpXYY9Q+3qTWGc8Bd/bRmvuY3j86w7XbGlrntg1iGOv0I06/BKlOqz8UWgVyuKeYW4Wu1OTDNhV7Ny28Xi6vxcJ8FcJr
 O/N2jCWy
 y/bfyE2c94UPH2PFNM3QqhGKCi/c5yohwo6St5znDkv+r3vZJjcVujis99c3Q66gRD/0nOmSg1Z+UPtEiu5FfAfM48jaJZiWphSteuH+AXD5zrcxuu9t8PRlfEg+QIOtdHVdPc5GDOv8d2kece7Z6MJJ8+gjrUeZM/aTF2kVHCP8Sknz0daDiIXDIEaZbfyS2DjY5GsGyshfjpQ/fX4gtfs8JAxKLyfSk4yg/skX+hs3jlegQCPAnrQvSSodeDWlKdP+6ggmgyvaHelSEnJEN0LDtgPwF4wA3MPPirDZILJlZMJegjL67jVbNMWvRMdLaIblOub/qFUkFPBsQwsPuMS0gC1NPqE7pK7cJkvFnLu//izJuxwaPjBZen8otP2GHWlRJSDdN4WpD6W6zuwaLTHwx8MPVd4W4lZHPMERjUlglE8n3Jf7d/WqRCZ+P15ZKgjf3X2WAwZxPGQUqPLelgkS7lCNuPqI4v/oXXk7ZnjZaGHrJTeJWimsTOpsNMhXdv9N9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

objects are created in fuse_ctl_add_dentry() by d_alloc_name()+d_add(),
removed by simple_remove_by_name().

What we return is a borrowed reference - it is valid until the call of
fuse_ctl_remove_conn() and we depend upon the exclusion (on fuse_mutex)
for safety.  Return value is used only within the caller
(fuse_ctl_add_conn()).

Replace d_add() with d_make_persistent() + dput().  dput() is paired
with d_alloc_name() and return value is the result of d_make_persistent().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/control.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 31fa816d0189..adcb81e04802 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -234,8 +234,14 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 	inode->i_fop = fop;
 	set_nlink(inode, nlink);
 	inode->i_private = fc;
-	d_add(dentry, inode);
-
+	d_make_persistent(dentry, inode);
+	dput(dentry);
+
+	/*
+	 * We are returning a borrowed reference here - it's only good while
+	 * fuse_mutex is held.  Actually it's d_make_persistent() return
+	 * value...
+	 */
 	return dentry;
 }
 
@@ -345,7 +351,7 @@ static void fuse_ctl_kill_sb(struct super_block *sb)
 	fuse_control_sb = NULL;
 	mutex_unlock(&fuse_mutex);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type fuse_ctl_fs_type = {
-- 
2.47.3


