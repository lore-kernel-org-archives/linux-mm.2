Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3454C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9F96B0088; Wed, 23 Sep 2026 08:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B17E6B008A; Wed, 23 Sep 2026 08:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7E06B0093; Wed, 23 Sep 2026 08:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 598296B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:21:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA35BA6739
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:21:17 +0000 (UTC)
X-FDA: 85244936994.29.8B4B6C9
Received: from mail-wr2-f39.google.com (mail-wr2-f39.google.com [74.125.225.103])
	by imf28.hostedemail.com (Postfix) with ESMTP id 18262C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:21:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ntgJMIgf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.225.103 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790166076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TL+zy+izjVx2cYsJok0G732OpLexLuuUAzyKfEF0o8=;
	b=DtWnzbZcByeGByof2cSPOKAg4bQYSluTr7HWPf03LNOg7a4W/Q43p7w1/nUe19j5Knp8SF
	cOAbJ56wgMOSQ+5J/8sU1C62DG9AwFa0xc1LedlnKziE9dRt8qFhO7kXIDlyEl907LgN3m
	X0pqfQwq30+QkxNNpsZd+tMu60FtrBY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ntgJMIgf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.225.103 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790166076;
	b=o295Doo2wWRXu4kA5rSfi9NpuAvBBGhQ0ZHuZDhSXZNclnn5GQfXP9nhviQLj1yquAcZEk
	SKpVhXfEiDbdsPDi2MeGEt30xUP07UkIMemL6RISPQ7Y7aHhtDeh/E6qkgafTSxxjED7uE
	3lTaBwTCcriHkwaSzFD6rrB+r7hgBhc=
Received: by mail-wr2-f39.google.com with SMTP id ffacd0b85a97d-482f633ece3so719146f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790166074; x=1790770874; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/TL+zy+izjVx2cYsJok0G732OpLexLuuUAzyKfEF0o8=;
        b=ntgJMIgfMlTWRL6b4LPjkNXWd2uw8+8JVT2BnSQv9pdVEgBb3thx1fAwTqLd+IimyE
         6BI3Bai8gr2dnv0hiqeaVIt1t/tMlprJh31uE8q0RsL/YjHVEvRziSjfc8SZUGtL/yuS
         8PAzceERONM2tVv9yeccSIoESWWLPyV49zib756afJph4TFC5ryCVaDrpIqif7IVSNBM
         /mctlXZL8qP3kiPdo5VTSlKSYgcvloPJW9i9HBe1v1NhfsuURkm4CoRjF8sAKvpsPfBG
         qsfI9qjz7Mr6Pg4ODIvJ3qSa1Du1/MC6NiuDHKV2aaRnGUQlNkUUM+HV53aLg4rHPCct
         ZFHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790166075; x=1790770875;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/TL+zy+izjVx2cYsJok0G732OpLexLuuUAzyKfEF0o8=;
        b=jUNlb1w3cNDe6pzqZiQCn/cHv75su4oBVb0CdjalYAGU4ZFeTAmqQSOJc52qkP8F8P
         XFfem06BjX/cWCzUZ0q23KWCdcC4HszIwrH5chV3kiR14Fdci6KhN3GUvMsiihoyCnLe
         NzeT0bUT66puxJxgN0ZIDpYSMZ/n4f3d2THyg0n2ZSMsUZ/87D1V3vhOd0RccBl79lKn
         HstVo9cEcX6EvmWhRXNu0jBaxrHx1vG6BOkpiUG+mq6PFt5lCy7Gjkgue58lYvBqPDxH
         KCM9ETwwtn7j3VfJH2+ltKefjBzHv8Y0WNaQG4012T2hVH1P0iKt9P3zhwyN+OU5X1jL
         925w==
X-Forwarded-Encrypted: i=1; AKwUvBy/sh8meBEfBnlsiY5x84NrKckCXCe+8xb1qZjaxAA2XFdPVSXY2Y2E8kldFHmufvfEj4Ccdwmbzw==@kvack.org
X-Gm-Message-State: AFuF++kMorPpetZN4XdmIa536JhO5iVyUnchkb6py42XMP/kJAbteOZc
	JUKKQ3/RwE3ddmdtQ4S5WCWTDmH2u7y4UcYwFC+KxLJoLi7/qg1jUpW1OzRPiFwR
X-Gm-Gg: AYBFou2aKQXq+gHEsPg5uDlfE3ZgDin7DeEr1L/9XLE0IzMolasA1fdpoy9NXvzKbXl
	WAzRowZ/1m54vHVg3Wvm/FTnXDlvfRKkv3DnpuPBrivU47/79+kfuzdGi3zjS3eemBlVZxIivsC
	wdl6qT/aUH1x34kN/78E/v6WE3OPpCWm32T7S9stNhzU4q2k2TDyBvkNHjdcYFCI1AAq5VbKq1B
	28ecd+0zZZXUPx2M1vmQ62BMbDN8bns+nALr6T1RQbIq8NIk2gvouHeNoSeiGVpaCIfAmaot3ix
	kSVBf+6a9GX4uEjIFtjXEUSnHqH6PQz0xp/RU/vJLNHLxxerwgXKiuuEaqPpptzYp1JN4jMGoWn
	uLnkF+qZB3ndpJH5Pg1QyQn7Mb7uL0ZbBIhpJ/q7VO+eIqtRxvckW5q/mHP20KOQZ+fJPRKkld5
	sG12qY7wnzYOuXDhZECUqxUxbN7sC6V7b4G5hrTmx27mDcdCEV5diAarb0FNAUEcK6IsHJ2+4fu
	hJsjv7YPFG0iDLgTBgB0zGMZEsTAKsq/lNWnL+LC27ubWgQl9wbDuM/auOZkWPMxE1eEA==
X-Received: by 2002:adf:e18c:0:b0:487:aff:c060 with SMTP id ffacd0b85a97d-4886709d0f8mr3962430f8f.48.1790166074377;
        Wed, 23 Sep 2026 05:21:14 -0700 (PDT)
Received: from KASONG-MC4 (11.pool90-167-203.static.orange.es. [90.167.203.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886848636asm6261900f8f.6.2026.09.23.05.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:21:12 -0700 (PDT)
Date: Wed, 23 Sep 2026 14:21:08 +0200
From: Kairui Song <ryncsn@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	Shivam Kalra <shivamkalra98@zohomail.in>
Subject: Re: [PATCH v5 09/17] mm/huge_memory: rename remap_page() to
 remap_anon_folio()
Message-ID: <arPD3ztCpw0r0mBu@KASONG-MC4>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-9-39878b37dfb0@tencent.com>
 <6e542162-fe6c-47da-b0c4-a36251242950@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e542162-fe6c-47da-b0c4-a36251242950@kernel.org>
X-Rspamd-Queue-Id: 18262C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: q73mnd43rn8hsdmi955kkhu4pp3mqr1b
X-HE-Tag: 1790166075-592912
X-HE-Meta: U2FsdGVkX1+MiOWNrCUMapibJgV+EctX71B9SWY+rEcNZhAuuat3u3bu0/+F0+5QpiE6IjqL8xS6dSL4WtTM8NQSK+Q6Q9RNuFWUwC616gKoJcxHdzQAOzFQ4wecI0YQ4uTQ5nmYXWmU4vU0dtQskQzklXSGSEILYyVtXJSC+FLEvokqUcki371FbkS6ZjpAWqVw5WLju2nqg2yZuaBG1ST8n0yv9sG9HyLeB7Myz6pf/s1gfs8FVJWfOfqqIMVzUSeGHBAIBamoElPzA6M08oPDjlbiykQBwBr3KJej/JX4686GmO+BN/B505kXxYm7N96hABeyQZ5V2aB3AYzBayosBsZmhm2oYbPcXZyeQS0ahruP2Z2QzyOPWcYlVpvgGHF05o3PLefnkYI4i8GM3O3XMErgyYaKgR2GghFrKi+c9S27AZG6ezoF935eTN9FRchgOWW9htvmOjlnmxzTsPTNcEsBj5/tWnwTKq4zXhTSnVcD0XlkV4rgW/RFe+IvRvpU0DCsikB85jSE1KIXhBQmdUQIo+yGWLgIZE8bsIMSvnCM9XXtot8daWTD1Z/t2SVOcK7vXjYn03NnHu8OyYfFjiTJRmTGIfY4QWRVH51reyKAs36Jr3+jiO7icH64hl8G5Wx9yggnENJ2imEfyJMwjPxvOQ37O/SOgK/SVmOTNkuFEXu8ytmEOLqShhjV87Z8dItoCcBk7Rc4CCBem1DnaKTZAnQ0U1ngUgLlKUvAAyCSGI6GttQuq1lxLimbm2QOFdnVbVIEYy1fckGfnBp1wYh9jSoy2kqZ9906MXpglUna7Y+rVT7asF5glJ5pOu0IYEWqnFMnArgsyhuO55HcPoJ+t8MZ1a8hzqUFo3w/dWUvYzejFHPX6/Xnwr5mffCkEqvnfd5JarQ5I9SsSa128+k/0Nx+M9J+HTnBUVfEjolbn87GOSSWTBnMGo5YrSUGkVr+lQS1tVRldSw
 3m/N3N4J
 oqHuHMui4CCqOHpU/MzfQMu44g0+dC5/dztbc5wCwMpJnF+lBV7IgU0aYiYGGg2Rt58iabPZ+3w9903XbSOUltuaEPoVx/XENJLvuRllw75SnGyp6YQRcHRuTayFgaXuY3tvbvOhU4ih/EfT74DubaVN6FZ0Rc/vgJtKdkVQP/BSPZJQ0Mw/k4pnbAsetz495+Lf8rMV2RtazH23/L2vbm+zCG0t26THC40Ux4NeqSRqBLnOuK7NZGKiXSwumwqw5ADrmY0VREjpI3Gt5TsrbDmqTnSZQZ8hz++3H18SpwA6+IvZQZI4CKVIlMBDhUMemRUQIQUF7IsZiBsW2wDYqSdL1FHYJB6V66RepygJvUhshMM0X8rg5jlB+u7gWdg4I7o8k5BXILGSqHzP9U/WFVdLxvUVOszLNfcD1MTKpsivyqXGbLlGIVhXDLz+8W+I9wqDZM3KnFKlDBfkZgRj8aUHCOUAMDwoOxyPYFOy+Dt7cZH8u4AksNl6jBU+NtOGsvuRIxIVYOwKaK+wGdaFZvXBe3YQcSkmRaLGvQ/eE/oVJM1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 10:46:55PM +0100, David Hildenbrand (Arm) wrote:
> On 9/14/26 19:14, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > remap_page() now only has one caller, __folio_freeze_split_anon(),
> > and is only ever called for anon folios: unmap_folio() currently
> > leaves file folios unmapped after the split, so they need no
> > remapping.
> > 
> > Rename it to remap_anon_folio() to make that explicit, and add a
> > VM_WARN_ON_FOLIO() documenting it.
> > 
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 1749905ade6a..77bf68c9b9af 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3552,7 +3552,7 @@ static void unmap_folio(struct folio *folio)
> >  	/*
> >  	 * Anon pages need migration entries to preserve them, but file
> >  	 * pages can simply be left unmapped, then faulted back on demand.
> > -	 * If that is ever changed (perhaps for mlock), update remap_page().
> > +	 * If that is ever changed (perhaps for mlock), update remap_anon_folio().
> 
> See my comment below, delete that comment about "what if X" entirely. Also, we
> wouldn't want to update remap_anon_folio().

Sure, it was added due to some previous reviews, but things are cleaner
now with the renaming so just remove it is indeed better.

...

> 
> Add remap_anon_folio for file folios? Just delete this entire code comment.
> Whoever wants to implement that can look into the pieces that are actually needed.
> 
> 
> With the comments sorted

Thanks!

