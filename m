Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE0FCAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 09:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037F48E0006; Sat, 20 Sep 2025 05:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F718E0001; Sat, 20 Sep 2025 05:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FBA8E0006; Sat, 20 Sep 2025 05:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D734F8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:32:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BD61C0937
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:32:03 +0000 (UTC)
X-FDA: 83909112126.26.5AEF7E4
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id F331AC0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:32:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jaQK8cKf;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758360722;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09KvsjW0ORXF5yAgFsWr4BmJpUanJ8JfB+m1F7eGQps=;
	b=hCGUFgKkgwWmCDqxJheLy9/7P6bjjJj2YMFKfVOAO/0aWthbfeukd9iVbD2QkM/TXOcQoP
	STsv82PYzCc5i114YDy0yubJ5itGYokdwvapTb68LCB0OAAlmmFjbQQHel3cnWjGZ3Rvz8
	AnpEsWhgyp3HHMf/CE/ryp41roDhUvU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758360722; a=rsa-sha256;
	cv=none;
	b=5fXl7qJSqp5Z+e6ULiXd2uTwYO3UcdGlLZQa+ZmknirFQwnN3763XSq8tEK527TvR4a46f
	Kcjc6zzukg0+b287Oeyddbqd+XKmFmkgjugm9hU/U8GxyQ1e9OKryGBaNINET5vvPCVGOg
	HDliOuDGJhhGjWayYih/MxRH1l9GnsE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jaQK8cKf;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=09KvsjW0ORXF5yAgFsWr4BmJpUanJ8JfB+m1F7eGQps=; b=jaQK8cKfGBnniJ4xeduBuQ4mdy
	Z8Qh0j68aqBnrjxEeoVTW67vl2L9GR+wcjUmE89Mle6Q0bb7rqeHVynY9bc9tpgu5c4WmNLaHTz8X
	pFRwaQvcdhRslmEdhfemL9wmhLt/ZRnjNK8/6wVMphnzkYT81oAUr3WBFPmzUNXaKcTJoPn5wwBwc
	3gT57+VI+M0C00eOsH5pS2UWTzhm3bdqs39h/XrVkl+cBOEFT7NpLQAwdCOKXhmimfGv9/rNxJhf8
	Nk/W5J5B2wgPV7mcNvQdzkMn0mOJWtnkhY+5Q6eDuX1azINcV1hEDsPAZ76dQYgApjHI3y0T0qVvI
	VWGDlqAw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKC-0000000ExGw-3OF2;
	Sat, 20 Sep 2025 07:48:04 +0000
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
Subject: [PATCH 26/39] binderfs_binder_ctl_create(): kill a bogus check
Date: Sat, 20 Sep 2025 08:47:45 +0100
Message-ID: <20250920074759.3564072-26-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F331AC0002
X-Stat-Signature: ogeug7js65bcym99ksrmgh7r8dyeckyc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758360721-89707
X-HE-Meta: U2FsdGVkX1/PFItzLubujLXkZAWWkkyMfrBpQyhhgyLgJW6OYbg5SY/S/+9YVc3UvjepFoR7G9/Dp5xPfSXB9tn8mLZp4n6VEiPaP4D4sCLeGxVSvjF21qTFgmJsNORKCN+qiDL1IZolXbnJ3M8HCPZh1rnubVr4L2nefHCLSk5iVn391tMy2wQrs8PaxgPs/Gf2eKVLO3/hp2Rr0OTkdVlTktmXTsVu0wuSTpOMrjgvziWUCPerj120qlHqdQNmzczVwCr2z9Jo+bRZE55kIIxtloSn2YBn9qMtwEmN49aR4igfi6cy4trnwgdQ0NL4Ncx/G7yQwpLtlYsfRxU8+U3e083psh5GWdPUoqxZe+Orjn3uYr5ao75+ZZ0OS0E0VVIrYJKXD8l0/rnsjVVUStNtiuJD+3+bkDxwihHeoo6GT1hiXMu0+/K2HLhAAhf4dQgKapaOyVKXtZG0LXKwKtvzKyemuDdw6Bcqp0CG6UxGuztbe2zkQJ8SoTaMDz8doX/E7iBkNcwOi33spavU9PBhVQlROf//Pa+cI0joTpZuTsFIFJDjD9htEjJq7F021eVlQSah4eq8QYsXOW+JIhyNdt5FzlSyNEzUIr4x5M9hpIGCsOT3II5P4CreJlZ8duYXeIU7UkVFrvrtKpsdPDfZI8xiu01fEt8V2PwZpxzcwWlLXcq2ReDT6AJ+NfVWov9fA2GqjkPvuZWuONLZLOligMItRiFMN9lrEb66aMT++oGZ6QWswKxL8aUz00d9ILiQrrE5DKnK9PiFzgf37PZP9XZ8L5w/3Zfs9mzwfRfjqdXOOHKyFW+5866bKgh2KyIPrX5AduT1ikpVwbsFBNRAS5RTE6p2XqvGHU32KAPXLwSXTAAGP6COXuBMVgrg9hprOxRYpIQaQIy4Ex4AXMKQSmOx+NWgisLkX6fHj5PIJ5J2Ki6F6d0EjqzcchaTgdF3s+wgxEhkssiBoBk
 Cf7RWtzM
 nfIwfnhREKLOqmh93J/rm49jjP48114FW7ortvvEwvYuNQvqTWzbqSlQGixrLqevdmTY7vOiZieFfxy5G50am3RoxwfswIzKXj21mjGnvPu0Q/fgKdZ/RJTDU6iEHx6nFht/A0Re1yeBoYxOYUocWwDM8+Lrpt7tb2PGrPBKr+MInpWjO6KMINDxotFv5BpQUlyM9C6/i7wLu9IEsd1lcFX9or69HoCMzGpv7tJ9QR7lozU3PrQjrh5ktIklfYsFyeZ2xJHpeMC/01cTNP/KG/us00V4+PUaqYz6Uoznye+5QD/jd1zDc6INOCOHwYED5daIo80qlHVCbGkEj57LrNp/LaLqQeISnj84TliyNbCHvz3k46I10jTdwjhu6y92AonWfycv4mBZJsEbS3I3HCBbrCxl6p17n8FgoKXmL+r3oP3gIHxPyVjflKbZ7jaxh7cXZzQx3uleNMMk7x2sygZa+kvfbMSVt3mBvx1Pk8MxK9X4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's called once, during binderfs mount, right after allocating
root dentry.  Checking that it hadn't been already called is
only obfuscating things.

Looks like that bogosity had been copied from devpts...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/android/binderfs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index 41a0f3c26fcf..bb81280a3e9f 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -395,12 +395,6 @@ static int binderfs_binder_ctl_create(struct super_block *sb)
 	if (!device)
 		return -ENOMEM;
 
-	/* If we have already created a binder-control node, return. */
-	if (info->control_dentry) {
-		ret = 0;
-		goto out;
-	}
-
 	ret = -ENOMEM;
 	inode = new_inode(sb);
 	if (!inode)
-- 
2.47.3


