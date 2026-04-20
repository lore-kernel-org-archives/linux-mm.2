Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525E0F588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793246B00A2; Mon, 20 Apr 2026 08:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7451E6B00A3; Mon, 20 Apr 2026 08:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B846B00A4; Mon, 20 Apr 2026 08:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53C4E6B00A2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:51:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04D508C8F2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:06 +0000 (UTC)
X-FDA: 84678919374.21.1A58944
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id BBA84140002
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YiNQSON/";
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAGKc42yexqH1EWWUAUEJrDKNbSbrVhgetE1tPIVhxk=;
	b=dsoQz/T2fz25Fbc1c/r761taZvT5qef7bF77Ib5EbfpTvBY9FVfs0IbQE/Dn/EEPla4HiG
	fZDI40j4YlhvV91qBGgC4iIa3HRLyRqaVeZjwAWBPxHljE6GVipbdrcltIdUvzXhA/h461
	k4l3wrUjav3igCzfa3tPstCAEkNWmy4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YiNQSON/";
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689464; a=rsa-sha256;
	cv=none;
	b=UlphxMs8RnmCCL3v51cU7xKbj/SNNiDlxXTC3XgzNLNmGqqhjhpCVtTb4s6treJ/oUht83
	aQhBFhno452Gld8JACR7WPMwZs+mZYjx3b9S0pABQnNbCTH1Yf7CempyGv3eKfL0ZBqlrK
	u6ysNrWFPuzEEKdKe9uxBObp5bqSqPk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qAGKc42yexqH1EWWUAUEJrDKNbSbrVhgetE1tPIVhxk=;
	b=YiNQSON/8g87eryTeEMV5boZNvDQ4wLJJnMCCbXmvA2e7/T8Jz0KnRh6PjKyXgOkwX3aXc
	D6FPwSCxdjcyIXaD42Tqsf83dxV2TUmN51c4mzu8dkg3PP7u2npaqZfDbZIq9gQ+RriQDa
	hEND9dGdjgWJ5o6BLnb5bXnCkwoD8w0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-7d7MWAHvN5yB8HTrx5kIlg-1; Mon, 20 Apr 2026 08:51:02 -0400
X-MC-Unique: 7d7MWAHvN5yB8HTrx5kIlg-1
X-Mimecast-MFC-AGG-ID: 7d7MWAHvN5yB8HTrx5kIlg_1776689462
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4891f97aef0so3768855e9.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689461; x=1777294261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAGKc42yexqH1EWWUAUEJrDKNbSbrVhgetE1tPIVhxk=;
        b=ITZ9KxAOh7pu58NPUe29I9nlD+pnJX+j/oITId1blqJBbSJgNBmnFoF8QNWMGnJa9K
         rgmwiLA3LYjuWReYMOwFu9nMsjGffUz1cJsGIGdLskhL1IHa+thbQzTpdIQdwVqk0sjx
         KmkZpTONoOI1corW5+GCsXZ0/S0yKN2U7so4AEDVLH1Dhay3bsL8Iiqa/RDG5qTI8Nua
         3oJ+EsypZpjZx24+2/nKRAwllluGAZFvQmGyH2qGL/gMhUd3inm6IAjhjZlV4K6Jq1z3
         k1h02cBLaf0m+w4x1S6wxf7i4IL/wLtAEUN21XtYqX8YWjtrZU8sbukRdflxob34eSA5
         rvvA==
X-Forwarded-Encrypted: i=1; AFNElJ+hDacg1YAcJNutEUXYwgcLuzTJ5ZVnzcsCtV9EIYJ/ZWz82hzLTlNDNFPyw+jrz+tg+kgqu0EldQ==@kvack.org
X-Gm-Message-State: AOJu0Yy45Vlf0fbCP1gsVpX2OcU1t9uy5IZ1iNQ1kC56PTVAM5PW3aU7
	foJx8ZeaH6wu91DzSKVHCrj21tCm3XS+4wsPat1Lwk6/cki3WvTet3ByicjdJb2BU+n+G1zcg2A
	K5KQ3Rwi4xnDF0gOk/UV1UbLWx9eF2PBVirlHlA19It1m8hAqQsDj
X-Gm-Gg: AeBDieuLheJrASWAYV0upNpmpeHlFqEwu+uPEEVYmaRRRsE2UO/ZW0MbdRJQI2PKZLk
	WxXuAz64erh7zlZtnS1rAhwyN8fohVoJwykBMT0X09JgFh3AhsggAiyrX2BHPpa0q0LHmJ72pi6
	C4sfMhaBHrLXZu4LJZDYogzfVJ0Vs+JQ/h4lyWQczcTSy81XVy8i0o4Gl/Fz+HhryVP1fUeiwSb
	f1BGFUliQg9la34hjc6t4YzAdVv0TIB99SjXLD7pTon15WIjtPY4zn6eccEFSwgvBoh5E/xs3Uh
	azFRaYvcCiw1xIXQCKHAZByVWN7fplMU24MRAoJY8A24r35LuWkGHYyGKqYPSF2VVPd6ApM7po9
	45ryKpTF1GkyGZ7SJ2znl30+pQczXa7etd5kGAiO2tBPqKxm06HDOdw==
X-Received: by 2002:a05:600c:a00f:b0:486:fe83:8621 with SMTP id 5b1f17b1804b1-488fb788924mr200859375e9.23.1776689461535;
        Mon, 20 Apr 2026 05:51:01 -0700 (PDT)
X-Received: by 2002:a05:600c:a00f:b0:486:fe83:8621 with SMTP id 5b1f17b1804b1-488fb788924mr200858775e9.23.1776689460975;
        Mon, 20 Apr 2026 05:51:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb735d3dsm184142605e9.2.2026.04.20.05.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:51:00 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:58 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH RFC v2 14/18] mm: memfd: skip zeroing for pre-zeroed hugetlb
 pages
Message-ID: <03405f0008afd371021e98a985490dce7fab6e7d.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: unCxiB0-i7YMBS6k5iM8NepmcmCH6n6mfnLu9NecCWs_1776689462
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: d4npksjqydut514t9ra3ssf8gpbjzrsx
X-Rspamd-Queue-Id: BBA84140002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776689464-975855
X-HE-Meta: U2FsdGVkX1+rKO0Ws2Pt7jB2t+PKMv2UeUC7yZGe+BgmKqrgc7/jec+Qiag4+Xz2sK8TRLXZBayG+oHFSKGREqr2E3NZUD8hwgpwPoVaJvqm2M02CQUNsrTfU8t1BAK1gogN212Ti5K9jYBkj4bFSpYX6GRJzs1frTspEDo2oPjdQyaG8v2ExKB2dp6Uq5Ym/v0QtGW2H0EUHsDLDMa4GUPrsO3GEGESCrS8E5IE1WwM0kCXHOkMtXpbmLnMsF+g4Xu4MQhInvGbuN/5pFw+lImGeItKribxgAuja1xgpKy4M594TbIsCw1utbQeTPDyxr6G4tlB54oSmB6aee2lm2Kzd0RHilaoj3DbvA3G22eS68yV5evEBMVYzo2wHgnKMVQqWCC+hoGKnxlS27DzKU0d38cz5ycluqBy2e14BC6epkRj5xb+geher1z3RwcwF355fOYe9BXfIOj41/0lbdSaCvRB+k5YC9en1VqYmAelswkXBP59woGcvTRUtwly9FKVjDkiWR5iishR3FuNIrTs7EMYfwynXvXD3nv9kkSjFkEn6etQSqWLoKNBZq5EMZUrS61hvcdZpYdo4wHDg1TdIg7NjzultZ3EaN5MRrzmgEDA5RgcZ2hXfmhHrhEUbP8d3ITJe9Lb7aJKZWn4lhk+maUsH/zPYgM02/NFanzak7b1fnOROMAlD/NupZHLMqDMsxr+cKOxndTAkmSXX7Cds+QnoeavqUIbw4NqUxfJ8OVmsIsSFHlaRKsSnxIYip8cajuJ9CTS4iEsUcvFT8SYd2p6qDwqeHzgrXsoTohf7pgMZr09wnW48vwIorP33dhU7WWjaNhM1j60bmqGoNKZn3W5BIl7noXX2Up9EgNUZIepb5pMrR3gHSnL41eWW39j82UvaUCeq+ydbvYXwnlgnj0pr7FgM0kyjlSledQTK2BC2La6PB1XgJzPtK22GWFGSeL6FrsqOddkkfH
 P6yRw2Nr
 Z2lDI7R2zDEePI1tlkrMhd7eABBfXdJ6ilBfTX0RLgwu+DynnWnnX2y5UsjwqSZ2tikA3awfnfjGlsgxd3Al/YhdPBFLhNLKEbWgYwHQDD+2VPJXjo2M+a7U64j4PntoY+aPrhhxSDto8DAsjxc+jbchffzbqhZS9mVayouFyUQomEe2l2weblPsTHWoUMal3vcrrnBoCp3mfxQX92R6yVPRieGcj6Ortt9O/uJHo7nb7z4v/RhXgl94MQFkCgi6r+SoSLf5AvBrfsIel0eMZBeKo67XFDiUyh7xD4Q9eb0482MiN0Kl+KmcMpmuRMOJ8gxYY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the pghint_t output from alloc_hugetlb_folio_reserve() to
skip folio_zero_user() when the page is already zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memfd.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index f1c00600e19a..546149897369 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -81,6 +81,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		struct hstate *h = hstate_file(memfd);
 		int err = -ENOMEM;
 		long nr_resv;
+		pghint_t hints;
 
 		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
@@ -93,17 +94,12 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
-						    gfp_mask, NULL);
+						    gfp_mask, &hints);
 		if (folio) {
 			u32 hash;
 
-			/*
-			 * Zero the folio to prevent information leaks to userspace.
-			 * Use folio_zero_user() which is optimized for huge/gigantic
-			 * pages. Pass 0 as addr_hint since this is not a faulting path
-			 *  and we don't have a user virtual address yet.
-			 */
-			folio_zero_user(folio, 0);
+			if (!(hints & PGHINT_ZEROED))
+				folio_zero_user(folio, 0);
 
 			/*
 			 * Mark the folio uptodate before adding to page cache,
-- 
MST


