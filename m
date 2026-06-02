Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2464C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452BB6B03D8; Tue,  2 Jun 2026 04:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429A96B03DC; Tue,  2 Jun 2026 04:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318636B03DE; Tue,  2 Jun 2026 04:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 205586B03D8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:57:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D937492422
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:57:55 +0000 (UTC)
X-FDA: 84834370110.14.D4E4F4C
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id E83C510000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:57:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=utdJPp7u;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780390674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/m/AOq0MzWCa7qNuImbU6Sf3NfKogr80Anbl3dKp5VQ=;
	b=NZ8Z8/v6WBK380F8OEJ/WrB/ug58yapYK5TbUf3lxmdiSEJX4GjXWq0670Dl6RgogwmuyQ
	PSmw4HRZ1rNSJdPO5Ggj12lRJfTzVn9tcjy0parnjBjmtJyjE9VHr01c5NXbHVC2W2BM47
	bAdoF5Ka2UgvT7Pgq2c8aOyaxyj5DQM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=utdJPp7u;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780390674;
	b=kWU7TsZqxP3vxS1pEkH/U1xXGLle7y5sZ096+b4BkvZU06+AdVFcw8gjZbgbm//Fvw70V0
	2/wg7vLS6JJzDzBR+04khLmL0ZsKhnWYhwxK7TwYhlFdcdrpsg2cKEXNbY4zuul5lFHYvU
	ZW5xdHMxyK5ZYwEstLxGOWM0dF99heA=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso12005265e9.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 01:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780390672; x=1780995472; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/m/AOq0MzWCa7qNuImbU6Sf3NfKogr80Anbl3dKp5VQ=;
        b=utdJPp7u8DvEte8FroKDakJm5Qk/ORPVKs42t31FpKPpshBYISoFa/lF6JOkmJ2OS7
         AfqmtQE+6aUp7A7oXggOqk0N168H1kW37Odo1YotREenCXU16O2NRzz6BVfY4lMGEze3
         3cGC329syE+luTzuecz6/FwoGlZBGsQS1mFVpdZwviSwNe6qRAyZGpsIZeV1MtKxQ1fv
         dXwoTU61cR9fAmkJfbZ4xnn99LrmMkk42JWFZwQ4ndIq4FnlobVhbhXNHEFnQfxMS42Q
         +4KwRmqmLyNWEZzbj+oM9ELT2G5zTfV6QpHyI69lUSy+NHHAJ3AZc6R82VBwLJZxepaw
         cj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780390672; x=1780995472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/m/AOq0MzWCa7qNuImbU6Sf3NfKogr80Anbl3dKp5VQ=;
        b=MrIxTZTXF/Jj0S1PJhxk5eX96p/IWYeRLjAFaRlz8zqDTqHlbuFxQqmPz9ATeykS0O
         8M5isRInEMNyOEs/vXzI66kHeuacnfJwNrWPEpmM1GT1boI7JgGAwSWch8xWr1+tlAbY
         Qsqc17dHKEvy1YGIDF5lEu+Uo9l2a9zQn5ykfAxvHOhq7+tdMDta72pflt6vw/zd2Pjx
         nakYEewx7bE7z7EK/qOohXbvRF9mZsJTRvnFsy6SH3NQagPYvdfKpreYNbZaQX9ziAWr
         YoZ/JnVlKHCETmrOYjoWkhdxLLDVgpvK1TlhdQtMgoSuoDKL5lwRfgvnoLe1gr99MJtz
         gbYQ==
X-Forwarded-Encrypted: i=1; AFNElJ+VBZRZC9Y8+Pjm22MNuVa39r1GhnAabQE1SzlqHXHzIE/4m63HhFhs20PcPY3H5R1r3scfSyVGhw==@kvack.org
X-Gm-Message-State: AOJu0YwpiUnH+cQTXf2TlvZwxu9wac/HEQ+Kn4Nw+GEDArhZ98ZkSock
	DwoYHF/RMGqGZxv3ldC/Wk3ir9fb8hdp6A+5dGsfaGXxpFaJuuCTcIvPYHgcSExIllL/kWvgYOo
	whzarQQJG1Q==
X-Gm-Gg: Acq92OEtSaWm+7odW5udxZ+BljM+B7W4FTbM4hNXw6Ls5EMoUxqBQenOduoNdZEdJ8m
	KkwiF8supDgux9IKYachpg7NTbiRCk4UgTqkiAMW8DUklo8H3z7KAYfLNsPo6DYb/5WxH+5+Mrc
	io6PzounK3dsk7bDVjIbAVqAfeWXxzD4h2nDgwxhcUiivVFIk60g30HoqnOPAeijsYEASfFRDz1
	j+qTCpNre3ufpE+6cIfrMVqP8lEm9JrPBg6bXnSAhjVfKGvYpjAseR6cgnrbSlnzdP2MLWF5rja
	kjVYzCSsncziGZxslirTq6NlSMETtMjQMHfg0opDkNpGPYiZB+iaTK46UvEyUCn3zgFZ776Sd2C
	9mhRXGuXWZR5Bb/kMIgBh1ghn+UrxCTh2CEA3TATHPk/9T3qK0LGZP5t5C7ao5SqImSJL7obEZj
	k1+PNJle33tBk8vEpSi04owty62ZtnUZWhSrO05MsKKw==
X-Received: by 2002:a05:600c:a009:b0:490:ad8e:11bc with SMTP id 5b1f17b1804b1-490ad8e1279mr109459155e9.31.1780390672385;
        Tue, 02 Jun 2026 01:57:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:6dc9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354c682sm30647541f8f.23.2026.06.02.01.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 01:57:51 -0700 (PDT)
Date: Tue, 2 Jun 2026 09:57:48 +0100
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah47NNhuiClgGCdn@parvat>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E83C510000F
X-Stat-Signature: 9fc5iaz9wzonzg6yia6gonrg64qxcg1m
X-Rspam-User: 
X-HE-Tag: 1780390673-490534
X-HE-Meta: U2FsdGVkX18CDBTq2isI++hEhUFunthXFxRJAuqVmKK5dHCVa98aorLghYcnc68hUaQPdcbAImcP+VbebGpB4b5OIy3AQdAu6DzjYkK8qOtUtZojNULJx88vBqEomVMzPmiCvTKr5o5YknWiduyHwBkwlgTc3f5APv5I49rj01DYCxb/CcGAITLDQHKYk/F3bE1LJj1Wyg1kRJhc4CLNw3evpnyEAM+UD36AFWbzeFchI3RUUdehcsxiKOIyB01LIfLq8FFhE2q4HDxwx5Etp3QVzVtu0T3Ez+auohWyk5reM+zjuFZvxwheWSU/ecpKLGMKFlpPBUtjcNR2YLp+O0YBkbDFqcrAO0WLcrgupT6kSigq6oB9gsGUKxSmMWZKSLAwjd6pBh3m7CMVqFaSIojdpA8mL9TnkeZV43RhFxvP4NYhiNrFcHPejuroobtDYy5jVEI3tiioTLJSPYKHwaOq6X7/5Jup62V2NiPORxpWg9MQbgjOz8hl6G7KvylOx3BfMEMAFoDLyRPOe2rLcnRsyMuogfGWSU5wiu3eR1c+hM4zzM3CIQCiNnSJjoKqkOo0mvNXcY1/cSzPJq4Rco3NSHP0/rnwjLd8X8fGrPRN/Trz0ii+xgfs+RL9j4fH12mtSaMp3MCDfJJ+O5WR39DbIowYsbIapNacMlZDrs2UdL6hYLaMeTqFwMLCHaum4A96vBK3tGBhy9gZV+bk16g4IrBj8dZT+espOFd8OFnLdoP/yLUE7lNKthdmFdH4s6Fy6hfT7TsCGnYFKLZub8fB8q3jrLNb9e3KvGTcLSLwEHLf254tkxgOQ7NvFrAQATlOTYI6Y3GkhOgZ7a9PRv5FnPY9Qn2AW3nfinCrzg/kvBjKM7iWUAkCQXwqtJXC+vH38Uc9eNzz0jPCDmQ7tyKKdh6aJCW1VBF0IF4013/fwC1QMCFTcvgv9UysfnkmYK8S2sYdeGsTbHduVIh
 FzJdaLHI
 bXSlvMaZ3Bq0ZL9VtX24MX1m79J3hgSCuKzdQ4Meyym3S10AQ++UqUCEp3uUnnKoCFhjbhwMEokQbpK6SRfKXc5JoloJaKZpsGIF8vOUqZYr/YdzX2Tph8Y36h5YM3pRFcQbeRuolpx7n9U295O5l8d9UL0+u5Y/WsDZzsH7TMc4mKICEdFRPaoIDL1anatmmUMGvNgNPylkAqAuHivIMTDhLmKYMWo01G6G9dImdY94v1IozqXsvrX9cCNiNvhd4TOPQm5MkqIWT+PbGgpUsyMvpFGhB6Y5aB4+qcVEsAdAoa3hkmtq7FIZUNwX747hlWiAyOyWNj0Y6d4CjX84YdNJryiV+A+aL0lLpSRDJH2CIHL3P9wNUb3Oyd+mLivXZrUKQ1n2Hskg6DC0TNST33Gq6UQq7FMEpWmvg6WlWxWTGsd/tDjh4psH/LYYnALCP3q/g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 12:16:50PM +1000, Balbir Singh wrote:
> On Sun, May 24, 2026 at 09:50:06PM -0400, Gregory Price wrote:
> > 
> > I'm debating on whether to include OPS_MEMPOLICY in the initial version
> > if only because it's not intuitive how it interacts with pagecache. That
> > needs more time to bake.
> >
> 
> It makes sense to look at it and then decide if it makes sense.
>

I am thinking i will ship without any OPS flags at all for now and the
have the introduction of ops as a separate series.

> > alloc_pages_node() is the kernel interface
> 
> I was think we wouldn't need explicit flags and that allocations would
> happen from user space using __GFP_THISNODE to the node or via a nodemask
> based on nodes of interest. Is there a reason to add this flag, a system
> might have more than one source of N_MEMORY_PRIVATE?
> 

There's a few things to unpack here.  I discussed this many times on
list and at LSF, but to reiterate.

1) __GFP_THISNODE is insufficient to enforce isolation and otherwise
   not particularly useful.  Additionally, from userland, it's not
   something you can actually set.

   for node in possible_nodes:
       alloc_pages_node(private_node, __GFP_THISNODE)

   In fact it's the opposite semantic of what we want.
   THISNODE says: "Do not fallback back to OTHER nodes".

   The semantic we want is "Do not allow allocations from private
   nodes UNLESS we specifically request" (__GFP_PRIVATE).

   __GFP_THISNODE does not actually buy you anything here, AND it's
   worse, in the scenario where a private node makes its way into the
   preferred slot (via possible_nodes or some other nodemask), the
   allocator cannot fall back to a node it can access.

   __GFP_THISNODE cannot be overloaded to do anything useful here.

2) We're trying not to expose *ANY* userland APIs for this, at all.

   The ultimate goal here should be one of two things:

   1) fd = open(/dev/xxx, ...);
      mem = mmap(fd, ...);
      mem[0] = 0xDEADBEEF; /* Fault device page into page table */

      In this case, the driver is responsible for doing the
      alloc_pages_node() call.

   or

   2) mem = mmap(NULL, ..., ANON);
      mbind(mem, ..., private_node);
      mem[0] = 0xDEADBEEF; /* Fault device page into page table */

      in this case mempolicy.c is responsible for doing the
      alloc_pages_node() call via the _mpol() alloc variants.

Addition OPT flags (reclaim, compaction, whatever), would
(optionally) allow mm/ to operate on the device memory with, for
example, mmu_notifier callbacks to tell the device to invalidate
whatever it's caching about that page.

This would all be relatively transparent the userland, all userland
"knows" is that it's getting memory from a device (/dev/xxx) or a
node it's otherwise aware of hosting device memory somehow.

~Gregory

