Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C635C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3988C6B0088; Tue, 29 Sep 2026 10:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349B66B0096; Tue, 29 Sep 2026 10:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25FEF6B0098; Tue, 29 Sep 2026 10:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEE936B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:08:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84D571604FD
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:08:21 +0000 (UTC)
X-FDA: 85266979602.12.C506D14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DD7BA40002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:08:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVewW5Qn;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790690900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlNOYHiT07K2az/l+2y4AGC9fafFmKTrBoDd4N5U5z8=;
	b=3h+sEoLiMNCaW5JwVUSOw5903drkYW6ysl8EN14r+EU8uJu0x0Tkg1UJ5jWxyHalVHWmaJ
	QS+mRKEGI7Bja3KCIa2u+OdlKyfh0GXvzxkIfGhMv3yVb7Lc0+JIEzE2DH82dzKKh+ggvf
	ckfCI+Sk5iTUGuMKV1HV2xkOOKyIvmQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVewW5Qn;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790690900;
	b=tT1WU7ieeNeScok/DuydlaWjLWId11mDwiD4mK/FHz8AAX19NJphJafuJRv9HVyteltmkE
	kQ11keIxFS7mPus7/o+yi49d9vbGVRsHDDKk785wrYyDzDWafGO+LblwqY24p3C4R9XQl2
	rPRYbOYB4JtEUqpJw2Cz2c/vdNHtwGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1493741A2B;
	Tue, 29 Sep 2026 14:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684D01F00899;
	Tue, 29 Sep 2026 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790690899;
	bh=jlNOYHiT07K2az/l+2y4AGC9fafFmKTrBoDd4N5U5z8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mVewW5Qn2qAmgjkDHrm7h9ImBLizby8aLuxf2ZTi8kNSecxlc9kpgDODMBKmTYCjw
	 dNLgsxol+gnQyNk8YPciyWzgpMPTtzYl0ZqWF2CrR+HvUn5tvJUT6R3GhQdk7pM6Gj
	 aWETMcRzoLIrFr85P7qlcdkYgSo9X+lf17RWX2QbzvvIiw0+rBy2vXTI+uyooN95zp
	 bTtivmEZSjOPyXvBPNdLnfaEheHIB2jbaJfy63pMIYZo8OREkTw7ofwEdFcu2U3y6g
	 beLHIDKMXzCH5xXoz2cKjHf/g0IcvsPaGKXbV4uO6WafJVG3ds1Z8T+GNcDv9SaJD9
	 CJulhZMBVU0HA==
Date: Tue, 29 Sep 2026 15:08:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Deng, Pan" <pan.deng@intel.com>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH] mm/vma: don't remove VMA from rmap if pgoff unchanged
Message-ID: <arvEs8PNXNkJJYfe@gremlin>
References: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
 <arqI5QB5tUr8dd_r@pedro-suse.tail5790ac.ts.net>
 <arqczL8K39qBoqgV@gremlin>
 <SA1PR11MB6824A3768F22AA274860809A968C2@SA1PR11MB6824.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR11MB6824A3768F22AA274860809A968C2@SA1PR11MB6824.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD7BA40002
X-Rspam-User: 
X-Stat-Signature: h5fzd4xs81sn3dyc4yasmg3a15u5y5o1
X-HE-Tag: 1790690899-836934
X-HE-Meta: U2FsdGVkX1/Xd/Hp3Pmqdylp1o60LgdcrpJZz7ckDigfCQU3ktuuZ7jzoHjgHUPxoqgSO6CvbRbkxfP5IxIs59WN+iV6FfJl9ydMYn1rYMfGtBfgZUkhghMbx6dMDi1hTjoV60+cYOA6vgSJH8Qs+KYgwSwLPNoNDv4cVJuJNqZH5eWBLJRM+SvvMfvP71cb+JyXnoP5vwBz//LvzHa4rg9M5t0yuNbNoeOAjs88dWbMz65Cvtx4f7NjZtmFGuDK9tW1fi1W7lNHatJUVfK/4UR4F/Rz3ZkXoHoglO9y2jtNPBFD84qk9y9hC5NHcMdGQkPqpugVpG18eyYntbNQIpj1dfMKFbFRaQJd/v2oXiFGW2YQdAqJokdLxHBkTLpn1LINRDp+FotyVQd2ei52x/uOc0HFjZLik3qOdzUe/BmDUbsAWTljWNbx2dKxO8Tkx2DrgLF8//7F/8NNLAdVsUKOc1p4TdDdNcUC3vTyPj+wBGGIZTl7C0sf0vKQp0viyjacnduxBRNGjZHbmBPHPwk3aCC1+fqVASketmoFLmJx4iyZQUUPRuYXZnvCXCeLTZJeXoy3ItAESNjhnt9NiEET/SyNwKNEChGYK+V0+yAtbaWMHHFA9CXLSDcWAyEpwj6U4cPP5O1JQZjNhTlIxF8ZpkxYM1TT/EK62MrgQImoR9A/vTTA5SjNSBoR1oRJvXl60Z44M3doVAq7FedsZEvghGNkVcTEdx50hOF3g//1AJOQv0Pg5Jg5jTn7Sl8TgQUddBnhF5PFnHgUw10PaO/2QwV1yrHmJLMIU+THN6coZ9CWTe7p5vQOYEZHoMBvzm0PB6BhKuI5PJ8jYa89Sb9f/c26Hi9W3yzvP/I7rVdb0bH5y3dn0J4V6fyJSH/MR2IavaPtBWMFQLbymzwLd7yeDGW036EXtXuIT0qI09F46pOO9l6wIrkBzySnR9CY04Kcwt4OecBSSmFkAcD
 ZsMGpDu9
 zdtuPxJSWagkxXD+LHzNOVV4WReLKZVqxbWNyF/i+7y323SEv4wnFG/T0C+rrYmcwRPha2wov9Y5lezreQUjkPVWuaMYPEGpo2D5j1RhCtKURpKJsZOavIFbQ/E2oMvsat+fOVPCRPtr3EoI/M6xW+zJGkeDVrTt4Mn1BNe4lx9+lKvOnjQf6wtbfdR9mMURIZfWUnUuXLmqBAtVOrJlIrdoBsb8oBojupr/VeTYczLonT29HOMxY6Ss4pPrdV1WHP7/u7V72fTjNEUyhqqQvJjTtlQ+NOugCw0v2NfuRoT4fe58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Barry for anon question below

On Tue, Sep 29, 2026 at 01:45:48PM +0000, Deng, Pan wrote:
> > > > The anonymous rmap is keyed on anon_vma_chains not VMAs, so in those
> > > > instances anon_rmap_tree_update_vma_inplace() iterates over
> > > > vma->anon_vma_chain, invoking anon_rmap_tree_update_inplace() on
> > each one.
> > > >
> > > > For the anon rmap case, with CONFIG_DEBUG_VM_RB set, avc-
> > >cached_vma_last
> > > > is also updated in anon_rmap_tree_update_inplace().
> > > >
> > > > When performing a VMA shrink or a split where the VMA is the lower one,
> > the
> > > > page offset cannot change, so set the flags unconditionally in these cases.
> > > >
> > > > When merging VMAs the page offset is unchanged only in some cases, so
> > > > update init_multi_vma_prep() to set the flags only if the page offsets
> > > > remain the same.
> > > >
> > > > These changes ultimately result in less rmap lock contention.
> > >
> > > I think this asks for numbers?
> >
> > Well I don't have any :)
> >
> > It logically reduces the contention, and that can only be a good thing.
> >
> > Pan had some numbers, I've asked him to re-run against this one.
> >
>
> Yes, UnixBench/execl case, measured on my 2-socket, 192 core / 384
> Thread x86-64 system, on v7.3-rc4 with and without this patch, built
> from an identical kernel .config.
>
> Configuration, re-applied after each boot:
>   - cpufreq governor "performance"
>   - uncore frequency pinned to max
>
> Run rule: 10 runs per kernel, 30s cool-down in between, cmd:
>   $ ./Run execl -c 384
>
> Result: Execl Throughput, index score:
>
>                               avg    %stdev         min        max
>   v7.3-rc4        3511.5     0.44%    3494.5    3543.4
>   + patch         4069.0     0.48%    4047.4    4109.5
>
> The speedup is +15.9%.
>
> In addition, I also profiled lock contention data ~10s in the
> middle of one iteration, cmd:
>   $ sudo perf lock contention -ab -l -S vma_prepare -E 8
>
> The dominant lock is i_mmap_rwsem
>
> Result: avg wait on that lock in ms, 5 runs per kernel:
>
>                         avg    %stdev        min       max
>   v7.3-rc4    9.470     2.91%     9.070     9.820
>   + patch     8.420     3.34%     8.100     8.770
>
> avg wait is ~11.1% reduction.
>
> Note: under the i_mmap_rwsem write lock, this case only exercises the
> split path, for both the file and the anon rmap, while  merge and shrink
> are not reached when the lock is held.

Thanks Peng! Much appreciated.

I'll fold this into the commit message on respin, should get that out today
(some trivial renaming, etc. functionality will be identical).

Be interesting to look at anon also, there could be impact for android
specifically given zygote.

Suren - do you have any bandwidth for checking whether this patch impacts anon
rmap lock contention?

Barry - I know you've looked at this in the past, are you able to assess whether
this has impact for your workloads?

>
> Best Regards
> Pan
>

--
Cheers, Lorenzo

