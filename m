Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E239CD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 06:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C286B0095; Sat,  6 Jun 2026 02:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9531A6B0096; Sat,  6 Jun 2026 02:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869C96B0098; Sat,  6 Jun 2026 02:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76C7D6B0095
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 02:12:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17A851A03B0
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:12:40 +0000 (UTC)
X-FDA: 84848468880.06.7C45E4F
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A882180002
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:12:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FjwcAI8e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780726358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhjLk1CMHsJsOzOKQ1JbfvjErAaIXQv49sV6IFA3w98=;
	b=I4wrtRmbJLTbk0rqyoL27NBHuFljq3jAauZ6TDTCDjQ3SuI5sLO35ckr0GRr3sv0oGCU2q
	zplREImr/Q3xgHM5pGnGzB3xbklOnzP20u3BXgH+OjdzMfffh0zViKv8DjH5MiI3ePzdB/
	foS+lgPEzYd3lwjg7Bd3MSx1RbA0qqU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FjwcAI8e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780726358;
	b=TJJmBA7Hk9qjA8subgeXmtDHftZgHbgM1UFkWH4NN0JPa1ZrQO+F60BDQ6ph9bf2ZfvqpP
	s4GmuWXQg2aNrQVxWV2UYbCwU8F0xaq31uU5CZrSwQqORY4mh5CZOQU7ZPlhsnIEc1wgw+
	l2/zaIh0g7FYSWHFeSAWhrJRiL35Q5E=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45ef779c1c2so1745391f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 23:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726357; x=1781331157; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhjLk1CMHsJsOzOKQ1JbfvjErAaIXQv49sV6IFA3w98=;
        b=FjwcAI8eOB6q0LFMYWorVhYD9xjqzGs6vbCBLgP2Gmv3oREPDDDBkZja7rkFIx8YGN
         goM8eZMViFsxeJRIthBpwNRFkx9yNaZgimCTX0GxhQ/ET5MVEwuRzx0N0AR7SetS+KCG
         1JGJG6ohmyKL+FnYjKiByFzTASRbCKiDBfsmo5PQQzP2yJC7JFocSXudL2yX++jYvJJZ
         4mPTJ7xoGyljTz1ONqL7yRMQChNYChGFt8Niay4Mbq5IYVNReNJjQSnRkgngCnAqXDlr
         x7CKBjz/pWnR8mhvWYfnlpyX/2cTzaTr2Y7Pcs0NXn6xUw3ixqh2gTdMMPHEIeZUcdaf
         Hc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726357; x=1781331157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VhjLk1CMHsJsOzOKQ1JbfvjErAaIXQv49sV6IFA3w98=;
        b=qvFoYuWM2jvFs8OSZKWQp7qMiJyC4eCpsJw5G+NjqnEbng70hQonYj9J46251hDVZv
         swxZDVflX6zdhvnRwsN+oO2xwxuIUNmR1m3bHQiARA023zxYRE4ukjkrb/DCPdhh/ag9
         KPrNSvoxvzR8YLMu8Bb2ka9eFSTS045ykY+8eTCO+RVZGrX/eoZy5GI+zwAd1OME2BX/
         vjOY1Vb8oMew/NkqhU3zH52w/youxqkZmkOeO4UAFod2C90e3gpRhD9N0uVY2XIoXSsh
         Grdc+NdINULdOB4fMCM2ZCqkc308FYydOvUSr1DauJGT7EVGDL6OnrudEI9sKFR4Bq7l
         WZcg==
X-Forwarded-Encrypted: i=1; AFNElJ+rPpKkEf0pgKvrP31t7FTo19ddUUJATWV/Ze+VpIIhE0r81a/AI8lOnizWKC0WT5Zk3Fp+0IE7LA==@kvack.org
X-Gm-Message-State: AOJu0YxLoZXBz2JgXQpQhvIlwnWL4PMh4kJtdcTxZZAFZSUzR0YI42e9
	yqxhhAH0WiUPgJia7sdh5MeCfXIPw2LJ6mBVkALy8eI6ueIeJGxhi4sK
X-Gm-Gg: Acq92OFq+Qw2YbDHFtvluH1MuSsH3af8zjs2Sp1QtnP5OVYNKkcp/pmy4VGaIp7Fy9m
	T0l5N+V8TXAyKLd1HoHfqF95q2Yh5K8jM9N0R9FYk1gLeRewSB342UaJCI1XmykEWT4EUGvSScP
	RZZYucJWCuywbg60U3Z3hCObPyh+iyhTqDGSfueNF3NNC37vo+BS6wtWCBgsKjMGLKVbttacnTi
	2qjqFBt6zJN9VSXwH0Q8TesbPwg8nKvzmjXbhgvgSW7Svd/3SM42/crovYxKwNqRqmFXHG5HbS/
	uCU50owIxABIS9tBMMh/WeX07M8wrcXN6AcBmO2Waztrsm+d2rSPSoxR+e4AERWAz7heMeVBbLI
	fVsygLcB6TE+B4ph072w2Onv9YoenPLQxJLkZ9SlGvDgxux/4AdFS9zb9eh0X/ZLhJREZ3a5aMy
	t8RFMtuqOmq8GJoN4anbjsHBsSb5oTSQ==
X-Received: by 2002:adf:e545:0:b0:45e:e44b:3136 with SMTP id ffacd0b85a97d-4603063a715mr8180799f8f.19.1780726356710;
        Fri, 05 Jun 2026 23:12:36 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f344541sm29667978f8f.22.2026.06.05.23.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:12:36 -0700 (PDT)
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
Subject: [PATCH 4/5] pipe: move wait_for_space to fs/pipe.c and rename it
Date: Sat,  6 Jun 2026 06:10:30 +0000
Message-ID: <20260606061031.3744880-5-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
References: <20260606061031.3744880-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A882180002
X-Stat-Signature: nahfip3hsbgqcr8c816cuwbsntz73tm7
X-HE-Tag: 1780726357-46613
X-HE-Meta: U2FsdGVkX19eIscErx+7ajiz3oRIkOeACuw6D1T4ZLeb4YD4cieO7B3UaT3neA2NJ3z5njfw9lGSfoHXQS+oDyYIRlAdPjyYrdMNjcWaTL0UO0euJy0TG20KPg4fEqpapSCHavWC2rAllTqvTh6Gh5heBgd63uNIjVsxXTjlAkzNWxn7xLHWTAU8Ys0OxOg6bMvO3/B5F2OmXgwNajmIBdE49RAjZDXZT+mdaNv6dwoJG0+9VAWAMIH71tND7NZZYDKTtdi9tczX5Q5Psq0DtVY/KF51sN6VOuNgHLb962wxHrNA4oo8VLUZe8ISd3YsoM8VR94M0OnnQr17QhGriuB40bg3QVe6RNxpiH7vAO4Dyp5R9NMpvlSISPtznlYlSarrD+0XPsS7EjaVXqYOiwwbdseJ2+l6GFQkoRzUEpZT0Gjhh5yPAaNOpiNhu1xSp6pnkUhZkawMDd+vsgCZ4g49XJjZdOnbq9+owiwTTNJdq1xXMBFODSEn2AxP8R2n8SIdaSB9p2jcWy6HaFXMxchZNkCinlhwcLbMAwazn/nfKQQQ5eBUfsVWRGJNJ/yqjAiQr1QmQELp2dHVazRVmP+JlFdyoGHEG2an1EZAiRTTHq6i2i0/QTh/HjPsA+SNEFpJbECZR2DvZdJuvOQKWC4M3YDnRdBU2SNRd91/dl6EVVQsHfAJahUKyFxLL2e/NX5hbcZfc1ctwSsFkvpPOpWEd/hO6dTKbdjm4X2fXar+s3hSUEoz4u9oK+R4fpSTRBqPx0YR/oL+yUasIbRFZcbSyqdvFG7bYB64OQazhauIUo+IwSNpt1Rq8RHIjkM3bBww1uUQRhbc4xZnWUg6TKl2nSi0D7jj8Q50se+qr9ziTmE6lWLh51XVEV02fPC/ahGDtDL4PH5FHIqkAqccrrVLOtmBSKD7EYh51c0R7U9JwjnS/XDw7J5x0Na8RBpFjEaV2xrNVZiE81wgeSD
 w+q6kGWb
 fwK9v1MdT5Gy6J12Lkle0sy+GbKFgm8kXZViK453iu5H3uRvER/jkyP08lFOyGphQFTd2tgu0Xaa3k9Z7uNuXiHrscqzoQpeYParwbJTG3KEGRn4oIPEZkfdvMPtFKhXULeaq96QP1nGo4e+VeFI0rkA5Tnqteed5fpJp5qyviqB3mmJNhbyKbNT2HekAs6SyngrhZxi4WQnSEyrBI9B8+EPCic/+ZgvGsra3BBVWCa+XVZVKXSfG8dCLUY4vOIRyXhRrK+Xx5N7aAjBXUd130v1gT0FVTdsihJXmWrys+3RiMwQr46Vbq1Ggr9ty91w6edDeAkQUpmTMOscQOXF/CfJ8sbuNy72hcgqnU4084d6h9OVNoKaw6tOOO/pNgDnBLGpUKO3qreTcmwfgY/1ctwbGpAb7vpw4KfFjumLX/SE+23oF6wfNUJPzhnhIga7h3C5vuYzkOqpkRnMwLRqqhsgQcrpMJ9UvVBHShMQwKNi+HaTbQQ1WXxD3C5wnpdtJ9kW/6NzTa7Y2jbYKyGdf+CE8pybb+y/wGX+D
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


