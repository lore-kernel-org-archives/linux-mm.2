Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE81CD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 06:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229536B0098; Sat,  6 Jun 2026 02:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200E76B0099; Sat,  6 Jun 2026 02:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116F56B009B; Sat,  6 Jun 2026 02:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01BD66B0098
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 02:13:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA3151638D6
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:13:03 +0000 (UTC)
X-FDA: 84848469846.04.2FC7A4C
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id DCE47C0004
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:13:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bFwWBNnz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780726382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
	b=kovlQihOy8IHLtkdrZB4r0uDrBPVUACLA7XOB+O0GfvIO+y+xlJZo/kdzUFzQOb8OXInzp
	wX2ZeP1Y7ZStPyUw/1sFH8/aGrNsywZhAPopGArHqsgvn9pYkyn5GDGDkJT8pg93yqVnWG
	JRe8tKcO9dcMLkDGWsYdcDWatMlYCxc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bFwWBNnz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780726382;
	b=tfXK74RiMF2CRjhTbdfColNM/sImd4ZpDKYzW/BaD7KVaPgkNwwXLxZ47FUi1zubmdkb3F
	TJG8YY6R+paNd6V2UyYANJyv8Dp7pH6qApHqUjmKz04KEAKIGtvPMcVEH/GKo0BX/RshHe
	rduib2w0ia+dR0BKeYtMyz2F3clFG4M=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490ac10e337so22722125e9.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 23:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726380; x=1781331180; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
        b=bFwWBNnzpGWFv6SV9Wn94CwzQnNRZZKjs3HtkL9j7foyyujk50/OS5v1LJj/0JkXeH
         w34nW3FSBLv8pen+NEpYLH4ROr2UcHbl3hDXgrnQ4gODl4xFhYuLm9c+hER98Sh1aX6f
         wiC6cDI0l8S2G5BF40QKJCV3VzjA21G98F0Sg6C5mDcl6u9f1hX0VoqzbMe3+daL9+GX
         7fs3zgP5PhwOtkGX0CKu/xhwE9GB+U66SHP0QObmr6WLYJ3iu0PYvHjjDtdZLoYcG2r0
         /QlabECYZF1nD1JlkfWtR2+SvvARy7AESfwxMYGdT9u0Z14YmxWcTc68o6cxr637WUaO
         eqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726380; x=1781331180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
        b=U4S89+CHPlNrvnQGXajT1n9TRntCaxmi1cTpCGPT1pzMVQMhFxbkckyHSP7GcxdJ6D
         oE85P78wqvtY02CWk2vmzpeVkc+Dg8N57xiQ46M5RpeT+ZV4JOiXkkxfLYvAJjP7sY15
         2tIq4QfkkaIEd/82CqW+ynRZuI2z229KHBnV0dRW9X+A78KWUI2e3l3jGuuSOLkHaUsh
         oznOQNp839wo7vhFRUiSAdCApMhXjI+6+glXTxK3Z0h222OeeHkto+bjlv5hTX5FcrLe
         TIa5KnpOvpeGeUJqxQISgrO89z3BMDyYcUz+gYVSR+dH2/cW7Sxv3uM1SdleRLmsPpXv
         w6LQ==
X-Forwarded-Encrypted: i=1; AFNElJ8cj0UztilraTY6gJpDfFbtu2Oadk5aUaq61a9zgzhwl1sJ8yLc+UjdczTkF6SqZ41jnQFdxjWoiA==@kvack.org
X-Gm-Message-State: AOJu0YwWpzacjabvnf6QrGD9bgWTthP9uzYgvlaGhgwbcm0h7W/cPwpt
	crfFxHsRUYt6guqyS7R8b3JcaDfA7Tkd/6D6B7ctu2QVdbAe3DGMxYyr
X-Gm-Gg: Acq92OE7f3bSTakWcUx4CPOlchcJkWimAy8IcyM9V56VvuxHi0eyEs1yj21g/JJtFFh
	A3NHNEcp7ttlm9++sSWySrMYgT3eOgkZm0y/U+k0uXfGYsGsfAx4kCKSyDf9GP09FXiSXLiXEo4
	Hv2jlTfA1OJnjW5mnmWyWW2GQu2ujxv/L0Ec50Pn1JLLq+r6tnUXDGzjY3DdH7rTj7GQWGcGbl+
	KJ82c5O2hqcSJdZENYDGn6hA21IcxtcSoTYffAoZ8ghOYgzG/q+8R79JEIcFdQ2FO0oSY78V3hX
	2avuNQctRtAL6etxRj56G+lwdQkclLrRxPd9e4113OS+ArUhO3MPU2WOHGVPxAIjY05+ktd9Vnv
	Q/UThoq6Qu9PZsUdy0Hm+wHNq+Af+usk2IMPEXR/tyX6SZ1cfv2xwtnjqvRRkptlVh7Bh5hmJL9
	W5P+U8pLnATEqq6Gem7mDuaEvzyvLIgQ==
X-Received: by 2002:a05:600c:c0d3:b0:490:b0e0:3de2 with SMTP id 5b1f17b1804b1-490c265c148mr78044605e9.33.1780726380490;
        Fri, 05 Jun 2026 23:13:00 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f2eadefsm32281391f8f.11.2026.06.05.23.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:13:00 -0700 (PDT)
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
	ltp@lists.linux.it,
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
	Steven Rostedt <rostedt@goodmis.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH 5/5] vmsplice: make sure we don't wait after writing some data
Date: Sat,  6 Jun 2026 06:10:31 +0000
Message-ID: <20260606061031.3744880-6-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
References: <20260606061031.3744880-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: q75fma3x4wo31euop4fa8jwndg3hmr6h
X-Rspamd-Queue-Id: DCE47C0004
X-HE-Tag: 1780726381-275399
X-HE-Meta: U2FsdGVkX1/R4bwOJwsLIuDoZ9T8tKip4G/AKlVUOyxVr2Ta6FhXByqer2YcTS9CaubyyCsyISvts9OOlblMuSWXiCIODI8zVDSNiL1TIXobgDWKGYxaMyyC83cSSvXT/u+FiX0wgBeWd+XGeIDERdu7uHf6me42ZdZeqjS7+PMuOEtiC/G4CskX+rNlccwpLgUGqzxQYAnSk2d1/ixVtvun+zEKSUAcKEsor54WIgFXPQ3UJLfjmsMCut0DtPorHcb8wFc9cT7L5aTD8OPxWrNzHbF2hRrIS0uBz65+omJbpL3fMHnzRHe5AK9jwbUhtn2HTmmoecQr6OX9vUHMZGwp3QHhuz3FzBtno5Q/rFW4GDUyv0uF/5FewzofVJDcxVlhMT5OwG3RP8/6FfD4tVUQcc1GO3kjeLmqOjp8NKTRJ8OhlrFNKr7McfrZGzkwgZqBYYIKAGF1YaYUmYy+GE+vJpOIteo/BewZvXXaDfgb3Ae1Y9eLWq5cgvjkZR22eBhfJPhRzX842Hr9jAbe+07pmTkXLp5FdRdRZ/A7PxeGqw+On8J3mVBP3tiq8DRq0hLqi/NM64hcc8oFZ/83H3GatrAMpxg1PyxBcLR0QqoNYIUU0MO5lFb+Ts2w0KA0UM8Q/6LsqUSype3LSM4/WCC/Qm1AoA6nEJBiNPAMK0sPOZDhDMyNamjE8sNhRjMTOXaRJ0IzxBQwo33k3YEAQ43Igkz9NQ4yKYm9XaA7+bPPuMm/9xNspRfhhGX7I9VgyUmW6VB9HhvgVhywMcFG7SUVd/7fTLSNHNoTdDpX7YTcGWMKUi6F74k+CX+G8ruZ/uWvZORuiL1YrAM77qR0N3zG2aDYK5s0KyNJx/URRpPVIUx9+OW9oyKSBRbZyGHiA5M6S+rJauB+A412UWZ51f9cKe17zQh5+lp1V9Fy6vV5qC1C1Prd2zz5YZ5yyE+3PVTSMFviPz5CVaw9gdX
 EE/YwQ7n
 OKO15uAvgaeroG+9S9cTc8OnqmYJPfv5CkQqy99mY1iMBBVD1LoWCaC2PX+WunfSv0YpH2we6jDRTFlpp3wuKyIUyHcjAeZx7OmpNyoHYj/AZ+RqF6XmfQHqp0ZzWfjjLUK/eXZNj4KwRWKDElQwTB8Y9xAZuSiFKtTM6TC+OkuzrqQcg1E8fhEQNUXcq/d8124mlULpKKsDYl9fLuEErkPLdD9O+28dE/7DTb7rXHmSrxI13u2zItquvD+5bBG/yVAd7BR/tjB54LeAEpSec5lRKPW5L5+7LFc3hIGHIasTiqtNtWpXIYjx4DofQVNPhAICZjQXrbanAnYlTeI1YCvc6/dz4dN0bgpxhNVMHbQYs1CNMafZ0vPghhUbTU0suvhpPnspZvQec1twaAstjtf9hg+7ozRGh1+dWVK5EFjP8P00S6KgkbnE1xJqgcA2DmQLB3AGb2Rtu/KzwxrGkTPYQ6sFesJeYd/Gp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make sure we don't wait for space in pipe after writing some data.
This is needed for compatibility with previous version of vmsplice.
Found by LTP vmsplice01.
See comments in the code and links below for details.

Link: https://lore.kernel.org/all/20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner/
Link: https://lore.kernel.org/all/CAHk-=wgV-j-G3d+899Zm1pQ=NaJrddPz=GKcL5Yw5DTUM=GaUw@mail.gmail.com/
Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 77487b307..dbd0debc2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1221,6 +1221,8 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		unsigned long, vlen, unsigned int, flags)
 {
+	struct pipe_inode_info *pipe;
+
 	if (unlikely(flags & ~SPLICE_F_ALL))
 		return -EINVAL;
 
@@ -1229,11 +1231,44 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		return -EBADF;
 
 	/* We do vfs_writev/vfs_readv, so it is okay to pass "false" here */
-	if (!get_pipe_info(fd_file(f), /* for_splice = */ false))
+	pipe = get_pipe_info(fd_file(f), /* for_splice = */ false);
+
+	if (!pipe)
 		return -EBADF;
 
 	if (fd_file(f)->f_mode & FMODE_WRITE) {
-		ssize_t ret = vfs_writev(fd_file(f), vec, vlen, NULL, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+		/*
+		 * When writing to the pipe, previous implementation of vmsplice
+		 * first waited for space in the pipe to appear
+		 * (depending on whether SPLICE_F_NONBLOCK was passed),
+		 * then did unconditional non-blocking write to the pipe.
+		 *
+		 * This differs from what pwritev2 does.
+		 *
+		 * For compatibility we do the same thing previous
+		 * implementation did.
+		 *
+		 * We lock the pipe, do pipe_wait_for_space, then unlock
+		 * the pipe, and then do vfs_writev. vfs_writev internally
+		 * locks the pipe again. This may cause TOCTOU: when we
+		 * do vfs_writev, the pipe may become full again. So we
+		 * do a loop.
+		 */
+
+		bool non_block = (flags & SPLICE_F_NONBLOCK) || (fd_file(f)->f_flags & O_NONBLOCK);
+		ssize_t ret;
+
+		do {
+			pipe_lock(pipe);
+			ret = pipe_wait_for_space(pipe, non_block);
+			pipe_unlock(pipe);
+
+			if (ret < 0)
+				break;
+
+			ret = vfs_writev(fd_file(f), vec, vlen, NULL, RWF_NOWAIT);
+		} while (!non_block && ret == -EAGAIN);
+
 		if (ret > 0)
 			add_wchar(current, ret);
 		inc_syscw(current);
-- 
2.47.3


