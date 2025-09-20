Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6A9CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797EC8E0007; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228B18E0013; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7598E0016; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41A0E8E0012
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F25721609BA
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.05.F734809
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B0B140009
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=o3oTpbJK;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXGw1nJCnekakkZR178NLSh8+iviODtKUClSm5rridQ=;
	b=pxOrQ6Doh/bs5soG+iQX3YczrL3+d3iGMyzUmu1vE5eqNDZN/eQFw34en4+AxFm19sDv3x
	3CJEVe0A+YuRj3ENnaKTOMcMzcl+JXDIpRJb2KyYN7BaDADvLpsaZSPpS5A7509YKakW4n
	rc7qaB7s+CZhp3d/xPssP3XLL9VSw1U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=o3oTpbJK;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=apu7DSVk6DSqImzaNd3IzwZwgwFjuQBd5ltfJuGOq/JbIL0Y6AMjWHQGnRM0t2/7WrdMy4
	Ode2j2giVN0ARrBd6+Y8UYzhh4Uh71ZIkF/8LkLEsrovRFuISMT22/D888FOBuJ4ys0mSk
	RmhYqRz2qBIfiEKArLKcxbNe15NmyAc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nXGw1nJCnekakkZR178NLSh8+iviODtKUClSm5rridQ=; b=o3oTpbJKkO0Lf5LxTLzK7R+SjW
	TY+nHLhBwrZkYyS9WBssOe4sbsADlN+jFSeqzXZkOQjGi2O4Aeo4KhKCAL+uoM08I/W6ppWx/eK1G
	YY8o3Jj4jFbuvUFckeTwI7kn0RccvdITK6eax7xeINKs4OwT/iQ0BWdCvr1W1NtLfklNt2YFIfGss
	68ABYs9XQgrWJX+naaa+H9ogU1NzX9gubWis+XzSZ+Z7Tx5H+qt9YdoGGZ7ruUliSz3cMb8b90ji/
	7Mbnbd+9p8UeOzS7783Z6QXJvmks9Z1wfcIsVpewlB6Iyx3Yx+N1W+Yy8PBzZxrdZ5aUqlwZ39did
	6Uy9Kuyw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK9-0000000ExCj-0reI;
	Sat, 20 Sep 2025 07:48:01 +0000
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
Subject: [PATCH 09/39] convert xenfs
Date: Sat, 20 Sep 2025 08:47:28 +0100
Message-ID: <20250920074759.3564072-9-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B0B140009
X-Stat-Signature: 9taaggk1fwjnf1snq8nkxu11q1s9waiu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758354486-62050
X-HE-Meta: U2FsdGVkX1+VVfoqosnrzslwGWieOZ+dUxrZ/mS5hu89UutCqToxg95eQa2igfSDqUuYSmV+J5jDXwzfzZ+WedKv+yVO6TsUrDyzDnP875BjQCuSF6kaTYfRYJfpnP7AmeyMwZ7H9gyBtoQ0L7TUwP/Vnw3dNfW4qbDGwRaxfcv1BdPgsyHDHEOG3RKza8xke9dFEyw2RIbjE2kgYyTAQfcTgHgPVWfsXQbiRXykgbl1sQPOlVOORnr+bQ4E4+gn5El0sn0gV/p/cAU58JH+vS+/mPdPIVgkSaLvk7BtOv1hbtkU6KudM7xKYwpO8Pp3IO5hC27QtoA6vCSjXJFziVYZQ2pQ6UEPxRq4cxwbV8otmMR0/4X4ij/IViXaVkUttP8/XrMAR5ZWZM15X0A0PnhMKAXh57RPVMYFJ48Rp0nu62tYr1ghzY7iytXonrgG08IahhhMhBI3DO93tcH82vbZhNVclUYMiurRP9WOP3dYEWXDy2J9l7WrIS4R/l7hu8IxhTW94OAi0+qtMnkgkc/v1PgteIye/FZN/oF4uQ4lIGFjlyjFcGq6ty/n/IgfedIrjgxa39AQRgDrYI0Tq+oTwRG1GVgONyU5LMXqokYLYaSW4BJJQIQ29MrY6ib3ebmJQxwqkcA1bOE2ey83QdezAfX9vVBVpQ64c4oE6ys3pV0zBT2tDs2Ppt4yMdZeQx+q3sq0+3I40ELxMLuELpafzb8d0/iZiwLbk0YLu5nymFAdJljj2LEdIe3W2CfgevxgO9xMZMnJbKJiA/kQo2biKCFBubMCHhhHrgsuoRM4i6OKGdWVQ0PerQzZSX8cX3kRvCIHTTSMLrpHPFR260Uapr24hkiAX8EmmqV85hsxt/BUdM3I6ofiWHREMowA7wZ0FBFDkO/oJnmcTEJR9tb9UjMKSfMqA2rSIYQwBen8ONBC11xIKNEUFtkthdfIpd/bo75ZyqyfkyRV6lV
 iist9Fwx
 6hoMADFnUosRvMjn1ff7osFNErK4cd263fVVT/B1HmulWxgGckKLLWL1NfM/0Zx7SD+C6p0vIwelDzYg48NAyepU22O7HUvIgsJnH+A9S0fS2FjbFg+HaROs3GQXr5Hpxx0T3g8i38OPITgHk0Tp5eER5iFd9ekxDyPJ5A2QRVYWhtsVaRYFCtsj+4IIAhgoEDzDmFeY5sih/7rxyO+Gg+/qbAJ2v8/uCWmhpoMnrzJNqswnW0KxpUhksMIFhZfS5VKmPzZBAsh5nIFKA/QBqGd6RnckazWBcN4/0K6/RHP8M4ORYEeLwJitnL65+vdCwIEfuJ4JNAty5jgPAlMiRmYZsg8xDY4U9qwdMjLPUlmo1SgsfP2sdcfmhgP4Q/E1vQJnu+J59cOIzhXDsa14iS2+YdZwW0WHCkz8LrVy3qygYAuVp1CM5EpD61E1PL773ol2e+zl0y6L26UA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

entirely static tree, populated by simple_fill_super().  Can switch
to kill_anon_super() without any other changes.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/xen/xenfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index d7d64235010d..37ea7c5c0346 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -88,7 +88,7 @@ static struct file_system_type xenfs_type = {
 	.owner =	THIS_MODULE,
 	.name =		"xenfs",
 	.init_fs_context = xenfs_init_fs_context,
-	.kill_sb =	kill_litter_super,
+	.kill_sb =	kill_anon_super,
 };
 MODULE_ALIAS_FS("xenfs");
 
-- 
2.47.3


