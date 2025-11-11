Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F74CCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591A98E001B; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171AD8E001C; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF52B8E0012; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE55D8E0015
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EDD316042B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.19.E049942
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94167180005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LN6CRJ2n;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXGw1nJCnekakkZR178NLSh8+iviODtKUClSm5rridQ=;
	b=f3TOH8vXFa2sbEYUD1aaqDgfWdDWxe6tPpwqVNUHMAoyJQbFwffiRNsywgpnaOMxqnfKpp
	9O5dBl/5Trte7jqXJT6ZHlVrX0wOALh9DcI+tNjrpNha4R6CYDFZvThBxJI2ol8E7oTxkN
	XwaZ8MgGluDE1CuWuLzQDkTRM0nDAlk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LN6CRJ2n;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=fr/XC0/ZmNBmS5ruZnN9a0cvUlZiQL77yKzxDPkILSNW3G0iraHAbaur3UMYtAtgp6rCCd
	R3Gy+camyJUZ10aS3cUM66ta92JnliUlQzXflY0yIMzAGzRsHESdTJBW1z+1UGl4FwdxPj
	3Jm6GnooWwWgnjv+CN8U69AVKleScdo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nXGw1nJCnekakkZR178NLSh8+iviODtKUClSm5rridQ=; b=LN6CRJ2njLT76zNgYlaloendZP
	sUs3p5zjumc8j/z2khvoDt6+pnpIkisW6gygxsWR+ifalIz1V4Yg5DAQ9FtJs7tAbkVTOk4sQFzEE
	Akpdo+3J8ogkCfh5OvJpyvM3sqOb+5OBZAHsB5nEDbL/doLrK3VQ3BXxoVw3mc0cvWpZeEKGJpK3+
	3I01Dow3QlFmu3TPpN6GW7C0p4u0V6qh6lc5uZmhE3vSZBXAHA4H6KxaKJeeh+6b8Bn7Psl1wdOyZ
	REPNGf5fPVNcffpJNQamrqIiuww6WrjvNELA6e68M74n8WF3URvWF9NFN47LeYZylNTGsroeVQ2D0
	f1oMDRWw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000Bwy1-0ZAJ;
	Tue, 11 Nov 2025 06:55:23 +0000
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
Subject: [PATCH v3 11/50] convert xenfs
Date: Tue, 11 Nov 2025 06:54:40 +0000
Message-ID: <20251111065520.2847791-12-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94167180005
X-Stat-Signature: pqedd89wscc4cpcw1psprmozzsbemag4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762844130-333327
X-HE-Meta: U2FsdGVkX19QB/nj35267T3JqfyMoGfYZU1qAvb4Th+GSvLYNNR0PpsdzsQj0y1xKgOCJPc3RonQXAsZEHk5xVx4MhTcVwRDlK9FhuVPNh0IfN/lOuJlHPEevaR025bvKh3ZhAbW7KL1VP3NR7m5K6Pp226AIwnWlHMRpVbxwJ+pdiK3i6SW6eylUId7fAQdqoiwL24ay6L37JRS6QgsNcDkRk0klxBlIWIvJ62KioP/rjG8gymfmI5oUx9kivjbcn56RSZYx1YQHAMJYwDVj8d42QHRAvE5q3JtuX5zSviv48GSAvQaj9KBKFrqXjDiwKG33BQqCu11WcB1OYs5UfGG3MbPfrXWgXN0nxRfYi3Mq96BSdhJCbSMiZnzyX9fJ0CV6h/FLf/NZ9Uj+iQu7QjDD8qLcJVFLkpIAtXqWMjZyEG9lO6tuyxV0s9uzzm4qNlx5n5OQAgeGAZqgCxOqRPcjj5V4UU4Vk9cVXtEgmUZGyunwNA0D19Fvx4bFkUrhoDtWef+aOEzxHzVWq+1qTWqMW6gzO6x3yo4z/VjuRwMjg7x6xBHFGCxkORcEFeB/L4vtVo9883MFoxuKM6J5xMClIfzUSrPDjQWaiuqqH/JE7x46Cwipm0ylBnkC7qZZBZb8jEgL2oyJiV8QBajSrgXQJI4XaGLjsNq3nuPOkP00aZQlvmS/dLm8MBA6VfgTAHO6Hx4VHtC6gZjNo50rEf1Ida3W5lHC/Q8+Rfxq/Qwyik6WyTsTtV0EJFlZgejHyOkFh78e4JpunZkn2ZBQsfnLeqVEn8gt91y8R5y0YIcdlJLFcPdYgh4IlgcIUaL2VM1QxHOfVY6rnfU6oPM5el0IXW2J8KaZRraBJlCLuD5wSwaX1+reQZYD5ICOmQOAhcVaKCKKjxRZNUHBdFdLE4ktfihd/SxWmHOfXn6+EOrTtLxHolECt3sUEFe4YWFJF9PGk6ZFyRcE6Vpig7
 eV2S5Hz6
 zd9qvZN5vQRX3+Ss72lAMitC2Tw/y7IFRZ9nT5SWk6zRWPpDU8pK97OuCoBI3y/o9cs5lYli0tYgWeoII9fAy40F5XUHo6c/DdV/TM8Iocx7flP2uMjvx8HhFccR+Xv5etjFASi1qQNsiGhXjVRbZzFYp+x08V6cBU2kg2kKt0IsQRLNG6htsFFgyAW0hPUgvnudAAskdpI7lmB5gjPBvD0gS4VAVR5II5VhqrXR9t/RJz4eUmqTgUMSsHE4T1gcjKBVyUsNBjEIRZsA+xKNdbZvwAnyyD6a9DucIdhJrB7TKug+SyQ+Mow905L3OaKqhswNzzQ5xxm4peEYOySxHEAZZedOBAeNZtdUCIaUJiEsl4utGtLZNebGBmxvJi4uLeipsE8EAx9ePLvLVZ2RojbAb8teqEjWz/v1ptfNzJoBy4iJM7QjrhVC2coZEmPp1rvUbcd7mtrL7Drw=
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


