Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE91F5A8C7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 21:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1714B6B0088; Mon, 20 Apr 2026 17:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122086B0089; Mon, 20 Apr 2026 17:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037D66B008A; Mon, 20 Apr 2026 17:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E60EC6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:53:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 986B11A0B33
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:53:28 +0000 (UTC)
X-FDA: 84680286096.14.EBDCBE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C44DAA0014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:53:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IICn252s;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776722006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cvrz3RVroP9sqpzzTck515Pzx+7uB03ZBzSW5NYDMg=;
	b=8HgIcE7nEXWuuw+wYxC4OOak65O2nNfGcvWrUybzvOkuzO1QMVmsWvTL146GQ6BDUAJ6Wt
	nRQgylyqombae+D7wlqnj5eYgSDJ4kh5rHwvNiOviCdBXM+6/XG5P4RtV9VFJ0sv2znUcu
	NiK/hLhiIBSTjQ7nHv/NVabimj3C+y4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776722006; a=rsa-sha256;
	cv=none;
	b=Buy3AoQKHSSCO+VOVLt7N4ZWjPJR+8iTfWWYUbaeOVi/WrAGbsD59TuAaY03o6IzXMj9o0
	eUfv5Tl3Jix3XYimtmJre1e35bNLII02swg4re/ou7BxrdYrYmCp+CHbBIijYbK5R4SVGM
	PNZwmOEgONl/0EUKbJ6jiFl00x1+Xfg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IICn252s;
	spf=pass (imf25.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD80043A94;
	Mon, 20 Apr 2026 21:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5260DC19425;
	Mon, 20 Apr 2026 21:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776722005;
	bh=/HTITAzIUs8p5b+UBhSvbh4D33hLXidZbOR3NbymkLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IICn252s/tRT3ekYwmslRLAST+Vib4so+FSjcxzBkKwxL1Tj+BoYs81ooK1ut0n3D
	 FkQYU7Zp17yWlg20HWSd5yDvEfRQDvWYNM7/sD2QAaQVxwt2tB4LRIy8P85mvpOG/2
	 kd0+4frlwhGlcnJeFj7b8QyMFOAtptIB5eQrOfmxGfXoLLBB7G98n/ewU0EesV/SHW
	 X0ZWSwTIHbInaS5OjsNy5L/ZtgbfSyt+JpzNHesjEOdDNoC9dn6P9uXWkh2rS9xmsX
	 ROrL16yGThxaMnWjc+4NWxpcFJgGJ4L/FRcIughA0jPSMB9Q3GFbpuWqyJZwYXiGWX
	 q6+kVKRlPEM1w==
Date: Mon, 20 Apr 2026 14:53:23 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aeagUxlju40rvkYQ@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka>
 <aeHRLv834FCAQlQ8@google.com>
 <aeHdGf7XDjvOES1V@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHdGf7XDjvOES1V@tiehlicka>
X-Stat-Signature: 88z398uga31o5fcnqnyom9qz3aze7bmc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C44DAA0014
X-Rspam-User: 
X-HE-Tag: 1776722006-96299
X-HE-Meta: U2FsdGVkX1/NN3Lbn5qH4nWnSOT+20TLdTP8d25e9/tIBNAO2GNJwJiTJhO+PQMBxow00dM0v8MPjfAe3Vl0DsDxbQTWxdOvUyTxl7SQrjGSsjK7OD8Xtdenz3TFR2hp60tFIha0Fz4+IqyEdd1BSW0QnckB8CGf9Aur+BUaB0ISf/qz247+qtIFDWXjfxOBd2KwZyxiw4TWbgdEdx36fahlBuu0cH+633jyWCy0JfZfLMMOz/OQ95J7ApuATF/p6hc8xs/+In/4Q2pGPn+go8R8qjYfEnNq1emyfNMTItdR97/xpIUQlbhsOhltAlp5+VGRZTVf4kkr4deKV6eho/nSbQdxhUgDfaO+pSiRho0iG8ApqJpT9a6Xk4/iszBgbuhRLZlul/9XoIIm7CSZg+Zb8OsKlmPk3Z8G8avjG3CezhLDR9nDDMxORxFUmOEkqbSXQSrXSZdtYHYSV7ln90dsByfvROwhzmXBIttu6V2lSsrsSLf/AQUdmbG/LMMK9wWm8wPxXaU5CubE88N9to8ft7N5eg+/sY1OatM8696GpYIeVK27HYyzgNTZCFmbkrbk2afi6pBPmCm9jokftBPsnRRJyhY4mKfZ16NTnG/8oCEAc7JTAMNdgAZHChJVasXWKLxBIEzwfBjVQbBGmb97eoUOhUR6M+9pGKthwnFa4SB0jemMbzeK2+cRiS+m/C9MdcQhLCqu/NWvjNxtWM0J/u4DcMD3ZLDUvHS/I8st2S6vgKse2h7RVVLODn4fgH+dInC769foDQGFQ+EtfL8HwuKsCbXZlwdzNyZkaxw8tBLueM/nvgllytboLngc9bVTsPaIEFKVHZ34nGDwfE8EJH2MhL3NqY5e8DotlYGWyhnFXYf/q7CSLx8IGB4KNHjC5yFZE49tb3hvCawsFFmGRV0VDz4MxbkdEGIaptVZDsjQhBAqBgJ0H1+DdYcUW0GqndzKIUh394M87p6
 nX7tM9Vh
 eg1M8xM61slrmCQiFPbAzfKj/vmQsMX/vqjnvWB4tdE93HYjTnL5V5GxfWP3/T89OTiwRlBpFXVcgL/IOm2XkK0EMV8J3KzFaynXslzYrotALGOzc8ul/QPpJRpWLQMmietpgzd8n3ZdUx9FgzsqXBAW5H1ttJm4/+q0fQjJTkwMvth0wKyhRmIFQ4wNCGpLMpHnn8B99ukmZr3zNvhXcMrgsIcNzD908kBaQawl7FK7maNWuoJX2NYM6ocJU2v2NnoOnIOuHO3ZkAkqoQKeHyYgeY/xKAHiXkjwUx03m2Hw4Zy57VclsdpoefkJRnAlOxca0gJpaYdTF608=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 09:11:21AM +0200, Michal Hocko wrote:
> On Thu 16-04-26 23:20:30, Minchan Kim wrote:
> > On Thu, Apr 16, 2026 at 08:54:53AM +0200, Michal Hocko wrote:
> > > On Wed 15-04-26 16:26:34, Minchan Kim wrote:
> > > > On Wed, Apr 15, 2026 at 09:38:05AM +0200, Michal Hocko wrote:
> > > > > On Tue 14-04-26 13:00:16, Minchan Kim wrote:
> > > > > > On Tue, Apr 14, 2026 at 08:57:57AM +0200, Michal Hocko wrote:
> > > > > > > On Mon 13-04-26 15:39:45, Minchan Kim wrote:
> > > > > > > > This patch series introduces optimizations to expedite memory reclamation
> > > > > > > > in process_mrelease() and provides a secure, race-free "auto-kill"
> > > > > > > > mechanism for efficient container shutdown and OOM handling.
> > > > > > > > 
> > > > > > > > Currently, process_mrelease() unmaps pages but leaves clean file folios
> > > > > > > > on the LRU list, relying on standard memory reclaim to eventually free
> > > > > > > > them. Furthermore, requiring userspace to send a SIGKILL prior to
> > > > > > > > invoking process_mrelease() introduces scheduling race conditions where
> > > > > > > > the victim task may enter the exit path prematurely, bypassing expedited
> > > > > > > > reclamation hooks.
> > > > > > > > 
> > > > > > > > This series addresses these limitations in three logical steps.
> > > > > > > > 
> > > > > > > > Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
> > > > > > > > Integrates clean file folio eviction directly into the low-level TLB
> > > > > > > > batching (mmu_gather) infrastructure. Symmetrically truncates clean file
> > > > > > > > folios alongside anonymous pages during the unmap loop.
> > > > > > > 
> > > > > > > Why do we need to care about clean page cache? Is this a form of
> > > > > > > drop_caches?
> > > > > > 
> > > > > > The goal is to ensure the memory is actually freed by the time
> > > > > > process_mrelease returns. Currently, process_mrelease unmaps pages, but
> > > > > > page caches remain on the LRU, leaving them to be reclaimed later
> > > > > > by kswapd or direct reclaim.
> > > > > 
> > > > > Correct. This was the initial design decision because there is not much
> > > > > you can assume about page cache pages which are very often shared. Even
> > > > > if they are not mapped by all users.
> > > > 
> > > > Fair point. However, that's the trade-off:
> > > > 
> > > > Leaving unmapped caches to be reclaimed asynchronously keeps system memory
> > > > pressure high for too long. In Android, this delay forces the LMKD to
> > > > unnecessarily kill additional innocent background apps before the memory
> > > > from the original victim is recovered.
> > > 
> > > OK, this is really not clear to me. How come you end up triggering LMKD
> > > (or any OOM handling) when there is a considerable amount of clean page
> > > cache?
> > 
> > It's not simple to explain all the heuristics, but basically, LMKD is triggered
> > by PSI pressure (usually contributed by kswapd rather than other components
> > like refault, kcompactd, or workingset operations).
> > 
> > It then checks the current free memory against system watermarks. Depending
> > on the free memory size, file cache, and free swap, it decides to start
> > killing background apps.
> > 
> > In other words, LMKD acts as a "userspace kswapd" to assist kernel kswapd's
> > reclamation speed. It is smarter than kswapd because it has high-level knowledge
> > of which processes are okay to be killed rather than forcing slow, unnecessary
> > paing out.
> > 
> > Whenever LMKD is running, kswapd is usually running alongside it. You might
> > wonder why LMKD kills background apps even when there are plenty of clean file
> > pages. That's because the system cannot predict current memory allocation rates.
> > If the allocation is bursty, kswapd can never catch up with the allocation speed.
> > This forces the foreground apps into direct reclaim, resulting in visible
> > UI jank. Android prioritizes UI smoothness and chooses to kill background apps.
> >
> > Furthermore, when LMKD kills a background app, it expects immediate memory relief.
> > If the clean file pages of the killed process are left on the LRU to be reclaimed
> > asynchronously later, the system's memory pressure (PSI) remains high.
> > This forces LMKD to unnecessarily kill *additional* background apps before
> > the memory from the first victim is fully recovered.
> > 
> > Again, this is why I want process_mrelease expedite clean file reclamation
> > synchronously.
> 
> How much of a clean page cache do you usually drop this way?

Based on some measurements on typical device, the numbers are actually
quite significant. The total amount of exclusive clean page cache across
all killable apps was around 800 to 900 MB.

While even typical background apps often hold tens to hundreds of
megabytes, heavier applications(e.g., modern on-device AI workloads) can
easily hold several gigabytes of clean file cache all by themselves.

So by using this expedited reclaim, we can grab anywhere from hundreds of
megabytes to several gigabytes instantly when a process is killed.
That's definitely enough to relieve the pressure right away and stop unnecessary
redundant/perceptible kills.

>  
> [...]
> > > I suspect you are missing my point. I am arguing that those special
> > > hacks in the address space release path shouldn't be process_mrelease
> > 
> > I am a bit confused now. Do you mean you want to apply these expedited
> > reclamation optimizations to ALL dying processes in the common exit path,
> > rather than making them specific to process_mrelease?
> 
> Yes. All which make sense, really. I am still not convinced about the
> clean page cache because that just seems like a hack to workaround wrong
> userspace oom heuristics.

I see it a bit differently. When paltform decides to kill a process
to free up memory, they want that memory back right away.

So it doesn't make much sense for the kernel to ignore that and leave the clean
file pages to be picked up slowly by kswapd later.

In some aspects, you can think of LMKD as a more specialized, userspace version
of kswapd. It has high-level knowledge of process priorities and knows exactly
which process is safe to kill to get memory instantly. The kernel's kswapd,
however, operates globally without this specific process-level awareness, which
makes it less suited for this kind of targeted reclamation.

If we force LMKD to rely on the slower global kswapd to actually free the clean
pages, it defeats the whole purpose of targeting a specific process.

So letting process_mrelease speed this up isn't a hack at all. It's just helping
the kernel do what the admin wanted in the first place: fast, targeted memory.

