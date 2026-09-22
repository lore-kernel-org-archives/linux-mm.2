Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41794C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256336B0095; Tue, 22 Sep 2026 10:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22DCD6B0096; Tue, 22 Sep 2026 10:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143C96B0098; Tue, 22 Sep 2026 10:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAE836B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:56:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A4871C2E57
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:56:08 +0000 (UTC)
X-FDA: 85241698416.02.90F2335
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E3A151C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:56:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NC3hIEgS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790088966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yx1KVYmcOfYVjEzVIyo9QwiUPN5oXN2wUlmjKnOCc0=;
	b=Lqk92+Pde8fdMXx5lv+DyBY8QXTZCEr2GGopg1N7cfmkv2wQchy8LKjQkLhTo21b5wE72W
	2f1YoeQtCASOJZHaVOqY484wfF4Abc0e5ngaxcszX0qCAqDR3A7dlT1E3MM1fzSQmv1Kda
	Gb5tCXOTQWlxPXWcIeDkmyWp7hvieb4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NC3hIEgS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790088966;
	b=eav3WvDmsXE8sO4cYcxxCoU8erflHjTDKOkz27uUyS75nbxivf9kVevh61GE4qrgyNCquF
	pLYCgo1dGGvxjnQGiFEYR4S8b1CQcx0vA7dteO5cVqfcROyWH7IrDkS3w0sVXcnVtmPuNR
	hojriIOS2s01lCz03C04qBe7pFjnGr4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B00760052;
	Tue, 22 Sep 2026 14:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8973B1F00893;
	Tue, 22 Sep 2026 14:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790088965;
	bh=0yx1KVYmcOfYVjEzVIyo9QwiUPN5oXN2wUlmjKnOCc0=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=NC3hIEgSJs/USe6Ql93fEv9ZrzabtkxNqEUZB4aQ2SanG3FKZCPBc+TZiQPr4OO1+
	 O/6s4bE+yPy8fmQm4C0uovI54n6HOD5kXMGyFVDFMz0p4JyjLJeDN3FsiwdR8cE49m
	 pRL3TJMlnfzuq3j8KgbL028p7w0xufIWVgMhb9Nvb5EkJpPUqXOWSkwk2N/5ocvPwV
	 0WeurwzhpDPAgSniGFO3HvgOjhUCfPTFDJ+Tx5GVONm/+U/AHgqsjkCy0ci6hyTZia
	 6Ofp14oLq8Roe4awmztMutLjIBhCFpEenyJ3ICn2F/EiI/xkjMGnnGw3FQWXK0ozQ/
	 JPe2j74jLLNgw==
Date: Tue, 22 Sep 2026 15:55:59 +0100
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com,
	rppt@kernel.org, akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, robh@kernel.org, mark.rutland@arm.com,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <arKW_91EeKA-w96m@willie-the-truck>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIYtjmSKCs14SqO@sumit-xelite>
X-Rspam-User: 
X-Stat-Signature: ep9c7sizrdyhf8heph38wojrh435whgj
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3A151C0002
X-HE-Tag: 1790088966-310264
X-HE-Meta: U2FsdGVkX1+f86E+woOxquy0RaCSuHrZnJsxBvVdAMDXC6VVyuCuBHaPk9PUZMys5VMfc2WRPnnC41ArhkIjH1U0Oui39oSF7628l5cabOEB4m7UoMrIC93BqXcS/r0gwKLoZuVuLYRXcN83CKLhptBmhSleyz4MpZ5md9kKJt/seVbBIP/jblVlbviJVUqknyynRDVtb4nTlSgqAysRFr0/5VkuQBnnwTAqEkEGgQIKWGWCgZT5QFe5TWPHHT3J/pnm8T2IYBw/fiBJeOYYOA5qlWbHv05p5jaIDd0eCbWFMaT/2AJw5eRPfB0rr6Ghi0sU8B2gZmGk5OcEej14UGmDmo3r63e7cjSrfUoT3cENdoxQTbTLHPJCnF7We8EMBzKJx/+96AVe04SR+JY9uWA/xffWc5oEHI3IUB0Pn803O0liLLdai97E95DYVFK7YfcgDa8Mc2ybpgjnJe57O62/EiAFTVO15q/BTvdeU0XCW70IAgR10bZQcJ3l+IXYgCVT+39C4+9IQUF+sBz/sEMmpMH27hjyppEQCXepAudGHYAlGtHy48PQgpKB7QUUOC+gHcvEEJmbjsZr2//vy2F08S2EFpK9G4a3N2VWpgv+xd+gqhjKYjyCVIkwdJlU2Uh8CDf2CqUg0WEH0BdeO2upHDW3iySo3UBja2mCafMetKQBtBUqsv+hm3nZ0vOhU1vmdfxNX8izuHMzE2vCWx2BrcBTP+XSEygedOvLMkeNbih/CxDUke6gkIHlTfLFddzmWTdhu7sRVkte/kAnGorUIjN8pyjZeJ2mBepmWswFPWuRMpk8bfGtjd2IlZ78mDcI89rfS3LnbT2dw5RtZsT/PvGNGIIsvl8Mp3KNxoDyy6zprl5gxZM6bHAdemRAa8XfeXgS29VjHndcI5aan4en0kZ4jtNB303dEvzj92iXskeKqq1H105LaqLBT5pqc0tJpg4H0EE+gVxQiPW
 EN9HAzQo
 XvrZY6untYwN724vNWJuOCZH8zS29SP1TVWCwFCwHsTzD9Jb06KSdaNXeOjbBCmfkXNjygPeDB2bmyxvJL2MmvoFnqWRSdxgNQRojmZZgP0cKDZl8GNE8yCglTeUuywv3LBkAPSNuH+joEmIq/WgIivuw0neH/3uvBv4nVpWYM912jjDW95q2XNQqbLhZeWzguN3JrJGoIIoU2yWmVlzohsSDQwDw+QUy40PAEetJCQU3Oq3+WikKT4O++oa9auIwH5s7cOh6X2Qlcks4ZujJwQnEfoJ57OMkCfS4BGQej3AxQoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:27:10AM +0530, Sumit Garg wrote:
> On Mon, 21 Sep 2026 at 12:00:42 +0100, Vincent Donnefort wrote:
> > This series is a follow-up to the discussion that has started here [1].
> > 
> > When memory is lent to the Secure world via FF-A, CPU speculative
> > accesses from NS to the lent pages can still occur as long as it retains
> > a cacheable mapping to it.
> > 
> > Ideally, lent memory would be "no-map" but that would mean giving up
> > MiBs of useful memory, so let's try to do better with the help of a CMA
> > pool.
> > 
> > On arm64, modifying the direct map at runtime is generally restricted
> > because the linear map defaults to block mapping and splitting blocks at
> > runtime may trigger fatal page fault, unless the CPU implements BBML3
> > or the entire direct map was mapped at page granularity from boot.
> > Forcing last-level mappings system-wide incurs a severe penalty we want
> > to avoid. Instead, this series introduces targeted last-level mappings
> > for designated memory regions, along with the "arm,ffa-lend-pool" CMA
> > driver to manage unmapping and remapping on lend/reclaim transitions:
> > 
> > 1. memblock:
> >   - Introduce MEMBLOCK_PTEMAP to force PTE mappings only for a specific region.
> > 
> > 2. set_memory infrastructure:
> >   - Introduce can_set_direct_map_range() to check if a specific address
> >     range is mapped with last-level entries and can be modified safely.
> >   - Introduce __set_direct_map_*() variants that bypass redundant checks
> >     when the caller has already validated the range.
> > 
> > 3. "arm,ffa-lend-pool" driver
> >   - Introduce the "arm,ffa-lend-pool" CMA reserved-memory driver, which
> >     unmaps pages prior to lending (ffa_prepare_lend()) and restores them
> >     when reclaimed (ffa_lend_reclaimed()).
> > 
> > 4. Optee support
> >   - Hook OP-TEE dynamic protected memory pools to "arm,ffa-lend-pool" for
> >     both SMC (via DT memory-region phandle) and FF-A (via
> >     ffa_lend_pool_attach()) transports.
> 
> 
> Thanks for your proposal in trying to solve this hard problem of
> unmapping pages from kernel linear map. I remember discussing this
> problem last year at LPC too.
> 
> Have you had a chance to look at a more generic MM proposal around this
> issue here [1]?
> 
> One of the major concern for me with your proposal is tying the
> protected memory allocation to fixed sized platform specific pool size
> based on DT. Then the cost of granular mappings/unmapping if the
> platforms choose to enlarge these pools.
> 
> As you maybe aware one of the major use-cases here for protected DMAbufs
> is the secure media pipeline use-case which is memory intensive
> workload. IMO, the solution proposed at [1] seems to address it although
> people have flagged rough edges there but should be addressable.
> 
> Can you try a port of [1] for arm64 since the author did all the work
> with x86 as reference?
> 
> [1] https://lore.kernel.org/all/20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com/

I spoke to Brendan at LPC (?) last year but this doesn't really work
for arm64 because it relies on being able to unmap arbitrary parts of
the linear map, which isn't generally possible unless you force pte-level
mappings for everything, which is prohibitive for perf/power.

Vincent's series tackles that by using a pool so that only that part of
memory requires the pte-level mappings in the linear map. That's the
whole point of it, so I don't think it makes sense to drop it in favour
of Brendan's approach (which doesn't work).

Will

