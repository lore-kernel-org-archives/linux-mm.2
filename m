Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157E3CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E0D6B009D; Mon,  8 Jun 2026 04:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BEC26B009E; Mon,  8 Jun 2026 04:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538196B009F; Mon,  8 Jun 2026 04:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4306F6B009D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:35:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01F62C31ED
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:13 +0000 (UTC)
X-FDA: 84856085706.29.99B5EBC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id C12EBC0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:35:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TZpLlA4Z;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907710;
	b=NSe4ehx6jcQK/Os+C7fv+04CMrL925NbVPAUEEpUcMkBWkeDTsnj8osPMo8G4SAdOCOmZj
	/2GlRW3Ae8juPlQ7dihJJDFnCEN4em8QrfuGfnnrHadkZ9epsfsyfuOMgN6eL8BVM+NyQL
	NgMVRnzBQnkzaux2XDsHOQlg2ZDWUb4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TZpLlA4Z;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrvJesBjI5N3mqdjRc1dMOyxu185onYyp291JtEzMjE=;
	b=jJziahFzzGCoF3AgnWpIHVHDeVqsyrkwX7ppKNLvfd7wcXMyvhHXVpDJiVP89CbtltbwBS
	pmkqDSFj1bBYanZum20x1QcTSmFyptgB4QL3vdFbAYmFpYMDlxQn6PiUm/jY8YcLWiy9bM
	HiyEWO4d/oOUTFQj7DYWrz3Z10zU4JE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lrvJesBjI5N3mqdjRc1dMOyxu185onYyp291JtEzMjE=;
	b=TZpLlA4ZSRqsmVpfvZRh8zFGUo99jbUo89IbiYTI8N5WXnMo+uYD2b2goSJ29yoAznQ4qA
	TYFGddmdx6aC5kIHfTGPXglq7hOEQX7/68piYBT3emlicBVqBU8e7KLRlnkVP4q4xjPCXY
	lIQmUPhqGP39Q/2CDmV07lSJe8lfZmQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-xAf83tq6O5aAd3ac82cOgQ-1; Mon, 08 Jun 2026 04:35:06 -0400
X-MC-Unique: xAf83tq6O5aAd3ac82cOgQ-1
X-Mimecast-MFC-AGG-ID: xAf83tq6O5aAd3ac82cOgQ_1780907706
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490ae461f8dso29972785e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907705; x=1781512505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lrvJesBjI5N3mqdjRc1dMOyxu185onYyp291JtEzMjE=;
        b=afT7hCd7LsEHQI6CdWagAHI4nb673qyGXqjlsrunLTtzoSUsJ63QXGswx9IMZ96hwD
         knNmkCOoByAUnyolBc3aHC4NdGn5+5Os2Jz+Cih/u/H//qbyK0CcvQxyx1n4fDU34qdr
         Mu0gmKOICIrOQIOQYLweDRDIZ0QwRWfqClnhdtbKo9ELG8iu8F9f9KTch9Lw+6fZCtkO
         s/InnWxKRyvca4OCOESf3gCaMMB5DLCOGcHjPSuoWsU4RbEy8l0ETCpK0xDmIM4wB2QX
         S5OqJF82AzyKT9tFrt+a2lHznqq4nBXmlgc7eQol1d0UF2NfsVKZQpByzLWCmIRYge8B
         K+tg==
X-Forwarded-Encrypted: i=1; AFNElJ/BnE986eqzbTz41z9fcmx48h9DQaoJVJZ3bI/4cIECXbp9zKOf6aooyWr3Z3bAbeyeGj9iR9Ieyw==@kvack.org
X-Gm-Message-State: AOJu0YyaHTp/R4i8O0Lf9s4TyqFAGxbKOs3tSrL7N86gqyFcaVqm4AOa
	paSctZzo8jdDsMgJDQt5ugCZ9Xz5ImDZ7ljJx97N1huStA8HVn71VAFYkMklm0zw228w2GrN2cB
	nkdEpWDWavgXd2ztOzoY63ckX741vwndSchfoUxPa+UtRtDkamCs5
X-Gm-Gg: Acq92OFInOGfnxG1lPAwPZH4g3by2tmXWuNmuvWQpBGMNgu3DGczaUJiWookdoE/oYG
	7nqkLJ+CH+asAGLjmRKQ9G3VG3g3FfVzBACEgK9NsvnJg8UxfKffc3IWq8hWOuF5WzITHyl/Rx+
	+74RsYnPM5Sml8k/FZI5LBqA9yCNZUghWh4NdwNztBUYlhNnn788Pru0CyQSUFbU6uaCKek5Qgf
	RbqzMWzxXE1TxXT82X2i0ExTSBD87fLHOZBv0YsZGdUJ7kJitOgXTzsyeqySm5bQ+QTC9gT50Sj
	Ijae/s/IMp1w3ak0TtE99o9MeoqJ/akvvJFclvPicO3m3SYi3K5EkIxgyewjjQLPexu3a3qWtzm
	qs1R5JdoF2DSgg/I4Y8D5ZC0=
X-Received: by 2002:a05:600c:6087:b0:48a:8b02:ae91 with SMTP id 5b1f17b1804b1-490c25b0231mr252123175e9.11.1780907705464;
        Mon, 08 Jun 2026 01:35:05 -0700 (PDT)
X-Received: by 2002:a05:600c:6087:b0:48a:8b02:ae91 with SMTP id 5b1f17b1804b1-490c25b0231mr252122505e9.11.1780907704887;
        Mon, 08 Jun 2026 01:35:04 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc391aaasm433938045e9.1.2026.06.08.01.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:35:04 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:34:57 -0400
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
Subject: [PATCH v10 05/37] mm: hugetlb: remove dead alloc_hugetlb_folio stub
Message-ID: <a9b5764c69269e5c0518e496b057a75354373b43.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WlNqK1QZauHq_GWM1m5-lP2-RvVY7-OH9sixqKCaGME_1780907706
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: C12EBC0008
X-Stat-Signature: 3sjqtwyku3e876yi1o6juipyd69pnw4d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780907710-875383
X-HE-Meta: U2FsdGVkX186krzbAqbQpwPM2C4ygUZHxPqJezeoSFYh0AQc7ojma5HJKffsurSh06+zNZbFbEC/9zoRTcnmI73O8DqTMx5q8vgAVYwa4tWx96vHS76JuXINfwxAZslUrPFPyU1Pyob6YRHzbH5FJs9aAmOrS2IkhgBJx/UU55ZF5rF7JChz0j4gIUuRk8ToGNrTqg/F3mBZtmOY+BLvsJLHvIzD9DxWuoRnIjqQDHkE/U/t+4dSm5Y1H6Z6xOI5aSyg6P3bkaPGlJyA+vPoebcH37f6MdMPGiLtA24kBnJDBIoyXYuLo8IZwvMLrBDFXxvb0dLYCuhp1AhG7NfmFeqUV5pjqr1hQK8Q4LqNEUZTk5LaowhWmsn3fxbNVPdcESvXvOgoly8y7bm8QC7WtRnnO/vBrhll0iHv4QdaVM0pTwLEiY+j4ITPpM1xzdjnkAVmF8eoHfCJK8HBIEnAL78ok896P8x84XCQPi42YLRf0ASpLo8YsT7aNkqy8hGLHD25Y1JkxIa5cRVddJg7UAR8JOiZXMx73hLNtzZH8wl1bFZ7JgSA9fkc5yPAHFo9FQFFtYEmNYQ1lGM5h2AKksiOVKw1ssJYgWmm9VvgRugHR36T7d2NBw9VNcL/Haruj5OqsWosvYEQLN1Al+SdnYBqsfrOYdw0cj/akHhf4e01vJaI9PCZZ/obxYFrp1K/ThemBXMfW4Ah4R/OQloI0rMZyxkUKCImr/oYAopO20g2evyK734bdL4pZwTGsUb6d7EqNsphMz9G/GaXzxt7osGFUcZd1zGMtyfoC7eTmDu4NVps3gWi6SGkvIE7yiU3SOltCs2adEWMcfaEDZnr3u71cgATjb7vwHU4OD4ZDjs5v8IiL6mu0wk2wAkmNsfgslzx+da6Wh2fbnjWdKbKCacUzwB1nNUZhhXJEudXVUbtQ7uLbRszM31sRM5Ea1hQuzOEFCUHigwAeIGQXNA
 ThLN3jRr
 T/r0ELxBqSEjeUfR+JZhbX8OrBWIN/P8ivVGhUJEH9IJZgghOJGuYu+NB0UwdIt2V8/OCFaMsES/ZUxRDEfsO4y+pchbMDqXKe7ssqL/WzlpIEXlNdB7whmyeT0kygNyBJUtFoHEmEg2TERzzFeOzbjxcG5Ni51xkqUOWjy+xQufkTYBl4izHOktSgU2M9KWoZfh3DFRtVSH3Pe/HsuOgXByl3SV/4JYYx3dELFjschJ6zqhF6btURUsdgJtPGG96TCOXHVEe5LSuTg836T0OCKAZb934K0mY/nLeMQOER/HiCTtkLzUaPdalvZmowY8olm8tV84078swdjkzQemvIyepG8B9GV2Ma+hEPjxBajmVToX5GqzR1lA3yMBJfvEn0Aw6Sz5RwhKA/IQYVjfLk63K/aES29bicjIbyRvajQX0Fz7Bsk/MR6KFpDHnpwDnsfynSqMEj1jir51X/VxGFSmExKC0quGsgMb9YJNGXm7bzypeHHXlh/KRjzde7RWI7Cs2FG2Suk1p6CODhPe+wqGkwBixaNokahlN0/3A7/LGKf+BvLpWJoQUkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the !CONFIG_HUGETLB_PAGE stub for alloc_hugetlb_folio().

The stub is dead code: all callers are in mm/hugetlb.c
(CONFIG_HUGETLB_PAGE) or fs/hugetlbfs/inode.c (CONFIG_HUGETLBFS),
and CONFIG_HUGETLB_PAGE is def_bool HUGETLBFS with nothing
selecting it independently.

The stub is also broken: it returns NULL, but all callers check
IS_ERR(folio), so a NULL return would not be caught and would
crash on the subsequent folio dereference.

Remove it now since follow-up patches change the signature of
alloc_hugetlb_folio and would otherwise need to update the
broken stub too.

Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/hugetlb.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 5957bc25efa8..1f7ae6609e51 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1123,13 +1123,6 @@ static inline void wait_for_freed_hugetlb_folios(void)
 {
 }
 
-static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-					   unsigned long addr,
-					   bool cow_from_owner)
-{
-	return NULL;
-}
-
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 			    nodemask_t *nmask, gfp_t gfp_mask)
-- 
MST


