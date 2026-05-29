Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF5FCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BEC76B00D5; Fri, 29 May 2026 11:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FDD6B00D6; Fri, 29 May 2026 11:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385936B00D7; Fri, 29 May 2026 11:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 273F56B00D5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:23:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E427F1A01F7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:09 +0000 (UTC)
X-FDA: 84820825698.11.45D0330
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E9D5100021
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QltAKcxg;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjfty6vgLrS4T7uumYbV6HhVn6mEWZk8nuiVgC9VboM=;
	b=xa2pvE2v8KTJWr9rdOanOyqqm8mY0anFQtska7pCRrPSq3Lv9LnSHdzsH36GHjH0U6uyXo
	UeDk+gLfxQvjv9klW9wtIvXdYYkoPuvXQR6iceUD86m4oW5LWRYXB0LSMN7JYnCxtBkNvn
	JR+fUsemQ7wqx4OGjklGhjnn8HoLKoQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QltAKcxg;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068187; a=rsa-sha256;
	cv=none;
	b=MREMpug7bZvxvKdKEcwdJSulkvZj5/WlcdaJE3c0I6WXpnJxnjbOlBUkZwesWEyCTbAJqe
	/D8WAo42AbHK6/jpHyzss8wsADdDl1EKIYntTUOZIRe+/6bT8tERkxFmj/Go4glQUnGi4U
	DDBVlwFZg5zQ9h6/dQQ+SZ45XAxur/o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kjfty6vgLrS4T7uumYbV6HhVn6mEWZk8nuiVgC9VboM=;
	b=QltAKcxgNt533q1q+Z51wHw2Ewwn/ACeC98pd2X3JaM5jIGf6GruON3A3QEiBq95maRkb5
	DAG9hzluSO3vN4i+zo9i57WdOqIWS6vH1z/ce3DBEGnLpPbJWlm1XY2v7uQbbXRzR6fU3J
	Nn4eMq5j10XqaeB1MP2Mjf6WGXCs4jQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-NNeuJdqpP1yptS35LSCuoQ-1; Fri, 29 May 2026 11:23:05 -0400
X-MC-Unique: NNeuJdqpP1yptS35LSCuoQ-1
X-Mimecast-MFC-AGG-ID: NNeuJdqpP1yptS35LSCuoQ_1780068184
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45aeac88af4so11159249f8f.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068184; x=1780672984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjfty6vgLrS4T7uumYbV6HhVn6mEWZk8nuiVgC9VboM=;
        b=Qp6eZlCKFthvtvZ3jwfbsKjfyMpR4CN9gg0txmi6GSXtJEuJfpS4MBZWhzSS6Gau+h
         JKPXxdHgWj74/9l6KiRO3lpTuRUJ0i4YDwy1noITT4mBXChr3CxsXPnwDHTHcqIldHcB
         ywUMnslCWohohapIYe2o2+Pce7chm4keZ+mpFNSzo2gXPuKGz85PqXlLyLcYdiG7+JAi
         beZ6+1yn/2vr+j4VksuIh/0eM/IXofNZUOsUmXolnYD29xCwhohoNJoZ4hd/XH5vyXLB
         QxE7aNyRUnU3408GbxV7M0BOzQ+NjeZz52JsYLRKMSlAqEzimHxE0AOzAt6GxFBhWboX
         F0pA==
X-Forwarded-Encrypted: i=1; AFNElJ9D9LH/oPUNXTXVrXhr8RK/J/79TMi4t6CdmjA2aeFwVN8yF/DuNDDfDX5ATrHamwQOF7yFFkLEAg==@kvack.org
X-Gm-Message-State: AOJu0Ywmc0pU4DXrNwSp1udNLdavGsgMOzMrEx9sVuFCARNa5+KiL1Zs
	iGH+RtZfzOcBpnaPCTUvVRRx/BuC7vf8Gz26UFPsUxg1t3EyKAdgce2lIgFwa/87hkeKjhdLZ0A
	GFYo5fU+dhQ/ghxm+c0Tkns0lPWzp76A7LFMtham3wkmhb7hL14nd
X-Gm-Gg: Acq92OHtbRXjhax4tPMB6X5ZX4xr3X9pELp6Ez9d+kZ5x/YcxO30QKlIjAUTmt5BdG3
	yiOpgCQ5MBxzkdBFl/omWWRic+CrazNRDB38CUKhjckOyzYMllaxc7zSsabkLdZC2dJNSWkqYZV
	TxKRmkD37ZXxIazAVbt4L9Ha5EoEbs1RHaC7iJQA9HH9AYJ+DXkIXwHTBvwbC6EqSDLixbTHOvj
	k8sfpnY1PKHuLb535rkMfdbr4V4oINgLvggTB/85rZt8uTxnSsuHKpd7tnXBswS+j+zR+q0hOSu
	EtlZZrYlK0waQN2HGMwLIj2Jhg/qQM/nrrW1xdcThoLA37vsBtD02AfNVbanUduGh3Y2Hm9KhrO
	WNXLerRmNFR2JsgpMDPoySqCYgCMvzreuby9Ay4JvAnkEWWOHcGSQdA==
X-Received: by 2002:a05:6000:1603:b0:45e:82b7:c260 with SMTP id ffacd0b85a97d-45ef6af7a60mr366076f8f.2.1780068184100;
        Fri, 29 May 2026 08:23:04 -0700 (PDT)
X-Received: by 2002:a05:6000:1603:b0:45e:82b7:c260 with SMTP id ffacd0b85a97d-45ef6af7a60mr365980f8f.2.1780068183483;
        Fri, 29 May 2026 08:23:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354c682sm3952557f8f.23.2026.05.29.08.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:23:02 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:58 -0400
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
Subject: [PATCH v9 11/37] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <bc9c4eff561153656b7ad247f584dda05ad7c098.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sD903GFsSLP9CJx8DWLk4ZyiThZPxYoTcB9cbV_11n4_1780068184
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E9D5100021
X-Stat-Signature: kyjnr8oqph19kkkns9x39stqqahdga79
X-HE-Tag: 1780068187-326592
X-HE-Meta: U2FsdGVkX199A6kIrOrC1UMBcxVyN3z1/BWlPymipyFZUIXwNIwfkeDxZB2JrccUjw1ti/T44QOtvJ1vHowwZMSVo/L0CfzmjB/iJ4uXVcVkpYGB2xM1WgTgtJxxe4hUnemlImj6IySTzjJfgRLZ/iQDiNCmsrB67rfYSU/fTYzy9KnXHmT5J0DY0uozV63Gy4URh5slrRs+i1qRn42nJ7xXmRnKs3Om6d1+LUsG/Un/Yp67xu8/DOtnLssCUAhhY+PFO14rMn4Zqz/FASeOcTU7nttXvru1JY0kwguqypsCQlNB9gJgyz9LP1o6fNE4mms3kUL3m24ZapsZLTi2X51BPVutHHy2+TL3HriOjD3i+o3bus234dcd2PbS9D83HlgM52DHS461LM2L0hOmrxs0x8jaL+XB1iShf2+8k6eWcFexa2/APha+97Rvcx3rZhN9QEfBtepVMhLYrscHmzfC1GKr+59zHbvgeHO0zz2orVSeKdQNRqYE/pBl5mr6+OTrc6MazP65GYlC2j366fOavCWu+1IVPDkdd+0YKZj6t/KCjTjFE1W+m6abnqsKyxgjPsWJVguTwrWKpcJxa8EDWWGDvS0f6JN+GqPc71qaF6rK9LpGBJ7LrLAg2Mo2UBjKZV8O6DeTiRAFvCcNXrzFO0pkbheWfnC7irpEBzdZUNCUDSw0t/S+ZuSxbgQUE2de9Q/GEwq2gAo3tsPBVPhVdXxB34YCbRCQvnxt+ZAQaJ3IbwQLtkhTMko8SLGsNvHhZYXs5v3AwoaT5ZzhK1Kd1SzybJ5aXipFoXlT/3T2/JS6/VxZ0unKd17qAkT1Ec65VooanuQZvWyjsAJf0iwFmdpbPoU5cHRoR50npF6RSTJQ57c4lEYHuvU5MR2BOmWa5GTjWUYeujePTJJRAhauBV/JL5AxBW9aA3159fgJfxhG9Mcqu2JNP0PtXM7TvVSJU0U7J1IpbwKCrvQ
 zSZ50mcD
 qJouP/33336bQfkT8QlQvIzt801ZiJ2ODcR8TRO9elWTDaJ7oRd1kW6tzTUDnXR6m+J3rGx1JymD5JiTSDJMfSADceTS2WiYUbWm8BzHb3/dsZRZJrCQysoTD4C7JVLlnUIjJpU3vQU+78/Sk8YQcO0TGxmINdRPZ/YwImyiAlM6/1cfICVPEwkoRNqHYJIPp2f9n47QrWamCsGBfRo6D+uE/gAbucPF4DeInJAbnpjl/cnXHYnEQAHRNeI8LhlVO4+ejKvmg3JD5K+yBONTcFb2yA9A6VWZ9w9+qJ4pw00ji62JARF9FKx8kDobl7B9HMKCu2dIhz01Q812XRR0fXeZJ6GEwfRNs8dH8T/zoJLD7zGvA5UjVvBn4aUjq0XaputXWRs13cfNLxWDr2cHmVJu1yiPpvv4NSFQiIs8cw+VimkX9Mp4O7vtcV+Qyi1aCVQgLTdhrYTk1BqHN/FUFFtr3BjoGUFHd3vLzStyVTKmc9mcS7jL2tkAjyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move prep_compound_page() before post_alloc_hook() in prep_new_page().

The next patch adds a folio_zero_user() call to post_alloc_hook(),
which uses folio_nr_pages() to determine how many pages to zero.
Without compound metadata set up first, folio_nr_pages() returns 1
for higher-order allocations, so only the first page would be zeroed.

All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
debug, page owner, etc.) use raw page pointers with explicit order
counts and are unaffected by this reordering.

Also reorder compaction_alloc_noprof() for consistency. Compaction
currently passes USER_ADDR_NONE so folio_zero_user() is not called
there, but keeping the same ordering avoids a future tripping hazard.

Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/compaction.c | 4 ++--
 mm/page_alloc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 72684fe81e83..4336e433c99b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1849,10 +1849,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
-	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	set_page_refcounted(&dst->page);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
 	return page_rmappable_folio(&dst->page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b725a3b59835..3108ac9061ce 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1877,11 +1877,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 							unsigned int alloc_flags,
 							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, user_addr);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	post_alloc_hook(page, order, gfp_flags, user_addr);
+
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
-- 
MST


