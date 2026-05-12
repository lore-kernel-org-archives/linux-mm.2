Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A3DCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DE06B00B6; Tue, 12 May 2026 17:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1652D6B00B8; Tue, 12 May 2026 17:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0542C6B00B9; Tue, 12 May 2026 17:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8DF66B00B6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B29958D2E6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:43 +0000 (UTC)
X-FDA: 84760001886.20.8A83745
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8BA5B8000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FN9EkYSy;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igR9Hw7C9olHKTfwoHAKRKmu59bne/n7R/dh04grefg=;
	b=fxd7zd2Hp4XucClMNJBtHF4LefRn1/C8wumf+bS+Hj6aUsK8yh+FGPOGc4RueCS7n3AVst
	mGk3jWWRLdsebb2lUZbLN23vRaxDWDZeaPSVivXhJBVByfkUjJYxEbt/2sN4FwSdAUNYgX
	bBbLM5dLJJ5cgXPs1VfRIiJV9qUvMwk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FN9EkYSy;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620001; a=rsa-sha256;
	cv=none;
	b=SmwUpt5E511bkkIU3Uj4VDltOQJPnmjv/P5Lw2NtrqOcwp/GywzY8stsWzUhL73JcT3/70
	gQUdqeTNrk9o4PkH9RJcIMhcq6HF6bZrkid700ui34lyZHFsMGx7JzJo1PGX5BQE5b9PN4
	TO4KduCvOuQbhwnIDpmYyb8o8MXE+WY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=igR9Hw7C9olHKTfwoHAKRKmu59bne/n7R/dh04grefg=;
	b=FN9EkYSyeDOcQSPDViEWO8v/SeEIB9+cDCee4/+2d/WNlkwZRkvT9KQq54PY4a8Xjtn4wu
	jaMuQUXD6jECrc727lTaeujkEyfc3eMvjm0MY579O7FWaZXpiXZEnI8oYPo0kvkzrqB/9J
	S45niQqvSN3ySG373h6SVlBpcA9hoHk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-4TOfZrjuMeiX0iodlUOCLQ-1; Tue, 12 May 2026 17:06:39 -0400
X-MC-Unique: 4TOfZrjuMeiX0iodlUOCLQ-1
X-Mimecast-MFC-AGG-ID: 4TOfZrjuMeiX0iodlUOCLQ_1778619998
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4518f777225so3894563f8f.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619998; x=1779224798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=igR9Hw7C9olHKTfwoHAKRKmu59bne/n7R/dh04grefg=;
        b=Edj1rYBGRsLomnXnAFLxd7eWQGKyWQ0vyGzYdXLoY/MRjvR8TqG5I9QGiCvSy34bYw
         HYSqKJagI1xO9aZyirPnlI78o4XMZiDpeGjUmpi9DJwNH38QsKjnY7WRGymAeVC2tL+B
         2oQMuCfDOWjxZrYFwIIidXPZD2JWPfLWnh7aozRLrfv0D7oqae2IDOEappxJLSBiWO3t
         Z4BiBiJmHSVlAygY+lGOPnAI2DvOFG2/79WgLx+O+oDoD8KxjIL/MfoLx3SijPHeag6t
         vmqEGsQrYgQYRI9cBdoyp9etj/F9UzyNtfuD9uJsC098wZT9RpGd/HnLkE8ttzn1pVjX
         Xo7g==
X-Forwarded-Encrypted: i=1; AFNElJ+QAtMCtwEzh/ChIS4/AlE+p6/bbiMaqi5JIbRsFTfZmHqzOtarXz4CeuT10NySUIAMl4KurQMrwA==@kvack.org
X-Gm-Message-State: AOJu0YzvKl5Uscy/aasPTKFTYjm7ZVIZkCCOjfoE7mQ8tfzLOb17nrUM
	Ma8OJQK3ocuEkl8OXYBAWqsI6tPIXP/pWQ983d2xMW8eA4fG9rRuqKz6UzCbD68/kPj75juqDfw
	9wQgeDQ74fEzE8GgKSoquFDnp66Iynuj90fszIWhvh3ytGV5XoGaW
X-Gm-Gg: Acq92OG8QGYs9UYFfudkKR8ciz3ynO346qz48UvHyYr/F+qx24WWCQLSy8izes1RT9y
	qyR1ovqQUduDPitF3pK5nkCvQj0asASNJ8qve3rj+4oyLRHTOpreN4c6tqI4htdyVZ755vmffRN
	gUqBvZiwHJ9YdXFpTRjN1t/NQpfOgYRnz0E13nMiISp316bC0fY4do0TOKyG3qFAZjWkSD5hTUK
	MBa/w9Zo01onpiAVEFhkKy/Kue6kuhMMcduH0WAr7UuslKlIfmKfgOkZWd+VLMT+flVvQbk6oGv
	Fgc8PkCS8R94UYbILRKB9wVjVLz4wB3i76JlQS0JURDUbvFe8IpXx8hjP/jqkfeFssmmVEOPmCl
	prgKCT+hN5xrOvNzORhQaBustU3i7lSMOdujLEGkx
X-Received: by 2002:a5d:5f50:0:b0:43c:fbfa:20a0 with SMTP id ffacd0b85a97d-45c79f29848mr16487f8f.25.1778619998245;
        Tue, 12 May 2026 14:06:38 -0700 (PDT)
X-Received: by 2002:a5d:5f50:0:b0:43c:fbfa:20a0 with SMTP id ffacd0b85a97d-45c79f29848mr16404f8f.25.1778619997694;
        Tue, 12 May 2026 14:06:37 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548ec6b071sm35131308f8f.14.2026.05.12.14.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:37 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:32 -0400
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
Subject: [PATCH v7 16/31] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <94f20c24024cde2587026ca881a6a7ec64e264d4.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GyPtT-ZORkVI8I1akC94AkQvePnAvhvOmjQCRTmv8QY_1778619998
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: uic168agyb8fxztend4ezuphdspdoy3i
X-Rspamd-Queue-Id: 8BA5B8000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778620001-932227
X-HE-Meta: U2FsdGVkX188fm0zNx9NXshEnI42+8wKjZ5akwPrC1uLWnS/N+49bXg6H/2P+K+8K8tOvRMy91thdPxeAxq0OUyoWbRlD/xMw2lTSLWpIff68NiRDp0MvUYfeNwgVbG+E8lkOIOb6ny1sLyGSkHTb37C1dk2022Hu3kDuTR3/ix0jsxs1JYnSsIvd+bxdSmiG1k7nX/aZE1QuawCWG+eVBXVcaUAxWMDfJlIzfc6NcjLSyR+fyHwoy4n2M03rYPsK/FOuBYOuv7oFQShHcfHE+W0CCwtZEVj3UyNvxNeEGDYbtS4BCto3PHCTo5N1BGt19GBAz2RWbWc8k/t1CAtMCCLGKEPwkVTVafIP6acpDRYFidyo7L40XeHfsS9G60PaqiZSK1/Lr5zcmeYslE5QE/XcTWYuXZTy9JngP+2ynxTc08ml7Uz7PqD5gR9VwYiyEwAhtAgHEr+rjf+F5L9UuihHTC29ENcjbH2y1iyYzkpBhIKxhOhSGqC11Y8rTtSn5a1fQbj8kpG291tjVUYEpMS0DKCzLouMUa7wtTUcwtwYE+s0VMAT3m2iBF00Swi0CnBmSP8dBKOtMZcI2DxPLxah2FiUGiOBJBIgVL1GsoEvEZtz7u3S1e5mTsATLJ8k4vw+9cqp98FTtb2idjop8J9wnYZvP7LUS8jP8zF3NXw0/sW+HaPYG6Bc6rwiRUMnPQFlo9UC4vGm2UrK2/glyC2gRGE/5Be81TzdfFg1/YckL9KR/jGeoPu46Rjmmmv/eNGksJn/APdRBXBBy63lDNS6pEb1SJxYsAuCiDf8BpTD0Jy2wSfO3hUQRr8dFXK7DGE98PBE3YVJeo/u4n4Ja/49FJKZz8UrbFGHmf+Li897ddFNYJxHDkO7fL8np5xGiiC1+BDoeXfhaExUnj8yJr5VF1jlppzxaiD1uoSfyp+PL0pOfnSUMcPJGRxxjdwxC0WpCP1hlpyKWjC09W
 DCg4ynWx
 +y6kbLWuCsCFlbQILv51Sm6enXc4Bs+EM7jGKTcEvTaV/lX2RDxjvLy5ipviiyGq8QqhsKzf+PDbaIWpgrPR3g1QHzcMRn88y8d63f9FP3+GglB8uxsfiviMQqmNRE0CtNnEdgqXa7QwVeHUkRN0+dl2pONGo4+NoDj0OaBV7pce0nkPiPPzYIW/K4mLpw4U+heezIVuoCaYYMaY4Hf7yl5RZVl7U2vibglLOcREHucpyFsenGqOQVno+rQfK/arRKc5TZKaT4FaVwWYUY56gxgBPNBSfgU7xNQlknE8dumc7L4+mVfNHwt/U9XflOUglMGQzl+E7JPw0lCv0sxA7FQ97w4Mcotq4hMnlpR8EqC/dNCvP6UmFlgZeKwk9dTUvblaxtOA2gADKWAnfXECo1lgtFNjBSeOD+KAftQSAFWbYoFIAljxqQxIKJmViKEwyFAeWXM9vl6BNtF9VWAS6KW3WLk43VsUrdrM9R9BN+UZWgAYClpfOiMSKLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite. post_alloc_hook uses the fault address
passed through vma_alloc_folio for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d689e6491ddb..9845c920c29c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1333,7 +1333,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1356,14 +1356,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
-- 
MST


