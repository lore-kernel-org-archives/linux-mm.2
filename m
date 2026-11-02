Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B55C6070C96
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jam/DikG
Received: by kanga.kvack.org (Postfix)
	id 64BF96B0603; Mon,  2 Nov 2026 10:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6239F6B060C; Mon,  2 Nov 2026 10:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A136B060F; Mon,  2 Nov 2026 10:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 330E86B0603
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:22:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C777116016E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:22:35 +0000 (UTC)
X-FDA: 85390545870.02.E299AE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 03EAD100005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:22:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jam/DikG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzw2p1lwQVTXGjOVK+O2fRllw6EWFGiyVpP4wwnyOh0=;
	b=I3Iiv4Ix9+0hHSYYTNHD7rRK+NuDk729M4qLySX5Hs53K3Fdt8jeIfPjcaqz0dD2WOR6pB
	4T0fByWMWbT+/dsoESCzCYjqcIvO3lgkNA5T79+3/Ai/zDP+SFTJy33YIRj4lAk3jcTZU5
	X77AHF8L6JRXA5Ns+P0Vc+EHPaGyQyY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jam/DikG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632954;
	b=sfguNx3FLyD1X1NmXwzVTIsvnx04fSAN5iTebVWam/mTTXV/zjwAyezar70GQmQp28NCey
	7yK3Rjau8RL4+DPSNXyW2uXV2neL/UOyzA3TIQUDjOSdtoaglwerCeadR9XveUwIQ22ZR0
	2f5pk4UV8kJVrOdcDWcGIDfG0J4P/c8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50CAB40839;
	Mon,  2 Nov 2026 15:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0491F00A17;
	Mon,  2 Nov 2026 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632953;
	bh=lzw2p1lwQVTXGjOVK+O2fRllw6EWFGiyVpP4wwnyOh0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jam/DikGbP3IcdUEgRo2CFdrSnYZ/3MSMU4LaHUHhtBAwB6d0wN4GG1MyQdeaC9Ok
	 wdJM+b/3RRtjlCv8z3tItr1QxtSmH9BkYdSP+SP67oPniRC+yl3OGovJKbnl6vggYQ
	 Xw6S0FI/uqQMcc4B28EcQ0DDMaWkGXvvD/9rG4J+o8qpnbTPjubCx61OEoREYP+wT+
	 n2SYcDkpCjIpsbDnXuLn3gvGvJMSkTaaQcGsDZNp5Sixc2gl8PYMoWuRLivBfr0Eti
	 JYdHka5rVsIFLmn3fwhKKgzdpuCwWerAtbnpQ53n/tpOZi1eZbO6XiCI8qo1rd8OmY
	 S9C/ymTqVEc8Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:18 +0100
Subject: [PATCH RFC 08/27] smb: client: let procfs own the seq_file of the
 smbdirect files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-8-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1034; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RIZYcDqYt7NhFvt2L4C6pTMn3DylkXBLCyRwuGHjm7I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6U8n4ug8YGx1uVNoYGj8zfPCt5xX+/1GRB/J/oU
 N4J1w72dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk8ylGhs/Tfi77dN1/hsfq
 9zYVab+vKc/ddURfvDWri+u34qLfrzQY/tm3hDFcuBC2pbSmPpAxdem3TZc/mgiqPk5x3Kp2npv
 flwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03EAD100005
X-Stat-Signature: 685cmcjkxoqoa4a5cjdcefnwwkjh7ioa
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632953-861467
X-HE-Meta: U2FsdGVkX1/+FvZZhs8Ei+m7v65y36frdUkgi8+EomgBks4EqqnHRSpZsOKJcLkowZVw7z35GPLG5ubsbwKrXP+4T7KJg1brM/9/VaWfey38Nf2C13sOl5K5Zz7FbYF4FrYG66sGLpG2Xt4poj9jrpoDeV+CuzyjpJBU2oar4YasBmcEVXZrIqvsT2UuLn/xEagDGi/on/Oq5e9dVaEPAvjIKxmYkZG/fGUthFQYbL5lhANhPZqZ00LLUlQ85nkeMWtfelMVZ16zlfrHalX2pKS4NJP5eItDAm/xh9z35j5PbjJJFL7V4hNc57MhC9uXyEKk7XDnG6cNxUWUq8pin1ep7QzPi4RQFVJPYLmTB9AWB73SmVr/nOHzjUd2kkFRtuV6Im5jCXYCGc9C6IDhfrtDKjYk6JnRPEnBUvdWKXs5/AxAbFgrDCCsTtDp4jRlO4PBQVSWYLYHl3yDB2zniBk+9l0YFG1ylcMbBzAKV8WpmkZ/u+v/KaXqxD3oYHa14nHR1+O6+JHAJtntzV9pkNyImRIjltRpw4Nr/y++YrBmtTRrUCn/zqwh9du7Av81i+1Dg/Z6PSniK65g/p34nYUPZKkML0osaUA9Y6ij4/Ho/atn7xP6zzlTw7fpr03Qdf6KAgez2TEwYjC8IFdGc3aWDaBSyjtbWp98DKGB7ru2nOBgGuu83LpqnmeZIQwwnk/WpEaJfta35u1ec1RgmYWA9Kwfsg7FyXY/VYMsyHWmKY2HR4xReXObaC0mp5+TbE+JnDO/+cjQ70eFCp8CJdZJlF6scUbb9sHlbVxrpRc+4cIaxoIlC3ilUPWLQOOWBmFAz5cK6+gFt7RAYiKbWh+kB8mXLhBf1gPgCE+haJhyUmksZlVDUtoiRryDtVV4DFpM08l3pqHt46beqEl1wiZz5ebaV6XGf7cv78oI/uTyj4xK8LnIGnyDtzVzVoQ1dqsRoWI8QFouhTz6S9m
 JsvGkzdL
 WC06PQlbLpE9Q8KPz6dBqc+31hkrC7KE1YM/wHRXKU4OAbqtUchBPDha7OOHH2IyKVR9E/Frr9DQv/sO1zlkMkIY/yjHh6vISc6/gZjLO57No/WLh5F11obVW5ZruP++wv8DaFz1TYMjxitWg0Jd/coWVS97sVFXhz/oOkNOhcHeoKdCXeo4OJDsOwD0AYPRm3bs3b46LBczcGG8VNI1giY6ht7yUwYz8MZGH9jaLklybBstzDK4V0tZRaAoUMzGG/BzCmituUIrpf8+FPxV/Ryusmb25R6P5PiiWJMdkMrk7hB6/npJ3h2qnAoVpxlmJWj+3hhYb3seu3cI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function in PROC_FILE_DEFINE() and let procfs open and
free the seq_file. That makes the open functions unnecessary.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/smb/client/cifs_debug.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index dfcd2cdbb2a8..664072ab3342 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -873,16 +873,9 @@ static int name##_proc_show(struct seq_file *m, void *v) \
 	seq_printf(m, "%d\n", name); \
 	return 0; \
 } \
-static int name##_open(struct inode *inode, struct file *file) \
-{ \
-	return single_open(file, name##_proc_show, NULL); \
-} \
 \
 static const struct proc_ops cifs_##name##_proc_fops = { \
-	.proc_open	= name##_open, \
-	.proc_read	= seq_read, \
-	.proc_lseek	= seq_lseek, \
-	.proc_release	= single_release, \
+	.proc_show	= name##_proc_show, \
 	.proc_write	= name##_write, \
 }
 

-- 
2.53.0


