Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A536088B1C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DbhUJFDn
Received: by kanga.kvack.org (Postfix)
	id 9F2E66B05C1; Mon,  2 Nov 2026 10:21:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3296B0617; Mon,  2 Nov 2026 10:21:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9026B0618; Mon,  2 Nov 2026 10:21:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 690F66B05C1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:21:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05DE714017F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:21:15 +0000 (UTC)
X-FDA: 85390542510.04.4DC7941
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 35C6740014
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:21:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DbhUJFDn;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632873;
	b=8DIA4+p/2TJR56Qyb8DyHZhsVzQbOXujTkwEY2/BApqGjLNLVGTaQIznQRcks73NJ+lWNN
	raiOXk5nIoLeXp4KttvYvKxRS40xNw2E42aoWsSgWC3oP/JstcHk1j+NgOMHO6W5jbXEqc
	yHhTKANAiluh0rmfRRloJqED44nuqTo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DbhUJFDn;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qv+c+5TDu4Q/teEIdzSpkmAL+eEuuwslAw9ahtaZFXA=;
	b=5ZXO/t1KH3TZZ2O3I/j47rbwr3VqG6bMwr1en/ibtLYIdqqrQjjxwiqmJe/7R0FvMD821T
	g9KlqONnCAVEkwyObbLhSYBwsE6iZ9jE+tCrajsmT/Tw22ykk/4RHuUDeX4KBiJyrc1KWa
	LlFkkb34L26Lw2Wgy8fTnQ7dtnxAEHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D6D94132F;
	Mon,  2 Nov 2026 15:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31E81F00A1A;
	Mon,  2 Nov 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632872;
	bh=Qv+c+5TDu4Q/teEIdzSpkmAL+eEuuwslAw9ahtaZFXA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DbhUJFDnO++WjegqV6sjnyS3otcl2/2sebZdDMTR095f4hFRZkMTGJyBlkuj94zIa
	 oSP3D1Ac7j4cfaoTs/YOZ/3HD4OntLtKpa0LwpNCh1+JLKi4UfYnGiwu0CoVUtic+M
	 /EOwTs/jPaQwpILuGPGbb/lTH5xfB3ImCVRAHdrO8lvkKmi+OSz4QkxvnUntYfmDLy
	 qsb4GyhuZqoOiqLcQKRlgK+Q8Z7rBL8ybky3VU6Bckc3xoq03qdnURR13NFJolGiGN
	 NMeI9G1ZGK8/Pa0iYX2UzAKoC/oKZ8aXViZ1ZRVWwt4iYelFx979KqrM1W3LPfQRZF
	 /OPD4WdSZcZVw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:15 +0100
Subject: [PATCH RFC 05/27] nfsd: factor out setting up the exports seq_file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-5-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1686; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YYADF9o+HT3otr/TqTwRIyIlVsvmHiIwO/9qKSxr7WM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG74im2vw/SLgkcF9xwvCrAujmja3vZs6iUted4PB
 lv0d6u4dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyk8jPDP8N52YHHueeITrga
 lFLZpu2/1M/v9c0uN21dk5DSny1CfowMx1f09ARf2fUkLZKFdYNHzvT2UqEvnn+41f65szhZbrL
 iBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 4jks1t636bztjjrst8yxtujatkbn7apn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 35C6740014
X-Rspam-User: 
X-HE-Tag: 1793632873-65577
X-HE-Meta: U2FsdGVkX18hQjUz+4onV7bQE9uPGoL+I9r45nb9xPcYyxBBCq7Man8TQ51blBoeblkMZZvb3AWQsv40xT4ma79DVd8hrS9T9lbDx/BMjpnD58NHPdi3PzKqprG+yQCzm+uunra3Aw0RHYFC3PvsrJ8U6w5SRMk3HhNE4z+e0E3X/jBO0etcMT4w3OollefKHD3wtFzrvzGssXsCYzF0zZsWwZbhuR3fcrFs6P9/LOv8PmRQnsmiS4upqCsrYJk7D2gPSTxo5hZK9lgRWvaWJmKcDTNsi9svTPUeSqLhqWuYUNINVcg1yG2A07qLNL4qoHVkp36Z5gw1+LVmCnBerrhzHV1OIZ3Ph0wFh2AJfFaDlrbn2UEzR+ygXw/1vwchulMdQFynKKio+erExHs5EGg4CcgNXr4GWPFL9Ng2dEguLASInj8IxpJ357dilTds5JRs8NaMqd5IMsKVTc2gJRcYCamS5md82zoiLhQB/7E0SO4p/3DFXjbgOs2Df7hPPQJIBhze4p7it1jrV9aOFeR9JVihfGVf8NKx8Qj8oELcCIVlPGH8Ophdx6yyGvXMzzJPzevA19nAc8kxQYcBseeCTQql+Tg4WPXTiy3Xf4Svt6LGWJFer6d7h8dTg463s0mfewDgr6a+RN9aSfU+fxTgpKUdOf3zdF+sdTj7TcKYJyxkCEay1tpZxVRc+phDauYtjuFZsXaZuGE2FBSCFDisk/50np7cZjakaASYFwNZDTioglLRiPjfnm56NBfLQsJA52XrbuLDvjuBD0fRbFJuk8+NC/MiwMGJxn3+OULULEC0fZCthkUCSLMgrH9HNgBAc1ZFZv+8sBfKQOqR5s0fLkveD3DFEkQu7OcXgS5D7RyqduWZ/Tc5XnVb5ib9iMI7ai+Ay6VOvPZLN7XCRtLVrGs5UTRzujwVDZcIu1LyBpbwu3gu2co7Z6z3JKWPFMjY+GmQtQPm1t/Ssv7
 LMiRE5a8
 Kun23TkIWAQKt6E4Pu0hAK7qz7RH8BWJSHPT0Lx33T7P2lvFFJl7CxQr3zIoRgbYlwbKHnBrbFqpUm2NqLwknHW9WEfvoJQDdV0TxROLYTZNj9JN56Z23Z2JToeL8TzRuS0+97VpwrjAVViiq/KHR3jbIBLRVj/BamYW9fip9PAD7XTLHVtMYB1vb8npmxW14PGEFUjr2a11V9auXiuxJgWF+6PybNwaxcjSr/GEM4XQd9CMLJpm6w9+Xp38NrB0dKTdewLo/t+vbtgsiaa05hpZ1FP6/2sytEpxMBT6QUMWmIyU7zd/3V/bVFyHgr3Lp+v2LHdpGQNk5BYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move setting up ->private and taking the reference to the network
namespace into exports_net_init() and dropping it into
exports_net_put(). The procfs file needs them without the seq_open()
and seq_release() around them.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nfsd/nfsctl.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index f32311f2d7cf..f8ce3c0fb077 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -143,28 +143,36 @@ static const struct file_operations transaction_ops = {
 	.llseek		= default_llseek,
 };
 
+static void exports_net_init(struct net *net, struct seq_file *seq)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	seq->private = nn->svc_export_cache;
+	get_net(net);
+}
+
+static void exports_net_put(struct seq_file *seq)
+{
+	struct cache_detail *cd = seq->private;
+
+	put_net(cd->net);
+}
+
 static int exports_net_open(struct net *net, struct file *file)
 {
 	int err;
-	struct seq_file *seq;
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	err = seq_open(file, &nfs_exports_op);
 	if (err)
 		return err;
 
-	seq = file->private_data;
-	seq->private = nn->svc_export_cache;
-	get_net(net);
+	exports_net_init(net, file->private_data);
 	return 0;
 }
 
 static int exports_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq = file->private_data;
-	struct cache_detail *cd = seq->private;
-
-	put_net(cd->net);
+	exports_net_put(file->private_data);
 	return seq_release(inode, file);
 }
 

-- 
2.53.0


