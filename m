Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A96106FD63
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203736B00A5; Thu, 12 Mar 2026 20:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190076B00A7; Thu, 12 Mar 2026 20:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C776B00A8; Thu, 12 Mar 2026 20:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E943A6B00A5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:47:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3B051C6E3
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:47:16 +0000 (UTC)
X-FDA: 84539200872.11.9961088
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id AEF4A180006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:47:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=IpsMpfFe;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=G8JHmFu5;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf16.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362834;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qz44r/cI/H+P66r7rjgQTu2SyU7wjlJxbU1IwzedCr8=;
	b=6lnroeQ15icp6zEv2QFf1n2LTMiYcnFs7fV/z6i38uHM19mR/MQMX2/fuI1eu3jIL/1c4C
	fZxRc5P/CPaLlWEJW6puD8mKv3b1dTufkOpByFHsTsTAxTv9SXhyPj2CRcge0deSaTPuU2
	eCwYnhQv9EOL7W3UvfQXg30rTWPgNyM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=IpsMpfFe;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=G8JHmFu5;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf16.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362834; a=rsa-sha256;
	cv=none;
	b=c8PGFu3C92hkIpFD6RWgLv2Na51aqjDxhNjyJxidlv35yvZMapuyH21WsJehwmgbx6mbJu
	9972WSyV5Pdt40U0ZRb3a3ZY/Fope1fQp0rmhfmXX/6Op9bHTM/w/2nEjPZwD4ErVaHrWB
	ezZooBioh2lr1vpZ/Jk5um5HMHPJTBw=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id B9F1C1301B6E;
	Thu, 12 Mar 2026 20:47:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 12 Mar 2026 20:47:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362832;
	 x=1773370032; bh=Qz44r/cI/H+P66r7rjgQTu2SyU7wjlJxbU1IwzedCr8=; b=
	IpsMpfFevA+mEhkdruCUf1Vu9FEmLzrEWAtb4IDHjustVcc660x5nQzIEH+zM7+n
	F7xem84KPhj9hWFRzoN31Jzl2kLAcLz5C41k8KF8DDc2o4mfWEEH6308fDzSejrk
	AorOd82znIkjc2rhRbi8CcLttXgvES5I5n9aRJa1sym6k9LnaGvmiOPtg4JaoClH
	E0GZdfUMmErgqYA2F+MxWkHZOVdGxA5gC99x4eWzvtHdwM3bSZVia7h1wLflwgGX
	KQHLoziyxbJHp75VC9zMqgFzhJDRW4bSOVnZITlnR83AmG4HdVrOomHAmHpQJLkD
	HBP2qOLbjyiF5zP3BpxzQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362832; x=1773370032; bh=Q
	z44r/cI/H+P66r7rjgQTu2SyU7wjlJxbU1IwzedCr8=; b=G8JHmFu5KQLBpNeDN
	zld/gBCZXli4GS4wIem/PbJqdIIhih3tiaKE/N90l8FUrwJW8+gU2YeDvGTUBthJ
	rkgMGcdPlD1fIWMo1biHaQo9/WLjEYSr4vVAu27PxvDXdpU++7hfY7L//0Jwh1vH
	tzV6BPqgVS3EsG8sXh4xhvpy93GmQMFAKAaTw03Y5NAL6DAPPg5Wqs5sjjStPu0f
	cLxuKrZDYNCr9qnEHNk94ODc/hUxWL67t8Fh7zQzN0r9Wm/zV2Yq30KwIEHJu9yc
	t/JWWAUZfgxJ26ZwGO6uIfjpuQTO8vMuyP8XPTU8suyyC2YPRzT8hE/YRgFJTBwT
	ND/vQ==
X-ME-Sender: <xms:j16zaYNqiENq37Q88rVFgJaCOvTJoUm1h2SEBH6kM7EqWOTDRHmc2A>
    <xme:j16zaYoZ3REtyM9VfSMjEIDxBMUKaiHvdWMBpAfpNKCvDvCxoo2Qze54PpjQVZobJ
    WRkvp_JemW5lzrlTb4vGsMKrrdw7teaVORNkzNbZ_AH4lnd0A>
X-ME-Received: <xmr:j16zaWO7xjK010jo-nA47C_4dYeAJwZ_N6uvslo1KsUNxaUr2oh3YspcqtKGGcTzoVpio9l4SKeKi4FzhdaorN2yMS4jRgR7n5YPp67PZbLn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
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
X-ME-Proxy: <xmx:j16zaUzYdGgFWNlQYTElED9rnjSSFh5w-f45gvQomTKe5mqutsfuIw>
    <xmx:j16zaf3nVk-q_uhqBESJnPqXZCkqcke1PsMYuH1SmSZD0xMezqCrmA>
    <xmx:j16zaTRtsoaSs1r-htZVOscRdBLq7DVWFnEqHhe2Q1hzILsaqY_XHQ>
    <xmx:j16zaQcOUgemLNPo4bCCmDOXDChgryenKb1HF8fIilO_1ferY7gLGw>
    <xmx:kF6zaedyr8sLQAReYz8TwH3TKulUCUC0YXzRK_d6K-utN3FzIFWDtrCh>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:46:58 -0400 (EDT)
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
Subject: [PATCH 23/53] afs: lookup_atsys to drop and reclaim lock.
Date: Fri, 13 Mar 2026 08:12:10 +1100
Message-ID: <20260312214330.3885211-24-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEF4A180006
X-Stat-Signature: oc7xx881j4cmwask74a9874rmksiajtm
X-Rspam-User: 
X-HE-Tag: 1773362834-961420
X-HE-Meta: U2FsdGVkX1/OyGU14cX3gd9dWXNaXnrDWGCqVWI/lIsFh0hh97Lx3gerQD3RiwJhJ5iCC/MMrHdss0GMjYzeAKThFNJE5elPFTRm0phbLhnkDJydkeIID64e19ExDf1beYg1kOfJdDTgaRj2H87HKL+aWPx9Ppb/2JYs4a3W9eL6RyGz/6CeUOKOdrYt7rCmKwre/cwEhzay2kSjcef68KoAK9Cczpr9JkFrKrHVVVJkuT3uxBcWq/QYufWTFcLteEkkG67j6NDLHCLGvDvDwzBq13e6+KDYAB7DYjkNpM/A5vHUBgwxlUJyUpZWkusfVE4MHWB/yflC2bAwdz18JyF9zU/my+Lx9NZ7a9k/H6kxQ/OnBDRxG4gUORfliQ3WnmxG3mksUCGLc3B4jjjLSSMMpwqiOuUOheii/b3NcfGvnuHF7IqnvfE2kHgA54oF72vKvMzAKTnj8W5ln0Xia0u0FDeVLl42AoYqwDQLMJJnVz+qvweuNwuuO6T/NbMCHM7Xhnoh9OJMWOA1h4rO07NAWnRGwyoQ/U+5OlgKZVQRmQQMWtCjYvQWg2X6GAHBcgqoWc4P8lUW1XCxpPUmHrCzMAq8kn3d8J638qTNeV+fVhkms2L9Mi/fhG78z5tUrGb/L5XE5VW8Ovg3zv1naYR/qNgTFBT17yd5Dk3ke7tq0yc3xXDylKa0Zxob52Xxu2ub7mLns0lhE+4uTQGXCcDr+ugI6eaAEv0+7b9EcF5c42dbiUWzydG1xcF6J3hiM5O7dHY2EJ7fMsbMt+e4BTznK+jOuDIWdNwFK5WtlgKc+N3vhw5ygml5GBvi436NE1NQ4QN9fFzvMqoB7JZb7h+9T25hH4i3k0/JAZFvFteeadRtbcOWi6jBtRVaWkkG27OUukJ13SmC4OTeVQEYe2TlIWbP3RzW5SeTn2bDufoHfM9+ld4wxqygWft+AMYz23eP5Mh8jYo7fINFyiO
 022h7mKa
 xbrVwJAmU9c1TIEHABMAO6JJBSPLkCzVzZ/JjQT55Ht9MJEDa+OeoV8ML/QTPsV2p1bUww2Cmghl8kXy2l+jX31puSkcAuOa4Jvwzsr1TQYxwt/eq38oE9pobnvlvBAMY9iF8s63hYWpxiHe74inGqDaYvbOew4wQEST03oyDxoU6rxGLrjdjzLTBH2J/39dOR1lWeRNvWIuZKJ9XZJPPeBQRNQLnUo/pAzbwA+BwOUaVBGDCtm/V5w3jRxdczWNpuCEvyUAgfL+MRUAYrhdBh65iSEu74/lJv8HBJwSKjR+O5EyY4MpNbJ26PFnH83kqsJAn649CgXQPBquuROl9qmbDjdoXOtd8TTzyoVfXwDAXKXX3BAL9JsOKwJrlp5fDyh8zKXt6MqLbEgWAXiSa37iO6pbzKelxbX6kEV8tCYddujdBSA6+YTqvstidRP3P4IFp8QWv6mUSDQP9S4A7pXGVc+P48cALfMWbKnbMyflFzJ/zsfX++T/buSmEOdYFf8XFc/hBdEPeHTBw5ld+kNHSv51lP+ahWP/1HtYXunfygOR4mM/1EZZ/7UHtAzJD3hhRHHmmiqhyPRngZFpLFGPjhLow62GC1lKswHr8vZLtJyamcof1k4d7H1MGgioZAWdm6xsBYa+upB6vObGNEKMhw1+X2A5zikWA19/PfJ4wNE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

If afs is asked to lookup a name ending with @sys, it needs to look up
a different name for which is allocates a dentry with
d_alloc_parallel().
This is done while the parent lock is held which will be a problem in
a future patch where the ordering of the parent lock and
d_alloc_parallel() locking is reversed.

There is no actual need to hold the lock while d_alloc_parallel() is
called, so with this patch we drop the lock and reclaim it.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/afs/dir.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 1e472768e1f1..c195ee851191 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -908,12 +908,14 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry)
 /*
  * Look up an entry in a directory with @sys substitution.
  */
-static struct dentry *afs_lookup_atsys(struct inode *dir, struct dentry *dentry)
+static struct dentry *afs_lookup_atsys(struct inode *dir, struct dentry *dentry,
+				       unsigned int flags)
 {
 	struct afs_sysnames *subs;
 	struct afs_net *net = afs_i2net(dir);
 	struct dentry *ret;
 	char *buf, *p, *name;
+	struct qstr nm;
 	int len, i;
 
 	_enter("");
@@ -933,6 +935,13 @@ static struct dentry *afs_lookup_atsys(struct inode *dir, struct dentry *dentry)
 	refcount_inc(&subs->usage);
 	read_unlock(&net->sysnames_lock);
 
+	/* Calling d_alloc_parallel() while holding parent locked is undesirable.
+	 * We don't really need the lock any more.
+	 */
+	if (flags & LOOKUP_SHARED)
+		inode_unlock_shared(dir);
+	else
+		inode_unlock(dir);
 	for (i = 0; i < subs->nr; i++) {
 		name = subs->subs[i];
 		len = dentry->d_name.len - 4 + strlen(name);
@@ -942,7 +951,10 @@ static struct dentry *afs_lookup_atsys(struct inode *dir, struct dentry *dentry)
 		}
 
 		strcpy(p, name);
-		ret = lookup_noperm(&QSTR(buf), dentry->d_parent);
+		nm = QSTR(buf);
+		ret = try_lookup_noperm(&nm, dentry->d_parent);
+		if (!ret)
+			ret = d_alloc_parallel(dentry->d_parent, &nm);
 		if (IS_ERR(ret) || d_is_positive(ret))
 			goto out_s;
 		dput(ret);
@@ -953,6 +965,10 @@ static struct dentry *afs_lookup_atsys(struct inode *dir, struct dentry *dentry)
 	 */
 	ret = NULL;
 out_s:
+	if (flags & LOOKUP_SHARED)
+		inode_lock_shared(dir);
+	else
+		inode_lock_nested(dir, I_MUTEX_PARENT);
 	afs_put_sysnames(subs);
 	kfree(buf);
 out_p:
@@ -998,7 +1014,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 	    dentry->d_name.name[dentry->d_name.len - 3] == 's' &&
 	    dentry->d_name.name[dentry->d_name.len - 2] == 'y' &&
 	    dentry->d_name.name[dentry->d_name.len - 1] == 's')
-		return afs_lookup_atsys(dir, dentry);
+		return afs_lookup_atsys(dir, dentry, flags);
 
 	afs_stat_v(dvnode, n_lookup);
 	inode = afs_do_lookup(dir, dentry);
-- 
2.50.0.107.gf914562f5916.dirty


