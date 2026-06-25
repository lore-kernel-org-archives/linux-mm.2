Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC007CDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4D96B009E; Thu, 25 Jun 2026 04:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855F96B009F; Thu, 25 Jun 2026 04:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5E46B00A0; Thu, 25 Jun 2026 04:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 255FC6B009E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:36:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 905751669A2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:36:51 +0000 (UTC)
X-FDA: 84917779422.17.C500DE7
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id BCAE1160008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:36:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VDm4nN5/";
	spf=pass (imf08.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376609;
	b=7c93Js69F5/xDsZGjQF/xmZ+Riap4zFoFS+3OVLjGJfyvKQIJoxeSfGj5n+z3eDHOmWhj2
	lB6TQcEtMbg/b6VDEpzx9ZVLhexlV7CE2eFYZnnExMB6owGYqLGwqhZVBD0hxcbJap88ub
	0HVxdg5PNN9QsE5RxMzXGSRJLoYBcZk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
	b=COhbvSyn6YuAAi1j84VqZWrtTXpIpE3suLx+la2CeELpQbl6mBNRC+hEJmxP5OAYZz7XQp
	46FNfFfXONeAm9A66CEDvw5T4m1P2a03TsIBzOQYcFhQXDhd7oNYxVfcmIwLeMRR3lVWul
	cfg1NXXKF9E87h549ndUEjdAgHPjZhU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VDm4nN5/";
	spf=pass (imf08.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b7866869so17469645e9.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376608; x=1782981408; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
        b=VDm4nN5/FcNO5RBKAYGXOx4J8UKh+ANuRlsObEwuWC5NixXbBuItQen9IDdwLUkZOe
         9mCKMiVeyqa5vVl3FkjeHQE7I7szDc1MUdBzzWK2aq326gVfqfsaDF77KiqcGr6rsZR7
         sWcCbXoIYm2sHUzwlsko0fm4NHr+FvVORLZi91Sca8VcwmBuNWkBo8WeQTR+UXItdhh9
         gJxYeWBxtqMMDxaxwtbM1YiGslMVR8PQNr6oglZOGV4JhYXI5vTgUAC7utoz9PPKLUyt
         GIq8AMCVwvL4GejUp6FraIL9qmwGWHcOUooRg71Kn6RpSfTGr9+dps09bXgjUVGmXdn5
         cDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376608; x=1782981408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
        b=dUw00+GXo6D7TXzGr1rPe9dF/vsV5A1EEJS49oSlTkQWPdiM21do+oAE9ZWZY0J1Qc
         Gd39vIUyRC2/o+m3cLJJL2sfLwGZzzxmd+gUZh+YwJNPxkTLodkJ4vt5AjJT0HVI28vo
         hCxfY5bEWQ7nOosTxt1Qj0UJqx2U3c8YYzM+68TcK8YpNz2GaxHIOPzqbQrQkfSD+eQi
         YZSPtOiGzXjK5F2bdcRCpfAF8JCR9g038DRMHZBzJTEulwhpxaFhfMI0hWdZzrwLNk8R
         ymh7EWRubtPfZIEfveWFoMxOF8J8ex863rlrAOdBQ4sS6IiVDCFWfvH9weZqPGRTprqb
         k3OA==
X-Forwarded-Encrypted: i=1; AFNElJ8lnrpvYIJ0wOKMySLZzsS8x4d32RhnHZk3RajaGOBrQ+TyxmGqWihVldMPl8nCq2tVbMhdzovt+A==@kvack.org
X-Gm-Message-State: AOJu0YxJvUel/MZ3AOd4PmZ9PZGWpE8ISesAOEprA+5OTEULIBP2bxeY
	CHevlBrTz49b2sX7FK0ikY9YvdJft+q7BDbIftnj/wIpEuqwVJRF/eJw
X-Gm-Gg: AfdE7cnxaK2ITA2jbnENzQBRrrUsoeozcLQq3tuMjyDUOG5NGf9PB5ZluIneRTGnyHc
	bIkdNp9CqRY5LzQqRiKtqXUqF42Ck6OffG8Ucim2SbnUVaZlLT/x3YU6oNsPvgMwekxt1Ko/J1U
	o/rYMWan+WzhXWx/jMX5sJfZdIfvwk4SqIUBggKNUWR2qBbl2DfifDeP8w8uB215e9G8GBzQniz
	5ZscSsp1zVzeE40FDf8P86XJ/5tgcKJ0eIozBrjFejICcghCitMaO12ImDzfVEboo30xjEL16uS
	BZ7NoqyWe7ME/dqPTvVHXa9IC9X86pXy4fWk+I7A76zujQ9cuQgbI+LGnejlALXDCiGGzm4Lue1
	jzhdZoUD4xMFhC5ejI+xiyCT7fXzHz8qkr6CEQCWGZdZ68E+nNh19vSuqrFEXPJxJOPxoBwA6s2
	t/YIRyRiXr
X-Received: by 2002:a05:600d:8489:10b0:490:a298:3859 with SMTP id 5b1f17b1804b1-49266892151mr13952905e9.24.1782376608352;
        Thu, 25 Jun 2026 01:36:48 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-492640362bcsm70832535e9.8.2026.06.25.01.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:36:47 -0700 (PDT)
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
Subject: [PATCH v2 5/7] vmsplice: make sure we don't wait after writing some data
Date: Thu, 25 Jun 2026 08:34:07 +0000
Message-ID: <20260625083409.3769242-6-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BCAE1160008
X-Stat-Signature: k3hcpenqic1qkbfc3nukrg5z76d4jjpp
X-HE-Tag: 1782376609-943712
X-HE-Meta: U2FsdGVkX1/x6LCYK9IJk51zxysZd7HrN2cZMj9U4C74GSlj/wy/fq0HGQXE5eyRvSamFk374PQJwyV2Ih2OT8RBOF49jXwAshznrhaJxamm4nvfGYuIvW0d0SjQKiWKbc/kjHlPa45jhgsgfXYHB87j4toA+pxo5N+b7uL8fXlYT5Y8BHkv5xJb2VNQ4IgTQ4DXnUA+uHho0gARg/783THJP/bTQfKNsW3TfMlbLjHL82K4k/A7aQBDqPJqg+2IXak07wVAcfhuDIZgN7dJUbFq1dB7sPSNukA+czgMmHlhWGpLvIVK3gGfFPVh6bojBqMVg7lH5XNz+cLhYVOpSFvDa8bX9V+3OA5t1+WwIf67bpHvPAPaanDUQMuq+wFOCrm09AGQhqBPJsw5ZKScVdI25hpeqVLmpqH+lpWOu479JITE6QYNaqFGnNHvkQI2cQ5QJpCW98Sb7MKSjP5odCMiAIyq+uJJ32+d/XgQzEZnOzJgnNAfuCqppAqdEEhIU77MQbh1Fjdm1+8ERXZHvBfWtoDeme6tegSFKBX7dh8+swTK43bNz9ThKK5aT/lRAqc+b9oxaxHOLBmbO23DNz7OPCg64UkaAVmN4HX4o+IfgP+C9wtz6EAr1DuDO7Y166UWZZj67An9VOnpDgaFdCoE3V1zx8UvxdTubu9g11r6rBUIMy6fhDmXgESwKJbqAf2BeaO8Q3lGchr/88LP3I2Jbfnirhcs5+h3uAWot1gNMb4+DjK1knyxYwg1Eoh+iI9wmARNGvwtqY0qUpeLVYd0FanuHDDUMHwqzMDsZpZGkV4Ft3jy/xJjGegsa2DLPVWw2miKqv5NZdjmKLCEhpsgheZFrqdbW1Jr4vX7fJu8rO948Kv1BAm98i53HvGSXgq15VOTmXWuPKmSfdhitDfOJ0u7e96M4ZH0f2tdcjnKzHqcl3MPmjVdZTIEzxpRT8bkzHVEIHjn3+QDXa0
 ECky1fXc
 0SZuaQav+KAy8ampezoi+FtAYTbtDSRpfDiBHmTlmkngkXM7Us0pzHUWuX214xIvOm4kyf5XOM4qPZCxbab+X1BFpgNm/lX1InuvlMD94wyqppDM8h8o8g3uxW4aIx5MDtyG6zjy9B2l+tUAw6vmkE5Xcq6r5oUTWeSKrxl9a4OnvDpLR3fFFM3MCpNlpoxpiSINDsjvhoBtCAOjZi66QIt25JxdPvhQbj4emSFS09JKW1djFbDrNwl6vJ8N7LSz+xibhipsZaCO5unzKUjfS6Mpm7uPlEX5OjGjhbzY1a6MRTBFE/gmxYf+SlRgJQM3fiRj61XFtDa9SiRScRlNTnaJMpIdJQVxKk64wtzb+WxrmMg5pTF5rkAbtYlEDLKlTMBHKdKYoxDNg1gYmbDQOEwYLzvAUc3+jHSDfdtrHs4PFXENgmVPewi0r4yEqToWmcMFMVuB6uwNMnxuE8+a0B2DRbQJFUa/rnYmySFy3eINNvmo=
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


