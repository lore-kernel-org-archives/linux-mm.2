Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF25CED24D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FCDE6B0026; Tue, 18 Nov 2025 04:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD836B007B; Tue, 18 Nov 2025 04:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C506B00A0; Tue, 18 Nov 2025 04:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5829D6B0026
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:21:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF7AD14045F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:21:33 +0000 (UTC)
X-FDA: 84123184866.15.09C758F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id EF5B010000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:21:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uNtO1O3U;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763457692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rQmwI4wUCW4CFIUjCTrKY3EBmJE6MZ3qh3WAaCxCww=;
	b=pBpKtvRZCxXmP86egoK0Po2IBotm0ljoqIXqLDOfTfp6LdbTTvqCcnmuQKaqILCPHug9Xv
	xIgylpmG7tqD3FNpq28TsXxfToveV/gUDrqkx1dhTGaMHvakYR+8LOsU3bImMYClOehvPG
	3ef8/fYCY5vwP0m3yHrbQni0TCgKZfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763457692; a=rsa-sha256;
	cv=none;
	b=QwtPQ5v+sFOV8M37Qh5X/U+xIi9Oct1HZm0xlIJVnDNmU361Idg6Htxgis6B7VAtEWEkbo
	E1ejirmFvoPtf3D4yNbTotyVUwNl9wjF/aK2zRWqgIRqRT3iFCoAk5Kp2jjsE1dXGXZZ4d
	yn88Xkj0Opgy8OvZRauz9IXQV6L7kyA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uNtO1O3U;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0rQmwI4wUCW4CFIUjCTrKY3EBmJE6MZ3qh3WAaCxCww=; b=uNtO1O3UM5XYJjR3Umb/AXtuAE
	/UaVKUHdbF8Jill3VqnkLbxn+dF+p6/2J2YFKutdv2Vj3cvpIq/UnA4DO+2r+wMB0syfw/5nBy+8q
	ppfqRdgCIKNrgI+PIoRP+NvE7e06iT5cHoc07dEMGZEdbOmLw1m6BQsD8Aj33fgnviMSZiudPYfr4
	mjlljUw8qilUEgPq8n01ak+owUb5kGcLdWGIst9/tjfsn5UdEn1vJ7Kh+sI3mhKfybxBIBDoK0ytj
	O5KFqSQNLOkojNyRWyb/K5UkmBcgeObcaoX8o/JzeixcH52uP1EJXYKoLTdpsFqKOUok6+qndXJqw
	9bMS8P8Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4T-0000000GEQ9-2sGp;
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
Subject: [PATCH v4 06/54] primitives for maintaining persisitency
Date: Tue, 18 Nov 2025 05:15:15 +0000
Message-ID: <20251118051604.3868588-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: EF5B010000C
X-Stat-Signature: u7qa6n73p6ygmcdsxonu6hgwnix94owx
X-HE-Tag: 1763457691-74973
X-HE-Meta: U2FsdGVkX1+NyUGqn4VkLfzg3PQttAoT8ex08Nkn3UWUbZJCV0RT7/fCT4IklcotjYNWmTPJRIPcOZAAhLhMmMHKFMtR8biL7p9806lEaPaLSuhY95Eytu01MbLDMPxvChjvLPd3tj9uPDkg/pvGgmXNfA4OiVZ14ivWxLm+WzhLI6/20OVJxPOTRkNARM0Mlskf/KsMW6VApQh+aizqXAYoyMyf6xDKz4yh8u98ksfXfuGALDCUSJ9WguLywRHiGP6JJY5xG84rr0FVl9/nuUvlfLQZpLXpHdhT5eGtEIS2JYd6Crsa+24hEjNLWrhW7g5iNKWvDHZs266A3jPSFkEuq65G1QQnmvitzG/4UdQmdPBwjkwF7PZ7SFewTrSQaz5uiaO6YvtRUPZOGcSXzgiJyTnBsxRhA28NDPcdr/EfhuCMQSWY2yCg0MtEM2ijwDgDe3G4S64hD9riFbgwaZdz7K1SjOZl+0bpRe9XmqIJRMnqWoGcZcmnYGvvmruTQrzNuTDMAMHRG5xlJfXqLjwtvRnR/Mipam4EVbN7ZxapwxyOOqg9Q+0A/LP4X4pECUCoIUljI1wYACIwQzu3T3Pj5FP/w1GtTGOZGc8xujAsmsze53v5nx8bgzCkFzmjBoibvuWjnAWjEh/LVVbHHdyRioAAhc1k14QeO3xJgkuRcxfc0kmDUCRQAn74uSAKpOQuamM1DGvcD4Xe5ebPY8sm+LNtAEQz+ccjSPxzTrJJFPU5mGz2/u/4WZWeO8fxjbhiwcGfB6ijJ6bm9pZRcfMd38EKAoU2Hzp2gecIK7AMOCt1PvUrGtC3fWNOmo1rn2OfmiVL6DGVBlrQMj2ccJ5SPhU2TPWNcrM9QUHR0hfC49DceuE54AiJt5Se5Q8x6fhfQnDxPzud5GorOd2+oppSVuiuwZsP1ZndJxl0xSFC/hSA5GbSm4i7dFfcx5ca1Ub8ysNACvlO1wteZe1
 Q+6LByp9
 ppUZ+4oPGYp048Vn7UnZ4GrpC5MHxhxUCjthIqmo1hRkTBoh0V7yeFosd5nuf8GleOelq2tYQooclnCWuMKE7fVuJEQIBzq9pRLLOf3aqbFMmSLB1mQLG794dXHPAlqZphvlndAZ6CgkEfgkHgOB3Zfl1aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* d_make_persistent(dentry, inode) - bump refcount, mark persistent and
make hashed positive.  Return value is a borrowed reference to dentry;
it can be used until something removes persistency (at the very least,
until the parent gets unlocked, but some filesystems may have stronger
exclusion).

* d_make_discardable() - remove persistency mark and drop reference.

d_make_persistent() is similar to combination of d_instantiate(), dget()
and setting flag.  The only difference is that unlike d_instantiate()
it accepts hashed and unhashed negatives alike.  It is always called in
strong locking environment (parent held exclusive, or, in some cases,
dentry coming from d_alloc_name()); if we ever start using it with parent
held only shared and dentry coming from d_alloc_parallel(), we'll need
to copy the in-lookup logics from __d_add().

d_make_discardable() is eqiuvalent to combination of removing flag and
dput(); since flag removal requires ->d_lock, there's no point trying
to avoid taking that for refcount decrement as fast_dput() does.
The slow path of dput() has been taken into a helper and reused in
d_make_discardable() instead.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c            | 74 +++++++++++++++++++++++++++++++++---------
 include/linux/dcache.h |  2 ++
 2 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f2c9f4fef2a2..3cc6c3876177 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -869,6 +869,24 @@ static inline bool fast_dput(struct dentry *dentry)
 	return false;
 }
 
+static void finish_dput(struct dentry *dentry)
+	__releases(dentry->d_lock)
+	__releases(RCU)
+{
+	while (lock_for_kill(dentry)) {
+		rcu_read_unlock();
+		dentry = __dentry_kill(dentry);
+		if (!dentry)
+			return;
+		if (retain_dentry(dentry, true)) {
+			spin_unlock(&dentry->d_lock);
+			return;
+		}
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+	spin_unlock(&dentry->d_lock);
+}
 
 /* 
  * This is dput
@@ -906,22 +924,28 @@ void dput(struct dentry *dentry)
 		rcu_read_unlock();
 		return;
 	}
-	while (lock_for_kill(dentry)) {
-		rcu_read_unlock();
-		dentry = __dentry_kill(dentry);
-		if (!dentry)
-			return;
-		if (retain_dentry(dentry, true)) {
-			spin_unlock(&dentry->d_lock);
-			return;
-		}
-		rcu_read_lock();
-	}
-	rcu_read_unlock();
-	spin_unlock(&dentry->d_lock);
+	finish_dput(dentry);
 }
 EXPORT_SYMBOL(dput);
 
+void d_make_discardable(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	/*
+	 * By the end of the series we'll add
+	 * WARN_ON(!(dentry->d_flags & DCACHE_PERSISTENT);
+	 * here, but while object removal is done by a few common helpers,
+	 * object creation tends to be open-coded (if nothing else, new inode
+	 * needs to be set up), so adding a warning from the very beginning
+	 * would make for much messier patch series.
+	 */
+	dentry->d_flags &= ~DCACHE_PERSISTENT;
+	dentry->d_lockref.count--;
+	rcu_read_lock();
+	finish_dput(dentry);
+}
+EXPORT_SYMBOL(d_make_discardable);
+
 static void to_shrink_list(struct dentry *dentry, struct list_head *list)
 __must_hold(&dentry->d_lock)
 {
@@ -1939,7 +1963,6 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	unsigned add_flags = d_flags_for_inode(inode);
 	WARN_ON(d_in_lookup(dentry));
 
-	spin_lock(&dentry->d_lock);
 	/*
 	 * The negative counter only tracks dentries on the LRU. Don't dec if
 	 * d_lru is on another list.
@@ -1952,7 +1975,6 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	__d_set_inode_and_type(dentry, inode, add_flags);
 	raw_write_seqcount_end(&dentry->d_seq);
 	fsnotify_update_flags(dentry);
-	spin_unlock(&dentry->d_lock);
 }
 
 /**
@@ -1976,7 +1998,9 @@ void d_instantiate(struct dentry *entry, struct inode * inode)
 	if (inode) {
 		security_d_instantiate(entry, inode);
 		spin_lock(&inode->i_lock);
+		spin_lock(&entry->d_lock);
 		__d_instantiate(entry, inode);
+		spin_unlock(&entry->d_lock);
 		spin_unlock(&inode->i_lock);
 	}
 }
@@ -1995,7 +2019,9 @@ void d_instantiate_new(struct dentry *entry, struct inode *inode)
 	lockdep_annotate_inode_mutex_key(inode);
 	security_d_instantiate(entry, inode);
 	spin_lock(&inode->i_lock);
+	spin_lock(&entry->d_lock);
 	__d_instantiate(entry, inode);
+	spin_unlock(&entry->d_lock);
 	WARN_ON(!(inode->i_state & I_NEW));
 	inode->i_state &= ~I_NEW & ~I_CREATING;
 	/*
@@ -2754,6 +2780,24 @@ void d_add(struct dentry *entry, struct inode *inode)
 }
 EXPORT_SYMBOL(d_add);
 
+struct dentry *d_make_persistent(struct dentry *dentry, struct inode *inode)
+{
+	WARN_ON(!hlist_unhashed(&dentry->d_u.d_alias));
+	WARN_ON(!inode);
+	security_d_instantiate(dentry, inode);
+	spin_lock(&inode->i_lock);
+	spin_lock(&dentry->d_lock);
+	__d_instantiate(dentry, inode);
+	dentry->d_flags |= DCACHE_PERSISTENT;
+	dget_dlock(dentry);
+	if (d_unhashed(dentry))
+		__d_rehash(dentry);
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&inode->i_lock);
+	return dentry;
+}
+EXPORT_SYMBOL(d_make_persistent);
+
 static void swap_names(struct dentry *dentry, struct dentry *target)
 {
 	if (unlikely(dname_external(target))) {
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 94b58655322a..6ec4066825e3 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -611,5 +611,7 @@ static inline struct dentry *d_next_sibling(const struct dentry *dentry)
 }
 
 void set_default_d_op(struct super_block *, const struct dentry_operations *);
+struct dentry *d_make_persistent(struct dentry *, struct inode *);
+void d_make_discardable(struct dentry *dentry);
 
 #endif	/* __LINUX_DCACHE_H */
-- 
2.47.3


