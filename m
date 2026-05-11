Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C66FCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87FAD6B00A4; Mon, 11 May 2026 04:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8566E6B00A6; Mon, 11 May 2026 04:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76CE46B00A7; Mon, 11 May 2026 04:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6900B6B00A4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DDC1140650
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:47 +0000 (UTC)
X-FDA: 84754526094.03.1F76577
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA0D6A0008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d3oZZSPz;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
	b=6f5mFJw1RYE7cIuk/tkBq5C/f8u48kB5280+93TsHuAdIZCd5FFEwuylyYD1JotkqAAhD1
	vZB91ug/xG//frSC5udCjRc/RKJxEM5ASGY8p5UAGIJGFPl3W/CBwtYTTorj1TdIOnNy/V
	mofGYA+DP419jIb5yx7/wbgHHdF/5pw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489625; a=rsa-sha256;
	cv=none;
	b=hU5rgxCcLHpPYcn63/1JzlcSbePZV73+Sqxw6c9w5VvIEjfzKSZzNeaWetXHTOVM6UyX+f
	9C2cKEYNGSqfQ07bN+SL/aGQR/ZEBC00nldMBnOUtgvicLYDRG7QV8OLbx+RvNKuSsUkN2
	FvSgzdl9aWrLXuQdn/HRMr6/jGB5/XY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d3oZZSPz;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
	b=d3oZZSPzOSTZEcUMBaRDsoRPnSW9qjZfQ29olXLPwBZLUvW9jXwfPKMkcubCbd1d+iEZnJ
	O1cccIP86neNjSPAVC+bPpGQdkNY7oEFdxayi0PvnK7RZUuHZg3MuuS1omZlJboUSFw/8V
	nl3iIR7BhkA76//SDAI9bsjOWOyL/lQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-u_WA10quPy-F6JbYmgZEWg-1; Mon, 11 May 2026 04:53:43 -0400
X-MC-Unique: u_WA10quPy-F6JbYmgZEWg-1
X-Mimecast-MFC-AGG-ID: u_WA10quPy-F6JbYmgZEWg_1778489622
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso30414735e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489621; x=1779094421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PyhJPD76XSlXOLIxrgX26vlRXB2m99TPkgzm+4tnrhY=;
        b=Ib62Ji3BPtYW9zRNzHDH63WjTfZYzLQTHHOBiFQy0vyj1jp5SnJI4LLU3LXnI48qzg
         xnQSmhcnGYTqlJyonN1Ujv37olUl/7C27Tu6+wAczZo9okxnklRpA6oSldExrghXCeML
         /eUyto134GGQTK9gi8lN8w/K3Q3BlveiihJHPeRcjuNXEu6oUcJgSAHQmnKR4FCA2fjU
         U7ciuyAgyohVf5KjhGOCbB1hI9uzx0YNM1q83WXfdhdPCfyKb+uX0Y64zIuVSn5Wkz9Z
         j0GWGKN7WHhOvz9i1idYHw02RN94leQC28ZCxvS2F0fMaKxlvUZPJ1Lx2lC5ymTd6afO
         E5KA==
X-Forwarded-Encrypted: i=1; AFNElJ/O1TGzcvM4oWrvZ08psvYsENHZCir4L2leZY9Ma2pdBm3rYiw3l6fRq6qh7rernGWumbWyzGt6lA==@kvack.org
X-Gm-Message-State: AOJu0YxOeaV0C+NZr6ax0yCmiSgJ/+rtNWiLeMLY1TvXeg6q4KHy7L50
	cOkl+PgSS3zTnSXptTcVBa08lnGEwM6WmCOzfPmOqQpA3v7WGCARvLnbwXOSz8/efIvyFNCXZwO
	Hhq0mDmm0efYdJii9M5lJnvyjC2buyxT+Snb9LaO7ymASVdc9/xtz
X-Gm-Gg: Acq92OEtzgg7QSq6/dpoK9JgSP+OGDgMJ5pbBJEPQ5NlO4bb2u93CcjVv5IWJA2tM2E
	yWgdlilIywOlxE9ZC/tiwwfmtQfOYibdQbUAgbI1P1YkET6VG2j5VsL1a/wpYNtdK9o0hXEH8ac
	6F8x46jE5ZG615j1cNEu5yEtsr/x3d8zb4w6+zSGeYEUE22HbqXUvG1jDE6Q2u/G0pSmKyPCQz/
	hePkqfkWx9QbAUR2YIk7+qsMYVMHG/yAcsG4tIiedl/08og4wXsGCgnL487gRFO3qbVsnboU9x9
	zt4j/oBOLFF3JrMySbyhYpTj+B8nAtGyqv92pWly2ihYSDisHy/zcK2jloM/gUUVtfr2uCBGZEy
	MINuglSI1yDgQ1fc4mRI8TImgcRBq5xhhabuSanZu
X-Received: by 2002:a05:600c:3ba8:b0:48a:97b6:7420 with SMTP id 5b1f17b1804b1-48e707fbac7mr149916685e9.24.1778489621252;
        Mon, 11 May 2026 01:53:41 -0700 (PDT)
X-Received: by 2002:a05:600c:3ba8:b0:48a:97b6:7420 with SMTP id 5b1f17b1804b1-48e707fbac7mr149916025e9.24.1778489620562;
        Mon, 11 May 2026 01:53:40 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e7e45ff89sm115577295e9.8.2026.05.11.01.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:40 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:35 -0400
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
Subject: [PATCH v6 09/30] mm: alloc_anon_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <96bbd5dcc37aed93a9b7733780bdcba4fdacfa3d.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bh4BmfST6f-A0b72I61bSHKBe01VYx2Jitohp8kQ3_o_1778489622
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA0D6A0008
X-Rspam-User: 
X-Stat-Signature: y4ygprrn7qm635b6pniq94cqqu53iur7
X-HE-Tag: 1778489624-660168
X-HE-Meta: U2FsdGVkX1+9pO7MrFPVNK2xHPx+/clThQqsa6G0//Z26+Xi5qFWLEibOFD1S6WW6KNB25GzMsOs+rCXHkJRER8k2BU+PoS25hOfbbmwiNY8hYNjas+PIdend4kWJ3c76rS6iaeQdUWEAhEPS67cNYtcipIECnksLrxIc8pfDPQHeIGAa5OSJZJDiRHk+cJ67EObUIazBWURHCWk61ECPbI8oVL9TKs2ACxwL0QylltftXfEhIYlif7qUubGVqZk+49RXm+JzcJ3yGQiq0MYU8w16JhqXsrjM1baebwV3wcvsL9BYzk0/RnPQ8NLFWauRrQmKoSAURLK75gn0xGLksSYACUKjfgpcueF9DSswDCph8dbKRG7MYg1kSsitNVxQIVDj8GOItsOKXe79z+APnJNIFHCxYMzYlTX3Mj1HSsRfQb2vk51f4OOO6Oo7mb9eYeuP7X0nnK8bCKf5SCM49TbG0RDjIpRJ+r2Em1eXaLnIta5xeGkIycoy3cocqp/Rpi0sVOWT4xSDTquRthyKNvty4SqzXXSeabhlvW2bRmuHkm5xCtuJ2fLQH2oeQExbh/bLkyo6JwjMfmHKy/FLBX7HZ0T0Y/TwQ6BCk1WlftoNZ/71SOX+QczWrSlGWl8xA1zRmASJ/1N8zzK+wnC15m+c1xJS85pNUDm7P8I39kPkHSQ2uGHMObRWb0ZCwljSVJTAzhlnz8DFcWg6P5uW8nctn/40sOZQfmrpbq4igKrccV3s5kMoOiCrGgR8mVWbYdYlnnattX564bm2axFh6ewNEN/LcWPOrf/viyN6VvYfBMI0boEgllfimO7OTzZUqgRSJePGIasm/VSZ4OKuwFiP3gvlU6CELI432fia5D3FTaq7WFKYHqs+JBd8CZGs5fgtCmn5i/0W9lhb72uaLNTgXXgA15Jy50Fi19NCHCGmd1MOdZgaquDCkRWbIDhcVisV1iBjhJwqI0h6gf
 4ixJ8InH
 K5bvPci+AeaucyvA/BCjzDEycptpXqVikNoAUShyFBOYdHUDbtWKbO2R7QMhwIZvE5PO8EO5wDr42PnsKFMUUBLLW1gXP+g1Vuy8DMgXNooNJFiVcwF2QF4NU4fR2rKTAd/dpuvHPDaptABu5nx7ObOoumwQ/kkJLRmkFpd0OS6b68MTmlJg5uFvsXJfJ5aVNNwh5UXJ14bXI4OzRm/n2rGEopP4m7VwdU6CHTSLwjOl9liKNn10MquXsZ+sDOiTkf+Gg3Xzfhji/BfHUcEY5CnkFPGyapmbXdRQZd4/LJqHVawdxYx8sc7RriDY8rlL56GcSUlCaCQ+e6bYhjIUwNrFcZMcBj+mEzjqKA8XZvmKvmegNBb93k480zhVJeVHDz5QNe0S9+gi9qSYhVmDOR8SDQL2gp5VkpUC+HHd4aQEkKYWceHJmKpYl1gIn+v+Bie8Yx3R4R4m/5gVH5iNbiRf8QTSadLKCG8Ks
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
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..0824441a6ba1 100644
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


