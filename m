Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13745606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OSyx9BAa
Received: by kanga.kvack.org (Postfix)
	id 310CB6B00EF; Mon,  9 Nov 2026 11:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E86D6B05B0; Mon,  9 Nov 2026 11:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8516B05B3; Mon,  9 Nov 2026 11:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7D5E6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:23:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2D7F40723
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:23:49 +0000 (UTC)
X-FDA: 85416101778.10.6742765
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A9A11C0009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:23:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSyx9BAa;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794241428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHf22tsdPPfDKAeOIiu4WmAuLGDaW8+V7RxrZhx4qXg=;
	b=hlZWoSM0icYliDxFDY8FRdpDGbSbO01ezEkEkxfDBQL1eM+oDz4zS46Wf3800PTveSIVdR
	q195qeo7t0GVKtQ8oREEA3svsLiy6RSwm+0lWGKz0hQUyMSO6mLLx7kPNByrS3ECu8Ey2I
	fpZ37fXpJqAc9FUBFSKr/nTLwGsvgSA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794241428;
	b=b4y5sf7sMnUIJAsZspMpptfcsL/GLa1kiJ+b2u1/xsm/Jm7SBM3zQf8xoqVFavjdMKXbXQ
	9RA3wy+yWYB0rF5RBuKc0+QPYGdbkFG42mtWDvv8O0p6i8e79BFqW5pCrISKczvWEiXqUf
	KYvoLNzTcwiU9xfvGnARGF8zemxOWsc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSyx9BAa;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F18544F1B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D8C1F008AB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794241427;
	bh=jHf22tsdPPfDKAeOIiu4WmAuLGDaW8+V7RxrZhx4qXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OSyx9BAa9gS4PwuytH0sMUh2QyzhT6ozk6cj07WytrOmwfGLoC3KN8+wL4IsPkOuq
	 wgVG4zxb4RwB9DVXmyHCHLSeoSIKvTTlZ76dxEOgcxdgh5ZVMrJn8kDrYEAtmPICgj
	 HcIX0pl3w2Da+iZvLrqGiSOmus+BORZjtThdpKZxcWwrVxHQ3tcpSVyFpPj3394gtE
	 W/u9WJffOZKTRUz/cmPGbuIut3k0lBJh4Lr4fpD0eyNtl0EUMyMqtkOJKeWLayU18J
	 7bZqP5NO02E3HFuQ9seJ2dkgfPCb0vq+tUoiRTiANl8ZRgEB5+Iv1d7viNOQxetQoE
	 D1SEz81YkI70g==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d5cb1b181so143654866b.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:23:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFBkttYROGa+zm+t5NgMaxr8ndVCSjBX10Hn/t0UfFw2e64QhMfpiwFHlewVAsVGFUyfr/wDMfmMA==@kvack.org
X-Gm-Message-State: APuU4Z9cn25gYIa/PDBwFGJ7+x9ArQTvMB9NkID4W+qHfHXI50Zb0l/k
	n3esU6yXOXs6rUQxTnjuf3iLfnanKqEtijfCo7IZn6fW9VrtNHRIdFMSEh3X0ub3jowg/ROTJOE
	AXR5zaHw+DqjNUziRFzHwT07EkSsfePE=
X-Received: by 2002:a17:907:ea89:b0:c3f:7270:10ab with SMTP id
 a640c23a62f3a-c4d6d491847mr331944966b.14.1794241425829; Mon, 09 Nov 2026
 08:23:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <au5l3KEjG_mri-br@google.com> <CACpmpoc3R8gwkMouwyFLw9PEqyDN1i6OcmPxsvZ1d0QOPSS_fQ@mail.gmail.com>
In-Reply-To: <CACpmpoc3R8gwkMouwyFLw9PEqyDN1i6OcmPxsvZ1d0QOPSS_fQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 9 Nov 2026 08:23:34 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOVf+gN0nbKkMGraTGhnCOG+5mpNBJvsZ=C5jDOssBf+A@mail.gmail.com>
X-Gm-Features: AclHuK8wGQGw5PDN9FVkkzijzlP7nY0X41Q1fjXtSpx5oni4CF9QZzjxFkOpA7k
Message-ID: <CAO9r8zOVf+gN0nbKkMGraTGhnCOG+5mpNBJvsZ=C5jDOssBf+A@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] Batched zswap_store() framework with compression batching.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A9A11C0009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: mtzbeeiuk5c4pdndyzm9jg3hmcpqsexy
X-Rspam-User: 
X-HE-Tag: 1794241427-828122
X-HE-Meta: U2FsdGVkX18I1FAc/usM8R1TZYpDdypPjFWmJ2uISnc6DlR4Sm0dRN7YH05FhivKxwEUl1fGtWxhw+LnTtxdyil+Nwk+8UaMskzGkRH8Lm8Iuqtq/ExgNaVJglQilp64MwOz5GO0IWljsh3YWgSIEbwIhZGQrFPhKqc2Itab7JgvLgEuhXHaIooWiVXHbDliM2py9cryT6TTae6vJJx6h4+Rudi2xuMvwuU697cyUQC5ne3bBcdpD3dTFFfRL7k005pQtHnh27oO17RPtC5WMQzqOACiNs3FrskHcmUxqR+JQVoT/ZlZOSfo2xHJbxz0IXLMiAcjL+c9gMuRHXgzwuZuyeMyxCiYhfufew24zyBbcF9ot77JYAanFw1kFXXw1v63F+73NrxzjX08I6X3y7EfcUsg/NmXaLHLFFc9JKceiZdXCqjgQMraxRfHjqyE4U+DWYiHkUXatosX0pnBC0zMoP/XLhjsNE+B7yTl47JryRw1mnjDuxUjv3FN4QGgW+SEyPMhoMYRdPRV3JgI5Xv0GlwGOszk4lpOMI5IzsZT1blIhFOOKEJpxytCIgMcvmWO0GeBk1NtrAScpjX8huIBcKS0CcO1yO6bwRuiYnCVrWT264OCvnAGQ4/Fn+Z981SXRyfOx5TA8Pfnv6CHE7gUQv6YGqtBlktn0OjVALMhcbj3FJukJrtBnoPXDTUpoHBD9QetKvxZLZO0cKyvikpZ5M40FrshcsEi4OFWu6wml5OfojgIC+HkqDnFbCoZR1b2g00ofNGO0mYPYDOntA5W/WkRC7AkAObvq1nOmcpXmnwFM75MVEhlg53rHf5yXFt+VJdL8mIUBdX3MNCnu21uZPTBPUfeYLTi8Bh8369rk845gL9D4xKVnD+PDbyM+UsTK3m+4lNmbIH2THzVv9W2EQJexzqZu9bD1jCUK3VAjk00iVYzq6zqeTfSgN05ofjYL+l/0YUvXreX/zi
 trt/LgGz
 PU09bfLwr0tNf08Mm6ZZWwdKU/ADMySpZLfUNHIGmu2Z6i+EwkOmYTRKxbzCLfaDl+huZQi9YGoe2e9gVH7SfEjDeA/ftG48n8OjDzLOByc0DlaDWfsG0f1XhuwLjh0iMbBdLNZ/YRfQ978cPi/7iGuu4SKI62hUlgdM+2bNLrCqeKLn1XQ7p17WKXpYKkJdX+gKlPd1GBMzM7WiSW221ObN29X01Jl4Azt2IT1j05JCx9Q9eSpM0iqRAQcD2oHociJ8yd7i4xfTinXQhUj9OJYkiv0rSS9HQ0KrO8B8+FFWUfHtlEZnqlyKVqCo4Clv+CZ3xhK7iAMB5pfw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> > As with previous versions, I cannot reproduce these results. I tried
> > with a QEMU VM on a Cascade Lake host. I saw marginal improvements with
> > patch 6 and no significant gain with patches 7-8.
> >
> > I noticed that you omitted high-level metrics (e.g. throughput), I
> > didn't see significant changes in throughput, and I also ran a kernel
> > build and saw a small regression in some cases (probably with order-0
> > folios) and no significant improvement otherwise. Even if latency for
> > some functions does improve slightly, it doesn't matter if it doesn't
> > show up on higher-level metrics.
> >
> > It could be the difference in setups, or the overhead of bpftrace hooks
> > for zswap_compress() might affect measured zswap_store() latencies, as
> > you will have fewer zswap_compress() calls with patch 8.
> >
> > As advised previously, I would trim down patch 6 to the bare minimum
> > (without all the scaffolding and prep work for patches 7-8), and send it
> > separately (with patch 5), and we can check if it's worth adding, I am
> > still concerned it might be adding overhead for order-0 to be honest.
> >
> > I am questioning the benefit of batching here without HW batching, so
> > far the results are more concerning than encouraging. I already spent
> > too much time trying to reproduce the performance gains. Also, sending
> > new versions without resolving discussions on previous ones is not
> > really productive.
>
> Thanks for taking the time to test and provide feedback, Yosry.
>
> I omitted high-level metrics like throughput since you raised a
> concern about variation. Hence, I decided to go with the "ultimate
> truth" which is bpftrace latency measurements.

I didn't mean that we shouldn't look at high-level metrics, it's just
that the test setup had too much variance for the high-level metrics
to be useful so I checked the low-level latency. Ideally we'd test
performance with benchmarks that should have stable high-level
metrics.

> For performance validation, I only have access to a 16G Chromebook
> with a Crostini VM to which 13G is allocated. I am setting aside 3G
> for swap and 7G for QEMU. Within the QEMU VM, I am selecting 2 E-cores
> to run the 2 usemem processes to minimize variation due to frequency
> fluctuations. This setup has its own limitations such as being unable
> to fix the frequency.
>
> Despite all this, I have been able to consistently replicate the
> bpftrace latency improvements with patch 8. My results show regression
> with patch 6-7, and improvement only with patch 8. As noted in the
> cover-letter, patch 8 adds significant latency improvement for order-0
> folios. This is with ZSTD. FWIW, these are bpftrace latency
> improvements in a significantly memory constrained environment and
> this ought to be a useful data point. I have been posting general
> vmstat "system health" metrics to prove that nothing unexpected is
> going on.
>
> My data shows that order-0 zswap_store() tail latency improves by 11%
> over mm-unstable with patch 8, although p50 is roughly similar between
> patches 6-7 and 8. PMD store latency is significantly better at p50
> and p99 with patch 8.
>
> Likewise, p99 latency of zswap_compress() alone improves by 3% with
> patch 8, while it degrades with patch 6-7. p50 is almost the same with
> patch 8, although patch 6-7 regresses. The page-normalized
> batch_compress() p99 latency is better by 15%. All comparisons are wrt
> mm-unstable.
>
> Hence, I believe even in a memory-constrained setup such as mine,
> batching significantly (7-15%) improves p99 in all cases, with 4-5%
> gains in p50: for order-0 and PMD folios.
>
> In addition to the latency benefits shown through my validation, I
> would like to also emphasize the strategic benefit of moving zswap to
> use batching, as noted under "Conclusions" in my cover letter. IOW,
> batching within large folios to improve workload metrics can only do
> so much (in proportion to the # of large folios reclaimed and
> contribution of zswap_store() to the overall allocation-reclaim path).
> What this patch series attempts to provide is a zswap batching
> framework upon which additional improvements can be built, such as
> reclaiming multiple folios as a batch. I believe that compress
> batching is essential to support these next steps, which improve
> workload throughput/latency metrics even more than simply batching
> within folios. This is with ZSTD.

Without a direct line of sight for such features and consensus from
the community, landing the framework in zswap is not very useful, it
actually increases maintenance burden.

> Due to the environmental constraints, I haven't been able to reliably
> use kernel compilation for validation.
>
> I have been doing my best to resolve previous discussions by
> incorporating the calculate_high_delay() hack that you suggested to
> reduce variation. The data posted in v3 comprehends this suggestion.

Oh I wasn't suggesting you generally test with this hack, I just
noticed that the variance was resulting from memory.high throttling
and nullified it to see what the numbers look like without it. As I
mentioned above, ideally we see stable improvement in high-level
metrics. usemem is already a microbenchmark, if we can't demonstrate
stable improvements in its metrics and have to measure latency of
specific functions, the significance of the optimizations is
questionable.

It's a tradeoff between maintainability and performance. It doesn't
really make sense to add complexity for marginal performance benefits
on a small subset of setups.

>
> I would like to suggest/request the following, as next steps:
>
> 1) Can we reconcile our methodologies for usemem bpftrace
> measurements: # of vCPU, usemem command line, reading Silesia, etc.
> Also swap space and QEMU memory allocation, using linear lhists() in
> bpftrace, etc. If you can share these details, it would be very
> helpful. Thanks again for your time!

I ran a VM with 2 vCPUs, 8G of memory, and a 25G swapfile (although
the size of the swapfile doesn't matter much).

I used zstd with the default pool limit (20%) and the shrinker off,
with 2M THP enabled. I set memory.high to 3G for usemem like you.

I used this usemem command with the diff you posted in the last version:
$ usemem -w --read-silesia -O -b 1 -s 10 -n 2 2400M

For kernel build, I used:
$ kcbench --llvm -s 6.8 --nodownload -j 8 -i 1 -o <PATH>--detailed-results

I don't have the bpftrace commands but it should be pretty standard (I
think I used hist() not lhist() tho).

All that being said, I don't think I have more time to spend on this tbh.

>
> 2) Does the kernel community offer servers for contributors to test
> their optimizations at scale?

I don't believe so, but I am not sure.

> 3) Can I please request the help of other zswap maintainers/reviewers
> to validate this series with ZSTD on a server setup with usemem
> running on 30+ cores, under high over-commit ratios; through bpftrace
> and/or throughput metrics.

I can't ask people to spend time testing this, I already spent more
time than I have and I am sure other people are also busy. If someone
is interested in testing this and collecting performance numbers, that
would be up to them.

