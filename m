Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B08CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83B56B0005; Thu, 11 Jun 2026 12:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5BAB6B0088; Thu, 11 Jun 2026 12:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71926B0093; Thu, 11 Jun 2026 12:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC2446B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:01:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C6FF40742
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:01:11 +0000 (UTC)
X-FDA: 84868095942.16.C60C106
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 24C2420004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:01:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Agon439w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781193669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwWE4lbKK0T3ZfG4RSM1mqAP2yW+nfdYO3kCAr+3V9g=;
	b=dRLwhGlB9UVItN1phjrCNAm62HufoTNVWJP05+iVO+Wrc97rq54fhDG7CyQIWFLPU1eRXW
	Uunj1500JVzcsfbDLS36TCOo0g6iwCUsiKmeJyU41lgv3JKzumKJhaTl1QWqrvP6+ImI10
	O5wfSPZSxam0Po6JFLnml9FDu2YsgsY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Agon439w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781193669;
	b=6eEjQH2Quz44URLQQhy6XF6oOL8wVHLLBgLNYGdg21ejl4bGEKrvTmpAmRCoO690J+icR8
	6cw0qgC5nIAzd5GbBK94Edt9AFd/3+617Zhg2k3ySKnCD6R9rag6IEsC1ZLFamXoAfzFU5
	4Ruc4Vs5o/YvjSBAQb65dGctGJjrAu0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8CD943F51;
	Thu, 11 Jun 2026 16:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7491F00893;
	Thu, 11 Jun 2026 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781193667;
	bh=OwWE4lbKK0T3ZfG4RSM1mqAP2yW+nfdYO3kCAr+3V9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Agon439wUBrQ/uonepv6QEQHD/Z6m9RS5Xb1WWxv0Q0wtFCqyeaUMDuH0YQ8F7h0k
	 poSBPrZ26U6e7yClapl80sHwPywpSo1ut24RqLlXqmKw9hqFEnVKp4lveByc+2vqB3
	 EclGyTzkzaf/JuT0Y3YBNKGWeKbjVkE7GFozcXEUaXdNNGcdC3plff9fkmEzUEr8SF
	 yLRHAf/w30nkrr5M5sh+jsu8VOfRlN45yDsLJie0TAMYvIFEMuSK4TFwnyZ712ahH2
	 NhS25Ts0oai4t03guxudm8WtA2u3sbx6tJpv0YIWL+aZL2eWXqKdHCQGfxrg1QzJzC
	 +XiDkTpLLoHog==
Date: Thu, 11 Jun 2026 17:00:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Huang Shijie <huangsj@hygon.cn>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, mjguzik@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	shakeel.butt@linux.dev, rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, linux@armlinux.org.uk, dinguyen@kernel.org, 
	schuster.simon@siemens-energy.com, James.Bottomley@hansenpartnership.com, deller@gmx.de, 
	djbw@kernel.org, willy@infradead.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	james.clark@linaro.org, mhiramat@kernel.org, oleg@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, jannh@google.com, pfalcato@suse.de, riel@surriel.com, 
	harry@kernel.org, will@kernel.org, brian.ruley@gehealthcare.com, 
	rmk+kernel@armlinux.org.uk, dave.anglin@bell.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH v2 0/4] mm: split the file's i_mmap tree for NUMA
Message-ID: <airY5q_SspdbQDbi@lucifer>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611061915.2354307-1-huangsj@hygon.cn>
X-Rspamd-Queue-Id: 24C2420004
X-Rspam-User: 
X-Stat-Signature: 93nz6ortwa131tnysptfdt6uhhpb1cog
X-Rspamd-Server: rspam09
X-HE-Tag: 1781193668-687032
X-HE-Meta: U2FsdGVkX193OU7bKgaF9djs9rJxokmFOSiFP7pL35jMIfAwIYhh2jDU+aIvX9CBg9hutlzdDZ4vTGsHzgyVP9U7Gv9iHXPGhKZe6iZaZtZWkkhP6B2qJl/ENBVTV4zUUjpObJhD6hB+G+Z4SsPo1LXVoDpC+3AJO2ks+/utVUURR0/KdF9H4+PcMsR5gVKI8aQstZmwQcZsheCBnmq/gHnTk4w3JwIxN8s0qhmxT8LuM/Hgjrhbwv4Rbm/7PRzi5J7d1LUCnUe4hNd2pPO3yguQzsFpyr6rVhCYkz5Gs/KQR4H5LBisNgDF0nYaCQQ8ZTYEjy0S9CktaSJOX6FmcMBhLMs/DWqQut6pleB6+lYoPzUCcVlLZztyqJ2Hcj7v3yuk15bHN8MbRreQD0TPp1HtstanC05uu7ZUx5+TaWNJ/ywgApQtO3Wr3pkm35P+vixOW5GUhcI+k29pmmTX6AcD+liPlH7rx3FcWM/NXNvhUURFjOnsb5v5djJRYuR4crrh4tLzGDX2qMTEDGmjZAji1+RNSA621maWNXxz1eBtSeJVyIrqLFCSOmW/1YhiluRv6eVUube9E4mHwLezSM0/f5s2HS4nhdTn3tEF7i6LoUfniRRXu0tPFCZ6MKJEx+N14AOETVolZOA/mRkqUl4i0gMcwwkUF7xuoQ8hl/11Po062Ilc+fmGT5g5SH6TxmwPTGJ8koFgJ+twjRGXgfEZma0QzIK/5pUOqB8ewefMb/3LjdLE/avI51v1g7TYeS2EoCWgshij+3Gq+MHjtfk6OWcT+WsP924bsZpdRsNmWacQBZAF7/fFPsg2w+gZg38o6U7HEuL3uQ8jo8S/4wMzzTDNwWDDPknQgfRVgYTY80IzNVR4pJ2P9BUiFTmLcRSbT/sBfsEEe2cwijQpzQSGUpcMQH83sFY4jhYkCNhilRl4rCVbLSB8W/i28y00DhBjKTOicwynXog/Mt+
 hjAyHNhd
 T5WCS31dlmlsz5Ethhrg8+2EtDOYSqZY/nmRANC1HiepDEIboZJaW7uUvTAsnbUq4hSR8DzI5mQzzbs9TJdrS3HXFxHZMI+xEuhA4dU/eCLJDj9gSGZ6rOgmnKlKBg6Sy9sIlzq0QV4Xs+90Vw6lFRWxKPQbbwpARgq5Xn/fnjezKFAM3ohG7lag9gF2V9YypJ2Q0rNYvSosY9bJSBdJoeqDLwrHa1o0qpcwMTGO7y2MJt0sRMCCota3/VgN3PmCFtpOxk/pHJn6wIcB6xmnGO2D7hRuAm/T9ug8JJXCWz4UK80Pje94OFgoikIZ5+wbZc0R/S4ehRfPlGR9xARbpnUZctfT2e7YzRSLFBmVFRKoG82tYosiacxOxoaGi/mFIEG5qjMcX93WhOg8CxB7wFDzY7Qja2vKSrQvDF3MQwJ8HHjNGo206m2JPsCU75LJjd1M1xQ9Vd8hk13heXp57i+8dwPxZ5Wd+ADNG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huang,

You seem to be replacing the file rmap altogether here, so you really ought
to have sent this as an RFC so we could discuss it as a community first.

Especially so as Pedro had publicly mentioned his plans to implement
something similar here, so coordination would have been appreciated.

Anyway, as Pedro has pointed out, the code is overly complicated, it's far
too configurable (not always a good thing), and the locking implementation
is questionable.

You seem to be adding a whole bunch of open-coded complexity too, which is
not something we want. Abstraction is key for the rmap.

You're also not adding any kdoc comments or really many comments at all,
and you've not added any tests (though perhaps it's difficult given how
core this is).

So I would suggest that perhaps any respin should be sent as an RFC so we
can engage in that conversation and ensure we're all on the same page?

Especially since Pedro plans to send an alternative, simpler, solution I
believe.

It's also not helpful that you haven't examined the non-NUMA case :)
perhaps your particular server behaves a certain way that this approach
aids, but regresses other NUMA configurations?

We'd really need to be sure of this before accepting invasive changes like
this.

Thanks, Lorenzo

On Thu, Jun 11, 2026 at 02:18:56PM +0800, Huang Shijie wrote:
>   In NUMA, there are maybe many NUMA nodes and many CPUs.
> For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> In the UnixBench tests, there is a test "execl" which tests
> the execve system call.
>
>   When we test our server with "./Run -c 384 execl",
> the test result is not good enough. The i_mmap locks contended heavily on
> "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have
> over 6000 VMAs, all the VMAs can be in different NUMA mode.
> The insert/remove operations do not run quickly enough.

You really need to send detailed, statistically valid numbers across
different NUMA configurations for changes like this to be considered.

>
> patch 1 & patch 2 are try to hide the direct access of i_mmap.
> patch 3 splits the i_mmap into sibling trees, each tree has separate lock,
> and we can get better performance with this patch set in our NUMA server:
>     we can get over 400% performance improvement.
>
> I did not test the non-NUMA case, since I do not have such server.

Yeah this isn't a great thing to hear :) you need to demonstrate this
doesn't regress non-NUMA machines or NUMA machines of a different
configuration.

>
> v1 --> v2:
> 	Not only split the immap tree, but also split the lock.
> 	v1 : https://lkml.org/lkml/2026/4/13/199
>
> Huang Shijie (4):
>   mm: use mapping_mapped to simplify the code
>   mm: use get_i_mmap_root to access the file's i_mmap
>   mm/fs: split the file's i_mmap tree
>   docs/mm: update document for split i_mmap tree
>
>  Documentation/mm/process_addrs.rst |  63 +++++++---
>  arch/arm/mm/fault-armv.c           |   3 +-
>  arch/arm/mm/flush.c                |   3 +-
>  arch/nios2/mm/cacheflush.c         |   3 +-
>  arch/parisc/kernel/cache.c         |   4 +-
>  fs/Kconfig                         |   8 ++
>  fs/dax.c                           |   3 +-
>  fs/hugetlbfs/inode.c               |  30 +++--
>  fs/inode.c                         |  75 +++++++++++-
>  include/linux/fs.h                 | 179 ++++++++++++++++++++++++++++-
>  include/linux/mm.h                 |  81 +++++++++++++
>  include/linux/mm_types.h           |   3 +
>  kernel/events/uprobes.c            |   3 +-
>  mm/hugetlb.c                       |   7 +-
>  mm/internal.h                      |   3 +-
>  mm/khugepaged.c                    |   6 +-
>  mm/memory-failure.c                |   8 +-
>  mm/memory.c                        |   8 +-
>  mm/mmap.c                          |  11 +-
>  mm/nommu.c                         |  28 +++--
>  mm/pagewalk.c                      |   4 +-
>  mm/rmap.c                          |   2 +-
>  mm/vma.c                           |  74 +++++++++---
>  mm/vma_init.c                      |   3 +
>  24 files changed, 534 insertions(+), 78 deletions(-)

This is a _lot_ of changes you're making here. It therefore feels like the
abstraction is broken somewhat?

>
> --
> 2.53.0
>
>

Thanks, Lorenzo

