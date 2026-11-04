Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D3A86070308
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KZ1raRI6
Received: by kanga.kvack.org (Postfix)
	id 924E16B05CE; Wed,  4 Nov 2026 14:43:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD7A6B05D0; Wed,  4 Nov 2026 14:43:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813446B05D2; Wed,  4 Nov 2026 14:43:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6456B05CE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:43:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5079C0866
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:43:42 +0000 (UTC)
X-FDA: 85398461484.26.D546A89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2686D40002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:43:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZ1raRI6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/r9Fhg2Z0/w3CqoKnG0DKCxv08Z9PpiFGMKT+radK4=;
	b=ApOdBUcWXvrQbmaSyYgJ/VDBGpmhnDNTH0Y1IqOLgQHxrAJK4ufbGHdwgRz8cn6yCYoiIr
	Mc9HoYDTN/9YMKH4d2lAlkM5C6AccXRjmnTgXi5f138tW5KT5Q2Ybuj7QZsdBoHiQmIcJs
	JatohiMMXp2CB0ao9/CZ+sS7yXB7a1g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZ1raRI6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821421;
	b=xBj+xAfcxszibxBL+FEO6VU8lqxwwg19R9JsLdL7GH+ErBC9sVkHTe/AJyVjuAyfdmFAuT
	3K385Bh0vlKPbvmaJUOkgx14LLJ4Gi6OH9gXbsqQXJXf4a743uWRarXKVWclbnGux9PO5p
	wftk+9QMhCMgSJo/VMHibY7R7ac1PuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75CC343D85;
	Wed,  4 Nov 2026 19:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7721F000C1;
	Wed,  4 Nov 2026 19:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821420;
	bh=Q/r9Fhg2Z0/w3CqoKnG0DKCxv08Z9PpiFGMKT+radK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZ1raRI68GhT/XlXjqAtcujYMj6ekVEJnVbT4x9Mzm70KXld0AlBQN8rUNIo5mZiB
	 v3zJfRoTx9WShvsapVrEfRLIh+JuiUCfmb2ZUX+PNF5aJyawlAjxV+5tufKSc1hVWN
	 VvPh24+PpQcho7riTX/8XuQc8iS04jARE2V6OzsbbxkTRQ7Vo0aBZoFeGZZv1hLQVS
	 Hkr6MNWkpqa3975/oQHgz3pITvq9gQ4JYehhDDJQLj/WHKcKawkPFVUPWwmjxCdrYt
	 4tLwomtdk6B+7RV5x8bRuXG3/mtBiQigiySV/b1v9b2+3q4lMlVQMUvKy0hVdMduzc
	 enqFVJsBMRBJA==
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
Subject: [PATCH RESEND v2 05/26] PCI/proc: let procfs handle the ioctls
Date: Wed,  4 Nov 2026 20:43:25 +0100
Message-ID: <20261104-work-procfs-drivers-v2-5-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2106; i=brauner@kernel.org; h=from:subject:message-id; bh=2F6i7ISm6IP0WfraLShTjEfHw8rrOdRgm90gAFJMkQE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97qrM1Vwiw7U2st/BZEXS4y1RZxM3sfk86zgQ1MPQt WzJg3/dHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZxsXIcNz/xGT2BwfN+fis PXL3f3M6eWnrx6KbjrqRz9jkwj7pRzAydGzMjXAJ2Pg4UJN1p/usyxfL45+dWzV/cmURT1nhaud 6BgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2686D40002
X-Stat-Signature: rwo3d1cy4my5h1xprfwjkw7wjp9xwbzp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821421-861146
X-HE-Meta: U2FsdGVkX18xJdvgg6oEJRgMJig6bgBoiNO/27PeccJ2gLndnIqI+ki78aBrpxa0uNC6wUFLuVtaipQ524fgjTXLV05WjqmJ/tO2M5Zwl/APJqxveINvgnvcKgnO6VkLjTVNJVC7g7AY4SJoX0/GMSJ4pfY3K6SaSN8tFy8KPyl5bWtAs3GrFR9gx8RLo7EQ06yeZSHRr+RlG7UbiIqbokMdGY344ki16+CDyVh7DnXwtVRhhl1ubDlLRZ7T0j2Yev5fTzvz+2b3wliFQYiHf4VNnaFjApXeXu48wPLs558B/N61h8ZlOuk27toRGDdg+nU2fpdWwYCCnPZMj6VbVYXa7VzXVoYAndogszqeUapEmnXvySSsnaB7pLOFhiDyRsKbXXA9QvEAEkvhwEsvxKQL8ZZ6Zk36was4QrR8SKsfe8dzHBgmcMT22aUzY259pP5c/Lbvm0D4agtu0SfJjjLPqeM2lmT+FrfKbm4tR7TT18LlP8tKaJ3szwbrozWiuUT9lifQUCbvJ385wtNLCS8VbT5y4273h9Jvp067yybAauSUSpu1HsHjtli8Spgh3zhBLzeeMUB56o+3/FmYM0+FCyMUxSGrkVyZcLj0/a1RHRqy3748ih24IB9xpB2Dk6cD7GDZGpAUTQozlfDrXzAOeNb4GylYgjjYYyEXAcLUzlAKEVvhnAo/WG0SaIpv7B274sDTARWMnrDApZ4J3H9DmIodYMEV3M9ivzBq9gOoAnObcRCI8AVba9Uig3UxzcKfpjvdHlv/yplkfTCh6ygJct04cfD7Ev2rhDpld3TKRphXXeVxSX4SGKEsSVFv3PgtU0t6Vza7eMIlWaCm4wnXZhHwqIpiEuaRDrfRc2hZoDg5E7Ftn2WASq1/gLmltmSqsvz2dXDoUpX5AZCv5zGfhUiTHiPf+LrKrOaL9jEGCHCqOTHxgw+UtAPuRmAJ58M9zYQXI66Hi+90RDZ
 MEq81zv4
 MZnDMoucRchD/xndO9B1SnKHczgEZ31ObSj5sKM899UeauUNAnbn9Xz1X4aMV+cMZEBf+v8HY5EjUh/9tWMSWRr+qSMaD4rHZLC67Nu116/IHOK/5QFU+yKrbgSAUOSA98V1fzayif0kM+sJZJN6qbKn8fUlfYqPRYmkKoRIxeWBJ126gLu68XwfDcKC+lQjiWgu9y0posDb1CshU7clGIVnKFinhSQw7CPQRy/UWY7YHanl6CkPzDT2npWHMLUitonUo1eDPCiZiLmqkLIhkrA4SH1KDOKtqoUheNHJG8ARK6s1o36Y0K3QXBXHyYpctblrPWSoQHw0VAsJ/XmN1rzO+6wNnt3jIMDZalGm989Qfe3z3NSlujEBQDYw555xMjcoITgCc26rzdi4gFJLmAMIrGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The PCIIOC_* commands take and return plain values and don't touch
userspace memory. Implement ->proc_ioctl_buf() and list them with
nothing to copy. 32-bit tasks go through the same table, so the compat
hook goes away. Unknown commands fail with -ENOTTY from procfs now
instead of -EINVAL, and instead of -EPERM under lockdown, since they
never reach the handler.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pci/proc.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index a8d7469f222b..6b0cb5bcbea3 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -192,8 +192,7 @@ struct pci_filp_private {
 };
 #endif /* HAVE_PCI_MMAP */
 
-static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
-			       unsigned long arg)
+static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct pci_dev *dev = pde_data(file_inode(file));
 #ifdef HAVE_PCI_MMAP
@@ -321,16 +320,23 @@ static int proc_bus_pci_release(struct inode *inode, struct file *file)
 }
 #endif /* HAVE_PCI_MMAP */
 
+/* The commands take and return plain values. */
+static const struct proc_ioctl_arg proc_bus_pci_ioctl_args[] = {
+	PROC_IOCTL_ARG(PCIIOC_CONTROLLER, 0, 0),
+	PROC_IOCTL_ARG(PCIIOC_MMAP_IS_IO, 0, 0),
+	PROC_IOCTL_ARG(PCIIOC_MMAP_IS_MEM, 0, 0),
+	PROC_IOCTL_ARG(PCIIOC_WRITE_COMBINE, 0, 0),
+};
+
 static const struct proc_ops proc_bus_pci_ops = {
 	.proc_flags	= PROC_ENTRY_SHORT_WRITES,
 	.proc_lseek	= proc_bus_pci_lseek,
 	.proc_read_buf	= proc_bus_pci_read,
 	.proc_write_buf	= proc_bus_pci_write,
 	.proc_write_size = PCI_CFG_SPACE_EXP_SIZE,
-	.proc_ioctl	= proc_bus_pci_ioctl,
-#ifdef CONFIG_COMPAT
-	.proc_compat_ioctl = proc_bus_pci_ioctl,
-#endif
+	.proc_ioctl_buf	= proc_bus_pci_ioctl,
+	.proc_ioctl_args = proc_bus_pci_ioctl_args,
+	.proc_nr_ioctl_args = ARRAY_SIZE(proc_bus_pci_ioctl_args),
 #ifdef HAVE_PCI_MMAP
 	.proc_open	= proc_bus_pci_open,
 	.proc_release	= proc_bus_pci_release,

-- 
2.53.0


