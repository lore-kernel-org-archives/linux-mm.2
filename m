Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D35C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0A56B008A; Thu, 10 Sep 2026 04:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50456B0092; Thu, 10 Sep 2026 04:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D573E6B0093; Thu, 10 Sep 2026 04:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2FDA6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:14:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FE2E40477
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:14:41 +0000 (UTC)
X-FDA: 85197141162.30.31ABE1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2EC74000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:14:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRuWfG+E;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789028079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvf4tT3qyVQ5qSeR5/mA7bz6/OSaH7qJ1i9sSUmphc0=;
	b=29tuIO8oPSjWih79zFJ0ugCeGpNgPtE2mBiFKO9C5I1fbDBBHUEM2QViPH6ig8COPJ1eiP
	DsJqtLyLTva/1Pqw8aBi5jrWi37D9Z3XkKxjtxMjG0Z27GMypLXCIWr/vrY7irqyzFkMqb
	+vgLxBeaOoe5mJh4Uj1NcFdA2kc0Vsk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789028079;
	b=AQ9++eR1lkZFad33ZasRd0E2sQWM0g/ExOijNsL4aw0is5Gn0vJZ8zq8hyOkBZKP4d7Vie
	fHbbqlfCr+KU+tdcnQk70uOpzYEuSXKy/zFOuWr7HuJ9sFbvRLroWDWgvEKMt5wEl0QZDa
	sQiFyi06N2U1pCB5h7V4Lve85pyxLZM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRuWfG+E;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6FA741B18;
	Thu, 10 Sep 2026 08:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86AA1F000FF;
	Thu, 10 Sep 2026 08:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789028078;
	bh=mvf4tT3qyVQ5qSeR5/mA7bz6/OSaH7qJ1i9sSUmphc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GRuWfG+ERt4+xZknkajh3piUbexT6bu5syNLFw1uW5AqgAaw11neKGUjHKMvFgh55
	 BlknpZffvbW2Yyp62yTcwnbEtuLI8JV570rB194qwgZII1FQIB2tjyfHwKQA4JZh8W
	 1PnWW7gGmqgXxG60fpyqC3G0z9cphDtUzChBqXh5aAc82noNGUbbuaeiabrumyfi/V
	 5e8iZkpH8ELp6m8w8NIJYyQdlfqxOAbesXRgwTgIxojBOBDsr1zWBwN5D+OvKSyZYg
	 SB5WGD2GMVNhAaLVaphvBO6pRwDD1Sd7g97ybvGM/9LjxjaP32uZzxvdDYYYo1zun8
	 2GorJ5tXK8HRQ==
Date: Thu, 10 Sep 2026 09:14:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: Re: [PATCH] mm: implement and use vma_is_faulted(), silence KCSAN
Message-ID: <aqJmt_rQCTodhJuj@gremlin>
References: <20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org>
 <3a261c3e-4c26-41b3-b55f-5800ae1081f3@kernel.org>
 <aqGJx-uQjN8-DEBe@gremlin>
 <c1f21bf2-71e3-4537-a000-fd0e95257759@kernel.org>
 <aqGaNT1M-csCCQk0@gremlin>
 <58173517-fb38-4508-ac8f-ccffb299be6d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58173517-fb38-4508-ac8f-ccffb299be6d@kernel.org>
X-Stat-Signature: rrozmymsezo3pc6ee9xkw4ag1n3trmwk
X-Rspam-User: 
X-Rspamd-Queue-Id: A2EC74000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789028079-267253
X-HE-Meta: U2FsdGVkX18IZR2R6kHz+Hxf5Vx9k4Z95XkrDJuweJnA2LJCr/yICvTKqH0isWMfuBMjBmjSDMjcWf8SltnXy9ddCMuGbwEbPiAG3RbkDMHLjKyheUTK0r8V/R2HdusMtKcNqsyELs7IrNYVQfwW/RWP7gIaH7Si7oojq4ZAWT3HJX+ucNzUzPt/+k2uD3koy9oBC8kYgwWfTuMzPKSRqa0OE+J7xnrauXfJX2pLAd1OT4xI4TLB0GnUMPByxlJOSBmhkoxMzyFgyb7Lk3Bn5IilLdD9U6ARlWc4bdkQCmVSWTOXzl5yDy/L2Z4g0joZXNioYlUCKf4+hT0yrbgwNdIdii+s/4HA84HmR77jTTHSQl4sja1JAIJf8pcU+qRfpWza7bCRmpP29ex1uenAoJLjPlTYRG0ZZK+CnOvzkwpknFYxvB1uCNlzFEhmPM7m+VAIlEItSJOnFetLvOzhMnxh0h89RB7O9aOOovVoAVH6NFyyfPBjkzympQGc0NJEOFvGFcO5ZxBJvzz3JcGRA5uYhGlJrbH02fBEEa8UaWulwloxvj4y9i6YNGULW3zhULkqPXrYDUd7tyoHqTqCTRimqsDK2J24+KzYVlN491efdqY6kjAkErEc6W6DfBRbmoondfC1YDAL9nwfN4vTamoP/7acyXmOJXBU9QX9GeNE1JKdwWcvOqKdBt4yy/ddccc4yuJFRwnKQzvvva2LoF6ON9eqaqdy89XNeJMRI9D8ou7OAXejRvUY0i7dCSMdxHuUYuyY2ZIw4mWNbQX/4aYeTZHRhAPCx8p6+MJ2/RiegGJ/vtH2gOlL5TPFLvQZY7fKNZeESlCct1sJzAv0hZ0A5Y5PHbxkCpQ3X4Jb0SArwKB1YLkiCODCeXFC5agvOq16pcaAm7ZK27P/9sSOtCCOKpkpjjWLZNgRHgX3Ucz/XM0/2X9DRzBxtgVx5aaBVk6sac+696BjZbESQM7
 56IuKPwC
 0biaORPQCY0BIGbw22567V1O+RORceM5WGDil9OEnklx8XXOQYnPsB6iVOI6RL7aTnadAB/ChDPR0uJiDSDOqonOqueTrUb7xknXbwkKb64P/5Tu9g1VuDDQELPVnbnKpcZYx000EOfISYfYP43EvK2TgpQ5sYik5XPaxueVY9oXo9fBj4HVXT+/zivW11nxSds8Oqz4SBAzDmW6FrLQuy/3cZQT0IIJN/vujGgZJYLNYXkMVrBaydCsAtdUJgzBpOBmwk14wDpE40H+LYk2zy75EoeuAsunR7895SImN+w+WKxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 09:46:23AM +0200, David Hildenbrand (Arm) wrote:
> >
> > Actually how about:
> >
> > vma_anon_rmap_tracked()?
>
> Or just
>
> vma_anon_tracked?

Yeah works for me! Will respin with that.

>
> >
> > Then it speaks to what anon_vma is actually for, the fact the VMA has an
> > anon_vma assigned like that means it is tracked by the anon_vma, and it
> > abstracts the actual mechanism?
> Yeah, this goes into the right direction.

Yeah agreed!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

