Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F70CCF9F0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32817800F1; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB322800E5; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A83E800F0; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5A1800DD
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBEC21402CD
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.19.4D3EAFC
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0509E1C000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=tX1rzPoI;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVog1JmPQq1AS/UVL7zjpUgX0UVPwCD5iHtdu2BZv2o=;
	b=fd6U4/vcnIwA4eqMiolHsQ850L5pe1NY4XL8nrf9ymuYVZG60pVr7qaEJ/5M8Q+h270+JA
	92/l8A6Ub9CgDI4imztS1coGN6geaLp2K1og8lzbKIVM6pANZPy3bNq2x1tyQwFechSrtS
	FeZ4Ya2qzj5VgjG22vvzi+kP58Cztsk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=tX1rzPoI;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=x4G988JomCXEcfuupgVRv8X2j3e0XIDdMcGIbcp4fFh1rdV1DxtCE9mWeZiNZUVR+Hu1N+
	TgMkXjcu1awBrLmgOdxTaMU7PjNmTnc/Ee9wrEBIP/3x/aEou3Ipv+lEht6KQ9zwDokPPz
	ZISZu+QpMj9eLQFtcY2WF3kBJd73v8Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yVog1JmPQq1AS/UVL7zjpUgX0UVPwCD5iHtdu2BZv2o=; b=tX1rzPoI/1o1o090qccKpgmnIE
	QqiR/xhjlRjUmW7P9jea5A6shY5HqE9KAWb7Aqgf2296vLnngrmPdFJsxX3IxxxyWHrjaMn+N16oN
	rkurUHdU0P3hehk92336DnZJ9QnK8zPyusTON5Bbz2ckKFCM4fnyBbkJ/cU1fRgZQHpMGPCCQcQeY
	dutnAhQTWa4V1Ifp8AjvhXoZuQ0T2Jp/GKhtwBw3kZ5rPDZJ35ICGa3HdKklj18biB+1ElMvcIRXL
	kxjqEJOJ3VWSbc3NdfMYVGFKkJSqF0KCaE1zJBpWjyJ2F5k16luWywgXZRm1Z23svR4xtIMDDVYST
	0bX1WSmA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001ea7-1K8h;
	Tue, 28 Oct 2025 00:46:18 +0000
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
Subject: [PATCH v2 35/50] convert selinuxfs
Date: Tue, 28 Oct 2025 00:45:54 +0000
Message-ID: <20251028004614.393374-36-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0509E1C000C
X-Rspamd-Server: rspam03
X-Stat-Signature: wmmhycnfi3qgxr38rezmr7wrtgqfaedb
X-HE-Tag: 1761612383-448977
X-HE-Meta: U2FsdGVkX1+Y9IF+En0s7/j1+ts4NKi7ug5aMdq2qwop5SxHip+JpvH46Xy2YV4jhpoNn6SRiPUFvUSDEUYn9fADZuf9AJbBMlNxiARSFHr557u9MHTxaCKwvD7j30zteT3/eB/svkFwA4x1GmaDQ0ysaDiaOwD9suWbWgKRKlrJSLsIHxAED+u1uZnMvCdANmRFVavFKlsZbPzXaMll6yO96k6PIcbdDrku/7oUcLzYxikqqptNier4Wq32FvHCaV3EawFbYEpWdt5uV/b8/6X0fpLnEm19M/mUwQ51CDNjp/ZKFKP4wPSNuAX3OR4lPiH0MbeX6Dk7/KgheAIl7s6p7/GJ/f9702Ir2KBTjvVrmBdaHjegJ6O9vPRh3r8mMO8iOFjpGLh5qIiPWEZbEuejgaDmSzOi2XvmfrNqWJucBa2ypni/XzP76bhMZtuYRs5rAmixnzSlHq3dKwlcAkxRxnE0ewKa+QKBbjMEO0WGh2qvLZNwyfW6WP6eB4oOeecze+MbcrVZq7gJtwDjuFBbz2VwAKetublyY5YucnC0KIfKgAcXtIwrUpvJEi4+hLA0DbgrvRDms6umYH0b1Z3XdK+ny9r7oYJ5IC2zuqi3zcpThecjIsIxhppZhyAx//oPtQxyPiS/jChPWdNoC0lYedWxJiLgEtsf5T+lVPSZM8I0S36v3lyf+Zr7R7rxE+wdKEtC6kR97k1gWMYHhkY1r9AMGu91SqAUz9VUREm4SkafoCm9FMRF/ZSZMMJfG7lT3/IPuPJkKnb/o6W2+CSF3bKftIirltna88TFnGfY5XGLZrvuuUJediDZcuN0o2u9E0wYfb0s7ibdehWY32+oO7lRG5d3U5RxDoEqbjiX9i3TTuVzH/neQ8sqryyVPKLF6uSSV/AOZCGjgYrd5jISItsC7KJOAIpxgex8CMIHj4gXyT1c6huFgo4UFji+XeTiIndxFanlhu8wzmC
 V/DPm16J
 RZR4IUccQzj1KQckft50vmRngsRHvWg9e9bszGikHBVNFmyf3SGVzTE6ANjWl2IeC7PDR1d2EA5EtmrMAX4HAbQzGzYaOfWe2qYfCzu5iiIx1orHRV977Nr3xbzj7xQZShcpx4jyYhQW+zDNK/vSE4x81NuHjNhcFHbMX0fXCdT53KurOKLwKjlP+NvW03bJnauIn5/G+Uf26QEUvSTkt+h0Hw0t+JV6whxL7GDzEasmFZ6uZgNyekPsPBVqvs1SjsR1tawEnd7WbL6+q7gI2BrlVz/1izXXaDZhkM0Gr3FD1OBEP87W3reAiBpO7NbgQDAqO1cFovyDh3KNhDeHHwt/L9ZwdQkIqs9k/FH2AZO3GTK5058Y6B08J4sqZpq+Ilmie
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tree has invariant part + two subtrees that get replaced upon each
policy load.  Invariant parts stay for the lifetime of filesystem,
these two subdirs - from policy load to policy load (serialized
on lock_rename(root, ...)).

All object creations are via d_alloc_name()+d_add() inside selinuxfs,
all removals are via simple_recursive_removal().

Turn those d_add() into d_make_persistent()+dput() and that's mostly it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/selinux/selinuxfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index f088776dbbd3..eae565358db4 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1205,7 +1205,8 @@ static struct dentry *sel_attach(struct dentry *parent, const char *name,
 		iput(inode);
 		return ERR_PTR(-ENOMEM);
 	}
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 	return dentry;
 }
 
@@ -1934,10 +1935,11 @@ static struct dentry *sel_make_swapover_dir(struct super_block *sb,
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	inode_lock(sb->s_root->d_inode);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(sb->s_root->d_inode);
 	inode_unlock(sb->s_root->d_inode);
-	return dentry;
+	dput(dentry);
+	return dentry;	// borrowed
 }
 
 #define NULL_FILE_NAME "null"
@@ -2080,7 +2082,7 @@ static int sel_init_fs_context(struct fs_context *fc)
 static void sel_kill_sb(struct super_block *sb)
 {
 	selinux_fs_info_free(sb);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type sel_fs_type = {
-- 
2.47.3


