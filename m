Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1288CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8866B0092; Wed, 27 May 2026 16:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD116B0093; Wed, 27 May 2026 16:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3816B0096; Wed, 27 May 2026 16:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC356B0092
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14E0D916C2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:12 +0000 (UTC)
X-FDA: 84814387224.06.DB04A55
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 393D214000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="ePo/UWM4";
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TD5lidUUheRvEbRogBFjUkTmTjQ7nHIsLysSJlSHMzs=;
	b=CQiF3uZUsS4phB2+tZ75/l6TXgQGZoBry4Qp5tSmN7k1bxiqq6uruu7b+9giHIF1kmlBq8
	zFeywYrG+6wT3sCWXtRq/u50jY3ZWxGGcYzX9Fm2CqpzZZxIYs5H/TiTjggXuiEVO/ERHS
	9GDVhCQo3PKdEL8NwFx5IVUTItt7Mtc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="ePo/UWM4";
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914890; a=rsa-sha256;
	cv=none;
	b=aY072eMWkYXHS/biHlHjQFmHr28Eh6rMP8x9nRM55OVS3UZpP8wzjjoos1PqAaIP6ec0GN
	ddIkfJh7QXYQL/u2CbIbUSzg+QSKbt+PsKInEdNNOoaNr0sDApsHLQsZe8YR4VW2YaFjOX
	flbqAeq7GoTOrPY8v1VSXVdN1yQY8bE=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50faeb8317bso109728521cf.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914889; x=1780519689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TD5lidUUheRvEbRogBFjUkTmTjQ7nHIsLysSJlSHMzs=;
        b=ePo/UWM4UGyyTyGePtW0DddcwlhlSjS92WQpl3zFOnyncq2rB9sfFf6TslPN+dwukH
         J9rCqmg8uQJf6w9/E6Feo8lEO/JVEOrBE69vbqmlPi6sbzR9YkBYhn/YAfWeWBMCbNKA
         O8UeVFu7EhacdmiA1LwatXwt/my6fAc5R0prWkv3YYbppf2VT3Rj6Nt4KOS5bW29ZKnK
         CaiiA/UtHBrIBioFaP3B94k2G2HuyJEflYfvv/oflQPVmySjNbpvdL16efLnP9WNUXnC
         aMWbNNpDGaYuR3KE3TJ527YYG7qW/Covc69YbaVb+AI/jL2/XfIU55xDnzaSdOe9BvNH
         P3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914889; x=1780519689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TD5lidUUheRvEbRogBFjUkTmTjQ7nHIsLysSJlSHMzs=;
        b=SS1kXWZcZ6Pu0dQxaOnrXTROAFmjU11qBPOMzGaNueqizotQMBut3O2uj/N1oa9Ge0
         foE9KxrL2pNTP1XmcP15Wmksj0vCQzP47ou45qg9exyLfvghaIqxOnal4tMVtrzlTVbN
         He+UucEHMs9WGdZ0F4SeGtpGrQBCdqInW6pU4EEPfLv0OFxfO9MI4hbO8yxoWl7Z2qZW
         HSa7EqrTgY8E4kE6kw+FzeRFvQ/kxVV1TrET1XuLMPVOVKBVdkjYw9sB8rahFsbe/KHX
         /P1Mf8WN2wr4UR81dKAPpGBKiRwZBOPZcwN82XCw7sV9kHW0OuwHYq01g/T4Ih8JD9ow
         oVDQ==
X-Forwarded-Encrypted: i=1; AFNElJ9MjisVlr9nt+nsns8ochqpbYsRbwd+A6IkZ2srje0iW3mA7VVaCaEq/1jwdTs5HjPIQ4F0BLRiBQ==@kvack.org
X-Gm-Message-State: AOJu0YxTobiLAogPHQwH9WTF3dhApjFCqhzDpRXgVAwu8/eigImsTc5D
	Gts33beSvPln8pYbUGR4AEaMk7NQcJIj5X8RR6S7muEfjdNQx+db19SPpz3IuIxVKXA=
X-Gm-Gg: Acq92OGDLoUmSijiarIRlpM045vEaQc6sNgBZ/Pdqb5/SBiMI+GEvQDMFw2KQwCcoB8
	9vDFXkkehhovtlc9Grs0strNGEtbpujqi5+tJNXQvHdj8ApU86VeV8/NaZzUTqQSmBF+4oiTNMB
	6Kv8GQVrYWAPbTIUbzVixnKKLEDaCLTskgDO0FBidASDj0neAbPnfFFr6Ot/bD6BeuU1kL4Z0A2
	TY2lTf0pkvd0Whf5aIXv1KiLFg617uQDNYKyFiFKNmaYzwEdtlMFWOChIPLS114uMi2QdUgkAWX
	qDlyrGegrvIvDKicM73/kGsVdH01JxEmsAGDs3n3Q054oVlOIGLA/oA2D2MAGFGgDxCpPAK2WSt
	0+mxbUovktTruJsmLwYPcLaVo2SYpmiE/yxlCxq9lJ1zlWVckps9I/dPzrbd2CZ1JRdLL2jzBR0
	B8F8Xom5NCcx013WZmItsBx4ryJfL/X1Qk
X-Received: by 2002:a05:622a:2508:b0:516:ddc3:622e with SMTP id d75a77b69052e-516ddc36797mr330589551cf.33.1779914889279;
        Wed, 27 May 2026 13:48:09 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706adcb59sm52568411cf.17.2026.05.27.13.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:08 -0700 (PDT)
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
Subject: [PATCH v5 2/9] mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
Date: Wed, 27 May 2026 16:45:09 -0400
Message-ID: <20260527204757.2544958-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 393D214000F
X-Stat-Signature: fzsajk7o4okf5ewf14rt5dc6mfwdjui1
X-HE-Tag: 1779914890-591107
X-HE-Meta: U2FsdGVkX1/Sz4qy4HtkaO0OWDz87CSMC1NegVyJTt2jiOirSWm//FtzdQsDaVcHV16m7faGy+haESH8QrfcHRgL4MaL+meG59LBBxKVsmyE2R3ZncFotr11GeDc7Xs9OOdlpa35D6BptzyJNoYYRqSOaF0edREDP9JsrYdtHWZo0BOC02fYDxrpmRzXhv1u0hScZmminVfLc8bumOik2lUBG2X0RaRQACOpoyGpuDKreyriQnl90d/hUDnzfZmodynChEKJm/BZ5tQe8k/cLW7V1HUsHB6MZdgxKDb8HwSNARFTwGuq0Ly5a67ovGsepqKDwlu2qp5zA/d9EqFC8yOKxS6vK69DceJiaXroi3+iiiTKdz3pHOlTzl8Yadw3mVuRL4UkMN0QkMIQv5nXIq1wk78mOU8NwYaadQf7ISDiMHLNoRk7NHzDQIKaPrjWVohINRiqGDcxaJCujUeA9GXe9VQytgjtgiMsCshc+CNcjAfrr1UOicBXfCvzQn4G+E2UzKEY47jG4yfh4PO15fEHYbkd8H5rj3vIOhd0c7kPPytu68zoiHIfL/NL7eLNjxp5GxVqip5He/xJMZRgexarTKvQtbI5e/H9nXI1ONK+dCNHOYZy1FsHCODiYLCnwyJ88luP8z0dy4hYyJGWVlgEttDUVUEGkM+ZlaI7zbA5EBStaXL6gHY9JWPMH1NLQ3RmqjUZ9jES/mRsWp39kt7R4y9Vd0L1XSdVoc3zBCTo4zm7hHjRBU1Vvm8sLlzRaosVI/4CYLmWkdeMOGygaSQBC9XkkAvoJ9uqZT4sQ0x2r7niB26EIrd9+czA5GLXUtrBIggh9zaabeWA5Sm0PzZx4dXLJaYxI4b/YeqR0gniDQx9fnSwFPiZ2uQ6EVUrOXpKi1Y+Vn1OTk+jPmvQbgsTCFhvwxY5LXhx8wAmaIGQ6DZKEfdRfSEJ/UwgHFKoKEkmyQWfDNdkJv4q9k0
 wlqtnv53
 99MS9Gkl5dMTzdFYK7qjQt8YbHChoA3uNqrG5SXWc9BC9N3qbsn/8c+qCyOWIB5wGlra7MRWMPIoCXubSsZKGMe0pMYCUCcppd8Ql+P9UzaUC0cDT5Th3vtXDywYGoMRYZAjL9PE1G08W5QJuwHQC9WwTFxTGNaArCu6R0OI7D/d15uvmVcWwgHwziWeXO1MfZkaB9aDDJ+uJmE8NG3WhpBfoUGV6MhiRwT/DmFoWPzoV506cY1k9tvQ0gxkaMjP5eEVrZ+/L+tM2HjsQ5aox+SBBEbmq3OUE2NPlGbm7u+QUQ5meNQmOgEhH6kKB3eqiPQJ+Y2hKMedfMrfrVEqE5/oig7p7bsX5iDvemVZT2TITStG9NwF6UiZt3Hzi7tMK1XCOzkRr4krPJd67YSqF0L84mkjPRn3eBBKPCmrPEW2eOhcEhrug9pCBuO7Kq2/jVhdXxCD/eTY/McHSctCoNvyHRVOZvtEDnrzsMIeEQot5zNcLMa+ByW7VHsfdHfDUV28CvEYSWUcOfiEhcY68FPqdAKMtgHB71hw/Es2KPH01tZHpRyvUVVN0IbwMx/fET1EjRrjsNL/FZW3Bhj4C/6WHeuqZEH+lb0yxLXLWwe83hK4Mtv9Vl9fAo+6sQJdjMtLKcrwCwg6Kl28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

skip_empty is only for the shrinker to abort and skip a list that's
empty or whose cgroup is being deleted.

For list additions and deletions, the cgroup hierarchy is walked
upwards until a valid list_lru head is found, or it will fall back to
the node list. Acquiring the lock won't fail. Remove the NULL checks
in those callers.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 mm/list_lru.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 45d1b97737ea..77999ed78fa5 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -165,8 +165,6 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 	struct list_lru_one *l;
 
 	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
-	if (!l)
-		return false;
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		/*
@@ -208,9 +206,8 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+
 	l = lock_list_lru_of_memcg(lru, nid, &memcg, false, false);
-	if (!l)
-		return false;
 	if (!list_empty(item)) {
 		list_del_init(item);
 		l->nr_items--;
-- 
2.54.0


