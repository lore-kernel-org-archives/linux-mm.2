Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50449CAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44008E0017; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9041C8E0013; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E806B8E000B; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 250E18E000A
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D420D42DC9
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.14.038B1B9
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 681E14000B
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=At+UaxpN;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCMtMhULL7XDxvS3BuBaCCDeHUz+bOSHTg4tb+kn7fM=;
	b=f8GdQeEa+7kN8L1WQjHTiugCNsMXhUD+s7sJxqj/cNQcF+/n73xGf9ki/aYfb7P2zPtFox
	SFiKEvIR7JZYO1VM7oDM0Dz+H0FDFRxBM4nRa+1l9Dpk5Q0sfn4Hzfqn8mYtYFC4FP3gdy
	ZIrj9AZ8rXG7qDLPMWdBe0TiXeuc6k0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=At+UaxpN;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=Ll1Cc/v8J8y/lrpkW6+sV/uszfqODu/cwtPwsspU7iT/kcXla0LjOUopx+WuokhUi6nBn9
	D3paRPKb+MoBhuKS4MwNs9Yp4JesPhBeYP9hRuRjoPC1N4WviXJZSAHQRXkFIKUzely9bL
	bn/5IeY2gPd6hi4FPIKQP/5FoHcaRNc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hCMtMhULL7XDxvS3BuBaCCDeHUz+bOSHTg4tb+kn7fM=; b=At+UaxpNTkftavSE6llQ5dPtmK
	stWIwaBRCHUBwgK2ou2lPFv7M1vk74cWDAJgj3vPyzmq6nqE7UQYSrX5EXhuFPJaLUtTnUyo9ADTl
	jEv1nIBQLq/Mzy9VvLr1b1ncpAnrl/5jw2i5LkQ2fHneinkA2Oei70cZGg0K4tXCem8As0drg6BBQ
	hrhNNQQP7Q7OXDJlof5AQvRdBv9v95GQygGi/K9Wbf3TjCQOIogJ0G6v5tJpsoxK1KgYitdK9zdWm
	+MjWq9el653871LxjjDa1uXAi5L8D7bUSIRzu9OA1hcA6RVXUPyTN2R6QyfugDc7IxYtVz3uT6mHO
	IO2EIr1A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK8-0000000ExBr-1Xyp;
	Sat, 20 Sep 2025 07:48:00 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 03/39] introduce a flag for explicitly marking persistently pinned dentries
Date: Sat, 20 Sep 2025 08:47:22 +0100
Message-ID: <20250920074759.3564072-3-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uebzcrwqtzjfwxikmxxmfq6s33s4x3y9
X-Rspam-User: 
X-Rspamd-Queue-Id: 681E14000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758354486-429738
X-HE-Meta: U2FsdGVkX18XV45fCzZfpGHghWXkqvGwWaF/ts4jZths4iILgIQcYGQq9kGEas7ZylHk3RES63B8ZxeI4aDimriWlORiUF0lvM1erlnv8T76XxV7Pc9nNl44NPLN8qieV3L2YrI6PBSGMF5UdQJnPhB5+2qFNrqzM0rgpSB7spj8BGVoRO1q2JaRlpYwoye8oJCTvMlJXHvZMqOzk6p4PygOJ1ngAdsC3BMHchwuZH1dgXzrJ3VS53ft55f3iTT6eATjsRVfOb2PsSgEukS8UzTnob/xKol8jV/It/1dzGNtPnaVFl7o3cOk61bJM15Xy/x9pqTqf7Hv9ysA0ipj0synr2TKFd0fGPWCRUt297Fr8u76OmUut5C3b3NebuouU6SQL0jbABwT6Lqsp7bqPT1xHdsvQwRezvaRMPMNJDEH7t+g2bl++3R8PNLP7m/Pulupu5INbG+qx+CjwDogl0tFI+r4Qp7e+cgCrZUrWuIPTARTjjyomWp0DoQni3V/gNsE/gbfNp0uQGKF5mTkydD15MyGHWzUewerLcnoeMc7ehkx3xvoJs9TFgJzgDvPtPxbxJYTLPSJpSxUfV23nvoZQ8LLcXN6iYsBbV4Kdj7LDVatwQmDchb+NiV0G4YBpvsi2LPk3APICuMqYKJYkfX9PlukTILp2m8CXHOpqOu7UzDXJUo7/dG+sGGEbmve9gH6wAgfh15DZTpALo/PUqtO9GATqvilOlsNkutVC7qPxztvEcjTbJbzMuCyN6l943blm3pNZSrslnT+L7mL4rgRtsBqPlFhKoJEVTQABfY6Pfu/EFLKM7uZOTbitQpLUh4U5VG6GGrmPkoM99GQKOUG2ibBgTeOF+6Ury8ZBl3ws41XP07DABFp3WK7ZOtV+9kPfBUcIK6dbON69TYzW0NVgc8ePDkjA23SQKjcV2ifgOQVRKCkKkKhPbtdTnByuCgXxE/hFX+dbgG6JDu
 gj9QZQww
 1sJBz1Z17BOXnKKE3AVXLZoGbmmBxiUeQAol+RHEv/W3hN7IQwl2UxXE+LEjKOXyJyJ/Zvpdjl/F+DfZyWgwea9N4UcGKJusbp8jlMAAq3T7/CZJxyKojKALX7lT7TawWxuHZ0ZnE+maFf8fAhiRGYwH2Ww==
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
index 60046ae23d51..e34290e15fd2 100644
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
@@ -3108,7 +3124,8 @@ static enum d_walk_ret d_genocide_kill(void *data, struct dentry *dentry)
 {
 	struct dentry *root = data;
 	if (dentry != root) {
-		if (d_unhashed(dentry) || !dentry->d_inode)
+		if (d_unhashed(dentry) || !dentry->d_inode ||
+		    dentry->d_flags & DCACHE_PERSISTENT)
 			return D_WALK_SKIP;
 
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index cc3e1c1a3454..946f40168c73 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -222,6 +222,7 @@ enum dentry_flags {
 	DCACHE_PAR_LOOKUP		= BIT(24),	/* being looked up (with parent locked shared) */
 	DCACHE_DENTRY_CURSOR		= BIT(25),
 	DCACHE_NORCU			= BIT(26),	/* No RCU delay for freeing */
+	DCACHE_PERSISTENT		= BIT(27)
 };
 
 #define DCACHE_MANAGED_DENTRY \
-- 
2.47.3


