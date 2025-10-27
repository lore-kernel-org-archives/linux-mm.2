Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 743DFCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D6880087; Mon, 27 Oct 2025 15:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D208000A; Mon, 27 Oct 2025 15:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81BFF80087; Mon, 27 Oct 2025 15:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62FEA8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:04:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1958DB74E5
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:04:21 +0000 (UTC)
X-FDA: 84044819922.28.F0052C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 14D6B180013
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:04:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=NTs7+Vwj;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761591859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5pBYMXTPntDn60DieBKkNa4T8Czf+7QY+NB3lTrCd4=;
	b=19WoZ6fbdvig8FZHwW2QUDz/QejG6cPWjOIYekykue+ujYdpBAWiZ8ZCmxxx0EBwP+HbcP
	aTMNaD48Q4KoLu8JdT9lbtyu9x6gsUId7TmHN/WU8CJmYKoAj8o5rKnBV9GB/79ZYqNkuJ
	v2NsnOWxlot7l1SxxvIQBS4ksiRjmOI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=NTs7+Vwj;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761591859; a=rsa-sha256;
	cv=none;
	b=Tfy7qqq7SHTePbIyYMNS2aJlNmfacBF9azLUQRYrCpQ/rpQ/3CjO82vrMeg1NOVtiQeFs2
	kAkgAc3NgmDhX0errB8kaziwwiXSRMObsn8MjrH2kUsOnvUMxv+2Jd58mwZnCoBqJYFF+H
	UWXzTu04H1XW6A8Zb6GrxQE4gt0SpkY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0F4B4483F;
	Mon, 27 Oct 2025 19:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257A5C4CEF1;
	Mon, 27 Oct 2025 19:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591857;
	bh=b2BsWYnZLRQZDPpKVQRoLrMmWrDa6Fhuq3j6U0/3mzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTs7+VwjoatVBtKor1+ZLn6Zeh4ZTS+4gcih0p+gNvhj+vttRK7UhAONC38ukl1Dr
	 zCuoLv1ALUbdZUfE6/5CpiVBQqL2EY5nZ/V79aqjTLZyY4tksk8XprRnhGzXjnxsIZ
	 /DjoXbQByA4wf6TrMYItJY233QG+2ANqoiKpHoxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-mm@kvack.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/123] splice, net: Add a splice_eof op to file-ops and socket-ops
Date: Mon, 27 Oct 2025 19:35:04 +0100
Message-ID: <20251027183447.045484526@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zzzrgbesy93x35qdxhi4ceqrhiskmuc7
X-Rspamd-Queue-Id: 14D6B180013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761591858-867496
X-HE-Meta: U2FsdGVkX1+dZ43AMl/y21nlUrgPguZ+DLq3/zWjEdJcGP4vgXICtUQPKupWtW9Ba8f5WO6GxZQ9ndKA2lVRb/2irSpK/mNjncOzUkzuVBFK6JsVG1FC3h6Zd46DLTbxTE0VWG+bKeXbFtQAWYCh1dwtyJKmL4LcetuX7B+dfJhnfx8+9Ax+qUaVoRxPGwdT8VGLvBIadyP838t7kP4xcVzEY2nIGqCtMUEX7Xw9uYZolIHxOLehfotnctdlEcEUse0x6eshoOiLqorm+UJLO5HcHeMtNGuW5ZRHQ7kr9HWb7901mk5uv3tMKP84uXFUmrTPmDciJd0VLv5dPvg3Yf/Fi10eSB+kK3eZn0nSLVFaKJIDk4MOVbHPDS13YmTFOzDVQ81lbm0X89/BNp9l2X1cQkxB8o/k0U5PRFOhtTlq65isrvPB+jIKIqLc6Bt0oP8RlOgsZIGNCCCh7Vm2TcukvMstmRIW3/8rRf8up5yadf363DuFVCsZ2SeXAcGvRB4mAZDoULVG3WFt83EGHpzmt5YOJPfVXkhEoWnQGTjlLmVdQrQ/SDnDKcmU7aajUnaELUe91815UlqkXzABJGP4Alk49tOjYjYFovrolesbYdM9kjULaPP7JEA6tmuqVS8RiL5v9NcT7ur4A4t24mzNTcBnoeDKr+9LgAwQpAxbHEjmrf2U9wTYbppRiV5+cieLRuiKE8bofneTonyZLgdue5aGqkAr73gRSywribQlGLahweF1I+21iTwWr+eRhq2bAIzEYpc3In7cENPogMb7NS39WGoIGdEsT7LBhF8RmqZ0RcZNKS7EKjhgeIPzoNNoXAb9pMpS0rBlL7yuuju2rPh5Gi90tqJ9ulYI4hvw0mzNQVq7m3Z5L7l9h5US8XkeiFFLvCWQbtJ9BU5dQ7TjsHaMVfp7oVILm4Zzc+JpKzTpdUFeYuz1SXGqbi7rYDSh++nrgUF2OIYG5kB
 mB0x24QJ
 XjoaGxYw/x9lHDkRBpb7Gb9DmV+CfxcwUTcytDehHIeD+cz7nXjt2vb80RqdHNbdeELvUFDgX+SUMde29MYGO35hcY4Ehap9num0VKJdmLysqHRNHknwZBbwUIAZLE1//Bzfb8JeFvZ9EBSeCL3Vuuk1W5qTpqRFPf8X7AJlIHmgCue33B4FuHqVzOGoMuoiq/V0qRbG7bYw13u8cCaEOdItlMv+IKwp7UNHOcIAsZblB9Jcm2N9l+cWDeSPLXPI0qR7bTKMIYTjT67cTPN9H2RyHvDKDXNVt6P3Sdq7ZIrxq4o492uDOHnzagRU3k9yFAsYl4+J9c/Y08fBLdAN9L307cg/vJ+TpubVEmx8742aRCDH9ND2J7QRc022ZgdyRpiC+POZ+H7AqEPu6QGQN5KXiWzyrZmn6BsoCr66+FlVfnKDBPW0qoEOoeXeHUr3tKbBrJVHiNEHrqSMdGkdizUSQE29JX+C36N6Mow5aCpDW15ZUzOsoJ8YwdspiKObZz3QovQTK2s1qin1K8zN+GMTAs3BumWNYa0UHTRIDTZw6rbf3slUw6Rpv7f+FCRQ9b26+ww+K3q2/FxEuMRHEVykZMcE+zsCkRySmvECkw30N7KAQB2uY+vnENuZPP/KniouRLRn1mdSeGu01QDYlayPQDwS+Q826HloVNvpB28TItSQu6rOkoTQH52WMhDKn3XS/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2bfc66850952b6921b2033b09729ec59eabbc81d ]

Add an optional method, ->splice_eof(), to allow splice to indicate the
premature termination of a splice to struct file_operations and struct
proto_ops.

This is called if sendfile() or splice() encounters all of the following
conditions inside splice_direct_to_actor():

 (1) the user did not set SPLICE_F_MORE (splice only), and

 (2) an EOF condition occurred (->splice_read() returned 0), and

 (3) we haven't read enough to fulfill the request (ie. len > 0 still), and

 (4) we have already spliced at least one byte.

A further patch will modify the behaviour of SPLICE_F_MORE to always be
passed to the actor if either the user set it or we haven't yet read
sufficient data to fulfill the request.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Christoph Hellwig <hch@lst.de>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Matthew Wilcox <willy@infradead.org>
cc: Jan Kara <jack@suse.cz>
cc: Jeff Layton <jlayton@kernel.org>
cc: David Hildenbrand <david@redhat.com>
cc: Christian Brauner <brauner@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: linux-mm@kvack.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b014a4e066c5 ("tls: wait for async encrypt in case of error during latter iterations of sendmsg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c            | 31 ++++++++++++++++++++++++++++++-
 include/linux/fs.h     |  1 +
 include/linux/net.h    |  1 +
 include/linux/splice.h |  1 +
 include/net/sock.h     |  1 +
 net/socket.c           | 10 ++++++++++
 6 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 5dbce4dcc1a7d..e8591211044a3 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -767,6 +767,17 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
 	return out->f_op->splice_write(pipe, out, ppos, len, flags);
 }
 
+/*
+ * Indicate to the caller that there was a premature EOF when reading from the
+ * source and the caller didn't indicate they would be sending more data after
+ * this.
+ */
+static void do_splice_eof(struct splice_desc *sd)
+{
+	if (sd->splice_eof)
+		sd->splice_eof(sd);
+}
+
 /*
  * Attempt to initiate a splice from a file to a pipe.
  */
@@ -869,7 +880,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 
 		ret = do_splice_to(in, &pos, pipe, len, flags);
 		if (unlikely(ret <= 0))
-			goto out_release;
+			goto read_failure;
 
 		read_len = ret;
 		sd->total_len = read_len;
@@ -909,6 +920,15 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 	file_accessed(in);
 	return bytes;
 
+read_failure:
+	/*
+	 * If the user did *not* set SPLICE_F_MORE *and* we didn't hit that
+	 * "use all of len" case that cleared SPLICE_F_MORE, *and* we did a
+	 * "->splice_in()" that returned EOF (ie zero) *and* we have sent at
+	 * least 1 byte *then* we will also do the ->splice_eof() call.
+	 */
+	if (ret == 0 && !more && len > 0 && bytes)
+		do_splice_eof(sd);
 out_release:
 	/*
 	 * If we did an incomplete transfer we must release
@@ -937,6 +957,14 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
 			      sd->flags);
 }
 
+static void direct_file_splice_eof(struct splice_desc *sd)
+{
+	struct file *file = sd->u.file;
+
+	if (file->f_op->splice_eof)
+		file->f_op->splice_eof(file);
+}
+
 /**
  * do_splice_direct - splices data directly between two files
  * @in:		file to splice from
@@ -962,6 +990,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		.flags		= flags,
 		.pos		= *ppos,
 		.u.file		= out,
+		.splice_eof	= direct_file_splice_eof,
 		.opos		= opos,
 	};
 	long ret;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a8d708fe08b30..72a956d243c2e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2104,6 +2104,7 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
+	void (*splice_eof)(struct file *file);
 	int (*setlease)(struct file *, long, struct file_lock **, void **);
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
diff --git a/include/linux/net.h b/include/linux/net.h
index ba736b457a068..9054f17e4b631 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -187,6 +187,7 @@ struct proto_ops {
 				      int offset, size_t size, int flags);
 	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
+	void		(*splice_eof)(struct socket *sock);
 	int		(*set_peek_off)(struct sock *sk, int val);
 	int		(*peek_len)(struct socket *sock);
 
diff --git a/include/linux/splice.h b/include/linux/splice.h
index a55179fd60fc3..41a70687be853 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -38,6 +38,7 @@ struct splice_desc {
 		struct file *file;	/* file to read/write */
 		void *data;		/* cookie */
 	} u;
+	void (*splice_eof)(struct splice_desc *sd); /* Unexpected EOF handler */
 	loff_t pos;			/* file position */
 	loff_t *opos;			/* sendfile: output position */
 	size_t num_spliced;		/* number of bytes already spliced */
diff --git a/include/net/sock.h b/include/net/sock.h
index 3158cf0269ac9..b987074f80965 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1229,6 +1229,7 @@ struct proto {
 					   int *addr_len);
 	int			(*sendpage)(struct sock *sk, struct page *page,
 					int offset, size_t size, int flags);
+	void			(*splice_eof)(struct socket *sock);
 	int			(*bind)(struct sock *sk,
 					struct sockaddr *addr, int addr_len);
 	int			(*bind_add)(struct sock *sk,
diff --git a/net/socket.c b/net/socket.c
index bb2a209e3e28d..1d71fa44ace45 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -129,6 +129,7 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags);
+static void sock_splice_eof(struct file *file);
 
 #ifdef CONFIG_PROC_FS
 static void sock_show_fdinfo(struct seq_file *m, struct file *f)
@@ -163,6 +164,7 @@ static const struct file_operations socket_file_ops = {
 	.sendpage =	sock_sendpage,
 	.splice_write = generic_splice_sendpage,
 	.splice_read =	sock_splice_read,
+	.splice_eof =	sock_splice_eof,
 	.show_fdinfo =	sock_show_fdinfo,
 };
 
@@ -1037,6 +1039,14 @@ static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 	return sock->ops->splice_read(sock, ppos, pipe, len, flags);
 }
 
+static void sock_splice_eof(struct file *file)
+{
+	struct socket *sock = file->private_data;
+
+	if (sock->ops->splice_eof)
+		sock->ops->splice_eof(sock);
+}
+
 static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
-- 
2.51.0




