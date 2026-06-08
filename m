Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1C4CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194EC6B00B6; Mon,  8 Jun 2026 04:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145816B00B8; Mon,  8 Jun 2026 04:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CA56B00B9; Mon,  8 Jun 2026 04:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E13F56B00B6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:38:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8C661C2B4C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:21 +0000 (UTC)
X-FDA: 84856093602.14.82D028B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 653D120005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PkRpVCs2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwQyRM0soCCwqjRtQ3TNBnEtxbXipQm56goEaNWxWT0=;
	b=Omk6ffyRLhlJx0T/VIgFgQJkY0NRDsLu6L2K3dJBl5o2z9r90Re5Da2pG+W5eF1NPn4iQK
	j9wwai6GT2RcuKgkcFb7evPX2oobBm0JZmCNdrxYoIozvR/4cHzX95ck/ZepKSa8TihEc0
	S9w6BKulqJ40vR9dM/SI52CxKBx/GPE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PkRpVCs2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907899;
	b=8KV68RiYaVFu+VCcrZcfcLWFnn5st2EMfXdI6xmoTeHiJO1/KIVRbE8rAy4I8fCe+ch5+Q
	JVZtZ4LyP6KApXYvZjog8TGP7TY9C2uzcINET4IajqQB3m4UYC8Z0Z0Bti4UT3k49uEFdP
	VTA1teqT9U2wvHYkXdw5XrvQfI1WrKg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wwQyRM0soCCwqjRtQ3TNBnEtxbXipQm56goEaNWxWT0=;
	b=PkRpVCs2PvPpJM3btipVFmUTuE868x5rKVncNyyMs87EjxgSnkZ/vHzq+aWdxDNh40iHRb
	ULrVBwzDEiFc8NW5rL+mkkrCrJZzlLnDcn9AEUzAlV95jNnsSEoLnzKFrqmsU00/aKfu+q
	Hw23fDuvXdWVNJV+HyJ0m+t1h/KCRpk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-YcZOlfcbMT6gc_M9jWCI6A-1; Mon, 08 Jun 2026 04:38:17 -0400
X-MC-Unique: YcZOlfcbMT6gc_M9jWCI6A-1
X-Mimecast-MFC-AGG-ID: YcZOlfcbMT6gc_M9jWCI6A_1780907896
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-46010392f89so3681638f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907896; x=1781512696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwQyRM0soCCwqjRtQ3TNBnEtxbXipQm56goEaNWxWT0=;
        b=Ievq6Pdc77AQ/QERaWZM/InqMy2k7S+9d8+zy1L/zkVLF0gmiq7AM09MQ2ftUGpGfv
         6pqRPjvTF4u61+uhvNI1ciRJqXYN5YUDL54Pz+0JxC8CoOTYf92+GBZE5gVGTghQErn9
         +bDeYDviQPlvkePSo/u248FMH+q/hcdE9WHXd//6SDIIb1TBv6+xPq5rI8CEfnezsc2S
         iKEYAPXfCL3d11UF4XemgjoMYHYyMw04qeMa/8ElfmmqMQMihFBaHrLdX60idDoNl1bU
         pcNY6qgOgGE7MaxvqIV/ebL8eMWECX0kcs93Iqi8yFW3fI1KxjThzNtyHaV0GdWGJVrQ
         yu6Q==
X-Forwarded-Encrypted: i=1; AFNElJ/LfZD2axUxhc6DPyGTSNI6YCM/X2seC11SBjxHDnuLpxPROG2pkqQw8BPq42IgirY1lq0BxEm0aQ==@kvack.org
X-Gm-Message-State: AOJu0YwX5SdSbpBBvwcXHnxMEkppRLVloTVrKs6YcbyF1yEfDZQoIqAT
	p41bZwZqCtU9jjNhZnLs5/QDW5NxJ3MZ0wJYRYWWDncr1wU13YNiQqbgMG1lFjpwxTo+psX/hDG
	OEDCZQAMSegFVv/UWcKPLufXqnJ9iIjsOqrCnpuQk6MPJxezo4kyd
X-Gm-Gg: Acq92OEtWhQldjr5596oIRXWUeBgyGOwYfIOwHp/HfDGYGxKoGLp15fN6h5/BbCawqA
	A9OHNBny0xUt6QwkyAsZPXCHs6BwIEPa7vCGgMGVsCMfd7WpPpf255wVLK9KyPEJdklYivWOSOG
	v0UGNCXbUU7+hWLpxMxZwRGueJTsl7kV/7EJpVxaCCNBo13D6iK1JyWxcnMl1opCuh8RJ/zcQdy
	7TQ4PLfWaOxFvburrQ/IiH0ZHEKGkzstFrfFitbukNNmzo8tlDebUCTh0/ehSlblNSyawvPUvVX
	HF10eoy7ykMAsmd3MENGNDVkg41JMgP/v/5SEVO9LEfj8yB7vw5HJHCzPXUi1UgrqOxmDUPbXX+
	8h1DeHthf/mEboc96whZOIhc=
X-Received: by 2002:a5d:624a:0:b0:452:3677:3fb3 with SMTP id ffacd0b85a97d-460304ebbe1mr15950845f8f.1.1780907896414;
        Mon, 08 Jun 2026 01:38:16 -0700 (PDT)
X-Received: by 2002:a5d:624a:0:b0:452:3677:3fb3 with SMTP id ffacd0b85a97d-460304ebbe1mr15950779f8f.1.1780907895867;
        Mon, 08 Jun 2026 01:38:15 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f344541sm47271286f8f.22.2026.06.08.01.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:38:15 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:38:08 -0400
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
Subject: [PATCH v10 19/37] mm: page_alloc: clear PG_zeroed on buddy merge if
 not both zero
Message-ID: <918897302a4cab9f476625adc238ec65a688d1d7.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iCpmMdflZBWbXy3OB7KHZDLukDFfIbkcPl7RXRy9-NI_1780907896
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dmpjqffw66maf7hj1ny83go4ii1jabci
X-Rspamd-Queue-Id: 653D120005
X-HE-Tag: 1780907899-476478
X-HE-Meta: U2FsdGVkX19GgIoLFLuWwTEoy+j5nsdJUl6hfZgYfxwCFgJkLX6VWylhyO3eToF6shg6NGtio3cThpBJvYpx77Y8wItOKH3oANy3erF/7YmPuvSqjLT7MBdaJW7C0s5MdD8xf/QIW06OjtLF2ZJkxUEenYp3UzhSyhOmU70j/6j+lZ1oF/zpS6AUKUXHzcMl4F09VEk9lFOUkU1c816g4MEORlde3aEPLfsyVp43ASEGjJqt/qYNWxQPlQHJkjljduDy5gFNciVn6p4/PQ3aaXBdixc+EWf0wNlvBHgX2CNmQyxfz1LdZhhnQtdYsiZMQn928aeioN9lWvJ/xBPdMph9WaAMtCeUdpCEDgWJocncDBJjTKp71Nb4+RFg3yUXL/ujy97ApKQHLtJBCldpY6IDm0B1cPxCqaNx06uZ+y6EFTDJeJuanKzII6B0wJs01s1vAgazkHhaCDWXBn5EaawkqlFMSlB631gvZcwisF30DH0GUe6gqIY1ccQ2Sb+AixTpu1cPKTg9vsYzLCmhTc0wzkwUz1LWmzZ1VvKtVFkDNcFIT6JXhX1iTKZiS1q2pa81+BR0pn89JqBKtozUCmzB4xMrmPbHVCq42eCb53bQb0rAUkIjrupp7OKtHwnZO/8+NlOP9KbtdvFxjVEF+g7VBAatiUjJGcB0AuXuupBJAuVDz95JM7VkQ5arwkR3t9fR6pXK4kHkhbiCsUPbs75YooclZhH0noovSsC+CKM9eIDtDIMkAbmU7ymnlP0q5fvgHkKFGZqIvOW/motGgLKLfZApd9lpHs6Z43AE4YnisnKFq+pXjSM6dOX7I7gfQ4ijTP6kMfV+grMvYnq7SnAoHXkLporAsJV0GHVybOviJZU0SAx1O26dJKzGFbUZnpbaxKSrHtDRjkt3OoqI8VTFqUODjtgJpAKKOTHDNpEsECFcl9+umZPgfOeDPNjufIYOOs2B6NpJpetxyd/
 YljZNnwt
 vHCnQs3oXoLdWcNdGNCzGAxUwC2FwzIGzs34OqPb4BpwvfTbuI+jbkKbbAcdNj9z28IrxVfC2UQryWvJKkieZDAk6b52pmy6cu6C6D+A9tC0mPyZWEepXuwrkTx8EAKAl7xkf5Z7e1BJRO8fsberEOGfEgt4dWYMB1n9py095b7sImrtlewOBrWV29F5wn+Kapv02ViFq+RX3MxKbS2XTnUUeFGSVsCtwuoYVEhp0CZ4sCfWNedLmn2XxCxLP6wyrcAC7TpJue7V5P24vPnSRo6mIV0Lgq21t2iJ0tEUzLr7ZIn8c4Cxo9tmNanrm5IEv2uoznAoYu1rJ5YMmkKQ5UpgdzfEs624vtp0l4qdb1K9oOYLwN5eowxVbaP2IhH3O6vgn3DMKL/CTBi2OQhDXUJSmmphPonq0g6YcAIYCFHiTqVx9bzDN+6hF+7BVX8NH2SJaLqWPq05uYXOTqxAL5kw7Ha3ChC50dQ4EacQ2zdy12UPfGFDcgI2PeLzML8dqaHjZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When two buddy pages merge in __free_one_page(), preserve
PG_zeroed on the merged page only if both buddies have the
flag set.  Otherwise clear it.

The merged page would inherit PG_zeroed, and a later __GFP_ZERO
allocation would skip zeroing stale data in the non-zero half.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page-flags.h |  1 +
 mm/page_alloc.c            | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 91f8ddb1d512..9365d59ac1d6 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -680,6 +680,7 @@ FOLIO_FLAG_FALSE(idle)
  * uses this to skip redundant zeroing in post_alloc_hook().
  */
 __PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+CLEARPAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
 #define __PG_ZEROED (1UL << PG_zeroed)
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index edfc83571985..a90bca5317c1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -941,10 +941,14 @@ static inline void __free_one_page(struct page *page,
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
+	bool buddy_zeroed;
+	bool page_zeroed;
 	bool to_tail;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
-	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
+	/* PG_zeroed (aliased to PG_private) is valid on free-list pages */
+	VM_BUG_ON_PAGE(page->flags.f &
+		       (PAGE_FLAGS_CHECK_AT_PREP & ~__PG_ZEROED), page);
 
 	VM_BUG_ON(migratetype == -1);
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
@@ -979,6 +983,8 @@ static inline void __free_one_page(struct page *page,
 				goto done_merging;
 		}
 
+		buddy_zeroed = PageZeroed(buddy);
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -997,10 +1003,17 @@ static inline void __free_one_page(struct page *page,
 			change_pageblock_range(buddy, order, migratetype);
 		}
 
+		page_zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
+		__ClearPageZeroed(buddy);
+
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
 		order++;
+
+		if (page_zeroed && buddy_zeroed)
+			__SetPageZeroed(page);
 	}
 
 done_merging:
-- 
MST


