Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A57106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA336B00B8; Thu, 12 Mar 2026 17:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B18E6B00BE; Thu, 12 Mar 2026 17:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1386B00BF; Thu, 12 Mar 2026 17:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 493A76B00B8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:45:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D142E140477
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:45:05 +0000 (UTC)
X-FDA: 84538741770.06.A69D222
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93775140010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:45:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=IdiQOok0;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gn3FSBiy;
	spf=pass (imf09.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773351903;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q86JqY5nWN61fk3HDIejbBzlZhC8qHqz4CWZQB9c0L0=;
	b=x1qsMrlYGZmYz6WfFHrLXCZy0RcQ0rk5pSokvBZedLnQudnaSJ/s8t9XLZ2PKlkwN8Hj5L
	kIH14sA4G67KHVDWVwp2ErBNLvsUfPOozRk+mw5hg7oihygCHz4Yi4j7LYBdwNN/uNsIoD
	B0osxwk22Oe9GhxBbynZ7aVVRhYOfSA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=IdiQOok0;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gn3FSBiy;
	spf=pass (imf09.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773351903; a=rsa-sha256;
	cv=none;
	b=csZr5VYQjH+oET6gIvtIuwV1ocqq3EYmZ9VgD6Eb8TFtiVyeq0YTy5beuTkmXL7zozJgRw
	le5EO8dT5yBcBvAq2YZEo1zVspEYFqzYUA6rbiw+/2LDcBTW51SmJk3FpgKrtXiwsde1Xt
	VEPH9Nd1R1Eg+K71tppZEGhn+Z78pKM=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.stl.internal (Postfix) with ESMTP id 81DD11301B38;
	Thu, 12 Mar 2026 17:45:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 12 Mar 2026 17:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773351901;
	 x=1773359101; bh=q86JqY5nWN61fk3HDIejbBzlZhC8qHqz4CWZQB9c0L0=; b=
	IdiQOok0NjcrVf3aBusgGZebFc2FHPnBB240qLNehAkc7QtrbGn+geGKng8idZGJ
	M8pgixjygkApnAS7lO7rlFmPWlnnVc7ZI+3NAFk4bKgxoEsSTJuJIpvXIQuhgkma
	hsj48bh9bZxX7e4DyJzIwbfCzQvDxXWTmxKYQxvUyWPBtqMB6vuaI8evFMQ+3Jzh
	YSXOHhEDMLnNXBxs3yMi4X2136zsPqA4HLfDUfQ5+O6mWKecRhNKoZtTqE1QKErs
	g24i9txs2z+6G+MZxrL9Ej0SJjyw4K3nGOm1peFDYO090Nbn5QSClI80O8eSgMF1
	HbW6gTFEIoXvPCxkC4/H1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773351901; x=1773359101; bh=q
	86JqY5nWN61fk3HDIejbBzlZhC8qHqz4CWZQB9c0L0=; b=gn3FSBiya6mz1Vl3j
	ZeHBiF7isXmDXq2Bj4NSdhVT01lccsHK2oNMG6rixbhMm5laJfOC1MNhF8URhPjY
	zfPpCGAv3EMgHswdAkM/NC63JIWQyCZMIvD9eoFCbdGn+0yca0TbrUF3xlLPtfSV
	MUMJ9mlzkwgs9wiwJvdrDOJZhGBQSoaUTvFyqBIoZR0BlZ7ZR7J6/Nl2uiHx+yV0
	OC48PirUBgXwfeDTTjEs0yLtaGLh608R+QD9jMUeUCQ8aCmPwgH4WdYQwhrv5rE+
	vvwfvA29XDqkVJ0VtODTYv+fXm11AMn7ghiP+W2k7wX75lWIdJJmBRaa2rRnR1Xj
	ha7ag==
X-ME-Sender: <xms:3DOzaSOy-EJ5M52dAeSiXhXiu4QmWzk4ZyygSCtRG1LbJnhV1pkN2Q>
    <xme:3DOzaUoF0hy8FkdKKemtyuUufzuos19b2bX-V3nh8QF-sbNkbNes3ZB17Gc8Sj3Ut
    2mi6jAcF7BiowP15Df6NOFLMh13DwCA8KtDPY1Agv5z5yLeSIU>
X-ME-Received: <xmr:3DOzaUXKtvg8cy8a1Yn4hKeTax-m9uWCMnfrt0a9U-DC2UwgvyxHZN4eWYnTx572jZguHkC49TNt2vnDNoReXnWA0iDzJEU-p78umv_v6rZn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejkeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:3DOzaQL9oijhqt4yjewGv3-1S6vRY49CYT-U2urGlkwLd-x95GWolw>
    <xmx:3DOzaf-ixVp_b2UGlSQkkpFtYH9pFCmJoOWJvH9bGaaot8XaFp04aQ>
    <xmx:3DOzaTQI3iitOQoKEqT2SGyjmIoeU4se1JZ53JzkJnUoq2S6h5telg>
    <xmx:3DOzaZ-O4PBgH2A_M20T6yNHevRLSfpBAowMm9FF_xpLEf-CcUgekg>
    <xmx:3TOzaTYsrE7RjVaZM_ZuJoMi7XQDVLNSOynY1Ipjh500LSgYWf_cUWZm>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:44:47 -0400 (EDT)
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
Subject: [PATCH 02/53] VFS: enhance d_splice_alias() to handle in-lookup dentries
Date: Fri, 13 Mar 2026 08:11:49 +1100
Message-ID: <20260312214330.3885211-3-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 93775140010
X-Stat-Signature: bxwgg3ph1ahpdp9t6qcpdqb3yqdoubj5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773351903-343581
X-HE-Meta: U2FsdGVkX18xMn5R2T3IzgssRQ/Qqbru9kQEVWIEshTxbB1vu21umGb+GHCQsF6QtcMgrMOr8NR4sNtj8095PJoltb8tL4zKMp8CgreyWj9vwc/DGZZFGGIQxHc79TjUQnvX7+T9E7nauPFAJpRL+/NPn3B3WOG/RgWvEAMvC+hWreyzAUvDLPp8jUDXv8rG8eUZoDY8u/iUG1Tksm9Q9FiUtsppEYK+6OImCKo4JXu6BbFU4pGApT9bg60HQ89VWDIIGlLtFBvVO0i2qdti3IX4uq6wxwyBML8LykxPBhNJ+Mnsl9L+uN8znVis6cEVndiHLx1J1xS70Xxw8rMJgTUd9E4X5DGio/46m0s/XAgwaUUvzUE5u8av5vRTaGTVW+/fLtNRcoMd9C3Ud/Jvko4hj6GKgUj1g4pm4Gng1H6ZaPPSwpOufRnRrw12eDtEPEsRZl0vJsSJ/df6Mzm5QaQpqIpr/3qibk0wmDPDTxpYgBisyj2nTgFvl62c+Nd1Uv2J/Rdc/8lRmBUCvrYxfBKZwFzPFUTrJpyx0OknmJuVpbQfedsGhitpAeEMlsZxfzFH1H3vYmts2E3Q0SI5SxpMdDx0v8WdW9gcz+nlTHybi8BLWiEYt/SQAc2tF3gouAWTWlrHjRw/fEX1yHPYyHdWbv+wstzRAHSsb8DQwWbAIOds2ygHB+AXwi/vapwauhZaB8HOsruOfCcoRU4k/QWOlEg6gr8u91m9Spss/+Kp0+btwSCI4AArOnyaTHw/3zwtUullRg8MsdKqd5LWPqnQmzFgdQ0HhZhRArwutwMDqGP0H9zDiESY+iUGm/WCjo5FJGRifDIsdm0OzjF/1Y3l1XvM3jnjC93gZpS5HbF7L34ibk+qsYAn2Ge1j9fdrGq+g2V2gahJ2fSjBo7LlGewuyPrm00beUdC9yo5ygIWktpSiEaIpTsTYQeAyV35bFmYV4o1e3ZRhE6+Jnk
 V49kE29p
 Xq3Vj6j1r6oJnInSd9KvgF8/vLtgR5aiEstySFedLchFkFQ5+sFQ3t71oe6aLbfI4X2TpkD46eolZuPlmOAGJlnq8bFtlQEuI/08G0PIiXvr5m4daFt8lNW2ApbfVOttQW6N6PzQdt2LYG3bDtkRR3qj5mkLVvu3E4WjPtELnYY9Ay5habRbJOzzQJ9NQJTrQek4GQrsA2lrrvsEtHLBwI3BumUvZKeMIpExeP10pQQO6hksnwH83kl4rnsadra2XcDBaOxXnHRS6T/Pt4X9F6GAeLrZ9kEAryRYG8QpaRGkF214Fo+LjlhLazMtDYR4h6/wS3g6Q3GYuXB7GqBqTeXMZ1z9NEDJJ6AY/kLoR208FlTl8iKUN/xUEAY99yBIKh9KyVrqQweVheAc4iEgk8X7OEtwmIHBDVWic0Pw8LfpiIWsqU+xcLVYjqr7HmXQFzx/TLLZkExvM6HNCed/BKe04LrZFpl3/9FV8d3UiqIFZWRn4qPKhKjnSyYOJS+6FuVVMrg17djp6rIjAA5FMr90ablhn+UQ4HhEzvPUCS+IjqmrObXGi/frUhLu1fe4cFgebx9wzpSmAR6pJkWaj0MJF+4LQrwpatnP52uMDrD+Lo/B4fMGfzHay8VW+lC6u14wjIta3PnFluf0LS5TrADZxswLf6A7IoNM3LOD998fZntI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

We currently have three interfaces for attaching existing inodes to
normal filesystems(*).
- d_add() requires an unhashed or in-lookup dentry and doesn't handle
  splicing in case a directory already has dentry
- d_instantiate() requires a hashed dentry, and also doesn't handle
  splicing.
- d_splice_alias() requires unhashed or in-lookup and does handle
  splicing, and can return an alternate dentry.

So there is no interface that supports both hashed and in-lookup, which
is what ->atomic_open needs to deal with.

Some filesystems check for in-lookup in their atomic_open and if found,
perform a ->lookup and can subsequently use d_instantiate() if the
dentry is still negative.  Other d_drop() the dentry so they can use
d_splice_alias().

This last will cause a problem for proposed changes to locking which
require the dentry to remain hashed while and operation proceeds on it.

There is also no interface which splices a directory (which might
already have a dentry) to a hashed dentry.  Filesystems which need to do
this d_drop() first.

So with this patch d_splice_alias() can handle hashed, unhashed, or
in-lookup dentries.  This makes it suitable for ->lookup, ->atomic_open,
and ->mkdir.

As a side effect d_add() will also now handle hashed dentries, but
future patches will remove d_add() as there is no benefit having it as
well as the others.

__d_add() currently contains code that is identical to
__d_instantiate(), so the former is changed to call the later, and both
d_add() and d_instantiate() call __d_add().

* There is also d_make_persistent() for filesystems which are
  dcache-based and don't support mkdir, create etc, and
  d_instantiate_new() for newly created inodes that are still locked.

Signed-off-by: NeilBrown <neil@brown.name>
---
 Documentation/filesystems/vfs.rst |  4 ++--
 fs/dcache.c                       | 31 ++++++++++++-------------------
 2 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 7c753148af88..d8df0a84cdba 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -507,8 +507,8 @@ otherwise noted.
 	dentry before the first mkdir returns.
 
 	If there is any chance this could happen, then the new inode
-	should be d_drop()ed and attached with d_splice_alias().  The
-	returned dentry (if any) should be returned by ->mkdir().
+	should be attached with d_splice_alias().  The returned
+	dentry (if any) should be returned by ->mkdir().
 
 ``rmdir``
 	called by the rmdir(2) system call.  Only required if you want
diff --git a/fs/dcache.c b/fs/dcache.c
index 7ba1801d8132..2a100c616576 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2001,7 +2001,6 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
  * (or otherwise set) by the caller to indicate that it is now
  * in use by the dcache.
  */
- 
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
 	BUG_ON(!hlist_unhashed(&entry->d_u.d_alias));
@@ -2755,18 +2754,14 @@ static inline void __d_add(struct dentry *dentry, struct inode *inode,
 		dir = dentry->d_parent->d_inode;
 		n = start_dir_add(dir);
 		d_wait = __d_lookup_unhash(dentry);
+		__d_rehash(dentry);
+	} else if (d_unhashed(dentry)) {
+		__d_rehash(dentry);
 	}
 	if (unlikely(ops))
 		d_set_d_op(dentry, ops);
-	if (inode) {
-		unsigned add_flags = d_flags_for_inode(inode);
-		hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
-		raw_write_seqcount_begin(&dentry->d_seq);
-		__d_set_inode_and_type(dentry, inode, add_flags);
-		raw_write_seqcount_end(&dentry->d_seq);
-		fsnotify_update_flags(dentry);
-	}
-	__d_rehash(dentry);
+	if (inode)
+		__d_instantiate(dentry, inode);
 	if (dir)
 		end_dir_add(dir, n, d_wait);
 	spin_unlock(&dentry->d_lock);
@@ -3066,8 +3061,6 @@ struct dentry *d_splice_alias_ops(struct inode *inode, struct dentry *dentry,
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
-	BUG_ON(!d_unhashed(dentry));
-
 	if (!inode)
 		goto out;
 
@@ -3116,6 +3109,8 @@ struct dentry *d_splice_alias_ops(struct inode *inode, struct dentry *dentry,
  * @inode:  the inode which may have a disconnected dentry
  * @dentry: a negative dentry which we want to point to the inode.
  *
+ * @dentry must be negative and may be in-lookup or unhashed or hashed.
+ *
  * If inode is a directory and has an IS_ROOT alias, then d_move that in
  * place of the given dentry and return it, else simply d_add the inode
  * to the dentry and return NULL.
@@ -3123,16 +3118,14 @@ struct dentry *d_splice_alias_ops(struct inode *inode, struct dentry *dentry,
  * If a non-IS_ROOT directory is found, the filesystem is corrupt, and
  * we should error out: directories can't have multiple aliases.
  *
- * This is needed in the lookup routine of any filesystem that is exportable
- * (via knfsd) so that we can build dcache paths to directories effectively.
+ * This should be used to return the result of ->lookup() and to
+ * instantiate the result of ->mkdir(), is often useful for
+ * ->atomic_open, and may be used to instantiate other objects.
  *
  * If a dentry was found and moved, then it is returned.  Otherwise NULL
- * is returned.  This matches the expected return value of ->lookup.
+ * is returned.  This matches the expected return value of ->lookup and
+ * ->mkdir.
  *
- * Cluster filesystems may call this function with a negative, hashed dentry.
- * In that case, we know that the inode will be a regular file, and also this
- * will only occur during atomic_open. So we need to check for the dentry
- * being already hashed only in the final case.
  */
 struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 {
-- 
2.50.0.107.gf914562f5916.dirty


