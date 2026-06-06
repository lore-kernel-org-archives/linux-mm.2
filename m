Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC95CCD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 06:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3386F6B008A; Sat,  6 Jun 2026 02:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3106E6B008C; Sat,  6 Jun 2026 02:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226FE6B0092; Sat,  6 Jun 2026 02:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12C9F6B008A
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 02:11:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF59EA03C4
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:11:28 +0000 (UTC)
X-FDA: 84848465856.06.F5F291F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9FF04000A
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:11:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dbfJX//n";
	spf=pass (imf12.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780726287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
	b=FXSFzKo/KIkSdFBe7SJlBlqFp8ElFCiNFNd6emI2M+cxC5h8eJQPqwX1NPIF1676fXEFwO
	Pa8ZEratapkWFTshJLNJaYapNg7k56kMVZAl4dI1LY1LLJ9Yssd3rCyBYRafHK0li1wFCH
	ZKoDRnze39vG3XAdDFP/aSICD5/gJdI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dbfJX//n";
	spf=pass (imf12.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780726287;
	b=uqbusYQrbbCqPT7TDwU9o5Q+BlXyWh10AfiUvwwxuyA75++EWFeuxCmP8M+pn/VI5U8aSR
	sS8ffPQssz8bY4hdPka7wlvrq5rcQDGUypNqlBb4CoBlFv4zvKkNIxYZsaFMvDE9SlVnMs
	lgfO7F26Tyd9/7XXA2KM5dhYPVQVKS8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490b4e1ade7so28379635e9.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 23:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726285; x=1781331085; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
        b=dbfJX//nUrldY/21GFb7dMxvBHxvd26yu4pzZmNXsa3iBf91udL8vSCPqPogaKW3E+
         jANzXhnAZT3hG8drSjG/bdlEv95JRA+GLxGqL6r8HXqqKL+XdebYkfc+2vJhK/njDZHR
         OxzjRegBkaPwEFFWAF54NN6khewHOUKkEp7t8GmRTYmAla81ueSKKErrQfJTyX9byQV7
         qCnYQNU/HRPZPQoCDuC31dDUnmhBktT1GpA59rP+KIpqVlgK4Yuc+J9CvPwkcrXWMsWS
         XaWSyQKVw+hcT84AereXlHSi8PU0xYNkGxY52e+xK6AJmh3/Rt1F7ebjsm6lnpM5QewY
         2m6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726285; x=1781331085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
        b=cSUP1vo5syZEVUZGkLEuoob+7IqWgqmL2BNHEWUpM4HgIZYH46bBQbmxX+S9h42K+P
         zX6w2gPF/lhDloAIPNXSMOopBENj37HH3JORr+MxARt1ifo1x0ZOfr+wFwhKATOm/itG
         e0U7N2RM1Y9Lvwfb6G0nLQVkZzBHm4aufe71zAgjhM28hoRwSSwY4Wrh0xKl61fN3vsS
         1MgvJmn4Lk6mshviG95ym5wkT+7VaGWZo0I/VCdeIMwPpSr4XAbuGNS4b/HDHdVibfGV
         yHzgEaRqGRwKA0oy5BlKAHlPn/Y2OR34ADTmGahzeRQEjuc/Bjfq4WftUCcKIg1tTK3K
         DxUQ==
X-Forwarded-Encrypted: i=1; AFNElJ9G2eq+JgG9heV0DjcTs4G76j/n4dqwYKqjNpwSbsw3AO6JbnSpd4k/aTIPUBKJKiCxBnp2jGVqgQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2xQ/OKV+ZsMyrQX7+SjU2ouGMko0rnuvDkJYRir8B2gOwHU/H
	c2wpESeYVu6aBeA7DPrdxlSV2rBdsK2j/varFYlze5N9CkYkbNEmtuAN
X-Gm-Gg: Acq92OEzeJWtLK29VKXX8S7QDwFV7w/iz3OTV7T/a+Z/5n/BIrSqtwIovo98rlEr/r+
	x9yI8BGrAnHd9qKliEE0NfXijOt6ij3kEQyvm8BmujgaOM53b6et12k0eJRtDTJpqgfWbf+ZCcw
	YmqnBZ7UBCIvn9LfDMzsFWZSx4lzKAkAgoweZe3ekgzqpg46RLCN9FQbC44GRZAEvoUZt+CEbVU
	iC+kTArD6b/cSgDpan2eiRURt0HTVXFjEgaQ5Umh8ob5PmeyZ0corN/9OuDDDOLpreFna3U/7xC
	ThKBKVk+kY+w2WQN9ldQZdVbl943bMuhppeQxhRA2eb+l5fSheXmjhsQZK+uoeLtXSAcl022rLb
	4BFhjyjavH6ss9GJ2WC2KMdlB0Q4C2wBKvYPigTv4JXBNwmoCd9SRmue/ot/bITFYOQcLRQm5Q/
	ja4Py+ytfTNn/LbjIYE8CAw8LW19grYbPlhe7R7krl
X-Received: by 2002:a05:600c:a117:b0:490:c2a3:3302 with SMTP id 5b1f17b1804b1-490c2a3336dmr71973635e9.35.1780726285175;
        Fri, 05 Jun 2026 23:11:25 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490bc39e024sm273433555e9.4.2026.06.05.23.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:11:24 -0700 (PDT)
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
Subject: [PATCH 1/5] vmsplice: open-code do_writev and do_readv
Date: Sat,  6 Jun 2026 06:10:27 +0000
Message-ID: <20260606061031.3744880-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
References: <20260606061031.3744880-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E9FF04000A
X-Stat-Signature: epb18gp1ycmdhiosfn4dnqpi6nwnacz8
X-Rspam-User: 
X-HE-Tag: 1780726286-350347
X-HE-Meta: U2FsdGVkX19GpYtzhfXfQBrFNoYG7pDIKRycodk9lONfGJY/hP3X0xZfegovv8T7whjnZxIE52EhZgaNKxIk0gIKZ1n8gVs4cb78Mk6F2Xq8FyP56UAv3stDG8MAtqYUdEC+9k1UVz4T51GhAyjcl6rnPBGPgC9R6y1OUI3TmN9M7EjfJhRD8upvp/FSjosBo7dJ8GsqR0Dgtw5mqPZM4WDibUBineO0d568R+XJ05WGWp8cH9R4pZ1NPk7UpzCcPboq7MkVQ986Uy7PjLv0JR7U28Vf+yWEqB2BV4YGq/TNiZPIlkVwfRYlwvZ8FKA3k7mI03lXIYCSZkTvHvD6TpRu7e5OPTxrzYRx92FEnVwPgRgSXeju2oh25G0tauGBdAiIuKjbMS8T0GHdxV5zQxWiUkLfeVjF0+fHkpwBshMqOBmeU0YYf/TSTRiweVjGmUcx5qHXY6o3WzRg2P3p9kX/NBcSs33finP0CKg8SwiihkiKcPK79QxGDABv6GSVv+dU0jFJeDkWsg+12/mn5xXzMd41sl7HZIDGohm1DSUWodHRMKN1g2gHZmndEK0X5phjciQ4lVJ/0cnGgrvCBYDefJmtHSH/yumv4G+7YIcGhb9m0Vga2k5w72SfRQXOT8MCISqbX0l+PWXPzVQYJTLRH6YpfrCf1ntTadbbSCQhS8p5Uc8HOxvHc+O1joEkiFmQzVpWxHjB+u2E28bP2h3ibSRd/dORlC0luVQ4ZlxbnRziMx5PMfabulZLNDeAXJIgtZt1fpXLgaG5cTPo5GVRBzBB340sd0JaptY6N0rn/uCcEFZjaTvPtZemiNtb19eQbS+jy4tK96MoJWVWEqQ2a6csviAFCPRM5RADbMbf0JurWwnzd2l1L+WhwHIUrkO18pxcvuuzgkPvU329yOmfEeAnjLwJisTNEAzTtPqVBkRgD9A3oxZ1WYWm1T3XW58WC59E/wzc7foakn8
 vwTRJmS2
 IWDcVWTZgTBebroHYe/H+r79tJBk21fy1dMxpppMsNCi9D/Z9Fyp4RmUfuyxIG0JWwd97vXqdcSsGzZ2kwVra0e604CS1XD119p99dSYwj9qkOU0fT3cycIk95KszjzQO5xOnu9dZxB2i7ifCsUsh6758YejYj1CFmOn7T6B1/51O5K+TtkATzVWlc2qeLjbOVeordvaZP4Tjbn0Cz3HpNTSVRK7sclqmTPcH1hLNz1f8WH5CNpaEbd8SuDjOnyZHrM4LoqAdkkjPmVAZBTnScam4Q+3ho+Q5AUulK7Cn0S2G+HQKFH80O7vtyVUs/YVLwSO5600/6pktSjLROhHvkab9DARBVzJObSloWlwvy7UM9dxF2TKp1nb2AxQpHeD6tac1ztcWvrfZdIRmTcxBh+I8R1p7b39r7B3ilOhg26+o4Jy1L59dc5lk/JUnv0OTegS7AdXJ/wKEwWC2Cevm8Y0cAsdrq7oul6J4dRU1RdTdHQJUBjBuM7mm3yS+uJN0DesnuNj5fQ7vGh7GhXVy/L29lYBOYmyq66pp
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


