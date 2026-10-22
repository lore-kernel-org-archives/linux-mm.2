Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623CC606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oDkwapO1
Received: by kanga.kvack.org (Postfix)
	id 7F4666B0999; Thu, 22 Oct 2026 13:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4A56B099A; Thu, 22 Oct 2026 13:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692E96B099B; Thu, 22 Oct 2026 13:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A59D6B0999
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:25:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF1F1120201
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:25:50 +0000 (UTC)
X-FDA: 85350939660.17.3FAF0CA
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id F3EC540004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:25:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oDkwapO1;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792689949;
	b=UyDwbP7RUFhB8yYApfSkJAWISYafl8sOEXs87GYH5W1QBvOEpn6B1cB4CGjmzeY0lQVXs8
	BaD35QDUqxutfgAA9eWxbWcMYgJD12EerQFgClMzNf/o6E+Wvasyazl46Y49l2g3rbii+I
	/28B+OPakf9Cf37WvOhtj5QCgtrSug4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oDkwapO1;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792689949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kg0a1MLSOgMLwF809X6bOKhuG0mJlcOcCErhKY4WjvY=;
	b=qWI5PtP3/WqFDKqC6Fyr5fR+p9NfKC6q+3FVAAfGD+7Zm24QHJOf8wfoIwk63xHPAWePu2
	lTUpU3D7C6jDHovZhBtFnrs5nKwCXNef2Nl3UYG+uRcWdOb21Jff4KPXKNvQFgn/dnCqEo
	1QokzpPgE76NX08+xu5vuP1g2g7Kp4A=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b0db268bd8so630167b3.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792689948; x=1793294748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kg0a1MLSOgMLwF809X6bOKhuG0mJlcOcCErhKY4WjvY=;
        b=oDkwapO1aLg5/q8q3S7SuHWwXh8ZqTZ7dZcfKFlLNGeeFl6v81GjoKb41thWhR/qcI
         mSzOCDY8H1pqiHRQS5rciptnVO9vJR1HOL7fjrhoC0fTe03lInGw7BM+N1XrGrrbqI4X
         R/ppxZMBrD3PHP8s6E1PzK1Kr6dCv7jC9coXTbNSTjSVUrJN0yKB91P+JeTbbc3hfPGJ
         F45jFNthAYmFFe3R9t/1ziZ2goMOPJ/rPyxWXG1nZ1xofT00xy42jOwpOLo3j1nVlDnT
         Z0ZRYp1KIKU8o+1R4DsuHRgPQf2kF3n+1M69aEnCQJHXNIqG9BOjKt3wZ90YqP+Ydbmq
         TOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792689948; x=1793294748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kg0a1MLSOgMLwF809X6bOKhuG0mJlcOcCErhKY4WjvY=;
        b=iSgPpTW+1lOAAOxvFuioQY0WW9a9kUwI8ZpDG7gF4pI4OkZk3WCQbJbLfh4vP14O10
         WslrmaSvo7Dh5ASvdDdy7/jS57DBtEsg0BrHwP4I7ZX4M+xCHRbc/S8ZpRDQpmRcuCdn
         +bZBtofPHOP7GP7Evk7AplKcDKeO1s+LXMu2igIjAiR1ZXaEQaZZoSYF+QILipEtu3Oh
         u9vRByQbb+U8sauuLebRBQ23kFFxnJ3xO3STcNu1R/6VG49z/x49NkH/RlOAp0vNse02
         0AztQvS7nLDaFQLvUNNoC8LwZY+LUOo2ER10OXAHRM09mw5fMmNdmHxHSO9DatK/Lmf5
         0qbQ==
X-Forwarded-Encrypted: i=1; AKwUvBySsGO8vnOXYRqZ89qsLtgXcEyCxYZsSzF+k7LZtxeaBztjFi8DmjOzOCwayf9SLV+5DqZ5yAy4ww==@kvack.org
X-Gm-Message-State: AFq9FYJW3KsAHOGzzZWLMttKNO/V7w9QTcBoGS+4BAhy4CjMimjsEpSp
	vYYr8hKIAlbcU0sVm+ri4r8cNemMbPazOsrL60gp6LCe/i2epdvaKey/
X-Gm-Gg: AYBFou1gkFMCOmlgBHe7vsluZinJB6GHj5AGYeidiLKgRvjrEBxhI0aS2aCF/mwgJCA
	gORDUqNHmCdjbrPXIikww7+QGtDgBIy5U9QHQYtO0+uXViKFkfhwlGF46FdMF+dgLlSI6yzGfSf
	9tckJyeW+cnMBrBfPj7dOft7TZhjM5D8W3xPHVcB3Hij9BF+Sauu8Qp5HTAQXOslzbzcvILWvOT
	ynsLHb061bzaViNahn8mJOJNg6fa2p/kA3OQM7MkhU096l4Fqv/vfO9GvQGra3Kq+8pegNVLHMk
	0Qoj39rw0ECBnF9/hSJ+ZqVVv++cEl4FQggIbIVVRHitx/vNQLaQs2BcwU9JxNllr3/QT2c6NAV
	cV253IB5jwjQ1T0Y/Fjdjap7gVXvZ+DwAqG3s9lL7/abtWE4iKQDRfkBYWV+zOpaC16yh9Kf2F4
	NFe709B52hCye8/brpgY1xY5XalA6XXRtBMo1AV/rPmKOLu+Wov9pwJbLs1GwNnkGH+iR88njh5
	hhXit+ZwkRi6O7BOYe4QZP3CSyR7ANKnn/zvni0+mczZ7ZVbF0u6d6TF/DDgmqfzJ7KzBv9av7M
	YREOlJQZD5A=
X-Received: by 2002:a05:690c:c673:10b0:8a8:8dd2:f5b3 with SMTP id 00721157ae682-8b13403fd8fmr31788207b3.43.1792689948009;
        Thu, 22 Oct 2026 10:25:48 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:19::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1560cba07sm1495917b3.13.2026.10.22.10.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 10:25:47 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/migrate: wake kcompactd when huge folio migration fails in numa balancing
Date: Thu, 22 Oct 2026 10:25:46 -0700
Message-ID: <20261022172547.1181530-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4kxsripf13c91fkwbbmkgdah9kc7a4db
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F3EC540004
X-Rspam-User: 
X-HE-Tag: 1792689948-53709
X-HE-Meta: U2FsdGVkX19s0h6Qz+6rHeGhyR37DiM4lIkCqg+MJeRTg7n96b6xlGJ9fo78UpmlOJda2d6Ir/oC4zggTVR/YC0eyLmvUA1AFUIiAp8it4rdQpniy1ndR81vZGBTxjabKPDJcwZ1ft4IDWXH1kso5unzaCvkdso5HAiOnOm+doPCaZSyf8ZoRUc6Wm0/ITjguuIqbbOet6AvUW3EfPJS7Jd0jJOU3eMkzSQmuwrg44HIcvxe3Q7sPJdzjM5cdnDO7+fh2+yYcDYa7nB2yvk9p7mYFa1fINVzGPD2N9I4xY7NvGSusQIwJ5jdDccAZNsktf1RXpxAd1WcUZuL7FOQ8Ocuva9aX3DlvvoXA6oZERXnigjF7WM4UFTDegf3l/ARzjFg/MWsfrtF8rLC8YPaF3aEviPVAr1zZdkRwi4udGAxj3QzqUB7aOfovZzrGeQ2TyKuekTZ2OOA3molPqcSNnajaDPOWLsFQECxxuWSvBUnsas9YTf0x4QmQG+py4B7MFFMXXA71kLx4Bp8q6wR6liMiWK7/KKvFgPLJ2fXpdLdr30QaxnrKqW/pFkSuXLGuHSXpod8qIbmp0TL3Z234QR0R6QC5y2H27l9YucLv8bktRT9xt12yJENRUxFN64zQzl6RerLlpUJp6I4ecK4opjVcgXiEJj71F3T/P9PQAVk/LCJwFbDdKVH6ofn1UAlB7cCSdJXNAS2AfSzUHr5Tkx0xh3JW2xu3gGYc9Wb7JierhsSZQY8E69vIsVQOOojxYuHvA2VKvA9edDSVbqgjFE9n3kRPRc3UlKAB5ScMXADOcmWAvLV4qCpBGXkw2QnGrj1yknP6rvPysyj3sy5li3UWfxciiLhy5/pb1/Ai4Ey6/CVyPZtUn/+qM9Jy6nb36oZfbljFzAD1hB0hyyVR4XbkqT5p7oaCfD96Wj8eCm/MIVluxVKmG8sic1uFu5s7ab8DBX0qoX3RBL2mYv
 Jy8oc1KM
 pe8T89ZX8OHZ8N0CUC1ijSLYr0mKnqXD6KWBy97R+HLyGjmXQ6d1pAd70eif4xfEJIP2GEkn9/GODrciuEVPID8LpxzfqQL36yedSjoeN+8NIpej9wbaT4pHVdSDiUj9/m/5u5hmNzbFjQyag2rXNGTQLB41nw1IeCUH85tJYrN1m6YadFhEWD5YnE+nZs2cxPYMwoOsKPO8b00oOw+BuvMsHiuWJMo4DQWSauMF4sX5Zx8ex/ZnGnezf9ipXpYSvoZ+gMeZQ1i55pluZSEy2tVDFg0faKw1FOzoDJ1aZHlndMCRysw8xS7BmAI0dE9Brf8o6O6slkquq/R+yIDjQoUfR9sWj6wFkk4dN2/5xybh/2/KVLnX4lNJvBJy0p3D7Q2dgeh5hZfDCviF2BrCRBxMWdJxjfMs5qtbRnd8a+dMJ0+GQ1/0BEnszBG9fP9QYyIQJL7TVv7aNl9mTYQB1D2rXoZN5wiok36oeDZm4u8pIucr5pWKCQADSWoUlKkwOc0lW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NUMA balancing migrates a misplaced folio if migrate_balanced_pgdat()
finds enough headroom on the destination node. For large folios, it then
allocates a folio from the destination with GFP_TRANSHUGE_LIGHT, which
wakes up neither kswapd nor kcompactd. This means a hot large folio
trying to promote to a fragmented destination may never succeed in
promotion even after repeated retries.

Wake kcompactd on the target node when the destination allocation fails
for a large folio. Don't wake kswapd, since this path can only be
reached if there is enough free memory to service the allocation, but it
is too fragmented to serve the large folio allocation.

This patch has been A/B tested on tiered Meta systems (DRAM + CXL)
running identical cacheing workloads. Without this patch, we accumulate
around 4.5k failed THP migrations over the span of a day, while the host
with this patch accumulates only about 80.

Those migration differences leads to about 25% reduced CXL bandwidth
usage after applying this patch.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/migrate.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f8..67364fe0851c0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2671,6 +2671,7 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 	int nid = (int) data;
 	int order = folio_order(src);
 	gfp_t gfp = __GFP_THISNODE;
+	struct folio *dst;
 
 	if (order > 0)
 		gfp |= GFP_TRANSHUGE_LIGHT;
@@ -2679,7 +2680,17 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 			__GFP_NOWARN;
 		gfp &= ~__GFP_RECLAIM;
 	}
-	return __folio_alloc_node(gfp, order, nid);
+
+	dst = __folio_alloc_node(gfp, order, nid);
+
+	/*
+	 * A node with enough free memory might still be too fragmented to serve
+	 * a large folio. Wake kcompactd to help the next huge folio migration.
+	 */
+	if (!dst && order > 0)
+		wakeup_kcompactd(NODE_DATA(nid), order, gfp_zone(gfp));
+
+	return dst;
 }
 
 /*
-- 
2.53.0-Meta


