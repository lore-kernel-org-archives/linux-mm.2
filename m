Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403A3106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17E76B00E3; Thu, 12 Mar 2026 17:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8C46B00E5; Thu, 12 Mar 2026 17:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0E36B00E6; Thu, 12 Mar 2026 17:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75E756B00E3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:58:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 489378B853
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:58:16 +0000 (UTC)
X-FDA: 84538774992.13.B95D736
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf05.hostedemail.com (Postfix) with ESMTP id 42ADB100011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:58:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="Aiv/eft0";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=1OKI1aeP;
	spf=pass (imf05.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773352694;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUCVEDpSf+0EP+yvqNrKKgbgS6k/EkMfChZKLZ22YF8=;
	b=NnYrWLEiQ0r7lhSeYmxWbFE+QpMKO7zRXTGH6ilmPfmEi+sKNsQlkG9cFyvbdvVnDY8MEv
	FJ6TXdg5sUeWtVbxvF38z37Q/z/6Xj1wjan332CmeHAm1X7b7yjAwVhXpk1EFPgcB46BXM
	DxdsvogmAbGnDwlJy/Wz3orbbmt/FSM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773352694; a=rsa-sha256;
	cv=none;
	b=QoQVfsKTvqT9l4j6QC3Y2M5YTlcg8hE56mqZqvytdsWn1UD8K5G5ia8OSatdk80QEdBgYJ
	d2hK8ndt9cNY1MUfcBdOtapFhpUjZpTQmdr+7xX/DS5NSzR1m+gsxqVPd4JgM8lfnRtZrR
	stdVrqGfUV2OsAUqrl1t3VN+is16aIo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="Aiv/eft0";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=1OKI1aeP;
	spf=pass (imf05.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.141 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.stl.internal (Postfix) with ESMTP id 531271301B68;
	Thu, 12 Mar 2026 17:58:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 12 Mar 2026 17:58:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352692;
	 x=1773359892; bh=MUCVEDpSf+0EP+yvqNrKKgbgS6k/EkMfChZKLZ22YF8=; b=
	Aiv/eft0lgPfT980cKxeTnbansdx69JMDdu3/JvECSezFjIw35T8po0J7Dr8uNz3
	sIBBHBdSe4MXUrEF8Fj06jbhW2EE7JC8gaPZzvxL4boq4YxDZ+CRXvvNlgYjU+ad
	zVo48RhaQGZQOjrYGJTHjDPxeGvcjtjerjOc4eh0NjzqVTlyohkpdmmv2NUqgUY0
	kGTPr9S74jE/j+NCuYF03/ks4uS34m9TEH/qtCulLr0zXqcwhZT0jqA18NZMxYk8
	7Q7QidM3FocAj62Z/Xs8FMUmSkMlrAh0Tu4ZwGqs+fXuxjjYBw4q/KLFBSxgulO/
	O8xZvAKjbOCAu8Ctbd/xlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352692; x=1773359892; bh=M
	UCVEDpSf+0EP+yvqNrKKgbgS6k/EkMfChZKLZ22YF8=; b=1OKI1aeP/URdJ6EVy
	Z+vyP9J8PKZrd0kY//3qj71VewKCNrnBkJOvFWrxGJymoeibivc952VMmJ0Wmphn
	GdXCcWC2chTiQ8YEYimV8Wfe46qK2KFxr0eSSwm2kf+ajXccqEga9+LHL5oUW84X
	yEB8WJoc/CtgIS9uwc4JfckT9M7HIIj9BkYyKEc7UKLYbnFaA3YX1pZd7rtnIM7X
	0CSikuFS9fiJ8+Et3mu0UkfKU4IGmFqiDYedmOmjR/0tGilyq8lfTDvk4GLhoa0C
	FKHKzDyWUSwTK3s6Ka962SMkXym18zo7X8d44IXEmqoskkODbePuGhcnghfwNyOh
	65kZw==
X-ME-Sender: <xms:8zazaZFnoL8nTaaYepHGpsupAfToMV1lBcOZjtfZuL-x6VPw3SWcTA>
    <xme:8zazaSAZo4J78ZKHviJoQ10vRcZP6ii2DtWlvfEKAp3RekpRuw90IejAvYRzXDFwn
    Yc4RlxEYTkb05EfEfYvmJjkVqqbfriM8oqn-yznpG8ry3DPhg>
X-ME-Received: <xmr:8zazaWOA1gfEptRTXhBFBUUqip5J9NWoLsZfbbynxyjbB4YaJqvofFlgOJi-xvcNcJEMzCUijUyS1Q2aXEJGU1Wh6GK96JOVcKRNeRYsjKcL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnefuuh
    gsshhtuchvrghrshculdehtddmnecujfgurhephffvvefufffkofgjfhhrggfgsedtkeer
    tdertddtnecuhfhrohhmpefpvghilheurhhofihnuceonhgvihhlsgesohifnhhmrghilh
    drnhgvtheqnecuggftrfgrthhtvghrnhepveevkeffudeuvefhieeghffgudektdelkeej
    iedtjedugfeukedvkeffvdefvddunecuvehluhhsthgvrhfuihiivgepudenucfrrghrrg
    hmpehmrghilhhfrhhomhepnhgvihhlsgesohifnhhmrghilhdrnhgvthdpnhgspghrtghp
    thhtohephedupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehvihhrohesiigvnh
    hivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtoheplhhinhhugidqgihfshesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhunhhiohhnfhhsse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqthhrrggtvgdq
    khgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugi
    dqnhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhk
    vghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    hfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqvgigthegsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugi
    dqvghfihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:9Dazach7av5MJT8wwTcG8MKSecwRaPCM_rUgbieUz9-plDpwI6zy9g>
    <xmx:9DazaU2BJC8dq5eg3cq_PE4esCqPkCfcmRsZ9j1K6OYny_6Tiy29xg>
    <xmx:9DazaWrD5GSVDOaic2AawCbj7ijw4e0hSyT9fTNC10lRFnoKpI1HXQ>
    <xmx:9DazaZ3IuPVJmTmgR8W3UIMoIjUFqPw7tpd4R62FV11LjodKC9RNvg>
    <xmx:9DazaVRBxjCwEQEOkYevKr9zMpuJ2elXpo_n74CoZdvgrzBnIBgDvJIG>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:57:59 -0400 (EDT)
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
Subject: [PATCH 51/53] VFS: use d_alloc_parallel() in lookup_one_qstr_excl().
Date: Fri, 13 Mar 2026 08:12:38 +1100
Message-ID: <20260312214330.3885211-52-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 42ADB100011
X-Stat-Signature: io557e695petrqzuuhg9rpudpgdmczjp
X-Rspam-User: 
X-HE-Tag: 1773352694-504713
X-HE-Meta: U2FsdGVkX19D5DJTxOXWfgJO7IPcWGyYc/1VFUdGKxRsZvGkoysfGqrfPxme8OJQRk3SFtyFkguZVxylqcnPgf8l5tLrYOGLEXxTMEaC4wYtLd2y/di7twUFfbYtIKF46N82GjnHzHb2wmfAMjOsJrODlJiXqjxZFydXxdIDonCOsgwie6aoDIMUHZgvEkreu/XQ1EwpIFgfenKrfEBZ6LJw5Z4K1jEzpKLMULX7UNySjJCW3H1yo54TkMAlt0JadpRAgx2nMMzOZS2HF+Qy3yWNvlXLZ33BhXzUl6j6G3hKQKzvcaqRumj3ouWcdRkPRkFWgyIQOhdAMABqHycIRqmEm7wiaiCrDqXM6esagn1j7vcPlc2swhUvaYuXWKJ/R1OJjftukPmuGmlWTtmIJzyy6/g9iyQRBi+qjkHNSeKFKhBSqKL4Vti+dPFX8wN6/pJDN5EcOse7W0W/K/rjHKQIVqfTs4Q+apxQqhT7rQm25jIOs4E19H4p6kVjo4d+L55Wv+KxWn3Qv5dtMRZNzItF/mNCRl/PnN9N3i8fGVhDS4i12PU06yNPoKkvjbB58NskysiIpxh4ZctrI907PQbak2BqEiQIFP+z0rX+TgHnSQccaStknmPv6n+7XmKS+M7BgDMVYL58887cpo3FOx1BiYgAZMr909vfM8M988NI3483r7FVTESnbi52Oy9QUlrk7UjQ6hiF06DHs2Ego9lJcMk1wA+aqJYUbeImzbmnulIqBe+jmLZT1WmSdiX+raLg1PIVj22AOJjytZ6o9rwMrgmznl58SB0X6zJ8/ZxbK3fxVomo31/yTOIyz842Sd/kv3/yuYjzXFY/kpIqccGSup/zTiuo8yELrgUUctCzfh+7mG1WLozMetSzOIj06h7p/X4iKbXL4SmVy7L6N1oQyRgp0sk5ZqK2wKvjpxj2oQMISqR851/ZQR4q5R4ybAgebjg6725DJ5fsyFC
 BsjTqKvJ
 TODKQXB+yLnfYl6J/NaAWnF0HWm9Lwj/fZ5ZJFLv5hVDwvvf8H0ICWKf0Q8wgGCyMXcrGMufpyfzxVJWjGt2Piz8+UeJyuc9x6U/i2a+QnJJfXoakoAnfvfk+eNKAe+BO4SD57mz76mRgWF1qt7zDXV9naJs8gM7DG6iavpvan3Sj9fYAHzV4aYsqrHIeA+QsLVvm8YqV71mGz+MFrLA66rn7XSb3p153FbkCzURU/RfBeU0czZ0USoPVt1qvHSxccM5SoAUQ67ag7gIQbFxeNhAtr+09frUAmbYCG8FpV0ojcSniN3lmF46w6soajifpEWyTjbG1lMayxeDTkzRppAah/yobQZWewG/vtPASfWWZ+9Yxwof3jSWhTwjujKhj63VTtqdk5LPiUqsTJr+N3E7fpgddVkHC5Faee0YQZMNRHXl3NUbWjMQYV/g/jHrMCB0OtDanJk3EZDDMULzk6kuPu2N39giGgHvj9sV40mXxDDeRVUjs69YrSFnuqUrd8NP3o2hxVEdaknYFnBBRVr8+7OvVot2D/q2igtHQLWlEko3i0e2H+Vy1uQUBRxMBeOlMqZ2LdwyIxUNd1BMkdAXeQLeWbQGk4ydKXtPYuwPaWdTB4snM6ZJl4Q7mA0nFPIB8M3B+MTCwUZ5HralNw6TGadq4ueMbruTwzM6F4WAlvs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

lookup_one_qstr_excl() is used for lookups prior to directory
modifications (other than open(O_CREATE)), whether create, remove,
or rename.

A future patch will lift lookup out of the i_rwsem lock that protects
the directory during these operations (only taking a shared lock if the
target name is not yet in the dcache).

To prepare for this change and particularly to allow lookup to
always be done outside the parent i_rwsem, change lookup_one_qstr_excl()
to use d_alloc_parallel().

For the target of create and rename some filesystems skip the
preliminary lookup and combine it with the main operation.  This is only
safe if the operation has exclusive access to the dentry.  Currently
this is guaranteed by an exclusive lock on the directory.
d_alloc_parallel() provides alternate exclusive access (in the case
where the name isn't in the dcache and ->lookup will be called).

As a result of this change, ->lookup is now only ever called with a
d_in_lookup() dentry.  Consequently we can remove the d_in_lookup()
check from d_add_ci() which is only used in ->lookup.

If LOOKUP_EXCL or LOOKUP_RENAME_TARGET is passed, the caller must ensure
d_lookup_done() is called at an appropriate time, and must not assume
that it can test for positive or negative dentries without confirming
that the dentry is no longer d_in_lookup() - unless it is filesystem
code acting on itself and *knows* that ->lookup() always completes the
lookup (currently true for all filesystems other than NFS).
This is all handled in start_creating() and end_dirop() and friends.

Note that as lookup_one_qstr_excl() is called with an exclusive lock on
the directory, d_alloc_parallel() cannot race with another thread and
cannot return a non-in-lookup dentry.  However that is expected to
change so that case is handled with this patch.

Signed-off-by: NeilBrown <neil@brown.name>
---
 Documentation/filesystems/porting.rst | 14 ++++++++++
 fs/dcache.c                           | 16 +++--------
 fs/namei.c                            | 38 ++++++++++++++++++++-------
 3 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 7e83bd3c5a12..5ddc5ecfcc64 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1403,3 +1403,17 @@ you really don't want it.
 lookup_one() and lookup_noperm() are no longer available.  Use
 start_creating() or similar instead.
 
+
+---
+
+**mandatory**
+
+All start_creating and start_renaming functions may return a
+d_in_lookup() dentry if passed "O_CREATE|O_EXCL" or "O_RENAME_TARGET".
+end_dirop() calls the necessary d_lookup_done().  If the caller
+*knows* which filesystem is being used, it may know that this is not
+possible.  Otherwise it must be careful testing if the dentry is
+positive or negative as the lookup may not have been performed yet.
+
+inode_operations.lookup() is now only ever called with a d_in_lookup()
+dentry.
diff --git a/fs/dcache.c b/fs/dcache.c
index abb96ad8e015..f573716d1a04 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2261,18 +2261,10 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 		inode_unlock_shared(d_inode(dentry->d_parent));
 	else
 		inode_unlock(d_inode(dentry->d_parent));
-	if (d_in_lookup(dentry)) {
-		found = d_alloc_parallel(dentry->d_parent, name);
-		if (IS_ERR(found) || !d_in_lookup(found)) {
-			iput(inode);
-			return found;
-		}
-	} else {
-		found = d_alloc(dentry->d_parent, name);
-		if (!found) {
-			iput(inode);
-			return ERR_PTR(-ENOMEM);
-		}
+	found = d_alloc_parallel(dentry->d_parent, name);
+	if (IS_ERR(found) || !d_in_lookup(found)) {
+		iput(inode);
+		return found;
 	}
 	if (shared)
 		inode_lock_shared(d_inode(dentry->d_parent));
diff --git a/fs/namei.c b/fs/namei.c
index cb80490a869f..bba419f2fc53 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1774,13 +1774,14 @@ static struct dentry *lookup_dcache(const struct qstr *name,
 }
 
 /*
- * Parent directory has inode locked exclusive.  This is one
- * and only case when ->lookup() gets called on non in-lookup
- * dentries - as the matter of fact, this only gets called
- * when directory is guaranteed to have no in-lookup children
- * at all.
- * Will return -ENOENT if name isn't found and LOOKUP_CREATE wasn't passed.
- * Will return -EEXIST if name is found and LOOKUP_EXCL was passed.
+ * Parent directory has inode locked.
+ * If Lookup_EXCL or LOOKUP_RENAME_TARGET is set
+ * d_lookup_done() must be called before the dentry is dput()
+ * If the dentry is not d_in_lookup():
+ *   Will return -ENOENT if name isn't found and LOOKUP_CREATE wasn't passed.
+ *   Will return -EEXIST if name is found and LOOKUP_EXCL was passed.
+ * If it is d_in_lookup() then these conditions can only be checked by the
+ * file system when carrying out the intent (create or rename).
  */
 static struct dentry *lookup_one_qstr_excl(const struct qstr *name,
 					   struct dentry *base, unsigned int flags)
@@ -1798,18 +1799,27 @@ static struct dentry *lookup_one_qstr_excl(const struct qstr *name,
 	if (unlikely(IS_DEADDIR(dir)))
 		return ERR_PTR(-ENOENT);
 
-	dentry = d_alloc(base, name);
-	if (unlikely(!dentry))
-		return ERR_PTR(-ENOMEM);
+	dentry = d_alloc_parallel(base, name);
+	if (unlikely(IS_ERR(dentry)))
+		return dentry;
+	if (unlikely(!d_in_lookup(dentry)))
+		/* Raced with another thread which did the lookup */
+		goto found;
 
 	old = dir->i_op->lookup(dir, dentry, flags);
 	if (unlikely(old)) {
+		d_lookup_done(dentry);
 		dput(dentry);
 		dentry = old;
 	}
 found:
 	if (IS_ERR(dentry))
 		return dentry;
+	if (d_in_lookup(dentry))
+		/* We cannot check for errors - the caller will have to
+		 * wait for any create-etc attempt to get relevant errors.
+		 */
+		return dentry;
 	if (d_is_negative(dentry) && !(flags & LOOKUP_CREATE)) {
 		dput(dentry);
 		return ERR_PTR(-ENOENT);
@@ -2921,6 +2931,8 @@ static struct dentry *__start_dirop(struct dentry *parent, struct qstr *name,
  * The lookup is performed and necessary locks are taken so that, on success,
  * the returned dentry can be operated on safely.
  * The qstr must already have the hash value calculated.
+ * The dentry may be d_in_lookup() if %LOOKUP_EXCL or %LOOKUP_RENAME_TARGET
+ * is given, depending on the filesystem.
  *
  * Returns: a locked dentry, or an error.
  *
@@ -2942,6 +2954,7 @@ void end_dirop(struct dentry *de)
 {
 	if (!IS_ERR(de)) {
 		inode_unlock(de->d_parent->d_inode);
+		d_lookup_done(de);
 		dput(de);
 	}
 }
@@ -3854,8 +3867,10 @@ __start_renaming(struct renamedata *rd, int lookup_flags,
 	return 0;
 
 out_dput_d2:
+	d_lookup_done(d2);
 	dput(d2);
 out_dput_d1:
+	d_lookup_done(d1);
 	dput(d1);
 out_unlock:
 	unlock_rename(rd->old_parent, rd->new_parent);
@@ -3950,6 +3965,7 @@ __start_renaming_dentry(struct renamedata *rd, int lookup_flags,
 	return 0;
 
 out_dput_d2:
+	d_lookup_done(d2);
 	dput(d2);
 out_unlock:
 	unlock_rename(old_dentry->d_parent, rd->new_parent);
@@ -4059,6 +4075,8 @@ EXPORT_SYMBOL(start_renaming_two_dentries);
 
 void end_renaming(struct renamedata *rd)
 {
+	d_lookup_done(rd->old_dentry);
+	d_lookup_done(rd->new_dentry);
 	unlock_rename(rd->old_parent, rd->new_parent);
 	dput(rd->old_dentry);
 	dput(rd->new_dentry);
-- 
2.50.0.107.gf914562f5916.dirty


