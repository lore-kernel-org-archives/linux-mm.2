Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C98A2CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 05:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00AA780118; Tue, 28 Oct 2025 01:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F249D800E4; Tue, 28 Oct 2025 01:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60CB80118; Tue, 28 Oct 2025 01:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5050800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:31:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8767E12A914
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:31:32 +0000 (UTC)
X-FDA: 84046400424.25.6973FB0
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDEE140004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:31:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=EWfgXsdi;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761629491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCYFuUAfEyL0H++y1+uBZz/Bn18lJwb1nrzO1KgbXu4=;
	b=aNsmqUo2A3L8+RPyTo9RPMaKWVsRyJwPXEaFy+Ej74ZZamTq7+tJB31e3QhYFfV6Ec6jjg
	Mp4EbyAtV+r1B4SNzWNDoQCVtWVPJLDlrS/dSfTLLmdEgIrp0DfHPesPkzgmryXw5LgJlU
	Wjh8HQPpirQQj0eeIVpLAunI6h9iSas=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=EWfgXsdi;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761629491; a=rsa-sha256;
	cv=none;
	b=v68z1XaX0ZeKPjrvqeWtwBxsCjLuHyOkbwajr2EY/pGhdBMcuo7enP9KqLHwb5AwsuNG3d
	3lqh+oLtg35FKd2jexmC4iVIMf6gk1k+kdj+b6Ft4cc8MCfmKQyw7AtWuxYe41DO3YIFQe
	Vif4KoXsH2rXsDhFU0urQ990UMPuesM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PCYFuUAfEyL0H++y1+uBZz/Bn18lJwb1nrzO1KgbXu4=; b=EWfgXsdiG3Fd92lYkqqo2qv86G
	VSuEIsAE3FCOGUjNJxAqt736qqVNAh1feZmW0K78PLH+93EYeUBDi1Xo4NzkphpULJWarhu9Oqrby
	pl/UZgIXr1W+2G5w/nMVZArRc7KcmUfNCfdq132QezWSLreZgiT2O+z3rW+qSNg88h4YVAyOKJk1k
	CxGSjVSLupRybFCX39EZff2pJknmU1Pf76gNozocEtWsm6ln0DjNrub4OI2ZwF1En+Jd3/MmNGXlz
	c4wZPg1r+A42g75MPjf1P4AKIc6OloMhv0P8DZccF6CGOiJ3b0QjBGhDWHq5pAJ98lhyAlfNWeLJD
	Jx20imGA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eYP-45Hh;
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
Subject: [PATCH v2 22/50] convert efivarfs
Date: Tue, 28 Oct 2025 00:45:41 +0000
Message-ID: <20251028004614.393374-23-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p4fa8q8ffgbby83igntq93qyax98cq8s
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DDEE140004
X-HE-Tag: 1761629490-760319
X-HE-Meta: U2FsdGVkX1+V+cbvlj1GFJYqEzazUQsxwEuM6q1SzVmjLZQhwGS9mqnbBh73EkktEDx6NiQXAfPtWAjnI0beBuRt7Dn2P8Y7ScLYsCKTeGXcP9ltc8zvGF8b75QuAIJnRYNXIPQ/bZYxjOchDENcO0EdR7yjk9/+Tf7sFZ7EbPakUK9oTvmItDaV2AfKc/AMHQSwwc2fe8FXVjSLgEEXvo/KDoNkBmiWeLbbusy9iXeeTFhxvHZvi+ennoIPFeMlfpC+hj2ehtDJwi01CFdxHUxgqD6CxazHpcxFVjTFwbi84lzvQxWX3NAKUbyPbRWD+dXMzial23xnMW4ozNq/J18TynpBfExaC5GhRuGkCyYXCgJcMG22jJKd/4JTchoNGW5v9FaYt7Hv3Tr32OBh42/DV0tazc9nxiqAZYoFH924w6fJv/OKR+4ptsrIfzLDjyjYtbVYb91+o1iLMKPrrZlZkTesl4xIgSvEdsw35dUJ18cWM7/iy7tfpvWE0s3HyOxLK015I2GQlQ0Ivvf/Vl8t6C0sGYSNWVDR7jvo8ZpVnlPoUjSW4j2uo1KP1FzqlaISkU9aMlAX8i5h4qOQzKpWmd2q8AL3Nbm5KxXce5L6iH7Z2R8yGtP7DxvHoRuBrMUbChqDJZm1TWWyPgcAFBVic4Ytasj8yslPSZ/Hq71KDAFiBhi4G40NXlHM34mzVeQxmOYIxpm30Szl21a3P/zCB2eQGUlCWl7PKvqTbj2kEyPSj/Zj7BKbEZ8aaPpuhhBaDt/mLQpkaO+Osq+xbJPHluJlQAJQcnkH8Xzn4CJJs6sZiqpW666bTtGFZLyZGny0+FGmDU+T0IuejFIQzI7atq7cQhMPAbOfdSgWbrTBSGI3F3Nlu/T4iHNlUuPKUzJS28mEZe9ClygQihIU745DH7RDZIpJluC3BtjYSeJYN5Eu+IxdMWRTqHNCBwN1h8hklMlPOVrhJ+8Vzej
 m3ynX1Tl
 XlGNwTuUDTnv08QKLiqt+vXrNtuUzJqSQJT5LsyAkrR8omZqOncl6CzHMS9PRF5RUbdhjLIo1apDZIbXUC0Ov7wKugziohpI0RARDE9kMvPDOEYJAoI8IcKAi1GmsaRo/tB+wmK1FEMgsxc+LMrIUDlz60AxhuazXj2Z2xuUZ21ULX0XjHSy+6lqpwokSZCRTs87Cv+5kZsgMZ3LdkQZswwtyniGaE+ASxPNRn5V5AlyRNlUe4V2E7XkFR0rJnnZG6CM6bXxDcTnag01RsDn+ft7qLE/oEvxAzOZgw8YAB1jg9aCFCPcbHM+N2OGhBEsEM5/0Fuc748IZaqVtAjltKMiBhdS26NC3kmUW2FwJQuS1uoK0TP1U7OwSh4rZxW26LFm2zYTQGaK1rvYShfJKziMI5286ap+0jmiy0VYHFMKiK7AWHT3DDzTU5zkv3OUrhirmgZlj6fp/B0Y=
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
index 1f4d8ce56667..298ab3c929eb 100644
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


