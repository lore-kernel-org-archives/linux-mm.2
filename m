Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF19B106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066116B00C5; Thu, 12 Mar 2026 17:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026E36B00C7; Thu, 12 Mar 2026 17:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B276B00C8; Thu, 12 Mar 2026 17:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFAF36B00C5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:47:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9C95160295
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:47:22 +0000 (UTC)
X-FDA: 84538747524.08.92E25E8
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf28.hostedemail.com (Postfix) with ESMTP id AD8EEC0002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:47:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=M0GFvqkQ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="1/GE6Q4G";
	spf=pass (imf28.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352040;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CijUCx3yISxMWTDbwuIO0Uj8qxE5ByzXHAuT2ll77Kc=;
	b=8rA4n0AhHvakGwljB0NJZiEYEad4VzLnArAsdh3KQbmK5Q3VNvqfqTPxiBx362BYe33wHC
	ubSgha6mHYF3k/FWGqwNK6eExWAnXFbz3lOtva40erRuraFsPbnr2VDxKoPGSVo4FYo+jK
	qATGEmxQ83Tb4OlaYy+8DjQO3h8lUXs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=M0GFvqkQ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="1/GE6Q4G";
	spf=pass (imf28.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352040; a=rsa-sha256;
	cv=none;
	b=PRP0o5G+GMCwrqZqUEv+s85E6kMgg9/KJa8u39WE09cHY41CmuVzb3+fZzFC3Ym653SvX5
	l5u+wuL3MvQzabapv1MDhotX7lggpI0wgqaKCMDmrI3ybsziwiI6jH9TaAitBJ17VD4H7m
	kkgOC5/6dl7odSsaiaWZBZvOiL45PPQ=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.stl.internal (Postfix) with ESMTP id CED9C1301B67;
	Thu, 12 Mar 2026 17:47:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 12 Mar 2026 17:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352038;
	 x=1773359238; bh=CijUCx3yISxMWTDbwuIO0Uj8qxE5ByzXHAuT2ll77Kc=; b=
	M0GFvqkQA+hh9nwu7mc7JuOVZVPu+x8oqWAW5Vi1Rx0ZNPsVz7iMxZxDKcq92CRt
	w1O4ZA75sGW4LDIVw7O6OPJ5TEFeAuGPKTPe/7jj0ItCruKb1FNYdY27SqhvZ09e
	HQrUKDXLZ77hpZ3f5jgYHX/xKT6j73t2fG+qbzqf9J3oUiSlH08UW2HJtPZBZl4E
	tb3S6pnqBRQMWB5MJD7qakzz5t5Vcq4FHeC8JYwtac3CNO2XjQ3o8C+nf5JuyF16
	FWLn2uA9VJxGu8LE7GwMewr9oJgdxJqtHJVrIkPAFUUXTRPZzAathqukS9KRqNd8
	vGX+vFOH13CMrNdF9lzRxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352038; x=1773359238; bh=C
	ijUCx3yISxMWTDbwuIO0Uj8qxE5ByzXHAuT2ll77Kc=; b=1/GE6Q4GOoKKny+rE
	1MCv0IvGJwFowq3gK2WpQpCuceE0cpvuxFjvXlb6EWJLNxDdvDBFb7JWso2W7Kz4
	mFFTfrB+C2ASTh9NC4SgG3HoHN43zfAxCmix5d+G+qZ+aEyNCsl3rNvSascyx4YJ
	TB8rxgDNbRLT7LoeFH5Cme9Q6tNfrxg9HzWUSDPszzVoCrORESTfN4bOq6nwEjj6
	nETza6aQ5uv45gJWXn54lpcHJOjI6XXdrUFqpLGzMIRfCqkIT7j6Cl0tgJg0F5Yf
	GNRULcF7xFfRRsuAOZ9mhJL0pTFa5+J27A43M+te1whUV4b+qPS2w84fsWgiX6kO
	OBj6Q==
X-ME-Sender: <xms:ZjSzaanPigQdEoCutGAwIPxjO8apJNgRPefGRXqMCTROMvJ-f8X8DQ>
    <xme:ZjSzabhOyplIVQ6rFZewl1y3_RfXqh3eikEEiZBZfSrWJrvLm1V846OM6sJqVJyze
    2tvhJt1_Y42OeZfOQjkdH8Fuai5DfHI5e8YlVpv-rEo2fY5>
X-ME-Received: <xmr:ZjSzafmz9RonKmSNFfPH-dDOoa1QQGeiKhudw1UDzdYzMUA5Fc3BHX9kxXc_Sk2W3JBwTQ9H7Y3ZB7JrVYGMX9luIkDKR407R11gkaq_hOgH>
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
X-ME-Proxy: <xmx:ZjSzaSp0E7bCqhcaSLkDbXNvvVFmD7gUjnaNvUJOeX2vs7zX4V9-oQ>
    <xmx:ZjSzaYO5kBCdqp08nn4s_kXmKCJVGkMzjkaXTd4aedH0KeQwN5YUBg>
    <xmx:ZjSzaUIHFxoYyKS25kJy7Qe-qFUsXUbKwQ1EfsvP5PspEUHlN7QptQ>
    <xmx:ZjSzaf05eFRrd1TCPNgoqXTI8E9qgZ7T1shFouSbVvlykGys3nYvhw>
    <xmx:ZjSzaT0ug1PB_DkmSY_fL7qirQdXDoPs16TB-jUayMEjlp2kG9qwmOKO>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:47:05 -0400 (EDT)
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
Subject: [PATCH 10/53] nfs: use d_splice_alias() in nfs_link()
Date: Fri, 13 Mar 2026 08:11:57 +1100
Message-ID: <20260312214330.3885211-11-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD8EEC0002
X-Stat-Signature: 1fez53anq8b38ydr8m3cwxj8oumfn86n
X-Rspam-User: 
X-HE-Tag: 1773352040-767115
X-HE-Meta: U2FsdGVkX18tlubmpwEC8PYlwknexNMbmYN6pEM5gvLZL6w3tbjf6X6d218GWTRRhajImi1cX+zlq4y257uu35DyxyvGmiIHGbldyoYCLPW+iAEO4ciullgMIL5ACyRVZQ63AHo3dcsAQsHtWtCCNykOvo7O9LR0qhhGvUBPflGfA4Y7K0RFjEqykG5T0HqKZREcIBq+bDctINFHJwBiMa1ztt9ApegVbq1RN+rqIHAktXg5AAcVZG/0stRaV5T3xsZJOB27FQsHhcijgjZJ84jIx18BDt28pN1ioh8W/d6I4hflLVSNFcj5Gh99sWXARoxdietmfsDEv2kF/ZiU8yuzikonhQob0as1ONG0LIQVl3JGg7jIr98d4LlHQjCxkPj3kMV8lS0H4CPIHFIVYCU8efqBmiSjb2VMzG4zz8UGP/0UGSanbuOoKO2SGzaPxxjnBzbnBYeDWKMNUvRDGJ15/91E0hfG9qmROde/pxc//ekx+b4E151qr8KnIdnIXYbAhNA7j+T5u3NpFZR2ft80b8Yzazvcoe8OXOW1IPVaKeXdgwitefK4LYPJW7tvzsi73KwZDJ5uV2k+ESrnU/99YP6GLtmD1zow8NTYIut67sBbP/lTHLvhODjvo8nnWj6VSxq26Dbtzw7llpmPxqo5SAyTqHmIybcKF56+JRQlxBOPdie9eayQ+2im3BkKG2IAeglxOxN+ydBca8wvL+h0pwZqQKGyt3Hf3PN/mcjFm6wwA9dBEFdpqGnFMDPTw0AgT2zJ/4/udGesK41Pw4o/c8yUZJjzRoyeDBKir/gceR+zzx3294IL/mUtYCSrDOtdCEJzZSNQUfnFcQwMINmSBbGK7RMImmpF35BJwayT2bvgI2ITWL6ycDSj+yrRfTjHe1Rto07hTMJHqJ6LU4ukDkxe0yGfAWHi5SixjiCtCeUrfnPnXZHfZDB+l2jW0Dy52Zgy9b63KiWSR2K
 CzDJHzQu
 0rCaQ2UvFppo225xCYQqMt91BssTzvusI9aL+I5l9ixeXnr6OHDY08w8qtVB31iV6XRVgh8ctbu5ZJr+FpA7c3mZqfv2gTEcwSl3tHdna/WE+ALlH7/L/myc4G5hlxCVTlGOftcuedMPEJgPbHfhERz9UvnwGuWyooGb6i60p0sUOdNvA9GcGCchjrQRJrWZEdIHF8eLYygY3XOPOV+J9jvrNRDY6ePN3Ifp72Be5qdwVcKMb+Ljwqd8IwAYPyHff0o6/egesBBn4TTWapnpIzAdfof8+ZZWdBXcmxeI4AfSQrSjTdu8buwIbRqSZHTbovzcvWvjSm0ciyyb/0drUI4smCTpbDJjbPUHHuRRzoRoAWV+hOcYnicPcd1h6FJkUwlWtqnOoKHKRBKX/X/ohu0UZXVg7jrnU4sRP9Ulz+GLPD5bWSz8LsalJgGczjoq/JEg/yz4lfflr5E0UoaUudS0CiFQIERolnOI3zk+tgzFD4cYzygLvKdMl28V9fiMj1+cjmM2VziRAEPH92pBlUqsqZtQrzd2FnEgo6awp7P02iJ0qDR4+/xHWjlZh3a0qmvwNiMhdnifm1cyzmX+GsoNRcO33rpjzxVL4D2YYHG7XBTww8E/AgVkjfZFPO/BNBejYEd/K7TNr3eIRIhF00J3FAM+W6OuBmpiz0S4fJ4bj9pE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

When filename_linkat() calls filename_create() which ultimately
calls ->lookup, the flags LOOKUP_CREATE|LOOKUP_EXCL are passed.
nfs_lookup() treats this as an exclusive create (which it is) and
skips the ->lookup, leaving the dentry unchanged.

Currently that means nfs_link() can get a hashed dentry (if the name was
already in the cache) or an unhashed dentry (if it wasn't). As none of
d_add(), d_instantiate(), d_splice_alias() could handle both of these,
nfs_link() calls d_drop() and then then d_add().

Recent changes to d_splice_alias() mean that it *can* work with either
hashed or unhashed dentries.  Future changes to locking mean that it
will be unsafe to d_drop() a dentry while an operation (in this case
"link()") is still ongoing.

So change to use d_splice_alias(), and not to d_drop() until an error is
detected (as in that case was can't be sure what is actually on the server).

Also update the comment for nfs_is_exclusive_create() to note that
link(), mkdir(), mknod(), symlink() all appear as exclusive creates.
Those other than link() already used d_splice_alias() via
nfs_add_or_obtain().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/nfs/dir.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 3033cc5ce12f..a188b09c9a54 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1571,6 +1571,9 @@ static int nfs_check_verifier(struct inode *dir, struct dentry *dentry,
 /*
  * Use intent information to check whether or not we're going to do
  * an O_EXCL create using this path component.
+ * Note that link(), mkdir(), mknod(), symlink() all appear as
+ * exclusive creation.  Regular file creation could be distinguished
+ * with LOOKUP_OPEN.
  */
 static int nfs_is_exclusive_create(struct inode *dir, unsigned int flags)
 {
@@ -2677,14 +2680,15 @@ nfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 		old_dentry, dentry);
 
 	trace_nfs_link_enter(inode, dir, dentry);
-	d_drop(dentry);
 	if (S_ISREG(inode->i_mode))
 		nfs_sync_inode(inode);
 	error = NFS_PROTO(dir)->link(inode, dir, &dentry->d_name);
 	if (error == 0) {
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 		ihold(inode);
-		d_add(dentry, inode);
+		d_splice_alias(inode, dentry);
+	} else {
+		d_drop(dentry);
 	}
 	trace_nfs_link_exit(inode, dir, dentry, error);
 	return error;
-- 
2.50.0.107.gf914562f5916.dirty


