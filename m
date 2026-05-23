Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3152DCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5BC6B0092; Sat, 23 May 2026 13:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D8F6B009B; Sat, 23 May 2026 13:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DAAA6B009D; Sat, 23 May 2026 13:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD486B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:55:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EAC6140B73
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:12 +0000 (UTC)
X-FDA: 84799436064.27.7A6631C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0B3F1C000A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IK+wo7hI;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/3ZZK1cCDduXYXcxKeKlOpSrmrsqWH7N/ziUw2jSZ0=;
	b=Jr7xPWLX7TLeC3wtWn4TRyUhjBpLnKgKtOl8Mq8L0c9ARGWqRhSqFNQXr2MCKZ1RfNuPj5
	BkZAxSz4WWQVFLfK2A5qTagzlSL6xwbjKvo8GQvSc/pcOe2JRbbheXfpNLUI1hbEjVPrbr
	z1oCW7TZ8ffbGA02gDawaSQ2VIjELNM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IK+wo7hI;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558910; a=rsa-sha256;
	cv=none;
	b=tMyW5CVPBwr0XSiRf05flzZ0x7ptdLBAD3Btcj513EguiVICSsrrIPJ50n5qN/pGVAsnyQ
	q5G1GIZQszgeF8TB+F57Un6mZSWgnyktVZ9JufgfPmqiXmTETiremo5k4PI9tH12r3dAq/
	ARbYtXRl4OgdnB7U9bpiuMT51i2M5WU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27E3860055;
	Sat, 23 May 2026 17:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62951F000E9;
	Sat, 23 May 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558909;
	bh=v/3ZZK1cCDduXYXcxKeKlOpSrmrsqWH7N/ziUw2jSZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IK+wo7hIR3ThlZ8Syhumfwrnj90K3fG4pOcL68OF1GGVeRIyIE55lypaqrwhkPQBp
	 TR7+D2SKUENtlQm1ZJfKj1rpPgJEwB2o46mX/TcXx2bMBEmBF/XeID3EiM7gWCjKBR
	 6VXPIg75qWarkDd1bOPZvZO1/WArLxZZ1fXNQ+SNBWzFHWwoLDA2ghQliJUZaLG5yV
	 RZU5VhCre+vUVnCKvEtvHsisSf4UJSscfwKHONUrvvD0yN4AbdKIMb0VKvCjZXjjzq
	 xejc85BC4vEANUbQl625iHtC76mIYLb8lEerln76aSUcPnNP6oY8bi+TWI/w6zyA36
	 vAq3u0qURaKMw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:16 +0300
Subject: [PATCH 04/17] nilfs2: replace get_zeroed_page() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A0B3F1C000A
X-Rspam-User: 
X-Stat-Signature: jac781owiyiyaey3zmj74igcfwd7p63h
X-HE-Tag: 1779558910-781654
X-HE-Meta: U2FsdGVkX196XiemNM4uAx3eNPa5ei7aJG+4KidN8RYPl+SI0x0CttLQZ9QjxTqqSiHVrOOStTDa2y44rhDlQWSL3QNP5f8OoLTmWcATCxxZBqdydyFsKgGeTb+TbGqDZrVYnC4PhDEJ/c57K8yX7TVRY7xtD9kBoLAgcNg7rdaUO+RtMrkwJ/Yl5And4k6QSo8dVllFV02J0qC9zsH2yBK69LtCs5MWAGSqON6120vlZMG0HvF/+ug+/cjYuzJrxIUhvkRRdk/z9MBG3WSzvWdhau6k/XVF9QpUBXKjU483ByqqWNlZ9rxJvsq6Xty+GJnUPZNAAMyzaa6UlAUK2WR1tHNabmhDtwZ+oaP05dpI8TrOWkfrquNOvQichJcU5XBgfQCFQU0rAR7JtSE+qNLz7IfJW/nxkTncet97WkvxOJ9fK52mZMo90k2pQPm0Kea9Q0DyrufOnljXVKaK3begGovwL/TrTvmuuhh3wpbRdy1Px8Ut/mt500yLntdE/cQgNx3OqHsj4rnQBVadkZSNmHxC4FMUFjv/Nehr5GUNiszamSBM/esZXNmXNAWIxASDQcyC5h42Q2fTFdtW0/LfOLcmbZulWLLmsux8HxLI7wVbhNGSbHuCezQbrlzmJxmfEqrrhQsHL436IWOR492+/4MPXV6i98QyiLLfqkNJ3/PQI3tOyF+QSVUgWMNrhjJHDklcTGtznOkoe6QhmfhpKNHCP/xeNkV5GTJycW6YsZgsyNjV+lA1+vMY0yhsmpWM7acKGXeKTBmW3a0kJNI6AUIMBPNBmpSc2REKiqhMGN2Mnb7fK09FABO/drsYZAxNsi41SsJkNqEcdyKw4Pz4XuUCUpBj963vpshGoaASN63ieTkTdrRmtgACJwCXQY7i03OiMuYpjV56ECOKJH10SHBCW2IvTlaKj4z9E0SVTrKO/PXsIFxBBBdwB/7cCFtFMknboLq9zjEaDqx
 GWXPUS0r
 RbTOfqStRxiEfrZWdzgbs9+gJ7DG3F4kfU45EQt1sKeo6HoTweAHkmN5prLezucrz4nmzib6k5OKDzEwt7Rp/7ZEVhUcuXB4eCi3ZAyB+cfg5BoQKV35n7P5+nu8Qj1Mau4WS7vDY8WFgqN3oUg1Eb8uLDHEzLZqYt8q6dXgv4EaeVXNlSoYnrW6+LF30Ug+/38DOwS1yN5rtOXhTgWQAWHEYFqnlYjHWCTQTSe2NFQelw6lZtoCM3jqUZESZ3VoWysaCTTEKCSZGZgZHf8XEwACbaL2Ym0BPJNAkqhlai1mvA0ugysUQI7p1IPwgjeNmYKxkT2yFy2n4fd1c7daD9sjIJsGkCBPoGLUTVMPt5Pf1fBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nilfs_ioctl_wrap_copy() allocates a temporary buffer with
get_zeroed_page().

kzalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of get_zeroed_page() with kzalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/nilfs2/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index e0a606643e87..b73f2c5d10f0 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
 		return -EINVAL;
 
-	buf = (void *)get_zeroed_page(GFP_NOFS);
+	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
 	if (unlikely(!buf))
 		return -ENOMEM;
 	maxmembs = PAGE_SIZE / argv->v_size;
@@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	}
 	argv->v_nmembs = total;
 
-	free_pages((unsigned long)buf, 0);
+	kfree(buf);
 	return ret;
 }
 

-- 
2.53.0


