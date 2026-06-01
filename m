Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6FCCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F29B6B029E; Mon,  1 Jun 2026 03:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CC26B029F; Mon,  1 Jun 2026 03:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D2E6B02A0; Mon,  1 Jun 2026 03:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCAEB6B029E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:34:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 545C98F1D4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:34:51 +0000 (UTC)
X-FDA: 84830531982.29.BDF9B53
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 600ED1C0003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:34:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PEsjYe9x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780299289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UntsdzuqpdttstMyOLOIQLL5ljvbyDCzLnXwa0e2org=;
	b=0AefLWxK6Pc/GTS1nDK7OSXUpFywuv0mHDQXaX3uTVKLvrYh6N0v9/4KJUBl6yJbmnShvl
	ha97kfNSVvji2LP+A7HBq9aasfbitjq7ELCCFbAw2ZxYnyLj/3JvC6O4UvRYDHPACdMDIN
	Su/hrBbK7/tuXYiMaQxMV2qIKssG/Sk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PEsjYe9x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780299289; a=rsa-sha256;
	cv=none;
	b=gyJHmmucqvStbRkGXxJaMmYK60tHqUaoXePAOC09x0Us7qPMQlP5RI61gIUT9J3Mrg9yqR
	tnzVRxGbU3SRVp0J623ge9xCNOvVo2o01LyxcpOK7mRw9qTb1Atktc6F35zZmAvlsHe3L7
	X6566WaT8vA18Moy8hJDQBG3+J+60sk=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2bf125989f2so23834895ad.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 00:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780299288; x=1780904088; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UntsdzuqpdttstMyOLOIQLL5ljvbyDCzLnXwa0e2org=;
        b=PEsjYe9xPk3+bpywEqqJy7gvjTMIJNY3RqoWpcmNz3Z3ur0o4sQgt0u3p3tNuG+2NU
         EjBAmGNbtuOKsyg1AnrXdAZJ1SRHP7iRV44shzziCeZ8j3eQRaRU5yTPO82iHrK/a2Vc
         /4L/N1VfRnyVViCR8jJyCMxWZlsOQ1ag1p5H2IfEkOm2otSl44PcjUpn1xsfI8sDv2rY
         hlafLEQOP+CQ+efEHP4p4dR9ijZQBtk2TEKJeLa6oln4Z1eGbGTiX22G7L/Fem569SVA
         IJ7sQKFE8BOZ28fwTgb+9DKOKl4mp6j13tcW5WQjFlM42cs7O7kjbY9bZZPAXNP5rrD1
         xNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780299288; x=1780904088;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UntsdzuqpdttstMyOLOIQLL5ljvbyDCzLnXwa0e2org=;
        b=YzeYnA8Lr3lQBxzJfETDhkjc7drUe5eQneSMe70mgcA+qsh0WXhNcBiFvgF+DY2v2U
         ZqMX7QsjxjawwpIqGwOlVIJwlnliB/ppW61dVSCjv03sendYAOniNtjl1VtQBv0f5um/
         eyfOm5wHy4YZrmHMNRDWX/YFHy4U2cRWpEVoR9MHpjFuX5U+yGEdH7QAmjZb+0gvKfPl
         ts1jA8MDgnEt+mNvt0AOcXbAGenltcI6cjKUse/Qpdrz8cGBn6G3Um7CQQyNSsKQFVmD
         Tib+qEcbUR/JKPMn3x3wih7zp1W4UEhYb/xc8bnGR2pZHqx82uzTUb84kas2emXPeXdc
         0nYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/vzMpsqqxR7YLwPnhA6IwD3O586BZvGjXRftWJwaQ9fkSnjlrbq2vgm6Fjp+qD+c1CnGsdf0Ogxg==@kvack.org
X-Gm-Message-State: AOJu0YxVgSAkN6SjvRX6yzFMQ0C4k1WBXGSAP5H9Itbw4hxtbYj6l2hP
	aOzkkM77/TXi14bUY8MA4uMLFZQxw/LWN1QDj0NwuZp8gZDJgBH8WZRl
X-Gm-Gg: Acq92OE0qbm+6/x9WT/HpwfoUh216j+M3gHzjpKAsVZHkEDd75joQRlGW+xi2WQ3EL4
	qL8cC9gxiPC1YnDGO46a0+N5K9e+vYX5aRKOoibDYiM1Ae9j6zt9Av7skPA2fADqYP66aeU/1Px
	vI0blFCunywNPWxOcMA4iIDunyx29jE1sHjYTad9PLSurOMDycGUAkifbtHIqjJRWk+sHD703uh
	fB9bC9y6UTSfyZfqjw8bR22Qo5/Ig6kM+YJ9ghMZJd6y1CjT73WBa718MlHqT6Y5VaEb+ieSXCa
	GghmM0BFJsY4doKjuyRUGJ4X6lzkHxoZStmsbJJGDedkIdjdJl69pSHpfYd8QLoVxkHo6fpR7vh
	+iQrQusE28Xf//NicRpwLWgxmyki155YKhjK8v8CwLF+n+9WPK7cZSwanA3I6RBPbRFJsGF8XEm
	HhkeAE/e5JvSixwvU136YKVDqt1eOYwOC4+Xxdl3J+BuISMVOoPikE5GkXKi5Dv5F70uTKhrHHE
	1ppWgc=
X-Received: by 2002:a17:902:ce11:b0:2c0:3400:5c34 with SMTP id d9443c01a7336-2c034005dd9mr93758435ad.3.1780299287941;
        Mon, 01 Jun 2026 00:34:47 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c4dd4csm97887385ad.78.2026.06.01.00.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 00:34:47 -0700 (PDT)
Date: Mon, 1 Jun 2026 15:34:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, tglx@kernel.org, 
	vbabka@suse.cz, weixugc@google.com, ying.huang@linux.alibaba.com, 
	yosry.ahmed@linux.dev, yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com, 
	kernel-team@meta.com, riel@surriel.com, haowenchao22@gmail.com
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
Message-ID: <ahz_iYG4lqWL4g-J@KASONG-MC4>
References: <20260528212955.1912856-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260528212955.1912856-1-nphamcs@gmail.com>
X-Stat-Signature: 3fmogq5ak78c5swog5858uo414s8nfeb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 600ED1C0003
X-Rspam-User: 
X-HE-Tag: 1780299289-956939
X-HE-Meta: U2FsdGVkX18Cq1PQf3PFT4LWOBqXRepq1W2Udn0wUne7sNF/3S4N/tT55iew+J5ei8p68+argd10JdLG3EGSwrI0a3PP6I69/z2AiqUm3vwZn27x033RRMSZpImt+YlKNqxhGF12tuk8Kr32T4aBJQ0xWbs8lLGh7HevVrE0B/m2reFp2o6d5nq4l/2og/7/k5mJJQLHvl4YOS4HwrIjYSdmcgR/Y+pt+mt8EM6WVuXkb6Z9zeoBScWKQRVoGfoNyh23/8/UIkh3qlTKLSgPa2vkOa7T9y7oljad5ZZgyIJ7XaD4W5XWBzicMcHRlfRxsNumXjQfwGnHtoPPWpj0XZHrtoGozENE9ff1i3Dej8oN2r7ieYmFK0g+dP6gtry959XnixKnKsD3P7o0gW1ZbHBzFhmXJlWyLjUMMaH+LDsZsU01KpqoW7K0xNvDu7C8m3OzOgnTC260ZHTiAjnI64VPBg9aVSWb2NOz8638VASJwKeh2FZTTqVkL/7PH2sEyCxA9rcNuAR9JJHslKdpPBRJbZ6yIOlE1+dqbLlFXg67Ra7tqan3YEUZiPAhdiapl6t80IxfjMz0bnekCoYpP6NRzkJqVH7rsiszXCgF/CGyO5NmAZdNg2ulUn3lhPM/s/eciHGGpIW6x2p4K6R8T9I8IQ8GAI8Lon6IpAVns71AiOhB0zg9Otk0fX2ohdquKO3TW1qF+PJr3Rz1BVV1egOchToInXPVKfozX8EG55GlQbpF18B56K3F8WMKJoaMcN85YjGzN6BY++Gat3sfIXOphbRTyyCErEps46teTn51gs3F1CnR0uYpbZsG95zBVigRoWFA7aEwKPDkaoexNVDq+QiOXXdTgw0PE3lycpk9vp9I1O62pA64ZUCNvo1I9GcwoydOrRHHNHuOs1vVbClhpvv6CNlJ1Ym3rs7LszU2I3+hl9XcWj1do7+PiYICawFZ5ZnVJO/tFkkjkCw
 h5FgxVxr
 XRBJVSU+3xCfvVassjg/xGPTGI0MbeWNKDh2LDHMO1lLHvq3vQGWBfP3BK0fzZ3Y9Ez2Iek9N/STXHVjsMFRIhGcIcn1ArK4muxvsmEcFolnZPthIn82hralDfJ956wmS4J6RugS3g8ZiBtBwx1VWobeQZdYJFT3RsXXw3R6tKK7/6zPPKvkmxvOtdeHEt1XWO5s8dA5ZIh+My4V0tYNg+iiXIb5d/i4qqUs/dc3OLPLbJCp2rMc1CZ3GekYb9Jfae7VqYOMcbWZ3apVjgBWRDBXqqbREShrwpxmvkuF7h8pwXRhJt4Rjfpm87VKIiDe6s/2PN2I5HwVtgaesYEMnTwZzzaa+zWtpqiMHHiLyHWpDaTXif4AzP6eo8O1L76Hvdg6W4V5nQ4Nsl+OU+W03Y1PpwbCj3UVuQlr8P1rl6Pty5yECkayd5jUCYKFAW2ZGOHpX3NL8LzmC+aVhztz3KwOgP5w9Wz6IZjOPTWAR25p6vTAsXSOzpB8DvMtQaHLIyUfKTR05mVz8jzVG4npjatVFwF6Kc4SrWeSJZB09PBGTf9J9hUgjFhl2up073bd0bUN4ho1TasXTLsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 02:29:24PM +0800, Nhat Pham wrote:
> Based on: mm-unstable @ 444fc9435e57 + swap-table phase IV v5 [2].
> 
> I manually adapted Kairui's ghost device implementation (from [4])
> for my vswap device. I've credited him as Co-developed-by on Patch I
> since a substantial portion of the dynamic-cluster infrastructure is
> his (I did propose the idea of using xarray/radix tree for dynamic
> swap clusters allocation and management though :P).
> 
> >From here on out, for simplicity, I will refer to swap table phase IV
> as "P4", and the older v6 virtual swap space implementation as "v6".
> 

...

> 
> This series reimplements the virtual swap space concept (see [1])
> on top of Kairui Song's swap table infrastructure, on top of [2]
> and in accordance with his proposal in [3]. The proposal's idea
> is interesting, so I decided to give it a shot myself. I'm still not
> 100% sure that this is bug-proof, but hey, it compiles, and has
> not crashed in my simple stress testing :)
> 
> The prototype here is feature-complete relative to the swap-table P4
> baseline — swapout, swapin, freeing, swapoff, zswap writeback, zswap
> shrinker, memcg charging, and THP swapin all work for
> both vswap and direct-physical entries — and satisfies all three
> requirements above: no backend coupling (zswap/zero entries hold no
> physical slot), dynamic swap space (clusters allocated on demand via
> xarray, no static provisioning), and efficient backend transfer
> (in-place vtable updates, no PTE/rmap walking).
> 
> II. Design
> 
> With vswap, pages are assigned virtual swap entries on a ghost device
> with no backing storage. These entries are backed by zswap, zero pages,
> or (lazily) physical swap slots. Physical backing is allocated only
> when needed — on zswap writeback or reclaim writeout, after the rmap
> step.
> 
> Compared to the standalone v6 implementation [1], which introduces a
> 24-byte per-entry swap descriptor and its own cluster allocator, this
> edition uses swap_table infrastructure, and share a lot of the allocator
> logic. Per-slot metadata is stored in a tag-encoded virtual_table
> (atomic_long_t, 8 bytes per slot), and physical clusters store
> Pointer-tagged rmap entries in the swap_table for reverse lookup back to
> the virtual cluster.
> 
> Here are some data layout diagrams:
> 
>   Case 1: vswap entry (virtualized)
> 
>   PTE                  swap_cluster_info_dynamic
>   vswap_entry          +-------------------------+
>   (swp_entry_t) ------>| swap_cluster_info (ci)  |
>                        | +--------------------+  |
>                        | | swap_table         |  |
>                        | |   PFN / Shadow     |  |
>                        | | memcg_table        |  |
>                        | | count,flags,order  |  |
>                        | | lock, list         |  |
>                        | +--------------------+  |
>                        |                         |
>                        | virtual_table           |
>                        | +--------------------+  |
>                        | | NONE               |  |
>                        | | PHYS               |  |
>                        | | ZERO               |  |
>                        | | ZSWAP(entry*)      |  |
>                        | | FOLIO(folio*)      |  |
>                        | +--------------------+  |
>                        +-------------------------+
>                               |
>                               | PHYS resolves to
>                               v
>                        PHYSICAL CLUSTER (swap_cluster_info)
>                        +--------------------------+
>                        | swap_table per-slot:     |
>                        |   NULL   - free          |
>                        |   PFN    - cached folio  |
>                        |   Shadow - swapped out   |
>                        |   Pointer- vswap rmap    |
>                        |   Bad    - unusable      |
>                        |                          |
>                        | Vswap-backing slot:      |
>                        |   Pointer(C|swp_entry_t) |
>                        |     rmap back to vswap   |
>                        +--------------------------+
> 
>   Case 2: direct-mapped physical entry (no vswap)
> 
>   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
>   phys_entry           +--------------------------+
>   (swp_entry_t) ------>| swap_table per-slot:     |
>                        |   NULL   - free          |
>                        |   PFN    - cached folio  |
>                        |   Shadow - swapped out   |
>                        |   Bad    - unusable      |
>                        +--------------------------+
> 
> struct swap_cluster_info_dynamic {
>     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
>     unsigned int index;                /* position in xarray */
>     struct rcu_head rcu;               /* kfree_rcu deferred free */
>     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> };
> 
> Each vswap cluster (swap_cluster_info_dynamic) extends the classic
> swap_cluster_info struct with a virtual_table array that stores the
> backend information for each virtual swap entry in the cluster. Each
> entry is tag-encoded in the low 3 bits to indicate backend types:
> 
>   NONE:   |----- 0000 ------|000|  free / unbacked
>   PHYS:   |-- (type:5,off:N)|001|  on a physical swapfile (shifted)
>   ZERO:   |----- 0000 ------|010|  zero-filled page
>   ZSWAP:  |--- zswap_entry* |011|  compressed in zswap
>   FOLIO:  |--- folio* ------|100|  in-memory folio

Thanks for trying this approach!

For the format part, PHYS don't need that much bits I think,
so by slightly adjust the format vswap device could be share
mostly the same format with ordinary device.

For example typical modern system don't have a address space larger
than 52 bit. (Even with full 64 bits used for addressing, shift it
by 12 we get 52). Plus 5 for type, you get 57, so you can have a
marker that should work as long as it shorter than 1000000 for PHYS,
and shared for all table format since it's not in conflict with
anything. You have also use a few extra bits so a single swap space
can be 8 times larger than RAM space, and since we can help
multiple swap type I think that should be far than enough?

Then you have Shadow back at 001, and zero bit in shadow. The only
special one is Zswap, which will be 100 now, and that's exactly the
reserved pointer format in current swap table format, on seeing
si->flags & VSWAP && is_pointer(swp_tb) you know that's zswap :)

Folio / PFN can still be 010 as in the current swap table format.

Then everything seems clean and aligned, no more special handling
for vswap needed, there are detailed to sort out, but it should work.

> - Pointer-tagged swap_table on physical clusters for rmap (physical
>   -> virtual) lookup.

Or reuse the PHYS format (rename it maybe) since point back to vswap
is also pointing to a si.

> III. Follow-ups:
> 
> In no particular order (and most of which can be done as follow-up
> patch series rather than shoving everything in the initial landing):
> 
> - More thorough stress testing is very much needed.
> 
> - Performance benchmarks to make sure I don't accidentally regress
>   the vswap-less case, and that the vswap's case performance is
>   good. I suspect I will have to port a lot of the
>   optimizations I implemented in v6 over here - some of the
>   inefficiencies are inherent in any swap virtualization, and
>   would require the same fix (for e.g the MRU cluster caching
>   for faster cluster lookup - see [8] and [9]).

This could be imporved by per-si percpu cluster. Both YoungJun's
tiering and Baoquan's previous swap ops mentioned this is needed,
and now vswap also need that. If the vswap is also a si, then it will
make use of this too.

YoungJun posted this a few month before:
https://lore.kernel.org/linux-mm/20260131125454.3187546-5-youngjun.park@lge.com/

The concern is that some locking contention could be heavier, or maybe
that's just a hypothetical problem though.

> 
> - Runtime enable/disable of the vswap device. To be honest, I don't
>   know if there is a value in this. My preference is vswap can be
>   optimized to the point that any overhead is negligible. Failing that,
>   maybe we can come up with some simple heuristics that automatically
>   decides for users?
> 
>   In this RFC, CONFIG_VSWAP=y means the vswap device is always created at
>   boot, and CONFIG_VSWAP=n means the vswap device is never created. This
>   *might* be enough just on its own.
> 
>   Is a runtime knob (sysfs or sysctl) worth the complexity beyond
>   these heuristics? I'm not sure yet. Maintaining both cases

I checked the code and I think it's not hard to do, patch 1 already
handling the meta data dynamically, everything will still just work
even if you remove vswap at runtime. The rest of patches need adaption
but might not end up being complex, it other comments here
are considered.

For patch 2, a few routines like vswap_can_swapin_thp seems not
needed or should be moved to __swap_cache_alloc? VSWAP_FOLIO is
same as swap cache folio check, which is already covered. Same for
zero checking, and VSWAP_NONE which is same as swap count check
I think. That way we not only save a lot of code, we also no
longer need to treat vswap specially.

If you keep the format compatible with what we already have
as the earlier comment mentions, a large portion of this part
might be unneeded.

>   at runtime also has overhead for checking as well, and some of the
>   checks are not cheap :)

I also noticed the new introduced swap_read_folio_phys in patch 3, so
this actually can be done using Baoquan's swapops idea which is now
part of Christoph's swap batching:

https://lore.kernel.org/linux-mm/20260528124559.2566481-9-hch@lst.de/#r

That series is focusing on batching and better performance but swapops
was also proposed as a way to solve the virtual layer, makes it possible
to have vswap as one kind of swapops which is Chris talked a lot about:

https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/

Following this, we could have something like:

const struct swap_ops swap_vswap_ops = {
	.submit_write		= swap_vswap_submit_write,
	.submit_read		= swap_vswap_submit_read,
};

The move the folio_realloc_swap in swap_vswap_submit_write.

Merge of IO might be moved to lower phyiscal level for vswap.

Another gain is that the memory usage and CPU overhead will be
lower with only one layer. As I'm recently trying to offload swap
dataplane off CPU so the CPU won't touch the data at all, the
overhead will be purely by swap itself, plus some mm overhead.
Things like that and IO optimization above and could make swap
subsystem more and more performance sensitive so we have cases
that needs only one layer.

> 
> - Defer per-cluster memcg_table and zeromap allocation on physical
>   clusters. A physical swap cluster backing vswap entries only do
>   not really need their memcg_table, but the current design forces
>   us to allocate it anyway. This is a waste of memory, and is an
>   overhead regression compared to my older design on the zswap-only
>   case, which Johannes has pointed out multiple times (see [6]),
>   and is one of the biggest reasons why I have not been satisfied
>   with this approach thus far. It honestly is a bit of a
>   deal-breaker...
> 
>   That said, I think I might be able to allocate them on demand, i.e
>   only when the first direct-mapped slot is allocated on that cluster.
>   That will give us the best of BOTH worlds, for both the vswap and
>   directly-mapped physical swap cases. No promises, but I will try
>   (if this approach is good enough for all parties).

Zero map is not really a problem when it's just a inlined bit I think.
For memcg table allocation, on demand seems a good idea, and actually
we are not far from there, I tried to generalize the
alloc-then-retry-sleep-alloc in swap_alloc_table but still not generic
enough I guess.. Good new is the allocation of the table is already
kind of ondemand, just need to split the detection of these two kind
of table.

Mean while I also remember we once discussed about splitting the
accounting for vswap / physical swap? If we went that approach we
don't need to treat memcg_table specially.

> - Widen swap_info_struct->max to unsigned long. The vswap device's
>   max is currently clamped to ALIGN_DOWN(UINT_MAX, SWAPFILE_CLUSTER)
>   (~16 TiB) to fit in unsigned int. 16 TiB is small for vswap,
>   especially when we're getting increasingly big machines memory-wise.

This should be very easy to do, just replace unsigned int with
unsigned long, a lot of place to touch though :)

