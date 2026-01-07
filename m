Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CFEDD0D178
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAA506B0005; Wed,  7 Jan 2026 17:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B9F6B0093; Wed,  7 Jan 2026 17:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CC36B0095; Wed,  7 Jan 2026 17:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A2E346B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:18:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47C1FC202B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:18:47 +0000 (UTC)
X-FDA: 84306583494.14.D4BB149
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 68B6A160003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:18:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVZhRQgH;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767824325; a=rsa-sha256;
	cv=none;
	b=DZzZZNAn+64+GKunoaFhFR6T6HF/CK5/w+K9lX36e92zSru+Zw6mV2hXw7XfLTODam58Lp
	XONT0GQ0e4QHm6Gq9SqTaEBzdoEezX6WMNraQvg8w1Zsxz1cvijTocJ0DzzIZwtM2KAXJ8
	jkVcm03U2DgTKS4bGOiL7hVLXu/smqM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVZhRQgH;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767824325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyU0F2lenJeJKtDs77BG62YKEEOPysLnmo/uHstuMUU=;
	b=J/Y/g5fTQAEI681IL53A9LB8J6HOmp4ta31by6ZfneDefh8wGvmguIkxzpg9v+r/TZOlEW
	lAnXESlJPuazXtJYLc1/GwkttMdavjs4IbV5frzGEoA/MYMPYtr80CsCVF3Pd0oSMLOR9q
	UfWFdtlCYW6pS20HYrpmeaqFkqUkXis=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 625EC40ACC;
	Wed,  7 Jan 2026 22:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9176C4CEF1;
	Wed,  7 Jan 2026 22:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767824324;
	bh=KdSmcJ8/TbqJDKA+KiohOltt+WMWmZB4A/avr7C9dwU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dVZhRQgHuDJIGIg7EvZ3XelD0Qfr9oo2XXWqcGHPyrrPtyW3TfZaFfLtyYdPvBLVG
	 j1WFpfM8ryqsFh7rYijXsWjspzyckhUJ6cmJ/C5JF4c98VN1CKwbcGaP5Xv4e+zp5H
	 4NvVx2ZyOXeknhDsWgxG5xd60fzw/eZiwa165WiP2FP4nDqbAN0AuQtkCyc5dd5qfU
	 6CUp5ZLk13h5IIfUweXEhwJVqaPYFf7r63y0dqoIBo8gClms6lCDyvE6ukjBZdKasV
	 un91N7u1v7HiSjeXEgCXWOl6rP5tzrCokKbMkb0mkLut2hheRLpWzoG95uN5wC9bjz
	 NW+UF8w55kltw==
Message-ID: <d6f84476-e407-4d6b-a892-493c4359f86f@kernel.org>
Date: Wed, 7 Jan 2026 23:18:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 8/8] mm: folio_zero_user: cache neighbouring pages
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
 <20260107072009.1615991-9-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 68B6A160003
X-Rspam-User: 
X-Stat-Signature: bfnarzxy3pdk6s65bi5c51drq5p7xkoa
X-Rspamd-Server: rspam07
X-HE-Tag: 1767824325-555676
X-HE-Meta: U2FsdGVkX19dn1xg5JHGQLkTCsR0szXyJemelYtKNSnvcMlf5j9KRT9qvyZqoSvOhxFI0NA1A1xnDn1zA3c2dznZiT1vtcErJFDv3YCrPOZRGqcMZb2fj6na6+R3dAU3FqqALkwdpsjvxVeIGmjkKouaT/HgClx4oqCw+ak9px8sqCR21UY8Ply6n831Bm/5RDjY7Six4uRPRWwUI/FRr8hEPeB/S5P4Lo68ezovO9bVONkV8IpoiQaN9YOeS6bAVsH///lJqKuyXFrg5LxtkiAY6vKsCksSPR7xJcxXeoheZeBdFoeonVzdH524jIKumQgzcZ8mPfLvny7HCB2klgaf6CbR/e1qLdrFJ7grrZw9lhcCSMI8nKr9hLdvNgvAA68NnAo71tVTw9D9mtjKpDDShqu8dqVwg1sjAZqczjJXAJHvy7iUBE6U6a6ihPEx/TDFxE0syyqicm356+YE+8Yr+3+MCy+9PmuMwYOZ0phVllNcU2N/BnT1puf9pIF4ikwZbN0/EVhLFwDWOmyhoO4+LSmpkXocttudusNX/dxVQh1fWGLm0mF28cTKjUGiNQVIm+NjriUA82xjNHYjF2YskAp2IM7oZuWF0wtyExZhTUu9jTMNl/L76PzyW5bFG5ZdhUZJTPdCY4E9/8fQGIfmPPo2HHlKtcw35H7gp83QxzG3uXYt2BQrPQP2OQ8ji63kGbKOqM9BkYg6yNpuOcH3NpZ129M3oHtsdRSJW6BO925cPOOKFT9eJX6WxPEG/Z8tSl9dyl5rWKmFwcpgVGSD6/MESaKLUJt7d7sri3Yc+NLTw+CjswMWUuxc7pJkhTuXoGO8qZfpe2OiD0ZJTl4eyhlQMLFGjTSM31ses5lzhHplsywI8FKstQJuPtVPbPQkPZzHYd0+inZpcz920gxkzWV+qMsmNEHVttXVaF9Z5hbTagSCI5UehxQNJueAC+eS/w6gPP93vj+Z5Ip
 ssFK6qhJ
 XDf4ip+isTETEu3/DAjhuwM+ouE2Dt3swc228bzYifRBPqZUvul0dHGyg7pjuIm52R9tEnLhUjtlEUFbun8Zf1ceHaJKUlWMkxedMLP3X2P0PQ6V3Ua5S2IlSw8HS7cAhHMAC4yWpvKhd8HAmectWLg9YTNFNAsrtyW+9rwMDH12ilCH0kOUymOf5H3p5lct0Os34OCHMJKs3qvcLd2UKZ2jVfyTkV08gdLeizhW3gi4JH3+AwrserEG+AXLEtL2fOzLDv6MjQ8Wqjvt9At12g9p/YZZMrSQQmmIkzJ2vfyNSHbDvzLQehhTH8YKkQPotoocDM/lLhIWs01TAGijJMEQ9g3hTbh+oCfeykSTa3Vxe82YcE+kIvesJPY/QJUA2qvq8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 08:20, Ankur Arora wrote:
> folio_zero_user() does straight zeroing without caring about
> temporal locality for caches.
> 
> This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
> algorithm into a separate function") where we cleared a page at a
> time converging to the faulting page from the left and the right.
> 
> To retain limited temporal locality, split the clearing in three
> parts: the faulting page and its immediate neighbourhood, and the
> regions on its left and right. We clear the local neighbourhood last
> to maximize chances of it sticking around in the cache.
> 
> Performance
> ===
> 
> AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
>             memory=2.2 TB, L1d=16K/thread, L2=512K/thread, L3=2MB/thread)
> 
> vm-scalability/anon-w-seq-hugetlb: this workload runs with 384 processes
> (one for each CPU) each zeroing anonymously mapped hugetlb memory which
> is then accessed sequentially.
>                                  stime                utime
> 
>    discontiguous-page      1739.93 ( +- 6.15% )  1016.61 ( +- 4.75% )
>    contiguous-page         1853.70 ( +- 2.51% )  1187.13 ( +- 3.50% )
>    batched-pages           1756.75 ( +- 2.98% )  1133.32 ( +- 4.89% )
>    neighbourhood-last      1725.18 ( +- 4.59% )  1123.78 ( +- 7.38% )
> 
> Both stime and utime largely respond somewhat expectedly. There is a
> fair amount of run to run variation but the general trend is that the
> stime drops and utime increases. There are a few oddities, like
> contiguous-page performing very differently from batched-pages.
> 
> As such this is likely an uncommon pattern where we saturate the memory
> bandwidth (since all CPUs are running the test) and at the same time
> are cache constrained because we access the entire region.
> 
> Kernel make (make -j 12 bzImage):
> 
>                                stime                  utime
> 
>    discontiguous-page      199.29 ( +- 0.63% )   1431.67 ( +- .04% )
>    contiguous-page         193.76 ( +- 0.58% )   1433.60 ( +- .05% )
>    batched-pages           193.92 ( +- 0.76% )   1431.04 ( +- .08% )
>    neighbourhood-last      194.46 ( +- 0.68% )   1431.51 ( +- .06% )
> 
> For make the utime stays relatively flat with a fairly small (-2.4%)
> improvement in the stime.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---

Nothing jumped at me, thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

