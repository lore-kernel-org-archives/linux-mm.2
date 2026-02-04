Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 786EDE83F05
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09356B0092; Wed,  4 Feb 2026 13:17:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0F66B0093; Wed,  4 Feb 2026 13:17:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE39A6B0096; Wed,  4 Feb 2026 13:17:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC92D6B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:17:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B459B7E92
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:17:56 +0000 (UTC)
X-FDA: 84407582952.19.1A67F72
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBC261C0007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:17:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vl/cR+vx";
	spf=pass (imf21.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770229075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vw3PSnoy6sYwGPshV5lDvteVYd7nzV8fPjKvcpV88qA=;
	b=vY28BnjyVh+q44KBQgdeQ9o/odF5BCQBn9TFVn5EXju7rcFfSwYPmrbF8cHyeDgwjV/rur
	+xoKVH33K6l96zWj42z6PWiYROWeQMboOFevvTAJNw4zbNLKTHn3XV4+D0ahoCgyDUOa8y
	gppKUvpKdRPCwhE3uAKYGSaSUnvBxQ0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vl/cR+vx";
	spf=pass (imf21.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770229075; a=rsa-sha256;
	cv=none;
	b=3Fl8w3ykQ/cLxMhMSwriCdzQHJOsklFZg9IKuZ7P8u9JZwtmg73VoaKdb7q6yvwe06gTbB
	5AQp25+tYSSnTy/33/ckxijltdJhkwDc3WahO3YlPFXNIsnGsjb5N8OdD5mv76GDVUSoKP
	sh228+PZteal4GD5m1qtp3BlI25IzA4=
Date: Wed, 4 Feb 2026 18:17:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770229073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vw3PSnoy6sYwGPshV5lDvteVYd7nzV8fPjKvcpV88qA=;
	b=vl/cR+vxrM2HuZ36TIUC8//EEbfGNwG+ngOf+qvLTz568hLldOn+1hVJI0Mfk6ti3vLFVM
	TjOAsRffosZ7voJRy14QnzTx3z15qkFYZNx5ln+1TOPkyX1I2K4Sc2nQkazs9wDld/ndWj
	9xhjoSj3u9alpLtp7NKxoONXx/KhD1Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Message-ID: <dhw3loxu2myculgk5vhpsbe5nupzvtnkei7u4zknc5ce5c6w62@csablv6vl2e5>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: CBC261C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: kbhd73p73f31ydu4oych91eznh4wku6k
X-HE-Tag: 1770229074-847182
X-HE-Meta: U2FsdGVkX1+9JokumbrvmyOfxaqqm3shmjWeyPJOeNHBv4SyyFg9I1Whcci6dp+erYNsTNe/I6p9v64NgFERGYiSjfz8cOLVXQLlhqCkGKIm6+JXbW7UFioJFvk1vIm1oZO5xnBPrzdxGUhtDP6S/8gCU/izDrWqZL9Ray/OraTAnF4uB8SfHWeDt+RwQt17R4d3UuXen7L9TW56G8enBHAPFvR2REsv98a+tlIZ1XU5Dp6a9MFGgfh31nUqmKhCEFE8sLFTRq/1anZnlpB7pZlmpADVZnjtd9Uv0D6MIwSvOgGbmlbygl0s4l3blsLHPNIvSNu1kOHzXh+ot/D3J4o7pWI7HFn8qNoSc3X1I6AwNoXsmsLhUraTHT4DFwwzFulGNkfMkjSPVbBauyk808d1VAFQY+GzbBa2N57nxTUJeLqxW8p0yW/SXqxJgLk3lV7Z0DcVDADwb4tLW9Mkn4ajkEUBsPnlS/wppEhX7Y1Q1Pnnbh6R2ZK+tvo0e3w6TuntGwmomW/mErJbtQY3hlJTC7iY+OrEo03+K/c1460AjfjhyaSLb/rKyBtrIVoN8+Pd1IAiYbYkblwjfiKfNmNUByYzGEfl45peqShzgWghND5PdQ68EgHEspUGpJBaF+Rp4S4OMNGwQ35rUn8AF+YkxnHHfSm0uxsImql8P3v1SsvBdqafznNqi3fPJ+YQcmAHuHzk9P49/hL90ZbP804KUs6l7oM3NQnC0lXHiFy9KYtlXbmKuETqJKRVCijq1iJR4B/U2NnOBgfM3PCKWwvnmhjxgnMQggxan9lIMAIePohBEV+sOTPYROpXo+CQTuVBFsDBfDlzPgucxjuhrZZ7mOzNJXcDvpovbofImrorRTri/xfigaNUocSYcBAkzgLykqb0l6xrp6WKkuXN4c0StZqRg2nj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 07:35:37PM -0800, Kanchana P Sridhar wrote:
> We introduce a new batching implementation of zswap_compress() for
> compressors that do and do not support batching. This eliminates code
> duplication and facilitates code maintainability with the introduction
> of compress batching.
> 
> The vectorized implementation of calling the earlier zswap_compress()
> sequentially, one page at a time in zswap_store_pages(), is replaced
> with this new version of zswap_compress() that accepts multiple pages to
> compress as a batch.
> 
> If the compressor does not support batching, each page in the batch is
> compressed and stored sequentially. If the compressor supports batching,
> for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batch
> is compressed in parallel in hardware.
> 
> If the batch is compressed without errors, the compressed buffers for
> the batch are stored in zsmalloc. In case of compression errors, the
> current behavior based on whether the folio is enabled for zswap
> writeback, is preserved.
> 
> The batched zswap_compress() incorporates Herbert's suggestion for
> SG lists to represent the batch's inputs/outputs to interface with the
> crypto API [1].
> 
> Performance data:
> =================
> As suggested by Barry, this is the performance data gathered on Intel
> Sapphire Rapids with two workloads:
> 
> 1) 30 usemem processes in a 150 GB memory limited cgroup, each
>    allocates 10G, i.e, effectively running at 50% memory pressure.
> 2) kernel_compilation "defconfig", 32 threads, cgroup memory limit set
>    to 1.7 GiB (50% memory pressure, since baseline memory usage is 3.4
>    GiB): data averaged across 10 runs.
> 
> To keep comparisons simple, all testing was done without the
> zswap shrinker.
> 
>  =========================================================================
>   IAA                 mm-unstable-1-23-2026             v14
>  =========================================================================
>     zswap compressor            deflate-iaa     deflate-iaa   IAA Batching
>                                                                   vs.
>                                                             IAA Sequential
>  =========================================================================
>  usemem30, 64K folios:
> 
>     Total throughput (KB/s)       6,226,967      10,551,714       69%
>     Average throughput (KB/s)       207,565         351,723       69%
>     elapsed time (sec)                99.19           67.45      -32%
>     sys time (sec)                 2,356.19        1,580.47      -33%
> 
>  usemem30, PMD folios:
> 
>     Total throughput (KB/s)       6,347,201      11,315,500       78%
>     Average throughput (KB/s)       211,573         377,183       78%
>     elapsed time (sec)                88.14           63.37      -28%
>     sys time (sec)                 2,025.53        1,455.23      -28%
> 
>  kernel_compilation, 64K folios:
> 
>     elapsed time (sec)               100.10           98.74     -1.4%
>     sys time (sec)                   308.72          301.23       -2%
> 
>  kernel_compilation, PMD folios:
> 
>     elapsed time (sec)                95.29           93.44     -1.9%
>     sys time (sec)                   346.21          344.48     -0.5%
>  =========================================================================
> 
>  =========================================================================
>   ZSTD                mm-unstable-1-23-2026             v14
>  =========================================================================
>     zswap compressor                   zstd            zstd     v14 ZSTD
>                                                              Improvement
>  =========================================================================
>  usemem30, 64K folios:
> 
>     Total throughput (KB/s)       6,032,326       6,047,448      0.3%
>     Average throughput (KB/s)       201,077         201,581      0.3%
>     elapsed time (sec)                97.52           95.33     -2.2%
>     sys time (sec)                 2,415.40        2,328.38       -4%
> 
>  usemem30, PMD folios:
> 
>     Total throughput (KB/s)       6,570,404       6,623,962      0.8%
>     Average throughput (KB/s)       219,013         220,798      0.8%
>     elapsed time (sec)                89.17           88.25       -1%
>     sys time (sec)                 2,126.69        2,043.08       -4%
> 
>  kernel_compilation, 64K folios:
> 
>     elapsed time (sec)               100.89           99.98     -0.9%
>     sys time (sec)                   417.49          414.62     -0.7%
> 
>  kernel_compilation, PMD folios:
> 
>     elapsed time (sec)                98.26           97.38     -0.9%
>     sys time (sec)                   487.14          473.16     -2.9%
>  =========================================================================
> 
> Architectural considerations for the zswap batching framework:
> ==============================================================
> We have designed the zswap batching framework to be
> hardware-agnostic. It has no dependencies on Intel-specific features and
> can be leveraged by any hardware accelerator or software-based
> compressor. In other words, the framework is open and inclusive by
> design.
> 
> Potential future clients of the batching framework:
> ===================================================
> This patch-series demonstrates the performance benefits of compression
> batching when used in zswap_store() of large folios. Compression
> batching can be used for other use cases such as batching compression in
> zram, batch compression of different folios during reclaim, kcompressd,
> file systems, etc. Decompression batching can be used to improve
> efficiency of zswap writeback (Thanks Nhat for this idea), batching
> decompressions in zram, etc.
> 
> Experiments with kernel_compilation "allmodconfig" that combine zswap
> compress batching, folio reclaim batching, and writeback batching show
> that 0 pages are written back with deflate-iaa and zstd. For comparison,
> the baselines for these compressors see 200K-800K pages written to disk.
> Reclaim batching relieves memory pressure faster than reclaiming one
> folio at a time, hence alleviates the need to scan slab memory for
> writeback.
> 
> [1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

Herbert, could you please review this patch since most of it is using
new crypto APIs?

Thanks!

