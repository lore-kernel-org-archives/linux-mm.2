Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69840106FD60
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85E16B0099; Thu, 12 Mar 2026 20:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D4A6B00A9; Thu, 12 Mar 2026 20:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07DA6B00AA; Thu, 12 Mar 2026 20:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF3A6B0099
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:47:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 546291B8133
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:47:51 +0000 (UTC)
X-FDA: 84539202342.22.5FE9319
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf02.hostedemail.com (Postfix) with ESMTP id 44FE480003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:47:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=kDoltOk9;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=fLlbZhFz;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362869;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKC2mXuXBSvpu/yXLNU8JNN/9B9bcozYCtRp08XnGKg=;
	b=lPi3VzIvx8RmKmbw7XuXKvPjB7TxLW9QrOTCYFV9eJpGpnCef+PmOwp7FRuacKzEfzI9sB
	buNV0SKbCq8qhID+sCK0GRUUtCipGcjSVD7/3Kk34/xoApOCQYg3lK2I5z2mBv793atXoM
	bZbgKyiIEEvzBpYYdQCi3F5yQfUpJbM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362869; a=rsa-sha256;
	cv=none;
	b=bX3oiT8vG5V+daJpaDYoG/OmM9H/bKUrJpE9Vse/koPCYpc86ZXxdZgIn9OD2xRQFuX91Z
	joESSWmI4QIzmzG+TmqPNcmqSn3wO6dPevIhj/Z8GiYvPEwaVmIzquP7Qx03nlbsDldKDc
	nO3LnJDt3AUE31VEPXvX7QvoIl+3Hmw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=kDoltOk9;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=fLlbZhFz;
	spf=pass (imf02.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailflow.stl.internal (Postfix) with ESMTP id 525851301B74;
	Thu, 12 Mar 2026 20:47:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 12 Mar 2026 20:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362867;
	 x=1773370067; bh=IKC2mXuXBSvpu/yXLNU8JNN/9B9bcozYCtRp08XnGKg=; b=
	kDoltOk9PS7j42/x8/QD6W2oySfH8jqtPn+udHVYH0MDyECLvp3g7QS7jalbAMpU
	eMimso/ozabOCqmYob+F+bx6ZH+xyy12nIx8jz5w/HQRO+brXlRSgeDbBeQc1vp5
	rwnbuAPA61dGJZ2OJvVLgtM8YGVE8OPfDhwWbbJ7c+PWZUldd3UtgxzXmvSyURKf
	r4+Zi6dNkDdhbxO9uVPdUGOmwGwapSfHGqwmz28c3AQCMDtMC25ElplGN7Uejeoo
	ZvxKZA1SW/rrh4Of2rBjHHTaF+gXQntOs5vHb9vtZsHebUgxTPaX6w6Zy3UlYLP7
	N1fZbJtIPeDqYNdbo5oyDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362867; x=1773370067; bh=I
	KC2mXuXBSvpu/yXLNU8JNN/9B9bcozYCtRp08XnGKg=; b=fLlbZhFzwd90VIqqe
	qYrOogss2BKl4uOQU0iVdtU8kNX0XHhSxmS2esGSjI2DreIGsCE2h//QAC2BK1h7
	31X9Ii5WxuWCUcsxGyQP0XOlhY1AY9QsaoYlzbNKHSvrphU+k1lFDc6C4fHPgkRr
	BRdgSdFyL0PXFJHboOrYRwzF/2iX2lvJ75lvYBZY4xuk3s1bY+f3PDj1Y/uy7X8S
	uQCyJPqAWKZDnIuLAgHCIsRtC0O8+C+4BpjD4HdtqKBwoCslIfl3kOSwazcKw0s3
	6j/mrP3zPbwdOXsv0PfPh9ZeIhPxNXjEseN3qe2xmr/mTvWCgWzHD75V4WIkXXtp
	6qagQ==
X-ME-Sender: <xms:sl6zaQqLN6SXWgQ0X9OhGon4ALmMO99qFHYbl606GVVGetqlKwiSDw>
    <xme:sl6zaaXpZ0KGR90QuZ6TEsibhtB2bw33Msxs5APnQVniflr0Z89epk8Zc-I4WKEZL
    948MdzTciFFbywDmPvot3ztTX0gQowucId8Izz_6sY7_6T_>
X-ME-Received: <xmr:sl6zaQTHlhIdLiGwrTQGHIBpvTbIjOX7PKd3oP8oy2UW5i5-t89z5KBgS0u3bG-bzYWMGVd0sYM74nDpz1vkpLVVdaV1N010NddhWdMeCHWe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:sl6zaVU0KQz7EyDRV46BoQOTAp2TlpsypoUoQ4-pI9TMtZnLakGK1Q>
    <xmx:sl6zaVbDI8vxUKMxdjaHMW86AJlvq2cJHrIXOY86RoGjgF_TRGaxCg>
    <xmx:sl6zaT_3M9Sf4gMoixS5K6KRVpOAhOH-XRsD3F0fDaHCa9lDDRy4oQ>
    <xmx:sl6zaU44XwH810Q2QaRAMkeQbS9hG6kK5ZwkxoFUKG96qzR0cF1esg>
    <xmx:s16zaY0V9cCDm8fR9vm55e7g2iqc5cbTbROJIkGo4VRHARXdbBq218XZ>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:47:33 -0400 (EDT)
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
Subject: [PATCH 21/53] afs: use d_splice_alias() in afs_vnode_new_inode()
Date: Fri, 13 Mar 2026 08:12:08 +1100
Message-ID: <20260312214330.3885211-22-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: u7ai9jzx444q45q4iq1poas6ze3ct67e
X-Rspamd-Queue-Id: 44FE480003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773362869-448627
X-HE-Meta: U2FsdGVkX1+tHdWGzYOQdvTZBdsff8HEKHs7XVwR7Dje9UtZ4DPDRObMJmQ+4D3ai6jd271ABLdxHLMtdQwEp/zoTvkctMRZbuFXxkTutIrSKOmPfc+gqUIf+syRZufZXeQtZ2HKZ/FRnYYVtJXASblr+BNn4A4asIaSRtEZZIW3P6MTKz1q9YIbXXKsVTbn3wvBPuiW4ySJURzRt3muEcbXeu9YKgJdcemMAU166o4T+Y9PyrOyNhPNIR1I0XgGL0/tVK6w2bm3lcOxJ5LK3Gfh3IWBiHdzk+++o4zE4rgNnMAT+/r+6WY7q7xnaKuZm41BjJV0pQ5Q286AmHabXqUtOPMI6HmEPKYwGyMYj1RTi8zg9cdP6uc7gZuiw5YEGaWmAAhnDvoLDzsfuAhaV00CTqiADlhwl3rbL1xT1Mb+GzCOg3RI+A7Yw6Eu+bJFAKECrd8Xv6ZVDa8h8MupQe3IHICBMEdF42iWMfZZhYYu45CQYHajbijscSy7PvIKqalFCbXYmnnx98jwKhFbhmgid5/EHT2m6BVZOy/SHMTpC29MQLxbLQhNDCMfng6U/PNGeXgVhis0Ak0GfArQJn0Il3KxAzC66Qq9rrPs5NQw17RzQeH8G6LQXlo4zi6+9DmbGKyKXbR/hoyJJP+j5mG41AtjW+2cLMSUh9T05hUn+qQSF8XQ94aSQ92pbwqTre/DmPGTlMxw7y26VGqCv4cgDKqWIn32PkYFkl3t0MpLbxg44/6fswbN/cP1JdSIfWs3DByxfYoV2RNsboP905BbcdBUlav6BAJwYaB9Nyusol0edDcOanX/ER0FWVpOfstB3xMDDAtDl1Yz8o6UzTmjuBZuFrro5fAsJNHkUXJBDq/5O+99aItG8MRSyIRUya/aelIgndq6PzvMe0DmTkCeTNLyBXdoCcw0STRbcu62CoRrzM2orbzRLfteGzEoINqaiSalMqAKg40BwRn
 5+iTvz8Q
 06YZRwQu5nqYxG3HLleQoZJxUEkOjdbgtTZ625/ZjDONhx5zuY4Odu2LzeX1kaYCFw2QaTQvmm/8Emu2MKNYRqT0cpvebdR2SJTAm89FS4rfS63znJqEcgOk6b5SD4BdE0MTjh6mm0y/vbjQlhpA+DWszICXfx7h9SkePk1CoaCoaJYL1OYZKNTtSu48zBFkQ01xctYuQQnDKlJzEXycuH0tOeUtQuLo8DOWWWz3oG3+mQIojbHamfpm03fYeRi7J5xwwllMrVAe8KpaJqsVF98pfS/kD9lnLPOQ60vWro9EfBqHRv74/uZ5NOeGamdc/yewsZN3vjN8C6D+MQ8zvQM1acDOdGgYrGyWjZhYdWdglK94SwOLSnuzWuAWrkB/NuGZYsA5YQgiB50pv8A9soxt18wVlMhbgRG7pJRKby6xtK0/pYM/xy5u0IkwtrIIUlJMdaMG0Js9fXi8s6Hx16VTXTZsHChTPp1rKeYPIgO0d8PmmMFO4BJ2etALqWpmyeZlvOT60jmhvWisMqTh8zBjPZK6K+4KOVtkcuERNGdgcG7Ewa+GGeRZAA/04n9WN6WzQEMWZaDVYxuRjQNuKg+OOa1c62OKmRo5CBgF6lVEcLChldxM9eLUUBRdidYlOvzFPaMwqYYP+re2xpoDjQfKUPZIY1XJiy3OreNmAfwwCHCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

As afs supports the fhandle interfaces there is a theoretical possibility
that the inode created for mkdir could be found by open_by_handle_at()
and given a dentry before d_instantiate() is called.  This would result
in two dentries for the one directory inode, which is not permitted.

So this patch changes afs_mkdir() to use d_splice_alias() and to
return the alternate dentry from ->mkdir() if appropriate.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/afs/dir.c      | 14 ++++++++++----
 fs/afs/internal.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9c57614feccf..1e472768e1f1 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1248,7 +1248,7 @@ void afs_check_for_remote_deletion(struct afs_operation *op)
 /*
  * Create a new inode for create/mkdir/symlink
  */
-static void afs_vnode_new_inode(struct afs_operation *op)
+static struct dentry *afs_vnode_new_inode(struct afs_operation *op)
 {
 	struct afs_vnode_param *dvp = &op->file[0];
 	struct afs_vnode_param *vp = &op->file[1];
@@ -1265,7 +1265,7 @@ static void afs_vnode_new_inode(struct afs_operation *op)
 		 * the new directory on the server.
 		 */
 		afs_op_accumulate_error(op, PTR_ERR(inode), 0);
-		return;
+		return NULL;
 	}
 
 	vnode = AFS_FS_I(inode);
@@ -1276,7 +1276,7 @@ static void afs_vnode_new_inode(struct afs_operation *op)
 		afs_init_new_symlink(vnode, op);
 	if (!afs_op_error(op))
 		afs_cache_permit(vnode, op->key, vnode->cb_break, &vp->scb);
-	d_instantiate(op->dentry, inode);
+	return d_splice_alias(inode, op->dentry);
 }
 
 static void afs_create_success(struct afs_operation *op)
@@ -1285,7 +1285,7 @@ static void afs_create_success(struct afs_operation *op)
 	op->ctime = op->file[0].scb.status.mtime_client;
 	afs_vnode_commit_status(op, &op->file[0]);
 	afs_update_dentry_version(op, &op->file[0], op->dentry);
-	afs_vnode_new_inode(op);
+	op->create.ret = afs_vnode_new_inode(op);
 }
 
 static void afs_create_edit_dir(struct afs_operation *op)
@@ -1356,6 +1356,12 @@ static struct dentry *afs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	op->ops		= &afs_mkdir_operation;
 	ret = afs_do_sync_operation(op);
 	afs_dir_unuse_cookie(dvnode, ret);
+	if (op->create.ret) {
+		/* Alternate dentry */
+		if (ret == 0)
+			return op->create.ret;
+		dput(op->create.ret);
+	}
 	return ERR_PTR(ret);
 }
 
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index f2898ce9c0e6..ce94f10a14c0 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -889,6 +889,7 @@ struct afs_operation {
 			int	reason;		/* enum afs_edit_dir_reason */
 			mode_t	mode;
 			const char *symlink;
+			struct dentry *ret;
 		} create;
 		struct {
 			struct dentry	*unblock;
-- 
2.50.0.107.gf914562f5916.dirty


