Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990D2CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023668E0025; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0208E000A; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27308E0033; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 351ED8E0027
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4014589A0
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.25.A155AAE
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id EC2AF1C000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=W2ERGgim;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSvwG6RsfCAVSbS4+/4CBqqk98DhL2WOLYlzO7apNsA=;
	b=oPlGse+t4r/UTg58LtwD0lykKJAZ2S9PSHZSxSInKkGQtOErPxdJS5e3UJmpYkcAjycDcW
	dRURLuLVtVmMKPneNSkNloDhwHSqnh17FYN92MMHuTzueKBqOlePd6yXK4sQkmb8v+a23D
	bEfpM9SqGuIWruEbSshQA307E/efkNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=W2ERGgim;
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=saB9ohAGWjzpGYi2StGZKSv4f4TK8VfiCLLm0DSjZTFa6RBiThqEEOKpR5o7I8CVTzryn7
	cY5naEBsqcjeTA+4VSURxlNEZTtqaX6Q8VPszZ2sFEuXWF2jA4QdgmuMbILkviXL5zn9Yq
	9GsrpA/x/4dacrRuiM58uUeiv0YJ9VQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nSvwG6RsfCAVSbS4+/4CBqqk98DhL2WOLYlzO7apNsA=; b=W2ERGgimsMitH58MDtj4At5C7m
	AqrmsCRI0tB62gk9cbxja28U+q92qkZZRPPOWFgOjbaBNTgwT4mTm+dG3YJn1sISa6CtM2bi/6o3O
	ViQgIj3GJlBhNZdEPOVR2nGRrCSvoxei553xg2qltmCeiyhUKj8dymcAmwjlKeEBGENFa9aRzgs3N
	ZOAODjoYvidwdGARmbAMYsRgA1w6N/AZ7RmWnNZDX7wPJa502fEkD6qFFxMHJ4pBVlSHY2f5k95fi
	6THFMoexw3vnADng1aoo1622q9e2rJ6QInxQA4+CHZ8T9OSNINs/F2XTzM643m+C/s9gVSFJC04NV
	jC3JSXYA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GERT-0FHY;
	Tue, 18 Nov 2025 05:16:07 +0000
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
Subject: [PATCH v4 18/54] convert pstore
Date: Tue, 18 Nov 2025 05:15:27 +0000
Message-ID: <20251118051604.3868588-19-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC2AF1C000C
X-Stat-Signature: 77r11umizdah9i86zp6hytzngu49t3h6
X-Rspam-User: 
X-HE-Tag: 1763442973-496970
X-HE-Meta: U2FsdGVkX1/+T4nEp7RpQPA65Xld30Cds+0hB2aC7nlw0C+qZkTOAKMd/YGUQQE2pnMpgixa2CeKJT4uG6E5sXQueQtt7X5YGLjbhrMW0FHFgTpMHZ9BFCyWgAXDFmfsEc4KMvA7d/MQ6+rUrwYmerJNXH0lepwjlhgATiiBLPUYn3FHO4R2k8lzt8DvZ/TYs/744X/k8ON+XDfssQI4f663M+8fUT2/Jdc9+igIi2HV4gUOEi3q92hPkGMWSNP4vhjpr0+ZLB94wKrYN/frqNjZPRJ1WR6Am0vkL+2SxUelXPTWcfl2LOC2anLPRNyTt5EfVMxNJF6V5LiUBsvchImor4QIIXuRrqNCId5GZXd2t1/nplLYfjl3NTVHs+V03M2p4yGJUv5FNQc46+W1pm8OIn4j5spYIx4vqsehxmtkcHnsFrp9/SMIsOBItVxyaKaWmXxzTPz/amVWe4NHP7SmaethYgXJCBivzAUL2Tuu1kKKveKK575FCAyhEa4aYUc/JUHZwAUDlC1z98HNtdHuE1ELSyEopE9/rwT04guhJZK358wYpGWHa44pbJYW5oWgMgJ7hRP3VS2zpS4TzosCl8KAjBNmR5EPyQG96auDHqfA0AMI/AYDEPKlLEZDzK8NXOFWswQJXlFOmBnKJxFNKaAHiDHvYgHABfvnRh3+qt6eSoJKQMJCQ3CBn/uSRq3+VdhM9Y5li8Abkg2R2uFXy8oPestwwXFDE3pQpBTn/Qvc1NGc0UR6cMTw/QLoSYjwucnbEPmjd1h2IeArbsi++wQca9AYVPkqioXEg9pQgYDkw0Fc1kLd9s6gwXimlKFejG9KH0jWgUZi40a1O2bb2hWAugdozrX/e+cWG6l8IgRA21CXf2nTqBSplhASPHd3eT5lwIZ3Jtlyz5N9ZKAbH0S/htN4WDUq/yhvP3nOeRh9iMChrILoJx3CetyMczXI2ba72c9+w945bnm
 VHnZ7Xm6
 3x05PepFzfYLW4KAF46+fBpGJ2q16xyxDeFAT6Ih0CXG9ginijxdsVcevkiH4H0ED/z4HFgj+Z85KW4xHfSkGyEQ7q6xQ/gi8/XioA/ido8yWvf/oWBFzIfai5K5COpyA6lf712QK/QQySpbqhGB6YjfiO9OxS9llOqDu1mH+0kjHHB/7zYZSEIq82SltdgLa2J4boJ/Lf3NFQshCGyHFn7D4XJFnmPTXDkkvGbFztI1azcgUoErh1wIMvM7/javJq7RvrF3qkNYd8X3V+XsXqXIeD+8XxQGyDMy0J7+7KwiTqtg7uaFpiV085+PtI9r7rsPfdn3OxBB/L5KQxRDD6xdrlCxqwDtVsEwOQR540xvx2/mU5tEXgytZ4rlZ8jhHhL/mt/MY0/iWeNPgXCGkBVniGK/UVLHelUAWrtjud1J55r3aZAOFNenUQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object creation by d_alloc_name()+d_add() in pstore_mkfile(), removal -
via normal VFS codepaths (with ->unlink() using simple_unlink()) or
in pstore_put_backend_records() via locked_recursive_removal()

Replace d_add() with d_make_persistent()+dput() - that's what really
happens there.  The reference that goes into record->dentry is valid
only until the unlink (and explicitly cleared by pstore_unlink()).

Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/pstore/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index b4e55c90f8dc..71deffcc3356 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -373,7 +373,7 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 	if (!dentry)
 		return -ENOMEM;
 
-	private->dentry = dentry;
+	private->dentry = dentry; // borrowed
 	private->record = record;
 	inode->i_size = private->total_size = size;
 	inode->i_private = private;
@@ -382,7 +382,8 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 		inode_set_mtime_to_ts(inode,
 				      inode_set_ctime_to_ts(inode, record->time));
 
-	d_add(dentry, no_free_ptr(inode));
+	d_make_persistent(dentry, no_free_ptr(inode));
+	dput(dentry);
 
 	list_add(&(no_free_ptr(private))->list, &records_list);
 
@@ -465,7 +466,7 @@ static void pstore_kill_sb(struct super_block *sb)
 	guard(mutex)(&pstore_sb_lock);
 	WARN_ON(pstore_sb && pstore_sb != sb);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	pstore_sb = NULL;
 
 	guard(mutex)(&records_list_lock);
-- 
2.47.3


