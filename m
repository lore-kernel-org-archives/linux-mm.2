Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A8FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3040E6B0005; Fri,  3 Jul 2026 08:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB8D6B0092; Fri,  3 Jul 2026 08:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1666B0088; Fri,  3 Jul 2026 08:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D888B6B00CA
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16F7E168351
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:39 +0000 (UTC)
X-FDA: 84947404038.03.EB5A54C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5E2CEC0014
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bayTiYm4;
	spf=pass (imf10.hostedemail.com: domain of 346tHaggKCLIbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=346tHaggKCLIbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081957;
	b=c1PQsTboS6YrpiJ6CzKkQq556M6bz5hCEw0KECK4ubKOClHizGRP9D6qkREXCyzIjwaJkh
	m9L8oHGL7vIoKmyIugQbOXgQsdaB4QcVReCtG9R62+xUnRBGrB1GeVM3oGL0oKiE7dksY3
	4p3xYCmVI6a9uRp4NZ9Qs9ZplLgD/ng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxUSvpYnRk7TPJu9DIAcrJg+2SEdx9XX7++N/RbsLUU=;
	b=2M/+rD79vVLv4wOp79oFPbG3jzVUn7vIInxigKtdzMogrG5CEjDXE+ELDf3Kf6ZchVFiPr
	iqCcQ3xokxnwhVIVwKy3l8dVh1aQmP9i0Ak2FmVLtXDFlYhjUbc1+v2wdjnkRrp96evrzF
	/Lvp/OT9eXhSd42VtgQrGx2hLX4TBZo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bayTiYm4;
	spf=pass (imf10.hostedemail.com: domain of 346tHaggKCLIbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=346tHaggKCLIbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493b786d550so5382565e9.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081956; x=1783686756; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BxUSvpYnRk7TPJu9DIAcrJg+2SEdx9XX7++N/RbsLUU=;
        b=bayTiYm4p9yBwPn4SNWYHzydf52yjte/hdDZH7NMuqZg++MDKFg89UkfDsfj0LfPzf
         WZqlaLL61DWw9yYRKQaxtj4ZRNGdU7yIXs637CDdTKEpXvLBYljSmDHODVa8ZR9fmLKM
         lalKz8Efs25xEgGSENt0rK27AxU1JZpmHg9POIV2KXH8RX2Mp/ztNe51LLvaZ1XHefvV
         IEFyVAwelj/aCdlrCK396p/Dhpv3Wn83bOAv5RjGpq9pmUUJHvlsKYbb9xV5jybYF051
         ytIitmBakW0Zlouv+SesijUKdp8URYmawCKW76KuqSSM5ctPmYuzNva2virDiZ3/0voR
         IJAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081956; x=1783686756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BxUSvpYnRk7TPJu9DIAcrJg+2SEdx9XX7++N/RbsLUU=;
        b=EC6bXX+7bukSq7IrrlkZYIwJvLxCFp3CNuEwg33PzT2vgQYeWiYNbGfe39ekNcsnVH
         aLteoP3nsPSPUWTXEjGqfpVGOGPdZJMR+kYFGdQq6V5qrCoenW2bz5RvFltf5ywj04Pt
         tpxbCjYSn0CODVEr3YGbMivzxFg6fyTCedVnkTWA18YbXFuW86/bS3qf12aAUhDBiqd0
         zBrDI4wd1kLy2JHuxNaOlUcFLYyLLckqaxcej8tTy3OaakVrGh+1BzzEbidAqUPcgm0f
         h0W8FZngkAXp9U6jEM7UkcoMUp5Y6a2e6nJojb4V4NvaE10Ky6XzoFHHkyakT2XJW/nR
         HFjg==
X-Forwarded-Encrypted: i=1; AFNElJ8f+J6WtXEY8SSh2vdIeK7EwiXUJAT9B6A3u/rqwWzVwNas2m0tMrQ6wVrwlHWzqucjZS2OG7OyHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0r6OMQ8HJneuoo1YkTFU64SDdCAbWCbZA1L4d3yaCS5GA5mQS
	g3X0Q6j2zkTIRr1spR/+1Qofu6Vw0EsMflIqzm5qEwZYS18jpliQJ8QgAkZg60IqUUwe3jmk+T7
	DRQ4nJ19sJ8rAZA==
X-Received: from wmdn10.prod.google.com ([2002:a05:600c:294a:b0:493:b4c4:536f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5d3:b0:493:bd37:1cdf with SMTP id 5b1f17b1804b1-493c2b3d40bmr104790495e9.2.1783081955851;
 Fri, 03 Jul 2026 05:32:35 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:53 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-13-c87b714e19d3@google.com>
Subject: [PATCH v5 13/18] mm: Remove __alloc_pages_node()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5E2CEC0014
X-Rspam-User: 
X-Stat-Signature: pqmzfmyjyw9uoky39rx1sxd9z8xzni9u
X-HE-Tag: 1783081957-786877
X-HE-Meta: U2FsdGVkX1+utlBP+rURD8DN973SVBgI8mLKdBPxKAKLc1K2ti++TN2KIRxjgyrTkQnABKqdSzN5dRLcdqZ3FZb1USluL72hA2JtYsi/7fMv0/uLUt3YE7lUDsnpdxDVLYOd7KXwuINOAQGqA0s13CfJcOj0VbPYBGLX8JgybGk25VYX/0ux0DIs6dN1QQMhXQ7CLRyuSMgJzUCZojbJo7prb/xtwEIumzZP5g1R3x4AJL2llouNCeScdq2yHJYV1SvtyJL/STSpKr4D186cehp+z2B+u5zAuqSC6GTo1JyqI9fKBLQMNjY5gp9gXo3aXN6VJ4ui2xknL3b4Py4dX8es+E/hcEtTO/W/cMsyBlC48Bi32KWFkzW+UYl1dHPMGXg9PKCnwCJjXbP3e8QgeceeLcn5eyQVzyKQkY/Jx7Grk0IBqi+xml4UFrhRSEK4VogUiRVDsPOOAs8HWYRXEZYjaBXaee1vmJEmFZYMhlQd/3h3z/Pu98oeBhaiNn/Paht0aZe6hdagScKJUoLBMnhznmragK2hM3OGJ+brJz+e7lXp8b3qB/leJnCC1Kdxs5ALlY3oFcnkszDyj8umN276kQXWjNuoS1Sy2Sa8TbRUCI+lMLiFwE78Ebon8ROJpglQxYxazq05uo6503bD1OCLLfRbCb1pURMFyzujVHRJRviuUWD0+9FjDnlhFGrPaGEVkI2zi7rwfVD91aYierDQ5Y+sNJ3sTqN4i9ao9TPUKFbJiBxItEbI8AEOK9hhcUGPVrh5iYG4uG2dx77S0eSeih1W/obPgL2ZXfVWbzohNJJTj+LcAK6o/iWEz0qKkKuL+Li4Hy3mVZnwzfqsKW/r2YcinwB28jcE5Pk6WUiKTrMUPX0/R69jqeV2bLkOjHXudmyZW3jcekleVFfm8LmwsT931cvHOfdRMD3MRWpasCuV4HrHUwBPFpeP6Ox1CecKBDMUPrSt3FSBbDE
 A+Yf01pN
 Bjh4ILxahzlepe8+lScnNtJWeUKseARHm9Z+HwJfyKP05qvE5V2Nclxqf2Vj2HvTMxrGrRgQStcLI12HYc4dZxfxRPTzAlaE0yC21xrR8KfYx1gPm/cpzOaev/4mwYGiiVdKNT/g9q6scpsnvDTGlsRuzP8GAhcTql/NZg8j1k0tXf7UvB7z/y3w5eYkGgAIEe7E3hU8O2Ex2AJtSRFA0/tPRJgmuTLLDMSlyz3mCMv0Yk3eYROjhxIhk7xzODBcxaoHKCgdoW8+En3KKMY7LqjUxssvzdmE7bhas2ZPcx5c3B+RZsneR96b8u8/Nlz+rRWsOf9NscA0JkS+Hf+glqddTDSVlZ7+nQC9aPRJ/uWmdSaaYvxpBmtOM98c/UokPizCnRNJ0q5AzCnBRLIh0+nFnobl5cY2eO7YlitiZ8LesCQrVmY+iCQPckNgcwpOOdCuVNK1o2Cv9MxOLyddhznGao2rmXCCKFcDi7ADUP+UJS7CwRTrbfsYYhQ8002Smjb2gfSMp4QFi1sqHzzy391IjH++nwF69aMOM10ILFk1OhqmVHXopzMJL6iMcKOKvbDBJ6r5CcGvKa6J7xsjVluBpxZBNZ0vanzuKPEVgd5j0XvdK6jzoecmg8iUuzDK21ZhVVq+HBHjMYRQTn63q010iIb2MOYEftziFnsmwIj8sgLZs2y2g3XDXX/t9r6gcNnDZU1nTZPODPrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There were only a few users, which have been removed. The only advantage
of this API over alloc_pages_node() is avoiding a single conditional
branch. The disadvantages are:

1. More API surface, more sources of confusion, more maintenance.

2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
   were using the result of cpu_to_node(); if the CPU gets hotplugged
   out this will return NUMA_NO_NODE. If one of these paths fails to
   protect against a concurrent hotplug then page_alloc.c will use
   NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
   memory corruption or other. With alloc_pages_node(), the code might
   just work fine.

Ulterior motive: this frees up the __* variants of the allocator APIs to
serve specifically for use as mm-internal API.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 01d6d2591f49e..3bf55a5f9143e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -256,21 +256,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 	dump_stack();
 }
 
-/*
- * Allocate pages, preferring the node given as nid. The node must be valid and
- * online. For more general interface, see alloc_pages_node().
- */
-static inline struct page *
-__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
-{
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	warn_if_node_offline(nid, gfp_mask);
-
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
-}
-
-#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
-
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
@@ -293,7 +278,10 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	return __alloc_pages_node_noprof(nid, gfp_mask, order);
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	warn_if_node_offline(nid, gfp_mask);
+
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
 }
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))

-- 
2.54.0


