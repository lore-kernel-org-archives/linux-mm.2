Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19487C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 14:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7640A6B02AA; Wed, 12 Aug 2026 10:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714436B02AB; Wed, 12 Aug 2026 10:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6039C6B02AC; Wed, 12 Aug 2026 10:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 305386B02AA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:50:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4E5E14027C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:50:00 +0000 (UTC)
X-FDA: 85092902160.14.2D624CF
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id DC6EF1C000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YMoAe9FM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786546198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2bfz1xPNnYsmTuBu6PuVX8SO2+iE1L2/l9R4aB2xA4=;
	b=U4Rx5ackVeKSPRGGveYYDrGj7OTwxF0HCq5LndLyFe6b4UvnZdNunRF6BO6IXWbc1rnDxr
	IoqCslc/E0AeXzpcFgd/vHhNeCRwgBHv8czQgWgDdasTeHeMQwxfBcbmyCF/KjlF/Kqcte
	I+lsN7wrjFgUxLlO8PNfRr05bROGzhM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YMoAe9FM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786546198;
	b=VHwpHskOXSpVCB4cASD48/7BYCKaZSgnuRniLQCc/ZE6cOPw6cduXbD/MCT+7b0QI+ihTC
	H9AxjhskGVoBCDSqb+xobnrXAZDRc/F5t+5Ll0leJM8K+2M8MyevPPAuijsb9Xohe0hWvB
	I9gH1iH1JMLPFnV1ETyHlPKEz6469zQ=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso1248966a34.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786546198; x=1787150998; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m2bfz1xPNnYsmTuBu6PuVX8SO2+iE1L2/l9R4aB2xA4=;
        b=YMoAe9FM0XvTlVgZRM8tLg7iFZYtjHkS2tLMtKCj+wN9hEsRHxsFj6lI/f96RoP74z
         z3wo0wKx2jTt/eOHBOmb+vKZ2SYWaFPa4Piej7vyCxJbYt9r7h7ii1HHdkxnMVlKk307
         XwMzw9tVvgl8i9MSOOoBR3g8qavRYwh/2ewGrIpY6o0Q2kN09JNbyJal4HJPF3jzNGTM
         VXOPlHqnnCCbj8633vgQ5cAo7YGQ3OxQIuWGfzkIKE3r8wOGXVgEi7Eg9k2vPgsdXkc+
         4j11qNQZFMbUb/88nxPAjUaPeEjRm2MMtC3AYtQp5Ra4ZfdFTDn6rmrHaDRB995VXIUM
         zImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786546198; x=1787150998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m2bfz1xPNnYsmTuBu6PuVX8SO2+iE1L2/l9R4aB2xA4=;
        b=Id6l/PHLzp3fhp+leKW0BhJ9HvmW/xpavKwB8As8Y5loMsJxGgqWXzUc+GsZw5F/OD
         qn4ADANwKYTiSYX9V2R3E9F15lxTaXzeIA9des1XtfXitfIGIC1Zxy7s0UZAfluNr9+x
         f6UxoulybN8I+pFqir3KBJWooEy9aI77Zlyhfctm7Xk2ftMMzl98WKDK1BnDDsoTP+NY
         BtDkre6Lw1w8BbEwzBUTZGIOD/IJir1I+Tsy/PEAC7MeXZXKUn+fBDnLtyoGyC6CbrEH
         SHdvRk/X0cmi9k6DIchoPNHVGJdjCxWz3loSyGoJ5rBII0Lt3Df/EtJ9KRWymIEFg7H+
         tomg==
X-Forwarded-Encrypted: i=1; AHgh+Rp5b7AfJuDjJ1ZYg9XkvLivBAXPGewLh0dPSb720Y+C1aBNqSKqCTCOaMv47+xqE5jpzNg38UmZBA==@kvack.org
X-Gm-Message-State: AOJu0YyPVYTbCATEZ0GcgMj96OFU/YxzION6UWkuLspfGl7IAJe9bjeS
	VEng8LVX6Etrfmg+xOXdUWrj4Kw+acX1fw/eobVg/p8IogGGIa5F5OOl
X-Gm-Gg: AR+sD13QJL7ZuhMhr4lQm4BGRGjJiWjMKHOW5dFU3IHQilvSTjdc14mmflaQy/77y+x
	jIFTNZad4B3fBK/dz7JFg915qdjoAMj4m4roEIrkQ1jNrZp7Rn8l0/x1jIzHKNypyC2WZZhFaEW
	dF2ls8h9hmcfC+L+loHWjPBpcBYBlf2mDp1SDeg9lLq6zgG09vPF4c2tsSMb0MiPAXePX1k5+Ni
	jWsa9Djm8WsWm9bfzqyQfymIoRh03xx5tY6gCSc2PkcDdXMeGErROgbnVGCItjewomZUnxAaH4w
	hA+6JuZMDQ3kK8X0H3dOh8AbcVsIUcxnnANJIqcTgV/j04uT88wt+ZPOlkjWvIdhQnCp0xRnv0E
	7qIBw06EvOzzu2llIxRa/G/Tgkbz2IPVCM5LX+/VmLsV7cUW69a50e2FbMub3QWcicRIRcMsVRg
	DIwC/4pAvxE4C70yybXLC/5d0pVigemqndS56zBT0YRnmDUptnVkP+Ttx5Iqoqo7LcR+wl/6waV
	/H7uAO/Y4xUOiXZf5w=
X-Received: by 2002:a05:6830:2116:b0:7dc:c7aa:22bd with SMTP id 46e09a7af769-7f3b7731b94mr5693831a34.6.1786546197721;
        Wed, 12 Aug 2026 07:49:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3b34266f3sm3096544a34.24.2026.08.12.07.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:49:57 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Wed, 12 Aug 2026 07:49:55 -0700
Message-ID: <20260812144955.3310684-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260812054700.1803-1-rakie.kim@sk.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 44e7bs9snc4gbfyaipxgodd895oj4dwa
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC6EF1C000C
X-HE-Tag: 1786546198-46461
X-HE-Meta: U2FsdGVkX1+li6AUeL1Q+/rIZ16TET39sQfYo2Imgp+rW0gfn/YeLnoqPOH9VTRqE0RfJ6tonKXhBH9kJlBxbmZKVp/OhBZ4gf8VxaOzE/bw1U3/Ck7f1uKERyR0QQwPPGKGkVw+MWy7aeo/o44dXLaFfeHGFWA6Dz66aQU6igBho1iySzdv/sjGETS9922ujNA+O4vahiNswUW+h4mKEPzubtFnKioHE7qabtGpDYJf7KaBSHvoRY83DWFDtuCxoM3ZtSUeX6LzQVaDlW6ifvFZvESp25nbQ6u+rwwY40P9qTa7CeLEYZqOIQyVCJc/kzValTjbUmD6Rl1v41pArqxHuKNrKg/UH26opnqairh0gp2hinxYMCY2pvRzlGJJJBlxTAvzhVauJ5bCO5+qrMIlxpyV4Nr+RVU4oalFVVVdH3K6aeXxm+s0NWqr3qLYaN55rfTKPz1BcDCBAWI5rrHTCmsXtKFLq6mMN+Tq5u78tQbupPEJb5pqA0UZioKp8fzlrJ+n0K3afD46v5hf1pz8VNRJaMHCTjCoJJn0FSFQ9fOv3Vj/dpdluI1xtdlRIbN65dLWYwu5/8iXZPMJqJ1fLAvhEfQZsAq9HIHPpnaC3tgo+t+VtyVoNjv4+KHr4izA39t+95HQq2akgCtEEwu49P4XjaT1VlXIVp4BmCSZyip4IBLFzmF6l4SRjXws1IWnz4GhjezPRIdZU2QyvCjS/UYyIBBJgUjez+eNdMn7uVAUxdIg1gX3Ibmt40b17nKbrDikuKkWgiGLy7LWmrKk0UdKeHJCE0Z27COwPLO/4N0WznFVG0MhiRNC3Co451yMrNlpVeigaEsftYNQS5RdqJy6Tk6ENLQQlVdwCXpzn0VIBYyuRHA8OvVBZQlXLuvR919CHh0AVdiXHWWVNI0A7dR8LNbN92wxS6IUxApwX4kqZB0GcvZou0PQ5cHq++K8Ih6xqh+UuQNCJP8
 1UNHdtTH
 tPZ9c5BiWDHC9nnaTWWFDg/Prwt2DhwI+yCyOQHXKBBslFdXGToCXYtX4qfH2+8/3xmjFaQykmwbI+yBpdIIP04z1odMOsEpDZbOfFykXeg1rL+xwPVahWflNPmEJ8Xo3m5FxZ5uK0fdmDCUWRQosIT/H8z+j74bDKcYdUWNpZBMTN3Gjwjs+2WoHsp3BM01AlxzX0TaCkpm7PrJ3fdJ0hkvG/3M4sZZGsZExInIZrS7Cv8qk5DU++Z6NcF8oYvv4LEJTHCkycueXNespMCSIBcNUL0bPJqqX8mqREeTJka1pNcs9MvgrNNdSn7oqhUn2HE6Os+FeBpeM4WT+hPY+sPiB5RHCjg39Pnzd4TofoEARqfoZ/Ws+9iY17NGlz6wwYF/JQBM/GG/qPx4DtDnrlHXnw5QBwbxwpourb5GGTY7hl/HX/9/WHS2szOqvYsi7z7z75r9xUgh5Gvr4szk1Av8CpF+GULLXLpIarO2aqd8cvG+5Is43O3dZGcccBGo9BskEvl/ficzNIKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hello Joshua,
> 
> I am doing well, thank you, and I hope you are too. Thank you for
> taking the time to review this series and for following up on the
> questions from the RFC discussion.
> 
> > My first question is whether we want cross-socket allocations at all.
> > The examples you gave seem to line up with node-restricted interleave,
> > as opposed to cross-socket interleave. I think the wording that you
> > use to describe the feature in 4/4 (which I will copy below)
> > 
> > > The resolved mask is by construction a subset of the policy nodemask, which
> > > mempolicy already restricts to the task's cpuset; package mode can only
> > > narrow that set, never widen it, so cpusets and the task nodemask remain
> > > authoritative.
> > 
> > is 100% the right way to treat these package-aware (socket-aware)
> > interleaving allocations, but the example below
> > 
> > [...snip...]
> > 
> > > Applied the same way to every source, these weights give the map:
> > > 
> > >               node0  node1  node2  node3
> > > global:         2      2      1      1
> > 
> > [...snip...]
> > 
> > >               node0  node1  node2  node3
> > > from CPU 0:     2      0      1      0
> > > from CPU 1:     0      2      0      1
> > 
> > Is essentially the existing weighted interleave mechanism with a
> > nodemask/cpuset applied.
> 
> The example I gave was not explained well enough, and I can see how
> it reads as a manually applied nodemask.
> 
> A nodemask or a cpuset names a fixed set of nodes, while package mode
> expresses a rule: use the nodes of the package the allocation is
> requested from. The mask is resolved per allocation from the
> requesting CPU, so a single policy gives {0,2} to a thread on package
> 0 and {1,3} to a thread on package 1 at the same time. One nodemask
> cannot do that, since it is the same set for everyone who uses the
> policy.

Ah! I'm sorry. It seems I totally misunderstood the intent of the
series. I think that my brain short-circuted to the discussion at
LSFMMBPF from 2025, where I think we discussed having a real 2-D
grid with weights per-node, per-CPU. I think my confusion is responsible
for the examples below, which as I understand it now, are not the intent
of the series.

> There is also the question of how a user would build such a nodemask.
> The package a CXL node belongs to is not visible today: on the
> systems I tested, the firmware reports node1 as the initiator for
> both CXL nodes. The topology layer in this series is what makes that
> association available, and the read-only view under
> /sys/devices/system/package/ lets the user check it.

That makes sense. Now I really see the goal of the series and it makes
a lot more sense. Thank you for the clarification. 

> > With that said, I think a more interesting and
> > illustrative example would be if the user truly would want to allow some
> > allocations to go through cross-socket, but be able to control the
> > ratio at which these slip through.
> >
> >               node0  node1  node2  node3
> > from CPU 0:     3      1      2      0
> > from CPU 1:     0      3      1      2
> >
> > Maybe even more illustrative of the true capabilities of this series
> > would be if you have an asymmetric system where you bind some
> > host-level monitoring / logging workloads to one node (say, node0) and
> > want that to be able to cross through to the other socket, but not the
> > other way around:
> > 
> >               node0  node1  node2  node3
> > from CPU 0:     3      1      2      0
> > from CPU 1:     0      2      0      1
> > 
> > Anyways, these are just super hypothetical scenarios and I don't even
> > know if the configuration that I'm listing would really be beneficial
> > for the system. I think that coming up with some illustrative usecases
> > which are now made possible by this series could help motivate why we
> > would want to interleave across sockets.
> >
> 
> These maps are an interesting idea, and I would like to look at them
> with you.
> 
> This series only narrows the candidate nodes; the weights themselves
> stay global, so every source that reaches a node uses the same weight
> for it. Both of your maps give a node a different weight depending on
> which package the allocation comes from, so the weight table would
> have to become per source rather than a single global one.
> 
> Encoding the weights that way came up in an earlier stage of this
> work, and it was mentioned again briefly in the RFC thread. As I
> recall, the difficulty then was less the placement logic than how a
> user would drive it: weights would have to be configured for every
> source, so both the interface and the structure behind it grow
> considerably.

Yeah, I can imagine it is quite a lot of tuning that users have to do.
So I'm 100% on board for the goal of this series to make the existing
weighted interleave mechanism respect the initiator's POV. Sorry for
making you explain all of this, this confusion is just due to my
misunderstanding.

> That does not make your suggestion less interesting to me. I think it
> could work well once there are clear scenarios for it, and the
> grouping added here is what such a table would be built on, since a
> per source weight only has meaning when the kernel knows which
> package each node belongs to. What I am unsure about is folding it
> into this series, whose aim is the narrower one of raising effective
> bandwidth by keeping interleave traffic within a package. Allowing a
> controlled amount of cross-package traffic points the other way, so I
> think it is a topic we could discuss separately, with the use cases
> worked out first.

Thanks! Actually I think we can wait on this until we have real
usecases where we prefer to make cross-socket allocations.

> > I was also hoping to see what this interface looks like and maybe
> > discuss how we should relay the information to the users, since this
> > seems to be a new addition from the RFC.
> >
> 
> Sure. The toggle lives with the existing weighted interleave knobs.
> package_mode defaults to false, so nothing changes until the
> operator explicitly enables it:
> 
> /sys/kernel/mm/mempolicy/weighted_interleave
> |-- auto
> |-- node0
> |-- node1
> |-- node2
> |-- node3
> `-- package_mode -> true/false
> 
> The package topology view is read-only and lives under
> /sys/devices/system/package/. This is how it looks on the system I
> am currently using:
> 
> /sys/devices/system/package
> |-- package0
> |   |-- package_cpu_nodes -> 0
> |   |-- package_mem_only_nodes -> 2
> |   |-- package_nodes -> 0,2
> |   `-- physical_package_id -> 0
> `-- package1
>     |-- package_cpu_nodes -> 1
>     |-- package_mem_only_nodes -> 3
>     |-- package_nodes -> 1,3
>     `-- physical_package_id -> 1
> 
> package_nodes shows every node grouped into that package, and the
> cpu/mem_only files split them by type, so an operator can check how
> the kernel grouped the topology before turning package_mode on. I
> will update the documentation in the next version to describe this
> interface and how to use it.

Great, I think this would be a great addition to add to the cover
letter and also add as documentation, since it is user-facing. 

> > > Measured results:
> > > 
> > > System Configuration:
> > > - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> > 
> > I think a description of this system's topology would help me understand
> > the results below a bit better : -)
> >
> 
> That is a fair point. The system used for the measurements is
> configured as follows:
> 
> - Processor:                 Dual-Socket Intel Xeon 6980P
>                              (Granite Rapids)
> - Local memory (per socket): 12 channels, DDR5-6400
> - CXL memory (per socket):   8 channels, DDR5-6400
> 
> It boots as two CPU+DRAM nodes and two CXL memory-only nodes, which
> is the topology shown in the sysfs output above. I will add this
> description to the measured results in the next version.

Thanks. Notably I wanted to see if the DDR generation was the same
across DRAM and CXL. 

> The case I had in mind is demotion and promotion target selection.
> With the package information, tiering could keep those decisions
> within a package: choosing the memory-only nodes of the task's
> package as demotion targets, and symmetrically preferring the
> package's CPU nodes when promoting, so that both hot and cold pages
> stay close to the CPUs that use them.

Yeah, I like this idea a lot.

For demotion, we would just chnage the fallback zonelist based on the
sockets.

I think we actually get promotions for free, since if this series is
doing a good job of allocating memory close to the consuming CPU, and
the demotions prevent the memory from moving cross-socket, initiators
should only promote (NUMAB2 promotion) memory that is socket-local.

> To support this, the layer already exposes per-node "preferred" node
> queries: for a CPU node it reports the nearest memory-only nodes in
> the same package, and for a memory-only node the nearest CPU nodes.
> Nothing consumes them yet; I kept them out of the placement path so
> that tiering can adopt them separately when there is a real user.
> 
> > I definitely think this series makes a lot of sense and I am
> > hoping to hear more about it. Thank you, I hope you have a great day!
> >
> > Joshua
> 
> Thank you again for the careful review and for the questions; they
> were a great help in seeing what the cover letter needs to explain
> better. I hope you have a great day too.

Thank you Rakie. I don't think the cover letter was misleading,
it was just my fault for short-circuiting and thinking the series was
about adding per-socket per-node weights, as opposed to the
restriction that you're adding to the existing weights.

If I may add one more comment, I think 2/4 is a bit hard to review.
A 1k line patch is not so easy to see the full picture, I think it would
make it less intimidating to review if it could be split up into
smaller patches. Just my 2c : -)

Thanks again. I hope you have a great day!
Joshua

