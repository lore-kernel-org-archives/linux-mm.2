Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4678B606F265
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EVGCHwqf
Received: by kanga.kvack.org (Postfix)
	id 6D1A76B05FA; Sat, 14 Nov 2026 08:10:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8EF6B05FB; Sat, 14 Nov 2026 08:10:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598756B05FC; Sat, 14 Nov 2026 08:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 392616B05FA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:10:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C094BC03FB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:23 +0000 (UTC)
X-FDA: 85433758326.28.D0201DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DE40C1C0009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVGCHwqf;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661822;
	b=qnY3LrgUmJA2TpE0co/lANQrhgPSF3i6nDvRi+dLtxOK/1KnVwi5X5QjAUMuyJgWpxr1bZ
	eXVlJMRKOOPek59qbuAdDca5zqpQgbMcMse2bRRC6nL9zDiR0IhhuJKcF5BmtOBFcj6Jy1
	7FgM34btItBNbP1jQS6xsY2VIxK+yOQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVGCHwqf;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+pArOqpOoBplfHr9snTfME8dVCmOJulQO+pgRyRF3E=;
	b=FijlGbCtN3ePhfZA53A9FLG74WGkglLONpWstvNDHnxljZdR4U5GLq8F09+w/LmsLUqjlH
	L1+928+ne8Dn2O0P5bkv6NBa6Cob1sSDi5noo52GUbiSzFF7HfpWV0Ohq9Y2bmHxm904Ry
	31l5Vz6xUbzXeVxvpDVlTlQy2XVUTeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 337C446617;
	Sat, 14 Nov 2026 13:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35BA1F000C8;
	Sat, 14 Nov 2026 13:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661821;
	bh=a+pArOqpOoBplfHr9snTfME8dVCmOJulQO+pgRyRF3E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EVGCHwqfavnzyYWwg8CNbf+NMje4pYsmRzO4uRlluRknVppyhMQwl/Xn1dc4lVQTn
	 ruS7elO1g1CE6zkcNVbBhOypAqQ6cogKC+fQapl4eNzMeOWFBFOUggmOAvl/3/CBKm
	 tVH2sJeGVPORhkQCuXfl7i0pmbYK7UO5qMKQ0+yYxUUjBTZIkl9hJST9OdybQ9ZLdd
	 N1lnjeaub8wbrZ4b7GY9/rLuY/DuUW9JtJE2qZlClx052vFvyFoOC0s//WrJS038HE
	 Ss5zo8ByYQkX1cWXp76pIaVs2NtnJ/wyksPdtrmAyoCaBIrgSAQ7WnKMhGs6/zmhnL
	 fA4imsmmqe1hg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:22 +0100
Subject: [PATCH RFC v2 41/42] acct: refuse files on pseudo filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-41-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1701; i=brauner@kernel.org;
 h=from:subject:message-id; bh=X9op73Vg/rbRJ8jAI9whdelkoA5olyJ3Amw57HmkUx0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iJlazpvzbLvMpMvTXZYJLrVnld+VU3KJ82bnqqK9D
 l8YP2fc7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZgI2zdGhluXrrJkiL3/Ibwx
 9O7JZKtJa33CIlmeJ3tGRBXf2PpLup+R4Uj6Bo3Tn0/1LZxl8HOt6C3z0ims1ftW7tm+8e27F3f
 2hHMBAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 93ms3hhqjkw9k4tphx7tfbuthabm6wof
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE40C1C0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661821-125329
X-HE-Meta: U2FsdGVkX1/PUCH4NIwRJ4oEbi7cJt9Rj8Jv24hZuyAG/MNm4GYK8hkZSofZuToF3a9MPA0w1+aHQ6VfhPChYL81CaQds68jO6LGcN1kk/XdnesiKELTzdkcD5UpoTqky5cONFIhiRQAs+8UCOJNHncZ8pWi3x924mqKuyB+puQYDesb7+73UDCcRttfF6IocwN1oY+IFEw4QrJQ91MrTQz9VrkTO0L8OK7upd6lXWbhoRXagUfpYB4zTU/yTf0RGVrJLVAwAW1JzIMKJJHXvowaWOxmjzTPSF8d1A4QFAcpUEtXsoHrNXEY1Y1Om5Bncb52Erc7v16+CtJ4PF67NdIy9xmlfK52vB9w262asQzbMlv3R4Ba4HY/5gb2lHCleZsnnBmZcvQFWazhGtCU3SPqg13ylqjY4K2MJqtZGgrPwu8jZW1bIOhWkUASLsOAb0cLiFPpj5DaKHL8Hx+Y52TXxQRL0GgXTPxrfzuHKhJsNdzy1UbC6xOXRmLdA0LpG6XFDy/R6b19Z7+n5A8jKS3HctICZC9txUM4hR9XUqbfEIs/HI6DopvnRIEyPeADMGLzBHI15D6cRxAbXIFpVYLwR57ISHJraq80fPxQsM7mv3WTZQ3k0lNwI6Bu+swZGFE2zvQ0gyxqUIr91HvGQJ2jYShkReSDXP6qc5vxboEBN7HHblf+YIgZTbvoXY/m1OzKzMj9qZQIQ4fMyc/qYArF1sPpoc4cx2I5LjGNUbQbI3WjgTdXCrZklCZSdgbTrrMgT4AbCTZcoMzwvjA/XWzgI7oGbbGzj/qvP7A5MTCl6cNBE923QwPD6obJFZi4h/w396Hm5lRgz0EOlVTcgNX85yU8uRn3NjpUlVHsSjFRN8Os1hC1mz9HvRT5rxw20EfDVifbK77CqRKi21pNQnftMFx+sZzGZVLoxuwzqu8iyu/c7OSSvfiInanw1ai0uusdIQhTD/MnKdfOFcl
 wcIsOC2j
 iLfCmQnh9ZSXL3R8rnWivsNuIL0ar/HXt3oHvGHnOZtVwQiZboKiyBObzfr7HFFuIZWc7koeGobxN2oxtJiRkLhHBjPnidvIT3MVWsfb4dBbCpQW/2awRlF3aHnx/4H1vpIcydlQJwusYI0+wi5Z/ikqIBmcwN3HzCNoxrWeuVL4maG7nDnDqg/HlbKNg6EZEEAfJ/bRvNavPlOw0DjOqF7JNYsQPaHN/2MPx8wSXMrmFYFFln2M7G0mOV1X8DDzZCftmEIShtA21z9igB5+w2Rd5Tu+tvLLesXkGtv62oLKVddeNs6mroIHXtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

acct(2) already refuses to write its records to files on kernel internal
filesystems and to procfs and sysfs files. It recognizes the latter two
by FS_USERNS_MOUNT_RESTRICTED which misses every other pseudo
filesystem. So a cgroup2 or binfmt_misc file is accepted as the
accounting file.

The records are written with the credentials of whoever turned on
accounting so this isn't abusable the way loop is. But files on pseudo
filesystems aren't a place to store accounting records. Use
file_check_backing() to refuse all of them.

SB_NOUSER doesn't need to be checked separately anymore. It is only
raised by pseudo filesystems and by tmpfs instances that are either
kernel internal or can't be mounted.

Suggested-by: Alexander Mikhalitsyn <alex@amutable.com>
Link: https://lore.kernel.org/r/ae189903d4cda27130317a9312d94b53d07415ba.camel@amutable.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/acct.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index c440d43479ca5..0c502f778fde0 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -245,11 +245,11 @@ static int acct_on(const char __user *name)
 		return -EACCES;
 
 	/* Exclude kernel internal filesystems. */
-	if (file_inode(file)->i_sb->s_flags & (SB_NOUSER | SB_KERNMOUNT))
+	if (file_inode(file)->i_sb->s_flags & SB_KERNMOUNT)
 		return -EINVAL;
 
-	/* Exclude procfs and sysfs. */
-	if (file_inode(file)->i_sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED)
+	/* Exclude pseudo filesystems. */
+	if (file_check_backing(file, 0, 0))
 		return -EINVAL;
 
 	if (!(file->f_mode & FMODE_CAN_WRITE))

-- 
2.53.0


