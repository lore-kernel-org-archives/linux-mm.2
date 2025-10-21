Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B07E0CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 18:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE46C8E0009; Tue, 21 Oct 2025 14:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94568E0002; Tue, 21 Oct 2025 14:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82F08E0009; Tue, 21 Oct 2025 14:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94C2E8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:04:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50ECB8897E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:04:46 +0000 (UTC)
X-FDA: 84022896972.09.3719731
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6EC7014000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:04:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WgNuXMF4;
	spf=pass (imf09.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761069884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4iCI3a+n92vgiAmJChfOmOa2AiYR85oxFU1VLd511A=;
	b=uHCPDqR01gAr/XjE2QYNRgz1Vf5bV7thnjc51XQFnWtJ4N5sVYVCzk23PKbSao809GMgo1
	I7J3VkwCYTNdLX71Oi7JUpC+ydAsrIuVPkwge9l0VoXFlOEpjxPxM4/nKVEKFBRaDrsTvo
	eBtVv6w9X56YkD15BUAaDqlPSmYUJ3o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WgNuXMF4;
	spf=pass (imf09.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761069884; a=rsa-sha256;
	cv=none;
	b=OeUtk9WdbrCIny/MrkDrYXQ1PTFgGEP26jAxZvKTGgC5xCtIwtZqfIFM+D2TNsswT5iBg5
	1eUd4rjrL4s0eNHExXeZ+UdpNGeHc1y6xoJhL+i0c2RKnpJCFCgqkCOqwf/arV+ncjBT42
	MnDuIj7hluo7S9uaq2+vhdc+vgHi4Gc=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-78f3bfe3f69so5207789b3a.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761069883; x=1761674683; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4iCI3a+n92vgiAmJChfOmOa2AiYR85oxFU1VLd511A=;
        b=WgNuXMF4yXnQNtMO2GIrh+RissJs+HTw/XBZCv36/PpcWve8g2xwsf3CE+lBmrJ05h
         HROzUrR7XHAt6Z09wyaQDs3rYo5jDk+fAYQ//R9KFqiWF27MaL4QeJKDUCCsiFXJ7v3T
         /g/6Re9u2nAlxzZmA+PzY+hvdo0V36wgFl6Njp7tRcbha9ftYjOzSEHVyc6WmkEHO7ki
         7HLscxBM9FzlQhtLb+RbtR6OkLqDVe2gjrvQdSyDJr6r7SB98lAKicvC1CuInGXszcBV
         D6KvuySo/HAc3iq5+eVIVt9ROXuFEOmQZ/RdWlj7WyEid7anyMIoda2CquYCB/BWfV2N
         QKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761069883; x=1761674683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v4iCI3a+n92vgiAmJChfOmOa2AiYR85oxFU1VLd511A=;
        b=ESogWSvYdekJCs88vrC7XhY6elrfAScTapAYPq3ACd8sb2LWWhtNjLWvPKTsrKLC2A
         HmdqwhbbK1S7i6/dmOfY5L1OMA41UUZ77OFEKUAX+eQM9hJ6xMeVEHbGZQDzIPhQDBAm
         F66oe2O1/Y+MVJ5KJzcI3NBWs2IUMxwDwuo+DtdRsW7lzbsdGxxut0L8SPCVJDG6LJd+
         fBe29Hm2l2acthYVCYoGbCRurJp04wRd8BeEyHnwRLEXJ9FjCfkl3RsgWxmrH3O1mHgW
         T6xJ5DEKx/QM9+GX+tI8EEC+9lDiPFq9xuGbSt4ULfGr3sbR8UZeZsFH9agOdYYHnRew
         KiBA==
X-Forwarded-Encrypted: i=1; AJvYcCVJZuN79xsSZMMBIoadfqNGmYwY0kn0RRnaEEIvbou4U7iItlXBI5ptpxsCUigku11JOAbtJJCyPQ==@kvack.org
X-Gm-Message-State: AOJu0YwSGB6zI48rB/JheS1EQMnqcyL2lY1KwdQkQj05ITtGVPGycgmQ
	H1swaUdOJbArnaMSHt0JCdpDFrZQlQ0qmwOUANPU4ZMlN1q9F3/K9h09
X-Gm-Gg: ASbGncvPa1dCRD5BKzu/zSXezda6SGct8OTNcqvoD9SMD0wXFjJUED6UOkovy4tk8Jn
	jxhJLefRh5pYw3orfoszzf7B6PJ4dF4mEBW33eb4xCsdae5LX0vDbJxtwiJHhTZo2V9Ko7mGFMg
	OmBKuhgvnosZJhvTOiAOlNTLF6GOHTOenZtZnb67HigqnkoGFXVmW1Ja4HrbVhT2UApYXr0yodL
	l1KjCTtd84URD+SWts8jAqStf9gk2at5iMiWVyzvORbXgZ0T0rlCnSkSNJA9d+m7PJehoEsd7qK
	thHuAyoHEEWCFmi0KD2TLKeqRpBWVeaM7bYRDt8ZO4NX1Knf1alI0Ml7muIswB/mMrLrH6jXzJK
	e/kaxpQwWmij+jrdOZf/fxwIMhmmyVJ4K8hY4eXXrDqDQkh4Qexq3xUPYt6En5bMyiXlgqx61vA
	Lyk28=
X-Google-Smtp-Source: AGHT+IFfvvRkT1o2E+LzW6g4zp1WME2u+yySBZYFy4r0G2UY/dg1eygrIwDL+LUnDjEL11Se4Le+KQ==
X-Received: by 2002:a05:6a20:42a3:b0:32a:91c6:e085 with SMTP id adf61e73a8af0-334a8504812mr20539937637.11.1761069882926;
        Tue, 21 Oct 2025 11:04:42 -0700 (PDT)
Received: from daniel.. ([221.218.137.209])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff34e72sm12016944b3a.24.2025.10.21.11.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 11:04:42 -0700 (PDT)
From: jinji zhong <jinji.z.zhong@gmail.com>
To: joshua.hahnjy@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@redhat.com,
	feng.han@honor.com,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liulu.liu@honor.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@suse.cz,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	zhongjinji@honor.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: Consider PCP pages as part of
Date: Tue, 21 Oct 2025 18:04:35 +0000
Message-ID: <20251021180435.11789-1-jinji.z.zhong@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251021145427.3580609-1-joshua.hahnjy@gmail.com>
References: <20251021145427.3580609-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6EC7014000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wdhwbwu9p86fopzkccp8yp7wu5bqey43
X-HE-Tag: 1761069884-581140
X-HE-Meta: U2FsdGVkX1+n1YQZFL9Va+vChGIX4ZXFe3hlmTd+PxAUuj88N+uu63kMM0yV+KVqWqJ840dEB9f3TV5kddilCjefn9LWvUWarbRb5wxLYulzbbZEIzmEvfhU+PalKRdcVSweTh1Oc+pHNnTPo8lMP1djSvMmX2QObUX+lCDseD0/6EpVtrZwkjopo5Zp2kw5f+pCECdqSk/IekPSAKU8n62D2CAmdB4F0sulDKawhoYLl3N4tciiwSOBPJCkRAdHj2Kr6T5iCSBDa1AQRCVDFMY9eaQJOpP30DFC8Bte3lYKmgjJAQW+gfAOis1kCBH2GugNdINU82jb7gqeLmsjrdMfTaYeGaV/oyP/kHvNUf+nkcCmIe+PtsnCLAyjJVd6bnwEkGOShjjrw1opechNXs8dUHmTk/+sPxTnVKfp8YJrC56vJP5T+jaXk7HQfx5WmKs3LxsZdLd/PG+lQYPUji1w+jl7vMLJMzYnUbib7h1oQUnB0/l8VOKrXUbmp0NHRnPa7c1XKyWANaFg17XLg+kf/kWIp+Cet1GfpQxNBjYAT3khAyI5pPWdYDpz8TcNsf2vJbuj+vlLVPwfacfRce9+RP1VozX3QS6QQiGosWN96iLjiFBeR6RAA4gV0+eQRZqR6FHdhPAdgY4dR+WJU0KzsT6He6Ew3hQ0YrFQow4Kk0cmEskGDWg2XTXyVJNqZnRT90yeZRWNEn89STjD5RFp1L/mzM3Vd2uu7ULxMjqY2txPOfYzQnlBNqCQu2M9GR875LYjGcxytsZlLx5yZwl67Gn4cE4C4FRZ8TF2UHw02+WJmGjVlW98g8g7fz4opb/yFELmDvD1paP3D5O2CJVrx7NPEG9YoXW4tGV3AgnsdeIZAYi4+1vGW0x2ud9Vk3IIkdtw3+g73ZYLTztXtyx754OjW3J+LPpBLKq6pYSjV36wgfVFZuvNd+pOfX3g1IhhU5k6TcBXphNBTdh
 +3Rl7ijB
 WEwQvZ+7YF4MPq+titlBmkKCHqYc0wg4ZDFuOhYRWqsRSF1EUT8ouuKZHAvCiaalg2xygkgV+xsY+JCFyh5vRFvZU8PfdXW1Wp33LWTOYoh/70wAcJ37v7oAbevV62jy6l+z/T0JUCuE8XcBX6UZeNpABTMqLBtHr4MJhDQ/KnMtu6dOZ2LT/Ik7KoA+gw+lyVSfXeZvMNf4Zu9e3SsWH6Yjtq83w3cKTyZ7q0KZjHO/teI9AmLBtBlrPRE964sgjVjnNRlj190fWo3HBpQKFMIUA4NGeDR8c/waNiH6iap645QOE06R4n/DxmfS+OLE2A7vPmvSf+jhQsD6h94gUs2TFfZ30FK7gmc6SfJfns+GM4b2lIbBvOmNdMJMqVqdyr9XqjkWJrN8BNF0cpasS6Nw2gUt+V2y3+4Fsu+hX999IyDDhALPEx2hNOwRhSaJh50gVvfq/y7jIxFPp0eOzDokWo32Vw8qLKxhaqO1c7UkDEdAuRPtlqtygGaraOGgSuNTEaWVP8ntQah9BYmv+pnzhdd6/fx+grbd7ZJoiLC8JMWx3xcp/L00TtyVxqlm1jPEkwUpCbSXmxGIV5qxygYjzUTOs/8/2IEjy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Zhongjinji, thank you for your patch!
>
>> When free_pages becomes critically low, the kernel prevents other tasks
>> from entering the slow path to ensure that reclaiming tasks can
>> successfully allocate memory.
>> 
>> This blocking is important to avoid memory contention with reclaiming
>> tasks. However, in some cases it is unnecessary because the PCP list may
>> already contain sufficient pages, as freed pages are first placed there
>> and are not immediately visible to the buddy system.
>
>Based on my limiting understanding of pcp free pages, I had a concern here
>on whether this would really provide the desired effect. That is, the pages
>in the pcp are not available to the buddy allocator unless we drain the pcp
>lists (and this operation is not free), I was unsure if there was a clear
>benefit to allowing the system to go unblocked.

The purpose of this patch is to account for the memory in the pcp list
within memalloc_reserve, which would allow more tasks to enter the slow
path. For critical tasks, entering the slow path represents a better
alternative than being throttled until kswapd wakes up.

>If we are already at the point where we need the pcp pages to have enough
>free pages to go over the watermark, perhaps it makes sense to just block
>tasks for now, and enter direct reclaim? Allowing more allocations might
>lead the system to be in a worse state than before, and will have to
>go through direct reclaim anyways.
>
>Please let me know if this makes sense!
> 
>> By accounting PCP pages as part of pfmemalloc_reserve, we can reduce
>> unnecessary blocking and improve system responsiveness under low-memory
>> conditions.
>> 
>> Signed-off-by: zhongjinji <zhongjinji@honor.com>
>
>[...snip...]
>
>> +int zone_pcp_pages_count(struct zone *zone)
>> +{
>> +	struct per_cpu_pages *pcp;
>> +	int total_pcp_pages = 0;
>> +	int cpu;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
>> +		total_pcp_pages += pcp->count;
>
>Could this be racy? What is stopping the pcp count from decreasing while we
>are iterating over each online cpu, over each managed zone? Under the
>memory pressure conditions that this patch is aiming to fix, I think that
>there is a good chance the numer we get here will be very outdated by the time
>we try to take action based on it, and we may require the system to be
>further stalled since we don't take action to reclaim memory.

Thank you, Joshua. Indeed, the pcp->count might be outdated by the time. 
And kswapd will fail to allocate memory if the pages in the pcp lists are
on other CPUs. While drain_all_pages() may be triggered by direct reclaim
on other CPUs, some hard-to-predict scenarios might still exist.

Perhaps performing drain_all_pages() before actually calling
throttle_direct_reclaim() would be better.

Like the following code.

@@ -6535,6 +6535,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
 static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 					nodemask_t *nodemask)
 {
+	bool drained = false;
 	struct zoneref *z;
 	struct zone *zone;
 	pg_data_t *pgdat = NULL;
@@ -6570,6 +6571,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 	 * for remote pfmemalloc reserves and processes on different nodes
 	 * should make reasonable progress.
 	 */
+retry:
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
 		if (zone_idx(zone) > ZONE_NORMAL)
@@ -6586,6 +6588,12 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 	if (!pgdat)
 		goto out;
 
+	if (!drained) {
+		drained = true;
+		drain_all_pages(NULL);
+		goto retry;
+	}
+
 	/* Account for the throttling */
 	count_vm_event(PGSCAN_DIRECT_THROTTLE);

>[...snip...]
>
>Please feel free to let me know if I am missing something obvious. Again,
>I am not very familiar with the pcp code, so there is a good chance that
>you are seeing something that I am not : -)
>
>Thank you for the patch, I hope you have a great day!
>Joshua
>

