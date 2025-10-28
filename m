Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D20CDCCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165BF800F3; Mon, 27 Oct 2025 21:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CDC800E4; Mon, 27 Oct 2025 21:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052CA800F3; Mon, 27 Oct 2025 21:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9404800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:11:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EF6EC02EC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:11:32 +0000 (UTC)
X-FDA: 84045745224.29.FB99E54
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id E70541C0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:11:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=D9zO8tc5;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761613891;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTvrbo3mOzTGCel3agLEDWiwlpX39p3niSGJ7gA+srw=;
	b=nIYvawQWsHkLPa4xGnvlNWUDTBsq+6GB9VaVQwyN9i8R6Lp5xBUqVnQ6K3sJoD6P8TdmVT
	EsTtN3MUJA+RCnYEc19oF0lM6EkisSRBUOUE7Gj3oJrkTLzRtKB6zRnMuceT65EhX/93Ki
	LBNqltZg6riaF9gzcGa/nLKkX1FEk1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761613891; a=rsa-sha256;
	cv=none;
	b=myqZ5wF+vBGtdVOKBzUmPnuUSEeA6Vz8uLF+trlAUaZ9fM9otXFQuKDvPxI/EimT6RNG0g
	b5j2NwEHMTJqwdpxuGd+/g7A//IfzB/ycQKg/RYBBKjO80HhVe/aVqFGblMGvbU+vd9KZo
	bAvfvVMuEWROnS88zbaoWtl6K21JqE0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=D9zO8tc5;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fTvrbo3mOzTGCel3agLEDWiwlpX39p3niSGJ7gA+srw=; b=D9zO8tc5gojcx+KHqFNaPkoIH8
	HHaK8RJUotq8p63zU0QdQ5l1ibCN6Gm+22L9dMB5TkqU1nZ+tDpYqqhLAtKmjrRudjrwZCbnoOPUl
	N+/rvq82fBDxKGh37AshE2wlhJuVmZbGrCR5QtNrDJ4w8e3Y/ftwwStw5Ci9oczcUTw1154zUxnyf
	PFvA5o6gQl6XTCnHGwwYFLFzcz/V/fKUDTVoOYLlGCEtsMICFNt18/QgY8poJTlBG+s1sivhMjmz+
	Yx61PgGITTnRXu4wk6RCB+rsG5gHe67UU88g86eccy6z129G1NC12olc7ywZCmrRufHifBOW+gTXJ
	SUgUxRxQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eXB-40ia;
	Tue, 28 Oct 2025 00:46:15 +0000
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
Subject: [PATCH v2 13/50] convert hugetlbfs
Date: Tue, 28 Oct 2025 00:45:32 +0000
Message-ID: <20251028004614.393374-14-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: o7m79foncumq9gq9f3ydw35jrjnsb8k5
X-Rspam-User: 
X-Rspamd-Queue-Id: E70541C0005
X-HE-Tag: 1761613890-450909
X-HE-Meta: U2FsdGVkX1/AXo/dy6FCopWz0Ho70NKwdBzEaLS4pQNyKWEtjg8AYWyHChjiSVTwV4DXzycbPEXdFQsdKfDgh78ztBboRdFDzLzTzDNF3AvnXsfTb0hZtWtg5v9BlpObuH5c/RTCXd/Y16rBsWNKAVKqQOxM5dci+09X2V77gngUkRrf4flis54SflHXPykHe8SYeZZZoLhA3ud6FDenG9hFb9Au1eE6WNfi7e7TABgN9N+pcEvb8R/SorjBoEgHKNFOqn9gaZfahuugDLdayXmssiQWvIHI3M5zW+d2v7JhiVKLj1M9BN8fTLeFDeiKPMxC2xGu8FX551mE+uKRIIbnPSjFLT71IpcSFeeC/Rldv3Ds4E8QCx2LCgAKlhO+KcKYaWB0CctdcTE46klAc5n1P99KyFkitFGNUc2wqVrmvMD/GcfyUuqEW25GwkSJxPPsYEGaeqVE1Ei1HpRh2oljz36JNMaryEPwwp6y7wR7NsG/iLsOJswpfURj+fBSg88Gf9y0mhU2Gt2r7mmr5FWO40Sz5LwBNYn2olQIRMPOOwZK5R9DCn5D8qBBGths5FsHP4YQQm1dtSw+YYDAE0C/FpxOqg+BGKbm/BsoiVEUihPOvmMqH+pEVmPyYMaS4dLGgIRrS0rxafT4toyelScvYk4MewZLdoBgf0Jyle/N8zPVVXWCkKyAQLNMKgJWyP1jDARPqQ6lmahLkcbNtiGYlay8iurj0VdxUkkFmBi5VtyQzsqWZMuVV2tkHPb6/1KW6asW8k6UpQLXE/z22eoBQ+gE4BapxZClP4lrUzOWF9Qhd+kpmPHQOdMPL2tBKUtOG44VIF8xhtZmaRFt7f4GsDJEMW5xMWw/KLNhkWwI9tB3PAUkVi9x85NDFCQRxpkTo/YaZ7PguPWTSLCNZ0XlBZyKX+pYz7S1mvr8mhWHW06UcNW65Vaej3NyOE/6mWpwuoE9WnLmqpUS8C4
 /SiMGQAF
 8/pjIouTAXrbx3xX/4xS44PmL710bCZWBGMAW/j0ywRdDwyF7RNnlg8sn16g5Ctv4mvpGvM9J0PmfKaaYtfrlkr8ZPWsbuK/hcND+WeAFQkqO91rBY5LEkjhkDaHjTTE307rJD8CJDbQgP/kLzQilvvAIFSFdRgQjadRI5WkmdG5Kaj/7OrRW6Jrkc1+OUukfYIZASjh08mgtL5OIcCB1Wd/Ep56/NrOsGczOFmyiTzHfnSRnFucNM6zooJ19IHDy47e7sbG8UtCyd5vFaMjGyN4o3G2LnxRUd8K2Skgezl2nDpAbquzTKXDhe+3qUSCxBs0+BtE4iv5ksl5es3bk4MKBQJJwEu+ACDLswcARQExzMr7U++f9A+EiQbhy3jb8s/8PB04QCQsjFPA+1GBVPOGT0LOlEPtfr4/5q6XvUE80SPyObW1ia2sv5ETi7hdA+YKUfv6R5lUigwI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Very much ramfs-like; dget()+d_instantiate() -> d_make_persistent()
(in two places) is all it takes.

NB: might make sense to turn its ->put_super() into ->kill_sb().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hugetlbfs/inode.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f42548ee9083..83273677183d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -975,8 +975,7 @@ static int hugetlbfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	if (!inode)
 		return -ENOSPC;
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	d_instantiate(dentry, inode);
-	dget(dentry);/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 	return 0;
 }
 
@@ -1023,10 +1022,9 @@ static int hugetlbfs_symlink(struct mnt_idmap *idmap,
 	if (inode) {
 		int l = strlen(symname)+1;
 		error = page_symlink(inode, symname, l);
-		if (!error) {
-			d_instantiate(dentry, inode);
-			dget(dentry);
-		} else
+		if (!error)
+			d_make_persistent(dentry, inode);
+		else
 			iput(inode);
 	}
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
@@ -1483,7 +1481,7 @@ static struct file_system_type hugetlbfs_fs_type = {
 	.name			= "hugetlbfs",
 	.init_fs_context	= hugetlbfs_init_fs_context,
 	.parameters		= hugetlb_fs_parameters,
-	.kill_sb		= kill_litter_super,
+	.kill_sb		= kill_anon_super,
 	.fs_flags               = FS_ALLOW_IDMAP,
 };
 
-- 
2.47.3


