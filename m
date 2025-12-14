Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EEC6CFD314
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 03:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875546B0007; Sat, 13 Dec 2025 22:30:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D0E6B0008; Sat, 13 Dec 2025 22:30:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763086B000A; Sat, 13 Dec 2025 22:30:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63DE96B0007
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 22:30:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04604C02B2
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 03:30:19 +0000 (UTC)
X-FDA: 84216648600.25.F40907F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5C3D340009
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 03:30:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=aMsawhgh;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765683018; a=rsa-sha256;
	cv=none;
	b=MLtWWDz4uSG1a4YLI1wzIeU3wlj1lh5KztUce3GgF85Y3o6eDWqdP/4LYUX3y0R7aQVlxb
	UAm6nA4gzLFTsAFxRmqFKz3N1G3hAQQtCZdojdaEg9OrLPXxl/ExPQGfm2zm7fHqHUlxRF
	WvsX8bUi9xpr+xra7K2I8qSk/yFaV24=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=aMsawhgh;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765683018;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGi9KZh4n2dTU/mRqjBgfYapN1MvgzZFugI9Jrcbsco=;
	b=yxDHze3Li0Kgc58Fj6maN9ntp+Rqdr/5HvPnOufJnvsFvRJA5O5x2rrft8dJhBxkt0Hg16
	Mi2kOxPfgxgM/iF/mQNmqJnyUTnqXI/YlBSyBwEm3PehsjqVizw3JqM7YBEfPBJ2isKUQ6
	LpVj9Eco8EmNsSrqX19bJ5Gr3kxrUlI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KGi9KZh4n2dTU/mRqjBgfYapN1MvgzZFugI9Jrcbsco=; b=aMsawhgh9BwqrryYqi+W+63jCO
	/Uuz/A7YCu8QXbC/ErbOjU6LOwABRhf3q5lgdCSt0GA2xwcjXHUjz6f6lzEnVkGBMK/R08zXRR4Yh
	fikqIljLdNfWREWEJAb7ekS2vjlWfgzgH1ACqZI+/oEkmi9sb8e+o7ft8vgMyRAtW/BiicIJa1xa9
	8LPsI6nhMxZqyT4frifavmMcSGJkP6k68sldjPM+BCKrRwP2OG6Xt132Fw3K5rfqu8Pd8s4y2XGpg
	DGqdbiTbqwgH4uuR8BCZHo3K2Tjhi0b3IhKmMlP0sV2IIYNvViOgWQ/PTvnB5FCLeTqV12GBPlV1I
	u9GRaM+w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vUcor-00000001yMh-3YW7;
	Sun, 14 Dec 2025 03:30:49 +0000
Date: Sun, 14 Dec 2025 03:30:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [RFC][PATCH 2/2] shmem: fix recovery on rename failures
Message-ID: <20251214033049.GB460900@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
 <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
 <20251213072241.GH1712166@ZenIV>
 <20251214032734.GL1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214032734.GL1712166@ZenIV>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C3D340009
X-Rspamd-Server: rspam10
X-Stat-Signature: xddczoqkkge7bc83kbsng3r5sy3p8zc6
X-HE-Tag: 1765683018-865233
X-HE-Meta: U2FsdGVkX1++qCTEmH7qGQlqdJq0CEfZoBvTkQjCs96zNhmJEHt9JaXWAgO999ZKx25kiG4bWh22GWDUNMoQj+I6TUa+r9Zv9D/Zp9NhHldVXouCPoGFES3NiVGdCjYOgwLkI+jOeo367QxQKXB/DAffLVldL09EtOxLO/CiDCipJHPHSGgmH6kCdHz56uRVryG6Tgc+J0i/AVWOE8/tWDCvV3Hy1iToybknw1ESG4YEPTkL7986SSRFKJ8Uh+Q6R78wpDt8wQGWEDNg4QoWX4zZS752ytF2v2FKeL2Cbo1ZOZ0Vm5W4CUhPqgySPA8kWUm0IwvHfPxAZjOxbRj1aL7l9f8EzoIYO81urE9qoMVkUX8bmtEOK8t8TIeFM97CCEuwbcDDJNOjYWss48/GnSJa1EeRPAHHFD95Y4rEEVpYiafHIiiOyiW+6EeZuq8I6ryfxn1XNkd9N00oly7I9e1TaIdg0yV7ME1wIG+Eq1vhji58RG9O/PQpTA34iauMnAsuadBi6ENKGLbe3TPRcp/joOKYdqRam6wqbqA+ivNLW7R4a91MWyMoqEUA+UQfp2GnKsZ316XCYQ440oqM5leMVH+BMhrqvMBrZ8hFvdUXAb21oreTjzSV9g+fpq1ur6Gdf7I2QQXtlxypKyYpZQr99pXlr+7D/WU/j3GLqnAzMJcPKLVHNicRNHNN1z/DIMwHtuKmdzHdKoD3WpLiYAsekyNGfjkkRYCOOFaJyAwoSnf8mAAF4jtRw/NHejZINv8uX0BV46+ZJhmRaM0ljhtUgT8I0B9IBFZgyM8wQLnColI4ZTMxg6AXRxLoxb/9SGnCAd8GfXXXU4bEQ3HBX9P18D+U34GV1+0tK7TverK10KCxxd2fkdN3yiL0HKhPVdtPGQjJjWlVwA4SatvzvNg7kKpZAMi131IRmDJV2dPJN6Li9uKgET4FhOpqNcyANKGH+9sjJCXtPjURCBS
 qDP/nlHj
 RGX20FkfjzTrVLLEvyklG0x59mk2MSMZTvv5xGi9C7CcMrmaWb9BKEdUAxA77jch84rbxesjEKorMdqZH3PnasadlzKp17R6HaahuM4G5EFgaeVgppWKdRgQa7hcAZ5sbR/tXD8KJkxoCqiEFraWtnx7n+UCFEzO2rMaPUxW/oUbYWFUXrfQfvIxR9ITI6T1tX7VVZPgjxTHgcdzr3/vIwN11LmpkzUSXQZwHOH0jzTS6nReITPgSpk+bk8iHk2NYhQmAjM0QpulUaVvHvaais8BlX10Tt2+FFttWAjFkjBdUDA9RvM7yEUUabi6H/WTW9GCfEI7gLeg3DJytvUN7bh1W/h4FnfLjnHX/2IPQi0PxA/fM/wgmMz1G3iiPkkUHCXzisk+UIZbUnHLZVwOwB6K7ailCeMoNyDMDWxEsYHwqE/fxHTmpUR13eIeAoqq0l37csaQ7Za3B5rY9nMOJIJ43CTljLmjc86+SenqoBMOtucA/n6/pWykjtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

maple_tree insertions can fail if we are seriously short on memory;
simple_offset_rename() does not recover well if it runs into that.
The same goes for simple_offset_rename_exchange().

Moreover, shmem_whiteout() expects that if it succeeds, the caller will
progress to d_move(), i.e. that shmem_rename2() won't fail past the
successful call of shmem_whiteout().

Not hard to fix, fortunately - mtree_store() can't fail if the index we
are trying to store into is already present in the tree as a singleton.

For simple_offset_rename_exchange() that's enough - we just need to be
careful about the order of operations.

For simple_offset_rename() solution is to preinsert the target into the
tree for new_dir; the rest can be done without any potentially failing
operations.

That preinsertion has to be done in shmem_rename2() rather than in
simple_offset_rename() itself - otherwise we'd need to deal with the
possibility of failure after successful shmem_whiteout().

Fixes: a2e459555c5f ("shmem: stable directory offsets")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/libfs.c         | 50 +++++++++++++++++++---------------------------
 include/linux/fs.h |  2 +-
 mm/shmem.c         | 18 ++++++++++++-----
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 9264523be85c..591eb649ebba 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -346,22 +346,22 @@ void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry)
  * User space expects the directory offset value of the replaced
  * (new) directory entry to be unchanged after a rename.
  *
- * Returns zero on success, a negative errno value on failure.
+ * Caller must have grabbed a slot for new_dentry in the maple_tree
+ * associated with new_dir, even if dentry is negative.
  */
-int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
-			 struct inode *new_dir, struct dentry *new_dentry)
+void simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+			  struct inode *new_dir, struct dentry *new_dentry)
 {
 	struct offset_ctx *old_ctx = old_dir->i_op->get_offset_ctx(old_dir);
 	struct offset_ctx *new_ctx = new_dir->i_op->get_offset_ctx(new_dir);
 	long new_offset = dentry2offset(new_dentry);
 
-	simple_offset_remove(old_ctx, old_dentry);
+	if (WARN_ON(!new_offset))
+		return;
 
-	if (new_offset) {
-		offset_set(new_dentry, 0);
-		return simple_offset_replace(new_ctx, old_dentry, new_offset);
-	}
-	return simple_offset_add(new_ctx, old_dentry);
+	simple_offset_remove(old_ctx, old_dentry);
+	offset_set(new_dentry, 0);
+	WARN_ON(simple_offset_replace(new_ctx, old_dentry, new_offset));
 }
 
 /**
@@ -388,31 +388,23 @@ int simple_offset_rename_exchange(struct inode *old_dir,
 	long new_index = dentry2offset(new_dentry);
 	int ret;
 
-	simple_offset_remove(old_ctx, old_dentry);
-	simple_offset_remove(new_ctx, new_dentry);
+	if (WARN_ON(!old_index || !new_index))
+		return -EINVAL;
 
-	ret = simple_offset_replace(new_ctx, old_dentry, new_index);
-	if (ret)
-		goto out_restore;
+	ret = mtree_store(&new_ctx->mt, new_index, old_dentry, GFP_KERNEL);
+	if (WARN_ON(ret))
+		return ret;
 
-	ret = simple_offset_replace(old_ctx, new_dentry, old_index);
-	if (ret) {
-		simple_offset_remove(new_ctx, old_dentry);
-		goto out_restore;
+	ret = mtree_store(&old_ctx->mt, old_index, new_dentry, GFP_KERNEL);
+	if (WARN_ON(ret)) {
+		mtree_store(&new_ctx->mt, new_index, new_dentry, GFP_KERNEL);
+		return ret;
 	}
 
-	ret = simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
-	if (ret) {
-		simple_offset_remove(new_ctx, old_dentry);
-		simple_offset_remove(old_ctx, new_dentry);
-		goto out_restore;
-	}
+	offset_set(old_dentry, new_index);
+	offset_set(new_dentry, old_index);
+	simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
 	return 0;
-
-out_restore:
-	(void)simple_offset_replace(old_ctx, old_dentry, old_index);
-	(void)simple_offset_replace(new_ctx, new_dentry, new_index);
-	return ret;
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 04ceeca12a0d..f5c9cf28c4dc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3247,7 +3247,7 @@ struct offset_ctx {
 void simple_offset_init(struct offset_ctx *octx);
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
-int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+void simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
 			 struct inode *new_dir, struct dentry *new_dentry);
 int simple_offset_rename_exchange(struct inode *old_dir,
 				  struct dentry *old_dentry,
diff --git a/mm/shmem.c b/mm/shmem.c
index d3edc809e2e7..4232f8a39a43 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4039,6 +4039,7 @@ static int shmem_rename2(struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(old_dentry);
 	int they_are_dirs = S_ISDIR(inode->i_mode);
 	int error;
+	int had_offset = false;
 
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
@@ -4050,16 +4051,23 @@ static int shmem_rename2(struct mnt_idmap *idmap,
 	if (!simple_empty(new_dentry))
 		return -ENOTEMPTY;
 
+	error = simple_offset_add(shmem_get_offset_ctx(new_dir), new_dentry);
+	if (error == -EBUSY)
+		had_offset = true;
+	else if (unlikely(error))
+		return error;
+
 	if (flags & RENAME_WHITEOUT) {
 		error = shmem_whiteout(idmap, old_dir, old_dentry);
-		if (error)
+		if (error) {
+			if (!had_offset)
+				simple_offset_remove(shmem_get_offset_ctx(new_dir),
+						     new_dentry);
 			return error;
+		}
 	}
 
-	error = simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
-	if (error)
-		return error;
-
+	simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
 	if (d_really_is_positive(new_dentry)) {
 		(void) shmem_unlink(new_dir, new_dentry);
 		if (they_are_dirs) {
-- 
2.47.3


