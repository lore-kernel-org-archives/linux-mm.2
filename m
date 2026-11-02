Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFBB606A338
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIAek8Jb
Received: by kanga.kvack.org (Postfix)
	id AD5636B05C3; Mon,  2 Nov 2026 10:17:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85C66B05C7; Mon,  2 Nov 2026 10:17:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974666B05C8; Mon,  2 Nov 2026 10:17:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 704336B05C3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:17:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05610A6CE2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:17:15 +0000 (UTC)
X-FDA: 85390532430.20.C8CC943
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3BC1F180008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:17:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIAek8Jb;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfyFssPJTJvcuxSkG9f8kEvYNY+/USJZ9O0CNfDvqvg=;
	b=3RioKKIAVQzRfxl4b/AoXt/vRRltBeI4SAUoU+PkMpCYJ2Jdq/+/TWbSQNRLj60vZmwHTn
	h5iOVS85lLH8wWZuCAIOMfJfBvBmxBvlkWmKgaHrz4l6TETeE6mHDG9fNPX+ZRtHXyrOrl
	6BaCl9cUknHKBrY2BSCJ0IjaBnQbHdM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIAek8Jb;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632633;
	b=p+OMoKXrLu3tERTokQ8PT5CzpdFLYurePOJW2GIN3b10jmbgGDkpxfu2LAi0jiWaDxarEr
	2JTcKX8dLzZC8s7WNvnjdifCRiQndgQEyQMFGTkMH/te94fXYGfeIaWIxz1tc6mDN+i+BB
	KL+7Ssyyhqor+66x6WtT3GNm3Lc+Ruw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2EFD601F9;
	Mon,  2 Nov 2026 15:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9E91F00A16;
	Mon,  2 Nov 2026 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632632;
	bh=DfyFssPJTJvcuxSkG9f8kEvYNY+/USJZ9O0CNfDvqvg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mIAek8JbLq+ZTqafvxnw2LB4ff0HkgTC+aGi/6y+yqF2kE7G09TiWjvwMQVWXgKWJ
	 j1NBMlnTlbAcrUxodtgBMsoNaR7mZikqMyEB51OmAgcxvAdR1s8057XPYJi0HWEcOs
	 nRQ2bf35kusyWGtueO8k17X4hhvJhhcg7WtwOm1t+uhngeu4kRt72ZitikRHEpqXcw
	 0vFOCh1DqgCGmWwYabRO/RjwOOn7QzGMoKfLzJLEp7rlauEM6K8PwDfNkRsufPsAeM
	 2peqxA8vYEB3IqNs7/l+zYP0dgKn/Tb/G4l32iZDViykot94MML8hqtyznICkXme6K
	 PHuY3YZ2HYILQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:27 +0100
Subject: [PATCH RFC 20/23] ALSA: info: let procfs own the seq_file of text
 entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-20-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2241; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yuuVKP+NyltjwbFFjT2vZNxR6EDjxJEWdEOE3h9z4hg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG54IGjD/6mnFTu7Rc+WtcysmcQROiHkB9fbPbpun
 guOHT0Q01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRI18YGXoZp+9W7rRa84In
 xaigxV/V8ey9lUm3GPv3trsIsZj2hDP8U3HuWt3B+9yz/ENv9WeHC8su3N27pzCJQ3J1nv+Blfq
 JHAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3BC1F180008
X-Stat-Signature: cezee5qh8g5ptk4sexu9noyga7prc9ec
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632633-208628
X-HE-Meta: U2FsdGVkX1+vvJ38DoAAQgF/t8th8qKyeJSOrZ82thEYFSS/+iGgz+fGhY1h9GUtIe//jwrncb7On0w21hpxzk08RC76yyAszROr310hfDnUyEBE02TVWfm/pgyTgyrRo0xGi7PMAJ4HqD7gF4UV0xjCJN2+VnIYY4mcBhf5UBZi3bZdcdEiIhMijoekHCxdrVCPvMU7pyxNroi4DdLDA+Mr758nBGgjibE8us59t3TOk9kMeLxiuJXSAzdIfRuK7hYNlKU+e8lMpl8sWI4/W+gxCYpExPFaIDAiIZZqh6pWZWmEvo5b1E8ZvqjENYfJBu+cAV9SBI5uuDRkpUXGx6wFO5T/zTtkrz7OGNQl2ta8I/y78Hnp4wXdiMGtEAxAhp22UROfIgPBPYqCyY7E1wH2i0gNvD2qUIg/pLc6mQqbWb5ChDGqLDuDefTU/eHAireh99/H76oRmwvKb+bhOaWpk/zZfscH5WPV2WfSes1wUksxsKy1NVTnDvMjXHTjAhkskqyP65bExizSW4RV2Sv4F0I3yyfm9Oh084uQGxoX2x9HPyS26GxucC5Y+Ugetuorii10EH5OAMoaxRKLMwnwgeLyZL3JddBxXYjizpW/3+IuqMK1U6Hd2KadMp3viYqMDMsaw0zxMQn+CDugJrdYHac7CHotsz3ea4dJN5zRPxhh3akkk3PMMla8dKd8zs3XL4Senu7bNQtJIzNf4Qsxz1Gv91RlgF5fKmPtlJ0MsODcmMhr2TF7OgWOM0R/Dyj9NqINJrSF3c8V5/SBpiZ5kmdS4WRPZ46az+/FtKgAtzCTJmuZdWWfWz11ip/yuriH720z4pBKKhvF156rfFka/8Cce0d9fi8ZWb9ItM8pPc2JsHL5dYbLLgSVkU7BK6aSHMGZWrzNYMnv70EkzwynyZaOgBEhVrn04WrwDoGELdFTb/xRVvhqixbXwmM6nUuN/0KbPTLec1G5xCQ
 AEdysVmt
 SU13L17iQmfgmgqRkoZg8WMMfyX0/1iwgcbf1ePWQbV3GL/bADSN8E9ymQ8AH8eXF3hp01i1ylVRs+qOJEF3VjokvI+6wKH3L67WZayxBVwh6tQ+rP1JdE3BP5C+qwUmR5qIa2pPYWOBIQeLmRQ9oVpgvfIxCQ8ILcFcfXf/8MaGnpP9Uop736ljTdaWrQ0esl2mHQq7vOlxjAGNZPmc5RXnzOh0Zo6+nrYAQoGBOejsvWee0TthxMjyUP5h5UT8c+CNAeJgHiCS6BZoFw4sLIARkyzeHhnQomslVePQZ1bzeiW+yQAh73KF/MAzVEh4GBfmUTRqymWqI7pI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function and let procfs open and free the seq_file.
->proc_open() only sets up the private data and preallocates the buffer
now and ->proc_release() no longer releases the seq_file. Reading an
entry then no longer holds up its removal when the card goes away.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 sound/core/info.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/sound/core/info.c b/sound/core/info.c
index 982087bc8575..8f905f398a0d 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -346,9 +346,11 @@ static int snd_info_seq_show(struct seq_file *seq, void *p)
 	return 0;
 }
 
+/* procfs opens the seq_file */
 static int snd_info_text_entry_open(struct inode *inode, struct file *file)
 {
 	struct snd_info_entry *entry = pde_data(inode);
+	struct seq_file *m = file->private_data;
 	struct snd_info_private_data *data;
 	int err;
 
@@ -362,13 +364,12 @@ static int snd_info_text_entry_open(struct inode *inode, struct file *file)
 		err = -ENOMEM;
 		goto error;
 	}
-	if (entry->size)
-		err = single_open_size(file, snd_info_seq_show, data,
-				       entry->size);
-	else
-		err = single_open(file, snd_info_seq_show, data);
-	if (err < 0)
-		goto error;
+	if (entry->size) {
+		err = seq_preallocate(m, entry->size);
+		if (err < 0)
+			goto error;
+	}
+	m->private = data;
 	return 0;
 
  error:
@@ -387,7 +388,6 @@ static int snd_info_text_entry_release(struct inode *inode, struct file *file)
 	if (data->wbuffer && entry->c.text.write)
 		entry->c.text.write(entry, data->wbuffer);
 
-	single_release(inode, file);
 	kfree(data->rbuffer);
 	if (data->wbuffer) {
 		kvfree(data->wbuffer->buffer);
@@ -401,11 +401,10 @@ static int snd_info_text_entry_release(struct inode *inode, struct file *file)
 
 static const struct proc_ops snd_info_text_entry_ops =
 {
+	.proc_show	= snd_info_seq_show,
 	.proc_open	= snd_info_text_entry_open,
 	.proc_release	= snd_info_text_entry_release,
 	.proc_write	= snd_info_text_entry_write,
-	.proc_lseek	= seq_lseek,
-	.proc_read	= seq_read,
 };
 
 static struct snd_info_entry *create_subdir(struct module *mod,

-- 
2.53.0


