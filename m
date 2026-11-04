Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDE760960A6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KLjIE+/Q
Received: by kanga.kvack.org (Postfix)
	id A26BC6B05B2; Wed,  4 Nov 2026 14:52:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7A56B05C2; Wed,  4 Nov 2026 14:52:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90DED6B05D6; Wed,  4 Nov 2026 14:52:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0446B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:52:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 091F61C4232
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:52:54 +0000 (UTC)
X-FDA: 85398484668.02.FDE7435
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4141F40009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:52:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KLjIE+/Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6t+ZjLlcl2UBfeg6Fa8p1cvIAPOQLpJeTR6f8fh14w=;
	b=AO/jr9qwIu7NfW1hb5VEMJFYOWzntfROMMOV6X7dIJ8gyXCN28Dq6uSTmTqxlptyQlEKII
	cFyWUMCU1FVnarWrfa2UGrNjBVSwyRoCaVwn8Z9lk99pyJk4vMUVSQXNJSSKg+rvYI/h1m
	TO1KvMybwzeO0LAw3O1Kx7ASDIREtP4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KLjIE+/Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821972;
	b=I34mOLKUoXnKZhKr4A0FyNiD0Ab9DUXvPAq3jAlxELWzaBHgAgk8MIO4CHkuoW6HQEP3JZ
	bb/8ODoa2ywnCE4dRYt+A2tiKb4Yv3OPME0IygE1yNJYAdGGqdwpvr2Xh2qrmXg5I99H1I
	K+IISjqjG12cvGrMO5PdlQ95J1JP8rU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91D6B40BA8;
	Wed,  4 Nov 2026 19:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41F61F000C1;
	Wed,  4 Nov 2026 19:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821971;
	bh=e6t+ZjLlcl2UBfeg6Fa8p1cvIAPOQLpJeTR6f8fh14w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLjIE+/QNPHQxRMuCW8dNWrCESqWYvISK46/mUNfKpIgCeoSJrgdmk8SkA+ATO7fz
	 FQ35566DIX+9ELnqg3Z9GTJZVRHI0Yud/AS1kcEPVIP4YYuS1YcVbpva0834j+U661
	 zMbjWJhPBVN/B6AggdgAVcfnGjd0hy36FXoA4988MkNbj3t9KGlQbCTtGn7Lq2oNiZ
	 gGsYSEMs37D5ZgHR4oyjLALRPtfTPAqhoQzZUV4znTfOb3VdD3io2MsyW92keql0Yw
	 gt21nsu4wFZgpw+3R20mXpoc8hVC/Rl4c9wnw34AaHdv6yMO/CIYavsN1nHMGTso6j
	 wpMlLdPvqyidA==
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
Subject: [PATCH RESEND v2 12/30] locking/lockdep: let procfs own the seq_file of /proc/lock_stat
Date: Wed,  4 Nov 2026 20:52:36 +0100
Message-ID: <20261104-work-procfs-fs-v2-12-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2606; i=brauner@kernel.org; h=from:subject:message-id; bh=wBxYZkbuLq2vx9tHnE9HzeQESu+Hnu4x6fVoBaGOq2s=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97rHsKW7c7qUfM/PTyqkXDu+wq5XQEdy7ZO/qHSlN8 2c3iPGIdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk6X+GfxavvpfVCmqsYy1b snqPxz3N8Ixjy2XenP/qsrrNPb/9wHyG/8WvPvNeb/4aOLFJQX7j5++rlv/axfqsyHddVbdZebv ZIzYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4141F40009
X-Stat-Signature: 93qntnq5ez51c7anwmaxnx3p3r6zh1su
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821972-363765
X-HE-Meta: U2FsdGVkX1/R1tHUrzNWFpmPnlMCTECmjrATb8LkEJSJ3i/3sllUosomj2w4OAqEWS3zbBjem85sHWPYnyV4IvrkdnQLbPAr95HRif2LkJf48Ckgh0H9vxg8fFxaRiOdyKhu1640+ZIZwE6O00JX59c+7pDKvn+KzX1say2688aHyep2KpGs+qKt5ryGnd1FebRmcUkKeSCB5p9ANJsythScwF0LCUdskf7/MNQiMZQnzsRXinPNQSmNoBrP0Wioj3ZXPN0Quq436BJjoRESVm8yHxOLbYPUyf6KtwaMDw5Pj65P9Y4eHCJYEvffvb+eBcBSzD4TW2j7vscucnBgNyjbi14CeO0ylrn86dvYNu33EjSTm9sPr8sdSgYb3XpL45l5wYM/BUnmzfmBU2hKNWnjgMvO/l2pBQ2SkI5dKm0TjC/kkf8yqq3Z+wqMalbRBF8QnHXxKIi1mSWu+GossgRIESfEreP4Pae/T31a09jBhGTFho3PgCFRQF1FB0QkUQWF/wBRnevdS4HI/+KAYqItmRMdKVRJ54PGhj4h0igFpt3WCeSoeuw+jos5lN/iFBlDTnnZ9Lwms7WgJldiXfW1jr9S/3D7I35FYw6o4C4fdlMv7gpLMICi2FSKciRmSTNHUmycWbmUw5XkJXUaoOL5KHTkazey6mjYcuhcX7yVtdPAo1msWSGzA0tfGR8uUWgFuGfTbsAxLJsn1j1+bx/I3S0Pb7cUdpZ6fQZhrRQD8gyqVn9rQA2M1gkF5TYsDbA/MVBjZg0bzMIHsXvBi8OBFe4uwrwFUvhrxY59GMdhzIshZpcV+DQtGg09HAb5dUr/95y9CazrThwYb71nT6je48wctziZsUD+yXWf8VhZ0+GZMqcQJ+H6G5yQ2xPRyUlZ196uOfSa+8l9U8rvKAcKwUYQqanog7/ArRGE5WjTKy6CHq5z0aVTis726PVmhqPlI41/yOBXCy8UPCy
 3Kcz2598
 D4zbz1pCEfVGfXCFvRmaXY8Xf3ujcA9f3tbiFoostTStRbCR4jEaixu4/VxtNDx/dwloua/NQE9FBG25bhhZ+jW6+3qoLQTJo6AYvTB7c1nGBquH7CQnfPpnrNkRfDaEfW9hV4y8+4YFS1A22R+S6tEyHZhEUnMpwoy9KsAvEQ7iaXMPW0wXU/1+AzVnOxHbedBjIM8Cu+BwHR/qSqdWgoKfv9cE99LELLeJcFUCSvHn9prDHz6An0bpH1/Htco2yUtHlz216tuT9h52Io8PoqnkiLHoxWTIHh8Pfa1zbPtgwe/X+6b4iOYLXX5/OAA3RZyUtDvG2vimjD4nd0wFDOrEdBYU/gvP/WqBabpPDpUtRpD7uquc5dSvjOvZqggSBU+4BbtF5jtgc/P4c5XCqCAIfrRFcZ/Uq7MDvHStW4V4Q2DPcjH/t4asEee3//vqzGiGx
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


