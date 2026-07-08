Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14690C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDA66B0088; Wed,  8 Jul 2026 02:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5FE6B008A; Wed,  8 Jul 2026 02:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC926B008C; Wed,  8 Jul 2026 02:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4FBD6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:23:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CDC6140649
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:23:03 +0000 (UTC)
X-FDA: 84964616646.20.C223AD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85E6EC0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:23:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LGtbx85v;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783491781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhJE5OuUUHCm7qpu+pDY+GZ63fKdVTQlvI+ddyPOyH8=;
	b=ljgqT5wmxwoXiC3L/Mlf3fwYGNj7zcOVdXXcQstZQ9QuqFWH17R/fDACgkI8o0Axhsf3J/
	vdAYEeTAgkmNQdgG18g3swbJ2B1Mbl+zJDWc1UU6HJmnWK8YNDqOdpySmROsED05j0CbYF
	Fz1IT6ucaSLbpWTtJT2eeeEagG1MEuQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LGtbx85v;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783491781;
	b=WcwoF4PRaGj8+4qehfyWF/tXsF43Csfo9qXuPhH9lEGRQ2DuIkHfaaBwGIugCGmk5az2B1
	689L3TYPdSTX2TDbhwjWkiwjsOIPkr/yeQMp9mhuD0iUf/nCJNoDV9ACMHRi8dFMkJ6eMj
	Gsl0NusA02fHETd1aZADXwgeGo5rEug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E50BC6001A;
	Wed,  8 Jul 2026 06:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C7C1F000E9;
	Wed,  8 Jul 2026 06:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783491780;
	bh=WhJE5OuUUHCm7qpu+pDY+GZ63fKdVTQlvI+ddyPOyH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LGtbx85v1aFTEcg8MP7ZNBwXODbxJUrGK5XMbNxHZthj1bawnpu/7anqV9DlZTTID
	 otNtVvtpsO3VoicTwuOXqdziXuAyCM/og2X2BfPcxS/E1GoE3iuuGH9nMR8ELGeFxb
	 XUP5XadBQwvxvwWx5VDeEWn4FKwW/DsRv71/lQ6OUo5vQTsj8Jp39fOqO0XAr/8Ayq
	 h13iuJHwp8S8xP/Lo5nTx7lqfuav2YlDWI81VHSVMQ88VcSNXzoTk2T10wby+OVF51
	 wjdgFe40bLWn9Amg6fgATfiCLi1Hp5Vjd0jvqtFYEtkpQNgJ5MAZS4fnhDnBUeUB3R
	 Y9Zv/zyiYnJoA==
Date: Wed, 8 Jul 2026 09:22:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Thierry Reding <thierry.reding@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>, Chun Ng <chunn@nvidia.com>
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
Message-ID: <ak3ssP3_gDIwu1VG@kernel.org>
References: <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome>
 <akzikTrmhMsvkNVY@willie-the-truck>
 <b0a1bdd7-46ab-4025-8775-c9273892444e@arm.com>
 <ak0A6eLp0Pw8iKK0@kernel.org>
 <f6e8b4d4-8b50-4cc7-b264-ae39929c619a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6e8b4d4-8b50-4cc7-b264-ae39929c619a@arm.com>
X-Stat-Signature: odp8aozze3ex6wh3kgxneo8ewjhnnsta
X-Rspamd-Queue-Id: 85E6EC0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783491781-65201
X-HE-Meta: U2FsdGVkX1/7O7SIzvm8VFdD8wSGGxEwM1RUP+2bMCrFrCswRH3lkWUDHk6BbbSy/W3huhj5zJ64OWA5ROOVcDJ2hE+882WyadwbebX8hQsD29pompKqUY8LMgK9u3IfhMLo/keH1VMmDQkykqCydOCU1llIpLHzAFENhd8hFraiI5kxltZIdATAPJ2KDU4Q7E4Mcf6Dq85RFTW4g1qlWhZdlyaflAMlI3f5xb5MF3cG8VBQB1nOI4UpZzs0RcCVU+m9B+N50VJWlJt2SuJO+dOWdbfcWfzi7Z5TeLO/VXww9RqM28lr8oMYs1oFBYCjmHeNRz0d59jVMu68qQyaH1z9eu+IrTAY3kXcaVSu4V4eD+D44100ScDN4k/+XJqfx44tXwvZthsig6cQAYRvC6OfYM7qEAynuqZuK4MKltsi3KIUbWKD8P7wO0BzqbnxjfyboPcY06Aq4BzipWTww6u61tG5ljQQDT0Ncff7vm8vMsGxUbOT78XgXFrk/TGdflC9pctYQ+9LOfN72bx5xthEpEDRnXwN7bdF171f4WvaJNUkMGWWdsmPq7HyH67uE1aC7Stv97fQQupxZPlJfiIZdycewSD8XMGXyq3dcuA+/nNazzcM3sDZ2o64dlxD7QzzTtP/mz98pTU5NTRFwygYVH/HRWD+PCqSBrYYyoKubPUBvIJ+MXcISSfFotDt5/co1xvuq5iXp5Ovdg6L3KCbdErjL4uumV4ZrWSM8TDP9oD2DMrq/DPgl3nYoPW/x/3MRvc/0RNGnmkEaQaCWR/1EOVgAPDlbQCvD8zX4KVxWHHBup1mCpUFP7POC+WNBeqBznU8SJgBNdWKpaPFg1t+J8Ey/LxhQYhHvmC1zNau+Q4+A/J/cJWy4wqjfmMF/dBGLKmN5ugw1u8bcn+m0TxeCywOwgflSA4Q+GRKz5D1mFHxn1jn/8+OvKQPQRkdVEAL4tDj1PK0gZ5zdyN
 1zdxzQKS
 oNSA4ijVDKWX0wr+MStY6dKJcz4+N62DNKzsXlvCrVEzW5x/57TUM2TtK+f53fi8KVv1Tsx7J4TB1s1qQgzrZ3Mr3AT4ronUUo//F9vqFzyGS2II/02FHUpZSxR9p6EKKvJa+jKjG7i43I6nLQ8VvExil2YhYCDbHYwa6Dr4HVhjMGqodUvqT9TPAlpCihg5F/qBEQCbtISzGWufergeohw4sLhpubDvVEPyJ+8Hg43814kelfcOwVwFmkjMW0uHEVpAAnYhjFVvW5xgKW7I4k12IpG97fL1X/3UNGLDE01VJS3NZy2IuAFABiKIChPRPRGYl+MTQB7mpvs/ZFLBDbb4Q1DRrOI/qbCn0QmIjohKg88FgCLXlJB6Z9WonqKQn+g4lGonM0CxxAJhB/ISb8V4skKhXWFTzLSTvQoce5e23hLpjp9rcyxfGnsGfC5SzoD1KH2ZgNQP9HBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 03:15:24PM +0100, Robin Murphy wrote:
> On 07/07/2026 2:36 pm, Mike Rapoport wrote:
> > On Tue, Jul 07, 2026 at 02:17:29PM +0100, Robin Murphy wrote:
> > > 
> > > Given the precedent of memblock_mark_nomap(), as long as the reusable
> > > reserved-memory regions also get split into distinct memblocks, then it
> > > seems like in principle we ought to be able to give them a new
> > > MEMBLOCK_PTEMAP (or whatever) flag which could then be picked up in
> > > map_mem() without needing to override force_pte_mapping() globally?
> > 
> > Please don't. _nomap() caused enough pain.
> 
> Indeed I was there for pretty much the whole pfn_valid() saga :)
> 
> Bad example maybe - in this case the only actual similarity to nomap would
> be the fact that it would also be set by the of_reserved_mem code based on
> what it finds in DT; in all other aspects it should be functionally closer
> to something like MEMBLOCK_RSRV_NOINIT, i.e. just carrying information
> through the mm init phase, then ceasing to matter at all once the linear
> mapping is done.

Sounds simpler than nomap indeed :)

Although I'm not sure it won't be required after mm init in some way. There
is already a suggestion to allow collapsing PTE mappings into PMD in the
linear map [1] and it already adds a use-case for runtime check for
MEMBLOCK_PTEMAP.

That said, I don't hate the idea. The only thing is that such flag would be
very much arm64 specific. 
I've been thinking for a while about splitting memblock flags to generic
and arch-specific parts and if you decide to take a memblock flag route it
seems like a good use case for memblock_{set,clear}_arch_flags().

[1] https://lore.kernel.org/linux-mm/20260611130144.1385343-7-abarnas@google.com/
 
> Cheers,
> Robin.

-- 
Sincerely yours,
Mike.

