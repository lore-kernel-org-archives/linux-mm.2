Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D68CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3982B6B0092; Thu, 25 Jun 2026 04:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321936B0093; Thu, 25 Jun 2026 04:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC076B0095; Thu, 25 Jun 2026 04:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E70DD6B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:35:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 673381205D0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:35:16 +0000 (UTC)
X-FDA: 84917775432.29.1A79211
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 836E84000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:35:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dtfI1faJ;
	spf=pass (imf01.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376514;
	b=yxmDInI3VQ/rvaV/41a8JHCdkKoI+Zk+ZQDBSQ3tK4lmeGlNt6X8x5girNXvkgTfNtcy5I
	lvfySoHdzI2eMMjWfQNBJbiaS5ovcwGmvpbExlGv6iWqZ6CAH2qa88sQuaIVVW1la85wc3
	jiYq5IOdZtxwAXCZfvtm1UOJe6C7omA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
	b=HJMxaFvGy5JMjI0+6aqWHzUVvJsDJ5+21BgvI0MrLeV2ivigol3men7imF4t+V5ebSni26
	qdnRDeUGKO1HyZY2APCP34KVlWJqcokMRmwhReJVs0j6M+2KIwxg7DOOmd+9FUiERdvafe
	7AksuOlCqjVRAzMHUL5jm28dYOQXY3k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dtfI1faJ;
	spf=pass (imf01.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4631679f204so345143f8f.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376513; x=1782981313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
        b=dtfI1faJxdqTPNO4JyQwpda9+oj+CyYLo/xJxjCmOn3gLN4iHeLVhRC+tvA6JTCsue
         BbH9U9nAX6KFo6ALR+Zb/BlId1yzpUel04HBCLNQ4oruw/OAnLGwc7mGH12QzIuIaVQo
         bL9pCRXV+Kfshi5O1ZzKpgUEBDKsoM59Kdzl5+Pnw9br6RtW9vZO2uQXnwq2ZBDek7SO
         57x/3cqLeri7Uy/E3LdWJNn25lrZtp6VFdpT7uyG50lfx2/KM41jI9S4Qk9hshCnevEo
         r314GVpUbItECZEcZa1m3rftw1BofXufcIGlOgXpZK2qU/ixW9bQlj1cKlMlH/hR12rt
         lUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376513; x=1782981313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
        b=cZjmkpY8q9ZYZ0XHfqhdlsYOW/pHECApDH3dN+mWLoa60ld1Mv+Hvii2o3kv11/g9X
         dUmYSz8HQFMrJuKYUV6aycIAhynTndZ0KY2mdyL48zfgFwSNRuSgvflNwi8O8rBfIjUe
         dVFVBCCSfu/Goy7cUbxLboKCmse/Y39g4kxvcMsmMLno+5vsRs3KXJvEld9PAb+rRUHe
         huemRBFT2AXxwLwxYI6obbfxcuup3aheskrG+Oy2y2H9h8MNxtdSJ2ljJCcI2IG/H7Jj
         ssBmXST4L9/dsDoxMCCJnJUAbH09zptvwKbXHxqX3Pp2Onnu2kNDXce+vAFVyAaLxhcs
         uRiw==
X-Forwarded-Encrypted: i=1; AHgh+RqmZ6ykjAEjm3tJhldvc3JLauxdLCryYMcYz5snBRSgO1D5QvniBHPSgcsncjjmTG05NbeOm54adQ==@kvack.org
X-Gm-Message-State: AOJu0Yx12BOJ8E+OkaqzC9bJD6PCILDYNWOHIkNX5toRYAZLvvyeBPgW
	ANdWHhO6XowQEYJkkAPg7ac+/sCLPV2h52IKWc1WiajwhMYrAawfbwlz
X-Gm-Gg: AfdE7cmOwttx0YTOEsC2LlZU7SCbpOX9qaWEt4r7RbL3mFXG5Xfy9TG4F7ZrUEjkZX8
	E9kOGslovPrVioo7yz3JyAzYUm5JRmbCa7PW7l+xj07CyAmN0PXwY2+/ibGT6ci6M1D1CsYu8Ea
	tmSk+7ZJfYY9hNv7GoP8YdeW6vG9ASRu6dpjUJi5AWlgMHIovQ4+4Yax5lJBae9M22nRUQwT4wX
	EW2pLzuHq8In49PnqT+hYr+5vquseJe70/woppRMdrZUtyYtDD7d+gfu0pR74N3sFTbAB+1VsB0
	JfbI4BG5r47kMGohOPVjOokC/9PZ/XqI9lfeSAEIg69QjSMKMUlItHhbD2CfU/F5AUkajqUoBbG
	arn/sdWvcOQeLAICclecT2IjP37UUog/+IJ0MpVPmFo8mwkIcGsUJx4F5Z4o22oGKulg9H1wPqW
	Kn+7S8LDl/
X-Received: by 2002:a05:6000:4603:b0:460:602f:85a6 with SMTP id ffacd0b85a97d-46da34965dbmr2376831f8f.0.1782376512951;
        Thu, 25 Jun 2026 01:35:12 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c9ed7491esm9926887f8f.37.2026.06.25.01.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:35:11 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 1/7] vmsplice: open-code do_writev and do_readv
Date: Thu, 25 Jun 2026 08:34:03 +0000
Message-ID: <20260625083409.3769242-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 836E84000A
X-Stat-Signature: yichpgqj8wqs6xwt9s4arg3z83y8qsbh
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782376514-603016
X-HE-Meta: U2FsdGVkX1/8src7oLk9nvj7K54FFgQdaCdIfrvCuA/P+nn8zksj8Ykr9jq1VTittNweytxRoaSqtkKMJpEKljZNYiqqEfgH42l6rFfw5p7LGf0o4Cuwrl9vWrY1W0w6sxxp/Q3YKeVvMxwWKhw9T9HJUooHZH2fBtiq1hrzilceapJNfRTdknhaYDL1B7Rqk+P/XblHfs+FRmkrQgiEDkAjds15xJocV6qIVKI2fnYDv7YyAMJbiAR8jC3i0EFX9qz0x/2+0V8EfpqU9+CTfevavT4R5WH9MO8EEvsKA6DwO+UYJZ9FVUd8qQz5t+7w64elfWhbwWtTYbFzxns8Ucb4M6vYu2Kc4VH6Z0Be0BExiCRqwcQwEQnZcViJAKfRcxu4UcChzILqgEq7+psm6gdvyXTPD5/OfMLSjXYakh9lyYAi2NGf3GXcep9RQcHHE5+GNnF/rXjbx/HQAFKrV+Nv6lmTJOot/RX7WZnRDaqzmk1k6wNvEx1T0wC1WPB1aQ7Vf57i9dggW3aHbVl89N/rxEWg5PIOUBwS5TDesfB8ZA02Yl29NOXGIGlwx2W1aGfLrAZFTY5hKZcCYzA5p/7SFPkDDy4EOd0r/nt79vi8G9ZDLyzbraP+bRYXwdf9DYl0FDDSfmXmKT3wKcsy97dyuh+Xo9ZcfYlSAsI1dvHmVk11Yupsj5UeejLL7IfGs3IpQbhlPWufQIdjhhvhvePmq1cFW0D/FNhA9ci+dxZinsrE8x9QEO9SuCevhmSYGjjQvrwnxYrtXnKlQV7Dy+vry+1z8QQm36bEjTM3YpygTUhfWlZUQYPIKHO7J5Y7pwMJYNnRU6EAoSUIHP/j9Z6MO5B/XqOKdy9nte7NUvSVK8JjcWHJno6n2kb5QHXpbyXEg6KpK1aMKup6q6Xxjku8sCpDu5jJz0mxZ2p7LNSa89tacagLaCIVq6jaCXz3apELWTpWNBELzF/t9kw
 LLBlgxvo
 w2O2t9Ada3A2Z0rufCDN6Y9w+x2n+TwZ28loEavhpNYd2HZARY65J4Z7lkmJezz23FOMv1kC9T6wJmCIMRKMbjqWzLhN2s6+zpCWx+4MPI4x1AeC3u7KcbN4gCiLI+79mB+H4KStp3uieJw36DBJLWSc6PY9YiXl0L+n9H5iB2+z6ABRh5T+OPjRpTp3uTgLNs6zpd+AT95xjilR3hnMO87sPGBYwHbOtwmASIoXfMx3i7xC5ZNCbC4ZxuQWaQDlSxdgIhQfTqGOgsl0d/wLTGAPecHAoy9qDAOtnvWSXNhJJRUhtEAY3BAYwEfcnEYxYqBttyrRsJtf8VUUpJeF3A/dXb6G+pxhwf9aQWReuz1eows8hh8I13GD64YEvsfgM0QAa0HewapBgft4/OFl7EkAYeDALHOlAuLiundrVOjVVRT3ngY3asH/u3Drx2jEcFIMuFoeBBhfodIFwOz225JSYmP2XtrpjwdhqvwFWr8VtMH0XUNSxfcWnHUp+t28wW5B2bOSRWyhBSTylzBAW0xHizJcdQBAlzmV/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

My previous vmsplice patch did the following mistake: I did
"CLASS(fd, f)(fd)", then did some checks on resulting "struct file",
then passed numeric (!) file descriptor to a function.

This is somewhat okay in this particular case, but I still think
this is code smell, so I fix this by open-coding do_writev and do_readv.

Also I insert a comment to warn other developers to keep
do_writev and do_readv in sync with vmsplice(2).

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 1e5444f4d..e224e7cb8 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1070,6 +1070,7 @@ static ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 static ssize_t do_readv(unsigned long fd, const struct iovec __user *vec,
 			unsigned long vlen, rwf_t flags)
 {
+	/* All future changes to this function should be kept in sync with vmsplice(2). */
 	CLASS(fd_pos, f)(fd);
 	ssize_t ret = -EBADF;
 
@@ -1093,6 +1094,7 @@ static ssize_t do_readv(unsigned long fd, const struct iovec __user *vec,
 static ssize_t do_writev(unsigned long fd, const struct iovec __user *vec,
 			 unsigned long vlen, rwf_t flags)
 {
+	/* All future changes to this function should be kept in sync with vmsplice(2). */
 	CLASS(fd_pos, f)(fd);
 	ssize_t ret = -EBADF;
 
@@ -1226,14 +1228,24 @@ SYSCALL_DEFINE4(vmsplice, unsigned long, fd, const struct iovec __user *, vec,
 	if (fd_empty(f))
 		return -EBADF;
 
-	/* We do do_writev/do_readv, so it is okay to pass "false" here */
+	/* We do vfs_writev/vfs_readv, so it is okay to pass "false" here */
 	if (!get_pipe_info(fd_file(f), /* for_splice = */ false))
 		return -EBADF;
 
-	if (fd_file(f)->f_mode & FMODE_WRITE)
-		return do_writev(fd, vec, vlen, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
-	else
-		return do_readv(fd, vec, vlen, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+	if (fd_file(f)->f_mode & FMODE_WRITE) {
+		ssize_t ret = vfs_writev(fd_file(f), vec, vlen, NULL, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+		if (ret > 0)
+			add_wchar(current, ret);
+		inc_syscw(current);
+		return ret;
+	} else {
+		ssize_t ret = vfs_readv(fd_file(f), vec, vlen, NULL, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+
+		if (ret > 0)
+			add_rchar(current, ret);
+		inc_syscr(current);
+		return ret;
+	}
 }
 
 /*
-- 
2.47.3


