Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5ADCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106916B00B6; Mon, 11 May 2026 04:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE436B00B8; Mon, 11 May 2026 04:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36706B00B9; Mon, 11 May 2026 04:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E44D56B00B6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8550D140606
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:34 +0000 (UTC)
X-FDA: 84754528068.11.88E24C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D3F22000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DKm3U3g4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
	b=TOAKblHnmGsLccrYtPbQoobIoRgjbha7ruKZswikBxpS2mdTPIBwlwqzvaSU7+0iXgMpUj
	Eg5AGaVkWn3jZTowRRMHBYlSjJOWyjUeO8+22YNFsT66qzrTkZw9yustSydBE77LDYsSZJ
	ndu1yn4vtprAPNXOb0j+sYqmjuAacN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489672; a=rsa-sha256;
	cv=none;
	b=VqNSEKcG1MhewzofA/1TdKOlC1UvLQfA3qeOKM7oUaFBLQmMgu5TvEoyV/Xr6TY87HjR2G
	cPH4EIipQHhsSRGFcXKtfsE0mfxz/BqxhR+KsD8C8icoSetfOnKASyCagQKiai0kz7RIX+
	14cNFQNtDOcA9xI/luvHiNSBHK0U6Jc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DKm3U3g4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
	b=DKm3U3g4cOzdPmFnYpPO85gPh+4r2uQr+xE9prnGY1epa88LFjzkd4ruf+TWrRv0w9ARIi
	Q3h1YuUUf5i8PNf3CAld/FBnI8cKHn3n6JqhXTX8g8t6UN+UpjM9FFvEAjjslP3C9ckeQm
	PZRtGGif/jy9HRyiKtVD4ALIAiIfil0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-hND-Oq7pNvKDdswtPnJTsQ-1; Mon, 11 May 2026 04:54:30 -0400
X-MC-Unique: hND-Oq7pNvKDdswtPnJTsQ-1
X-Mimecast-MFC-AGG-ID: hND-Oq7pNvKDdswtPnJTsQ_1778489669
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48e6af7a9cdso16387785e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489669; x=1779094469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
        b=DU3kE0LzXJwCdP9BlCjhCHV4FKoARHRwHLrbUkEurKJ6ZESTxCqgcHKzXBlUmfmkbP
         D8ElgOlQqsV8DcoR4ZB6jw9uUSYjhb7wvzcfOhQyKFsR8KH7sUyrUrZokpJEhbaHfy8J
         vIFOonP6bXWQp0VWH64NDYMzQhikfVFfu3FEaRx6XjMlLWs+Kk4E1/8T62QXXfYgFqaE
         72HIlUonHuNKZSn3HYDT9Y8Aj6tyP93bdQ2vEaHJQQkFvF9m6tXqRZkhD7PhJnYLLLu8
         yJ01nG1kb4m/ixzmI+kVhKmWg9qHzmfAD9YszMU9RXb5oiNNR6L8D7LyhUoSkBngtFCB
         rwow==
X-Forwarded-Encrypted: i=1; AFNElJ9QS/P+ZsH7otRJiHFz4RzGF+TbDn0B0ENrqLCpUSTYStqtq+B4fZbcDHU5qJkPiOMO0LAAKNHWhg==@kvack.org
X-Gm-Message-State: AOJu0YzXQTls2AMeX8QlrsMcsnt1RMPgq3Kr/XVa/Kv/+vaFbHZWh63A
	CbDrzaqvuEyIXyUX5NwW3lylIYb/YvLqw4MPxWD4VJ26KgzLjO/JEJpJrJjUIJ0nNivAdO3dWtM
	ksT+TvKBw//CLBOxNltr7fC0Vm+r8mB8/5OBkVPf4oBat/2a7e2jq
X-Gm-Gg: Acq92OHwpv1HJSE9j2mztNJ6tUXtPcQcLTUeifN+4Yj5xTWWLecuba5ixYs0905EebO
	E9WKX8OBZbKmLAo6TB65WCpRIpUunudkzILzgtdIZvn8JtmqtirxzQ+oXLtX/oWwvSxd8O98fiH
	GAJk5Fy/vsqk5BVAbykZ86Ct7fCc9E4KtBo064J9RHUZ+EmRdQIr/YPTH1EmYAmbc1aPmyizoSe
	ZSLuzG46vteQOzI6jWh+40SDbx+ekR+QDKsZoJfVyFLxO7MMoRVgNoZVumNIz4HXG1MN10eThRZ
	GqmXdaM3oMWmvEooByVjhq/ZE7j0Hni1/hkPxggOchfbPDb1PqqvSHwwwbr98iQS9Bim8b/nHDy
	ZADn3zal/eMzOY1tancBQEJs6Ua3kGxv6RqqFmJ6/
X-Received: by 2002:a05:600c:8b57:b0:48e:75fd:9f9e with SMTP id 5b1f17b1804b1-48e75fda826mr127047515e9.20.1778489669165;
        Mon, 11 May 2026 01:54:29 -0700 (PDT)
X-Received: by 2002:a05:600c:8b57:b0:48e:75fd:9f9e with SMTP id 5b1f17b1804b1-48e75fda826mr127046835e9.20.1778489668599;
        Mon, 11 May 2026 01:54:28 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d8d30dbsm91516415e9.1.2026.05.11.01.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:28 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:23 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH v6 13/30] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <c8768c7c2a4965b5e2dd78680c936b82606cc034.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: seSd9iDXLSnGM0zSUzryisESTgcbQ-3NUFhzSAsMN4U_1778489669
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D3F22000D
X-Stat-Signature: do69rz9tresmiutomwk7gqmgg74kmjfs
X-Rspam-User: 
X-HE-Tag: 1778489672-416907
X-HE-Meta: U2FsdGVkX18Dn1y5XmGHdWMGhcnrD6fT7wyUyrsEruty7lyIMkuwkQAixe2xIYGa+FGAIL9W5A8WRoKbflON3OiPRvYAiRsUwGbU18+QVjqjwpTrlO5K8TaOImSfUX/bRYabptldzLdqvzn8g66KNMNkEzKQRTQ2MKe5NxlmIGZgdYMPyCOxbgLDvr1pkvxSrVG7SAy6HYeMpwu5ckJ/Ee3hdtzyVrBQ3qvAexG5O5GTGEu2fODZ39RdnPvt6bLoniUNSDXgbNaInnI7/v+sMHIBYlx8CVfoTc5TsN7xb0nLW3cOdDbjEYfCroFblL39O+Xwha56m6EUmUyqz4DdNPB86FcsV79yRJBX/G8x4M/4yfrNCh7wQu7aQWNO8R0nfEH/+S2GgupELsz7N12yQMl0VZuHh+tZq1XYCN1JoEFD/FXO1/9aSPUd6B8dpB51i7NyzGzNSFPMS8OAD0/0YuMu7Heh4CPAX2cMfJAh735LzXLNVQM1L0+0olNC8Pmuu3LVUyUjmiLMHyeUayG7214hr/0cvDWHsPOolVr2wOvtYJxLLM2F8boeVXgNNinNe3MYJhO6VZ0FMJYk6lwfZL+m7X0W1OHqFv7aAB33hu5Baezu25kMG823ZNlCGKdiXgDnFXFhH4SpIdA4PQicku8GS+m47CwWqe9To3yDymQixkX7mduRUkk0GOPBRZ00qwH0KzHJ3vrVt3hZS74CfghWg9yni+FZx8kB4tSgXgjtzejdKhEN5j/v1bdzHz1fgPwF2EALBahepIUIJpWuMUFgXNI3CDOWRJ09nBhtsXAaoL6W70kQoBCurJfJUZmPuKG3VwbyNMC2ksrM4Ens4dHTUalY1/CijW78TYSGI8OLduYTHTy/TisxFsO7dJjjnJrITH+y9t0TDMRrKE8apNCz062zoTR5TmQ+CxZtwXnNijBa5OHabx041tzRa0geShU7YOTgiPFElj7jbIg
 9XmrEqs3
 Z90zR7TK6W43fFkK61+Y4oQkltBmuqXW9FzlLin5m6ffYlK7ITMVZQjGZDVVnyjlMIcsTqMa9Lnw0SYBh2CNyfou0nkznVyepNh0UdM00zNx9BQ9LSYyZljn1onGcdwB1NWsag0wVwpee3HqXrAArIyYi+MxfkNA/GxHfNJZ+VGkBXtW0NxuYy6UuGu270QpzqxEsJZBxT/Pkbd2kaCrqnT2JK6jew22ZjQ7yCc2JzU42D54mwsp9kdSfaIbZYq1DKrBVBRnSyQ0e7XTkX+GIJlzGF1FJDvfraEhp2u/jI7PPkKHyxfvzW2xDkv03FGBT4m8Qnasotx4yKq6o3j/ys54hxQwX3FLXpc+nO+mrfZAf4uCPnWm2pze9q5HqddfylrQWj+qKfE5qKkddmo/2d0Wb+cMkeTcI7LY13C7BDSAr29Ldovye9wER1MPE5zLRQ5Rz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite. post_alloc_hook uses the fault address
passed through vma_alloc_folio for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d689e6491ddb..9845c920c29c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1333,7 +1333,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1356,14 +1356,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
-- 
MST


