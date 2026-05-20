Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A998CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75EEF6B008C; Wed, 20 May 2026 18:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C8B6B0092; Wed, 20 May 2026 18:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6260F6B0095; Wed, 20 May 2026 18:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE556B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:20:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F22F31C0301
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:33 +0000 (UTC)
X-FDA: 84789218346.07.B6AE3FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C020A120006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RMl4EW7P;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=piBMwx0YNR4u+eZF7dD5f/57awj2BSKfWqeLUqtqejA=;
	b=qTxRQ5+WsrLDEkgcIOcuMtg1RcGSOvl5FlXOsg+L6ILGuzuJamddvXntMNN/BtnYzDB6td
	o9EJG/TpJGBHW6sG/jb/2m6BjZOS2XnLgnsdoS55/T5+C/pCkZnes0ud0u0oy54r2MZSSv
	zeacXokNIPj8xOaiPZuZM51SaZgbncU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315631; a=rsa-sha256;
	cv=none;
	b=HPpU2JDREqItnv2JG0rWA7RmpVUztQfAhLF16wyBk263ghOFuHif8YC1l3W5nFkhu97TT/
	Ln3Aznv2LM4+X2z+h2OWrjV38iTV22rlkqeozhkySfVssvTmDFLvPRd3Vfrf/bnElp/b5k
	Vm/psAWFQF9iwBfwVDCn4fO0kZPxxE4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RMl4EW7P;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=piBMwx0YNR4u+eZF7dD5f/57awj2BSKfWqeLUqtqejA=;
	b=RMl4EW7P/hWim6d3NKsc5whpb77ywJ5Qlv57sU+BM+Gh9aI8O4aXqzdyEJ0nEoXDxxY/4q
	R4f65kjV1S0B6Dve0ty34GPOZzP+OPcqK9YKpjplqtlDaZJ2Rh34OwFSJuscLOVjk9dju1
	fRhPopYjqovVoz/n6F8gCw2YfYNAOxU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-koF9bUxkO1qQx9NuNgknEw-1; Wed, 20 May 2026 18:20:20 -0400
X-MC-Unique: koF9bUxkO1qQx9NuNgknEw-1
X-Mimecast-MFC-AGG-ID: koF9bUxkO1qQx9NuNgknEw_1779315619
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48e79219704so37858635e9.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315619; x=1779920419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=piBMwx0YNR4u+eZF7dD5f/57awj2BSKfWqeLUqtqejA=;
        b=J7893Ur9BdLSIEz7lz3VXAsBRze0TgKtuY5OA7Fk9k0RKok2r0tSZnniCfc22Vj4Sv
         y5Ebktoh++Om8z5svZUrj8IsEBGCEP8S7lJ/SfXG6CJdZS9GCrjWDatvH6wgU/QRjWDF
         uoSUsAlIO2eCJ25yj2d6E67gnjrX14hVDn5a4WuRFIxlpLFKum0bIkOYXcLNIoHD9kQU
         GIzh/r287JUZAYDUWUdHWhmVlZ+YUk0hz33QFpdSMNW3/Q5egT67FctFI6jOymN8JcOI
         Y7uUfCT72RPmFIgkJa/9XjKZ9fQnznBDT/LGkH/duvRF7jEZLs+FaEQ3LxMATvkP0KH2
         Q80w==
X-Forwarded-Encrypted: i=1; AFNElJ9bEcq7tRzWR36SbgjIaAmwWK/5n1g90aXXuSfTzLBmuwUR8iZtnm0CJbNvea34beFKbThxOzHK9A==@kvack.org
X-Gm-Message-State: AOJu0YwzrqGcPjLlR39nkNzfXO5pp5codI6gj9an2WSmzmsy4y/wGwPj
	Rt3k99+8HjVI8QZo5BxI2eW8xD4nRHt5EtFKdNhjgIvmaYicMCDW4cP6nmcazLa3jYfh5gnsnRk
	7rb8Cs5LV6IF4KWUkymJjpRJrr3tdNKQdAiGSboCC7dam5YXcManq
X-Gm-Gg: Acq92OFEToaKsG/noPHhtZmgkvRmmzOPiCXmIULO8y67h+ZXs8fTvtb2kTbTP58nhQa
	xFKeK1BVvtJO9DrpIzsbtrrqGv2QB7eEk9QmJmfHQe2HdS8WayDz++NOcyG69L7nhZ1qJRR2XH9
	AHNR0EWZWGUXlv0nSRxKIPaiR4jkJO4t7KAoCh7Zq+erkVXa6PuQRhWHLa5Yddr6syp5m6cPAdn
	kPmPeFImsCujXO35wdjP0H1lWjrbaerUxXuaqazTyEUpMIj78HB6yZW6d8u1fggrH2LlR/wr4Xm
	Kbk1jdB1iqPtstWsa9hjCUpGXXeAEyjcSBbpIfJR9k4ZFu9iHzoUDo5CxgRTL0N2dx+t9BVz8el
	8f3NiiTLE7SyhAPG63l2Nrpy/P73iUHjuNMjAIuCJ7Q0=
X-Received: by 2002:a05:600c:4753:b0:48a:7a10:4f17 with SMTP id 5b1f17b1804b1-490360485f7mr2618925e9.6.1779315618483;
        Wed, 20 May 2026 15:20:18 -0700 (PDT)
X-Received: by 2002:a05:600c:4753:b0:48a:7a10:4f17 with SMTP id 5b1f17b1804b1-490360485f7mr2618645e9.6.1779315618045;
        Wed, 20 May 2026 15:20:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d4ad9bsm18916095e9.8.2026.05.20.15.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:20:17 -0700 (PDT)
Date: Wed, 20 May 2026 18:20:13 -0400
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
Subject: [PATCH v8 01/37] mm: mempolicy: fix interleave index for unaligned
 VMA start
Message-ID: <2cc8a28608f548d582c4e5609eb036ac24f7ae6f.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v9gGPLU70x7xg8v3azWbWFX_7XaNJwd6gYuBium1sqs_1779315619
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C020A120006
X-Rspam-User: 
X-Stat-Signature: 9q5isctd6fz43g16isqnqx3eh6xmqgm8
X-HE-Tag: 1779315628-61257
X-HE-Meta: U2FsdGVkX1+hePftLa0DdApTc0c2nEv1SXhyY821M1Si6TM8eIiZEMEmVHJcrvpO3xfivGDHNEwIeqe/sPHmNCIRrOyrV1jygkwtNiIRN7jSWRuUniC3njklSH4AEQIAQSODYe3vUq0H7JeTID4HetzpQVrS48zWTN1AbHI4et3lL/Xi4e0OyFz8Yiyr7Tyo6KT0VZmdduACRlf4Gm2Pyzibni7D5toz0SolE70FT69UGa8sXDnJZYCJz+JkbhiZWjMeHoYLXBVasGbE3Eg+cxU24sO+m5yo2tbFesnEcBGFiF7WDppEQ33NGLvH1OAHJ83X0nm/37BLjhSi0JwDVd7y/dvgNaXoQ3q6qF4Zpw5QjhQlaDYFBbU6JHljkeGcUqnGFlKToAdD9WZ7D1jNtwBZHIj+1jhlDZkJ8Ky2dGR/wnhuCaMl055NM1V/N0leEETBHxUS1pfqIlz5i9LBwS0X+hmY9H99LHIt+ifffqbs+n/aV8UBQ9yBCoi6wAvg0vUgyS2ZnJYyd8RCLS1FxwdTzPyxJwIIuGjvDFaZnvuwqH57MD8uT4FGidv6GwnlYxQXosFI2qcmo0CzopMLNpfqJHaG9CPV3pJqiQGBFc2omuLtBZHBnRHQo74iHp+u6qX2tGekZwIQHClDs5/GyYVYGkeHdhgGIW0br6NUux0zClDg8Ski8Igas7yrV1z+kdFqV3v8Yp2nF5MJbllWfZgDoLNfm2jgcPnbu4SdqhaEzSzNzKnUwpscM23jRJGp6b0QQUgHQ23C1XEHt9I9xKLLCph3FsFEtzq4wP5zTqBnu9fmzCrCQkLV7yw+/n5txFf3ipB6XddgH2qgDzIOXFFpqO1zvPmdKQkfQA9Y+2Vi76ZWazefIR0ohVKZ3zIpE71zA5JKCbPR/TzaFYz5cXhp7hJcfRTkiQ17zIC51IKWPGdPO/HH8rVcffiCKJfKGgb0mNq1DFjau6KJVlv
 N3oAlsuo
 bxrWnP7N11l3inwFy5p9ESODAa40P+ijDod91PQa9fN3YJq59wADK9lJ2GYHx41u30JIqo5XwAR0NON19WcpZCVMqXt9tjoVYJUvWYTIljBXatmN/qxTZSBM+MlksBLZk1AsFHDETMboePP6Lvi8QfmNzOa8/GANTPTrekV1lr5lrxrYynD5+4iz5aWLMEJXWTMgZPvUwiQKyWmfzrMluOV19mFv6Rkz5pa6QAVY03+ZUs5UTO8KqIyAN4tRmKYkpyhhcEttSOSHW7rD2jOsC1sJ9ebZ3LHu9XijQO46i/PucSw00jPnw4tz0fvfgpzzel16IYZlZYBZwEkiCGXpfMbdvMYL8ORpJf6ZiqPpE/NBakq094+JjVZmiWMsACNfN8Ve2E0dc3XVk1aSC8kTW6KSx7f2TlGgwOphI3JmgU2AzRyyB1Q/RkwWBeELYhhoT3vX2mQQx0zybnpzvv/hCu64DfapnLaz8lD/lQuIT5Z1zy5y4mhXcDFWCUZPQjTST0B2bgUefA0ry7ZFsZJrKFsoU8aeCqJq51kirKQs8lHEY+78=
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
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..b2c21ed1fd84 100644
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


