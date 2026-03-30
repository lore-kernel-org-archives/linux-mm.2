Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3E9FB3CEA
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD216B0092; Mon, 30 Mar 2026 05:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994936B0095; Mon, 30 Mar 2026 05:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1976B0096; Mon, 30 Mar 2026 05:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8028B6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:34:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19323BB47B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:34:54 +0000 (UTC)
X-FDA: 84602220108.12.9744E66
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 717974000C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:34:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HJENXvRm;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HJENXvRm;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774863292; a=rsa-sha256;
	cv=none;
	b=y9K9TefOaoSIIIghdpfWSIMU7rh+RHDvFsT12rapK+cKKCCBu7YWHjRIEdwXRz/7Y1l5v+
	G2SLF+AxfSybFaD/OQ7CdR57cWkGn2k/ypuH/OLLle9XmVm+KvTsz7zBAP4laPY8v0M0D+
	hQ7qPskL111nSszsO1Pl3d1YL0anXcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774863292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGkDj1PBQwxhRCTzQSOpS9DEQZkCaWieM/DJwzadiGA=;
	b=P9a43MK4U5yLDyzVv4heOTOPkgsXSt7OE8QmDM4figoseG1NplH4T46h+z/cGu0SP1AFRE
	RsmMdBwWsGsyEYrZjiiLspY2CEeVZHv8eUpwf8sCh+v6+BzAer7JSfetjiu8K5oAOQOOzi
	9uZNR+PAvx53HvpZzt94n5mIqGYvrhY=
Date: Mon, 30 Mar 2026 17:34:21 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774863287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QGkDj1PBQwxhRCTzQSOpS9DEQZkCaWieM/DJwzadiGA=;
	b=HJENXvRm2Fd5wnRz+GYvxiRAnbc7T7Ywrpjz7wQVSnzC4SJzA+ElU6I+uvySgtS0wUd0OX
	/5ZQ/FxtYE/ipg+O8+W+ZWRQ75BcHQNaMS1S2Adasam1F1KZ9GDFUyZbjIqe0UwUEsOIpS
	VZQNjUbndz9fUXMBrnGZwhVfgxSHKbQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org, 
	vbabka@suse.cz, joshua.hahnjy@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-ID: <23feu42lqvc7iymgaxmnywea7c3qie5vmjm4aijbgdiazwvrcb@mmlxjowgtotv>
References: <20260330035941.518186-1-hao.li@linux.dev>
 <aco0MtqpysMXMZdy@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aco0MtqpysMXMZdy@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 717974000C
X-Stat-Signature: et9wipnw6nyn79jqcucmneiwbus6wdf1
X-Rspam-User: 
X-HE-Tag: 1774863292-815878
X-HE-Meta: U2FsdGVkX1/U3xlJGEqUNYZ+A3IXRTQqDeLqYjA/c4X0nkl/t0WWPXa5ZXrDl3bxvhAny0pu4wp90qrtEtySTjH4AJ6b2S0k8jBAnq/uIbAs0IM8JZhP9N3OAx4MMXFEyBE9CUyYKYUWAUNyd+h/tG+GByw3p5qQr279JyILdgBc4Yg9NbjA/DhZBdNlNg254fzpWW9p3MMO71j54z2Rxefc0urHIkG+VtwzQj1jrcMq1apznynsdvQkEn4v6uvbqbZaDI+UH3Zjtdzd/I0sXGRPLUYOi0VH/x95isP8oFnGJ+DZBvjj+5bNx2hBuL2Q9zqIhDxddRpeyLLXzVjVtk7u60yD0H5AUmRbBF0+ghY7mIHLu+d2rfOWdfURcBJXg6FkAVoeQReQbrp+vNYs9N1htj4KvrgHW0wq1TZxjvEGDEy+E39Aw3BZj9MtZCqFnQwKDC+ftLYa+hX33MiR0JhzrHcrvDHWjXgnSu+gs44S4b/3OM9ToFlu+2/sq1SZl1arNyNX7SzHwgIzVdzgYslnwdGtnuAO9hMyb00uJLg9wmXRSwaCMShLhpnSJAddDfP2+jZuzTS93nOovtKjjdaj6m462kX9qs13BZhcU1H2obVP5YfL/i1xbaZw29OTzhVRy/AIhhcrK/4tGjL9/DRnZEZfWqNpjnsjplFdoGAbPPvdXi36h3vkr8ATSMtTBGx6pbHXTfOT6i7RT9xHy7Z4mlzWeNaEpEf/hWBY1J0tUMxCFk9PSFN7VgCXGyAJLGMcVRrFDrJM6vQdB7y7JfrCUin770fVcFUy24W40lh7x746Mz5g6wNbGQVbdavElFFvZBmpR7CK5MKtsp8vkFNrUuQFx4pvAfs/hIJSHusswi1C+LBS9MPv4qqfjI86qRxVtW1kXkl2UTHz9Ioijik1KaQA79NdlF4tWvi7t16VLm323tJdLiq6nwthsKgIlhtm4avRUQV6IMr3N/H
 ZQPtbZ1K
 Rou8zzcMrD1oasSw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 05:28:34PM +0900, Harry Yoo (Oracle) wrote:
> On Mon, Mar 30, 2026 at 11:57:49AM +0800, Hao Li wrote:
> > N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> > hotplug currently only updates N_MEMORY. As a result, a node that gains
> > normal memory via hotplug can remain invisible to users iterating over
> > N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> > incorrectly marked as such.
> > 
> > Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> > offline_pages(). Set the bit when a node that currently lacks normal
> > memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> > offlining removes the last present pages from zones <= ZONE_NORMAL.
> > 
> > This restores the intended semantics without bringing back the old
> > status_change_nid_normal notifier plumbing which was removed in
> > 8d2882a8edb8.
> > 
> > Current users that benefit include list_lru, zswap, nfsd filecache,
> > hugetlb_cgroup, and has_normal_memory sysfs reporting.
> > 
> > Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
> 
> The Fixes: tag indeed looks correct to me.
> 
> By the way, MM needs an explicit Cc: stable@vger.kernel.org for backporting.
> 
> Since this commit was introduced in v6.17 and we have v6.18 as LTS,
> this should to be backported to v6.18.

I had gone back and forth on whether to add the Cc tag, but I'm happy to
include it now!

> 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> 
> Otherwise looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks for the review!

-- 
Thanks,
Hao

