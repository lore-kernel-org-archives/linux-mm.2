Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CC1CFCD0DA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0CE6B0135; Wed, 18 Mar 2026 04:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B819E6B0137; Wed, 18 Mar 2026 04:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97AC6B0138; Wed, 18 Mar 2026 04:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92A5A6B0135
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:46:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25387160579
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:46:47 +0000 (UTC)
X-FDA: 84558553254.04.E7135C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8CC1C1A0015
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:46:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nKx3Dple;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773823605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvyNpvBQUNpswfILIF0dxIUN11CIWZaCMurwCvfZj0c=;
	b=wlBptxR+qQ9bvpvih9tSDzThR9igXbahXlZtuuOlXV4Xoo7tnGfXHiNUCbD7SgmjvSmTa5
	pLeeAvSOMWFVSHeUCUfMN7YWkrCqBUHSdj/NEz+9rDrn945IPWvN8vCFIDAf7fsmYPI4rA
	hUI8C/cik4/43/s4cJI4BlNpt6oisR8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nKx3Dple;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773823605; a=rsa-sha256;
	cv=none;
	b=caMeR3YTK058i2dcyxjl+iZMhAjgnGX+O9l8roGcaTN5GCcSECwHRPQY+944VoiBMnJbbZ
	uyXvYAtZZg+TuUesFKWiTpq0YkRu9/a6T4vjKYIa1fWWaMJMR08i5BbAl81pzondNtvW00
	ZsO26bKFm0EDpR8S3iJjFW8Yan4Y+HI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D592260121;
	Wed, 18 Mar 2026 08:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F57DC19421;
	Wed, 18 Mar 2026 08:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773823604;
	bh=97R5iiUeYEFXhLUOgsr6q++vnxznhURgis+UaBmAhKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nKx3Dple/UoXmU9B44vuRKg2n12J+xrWeUdndz0FP9ot45QHACTNWVhtOPqpIHR4Q
	 UZliJ7Mwz0qTfwIhZYbbsvQ7xuM+Y8jLzVWW1gSfECkgRRsxFT/sEfmTzuV/AmklhB
	 A7/6CtDq49lJUettu1l2iCN+5BjoQECxl2buIvifyFncxbcP8+KVJsr0e5LmPxYvl1
	 qbMW6++oMyj6zHy1z13PtOJY964ZEjXRZVRGsfQkHhVDrjV0q7ZJGtVLFE+VzE09hF
	 hh2GAdPXFrt2tzCLKdysF9TMkIgH7NZv51t8kmITAl9G+iiRCm23Eu3xGxobx6vwaM
	 im6GwepqMujxA==
Date: Wed, 18 Mar 2026 10:46:38 +0200
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
Subject: Re: [PATCH 10/14] mm: prepare to move subsection_map_init() to
 mm/sparse-vmemmap.c
Message-ID: <abpmbj8mCZjt6NxB@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-11-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-11-david@kernel.org>
X-Rspamd-Queue-Id: 8CC1C1A0015
X-Stat-Signature: qm1zoit4jka4gfx7tqhhfsm8coy7do9g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773823605-118056
X-HE-Meta: U2FsdGVkX1/l4tAnBWMpspeXBq/J0MqNhSjM4f7IVGib1OjKdX0q+vWw9/HWNPQlrLcYkmGvZR8mZusnK9g53K+rkPtKdZBnp8ZIo/zajpzQL3VRbYeLzx4zMa1FkvME5ECB7/6naOCQyzqcQg15l2oePcQpaioI+xEdBaZsYnfobf57QkyYXfgICEtyrXdBQuMHlxWoVqIDWlfiWkly9HeSBMDkNvNCuRHKPf7oLMW1SBhLO+sIxGiz8s3sUzmjGmc/HubySzPDAZIzbkCgsIwXQI2Mm5NbkmSrasSSxfzNGo0LhPgve8aOWVYwWi/jpBHWSRLNF+7v6MirN7PnbtfGF8pbnZxiMLuapH89WH9RhHp3VeuJHq9SljNNlJ+X0TmoXOtUq6+w08blERoI+nWLO0JMaN5LAXfVRBrJSFDjQWjD2b3L547axdcaF9frjdN3EsndE7e9zvpT5UVRLKB2DPSyAGHeXDR+wEnXiq+sOf1peBsdkfzQb2jStySn+lB3tJ6dxT0XenrLlrFdzgeukev/6itEPferkmqrOTZ/Q1AFa2/b2D6lkFslumHCsqjwBY+iFw/HSKReyZFRLCsjzqitmPJGDNwd+Md1oqorBVFv26gTD5+tj9O38lSJiOtDBqsitz+X+q7Bmy3XY3C3LNuJpLs+2J0eE/G85l+FCUbmtq7gLkQSZ6L8dVs5wO+HnllHgpHqADATz0yyGl+Qq/zztWDdlEE2V4TK9cHHS31Pl054utO9ZqwkU7FEBRCC3C11/YSyF0V2E+Z8r0BAQxsGlJgpnmdHzd7xDM5pr1tSukXjm7RyI0+XIY/WGR7Nj4g7XcWghJtgEIqVdsV0Syppb3ITfPBvw5p2bhQlZFW209jPClct+rwitHOnKSL94CUd/reMMc/MfmfzHgL72y2k68tumWC8nSNet1stagHlQgv2aKY+Y0V1b3KzDjUjjcPa3KTYTZY7YZz
 54rTombK
 MaOTevLBTbA2QUAESuWMyGVBL1dYHjdS7Rk813rSvApGGyB8PVaxGSK/UXILKEs0Uu3ztl1wSRJb81WwpxfGJdS1nV3nPzLunDVu6QZHP0HSU3X+zodLq1SVtPSG1AwxcVioHGspdJJHl5GdD3b9E6QgDhXSt0/7OaUV84cL2Dp4ALvaAhpU2nSjPwGfRfomJELvXNCltoXMvl4hcPpBGsWyAiwhnsRCIkMjjwpYZVpZOONC1VabC9VCPJC8lxulnG6kkH+PBLQDAlIlr+/1mI2WWVhNGQM0lsgOZlB9Ls821IcaRnvoacX+i5LcGglj5DakkyDVZlyEBNFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:48PM +0100, David Hildenbrand (Arm) wrote:
> We want to move subsection_map_init() to mm/sparse-vmemmap.c.
> 
> To prepare for getting rid of subsection_map_init() in mm/sparse.c
> completely, use a static inline function for !CONFIG_SPARSEMEM_VMEMMAP.
> 
> While at it, move the declaration to internal.h and rename it to
> "sparse_init_subsection_map()".

Do we really need to rename it?

Maybe add a "global renaming patch on top, like

s/clear_subsection_map/subsection_map_clear/
s/fill_subsection_map/subsection_map_fill/

etc
 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mmzone.h |  3 ---
>  mm/internal.h          | 12 ++++++++++++
>  mm/mm_init.c           |  2 +-
>  mm/sparse.c            |  6 +-----
>  4 files changed, 14 insertions(+), 9 deletions(-)

-- 
Sincerely yours,
Mike.

