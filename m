Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E454FCD0DC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45356B0132; Wed, 18 Mar 2026 04:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CC66B0133; Wed, 18 Mar 2026 04:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A306B0134; Wed, 18 Mar 2026 04:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B42FF6B0132
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:34:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 779641D32A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:34:12 +0000 (UTC)
X-FDA: 84558521544.18.B2D6350
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BE71F100015
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:34:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tx6xdKdn;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773822850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxGivEO5lpHkxDwooBgSQeam/H2t9SBwXtpsQFV20iE=;
	b=Jn7cVP2hCgQARlV9qF6KD498pHPQwUq//LaTqABYwYrpwzkwXetHCeDSG98ycSO6OEuLZq
	IZlbpmsjaxWvqNMumLoI+MVFYMSTrkIdO2xVQR2xmCnpCGWHYPtfdkCDYlVbPtU4NXcCmn
	pi22/yrn0h6aWqOEiovElTOkf1yaXYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773822850; a=rsa-sha256;
	cv=none;
	b=DSK8AoAms89F706Vbo1qrX5rdQXvtgpnIDXKduQqXjGEDl+WnruWoSu2p3cwF2SwFvjcmB
	iFKSmS4kBj/jZvJey8/VXYATeShC84QJC6gUGw2cA2rhh1Q2K6F0RVm4w+cbJ4TEvCEJ1w
	rRfUsX0Vpk4ijjun/0UoRJWKDAgk1G4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tx6xdKdn;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFAB14036A;
	Wed, 18 Mar 2026 08:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261AFC19421;
	Wed, 18 Mar 2026 08:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773822849;
	bh=ZzFleRXrNFkpynaqPdY/YosKojmZPLThpwZ+pBJV9FE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tx6xdKdntAjvd7zE1xx0i/755mKqecG8zfCeb9yA6qg4bILeyQ/h0kUS2/5MwMpbS
	 nF8Bu6Jk1u8LDaZoODu9BxV0GCpYF9N3g5DvU9gZR9NPcOorLdNDqr7kbMqnWiea7w
	 BFzvbSdhNsD/8a51s5GiNRNiUKeI3EUO49KHTptG1brdZ+2wbEOGP24kJegQj9G+ZZ
	 e5FdJsHN/EAubdH3Pd3z5UwnADXx7X4136xXfg+ZnugM9ZaLqwIZzweuMdgoNeKBD2
	 Hs9NqodI6fPKRQp6WVzzrb3dmiS7eoryorSfPN+PO8XpHTySird+IyC/CyTAbXSi3m
	 KT21E8nwgxgBQ==
Date: Wed, 18 Mar 2026 10:34:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 09/14] mm/sparse: remove CONFIG_MEMORY_HOTPLUG-specific
 usemap allocation handling
Message-ID: <abpjeswfbBeDi6e6@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-10-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-10-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: etkiqr75ktn6whuq519ne8iw16it5czm
X-Rspamd-Queue-Id: BE71F100015
X-Rspamd-Server: rspam03
X-HE-Tag: 1773822850-891305
X-HE-Meta: U2FsdGVkX19KtyLZW4kcHYtHVQK4r3oJ4s0+WtgVMRjU/z8aLPUgOS/aPb9cqb4gy2PTmX1YE/YAbw5ei7dTcMKTHWGMst5imF0Gc4bfrgDqaypH3WT2MUsUgnNCterhe5vkxpJ2nR9TbldF7jqrciRKrx9UQgpKKPt7ZwKnMP3JPWFIE2uhkp6Aj5gnlpffqaqM+Qw1XsaeBAe1F745Lq0P00H8RgYZrtFK4RSPMkz5stFkLs+v/nsjhtLTZTWKbdvDKw8EPoqh+3fF5Y9dr5qlDummoZDB2x0QjUC55F84nsRhLt0aJnFSnK6EVphwU1eihus5mzTiCVJsHJObF/WJgNSz+qqwpzFNxzSTZVOOqnjE0h5VQ1Pcr2FZII/qtX10qX/MBDzg3ZRWcz5JPzy2QY89nnqk+45HWi/PweOfYKL/KGazp0o6ocrXZHzFoRvWcRX+G2vbKdBEuq7ytWuBrm1F0w6tKPHnoCbwHeTyLabC0jOFgM0Jlq16bx+xwfJQhwZpr4+x8oDK2+na/K6uuWU5flOKv8UH0/qaXkmgK7q3dicKBKDjKJ2kClI3l1xuicadTNOCCwPhSUTKnZAbZl6vPisr+OeFf/cwBYVI10hH5rgNMELBwY8aAROgXR9Q3KaNPhy7WKIoRCqO1Xgyk3SUxtGsRYU73Pw/+/qtbuTcUT/FTB3BoMzTUVXPjmHPYjuqS8XxU/7nVJVM3FTB5R3vw9DRdiob7Gpa4gmsMnyEE/MtAyXAPKZKPpd1NeXLUdadCIlvmmRuxbIbQ9fqrubdEkdRX+6PMroSp7k3+NF8sueCZs8t4geLy2eEOMVd2tydpLLXTM1ixF/rjHw/n6vRC2mq59ca+gvkgSGuABultU0wqFySa3jFUZRfkBhXk+dxqEYmZzFpHRQYSGJwLjxa8wKkH4RVAEQ4f/L2o3ifYphSSSlZYh1jae/lK7I/YmoXHxkZeVP2Utb
 FSjMLcua
 6mSUT4OWQyboULo++vx32Vqx3yoji0fw/CaLpZovG2063bkyInH1Mrfg5P0m8znaD2Z1LoGrgYJvIVZwwTl0E6/olh3JEIzvM1hWSDUGT0+Zcf7Q2VWUwrajmtLJZYd1Qvh3v4dWTbeFdRJ/Dx+PTEffvfh9zVpVUmLCiyi7kF4kxYZHzbj2JQIqR36N4A3JenCrjixaw3gAFseOQigqh1DRMTcRrdwe+IoveqZvYa2bU+zaUqgqo3IwA3kdNLck9mzXaKBUn0qSghr/b6pooHNiSey/HaO0s25WUmlcoOA13JVPJyOLZ/K//SAmODn+crbv/SyzdJYDxjQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:47PM +0100, David Hildenbrand (Arm) wrote:
> In 2008, we added through commit 48c906823f39 ("memory hotplug: allocate
> usemap on the section with pgdat") quite some complexity to try
> allocating memory for the "usemap" (storing pageblock information
> per memory section) for a memory section close to the memory of the
> "pgdat" of the node.
> 
> The goal was to make memory hotunplug of boot memory more likely to
> succeed. That commit also added some checks for circular dependencies
> between two memory sections, whereby two memory sections would contain
> each others usemap, turning bot memory sections un-removable.

                            ^ typo: boot
> 
> However, in 2010, commit a4322e1bad91 ("sparsemem: Put usemap for one node
> together") started allocating the usemap for multiple memory
> sections on the same node in one chunk, effectively grouping all usemap
> allocations of the same node in a single memblock allocation.
> 
> We don't really give guarantees about memory hotunplug of boot memory, and
> with the change in 2010, it is pretty much impossible in practice to get
> any circular dependencies.
> 
> commit 48c906823f39 ("memory hotplug: allocate usemap on the section with
> pgdat") also added the comment:
> 
> 	"Similarly, a pgdat can prevent a section being removed. If
> 	 section A contains a pgdat and section B
> 	 contains the usemap, both sections become inter-dependent."
> 
> Given that we don't free the pgdat anymore, that comment (and handling)
> does not apply.
> 
> So let's simply remove this complexity.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/sparse.c | 100 +---------------------------------------------------
>  1 file changed, 1 insertion(+), 99 deletions(-)

-- 
Sincerely yours,
Mike.

