Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DCCDCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C886B00D8; Mon, 11 May 2026 05:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D476B00D9; Mon, 11 May 2026 05:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705066B00DA; Mon, 11 May 2026 05:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F15C6B00D8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06A7D120646
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:26 +0000 (UTC)
X-FDA: 84754547892.17.844C5C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C7BB72000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IA+8+nQ1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490143; a=rsa-sha256;
	cv=none;
	b=r3dJXwPUFNSHX9woBxg079ywEZEzKkQgJoilqaEYOryiw20H6WBkaO5PDD9E9wQd2dTyVG
	5uIzACQEFcDL/P6CYICaHBD8pR2OwTkXXXa7YtgFepQGAJvSjBYyAHYHprR24epHIwJraB
	CpOssijBMgR67VkdUWXaznFogRCUNvM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IA+8+nQ1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zuBj5G8Fe8DfsQghniXtZy4OYrf8Ud9rSYDvYLkW/0M=;
	b=0bZtSBBVT2n360TFpThJlGaeVfozDkHsAxmWhbo+cWwfQbXWHUKFZjxuKVsaJ0p4/jZQee
	Lbj8yYPuy5FP2F4C2atwTQapk9YEOgd3WVNDtzp2k///rK4bsndiMJQWiJEM1lAxy2Hlpv
	gtU6wwPQ9c5tDfQF8u+mBYX4UQLi3qU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zuBj5G8Fe8DfsQghniXtZy4OYrf8Ud9rSYDvYLkW/0M=;
	b=IA+8+nQ13v3L1EdFJZFXqjvuACRDWvZD//B/9qis5IxmRdwwvm5ueA/IoECff2bnLdNi4c
	Q4zj/Zj3vsMZzTxbrWCHjLvH0WEQbfeU717WY1jqLZN1Q8fJPM07Vmy2RkWGgOiZLn8hbB
	gUOyNXM/mtLEaTOqM0ctENfyOUjcKZY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-FM2YJBiPPTywhcJXrweYKA-1; Mon, 11 May 2026 05:02:22 -0400
X-MC-Unique: FM2YJBiPPTywhcJXrweYKA-1
X-Mimecast-MFC-AGG-ID: FM2YJBiPPTywhcJXrweYKA_1778490141
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b8f848ebcbbso339891966b.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490141; x=1779094941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zuBj5G8Fe8DfsQghniXtZy4OYrf8Ud9rSYDvYLkW/0M=;
        b=YgmUQtIuigkhd47zKN8aR1G52An1XrvO3yWAKZOFol/LYJmk2FHlVTyWyGvO3W5u3J
         myM++nGdBgORee3/z217YFcbWbRuIE7zdIRhqO/tnAdSlwo+GUEprlNtNkyhenrHMwKt
         o1Q/w9+GgypsGnYakov4h2pX1h/zQDYWemRHGnHj7TDjWoN4aeLSkZv3TCWZEvQd1aST
         brfiCK/1lUS/kdiN0APtHibpuoW5VFr26u+2gA9SUXsRxw83Fu/+BcoTMX3wze3+U/F+
         4t4sNWa3xzw2SEzl9Tgc9Or7M7neEgGn4FFOnPJTTFHONet8Gk9RAPhHULc4znjVQ42J
         eGPg==
X-Forwarded-Encrypted: i=1; AFNElJ9BLGh08ow8DFIL4Iv0/2eo05FCVa+wTC1lJ3Oqy1g/v7kto53J1+wpFFWujkw/AkSB2HMPxvCJXw==@kvack.org
X-Gm-Message-State: AOJu0YzCkfPwhqBmfAPOxs9I8I6MkCV0Pdtg3hY29egsbET50fyiwIb4
	Y4y/cBM3WtQWoCz8Up3Bjld5fZ1Zk0UjJLKnGjFQ/KXDw6s2hxWCN/xcjzEXoV8sCC1tROKWjpG
	o0KRXVDCBqG0f2SXqC79fWEaCl7UiLKjSiDDQe6NM10IF3KPJyKE4
X-Gm-Gg: Acq92OFVWt8RP6x50vpOWSMAGT2LIROahtdXPH2ixM1OEyzOLa/gI6FhjJdncFeaVue
	E/2LmEmCEWRN7p+ZB122K6eyRpblaoN/5bAJQCXugoA3k4Lase1pQy0z143ie52Z9z9v//QGdyb
	rcuZynh7N90roVkD1sWYosK/bkqj+Rtwp4QjX0kIJH0HeRwVKKbCn738MRwE9OX2idQz+XsAWej
	cOTlGBIcwfVYdXgL5+dqA+4gxuZWCgMup8E8T+WPiqieS4IsX0gzVxXGwFxjl8xWlFLi+YhaHw5
	vSsVOCBK2NHFZ4xJUwXG1vvX20LWw8E9MrpvSHHpzKPq6haM4t3cHY+5dMBs/dbHacvtBejbwZS
	RNdDV6BBr+ot5+CcMnT5IQIsBkIbTzabfCSF0gZFUq8iU1PSUDP8=
X-Received: by 2002:a17:907:1ca8:b0:bc3:783f:1da9 with SMTP id a640c23a62f3a-bc56d13123amr1190827966b.33.1778490139888;
        Mon, 11 May 2026 02:02:19 -0700 (PDT)
X-Received: by 2002:a17:907:1ca8:b0:bc3:783f:1da9 with SMTP id a640c23a62f3a-bc56d13123amr1190817666b.33.1778490138948;
        Mon, 11 May 2026 02:02:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e4bb87bsm23408179f8f.2.2026.05.11.02.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:18 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:12 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH resend v6 06/30] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <87e7ec6a9722ebe27a837a29781547d0d210147f.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 45a_ZmZ-6AZ8-rwSW23OQ_FtaSW_SyeNIUkWL_Tu0Rc_1778490141
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 85zj616bhz6r1ftxmwosbndwbuks4hib
X-Rspam-User: 
X-Rspamd-Queue-Id: C7BB72000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1778490143-691971
X-HE-Meta: U2FsdGVkX19sZWzJh5fFokpV3W81Y3gQ3X8lmk5Drv93ypRk72da118x1njxxhR0NgsJu/AZWEHqFwTXnM28eljAyFMy1AJuCCPONCjav/v1E4rVumwu+GW2qw4fTA18396chEaVaEbaTNKQIxD3V5wN4QU/xJHNdkc48QKoef82aX0QucbNEIgsd0ve8kO3XhvBrYD49BqTyWCeOxN8EDcKivKpDhZdhcwTPKsTb/rHK785NdJmZDU1Pcuvpu8Caq4bXw4212Ps9VZtO905VBYXCHKNXt+RJ48QfI8OGUn/h5cuUWZYwdlJScGI45RY3I0mwuDbrnPasdRDFkUEOArpqnMc9/e1lJlKt/eDlb7CsqkAIf6dqW4jpYgXbQoLIQk1KCJ2MPdY5PQd+CCL0wcprTKmy/02iJ/y6ve6JgP3kVnnU/AUK1eMykG7AgJeau6TaRFPX846edNHXziatLWmFR/vgfJsBOWoKyz6XmmzBX/VZR1hGKbTCV5xJ+J71azZKeq60u59dD1WvYGvzW8/Gv31e5numMLzAebcVped6myDsqGxx2FrubHYB7Bgx5bzEemY/Cw10IbRsfWNjqjNMwHcjnXlKw/WwppexwyQTFzAuLTdgJSWzGzl2SBQ6HJZR7c/anAcSb/Uk6yjCeGUuw21LrN9Y7/xPmipzJVqMYOY28PzUbHD1gPCUdxZ3UsT9VMIr2MGyAc/SxLM8PXCth653x0ZzbTkEkXnkyCL9OrjSNdwbBDSqThchiVMXlUGnBIXoP9bHfJCbe4mn4bKpa++tCO4QA0NzLBm8JxsZXIS4Cc94MteIC55/dwJD/OaMctUQ3ZpKAhw3I67piCiDB/X3Ce/bxyloGDRO+98x4qni7cN5C7PngjoEDWTzZnnIfYRL62nBZ9P0+lWy+BV0SYIRuJ0I7tethZxcAjZtKtkI3tGmCP1X/884fiYTMgIb6JUwChr0CyFCsH
 BgE38JoX
 Cm4DNVzNBltdpJdlt5mr+9RizFHdUMnNReHMaGCOY9zVzfIRL17XdYXlsp8ocB/ESJabhgcKs/rtSYOkcd9LrsmBcDTW/xcXXQo8jU702Fu78xYaML8nlUJK5I/3/fyl3fl2XF9+NlaZP4z7Y8RBk+lZwVyMaceBalqRiYpsjV+ahwwGb5aqTaF8KLhaZFgprtwwrSSmbnKeNWiy5M37QAiGe/6cQJuP4r0eeIdTO2tOYre3Of5cJdrlOQP3JmE6AwM1L4vL3axhdOhY+LTi3suTihkVVDCh/7VqZXUf4rlMVN0VSxolsKWKOZr4dgTnl6HSYoCaOk/suLT7aafITwK+C5lv9wLFo1hLgHyYooHus949q/0KcksdufDjKqkqhscS9QjwcHqslak8sjc+Piqmi4/kzdMxzO2ZTaUTig1B7/v3mTe+wp5m3B9CCY0wIDtiX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When post_alloc_hook() needs to zero a page for an explicit
__GFP_ZERO allocation for a user page (user_addr is set), use folio_zero_user()
instead of kernel_init_pages().  This zeros near the faulting
address last, keeping those cachelines hot for the impending
user access.

folio_zero_user() is only used for explicit __GFP_ZERO, not for
init_on_alloc.  On architectures with virtually-indexed caches
(e.g., ARM), clear_user_highpage() performs per-line cache
operations; using it for init_on_alloc would add overhead that
kernel_init_pages() avoids (the page fault path flushes the
cache at PTE installation time regardless).

No functional change yet: current callers do not pass __GFP_ZERO
for user pages (they zero at the callsite instead).  Subsequent
patches will convert them.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f76d5271b5c6..842f5080d728 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1851,9 +1851,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE)
+			folio_zero_user(page_folio(page), user_addr);
+		else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


