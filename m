Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EB37CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC82800E1; Mon, 27 Oct 2025 20:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DB61800EF; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5710A800D9; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 345FA800D9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC5EC13A083
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.16.C39B08E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id CDFB340008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=q74Ernaa;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CVyMMSGpWWe9qxlGuUIv4nZNRk8bTkfMsk1yIBX5YM=;
	b=mzBdzhCmWNaWXkngc3AAKT3dbjU4miCPTXbYsUTMWLzF7YTeAckXmSSGP6n2aQUGo45TH9
	bxguoHbUPXUCYQEx6g1hF0c+GcVI6EyJuaSiK30OjupHY6Vji+CEjnFGn158+uRrfBBNF6
	wvhQE5dSEu+WUwuybXwfe57+ouNYCqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=VTUiy54TD0c8mJWLyD4SxPKruU1gErWcx0cf42u+FzZY79bruR/3SV0va1wQwSRbjmSexk
	NZyvvy1xLMJchzvBK1H1etTixhHrRqLGR8ecNiqFKakUin3S0rC8nN0iDiaiQZAvR5prpp
	fJ8lhReIp2xycjmLooIXeJBTt6l8U7Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=q74Ernaa;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7CVyMMSGpWWe9qxlGuUIv4nZNRk8bTkfMsk1yIBX5YM=; b=q74Ernaa6Vz0JzQmiS0FDEAt8j
	kBck1RKqVwdal7HJjQCcaOsEZPY5G7j3uep4wdUix9V3Z5GahrT6a+KN8LvIZXQEgWWSPJ5vJi0KW
	9OUmKcXsAHigqIDku9/TVRMW+IS/OquuipUdkitBRNj3Tey+pbGzLlqHeN+XsVBONm182L8ophRJR
	h7iStQrTjUP7C7DKvvYrkrNqCpRbrhUCgOMMnpVIsCHZ6iXSeDNZ4UHmO4CnXCFQpsdLx3xFW5jEv
	K6oo6NNc88cxIJvbzkSKly6rCngbmBvrDa0F2ad02gJA+SFzIi296I0IhhF7a+KvUaZ0wn3GAW7Wg
	gd8e/cXg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eW2-0x14;
	Tue, 28 Oct 2025 00:46:15 +0000
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
Subject: [PATCH v2 06/50] primitives for maintaining persisitency
Date: Tue, 28 Oct 2025 00:45:25 +0000
Message-ID: <20251028004614.393374-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: sc6d71qxsdp9y4x5yrhq8mxxaakyypjh
X-Rspam-User: 
X-Rspamd-Queue-Id: CDFB340008
X-HE-Tag: 1761612383-303040
X-HE-Meta: U2FsdGVkX19Ehq8cdyoqC0Ge2F8ukGu5ySdVZYT0Pa/FgBn7SG2HBJ1PlWnDTMva/gp0GE/hILq9TVVmqqPls2Tee77Nm1duoUA8lvLZz/LQttDx9ytufsuMY5041R1DITMrh/4qwAjKkN3Eo5vVgqZtmzrukpCipm1zYAZf25C6We/d7E6dlKS9VKZkWRnJ7Kxmytr+DT14y8hROtQpYSyoCukgo0D7cUZL3Q53zg+OT1+EwxGosRnh6z0xZboZ3WH4o93h/yXjOnnVtu07BgnLJjOOK6/5IJ/zc03pJFjY6iY8N96LrWAKTtkSLtT8BIqEBe8GHg6G9I73bSaHfsucFjr4Jk8RJo18/vb70qXby7XZQaTAZ2ycBgpJxQlB1qIwg8aVV692uTMpkiAdk2a2rqllTNUWO84po4cPpUDArw1bsan8zEGj8lQrwULGJ+z1CYJATYw6nhFXMO8Pw/tdHF1pm2mRVQmyeuBCtx7/5fOsHuhiVWAQrIGpU2w2DS+rfNt9qBkCkD2e3YdknDuOq2KJym3jFQzMPS7hHLRBuvzav3yO1NVsJVJZFBKm13ZkaWAWdcJ1UDb3Ujd4mtqfPOMz5jfeX7ZML9WfHf9F7v4FFA9lrfHZTSIooi7rbHvxCRr9nxu/kJ7mv7GyC0UWh4LSdb7voalJMjxCx5RJHT0fmbDQ5WvvrO3zPjn8oT57Z/t+6z3Ppz0y0CijnAEgoaux/+ETwyXIvuvFBqlNTaTqM67A/rqt/evoFE1MyvC8t7JT9NSHFouJ8VvsSn8Gk/yBznqCG9C5afVp5M8xccIJ9rbeJ4ncc59XncdUcqjcKXsjB9q0t02vTbRx1qxyIl7eZFW2rM6qSI9tv4zlWyFD1mN3MYLO7eDUaTDJzZI+xW0Z2kFwKlqmfmySJ3zfrp4oloNfRwHEfRVTL//vYFAu6Gw/js8ETLNzCysr8ObUmRUwWBqMu6jM/kp
 SpEfPd0A
 Gh3uuZyA4v5wJXx1IagXixoajpOlPTheB5YEyWo7KEu08eFtuVofHcIeXEIxeqc6HYCUJOo9w18DsQXE/UcOY+gA0o1ZDQ5o9zKv3nK9AkWRiVbhKcf+gW3z4X3iQ4YXcRlWeCZNkwsU3PmPUqOjY/YgNVXtZ7lYHvFOkjWUqSlGMezAGETjDDMmD04r4Ikw2FcLVDTbn26t1W8Wjhl2FNCgaDX9qzYPhE6l8s69YP0SJJCT27k5FQAdtTlpSI0LV9CC9Fx9gOe14HILP+qqsRURp7pWMszB3APpUQYVAq77KYK9IjnZMVpmBoTT2E7YjjcKpip5Wls0K0HNBpyIjpByCl4y8iXSw2Y+40w21k3eK+clzUinT6TJj8OSoWOQe8Htq+ogGZ+2rnsvrhmtFZFyNgeaBSe95QQDjUjGLPSYnEfYmU54wZZFuU45MnQfSrOOlvcHMvfWJ5CI=
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
 fs/dcache.c            | 66 ++++++++++++++++++++++++++++++++----------
 include/linux/dcache.h |  2 ++
 2 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f2c9f4fef2a2..3e26039ceca1 100644
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
@@ -2754,6 +2772,24 @@ void d_add(struct dentry *entry, struct inode *inode)
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


