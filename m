Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19B7410F995A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 16:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2DB6B0088; Wed,  8 Apr 2026 12:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C106B0089; Wed,  8 Apr 2026 12:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD106B008A; Wed,  8 Apr 2026 12:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B851A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:42:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E53641A01CD
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:42:21 +0000 (UTC)
X-FDA: 84635956482.22.C1E3A3C
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 948ED20005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:42:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=L545g3X8;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775666539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIK4dvbBCacea2XmbH1X9fhSsvJ+R6maIp66zH6uBkM=;
	b=SzQsUE6XScEAFALMCdkWocMvVoG12d0/iAzwBKAJJ6R9K/QTXNnOUZV2/5ZB4oSCrHcdoV
	a/vjRhrZ6zLAQGvM+DC2ATb76/x1yALR4ik2ZtZo8gV+iOmNKJD0sQr0WOfKcAU+4knJr2
	lEghFrhgrzMLB/Z+Ca4ew3SJOeKwLUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775666539; a=rsa-sha256;
	cv=none;
	b=0+13mo0a7VWpmZh4JS50X2E8d42BEgvbz3pd6IVGJ4+8nh3H/QbM5HJPgWqcZWdGshaRlY
	4lWjkLKxxdOd9DXIaf1DnOZW0HFg3+6EzQPgiBbiG2EwIBLYWAIzRygVja8CMyCPPwSSUV
	jESmCe/sA0gZrei5fC9+0O4TQCKjw3Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=L545g3X8;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43ccda008cdso33791f8f.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 09:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775666538; x=1776271338; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QIK4dvbBCacea2XmbH1X9fhSsvJ+R6maIp66zH6uBkM=;
        b=L545g3X8OYh2qsTB2tInlCyyNZ68xZJXTRXXxGTMKw7ImH4okMZ1zXVcEw13jvz0cf
         uaaQnEuI26kHsGEpwSJYoswLO62PPMUMZ9U7NHsnrAYtg+SxKemdY3O8gRvag0lWok13
         zLrqNXXMP5eOok7ixLiL1vkIdt22mWnJ72nFfNKW8g2ibCQeeIHr7XI7hbhwc6EMhemC
         HklRdUxJASQNZK7Aade31Rnu4aW5kcwf3JLqrLVntc9QOEEyILHm/MY7Csx0/3EAUpIo
         vw3+G3X3usGvctNKhs3ZtKfq+gMKUTyM9VM/DrSZ52oLIgfLSuYpiBU85C1/Sz3L5BKq
         8J6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775666538; x=1776271338;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QIK4dvbBCacea2XmbH1X9fhSsvJ+R6maIp66zH6uBkM=;
        b=p9hFcC0+prFWcb9TmAyyatptPRDGhwYGkmQW1Vh2ZHrQ+4bKGcjThCQ9dmzaCy8A8+
         rElxy2y3ZKViFEYQ7neTRBMSPXCMzNJoH1Jeg3D/bBxe41dyl5JYPzF8qUw6BM2y6Bim
         FTpP0LtA1LSsmuiGdoOj6EBvcpW4fpb+aVKm6P1wLXwzuvlA67t0UcFoi07cY1U8rDxP
         ivEuj33w0ZPHCBcE/d7m6XK3xh8TJlQ3xDEKqaNb8O9oT5kKCwYsbAwjwxj4w0xlN1Y/
         vJAMR0WqOIBv8Ey5v9bck0YtH636iZgbuVC360YxvAf36eAK3ApiLZwS3/xqC5iPP6Xc
         UfnA==
X-Forwarded-Encrypted: i=1; AJvYcCWdawcTUolOgc53SmAiC9ZyJ10vXDOxOn4bMfHv20SzpWHksR5MyXv2KHR8cSxV7WtzLPo+IpuLxw==@kvack.org
X-Gm-Message-State: AOJu0YyBiVClN9nCDqqmf68lQXDm4aP2ol5IDnxj4y2FfeNwwj1xAoEf
	2NdAk4qbKa+eHXXi93obZyyfO4IKYdy3EH4LGgq56fYNjTwl/yTJ1UJzauEVNgSlqAM=
X-Gm-Gg: AeBDieszMPXjQhWlicoGi8mHDulN4gUQY2tEnn4YQWdfAD9K6yFy0trvYqORN5c8iYU
	NdnIJO+urQqloDtmjAMQLHQw3BhzGB8rnFDoC/dao5S5GXQ5N0S0gOo6qVPfnPJBDvEnpp5qjwS
	TFV8Czwq0/4oDpKvIRCsjq+2a2Q6t8VvDPPL8EMVScQSHRwXvIbc2V2F19DplhSOE7N9q1uU3H6
	HF/q/JRIs/Dg4uR+PMnF1++Ql6xh+xwwNkQm/gW3+GuRnuHTLWS2RuzSpxQVKAsA2Vv0FKbe2SB
	/MOz/m++gCpn319cVc4rAysQjbtP1vPFAm2ByNnGPH7bOWg4FcnF2uwVePIEgoJBG6dQ/2Mpi90
	gu0Li3pg5GZtSzwYY9J6h43YfA0HR17vQ7SAm3T1PbwYYmYZchrUXCiv6WoLfw49io2VKG4Qk2J
	I6xNczYwm9GqlP0wSYCg6eH5OcfkpVZf4wz3TX
X-Received: by 2002:a05:6000:471e:b0:43b:940a:3457 with SMTP id ffacd0b85a97d-43d595e0467mr218166f8f.28.1775666537708;
        Wed, 08 Apr 2026 09:42:17 -0700 (PDT)
Received: from localhost (109-81-88-253.rct.o2.cz. [109.81.88.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d214f2b63sm54258674f8f.28.2026.04.08.09.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 09:42:17 -0700 (PDT)
Date: Wed, 8 Apr 2026 18:42:16 +0200
From: Michal Hocko <mhocko@suse.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RESEND PATCH v2 0/8] mm: use spinlock guards for zone lock
Message-ID: <adaFaMGbndSSMaZn@tiehlicka>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
X-Rspamd-Queue-Id: 948ED20005
X-Stat-Signature: 7oa33chzm4swkspq79mc8ewgitdo1woz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775666539-734728
X-HE-Meta: U2FsdGVkX1+Zz1LPB4I/2U8FuXjwuY0YXoxpq/1PSsP/qGOr7kyTAsoi+/NEFWS2oVtyUQZKdNgzR4l0wh/GvE5D6/dtCC67zRjrVf27ZiA1iv5dduj773LARfAzIRPPbLEUxG7p2QKGCGEYwRRPM7DARXccAtHQNS4GzG6eOgXKL/YD1GunPXSQPax27+sLllI7S0ea/cVTb4pnwCYVgVmiuoED4dIEytn9nciM5PdPxpK4WFT2xsdOQBwvYCatqbZbRli3r2/6sDugnJRBW7QmyYiehaDsvvX/owHgQx0GPYlYrlYmIc1Tk+4BV4Znr2X8SJ+xhr+w0x1Z6r4RJ7rMFfWu0bftEVUp+3Y0+VsBK8fTR4SoJyPh7MyH4t5unnwMl2egyOuyBlXtFo1kGVIqv1/jMaISpD7wzfQQSuDHrDndy/N9xByg/qv3DlNGSJa8r83v9ApQojWv8u+UQqpKNtO1Zxjx6t/GVdqdQuFUyTWoyueLSOhsyw4M6YkJpNlMePmYcR0u148EdpbCil4mWC3VEYC/dqa2HNf8Rk5rUL4+lACvw/RTJ+rOj69mYEVCooGPEB1fhdWZkvwz1PUtvbN0mX/p3nxu+gXxgk2inD8WRE0GW2COfgzyWgcSS8FkxWU6uLrDpO7Mg+gov2dKAOzOEutbhKuTBZyMI5EeSn/hoi3NDF+BTFyrZjh9NCyQIB6kYzPm7s+0ZmRWQuoTa5G6CD1Wq7BQMfyHQbv5XbSSmgd354mjgYjmUdF+SvKb2RzCbQn2tXOaMUBzzVS+4Uzv2KrBDhiAsz0sDmDbvrwHRHYMqUzdAnA/blS7cMelKcP1qFFN3YSABSky3BSsCw+NaCEPAATLBOw7xfi6ilCcJB9P7e9aJy7Th38nxIX4frY59+pXJ4qQXW304SYYe1apx21ot0s3rOLqa86+Vc47C2tRDDBDk07Qx8auiZRUdMz31bD0oFzzeJA
 DMexJ00N
 PeA0efCdIOS3HLiqlOrOIkAs9WEJpttOdcvpQZJfzJy/T3RXbIueFWSSYtKkpqKHA/nRcdo667OSwXPU/REpPNTA0GMDBr2yQUMAwf7cLNonzeZgCCWtxhrknGOLTBIsP/T81uSOvMZ7napOKRYtCqP6brEYfGCj44Hzio/aDEqyP8UUMrmPqJoZ2G5SkrcuhmyMlgT5LTWVL4Vdx+iMKSdW9BFDhi8LyIS7z9H1IEcjrA+cDFRyh5ADSyAh8OCcAkjZg2h4r6NVLoLCLgXKr+e9bwzRJmwuFd5apVt4V2UW/O+DHdMnwCNjb+y0UPAi/D3zcPR9pFuLnwF5DzGujI9zsSjQl8C9nvw0w4kSOFjG0qg3uwrT0vUQSFuT8cHtfnQw2Pwj9rgoM5ZmglHz0ySF5LhDsSe02nVtGlAf47TP5o65YLAdaePyiYJlwu8/dqEiHUk+hALYS32FKfttTJGj9kULqYLTxoV9JjYqS2kVOO5IiayEauRUcAZPpnAEqcvS+Q11Scgo9PeuOxGgROZIs4dMjQ86BRQachvUeNj0DfttY609YvwpM/LG8L5ysYvGu/HbGNCVGPjCeKAxTKkDP0+TZH5q5+aUiwzChLez1XOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 08-04-26 13:33:15, Dmitry Ilvokhin wrote:
> Resending v2 to get feedback from folks who work with this code, as
> Andrew suggested.
> 
> This series uses spinlock guard for zone lock across several mm
> functions to replace explicit lock/unlock patterns with automatic
> scope-based cleanup.
> 
> This simplifies the control flow by removing 'flags' variables, goto
> labels, and redundant unlock calls.
> 
> Patches are ordered by decreasing value. The first six patches simplify
> the control flow by removing gotos, multiple unlock paths, or 'ret'
> variables. The last two are simpler lock/unlock pair conversions that
> only remove 'flags' and can be dropped if considered unnecessary churn.
> 
> Based on mm-stable.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> 
> v1 -> v2:
> 
> - Andrew Morton raised concerns about binary size increase in v1.
>   Peter Zijlstra has since fixed the underlying issue in the guards
>   infrastructure in tip [1]. Note: the fix is not yet in mm-stable, so
>   it needs to be applied first to reproduce these results. With that
>   fix, bloat-o-meter on x86 defconfig shows a net decrease of 49 bytes
>   (-0.12%) for page_alloc.o.
> - Rebased on mm-stable, since the patch this series depended on was
>   dropped from mm-new.
> - Converted guard(zone_lock_irqsave)(zone) to
>   guard(spinlock_irqsave)(&zone->lock).
> - Dropped redundant braces in unreserve_highatomic_pageblock()
>   (Steven Rostedt)
> 
> v2: https://lore.kernel.org/all/cover.1774627568.git.d@ilvokhin.com/
> v1: https://lore.kernel.org/all/cover.1772811429.git.d@ilvokhin.com/
> 
> [1]: https://lore.kernel.org/all/20260309164516.GE606826@noisy.programming.kicks-ass.net/
> 
> Dmitry Ilvokhin (8):
>   mm: use zone lock guard in reserve_highatomic_pageblock()
>   mm: use zone lock guard in unset_migratetype_isolate()
>   mm: use zone lock guard in unreserve_highatomic_pageblock()
>   mm: use zone lock guard in set_migratetype_isolate()
>   mm: use zone lock guard in take_page_off_buddy()
>   mm: use zone lock guard in put_page_back_buddy()
>   mm: use zone lock guard in free_pcppages_bulk()
>   mm: use zone lock guard in __offline_isolated_pages()
> 
>  mm/page_alloc.c     | 53 ++++++++++++-----------------------
>  mm/page_isolation.c | 67 +++++++++++++++++++--------------------------
>  2 files changed, 45 insertions(+), 75 deletions(-)

I like the resulting code. For the whole series.
Acked-by: Michal Hocko <mhocko@suse.com>

-- 
Michal Hocko
SUSE Labs

