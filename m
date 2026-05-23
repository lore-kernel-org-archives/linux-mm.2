Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5571ECD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE2A6B00A8; Sat, 23 May 2026 13:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5326B00AA; Sat, 23 May 2026 13:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902646B00AB; Sat, 23 May 2026 13:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 806676B00A8
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:55:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47A3F161B42
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:57 +0000 (UTC)
X-FDA: 84799437954.11.7D7CB24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9A1B31C0009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEaGA2By;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxGF956OZDQJ04Ha1BVCIxFwqpuZT0QUw7PeeB2x8ho=;
	b=LQviEg6gIlOrQDgU3wL2mqIKB9//rziR2CS1qt9LsxPYeNy2+wrgoXu/ffGymepUHmJKf5
	rDwEF4CnbUU9M3FeDK7OGlda/9jUFEhbBwCj6Pn9GqCzYoI4BpRlEFD8wuKzJNLfmf6d3o
	ec9xShET0bNztk/7s1DkJrv0cPp+fsM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEaGA2By;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558955; a=rsa-sha256;
	cv=none;
	b=rjLeeVi826RvbDErxFTiHCy2HWCeCws2nObaws3kVySrdqKNV5+Zi7H6AqiU2/qneRcRTZ
	/DB8Suo9bES15PiMYJEYSGCfhwL0Owq20YQf7V7dFX934XQNq4JoEDyhesuQGkeRcbGfhj
	mLofdiFacKJe5RO9bcj8JeljJgdYAbk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5DFF42ABF;
	Sat, 23 May 2026 17:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1771F000E9;
	Sat, 23 May 2026 17:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558954;
	bh=SxGF956OZDQJ04Ha1BVCIxFwqpuZT0QUw7PeeB2x8ho=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FEaGA2ByUVUb4gzO0lRcyjGQi2EY/wCi4EyO6v8VtYTBWBx6YG7dKrg4vMqbF1ooV
	 WAUaxnU8AOp55vwtaP+3UQP9ccPWXV7xJpiq77GZF4K+RZRJH0UgOJsTSQrvBD4P6G
	 TnjCadP00pKGHQhzbjpVokPQrVZFpNTOwTpF3hLxUvaiX3A9L7Tq8RWx83HlFJyaBt
	 QEFNZTjsw+5/uNOPM2Bcb8E5O+3sF5zx3jplBNPReyTS53Zy8H+j6tiGYQb8h8G1Kg
	 646TOOJKUKfrQ3su+L3yeG4CfdpIKRXcovoEsdUEqQJhDFky4dSvKqdEKX99RF4YJY
	 NJA9X4Sl9FkZQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:22 +0300
Subject: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 9A1B31C0009
X-Stat-Signature: xtw9b7okmyac47jksayd9x4gug49pu74
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779558955-603278
X-HE-Meta: U2FsdGVkX1+X70x6XoOXEpKc8RhfJRWRqMquoJMnVT9YxRdrRjIZjXH7mYJI5e+xKINmsSQWkphk8YdWSy7lFPVvvUQszXQmSl9CB6TZwdsCKoQqxuFaV8dq3URsB/us4RkUVJpDKnD+vO4y7qXiHjvVrLFNw/rgWukZt7iSq42hyajVRejMy5FImEWthKv+JyT94o165edhWwHCPWCa4y46gzp8JBTOLFIfDxmkA13aTskxUvashqDSGh6cw9hEeVT1D2AuaJsrVdEOYJzhBoPc1N0pprOBJGN+GPBTSF3Cy5Kbec4hj/XTpPaR49JLZvJsYEzzMinXl3S218CP/FrnczXjGG60YF42lbRtUw/ffGt/xLBKvxjPkkSVVHWS5i6tJQ/s41I9NdYdZZ61EJCoSzh2eKs6arxjObZs66SYPd2wUd/x54sSO1wdN2xwGCfpIL4jAIGBfMUeRdbaDNBKihlxf1da02wkHN1kWHN3bsBH3FPAmVsUDRwF5m1GdKf0ajxZ7ABLQG7bqHwWM4+DsZHbQZcUeoeetqdbh8wiVj6KLRqQ+nQ2ZARz8quVkin04dkmUY8fsrL6H6t+xZDlxYBoWPfNfi+FqhfLDVuExpw2/Lnsdv6jzjxAdDXDY2k+QwIuHMym2rTL2hjGuEzGMHY/0RfFVIaR7kKpn2nHqkbYc8nMlnu9IuVTaW8vWT322SrQiHBZacrCXW8As3lweqZYa3dDePTS49hMnYeY3xRZT1Pi9Fasa4EP7qBNd4uYnTLM5f4J5RZndasf5vYE+RhyDQxijSI56or8BrCTQew+Ia3uxnFYMZx5BZqygWnTjxN/JmNPFgowEEspPivIuHQkFSUqfZAYdXssvo6E9txezHOQuYZUWa/4njWXtEAn4raQtqPGhWghcVKXxPKxyi2hzSQBGJIuMSXEMBBPhqT5nqwJ4Koa3USSB5LJG3MoRewcN6b/wSNQY5J
 pgWjD/y+
 Wkv9h0ZuzqILFQtu9dhA3qz1UpZte2UGdDsShTjOXdR0BI9ZMhHzxaikgoLnA7RLZsqW+0VfeL/q2cx8MqPNC09foYHRnfqzyr8pBbfqd4BYn9/xvlnPPYBael2+gD8aJw1wu5im8eSv+KsNGboCBM294xi0FDDjWiNEO4OcnzEyj98rYIpeqOwUpvtV3mCVWtmICL86zXMI+WuRUOyIxQzLvlicroWbb//GICI4pgrAfXQH44nDcK5hz1AZzs0fMlCOlrwvfjHNPqAqafI0qYQ4PZ/FCXshEPtlOwGmxjEXDIemKDZ9GpubLGWhC3DEVkeLVaZ9iHJ+pessdg9CZV/KDaKn/ZeSugVLCZKzspxY8R24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

jbd2_alloc() falls back from kmem_cache_alloc() to __get_free_pages() for
allocations larger than PAGE_SIZE.
But kmalloc() can handle such cases with essentially the same fallback.

Replace use of __get_free_pages() with kmalloc() and simplify
jbd2_free() as both kmem_cache_alloc() and kmalloc() allocations can be
freed with kfree().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/jbd2/journal.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4f397fcdb13c..1137b471e490 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2784,7 +2784,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
 	if (size < PAGE_SIZE)
 		ptr = kmem_cache_alloc(get_slab(size), flags);
 	else
-		ptr = (void *)__get_free_pages(flags, get_order(size));
+		ptr = kmalloc(size, flags);
 
 	/* Check alignment; SLUB has gotten this wrong in the past,
 	 * and this can lead to user data corruption! */
@@ -2795,10 +2795,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
 
 void jbd2_free(void *ptr, size_t size)
 {
-	if (size < PAGE_SIZE)
-		kmem_cache_free(get_slab(size), ptr);
-	else
-		free_pages((unsigned long)ptr, get_order(size));
+	kfree(ptr);
 };
 
 /*

-- 
2.53.0


