Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 101A2CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21D9E6B008A; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06ED56B009D; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF01B6B009F; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5B76B008A
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C35CC1A02EB
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.27.394DD11
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 159C740006
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=oDl2Okc4;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9rJz0S4ZvlUN8tTo22g/3aNhc0livUU3ytI37nwAhU=;
	b=OqNX9LBQqUiHfWYiLhinOSFnQmf5EXhCQjae5/F1KuhVFsmL3dhGZbuJD3gJHjmY67fROM
	WfeZmGcPRobq0SqJ3HqJisRnnKg03MAS7ZO6TM7Xda8Nzxk3QntqS/Xf6lJmv7Ekt7gnmZ
	jFKGyzm9ZlON4NtIYh2RpM2zDDV2eHU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=oDl2Okc4;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=5P1NjCuoNlffcYNZMfM6aOfm1HCm2uBgPcVWL/XPDyGgmjx0p6ZA46vhVerhJxDlC8hd9/
	f9+ql3rKK2yOjl68pnJ9Glv4uKEIVWFdCNjY9dEhtzyYhKnl8P+GZ4ffAx9Satsg5CSO4n
	JpS4vgsuIREPIpzGgb45Ixzn7Xd5Aw0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C9rJz0S4ZvlUN8tTo22g/3aNhc0livUU3ytI37nwAhU=; b=oDl2Okc42x/lldoIdjfrsalnpk
	Yt7seMej/y4SVeL8gAXIzUuPUpqG6PzZWhIybTn0nMGRQ3Jjk6r3IcQlLLDlwGEdBqFA/RpHvLwAK
	VB2dAqlDPhN/4eLE0OX3GOOJ2tDzbKOdhN+jEfiORhqLfxKkA609cQAsRuVIjjgfdRh036/4xfXGo
	3Uc9sLSV7gc5oRtFMBxfEs/5wZu1BzWFLseKfUoTturCdCuHldP7pwmiFTVC0p6ws6UAS/piS2p8T
	AJ1VbgenroME5//r9+44eoTrsBS83Wr+WXGtp+2TRvOVwev5qBqBDTDu2HSrrPqrQvQkj7U/D+LOO
	7Rpo1/Lg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcy-00000003aTF-3TUr;
	Sat, 13 Jun 2026 05:09:52 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 06/10] make mnt_cache statically allocated
Date: Sat, 13 Jun 2026 06:09:47 +0100
Message-ID: <20260613050951.855141-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 159C740006
X-Stat-Signature: dte4bkwo8n6ozcy6ogrqeftjpz7d645z
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781327396-837619
X-HE-Meta: U2FsdGVkX18Jan8Me3w1yRYMSkc0XcMNmJJQzbeVHYaur+MqTyeaCNnB6aOW5OnuHZRpmUPQyjUEaURxX2KodFbWwUbhkFJszzvH+RBb4vh3AMHbnfXKEJEjEe7NsC5Eu5wIjqgylrHMoZsF0t6GellNTHOKe/yt0FRCiEmSKtLc+q0ESjJpnscfhNq6vPjfqmJcNdLjwaOYcKtiQ2QkzggyK+qxlhM2V5oaddZxInPhXUcLUho+SfOzM2k8wYKNa2NbQmGLAl2olN5iZY53smq7HMI8kPGZF/p3YtuHQ8IibUnzoLLUU3nhsAshmzyCSYyqoEmzToFeH/lplhBUMyFaqnSRhEWHpFw4n8ddXF8BFmstgIUMxQrsT5U7X/q/Vwb1ySW1N0TXjfh22cPM4DKVfKaVtXbxq2Qg2K6pbRMegKDx5ZhUpz83Gy4tf00amj0iuPGU9a2eTUvvzX0ajQE32WhFmYZbG42qPDYKfyyHW3yPcWbsS9GHJ/YQ82R/YHeCy0oPPTSycZirZzOebwJuYXMtJovUNQNBSkzhp8d/aulGx13NXo4Z8vwu2uwv5TPcg3HeYJrp6TKfbUmKDS082TvKZe4n9j5tsSYzByuiJaA1RKuoACvE6L3Oj6ch/MLbHGPrLXT6svxHichmeSS/2p1cdcVKWthFK6UhQNpIJW+E++8KRvzGgl1yR6XMlb3C55qDmUOvn/oIVGCLN3xxZnl8szMWCbwVaZridS3vIfQn+CDIFh+pTffCowbD0qk4MBza5seiigR3vZIZDxvRf0W09fis6qObaa8fIpN9Xi8HJxbS/YSGiX6cucjpXWOtlPNcvW8k0v/FJu7kG6xpJJXkYc55lC5gPktKGFuS8EZ+tJ2Of3WmirvdUCPXZLVDM1Gf5C1Apnkc9LedDF8VKiGL/yJgURn4OxbC1lffakwc8FZ7IqWIMTVvdfNEAI1ZrcBLlNM1YCo6M/r
 dmcyGFHh
 qktyLCrze3JONLbk8ubUBMdOHWrEtsGlNbAiLzNsrJ84jx5CanpISfjl4vE5EGq3AzueOiZ6qW+ct1Q7VbXRWI/h3qH2d4eOWhdkIuaq2UIKWm8JgLHbEhzmTTW3IGB3VNpgXJPeSKQnjTp/CjyjNqIxkX6TSqmbu9if/R/uS5d+nMwSKPvmmINCjK/nFAYQy252i5R57dgQRy73Ya++hZ8O2AEYwk/4GWvo6LsdsJeqIVVPfN++sFNUhRU3UwcBS34h4YXm2jSPHkemPcjIj3IbEs95H11SmByBG//y+Ketp/BIE4sOu+dEOEKWmXgQS0FOQ207n/HkSCaE13pLrDTzgvSCeNeVmrcs6czP58UluKjztiP21v5xMdevDQuyW8mycn/itIz3y0qD247oA3ySsTEMT46mLpg5Ifc34fQa6dF6EnFw6gV2aoRI9oPc8JaH0m9P/LD4ZGnIszaBIyz7W6/z1LUJG+eoaMCFbqXKSk8F/SLebOWNHcw==
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
index f5905f4ec560..330ac43efb8d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -34,6 +34,7 @@
 #include <linux/mnt_idmapping.h>
 #include <linux/pidfs.h>
 #include <linux/nstree.h>
+#include <linux/slab-static.h>
 
 #include "pnode.h"
 #include "internal.h"
@@ -79,7 +80,8 @@ static u64 mnt_id_ctr = MNT_UNIQUE_ID_OFFSET;
 
 static struct hlist_head *mount_hashtable __ro_after_init;
 static struct hlist_head *mountpoint_hashtable __ro_after_init;
-static struct kmem_cache *mnt_cache __ro_after_init;
+static struct kmem_cache_opaque __mnt_cache;
+#define mnt_cache to_kmem_cache(&__mnt_cache)
 static DECLARE_RWSEM(namespace_sem);
 static HLIST_HEAD(unmounted);	/* protected by namespace_sem */
 static LIST_HEAD(ex_mountpoints); /* protected by namespace_sem */
@@ -6234,7 +6236,7 @@ void __init mnt_init(void)
 {
 	int err;
 
-	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
+	kmem_cache_setup(mnt_cache, "mnt_cache", sizeof(struct mount),
 			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	mount_hashtable = alloc_large_system_hash("Mount-cache",
-- 
2.47.3


