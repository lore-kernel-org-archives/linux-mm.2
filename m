Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D93CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0427B6B0005; Tue, 19 May 2026 16:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DB06B0088; Tue, 19 May 2026 16:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6186B008A; Tue, 19 May 2026 16:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7CCA6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:28:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7824E1A0A16
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:28:32 +0000 (UTC)
X-FDA: 84785307264.18.F4310FB
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E3A91C000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:28:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BBBeyJSG;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779222510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSwhsPuJIqUQQohobkJMpwlzAsTqFWfrWTjdV97EMcY=;
	b=WoChPluu4cVQpZHJn+CF6GokgqaO05Muktph6rUN6c2DeEEU/Y8XZyjL6FHbWazZkOX0xj
	I+ris7cM3EJFeGGDQvipXuOMrtG6R/r84wgzoADPBVPzY6elXlWfXg4qgXoFua7teDXs63
	CmgSfgOQQjX8AAyedQzPWmfm3ozXQPk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BBBeyJSG;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779222510; a=rsa-sha256;
	cv=none;
	b=ax2OvzZOrTITNe/figgCMm13+KxOf+5jaLucwBhdcBjOeJiZ/UKwUqurZGUmmkdT6Y7hwT
	Bh6ngFUXVTdMfpOOCdzRmxjtKfHcBuEf+Pzt3+xvSPhMudM3/ElcPdsw4HG7tsvjx+QTms
	1HtiPqmbbnZ5pv4GeyaXte/STJmcV1g=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9102e90bcbeso457898685a.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 13:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779222509; x=1779827309; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lSwhsPuJIqUQQohobkJMpwlzAsTqFWfrWTjdV97EMcY=;
        b=BBBeyJSGIXcawlpFJDIpOmSLsAGk9nKvTJSohcwrR4KOJaHqCsyCkc3ILV4B/wqAsa
         cQdOPDPlI1HRCCy2vV7CNFKxgLl6iQPg4NHmWDVYudBgVU1FSjPoCegJb2XqiY6Ptpez
         Lx54Xo0lr6UmnrEFMTiZ1+L0shbzEAiMnMm4RuMCjcMRRGMcec19TZu8RRe04Eobg0BS
         BG/KEN/P0LytebzxES+5U9dPyLOORu7wMEAgpxGl11mIfmbOqicLzQNCLsXn93qIe9pg
         qJVjWHJA8rmsT87Zhib1j+pcyBoWEqW/hD6ETXAekNaHauTFGMq7xI1matsyxoNuYBiW
         fdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779222509; x=1779827309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSwhsPuJIqUQQohobkJMpwlzAsTqFWfrWTjdV97EMcY=;
        b=IXb66r9kHz7tamDqvqugzNft2sIn1WeaYJetwrut0/VsWNORrMu4Yb3lEexB+AvhsZ
         ZxB2EIR0bPs3QSNQx6Ga5UGSZMUmhuWAHiP8eql+eAxqVCslq9sZJMIJga+HmHoKIM6P
         RsbCauUHU9YC2sXWYMl0pRPo+zjgOOpL92qmoh2BpmwZKz/zkKD4CTa0zcEVWpqYgVU+
         mE3LFJQld9CUoZZyvPZz42kK5XANeAZF2Zuooq85UUXtOn+b6yEl1h7gs5Ey29Dx4WP5
         fX6p4Yy/l89jb4UA6ZUujOSSaY1A7GJJm07MXH9gs5cMxVOTdiWcUZLHJ9z2sSpNFo5+
         ADZA==
X-Forwarded-Encrypted: i=1; AFNElJ+4vttMV1rvxULg+cCBDj80vdDXV5HfH+VN/sV59Buc0jNDknA7Zqp8Z8xRBSeffi04zRLZOIWkAw==@kvack.org
X-Gm-Message-State: AOJu0YzT9PACDyld61xBQ9VM8KgPsz92t3EiW6YfzvLpIcgCjR/v8Ucw
	sKTJdU3X3fX4L76Dk9M0q43pnb9MCZWt1d0Wq1yFJZDZWXPZlfZ323EF9KVLwkCFp/s=
X-Gm-Gg: Acq92OGUcgT5IbT+JBlUhORa2kxS2bW1eqlrH5Hp2K93H72NOK1SsnAagbC3AiT5J9K
	M55i0MP1QZui3SZvoNnNH2Z1/4GgAcPph9DFXCj35VfCLDxjo50y69ebtKXFU1JdRSlOrkKJ1aZ
	EYlmqm9sujFAZc7H07X3mUt2hP8aThUp4HeH7QibSinzsUy++KA6wuQyX1MuW6tNH03bvOqzlok
	MjQCA9Bp4UdNAI5fRmyT2pg7oEEguW3IZ/UzqV+dZRUwzRTxmk/gIHYo3si9teT/Og2YJavQvQ8
	uBw3WU7pqf+Tg2FYEvDstwBvtJOa0XDw9sIkFTPELpPnk1wmLmBjvN5+M8bIh6AQj2j8dUjbHLI
	m0hFghBiD1EGvY+GfBTJ0S1I6JBIIy6pScuK049Xrtm0gE1cLm92QOTbVgXuKVw4YjVF0gam7Ln
	+3IbsjLHXvogwwFUZ2DTaVGQ==
X-Received: by 2002:a05:620a:7116:b0:911:6136:281d with SMTP id af79cd13be357-911cda50909mr3238889585a.23.1779222509012;
        Tue, 19 May 2026 13:28:29 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910baf2236fsm1951430885a.20.2026.05.19.13.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:28:28 -0700 (PDT)
Date: Tue, 19 May 2026 16:28:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	linux-mm@kvack.org, usama.arif@linux.dev, kirill@shutemov.name,
	willy@infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
Message-ID: <agzH5BCkTMaK19Tx@cmpxchg.org>
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519012532.272770-1-jp.kobryn@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E3A91C000B
X-Rspam-User: 
X-Stat-Signature: uc1g91tqwjiesioupg1f94mh3dksrmis
X-HE-Tag: 1779222510-263707
X-HE-Meta: U2FsdGVkX1/6zQ1EYGaSCTTNbRIyzWqnQI5MNOmTGywyR4/q6z8mm6h0nKOZXqn7lGHkWST99hrLMLSk2MIlyd5zXb1b1yGyaxwHOV19asemveD2LJiprAMPyT94WS4Ar1ERcfGrcl2CYfkkLl8bKvXsic0WlZRNUmtJG2gcwh3AdIxaunZeykqV5A3Cqso4PfFZHHhurV2A3uLqWWab7EQfaCkDT6GzUeI1N/pY2LJ6HYju9/vyxnTvOWjkqdXdAX5FvqQWDURx0VsS7uNg2UIQEBKVpbPdHMoi58aW4TuXlEaPu/u9W1dcyMA+Cu3iv0IXebcR31CJ1sdevacnmQ5KwfqRC/IvyhxkBRsm6U0ogYYTWYbLQyrWgDR1hL/ZdGaebNb1xsu/darwa+0CHl7mGnpIGYXymaBjTFX7mRrxRDDwyqt/uECokdk3dbceNhY4cIuS4xNe6Z7Zo1Pd4I1Ta0XB1zqJVZd5ZYlN1Rt+xwybadqaBUqOVCqByc6Y1ldKI0z3+xMF82SYoVBZhwqzAfqSTcPZedDCJvm22l+Wt2ZDS3qhdesh+trgZnfolPBYFJzAb6RAz1t/xRAORVtVgVHjqMdIqZd4Rhh6ceprzHmz5d8+0ioWPgBvt70aojA9vzkA/u2MRyG1bb1WltIqsD0GI1zAfCdFTZBWo+vpcHizv3/EYtMhuY6UPnYhhFjW3tJVdse5J83XSZQd8HKeipTRsBG7845OoXF+7ljU8OBC/aeY3QMVLaQbk4pOq937iqd4u0kTQoaxE/1ux0LDvstUFrSoF1wlLDrYnZ0F8W1I1Mgyc1mdPkcnlptI6D1mfD61hUzUrjlR525KYFIChPIJzjT6vvN6w4cIMcvKuhir9dTpS4qb/gm5qBfNC82iDicUohe5Q/I/A1+bKLlRr25T1AcWpYIt37llnB1nz0rQrrJurAKI0RcFdG3bUjyiXD8pRieqo9/h6AA
 8HBMLpCB
 NBPlxg7GQKNnNhEoFTOnE2DDWHsA/lQQ6hmvpotR3URE41eoWVVYiB1pKYcznVBMvgYBBXyxlhJw/s+Ou8X2vTxoDn0nA0Jt50aGq/i3sMsqxB7QCzGmug18F4MQAPmPBAaK0d6SJROhCThJtga3qRPU2rYmLEOLx7xYdYDmZpTFx0IJeXCYybZog4lDqgLkeIJ7k4JXFlAp1hU4uzPaMoplgPVcvTef3Q2Ltu3qk1XGyGvEMTrGmtnXhFRielUbBU2I2lQ/VAaMWwP4vmIxx+7TArD2su1VXGttbj0j7UjuVg7hQXS3zXLBvhPt5rjh6jH/vSEWpNkbR72/1A07fbxj5DI5FtzpWx12qeh2ybL0CIpRde/l+aTmChsUQjtAiznxHj8MYXYuP2iHYX8ogtsFYdtnDt9g8vzna
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 06:25:32PM -0700, JP Kobryn (Meta) wrote:
> We're seeing a pattern in production where 2MB THP order-9 allocations are
> failing due to fragmentation and triggering reclaim on systems with plenty
> of free memory. Over time, the success rate of these THP allocations do not
> increase at all.
> 
> Inspecting zone->vm_stat[NR_FREE_PAGES] via kprobe on compaction_suitable()
> indicated the given zone had sufficient free pages for order-9 allocations,
> yet they were going unused. Drilling down into the zone and inspecting
> /proc/pagetypeinfo revealed why. Order-9 blocks were accumulating in the
> zone's HighAtomic bucket (while zero were present in Movable). THP is
> unable to draw blocks from HighAtomic since that bucket is not in the
> fallback list.
> 
> The heuristic for reserving pageblocks in HighAtomic is that any atomic
> allocation greater than order-0 will result in the full pageblock being
> captured. This means that an order-1 atomic allocation will over-reserve by
> 256x, a full 512 pageblock.
> 
> Gate the reservation on order. Skip for allocations at or below
> PAGE_ALLOC_COSTLY_ORDER. This prevents smaller atomic allocations from
> reserving entire pageblocks, and significantly helps when THP is in use on
> a fragmented but otherwise healthy system.
> 
> Testing was performed using an A/B instagram workload receiving prod
> traffic. Each side had ~60 hosts with 64G memory. The patch resulted in
> several gains:
> 
> Unpatched
> HighAtomic pageblocks per host: 309-312 (1% of zone or 620MB),
>   ...all order-9 blocks in HighAtomic
> THP success rate: 1-6%
> Compaction success rate: 0-2%
> pgscan_kswapd (total across ~60 hosts, per minute): ~70.2M
> Atomic order-4+ allocations: 0
> 
> Patched
> HighAtomic pageblocks per host: 1
> THP success rate: 44-78%
> Compaction success rate: 24-47%
> pgscan_kswapd (total across ~60 hosts, per minute): ~29.9M
> Atomic order-4+ allocations: 0

This is an interesting patch. A couple of thoughts:

1. You disabled the highatomic reserve for this workload and it didn't
seem to matter. Presumably <costly orders don't need the protection.

2. Maxing out the reserves is odd. ALLOC_HIGHATOMIC allocations will
try reserved space first, and I'd expect things that are commonly
highatomic to be short-lived. Why don't we stop with a couple of
claimed highatomic blocks that get continuously recycled?

3. The impact on THP and compaction success rate is pretty
extreme. How can 1% of memory throw such a wrench into the gears?

Have you tried this with other workloads?

