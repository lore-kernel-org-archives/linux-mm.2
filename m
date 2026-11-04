Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3045606BA0A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNR1RL0M
Received: by kanga.kvack.org (Postfix)
	id 031B86B05B7; Wed,  4 Nov 2026 14:51:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A1B6B05BC; Wed,  4 Nov 2026 14:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E632F6B05C8; Wed,  4 Nov 2026 14:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5EAA6B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:51:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50B9E1207E3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:51:08 +0000 (UTC)
X-FDA: 85398480216.25.51DE063
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 835342000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:51:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNR1RL0M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEQe0uyLMhpY0v6D+NYVpfdWFgM7DE6SumWpafCq12g=;
	b=xXTTZT67AcO6J0VWvfjp7ck6DmfkBIhNRGYByengP964mkteYJUogGhAqFc1GZlOGNVbtc
	af6R4yEhLuOmtRxojmQGyH2Nij2hDrnzitHyOBsl9XO6ahhRwesIyuLZREvNxLz1eEZbNB
	gl4fViTApmO8yXVzPaxjOPPC03QsZtQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821866;
	b=LCcoCEmgHgXp8WOWI4EwUM2zMh4RGWJj2XahEc47bBybeaSpzdrcu5QVUwG+Cn0xSvW3g1
	Zxzrp2NN1/Qcgd0WwDI85BCmkg9uWM59TTKU0JNVX9YV8uQqjZ3o44emwfawR8wRKr/gvz
	K2MoD5U+qyNQ8CPDgLX1CGHLbZZssNE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNR1RL0M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA4A34047F;
	Wed,  4 Nov 2026 19:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE711F000C1;
	Wed,  4 Nov 2026 19:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821865;
	bh=nEQe0uyLMhpY0v6D+NYVpfdWFgM7DE6SumWpafCq12g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNR1RL0MdGjcQerL1pRweO0sDyx5srKRXEN8HDA+Rakv7ORmxGv0M2c4pYe9RS1TQ
	 0hEIzB+5FOF0UCUZDy2W4t4c7HuYIzaQJTIIdmOzZYD7DdxjyO4UPMNhgtsSPIcilP
	 VKQkCD781my0Xdy0OOhH6pW79rQPVmEqRIUUxd2NdY92712CXUTz6e3VpbB0hBPCek
	 OuNQy8Ti5KEKBVAOmNI7xjQ/es+OJejnGIOCcQv3TLP2VhuvJQoptNjkpFmMJ9AFiD
	 0pSOj7vYCxBvgAkRaIbFsX+qFB2wBAEL9TsIawHW/SCRe0fGQn34mw49XBQgFh27d6
	 NX3UXBJy8hndg==
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
Subject: [PATCH RESEND v2 05/30] nfsd: factor out setting up the exports seq_file
Date: Wed,  4 Nov 2026 20:50:51 +0100
Message-ID: <20261104-work-procfs-fs-v2-5-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1726; i=brauner@kernel.org; h=from:subject:message-id; bh=vD80ghFjEqER+DW0z2Tx247oQHe2lrzCvRX/1X8RBv4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97jE4HGMmWSWebTGtb+f+qbf6t/93PO9leHL1HTEbl YAwmQUfO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayJpThr5Txruw7h8z+75d5 n1L9ZprSX0ON4zl3v9jMV5lvl7Zx8waG/4W80ze0KR4rWpY6/3hi66zKk8tmbsxvP1RSWORQnvT 3OCsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kbqo6ki8inctfpkzdsf6uyexmkqmscyf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 835342000B
X-HE-Tag: 1793821866-458951
X-HE-Meta: U2FsdGVkX1/FAWRXpm3iFkrHsRq/P6NM5TppNHhMsOUY+f9MRcdhws+rN8TLhlstzfBJhqTPmQMOQzfDktWh5GlZIsdYJXkLB9eAuKE5kG+IGhLLse01MP6h0GyOFO9QBhDJXg9ukq+bbSHs8B5k2TE4CCXz4q1e06bcdJDccjxgjD3cS9R7dlAll814YTrEP5Xyl9yRApiO5EX2KRzIL0hVqDA7pl+fc+jWQkozaKC43z40ct1pB7s5FuSjR/NBMLJwkLNR7hxmczSlcje/l8O4kUazB9g74Gr8y8kVmGHtwgLtr1G7Gd43fB0bg0H+YSOJJ6ylA/TXrpAbzsfS4/1kIxt5/6EqqDSzmfATs6QHjsoiyPhqA7EwsizCTLUIo8KWgIUHqDOe+241f1Oct+zpp+gdsEVdhpsNQXsWdQCiq9OURvjVGgbHc44zEmO+tit+3hydhUrc2mAK/ITMHicm5JiMy95Kt2oPqYpXh4Q5oaXylAq3HAnuMDX6IIWDXe4M2ptplEvbXbwjYy4XrTc+Igd73S/mbt0ILJNs/Jn6knNUWzuSQoMOXWKQcmzPGLV4eQq9RNfbn9oy2vYpSHFNNeWu6o+ajPX893SXd2prqQUhFXcAN6mtdVuozgI/JPITgimJkeHq/yQYLpSjd0vZJuCMRUtnds4WCvwNemeBkyPM+9H4W6t/Wp311k8hObbWFw6Qgf8r7rWh+EMWgOfxyneDbzKQziC4tFddtIfZD/Ki9ePQDHAJrLN/q8+b8N1uBTEjUMw8ORzENJDTBmR4ZdE/n2VDXznG85SOveMpL0KTXqNONuO3tKZXKQyTgtv2oTDCNB7GEH6Udjuibon1Bjm6UTXlGeQ6G4bM2XKuPeSUZuMCxoan2E347naMnx3fGP5GoPdStwEXrSt31S21t4/Es5hLFmABg2vBd6LBJKFu0zB+0qqJ/Z0/XSa5Yeyx6/buy+/De+hGJyw
 w+IdM7Qn
 Lx+6XlXT4mf/W2oi4dIr/F2z/Is7kzvETf4hts019LIG1wKr6S7CMohIMazc97UhZ3Xc5YH+hjb69B04AywU0cxxMDPsC1I3jNCmB+Mf5GXx9VsWEGAuAmdGlYX8DMUQBUG5FpDlYV7hqigI+9BIXi6b6X5JHMaj5m9st2JvktHRypLdis6B4klynmzBqAUEwi7tNxExxndOIKwArkWZHnPetDW2e0S2nScKmkah9Z+JjxAx4dcccB2zPFYffV5o+trnIGv8bWh3xNFwG8dq/Mts7VQH6INGGzvIk0f6c1V8mCv66OHUR6YF+Uxr5K/QZYVqYVZC/MwCtXSfhbU+qgU7HvAdVMYdSGyLOEWttWEqt5QVYVg/a2TID6D3wzJx6CR1D7nXwWNcxW69VJRHxDocMna9bQAAsDqaSx1R2eitpo633uxy8r9bBCloCshr66ZfoSl8y0BdtJb0=
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

Acked-by: Chuck Lever <cel@kernel.org>
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


