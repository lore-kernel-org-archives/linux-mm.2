Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97DCF60A263E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ax8dWQye
Received: by kanga.kvack.org (Postfix)
	id BF4026B05B4; Mon,  2 Nov 2026 09:22:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB376B05B5; Mon,  2 Nov 2026 09:22:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1E66B05B6; Mon,  2 Nov 2026 09:22:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 899766B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:22:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F63EA5B8B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:22:06 +0000 (UTC)
X-FDA: 85390393452.15.A5B3116
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 22D1D80004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:22:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ax8dWQye;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oFqdYtQQ93hmf66Xu9P3kJmoMCkLJeiEqd5UgVqoAA=;
	b=H1N1iAXt3NX1KrIhqxDEHouhK2bDP70peXYEEjLUnSZYiSNtQ1GXifZM5msiDdPvtgvqso
	+jYmkz5uO7+l+IBTeCxc8/bqfmSSN67iHSJ3jraKX7aRbsI7ifCGTehGSB6VP15zpBTDaJ
	yvXeoxG650BNX+sbtKtvv4PgDVseuQo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ax8dWQye;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629324;
	b=rXJ4a14ZVSp823jQEAXeoZMxXttsDTMUJHiuBXgHXkEgr1tLkpYrFTYMtGByVE4xNiXZCS
	yeD3uUcXbJVbJ++Cwi7jMxGekHVoIiNO1e4rOcU4quD4yBbPPLB5BZPZPYs0xXy4gJ3is7
	sy3OHi2HUlrISajWNpU7wjK74/N+7P0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5813E404B9;
	Mon,  2 Nov 2026 14:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B981F00A17;
	Mon,  2 Nov 2026 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629323;
	bh=0oFqdYtQQ93hmf66Xu9P3kJmoMCkLJeiEqd5UgVqoAA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ax8dWQyerzpr/lWF0zvdG4jamemgWlVZd/h7GMRXnqhpTBDJEl7ev50HTLs6gH7J/
	 0p7NNLryksO6UgSelTjy18+WNSqy3gYWlFUSSyR19sqLhSv0hd9SLP5IvSKwiIx0nB
	 EmF9BtAu7NyghltI+OycSZEJ26mnAtmx7MkuIud4BVq2NcIGDOUtdlbiumRpD8YiX6
	 cay+Ggorj7ZVDVBu7GBPEK5Aw51B56VDfiDPqSmzWSFRn7vWnbSOjeXUnaCNUmE3rR
	 czSLGyB9rAbV56X/5L4Tebo1G1sdy4cG9DZlv5tDH9WHwzjWU8tayWaP5twT6EmNQp
	 RARmDivxEu4rw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:16 +0100
Subject: [PATCH RFC 01/38] PCI/proc: don't truncate the position of config
 space accesses
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2714; i=brauner@kernel.org;
 h=from:subject:message-id; bh=57Zv3BgjxHPYJgAYtfWWUhWCD6jzurA4v7Zp2iJg+04=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJN11v/UUrXtFcJuaV4rJB5G2Ou5n+Tu6Z/jVp+uW
 MTK/0yqo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCK7NzH8M2yqMdxuWRuoE37x
 QsuKJx8C/3tt2Xjyxk6p05Y/GGTn7WJkeKXl8emh1r1VXHuO8HVGP7z6emFsq1zH7SfFda/fuJx
 cwwoA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 22D1D80004
X-Stat-Signature: 1oymsze9x3kqznps3319t713ymsd7ht5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793629324-517673
X-HE-Meta: U2FsdGVkX18xYQlXDG2gnSa5ooF4u4TcQAsa1oSsJDSRaCWiErdko9zUJf7/AtItUMClY3/0NxhIy+5xeUN4rRNwIGgZLHKe7eIH0komBmSqgL5Zs/CZGy2cGhRCt74xAl9qmdp/FtyxlvfBOnLh6DACYTivmeVuoKe3WR6gZ98HuumsqB+M/2HLPhalcOE6G+qHg0UPKmw/vUp1Qhxf8I/PoixRC/UcPDHAIeC8D+vr/EpKAdPyr1J2E0UlfQsOkgfe99uL9IJ27xWUyK2AjUrXtyHrjBtTRHC7OJPnWZZeZHkh5vsoG3DmY4wen3tZYfuXnLmjTM6fznqz4M3dr+MoBBGSbvrVVNFDwCdxffNVvrZkrdruUygdFbG4QmSYlxT+PUpAufQbilKlsK1SVqtejHOCbrwb8jp7/H5uanT8eOCYjipTmN2SL3AKnwCsRZpLKA7wqPSAL5sqvtDjXSAuUgWXF7mVtl6sIsjdBWvOYK7AdBm+1ub4JGKd5ItztxbHWsHHcqO19U4LNnOTEo6gO3/yK58tgJSqx8y85iEaq4Q5OsUJ5gVqSolXdyBo/UybWJFh2GY/OOi+TKvIYcT0SJ+4TcCEKekqD7QpI8EQE38Xg9hg2nf0tZQJs/jMCyegM3sbU52ADJ3UMivf2uBLyGsf42YPHHOLRbCt5rlmNAQE9+e/bUd1m02kWkH0lXkUKgt1+/mYsx+20QXGKmXO/o5LawEqU7U1UEktrrOgESCsLqXhCGGgy0EWuF1+X3maagLyAR7ZOK0jRE8wO+fv6odi7mj78PNBHrdYdfJOf1iM0lnDWJ2W5Je325HibSnFNliyTTfMJObXxKhN3VoEdwzdIELZJhbn3oeswOGwKQ6ZQVRDL72Zpmfh4OFyFoenBgohyNg3Av77qjYQj77Kev5XzVme0v92tFLCcQNCUwB1DXzNZkOUnD550vQD6QNAinRB7Eb6AOiyKUg
 wP6B8Rzt
 e2PPsgNxnh6TaspKtNcQbtnKML28ASDasb3e5Z0gakmMpyesa9/RGHk2v/QRIeUrvdcoKX9b1jN0CyI1MtUB2XMx1iaD1ouLMOqQlyJ0YbvW/3S0gXj/swy7dc5ISRtAzH+DaS5uFzkb9GfJPt3fcBmlIrvFZIN25jBgSY41wfa/qUsv8BtyoVPQEFQudO+Rl2fAA/RGuADG6+DsZwMr34c5OIPVkN6KCZhRURIqw84OG2whWst3rPAfZOBle9+kneBuM9+CZ3qtEsOoSUPdkWePL4WWVXKVjcSDo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_bus_pci_write() truncates the file position to an int. A pwrite()
at an offset like 0xfffff000 turns it negative, the check against the
size of the config space passes and the count it clamps to ends up
larger than what was written. The loop then reads past the end of the
caller's buffer and writes all of it into config space at negative
offsets, which pci_user_write_config_*() pass on to the config
accessors unchecked. The write also returns more than it was asked to
write.

An offset above 4G that truncates to a small positive value writes to
the start of config space instead. proc_bus_pci_read() keeps the
position in an unsigned int, so a read at such an offset returns the
start of config space instead of hitting EOF.

Check the position against the size of the config space before
narrowing it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pci/proc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 3d7a9ed5fc22..e0dc70123f82 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -32,8 +32,7 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 				 size_t nbytes, loff_t *ppos)
 {
 	struct pci_dev *dev = pde_data(file_inode(file));
-	unsigned int pos = *ppos;
-	unsigned int cnt, size;
+	unsigned int pos, cnt, size;
 
 	/*
 	 * Normal users can read only the standardized portion of the
@@ -51,8 +50,9 @@ static ssize_t proc_bus_pci_read(struct file *file, char __user *buf,
 	if (!nbytes)
 		return 0;
 
-	if (pos >= size)
+	if (*ppos >= size)
 		return 0;
+	pos = *ppos;
 	if (nbytes >= size)
 		nbytes = size;
 	if (pos + nbytes > size)
@@ -119,9 +119,8 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
 {
 	struct inode *ino = file_inode(file);
 	struct pci_dev *dev = pde_data(ino);
-	int pos = *ppos;
 	int size = dev->cfg_size;
-	int cnt, ret;
+	int pos, cnt, ret;
 
 	ret = security_locked_down(LOCKDOWN_PCI_ACCESS);
 	if (ret)
@@ -130,14 +129,16 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
 	if (!nbytes)
 		return 0;
 
+	if (*ppos >= size)
+		return 0;
+	pos = *ppos;
+
 	if (resource_is_exclusive(&dev->driver_exclusive_resource, pos, nbytes)) {
 		pci_warn_once(dev, "%s: Unexpected write to kernel-exclusive config offset %x",
 			      current->comm, pos);
 		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
 	}
 
-	if (pos >= size)
-		return 0;
 	if (nbytes >= size)
 		nbytes = size;
 	if (pos + nbytes > size)

-- 
2.53.0


