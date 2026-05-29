Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F2C4CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1186B00DE; Fri, 29 May 2026 11:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98F46B00E0; Fri, 29 May 2026 11:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE4E6B00E1; Fri, 29 May 2026 11:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B97256B00DE
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:23:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 829E71C0CC2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:36 +0000 (UTC)
X-FDA: 84820826832.04.1944459
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 106671C0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z6hsLO3B;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068214; a=rsa-sha256;
	cv=none;
	b=r6Glg4VkMReATOZCbBpZVhNYsbW3Evohr8nkUgoCi/pZDI843ideEcMJYxDOnGba8v4yUT
	xOSIkn7WYAdnu1gQpOsA1CPDG9FNvLDjz5zGxEYSTuUpaTVjUtYqusC3lQi8bD3vJrMJDG
	JygUbbbfG5ZwtfFwbuMKmDZsrKwk/jg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z6hsLO3B;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBx6SgN438Kse3DYiPhfWEcJAMkqbJwsQPerWAK4QDs=;
	b=mYUKTeoI3hfibYeyEqsi7zYnCq1YEJl4hDlWeQP6hVXCE9XlgNnzVacP2A238sVkJvv64G
	vk9AcAfYPWaUdV7xIYGt1AOtEXVr5FoUrB3HRBM/0qCfui2uuUM1e3nFNUpTFDCz0J09P1
	PXjmK05HBIU8TFK+i/G99Kw6aP+GwnU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YBx6SgN438Kse3DYiPhfWEcJAMkqbJwsQPerWAK4QDs=;
	b=Z6hsLO3BMe8klH2VVDjVJXVVnee73LsklJ2YPGaMPx7LZjO+oVOV9QchRHM9NoIZZO2tm0
	6pfRslmQzACOIWUUEyBTP6XOQg3dsedstUGSlmizy9N+5vTv1V/JssFYxR08sQ7ITj/6lZ
	vnqWBwDjtqvpjra26wa1L7NIRn+NG5E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-kg_Kycs6OWm_axFN2vQqeg-1; Fri, 29 May 2026 11:23:32 -0400
X-MC-Unique: kg_Kycs6OWm_axFN2vQqeg-1
X-Mimecast-MFC-AGG-ID: kg_Kycs6OWm_axFN2vQqeg_1780068211
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45ef3c7073eso483527f8f.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068211; x=1780673011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBx6SgN438Kse3DYiPhfWEcJAMkqbJwsQPerWAK4QDs=;
        b=hOgoYI9TR8F5TDncMD30xRJ76d4dw9czDGCP9umiqIoW9JF1X1UyUOuckH+OovmTSf
         Q138PP1PX2+wjy/67emK3RG64GfxBZ7whVyOoQJaBTciIkodpShs8ZF0M8MMBVEMBCUh
         +nPV3mYuPPScQHRy0+YfctsrAK8oQSVThQagd0Ev9lCj606Z4ECzDkGUR8uLYLdKNr/F
         SVLtvUP/25eZp/nEg18LgPyogRzhPyzZY+2Ku5DChOyuayBGtFal3ImrvQz4sS+eO7qE
         rtl3vaStVy22te3d+Mh4aKRTE6RNlI1RPOWub7Wzq6cOQL3cn9t1b+LumUZBAdMqGNH1
         nGhA==
X-Forwarded-Encrypted: i=1; AFNElJ+8q2KuW+cHM2Ckn0MLO3FHuvzBV4tfCol+ZomG8Fol8w6lh785AQVNPn1bQif4CZEh/dQuJVeR+w==@kvack.org
X-Gm-Message-State: AOJu0Ywfm7GfERb7I+/gKFsnyr7XcEoaN8zJRl/xrO9jrsactcKuE3KV
	Jo4iUL/lJeBZD7+pPPoojbIhDNyRcOVThMwVyZiC1yo33Dy/uX8IjFJ3Plf4clb88mDruSXbyYc
	Um8SfGBLrVuqzU7GhSuoAL0aN+RDY/GsLJApZ329mMNzMS22Zjhlx
X-Gm-Gg: Acq92OHFJGBTJBShKZz3LQOGRKVSTMSre/pALTEFln8v4ipeCICsLd5SzZx/Bxm5jLy
	lQMJh0wPYdZhXUE7J4ue3QWy9XfmQuVdpQKjOc5xHkYvtrU+AI6T1rl32zhv/Eo1pq5/W9FCp6X
	9HeL1lNXZSsb1yJ5XeTFwZ4EPp/bAfN7siSPWwp4l2JzHEdYjRMiXvrITGotOjXoI9a7/FNddwP
	0wk3+webTK94f/HFfSBA/QbE0xcZ2W6/1kN9TVngmTFHkzPgVMYjQ6eteLR3ZS+WacxL9KsyovE
	0zs1ihtsBqzAQs/ZlfUoVZT1fkXILdoJTE0w6T+2SKwIjuhsJCYLU6qkppoJ9MhO5gozUzqUe34
	+C+Xi1349pwVo7F9x+y/iVJYZxpq5w08oAXQ79nfNDF3N0QBJTHbKsA==
X-Received: by 2002:a05:6000:4812:b0:45e:f6d5:7db5 with SMTP id ffacd0b85a97d-45ef6d57f21mr93716f8f.18.1780068210646;
        Fri, 29 May 2026 08:23:30 -0700 (PDT)
X-Received: by 2002:a05:6000:4812:b0:45e:f6d5:7db5 with SMTP id ffacd0b85a97d-45ef6d57f21mr93615f8f.18.1780068210090;
        Fri, 29 May 2026 08:23:30 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef35601d7sm5883909f8f.28.2026.05.29.08.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:23:29 -0700 (PDT)
Date: Fri, 29 May 2026 11:23:25 -0400
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
Subject: [PATCH v9 16/37] mm: alloc_swap_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <b78e766a1efa9f3587ee8787532f4b624e9da032.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7SBU11gJvtfHrCiUoIVr3MS9k1ax8Xo-14pIjquSRWk_1780068211
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 106671C0005
X-Rspamd-Server: rspam03
X-Stat-Signature: 5ss8enxhdb8cma16kwmut84fnrmrsacc
X-HE-Tag: 1780068213-551847
X-HE-Meta: U2FsdGVkX198Y1dBePpIAHObr6Os0g7GH5xtLp+HD+MsIr5yi9a2ubd61FrKW22fq31btoS6nTyRaDyrmZE9HSGRKiWjbeGlXeNl45qzLaPXZosf9r9lP5BIu67L9JyLAaiARfZo3wD9Ah3My7AWo22r5IPyG7tCrBvQPS8OcZtuSECveTAxnWSKYsrvZbcKQr6ch6tYKtRTkq7Fo7NKyP6c5jEQUM//9OO7HY045NI3kZkSheBWTHGu+UjJJBKX97QAdlHA9tVxsTeqh6wI1d2btem4JPbblX8fSKDDzaBYtkfGcdMIAN/MA7XXHKsnaowZ75SMag5IcSPkbtJqbNQxgUawWombmYcueFz/3N6MlitZG4bdRlcSaDBLx9Td+rIiVgmRp1w3DKcNmPf+CbN2q3C5Vn18mGxF5sACi7Wxcw7TQvX5UZy2lgm4Xw9M8A5n68Dp0gaadvYT4J6MRKXsOS0wUwzRZh6as6uTXjk9b4MLeQOHBZGJJ/k6Id5UnCQYQjlFAMvLkzqLliidkZIfd40C36Y0PUv51Kss/9r+WfIILMjmaX1Kev+gNBYUkQbZ/4SgeMC31rs1qyob4r9pGevftffofiXkkMJ6KKjRMQoKw+u0udv1aWSDwkLSr9j5R29yKhf8zJJJMjFu45+rRySDo/x5F5/l68mJu6CeMXlyLmVHRTTPhJALgth9/H36+zVuW5sRKA/5qIDEvS9SvWKzs7sRGWwGqgyKpF99T8sCTBPQXg2YcohMwwZiVJSCqG/NRCdBx/MnjneuKjcfmTQT5gmab8QustOdXJ4EaoFKaIyrBIjDaSKkUC2YpdcKZYSbAwDOzh5ijvlKEFGNWfx+VM+cbGmqQK4L3ncP0Ff8TM8qRNYFcdtRnyoDTezEOSm614wOsqZ8YrtkDKluSj5Dux5Mst62vmC1rfKP+VmscI6EpUyxiKyLef+3Ju9skMoRwlTu6nyFknV
 7wqsZvgn
 luK2wCaF+xC31gLzmxv1m7q0pwaImjq1v6qIt/MKDoukyRrzl/2DEF3TV3HVnTGF6sh/Hw4FAhedYymCFdyN7yt8kkQgE2iK/p7k6zH/coa4oX1PVHsgKXgvtoGYfnKS735YpR3xOS0mGDn6G8IdbT5zKx0aHnS9mYfZk9Qp9kV8o5dPdtrF1j5t6eA+D325NDVNrnsmVUR7/tGeZEsLWi7EGoCZeoqPQNz3uW+euCClykrtIIv2Mk1+oa5wfCWGeh0H9LFTgbD2pEhTxZh5QsPcOi3hr6Uwsx1CgKxVLR41tHr3u+LIDfmcjFaBApd+M+po9RZaRcRKbGisXOGQJjuatTQZn+q0PJKCDq03sjrjM7bpr9lgUgb/Z/m8adDsfG2BJzbUiZcs2VJXwEYQ0wZQHgmLiMz8gnXCgf7zq6mE8ZH1eolVvAUGFgv1UsrCvlneH1elsuq3s6aT9Xun5HUyAiYBF1wQpFYBG+SlxLgYoxL18dY39EmEgzG+7u8pjsR3PLSSgDIj4xczkVqfCfFRmnbdqhXh1JLl9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Same change as the previous patch but for alloc_swap_folio:
pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 75bee9501666..adc228fe3578 100644
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


