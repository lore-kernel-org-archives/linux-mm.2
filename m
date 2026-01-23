Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F599D3EE9A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61D06B0403; Fri, 23 Jan 2026 01:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7026B0402; Fri, 23 Jan 2026 01:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860C06B03FE; Fri, 23 Jan 2026 01:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 721B26B03FE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42CEC1A0325
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:32 +0000 (UTC)
X-FDA: 84362312664.26.1456311
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A6B620005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kTHheWfs8SEmgcjXleoxxOUgg6tYL7rw7gDEvGl0jc=;
	b=CBbR5ifh3uCf/jMhF690BSrgnWVNFYs5tH8yo0PQXrVhaEDoO+++EdQ/N/bFkeURXH7KLl
	rkZbZ/poSqVFSakQSLdsp+3yqPrlWcfmX3Md+4vcwGNe+gVOUO7ennmkN3XNJF1p9JYNoJ
	NQlpRVaXIVC31AsaUD9H1OF6T5HhsgQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151210; a=rsa-sha256;
	cv=none;
	b=O/LjmloQaH9cYxqU3NPrACNHxTUNl/F/fh14OmbyVATuSaZoeXQvkDoY2uw1L32UHWbwxg
	0Oc3R5yUFqHuNxTZ0Yrs5m2OsmoJsTKfAfxc0vjYSvnbOO1oDQzEexHL0vXU1CvNLdt4ad
	zK4dloJ/rzG8YAkQEFiaZ+aVo7dr8QY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACE3E5BCCF;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96A26139EC;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KGCAJNUac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:43 +0100
Subject: [PATCH v4 05/22] mm/slab: make caches with sheaves mergeable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-5-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A6B620005
X-Rspamd-Server: rspam07
X-Stat-Signature: ecjbbtj8msqump4x3noedbpepzii7szy
X-HE-Tag: 1769151209-498853
X-HE-Meta: U2FsdGVkX1+MhCThqkQWXug4B4fxQKqlr4gZLmJ5yXI2ggUQvAd0Qj6sgLVSsDA9gAWe2aMe4MYoFtCBZo9Roe9gMvWyvO9CZca7AefmM8HLU68u0Ntz4Qgq368+1cZ8PSMCDTwyvaRoRRtiL8PJAxT3c6zxypSZOpV6j3o3PCWswWoljo4ceK2RoAVeP0+ZLN/cLrZym+mCj6dSr0WNqfHMdWs5V4EZwoSWar0kDrPE7WhOUGxvdmUTQBppJGnYCv/TO/JKqYtkE+EhbTzAkfrNWJ13IStqDXNofibe7XKB4+ZCHXC2uiW3kAzIYNqQ9kMScTEBSVe5b38lkYJJMzR0NJTIKn+CI7Q25EQmN4W9nIk+L9x52Fe24TrfzCgt/KuCzg+p3g4yf0WO+QezrT0sKasGr5nB2mx7fLoKxcKH6pvgQVsLNTIeZGjqOjyNPk9MDFzbAZYuIuWD5YeQfcYXus+JrhEyiZiFdFZdTmiYvvsUPfU776eVciWDpB+Zdce7wYbtfLv5kzRO1Jq5ciCRwGitXNBs0/qdbHzRg+8dqLZs26HxEaEzZcoQe3uNlcLnC+5LnUMoA//Gw4KuLtbmwanmlbXsTYl3IZQ8mjizsxLub661gx6qeOenpZXVWRrrQFmD5joFYcFt/hrhwV6scvLLeyKakYHC+9gr5To3MwENhpX1DkXeaEemu2/qQ8DIeEWDKfkCTywSE1NkTsSvqHxYtiQPQlenb6JtRAuDy9K/bmznJ/5/9ze7qKpazUOSD8wSzvzWY15nzJiFU+vn/92j4Xt5OrWq7kidavtFm3tBqiMTa2le/SblUrHxViGOMDyLyNjHhHMyrrS+4+RwO++jSL9NPn9cY1MocOgjUjDi2Q8RHo24R5QlZBUkboqcOWVPLvzGxuFlSBpI2PMoyuAwcuNcUj/G5YD5aiPBx/fkWvCQN1uqIRF7dZURaHGsdq15MdpYVgB+6jj
 zDxdejRK
 BDMQQrQ6mASCYMy6W8SFbFDdE4KfkrCW9pfcwp55MsPIQmhUnJ0/LwNAOer5cm9r5YbI7aK6y1xocNrMdW12FkQupbT0I9TOKRb6aJEacBTIGH2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before enabling sheaves for all caches (with automatically determined
capacity), their enablement should no longer prevent merging of caches.
Limit this merge prevention only to caches that were created with a
specific sheaf capacity, by adding the SLAB_NO_MERGE flag to them.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index ee245a880603..5c15a4ce5743 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -162,9 +162,6 @@ int slab_unmergeable(struct kmem_cache *s)
 		return 1;
 #endif
 
-	if (s->cpu_sheaves)
-		return 1;
-
 	/*
 	 * We may have set a slab to be unmergeable during bootstrap.
 	 */
@@ -189,9 +186,6 @@ static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
 	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
 		return NULL;
 
-	if (args->sheaf_capacity)
-		return NULL;
-
 	flags = kmem_cache_flags(flags, name);
 
 	if (flags & SLAB_NEVER_MERGE)
@@ -336,6 +330,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 	flags &= ~SLAB_DEBUG_FLAGS;
 #endif
 
+	/*
+	 * Caches with specific capacity are special enough. It's simpler to
+	 * make them unmergeable.
+	 */
+	if (args->sheaf_capacity)
+		flags |= SLAB_NO_MERGE;
+
 	mutex_lock(&slab_mutex);
 
 	err = kmem_cache_sanity_check(name, object_size);

-- 
2.52.0


