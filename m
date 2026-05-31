Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6664FCD6E4C
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 01:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFABB6B00D4; Sat, 30 May 2026 21:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD16C6B00D6; Sat, 30 May 2026 21:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9026B00D7; Sat, 30 May 2026 21:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFAF6B00D4
	for <linux-mm@kvack.org>; Sat, 30 May 2026 21:02:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D53F8DCAC
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:02:46 +0000 (UTC)
X-FDA: 84825915132.23.5C8093B
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7A62F4000D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:02:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E7Xi2wGb;
	spf=pass (imf07.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780189364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rY9xqu8l7Va76QXZ+E4mFY8QOJNQ9i1JD1YVgseayQc=;
	b=vaq7fPgS4nyezwiDJ/7HbiCW1tJ/lYgboSPy+yU5uyBbi0Bf595M8H6bG16dJT14jLp6h3
	5UEeHyEpT1ETdZhSm++GaeIotIexHoeOxGyHYkpIsYzjJuMWDzAvvwsedEVU29AJreKdym
	tN1VaxGbCakzOcTlYDTkFits6MI4agE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780189364; a=rsa-sha256;
	cv=none;
	b=payeD1gM7WCbLq11iAy+iniBdXeAe8RlfRNA76dS2wCxAVAN5/gQkSQRfXbkyotmYkfB1p
	Mr/gFvz8MCBxHmTpnKWw07WtzF9q/E0IPQyzpU0mpMYs4uZ0AMABKPmZ4I2BSHbQRYpDJU
	xQpKm1hf8d9uWnBtRdtqX5a0NzGx0yQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E7Xi2wGb;
	spf=pass (imf07.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490a7876f8cso1432865e9.3
        for <linux-mm@kvack.org>; Sat, 30 May 2026 18:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780189363; x=1780794163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rY9xqu8l7Va76QXZ+E4mFY8QOJNQ9i1JD1YVgseayQc=;
        b=E7Xi2wGbDJzgWARJ4g8DvzYZBy+rM6BR/YncoqSyERMKQcBBDtZig/jBLpKX7jgL0l
         8kG6QwM5LpVMIaAh0NlqWkNalpE7f2nDGcGzlGqRGkUjX7N14mXrEfaBEdtzqeaykyr7
         5r9LcMQ5Q5+6cThBTkd4VaraLFgfFcyXDrhK/I5ndiTerFe0Rm0nMwKvkbT5/yH5Dz8P
         vGimBFgOoOUJeIPJIibZwjWu7JwyHXn5gVUR2u+pKfE7uWTFP3UCo+43R5xRBKpp6tuw
         c6xrx7H2FRwtvX+JDmxBz/qg0lf8gaa9E8iqsTCTdVNTSjlKBlTRJHKpvXNx98n4Ka/Z
         xEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780189363; x=1780794163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rY9xqu8l7Va76QXZ+E4mFY8QOJNQ9i1JD1YVgseayQc=;
        b=kMi3ugB2AqxZEvTc8MR9xHys8NlAh9vcOPMnpP9fAs1tzITUONVOimx3dwx8Y5+xIR
         tQqk+aebDG3cvmQrL71c2BP+XX5xSmOw79vFYeCrR8kIpEUrnW3X0WFNoWCA8XGChN3Q
         qJw0hXqQwk8zZwx+bukubMxgG4Gyh5LUggm6BsD8skY+pO22lVxHY09clKGbIbGqEfxI
         f3B1ngOLMu3jDhNvCqKUFSWjtTS0LTIUQxzYMf80IBEiJcmzC+CbEXZLmYl7Vj/XgndR
         zAjJpAK4K1DIy/Y0HM3eRl67t4AWNypjTDPKtdk4jq7T2kYETMBDSyJNYzwwhqyWcfbM
         D/Ow==
X-Forwarded-Encrypted: i=1; AFNElJ+/LjfkbXu0CyqardGXayzFDkpwbSVpWGGoIGuDOXXVxpia02oZPVTukVWbTomMjFAfD2lmnG9+oQ==@kvack.org
X-Gm-Message-State: AOJu0Yzugf+sQoH2dFopVIEa4OdykKBYQrw2ec8shnPR0Rk6ddpd/X0D
	mNlgOyTF4NsPOBqAQZ0Wu1pUKiREPJeqTubhBHeusEVpc7lmCBGLjKNg
X-Gm-Gg: Acq92OHJGHLve3IJc3k5AKs3vQQXnrepIkZDXh9C9N4SF5G3tIgKGWZ6AVDhKAJdQCU
	yjN2FmLkmua0nK0lYKxa1/Qbu7Gt+MjaaBSzv+2bRHlLBOT/YwX+tNFEa+cxpadq5YRFbKVCrBq
	PUMJGbbW1rEvnZK3nIp0worutHgwX12ILW2Gfn25zve0MkJNUDcdVf9/vZmDRkrRNz3pZ/ArbXu
	m07jNLitLdpZ6ECjXb9bCUaUboNlxNRMNU3rZy8k5sQr/Zp8bBjdSZLp7TKPjqLGDRnVKLgIDtA
	K0spH+eHTuqzybUl76MrTVspb003iXWXiwmHz/0Bjh0Cbm3gSIfDDpi4kukgWq80bQw19Vc8w8y
	Koga4h50YUEhUFkZgJFoBQNGvns5HL2HH9y8PQibJwzHvqQFsLh6p/ZLCVwIG+k2CRUJe0J20MY
	uC/o8fZTuPpnZYl6w67WbHCpuh0QHnrmxlcP47gUQ0
X-Received: by 2002:a05:600d:844a:10b0:48a:5565:ec3d with SMTP id 5b1f17b1804b1-490a294935bmr71684235e9.22.1780189362730;
        Sat, 30 May 2026 18:02:42 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4909d68a925sm219356085e9.2.2026.05.30.18.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 18:02:42 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	patches@lists.linux.dev
Subject: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Sun, 31 May 2026 01:01:06 +0000
Message-ID: <20260531010107.1953702-3-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 1s4xke3jf71886dr1qobautjutu3h1m8
X-Rspamd-Queue-Id: 7A62F4000D
X-Rspam-User: 
X-HE-Tag: 1780189364-776392
X-HE-Meta: U2FsdGVkX19cDNXfU4Zxs1Pc8uk+TjtwuxPlaOLYEzSanGwZZv2LrivXpJhw7845vtvws4EGC8m3fisZczBNVHr4Vh4Yj6RE56C0JiKDj3Yyv3DV0ySDysrI8vKHk6FbASb5DNomgZeYjF8Ma/gY2HjQBeOKP4l8uhC8Jj7ULmTLrQEPLcsP2+RKO2ZIw8BqChfPnwqJ97Ft96LyVdluBCHyIOfyjnTFm/2NTZr36tXdZQlPBXeL377eEjglP4cWQTD9w8VmGcr8Ryk01ikDTk+mg78qM5Euey3q6/yD1KyU8o2bzCk7ykJvCwUPJA/npEDAfx3DQIs/xp093LobEsI1hww+v4hmUMZYhjMNrxIFUTPpKEUG84sgC5WxldMUr6Bk+bUV/8/OqrzHYy+6jxoaQ7m36XsJufJwYMHbPH/rBuogt/Xh8hyYq2BVvm2L2x3CYanJ1TGPIZ10CRojdwL5xRluG7NQsVZbURdmB5VhOMdakRat1e+9X8EniEhhH5StuXK053DPP0wI7ZJdFQIh0N0e5HXKSmSxJwmrtRppy3isQ9I9ectt+p2SsEpByxEcGjTRgUXXtwWAEMH7nkX+CS1WmXeVIIWVWZ0FIUCOqTYE11lKmM5pNum3LfZllDICojOkDZJnxuFv1k0NwY1K3rfXewwU0obg6KBAouHSI80d78v0PY50mDepbBSSb1aoMR6hcYa0nbJFaQigApY899ITHi+3XcNlhgsvQIZgFAnjEH/7/mxg6P+Bbd4xfwOwoOfJMXrh3Ui5lX1vqxHjbHv9xRyvAosnGPmwYNl6db/tQa4rFyejNF8dAcL9zWlctRdy94zychOk9bvI8V9N9TmyawKABAS9oEXd6ByhM6xmO3k46KItt2GTqeZNsPFeoG7eUmGhYB0e/kHbURWQHmTFgIKBtaVkYXQiVuviw4hMvju6024spmB+GiRUM4lM5tQFtRRk3QsbS2F
 HIUtf5hU
 YKDnUZr5AHO0ykyNWAOFH4BQJXVjQTVxLPceRQAsi+uc0wKpRI4H8WprWPWivy16Ick409AXZW0kUjqlN7Dh0n1CsAQziUI81I6xOYzBca2LxFEHvNmK+bklHI8/rkbWrfJZMWGgK6UaxA3++O/4J6M0i9Co/yF9Tl9THvafsPSL8SEhaV4jukJFg2EtDV1R1doPrRKoL7lg/nRsjIBiVldQTmxGiMBCgnxpOTwMqPjxwpV/zQ8kBd8BOI0IglJ82rJ7nR74M6UX9XCH/w3NAsW9TdtAjC6dCaZ3ZBUOKyi3e6jDX1tqX5FMbGm4nvMYAnauEWiJQ1jk9jucSNRveFfEjLgNaXizsdsGWPiVGB3ydMT05tb6w4hS1biP2PHji+JQ8ryM8Plz02EbN0IjWz5W+ShfQ+0ZfovX9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmsplice behavior on writable pipe became equivalent to pwritev2.
vmsplice behavior on readable pipe already was nearly
equivalent to preadv2, but I made this explicit. I. e. I made it
obvious from code that vmsplice now is equivalent to preadv2/pwritev2.

Also I moved vmsplice to fs/read_write.c, because now it arguably
belongs there.

Note that SPLICE_F_NONBLOCK behavior slightly changed: previously
vmsplice ignored whether the pipe was opened with O_NONBLOCK, and mode
of operation depended on whether SPLICE_F_NONBLOCK was passed only.
Now the operation will be non-blocking if O_NONBLOCK was passed when
opening *or* SPLICE_F_NONBLOCK was passed to vmsplice. Previous
behavior was arguably buggy, and new behavior is arguably better.

Now SPLICE_F_GIFT is always ignored by all 3 syscalls: splice, tee
and vmsplice.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c          |  23 +++++
 fs/splice.c              | 192 +--------------------------------------
 include/linux/skbuff.h   |   4 +-
 include/linux/splice.h   |   2 +-
 include/linux/syscalls.h |   4 +-
 5 files changed, 29 insertions(+), 196 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 50bff7edc91f..1e5444f4dab3 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1213,6 +1213,29 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 	return do_pwritev(fd, vec, vlen, pos, flags);
 }
 
+/*
+ * Legacy preadv2/pwritev2 wrapper.
+ */
+SYSCALL_DEFINE4(vmsplice, unsigned long, fd, const struct iovec __user *, vec,
+		unsigned long, vlen, unsigned int, flags)
+{
+	if (unlikely(flags & ~SPLICE_F_ALL))
+		return -EINVAL;
+
+	CLASS(fd, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	/* We do do_writev/do_readv, so it is okay to pass "false" here */
+	if (!get_pipe_info(fd_file(f), /* for_splice = */ false))
+		return -EBADF;
+
+	if (fd_file(f)->f_mode & FMODE_WRITE)
+		return do_writev(fd, vec, vlen, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+	else
+		return do_readv(fd, vec, vlen, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+}
+
 /*
  * Various compat syscalls.  Note that they all pretend to take a native
  * iovec - import_iovec will properly treat those as compat_iovecs based on
diff --git a/fs/splice.c b/fs/splice.c
index 59adbc2fa4d6..b1a4e3713bd6 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -159,22 +159,6 @@ const struct pipe_buf_operations page_cache_pipe_buf_ops = {
 	.get		= generic_pipe_buf_get,
 };
 
-static bool user_page_pipe_buf_try_steal(struct pipe_inode_info *pipe,
-		struct pipe_buffer *buf)
-{
-	if (!(buf->flags & PIPE_BUF_FLAG_GIFT))
-		return false;
-
-	buf->flags |= PIPE_BUF_FLAG_LRU;
-	return generic_pipe_buf_try_steal(pipe, buf);
-}
-
-static const struct pipe_buf_operations user_page_pipe_buf_ops = {
-	.release	= page_cache_pipe_buf_release,
-	.try_steal	= user_page_pipe_buf_try_steal,
-	.get		= generic_pipe_buf_get,
-};
-
 static void wakeup_pipe_readers(struct pipe_inode_info *pipe)
 {
 	smp_mb();
@@ -589,8 +573,7 @@ static void splice_from_pipe_end(struct pipe_inode_info *pipe, struct splice_des
  * Description:
  *    This function does little more than loop over the pipe and call
  *    @actor to do the actual moving of a single struct pipe_buffer to
- *    the desired destination. See pipe_to_file, pipe_to_sendmsg, or
- *    pipe_to_user.
+ *    the desired destination. See pipe_to_file or pipe_to_sendmsg.
  *
  */
 ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
@@ -1440,179 +1423,6 @@ static ssize_t __do_splice(struct file *in, loff_t __user *off_in,
 	return ret;
 }
 
-static ssize_t iter_to_pipe(struct iov_iter *from,
-			    struct pipe_inode_info *pipe,
-			    unsigned int flags)
-{
-	struct pipe_buffer buf = {
-		.ops = &user_page_pipe_buf_ops,
-		.flags = flags
-	};
-	size_t total = 0;
-	ssize_t ret = 0;
-
-	while (iov_iter_count(from)) {
-		struct page *pages[16];
-		ssize_t left;
-		size_t start;
-		int i, n;
-
-		left = iov_iter_get_pages2(from, pages, ~0UL, 16, &start);
-		if (left <= 0) {
-			ret = left;
-			break;
-		}
-
-		n = DIV_ROUND_UP(left + start, PAGE_SIZE);
-		for (i = 0; i < n; i++) {
-			int size = umin(left, PAGE_SIZE - start);
-
-			buf.page = pages[i];
-			buf.offset = start;
-			buf.len = size;
-			ret = add_to_pipe(pipe, &buf);
-			if (unlikely(ret < 0)) {
-				iov_iter_revert(from, left);
-				// this one got dropped by add_to_pipe()
-				while (++i < n)
-					put_page(pages[i]);
-				goto out;
-			}
-			total += ret;
-			left -= size;
-			start = 0;
-		}
-	}
-out:
-	return total ? total : ret;
-}
-
-static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
-			struct splice_desc *sd)
-{
-	int n = copy_page_to_iter(buf->page, buf->offset, sd->len, sd->u.data);
-	return n == sd->len ? n : -EFAULT;
-}
-
-/*
- * For lack of a better implementation, implement vmsplice() to userspace
- * as a simple copy of the pipe's pages to the user iov.
- */
-static ssize_t vmsplice_to_user(struct file *file, struct iov_iter *iter,
-				unsigned int flags)
-{
-	struct pipe_inode_info *pipe = get_pipe_info(file, true);
-	struct splice_desc sd = {
-		.total_len = iov_iter_count(iter),
-		.flags = flags,
-		.u.data = iter
-	};
-	ssize_t ret = 0;
-
-	if (!pipe)
-		return -EBADF;
-
-	pipe_clear_nowait(file);
-
-	if (sd.total_len) {
-		pipe_lock(pipe);
-		ret = __splice_from_pipe(pipe, &sd, pipe_to_user);
-		pipe_unlock(pipe);
-	}
-
-	if (ret > 0)
-		fsnotify_access(file);
-
-	return ret;
-}
-
-/*
- * vmsplice splices a user address range into a pipe. It can be thought of
- * as splice-from-memory, where the regular splice is splice-from-file (or
- * to file). In both cases the output is a pipe, naturally.
- */
-static ssize_t vmsplice_to_pipe(struct file *file, struct iov_iter *iter,
-				unsigned int flags)
-{
-	struct pipe_inode_info *pipe;
-	ssize_t ret = 0;
-	unsigned buf_flag = 0;
-
-	if (flags & SPLICE_F_GIFT)
-		buf_flag = PIPE_BUF_FLAG_GIFT;
-
-	pipe = get_pipe_info(file, true);
-	if (!pipe)
-		return -EBADF;
-
-	pipe_clear_nowait(file);
-
-	pipe_lock(pipe);
-	ret = wait_for_space(pipe, flags);
-	if (!ret)
-		ret = iter_to_pipe(iter, pipe, buf_flag);
-	pipe_unlock(pipe);
-	if (ret > 0) {
-		wakeup_pipe_readers(pipe);
-		fsnotify_modify(file);
-	}
-	return ret;
-}
-
-/*
- * Note that vmsplice only really supports true splicing _from_ user memory
- * to a pipe, not the other way around. Splicing from user memory is a simple
- * operation that can be supported without any funky alignment restrictions
- * or nasty vm tricks. We simply map in the user memory and fill them into
- * a pipe. The reverse isn't quite as easy, though. There are two possible
- * solutions for that:
- *
- *	- memcpy() the data internally, at which point we might as well just
- *	  do a regular read() on the buffer anyway.
- *	- Lots of nasty vm tricks, that are neither fast nor flexible (it
- *	  has restriction limitations on both ends of the pipe).
- *
- * Currently we punt and implement it as a normal copy, see pipe_to_user().
- *
- */
-SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
-		unsigned long, nr_segs, unsigned int, flags)
-{
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	struct iov_iter iter;
-	ssize_t error;
-	int type;
-
-	if (unlikely(flags & ~SPLICE_F_ALL))
-		return -EINVAL;
-
-	CLASS(fd, f)(fd);
-	if (fd_empty(f))
-		return -EBADF;
-	if (fd_file(f)->f_mode & FMODE_WRITE)
-		type = ITER_SOURCE;
-	else if (fd_file(f)->f_mode & FMODE_READ)
-		type = ITER_DEST;
-	else
-		return -EBADF;
-
-	error = import_iovec(type, uiov, nr_segs,
-			     ARRAY_SIZE(iovstack), &iov, &iter);
-	if (error < 0)
-		return error;
-
-	if (!iov_iter_count(&iter))
-		error = 0;
-	else if (type == ITER_SOURCE)
-		error = vmsplice_to_pipe(fd_file(f), &iter, flags);
-	else
-		error = vmsplice_to_user(fd_file(f), &iter, flags);
-
-	kfree(iov);
-	return error;
-}
-
 SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
 		int, fd_out, loff_t __user *, off_out,
 		size_t, len, unsigned int, flags)
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2bcf78a4de7b..2961fee3e5cc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -505,7 +505,7 @@ enum {
 	SKBFL_ZEROCOPY_ENABLE = BIT(0),
 
 	/* This indicates at least one fragment might be overwritten
-	 * (as in vmsplice(), sendfile() ...)
+	 * (as in sendfile(), ...)
 	 * If we need to compute a TX checksum, we'll need to copy
 	 * all frags to avoid possible bad checksum
 	 */
@@ -4017,7 +4017,7 @@ static inline int skb_linearize(struct sk_buff *skb)
  * @skb: buffer to test
  *
  * Return: true if the skb has at least one frag that might be modified
- * by an external entity (as in vmsplice()/sendfile())
+ * by an external entity (as in sendfile())
  */
 static inline bool skb_has_shared_frag(const struct sk_buff *skb)
 {
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 9dec4861d09f..fb4f035aae83 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -19,7 +19,7 @@
 				 /* we may still block on the fd we splice */
 				 /* from/to, of course */
 #define SPLICE_F_MORE	(0x04)	/* expect more data */
-#define SPLICE_F_GIFT	(0x08)	/* pages passed in are a gift */
+#define SPLICE_F_GIFT	(0x08)	/* ignored */
 
 #define SPLICE_F_ALL (SPLICE_F_MOVE|SPLICE_F_NONBLOCK|SPLICE_F_MORE|SPLICE_F_GIFT)
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f5639d5ac331..a86a88207956 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -514,8 +514,8 @@ asmlinkage long sys_ppoll_time32(struct pollfd __user *, unsigned int,
 			  struct old_timespec32 __user *, const sigset_t __user *,
 			  size_t);
 asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
-asmlinkage long sys_vmsplice(int fd, const struct iovec __user *iov,
-			     unsigned long nr_segs, unsigned int flags);
+asmlinkage long sys_vmsplice(unsigned long fd, const struct iovec __user *vec,
+			     unsigned long vlen, unsigned int flags);
 asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
 			   int fd_out, loff_t __user *off_out,
 			   size_t len, unsigned int flags);
-- 
2.47.3


