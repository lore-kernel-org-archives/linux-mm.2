Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6F5606A897
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TgjMN56K
Received: by kanga.kvack.org (Postfix)
	id 8D6E66B0617; Mon, 16 Nov 2026 06:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860356B0618; Mon, 16 Nov 2026 06:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EB36B0619; Mon, 16 Nov 2026 06:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51C5E6B0617
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:11:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E72651C4312
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:33 +0000 (UTC)
X-FDA: 85440716466.26.6B0847F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 84FBF40003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:24 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827484;
	b=H3E8PIkFgPBP4Q4o5UKB9gyb+bFn/2E9rGyAbclkLQIH+yuzNMTrNTSZ87SwYLrJcOpoXB
	5w8uwjs4dOu5wzDan98exGDNFu6FF0dFpAq8yZBDdbN4M5wBc66M3IB4z6EdiyhhEHh9Ab
	ZQKX9B7HT+oVCmTAEMvyhqaRGNmKg/Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CwpxM6nYTuBn1diZMKE8u8L7OG7WlbpBDnW4TTBYyk=;
	b=BkGS5kdh92KmbVsfjtiQhgp72QoTF+YkbOuoj5K7ZNdIIZY1xgh3x4zMSVveKAudKdkNkY
	I68i47Nm0+0XSXGov4sYghZFcWYW+ZAyQhB+WUO3UVf8kVIpijyVCYjdGr50BK6dlxaMoc
	EXjCwYofkIKpZmThBo2tE3DHBt4hf9I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TgjMN56K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AA1162967;
	Mon, 16 Nov 2026 11:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07B31F000C5;
	Mon, 16 Nov 2026 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827483;
	bh=8CwpxM6nYTuBn1diZMKE8u8L7OG7WlbpBDnW4TTBYyk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TgjMN56KOGGjy4LWUYsZ8zVo89DB80z6mNiJUIXdyCxzkfdDPL0CceRNnYEB5ZMAg
	 PvkD68BWJ9caW2s/BGPrGC91Iq9CXON0BvEYC4o9C6G7FIaTwo+zxVlOEz2OOHPj5k
	 4vXH0MjVLq/jft4abkooK+ZUvlfxnZFbaMziEvjtIgG2hkF85u9Jdu0B1Z0thxS1Vt
	 ZGARk4NS/4O6UY4E9/nGiGeDdufCKu3ZzScYIpnsUw2WoGqih1dN6XANIxyQsbx8j7
	 /P5GGzoXoUbjqBYgg50FlLRHJWxCQQmcH0xslfduPPlaC1VbV4Z1ZBjTDb0GhtHuP2
	 ZujQbdQe5sKRQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:16 +0100
Subject: [PATCH RFC v3 43/44] acct: refuse files on pseudo filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-43-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1795; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TBLyDKw5rIlrAxe1WyLhAIBRdo8Sa0ool6FMcens/Cw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ejzBrFZos83lvdOmyU1dbrg+U5ejPTdxwtWo7L1VD
 VNiDrWpdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyE7zkjQ4fU9EqupZErcpbM
 YdFl11N9/mKWoNrBrC3H9UQXrluybwojw9s/fcqVr01abSYZ5cX71J9+ofyxLFboXoAX66kl1eu
 TOQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-HE-Tag: 1794827484-954355
X-HE-Meta: U2FsdGVkX19Xx6aDiFyRnchWZxtSfdBk7ssbOsZt3vfa1ICwID1r69rXZ3tJkDBHyeiNuxKKcmrbSwQzWtdXvfXd8ri0tNfYBMUgv0P7Kge2pqDd0PW2OO9rG3l7aSLsyI5ur90uCwZL900l2OCQjWxd5hCcGZMPMeeM4W1hK1EYi4IG9Z9yao9CLtNRxORt61AY3jCPrnkNlJbXefihoUnPt1wO4ul3rRc45c5XIWgot0iDzOgubxRr4zg910lcGYEAyUCY5InRElIrldHL/2E8Bym9JI39DssU6KDYt3OZ4cDLR2QUmGoBEhHLlnAjauYEEtpcNx3GYlCH4f0dmLIV8erjqiQ7TRI/mbOWokDUqHOlczrXWogDaifOJe5ryShI+NRseOgOCSkm+9Vrz4OXKmWuMKDTzfkxii8cmX7nLdbrn/y9WRzrH6zdQZzvqquUgEpYOuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
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
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
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


