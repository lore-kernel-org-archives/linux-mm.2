Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A81CCD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 06:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4816B0005; Sat, 23 May 2026 02:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850906B0092; Sat, 23 May 2026 02:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7186A6B0095; Sat, 23 May 2026 02:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE9C6B0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:01:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4AEE1C1BD5
	for <linux-mm@kvack.org>; Sat, 23 May 2026 06:01:37 +0000 (UTC)
X-FDA: 84797637834.27.6904368
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6497D1A0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 06:01:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bG6uTREA;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779516096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=63lvyRs9Tc58HIWr/RdMFYbATzvXY2B5nVbtsmU63VE=;
	b=mZn3hO6Uy6rwAnEqCVVUSHumpaJIUOKDR8CZWXbHtXsAMLsmkL5KQjDg541Ikt/Iz8orSx
	nP6PHZh6Jla/oK3Pu1igJmHab3LBkmz8XiwbmXC6VR58OIzR6K0uYzf8NER84UrTC/mesB
	WKwq8nOzB6rkr7h/d3qCoj9qH09iqcA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bG6uTREA;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779516096; a=rsa-sha256;
	cv=none;
	b=eCdvMEm29I6vW8dQSGKamU0WPwf3GVZeXjKWahb+tUIU9ElC79GFEO7wMfXwIUe6De6UEg
	s8BjnqWHRCTIIoVvhXShr8dhmebwhC2dGdWPVB7IzRWegfwETc89fQY3xRigMVGUAMy7O1
	Ipo0SoYO40A9G2eBQqO1EqrnTK88fkA=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36a8ee1e28cso696381a91.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 23:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1779516094; x=1780120894; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=63lvyRs9Tc58HIWr/RdMFYbATzvXY2B5nVbtsmU63VE=;
        b=bG6uTREAvjELKRtLJdGeo46uy9yZbccDLarR612fEnVSdP1jvB+iSuObiwMKSh0ua+
         aGRElqqJD2o+p25+hk3/g6WdwhAZMj+x0Ery8sZyQ4Z2y6bnpX5AT5FcUZtLmBgKoi/4
         Y5CU2dENw/ioBpHzw+q/lduCp7GggVcJqUcT/NYoWCTJUCsCuaMddhUCe3r6eBOvJoBV
         1N1KzRyGqpSlw4Uk64qhcApjziETZL4lDGslP6gMPaz3aGFoFKU3L8lJvkJxFSylFLjL
         1ujChHAl6qxEecT9d+V0Kkn6ij9voVgryHJdkBOmqL5jnal+yQBqKvpW5iIdav71k+/A
         7D5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779516094; x=1780120894;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=63lvyRs9Tc58HIWr/RdMFYbATzvXY2B5nVbtsmU63VE=;
        b=ibrm4eNFLxUhVpbBwb5hj8/JFkZKdu1hCEKiZn/Sj8jc0Tkhy7nlyXne6ckjjTiJPl
         5sHyw5ANPXw3IksCoCDSYlINn7/DEJSv2W5nHmpZcknCjAzHvkyuKWlPwT4erS0As4w5
         j0yozEHYN3V+ym1Ajbp/b+oCdqWe1dovJibMclGR3nOGrfK2NVDnuoRneXobmdjjjvBo
         4hp2A0j4Uj3LEVDeSQV7zPjlxfhbF0fk1A7dNNdKywNPNUy3ifnDDVNOatHQmboYrSK/
         L2og5V3VUGHKoQg0Sgm0aLDFykEjXqP7G+h/FgV6ThZNNSDlkOt8fYXwz7NihF+w9FlV
         PERA==
X-Forwarded-Encrypted: i=1; AFNElJ+An2O6y8dP7fmud5VHHr4gvUxkCWrBbChKxOy9N8QfGzN/CkSHfBbos9Insqcko66ATeR1DuH+pg==@kvack.org
X-Gm-Message-State: AOJu0Yy447nDVh2hdoJ2LSNFkLKMS+Yp6IaxFzB0QOueZRyxJXgU5hi8
	47v6wWB8YTbgPmcsxMnAYVAJUiJc3ugyPC9D8WfLWUfEoNVnJr6cdSdO+LHYEhM1Kn4=
X-Gm-Gg: Acq92OH0p/MQU7gqzEsqfh0tnob+0Ky42P6QJtCc9kF7SYemuzHLxjEAdPo+LNnoI9m
	/YQhUYuz/E8kftbLw6hLcZHVl1NQFXG9MhNhZt/ZADcXrdjWiw8425bZhI3UoH5AqZ6BgJsOdA1
	87fAMz54lNMJyl+Mo/qp/H/MEvOy2E6fzcWgdklucy387O9uO+sCeq3XjqvLBvF50AV1zYAeEn6
	mZts14CKKnPB/OshCf0P2+4YCPJ5/yGMJ63fI1DKtibGMiDlXQkQa8AVp5jIiweVWFauWFIXHC5
	a9lBmc8HCQ2AS5U3KlNcBxxz0h/hzYEdRD4ylRyEHNzzKsAUUDq5kNaKhhvsNnLrxl/8WnlXWYu
	tNmv0pSGfFFU3OUtdrAAppEdrZNleulVL5G/bo1O3/NUFQC9XwjMh8HlUm/ADip77QCCdW6SsPq
	e+3hm5PmhcfnknM2aP3+4wMKVuTb+lka+6bUEr1y0dFCU/jmsAuAOMmlE=
X-Received: by 2002:a17:90a:fc44:b0:369:bddb:79b5 with SMTP id 98e67ed59e1d1-36a676dc2d0mr6917568a91.2.1779516093645;
        Fri, 22 May 2026 23:01:33 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a7265a001sm3431127a91.7.2026.05.22.23.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 23:01:32 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2] mm/cma: fix reserved page leak on activation failure
Date: Sat, 23 May 2026 14:01:23 +0800
Message-ID: <20260523060123.2207992-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ob8yireqg8b75x3h9gdoypwhh3oqgusj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6497D1A0005
X-Rspam-User: 
X-HE-Tag: 1779516095-378443
X-HE-Meta: U2FsdGVkX18Bz4r3dC5PaU6FX0Ko3ZtrKew7+SOVOEWeBmraZnEOpPJ6Caj6WFkAzxhEgx5H4AsPaAbVaE7yLdScF4zLTIsG3nzfrlEmx82LHYS4BXdbnKKcpd4UUlSAxsuig3Po0Mxy4yN3EMTRDD7awDB4xd3OStZGC46BAbAL82CbifisMR7VmbkmrZhCDv7iO9sdj0l+TGONNNxTNjGjfuzFgjCpFsrzvB8MyBH8nUt2Hd9sa0quJTAF8BeU2fFbwTVpcZN0l7VlXxcptpPE/XQfXZYbaBP1mSUUb519oH6OMRCkrfxIx+TGNVwx7XirEGSJiW91ejkIkHOGc35Sust6EE/7PO1oV6IxRdj3PJY7JCmjjTwgVe9to2Puv2gD9lG773pf94QKY/G+Ih+R9PF9+T6EOAImBKr3ueDugSEe21+pu5t+A35dYADSKNN9nSv/uJqw8R+y4tlcvIxoTkKiq/767IkFvhkRkOVk34XGy5CX/Xas0PhnEXqjqH5wjpROsRm4xYs763bTMyk3EBgyCPI2WRWZh/i/di4TVzdi9EoztPugraxKgRfDu4sMk1oPl4KYz0/RPBNBmL7AlrDRUVt9G7LMk4XAnGGT9jUHgtFSUFYkbYlNxohkm+MXB6EJbJblSSeKM+9pdUgUwh6YZXevY1eRQKhF2+dXJj6xqlCDfhStdZ8Wgd2t408YxqeXqG0yQRKfXJnGB5ROtxkP4vig/WKd1Hpn52DpaChv0+NX3d5s/Bg9/gimeF4H69TBQ/+7ep1zZDOgacnooYrwiXI8ZB+kFu4cAUVjEgjoQngkubdQzfN8HOdwCv4wCi5vPqKC4GZ5AtiPEvAUMKx74NA6Tfji8G4eW2b8hRjyT1qVR5aw6pm1AmhqwcjIQ7n9wqp0qY3eayYEE2r8Gj77BdZ5/It6oaEjX0cAQCW9VaZ0xCL9jC+rd3iJWx8sA4qbIBZs8tQtE2K
 6VTCG1CF
 bdzyS5Sjxuh1tksjG/wzJCqWwGbAE8fTFqQpF7NroV+nbaDQ5j6CTfczyaJIpuaiSsujFKdg7+eYWl6swrwjLlNJmC+KJgCxl/WpfRtBhjn98cQlqun17dmJO/ErdIaAUS2+wpg9+gkn8GFKEDEKh+y/u2pfHMQepLDaFx9+sOHjiiHhFUVeroqmHI1DDnSZW230sCaIkzFE5q1ESUg0XvjUMKXxsWmx1SCuYGp5Ud6oA5ArnlV1qxTQP/X2HDJq9phCTZ5gEcJK7Qsbd7tov/zxgpdrxCGwhLO6BZJHRWTrTn6Tqx4evNLxrisItvSweQtyALbZYR/A6hQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If cma_activate_area() fails after allocating only part of the range
bitmaps, the cleanup path still has to release the reserved pages when
CMA_RESERVE_PAGES_ON_ERROR is clear.

That is still worth doing even in this __init path. A bitmap_zalloc()
failure does not necessarily mean the system cannot make further progress:
freeing the reserved CMA pages can return a substantial amount of memory
to the buddy allocator and may relieve the temporary memory shortage that
caused the allocation failure in the first place.

However, the cleanup path currently uses the bitmap-freeing bound for page
release as well. That is only correct for ranges whose bitmap allocation
already succeeded. The failed range and all later ranges still keep their
reserved pages, so a partial bitmap allocation failure can permanently
leak them.

Fix this by releasing reserved pages for all ranges. Use the saved
early_pfn[] value for ranges whose bitmap allocation already succeeded and
for the failed range, and use cmr->early_pfn for later ranges whose bitmap
allocation was never attempted.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v1->v2:
- fix the failed-range cleanup to avoid using cmr->early_pfn after
  bitmap_zalloc() failure, as pointed out by Sashiko
- explain why the cleanup should still release reserved CMA pages in this
  __init failure path
---
 mm/cma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index c7ca567f4c5c..a13ce4999b39 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -188,10 +188,13 @@ static void __init cma_activate_area(struct cma *cma)
 
 	/* Expose all pages to the buddy, they are useless for CMA. */
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
-		for (r = 0; r < allocrange; r++) {
+		for (r = 0; r < cma->nranges; r++) {
+			unsigned long start_pfn;
+
 			cmr = &cma->ranges[r];
+			start_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = early_pfn[r]; pfn < end_pfn; pfn++)
+			for (pfn = start_pfn; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.54.0


