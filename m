Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71CFCCD6E53
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6346B00DC; Fri, 29 May 2026 11:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD7E6B00DE; Fri, 29 May 2026 11:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3546B00DF; Fri, 29 May 2026 11:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1896B00DC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:23:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D9F1877FD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:32 +0000 (UTC)
X-FDA: 84820826664.25.5810B56
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 353104000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pg2zASL1;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vK+J6BapUtjwGwdYlifbIYhLZtsZgN3kLB9idS28qTQ=;
	b=1DBDc3jFHQ9NGNwvoCVgm12dCkq0SRHfNPVSYF/NdDa5j/DLBZOmSkqpLDFybYoWLLiWmy
	o7uyONX+tC+KcY8VBQ4e8wsKE26+0C8cCve468MY6/CnAh4zzop3RQQLzUqh4VUIPGq1+C
	L66ClcH9odgapUypPLplvJH0cBOd6U8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068210; a=rsa-sha256;
	cv=none;
	b=0cI+Y0TDIeK5zM6AN3NCC/gEqGt0Ian/DFj/g/cGk4+gUKoP/PBSiFU3s0ka1KhlNldPwi
	xgmCX/OPZQXD4LgBy9DgVJA1FaA1krSR8CYUz3GLP0+VIx1QTk7bnAeNWx8JGF9LFGZJd5
	6pV0JRlW0B6p5cwl0qK/9+E3yGrIi0c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pg2zASL1;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vK+J6BapUtjwGwdYlifbIYhLZtsZgN3kLB9idS28qTQ=;
	b=Pg2zASL1T4cBF2bJg7he+z8k68kRb6XlEXjnEE+uKA8CGYuYyJ3IXfR/ABBrzJ1q1j2cVj
	v/WbbawNVhNkh9qYLhE9wBghBXqXgr3BmtVAhqKlBQehg+8J3IshWy/AdvlyuWIw2Qc9cw
	bQtpmSc9sdIu9ODzgZAGfCRQaC49m+4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-J3zYxdSjNOalakLgkMSObA-1; Fri, 29 May 2026 11:23:27 -0400
X-MC-Unique: J3zYxdSjNOalakLgkMSObA-1
X-Mimecast-MFC-AGG-ID: J3zYxdSjNOalakLgkMSObA_1780068206
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4908af8d7f9so20082395e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068206; x=1780673006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vK+J6BapUtjwGwdYlifbIYhLZtsZgN3kLB9idS28qTQ=;
        b=jV4rBH6e4Xv1dPtXxCJd8B/5hvpsz1WewGHQM8Qp6iEBtWqHdtXVCcjgSBCiFmxn+m
         /xcsRmiLjRNb5arUCcXR3zcdjEuiwOHR7gmDmLQxXomKASv5KM6Gox7OJKX1O1bTBufU
         sMgRCTZmb81jnIJUCJjrue2Ufb07HrwZC3Tb38YBBm2S7G6UPRtdBRXWx90lWtv7zXBh
         ZmT3yVZi1H8uJFEiG0ax5LPxsljHWvpZFw9pvmGtFE0Ugxt2k5uLIwLVaAifk4lsFsTh
         +8rmkRMIfXN3186Ue5NGgMOVT/nIHmLAy9HKl4FEx8Hr4wvsndfNJnbIZKMHnzEhGy9l
         uGdg==
X-Forwarded-Encrypted: i=1; AFNElJ9jDwh4lySg/9GqPrhjHzaB5qi7z8seGk/516pZJ2laWN9JKCpLvGvUk7knRC+pmEFqe1gWgPwm/g==@kvack.org
X-Gm-Message-State: AOJu0YyXr6MTpy37Uqp14t7DM1tyI3zEHX9gF10r89/ouuobZFrbHsy/
	36fc6rg04aI8GtfdBXnnTNzjTKPjDTvJWu1LtvRwbtw9ZFWZsPoyFOP50eoOe/mUGildcj0GdY3
	m90eApXEw2X+NdyGLoNbGBnTxvxMhVIJpPMhyiXTcZ+X/fnQN5Lwa
X-Gm-Gg: Acq92OGfOyTM+Xbk8neM7F+StktvMgUuYd0Fi78Fxrw3HjO25SE+kM+NJpdKVCkKpHh
	sOv9Q3E7bGcRRN1bvv5riZP4rOkNGGiTWpt1U3h9iD67D0cP161THK6XaljnCbAtYy5NapzgGth
	uvrv+PXnI7lxL004STR547wWhcO4AhvkoFJZHE6/YgVR4e+61bc1IUI15gaprCxsw/+k6WBlX5h
	nS436ZZf3hlKfYTSik2XivN0JpIzAD0v+sHQhwmUBVHu2ErwN7rKMJKy7dS6+hP77SpYykM7Obt
	Jm/cwhLkrN8JsZFHCbYYyEFgQVvA7aNsGR8ERrEzhs+KJA0zWww/QQGvQE/yzXkmxtNejy6zHdt
	PXxifyx2z1U9VDECgg94IBj4tdKaf0M7fnLcZ1TktJZuGy8Dj31hbVA==
X-Received: by 2002:a05:600c:1592:b0:490:58e0:f466 with SMTP id 5b1f17b1804b1-490a2977dd7mr372025e9.33.1780068205605;
        Fri, 29 May 2026 08:23:25 -0700 (PDT)
X-Received: by 2002:a05:600c:1592:b0:490:58e0:f466 with SMTP id 5b1f17b1804b1-490a2977dd7mr370945e9.33.1780068205067;
        Fri, 29 May 2026 08:23:25 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b47eesm4815815f8f.9.2026.05.29.08.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:23:24 -0700 (PDT)
Date: Fri, 29 May 2026 11:23:20 -0400
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
Subject: [PATCH v9 15/37] mm: alloc_anon_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <552604621ff4b05b9ebb69ca75abb83ac8c0912e.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iaBVkaTzgPQh7ZMU73i1lMUp_6yJuHsflmQpDLbZ7Ng_1780068206
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 353104000C
X-Stat-Signature: mricth4fbxhicudizsyf5f5p8s4zs8hd
X-Rspamd-Server: rspam06
X-HE-Tag: 1780068210-401374
X-HE-Meta: U2FsdGVkX1+f2pnUVNqC9CBGdrTT6Gz3AxixLQKaFGA1lYAqMXyK88Qv/lFm8yoz9SnWGxb+OeIl4AurjW0sptv+pGWk98m/PUJTcT25mXfwiHx4461OHGcL/rvB8+B4lS3/zODd+H2vdQgbUc/hF+I16z61Qi2+QbaEXL62uvIIAow3V/3Y4LFjy4do+xLWogT1t6NWPCZBtekcsNcRcX01QcYDs29F6/KxhZin0Nr0JKYiB9twugUdAs+SVWYBei/58t03C8IMCwKb9lF6QlP6LWLoctPyN+eSi9aEzYgkhoX0tTkYAa0RGMEKtcOiTBsOuqyjSYDKYcEzhqbcnTHkC2fmJD3pR+7a0zC2qNJTDMkosyEMgbRVJq9zSiXnRTqbwwZQbSKMDRfFGkmBx9ZVLv9ECQlD9FXEKPae4jAj88gh+7/5r9HmNjJ80xDuIQDOUuGxWhcQBKwApWWEA4CbjqXp0mA2agwXCa66k2rLTWc6NVRGmfgqdvm2iDHfN1klaKOl9krJ/4/AIj16iGRfle2Pr7JPkucwo4exYRVlC4T587CXMJQGNgSvGGhWqAGp3uqURssSsAc7LxOj6BXw6IoKnKtVH1+TW7lr5wE6UAOx5HA0Hb/aVVm7gl3hJOhE+wT1ZjImA2WYFbIKIOHyrnpIcGWir/L4C20eL3uTvVUrMwYFANri3xPP3zPvnTQyKBzamZTEU+d3fqTzNNTSnQZrRUM9T6FscQxtMKKEkYMJeEHL7Krssb43q7Q8uPQ7dLwPTWYGyGtPV1HacD0jCxUrRVti2AHQlYY9rmCBvXYT6mMVfHoJieeVXL+eZ8mCqRIOyQTjJmA1ysTMaX6xsFsdltPJx6NBXu760DFUjOaVG0zIUrWeWEGYcwDUiNOWZIw04F709O0ML8DEJWlhHGYmQoz3MDCedo11IyioI5K1fCe9pup1ZKjQ7tsQYzKz8SNS7Mg73aKSzoM
 y8y1LNRd
 sc9XWCMAX4DIxbaFx4cqAe+WEaIlh82r7p014MYyEJVC780lc8gDZLNnbAFuevUKxNfTysq5FERVqZI7jJcAq0uzS0IwoL8Y+sjQOWVOqRdxx/PiHhIZVRctgyzNpie1NlG7iXfuheplE/cp9oX1xUyW23QdBIhMvTE/RD0/jyz68zr9i8GwcY2yHtW+nbqy/mAphE4YMSDewcz6Dhp6C2sQisGWOTNOV5rDCdEx0cFCmiOoIgw+DgJlELlikpeZSnoRA2c/WGIkz5R4M8SQeJ7Rcjd6lp57nqaX4Ej0Xb563UDG5BT8/FwVnE9coG2PvhBzAK2WGJ9bComE0FI/uh/oBEWbFGN78wdYE9XhU97AvIwPSuf1M/YAymDYr/Wcke3VLoaNmMPh6DKM0CSuYmbOOJVv/9y7S8/5gmVOtgBsqMKkFKoP4vYa28lk0CzF3S0zF/QE41LmLyJHj3UyphrwqPWVpnUJQObfTgT9Wx6MT113VWkhlWQIAUn9H8rR+tSxSAFKP5m5eF3EFJxK4l01TH8ZkOsRM/LMu
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


