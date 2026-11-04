Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4546070E57
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXAwkLYs
Received: by kanga.kvack.org (Postfix)
	id 8F17E6B05C7; Wed,  4 Nov 2026 14:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0A56B05DC; Wed,  4 Nov 2026 14:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769846B05E0; Wed,  4 Nov 2026 14:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5239C6B05C7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:36:53 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9A2F8085A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:36:52 +0000 (UTC)
X-FDA: 85398444264.26.D726804
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 401F1C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:36:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXAwkLYs;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEPnWAoxjJOkMqmLZaf/U9t0SZ8y5Jr9Z0MZeAu0+Kc=;
	b=W5MjwJMFs8L5u8lhoSONFQHIbBxWjV0dDT9/IPYvHdY97Kd/jcX97Yg9V5KOQs945YQHag
	D1XO/b0G2f2Dq/cTlDqUfsybwA0TAYtQvoSFssArusJuIKjfPbfqAoPzzvh5YslibGHrMk
	06BHOZ5mMQXmrTlv46TrzM9xEky2NvM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821011;
	b=7IEbMjuCZU810TWJ0iuXrqKHImk19bUW0yaC3m/wHdReJbLK2GMX85RgxLM8Bym+zGwPkB
	ijXy/1BePRgf6sUl+Z3BUxTal6RVpqYyNjPl726oSP8aR4zIb3bneNCytt+ZyCYwAsb8tG
	mnQsRv3OBNcGIjMLL0bw8h7yxNsRF90=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXAwkLYs;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEDA060DA5;
	Wed,  4 Nov 2026 19:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B64E1F000C1;
	Wed,  4 Nov 2026 19:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821010;
	bh=wEPnWAoxjJOkMqmLZaf/U9t0SZ8y5Jr9Z0MZeAu0+Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXAwkLYs5CMjRrIik+svwhbWUt5bDEP/6QOWaHqgQGnGt34I1o6T853RqAuV7Hurk
	 nJguWnT7WS2BCr/MHOaCcfo/y2YF8uonfqwKBD1vvV5BxItKSThPtia6lCKm8tXqBj
	 HyK614i5nL+pOdjZyJiH0sAw1f5liFCfXPhf+aJITyPVYu1xz3l6R95T55JjSVbsGG
	 gsd77y2zC/YQYCVOozDP6pBG6pwL8RsS6zHpDLqsqfvlDhE+Y1bJWPNUxKRk6rTJsi
	 AUUQYXCgIz2oR7YPa2yFabJiCl27Vqc82eAQrsoGb+Ydr/D+wm+kQ1Kp63UoGu/D5M
	 SSv/nmv1lJgcw==
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
Subject: [PATCH RESEND v2 04/23] m68k/bootinfo: let procfs copy out reads of /proc/bootinfo
Date: Wed,  4 Nov 2026 20:36:36 +0100
Message-ID: <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1117; i=brauner@kernel.org; h=from:subject:message-id; bh=Lp2WfN6gRzyIoXXnYjqLNGRBgINOkMledynPew9Qa8Y=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vi4tPTP9WOBc0V6N/fIbxTfPI/lUfoLfZZ8TRene TrRPhfPdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkUBPDPzO9krgvvw5fYBV+ 9H1XqQXvdO7wtZP+r/5w1yl9W/zGBWyMDK/aPsbxCnmcPB2wcdUkBYmzJVbHot9pzTMK2f0zZ9c se04A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 401F1C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: rodjqs5pd6m9jyx35mjwyjt4161qd3ax
X-Rspam-User: 
X-HE-Tag: 1793821011-856848
X-HE-Meta: U2FsdGVkX19B4cwUfVJQyvK/Pk4O4w6ixPL+j6G6GTpN1eJIR7qzA8p+DAPnUirOFbwBYRHw+NwiJ30jCb/FxvjYbfW5ziDoS47NrCa60SgTlJzh2o58vnQdFzapIHOGNpxaBxhD739Fr7SrHjCYEXO+4mciQ9XbncmCoueO+cfl//FOJ1vBEG0Wh9tSXYa+6l0XEysdlLlw2XJlvRNSRJ6ENBxvj7c79FMaR/+U0QGMyHGfQfrpTZ4xbyxj2OI7cU64DXgwZ/H2IgKnN+8etGjqOb7UY5cSPuh2AeyAQ7frdgaZWy46NA+jMthJEBilgbnSuf9C/5GoqJ8EtrDULTIgeEPZ2cyTx60Ui9X9uwU3jvzbEYYEo9q1QTALesQfbSBx7+cEGRiEYvSquAOAAlZW7/v2WRcY5Ae/7g4xi+6YvSI0CA2MLuvFXIBZ9wP8u6jwwBuntzVPziyM9byy+05DZRkIbnZGi0D58fGYVv1V7KOJUMSUv+RpkCFB44/7dfAKocA1yrnYd7BOGT4caRDZcoYqqU1LhK6iLvjZ8O06GJurKYAqUt2VFF/a9DihAEfFfpKNVJV4nK0UKGuQS+B/jsErvtbRnSzcbnCFH+Wj+6HLGGRdlk4aRhhEM4x6zecoWR8ghAJe06gwl01tKGSzJBDX7rEih3h1qorxAlMskAjawBI48NBMHk2jHIV8X4Sq10knajiJSGd9jx9v3nBO+QQDzBLcw4LBG5FXh+zDpxm0A/QBC1+yYsyCCwTxZopoFsuAzUj3TtVlmFQkXqAApgnwvYMjbttm1wPKucYhzrCDB8Y7p6VJamHgN38bWXhtrZhf8yepx0j2Ha+i05Hd/woyFuQ7RdSV3LEjoZ4spg7/P9lEBRd6ecbAAINdDd1tY7zH2QBAE4nt1Z3/vgQ8lS/2X60lRcC1k0u08JOnpYKDk2VZKnZA6v+7j0FDWDiOfBchFBR2/htAN04
 SfCCy99j
 u0yrAiYE6tqjdHV680Yemtno2F7fU2T5BBNd+Js4lzyDZJFNR6QxXw61SOIey7vfkKYA2nK6eiYLnQMQ7fD1S/e8G+sGstXBDmz4UFIoMbUKLpwahZQnuqOdts2A01KrkZ1UxVa8aCZkZfh+DLhPs9gf2Af/0lzGzZZ2ZGD/7lwFXk/Ivout0EwQNpKFf+gXEWtbdjkQmjOjXnzAevJ2QHNvAWrbli2nXgx+R0tQUuNGktgL3laW2UPJUaS9VS5vjUkvWEUQEfUEKIsFFNWONsqM3vFIqoI8XEHBKxk70teYjDgsfPwo9sWaMxKVZA90XiUCIw9QfCZoz46imlFBBLn/MOrYdc174hOx1+dBgYEovBYwE/bwWwmMJDUp6R4gLcdghdy8d+QLNlQYYRJugyxiZ/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/m68k/kernel/bootinfo_proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/bootinfo_proc.c b/arch/m68k/kernel/bootinfo_proc.c
index 857fa2aaa748..4936cf44e86a 100644
--- a/arch/m68k/kernel/bootinfo_proc.c
+++ b/arch/m68k/kernel/bootinfo_proc.c
@@ -19,15 +19,15 @@ static char bootinfo_tmp[1536] __initdata;
 static void *bootinfo_copy;
 static size_t bootinfo_size;
 
-static ssize_t bootinfo_read(struct file *file, char __user *buf,
+static ssize_t bootinfo_read(struct file *file, char *buf,
 			  size_t count, loff_t *ppos)
 {
-	return simple_read_from_buffer(buf, count, ppos, bootinfo_copy,
+	return memory_read_from_buffer(buf, count, ppos, bootinfo_copy,
 				       bootinfo_size);
 }
 
 static const struct proc_ops bootinfo_proc_ops = {
-	.proc_read	= bootinfo_read,
+	.proc_read_buf	= bootinfo_read,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


