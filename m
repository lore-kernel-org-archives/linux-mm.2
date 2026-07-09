Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D40C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6D56B009F; Thu,  9 Jul 2026 10:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD6F6B00A3; Thu,  9 Jul 2026 10:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3096B00A5; Thu,  9 Jul 2026 10:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B237D6B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:52:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A1D8C0F5F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:52:04 +0000 (UTC)
X-FDA: 84969528168.28.B7D071D
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5948CC000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:52:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qgc+qo8K;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783608722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TomD5kQp4QDVC9gWt3p58S/rBPFQXp4PWIaI11lLUvQ=;
	b=0V3KGvjhxekC7Q3jOh3nbJ2rjEyxYHfIc4aNnZLdAATm8TvifzeApN6gXRyZv2D/sFH/tM
	SVclj8j9N+vfGVfQvou2jUhzKTWzwIuaT26B1z9SXgxIxSObhvKDQLlfsAZu8aZ3/BeDKk
	/FOHjjGE5yyIWvSd+KLqs9UEzFyFOvk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qgc+qo8K;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783608722;
	b=Kf82M18Fh1x1HVo130aHRHdFIVb75zmX/Pa7uccycPuU19WGE0mogfivryozJQGj7cYnjr
	0naJnEZ9NQxZBACltveL1Xc85c7ggZsauc/3NluKbSrPXXaaYFgd9ecIwhNOuN5GmxJQG6
	YmNEouv74+X1bUa/jezGipFzUkU2GYc=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-381d656c36eso197282a91.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 07:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783608721; x=1784213521; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TomD5kQp4QDVC9gWt3p58S/rBPFQXp4PWIaI11lLUvQ=;
        b=Qgc+qo8KV32K63iive22vwb6zhnnGbT2ct4PjvNcnRAV+j6Su4QMI8ehYsTF3t5PQD
         lIj5SNbJc4VRnRALZ1/NRBhQThocXxUEByHDOffwwvw1/7bI+kTDnbWb2O2kRMtwWM5K
         hZY7BCbBN58KERicSCnf0uRYa8NAtKLOLUcJKY4lQ6V/C+iFaofe1tKWXpm+R3KxTJs+
         PZ3xj76OFCXG4wdadkwB95uGj7lKIZTl/84JU1ElnLLjDxIUIxVKqUgiI9Vrkb60Wqds
         8Fkmz9N8yFL8sdlVkBsEoY4bYrdjOrRA8aKxmTKYneK+xqRjz+FEd8LdQFx0GAnNSUug
         AGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783608721; x=1784213521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TomD5kQp4QDVC9gWt3p58S/rBPFQXp4PWIaI11lLUvQ=;
        b=cosq9F1vZjDLPMVX5h0UtRACN0i3Y02qfN9/0276sCSrtkxlnRSThIaf4xd5Ff1775
         d3ka8vkbmz6lH08p9/OyP2pVBxe5MFmGCkqAF23d181YpDwQdzqCp0XrjZ6in/N9YXaB
         Lp6VBWn4uAji1L4fc88N0aVc8mFhnA0R1C7qAyy+yKXltFpCgRTXcUYERTX4sbfha2Sb
         Dh3lEozvhDhmVUnInutYOqCCU1F0WmxkrOiKcB7QacI0ojPWnq+fn2hPVgqIU9+yiLCP
         5dJg+h461lIscHhxWw7WpebtNLrt1yMBBeF8TuaeD0sHVhXR46w3qzvfNJ7df2m9lzp2
         5ilQ==
X-Forwarded-Encrypted: i=1; AHgh+RofArdiNhKFUVGNYHkuGcNxqEyUL45pxfvODflgYnlf5XxgDexHBgcLnAOQ7vFd4kRj3Gqo5BDavQ==@kvack.org
X-Gm-Message-State: AOJu0YzORz65rVTnec5C3+u0QSSaTdKUb26AIknLIF0weXwj1/pTTj8r
	R8h1spYP2SBSNqLQDQHeWSZ4dUuC8zVVPNTlGxI2fZeN0WJXtUlAqlgh/Hfyg4UJCec99bmT
X-Gm-Gg: AfdE7cmOHSoTejzqjFUvwnCHJOke0LfaE8JJYyKL/GgZyfhvnxp98OFfVq0d2TZQa04
	aijcgCQ4SCmbTzsq1B4izKU7NYVet2WV0itmhyUM7NNyA9XSSWfhCsE71DmANQP52SsbMKDahdO
	CFYbEdapCqpC0wsa4oTCpMmPD3+EZUpYSY6pxaxw3QOqGMId/9tjC6on51jQTk8JCmhiNxEIZ38
	k6YkdDl92cMoLHt6zIE8I7/HQFs8QLdRD0VNoi6suSdWn1Pq/B5h3PoOyJv30STsDWgCIsRt3VP
	9gE2KOuJ8NimZH5kSExuMIJX6Fhm6B2WBnCUlOUZkDd0kvWAPyFlLx9pAkAjMoEkmjUsJZ9rzun
	sk5jIv7obRaQSOBMAkohy1ywVEMxGFvf93ra3all5yqtkpETNaTUmeeDDIDJQP60tJQpv/H0Qfs
	cdzdM5VKL7KgKeQd4CUbg6nrsjvQJPWVRDxDrcoIsJ+MT+a4EGL3Kx1lB1FjQ5LyRirQ9KmekMZ
	77GLh8=
X-Received: by 2002:a17:90b:37cc:b0:381:6cf0:d5f5 with SMTP id 98e67ed59e1d1-38a2122afafmr3620933a91.5.1783608721148;
        Thu, 09 Jul 2026 07:52:01 -0700 (PDT)
Received: from debian.lan ([240e:391:ea3:6910:38e7:894b:82e3:a58b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a57dc5820sm1286917a91.10.2026.07.09.07.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 07:52:00 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Subject: [RFC PATCH v2 3/3] mm/vmscan: avoid pointless large folio splits without swap
Date: Thu,  9 Jul 2026 22:51:24 +0800
Message-ID: <20260709145124.764807-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
References: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5948CC000D
X-Stat-Signature: jaesh1uzpq3kq7p5ynmk8737ukphjqbc
X-HE-Tag: 1783608722-227441
X-HE-Meta: U2FsdGVkX18pWz2gKTsKmZKF18ukvPXO+2i+IZwETT/yc1IDG/45S2D6l0H5AFgpdKS8lzOKhd4lghY8E3Ke5525pis28Nkb434R2sr9pJct2SgHegBR0GFH0orO+NDlds5VylEZVbYg06mzAE3e7081TJMe+gzgtPhcOOJ7rIG73R4z52Po5nP5C2RP/86mZDK6GTZ4QSk3tyR7gdoU5SC9OuSdW5m8pRTfXvDHR8cBS5HdUPBKXD+EEkXSGy7UhkpanVfquRVn18CJJbibdy/FGFSNJkDPbMhp2Sa/36vf/P4VXhUtiXZJbydGGSUZsHyJIwbaRdwJsqlJ4kvWBICmuy+wqoi3ry/MO+aFS9fhtsm11xK0DtpvCkHHcA6JA2/xm7fedL0pWEiL/Pbe5otsudBcLYam3yaCR2Tml//Xg3L4N/48Y91/W2LsOSlCrKmfKOBXHw4LYysZZNE9BnJzIPzod8Cx1BBOFUPhwxBYW/H2VLeKQqw+PTHfGUWBvorfvJ5EYQBIx+YaXO7xmha1LxpWGgxOsAahQ2MPm9nOrNdIERLtjbdwZZC0BHfQEVKtSA7bbD75T+ovSmJYzrJ6kQY+hbULI8k3Ok1OT7aM6kyYPzRUFamVjaPEn7VkfBrV49Jd65XZ+zdzrnd3y/uHfendSCyMXaJ8KIPB5p4yQ2zf9Chle0EFcK8RMOJMR+2APfJvWIes1bt8r6ijUkCGMDNLA0Xv6de4cPS+UUjYTH3H6q0nYtS2pVPIOGQEWqT+4WH8ZSew/0D/o3l6H5HyRQvYv2F/UUWx1Wa7+F6xUoDT+GIC7MGUeKbz2Hq/TuTzu335dUzpUzzZKnK1yvyjFXqE74+NyZki3Gk0MrCJMT2JM1lPVw/RrFNhZJnwFqAB2kfxDLidDL/GVvW9gY2OJAjPd/akHOztXVlaPLwT57PJ+x9DFrA/BC4Kjsp0JzMWwELG/re9StYFheL
 WHOxCXQJ
 e7pB6d1FzeLjIP0jPxXxpRncVx0q++EOzJ53/5x2DRW3ahpybhv+jIS0liRqJuBgNM3pHJ9lgEeDOX96QOUZL/XDu/q4AO7qfGPfMTu0hIoxD3lLHMov4RPq6QXwUNG41IrZdnLdmUgkmSlWmZyttGxsqVLkO6uk2r0VHsNPcfQ13sH6tKOr6uPnZQOu8FZLKgCGi2n0Z9K2Xn9bAoZaf5YqEOWVr98ezXux7KY6u1pLPwwUHBEHhkqhfwBt1HqdaSfsZJ5DYElSu54VxQImIXGbqBRSAGZWAb+qVfZlNq0DUetfeUiyOkZHkcTiMDTDNxsJr10SK9l94SZXEmHnEFFYGOtkvbw8tCjcKNRGdHkRDjcv2Zm5UD9lNLLwBOisT5mdQlIU7pCw/ftB2EEZyRf0TB9T8hpbKXI2yAxT0db+8eQclgLc1rnzzc0NMd7mfvLcYkzrDBW1IaAb8iyUwm6j2tCssbY9+pVcW/Mg7ZGH5J9FEq3pS7xSVSQPSPNkUHmtP8xPilgxA3t4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

When swap is disabled, exhausted, or unavailable due to memcg swap
limits, splitting a large anonymous folio cannot make swapout progress.
The fallback only destroys the large folio and inflates split statistics.

Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
the folio might allow swapout of smaller pieces. For other allocation
failures, keep the existing activation path and avoid the split.

This preserves the split fallback for fragmented or partially available
swap, while avoiding it when there is no backing space for any part of the
folio.

Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..40340a88f78e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1260,6 +1260,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1278,10 +1280,11 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			ret = folio_alloc_swap(folio);
+			if (ret) {
 				int __maybe_unused order = folio_order(folio);
 
-				if (!folio_test_large(folio))
+				if (!folio_test_large(folio) || ret != -E2BIG)
 					goto activate_locked_split;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
-- 
2.47.3


