Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13278CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3428E0002; Wed, 22 Oct 2025 21:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052918E0012; Wed, 22 Oct 2025 21:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82F28E0002; Wed, 22 Oct 2025 21:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2A5F8E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:22:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81A51C09FF
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:22:14 +0000 (UTC)
X-FDA: 84027628188.25.F52CB14
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf07.hostedemail.com (Postfix) with ESMTP id F114B4000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:22:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aIRX/LnA";
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lS0mhQ5R43bGQo27SjH0eAhLsgCq0WUEHmFOE5SKzxw=;
	b=LI1YbKJtFdm4VnOpmxrC1ca0Ybzjg6uGW2KhsMCe+Ur+twjXA65VUciYqCIUn3G7n77tcl
	NKInF05JDr/uPMlHDawOKOvFDMpvS4y12eareQaMCDdh7wASXpfOe9+6eBi7GYhNIowAYF
	aZSsQRUtUpLYsVpoWJMz94f3HMguaBA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aIRX/LnA";
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182533; a=rsa-sha256;
	cv=none;
	b=ek92L0xwHxyeAENlLp8Id0APaDTRKoLS6wBbQMoMdY6HLh35v+iuwfmQJ4XACQG3H36R51
	82lYdtmctZD0uG9LAJNClkVGYd57DUrRq/RAOF5avNn2BT8IYny1dmv/vFExY9AgYe1hzo
	mFrOUsIHLH4n5mcuxz9IbqGIrvBb4Eo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761182530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lS0mhQ5R43bGQo27SjH0eAhLsgCq0WUEHmFOE5SKzxw=;
	b=aIRX/LnASeyDPiwS8a8wyOgL5oKFWk9ymcuT75gnJ0IZOacm3dSpZH/R38T3ReMFFQ40uZ
	YTSnRX+CgIa/HmXPWYBgk26GFQnodLiOWZUrN0yWnumG744hcTGdK1gW1qKEFdtFIcbgPu
	4TDa5R6gAwW0HHQ2ZhxTRUnlAtZ7YEo=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>
Subject: [PATCH] slab: Fix obj_ext is mistakenly considered NULL due to race condition
Date: Thu, 23 Oct 2025 09:21:17 +0800
Message-Id: <20251023012117.890883-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bffdx6jmwur1r5tfbuoh9oniyj3p466t
X-Rspamd-Queue-Id: F114B4000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761182532-882429
X-HE-Meta: U2FsdGVkX18hsOULomaKqRCewedderMOtvgdOabwJBxULLOZ8jZHwZ68ySpHHl+Zik3/2z63HpFRqv7uHG2q2v0y/32JCERdvY8z8B3AvddV0slBDpWClFkU1WPbVmjG6cOEzgTHeFw/+CwgC3tjWUTbLet+q50/8fUzP9Em+C/8cUgmih2HXER/a5XBI626GCMVVgy6FavuzUmbHB0zbJTyYnqRwqcMkodvckwtnrQT/bmAB7Nt6A5KFg2CjNIyz2q9+hqoagOPh3RcJiKHevYh+FfjBNbU0oBDMr7Yq0Z+s0elJn+2USJwbF11ioGCqsEx7UHMQ3E0M5lx7DaKdA/F8I9htkU/BseRQWjscrSl89USVcOtYme5uAC3KZ1+OLSjwJazx1nVuyzBpYMDDoQ2KJ5nMBr7Zb5gJ7PqctxDQXzFT0VlZKtkdRe2fCT6DYEP1pKRXNJvxj57iTrN3PvGlgEvLuzcdBSfQ1rWGbv19ormsXofcqVe3bj7lrVNTAfGuej3MXiHiXKwalPg2ZQCuXj7z+ku3OD9isSxO128ZuvPz23Tw9CCLrsKEYtRIt7OAF1Kmc4HNdn2lmN/JQqdDJ+/JjRJPED7+puC9q7rOYie0RhFkfrJgt9T96UQQnF9IKdoNSyfhQVvGhPN6T1R3rVeM0Sls7RVdhCbwjuJtQNwFu9jYfcAptSG3iVSI55snj9WPTxAK0LZ2qcuxPQhEd6U54cy8FmGJWZ1/czLdN9Rg6VDbbgpD+AP2FB3WDvHvKHGiObceCJB0UyucQEJB6xpBjgVThV4p6ezYBeHpBTaVv6zRdJBIYrKqkw45hKYYLk4Mc7f9U4AdjrVFPq2DukDo0NpuwcU5PTZBMEChSC1k8RqvTsq2SkqT7hePOVMt+jSI8DjfAgar9lSf7WdKRRwwkQ/LfX6tunucork5f0mWhT627CK/ejavcFdIxKtuyM34/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

If two competing threads enter alloc_slab_obj_exts(), and the
thread that failed to allocate the object extension vector exits
after the one that succeeded, it will mistakenly assume slab->obj_ext
is still empty due to its own allocation failure. This will then trigger
warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG checks in
the subsequent free path.

Therefore, let's add an additional check when alloc_slab_obj_exts fails.

Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
 mm/slub.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d4403341c9df..42276f0cc920 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2227,9 +2227,12 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
 	slab = virt_to_slab(p);
 	if (!slab_obj_exts(slab) &&
 	    alloc_slab_obj_exts(slab, s, flags, false)) {
-		pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
-			     __func__, s->name);
-		return NULL;
+		/* Recheck if a racing thread has successfully allocated slab->obj_exts. */
+		if (!slab_obj_exts(slab)) {
+			pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
+				     __func__, s->name);
+			return NULL;
+		}
 	}
 
 	return slab_obj_exts(slab) + obj_to_index(s, slab, p);
-- 
2.25.1


