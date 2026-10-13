Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 635EDCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 17:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4366B0088; Tue, 13 Oct 2026 13:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4C66B008A; Tue, 13 Oct 2026 13:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094976B008C; Tue, 13 Oct 2026 13:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB7136B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:27:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70D33140129
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:27:36 +0000 (UTC)
X-FDA: 85318284912.03.15437B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D8178140009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:27:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TDzXC/8V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791912454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPFavUKg/elaqUmt/6yrwjPSlADw013VHKQ/g+fF28w=;
	b=8fI6ox/mUq3RFNHaPdFsn4Zo+Gjl+LuG6qatjFNcEjPoyFw1w5lcSv2PNS6KkJ/XLYEqmH
	4iHBla8a0UAUHxIxxaCgZqbY2nFM1gm+mVX3zrQGGrSIl/jC50HGUbygBRJJfDUC25ajP3
	z9RXavEVnVrk4KBnTNltq0kBImZRvpU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TDzXC/8V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791912454;
	b=FNsN7rkziCXNc3n8fFW8rVINdlp4Tuy9FLXTbQtIPZbfkwN+b3AKtvZ5n6jz1XjultQF7g
	zOQfjPMAK4LlJlCwTRUcsBP7jaL9hadFhLmiP+u953EKRh7pPfFKHG8i5bVdroqQDMkF2O
	SnGLPvMeYxJ8r3YwNZzuaZWU4Z5w3JI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A28660A5A;
	Tue, 13 Oct 2026 17:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A1D1F0089D;
	Tue, 13 Oct 2026 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791912454;
	bh=YPFavUKg/elaqUmt/6yrwjPSlADw013VHKQ/g+fF28w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TDzXC/8VPxgfaNP4AsW2ASI3EDrr3YTRcseWQXnfjAJOZYzLiTtCLCLsMFJ8kdgjs
	 lOLEV7Vu4qNwNg8JT41fOaWiWyT3kuzIx4cJsW11nzbJi0f33DL2cFhnLM5GJa0FC0
	 tF5WXl7KjdVs8lp51p4LQ7HZmweMsg9YOHIcw1ntPf5uDyS8MQspxUmXeOZbAmAmQ8
	 1QiCaSxih1Hb9GmXRDbkAKkmgbIAmHI/o25B/9xtEZtJx98fgOta4NAW/Ya8T3jd9L
	 xRtsGpM5OETM5x6QPTYDM9XiTfK7Sy7bkYfTCYL5aUbacszaM147G1NygpjgYd/HvV
	 WR1+oicE2nxpg==
Date: Tue, 13 Oct 2026 20:27:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kaitao Cheng <kaitao.cheng@linux.dev>,
	Priyanshu Kumar <priyanshukumarpu@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] memblock: Remove unused exact nid allocation API
Message-ID: <as5p_av2Y0Hu70_2@kernel.org>
References: <20260919135327.74089-1-kaitao.cheng@linux.dev>
 <179188501773.4183299.8247277870365097333.b4-ty@b4>
 <35057B7F-9E89-447B-AF4F-92A78B45F8E2@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35057B7F-9E89-447B-AF4F-92A78B45F8E2@linux.dev>
X-Rspamd-Queue-Id: D8178140009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: n37a5z7if4xih7ep7pb6jyeaoyc9tdgx
X-HE-Tag: 1791912454-11210
X-HE-Meta: U2FsdGVkX19XmmJKxNSRk/gRHDWjo40C1FiEhH9ATse8wPva3Vi5rQq3267TGrAsawoycckJ3ET0qECI+xdxY5VhxBsemYN8ev88ToDa6B1PZ8xCLXalaq+VGqvNWXbtvN11zrJyzA/7i2hmvqc9OkLCaWSHYN4P664jTwmqE4ZbdK/GLpSexSKfwSy9ZfB2qaKlj7IyjFdDMOfHU8SECkAeN8m1ukegmVq+XkmHWlFvnkEBu5JwMle1RDFlhkswsMZQEMW0ubtSx6Y8/5KNDJ45W9Taf7Mi/nlSHD4IZ4xRKKlxcID3KAuA/rVvRFi/rht9q7I8cvxKpLo/RqxuFeKSQWai5SiBe/2UubS39J1gxd8q2+vcE/Rdpf9VGukB/qhilvdw4SSwzhSELueUDbpEeayBeFWtwyHC4WSbpeNBURwwAD96y3LABUP7XqkkKkp7UNwDFcmXVeTE1T7+VZ7sDXDGkhwyDQQLKGPpgB4LvtzE8NQgAU2ZxhtYS4eTtyVITLaOoORrQ3JY702MVhu8vj9014GT+DzHGsBi0ouOvL6/dsyIseIlytJx52yd54ZrqFJlw6xeUb1U2LXIA69JcUez9mqUySUWbVn4rFztmTAlyqLN7nDlFJdwNpTuJ6FD+PueJYKVldCAErnogZMvmAEgPd/sd3HvUNZmpTvIUyVS9pweKA8igzCv8yXHxHlxZeXvG2M5uP/+E4CfHg/j7yTnstaf0mXH4i3EeuPTDiO+WO1WiZn1WRsusOJ7hNId191g/yD48yzUjejvvdO3Z49JRhpT1XvsuZoeZ0+wLRQNu09rJxrOht4MNW5M1/g7htDTmAdMprOrO+fdtoDW1Wvcg3RwbVdL/FCylrYXINXhYxl22sjPPO6Xd/9LfaLnbiLUc6OMd0FzYGiM5tfnrYxMYFd1Mc2p8pGKWOKBPvgMuQyywoueLC0tP9YpjkSpPy5GHSCacfUkIEP
 hZxGm/Ab
 H0MkvmfTRtBLfL5j2OMl7rxVKU8BpRU9/Iadc8QUCz4RKcOCtMUaiAF8MstdIfShM0aEtlL7+kfFvIMuaLOK+rRabmeIF5qCRIiIMAktRCnc/c+A2jJegcXECZ+d0kvA9Gi3k2kny+4/zZ6VnB//9C1irx3n1nUCWkQyqeYyDKvWZ5Ujcn0xabAYdfU0BK+baOblc51zz7vXYA7ZL79esjx6bTO3ovqiiY/R6tMcYxNowug+G625TeLlibmnnKEXbdYFEDbevXxreh9QNxajSy5HOew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 06:06:49PM +0800, Muchun Song wrote:
> > On Oct 13, 2026, at 17:50, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > On Sat, 19 Sep 2026 21:53:24 +0800, Kaitao Cheng wrote:
> >> memblock: Remove unused exact nid allocation API
> >> 
> >> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
> >> mechanism") removed the only memmap_alloc() caller that requested an
> >> allocation from an exact NUMA node. All remaining callers allow fallback
> >> to other nodes, leaving the exact_nid argument unused.
> >> 
> >> [...]
> > 
> > Applied to for-next branch of memblock.git tree, thanks!
> > 
> > [1/3] mm: Remove unused exact_nid parameter from memmap_alloc()
> >      commit: 063b5e8bbd216c27e885f45e29e23d053aa565fc
> > [2/3] memblock tests: Move exact nid tests to memblock_alloc_range_nid()
> >      commit: fba3e86fb848f79c4573243affcd7d79d378958d
> > [3/3] memblock: Remove unused memblock_alloc_exact_nid_raw()
> >      commit: ea27be9f7ce90a05e779d20b60969ce2a9834f77
> > 
> > tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
> > branch: for-next
> 
> Hi Mike,
> 
> Just a heads-up, the tree has moved to:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock
> 
> Might want to update it next time.

Yep, thanks!
 
> Cheers,
> Muchun
> 
> > 
> > --
> > Sincerely yours,
> > Mike.
> > 
> > 
> 
> 

-- 
Sincerely yours,
Mike.

