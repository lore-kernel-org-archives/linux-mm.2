Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DAB60DBA45
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SRuzWbzB
Received: by kanga.kvack.org (Postfix)
	id 64FEA6B05D6; Wed,  4 Nov 2026 14:53:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627B96B05D9; Wed,  4 Nov 2026 14:53:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53DB96B05DC; Wed,  4 Nov 2026 14:53:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35D066B05D6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:53:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D01791A0856
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:53:08 +0000 (UTC)
X-FDA: 85398485256.01.5A1E3A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 250411C000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:53:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRuzWbzB;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DA6RuBvRtTkFqswtNQb2uYlEiZpU59l9tIHU1Ga2j8=;
	b=rFM5ygR1lPx8jiouLgQT3cWSPyxMeAk4aweIn1Sw8hiCAiHryEjeMdLD1O6a4aX4I8iyMn
	zpqKxeAOw50yi75UWja6B/8cvYKVmFDj3SqGv8pa3btp6hX18M3oUon0Zg7q8WYJKEMClz
	WPF3csgxHuGoXBcnd185PzqKpQhk98Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRuzWbzB;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821987;
	b=0A6FTsRKOxya9vIzw29otSBQZikK8Bge3hwwAe9KVFCundSyf87ufwoRMfclYnjbCl1WAd
	VAXomWQgC432rDbBpSuIKXkj5vl/V8xF9zFOD1SbnWnT0JeZIJ37PfmtjahRKssarPyFFb
	TxDjnaUuTdnVuN9oJe6evLdqTNa4hCc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3A9060F18;
	Wed,  4 Nov 2026 19:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630E91F000C1;
	Wed,  4 Nov 2026 19:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821986;
	bh=0DA6RuBvRtTkFqswtNQb2uYlEiZpU59l9tIHU1Ga2j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRuzWbzBA/Ayk18PSyfBxT/OLXbTcYla80E66c/JAUTNKWwvu8J+iV96HiiS6uEcH
	 QHS7YxPFtx6Ioglu8rsGqiQzEoeQ8bEbGSKEx4XN8omB6KX5mlTYTqW0Wk6eUgmEQB
	 B+z770ZN0h6sM7vDGdXR9zfXGIS1XJndXGgje4DTMOIYeLURXu2T1GmuCPMzPMxK7S
	 nurIEXlnG0ZIr4a8/L+heetwhEB8F1E5hs5NCWlfyBW+GWY4C/S4AmxGoDaGeMs9Vs
	 f5F7cAhX60Ts55MnyTtdNSbrqHrZaPAO/QFQ6TbKEkPr3xHro9JRcDthamnh6QpgBO
	 gt08JD3Kfhntg==
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
Subject: [PATCH RESEND v2 13/30] locking/lockdep: let procfs copy in writes to /proc/lock_stat
Date: Wed,  4 Nov 2026 20:52:51 +0100
Message-ID: <20261104-work-procfs-fs-v2-13-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1505; i=brauner@kernel.org; h=from:subject:message-id; bh=8vcSfGoyDeqLJaquRqiN2D+SQsNeRK8HAS3H3FbecE8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97rEyKlv/n0U+Ncf4zZ0z/k8rXxQFN5xqvbLjdI24b /iyrX7bOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZSJsLIsDDpMX+EXH+FfOlz /4uiJpUibR6mKrvnlKufSe+7ojVxOyPDsftVl+Qu1LCnTp70o3zhxgUrJCWyJ/n6XbbhU5x210y eCQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fgjw8k4t3xmoxym7a4xerje1awjs3nxs
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 250411C000C
X-HE-Tag: 1793821986-369390
X-HE-Meta: U2FsdGVkX1+b9FC8OETYvetifFijijy12GxxJB+JmUHj/xsYXSstqaWtk7ONEs2I1b1G1juUpXTpRygNuBXLtf8ojghgDdytBEEF1poqa+ygtpxlF+Ov6o8p8/r7BQmThDM8FnARMCRZsWIrxKxteOKdkPs/GM/KG3Jz0eul/KVqC7nG7zH3D2vgUCmAi5D/asq0SrqGbtf6hoKe1scuULKJ2GtiGiIT5QJ+z+z6mFMA3VFKhASULgky4WQlpZB0rrXcYd6HdfmcxywqhOn9QT2fBbLEpjyDsHLmZBmFPDBzxIQUH6tw3TzyBgqCBxWFa6Hwy0hcdxGCzfQLz/1/kx7x3kBR7KnPIaddj+h1UMc5zNarfJA3G9u1j89BOf8nZn+JjiXjQdKDewutGRh9HHt6Qp61j40DsU/aRTcjF+fuCbIUCLsXzRb2WUg1yqeG9mhsslxJ8BFnBsVIfFX/U87DTg+VhKlXmGcGO7CVCXEOY3fmACHbxX8jHcaRe1lGsHwe9kzO8absD7Q7ZCNRakp/SCHmJa+llBa3R5mTm/8t4dut/V63bVP6vd8qctkdrVgw7xtvMZ0xCWN/5fUjD5NvECIBL8GiRUvH6pJEhcevO7YiaxRAiZ3nEAijdgwJvV8tvcrwa8HZvo7x4bA0iQq5u7DwzNbK5TnWpl6C847mvWz7YDqQpCDWaTuMsuEA+2KUgMEdQlgt9B+DcIS9UrZU1sODRicL+MIZsVto3UctvnhKHoxo3+bjEia0un/knkAr0SI7fGsZvO+nD957FnX7BW12iiom99PgFpR3VmCxr4/yBJ3moVbBwqCfxWYS3tLM27i41WcF0QaNIpM1vUmqTmy55I/s8c0pozrBmyBmsj2sYroJaBdH0glE1tsHnzjuS9OoMPYmmGMVzbI+ip+tVnYy0DIS0jZQP0kjmJApjPhfxosMf+hatMB8ygXrQcvH9O/tyLbkjEDnujx
 6V2GBdig
 4MICeQulKD+x0VyoNds30VTvjUv2vUeMBoGD/2Dz2Fl7rjixjlAi2KYMyVntguILciLj9t216tNQliypEsyiupUpbvxYbztLqT4F9qeF3sBIpxcQ1/8yBP+wkiiplIhPBfGeNphfH0HjI+siOqXxeZTyRhgtTS3tZspQRKeqbaFWnd+vi3YnU6x0Xlq3O9GxDYhiropHeTj5Mw77iXstguOGZktmmug3rApeloWAZtr+s2/gJM38Xa4utAVjltdwdr8OV8YfDZILTP91xDR7LdrOMUH6n7gPPPfpm2PdCm/MS1QjmeDWj0NDza7pyqyTQvv523rUjimBttZG1uSbCQ3icDzxWKXwlI881VPnXRPVJ7RuZppGZ/KXHwSHlRotcSUDDdL59U30Rf4GXSTTSk58bLlMojuKCZSkfBonsvJ5q1ifD0Fi6fjHiKq3KrAtdBq69
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and look at the first character of that copy. Writes
larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/locking/lockdep_proc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index 9b034b5b94bd..2a66ea09c2aa 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -669,18 +669,14 @@ static int lock_stat_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t lock_stat_write(struct file *file, const char __user *buf,
-			       size_t count, loff_t *ppos)
+static ssize_t lock_stat_write(struct file *file, char *buf, size_t count,
+			       loff_t *ppos)
 {
 	struct lock_class *class;
 	unsigned long idx;
-	char c;
 
 	if (count) {
-		if (get_user(c, buf))
-			return -EFAULT;
-
-		if (c != '0')
+		if (buf[0] != '0')
 			return count;
 
 		iterate_lock_classes(idx, class) {
@@ -703,7 +699,7 @@ static int lock_stat_release(struct inode *inode, struct file *file)
 static const struct proc_ops lock_stat_proc_ops = {
 	.proc_seq_ops	= &lockstat_ops,
 	.proc_open	= lock_stat_open,
-	.proc_write	= lock_stat_write,
+	.proc_write_buf	= lock_stat_write,
 	.proc_release	= lock_stat_release,
 };
 #endif /* CONFIG_LOCK_STAT */

-- 
2.53.0


