Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54498CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C83E8E0034; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBD98E0002; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08A48E0036; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6B38E0015
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA4F41403A5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.28.A8478BB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE9FD4000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PSVLx2ZZ;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTvrbo3mOzTGCel3agLEDWiwlpX39p3niSGJ7gA+srw=;
	b=PhG1E4M1ir9FuqnvaA0yqvTZy3DSTRySi9RKpNaUpjboc5BnaoqSNi1zq3hC4ZnQsM8Zm7
	GyZNaLCwPffMDBMiW3eqc1rzKfBI6WfjexjqLKxtoZ0TXR7MEmtvIa89awOwchpA9ASpuP
	szhwXREUe7ngMd0FmdfFnyj0hoU+Ewg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PSVLx2ZZ;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=JqUpqFGZAgVaVEJWEtnXYYM9PR8JhC6SHY0G3ojFM0AREC9kVlOvFKsot4G/o+sZf+fu7q
	hKwOtvXY7PMM3t9E3Z1wpVPfrmpkkPjgzpoEAzzg2X1aVVxDRWAlLsJC2iA60pXM4GnL6v
	OfV1VCN/D17i09vg6iy8AWXxGOLD/f0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fTvrbo3mOzTGCel3agLEDWiwlpX39p3niSGJ7gA+srw=; b=PSVLx2ZZkp601tYQtdf5C5irNi
	Z7g/rYw0aEK+ZozaQFkjYAFP//abSPM2KmlJ+TGNePUyHuho8LH9yaUIP0+J+fLbezhny0lHLizx4
	mrcGJ0M5Ypjr1+JCRFDJOHmqmdSgOpN9Epxm7WzGJ66a9Xm8V44lcNCm1pBisA8O7Uw8/ZfWSeJMj
	Sfz8/geCQxS/BUK2mSCsqUbJi7X2dtzelZd9D7doMF1NTYM5+w+c9G5twuxdJpVfG5x1jUWDXBPPO
	Qs477BYLAfmVR4HGQqElWBDUdNWUdG2TpTK/gs1R1UXz6h/7z6/DEqZHOoT3++Qn0Dpgqh4saTmnA
	0DGl3t6g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GEQv-2QWj;
	Tue, 18 Nov 2025 05:16:06 +0000
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
Subject: [PATCH v4 13/54] convert hugetlbfs
Date: Tue, 18 Nov 2025 05:15:22 +0000
Message-ID: <20251118051604.3868588-14-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE9FD4000A
X-Stat-Signature: n6nr9fk3h3ym9mr4fnjzu3yxu9eaqw5y
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763442973-60078
X-HE-Meta: U2FsdGVkX19P+pLzQO1FV+0FlBkLijctJbYDeWDE2HEu2rCQgVsgjLa/b8oOznj0PFCVbz6afsXsixYFsxnMthpklkZAEKxybbYMK7ye9k9+UxnQJ8vnTPCqFi2cUR7Cq7Arhkb4rWtEmXlq7Xp/qOBcoYI3iqI6TjnEoSF4MsVQgAgFZ0wJOIb88fhvI1eNdCLs3b2KZWDYvEcAb2pHz38JS//EVuoojI7m1veztnY9WqIwd+b/Mx65YeXb+DLIYwaMe/6w4Qgf2+Mk4RJm7NvGDEHAeWHV5Bm89Abg88JB9pwJRGpWLyiGzBqRQI1NZAO+hhH+thjDan8ELkRi12P7gJQ/MAmlca/8ByTBQp8yy0t88AqsbzSfiGBFqnoYMmUAVxxm2IsHrtVMJd1XTg2DxRjngavMTCytd3PgLCnCSqGR4NZw7OCRmt3Yjhv0tf9Ei1I7LiCOYB/cFZ5Km1NUdG1UzDdBCv+htO9Rd2McX6qh55GDOZTSPOp/HLU0u73rckGa4IfIrkOd/sxIjrBD2E6AWSikGJKaXNtfKRCHKdH7oXZ09oxZ0HZNqTCPz6hSi4g8TifOUIm7AGPuVsS6sWwedIWXMQYrwiQ/VUk5j5xNBH1klhP8sBHNwqRwtE0N/U94Bj6MKZgWUo6llmKhrDNV9evbC1hsZFgUXT8JHJc9gcTdAhmlNAFgdm3BRN+G1iy1hsVSw7UDU98IZCeOqHbGSUzT40E1hEzkdwXaJvlZl13LLdi7mj0ZeojfPzlab29QVd62zKLkSrlxsxTbW6bxAVcuQHGYtVRlalVUTAWMiV3tKwInIP/js1yAry9lSH4J2y4z0U1fVBzHziLLL2mZPPrQbe/P8Xatcwjvht6hrWc6eVEQ6bm/eNq9A10zXpG7GsJahIQZo3Fh8rra+5OV9m4Id1nuRFmiUl2kpsqfRSxHAjPJCIGle02OqIv1b76vlv1jmjvZ3GZ
 SnTttuvg
 XrAeF7DJoOKh/oG44jMKQ7uboVIVm9biTTmEJTJML10vZ9ObkTc4Cs4p9rgqt3jFGXwSVOGL0lovIQ8abGPc9DKW20QtHOaXLqXA8zZ30xI7u2s5uT9z6RS/K4hEtNCKwCR/bCwAfcQTnnFvYmd2cxV/+fwriuKmswppbkGKHcokBLxEv5VgxSSwqnULk/jQ/y6zvL2BW3JWLPXa2rzXcezx/i2zox7gQTnlaupWa5VFihwtZ6IGZ04U6uARC9HttSmI5KJrVcEpo/6NKf89ZqXhIXP3y9+gv6wFM/Qw2YgvISzVqw4Ux2XdiG+EQDlb+M3RHi84esUk0/ISNEAY/gAx0wiMnKpfb3san2YigwiL2J2h60iQLUWy+GPSeeJfmmozAveyLiBxtHfyvdcvtJSswKkJXG8biG8Zi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Very much ramfs-like; dget()+d_instantiate() -> d_make_persistent()
(in two places) is all it takes.

NB: might make sense to turn its ->put_super() into ->kill_sb().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hugetlbfs/inode.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f42548ee9083..83273677183d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -975,8 +975,7 @@ static int hugetlbfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	if (!inode)
 		return -ENOSPC;
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	d_instantiate(dentry, inode);
-	dget(dentry);/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 	return 0;
 }
 
@@ -1023,10 +1022,9 @@ static int hugetlbfs_symlink(struct mnt_idmap *idmap,
 	if (inode) {
 		int l = strlen(symname)+1;
 		error = page_symlink(inode, symname, l);
-		if (!error) {
-			d_instantiate(dentry, inode);
-			dget(dentry);
-		} else
+		if (!error)
+			d_make_persistent(dentry, inode);
+		else
 			iput(inode);
 	}
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
@@ -1483,7 +1481,7 @@ static struct file_system_type hugetlbfs_fs_type = {
 	.name			= "hugetlbfs",
 	.init_fs_context	= hugetlbfs_init_fs_context,
 	.parameters		= hugetlb_fs_parameters,
-	.kill_sb		= kill_litter_super,
+	.kill_sb		= kill_anon_super,
 	.fs_flags               = FS_ALLOW_IDMAP,
 };
 
-- 
2.47.3


