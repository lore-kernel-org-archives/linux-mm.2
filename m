Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F4E8CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B809A6B00BE; Wed, 20 May 2026 18:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58256B00C0; Wed, 20 May 2026 18:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E5E6B00C1; Wed, 20 May 2026 18:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 954A76B00BE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67B731A03DF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:37 +0000 (UTC)
X-FDA: 84789223554.01.521C2A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E35D80003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tv1qTEPa;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fkdba+Ei5cbofNgiigEWYwJVG7QGPYteKxTN237/DT4=;
	b=IbWX/j8MjbazH7BvUlIYZUWENCNBB/Cyk7HchiV9pdkpfbFt29HFfrkjr4tv1rMp7/eVU7
	EKJdHAInotDjHT2Mp0fP9DCwojti4Z9YJLjjf8Q96HvR/vd+2Ho7om4BeR4HWf6bMVFM94
	1lmdgvQpyWYvju7LQ0pqSRJCWS+Qvqg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tv1qTEPa;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315755; a=rsa-sha256;
	cv=none;
	b=1OhS2VqSVbLVwOJWSL0Q+pKW6UVh+AU8L8VUAEAvybPBnaiUurIDPIWTr4wUMtMlLCPeV/
	Bnb6PkkXrMSgDxU6ssmhvnxNN73dWKaeQHtk9fdiTLTCC9ThUuXqmWAW+U3iVCLMdASQpk
	bhdYIjmnHgJyge/fJ8bqX0pZNz0XvCs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fkdba+Ei5cbofNgiigEWYwJVG7QGPYteKxTN237/DT4=;
	b=Tv1qTEPa7hIQ2mAfBgYWcJbCz1ysnfMOTCh9cyFrBkgM0sbv6f7rgTYF68ENNeUzo6uEef
	Ma01FiRGcOxXAKWX1elg+uRXn3MgI6qWxAon7bitQROc5IJq6/MrZ0ALcLJMqKyJp126ya
	syWxEEEiOGBsYJxomAosDkZW+27JwlM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-wmkxtc7-OIGPSo5dRoVhUA-1; Wed, 20 May 2026 18:22:33 -0400
X-MC-Unique: wmkxtc7-OIGPSo5dRoVhUA-1
X-Mimecast-MFC-AGG-ID: wmkxtc7-OIGPSo5dRoVhUA_1779315752
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48a589c7879so41307255e9.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315752; x=1779920552;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fkdba+Ei5cbofNgiigEWYwJVG7QGPYteKxTN237/DT4=;
        b=YX42Aje+p0RMNJAsn+3dL0/MRWLcmaSkWO5YMpg9VCzdgqZnmAmHW13CkJh64Xg0CI
         b5stUqR5ltnB4fROMwY8eTNcaS8DLhHmcoqtDFqbEMqFIuQqe1/GkdyJxDSyxnTXTmZU
         szCwuhF3+Ac+v4vBLF3tstwBYU39BYiCTlXV9Khy0ds7Jy+q6R7KSgVQEbe3OuO1d9nr
         z8mJ2dpnbgnthJQbFA3mLgJI1PYTZJBAV35TLxtOEiUCSvanrgph/iMIPTkwUGfUqLLG
         hG1iqrTgWjbwguzrSoSB1/TD6cjCnxcIHMftQ5cAeIuS3l5JhFQFJpnnhdcsyapv18yX
         rMsg==
X-Forwarded-Encrypted: i=1; AFNElJ8eHDdCHt+YvLTlVfpKx+ea0vows0uIY+is00kC/SmkIOzj7FJg2nH5NdrHZ2J65LWYccyRACsuCw==@kvack.org
X-Gm-Message-State: AOJu0Yw48KWKtxGyu+qgJ9yrQivphhr7cdCrIRCk7d15SOxCO26Nt5HV
	4Em42CE7P3wiHwUjk/toKpbMMYzNSKqjoQ5yHZFpuV0yX6KbgyIJCuXaFfEtJNAAxHA73whiVPa
	qYew8KXZzrmB0Z8AxLHd5TDxNW27Qy7lBdk0SFVGY5/lfNyhI1DOg
X-Gm-Gg: Acq92OGTmHUjYlcZ8SEzhY/DboJh2q6Wd7sjuMkRTXrA9YoOQ8vYiaA++z9Rn0lu2VB
	76Qz113OO1o491W/0SA1ZJlPuc7eLQd5s6XInvBv8R4XwQlV0XcDjX43p40TbnSGp5+xt/ksqB8
	yMAyBxB1WnzzMzcJn+mLZicpcLzDLgEkNgQHHIgiPN0oZoe889OG9tL1xs46m3rs+W0Mp+vXMjd
	vH2Bf6UbCZIRLezlLZC/r+SR2UV8AcL7wINYuAu7KeA8pydYl/NF/HDBkCga8si9RRCFCAMIY69
	C5ELdi9sabzHOSmer5M0DMoO9KG8VjtWwYfh+J2W76l6WUdDulj+/tfmeYhJ58Qn6h02MmcKCaq
	bw/fej9dfY8/NdH9vLzw20vDwikuNeiGhXL8/kgKeM1U=
X-Received: by 2002:a05:600c:6b12:b0:488:7d5b:125d with SMTP id 5b1f17b1804b1-49035f2e4f2mr2683665e9.7.1779315751933;
        Wed, 20 May 2026 15:22:31 -0700 (PDT)
X-Received: by 2002:a05:600c:6b12:b0:488:7d5b:125d with SMTP id 5b1f17b1804b1-49035f2e4f2mr2683135e9.7.1779315751494;
        Wed, 20 May 2026 15:22:31 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2ffdfsm53025915f8f.15.2026.05.20.15.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:31 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:26 -0400
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
Subject: [PATCH v8 23/37] mm: page_alloc: use aliasing checks instead of
 user_alloc_needs_zeroing
Message-ID: <51265bb3f8374b093b91b07628d418375faacb9f.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ka6Slq9Vn8o3YepzgCY9fQeBcDbZoETWr1SleH7Vuos_1779315752
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 2E35D80003
X-Stat-Signature: wuussuqw6yrbdpfgwap7ktsfou6tf1if
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779315755-50177
X-HE-Meta: U2FsdGVkX19xVtj5mHJaJn6vAMF7Qe/0oTRf0syuzNWOpqmPXJdYibyGeFmEKeP+7mm6YdsX0sDeDx8hF5HBSSSgM/7oklGBZdjq6VaVEJT4cfsci5DxI9S4N2BV8KeQN9/KZr3rD1S/cEywpWMJ8qChw0HFfdOS8E45sQ/o27RBCTefZg4rxQkC8bleTeKI6RTlhskgInh6ZH0NjAW3+9SjQUsMJ6GQ9UNG2BWF0WbnhvgRb9eE4cAKnV/youEv37JvmO8TBBLlkhIHIMUvlUf9kfSeYjISgHOm9iEFfJ485hoyQNFogN+wHAJnSxOvh8WJWqhTaU9ThfupSj+tNUQAhjQKQkH1Lz7E0eDy8RM7U5mncF9d3b4IVNTa5rK3m4Cbzi+HBqrdnFCONo/hWALmCWnpIxPUkvjCYd7QJJWVtYpad0/WiaCbww06hU3zYoynl1zGZadCwD9d5Ou2a63x1Zkq+zDD3CyD/rvGiNfnEc+oFQR4bS7pN9s4dX5UQ2et+3uX5nBdWLCyspHZxWqGk7+66N+wcZVDufaZquiHkbK/nEUUqNkXttMm4m9lTgQzupm0Jz33QQvbgCB9Msj84ajGNxZdVjUoaIVjc0UEjvrnJRR2ZjSwFKEnj3pJ5hSIjeWAjwn7QdnXOea/XibuAC86qZWfzydsGNUl1uusxHb3iOmOesvqBTipJw/QohgkorBpoB6wYXGxsGZSnXqaWXAzVOpu6816wDwCsSC8ml9mjzYb6stztdlKG0SVK+jVzYdoei9OhJ5fSTmlk5uh4ISnzwun4kf3FDwkidkSYSjiuBuLw7CwVfSqJbzW1wZtRPFFBYyQZdoz56MDsg0zM5gNXbWYBRiJP1xYwrPjkIUOxTkx3UhgtuIsVIfMggJfSHRZuJrQgNxrfrCYym4ywCA7V9canQD1D2VZVhzhDv203yv2F5aa8oGOcUGsH6zFK9NbqC5JRPvNfL+
 /vhSLlxD
 B81zxPkLZm9KmaiyUMMA7zT0PI+yOZdnHQ4oRd+zU0ZuBlXiI2xx2k5VTkcnhYmH1NS20fwKMgDqrTwzg4tBPdR5jme8Pyu2FI8640rCnC3V8PtFIqjT96+d0owN8jgzUkukqSq8it5q+apbeepgmWDdSACGk9i6PVhe5aSliYu57T/drLt1ceunOOct66yEWwk/imp1srRR1A+7gqBX75k1Wh5HAJ1xek3cAbqpeBALdCkLhyKhzkEf27JIZdLfI5MvDSeYgi3lWuTBmTaoqCdv8C5jkoCCTNetIaAPCB/ZVbeWAc51cNG87WlDHtI4dTqBOU8AhTad0SPOgo0oHFB96mq/t7Hb5AjC/ld593/J3Rr9m7l92LjA6Kr5p2S+FW4IXmutFPi7SIl0lEs7yWbN//1qitBq0EbNQYPpjtqVnhEMxARadW7nSQHzPo+jcYk+I
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5158f7e23d18..4cb7e779a6c5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1883,7 +1883,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
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


