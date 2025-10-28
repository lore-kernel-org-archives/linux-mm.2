Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08083CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAE580103; Mon, 27 Oct 2025 23:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D239800E4; Mon, 27 Oct 2025 23:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F8F80103; Mon, 27 Oct 2025 23:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1F70800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:11:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A01A160369
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:11:32 +0000 (UTC)
X-FDA: 84046047624.24.D98D67C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id C9AE020007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:11:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=N1HyiXqW;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761621090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ6yrPf10XyjUbpb0uoz9zDvZV76d0sxqTJxoq2o+VY=;
	b=lQaLGDZcFDqh9Z6ODUxmBbILjsWmJX8NJX8fxCvveWOp3M12XA+lS0+UTFrCrZSPiqveaF
	0FxkCbVEDWEuLkwtEfhul1bRcxJ0A5wPlOvmdHx9CxC3v1hDTpOO3Jnq65RVUYEesB0Zei
	cjewKzXov0RBDwJ0Var4lWqaSmFZTI0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=N1HyiXqW;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761621090; a=rsa-sha256;
	cv=none;
	b=FrIzzaZYPykk/a6Ce/qMulpY94r1CD6GL5RDj0ZrcCPjTVfhGoh3z8CwXvp9BlNIl9G0rb
	xeiPYRLeGqXqeoBAarvZPSSDT+a4YhhjkLQ+kpvfB5F+aD2G/yMLF2PcCRgxEGo2eE7NQY
	efaxt1aojDAahcy1RIUkMdkNuY2CLZ0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LZ6yrPf10XyjUbpb0uoz9zDvZV76d0sxqTJxoq2o+VY=; b=N1HyiXqWvHuK6eYbHoqjsKF4yS
	sRZR3R+AAf6swru+RmI/QN/YSkxT19z6dcL9RxoRt93tDwIfw8aweTO/4iA9n9JU+jR603TVBSnk+
	Q2YJ74xC/uQLAY75lEg1xiQjThGulXfxJPHOqIx4++XcFlGut3/cwxrsMFTf0DgAoU4re6hB8TA1M
	3D10mdbSmAzj5Eoeu/6TEUA1WUtGct5NSYbTRd/fYRips79EkV3WYcVtfDidNQWbDxf0wxBszRyaY
	S8UHHm0pO8PDTgf+NmR2oCic03QfrrrZZGr2Mr642AXlexwRwbP3JkXztjANyhVSGqgVHU/kqDZ6X
	WD2OlCNw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eYF-3cOg;
	Tue, 28 Oct 2025 00:46:16 +0000
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
Subject: [PATCH v2 21/50] debugfs: remove duplicate checks in callers of start_creating()
Date: Tue, 28 Oct 2025 00:45:40 +0000
Message-ID: <20251028004614.393374-22-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9AE020007
X-Stat-Signature: keeo645dwi9ijdwh9ekfh7ainwomtsqz
X-Rspam-User: 
X-HE-Tag: 1761621090-566459
X-HE-Meta: U2FsdGVkX1/2V9vrp5+v7sU2fGp1RhGf7u/q4ty7ioWSy4SxrlnWvJ/qloYiyGMtbM8VYPrwP0WBHaKPx+H/iFzc2XIlUX0fHXjbOPm14HGFRuhsZc6YRmjyHBH7LdhIDZfvfMptYvQzBIJra5fjRatESJOA//I1YuGGI6UOvBmenA50RZR1fYV6i+qQMoRWsa21fxzfIhsFZncuTiCs+Axh1yb6te9SVJvWt5U9O3XYheLxuwDmBrcNnboOjRAes2eLdt8f7F/oKcyktSAV6k0JlXb5MaPC8ESCiHCTpsT+Oebw6vF2KUSx3IjwOqBNO9Bo3fpWaE59nJtke4+zLV4QwX7WKF2pOZB2i/sEsY8lyvc+5rBpH8bV4IvhmREyf0PQ9f3+6JTE+YvuwTwbwFYbhGCYe8DT4IavUyXYPDXkwJ2TAJdSoUW2hzZJXXF5B3BbFzpUIGwMzAHy5KRHc9det09Ir7a7YLYKvJyd2eM+MoC6wbvw+siH8TEOYkrw7pRMIUxfsg2iZOTxOQJBe80KfhsSgCUO1V9vGjSPBh4x1Y+N7lmVuJSPuZhnv1DiGFyM9H6lBl/J0o1c3odn8ESXsZQH2po7tAdjgCvtN0r0JHQCo3vxwobsP4sLsJTV2Mh8Dl0SCqcJMjUTyRBNNqeX4sBOwJn5OSAvGROUZfjJa/5fud+V3KFbYm2AlvBVua6Syz6HuQrrt6Cit00RNsyreroB9i4s69nKnZBh1eE1ZpSFtPFFd60mnYEhrW/ZQ1Eg5vncKFf7Agbueh1cruVn7hMhplNWhs+W7zThID36JQDvKerxlO1OY43KRgb/IugcNQHRByLf77RStOGr5CAROq2j//zEDe8JzUWUz1UXQbQ95YcgorcABwLHydOJsmvr3zM8LOoeiVTSszMiNt6VRqNHWO+lhMgZxNLAh3kZzwfyCSsRDdqYMG1nlygdn66atF3vtiXExqbXvyw
 /BCvSygo
 i8Zws9Mv9+uqlh7L6+L96rKtvsLbEJayqxeTL3eFiiikWa36jueFAw23pI7d8wwCeZdfvcxpikaPXxH78i2167RsezKRDOnfX0lg3Go5L+gg1vzlQ8ZmSRrKDhQsatLOs7rcl1POrEgKe0utVYcR74FXyUpxncshV/azYZvPdn39UJOct6HGddOEiLkKuhGXZaW/qDtni0q0MS2x1f52uoOqVTxrEeaNVAcJHnzAMULt/7/hS0ZGGbDj2sg0Ttdezo7ZC6JD6HZndcmiZFriQVds+hMnqEmBoSGLxWCdcuRrY+hNCufpBypmiV9qtj1gH/cPM5ILcGbxxlcAQ6J6SFcRPO6Ymd350sWF9j/5/rSeC5GGhLXPIXxaZbntykGCiXTXvAwucvjlFNIJBlq+JLg6qZvK/76Du2USrVJsEvTd5pPdOFZ/4ePVOcD18FbeHQYeWZVki1zVgDw/ei2ptuyR/41lO9ajdeRqmSHpyzCvD5IpsFqItt4ZruLS1madEOItpLFrdx8tlrYyzkHWwh2j5QQ==
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


