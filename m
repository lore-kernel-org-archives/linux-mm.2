Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A0C5CDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633386B009B; Thu, 25 Jun 2026 04:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4BE6B009D; Thu, 25 Jun 2026 04:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB4C6B009E; Thu, 25 Jun 2026 04:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE766B009B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:36:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BCAA1C2ABC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:36:27 +0000 (UTC)
X-FDA: 84917778414.05.F985CAE
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id B21D7140004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:36:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTMZP5nQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376585;
	b=Yj1oUXZJduWpU1wUdu6uJIhEx/pYS6DU0RK4xKw7aqyHDqPpAB5PWMbZK959KzXTM4zALi
	DJT0nabDoQF+BeYTO0h0pnFIpkGJj4uCiAoD+E4a3/EWQqDGF4A0LqyEcO84yyHyi2OFQL
	yrw5uK/yYB/kZTYSzuV0OypQX23KdL8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhjLk1CMHsJsOzOKQ1JbfvjErAaIXQv49sV6IFA3w98=;
	b=Tuj3HXQBpmTR+lmOyHXebjLZ+5r1zMsRA8KlWUNf57ouEyqVUhbWbxX6WnQ81yI+aSRoQk
	oUIv0rTmtMccOn/VRpTMMhDCItTYbIDER1YXtcCfPoKbGmr/R5X9coxCEzWkq6+EsiG/9H
	VwzA9tm7Nzh23HAoxSReUYoQoFmi2rk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTMZP5nQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49249707788so10115135e9.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376584; x=1782981384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhjLk1CMHsJsOzOKQ1JbfvjErAaIXQv49sV6IFA3w98=;
        b=mTMZP5nQ6sYZh5/IAGqcGqnG540U40nQ5U6AaUpL2Th0Gn+PL8JBj1gX9elNjvSyEB
         QZtqOSe66QOfmw7j+rMrSWublj50FGc2GT1DnwH1DpTlj535Nc5PHIXJSyBlzu5pz4Kn
         a0RQfvV62RPiF2A2GKTy65vc4OkfFpz0Iv/m9Svqli2rMWnZrtqvqrruAVtTuGZo3TbJ
         zukZHBaglsxeYxYj1vzsPpilEa+bCPR/PINg5kcrdh7xYa/Li5jijDCJuCdyXZ3+J+Cp
         xiwVBA+6Yo6anRxGcuY7CB7WttNxFF6MxCyZPyWmf4rACLFKC6w01KyHz42SridHj6Ui
         zEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376584; x=1782981384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VhjLk1CMHsJsOzOKQ1JbfvjErAaIXQv49sV6IFA3w98=;
        b=JmwUIAs3nn+yL+utjx48Vk4lLetKnYlQ+k+CkmWBgXA7mKMkl3IjkVKmSt4G/9iyPI
         zKuXVSK4Xa3jDFE5tKzpP5lLhTzt+lRoiTElxdgfqpvZ6ViwJXkSLlhF5QHtIwnfcrmv
         5SMiqARibavY/bqRIsCp4WmFnZGghSgw4hfVeHwhlF4VJi5cNlVXL4d/F7USiJ5y/Klm
         5XMnzwTB3RNQOlHR9x17t96H+G66vPIwHNxFmOo/Kt7I8gjgcCI66W8Qr4pESCwPGULC
         JoSv4dwkGuqzT1/SF5jBpkfITc+jiCt/RsGZCF2ilDcTrqxX4Grby9TbgvnuM7/+A9xV
         +Eyw==
X-Forwarded-Encrypted: i=1; AFNElJ/eW5TIzUnL5Ixc6QI2JYAZWd4y90WnkNiqYuRsg5BfKMVInALHknsWPZBCattjPRUC5qyBT+iqTA==@kvack.org
X-Gm-Message-State: AOJu0Yw5tEC+m8DHtmVMWwBCo/r2quHIXBjkPPrrdeGekJj2HH9LXe7+
	9mwTu+BZ0i0RXjuUI7CNjHuCv2UZL1IA+I3wO5Gmjggt7tNOnd1x/8rOvN5aWm9JcjE=
X-Gm-Gg: AfdE7cn6UriPw51DNSrkMDUspEF0Ffeld3bXdD3a8QuYZElht0nXGc2krkPVqzWGKpM
	nBVxFKUaT03tb9Jim/TmHKgaUxHR8T8vK87SxTQr8OZ2dxha0l1AB77YARiNF2nH1eEeXPmO9fh
	L0o582HpftbBJg0BEgK0uHYzmjDOLbW7UC/ZwTI8OiudQ1pDTXISchKsouC6f43ctlPpJBGWO4D
	MS64ZbOsvzko0aVXxJSEDxXZvf81TJ8Wd3uh6K7Lwr89WY0tIpCpmewDZ3h8tkU13hkygSRiFRG
	w+eZ0nbP8MZpEAYu9qWj0Q39sdCRnyzSxc9TAd49m19Gb6TMulN+ZCRRI7Z+AfdoHjVIZgoRJZu
	i+8pDcFX90ceMUIaP75oInzdt/bw4zagLY1u9GvtGvD7YjQiwQJbbCVnfG0aKCC5JIkZH/KOxiq
	xij54EqK1W
X-Received: by 2002:a05:600c:c4aa:b0:490:b189:212d with SMTP id 5b1f17b1804b1-492668a83dbmr17827635e9.33.1782376584308;
        Thu, 25 Jun 2026 01:36:24 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c2279b85csm13362284f8f.28.2026.06.25.01.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:36:23 -0700 (PDT)
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
Subject: [PATCH v2 4/7] pipe: move wait_for_space to fs/pipe.c and rename it
Date: Thu, 25 Jun 2026 08:34:06 +0000
Message-ID: <20260625083409.3769242-5-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B21D7140004
X-Rspam-User: 
X-Stat-Signature: igabqbresnybkfgko9ci91177fgr9yy8
X-HE-Tag: 1782376585-609385
X-HE-Meta: U2FsdGVkX19wv7ftufFUa1CW3zsolbAbhnUhAFr/pE2m5dy/x+cr0Wf0rXJGtgCwwMoI3waiXnF6Xisp3QKYqcqERvXTT31ZWuL5ER5lLRAu44LrEAoEGSJToSpWHEaOK94HdofIc1AizHaYmPKrQfJkpWm/99N1aaBsbAUkiP4HyHCVFiBkh1d9kKmhkmX8HgMElQJI5l37UP3AoCpKocAufh3wN80hGLAM98ULwFQfehMEce4FOgk5qCHdrA2xWpPvyVoBDKZfRQMvMIR4b6bejKfr14q3OgMnGDyCF9bnjp6I8afyLcj0DVpBOlEj1VP5HI7vuuW6PhgcM7ox+/FPbjgcQD07Q6Hq/2iEgXonkHtCRDfV02YO/QB6sjfnXI3MkrnGGmnPk3RAtoq2ND9rdL7liqsIgqeBO89xszxC+OBlFEWTKpVkKZchB92JLl7f4btUdJXe7Z1WsS4IRH53HBcTCsGqmcIXXn1KmV1HnSxjkpawmLegXUifp/v0l8GUGqkSxMVt5G/LjUhihLQorSxt3swYnr3tjtyYLp3TRsu3DRSqceMQP0UbBjDoAgDhe8EdXg3e9JQQGo0C8PtrkK0/LVYCDOjwyfw2eSOT86xj50oNow9mmDBCym0XsxhtlEK4mHt5l6D5zKFGKPPlxngxQH7lAb9MsN+4Jh/BqmLDTjgQbs09NS07/mqUupHjvZG4rh8x8poRBTq9Jax/iEo09RGFTdg+qMgg6Sz5NtgAgTy0P2/atOs6jaxn/S3dPjWFnRyXJJvDmEnORVO9SQudVzf6CyYbwl41URj6PWMC5meThXNW/BRI2XTffTX7aHfw3ZFY2WezKwPxYiCVNUcQ4NAGBld580CpFlWGhnL08rUof7zTmMMXZLBifAC8U6LAGom2gQae3wpOXdfXb0uqzH+vKRyt9nxMSdOqKCuy2qhv35ha8z2Pl7IGl6bqTrqIZDBc6+cEu4k
 xBNoLcrx
 8GXxdZFKp9RbMrWY5SRFM0EtFHfJgzs+aI1PtXtuUJrofSD+MofjxbKp2Nm9ccmxQTaqtWOpJZnpNTS34Oobl9oO43wQ1ge3/6zLDJ+30DjOjDyLoM7WUEHSTubfe+Lp9U+ckZ4wvB5AZnE5on550J0iBjg5w9BcUeVqgbBUImzCZOCeT2rMlXv6nQBjISnxTfVdQ88HvgwKyIgTv4KEZ/ToA1UjTvEv8KquyIHIpCzCTOo2x0rMVHpwuZTFiKQVm8anLwliaEXtnHJV0wEgmmE94qITCI/KRoBRBUjZpcbrjLFlW1BkERrhOoE3j+SakRx2iqQZlXQjH94esD2Z6hXoi4t+5EZkyuC7Gj/jcgfW4PxWOtECQvHUn66GuZIPDiRk4zUJp7aHIx5+QLiMcdcvdMsvx6CKe7qumaz0vVAlRhmbhWkdZOaajM+VyYNPdLplWwBiMiKb4rAfiT1UHxzccRxik8JGSzoEwGVrE0UrrILfxn1+NRZK/kf24ppzPz/bFEElOA9v8a3N72JZgGYXIWRLpTOLCBB9x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is needed, because I plan to use it in fs/read_write.c.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/pipe.c                 | 17 +++++++++++++++++
 fs/splice.c               | 19 +------------------
 include/linux/pipe_fs_i.h |  2 ++
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 9841648c9..c0ccf21b9 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1451,6 +1451,23 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
 	return ret;
 }
 
+int pipe_wait_for_space(struct pipe_inode_info *pipe, bool non_block)
+{
+	for (;;) {
+		if (unlikely(!pipe->readers)) {
+			send_sig(SIGPIPE, current, 0);
+			return -EPIPE;
+		}
+		if (!pipe_is_full(pipe))
+			return 0;
+		if (non_block)
+			return -EAGAIN;
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+		pipe_wait_writable(pipe);
+	}
+}
+
 static const struct super_operations pipefs_ops = {
 	.destroy_inode = free_inode_nonrcu,
 	.statfs = simple_statfs,
diff --git a/fs/splice.c b/fs/splice.c
index 707db2c2c..d12243d19 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1239,23 +1239,6 @@ ssize_t splice_file_range(struct file *in, loff_t *ppos, struct file *out,
 }
 EXPORT_SYMBOL(splice_file_range);
 
-static int wait_for_space(struct pipe_inode_info *pipe, bool non_block)
-{
-	for (;;) {
-		if (unlikely(!pipe->readers)) {
-			send_sig(SIGPIPE, current, 0);
-			return -EPIPE;
-		}
-		if (!pipe_is_full(pipe))
-			return 0;
-		if (non_block)
-			return -EAGAIN;
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-		pipe_wait_writable(pipe);
-	}
-}
-
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
 			       size_t len, unsigned int flags);
@@ -1268,7 +1251,7 @@ ssize_t splice_file_to_pipe(struct file *in,
 	ssize_t ret;
 
 	pipe_lock(opipe);
-	ret = wait_for_space(opipe, flags & SPLICE_F_NONBLOCK);
+	ret = pipe_wait_for_space(opipe, flags & SPLICE_F_NONBLOCK);
 	if (!ret)
 		ret = do_splice_read(in, offset, opipe, len, flags);
 	pipe_unlock(opipe);
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index a1eeed800..be653625d 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -335,4 +335,6 @@ struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice);
 int create_pipe_files(struct file **, int);
 unsigned int round_pipe_size(unsigned int size);
 
+int pipe_wait_for_space(struct pipe_inode_info *pipe, bool non_block);
+
 #endif
-- 
2.47.3


