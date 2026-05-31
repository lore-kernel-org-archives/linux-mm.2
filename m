Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A66AECD6E4A
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 01:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1740F6B00D6; Sat, 30 May 2026 21:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1250A6B00D8; Sat, 30 May 2026 21:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A536B00D9; Sat, 30 May 2026 21:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7C466B00D6
	for <linux-mm@kvack.org>; Sat, 30 May 2026 21:03:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B00F71C1920
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:03:08 +0000 (UTC)
X-FDA: 84825916056.20.718818C
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB8F012000B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:03:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HJKKbJnf;
	spf=pass (imf29.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780189387; a=rsa-sha256;
	cv=none;
	b=ztVq/Px12+Wv4wpLaqvOBXn6bEwCRvUvEnKlDu1CknI0KUvFXryncZLoxABU6s2Pzlb5te
	kw5j+9ld3fD7s26uilZxCFes/1IIwh9YPlbRPsz3XZeBaoPQBwOY0NM8okucIGt1CxNacQ
	ab5qXUKtusHeWY5sAy2IoqJNJ20i3iU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HJKKbJnf;
	spf=pass (imf29.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780189387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xcR4llDLZ21dX5aGAHoZFyM5vQ6lE/uFW6fHX8pUaI=;
	b=WHhs8CrLPoY2vK7DudrLw19uXSLlpfYedHDx5empMocYU33egumg+b2rVT/503Wz1MyljZ
	dHDhWqpaSDMWyKfLmUvro5FLmlMNbna5ItsJdi7fL98wvoYmnZvVZWwgGq/6Z0Zwv3HziB
	rjiRYmev+9NOTkFSGzLyHm9UXw2GYfE=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45efa0326fdso545305f8f.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 18:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780189385; x=1780794185; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xcR4llDLZ21dX5aGAHoZFyM5vQ6lE/uFW6fHX8pUaI=;
        b=HJKKbJnfzTPwhf3ysHuD2Ge6RQfZcVB+A9WZyTEX5/6xLDTVSMkTmyghmFOA+nOxUc
         RYUZj5qcvZX9eslzPCV39SUE7xInfuE9r0gEgwxxrKZqUQrG49Ns1dkjEV3gVE5OvvmO
         fvOk2E5qhaQ4fe8tyYc1vymcsMlQdeSmqL/QMQmFWy0wUISHDMp0Mv2xg7KcSavZawBf
         6AYUIbgDgEIKv6iQM/bxR3C5+7ePDg+Gu928kpzMe/gEyYBF6QtOeAfg5zbK+6JfZEUm
         s4M51uaoV7Aq0hupaU35me92CtIkF6HnzrYZEjr5jd90Y+Bs8EWRYrKwse5n4KGC9beD
         y98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780189385; x=1780794185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+xcR4llDLZ21dX5aGAHoZFyM5vQ6lE/uFW6fHX8pUaI=;
        b=LwVmw7EkC7NQJKGBGmEK0jaXW7aJyt2ZeOKV8ItPJDl6dkZ1aVw+Qe/ywWTVmmKaDX
         H4Tzk4Xt9Ej7Df9WIRJ8DlvzJEVY6/jr1w7OP7YyZG+P5m1KdmYEguCYK/PWVw9fNHOq
         4gJWuJ8o90FWyiN53BFwThrCCUOZU33c2qs7MnKDFnPEhSlTW7dVrAPkRkA9pw/uGy29
         RCJCGr5w5pfSF2Cyev8YK04HLsEC3RZLm/xVQPe023bBfnswhK4yhJSa22+pakRq4mPX
         JjFQKpARDa1aV/6LcVGtHxmm/6fNuMn9YJ9sbd0+PBzmQ80wyuVeyr7gmFca1MCRT7xK
         nS9w==
X-Forwarded-Encrypted: i=1; AFNElJ9xCrin3b77EfCF0Y5ZN8aBK9BCRBLmRjBVNq9B2lrGReLSWD2gB3nQcO70K+ksG05G8ffePOFrtQ==@kvack.org
X-Gm-Message-State: AOJu0YybNCDQcJ8q30VuEjg1ab3KsUuKAK6s4Ij+fRGeZBtnEyZ7D4xd
	opbkRT/RdSq+lR2Jr1tIyM6u2u4MB65ge53Fgdgksn6x7kyLNHcrQNrn
X-Gm-Gg: Acq92OFvWlXeMcds5PV5s6GA5iRwnnHKR/8V8PqxNZqbzR+/Nmk/0OcfjR4RJSUO7iw
	TpcE44UX9aGZo8I7uGsyGRPIuwrF4pX3eatf7wTrDVvpBZPL1XKZYonSVuAykZPf750XUmLyYo3
	hYTCJgTTJ2jelCHyjoOY3nK2Hr5A3Q85QojLqGxzqTMYvYGY9rb2JzrLvHTCEbEy1MhB70amhEO
	xTmv7m0nXR/savLs6PettWfTxRyCJMehenJm0M8DLgIofFluLmf1GN0v5mrGkgzn/t0NzsLD8qQ
	KOAzf0uxRKTUn8pl7t7HIcpISvqsUCV6H3ewBXeXhulOd/9pUFTB1aSiycHIzc/6dMYIhovhuJ+
	yRfFeUGDywgsqcQWksTRKvAJM5dDQa7dFkXDxFo0G19Tk+katZs8fxaw9ta3bPUnOxGcT7Zftvg
	JmLuXqi4OGgB6Qrl49Mjb9fzQPhFKIPg==
X-Received: by 2002:a05:600c:e489:20b0:490:467e:a3d7 with SMTP id 5b1f17b1804b1-490a2952798mr65855195e9.30.1780189385274;
        Sat, 30 May 2026 18:03:05 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4909ca6575csm218111405e9.4.2026.05.30.18.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 18:03:04 -0700 (PDT)
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
Subject: [PATCH 3/3] splice: remove PIPE_BUF_FLAG_GIFT
Date: Sun, 31 May 2026 01:01:07 +0000
Message-ID: <20260531010107.1953702-4-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DB8F012000B
X-Rspamd-Server: rspam03
X-Stat-Signature: uzd7ysx3yidqyz6u5r8idgpp7dt9enj3
X-HE-Tag: 1780189386-21025
X-HE-Meta: U2FsdGVkX1/k9Jdfl9tWaNF9GzADxrfzNtN3WAxz8aTkOhDMWWODE+EDLZufPCF8YrDuTgW6rL/0dKS4Gp1ZIDQse79lyKJREg06JmrW2oP/aR+j/azct7UWPYs7eLKsDsDjXyFZFC2AH8c1uVXE7TstV3n9NNTcXdwu+F4RJrtHcfAJAJZNLOeowjtNGsD7/+fbRius7t9TfpZW+VnAE7T3eCHs1EZdwohNFz1nJqj5HyzdMqYdKHr8rkthRQ7apb7hSpT7EmlQk6XNTVYuKCZHC7l/9WMaxVa6yWYURjLEEBBTSP3KU98+tB45kfaUVIzuxqaE2VQ0UJLk+TpoudiyrRFcoK1w2tV9dSPf/vSecfYw/+4wxCwsGs7PJJJu/VwrX+chD5X7BXYntVeFPB481VK9GqjaQ9+5Si7r6xQLXBivCvIEGvXH25rRzMI/TUbULCcPQ2VeM/rcI9nk33XJQTxdhMPtI8/fBy4xYpk823hiaR1ysg+EvfKwX7yPL+HCRrQLg2nX7frjiInxaT7NUVDdLh848/bjoJvAQ/j6Qzptkv4picapwSc+esaoYitbCoQMHn0nOn8PfjIT8HaKoQipdpcIMbT5VVufeobRcJpZpQRnEXwaluvzOqXRPdZ+UFAxPEeadfhjhUqyonYVLPM1DNydBoT+qSkydbYgzVhHA8FBaFYuFN1q9lheisMQByKb1qxn45K2qpHpfle9ENXYAOZPFtqDKy1eP1cm9na9sCb+z6/iTnXY9iVqaEJd0D9K0nnriOYbm0/nMePTvm7E7QVFOVFVrZqA3nh+tOUu0iECDBM4+HppzVSBZE7yj5DlEKsN3miljwEyOPS/BGl13EbNfNuCODdBcqnVcjInbgIs8uWYyT1mEpKkWq0qtKAmAs4LqjiF/w8bBjOJ7jk61uBUCqPf//C6LXbj4Onv7PuYKimJo7htxi/p+EqBwC9qF9sjSSScupI
 111vQOsj
 R76gX0CT4pu6n+wROeX4hC3EF2AFW8/C0wiLS/S36Ed3cX/NeNYsQ4Gwj1FITgd8ZnuZlrjdM8GblrokYdZbVdlFeP3oQUepreaNYZHrrqLy/co0u9K2/QJtNXQYpZZdRrOwSbtWqmm6H09gvuqInFTy7wdNnbD6zcT5uG5JdMKQ9KCD7aqQxzZ7uIwMbgXTa9c4bvhw4Xi6dVk7Ne1HuaBSgjTcADdzElKq+bMvLJA9BmxNS2SUT4m92N30vjFftKLhHevneOe5Bpi381X1qyeUTpPoiUWXaNh8QkxoyNG7Uah2aygjMoDWX0VXuUddBrSrqTiQKVM8FITyg/C2dlZLUsCMUukUYiJUyCJoDyHb74yG7DiYpeoUXZhn2g9Ahy2r8wRjdD01hyfEm5tQVXMPrYWURYgyZjN5Ygmyo8jcWL+uw2gUMfd49ITC2xNEOrxlvz+7KJCKbn2gMkJ2uTAff7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is unused now.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/fuse/dev.c             | 1 -
 fs/splice.c               | 6 ++----
 include/linux/pipe_fs_i.h | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5dda7080f4a9..fb8fe0c96692 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2352,7 +2352,6 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 				goto out_free;
 
 			*obuf = *ibuf;
-			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 			obuf->len = rem;
 			ibuf->offset += obuf->len;
 			ibuf->len -= obuf->len;
diff --git a/fs/splice.c b/fs/splice.c
index b1a4e3713bd6..6ddf7dd72f7b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1622,10 +1622,9 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			*obuf = *ibuf;
 
 			/*
-			 * Don't inherit the gift and merge flags, we need to
+			 * Don't inherit the merge flag, we need to
 			 * prevent multiple steals of this page.
 			 */
-			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 			obuf->flags &= ~PIPE_BUF_FLAG_CAN_MERGE;
 
 			obuf->len = len;
@@ -1711,10 +1710,9 @@ static ssize_t link_pipe(struct pipe_inode_info *ipipe,
 		*obuf = *ibuf;
 
 		/*
-		 * Don't inherit the gift and merge flag, we need to prevent
+		 * Don't inherit the merge flag, we need to prevent
 		 * multiple steals of this page.
 		 */
-		obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 		obuf->flags &= ~PIPE_BUF_FLAG_CAN_MERGE;
 
 		if (obuf->len > len)
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 7f6a92ac9704..a1eeed800669 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -6,7 +6,6 @@
 
 #define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */
 #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
-#define PIPE_BUF_FLAG_GIFT	0x04	/* page is a gift */
 #define PIPE_BUF_FLAG_PACKET	0x08	/* read() as a packet */
 #define PIPE_BUF_FLAG_CAN_MERGE	0x10	/* can merge buffers */
 #define PIPE_BUF_FLAG_WHOLE	0x20	/* read() must return entire buffer or error */
-- 
2.47.3


