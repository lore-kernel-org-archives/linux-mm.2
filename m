Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23606CDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177116B0096; Thu, 25 Jun 2026 04:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128A36B0098; Thu, 25 Jun 2026 04:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D206B0099; Thu, 25 Jun 2026 04:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB91B6B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:36:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5256B8FE5C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:36:04 +0000 (UTC)
X-FDA: 84917777448.21.88EA563
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A8B5140008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:36:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sZX1nsaR;
	spf=pass (imf23.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376562;
	b=rrUGPMtSgOjeSun5f7trsHV8KFsR7zkh2qUS5/tVl1p4EalzjDiCX91bvWKXfhb1/IjUp+
	OkR59tzr8E01bThPX23i3MpgJO3FkhNLIcstVL3eBGKcEwA3FD2QOF9GsF7rH17K1uA1cI
	j3XSOaVQcqeuPDHuoVijNN8Coc9/GgY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
	b=qV2asy9tl4jpyIsnZmobWuBWtlRpfijht45asIaOaEJvZWeibDjUewVfS/u/2EGyWFZHJb
	5z/lZXIz6k/vZhhQzAdyffOT+UniLUvJVW5CfjWWR1YKlPVA1fQOxZnawkA7n7GeSUy23f
	U5jDq0mITi8R2f5Gtmnw2te38NGAya8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sZX1nsaR;
	spf=pass (imf23.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso21158345e9.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376561; x=1782981361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
        b=sZX1nsaRCeGHtF2/7ZRgNHAHq9+hUB2SxWzal5a1bZLDmjeDk+u/4VYpydfFUrzFzO
         gtmLB3wdbsMrFF91eos4DTjDGJ9im9r+CKR2cBmBYC9jELyYkmJiz7pqZ4XTAbICSGzY
         sfxI92H3KDFY2Q4KSPPe5gUlQEyNgI5MpDeYTM/pwdO1UULAWqQN3j90X6dGJV98obMd
         r2HdwiBsrWnhEMD/bJfAwn1KUPOMGCamDqS6wAKXRZMvJVdL8liXQhZnrtsf302vkkn1
         1kq1GdsoZhYczby48at68W55dF/52SkIhsTFwuOks5m7QJE60CZRQPLUJCREPWtnHs9a
         GSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376561; x=1782981361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
        b=qCDbsDppLlZxFzK24inuTFx8iQS6iZb+Tp9kiGf1Ey9+Ujq+Q6DLAcNWEWL2qYQRb5
         jEMOS4Qb657RqaBSm/mKUq9m5fWpd6+5IYmRkkCHbwZir+D2j9tPjYrLHucU0tLLcWxU
         hHJn9yTw5lT69OfJHk1GdiTQh5XtiBH21byZtW9QnJ8nRkeF4bn56JsSSGfU3FP4xWmh
         0M/2fQlv7MkYbjG7CmpKNB3ZZQ9DOPEU0j4uq5biUs7ABVjt3nUTt2WZzSV4I8UqMp+c
         Ais4cdNJ3fFuteopTTwO0KhcA0ub58YS0iGya5HjKLfLzmqjQgaLZsR4l+/k8BfqtB4t
         ypsA==
X-Forwarded-Encrypted: i=1; AFNElJ84rqoEBLiQAE9g3CK83QtjoiITrjt4HgZH/1vjX8j3SCTyG3MpG75GrvkthqaeoS4w52VActlksQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0YNZTvUSRVtdUgTWNr9kfmO1TdKpcwj8YpHu3XDruvAfcsvZB
	w7Nb2mZvdCSAAhDHT5QHNUMiBaFBCnGbeem07On+W9XU8aGTpa+mFBeo
X-Gm-Gg: AfdE7cnkh+y9bh2nEd/33RreNJXJPkGZd8qCXjBhmv16ADqLz5whqrz0czm/i45TTtc
	HwBLx9lTs9QrMZLW4YZGQrcrBFJ12b07oji2aKAcbBIGOAW0kRqYmPQEddQ+VUlvyr/TvGH3W8f
	Gjb/uI8da4sP9fV6ehJg0glyq8A4GDt8HAqndamY7GF3+2iMKvO9z+3drwyhH1XoRuwOKqc2Jvp
	FLqLKfdqbxjEim3Qbfr6+R1rEjJOk366w9sS4gc1Gqav4ANBd4bag5YlmFFAaeivNJHAf1HWvjz
	vo1lpBqYQj2bMxkENYzuoa279sFV5Bes/GrMw73WkUsxkiJAx3VuUJzF4GI1+kPJlyuS3ZOU3tj
	CEqF+zTJP6vltbdBPRCIwSeagLeLDmxnk1QQBvgL8iZlpWuk9kLdTMyEq17uhual/aMy5KTzKyE
	wNpAfCSqr2
X-Received: by 2002:a05:600c:c0d2:20b0:492:41c9:886b with SMTP id 5b1f17b1804b1-4926684c948mr14881805e9.14.1782376560755;
        Thu, 25 Jun 2026 01:36:00 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4926401a2e7sm80070205e9.3.2026.06.25.01.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:36:00 -0700 (PDT)
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
Subject: [PATCH v2 3/7] splice: turn wait_for_space flags argument into bool
Date: Thu, 25 Jun 2026 08:34:05 +0000
Message-ID: <20260625083409.3769242-4-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u8611s8ab4o9t8w9q5bityi4m9nfnep4
X-Rspamd-Queue-Id: 8A8B5140008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782376562-398093
X-HE-Meta: U2FsdGVkX18KU69216i1mpdobDKI56sBuVSwQTaJGxgQIQuLUteov5lWnZBrsoVmJEd3uSKMOgeq77KXwE5CHVwBr2axgdNsf+JfecwBhNRE7VHjAW2IMtwbRsu4L4avoSMh3npHQv255ON+VXFNgSeq/er/fLGV6zEz/0W2KEfKU9CD4Jvbj80uPhS9A8JJvqdG/jUc3QymluPQBqr6bcG5XeBsgHtdcaw5DRwZYt8mNu7JkMKTNajCgkk/mUFyjFH9OOfKBobX3aLomDjZ3QirNkFeLeK4NgJEFM9eZzSBhLSAa+bfzpwV1+6gj7v5dI0tSl/Nmk4bdrGLxjgj9eCr/M94OnPp+btEfQ45rMh6IwMesTldT7utaFa6rro6PIMIjg7TlU7H5bZKBXkYZSBKLDJWqPUT35gV3LZe6PHUnzysjradmtawDRtD39fV75nVOPQWZsPeEI84Kl9YrL2B+fRPprwvFvdEwVLZ/Zi/mohLbY359tYpPjPvfIhgT/EEUwgT1b0jOTp8OWv9wh8IvuMMBUzUOIUIfslD+rvt05UPmGhpxuKKP7Gs9CVY411qrS8Gy0+Adud98yYJRY1FALqp22yzx6C1JAUFrrjB9bHUaSm1ZwAyi7O+l6BXcpH1evxkJMqbEVZHxdzS85tYpgGWSXeGUfvoXvrQ5AZuDjNdjavhFVvQhL46xv+OUo5CzPVjQpdMh1B2ivThE7TOpdj2bdgS+yQAPW50PE/LEyu4mMBvgJjTVP8Uinkvj14vhF9pMc3swLNVRGv/gxAUSjhaNkirSVKqxTl1K9bkp/QbJE5hzyDx8x3T4NkLr7+KTkc/Cw/PhEJwXA2/NaVTF1rvw3ObAEbYlsxsiRhckkKaqOU/zI9Q3G/vkKOmKGvdvoMwRUMuhpT9Ensk0X3CkYKaLP1dHAg9hZt5wZbX1OlRokGGy5N0mN83Wsmld85mUNbRYXXsdZFTalT
 WjMQGdwd
 gnZaqOrW59yV3Eua5Vue0sResfQetKdspd4pVbZh1Rw7TBlfNa8Z0LW1HPqCA8pB2k25FUx6HEqcWPuFLG4jWsXq359Lgu/V51M/mahEX95RuOT+T/fYBrcqTCfWoGiGd8Gck8Xme4jAT0qCAEX9RzTgyzgMq+zjt0vRA2eWfkqn6+isH45fJOU/awyv3A2MZHqq0kPdX2e2IhVCpjorUMv4ONZ9syPkhYmBCSJLSA+qtBOrotObS2xdo06LuFP0Xrf6hT79YuEeb1DSYzjto5R37KiK5eszsR1dI2f1G+hjuPXxzYg9LTX2DozQlwm5+h45fxQizx9ZtsDmgDrvmCXp/bdCJV9P3hv9lJCRk16r141XVfgcaPYa2kYTwRfl3w4+6ZCqh6Ov1B4gLoCeAziWgkMtCNQFvNb6CGIb4G2kNE2/a0+JM9iUSwT0n6QoV49NVenC2cMB3/GKp2CH8Au6VMmyEFYULZCFkgRrmjbA30wp2oGVLGSmBvrGvwGB6SZ/J1TYLvH5f3GhyUbDQNn69BJLeKFGxLiYN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I want to do this, because I will move this function to fs/pipe.c.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/splice.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 6ddf7dd72..707db2c2c 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1239,7 +1239,7 @@ ssize_t splice_file_range(struct file *in, loff_t *ppos, struct file *out,
 }
 EXPORT_SYMBOL(splice_file_range);
 
-static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
+static int wait_for_space(struct pipe_inode_info *pipe, bool non_block)
 {
 	for (;;) {
 		if (unlikely(!pipe->readers)) {
@@ -1248,7 +1248,7 @@ static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 		}
 		if (!pipe_is_full(pipe))
 			return 0;
-		if (flags & SPLICE_F_NONBLOCK)
+		if (non_block)
 			return -EAGAIN;
 		if (signal_pending(current))
 			return -ERESTARTSYS;
@@ -1268,7 +1268,7 @@ ssize_t splice_file_to_pipe(struct file *in,
 	ssize_t ret;
 
 	pipe_lock(opipe);
-	ret = wait_for_space(opipe, flags);
+	ret = wait_for_space(opipe, flags & SPLICE_F_NONBLOCK);
 	if (!ret)
 		ret = do_splice_read(in, offset, opipe, len, flags);
 	pipe_unlock(opipe);
-- 
2.47.3


