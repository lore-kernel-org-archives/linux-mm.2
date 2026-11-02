Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C58AB606A90C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vyc0TIAk
Received: by kanga.kvack.org (Postfix)
	id E63696B05DF; Mon,  2 Nov 2026 10:23:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13C46B05E1; Mon,  2 Nov 2026 10:23:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A626B05E8; Mon,  2 Nov 2026 10:23:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2E766B05DF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:23:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57F4814019A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:23:54 +0000 (UTC)
X-FDA: 85390549188.19.ABBE29C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6A5F2C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:23:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vyc0TIAk;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6t+ZjLlcl2UBfeg6Fa8p1cvIAPOQLpJeTR6f8fh14w=;
	b=j+MfokqHp9Bbbqt3QVcipBpnFHp1jVk3yPd6DOpsI8E1iPRCDUnsaN4BE4CsosFK2sWUoZ
	e2vxcjo8dWduQh6AOzD0tR5O16ULym+cgD2al2PUrWAy0E7X/bRdVWpRWZ7h7T3yTpEB8+
	4DPVmiWW1BFairzV7kxdZHMSw+SXEkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633032;
	b=gy9x5pRZ01DuUMPBBP3gxyF28Qn9Xpf72iJEuuPwFtYiMuraXuxoixiKM0ij/NkyO7xJT4
	E+ihHrToEc2wz8d+lfxV0Z6d1CNlsfJnMaxBgy/ZlIGrr89DRMbV5YknAwtWZCk44+MwBT
	iAK3RbGckoBbZe3KuP14d7UKgVC/9ds=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vyc0TIAk;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B983A41FB9;
	Mon,  2 Nov 2026 15:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AFC1F00A17;
	Mon,  2 Nov 2026 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633031;
	bh=e6t+ZjLlcl2UBfeg6Fa8p1cvIAPOQLpJeTR6f8fh14w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Vyc0TIAkWtCaXuSIcqkzHLeKxyzrJXWfZdR7KJ6r92hFll9vSXVA6wBZRD3vYY+uB
	 3sZVdE2NFmTbgG2ddW0Dunqa+sx427e4/M6eCyX7YNulxzXA/Y7RrUt1CRtv0WV1c1
	 VnSdyrjZW1T7JnIrNFbHUTB5G0y2F7yNJ7aKsb2ZXNUPpTdBj7EAlKl0htLsJDFAU0
	 GwPSMja/JtXpY9i9oMZ1zVIV10/ZlPAajmqJjQDUDjAhADIX3yaC33ZI9nceLo+jVL
	 nntEU+f/qQxM5Cqc+RfMImzf9pBGn9CnD6PB9Mfk8jOBpiv3i5NqevVbA17WMV+SOd
	 Cvqc70uXuktPA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:22 +0100
Subject: [PATCH RFC 12/27] locking/lockdep: let procfs own the seq_file of
 /proc/lock_stat
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-12-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2606; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wBxYZkbuLq2vx9tHnE9HzeQESu+Hnu4x6fVoBaGOq2s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG4U7TXpwSSf2Lct89uWhW6YtPjWvccbVb/PU9T+v
 vr4N3Ez/Y5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJeLkzMrw79v+ffdeGm4Jz
 BNPPLvqwVv2j7OqCSNWSaz/OrW1U/T6D4X/epKx5u14mSBWsvqm6pl/ZYFGsw6souyT3eiYxK2W
 lbj4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A5F2C0004
X-Stat-Signature: rcrihjowdipcfdrtrkyutcszh6bzyijn
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633032-125438
X-HE-Meta: U2FsdGVkX1/SXWt3CjobcmIZAAefrQPya4fLypi5asPT3EgahQd9VcGkXLOetjVK40ByrzVSFK4BHzOKcwYJwHdEM2tVEO7Z0hyDOxs/W2Bv66ub6N9NgaLdvywpYKyKdlMTUjpXgwLzJnlgdaXsa0Wu/S7IAVFDhMWn/tX/APS/pXwP11+cxykXCA1q+F09u+FBE0f4TSZ6+PhUBvVCSkQJOBG0giQpGd+4KIEk+03TrmaYI07Oq/T/9SRfaLxCzJmWuareQ/IRER0C3LnQTpvUCsTuzWXQjQjKvHg1yLnS6BKoKEE83Jsjxe8rlmkBL1myKBX/v0uDk5VbeLt8PZoWlkPety9YmE48X6OcONRJjk6XnW2FWJXkS02rRIsmckwfxAsrVLgmsI0aBZEWVQaUm2FjmCpNgU0WLTEJXDPIGlANC5lmJWJhItud5T8JV0rfLhGqs7tqsBccXjA/tNLcGm+DbattohYynrBuAC81iRNsHLZjOACsgQMdKY9pMBf8qXOD8n3tD3qqseHjFZsfusURHmTaglnSf1azDKMVIbHlU9sqHc6iLfTxV3s/U29R2CMP+0J5tR9vz9IiuNpaygMK9sD3yJtobPdDh5xuOe7qP4bS8l6UuEia9WOV41VTu73eOqHhcqz55gREMUA8t+lQRkPLvbMkVBKQ9HYTtUKAsg9X7i2o73tIBdj/xhAU41fSuFZZaSyjaNzsxdY+zlQlJjZtJaxArYZdugrWm+qxSijqFq2sknDS7plnnSwktrf0o2IzV0XMx6F0/11Bpq6pWR0uGz9UCGyPens0aCncS2WwInlkj1KY2iBQiIaavkx20NrsFPMQP7Ge4hnUo3J9cOHVVeqkv/vf6WxUr8XXJ/thhUAf27B/vXOAScr4RCL9GBcCZZB0CU8YMSMZrZTudbGc75vNyJBsWyPkcjop5rKS4c01IviaKUHPka3DFi2EF1RUOMsywyq
 5aUv8ziE
 65fVPx/4GIlIBSpsXH2Ca8Q6nU3loWQ106ib7f/cQYv9WeSXNdzMIv1a2TozHewBVHHKnb1Y3fwI36gH2XQ7fCfzA80VkhItxxdWGZzwNKo9H0xCcyDtiE82VdTBXSkWoySXgnqUWCKYj84qqH2yQRTzC4m22bBdxc49QCOxu5GA1Z8dvbN25g8qaURuxT3fug5j+eTh2Bat5Mps6IWhRXqI4IE8EKHqQZx20VZdTNXhssy5ctSV7pJr/jGZ4i6KT59atUe9+1W+xD0R525FNMGFKaPJ3AeNDD4Nv20i9s9OKbksWhK304rtnWfjK2jb5WtkqbSAafy5DYCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file.
->proc_open() only takes the snapshot of the statistics now and
->proc_release() frees it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/locking/lockdep_proc.c | 48 +++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index 1916db9aa46b..9b034b5b94bd 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -638,40 +638,35 @@ static const struct seq_operations lockstat_ops = {
 	.show	= ls_show,
 };
 
+/* procfs opens the seq_file */
 static int lock_stat_open(struct inode *inode, struct file *file)
 {
-	int res;
-	struct lock_class *class;
 	struct lock_stat_seq *data = vmalloc(sizeof(struct lock_stat_seq));
+	struct lock_stat_data *iter;
+	struct seq_file *m = file->private_data;
+	struct lock_class *class;
+	unsigned long idx;
 
 	if (!data)
 		return -ENOMEM;
 
-	res = seq_open(file, &lockstat_ops);
-	if (!res) {
-		struct lock_stat_data *iter = data->stats;
-		struct seq_file *m = file->private_data;
-		unsigned long idx;
-
-		iterate_lock_classes(idx, class) {
-			if (!test_bit(idx, lock_classes_in_use))
-				continue;
-			iter->class = class;
-			lock_stats(class, &iter->stats);
-			iter++;
-		}
-
-		data->iter_end = iter;
+	iter = data->stats;
+	iterate_lock_classes(idx, class) {
+		if (!test_bit(idx, lock_classes_in_use))
+			continue;
+		iter->class = class;
+		lock_stats(class, &iter->stats);
+		iter++;
+	}
 
-		sort(data->stats, data->iter_end - data->stats,
-				sizeof(struct lock_stat_data),
-				lock_stat_cmp, NULL);
+	data->iter_end = iter;
 
-		m->private = data;
-	} else
-		vfree(data);
+	sort(data->stats, data->iter_end - data->stats,
+			sizeof(struct lock_stat_data),
+			lock_stat_cmp, NULL);
 
-	return res;
+	m->private = data;
+	return 0;
 }
 
 static ssize_t lock_stat_write(struct file *file, const char __user *buf,
@@ -702,14 +697,13 @@ static int lock_stat_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 
 	vfree(seq->private);
-	return seq_release(inode, file);
+	return 0;
 }
 
 static const struct proc_ops lock_stat_proc_ops = {
+	.proc_seq_ops	= &lockstat_ops,
 	.proc_open	= lock_stat_open,
 	.proc_write	= lock_stat_write,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= lock_stat_release,
 };
 #endif /* CONFIG_LOCK_STAT */

-- 
2.53.0


