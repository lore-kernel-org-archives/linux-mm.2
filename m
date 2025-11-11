Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE349CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005758E0002; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02CA8E0025; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8478E0002; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A60D88E0011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 739994BE42
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.18.3CC8FE5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 98A2E40002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=w3HzJj6d;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rQmwI4wUCW4CFIUjCTrKY3EBmJE6MZ3qh3WAaCxCww=;
	b=gSpgieg+xMJ2Iuun8XGbvWBeNHgjTRI8WvvxY6auwse+TbbQibLq6Xq4ti6jD2SXW+1mOT
	1kgwWUA6+kB1GDzLlf9DAbrzmtXPWP8T7/M5Wa3cW/mbaM2sWsU31rVhlQEBdBof/QUyCZ
	0pmATmZVdGcrodkVC6BX3kEryAaEyH0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=w3HzJj6d;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=5uTJOWoKNpNAlNN6NPSZ/L40P8GP8HuxlC2x6xBou1LVgy5WPWDhgem0jg7ugJ0OLfe+Qr
	jQ7X4loWOBGGf+tDpE3ZVKhSf+bfbhvJyeOYSbHGhZ1WSsbdAqr68Y31lQ2pTZfZwLFtv0
	J04GFTKGFraKhwMBkgh2qTCCFpzNqk0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0rQmwI4wUCW4CFIUjCTrKY3EBmJE6MZ3qh3WAaCxCww=; b=w3HzJj6dIjUGvVtuH9EW2+M/oX
	l2sQlAQ9o3B9CyZUYYA4OXaizv62M7NjTVobql1V02v22x7GXnZ8QNDFLN1uc/kCnoLwYhr9nAxZC
	wCkoEamKxQMJPivBMdxeCtsVnuJHyct5ys4qSehrBLtSNh/JI5Z5el/50nGhUV9xnRpjcrtgRtQTM
	jnxdeI8xRzQEVH9WzI6PB7UsboUJRoseob9UIqEJNKhXhJZfU1ddIPB6CYm9QPiWF17Htr5r4XITD
	53c068+7s255nbfMCbX+eSz2Ms0ldTle1KLXxVXEVLlcDMewriy1w9Qfr89wD1ERdYdXtMTPhCuMU
	0HRk00bw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHi-0000000Bwx0-19u5;
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
Subject: [PATCH v3 06/50] primitives for maintaining persisitency
Date: Tue, 11 Nov 2025 06:54:35 +0000
Message-ID: <20251111065520.2847791-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98A2E40002
X-Stat-Signature: daymihhu8idi64y988k5fukpfgnrpz56
X-Rspam-User: 
X-HE-Tag: 1762844130-687393
X-HE-Meta: U2FsdGVkX1/Z8DVx5FPSiG8cp8mFyspXQy/WZFO5OwgFBd/cvaZ6F9eOdLUFS6+gHfLp/NDIL5KeWYiK3LP75S2Mz9m5PoFwmPe612bIsB70EG7lFvHlFUe93FPEnS6Lv+AvOqFvNwZyYkpzO92xe03pifN6kmdCQF/tHnW5JPYb9ZvLqFLNfKl78h61Wm0O/HjbaVfVjeS41ow59XqZboZUjHLD7z18oM2g0++32GFpUyGZEht6X4hJ7ssWT052OyFQNcEbzMeiodUGhmBFguPWKhJXWwWRmKHKpcmsjcSjW/cReyDRY0ikHqeTaFwcDTqhkTbdHKO6uO1RGMOjsnJpPJHT92Tvmv4vtLOj29bST88y6MG/WtvYbr/gVCrPA6TzJTm+NC4TmavZCXYAUO0q92SGkq4HMuH5LeNVGlRS2ArjPRRsXyjLgYffUJGJ7al0V1sD70dIU3GqDhOFoGp+qm1CNtv9OPhKVoI1vpMKDOnQ/XfI2paHIURTAGcgzr9vPfchUJGZTbsDXMy96RuGz8Xx8K696zHYGvwF2EKubwqsVtNn/Ebskejy6WnT5+npc7aK4jgUfR/efAqsHRxy2ehxR0DzMhorLyFf9x0jQJFzP2wmym3kdt7nNq01GV8OWfD3a1GFpFXWz8T4pqRbigCxzdzpxG2t65vWT3ryifyF+JnTjyDDfC/Ql5M+NWGc9CtXt+eIU0esSowPgXqe/iC2NKX2D1aVdch/VFQMx07TbzFi/LM0FMUMw//vL9AOHZiGmjnV8gkmQqkd2nZt/ds5CTET0Nfrn4mzEv8CcvTkWBrPH6tT8x4NcN3fH+xZ/PC42rI43hWF+nWI8Zm1IPXHx3g4psFPPT5VGJdOrqRwINDFmCjTR9AWmg07EZxlXK2jfAJWF+5yzngWtmRep2psj5Vds/hlA7IGjuzarwRtDgaSAeIyuH0FFhQScKzgf6rYaZ7FtJpSnPC
 VBjhYTNL
 q9442KW0UloNNuoS6drlq+iMqOwK2vG8bx0vNQ/Ujxmp3iE2KmLX40viCiDJdNLEuFW2zC/EuXKBv7bWHLBEHnHXrjMi5FLV4UVnpFQ9/d7YHE/urVYsFWQ54/e4QW0MtoslVjVJR/C6aovsvDDhIIkw5re3LtzZb/PEpu7sjiE2i+XKacpZh1zO4DrNBcPy7QQxe2rQ84zjWbxTrTytZFptqKgJvpHa3uDjq4KrVrjwP8OSCHVfxsMt96X/Wieu6UI+WBed0m1Hg+qPwJtjHNc3trWqLnA+4HhIvEG1c5Ag8kwfI+9swGOjGxt1QvVk+eM6pKwkCCIOQPlTb/flf8Md+4SBxdUJOOaWmW/YVmD/pR6CFFdtF6LFZ8kspwOwYW+oh1aOWv7bgtmvFYjmEan8YqNI7BO72o99SBhoV+vkfY74g7PB/8v9M+ovgB2eeTeR4WaI9NrW6IvQ=
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


