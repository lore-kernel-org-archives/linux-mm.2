Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A96C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05126B0196; Wed, 12 Aug 2026 23:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDFD6B0197; Wed, 12 Aug 2026 23:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF32D6B0198; Wed, 12 Aug 2026 23:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B721E6B0196
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:38:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E63E804F2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:38:13 +0000 (UTC)
X-FDA: 85094838066.23.2BDB13F
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6344F40002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:38:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf17.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786592291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4iNsDJOAmndy5n6Hq/NNvmYAYTm1RKE/jtFBAJLrpE=;
	b=lh50bTZXh179Jtn/vu6y/KS6dYYG7acGFsh6ZClaqg35CfodRLMYlPebWOgVdBvNRXw0zd
	NN6vBo04nH7UIGIZQDt6O6Rwb6uhO6wFpzCCCb8VyRV0YlqYhGGZRW4eFHen7gJn4vbGus
	O0DemVvwrrzH8reTKB9ao4DriNANL28=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf17.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786592291;
	b=beiKTAkXqg4c3uUwqTZq6zp9KVSMN+prIj+tShrEc34cDxXTlTy0z0YtOhduEZJkjKCvyO
	PK7TFk3OcNnKMUctKFVp12hXFm30Ox3m8ulTRpPbJyethUYPayYcYaHGJP0L3j/fUCunvJ
	ZR4lcC1vfDOWq8VQ+728kH96NVP1x3I=
X-AuditID: a67dfc5b-c45ff70000001609-63-6a7d3c1c4cf9
From: Rakie Kim <rakie.kim@sk.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
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
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Thu, 13 Aug 2026 12:37:59 +0900
Message-ID: <20260813033802.1838-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260812144955.3310684-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsXC9ZZnka6sTW2WwYm7jBZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4Mp5fXcZW0JZYsWvf
	JsYGxlmeXYycHBICJhK/F59hgrFvr3vO2MXIwcEmoCRxbG8MSFhEQFPiROsk5i5GLg5mgQ2s
	EqdOv2UGSQgLBEl0TYeoZxFQldh3WRUkzAs0ZtaKZmaIkZoS6zbeYgGxOQXsJS53vGcHsYUE
	eCRebdjPCFEvKHFy5hOwGmYBeYnmrbPBdkkIfGWXeLuriQ1ikKTEwRU3WCYw8s9C0jMLSc8C
	RqZVjEKZeWW5iZk5JnoZlXmZFXrJ+bmbGIGRuqz2T/QOxk8Xgg8xCnAwKvHwZjTXZAmxJpYV
	V+YeYpTgYFYS4a1eVZUlxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfoW3mKkEB6YklqdmpqQWoR
	TJaJg1OqgbHvQp/Wx2Iu0Zcpf/ffarDqaQnI+CG2/8FWdW27KSVn95xwq5vqfsKhIvtXtVxg
	yea3p7L2bWpbGeURrby59YhTywzHwsw7k8t+Vv2S33PrytQ1ZrOqvLV0mK5LC06Xcl2hcO3I
	swm153v21l+rEg6Kz+5lXq6+RzQhZd4W/f1iZYYz/HkPqiuxFGckGmoxFxUnAgDugx2j0AIA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02RbUhTYQCFeXfv7r0bjm5L8KZhtDDRUrMPeA0pwag3oagohTB06MVN55RN
	ZZqSNTJbJWZGuqkIhsy51KbTFFNY5WeoNSw/WCqam+UqcommYC4J/Hc4z8P5cyhM2Il7U1J5
	BquQi2Uigo/zy/xjg/aE5yUf1i8FwopGIwFtsyME7Bi7AodKdQTsG79FwPpxI4B28x8AV229
	JPw0UQfg0vw3DHZ/seNw+raBA3vNVSR8XdnPhQ0DFgIOawdwaO2oIOBn4wYXLs6egctFPnCq
	KALWraxzoeWjnQvfNLZx4OMP1QQsXJjC4URxDwfWGyVwrVVPQN3bz2SEL2rX2khUbcpE9wus
	JGrWB6KazgUOMhnuEcj0q4REfWVrOGqfCUOO5nKAHqq/E2h5EqEax08OeqK7iRpbRnG0ZPK9
	SF/jhyeyMmkWqwg5Gc+X2EdrifQCsaqjywTygfacBvAohj7GTDbYgQZQFEGLmJ5Xse7akw5g
	+u6UYBrApzC6icsMDDoxN9hFX2Y0T7d8nPZjuqx+7lqwOaPVq7GtyQCm4cUE7s48+hRjLfxB
	urOQ9mC+NnWDLX8n018+98/B6L2M2qzDioGHdhvSbkPVgGMAnlJ5VqpYKjserEyRZMulquCE
	tFQT2Py0Nm/90Uvgsp61AJoCIg+BRJ2bLOSKs5TZqRbAUJjIU3DDkJMsFCSKs3NYRVqcIlPG
	Ki3Ah8JFXoKoGDZeSCeJM9gUlk1nFf8ph+J554OZ1uYFvW9L+47fgSFeczNW/8j60Hh62t/a
	df0d45x0OS2D5KUDFw5xda7T4epcXq7pgQpP2u2zmDHAlkYdXYzhg2cjHoyi8qBNVerl3Lgb
	GTQU7GjDNdHKyAZeaO1Vtd7Zm+KqMr9fOSHf379PNW84Eu3MP++IGwtLWB1+LsKVEnFoIKZQ
	iv8CDdj8V88CAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: oksqtnh4q819ua3i8cyz435f8i5tcqke
X-Rspamd-Queue-Id: 6344F40002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786592290-19991
X-HE-Meta: U2FsdGVkX18DRiXpsLG7Xpi28eSuR7fX1wIrsy8QI0UoImG2wO0PBKIjsNjBgkFr0C8ZKA0W0+pZFvOOfKggCh7RpEoPLCDStGJuMPdKdqOI62TQVn5DITX7iAPrGkhD2pePrmKTgaJ2cwvqUpvpaWf01TMZt2/iDyZXb+59h50b+p/hnqPs8HPkrfDxk5dSuaJwSlkSP6X98USEmfD/71EJTM90hZPMKwLfBwmEHDDO/v+nH4LhqeID5uFtVb6IkU5xcSg/hc8LtPqUhgtEWcgHdtbj5mWrPPGNrh1kQ/wpFq6aWyx/+q52gjv7PNTwguJ9LTaj52OVQOl3ipFknWBdOSMx019iasL9YDNLWhj44dUijdhjFLO7R0g0yzcR6RI09Vj0mNi02x+mQ7Z0X47qGkxw03zDGjDFuP3mR2wqfje+9R/g/n74tzfnEz3U1/VR/YaQbdVCy/OyTrGrpMP2G7d4ycgUDX9zWlycfJSkjczVcFWThPyshyjuJ7i5e1zQIjK94dyRqDgX9XIup1+RKM1AO+B8ZfvYXjyfE8FZdPzeBXPByBcVFWiImyJo+oGfqrT5pPViwvTJ1OZ/sg8O4B2PizxKU6zWeNzH3iJ3zGJim3wbOW17pI/Y8xQ9czY5tbciYyd1Qr00vEO4HRuQg38228Vp1ttubBjI3A+Gsq8We2+srG29VH5vgkXaMX2cAd+xiffNH4kEC1W/TLkLnp53Iez8IydxjnH9cwnDAtb/zt90sl4bmqaDlgFtF474s7ZCvJNWHrhCjBOYqy/qcmps0wIG4pGpUjq0vaqoQ8grY8OAH0SUufXXw+kqrmgmFNn7I3nRri/weWFb7atbImi4pMU9hvrtqHwI8+ySiO+odrFRGQ+67iOo+I7ZcCIGyPTNS9f4ujLXBzSSV7o+Bufsf9fCP9mST5zWyMbOSuSu0BwBn0eSzWXx+qb9Vdh0r1yEr5qFmMBLujB
 /PibSTc5
 swTkqBTTKMcU4s7iKDKFiUjyLp6piPjlXiyzQVphv06zQY8h4VY1a666NNd0Rw+LlqA/BwBklcZlOSKbtbhdgtHXcWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 07:49:55 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

Hello Joshua,

Thank you for coming back to this so quickly.

> > Hello Joshua,
> > 
> > I am doing well, thank you, and I hope you are too. Thank you for
> > taking the time to review this series and for following up on the
> > questions from the RFC discussion.
> > 
> > > My first question is whether we want cross-socket allocations at all.
> > > The examples you gave seem to line up with node-restricted interleave,
> > > as opposed to cross-socket interleave. I think the wording that you
> > > use to describe the feature in 4/4 (which I will copy below)
> > > 
> > > > The resolved mask is by construction a subset of the policy nodemask, which
> > > > mempolicy already restricts to the task's cpuset; package mode can only
> > > > narrow that set, never widen it, so cpusets and the task nodemask remain
> > > > authoritative.
> > > 
> > > is 100% the right way to treat these package-aware (socket-aware)
> > > interleaving allocations, but the example below
> > > 
> > > [...snip...]
> > > 
> > > > Applied the same way to every source, these weights give the map:
> > > > 
> > > >               node0  node1  node2  node3
> > > > global:         2      2      1      1
> > > 
> > > [...snip...]
> > > 
> > > >               node0  node1  node2  node3
> > > > from CPU 0:     2      0      1      0
> > > > from CPU 1:     0      2      0      1
> > > 
> > > Is essentially the existing weighted interleave mechanism with a
> > > nodemask/cpuset applied.
> > 
> > The example I gave was not explained well enough, and I can see how
> > it reads as a manually applied nodemask.
> > 
> > A nodemask or a cpuset names a fixed set of nodes, while package mode
> > expresses a rule: use the nodes of the package the allocation is
> > requested from. The mask is resolved per allocation from the
> > requesting CPU, so a single policy gives {0,2} to a thread on package
> > 0 and {1,3} to a thread on package 1 at the same time. One nodemask
> > cannot do that, since it is the same set for everyone who uses the
> > policy.
> 
> Ah! I'm sorry. It seems I totally misunderstood the intent of the
> series. I think that my brain short-circuted to the discussion at
> LSFMMBPF from 2025, where I think we discussed having a real 2-D
> grid with weights per-node, per-CPU. I think my confusion is responsible
> for the examples below, which as I understand it now, are not the intent
> of the series.
>

My explanation was not enough and that is what caused the confusion.
The 2-D grid is close enough to this work that the two are easy to
place together, and thanks to your questions I could fill in a good
deal of what the cover letter was missing.


> > There is also the question of how a user would build such a nodemask.
> > The package a CXL node belongs to is not visible today: on the
> > systems I tested, the firmware reports node1 as the initiator for
> > both CXL nodes. The topology layer in this series is what makes that
> > association available, and the read-only view under
> > /sys/devices/system/package/ lets the user check it.
> 
> That makes sense. Now I really see the goal of the series and it makes
> a lot more sense. Thank you for the clarification.
>

Thank you.


> > > With that said, I think a more interesting and
> > > illustrative example would be if the user truly would want to allow some
> > > allocations to go through cross-socket, but be able to control the
> > > ratio at which these slip through.
> > >
> > >               node0  node1  node2  node3
> > > from CPU 0:     3      1      2      0
> > > from CPU 1:     0      3      1      2
> > >
> > > Maybe even more illustrative of the true capabilities of this series
> > > would be if you have an asymmetric system where you bind some
> > > host-level monitoring / logging workloads to one node (say, node0) and
> > > want that to be able to cross through to the other socket, but not the
> > > other way around:
> > > 
> > >               node0  node1  node2  node3
> > > from CPU 0:     3      1      2      0
> > > from CPU 1:     0      2      0      1
> > > 
> > > Anyways, these are just super hypothetical scenarios and I don't even
> > > know if the configuration that I'm listing would really be beneficial
> > > for the system. I think that coming up with some illustrative usecases
> > > which are now made possible by this series could help motivate why we
> > > would want to interleave across sockets.
> > >
> > 
> > These maps are an interesting idea, and I would like to look at them
> > with you.
> > 
> > This series only narrows the candidate nodes; the weights themselves
> > stay global, so every source that reaches a node uses the same weight
> > for it. Both of your maps give a node a different weight depending on
> > which package the allocation comes from, so the weight table would
> > have to become per source rather than a single global one.
> > 
> > Encoding the weights that way came up in an earlier stage of this
> > work, and it was mentioned again briefly in the RFC thread. As I
> > recall, the difficulty then was less the placement logic than how a
> > user would drive it: weights would have to be configured for every
> > source, so both the interface and the structure behind it grow
> > considerably.
> 
> Yeah, I can imagine it is quite a lot of tuning that users have to do.
> So I'm 100% on board for the goal of this series to make the existing
> weighted interleave mechanism respect the initiator's POV. Sorry for
> making you explain all of this, this confusion is just due to my
> misunderstanding.
>

Thank you. "Respect the initiator's point of view" describes the goal
better than what I wrote, so I would like to use that framing in the
next cover letter.


> > That does not make your suggestion less interesting to me. I think it
> > could work well once there are clear scenarios for it, and the
> > grouping added here is what such a table would be built on, since a
> > per source weight only has meaning when the kernel knows which
> > package each node belongs to. What I am unsure about is folding it
> > into this series, whose aim is the narrower one of raising effective
> > bandwidth by keeping interleave traffic within a package. Allowing a
> > controlled amount of cross-package traffic points the other way, so I
> > think it is a topic we could discuss separately, with the use cases
> > worked out first.
> 
> Thanks! Actually I think we can wait on this until we have real
> usecases where we prefer to make cross-socket allocations.
>

Agreed. I will also keep thinking about what such use cases would
look like.


> > > I was also hoping to see what this interface looks like and maybe
> > > discuss how we should relay the information to the users, since this
> > > seems to be a new addition from the RFC.
> > >
> > 
> > Sure. The toggle lives with the existing weighted interleave knobs.
> > package_mode defaults to false, so nothing changes until the
> > operator explicitly enables it:
> > 
> > /sys/kernel/mm/mempolicy/weighted_interleave
> > |-- auto
> > |-- node0
> > |-- node1
> > |-- node2
> > |-- node3
> > `-- package_mode -> true/false
> > 
> > The package topology view is read-only and lives under
> > /sys/devices/system/package/. This is how it looks on the system I
> > am currently using:
> > 
> > /sys/devices/system/package
> > |-- package0
> > |   |-- package_cpu_nodes -> 0
> > |   |-- package_mem_only_nodes -> 2
> > |   |-- package_nodes -> 0,2
> > |   `-- physical_package_id -> 0
> > `-- package1
> >     |-- package_cpu_nodes -> 1
> >     |-- package_mem_only_nodes -> 3
> >     |-- package_nodes -> 1,3
> >     `-- physical_package_id -> 1
> > 
> > package_nodes shows every node grouped into that package, and the
> > cpu/mem_only files split them by type, so an operator can check how
> > the kernel grouped the topology before turning package_mode on. I
> > will update the documentation in the next version to describe this
> > interface and how to use it.
> 
> Great, I think this would be a great addition to add to the cover
> letter and also add as documentation, since it is user-facing.
>

I will put it in both. Andrew also asked for documentation aimed at
the operator, so the next version will describe this interface and
how to use it there as well.


> > > > Measured results:
> > > > 
> > > > System Configuration:
> > > > - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> > > 
> > > I think a description of this system's topology would help me understand
> > > the results below a bit better : -)
> > >
> > 
> > That is a fair point. The system used for the measurements is
> > configured as follows:
> > 
> > - Processor:                 Dual-Socket Intel Xeon 6980P
> >                              (Granite Rapids)
> > - Local memory (per socket): 12 channels, DDR5-6400
> > - CXL memory (per socket):   8 channels, DDR5-6400
> > 
> > It boots as two CPU+DRAM nodes and two CXL memory-only nodes, which
> > is the topology shown in the sysfs output above. I will add this
> > description to the measured results in the next version.
> 
> Thanks. Notably I wanted to see if the DDR generation was the same
> across DRAM and CXL.
>

Both sides are DDR5-6400, so the difference in the results comes from
the path rather than from the memory itself. I will make that clear
when I describe the system in the next version.


> > The case I had in mind is demotion and promotion target selection.
> > With the package information, tiering could keep those decisions
> > within a package: choosing the memory-only nodes of the task's
> > package as demotion targets, and symmetrically preferring the
> > package's CPU nodes when promoting, so that both hot and cold pages
> > stay close to the CPUs that use them.
> 
> Yeah, I like this idea a lot.
> 
> For demotion, we would just chnage the fallback zonelist based on the
> sockets.
> 
> I think we actually get promotions for free, since if this series is
> doing a good job of allocating memory close to the consuming CPU, and
> the demotions prevent the memory from moving cross-socket, initiators
> should only promote (NUMAB2 promotion) memory that is socket-local.
>

Thank you for the suggestion. Changing the demotion order by package
sounds like the natural first step, and I will look into it once the
placement side has settled.


> > To support this, the layer already exposes per-node "preferred" node
> > queries: for a CPU node it reports the nearest memory-only nodes in
> > the same package, and for a memory-only node the nearest CPU nodes.
> > Nothing consumes them yet; I kept them out of the placement path so
> > that tiering can adopt them separately when there is a real user.
> > 
> > > I definitely think this series makes a lot of sense and I am
> > > hoping to hear more about it. Thank you, I hope you have a great day!
> > >
> > > Joshua
> > 
> > Thank you again for the careful review and for the questions; they
> > were a great help in seeing what the cover letter needs to explain
> > better. I hope you have a great day too.
> 
> Thank you Rakie. I don't think the cover letter was misleading,
> it was just my fault for short-circuiting and thinking the series was
> about adding per-socket per-node weights, as opposed to the
> restriction that you're adding to the existing weights.
>

Thank you for saying so. Either way, your questions gave me a chance
to look again at what the cover letter was not saying clearly.

> If I may add one more comment, I think 2/4 is a bit hard to review.
> A 1k line patch is not so easy to see the full picture, I think it would
> make it less intimidating to review if it could be split up into
> smaller patches. Just my 2c : -)
>

You are right, it is too much to take in at once. The patch became
large and complex because several features ended up in a single
commit. I will separate them as much as I can in the next version.

> Thanks again. I hope you have a great day!
> Joshua

Thank you again for the review and for the discussion. I hope you
have a great day too.

Rakie Kim

