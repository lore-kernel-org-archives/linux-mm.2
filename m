Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6981D106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1CB6B00DB; Thu, 12 Mar 2026 17:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99386B00DD; Thu, 12 Mar 2026 17:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71106B00DE; Thu, 12 Mar 2026 17:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A71C66B00DB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:57:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78E691B7F2D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:57:08 +0000 (UTC)
X-FDA: 84538772136.06.25CE72C
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7418880003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:57:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=BW9wEqW3;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=dpUIJhtE;
	spf=pass (imf30.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352626;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4l/tn7wsmdY2E32uQtjREu4g7D5gEVnge4bbDSwghlw=;
	b=FjdM3MVhDdg14r06U2LqZasD0UuF8y8urkaGvK7Iw7myGNmlmOre/ZzBcgtZE5a/vtFi2Q
	c/hmuu+ZymB+jDLLZ90VIYVLeiq9gpEQ8AFpBPHPAsK7MmThetopW10w+Q3Bz5UPEHhr0L
	sJWcS8HpU+bTH69wlwM1sCiymAZkzuI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=BW9wEqW3;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=dpUIJhtE;
	spf=pass (imf30.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352626; a=rsa-sha256;
	cv=none;
	b=RY9eg7m2rurX1wp1lnsl2BcerlY1H/F4zvUS8Pgn+2+540RLfFIRAyOgu21/eSXbnnEBk7
	Tkln9f5ey9Jq/jQu4fYzmLCtbJQIFmcBVKkJfH51Gk5m4MlK1XSMYz0Xzzx/QV3co1Tbzr
	jy5Qie1mENJfCal4qADBEbRBamam3AA=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 8997E1300F6C;
	Thu, 12 Mar 2026 17:57:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 12 Mar 2026 17:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352624;
	 x=1773359824; bh=4l/tn7wsmdY2E32uQtjREu4g7D5gEVnge4bbDSwghlw=; b=
	BW9wEqW3sDh/FtKsI2oZym4cN8gfqO7PI+1QZkzeYlyvzzvl6g5EeSeOVu2oQtk6
	PwPCa0pocxA0zzebqej9hV8+MTj4mW3U1OzGT1coekfj64HMKjiyXojEgdUSfnKR
	Df6eFbO4K8hWvuP6o0waZ4SVFdfPcjZ7D+C0sJjdqiTmUTmlwI+pXNafNv00dWc+
	O0BVOVD6z9gx+eoRdkYV7FRCKsnyeYvYtoaEJmptNiWxetbag5RW+Ctd2uja0vfe
	v/0ZReqHwz02Av+es2ehMtnHwBvblWlCyOd+zaOQ8hfvOrqwfKTb6BsB9u6fjrkN
	H6TNzQH7wj5p2FUyypeOZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352624; x=1773359824; bh=4
	l/tn7wsmdY2E32uQtjREu4g7D5gEVnge4bbDSwghlw=; b=dpUIJhtEj1cBj3j9H
	unyZT0sMz9m0PJa4w9ml8U0zTMyPTdFWoMrhP+PqHlnb46PZTAI4xBzf/94OZ8au
	HMMYdpzclow79eg8cITbo/HF3XL3lV3pJvLrnH+UHhYGWNABwaDUEiiSyBi+p058
	AIT72AIiSjFv8C24PGRRqioFgMW/bXDjAmwY1r7O83Dgv8bls44ABJ3Gy3mhaPVZ
	p5sA4LBrZzneMleY4pIfAQbq2VSFXST6n79auOxftmCpBxOkbEmLk++Su9Eqt6tE
	9xo9Ukyjllk9zko/7dVAbA5+W8pX2MGic1YtvXJIew/ovNUl8pHZGrIke+e8ed4X
	zHmhQ==
X-ME-Sender: <xms:rzazafHgq5kkJNLQXJ5MsMZvA5C7KDN9tUQQwQNXLndrPr-KUTr36A>
    <xme:rzazaWBaxSyrDQlnqQ7fCszhaC7GOWJXr034oAZHf9f5Ln_XAnrlsy8lJHZqhtcCa
    24RJDo5YwjWbYzhkh95fWMs6HGsmK17CJ_FCEE3A2bRWLgAE-E>
X-ME-Received: <xmr:rzazaYGaMqtlyBo5Byt15BG5PspFOkSK_oM_1CAORCyOKtV1Z5vCxW9Wv0QrAIBd0dvvztUHaL61rYcyjKGMWRqFwlWMac7pDS4ZI1dvlQHE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledvucetufdoteggodetrf
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
X-ME-Proxy: <xmx:rzazaRLMf0xCbH9DskN6cbfxaFyHjsXPa01ypMC44vm_7j42GQo-XQ>
    <xmx:rzazaUuXjK3pWNOdt_IrXzDfMiNIFLihdDLGV0rzQsKjCfilR3Fziw>
    <xmx:rzazaWol9h7ePjrj3Za7I73W-xCiRO1lEYFki_qD-TJ6bQYulpiMtg>
    <xmx:rzazaQUBcFkXeR7RUWU1cUXNQ1HJd2AgmIhU03afXZwQTCNgbw326Q>
    <xmx:sDazaWf3sZUuzWbO4fKYzxinLNZ9SCRYKi3Wbk1TTyoldl1UNbQP0RC5>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:56:51 -0400 (EDT)
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
Subject: [PATCH 47/53] VFS: make d_alloc() local to VFS.
Date: Fri, 13 Mar 2026 08:12:34 +1100
Message-ID: <20260312214330.3885211-48-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yssgf4otkjd33ctcd3s3xs1wodn3gxuj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7418880003
X-HE-Tag: 1773352626-327114
X-HE-Meta: U2FsdGVkX1+fpTwpoP97dVC8fYArrlPYGbNc3xi3L8xzRMSkIYMAvKx6p/8csCFrRZGKgiu7aPOkYV4KOnjCQRoVNLklQRIR8mr3FnfBBcBjc4v5XjBhOq/DF9DZlb/+okFNDKWpqbEUO+CruGsz/mB9mmXrhaPQnm0VGUhtLmNlbAN93dEZ8ECDe6Md6uzJgb3YCoYxq+knuQoZ5sFHfpeyMsK6opRbDmRuyrfYJZcf/tly4CQ+16gfEZxOlYzLGe0PnDnHLqMUWQ0D3wIlZvABuc9aphSn5m4nWL4rBEdA+FK7HgE/XRpQcMTlZ+XtzZF68w7j9ApO7CmIq5DhKdFkWFLWdQDj3Nn4b7ys4OW5rUqrbjpaTXNSTN76es0bWSSe960baHmWLgYT4T7ECYQ1Pssv4tl6JISVBh5sNjfbX7sXr58goCgjN4WMKG3Ax1NvitaBOY1AETVLg0kAe5Z6ozduFhJtXvviFG3FPXuCJsZLLH1isKKhiwoDkvVFSggq/fiy66X35000SOBNf3kp9nvw26AtF5r1wLWyHfkojRJhitOjYk97CtFhlsioWXw++o/jUxrgT/LeS2VOS4V+d0zqM9tx/4PnOwn0nVsyv+eJPU6AAJH7EBHpbhmOKio2fIYxj1v0Tsann8+OJTHFVN5jk1CLU7xGA/Hl6HBXJVWQr6H41UtlX86EEinQTJOrB77poR2ioWiKQvztYDB2uch7mlzNC3dF54rosMAToJKCOuIxm9H39tX6sGubcCP6Xi9bbsxy3f24GY5f47+/IswkscqMmPzRAfCp1HS8dp7J6Y/tDzA4pRTlUt5HD4Edwt5AhtSa0V2U5IbikwoasV56LRUB6aBEzxiMJK9oTrul3tz7HRsjxSl23x2E8mNX/sxqbpmDtFFIDFL5r7F/ShWnhACO1b/tcxEMuH+twdoeVVlIP5xAWsY1nR3X6TShjSZ4Kf2Uy2qiM1h
 SCx/RZai
 PbAd7Usmgh5TuwRUBnUnArhCZqltwRQCbi7K5/z7IXt6GFZS4sZ4fQ79bIyTkMiPnxI+QnxXBDQSyG95vLWx4prQ1GyeWgTOE3eywz1S+U6H9QM3YwUn6oT3Q25tjKHa2SQNUmQJh8c7KkClSnQg3arGb3KIgTA2hT1LzreuTxyQ8yMVed7YbJLNVngVzZ0I0f5sv0xmKRV/4MKdGrS7sH+ik9rsBUsd77q7noh6YtGfnSJrz0BYEhg2gv2dW2nCOZsrVF6VsPQOpC+7Gj7RA9KviX3pcW9sWAZsc4jbaDQXmrY1Mjt40EjhDZzhI6yCZVQFjjXtH0iolJ3d9PhHZqKyRgt1v0mCnQpKar+HMdttXUN3nwAMpo0w1nBCc+KXJfwerHf6/JrVUpf8AlWWmA5sXrwYRAiJuPkNESU1Aeycj6ukWZnL78tjbJcrqxB6IpMKEuq/vnSVuLsqedsGtw+3lf9HNxU5Qe2BYQHzEW+arxRzPFzM93Q7TZmn6qgD1/XvjCaTNxjIE0JoxrmhC/W2hCDiis2g9UtE0Y76os+dQqb1NyoDlBKN0VMqzT++N+TZiNwRDY0AUkSU052mjSoI25sVx0//YXB8+BZY527eDgqDg/uHBohdOVgNZ6WnIounKecgczSadq94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

d_alloc() is not useful.  d_alloc_name() is a better interface for
those cases where it is safe to allocate a dentry without
synchronisation with the VFS, and d_alloc_parallel() or
d_alloc_noblock() shoudl be used when synchronisation is needed.

Signed-off-by: NeilBrown <neil@brown.name>
---
 Documentation/filesystems/porting.rst | 8 ++++++++
 fs/dcache.c                           | 1 -
 fs/internal.h                         | 1 +
 include/linux/dcache.h                | 1 -
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 6a507c508ccf..4712403fd98e 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1381,3 +1381,11 @@ longer available.  Use start_renaming() or similar.
 
 d_alloc_parallel() no longer requires a waitqueue_head.  It uses one
 from an internal table when needed.
+
+---
+
+**mandatory**
+
+d_alloc() is no longer exported as its use can be racy.  Use d_alloc_name()
+when object creation is controlled separately from standard filesystem interface,
+and d_alloc_parallel() or d_alloc_noblock() when standard interfaces can be used.
diff --git a/fs/dcache.c b/fs/dcache.c
index 9a6139013367..23f04fa05778 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1830,7 +1830,6 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 
 	return dentry;
 }
-EXPORT_SYMBOL(d_alloc);
 
 /**
  * d_duplicate: duplicate a dentry for combined atomic operation
diff --git a/fs/internal.h b/fs/internal.h
index cbc384a1aa09..9c637e2d18ef 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -223,6 +223,7 @@ bool sync_lazytime(struct inode *inode);
 /*
  * dcache.c
  */
+struct dentry *d_alloc(struct dentry * parent, const struct qstr *name);
 extern int d_set_mounted(struct dentry *dentry);
 extern long prune_dcache_sb(struct super_block *sb, struct shrink_control *sc);
 extern struct dentry *d_alloc_cursor(struct dentry *);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 3b12577ddfbb..18242f9598dc 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -242,7 +242,6 @@ extern void d_drop(struct dentry *dentry);
 extern void d_delete(struct dentry *);
 
 /* allocate/de-allocate */
-extern struct dentry * d_alloc(struct dentry *, const struct qstr *);
 extern struct dentry * d_alloc_anon(struct super_block *);
 extern struct dentry * d_alloc_parallel(struct dentry *, const struct qstr *);
 extern struct dentry * d_alloc_noblock(struct dentry *, struct qstr *);
-- 
2.50.0.107.gf914562f5916.dirty


