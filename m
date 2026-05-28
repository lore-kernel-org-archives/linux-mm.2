Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F04CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F336B0005; Thu, 28 May 2026 10:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F02B6B0092; Thu, 28 May 2026 10:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF286B0093; Thu, 28 May 2026 10:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2D96B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:02:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E016092862
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:02:10 +0000 (UTC)
X-FDA: 84816992820.04.7CB9CF7
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 90F97140008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:02:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=oIR5+rji;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779976928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWqHhRZrJdYq3LgBVddMXMAngLR9XNgV7phzSAMcWeM=;
	b=WE0qkKZKEUMi8wlQ3ZsoHkDPpYU+TxW1U0DRP2SgMQ5nA0vzMSFbt2wzsrHhywcjQ7cPwz
	uhB97HEaoYWdJgQsW5DPGvJ/E3B9tU69oIgCi8GxZbp+XnG1HYDRgTDyp46E+6CRjowvMB
	BB99zZ6fmHEnH7hNJ6sqBH7mfbuDz5c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=oIR5+rji;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779976928; a=rsa-sha256;
	cv=none;
	b=r8T/PUmBn+94icjkgWFVSm0nH89bqbP5OX3Z85DIx9jDKZOmAS07l7Ox1I00LIwsbSrAQ2
	vh0ozNoaU7n35grXTnDpq4ZpW1ctf5m/5lw/imAWi6MAfK6XWhIof8MwvTOkwvNqs5/eT7
	Do4eR1ZtF1DHXQJ1bH4CBNw/8lmP2c0=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51306c9f2e1so148788001cf.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 07:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779976927; x=1780581727; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VWqHhRZrJdYq3LgBVddMXMAngLR9XNgV7phzSAMcWeM=;
        b=oIR5+rjieekQicFxEHC+DuoyCmpL3G7VHLYntwsxIaSqgPVLCQtqKlUMlxtwwieSmg
         Ci3MojKXoRXsjbdyjmcQUluejhM9ecJBxVX/ioOUBt8YOnS5MS8EpRkVEdu67kXjJzYO
         85xk/hg7ozTokraklAVyPhOqJOx2TSMj9dOYCfjYbK2xLmbGto+zfedteHjQWWKkgs+M
         dHrMuX3q/3zeEc46u/4ztcqb5gczW25FH9WkZpyXWEfoNELft11bVNZQHk1bDHAEh47l
         YxrBWj57exk7V3eLjDObcd7bD6+RP5w5dA+jfbFYr6gJ9MwcAriTj/8LzPhyCEs2/c+D
         VE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779976927; x=1780581727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWqHhRZrJdYq3LgBVddMXMAngLR9XNgV7phzSAMcWeM=;
        b=WfqnEuip5ROJQxXKpVpg1a7O+WxPfB7QwaasBvgLJWw9nczleXAImhGqyIMmOk8E5C
         V5IxPFfuJMYQDm6AEpOtrldAQkEfzwLyJlGGFul0X9XUD5HoINeKlIas8GL8FdncqF/q
         fCKESDyVQg7Ssa00ZE/F+Hym0DUISLnoMz3T8vJKyr/8bauTpXh7XqEzmeYQDmEBVB9O
         zSh1DRZz6NcLQB23nKCiCyR/226w2T0KEzqYntZw9Y7yYnmA+sEg74o/QAj2bm/c2H7F
         M3RDjaI0w4jw5d8q/pgDenWntT1vD9/VHz1x/THausnR/yE+IsnSe3GuzV+B3vTDOCq0
         8rcw==
X-Forwarded-Encrypted: i=1; AFNElJ8xdk8Oywosnfhkkh/EX6QtyiB0QL1705J/97eObTqG6jPjg/1YNJA3lZcsDQU9yUXj8HRaGogIPQ==@kvack.org
X-Gm-Message-State: AOJu0YzBmZa0wAjCAxmgf/xgUmchR5ld2L0gOGsJIb+GU7QsPiU4A7+t
	7yMTf+203hLP06NCWB9w9IU4TtwidoSa7gw38erDqKVBHzf9TkqBm+OI2wcNs6jhtJg=
X-Gm-Gg: Acq92OHOUMxZ6l2utTcQbgkR7TrC2IQUnJYaMizSE+4pPAXRlvLgRXIuI2/scekrigS
	Es0dEnR4mIzIgaqIZgUuzq2J7MFuXA9FrTo/xyfWW0rx0UHP1Ua2eSLGIreSSHa/7SSDajF5jQP
	ePs/YAXrg/NmPWIILhENB7wZkLNbbtNLTf+rzxldTFP/mv3Tm+PtWBZRNzQJPYqTymGGJq6eFV8
	K2DAu/k+6YqH2gPC/KjSzZz4oBB37gSMzJXAXqgNdtoXFwazxTjqRJcz85OY0/yn51e1brR9q4P
	EyJGHlbEzLBRGIn2WeF4nrTpfEbkrnR6D3jvi1jeGX+UQ54HldjH++JjHHBrnoqSEh75VQPthV9
	E+H9LJYkTvfqKKibCGrRXX7ey0YXaenZFn/h8RWxnTWBS+c7hRSUgsB6GuhmqZDiPFw==
X-Received: by 2002:a05:622a:a6da:b0:50f:9c33:af18 with SMTP id d75a77b69052e-516d4428303mr295741211cf.51.1779976927300;
        Thu, 28 May 2026 07:02:07 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706b066e5sm72303461cf.26.2026.05.28.07.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 07:02:05 -0700 (PDT)
Date: Thu, 28 May 2026 10:02:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Message-ID: <ahhK3AKksNbJ4zbY@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-10-hannes@cmpxchg.org>
 <6f9c78b2-3846-4f75-bcc2-41bf91230513@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f9c78b2-3846-4f75-bcc2-41bf91230513@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90F97140008
X-Stat-Signature: r4qbawrorg56ythu68k9hucj5s1dnzrt
X-HE-Tag: 1779976928-535842
X-HE-Meta: U2FsdGVkX19joSCGdrMDNAKhwAMCB1i9n+/8ySOmbOTueD3GAoXXUx9+hCwHZIZKILsBdJVcjCSgGXhG1je5sqzUy6+nFUsG9h53ABobpUls89pku/LUk0bGfnG+bhoBRTITbKURU54YNTxFLwMEoro3Zs1C+PGSeYzGrCIgVRjDjugXT4FBHmcd/y+bWLIdlpSFemB9cYJ9uPQupjhbYssZ+4pK7cDfa6wM/4/TObZJAPNb54YqnOSRCcotag0SDO4/t0deHiQJKXd1YyRY7MXfgHep5+3Ez77K4w0I8jwQMsGrQ9pPvgqHtmKMmOP+nTh74tz2txBT5enZ0jaK9k3HWsv9dhpzYthDzJlNhIftisOF3BxWx3MNMiqHuUKSJgC89IjxkLz4exY+PeqC6DKeT8Xh8WeSCvzstcgmSxCViAp/6O8MmuqwF8+hzd8YAkZu2WAjS709Yvv2DUfl4h/+nJ8/LFrbK/6ayj97eHBO2twibB64gd0Y4lqNuxCfLVYCHCRpNNxpeS4px1pHNMcFA+Irsaf9ByMuc/q3iOYFVk7WYQycqEjEuot/oR2k/egzgKEmIMrl4KVsxdUlyv2n9w01OTs1+8Z7PaS3M7DuDWaqrEtlAxpmPmJGW/3n26o/FXamdHENNwzgrvUjZ/uI8JiRBSrxDu5e56lJlftR1r8IIZPMDoN5LXGlE57zRdh6rnpVgLIfLriwiQbcT6YfE4tuV1xZNPWhExrq7IZpZiW6v1wnupeutCpLLv6xUjEyANhzVjovqLlyUsoPnCT4HurNL2Y+UYmZT6K5vcKIepdVjfL0e5e65iOGDNn1HRytmHmnO5+dV8rp6svaz3/ptZEzOyr8I/5JWicpfEZhaQlAABp8jtdNt+fcXhh7dzubMMNZ/JkYppLY4wvfNtt1KwaoO7QapcH+Rq2D6xQa5olXsuSXQa07wXj+vxF9RZU6f3qPnIDqRYuyXRR
 PMKUCcyG
 DYWWhpvkGFsG4hle4UBA2vmt/qegOGFyMJdr7zKpeuls7Ir92yDLeq3C2y0No9unA3aJCX+CwND3hXM5LcLJl1pATsDh0JmZ0Y6X1opEpZIg2QDqokgeuJaTXkt6PJckMSpSbiCfsJXpCF5wQE4BCFAJ+VXCXBlzfzYFJO2Y8RWFNe30BlnkeQ3Iyk5Ijmuej641NTlOhKGI2ayCexztwF1oFf7UkD81pWLbWSrCdt033p5M7ERUFJd0O+v3ejPwfj9LfmhVbuPP/umFLOvRqO6I/5HDK7Byq2lD4x34+KsISW9GTvQuJc7oReJlrWPiu5usMrM2rdJE2YCFd+gTIb1RVqmwfVwAuIf/nxj1qKl2DbkAX2+eBrvcV+3FzK+g5KuyBnpNFDERRONIPCYNOjj+3tn5rrekB64pbwW2yetkYcWUWqKw922tURtALyB2OsIR4t7ECcDO6oH7qywlOQToh79P33AZX0SD6Pi1/VBW4E7uZsIDcBxNZfhmRBLZM1k6MBW9Qcz9k/rR1lUcNXoiA2wRO3tf3AF5G/qy2ZYTza+keDRUBCfJPeGwlYaieSHDyGDt+YiWrgmD+ZsnjU+aGS5zB1WmG16Ilkf4TW8Jqz50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 02:32:06PM +0100, Usama Arif wrote:
> 
> 
> On 27/05/2026 21:45, Johannes Weiner wrote:
> > The deferred split queue handles cgroups in a suboptimal fashion. The
> > queue is per-NUMA node or per-cgroup, not the intersection. That means
> > on a cgrouped system, a node-restricted allocation entering reclaim
> > can end up splitting large pages on other nodes:
> > 
> >         alloc/unmap
> >           deferred_split_folio()
> >             list_add_tail(memcg->split_queue)
> >             set_shrinker_bit(memcg, node, deferred_shrinker_id)
> > 
> >         for_each_zone_zonelist_nodemask(restricted_nodes)
> >           mem_cgroup_iter()
> >             shrink_slab(node, memcg)
> >               shrink_slab_memcg(node, memcg)
> >                 if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> >                   deferred_split_scan()
> >                     walks memcg->split_queue
> > 
> > The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> > has a single large page on the node of interest, all large pages owned
> > by that memcg, including those on other nodes, will be split.
> > 
> > list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> > streamlines a lot of the list operations and reclaim walks. It's used
> > widely by other major shrinkers already. Convert the deferred split
> > queue as well.
> > 
> > The list_lru per-memcg heads are instantiated on demand when the first
> > object of interest is allocated for a cgroup, by calling
> > folio_memcg_alloc_deferred(). Add calls to where splittable pages are
> > created: anon faults, swapin faults, khugepaged collapse.
> > 
> > These calls create all possible node heads for the cgroup at once, so
> > the migration code (between nodes) doesn't need any special care.
> > 
> > Reported-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> > Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  include/linux/huge_mm.h    |   7 +-
> >  include/linux/memcontrol.h |   4 -
> >  include/linux/mmzone.h     |  12 --
> >  mm/huge_memory.c           | 364 +++++++++++++------------------------
> >  mm/internal.h              |   2 +-
> >  mm/khugepaged.c            |   5 +
> >  mm/memcontrol.c            |  12 +-
> >  mm/memory.c                |   4 +
> >  mm/mm_init.c               |  15 --
> >  mm/swap_state.c            |  10 +
> >  10 files changed, 150 insertions(+), 285 deletions(-)
> > 
> 
> [...]
> 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 135f5c0f57bd..f22e61d8c8de 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5222,6 +5222,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
> >  			folio_put(folio);
> >  			goto next;
> >  		}
> > +		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> > +			folio_put(folio);
> 
> Ah sorry, should have caught this in the previous version, do we need
> 
> count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
> 
> here?

This isn't an allocation we expect to fail with any sort of routine
that we'd need to capture it in the event counter. It would warn in
dmesg if it did. But in practice it can't happen at all, since it's a
sub-costly-order slab allocation and the allocator would loop and OOM
kill stuff until it succeeds.

> or maybe we just goto next instead of goto fallback and trty next
> viable order?

Again I don't think it matters, but fallback seems a bit more correct
because the size of the list_lru allocation doesn't change with lower
orders (until we hit 0).

So I think we can just leave it as is.

