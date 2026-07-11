Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC23C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 15:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E42F6B0005; Sat, 11 Jul 2026 11:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E686B0088; Sat, 11 Jul 2026 11:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534D76B008A; Sat, 11 Jul 2026 11:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3015D6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 11:14:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA87BA075F
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 15:14:45 +0000 (UTC)
X-FDA: 84976842930.19.76D0220
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EF9E7140008
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 15:14:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mMIBSAEC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783782884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+i9jhfHQV1VkWghZMio3vOJdKYg4IgTadReMoiZhHKI=;
	b=28Oj2VdpA6EmCiI10quyFo1HJgZaiAtErbZwJqWYErZl7lPz9MAR1X43JB+Bc8bxBv8j12
	2G5wxukw4Sm2zNTNxpn+g8iH3ZZn7mF3P6HeValwbk3H9Y5N6tVC542mhdv7JhRqf0VtTG
	WZuRp2rTCA6s5tzalqB1dp/r89xJcUY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mMIBSAEC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783782884;
	b=jAJe4wIPi3BC/3V7Fj3AF4fouXw4Cfl+rXH7hgZjNNwJ5RpI+cX2roedzU/K9h3pemIKbw
	pTi9IxlfyldHB1JdlAtrT3ViNwgddQgRasQLOrn24MMzrqRIWkuJfB8bDxOI6upaTa5PY6
	9utuSeSHX0R9MrmTFPHeGFHdEL2RGBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE76A4034E;
	Sat, 11 Jul 2026 15:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDD31F000E9;
	Sat, 11 Jul 2026 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783782882;
	bh=+i9jhfHQV1VkWghZMio3vOJdKYg4IgTadReMoiZhHKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mMIBSAECnhdy980IyBb6poTmknYhaPSfK+ERRvz+wMgwMhwfBBfGPp5OyPotggFer
	 44sbv97BGTlcIlDx1I6rhtltZ7E6DNeTIiK07sVyDjMrsDoF8s0yfAwRTsknH30Tnt
	 SZFL7ajAvWYKXpHgRCUgaZGuTbVyQS4bAihgZTW8i26DJiGdrFs9l/XP0rhPNxfosV
	 IHCM5oTlAifUgFaBvO+VX6JmSegFMXquTJ39DLYNt4u+946/8eQ888SPigdAX2oZAy
	 M/kypSWCYukINHsPihbEqHqtnHfYsjfQ7c1aoAfwx4w1YEoDCj3qI62hgwFw8ZvrYt
	 gsSYzcsaeMjcw==
Date: Sat, 11 Jul 2026 18:14:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Alexander Potapenko <glider@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Marco Elver <elver@google.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	kasan-dev@googlegroups.com, kexec@lists.infradead.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] mm: split out mm_init and memblock declarations
 from internal.h
Message-ID: <alJd1BLypyK9Mpaw@kernel.org>
References: <20260709-internal-h-v2-0-695631425968@kernel.org>
 <20260709-internal-h-v2-1-695631425968@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709-internal-h-v2-1-695631425968@kernel.org>
X-Stat-Signature: ytf3tad6yig1hsnmy5xbicgerzte8pym
X-Rspamd-Queue-Id: EF9E7140008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783782883-803502
X-HE-Meta: U2FsdGVkX18uOtjCrVbbwfMhuOLEpTmPa/6dshAwkt8ay4ImALCkGqzSbFeh9iIiJ6dWyGh3gBQDqHVL0XhvaYyG+qAWoh1wymQzUxOFsCfECW0wjblcrrphhdRAAxzYHiHJzxL4y3YczQEZpPYP6LEpOSefX1AknNney8fYzhbg17vd8EKnQ4fWsJmoywDGaG4p5HlVoxrZMofHPsQYIJvhocI6iARuhLQm+AKJPMqY+pM0FQYTnkoV+WdcoS/j7Tnb7IOc+nNePU7TxjS9sSVEzy11+vw+s9u11sosLnx4Jm2JcNQLpThDmj87seP9IG8+f5B9un86p1VOtP7njdRtALFrDI5L0Uh0AhVsMAorVu/EfKfwM+1VBjoar+A35aZ1fDqMzLZmrLw5yuKvIfc0R+Tcod43Z4pAxYj0w/gRGYA4F6cczgEW2lgq4eCBHpC6HB9VHF/Lzvi/N/jMtzESxSVV1xaHDed2FFwaZ6qGmGWxEnl3PfCfP2ygFXqIoA9HQEbSFQSfxkjjKYqXO7ecM+bCc3eSsPE8hd7nX3F/uY/SrDe/AVJTDmGaVVRGKW8i2xGvpjfrDLZf6gya+GJBToBjuYwx/xDR8ZAxCU9HXd6P+HMUfQyI5p1P8kRbjg4sCaLiUnoaq9LID6fst+ArzL+eLF1XQdKztH3wybChV+rKnUSygVmdy6s4svkuEgXn2oOZKxO/WXadMSN5ACLKHjZhzJtJH564hl0D0IysawOyIUC+QmOvkbdCchiJPvpHum2jgrvVnG+Lwc8Vplk+426NwP33HTrxYIS2wwGlZ8qIYNFliexLDSmzwzpCZS+a/oZkaTD/1/s/i2lZEcl7kYw3268BTfve/AKkN7eUm0CULRgcptdTBJzVL1iGOGnH47Wc0w4DLLClTAiXn6sWr7i1vV0744obOts2/rMAX3g5namjrTyB78BNbvxu24RmRC1mBt3aJbseeGs
 4l0yxBVv
 V9HdRK5FkRdFqtFJqMCt6LIO4QzSy1tgz+Voeah+z8xR65VlEaSDXsvxycb5jxg+BJqoRnA7beMs+X+ONGgfeWdtVEMxqvv7SWrO710FF8qNkCE/yNoRN/TGMMspGeIkyIK+Fq6wV1KSmyP3lVPxfGGyoOkiOlbGiGKCuLIoGKrrE57TrHHnWHmWyv+Wx7stm+VCJATtHzgyzs4QF8j3X2fPL2XekIPh6mYG6zBPfxF1aTsYGw8uGWBu88vS/McYGBmbrRedZtpTrSVoFB0ufj4WYyq7xmNGWBrTvBH8G26BvcxRWhx3V8nGNMPPcnU6vBTMwZuMUh80MJOU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 01:00:03PM +0300, Mike Rapoport (Microsoft) wrote:
> mm/internal.h becomes more and more bloated.
> 
> Move declarations for related to mm/mm_init.c and mm/memblock.c to a new
> mm/mm_init.h header.
> 
> No functional changes.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> ---
>  MAINTAINERS                        |   1 +
>  kernel/liveupdate/kexec_handover.c |   1 +
>  mm/cma.c                           |   1 +
>  mm/hugetlb.c                       |   1 +
>  mm/internal.h                      |  91 ----------------------------
>  mm/memblock.c                      |   1 +
>  mm/memory_hotplug.c                |   1 +
>  mm/mm_init.c                       |   1 +
>  mm/mm_init.h                       | 120 +++++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c                    |   1 +
>  mm/sparse-vmemmap.c                |   1 +
>  mm/sparse.c                        |   1 +
>  12 files changed, 130 insertions(+), 91 deletions(-)

As always I forgot to update the memblock tests :(

Andrew, can you please merge this as a fixup:

From 4724f0868aa5ab6bc1c054d0be1cca2067533c22 Mon Sep 17 00:00:00 2001
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 11 Jul 2026 18:11:13 +0300
Subject: [PATCH] memblock tests: split stubfs from internal.h to mm_init.h

Following the split of declarations from mm/internal.h to mm/mm_init.h
update memblock tests to match the kernel core, otherwise they fail to
build.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/memblock/internal.h | 20 --------------------
 tools/testing/memblock/mm_init.h  | 24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/memblock/mm_init.h

diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index b6b1d147fd75..4168e646af09 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -28,22 +28,6 @@ static inline struct page *virt_to_page(void *virt)
 	return virt;
 }
 
-void memblock_free_pages(unsigned long pfn, unsigned int order)
-{
-}
-
-static inline void accept_memory(phys_addr_t start, unsigned long size)
-{
-}
-
-unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
-void free_reserved_page(struct page *page);
-
-static inline bool deferred_pages_enabled(void)
-{
-	return false;
-}
-
 #define for_each_valid_pfn(pfn, start_pfn, end_pfn)			 \
 	for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
 
@@ -60,10 +44,6 @@ static inline bool __is_kernel(unsigned long addr)
 #define for_each_valid_pfn(pfn, start_pfn, end_pfn)                     \
        for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
 
-static inline void init_deferred_page(unsigned long pfn, int nid)
-{
-}
-
 #define __SetPageReserved(p)	((void)(p))
 
 #endif
diff --git a/tools/testing/memblock/mm_init.h b/tools/testing/memblock/mm_init.h
new file mode 100644
index 000000000000..95bc5f2e8ed8
--- /dev/null
+++ b/tools/testing/memblock/mm_init.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __MM_MM_INIT_H
+#define __MM_MM_INIT_H
+
+void memblock_free_pages(unsigned long pfn, unsigned int order)
+{
+}
+
+static inline void accept_memory(phys_addr_t start, unsigned long size)
+{
+}
+
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
+void free_reserved_page(struct page *page);
+
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
+
+static inline void init_deferred_page(unsigned long pfn, int nid)
+{
+}
+#endif /* __MM_MM_INIT_H */
-- 
2.53.0


-- 
Sincerely yours,
Mike.

