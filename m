Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1F76071A03
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mId0rHTF
Received: by kanga.kvack.org (Postfix)
	id 5E9196B05CB; Wed,  4 Nov 2026 14:39:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A316B05DD; Wed,  4 Nov 2026 14:39:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4890B6B05E3; Wed,  4 Nov 2026 14:39:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25E796B05CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:39:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FB5D120822
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:39:51 +0000 (UTC)
X-FDA: 85398451782.08.4747EAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4D0DD140007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:39:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mId0rHTF;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6/VvbPNlgz2+gPXC5ytRZfMVcR9V1MzQDpcWQsb8Y0=;
	b=fKttDgbYEzlbPKgv9KqnTglNXgWZ/keCFqSSeog53qCAK9aivHoVVpsI9n2Q/00lRc2v8K
	95l6AX9ypv6+INLG/ASdk664y8dRV9k3psDI5PiRYzIo50faSXzPPpSKaPZ4YmCR++Wi2f
	G5AlDVH3L1n26pjCX3eVH1HJKvAqRaU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821189;
	b=v/pprPX1RTjRK2/tEyR4WbziHeL9RKZsxO/GPHwaenO/paXhm/zd+PjoyqPI2C6axhC1Hc
	kXudIz4Yb8hmPmcIx3f2ZC7CCMgkDQAEeUUaahUkpbrZr2zJ0qX4PUs1buGURHtQN0zbiP
	mUX/ezrLyUJZAXrAvz+78G6dcq6LS1o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mId0rHTF;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CDD241E5C;
	Wed,  4 Nov 2026 19:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6B01F000C1;
	Wed,  4 Nov 2026 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821188;
	bh=+6/VvbPNlgz2+gPXC5ytRZfMVcR9V1MzQDpcWQsb8Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mId0rHTFGhaCS3sdYfAY6UrikABSq9514uoQ7GPPNOveDld4OAIzV+AP1cZ5+Ixn8
	 u7k6fo+fYf2fRgma3+s5wUNjWW3+eAUKQT5zf9pbgI2+BwxF5bFCL2tWyNW8KXBYBW
	 v4NzHbeNk5FZUX1OHygbkhxJYXzZJn+Y2YoHEOPW7SRj+yqGiqHwRElrmDCDAL/nhs
	 z7wZyWQuOB07rCVv/pujZRKQ5+vDxcpmumnJK/6BxNgfLAnpurmgFd/xiClBXHam+S
	 gz17fzUUfOxo8DS399IsxAuyLQ8HZywLsxKD4Yl0ICqZpYgzoxVKhiN/rxJyP/QGLA
	 jH2iDe3ufVuWg==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 16/23] xtensa: simdisk: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:39:34 +0100
Message-ID: <20261104-work-procfs-arch-v2-16-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2191; i=brauner@kernel.org; h=from:subject:message-id; bh=CYWbl/ymSaa+aNKLZWQVP3B9Tfxpb2fN2gwcMDszgw8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mSwsF81Q+qzYrn2x3DTybM9wi12nvJmmnVCNNLjr 5Ey5wrnjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInse8nwP2drV3zO58/CxU67 rsubrYlJFcywLT3Csis1qG7hVNUP7Ax/xdm4jyrvPTzj5uuV2l3KAnG7rqWt63zAqn9rS3mOyGx 7fgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cnmr14s67y3tbbemuwksrmkroq7dbe9b
X-Rspamd-Queue-Id: 4D0DD140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821189-870333
X-HE-Meta: U2FsdGVkX18VCRMj3E0kOv2FPRazR/GSiZroN9+OptwuvJNXvRESkrIS+yssR+itcpIw1aKqYOQPe8wgDXcbuvw4fZ2EYu8jTdB3QbuPfL5bP37yEYLDEMqkUv02NzwCmnls5LVb7Ytoa3NvP+9/599Ukm7D/ucP/l4ZoYBGT2Fb5gh0iFCSY5LXuKvxOzlQSxqK8jVyOyadr5mgsJQGt94B766zEGewVHQmVcy1pbTW5CSyRN0DMctJBNZedAYA7+Ml9vPsknlK0g5fFh9MqkynJgDnX4oa0LsAij+txaqS7wIFmgm0yiLSDUInqWT14IeQSL1mRa7Ch9URIjCmAdDiYhtMmoSL7ex7xgvgzi/VNHEwNofN1X8++fZgm89w1MVtfruGBJlDuvYwI2w7DU/wUqbeDA+ceu4Dz8tFJpKokGZ/79wuyJ11MkjZ8iltsRKkvmk3fflaDncgOEizEOU63IsQqJ0ua4vHJF9hlXr4mtUt9nm+2qYrVcZV01PXO0QC0z9eInR26MOhgqCFnP3XVFN2FJPH6GiwiPz7y/oa2ZfbEU5yGxnje8li+n26CC1lrb5FJclO6IVrJry2Hhkp7kQ9sKqMVRCamcv/PJSqP6nCIK3uyvd4X0mek6It+1QBU8ZP8Tryyx0XpmpgfuYBv2D3UMY9V7rGJ9w1VJcQwJP2wH1h2uQgudLft+4JAecxuavlCQ5VqSYzE4Wbz8kg2f5pi07ZDG7Ks2mgRfdUfIvbXbTTiVZmkhc9RDMAOc4b2VwKNOFH0kUUfHCsZomnlCqUTJgZfkGwtKrAYJQczucOKbB6qAaB1LUQfDn1bJU66ZeEAih0VPURXQWM23PdR5W0b4DWQJIdO7L3hjmM8hWXnpAOaLpQuIV0A8zqDviXJbFPMlc/TKjfDriKIxxUwa8QY45xPy8ufXpVmVFcAWG4cJfn500yH0qEP0MCZfOFz0Z0jXXfp9vuhMJ
 0T8tnsT8
 rSh7/GD12siD6ml4WNw2OfzSCryfL7y3KlJKw8cecPMpKsiWzGe80B+oJoepl4XZJJej6sR3irBpGZk5nGM1P3Dm89BYhK10yV9r+MDrorRvxu8j2SPORpFUNk71U9kbp7RdZq8mS2RXMBj5srNAskfmXjPSp5EmU1fHOWFUdMrCFStJdkY8jnHodV1A2oKmsZqDGEtSA/zqei+HT/rNgycsqOxm+Vo95sDJDX0RCluK+UUTe6Gp7olrC9vm484gR6yd5VwgnYWyzlft+iGed489aRwcDquJgVbOQrjq0BqJ/Qu6JhUh5IHzJXAjrRIY7uFTezV8OH6M2FCtqEQQOjQGO5S/hMi/+ESwlqm0ORDJm4WIlIoYAWGgClKfg01JZn8gN/lt0ATk2liHXyayu9oDP/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to the
simdisk files before it pins the entry, and take the file name from
that copy. The files took up to PAGE_SIZE bytes and keep doing that
through ->proc_write_size.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/xtensa/platforms/iss/simdisk.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 1248d960e5d3..26c2fa39a66e 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -241,7 +241,7 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 	ssize_t len;
 	char *temp;
 
-	/* a write sets at most a page, see proc_write_simdisk() */
+	/* a write sets at most a page, see simdisk_proc_ops */
 	temp = kmalloc(PAGE_SIZE + 2, GFP_KERNEL);
 	if (!temp)
 		return -ENOMEM;
@@ -255,40 +255,34 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 	return len;
 }
 
-static ssize_t proc_write_simdisk(struct file *file, const char __user *buf,
+static ssize_t proc_write_simdisk(struct file *file, char *buf,
 			size_t count, loff_t *ppos)
 {
-	char *tmp;
 	struct simdisk *dev = pde_data(file_inode(file));
 	int err;
 
-	if (count == 0 || count > PAGE_SIZE)
+	if (count == 0)
 		return -EINVAL;
 
-	tmp = memdup_user_nul(buf, count);
-	if (IS_ERR(tmp))
-		return PTR_ERR(tmp);
-
 	err = simdisk_detach(dev);
 	if (err != 0)
-		goto out_free;
+		return err;
 
-	if (count > 0 && tmp[count - 1] == '\n')
-		tmp[count - 1] = 0;
+	if (count > 0 && buf[count - 1] == '\n')
+		buf[count - 1] = 0;
 
-	if (tmp[0])
-		err = simdisk_attach(dev, tmp);
+	if (buf[0])
+		err = simdisk_attach(dev, buf);
 
 	if (err == 0)
 		err = count;
-out_free:
-	kfree(tmp);
 	return err;
 }
 
 static const struct proc_ops simdisk_proc_ops = {
 	.proc_read	= proc_read_simdisk,
-	.proc_write	= proc_write_simdisk,
+	.proc_write_buf	= proc_write_simdisk,
+	.proc_write_size = PAGE_SIZE,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


