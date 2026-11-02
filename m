Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C16D60810E6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gMV7oMe2
Received: by kanga.kvack.org (Postfix)
	id 6E2A56B05EA; Mon,  2 Nov 2026 10:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA596B05EB; Mon,  2 Nov 2026 10:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D03A6B05ED; Mon,  2 Nov 2026 10:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3782C6B05EA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:20:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA0E3C013E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:20:11 +0000 (UTC)
X-FDA: 85390539822.12.0E57373
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E787A18000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:20:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gMV7oMe2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDybWaXH0yVqSHGh6cSao1kY+huQ+XTPXQ1Vld4D+UM=;
	b=iC3UHGVulPp6o/+2oxPxpVdpRfADlQhWISuSpoxBlKnBDua9wB0IB1Ov1rfbqOmOEJz2Yf
	Z690QyMmGmCEH/4pSnTbBDzHUnhbtYdwZa0lCgP8iVGWIL4Qja0LM+LIBPuqy4Rvp3I9Is
	BIQVqCkWHbQtj4rjsD68wY4Iaza4zns=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gMV7oMe2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632809;
	b=FoxHOUXww8uxKaD2RIWQ706DVuDRuFlC9In/NeHrEphPsg6c2qeXIIKZ7xTBPXlMrltX9m
	j/PDH7k6HWvpd8RDIXqM4pwBcN545KSnRka7CEkWGxVJ8m4YUvfTP5TE0FRFvSnfly2pHz
	k81v+eXLCdvb9kLeKBHLb1MzTSaZk+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81FDB6061F;
	Mon,  2 Nov 2026 15:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976621F00A1D;
	Mon,  2 Nov 2026 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632809;
	bh=gDybWaXH0yVqSHGh6cSao1kY+huQ+XTPXQ1Vld4D+UM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gMV7oMe2qdf0+aS9olfnOBAqn/OBe6DasxdwT9LImBIs7Pj7CDa/oA2a6B/8kY9pd
	 QfSD+01vRhmQIdCiXlwTDyOpKHr/+vYVKI1GFm8wQR5ZwmzCN80Jrz/IWpqVDIWfYl
	 3Bzlzk4aLDYzHqqx14bF+dEvwX8XoOta/BsfktGPBtManOh4//zemOTXkilWggqbhn
	 W/RtVoTwiEMKAtL6JeSwBY8eTWp9GpOtjwbXtxAZExlQVzQlk62v23yj30uR9SnWUe
	 jbKIL4QwYWDm+Xox3mBmfSoPFHGyBgWuJOAs5l7OErmCDLr8xRUVWg57VzoW07Bk1H
	 D+JLNSysS0GGw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:12 +0100
Subject: [PATCH RFC 02/27] jfs: let procfs copy in writes to the loglevel
 file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-2-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1370; i=brauner@kernel.org;
 h=from:subject:message-id; bh=izEZyN2ciF2azWBwOiarD7rxdH5SrLb74RUgxhmuQ3M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7IJf+71NVUmNfmjuySXN5GYdHLr8WmWM125JvlY
 84Qs/VxRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES0PBgZHvWw/qhbNX2Pi9i5
 F4F+xcfDMxt+ZB+X21+0fPH/f32bHBkZLj5bwyh982HI2kgp1W2/Husu5Fmlc+PU8aMTrX5F3I/
 u5gEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: E787A18000A
X-Stat-Signature: axp58s4ytzu1rbnd5za9cnbryfuod6s6
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632809-395237
X-HE-Meta: U2FsdGVkX1+xp6XGVL0/tWB/uXoZJjhqfmmLj01qZHp1QPPraJLAz4efEft4wAgtmnhehdGyPpTxwiGRjrRd624YVkEMI0b1z6m96oxcCPyclUnunu2WfbUjwmsE4keZYq5bp5tDswOqLpzxP+a0Jc99mbjHNe/nrnphEyuL/SAzyxxzrz9bNyYSRJJxsywqqQTg9bLE2JWaDkdOPgS824PkqbSuz+m1esZ2jwQK7t60T9pems62zx9VwiBC0RVl54arpQXR7hb+zmdTmEpvhpagZ9hEpHTQzKOupHGXuVPovdySANLF2dIceuYiRzu39O7BLgAzSdBIdWw1gY7AFlU0vsptOmC0spUrm0LfieeCxjwNHw6ATNzGNKFcH6CIlCbxV1kfddTOtLklBt4oRMEv7vBEeLDlrNiMWxwdMKQg+8J43vvDwVMPKbtryRa1gglogYvnx+dpcAsxiD+OpAD4PW+mK7mg9TSbSFMvg53p9Zf+z11fJEs6Jyy9L2Rk3wvl8llrWDfXOMHCw2iFXMMejCtR1zSZ+t4PTif27MfE6wm+/DheKftOTfH3aAVIJRg8xPhR+eKqo5bKwXb/9npANheO3hN/bGMidbaBiwwTDoP5W0XU2Qv+ShNBQAXDLL5A+Utw8B7ZvfL1BPlS4dnkJVqIe7YLtN+CAuA8zC+cUFlSlEocPNR/JntYDTf8SzJUgO02OD+2KBiM56yKnWHFaA+qICQMPVa1f7aEijwctBLMxWCYSv1bdB+CNxxQXiWNzmulfexnm908hqv35VdT/IVj7oVmuLRhLbK8vYUL4ZgB0lnTTCs76iPR38NnKeFkCNqWCULHk/3Yi0A4G8fV19f5mpc/+ZUyZcI2RRxOLwAbfNlpHsOVQCZC1v5G8TBfhydNaw/k6qmt8+bvzKUc1PeniPaMfF7wXDal6mL89hy93c02zoLsNL9fsj0ysxpTV1uIi0DcoIleLoB
 anEuPBL3
 snwlkpkWun7O6aRNa99a3kNCn3roSLp60X87t6lM+dH4U03BfFVuFzb6CU6fBpPTWd8Vs9Qd6ZPFlJlryqrBnhXzdkWLXCuLwlsSc8/uiJQ3GRF6ChDh7gBsDmjqLorfzD8QLNYEkiiW5TnaM1mm0gv3AuADkSPnyBJqVwDmvRRO4AGseE1t0CAGRhrrPapIq5304JZe/Z9vWdkJn/rQ4s38SZwpcqu8uZ47cPmAttPRL7JzpfVA5m42HgFrOg2VA2NJvF5YupSmAg93oQ+k0TxBP2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and take the level from that copy. Writes larger than
PAGE_SIZE - 1 bytes fail with -EINVAL now and so do empty writes, which
looked at a byte that wasn't written before.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/jfs_debug.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/jfs/jfs_debug.c b/fs/jfs/jfs_debug.c
index 5eb35b0d420f..e1c0211a6a32 100644
--- a/fs/jfs/jfs_debug.c
+++ b/fs/jfs/jfs_debug.c
@@ -23,13 +23,10 @@ static int jfs_loglevel_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t jfs_loglevel_proc_write(struct file *file,
-		const char __user *buffer, size_t count, loff_t *ppos)
+static ssize_t jfs_loglevel_proc_write(struct file *file, char *buffer,
+		size_t count, loff_t *ppos)
 {
-	char c;
-
-	if (get_user(c, buffer))
-		return -EFAULT;
+	char c = buffer[0];
 
 	/* yes, I know this is an ASCIIism.  --hch */
 	if (c < '0' || c > '9')
@@ -40,7 +37,7 @@ static ssize_t jfs_loglevel_proc_write(struct file *file,
 
 static const struct proc_ops jfs_loglevel_proc_ops = {
 	.proc_show	= jfs_loglevel_proc_show,
-	.proc_write	= jfs_loglevel_proc_write,
+	.proc_write_buf	= jfs_loglevel_proc_write,
 };
 #endif
 

-- 
2.53.0


