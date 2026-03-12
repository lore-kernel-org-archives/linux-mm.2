Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05019106FD60
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440B96B009F; Thu, 12 Mar 2026 20:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400B76B00AB; Thu, 12 Mar 2026 20:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ECB16B00AC; Thu, 12 Mar 2026 20:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18EF96B009F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:48:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A118413B082
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:48:26 +0000 (UTC)
X-FDA: 84539203812.21.4C54E7B
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5AD0F1C0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:48:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=dN+zoQ+X;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="34dgo/VI";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf18.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362904;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OVL4XXP8pGkqIJaCgrneigzeg9lURjpYtnSBAI2TgY=;
	b=4YPDXI4x9UnqUmhddnVN1kBCQy95B4+kn+EJnOQc+3+c4g5bJQq5mUaJnesRTNdk/zBWWa
	S7lizJH3dJcI+AfkADGvroC7XCGtqJdPIJzxs4iNIpED4+hnqfSw8kkDJJZxKF4EOrrqNQ
	XToOlFTvdNLuJhHbFhF7a4K4y28I7zY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=dN+zoQ+X;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="34dgo/VI";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf18.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362904; a=rsa-sha256;
	cv=none;
	b=GJub6LT28RSGY2e1Aj3+UYU3jK7gYjzKR5sCKZGeDpRy4yqZpwv0F1YYl4AaenCyS9gHLz
	LXSEh+Gxj88hZylFtzT19oHoDx29jwNN5FW/QABlcsGS0OY5zsfWNlLusmSGOIR/Dq08yh
	0kNK1cNHTWpyTK88AaW8/+TpRskFx+c=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 723B61301B7D;
	Thu, 12 Mar 2026 20:48:22 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 12 Mar 2026 20:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362902;
	 x=1773370102; bh=3OVL4XXP8pGkqIJaCgrneigzeg9lURjpYtnSBAI2TgY=; b=
	dN+zoQ+X4IMCOwHYdmkT/bGnzCHvuxlXBbrpp9O8UwCmnQeDDi7ioO7y2/TUY8l5
	mQGtxsh3qVE4W70GI8wjUfwVDAFocwzcsunO2RHndj6ssUSoW5JU5xyWRUYJYDG9
	NMIjn03yZHXunWH8BNEHahsglP7uOUYKduvq4RcsnRx45o5+YD6/oyA0D9GyutPP
	mLXDY4UxeKqfkDk1pTNpvWvnW1/dJJmaIfcBQR9lGPgKHB0zDYqbbg/WeD543BZ1
	YZZiFH4HEkOT7GPsszH0tbfrqAMP2nkAl+SHWoXH2ZfgLfzJ7G8Da4TigmEpPMMB
	kWwgCUIZj7EH1b7QHZSsmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362902; x=1773370102; bh=3
	OVL4XXP8pGkqIJaCgrneigzeg9lURjpYtnSBAI2TgY=; b=34dgo/VIKgtmzJGsl
	miC6lP3iQWBH1TiVT3V5XLsNBZ4hEoP69rm02c/9mKZc3HpddJ+Jm5BVWcJn9DkB
	57t0tJJgDeHpeL+ua3mR8GhZPmEwPi0lQb3PwN14P92l/6Ep6Qp5LUxmLxKuHb0F
	wZYQlWii+7LBp+7LMX/8e2iuf/gsPxQRwWVKDTbZSMt9L0ZT01nsdAwc9YTMK1yk
	3Ch2rxde/oduz5imnG5I61fP0o7Q2RmqJ7K3UEHPNtcBLNHsLWMstLaJPoAb0igY
	8DF5fJdmXv6TlSvdhF6xHSluXNYiYlg4IeJQvDDCwPSoyDiP0Juj0NE2pRGV7aHr
	PQHYQ==
X-ME-Sender: <xms:1V6zaXtH06rAO7pV4rOdlFXVNkVijrUmCf0vVAv_Ujaykp9lWFkVUA>
    <xme:1V6zaSL_4xMe1h15v6v_9nrb4svolCWWxRRWlp58JThkCtUqNOpn_7K56KAMV4jBN
    cGtzCL1Thm9U_31I3DYNACQlL80mseSG3Y6nzMDWD0wdm-FNw>
X-ME-Received: <xmr:1V6zaRsNHbq1HAAvorz2a4ifJogef7TXKmNqTpQcCe9PxHeFXpkqvRiwJY2ifrOJhZJ5aR-dtvC4AwJT1dpKudgAOgsZ9isPlFg0GubFOswr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epteetteeuteffveduveetgfdtuedvfffhudetuefgffejgffhgffhgfetffetudeinecu
    ffhomhgrihhnpehsthgrthhushdruggrthgrnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepnhgvihhlsgesohifnhhmrghilhdrnhgvthdpnhgs
    pghrtghpthhtohephedupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehvihhroh
    esiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtoheplhhinhhugidqgihf
    shesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhunhhioh
    hnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqthhr
    rggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:1V6zaaTzQHsC2J_WA_QH8YOW_5awtZOh6jhAGe4ctTmQ0wdnVKsSLA>
    <xmx:1V6zaXWc7zV7rd1I7sVLWCAwTLiktPdZhBNJ4HbNuPxgBSFuw-c-Lg>
    <xmx:1V6zaUwUe1ZPNR8n0_mEqCQ_Sd_NPmOB64IRNXt4wuoK-BJWr1Ospw>
    <xmx:1V6zaT_DAKDOpJYW6voXCzE3Z5WD-QvwjIkw_5BxIl1FpW93PzBDgA>
    <xmx:1l6zaV-vNAGrjs6_6LMnFfMVOi8yPfJmYBYHQZTtZUELj1jaKl8Npb0B>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:48:08 -0400 (EDT)
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
Subject: [PATCH 19/53] afs: use d_time instead of d_fsdata
Date: Fri, 13 Mar 2026 08:12:06 +1100
Message-ID: <20260312214330.3885211-20-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5AD0F1C0005
X-Stat-Signature: 715on88rea6gurphcqg7mr3z7t5p1bju
X-Rspam-User: 
X-HE-Tag: 1773362904-331033
X-HE-Meta: U2FsdGVkX1/NKdcjdvsjF+1dDHB7E8ag9k3BaBtuWzfLPK7a3tkjReu86UtSlXEAtiFhj2Tj/qzYwjxXv3G87ZW4DTO5ihcPM2y0i4+EW9hJzJBOEBK1Pc+nkPLL+rXiXV98Z/ijQn3zxakYDej3HIvnLZOGkabqSDbnVd/KJHHIC7Wgh1xRI0uL7TQk16mMxxdOTw5c9EiS1JlFpMsL5Mjwpj9NODOOw7ek0DR5kKFAvTo+Q9a/rIw7JmS/YikeAMQFDgpvDmGWSHlnUMucYTVLdPBk5HG0ne76vXxevKHdrlPW3UHujluNudoxeYldwSsGGJcVdqidneJMtPtUFdXmx0vwjMOZLj83Mu1mIiw8K/UzwUR8HLNtj45q3Y02uAgiXxA8/lxMC7Ww/IszliMpxICMlz9TwlZRxFtlv99vzBuLBQx/Po+z38kWo1jgiOn6InJXLcjKccp4Mb6wk5h8BpFzpnhAtOTlwIZqAe8IIKs2NTLSnG+niq4haq3Mc4C0bpsfTBGaYdaELEHgnmKi8gpDRM67+h98tpfEFT6JB+AJjs5LgMnHxvMQ52b7i3GBT53YFcsloudxTWZeIGLFSuAS3Xg5WwHvYDFIjED6DKlRorlQsB+OB2P5pNaGyt1WxBwlCqz9YhXiqm1Qj7ncb0IZwlbwanK9dPCrNg0ILjI75BgchepiqyIwqSFu/V29QIol1T7pnqtJfzCwASBD2NHpNzIoyc+x0naPfq0gqcRFca3onIJfnDTzNGP5J94WSAhGadXQCsg5pUInMqoUVY6UsboJOd6zM+XNaA5Nd8jPQHosZdmSXwYQDSjfUO3TQMGVd5dwbEknoqVK+EB5zEoItvF66Ff/XxC2GMbl0gcM7N4WIY7pAUZa8kBkCh2qrmgtI+ql1s0z6I0yn4V0cxo0hjIyCub3WAC7ZAIhq44Qou99QRrw+gv2YpjzqMhjAmR5GNDOgCjlsy8
 Tn9xdtyS
 3otlGxagGsr5MCLqSYI14hVvJm6CEpsR3il4mzYLtDKpHTwf3r+zthGlTfSHkR9HpPEpeAXE4TkMSBiq/BUnRC/B3HbocTu1zTua7FH4VauOiNZsSOrHruP21GZNG//b1w9jBv08PmxrZUh0kjZHJ3Jx00/+OqcGF8KXpzgXwbbypS0ZAJXBopI6pEprT1NTmln5bnTutXHuKtnEk6nuCjBxQqRTgq1hXwfaOe7F/DLE02I0NEynrqmgLoA2CkUwTix/90Ii+t7fcGz69Smd3INrMC2HD9KZEA8+wNtUNN3371GZmA2Uy8EmFnB7rYe9NqDwBsF5hyAvyRoU+54z4otGnFkd/HcKAxUdXIWpRX1PVFevCFn3SjBU7oJs45Dfo0AKJieFTuPYbPZneAvSMbRT573Q/WV1p7VuEcvElkiabwugEz+lNvFKOmaLcNuH0v1m3Y/Gcl1aLKdYqlXec1F+f9HG7F9tRKlYBZIdORcSdYIZwa3R/tzbrV5fKVEDLJbv07VjfPXrowDYTHQFGQN3GOPYHc8reOhI47JDWf5P+BAAllMn85WzHqqHsbXmD6+eaJznG557z7bjzapSqSMW5CiM0FDcrQGXs7Ei9j0jHiS0EW4/Cqvo6q4HpGU2YaUlpHRDu9AM1dno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

afs uses ->d_fsdata to store version information for the parent
directory.  ->d_time is arguably a better field to store this
information as the version is like a time stamp, and ->d_time is an
unsigned long, while ->d_fsdata is a void *.

This will leave ->d_fsdata free for a different use ...  which
admittedly is also not a void*, but is certainly not at all a time.

Interesting the value stored in ->d_time or d_fsdata is u64 which is a
different size of 32 bit hosts.  Maybe that doesn't matter.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/afs/dir.c      | 18 +++++++++---------
 fs/afs/internal.h |  8 ++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 78caef3f1338..a0417292314c 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -808,7 +808,7 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry)
 		afs_dir_iterate(dir, &cookie->ctx, NULL, &data_version);
 	}
 
-	dentry->d_fsdata = (void *)(unsigned long)data_version;
+	dentry->d_time = (unsigned long)data_version;
 
 	/* Check to see if we already have an inode for the primary fid. */
 	inode = ilookup5(dir->i_sb, cookie->fids[1].vnode,
@@ -895,9 +895,9 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry)
 	}
 
 	if (op->file[0].scb.have_status)
-		dentry->d_fsdata = (void *)(unsigned long)op->file[0].scb.status.data_version;
+		dentry->d_time = (unsigned long)op->file[0].scb.status.data_version;
 	else
-		dentry->d_fsdata = (void *)(unsigned long)op->file[0].dv_before;
+		dentry->d_time = (unsigned long)op->file[0].dv_before;
 	ret = afs_put_operation(op);
 out:
 	kfree(cookie);
@@ -1010,7 +1010,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 	_debug("splice %p", dentry->d_inode);
 	d = d_splice_alias(inode, dentry);
 	if (!IS_ERR_OR_NULL(d)) {
-		d->d_fsdata = dentry->d_fsdata;
+		d->d_time = dentry->d_time;
 		trace_afs_lookup(dvnode, &d->d_name, &fid);
 	} else {
 		trace_afs_lookup(dvnode, &dentry->d_name, &fid);
@@ -1040,7 +1040,7 @@ static int afs_d_revalidate_rcu(struct afs_vnode *dvnode, struct dentry *dentry)
 	 * version.
 	 */
 	dir_version = (long)READ_ONCE(dvnode->status.data_version);
-	de_version = (long)READ_ONCE(dentry->d_fsdata);
+	de_version = (long)READ_ONCE(dentry->d_time);
 	if (de_version != dir_version) {
 		dir_version = (long)READ_ONCE(dvnode->invalid_before);
 		if (de_version - dir_version < 0)
@@ -1100,7 +1100,7 @@ static int afs_d_revalidate(struct inode *parent_dir, const struct qstr *name,
 	 * version.
 	 */
 	dir_version = dir->status.data_version;
-	de_version = (long)dentry->d_fsdata;
+	de_version = (long)dentry->d_time;
 	if (de_version == (long)dir_version)
 		goto out_valid_noupdate;
 
@@ -1161,7 +1161,7 @@ static int afs_d_revalidate(struct inode *parent_dir, const struct qstr *name,
 	}
 
 out_valid:
-	dentry->d_fsdata = (void *)(unsigned long)dir_version;
+	dentry->d_time = (unsigned long)dir_version;
 out_valid_noupdate:
 	key_put(key);
 	_leave(" = 1 [valid]");
@@ -1931,7 +1931,7 @@ static void afs_rename_edit_dir(struct afs_operation *op)
 		spin_unlock(&new_inode->i_lock);
 	}
 
-	/* Now we can update d_fsdata on the dentries to reflect their
+	/* Now we can update d_time on the dentries to reflect their
 	 * new parent's data_version.
 	 */
 	afs_update_dentry_version(op, new_dvp, op->dentry);
@@ -2167,7 +2167,7 @@ static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	}
 
 	/* This bit is potentially nasty as there's a potential race with
-	 * afs_d_revalidate{,_rcu}().  We have to change d_fsdata on the dentry
+	 * afs_d_revalidate{,_rcu}().  We have to change d_time_ on the dentry
 	 * to reflect it's new parent's new data_version after the op, but
 	 * d_revalidate may see old_dentry between the op having taken place
 	 * and the version being updated.
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 009064b8d661..106a7fe06b56 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1746,17 +1746,17 @@ static inline struct inode *AFS_VNODE_TO_I(struct afs_vnode *vnode)
 }
 
 /*
- * Note that a dentry got changed.  We need to set d_fsdata to the data version
+ * Note that a dentry got changed.  We need to set d_time to the data version
  * number derived from the result of the operation.  It doesn't matter if
- * d_fsdata goes backwards as we'll just revalidate.
+ * d_time goes backwards as we'll just revalidate.
  */
 static inline void afs_update_dentry_version(struct afs_operation *op,
 					     struct afs_vnode_param *dir_vp,
 					     struct dentry *dentry)
 {
 	if (!op->cumul_error.error)
-		dentry->d_fsdata =
-			(void *)(unsigned long)dir_vp->scb.status.data_version;
+		dentry->d_time =
+			(unsigned long)dir_vp->scb.status.data_version;
 }
 
 /*
-- 
2.50.0.107.gf914562f5916.dirty


