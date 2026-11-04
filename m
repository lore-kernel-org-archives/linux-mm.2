Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330996075242
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dA0DNurZ
Received: by kanga.kvack.org (Postfix)
	id 2EC026B05E2; Wed,  4 Nov 2026 14:47:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1EA6B05E5; Wed,  4 Nov 2026 14:47:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2C56B05E6; Wed,  4 Nov 2026 14:47:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F32BA6B05E2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:47:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C3ADC0867
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:47:55 +0000 (UTC)
X-FDA: 85398472110.13.26F2299
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E45AD1A0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:47:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dA0DNurZ;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821673;
	b=Ud1YmvMTCw2xXaRyc9/oOAIp+OgipVx+rM4OIRTxdCEWmO2ginAgl1xZG9zBPztDKsVXlb
	Hm4jJW6pi+5C3Nxy1ZqgXj5bOLuBzueTpbmI7qacnJcN1ZRvaCGByxf+mUzJJODb9EtZLI
	XtS0Srpq0Qiub8sHlCGYdTpicq65yGE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dA0DNurZ;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7mJ23mAcDTgScqej0oFhuq1h/6FvdBmFy6u6skOQc0=;
	b=T3Me5Ceb+g9Ggug2g02mjdqGz/YgAdhqQXj3fLpriq6wq2IXAn5X0aAM827vgwrTn0CCO9
	OEQXJ2IGAg4FVHUDhstCgSAYJkSIH6enFfx7wIgEkRxcBNz/gb5exX+r/G5dWLJgE30Bzc
	ZoLRKaoiR4qXPuj/JCXw3Zr7qD8pIqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CE2A60F15;
	Wed,  4 Nov 2026 19:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A231F0093A;
	Wed,  4 Nov 2026 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821673;
	bh=o7mJ23mAcDTgScqej0oFhuq1h/6FvdBmFy6u6skOQc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA0DNurZqV4J9DbS0OyTvs1fyzf+tr+GnxjFgcPQAXyozxe/btBqIfQ8qv52kR1XH
	 FUZ5gMbXt9OK2wJH/Q21p3te0KBNKoQmKmOkjKcIkbKYcHgCrR5Dr4Z5UBlA95Ho1N
	 RZBF+D4QSJaIxJn6Y8WHPyeYdRN6+YuqVVO7YdSYR1PI9vvy2kuuar+gQyTcmGnjvo
	 skcmgOf51D6shHyYWUMhtACHkrQpha6C3N03hx/u1Dd1WRqrNEqgG2OeXjq39V1Dp4
	 i31YqmqhIyZZvJu67ZPvlEjwYe9Ikqs3ZGyd/wpMChb1hwGc5NYBbHFIVrVfRBvnFu
	 8IfvxRbYh5cdw==
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
Subject: [PATCH RESEND v2 22/26] ALSA: info: let procfs own the seq_file of text entries
Date: Wed,  4 Nov 2026 20:47:38 +0100
Message-ID: <20261104-work-procfs-drivers-v2-22-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2241; i=brauner@kernel.org; h=from:subject:message-id; bh=S+buwBt9DQjjWOReG2bmbtOto+rEgyDiARec22GsvW8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97ur7cKp5nuC/vvMVLfsjea7umM/MkrbBKuzcXst5/ n7/szoFO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbSPJPhf+m0E+VJ3WHGl58Z 7Hv7Z/9Z1+vuQv7Tv4jdCrXmPr1L1I2RoUv/kNHdZDXZmqY/2/X6um5/m3PpyarXv97kK7nJn/o 2gQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: itb4cmbpn4x5ni8ewqc6bccsk4txj16h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E45AD1A0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821673-599091
X-HE-Meta: U2FsdGVkX1/ewHyp8ve29flviUbKAT1PN/gwnWn60wEyCrt7TJ0jlTfdpsmJvXGlqnlMFYOiwo1qZOZ4J98tATBKJYZXaPsrAFO+mfW27YtiSErCa/QyQKJW2703iEHKLDMpYJVfqSw0gGHimGUSekKvR09m2IPB/wKZSyx4I0qdEojWBeD+o38uEPEoHBltiVSroPA5Ca1hdbuJ8ZtvEGMD2WUbaXDSXh40QODWZY/uXQmm9x0Z+0eVyQbGOinzJ8DpzqOnTtDC72BcfMtiNSE9JXn0KABhfDT/qe+fKlIGyxXfTojss5smqdCk2LPg3LROH103CA+rxAItj4Y54064gSb35iAtB8mvtp9kJRbN/unsWrEeBaqSyAua8WROwijhh3z4wTmp0b/Soz4cTR0TtPwC1qH6Q0uTl++bs4hQMxgc0pmGCLo1uhd2YVVbmQtbMBv9Fe/bjIW1n29dX112Z6UWxOTwffHzd5DolvpOGXQHxhcafNRZCzACaXwEwtohV1s1CoexGHR26xcUjte6VZYiLSbrkpdjb5IIm8wOBGT0kcp9isgVuMqdEGiAKWl6Avkd9M+MbXYLMGm5k1mvBnypFU7F+Pm3ZzInyF+7ZL6lljgN3F0wA/U787vUui1Yy414OxG/j+1muVxvTlQzDI1zkPPvdj3yMWZyjDcH9Iw7zYjHj+f8GUZ/8G90L373Ey2XO4a8qm1iDsowUFs5sK0/6mnxvVLDFwycit5WI4ecYHzk/klgh9ervuDTqdfAL61BUvR66foYVfaIXP++Q7BMtdtJvcUtECPKE709H0tV0EinKQjl1UvMFz5Ri8gNSsOXq+gOMToi/jih2XEfqdIvJ+d3mEjkz5l0OTugHx3SHjnb9r/KHMj9u6zDE25/+zOZjGU4YuxaP9+SUz9MZqKBzY/8QgpAfnFUF9+lgYU9EMXgfOziqYjbJPZGqTp4JnAgZ10QaeB6S56
 LJnzvXPj
 FRYtYSy3Nvz415Y5X6WN01DZmWEMRDU7RFZezDNpe3c3PTJDFbRpqJ1hABlShYQxVbOY8Q4x+7uOLCEjYokVlq5t4Ux4OCr/iuRMulPBPVshFjW9gCBophOVhwae9R4yuE0aSG98G8DfleF8el29tWDNpl11jveNEhX1J9i3lQ2zB9I+2oFNUuDfOqubRU+l7Dvi9eMu+SmRMERuMlJrBMAeh09ZYeb4SWnMctg8/xC+Trcd+34kDLBKU+lMl2OS2X2V/6h9rY1Qk/gq3ExlGNfH4sr6cnKe4/MrZaO5262c5jxc/3BnWAWUjkE9Af+5/cODREUZ+ePw8fbp25dKqhNJOVXW1aWcUMzn1GFzBFqwQ6dHF1X1DakDGGHNeN3waR17Zx2MNW8mTPCteYRaaxkfiYJtM3KqX6Ew6Xn1D/TXJYa6pYx/u520TAXr0vn0Iafty
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
index f608d335b6c9..42a4f8fb3198 100644
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


