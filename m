Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3BB606BA1C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cwHr8orF
Received: by kanga.kvack.org (Postfix)
	id A1E116B05C8; Wed,  4 Nov 2026 14:51:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5956B05CA; Wed,  4 Nov 2026 14:51:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E67A6B05CC; Wed,  4 Nov 2026 14:51:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68ED16B05C8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:51:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3E0B140845
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:51:37 +0000 (UTC)
X-FDA: 85398481434.27.CE3A72A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3646A140009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:51:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwHr8orF;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/yvfG66BfgMeEDkk3c56eCZsjSg3r6CFhJDsqYaHrc=;
	b=SyBqG1LYDg39qi3Bj3I9AH5TEUdxxq8T4XhB/9LaHYw3KXVAUPLPLFarY5kcZJDdexVbLf
	7/dnig52oESo2Yn2nhKHxLXtur39fEgzYfZ1Mzz2r8NRk85kygjEzKD9HZ/etmoQ71klSe
	WlbtnwcMtWSjE3FpL/6r54EjnGcVcpQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821896;
	b=kpwBvqrbKssxUvdJbiNZDERvYRoSkaUmOKNYPdubKZFrS8elr1Pz/r/b5vgqsRQIFlp5DN
	XwWNG6A1r4G4Gphvw+cJSW5n1yro4I5E5stbgDpMHA1PBRNVpT/r7We0vnNROikakyB/Vb
	1NxBxUrX1cyp2mmmnBWv9RRxum2XTLI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwHr8orF;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C464560F0F;
	Wed,  4 Nov 2026 19:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1974F1F000C1;
	Wed,  4 Nov 2026 19:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821895;
	bh=X/yvfG66BfgMeEDkk3c56eCZsjSg3r6CFhJDsqYaHrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwHr8orFnp4x7J2Xe1KsHSEJ1eg0u79nGPLRIUIwbAP0zUf7QsBysosf1FqR5ZX0Q
	 HoxOVOzOEv9f8ZgsLKaGizKxckb+8NmWDvznCxT9hyz6XDje23Fu/BV/7vYfSBlRBo
	 29q96vKA3sg+WRQgH3Xu5HAtJzyAV0C0X5mRTfioCWgSP85kQ3OB+8joip1pGF4lz6
	 O/KafZ2Qaez9U/HbkLZAPk5WcEVfLztKFegfM9NGRKV58MPrNpX3BlH061wFYzdEC1
	 0F3/Xa+OzEI16gZNDCtefEhvwseJTbeAB5Ppvs0OtDpq+EK5pYG3BV1CYUNRgxGUPi
	 Ziv71uisF0tng==
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
Subject: [PATCH RESEND v2 07/30] ntfs3: let procfs copy in writes to the label file
Date: Wed,  4 Nov 2026 20:51:20 +0100
Message-ID: <20261104-work-procfs-fs-v2-7-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2130; i=brauner@kernel.org; h=from:subject:message-id; bh=kxB3eQnJXJ28LS46eI6OZqVe3PV4LPZGCXrTLaq4dFQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97jH+72CqrHDmzhLOGyVf5VS7p01fvUvn0De7C5+m2 C7Q/px3v6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiHx4yMpy3rZ0/Vbh5+gyZ wzeePF8kfWTR38C3305W5Fd5HDHp+GLF8E8x2XK+7nLuldutNvMse8PlwX1u7efe4OOL3l+evkZ A7hkjAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8w1hz6wum84g4ebfmt7yhbx4zpa7d5bg
X-Rspamd-Queue-Id: 3646A140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821896-343374
X-HE-Meta: U2FsdGVkX1/8s+JnYUprJDl48JQ/Xj+gQOlSe49rj+SeCE1ING46GU8VwjlPg8KmXvBfH/9D+x1OkwN9cyXtl25wCXJkdwZajza7esWKNCXjN2tsPmKkKWMS9ALBlDAgFY6DDacEP4IDAimphsTrftKKvh0f/h7ndmAX8zDkm+ltXeLw8zx3EOU1Byfs7a31wxNHLRN/KZpqBxvAYEeEGnPMMZ0MfuAUKQ34z0xQqtC4hEll8G/EjoeW/k2QwUc1MUB0fhtIvXZGrCY4VXHzL2ZXBC3mypBKfxjp8ybev9CEqC+XJ4XnU1KanXc07KxqafVY+PQ7S6nq9SNhgKXW1WnRZSR8jq4LkvEK5/cC5657hlhOrPGzdlcHF/rMVteu9w9GpH6sNQGV0ktHXvrWzewP83hlzNHrNGL1IS+EwFl+FdTZUEB+Ir6ZLjebV1W9ogFQMpXQ3fo5rJATZrZtcPYNiffeM2iEiuU/byGsi3gjML2Kkilj1T5aLy7jiggslYhoIzVyq2WIW+ZiAZlGTSXotiCIFZJLzrrGtDnCoqzOKFW0/l0bn+xAGsw0HWs924+p8VyqejIIEL6nKdNljKfqgwcyVtIMm9Jnf1jrfuIw49uOghVRpYhA8VUfUbo9Q3YRgxPT2cFJY13FPNfCocYrewUDdoD21V++sTJY5eFwJEgl6m+BKIusrkqFu9kAV757M+xhZV1Kn0ZUnie0I8El35RKbifQHTi+K7ksOvsrmxiiAJ1RqRqf7uX+uTxsXwSMcEQs/DW4MDZdqmKjfTVcvDl8YqHO/WaYwh0wbN6+tf5FDBmVG8+1P/M782lsazAdTNJ+sGD14GhsUyJe7CStaAX8NT6p7lAJQWEMdGGFPRao1hkNcT1P8WyfjXEFXd65nX7wSS9oLdbqmtYJPZCIFyKqAPh7+tgp3tpaWxcN9yjXlMnC+LReDa+Xop7x4QsL46Xvm809lnj/JtX
 Z+0j6ZfO
 uqYa6CyhjFx1eTjH5g9ggkuGzmnB2yUX3V8k4XBSpsbhAzxY6LiRI8lAc14nPOl3CFEEF5qvd/ARscinuPVXsLHUl/xevHv7ZIfL/HvWWLPhorlIhqSKL8+6/D1qkiIEw8lNN08JCA6ezfBQEspCtARXdnnJH7PbgEDQ7S2fM7rgOed3C9ZdzqSVst0F4+B1Iu8QnWC6a70IEVsf24VBwM2F6tgHq+hmkLTv1fn5A6GMuOEA/qRfwps6VthcoFRyDiMeLxN6YXuINWmbtifHZGzB5HZ/4Qy7RGz/I/6gjNiUbeTG5yTWB/iqtqlVxapnLykFeWqG346++4HFijn239lZ4Jg6htNSvj0NmuJehSGog8kCMut9wzK1bUV6RCzr7iMWP482+EMhmv9ZRQnJsIUQr4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and set the label from that copy. Writes larger than
PAGE_SIZE - 1 bytes fail with -EINVAL from procfs now. A write that
large only ever worked when most of it was trailing newlines or came
after a NUL, ntfs_set_label() refused a label that long with
-ENAMETOOLONG or -EFBIG.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs3/super.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index cd47839872b0..cdeccbe506e8 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -560,37 +560,28 @@ static int ntfs3_label_show(struct seq_file *m, void *o)
 }
 
 /* write /proc/fs/ntfs3/<dev>/label */
-static ssize_t ntfs3_label_write(struct file *file, const char __user *buffer,
-				 size_t count, loff_t *ppos)
+static ssize_t ntfs3_label_write(struct file *file, char *buf, size_t count,
+				 loff_t *ppos)
 {
 	int err;
 	struct super_block *sb = pde_data(file_inode(file));
-	ssize_t ret = count;
-	u8 *label;
+	size_t len = count;
 
 	if (sb_rdonly(sb))
 		return -EROFS;
 
-	label = memdup_user(buffer, count);
-	if (IS_ERR(label))
-		return PTR_ERR(label);
+	while (len > 0 && buf[len - 1] == '\n')
+		len -= 1;
 
-	while (ret > 0 && label[ret - 1] == '\n')
-		ret -= 1;
-
-	err = ntfs_set_label(sb->s_fs_info, label, ret);
+	err = ntfs_set_label(sb->s_fs_info, (u8 *)buf, len);
 
 	if (err < 0) {
 		ntfs_err(sb, "failed (%d) to write label", err);
-		ret = err;
-		goto out;
+		return err;
 	}
 
 	*ppos += count;
-	ret = count;
-out:
-	kfree(label);
-	return ret;
+	return count;
 }
 
 static const struct proc_ops ntfs3_volinfo_fops = {
@@ -599,7 +590,7 @@ static const struct proc_ops ntfs3_volinfo_fops = {
 
 static const struct proc_ops ntfs3_label_fops = {
 	.proc_show = ntfs3_label_show,
-	.proc_write = ntfs3_label_write,
+	.proc_write_buf = ntfs3_label_write,
 };
 
 static void ntfs_create_procdir(struct super_block *sb)

-- 
2.53.0


