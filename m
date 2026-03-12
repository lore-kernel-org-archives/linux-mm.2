Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D6D106FD61
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8968C6B0092; Thu, 12 Mar 2026 20:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FA66B0095; Thu, 12 Mar 2026 20:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE516B0096; Thu, 12 Mar 2026 20:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA246B0092
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:44:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E03613B080
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:44:25 +0000 (UTC)
X-FDA: 84539193690.22.F6FB2B2
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id 07F5F100004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:44:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=HtGyc6qG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=cGZE7jMy;
	spf=pass (imf05.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362663;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EchxTXDSTALGT/SYRwTZVf/wCe3kGgvEe9z67tw1N/I=;
	b=JBKfbjGSi7/riklH+mdEtx/CNEvjodl/Y06zutkL5a8bNuFEBWc/vfc9FMuk230C7W9ppv
	aSNFo/8xyeo5ZpwvKi1TPL+hUvP6XmCq3tHRk+w9AWkhde6gGHgwt8MsDZWxwof6Uga973
	25Bn7SGTXTa9Rd3ArrfbPszsX+7UUyQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362663; a=rsa-sha256;
	cv=none;
	b=0CDi6lagaObqXjwTACPefQvpA9/xirs3ZMuguQlXrMXI9aqt3CZCRe0G75+mpwwYGvFp8M
	dgzvf0nD7EOgc3kEnldujdWhatIgs/ndGKo+Mqbh2WdLuiNbxXEnU4fz66GW2IqaDQu/xz
	7I7PH9i4vKPGc5uqOo2arGXBhvoI9Ts=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=HtGyc6qG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=cGZE7jMy;
	spf=pass (imf05.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 1C1651301B36;
	Thu, 12 Mar 2026 20:44:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 12 Mar 2026 20:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362660;
	 x=1773369860; bh=EchxTXDSTALGT/SYRwTZVf/wCe3kGgvEe9z67tw1N/I=; b=
	HtGyc6qG86oz5kPvVFKloxRAiiPrdOpKU8L6wLUUYdjZZtzmK8nkkRoRc4Ob/zDE
	ygWeDDQ7jByf/H36cgdfqD2YT8xrlT5AnRfqLG6YYDduADlVEQcPZKFCOFEq7efp
	W0PV4tzGLYO7R7+Bi8QoTHgftdcdAbG2cmbRdSq7IiPJrej/xGh8Sis7vcSb5NUp
	8p9RKdBEfwd8U9POVkTHLrI8JD7f/jqhMlJETvpWzrtU+xKrqH6+DdkWl9BZAf3N
	0STPIxH4lQraZKks4fXTtb9nzvy+JFzG89W3Fsfemen70/tWjCFitTexXEMl+aF6
	MdwcnBbmpBgBWkwcmrlWrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362660; x=1773369860; bh=E
	chxTXDSTALGT/SYRwTZVf/wCe3kGgvEe9z67tw1N/I=; b=cGZE7jMy2SV9uoVbT
	q+IZzNuzXM+hYp7X/7RyEelmnM4UrPJGwKgU90XEnptRogSnhLgrodnjWWKRdW6V
	AQ2OpzAPnuid/OLVu+UcDPlHx8xARolg4F09VwR1VkrdXcXUZU3U5Q/ecPnnrOZf
	SYXSxRBpzCG7sc8smUlxY8lKJ6slf1JpRJFSI4EJH5Sn6FJIQ9W0S72D+0grR2eW
	eRAGsh4DDkSU9EgUFpYcUsAr3jEhGPLkD/lIXTiZxQR15ET1AfwNhG2Uyk8kFZEA
	eJf1QWHbL/Mhmx2NzRvIensmEAwQ5KJ9/ygKBb3mV2toMoGumq2oOmUfpqyuBCg1
	QIv+A==
X-ME-Sender: <xms:5F2zaVHI984ELvb6xSRaFU9eCeKsAQjeZVnzdbb6spa-5onhWibOxw>
    <xme:5F2zaUAed5wK-zCYjIohFxTpHOZodN1QK5v6gSu9aBbq6YkW49INvwK2H8WSlxuUj
    0AINAGwpWxmYYyrWgs6QEljfIuLf1lidnihAI7NxZBlett3>
X-ME-Received: <xmr:5F2zaeFAXsLgutzseRttIHJSIZrQBg4HQsn-pgvOFbN2jRZuZJQaVAifygamFXGvvWGzpvACE4zAmDQPT3U028PwiKjFjFm6UlAj5yjyJwko>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:5F2zafLiDwJI8AsohNmCqUWhx66u5JznxXNAP9db1X9x-LHxraRvUQ>
    <xmx:5F2zaauU88YwyeOeYB86_WfHys66FW-d63rSeocswtoECd66SdtGHA>
    <xmx:5F2zaUpH9EvuwjTwbaCT-kN4TE4nurgxpwZqmfL5VKPrPKKsZvNp0w>
    <xmx:5F2zaWWtk05otDk_d1bqcAfIJnfbAsyYAIR11Xd5Jqwl9RmTh_ZPSw>
    <xmx:5F2zaZWxNVGF8w3Grc8V634dTGW1lFtEASW9xYbi3dSM4mcL6-JNsBIK>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:44:07 -0400 (EDT)
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
Subject: [PATCH 33/53] ext4: use on-stack dentries in ext4_fc_replay_link_internal()
Date: Fri, 13 Mar 2026 08:12:20 +1100
Message-ID: <20260312214330.3885211-34-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g54o1h4kx6n9d95dybec39ifk8zi7fim
X-Rspam-User: 
X-Rspamd-Queue-Id: 07F5F100004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773362662-697559
X-HE-Meta: U2FsdGVkX1+oVn036ntaWNbgs7VpEw/sXCBKXuRvXnOaNlfm+wyY8/9AuxclScs1GnHmzE05ObX6jt6tHJ+pa83IHvJRTbxDRQ/FNdIHto2STqku0ElSYm9UQ+HEikmyu9LS8IAaO//VA7iKNi717cThcJpk1HaWG5f9VqMwARPuCOzFBPDbLOVIdfJIzT7ACQOYU1xgb6iXSRo5oKckSr5QvpPoV+0TWljhmygYKF6LrhIfSEhgLf/AlqkYA68kSv+XgdUHCM4GNlIDb+sjQVSHShkF8gKmVfdL6acoaUSLvl1owxOhqVi7r4K4w3wyh3zTtw6KKJtu9TkA6EsYihjW4wTeRrcSfel2bb1+JIVqslnLbAniZ9sZXnkhHRCOFuEyuIMecFM/8rPdRaR8c565RO6kKASpd2nrHXeUVN4VDBYSJTafvFSKJ/orPjhtHXFK3wEn9dcQRp6px2nuDjfeNiEibIHczkuIIpLYbo6xP2OiQXTjrh/80/nmjP09rGWTvA3ms/2vwu0E53AItQ0SGQQLL5hdDmmLJxx+K8jkq8vsziClF6zL8nJZeuvq+ip2C+osc3JUjvqCdHPNl4V8EYOJl9PeEW7LyVXsxp5uEVPHvtbT7AQfG+BZgxEp4T2z/OX0+OkvkuRk6uQWBjBDBc+tv20Nw8JBwfzKyMZmf8AGAQFPUb2JaU3b1WZzVJGiVXbdv6oXXUxNvwcLbNsPhfRoB1z5uA6U2nnp/UkQuygETUIQMS4bzew7aH1SJ1dMKfdKn34+02zn6340ykNluoBD8ui31e2zVmMoWiacpNCwzXMi2EIAm3QQhPQSBFMWiFErGw9fR86J44BDvkYb5OhEdCBfZJFDu7oqNQKg8vpJRoVvLI5bP0kvPXJcHhKKha2T700m2GofL82dK9rziU+xtohaVzIdoEScyWVAK6odp6xDZZPf9CMyTFEdyC2+I/hQiUi3J26M6Aa
 xzsc4xyk
 /S5NZmVHo4uTFIxMjJ77ZnrRdGgkls2HYFUBClMM+R+YIvlpZz9gB1Wk1HNCO9mHI8kblBeHgLFxlovyANd54MxV2fIbBnQZ7vAXpLogsflJSDG1CBL0755jmCZHj90NjQYSYCENeSqzTHrVF3CcSQQUck6CwvwZAETny/dc6MBi835Pv7YiUYgN1L+wQC8tdUuhyo8uyvB4J0BpRz81kr89PVAIYViR/nh1r1bOzx2127jdRAr3QkDehGZwR7qEoVToNIeguH1b3IJl3KPWkLLOjoTMBBcAUsHLyiXjKvJ/Iyj5mTeMvIJSK+MCdLuPAZxFh8a7XZsg/tU0Jpa/FtWJu8co2HyF8ODp7lI6LFwrN6vevyhBTQMLV49YEzJXAKAA3zwyJSxCB14rAStc6z0cgi3c7QDRJb5uO89SxsMO1HEbdI21PdVCClwnuUMpY43mohalSnQgG71xZRMSr4/Z4JYFZpljOqvZkBpvy6gjnsnIxXsNfte8EvuSrhMqMdnaucTUy5CWyWL7z/o5TNiimQex7bnzlu8OT69G51ynuBa/AXMRecSMvNgvcSBY3zei95aMhMG30wxHVTCw6Q3cPoemYIb16rNRyBF/TO2DeEnAmtIbK+azfzAdaBHzM+thnSLVsqi+OFXfVAZP/zXrOVdVXwkT3UGIyEKyQuSxVaIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

ext4_fc_replay_link_internal() uses two dentries to simply code-reuse
when replaying a "link" operation.  It does not need to interact with
the dcache and removes the dentries shortly after adding them.

They are passed to __ext4_link() which only performs read accesses on
these dentries and only uses the name and parent of dentry_inode (plus
checking a flag is unset) and only uses the inode of the parent.

So instead of allocating dentries and adding them to the dcache, allocat
two dentries on the stack, set up the required fields, and pass these to
__ext4_link().

This substantially simplifies the code and removes on of the few uses of
d_alloc() - preparing for its removal.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ext4/fast_commit.c | 40 ++++++++--------------------------------
 1 file changed, 8 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 2a5daf1d9667..e3593bb90a62 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1446,8 +1446,6 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 				struct inode *inode)
 {
 	struct inode *dir = NULL;
-	struct dentry *dentry_dir = NULL, *dentry_inode = NULL;
-	struct qstr qstr_dname = QSTR_INIT(darg->dname, darg->dname_len);
 	int ret = 0;
 
 	dir = ext4_iget(sb, darg->parent_ino, EXT4_IGET_NORMAL);
@@ -1457,28 +1455,14 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 		goto out;
 	}
 
-	dentry_dir = d_obtain_alias(dir);
-	if (IS_ERR(dentry_dir)) {
-		ext4_debug("Failed to obtain dentry");
-		dentry_dir = NULL;
-		goto out;
-	}
+	{
+		struct dentry dentry_dir = { .d_inode = dir };
+		const struct dentry dentry_inode = {
+			.d_parent = &dentry_dir,
+			.d_name = QSTR_LEN(darg->dname, darg->dname_len),
+		};
 
-	dentry_inode = d_alloc(dentry_dir, &qstr_dname);
-	if (!dentry_inode) {
-		ext4_debug("Inode dentry not created.");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ihold(inode);
-	inc_nlink(inode);
-	ret = __ext4_link(dir, inode, dentry_inode);
-	if (ret) {
-		drop_nlink(inode);
-		iput(inode);
-	} else {
-		d_instantiate(dentry_inode, inode);
+		ret = __ext4_link(dir, inode, &dentry_inode);
 	}
 	/*
 	 * It's possible that link already existed since data blocks
@@ -1493,16 +1477,8 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 
 	ret = 0;
 out:
-	if (dentry_dir) {
-		d_drop(dentry_dir);
-		dput(dentry_dir);
-	} else if (dir) {
+	if (dir)
 		iput(dir);
-	}
-	if (dentry_inode) {
-		d_drop(dentry_inode);
-		dput(dentry_inode);
-	}
 
 	return ret;
 }
-- 
2.50.0.107.gf914562f5916.dirty


