Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 130EBCD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 03:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78EBC6B0088; Mon, 11 May 2026 23:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717266B008A; Mon, 11 May 2026 23:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605876B008C; Mon, 11 May 2026 23:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A88A6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 23:50:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E70A7160356
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:50:44 +0000 (UTC)
X-FDA: 84757391208.27.717DF48
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	by imf20.hostedemail.com (Postfix) with ESMTP id 20D9F1C0003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:50:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OP8vGzRE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778557843; a=rsa-sha256;
	cv=none;
	b=qQfBJxO3TDxSf9R62a1epHdDblfznor98I11dIVSTYfArHFA00X0mUa7/QtrHZKzsTrxQB
	e06vPJeJSHh7Z8RmciqcJwudilUKppSm1qWbZpAscLS/93nuekzQRzs7JARzuyX3xkHgeN
	fp4yfT3Z/cFqm25cTnSW04RaStgjvSI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OP8vGzRE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778557843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5udFJeK8iDZYzDB3JHZhpoCGdix8HdaGJ6c14ctwbU=;
	b=f7BHVZ1VRvjbeZGcPDWoL/KZF0Vn70OQXi6J7C8Jcy2Yn2rRYByU6b3tuaS+5TFFofMjD/
	ejE3RR8p7Yf3f/Aq0qi43pTsRTP467Ngao9AltLq9wzkhKScrLbUa3ghxdmNCnWccE6AyL
	NX74A3yG9SQEiJ3tIyhhsvWtJSxiE6s=
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-364f7c42c62so4221337a91.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 20:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778557842; x=1779162642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5udFJeK8iDZYzDB3JHZhpoCGdix8HdaGJ6c14ctwbU=;
        b=OP8vGzREpboPLx2oNIzDo9CzVngbihb6ZuQ9j95ExczwHVw/mwao1va1cM/aiMfwTR
         XdDkYiLGVxcI0mY8djwutMSf9HRX2eMMC0QAtkO9X0ajSUcLR0WqWS+cdkg/2Ez4Wqt2
         AUB0KGzJeSQVnlFAzLT2QnIL6lJ8mzfyWJ6bQ3F7Kx74EzVuNZpctSzIzjWUVlqJVoDm
         M4OMFP9b38E9MUMDeeb+s2mGUDhmMQhAmVlAaXXKeTUGyxJgahDUpwtFa1a4reqvXWSV
         yAqEhFuQiURPNtPR9Hpp5+6SHcV6rQB7f3ur26ldhJy2R5fpPFbLobMV4CzoBS6S9xYA
         N93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778557842; x=1779162642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v5udFJeK8iDZYzDB3JHZhpoCGdix8HdaGJ6c14ctwbU=;
        b=dgzsSh3r//sx/W0d8Ahj/riBiv3Q9mxuXrmtU7jH+BwzrHf/r2ZDUMl0tkFEDAFPPK
         Seb5K9fmPKn/PQ8WbgDhgd2agcgpblyzWviQqShMYZK/QCG2icNJZ+/ZfeXr6blg6MYt
         gHxj6H/WSwQum5If/TsU0ofX9zpPz2zPPqCstiVSL3cH0bBDGUvcut2g2Yg9Cgu6D0+r
         RmFbgWHA+Ds0SvmlL6Iulvc32F/j5RFcj2D8/AC33Ev9aeXdeoUvcSuFdKb7waiWWgnJ
         z+CeJ6KGOgmPQHJ8gzSJsa2d0guTopciGEKuhk5yDo/8jDavlmXzfjTiXF9aKgcwZJPk
         OXUg==
X-Forwarded-Encrypted: i=1; AFNElJ8amwYrw7Xnebl0I+WZZ5StXwWdJylRijeEUuI4HvgUDMGeaJimpkvlwnoNJwdAz82Hin3eiRfigw==@kvack.org
X-Gm-Message-State: AOJu0Yylq8y0NxxHLh5kUE2vPCQ3v2nST7u3puKBQf6CpqZmA2SEOVoq
	luAMXaVcyOnFZNvvbwOu5OZFfcusDfVNYv/kOrNyIr+tnp6Ju/bj5fjz
X-Gm-Gg: Acq92OFUcoL8S3sXg1xAqcyHkwWH0TNYHXa699Y0mJE67w/zibrSjS97OJI6aHghYpF
	fP1hC5oyy/9ITr3JZqTqHHJi2kw/sY7By0DAMCl6zLaUr+keGaJNvgKKDzAJ3QrVw3CDXHPJM1p
	WNn7PkoataukM/fNojSsGTlLwurOsnDx1syDoYRKUAkSQBowkEJFVZjG9CS2aLwfiQIZdFil6Aj
	NghL8EVyFrDBgeK5xMaulIWDeStdafGBhWFNJNgw8s3KhLrNiBDfEwB8mVrxrtf2Vs1/R6rXmgr
	2UXgqfR0ACfacfcdYd27UqI3pMmRoVoyU2jTw3IRjEk5QmRbH39imG9cCim91/A6SNoCSsXFp7L
	IgRuCwBe8yoOzuSAWyNcD5Zc6zaOg2dTsG0MBMNFnBHAYLn2m2BzrPJSPDEZPsQBFEdNy11Y2GA
	1iHyKrh/BmOGgsW/Sd3vzLMYQ0Ul1F+Bg6fuWR42jWVlIDqDIi1DzhkrdZ6XeV
X-Received: by 2002:a17:90b:5783:b0:368:5367:d681 with SMTP id 98e67ed59e1d1-368536812a9mr7320694a91.10.1778557841889;
        Mon, 11 May 2026 20:50:41 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.218])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d625cee7sm9389081a91.2.2026.05.11.20.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 20:50:41 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: harry@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	hao.li@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	vbabka@kernel.org,
	wangqing7171@gmail.com
Subject: [PATCH v3] mm/slub: hold cpus_read_lock around flush_rcu_sheaves_on_cache()
Date: Tue, 12 May 2026 11:50:35 +0800
Message-Id: <20260512035035.762317-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <dpowyf5xneyg36lp25flxyjfy6dhijje7qy6z4sa7q5jpwp23d@uht5ja2rmfng>
References: <dpowyf5xneyg36lp25flxyjfy6dhijje7qy6z4sa7q5jpwp23d@uht5ja2rmfng>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5rzpq1r873jaqbw5z9qj4pqm3ghmb3fb
X-Rspam-User: 
X-Rspamd-Queue-Id: 20D9F1C0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778557842-117282
X-HE-Meta: U2FsdGVkX1/EOpY3hgpm8VuPjqCTcKNnhCZysfBRrClFIqUDYtXsVgMDmx542xbJiCLvLHJoGAlOdM0ooPXvNi0UfF+sa2a11QSn3KxkN1owlp2tURxjeEf+PhbpiIy4Ubs//fb2bFFUHMKZD/8UuHE0exqNVI9HveRitAQ5Jg7Ovc50UNgS7OU6Xa5QCE+e+PnURiUHPF3g9uLPoeh2rN9Ivdg8hAW8v/Ak0mvL/gyNgDKlCsnxHx22UIvE6y2KvF4FI0gDZe7UqWb7q1tSxznNQUBSafZyWGo/nkPNSr9UCGZCsI60HZSyxIN+DHF1BxsEjNqLgwjWHSsgan09e/O9iuLeHAPBY86Bc6loaQAtxJWNYSXQZXFik4EfkhaFvLUI7rWmEDqgBb5y3bnVqwelsLjK63hY/TEYNsPEBgSfKXTm+dEENVS2fw2/A8n6hzohVq8nkoVBI2OKaSnvYTk7zltboxqRxWle5CINwOzjNTgnAWBUHJcVExl8EwSUPd7dNOBy/uVhNGvOXt/JKs5iJl1uvvvPd53BtbanczcwECCILDvq0MIzSeFqu59/7IAvLSn1OQiaFtFstlSn4IKtXfqffuQ6LRaQ1jcO9ILT3bINLeITAf8+1m/WCq7t4iwM98ftXybPp45nW1nHjd7OYzvZJ0OblqnFr+CGXtiupDbfy4qmPFWXNelhdULqGBpXYQ9T5nkTI/y/4Qy50bzY4ScoU3Azeegb+ajLdJ29+AfQBsHx3O6uPTKCOP5sGWbbJtu+UHeErSGW2q68Xscx/nDDoyKs+Qnh6duDMjExPOsoAs1DxuHjtcxkw+l4FYqxsrmz+cl73/u55lugPjxSXtdHZcjbIW2yJOMHr06Wm9NSHFRJ0S1mdoufJEWnBka+QP7pcdmW7ZFfB8foVGBEYZVonp7U9d0qf8z3HmO0qUNPvOzo4FAOCm4D9uVX7z+GbUwabS82TVubh5n
 RWjFFWjU
 u4/PLPlXFWUtiy9TWLIy2NdJdWsInMgpJ49enbbTzd3Cc61XAEWwMthTZw9c4SX/dj/Sm5j8FwXetGAy9fUs0+XEGZ6FwAnbGl36Nu6bscK5lI6h9yVWkFMcGj2GyeSFU6vPcHpVOtn/YerIkCmqfaYnv9deFxFxdKlaIFm8lv/1oMHfcs/HlQkXF4fhTYkR94h9LDmq0ZvkmMVVEex3VxnEdDMen2IIKAGrn95R0qvdVLfpJpld0T4BehJ+PyqIEohh+BjojfZTNc7pRYyhDd+V8E0oIZHGq2OVW7RbzNGzfVkGMLQiE4TIU1QcJ17uNG/lbxoI60AnzqQ/MOyXmkrec0rEzJWuO6t7kVtras2xrZVGOy02upO+YU+UKuodyTECHaHuc0bCvHeLrKuuUkXGXBEd3SMDfLjVF+/way5VLOYwWzkhhBDBj6/PrkdRCv7zLvBsY2OMsKTpsuTU0Jq9FJ54XRy34ka0pQbMAEJkNYWg5QS5WWgk2IhrXcOXqqrlFNrBM8opTNMVkW0ts7xNGVPaTD6wReZ12tBNiFpqzqm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

flush_rcu_sheaves_on_cache() calls queue_work_on() in a
for_each_online_cpu() loop, which requires the cpu to stay online.
But cpus_read_lock() is not held in kvfree_rcu_barrier_on_cache() and the
set of "online cpus" is subject to change.

There are two paths that call flush_rcu_sheaves_on_cache():

  // has cpus_read_lock()
  flush_all_rcu_sheaves()
    -> flush_rcu_sheaves_on_cache()

  // no cpus_read_lock()
  kvfree_rcu_barrier_on_cache()
    -> flush_rcu_sheaves_on_cache()

Fix this by holding cpus_read_lock() in kvfree_rcu_barrier_on_cache().

Why not move cpus_read_lock() from flush_all_rcu_sheaves() into
flush_rcu_sheaves_on_cache()? The reason is it would introduce a new lock
order (slab_mutex -> cpu_hotplug_lock). The reverse order
(cpu_hotplug_lock -> slab_mutex) is established by

- cpuhp_setup_state_nocalls(..., slub_cpu_setup, ...)
- kmem_cache_destroy()

The two orders together would form an AB-BA deadlock.

Finally, add lockdep_assert_cpus_held() in flush_rcu_sheaves_on_cache()
to catch the same problem in the future.

Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
---
Changes in v2:
- Deleted the unnecessary comment.
- Added "Fixes" field in the commit message.
Changes in v3:
- Deleted the unnecessary comment.

 mm/slab_common.c | 2 ++
 mm/slub.c        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..8b661fff5eed 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2110,7 +2110,9 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
 	if (cache_has_sheaves(s)) {
+		cpus_read_lock();
 		flush_rcu_sheaves_on_cache(s);
+		cpus_read_unlock();
 		rcu_barrier();
 	}
 
diff --git a/mm/slub.c b/mm/slub.c
index 161079ac5ba1..2a005d1e3a74 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4024,6 +4024,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
 	struct slub_flush_work *sfw;
 	unsigned int cpu;
 
+	lockdep_assert_cpus_held();
 	mutex_lock(&flush_lock);
 
 	for_each_online_cpu(cpu) {
-- 
2.34.1


