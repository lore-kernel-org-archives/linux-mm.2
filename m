Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 201FACD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851DA6B00A4; Wed, 20 May 2026 18:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822B16B00A6; Wed, 20 May 2026 18:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738656B00A7; Wed, 20 May 2026 18:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62BDF6B00A4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3156DA0462
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:29 +0000 (UTC)
X-FDA: 84789220698.10.C7E4389
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id E131116000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BLox6b2b;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phYVyxy4NXZDWgDwVjZEeX0+DVaGt3sk04puvAHm6ak=;
	b=22FveaOvKqzQZAtdJaMsVJgtKJ/Hq8A8BUqAWe1arbSAxF2bl6GDJjQIqNfAFzPv5GLT7M
	YKtMVhvAvTrTbE0JruisGJRAfYHQzYkt2AGko+hN2ko+LdS5EO3eeUK+XeUqHT2Kgcnfmy
	HZbPmBzN0lIR++N1PoedQy+FTIXJJK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315686; a=rsa-sha256;
	cv=none;
	b=HMxTCYlbu46HyrXj1RtkW/jwpFL3Lq1GShvq8ojGpIKT1eafhvsOjRG758uPBiRqZNjqF5
	CsEt2uL1eix6Wv+ddawI6siVihbnDYeWtMhBryTxscbtBEOWUxBivPLrrbkArE7ozv/0nc
	9sKq4YZeU17JweLC4NBuCQoNoBCLwCM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BLox6b2b;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=phYVyxy4NXZDWgDwVjZEeX0+DVaGt3sk04puvAHm6ak=;
	b=BLox6b2bqUO68wHW0ta08CFNoOF7XaUJBm9oGQ/UGzqEmk9urwDFmyM53USjrwbuSK9Tw9
	tCrwLT6WFdIbD39FfoR3Dz8HFzQT0x0lli7NVAt+tjcnR1ApZobdA9cQ0XIwb4sofEydJ8
	X+PSOsm4Dqd4xW1dVQ92stUsahEUB3s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-NkMHjAHpP22bVllYjeHeqQ-1; Wed, 20 May 2026 18:21:25 -0400
X-MC-Unique: NkMHjAHpP22bVllYjeHeqQ-1
X-Mimecast-MFC-AGG-ID: NkMHjAHpP22bVllYjeHeqQ_1779315684
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45e2f74da10so5971995f8f.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315684; x=1779920484;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=phYVyxy4NXZDWgDwVjZEeX0+DVaGt3sk04puvAHm6ak=;
        b=PgTtah7LWgLxBvpHf3x+Lbh50f3xBN5cPunAPyzSOyUDFGPl7O9SvZsd1r1v7IlzeQ
         6HPqOWYD23qcHQg6sHuB03olZnjs4K7BkT4ZetXibz71Z2Fiw/mT5LNwiRRY+AwYu8WK
         OoNOmWMMZDJuWpriwWmxYpErpKOWSFZnyK3onzDtD5JC8gsI4y0cJunKYTYnFDSZbU9U
         meHAKqebEF221ZYZyN2OmM3ZEo0rMWqMiwLWMz4lqEoQtC3Y5AGCKtkW/1eOurCA9Jq5
         Nx+X0fSSyVVImxRlLDtyrrgWcnJPBvI1pYBokpg6zaJyM1wh2wUbj3geXLA78JqJ8FRL
         Wetg==
X-Forwarded-Encrypted: i=1; AFNElJ8lrzzvxEB8Rx13LsUPOgFSB7hhpB4UVohWOZMthJ/tLQq/IDF9DZ9sBXo9EAvKn5SWgoTtUiEzPA==@kvack.org
X-Gm-Message-State: AOJu0YzuOZ0iIqCXNIETxCe8XEkuVKQtwOd2OW1paunFPSR1ESs8qpQo
	yYYdSK4VaJKuePWT/p91Y/MTf1NBgCo4ZxfzuCe9ywgcrGKBQk8GwGTJus7/+kODWaNcUh3fhOI
	WHs6s/QKbyvAzxZrAStPvhJdqAieLs6ZxTB7VCwLilbd9IldBCWw0
X-Gm-Gg: Acq92OGADIrrc7/AXMUb6RrYiXmRciCXaCrfcHDZu51gkfkZ3j0SrDVdmgJXU97ETUO
	IQ+P4LI2uXd2QRxjlz4CWIB9prM/WaoByXxFadggnzVZl3xAHtm8dlVsfxJNIU113rQIGcv9h/9
	vzGLfLSYsJrew/XL6wrvurxX3RZOo2rIFAFTXZl617AmMnO8wuUNYSoO5CPM0V9VyoS17P/huWN
	n6PrdYiLnkqsfC0YdvkBRFSqLO+F8wYhIIDH9KpTKlBH8hHkepdHt/o+Ou3hw2h+xB2Qex+GnXs
	NsIKGP0NvS5HIz5NSzdgMftRb1KDer/c/a7w92UHQW6AT8xSN1Wh/ZJ5g4BGabZHTCnOWUYuaHU
	6OT+oiZHsmzUwN5C6ARisnPuVRxnT+aM7SKfHbBYarAQ=
X-Received: by 2002:a05:6000:2c05:b0:43d:309b:9c4f with SMTP id ffacd0b85a97d-45ea38cd4d7mr309374f8f.6.1779315683792;
        Wed, 20 May 2026 15:21:23 -0700 (PDT)
X-Received: by 2002:a05:6000:2c05:b0:43d:309b:9c4f with SMTP id ffacd0b85a97d-45ea38cd4d7mr309285f8f.6.1779315683262;
        Wed, 20 May 2026 15:21:23 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a1aeafsm59910901f8f.23.2026.05.20.15.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:22 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:18 -0400
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
Subject: [PATCH v8 10/37] mm: add folio_zero_user stub for configs without
 THP/HUGETLBFS
Message-ID: <501f8a7a582a97011a23e3051f3d0999c66c10bc.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j89bde0FiRiUSmXyqU6AhX1fUG1g0RBfudYW4cUCUOU_1779315684
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E131116000A
X-Stat-Signature: y8eszcww41ct86oaswgtsnk1q8e5k83x
X-Rspam-User: 
X-HE-Tag: 1779315686-197114
X-HE-Meta: U2FsdGVkX19SZESlW2htcOFKeGtGK8LSBwJ7DuE9uxmV9pOtrXEad+F0yPy2fs23iaXZ6pB4Ko+YFg25OhqNBVlcfYeJk3CwsePNx8eQJSIhgrMQ8nnQ7jM5kAW0XtvPIqIhkHJxtlYZ4OFbRiWNDWoMGovghDQaQyDUpmFLHcREMZlg5stdrEtQSgbQ0CzrY8B4rbogdX/K+9bIXoy0NrQCjcujeMpvM4dJ7wBhmuEo4L3cVVPzuxErotBtdQF5ahCSiUFDoSDwbGPLMCKZsVAUzC1zr+bOzfTei9Sw+qUBntfLp3imt8xuzdo9MPDgF2DXxElAJWUdQaKvtGa/xmtKOt5FnHI9ED5qzVCqV6DWURNS3M3c3e0bd9znfb0zGzE5vCiwny2waW9voW3jC2wX5j8eaCIHYVPa+7NkrGGfEhfjWhL7EAnKtv8PJryBSXXmDMprBwongOdDIVmSyfkAoX/ipgM7K21wzzNZMociiAPzYb2aoG324+rIF4orsNVq1bTOWfHDy2Bwafui3SZYpk45eSlSbeyJm5oe5DSIvTiUr4bO0u6jv4bsKXdz1zyfBOC4l3Cs5GzfNhmGiiVu8mGiX7Wm1yop1G6rR2ai+LDz1m3xxHYwjmMxrYqEji8+HYJVLAH9vYnk8wRJm6bc3GokJ16HVY2y6hrGxe7MvFQILsk09wHI8GmG8ZNE4+BechRsVCzXbPC33d9d3+eLS49TzvwLPwcyqpRA1AYuDrBvyyxs7Tu57VJB/qTAsGl9L+amLTiUl0wuPrLARFtcebnnwFZcUR+7LaYAohvNy1L+vhkVBkus2thPA5Zf4Q+A2+KL9LN7RUKrUxPSyJR72NIEKlQtwJjkMyvd7H1NP3AOa15RQR6aH7tpmy+Um2jWO3cSdnpVCxCkA/WrMX1QKbjwYn7atL+Gz3v0HbpmdFTgZ5Hbzo2Q26lN14kJx/4C/yHnSRgIZWbc5BT
 jsYFVA9r
 qbtKuBOxzKZate837dtGyz3THsvb5Qa2FXu7Gk95lrERtulesaAG5oOxrD8YB4pzY0ZhzoXcDG0q7Mi8MMZVPvSUDBStRSOK2MCPIZrQYtcYlZ9oMPWbgirsPG/1A+JX6hQOff4F2nWg3CaPZa/OXks9BIqqeAQ/d0rvqf4L2hk9MkG5bJvKVT5cekuoo/Q0gJa6kocgCX5k8WmqJS0toiB9m/Fq+eZAtizUFOSUaFzr9gdYOkRj+P0px3sm7BRqyZsgylTUp2303rZaQxSrfnXzBKCMbwP2wvC0B8cjiCN49vWcqL7pI5keoLB/NF3uDlCvO9MmTn6SOv70vu1p8XM2PhWEnFuXBCOzfWsVSjSJKJzmC1nRey3AiIQcSwCZpb3icM9tL3kFBvvth7Ng88lgzIMPXOXzXTAIPpiGh9kaSCpKYcaPYdhkrP+GrOtgDGV/RUmaX2l61RVwJ2skr1McXmPBAhYg91oUe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() is defined in mm/memory.c under
CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS.  A subsequent patch
will call it from post_alloc_hook() for all user page zeroing, so
configs without THP or HUGETLBFS will need a stub.

Add a stub that uses clear_user_highpages() with aligned
addr_hint.

Without THP/HUGETLBFS, only order-0 user pages are allocated, so
the locality optimization in the real folio_zero_user() (zero near
the faulting address last) is not needed.
This also matches what vma_alloc_zeroed_movable_folio currently does.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/mm.h | 2 ++
 mm/memory.c        | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..d1e768dcda13 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5070,6 +5070,8 @@ long copy_folio_from_user(struct folio *dst_folio,
 			   const void __user *usr_src,
 			   bool allow_pagefault);
 
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE && !CONFIG_HUGETLBFS */
+void folio_zero_user(struct folio *folio, unsigned long addr_hint);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..02d3e53fc91b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7546,6 +7546,15 @@ long copy_folio_from_user(struct folio *dst_folio,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+#if !defined(CONFIG_TRANSPARENT_HUGEPAGE) && !defined(CONFIG_HUGETLBFS)
+void folio_zero_user(struct folio *folio, unsigned long addr_hint)
+{
+	unsigned long base = ALIGN_DOWN(addr_hint, folio_size(folio));
+
+	clear_user_highpages(&folio->page, base, folio_nr_pages(folio));
+}
+#endif
+
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
 
 static struct kmem_cache *page_ptl_cachep;
-- 
MST


