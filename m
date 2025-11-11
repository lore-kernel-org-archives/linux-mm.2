Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BA7CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374A88E0007; Tue, 11 Nov 2025 02:21:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321E18E0002; Tue, 11 Nov 2025 02:21:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F068E0007; Tue, 11 Nov 2025 02:21:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 196D78E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:21:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC14212D15A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:21:35 +0000 (UTC)
X-FDA: 84097480950.06.889C43B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id E413A80004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:21:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WF+XWuZj;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762845694; a=rsa-sha256;
	cv=none;
	b=1jbuxfs9+U3cvOVCVIcnvrF5ZX5zWBi1m76Elnlum+0x4IXFa+sau+XQ3O9quDKk5Q/iaW
	0uGTBX3xmb2RJkgDGM2nFtpUNdq/cGIUcVcDUoeoqEXhJRr3OZu9rblB5TwSgwkGQJXUwm
	LwMK+QUSuVrESSzD6JLpGZ6vObMOyHg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WF+XWuZj;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762845694;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ6yrPf10XyjUbpb0uoz9zDvZV76d0sxqTJxoq2o+VY=;
	b=zmQLGl1giTg62qDzpF0XdYKgvNui9vIRERYWoIw6DhYqGd862MHbSznJQ14FMj+m94RAh+
	97AFoevMkThBR0eCuEXnLQV2rADjAtDQRbl0tfbgokIPjdRGX8XuNERTY+LgV8kuqV5Vlv
	z7F5C9POYImOg0LES7jaAwVh1vO++ug=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LZ6yrPf10XyjUbpb0uoz9zDvZV76d0sxqTJxoq2o+VY=; b=WF+XWuZjccDaSV23t3ZCfvZAqt
	Hohm1giogHgJTgIjz+BM3jhjjTLoMdwPuodAY78QeOg3GUBHZu1BGBA/33p1gpzOLqgCHsjuNsjeO
	sQETYjkIyeMGltUwxf2aDzIQ7PxRO17kuJJhunXpDKie7s9abJc1ZOCPUQ4749pSp/uNXUiW0pz9g
	5StKOHjXdngU9MjIt4G/vCYSMTp+hyY6F4EcS2NOjjVRYMEIOouxZxb3c/rhJhZKAuyInpomcfpJH
	67Y7Q5I6dHBaVWqSe0Uuoe3F6FPAUvCjSQfpY1qedvsKXQE0I+R1n4CVwDF5AEHhuS7B8QobBm68r
	RCaB/VuQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHk-0000000Bwyw-24hu;
	Tue, 11 Nov 2025 06:55:24 +0000
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
Subject: [PATCH v3 21/50] debugfs: remove duplicate checks in callers of start_creating()
Date: Tue, 11 Nov 2025 06:54:50 +0000
Message-ID: <20251111065520.2847791-22-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E413A80004
X-Stat-Signature: in7uej5m9fbhuub3nzmn3f9gihztskja
X-HE-Tag: 1762845693-354968
X-HE-Meta: U2FsdGVkX1//CKhzj79NmeUuN2DtLWQOUFXV4aT3onJvMCMX5EcCpIn40OXH1FuaM9i2YNTXHI/qVzzt5aiHnxKxz9N2iTD4zzBI2Jr9uGHZZItmA7Skea/jTc3gElxNzm3Of2XWanKEdKyIlLmyDtpI1GqJ4bxEtTXLFX74og0oHL5nliOs774tHkOA406ZiulNIMWaCarome+GeM75p04/qx26oySap29E5CpbHQoEuk1dbZ0x+BtpPx9vDdN2tObivVcIX0m/DIpRMizzXt7bXc0ylTKVOAJgUv/W9ZTe4+FUk/dWMmbXly+X15FfmD88KRff9bCLKqxtq4iJsyjK3wqibxDOLy6gIN2xbDu3NGxdq5GQgI3WNM5PjJDB7Vdpsfz0ur8+FF4RrMkW72OJbfNakOXOgzzoVOfnpoicUZe9j7NyTwTWJebMRRRMokXIKczitg8YyOrN+ZBJtN5xId7BM5RhfcHCdjtB+KEhLXXhGXwT/2JdHwoPJJmAX7Czt3ylLdlNGa3fZhvLQXTJaP4lRI3gmKQKegOF4TOC0aTNUL+fLXbGf8wR9sddd7K45nt4+DsVzJJc+uQTfEgDJ0ilY7Dc81B6L+HVTMS6X6fTH7LtvoKN9aCai7neaGR2nPTS733h9g46pytdDIxDQqIXWUB5t/SeSEFLdGwapQeKxy36yW+ltgJ4SmYMZQMNTqSU0KTTKcLNjX6LhZKVQyrEM2LjUJYVTO/27rPX62qvRN2pZPgwv2yCctIEda+6GPh5Qqta4H4YSyf4KJ0/E5DcVnblGOZ1s8wSSkGUZL4z9h3NYBz6z5nIiLBA4EFhnzTZIX4sNT454LvKOJXNuDeKh3w0WbgEeHLwFGBboC6yCdDjmmaw7jqlf8eAbslvuJCUgy8fmEEwCUs2IIYs4I0nRxDJngpfDyjkcmffV6QhPre0PxGvFcRRd2vgF/qGtxKnoLi7t9jN+Z4
 5a5QE29e
 39+AE6QswFuFRd5HQL2/9MBgkRwBE2yQj0qIHRK2vHLtr1reCA4wo1SlbzLgeqxPWcnQXNDAUb3Yba5Si2SG4K9U7zyiLwh1mmMCy2AoAjweXC4YCWv8pwEm9JR8X3qwNsCTFx4NS5LMBGN8aHLyouj6Lm5pwTOxtZxIqpTDyc9MfA98wJUiqFPPNjVPk4YDEI2VCvkMR4jrp/ajV8WE6YasUE0GxYOaFns3v0IsjZz9ThDCbevPFVmgWjU8ZbaAY30LQ2yui34VaRGkouIO5XZTcFN3VMlx2QIDKfj5uZDgds/xfAQMcuslTjhE4HieEohB22hWWqLLoiGBrE/Xrv66AYPxBZrLYkIeLYfivbQOgk+c+ur6TWKlGAQOoamUVoejhG6XuNIzBJGyw7ixjutlWWb93DIJkK4sOB1ZMJydHyqBdr+gSfn8peQm1+MvkJBwtzeBA4RnXp5Pgb0Hu9uSs2qyg0XVUVXw4K3BxKlllsqWEEFmA7te3zpiZpsWp4NXmXOOcJp6dIgJ3UuaNN8rkRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

we'd already verified that DEBUGFS_ALLOW_API was there in
start_creating() - it would've failed otherwise

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 682120fdbb17..25a554331ac4 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -433,11 +433,6 @@ static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create file '%s'\n",
@@ -583,11 +578,6 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create directory '%s'\n",
@@ -630,11 +620,6 @@ struct dentry *debugfs_create_automount(const char *name,
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create automount '%s'\n",
-- 
2.47.3


