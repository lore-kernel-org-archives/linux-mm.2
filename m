Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487E8606C647
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CT+iOXhf
Received: by kanga.kvack.org (Postfix)
	id 694A56B05E9; Tue, 10 Nov 2026 04:19:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D396B05EA; Tue, 10 Nov 2026 04:19:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5825A6B05EB; Tue, 10 Nov 2026 04:19:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33C186B05E9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC69BA0342
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:45 +0000 (UTC)
X-FDA: 85418661930.04.48D6FC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A4B4140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CT+iOXhf;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL0wpOwuozhlRhYNz0JipJ6kxKX4QenBWX0X6ItK/K0=;
	b=Ku2yUy6oAsXMGRQvjKGrB8tIU5/RVFTZPivYsE7wfPfFlagyDAc66ynj6rcGF7Yp6tVdng
	C61kwxuse30+zIvfH7SMiybe28nLPkm4QvzoVjmoQMlLwR8Z/HYnQCDGf1enloav6LJ839
	nXBAWDIZ1gGVv4bHHaRDBhMgXSt3ccc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302384;
	b=TIERtdmeOp3jC5rEThN9++nRl+FmSmEkRo8oi/dRWtM/779c+PjBkcYIqVucSJ39/Ga2jt
	pUoxdzfti7IglBoJsncoBMHHNmxrhLFWfLi5hx+4T4KZLzkjvek1gvJn5aLhnMCOYJM2Wl
	UJttE1h47XbID9X/iTB3KlTTN78zEbc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CT+iOXhf;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BB224087D;
	Tue, 10 Nov 2026 09:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32A91F008A4;
	Tue, 10 Nov 2026 09:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302383;
	bh=XL0wpOwuozhlRhYNz0JipJ6kxKX4QenBWX0X6ItK/K0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CT+iOXhfdXS9EjWhCPxyMwbc6qpk2mfT/FYG65nH7AnMeSTgDu4gtnvPph9s+gyJQ
	 ZvCsMu20agRk/DN1s3jOLTDIaiE9C33mbBH7UBmpmq1UA5VoUIzICSYA9Tg4ndMgTH
	 NUHn4RW/Rt1Efr1DcrgvT2Czb0YSTQrx0YgABhREHnhLrge2ohMdRAEXc8ARjQ95GB
	 N91PcDylNuNGgoO+A1oWCOdoVMTmydTR6bkBvDN7xjUC6o/rf57lsPcqiLH9lVYbog
	 fqTRi61Xug5bUX+nw+zLWjcrBruwnR9lQKJTUUtPpS/C/b7PBRlfrij5xhG51EYia0
	 M4TkDbL2tSeqg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:49 +0100
Subject: [PATCH RFC 33/41] fs: add file_is_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1523; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fWtwbOqSVGrzkIOODqoKjdbZebK5p812wmLNWmDsq10=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDr3MIVGoy6T1c42Fn1zN66UCnoG5vsrbwj8gcLt
 77hOtpb11HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRhFRGhmevWgXzbBfJf9i+
 0PPiiVlFPwKL+Fc/UFjp/vmC/tGfMw8y/FNqqr0U8TxATPOxjuYj+fU+8bu+/uDa1s7jnDCrjX2
 /FhMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 8qtcaumya9cjg6fozum9hnzqays6gqem
X-Rspamd-Queue-Id: 0A4B4140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302383-870103
X-HE-Meta: U2FsdGVkX1+Y2Y+TQoNC5aAuzBQNzud/PNSpN7x/3xYO/osSj/1Mx6o373SqDtAbVkCBOc9HC00yKqwTnEcwOLZWR8SxxMlDGaXtE56IBNSDV3PTM0Rttf7JdeMIgSWsyVBtRuWE6D/3A1PZiQfWfbiigKdAi8mSPAIYp3d2d1dPAMzBzLC/gENsZ8UckibbvN+RZ5HLluoGHaNXWonJuTC6CWEkHjRsviNoCqoTKjiJrErGR2G+yf40cT5xmo1S6vZYBIXcxc15fq9ygF5xDrmZ6EfFyAfQiayn466JVO5m6Xl+1PWVOGIPoAyIvzSVC0egG1vwlmAryRBhs2q4vSx/espgLUfdDXDEkSj191J/C0MVOXgI4zVlboloVpCqXsxZhDSSg7NCi9qMI4SUK8YvcMZAFj3iaF+3/lWKkReZDyR09+oNasMFWhwVOrDSAckcC11k96OrT8HIKSstzOohXT+2aQ3bKAbGZcqRQQZlbLisifZ8RwxifIdTjoHU8vyfj1SX3/3s3IgeTfnAKLmyceP8PSG4GaS6qLKegURbeHQAb4j9vHnbisHcHMhiTBA44somYIKjG9ShWvDMghA47KwN/9aMusgF1zM0vkS5VQBWqdTAObvuRS60FoJ/FTLQTt8mddE2RtnjkQ87+IqcdGDe31lAwnkmB6Xa4ehsuHrOfOAL4VWirk6B6hqKBto+GiegpAtkv/rqfhNxAmXZvjkcbIkjOez3Q/d+AqhC/7mZnFipvTcno2V6jaCDsK6WqOAmHNiVx4E/qVpx85yoC6UT9xbEnOhqm3MkHmPIR1L9LSWq7C7IYLSkqxrPXw8qXpLLTjFw1OZQCnw8UQKE/4Ub5yn/UXX2P1m6WeyIBzBA1tZ1Fyacwc6f4Fxc4XjxetClkMROFhjsVqc1HgxBo4TeFsK2NTtY1wHcUYAZ/Htfqh1d54jS+xOa0g6MdjMZoK58qVoNPtvQxPf
 TQzBD7aB
 e5i3U+JpymSuYaCAdtYEVPKYaBuskqGYcMGEf4JJTySaBCrp6N14Nw7WHnVazD0MGEtvO9ery48A/bZ66ohTX11xzYF6+3jTjroae2Ch5KZg2Rfh9T7jhvDVkyWlBqXAmbIoRA2CAuXGQfXiyD9de3OF21ceJyrXIBIOW5QzKUdCXDSr9/DKPb1VdhLVddXViAyXjA9n9xVU8jLObbb05ibugQTuN9IPR5cfoVD9YwPgJC+1StHOUNlBdxJWJvYh+41OIEwe4xwVmbG5VGLyc5ERZFOs5zOGc0Hw+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a helper to check whether a file is a regular file on a pseudo
filesystem. Only regular files count. Device nodes on pseudo filesystems
such as devpts, binderfs or the block devices on bdevfs are what they
are.

Look at the inode that actually provides the data via d_real_inode().
overlayfs accepts sysfs, cgroup2, debugfs, tracefs, configfs and
securityfs as lower layers and reads of such an overlayfs file are
served by the file on the pseudo filesystem. Checking the overlayfs
inode would miss that.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/fs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c..407ffb6342ec 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2553,6 +2553,18 @@ static inline const struct inode *file_user_inode(const struct file *f)
 	return file_inode(f);
 }
 
+/*
+ * Regular files on pseudo filesystems are kernel interfaces and must not be
+ * used as storage. Look through stacking filesystems at the inode that
+ * provides the data.
+ */
+static inline bool file_is_pseudo(const struct file *file)
+{
+	const struct inode *inode = d_real_inode(file->f_path.dentry);
+
+	return S_ISREG(inode->i_mode) && (inode->i_sb->s_iflags & SB_I_PSEUDO);
+}
+
 static inline struct file *file_clone_open(struct file *file)
 {
 	return dentry_open(&file->f_path, file->f_flags, file->f_cred);

-- 
2.53.0


