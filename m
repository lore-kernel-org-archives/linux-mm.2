Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D72C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5E36B00A9; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275EF6B00AA; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13DAC6B00AC; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C80056B00A9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C873A0106
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:30:25 +0000 (UTC)
X-FDA: 84994875210.14.02B0926
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 95E5B2000D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:30:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WY5RyfYE;
	spf=pass (imf13.hostedemail.com: domain of 3--pYaggKCI41su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3--pYaggKCI41su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPPMQZI6K5BD2JSD4w/twAcndg7pfdwRcZm6mUR6S/U=;
	b=Phqjqx6gkOcdeKLv3gZ48Aos03N0SrbCG29NRQHu/7m/5j7b5+dM3511vXIZWoEDVu5SmZ
	Ysef5A54XSGYT7J3zIvEALbx+HuJKKFE+qQuaFwcZ8eoXVDnmERfkIwZEnb1tOun1SQIF6
	NM18VZpc+matSOdww0Ss7FtOTcshhG4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WY5RyfYE;
	spf=pass (imf13.hostedemail.com: domain of 3--pYaggKCI41su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3--pYaggKCI41su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784212223;
	b=FekrARqIFNvRsGjFlMMIJoKjfWI9gdsRIony8suwbwf0RtWMHjxus3z/xrgYGdGQc1XTU7
	bB7AbL+PrUofmvlIOdS/uH9PtF3EP0hU0u9GS+FipgvfQUflEMqUMSdSMCrnZNNMVYSkY1
	PisyRYzFTieLCoKJ+VEZ7B/9LThej/0=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-698ae260973so10829825a12.2
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 07:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784212222; x=1784817022; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qPPMQZI6K5BD2JSD4w/twAcndg7pfdwRcZm6mUR6S/U=;
        b=WY5RyfYEzfFOhQ53/0goN/m638FCi0n8XOLqlrvMKyEtSGEysJPeQ9qN+f1K1CbICQ
         3ktyTdRxcbCMYR392IzQnpsOidK+qMonSvPejodAnjLiLbJrDM/tqA1B/Ruv/W5cusMM
         otZDOdophbfMt1IvAt+Fs5czsDoAAuCKUeIRMJQfdGj+SIK4h8qQjfNYD6WwC92aRGp5
         erQtbiGiooM3HsgrWsUlk7rvp61U9SKdqfjnccdofkzfT9+1UM3yvWKf7aickJg6Zn8Z
         r8krwBgVDaD2Glc8mhQxuuDUk4+OWV2rn6DMDCbDV9s7pQZNkNTQsLeF3wEfu/MW0ZWP
         a50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784212222; x=1784817022;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qPPMQZI6K5BD2JSD4w/twAcndg7pfdwRcZm6mUR6S/U=;
        b=C9+SJHVEwwLx1milTUMD8uOGjLy6uOW9imDbI8fqFsVEmzdiVuFRlUb1eOT5XTDzSc
         wLlEfON/xIROhopDSyKVJPhCiz9CvzIYJqnrvJvPAzEJo0zt8BNxRDO5ipxdka9U1YXv
         XD1tBkOiE42tAf1Zq6xHfVQ4DjVbPbT7NXUxTjtlu+6SvFYVuAFhpPvJiPnebCVe6wku
         ufUAtoEeTLZZd30+F0UQARUOMU4jmWkQGn3Kicjw79w+c1APCZDB2lEuNpLFdQt5Nhpx
         WSkdsAVOd1fI7cWzMTaf/Vu2BbqbOQelXppgTWe61vmyY9aiPzwO9eNI3xTtHptCY1iZ
         Gbkg==
X-Forwarded-Encrypted: i=1; AHgh+RohC4VFdvVJBLA72vWFpuf86ldX85Wj17T90/tEqxlf6o15x+Wsp//CXN2cbZq8qJNUHw3rNlwQzg==@kvack.org
X-Gm-Message-State: AOJu0Yy6A9mOmID/pXuCrUFlwSHollahGqLqp/eMwjCRgcIiFmWakqn0
	FM0e17auTxV1shzFg079Bce5uKGeCP3k6oZkvUUtUi5ND3XYog/ZI0E29o2YvmT671X83PlaLIA
	hLboybOZ8Xg8/Hg==
X-Received: from edl2-n2.prod.google.com ([2002:a05:6402:4242:20b0:698:c0d2:794d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3596:b0:69c:72e2:a3d9 with SMTP id 4fb4d7f45d1cf-69e199c3870mr3879463a12.21.1784212219530;
 Thu, 16 Jul 2026 07:30:19 -0700 (PDT)
Date: Thu, 16 Jul 2026 14:30:12 +0000
In-Reply-To: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
Mime-Version: 1.0
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260716-folio-alloc-cleanups-v1-3-5363b8e92d33@google.com>
Subject: [PATCH 3/3] mm: move __folio_alloc() to page_alloc.h
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95E5B2000D
X-Stat-Signature: n68zcasnkdutu7deqtbmftd6yaz7at77
X-HE-Tag: 1784212223-386229
X-HE-Meta: U2FsdGVkX1+w9lJ7xeu80ZAGzQXBpNXhzrVLEBn2DYYOoM1GLkdIezazpdg2ZRowuPa6hp9nh9uLueeyMA0QKYDn8GbLXwU2DxuZkF+jFA4VADX69W66pQQBUnqdUfvp+fx0UdgDHpDN2q6/lWB5wRtxUq8J8ESQY53s24HTGUubW5awVKF9jDkdjDThD1PYiTe3KtIMLgb2HTpggCuUb6CYWJl2rxjpcarDpzcaYSCYwn4yWXvqbWpk1GGhvaGRBIp/Fy9emcK70fvxDkldvc8fH5XOh4IhXx1KuuTWK7XyfEB5lL0do1ebK92mkG9pCKE8IeYj1JYeLP0ys6rI/j3ZqV8JBiViBV+9IGR0Bo7bytwrmL5hJZ0a/ldZKkIC4CUKyg7n4AAHV5xNVrXb2ov7GA45YqiDYdEHPZhAHjDtW/3wQYi74DWwJCO7pCx7S5QtTwbcSx30ND6ZSqF7lfd2ZiKvigkVp+Yx1PdO/N4Z1FuTWI7Ii3DpIjhec+R5cus0CryZPJo7AirEmPmjlMhl3tmP7tnYXRqa8YYVAF+7xpIImDDi1SQDgB1WYfmgkkaN0CXdTTjUXBAwKL8bwmDgk1xy+OEwGESnPTAFJPrk8iKu7j/LW9g5q2tRXkOE4J/KdxNeHjBF+yOBY8OBY+cJtY8+BTqHYDf34XS+8NU8/CYQpf/rBcrhvhRKZzNM46bhWk9B4vvcCw7J+OpZHcdpMwq+ACgHchewXnfs7fNuWou4FlliTyEwZRe98a0kgfYfUQmto3LCYLX7z90FTdzKUlVPFUwAvCiuchfmIAOJziRWNojTIik7dX83EjO2bLr34oEcUtvDA8YpAqBsq0xYxGcbFrury78qb0ODQYzcM6j7VnwIztEQVs1LL2q2RrkoOpyr6utbBw9BkbGA0+kF4jxc/SvEG1wzkbt9XpxOwDui/SYJ+7ozc+K6CVPdkVLXJpAtlpH8MQnYcWd
 ShgHbmiq
 va0+efPIFb3lUg5n8r3lJ2o1wrSitJUS6h49zhCCrx1auGgaGqQbq+UnccSo994CtMJZdIN68Wi8Rvx6VI/9o26Gem1nAHvTglL0Os7a8z1jMTKc2kNrdj+h6v2lCQWmiHVEQ8uDT9tVCGFevpGMUhu72WEP2aIg1AaZpYpjR/ufadgv7PjThbDffmS1LFhzDCwJ5jneocTjUXKJT9cMFepdXwFnGwbFjh0yAm9GPlqEs9xm/ZYuXJZBSf0A9JToIXETb6FkGYbsPFhCuqJnNRs8ilFeatgMj5tfw4ptH1plE9O6girtnSntashJNd1frM6hAfo59eD+A9gYSh5toktRG+waTILKt+/xMoG0Hq+502FkLvcshO2p7uT3jS77I79FLGTwjp23f29uGJ579YAueW3DTRZ20cGkrYfv7owROd7hMdBDHteEuAHArKRuQDv2EnKth0SikTy4j67nc0hVFkPITVU42ZLKUwH5xCUfL7IPa5n+VgyjsjbVkB/KiiVvPjHNfs78kTECipcHjy+J1sES9gO3rfJaxobw48GFrEOR9THHPWW6P7bzDD/rWLWpvP6be5dsb+w4GpzJSj4VKspbvktnc/YaMZcEFW2IuMAS0WbnDAtOBtmkjgC1CRumWW1nbxWKqgXp8Kq3sIGlUwPEneavx/4EzyKvmzprjlr+DN9NFZBhufQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is no longer used outside of mm so reduce the scope.

Ulterior motive for the move to mm/: A later patch will add an
alloc_flags arg here.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h | 4 ----
 mm/page_alloc.c     | 1 -
 mm/page_alloc.h     | 4 ++++
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 572605d84e30e..17c14b8ca007d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -203,10 +203,6 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
-#define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
-
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct page **page_array);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 86922270df157..ff8515e173e1e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5446,7 +5446,6 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 				    preferred_nid, nodemask, ALLOC_DEFAULT);
 	return page_rmappable_folio(page);
 }
-EXPORT_SYMBOL(__folio_alloc_noprof);
 
 struct folio *folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59d..409be31898ae7 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -258,6 +258,10 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_n
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
+struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+		nodemask_t *nodemask);
+#define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);

-- 
2.54.0


