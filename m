Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41D9AF33A7D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1EE6B0088; Thu,  5 Mar 2026 09:57:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70036B0089; Thu,  5 Mar 2026 09:57:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F046B008C; Thu,  5 Mar 2026 09:57:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 876976B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:57:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3597B1B5132
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:57:26 +0000 (UTC)
X-FDA: 84512312892.03.1AFDAE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7B8FF4000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:57:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E5aWxIL9;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772722644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPsMlTXN+jihkMNquu01LXfDgqsMeUu2V8/GXSWSYCI=;
	b=goBScXFxB6+rRG3uK6A2+WuYge3SS6wie1tBOpuVkKeSgJv48p9OBjcNb/r5PHypYvMBu1
	tMa7cXWtFMPlDu/dZ79ffVKW2Zut5EGMiZvkHYySQfpvubtjY/WFZK/Pa3VZvLNCV76d1k
	YwB8e2A99lNArz5cRXpjjJjeQmoevNs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E5aWxIL9;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772722644; a=rsa-sha256;
	cv=none;
	b=PieIp4Z9uQVuXX3u/QOwz5ftCAUNrpFVmiGzDw+7Q5kJJYHQSTaF6GXG4XnRZ31GBCmlta
	SMnnX4f5xksgbcKVhcARvG1IplFmDvSP0XJMIAs/AaasDYch3qw9IkpdQWSkP3Ti87hvNj
	t3RaNKVFnj+aL8hx6cBHl/xKRLTgZAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46EEF43CB0;
	Thu,  5 Mar 2026 14:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D36C116C6;
	Thu,  5 Mar 2026 14:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772722643;
	bh=IEc4WYX37mgMOxzZzlTDIloDSaDnVqxnv/57atbWyWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E5aWxIL9Xu+PK4R9e7q1xeRi0FX0o9xCenpXCKB0U4U+owli7skTbsyyslJA/lkPm
	 R1YydSBWrVKOZGhRUvXAWj/YIErLLyuPQ5CvZcOdjAIV/VqRMJ3IfAFzGQA2D8Yjvj
	 9s3IMZSw4W0eZH9QmIOn4I93x/3BEGL7B06H5A/d0q5RyJFzI1KcN8x7Id7K6/6qmr
	 9xDu1wb90DW+DVRqFOzY8R1yR5SiCywbr+jN2MWhNOIh4pbj09o2XUuATQM+Lvktd6
	 65asY8zz6HYED2m/Ji7XhXjpm+WkbdwPmj1O5hMbwnNl5R+ySaNmpys6O+iFYPQnlj
	 GFXci6SveISgw==
Date: Thu, 5 Mar 2026 14:57:15 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Usama Arif <usamaarif642@gmail.com>, 
	Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v1] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
Message-ID: <ce2f4343-8bc4-4edd-a922-dd71a09a34e3@lucifer.local>
References: <20260304155636.77433-1-david@kernel.org>
 <b24be8c2-32d3-4e3e-9fbf-8a0068c360d6@lucifer.local>
 <c5330f9e-db41-496b-b580-73ebec9cd811@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5330f9e-db41-496b-b580-73ebec9cd811@kernel.org>
X-Rspamd-Queue-Id: 7B8FF4000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 5ku4q1x5dyw7hqogag19mwq4fti3y49h
X-Rspam-User: 
X-HE-Tag: 1772722644-351414
X-HE-Meta: U2FsdGVkX18ZgGy2nVHP4+NW8bKUuehMikAsYoOIvzsE5jRMzjc0yf2YoUD7b88YOIi/xGbIRu5WN4NSQ4yD2xTytfdCAeTd8EZvCKYSD4Vbc4tyLWh8oSXSPzQr3Ns7sYMyNnxvGJBQF/rvZl/19G5/EN2ob94UTnzQeW6x3w8BIxN3FbjANZ8LOD8t3k/GCGbDfmjFUomVRLoPS2/XdCMavoIHmtIKHDQOsbRJLZo4eIVFxIs/f1O7YAkfpwdPY+xBzz32vEZBrfOj8ykUL8BR5cBmqF9AVB9jEOKtGgj3x8QHPqZY4GguBcIGhPd/S2fs7cjvp9uQqb5aJHvVJdN3F6GtyE1uFwDIhkNVas4WtXRPmi+ILceIknhR+daqofALUbHaqtyktf+JPXViUdzn2iuY2TJ8vJHRDre13h4na5WtcIi9dWG6btlDNHxoiAwbC3qWuU1ZoPXAlGdVpTCcn7ZAyuJj32IqPAqJ3G6IyOv8eKkkAPoxv1+PlLzcwL8Oho2Uz5V8zYkH3JBUb6e+5QWIe/pXsw3++Wgu5S4NvT/gB83buokvr5VIQhKfsaPhCKaQqpCap4DSs/TuNHAYVF16oCza4ouc6mCywWZ4X2pzd+p8pOwa65RDL3HHnwcsnFVE4R1lii4oUEkza4xScEqLfqWoEjuJF6LXcoH5WEsH8Y1RhDB6eEZhlCZd5eWD9aTCXbNLti65aNFPKJr5vTOHfUnwrxTxvQO14Q4ReHmjUMGuusbH2lf1owJ4NYWyE1EW3e0/NmBQyw/SjRtXPlrzXApQrLP2ZYGw73OTgMNM3yPYwCYJW9CeS0moI9HI5OL0XMVErwAXHlWKYMxxIHHGiE8sE91DyDunwsF6jHjw5bl9zk+1SBwS4b7aIkrMEU+y5fVrPDLGqQQ1qB3yL7DjtZBipZ4mUIIhZcjePBYxbu1I5D8cgJT4ldPIrAaSoj1tPz2wE0HtWGz
 4nH2a0Ei
 /OBroe4kOC3ITOO+LohktU6U8IrFLYK4Ddthzf77Wsf6TkINZOEUFCGJr513/B5axrhntETqMPUiPODjgn4Kd7NSrftSNfr3IrITr0GbWPT+70Eygs0JIGSWyEuZ918aBRsWz7aYN3pOtCkls8GAt2ac/FU7vAJclOQcOENWiVx+Kyl8vzRNWVK423rxOTRQsiTw7Xj7sojiM3arUAr/A/q05rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 02:32:49PM +0100, David Hildenbrand (Arm) wrote:
>
> >
> > Ah wait you dedicate a whole paragraph after this to tha :)
>
> Correct :)
>
> >
> >> +mapping that is currently resident in RAM (RSS); the process's proportional
> >> +share of this mapping (PSS); and the number of clean and dirty shared and
> >> +private pages in the mapping.
> >> +
> >> +Historically, the "KernelPageSize" always corresponds to the "MMUPageSize",
> >> +except when a larger kernel page size is emulated on a system with a smaller
> >
> > NIT: is -> was, as historically implies past tense.
> >
> > But it's maybe better to say:
> >
> > +Historically, the "KernelPageSize" has always corresponded to the "MMUPageSize",
> >
> > And:
> >
> > +except when a larger kernel page size is being emulated on a system with a smaller
> >
>
> Given that the PPC64 thingy still exists in the tree, I'll probably do:
>
> "KernelPageSize" always corresponds to "MMUPageSize", except when a
> larger kernel page size is emulated on a system with a smaller page size
> used by the MMU, which is the case for some PPC64 setups with hugetlb.
>
> >> +page size used by the MMU, which was the case for PPC64 in the past.
> >> +Further, "KernelPageSize" and "MMUPageSize" always correspond to the
> >
> > NIT: Further -> Furthermore
> >
>
> Helpful.
>
> >> +smallest possible granularity (fallback) that could be encountered in a
> >
> > could be -> can be
> >
> > Since we are really talking about the current situation, even if this, is
> > effect, a legacy thing.
> >
> >> +VMA throughout its lifetime.  These values are not affected by any current
> >> +transparent grouping of pages by Linux (Transparent Huge Pages) or any
> >
> > 'transparent grouping of pages' reads a bit weirdly.
> >
> > Maybe simplify to:
> >
> > +These values are not affected by Transparent Huge Pages being in effect, or any...
>
> Works for me.
>
> >
> >> +current usage of larger MMU page sizes (either through architectural
> >
> > NIT: current usage -> usage
>
> Ack.
>
> >
> >> +huge-page mappings or other transparent groupings done by the MMU).
> >
> > Again I think 'transparent groupings' is a bit unclear. Perhaps instead:
> >
> > +huge-page mappings or other explicit or implicit coalescing of virtual ranges
> > +performed by the MMU).
>
> I'd assume the educated reader does not know what "explicit/implicit
> coalescing" even means, but works for me. :)
>
> >
> > ?
> >
> >> +"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" provide insight into
> >> +the usage of some architectural huge-page mappings.
> >
> > Is 'some' necessary here? Seems to make it a bit vague.
>
> I had PUDs in mind. I can just call it
>
> "PMD-level architectural ..."
>
> >
> >>
> >>  The "proportional set size" (PSS) of a process is the count of pages it has
> >>  in memory, where each page is divided by the number of processes sharing it.
> >> @@ -528,10 +541,14 @@ pressure if the memory is clean. Please note that the printed value might
> >>  be lower than the real value due to optimizations used in the current
> >>  implementation. If this is not desirable please file a bug report.
> >>
> >> -"AnonHugePages" shows the amount of memory backed by transparent hugepage.
> >> +"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" show the amount of
> >> +memory backed by transparent hugepages that are currently mapped through
> >> +architectural huge-page mappings (PMD). "AnonHugePages" corresponds to memory
> >
> > 'mapped through architectural huge-page mappings (PMD)' reads a bit strangely to
> > me,
> >
> > Perhaps 'mapped by transparent huge pages at a PMD page table level' instead?
> >
>
> I'll simplify to
>
> "mapped by architectural huge-page mappings at the PMD level"
>
>
> >> +that does not belong to a file, "ShmemPmdMapped" to shared memory (shmem/tmpfs)
> >> +and "FilePmdMapped" to file-backed memory (excluding shmem/tmpfs).
> >>
> >> -"ShmemPmdMapped" shows the amount of shared (shmem/tmpfs) memory backed by
> >> -huge pages.
> >> +There are no dedicated entries for transparent huge pages (or similar concepts)
> >> +that are not mapped through architectural huge-page mappings (PMD).
> >
> > similarly, perhaps better as 'are not mapped by transparent huge pages at a PMD
> > page table level'?
>
> I'll similarly call it "mapped by architectural huge-page mappings at
> the PMD level"
>
> Thanks a bunch!
>
> --
> Cheers,
>
> David

Thanks on all!

