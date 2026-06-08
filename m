Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13F4CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209E76B00B4; Mon,  8 Jun 2026 04:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA296B00B6; Mon,  8 Jun 2026 04:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082036B00B7; Mon,  8 Jun 2026 04:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA5AE6B00B4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:38:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA0CD1A09D9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:14 +0000 (UTC)
X-FDA: 84856093308.19.52A8A94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5CAAD120003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H6jQGcYw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8mD++2dfZtiFiQOTpn1O7CzJ+9UexLHDFBwODnyZcw=;
	b=LUkLzH2fMMuKk/0F/Iw+JdENJMyYI4f8RLfKGNxX6nmsi+HnjqrDNu/wBgT1Iudw4EgE5F
	8QKm1nhC/jzzg7l8QHKsP9MFzKCVJx3Jy9E7it2a3tcdYSqpVuK9QcYPrTgvy7AOltrF61
	Co/j5XQJkMXpTt0MQB42NF5CA9IzqvU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H6jQGcYw;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907892;
	b=bIaPhvBFDLorRw0N63PMT5QNCMjsNndijOShwdT4FOwFl3+mRnNNT+Q5uauV2Zpc4HZhEA
	NHcLbiZ86EIJmZS/yODPOpB33oj03vOM92bFCUPO3fHH6R2jajw4RgwXMedhnJrtdnECmH
	rEJ8CezSEU6kkN8DO40geA9Iozt6zTY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k8mD++2dfZtiFiQOTpn1O7CzJ+9UexLHDFBwODnyZcw=;
	b=H6jQGcYweQ7a9R4u/r59bqYfSTajvwNk+KjkJL3wWc+P2wmSoodIMBzoZZYOU4bzR9SYks
	a9s5FujJ4eLaYiRrrwWPNnR3Nrq2k0YkAxLHNlErAtVWeI4aCw+BpHiQMGMxB3eGw9OLOn
	myYtOHkKqiUOYK2kuErugDxSL+hZKtc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-A-cqZE7vNxOMyes4vbOiHg-1; Mon, 08 Jun 2026 04:38:10 -0400
X-MC-Unique: A-cqZE7vNxOMyes4vbOiHg-1
X-Mimecast-MFC-AGG-ID: A-cqZE7vNxOMyes4vbOiHg_1780907889
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490a060eb84so26821955e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:38:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907889; x=1781512689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k8mD++2dfZtiFiQOTpn1O7CzJ+9UexLHDFBwODnyZcw=;
        b=HDvF7bxbMmNqHw2fNZ8exmjADZwU1Q+1ETBeiL/OzO96wdZalHzfdhfBRA+p8oi8X5
         ArLNdhx5+eWtLqO/v2je90q1QRCIu2Ob76WO1W0hRIoiuRcB2Hxj1dUYLt2jz5fXa/ku
         F55RfNFJ+tdnnTs4funxK4KMgf2o0tjJL+gl/xdvGzFU6atYETMeTpioswtCu/ANB/q7
         q9oQiMwD0k0QWzxRSNtaQEA7IYWeFR1Uk3rALY9WQP1rVzWsd06G41WuULNEkTXA4SYa
         aQ51H7z98MXuO2iERcCYLN7MsDO4mUzcMCL3Nz3ZtFDhWUAwlyGhI/t8xzNhZZFd4poJ
         Akxg==
X-Forwarded-Encrypted: i=1; AFNElJ9QNa2c/b4NDkX6AeBvtCiZVH6iTFMIrMwdvz6zz5W9snG4Vxrbu9KkkfJe+8OHZyZWncpMHNvmFA==@kvack.org
X-Gm-Message-State: AOJu0YzWfDcnr5OB4W2Pvq8nFc9KfBrxTDfqNrWfXasdejM4BvUCi1T4
	vMbMpa+6pBRmwmuLHRQhTiTMuB9JvOodOvKIN81A5Q0fIbjN1vQKNLPDqyLnSUYfhddFBR+VfLe
	yJ1fUw6MFcCpl5exnjFCQqvKgiKF5L2q6liUVWRrECPYzAj41yk/7
X-Gm-Gg: Acq92OGJQHkqOYGfLRsM+bhk/BBmsHibctonvbtGMc7kfeJOkvGzmVlqjbcn3YeWJdL
	rP3jPqnRmwMyeIYgx/yDWGKMEAN3Y0rLGP+lmSIshFdt/QxzUlGkUQoeeW3f5snZrXkjxEvJF8K
	CY1Q0ogftJABQp8Ewi9HJB06w9LvITMn8mTxhnvjqUqufXdwihsW1DzhwsSt6XznZAwrPhh911j
	PCI/wbvSurWu3K+WJiu858UGKuG/kiKy7++0Mwgxs2Y7bXd9lEjytkCSTes57n5ihnCdM+YEgjE
	4y8gAA0aFmKPLf6rwArwVFtZQqFCnIkTlYHbQqRwmqnaDKxj4KaW34LCpGV+/xTBpaQXOLVvjQ0
	J8u6gneXx2uqtwbmW+h5T4j8=
X-Received: by 2002:a05:600c:c491:b0:490:bb44:3f8b with SMTP id 5b1f17b1804b1-490c2605385mr243137025e9.17.1780907889122;
        Mon, 08 Jun 2026 01:38:09 -0700 (PDT)
X-Received: by 2002:a05:600c:c491:b0:490:bb44:3f8b with SMTP id 5b1f17b1804b1-490c2605385mr243136515e9.17.1780907888480;
        Mon, 08 Jun 2026 01:38:08 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc4082c3sm362037795e9.13.2026.06.08.01.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:38:07 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:38:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 18/37] mm: page_alloc: use aliasing checks instead of
 user_alloc_needs_zeroing
Message-ID: <d9b5fc983725665749024312f9ff5ede4f05e405.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NlFgdF4CE3R6Db7syXuw46M9Sl1X9cWbgzKw5h1O7M0_1780907889
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5CAAD120003
X-Stat-Signature: 4deq7xhtg1ptqe4s43g8r8kbwam5gxhp
X-Rspam-User: 
X-HE-Tag: 1780907892-420102
X-HE-Meta: U2FsdGVkX1/SOMtAtBF6DmQV/Nu64LzJCxfYh9UO2fVQcOjECHM9hZryte3U/LXgX+L1ajeSSFJqPOVLlzlc1S5phwzCPeYmK5W4Kmztf2rfMA7sMyzwlQzEqDt+AiZFr3N0VMWoHB+O6Qy4QgQXMxzOaIFeuvMzjULnplDhMWNLa2VP9+aD4QMqGgjFD/4VYjnnN3EgfjvdebvIdff8DTbJODBa7RGzt8OOBqBjHc2tnXXZos7IXSszQ6eIhSsAdz3HkZghTfN8CyyAJU+lpaJEbKaRS4+5lnyTT/j9jUCJv5gnysLGv2rf1f6fSgXeQBePwCKA5ThteKucN/a4RaZ2KpqtjyaYKZImy5/EoM/SuDkCIGqDbnl4wtNjdOmGxs5witKjcQk+HkmbMTA6uj1ha+5F299NCkxieLaNm9URSC4lgAIim+d7xSf1Olqyb4pvBYvdAcZsGK/PlDihinWS34fyWn17/wR60O+HaPne8yYbBGx7Lq4Td0+OVfFLVkNi9H2QGuuuMjUh6LOWQ4kdDF06sXm8ksezKxU9u5jGmKWfAzcQSLg04eS5Hwi3JrLSDf3klRe4oewoTMdVsda2X3BnzbY4FlZz+VrYuZk+gGJEQQMxWtNz9GiEIqKWf0rbO/tuV7CbaNZwpj0NPxoHoWRpkydspnUhBecsHMy0gtooS0QQw54wAekbCBy0Lu16OQNE1ICfXxYx7YpvVVpOdpGEI1H8ZRQ1dKx+v2KtZh4NlYEQvQT7atEhOyrYhQCkl8xXqg7pWG1xd+DGDyyRi0Ey6ElKeedSKxACSAMf4gic0atfuwqCaBjerxy0poR5GRFFXMQDAS4kGmjykcmv1q8bph0XEtR/1HRrOcH70RHaczH9s5a6XlsyTuP8PzEDEoeoMyoSYANt/ev+qtJlPUjnml1DFwHLYAKLjpxRDu3evmV0LCL7idUj6Bd5RkltPadCaoMlu97nbKJ
 z0g4WoNX
 ctegTPxqIIazaPwtrzOuJA8vXGWLbMmF5Wk4JA426HGlmq89bmIU+YNIFFoDzRBAk4TBFLnwe9HPDAtYAvAdNOtzjLvddlFvgZKQuhhNLwCYZNufZaOWhz+D9/hbQFJiFbCRNriZiVY1cynIfeL1X670xbXWv6s8ulMnf5u74h2tJwRszrFkNO6KnS4B4nwfIGXOFxPQnxqaNW/MoNsJMu/rkVJu86oelZ11U5HuqQxvwEyueeCHcCvsghr6275V4zAPn46O763cv7YFykcpHezKnsQJyLBO5ARSrQTW8CeMVPWXhzyXlPD/lyiycGhbIjVZw7sSh9IzQzW/tu23ie4aniUzzcki5wvY/X+RXxfBnooSH6WaxRofcMRbiADsgHpqRVvZ+zsY1y6XdqsfTKJHqblVHWLMysdj+cCgHi39YvQ/R5denOoPKAtug7Mnk+QH4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace user_alloc_needs_zeroing() with the direct aliasing checks
(cpu_dcache_is_aliasing() || cpu_icache_is_aliasing()) in the
post_alloc_hook aliasing guard.

user_alloc_needs_zeroing() includes a !init_on_alloc term that
means "allocator didn't zero this page."  But in this guard's
context (!zeroed && !init && __GFP_ZERO), we already know the page
is zero; init incorporates init_on_alloc via want_init_on_alloc().
The only question left is whether the cache architecture needs
the data re-zeroed through a congruent mapping, which is purely
cpu_dcache_is_aliasing() || cpu_icache_is_aliasing().

On non-aliasing architectures with init_on_free=true and
init_on_alloc=false, this avoids a redundant re-zero of an
already-zero page.

Note on PowerPC: PowerPC overrides clear_user_page to call
flush_dcache_page after clear_page, but on freshly allocated
pages PG_dcache_clean is already clear (cleared by
__free_pages_prepare), so flush_dcache_page is a no-op.
Skipping this here thus has no effect.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 45e824b1ec75..edfc83571985 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1880,7 +1880,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	 */
 	if (!zeroed && !init && (gfp_flags & __GFP_ZERO) &&
 	    user_addr != USER_ADDR_NONE &&
-	    user_alloc_needs_zeroing())
+	    (cpu_dcache_is_aliasing() || cpu_icache_is_aliasing()))
 		init = true;
 	/*
 	 * If memory is still not initialized, initialize it now.
-- 
MST


