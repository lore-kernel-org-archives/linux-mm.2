Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37348D58E6A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 07:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677F86B0089; Mon,  2 Mar 2026 02:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6600F6B008A; Mon,  2 Mar 2026 02:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576046B008C; Mon,  2 Mar 2026 02:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46D336B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 02:03:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 145B2BBAF3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:03:56 +0000 (UTC)
X-FDA: 84500233272.06.40C12E2
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7FFDDA0007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:03:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JlUQLry+;
	spf=pass (imf25.hostedemail.com: domain of 3WDalaQgKCK0OVaTWVNbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3WDalaQgKCK0OVaTWVNbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772435034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=b68BgO2svrQ9zkYU7SLhBTPAbCEH/OdSzC0ZL6Lj1bw=;
	b=wgbvQlhOsgE6kfLqVA6FoDlzyoxU6JlVhfjhge5R8DKwEoR6VEgc73ox5hdiAHkg1dsxm+
	KXJC/Gbb09LkahDJtLyLre3up1U7tmS3ppURaJWEdwsbtjglTVs59nj/qc/whVdvyKbl0d
	Rkn8z4v6G8LpUHI3AA18F1WJz4QpzfE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JlUQLry+;
	spf=pass (imf25.hostedemail.com: domain of 3WDalaQgKCK0OVaTWVNbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--bingjiao.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3WDalaQgKCK0OVaTWVNbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772435034; a=rsa-sha256;
	cv=none;
	b=HJMx/f7m8nJoWHTlTAbi+th9mcEwKEvtKKe5x9ef6cLDZ8ZFXnsqmV0xBQYQX8oXM7heoU
	ukauGKKE6t26MlOmCsKqGK9lniJFKQvULWjRVXfqnJcrHCrTIQoOuFSYLDnljGjdMg97Bs
	hKVCXZtKNKz/01Bu1rGpr6c35rU82/g=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-1279caef718so1328408c88.1
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 23:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772435033; x=1773039833; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b68BgO2svrQ9zkYU7SLhBTPAbCEH/OdSzC0ZL6Lj1bw=;
        b=JlUQLry+YZJtqFqLtwESCkfO2v6Oem1Fawg+KaSX1bcY0FwjHeB7OmybpasJ26XX1/
         eccCYlJaCT0MTLBIA4ndj8BQPt+J2zxEdQ5bVmY9Orr+Plsr1cIy3pBuam5TBLBU7rXa
         /9qA3fvajr9mkhgfU0hkqsyIZkE4xBOc5rGXnLzPbF3nQGPt0X99cUqUETS1ebUJNBNz
         fQmDI7Wcae4n9RYYVx5WxVKTAzQ4CZ2NA1+tduNlmU6LIsIpPYVI+TjiCl0aQDlZgWve
         82MkSaBvpoxSk05MC5QQx321CFybunJkNuYdS0XBVilOHzuv2grh5ChQRs+FEoikRKaY
         B8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772435033; x=1773039833;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b68BgO2svrQ9zkYU7SLhBTPAbCEH/OdSzC0ZL6Lj1bw=;
        b=GIb/7GZqMd6MBY1r2pek1RPDUKjzWkwQOrEMXtTDKxZ5lW7PeAs6GFRd8W1IPq8s/R
         oiYzdWNGckxcNExydrkBLhHAcismzKsmIgbPXK11CH+zAH+W2hMh3jsgrL4V8u+mFCda
         Yh0sc61IN1HzDZZ7AFppu2ByjsV2yFWPFw+CPAH4ssKKNyPC7yapC9WwWTr1hjNbbxcd
         qzluaRK6GX7VR2kte3+lUsN0uTt1uHkd53TzJO1LAS8gDxlwn37ZhRafdtWZbNvDXjgH
         0Ixz169Sdz87c1Hy21RjPyu2exyLjI5Xivwp0gybhIqlPHHUgOJ0D5H6cIQI9qkGZGLV
         JUJQ==
X-Gm-Message-State: AOJu0Yz1ys9xXTW+lB/2GZP4SYevZUokE6LlInwvRX5OEXz8UWdlMcn8
	p553LhK6CRtRlPa5X6is/f4BLgN1k6UXy7YrUokc983HHHZK5cIka87ciXMtXCOWApjYPqeI732
	Hnv0oIMdNOawIxJt335Fxn6LtdGFUSW/Hr+sMODP63bQkgrMi2NsxigURjCsNaQIl12pNnZFmf+
	uLlfnCFSBNlXKeQahRXGsl9zzAQNRObd8pl6DV/nv+ZQ==
X-Received: from dlk29.prod.google.com ([2002:a05:7022:11d:b0:127:78f8:34b0])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:4384:b0:124:9acd:3a38 with SMTP id a92af1059eb24-1278fc4dedcmr3132169c88.35.1772435032931;
 Sun, 01 Mar 2026 23:03:52 -0800 (PST)
Date: Mon,  2 Mar 2026 07:03:26 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260302070351.3465439-1-bingjiao@google.com>
Subject: [PATCH] mm/vmscan: restore allowed mask in alloc_demote_folio()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Bing Jiao <bingjiao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7FFDDA0007
X-Stat-Signature: 4zxud195b1zyyfeehc3w5mxinnkpxhxm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772435034-25651
X-HE-Meta: U2FsdGVkX1++WXjyCq7isLEd1GjIJEpwaQ+87smpxqAPdAunVi0gkExPQzAcH7rmIausIa+X58OaH3URpE43el3fbmWT3fHFsEeK1gl95Oav4rnqJsO+e/xn74RyhhGxXeLz6fOvn0utPYkrptyiSkoANgysjmu0bmmrA0+wHiHDNwuDWWregI6f4CgFJ4LB+vk5Vft2ZzrG4IK/AmTsD7o2o3C2zrwHdBaAhvYgfyw+P687avyUyULJa+yJxtiT4lWGcq2/7lNb+HnJR74N9eH3TMh41CfT3aKdlcLOEGb7vq7YE34Px63R4fMFOSG1dZQ5KMQSMs65ttbJD5A4+3tNpLI0D6j07IlTFHMUrDOHKZRNvLlZX19MelXNN39HR2JCHqujX4oldSfJ3K1ypS9OF/MuL62JCvppbMtmwWp+hPppTccQSeauJuF/Ou7MX+ZQYyaGwlWYxkOkxMuxzPhjRVJMjv1VJZguAMeh3+mqfLa87Uwi/QsOukvjF6hwHdslqrYXJ2rZZZN/FtD84+KJmrf0V63iinwCUcRBNd5HlbwjIDNPEtqatDb2265UGA9ldMCur+u03621w4tPAxmbIOI5SZ8UqxJfB5rUxdz8Ccp5jKysSi+PV7ucA5IGhE7XPQS6mreA3g8dhkTx4ORfK6HOLXPOk3FYo3r/qVgZaPHDassfFMbUyVW8usfKO3H0eUtpAyYHuYr6fx3HNF9MyVl5454xw7/YRJ7IGJ2r+lQnM+deU3QZ1vE1WvxLl6rthRe/PDdinhF/J5XQmRyBmDKO4z7TILd7f+gune3UPIDb4FnSe2PL9uZ0oocdvvdOvkJ/wmLNJtbZhnnd9Erz2h+qMSVa0H7BxfVrQpQVX8/9gY+2loLs3/PZgDo2yxUzew5/QWP6/rChaCDdyF8vmRirNt4ir+y8tz9TUR4hqj50azg3xEiIjwnH29qIINPcJuLCh+1YNLxpCsH
 pmgvZiKW
 ftzooF9mY+z/oq45dkqB0P5X9qqaOXELUM31J3791lF7JEz9ceARUyvaZFQxF6/9trMXtP0039N57BGVwGO5mqG6QBZxWYiZFXUZWpU0Lz68gKOuBg1mLPn6mzarxrBEA7CXllwItBnA4V3JEpcTW4jNDcGgyFBHg0Fv6gNVtI4V+8PDVp1pFOrsTLMf/vsSrhVKYgAvLqwD/0gekjP/LCcQAqjyz+DNMUGUBG/TDVH8HiWsHPWiOoLSaBiZlsHzEhcI0DVy35nGI3HYgmABSNBiMyMj6PNAbbDoUj83IVC9PVpz4HWBxcEhk+Tn0OpkOR4E9CKm6IPFpf81vNgsk5+esMJyiqgNhKLoIO/rxnfQhUFFPDiZcpNXCIOjfcc0LNx4HZszEEw4Ph57mcVvu+6wR2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_demote_folio(), mtc->nmask is set to NULL for the first
allocation. If that succeeds, it returns without restoring mtc->nmask
to allowed_mask. For subsequent allocations from the migrate_pages()
batch, mtc->nmask will be NULL. If the target node then becomes full,
the fallback allocation will use nmask = NULL, allocating from any
node allowed by the task cpuset, which for kswapd is all nodes.

To address this issue, restore the mtc->nmask to its original allowed
nodemask after the first allocation.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cbffc0a27824..b42abd17aee7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -985,11 +985,11 @@ static struct folio *alloc_demote_folio(struct folio *src,
 	mtc->nmask = NULL;
 	mtc->gfp_mask |= __GFP_THISNODE;
 	dst = alloc_migration_target(src, (unsigned long)mtc);
+	mtc->nmask = allowed_mask;
 	if (dst)
 		return dst;

 	mtc->gfp_mask &= ~__GFP_THISNODE;
-	mtc->nmask = allowed_mask;

 	return alloc_migration_target(src, (unsigned long)mtc);
 }
--
2.53.0.473.g4a7958ca14-goog


