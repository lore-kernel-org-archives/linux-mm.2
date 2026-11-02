Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549666072234
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UbE/GY/P
Received: by kanga.kvack.org (Postfix)
	id 770176B062E; Mon,  2 Nov 2026 10:31:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746096B062F; Mon,  2 Nov 2026 10:31:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65BEA6B0630; Mon,  2 Nov 2026 10:31:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46B4D6B062E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:31:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8228A597A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:28 +0000 (UTC)
X-FDA: 85390568256.05.B7FF466
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13476C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:31:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UbE/GY/P";
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633487;
	b=u3oLtn/i5hchnYAWuZokqFNWPJPyORvZxP4LuatWdVBZamr0T4hfYapNYcKrfwhaQty9k/
	WwR732rfGfFwo0D/fB+lZYJlu+2viYSSkvZlMgwNqRAkaBMWoCSDSS6GeiuyinEWL5GF7N
	J2Evy685M6/B4OZFWJpj0178+ihh0Bc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UbE/GY/P";
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwjxO3TYvy6WGJQYdN5saH6B1iVdIocyydf/9B8LfXQ=;
	b=o832JtSZHqnuRLS7B+HzFiPQxXbTbYZ8HlUEOE2jyvv6T/TaDGbVxUmLOqTfLfUKtQRn3x
	b6GAXPz67hK3CqO2/2g34PoI5k5L0oa2rJhZT3IQgxR3aAkypnzOmOhSC9l4BzGKIrHmAp
	qxtSg56gVAmqiyB0f0ND2lUQi2QgU1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F68C41B56;
	Mon,  2 Nov 2026 15:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ABC1F00A17;
	Mon,  2 Nov 2026 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633486;
	bh=vwjxO3TYvy6WGJQYdN5saH6B1iVdIocyydf/9B8LfXQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UbE/GY/PYzhi2Fi7si7/s3It7tNz4DO7UQGlprH7NLzpJSufJcUt6S7sLl4ETioTn
	 lSrxhrhtFMtQb6rZpoE6MoG5MG9eu/oVVRZmwnTVdQmH/Uc8YanZxUbAPJ3I9S4O7q
	 z0m2i9CWxWD03GNLvtDJCEzS1ywzTD672wOGOyzXiiTxjSmYm4JDOfioeSmLQa60Ds
	 a3wnZ+yTE9KkhVTKNfGA/bKsony/u5hTU2nvptIrn6VLRSoxE92Hyqh1vP22R1USo3
	 fnoX0h5mvFahCSUZxRECbsbRhCqA2NVJbxVIwTQPsraXYkSxXkM4wzwb15ZC+dp27b
	 y5/kCl5AgK1UA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:16 +0100
Subject: [PATCH RFC 02/11] l2tp: let procfs own the seq_file of
 /proc/net/pppol2tp
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-2-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
In-Reply-To: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1918; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/g5R4n0Ms+FYrKqMM/T6cxyrF8YI/t11/rZZuOTaMss=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG78rF41UVcn6s+kRfI/lJTvq/TI+ez8kiHKd3vOn
 QnBrmtYO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYi9oyRYf/NOSUiv50MPlxP
 STf7vX/f6RkVu0Vzktw3n+teH3BIfwcjQ6e+2UWHa43H2pdHS7s1ZT76oqVzw0iU/67rXo/gM16
 nuAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 13476C0004
X-Stat-Signature: ndrabjo6wfeop8re6no9t47gn45izg7h
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633486-47436
X-HE-Meta: U2FsdGVkX1/uD2ssEK9J+tyhTb2pJgx32jRRVwm7ckxvNQ59Bx4k/ijF/yR42iHIWF/RhlRX9GnWvpLA5oJOf+jtNu6/ByHDIJI0Cjju0Nc3cV+II4CHF70maJWiVexwhcMG3rKsjQ+7ByNCDDzLjF/TKc8XWSFO3kmIUFxm7QsiShJ7eiLJ1jjtCgvn7jVgqPGzyEdFgDS9ACdnsPx9pvm6FoY7zS0kZ1nHQRhDPbEdfLfzpokMQU7wJ85VbGnTE3c3tTAMaH7zT+xLtZ1Nbs3BeRB1tF8/GmOLm9/uwJSaiisKfTUL9JV3744Qr1NZlrSeqolLfIP4Iy867HIK9pttf2vqSg+ohjSm60aBCbpvPukW9LrlHEX0DTlDnTVHWo29F5av0o9jERA/SwAfD8XqCJcU5cPCWboA291Boc57rODJHTetIE4n+hEwrLipOCc9R2zL8U9F2T8k6sW9KiynwxC021+rVxbSakVodRY4eR7gshsI8DrBcTt661YKv5n48zSjAANoyeed5ydiSaFyYXXMlLpKb0C6kkP7yLqmI9ePFXUAgOseHEwYa3tlGhIOvJINne8xUMYHdzzuhnmb4Xco9erfmbs92BicPT3ij6sTlttJE7pVgOh+8wHEAtFckqiSEO+H7xL4WEkaq+wbm5J9wz+bmKZVqBDRCHUFuxdhOJsVy0k3P0GGLjdcmbocVhYPmvoK5UlPw1B/p/RsSQqc7m5RU7XCiP+mPVs028Hl1CheCzBVoycbReHT3NxESfy8V/nr8eHb9dQPR7L9ldtFBjZNKzELjD8RcooFPMT621ALOb6nzJ6PeEcpBFfzw6L1Vmi+tzPaCkoT15nmIs5sn1rG7jWuDOK1QjZh6m0cBpGozUDvb4bi5ye8ZpLc/Io5PfKD5REc40eCEfDi+RlCodhGylEGChvbEwhM2SNwrfUo04NJPTGX3UWyjbMSN2EANn3nZDC2jzv
 +wbwZxqT
 r9vg3DaBikNSxs1UAxAxQuenZpWCfDUFQklOl9jnObjWiYwVE2J3sxco0WnlPpFDknLXCCY0FA0SJonHJ9Ph+9VJLbFRBqDnj2BTPMVMjYUyDs0VfMYjxuFj27QKmGlExtC1fH/7AYuJRH5ZEhZ8fOOsxyJqu4S96LDhVeJucTM6IN7gpZFD0Tg7Uj78oMLpbRWjQjTUlyZVomA9+CHujcJvQBXfIZ+KFL8aypMc5DlYIvjQrKUXmjfvZZoekAl+Bpt8Ijnq1AWjc/uOUuPInhCpa/oRrUaAIZvmjCGaWtdb11AJvcuok3HggEO9kbdIB97mGpuPwbWXJ4J/OEoIswrnPLRTIn87GJ0Sq1yYBrkrpdoCj6PpWEglmjdtwHV0rMw1g0oj4arbKuMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the iterator state and let
procfs open and free the seq_file. ->proc_open() only takes the
reference to the network namespace now and ->proc_release() drops that
and the references the iterator holds. Reading the file then no longer
holds up its removal.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/l2tp/l2tp_ppp.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 4f311d473a64..499e37eb788a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1596,21 +1596,17 @@ static const struct seq_operations pppol2tp_seq_ops = {
 	.show		= pppol2tp_seq_show,
 };
 
+/* procfs opened the seq_file and allocated @pd */
 static int pppol2tp_proc_open(struct inode *inode, struct file *file)
 {
-	struct net *net = pde_data(inode);
-	struct pppol2tp_seq_data *pd;
+	struct seq_file *seq = file->private_data;
+	struct pppol2tp_seq_data *pd __maybe_unused = seq->private;
+	struct net *net;
 
-	net = maybe_get_net(net);
+	net = maybe_get_net(pde_data(inode));
 	if (!net)
 		return -ENXIO;
 
-	pd = __seq_open_private(file, &pppol2tp_seq_ops, sizeof(*pd));
-	if (!pd) {
-		put_net(net);
-		return -ENOMEM;
-	}
-
 #ifdef CONFIG_NET_NS
 	pd->p.net = net;
 	netns_tracker_alloc(net, &pd->p.ns_tracker, GFP_KERNEL);
@@ -1633,13 +1629,13 @@ static int pppol2tp_proc_release(struct inode *inode, struct file *file)
 #else
 	put_net(&init_net);
 #endif
-	return seq_release_private(inode, file);
+	return 0;
 }
 
 static const struct proc_ops pppol2tp_proc_ops = {
+	.proc_seq_ops	= &pppol2tp_seq_ops,
+	.proc_state_size = sizeof(struct pppol2tp_seq_data),
 	.proc_open	= pppol2tp_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= pppol2tp_proc_release,
 };
 

-- 
2.53.0


