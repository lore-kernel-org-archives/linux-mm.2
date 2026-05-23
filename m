Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EEBCCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC6F6B00B4; Sat, 23 May 2026 13:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4996B00B6; Sat, 23 May 2026 13:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0A66B00B7; Sat, 23 May 2026 13:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CDB96B00B4
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:56:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B1C0120B43
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:42 +0000 (UTC)
X-FDA: 84799439844.19.7E8BCF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 775034000A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBZAZdcE;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779559000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukrRzZydclNePROfQDTuyRdGagizkwrv8BiO6E2x4AA=;
	b=EoFBlWQzBc+7c6YwTF3t/yQ8FPiHWGZHkxW6zUWT4R6YVKJ1C0A5KV86h/qDYbdA7CQyuH
	Zw4naI7O0Bchazhi9dE65MRPGjbJOGDPd/MJZg7Pr3kANlg/p8eBQkgsZ8iUcYzXoGxd1k
	S8YvZ4+sZBPp1ZcP19Zp6PmxGks6RiY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBZAZdcE;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779559000; a=rsa-sha256;
	cv=none;
	b=4lztCkC2LtqZG52GPFolvLfgldTmoK2WJ7Fxnj3XaA16HMGD91RRVLA6mYHBjh6tl2WC8t
	v+Ybh2swcbjMhJOzeDpMJN3EYrvdETJYisq+xotZFtWaxb3xvdJuTb8whhc7q6qED5PgyE
	IrczGd43aheRIWA5s8dSVa9BRtnwZkE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E880B601DB;
	Sat, 23 May 2026 17:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30DC1F000E9;
	Sat, 23 May 2026 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558999;
	bh=ukrRzZydclNePROfQDTuyRdGagizkwrv8BiO6E2x4AA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BBZAZdcEVz/p/msk+v6WT2AsRtCoFYBx3Z0qlKQpUVbqTTbkufOrda1SFIO7l1SpK
	 0+apuNi1AgkI0nv8JogTKz8wOv4b5mpvv9u/xDPzwAED3kA3JFSABvqXVcMQHbe+lH
	 VfZAKI61R0AS0GYB6HHcfVezMPaXJquvTDImNyT6NiTXW+RaW6vpy7tY0D+UKyAawh
	 jCVkOl/9QaWWRWLTIeXzvccQTZ8YykJTCul62f93TjwBE+wLiNuNiL1GEnrH4p3nuK
	 9ErpfHG5KC/WNMAH6vNpsC3L+3apRTMtE61nyfp/IroAR1bZ/zd+pANUHOaQfbyAvV
	 D/d7xN/FwOJkQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:28 +0300
Subject: [PATCH 16/17] binfmt_misc: replace __get_free_page() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-16-275e36a83f0e@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 775034000A
X-Stat-Signature: 987z8wjyh1bg8z9k6wqyrtbt7tz4u5ai
X-HE-Tag: 1779559000-273511
X-HE-Meta: U2FsdGVkX1/fdX54zpNzYYduIaFYTyxqZPe8qcEMkCNvnwD1gWfnVDet6FpfFkH3fZqz/c22ymCb/fAj3W38qvPOwGQEtCm8nNTKkfLGrDyilh4lGJPvPZbWuRiIQSvon7ebLCk+VloWsdB50TeH4h6Q1Z9HVS3V3FZlwq2lLuGyAtBER8ptLxoQupmRyYyHrXT0uJFB9d82eGuhn/TJBCAxS/2/oP8N0IurXBhMUBWkdaVzOWApG5K4ewQQ3RGyxOeihTgo70eGZyJe+BZNVJ5q56lySKVdDq9VV8YoaUtcpxgpRfXvPj+l7rXH38wXamLclqTgoePIdFg+CKThZtqBpX12wQKUzPd3xM1IDPDLDzhmqJbU7oSJx2GzTlS77h2HEykpf7edsHp3V1q3IiE+yPRQr2UTgrwXzDe0BND3+GSLG+q8OOeNCPoVVw0tZABIthgxRDvQjJvP5AtF3V0Pi47y9HcWlrXxyyQjNoUtnhbbiHKkPk5oP/tzO15kvjK1nwQlB8/T6zCGrKoljHJE1tsxPzzwbynoE6rnDNo8P+ShPltko81FddDMArJfgZCLYabjrR+86PMbZanIipobN5QCqsZFx27m247O62ekUQVC608jfmqVGbsLLLQSFVD+jbI0mDc4Nqqq+d8LY2POTGpd9kRIO6ztI2LE+5xuMtwKvM02t0K+useBvYS71N8i3aQeLY8QN0GYXeCUGoN68/FRQ7N/VvffYTCoSMXznKPwppfFYt4uk3/Bi3sePGbdiHiZb8QK/e7SsHOjtbDYFi9aQ92yvI8PW67H65QF8PVof5YjXBtua5XK2zXSH+RHL/7aC6n+ZY6BAtgbpPmrvOg4SRkYKx7mI3tfQi7I+bIH1nBUUqwWI4gwVI5t5JutM+Cvt6rNPTD/cotYkgzfZrFJSY94SwdHqtXOgiOwqlmLIAoWGk9MwdNsmUFnVaFK2yaxE6bc8D63Oah
 cL6Hn9A5
 9p91Oj6iwyS+kUGhbXOhn6d/Y4+r5vsZgFJUr7ZhGat5I1dtQ21Hikn2++o4o2+Fl8vu0z2Ln61kt+ZAQ5tBmLs2gRBMPIChL/MsrxO7/ztzpq0Dmy+WBJ+bJ8WkBzk9Nmj/iLkW/RPyGRgaPHKDeiSbF6mRxvIrrCkUkIEzd4MpG7in67lkppBrrUn4Jku0x+7RLmVUHGDcENzRyQjwfNXGRLhFBM6Q7c14Ui20ePJ3u7G7UaEYtdFhlhKRp1aNUm3716E6BCe/6HxE8yo9+nHHDzAsyyEHlua5+bj0MmQUJsaXou9kjt2GfPImcF9phZrVn42jcAk6YFWdtiDZ1pZ/vOfL3F5MJ5pPG7H3qE6tVV0A2kN9mdZvjevcbEyVuYi00
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bm_entry_read() allocates temporary buffer using __get_free_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/binfmt_misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index b3d8fd70e8b1..84349fcb93f1 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -704,7 +704,7 @@ bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	ssize_t res;
 	char *page;
 
-	page = (char *) __get_free_page(GFP_KERNEL);
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -712,7 +712,7 @@ bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 
 	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
 
-	free_page((unsigned long) page);
+	kfree(page);
 	return res;
 }
 

-- 
2.53.0


