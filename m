Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B26106ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8E06B00C4; Thu, 12 Mar 2026 17:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78596B00C5; Thu, 12 Mar 2026 17:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47206B00C6; Thu, 12 Mar 2026 17:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A265E6B00C4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:47:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FDD6B9662
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:47:05 +0000 (UTC)
X-FDA: 84538746810.03.5F62551
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id 76C5DC0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:47:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=BC76xmpQ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DCxT41qh;
	spf=pass (imf22.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352023;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9RhJ2BuLywXUJ/fvnCHaZYNU2thzEny+uIpuniq6ls=;
	b=gJ8apejiIOde1vhKWiXNgZoFuSrjyHhm3vawN2i5hC3bpcw9NilIn/ap7MmQkOLb9+VzsX
	aFtVDCvSU9imoKZjVoIfcucS3P0nDtJfs4g7cFDRAe6Ovq8zASoWs3yeLKW8NiFctXirTE
	oulfomhUCelT7bJUd6ffa3l57uRyb5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352023; a=rsa-sha256;
	cv=none;
	b=gpLtlI+hxJjyBbLsKp+Cvxr3rlS4SWJmUYJPnOFB9U+tn5w4aF0Eey1KkBTlTklyVT+3pl
	t+RqgyI0xfE5pW1dbXc5H8trOt+kU9RePlfJx+E32c0R1hVYIKv9v9SkPMlGrUBVPT5qE3
	xg5UhPzH2rbiBrZkhUFnH9gWhtJjJUw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=BC76xmpQ;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=DCxT41qh;
	spf=pass (imf22.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 6586A1301B5F;
	Thu, 12 Mar 2026 17:47:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 17:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352021;
	 x=1773359221; bh=d9RhJ2BuLywXUJ/fvnCHaZYNU2thzEny+uIpuniq6ls=; b=
	BC76xmpQzBJ/5FWzgYwZ3exEB8Y9YxPHLjPvprCTetgklTOlLNdancD8t5ymMjZa
	3NCix1LQtbhZKIJmxEJsx5VOEAsW8ee1C/VOGvYvKaDXzSQ7qm1PJWuggVq+7sOX
	RwRQfVuH121ZKNqX5D/PIfCsH/R6iyJhKA8S1o7+T0+6YM48RxlHwDogpHijdGHt
	SS6wqZBT0lkrQfBq4MLO1x3tvt0osH1t+pfpDHUUXYF4La5ohqB0DxS7k64FuKq4
	/2t1hr7mfNYFsZZJGtj09uj4rOGEZYTnz7ENVdeRFWwkjiYo7XhaQ7N6ktWdp3BC
	HDT8R38jU0q4FXwFBawbLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352021; x=1773359221; bh=d
	9RhJ2BuLywXUJ/fvnCHaZYNU2thzEny+uIpuniq6ls=; b=DCxT41qhRsolTCr8S
	fmLfxVTn2usDZk1YalfS014uow6ZmLtFeCiClbu0uY1EqfEce3yq0r6X15MS9F9O
	f5KaXSo+ceu5kK+S14baxhrU7tWh8UL4DUJ+ZQfKlkyWEz7zM0VrHY42SKCSlbIk
	z+JPxA1n9EmcTefXq5hlS4p7dFYZ5qD2phNVpZqECjx0aLzOZWjwX/Je2vdTQJeE
	cDuagD/6uB7HJqWOXrwp3hGm29I2LG09xT8ITuzo532E7DZV63YmHP8I6C6p3yMQ
	qGGHEUDjoK0CXP0n28Zz3w6DZ6cRwngVDUDiVADWPhnRp98AFT0MsQ5OH3LvviFd
	CNZRg==
X-ME-Sender: <xms:VDSzaXYLPrtcK0bs2zJdBCtohptPfrtuCjH8-lbNYxX2oxUhPVzkOQ>
    <xme:VDSzaaGfHfMxGyn5kMEamz8ctprxVPhX4vDmo-L4eAGQuGMr3ud_9JZvlg7amgeo2
    65r_7f8MN9XVTajYp7iCuBZ_MWXiFP8hFwfdMOtM_AmvEViqA>
X-ME-Received: <xmr:VDSzaVCrxd00LhfUp8j7wh00JZkGGCRs0NeiUYwlY0rOj2uVjLCCfhx2jew45WoX3SaIKDApk5cGTV-i_5mtndNGCoGovB0ufEaJTBZelNrh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
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
X-ME-Proxy: <xmx:VDSzabGwTA4CyLcXH0u6YYWqIejt2rnCCD49CKiQEsFjZWCS6iBiSA>
    <xmx:VDSzaYJeygJdr4jLGgDpOItYaEGvi9lW7E6L5fZdeQ_bJQAsoCQDnQ>
    <xmx:VDSzafuQHWpbo8GPLQkHsckyDbYZP-k7hiTFg20qbB1rZHTG5aOMjA>
    <xmx:VDSzaVqVRHdjut9ARknHxg73nOefF0dcf_4GTtHFCO3WI4xTl4ojxw>
    <xmx:VTSzabkEE-r_qI7J47jQxmsh9q_ZUY65iFqroveMaPY5PhnGzMBWvloT>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:46:47 -0400 (EDT)
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
Subject: [PATCH 09/53] nfs: remove d_drop()/d_alloc_parallel() from nfs_atomic_open()
Date: Fri, 13 Mar 2026 08:11:56 +1100
Message-ID: <20260312214330.3885211-10-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76C5DC0005
X-Stat-Signature: 7p7ec6y751xqad9hcfpoejnk5tn38ryk
X-Rspam-User: 
X-HE-Tag: 1773352023-849981
X-HE-Meta: U2FsdGVkX1/poqi9bYeFh1dnSUv2KRTmQj3SJuqQa5ikfO3dbFNmnByVNKj9lRzmHJSqJGPj7S1Gy1esVSAlc1A94pQYuid/Uzpzse+f/+fYcWM3ez7pcwfrVnjT/wL2KNGHNFt1+RUWbjepMVbFImRmEQA30aSwfK7i746/fuGNfzeB6RoYhWbnX+npl/vWqjifHINDeM7wDnH4Kp6zk4pvgTW+ymED5VonUEND9LUQRBg4UyxMtU924tZW6DkZeNSMprCLfaDwuu4JwqSeN9m5WSEHi0KPHTt/itDMX+RgSGR1F2Dfe20Fc/HVggDYjqOnpyYfsLHyMaCbqjF2DqdrXDrox5xw4FddK8QC+3Utm7M/xMQBlSCbdFAqJhTeZMRGTv/Bb+hEczsHRtcmvKL21GzBMR5gOYTxDfdzTzE8/YnbhP/ll4QACPbpgud9nl56B8RGAUpmV+IeBoTmXnkl8aIWWkj2rgTkJTL2QbllC1QI9J6ckvES9SbKsA5bgm5zThBH0KYvu9Q5jY378y+QXwpDvR0/6tDF6tnnfI+ifwguRnMJCfYQQuSkb05yecpehN52d8vxrnBtGJlUp7TDUJN//8RVq9zZInrSEnxLObAwT+a+V79FOVUAHyoVC+eDorvY9pRVlhBmMMU7VcCLBlNs/6y2pcC9Y/DHDWCgoLPIXabWH65p7O+eslI7MgtdN4Rc5yNFSfDZ79Crj9VD1prM2//ECsTzf9B65l/kdl9lU1iuR/9nhJ4YNkMCBFNiCtLIEdiKh4yX4Mphyy4pub3RUOEK/KyFO/2YncAFrEUTjEXh0r2rn+hKrhw9ooBuDyy5kjNz5KFb7E6A0oqQPAT5uDpxNu45ehmwpgFp9T6s3VGgCv3MHWxSBWLAsHdKqJYMdtnUF0clsXilzDT/FXXNNj2S8Ry9+B7Kap6Yhdjcjj44+0YIW4OAOJBuSnme8IWb6Bzyv2jXFEw
 Oxf1AUA7
 XUD3yyc7mINv9H5zpFvw3KFumvLfly2Lp4V2Cj49qgJxXYFtvS1G/2rC/5tCdKNAjaPYBmveGGTaI7QXi6mtztkkbOhe0MaGFuCfzYBR21EesL8J/lCICuY0cqLi35Fg8XiUzY1LmBSah0JaZw1uLIubh1h7nQNLIEgOww33ByB21jBg/+RxnFhoiyUE+n5uYIumTqJXcT4QHUxm+7Me2XloKLReVrOPa9IaDGQbDg2D0OD5R4w8Nmb495PDbhEZly2ONCk88h+qzVd6CaL8VysR7rq7ocbvQnCMNdVRdLMbYcQWcbO5lroA4+n7LoDFhmiRo+TJ3Dp/DBcBPSvqk7jha4jmJ5tI5IP3Bsc2Nosy6fbvjxg2yaTuuFxWM8FQn9Uy7KJdyd3rHDQCjxc3SXTw5gfqFVWzMb8r8sfJrUuoM8yE37VqNJtQFFLuIduW11DqPXhhPedg98DANDO/lsymtQ5EzkeG13X6diqTibyeB6yrj1HtgnmR46uh18OD1U4R3TkTvw5WVJ5SDwf3XW+JOrhu7zkFm10gFkevLFOELb7Q1x1fSdvaLLg1QoxhA3j2VO3OjX4ZNecmOhvnV2p7Vl/1WxBea82GmmkZ4zFZtjRRTZeOL3nqvn8ePAs0XZI1zsE1PD9cM3DWB7jZgdJMLJNBRTaZ2dRug
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

It is important that two non-create NFS "open"s of a negative dentry
don't race.  They both have only a shared lock on i_rwsem and so could
run concurrently, but they might both try to call d_splice_alias() at
the same time which is confusing at best.

nfs_atomic_open() currently avoids this by discarding the negative
dentry and creating a new one using d_alloc_parallel().  Only one thread
can successfully get the d_in_lookup() dentry, the other will wait for
the first to finish, and can use the result of that first lookup.

A proposed locking change inverts the order between i_rwsem and
d_alloc_parallel() so it will not be safe to call d_alloc_parallel()
while holding i_rwsem - even shared.

We can achieve the same effect by causing ->d_revalidate to invalidate a
negative dentry when LOOKUP_OPEN is set.  Doing this is consistent with
the "close to open" caching semantics of NFS which requires the server
to be queried whenever opening a file - cached information must not be
trusted.

With this change to ->d_revaliate (implemented in nfs_neg_need_reval) we
can be sure that we have exclusive access to any dentry that reaches
nfs_atomic_open().  Either O_CREAT was requested and so the parent is
locked exclusively, or the dentry will have DCACHE_PAR_LOOKUP set.

This means that the d_drop() and d_alloc_parallel() calls in
nfs_atomic_lookup() are no longer needed to provide exclusion

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/nfs/dir.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 52e7656195ec..3033cc5ce12f 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1657,6 +1657,13 @@ int nfs_neg_need_reval(struct inode *dir, struct dentry *dentry,
 {
 	if (flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
 		return 0;
+	if (flags & LOOKUP_OPEN)
+		/* close-to-open semantics require we go to server
+		 * on each open.  By invalidating the dentry we
+		 * also ensure nfs_atomic_open() always has exclusive
+		 * access to the dentry.
+		 */
+		return 0;
 	if (NFS_SERVER(dir)->flags & NFS_MOUNT_LOOKUP_CACHE_NONEG)
 		return 1;
 	/* Case insensitive server? Revalidate negative dentries */
@@ -2112,7 +2119,6 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	struct inode *inode;
 	unsigned int lookup_flags = 0;
 	unsigned long dir_verifier;
-	bool switched = false;
 	int created = 0;
 	int err;
 
@@ -2157,17 +2163,6 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		attr.ia_size = 0;
 	}
 
-	if (!(open_flags & O_CREAT) && !d_in_lookup(dentry)) {
-		d_drop(dentry);
-		switched = true;
-		dentry = d_alloc_parallel(dentry->d_parent,
-					  &dentry->d_name);
-		if (IS_ERR(dentry))
-			return PTR_ERR(dentry);
-		if (unlikely(!d_in_lookup(dentry)))
-			return finish_no_open(file, dentry);
-	}
-
 	ctx = create_nfs_open_context(dentry, open_flags, file);
 	err = PTR_ERR(ctx);
 	if (IS_ERR(ctx))
@@ -2210,10 +2205,6 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	trace_nfs_atomic_open_exit(dir, ctx, open_flags, err);
 	put_nfs_open_context(ctx);
 out:
-	if (unlikely(switched)) {
-		d_lookup_done(dentry);
-		dput(dentry);
-	}
 	return err;
 
 no_open:
@@ -2236,13 +2227,6 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 			res = ERR_PTR(-EOPENSTALE);
 		}
 	}
-	if (switched) {
-		d_lookup_done(dentry);
-		if (!res)
-			res = dentry;
-		else
-			dput(dentry);
-	}
 	return finish_no_open(file, res);
 }
 EXPORT_SYMBOL_GPL(nfs_atomic_open);
-- 
2.50.0.107.gf914562f5916.dirty


