Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CDE6082600
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C84U6Gw3
Received: by kanga.kvack.org (Postfix)
	id 5B37A6B0622; Mon,  2 Nov 2026 10:24:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B096B0623; Mon,  2 Nov 2026 10:24:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1F06B0624; Mon,  2 Nov 2026 10:24:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B10D6B0622
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:24:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 957EA4014A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:55 +0000 (UTC)
X-FDA: 85390551750.18.B50853C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D616314000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C84U6Gw3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6w6X6v78H1W1MVXKcJJM4gA/sIdjDlKonl9LFE5zQjY=;
	b=owU6sFrfj7GeQiccer3qF/jAmg7hBKVRAOjhnjSJa/wZ2WXeg+9Zxrjow8564iQtbvIGid
	z3J97THKZRBcsetZX+Qi/OjMT7B+6aGUjJIfIy50zqPZQMoB5y3Y62ad6foknHVFUMQsSm
	SZTqMo9SsQMBuO8QyWu33I7lfLKzbI8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C84U6Gw3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633093;
	b=C2vVhoCVMCOZu/I87iwD1g5/tb1HPKe/OlBvzHxECfxk+BeHwbnyAh0Kf8plgB2QFE3jj9
	MNnyrgvVoi5/DfE8uvdRaiHTdEb0hH2jbpRg2sdvyRLVuooTR4QQaGayCI3XfWcRyhzlZ1
	LnZgJYgALUFgGp9Uh2/1Fq0Pa0r5Bck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 757DC60A4E;
	Mon,  2 Nov 2026 15:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61831F00A21;
	Mon,  2 Nov 2026 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633093;
	bh=6w6X6v78H1W1MVXKcJJM4gA/sIdjDlKonl9LFE5zQjY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C84U6Gw3/7NEIEUX8wm5aL+w+p7nAtzL3Ye+Ut/KhKaxTRXTfZospYsPa7VSOz5cs
	 uYRf12TBs7aUroCeRblzf+4dkXCp+IFPpb3DPQ8WNMEWUjjQuGaO0igdG/1FcnT2sk
	 +Nnt45slpztD2ntlOu/8ls0Zsfr4+xCPx06oa8Issc3Es4DkDNDArFw8ZSKvEW1hh6
	 u0Ea0BzvEinh2dT3lDdRxHUYCzC8d+8dq43Yq1AogBxlWH3/qsEKacpMbyqrSCk3Vj
	 X3K/Zj3rcCm7HgLR/AXQpaSck7PV9j54FNLH1pxrv6FHNrJt7646S7muiBZu8zKYLm
	 G/IY4zAlhr6qA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:25 +0100
Subject: [PATCH RFC 15/27] profiling: mark /proc/profile permanent
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-15-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=950; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qIZMo2xD6WijzH8eCxcoPQWkqyhBdrmfr/XH6W+8iSI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7ExefxM/s4z6HMuLP3ZGefX+6xsmVr7IUfm4u2V
 Ki6Fvx831HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARt2CG/0EfvR80+J/5o3qz
 ZXre4ifTW10KtD3PvVi8oa/zDvf2QnNGhsUVyZFdtvc9vu1c+ij2Ws/3EP9Zmx8qpokHcu3cW7w
 2ghUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: D616314000B
X-Stat-Signature: npscck47ot75nq46b7sdzbw1nf9z45mt
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633093-789738
X-HE-Meta: U2FsdGVkX1/6EeJf4RKIx3tW8yOQHZYS6evfP0miq4vQF0IYHsmLN0s8vB8ukQYzgZWfNh4kY10gPt+UfY4INWfUkybktd9GgUVjoVqfnkqtdnOK7L3tAA1rv1UkYkKDDHE3Us968I/thL1bnbjs7amnZKq6tA+E4UlLZBN9RsY32q+vkwS3v5tzg3HzMMcFQw2XIR4UsRWNn5Tvk/07xlxkQhvBnKbbqFCfxBO4UKWYh5z0y0mNxuTAMVY0+DxjIb6za83hncm8/gQZdo+d/4xBv9I77MI6Y36064QxXe1edvDdLEGkCk3ClCzqOIvajwSDkHXPKDteP1jmTQ9gu+1dsgzwCbE5FglU+FibGIS2tTFH4XZ2q15Ylw3B8WbzoQ47zm1UU/a9kOgC6+faaGsuTdb+ECCJTNCiHanVD8KJgVWlUN3gOWvva62RxsMdYll0+QleLLoo3UW6HWcwxNfHo2Gzs/ODdqGbKJUlu2Ag4f9hM6QIoIh4YEYgCK1UiR2Z9kNHcTz2bx2VFZbmKmlfXQjqa35hsa2z5oZXzvNQXnXsVuEdjE5ZDwdWDAV0E0QEIFvpbSKtufop+EltC3Y1lXVjc2/gF8aUg/kaAVdYoYrkhIM/bNiJ8cFyHMIeEQUlrLEWY2QjHFej1TBF48L49hgBjVO/8af46OcTmClAc66ccxTVCTFvhxs3Y+edBwR19qGZ7ImHuz5SbpNzUqoXdrOPRhs3jOHt0NqCI6vxBw+sH4r9BiiFabtKP3JvMdTeeYMW+36h8OdtiH+E4GUm2STqfs8oPiZTTRfbO93lDMi7+1tGUyyA1IZJZWFcJARY73Ti1jQyyJcRHDVS4hmH8Qf3Rf1d4yj5UJiwCSgOsZzsyv9ZnLNkLxt9rQLzHZUyw8CaI52IeGCejd0VaH8H318vkwvm2Icia2AlIMIrOF04gMt6r/O6pgqSrRaFWSCcgFVhO+CjiTXhOpg
 SQa053E+
 1GoB+ZScAEY9u0/TlwMzA9rBmxZxl1IAYGvMcv/MA9FFtgXIWkPcJBEfnm1RuwBEgZJXJtYaZ/IzwLOewLQtnk5YUzaGUcXEA2tCHewMQbLDl/OYStWNEirV8M7CdyHhvC7k+BUepMjXXLFR0+f5jHrQmZW1pSdOdW/rQTCVPgPwrKkODDGadaysQXxQuE1vIN1UJf8ycTeArRK3+44BSSNqUXaOSgo7Tdveu6LXTRdCEK9Ns0uweK1tfZoImTbCTTfwUIvCpjW2APiajR472NFyObg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

/proc/profile is created when profiling is turned on and never removed.
Say so with PROC_ENTRY_PERMANENT, procfs then calls into it without
pinning it. It keeps reading straight into userspace through
->proc_read() since readprofile reads the whole file in one go and a
copy of all of it through a procfs buffer doesn't buy anything for an
entry that can't go away.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/profile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/profile.c b/kernel/profile.c
index 6e4b34f35e3b..6f2441dd4a00 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -206,6 +206,7 @@ static ssize_t write_profile(struct file *file, char *buf, size_t count,
 }
 
 static const struct proc_ops profile_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_read	= read_profile,
 	.proc_write_buf	= write_profile,
 	.proc_lseek	= default_llseek,

-- 
2.53.0


