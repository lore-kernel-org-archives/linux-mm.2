Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD76ACCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 05:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0020880117; Tue, 28 Oct 2025 01:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BEA800E4; Tue, 28 Oct 2025 01:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31A880117; Tue, 28 Oct 2025 01:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6867800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:11:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 755FEB85F2
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:11:35 +0000 (UTC)
X-FDA: 84046350150.08.217D16B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD9EE120002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:11:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WS+FB8wn;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761628293; a=rsa-sha256;
	cv=none;
	b=01OB2wa2qy72AiVKxQKQQEyJybFSDbq7LVtBLV6Oti+L9JCautdLX3Ie76RPbBPjjTW2qK
	A3Ees68aNWIuyn2EKXfJddFQw28lLu0iOWAixFR4H1EkA79OVFCn4UeKjM6HAMFYg4jEV8
	2r7g2qkDG7dk2bMlGzLqCKyp+5HpUl4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WS+FB8wn;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761628293;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XM4FZa0do0+xkZhNaAyLfkF8FdfO7rZo+6nC0ji7Cc4=;
	b=L6ft7zHEIC0nBtL3q5+L51auXc+8pELAXDSG9790EjvHdq9hA1wtr/Edz9V6bBzK95o0Mv
	GnjUo6TYjSEacbIgzhRC/pe3Rt/tI2Zb2ROuMvZXeqargUy2/11WMqG9HFAR7jH6ZJkdfS
	Fo4Pq26kKNIcv9EdSgtKNgti9E3yEwM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XM4FZa0do0+xkZhNaAyLfkF8FdfO7rZo+6nC0ji7Cc4=; b=WS+FB8wnnvrg1STdVHRHhgtd3e
	vA8ZVpy0FVTwmwDGjCHc/2tiGcDQkk87YeN70uDxpICW0w2QMEcAqsDJXCqIGDXWDAgcCJQT5FLgv
	IU1uIxyHaIhuzZXuqtR+78tanMf6sk8IV1fzlNZL69yfV+Af2Upb49UTz4IjADgRxoaWJnca5sKQX
	AATECFXUnQxK2k3O9chDriGxOsLOR3+wEFJUafpfsa2m7AS9rX3yNjIxcIrfS+Af1F2DtpuBwBJgV
	tBZ4ytoVCKlXYk5skQ95GPhvuT0p8Zj7buhDSVwVyQEZVMEI52Ey0/J/+V9+vtlESXizL3+cBs2Xa
	mmNljBtQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eXr-29Z5;
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
Subject: [PATCH v2 17/50] convert fuse_ctl
Date: Tue, 28 Oct 2025 00:45:36 +0000
Message-ID: <20251028004614.393374-18-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4m1d3ktbowdk8jigq96rsozp7b5e1hgp
X-Rspamd-Queue-Id: BD9EE120002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761628293-634554
X-HE-Meta: U2FsdGVkX1+Xo798HMvU1DGOmlgB1KUIndW0yQIYH3I4mfoVE0GWGLAYxguduOr9B/DNEVgpZ8RLj7wRL1bON+hF+E+uTsZC6GwJDIv+4Sj7rMcD598aXPkPEImbP43Oyoczhi0Xm2X3VFgyWaM2TAaWuqoyUsX0OD1mYwQMq2KHY5JChUfuHp8cg9hUrFSjC+XKtFIb6iCFmYDEPIX2GgXa6WCJkJFJyfiyWKPIpx1ns0+fofmzCjUAiGv0WAOujcSdaa+xI5HgjlISnLJ3wdk+8wSsD4rlxMyWIApRM/nrNj9Q4JwlIDC9Z7lII3qqvu2WY3Z69xFgdHSYyk/hawKSA7eBiZGovEXwdLYJIS4u3BcxR1aMKAu6i6sTLCc84e6/CnSFL/dLCdlPpKKF0xRMWQyHNeBcU7LdebzaDFW42kRli2NWgnNdv/moZMsfrt0DBcgVwxFqHyU40r6R8QG0EvA+dV+vNDQX7gUn8Rnoq1WDQ7TvU33d5ksmaga7HLxS+swYX282sABeHgiJNDmji1jmt1tLUrb7DBinmR+bKDDYJjL5MIrfuh0jey2UpwNJyCC4YysX/G8vI6JR/Ju5UsygKeUceix12e/TviR8XvcK4fQUBwpo1AhQzkTk01t2hFy8v1Td5TM18NntsFHmrX6UGWHW9dxyZFS0zyzLJgzEZDHs0NxRMkC85dkjrt8I7SLC/yZk1MFL4W2ET8la1edlfq55er6tkiATsO7GMHSqkNn0HiO5ESabnqev6T1QDIwb3f1XKNJ2zFhnRs8mTnMaU8zrFQIJsMe4gheckZ24RqXc0DjpMGPztcj0bfdb58BS1badzpqORQpKM+XMn+V1K7beicM6nqWj/gW5ZMx+ThyzJlsvaR7nxP9Nbx4ZIYG+vb3wSzHkYD4ZshBCOBk6lJxzZkbWhD3berQBLZVA5ptFa+eyJ3zfzxAsSesjpX3gMcHOxdXWRnJ
 N/Ex+elA
 wjWs2s86YJHxz7VckbdU2x+CybIRdhkC6VPGO+Y0kjaou8zIJYCGA9o3vr0rFN98qxx/szOe8ULJV4uy8lRGY2qgAd8rlD9XN5scHvC6cF0TeZG0r+C14pVvw73sBp25eH+1iUKm0lyZbz4NQvjqFhy4PFGVmqjzopH6PiG30n0lHnbfGP46bg8gLciR0nYDrIRFbOZCbBXqqvuhCyox2ZIXpR+JcMZXsgqbYBXSFD+wrGgAaWcF3fQVHi0n5g0fJJb+Q/vjDyI2D/2plIhnUfc/zKTJlmwIonPdRyRITQSD8KGw1lu41xSjshDYO/VtLAAHp1Mju7yaTcz5DPuIQe1yPXUyDVwCoHdQP6CaOlW6rvU5cNOC0NyQJXSXlKdTDSnW0zkWIMNwHd79bvmMDlQ1RLoXhnEoPz0OiiY9eXgOyi7JTkUdx+kzBGbor6BzHhpSUxtu9VJzwFRlPpVUbxKlAfA==
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
index 3dca752127ff..140bd5730d99 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -236,8 +236,14 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 		inc_nlink(inode);
 	}
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
 
@@ -346,7 +352,7 @@ static void fuse_ctl_kill_sb(struct super_block *sb)
 	fuse_control_sb = NULL;
 	mutex_unlock(&fuse_mutex);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type fuse_ctl_fs_type = {
-- 
2.47.3


