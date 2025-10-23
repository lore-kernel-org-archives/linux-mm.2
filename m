Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AF8CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 14:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4897D8E0003; Thu, 23 Oct 2025 10:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B658E0002; Thu, 23 Oct 2025 10:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3289C8E0003; Thu, 23 Oct 2025 10:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE198E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:34:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2C3113C128
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:34:12 +0000 (UTC)
X-FDA: 84029623944.05.F6374B1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf24.hostedemail.com (Postfix) with ESMTP id 05C6A180015
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:34:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=omPdSohL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761230051; a=rsa-sha256;
	cv=none;
	b=a/BkMBgYQVEAPVTQllHcYlys0FZPkNVBjm0qaFkH8opbFAK3V03uc0hoBZ6G6EoRHXx+Nw
	gDt/4JXkM5LEo6hCoJyW+dRMki8piuE8jbAGheGl4vKgrKgFWLuse6L1wrCK+4bpXWm4I0
	Z7yL/YmRFbS47PeB0Gm7c4A65lnyazc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=omPdSohL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761230051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6+PDu1BKpeekQuNXNoUHSooGzAkk2JG8H4zonFnyfOo=;
	b=vnbI5NA4W9KgIZRsNRiigGF43fSyLGLmnREyEIyysdvk7JSIOdrWZgOW7YSuw2Rgu3KI6E
	2SoZDZF+oWdduZgwTajNfUXietw0/+76e3k5mZyKDpcn9G12LuOAR+QF22AfclCdt015Wk
	l48PM4YxKskAS5fESr4CjopCTx7vD/c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761230048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6+PDu1BKpeekQuNXNoUHSooGzAkk2JG8H4zonFnyfOo=;
	b=omPdSohLRvyzB0wgHZjOYuoN/Sn8Xiq4qDJvMpEU6zK2LjG1wybI/5t1+xPCS0Uge4TRN6
	+Hiu659NVfrHAcTfx+amzmScXnMpSYNZIbbVW5FTgOc8AoUK42k2vD9LcouSEIAaigp+a0
	uU8yjl8J5d+neUeFd0EBsbi2qzma0m0=
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
Subject: [PATCH v2] slab: Fix obj_ext is mistakenly considered NULL due to race condition
Date: Thu, 23 Oct 2025 22:33:13 +0800
Message-Id: <20251023143313.1327968-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ac39s3y6twkonquon59gyggnoon7sayk
X-Rspamd-Queue-Id: 05C6A180015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761230050-168620
X-HE-Meta: U2FsdGVkX1+lrjsaGwsiPTGlq+zkozlo89sl251/vfVRiyDAsvMHQQAtKEnugqyNKBI0o3lNa0itixbCt2XlJVaFcJ3lrd1FdFfU4agdHZkJLyInwjp8EnlJZma5a1/nf/0TX5VBSIMZzt2CXHaom6PXwVPmgFFdB5Rqm8lAaa0/6XruEBlXjuE52QPMH8StMTPJre5vxV+g851OZIPZVGvJ58NK0B11HXfrmcPcaZ4GDJDeUxnvvNMFxwIFUZUr0ZAcEq0Sb6RCBnFBfiPtCvPMK8w9mXfM4red2o7+G+wEoDjADRfztBtwHZFW0PJixcnxw3v9tCMQjE+XxwoSVw7SWE11r8Q1pguA/+pKoUBk2uz2+W6KfsMpFJWkSRlVUvTOlvhspcsr+izjrx6PK9EnLYONIzn2pIlkabCAJPoYr31vL3K4JIQgQZKzrGYuCN0S7J4P6eTX0Z9K6Pv9cb5EFEFJCMGnXN1l7PwXQbTjH73FBwxE8PWtIuK6ADfASykbrCd6d4ar/NiKCqqXMY1frLSPUjnEOhkueyDJiOi0TVkD8lhcWtnarNYx2yMHq4bSliJGRGYgQNAwyi31017mQ3wIhihWiQM1k3HL/fPjowXj8BbGQAzRm0nU5ZH18bzpxu3GmRK0t1YIiDs8rvp2etvaSDaWmYWYUvKWZr2Mmfx9TjhhFFUvlQPdMaNQgiJvX7fnjOVU1IaRl7d9EGl5esc7gdJM8XhYvCf5/9rV8Iot7Org5m+RkGkfnCFATWU1w3cqZkaIuqeKk3S3mZzjFyMHD6PRarMihAdos8uh79xY5K3R4iXbrfDtteI9zCBcI+JFfjeQ20Qy5Cs/KfgvYmmT8IUsN72dbBbayzfuI+IbC6oafLFCtrlYcoPC2LDCLzl9wgIM9zkFxJzmA9FnyD7H5oVxsZ55tKhiM6ImRn3zuPdPN32HIPNiV+IGtBZKX2USyqfOfC/h79b
 j338q4M7
 xFzLsryn0K3S37MA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

If two competing threads enter alloc_slab_obj_exts(), if the process
that allocates the vector wins cmpxchg(), and the other thread mistakenly
assume slab->obj_ext is still empty due to its own allocation failure. This
will then trigger warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG
checks in the subsequent free path.

Therefore, let's add an additional check when the process that allocates
the vector loses the cmpxchg()

Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
v2: Revise the solution according to Harry's suggestion.
    Add Suggested-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d4403341c9df..d7bfec6c0171 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2052,9 +2052,9 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
 	}
 }
 
-static inline void mark_failed_objexts_alloc(struct slab *slab)
+static inline bool mark_failed_objexts_alloc(struct slab *slab)
 {
-	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
+	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
 }
 
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
@@ -2076,7 +2076,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
 static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
-static inline void mark_failed_objexts_alloc(struct slab *slab) {}
+static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 			struct slabobj_ext *vec, unsigned int objects) {}
 
@@ -2124,8 +2124,14 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 				   slab_nid(slab));
 	}
 	if (!vec) {
-		/* Mark vectors which failed to allocate */
-		mark_failed_objexts_alloc(slab);
+		/*
+		 * Try to mark vectors which failed to allocate
+		 * If this operation fails, there may be a racing process
+		 * that has already completed the allocation.
+		 */
+		if (!mark_failed_objexts_alloc(slab) &&
+		    slab_obj_exts(slab))
+			return 0;
 
 		return -ENOMEM;
 	}
-- 
2.25.1


