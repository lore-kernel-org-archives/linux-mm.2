Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C28FCAC5AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4BB8E0019; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C538E0018; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8688A8E0019; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61D9E8E0019
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E865C093F
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:11 +0000 (UTC)
X-FDA: 83908850382.22.D2F8066
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92733C0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="pQ/jwxDa";
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354489;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0EOMkT/UFsYLOkQCFILn7xjwHlMa0Zq2h7YoVPTnFkU=;
	b=SbUvQ86Cwt6oreAAGI8mjwbkU/Cey6nvb+XYUxVkXj+MVLz2jXZ5cS3H44ebPenCFxJDfw
	tfhX0G8aFZ9Qk0q9/UHBkGSqVFs88vU6KbIkwNgsWXKHMyFaNOFXCj4+ThZcQom6ERMhGW
	rVgOI8C4pKcu5hNErw5HfwcF/EZc2nA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="pQ/jwxDa";
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354489; a=rsa-sha256;
	cv=none;
	b=Or6K9bwhlIcS08zqR7FcmWR6W1o75RgPd85RQ5VtTjmutzTe+uUuf2ZHFsR8XabtvhpV3q
	5J2VRYGR6IAZK1WifEzUc6us0jq1OUWmUz5MND0z+fSpQNXu6vAxpX1XAOhqoK4pe7ubaH
	NIiWeMk2QX6e5cMqzt3V5g/rbjS3Lbo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0EOMkT/UFsYLOkQCFILn7xjwHlMa0Zq2h7YoVPTnFkU=; b=pQ/jwxDajkwrHC1Gmh5fg9w79r
	hzxbGeYIIbrO2n7kvvsAppMq+o2/PZt0XVO7Hm5K72cISh9MXIXn/fM4l8+dNWUVGpUy95MzpWACd
	7HIgGR0ttc/O7g0IrqwE9x5T+/cz8+Tedp1iHohLeHJQK7iuEQwz48CWspHGgt6EmTOaCstNmQKTT
	dqlW4Nwp3hygpE/PZ25TXNllPy92fiESt6mhBve+0EyVZmlAH/PjjoGHoBuGpv6Sot54xlq98zHWL
	TcuYcWLg+f8QCKKFxKUGzaFy3OKKAqj/Fa7tIuQVvSClpRk8R0GmVvgSaKbWWyaXP0cQMjQMUPrQI
	mNkzVj2g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKD-0000000ExIL-3Leb;
	Sat, 20 Sep 2025 07:48:05 +0000
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
Subject: [PATCH 28/39] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry == dentry there
Date: Sat, 20 Sep 2025 08:47:47 +0100
Message-ID: <20250920074759.3564072-28-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: utzfxi6qah1q4ur3y8yw8fgyy1d1w4z7
X-Rspam-User: 
X-Rspamd-Queue-Id: 92733C0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758354489-615003
X-HE-Meta: U2FsdGVkX1/OPvQ1T6SJQFBOVx+qj7/BfON0QuaYRzqUmisvJ9IKPzydRFLAeEplZa80TXUb5VPjEMz0i4rYMqLemTDUwMqe8LcZ5q/EApWUv6t9ugB5k2kLqEcqMV84wFciTSfV2bk8oDC6vmVpKRP6TUyj+NmYZ3qmsdIrQ3mAOwlbWwHgt+/VyvsBak7xo8z4h/N194DMXI6QSrES7HLEzqcz9EUzz6eVbFpTawR367MUyRtipFdHwT7Pe2/q7ZfaZ+UwXPg3LWdDcU2DkXYYYCRmcDc0iwhUgbcMy0E690biKI+aSM+09+IsIoSz2ZVa/s83EmyFG2Rw1CCCPe7a4hPixw/AewNJxfi7xo7gzyc9uFSjfxBwkbJULiJ1UCXQZkWtbtM6JjQabRl7O7NISkVWAnujJOu+hgSmHhN6mxCedcC13TsOaSSp+ihk9mNLihQY5tMappROGWz5xKmzeHSKdaW+mo9j0ehBxy1v0371XxEdDcennzJ0HbZ1iED0HdVbjUpsn1zDJgjxxjEhY35u9/nPLhPatjMuq0kwssQ2kksH94P2sV5gGp99fQLSq/KiEIROnwuIwPru5APF0h6TgvHi/f8zAQWTM3u3PtMSVoYzyM78Wr1dCie9dIIU0HGzYYzdSMR8H2JUL/Ydjho8wp4OCmIPRSvf5Qs54r3b0T3lZfBjvY7ukNjmMAORidqdgzN77s96FGhEF0k0cL3katszZbRKaaO6o6+dp+kg+Ug0NArkooHjWWdT87zUqbBDIELx5D+yoZxUzsJMvty6IgBBJdPuK8SLsl2LaMEfIYSQsOFTHKE0uqcYY7IpiNFmOTr6w3w4EPejehsrORHyDZeokg5sfLiAuunb4skOqz7WvR5WJGB3vllo2SZ4sMmPbqn97KKI6rHKu+glkGM4u4xfW6roIPb6dHDh1AO+YjTjjeF4rqW29kLB1kODgmLxUJvl0251f1O
 nwoBIHfl
 ntkO3a6tDqsZUz3xSH9T43+SN5AwDOaZUlYXQ79tbMY2+tceZT5JF8/eWyTylaQ5oShavV7XM7MUP5xeWe+baxZzA54wyp5vbBk8GclCf3NLEsBYDkKlclehrQ4olCDq3RqkERpeRlaw3q5HdkX007Q6WOTio0Va7LToaZ2LrEhOJyRLM+7tqwA6TjOWehK+YsVmfOcZWVyP1UiGLxa7Ewz9L2+x0mTN9JLvRhdiVAQUY+BJuKsWXP/dCzh96ey2QqEMH7GGiW1aFR9TXVjENE4pSsHx+Ua1Ilf1PymOkmAdAuMGoNTt8iLZ19bWyX5klM0EWTZWHBncuHZ0JNBoHEo+IiGhgWlLE/9BdaD+ePLZRLnOcwm6+kNP9ObYDWSgMk0kntgnI/tQu6niNiSwj1hUkcOBeP005whBYXg9y4cUFwOvbOT6J8KGYjBGhjd4hyPnB0IWyy1NvxwqkzFm8cgRva3Ihqp7ZcJSZm9/ptIYr3Bs/dLm1rmAQCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/autofs/root.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 174c7205fee4..39794633d484 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -623,12 +623,11 @@ static int autofs_dir_symlink(struct mnt_idmap *idmap,
 static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs_sbi(dir->i_sb);
-	struct autofs_info *ino = autofs_dentry_ino(dentry);
 	struct autofs_info *p_ino;
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(ino->dentry);
+	dput(dentry);
 
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
@@ -710,7 +709,7 @@ static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(ino->dentry);
+	dput(dentry);
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
 
-- 
2.47.3


