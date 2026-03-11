Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C35C103E2E9
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 22:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79B86B0088; Wed, 11 Mar 2026 18:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD4B6B0089; Wed, 11 Mar 2026 18:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C093C6B008A; Wed, 11 Mar 2026 18:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD0176B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:23:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52BBEC1C65
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:23:44 +0000 (UTC)
X-FDA: 84535210368.06.FF2CA07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B3C2D1C0002
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:23:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FeHRPAuo;
	spf=pass (imf20.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773267822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHs3xR5Se3YZpNYXYKMYNNyGO8X65iRZ5Ar425fORQU=;
	b=xDROFMc9oJZnbDPpPGiOUEWZfHukqeD1YNziOEl5N0ccorgWTeO7dU+2tAUOUtswpuAHYi
	d2jEIvUtTecza5N0PMzvSxgt/fpmhDCYrnOwZ3aLy36J5C24JClht8vxA195wiIxtN9vkG
	wloGccY7oSrixA6I7iWtlHFQCh5Xq3M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FeHRPAuo;
	spf=pass (imf20.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773267822; a=rsa-sha256;
	cv=none;
	b=QLcgDMhbuP3Icd542RUdt3fDRZpJa9KFdpWS41c5KloWbBCGvyQLv5ce9yk2h7PRKFANuY
	Mc5eXdYJtdsUTzEB5E0DERthvlbeUNw2TlesBiZ2MjnWhoAzAx/ClsgbWpMjssO+Y639V6
	XuWF7AvvnYuX57jHo81Os1LFMMZMJrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D8686012B;
	Wed, 11 Mar 2026 22:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BBFC4CEF7;
	Wed, 11 Mar 2026 22:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773267821;
	bh=vNQT44UR5S7io6hYR318cyqfrKmzItN1fXmEUKzW/FU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FeHRPAuogMNRiB8G5ICCZu3caqsUfYCD+oSm5TCtz9JTaWZ8VaP0YTNEHXM6A0sz7
	 oBGu9yCKuNu1jGvN3ZDLvDcAq6qW3jS3f+/iQ+ESmw7490jUrTRgTnSYiRpPjsK2EO
	 jJWHrn35MPBI8Hr4eWuzjS5ECSbhaOxUZZyaqCS7S2+P4mVrKYu4WmexzUKhLYaHGL
	 pqZX21nQuRS/RiLDg8CyxfqCAVGbAt+4fccp2/NsLFDkL5qyhN6WbT8l94xWTbr8Vy
	 vGS2ud63GtFRK8Gr3PumhVpc5TsqJ8FhqdyYiG44bwox1ZlW+YvENMZVtCHFjODDro
	 s/5dr6wdY7vrg==
Date: Thu, 12 Mar 2026 09:23:35 +1100
From: Dave Chinner <dgc@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: switch deferred split shrinker to list_lru
Message-ID: <abHrZ7VoRIU71vAH@dread>
References: <20260311154358.150977-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311154358.150977-1-hannes@cmpxchg.org>
X-Rspamd-Queue-Id: B3C2D1C0002
X-Stat-Signature: gzdfjot68c5we7fbdjeicpt6if9dnsce
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773267822-922377
X-HE-Meta: U2FsdGVkX18J8EodDCZAOncwy53DzAaQkV6MGPsXqzCVU749t+g+WyqO+zDZovXCaNCIg968+tlo2IGMgAWQQzb+cccsZuxf1GMsUtNb830jnNyFQqWFPd5gSZpyTGYeuLC+9kHriB/KMDQ2UM8DxFZrYYrGJp2OOWiBn6yd41LB87e61YJzUWoY9Bk6DvABApwY5yHBYrQv4GYKWQcZcMDSR7q4s6opt8L/b1oqd0PM+DMuEoveq0CTKPelwG7iC99m+itOvaaiF1V4id9nZ4dazCZzOVGMYUuN/ZWPFS9cyHIIaYe3kYN6pCZEtkdqRqlGXqCXB01y8CoLSKFyldf1eBHAn4r2lHQSPqYoksDzUZmP+EsJsJv/JfcaS1moKGzTNFu4bh7uyT+QqgXp542Z9dXqJ/IS0aFBTIAQlB5v2hrrO7XIXqdvasr0zRopnGU6zL7Xhaf2Nfn3TDlWxst/o+I9AHy1ul1PX1Fr5bSJFdjAFtCV3c5pbse/4zn061yeHOXDYCz4j80+Yd18NGMcp9cKMZlUyeo6rzpNHMH+p9ean85BgguGNcBGvo1Px/26wqLAZGhiRjkNSkH2Bbb/f0038B2l/UaSCIuE6+u/xTGtX0fNN9L5toN+rUdQSIqLgSQwfkB5JBE11e7OLgq480Xt4FgOi22foob8FUfjkuLiKUMQGKzr59aN4X2dB6g5ZzVUDGVL3eKwyfPyAYz1ZRzHiYf5K09CUunATKzyj2Y0t7pHDq9lw0a1G6VZH5Y3+D4S1CQjJYPxnS8gtRY+eK6iFYDbxERN7aON+bohwRmGoend6Cd/1eFL8PwfOeEoiOg48R+2LU/ErONY/n5k3Fu/FGZOSHhfSXfvCcWwJuRhcfwjEXm4U0USrpqCnlnUcxYjU1XxhUC8dpZoj3wZFS6xMMtl33At8XZd49euK9Ek6IW/mSCa3yVljGTOoOuKOueu5vX0ticM4kg
 /xnNXXPD
 kdgb67F2SpXli3mDOnvzl8L9BEf0B1k7eY4KmGPMydmNc04gr6zrTUdtiRhljVrtFrFiGf9ukZHvo9Pgi56y5trJScImoBAseCaOzkg6Beq3cNCmezRiOR5ao3xDxV93+RN6fxFL7LLrNq5+/JT+b6R2gaiU/unTIQT3IxgeqYJLme63phaPoh/tXNi3WyeM2vFWU2Yi5Ug444p/1M09BNNmSyBOTt9St/+b4D/JaoRJFbhXetSMJv5E9jWG7ToiUIbFFxTkMISKagoY06IMWoYKKkojDmzlfnGSY4TOHZHLU0cN5pzgCGceKd9gTcIiKOsgohIs7+0L1DbC0D8XSdUm7rv0cdS4jRfQsxq+Kq5v/3pamktw+PvTOnW4r1a3vmazn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 11:43:58AM -0400, Johannes Weiner wrote:
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
> 
> 	alloc/unmap
> 	  deferred_split_folio()
> 	    list_add_tail(memcg->split_queue)
> 	    set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
> 	for_each_zone_zonelist_nodemask(restricted_nodes)
> 	  mem_cgroup_iter()
> 	    shrink_slab(node, memcg)
> 	      shrink_slab_memcg(node, memcg)
> 	        if test_shrinker_bit(memcg, node, deferred_shrinker_id)
> 	          deferred_split_scan()
> 	            walks memcg->split_queue
> 
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
> 
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
> 
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> memcg_list_lru_alloc(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
> 
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.
> 
> The folio_test_partially_mapped() state is currently protected and
> serialized wrt LRU state by the deferred split queue lock. To
> facilitate the transition, add helpers to the list_lru API to allow
> caller-side locking.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/huge_mm.h    |   6 +-
>  include/linux/list_lru.h   |  48 ++++++
>  include/linux/memcontrol.h |   4 -
>  include/linux/mmzone.h     |  12 --
>  mm/huge_memory.c           | 326 +++++++++++--------------------------
>  mm/internal.h              |   2 +-
>  mm/khugepaged.c            |   7 +
>  mm/list_lru.c              | 197 ++++++++++++++--------
>  mm/memcontrol.c            |  12 +-
>  mm/memory.c                |  52 +++---
>  mm/mm_init.c               |  14 --
>  11 files changed, 310 insertions(+), 370 deletions(-)

Can you please split this up into multiple patches (i.e. one logical
change per patch) to make it easier to review?

i.e. just from the list-lru persepective, there's multiple complex
changes in the series - locking API changes, new locking primitives,
internally locked functions exposed to callers allowing external
locking, etc. These need to be looked at individually and in
isolation so we can actually discuss the finer details, and that's
almost impossible to do when they are all smashed into one massive
patch.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

