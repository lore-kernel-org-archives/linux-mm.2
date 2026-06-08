Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D90ECD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FC56B00BA; Mon,  8 Jun 2026 04:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0876B00BC; Mon,  8 Jun 2026 04:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788946B00BD; Mon,  8 Jun 2026 04:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67E1B6B00BA
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:38:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D2C41C2B68
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:43 +0000 (UTC)
X-FDA: 84856094526.03.EAFC72A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D97B5160007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FgVBcoeO;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vosxR5Z06o9BwR/z8OHSdoefhvjInnjhiEJ23p/a38w=;
	b=z+tNxY7CyE3GqkaG2H540dpMSnGF9vsuM0qlzqj+c4ZZYmEUY7+QzWZUSoduVKEYXMAYQs
	epS69ZtC5jb/A6KrbyowQIlDbPcJoJnui0Mw/U3rEWIGb5zTz4HYuVTyHkoAZ7y6wLepMV
	JeiazLSVqhvEXJGDwLca0+JbeWR8Sk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907921;
	b=4HTHULU0AvCNvYkz126MG2p2V6wHApbxbDthmJ8MEXihJpXawTil78iC7A2e5vSP+0ZNha
	q/CeVC/iEdPGajvwo7QR7jAqjt9eqOPEXB436ek1FEO0iwie5ZcnBwfpP+XO+SKO77IeSL
	CVx676Qt0Mz9jxkDwFVZ/wftQkfKaPI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FgVBcoeO;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vosxR5Z06o9BwR/z8OHSdoefhvjInnjhiEJ23p/a38w=;
	b=FgVBcoeOakn0yVdM0k9ezq+vOwH6hwaYVJfu0myL9+mrn3VDHcv1cEvZbIS6HJxesOj/pU
	CZF6Afz2GWexOWT+hduGA8DwpJX241XrZagxUKtGlLVSB4pY5cftOUqSqv/cfH+gfYLTnM
	1DpIKouKqHjFGyi6l/VbY1fvs4dPdKo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-AXh7mcLwMlaQ-r8tV018NA-1; Mon, 08 Jun 2026 04:38:38 -0400
X-MC-Unique: AXh7mcLwMlaQ-r8tV018NA-1
X-Mimecast-MFC-AGG-ID: AXh7mcLwMlaQ-r8tV018NA_1780907918
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490ae4d89e2so40911285e9.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907917; x=1781512717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vosxR5Z06o9BwR/z8OHSdoefhvjInnjhiEJ23p/a38w=;
        b=hHbbiMyCQ/RVavDZugqbjAPW4oljYNgQ5941JbNZ/oExlM3NwNMb/fkVHjVQIVQYLD
         QZ3Np5nfnDmmCwSkQxwos8uJSrDJ8Y70PPa3Tt1HupCxYMAvPeS3jemkjPdh309S9wZp
         njcNtlSVY5O5/eZ9Jkz4qcwxaSM373V8KrrMEWd+iIYB5EmZK+4I9n1jzkN02P+smJP3
         sU37lEArImYDZHRjtjCzqgRauECa3e2M/6MJt+ah8cyQ6J3unExcY+ZObPxbEOkZDivA
         nfYME124KTObR7dkKbHRHktbbc186FjYwonvKxoyhTW8DCdHJrcQn0WIJT6I+qZcL9yP
         WnFA==
X-Forwarded-Encrypted: i=1; AFNElJ/BjiaK9lHFZ6BOCgpWmBjeMR4vj6sTysdYBmxCn/yWReoq/JpqWPq6ilZysKMS00dSwJA83a/Gsg==@kvack.org
X-Gm-Message-State: AOJu0YwN0xuttbqcfukMP0F47cZMdZ9q4bw/tyG1bgzHG6vnhV5294G9
	MZLxOv1BbnaQh6naniG5lBog/HFPBkAQ/CIJG9eJn05GRqW0kQX2rE9C+pYpAGtx6Grq58mfn22
	q1kdzVKFVGFLZIDaZWNK2nbHu8TIhKItFWJTVfUcxjyJhiP6yFch4
X-Gm-Gg: Acq92OFZ0/fHEIiPVprym9mF9/qH3OIIeYO4mUv7UQkhTg1hfmTVUx2l5AvvvTyjYAE
	yOozjWqBrn8BRxDCq8+IAiKWiuTYvxyzY6UlD4Fv9VZf7qpVjddZMSfKYQuRKyZLdSQczTP5xX6
	6jlg6JEW1SVjcSmTLpWRKcjv1HFTHcNL0ne/iTcrj+5q1VhsUYzYIyqe4du/11eBkkm1NlTet84
	uSG0/KJUzT0r40su+3w74B9hmE5gUEohP7PoWP30VMfJdnKPI/aDtTYfx9Y9506GtWfzHCBftYD
	CEp25VSXeaH9UOT+gf01qJZxSY/ucI2arPZdXlWTq9IBpmR47kWNBpC2GzQeX9CUgA4JTls5+Yn
	DNUKK/TPb/WVgNFy3Y/yUixk=
X-Received: by 2002:a05:600c:34c9:b0:490:688b:f10d with SMTP id 5b1f17b1804b1-490c25b3549mr252414955e9.7.1780907917514;
        Mon, 08 Jun 2026 01:38:37 -0700 (PDT)
X-Received: by 2002:a05:600c:34c9:b0:490:688b:f10d with SMTP id 5b1f17b1804b1-490c25b3549mr252414265e9.7.1780907916933;
        Mon, 08 Jun 2026 01:38:36 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm50788900f8f.9.2026.06.08.01.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:38:36 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:38:25 -0400
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
Subject: [PATCH v10 21/37] mm: page_alloc: propagate PG_zeroed in
 split_large_buddy
Message-ID: <d8fb16b7efa1c9f67847e2e92300d6e80263ca1e.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GUS1MhLWFCiaBq_3xL0aTGVLoZKb9gdX0oalVd57m_M_1780907918
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: D97B5160007
X-Rspam-User: 
X-Stat-Signature: eb7h6bn65s46arduqq8167d7fp5fbtrs
X-Rspamd-Server: rspam08
X-HE-Tag: 1780907920-373801
X-HE-Meta: U2FsdGVkX1+xGsURvIBE7OxRnuN7IYyEjXkjEpOQGARIhQl9kJyE5YoLN3KiBjEYOG6GXNfASv9NT2mvhEK6BCbfQJz4pXXRp6qOkrP/m9bzrsyTef/o5vwkDgSyyKd7/QaKT7BrXhRIsWySLKKiOoXjWbRc9GnG+KV55r5MaDTXzTZRiKptvio33NP6XIslq+aZ9UROmUqelnRTlpdoVNHD5dbxuRJ2CnfQbAseR7DkVReqz98QlO7m1g82V4/CuJMtfDqPVmxyjnc1lAL2r3SHjW0lc7c/tml9f/9Nh0gdEZzBNk33SIwgVuskXv7KK5m+t7dlJAXrLJGQRHtaKi+5VY02QkmqOfSSLnYU5b+JieEHhhOE0vJebWSuQbrndvMypLwSxWkx+inAanEoFVDjPDqzEswaMREesFs5HI5yc8K3MPDm2iIs1CPp+Fq6fMgSHoXCa5Dte+XAQPOuCMJYXjMvyatmPRfhQKVqhXQVT5xR+EtX0ZuJEmf/46IBT4jgUV66TyQCxYu4KJHQ7lH3FHCWQbuaEvlNV5yloO/Gr5r+mcGNMo8KQn9d7WXGfXLz/oa+iB5NGTU+fz5OgOSggfY/4W47j4+PwUl6UJHbY4OgGqK9b+rNuOclUu2we/GcNal3IWZ2et/4MD1+uxgngc6fccyRaM0Cw7TIk1Fb7Xx2yv1WACtdxF+928AWefhWya4U/FishyCjtBcCZzo5vSmCdGj176y4E4BTM43ZBZsIkeeb3QX/iImDBGJn3N+d9NhKiJDcm20lqtOvIJOsBZRQAM75VhNLvl2c9CO8TBEOjiL8Tp3jNebRJtW6lIM+FpTOf5co+/r99KJKQirKElOlGp9/GP6O/Bbb6pmK3uhtMpx3gcjH7J9mAne3Z48SgBQPME1JhfWWfzq6BxBdr/q0RDtBAotnZeWPvjD+YTXmYkWHvOSgEs24yRS/ABkppPKS5mmsfd/8+xh
 IOH4DBtw
 vrSss+XhikV8rdDrpRaC75bD7pfBa3NtGBTrX6jLT0zMdU5IR4RKEJcmPqcxUqQvBWJF2rGXoq73mFQu0Qhbxs19KWS26w9HAfNxAtBmDUFY2lFXRXDKGEQdH30qUF8zvfbT7cP+3wLqr0OGc5U5GfeBCynZkp4tzKL2czXP6aWsTMTT+nG6earnGXDrrUItLdCXTMKO8ZAH0wCQxDzluSbx1FqnfmuCAzgxZ7yxgT/5J2xMZJXv5a1IJIVyadyMbiWSlT7gYfS6iWHYKNmRvEy0RftibMOFRoQ0Wi2WTl23pBwEhK0ye6O7MQqtJv79qokzzR7Da+3uDh1fTpsHIILWccBQoyrZRJSJaGDGxRmcfPndyJjfEVvygNr0f4GvspGgJVxvJA5LUeZzvHU19k6uxlTWjrf0am4yTcNfgX/AQ1yZMVjyi/gPco9CzbbeA9EzNOOWk2zqFkaOvsBd12haVsceTc4TyCs6h7QMtSe5c77s0tTA7/nSLoV+uV7RwPihB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting a large buddy page, propagate the PG_zeroed flag
to each sub-page before freeing it.  __free_pages_prepare clears
all flags (including PG_zeroed), so the flag must be re-set on
each fragment after the split.  This ensures that the buddy merge
logic can see PG_zeroed on pages that were part of a larger
zeroed block.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7a6dedd716e2..21f9e92922f1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1520,6 +1520,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 			      bool reported)
 {
 	unsigned long end = pfn + (1 << order);
+	bool zeroed = PageZeroed(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1531,6 +1532,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
+		if (zeroed)
+			__SetPageZeroed(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		if (reported && PageBuddy(page) && buddy_order(page) == order)
 			__SetPageReported(page);
-- 
MST


