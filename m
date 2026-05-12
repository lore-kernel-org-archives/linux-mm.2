Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC51ACD4F39
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313C36B00B0; Tue, 12 May 2026 17:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4046B00B2; Tue, 12 May 2026 17:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3EE6B00B3; Tue, 12 May 2026 17:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05EEF6B00B0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2C96405FB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:27 +0000 (UTC)
X-FDA: 84760001214.23.931B017
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 67D014000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XRtN8t0S;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
	b=1V+ztndr4G4CZNH492/j0X1n37xIi96DhCZ70oJJC2qBD9H1lwpgzEHMWDPkRO8s9IagBD
	Vc49HlomqI0HAicZqi1eZyt7Ote2bHAfvxm88a6hLO7S6ETcxcZQXbqTurmDluHpVjW1s9
	cMjgnMLYHDXt1PSbMWx7ztDG0bL17P0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XRtN8t0S;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619985; a=rsa-sha256;
	cv=none;
	b=dv0fchSmrVtRAp+2hJQEKxDRegNBlhQ8H46spCM3lmuF1PsDpe/h8VgmEcVjb++KEqEmwZ
	OQOl/fUXzieKd4TjcCWeJ0M1jOPUL9sHPZxRwMjvtrq8l0I5Cy+I9q6Dh2NWh6KDaJJmFB
	3KONbC+R4+bWnPTa5ZsBv4fwzjknCC8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
	b=XRtN8t0S7hludJHm/8rFdHt4jbaMinai5EX6DMqfH5PoGJA3izBUv0yaHOiKyuyAEqZ85v
	o8qMox307APedTO4K4e2aAvcwh8oh1VvZ9AIz6tMT0pai5E9pgmn4sMAqoGQL4N2GUBHgQ
	/va29ZIzCx6U5ACzZj5EUQUALR3SXMs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-J4fs8dpANLesCJ5cqqsudw-1; Tue, 12 May 2026 17:06:23 -0400
X-MC-Unique: J4fs8dpANLesCJ5cqqsudw-1
X-Mimecast-MFC-AGG-ID: J4fs8dpANLesCJ5cqqsudw_1778619982
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48eb0da933fso5867705e9.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619982; x=1779224782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XL/pBrxkXlfOOto9pZb2YfWp+jJTrqFtHfQ0Ihv6FSM=;
        b=Ylfdk4BdKIoxm38A/Z+/7Kg01W8+nm46JxFGEFXALRi7StX5h8tqSSYpcdAbKhMD+Q
         wMjYdzC5c/AgwqCFw0bQ7VvB0E7jwUg7K6BKMqML5IO07h3SqD2lifEa5koq6y7hWMad
         aBUTnBGjEad+qNLEHNj9sZpx0srK5gaocqfCHKnn8ReW5mWQKRM1QsEf/W2epZqoksKa
         HLVG7Gz9/Et1KAID2nbdxStOtXDNi9na8N2T2DLurqH8oO3YzSZeluzbwJA5fWdBbLP4
         nIpWVFLNT5KrHIQsLkWBxZNg7aW0ZVZPF9pzHsfDqwoY5z8w0hD/EB0lOb9BeBlolggE
         QJYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/XSdTsuYtk4I17JBThHOSKurzBCGdE1eRQCLwvQ8tHTJJCPvYLKXan0VyhNOCScR5svPzUKdeZ/Q==@kvack.org
X-Gm-Message-State: AOJu0Yy5wC4wEeYWY7uFBmkh3la1aZYe9dPfBPO0cWtOSUjpHucXEvsi
	CjkkKD9DS7dHHEqNUJfPcVOU75fyvlqyGA5leVTaOYnF2bFUSsIOIxY1ZPqgzYfh/clqrP3mbXa
	M+IiMt2HzrbWnBX/IzCSGPh/ffJMyUcUv0ev5W5znqHjoIQUBrA5k
X-Gm-Gg: Acq92OGMiGQqtMDjpXuHHdA9WPDX7zTVF+vN2+yGuw11SoUlIf6kOiOnp+q5NoLJFeC
	VEycVxzlJkff7lelysg4sd1foGPDMHpP4EOpxsgrFxFVITTV8fC1WoqdUqec5/isIpgJ57gcrgV
	nZanQ+WaJTKS761FdfY9vTAH7bmKu0Cm9b6GuE78q4FHjGYMwwl5bePSCM4zO4wlSNyc7tB7e7S
	/K5kIsrSQXyqImU0HmaNWbmXQK53x8l/iWCBp1kjrDm8OW+O5olmfvTxJ9jc6eKxveku9h4s9+H
	92YAGuY/wpKJTHsLwwIxMoSLcySvQIGFAtFcBa9HMjidLLu4z9VLoanJfU/bDplRMMRe0QmOuxn
	0hQfjsexy/dx7tPZsZ/oxz5K6i7ry4YCTUpo9vKPu
X-Received: by 2002:a05:600c:444b:b0:48e:706b:53e3 with SMTP id 5b1f17b1804b1-48fc9a0231emr7733265e9.1.1778619982359;
        Tue, 12 May 2026 14:06:22 -0700 (PDT)
X-Received: by 2002:a05:600c:444b:b0:48e:706b:53e3 with SMTP id 5b1f17b1804b1-48fc9a0231emr7732775e9.1.1778619981835;
        Tue, 12 May 2026 14:06:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491cab9c2sm37226840f8f.31.2026.05.12.14.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:20 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:16 -0400
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
Subject: [PATCH v7 13/31] mm: alloc_swap_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <66119d3bab318d74c1586b99dd70fb74e2da1ec0.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GBTyMXwjMUAmORcOgDpkIEmiPMyM_yHAlcUy_udyQXA_1778619982
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 67D014000A
X-Stat-Signature: ydrcxek63pn5js8aoi6htjukg9taehgg
X-HE-Tag: 1778619985-785959
X-HE-Meta: U2FsdGVkX1/FqUgD2GVDRRNdSzsAyeccH48ZPpYERZI4j72P7o4cp6TDINZ5c5x8ad7AZW9pJpQ6TnAUHfAISSUCpMV9y5O5ANC7gKhQbI0ds2ZsaMiaK1SxhJX7B/GvWCpYkI4/dF1rbieT4ur3drJUyWc9mm2V//9reCOzR6N8hNagdbRIxNzwdwxqqTv+7GYp9alBmX8Yk+OOwKsh0k47iyD5rxWM8AQ3I7rCOHm1ZuaEK4mlxe5Y7L4zBc3NUPRBjEcMibx/3kQHq+1WrDhzctJQAfKPFMsgO5YGYmSsczLx2z9R4dl7Yo3dH1Ohrle8v9V1RwcxwtDyYYxQ5KntYXfatUUAXr9vlDvTp8Q/a+7FhoxGt6Q22iwIa1ihc6/xmAWXp2mPRqF8kB7tsQ3T7jKI29/srPE8fA4OiX3S6ObnXE3xHqC0vebtwacZm3+Op4zAuKmtBMCpo6yw1x/mDKKYpbLkjkgVTEfhdi+By3HENa6jnKSdlmhSvtPmeFfv1OP96hZFUWomavUdoeREthCSExJ25sHjNMv/+U9PSQ5lLULuGQfzkBz6DrT+oFYADs5kxRTVMN1pisLRLOAfcfs6UQ6e4/Zqodw0fq7EuOK/s0HUJnPc6XRib5GzTeS39+Apsgag+R1k8ZrVQ6zaODVNnCu/lmI5OP99Vbr5XB0dRhT5a0eWyqt5l2scGM1AfEiZRhDvFL9G3GLSy36khNMC9XxyXw+3uaE2mZ91Ke2mkLNuL/gWDAcB7O4YM/vTex+1iEEVKzTXPxreJAjcFfZmiv1yKMNfxHTZCAqsZRI9sUzV/Zl1NVwQEjJZ1pt0iJq37/5qG9SyVVYYsL/031g7DKNu+wys4otDKA8+qsav3qz9EjxagFO3za+WCGiv9Ps4fEDylWCecok5J7KQcBevYR/JRTIT7ykJHjiSk3mGUq3r6ENEGcs12i53BoUkuXOS8QfNV0p3xa/
 RFXHza8K
 9GQnOVo2xqb0M0VtThltcb0Um5LUAzfub3zw3rAyEDOhWzHJboPqDqB7KUWJg2RJRxFTuo3TXFp9rDTj12QgEukvUAbCrQxWdGNnsAEzNaNOIMq2pXD2T4EUzhOvRY6wmU9mi1aFtQFwmuNvDUB7dofZpxQTA/r59OCVPw29BZW2Q3o9ht/YGXQUbOBf0yO2BNeNW3PMxuOpbkx1xi/ZIdfvGceKLtI98wMUsPKkyzDzwFDyBlYVplp5hnEfGy4VOQyR56R1jkRZ93HnFLzOa0+T7TfaO+fVCFuuX0xNTGbFoctY9qQaqRBZ/wp4FuItnj4RAttZh0dl86E4cI8+jikpZiZoKqKX9WpOF13sO/OkmKhdOsz5XPYIA/kx/LSBUXbpuaqBBXMuFAK1YLcNs3K/BEkeWfLy8TxDTmp3qIXr9eykCZkIo/6CLgP23G/v8rVAzWuzaY3MBAhU42egmQsn7JDs/2M+jQrln
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


