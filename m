Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17114CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CEA46B00B2; Tue, 12 May 2026 17:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780016B00B4; Tue, 12 May 2026 17:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695586B00B5; Tue, 12 May 2026 17:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58B326B00B2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2223816067D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:33 +0000 (UTC)
X-FDA: 84760001466.11.8546AF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id D44794000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JA+5JBC5;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWQzvk6rjiRPyM3eAZla3ajwvkAoYuOsF+wH5y3nY6E=;
	b=pwZV7yviw21i/2zy0GzE/4ZUp/outLtG1lzNG0IykVR89OR2kq02ex+b7MYMmfbcm86OZJ
	Lhr9IkoBNla+AwRcENza35cZ5QpHXIZ7mv642WSYA9QZjjQr273hgAVtqe4XZuspB1O0OX
	hr6YCR8AQyZUVIpVoYqjerunObVn/9I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JA+5JBC5;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619990; a=rsa-sha256;
	cv=none;
	b=M/SoXyCRB5R/G96M1rYv0uqan0dKGVRurtmXEtOh7pJbKsBg+vNbYnunCyo1HaEdk2ivVZ
	uoJSa7gValRSsJGHK4/lIdoYGnEo2oLMHV4aT+ndbqVYZmI2HSaSYEXHN17v6oflyZhND/
	dT7t6ajAn86ZhxGaw6Mlh4BnOJFqM9E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kWQzvk6rjiRPyM3eAZla3ajwvkAoYuOsF+wH5y3nY6E=;
	b=JA+5JBC5+dKR5TMCQFh22a9t4g5KtsIyzKonDaqUUXQMrHP0mb51VR8f0irSrGNNW+XODs
	ATshtja4p3mRE1khbdlzfCdRenmdo50TjiqvcK2HWfKS9VOkFwsMqC9Qypkg4nQrwgDQWj
	lpMJmLAd7IlRkft3RicQcNZyZPS+irM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-yhh33NEnOfuxRgZ3wfEX3A-1; Tue, 12 May 2026 17:06:29 -0400
X-MC-Unique: yhh33NEnOfuxRgZ3wfEX3A-1
X-Mimecast-MFC-AGG-ID: yhh33NEnOfuxRgZ3wfEX3A_1778619988
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48d046fac74so35020605e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619988; x=1779224788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kWQzvk6rjiRPyM3eAZla3ajwvkAoYuOsF+wH5y3nY6E=;
        b=Ob4yRB7l/NKD6QlG6knWe4guUr3OT2MmsLy7ib2xj7MCWBMfs0VUIuZpfp7Yz0+SAZ
         Ue/ZRDkF6uwZELrwQR6x9i76KmoxNI3U3WnS4kDE7k/C5ym3OBjqDSwJmhthVFa1QYrE
         xJ878kmOOPdu5Ekjg9ZfQT6WAZQVCruw7BSpczkCZV+2H68Ods+lB25wbPQdM3R+g1CE
         obzy1XUJm1a83Aqi9jX97jzfy5Q3f+FsZDQNAVrKNHm1lT9RMPMnlZ/EiJkKdxD9Ezbm
         daqUUOuRM+pfcgN9c8ZBaq1ouFD3HsYsmDR4izvnzlWJbqxY/SIqRysoHoQKXly+zHLn
         GCXQ==
X-Forwarded-Encrypted: i=1; AFNElJ8T8VNYTh96G9v8t8woUKlbD/bupVyWzpKoRQM72AOEFrXhPfCF2AKpbBHjHhAk1/YRQAwhyxJ/rw==@kvack.org
X-Gm-Message-State: AOJu0YxkkxYYWZPskqqM7S8laHErkkLNZZyzoe5yNf9jsqYTYzyCjDqb
	ZFzSo6OPPEiIfwvo17ep7qW9/tr/PoyVj9o+m4GS+2c9v1cINQoqN2/XVbDTh9ewIcj56BGYp2S
	My+3S8aLI3y3ImOm4+a2Lrm1f5bwPU4lATxVWYU1MVvpKXSyOp1NK
X-Gm-Gg: Acq92OFwriyAjqYRnih3wq9ZREr0RYAlagabxwIYeMh3ixEp3Eu5F2XGjakyCliuR0O
	BApSilRRNBGZWOAAKjxMQXJ3nj1++1C3Y/YM0wOzzcJMCFaLUYu1+q3iNj3fd6Ky4WQ/TAv/QPL
	Rqe0LxHJYlbemPcFUXlOu0KvvuJO0jcs9iq+Ml2EjB+d8X1gsTG2CiJ6PqQ47oRvZu2r7YNQqRe
	5CtVQxKBuGbwLxor0kbhnUT04lUm1PIErzetDX3ObdfNBeIe4wAOaNCiIvtExSKowlxFxBFGjvp
	YIRUKSbKECeOhVZnch5vBX8TKWFG0rWGP5ZJ/z79861M1aXpoqi1PjQ2Elg7CudWtZgZkehRn9b
	4w7umuIsyTPwyCetiR/xSa0H2aP8zzikX2oUmiRaA
X-Received: by 2002:a05:600c:4fc9:b0:48a:7a10:4f47 with SMTP id 5b1f17b1804b1-48fc9a023a6mr5599135e9.3.1778619987586;
        Tue, 12 May 2026 14:06:27 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc9:b0:48a:7a10:4f47 with SMTP id 5b1f17b1804b1-48fc9a023a6mr5598765e9.3.1778619987004;
        Tue, 12 May 2026 14:06:27 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f3f5174sm40737105e9.5.2026.05.12.14.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:26 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:22 -0400
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
Subject: [PATCH v7 14/31] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <b74f5e68c5879e2a9d28df1af71ec3d798b74dc4.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BdK3Q2-ji1FLs8nQEAeYFgwfwEgXUxUscCW8gKqX0D4_1778619988
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: D44794000B
X-Rspamd-Server: rspam06
X-Stat-Signature: zjjbtqfn9seddk7p31c9xgn43mkh7mey
X-HE-Tag: 1778619990-577458
X-HE-Meta: U2FsdGVkX1/8H9WO//FAy8FlP/rAWi79E5RxVtQheIP2MuqjZWPQTltGc8F8bkVf6AckLWe0PpolyCMdkryFx6VbS5nQZxIk7TCD1erVIZPCz2UCgVAx1hF9zfjEKbDzGm1i8teWuk9oYf1HbFMzG8xOFfTToigz6nQUM9vKfPYrp7/d7EyWUm2DszNawl62ZM7J+JOh+UtOc9P5eFnhVls+VsUdyZyiBszkpQQHwA6Q0pMVr+NQyF6ZYzC4hTPqrwYInalDdNT60v0jX6UAonU8wlvFp4cmg+QNzT+TLACvdsdyAL+eFwDFsnolZjoPgNQv9odxMw0QD4aQCB60GcVURmX2ks4Si12aGq8BdBJnnsRqJXUBHIlEsv/RbVt+KryWpJPmG4vys+PmsUjRZpKUoDGXKd+T6PU5vUO7Xj44duOVZE1llvuQ2CIo7qF/vQy6BeCQYcQcfxge8/KGFcK53aS7mT1KHXKAZabi18KPNNEI5kH4fJCLtJwB4NvEq3HB4+CSiwLWFiU3KwBswWp23mLBmf1hZuMTmPmlLkFHMn9n+FB7GHvJ71U3rp/bl3WXzFBWyRuqu/NEEMgnsuX4+e8s6xjU9g81JfOpxdB/GPef5k8P7JH6I0cpZSGSQqm+KPHicfMKRWEttxWcEJe8v3BE7pRsGifcKk4XiwGaj2i8/F7UeNrEqcKqtK7/HOyTjWXjVWb808GZiR/C7oe9Ub/JYWwz03Q4PK32UYXUYhbFXqSsHUaeV0Qj/47ydHtKjUkgVxScA18ufzwbvVwauXYIeuPs9n5878XdYsdsuSU98XTGT+/YdCOc9V90SHXShH9Fl9jLjYC/pcSgUNdP05EpcrBMn952hy835O28rUW2569mBfgpwvHfViixJlsBDvBMNw9YOmV9hC+M4DxSKngQGVqiIh27hHbcCZiXqvon47upOukTV1XZnXACY7YWSDa4Q5KLFInHUyP
 jiwOcvfA
 u4UWbP/PCTcBCJ0tEj/V1UHYXqk7/31n8uWnn4UHEuua8ftXGab2+GnygdY1SzRNc/JuAORgzPWxgqf7kpj2rMXc8EaJ6jT/pre0oub4+OHvQvPvDdAWxsqG4DQewpUcPBlsqN09tIcdL73dwui6Cz+GnQSXC14d/7ZyAyG7RfSzbr0ktFX8/Nq4Ww0FsJST+caGElo4AWB/7BuUMVXzNWbid0O5oG4oSlzfW70rJmX6yfApDAFXtDe+VyMBUs/DV2LG1zVSjartTiss/fTZ9b+NP4mp+L12e0wN3Ew/OxTVTeiex5LriZK8jkVtxu9Ha+LVadqUwxLMqmg6GYM9oRz0wewk/0HNcpONi0xzI3v8opD4CbEZk3YrgcZTayF+S7wLn/czsQHYd4XqsUW11wec2ZQTZSPT6MJc225zIWGprwqg4+d5tcmSlKl7xjNG3D2g4qoCMU3xuwXZshadDzHHTig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
at the callsite. post_alloc_hook uses the fault address passed
through vma_alloc_folio for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 mm/memory.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 74523bc00d8a..f3f1bc66366d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5249,7 +5249,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 		goto fallback;
 
 	/* Try allocating the highest of the remaining orders. */
-	gfp = vma_thp_gfp_mask(vma);
+	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	while (orders) {
 		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
@@ -5259,15 +5259,6 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
 next:
-- 
MST


