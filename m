Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFA0CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4BBC6B00A6; Mon, 11 May 2026 04:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23D36B00A8; Mon, 11 May 2026 04:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D397F6B00A9; Mon, 11 May 2026 04:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2F776B00A6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89A43C22AF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:54 +0000 (UTC)
X-FDA: 84754526388.20.97458FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34F72120009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pfv2tou3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
	b=8am6skQPevl0T6JZPZ0aJO8UmDLtugZIF1qEGJfHjSLHD1WUe/iyqd1wkj1zTTiliSRqZo
	zWrenBWXLWsOqQMms7SwsIZHtroKykzE21CYJ02WaDE0nCd/iHQX1SbjWdxD5InJ7msbmN
	OoWFMOeilEi5Snbttk+BXAEnSm9CkdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489632; a=rsa-sha256;
	cv=none;
	b=vXIlTx1J6yIKrTwwErmvFAlKLnUc7+f5v+XZZNxJ+zFmXZKMWYNGCiuVY0d4CT54jhitEc
	PaTa+sCCXNUyOzw5Qpq/NM/oeWGMkKDGfRv0GQG292iC+gOzdIKQkNbz5tv2amTujwoeSu
	ZVkOOOFBoODlpCeRrvsYB+giii25oL0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pfv2tou3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
	b=Pfv2tou35pvTUNO4FMM+lkT+Hu4t4ZKtqh1L7vHDw50t4VWRdr96c9iaL1sx9T35Yq/f2D
	uEJR1D3xh/ru4pw3fv1eOhh/7LwUMU94XDmsneuf5EN9Pn8Q8dpvsRXx0GUGTnCgsadQ92
	4lX/Jw6s4BreE/ceHeQyR/9JRA8evFQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-2baZXsq2P1acWBVXO_cTWg-1; Mon, 11 May 2026 04:53:48 -0400
X-MC-Unique: 2baZXsq2P1acWBVXO_cTWg-1
X-Mimecast-MFC-AGG-ID: 2baZXsq2P1acWBVXO_cTWg_1778489627
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48e51dc35a3so31805385e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489627; x=1779094427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
        b=M9vSD5xyFoHlQrfQmSKqhIxsz7vJZg2Tb6FVdXEfpO+ZycWDBgWYohXx8b2muHBLGy
         nK8P2YyKSYDOdvsYjW70TUOPwJROWOc6iJ9vRaYZnifDF8W1ydvB/JImbjuDINKeEtVW
         Q/dCMewUAI+LA9mqulcMXeyBcYlLFhQlscNHEaFehBMmClVTXsldQ2/AiyQOqy6upURQ
         P1/4ahE3Eudg3xXN8RvvPSO4eddtL+/NcogZAcUbWGt8sLvNEqGkLc3b0Aa1S7JAk6CK
         ePanBkT+QXzj9so0Gq4KuAHk/yU4h3quhMxWXHxXC9jLf7mrxn13OtBJNm+5Jmk7t1ma
         O3kA==
X-Forwarded-Encrypted: i=1; AFNElJ8vZFdQpCEPANllzT48E/z141AOTjNOcCZ6Q7SUlTpbUn/mIICVrtV5Z/bZ0bR+vi2bPsszXMFPUg==@kvack.org
X-Gm-Message-State: AOJu0Yyo1WiNWsG9ETZAeD0y4vypVAZZEUJqbaF061CpaxyqmiiCTkuo
	RHRWnwfI/7bul8s0m6U8POQi6S7AOxRyEbBEqNU63RbJeBcC+ng7MgY+Yi9+OM2VYPoOpOxkm0V
	RrPebIi5EudujY6irsVBL+DuuYgCLTlbJtMSQCUAS7jgtXTMSs0wF
X-Gm-Gg: Acq92OEjx71QUB+801KvuChNdkcP/cPXT8NaBDFNuOafziY5xtfYjAn7B/CJf+gDZVe
	r4tRWA4CAySQoqd5JTP2NBkOQAPyGbGfdeQXzTdC+V6LKPkJ6m1xpW0knZ4jbwEu8HXA0yOUqYw
	/9+7U5KVXKgJ0RNDO2RlKgATI4MAhfiizS7FZylUBdvcWCT6oDal9t6zoVsIGLgxmHX3pGQOhX5
	WBkbuu5bh8q5NwgVgkdoXHqaRrP1YqFFUyZRFM8c0YQLmvxbEldI4iOaWBAk/nnFrZMgNnpMF60
	zv0/Hqik+Upll5fYwEaITN5nSJfxtHVFvY6o+qBDqRm3biVt2cKSDz0MCa9brjI7I0FsDq56DNx
	Bgwheomu5LN4S9D60fF9LArTr9XycF7JJt+HHCvXspt7C2eO6gdQ=
X-Received: by 2002:a05:600c:8211:b0:489:c57:7836 with SMTP id 5b1f17b1804b1-48e51f40ecemr408950545e9.27.1778489626758;
        Mon, 11 May 2026 01:53:46 -0700 (PDT)
X-Received: by 2002:a05:600c:8211:b0:489:c57:7836 with SMTP id 5b1f17b1804b1-48e51f40ecemr408949875e9.27.1778489626227;
        Mon, 11 May 2026 01:53:46 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491ca2fd6sm24939735f8f.30.2026.05.11.01.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:45 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:40 -0400
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
Subject: [PATCH v6 09/30] mm: alloc_swap_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <7205b70bc71ef0794b5148242ba18254d9e421e6.1778487000.git.mst@redhat.com>
References: <cover.1778487000.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778487000.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: efBMqF3IV9H9Er7E0ISHlh6Wvn3RxzlNvMAjhdmTMwM_1778489627
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 34F72120009
X-Stat-Signature: ep7p9bzatsfjwera4yosc1n9hsrrfg65
X-Rspam-User: 
X-HE-Tag: 1778489632-225704
X-HE-Meta: U2FsdGVkX1+sxpX58kEPabD9pmWZe2f6wftwLLfXIvHs7esHRnXBdumXTh+pTkQCOGLstubrkXucAzqEBI3J/7qc0a1IEnwDTXW69CdvB0zWYQykxv/0e/0I17NRvKZM92890j++FWXfvbtSyU62OxHlWjWqwHg1ZFTksE79AqyXVo3pjT9ZFtcvz2lpEXSU6xt+N2VFTWADWQw49n5wc7BLC5iFj38K/Aisq7srYMJdarB38gBjHgJ65jOCiSUy+Gbhe90WA9YKPOnD1V1baGegnALQVvkSeI1/axB9P1cIGcOs/Aowky0FraYp9wN+dehYwXhsmFSIaLWRGdrp5OwcCy7QNsPjRwZ0EUrUlDZFhR3modlYrX2jzmlP6tyhaXsp2sUH+R8LsN7B2eSOua7xl4SLfxmJtH7FBZgSTTKfERyBrWWD5tTAfbODdJxHnJ/qvpAz92Q/qaWdERDgkE0zr1tzhYQAgsyj2s+KnSSE0LAkyik5/v1d8bSQlUxqFt98xyjKHP7Yg8NvowacYhi0ztmtIqcQEFt+C0JuxfXVg7v/aWj6T3+Wv4lIKp901550tY5auaQvqANWzAkAHRQ0pmlVfKWWs5fDtBA035IsECxBqln6Nc0YMl3DtXMyUFWtM1+Dlb1vZsWkgjX9KpfYVOQcOecXYhLHxZCTkZt6MV7xOhcOo7Svfl4x6S71RvyS7WgxyWueZdq5xAT3c7IVzlU6zQnW28sP49cSfdVG0gyrJVcI3c27K0KfiUAxwbGIGI5wxUXIHdu7zX9GCsvsY88hLm4BLKXzAp6jmQHfY7fOasX2FFlcanb8fkgodDzuTdMeYTeokqQZZn5fGG9eAWLWUDp+eElBpk7l4TTA4rZOxF9eY+H/BNTC6uplDZJ0i24ZufaGs0rtcDyZ1Oe9baj6GagzEVDuPN29LagLQK/Dv55UCIdEdou521/vFnQFLzvfisoNXWNQHda
 s0L66xSk
 A+ofEPoWirrMglxeWfUQpcDJSOJAbsPRpMcSnpF9vYtFpYDST66YJWlv4+Bfm2bFzL7dqdcIS3fNXxXT48bORqMm3Q+wKCggelguJwJxW+bWUvZ9HzU7c//PxE3vuGNYdt2bjTwW4pH0BF6QU90KnxRMwJ60iNbeY5OZi2p769Q8bPOoVsi+0LrblEjpFzoG5/2ONf1guTu13qbVl8sWyYuJTMB3K1yxVRLbdYJfyY9P+RmjYaF3UFKU+/JD4aBvJlJLA3Ymcx/ptqokG3YKf3z7NyipcFP8Fuc9xVa4UIuzYNMmECl7qD42VF09M7OPtcP4rZZGZmUNCUv9KZYDQISWeRSiJAeC78FTdeBOT0XZLVgCtY530/lJVKmfGX8ePdZL9zn6DSPWBLQTJDNB2BI4Ax9cTduq9PU1O3Q+7anHn8NYMfwYWfEUIB2jTvfpiov8nKH2+CbEfH2CNOpA5/WLgDsDWVEerhajy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Same change as the previous patch but for alloc_swap_folio:
pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0824441a6ba1..74523bc00d8a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4734,8 +4734,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
-		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
 		if (folio) {
 			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
 							    gfp, entry))
-- 
MST


