Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB936CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AA748E0033; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3180A8E003B; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAE38E000A; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE868E0009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9F6613AB30
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.12.36AD239
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id F14812000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=G7+xIgWY;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VD4R3gUn11tbzuOSrLlHcr6CK6toCdQdVG0PoPu8WQM=;
	b=kXF85mdSPvSbH75brmHZKsdmcfu1owQr7QC+UuCM3l1WKddzSguL2j1UrlEX4w5xVWZXdk
	Q1EyFqecNrPk3RutUk9Mfsw61ou/7z/f7YQJobuiRyIwDY5Pqm86F/XoAer+/RR6oyX27j
	DrubV8gaT3Bb4PiZnpZCmIVX3nTcUJc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=G7+xIgWY;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=aJY9qkXazGqa5YVpEuhcWPKx5bUzumBe4jwxcWlURcF65bWteZjJjUeVnko0RQgGBVXYV/
	btCqewoEHGn9DevqGS5sKk39TvefGNQESn1tgvWQh3e16FBlJ9zsDjELE/iAT8S9WmUOko
	H6cJg7/ExiKqsYlAIYr+gv2rj4yMutE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VD4R3gUn11tbzuOSrLlHcr6CK6toCdQdVG0PoPu8WQM=; b=G7+xIgWY9mW59c0/eZZxJQc4Mx
	lTCk0HOYiXNDgnVhmCcy8+wWHf+UNH3w+rypga4y1NhonS1cUjnRHI9BU2yzFyqi2vZkSL0IfF0Xx
	2TJ/+oa1kZWmBGf6CNo8PwPlxzWkCNNBdJQHkeltKcMq1icgSBYByUTcNE+hxrPm3CPrC1ACgt+oR
	jK6CrK03Fzw51gm81zn1IcBer8Q2/6ned6SlrrSgddA+RgTB4g8VJyZDat3ix86u7vN7mGGzZfDrT
	5vHwcVjhgWFH3BoFNR11KpqoRpD+5KTGrqtLE8/9bgIvLe5Vqs1z6rktf4KgeYAA0i7RiManuouSx
	a00n9GLQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4T-0000000GEQ5-2b7c;
	Tue, 18 Nov 2025 05:16:05 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 05/54] introduce a flag for explicitly marking persistently pinned dentries
Date: Tue, 18 Nov 2025 05:15:14 +0000
Message-ID: <20251118051604.3868588-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F14812000C
X-Stat-Signature: ic8ykxre5gartjoe849tr7gpg8jxh5mx
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763442973-776591
X-HE-Meta: U2FsdGVkX19GrVZzIN3RWODSTELTKNLzJIFUKkS+0p9QP9rAc+RKYphntZ9PsGjqSH+H0RP7VdbxtfGnFtsBs6FlG7y6cFs6MdCG74K+nQCVdH3Bb7YX/ydocLiNavtk5IbWEeuMd6thRJGm5jGJjIeTTZYylMY3G4eNT8bXX9I7zjRcxUBesnXvP7HxKqaWPDEOWgq3YYupTB8A/iLAcfXOrT4Eokwyt8oFC32vZkkhGiIb4eLPkAGxacz8FECvXchr0cOKcvgRjnmrxUsUenlW0toLg0J08xVuhGaKeA/G43yD4Zs6p5guMvqK7Ke9tm5mNAi4jCwO/k63o6r+ByrPvkleflaiA+M4Qqhlsms9xzTsn0JZI1dCVDh5o7sD1PjDwDtYOt8RXZTH24PklG6as/KFAgzYhszSrFydLfoOCd46WeWwfTwFtEIAy2pG8qY04Sriyrm0acYh4cBBtDLdINLXj0H0bw0tOebviT17UCdNxEIGqOYpZbbClLfDush/DvOUF81b4XNenJ5Hp10Jk+DQT/h+k3bJwlWVv6iWSRwkd0hzSmEfo0sbVaz9db0ObQfKFHZCnf44ojzmvLbCq8edSeRFWZ15X2to2du48vTXLCHoFAFnX52qEkgoVjYg1fhMNmFU2ZCuDzOuvuehsp8Gp+X/P7TtSQerMWPfRAFR4uE2ohBzPkCtq5MKr4y5mA81HQ0bgnFacAJtYkkn9iCN7u6mLLUhNpSoOecxG78YIV8nHGSYuQqzjaufrjR9tjYM185Djt6RgMGVmtTdSHYZ+qJGJk8ZZrj6Bi1RpZ91bw1WDDIS8Esi0+VTkMYghSrfaCRGOw6XwSjqPt8xh8wgi1UVHT3ZM8Ylk07ToxKvIIfcnQMJPnLvgyxQSJg6FkSkaXOW9csZMmnWNxgqoVaCBMtS3nNSnx//4vZwPM+OJythMw+ry/WHaWlDqu5Zhxr36Wb4nZBArI+
 tjmvMU+g
 yDDrzuW69QGkPfU3shi0syC1oUtGoJfpP9ZnVVfuUUiSyKilhU44sgYODRxuDtLtnKYkYJ0/u6PxptRobw3oKubaM1d6aPUDuRvvSDpyVMF7CSKHsAqXBvnd++j16qZzDhUF195ClpGwn2GvA1oTIrqfQdqlS6TJixRpW7+FKmDf6nwgwTdwTVclYLxR7m/mVhY6Fkdil7QUuh6q9iEC24/6G42i7O8QJDW5YNyfkiXFZV6cVSy98cEcPWJ0elwqOTT/98Edzt+0aflgVfA93G3NZYIDl1F8W40XH9+TPVgYF+/k1OOWxulY8FoawHUFjBfSr0u+b/VCq9GN4IQ0IiIL2apVkTlkK3ZdxtPCpEdWJc9KkeTAUqfzehG6aNuqpOIhBOEEFAFT4O9gTrpVTW7xHQVEevbf3usck
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some filesystems use a kinda-sorta controlled dentry refcount leak to pin
dentries of created objects in dcache (and undo it when removing those).
Reference is grabbed and not released, but it's not actually _stored_
anywhere.  That works, but it's hard to follow and verify; among other
things, we have no way to tell _which_ of the increments is intended
to be an unpaired one.  Worse, on removal we need to decide whether
the reference had already been dropped, which can be non-trivial if
that removal is on umount and we need to figure out if this dentry is
pinned due to e.g. unlink() not done.  Usually that is handled by using
kill_litter_super() as ->kill_sb(), but there are open-coded special
cases of the same (consider e.g. /proc/self).

Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTENT)
marking those "leaked" dentries.  Having it set claims responsibility
for +1 in refcount.

The end result this series is aiming for:

* get these unbalanced dget() and dput() replaced with new primitives that
  would, in addition to adjusting refcount, set and clear persistency flag.
* instead of having kill_litter_super() mess with removing the remaining
  "leaked" references (e.g. for all tmpfs files that hadn't been removed
  prior to umount), have the regular shrink_dcache_for_umount() strip
  DCACHE_PERSISTENT of all dentries, dropping the corresponding
  reference if it had been set.  After that kill_litter_super() becomes
  an equivalent of kill_anon_super().

Doing that in a single step is not feasible - it would affect too many places
in too many filesystems.  It has to be split into a series.

Here we
	* introduce the new flag
	* teach shrink_dcache_for_umount() to handle it (i.e. remove
and drop refcount on anything that survives to umount with that flag
still set)
	* teach kill_litter_super() that anything with that flag does
*not* need to be unpinned.

Next commits will add primitives for maintaing that flag and convert the
common helpers to those.  After that - a long series of per-filesystem
patches converting to those primitives.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c            | 27 ++++++++++++++++++++++-----
 include/linux/dcache.h |  1 +
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 035cccbc9276..f2c9f4fef2a2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1511,6 +1511,15 @@ static enum d_walk_ret select_collect(void *_data, struct dentry *dentry)
 	return ret;
 }
 
+static enum d_walk_ret select_collect_umount(void *_data, struct dentry *dentry)
+{
+	if (dentry->d_flags & DCACHE_PERSISTENT) {
+		dentry->d_flags &= ~DCACHE_PERSISTENT;
+		dentry->d_lockref.count--;
+	}
+	return select_collect(_data, dentry);
+}
+
 static enum d_walk_ret select_collect2(void *_data, struct dentry *dentry)
 {
 	struct select_data *data = _data;
@@ -1539,18 +1548,20 @@ static enum d_walk_ret select_collect2(void *_data, struct dentry *dentry)
 }
 
 /**
- * shrink_dcache_parent - prune dcache
+ * shrink_dcache_tree - prune dcache
  * @parent: parent of entries to prune
+ * @for_umount: true if we want to unpin the persistent ones
  *
  * Prune the dcache to remove unused children of the parent dentry.
  */
-void shrink_dcache_parent(struct dentry *parent)
+static void shrink_dcache_tree(struct dentry *parent, bool for_umount)
 {
 	for (;;) {
 		struct select_data data = {.start = parent};
 
 		INIT_LIST_HEAD(&data.dispose);
-		d_walk(parent, &data, select_collect);
+		d_walk(parent, &data,
+			for_umount ? select_collect_umount : select_collect);
 
 		if (!list_empty(&data.dispose)) {
 			shrink_dentry_list(&data.dispose);
@@ -1575,6 +1586,11 @@ void shrink_dcache_parent(struct dentry *parent)
 			shrink_dentry_list(&data.dispose);
 	}
 }
+
+void shrink_dcache_parent(struct dentry *parent)
+{
+	shrink_dcache_tree(parent, false);
+}
 EXPORT_SYMBOL(shrink_dcache_parent);
 
 static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
@@ -1601,7 +1617,7 @@ static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
 
 static void do_one_tree(struct dentry *dentry)
 {
-	shrink_dcache_parent(dentry);
+	shrink_dcache_tree(dentry, true);
 	d_walk(dentry, dentry, umount_check);
 	d_drop(dentry);
 	dput(dentry);
@@ -3111,7 +3127,8 @@ static enum d_walk_ret d_genocide_kill(void *data, struct dentry *dentry)
 {
 	struct dentry *root = data;
 	if (dentry != root) {
-		if (d_unhashed(dentry) || !dentry->d_inode)
+		if (d_unhashed(dentry) || !dentry->d_inode ||
+		    dentry->d_flags & DCACHE_PERSISTENT)
 			return D_WALK_SKIP;
 
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index c83e02b94389..94b58655322a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -225,6 +225,7 @@ enum dentry_flags {
 	DCACHE_PAR_LOOKUP		= BIT(24),	/* being looked up (with parent locked shared) */
 	DCACHE_DENTRY_CURSOR		= BIT(25),
 	DCACHE_NORCU			= BIT(26),	/* No RCU delay for freeing */
+	DCACHE_PERSISTENT		= BIT(27)
 };
 
 #define DCACHE_MANAGED_DENTRY \
-- 
2.47.3


