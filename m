Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EC6D277D1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91F96B009E; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB14F6B009F; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEBA6B00A1; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9066B00A1
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4158385E48
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.17.E05F095
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7324140008
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=SxSiiOot;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8Fdz/ANVjFzaC5C2LEX2ZRigSyjCLczPh/9G8T8FCI=;
	b=LID4oP6khuFdV0JDPXSQ3G0hlpHNa2Om9wHEkyj3ATayCVZL8ZMMzsiqlc0VzK4LBQsFwt
	L8eI8kcfLJXqfERcN9l6oVyJiaDxdGgWAjeO645X5JU+x8kI7dnt7biZAM/aAXnRPng2vh
	AlIRQbTZ8MdIYHcA/Qd08uV9Fy3CT9A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=SxSiiOot;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=vRtJsfNzmPxX8rt5Qz5rOcMa7OkDuM+2aR6MQzFBmfhIeLxQOeNGE6QeAEhTv/LSrs0wUP
	X7xgCpy/7j+ucj4TChYft2LKYGxPY6nBPnL3W99xAv160OOTjL+a0/EhcbLuKS401cNbKz
	xJLlalYpJHSfc7Fp196umZUcB+4/dSo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=W8Fdz/ANVjFzaC5C2LEX2ZRigSyjCLczPh/9G8T8FCI=; b=SxSiiOot8AA10l4sV3FTpcNVzq
	ZE0zHgefZleVJgi6kBLkLofKrHPFazzukPus92tmZxNb5439rkcKmReOtnbF+5Q3lbm97QlLUTupS
	ic7hmMaryQL9yU95IjWGQ2xIYSp+NkXLaZtUR0LjAtizMR+fJQ/p7+4Sn5dTBqhye+EKo3k0824WB
	3hWOEbzWMIaNo3kSKqmDqd71OIHpwQGrz4NH97LPBhdRgKC5UiM30ovJtgU+H/4ivS34HkRlBvtKE
	xfHp0U4XFPRWVzxYbbhOZm6aeA+lmMhcu4x4sNd+RGXv3GAhl9KO6H6WPagEoVPs3BDQxqOwq6MVd
	RcYsnavg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB8-000000085ZK-2mo4;
	Sat, 10 Jan 2026 04:02:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 03/15] make mnt_cache static-duration
Date: Sat, 10 Jan 2026 04:02:05 +0000
Message-ID: <20260110040217.1927971-4-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7324140008
X-Stat-Signature: 1s53u71kn5p3pa9ogwf955gyqqf341oi
X-HE-Tag: 1768017660-651232
X-HE-Meta: U2FsdGVkX19ftMYTThwnBtH3/F/nrJB7fj9YqLZPBVDmF9L+WA45OzVM9dZgTtny0qpxAjEW0W8yzr6R/8NJeowHcePZiBdH/MB0rb83lqVPcDuh4i0DDPwQwIBKqvslLSB5Ua4Kteeif6wv9Y2J8iaPiy+TqRjn/QRJJRY6Hq+930O0XFxBqCtzLj77nd+q15KAz3SKojkITHZrayWNy5rcWZ5/p1fiNJap/wVUB8hUhqR6InncfxzNUJsEbq75BlQ4qWO0WRz/rrzytDtoqFCHnVTXFGYdx8pCubQjyp4H5nTecGI8JoOTO4JnrHZzyBtGXYd+WVaqAN7kkC4LJgnEY344aJohW6Jb7tYL8l1pDKHMYOVxqc5UtchiyMtYep0t3pp+htjdnqosQxz4eJVAvH0cZgHB1Zr/Q/cYemZ+NfEhQIP4d2cJ/viAW2cBtGXqwhJq9cAIbubEp7OzxdVpD8dPHr6VAfC1subIT9A/pG7UUWLrt8VdX4r1xxPZtx7UY/SezT4yER3E83IsVK+Theec0DCo9rG+iEcvDa505iVhJwkjberc+bgNMUuXJQJpIGlTbatiImzUXwy9FiBDev42FsKzKXcWzTyO6THhpRiO+XJ7HgYw5gxmT/MwKsSoZ0COCJwsNEG2NjsmNwJc5ZTLIQl02ocWpqLKbYofrVZ+PE7Gfs4+qwWa25MJY7m2y/bxAtbKK83gweo96Ufe0nFWzKiZfO2sIa7L+UCPTo/dpFqa7Q0/RGyhyzdJL1LZxgW4O9hCIiyJ6dcI+RhgW9bmx0iCH0SlDyPxNoG87jB7EIw1Pzh1wF9nEv9EhE1Fhn557pMH0tzFBibeGwl/qAeT7zSQGyi6nuI/XeweS5qaigxtXr7e4j03kBPFVugUZpmmGV4L9FYEdlzIfBb30a8PxgbiY9wMra1hCNFxvwNwQxN2AjTxujrVhDkYA8Qcj7wK7JkhrJW9j/B
 x0gd+eUo
 JPt8AkGSR/ctFDQuPSNeCBQh0oJ0CiON3sQLI18aGdFGJmudJj87uOUOq6VXsOeplMhSB47LImkFKE4pIDjOz5JAseN3yxZyKMZZV/xkP4nOqESf7rMArKqZI7rQziEZH0FxqgCMyn1DSpX0MH2w3YjjtRcaSqwgQab+clK0TM5Uvs1kUBAtoRyuDK3cC9CMERXPwuaR4f26oByYjVcA0j1VHasVqAqCVFkfx4Mk0wyJ/PkB4ejM0K986ZQ5JehByoI2yAC9aWCXeTLLwEbTtBezUerMu97HZf/wbKwhDJtpk2xXQZE0UsTooQovrG/RljWh9NAsYZmLOM8qLuXrHSqxy31G7F6C6yzeSkfoeYgPA6VR8C63L3ztaAvVOCdYG/kT4SG9lSVw77lObeQdIKdwCGLVe3cN8xJ10gclDfZOygs0aONXE/50CkuIDqI55e4UtUzkS6F2cuN7QRI7YjUErfSn5VePFsDiceinCo128wdHT/wn+vUdBU/b4JkjTyG5PxjUikOO8E0aqq3dnkbOGzqNUBE8LCGlk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c58674a20cad..9a9882df463d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -34,6 +34,7 @@
 #include <linux/mnt_idmapping.h>
 #include <linux/pidfs.h>
 #include <linux/nstree.h>
+#include <linux/slab-static.h>
 
 #include "pnode.h"
 #include "internal.h"
@@ -85,7 +86,8 @@ static u64 mnt_id_ctr = MNT_UNIQUE_ID_OFFSET;
 
 static struct hlist_head *mount_hashtable __ro_after_init;
 static struct hlist_head *mountpoint_hashtable __ro_after_init;
-static struct kmem_cache *mnt_cache __ro_after_init;
+static struct kmem_cache_opaque __mnt_cache;
+#define mnt_cache to_kmem_cache(&__mnt_cache)
 static DECLARE_RWSEM(namespace_sem);
 static HLIST_HEAD(unmounted);	/* protected by namespace_sem */
 static LIST_HEAD(ex_mountpoints); /* protected by namespace_sem */
@@ -5997,7 +5999,7 @@ void __init mnt_init(void)
 {
 	int err;
 
-	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
+	kmem_cache_setup(mnt_cache, "mnt_cache", sizeof(struct mount),
 			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	mount_hashtable = alloc_large_system_hash("Mount-cache",
-- 
2.47.3


