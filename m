Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E56CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B3E6B00E2; Fri, 29 May 2026 11:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841C86B00E4; Fri, 29 May 2026 11:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758656B00E5; Fri, 29 May 2026 11:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6551F6B00E2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BFCA401BB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:05 +0000 (UTC)
X-FDA: 84820828050.29.484AC1E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id D697BC000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q9FRk9ol;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yH/Aq3jRD/J0BW4aKC2BcM/dVQFsNlzLQi2tKUktXO0=;
	b=vfk52aBr9DdDpKiKg6JIGlyqvsT1Xn5gTb9NOE1ie8t3ezJVOJsgygQatunGOXPdBKCE75
	dHVbawgRtmIazIzHmKz/axIcDeDOhKN7uzu56n6Yk4LeAyb4C0PN+7xBEIBQnFaXSHvrRx
	L3f+GjLt65Cr39SG7mTMv75Y5JcpcFQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q9FRk9ol;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068242; a=rsa-sha256;
	cv=none;
	b=H9r3jOwSpNPqAA4hgQVD5dgblmQ1CFu0eQ4TCag6E/RmlCVtYeWPB1TTSLgo6crh+WM6Ft
	XXdaqdc8imy1/20Lp4qrICD3ip67RA38JyYDQ9r7MJxPg0Xiv5grT5/GQTwopb3hC6rHze
	TX/zJXC+cuZZOm7cWzMpWMtVRTpxAuo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yH/Aq3jRD/J0BW4aKC2BcM/dVQFsNlzLQi2tKUktXO0=;
	b=Q9FRk9olPR3g0Cl0ex4aPsAkLcPUviujuI+nre4qQgP32HIwmEa6+F4Nk4iM1Td+j59vI0
	RSRlkYRcPVMn+1HJuk0o/BfwJ19Gb2wUABasVSfXSOarsfVIzuBLQJXOe40J8XDyMEm0gt
	gCIbkPkczlw4hL0gAx8I4TUz4x/NIAM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-HRJfiEmNO269xq7oBCVIwg-1; Fri, 29 May 2026 11:23:57 -0400
X-MC-Unique: HRJfiEmNO269xq7oBCVIwg-1
X-Mimecast-MFC-AGG-ID: HRJfiEmNO269xq7oBCVIwg_1780068237
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4909e29e78fso5213685e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068236; x=1780673036;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yH/Aq3jRD/J0BW4aKC2BcM/dVQFsNlzLQi2tKUktXO0=;
        b=gDvIk09do/AnFLx0OA/fKTv7Kne83GoYZ3VsSjG6iFtr20eLWRDHB84r0rRsGzY8oo
         SiIX26bt3uzsB3Fql4IFFuCaC+jAHxXRNtM7XGfO5DW827B2e0O/vtCEBSyLHt7N1qWF
         u7vbc9LzLlerSNu0OLa+DT+2seiVMrbZiM038hJtUH5/7qCu3euWka5l0TUBY3aIw9uY
         G+EoG0SzruwC3iBej9yFu7COQDFU/Ee7SUYppuV2adeSV9N9pBqmKVvGiTywzbiCF5M6
         eOpEYZzgFKmqLHIPBDpQyeTAM6fAPsxTUlFwD/fb6wtk9ldQ3qB2YFP9PB7obIVF8RQt
         TbCg==
X-Forwarded-Encrypted: i=1; AFNElJ9Ifyy31Fu0SUQpW23Jr+mUNkJx0ryADmrXTYXv14BIvqRA5/1/t9R3rbk0VgnlTJYxOcng7rVmRQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+WzbpyawFLAxaD8klmNfSIHJWgfV38UzZsfIodHUeASmjGoS/
	uwFzsCXrsslUMrJdogaIhn2SGJd+v2KDxT3XifpMGqdcOzFI39WrGe9KBA5DZV3jGPUFvr1oZUR
	ykCI8bwNY7yPHha/v1cIq0pRe7GDZ6jIVf39bLUyboJVFjbSlGjcG
X-Gm-Gg: Acq92OFgpgcdR7W0cLyAlj+IUj4rGpPBgfLHDZBx4q8xVYl9F64KV++DFfOPyr2BZYa
	/JfEiutUDl9CD3msFQJeVmKoZaoyE31hkLJn/WgY597jMfKhVsos/DPkBeHb2thrvZUiqdH5Hpc
	la1ofWFo6KSAPEd8aQq/fSYUfj1i880ZkT+LYzI/Tcuznn8QcfXVHTby+D0csqFZJcFcZQvt4Mi
	cfKv9QFW4xketKqPsP2HCzgZ3oSTa/6S3UCL58wDLOCC/fzD4yyTCaNhmJ5woqcUJEIY1U9IYHT
	VMgIQMMiwSIGbq9HO2l0ZC8kdN4+v67Yk6jCAjKrHm8nRt/xCKjScQG51ujRBzm+GZT2oHVs2TO
	qA0oXzY/Ec5bqtaqR9AWbFyneNIs=
X-Received: by 2002:a05:600d:6413:20b0:490:890a:da46 with SMTP id 5b1f17b1804b1-490a292a4b7mr1450515e9.2.1780068236409;
        Fri, 29 May 2026 08:23:56 -0700 (PDT)
X-Received: by 2002:a05:600d:6413:20b0:490:890a:da46 with SMTP id 5b1f17b1804b1-490a292a4b7mr1449715e9.2.1780068235845;
        Fri, 29 May 2026 08:23:55 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:151d:1200:7829:d653:3902:e833])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef356a4c4sm4498359f8f.31.2026.05.29.08.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:23:55 -0700 (PDT)
Date: Fri, 29 May 2026 11:23:35 -0400
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
Subject: [PATCH v9 18/37] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <a544c8f1fb6704bfd3d7ea40c2b6b589fa288284.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lRIrqUXmY-YQt0X2LFsHvg3lpxXPwywF_ATQaajRBXc_1780068237
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: dr1i7afstacadh7n4kxh1ht86139xeso
X-Rspamd-Queue-Id: D697BC000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780068242-261480
X-HE-Meta: U2FsdGVkX1+qQGQ4KlRGYm0Rmn1uIKZkEuZqDUt4tYv9OIiY3K7YMnzTZC5eZSpbthjhD/k/BedPIw1ctSnJQkU6pA0uHJEtbs8p0H1FGe2h+zTpppokIpcICRwOi1V+WiSBlvUClYUUOU+ZVsgrUCC/cA9AEiNjPNvOK74InxJhKu3OZCqY7KhSj7zaBsfDvWNVducuDjmac235QwRbzBR7luF0Wrb0rcg7hGt8YURTN3Qddkl5b1+Ov1ZODGFL7jGwiSzqsTqCJQDtThoypTH6E/R/wBram41mPKgeXr7UNzZ5w7S5r5wLVV0mGjwj8W+e9XQuCVI3e99dvwg+JqR1IGx0pXJ9gE7TmFxMrbQJfgQ0eB5BL+Yr04PsEl/a3+m3Mcg0qkEwSuTld9XUAwXFq5fzTzlhkB13oJrnZYwirh6Nbet5mzQOnCqXFaLJfF42ltxByi/9uO2sPGEVOeWVswwp3qAvg1DW81YipVvAh+VQfa/x6JJegn91JvITJNcDmFwtXhrFlGaMHkf7xLTkTft3WWZ0+W/H6UEi/tSzzLDTIen7FK0LID2U7tol1BjGvUb+rU1LDguyq/Yt7x8dfXQLtX3MS4riCjuKd46NJ2TWxVrGQVVpP5Ct8J3NQ/qTCdsk90eFDLVTbkk5iJMMxY+cAsuX/75NVGjfTqiBd9OwPL8DlkLljZo2URSJPdbQt1yX6y97rAFQxQYrohBY5b+Qn2eAGkpelicmvYjHwyxF1T4pE7bALIWTVSVbqexIbxF4BMCAcwiDbWYralUkjSOvR3VatEMF3IRrIMhqMj7xF/P312jNpD/mX9j52I+MG4isYX36NPdXsj/GDfyvzLRfo9G26MF8S9bWv7Oko5A5BTYGOGTL4NwODOrnEhRQ20D86uv+FoOVA3BkgSdXyS91dBfVbt7VzlJAtYcVZ5evqe5P5uGtIAuvRg+g/tQoSi8EQ0CJcIVQO3W
 bQ7fAP7w
 l33ZRjLwCJr6iinNcdNVAENa0Ln9HYGCfAl5/8+OclI0p+Tgkvelbqoq6FAj2hAYmoOhXU4JVx9ksxo6gZG9Sg1GgaCsXtx2wk5MzIx+lCXSrSnIU8MIofa7Wj27V7mc485SBp1GqdeoMd7NRTmRy8f8cgsdQXFkK/5C8l18lwMbMcYODm3YGbTKgjVcCe/Q6T/C57zDZ3oG5hAshgCLnQtDUGa6bpNoWQwtxPGWr9sxBum0vuoqXSUYe1MjAWZ07KZ71xl4W+AreKqWqIlNcz9VFclSQZ7lhcPk9iEs1b33qRpSExjK7AptT9ZZ7Ge1jUeFB9Sb+6t3or+cmlAf9zLozjGHKAsU3BWVDPXl4hf6S7SyTCdzwvt5PME+dczGQ/5IqcRF2qssAw7b5lHQc7BaZ60Gbm6Xulsav3+voreK+BhsxT8WHI3COLk/zbBEnyroJsABwz5tLbmyXVSFMwWhhM8aV8jcqnxc5yoa7UFDex5stpW4WwWV0qNjekvb1gNrO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that vma_alloc_folio aligns the address internally, drop the
redundant HPAGE_PMD_MASK alignment at the callsite.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..d689e6491ddb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1337,7 +1337,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
+	folio = vma_alloc_folio(gfp, order, vma, addr);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
-- 
MST


