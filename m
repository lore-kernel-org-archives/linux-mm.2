Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D349CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26BD6B00A8; Mon,  8 Jun 2026 04:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6776B00AA; Mon,  8 Jun 2026 04:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9EF76B00AB; Mon,  8 Jun 2026 04:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C49AA6B00A8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:36:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F2B01209FE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:36:27 +0000 (UTC)
X-FDA: 84856088814.12.B557AED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05CBC180010
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:36:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QnMkktKe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnyUq+qDaMsFj8Ekur/kDRnbeSK9pjyeC2qTYvUeJTc=;
	b=6t9U8UiBy2BJqgyuBaBlvWD7cJm11fy7Gy/TEogOzj0/FvtyUecJf3aD8GskAtJotKPTHO
	9aBbJNTCdlvuv25bimepkApHf3QObLy1japqCzuDK8JgwkBXkLXEjC6NKE3EhXMFpxyh/Z
	LMl0VFAklpzBtP62n4o1INftXC8NQJc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QnMkktKe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907785;
	b=VtRle/bSiK+9BGTCuceiWrrI+HTc5p5AvoYw/ixwSVfnwbEwaud3WF276gmnReyIraTxVs
	DIkJJzsWKFgKVKrU61K2e92FH3WBWx67d082TO/UNLTDMzNkmBFQVv6rpL7OB2ff5l3MLP
	QYPX2aIp/Clc7u5JBmBDLrZe1zT5fGs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FnyUq+qDaMsFj8Ekur/kDRnbeSK9pjyeC2qTYvUeJTc=;
	b=QnMkktKel3FZ4vRrnUp6BS4wFWNBaOvXX0dHbMur2xpH2HeEnyXGVZHPLK7OZUt8sLP7l4
	NtUwpjeV6FcC+suD/3NcN2tx+VDXRT/w1Pu6syLr7idkpX/I64v6n3UEcdIBmVk04g5n+U
	FTcFh6+wtyspk/tnrxRyKDYc55N/6Io=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-p3E7KQ3WNjCooLPK3SFuOQ-1; Mon, 08 Jun 2026 04:36:22 -0400
X-MC-Unique: p3E7KQ3WNjCooLPK3SFuOQ-1
X-Mimecast-MFC-AGG-ID: p3E7KQ3WNjCooLPK3SFuOQ_1780907781
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4601c9b630fso1627724f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907781; x=1781512581;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FnyUq+qDaMsFj8Ekur/kDRnbeSK9pjyeC2qTYvUeJTc=;
        b=s9Es06hnea/aWO3yU7iHvl9dq5PHDRvak8+dy14xODxpEI+s7HN13bUCJDGfo99MLc
         XDCKeOtIqktFuFRiz+CiTOvss5nfgf9nFod5MkJZT8leeMqHytlzpyt3SkkaZcIllkpL
         IFLxqLNXWXN9T1d8D2gBcWAOfAM+ciCT8lbYbkHCgdmKwXdBMj4WoioJ7d+phsHTn05k
         mtGIXs3GBHAD84Vlr26UFd1K/yRIDc1Ya8/GAYC95uD4/iN2NOB3TAJlzIK3CX2K5vqS
         zNG9GD0+AYWFigaNd0Qo7/kr4PxBILOxAzRkasKyij6cYC947XwXoRF43GXk86kNETFA
         uWng==
X-Forwarded-Encrypted: i=1; AFNElJ+uSz4qm1SLeCEZgWekcakjW8aP3Z+NtMRRS17Y1t2rJfYN/pcw4vS8/YKe1C78Qarq/PKzzC+29g==@kvack.org
X-Gm-Message-State: AOJu0YwTXFxcEvx4dWew/EFok9GqkmUYdsnfbpmNn7r3g7W9pmdzc4sX
	4uWsl1+8mtsNgE29FvABz85Plceu4YVHB4Qoim8u2WHunTUndz9gp2/0jlFBf3bOeVuh4x86E3y
	WtF9SRZQYiyRZ0vnVeoUu+V/hs0fFrLAa43PTvERm4Y1dyi6t/uiP
X-Gm-Gg: Acq92OFULvAuGDnBr2cov8mnrGXo960lPbF+IhPJAw7ANfJXqle3lqua9IRM9RNOJJn
	PIdHSdwxoDcCIB7TmllBHiXS8ar3yExQXWiyPC9MeCdaTt6ENEF+hq7lJHlDmSi8CWJ7HMZnPng
	xiWMRHLeIovXt/NQEkr672RU4QZgDZVuLCcD65wR6eE4BSJEHBA5+YVQdE/OQVyfuKU/1HWKHBL
	4NuDPxEDS5N5Q3QiqJurpfmZEwf44IecLz0bHpgXPtfnQJnNI2KbuKgWbmZEoE016meh3YtMxbq
	CYnWyZwyqB9bUnhjJapO9qZkgaqjBnwV8rom2RVKTZnwC2/xb6UWDMNp8NPf2F5fAwD1TPHYlzp
	FTwb+H8qJY2ZSN5pc+a1yy0s=
X-Received: by 2002:a05:600c:4e4b:b0:490:bfda:7d7e with SMTP id 5b1f17b1804b1-490c258999amr250328975e9.3.1780907780958;
        Mon, 08 Jun 2026 01:36:20 -0700 (PDT)
X-Received: by 2002:a05:600c:4e4b:b0:490:bfda:7d7e with SMTP id 5b1f17b1804b1-490c258999amr250328155e9.3.1780907780459;
        Mon, 08 Jun 2026 01:36:20 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3918fcsm427602815e9.3.2026.06.08.01.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:36:19 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:36:02 -0400
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
Subject: [PATCH v10 10/37] mm: add folio_zero_user stub for configs without
 THP/HUGETLBFS
Message-ID: <60d48e3c6f03238f385cdb8e48f6d8ffd4cff387.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 99jgZGc9S8q8opsK3X5vYoEGKNCcqnf3zMOvcaA5-b0_1780907781
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: f4dcuop1rqdmoy7k35gufuytor63mbix
X-Rspamd-Queue-Id: 05CBC180010
X-HE-Tag: 1780907784-445595
X-HE-Meta: U2FsdGVkX18Ni7Dg2Xu9K10+K5YR4PNr9erDoOlgVjZ/TuQ9WmkE9JLOLDwstgLdubGqn1gPJ3CaFXRk6VQHvfWEqhguGSpjqfbZa9OpTAYyVGulP7RMIEXgeuUJuL3rR16RBS8hUuEKU+iOmAkeBU5p69Qbsezxnt0eOK1IN5013whbDvqaLbVxLxslmrvKHMZMRodI6Ya2SoSSqLw1WcE3GnhQ6UGX7llYxrVv4ccU+L6MwxPFXliiqIa2HOdzmXdf99CgfdF9jcKGOL5ZncxPzawyg+pylquMXSegdB9pewnbzcP+218AxaVAFwk4k8BjLTDs1JS/LS9SRDCyv6ehpRZbbJIna65b50EnjXTFImALLsII0zy1MXI7Ek47bzemxlRf/9X1EQvE1tOO2O0FWa/6kKbm/5lzNVeU8jQFJvlqNXCYzRV+enxos4+aSo6uF86dZc/4pZM8qEtHhZ0RbFKxXsIQvSu79WmkkalXr/EPhEMu+K3ZDsmPvz0G01kIFJUE+Dpv6eNHOcGgDjeK1qJ4jsPJjUiKm9+DSBt0Fjga351CzJ7u0pdHlrFSUeTtSWB6FYwl4QG5kntpZiZgXR2ghMDAg0uF4johu6RE1gjhS7StoLpXF/5IBNXeXaka050AQ/Liro7KmiLtHMk9V9IUBSdElQKZ+yyJdBfLWmZBf4fmL4gTx9As+0sIAF+E3ijRxHo71rswhqOlwA25L/Bk1JS1OgJRgYDtI1v8O61rN2f9D3T+6cGfAeEMujwL/om1Vnit5Mj3TfXzrqGaSDeVkmTt9MZR5xbOTiwEActNW9CPUFZ02zeG++dh1K8aKKqkKaYAqqKsiAyhe2U/7BVpKs/IoF3da0auM9ENDZ9KpJOKsnSO3wC9YWcKmLu4yPghcT8OhrMxMsvbtbI285aDBoXoMeDRDgBLMk3AER/xd8EuRQh10K1LixKXCFnPSDAt4DbRMJsjWl9
 iuM9rUPC
 gTgiI7PgTDuY8qkH3bl7JtiMquwrNs2Yv9oItKMBfHnDMif9OLJXzCQ9l2jKhnH1h+L0+kGW1bpbUn3N1BQr8WyjJaxSpnaUaElm9Z+tElp99LBCwZIffSopiswn3k7/tSfW5SSUvtLMYJF/3G6vXBEImr9j98Hy69X6u7JbSyvB4OEy/g+t5G6GMhQ+c7ZCMkC0SGQdzPB6MSkzXNYEHmcu0WgjAreBMLWdqdjMNUJ9/2WQqA3datv7YCDkOcbTUtqK85IHITRWrybZFNPTP6mCv582cwLAVkHIaisHfnQBaFWkeogDCxROqnQc9log2Xi1kByGGmQrReviUWZk4BklxclgxXRuaDpt4yDneZsUZ31wXT/ykmQExqn8lLVB3cd1KVrdeF5/wcF1JevBLY3iyEcupSZ8BmuH3iurOXGcGDuzkQAqUTAbdrz4fYd6UrJ4mtziqByEvDUoaZwso3/Pa0Snp+MTQxgWl
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
 mm/folio_zero.h | 18 ++++++++++++++++++
 mm/page_alloc.c |  1 +
 2 files changed, 19 insertions(+)
 create mode 100644 mm/folio_zero.h

diff --git a/mm/folio_zero.h b/mm/folio_zero.h
new file mode 100644
index 000000000000..c135b3a34da8
--- /dev/null
+++ b/mm/folio_zero.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef MM_FOLIO_ZERO_H
+#define MM_FOLIO_ZERO_H
+
+#include <linux/highmem.h>
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
+void folio_zero_user(struct folio *folio, unsigned long addr_hint);
+#else
+static inline void folio_zero_user(struct folio *folio, unsigned long addr_hint)
+{
+	unsigned long base = ALIGN_DOWN(addr_hint, folio_size(folio));
+
+	clear_user_highpages(&folio->page, base, folio_nr_pages(folio));
+}
+#endif
+
+#endif /* MM_FOLIO_ZERO_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6d3f284c607d..0943ab724032 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -17,6 +17,7 @@
 #include <linux/stddef.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include "folio_zero.h"
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/compiler.h>
-- 
MST


