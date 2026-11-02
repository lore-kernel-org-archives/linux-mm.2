Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD84A6083E03
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nYBs0GAF
Received: by kanga.kvack.org (Postfix)
	id F06E16B0600; Mon,  2 Nov 2026 10:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEBE6B0601; Mon,  2 Nov 2026 10:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5596B0602; Mon,  2 Nov 2026 10:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B46016B0600
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:26:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4905C1A016A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:26:56 +0000 (UTC)
X-FDA: 85390556832.22.39EBEB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 744AC140007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:26:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYBs0GAF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GRAUZH2kX1HsIdPeFBozE83iEr60/LUxZUEqoYcqBA=;
	b=uOU/8YLP2RaQXUiFTidV3Ip4PYurX+UIbULJV1ibY9At/1Xw9g3LQP6hPNBNqTgWJsH51r
	HHqBxWoS3e8jPbHfOSxEcOSOxrNM+2H07ksFovQaCkqva9jpJoylS6TEW0c6oUKooPmUmx
	Xp/WMByOBw2LLnJKr3k44h4IiTI4xJg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nYBs0GAF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633214;
	b=3u0sKaPxbVBxEEpOgPJVgsmHXJREvDwtSBdf5s14rX+BFWUOyLKNuNAXDLXiTUGStAlIw8
	G/+JfdgV9A4BaImCUwMBQsita8X0abb6dROOr1sK5MPSQc4KWxI8zFRRk3c8wgID50TRK8
	iZkk5aSdUY5ObWfEU8rBTnF4e2kD0Ak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C642B404E4;
	Mon,  2 Nov 2026 15:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FDA1F00A16;
	Mon,  2 Nov 2026 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633213;
	bh=5GRAUZH2kX1HsIdPeFBozE83iEr60/LUxZUEqoYcqBA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nYBs0GAF8b3S0eatIZoAhddTaBQQ/i0CrcM92EglgsZZbWpy731ExatrOh40qewLF
	 Lp8S7Rrut+eO6q6LdIfOUD8IT/maYnyF1DBExnOFJG7mwcNuHGN5jv9pNZ9AuWREId
	 lnOMTthrQoRObRBolVjhYcHCSAlAi4r+kE39L/TCDTKs5S84hkUHNI6KoriDtYwBpI
	 U0fE3C6vht9Hwk8FIpEHBtzNae5orDp4ap1DfxmedQEVe2FH237hpiNUepRwcWVPa9
	 eKW1KUqWkYD6wrjns7QIlZcwyB9vCaN2c35pIVU6Iu87SgiaL5+rLK2WDEDvulHZL8
	 tBantGPOqqkGQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:30 +0100
Subject: [PATCH RFC 20/27] module: procfs: let procfs own the seq_file of
 /proc/modules
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-20-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1665; i=brauner@kernel.org;
 h=from:subject:message-id; bh=flwsY9W3AwD1el1fvMS4MRjAzw7empBDyCTwiYsv/MA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG50+lPbWr8TO3/XJX642z+55KDeRh0pIW9bi1VZ/
 MvKft0s7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIpwUjwwyex5oMWjNmXVW1
 TDi5fH3+9vUsj5XnVPa/nJM/5XDQTDNGhsPvYp7dK/9aPKFSfO5H07Jd/XPz+O2FRZWOr7PQyLs
 rzAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 744AC140007
X-Stat-Signature: gjpbb5odg3jngnawabptzj5jziq1c45o
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633214-752311
X-HE-Meta: U2FsdGVkX19E0//6dyfaJOOa3xLDPEQCeOoB9q6dVHgs+F/RyfCGHZHM+IYF89Kar8lqvoxj3j32RKGfjb72qa4sQoMLKpr+bpZND1WaO2vhqzdso/fKUHUR0krDvMTJnyg/MIjCLwAK1MeHJP+59+15v7VCXnKPLfmTQMmDjqUjNJGUJSR/gMQo+el1bEcECGscVKMzr60uAQeEtlzrPfDE6UvXJN792MYl2ySRLzTo8tR0MbosXksZsFGz8KTlp5i5FDjgADf8QLuNebj1a11IgAZazd/LwPrcYvh+uf5hwidmVpxNANg0SB3GD0/b3w/Qrtt8ce8bWOOHKzyjdUTdzncW2gTD+jEfyVPYZo9fF4EzcIv70xblawDzD04p4VZc4VxZWQ/4IeISLwHncHt8I+OhC/FdfAFodGqI53OeRzK0MyPPqeRNEaniknDD0n7dVthP7aCz/P90O+9PyrdSeIUu51AUqmzEAwkqGA1FV/4VugYFXXP1o1nBcwUNbycMMmmZuIiQlkTyHStRr78aY035rCMwJQqtkukT/6eRtu3c7+bviTAeE7nm1ttd8vpQVW28iJhlZnqF00XyFkbWQVk1RdqHfMnImg8SmTfkK/w9uU1jNF/e3h/YaR6JXsmGTB2AJnN2mWdRHJ1RFCYc/XWCiVDmPDhakhfcYOz3LHbSOi87OvOFlVwYU/VjQc4BX4xRa0d3zxYmN0a4ARtq8JZ+El/ptrqX7feKvP3y26esWP7FNuttPooWllH/RtkcaaS2PuJugr73Wgefg1TjZzs1/XZ0H+SbbSaLjEsd2ycHIeNeet8zG9xGmus3ttOr5cc/ZJzTIqp66vgOS3tsQCLLa36gAahEsgPqunnxoanseoeQmOE8WEIkTfsGU2XKMYmzIKhRucKTkNbRp8RDWQgmYKw7hef+zzH+jV8tIsYMwMmIHbLjgxmImoZJiNdMnF7sMkvvlISRNi6
 sYg8tITA
 F4gZwQNuDKRT8kn/wb4Jgw9LpjgDmXRk59ncZSjCXNslyQuTT1Li4JPbZYQNif3Vbb36D/6refPFCPM5vIZlcojfhpKgH5x8DLv93at29UXrr2VR2ZVjj3jUuS6zb6iJmPXwV3B8yXnIqQWw8RdHVvOuvapoDa8Y4u0hf4H7kMYhDnEOfSTTjBPMgsUG8ejBPdrT37GEiTLSWh7PNo26zxdGpk4e7rliDmAsNJ9TZ+tZcu8xjlllaCh4hT0UDDFJvA9L0cDXjyyHEEEEvzSGhykwtKAqwf0KMuuemvDZGxhHrcGtQufWDJeGYTzOQSTW/qlyaK73MflDHbCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file.
->proc_open() only decides whether to hide the addresses now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/module/procfs.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/kernel/module/procfs.c b/kernel/module/procfs.c
index 90712aa9dd13..a759bd916df7 100644
--- a/kernel/module/procfs.c
+++ b/kernel/module/procfs.c
@@ -117,31 +117,24 @@ static const struct seq_operations modules_op = {
 };
 
 /*
- * This also sets the "private" pointer to non-NULL if the
- * kernel pointers should be hidden (so you can just test
+ * procfs opens the seq_file. This sets the "private" pointer to non-NULL
+ * if the kernel pointers should be hidden (so you can just test
  * "m->private" to see if you should keep the values private).
  *
  * We use the same logic as for /proc/kallsyms.
  */
 static int modules_open(struct inode *inode, struct file *file)
 {
-	int err = seq_open(file, &modules_op);
+	struct seq_file *m = file->private_data;
 
-	if (!err) {
-		struct seq_file *m = file->private_data;
-
-		m->private = kallsyms_show_value(file->f_cred) ? NULL : (void *)8ul;
-	}
-
-	return err;
+	m->private = kallsyms_show_value(file->f_cred) ? NULL : (void *)8ul;
+	return 0;
 }
 
 static const struct proc_ops modules_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
+	.proc_seq_ops	= &modules_op,
 	.proc_open	= modules_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
 };
 
 static int __init proc_modules_init(void)

-- 
2.53.0


