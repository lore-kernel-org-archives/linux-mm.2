Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C12ACA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 04:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3549F6B008A; Thu,  1 Oct 2026 00:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B73D6B008C; Thu,  1 Oct 2026 00:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17FAE6B0092; Thu,  1 Oct 2026 00:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D531B6B008A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:42:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54463402F0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:42:22 +0000 (UTC)
X-FDA: 85272810924.23.8A18333
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7DAB5C0005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:42:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUymu9kc;
	spf=pass (imf10.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790829740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2Gp1DxjHQ0qTISrrSjvk99H2tt8CfuvB/h7scE7CDY=;
	b=vzdWVUyKMYdU7BAMlZf1bFHw1kt4YiPICLMhivYru6leEZobAxPo7qzJo4MZjo9aTr4ptw
	TyrgSdxSe4jj6bqoz6KFQ3oUWBVQ/bG2NOCFDlFCpPOL1+pOz5iPRngDPq10unPXHLlTod
	ggn2FNNSUK+4lWzbnVcNbrMfvVtxZBw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IUymu9kc;
	spf=pass (imf10.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790829740;
	b=AVZGwhtmEza7Z+Hyk0iFwkP9ozIb9QFcNsqbkUnIFobbwZUTfx9Y7mkhRmaMsbOEI8Dxng
	4MpIl5650H/QWoK5dbKq7oll2Dyy3iRs+Kin6tY8cyiVB60L3QZHiTbmFgbuQEk8H60BOg
	v4M/xbZGM8NfldkYouLpfEeeB4lEWTg=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ff9621c5dso36272335e9.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 21:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829739; x=1791434539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p2Gp1DxjHQ0qTISrrSjvk99H2tt8CfuvB/h7scE7CDY=;
        b=IUymu9kcd+l6iW6orKcUkPa6k75o0wbZ4og4z/X6Thq/sMmxumvJ2ojoBdCKHLxe6N
         X7ec/QmZtuVIZqhj8Jtn24JQJL3w1Uf442NUn3n8NeCMOnE/f0o68vHSqxdJdXRbqpyD
         EbTQ6PQiQAnA0CRyTq0zRz+UY9y1zjBE8V1P4QywmgV16xYNTfD1SAPoHsPLLerwKG9U
         iL3F9Ka+0SHXPoRyNL8pe0/Kutxt+8SwkbZueI0gSJGkMkF+O1l5vOv7KLLxraS2/rsZ
         RIrdR6QSs1zg4CJtwaAgPLwRJUYhzQom9akTIaMxVK+RtuJq+WEA78pcmcPnSvLJJZJQ
         CzJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829739; x=1791434539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p2Gp1DxjHQ0qTISrrSjvk99H2tt8CfuvB/h7scE7CDY=;
        b=h6bxt/Jg0A8FSXoMLxeewN0w0pvNniwYQrakbBsf2w4IQP/xiuVVVmANi/UwR8XDGA
         4YXI2byT7EHIu872zUQ65TxQoRK7zxWP1tg1StmeO4CFANXZpx1vjmrhmWRy9ntgbsEM
         HSqak+5XFAtrJOPDHLu43S8LJInxi4OgLMFBm0ODqicKZxh5/onHPEXQvU0y85STBXt3
         ShHdRk9PZ6vGH/fRWyoCTNb207NqRogJAw8pOOJFpEKFcJbmQBjDiAMZCemrnJgDKE8I
         mEazr2vpTq+kzIjCLsOtFRttdJgXykP1puuRC3LB3NRrajNSwoLx/AEA6NYdAmLoAF43
         kgug==
X-Forwarded-Encrypted: i=1; AKwUvBzl8iusWPBuclMx2f+vKZzHQQz7GGVP+8KIjB+yUcMG3HFPxg/jOGQyTqw9QQlNazy1PszTS/aSkw==@kvack.org
X-Gm-Message-State: AFuF++nyz+tpqw3NwR9exmoSQeGFlGHDetWyWmCvZJw/lp+NNyYnsXWR
	b5MJQYmct6kYPRS8nQirat6ikzkn0V+GiPs6zOSVm446WGD1gSNqgwAh
X-Gm-Gg: AYBFou22wUn1+s4usYfMSPAS8JarxBrPeCBsNft7WOY3pNxjdJDr5r+whw9P+TWczTZ
	sD3DyJxnMxkfkuLreDrfLj4P4ozAwdRagGCe/iDkMMyoAJ81QI49UB9nsSpf+YxSWO2nHUZhO9J
	0QMvM2PBGLbSknD2aAGGdBX2Mz41ik+1T0ALTr4Ow7Z/N/R6AoeWpTCPWh3u7H/TCnKDW3qTJ+U
	p3ynwfF53DkevlP05JfLLATf7zgdFvjYxj8JqwrQ/HQ/ML5EKv3tqrJj2NokUNsGKDQtgnAZkO2
	TAai9yZZbIx0AN7SCZ4jNnqe2f9QIDpOHh6rO5nwI/9cWJXhuOYFUKnmP95MASWXLIFPCT3IDki
	9S1o/Pqcq5x6sQ17RtwG0u8I0L6QpkgRcXp0052z+5fkDsKnTYUAyQTvK0+2tu01KFbnnK2cevU
	6iecJyw/WdnuBpcn7ITlkXJlT93UQ+qTQv+PXrYc1KdZgNeQuoTQm0HA1v9BzNRQN3AiN0vg1HL
	4Bz6t6KCoHF9tX4KAoaZnoxOVG6bvGS7r3OwsCXaV/s/wtYNfDwGoV5jcakpJqlTJ4T7t8dJ9m5
	ukhnNxnPBuHukuqqlVTXcMwtKWnPXuUawvmgtcEvXSPf5R/vqlSy
X-Received: by 2002:a05:600c:8b38:b0:49f:ce72:e930 with SMTP id 5b1f17b1804b1-4a01b13d7d9mr54875995e9.34.1790829738870;
        Wed, 30 Sep 2026 21:42:18 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-117-056-101.95.117.pool.telefonica.de. [95.117.56.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f6c5059sm32619515e9.0.2026.09.30.21.42.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 21:42:17 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 1/2] mm/slub: preserve no-lock freeing after memcg charge failure
Date: Thu,  1 Oct 2026 06:40:55 +0200
Message-Id: <20261001044056.75079-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261001044056.75079-1-kmehltretter@gmail.com>
References: <20261001044056.75079-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DAB5C0005
X-Stat-Signature: 7h879mxi6tpp585ufo9xmmt6d777t5qk
X-Rspam-User: 
X-HE-Tag: 1790829740-44918
X-HE-Meta: U2FsdGVkX1+idLDhDSecd+IJCrY/5CPuFvIdFWFVs2dm/ixnSBT7ByviPbAWvlkNuydEAsYzJFr/FqDPCch0QbLeK3vIxgphlXJhfjLOmHrdqEMV1H0+DCJmws7qpnDaFe+a4z3mj6Jv1zcMF+QfEJQJls376Zs0Eq1g7s2/4vWFjh6CbfWDU/mYwNqnhGb0HvCNbO6E9C8vfC3WRPcDizbpNF7jQ/dwC42/4YZ7wa5ohCRxIQVpUCXqke57VSgoxm8LS9Ituvg9IUmCmp+Q2NUe7kV6uRBG3ETt/++MCzwqMl/o0awFd9QBHWwRgNbp9V5sGJseMEMeIXOegYscOEbDxRV1Io5ICbyznCIDmrcGrhXRY+ir7nSlU/ERwk29wTPEDkv++BBtGiziZDmLiYpD2x3lgQkbFX9zajTGOjv6u+DSxUVZLNQQ7zugGiqV138o6GZ9GW/xj97x0vUJEbWOJOxE5b3qR/aVXlXNBSJNuQ8qHjt87kyWwDI78lp4Kyk6V3cz0/nDjuQFcnXHc4rHi7B3to/+1RyEOoYNIEVf9+3i7zBivJOnfVZWDD0YNqCzR4vR3tp6kQIsZJ40wJTlkefzraXw7F/6OBKmIEyuKmB9UNWLGyOyv8Q09+q8ffBRwcrD6kz0GgPCo0agfEfVfk5CoDowa5j3HMwWgxrPs3TaeBTzFH/bY4ovTgaY/FCTyDgAnHQURMDz5axx5J/5ZCfp85t+nI3H7qgoPQkWUHjtcIpyaERih/aB9bWp1gUwf7JzugCdMUOFYdWPgCl4w3S1FzaFBR53BP4o9rwORJTbpCfi6h2gfbKudZimAsfS6mpxaGpOa7zQezOEhXtBpE1Dnx8xmZCiWVfuxWodDTvJYvecpCmGr34VJej5qbkrew6XW+RjsbrtL3LPC9fORJedWHRcXsCkBRvRWaq5Wbj+NIQbS7nDWOYy3rtveztQxhkiWPoED5PU1pQ
 WQSWgrWF
 2gSzWHeA6Rq+bs9Xyq03g517Q5PZOh8dPNx86w9BOi7jJw20jYGBQG3qFZUnlrgtjE+brZAaeoDK4rV81n0/XZ+ygwmJ240Xiew1iyGNtvMEPCkOQrLbNtQsFzurRNTieTMyifj6Xg5fPF/wBgAPU2PnGHLdCbAr5w54XzP3O+x+l6aYzNp5BknvNLQv8i3D9rZP3WAslh8l5WFZuCEUNt1Bixt0c3Z+RkslhGfvtgxDCL1lN/ORTUgqfmfERO87UpROL8xCTiqBOt1sD1JegW6XHhSrmajJwKUf+OSuYJXC9InTEwgYlQ4voFJ8S+7PrRWaCKuLKcwZFmkl4AAMuG4+ahq6ylrQtzTXRr2LElnr3Eg5uNDkSaL0eHzUNb1Trk/SD3DavufpmaFpPn5JvGOREm4HckY163uQq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmalloc_nolock() can obtain an object before its memcg
post-allocation charge fails.  For a single object,
memcg_slab_post_alloc_hook() rolls the allocation back through
memcg_alloc_abort_single().  That enters the regular SLUB free path,
which can take a sleeping list_lock on PREEMPT_RT even though the caller
selected a no-lock allocation.

Use kfree_nolock() when the allocation flags disallow spinning.  This
keeps the SLUB object rollback on the no-lock free path.  The failed
allocation continues to return NULL.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/slub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 54ec125033571..a1f08338102e2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2519,7 +2519,10 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		if (alloc_flags_allow_spinning(ac->alloc_flags))
+			memcg_alloc_abort_single(s, *p);
+		else
+			kfree_nolock(*p);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
-- 
2.53.0

