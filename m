Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B23C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00096B0092; Thu,  9 Jul 2026 06:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61E46B0095; Thu,  9 Jul 2026 06:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977816B009B; Thu,  9 Jul 2026 06:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7456E6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:10:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0421A140422
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:10:07 +0000 (UTC)
X-FDA: 84968817696.09.E0EEAC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 53E6180008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:10:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfJR8DV3;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591806;
	b=q0VcWuUW/pXP7KwSPTMPlbD+X9YMVzNb6U8DvH8flaI65I05CkPUSXaNHopghXXaqdTBFG
	0tp2+KEiEiEWoiNAnc+e6v6dw/X6Qk6whcoVuyGXveAfgmCn7BaFQSmiTNn174btEdrmkk
	JVvcviDTmTUqITLdVNCibT56nY934a0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfJR8DV3;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62Xp9uenJbWFCQ1zJ3m5mkBRivtDvPiXDOuu4/GkIx8=;
	b=SdylpJ5rON+2IdwYfYt4IZpmx4unfoz6uvw/s4kZQP8UHcqcTSpESjqAnB/rHE59vYE7Xv
	KxdSRK4xoenPEFMKSTf/e0PZqEpwLVzjzMGTHeoGrJjBHIXMTpVh30owIDxbbh31vCrz5a
	28EOAlYeOd2tKf36W0B/1iTUwNpJYV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D09FE6111A;
	Thu,  9 Jul 2026 10:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452041F000E9;
	Thu,  9 Jul 2026 10:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783591805;
	bh=62Xp9uenJbWFCQ1zJ3m5mkBRivtDvPiXDOuu4/GkIx8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LfJR8DV3LYnN+5gzBj0atwXuJVwLFDJcyHGUFiHu62k+FqO0RhRNvNCnFiVHfQ2c0
	 eahWL9aq2q5M1+Lo3F/7flwAAMOIJe/0FWe9q0WpKnGC+kz5Hs/RYHmwJewFB8vPlU
	 Cx6rA1JiGR1210ORhlqBSZ+Jz1n4nsdIEF/ildxWVXiz1i9ij/gD/+5g8vx98LwXWJ
	 KNEpduf3tpmwOibv/sUCnM9nJ/62bIVgZzVOr1gWw8P6WTGlDrHcw36X9QRtunuBJ7
	 eNi0im4S0Hl6hDS1YiUFfgjqgqxwYkAMtl3SYwSCnWayPACRF/qpUG6ckmn5IrpGCa
	 6zTFNO/+RQXzA==
Message-ID: <0970fec0-5c18-41e1-b63d-029c7a8354ee@kernel.org>
Date: Thu, 9 Jul 2026 12:09:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: split a couple of headers from internal.h
Content-Language: en-US
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Alexander Potapenko
 <glider@google.com>, Brendan Jackman <jackmanb@google.com>,
 Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
 Dmitry Vyukov <dvyukov@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>,
 kasan-dev@googlegroups.com, kexec@lists.infradead.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260709-internal-h-v2-0-695631425968@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260709-internal-h-v2-0-695631425968@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53E6180008
X-Stat-Signature: 663366e7jd4exfhjsrtzi6pm8ix5zpni
X-HE-Tag: 1783591806-245782
X-HE-Meta: U2FsdGVkX19iszF+COaTNjCE8tduW/fV+XgM4B1arfX6+Ftt34vynYMbO4fRFVVOt/lVCcIyQIL9o/obWl2LjIbETIexS7SQIto05Ou3jLru6iGeW+/XXQP1bgeMl/hV6TMWx87l7LBYP4hJaYIrNkQ06tJ+2U3+pAaMkrCs7lt5GocPcV/WtNSGBg0Lxn2a2EOxtZKUfQeDXGwb3tVaER1Pk1GLJ0VHgyJ1aTTdhmoZgXOJMau4NvqZJNyPfCbNZw/51oaV9nfm4Hbz5hcrpIQXHqLF6ajReoNHEpUV5YSdpXypqwqjPQWXBOgp8fNxso+828pKvisx7ajul8jRZa6wgY552au7zdrDF5m1W7U2X5osRPrQpHbYWlJhrTNH5Hzf9FmisDM1aQV6ow+wubF+STPlgyHlujsfy/ZVT8QE4CkR48RT6W5RMicqNlm3cGsv1sBczWkoXNilHz9PycS3lGEUDvazUoflkb2jw9fQ/GzahmBb30zdUAD3l2UQLj9W9uvHbyQ//d8EmgVMH4FV+wgx+zYvcAnQUBHICiPnH5ZScP7ATo2yY/4f54bp7iPBaKrL38xt9EQiL5bbAt32TQ9im8EFfkne5P5RB2bQk9Jf4utN+3YuRi//yf8ykTKh5399QZ8MSuOeXKojdbmujN7GUilupXfaTg+nVq2H+3GdLc6YvuWbI9LW/BGESZcSzfriChGsORYnv7gTDneLkvtBcb8i3ocEVoih1DuLoWOl7BeLjd0yeUmemOPYqp7ESjIpwkvyamNooczsjJA/PVtzQL+QcpnrxtxcM0mCwrixkRdFFvsHCiVZLychUHYGU82JMTvVfELs3riqEer6Sq1pqAeHfFM/DFOnDclS6HIlF13os3BP3TG8gdnSKiDXz9ch13V5S+eyBzlj7IK2nAN5Vj0E7DPqSeLvtFDO9+Ia2l5dTj0XScOnn/qL2bbHDESodlmeYTFnzig
 6V7JVds1
 DEgGGaSpOkCT1kEIcXhZUTGLTx32KrLNnU6QRCb/PMPxN5I+uiCX7aCWeVrrtqZkK1gWImy6Z7cd17DVHPDOukVPUdz1CHNupPOCK43aqbGksamve0UiHuAAwwT6eVu0CDkeOP7qiq5gCk8+bNxK/iQv/aH34k6NJTZ4m/3DbjIMfsqs8iOl9oJzG1GdR344D4TWy3W10DzAJIA1xFpW1pxgerQCIr/lSACPTGhgsD950s6mQhs8PeRBpIdeTsDJC5OeRkQpgrqgaPHmL5799GGcWWBv9QfglYQMh5M/04LYeXALCrxGzXHn/WJNvPbNuA/ki85yuZfqiVmcOHTti7iMl/ZEPVUGo53xLkZ8E0GSOdGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 12:00, Mike Rapoport (Microsoft) wrote:
> mm/internal.h becomes more and more bloated.
> 
> Split declarations related to mm_init, memblock, vmalloc and sparse into
> new headers.
> 
> ---
> v2 changes:
> * fix fallouts of rebase fixups of checkpatch warnings
> 
> v1: https://patch.msgid.link/20260709-internal-h-v1-0-956d5092782d@kernel.org
> 
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

Sounds good

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> base-commit: 59e34180e138a293260301c139cf7ee800978533
> change-id: 20260707-internal-h-2efef660381d
> 
> --
> Sincerely yours,
> Mike.
> 


