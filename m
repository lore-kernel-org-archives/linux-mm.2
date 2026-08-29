Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EECC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 23:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5C16B0088; Sat, 29 Aug 2026 19:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93806B008A; Sat, 29 Aug 2026 19:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9336B008C; Sat, 29 Aug 2026 19:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A04596B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:18:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08E581401F0
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:18:54 +0000 (UTC)
X-FDA: 85155874188.29.E6F5775
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3F43E140005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:18:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JAgz+RxN;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788045532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeUcL4nq46vAOTRNrJyFE6ffe6TtzURWgRlqZ+Mahn0=;
	b=uUyyxS6HX/Apot0yN3MfXavhKNdL6YUmTm3Eonfw6SW6hnoqmShF0wDa2zH26R62F2vAeH
	dae1hdjlqVeJKUdriPjArC3FSCZbPr8oNO+hQJ+Fm5El4k68dXprPAfbjycZOn5Xcfe2zk
	/QPgGWAWHeSkCjVmPxTfNPEh7UqXtAM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JAgz+RxN;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788045532;
	b=V1EGNUAbiIBiytfcxiar9KbA2EuiOf9hPXvJ6xbZH5HECvAuG1dBifI0F1+1svREO2DmUQ
	DuaXUB5HGTsmJ/9QbMdHuDwhO1mWrg2YK2JovM6Ab4mc5iJzUeDFLsSJNmlojDCnfxUAfR
	fNRIIBgYvukogMAKqyPRTBxm0M0YFv0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57265600AA;
	Sat, 29 Aug 2026 23:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0521F000E9;
	Sat, 29 Aug 2026 23:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788045531;
	bh=SeUcL4nq46vAOTRNrJyFE6ffe6TtzURWgRlqZ+Mahn0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JAgz+RxNvvwe4PCQRC4qC5IYds3alR+iPeLhCZqByUhsSi5jP+5ZkUOam5IVVf3HV
	 LP+8pndUSXapSJLVFClg24h6NWgeXkL+BsvgXvT3Gv6Js2U/yo3ob4U7OoYqlidLZ6
	 IfdgX8xbCZVYP6k9iF5QVCbsz2LFjFdHHPr30nIM=
Date: Sat, 29 Aug 2026 16:18:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, urezki@gmail.com,
 chenwandun@huawei.com
Subject: Re: [PATCH 0/2] mm/mempolicy: stop copying state in the interleave
 paths
Message-Id: <20260829161850.db162f9f99deb419f4700c11@linux-foundation.org>
In-Reply-To: <20260829015943.1258774-1-gourry@gourry.net>
References: <20260829015943.1258774-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: asrogic1osgki46xb5rq9b794d7tsgg7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3F43E140005
X-Rspam-User: 
X-HE-Tag: 1788045532-714829
X-HE-Meta: U2FsdGVkX1+aOBgQL26Lyu8PnG6LbNDTGZn0YvcFGIcormEDicV66c7d0rHuA5TuWHLW+2lctXDiqkhSx+8E2WSLpF5jdEywDG8FNsgGaFZM6j8B1MoLuaRmf5sl58RdQUACoOhf3nYeCoGN1QQ6+3NZhdbBf43wEPKgxDCzGHooHL1XRkMIbIfdezyIrxKt0LltAN8d/IrgvsoRHNkofMgagSZTl7elDZbcKoAC/gsiew6DJCMPIEB6uqRZ0jI7Abhf3nTQ1ns2+9AjEAUIMYOf9oEvt5fhgTMae7lCBLBkpMmRt/vxW8hTyRDfV0j2QMiRyQORti2WNRu63JHf9HqFnREQEp4AHlrkT6tLnqEYHPuKvDHs5WPMuuUJth/xOoi64IeGRjpSZUn0jgsx/fdRJblowQPLasxFQzgtLcForlRvy7Yk/UrAgN+VQH6L5BVaSwMDmstaU3CxazmzX2H6FHluI74vNubFfzNh08kxy5UixGAJpVMv62SCB0f9fdrIDFkxUr7IEzxacdcKcSiWza8aoXZNIvDWKn5undc55QxBsZKam3C05g8G8XS5405W98Fuy4MAG1o5jRRCs+kH3g6tyaIL4yZhN8+VpCv2tV2mWKMpxJnrbVyc4Ezus1/WwnSnjg+tqqhM7cEIxTjGx+vZPydcHh+BlxmRvki8d9bJZkS39XzZ650PyVK2eu6gtxfOkNX7uuT34+SPd/TB/IXYHkw/m4Y7gL4/MiQ3R+GD97xu1t2KJBjUPQcvEJjnCiRQ45RvDPwTmjz/kAT9J49oB60WIxmZ6KC4pnL2UwMsCVDbfz0Kh5aH41R6gJtpCepy4xvu2AqzthI1USrMA8Tk6p9aXCNXW7JL2IYUq+P9cKcRyEBpRC0iBc5ERbaOhLPksxHIe6tDC76ofivZ4nS0BWGZWlNrqiuwCAqdzn7DNMiYRoS1W4eOYxwvSHgshMXkzTRXOtkSBcn
 BcMNajmi
 qX5OMUZ0elRghF92lAHhFunzz9IR4lfj8y2myU/fqInwUKde5MR1yQ74E/m8HCs9Hzw/F//j5KrMsJcRW5bzsZ0qWYUqu9PNuPABVfNPO+/7GuVsBF8TktboagHFa25GyT6dcK95sh3WTuARzIP+RtDnOK+MHaeqBvAvgEcjpZzxVjNQBVq40Eqr0mrB26vs7lSD9WQzwDGK7+jS0/w/aCohXjB8xL5J/hxweHpusYJql0zjrPGyI2wLdxc5OS0GQ8Tfbtd9zd7D9Y0+bdvLqgxHjcLXsvYJalYoOm45J8Cw8ir6y5XmYO5FgjmdSEBPfbcGRvGySGYzt+ej8JlqzyIuxFlSo4xcqxtWBpVoFKjDYna9SwhYXvuiMqLAmcSuCXIP7J33zydURsN9cqus+pVMz/gu2dC7/mHAtiQJcFULOG8++HEFvJC00zkmv7cr+ledK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 21:59:41 -0400 Gregory Price <gourry@gourry.net> wrote:

> The interleave node selectors and bulk allocators take copies of
> nodemasks and node weights (for weighted interleave) in the fault path.
> Both of these copies can be entirely eliminated.
> 
> For node weights, use SRCU to pin the weights in place.  This eliminates
> a copy and a kmalloc from the bulk allocator path.
> 
> For nodemasks, we can operate directly on pol->nodes as long as we bounds
> check the walk.  A concurrent rebind can shrink the mask, or tear the read
> of it so the mask appears empty.
> 
>  - The interleave node selectors fall back to numa_node_id() when that
>    happens, which is what they already did when a copy came back empty.
> 
>  - The bulk allocator simply returns what it managed to allocate.
> 
> The node count and weight totals are read separately from the nodemask
> walk that consumes them - creating a time-of-check / time-of-use race.
> Just clamp the walk to a single pass (number of nodes), and clamp each
> bulk allocation chunk to the space left in the request.
> 
> The cost is distribution accuracy during a rebind.  The copies never
> corrected for that either - they only kept the code from dividing by
> zero and overrunning the allocation request.

Not very well, it seems.  Sashiko thinks there's a div-by-zero in
alloc_pages_bulk_interleave().

	https://sashiko.dev/#/patchset/20260829015943.1258774-1-gourry@gourry.net

> Gregory Price (2):
>   mm/mempolicy: use SRCU for the weighted interleave state
>   mm/mempolicy: stop copying the nodemask in the interleave paths

Looks nice, thanks - I'll queue it for testing.


