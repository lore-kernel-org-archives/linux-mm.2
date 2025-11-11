Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D042CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5DBA8E0012; Tue, 11 Nov 2025 04:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34828E0002; Tue, 11 Nov 2025 04:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71668E0012; Tue, 11 Nov 2025 04:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2F158E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:21:32 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CFEA1604C3
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:21:32 +0000 (UTC)
X-FDA: 84097783224.30.68A4C32
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 863A040010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:21:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=mNRfCj7o;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852890; a=rsa-sha256;
	cv=none;
	b=yOdg41U8aEVt6QHoweNTKLZ3Tg4YrF5uwVGbD6/PRDensFPTzmjpfq33d+/r2RM4lcLhay
	kqeurnF5BEkFx3VpjxBTK+/dUT/f60+WVocd0SxpXMqJIsvwkvRhEGt3/OjJYd/QkicXVq
	CEnn0aDE7hvFWsuUTHXDVRN1q08cjc4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=mNRfCj7o;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852890;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZCVSqTQSDDLvQs1X2myYSkLJtZwbiT5pTgxLsDWfWg=;
	b=nNfXTF3T4eoiGecclNCWxDzvFkTZeJoedz0wtbWSBAxU7tYemMpvHBhnTkpjvhpVHpnW4F
	dsx90THFxEwi9Kg0Rv4HMyiqnMzoNitpOxQZvKzRwSXxeun+AR/AEMJDdsbfMtkft/lzL6
	uSGrnGA7KGfoVsjeZQQvR7PHankTmnI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tZCVSqTQSDDLvQs1X2myYSkLJtZwbiT5pTgxLsDWfWg=; b=mNRfCj7o5DsyadrTOAd3PG913l
	201C7wMUBSUYG7x8M00Si6M8oYv4ANGn1iKzb+lHWLy0+Lu4uY+ZdiuYrVf4nVdtMwESJEGFGxvEg
	ddUMj5in/pZybEUgy3WPRJq0oTRhm9nRH3ENr4LQkkaqHtn9JwhQXL2KtntemE79n/9mCYw1tWTfE
	C8HbTwqu+441Wz5LpaAxDcPcfWvtEtiBRfb3GrswMaYwTuDQc6y012OzP+0oXcxgh/zISf/Q5eAfs
	kusJonnF9/xByqdJJmx8Pfmts8z1PoUVa7JLLKkc2gdgBbXjFenJ40u0NiNLfONirl3XP70dRc+l/
	EWpH+UYw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHi-0000000BwxE-1dWe;
	Tue, 11 Nov 2025 06:55:22 +0000
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
Subject: [PATCH v3 07/50] convert simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
Date: Tue, 11 Nov 2025 06:54:36 +0000
Message-ID: <20251111065520.2847791-8-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 863A040010
X-Stat-Signature: ss4ycjcr5syquzbhan6sfryfj4qiy58i
X-HE-Tag: 1762852890-664152
X-HE-Meta: U2FsdGVkX19kFFn4PKiInIA9cvd6G6F4VpuvkBiRLvRo8NvDwicmM2FirBiDy0zY4+C9ZlDrayb9gTfBkcHj+D8iUxtUjCU3I4SRhqRuhU8FpxqeLWGsofPLdKzCF/lcxfDwN0Me8uYvl64EBUzXErrDXcBY27L8XFhpTbH39f+UtL58PO1f/NXNgDhWe5d7vc1LzXpuXtrPc0XoKFqZKuG8VpSEXm/cl45KbCFQKj5HFYXzZUSFbPWbagKOJQqN3BBj+3Op/N2/bM/gb4VJPCb5zFW5gBwsVsRDNv8EWDJ5+e034qvD9tJj1vaWl0/iox4sTeYh84gF64TUaWP9GcOYj3VVD+lv0dq3RTsPoExNmZBSOxBN7wjAoYtENQSQwGHk3jE1eapIfLoCk64gLF5wjd7yAzI792gFK48cNtCOtViujFHcwT6PEbCNxu1bU7IWRGkG3At+OSD3+iGIQ8TQEglkEaj3kTOpKKodZJ6sE9KGezPXn5A4X8nuq1iGzeaOnf+vCIZx1k6GEl51ImgidaZHqCyG1M5NATKd+Lq6kF7dnBdsmfMEV9bszD4nmTqGpF3d+OHG7XOd42W0QOT9ZaiHM3DqZKV+UYTl1nlClILWS45eLg91aM/azvMVoMchCpjJUpkXv6GuOHUBAwjixzp8Nc7GcKjr1QpUMsrI5Vb6V8BfXb5IDSITdsssxzPLUccdtmp1ro2w9nxp4O7Pp7Q0q8JCufPHTn3WyNyv58DgfxM8mI766fwTsfwEdGyioaWZ00lMv2jqQ5l0E+6oqE9qgLrrR0jU5Nh4ghAgdCbiSP8dcX1TyXrEx4Y91v9EcHpFkPPM9dlzpc66iSG0gcM3/gd/3zPsE65L2qTjHoXpC649mbbvCoshFCdz3x7/Kb/sP2eY8m/1t68+n0BqClxFj1Fo53WE0H/1b4tBdb/phy3sHLvzGtKPnHy6i9KMrJAJ0NiJXo2GuFw
 hDyDx2sz
 JGCvcA5n9U3Vcj0zgCY2ehCS4Xk+kwHKGOyxPQqgaRuS+PiXChaXeYKpJg7Ng9FaJYKDvvUSg9ENMJz0w+A4hPRINzgXnjJ5N3jmWHN4uvz+9z8ummvtivmqlGsbuddvkiTFRSiZavNsjXfcN7wVbPiWs3TBaJ1oNO/j43Boq9aW+9TeU/nt1+QFmCBoTg4BO13mAST2BKGu4JogqsiVo7awNKX+otaN6w59txYjBZLB7JCG/iyp3v+MP3nFTgGCKBBJTvdnO+iWIfll++XZZI+0I8L6Y30R9/tP3xAFB/aPf2G7iweFv0+v60XKIVbs+e+xl+h76oIflBfdms9YEnAXGjcoLuDReHYruTcqZqfo2Ule4z+njyOTjGT5utT2v6+LIuqCF7EHQyolE+YHO4NzfMQnRi+YpJSUcMVfYRa9qZ84=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note that simple_unlink() et.al. are used by many filesystems; for now
they can not assume that persistency mark will have been set back
when the object got created.  Once all conversions are done we'll
have them complain if called for something that had not been marked
persistent.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/libfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index a033f35493d0..80f288a771e3 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -630,7 +630,7 @@ static void __simple_recursive_removal(struct dentry *dentry,
 				if (callback)
 					callback(victim);
 				fsnotify_delete(inode, d_inode(victim), victim);
-				dput(victim);		// unpin it
+				d_make_discardable(victim);
 			}
 			if (victim == dentry) {
 				inode_set_mtime_to_ts(inode,
@@ -764,8 +764,7 @@ int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *den
 			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
 	inc_nlink(inode);
 	ihold(inode);
-	dget(dentry);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	return 0;
 }
 EXPORT_SYMBOL(simple_link);
@@ -798,7 +797,7 @@ int simple_unlink(struct inode *dir, struct dentry *dentry)
 	inode_set_mtime_to_ts(dir,
 			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
 	drop_nlink(inode);
-	dput(dentry);
+	d_make_discardable(dentry);
 	return 0;
 }
 EXPORT_SYMBOL(simple_unlink);
@@ -1078,7 +1077,8 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
 		simple_inode_init_ts(inode);
 		inode->i_fop = files->ops;
 		inode->i_ino = i;
-		d_add(dentry, inode);
+		d_make_persistent(dentry, inode);
+		dput(dentry);
 	}
 	return 0;
 }
-- 
2.47.3


