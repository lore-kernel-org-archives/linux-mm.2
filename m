Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274C5CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9426B0005; Tue, 26 May 2026 02:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E736B0088; Tue, 26 May 2026 02:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F756B008A; Tue, 26 May 2026 02:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67A836B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:12:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F5241402AD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:12:54 +0000 (UTC)
X-FDA: 84808552668.19.3B86D42
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf29.hostedemail.com (Postfix) with ESMTP id C87AE120002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:12:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779775972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NRbexkdS8YdvFxYW6tMdXRRj2dJpdrDMnK1pfsdHrwA=;
	b=5CdqWbvZBydsMbfbtuLHaxiuzXp5eIolmR7m4t84/gb/q4fIxNtuLHAJiA6mMEnHv2tef8
	hpDFlJxVCxWJvRCFNmSEdYYtrkPcImWAmmFyAB0dmAMJgn68OpzoVN04hJu9NXkv7+P1kS
	MJ7pLFMrF/GgROhN7yEt+En01DZ09eM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779775972; a=rsa-sha256;
	cv=none;
	b=mn+We2LztivVM/b44whg7cDcT4HzLw1iGz4nIK+Kt+SqtAfH8Li5ERO3IdCGBmrWqnehMY
	0avVAK+yuY7EMvYr8NrAZ+7H18Sg0/vwflvs+PuNVsgzfdsqIKecv2qYPBHdiWQStOD8r/
	WKDWbdai80t4EcDB7PHRWsfyXN2ZbEQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 26 May 2026 15:12:48 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 26 May 2026 15:12:48 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahU54MtOVajvVYjT@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-2-youngjun.park@lge.com>
 <ahTD24kOr9WoluRT@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahTD24kOr9WoluRT@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C87AE120002
X-Stat-Signature: i1h8pid3tkcc7cpjjzaz14z9pqhh6yf4
X-HE-Tag: 1779775971-361549
X-HE-Meta: U2FsdGVkX18xC8FRZTpZ2X/2Q6k0rAxQmyyVos2Yw+dwDbbnH8zfVwVD4JihD0N8NhwiRL09vUTaGNpH0+OBPRjCGRQDCR6FjHgSNSSVS8/J2oP5FoF3VzCx9UjLSSopTcnVIkviGs9iyNfowwBGxnRL8lYcbV+wHPCZ/6NtNgvFHcy9zqs9Ugz08UdCOJipny+V61/dE4aDZJgXqDenQbaQlmU1JIkgu7rvKgVwl4siiA9it6aRo4GYCK89tzSZ2tu1gIeQv8NZwrGnCiWJ1e95DcwA1b72e7eV7ZIzTZP3b7QndM+ORauU7mps2+90NokSyjdrTaCd35DgXFuLqu4vdS32exici2ADv8tGwBX0ulAgd7gSSrCcQknjnOKWoh3AnEF2rDSUNMtkdvfRv0Z0D8eKwWfcYM1ZztbHkevg8iRseDQV3bH0mhN4dcQUyjy+rfaDbHoVPQu+Z3yQLjodMegAG50ydmJrVda64KDlPyGnUG7+hPEKh+IV6vLX9/ZEZ2aShyns1nfI3sAx4+hKsm1nwxysLlti01wvBzrH72HAKqtXJbPJr1mFbsmRkSUoQc4x6o0MGdGEd10FM6xR6Jq6mW0JZoM/rxoN0DhYP4fO0KwwxdARIlhfO2GJHdEGB+Aexmm4DiGR/vk5V6tQ6FwwC5BJ7pL4OygLYWTZjNPlYotvWhr5TQTh1zUyG0a7YgFvppintEbZfqc6Yohvsq62XUxobOX2/8BjtTyJb7YBDQnuHr3Lfnqo/C2KpjsN7j3IdWPdbJJkVJn0JHPvKzaE6fvJ6sS+TYyg/Zb3R1Aj50FV7LcaLmXXz2GcTBvX9DjDcKae3dPDXGoogvlOSxfO/q+QI0db01uYiqe7zJvkMghuKPctmFKxsw3RpevKUhMjG3YNEcLxMN4frRIJ78hanD/7CoQLhCc5Hd5nPl0XCsn/e928r6/vUGUwB5ADrKEVBBToa9T3TAq
 qq7MASQV
 3TGoXbxXupGQ0bc6Jm2wvf57zOLA3wfvpxLo1A67zF4abzSJYtQAdu4M6agEOUClSwoquUIn9puw1DypgfoVSGHBFQafAGgUzu09QoI/bRtmJlZhaKAZc9x4zTzkZdsRl7Oedwu21i5p5GLR8RXRHkjyLKZsb79PWJ8ZHcRECXU3AOwyg0fFEoi9Kt6HfUmWqpsxbgcxufdltMe9AF5xMhWUjX7677P9PT5WVBn/UYpHbTd7OmqCHvLXM+iXLcIkCDYSY8vdu2r9tZrw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 05:49:15AM +0800, Baoquan He wrote:
> On 04/21/26 at 02:53pm, Youngjun Park wrote:
> > This patch introduces the "Swap tier" concept, which serves as an
> > abstraction layer for managing swap devices based on their performance
> > characteristics (e.g., NVMe, HDD, Network swap).
> > 
> > Swap tiers are user-named groups representing priority ranges.
> > Tier names must consist of alphanumeric characters and underscores.
> > These tiers collectively cover the entire priority space from -1
> > (`DEF_SWAP_PRIO`) to `SHRT_MAX`.
> > 
> > To configure tiers, a new sysfs interface is exposed at
> > /sys/kernel/mm/swap/tiers. The input parser evaluates commands from
> > left to right and supports batch input, allowing users to add or remove
> > multiple tiers in a single write operation.
> > 
> > Tier management enforces continuous priority ranges anchored by start
> > priorities. Operations trigger range splitting or merging, but overwriting
> > start priorities is forbidden. Merging expands lower tiers upwards to
> > preserve configured start priorities, except when removing `DEF_SWAP_PRIO`,
> > which merges downwards.
> > 
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> 
> This looks good to me.
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> 
> While there's only one tiny concern, please see the inline comment.
> 
> > diff --git a/mm/swap_tier.c b/mm/swap_tier.c
> > new file mode 100644
> > index 000000000000..9490e891c5fe
> > --- /dev/null
> > +++ b/mm/swap_tier.c
> > @@ -0,0 +1,302 @@
> ......
> > +/*
> > + * Naming Convention:
> > + *   swap_tiers_*() - Public/exported functions
> > + *   swap_tier_*()  - Private/internal functions
> > + */
> > +
> > +static bool swap_tier_is_active(void)
> > +{
> > +	return !list_empty(&swap_tier_active_list) ? true : false;
> 
> The above line seems like generated by AI. Whatever else I have seen is
> "return !list_empty(&swap_tier_active_list);" which is enough.

Oops, it is generated by me. My coding style.

You are right. I will remove the ternary operator.

Best regards,
Youngjun Park

