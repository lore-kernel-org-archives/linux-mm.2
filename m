Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4B5CD6E53
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBF66B00C8; Fri, 29 May 2026 11:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3FF6B00C9; Fri, 29 May 2026 11:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9E06B00CA; Fri, 29 May 2026 11:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5216B00C8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:23:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20E5C14015D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:04 +0000 (UTC)
X-FDA: 84820825488.21.80B61DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF34FC000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:23:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g0VISnFq;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068181; a=rsa-sha256;
	cv=none;
	b=TYuUVFjhbKG6JGC57IgoVvTMgUN2WsqiLJlFueu1pPcm2w8NXsUPmYbeUHyVxzuLORPyqq
	kI/3JMvydvYunkUloavsCrHQdUrlOyS4B+5oVpJ2zJLUlLdHZ/GvRBWuYHp4nLUb2MG1ED
	/gLb/XRta1VbZnOKYVvYnRtjIco0BIc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g0VISnFq;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phYVyxy4NXZDWgDwVjZEeX0+DVaGt3sk04puvAHm6ak=;
	b=wEjU4tspsPkRu0anvWfJEv6E/bO2VVZ5qCT0ns6sLg/1ROh1/p90mEcAQi5VhqrnosC2X0
	MM3v6WcrVLycKrCcsC5w2z1/uDJmfm/Z6axJps1tzpiOsLkeOUrzKmt8D3pQOpeq83u/PN
	dWd/VH+Rnz5XLnBNM5ttYLUjYBROlE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=phYVyxy4NXZDWgDwVjZEeX0+DVaGt3sk04puvAHm6ak=;
	b=g0VISnFq54Kkft4xfuZLosv+akj/F8h1a5848NldffwZnpiusF3CMwL6UI4KEANG9BZjdt
	41xVdANJJsTdwh3wYkXT/q9++yg5v43g+Umno09DiwdSxsNfci5FViF3ozEeprwPtAnk5u
	B7aQI41ciQ6I64LE1lqcjeR8McdzHXo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-6UuELWZ5OTmZTIUBtfEHbw-1; Fri, 29 May 2026 11:22:59 -0400
X-MC-Unique: 6UuELWZ5OTmZTIUBtfEHbw-1
X-Mimecast-MFC-AGG-ID: 6UuELWZ5OTmZTIUBtfEHbw_1780068179
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4909e29e78fso5207985e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068179; x=1780672979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=phYVyxy4NXZDWgDwVjZEeX0+DVaGt3sk04puvAHm6ak=;
        b=P1tUJmpDCv0rs1hXqFjxhT6l7RuHcTnp0bCL5hsMh1wytF8KlYZf+mYX75xbtmtVqx
         uzPv98Rr7gsCoBHa9H0wZNjSLzS8qH3HezX6kyvrE5KIZE1OYKvLjsVbtZ8ldKaSoI9A
         kWgI7xr211/z2k36ZUKkZRUyQvDv+aoWoFsvDrAP1VB3dVR7DP/hlRpZl6u6V2KlqJvP
         39F/2eHjWF0VyR1Wtbktv8ngLgYCm9sml5/QYugsrgajVWJj9/cgre5Qke/HaQYFe9Qa
         NTKERD10zTeqPeV2ZnM1AnhVs08ovdRBlXjC7KsiO6DAToFhPfAPtj4PS3uy+9Kct+DR
         Glvw==
X-Forwarded-Encrypted: i=1; AFNElJ/l3MAGZUQmiTu4T/bn891+ekDsWQ1+zvjf4IltxaWfTjTW2xyVjQ4saa2oOreWk3Ykws6waPFhUw==@kvack.org
X-Gm-Message-State: AOJu0YwG6idgVVkrzTr+vZuwV1FI4gVxjP6ER+XYH8QCbLxUhRHRFiU+
	hEr8gqgxDRjy1nFAM0bKsv8NP1Mbe//vXSEUGgldsBmvxQUk4W27s3NVrwmTS0rMmmju1yo6RBR
	J5Yi9nBnX0/8z4NGiIM8+WEQx4tCIQx8a5pirk+8xJ9SFKsvG/3+k
X-Gm-Gg: Acq92OH91VHy8JgKf1114gmgJcFRF8EAMlTPEOPbNj4E5pgBgaUwV9RF2qTS/d+/HI3
	15AeMDg0rzPDqqT5QKpk5t1JJocuAOWczHXpha2W5yuDn5EZieoLooDjqnlNtkhXU4ig5i51kWw
	9XPNRMaitAlOprD2TgIEF4eG8M+DfoZFy8KpnmLUiA7cWc9HRIe0i5MPe01YyLev34MeQXfX0/Y
	rVscNGsVRtpZ88yvId5W/WFPbF07Jdi9zG6GGU3kWnfbI49o6IaGjrHbA9dHWKzm34Bn2oUMYOe
	2gLWzITfgSMEPqROHuIlz8UisnTA1Rhiebgr4tFhmba0S5dPnfquZt07+K2FwRE2Uz0pKvtBb81
	Cauz/obyO9iZlOzcnhusQZEP2+viii2dXCZoyAizejg/1riTzHmj9bQ==
X-Received: by 2002:a05:600c:4686:b0:489:1b10:d896 with SMTP id 5b1f17b1804b1-490a28d3f2emr3053315e9.0.1780068178572;
        Fri, 29 May 2026 08:22:58 -0700 (PDT)
X-Received: by 2002:a05:600c:4686:b0:489:1b10:d896 with SMTP id 5b1f17b1804b1-490a28d3f2emr3052135e9.0.1780068177967;
        Fri, 29 May 2026 08:22:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c0498e0sm23826835e9.0.2026.05.29.08.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:57 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:52 -0400
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
Subject: [PATCH v9 10/37] mm: add folio_zero_user stub for configs without
 THP/HUGETLBFS
Message-ID: <806b21ab94d4e92e78a092ac6dfbc2564fc6d0ca.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JHzytQxp9i8KIwwUBwf5Dv_2I517prsG4oJP52tcM7c_1780068179
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF34FC000B
X-Stat-Signature: cgztipizdf3uqum9rjfcuu7xo111o5qr
X-HE-Tag: 1780068181-355544
X-HE-Meta: U2FsdGVkX19BAJYnz8Hyv4MZxzHclUOEKS3JveRF0TmASFujtdC/Wr6Jcprl7EC4tLXaUiaZM1GJWtb7AFIyWLLBHzeOAvblDmb3gIm/wEd886ryxhiIMssJ3EBeeUggubGY1gqE2Hv1i8vnfofpodjE8A5vTYlckWXfixPWIj83qiyjGFNM6H/54kYXXMhRUMnrudUDoHBwLRqO/urIvRtFjaNR/N42qEJEaOgHRb82ZrzN7eMvVwzH9s2L+GGZJ1lu13ZT2Xvg2Td5Q5H2scYEN0ezNn3/LuSxTYr14JE16d3TpDPD3TnX61pzF037Vz+Ei67jYOWxF/1zeZ2JE/VmZYSLTFzkV2vlmCfMJ2QQ5EVJmC7WHbxet7N182QhWA6WrCmHmZq05odKVJGAWdRUxNb/unYnY5WMajAmSrrt1U8SdvUvv/Uszw3We/W/Ipd31MlgTi87B+4brWF1et3sYjXPSE39XTiuHf23W75JiSESfIDSJmtGpHKoNnyIMBFq1S1FIjX2KlmkWpamcWy2O2SFAyJr5UWJt3qcvmlBGYwke5ar1JzvGyjNMRuLTNNKdUdboRrWJfqOBFSjX1O3ScKB4fXZbq7Mh9aFcWeSI8a40JosQEGAETNUTIgkxNTSGwI79J2C3Dmq/L3rrGQm+mz2btjE2gHS3KAslpm9jWI8p/40wNL6YMxjSGapWRVIR3CiP9MPOPnzooo/PDdtuAoQZhuISH6mFZadsfCHb/ezESLLQ684L4MwIr9r//rn9LFJPVhRByQgdRxsFC0AtCQSv0/dGNyGbUNdzrGBKEK8JLv4zRS3eGHBZCHQm7CjjzKU27LFmAsdOJY8+/l1QHQ1n4lEh3DVibCnIG9AyE8Ghl06TPuLNb4UEjAa1TAf2Uv+oXQjrBYyeIDDUC1MKcil7byN+ZUHp+1oqOvcxQhYad3OfSk5+/Jce4iEDQxxuM3F5XL2rBKEjrk
 EKV96aiu
 XkIgbypSzJKgInyIzM2W5FW0T7KpxiwXG3G/oM055EWrNLTrESW01JspLhFvvmK+bIAqdMib9gRw3/9UJeR3UEQ5ziL29RnxTc244F+OZglS6woz7yfqMHFZL8yzwSK5IhW7vpD8T/Uf6IQ1wDV4QHR1+4i8kLDszb8nHEj2AzHAR5sL7e0Up8Cg5x4Y9vnvCjJUeo02cdq2hb28iPcuVJ7UCPQrAV3bgIRhfaqU+gkm9amIsUM67K/wHNWYIxrse9wPEikslcTuLV7uvzy6fMj2VlDRQw8Y1wmmZxvpP+rYaFhWjNgO4KpvBYmWD9J1Ik050z99v5APrF2UqRCR6etW2CK4DU2SpoJ6EXSiyubLLTH62A+HpG4R4omugkiKrTa+CtSG5UrVOldcEuRQloc/BO4Qosyzz96quu2U8VQkJhkqxrpi2lsN12wjsHzEUDoMtPQGUQP8gZlGptALWFK+NT5r8BhMKXedD
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


