Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D58DCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7ABA6B0093; Mon, 11 May 2026 04:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52B26B0095; Mon, 11 May 2026 04:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940AF6B0096; Mon, 11 May 2026 04:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87A886B0093
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E29816067B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:15 +0000 (UTC)
X-FDA: 84754524750.07.D95527B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1141180002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MV6ME8qk;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
	b=2vQDwzvgZ+ZwS+OuIf8H0nLtI0mG9visrR6/x27pU1R/fH25iF4wVP2BIJgVtVSi+UJfiF
	6TKQMQmMHU3y7XeXUwIYz8p07SHJEjlW8gOnq5FQQ6CR72v80ieimMSBNYmUc/ks3UHdLV
	KhrGP6BFmb/3kweuTtiECQqFs8WTH44=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MV6ME8qk;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489592; a=rsa-sha256;
	cv=none;
	b=QmkVYq2pP5T7c/5KulugbS29HYC3jv4f3L20p3yVXp4zJQsXpjtHbrq7CqPjThrveEjudq
	XzcXjogr4MFa4jtPIvGyrKf/+Fmk93UBetSk5dQS46rNAVv78A42A9GVuUQKI/KyDZqUdW
	GfPVbzggeBwQGTCHglFwqmkBJy2n0O8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
	b=MV6ME8qkRfG1GcAqdQscG/BnY3ACAno8mbfnhyX7hooHcsTfFXAQNTAZo0tTuLPkZXYTUr
	7Sk6adX39PsKISGCmBjDyrjWbO1YkCgV+j7NWgZGZ6dS0zinxe3SQSZt+/epZqMjXRcOj1
	LLd+HsWlliXL9TxNsZcnjFW6yBGqxac=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-Os6vMXaxM9Wu55wuYxsVZA-1; Mon, 11 May 2026 04:53:10 -0400
X-MC-Unique: Os6vMXaxM9Wu55wuYxsVZA-1
X-Mimecast-MFC-AGG-ID: Os6vMXaxM9Wu55wuYxsVZA_1778489589
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48906aa28cbso37384515e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489589; x=1779094389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dawd7eS61o9/4A+PK33L87yl5/YoiTuIytB/tOyfis=;
        b=sTJyI+teXM2w2vmyEY/ah3tNQCzvcyw+/mCg6EGNIUrHVBGP7hwzyQmRdOz3IPOBq0
         ZAUlcqbjglSkjGEQGYOyaCYdZS2lgNLCoxVu6gJ+GJcRyZchVEnGoVQS4dNPVEtfqOhS
         hHOjqpQIfsbKMGaZSlcwqMFI4F7vQrXb6PhPtvW8c3fF5NEk9KxIxTFFaNkneiacxXqI
         G72vUYN3jUQt3QUBBZf8JW0b2sFzQa/o6OvwsyJnS5CD4nY3o+ppGg6okodwutCkXA9Q
         6kxC877hh7nboy1Ki0kQi0+WkQVu74u3sc1U/A49AI0vdimmNdj1Th/atxok55I01XrQ
         idvw==
X-Forwarded-Encrypted: i=1; AFNElJ866PBi7nYTaSO7dWKwMXDD9wOxhUvDlZibHTwAONSqyORRJQ8V0BK+8P/GqiPWmaav7+VAhjm1pQ==@kvack.org
X-Gm-Message-State: AOJu0Yzgu8xQtktQw4TOL9mVm3DswMXwZ42CqpSvHkeEKCLv2nMJLs86
	EcpoXPr+47gpFJ53sPxF58y6LVdZgQAptM9O1zBDP6J3tYn+gXvlLnpFb3PQgYVLesdc1yNMNru
	M+1ZSdUOoGnhLzugTXcEEldlAH6ZLJQBBKnWGOxV8dObiUQBY51Ee
X-Gm-Gg: Acq92OHusvdHd0jE8fyiQQ7sA6anZXYPx3qWTaFdU4Ir1dpPHKqlBS3qs7r2Q/6Z7O5
	68SSfRdrmh9quLZapjOW39gMyiSz5ZRnudbL9LzbciEAwFL5gMUHXoubDLDtTXi2iHGQ6M9o68u
	MTfVq/yO6HCJbopHHyVwbu1UZOqwxjPxF665b9CzoWr1BTcrNZ5aEuSaiook7TTqBCyyojNHWpP
	QuGtigXsH4o0oP0f1w/yVZAlDRqU5j2dcVEXPnO6rpY91m8mGx3EqcjMriHTnCvNp+SojyfLp4o
	QtzGGo2KNlnr8fjq8d9L6PMTRjjw+hNNTab8lFSnrx1f9lrYh38YR9sMegjHYMKAFsa8hfcvCzK
	Fcu8+5iJLr64Dgk7uEbfIw6ZzMPyMEUja0iuapsFG
X-Received: by 2002:a05:600c:638e:b0:48a:53cb:8604 with SMTP id 5b1f17b1804b1-48e5e00c1b9mr274005535e9.14.1778489588762;
        Mon, 11 May 2026 01:53:08 -0700 (PDT)
X-Received: by 2002:a05:600c:638e:b0:48a:53cb:8604 with SMTP id 5b1f17b1804b1-48e5e00c1b9mr274004795e9.14.1778489588154;
        Mon, 11 May 2026 01:53:08 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6aea4sm28136990f8f.10.2026.05.11.01.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:07 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:03 -0400
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
Subject: [PATCH v6 04/30] mm: add folio_zero_user stub for configs without
 THP/HUGETLBFS
Message-ID: <1aaf861301e26121bcbbf549060cb6b3b04e0c06.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KOP_z7jbUomCT3PXA_Y05yBeX9vSUcr33VQUHP1YE4A_1778489589
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: o5sdukqdmbesmxhsh91imphcp6359ebz
X-Rspamd-Queue-Id: D1141180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778489592-895752
X-HE-Meta: U2FsdGVkX1/78zK3tM85+ijBj2ItB2R72vdrmCsHDTm/e4bZEAQ0lUr4PF/X1ZoxBcj0Z0whDh9gWyf8LJ2m+oEuwVMiBuIzPEtU6tSfgUX6TW8CiOeBoGfWj9YRYdaVEIsKMPOXrCQZPnPrg1Kzcg0EXZcwNTUO7WdD/5Ov9kmv9Hu4JhhFXu8KaS7CuUtyjvho7h5L8/eG278i7tLeHxrIyz5PWL3dxY6Amoby/n4MRPtLZhzxfiTUk+wakXmV/y7W9f9ZJXslXo78DRiPU25KNOrjWeMQK8NEPV0y7nO4oHHMwRTNhQoze3Fk3UpJAJ+vzZdpy7c485AtrpemECZSskGra8nQr3SFH7zG9VcwiWZbAcU0hnnGyEDg0e3s6Vez/yieVFi2ruNU9kJIdgLuOPW/57mRh8oLtCo9AGFju8DZfV54jmBLHskek4blcMeq1c2c8ZNv/sDcc0SAs8jQxZPouAa4qoOJqjoDKwwmpxdcCxaZjKvdMrl+Xdm13puWsEzRrXj/RA2dJ63LouovtTd+XZEjTHwpg46mYc8QwC92WWs3QzamyKN/h618ugUfKv6XheP35Ijoz88Nbi21VacAkelKWVTkU07K90sydPQ66Fd3thnBUZrbZpSmPUantCMQfkhpn3GSh2u4qfX4wuSnIn8GMZKkOaYRnLtTjL1cmIBFe7ZQRFFHEHnTwOdNay/sLwS8co/S9+QekJ73mVBvLYvvdqR1R/uhnpU3qkWl2fnTVcYfpVlSMnliQVg2K0yRFy0u/lAl+pduaV+zGPA/7S6Zb48lqEvhnJ9GXh9UB+j8BMJ7HTydDMf4fm1VItQtevItph7EJB72YlIJMeowEyfZbFk7KqGHKtgtkrmLGMsJuz0ib7rPxihIYWZMD7lW/ys/wuAFfqVMAWEB3GnLwVjzvWaa3bibbYkSsZVGc2FAXjmdHVnvq4YAmYXj30nW6/rdtm+XNgU
 2aMVsbQU
 samkVSDKJhGME4AYoVf2B4VQrOzj+HfYOL5IRsf3gXkSB/TmxEagOtLt7Ssx70t6qCNTpfcOajNzidqyQ7n0q5zkgl5e8nM8zcUy1Ryy2lheAawc6svHyt64IVjebO4gCYJucerQ/R33Q96ISweQzxxUiA3bR5xAsFwKHIGJE9/QKOoHUvSakbrx5e3PVgyMlLYqKJFAR6U/VxQWTGxg+XPpeUvvbKXrXR+CnP78IL40zMdbLCSgmmzK5conE0bHQPjtbLFgFJkuJoPnaBXY5aJ4EwyP6NDuI1cyF1KzpameUsV9l5deUZTaL+XEmgAFidoWvuEfvWFf5GyRT3OvgOlh/5LfBLDAc+T2vrhzriC9wERNqSRhpEQ41cuJtx3zrGWRYWoRY6b//shzUOP+UsJvvZH5lEEQZm8ipfjqk9Pqg7T8uqSy6mcJObOn7VZrV9xDAH1VZkCLUSP7KhSorDDLCaCB0P6dCHv7D
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


