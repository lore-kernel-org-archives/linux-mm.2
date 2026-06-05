Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AB0CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77676B0005; Fri,  5 Jun 2026 05:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28376B0088; Fri,  5 Jun 2026 05:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16E96B008A; Fri,  5 Jun 2026 05:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADDC06B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:53:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 506D1120928
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:53:14 +0000 (UTC)
X-FDA: 84845395908.17.08A42DF
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf07.hostedemail.com (Postfix) with ESMTP id D316C40002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:53:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BrZtdbuE;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780653192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXiBXZl1Vmlir2P5Qz3JcAhAkCPHs/FXfJy9ZEGf6VQ=;
	b=oJwhlfAIjUUCQcC+/GMS1sOM5ANSk2XRc1plYQyd4RmQcW2UOe6JKXB0kh33MiBmdPY/fZ
	X65JOpvTigR/+GW8iDXehlH99tIAnGbpy/7g09B6V7bHk0Zp/tIMbczvsJ12DrxooDqPKw
	9bJmJh2x5rn+dJ4Lu91oIppTENBaaNs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780653192;
	b=mqtIF6pyCcxAEmqIA6NkUQWXQ6q6Gnate/QTzTVmhBjicYgFwVANs/M/ya7qKD878tfQRm
	fKGv9sNmZkDqBTqENx+nYOjRoAm4wNqf5wywjAqDN8l4MxJi41P9m2wVkNszDsziSagXvx
	eIZGJMN3Fu7vzowwUkK8CibLieB5Tlk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BrZtdbuE;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780653186; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=rXiBXZl1Vmlir2P5Qz3JcAhAkCPHs/FXfJy9ZEGf6VQ=;
 b=BrZtdbuEbLM3OJ9YH/EXiKdXZls5Lz605N5tDPReDsABsV+3B+8VjQX6A8qDQKesO1/AsD
 0Ft0eCFC/56dLAQkQ8C5QV/VIsZiRMZuerEGVnle3O6oOzwjbQqxBZNP8vvL7XLv92srNH
 +ObXISVTUCvMCe7jAEdBK4MBky5dyt7+I/2HR0xZ864YvzUSE1cGnTf03w83j83ixKx0ah
 KhfVgLctl8lClD6dfexvUg67qTzTVkxkQzMBbMv3JSODMBvC8nmaXSx92jrmWB72xwht6z
 dBNs4/Lx/BQy6e8P2x/b6W7FE/l4JQpOOjrm/p/pDKuQ1ytsbc/Aq3I9zhtryg==
Content-Type: text/plain; charset=UTF-8
To: <apopple@nvidia.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260605095243.45803-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <aiEoByaQdRR3xtM5@nvdebian.thelocal>
References: <aiEoByaQdRR3xtM5@nvdebian.thelocal>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Subject: Re: [PATCH v4 0/8] mm: speed up ZONE_DEVICE memmap initialization
X-Lms-Return-Path: <lba+26a229c80+465f48+kvack.org+lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Date: Fri,  5 Jun 2026 17:52:43 +0800
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D316C40002
X-Stat-Signature: aqi5o85nwhnbh3911jim6btkmcq49ots
X-HE-Tag: 1780653191-172300
X-HE-Meta: U2FsdGVkX188+Kask1gCobjUZMZDk61ggW8ReItGQEQ6kIy9bWSqJtqfPVfCOWgO3NexoXn6f7PQM4dC0UIu4kHsZWPxPaVpGBMF1Qx6YenoB1ystLTCQEKvdvcNcu3mchOAXkCm+DXptYbetWcY6eLi8hFB8cCHSW5XA1JUEkY06xwIWCnfBI0fmjb5Et1oYjZDmB44ImHM8knRcXrZFythMx/b0z4Fhgjqxa7+Ig9fYUVdLeZWEXPk5Q1+m0GqggHw5OhNxFQWzpBG/x+noB3up8s349oGqsoWTCOoY2P9Saeb0/HujqyU34XFmFVllAM9SsooSS3Aon3GbWBzwdtFLzCvDSNGdKgLPuscp+yfvGx8UqzQSgRxhgVmmtQkKd2sYKMS5LkQ0DuenSgAZ4uAtw57DCJb0CVGwEh8QJ4aPZ1gnrDkTSLqlB3CWgPBgOgwGcp5qIP3jNv28FNDT0Vbg9/0EXTthWIFvPG930V58nAh5xrcz4seqV8mlWogzcSoJSSRR+CymkbfGNgByhurXDYEI+Ejd1TYOCJwdMYyAJ36SUbYGYl+quoIIY5oD4eczEbdiZqYbc49ogKhhEJG+XttehCI3n47E1Fq7UVy0+mgG2124LtNpnNzqZgaR5ZBug2tF4p6+Y9uiqilJAIyXaT4foDCSUu4nuXEitPuiCfo2knul/yXGww0MBpKJ4HOgk7zxSQRiWZfAZRfPIGlUklNbxbRwMTBYOlJNwxC9ee0gbSuaC+L8zZu3ERNytABG5WXuJkYPsXdL0HtLdmlhQA3uOg2by7ag6PFM6PMCpW/FQ5RegSwG7A7I18Z/GUCzuBt/Z4ov2fGurUPJSNsErcuWfYhCSx6VhMr5DaKf1WX5JxWCvdfQmtceF7FGEt9w1PHqw1xf1D0A49Xm2/z+fL5maI1S+Tyqfy0ufO4AFys0y5yP+KF/kqnbiaSFF1Gp5c4/t+4mPqKLpp
 mNoSq4jI
 7CYBobO8zCm/qf98iyF3alUqLDYKxpS0lNOR2m5vQFzk9ZUORpZEnu9ik/sA7ZMe5df6UVZ7neL818Javg02U7fxGtzNFm6AF+mPG7rqSW6CBT1Kf2UL3Dwt7dfi3HrKoDDtrfzS2SrHuxXk9922DImJpdx0OgH+KGVKIVytDJET4sXb7W3xzvgdLf6INRFu4u3t97pb0Nln9xJrns+cOysoIoLw03BTF3QRvtTEKEmvZfnYtrJAG0UTi34/FWkC0bMKF8k8es2fa4JtvCTg1xPM5eoKRwkEV82RoNPZWAxwwaRu1OLT3PFD4aLJPjNWsLSDiQk/A34RJOsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 18:14:05 +1000, apopple@nvidia.com wrote:

> On 2026-06-03 at 18:01 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> > memmap_init_zone_device() can spend a substantial amount of time
> > initializing large ZONE_DEVICE ranges because it repeats nearly
> > identical struct page setup for every PFN.
> >
> > This series reduces that overhead in eight steps.
> >
> > The first patch fixes a stale comment in __init_zone_device_page() so
> > the documented refcount policy matches the current ZONE_DEVICE code.
> >
> > The second patch factors the reusable pieces out of
> > __init_zone_device_page() so later patches can share the same logic
> > without changing the existing slow path.
> >
> > The third patch adds set_page_section_from_pfn(), so callers that want
> > to refresh section bits from a PFN no longer need to open-code
> > SECTION_IN_PAGE_FLAGS handling.
> >
> > The fourth patch adds a template-based fast path for ZONE_DEVICE head
> > pages. Instead of rebuilding the same struct page state for every PFN,
> > it prepares one reusable template through the existing slow path,
> > refreshes the PFN-dependent fields in that template, and copies it to
> > each destination page.
> >
> > The fifth patch extends the same template-based approach to compound
> > tails, so pfns_per_compound > 1 can also benefit from the fast path.
> >
> > The sixth patch introduces memcpy_streaming() and
> > memcpy_streaming_drain() as a generic interface for write-once copies.
> > Architectures that do not provide a specialized backend, or cases that
> > cannot safely use one, fall back to memcpy().
> >
> > The seventh patch extends x86 memcpy_flushcache() small fixed-size
> > fastpaths so struct-page-sized streaming copies can stay on the inline
> > path when alignment permits.
> >
> > The last patch switches the ZONE_DEVICE template-copy path over to
> > memcpy_streaming(). It keeps pageblock-aligned PFNs on regular memcpy(),
> > uses memcpy_streaming() for the remaining write-once copies, and drains
> > streaming stores before later metadata updates that may depend on them.
> >
> > This is not intended as a steady-state data-path optimization. Its
> > benefit is in pmem bring-up paths where memmap_init_zone_device()
> > dominates device online / rebind latency, such as:
> >   - fsdax or devdax namespace creation and reconfiguration
> >   - nd_pmem / dax_pmem driver bind or rebind
> >
> > In those paths, the kernel initializes a large vmemmap range once and
> > does not immediately benefit from keeping the copied struct page state
> > hot in cache. Reducing write-allocate traffic in that one-time setup
> > path can therefore reduce end-to-end device bring-up latency.
> >
> > The optimized path is disabled when the page_ref_set tracepoint is
> > enabled, and sanitized builds remain on the slow path so their
> > instrumented stores are preserved.
> >
> > Testing
> > =======
> >
> > Tests were run in a VM on an Intel Ice Lake server.
> >
> > Two PMEM configurations were used:
> >   - a 100 GB fsdax namespace configured with map=dev, which exercises
> >     the nd_pmem rebind path (pfns_per_compound == 1)
> >   - a 100 GB devdax namespace configured with align=2097152, which
> >     exercises the dax_pmem rebind path (pfns_per_compound > 1)
> >
> > For each configuration, the corresponding driver was unbound and
> > rebound 30 times. Memmap initialization latency was collected from the
> > pr_debug() output of memmap_init_zone_device().
> >
> > The first bind is reported separately, and the average of subsequent
> > rebinds is used as the steady-state result.
> >
> > Performance
> > ===========
> >
> > nd_pmem rebind, 100 GB fsdax namespace, map=dev
> >   Base(v7.1-rc6):
> >     First binding: 1466 ms
> >     Average of subsequent rebinds: 262.12 ms
> >   Full series:
> >     First binding: 1359 ms
> >     Average of subsequent rebinds: 108.36 ms
> >
> > dax_pmem rebind, 100 GB devdax namespace, align=2097152
> >   Base(v7.1-rc6):
> >     First binding: 1430 ms
> >     Average of subsequent rebinds: 229.12 ms
> >   Full series:
> >     First binding: 1273 ms
> >     Average of subsequent rebinds: 100.17 ms
> 
> The results here are impressive, but I've been having trouble replicating them
> with hmm_test on my local development machines. Both an older AMD machine and
> a newer Arrow Lake based machine shows ~3% worse performance with this series
> applied doing ZONE_DEVICE_PRIVATE.
> 
> This is based on measuring the memremap_pages() call when inserting test_hmm.ko
> in a VM using the following hack to measure 10 64GB memremaps. Is there an easy
> way for me to replicate your results in a VM? Or is there something in my
> testing that I'm missing here?
> 
> ---
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 213504915737..a1d5463dbc86 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -34,7 +34,7 @@
> 
>  #define DMIRROR_NDEVICES		4
>  #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
> -#define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
> +#define DEVMEM_CHUNK_SIZE		(64 * 1024 * 1024 * 1024UL)
>  #define DEVMEM_CHUNKS_RESERVE		16
> 
>  /*
> @@ -565,6 +565,8 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
>  	unsigned long pfn_last;
>  	void *ptr;
>  	int ret = -ENOMEM;
> +	int i;
> +	u64 t0, total = 0;
> 
>  	devmem = kzalloc_obj(*devmem);
>  	if (!devmem)
> @@ -613,6 +615,22 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
>  		mdevice->devmem_capacity = new_capacity;
>  		mdevice->devmem_chunks = new_chunks;
>  	}
> +
> +	for (i = 0; i < 10; i++) {
> +		t0 = ktime_get_ns();
> +		ptr = memremap_pages(&devmem->pagemap, numa_node_id());
> +		total += ktime_get_ns() - t0;
> +		if (IS_ERR_OR_NULL(ptr)) {
> +			if (ptr)
> +				ret = PTR_ERR(ptr);
> +			else
> +				ret = -EFAULT;
> +			goto err_release;
> +		}
> +		memunmap_pages(&devmem->pagemap);
> +	}
> +	pr_info("avg memremap %llu ns\n", total / i);
> +
>  	ptr = memremap_pages(&devmem->pagemap, numa_node_id());
>  	if (IS_ERR_OR_NULL(ptr)) {
>  		if (ptr)
> @@ -629,7 +647,7 @@ static int dmirror_allocate_chunk(struct dmirror_device *mdevice,
> 
>  	mutex_unlock(&mdevice->devmem_lock);
> 
> -	pr_info("added new %u MB chunk (total %u chunks, %u MB) PFNs [0x%lx 0x%lx)\n",
> +	pr_info("added new %lu MB chunk (total %u chunks, %lu MB) PFNs [0x%lx 0x%lx)\n",
>  		DEVMEM_CHUNK_SIZE / (1024 * 1024),
>  		mdevice->devmem_count,
>  		mdevice->devmem_count * (DEVMEM_CHUNK_SIZE / (1024 * 1024)),

Thanks for the feedback and for sharing your test results.

I reran the measurements on my side using two setups. I do not
currently have access to physical PMEM hardware on my side, and the
target use case for this work is a virtualized environment. So my
measurements were taken in a guest using a 100G emulated pmem device
backed by a regular file on the host filesystem.

First, I followed your modified test_hmm.c approach, i.e. looping
over memremap_pages() / memunmap_pages() and measuring the average
memremap time in the MEMORY_DEVICE_PRIVATE case, where the vmemmap
backing comes from normal system RAM. On this setup, I got:

- base kernel: avg memremap 222.0 ms
- patches 1-5 only: avg memremap 206.9 ms
- full 8-patch series: avg memremap 264.1 ms

I also enabled the pr_debug() timing inside memmap_init_zone_device()
for the same setup, and the numbers tracked that closely:

- base kernel: 221.0 ms
- patches 1-5 only: 206.0 ms
- full 8-patch series: 260.1 ms

So on this path, patches 1-5 seem to help, but the full 8-patch series
does not.

Second, I also tested a benchmark-only setup corresponding to the
FS_DAX map=dev case, where the memmap itself is allocated from the dax
altmap range rather than normal DRAM. On that setup, I got:

- base kernel: avg memremap 200.8 ms, pr_debug 196.4 ms
- full 8-patch series: avg memremap 117.2 ms, pr_debug 113.5 ms

So on my side, the full series shows a clear gain in the
FS_DAX + altmap case, but not in the MEMORY_DEVICE_PRIVATE / DRAM-backed
vmemmap case.

If convenient, could you also try the same kind of measurement from my
cover letter, or at least enable the pr_debug() in
memmap_init_zone_device(), to check whether the delta is visible there
on your setup as well?

Also, if you have time, could you please try your modified test_hmm.c
setup with patches 1-5 only? On my side that configuration still shows
a measurable improvement.

Given these results, I would also appreciate your advice on how best
to evolve the series. My current understanding is that patches 1-5 are
a more generic optimization, while patches 6-8 are only beneficial in
some cases. Do you think patches 1-5 alone would already be a
reasonable candidate for upstreaming?

For patches 6-8, I am not yet sure what the right direction is. Would
it make more sense to expose some explicit opt-in mechanism so that
the movnti-based path is selected only when desired, or does it make
more sense to use that path unconditionally for FS_DAX map=dev case?

I would also be interested in your view on why the FS_DAX + altmap
case shows a large gain while the DRAM-backed vmemmap case shows a
regression with the full series. I do not think I fully understand
that difference yet.

Thanks,
Zhe

