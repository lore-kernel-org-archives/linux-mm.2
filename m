Received: from smtp.lore.kernel.org (ip-10-30-226-214.us-west-2.compute.internal [10.30.226.214])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69B5606A321
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=s7fpb4WO
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4876CCCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228506B028E; Mon, 19 Oct 2026 10:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9066B0290; Mon, 19 Oct 2026 10:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9BC6B0291; Mon, 19 Oct 2026 10:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5B936B028E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:50:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E78C12072D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:50:35 +0000 (UTC)
X-FDA: 85339662030.10.F24F416
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E7F7140006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:50:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s7fpb4WO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792421433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LovpYfxn/g97ME2UuZhbRE4X+t8nS3wo/zMXi49f1I8=;
	b=V/XqypwdFD6yivL3J4KrFs097335CWeCC9pFurR9w0H548/SkYenPnhpFowC9TfBuT3sRc
	jhCD+xAtzuNU9KCb8F4LvYHKrfeSOrkk7Gk63hWB0c6rgJ1DPUaAdY/DewakBWzQG8+WfJ
	W5fhdRW2nLnZ69DR3qOR7qxF2Fr42cU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s7fpb4WO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792421433;
	b=jaz7HGeHQ40xRoIgmsSn6ZImjRhcMnuRMaxeIc380/NTNj8dDWZh1UupuyRUh7qAeBoA7n
	luDBN5+pkS5PwBqSgMrNg9WF5vdZgAtdvWzn+MGsoeO+CAr+PRbPzEy/Tb7oKNoBtyL8Bf
	F78bd8MqLdTY7kany9OeVsa0ad4x3A4=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3584f70a5aaso255389eec.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792421432; x=1793026232; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LovpYfxn/g97ME2UuZhbRE4X+t8nS3wo/zMXi49f1I8=;
        b=s7fpb4WOqaCh993c33qv7pOU96FfpvziiVS8DEQs1AHaGpxgCctW1KNhHlbSWqrru1
         PgQM+1lyGq/gXQYs7BJdSjBBeJVVs4OYJQOk2wDugQZp0RyOeLhabCPNb0Vbmu9aN+oP
         mRwiTo1IFnnBiXFf0JWJNL6Cj74JDIkQNF4SrQVd1XYLUsPbnWJLc9pS7A1z3vXGKXPI
         VLEc6/RgDehe1y8gRhn5QLRj3paEYrypxGKXFyEfZJFZlpVrV+LKECCOFBPP5UD9CShr
         lOO24/sNDNDmGkF7new9w5K5Om7iV6Kj/15UOcjBoO239ImAkMpohCi6BAlRNtQCjDgM
         +bkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792421432; x=1793026232;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LovpYfxn/g97ME2UuZhbRE4X+t8nS3wo/zMXi49f1I8=;
        b=mNsdKSPwDkPU7kTZy1BiBj4uI1IpWti+WAip2wP6s2DKAElktC4t56CZdmBOT1pRp5
         K5WY5b4mfwZ6qeWIceEqd5DDXH/J2BXsm2M4dHyF87wnVlUZsPdhsUuAGf6NttdM8i4O
         I12vrfnFPdL5YoL2VXQefZ3qslhPJEI1OMhx8GExHwbAlOrwTks+kmhpe/cniNb5TJre
         wNrQ6IfaphUBUcu1HX72Pf+oEsy3vGVklmsWG1bP0NKRb/7PmbYPQVdqeoFpeG9B5TXd
         sYo3lDfQ5VxUx06Cr5pol2G4/ivu5lh+YVUxl4npK4urGmfCmNd8O5RrPJgmeusbG/PI
         7LKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwU9PVB7GkmgNRT6AEaekOyA3eOV4GEjVX3ypx624dN8B7msO4a0Zm4pmmu3TRk7c/levuChRBAeQ==@kvack.org
X-Gm-Message-State: AFq9FYJtezsXrz80tBfNBJ00lgZhUlgCdDrxYhXzy4YuC/SDlthaJnaW
	9sw0BDL12N1NV26cbiW2Byx+z6FFFWceFuk74qA5pd7G9JL9M6Rnoi++
X-Gm-Gg: AYBFou0+65E+Cvxww2S+/AUsPPvFTA05tcr/GrQFRQ8rOE3G37MRJGT7vvcRfkNVueg
	L2aoBDp27GrJTv0w1BJdxYgZOZbKvou4vusQ/6bnXa9jtKAsm6OyVj4ofYkgTJHPu6BP0WiRKlh
	rECT4rDHASy7J9pnqDPuiDwxeqR04xvcW22h0dFxiknLHfn7xMRwFwmS1mBuot4Oxnxg1IWNSD3
	EhwR1CzupsyNt+Jh9pJu9+cW3xC+CaHSWR6m3DsfR0earFrw7AkVPel+5rq2ukjGDsb8d6YJ4wM
	hfLHPsx05cHEvnlLJXARu6SRBCJmgxakoBkBCV6YDGa+Rorm413KEdSb1wVc1FYUX/a/hHC0CHe
	UsVPpU7zaP/m5i+5hREJeVhTkG13EoDa1dmpjtxd6h07FUW0zfTjDtLibeoFvW7XW39J+i2NQqR
	6K/Digl6Q9xd6jvvRA7tnnQyPKPNd+jWbOQCyb2lkaiBA9F14HS+jRkZfumVfOXrtCuvrwl+0n3
	gTOxnlsjNvgjqptzciaAutuGow0psDG4phT
X-Received: by 2002:a05:693c:20d2:10b0:35f:8c5d:5938 with SMTP id 5a478bee46e88-3619ffc5b52mr19048848eec.1.1792421431765;
        Mon, 19 Oct 2026 07:50:31 -0700 (PDT)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360813b684dsm32864621eec.10.2026.10.19.07.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 07:50:30 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: dev.jain@arm.com,
	zhangbo56@xiaomi.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhangbo0325@gmail.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [RFC PATCH v2 2/4] mm: compaction: target mTHP order for proactive compaction
Date: Mon, 19 Oct 2026 22:50:17 +0800
Message-ID: <20261019145017.3900448-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8e54025a-03da-4cba-bae8-1604463c7622@arm.com>
References: <8e54025a-03da-4cba-bae8-1604463c7622@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E7F7140006
X-Stat-Signature: 139tgbug6o5c818mug71ygkuaf1t5xyx
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,
	RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792421433-150018
X-HE-Meta: U2FsdGVkX1+zh/PhI7shTsYS8B/tRYFbZ6DU0Ih1aHFVJj76mY1yErZy/QqiddOc21E04SVnEhifGS+NTyKwAyRLZUS6APioJOj7NxeiYCZhliIMP9jL6BVIEJnk9hDJ2OZm8jpV01olBqF7Ypg9s9CScqXaSFRwSlX1VAwd+GCg92tYx5pkQQ/e3Cq5NC7Qnn7i+pnu+AgvDLrA5wKokQl70kO/MN1lWIdptRlqDSa7EMwEwpG9q7YnqWd9uFQSxgURKth5wEYDF2gnI3BUCUD9dcw9W02+MgBJj/LkG9NKjZdkShhLFC6+vvh8X0ap5+5fL9ssBS3+/ZftCtirYiKTd4CC/jB2nFfknTFhZxd/hgcFT4Nqv6O1XyUv+3vlHeCDtntCF0MvPCl/EM6RTX/8FecRwbGzEweedTA1iik9nylNPALchwMtmj9qzReIuKynDgLcfvfBACsd0MjYrjErKOax45P4jf6qrb5uo9kbGylK/rNDKFP/lWHh4W4j0SpebdVGombAvKIl8H6OF6NsljO38THzY0bDqMPEofp8IPWgeIVDlA7BOuy1Prqb1Po+UrjMZsKK+wGLhySqz7YVn9zSm/i38qSe/AHAzxAj2mZs2fRtt6cQki/2GGnHvzWfpnDQBYmHUCddKUDWpupssfI6bvkRCPFXQ0p6O5nr0g8tc/YwiRSlbimu1J46zd66IacGCgXnSdAnOeR//CgEtV9YzFPH+BcPiEk8KboOafSniMZlGw8ENil6lT92XrLCkRQ3v/qEFJ+Om3bbD5vjR7HF+UgJKSwmn/qsFWQwU1GzVft+GqlCMZI6yHM/dM1nv4k2/Z6p/CdzuPdo8PbTt+SWP322ZvSboaFFTJ4eaNYh1buLm5Ec4UIUsqZRhBZ0ZfIrCT/p6ytN38BkRKxghs5yu7C6+AgFK73G9varOtUA2BV3W4tnkhN4A64/wUsrU65eADxGKlZlMJw
 VHEOrHT7
 Jb5iH6bdZIvObFms6EM/0j3wTM7ImJT0pOR769VZpXJdcNouWmKxxq4NPvkFajbvbUQg5eEzUyfXBRB2YNp0Cu5dMEL3JPP88LkRyKO/KTISh+ZYiUB9DJp2pH1+Z/zVAu8pPYb+6laKBdMneEH5XdcsSWIj4qSNUBrTO9zL2BhYT5ddtgv4cBU9C4wTB3uFN3ruO0YCDICz07ZdD9PQBubIOtPVfbvsPlkP22dOkeGHiauEvDUF+g7VNQW5ox9cFJVdg9zf1pPLZ+XAyszrCzAR3Rs43/mNjG+AM/XKwVSyYx9IFUIubClsAUqzCs+cLfSTJZAUhakDif3sePx6NQcziVpcZuMmEoVxSBWtb4PVXSfOJno9XXEWmqL55ydAhhkBRqv8yOF/CBUOFmF51GDkDLHJmLEPZw5ISPea60vzmpR6C8XowcRvW/d96iK9Q5kOKLKLg0OyF39odBGCNM8I0Q/kvxHQESxObqDjQngDSZoSloqB/kOilpNfD4bCs5ge04pzysUjyYnJlqjOaqkoEgEVdb1dDQ0H5un2Dlfl6s1YBc1zfTaVGzVe0CtFZJCO4q8zoMZyjGdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Oct 19, 2026 at 01:42:55PM +0530, Dev Jain wrote:
>
>
>On 01/10/26 5:44 am, Bo Zhang wrote:
>> Proactive compaction triggers against COMPACTION_HPAGE_ORDER (order-9),
>> which is too heavyweight and misdirected for mTHP systems where the
>> pressure is on smaller orders like order-2.
>> 
>> Add compact_hpage_order() to return the highest always-enabled anonymous
>> mTHP order, and use it as the proactive compaction target in
>> should_proactive_compact_node(), __compact_finished() and kcompactd().
>> 
>> Fragmentation scores are not comparable across orders, a small order
>> scores much lower for the same state, so scale the proactive watermarks
>> down in proportion to the target order, otherwise order-2 would rarely
>> reach the order-9 threshold.
>> 
>> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
>> ---
>>  mm/compaction.c | 40 ++++++++++++++++++++++++++++++++--------
>>  1 file changed, 32 insertions(+), 8 deletions(-)
>> 
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index ecd3e6cf54fc..3928a5483efc 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/page_owner.h>
>>  #include <linux/psi.h>
>>  #include <linux/cpuset.h>
>> +#include <linux/huge_mm.h>
>>  #include "page_alloc.h"
>>  #include "internal.h"
>>  
>> @@ -81,6 +82,17 @@ static inline bool is_via_compact_memory(int order) { return false; }
>>  #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
>>  #endif
>>  
>> +static inline int compact_hpage_order(void)
>> +{
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +	unsigned long orders = READ_ONCE(huge_anon_orders_always);
>> +
>> +	if (orders)
>> +		return __fls(orders);
>> +#endif
>> +	return COMPACTION_HPAGE_ORDER;
>> +}
>> +
>>  static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
>>  {
>>  	post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
>> @@ -2257,24 +2269,36 @@ static unsigned int fragmentation_score_node(pg_data_t *pgdat, unsigned int orde
>>  	return score;
>>  }
>>  
>> -static unsigned int fragmentation_score_wmark(bool low)
>> +/*
>> + * Fragmentation scores are not comparable across orders: a lower order
>> + * scores much lower than a higher order for the same fragmentation state.
>> + * Scale the watermark proportionally to the target order so a small order
>> + * can still trigger proactive compaction; COMPACTION_HPAGE_ORDER keeps the
>> + * original threshold.
>> + */
>> +static unsigned int fragmentation_score_wmark(bool low, unsigned int order)
>>  {
>> -	unsigned int wmark_low, leeway;
>> +	unsigned int wmark_low, leeway, wmark;
>>  
>>  	wmark_low = 100U - sysctl_compaction_proactiveness;
>>  	leeway = min(10U, wmark_low / 2);
>> -	return low ? wmark_low : min(wmark_low + leeway, 100U);
>> +	wmark = low ? wmark_low : min(wmark_low + leeway, 100U);
>> +
>> +	if (order < COMPACTION_HPAGE_ORDER)
>> +		wmark = wmark * order / COMPACTION_HPAGE_ORDER;
>> +
>> +	return wmark;
>>  }
>
>I wonder if this function should be left alone?
>
>compaction_proactiveness, as I understand is given as a sysfs knob to
>ensure that the user can control how much power they want to invest into
>compacting. So suppose the value is 20, and the highest mTHP order is
>only 2.
>
>This gives wmark = 90 * 2 / 9 = 20. So, even if 80% of the memory can
>serve order-2 allocations, we will still perform compaction for order-2.
>This seems "extremely proactive" :)

My understanding is that compaction for lower orders is cheaper, so lower
thresholds could help reduce mTHP allocation fallbacks at an acceptable
cost. Is that the idea?

>
>>  
>>  static bool should_proactive_compact_node(pg_data_t *pgdat)
>>  {
>>  	int wmark_high;
>> -	unsigned int order = COMPACTION_HPAGE_ORDER;
>> +	unsigned int order = compact_hpage_order();
>>  
>>  	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
>>  		return false;
>>  
>> -	wmark_high = fragmentation_score_wmark(false);
>> +	wmark_high = fragmentation_score_wmark(false, order);
>>  	return fragmentation_score_node(pgdat, order) > wmark_high;
>>  }
>>  
>> @@ -2306,7 +2330,7 @@ static enum compact_result __compact_finished(struct compact_control *cc)
>>  
>>  	if (cc->proactive_compaction) {
>>  		int score, wmark_low;
>> -		unsigned int order = COMPACTION_HPAGE_ORDER;
>> +		unsigned int order = compact_hpage_order();
>>  		pg_data_t *pgdat;
>>  
>>  		pgdat = cc->zone->zone_pgdat;
>> @@ -2314,7 +2338,7 @@ static enum compact_result __compact_finished(struct compact_control *cc)
>>  			return COMPACT_PARTIAL_SKIPPED;
>>  
>>  		score = fragmentation_score_zone(cc->zone, order);
>> -		wmark_low = fragmentation_score_wmark(true);
>> +		wmark_low = fragmentation_score_wmark(true, order);
>>  
>>  		if (score > wmark_low)
>>  			ret = COMPACT_CONTINUE;
>> @@ -3239,7 +3263,7 @@ static int kcompactd(void *p)
>>  		timeout = default_timeout;
>>  		if (should_proactive_compact_node(pgdat)) {
>>  			unsigned int prev_score, score;
>> -			unsigned int order = COMPACTION_HPAGE_ORDER;
>> +			unsigned int order = compact_hpage_order();
>>  
>>  			prev_score = fragmentation_score_node(pgdat, order);
>>  			compact_node(pgdat, true);
>
>

