Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35CB6070D9D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNnLcX8e
Received: by kanga.kvack.org (Postfix)
	id D2A506B05C4; Mon,  2 Nov 2026 10:02:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01886B05C5; Mon,  2 Nov 2026 10:02:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F886B05C6; Mon,  2 Nov 2026 10:02:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8926B05C4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 32321A0144
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:02:46 +0000 (UTC)
X-FDA: 85390495932.18.44ED3B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E6E882001B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:02:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNnLcX8e;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQQ1Vs9Ggdq4tGJpsZZ2KAKh5WKICEOKhSgV+25xKrE=;
	b=wxDSq8A7nw4r4oZpydpiEgDt8edu2N2jBtGIQqqZu5Ke8Dhk7AkBs2xzjWaLGzPow9pnxy
	ot91uV8Zfp+dCSZIUbQ5F861HtBxe590pK0GZcPu6bOfOnSpSIulBuv6uHb9bFGdnk+ieE
	rA7f8O7/LL/cK2kC7fch7BH39ez1//A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631764;
	b=hBqaG5bKQMtMTH9ww2aPLivSZrKWADOTJXRu8dl9AA0YN/IW48ILCaRGfTjEW3HpP7J7lo
	6GZfTKHaUFSMk5Itroa4Vn/EZInNs7MA+UHiXBF4zze+U6H89FWR49eyvhmJvP/Y5LzQoS
	vFcDj9vp4gbonnezSJ0xcolNljqFUxc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RNnLcX8e;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E276434BC;
	Mon,  2 Nov 2026 15:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822B61F00A16;
	Mon,  2 Nov 2026 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631763;
	bh=pQQ1Vs9Ggdq4tGJpsZZ2KAKh5WKICEOKhSgV+25xKrE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RNnLcX8egvEl5rPbLFMIscYDo1QnoOrpG6e02ikgGgR/Z2oamdimB42SLpFro378t
	 USbuYkcNHDjjzryLCSmr+2mmsvc3Atos4MVc28LQXLDJayaUp2uu3SYOz50KP5/BKt
	 3u8kERoVbEfv90E7PC1AQzopGHBD/M7WfJWVvb4TNCYwjGxWo6SsNG7sq/Lq8yJIja
	 zntE5mo3Bhg9BDYczlvI4bibAH3u2IIBa/7c1DzqGQ/HgRro22a3o66odi6Je5Ttco
	 L0BW9ZHBEZJkGL3uRb7ev3sdiVhk7xK/B7muXSKuAHvnwQSKK0opx2IHD1lw9HfJa5
	 LqGcvESsuLu/A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:01:30 +0100
Subject: [PATCH RFC 03/22] ARM: atags: let procfs copy out reads of
 /proc/atags
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-arch-v1-3-c9492ab08480@kernel.org>
References: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
In-Reply-To: <20261102-work-procfs-arch-v1-0-c9492ab08480@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E6E882001B
X-Stat-Signature: zizpn41zj3zkphtuo1y3stdisb38mgrw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631763-932666
X-HE-Meta: U2FsdGVkX19lbyH1rcCJkOiLnMqjNd7Opuk13Cc7aQEz7ViLc6q0GrBrPKhuQCxFixeF151rbvWpoPag9ysT2Y7KHKHfrgoEt5DXegkIGS2psScNDHMo45TBC87avPEv4wN52bvsLupetGbs3b3S7MdeEIqa+zGvFVnfNVcnSYwBPqhaNlXyoGOMZuGh+PsrGbYp1vm3u2xPGEFSMS+uC/F7iH9KWrm//b2KmfPWJjvEWRRK94i3Mz8ZwgHf9reUsObER/2OT05Po8Np7/XIV9AVPq8b5DgHC5vnU1lWW8GtSjd5OPhXMO92Qe6P/gbLotZ4P2WRYFNUCWZprZeL2hgNsIUNTDKc4HDamGICrZz37p0JW5slYLTmUHn12pTNyavBYdSn5YXp1o5I1HvqfXYvjBQ6TxY65pwT8T7XXYZC1GfB+NNqqT3TRGg5ysHZFTgNxOsIriHGYRS4WpHAyIZ5j9ATiro2VEQveR6xIMKy6ck6GvSGKyiCL5DVwXmSjuCAerbakRvS7c3Xi3JLqilfBY9PGOcOcwj13dl35XEAm5/O8oKpDjuWBn2d9Xwrf66QSqkOLQeegSHt87pBD3X7W4QpmNUJFzgEXrNbiv2DGxUHpkbAF2tOUBmplM6u+L1U5eIabekJ8JAuktTBjq7Jx3TsS+JSTK3/uHyTkvAqVCk3vOxENIo2c4dNj4gFSNh7TljWOVVnuh8GmSFA8GhMNqzXFgABmfpYKKtrLImbu8buESFcbEx676gMjrxXoJEciAJdcLAJuxN/TNp0crD160oJpolbowtbiHLayg6MeWiCZxao/+0gH2bepFyCkcQKtc5Iweyi4/weK1qWNNStMOEN8oFgD0MF5ImdRsrveHFFy/vAUc8lSxcBgUr15t0yxJFqVx7Dif1u03EfOXyYRXHf16/rRcdkJFtdRAgt5biEHhWuJtM8an49LvPxCP+XEQGCSoVwSO3xe7V
 DNvg5+n+
 Lz6rBzG5scTeYczE0iIFgh9FXLmUsN3PS7CEf9BQ3gA/GSswjrvhhHgS5UYwVxhGC6ler49xUlJ6AZcRHwBx90TqghXd6WzWYzJb6ABevFDXoOWo1sDc21ZUbTSH3LiCqjshRXS3rSD8ncxZppSaTbPh7+X6lKOij1pm9odCpUGYH9ZfdV12fx4sEBlbSAq7ggVFPwb6DCP3umFpzgJxfHqFq8Zusx2bUuCiRsSSIps15f1MBn5CLhrbVf8+EopLw6aA13h5fehhr3ZymOIjqi13fCPvI1uouiV7S
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
 arch/arm/kernel/atags_proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/atags_proc.c b/arch/arm/kernel/atags_proc.c
index 8411fbfbcb8b..ff28bf24dd30 100644
--- a/arch/arm/kernel/atags_proc.c
+++ b/arch/arm/kernel/atags_proc.c
@@ -10,15 +10,15 @@ struct buffer {
 	char data[] __counted_by(size);
 };
 
-static ssize_t atags_read(struct file *file, char __user *buf,
+static ssize_t atags_read(struct file *file, char *buf,
 			  size_t count, loff_t *ppos)
 {
 	struct buffer *b = pde_data(file_inode(file));
-	return simple_read_from_buffer(buf, count, ppos, b->data, b->size);
+	return memory_read_from_buffer(buf, count, ppos, b->data, b->size);
 }
 
 static const struct proc_ops atags_proc_ops = {
-	.proc_read	= atags_read,
+	.proc_read_buf	= atags_read,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


