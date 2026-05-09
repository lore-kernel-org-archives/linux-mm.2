Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A17CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 16:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE7E6B0005; Sat,  9 May 2026 12:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558506B0088; Sat,  9 May 2026 12:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4204C6B008A; Sat,  9 May 2026 12:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5D26B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 12:39:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74FEF1A01A2
	for <linux-mm@kvack.org>; Sat,  9 May 2026 16:39:16 +0000 (UTC)
X-FDA: 84748441512.30.D3BA094
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F05A140005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 16:39:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="denly/R5";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778344754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Z2UMBx5dGhCxet+pSUCVtwvNzhJpnfXCgIbbDTxeL4=;
	b=nvEQL8g9LrIBxMsfbuC4hig3UNgHBQ7ZljjGBQIrYc+5J6sGKnh3BremPhR7MxcWc/wCSw
	VYOM+vqOYYAp8yxzJsJ7f5+XHDL96ekNgV/k0Px21MKgOahvLtSzau8z6BaSZ02k1qj+Br
	rQkK7D67BrnOiRrxwLztl2eCXbIZMHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778344754; a=rsa-sha256;
	cv=none;
	b=RSlMt641IK9/HT+nk8pGRNPG/sCwD2KjfYAaTd91y1f17sKwfFUBD6lCmw5axwUcQd0aMH
	mkewHYuSR7CEzct9pud5gjmIojvhc6mfBcO/EsiZEupvIhcFpLIOYAkjlF76eMhAO3VrG0
	3CMquaA4KJJH3CI9ZSekk0Jg/ljZ+mE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="denly/R5";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2f0ad52830cso4523673eec.1
        for <linux-mm@kvack.org>; Sat, 09 May 2026 09:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778344753; x=1778949553; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Z2UMBx5dGhCxet+pSUCVtwvNzhJpnfXCgIbbDTxeL4=;
        b=denly/R5q7R/rtOz75NGa4mzKkZm0gFc9y6cMtzn00Ok5pevWlndTJLm51EtyJ1nhK
         uk23PX5X8ri53yOOt0um0JEYGbcRDJSw58pgzYW93Fm+BdnccB/LtvlcDTjZy+PhR4tq
         Fa+sXZXnInPdfp2CLCbLGdceXvxmRnGoMIrPrRF75L31TBv4G3KPjJEFSZeSwig38Arq
         ga8Hi7CD/agI1u/OgFrFgs+4rxh7HXpbBIfjeXVvBq+3EPGxPA2nwRv/4KSL+G93khvd
         KHcJXeyIjZyMylv9OBrVrvHCmr1cUOz+Y5ZeuvSrvFcFy3oEaKyR9ByCcX/RzjJ5tgx1
         x4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778344753; x=1778949553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Z2UMBx5dGhCxet+pSUCVtwvNzhJpnfXCgIbbDTxeL4=;
        b=bLhH0ZFquQgmyQDq4vNu5AcggXgwGVvlDSusPtcYY/3iTg1meTDORTLy57c7/MSj76
         gzTQ+LHYrd9Fm2n9KkWmXKACLlOMUTInY67oR3RdW+ybd0VTX08B4GroW7f/dm4LF+8Q
         rkYcIpPDpNUIehpmgkr13PNKj+7VlGgM0isqD1CPjBZpA4iw0IBvKNgiEF6yzeRqvdA0
         QR4n9yqFEqcr3VwSfdcjb7NMWItr0OFZGRLV4y7kNGHXItA/QLONgNMEGdi8QV6dUDT/
         bhKcC+gPFra37jQ0FDEQon8vfJwuPxD+m70I92ULXnryWe+YK67r7GrJcRczeWtG3m1Z
         olFg==
X-Forwarded-Encrypted: i=1; AFNElJ++5sfk4tegSNls2rRxOqRoA5iLRlMdRXbABnqSSpmrKK0FmJLgJsalTugHRUaT/ZykD3qFlWKA0Q==@kvack.org
X-Gm-Message-State: AOJu0YwviFARcVEljRlIqqkzRGB2yT1tw/WDBoht4RDd5yETmOVK6zgd
	p4ltDpNt7KvZugP2IzhycnuKRPi+hC09fcFt1o4dGEOMQRXqdbXZXTpLs6qNS9Wof8k=
X-Gm-Gg: Acq92OGtjZxXnzbNaTCN+WA2YYQ0hSMPTCtu9nHxtg8dzJKUc9o2vFD21uB99tmS75z
	A1zwSjJlrYOBAcb7G/TlpY+NQbNZUJUmrVGxThQ7GRJqpTcLKKrR/03857b9+4vf5K7kJqR74Qv
	SVrTdNJqnlx8ATEaBrGtDlTfh8Dzxy0hJ2YpJeOOo+wTTmKn38tiRdB0/HYI1qI5m0lDjAeWrKK
	4yHNpIMtGnDcL+wYC9M/HUUydkHs/5NW/Xvt/N8YjL8SapJz0DNnUJ4gWQfR+x+g6uRxN77Byfx
	qconRNLLkkwjaxBVgJlALX+FB5tAznL4sXkGV+csVUldaMc66WFU6WK6ww7AvmDoJyIRS9bNgEK
	x4LmbRsKALMSyNHEJaXUp+q4+JTA4PwGGYzuhya4YzZYfbmRUEUiPF1KOBr/aHuK1fg+q/ij+gk
	pBaeso+buyCbcnekeooXLxnk0yjAtJZ1JpxQyA4vfdJw==
X-Received: by 2002:a05:7300:724b:b0:2f8:1f2b:bb5d with SMTP id 5a478bee46e88-2fb4dc64acfmr984629eec.25.1778344752833;
        Sat, 09 May 2026 09:39:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([205.220.129.38])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eb4b7sm6994852eec.2.2026.05.09.09.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 09:39:12 -0700 (PDT)
Date: Sat, 9 May 2026 17:38:05 +0100
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
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
Subject: Re: [LSF/MM/BPF TOPIC] Private Memory Nodes - follow up
Message-ID: <af9i7dkNvGGxPHzu@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F05A140005
X-Rspamd-Server: rspam04
X-Stat-Signature: 4rrtoh6e47weiyht18a3n4m5cwfotth6
X-HE-Tag: 1778344754-182807
X-HE-Meta: U2FsdGVkX1+G0pBy1Zm4C8zm3GmTWqQ4IiiktBSapKYOxCizh2n5ByOLyYWKQJk3pjzrNC8SITE2IjYlMHvzrN1ebcFVmu5oNLdkDfhFhU5qzvHwK8B2Mr8H7Ik0QWn4zBhdYfvIiAnILXWSHmip9GF/gGQExnP+dLabZ2xdLiK0gY/M4U/iwQSfcqoMCUnQdUBEYXGKn/ZpJR846yw2Gu5UZqJstv2EFy38ASgda4HJYfHXIgUwuRnI2v1oH+s7MJuUjcXFCDGZ+mKQyM6GZgOiO8d5uXe6Rw5dHmqKkm5hINWZZ0TSb6ABXntO5H41c8jnjN7G3fki7FGujE9HSKHyeI98zpBgyIvKmp/fZOXaZHhgZHTsm2lCtnAbbu5f4MOyDNk6vcBYcN3F2/rUasc63iMeP3QnQovy7a5Dr1tWNbR6pHZ4yX7wxCcbREpxSA8n2TTuBnf2EwlrFxlZITzEMsqJYtIw86GTAblZp/YSHDj9Qyp4Z2KviHtWzl9/+6piOfKjie1dnb+589/YDA6TIsW65QefIp8dxzpfCaBzNzK/k95quOkTAcOe1I5Wl06AMtwIntuqUN0QnMPq9o7/J8Bk8P7NxmGU4n2knyV+HBRrJeq8rNmy5qIkre6wJgPOJc1GwImFe90BweuraL0Tfb9EJKyHevPSVVl7b0/ggMO6FTIPolC8/trfvYXLvYM1s/DYDpsNieVQmROUYtzYUUsMC+L1Huel38Y3oWbsupJns7OEE4QB4RawpnIf3v0C6F4OeZ3vfFOii5mpfNVM5VNRAUaPhCGw0Rp7B47FC1Ltb2yrCohACf+VtwnypxWth5dSTO55PGU2x0ldUkPP/7pHnjE7m//71YcGbDsf9iW6THZdRTN30Hjb9xzhA/eGSzRW0boWOOJSvOTpTnrpAZ9vaM+YwxWmqp6YcG4DbxW+9MsyoQ+f0taO5hDkU5tpxlBT3D5j214S4b5
 ElvukYeB
 TUZcn/rJKjPh5oC2gu1SUYJiWLH8H6mlnEkiX3Elg9GqrjHhTZ8Npv7obCWMH6FiVeXcyugcjydVDsnqAtvyrC1RlFOULzcTYjI0RypJrJ2MromCAq6SoBWWAMyd4Yw+cfE4awLypo6cbEERgD8juC7fWIernUeRS3jdANgB5jl6scbBTVwNORA1gjL9z2D4GTVjeyUmPAZl0N0NqWHLINEwoumJxkIBZ201csvfW/bsUxrWsUwjrvp1ydC055hsvXHaPjVaxIZiKfwFOFHUHJ8fmqHGBUJRCXv9BBRF3Lyj/4gzEDAJZQpdnXzi8nvLIzE6CCqh1mJQj5LLrY7maBCrEI5gaGb9uo7iTdmUpIFiZEvqh/A4Su+alWz8fPFOp3FsjzJqOlB+puIVSbj0ece0BABciwTHAMSZDZqv7yLUwvLpGU8Br7g1vUxqhRTdP3li9QV5n7H9v1H4Hk0IE/Z+D9+nlg5odt4BsjtFkvG0bEy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just wanting to follow up post-conference with a few major take-aways
since I will be a bit sparse during May / Early June (so want to not
forget, and garner a bit of input on the notes).

If you just want the tl;dr:

   0) naming:  private -> managed

   1) remove global general "possible" and "online" node lists

   2) add consistency with "normal" nodes, by opting them all in
      to all the new things, and just making that the new normal.
      e.g.: node_is_private_managed -> node_is_lru_eligible

   3) Have __init add init time nodes to all the lists
      Otherwise service/owner must add/enable services.

   4) Make folio checks just way more explicit per service
      e.g.: folio_is_private_managed -> folio_is_ksm_eligible

   5) I still think w/o __GFP_PRIVATE this will still be too fragile,
      but we're going to give it a try.

   6) No callbacks in the MVP

   7) MVP will be, essentially, Buddy + MBind support

Otherwise, more notes below.

~Gregory

<wall of text>

0) Naming is hard.  Willy and Liam expressed concern over "private".

   We briefly discussed "Managed"

   This results in the following changes:

      - if (folio_is_zone_device(folio))
      + if (folio_is_managed(folio))

   and
   
      + if (node_is_managed(nid))

   and

      - N_MEMORY_PRIVATE
      + N_MEMORY_MANAGED

   I'm less enthused the last one, but i'm ok with it.


1) There is a desire to fix possible / online node masks to avoid
   bad patterns, and maybe to audit existing nodemask users.

   there's one UAPI issue with this, and that that these masks
   are exposed to userland by nature of existing node attributes
   (N_MEMORY, N_CPU, N_POSSIBLE, etc).

   I'm considering a name change from `possible` -> `init`, because
   that's mostly how it is used (initialize some set of per-node
   resources during __init, not at runtime).  Externally, this set
   would still be reported to uapi as possible.


2) There was concern about inconsistency towards nodes.

   Along the lines of #1 - I'm thinking about actually adding explicit
   service nodelists, which are populated at boot by __init, and by
   hotplug if it's a general purpose node.

   So we'd end up with things like:

       for_each_ksm_node
       for_each_lru_node
       for_each_x_node

   And we would retire such general defines like

       for_each_node
       for_each_online_node

   For any "normal" node, it lands in all the lists.

   For the buddy, we would have

       for_buddy_node

   For the default buddy-node list, and otherwise "managed" nodes would
   still be removed from the standard fallback lists.

   This means these nodes cannot be reached via nodemask arguments, and
   can only be reached by `alloc_pages_node(nid, ...)` nid argument.

                I *think* might resolve __GFP_PRIVATE.

      But it's still dependent on system-wide for_each good behavior.


3) How do private nodes get into the lists in the new system?

   For any private node, the registering driver (owner) and the managing
   service are responsible for adding/removing the nodes from the list.

   Example workflow:

     0) CXL driver hotplug: add_memory_driver_managed(..., nid, owner)
           a) owner=NULL means general purpose node
	   b) otherwise, reserve nid and (pgdat->owner = owner)

     1) hotplug memory onto the node
          a) if node is normal, add to all service lists
	  b) if node is "managed" (private), omit from all lists

     2) CXL driver registers node with specific services, e.g.:
          cram_register_node(..., nid, owner);

     3) Service sets node enabled in appropriate node list, and starts
        any appropriate services (kswapd, kcompactd, etc) for that node.

   In some cases, nodes would have individual mappings onto services
   (cram), in other cases the intent would be to have the memory
   otherwise treated as general-purpose, but with special access
   patterns (e.g. an LRU node not marked N_MEMORY).


4) There are still concerns about random hooks around the kernel.

   My thought is to make this less "random", and more a change
   in the way we think about folio operations / node operations
   for ALL nodes.

   ZONE_DEVICE has a bunch of implicit filtering due to not being
   on the LRU - but the intent is to allow flexible LRU membership.

   So what if we just made these checks much more explict overall

    if (folio_is_ksm_eligible(folio))      /* can be merged */
    if (folio_is_lru_eligible(folio))      /* managed by lru services */
    if (folio_is_demotion_eligible(folio)) /* demotion target */
    if (folio_is_mbind_eligible(folio))    /* can be an mbind target */

  Rather than rathole over what the set of bits should be, i think it's
  more important to determine what the actual operation here will be.

  right now I have this defined as essentially:

     folio_pgdat(folio)->private.ops.mask & NP_OPT_KSM

  But if we generalize to all nodes / all features, it's essentially
  a per-pgdat bitmask lookup:

    bool folio_is_ksm_eligible(folio)) {
        return test_bit(N_FEATURE_KSM, folio_pgdat(folio)->features);
    }

  With the bonus that all ZONE_DEVICE hooks can be sunk into these
  checks, so there are many places in mm/ where this becomes essentially
  a single-line change.


5) Lacking __GFP_PRIVATE, I have concern over fragility.

   Previously, __GFP_PRIVATE created a "default opt-out" mechanism.

   I *think* the above nodelist changes, specifically removing:

       for_each_node()
       for_each_online_node()
       for_each_node_with_cpus()

   The problem I foresee is with existing node_state masks, like

       node_state((node), N_POSSIBLE)
       node_state((node), N_CPU)

   This might be tractable, but it may also simply be too fragile.
   
   Right now only 3 or 4 locations use node_state() outside mm/, and
   I'm tempted to try to sink these into mm/internal.h instead of
   include/linux/nodemask.h.  If that becomes unpalletable, then I will
   lobby for __GFP_PRIVATE again (I may still anyway :P).



6) No callbacks by default, but nothing technically prevents it.

   I was already in the process of killing this.  I think mmu_notifier
   does *most* of what the callbacks where doing anyway, so we can
   probably collapse that.


7) David asked me to limit the MVP to Buddy + MBind support.

   There's some odd interactions with pagecache, so that might evolve
   too (may not be able to reliably fault a file directly onto a private
   node, tbd - mempolicy does not apply to page cache faults, so it's
   just unreliable).

</wall of text>

~Gregory

