Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C1AC44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5996B0093; Thu,  9 Jul 2026 03:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565F86B0095; Thu,  9 Jul 2026 03:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456E06B0096; Thu,  9 Jul 2026 03:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 218C06B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:22:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D051140407
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:22:49 +0000 (UTC)
X-FDA: 84968396058.13.BFC8F75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F27940008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:22:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vfkr0ESu;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783581768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zW25RGaPGwBbxFd+aS9kBW8b47epnczIHFRFBCLAYo=;
	b=zkpfL7UtdwqIHKDf61KPP861898+zH6/8wy5orY7MWPT6tV4GY5iKevEjcl9cPbPGrvezq
	su9j3zYbGAuEEgxzW9KNq1H2ZDIr4KQAmFtRdvdehvNZnaDDL8f+fbFVXwJeev6KLkrpwT
	qjbO2Ar3jsFtv+4VhyAs2pIIjkvDbxs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vfkr0ESu;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783581768;
	b=yLCNtH6mIR0k8aZQhtQF+gjqCra+U9xE0DSXnsfoZbKTrz4QbCN/DHv6/l4tEfCMWOZS8W
	Db4pwY+JE+2Sq6QRJsVuDKpGlu3cSAFZkyTBz4C+ONm9uvZWwTtkX2266nKnLNYbvTXSM8
	MujLe3/nMlZxDEnmtU+AN8X9fKYh2gU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B2146001A;
	Thu,  9 Jul 2026 07:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CE41F000E9;
	Thu,  9 Jul 2026 07:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783581767;
	bh=/zW25RGaPGwBbxFd+aS9kBW8b47epnczIHFRFBCLAYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vfkr0ESuoATXnPUkdBeq5+55sr7cVzSbt5ClCmVrSnQkJcQlnePuTOPN43DOTmXBB
	 YSlQfUnogVcP5QFkvu6bmLtwBljgujN7UWqTgrsBz/mE/apwSbu1SjJZF9FbAd9uHS
	 YN+nGemmSCwyGDh+062S5GniNn8bNOd+VlJTpc4Ev7w6aZ1qJeLKrrA3kf7DEhJXCs
	 NcIZY28KAhZuKKTdEjThKMco81MwWoZcwhDhzGMSYaZvrTkjXcV/6rn4gWFjtTemEr
	 iQZoNnClbYQXt0PJm8wXnjYh33q++mH230eCtmwWcF0M7UOxqN4QNmZ5IiHWpXSsJK
	 2uv9LvYoeHkhQ==
Date: Thu, 9 Jul 2026 10:22:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Alexander Potapenko <glider@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Marco Elver <elver@google.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	kasan-dev@googlegroups.com, kexec@lists.infradead.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm: split a couple of headers from internal.h
Message-ID: <ak9MO-FWjkgr22KL@kernel.org>
References: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F27940008
X-Stat-Signature: 681nx8hhncpuxxu6pexk14szx9rzgkjn
X-HE-Tag: 1783581767-944365
X-HE-Meta: U2FsdGVkX19d9/V1h39A0FXa68uOdcKO/OVVJ7FtumCp5L7XqV8GbTHxQD/F60lcVj4WzEReWBklYBWumoEkji7L2wJAJh7R0+1t/7/469WTgcyo4tAm+aX5CqqIWSIagrn8NOVBj6EXnFb8fQl/lgMwOR3PtBq6m1trpRJju0Hae2gjElLYtIzYtDbaaH1q9GoFaE4Cwwo8Mf97eyRHmjP+jTj1huj2Vs8qhNQc+vWoZdTcX5P5epEH3tK6fQfefxQ8QmSoG4VZAc9HFoGU9ly0Ca9xo6sJRbjNOOUgiezSiN4QKr9uoiXjzCbcoNMsXnbIKKflbQkHcF2loGifp8K0ib0FAjvzSx+fSIcZAR565B4Uszjdw+nuGLYRpKZ2MtH0H2V3vid7kMJ/D1jsuwR8H8ERBb9CouG4f0FEix273S+giquzD79YALXmQFRCXxdU1exZtSFEUndKL52+juBR7zkYlBgrjEEwicxsEfhgUbRjfmuF/GHHRCOPn6+oLdJqLb6QjFPqezWO4rx3j5IriY08dESgEM7KdWjuJ58yJuTHbWh+N0KN5+EsUleSWyEv9QfYao6bOD22OxDNdmmPKyLIAbYTNDOM53UqX6VFVUhPzx7xdAvZF04gAK7goThens1UqLf0oiJBv3qBCmGOHDBuOMyCB2u8uWqlWhqGQPkJhwNb9Z3GYNTwSMpRcVueKW0akFWyEhVMnjWnIj3cyBJxUQpdY6iWLlgZfpLSMeIunAfkGv0P5sujqViMu/PvwIy9soeoH9vNJtfVhnJiKPYNHraacx7lsQwloCywevpcra4cNgjaO/hjAJ6IlM8fqSCfNwCTcwbvVaAae8E0484MbgTGCmLjTlwtZGeDgyUM3uWjna8BWO0yo+v8OHMvG4w5CffH6OplL1oXt4aMmu0eMTYPzvuFEvD+OY/IJPmUtJeEEyV1TGQ6m1ZcpETeaerLV5jGnJoVPID
 hfesTsFw
 /KnEbyxe4I58VQfglUXvdr2BnqON+MYqaMkd+sTK7M1S2sFQdhiZjEzwDg8B8PsLYmzQEI/Ktq8eR7qFthtSOd2/Iz5g0sG+vlpJI5XjVSBXdN6BE7iFRreCIa96i91Zm+yBkpr51bxdzOxgMXYUS8apjiuSamhXAlD/pPmM5feoXSWAYRrdIJuq0pEZEBim8kAVeEFq2R6rf/x2cLq9TyfAOQVleA3Vi/kPLv/+WcDjVdl+04vUH0utBIMzu7VBt1xLF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 09:41:46AM +0300, Mike Rapoport (Microsoft) wrote:
> mm/internal.h becomes more and more bloated.
> 
> Split declarations related to mm_init, memblock, vmalloc and sparse into
> new headers.

Sashiko rightfully pointed to some issues, will send v2 later.
 
> ---
> Mike Rapoport (Microsoft) (3):
>       mm: split out mm_init and memblock declarations from internal.h
>       mm: split out sparse declarations from internal.h
>       mm: split out vmalloc declarations from internal.h
> 
>  MAINTAINERS                        |   3 +
>  kernel/liveupdate/kexec_handover.c |   3 +-
>  mm/cma.c                           |   1 +
>  mm/execmem.c                       |   1 +
>  mm/hugetlb.c                       |   1 +
>  mm/internal.h                      | 183 -------------------------------------
>  mm/kmsan/hooks.c                   |   1 +
>  mm/kmsan/shadow.c                  |   1 +
>  mm/memblock.c                      |   1 +
>  mm/memory_hotplug.c                |   1 +
>  mm/mm_init.c                       |   3 +
>  mm/mm_init.h                       | 120 ++++++++++++++++++++++++
>  mm/page_alloc.c                    |   1 +
>  mm/percpu-vm.c                     |   1 +
>  mm/sparse-vmemmap.c                |   2 +
>  mm/sparse.c                        |   2 +
>  mm/sparse.h                        |  63 +++++++++++++
>  mm/vmalloc.c                       |   1 +
>  mm/vmalloc.h                       |  46 ++++++++++
>  19 files changed, 251 insertions(+), 184 deletions(-)
> ---
> base-commit: 820d5dfede0cd55dcbc89ce96fcfbb11b7c457ba
> change-id: 20260707-internal-h-2efef660381d
> 
> --
> Sincerely yours,
> Mike.
> 

-- 
Sincerely yours,
Mike.

