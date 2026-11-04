Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 755ED6078C65
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cTuaWM9d
Received: by kanga.kvack.org (Postfix)
	id 874BD6B05CE; Wed,  4 Nov 2026 14:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84ABC6B05D3; Wed,  4 Nov 2026 14:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761B46B05DA; Wed,  4 Nov 2026 14:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AAEC6B05D3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:32:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7DDB120814
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:32:26 +0000 (UTC)
X-FDA: 85398433092.16.7E2CBF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EDEBCA0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:32:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTuaWM9d;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820744;
	b=b5XmVOa1mRiN3JW+6uKxUnAXO6a2ahLPvOOb+WK6e/1W/eQUgZEPYCJkWwe33h2oibsp5P
	NODm6SsTHFTRIvPHRNbBlVj/gRg+EliECdvam8polrNrgzyOamCpTHfZlppVoS6zUS65KQ
	+u0ks0h+gdlUWju+wZabikdqDTVXIj4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cTuaWM9d;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7CXhIggcklIY3xO5IiO5lA9eZblBCQpzIpV4iqWwIs=;
	b=0UnsQnSkXDK44jYUMHfeYtMfY9XuCD9O7O2VNPlPip3KatgzMmf4gnXEIXO2Jot6b6e7zr
	0A/Vsa2ZTjF0b3B9pwDER8vEOwzXq/NL9XBG8vIZbaO1MjDLbKT0mbDQ66cpygTb1sckxv
	gN9jq2KZQgUyQXS0XtWdY7DSC95cZnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C89E60D9F;
	Wed,  4 Nov 2026 19:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89F31F00919;
	Wed,  4 Nov 2026 19:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820744;
	bh=t7CXhIggcklIY3xO5IiO5lA9eZblBCQpzIpV4iqWwIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTuaWM9d7bmS3BQXsgtTAPR9uVh6iO0s1VUb1qW5xthyjwQ7vxJulOEZ629mv/ktX
	 8pc572eXrayXIbCxFRUJIEYHlf9ycJZjdr5EilMv+/yNyQNPgE7IbTr67SmbjqGKon
	 wQxWa1oDi8Z96DmUhmEkZsLKgf7TxOqe0u+yeHEa9M+VTfdbUwRpShdZhtLt7n6wLd
	 xG8ZPgiEEG146zAmYMMPTfNZP+A5FSPLxTvy8HupirTDlyG6AokYQO4fF7KBnvln4/
	 BccNNTsARBWlIFPDpemmx+BLFNPVItSM8w4MnywAOEfXW90hS1vRbBdoScA6JM7MiN
	 65ED+/q2glmuQ==
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
Subject: [PATCH RESEND v2 12/23] seq_file: add seq_preallocate()
Date: Wed,  4 Nov 2026 20:32:10 +0100
Message-ID: <20261104-work-procfs-core-v2-12-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2744; i=brauner@kernel.org; h=from:subject:message-id; bh=cArC7PPeLGnNNo4k1qcZwNiSGSA+jlDCNRnIKXcvzj8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bq9fUy53Y+meKbNe5Zf78F+aKHlY58q16usqyqJv3 +V2rX5U0FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR+1yG/3HL357Tm/j6pbNY 7t1vOYdrHYtOvFVkdFthFzlPc30mlyDDP53w+qwZtmFzcn4YvJ2TMYtvgYrB74l+jyOkXn9YOXn VaS4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z5odih85efjaq1hqqnncg8dp8zcf3ig9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDEBCA0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793820744-908521
X-HE-Meta: U2FsdGVkX1+mQoaMUjJjeV6rHnUPobmp87Id6Nt8gcj5Vcu2D2OYl9KB10dnzJS+06la7CySAM6gXQJoohOLLzV6y2bsgMzytaC6XRtBZuRlQAptLlKUivLdimH+rxQk+OR2bqzZRjbzFqmtBOwanvgU3DYhN5AzZiHccT12/di+q83be33GJC87TLFcEiEbVmbV11qopfXtC8bhVI8i8pcQyuB1b53FrK2m7LGCkR+4La9ao6qmZm9E5MT/B0u8AvVPvsXwQHK0L4Eiz8xOmxu9uLSYofWyN24m4ekzXW4V/W6zsVCun/ASwHua8mBOJ87A8j1TPOtFxJInU6NI0Ln1P6gGzYUN4NFv56Mr4hgQvIzOeIW6EEIT+QC9zO4f9psPN46ZxaeEuGOumIcB/xKBCZCjaUDyrD1uppMY+qQ3m5AtgbEEPpj0d7oW+No6EvlDtq8Ki8qFCW9hIWASllEsph6I4uVG3iVdkEWbvBjoMYB/R24eh30+m2130U7RP0mPxeTtamdx10vhdArtAQkcYIz1NZp+xbYQ0Xs439KDkuXLBZt99lqzaIjvrKH0J8aYhGPeZVhg7lLp9iWn4Ng27CFE2K8oMuXXH8l6++eo36zj7nZ0xctTDmkfPBpzpN4v7UQ2sEe6xLJ9AipKvw2a8RSJje8eKRwJwWyldWY+gGEtGyx7w2bWv0YsWjm00LZlnKA66l0Wf8nUHFdiTPfQCqcVpjY8OwnlmMk1TB8Su+G+62qqH7Az8U9tvpPFyVx3sZ7yOUs6Uy5o6bwMyodUrdFbEUmzAIp+Rxy3o8MFEP/1V4jtfyIR2hW7+Z8joOSeTqbRsOTAfdU14WZBxcwMQNCoisYw46LQMEkyJansF7KCdqZc7j+dBSs1sCO0zfsbPLBYZLlF2JW5ZdyR47+mdydyKpTkiKdgI+IE4rlDgIt41R/XZFK77O1Qh+rDJD4yZZKf3JkdDqmr8IS
 6gNErD3B
 O0bXBZZ30rr/9jCPia4jxQlSEBtEacafN1oUmiafXl9EHPkjC8FtQ/xn2Lmg3Eq4ISEC5U0fewYH5IlQRuZu0CdV8KktoUu8EYb5Hj7oMzcb+9sdn9mgfZOOBtCA/+OeG+u3856mEIzbX/OHQFpUflGphwninAL0SYKMnp2SRA1sMkMa5XcRmPly8nia7KAkLTH7thpXcoLJ3R1fifLW1V+SuTXT306JTXKvBmaqKhopL8E/ksndg+aii1U6/XU4RNN+AdABy26m63SI1YR37/vdSg7GjqzlMdGvI0jNB2FwgvRT8a6e+q6KruHcqP5SCYW2gMZGNM9ZiQ3DtlI8/dyhzHizvFr/gKdibbOeGjCP41+8z4hkLUYaExycQfFAQe3Q6y7pqm+m4t51XTEZEkeBJXbPEN00ORy4L9GuZx2igaLy3ZdwjBN8SRG9p7w/1G2vkXBqi2ZS54vA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

single_open_size() allocates the buffer itself because it does the
single_open() too. A file whose seq_file is opened by somebody else,
like procfs does now, needs to do that after the fact. Add
seq_preallocate() for that and use it in single_open_size().

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/seq_file.c            | 36 ++++++++++++++++++++++++++++--------
 include/linux/seq_file.h |  1 +
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 456c78719fd0..a4644cdda7e6 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -590,21 +590,41 @@ int single_open(struct file *file, int (*show)(struct seq_file *, void *),
 }
 EXPORT_SYMBOL(single_open);
 
-int single_open_size(struct file *file, int (*show)(struct seq_file *, void *),
-		void *data, size_t size)
+/**
+ *	seq_preallocate -	start out with a buffer of @size
+ *	@m: the seq_file, before it is first read
+ *	@size: the size of the buffer
+ *
+ *	For files whose records don't fit into a page, so that the first read
+ *	doesn't have to work its way up to the right buffer size.
+ */
+int seq_preallocate(struct seq_file *m, size_t size)
 {
 	char *buf = seq_buf_alloc(size);
-	int ret;
+
 	if (!buf)
 		return -ENOMEM;
+	kvfree(m->buf);
+	m->buf = buf;
+	m->size = size;
+	return 0;
+}
+EXPORT_SYMBOL(seq_preallocate);
+
+int single_open_size(struct file *file, int (*show)(struct seq_file *, void *),
+		void *data, size_t size)
+{
+	int ret;
+
 	ret = single_open(file, show, data);
-	if (ret) {
-		kvfree(buf);
+	if (ret)
 		return ret;
+	ret = seq_preallocate(file->private_data, size);
+	if (ret) {
+		single_release(file_inode(file), file);
+		file->private_data = NULL;
 	}
-	((struct seq_file *)file->private_data)->buf = buf;
-	((struct seq_file *)file->private_data)->size = size;
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(single_open_size);
 
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index b813b7e63d89..834daff48b7d 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -175,6 +175,7 @@ int seq_path_root(struct seq_file *m, const struct path *path,
 void *single_start(struct seq_file *, loff_t *);
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_open_size(struct file *, int (*)(struct seq_file *, void *), void *, size_t);
+int seq_preallocate(struct seq_file *m, size_t size);
 int single_release(struct inode *, struct file *);
 void *__seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_open_private(struct file *, const struct seq_operations *, int);

-- 
2.53.0


