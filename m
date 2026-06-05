Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD029CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4E9E6B0096; Fri,  5 Jun 2026 14:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFEF66B0098; Fri,  5 Jun 2026 14:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED796B0099; Fri,  5 Jun 2026 14:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7CA46B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:20:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 845FA1C0E8F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:20:57 +0000 (UTC)
X-FDA: 84846675354.09.4A03E90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD893A000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:20:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6j2xosM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780683655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+zVvdL1dXafGmhtKQIc5JAjS1cg9OS8KCtGRJH3gyw=;
	b=xW+ogaOHhWoO5uQXcLmCgxMgRxqNlgDL87mHp7CzoHBdw4sXxylSYLlY9BOa0PgXAifB+e
	3/lGBSmhP9y1/I1IhSIrxHA91doAeZhz42YvX+vr2zp0JeThRu8JM9g4hceoqxvEHFvI8M
	P9GJ7RGi1+fJHmCnsYYg05AINSZexr8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G6j2xosM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780683655;
	b=2QLq/mdDFhfm67DmbSIWXi2Gg7G7wNMlx8pQ/BTsWoUJqmDxLxF6L8+ePqSGXCgcQqQtTY
	716BxqP0Qnp//dcZtzBxfjeEMjgZNGQ87N8xKm021YDLxe6HPDsrPha/OBHaXpGPUaCmGD
	3W2njmPVKv+7824BhrvcaWsqYx7ylRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FBB8601DB;
	Fri,  5 Jun 2026 18:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5771F00893;
	Fri,  5 Jun 2026 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780683654;
	bh=r+zVvdL1dXafGmhtKQIc5JAjS1cg9OS8KCtGRJH3gyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G6j2xosM+nK/vGyDuiWC5HPu28msvGJihCctYNYSbrCCHx1W1zU91cb6B/2sv+Iyj
	 3MooWXDSODBUEZz/OdfZz0wBnlFUcrGt4t85nSG9XiYqnNUvrDFsEGLTjZqXicf8e6
	 pbE1JeALaahtaOQEIowFTXyapGPdBr01DWTmU93N4gI/NpqxbRdLHCoTHKJyraRWsY
	 +Uh+y7hIFgMLZub0+5lnSjn5InOrwj/Ho3bUI1zqkQgGoZx+o2qCDusTxCt6ZCdp7F
	 jFt8tLKKLB72G2kraakYZOgYrx8jslacyh/sJuoKirFoV2UhxyAfMKvizJhkvNdPZC
	 eRe0tKBIY0Irw==
Date: Fri, 5 Jun 2026 19:20:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH mm-unstable v19 14/14] Documentation: mm: update the
 admin guide for mTHP collapse
Message-ID: <aiMTFl2vvns1_dn3@lucifer>
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-15-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605161422.213817-15-npache@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BD893A000D
X-Stat-Signature: nhxdb57hkha3ddyerbqnmssixeb6ewhn
X-HE-Tag: 1780683655-642773
X-HE-Meta: U2FsdGVkX18rJXkBslVZBsbAfoDVGfDM7TG/SwUPaFvVyoht9TyYVXpSM6ZYHs8TlZ4c5n0ksZPMYvOOqOpMEWGdQlcbAzof32uGzFyyCpZ4PHDkhKFljpHN+WY/g78dy84UbLZjfBrl5RvSt/eAgIx54uQyaACO2A0Xs4pN7txzymFCLA4VhxdzefDWsVyYwYoY+dv1E/HkEV5Fbt/ppZ92T12h9UaVjF6zefki1gH6i0cvcqO1mU0xJ/gIh4g72bDtD28FEQpr4qj4SxBcRdysWfBIBBOfRhzrSpjuVuEJ1x1cuXdtxM+m58IzizgYEJdBEWAgVRLU/p8PZ2O30tGnMG9Qc1hcjKZekN52NTYPD5o78ijTEAv6TNAbl0DMxAmPei8FjgT2ghbCQzG659B+vWvp0SeG7Ef4h+F9e8uY8qTVGhT/uvm33OlLrDLj5sSMAFV8oUtV/QCQwLy6XqejpRSa8o2XaXsXviOtbwlU80I5ko1Xg9PAdhnOu5tLv0BXySCGoZhGckpwEjGFBd5djPD4pvfWU43HWOzFEUMEHTVMuHtPDXAwF/aUv7uBsxf9rn2EKOtuoda7fDQgt3XG6xr7OM/TbzsujST+Z4MKt1jecPgzIiwJ8Ex97HOfu5UAitxGHhXrkDENrsoPeLYf8AY9y5T3VFuQutlrQdt8/sejrCGtzoHbh9zwPuueMd1LgoerY3iIyqoJXtHcuiwlXzyHdJJGJFaZ90xs4pEM4e8fjDMVk8/g+7RLXtgTyBXn51z2QuuAt49r6t/31Ww3XNxak/v/i/fxMNYSOG/qufDx7eICv2RIwI1VfrQ4+zcNR8mOn1B10MbhrD0gpJ7BTn3frjIa005RCSQ2cNyt/cdMnJEWTeGbZ4xQz5hw/T5SX8MEVk2KySweHxa3aoPrjv0n3oPW0TETdl/x17P2eT39q8PNMZyFXTw6W+hzq58HPUkxV1vtA010vMf
 96THZGsh
 3Rg7xFHTW5vbjoB8NH8TduH2pt9vIa8IsU0s4Klp/aSKqTWkuBuHrw7GxAFBNfi0iAlpnHO4ND/o5eTfsWFLExHF8brOTMZYDB+zcb6ciL598reVueM1X0LppweYaBXDL3daNPSehJLDuarojMLWbd0IRTVdwc2WQsEK2gDHAeqcU9c+eE9GYdg/zwdgP6bZ7JKEyxBGg043vA0AlwYCXT8F8zLmY3zwLFPZpvsq1bDbMVIZsZoNN654kcMj9UC6o354lKkqUt11ORAn3PIWhY93KbOHCDpqxXrBn36RcwtOhEdsOO8kynf7N0aV8owxvCQGaOiJRUPUU1awC/y9pso+eEgeKl+X1dqgqditzmXWmgozzmUg2kVzEtKuWCQ4u+CN13qQ/Qazap//NZvdUR2z/vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 10:14:21AM -0600, Nico Pache wrote:
> Now that we can collapse to mTHPs lets update the admin guide to
> reflect these changes and provide proper guidance on how to utilize it.
>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

This is completely fine, and no blockers, but just a couple tiny things
below Claude brought up for a possible trivial follow up.

> ---
>  Documentation/admin-guide/mm/transhuge.rst | 49 ++++++++++++++--------
>  1 file changed, 32 insertions(+), 17 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index b98e18c80185..23f8d13c2629 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -63,7 +63,8 @@ often.
>  THP can be enabled system wide or restricted to certain tasks or even
>  memory ranges inside task's address space. Unless THP is completely
>  disabled, there is ``khugepaged`` daemon that scans memory and
> -collapses sequences of basic pages into PMD-sized huge pages.
> +collapses sequences of basic pages into huge pages of either PMD size
> +or mTHP sizes, if the system is configured to do so.
>
>  The THP behaviour is controlled via :ref:`sysfs <thp_sysfs>`
>  interface and using madvise(2) and prctl(2) system calls.
> @@ -219,10 +220,10 @@ this behaviour by writing 0 to shrink_underused, and enable it by writing
>  	echo 0 > /sys/kernel/mm/transparent_hugepage/shrink_underused
>  	echo 1 > /sys/kernel/mm/transparent_hugepage/shrink_underused
>
> -khugepaged will be automatically started when PMD-sized THP is enabled
> +khugepaged will be automatically started when any THP size is enabled
>  (either of the per-size anon control or the top-level control are set
>  to "always" or "madvise"), and it'll be automatically shutdown when
> -PMD-sized THP is disabled (when both the per-size anon control and the
> +all THP sizes are disabled (when both the per-size anon control and the
>  top-level control are "never")

Claude was very pedantic and said we need a full stop here :P

This is not a blocker, obviously...!

>
>  process THP controls
> @@ -265,8 +266,8 @@ Khugepaged controls
>  -------------------
>
>  .. note::
> -   khugepaged currently only searches for opportunities to collapse to
> -   PMD-sized THP and no attempt is made to collapse to other THP
> +   khugepaged currently only searches for opportunities to collapse file/shmem
> +   to PMD-sized THP. Only anonymous memory will attempt to collapse to other THP
>     sizes.
>
>  khugepaged runs usually at low frequency so while one may not want to
> @@ -296,11 +297,11 @@ allocation failure to throttle the next allocation attempt::
>  The khugepaged progress can be seen in the number of pages collapsed (note
>  that this counter may not be an exact count of the number of pages
>  collapsed, since "collapsed" could mean multiple things: (1) A PTE mapping
> -being replaced by a PMD mapping, or (2) All 4K physical pages replaced by
> -one 2M hugepage. Each may happen independently, or together, depending on
> -the type of memory and the failures that occur. As such, this value should
> -be interpreted roughly as a sign of progress, and counters in /proc/vmstat
> -consulted for more accurate accounting)::
> +being replaced by a PMD mapping, or (2) physical pages replaced by one
> +hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
> +or together, depending on the type of memory and the failures that occur.
> +As such, this value should be interpreted roughly as a sign of progress,
> +and counters in /proc/vmstat consulted for more accurate accounting)::

So Claude said maybe it's worth mentioning that the per-mTHP counters are only
actually exposed through
/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/ and maybe worth
mentioning here too?

>
>  	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
>
> @@ -308,16 +309,21 @@ for each pass::
>
>  	/sys/kernel/mm/transparent_hugepage/khugepaged/full_scans
>
> -``max_ptes_none`` specifies how many extra small pages (that are
> -not already mapped) can be allocated when collapsing a group
> -of small pages into one large page::
> +``max_ptes_none`` specifies how many empty (none/zero) pages are allowed
> +when collapsing a group of small pages into one large page::
>
>  	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
>
> -A higher value leads to use additional memory for programs.
> -A lower value leads to gain less thp performance. Value of
> -max_ptes_none can waste cpu time very little, you can
> -ignore it.
> +For PMD-sized THP collapse, this directly limits the number of empty pages
> +allowed in the 2MB region.
> +
> +For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1) are supported. At
> +HPAGE_PMD_NR - 1, we collapse to the highest possible order. Any intermediate
> +value will emit a warning and mTHP collapse will default to max_ptes_none=0.
> +
> +A higher value allows more empty pages, potentially leading to more memory
> +usage but better THP performance. A lower value is more conservative and
> +may result in fewer THP collapses.
>
>  ``max_ptes_swap`` specifies how many pages can be brought in from
>  swap when collapsing a group of pages into a transparent huge page::
> @@ -337,6 +343,15 @@ that THP is shared. Exceeding the number would block the collapse::
>
>  A higher value may increase memory footprint for some workloads.
>
> +.. note::
> +   For mTHP collapse, khugepaged does not support collapsing regions that
> +   contain shared or swapped out pages, as this could lead to continuous
> +   promotion to higher orders. The collapse will fail if any shared or
> +   swapped PTEs are encountered during the scan.
> +
> +   Currently, madvise_collapse only supports collapsing to PMD-sized THPs
> +   and does not attempt mTHP collapses.
> +
>  Boot parameters
>  ===============
>
> --
> 2.54.0
>

Cheers, Lorenzo

