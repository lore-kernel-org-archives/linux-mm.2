Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D78CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710A190022B; Fri, 15 Aug 2025 05:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699DD8E0002; Fri, 15 Aug 2025 05:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B01D90022B; Fri, 15 Aug 2025 05:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 471248E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:00:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08CF216089D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:43 +0000 (UTC)
X-FDA: 83778396366.03.A7C638D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 678D510000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LwixIVgggwhQLCQw4oWGwiHErSAAejOEdd8GmzOgHbA=;
	b=yXSsPRyws8aChb/Jac+OSyqPJ/EBMR6BECew5mS+bkGGiBrm0JTWqfSOKIATK8IEjsuUcV
	ioWxxxs/sC8Ubq09DnLE5HIViMKo8V/bn3fQQP5Dl1KCMTBV8T/asmclOjVwlMxUsc4lLQ
	KS7DMbUtYZYw9OBjz8sGZdRuqxGVOuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248441; a=rsa-sha256;
	cv=none;
	b=lXDu4t328wAmBsXGMYdcl5wuRwdn9tzD76LmYoxVC0YAFSYRaXx+5nbqFIgr7htJhOkeMx
	p57u/jK3Wte7W5hvGnZLQtLzc0OpzbT+low2pIz++BrUblOFQmJX24q+wxu6EX3i3bloXg
	ZPrygQCuC7xo71ffoupN79afxeA5epY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8898D2C46;
	Fri, 15 Aug 2025 02:00:32 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FCD33F63F;
	Fri, 15 Aug 2025 02:00:36 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v2 7/8] fs: Protect creds installed by override_creds()
Date: Fri, 15 Aug 2025 09:59:59 +0100
Message-ID: <20250815090000.2182450-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815090000.2182450-1-kevin.brodsky@arm.com>
References: <20250815090000.2182450-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 678D510000B
X-Stat-Signature: txhzadkuymkinpjm9npf1yux81wbrcwu
X-Rspam-User: 
X-HE-Tag: 1755248441-788192
X-HE-Meta: U2FsdGVkX1/RCZjIjZz8DkSl4jFtRKHfwjaPN6DSX4e8tQLP47FHxbVr6YftsiN3OBT4Oj7btj7lYAf1Hj0bg/jFn1yJVHgx+KfXVlLLJOkSt+OUM1EygEUKJImo8ZrHty6fwSNtBjdiR6hgYVKW1V7v7rd3NKcIb4+6En69yn7/OMiEEGBmOUI1lxe4nZSSWxk8uR3jrVKoUe0s6o//29OBCsvO9XZYWVQo+CInyPmt1lq94nqT/1TJYhY6mvg0ZBGmtlzuFnBuFLFXVg7lFpiELx8sz/HNz6r+MU1y95fCOQEjIDPOawE0mTcTbQ86T2e3IsH79ozqnufWigUr3PUUgxDxdyrvDWRbtF6kFnV1woYORUFJp+IDqQJSR+4IPb4y+qiRHBvItxn50P2u+27uXfTTrDbNBCSr5pUYAUhDB1VuLdY2N8mqlI0eOVbsS9x8GQuwtqHVAeBnoDn8/PjZYin6/nEzRpTvUTAzE+erseVqPjK7y8p/7gLjj4wW767MBDBjVeBNrysY8n7M3+ev2xAkPwAyrhi9RktHGoyLnMo6gJtJ8m4JNNwilipBVjW9zdZKrLOGgZj3WyN1rCRlBMd9qqHfKHL9PqL/rhBUtan4xz1UoX5oLzm2exXs/P2gbK4uiiKGT0Pl9YEi5DthtbxrYz01zaXQTipOMjeWFfxvI5UHAwoDrohPYGEeUtVJu0K1iLJtlN7ZXEm7/hYPHOG+gciNUQtxgLVN0NZK9TLHmYoQE43bTor/wTRiyCrdkIzZhJKT77coKEsTIFgB9ToOcUnK/QccRsKX+MCmkHS2tqo7nSJtAYvT88UvITrnmrQIx2a5mB+Acni7HkbdhnX1WU6PXZVn+B5JXtpfhB/0soHcZ/ehmq8LTvmz23fB6xxeO5MKvXPPpb1uLSZa0tEQapNDw8jfyQsjuIJ5xpRuJgyWex0UGv1+Mfz6MLTP8mjzKlKpXinczfH
 xJvrJbVO
 Z6/19nlQ5JD1U0TprXKwrEeDQO6U56kUoTLBP70dHFG/Uvn0FdoUxuq/vPUhb7Cj9Sviekuym/0XoqdmAtuif5xSVQiyMI6ye8wVL5ZFA5twPy+pd7K4wppodEOu63afqxo2bPcZXrBV5hYCFps8RjdNL8c4eZZvexmT7jxV/nlNIXRY6S1x1LVWuM8y+wsEG+nNXgRkD9BXLzTHDYaXLV3C8U38B0IuQNf6jk+UV/e3xDv8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_cred feature, when enabled, automatically
protects credentials installed by commit_creds(). However, because
override_creds() does not consume its argument, it is up to its
callers to protect the credentials before calling override_creds().
This is done by calling protect_creds(), moving the credentials to a
protected memory location.

In some cases, the credentials returned by prepare_creds() are
passed to override_creds() as-is. In such situation where write
access to the credentials is not needed, prepare_protected_creds()
is used to avoid the copy incurred by a separate call to
protect_creds().

This patch covers the main users of override_creds(), but it is not
comprehensive.

This patch is a no-op if kpkeys_hardened_cred isn't enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 fs/aio.c              | 2 +-
 fs/fuse/passthrough.c | 2 +-
 fs/nfs/nfs4idmap.c    | 2 +-
 fs/nfsd/auth.c        | 2 +-
 fs/nfsd/nfs4recover.c | 2 +-
 fs/nfsd/nfsfh.c       | 2 +-
 fs/open.c             | 2 +-
 fs/overlayfs/dir.c    | 1 +
 fs/overlayfs/super.c  | 2 +-
 9 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 7fc7b6221312..7529399bb71d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1658,7 +1658,7 @@ static int aio_fsync(struct fsync_iocb *req, const struct iocb *iocb,
 	if (unlikely(!req->file->f_op->fsync))
 		return -EINVAL;
 
-	req->creds = prepare_creds();
+	req->creds = prepare_protected_creds();
 	if (!req->creds)
 		return -ENOMEM;
 
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 607ef735ad4a..4451651b1e51 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -248,7 +248,7 @@ int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
 		goto out_fput;
 
 	fb->file = file;
-	fb->cred = prepare_creds();
+	fb->cred = prepare_protected_creds();
 	refcount_set(&fb->count, 1);
 
 	res = fuse_backing_id_alloc(fc, fb);
diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
index 00932500fce4..6eef34b02513 100644
--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -228,7 +228,7 @@ int nfs_idmap_init(void)
 	set_bit(KEY_FLAG_ROOT_CAN_CLEAR, &keyring->flags);
 	cred->thread_keyring = keyring;
 	cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
-	id_resolver_cache = cred;
+	id_resolver_cache = protect_creds(cred);
 	return 0;
 
 failed_reg_legacy:
diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 4dc327e02456..09b377a97147 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -79,7 +79,7 @@ int nfsd_setuser(struct svc_cred *cred, struct svc_export *exp)
 	else
 		new->cap_effective = cap_raise_nfsd_set(new->cap_effective,
 							new->cap_permitted);
-	put_cred(override_creds(new));
+	put_cred(override_creds(protect_creds(new)));
 	return 0;
 
 oom:
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 2231192ec33f..63ffa7936246 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -82,7 +82,7 @@ nfs4_save_creds(const struct cred **original_creds)
 
 	new->fsuid = GLOBAL_ROOT_UID;
 	new->fsgid = GLOBAL_ROOT_GID;
-	*original_creds = override_creds(new);
+	*original_creds = override_creds(protect_creds(new));
 	return 0;
 }
 
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 74cf1f4de174..887ee5adb2dc 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -223,7 +223,7 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct net *net,
 		new->cap_effective =
 			cap_raise_nfsd_set(new->cap_effective,
 					   new->cap_permitted);
-		put_cred(override_creds(new));
+		put_cred(override_creds(protect_creds(new)));
 	} else {
 		error = nfsd_setuser_and_check_port(rqstp, cred, exp);
 		if (error)
diff --git a/fs/open.c b/fs/open.c
index 9655158c3885..351ac9e86a15 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -461,7 +461,7 @@ static const struct cred *access_override_creds(void)
 	 * freeing.
 	 */
 	override_cred->non_rcu = 1;
-	return override_creds(override_cred);
+	return override_creds(protect_creds(override_cred));
 }
 
 static int do_faccessat(int dfd, const char __user *filename, int mode, int flags)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 70b8687dc45e..7e7d4f26198d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -575,6 +575,7 @@ static const struct cred *ovl_setup_cred_for_create(struct dentry *dentry,
 	 * We must be called with creator creds already, otherwise we risk
 	 * leaking creds.
 	 */
+	override_cred = protect_creds(override_cred);
 	old_cred = override_creds(override_cred);
 	WARN_ON_ONCE(old_cred != ovl_creds(dentry->d_sb));
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index df85a76597e9..0a45760ff7ae 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1326,7 +1326,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	err = -ENOMEM;
 	if (!ofs->creator_cred)
-		ofs->creator_cred = cred = prepare_creds();
+		ofs->creator_cred = cred = prepare_protected_creds();
 	else
 		cred = (struct cred *)ofs->creator_cred;
 	if (!cred)
-- 
2.47.0


