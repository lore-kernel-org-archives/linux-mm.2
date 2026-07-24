Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF744C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 07:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9CD6B007B; Fri, 24 Jul 2026 03:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672536B0088; Fri, 24 Jul 2026 03:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D186B0092; Fri, 24 Jul 2026 03:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 165EA6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:31:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 912C01C04B1
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:31:02 +0000 (UTC)
X-FDA: 85022848764.12.68EB4DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E20CD20003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:31:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PCFHLxp6;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784878261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRyaonZT0RqcsE1xlqGu0bDb/oq1AhEjwIgABdlyRuk=;
	b=qIdSHJqEWTuOiK5EketjGUZS589+62CCwv9e+5UV/eU93KF/5KJbWHVA+qRmf94KzzNlZ5
	w8BdVSW3yNnjnlwV+lH1+7KvigDbxs5BHrPUsSHBs8PyvnFz3D1I+8JJ5J4D4akAOoBJvm
	e1JlSnbHXt3VHIET/IKPfLMg+2pTu7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784878261;
	b=cVJsNzoroIKwygB+xIG6yEpZGKuPczC+PTo4eB56Vy+KCpMFKDcpuYJ8KXQg9J7ycl2101
	NxwklaqgzzinbEyK0DiC8SQ+3X3GKk2xfrtiWDE7wPLrMA6brjH6Pt+GNnJRwlqMNEZYqQ
	OtaKvN9SHojiCyfX+QR/vfxpdMVZ84w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PCFHLxp6;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5DF343BB3;
	Fri, 24 Jul 2026 07:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461A81F000E9;
	Fri, 24 Jul 2026 07:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784878259;
	bh=vRyaonZT0RqcsE1xlqGu0bDb/oq1AhEjwIgABdlyRuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PCFHLxp6gQQvj6vt2fQP3B2MY2tcKYGxKG/3FXWBOlaeXxCUzDajThuZL5WzcLw7a
	 2ClCCMRm0cImNimHpCMjM1uT8ZoJvYHGPAsp/d2yxxFO9FwNADUJf7NeoSO+E8x+hG
	 Cj4rKiinADILDN5eOMDTd1BwTP7cAAE4/tkROz1McJ6StnJCZMUl2f0vr78s1ByTN5
	 NOQcx4tam9JHbn5SnuHvI6FBWJzrZlohHOZV0ZmNrhstiJH7QysxTTjaAXpmUwe/vW
	 4EEZkHCJehvCCsad8jhMmXOrPoO1SPog9Zs8oRa1NzZPlvE6odAtFzRVnKJERrMErC
	 4S6Ps0phNhxGQ==
Date: Fri, 24 Jul 2026 08:30:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm/vmpressure: scale the vmpressure window with machine
 size
Message-ID: <amMPWbcKoXQ1Mxjw@lucifer>
References: <20260724054305.516126-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724054305.516126-1-cui.tao@linux.dev>
X-Rspamd-Queue-Id: E20CD20003
X-Stat-Signature: wqgsk7wr739pijed45t57mqrek7u7mrx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784878260-475032
X-HE-Meta: U2FsdGVkX19s2VIzTAfvLxGi3+vmzKXewM/Us4BtKE8a+EmzsGdY0t6C6hxY4vyh36XlM//duI1qj0WgaAJj70n9ET8P67BmvFIpWc+MMdj0Axwsbx2lOCUBlSEj9P7X6dGGprPJOLJbunGd/xxY98+tRAtU1ztO9Fa+5kcBGY81FWn0B00S3M8deqQlpk92RnbG+OYxw5W4Z4+mE5AVTTsYLdXW47+yZZdD4mErwW8DIpeyw1uJ5mjhL3CVzmsBdQMdPcJuu9PIRTkZ88s+N1Djt5ygUfNS5xam372rPcurMBsoYsdmfwdluPS6XBiB/jlSEnDi88tUk2NNHR4kUgsV3TsvJ0L5LCOYCM9P/78y87GxAak9WUFxZCq9JChDTE80jm407PqoCv3aZ7Piq6iCnD+32a5A2wv2/Lvddw19eY5KfPL4DxiTRR9yzjtgFMl3+GmAj0cvSDkdw6+uyv++XjjTBfarVJDcgjftz/3DExUO51+71ykC8X3uGkRmBynRG05ZN3T45FwV4iHTYlgAzekFAkRzmNfw6Bfa+1PGACty9O2eRVG2BdvmVS6XOruEu/sNQ/C0NrzG/BxSPkDhK2IZWNbYwSzDFalwjxnxBZWV18TVoXMqE5hqvmXkxuo51JaRfEUA9pVTiinh5NNQbrnTNiykKKBARK3cN+9qm2GKEFEiKTY2n5dnoG7+35+ouX4HdOb9XTKhLulBddhgsZJ3RzxykKePSdzV2ejpbymuySNVOW0o4+EbjL0CSHlw1oG/1DAZMVgESWXvlNntO+xwfC27ygU83Uu8nBrVngr+v9Cqp/4k/JkVl5IhZynKvGnBGYES6HFtE2DSAlM+Fr+7kzDjqC9rolzid8inA80bKbGbbLmAAs5Xmtb87G2A0fBVbrJZ1/iG89nplPOhmAEjAAd+WxFjhku01/KJABZldJ23QmpAgFtpcYBWEekezdiiGsSn8VMuFGb
 sAqhmwjN
 euM5aXmPbQMigAKfQQvqpQYdE5eI+OzD5vOOTcz35Pga3Xgoxv9SSeC8uihcfnbix1kaqHrU4ke+FwkyBVJ8Lpg933ud9dTk+nN0lILVD0yB50qxn8pEOK5YBmxV52z1zviXXNNQdG4NlVMzMhgyACndkbVVSx/vOjfSjqgo2UbXa/PItR4TcKsSJ+kQ10FFbzRPPWrxuDml2SvB31TPMmjONzZrXmFrAKk22dIC33XB+oLd7fZGN66hcgv32D+L9KBahsTrXyznK9cZni05MdPj8D7ZV9aZTDBmnmyiyqBxJOSr3DM1QTape6MhFlvuYKJXhyz1xMjc0j8gCu5bZ3g5TdoUNl4QGdFE79BNYOFfW5sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No thanks.

Firstly, a change like this should be RFC, especially from somebody who has not
established trust in the community yet.

Secondly, this is more or less identical to a previously rejected patch ([0]) so
seems to be plagiarism since you don't reference that at all.

Thirdly, this is the 2nd time I've seen a submission copying that patch
unacknowledged (see my response to the last one at [1]).

I suspect actually that you're not plagiarising here but rather sending
unacknowledged LLM-generated code in violation of kernel guidelines ([2]) -
since the TODO must be a pretty obvious trigger for agents generating this
patch.

But regardless of which it is, this patch is not welcome.

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/20260227221555.29969-1-mcq@disroot.org/
[1]:https://lore.kernel.org/linux-mm/aljYxLusTzZkTfnH@lucifer/
[2]:https://docs.kernel.org/process/coding-assistants.html

Sorry but no - this is a subtle problem that requires expertise and a strong
argument in favour with data to back it not... this.

On Fri, Jul 24, 2026 at 01:43:05PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
>
> vmpressure_win -- the number of pages the reclaimer must scan before
> socket pressure is re-evaluated -- has been a fixed 512 pages (2 MB) since
> vmpressure was introduced.  The reclaimer scans more pages on a larger
> machine, so the window is reached far more often there and socket pressure
> is re-armed every handful of scanned pages.  The comment at the definition
> has asked for the window to scale with machine size "as we do for vmstat
> thresholds" for over a decade.
>
> Scale it the same way calculate_normal_threshold() does: logarithmically
> with memory (fls of memory in 128 MB units), computed once in a
> subsys_initcall once totalram_pages() is known.  A machine under 128 MB
> keeps the historical 512 pages; the window then grows by SWAP_CLUSTER_MAX
> * 16 per doubling of memory.
>
> Why this matters: the scanned/reclaimed ratio that drives socket pressure

"Why this matters"... oh I wonder where I've heard that kind of phrasing
before...

> is averaged over the window, and the window rate-limits the evaluation.
> With a fixed 2 MB window the evaluation runs the same number of times
> regardless of machine size, which is disproportionately many on a large
> machine.  Measured by cold-booting one VM at each size and running the
> same cgroup-bound reclaim workload (so the page count is identical across
> sizes):
>
>     config   scaled_win   pages scanned   512-win evals   scaled evals
>     4 GB     3072         11.9 M          23267           3877
>     8 GB     3584         11.9 M          23306           3329
>     16 GB    4096         11.9 M          23281           2910
>     32 GB    4608         11.9 M          23268           2585
>     64 GB    5120         11.9 M          23281           2328
>
> For the same reclaim work the fixed window evaluates ~23k times at every
> machine size; the scaled window evaluates fewer times the larger the
> machine -- a 6x reduction at 4 GB growing to 10x at 64 GB (and the
> logarithmic growth continues: ~11x projected at 128 GB).  Each evaluation
> takes the per-memcg sr_lock and may write the socket_pressure seqlock, so
> on larger machines with more memcgs under pressure this is real overhead
> the fixed window pays needlessly.
>
> The default stays 512 until the initcall runs, so early-boot reclaim is
> unchanged.
>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  include/linux/vmpressure.h |  2 +-
>  mm/vmpressure.c            | 20 +++++++++++++++++---
>  2 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
> index b4d13457bc2a..09111f5bdc88 100644
> --- a/include/linux/vmpressure.h
> +++ b/include/linux/vmpressure.h
> @@ -51,7 +51,7 @@ extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
>  extern struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr);
>
>  /* Shared with the v1 vmpressure block in mm/memcontrol-v1.c. */
> -extern const unsigned long vmpressure_win;
> +extern unsigned long vmpressure_win;
>  extern enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
>  						    unsigned long reclaimed);
>
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index 9629240d77ad..4c8671273c79 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -31,10 +31,24 @@
>   * As the vmscan reclaimer logic works with chunks which are multiple of
>   * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
>   *
> - * TODO: Make the window size depend on machine size, as we do for vmstat
> - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
> + * Scale the window with machine size, the way vmstat thresholds do: on a
> + * larger machine the reclaimer scans more pages, so a fixed window would
> + * re-evaluate pressure every handful of pages. The scaling is logarithmic
> + * (fls, like calculate_normal_threshold()), keeping the growth moderate.
> + * The default is the historical 512 pages; an early initcall applies the
> + * scaling once totalram_pages() is known.
>   */
> -const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
> +unsigned long vmpressure_win __read_mostly = SWAP_CLUSTER_MAX * 16;
> +
> +static int __init vmpressure_init_window(void)
> +{
> +	unsigned long mem128m;	/* machine memory in 128MB units */
> +
> +	mem128m = totalram_pages() >> (27 - PAGE_SHIFT);
> +	vmpressure_win = SWAP_CLUSTER_MAX * 16 * (1 + fls(mem128m));
> +	return 0;
> +}
> +subsys_initcall(vmpressure_init_window);
>
>  /*
>   * These thresholds are used when we account memory pressure through
> --
> 2.43.0
>

Cheers, Lorenzo

