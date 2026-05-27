Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD58CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13F76B009E; Wed, 27 May 2026 16:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC55F6B009F; Wed, 27 May 2026 16:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3FAD6B00A0; Wed, 27 May 2026 16:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C76CE6B009E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AF3E1C1E5E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:23 +0000 (UTC)
X-FDA: 84814387686.20.D5E8997
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8864180007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=d7z3ws5r;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4EOQagJ0AFWLKeiqsu95H2CZJTRs9F1Y/QS2dFLRqc=;
	b=uXgTMBYsgzCkafSYcxlvZW659O5LsaUuRVfPZMPfQwXIt8/G50n2T6Px1HrkJ38/LQfTDm
	Tz0wc52wiZ0YhD3iAzJbZU9jIEQxj1xW04Fwkg908jYZouGLPEZEnN50XJGBbtDMDJBqoK
	UaSlBq4eNwO1+iG0gVuVQYouJQvsYzM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=d7z3ws5r;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914901; a=rsa-sha256;
	cv=none;
	b=a5+Q8kBSicwESDEQdGgfzhocO8ETp7P3RczuEPpzSYuUyJO/KgCX/wm9ngTdh5qFsdLT1e
	UVDwRwkF3JRMZANzN3QIZAKFYHmTbgHa92dm+y1OFEH1U4dnbQtmwwsI8KUgWw/f7ntj+W
	hyOekYjizrSod9nevfL2fIdsOY0zE/Y=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-914c1ced558so278988985a.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914901; x=1780519701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4EOQagJ0AFWLKeiqsu95H2CZJTRs9F1Y/QS2dFLRqc=;
        b=d7z3ws5r6GT4YaZHEyHyvq7hf4viymQGh8iRB6DlxMZ85wMokCWKpLwX1uj2js5HoV
         CgRteMFFHin37Qi4QxHkqRaZ/wqAu5OU2fJswOWXa9lorNiMA//iZAEzh/MIP0QmDXjw
         FAfyzpwGOysqG9l49r8olLG263ucbDqlVcUXNkff75EZ1QOTWUg2RscIfe+SQpFNh2OJ
         3LYwrIBvIUxIHKJewA79nToKOtAhxZuqDD8IbScaq5B09mGxgHyZ7Gjaxw60tFz7aukA
         DSSyjjAnhSZPow13ei2i7G9AB3zRoPukbd3mh/iMbzvvcSzUeIqX85sE0pg6ToirkK2s
         DwFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914901; x=1780519701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B4EOQagJ0AFWLKeiqsu95H2CZJTRs9F1Y/QS2dFLRqc=;
        b=hIyxPdAmxRZWIFqlnT97IRQ1muARh/T6I3RuBxkxMRI7512jbMNb7wa4Ib5YNq1ieL
         ju2Ae1v0QhFtsCeHzx4xOXELhkhPEUMoE8G02ZWeiKUVUvIw0RLbm0dIcsyt52ywD+N2
         YpYj2XSoVAVen8basigUUQeJ1J0pfNaJQBGempJWUubPlt+evtVxD3IEwkk7kypXW4Xg
         HLeNYlhFtdRbvQIbbpaqTle1Ds7rfEbUvhSXlJMaNlIXYb8VeD7BDISUH75SW43c+Y68
         UFZT3HRFRlNSHAyLXeTqIy+Lq7ZPByY/iMM1f2qgyKqIS+7F5fKkJpQqbDJGM2TNzYs6
         F67A==
X-Forwarded-Encrypted: i=1; AFNElJ+EJm7BVi+/fO5HrJrnQ9vGvyLtMHL70xzNyABr6cm5jfKLA+8LY0uoVSgtBT6MptEI2auUnBcpTg==@kvack.org
X-Gm-Message-State: AOJu0YxyuX7u0hUbXQWH8YE6ngyOSzZtfayj/nLEcqK5w8abgsDECPuK
	M1ld3EUtYrlttT+zRe7/IrmrCJLX4vYDJjpVRD7kfaiHhHR0kS+CwVp5UhI/iHwjffE=
X-Gm-Gg: Acq92OGFaR0blwyt6evTpb0kiPBYZDmPE8VQkjJ9gUGEB5z0LGCWg2yaEi5jFX84F5f
	5e2Ig4qVCHm6e0kjnbVKVeweZ/b2HGIP2bnVfk4PBvP1Guw8WEcE8f6r9XsIeBCzQyS9Y0a/SGy
	dqgiHUxyq0ZBUppluHpHfoPzXWNPBJTVr7qnF/SW32YV1mWE+JsVFzVVjnfStJ5HMUJmeCT2xKY
	U9JK0lfJJ6XZ28DpRs3Hj5Bt4YaXxWt0zk+y6XUWqnJ86rwJ2fEh5w9A0tkqpHbcojQC2on+XQ5
	9y7g0GhO0wlBhKLoExEyxGubUdvBEu1RwYXdz6xAwnlbrncP0XLLmoVZZBIeVjfz5ziFfc38YM2
	Lh65hpVcKOaokoxyYzov4vscfJyHK91iXV5uosXXI5axbuBGyYZDNC7EKYxozLuRmqmqUWQlm/E
	4m4oTvPfitS3KpKyEOh7eSgY7jiKmuw27E
X-Received: by 2002:a05:620a:4408:b0:902:eacc:bf88 with SMTP id af79cd13be357-914b4a19480mr3620622585a.62.1779914900580;
        Wed, 27 May 2026 13:48:20 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f8810a50sm601500585a.41.2026.05.27.13.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:19 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 8/9] mm: memory: flatten alloc_anon_folio() retry loop
Date: Wed, 27 May 2026 16:45:15 -0400
Message-ID: <20260527204757.2544958-9-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 89f5yxoq8s347of11q7qd1nbqdxokbu9
X-Rspamd-Queue-Id: 8864180007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779914901-771968
X-HE-Meta: U2FsdGVkX1/Zm3UdkghEmCfq2GvjhZdPH4v6PVCW0l/8A8EQwBHbmpWl/Aa+U5QLee5cWCmsZNfAAioaV+7I2uI+U1xegTxi2AQMM/d88xwUQS6pR9G3/M4yx+rjcc7190y70gMqBDO8cRlOv0lWmUisZpa4+F1XvKWPpKXYQzPWX3Kpa0uIOVkiyrYUWnPCf1uTk0dA1xf2nU2cg8SFSshK5cicvYnSAS7L0fD+UzstAKMkdPLw9qGGgwpJBVMLPRL77eNiN0bwSm08KaBBvnqTtVvc45m6hwAyvfcY40EHaxMa/MZvk7UvL0qCrMdcQmkh72amUwmhiPf2rKAcGJpLXx8hHGdTk8dh1Ih68jRNJXAuA4uLwZhVAHXxjwJ3ls+9yhPt0A8ETolyxKH/FnVtmN5weeKLPGLOxPbx6r+UWoemzN6kRs47xQfrMXAhJySvE1wTOWp1kWd4vukMQ0rxDIhmXFLUWCMkUFQ1+RLadhnSqrffgLxeO2JGpqXdDYagxwqr5oG9yd2yP5opF7WdSBcwlUW24U4k/879UND6EHtRl+uFdKZUL2wJS4+ECF6EcQTKIXY2GFy2+gZ6xJxKLhfRMUH3bErxvKdt8habOPQUPuuHkQEeFA4CC5PXf8boHy7UAMwfi4Qi4u9YDYkyvo1N7fswm3I1+R4UdUM51733UvTr5zVSeMK+1/s2zFwJ+VeESTWHOqUIzDBsSHbjWzCGpK1BWpVCybCwE1BdNy5Q9YtfZBbgiVNoWqlBcg9ZZS9bllTJ9ZQkYLjg742aEQjv1yNB8J1E81kIoYDnSGRnx/lw+Fv0yvMpCdESX/4Wssu34j7xnxkJ6YoBfzD3eXbGuSeIh8cMfc7gsC80CehiYSdICVAe4yzHGUchCZHBCI3SBZHYjZ0/EM+7DdygyX3qz0eak28piAHoYica5h1+A2qyQ62VnOvR5sFobHoHC3Pgd8TrcKvhgLy
 r+MFY/V/
 4+R6H4EtVC6I37wL+GE0zCkkz0VCFZaehiC6XTPiiPjiqv+aCqxMAN0gC4bEO6CBZHK8Xow9UiZRoDLy91c4bG1P0rPCXz9qQwZfSdWDHuzv5h5kPl9BnUzHlWHg1NwcGqIoecKQ7IUvuo7G5hUcFHGNLAOaiZvVu/XaR7WtU90+HQjWAbw7y8AHa4DD1OA5e5Kgu2/kMU44gx9ACFLru7kZXdsGF/00ko/hYQt/9XFAB5xHAug6wI11IuDHEDmi1XWOc7flb9qGwx7+D7TAm2djY5kdVIICvAvn3A3RDOFIvb+mL5ABnuRcFFbyQvBvArtowNWMPpJlDnecRds/XxzKuZcTBzWozIxLItOYmzpB+QaTprlIlHETmeMkPBeCXImB4ecyQaEwHVsK7rzy+Uw/NfCo4fUzwiSnM6j5RWf/VDBOioEjTTW9b/F9yPn9wbttqnPen0E+wa3I3Y7LfENWkZVIyH7IKoTe7z2P2KY9tVaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_anon_folio() uses a top-level if (folio) that buries the success
path four levels deep. This makes for awkward long lines and wrapping.
The next patch will add more code here, so flatten this now to keep
things clean and simple.

The next label is already there, use it for !folio.

No functional change intended.

Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memory.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7c020995eafc..135f5c0f57bd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5215,24 +5215,24 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	while (orders) {
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
 		folio = vma_alloc_folio(gfp, order, vma, addr);
-		if (folio) {
-			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
-				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-				folio_put(folio);
-				goto next;
-			}
-			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
-				folio_zero_user(folio, vmf->address);
-			return folio;
+		if (!folio)
+			goto next;
+		if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
+			count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+			folio_put(folio);
+			goto next;
 		}
+		folio_throttle_swaprate(folio, gfp);
+		/*
+		 * When a folio is not zeroed during allocation
+		 * (__GFP_ZERO not used) or user folios require special
+		 * handling, folio_zero_user() is used to make sure
+		 * that the page corresponding to the faulting address
+		 * will be hot in the cache after zeroing.
+		 */
+		if (user_alloc_needs_zeroing())
+			folio_zero_user(folio, vmf->address);
+		return folio;
 next:
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
 		order = next_order(&orders, order);
-- 
2.54.0


