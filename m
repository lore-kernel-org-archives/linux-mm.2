Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60277CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4208E0015; Tue, 11 Nov 2025 04:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBBC8E0002; Tue, 11 Nov 2025 04:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8A88E0015; Tue, 11 Nov 2025 04:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF478E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:01:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A6BF13AFC9
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:01:33 +0000 (UTC)
X-FDA: 84097732866.12.9E27939
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77E5FC0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:01:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LNsamXUY;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762851691;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VD4R3gUn11tbzuOSrLlHcr6CK6toCdQdVG0PoPu8WQM=;
	b=edb6qMicDmYlDcItnT0zXn/gXr0xNPfa3G2hlpis+CQwzpk9IUtzKp0s1lq4hT4KgQlZYL
	QqVdYozdGuJjLSdEKGY7nUaMiCO4OHcRPPGy6bYnTn+/ZYX5VZh720oJrj+x3g7B1jV1wB
	5b6aNnQZB84CoEMXZpwlJGcF7LaWMBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762851691; a=rsa-sha256;
	cv=none;
	b=Pv+Qw+E8/RHljEIT3MnimLJclf+jk4cpxgdVmlGqCrxwVVBKeK9n4HO02YQFwjIWUYC8W+
	Gw+MGxHksl89oGTtJMgh0fOHTwHOaJ7c1r2xnGPOqcRhe+U8ykYZO+KIjfe58nskqRaALP
	1fRiuNagCWd1BBmP0PxVVTRbSZfo4ms=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=LNsamXUY;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VD4R3gUn11tbzuOSrLlHcr6CK6toCdQdVG0PoPu8WQM=; b=LNsamXUYKazGznu3+E9phCtvFS
	xjf71FMGZm2JuJ+Cm32kOVxJtfzKEkBIb6d+BGR6fEOzTgfS5jd2YVeRQ+OE3ni4yswC4QAmDdjYR
	eibV6DV0w0cYIHk8DTwzzamCwCJ10F9b99eAk5T5XXcpsxwHZXtsxcCuPYQD0MNkAhlMPWuqH+iB5
	jfNCfcEMxoJ8XR9FBm1BU0CXGLNlnxeX1ZFDwILY9hz+pqCSBxzWR7Vie+mSQmpxsAQfgMJzQAUfW
	2KDzj4EKBxh8RCptnzntp/hsjYZ/yeL05Zj7aoBPhNRhCEUIsc5L1dSUPXa5glgwv4vV9LjL3/pNM
	ip9DcELg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHi-0000000Bwwg-0icy;
	Tue, 11 Nov 2025 06:55:22 +0000
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
	bpf@vger.kernel.org
Subject: [PATCH v3 05/50] introduce a flag for explicitly marking persistently pinned dentries
Date: Tue, 11 Nov 2025 06:54:34 +0000
Message-ID: <20251111065520.2847791-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zhzqkturd1icaiso8nkdusm3eo6tg5u4
X-Rspam-User: 
X-Rspamd-Queue-Id: 77E5FC0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1762851691-62516
X-HE-Meta: U2FsdGVkX19tH2rf0M1vfmOnoh+UOz00EOKB9GWDrtaPrIDXkAwHX+6+4DqEO9NxNdm6eoHIXVjS3kvqgxdFtjQNvPXYXRKOD8TXho8jtIS770O726MY2ts4hJhI1sGCvnMHb2n5zLk7/bbAZJTy4v+Z5Lxv1J/qjgSu3FX0SvDfY62NKXbpSvMBLlUGJVnP6hxILDA5jiRj2tOp5Pz0VP2fTM1kazIiTQJQ+mg5gGw7mM07ADFTagREJIcuJvcGt498bFqYzJAJ82xH9OQGLFFWOpMxWYTKrgnBsNQsFvR4tl31yBixT2bc8FbMBU4NXQUhxY6enb434Ir/PE0cwWLyk/svfBoncrP5M1fWLckRxdvlakj6ezQbSfXDDToTlnNW6eCHBoAZ6YRv4TosvjZbjipO/QVL4pwH4VUNhvdqWImycTLfL5M4B2UMs6g4FYCcox9xayiYVX+CZ75WhKgItGnoadCpe5RK0YDSCr6Y2V8tTknos1x1r0qB5iCi3tPEzMoqoCyYIZ7G7seWRI2sZCr1DtRrRCIAOgE7rzDlasY1dTX1z1FNYDjjfoWzizVZQZZCtj9iJJM9iXWeJTQS0spKg+vwKu/uP3cVwxqc//1NXR/Efnj4K7ckNdDnneya06rUFaA8oiOJAmuHzHv66xHDgIn/OjgZ4OAXYumHgjYhujuEfy9PRkTHOpj99c5OPot3xVzWVrXylM31ANuqRsJaIW5imZXPItQCcGUp6WbgeNjiM40d79xljo4GCGbXHyrqTz0oCP4l/aY3VuraLGsjfDVfVS8frRhfD2qooxXvbPn9uzm3rfGW0ZKbv7wj22m/JvAXU5prdzSx5SyKGOB2tb0C/GToSgqrrEXks3oweVTwdYB+BixYH82JqBrzIlz00wwgC+2saJMWUnuy7H/cZtKvvKbyv2XPpJxlJp/d5UAyPfq7za+Ea29Zhu+1aCP4vyPwrSJf/ko
 IJTFDRlw
 XhX0lgHrUxmqt3fPIc3FcAmF1VOA19fISLn69Mi1/2vnixQVLOOo/Q0Wuu23VGz+F9iDSbEK8pILib5PvFy6lgN2Thu6rCiZhyhLL2OPtNhYryhwhbBYBXk4r0M7wlnMCOQD4YYO5KEA4tfWgM8GJ+1QQD3NVrFnJtyFZXH1pv72ESHwml4+cZv2kXDR+Eu5bEpXYY898UPr34l/PKWiizdlauFEvBRVlqpgnBOEHv92jJc3w/MMHji0K6mLeX8xIc1rzI+1B46iOerAkUDiRPx04y7TOlGIWZQXAfXeEk1ZVy9fb869A+MQnU+CTTGK+zaE+NRiKdyiuflHX46EYgjOVOsyRNWoOqgnGgTo2VqkEQRPNh+V+Q2i/scG6tb/a0jXNFKatl/z9Keeysqmgum2HzbBRzdRniwS8
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


