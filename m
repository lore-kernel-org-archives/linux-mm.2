Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 424DFCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 21:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8306B0298; Fri,  8 May 2026 17:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871266B0299; Fri,  8 May 2026 17:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739FD6B029A; Fri,  8 May 2026 17:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEF86B0298
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:18:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C2751A02FA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:18:39 +0000 (UTC)
X-FDA: 84745516758.04.42D32D7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E38720010
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:18:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cypH1QBj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778275117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJj+sF5ZXbopOQbUXOheRDyjT4qPVzqttIbbki6Cqek=;
	b=J9DwNfIMOkPXIkLityohiTduuAv3lrOsm3eAPr0ALn5wqxnydBGfDzKVAyYxRvyWjksM9y
	o1AwEcqJrSds4yj7ce/eGBfg9HFRtUynAgSfPxWU3Pg1UaawPjuiC9ZzMjfXlhvxgW5R6R
	M2b02YAS1UVJ0x7FdShBpd500uxK2kI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778275117; a=rsa-sha256;
	cv=none;
	b=zLUf/33jHiucqOS4iofgm/c+u7X/NC+YBF0CD17eV+ZZsv2eTxi07aaLK2C2K7YG6QfQNd
	cOsGPQdEDqQ8lzgyCfxJGSuF68sPjMm5qQavVrfe+9XtL4k0oDmnNDrNacKyRs1eQZY6Ej
	HX339PMeiFO5q3fHE5/VQYQ9s1omqIs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cypH1QBj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fJj+sF5ZXbopOQbUXOheRDyjT4qPVzqttIbbki6Cqek=; b=cypH1QBj6pZMp2Qzt2Mbm/LgfH
	N5tZJ//iHwd4v4yVMt1hFUDqHAaeniH1cI9WOelNoCu2nxRGrYC9/wpk7b5SkvU1FWRFO7/YEClBu
	JL3jwts7x5VY9DgFwv3dHjIxe50fsVyk8LDcFo8dPUy/lKZfFCUBQOGl0c3fc2ZBuFQ9ueU4PEDqp
	wxFS+bez9svUR177dTDCGOBBWOHqpItC1GmCR72FEXKkLHTB+EFBFDB7OkSvHIo+p43mrr3Nld55W
	GqrCJu26jKSaDUEsIic22If0OXOcT5QKY1Ej6EktC+Q0F9mQ3QZv6ZB64u0WakeD0uOe+SiEzAQ8l
	NmYTvTLg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLSaf-00000007X4J-0lkU;
	Fri, 08 May 2026 21:18:33 +0000
Date: Fri, 8 May 2026 23:18:31 +0200
From: "Liam R. Howlett" <liam@infradead.org>
To: "D, Suneeth" <Suneeth.D@amd.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>, 
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 26/30] maple_tree: Use maple copy node for
 mas_wr_split()
Message-ID: <wnvu7fwch7vbmmngd5s4pcypaoiuzq6atsdh47nhtfo4rccsxi@kbg53gd5en4o>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
 <20260130205935.2559335-27-Liam.Howlett@oracle.com>
 <c4605bf2-9ac6-4d04-9f49-79643ee99178@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4605bf2-9ac6-4d04-9f49-79643ee99178@amd.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2E38720010
X-Stat-Signature: mhhx6tz3qsawp7rrxugfpi8hqp9fm5w8
X-Rspam-User: 
X-HE-Tag: 1778275116-107549
X-HE-Meta: U2FsdGVkX1+jMqN48PPg9pAtVV/ArCkE+qrU8zH00BLpcchBNMF0yUC61Bti/F0do2EpG1Kk9pGHBe1j1kW6ImNHigOquexUIRLbmYl2chj/5S4t9GbW+AgJjJkovqQiOp6Qfg6gQ6Syuo6kw/vT277Gp+VoMdgnknmFNI26+s3Avm472fVCli4jMjrIUl9P/N111ZN8CBb7qGyt3Yi4ywVh68b/0KRD1X2prfLB6nW1qNAH+zxZGaiVduL+UnTSvgJrKMdoYYBdg5FU1jdt0N1QO0o6Is6SKtkQ+ksxlCXbpSTOK5rJnLkjBjnvydZdgug2G4Rdw9iFVAk+C33SAB8HU7DET2shBc6dK4uTqYlT7fzOd9ccoOyEzUJfIEgvAHnQqItOvh4BnaDqA67GnOwEL5bBtydZRfQ2MLF7EseCz4/BQ4V/wboNGCPOl94OPSYlBSA7mhVGdlG3JIIzMvhsPLxIj0kd/JzQoH8zCGsOuzs/JzlZ4/MU1qWUnMM55bt+O7rJmBOpAOKzS2kmkBwsovcObkmknGNPnXHH3rLxLMIytQhvSaJgEjwilmJcLYVbwvLvSIh6/+zH/MrJLVsSiUBTZ5Twc1NVw/HYTS68+ePr/e8/XF1GCXr76g/HbKqA/yHzQuLpBCKUi7iG+8sQKzGrEWdtVlwcH3miLIlz0vNd0dJSqe8kPiKCE4Xq77YkBi/BgRoNLnM1iXBeIszMN4pWBPCerCMfMWN5ijmHMSJM9v2CUE4NOIvW2zFtKuGhTggOPLVpR4Zye9SUIhnfc/pbQE3sjdEqa0Utvl4Dyy0ZcVFSVnRJ9+KA4AAdZA0HWaCTpnW/nPq4OkOJHG6UigKmRGhdY8IwbB9Lpq/O2+Ob+J+yla9jpjyxd5VAUK11qiQVharzsMn1593YS/bi7q3g8QQafxoDqiyS1+QRfR6EW5XzrHAFXbZrRWFgM2QmDvASHCYXZFDeJqW
 1NqM2oqI
 KqtJdOEZHUrLEzdH78/BcqW+4nNQmE+LIF+FIHECmKXDCWKMPELfcvsWYHxeAoKO+ANgLo4gh9zDtj/t8/tlZAONFAAZKdY9+5fA0LRmywbshG1+FMXu69Of0ku7hXvrAO7Sb5YUYjTpUwDMdoAAXY7HEQXfVbyM86bv5QxvpYTNlkrG4e7nWiphXu0qOBBU4tR6CLN1iyaF6pa3Pjcir604DaDUKSXNljO8BB9H0rz+VQVqOI5pI7icywfO/Sx5XIAygrWRhlyF+PAYtE0nAuAj35SKJT+Yf314K1QYJb6rzQbwi1aC3AQsCsleSoTHvc9+j7PLk8UojmksbKS/3ty0GCNodlrff6JDKd/GrO51FC5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/08 02:12PM, D, Suneeth wrote:
> Hi Liam Howlett,
> 
> On 1/31/2026 2:29 AM, Liam R. Howlett wrote:
> > Instead of using the maple big node, use the maple copy node for reduced
> > stack usage and aligning with mas_wr_rebalance() and
> > mas_wr_spanning_store().
> > 
> > Splitting a node is similar to rebalancing, but a new evaluation of when
> > to ascend is needed.  The only other difference is that the data is
> > pushed and never rebalanced at each level.
> > 
> > The testing must also align with the changes to this commit to ensure
> > the test suite continues to pass.
> > 
> 
> We run will-it-scale micro-benchmark as part of our weekly CI for Kernel
> Performance Regression testing between a stable vs rc kernel. We
> observed will-it-scale-thread-brk1 variant was regressing with
> ~9% on an AMD's Turin machine between the kernels v7.0 and
> v7.1-rc1. Bisecting further landed me onto this commit
> 280b792cac62ddadca2935766ca870b438c86323 (maple_tree: Use maple copy node
> for mas_wr_split()) as the first bad
> commit. The following were the machine's configuration and test
> parameters used:-
> 
> Model name:           AMD EPYC 64-Core Processor [Turin]
> Thread(s) per core:   2
> Core(s) per socket:   64
> Socket(s):            2
> Total online memory:  258G
> 
> Test params:
> ------------
> 
> nr_task: [1 8 64 128 192 256]
>       mode: thread
>       test: brk1
>       kpi: per_thread_ops
>       cpufreq_governor: performance
> 
> The following are the stats after bisection:-
> (the KPI used here is per_thread_ops)
> 
> v7.0 (baseline)  %diff   per_process_ops   kernel_rc_ver
> ---------------  -----   ---------------   -------------
> 353091            -9     321987            v7.1-rc1
> 353091            -7     328897          v7.0-rc5-280b792cac62(culprit)
> 353091            -1     347884        v7.0-rc5-11e7f22f5e85(culpritm1)
> 
> jFYI a very high level call trace from running will-it-scale-thread-brk1
> which ends up in mas_wr_split goes like this,
> 
> do_brk_flags() {
>   may_expand_vm();
>   vma_merge_new_range() {
>     vma_expand() {
>       commit_merge() {
>         vma_iter_store_overwrite(){
>           mas_store_prealloc(){
>             mas_wr_store_entry(){
>               mas_wr_split();  <--- Function of interest from this patch
>             } /* mas_wr_store_entry */
>           } /* mas_store_prealloc */
>         } /* vma_iter_store_overwrite */
>       } /* commit_merge */
>     } /* vma_expand */
> } /* do_brk_flags */
> 
> Recreation steps:
> -----------------
> 
> 1) git clone https://github.com/antonblanchard/will-it-scale.git
> 2) git clone https://github.com/intel/lkp-tests.git
> 3) cd will-it-scale && git apply
> lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
> 4) make
> 5) python3 ./runtest.py brk1 25 thread 0 0 1 8 64 128 192 256
> 
> NOTE: [5] is specific to machine's architecture. starting from 1 is the
> array of no.of tasks that you'd wish to run the testcase which here is
> no.cores per CCX, per NUMA node/ per Socket, nr_threads.
> 
> Would be happy to help with further testing and providing additional
> data if required.

Thank you for this report.

Considering this is brk1() in thread mode, I'm going to tell you that
this test is seriously flawed and will not produce anything that looks
reasonable.  The way it is written will race all over the place and thus
is unreliable.

Does the same test in processes show a regression?

Thanks,
Liam


