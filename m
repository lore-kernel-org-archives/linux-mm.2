Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 716A9C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E59D6B009F; Tue,  7 Jul 2026 12:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595EC6B00A0; Tue,  7 Jul 2026 12:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484756B00A1; Tue,  7 Jul 2026 12:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C23D6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92FCB1404A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:11:44 +0000 (UTC)
X-FDA: 84962471328.18.975A4F5
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id A67A940002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:11:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mL0GHzSq;
	spf=pass (imf04.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783440702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=99+toj70dZgyWT9XG1jyZH6wGT8LuDxWhIOZpE4AM10=;
	b=XGLk/YKxdN8nc3iX+VV9gfinl9WBvZl9AM9yxg33PWojWApBUSyKDQiPlJqXQwqJABZlmn
	5BZx5Dg7L/SrOfbdehGb78BZL2CdbghGbmy/+eJkCqmJYHJJ3IiwK3NZGQbUHsWVq/zbJh
	M/zIkDJbPltWCKmt29LoFazDQWQkqkQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mL0GHzSq;
	spf=pass (imf04.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783440702;
	b=a7e0sHnRTeCJwCBQFBREhV3NtuIB4SOZq/8d6zjtOziuHZ5+z9K/oVXfuYyV+rAI4ECVh9
	baq7D97cfgcN86uMuo383kBz+Tl/BrNHZKC4XhzmzL7UUm3ffzfKxmUR9DBflG4SkA/EJO
	9jgl+xvXigHAb11MShfbqn249Pd1xNY=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cacb8416a1so37073685ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 09:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783440701; x=1784045501; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=99+toj70dZgyWT9XG1jyZH6wGT8LuDxWhIOZpE4AM10=;
        b=mL0GHzSqHzLk5c3B5hfj7bQGihmTOT9mwmFgwmWl4VZRcXCEVdZoOsQPtq9xvESPtC
         eEnk7g/VZ4VhniX84ObY0V1MsQwoSBLd61l703TjW+JZJiVxtYuAcQzZiHTLSJf71X0S
         6+3kylqwAnU+CTqHGZUW19MYm8XsqOCstflya0CFH11aAVKnnAxs5vxNF5bT5KmbEBbM
         orL/rSw6Uk/kTbQTbuYaA+gVRc5mnw9OGxIOs37+TKtUhNx/riJKXbiTdU2m4RfGtJIv
         34DAatvvhg4tKZ1Dv+ZgxZKxeAupyAw568AmHf3p1mKSSQOYRL1Onnc99PPMNlj7ejpL
         XUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783440701; x=1784045501;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=99+toj70dZgyWT9XG1jyZH6wGT8LuDxWhIOZpE4AM10=;
        b=iUn3fszcp9VyKEc1TgwD52xZ5REfH5H1rwncrtAl50CcYck4O6DmX/V8NIF0whw4bR
         JOnwRjeAqZUmoMmnWD8NuWd0YUWhIs1QjhW6sYBfr8oAYNLRIPQDVR5WPgzaxTZwAmTd
         c5MWC+qr5LUcbk3UwqhjcEgf5TZP5MRFClKWLs7tes/U/zhiof0BJOXIEDn8++Szv1K3
         K58bg5l+QndLZBIQprO/AeN9mQECIhkbgY4mD+E+6Df96iMdjPJwXP/klKQBt+Gr3xCB
         DpNaQCHjWtDI1R8hpyl6yKA9gsCOUI0Gpek6gs21nR1hVBtIlSXCIBdW7yyqAU5qxRDK
         ESpg==
X-Gm-Message-State: AOJu0YzcbXwHrXGEFaOrJXFjS6XEX+LcXCkHl6n9tb5B7b442Lr7CiDR
	op5M6sAl9iaiGnnLLLamwJi0F145quK/dmVrXb52GBDnCejj7/mNEX6m
X-Gm-Gg: AfdE7ck6/o2Vi2qycsCBnbcgRuSxnaiiVoQglegyX0vA47dz2y6k4b/mZDnVx/7JkJb
	/2jZY7pm+RWaxSOVthj3/wp/Fo0AP8xVvGo2k1/aNfB6FPNgTaPZJtEo6GY20KUUs8YoSIsUMXA
	P54Ian31hRZ7ownNJ7dUVjAJJXQybcMyF6HffxoweqjlZoq0p+E0f6cItjcxOrCsKqHCz9Uxkrw
	deWbJDHxziLlMQtnzP13/7AcWa75otCqMcJ+7ly5CAGBlgE7F964aPVjZKgIM228MDAD8TPsVqP
	BfcbzqMNs9lSR6qRG3xxB8wPjd8PciyZE9n1TKwFVVmLTUR2nPLHya+YiJTExgaEZC0ZIeGsTvR
	F+NiFet21/C9u996qGFe+1j2zFTHXUKywzevP6AcAO/irMpVdhbSCBgmh7E69iDpzxwM05M5aU5
	WTGidfEvmZT0F4uW34vuoaWu2y3Op6o+xx1PJ58bovSoEu/3A+0wrB9Two2OXUOnrFr2BmR0mU8
	+CDDVDqUrJ2RHC0DsmAELhzeovsWElk6PuPSUmX
X-Received: by 2002:a17:903:4b47:b0:2ca:ef49:f5a0 with SMTP id d9443c01a7336-2ccbe617daemr65460725ad.6.1783440701373;
        Tue, 07 Jul 2026 09:11:41 -0700 (PDT)
Received: from [127.0.1.1] (ec2-18-162-112-89.ap-east-1.compute.amazonaws.com. [18.162.112.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bfd443sm14712115ad.30.2026.07.07.09.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:11:40 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v8 0/3] mm: clean up folio LRU and swap declarations
Date: Wed, 08 Jul 2026 00:11:26 +0800
Message-Id: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC4lTWoC/5XQy07DMBCF4VepvMbIHt9Z8R6IhS+TxlKaRDEJo
 CrvjlsWjcImLM9I/n7JV1JwyljIy+lKJlxyyUNfh306kdj6/ow0p7oJMNBMCU5jS8unH+nvOzp
 2c6HN0OWBdtNMY4e+n0eanLE8WiEgRVKtccImf907b+91t7l8DNP3PbvA7frfwgKUUR6clz6CU
 kG+ni8+d89xuJBbYREPVTM4qoqqqhCC0qax0bm9KreqOKrKqkZkwB1yxtIfVW1UwY6qqqpSg/H
 BW0wc96p+qIYd/ldd1SQbLa3TQljYq2arqqOqqapnYNEG1USRtuq6rj+e0fLyiAIAAA==
X-Change-ID: 20260531-ch-swap-series-plus-folio-lru-cleanup-d9781c8332dc
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Baoquan He <baoquan.he@linux.dev>, Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783440691; l=5288;
 i=wujianyue000@gmail.com; s=linux; h=from:subject:message-id;
 bh=3q6cs41GifWzmyNSOa0nCahu/8aSuzVSNbctt5MiNwg=;
 b=a496fpvM/EI7ZriJBD0qzF1GY/kXka+3Txn1hmbxzxK804xt2v/K9j5UQ0lHccZscjCeumXRN
 lYD+D4bREE+AU1PaxKjnOiteo7YBbGCmV1RthqFvdvMNSQvNiwnw91r
X-Developer-Key: i=wujianyue000@gmail.com; a=ed25519;
 pk=49tqjvkqDVX1TtHEyTCiJGlKLg6SQ4BmgzG+HoHQW6E=
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A67A940002
X-Stat-Signature: yseo89jx8yec6bz39rgum6wucgiriaga
X-HE-Tag: 1783440702-461490
X-HE-Meta: U2FsdGVkX1966sH676aBaULuHH546NfGEu8gH+ch8XrPFfRD74A/lsjfTDGSkPPzIILqq9gYBrOLLhWqGEnucl2Mr1TntzdHsGCdMbGvIa9gIay3dHLe59Sif2n73hBnqILCq50jRtVuDQDYxwkp9eG1UepFqhBSATuF8j70JTEeOA4KWIoewe34KUCBZ3njh3hKXFhPQMdoRm84QCpeORYXSe5sBiU1TMwhy5V5jrwibsfWYAO8Phx6LZRHlfxDiq5I1OP+3JKII7lYIItVFfRW6mx/bATyP1Wrbz3DoI6fGuDg/wUBd9SKdk97Hu8KNse/jUJWDOri08U+kCIiMNxzZBuE1cjnXKkmWKv8nT2yfsRKjEfd12B+CGIshDCD1z1G4r2z8tEUNGkWqTefGOoSuIOOGvB3uLvEAVjuOvTgz/o4M6KnmK6M7bTyDSCVx1LbGrHhEeVD0old67Hmfr/J1AQpm/0+dObQWNvFQxtVzmFs9evhbZ00fiAEvDW7qnwthQWvzNg1nnJpw+T5yFcdHfUpL56dkRsrRIIPCTk6RBcMsKz3VV9Sir8qt3bvWTUvWmNFQv29DHDeSmsS3GXjnl1Fwzb4Vxo+CF1qGFCuNxbOSsp5xgdqL3C8xMTC+ZmVE+rWiNOnJlStTE2m1OJNvyvC4ztGjr2ur/NGcH6WCYGmaIy4zOFu+1dlpas24MBCLntQzmhPI5n4hIEAlyLqiOn/8V//km7gkYwotlW4JxtbE0Vo3n8BBjFoEnSEVvfvullokFHUPmya3AaMSHgaG/rYUjAL+WKQxpQlVFmid5N5RlkM7+CxA9IFSaL5ORrUrOx7pxQuH3i7jlJ0r14XG6f4OA1iZMBdGbA5/qIjCSqXWIjQqTG3CUJ7/rzYkNuuv8fTZSSvr/hOCfkkmKkWWqiQiGFhSj/PpWFt7RRHUIb/9wf7UP27gibfWrfFW3dfIOh9OvXa2kBXPVJ
 TmvOFS7j
 nGbw1+cfP+bcNZ2KdBz9WA4VQS7xFStf1LJ4E7O4qzY4zHBgk8VlIJja/zOd46g9Pc1zeSOro6x5C2K0TZQXQ3jQfenHUs2lA4iprITgHWmCEMzMxI9/8bh52uwdLMCfDol1sNZJ4R8b/awuNAUtv5l7w54qk7BFTO9bvaWzC++RlI0GAcNMw2+5xVyCui6kzsmamEv29vEq4Ih94yOt9DkDgmLydrDKeYc18DAj8JtCv+o1QC1cch1vWAMdopryOvxdJkYfZn6g8R+s7uNX30Ts2Z8B7BMxbq/V2vhnOThWXe7p+zWo0kX9hS88NFL/emaEXLf1xDDSWJWS8ITeUqYjjwOWnKIfa6m66UOEjENqrdWHMEKmh/bQyJZYxoLrx+jKlHGP2klI9MoRAV5hv8lywBCr1DcPG0cFaR3tYqAzJJo/Dk4P6D65miLeLdP04SyKpef6qPMxuLvn/GzvWcvpgMRr/bAmIzBWuhQgAR01aneW5HalxbNwhUgK9ADR+vJyBtq73VISqiV7743kBMTAnMc/638hqCUzJpjNAPq+OtRUZfFM86TBIo4WnX5Kn3WYRjOxQ+KmWF5wL3CvmY8OrvlqNuE3wHGH08K2+fX2ewgMILtcLPfcKdoG/Z38t5NIIrTaYQqGomMEFL0M51y7nS9rv2dQwb+DkznySTgxOr8ryHOov/Kbtm0u78J/KckZAjvaPLQQBJdWSQznBTuBjWHicXeZcAqnXucNFk8ujPO0oFYdVcZwlq1okeINqf7oGeGoXWxl0mqxLZXiKmo6VpBC5YVisf6rN3n/CSe2avmCNJOiDtImdurnUzwUEzhPxTV4sNhLJtN5Wxe/vNXcRCIkfGteXHWDTOOMHCiLQTh950oKXgwcnwX4ynXJJZAitxQXGn37KsV3xIky1FTJ2Xl+eQ4/lJlniSj0zTgjWy24wrEmPNbUSZmHWwZpWBUDKyLSlDjABd2PajSExCD7mX8k5
 dbK4gM/i
 M6xf7nD3m0yE2BlolDWIQKLiE5BrPZJENbrkq1pyQmeRKupcAfmZqQMoE1RKjE6wJSjE4/1NCF60yLxO3W2i9j22xohAIIPInSDMns7XUCD9/seJmS9XhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series splits folio LRU and swap cleanup into three steps:

  - move the page-cluster sysctl next to swap readahead in mm/swap_state.c
  - rename mm/swap.c to mm/folio.c after the swap-specific code moves out
  - move MM-internal reclaim declarations out of include/linux/swap.h

After this series, swap cache and swap-in readahead stay in mm/swap_state.c,
folio LRU helpers live in mm/folio.c, and MM-internal reclaim/workingset
declarations move from include/linux/swap.h to mm/internal.h (public LRU
helpers used outside mm/ remain in swap.h).

The first patch handles the swap-specific page-cluster state before the
file rename, so the rename commit only carries folio LRU code. The last
patch keeps the LRU helpers used outside mm/ in include/linux/swap.h and
moves the internal reclaim/workingset declarations to mm/internal.h.

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
Changes in v8:
- Rebased onto akpm/mm-unstable (0bfae5663f86).
- Re-tested full build, swap-in readahead smoke test, and run_vmtests.sh on x86.
- Make swap_readahead_setup() static and remove mm/swap.h export
  (including the CONFIG_SWAP=n stub).
- Refactor swap_state.c init: extract swap_sysfs_init(), add CONFIG_SYSFS=n
  stub.
- Drop swap_readahead_setup() call from kswapd_init() in vmscan.c.
- Add Reviewed-by Kairui Song on patch 1/3.
- Link to v7: https://lore.kernel.org/r/20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com

Changes in v7:
- Rebased onto akpm/mm-unstable (cfb8731f5396).
- Re-tested full build, swap-in readahead smoke test, and run_vmtests.sh on x86.
- Move swap_readahead_setup() into swap_init() in swap_state.c.
- Move version-history text below the "---" separator in the cover letter.
- Add Suggested-by and Acked-by Johannes Weiner on patch 1/3.
- Add Suggested-by Matthew Wilcox on patch 2/3.
- Link to v6: https://lore.kernel.org/r/20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com

Changes in v6:
- Rename mm/swap.c to mm/folio.c instead of folio_lru.c.
- Link to v5: https://lore.kernel.org/r/20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com

Changes in v5:
- Rebased onto akpm/mm-unstable (81652c5a65d4).
- Fix mm/swap.h for CONFIG_SWAP=n after rebase.
- Tested swap-in readahead on x86 with swap: vm.page-cluster present
  and writable, swap in/out under anon memory pressure, page-cluster 0
  and 3 paths, no oops in dmesg; run_vmtests.sh passed.
- Link to v4: https://lore.kernel.org/r/20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com

Changes in v4:
- Address Baoquan He's review on v3: align patch 2 subject with
  rename-only scope; fix vm.rst sysctl documentation; refresh file
  header comments in mm/folio_lru.c and swap.h declaration comments.
- Expand patch 1 commit message on CONFIG_SWAP=n vm.page-cluster
  registration (also on CONFIG_SWAP=n kernels).
- Link to v3: https://lore.kernel.org/all/20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com

To: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
To: Kairui Song <kasong@tencent.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
To: Nhat Pham <nphamcs@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
To: Youngjun Park <youngjun.park@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: David Hildenbrand <david@kernel.org>
To: Michal Hocko <mhocko@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Lorenzo Stoakes <ljs@kernel.org>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org

---
Jianyue Wu (3):
      mm/swap: colocate page-cluster sysctl with swap readahead
      mm: rename swap.c to folio.c
      mm: move reclaim-internal declarations out of swap.h

 Documentation/admin-guide/sysctl/vm.rst |  3 --
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +-
 include/linux/swap.h                    | 76 +++------------------------------
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio.c}                  | 46 ++------------------
 mm/internal.h                           | 67 +++++++++++++++++++++++++++++
 mm/memfd.c                              |  1 +
 mm/swap.h                               |  3 +-
 mm/swap_state.c                         | 53 ++++++++++++++++++++++-
 mm/vmscan.c                             |  1 -
 11 files changed, 133 insertions(+), 124 deletions(-)
---
base-commit: 0bfae5663f86b4b08977b132ea4c35abeb53425f
change-id: 20260531-ch-swap-series-plus-folio-lru-cleanup-d9781c8332dc

Best regards,
--  
Jianyue Wu <wujianyue000@gmail.com>


