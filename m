Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11A5A106FD63
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCF36B00A1; Thu, 12 Mar 2026 20:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4316B00A3; Thu, 12 Mar 2026 20:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BF16B00A4; Thu, 12 Mar 2026 20:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB7F6B00A1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:46:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 005B4140538
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:46:24 +0000 (UTC)
X-FDA: 84539198688.15.DB6454F
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1A97B180007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:46:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=WHV8jLjR;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="ZIH5/VZH";
	spf=pass (imf16.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362783;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=beibKrJw8gVlJSS1MC+gPsWPAAjnc1lfM9GVMreQ7l0=;
	b=Zf0bNC2ewepBaSWT+nFK/VC+C1fXzPzt/1Hk94TdzHc8nNyNk3SfwWHoxshE2AezDUfUm9
	d91jnkgWEj6BPHr8NHBLck1fXDts8cnJb12z/+ulIN4gLzVbbJ6Vay0CtJ3w/eHa/m1MAA
	KnxctiJmq/6XmO1nf9kfzgvno7h/1pY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=WHV8jLjR;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="ZIH5/VZH";
	spf=pass (imf16.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362783; a=rsa-sha256;
	cv=none;
	b=KpLnoNT6xPi28TQksCrY4zDrGTCbsAIGzt873Cda8Vq6hT43/Y7gmOS0Xk6jDkr+RB096K
	JZ00ESc5bL1n57fM9J9Iv2sjI6clTziLtVln5wA8zb19LDE+gpYiyZDD5KsGjRYx0nQjbC
	Tb6LDS3/9DCyPfoyHmQf4EBRXYEf9Dc=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 2F4F01301B58;
	Thu, 12 Mar 2026 20:46:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 12 Mar 2026 20:46:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362781;
	 x=1773369981; bh=beibKrJw8gVlJSS1MC+gPsWPAAjnc1lfM9GVMreQ7l0=; b=
	WHV8jLjRFjvExaZUz/IeuFgzAji4iuC1qCdaaeCT+yhJO1A8Jy46xlJATz84RftX
	8ziuDP+FIoVk37AiwmkWNq59mHh58p+afnfWD/PswUpqQxv2VeqaDwUpCCy1ua2S
	UTsPcAo+khmfNmWIe4/dEMaxZPSeXxrGb/QhRIAyhV4Q0EucmpogkjrKFycwgKSu
	8XvmsnDj5S9ck3EDBgdc36XgPp5YT7phSDnE54m2kT6FBaPSFqUxsEP5LfQT8Ibd
	kwPFZIqhYefJcMp6GHUuks2lW91o2lXD9/uMMRk5odSMf2vU+pN6LAFgjwuofxko
	Pxd4qYjc0WMvZ9umgpIH+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362781; x=1773369981; bh=b
	eibKrJw8gVlJSS1MC+gPsWPAAjnc1lfM9GVMreQ7l0=; b=ZIH5/VZHZrMfU1cW/
	wG0qw06iFIqEqoHXhM5fZAFsUmmSTK8s5iHKFawt41sSzRFI2voGV/g2vxNPRvvZ
	QT4aLkhEZTZsQGWPLjlqLtmevQqurNCd2EhPslV4EIvWQatGKGq6tQ6DUKA7hkfJ
	wjgHPYeUDwzEedB/fhcD6NPn128Xk4owWwoTOWNwhF+JKbEEbpihYJy0ES1ozFab
	f79UKDfTMpYIQuiK2/rFGv9Osd/YLjjgERMzFcZkc7zkq+y6Jg08tF8TybJSGwX8
	LmtR+qvbnSUv3BTDBUn27O3PhnWN1IVPZyiwC0uUVCe52zEbcPFy0n0GgdtLfz4g
	ljLng==
X-ME-Sender: <xms:XF6zaQUpRmafuJ_VHKe6XJaV4qBgLd_E5gKvsgYdkMxz2ET5WHAB7g>
    <xme:XF6zaYSv9FEh8EaTsVC5XLx0QELITHk5QqmtSV0zq-GJgWdsdFYgKGzfObe4ouSSs
    fYtZg0eaRckvm22EVOlAoe8UXRY5M4VziXPrC0xNjUE_1gxwQ>
X-ME-Received: <xmr:XF6zafdg4fZr2hEtwPzJRJgGbidcS4KiT_rsPzUcPRYmpmOD949T70dcc4FAu3lLy--iMqyCzh2s6_u31OdO5a0JYEsiwjCXKfUmRgzEyLkK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:XF6zacwSQeyzcLbD0R0qj4fwLPpCY48skK0gFd_OeC5jNrulEZpEVA>
    <xmx:XF6zaQFm4O5uI-OqJvlKJeYunIiAleVawCA6AQPaqmJ7eImB7SKTSw>
    <xmx:XF6zaQ7cTsUM98sAG-Ckq4Eg8qscb97mTd9koXQg4HUb5ty_tBHmLg>
    <xmx:XF6zaXGeOET1UNLDlICu6EvGX_PPuMutBSqqlmsQef4rv2ewdNid1w>
    <xmx:XV6zaTitV2u39poMCZ6KTd-RZDEhLge4mC8KQjRjbR3O4bUu34t1yTdf>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:46:07 -0400 (EDT)
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
Subject: [PATCH 26/53] smb/client: don't unhashed and rehash to prevent new opens.
Date: Fri, 13 Mar 2026 08:12:13 +1100
Message-ID: <20260312214330.3885211-27-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A97B180007
X-Stat-Signature: ig9mtnnqjiqkc8ndx8cdc3b8rhg6w9a7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773362782-299910
X-HE-Meta: U2FsdGVkX18n1s2xuPsH5YPV1N97P4y7ArlYFUxY0C2M0PFOBTmobtotsuVQxBKH6LrGBahH5fMy3B2g9rIamobOftU2luxFI9Aut0ybzpn+1qgCIRTNU6RS0KQpXVgvVSeujLV6qqc9uQ/WCu/04J4bT9g+8PjHwh6ElEJhYLA5TgouGrguSTk1mG3ExhruoGPaGjFznawYEDn0q6jq7VW812uFu+HbplYpq9EK6ycdVG2OhPHsLMIu4m9YnpxkA7ZMjNbCwTGR/sTqqB/mZrqd9xNJ7I57+Zw7bsEW59TL4T8O8clCEboxVYNbqJN4YSr7fUpTKaYWWeSznrr/stKEWWqr95i+BfpNm0qxnNRmjoc/1fNpaSqZ7Bk7iQ6xyPgCT1BoxzcW9LucjlAcOsUzwI+ZR3LIbzePBFxl5GLqWeF0l1EfDLDnf2gzv1ew5ImvZ8r7WexRSc4753egHA1PNth2+U5wAPwbvcqLq7wo03NXVVsGWdS8IbN24mt9I9PPiHvmbP6TrDZp+2cgsZAKZUlJsxg/7PQ7hBDUBt+13Ka4uuhRmH/7zTGshMMcw8rOzkd+61nOZOmGlxgbXUCVuEh6VK0JSWx8KSKTKW+6Yrat2E1L1kOLJa7Bqi0T0zKlc7sDsarhDg1kZIjQhmo+K8hXB5H+Qm+zNfiRZ0jfeDqm4+5abtrQFMYIzc4czg9lD6o52tVnj9jRupLl260af1z39wyV8wGz0Kbm54VeF9SGO6pj/CgU9yexjpo2fd/G8+Hv/6xrixjOQ0WpLIOXBFbCp/d+vlEzvLIrGcAyfxBstidavUPhwaLYFHth357hFOJS2SieXEX/Ph8GiwpimQOOp1egvGZEiibDTgIafGSUhKhSP7Zy1UW8eA6waqGlswPrZ7Rt1rMZoNovYgZcwdvRrzTQK0UtU00nxOFIufIPnm6CcnNChNNnxJG4y9d0GyYcPXNF6ibG3yr
 VPh6KIbt
 p2p1IbViF5gkH99hCL0SMvT2g/6KeQT/nUrX1Vvy+ZqxBTCnD8rFnvrOfsHTnlatA+d5FBUG5kq3rE4IXPNnvoABPfcGjCPC4mttkS/E74d13lRjl8lVqyAP/WMOoHi4f1wtxm1ilCV7hiVOUR7C+23xDdCVSHyIskqULgIA+EYV4hceUP3x7BCyo/7bW9FdPrJ4+4Kzhf5bgUGgYG6vkxSXHIkm2k3xa9/z7HdS1NLi/KnWTOGEEsaeXxexutdckH3c2F8LZ1UOYN+eXEIiauk5RAYNA9VwElSik
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

smb/client needs to block new opens of the target of unlink and rename
while the operation is progressing.  This stablises d_count() and allows
a determination of whether a "silly-rename" is required.

It currently unhashes the dentry which will cause lookup to block on
the parent directory i_rwsem.  Proposed changes to locking will cause
this approach to stop working and the exclusivity will be provided for
the dentry only, and only while it is hashed.

So we introduce a new machanism similar to that used by nfs and afs.
->d_fsdata (currently unused by smb/client) is set to a non-NULL
value when lookups need to be blocked.  ->d_revalidate checks for this
and blocks.  This might still allow d_count() to increment, but once it
has been tested as 1, there can be no new opens completed.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/dir.c   |  3 +++
 fs/smb/client/inode.c | 48 +++++++++++++++++--------------------------
 2 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index cb10088197d2..cecbc0cce5c5 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -790,6 +790,9 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
+	/* Wait for pending rename/unlink */
+	wait_var_event(&direntry->d_fsdata, direntry->d_fsdata == NULL);
+
 	if (d_really_is_positive(direntry)) {
 		int rc;
 		struct inode *inode = d_inode(direntry);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index d4d3cfeb6c90..3549605fa9c2 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -28,6 +28,13 @@
 #include "cached_dir.h"
 #include "reparse.h"
 
+/* This is stored in ->d_fsdata to block d_revalidate on a
+ * file dentry that is being removed - unlink or rename target.
+ * This causes any open attempt to block.  There may be existing opens
+ * but they can be detected by checking d_count() under ->d_lock.
+ */
+#define CIFS_FSDATA_BLOCKED ((void *)1)
+
 /*
  * Set parameters for the netfs library
  */
@@ -1946,27 +1953,21 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	__u32 dosattr = 0, origattr = 0;
 	struct TCP_Server_Info *server;
 	struct iattr *attrs = NULL;
-	bool rehash = false;
 
 	cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
-	/* Unhash dentry in advance to prevent any concurrent opens */
-	spin_lock(&dentry->d_lock);
-	if (!d_unhashed(dentry)) {
-		__d_drop(dentry);
-		rehash = true;
-	}
-	spin_unlock(&dentry->d_lock);
-
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
+	/* Set d_fsdata to prevent any concurrent opens */
+	dentry->d_fsdata = CIFS_FSDATA_BLOCKED;
+
 	xid = get_xid();
 	page = alloc_dentry_path();
 
@@ -2083,8 +2084,9 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
 	kfree(attrs);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
-	if (rehash)
-		d_rehash(dentry);
+
+	/* Allow lookups */
+	store_release_wake_up(&dentry->d_fsdata, NULL);
 	return rc;
 }
 
@@ -2501,7 +2503,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	bool rehash = false;
 	unsigned int xid;
 	int rc, tmprc;
 	int retry_count = 0;
@@ -2517,23 +2518,15 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return smb_EIO(smb_eio_trace_forced_shutdown);
 
-	/*
-	 * Prevent any concurrent opens on the target by unhashing the dentry.
-	 * VFS already unhashes the target when renaming directories.
-	 */
-	if (d_is_positive(target_dentry) && !d_is_dir(target_dentry)) {
-		if (!d_unhashed(target_dentry)) {
-			d_drop(target_dentry);
-			rehash = true;
-		}
-	}
-
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
+	/* Set d_fsdata to prevent any concurrent opens */
+	target_dentry->d_fsdata = CIFS_FSDATA_BLOCKED;
+
 	page1 = alloc_dentry_path();
 	page2 = alloc_dentry_path();
 	xid = get_xid();
@@ -2570,8 +2563,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 		}
 	}
 
-	if (!rc)
-		rehash = false;
 	/*
 	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
 	 */
@@ -2662,8 +2653,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 			}
 			rc = cifs_do_rename(xid, source_dentry, from_name,
 					    target_dentry, to_name);
-			if (!rc)
-				rehash = false;
 		}
 	}
 
@@ -2671,8 +2660,9 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
 
 cifs_rename_exit:
-	if (rehash)
-		d_rehash(target_dentry);
+	/* Allow lookups */
+	store_release_wake_up(&target_dentry->d_fsdata, NULL);
+
 	kfree(info_buf_source);
 	free_dentry_path(page2);
 	free_dentry_path(page1);
-- 
2.50.0.107.gf914562f5916.dirty


