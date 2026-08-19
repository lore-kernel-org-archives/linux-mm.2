Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2884FC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099346B0095; Wed, 19 Aug 2026 19:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071476B0098; Wed, 19 Aug 2026 19:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0C76B009B; Wed, 19 Aug 2026 19:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C89D56B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 558DB160472
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:05 +0000 (UTC)
X-FDA: 85119563970.19.35E8E01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 863A3160006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDYwFiIN;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oi3boUOkzX5Fioh5QmD8x8BL+37Kty3nYY/z7h2oQHc=;
	b=JdDAxqxflaFybn+uONhEzW0D0NdQeUIG4gum6ikk6l9bhjrRl92dWz0KuI5CeExx2OMokE
	jXySiRktXW5LtNnoMvtIF0ALTkHoa7Utxt72Wfg12Ta3/N/05FBnZ5oSotwoKmW1iTnfz3
	NGJop6VhcGokZKBEKVwEFXPUa94v4zg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181003;
	b=m37NoNDtHvGTLBFwOP4g0lviP8QnaCI64zAYeORDCgHkHarpVj/nm7DYA9FYpZGsWd5nO0
	zImOfhPBH+GeNBVMn00HFYyPBsJIgMvcxznRGnALWXJ4k01ApeeD4ByTJQSt3ka+5g/dV1
	nUKt7XXp3WVqHODKrUwAIQY9PaCuj30=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDYwFiIN;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA5314374F;
	Wed, 19 Aug 2026 23:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8C81F00A3A;
	Wed, 19 Aug 2026 23:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181002;
	bh=oi3boUOkzX5Fioh5QmD8x8BL+37Kty3nYY/z7h2oQHc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eDYwFiINKf5JbSo6traJNjGvUNvKn2Unt9Mn6smDBILf9U4IUjkavUTgZifrwAqWz
	 yHg63NRllhrOKx0FYHRTAnQEAJye3rBPsUdbDyayXpuJkpFlXBkKEuuvULhKm1uNQh
	 uFw5cSDqUo8t7aYpG2l/zs5xxp+EV6lIKe3EgTZz9RB7nUbdh7VPc7eVkofqYfts21
	 oQ57GFjvCl991rqZpYLkXO1kryScw1Rl4kMbQK6S8/W0ciJkY9C9yMMzW7FzMBv89y
	 eSAs/5Hweo3P3eeNosdIxb3CuCE6WYwnbsV6466bcipRitbqkmTMhU32oBuD4lO+MW
	 oXtK+8lEO8qSw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:18 +0200
Subject: [PATCH v2 01/22] powerpc/spufs: don't dump more than the note
 supports
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-1-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3760; i=brauner@kernel.org;
 h=from:subject:message-id; bh=di8lDjxqjEUu2frXVo5i67auNBzudR9399AU6vo3m3k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me9TjBGxXp7x+/vRRGW9M5M2n/7oyc3z+ml+gd7Fy
 R/NLvMldZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkzk5Ghq0i3AvsrVfacrDG
 83rFf/V/tkh9scZ9doFOg8K4k60TJzMyPDh05Nhn5ucTt2d8To4zOzjJMvnqDo53zzS7GIOEy1h
 kuAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: h3w9qy7b3u7qdq3jhdj371z4mqka76pb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 863A3160006
X-HE-Tag: 1787181003-652677
X-HE-Meta: U2FsdGVkX1/2Xql0AljSKkTT42GPe0nKO0bFy2DDHxpO5iL5sz5VJRSkU9pai7AJe0fr0HtApuNgtKhH03c415juTxs8PTyc073aKEkI/xs6m9vx20v+dGqYr9bmzk+fHJZSVA1eHn3+1uvUVVtglD/uPLoZ/qewwQbI7LyxtZjtz7MqH+8XW/hgaztEoFaYqdKfv+We2QRLZb2t/g4iefVbkHKnMjfiHXjeGI9Sz1rwsU5bLbGlm6awLj55FSi16xRvZtL0nHqHqFKXW2+iYjI2hRGnguFXNPA0gfylRHWzXbLw8Zb09ESX2POXS7wz85h8kNyJS+T2PzaCbkz+OEK0gE0CzheiVYAQbVvRCNq8sItcgVRyLsRen8+vQa8In4Zdh24x3qy0yrtJH/1aVmkEwlIMr7zMJBF9hjDkglqSSAfYPF6M2DihTR2H87t3PtQL1cC2DhEBKjCFiEoXvBgt80t94PUs/zPhCRHsainnEyH/zvZvVNPKTwbuNub9lBwdhjrIt/+U2eRA5yED1BKHelpM7jwOUc/MDSqYa8KJLKTYnptxldxzACxYLR3+Zt2yL4pNya12o+alV4myNae/6x673HRyAu0OEE+CnT0aSUSA85nNUxr4ZU+hOUsHPxlPdEpDQSyEYMpYh5XusogCsLQ1nEyhfLlenXLscr23t7BqVqueg1Okc6MKSqySVWwfvpV9OQGEvAMsLwXcZCZ/YPZ6nR5keX+s9jjZAZKj+jNYcXepHMzf9b2C6k4UyDn0JYyNStJd6C3mAuY8guam2UgdNjVRkAK3LRlpfZQRdLasSwQWKypoRRZc+Lb4qgzzI1kuUWf6OxJ7Ugzt8FbFd7aBaQRTQ8eGmQYero72HHW6xT1qwRZ0j+TYvfbk78IxmWp851HDVmKd3UNHy4YCOo8rWSGvadOVPAaxLl3MDlE0slo+FECfsZ+R7xgY8AmFlfCvFlNIcoXHKMf
 gU77YDgT
 2pOwItbado+3uct6CBDJFoK5fMjmM9DIWQn720sFfazvJzoAk6iP3rx2yu6HPPN/x1GXmssvGqvOXeAv6t0z8naDvWGGwcn0l2jQq1MlHJ/6zD94SK0lIQcPzcer7ANQHT7hywpKq583CMyVfd6cwmXVn4T3A8i5YLeQtKyWfPhRvvsH7cdn/n+8fZn0D6MPktoLvluq3FeWZCme8qhQGwxfv7LZtrOvKTmPE71upk/HFLVykbOu8oEY6nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The spufs_arch_write_note() function puts notes in the header and uses
them to fin where the next note starts. The spufs_coredump_read[] array
provides the sizes of the notes:

	dump_skip_to(cprm, roundup(cprm->pos - ret + sz, 4));

In this call @ret is the amount of data the dump callback wrote. @sz is
the declared size. So the position moves backwards if the callback
wrote more data than the declared size.

For three note sizes that is the case:

(1) signal1 sets sizeof(u32) and dumps u64 via sizeof(ctx->csa.spu_chnldata_RW[3])
(2) signal2 sets sizeof(u32) and dumps u64 via sizeof(ctx->csa.spu_chnldata_RW[4])
(3) ibox_info sets sizeof(u32) and dumps a u64 via puint_mb_R

The note is 4 byte aligned. The dump_emit() call wrote the dump_align(4)
just before the note. So if @ret is 8 and @sz is 4 the position ends up
4 bytes before the current position which means cprm->to_skip is now
negative.

For __dump_skip() with size_t that means the pipe or socket gets 2^52
PAGE_SIZE zeroes. This also means a file seeks backwards and overwrites
the four bytes that it just wrote.

Before commit 5456ffdee666 ("powerpc/spufs: simplify spufs core
dumping") this was benign because this truncated (on purpose, I
presume):

	u32 data;

	data = ctx->csa.spu_chnldata_RW[3];
	...
	copy_to_user(buf, &data, 4)

and after said commit things became fscked. So let's truncate this
again. Not truncation means the wrong bits will be picked on big endian.

Afaict, spufs is effectively dead so the fix probably doesn't matter in
the grand scheme of things.

Fixes: 5456ffdee666 ("powerpc/spufs: simplify spufs core dumping")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/file.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index de7494748fec..6f86d87e3749 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -956,10 +956,12 @@ spufs_signal1_release(struct inode *inode, struct file *file)
 static ssize_t spufs_signal1_dump(struct spu_context *ctx,
 		struct coredump_params *cprm)
 {
+	u32 data;
+
 	if (!ctx->csa.spu_chnlcnt_RW[3])
 		return 0;
-	return spufs_dump_emit(cprm, &ctx->csa.spu_chnldata_RW[3],
-			       sizeof(ctx->csa.spu_chnldata_RW[3]));
+	data = ctx->csa.spu_chnldata_RW[3];
+	return spufs_dump_emit(cprm, &data, sizeof(data));
 }
 
 static ssize_t __spufs_signal1_read(struct spu_context *ctx, char __user *buf,
@@ -1089,10 +1091,12 @@ spufs_signal2_release(struct inode *inode, struct file *file)
 static ssize_t spufs_signal2_dump(struct spu_context *ctx,
 		struct coredump_params *cprm)
 {
+	u32 data;
+
 	if (!ctx->csa.spu_chnlcnt_RW[4])
 		return 0;
-	return spufs_dump_emit(cprm, &ctx->csa.spu_chnldata_RW[4],
-			       sizeof(ctx->csa.spu_chnldata_RW[4]));
+	data = ctx->csa.spu_chnldata_RW[4];
+	return spufs_dump_emit(cprm, &data, sizeof(data));
 }
 
 static ssize_t __spufs_signal2_read(struct spu_context *ctx, char __user *buf,
@@ -1965,10 +1969,12 @@ static const struct file_operations spufs_mbox_info_fops = {
 static ssize_t spufs_ibox_info_dump(struct spu_context *ctx,
 		struct coredump_params *cprm)
 {
+	u32 data;
+
 	if (!(ctx->csa.prob.mb_stat_R & 0xff0000))
 		return 0;
-	return spufs_dump_emit(cprm, &ctx->csa.priv2.puint_mb_R,
-			       sizeof(ctx->csa.priv2.puint_mb_R));
+	data = ctx->csa.priv2.puint_mb_R;
+	return spufs_dump_emit(cprm, &data, sizeof(data));
 }
 
 static ssize_t spufs_ibox_info_read(struct file *file, char __user *buf,

-- 
2.53.0


