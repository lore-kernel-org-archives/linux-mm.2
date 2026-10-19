Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569E3606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 22:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fqTGEjK2
Received: by kanga.kvack.org (Postfix)
	id 6842D6B03A9; Mon, 19 Oct 2026 18:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635126B03AA; Mon, 19 Oct 2026 18:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524486B03AB; Mon, 19 Oct 2026 18:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 183E96B03A9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:42:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 164291A08C9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:42:48 +0000 (UTC)
X-FDA: 85340852016.27.8982B51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 725E2180004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:42:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fqTGEjK2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792449766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXbwnR2RlCJZXvS7RGs12P+e1RnZcsA+7Uc/5Gfouos=;
	b=GkUfDYl0XYLPzm22uijYBRun3G91aAKA+xfCo43UOQSC+jwk677J/5QMz2IbKebRrGkqMq
	nVnkGSAm9CFzbnAKYsNrd8LB/gN5deqMmc4nijIvzPWSBBBnkwyVHdT+cSppwMjxV3JcPX
	aUGrO3s45aw9E3B6LRp3bIkRW5HPuII=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fqTGEjK2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792449766;
	b=EqGj/qeJ44oKgPshBbIain+Ssgi09mC163vfi8R3d/kVjWgL0CMTa5NNPfqYSjkd5GZoe1
	1HUNyTRZo9roHHNUTI0JkgvbnyJB0mHsOZ03oE6lcrehG62PFmHVdhMykTbJPY2nJCX3bR
	x52+LlEOwA8UAmjXd3CWzuDKrs1AJDY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF0F0600DA;
	Mon, 19 Oct 2026 22:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36ECF1F000C5;
	Mon, 19 Oct 2026 22:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792449765;
	bh=tXbwnR2RlCJZXvS7RGs12P+e1RnZcsA+7Uc/5Gfouos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fqTGEjK2k/qk2/XNPXLr8ukixfoWwjB4gtEYaQfxQWiO7jazvPdblIhmtcV/ubSe/
	 XAunHnFhLU8uK2kDBgJt5hDKF98EqfQwe+3OhEr8+UV7/rEePiER9pTy7dYJzx25es
	 a72Xz382QF6geDuUejhjjhH4ezOmf4Es8L2uItUwzMWX5sOKdLue0feow2ju6bw1LK
	 4Aq2XSSp95TOrCEj9YS15xBlA+FlKrLzy4UJOI0I+78tXNTGBiPYI0VfxlROWCvuOs
	 GPzftPlxo16nmUBCFg/mfcOFhDdhx9+wklYbJyaS4LcpR13bXqgg9z87zjAikyFjjr
	 LPCUllYYuBfnw==
Date: Mon, 19 Oct 2026 22:42:43 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atacyPeRJeDiUs1X@google.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
 <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com>
 <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
 <CACpmpoe+krnso-b1h_g_Q=HzV5x8xpu=Ke9==+4PfWF0ZcAUgQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACpmpoe+krnso-b1h_g_Q=HzV5x8xpu=Ke9==+4PfWF0ZcAUgQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 725E2180004
X-Stat-Signature: jc6axwr8ff7dgzmd4troqiyxdn8p6d5i
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792449766-176209
X-HE-Meta: U2FsdGVkX196Rl+OYiayTBoKmEarHLMZ+SAFlpxqO4QGq2jtPPvOsfCYY9EUOOfC3+WA5p8PGFVB94O1cMw/Tf+8cCmGar5FtQcgbVNhjP8lsCVSesHSFP9k+tThnHIX0aYJlG+/CvwTFuK8vOxjbvHMkl+mBvh1UCPaLF7CeZ/QUmN4UBh6jhcghZw8xSSS46PlOEuNLdAIhXbqwR770KKlAOsNO1PF3Cj/ZmLVg0sRYa1/1So21tJK6PvpP12sXe/YpQyBA3loZhCaQxPyXwgvcworCepWXp2/ddrkokdZtZQ3Fsr1aV121PqEsxTm4H1QFa9EPB59gGh8Vu9yS8aZIttV/xbQ4I9LfvAhB3g+jYQ6B6yxFis7iaDC/uyPAwR+ccJ9wTsBk0tKKjOQ7an4aqD7UkIBr2SXKb/6zNIkujc5/jFr5kFVvYYqXmkD6cNX4b0gXNEEroYkXO3t8iaJ/eG6djKzMrhiUTt/DpcRTNDDdrt9qGIZxuHqujrEyBg2cwmZAEWMH6jh4pR+nJ8KAOF/5qsi65yQNXuVA4B1j1nLsda552/90wcx3yxyND2BD9wTSIw9pZCIQWvOMmc61j3UPmldnqPQ3uhm+2zBuL5hcu/zGq6NoywWUvXaL5tB5dlHUWZpoSzT2zUTFpr+TDBk3m3OwU7VHkbQwZBo307pphC+FKAQAztZUQAfSRkdBHHw6XqS8NitDYcgoknONtavAdHImMhiuAlyGm5RNf63a/JSaayO3V/XBnzfA/+Xrx2zhtdbX/oAA0lLUx2VUe+GCJSqk68VJNF4L6ibp29xBWdbWu1dSAi6Mz9PIe1/ZDCBDKSsaVQyMoJrWfxEENrWC5NhbSOf1+GbNvjUlVOuemWG8hFQ2aoRmYauBgpqxNOBGUoLGd4XvC4XKk7RpszQ2JylxN75nMXAgYGutaVQyqPHGVa1RwwwP1zxuM9SQqqCNcyK2i0Cfd5
 Zs/fe0ii
 3qIeLCc89qM7Flr9Qxi8jJoz5B1YYYxFFOX3SS5cK2ueAoueFGh8+eBMyFmDCnxOHUcTNW47wsRtBD2egEfhEas96dw+ugYRzJNxSfuV/RFbzLL3xXQUtuM4LTVubxQhg83S8c12hez2injpIzpegJS05bZMS975PRMMS7kb0WLsxKtq7ktfVFh2eRg9g2O/1wVp3eS/vTjiZwffo51/LPttDSvh/PJvR+QA43ksz3w3l0KR7dSmPYlsIaHv4nRQayYPjhsEFdtHnqDzC5mMLQ+ge/D3m7GPWJyikY/PoXaFW3KL4XGTU+/IGkbrpQmqdpAritAKCCNyUKtAAtaWeAiT0z/5LTgVoE6gHl9emfZ9Cz78zwKvHqEFGLQNGI6Xl2LL2Joxn7CZ+BQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 08:53:26PM -0700, Kanchana P. Sridhar wrote:
> On Fri, Oct 16, 2026 at 2:48 PM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Fri, Oct 16, 2026 at 12:05 PM Kanchana P. Sridhar
> > <kanchanapsridhar2026@gmail.com> wrote:
> > >
> > > On Fri, Oct 16, 2026 at 9:14 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > > >
> > > > On Thu, Oct 8, 2026 at 11:28 AM Kanchana P. Sridhar
> > > > <kanchanapsridhar2026@gmail.com> wrote:
> > > > >
> > > > > v1: Batched zswap_store() with compression batching
> > > > > ===================================================
> > > > >
> > > > > This series is a spin-off of "v14: zswap compression batching with optimized
> > > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> > > > > compression batching enablers. Resuming work on this series following a gap
> > > > > since v14 (January 2026). Please note that my email address and affiliation have
> > > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.com. I
> > > > > have retained the original Intel sign-offs on prior patches for historical
> > > > > attribution while signing off v1 of this series with my current address.
> > > > >
> > > > > To summarize the main contribution of this patch series: Batching is introduced
> > > > > in zswap_store() of large folios: we carve out a large folio into batches of
> > > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> > > > > batch. Moving the fundamental operations that need to be happen to store a page
> > > > > to now work at the granularity of a batch offers opportunities to optimize them
> > > > > from these perspectives:
> > > > >
> > > > > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> > > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> > > > >
> > > > > 2) We keep the working set for each of the core store functionalities (alloc
> > > > >    entries, compress pages, store pages in zsmalloc) to be focused on a
> > > > >    batch, thereby minimizing cache evictions and benefiting from cache
> > > > >    locality.
> > > > >
> > > > > 3) Along the lines of (1), the main zswap_compress() batching routine obtains
> > > > >    the acomp_ctx mutex lock once per batch, and releases it after it has
> > > > >    processed all pages in that batch.
> > > > >
> > > > > 4) Any zswap store functionality that works on a batch can potentially be
> > > > >    parallelized as a next step, to further improve performance.
> > > > >
> > > > > Performance data: usemem with 60% over-commit:
> > > > > ==============================================
> > > > > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and with this
> > > > > patch series.
> > > > >
> > > > > Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini.
> > > > >
> > > > > Chromebook Diagnostics reports:
> > > > >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> > > > >   RAM: 16GB
> > > > >
> > > > > vng setup:
> > > > >          Memory: 7G
> > > > >            Swap: 3G
> > > > >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> > > > >
> > > > > zswap compressor:
> > > > >   ZSTD
> > > > >
> > > > > mTHP enabled:
> > > > >   64kB
> > > > >
> > > > > vm-scalability/usemem setup:
> > > > >
> > > > >   cgroup memory.high: 3G
> > > > >   4 usemem processes, each allocates 1200M anonymous memory, reads the
> > > > >   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
> > > > >   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
> > > > >   frees the memory and exits.
> > > > >
> > > > >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> > > >
> > > > What is --read-silesia? Is this a local change you made to usemem?
> > >
> > > Yes, this is a local change I made because I wanted to get compressed
> > > lengths besides 565, which is the only compressed length of data
> > > swapped out from the original usemem.
> > >
> > > To replicate my setup:
> >
> > Thanks for sharing the details. I am having trouble reproducing the
> > results, mainly because the standard deviation seems to be too high to
> > make conclusions. What is the standard deviation in your runs?
> 
> Sure thing! Let me know if it would be useful to upstream the
> --read-silesia option to the vm-scalability tree.
> 
> Yes, standard deviation is considerable, which is why I run usemem
> consecutively for 10 iterations and report the mean Average
> throughput. I could also report the median going forward if that
> helps. The cover letter vmstats are after 10 iterations. The last set
> of data I reported in this thread after applying patch 8 [batched
> version of zswap_compress()], had a mean of 20,946 KB/s, standard
> deviation of 5,391 KB/s and median of 22,477 KB/s. For reference, the
> stddev for the baseline mm-unstable was 5,397 KB/s.
> 
> I have found this methodology to be reliable in drawing conclusions
> because as zswap_store() performance improves, the outliers are fewer
> and the data is more clustered near the mean.

I think the stddev is too high to make any conclusions tbh, I will
respond to the other thread with Herbert.

> 
> >
> > Also, I tried measuring the latency of zswap_store() itself through
> > bpftrace, and it doesn't seem to change much throughout the series.
> 
> I ran bpftrace today to gather zswap_compress() latency per-page,
> before and after patch 8. It shows a clear performance improvement
> with compress batching for the reasons mentioned before:
> 
> Sequential_zswap_compress  nr_samples     p25     p50      p75
> p95       p99
> =================================================================================
> zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
> 130,165   323,961
> 
> Batched_zswap_compress     nr_samples     p25     p50      p75
> p95       p99
> =================================================================================
> zswap_compress_ns_per_page    339,088  42,081  52,633   63,185
> 118,461   191,710
> =================================================================================
>  Latency saving (ns)                   -1,866  -5,159  -25,305
> -11,704  -132,251
> =================================================================================
> 
> Hope this helps. Thanks!

