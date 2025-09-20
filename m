Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23068CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9EF8E0010; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D11A8E0015; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8ADC8E0019; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AEB7C8E0015
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70B6611B102
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
X-FDA: 83908850256.06.DF31143
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id C06D220009
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=S0IOCIyb;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHYH+cQVsm2L8KWlz63sd1N3QvfADJqbUf5fBvo0O9M=;
	b=qfDpvmnO48auQUlDyNqLeo1DrfCtcsvTDdc9KWhsnRyF/v+LRPTEQC5z/tl3/WlgtKSjO0
	PPwLJa/C2n9fwKIwDpzxZDsSzlGG+49ME3UVDrAaNlCy2colEA/IU9qtDEBFY0HQjjD58l
	eETgpJrnyvwc++DRkhDhqnlWdptmzvs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=S0IOCIyb;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=oKbcoHduQF6da9zGbbtB6/VFLRo2+3xrH7peGzAvAGnDKIwViA0xOvoBQbsq8TkKb/oN+q
	JYBlRVtZr/nxE25GiDpe/oGHkjejswHGibVug24mP2LkF0WTvlh8pIa5r0uesiXvSvg7ID
	xI3gS0+wUk4KHJYpDle2wy0bc6ccqdo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SHYH+cQVsm2L8KWlz63sd1N3QvfADJqbUf5fBvo0O9M=; b=S0IOCIybhpDVg55/sRTdTvowJ5
	klRE1xB/CDgAo2525KwT7F4L0heh7aXP7QN9Eh12RzsOJSHr1U27GatydApDoFWj72MXBXbhxUXEf
	mKDsQxDn4x2CPSC/RKYKCMeL/Kfm00JGEz52JxOZqSu09iztJptYnjDZ4G0ikALQ038MOm7LTwe7a
	ti/N6mdMrkwP6Go0mw2F7M2B/Z6cSx+Jm1o7bsBLLeGoM5s9BkeD5paoujT0kKglwj0OjDrGKTujh
	UE3q0/hIelsAycZGrSHLv0H8+7Ec0Dads2v9xZr/aqB1YnfGQ2hp1xxIp6tdYUzNFV7ycRMe8nwtB
	MCHBD53g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKB-0000000ExFR-0vOu;
	Sat, 20 Sep 2025 07:48:03 +0000
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
Subject: [PATCH 20/39] convert efivarfs
Date: Sat, 20 Sep 2025 08:47:39 +0100
Message-ID: <20250920074759.3564072-20-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: egk3rqi93n7ocijxejzpp8z1c4djtqmu
X-Rspam-User: 
X-Rspamd-Queue-Id: C06D220009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758354486-591951
X-HE-Meta: U2FsdGVkX1+ROt87+FXFZK6tW0w6M+v8lpecVbGapeh8/aEs+x+Uv/N2hqQbCsXJnSAyhJZETzdVSKxodWp6vsRM1zGCBw3bg4u1njDandjZzPgLFeAJuVNkv/vXD3jKuSIBEOV7QbyJQ5xOYDkDRVVQv6yNBKoD4saHWkujhx/puFh6e8aA6Cw/+NjP9pdP/SQmOJU2nXR7wXz2RraLEiYKNhLWl6CP7xPVplAqRdO5s/pcj171lHmmMUPBm/PimSTvYTJ7Hh0EoBe+oAsIrLCP+eRaA0lEZXNdqPti4bUHt+HLL1KPfOODZmmxfOQHRuvY7omlEwB055/HcmSMUrr1GMj6Z62sExrpwv+5jE37UXFLilv+F7B2uZ2dMiRYtRDFSMBEyGx3Z+zfnPrO+2YHDnSTGPaXQlH/OkfOSdYLgIPpWIVLTJabGopeNJjHMhfTofivCnVSydbi875KeFf+B5g1KQlKrtq5j9NgAlxQadYTke3GLpnPmZt3F7HV8Tg7Q4Y2D2J4abI0YaZCodNc+CWbp3DAAGjHi+HLos7j03Ap/C0iAtjwj8FG4iNgiITfAPoqAfOk9aBkEJfL4s6KMUiUk8hd4F3kwIQpUV1qdJnB6nQcngzscv3pX2lAO6TPv8sRpqGk0KN+GGavbFo1kMgBByBMOTlhXGg95DXEDr+5lFvRTp4s5l88wMk37r2Ud/3AKt5b0XcvA5rU0IApTnbbeQaFwRUgNYcYAi0nZQrlKWm9iLsUC1yQz88ieyx4qcqB+oj0GEJyk1aOY2+5h5iqocn8y/H/n8RlecwyLr2ztcKAGRj5u1xrrMjBLsmtHHjuX/Re+e/QEkMye1s6AFsxue9UoOm+emRV+l+wVCGNTOIow4sVOA9O1qAj86GMdnB36xfyKLTK7OHu4tYv5jUt/zYKghQZrQNCPp4bqnC9VBjQopkTDGVTXEmeoMfswYFJFz31ftNeRTD
 f+Vs1lhU
 4B6avyXrme/E9NhIAzKVROSjg7kc+/unMQDuGRKOH6LH7fmuDxmERhqPM5Gf8l7Y1p9dkMjvjdE/WGzRNU5n4lP+XrEbhdsztzA1tB6zAlJPIp9BlFb/JPKKSAH0BteuB/t/JN/L5yp5VYh8C+2y05BApZLAMB2BFcp1kC4RykFCMeCG2beA4zIl/v2twU9TYUYzgD2036heKqFVGnCKwGAWugN1PYV1uOaaFC/uNZs/pT3Nk+xgLocKf6lmUYCfiAwBbEwlOlo9c4vjZXV4sBODS4pBmw6EqLX8f8vuzftUjnug6cN/DUfLleVvzocIxJaCLADTdB7Ux81ym4LnG8g24401QqcMvTwWMMKGk9Eth7F7tfs0Bm1uBfb9mMzL/lH+KT9M3FY44ZA1I4JROhiX4GzJPkx2etZEWgJRebgGsvr/PiRGNGtwUThIlNYOSvf2feI5F2kl1UHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initially filesystem is populated with d_alloc_name() + d_add().
That becomes d_alloc_name() + d_make_persistent() + dput().
Dynamic creation is switched to d_make_persistent();
removal - to simple_unlink() (no point open-coding it in
efivarfs_unlink(), better call it there)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/efivarfs/inode.c | 7 ++-----
 fs/efivarfs/super.c | 5 +++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 2891614abf8d..95dcad83da11 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -113,8 +113,7 @@ static int efivarfs_create(struct mnt_idmap *idmap, struct inode *dir,
 
 	inode->i_private = var;
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 
 	return 0;
 }
@@ -126,9 +125,7 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 	if (efivar_entry_delete(var))
 		return -EINVAL;
 
-	drop_nlink(d_inode(dentry));
-	dput(dentry);
-	return 0;
+	return simple_unlink(dir, dentry);
 };
 
 const struct inode_operations efivarfs_dir_inode_operations = {
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 4bb4002e3cdf..21208660bfe2 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -278,7 +278,8 @@ static int efivarfs_create_dentry(struct super_block *sb, efi_char16_t *name16,
 	inode->i_private = entry;
 	i_size_write(inode, size + sizeof(__u32)); /* attributes + data */
 	inode_unlock(inode);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 
 	return 0;
 
@@ -522,7 +523,7 @@ static void efivarfs_kill_sb(struct super_block *sb)
 	struct efivarfs_fs_info *sfi = sb->s_fs_info;
 
 	blocking_notifier_chain_unregister(&efivar_ops_nh, &sfi->nb);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 
 	kfree(sfi);
 }
-- 
2.47.3


