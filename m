Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8769606F236
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FmbTyM8z
Received: by kanga.kvack.org (Postfix)
	id B9AD36B0611; Mon,  2 Nov 2026 10:18:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71176B0612; Mon,  2 Nov 2026 10:18:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A986B0613; Mon,  2 Nov 2026 10:18:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 795566B0611
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01CB514016C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:18:13 +0000 (UTC)
X-FDA: 85390534908.24.E6EE723
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D10720015
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:18:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FmbTyM8z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mH3Z8P6UMOfE8MLC9SlyxmstA5/0uIySkJ7otw3RGiw=;
	b=UwuOZUVr2amAu/sAY5ta8jGleeA7D2fJYK6Dq8ttsUyumedoJPPYj86HJ+zT6UtHlMh/8z
	+N7/1QGWfH4sqG9Nf0ds7Oa7xM7ZjQENvwO3GdITdD59h1/4B35Lgoy6nLVuo+aeRwbCWv
	BCmxsJNWZn9j9GuDtKhLc4t2glEeGFU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FmbTyM8z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632692;
	b=Gtem6GXsJewnVpv85QVt/QS7xdbu2w35uuMlLFRpkaWqlNfoz+Rp0B5Q5tVelJjinQZCfB
	FgwNk192OFvzofAKsxHmcx7aoH8sQr1vlkIeDEZt8dsa90aGkzjVX64/zdRPqKPrQZUf5T
	wdXh5ZIkjwvQxM4Q3loIrwWLKByt+A8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D00C160229;
	Mon,  2 Nov 2026 15:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E081F00A1C;
	Mon,  2 Nov 2026 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632691;
	bh=mH3Z8P6UMOfE8MLC9SlyxmstA5/0uIySkJ7otw3RGiw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FmbTyM8zGqwanNFhJmHE+yr345sASMDz0Mkpx6EKJNZbLXUFdS3A7he2CNilS55cT
	 HQLgGFvjHb74xJ0qV2rY4+XnnSY6xn3ltD8mfNZMp4qmkB2OqkKB+56zAOIVhSO3Wf
	 lYsaZHiIeUWPxkOVGTOeUA/sEyrMrtZIZhapM00yvHz93y8CqvQNS09wICF9TSpolD
	 YpUUbIwRVlVNt5U0ywXbIAT+Rq71iwQnR6R9ZUh5jMkZ536CigxXKID+/DHQSFOW4K
	 uiZxdfeZMTu/1RXCAO1wfJAgPRht25qNR14pehV6NMY2ktyBg+92l/1LWlkwVNI0lf
	 g3WTgTzSXS/GA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:30 +0100
Subject: [PATCH RFC 23/23] ALSA: info: drop the ioctl hook of data entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-23-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1977; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iw+78SbfmRHzz9M2dcStkryZcXwy9rThc4PTL74QmD8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG64bWn0iafHzi8yfCYkfqLHV0Ex89N3u7Mzj7zJj
 6zynxn8r6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAijYoMf0W1mtRmR4iVHZdc
 bbd++jy7BYYtKZN9Zkmotp5ZdMllwkVGhj/V/87UX7dc/WRD/I3Eo9+sdlz7NWtXVqCfMQu3cvU
 2RV4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 3D10720015
X-Rspam-User: 
X-Stat-Signature: bhzhma71tih748seodndzwi4sfp6hhuk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793632692-252562
X-HE-Meta: U2FsdGVkX1/qFcywATPbRNiicEVn71XfxBFvhQyfu2j35b1HJcnAhlZFZoYYArn/lRiTxz9rvHi5zvWg6edZMHZjM9ECTnPU+aE8OMsWKaIzNE/xXcwgmLs8dR7SQSfbY4szO1d2Ye/GxbDzKqMFiJ418lvJEt06Vcow/SnlW7x3aO73PVFlSYlq4HlHutk/mQ1dEmfCvND7UODgvEEwbcKftEucvMmCktS8sYlOLLsk3YddMiX0y8gCt9tecyNz0OrDincTDNL/LxbeDw563WtF3QyCQeJfBLCvFV1I+71lA7QvatKcfbVSySBrJ1gDbj93QMJKMSshWQVQmxf8Oicuk7MHEXITngAjrlf+ToCzIvjxEMNbLgfk6TEn/1JRwElk7Gt11R95oXIIjhF6qstzUfg0TCL9/+1pMzOSHlThocV4AmJ5h7jzXghsBCeznpxILS0mel1TSt+BuBvNZhYi4vx2lPc3iuazVVgX7FShDZtcfhPDBqqZigNvqXqFyqf1H0YXJRI6f9Aw29p9HEeV8+2BuS06YWe00Imkq9ag53H3+SXFO7D+5jkZ2i190j+AwNeYFPkylXaCRbgs6AAD53CpqSovf9LMz/uXSTNq2xa3vrJa3X4OVfQIHTHPUWnWRBQK9M3dedqR+mkMw6S0xgDxzfYO6GNmUILHhmXcTxro8Hc3hKvs99dtYfe8qtLYAM//40EFJteuejXxXAaj1qTkpi+A7oGBEEAWzo0eBquW51cwgCLSi6GZr/o7W7Ei1jSFkSGbZXmdiTl9GfvRhX1I7WUBPNWeWbJw5jZsF55Wq4u9/UEDvKENo+EURXzXV9/swpuYAc8kSJrgQpat3QFcyQJylUc+IdZlRJ1iaD55j9mfhhMq6WGMJkDCWh6Rujl+2LAxINx/ksHXi+yLfuTLg26OmytHxnB3qd/iHIBKOEbkJYnvNhxVFYdjy79mHcEo/HC38xP0uVN
 pQ3iEzhW
 Fu/B8zcnEnDCLrSgBg1H/VjC8qkZZ8kLzIJ3PpnPHzOFtncX3D/cD3EzhjPVKq8FZX1fUX5h6FTHg3y5h3deCdJQxSSlHa/LJdbX10LyGi195UB6xe6J7anZN5je7NE1hpCiD2YESnVg/N0J/aCk/OMGq2On4pjz2ls5DaNbkXyuZMGgZB/ogzinGFalNPlrRHdBCtzih9kySTCfICBAvThCgWzRCdIjFyyIBhxk8HTfRFt2p6pBvBdItgz6zucFMzKZXh0xGQHt3tsjobxiu5xwBozJSkVqF8Xpq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

No driver implements ->ioctl() of struct snd_info_entry_ops.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/sound/info.h |  2 --
 sound/core/info.c    | 13 -------------
 2 files changed, 15 deletions(-)

diff --git a/include/sound/info.h b/include/sound/info.h
index b4b5bdd6898d..f32e81ef0c8f 100644
--- a/include/sound/info.h
+++ b/include/sound/info.h
@@ -50,8 +50,6 @@ struct snd_info_entry_ops {
 	__poll_t (*poll)(struct snd_info_entry *entry,
 			     void *file_private_data, struct file *file,
 			     poll_table *wait);
-	int (*ioctl)(struct snd_info_entry *entry, void *file_private_data,
-		     struct file *file, unsigned int cmd, unsigned long arg);
 	int (*mmap)(struct snd_info_entry *entry, void *file_private_data,
 		    struct inode *inode, struct file *file,
 		    struct vm_area_struct *vma);
diff --git a/sound/core/info.c b/sound/core/info.c
index 9665600ca5ac..639554bb17c8 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -201,18 +201,6 @@ static __poll_t snd_info_entry_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static long snd_info_entry_ioctl(struct file *file, unsigned int cmd,
-				unsigned long arg)
-{
-	struct snd_info_private_data *data = file->private_data;
-	struct snd_info_entry *entry = data->entry;
-
-	if (!entry->c.ops->ioctl)
-		return -ENOTTY;
-	return entry->c.ops->ioctl(entry, data->file_private_data,
-				   file, cmd, arg);
-}
-
 static int snd_info_entry_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(file);
@@ -283,7 +271,6 @@ static const struct proc_ops snd_info_entry_operations =
 	.proc_write_buf	= snd_info_entry_write,
 	.proc_write_size = PAGE_SIZE,
 	.proc_poll	= snd_info_entry_poll,
-	.proc_ioctl	= snd_info_entry_ioctl,
 	.proc_mmap	= snd_info_entry_mmap,
 	.proc_open	= snd_info_entry_open,
 	.proc_release	= snd_info_entry_release,

-- 
2.53.0


