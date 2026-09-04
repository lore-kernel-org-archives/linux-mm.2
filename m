Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3650C624DB
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E6D6B008C; Thu,  3 Sep 2026 22:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE886B0092; Thu,  3 Sep 2026 22:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE5B6B0095; Thu,  3 Sep 2026 22:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 858CB6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:42:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB8AD140509
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:42:19 +0000 (UTC)
X-FDA: 85174530798.19.7641BB9
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0EAC180006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:42:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aj1LJK+E;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788489738;
	b=8fnKCAy/nO1XeY+PX4z5Q0S24uxZqJAdYNlZv6RJ3oylDEWgpnzqtxgRp++/86i5+J/hMd
	xuGP3+sK2Per+qHnfy5Haz4C6jW7PMhFgNPlyYRgv6wBEnGmeXvPzGVlwwf8CbdVuzAAM1
	xhgUmoLvcbcugyRdJhKMsY/E+jRV8fY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aj1LJK+E;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788489738;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jByX/hUOJR9metF+xa8zMsLgboYN/Yuc7pkgyEeawdI=;
	b=c8TxTwW+uu8G2Yj7nvDj3Zh41mAufxln4DcrPYHiN0OOlrlJiaaqkyAWtRjLG/tOYqPeIp
	/08mL5WY4yzBJ+QyWair15m0euR1RJg+USJMvF4kABvcun4TL6PKcuRKo7Vb1yAbNYNhVy
	kJJmCGbEnOblWIulsVy2yQCJ2Mua6EY=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49cdc81f40eso3334845e9.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 19:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788489737; x=1789094537; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jByX/hUOJR9metF+xa8zMsLgboYN/Yuc7pkgyEeawdI=;
        b=aj1LJK+EGKWAt6+cDvr+FU7OQscoam8yU4DT9/fQvyJ1SI43eK2BKWMl60zc1f1BlW
         FWGCjP74Zqx8pydL/Vz0iLOm1TI5YJZqCoanhOzlAcB7jS1dmRQR7tDoOrDjpPgNZvOS
         a+umo0viPR20rVoSfM1cvY3UmI0ilCLKW78KFhkAlyn0fSdMqoyefwiRc6HfWs0fEB9P
         f97ZCAgkhR43nEgw4QqIymvieZFX9sDvu2VSqTvoT3aUmThfSqcKihFfYy/07/01QGih
         C/vFdz0P7dEHOvJegNj8lvpj04m465nrrqIpSRNPaGVOLZRt2DZFwnsyqOv1gGUfHKJc
         bcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788489737; x=1789094537;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jByX/hUOJR9metF+xa8zMsLgboYN/Yuc7pkgyEeawdI=;
        b=aXzaZIKxUk5trO003acMqOIsoXpuUNB8aj0N96IMGEHtjSKMXN3+YPpDaq/4N3Oqi9
         NrEl2UzwtNDohfdIq7a/9ytzOotyHv2JbZgofCTeZE776C5fwAnaPum0btbvG6QNb+//
         fdelajgHnDanZ7pkbeb+7BLkitZCVJ8K5AuxBUJRONIBZr1o1ciXmLEs4nPse+Dk4Kr1
         r0oSnmJk2y0p0F6Wu8sakoDJ+hXM3wBBZbkkJptXo+O+WoEhuIbtmuaijxUNUxdZFsnL
         9dZo0QsBYTsvUWbbzqOMHZpm+uoj2kOfNBOBQMDFbUDiVTjE6gVHvFW+BbVbCYq3HrnV
         DgKA==
X-Forwarded-Encrypted: i=1; AKwUvBw/jQqokyUYnaFT4HQS65i+bQH2sunIhZxm7NoOHUfI+A/BOgu6Az2U1obP2kzYlIic3PXOBUIJ9w==@kvack.org
X-Gm-Message-State: AFuF++lTTDbs8J0mB9R7E4k3OkUfR1eKcsnfFLtbA7ajDhwuNcE3kuqc
	PF4kd3BIN0aolRwET/TN2zUqNYFGYpJ6Qc4lPNzfp1vFD9As0+xQDxev
X-Gm-Gg: AYBFou2Fx8htI/oUPyVSQdPEyy0buFCOKJkn8vUNPJ3LmJh+AXP0AQBUe/HqjNY6iUh
	IyaYqz6Zv48LcLK2by4ShQWQZKJsPRpy+rosr1l9Yts+Zunvih5qvh0K/lo1I+bayXZCEQN1hdJ
	rYza30Cg2PLQekM6BFCqQefNcs0el9XrjsYOdVeYdi9h1vt0ZKlKQC2rz0QlGSE6ffHlHTF/NKS
	eiYReOiJg6E/8qY6NCTJtwbeEPht6eqhVnOUfUENcd1EFz0sbo0OUl/x4E7d3kov+5FYiq244UT
	JlXxXn+79LhKmDCx1EQsFl5l3vdn8BgzGz+4H/lb4IJ/zqCrhTc3nP73ootMSGswhFooJFhm57b
	u+iJcY4PldhMBfw1e2LnJIGW8ZrvKNd9I4qNUQjq2pSQALSp7Ow9dsPOtXdW2bZ4nIrZ3AY5nbs
	DJI3HPZ5x/Tzs+MPw8IrCBApfuKGmmb5duYVgUSUQXfaWO7Do9H01XS2W2vAE=
X-Received: by 2002:a05:600c:4f4b:b0:499:83f1:398 with SMTP id 5b1f17b1804b1-49cf823f53emr34860435e9.9.1788489736619;
        Thu, 03 Sep 2026 19:42:16 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm118348575e9.0.2026.09.03.19.42.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Sep 2026 19:42:16 -0700 (PDT)
Date: Fri, 4 Sep 2026 02:42:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/2] mm/memory_hotplug: make shrink_zone_span() more
 robust
Message-ID: <20260904024215.2vg2j77kopwfv54e@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260901052950.3284540-1-yuan1.liu@intel.com>
 <20260901052950.3284540-2-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901052950.3284540-2-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0EAC180006
X-Stat-Signature: 5xahujy98xz7immwr5rub6wd9n6gbfgx
X-Rspam-User: 
X-HE-Tag: 1788489737-236020
X-HE-Meta: U2FsdGVkX1/0HstVNiiXYsSzq1xtoae+qFputlNP9HJHa3GVUSCTc3bayr2WCnHNpEH3D6H0v10VdDJEqDkG7AUCJpI28hD6dU5jGNyMJxRZ9g3LuKiWyKjtjc15esgd99oyYfyKeA2SOJs1TSUpoaK/7GeDK2zHYGIuKbRIUvWPcFnZ0BDfjPM2fs0Gbdrw+TJPUCH/Q4r0cGtqUM0HchaKaeBfctu5LL7xx2l7MuB+UV5NQyPWtdmWVCUjMZkZaSJSeRb/AqQgjODgiL9mxkNZZZ6K2Epfonjj7Q1ryVtw1LpRnPLfBFhJ/K0LP1W+UP9JL10USV41C42wMQ/h+ZuLR5ERtXBjaajj5p9aPLdpyZviDts00mTSknq31bNTU59hICa8K+VF6OWo+RuZhEOliknHtpGBayZwQWxZMSNhOPsb0MkH2MupX5tOe6DFX4cqi+AsurF/GapfA6YRXPoytmMPFMjqRBdcPvLiECXrw5z2vdk1nUwtvke8q+hZ8Prv6ZT2wh6eLKkpvLabTNKnIKD9y/xv0HgZC+t+4e6kD3n2uqK91wCCkfHjpJ16zTE9qnRkRm9hCG8F2qwgc6EjVCm7ru3WN45H6TCNzM7HMzJHdwksgJoVeGpWEoACAkoai0UUUi49Dz4NUFa4XlwxKLGGd0yAQFo6jY7rnj4eHKtZ40pPi66l6thQKJwBu+8MR64BdvouL2AQowPzqbg/cabx+ZlD/BLyIWNqSQLN312BDIROqBTsZ0CGdaUIK9LRu6KrWPAsdRNXZ+wQQp0aBIMTmwiKbdV1NVujzRnkB3+C502cLDsxByH+XAmnMs8Nwgu06PC+HHhT7ymMifAWijZgsldiozLzh7Xy+UmZyxfidaNr4/ruWE7SVpfkiK9VuvVN6flL9rOmibrWUDS7H7cGSSTklpBrl7OrDDnWe8/Diu8PLxE1G43pnt69340nf8BzzafRPByF6Wc
 9DourSst
 BMLgFMkjVglewOX1yjqw9t4q/yJXQ3o5WEyf3xluE9gahpcWEmV8SxntvO9sJ8IjRGiE1Fa30UgroBGQ/gikrFOkNwLueJzdgue7lb0cYjhRnFGuIDHN4IfYcHJfbpEbJbkwNK3nxw3clMxTkT09sonEJY++5hfmgQArtCXyb3PO89/5N2EkBTCZpWoaS5BvKzVFHQCpwi5bhGlu/C7txf30PfrX3F3pom42J74GvhNfmcNNO0hZrEmKorIjAhK2r/oDIzCwJ6fU+3j6oqGK4ZXyF4c/JEgMdkmFSVNtIdEG+BT0LusRwN9g0K6L5vK5qzE0yfDb+A6xsNP0iuGR2WSNizDzDc/797Fpo8kmDFhOVWAINzvUqfvPbkeaZIYz7fiCayydvo1Cxao/0wnx77kQZoHLcKRFIzxkdD0bW9B0jFnD7n5Dgfw408B9NJT4lgbmMLaLobqXhsLva/e9nnWQWDKN9tNQmivp6ptkgUY2XDs7mbvrhIkURkNzvdOl5UH7uYiyJrDgWEizp8l1AljmlZpK/s/J9Tq+vLvbdl/dvFRmC0ndCbMmAuin5yrhSWwkiGXaqJlMQGmhxHgNEhSZE81yEhspFn4AvmiCOUWeuab3CtUSxO4Ava+nBu5OIq948MWxQkB/A1ouh/O+wxz4zpal3ylG2s3rd60becNd7vL5EW29w31iPfawh1DGHjsI5cTO+XyOdAVkwpgdNWyYQd4WnBYEKE3f1g18gqq/LYEYb/xImIr3dYQnx5z4vUwRDh7PRDKrKgiRUoUHTWu7ieXWoicacbRk6Z1G7T+x4juM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 01:29:49AM -0400, Yuan Liu wrote:
>From: "David Hildenbrand (Arm)" <david@kernel.org>
>
>Let's make shrink_zone_span() more robust by checking in
>find_smallest_section_pfn() / find_biggest_section_pfn() that the
>start and end PFNs of the subsection are within the zone.

Either the start or end PFN is within the zone?

>
>While at it, clean up the function by factoring the core check out
>into subsection_overlaps_zone().
>
>There likely is no need to check the nid first. We require
>SPARSEMEM_VMEMMAP_ENABLE, where pfn_to_page() is cheap, and
>pfn_to_nid() on CONFIG_NUMA would call pfn_to_page() either way.
>So let's just drop that for now.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>Tested-by: Yuan Liu <yuan1.liu@intel.com>
>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>

Otherwise, LGTM.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>---
> mm/memory_hotplug.c | 59 ++++++++++++++++++---------------------------
> 1 file changed, 24 insertions(+), 35 deletions(-)
>
>diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>index 226ab9cb078a..9f19876ec3ec 100644
>--- a/mm/memory_hotplug.c
>+++ b/mm/memory_hotplug.c
>@@ -425,49 +425,39 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
> 	return err;
> }
> 
>-/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
>-static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
>-				     unsigned long start_pfn,
>-				     unsigned long end_pfn)
>+static bool subsection_overlaps_zone(unsigned long pfn, struct zone *zone)
> {
>-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>-		if (unlikely(!pfn_to_online_page(start_pfn)))
>-			continue;
>+	const unsigned long start_pfn = ALIGN_DOWN(pfn, PAGES_PER_SUBSECTION);
>+	const unsigned long end_pfn = start_pfn + PAGES_PER_SUBSECTION - 1;
> 
>-		if (unlikely(pfn_to_nid(start_pfn) != nid))
>-			continue;
>+	/* All pages in a subsection are either online or offline. */
>+	if (unlikely(!pfn_to_online_page(start_pfn)))
>+		return false;
> 
>-		if (zone != page_zone(pfn_to_page(start_pfn)))
>-			continue;
>+	/* Checking start+end is sufficient. */
>+	return zone == page_zone(pfn_to_page(start_pfn)) ||
>+	       zone == page_zone(pfn_to_page(end_pfn));
>+}
> 
>-		return start_pfn;
>+/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
>+static unsigned long find_smallest_section_pfn(struct zone *zone,
>+		unsigned long start_pfn, unsigned long end_pfn)
>+{
>+	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>+		if (subsection_overlaps_zone(start_pfn, zone))
>+			return start_pfn;
> 	}
>-
> 	return 0;
> }
> 
> /* find the biggest valid pfn in the range [start_pfn, end_pfn). */
>-static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
>-				    unsigned long start_pfn,
>-				    unsigned long end_pfn)
>+static unsigned long find_biggest_section_pfn(struct zone *zone,
>+		unsigned long start_pfn, unsigned long end_pfn)
> {
>-	unsigned long pfn;
>-
>-	/* pfn is the end pfn of a memory section. */
>-	pfn = end_pfn - 1;
>-	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
>-		if (unlikely(!pfn_to_online_page(pfn)))
>-			continue;
>-
>-		if (unlikely(pfn_to_nid(pfn) != nid))
>-			continue;
>-
>-		if (zone != page_zone(pfn_to_page(pfn)))
>-			continue;
>-
>-		return pfn;
>+	for (; end_pfn > start_pfn; end_pfn -= PAGES_PER_SUBSECTION) {
>+		if (subsection_overlaps_zone(end_pfn - 1, zone))
>+			return end_pfn - 1;
> 	}
>-
> 	return 0;
> }
> 
>@@ -475,7 +465,6 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> 			     unsigned long end_pfn)
> {
> 	unsigned long pfn;
>-	int nid = zone_to_nid(zone);
> 
> 	if (zone->zone_start_pfn == start_pfn) {
> 		/*
>@@ -484,7 +473,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> 		 * In this case, we find second smallest valid mem_section
> 		 * for shrinking zone.
> 		 */
>-		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
>+		pfn = find_smallest_section_pfn(zone, end_pfn,
> 						zone_end_pfn(zone));
> 		if (pfn) {
> 			zone->spanned_pages = zone_end_pfn(zone) - pfn;
>@@ -500,7 +489,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> 		 * In this case, we find second biggest valid mem_section for
> 		 * shrinking zone.
> 		 */
>-		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
>+		pfn = find_biggest_section_pfn(zone, zone->zone_start_pfn,
> 					       start_pfn);
> 		if (pfn)
> 			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
>-- 
>2.47.3

-- 
Wei Yang
Help you, Help me

