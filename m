Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBF3CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730DF6B008C; Tue, 12 May 2026 17:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1606B0092; Tue, 12 May 2026 17:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8356B0093; Tue, 12 May 2026 17:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC466B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DCEDC405EA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:21 +0000 (UTC)
X-FDA: 84759998442.18.17808AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 726EA120002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dVjBI+AS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axwB8YBt76LIJzhy+Beipy/onk26AHGibl0rZie+Elc=;
	b=WyLU2RcGYY4dp6DVVi4CBPT7oRFq6MmdV3YQZqSfB26g8MYHY+7VnedgU1mRtb5At5kGBR
	I4ID/cs2d1wpyuGR5OBxUc0JWRQ0YOLOnze1ZOhakb6mct7uZ/1ykOLogdEUGxdJnpy6OQ
	/xen5pEJIKC0qk4yzRPwVmreD2aR4E8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619919; a=rsa-sha256;
	cv=none;
	b=wK0NioujmC3NAj4hCd/YC4E2EGwoej7LRe5jOmTAD5YOmmY6LtSvuhoAVNiSf8k5TJYjIu
	0G17NsQiiRPiGFFgzWxhvbAyli8qVMe0FbABumpBoUXaJfUIk3hdJSjJh+SdOiGHEYJkOr
	Brm6vVd/q3LEjmMVQ9/SRCyO+sgO97I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dVjBI+AS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=axwB8YBt76LIJzhy+Beipy/onk26AHGibl0rZie+Elc=;
	b=dVjBI+AS+AM/egdnLSKPGEsHDO6JY1RBKPewQY9vz0h/mHj3lkxmub3KY6ivvAF0MhAyPy
	jNiIZDWIKTrZS0LPQwVzp5ROaJeFgzemFHKprIoV09d7ATjbdvQ0qH6j/3jJWU/2BQKi+q
	nIdH0Ia5flrHKIjRwAxfobDkmFhcBpw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-zlm1U-WZO3izVVAgmtgaHg-1; Tue, 12 May 2026 17:05:17 -0400
X-MC-Unique: zlm1U-WZO3izVVAgmtgaHg-1
X-Mimecast-MFC-AGG-ID: zlm1U-WZO3izVVAgmtgaHg_1778619916
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48e60b55de2so52979935e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619916; x=1779224716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=axwB8YBt76LIJzhy+Beipy/onk26AHGibl0rZie+Elc=;
        b=oiLrSa5TpxR1yYzFumw6exPkSgXA/35F9WzTOdhIntkuzd+DOoTIK/1yfonSFw8tMD
         w8NFxsncw9CvgMpP9jMzxAHJqX+rRhcOfQvHBHIicy3zeteKrKXmgJmVajIY6ob7XVpi
         +4zIDTKDyu/z7RzC8mZlb3K0r9cil7CMm+XTurbLJfUCD2Tm7nYdp79KZboMiSpf+yu4
         xzEJLSWKXspqqkhH+AexJUyeCZQB0Df1dAsTQckDzNdYGHLEqAj8pS3Lqz/8hWJ+QQOh
         dWb018pFui1qEEjNqIVR+JCJIs2/+oov087JmV7U4rPhZrJd2tQ141g7fxLcTrc8lk3/
         WW8w==
X-Forwarded-Encrypted: i=1; AFNElJ97JM5kb3kOQ++cXU/eXHtCD0jUlZSoytPZV2ft6B2nqw5G9bW/2UtNZlr4j4k9r5+s8qdq1znBvg==@kvack.org
X-Gm-Message-State: AOJu0Yyxr+pPt1KiXIAui36tykRbYWXu7nxfcwpJ3B8nzZFHDeeyEp3Z
	Uh1jSkcAHgDaShLEU5nwYK3XLP9ulDTfKeFWv8WSYXScYbg+4ZJSoz0U0bmBODxREsTQHX2asfo
	718asNxXKOa7jyDQN2KPTOs3TmzhC7YoR00iSmA9hYwInPZJp7xsV
X-Gm-Gg: Acq92OFkLoWj081/8LJWTursHxCBlRSWSGy1QuZ84eh1poGaTG6eYrEjT24P3Fg1QX7
	Z8e9ev14MGss8gldQms27n/gFFWiAPqi5ZJBCxYorbaipoGSY8oJ96sNRdIcdVejDgZqsK9phTN
	nsyLFh8T1QCPJ0UwmiLTpo0iwEL4SV0cU1zeSd0hjoVJoi0QbTMTsDkGKUkYF+LC1WPZ77aRfMZ
	NF75M1fynCWumdh1sjv4FLkjLBCDVp+fEGHFp4rNsEgkEDapBkQNKy1MiPGXWQu1QJ20GOTfv0v
	YJKv04oaOaNoZcWPU0oKwZ5KNEYyV2OXT0Tf4kEMYxr++RQWITqm0nsTiz708D+ezl9dzMxoYZa
	S6+6hHTFs7/UmGwJO15gAm3qbWISYOP3ItAESLG2a
X-Received: by 2002:a05:600c:859c:b0:488:c683:be89 with SMTP id 5b1f17b1804b1-48fc9a09ca9mr4482215e9.9.1778619916290;
        Tue, 12 May 2026 14:05:16 -0700 (PDT)
X-Received: by 2002:a05:600c:859c:b0:488:c683:be89 with SMTP id 5b1f17b1804b1-48fc9a09ca9mr4482015e9.9.1778619915787;
        Tue, 12 May 2026 14:05:15 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d624fbsm57846605e9.10.2026.05.12.14.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:15 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:10 -0400
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
Subject: [PATCH v7 01/31] mm: mempolicy: fix interleave index for unaligned
 VMA start
Message-ID: <d254b3b52b4d39a5c2ca73abe49cc13d3c4427f3.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fj_bHuFQXR3RMfhQbnOBsf67fm09k0hqm4-xsGETkyc_1778619916
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 726EA120002
X-Stat-Signature: 53y5zpy9w8d1xb9x1tz846qt4xt5n85d
X-Rspam-User: 
X-HE-Tag: 1778619919-569806
X-HE-Meta: U2FsdGVkX18R+LJKgu2gJ8XH30Gq9ONAG6vY2g7aar8iKmch2JcYnGGhRe9ccpFvFDIAqV8i/btcp7SXw6WTX3G4R98/Ow9QHjDxGIH6QCPovwC17ltybIvBHzd2IG6cw3zw+fWfi/WW6OMWGz6muP+IFi6YqYBswQ6cMEvOzjJ+2pBNuyc9Tkb9hLIwAA6nODmzPOaJyRxAZKPsk0c3lE7DwV2BbsM9LAyJl4Bwocs+yQ0mMLVtfbGrIS8bsMUZTtTMP4KN/NCE9d3eGLmkE3c4Vup/9HrSVZv/J5YHz5Pz1cPr5JgYEU8Tbp4buQ2NxJ+3OP0w1FRg9N0v0E/EsxiyIBLTRzRz11TRKk0O0X22VY8wEPUg6BZKWKq/ptZVtuU2Zgs0ZaJSIvU9y85iMFPUEamNPJB9sSyw1oWpz/Wk1p1n0h3TDH9AwJ4aAKXhDCDuFz68At5rQEqZrxNIAoq7DJ0TEph8ulEYCr9rJQVJ+UhHvM62xgY5KWKwsdz8IHfmunFbKmM7vr5E34uhrzFHDxEpOtMDfDC/cHgRAqSds42Hbemx2GaJDDLhrXjols7txeUIZyZxRDfI7ZPQZs3InHdI2JjcpqhDv8lmD7MuIsJEq9k82ty7oDF5zNlz5WImw6vxb7YN2QUZG6DzJyqN/UkJTq6PSnxo5Fe23Ytz6WlymhhoP+hakZm5qy4YNnZhThk8IcqtdSi0WDeoFdh+sh2yN+J5LqyjvjEFGgTR3Ul6np1kRLorGBXgsPPiPuur0hOD2whyfMMdObaWhWkBiQgJPJZpsN3VBQRBpad54evs8UyRWM+gFvRFwEPZp/tIgqaJ7zNjG4uigLZ2pMaGeqeNwDsTVk7oIKF0pKRFMKyhuOKfkro/qHEwtxfh8su19JNRbwdFOz2iXkFsqbUziQYQTNjIU1PeGXZK/M/jxUe28J1N8gSiL2PTkbO4LqtdoQ4GSZ5XhrrHTwA
 6G/qgHhE
 4+0Gc0lErlqwxv+3DnzBf/Iu49YUXRFr902qAnzpI8v219euWThFUr6hq7y36zkBshpPC77RoIwwWgMwYzz4TOJuAiPkcbEN94L4tQ68quUJB+W/W0ZfikamG2/LyNc4G6JzV6h/JrOPEKMaELkcYIfwHWqT5Ahxfj7I6ASBmzd+5ve1w2x8fpHg+PFSPJdAfQJcaQmi2yyD6MWqfgdtxtKOOPC5kwe3Y7ZERMng+aCRbDcITb6GOstD4ohL0hwQM1nARYKmo36QtxbPBcJFP5GvwpIWmCmYdWKXHHkx2LhG/kMp6BBHwNQ2+ao5ZH27/0XSpWquwoemNCX7mqrw2rlROVF9xxk1S5aGJRdIgJywV28+GVp01neNGUTbXmR7fORv6JYSDX/c0C+l3SFlkR0PLYTSyChqqeO6H8TFz7CH9n3uoVM9b02HJDaJo8hd9JLiNATW869S6U+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The NUMA interleave index formula (addr - vm_start) >> shift
gives wrong results when vm_start is not aligned to the folio
size: the subtraction before the shift allows low bits to
affect the result via borrows.

Use (addr >> shift) - (vm_start >> shift) instead, which
independently aligns both values before computing the
difference.

No functional change for current callers: the fix only affects
NUMA interleave and weighted-interleave policies. Current
large-order callers either pre-align the address
(vma_alloc_anon_folio_pmd) or do not use NUMA interleave
(drm_pagemap). All other callers use order 0 where the old
and new formulas are equivalent. However subsequent patches
in this series add large-order callers that pass unaligned
fault addresses, making this fix necessary.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..b2c21ed1fd84 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2049,7 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 	if (pol->mode == MPOL_INTERLEAVE ||
 	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
 		*ilx += vma->vm_pgoff >> order;
-		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
+		*ilx += (addr >> (PAGE_SHIFT + order)) -
+			(vma->vm_start >> (PAGE_SHIFT + order));
 	}
 	return pol;
 }
-- 
MST


