Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A672106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897B96B00C9; Thu, 12 Mar 2026 17:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883076B00CB; Thu, 12 Mar 2026 17:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751AD6B00CC; Thu, 12 Mar 2026 17:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6157F6B00C9
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:47:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F7011B6F5D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:47:57 +0000 (UTC)
X-FDA: 84538748994.10.C04A118
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1F38E14000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:47:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="c/pw77uh";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MVii9L11;
	spf=pass (imf26.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352075;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/Ak1KPwTmCaYgI05wA4foboiqmq4A6jkZq9iOG+AdU=;
	b=OMY/Ea1YUMTxAtHG38Gy+pOn1aXwpPV8sjFvbOe1qKgqiOXCnr5vTKGRgNpz8U3uWMS27x
	+k8vviBOFHOPsWmZLXRb1GdDXxW2X3R2YGTalFpu1jBUtXBB1vsWzGYCvy+o2AqsNOszDb
	atIliIJwg+ZtxA4alvQSaGMlqOISAXw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="c/pw77uh";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MVii9L11;
	spf=pass (imf26.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352075; a=rsa-sha256;
	cv=none;
	b=VsK6RRmrlWTMce89WD9ioGHlqx2Pqo3TnIzOuO/PUvQnYTntjYZqe00LDkUOBdqpEwrOQC
	7pOhiVdh8y7UJjRTPYYlFCjlqgLbwszKcLr6ubkk4e4t5YZi+zGnhbgw2UzxXU9NkULsEa
	sRQz4yhjJABWM9WkvjnLDJyRrQF0IaU=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id 3C2BB1301B70;
	Thu, 12 Mar 2026 17:47:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Thu, 12 Mar 2026 17:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352073;
	 x=1773359273; bh=W/Ak1KPwTmCaYgI05wA4foboiqmq4A6jkZq9iOG+AdU=; b=
	c/pw77uhzQwtu+x2rfy8YAQ8ODHIH6TqF5gjkDP3PnFVgS1yE39XzRUPiB7FP2sc
	RbT2SpGQkTPfjMjryKRQmCrUB49ETvDmOW/QLdaS3hsyuXpnCKPp4KpaG/88uh2b
	ZXJ9+VfUjmAlAqwi0KyMt/q9CW2hdecgqwGPYM6ENHXeNa2d3fgGwlvb8qBCnbPl
	x8pPfpV5ACsdJEY+vFgnJ5ttUL/vZ5lzs0FJW0pNjeM98B1mNj3S1TLDNNkpQ85G
	mrIMwkNyGULMNnaoWm3wi2W8zO4ZyGTiZJ5fNsPnxumyHNOH7BM2cdOc/C+ceQbo
	7ROxYdy3UdkLgEgWoNY5Lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352073; x=1773359273; bh=W
	/Ak1KPwTmCaYgI05wA4foboiqmq4A6jkZq9iOG+AdU=; b=MVii9L11GlwWtMhzZ
	n7iyDbPToR7JKb8T+MC59sZyBmXHZlJqZHj7ZQZrD1S9ZmYRwTLXpkBTfH/AH0ql
	XbK/noTmtQpNxvag+selT8UbNrzr/8IJl3kNxMvGZTLR+moT9KOT8al3IGiwNRoX
	j8ioh/jBUoLeJqAxmuqIyXvmtjLlIL56VrRHOV7H7mbB6T8HJiTueMd0tykadvXM
	ZaBajRtT7ugnSgBwWXivnDrJCmaH1qiDVbS3t+bJW+z4Vbk9MiVqyz7miWcV9qju
	MqrU8tjGSX+VM6REOR8up7aRz4q4674wBNNCUAlZBuJh49XTJzmrGGb3vo1RiPrw
	yZczg==
X-ME-Sender: <xms:iDSzadf1MovIDDvvqQ6m703oltGBhRnngp3beiLGJSJZjewqpRJxtA>
    <xme:iDSzaU7kFxhIoJWxE1RTDf2t8oqexnxdhjkbXG5N5FUMS8uwy6w-AM73SOEtbiuBF
    uOE7IwJJi0kM5W5JqOt7ALX4wYtbeJh1HFlYN-92h_1c4Q>
X-ME-Received: <xmr:iDSzadcoq5CrRqaaWti1CkFPSfX6M4RqKzQeN0yflSVg43UjwueDpXwh5Ys-4gY0lPdS2gJL-7qQvNFXh932_SMPRpiOg_iMtCeNxLYNWhUq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohephedupdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:iDSzabCq_RvYJXtjKj-mxXj8cgaSwK2kgE6I7mhCH7RkS1KGGqql6Q>
    <xmx:iDSzaZFUzlkcAnxW7y-rWbMhjamfWq-Vptqs2x39yx-7jXjO5-Yr2Q>
    <xmx:iDSzaTigiLe8tZx1JISL5ztxucDTqZ8xpdT2bkQm4n8qOh17tO6pbw>
    <xmx:iDSzabteC8QKWKodA79F8ezpVRGSzyCRtk90G-w-YL6UtlIT-rMcpg>
    <xmx:iTSzaXvLLx8QlN8PNoj_x62VFUWwQFufxUedui_IHwRwfAfxnUhgOhIG>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:47:39 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,	Carlos Maiolino <cem@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,	Amir Goldstein <amir73il@gmail.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>,	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,	Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>,	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,	Tyler Hicks <code@tyhicks.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,	Jeremy Kerr <jk@ozlabs.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	ecryptfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-um@lists.infradead.org,
	linux-efi@vger.kernel.org
Subject: [PATCH 12/53] nfs: don't d_drop() before d_splice_alias() in atomic_create.
Date: Fri, 13 Mar 2026 08:11:59 +1100
Message-ID: <20260312214330.3885211-13-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F38E14000D
X-Rspamd-Server: rspam08
X-Stat-Signature: 6uzyzjy9d1ghjja5txf9duog6fao88mx
X-HE-Tag: 1773352074-21473
X-HE-Meta: U2FsdGVkX1/tGiG6hMZcnoFcAkdE97yutCUO+P6XHG8BbD1LKgW1DYp9dVq+LqDt3wV4ph/VvQZeKHK4+DgIUQc+DB23K55szBLqQiEt+1d5XFLMeVXSdIgA2Jz+rXF+7y8ymVC0xGp+boD/AVeyAy8pia2PKa3khX1Us1feGFtVZtJIRH0V2GNehaTYvPuhiklteNS8E6/lk4iN+m4OTqh6GT1RAUshmUEz5eLEgrP53TeqHj4Y1Y7YgOKo5Z5OZbORlrfsIXKWlIbW4SJMvZ4fGx7pv2DLRTzPYud1B0QAUj9l7MpYS+EsbK8lBzS3jN6qPPLb2r87BE1PXXoB6ZYH531dSTas7zlAT5/A94A4EQTItS2bKMhn2Fxmv96O4GBTkRRogvTY6p/qrIr9BzGrnJw9nkERd2T6ovbW04K6wCvGp+VASJ/JBSaAkxZ0UjKJas6qq8Oglwy3oDUSJrenvjhioYx/PpYS5AqtctT/+AwCb/av7GjWCp7rR6RCNeHHFmhisBCMh3oiZqu6tZDpNe//w5PswUiaEpC0VhaXRetWCwWrekjjaLJwo9b74D9orQi3FKt987nQ+r/KanV6qM++zApcu26/Bl53tLaZuuPq50p4LxruA+FPXtkeLD+WkKCLHVOp3TcNYqBF3jU+JIi0myj4Vp7tcNENuucFCTkG4xApjvqQEdfdKWk6F+R23P82dGcJZuDSddwjzYktln1hP85tSntnZSKDEKrHKzSeMwpG/ISjrgOx3fR+t+cZNIt7Jm8/tYjhUuIfEYrpsD2Jj9oWuels5P3knyDrj4jIPXluhZfIDvyqpbwz6KMo8QO8U9cXcBqJNUv6OgnVRxwo8gAmYGzN67womHYpVc9TBwb4t5biug8BKYFuPSMN5Z+9ZFwZTFn1XN09ap5x4WjlophI8cvZCu8aC5VxPiv71fq42E2NhMs97gNa9ImhKlxDUit1qkQtz+g
 chxshGbU
 17FXpMsMUDm4dj0pCPWKpFlKxYTNottzZmRwiM/6BlR+LcSneVZvmp0qJEorwu494L5zgdSaskxLF9JASqJaTQ4pqsMdhIn0N0bHzTa77MAeTcMLO8VuGiIf/lHJMeUzSeZJj0K5n6pDJLgquztC5s5rVfQO/I6SoXZVUMdQhKDy787D2F3bIjbR1PGgwfbVWxe1kzEk4mlNBnxqpUOqAOPZkTe40hXxhP+sUpda63J9MfpdinY6nlKdYxlj1OXDUha6swHh/lrRzc9yAFqksRhlBuUIQZKJEjzwH6wxKlalwUp749NmPLPX00ncKs1sNKRjTRBnJFgF51LYffx8BVzpVdonZzo2HCp5sqmyPfMhpPvXfg7UDWQRyyYCHGKCJrsTBf7tTZrLGoDdgQ0VlLV8/vxM1kz595dhZtFVTXlN9eWtulOusosUWPSQMQ/YsmvCqYxRqOm3eWmRxT93d2HD+pCszHU3O9G2ybi+pvXUuaFremPnwvAs43VQ78tV5QuVJ3v1zRz1azLVLx3Q8Q8BTiXbuxzQsBsr8WmcXz6qT30X7BwYSj0yZPJbTpze+GdDGk8orwEGcHA0mjxhauFJuMRaeqnCYfudyX1qHk/FHkG6RZ78qsK1iveDdwyGgiiWSVgcfKB9KcGM/8qjyyP7SNQHCHbyyVrYccQoTUmclTXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

When atomic_create fails with -ENOENT we currently d_drop() the dentry
and then re-add it (d_splice_alias()) with a NULL inode.
This drop-and-re-add will not work with proposed locking changes.

As d_splice_alias() now supports hashed dentries, we don't need the
d_drop() until it is determined that some other error has occurred.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/nfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index f92ea11aea44..ffba4de3df01 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2179,7 +2179,6 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		err = PTR_ERR(inode);
 		trace_nfs_atomic_open_exit(dir, ctx, open_flags, err);
 		put_nfs_open_context(ctx);
-		d_drop(dentry);
 		switch (err) {
 		case -ENOENT:
 			if (nfs_server_capable(dir, NFS_CAP_CASE_INSENSITIVE))
@@ -2188,7 +2187,7 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 				dir_verifier = nfs_save_change_attribute(dir);
 			nfs_set_verifier(dentry, dir_verifier);
 			d_splice_alias(NULL, dentry);
-			break;
+			goto out;
 		case -EISDIR:
 		case -ENOTDIR:
 			goto no_open;
@@ -2200,6 +2199,7 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		default:
 			break;
 		}
+		d_drop(dentry);
 		goto out;
 	}
 	file->f_mode |= FMODE_CAN_ODIRECT;
-- 
2.50.0.107.gf914562f5916.dirty


