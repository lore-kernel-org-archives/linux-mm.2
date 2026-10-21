Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39529606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HJp41Fmi
Received: by kanga.kvack.org (Postfix)
	id 5A4F56B0663; Wed, 21 Oct 2026 04:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5570E6B0664; Wed, 21 Oct 2026 04:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445A66B0665; Wed, 21 Oct 2026 04:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF5E6B0663
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:25:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CB85140496
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:25:00 +0000 (UTC)
X-FDA: 85345947960.19.539B7E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB02618000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:24:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJp41Fmi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+wlJA0rtb40EYpHl8bU9DDEGkk4vMgjHF45RyGHlDQ=;
	b=uXXJSV76ho8ULaoOaEEocAEBDA5CNlyeM20FajhHLs9nkK1IASepzmtQVK7Zef4BQxAkPU
	IwfdjHrBpvGQQtQl/wmc6GSKS2PX69VH6mbPNfySuzcA5mDrMREn4l3d4PXPZJJU7HFpuf
	P6Fx+IwXvqOdCHnnm9qy5+kQAYqs5B8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJp41Fmi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571098;
	b=e7z/hc/akBumCvQ0p2FDzo/LiHec7Xl+fIMCwHhsyetuepT+BDjBRckIV/m6owtlr1DwdI
	ULacYB3uvyWlTm7D+v/+0rhlI6OcCO9AKki3Kr1m4EfNR6dhdjGm9KXokOdBj4zSrn5rp4
	zM8cfH8rX9Dxf6vool/61awZLmzW6lk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E97F60142;
	Wed, 21 Oct 2026 08:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2551F000CA;
	Wed, 21 Oct 2026 08:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792571097;
	bh=J+wlJA0rtb40EYpHl8bU9DDEGkk4vMgjHF45RyGHlDQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HJp41FmiOp267MHOYY4JXF4ir7F268Bt+49x/nO1nk3Pp17O2Wsc48uRaeSYy1Eac
	 P3iFcJnNmiAeWMQ/wuyjlmAqIxMfBsrIm41S9CMGj2uSsGaQtb+K2OAc7z0lPZCeeI
	 EIShLpBVHHdWBXEl/8avMjDhbesel7q47a6bYWbEJhFWXNI10J41d3gp8RMAwR6hVd
	 sKKabIM4kGFu8Lb8iRDohmtJEpmtu0S+H8OFTA5F5JTZPUAwM6rY+dqTiP6KnNA5HI
	 NbsqF/QEfSMiDkxwTQAnE5/BZMJMJ4qWojLXAz84e12I1L4tTSEiKKB5qr4ZCdTyyH
	 cdWuvu0BX/7DQ==
Message-ID: <63521469-3829-4895-a7d9-a0f7806c58a1@kernel.org>
Date: Wed, 21 Oct 2026 10:24:48 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm: fix allocator races with memory hotplug
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, kernel-team@meta.com,
 akpm@linux-foundation.org, mhocko@suse.com, rientjes@google.com,
 shakeel.butt@linux.dev, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, muchun.song@linux.dev, osalvador@suse.de,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
 mgorman@techsingularity.net, anshuman.khandual@arm.com,
 Bessel.Wang@huawei.com, jiang.liu@huawei.com
References: <20261021023940.1940971-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DB02618000A
X-Rspam-User: 
X-Stat-Signature: z9bzodnnf4ydrukr3yjqtp7fucaor4kq
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792571098-559380
X-HE-Meta: U2FsdGVkX1/7jQ4cArvt6oEUKNG4hnBr6NQIyFY1EHTk+I0f+5vgL8DAq/4jIpVQ/9qKvB3eJEti11bphJ0v1dw1MuduATNrURiIAx1Aj0X6RdoWK43veUWsdyJumksJhtChk3rPf06vW3wp28rD/sHKiC272JFpWmJmSG4tXTttLRXYMHAtZavGMVl5wAVoVmETbxe20tu8UvjEMfRaAfno4ZjfEfwq3b7cb0Ib1DmW6jBayKSElwjrJWtx7qRZalxb6lBgl0FbNsF7XGJbjDy4uEuN0/D082QGhvT4BgKBAkmfNGYpuemuE1t8SjmPVc0TE6iVvo9QmmLEWaImAlqZCdcF0qRlY5PulstAmyooLLFLZuyyM1ZUD/qK1mxr2pWdTOxohetvqdOv2WhWUQ3boRZYPbxODH85+uebmOB+tT8pveSRD/+qy+QgbE2rkyUuAYsB1/TkqS1oiGSe+NQ9KOv3myYZawCsSfzJe6c4hoLAqxJa3HFDMJqotO4aMnYqZy3xI3G5H/uObfnWTPInGt5VBhUVxHKSeP7s/378jfR92BZGgFtxiuJvhZQKd3U7Qi6IxSCWVWro85zW9VVynv8DmJgW+oEqUqTc1d4erYG98kRsykn9oVD1jMlsfsqoeuTsuN35+wefe8kSU1MYV4JFZhGaANpCoY1EcBSyPhbPA4SdADoWEwOfsGKFlcdfoLOlQdmn/D71UXfxAEBgy0SbcxJ+YUfSDbD2It/rOl/PrTo/IADnDGMUO8TLgVP5mJWfSumKgGEtahw5TYNfcyn3Q8OU901qTlb2NUEVQuV+TsScdOFf0nzawY/v1eFPzLpu7EaFzAZbCzXMjTSN8NjJzJrttzLLWKMTrX1fvGciTKysufxmqVfvTVsT8qxMYQdXmVxsnpHx+MGhjiXvtpzsLeiZvapjNTHufR1owrVwoKNp23OpsVPOkIvISxOYdhmWRYZncz1R8hj
 mvvI/pC+
 MHK9+oE+gD7Chq+sECV+DnK7Ecvp+up5tnNKKvhZ8hwM8gVSVhj27oTBgQL67Enhp1xmKPSKEdr/j+GJNhtY8Yvtx47t0c1ACan/y1bdYwGAAujlbcXZLdWwkfid9K9QS1O7yFcpSZFyEyUi3kq3e6SfbI//rglToSEkQ+JvReP2TtnFBtaRRA1jVpdPxlNMZs81qpZMuZvIDhPySIVxccclH/JlmEomSWFlFcZDPJIdpEv8tUPahF1931i3X6zWFnUKwaNxFaxnB+iU6pPQw+znrGQIxTGTYPBJcmy9GxptNmk0Un5uCprvQcMup/2RwOvFwmctYKRiE9vo9gvlQq0rTZ4iE6s6v+DWr83VPKN9K/wUxKvisjXXjbDwROWR59tP3XmbnkjZUXiPdKEMHp1uHqXFRTf0A9YgU3iBqrMfUao8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 04:39, Gregory Price (Meta) wrote:

Usual reminder to slow down a bit :)

We have

	Documentation/process/submitting-patches.rst

Saying

	"Wait for a minimum of one week before resubmitting or pinging reviewers
	 - possibly longer during busy times like merge windows.

A lot of this here was broken forever, so there is no need to rush.

(thanks for the fixes ;) )

> Eight fixes for allocator paths that can act on state another CPU is
> updating: zonelists rebuilt by memory hotplug, and the pagesets of a
> zone that offlining empties.
> 
> I've packaged these together because they're all related to hotplug.
> 
> *** Backport note - Patches 5-7 build on patch 1: without it, their
>     retry is compiled out when CONFIG_MEMORY_HOTREMOVE=n.
> 
> Most of these race conditions stem from zonelists being re-ordered
> in-place at runtime during hotplug.  The result is a mixture of failed
> allocations, NULL dereferences, incorrect placement (GFP_KERNEL in
> ZONE_MOVABLE), node misplacement, or incorrectly allowing hugetlb /
> contig allocations on a node/zone otherwise not eligible.
> 
> Most of these are incredibly narrow race conditions, but since the most
> likely impacted machines are VMs with memory hotplug, the narrow
> condition can more easily occur when a vCPU takes a long interrupt / VM
> exit of some kind.  I've made all of these race conditions
> deterministics with a kprobe reproduction module described below.
> 
> Reproducers
> ===========
> 
> All eight races were reproduced on unmodified source in a QEMU guest
> with three NUMA nodes:
>    node 0: 3G, CPUs 0-1
>    node 1: 1G ZONE_NORMAL, CPU 2
>    node 2: 1G ZONE_NORMAL, CPU 3
> 
> And a 512M pc-dimm cold-plugged on node 1, left offline at boot
> (CONFIG_ACPI_HOTPLUG_MEMORY=y).
> 
> Patch 1 needs CONFIG_MEMORY_HOTREMOVE=n to show the failure
> Patch 3 needs mm/mmzone.o built with -fno-inline -fno-ipa-sra,
>         without which the two reads are merged.
> Patch 4 needs the reclaim_retry_zone tracepoint enabled.
> Patch 7's hugetlb case needs a 64G guest (node 1: 4G) so that one
>         memory block is 1G, with a 2G pc-dimm on node 1.
> 
> The windows are a few instructions wide, so I used a test module to
> widen them with kprobes that stall one CPU inside the window. This
> emulates an interrupt or vCPU preemption.  The vCPU preemption is the
> more likely event to cause this at large scale with memory hotplug.
> 
> Patch 1 (zonelist):
> 
>   Online node 1's first memory block as ZONE_MOVABLE, which rebuilds
>   node 1's zonelists.
> 
>   Stall the rebuild after it writes ZONE_MOVABLE into the first entry
>   but before it writes ZONE_NORMAL into the second.
> 
>   On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1.
> 
>   Before: the allocation fails, 3/3 runs.
>   After:  the allocation waits for the rebuild and succeeds, 3/3 runs.
> 
> Patch 2 (preferred zone):
> 
>   Online node 1's block as ZONE_MOVABLE, so node 1's local zonelist is
>   [MOVABLE, NORMAL].
> 
>   On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1,
>   whose preferred slot is NORMAL, and stall it after it loads the zone.
> 
>   Offline the block, which rebuilds the list as [NORMAL] and moves the
>   terminator into the preferred slot.
> 
>   Before: NULL dereference in get_page_from_freelist(), 3/3 runs.
>   After:  the allocation succeeds from ZONE_NORMAL, 3/3 runs.
> 
> Patch 3 (slot reread):
> 
>   Online node 1's block as ZONE_MOVABLE, so node 1's local zonelist is
>   [MOVABLE, NORMAL].
> 
>   On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1
>   with nodemask {1}, and stall it after __next_zones_zonelist() tests
>   the NORMAL slot for NULL but before it reads the slot again.
> 
>   Offline the block, which rebuilds the list as [NORMAL] and moves the
>   terminator into that slot.
> 
>   Before: NULL dereference in zone_to_nid(), 3/3 runs.
>   After:  the allocation succeeds from ZONE_NORMAL, 3/3 runs.
> 
> Patch 4 (tracepoint):
> 
>   Online node 1's block as ZONE_MOVABLE, so node 1's local zonelist is
>   [MOVABLE, NORMAL], and enable the reclaim_retry_zone tracepoint.
> 
>   On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1, with
>   its get_page_from_freelist() calls failed so that the slowpath reaches
>   should_reclaim_retry(), and stall it in zone_reclaimable_pages() for
>   node 1's NORMAL zone.
> 
>   Offline the block, which rebuilds the list as [NORMAL] and moves the
>   terminator into that slot.
> 
>   Before: NULL dereference in the tracepoint, 3/3 runs. With the
>           tracepoint disabled, no oops (1 run).
>   After:  the allocation succeeds from ZONE_NORMAL, 3/3 runs.
> 
> Patch 5 (zonelist slots):
> 
>   On one CPU, allocate GFP_KERNEL with a nodemask, and stall it after
>   the iterator approves its first zonelist slot but before the
>   allocator loads the zone from that slot.
> 
>   Online node 1's first memory block as ZONE_MOVABLE, which inserts
>   ZONE_MOVABLE at the front of node 1's zonelists.
> 
>   This was run for single-page and bulk allocations, and for a
>   single-page allocation whose fast path is made to fail so that the
>   slowpath's walk races.
> 
>   Before: nodemask {1} gets a node 1 ZONE_MOVABLE page and nodemask
>           {2} a node 1 ZONE_NORMAL page, 18/18 runs.
>   After:  nodemask {1} gets node 1 ZONE_NORMAL and nodemask {2} gets
>           node 2 ZONE_NORMAL, 18/18 runs.
> 
>   The check adds 5 instructions to an order-0 allocation on x86,
>   counted with a hardware counter on a non-debug build.
> 
> Patch 6 (hugetlb):
> 
>   Reserve hugetlb pages on every node. On CPU 1, fault a hugetlb page
>   bound to node 2 with mbind(); the pool walk uses node 0's zonelist,
>   where node 2 follows node 1. Stall the walk after it approves
>   node 2's slot.
> 
>   Online node 1's first memory block as ZONE_MOVABLE, which shifts
>   node 1's ZONE_NORMAL into that slot.
> 
>   Before: the page comes from node 1, 3/3 runs.
>   After:  the page comes from node 2, 3/3 runs.
> 
> Patch 7 (alloc_contig):
> 
>   Write 1 to node 1's 1G nr_hugepages, and stall the gigantic page's
>   zonelist walk after it approves node 1's ZONE_NORMAL slot.
> 
>   Online node 1's first memory block as ZONE_MOVABLE, which inserts
>   ZONE_MOVABLE into that slot.
> 
>   Before: the 1G page is allocated from ZONE_MOVABLE, 3/3 runs.
>   After:  the 1G page is allocated from ZONE_NORMAL, 3/3 runs.
> 
>   Calling alloc_contig_pages() directly with GFP_KERNEL in the first
>   guest, as in patch 5, nodemask {1} gets a ZONE_MOVABLE range and
>   nodemask {2} a node 1 range before, 3/3 runs each, and neither after.
> 
> Patch 8 (pagesets):
> 
>   Online node 1's block as ZONE_MOVABLE, then offline it.
> 
>   Stall the offline before the zone empties, and stall the vmstat
>   worker on another CPU (kicked through /proc/sys/vm/stat_refresh) in
>   decay_pcp_high() for that zone. Let the offline free the pagesets,
>   reallocate the freed percpu area with a known value, then release
>   the worker.
> 
>   Before: decay_pcp_high() runs on the freed pageset, 6/6 runs. In
>           1/6 the area was reallocated before the worker resumed, and
>           decay_pcp_high() rewrote the new object.
>   After:  the pageset is not freed, 3/3 runs.
> 
> All eight reproducers also pass on the series tip, 3/3 runs each.
> 
> Changes in v3
> =============
> - Replaced v2 patch 2 (zonelist_zone_valid() recheck) with patch 5,
>   which checks zonelist_update_seq whenever an allocation succeeds
>   (Vlastimil). A raced attempt's page is discarded, so a stale preferred
>   zone can no longer affect the result (Sashiko).
> - Moved the NULL dereference fixes ahead of patch 5.
> - Added patches 6 and 7 for the hugetlb pool walk and
>   alloc_contig_pages(), which have the same slot shift.
> - Added patch 4 for the reclaim_retry_zone tracepoint's re-read.
> - Fixes: tags on patches 2-6 now name the stop_machine
>   removal that made rebuilds run concurrently with zonelist walks.
> 
> Link: https://lore.kernel.org/linux-mm/20261014222456.2318284-1-gourry@gourry.net/
> Link: https://lore.kernel.org/linux-mm/20261015210539.3243563-1-gourry@gourry.net/
> Link: https://lore.kernel.org/linux-mm/20261019172346.3344005-1-gourry@gourry.net/
> 
> Gregory Price (Meta) (8):
>   mm/page_alloc: detect zonelist rebuilds from memory hot-add
>   mm/page_alloc: snapshot the preferred zone against shrink rebuilds
>   mm/mmzone: read each zoneref slot once when filtering by nodemask
>   mm/page_alloc: pass the zone, not the zoneref, to reclaim_retry_zone
>   mm/page_alloc: retry allocations that raced with a zonelist rebuild
>   mm/hugetlb: retry the pool walk when the zonelist is rebuilt
>   mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
>   mm/page_alloc: keep a zone's pagesets when it goes empty
> 
>  include/trace/events/oom.h |   8 +--
>  mm/hugetlb.c               |  13 +++--
>  mm/mmzone.c                |  11 ++--
>  mm/page_alloc.c            | 106 +++++++++++++++++++++++++++++--------
>  mm/page_alloc.h            |   3 ++
>  5 files changed, 107 insertions(+), 34 deletions(-)
> 


-- 
Cheers,

David

