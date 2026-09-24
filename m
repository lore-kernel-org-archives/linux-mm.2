Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0912BC98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 11:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127416B0088; Thu, 24 Sep 2026 07:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8726B008A; Thu, 24 Sep 2026 07:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2D56B008C; Thu, 24 Sep 2026 07:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B925E6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:45:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D50D16032A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:45:41 +0000 (UTC)
X-FDA: 85248476082.17.16191C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 654F2120008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:45:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdwNkU7f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790250339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ut9ev3kcVAVJgTSu6Nya3iZ8tPXCf/WJooMYCLWxpmc=;
	b=EqCHdGa5u7Hb+3ZPOoOdVkPuLeEOtJUR9MJBOBzobBfA2eWDyfa0R/RW06sAgNpUIeifHa
	ShfjEmcRFi1jegp6IThPNx5zMBcKxYfB0vsX7HXqPY5MK4sDfEUsVYF/bBPmtSpvFP260y
	UsZ5EIHtaLU53NQx8UI5tXQCpL5xK0Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdwNkU7f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790250339;
	b=CGX0i7vTqaCNRvIFUy2iaR1G2GU3HIG54cgx/4Kd6sbnFRzwYRkQFFQrcH6IUwMuRKXi5t
	pXrUkXjg8fuZvyGsQmbNrw52ObbYdTncKxaRhBAsgjFd68JAFnu4DauBWpbLi1+z9jlWop
	ZKqDuGakedK0Llj/UNDyu2i1xYjIq4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8784443308;
	Thu, 24 Sep 2026 11:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECCD1F000FF;
	Thu, 24 Sep 2026 11:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790250338;
	bh=Ut9ev3kcVAVJgTSu6Nya3iZ8tPXCf/WJooMYCLWxpmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KdwNkU7fC6p0Z59UnOOrZ+WsPDyul3+LLEPMes+3vg5gSqGpqOqfqPPBPE9YzyTuF
	 /018svbY8qU6R1mD4AnHJxcclHWaMtJy+gUt2A76XGdAFY6hkgoWizcuorVSRo9+1D
	 /4f17Se+WFFTeKj9FC98wFEHSscQW9SqAfxrjJwcHWugVTm8IYI/5YYq7AE/5cfWbv
	 4Z+jRp4DQgh6dFQ5zDVau5e4hmGygo8Iux/hs88ZDKQmRQcE5p44zFcRF7xQQPBg2e
	 GiDlK+bxXiK7eJKPt1Qd2iO8UhOqLlY4NyvKoJcKshBL/sdXRZeDiNgzj2O5K5VimK
	 hPCmiNk3Yawuw==
Message-ID: <8699eba1-21cd-420e-a992-51a90ba62b71@kernel.org>
Date: Thu, 24 Sep 2026 13:45:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] mm: support promotion-only NUMA hinting scans
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-2-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922182928.2199090-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 654F2120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: abhjzy7cj4jabga6t64a7cc5qkioyoa1
X-HE-Tag: 1790250339-586886
X-HE-Meta: U2FsdGVkX1+X6PnBODRc2xAwm8rvUmxXFBqgQYoveuXRHS8UlqxV+ZeN6yVFFkvejboXRHusYKSV8KLqdbfH3zRC5md40tHmEZ9Pbf6t78wMxezrAlg2o8LmLk5G4Z/+oYuXRJuZj0t0pBsBqvYa1kK/gIAdOdu6XJo6yEPnB0+dBeYeRMsXl2eJXd9baZIw8AJMWqurWtzm60p5wezxQjGVScZkTHCkKx2B56pKh15MZYuxDKOtQOfaYl1d+E60f2cT5wICPrbz9CRmeWxu8Q7FYh28VgwEXuf2TX7CeEOweLgIRI0VFIe3H+Nz8SQF6GROzkdCODA5BULsKmmCQEdmvBfem49AbIJNpdKhQb2vdDnCqkg9EXtHy9ZGKp4Xl9xaJq7lwfQW1tXPPb0MExXFbGMohKOTDSLs6v1vc1ponP3rGXxYt+3WvbcQitMPf+ix7oKgK+LXp2+EOow6zwGGZnYSbq16nMdGCNfL2dimJL1eT8x0juaCyu/lu5KQAOeX7yesS48RWCqCNoS5S6xLCGNo6D9E7y9g3mxFiE8NdFXhdo5URhuXo01J622x5W9da9pimCJZC2ctwN0/Wwtymn1a0YlLyRrK0k4Snj5T8JjUEyPsU3zJP4hS+uCE903No4w/0E0/k92Tl6dTxuyA8na3SPIgJNiPypaYi6IV1stK86IJecTFtExMKKIrV7kUcGCSZKWntLSCYoY5sUXFA/IpnDUUKTM/pbvMU+sFgC/KqBQiGLuKAU3cLLMFkrKY+tAKh3BiTDYMotHCgW9OArVV7c7S4q7cgauQp7zlm0HqGsj67pM+7xJTw/q/xTdoviStXidnUZHW3iFtRO5GR015gi2BHZlfahWE7YPkdWygDXvgzBV/A5ixgqiawqk1n0mXp77LNJ4UuhVNKhSeepeje1vx7kkPd24jXVwDW1lVCaMd6cLeAjFwl3tbAQjyrKUzpQU9oPPhAIH
 bHM/8nXQ
 JtW7fXXg7mAcTCbV3KUC5pOXOIfrUE4K7khf/paE3j26+7IV1SXDBJC5j5r9ckUL7BYD7t3K65HbfTJYbXMwk6gnCXFAin5r+3XXwM4GPHm6QB7kQRGjwNri/MJj6KICvsfCvZblMjxtAmSs7j35bynKYP91zE/gFa++CQZ+CQzOZINOcDHcs/ZlfkDE8EBVCy2InUamKJdzTzoWFKFr+mrhwsI713eGM1DAw85SKLBUhGT6z4XaDqjiBgwAeoIWQq1K8Adc5Pn8J9CcDEB/88fvfyDoiiylpoUHLPPmILhBGtmKYmq7cHPVAcLkP5uCcr741zAwbVtyk5LxU2pkDMJJpQw0romW5YrFCKnB9yZUmcJFJpYf8zzLAMwrRFlgfqTjTwCplqshs6wriRoJEkQyt6TEMC1jiQmUY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 20:29, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> folio_can_map_prot_numa() derives folio eligibility from the global
> balancing mode. The mode (normal, tiering, or combined) describes
> which balancing mechanisms are enabled (placement vs promotion).
> 
> The global setting itself cannot describe the intent of an individual
> protection walk because normal-mode tempers its scanning activity based
> on a number of heuristics (read-only VMAs, activeness of VMA, etc).
> 
> In tiering or combined mode, applying these normal-mode optimizations
> to an entire VMA is incorrect and breaks tiering.
> 
>  - Opting VMAs out of scanning because they became inactive obviously
>    breaks tiering - because the intent is to identify when a VMA
>    becomes active.  Applying it in tiering modes causes

Incomplete sentence.

> 
>  - Opting Read-only file VMAs out of scanning is just incorrect for
>    tiering modes because its intent is to prevent bouncing between
>    sockets (east-west), while tiering controls tier migration
>    (north-south).  The result is hot read-only files can overload
>    lower tier bandwidth.
> 
> Add MM_CP_PROT_NUMA_PROMO_ONLY and let task_numa_work() select the type
> of walk. Build the change-protection flags there and pass them unchanged
> through change_prot_numa() so its PTE/PMD paths use the same decision.
> 
> Have folio_can_map_prot_numa() derive the single-threaded private state at
> the point of use instead of adding another precomputed boolean to the
> protection-walk interface. This keeps the interface focused on scan intent
> and avoids plumbing VMA-derived state beside cp_flags.
> 
> The tradeoff for the cleaner interface is an atomic mm_users read for each
> folio, rather than once per PTE range. Check the promotion-only top-tier
> exclusion bit first as a mild optimization.
> 
> The scan-intent interface is required by the following memory-tiering
> fixes and must accompany them when backported.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/r/4d2853c9-edf4-4685-b186-7214ed6abd84@kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

