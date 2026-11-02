Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 299486080587
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BaGFkmgd
Received: by kanga.kvack.org (Postfix)
	id 18F5F6B0619; Mon,  2 Nov 2026 10:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1668A6B061A; Mon,  2 Nov 2026 10:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C776B061B; Mon,  2 Nov 2026 10:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB1616B0619
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:21:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74474A014C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:21:55 +0000 (UTC)
X-FDA: 85390544190.19.7AB79E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9EBA480015
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:21:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BaGFkmgd;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632913;
	b=pdBugZTO3q7hA517uUZckiyF7hM8dRTj8u7T59vxwnNJ23jE6c3Dei+9GHzNruxKCOHgLD
	3WSYtje39WhdwA2UJdW56+l8opCRa0wckBKYQl/7rEsrR5B4eJV/Bt+T+NOm9UaD0s/P96
	NWg8jkH5OhOtYdJgGKoIMCBnFpkLNgg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BaGFkmgd;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Br5BKTNsV9SKJ+VKUXfa+LuXFyw/MNJN1rBJWSG1Dk=;
	b=zDxRwmezItBUBZOGtsCIJkg4kHlKX3jsz01SeUsl55NnCtLZWTjtb0O5HrTbWhFhsyaewK
	0kT5QAbAS4F8qeLO5h1MOmF3e1BvEZ/HsHhTr/RZ7bZ3QARfqigw61oJ9qhkF2FdyV1bzd
	24ekhcW62Zj8yOJNxx9uJmhZU3D+Ho4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE21343AA4;
	Mon,  2 Nov 2026 15:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A5D1F00A16;
	Mon,  2 Nov 2026 15:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632912;
	bh=+Br5BKTNsV9SKJ+VKUXfa+LuXFyw/MNJN1rBJWSG1Dk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BaGFkmgddplAg+7kWtOO3Xs2bTNw6C/l7s/H+s/ARAFWAG8PiIzq4DHKs1pIJtkZF
	 MLQLlN2WfsWYgrHwMGc+LaYjthSVIYcPsAQ4ZVs0x8SWftIxeVXIb74Yi6DeQgLPv3
	 MnvwnjVA4w76GNzJNNroqO1Ub2Of7dy2AD2kO3QhN5NULX8sENf6yS60Ffvc4YDPhz
	 AVUwEuacSjAOwoVTTIoFEsTOOa+8af3coYqbYIzhqzqGrILTs/bIDcsXX7gywt7ryQ
	 fcrmpnyg6ue+WCi9ocPVHrRqPbxVSWScBXs/eHykFP/KwB1QkPorU1BSb4GtLYc/Ew
	 +SFzyKl+Rjtbg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:17 +0100
Subject: [PATCH RFC 07/27] ntfs3: let procfs copy in writes to the label
 file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-7-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2130; i=brauner@kernel.org;
 h=from:subject:message-id; bh=1xpKZw46Wve9Gi/wwfJco67jsfuLoZVG6n9ZzMkX5cA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG70gMfQcsmsxZVZlz3llvU6P9Q+FGFvnWXM+sG1i
 OvlzHMNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZtYzhr8TWhVUbp6lu+ajh
 slFF/whfzqNX3hf5107YP/PoQl9+338M/32S/bhdbNlEs9ZN/nX/VOfslLOLVi/+18m6pJt1w+5
 V8TwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EBA480015
X-Stat-Signature: bry76ezojmzypqhbrho7qfrnq4eqxi7t
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632913-282685
X-HE-Meta: U2FsdGVkX1854ZZDBt4LuLDnVOoJ6jsv1LtZBjN2/wS2ac4/NdV+JikuAQq5yXwbzNLUBgDJ5u+2SFHXm90QycqcWqRwRcSd6dgJu93L8PGMJDUbIBRELeyp3W+s3sX3K2dkCKKOUxTUEviC/Oy2yeD3Ny3NcaATCSdfJSqKMwZwWZfGSQ/rOoNIDWvWAhhRxUW3zXjkKuLbZV7OZJfu9owr7tTGx08bfczBlt6Xg3OlEF8KT7x/Hc5EoL6hoL4XUADS+QTAsuD4wBb0rP8CRnsPWarle+koIqTW1+ZsTf7LlJspN+BYLdMA7zF6Fck1CNKnTOEZkIIJdicK346GtIphfdVvy5Z3fTRG5MUWWN92s2grU+enM3+8YGkD04w20S/tTaL3otSqBtIYF5zIgSrJaz7LtHvj3WX3rw7zRupjgXOk5IfhsSX3Q01mJKP48nI+YQVGXQ1vvOSaWcjnizbJnVMnjGorhA4kiZzPC9r2kKHqv20XBXuHY1VgbVgO0hi0ggnYkZA1pt5nxhmm5VuJSloP4cZbSboyKGlHrncPi7otBcHyQaldMJfItkeh4bPvY0CjLvjrU4hvT8LLbak7itHRGQs/HUx0Oz46AEZ3Er1dXOrbDq/B2h1181SXG4bRC6SNG1Io7Ybkq0BGs0tp2vK6YMukPTY+LDvmKcv3jgw9T6O/aWrbOUyIJQbLRSGMn9F529vw3Rr1lCpgU6Vrjt72F6b0zP4PRlFwWGmUyLx6yy4cKJ9NTsSb6VpCQ90pZ2cxiOGwuSCl1UFbvhGLHkjrBjRJIExLV23neu82CqleR9eYGGUvaf/ZXAwI5aYItP3SVXfIGr9w3J/yZnwmPLxGhUE+Pb/StRLOFoFYalCkSfEVnEawBcbNH4kwq8tfm/AyyxKV5y0IKNh+IeUpbM7fOk855TjL/1oaYbZ0hVIf5imBc2S6QeXVin0Kg4CfFWHkAZWzrpVC0fu
 tykKlB6r
 Kt7HZ2hcvIpn/k4eeTGwPRRFVf9vd0vOwsdXGqkX4vsdHtyeMXkpvVd1NjUnVGh6dZzrkevvBM75Lf9dl67Ig0wXtcaxdTMqrhPuQshUr8kiWeH2FT5cz7PhwIl0ZZro7cSKoshwh92IjSbDkOQh32TXShblFXWOCwOjmGZxqRcx0He6VGumAQNzwmCDHS//R9GOyUlWGBaW+9HQHXWysVsvV8Nu2GN/u7uLsTZPkdnbCMUlEsZ0C08E5xUQqwo3vNEAO0uDjSJmM4AGarftVZ8MPVoFujvCKSmIB
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
index 3d669e957ea4..fca73d2766c0 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -536,37 +536,28 @@ static int ntfs3_label_show(struct seq_file *m, void *o)
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
@@ -575,7 +566,7 @@ static const struct proc_ops ntfs3_volinfo_fops = {
 
 static const struct proc_ops ntfs3_label_fops = {
 	.proc_show = ntfs3_label_show,
-	.proc_write = ntfs3_label_write,
+	.proc_write_buf = ntfs3_label_write,
 };
 
 static void ntfs_create_procdir(struct super_block *sb)

-- 
2.53.0


