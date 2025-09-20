Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B6FCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFF28E0005; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385958E000F; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115048E0008; Sat, 20 Sep 2025 03:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3B8A8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADDF11A0919
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.24.DE1F8E2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06D5A100008
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=VpNmssgh;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TcpWsBjdjgXhy5lAdESLq2yqR8z6nILzb75NIW3ZjY=;
	b=eS3+2mI8RXZVwV3XMXw9QdkyfpkYMEzEX1FlUzevc9hM5moCIKFkLA9v8e/KytMZUVtGrQ
	wZ6LlwxWXnOh4kep3vSkMgfKOU1Z8yZb7P8wmCjYHdQILDaLSN6AeR3+8Pvf5OV5/+6EBP
	dx7cSWeag8MzVqrc2/Lt41IpF+SOCAA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=VpNmssgh;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=wq8wowEK+nYpXnPLiNAd5MQtxOOfv2nn5bH0PPD/3HQmSIPrZI1WIgHbmNzOClYcVR1fiy
	5q9mHsn19E6u1Pvh53mtkl2scGfhOgIFqcwjilq4AY4L7tEMnS6PLnvQw/iiPWNRi6xfr8
	6EJBNjN9x6Ia06KR4gUq0JzNbdrWBHA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3TcpWsBjdjgXhy5lAdESLq2yqR8z6nILzb75NIW3ZjY=; b=VpNmssghR59gIO4gLJM/zSLa0Q
	0BS9x/u4n6VaAJumIuxaOA+qtvnb8Y3zeyB5yqx7ENE+0eUh4orHSVQZFKLZrD4C3KZDz/5RR0hJ+
	Gm7nzApnxhSEWPoMDDM3Zp1nUun4oi2s5f58lQFInd1GqzJZFubYmk3yMnCZK5a5WOjKHZoo3L0Tr
	UFdRhUZyXqPL+RkioQF0SHPJlCxY/dB6FHgn3t01UyfUN/KALtC1rSEYVBcF7OX5MkDrD7JRcDzrR
	S6YrGR7nhOLBIEZbYbilR/Atn2AFZWIJQJxW/Y2fKTnHlZpiwk/Yy5vryKbSPXtV4wmaXut/F8qB0
	6hpyp9jQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK8-0000000ExBw-2DQc;
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
Subject: [PATCH 04/39] primitives for maintaining persisitency
Date: Sat, 20 Sep 2025 08:47:23 +0100
Message-ID: <20250920074759.3564072-4-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06D5A100008
X-Stat-Signature: i46hua1pqxpyjdnroqa4k37866duassk
X-HE-Tag: 1758354485-331479
X-HE-Meta: U2FsdGVkX1/rsTLApsZWGHJT0rGVkhKLxG9Ki3uXj/Bfv2nQIDCoeU6eKQEb1a0VdxLgZwY/JL6T/rbSNf1t10+qvhPHyE5B9hq0bCofA3RQMtLwCNCTiXcB3EXkrLl3Y69sr/J0mGJ1LB9DziEJMcbiIfvbFKmr4iRaKtSScqU3VKWcoAtbg2gaStxvjhu7n3OAh8NLgGxtjVB3peKklDb3Ztp32CkTIwtrv6H+aBXGa/OLCaoZQLOMV9bwy2pRQkgcV+71U8+Z6BmnzZ7FocuNdYjT0Ci55UUWz05qLurIDZumi3bZsInipTI5bVoKmUlv2tcu8NugBZlfJFhGY9+QDH0E+kuQn5VRkzvV8JHYGvqZ/GLemYqiMblKAXlN2GHITRgZlqnaJQMAPCRWq8ca5rY8Br149E9lMAc08RzzJDIuyPQoHEbkNus3P9h9zT2ddw2clMVsP2cMCR0SYg3vh/je/qwe7aq4pNhAT4J6EqtEX6P4kGgk5p7Qo1KLAXOWnl2T56KDnf0iZhVKPsfZW8BXdFNKHfqogxeFdGZWiizYcWgemvHb206ld8Nqh4XchJfYJloAHpMyyrXGt49mR+E3CshL35obhf8ONngPgNZBYzgvlvjjs6D+MH2m5Kc1rAzHFWOTns5TH/DMDWaq+pIo7CJFlmzT08TXYtAo0mNPDiA4khtv2pYBR4q/yr6wyXNEob6S3OSUBF6I5WKCPuZqC66GBPXl7e9LgcLtJeRXmxoVdveEjl/e5VI0gPdhGNG3Nefc7jwTSt66mg7yxM7huH/3euPBJRmxjSEG5MkukadQRAVi7/75VCDXj1cOJ7t0eEcW91LhWOdzkpPbXTQTvswZGPnk4vKhraOql8Jp9esItir/D/4PlPX9pZ2rmC33ZjKUYOsBNCYbyxEl63hYKMeIBSwwOonrgGbOMEcfCqL7zmC4fZbSBgIuuZMAkb+mHja/m2NuoaG
 7Dttv3iX
 5ETS5p4/KN6REuKAh8DxsAI9qrWKRAF0LOos6wHkYXpxwbeSQaOLXPswwC1gcTYUfvElkzzH0hgbTi9H9eaXEMozsKijLSOZ/kd36jpApiYnR+rpiRb3GWnC2Y8f9ex2emBnsp4yPGvNKApuO4GEXw7ucvN/hA59lwCNKisbSTaUV3Ce8YCdKfgjLzaXdjIMUPLe3dWd0pIVq+LosNH7j570APQa+wkRswrEFp4woPmKCs70vKYrIH9C6Meug2TPaSo6i72C+2YWgdB7Kjt+pFjm23aX4YyWKd4/xAwXHH9U1koOJgJGuEReM1bfIi2T81ezM9ktZxtXcXGzh74hI2G9iHlxaiepL8FLS5buQTqKpvIcHqF3tZKr9wYfWXyGSOMJ8qhupF0q907L0v6g4keA5eXbQrY4CKOMFiL1DKUStP6dKoNv5XGinlElFdzLrQIZ50+VfdkQDV8U=
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
strong locking environment (parent held exclusive); if we ever start using
it with parent held only shared, we'll need to copy the in-lookup logics
from __d_add().

d_make_discardable() is eqiuvalent to combination of removing flag and
dput(); since flag removal requires ->d_lock, there's no point trying
to avoid taking that for refcount decrement as fast_dput() does.
The slow path of dput() has been taken into a helper and reused in
d_make_discardable() instead.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c            | 66 ++++++++++++++++++++++++++++++++----------
 include/linux/dcache.h |  2 ++
 2 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index e34290e15fd2..9f802f6f9e3b 100644
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
@@ -906,22 +924,20 @@ void dput(struct dentry *dentry)
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
@@ -1939,7 +1955,6 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	unsigned add_flags = d_flags_for_inode(inode);
 	WARN_ON(d_in_lookup(dentry));
 
-	spin_lock(&dentry->d_lock);
 	/*
 	 * The negative counter only tracks dentries on the LRU. Don't dec if
 	 * d_lru is on another list.
@@ -1952,7 +1967,6 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	__d_set_inode_and_type(dentry, inode, add_flags);
 	raw_write_seqcount_end(&dentry->d_seq);
 	fsnotify_update_flags(dentry);
-	spin_unlock(&dentry->d_lock);
 }
 
 /**
@@ -1976,7 +1990,9 @@ void d_instantiate(struct dentry *entry, struct inode * inode)
 	if (inode) {
 		security_d_instantiate(entry, inode);
 		spin_lock(&inode->i_lock);
+		spin_lock(&entry->d_lock);
 		__d_instantiate(entry, inode);
+		spin_unlock(&entry->d_lock);
 		spin_unlock(&inode->i_lock);
 	}
 }
@@ -1995,7 +2011,9 @@ void d_instantiate_new(struct dentry *entry, struct inode *inode)
 	lockdep_annotate_inode_mutex_key(inode);
 	security_d_instantiate(entry, inode);
 	spin_lock(&inode->i_lock);
+	spin_lock(&entry->d_lock);
 	__d_instantiate(entry, inode);
+	spin_unlock(&entry->d_lock);
 	WARN_ON(!(inode->i_state & I_NEW));
 	inode->i_state &= ~I_NEW & ~I_CREATING;
 	/*
@@ -2752,6 +2770,24 @@ void d_add(struct dentry *entry, struct inode *inode)
 }
 EXPORT_SYMBOL(d_add);
 
+struct dentry *d_make_persistent(struct dentry *dentry, struct inode *inode)
+{
+	BUG_ON(!hlist_unhashed(&dentry->d_u.d_alias));
+	BUG_ON(!inode);
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
index 946f40168c73..77c205693ef8 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -608,5 +608,7 @@ static inline struct dentry *d_next_sibling(const struct dentry *dentry)
 }
 
 void set_default_d_op(struct super_block *, const struct dentry_operations *);
+struct dentry *d_make_persistent(struct dentry *, struct inode *);
+void d_make_discardable(struct dentry *dentry);
 
 #endif	/* __LINUX_DCACHE_H */
-- 
2.47.3


