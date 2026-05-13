Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CCB9CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668CF6B008C; Wed, 13 May 2026 06:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A056B0092; Wed, 13 May 2026 06:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508996B0093; Wed, 13 May 2026 06:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C84E6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:58:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EC2C40890
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:07 +0000 (UTC)
X-FDA: 84762097014.30.F66869A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB8404000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:58:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K57lqIma;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778669885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvB5WMHATVUagB69UrPBf5isEpWprhAmOlg/Dx4WU5A=;
	b=4Kx+tnjb8e+bT3hCRvSdLMkNpzBvRxCYyD4rxy46AMbJH077kSq1tIKECgk7JiowEMH4K7
	tdaoyJhYFPQRK2M4c5L7YuFvU5oD3//lFjIhfbxVnERWNEJ/bUrwQNtRWVqCSGxeE79tCy
	8Qqx+BtrlNSX/kyVnpRrUyDVAR47toE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778669885; a=rsa-sha256;
	cv=none;
	b=SmYbgB61e93lSdFUdpn3sTP2uVwNT0x3sG8wHHOWZX95Lye81ysSloOjCbCBrLQ4Lvrxrp
	JP3K5q2x0IW8Xk7Nk6/3XZhjO7iQk62jkdhG/gWEfpsEbdiGx6DBhps2QqeqGtS//eqEjn
	1wyyRm9OTF+hdkRrTeXRZDmSioJVOtI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K57lqIma;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A85C01C14;
	Wed, 13 May 2026 03:57:59 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 989C23F7B4;
	Wed, 13 May 2026 03:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778669884; bh=XRXFMW82MTJcynAAttMY00dBFajezS7qCJhkkN3XZNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K57lqImajoAQF8JERG+bA2jfqFK2fCcPAdfcdLC95ysF8I8LFcnqCi1X9m2ihyO/c
	 GZ7Qu80Q6sdhjqcQPbS4G33bKzFAsKi6k8PWwxXmxtMzufCC8iIw8LnAGzR8zn7piE
	 PmpCzLyDmCnlx40u/j867YiA/tti1xTdnAHFepfg=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	harry@kernel.org,
	ryabinin.a.a@gmail.com
Cc: Dev Jain <dev.jain@arm.com>,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com
Subject: [PATCH 1/3] mm/slub: hw_tags: skip page-allocator unpoisoning on slab allocation
Date: Wed, 13 May 2026 16:27:32 +0530
Message-Id: <20260513105734.3380544-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260513105734.3380544-1-dev.jain@arm.com>
References: <20260513105734.3380544-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB8404000B
X-Rspamd-Server: rspam04
X-Stat-Signature: ios3dkkbpt9f6x9octir6swy8m46ep9m
X-HE-Tag: 1778669885-104948
X-HE-Meta: U2FsdGVkX1+Kr4+i5VY4BFQmOl7GgpG5y1YJx/Gyihb5lD9yBmCc9ovGdS2msu+zGqD1peYAQrytYj4GgFNfzhL5UirZHLsUEVz5d2Sz0nzVpqjPXWntwgz8sXkIS4hoJxUe6DkqIdEtExEIHFtB8wQ7pzFNm60xVWKGHFcWZ6u6QwTc84gYkGjM0rPWu/lJZO1RxHJNw7JRZRtCxL+bypDJ0KluhUsqvkNuthxNTCS0gODjxpkr2vjVXBoyN2g74cM8GudKCjiulCJ+Yg4VbChC66FVwDhV14t1zZdj33SbpHB/9Xe5dXMOeNiNm3yPVhXp6wPZBqOo/Q4d06DJNs8CjlE/CL6DZkWLip0jGPjbRwT9jg/oHeEh2SVfUwpCAEAvhZ71Wz1I41de8jPPQUYTnXqMNGKiCQDK9iq45ydxz8yEBUHjTzlA4PJyaSj6ykpeGMoVa2cPNRALa/LHPrwq5h2JSn15+WAjf7QKSuflrLSKIXNot+D0NQFcDOsC9vxwJ9RwyIfHcBy7UUhJzEyPjH/NZIS+J/7XohqIDF9lK5HUiEGEFgSq5ButswKO9XCleMqeGXKFPP6Zrg0xvHbGRTwRBE0yFiBIkIMlyakVtt32GfeIEaZgPYxU3q9HXyCzRtFUKygqT3inPASMaHQReiNcHHv66qtDqPOkQhEQopMJN93Qr5RtSm1L1GVwBxznd6lsNn9seBAh4bFTWa5rifnXjObyRK7chFYtmP8hqrU5EDHOo62g5C1dRtkuUtxX9BP7ljKsUgiWI7A+PBQKNI2+qoymPaXzhZ0tt6jVUZ/XLP0q5cQO44CRt1WHHUpS10jwY/F+ntTDO0q73CoEWEMLwBzcL/ctCXVhBSgcvBPamR5bwWNDFpU62ZV63R9rQdfRpmQ2Spa+yJYr8ur2MV4fIOhOo68KHL1m2EpDLEUOL1E1XkhSaSVyu+5FAQKQO0dkSH10dBR0pCq
 5PBmWl1o
 k69KkAB2hZTxVK+jELSQjdKN1m0Zs204TUzsqt5aY/9/vN8knF26rUAvygdkd43DJ1SPcks30jBoAh3qrwJ0UAeXIIck/qVpkIjzukPpKiCHmo1k8Pkq7vX18TW0dsrz6XW9n/SY8iI1CuMX3PY421A5xMJISVYn0ohSUDjZd821AtJKxO4TIVWi8qBE22a/TX8y8moYINU6kVYeW8WlvZphj3d+WftcGp/8z97iF2nTu53YF0AgcXHggOS0DPkVBBgK9i64MQUr92uv7KVTCPwogMbOBxh3XhFfmLEsqGaOUPoHv97huKJOsLEbzLYaXI+7iEqtGSkYUyCXWYr2God0PPRqxcyaRYYVltSIGhlMtZLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a new slab page is allocated, the buddy will unpoison the page.
Then slab immediately poisons the page via kasan_poison_slab(). This
is wasted work.

Similar to what is done in vmalloc currently, use GFP_SKIP_KASAN
(hw tags flag only) to skip unpoisoning of the slab page.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/page_alloc.c |  2 +-
 mm/slub.c       | 11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..c3a69913aaa9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7723,7 +7723,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	struct alloc_context ac = { };
 	struct page *page;
 
-	VM_WARN_ON_ONCE(gfp_flags & ~__GFP_ACCOUNT);
+	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_SKIP_KASAN));
 	/*
 	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
 	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
diff --git a/mm/slub.c b/mm/slub.c
index 0baa906f39ab..da3520769d1f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3269,9 +3269,16 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 	struct slab *slab;
 	unsigned int order = oo_order(oo);
 
+	/*
+	 * New slab pages are immediately poisoned by kasan_poison_slab()
+	 * before any object is handed out, so page allocator unpoisoning
+	 * is wasted work for HW_TAGS KASAN.
+	 */
+	flags |= __GFP_SKIP_KASAN;
+
 	if (unlikely(!allow_spin))
-		page = alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,
-								  node, order);
+		page = alloc_frozen_pages_nolock(__GFP_SKIP_KASAN,
+						 node, order);
 	else if (node == NUMA_NO_NODE)
 		page = alloc_frozen_pages(flags, order);
 	else
-- 
2.43.0


