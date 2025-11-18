Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE4D7CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108A48E002D; Tue, 18 Nov 2025 03:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9828E0005; Tue, 18 Nov 2025 03:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEA0C8E002D; Tue, 18 Nov 2025 03:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4A5D8E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:01:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CCC613AD61
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:01:35 +0000 (UTC)
X-FDA: 84122983350.15.A5860DB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id CB6BE40006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:01:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LeMawiHQ;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763452893;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZCVSqTQSDDLvQs1X2myYSkLJtZwbiT5pTgxLsDWfWg=;
	b=aIt6O+nXhhXwhAP9lw3C3AoSKyNkW1alkGdhboDTw/hIDPizqhgAEDuNajhq4TVUPw6A0x
	da1PeiHnxaTyCM0gfasCT5l842WjpIQ15u1afPtqZ3Ypzn66TVpnBJaHDbzu3/qIvRQcjn
	8vujau8j9x99/LFBEgjxAKojv8zVRuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763452893; a=rsa-sha256;
	cv=none;
	b=qDCZbYYzHewkkY9h5AKRSyzrJzKIWt+PC6JnguuN/qrX6BMq3ronk/B/pzbwNB2uqzT/VV
	9G3PBEs4NcUqo0da6/zmzfHwWJ7XgiT8IcQpObYGSJL9jqawA5l2+KTQZpF0HXZ3KoZfdW
	7WXBKU2ejAFHAUMPCTfiT8e97b0lIMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LeMawiHQ;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tZCVSqTQSDDLvQs1X2myYSkLJtZwbiT5pTgxLsDWfWg=; b=LeMawiHQ7jKHSt76eutlBW3Zs2
	s+rZfr3ileWw8U0iBYcz8v2ImHtWAxoclxDit7HsWTNNQmQKOMJkc0H1JsL4GuhLFLZAMtpbJFw3v
	5sBlLWQgFe0bcX9zWvwGz2Giq4KokVLbCiwbMNLTfCiXwtxQVQZeLPKNNBE7juy/rmT4e3GALwTZ5
	PEyKCfonsy9yCOuc26nYqza3cVari3TereVcpVEUdC67qgYTv+GiT8T0E7SLQpJSYJLJKgWMdFNWd
	Zh/sz9+hFx+PvVhRl7jo7ztL9IWysDkF6r54Lx6xBC6oEYA264W6d3qLG14Ze+qOGrr/0NYrKK5Sb
	Q2r9AhKw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4T-0000000GEQD-3C7U;
	Tue, 18 Nov 2025 05:16:05 +0000
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
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 07/54] convert simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
Date: Tue, 18 Nov 2025 05:15:16 +0000
Message-ID: <20251118051604.3868588-8-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB6BE40006
X-Stat-Signature: eokpwwrh64o9i1ggdqhr4mdswibrezaf
X-Rspam-User: 
X-HE-Tag: 1763452893-611343
X-HE-Meta: U2FsdGVkX18xlAWF4sRInVBcQRoyzLjLKn4cdMHv98vDbkf7dfAaK/2ym9I5xdj7oHslmG/YQR85T+Lca+NKSgDWSBgsbE0t74RMM9kExCZvEko0NQkF8Wr+duHmQDzNrMT/Z9CIXC6I4xYMtDxCfIpXbGG5h3yxGJqWQK64BXzO7rmcjYKOYh6/zOzqRwJ2cSelJUfPnolcoHuz5Q28H65SolfmWswsuVE8yKiK+NczDadVV59h56LQ0vdCNmz94soaX5aZczR1JWcJDD8oWC0kmigKdAq0tyq1a1i63mU+XuqIvvN91vaahzE4a2v1u8ix0sW/U3SNxXb8mH5ltgrZVnl/4o2KDeolP3TAABYWtny3p4m/q0XBvMBDnKXTLxoJRo71EI97SUBpo989ilAHLAAClGZZlOcZS9Pdts9l5mry9czUZFyRAhJkanTI8UpP/imGvGl7tMLOV4qbsnegMJv6wrmJW7/Xi5wRicJ8L8f9L30Qo/2e+yHrdPufUFhA4C9Tr9hD8/LmpIgKz6MxgxZVb4/0je+8LkVyFV5nBz82h7A1W8a0/E5h+D7sXMRxaKDnUpvOSimz59Rj35Ux8TVlY+9gHmGHfFPY3RofDfqfGeRwLbMBLSpqWFvOCdX3MT/vAYWB40Bw8Crre7QGsLx4QYCi/mYR5UomzRRwUdbrOpJRxQU/RVWXoOH1r+Ez7+vIZm+kkmXzV4lGRHSb1djn8WuGzqU0/RnxSagytu3Hi2X0xlVZK+xmDwUdMxeZtzn6Mdajq5xw4zy8U1NvEZFfNtcQjp7bHjKLmLBLemt3xM9TjezM7TACmR9lQJT6mH0IS2wkIeNs6Il2i2YmmU9qB21voKwrj7sQxVd8GZgLEHfABmsGJZLEMk77c1c1/W3yyQwMhFQq0j0y5ZZRIq7C0H3mMRauJTubX/M5lCKei/uARH6tnSniUIF1Q1xgDupGVV8Ty939Zzl
 3qvQ9G3O
 +Zvr/S4mAEcq0IlTNUpc4zLQqo4yiRzsFYVuG2VggRCNuJbtYkoKTwfXcvOdgAMSGhLL6PGib7LRSD8VqNMlICB83/my1klBT/XARgkKjOzL/UJJwYSjRysEJZkn9YYWWiq5qwaI+NwWdFg3EaRHPMhmw4E9cQ6TbvB+v9ZPnCdLbyeS7v7HIEpQYyD4sm+8A47v+tiIUsKXQqsGc4zGH96YnqfB03doxH72lfAWa0qxvwg6DthHGgG2zE3GIqD7a9wfdsH7EdhvSpBvd7PBPBo5DolVl899fYTSl8tZQcWFIJyLBwTVRbr2D9bcRknMD6npUHXOUEGFys9MjfDLVv6R52e5hxq1YvvaI19isk2AbZepMdglwi9u4U2gBF7kGN3L54BWSbgbecstYWUWJzfxrCVWEshpOAPt+Bdm/n/iOtQE=
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


