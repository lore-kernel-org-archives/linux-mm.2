Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD8D7CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3278C6B008A; Mon, 11 May 2026 04:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B05A6B008C; Mon, 11 May 2026 04:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C68C6B0092; Mon, 11 May 2026 04:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF076B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD3408D64D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:03 +0000 (UTC)
X-FDA: 84754524246.16.83CEB83
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7719440002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GxdP5az9;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tuOG0LtkLDTSKD1+Re+ayATul75v5uc/Qit0qQeEcQ=;
	b=bqF/93FP4OmskxpANBu8EjFtYdFeOIQe/qudjCsSLGqK8WVqoNLJX/SDfvmqJFQvgUf3mh
	SPzJQA/CfG77kW71f/6DNIxGeRr/TyPLev2PLNq0msQWv5VOE5aoMplNFd+CAR8uLUVbQM
	NoyR/rASWnAq/hPSp/IEiC4lDXEu8B4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GxdP5az9;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489581; a=rsa-sha256;
	cv=none;
	b=JEC/zTBqvoXBrOrfKMUKg1eX3LbeQTtBgPILj77OmQq6YyFEpQmMCx3ocJW52GFmnK2+J/
	uekqUw3n9c2Mk/q5SLsXfWHA7iaNEa4WwOFJai3e94G3Qd373sa3YbYGLPLmM5jGNhbTdT
	wpnNe3nJofT8501jpmskD4fuEB/fTAA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9tuOG0LtkLDTSKD1+Re+ayATul75v5uc/Qit0qQeEcQ=;
	b=GxdP5az9qfZZnPnnwuU2AxbJLm946L8YbrVa99D7HLEYhSN6V9GKdrSt/zlIdpk2zy9Gug
	OSKC9ixvGQnOl34atA7yPYvzYirCehtZXZ9/I1WJkN9gGD+nZB1AzJRXovnUOwJAhRj1us
	Uqc9s12MDLLhFI+z1MNPm39saM1E/Nc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-iYlbrUnTMb-EIlQz6GI6IQ-1; Mon, 11 May 2026 04:52:59 -0400
X-MC-Unique: iYlbrUnTMb-EIlQz6GI6IQ-1
X-Mimecast-MFC-AGG-ID: iYlbrUnTMb-EIlQz6GI6IQ_1778489578
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-441243ba35fso3385211f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489578; x=1779094378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9tuOG0LtkLDTSKD1+Re+ayATul75v5uc/Qit0qQeEcQ=;
        b=m9sfZ95Ua+DoJcKC/9OJjBiYcEslMeWwuKKCRXf9qaIfK7CkMLnjlCKexn09qQv3Hl
         V6f2M0g0KTL+R3FH1V6t6ZcoP4xg2KTjbdT4hrnHRnI+J5SOtbIrAdo8phH5aLNE9h0m
         2C1poTQnr5kGwVUowsDAZbjSQxKjQqQ7nunHxN5GzSBMPuI2sUwj7/iKtn+G8f6W9rMX
         Z6ImccfsInQhfkkvcZ2+tR3RM7sWBd9jCZa1oTV9kL6yyHB/K11Fi/sgTUlMPNna/bmq
         8W/C859Kr0i3WKQUiiZI4CLV3aJvmKUylreFVe5qK8E5cQEVAVadiN2KpT/PnzBKMi1s
         w2fA==
X-Forwarded-Encrypted: i=1; AFNElJ/B5N4r/TfDtmQkA5D95ffM8a8EeRdbYEtlSbnicL4pLA37C+w+j1PVbJzFBYbI2/XVgURY+jjYZA==@kvack.org
X-Gm-Message-State: AOJu0YwLW3Qvq1uUyT2Le83VgGnAEVouELD10uVVsJYF9F/zQGQHdNZG
	54dRm3U8r81EVMFc6/fnDwS5JXkqeyeblWDfDN64O8UbW1AxjGbuzoNfPkfyXxcNdhKxyEeICxr
	Q7+qC2C2AGXlifQjVf/OAH6qAbzAIYwZGcBXBldmohOn8voeLUxuc
X-Gm-Gg: Acq92OFskNx9EeQb1hnLv1Dwy0H+Ef/8YJlMs7N8J5PQh/kzcKTKnZ6Pzbr39J65rzC
	9LCtnq83Hiqw8+yOENBtQ17nZGtncjx+EU/2oul1y7BuWMPeUnM2kYuQ78xyxlSkplUElMSqRo8
	PZLbsf0XY/eo/QE2S3J78gbE+N+Ze2ZItk3KEA+LnVoYteYXBy45N4l4CSGdA8JPKheU8DfTQfy
	i76X0zgVtNxC6gssfel+JpB3604qf7xO28vYENB9I2WsFTpzqoE6SmJcApRFyu2nGiM99mj9Zns
	y30JWTVHYlTDkMR8qtMW6ZMc0FwiMdqB8HXmtFzBxBhTx8nbqzcFoaoq4m/AhBc0SJbIWlQqIa2
	UOzhxw5TWfSGeepHxaHzWMnqPlUJfUQZVfwiv68+lZ7g3WG7yMe4=
X-Received: by 2002:a05:600c:6299:b0:489:1f97:6b1d with SMTP id 5b1f17b1804b1-48e706edd0dmr143157485e9.28.1778489578210;
        Mon, 11 May 2026 01:52:58 -0700 (PDT)
X-Received: by 2002:a05:600c:6299:b0:489:1f97:6b1d with SMTP id 5b1f17b1804b1-48e706edd0dmr143156535e9.28.1778489577648;
        Mon, 11 May 2026 01:52:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e80ca2666sm90929945e9.10.2026.05.11.01.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:52:57 -0700 (PDT)
Date: Mon, 11 May 2026 04:52:52 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v6 02/30] mm: mempolicy: fix interleave index for unaligned
 VMA start
Message-ID: <41bd50fdaae943e1a79215ea4000322e74a823be.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8csXo4AV8ccNM3sk1MNhQgVsBpzuEAkHF2uOovaTjLU_1778489578
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ss61d9f8j4knm47twx3k3xxxdmwnpooy
X-Rspamd-Queue-Id: 7719440002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778489581-750260
X-HE-Meta: U2FsdGVkX18lnyXHlioJo3IV1V2tq6qb8Ei7M36OzeEbddqxUtMgfBXOvnceL3ntCUu4lpZ1j7YGXeNo1v2kCpaINMb0nuGM8ktdRcPeytKEWUnW00RFQcxVx7A4L4/ssOP5HIp3YkzrbX3LxSPz4A3YjABfx31+5dxol+PcVkMCzU+5E5CgEyQ6rNy9izLT4TavAavsVwasHy1ZVRhDXSVr+dm/7N8OwV3o8/8w4rGHxGDvj5HNPES4D3VVYO2pweJJhSgQjIDq1dnWqEzDBc297H2Jo79LquJ/dAMr7AzETwtdegtaArZcwGS/fOUsZ9dyW//KBnRKKfYIR1zlbtbxnzX6dDV/8LW6IvYejDaMn8yjtL8jWKcNv+3VHKvpNZVCkv2AXdkWNS5S8f4xhWiVD7iJYfAjE8xVgoA1QvkQrr4o8vfdcyvsw0eQWtFJl97eOhVSvlSQUGeObkoXYGiL11L0c8wISEYriWUKpyXTAEVQBV+wG6F6e4FmEzKMw2+Bjt2w/JnyaWdtvPY5vRhi0jUSM3CaUJdhEtX5oNCrWOppb5Bv2KVSlN5o56Pd+OiiHxVAA1qRmORDZAhSmyCzc41a2Oukf6NEDfgG77cZdSJBTQIlxL78vITdVfkTecWGMAIEQzTf/nY+6wIQrDYmuGQg1AJPGXTij8EdDJJfeU/O8SrzGUKkd7O5Hp1hSCO4ikb8h3qlNNwgqG/Lj7neTue9t0rHUNP6YDW5g6LJsb7wCY1Zd9XwOUHO8hIQzXHS6KuZNnPl1zf2SCHXbYTFCqQlryZIpGoU434tUwOJGo6JtF9XfSrlnvJbPdZAOyFceiFQN2jwlcIP1QFCnzFB3XxYuJvtX1QlKqJ6BIZwwwwEFLIZ9XlcNl38fbJoPg59sito1df6iBwS3AA3CBMjaJ2Le5xoahNmx7Q3n35upU7YYv1xIzezZfRyMcHFgSpGWQHRJhYO0zLi4d5
 G4mgSW1y
 2nzfygEHn+1SOSmGMBxFkVkeMbeYFiyrmLLIuJgjsP2s0oPyr+wX+4gCWtSxNNhaoG2JshVfU6OTVXX1GHll2QAHj7iZaIDl9a8XM/pgS4QXAex65C96T09juaelNX6uM3Rt+Nso5v7Kt0+1o/nrofsK7T4S4pII3A48gb+32zRN5g7h5+UL686pVzQAKkm/sfAMMgik7MwLWmrbNau03TARpQH+T9Fdfio3hZ7oj8yd13g9ev18JX0WSzqbF+YTBne9a/x1idRtgexrf2cUQsRjkS/X1Xl5ijJ1RU2QoMWbHNFJWMRTCaI50KwRMTuvWSfQn+8TPycgbj8R74pXCjjLqK4cp6q0qWtQtyDjuaUdEUW0oqHP/a4aEfpAT4yIQ1xegs836BuUGdU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The NUMA interleave index formula (addr - vm_start) >> shift
gives wrong results when vm_start is not aligned to the folio
size: the subtraction before the shift allows low bits to
affect the result via borrows.

Use (addr >> shift) - (vm_start >> shift) instead, which
independently aligns both values before computing the
difference.

No functional change for current callers: the fix only affects
NUMA interleave and weighted-interleave policies. Current
large-order callers either pre-align the address
(vma_alloc_anon_folio_pmd) or do not use NUMA interleave
(drm_pagemap). All other callers use order 0 where the old
and new formulas are equivalent. However subsequent patches
in this series add large-order callers that pass unaligned
fault addresses, making this fix necessary.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6832cc68120f..39e556e3d263 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2049,7 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 	if (pol->mode == MPOL_INTERLEAVE ||
 	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
 		*ilx += vma->vm_pgoff >> order;
-		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
+		*ilx += (addr >> (PAGE_SHIFT + order)) -
+			(vma->vm_start >> (PAGE_SHIFT + order));
 	}
 	return pol;
 }
-- 
MST


