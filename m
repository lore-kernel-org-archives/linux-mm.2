Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C666078258
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YC9ApXUw
Received: by kanga.kvack.org (Postfix)
	id 8AC1C6B05CF; Mon,  2 Nov 2026 09:53:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BD76B05D2; Mon,  2 Nov 2026 09:53:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74B606B05D3; Mon,  2 Nov 2026 09:53:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3986B05CF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:53:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6C7FC013E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:52:59 +0000 (UTC)
X-FDA: 85390471278.08.230FA93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0EF4940005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:52:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YC9ApXUw;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z15Uq40RTWsSdyyx7OaN0bxQRP62XbWMWxAG8tgRqsc=;
	b=TT6OkZIqXKzmTUh7z6k7SPsRqtVZL1rmzYEGksQpNAGxe5O+fHDuyMKS87EjOXN0DssozD
	6PKqEDyvXvVt9W7qDnFK8QfQRQAXal5YhvcPYuWYqSPg/qtaj5/W1wNnfZ3rOY2Efhv898
	y3HiosPqiFmp0xFvUV1KRifzQlbUas4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YC9ApXUw;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631178;
	b=8DzpGcA5LPNvdmCPNKJKmzNJHXeQHLIeWpsSRhaeZL3YQSTYFyRhxj7SQaW7BXTkmR5+sr
	baZrhowoiUuTVL1FCDK3I+zDFCqPR4gFgxpmGdshgf91q0MHCDASZw1d2qq//FN2pKIYzc
	jUBlH64r3MYc7P2QI0FBMdrFbYOSUYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 162C643ACE;
	Mon,  2 Nov 2026 14:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4BF1F00A17;
	Mon,  2 Nov 2026 14:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631177;
	bh=z15Uq40RTWsSdyyx7OaN0bxQRP62XbWMWxAG8tgRqsc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YC9ApXUwYHXdh7Oe3VkjE39wJ3Qg7gCObz/rTOq48xo1JAMB5WL5rAv5ZOVJS8qqZ
	 ynnExq4rKiMg+GmAmkH9n8AzdYfTlEHmZ/fOsTnE53ISdXH1WVlbQFy7hO/CdAQSYn
	 4JbQf/FIJ657tBcgXmsRiDHSQsBBt84kHCnQ3pca44VTjgoKmBvJxiGyOKjK34ikx2
	 /LNlDgNsznisNZc5MkevQj1M+4bf1MamMBIardSrDk1sWSAOiPvR03vBw4J+ZC6wk0
	 R7UEuNIvdf3X8fF/lS/cfHuoxA8HStGxldAahOLTER+k7KMNib4+Ih4XKO3zJT65eL
	 9MJrEIEx2zC9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:50 +0100
Subject: [PATCH RFC 10/16] proc: let procfs own the seq_file of /proc/stat
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-10-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
In-Reply-To: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0EF4940005
X-Stat-Signature: d1ew9a3gixmtmz197e1c8ryhtariqjnf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631177-445234
X-HE-Meta: U2FsdGVkX1/5ijBWGgumKgsCt9u6wDTCq2skU3lo/7QIIrxKDumEgqbIf14oCzl27+mnYAS5Rq4++sFFZWAoJr3lcSMt6zCZmnukhjMNVvDThBRCSuBn1lWy7B+bmfbYKhj4QtzCVk73OaikIGRRrFlE9o5gcvlALg8fz4J792QoDX0ol2pSXcohqfWiObx1A1f5GYuC+Ag6NbeyycSat/z8mxVxG1pVMRoH9YkMqENvATqamJJdj6+iE3dd3A7Min/dbWsAX/jyMgNVRqq8IgeWH44A0p3a3d+SL8QTQ0p3/X7PlXGofGRI2o0rWzm4r0C54LKXWDalxntF+09PxZQGNcpPtHrM/Q6930SEvjeEm2gp4N7shfrjsyzI73KogYtd8C8ja+DmYwroyEvQ6KEBIeC5hJazrB9j1gAZgKK/WDi0r1KfNUtHJZnVZWD+9Qj9QS4az3h7tq+/fUzt99gzO1skAE7LKcs9zechDrJ3Fs2DnDmHoRnQESwTGwQeiZJDdIWb61LBoqW7ScBbH1chvFfrTA4tCBPjcJi6kkkzzk6kX15tcjtgIAwhzpeHG3+YRz9+xRdWIeAyBzZ8NMDP3M9QJ7Jr/dQnwYLjjVt76Ms8aIPm0nLbMRr1rKdbh2PBVnbECKo4dz9VM4WSheBahmjYYKbREnbfFU3L1dsi4NLamGmeW+jexY6uF+tgynwGNs8DN4MytjIkSxwgTLUDdKwmNUpCU1PaTjeh2itYxdulBpXBJX0+vqenLh64tznt9f3mBVHheVRO+gXj9OdG86YKIFTUL5fbzpe+b7lGMg5s+Si5aCbBPZl2DQXs2R6u1lwnoCAzSZeIxDWOaXB2KgDUSA1eb5nPeIzbLVKxGZzodgdWLwyUmU7fxYLj9pF5SmtcBuevOGamhNCzl/tdtZxUcn4HopWCxMw7GhOw+vWVfg/h/VWmDlmoK9orXYqBkssS2chZv1j9bz0
 wy+6Fj6Q
 MiXtcS7+E81LdauqAlanvDUtfeGaLOvQeUuhVJgugVHQIH2dwr5BgsjXMapRRM9nWFph8++syfM9/VlC2yzQx4q70iiWfKmY739vxLLMEZ9eMHOjLsssZEPpX5psuYSR//Tc82bopViiU/EC+vNK25R3gbHYeVJs39RFCO8Wkr7Mk/z+Ky7pglIh0SQzAXT4ysOYojyuHAJvye8HctoFlt92Wz3xAlUJt+TRjoi+m5T80lsgKZTSXIs8ijH5YgnvfTtoZWeX47ogQBb7AAti1rx1bSMvqW9bBr7kiTTKym2ce1b1JStLuV5v6FlZO2TPW9cTaIZJdajLqj5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function and let procfs open and free the seq_file.
->proc_open() only preallocates the buffer now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/stat.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 79b42f2bfd00..3bfb79edc0f6 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -161,15 +161,13 @@ static int stat_open(struct inode *inode, struct file *file)
 
 	/* minimum size to display an interrupt count : 2 bytes */
 	size += 2 * irq_get_nr_irqs();
-	return single_open_size(file, show_stat, NULL, size);
+	return seq_preallocate(file->private_data, size);
 }
 
 static const struct proc_ops stat_proc_ops = {
 	.proc_flags	= PROC_ENTRY_PERMANENT,
+	.proc_show	= show_stat,
 	.proc_open	= stat_open,
-	.proc_read_iter	= seq_read_iter,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
 };
 
 static int __init proc_stat_init(void)

-- 
2.53.0


