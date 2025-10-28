Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF09ECCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 02:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35448800FD; Mon, 27 Oct 2025 22:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30395800E4; Mon, 27 Oct 2025 22:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D67800FD; Mon, 27 Oct 2025 22:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 037E5800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:11:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97263B787D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:11:32 +0000 (UTC)
X-FDA: 84045896424.07.7751B18
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id EC11C40004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:11:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qWSFV529;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761617491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kO6yHdg6siJNaebYbY2WULFHGrjSdi/bz+IlHzXX3E=;
	b=tumkpIZlG/NgTlYhxzXMyxCxOW4spYoPYjL/GQ+RcgLfysA9q+gH6z5h4Kvt1Qk3BPWK3n
	ObUOCXa6D9FIyu0GO03xzZcYyQUOiIHv2otGrsowzAIY4I1R2dUxwTw5EASlOH7mEarlw2
	xEt/jOwdRXFjbjbjV/3R9cFC2W5m9CA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761617491; a=rsa-sha256;
	cv=none;
	b=PaZvL58R36GH9YtHxAZjEajPFRwvRqYLiwcskboGKotlQifXu3VSPwNSEBHwwLnZ6qB8Fy
	1t+Rna23cJ84J5DJq2DJ/cj5+ArUwPu5ycunkgRH8S3KsneNLNUT4HG8J5CeV2btpgpshj
	r89Q3WrNwNXXgmEswYhs0Ww7Lg5lcLI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qWSFV529;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7kO6yHdg6siJNaebYbY2WULFHGrjSdi/bz+IlHzXX3E=; b=qWSFV529y90Ap6JBzI+mn63edH
	BAwZcDrZ0a4vMWGm7Q9HAkd3smT55GSGctGorOIAdaqzWNqKy5xV4Djjv373/fG4UAiE4peVfwBPD
	3NV8Iy2WP39Dbj7Ji2dmNoFd6WxgfkC3MIuVf+PcahH1nLGmmqQD4BTTk+QxOMZg+MzjPUgbZ+mT9
	bUy4nrFkUbG3Yn2DEdqo85Oy3OjskYW7QwZJs7AEkrEv1NLvXBXqWuTfTOLD/iQXHC0RwWQQKK/0w
	kIEs9PElDxS2vWbt28o1WOSWf1dU484GGh/FPZLlYBkYTb1jvt0PFcSblxjo0UUl4ep9UiJurBknH
	jULeC1pw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqv-00000001epa-3BMB;
	Tue, 28 Oct 2025 00:46:21 +0000
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
Subject: [PATCH v2 48/50] convert securityfs
Date: Tue, 28 Oct 2025 00:46:07 +0000
Message-ID: <20251028004614.393374-49-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: qb31jh96fpuirpic1i4oxgo8x6i14sji
X-Rspam-User: 
X-Rspamd-Queue-Id: EC11C40004
X-HE-Tag: 1761617490-542516
X-HE-Meta: U2FsdGVkX1/VPztrgCi6fwY5W6O5QbtIXlbecZ1miIdd0Rz3zTXO6vQRCLkQB+F5KnAScpaoiP9d49FFPpIQhcV9V/fSpdQt56JnFwusP/4a8DaXc2Cx/J+4TCyzxcZDxgsWaT5p2hP3j9rAENdY/csJ3ad0avsJtKbkkFrTJrQPFaMc+BSNbNLFos+aVpu4R9XUCIaahWZvrxcLiL+OLckkCYY/2DPzKK1NoL05K0pwA6gcC+4dWb0Uz5NM6Qng8XHlOyka7GYie4/txnojDKosOoBBegPRPiGb9cx3ArXVShkLGr6ztCjGSqrQ2byz+CdqJco89iqL3VzUmlABVQ0rqC5iJvk5P5GRuZENI4nqoHkN0yNVym/QiQDT8432zBVTQ1lWm1mAErsFQ+0UHpu5cHuxYHA+2zb8bcsthuvcgxM5bo5MulemXRi+y7zFwxQ1DIXOA+lSMMCK24QFTc26QfMCO96lVo8fYDb0FHPU+131HjEl7NU7Wdkg1HnmkA0rkvitv1Fhyx++/tcQtBl09vczfMT/4Vd+nFqgnSRE46J9wAXgkrRI9UHUoyhT6xUmwSe1ZUCzV5d9LG1+HA98LyMYZVLpm1GXa089EMhFZYBQ+dPaGHb9WLl7Md3stMQILPSQjOjnDoC3513yq7XgJfvfB0sKlESCGMO4dV8fOzy3dSM5Old79iH3ENROxFegXZvWkzRG1VMQy2AOkg2Q9X1QWR8MrFCNROWoiYoOv/jGNhESBcqAaClWfHZ/tsQfMag5wzbFBEQ0LzyldbP63WcmORaJEoyE0FrL2SAjZonmoo8IvcV0yb5Ibw9lN7XNMnlcY7iXdCA1wymDth3MWAWTU1pa0dxysLAv7UVYb72jLVN2IGUPeYIGSgaWPfHOHFO0cIDWG8spWSanBWcfffA2qGzBO/no/i3pz7SsnIz7QS/Hpd1vD7Mse28U8Cyr92+vm1DjUECeG8e
 YGNoXDSS
 jnbpafi6IKPCWMnY9md6rDM5MlmOVfvK11FesdZFlcqk1hn6UlyfdCm0U0LZwISqQ0thx3n8c9DyD9t9mlfKfyikBGNbZvyNiqwdcLeDEuFrMJFg3lxLlKo6M1PHA11QuJsRM09YLlLrVLZxRmMN19Sbso25a4wfdg0rb141lQ7CoaycSJ3TfzcRzmiOCXTdUAmWujX1GtP8wl9IlMqtXI/IV5bb2/MJjzzdMcVLoLBFpm15GObf0XhevJmaIeySFFrxEXntZs9NhjvromRjLLIxqhgb8yFm3HijKGPpwm45CIyWNWp8ExziZe0c/XsgmOezuHay5VmdmC2wAbL+0t6Tpx3EgsPTiHFrFfcTjKthOyYnLcvp1fSv6ZCZTtYP+SxRPKaU8qjyFm9TuWDtTsSZ28Nfk1e9fC4/Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

securityfs uses simple_recursive_removal(), but does not bother to mark
dentries persistent.  This is the only place where it still happens; get
rid of that irregularity.

* use simple_{start,done}_creating() and d_make_persitent(); kill_litter_super()
use was already gone, since we empty the filesystem instance before it gets
shut down.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/inode.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index bf7b5e2e6955..73df5db7f831 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -127,24 +127,19 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 		parent = mount->mnt_root;
 	}
 
-	dir = d_inode(parent);
-
-	inode_lock(dir);
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry))
+	inode = new_inode(parent->d_sb);
+	if (unlikely(!inode)) {
+		dentry = ERR_PTR(-ENOMEM);
 		goto out;
-
-	if (d_really_is_positive(dentry)) {
-		error = -EEXIST;
-		goto out1;
 	}
 
-	inode = new_inode(dir->i_sb);
-	if (!inode) {
-		error = -ENOMEM;
-		goto out1;
-	}
+	dir = d_inode(parent);
 
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry)) {
+		iput(inode);
+		goto out;
+	}
 	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	simple_inode_init_ts(inode);
@@ -160,15 +155,11 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 	} else {
 		inode->i_fop = fops;
 	}
-	d_instantiate(dentry, inode);
-	inode_unlock(dir);
-	return dentry;
+	d_make_persistent(dentry, inode);
+	simple_done_creating(dentry);
+	return dentry; // borrowed
 
-out1:
-	dput(dentry);
-	dentry = ERR_PTR(error);
 out:
-	inode_unlock(dir);
 	if (pinned)
 		simple_release_fs(&mount, &mount_count);
 	return dentry;
-- 
2.47.3


