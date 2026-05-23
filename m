Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1B1CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226CF6B00B2; Sat, 23 May 2026 13:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF566B00B4; Sat, 23 May 2026 13:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BE06B00B5; Sat, 23 May 2026 13:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 029706B00B2
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:56:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5A3FA0BFC
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:34 +0000 (UTC)
X-FDA: 84799439508.11.DCE5253
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 22C3F1C0003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCSdfqNI;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avaAlGi99keULPCZbynNTnKAsRLlbRGsrJ8jPwcvMgE=;
	b=L1K/Y3YVDu50R4upuzYQFl3QOREPSD7/d8VcJSZSi/TZ9oMpR4U0oZVYFqvL/hPGkxA/Nv
	uF8NQkWcEYq4YKxo39ExbDWpgsOPKqWYmqoSiJ5wzHauKo7S6Y0Iu5TzqcO0vfYwOt3wLG
	am7wIAUhGaHbVuGYJaichoX3P/b7DrE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCSdfqNI;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558993; a=rsa-sha256;
	cv=none;
	b=lIuyUcMAKix24UDdX5UOM1kGjxMfc6VQEJFsiMDbgvD9Jnl0T33wNMNP3pUc+8hdLb72A/
	mbPVWvwD1Au5aWEaPrzPmLkNhR8bzEKIKlcsHlz4gype6gZlIV2f+dslDjOZw/bwhyyB/i
	e4iwk4LEkuSatT1SSNi1Qq45nCHK7jg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 457BE41573;
	Sat, 23 May 2026 17:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA291F00A3A;
	Sat, 23 May 2026 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558992;
	bh=avaAlGi99keULPCZbynNTnKAsRLlbRGsrJ8jPwcvMgE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nCSdfqNIbpAILIl1hkV8eRrcN1BW63mPl1SXXJDMC2qdR5RyaxxJGoqPP46gwgR1S
	 +23QGRthqb5rkclytzrT4aNNh23BqD/SFor3S4bTV7lcsIexjJFjf/nTcfVKNnZdDl
	 zm9CpBj4O92KD7M+sFppTDfYRg0P+I0San410HCOyA9/hucFpDsekC0skrneiMae8f
	 s/FlJUMcGqpZ1eE2hEooc/JDON11jyXAJlM8GzjJCY6gaCzDLXOtxw70PzbGh78UeZ
	 t8GLZb8jdivXwzqrjSaSh/j10uwgwnPH68J080OEN8uh3h/W49iDDQ35JPS1eZv99G
	 yvks9jaAUnw4w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:27 +0300
Subject: [PATCH 15/17] configfs: replace __get_free_pages() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-15-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: kz6hy84j9hhoags53kiyk9jrmbnjbdnr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22C3F1C0003
X-HE-Tag: 1779558992-953999
X-HE-Meta: U2FsdGVkX195SZISsd/Tbq+1O7fjuGMXvrtA0bsp8lsC+mV5uY34HBNUoWY0dTn4iUqQp6g5u/VcA529CGoZgwnJLBdyYQYhcnv9feGkpdGoWbG48fjyTVR+uQa+kA7U60YjBDIPE8zUifp1jI6vN+llGkB8GlBjPMtz3I8xArs4pIf3ZUXGiMzadnmvqqJFhx7bFXgnirvpk/+8Li47Be5W9lZ58XleZCuAw2anh85QxwQjJrx9xJbB4ov7DoytuWBVm0bTbblOIPFg9YjAdeHe0BavN1UMoZ4ecuLW7fW5mpY3qoSHOv3C5pf+bdQdGWodhAv5YZBEzRNc+g9qDGzAiNS3PlbTMTKp2HLPDEDXhpCjBvqOOVd2KJZv/zWzQSOF77OQfYSf0h2V+WUtFbu8Ho7uo33rH8ur8SsutpYq1w7o+k6jO+po0RG4BzXLb5IdvGQdVUNyERWqfSalU1iODmXiEIg/ZzYz7Qa7Umnrr6wE+e2A7FjfCS9o5u3LUW3OhKvx9zGPkBq3QK3tdw6/rZ/BFlA7sZVF1VZZ3k20q2GNtjeZ2xQjrZPGJJcirHSS9YYhtcaaSKBk1jTh1MS/OuvgSkFyrvjngVSipqZ7ib9FULQMvJPxSZbmLo/da+JwF7I8O6UinX/a6TIWziYWomJh1XUN1E+dmq39NlUlyxPgjkMnpOrHY31xZoXnzuyDTdym6Zu3NdJunGsWD8ojk9yNw+H9yNZ07g5dp3g8/D7ioAL63q4bGkSLqH/LKMB/VEzf2PjP4NHuPKjA5KtlCvpoWTC0h98nHhPJ8pZEH8Kg9VUAQ8DmJrLMYlDww9sk65p63bckX5HvlyIY+nwkGv91pVuzHBxm7+FJhryIeG7mL5ujV4yDyCbfQHFxyv53ilpEuk3luBb15ercEMbkMVaPgVTqtY8r57dn0Bjd++s/u7OLUKYvnS88/8rsSDkN0rEqlQaIsNYG4Sg
 0y8UIEoK
 2oPW3QXf4DXim/y0PGyd2cTrSetfRomdZfToEwM9kvKLyv+kEFPVBtkDEMXi/W28sP55PLswS4W64B6IAQDxDe6EfgaEnxR6WeX2+qI/L5iBe1CjX9ByhYmKouJBboytN1hmqwpW4VubxNHAGlfJ3Jespn6SqkWEMEIcNrFeM41Q/ZegNqI/t6qR2ix0ayRSNGAbWwV5CXmvx9caGofAUBpT0uZ0JHNj5MW/1ssgzwCod3CGvG88se0BkghURre3axCd0kh49sYzs7MQegnV/GUzHCkfAuMPkggdTpnFjz5fQEBLeTHyo42x4prLMIqmAfS4UoXm3yx9s5fvivNAOUmd+On/kQlpTIqroAmYADgFpBN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

configfs allocates staging buffers __get_free_pages().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_pages() with kzalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/configfs/file.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index ef8c3cd10cc6..a48cece775a3 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -59,7 +59,7 @@ static int fill_read_buffer(struct file *file, struct configfs_buffer *buffer)
 	ssize_t count = -ENOENT;
 
 	if (!buffer->page)
-		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
+		buffer->page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer->page)
 		return -ENOMEM;
 
@@ -184,7 +184,7 @@ static int fill_write_buffer(struct configfs_buffer *buffer,
 	int copied;
 
 	if (!buffer->page)
-		buffer->page = (char *)__get_free_pages(GFP_KERNEL, 0);
+		buffer->page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buffer->page)
 		return -ENOMEM;
 
@@ -381,8 +381,7 @@ static int configfs_release(struct inode *inode, struct file *filp)
 	struct configfs_buffer *buffer = filp->private_data;
 
 	module_put(buffer->owner);
-	if (buffer->page)
-		free_page((unsigned long)buffer->page);
+	kfree(buffer->page);
 	mutex_destroy(&buffer->mutex);
 	kfree(buffer);
 	return 0;

-- 
2.53.0


