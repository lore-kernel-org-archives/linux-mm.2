Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3410CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147176B00B0; Wed, 20 May 2026 18:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11ED66B00B2; Wed, 20 May 2026 18:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034156B00B3; Wed, 20 May 2026 18:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E62616B00B0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B00FA1A0337
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:01 +0000 (UTC)
X-FDA: 84789222042.25.1DCAC04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7AFAD4000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FOmWFIeS;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBx6SgN438Kse3DYiPhfWEcJAMkqbJwsQPerWAK4QDs=;
	b=7MdCLn6DpIMioy9grfuHfEsgp6SCH0bcGrw+16CS+yDl5dqYzwqXKHW4u4x7vva/W19b1A
	Sz8DEAshxt4J9+Q4elbRkeWr7iDYK9JY0VMkL66vgxffgqeJBuTk5vYIIpIBYtLAx9uQoY
	Xw2Dcp9MJhqAIGbBh6HTC/H/FYXypOg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FOmWFIeS;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315719; a=rsa-sha256;
	cv=none;
	b=8qlUE6XBNSBRWMBMcV68yxlJVAJkTcqEFPE05LgM4xlrf34+wfPlCFvaZsKfLB9HjWzApw
	qmEQmP710G9azZ7djRTHZDzDBMWGvjd2qCSf3bYhsC0GadT2kUbqCigQZhWIWyCBEHh0FM
	giWRFOe/ZOsIhP31VmH02EAhkZNVQfk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YBx6SgN438Kse3DYiPhfWEcJAMkqbJwsQPerWAK4QDs=;
	b=FOmWFIeSTS+zNvu8+MauBMQxLM1cANz9iuQiVvPahmES2vXoh96l/47b9NNSxjiDmQ8To9
	/IwZwFGxyldQEWZMqnD1DhDu7FNRyd9lXBaStiJ80YnYfh4ZWdSNvhGqyIuuoJRaGWer2Y
	88VghoU06zeDwg8uu0tLzHu72yHsEHk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-LehikFQ-OGGIkspAjrVbDA-1; Wed, 20 May 2026 18:21:57 -0400
X-MC-Unique: LehikFQ-OGGIkspAjrVbDA-1
X-Mimecast-MFC-AGG-ID: LehikFQ-OGGIkspAjrVbDA_1779315716
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48fe24773c8so29190045e9.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315716; x=1779920516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBx6SgN438Kse3DYiPhfWEcJAMkqbJwsQPerWAK4QDs=;
        b=HsXXe7VIe23gBH55eBaFe1ckeewgLxGU6NfC6gG1l8dKR69mlowB3llOKhOAP062rC
         r9GdsLls5H8zVLnqttFcJfSUsNLEd3N7ZQGt2e8jlUKHTtTEqzchj3UsdBH+Ppk1A+wa
         Nmdcl4WWq5UHgQ5ywlWUvF8SJARuZVUmQ5jsehGSDkRVnNM07u0mOaZfRwhc0+Ig38PH
         sT/QyMakj/bcBqbcExeMviQSMImWR5WZ8Zu33eHeGlVPlw5Zh8NR5FcAZW4p1n0i/xyz
         LyRY99Vt/0zSgHeERfJ6p+/6AkuaJiU82u2yOEy6ZvDGQ5XfkDyLRE8CQ7SP/nshmKkg
         u/tg==
X-Forwarded-Encrypted: i=1; AFNElJ994rIHUh3l1QbUXgXmVmJyikQCyP+/+xy3aEwSglCZxOsCDIihKptbG8Qt5piX+bz5+ie4QwtACw==@kvack.org
X-Gm-Message-State: AOJu0YwpgbXihiJrEyIC93clLM8hihH9mc5kX5LoqQgARcefPtAlR9Tb
	jbaeVepjIJKukrgEFDfVRNkdCGbXrsEe/Gn/DLM9RTZ849mR5PrEN1SoAzasdu0tZl0ooPivDQu
	D6MVLmz1YbNLhGu+ElOHmVn+PROg7qAsX8Ql6o2Kj/39UwKSaWm1B
X-Gm-Gg: Acq92OHfnwpqvCknwISiDoV+MJT8dMyHFW8stqpepKrRjVK9/HeTPta+ab3d+2IkJxE
	i7KMa63Rso6ztILgGDEmDJ7GRLmMXvvK64NcjLbCN2XOzDHomfo4+XhTNR+eU7v7/R/ZvSjRJZX
	o5Duj4EFdQMVjF+PduCz1ywx/yXBngAe/cY1UMr1m4SGvn+MbyuNjyNungI7wQJtFIdUm+e52m3
	/l4r5NRPycO4NKpuFIoXOeBvMq4OgqYJxzocxEpLpb/nu/oA8aTJrG3Ph1V2Wk+mHiNtScKcNWv
	pB88NjuneeJTTXPmkcrupFpod6gJMNP76ZKfe0pJ/rq0sfQFlIHELdFPMrM+3fKlPUIUI+H3dhR
	cS0mAJhqwB9/p6k0cHI7VDAeTkBWKNiaa4pmkaWGhgGDXhAmrk7VDkA==
X-Received: by 2002:a05:600c:468b:b0:488:aa33:dcbd with SMTP id 5b1f17b1804b1-490360c12cbmr2778535e9.26.1779315716147;
        Wed, 20 May 2026 15:21:56 -0700 (PDT)
X-Received: by 2002:a05:600c:468b:b0:488:aa33:dcbd with SMTP id 5b1f17b1804b1-490360c12cbmr2778335e9.26.1779315715676;
        Wed, 20 May 2026 15:21:55 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035ecc679sm2541065e9.6.2026.05.20.15.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:55 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:50 -0400
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
Subject: [PATCH v8 16/37] mm: alloc_swap_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <00a4571e8ae75a457353726e1ec9111aebf76e31.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Nsom3dN8nTj0CiasnEGbevQLssGAkCtAbvwfgIz2R4s_1779315716
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: hod44q1ob8zroqgze4ihtfnrkfzwudaq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7AFAD4000D
X-HE-Tag: 1779315719-639857
X-HE-Meta: U2FsdGVkX19zGLsBcJ94pzoBuTNUnmdsOCbCVPXiM6GSbh7mDpB8akI3mOLjEJadPDlZTTJPjcZVucwkzNmT6Cly0fu6w89rPCHaVk3qzsINCz42fcKdkraLKb2pFgKEjUrNWr1BVokmPY/TqzUa2NTWoPEf+MFeja9anx4pfEWj7IB5BM/x8aL1waVF3qzoLb7LAfJyGKbfhbwBrSkTS5TvMNuprh5/H3ZWmartzH7usD1houHq0VkbdEqObQZ6+cojuDEY/fz+X08G+NVYlkBI8/zlbRNGIJu6071dssUvnN1OoS3owpAKb7Uk2xSz0jo17OBV89RUwNTzsS0CGta2JmBP1O7nrZM8PRxhSlvrl/06qgrEedch43lBxLfmRRUtztTxBBWdROUvtPXwZKVIqFMG0I+YTBkVY/ZKPEARalrCFaCgKsiVm590XRjKVhPN6wV/zszcSNxDkANzqYIRMQhSF2zrLb4K/1xVzK60/7f86dTlmyzFJztGL8cVcWogljyjZj1o7RN8xsj1UszV0mBQNSr/mKD1FYhWC9JX4VAzPB7WdR6jFDmOt06ONrUkye9jB45ZUsKKfQvPhOPQLOZ8vPv4j/qWjJpAz5UGDvPVoSRMtQn8l1XKOIR4wzgZmoSXBzpkirHFj8hyAWn/Vtc9KKVsW/NYe+pJhyGcw6jPjLVpmuATaP186l5XA+JaML5RRyII4SCjeq7CQ7T3REnOHkrEdFwBqQEbDxSa+QMwsYAbpY2u9/7CzCKuZGRQ9dYk1Oxs+vr/Kzps+5hqCFy16nuBFHmryGTFLctgHDAbbEW1NCFI7/Bo8/fbwACEYh5jtQz7ZrSx2D4XRlpZXZylVVax7/uaWwt7V+vL/7fAfUV41WuicftkCEhOS4vjIOg9JjYl9On1JZbvjbzZJkTV1Q9gOVqt7PjfHg5l8Y9Rs7xpkHMt0XgRMGoU7F5HQwiN1ceGqakFUfT
 oCu9Dgom
 jIUuTSg08RC5Jv4wgEf8jqdQF7K8TNTqt+c2ciwMtARW/6DQy8DJfPbjazGjeW6bcIJyj4LlY3eTDFc64o8fsnEZjbvskzOXTQnY8WEnp3jYehHE+DnHIg+PQq7Ku0b7Oet6uE2jS3jeV1M1TTZhwhsK040kGfWvXSxe9RiY3A3UexEa42eGAp9hBHiHGntQkOdy3HfNWv9gumntzVfSK/YjMtx8AupoKVjLKpBZB+u4Dts1mb2H8Mb7EWs9vrgOG9KovAt7s9S7xmuLWJTgKmY/OkhaO9M98+ljJ/6ecSmcdf3rw3OVh/HLFe1k8YomIpJWBPVqDQ2ieXhftF2zjwjCC22RkA8ujz60acHhdwwcs+0SlTA3q6ia3xUHWkAOJLtPQUwdD9VwAm9gMB8bAOxWJO8b/w5dwJTqC/MtfT0adodqjiNZXACZGRm9ipayUsV3jUrmn9yTItoLvox5qL1SfE4Wjqhfx1b/dwuHaBRbVJg+xelv7PBAYV3UPbKzZl+hj1Ip5XbPAWbkNmpXdq7AwKsiVs+XlN/H5
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


