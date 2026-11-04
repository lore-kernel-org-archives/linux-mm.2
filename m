Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A9F60E8716
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gs5GVn7P
Received: by kanga.kvack.org (Postfix)
	id BB15F6B05EB; Wed,  4 Nov 2026 14:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61B96B05EC; Wed,  4 Nov 2026 14:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D8F6B05ED; Wed,  4 Nov 2026 14:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3A96B05EB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:58:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91598140841
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:58:25 +0000 (UTC)
X-FDA: 85398498570.19.AD1A6FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5F98180004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:58:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gs5GVn7P;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwjxO3TYvy6WGJQYdN5saH6B1iVdIocyydf/9B8LfXQ=;
	b=0oltxbqC1IY3OZJSHt3S6dzVhh8RIJhtQRyjWMQOHZ5IO23MC6PHvdEy/h4N6wigQCmycZ
	TxfvCaEdvo9YUwkuKVGwuG2zXgVLzOyB11bfkrH4zWAEdCBzQmWTXrCd9E/uvMqZyQx7js
	39v0BAvfqdHMj9ospIkfAhOCmlQSB40=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822303;
	b=xi1WNtrLJB/6SoCbpGdmRCqUW4EaOazxifSobLJ3P5r04gZKMUVLrFZV3MQfE1RCX81PvC
	AvUX3cedQtzbxPjwH6Jpz+N+JRV2fw22S3H4dgsOHZhMDXZBa9us9+8cEGvyaCCkmSqeOC
	rRckS5m3Sag9pN3TvUF2JBICVjLOcHs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gs5GVn7P;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CCC341E4F;
	Wed,  4 Nov 2026 19:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443461F0093A;
	Wed,  4 Nov 2026 19:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822303;
	bh=vwjxO3TYvy6WGJQYdN5saH6B1iVdIocyydf/9B8LfXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gs5GVn7PVZyaHxQYP1oX1TlJKCs3atmjJ7YDkZGohYKM8gAGNVV9VT9s37IvLT63p
	 L4L5EC1cjQvvtlvaNLN0gxqkT0/JHX+G8Jskr1+i5iT/1BEoXTgOvTBU2JoiVX9QJn
	 SVcwPycBujDMI11yUPUBwIZob9xvtdHom3bNPfdTI6rcdnhnR9XEYbVnGufjUjHyY5
	 XS9Zten/fLmAjd1NEGRd3O5Jj7NFk3hoVCpRY/0FlbIUHIKxjpKo/CyBBcBbqFFOah
	 Yl3b+onZRchWRKJM5w0VJoHNNmoc2XKJUSt61/Af1LESg+Z9BzGmnqiHsRNVJ2UfrB
	 Y73jnPC+BIspQ==
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
Subject: [PATCH RESEND v2 02/13] l2tp: let procfs own the seq_file of /proc/net/pppol2tp
Date: Wed,  4 Nov 2026 20:58:09 +0100
Message-ID: <20261104-work-procfs-net-v2-2-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1918; i=brauner@kernel.org; h=from:subject:message-id; bh=/g5R4n0Ms+FYrKqMM/T6cxyrF8YI/t11/rZZuOTaMss=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97lPdVvdYzebqhhVnXpw8xDvHsuzZ4RnqoW8ipiutf T4/NK+VsaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiFR8Z/rtd/L6gwWtGUN41 FW63f2knOZOaTxXGXHuqJqJe7TlP+xMjw4k/LBOnuz10aXA54HTj1Qv+RZ4dDHz6dapLw8s5Ofu 5GAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mjrhnxhwaysd7ptuagitjc834reh3xen
X-Rspamd-Queue-Id: C5F98180004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793822303-650464
X-HE-Meta: U2FsdGVkX1+BYVOsWvWhNNVBBYhErZdTANCjJzhAtCNbpcDWqtaRzHuP2hPUMtpxY+1XAvOgAh2G6N4LuirK3cwcFt9U72hDsLO0fnGVPP9dDAzY8ivBQTnGsS0mkFsUFqZH8Mz8YkkEWmY7xn53kWA+L33LowBfpzE9N3lFomaU1FPLUAnzQdMSOvH0AR6Aa197Cj5yAUa9jhprv3B759HujrYvR91NJRe/Y2Zzgt8B2y21e885AoUbDbUEcwL8dH2fiDU3sBiDfF2cvYZYiEabNtZhl4CTo5OIztyBm3fjK/J8E0RYru1XaigMl/CeECuCT3JnOtMfBsXtL6iwNhAt2wxXGtS1eAxOoxsaTLNHvL9b9tIBRJjuc/XoymwZuhtELJhwuMLHXNyWMWoQj8p1sWGIyznWE7AFYXfuiSQnsW2pouBXRQNWzDpVvGYKPQrrVBeqHEC6kp4f9dpkM/L2WAyVTXDMfVwCXxppsBdG3pR4r4XJfrhglElx06iIozQiBpqMxh/u7e0/evEus2+VZpdst1YwkpIgabBW6CbcKkQ40Bg1bKo4UuUEmMchGY4vhLVm30CtIetZbseYEMdr2EmTBtHBgCRZy+F+8SradldeKfen87NpRrdXVA8SmpqNfGNe5Gn6/cPXMkXo2xuFYDNKVwdCzs9QR0T4hfKDroRXjVi735YpXdrtQjynzltrzMn07AcUqRNh2OhNaksIZnlC6nE4WQMEHaxgnT+yGM9yDXCQBYs6QMf4G0/l24Dz/cQIagSUJjAVyXK/fC00vygiul1AxrRvk+1noRTT5H1pZmWlZGuIK+zbiBLKuKCIsrBJbOS5HHGKN+wH4waXzIMNgTTs870euvgb9k+vShJdWkPZfXcWuX5DlxOwC++bPP5Nx/d5vKit/ND33vLSB18qZaYKd9leYFjIdCwILtq+/5Q6efaUqPa8k4Mr5o68sAZ7TJyUzJcwvzu
 J8S2egeD
 3cwUSmjxLP+YfTYEOyNEP5oGZrx6BPZlTlRLqWyzllN4HhS40TMYt9npeNBCaqmqtn5Nn62EuK2Ka/iMqDgadtHFNd7Mh61Z2yK8OXhGGE1+VOUHl6Abjte4guIZCLV1+qpv+vu5Nu68fDql+PI3rVrH3G+SzQAF4CScs6hVlZ8KMp3XYohBtzaF0vHpqYPXwIozs8prOUFJ3qe6YcWtwwRMYAgG7mH+oMfGNBHQGC3XX0Aa4TX3C1zikhAwn/MV1JILEL0hfDHvD482S3MYeM2aQB38190AqJpH8LhVk+CEC0tDvLvWb1w3QkRcR1qCpewe8y3slrTTxHLjUJBk0j3Elc6Gma8pyUcGTlSX4JTmU/mu8/AyjzlfM2qtzxrvn4Z1/He2GeExOcGCkdGyZZ0Kflo0uzndjwvQKbJQXOluRvU16nSlcPqw1WTK82L+a5Hlt3bPIqg26vISWsBuY9PR5bh6pd/05zqjtfg93qkg+xZ8ez9mC8PLYL7XYViU/bXjF
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


