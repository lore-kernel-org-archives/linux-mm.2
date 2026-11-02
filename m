Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136A56083617
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPntUaej
Received: by kanga.kvack.org (Postfix)
	id 2A9DD6B05FF; Mon,  2 Nov 2026 10:26:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282126B0600; Mon,  2 Nov 2026 10:26:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1702C6B0601; Mon,  2 Nov 2026 10:26:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC2E26B05FF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:26:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C12DC013E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:26:35 +0000 (UTC)
X-FDA: 85390555950.18.1E5311D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B47C710000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:26:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPntUaej;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1VqjUGL5+J0t5hj5seZeRe1Maiv3S9hp7Jj5OG0/0s=;
	b=FHGDRu33VEnFJC7KBA3DOYPSAKYpRDRXuZEs9WvcQRlXmLY5pXIg/w7ervxpOAZD4MPJXR
	ZM2fGSfZqP8Bc/HF5nzqVAyhSSnTLNJhfd7f66Rn9iqxghq8btEAXJm2ZWPEHgSuoXyKyI
	qtXTC8Jov0mNyl0KVp5IDaAtw2IwUnM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633193;
	b=h2Hllcr1FxRlYT7J5zm47Zt//dYf/+r2WziInejtSBFPOZICq3f+hXDk5pIGSbSK7DW5K8
	UXJIm2HxmarFtiVppkxwub7vWEK9mCyskM5U1vOKkYsnumPS0T/09NTLNqJp8tkmyUNttB
	JK6MWT/e/DXMCNFxRQcBPqBOHAGcTOc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPntUaej;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F5CF419A5;
	Mon,  2 Nov 2026 15:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7DB1F00A16;
	Mon,  2 Nov 2026 15:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633192;
	bh=R1VqjUGL5+J0t5hj5seZeRe1Maiv3S9hp7Jj5OG0/0s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LPntUaejzzAUOTRvUNS0Y1GMbnPApCWQqcTwI13UUCKXze90UPLxxpRnGW90okaRN
	 /SIo51jvsTdg8UsLHm4uePjBeYyLPk3KVJ4wuqLBYJhjSGrlhysCaMmn5I/CkJ1pd9
	 ZHTI/3+dLOQ6JzTqFxt6SjCj+4pjEdhhbPGoo6W+bAjQGlPVV4SQHQDv7/I/vWQIJ6
	 /fi/xyM0dOZwYg9ycwAhjjdk4lSHA97j+wFr9FXI3WUCvPAnDgHJoyNjjrjgyn1Ef4
	 i8wvejafrNc0aiVo0X6lBeVv6XILV8EgxhSfBWL+BkF8M9XALmyKKUOR1IJtwGwMO0
	 zz5ZY6ZT8QG2Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:29 +0100
Subject: [PATCH RFC 19/27] kallsyms: let procfs own the seq_file of
 /proc/kallsyms
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-19-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1331; i=brauner@kernel.org;
 h=from:subject:message-id; bh=X1hXUo+P6dAEkQI4HVxBka/iuP3neD063cymPGxvXEU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7E86Wn6bItX8PRGc932QRueyvG/7r7fdz1LQabT
 jt31lYxdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkdQkjQ2/ojiqupX4S/zNi
 eAuad2pzvL4hu4l32d2bRa7rPvysnMjIcOC061HJ9ce7zeXr+fWZln6azCZ4Zf56HXH9smbnqy8
 vsQMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B47C710000D
X-Stat-Signature: awb5k4hsaojydm3j55uzycbxusm78g43
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633193-959111
X-HE-Meta: U2FsdGVkX1+LLB2wP0O5UMhyZDeiESS+fc/HIDTjKk2meSEGX4cT2c/9z04f0H7cw2NlU2lEZ1W6BTKjpAIx0gkw/jua+UZN2RKlNZ739qZPWNCOgT9bJAjNb0ckCubE0hmuTM4A7phebRMIbuDMhjo+t4lDl9wlbsA2HfKg6azlxBJxjlYl65xQHGwajNNc5etpfMiwHD2P4v7x3uny0TQigRoZlcD9Li915k9zKGw8YtOiv5yKJ8+HMDTxpIXY/GAv4EZSlL1j1G2i8Tl++RjGoFUHFqRAupax9PEgkzgEzG6fLsty1h6QX5kuxrYNTnJxpet8MvhPisqoweT5Y/b2stwp4HWPsbtGRBzis7UIf3ixw8UnXjXDp7sito1Del8Lc4Yi1kBgEGNgF3WPQ5DFLelYaoLEvbqkSI4cSU5PfQEC0QIggxpo2/rKGfszt9BZJ0Z6rEBZOrC2EOBssnjXKuRU/Whgu8S5FoqCLcYAlA8TPWj0PpXHaM5Gvjcuqp3KRqYmfzOuBiSuewPh8cPIQVAUq5l9gMw/3SQ7hiMExxzIyq/LMcFmiPHguKbZ2t05iYX3Wjr5/TTKHy7CiQhAEphkpWMRDxZK2oe7402J3w3ZLAKV+zWJh2oPknCCXbD38B1M5njuSRxosVS9hVuXj6A+bA0Mn0fOd7rR3trUktjxQZyXsp5RHyuK8FQ5nAx84xJ8gri+30iev14JWf3R2L/kvXtTpIqmtM5KN6ILkNxdlqsgUBU7V8+UIRXXlTZGe6WB6hOipsmmgi/iJqJNzpV/oKxAFHJfIGkjks43dPHn9PIy1+rj/76I+/fCXhSyJf7uNgJmrWOuRSU+1Pa6dxw7unnbsh3ReXbRY7dRYwaHLRvRIyZ9xBpo0ERmiVY8A8SrGeiTLl6XUgSQBKnmAZ0th/3umS9SrrKnvd/2PRUO778UxJ4F968m4Q9U9lRz6OUbmtQqzpKUlYc
 /qVmLMKs
 bLdiZxdgbo1zaAXP/vZydLSsJ+MRpnoGo6GeNNLv4JPUgZ/OFwhrRoI9s+ykPdmWTgplLuyZrTuIdlaVNy6/gZFU+k9L/3e41I4qABfuUh1vm3FcYwC3QxDyR3fiIr45VXb5CIoUC+Lwoc3SbTLXPCxBDQsQau3vh3MczHo92FRXWIkU0n6ATXSNdafK/Fraa3QXt7+klPZS/CH9uiq2qsIaN6Lp0fBhYEKykGzdV2M2VMfh9EgD1EsCH+f/biDEZvZ3CJENkCZuVpxJk0tVz7RPkouKqlplfrI7yKG0JwPQWxHBTXaQVGWB5fa9mqjSavOdG/tA4kr2zt1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the iterator and let procfs
open and free the seq_file. ->proc_open() only initializes the iterator
now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/kallsyms.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index aec2f06858af..2d309fcee730 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -888,10 +888,9 @@ static int kallsyms_open(struct inode *inode, struct file *file)
 	 * s_start from where we left off, so we avoid doing
 	 * using get_symbol_offset for every symbol.
 	 */
-	struct kallsym_iter *iter;
-	iter = __seq_open_private(file, &kallsyms_op, sizeof(*iter));
-	if (!iter)
-		return -ENOMEM;
+	struct seq_file *m = file->private_data;
+	struct kallsym_iter *iter = m->private;
+
 	reset_iter(iter, 0);
 
 	/*
@@ -923,10 +922,9 @@ const char *kdb_walk_kallsyms(loff_t *pos)
 #endif	/* CONFIG_KGDB_KDB */
 
 static const struct proc_ops kallsyms_proc_ops = {
+	.proc_seq_ops	= &kallsyms_op,
+	.proc_state_size = sizeof(struct kallsym_iter),
 	.proc_open	= kallsyms_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release_private,
 };
 
 static int __init kallsyms_init(void)

-- 
2.53.0


