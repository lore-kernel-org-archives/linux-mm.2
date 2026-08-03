Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA566C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92F86B0092; Mon,  3 Aug 2026 02:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43886B0093; Mon,  3 Aug 2026 02:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C796B0095; Mon,  3 Aug 2026 02:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A007D6B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:38:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A2C614062D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:38:40 +0000 (UTC)
X-FDA: 85059004800.05.F4A905E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7598C20006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:38:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OW+F7WyO;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785739118;
	b=f81XDbWkBaKcetwA3U/P/Cau+vBJ577vdGfLeVcKRplqh0V85+k+20vUIhz3fsdR5e1X4p
	QRGT/Lcs6NYUYpBbPVU/Qa8hIBg2syI+sgcKYB9g6ZttVmnQtBLCnepW6tzzVUenDWPOOg
	bgFpXS4GnDj/m7OKGAyVuky3Ve6RhfY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OW+F7WyO;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785739118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW7Og0qPxzuL6m6WFYbBCbPX3qINoEYxL05Tp/X8L/M=;
	b=t57IX8cdbFNin3kpsCsMOQBNjItuM3X/G745Vqa5Hma4GWBJxcNf0ktsrk26q0nGizUzX1
	x/q4Q9KzRyAL2ybQ3VXU9XRYWQwe/QTNKdL/aNgP0YIsUQp4y2kbJwXkgxlPXgjZEKnNYk
	f83tCIqUlDLBUbobF6cFER73aZ5gEOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EEE34181D;
	Mon,  3 Aug 2026 06:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AFC1F000E9;
	Mon,  3 Aug 2026 06:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785739117;
	bh=pW7Og0qPxzuL6m6WFYbBCbPX3qINoEYxL05Tp/X8L/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OW+F7WyOx6cgS/hdYImcNWyD/FWqnkb/95WncioGVZSrVnsUcNUvp92NfVhJ3mYoT
	 NVCBG4M5JTgSZ6cBMNXMo8GzMtXYoXDo5FPb0iGBya4dkVax7s/1NM1vS2jAcXx8oa
	 w9fv/ZwElNMPHpK3zjsi95HROpgQDJGKazTOGhKIAR1ZAYNbvid5sgaBMAa4Vc7Y3E
	 c//cStuusvoomu2ZXRFS2Yf+xT1zDCawUD85QNiZnrMLeSWXhD6MoUsbnOls8eKL7C
	 Mv39sE6fO10OJfecIzohY6qmDcbUlE4MMLvqytBlOjWE/o1rIJgKUVqrhXY2nWG600
	 4x8LLeg8D2MwA==
Date: Mon, 3 Aug 2026 09:38:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
Message-ID: <anA3Z9XH-tuiwnNu@kernel.org>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-4-songmuchun@bytedance.com>
 <5005C7D3-B3ED-4C62-B611-8465D2BC69FD@linux.dev>
 <178540851830.2154539.6359871825839331816.b4-reply@b4>
 <3FCC8989-95DB-450F-95C3-183787DF4D08@linux.dev>
 <amtgdZ0U_UIbx_hI@kernel.org>
 <89878C33-9BCD-4FD7-92A0-884CF682CBF3@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89878C33-9BCD-4FD7-92A0-884CF682CBF3@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7598C20006
X-Stat-Signature: 6659zzuzjozktfa13zyekii95zhdppsh
X-Rspam-User: 
X-HE-Tag: 1785739118-767142
X-HE-Meta: U2FsdGVkX18hYidij2l6DGVXSZx92AuC+sMOgq/6m6VIAGh890Fk/3SwHloYAtwYGtUX8KtuhbZ7qWs7zKb2/zLq5pTNx9RyGA7UX8rCh9UES8k9wCn4e++W2z83glvcXOSwTjnNX34SPmrp5g8n2I2VBwL3m73jrDF/tnuFtvNJudMjdTS+fvfKEvD9s5zAf9f7/PgBhdCKFrBvfLqmyV+WF5nsgbUHHJcMj2rK0t9XXOQvgEd/pXunazewSDzcNcngkv3LPuA2E2fv57zGMixqibEC/pM4xKnfWMTIuyDV/h83qP/aY/EWkpV7zC+uswyXchC5A+1zm+qfD8kGO12W1z/D0Q4EZymxvkyYrbr8H2HMnoBl0ODauotGGhzxjVJknKvaJM3II6R9d0w2mSnvXnEQkARNpQl9XfDMXeZ0GtUPtP71IwHeS33ZbrRDnWLFK19UGkeh1M5EBfpr4rRqhuAU1W1fD2pDzgSADIp7pxle5L4f8sVycOqs0nUMEQ/Jx4ytzyfUV6ubh/byQQHFAwHPGJJ6lm3AbKRhE5SgaEUj8DRiL6Xgy0Ul4KXrOpBx6byDpcbqYKBIcT3kgHQyCNgHqOqtl8+eO8IJ/Kr4PfMgD2hDguX6qg/MGSzQcMCcOMiEL2+KgMbVFLE3l4tWaIBXw5NJSTketEvAdc5vVwgc/PzEIAKMO2U1Pl8C8y67Bl6/e079ITOoel3fZpDVy8oIT+YN6K6mfAyHftqRxwRPp79ZY7GwAajGFobxA1k3RnRaHN6tkuZNeoxlZZDzSYYXPU3fg8dNK0y5kNzcowtROdAXY3GqOP/93jN2aZsSyApk9z7GVZgCeLWYOMQZL2xtAT2FJiw12iG9K54JClEny0oTmve2h66iMVbTQmuH6jX/rvMidD3OB3ZytFDHU4LCGyhJIwMLPr+LSWMDR8cIwzBCyCkwzvnHC3Tlgk/GVwDEmlut8+nLgDN
 pLVJh/1G
 EgUOu6gvljObxirfRFEST61Z4kfFgFUAZA2+RPfxvdJ8oWJVOweqQeLbChAy6UDjFLiDAQ3RRbe4wcYyJNPE0k9P1sg0HKRjZyu/ntl9WFnbgYspt/am98BVWe49mm5gwL80foCPTDNaI7bbr6IM84jWrykIeHMnwFnRf5j1O9d1MKQQTapdbqB1e16etA9JqebOVOcrj/YGLi/BQZ1yEPV3Q3zljZBbWggVhz03QuPrT5aLK+i3ft7uPGEo8d1x0u26z3yFhMiOTLmf0pdM2VYH0fmsDnTj+xzo+VETeLaJnt+r8M96LRdnxy6Kp6x1GdbUT8YrpWdvevnk4zP3NtnhTvsTpjlq3iueYVsYiriex/oNdtY4MAU37/A81sKCoELjVBYLKbUpF9h11KoxU/7zmfndIlcjq4ikspKy8W3W93S4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 10:13:43AM +0800, Muchun Song wrote:
> > On Jul 30, 2026, at 22:32, Mike Rapoport <rppt@kernel.org> wrote:
> >> 
> >> Since we also use __pfn_to_section in the patch 14 in this series for
> >> !SPARSEMEM, we need to make corresponding adjustments—specifically, by using
> >> pfn_to_section_order to determine whether the vmemmap of a given section is
> >> optimizable. This new helper will be called from several places, so I'm afraid
> >> its introduction is unavoidable.
> > 
> > Do you mean that section_vmemmap_optimizable() will receive pfn as a
> > parameter and use pfn_to_section_order() internally?
> 
> I was originally planning to go with the this approach, but now I've come across
> something that feels a bit unusual to me: a function whose name starts with section
> takes a pfn as its argument instead of a mem_section.
> 
> So I started thinking about an alternative. How about we keep section_vmemmap_optimizable()
> as it is, but introduce a new helper like this:
> 
> static inline bool order_vmemmap_optimizable(unsigned int order)
> {
> 	return order >= OPTIMIZABLE_FOLIO_MIN_ORDER;
> }

Maybe name it vmemmap_optimizable_order() so it'll belong to vmemmap
namespace, order_ can be really a lot of things.

I think it makes sense. Let's see how it fits in the end in the new
version :)

-- 
Sincerely yours,
Mike.

