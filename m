Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D871DFED3D9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF386B00A9; Fri, 24 Apr 2026 11:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F9D6B00AB; Fri, 24 Apr 2026 11:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCDA6B00AD; Fri, 24 Apr 2026 11:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B32A6B00A9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:06:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A945F401AE
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:06:33 +0000 (UTC)
X-FDA: 84693775866.09.4B56DA5
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id C62EF140004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:06:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cAldweiF;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39aR5XRbrEXV24JT5m2euVHnJMBsT6ax8xLhWEkFjFY=;
	b=qQM6ZlViQtcobR0WgIxgDJyyaQ3VOGOLDQcwHiPi1i5iWpsaEoiI9nXn6wSa6GrOdXkRzV
	27wfnGjLOZVNd2Q5UzXzkPxUb0a3FMUDCOrrBVc5NZDOazS33TPYc6Vmv9zg1CRFDDHQxS
	MOfSoJVLFF2jfNgda0GfnOQaIsbxbRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043191; a=rsa-sha256;
	cv=none;
	b=z650iou2bV7HuGhp3CJy3o9g6ix9K2ou1QZo68u/28K9cUEsIZFcqulGjjNd9ilIsxnCqT
	tk8Ddvvl1y5SB0N/B8cnPDfeqqJcuz12VMX2FXpESO9W3S6I7NgEEYrTWHPWYL7FKMKfZe
	EsLbAa9nvwqfXH6PLGDKtrqOGPHAguY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cAldweiF;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8cbb6d5f780so714645885a.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777043191; x=1777647991; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=39aR5XRbrEXV24JT5m2euVHnJMBsT6ax8xLhWEkFjFY=;
        b=cAldweiF7Jo5RthQ2wQb6zeooCaUNWKMPmYr88oMN0eECEfaQOKWTZ6oBrOY+b/p73
         49/5oNZ47/9w+4HBzTRb5loUtAAQI2MxCkk85gry5qpxzvtPSXKcuppdtHZwYwbPs3MF
         u3YhQmQzMAxQwnE6iTapAVDWq7DEDO0FoSU4Pk8O/zDOcpiAnJ6o0TZ+DgL2mchVk4HA
         SrmZkEVvq39K3N0O0Lbs15G+UGuxrzwG2wx5uk/R7CAkWElwzLk5KxTJdAyANV1if7js
         Xe3o/ZLjMsWkdBUUcXoawZLdiDcIbyyujRGMNqITOewSatcbawnW/u/Rty6B8IfhY8SU
         wINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777043191; x=1777647991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39aR5XRbrEXV24JT5m2euVHnJMBsT6ax8xLhWEkFjFY=;
        b=pz+CMgpclSxphsa+h9InZxJ2fCWjefiU/eXcL9LBmScs6yYt8SHHU7678QJkY01Qnz
         5gx6w4t2FIL+Zif3I/0tQ47FLzJlMEcTDn3utfs2ws3z4WKWDxZ/QaV7PqEI/v5Eaf1s
         AYYJnlSwVWgsVwgDFrL1mUyadmDgQdScOCEhm8eQUON2YPZkQDIHlu/jYG7A8QuWkq71
         JhlnCwuavXaaXINJk/X4bWag9a7uTg83gMdw0rPSW1pW0vjh8ObQ42eZ/LnEwWRPu0y0
         uAJc63UGiB2zjceXdxb6naolsq9wqdDg40p8mJNWBNBn/itXYZiHUlAqwFwmLU3FK4rY
         J3uA==
X-Forwarded-Encrypted: i=1; AFNElJ+bFqUy2hE1urf7UshlsRjeT5PWFQPghmkFOs1hKxLnA0DLrRyTCn2mLDLyLTj8qV3VAhTg19K/Mg==@kvack.org
X-Gm-Message-State: AOJu0Yy2E3OoihMz3oHZqHfMmrTQISTd6DC8Lx/PrhMgT5dmbP1bv0py
	xBqVp01PiHUqOKRdtL+kLv3zFuxpsG4lc6RXutSvhadIqZLHA4KYJuZv6f8LJg1TUkw=
X-Gm-Gg: AeBDieuvB0cCXHFsvg9LWZi4RpKoxZVtwjOtJlmgeN8gGjtCDT7A/d1JbXyfJT8MqVE
	uYOUpt6dap7XtGRLB2IE56nOyPEhzTrg9eGvw0LRSjWlP6LfEXUUSKYZGhwaHnx9BwmyOmy5LPg
	yRjiSNnlStkJb9f2mnDpZxWdSZGoWVaaDMeD1UaH0MEaHiJYD2gClmB6bsjRkRt4C5lZslzWbr7
	6cgCcORcD2TQS+/P26s9AVXiuqLMWhnYN8tTL1R2MyXnHRkhr2tJoJdBowz8+2O7t0LWgU+Z2lW
	AuM7Lx5ojmJl8o0JUR1eBsPTEH4udHuEltT6vK6JE+/DuRkEjGDBDC7AFqz9XaC1yt5Zr13V56P
	VU5+OnCHES8P2wPgiyYe+86/I5brvY/MoY5MCNR4/rXEXh3CpssrYCYiFgTw//gBL0mEpWq34OO
	mTEZ9cGGTx+zJDnjVkgZn12lR8khUrSwPExeX8UC8A5bBKS/vEdOrx/Q1mTmXmEQ==
X-Received: by 2002:a05:620a:4623:b0:8cb:62c3:3690 with SMTP id af79cd13be357-8e78f443268mr4562871085a.13.1777043190723;
        Fri, 24 Apr 2026 08:06:30 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d9abce59sm2293120385a.46.2026.04.24.08.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 08:06:30 -0700 (PDT)
Date: Fri, 24 Apr 2026 15:06:28 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Sasha Levin <sashal@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	skhan@linuxfoundation.org, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sasha Levin <sashal@nvidia.com>, Sanif Veeras <sveeras@nvidia.com>, 
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
Message-ID: <aeuFnuiYDBjttEKt@plex>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org>
 <aeuC6TJ4XowazVZj@laps>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeuC6TJ4XowazVZj@laps>
X-Stat-Signature: uasdftdw5p8scrb9framcfpi8t7gwmn6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C62EF140004
X-Rspam-User: 
X-HE-Tag: 1777043191-596882
X-HE-Meta: U2FsdGVkX1+jBNRMHQdjnzrQkVqRvnJFcQk/S1JRH6RSfhh8sI9QypE7RTfxYKd3MMGpeg26vFO7dv4w+aDzlWfAgNxwdHvRL44s5MQGEVCcWy5XvidaD5PrcJT0h8FZEB6+aKiR45Aktzn7yBwuikd6YPhB/DYgBfUMjhCn8TzMxsbAi0nuenAiBGt4/4YRN3ak/gYKEa56WiFvuMuhz4q40hR/ldxWN4s9VGykljVJWRcdypfdvJ4xoXL62HHtSidYMl6nQxItAIUF+CIdgYqg2cYyf0gH14VsC9FWspq6yte9EgelDYWEq+uIcesvm4aUKttxBePJI2lStOrNpWhefjNGqvk+/N4jy6iwXM44cTDwb+MaylCI8OItErrouAWnOLDKv2UQV9N8uZvCd+WbC/uPvuDsaLNxd4rlT9CU+vo/iTJ8tW6KWbUEXkz89jXzlygI1oKDzgSuGcI+LVt1YV0GXBdw2kkuFuOpSHwAn3hUWWdSxpd4+uxNdapfa1YiVALY6K5WzlDXuv2O6KDfQufGqkXB42djVFjoG6H3wMKCl5x05D5LFZHSaqZHvd4yLQMkabR1jSf/aQNvnzIuZRHqU2gD9fTgBmsXFCtlGeZ4pFnMECvdpRSVD2EQdG34oVtJKfGoOicCcxlxIdDAUIQE8dfPlBlaQYuiIX1SEAD7pPFWFQG7J3UicOthzyJJR2mFdZFDjIEIbc+RAasG2uX7iHE+eHQ5Kj28PL9Qs1FmY3HpxI+UimVH4fHWudHzYVTpmDfEItE4m2zk1k+EnxjUo2rYut3fR+QnKWP40i5JCWNqthha+KODklGMqah9CIB6ceTigNvMnMPn6GU1vdUI7BjHJPNqpemR1b4CHnonn6fnvME/7eZW2OU6dX8u5Yweu1NnxDgSbu8JTh+R5VFZARYPQfMwRnYltaLKf2Rr39vp/coqOAoy7vHv5dwrNLYdiTG24AVUsgW
 bsPfN+2s
 3oE4tc7dkopTBtjr0fS/hWSbie1ePjBLLmalnxGNu3xNzYpDoWeCaedQ6Rn1dHbvPZ0jER+Nr2xTXl78WuC3bzbHjiEcMxtMtTl8Cyk6SRLofN7SmLCollES184hw1xDTRXK2H73kvy6OQVnEukRpmEDXonljLt1DpQz7ghw3ZXHPfINK5EVeethFLEcqOLP3rsX61e3+4xumD/CeXnC5/kYJfhlozrmrsg1qentqfnYniGMlQHDhkBDuihh4LRwD81ET/exD9jrwgRA0cljsq5/cnVwnN/F0Uxh9VevRmYgAbdoUp/5Pxf9Bkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-24 10:49, Sasha Levin wrote:
> On Fri, Apr 24, 2026 at 04:25:41PM +0200, David Hildenbrand (Arm) wrote:
> > > +	/*
> > > +	 * Size bitmaps to cover the full PFN range including any holes.
> > > +	 * Holes waste a few bits but a flat bitmap keeps the indexing
> > > +	 * trivial (pfn - min_pfn) and avoids additional data structures
> > > +	 * that would themselves be subject to corruption.  This matches
> > > +	 * the approach used by pageblock_flags.
> > > +	 */
> > > +	pc_state.min_pfn = PHYS_PFN(memblock_start_of_DRAM());
> > > +	pc_state.max_pfn = PHYS_PFN(memblock_end_of_DRAM());
> > > +	spanned_pfns = pc_state.max_pfn - pc_state.min_pfn;
> > > +	if (!spanned_pfns || spanned_pfns > UINT_MAX) {
> > > +		pr_err("PFN span %lu cannot be represented by bitmap APIs, feature disabled\n",
> > > +		       spanned_pfns);
> > > +		return;
> > > +	}
> > > +
> > > +	pc_state.db.nbits = spanned_pfns;
> > > +
> > > +	bitmap_bytes = BITS_TO_LONGS(pc_state.db.nbits) * sizeof(unsigned long);
> > > +
> > > +	pr_info("Initializing: PFN range [%lu-%lu), %u bits (%zu KB per bitmap)\n",
> > > +		pc_state.min_pfn, pc_state.max_pfn, pc_state.db.nbits,
> > > +		bitmap_bytes / 1024);
> > > +
> > > +	/* Allocate primary bitmap (zeroed by memblock_alloc) */
> > > +	pc_state.db.bitmap[DUAL_BITMAP_PRIMARY] =
> > > +		memblock_alloc(bitmap_bytes, SMP_CACHE_BYTES);
> > > +	if (!pc_state.db.bitmap[DUAL_BITMAP_PRIMARY]) {
> > > +		pr_err("Failed to allocate primary bitmap, feature disabled\n");
> > > +		return;
> > > +	}
> > > 
> > 
> > One bitmap that covers all sparse memory available at boot.
> > 
> > Conclusion: Just horrible.
> 
> Depends on who's looking at the code :)
> 
> I picked it for auditability: covering the whole range with two
> memblock_alloc'd arrays means the only thing on the lookup path is the bitmap
> words themselves, which is what the dual-bitmap invariant already checks.

The issue is that we are going back in time to a flat memory,
without NUMA or hotplug support. We need an abstraction that avoids
allocating this memory in enormous contiguous chunks, as thit approach
will not work on modern hardware.

> 
> We could go with per-section bitmaps which will fix the waste but pull
> mem_section[] into the trust boundary, so we'd have to start validating it too.

Page-ext provides all of these capabilities, but as you described in the
cover letter, it does not meet your requirements. Therefore, I believe
a new abstraction layer is needed.

Pasha

