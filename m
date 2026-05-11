Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECEECD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0805A6B00D6; Mon, 11 May 2026 05:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C746B00D9; Mon, 11 May 2026 05:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1DB6B00D7; Mon, 11 May 2026 05:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB4C86B00D6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9710FA065A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:12 +0000 (UTC)
X-FDA: 84754547304.27.DFBA2F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6ECEC120003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b+IWyC90;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
	b=BkE8Yg5j6JJVt0LM3bK+tjM0l2RmJct9on+bLpMimfOOMYzsMmamlwTT5PdO3qJVQDD9dC
	fk2FQPcFMJyhb6hA12lHKMJter3B4ZwvCQy6xCwkiukKpukwPOC2RNoxfCY1u53GejsiFx
	LKnaRum/ZnYrXl+08QQ6syqbY0uPzbg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490130; a=rsa-sha256;
	cv=none;
	b=Bi5TLhicLJKPLB/HZAJslbADJG4MYzORwELk1HmhbNqm10WAWdWpmILmORHp0z8R06NX0T
	PAd46uJvJQfSdJjxqxqBpwqiYSIUaWeMbvx5LXsQ2rWqTkbqtUvBmH5c+WJVk8Gv8GiZrE
	vB01fLfpMsPMmxb3xw6/NjucXWgfyrA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b+IWyC90;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
	b=b+IWyC90cm/burLMUqVWAVR9OnUmGNN9d28VQkcGjPsC0Qz6iIDYfpD4WaZtOiBm84Y1Tg
	FHOYqHSWw6Q4Kra1UjX2Uzk+MPE6wSJ0gUUXRXdWyUs/RBOFgY+7j2XJBU79lCl/E8GQlr
	6yfesWMaA5u89AI0qlLHwvYI+qWwn8Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-BKv_ZGHoN_io1rGeavPFBw-1; Mon, 11 May 2026 05:02:08 -0400
X-MC-Unique: BKv_ZGHoN_io1rGeavPFBw-1
X-Mimecast-MFC-AGG-ID: BKv_ZGHoN_io1rGeavPFBw_1778490128
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44ffa15dc73so3686103f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490127; x=1779094927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
        b=jMZ2EUg3qggr8EOQxPv/YSUfsIC31aMsV+i+n4hhPIWfji+X03b7kWVYuKRTbgNtYD
         c+I6/03BRZtv4rd2w6/chd+KJG85LypCjiKQHN7Qxm9KF0hR2sORjxd1H5MNwdd81Ztv
         7pq3bwjsZJfogrk85Sh5/8q0+fF42dIIpjJDGdGirnjBzuPc3QM1zTjyd+eI1n3H6gM8
         hHEiHe79ZMsFQ4c+Oo5UWjmB5MrYO4Nfc4yVIWf2J/p5LjbVVIUWf+nMoY+7CfDH+1Ob
         U3vBW5A9SgixDTZJ0plMFjojGtdkXfeSSp8WY20ilU1xvtouCG+TMypf50iLkp51cGGF
         7RPA==
X-Forwarded-Encrypted: i=1; AFNElJ/Tkuy9xiRiZdHHmjXKpb+9lyPYw8dSCL41MNtkGaJ7bVzK82IqHzoMaxjPIdd267R7ykX6ogpNvA==@kvack.org
X-Gm-Message-State: AOJu0Yx6BUV1pa6C/N7fTtohdoDnoVfETtUlO36SZnKcEXxcNCADcB1h
	r/SWUOtCxT2Nhwo/h7hgFRXLZ2m9Yd/NqwynQgbjhLaDL7Hp7apQ8D8lXYaI0yXxAszpbGxJ7yT
	PpId+0P9A7pbwKGuKkVK/veOQaKnAJViZXhxi7/hTjmwgYlSSJGHi
X-Gm-Gg: Acq92OEUsSLz7f2wKyL0rKE+to3mcezFoNPmV+9Er8u3/Wu/Xhf6I3KGwo9fZZBhHlm
	K7A5hBFb72j1jhemRyk/8rdlhesk+NLEZelwjQMSpUUngh2okak3gwiUHCbtk7GRsGdkpwAmSva
	KrcJ0DalHeny+y6RUUM3CSek8dtmQZ6ytWbAYi8r91zI/fuN+pCymks9tb764yZMDyp4FHdG3eU
	6XNS6jznjt9K2wQXYpsCcRMkqYorAEm2gKFwtI495sgkryoD9NBM14XL3Ovc7w9lN6bMZhxCDJO
	r2pgv7hvgJ9c0aAejqrrxYuwrEonggP/oi3H9HfuE4DOy4/Md48X5IpZWd8MEX8EeZeHUPWFMj2
	Ex/uAIi/9kw+qmy03KWDnRnIPdAsyppUKlY2hZ/Pb
X-Received: by 2002:a05:600c:4f51:b0:48d:1a94:56c with SMTP id 5b1f17b1804b1-48e51f3054cmr404020745e9.18.1778490127396;
        Mon, 11 May 2026 02:02:07 -0700 (PDT)
X-Received: by 2002:a05:600c:4f51:b0:48d:1a94:56c with SMTP id 5b1f17b1804b1-48e51f3054cmr404019825e9.18.1778490126688;
        Mon, 11 May 2026 02:02:06 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6db1742asm59834415e9.31.2026.05.11.02.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:02:06 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:01 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH resend v6 04/30] mm: add folio_zero_user stub for configs
 without THP/HUGETLBFS
Message-ID: <1aaf861301e26121bcbbf549060cb6b3b04e0c06.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uXmmfX_Me4gpmzqi32pKNfR2mT0kupyVwVI99VQa-3M_1778490128
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6ECEC120003
X-Stat-Signature: ef6jwiqzht388mysybpb74ugi7qbb47d
X-Rspam-User: 
X-HE-Tag: 1778490130-366840
X-HE-Meta: U2FsdGVkX1/nh9+CsUoz8PwwZTGfIcWSvXCvFz/g061w0/bDLrCjGBxwvkFZhrDGb+LTMaJihiWTxaRMhnW2h4cMfUQYO+G8GQp4oqGZJtA+usAePusYvko0AM1T/E1csHfZYqbv7MtScn2EDgnAKLT9NVG86fZkEHXXShZ1dzExLZupwHYjnnSEqfeCaDsI+ecvb7LX0B3IMrgNRiHt7QTB4tiiRV7ozrAXtFrXVylP5RiwGzW6yCLKjHpfug2hVy6GV9oVwJXENxdYTNd00FqfrVO/HreV2rrTVoDz7Uf+jhfHRBSPqH1Si+RPSnlTaLrPr9VBlmOS1Lhu0vhCEzxU2c5bR/MUc+Y/Tk12VlQrRtITEmMKVPE0TAUyj4ZcKPNIlBhrOYLE4sslUz09J+g3cfGLFPsNW9opq1lySMAQ2rytT94VJ4wcTAxboy+dy9TtlP7LgIAOuIOsd7iCN26v9Fn2e9zRdEU0AJq+WHSKp9ay6Jr70t+NfhilZZ42P7r6wXSUa0IITl0nhIySbRRfogSaYMfD4r+Lxo3xRZT9JL02X/n33Va6Pxn20cyDS5sWDot29+QvVKk3b33ltr4hsWrXiCfASnXpRCBZ1m3KuDYYYgg8zEjdKxoK7W0iakoQKgY64bo/X4PlS0fzWjzousC9vmWIvS7dlp8+O2jNnN0XVnQz63GdE+EWiQf1MWoPLcyQ4iEM8mEBCccQ0zizNUqIto84diBvP0FI7/4gL/AnL6p51lifSFH8i6utqdV5GjIqSEAu7+yEc5hSENo2DAioTG/Y4kRAGHlMjgKum5VPkpDvBkWZ4wGUtrqQsSaqeQHhI3IVwQvcuExbnX2HLFYnFDYxxVcA/nKpfDKPzbNsAPj3RAEqYK5QuVzJ6/gR0dKzKylhqEl0AW+XQJw01gX+LaC5cyPiYMvssoMvS9DIhl/fcGmsMKhdIZcECagK3+Co3tQ/wPT+a2K
 w46SbIkm
 Dm62mAkvNkBSFstxTHhbGYbtr5jKobK0iBe+2rtRa1yL//YLGFSwCaTVJ3bMLn85JtfvJOsyZ91KaV0F4RnvXtcurPMLLGZzRoPtRifjIN3Q3V23GSqLiNNXEursD6ffeV/6NVc4kY++jup33po3d6Ur5VVtVTuCWaBltIIEAeUlhEvVRzmVMuEU2h5eMBaHhyPvWPbD3eZuVvOt12gO3Bk4jA0WGrbyygKX1ApRu1qL/dZZd7+7Bb8vfYitV/mLkgob63GojurcLqtzrtvOGWgxOqulHnUdV+cZgW7gjh499bY2AlT9rFP8iLSZtO5AhilxpkjE876xDamT+fTeVkbRAaOQy5RqW+nsj70DUGzgMl1YPFhkM/I5TFL335Vl9k8wnE60yQ+VVW/vcnANh7naCOs2qvaDAccpLWbSueOmBhZre69yPfwuJffcLq4OOJ1lh+X8ui3UsBEm/omej+KCuSHzojJPX8ixV
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

Add a macro in the #else branch that falls back to
clear_user_highpages(), which handles cache aliasing correctly on
VIPT architectures and is always available via highmem.h.

Without THP/HUGETLBFS, only order-0 user pages are allocated, so
the locality optimization in the real folio_zero_user() (zero near
the faulting address last) is not needed.
This also matches what vma_alloc_zeroed_movable_folio currently does.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..3b1ca90fd435 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5070,6 +5070,9 @@ long copy_folio_from_user(struct folio *dst_folio,
 			   const void __user *usr_src,
 			   bool allow_pagefault);
 
+#else /* !CONFIG_TRANSPARENT_HUGEPAGE && !CONFIG_HUGETLBFS */
+#define folio_zero_user(folio, addr_hint) \
+	clear_user_highpages(&(folio)->page, (addr_hint), folio_nr_pages(folio))
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
-- 
MST


