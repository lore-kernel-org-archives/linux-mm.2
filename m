Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07FD606A324
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vQi1Ag9g
Received: by kanga.kvack.org (Postfix)
	id DBEC26B05B6; Fri, 30 Oct 2026 08:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28F46B05B7; Fri, 30 Oct 2026 08:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2086B05B8; Fri, 30 Oct 2026 08:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC5E6B05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:40:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C918A06D9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:39:59 +0000 (UTC)
X-FDA: 85379249718.26.7A3CD64
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 951391C000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:39:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vQi1Ag9g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of meven29@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=meven29@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793363997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idcCYTNO1871c547soSOMVzF2UdXrjdgIrvxw0MC2E8=;
	b=Rd9vN076yBDlIXMatSB4brUwyVd1BiiM6ZHoD/DOGv7gcXih4LtzfAF64aaPF9MKF17uF5
	bRhrguR8tFC/x1rLwk35Wi7ILuq46nBNfQg906hmTRYgF/tBuwogwbttktU5fSViXH6/Dh
	ZJbhRqKoW0Wcp4ffKcUSBi8Db9cNIss=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vQi1Ag9g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of meven29@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=meven29@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793363997;
	b=BJhCSkcDWdwZ9Iatv7HF3OwpyxHBR9ClZCLBwuqsHK54Gxr1tLZLPclMJr5W4i7BT6ghYK
	W5HHlg8bAx4wLHbSeRyMAvS3bbZ17etIML05kjPXoXEh29pWdzjBf5cCm0GRE+b7zsi7uq
	LqvArS9fA8LgMV5SPSQ7Q+5TtfMswnE=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso4034505e9.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793363996; x=1793968796; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=idcCYTNO1871c547soSOMVzF2UdXrjdgIrvxw0MC2E8=;
        b=vQi1Ag9gyrk+i6wc4q7Q/K33GIctQ2StMtFlxvIco0DKz0gT4YLlW2KGcC90ukj101
         sLxu5wzdqnX3pDOy4aZSIBQbEw9mEonlajTKkGMUH1CHGggPxlUhAP475nF8kzNTevFq
         lzp2dMRAGM+FpAcj5rWL8xOW0MPm8bAaKTWfVCAXsbVGezQDEWzjNQENBhi6i2i26QXj
         6apBQukXUhlkNcfuHJn5h9BJHnbke9S+TAlvtuiubEHQgg9/wYFlSgDDMct0OgYkdCd3
         bBiwfbDypFi3GJ1eIdQYC/ldS5Vg97PUvaRyG5Va6Kvqi7FSysz5pCUiZRD1TqskFUm/
         k8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793363996; x=1793968796;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=idcCYTNO1871c547soSOMVzF2UdXrjdgIrvxw0MC2E8=;
        b=nvsddszJ9BM2NLw/ES0mJrAcs9CCJ416S6FiiTrlAocKlKj7pO6cHbaCMK3U3Kg4yq
         nJj/dCJKWiF0FutfO1pK8tJgMPB2RSzdooFzG487KdgP7NSddUKPtb8OvdVwl92UFYDY
         Nm6ZQqanvAwcbMkaagoKHBM24h7NbVSGRKRX0JP+bw/QlfhgrZd4oreDQ78wuFCbamx4
         ZB5C9YEAVbMkVIlgiZUsX55DIgKvNU79vDpSuOrYzMzKeJSauhY4fbyOI6cWXwgwlcml
         +Fyv+9whhewtRv6GilPmDmYxKBAxWDGmYzE0HcBkbVXeHTlIhbF+CE01tdDkjdt0jzPP
         Wisw==
X-Forwarded-Encrypted: i=1; AKwUvBx9XMH9X0wSt+AB7Ac0ilM3mjFABw1PTtTig38aZ5ynmXO26Uj1j+cQGYoMQSt63kGnV4RT9hPX5A==@kvack.org
X-Gm-Message-State: AFq9FYJGRt1PDJCv8yeWt28qX7onExPw05tmO25xqqXGd4Wm0OX92lPH
	3Q6V/zoKhqWz2YVvuEYLnEzzZSlrWycJ969u4cKEXfHzOQtv8tkzHM1+
X-Gm-Gg: AYBFou3ihWLKkxB26dnmrfGeMhmghXvfsisUKQpFdEm0mm+JZnkzFEPDDHLBVDRYuro
	HioY9DQ7u7Wchj4Ue9N7zVBRT1pw0S1O0yttiAYj4ctj+5HolY4wAwznKSZ9PuEYVWEmuL/eq+7
	MvFvrZR8UbVvfZzu4+6fFFEGcZ+bGXu5WxWy3E9dY8o/N0ez0coYK8RyZZTab78bH/LFF2oUJCN
	/f2u5eNlItkI/ZKEnUIfM0eqZJHP1ontida3DxBP0RPY9+R8No6RWbmMIulFtaUofprDWQMCDWG
	DRIvauZVEgBzNf08SjpRmVudNNpliCQ8KWqGjY6SWNFv7ihky3w0hqC8g8a+FZWAAZnZ1o9dqFh
	4ODEll6SwV05waIxHi2qV5upEi75hQV7RTFGTvydWJpalVaAc4wZS5p1BY2IHVpUsT+HdweErxy
	m+CA6FM02eqNlV2iPmaCC+iDqeVZvb0xITXWbQBGI1jNHuCbSdDvO9pUZIg2rZ6OglpbqQLcXJ5
	er6cSR6gq4bV0BEZS+TZFXeWOlQ599LGICiSYkCofwlvlKofbq97PzOMHPahjjj0Tb03lAp+l5h
	/GGE/yRRfbXJOxgJWvyFk2Praw6l2bl+/iViuHUn4O2fKfg2ofkrgY+AtgCXA2j0GGpLVMnnWjn
	TOZzQM+B2GALUxi5QZ5Nu99BY7QLFztgvBMNQZE7k
X-Received: by 2002:a05:600c:4e11:b0:4a0:eae0:769a with SMTP id 5b1f17b1804b1-4ac185bc7d0mr48089815e9.28.1793363995962;
        Fri, 30 Oct 2026 05:39:55 -0700 (PDT)
Received: from meven-thinkpad.home (2a01cb088745e00090de407b41070a01.ipv6.abo.wanadoo.fr. [2a01:cb08:8745:e000:90de:407b:4107:a01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a4csm3088971f8f.23.2026.10.30.05.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:39:54 -0700 (PDT)
From: "=?UTF-8?q?M=C3=A9ven=20Car?=" <meven29@gmail.com>
X-Google-Original-From: =?UTF-8?q?M=C3=A9ven=20Car?= <meven@kde.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] io_uring: add support for utimensat
Date: Fri, 30 Oct 2026 13:39:44 +0100
Message-ID: <20261030123945.1704118-3-meven@kde.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030123945.1704118-1-meven@kde.org>
References: <20261030123945.1704118-1-meven@kde.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 951391C000E
X-Stat-Signature: efuksu6jiph93hxrfgydypttj1fwxfjt
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793363997-93303
X-HE-Meta: U2FsdGVkX1/rC/KmH36LEek9ed1HOMFrgxdJXh+USNiGNTjzvGbNQmnlCsAzip73jGqSUsktMOjf6g9P2feg3a6TWz0KtvW5G96nXjqachlW+9hPh7Hu8F3vXBFlYaqngxBLA0fwlvK8n7bNpnA7FhdfJtXntYSJcrI20cSkjdEeKVWmCFvkjCVouAS+R5lpP89XiySxQAYCY5BxOtA1OYzSGKlNZE04ZUjXLAu4u5DV/Esub6QVnd3bW54fxaP0CN2W/vh0e7NpVf5WNUB45KPSvjGPDz7PG8qEJMumPXAj+wfx+8NahYsODd2LPk2hGCS1FzXoqNMKd6/HTAj9kcIEPLGshsrdTwjK+kSB7GKTu2Lllq1DxkXKCPwRvZe0qTvFqSXJP93bE6Oe+knyFXFpYFgWk17OS9j8KvkTY/smk6dCznbcrMFM0Ii/OYQxVAbrOyMZoZN1Hfa7/8tF1kVkWgZ7wKP94t2RowOz5RI83EnAA5qzP/lPh03HuQlWqmP7WirfBYIyBSaWw2/YFTlEhrmqIBtP/v8rJc8SYiGsIrDlJUeea456MhjQ0WlPGEcmZMFnzC/IOxKbAUnn3OgGZoQOEYj5Znx0bMB8GOBhnQuY/nmXJmPqsmyUYPuQZNGg9YVSJbByPXyEZVDcOlFL8mmvehcGgr9k/6MDJsypEW+peWC5WaG/waZHkzPxlLjFkZxwSAE4JcJ97ycdFfiAhGx6An2IOvqc/xNrT+IfPsVV6TQb3FrV7gD3u6MX0YdB+xcMSnf8OCUT0AgnC1x53m4U75dgdPvGlKe+H8k8Zb08QZRKOcarbZv0nh2v7TPIgV95kT4Jp54WInIgBWjlubnBSkN0di5cK2yTDmVTnlElxzhbU28KSJ8XeAtKUSTlPVenqfgHrtR4WhkzYaoO5i8BgsiNcqi2pwgHaEuJO0CXZxNn0U/6ce7SqKa4QV7+/hxeDP3vUdW/HJ2
 4aXb7Xqz
 /MP4k1nDMlRaq51rEffUPlgPIMHh4UjS7WbNbp1HV9S7DyK+X0JxsZzqotnrCPlkKmA6ZrXtLSncoFuH8rlK1nA5jmg7oI4PACJKf9sBszspVPRFlweOUjreQC9EbipoY0HS+1d4Q1rIzohpiGLrVl84nooIv3pvw8w3cdq7AZc7DTxkBC1etkcfLd9OM+hu93K9wF2tbiO0KdlhpcVwe3OPZtaSYbh1VkCt/0gOWJmRJt26o7zi5n51IRYfOxI2VF176K02hFYZ5R5Inbbfkmi6p325p2SKH4Hekuo7vZea9uy5aLLX0dwieENi/n01cFoOwvZ1hmALCNAEHb9BVVRsE9JAyyF+f3Dctro6xNgeMpXsb3xdo5sobhh8Bx/K8GaQ8nvwII3XY2T/FZz/CPvI54idhDt8DZtTCp0kp4rxDry3iKPjO37Kt5Zv7J8FxkKnIwbkUJLmsfbauoHDR/DNaKAEbm4Uv7xae2zrX5fVPj6Yf0YgnywI7/bQYm3Jn8qcUrlVkf5LXBwKGJ/mWbNxqTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A program that copies many files sets the times of every copy after
its last write. On NFS and SMB each of those calls is a round trip to
the server, and with io_uring it is one of the steps of the copy that
still have to leave the ring and run one file at a time.

IORING_OP_UTIMENSAT behaves like utimensat(2). sqe->fd is the directory
fd, sqe->addr the path, sqe->addr2 a pointer to two struct
__kernel_timespec, and sqe->utimes_flags takes AT_SYMLINK_NOFOLLOW and
AT_EMPTY_PATH. An addr2 of zero sets both times to the current time, as
a NULL times argument does. The times and the path are copied at
submission.

As with utimensat(2), a NULL path sets the times of sqe->fd itself, and
two UTIME_OMIT times complete with 0 without a lookup. Unlike the
syscall, a NULL path or AT_EMPTY_PATH also works on an O_PATH
descriptor.

Like the other path ops, the request is issued from io-wq, apart from
the no-op, because the lookup and notify_change() can sleep. A fixed
file is not accepted as the directory fd. A failed request fails the
rest of its link.

Signed-off-by: Méven Car <meven@kde.org>
---
 include/uapi/linux/io_uring.h |  2 +
 io_uring/fs.c                 | 99 +++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  4 ++
 io_uring/opdef.c              |  8 +++
 4 files changed, 113 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b42b66b424a7..6a98c9282e0b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -76,6 +76,7 @@ struct io_uring_sqe {
 		__u32		install_fd_flags;
 		__u32		nop_flags;
 		__u32		pipe_flags;
+		__u32		utimes_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -319,6 +320,7 @@ enum io_uring_op {
 	IORING_OP_PIPE,
 	IORING_OP_NOP128,
 	IORING_OP_URING_CMD128,
+	IORING_OP_UTIMENSAT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/fs.c b/io_uring/fs.c
index 26ea841a22e7..85e0a1cb6b47 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -304,3 +304,102 @@ void io_link_cleanup(struct io_kiocb *req)
 	dismiss_delayed_filename(&sl->oldpath);
 	dismiss_delayed_filename(&sl->newpath);
 }
+
+/* Internal flags, above the AT_ flags of the SQE */
+#define IO_UTIMENSAT_NOOP	BIT(30)	/* both times UTIME_OMIT */
+#define IO_UTIMENSAT_NO_PATH	BIT(31)	/* NULL path: the dfd itself */
+
+struct io_utimensat {
+	struct file			*file;
+	int				dfd;
+	unsigned int			flags;
+	struct delayed_filename		filename;
+	/* NULL sets both times to the current time */
+	struct timespec64		*times;
+	struct timespec64		ts[2];
+};
+
+int io_utimensat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_utimensat *ut = io_kiocb_to_cmd(req, struct io_utimensat);
+	struct __kernel_timespec __user *uts;
+	const char __user *fname;
+	int err;
+
+	if (sqe->len || sqe->buf_index || sqe->splice_fd_in || sqe->addr3 ||
+	    sqe->__pad2[0])
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	ut->dfd = READ_ONCE(sqe->fd);
+	ut->flags = READ_ONCE(sqe->utimes_flags);
+	if (ut->flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
+		return -EINVAL;
+
+	uts = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	ut->times = NULL;
+	if (uts) {
+		if (get_timespec64(&ut->ts[0], &uts[0]) ||
+		    get_timespec64(&ut->ts[1], &uts[1]))
+			return -EFAULT;
+		ut->times = ut->ts;
+		if (ut->ts[0].tv_nsec == UTIME_OMIT &&
+		    ut->ts[1].tv_nsec == UTIME_OMIT) {
+			ut->flags |= IO_UTIMENSAT_NOOP;
+			return 0;
+		}
+	}
+
+	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	if (!fname) {
+		if (ut->dfd == AT_FDCWD)
+			return -EFAULT;
+		ut->flags |= IO_UTIMENSAT_NO_PATH;
+		goto out;
+	}
+	err = delayed_getname_uflags(&ut->filename, fname, ut->flags);
+	if (unlikely(err))
+		return err;
+	req->flags |= REQ_F_NEED_CLEANUP;
+out:
+	req->flags |= REQ_F_FORCE_ASYNC;
+	return 0;
+}
+
+static int __io_utimensat(struct io_utimensat *ut, struct filename *name)
+{
+	int flags = ut->flags & (AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
+
+	return filename_utimensat(ut->dfd, name, ut->times, flags);
+}
+
+int io_utimensat(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_utimensat *ut = io_kiocb_to_cmd(req, struct io_utimensat);
+	int ret = 0;
+
+	WARN_ON_ONCE((issue_flags & IO_URING_F_NONBLOCK) &&
+		     !(ut->flags & IO_UTIMENSAT_NOOP));
+
+	if (ut->flags & IO_UTIMENSAT_NO_PATH) {
+		CLASS(filename_kernel, name)("");
+		ret = __io_utimensat(ut, name);
+	} else if (!(ut->flags & IO_UTIMENSAT_NOOP)) {
+		CLASS(filename_complete_delayed, name)(&ut->filename);
+		ret = __io_utimensat(ut, name);
+	}
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
+
+void io_utimensat_cleanup(struct io_kiocb *req)
+{
+	struct io_utimensat *ut = io_kiocb_to_cmd(req, struct io_utimensat);
+
+	dismiss_delayed_filename(&ut->filename);
+}
diff --git a/io_uring/fs.h b/io_uring/fs.h
index 0bb5efe3d6bb..2812dc3b4b2f 100644
--- a/io_uring/fs.h
+++ b/io_uring/fs.h
@@ -18,3 +18,7 @@ int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags);
 int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_linkat(struct io_kiocb *req, unsigned int issue_flags);
 void io_link_cleanup(struct io_kiocb *req);
+
+int io_utimensat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_utimensat(struct io_kiocb *req, unsigned int issue_flags);
+void io_utimensat_cleanup(struct io_kiocb *req);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index cf3aa2242cd7..383a9b9d1df4 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -591,6 +591,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
+	[IORING_OP_UTIMENSAT] = {
+		.prep			= io_utimensat_prep,
+		.issue			= io_utimensat,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -849,6 +853,10 @@ const struct io_cold_def io_cold_defs[] = {
 		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
+	[IORING_OP_UTIMENSAT] = {
+		.name			= "UTIMENSAT",
+		.cleanup		= io_utimensat_cleanup,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
-- 
2.56.0


