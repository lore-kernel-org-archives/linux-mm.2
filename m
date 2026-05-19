Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83362CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC1A6B0098; Tue, 19 May 2026 10:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3826B009D; Tue, 19 May 2026 10:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0716B009E; Tue, 19 May 2026 10:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D04EC6B0098
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:18:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B879A0271
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:18:07 +0000 (UTC)
X-FDA: 84784373814.03.9C0AC91
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9E35E40015
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:18:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z5H6ymdK;
	spf=pass (imf04.hostedemail.com: domain of 3G3EMaggKCIYtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3G3EMaggKCIYtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779200285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uems65kP0VRu6i+029j484GD21MKk/86CTpEq9XOK2U=;
	b=TZhSFErooZJQZjm6Axrg9HXaTSLmgOnM0A1dWkzgVWPrTeh0jYaXLp7+eLTOxsMqPKhm3M
	d75YldwHelSiImikR0DU1zajlNhWmb2VA/DEkFxwPHtxHnrxwSCqcahBWUVnYcHQXcusc7
	wfaZipykglFYfOkBV4yBHvXAoidagVQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z5H6ymdK;
	spf=pass (imf04.hostedemail.com: domain of 3G3EMaggKCIYtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3G3EMaggKCIYtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779200285; a=rsa-sha256;
	cv=none;
	b=qJuD/b2Em6OfkjG8iAC7nCZ+ZkxTpEm8SzAJ1qMh1ze7hJQ/nNB/Vp4+mis7ygvJnSrHQ8
	TeZwuy7bLW44RFolN4fZT6VyJ4wqaO/zVYdffPqMD/OkAP5NeWbeB3rwQBcZiQbgBtAhEX
	k9Y9Ul2kph7WPYlLZ28gOOiOxzYvP7g=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fe44ce385so30500165e9.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 07:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779200284; x=1779805084; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uems65kP0VRu6i+029j484GD21MKk/86CTpEq9XOK2U=;
        b=Z5H6ymdKdNNKSEyNxsZsFLGrHWExrlfd+ub192j9Qd2S+vuVA0e+oVLNV6UXXWxLxY
         xeJ+6vxjR8YqXMb2Z3THz9IbJmqCCKwb6oYlBnD8JPka0a+CFN3NXQHbh8m4GOxjCPoR
         T191BW72XuzhqollVN/DwWDJv7gutpKdb7r+Y2U/qGqLr5lr+lG4RY6U8flXog7NGDu9
         W+ZKYYES3kNnpVdnEErJLZdt8Fy4fjq7sCbOAVnqfSajPtA9v1AGPK59QYpKcRMWDB12
         018UVCLSuCodeIM7XWzWnQiF+kL/0gCmtTsaGiqmCGILm7ojwyJQ4/HxxJUGEerDsnEi
         84Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779200284; x=1779805084;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uems65kP0VRu6i+029j484GD21MKk/86CTpEq9XOK2U=;
        b=epAzFMn9HDq0QCTR3GEVoEMuBZCleNMHZ2FeHEpxisOQ8VMQhOXsTnS30PgQ7rGsUd
         FnMEiiOlp33prmam0u+XmifKtEE8Cxv8QHEXCx5QIWf1drntOfrgOnKfysguo7UcnnJ8
         iHqpGfxyAcVwdwlkdKZdy2rHPZp8njccBWmGNg6UkNVQxFTTP2eoQ4TncQ6bYFquOkdb
         j2aVNSPxYkhmm8rOrxGQaIX5/6PSa+Ysl67RylhNhPrOHHUbqHXrb6SjcICEjqyQL7hs
         /99AhbxPjg1rpOG3560YHX3HTJv9emwzqCkQIHGrELp9za6w2PoqBBQGWVdWzd5l1Yc8
         JI0Q==
X-Forwarded-Encrypted: i=1; AFNElJ+0SZyzU5j7St0RO4A42LFV3s6IG/CBRiQVbpH4aGU8vxunQAiyj66zYGstEvFu/zswB3I7k98UPQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5exm2gYt/+lol10ls6ajxf89qNHWiVluYx+AwaPvsCnfqDFJg
	2bfNn0ly7b0e7iZ1+dR3+pVpIU1dLXDVFK5QyRSO8FdytE2fZVOcfD3Xa1uzfB8xU5PkidGkmab
	PiLpzLWdUKtJAcg==
X-Received: from wmbka5.prod.google.com ([2002:a05:600c:5845:b0:48f:e178:4b87])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:620d:b0:490:18cb:e820 with SMTP id 5b1f17b1804b1-49018cbf419mr73386035e9.21.1779200283971;
 Tue, 19 May 2026 07:18:03 -0700 (PDT)
Date: Tue, 19 May 2026 14:17:58 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABVxDGoC/x3MTQ5AMBBA4avIrE3iJ5pyFbGoMZiglRaRiLtrL
 L/Few8E9sIBmuQBz5cEcTYiTxOg2diJUYZoKLJCZVVeo3WrowU9nUhu29geqFmxIV32qtcQw93 zKPc/bbv3/QBYgvNoZAAAAA==
X-Change-Id: 20260519-nolock-rcu-comment-8e6eac83b6b8
X-Mailer: b4 0.14.3
Message-ID: <20260519-nolock-rcu-comment-v1-1-4a630c8794e5@google.com>
Subject: [PATCH] mm/page_alloc: document that alloc_pages_nolock() uses RCU
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E35E40015
X-Stat-Signature: so8ke9goi6wkutnkgt44guy1qdwq5jnp
X-HE-Tag: 1779200285-151601
X-HE-Meta: U2FsdGVkX19rQWWFDQ5ONxd9YP+rVxppwEnDjOe6TF+iMOrhgOcXlahC5D3fU8Dieah3YCKocIcXGjp4XfPBKzTH71jG1ERw5MuUQRuj5fSUB3OvkvcsOiYgfB/Z4kx9d64JfJeOQ/snmyNy7DGEKEOXMopiEjE6MgUi5EQxHsrZuzwAjChabShWtNNi4DfEIaZh0vxCuGFrQIoYuyft3KfpOrdLWjx2/g+lLh2yB00We0/FfTYYeiYQoyu0wDAzVlVmwyCzJpyKJq6LctGcfB8oXWYDe2jnxxfoHGSHrCJQ9LEKc2OnEs2Df7HBJbsLXIVmPzhXp3HD2vIe3y0XPg15QkHyifJB2PjD70lMo7xAczI6QtByPQhknTn53p9sN9h4e7hunbu7ZgDO6YfWFWaXJ29LhgiADlmaLdpBKp1umVIKAkQU0AS8vwT2bgBEuvBpytE7v1jecQ4E92oJLaiqEjhHAoFMNeIaaWnFlU7jf6rkFvVqlUiqDnUGuUYrj3UvXeQPqu189WITnchMNnp1myqPFhUP6iLDZOp50KoENrvDKMXLzpdu3x9HUcztIW2lTUokDk2MUMvs337d1da0Jl3Fd92CLUH1Pq0Mu5FOMRY3NRegY5MLm2s6cPdT+1iEGJVubR9LjZmjqamp3i9OYxMn1ttdBnoB4N8qYgoCLYD9Q304yYb0Rg++l7k6T2P1GYCi5eWf6vIKtGR/wOY+i/zTPYoBcAaR+F+vo9r5JqO8evy3ijT++W2JuZ5SKvyXrCtpyGkg4fDTYWvcskMDMa1Yqg6kRbOyP3MxmFty0+dXsBnEnTgvE0DhpTGdHKPIJZAULR0+eJrirEDO4F2QoqZX2JHZ9H+1bId//5VIjVEON6Ynh/oBfb7r9pitprhrwbS2F/vEdTm5Zx8H3C/eSGzReNnjJWfdopLaMfkITee4ofLypvE59HDNqfEPU+0yDZt9iVQ+dx0jM82
 veIgWi6i
 LlOgHVNKYHNB4YSsz1PgqO4Q4rT6ke7GTQ666m5rwiKq3hTzj0Hvc38bxSFcHVcBit748ZOOioqe/DdU5CggjH3u7YlujZhR7b/tk7OCO4a/trvxf5/K+daZeLEIzJ8HIe8nR0EamDpXpPj9DMsGNF1yqQEMv4btmfsytcfogb1HSFR6g0qIBBy4yVMlxP2kO3nNz9ztu57/SJKvTe0dYW/XfkaaFDpt2Rp+OwJxfnXBUAdHifuFBLzAonS58dC3bEVlhZNmkO17qENnDcfqxUh/5UPCmZPe0ChGgGtQmW52NaLr4QcfvYanJhKr0QWl3Kq0+Qct5WhWGW4JmOZBBIU5RBXSpPdBICFEVmAUmrZDWTpIntbwTOG+LoUZEVskM/g+/oRArvfTjZo5GWTuShEbwxWBYxw5bQ2Ej02VDaS93Q2gjlCD/V79Z5iH1YZLVCxQfIk+ah/YIGZiBKQsxZ9XjgtgeSW604fDNxehhKfxtFoHLdcEzFH6u17uSJHM0hEuqhT8IchrvMmNvVEWVa6HqSRsjvwo3tzVs44BwUrj8UEsXQBrtnEVijkjByflJJegYsgahZC6GldJvV9B6u42PV3HndSp1PzxiG+WVh781m9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The allocator interacts with cgroups which rely on RCU. RCU does not
work everywhere, so the "any context" claim is slightly overstated here.

This should already be enforced by objtool, since this function is not
marked noinstr the x86 build should fail if you call it from a place
where RCU is not watching. But, expecting readers to make that
connection for themselves seems a bit cruel (I don't think there is even
any documentation of what noinstr means at all, let alone the connection
with RCU).

Note this is not claiming that any cgroup code called from the allocator
would actually break if this restriction was violated, it could very
well be that there's no real way for the allocator to act on a cgroup
that can disappear concurrently. But, since it's likely nobody has
verified this one way or another, better to just be safe and declare
that RCU is required. Allocating from an RCU-unsafe context seems a bit
crazy anyway.

Suggested-by: Junaid Shahid <jackmanb@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e262d1316259d..7e647d047a2e3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7938,8 +7938,8 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
  * @order: allocation order size
  *
  * Allocates pages of a given order from the given node. This is safe to
- * call from any context (from atomic, NMI, and also reentrant
- * allocator -> tracepoint -> alloc_pages_nolock_noprof).
+ * call from any context where RCU is watching (from atomic, NMI, and also
+ * reentrant allocator -> tracepoint -> alloc_pages_nolock_noprof).
  * Allocation is best effort and to be expected to fail easily so nobody should
  * rely on the success. Failures are not reported via warn_alloc().
  * See always fail conditions below.

---
base-commit: 444fc9435e57157fcf30fc99aee44997f3458641
change-id: 20260519-nolock-rcu-comment-8e6eac83b6b8

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


