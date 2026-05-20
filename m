Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23D1CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4045E6B0098; Wed, 20 May 2026 18:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB396B0099; Wed, 20 May 2026 18:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F22C6B009B; Wed, 20 May 2026 18:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E86F6B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:20:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFCF01C0301
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:54 +0000 (UTC)
X-FDA: 84789219228.17.7F81F91
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2715120002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:20:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RfOkdqOW;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315652; a=rsa-sha256;
	cv=none;
	b=cxZhEw9OkIICOFor4gX11cRGh0IQovD43kgba1/L5AC3v085NMYBs2HeaiLoLzUMrutPPW
	kPyF96nWqcjvCtT9cMpDhP6JVcKAX0b3cycIWI9pngqlQr34BC2Q6HDgUH8cbKgUlrXfWO
	arot5ntzfpzUxnhWYoXQP3u6HaTKwmQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RfOkdqOW;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RnCcviTYcs0bJrQCPa7/Ta1tOKxh1kkpoqwRDnBft0=;
	b=w37CXoK7PEY65d222HXXsmFn6bNrTUvscZR/qe3a11wj6SFNonT5T3pMGl24OQMCg/hX5s
	UZ8EH/n0MjtPTKjTSKKyAi2YxQvtHGTB7tw8JWR4+8YlizBzR3A0IDWZ0PUBdiW+rElQKd
	cpXo1SSRV8mtieTUigHiCPVMMLGc0bk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3RnCcviTYcs0bJrQCPa7/Ta1tOKxh1kkpoqwRDnBft0=;
	b=RfOkdqOW78OKWBvrK7xGnQDOD/p97XFbmwVitA2wATN1GUxKW96GtX0nxattzWWNH66+qG
	w0yFCkO2KZREHxFkb9BuYVCipcT5N1mYNtfjD2XJTUcRaDL3Qk/mB3GwkuWTGK9mpGfVkX
	g04srEDpHY5mg4VCwLJMaUYyAvCOOiE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-xJh8Dft-NDGUgsNed0wrQQ-1; Wed, 20 May 2026 18:20:50 -0400
X-MC-Unique: xJh8Dft-NDGUgsNed0wrQQ-1
X-Mimecast-MFC-AGG-ID: xJh8Dft-NDGUgsNed0wrQQ_1779315649
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3940fc93c77so23255781fa.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315649; x=1779920449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3RnCcviTYcs0bJrQCPa7/Ta1tOKxh1kkpoqwRDnBft0=;
        b=GR4K4PLImDeL4QI6HjPdw4q6UBqOLXgPOR9aRQe/ZNrs682+XaLd0sbO4C2dp6IqVp
         BIuKL2a2A1N5HUUIeT3bo5EIPwS5hkfgedyq36jEEDRgs0TmclABvYEb7jTyFbl9sT6o
         ifL6wCFcoJOoGeMkf4IZz5GexadUS62VIVDUwBtY9fkSYY2Chsed5I9+rUrq1KFKJPmU
         R+T/QE+KSYdgh7pkNzlRoOuqUNe/KS3+Z9uKJipD8JYLDSt4KH8MGlIgrYmxhMjhju/N
         5Ulu1aSyE8r5IpSMGkErWYUlUA4m682tOM4/cKkWsXy8bRaQFs1j/XyZZgpKPvNJQiZA
         bKkg==
X-Forwarded-Encrypted: i=1; AFNElJ9mNYKeflUDeTQrBbCa9XPKvxjKdCnxNg/MnflUFvV9FCelclAyAJe/C1iqRkbqvHMO2cBX1LFuBQ==@kvack.org
X-Gm-Message-State: AOJu0YwYnAuJB1+d+NkEeQkfASQckm/WjSLJekE1m7HVBK7hkHoc+9Z5
	P73HNvWhE3jh6JGBhpnLnZkYe6gjn9amNY9YQ7FCd22aF8S5VQt6cox+WGZW4DZjy7zhyEhgxmP
	bThje84klEq8xHUj/saB5zE9S85ugdtMnhC2nKYzBUG3jv0lgB6uA
X-Gm-Gg: Acq92OGBeqB0PcY5dQTOAC6WNaGJu191XH5h/KFQnle8Iu1OdW6yXbveE6UfP/kkV8V
	qrW3t/HPGuzpDjQElF2w3ds+pUwSoJPJybTAcwjDdltteJeHkTzwVmvh3HUYq9S9edROG9t3qgw
	vJe5vixhPkPiq9Sa1/fzbCO0mVLRAFFKpY/MVbzSIZFkaLWx5UcgbBZXXYnd8V+Ds4hS1LKrcir
	RVmhaE2qCTZ42lQ1mpqeThl8PpFpAGmeFO3q7OUVb/AL1J9bMrbFar0IblSAosmIQGgvIto7Mvu
	mKeCfjfB1orZo8uSYi1PUG7KWGU/ZsZauQblLYWGMxJvAf5TcA9holsKbKcoxKiID9PYRVQddCD
	+7NMMTDaPVDHI1vexKR0dZvDLu5/gJcVNNZHLf8mweQg=
X-Received: by 2002:a2e:a593:0:b0:38e:98b0:3a7e with SMTP id 38308e7fff4ca-395ca5b175bmr844571fa.22.1779315649088;
        Wed, 20 May 2026 15:20:49 -0700 (PDT)
X-Received: by 2002:a2e:a593:0:b0:38e:98b0:3a7e with SMTP id 38308e7fff4ca-395ca5b175bmr844081fa.22.1779315648437;
        Wed, 20 May 2026 15:20:48 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395882cf497sm34824461fa.16.2026.05.20.15.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:20:46 -0700 (PDT)
Date: Wed, 20 May 2026 18:20:40 -0400
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
Subject: [PATCH v8 05/37] mm: hugetlb: remove dead alloc_hugetlb_folio stub
Message-ID: <5756eedfaae9e7b69a00da30428ab099f3941d26.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _h8lZE7UOUUSpfm7LMj0S2iVsLVUps2Ypsg-JeBlJeo_1779315649
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: B2715120002
X-Rspamd-Server: rspam03
X-Stat-Signature: 9p6nzwyi7fz41topjrtakzjooxzogi1q
X-HE-Tag: 1779315652-125387
X-HE-Meta: U2FsdGVkX19BXUdTgbVPAezxeCOe3EwVQRHT3ahRlXZANj1zsuZWyuQgkQitCMmNI6a4j3QxH/WcfdtQmDiEOTaruridDjhHXLRFR9XU/FcbrYOgTdC5nBJXEFZnTYSIHn4ti9JQiCCif+5DUirNp8MDH03xUzzXlRWB7tdFcR+DsBDuqyyY9ZQYxFQelmOYKoihT56Y/o2p1N11L/MZXUyJCPEoI+L9VSksUOyAklgiRJ2jmfX8oQQQD7lyVaziHz7eOxHSX56VO/cFxHSbJgpawAPGqzTiMgytcN0iq9NNiOPd0JeTCBVb4uN2UQAr7FGsfNOjhLbdUePaZQ+5jSV7nIKKVxDuctUVQ+BX1DGZm1dj3MDRqfyjrRXObWxXbQriMbnAXDgVnATn+KQeeoD9YhTP/ESZmlzvUl8HWTWRKjXtE7cM3OqhWD7v1qgazJB8iz+B0jAkzzZ3Kxcxdnq/7anZuFi6H5OdSwQCq30e2kqIkDLrcWNb2H5CF6kCBXJ0JZiYYzngZUuBWW0Rh1xowbvJTjfOmAj6CHE+g0FBdc3fStNXlDZuyryUym4Xl3vHBzUOTnV7f9cVqkodKlQBLtENSSnjBSC9+4DBZp6xM8lQPUihcZpZpLvTkLtqCeY+9lXHmpO/gPvK7bMGvQQBXbDvSjbl9bFho5le0wCPRPYrOoABnUzg/A0AG8v38k2g0fBklZPI8TRtDs6b0Qy2YaQDgl8FekCBV2Tv8Md1tSCRIFpmASNpUHUJWFC5krbkUCjFjf5kWkHAQppeHph39KoYsnLQ+0PJPb1hNsPI2J07mTMSjMgT2Wz7/yRB+NZEpDFyGkwMt/z4O+ypWtsBViYkcqTIbsLew0222Mvs/SdC+9zb8lOWwPoEoO9sTskeXPPGnetBQ4B+c5dQZ8kQK/bCnUL7caBvEazb8D6e6KUR9WBCKRELxg+WEbV9U4MG/xMuLoNdyr+Qyll
 zgsi/E48
 OqXI7DmFmxmO0gthLYjjWDZDZ4mLb045kvXA2vznch2TGuSAiI/i8lW3nTw6zBncgppQZJB71n4dvrvJYMPYC36bBOOelPqZbdYGDhaV7LTVAj1OkCVJmyUfawvkmGqEBHQe/i3GM21c/2g0LS5Cte+pC6KgwHCHraTnsj68ZFrwJETBZDEZkyZqK6Yf0EZiajMof+UeSpRwuWqRmymElthtZLR3aHzVMQZWy/OagATGEhsgex8F8OZ1AdNvNDkrxq6UqAVcIwrWwnoXQNBwNyHRQBm9Tc0QJuYI4YKDiAcm7ejgE8y/kFz9w89JgaVWZuvJVPGE07uzJHZiDkCbfI7mGeRmwSnziFV2q5V9Fg1ALDkxf9L+15wUsOCLMTeQOCq52d49hBgzMFNjnR3fQ4eOC3CZthM4wrASvNu3fCezWFF5qwYuvKhV/Not+koURhgKDOv9884BSkq53ve+wjB4439bfB8+Blj8coCnrPHGYZ2DAJV/H3++TcA==
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
Reviewed-by: Gregory Price <gourry@gourry.net>
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


