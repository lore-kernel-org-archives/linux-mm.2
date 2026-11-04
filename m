Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF836072644
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TFjDqZZ/
Received: by kanga.kvack.org (Postfix)
	id 06E936B05EF; Wed,  4 Nov 2026 14:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044976B05F0; Wed,  4 Nov 2026 14:41:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51176B05F1; Wed,  4 Nov 2026 14:41:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD3DE6B05EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:41:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45BEC1C4240
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:41:20 +0000 (UTC)
X-FDA: 85398455520.17.D653C6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C95E180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:41:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TFjDqZZ/";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zr7obOUiLNzJ4M2rJicyi/Ze6HCzMDPfBdGpZnrgFfM=;
	b=ekrE6EXk59dsLJn2cQMxTfyHnqJgox2vFM96/zRcebO//z9IUk6FwfwgfVxq/x9yqTQBS5
	zwjXfg2YokyBstbDxHyW9UI8HYQ+0Pg/Qtu6wbSsoTbuedRNpKwXolSx0kE8JZIaYu8xv2
	9E1+eFME6B5oXYab5whHjKNI7CCzz6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821278;
	b=Gv9PcfwsVykVPvUQKpadcxwwUX6G55tJj0IpWvB311hplWTTpYEQVmU+W35h7jw0dybQfU
	wQBCM7kkFBq0meDXCYazNqC4tmVINGgSTKESrDBeb5T9CyIJ0Ppz3Eaas8jiM4H83gYWxN
	dRipKI0m56t056eu1wQYS3H4BaJNBz0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TFjDqZZ/";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC49F417B9;
	Wed,  4 Nov 2026 19:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D881F00919;
	Wed,  4 Nov 2026 19:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821277;
	bh=zr7obOUiLNzJ4M2rJicyi/Ze6HCzMDPfBdGpZnrgFfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFjDqZZ/yUzLlq0AHrRb5nxWFxABXvXQCDCDepRKxtO/+DBoiHd924rOXqwV39mBk
	 7xCkrI7XXqopmEBEygr+d7LVUhWDkEjbtByAS2BeniVcX7cUeVHz8fQauHPvv0iTAN
	 N7eRvtbhE1tCTi/bRw9rc3UYJbpqIAjFGWaWNdO/ByRLbrk2T4vEZCSk1IeyoJGCNP
	 l+FooINdTw1eqVGKCx+YGE50hLogaFCmEhwRPgTTm9Jo8wQRCWb1gsfGDrq+Yb3o2r
	 eWpzM29PtQ6IavQhyK8jALEj1OfP2htX9ROHmW9j/4lxcAS1kM28pIz9UvG9ZDYqie
	 36VczlHeApOTg==
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
Subject: [PATCH RESEND v2 22/23] PNP: pnpbios: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:41:03 +0100
Message-ID: <20261104-work-procfs-arch-v2-22-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1575; i=brauner@kernel.org; h=from:subject:message-id; bh=IXYMr4OIXAB8ydnfVDKQ7NIihIFaHGo221DwmHIwdwA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mR/NSPT6HkaC/vt8vZrrZOf7cn8cOajzZze4try1 XtLbIuDO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYy7RvDf9eUspCkiD7zz/mp M1Q770my3G5f1nJheSLzi75vySe2PWX4K9E+OSP6wK3TV2dX82rV71go8lKvXe+0OfMZ0ZTd8x/ MYgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: kgoi1eryxg46mgeeo6wu5yzcni9cmi46
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 7C95E180002
X-Rspam-User: 
X-HE-Tag: 1793821278-548541
X-HE-Meta: U2FsdGVkX1/YJa1h6rXbGN5q7troVoDpU7phQzy8fN0yGuBfEQVWAjWj6J0CFNgOG5Iy1PpOcywr5H7Y2Spc+1zHO7o/s6otyrFeZpQYF6wsSZDnJaCFX8RzHw9n7vmwHpn6kURgsxIxerTgqlGWoqyybJ3jo64HLWTfdZJ0kiMzFE8PTD2imCV9auN1DnSUBOP7a/DDc6XQ6NxadJ+kruHQ2JQDSqAJvMQcL6GPuJjXrB6XZHMGa/MS7qyvcDn1h8ZQq3oRwDThSZ/DGVnAt4tDVHEkCVxzNGUpBnhEUpAQe2VnYHLpNwb56wL9ZMbCOTutkdLc7/Qy6dLa+Z9HdKaU5M3NiinLLnXiCnV0txvhbLjds60r8ag/fpmNLhhqs4tJPWvr/z10PeT+TCIssVorT2g6xCpEzQhIiNX6sU7qqmCYqSC3iY2zYHaGmZxb2X+9HxX+nGCbWSI7MKVIEb1rxmbqcJ1F8TfLnMWXBSMMS/CzRVtm5EYPFtibJj89ULPqYJxGA4Oae1vsfkx+RLqsG4zMs9GcGkJXtCSVtUrok3BOZU8mWXKjBFSXe9TnfBx8wpZLH9/uZQCWze3TQaNyzpu+oJtntR3N1wWFQm4sPZSHyaBUl8KME9IIgvSj65+B2j5dG1dgVQXrvCb88V8/8YWLzOfG3TYbor3cF2tRz5sdzDEuaH5NK5wSkMCyOYWiLEhxhREfQBygE0F8PRGzdtiW0Y5lL4ZH6OKWmfygAaZLNgTbNXQw2LI+SQWGhlknl66vrdWtGq1fTR6KD1moAnraryHZXU6QBEWgULibQ+1Q0BAn9rrfWIvKsGU+tlP5Wf//VUuR3mMGo1EJelrvI2vEsuLw9V1MjpA0J2eUdfeRbNZ53e+zp70OnV3lzk/NyHA/ZV1fGFV6JA3M+ekLfiN98yritjl+UjuECOGhlaLysaWmTRD6ENyi6DYizpF8rFc4nHImQRLwPP1
 GNJdZKWg
 afDf4khmnDBNpZTP1gnHiihMd0Q2ohy0WAzOlZO7DukO4VcdSP6fzHwj/IcFqNaF+z4mWO0rj7bbhqcwFn4NJNuF5Gm8Y8fAsIPwJz9Xgfh9l1Gg0WGU1SAm6FTlzMppo3rfqp6Os8YO2ZnR/o9HxldP0TWEs6VTvOI1e6IGs4+gHt0O/73+/4XPTQpCyc3qHfIa6Kud0XbRFcF4XWHXoJ8QOaek4mnG5rsHtqg98c0RDYpLW2Yc2+VlLMqTXvd8ECQ/hd4zyw9u6bqL1PB4t451bp/2dFiyEkPKpFhne7xySVSinQ9ccCqWMLrmA7f8nMIA7+fg34Mr1tSsHDc23ZXQWqR+4DFrdbGHG2Xmom3eDHzcC9TTuTz7cyBnCg2DQ4L9azvra9ldK+AoilGyPaJKNPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/bus/pnp/<node> before it pins the entry, and take the node data
from that copy. A node with more than PAGE_SIZE - 1 bytes of data can't
be written anymore. I don't think there are any.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pnp/pnpbios/proc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pnp/pnpbios/proc.c b/drivers/pnp/pnpbios/proc.c
index 14632a8d0da0..00163aedd738 100644
--- a/drivers/pnp/pnpbios/proc.c
+++ b/drivers/pnp/pnpbios/proc.c
@@ -171,7 +171,7 @@ static int pnpbios_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t pnpbios_proc_write(struct file *file, const char __user *buf,
+static ssize_t pnpbios_proc_write(struct file *file, char *buf,
 				  size_t count, loff_t *pos)
 {
 	void *data = pde_data(file_inode(file));
@@ -191,10 +191,7 @@ static ssize_t pnpbios_proc_write(struct file *file, const char __user *buf,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (copy_from_user(node->data, buf, count)) {
-		ret = -EFAULT;
-		goto out;
-	}
+	memcpy(node->data, buf, count);
 	if (pnp_bios_set_dev_node(node->handle, boot, node) != 0) {
 		ret = -EINVAL;
 		goto out;
@@ -207,7 +204,7 @@ out:
 
 static const struct proc_ops pnpbios_proc_ops = {
 	.proc_show	= pnpbios_proc_show,
-	.proc_write	= pnpbios_proc_write,
+	.proc_write_buf	= pnpbios_proc_write,
 };
 
 int pnpbios_interface_attach_device(struct pnp_bios_node *node)

-- 
2.53.0


