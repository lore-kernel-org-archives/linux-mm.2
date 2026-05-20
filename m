Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6975ECD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB89F6B00AE; Wed, 20 May 2026 18:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8FDD6B00B0; Wed, 20 May 2026 18:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6226B00B1; Wed, 20 May 2026 18:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA6D86B00AE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77D9DA0461
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:59 +0000 (UTC)
X-FDA: 84789221958.11.CCFAD76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4E0E6C0011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="J5p//5BC";
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vK+J6BapUtjwGwdYlifbIYhLZtsZgN3kLB9idS28qTQ=;
	b=MW8lEAn23uSok3IVtIdqFl3FPH+dy8RBTiOgzTHiJhYo09tIyGI1niIfraABB9kWVSysUZ
	zgigdSSwWs0ts2atoMopqgEBPExr1fdQxZXCAt9NJE3Mhsj7E1vmra8ELaIKHm0igMAHFk
	KJ3wTuvlHIbSsEWoRBC1Z3XglryoQHw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="J5p//5BC";
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315716; a=rsa-sha256;
	cv=none;
	b=Ac0SlUbQnnXYYJNTmuKVPcdeNnhY3KIO9HjaBAvqmaSknk/NJkGjgU56j3nk0qhbgtMZe1
	8E0YGBTnQyJ8ijeb6wvTkxpjhtY0kmlGvgjfMRoK/oPDXRF+pYnjt/3el2MmOQ6euzT9Jv
	D3AoNYSHcDiQqtb+czhXzaXvTLUTUrA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vK+J6BapUtjwGwdYlifbIYhLZtsZgN3kLB9idS28qTQ=;
	b=J5p//5BCyFt0RfjngEwCI5v/FAN3QrRkyjn1fHdLWWPquDNa2pmEo6sUlrcvvcQfKQcRid
	Y+C5Eii6KZsOWB5xsalbgky//MvGrieDK51MNxtwvtR89zwq/03WHYK7h1RJoXRJdfDU4n
	SXPiiuy2Hly2Hnj0dbfR4y+v++6kxzM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-tHYg3cvoNWi8nU6HAUtXTQ-1; Wed, 20 May 2026 18:21:52 -0400
X-MC-Unique: tHYg3cvoNWi8nU6HAUtXTQ-1
X-Mimecast-MFC-AGG-ID: tHYg3cvoNWi8nU6HAUtXTQ_1779315711
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45e7c7289c3so3707956f8f.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315711; x=1779920511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vK+J6BapUtjwGwdYlifbIYhLZtsZgN3kLB9idS28qTQ=;
        b=PtPvgZaWI2qU+X3dCDSFcU7qto7HmbI1gSkO8Yd5ApdnPfXIFa58slu+TZ8k+jWl4S
         xoo1VFfDCVsJ44qB75HtwEdaMhj4cfoWv/7ieZR/gQGVzBoLcBEWlWbIuhqrgqhawdeY
         4a69SCQgI40k9UyF0O6Pb69djbswul7+Aui88qRNzmkqHtg9Lbd/UplIuGgP1snBFYSd
         HWPmnhDedxwoYAccUMkkcjrHGd0nIRwqn2jRSEKtFdfmfXmOFQntgHMy+pwZdPLPI6Tz
         low52nRz6xaPvzNOtzBO6+9UZC/WBEcvaIww2ru0RS+mhAFvsLKvAkC82MAc41V1n6xW
         snRA==
X-Forwarded-Encrypted: i=1; AFNElJ8b+Rj6+vYInFtCpIWNLm1EyHvcIjUtOCWZT+YUCoaNgRS8iyfTLYkCR8IsIIMlnZyoMeh5DMIsWQ==@kvack.org
X-Gm-Message-State: AOJu0YwMVUOy9+mfyM7aRZ3BT/bIjG+9LIy0njOavJjrO9pb6/BVnnsB
	Rwow4ebFoZ1RPiYtgJE9YGcsmvQ7K2N1QzxKqXYfThbtFGItL9X8JU5oUF05o4xBDUklzrF6lcQ
	6HV6Wt49oOd4c0A5vlIKa8y62vVaAGfujW61cyhoeZmSvt4X70TcQ
X-Gm-Gg: Acq92OGEX6Dy271DZEt6hUeiin+KzcO+B9ntTSCjal3/VSWnZNW15+kOQffIsQGbNOc
	ElvsJpw1A+Et7mmp/129A55J2YNhkuqNEmC/IU8bWk4LweWsHwtNneUbnhwxiDpPmgPntcxykF8
	dXroqHHpfExoi2fGHWyDwKz95K3nBq5Gl8c1Gm/0cnYllLhJL6ZcB86hoQZHj+8u0CVZzQej2Ht
	1AzscYqdQfLe/TGDDnqM6WIgFvM33bXDfOakzY51LDFQ7Xh/HIW4BA6CBZL3e/VYEY4h3xTckQE
	yh+pApPPpqgqG5l2LZARNn/sMtFMtefbTcTtk2DprFEw3ipyiKdtHk5k8xeffdOvcyIO36dUUU0
	bjwNIue0Kxgm9qIxGbHNjt8EJ/shxupKxEp+RWooFteavWcs+NvdzQA==
X-Received: by 2002:a05:6000:29db:b0:452:bc74:b129 with SMTP id ffacd0b85a97d-45ea34accaamr165795f8f.16.1779315711114;
        Wed, 20 May 2026 15:21:51 -0700 (PDT)
X-Received: by 2002:a05:6000:29db:b0:452:bc74:b129 with SMTP id ffacd0b85a97d-45ea34accaamr165775f8f.16.1779315710727;
        Wed, 20 May 2026 15:21:50 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe13a7sm59869358f8f.29.2026.05.20.15.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:50 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:45 -0400
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
Subject: [PATCH v8 15/37] mm: alloc_anon_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <467ed47f63a499c8d4c6b8209f6a818fb30229b0.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JtffSumceIT9u8frXT9439pnjJacOPAUKX_eVt2nkxQ_1779315711
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4E0E6C0011
X-Rspam-User: 
X-Stat-Signature: ep3n34td6fkq1me68z7wset5au6oh8tt
X-HE-Tag: 1779315716-239942
X-HE-Meta: U2FsdGVkX19lcFgbSbtW87vY1PQbT48tHyFZiaYBRtTL0r5IjTiJQiqHzLq+2i8jsxKVlEFSSct3Br6LKrpXomWrcC7MTsWtiEG32n7HzpvWHN7QEqIVWw4y4mfixNvQXTxG90+mN7tXSkRhdCDrFQOXPaa9QNpE7AlbXzXHMT7mig46xCqagn3zDJ9kqXDwkvG+Wqi0SUEi+SV/bDzZaMPq71UP/H+Gyjyg2iGPf7OPlQAve1KpgAy0tGRhg6ZTB9QgA/zIQ8+d8JGBdNXdRWWJ0TXpt1iaMw3Z7pFrgEQXIxHznsL9iyaeQLA4eNeNNOChWvYHBRRg1krRRNWe8h/YtTMkeF4aYe9C/3hZgYFwlmf/u/5JjZtApCo07MXjohtgcRW9oFg72cr7YyBprGT+ROCUjra5Ia1a3DauNr85XfJCNjLAnR+N1URDAO6ZjmY1S3oHpsU8Ug4aXBtYcYR5WG081LaQPsH6iRN+6M/pZj1rvtciLKlOyH20h5oGJd3A5jYvIeNzXZXxcrm8nmRxO4Bi6hkZ64MbCsUWiYKvxXoS8PSJFueYG+F2Lj/AlmuA3E6t9DxAgoNQGFzC1BEulwQiUGVLKNMEFe8yBnzZ/fSq2BVw0/reoov3ivzzfrJQxc/CXJeKlHuDLKvcQ/vP2RFZKX91e/RT9gsgSayHg5Z9sbzhcBybgW1TQkdHRylGbrs0M7mlkgze8Rx22P6lz6YFKSELVn+8EnlFpLmjCWvQkghPaUrysw1NnMtMB4ZDsYZXN2bg+0jKitx3FAp9HmlwOAP+BZN2HNBAlW5POFHf2KItKjFLhsRN5q8uPjrikEows1ridhK+vSMCEYiR24VNtUKzUF5szR29O5bZcBLIykivWEtkOoaDUX/4o2NtUWRK2NxDqIdjaQtYSVtnfK1k+dvBfzLI01LVt/7jes3ttAVrj6rkIRy091JbDgYylLGVphf7KwC0YGy
 YvOGr0G9
 67BK3ay97JbVpNNnvxpfgysDZqExUXyicIoLce6KWs+fjQy57qRO0wXKHwW1WOahRKyzQU2/H1I+kD1Q3XOZYzMrPE3F8xNkLYBohkHlVXE5jPiXXtBOXQW3f4VnnGZk9495tVAQaYCnKBWxDqiYG30Ll5WWtbFvL5itZd34x+N4mqinK8J8JynXbB+mjeYE0xHSnSta8Dp8nTh2zN00lDK7uDj9O/zrHRNtWTEDRpBhuQlIxQ9uqO0mLjTE3Yb8YV2VAIWLm83nUWefwwG9GZyRKGRNTstsb6B8gEpL/epoA2T85ORgsF77wKq/KyslauUyVkc8rAP85QivpkJq41kUDrYMIBjOGVphnVdGyg6gaUiosEjk/0c07efao7NK8qwla1tWe3xYipc+9rRH69qFJ7XQsfZyLX/UF1wTLqWiz+dG7ewLhEXe6WzBqlwQXIfPfpYdQz2zuvXwOqax7tJCEXhO9bLF3BSzh8JeGg5b5EyoT8vQaMnhhx5M9Fx33DYM9AswcuqsCWXW4S81YvEIUMSHdQQ/IT+eZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
vma_alloc_folio_noprof now aligns internally for NUMA interleave,
and post_alloc_hook will use the raw address for cache-friendly
zeroing via folio_zero_user().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 02d3e53fc91b..75bee9501666 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5252,8 +5252,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-- 
MST


