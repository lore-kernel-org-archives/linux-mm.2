Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A713B606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m9szMX/f
Received: by kanga.kvack.org (Postfix)
	id CB2EA6B05BD; Thu, 29 Oct 2026 12:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C897C6B05BE; Thu, 29 Oct 2026 12:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7356B05BF; Thu, 29 Oct 2026 12:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A21A26B05BD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:07:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E073314048B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:27 +0000 (UTC)
X-FDA: 85376143734.12.06636A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 223F0C0013
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m9szMX/f";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBzHd4puvf7PelR0/56wwfcOU7QQK1cg7vOg9biOXQ0=;
	b=t5/1uxOOSdF7ADmkpgKOo7dMaabr7imDUgu+asLEtro1arnoY9pWRk2tTNEQixBsQHY5Fj
	Gqf6KNWwIg90jB9ONchmEwGrawT6ooB2U4wBSWphIH1tKFkSJZ5bErotCR2erkvxBtl/tm
	0cmzkXYjPQOCbGgvvpPxMnmjKcYkZUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290046;
	b=JLaozVCekKdymAShC0HNkxO1hhPDNWcR+pJH1Wv43nSQOR+q+AF6+z7FhQ2QuApaGg12+G
	FTc4ZXKqO7BZnoMdtudmZrIJEqxbGwc5Woh0g1IRkV5NwtG0xN+6b0J90ql+dZnQSp7qP4
	834BxS+JXobeAq/U6ZVkcICwD1jbxT4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m9szMX/f";
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4EF960617;
	Thu, 29 Oct 2026 16:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EA01F01816;
	Thu, 29 Oct 2026 16:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290045;
	bh=uBzHd4puvf7PelR0/56wwfcOU7QQK1cg7vOg9biOXQ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m9szMX/fEVXD68Fjo3EeIkbSZWBiFCaUdnZ+VIh59ux0qGOuLrE6FOEM4OJ1WZJSQ
	 f9sjcBIGp3cmwtR0Vr1suMoxuUz16RM22QVCXpsDoj7hgG+YtZpQhzQ+8ERPTwSOx+
	 FENqtUXhbWb6AJt7guMCyWwmoiN2tg6DAlUgnisQ768405K+ORmRZs5e5Mai6t3IC7
	 JCG+wlnqB5yg7zzE/v6YXROVwr2DAybfz/I3VBKz/fd7tFcRlVQ9jktvnhDRhYblg5
	 /ZXlk9pRMGfEiSj5AyGOVRF7ifG92+RvMqsktF5VXStBqOVxXjmAQApSiLmPU3bTZN
	 rhuPH0MlQETDw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:52 +0100
Subject: [PATCH v2 01/34] ecryptfs: don't leak the inode when a lookup
 can't open the lower file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-1-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Farhad Alemi <farhad.alemi@berkeley.edu>, Tyler Hicks <code@tyhicks.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1542; i=brauner@kernel.org;
 h=from:subject:message-id; bh=x7sC/M8PNJXXdVBMQkSwa4kj/sguCVJ7hcSWkzP5Ueg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfzU+27Xxy89YL9ydKruYr84d16Vtu6Xx3cYmlqd
 2qRy3v1jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlI8DIyHLp2+rNUvlLI3k6/
 3/ESRv/2vGuTuqrwxpzRw0Za2C/LgZHhgMcuQdFr2SV/T3svv3sy4ytP6qPJq7j+hG79yNS0x2Y
 vMwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 223F0C0013
X-Stat-Signature: pkbjkjr3i55ntbtcrrnd3abdk6josfdi
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793290045-888252
X-HE-Meta: U2FsdGVkX18id38SJi5cDViAYiZg/cD+C4xGv688RRagRab5kpFwVxk+xi1UxQdMsgxZylB70FIVpCbLeCFCXlt1kl3t/eQVFUT2EtFfLtrDAqE/Nvgrkr/3LH58k8e452a6MP/B1mnmG9TWD66hxzCWCTcO81TFBFxEeS9y+OrGLVaAZy5Dv3Gm9VjmCasLXV9WJ2Qh9vHPcDQUTyW/azOOK23rQUmdwp2OeK6J3H/8pLztlw+5uXHKVsA1eM8uYmqSoSvhZvKJH+wrNrCCP+mmJrcW8466CetrZ5SXcMOafGRuGIh0+BmxMf28PHDyGqZZ+euNR9ngpLZ34cgIWypI8+1RfucvD2bTwGCpwqPpMOazWdbcWk+8MTBElFsyvtLIDJ1biGVeGNO/76/cbuJmDZeExQeV2xZm3SRKJJHwNaqVLVtZ8Ah2IzBOEgI9F229Ay8+fJsJVrVtW3MxVrByBjIPOxqpViYGlAIBglNGAj0yArnYRZNc/JZTc6zhrIlYJ1JlGhhVSGPXqejWnYx7W+bfA/CqUFw7UfhOE8q/bK3GPL4K68YhJO0ijSXBtmFY6Rgm9gBwJLHBLxzzOgDFj6/Rl0Amk4AKqqtAxKsleCbSPMgfk0Qf67BvsKrPxOWFn5gqmhgpSeYI7qIoknUo36u0Vcf8/kOttwLGriKLiDHKsEKNqJrPtr4d7//xWCtIi4HKf+LaknZ59FFzkri8D/Iin+i3XPeEPxzczzEbaZUuD2Bo6zsId9gwoBOTsaITLC4itzZ7sbGrto66258tC9PFNXh4pWYaLhcuwKB0Ivq6dtSSWf9NUxlNDxJsWjCcO7uXTKSP+QVraZpAJdrmhIkAO6HkQl3p08OS+IYhnm3BILDAfHcdyJ+QlrCcnI2WaiajKWm23ucOh1Sf/7l2gE2ROSyxt0Q/fbD3UVEx8rapyOGUC0qaBVvnSD7GRBas+an5QlJn6xSPdg0
 d8MD+PxO
 ncbfrhzu39VgFsVoEMgc28uBvB+0EtFXeY/43w4vzlbJp1/6tP5lux2KpTn4chtDUmZuLELNs3ZXeiLdsZw7SwoislfzRdCrkVfwjBJS+D5txWHhnMHLTb3DyQJ7QTSsRCDoQEzWs2/FV3b5s83iCx1LOQ4b6LtJD6YAOjSVdbTW7ZZq3FnaFN9vn6OKQeXjJSuHjtnPW0Y1a+Ucwatmk0sn01gwTd8Q2/GfaFg+ABc4qUQYEsq5oxn8Qg/8kayC+wJQWQxSFG9axrM7rvc5bR2U82t3inu21qL5ZDZH1Hx/9ABZS+jJwYTM5N5url25rNXiKJdCPZgTxB/q9RhJsCSxGmI5g6/hdDfqz2w0xICmNHfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ecryptfs_lookup_interpose() opens the lower file of a regular file to
read the size from the header. If that fails it marks the inode bad and
returns, but a new inode is still I_NEW and nobody ever unlocks or puts
it. So it leaks together with its lower inode, a concurrent lookup
through another hard link waits for it forever and umount complains
about busy inodes. The lower open fails e.g. with ETXTBSY while the
lower file is executed. A cached inode is marked bad for all its other
users instead.

Use iget_failed() for a new inode and iput() for a cached one.

Fixes: 3b06b3ebf441 ("eCryptfs: Fix new inode race condition")
Cc: stable@vger.kernel.org
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/r/CA+0ovCgYP920GT68hAJK6Trjyv1kGv2dZAuem4LEunycQ=POww@mail.gmail.com
Acked-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ecryptfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 48e520960d66..3a966348a578 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -362,7 +362,10 @@ static struct dentry *ecryptfs_lookup_interpose(struct dentry *dentry,
 	if (S_ISREG(inode->i_mode)) {
 		rc = ecryptfs_i_size_read(dentry, inode);
 		if (rc) {
-			make_bad_inode(inode);
+			if (inode_state_read_once(inode) & I_NEW)
+				iget_failed(inode);
+			else
+				iput(inode);
 			return ERR_PTR(rc);
 		}
 	}

-- 
2.53.0


