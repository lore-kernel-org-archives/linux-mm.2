Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F1A606D80A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gkL6dVH3
Received: by kanga.kvack.org (Postfix)
	id 6AF286B05D1; Mon,  2 Nov 2026 09:52:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F3B6B05D2; Mon,  2 Nov 2026 09:52:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54EAF6B05D3; Mon,  2 Nov 2026 09:52:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26DB56B05D1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:52:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB65D40121
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:52:34 +0000 (UTC)
X-FDA: 85390470228.15.E596B5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F0F3612000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:52:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gkL6dVH3;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631153;
	b=gOFvEZOO3LfvIuIFhZ5XuwkH9UcmlIARCtqIXmQ0f/BQjh3i9UMeHW3v0ShV09ANflca7D
	cMRsSmmv+Jo+uR878Ymm55ArU7QUfIwKkKza+SbbKQ7femIf3Lh14eM9pFugSt369ka/Kn
	BG8swLOjN1O2vhau4KJsNdo7TtMemcY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gkL6dVH3;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7CXhIggcklIY3xO5IiO5lA9eZblBCQpzIpV4iqWwIs=;
	b=R9XvlHgjGyRlBq5K37V7CXePQTfZuIUMtR5AeEhwXr9rbLJJfnkmfcb1FVdMmuAm/unZyW
	BPj9MKVDhf1cSGTPzHn6E/yY3oCnMm6JlhCY78FAOnJrajID4SDrseEarenV7Bn16N120i
	Ok0s+1erz2LfK69Wgijp4tM8Ebxl8Wk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F5A60200;
	Mon,  2 Nov 2026 14:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943F01F00A18;
	Mon,  2 Nov 2026 14:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631152;
	bh=t7CXhIggcklIY3xO5IiO5lA9eZblBCQpzIpV4iqWwIs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gkL6dVH3qeZTZTEUa5gJkjb3DNPVL8n5WP7/jOyBtnyh2kByZfYEWHf2I4V1dxI/p
	 MRJ7Cw4L3gZu5jux1vQS4dO9q+KH6eZstOXSKpu3hAjg1a2jYzTILzigEgrHxnw7a+
	 i+t8SHRQhy99x5vtc69Wd2RooVfSrGTh0BlmU//CeRIHSUWS8Rx6aYeOu7JZwe1YT/
	 PvpClFllL3x0bHydSz1hKBiSwFXahsk/lqsUAX5OXvNypfMaPi/I/xtwDZZXht4OD1
	 TjstHlA2Hp9ENKs7XrHGkLPp/n8NK6zuyN2Fg1CTZaD1iWdK7fJJWkqOfluwSEGTxl
	 kopkZdZ+WBiqA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:48:49 +0100
Subject: [PATCH RFC 09/16] seq_file: add seq_preallocate()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-core-v1-9-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
In-Reply-To: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: F0F3612000C
X-Stat-Signature: w56uopr64z61y96aasbbcs7kxbgkm1m3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793631152-390821
X-HE-Meta: U2FsdGVkX18gxYM8VvkZZQN5zGFYO9k704+krVxEJKybdrufPBnpry94gbh+DTTCi1VD5M7O21B9RmnxxzdRsbGVh5kuBWhj5Rf4UL8As5gkB6m3bUpP3SvsFjHTb8TffSmhcA6P9RVz8SbxHrACBMyPngueYNKGNx/blxfJ1GfRhopZDLfcN2XPXup4KCn1vOLTKElopNSXtZqzCjGlPw7W8E2ZFeSF9fapAm61r9ipS6GItzDsPCqov00bNwVOOUI+UwJBCb1O5dxLbxFgw29+2v+SeE2l4sOPHProlbzLxcM19OUO4oU3oI0UvbTddshRrbBK/hi4XQAT+5XpNxH/uO2kHXiAR3O/1qwMYFFBjShMvYnhjehoFkp/YYzqpZc++6VoWcI/7ygt53Ab08oDSfYR/TE8lOMfOepHj1uPN6B2EN+hWlmfaSdY3Riqod2RNDaYWGxiJM6MPwCSyxIYSP1ou8x8O7p0/BIIAJBDYrfEaik9hDEWoZqX36PL1WFS+OJfiZgHN5lJb9dac0UR+JipnGGnX6jQ7DKDrObCmdxyKbRHAr/Sg+hRACL0e4gZ9q+cKBvfofiGJcGman5rJux27W5MLcan62fL61uDdhs55KeV6C7zFCHMtOR6b6W8rOsgsU4FUV159dYRMEhs1LRkoLzFr0Zyg1wV4dLFIPZA7NID2ewVWz8EDdmUU1lTXu0yiFVj87lo/Y9/2pOWlmvXIXAe5xc49B6iTsFUpQkShZPEv5/PDL0V1z45e1XEeTyUhhWmaHuLE7rbRXILVLapxcH3aqBxL5cNCOcL/BmEsYSTFNe+9r5ydAmP43lpSVIjgbGvz40a93aLwRHn2RoDJbUyHNEE1A1Es3jcR3ohSt4QslZQZ4X91fHb37+AYVKtx3WLmm6uo+LG5Y7z1WfALbZcywASpcEsfZWmxICLCpddS9JJJpzL6Dgz9WaYMEvl7N4jiTdMZMH
 gxeNfQ/5
 WetpJqkLy/6+aaQhpd3x8Rw7hD6ZjeU1k1iQJwz9pOtdqL2EYRwvg+lgdj5NhabEj2oQ2N04f9JZrNRfEbA3yhdZjf63j1nGtEQKXlUWGpxQTT+apjOqDuebazEFgHmy1d4Yx2Na2Fr5P3T3mT2qiigRhru5T1MtmayFiBVduge5rfZtjzn4TrSpFvfz6yZKUUtOSarhYVMFD9MOTojMKKffjK+ZiUIfaLAF3qXOBIgTV8DV2GhA89qrgMJGsCCE5HCUPkh1VxEnhKk08Iw/Uz1XcKn+H5m57YOkI6TZyYMMS4ZLoaSlpeENvuSg/bQCGac9sfaiEcALNxa4=
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


