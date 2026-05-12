Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5627BCD4F39
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFF66B0096; Tue, 12 May 2026 17:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C87F6B0098; Tue, 12 May 2026 17:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA186B0099; Tue, 12 May 2026 17:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D90416B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B7731C03C0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:37 +0000 (UTC)
X-FDA: 84759999114.07.84C31FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 48856C000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VLtZihob;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73ni6E1OiylZPcnUbU0EX/Y/PdtoGvrjv7tOovuvhS8=;
	b=M63HnTv6tyMccImsA1Sg5qgxhldUuthX1O6HVEVO2XGOhWCPrRbDDCqtDuYgMKwt2mRNWg
	uIl/i3xPEOUP6fN+NpHnc04icZZWeBU//f6bAeprLiY1fxgZ8PAvrQICfHfpEeDUBEgfwp
	qmhf6IsT2lGJ1wkEtEMibCwJGnz/a5k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VLtZihob;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619935; a=rsa-sha256;
	cv=none;
	b=nUmlX/9HzOOXtwqNotmnWjUeN8l7cMxkZrlS3N9JqoZoytJr3l85YUKpM16rGCTqokZGbo
	Gsh6F9HglUwQ7GGkZ+JSKBs7avYqE5yLhK+g+HhVeba5EWqrJ0+UheOiWSyaDADIOVRbL/
	ObacxSHzdI8dFY2gKf+7FzaX5DfAiUo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=73ni6E1OiylZPcnUbU0EX/Y/PdtoGvrjv7tOovuvhS8=;
	b=VLtZihobdaKSk83tsFET2o3EgpbIz7mTUHTfnCEjx5IHl41Or0Gs7kivD4sD6qKyqzZsWE
	8zd9xrTnjkzl5H1m2Q2JMUE8W+51nAVs7HX056wptkuNg6T/CY6WCb9yAm7RHv1AN9cnK1
	8+UieIhaHeNOsMPpqOHh2yuurzXkAWQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-zwHHiLScP-arn3kZ2qV7vw-1; Tue, 12 May 2026 17:05:33 -0400
X-MC-Unique: zwHHiLScP-arn3kZ2qV7vw-1
X-Mimecast-MFC-AGG-ID: zwHHiLScP-arn3kZ2qV7vw_1778619932
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43ff19e54beso4179555f8f.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619932; x=1779224732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73ni6E1OiylZPcnUbU0EX/Y/PdtoGvrjv7tOovuvhS8=;
        b=c6/nIFUVvGg6v9ICo0GB6+wp7UHW9ZQaU4GkV1GOHs1ISC6UaaVXUCuhgz6MdcVsqu
         BVaaAo8003e/Mf7W26x1sx6MT54qzZJ0t1nKYvFBRGDXdBvYSeusSdQ9oBxlJDO2GGbd
         MJHseWbHLkD6h3+wXwqxxA6tikYxLwPvdKgqGhAp/GdF8xAsPRU9gM58iHnRZ5QgqbLy
         sKDC4ThWO4yRi0MY2owQywR9OqvrM05x13lJylb+nvRXW+DVuFPRkumocmjVkOy9VbHK
         KQMGscP3zdvI8r2vPSBKGdjYUQP5h5rXjZXaVkcMowGPSXAeCI5P1tCraTRS4T8f5w2T
         bjog==
X-Forwarded-Encrypted: i=1; AFNElJ+AMjoAhvRKuD92xOUiR4Bux7/BgQ3ZeBNAemhY5kYsTWQ17RS0lsFrxEBLhp+e9J+pQpJFCI+rdA==@kvack.org
X-Gm-Message-State: AOJu0YwbFjhXTyEhlZFsb1AbUkxL4kej9sxUuBsIi0AxQOklA9h/Hei6
	SCP6kZEiYuJk769tOKfHp3F1l05cimJaAGD0WMVvF5P+aSGuXEKmBfj5nle/twDG3bRdgCrAvkn
	PBYBSJVKMcIfNTPSIBWfIzzTSvd7dtL358LiYFTCIB1mzrlcf9m4K
X-Gm-Gg: Acq92OEQfhNd5ruPImjFgjVPOLUF4KWOFsxjfWpo3Kjj0xUnNoDKyDClixAYesPdOic
	2fT+5BYPaC7mfWJ9hs08MZK7spboklCkl7VE+0zzVY60y7RuzY2PNQTCx4BnY/4JTrAJb3o4ySM
	YBpXW9J8a3mpsl/AHdRwcASWcSRZ9o8HsdVuanIMi/qDCyr/mYLajBXxqJq2gQk03t69eAhom8H
	baOT1FYleEZSQ9sy/zJLYB+fHk4TdpGfqM4P6YsE2pod5RPcGjK/x/OQZ0xKzmBKs+IOTeUjbIe
	dRL9T7AGmqxjbbwlWURP+fWq6mtcLwBnjyvIbqlssKRVWm0IvJXkLFEs1HnPLFlNBjlz2LcagUf
	fLUNQSIukSnCxKFcvkGQHgs4jy6Nx2wAmq1NduYl1
X-Received: by 2002:a5d:64c6:0:b0:448:659b:abec with SMTP id ffacd0b85a97d-45c580ce38cmr505569f8f.8.1778619931834;
        Tue, 12 May 2026 14:05:31 -0700 (PDT)
X-Received: by 2002:a5d:64c6:0:b0:448:659b:abec with SMTP id ffacd0b85a97d-45c580ce38cmr505522f8f.8.1778619931288;
        Tue, 12 May 2026 14:05:31 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548eb75c29sm34124809f8f.9.2026.05.12.14.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:30 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:26 -0400
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
Subject: [PATCH v7 04/31] mm: hugetlb: remove dead alloc_hugetlb_folio stub
Message-ID: <0143c5e2086fccb05703500c9269a899d4784768.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y8ZAvp8oalPBrTj9Tc1cMAh-eF7-CS_LN0xM4pBfDJo_1778619932
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48856C000E
X-Stat-Signature: iaub5k53bgnttrhj31smd14f794b56wo
X-HE-Tag: 1778619935-524803
X-HE-Meta: U2FsdGVkX1/qM+fLfqqUvcpHgR4JK30CcXvH/+VijYv0hNjjaU1MpkQXjb3qLTOxYyWm3WIiHo3aTlIwP0To4hwFXRaMZGk0yGikL89g0NUWykz/Mqu3V14oqTa4kujEoBdEvBT3g0Rm0siU2CzgBk3E07z9+zxvCpXncD9Tf3e/MdRdO5OeN0ilFEG2tmaMV1N8v3eqp9dq3RT++poLPpJgOyQ+bUsu/nB8Sf6koDYo2MXqEuVZ7nTdSLHegkvEI65W8DbBznygU4ulN2aUino0dqACcJ06zexmilULu3QUpOhxM7xqidCDaY3TpyqFcTU6pS6rhAGUfhdbBbCI1E0fqpcNZdjkUMog+Rh2pBZ6QF+xq1YXP4AUQthTDkP41l9QAIh//bDi1HbjzD6efVku4vXNYkOmSIDpKaP5Ek9gbMEeKZ98nL5Q+5gGcuGqe6ZqrjgjOGMba9KRPJq1kb7bp0cAAtDrfV1NQPnMRiepoI9/67C8UhpOzXs9GDd31vk+NGPrkUGQFxk4ZNGASTb0Z0uXNo4Ksj6qPwxsj/kic7ZlDBE7pu6P5d0ypRmpAPJaO+c5UrWZw9vz0325RCyETWSRCReqbS/VciJiGBTpStmf4gLqtKDYC0PhmyDnNIQLUYL7hQ/Ra+C3+jKD76mkJiFYGQpXD6HMGXAdVUVvqV+xbYWA+F4NIU9RYjBinPvpBjOMZQnwzjgoprOdRTKz7p5hWXpDMqmi53G5/Eb0n7cCk6wB3ESQyH0bUGH8AoMgjeppLLOY39Fb6sW9Hw2bD2U0A1zXJbRjzvpxZucLn/HYlZKj2qQ3hYmIEYVuVdb+d4gtd8Gyat4Blf23DmRbm7r5yXblrPEtB7W93ANLr0HI6c46yAN/vhthKVbv3yiCK+MXShyFDMj1GrVd4dHs4vmVu4HOcQtjq+xMHK8eupddkEAdyv6VtB9CLuWYQO+gYsLQ6NslNPeyVR0
 eDTEmI44
 JMwTVCJ7D0ekR/KXQ4RU3MZdmAfznCmYjhLz0PnQ0EWZ2c4Mccs5MPWwXEpDAAHWQGfGoNw1ymQKeVf7Z1gv4/H/Id5Jk7YXjgiwI13bCSUBeQV2KWnwGVVuBWNIuxVEw91obbtUEPPLqtlgmWmsD4QCf/dcerjC+Hb4i9c7eBXinXyiQoU0uV33TxbXpRacaK8TqvEj2VBkxgWG/pMtRATbbI3SJpJSd9cg8Tw63hT6Towe/nBogsczCPcAbIcyAve+pkYM2CfQp3bay7jAXcrdhXLgaL5nSowHt/SKYBy2vGx/wr1ZaJMiA5uda83prr3HKE3dzwQ7pwVk4yLuqE8ZSpXKs/r0iD6PzXqsuVk6pcjpcI6RMU7I9BIdWQ5QBXc0HafPCcUwXlqXvUDiqi/uP6IBcoomtoy31sOGix2BUaEScz+JXKxgrwwDdVx2kn7vF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the !CONFIG_HUGETLB_PAGE stub for alloc_hugetlb_folio().

The stub is dead code: all callers are in mm/hugetlb.c
(CONFIG_HUGETLB_PAGE) or fs/hugetlbfs/inode.c (CONFIG_HUGETLBFS),
and CONFIG_HUGETLB_PAGE is def_bool HUGETLBFS with nothing
selecting it independently.

The stub is also broken: it returns NULL, but all callers check
IS_ERR(folio), so a NULL return would not be caught and would
crash on the subsequent folio dereference.

Remove it now since follow-up patches change the signature of
alloc_hugetlb_folio and would otherwise need to update the
broken stub too.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/hugetlb.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5..f016bc2e8936 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1129,13 +1129,6 @@ static inline void wait_for_freed_hugetlb_folios(void)
 {
 }
 
-static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-					   unsigned long addr,
-					   bool cow_from_owner)
-{
-	return NULL;
-}
-
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 			    nodemask_t *nmask, gfp_t gfp_mask)
-- 
MST


