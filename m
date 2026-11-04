Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08F1606A335
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vEDRjb2S
Received: by kanga.kvack.org (Postfix)
	id 9AB146B05B3; Wed,  4 Nov 2026 06:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9826A6B05B4; Wed,  4 Nov 2026 06:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871216B05B5; Wed,  4 Nov 2026 06:06:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60D366B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:06:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2E6C1A0694
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:06:24 +0000 (UTC)
X-FDA: 85397157888.09.5D2CB86
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 31E8BC0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:06:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vEDRjb2S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of meven29@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=meven29@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pLpVK+i/8Imxqr3Xov4ssSifbUYKBHJ4bTvS4h1ZT4=;
	b=nSfiOjt+CkPVkLVmd4hs2BmOq8h4vOoMeU0kYt2NcdhNreBbKtXgsW1aSv2oNmnSAdFQDz
	Og8k8PZzGoVFk8CckjHy62AG+V6Es0BSomqO3HJhr2b2BZJVkczda2qn1rE3qkV0k7eL5r
	QQCCxkOsk8EkhDfmDKuZ+k2ScCtrdxw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vEDRjb2S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of meven29@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=meven29@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790383;
	b=aNCoMaTTdJH4sAYDVaXO+S2/6nn+yCTRQb5c4YjFbWJXioopS2d/+/OY8wxXytGye8Jrkt
	DlyItFUVBoDIxKZGOQX8oic424rliEHcyGhQ7erzE0K01E/ScmpaNOOzrKfT9RIxo5Uss6
	AH0LWNvUGDu9mWKDtW7t8ZSVX9unVkk=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c45111bebso256980f8f.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 03:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793790382; x=1794395182; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5pLpVK+i/8Imxqr3Xov4ssSifbUYKBHJ4bTvS4h1ZT4=;
        b=vEDRjb2S0gklrqK8jxunWoUmUIP/lk883mcnnqiP7oRMiiVhJ6at9YyZqT8a7g2Cx9
         enHlZQwcWdQVcv/D1DiUs5/jEhMJVsIquLLyGG8dtVvauN+dBmsLiF55kJ9xgHf+M+jJ
         ONeorrjMzVW47eDBRWqowhF2qud/obAjtMm4SlM+y8+deZWXT5ww+DAlfSgv7ixWzEsT
         wWzkYtYD4HJuTTRhTQxi1zbOnVRBw47VfjB7Idp96daEwujXwilMXeXExhqK3V0zs6l8
         hQOV8y5cM5zC9oexAqRYdQ0ZxYSxoMLNz6spXj++lCI3QOpn22Yb/81/N//G707jg27V
         35vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793790382; x=1794395182;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5pLpVK+i/8Imxqr3Xov4ssSifbUYKBHJ4bTvS4h1ZT4=;
        b=PWaSH/NyAZX+cUK49544aETvYYfYrDqDB41QkpY8fej5O5goxK5K5BCUye9j2h02ey
         n7oWkmfVdodmn+Bak/s22DDL3Vr4oVyqVD+swXYZeb39S0Ekm+PvzQrgFplymnGsi/Cf
         ITnbsxJNNcgRPrlDstaMU3GHjcJnkfl0kcIFERXvO64JRDkcUs7BmuuSxOqnhfSGsxzY
         17durvU2hFnC/O/CpU9pc6UqcP5K/8xKqED4dEm6SRQnfVudQMmxgG6K0zt3fWak33UV
         zA8SRyNApwu+9yNL8srk+zBK5vAeGIFfe/p+uifUrVwC/miHNEVxIX2V9b/0+6OU+tg4
         dc7w==
X-Forwarded-Encrypted: i=1; AKwUvBy2H71pbYmSiy3n3oNiNnsqLzT/a8GLHJOruVIp+3L5ZHB0vgGMSH8ReCw+eaNwDAVYcaexAxduww==@kvack.org
X-Gm-Message-State: APuU4Z/CRaLK2MXrR8irCiZuUJ/OcWhMdsLxC61kwBPPdOjJKtOhZ7oP
	iLDoahB1z84zMIfaYfruTl9E/NZPy1qeortfKsSG+qTk/uFUVSJMjklN
X-Gm-Gg: AYBFou0fu7aoW0hBmzSZKVxqPP9vbb4kXwSzCfA8Xvn6XNElMnc0JAcsB++CUZEw6pr
	WasaFrU5RuTv43fPQuE2drKuvOdeRD45LOyUx5RbBlpb0vLG3PV72p6I1UXixExcQFHfxsRnh9S
	MPn6VXdVf9Z3PUvx2mHVTtMzCqhuJnEmBGllLTqopfqdvc7xjTnuRkf+QmLPW50zXJLXuYteaIy
	El7gPvGHe7xh8U4JXzZ6Qcz6zpF4zxgFn5MtnE83L6S77Qa8F8DWlna6c3RN95JhswVk7VoPSub
	6s/SXMkeFAXnlfL02u2IXyiHKnkpewoYmNPe0ldUvq8xdST4aK6hfR+be7Y21AtpdD0vbzkTOWO
	0xGqmarVCm10LmpoH/z+sV2sw2n7VYUp0a721MCIg0bxTpJdJAWcs9bx5rBLWO7HS3vTD7y9v3t
	jBd2JSl8hOtYZ/DS1autbP4Jx8XB0e4zoa/d48IGIvyAHl7U/0Vxnp23dBHYaLhop4aMcsRCdZa
	SagNXk3pfGhvHYjX2pJBqSSJHJEnDJ1KRQ4ME7r6naCJO9mG8qe2vdY44Cop6fkB1FzUqz/OdUq
	D6e44SIbhNY5jisk+rT81co8ovScAgUt3YG+75YUT2hKAmqftFUI0GByal1V/aQXaPfNuVVHwSe
	9RWIJprRH6dCYFhBEl/g48qyk
X-Received: by 2002:a05:6000:24c5:b0:48e:d7c:4bc8 with SMTP id ffacd0b85a97d-48e6e2bdddbmr38014500f8f.7.1793790381656;
        Wed, 04 Nov 2026 03:06:21 -0800 (PST)
Received: from meven-thinkpad.home (2a01cb088745e00090de407b41070a01.ipv6.abo.wanadoo.fr. [2a01:cb08:8745:e000:90de:407b:4107:a01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed92a753sm3704835f8f.45.2026.11.04.03.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:06:21 -0800 (PST)
From: =?UTF-8?q?M=C3=A9ven=20Car?= <meven29@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?M=C3=A9ven=20Car?= <meven@kde.org>
Subject: [RFC PATCH v2 2/3] io_uring: add support for utimensat
Date: Wed,  4 Nov 2026 12:06:03 +0100
Message-ID: <20261104110604.126717-3-meven29@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104110604.126717-1-meven29@gmail.com>
References: <20261104110604.126717-1-meven29@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 31E8BC0003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: aan38cm7ngj7i5mcigfoap1jrsrunwhw
X-HE-Tag: 1793790383-514915
X-HE-Meta: U2FsdGVkX18gp+afT1l+2nCxeNYDWF2DZfpqB6eKQlZ7fmkr2hAD6UE0vxlgiZTMuizTwiNeoTCII9DV2IJOXd0o7Eo+8zwSikNkzBEkLGcH8MOtg9/Yrl2tmO4ZwhKcxEP2DUL+VFqs6o0eTnbStW4M/K9fDGSr4Kdj4WMicqta8shOWjl3s4xKy9j775Fw9/XtA9PSGEnJW0A23bcdDFiHesU5Rf0B5hpoJgcB5tLOMDyM/mYpBcUrjN/iYOaCGZ9P1t76ExH52WSfqZzCui4/d5V68PCT2mL1lvJl9G00jwY/h/OmBIdQMPHug8NCWDMrSV3sWmI5PHaRWB1C9W2fMxdwWY8WYpcmqFOjtw5ixiXQvE/x8EshClBFx7CaOIgecE3T/s5pth1T63E1edENTAFfQ1QgOaqPLLELgETl8jGXkIXbDhyyd6jWgX4rFsUxugvuxCLw8kq6yjTdAn6QbuWh/KbL4sMBeYp1JSmwoWbY9IYXaTSIdvD83KRVpfgSY/20Oodt4f7Y8V8vHY6di57UH2VjRuBeVFWA7J8pez3X8FzAolPNhQ7XMphZ4zfvHYLELyHvj1suVqppRe3EA0kaHeU3nrypws9VurPRtEdQnd0jE6MEB8RcGeSgdaJLNapr2RsIA5G21yBm75jdwYRDY0y7MPpxjTTqb2D106S+CuXNs74svgP6dBiz24nO1gtV+aEDVQAEZvda2Zud3tNPr92bLvv6S0bN5hsIwN9qI+41QRMKh4Nt0qxLIjq685ChzHBG5UVIc+6WEqV/zhoRWgDHW7NHSoGJ4NU9myRSTwEgopSavZomlR3U46ox2lbFZvi63LPl0U0mW8o7eDo+yrYrD7N4X8dPk9wUge2sFqVgV6ApdnlK8pwu2Pugah8JW9ob1YioIhiWTxysneVYC66lV4PzyacGR8SCyC5H9It1zXbXBhtM9WyS/fVC0NVCXgLcZIE4yO4
 RKQGobrw
 n43Ywbd3LyAhotWfyxVdlTe/OHckgv6myEI0TngZVU1EMrWeS7JRq7ejoD4KaqYyGSq5O2lAVms43unHcVcXxv0YO+wk6ioCJ9hYB3qI1zdMCBvGGm+HBlCU2AQYiY/vHaK8r15dPLXkbZjljhapV/Ey3BDj5Zq6lBQaCSTGVT+qu+HhmTXh57TRbeUFjX2FdOfuqjSIay/w1rDtDnjC3gI2hDPZeAdcmu+bA0P6qr+S2G6UhipOaXGhKpu+s018eaz6VB+puVTWMK+vktjo1N8Z7bP+zi4UywebHvfdra4I2+8wmm1fJxWD1OfpRiEqFRWSHiamNqBhcPu/+FF9R4QMqtzh/XGVvThHcbrm8I1rvL1Q6j+yJXm9I9TQbSVJy2zOqpfQ8npc8KYtafGcthIm4WR/rYZba0WxMVK5uz55PYGi5JQMbRc0SRXcoXD+uo839xuk5GjnbvWshzzYsDs4++Hn8kmfPtqGZ2hxgopu9ElCexAs+VrNnfJMoxCeMrE1ftlv0MsNmqUYf8UzHWEWddTaj20WCnmN9o0zH0K8eJR0rErfL9xIrJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Méven Car <meven@kde.org>

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

As with utimensat(2), a NULL path sets the times of the file that
sqe->fd refers to, without a lookup, and takes no flags. Two UTIME_OMIT
times complete with 0 without a lookup.

Like the other path ops, the request is issued from io-wq, apart from
the no-op, because the lookup and notify_change() can sleep. A fixed
file is not accepted as the directory fd. A failed request fails the
rest of its link.

Signed-off-by: Méven Car <meven@kde.org>
---
 include/uapi/linux/io_uring.h |  2 +
 io_uring/fs.c                 | 97 +++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  4 ++
 io_uring/opdef.c              |  8 +++
 4 files changed, 111 insertions(+)

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
index 26ea841a22e7..71164bddd958 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -304,3 +304,100 @@ void io_link_cleanup(struct io_kiocb *req)
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
+		if (ut->flags)
+			return -EINVAL;
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
+int io_utimensat(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_utimensat *ut = io_kiocb_to_cmd(req, struct io_utimensat);
+	int ret = 0;
+
+	WARN_ON_ONCE((issue_flags & IO_URING_F_NONBLOCK) &&
+		     !(ut->flags & IO_UTIMENSAT_NOOP));
+
+	if (ut->flags & IO_UTIMENSAT_NO_PATH) {
+		CLASS(fd, f)(ut->dfd);
+
+		ret = -EBADF;
+		if (!fd_empty(f))
+			ret = vfs_utimes(&fd_file(f)->f_path, ut->times);
+	} else if (!(ut->flags & IO_UTIMENSAT_NOOP)) {
+		CLASS(filename_complete_delayed, name)(&ut->filename);
+		ret = filename_utimensat(ut->dfd, name, ut->times, ut->flags);
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


