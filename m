Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B54C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 04:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33FCB6B007B; Fri,  7 Aug 2026 00:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9BD6B0092; Fri,  7 Aug 2026 00:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1916F6B0093; Fri,  7 Aug 2026 00:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA4526B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:08:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 255EC1402E1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:08:30 +0000 (UTC)
X-FDA: 85073141580.21.712E4F5
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57D14180006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:08:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=pass (policy=none) header.from=sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786075708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xNVHNRU3zZmqLbxlEOEgNCOJyzpaw+m5DJpZc5GrrLs=;
	b=YTnjfUujiMfVo91OupxtFijxTEAey9eJS+aqQNwDL3PPM5F+D49MZdfMz6r44VQV1/ySvO
	8SrBLW/MRxzIhfjGUOIU6IdlvSjqUKolSVK3Dm7PK460o5PcMRHqLjFMkC+uqCuav5ZMgd
	yHvU/HO+0NyKB0xMm6cV+b67aZyDd3M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786075708;
	b=UDqeqI/Nt0FIih+zQSCd4B6lIR3fv46ekeym98AgKRW9cHayxOb7bGyshH1tG4G3Y8xt4M
	FMipmtZudjHMcio6GFFN3NPaW3zdiXhtif/AjbMsFyFVJ0F/B/S/fsKzA85LqWb1nveAHh
	ilP8H0UTGyXC8wKJ8PFh9K1HwSmZYcM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=pass (policy=none) header.from=sk.com
X-AuditID: a67dfc5b-c2dff70000001609-9a-6a755a375cf8
From: Rakie Kim <rakie.kim@sk.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Fri,  7 Aug 2026 13:07:22 +0900
Message-ID: <20260807040726.1933-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260806143839.cf5226e6d5c8254098bf3d74@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsXC9ZZnka5FVGmWwaVbLBZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4MrondbEX7FOueHB4
	GnMD4xepLkZODgkBE4n9nQvYYOy3O9cwdzFycLAJKEkc2xsDEhYR0JVY9XwXM4jNLLCOVeL4
	WzcQW1ggSKJr+nNGEJtFQFXi34k1TCA2L9CYf8ufQo3UlFi38RYLiM0p4C1xf/kNsHohAR6J
	Vxv2M0LUC0qcnPmEBWK+vETz1tlAu7iAer+yS0w/8YMRYpCkxMEVN1gmMPLPQtIzC0nPAkam
	VYxCmXlluYmZOSZ6GZV5mRV6yfm5mxiBkbqs9k/0DsZPF4IPMQpwMCrx8DqUl2QJsSaWFVfm
	HmKU4GBWEuFlPViUJcSbklhZlVqUH19UmpNafIhRmoNFSZzX6Ft5ipBAemJJanZqakFqEUyW
	iYNTqoFx5hGHyMdi7zjeFCQazHjCP/Pfzkz9ay0Tj8SoLnT+oOJhM1mnTfnMmnfZTi+Knu76
	//FkrRLDNuGn5qfOBhe3fWy0Zctb9/Gr8XqbeDe3zP8Tk2V/nd18j71Ps0vjweJmU8/S+GVl
	XLJCs2ObZtlFGvz6EP+7SGbSLM+NMVdPP16dc655Ld8mJZbijERDLeai4kQAJluWp9ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsXCNUM9Rtc8qjTLYPNaU4s569ewWdx9fIHN
	YteNEItzU2azWZy42chmsfrmGkaL51t/MVr8vHuc3eL6rZWMFp+fvWa22P/0OYvFg6ZVTBbH
	t85jtzg89ySrxbpTh9gszs86xWJxedccNot7a/6zWrx57GbxrU/a4n6fg8XKH39YLQ5de85q
	cWT9diaLyZcWsFl0vLzPYnFrwjEmi9VrMix+b1vBZjH76D12BzmPnbPusnss2FTq0d12md1j
	8wotj8V7XjJ5bFrVyeax6dMkdo8TM36zeOx8aOnxYvNMRo/e5ndsHt9ue3gsfvGByWPq7HqP
	9Vuusnh83iQXIBDFZZOSmpNZllqkb5fAldE9qYu9YJ9yxYPD05gbGL9IdTFyckgImEi83bmG
	uYuRg4NNQEni2N4YkLCIgK7Eque7mEFsZoF1rBLH37qB2MICQRJd058zgtgsAqoS/06sYQKx
	eYHG/Fv+lA1ipKbEuo23WEBsTgFvifvLb4DVCwnwSLzasJ8Rol5Q4uTMJywQ8+UlmrfOZp7A
	yDMLSWoWktQCRqZVjCKZeWW5iZk5pnrF2RmVeZkVesn5uZsYgXG6rPbPxB2MXy67H2IU4GBU
	4uF1KC/JEmJNLCuuzD3EKMHBrCTCy3qwKEuINyWxsiq1KD++qDQntfgQozQHi5I4r1d4aoKQ
	QHpiSWp2ampBahFMlomDU6qBMVue+7JkwHSmTsE/ErqFBgkTpQ1smyo3mzJxmd+9ybP6XXWD
	Z8uk8BMZX6QWhD/pkxd1MNnL9ud1kLGKk8Lf++XsIrFP88wTXj5YX5bGofJn7/OKV9bny4VW
	9U/eX/h44ZGjfh8nvtJ0iivrq+c5spVlZtGryEnTyx4wqOqdsMiYpn/lt/ZbJZbijERDLeai
	4kQAwAxoas8CAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57D14180006
X-Stat-Signature: y9huqiew4pukdgabgym8gacfsjzh73cj
X-HE-Tag: 1786075706-897255
X-HE-Meta: U2FsdGVkX18jHcg8vnMzSE7PebQ+xkuVt7D7iEV82UlecqrTxo2KKFy1+4ldJRSE/vREqdKoAe7F3rwjrRcvGncLyRCTtQ4J4+pxv0dRMkcfGI++9HztKAz4RIq7Tx3mI5UrAYt3hvgMC856AtfmnwzcoH64ggUM3kixiGl/yj7XsgNob14t/3xvFnDPfpC6/SwNVbe63vGyvHadZj6YrO2b5nhO8KwdbQejcRZvKYOhdD6/E/ALvOjgrJAUXJ+vVy/R+h1w6g9gTsAMyubycbGojdi8B1JX/Tu8ZdLqX1krlk3wnHExpZv3hnLoLXkJZFJZjOnBvHOqdOcIRNffNeE8R6CIC3M1s4rUr3t0HXJYPnswVFGe+zP+qiSc0k0EksU/9D8eHVB6/csfjDuAcomjqKQj5s40GEDwQp3Kq6wIC59mxhYyYg7nNAYpyxZDgaT9huIhMT/JR5P59oNZrKw9YHdS/u8RPcttmCRFYuLnvmZyD/PfsnOu7Q6rpBQgpbgDvtq0Y9rf9i7zIys4WsLS2VQzKh4kMYqJoI761UZQJ0UUoVgpDcb8SXAK+7S5z8ma+PGDeBjnSVJagRXvYRxgIk747GNazOaIM0QjwcCNB5+fWIFOtYiSkrhKaYEtxR7t1Q/EUTj/VuSm9fOB/RNTgv1jDtXgQu4Yab7UFPb+ZqOrMDjzfkc2rdqGQuDlKjDKBvmlp+99O3gQx/y0kGNhmYWFAqIJJVXesrISazu6r3tdVDDNGooCgUaU8RgtmA0sg71O4zqcK0Vx5JhsAIV7GhGll3jfEv/nd1nMZO4Ci/WHoWBSGByRE2ivcccxbrzHlBEyNAmnc+zbHzVjOxssorjs3xb7LRFInh+HUoxs50ul6ZJ2jaYbZ7K/6FkGQAQvd+RUuf4QS9MHv6761pdAnPA/fvUwKDlIja5jSOGI2Iscj93S36pHc6YFqMEhxVhDKvCaX0nDkvCraOu
 lMc0Ud9H
 txpVbI+b/f3xllkXZ55CshTRDCss+L9ORS4tmZQKJ7zKp3jFd7yndYIHYnVtIJ2zegYI8/hde0sGDxrri9ZQdY4LubBknpcdYKn1lFdChT94dTk6QBafYTsV12qchhzMtoZyuQYnk3nN+Kn2diM33x3HtvmBqxWjVUOQ81M7ssaU4KO2iBnfhVy38zkhSZQXuZoKe1XJozIxDUw4PYxxlCyU16Mjt5gwp35GknRRvU0Re0bWshtWqVJSftg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Aug 2026 14:38:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu,  6 Aug 2026 17:09:31 +0900 Rakie Kim <rakie.kim@sk.com> wrote:
>

Hello Andrew,

Thank you for taking the time to review this series.

> > Package-aware weighted interleave places a task's weighted-interleave
> > pages on the NUMA nodes of its local package, so that interleave traffic
> > does not have to cross the interconnect to another package. This keeps
> > each node's weight aligned with the bandwidth the task actually gets
> > from it, so effective bandwidth holds up on a system that has more than
> > one package. (A package is a CPU socket together with the memory
> > attached to it.)
>
> "package" is not a familiar term in MM.  It would be helpful if the
> [0/N] were to carefully and fully define/describe the new term before
> using it 40 times!
>

You are right. I think my explanation was not sufficient. When I
prepared this series, I went back and forth between "socket" and
other candidate terms, and settled on "package" because modern
processors can contain multiple NUMA nodes and dies within a single
physical socket, so "socket" felt misleading. I did not explain this
reasoning in the cover letter. In the next version, I will define
the term at the top of the cover letter before it is used.

> > Measured results:
> >
> > System Configuration:
> > - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
> >
> > 1) Throughput (System Bandwidth)
> >    - DRAM Only: 966 GB/s
> >    - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
> >    - Package-Aware Weighted Interleave: 1329 GB/s (1.33 TB/s)
> >      (38% increase compared to DRAM Only,
> >       47% increase compared to Weighted Interleave)
> >
> > 2) Loaded Latency (Under High Bandwidth)
> >    - DRAM Only: 544 ns
> >    - Weighted Interleave: 545 ns
> >    - Package-Aware Weighted Interleave: 436 ns
> >      (20% reduction compared to both)
>
> Well that sounds nice.
>

Thank you.

> >  .../ABI/testing/sysfs-devices-system-package  |   35 +
> >  ...fs-kernel-mm-mempolicy-weighted-interleave |   17 +
> >  drivers/cxl/core/region.c                     |   54 +
> >  drivers/cxl/cxl.h                             |    1 +
> >  drivers/dax/kmem.c                            |    3 +
> >  include/linux/memory-tiers.h                  |  113 ++
> >  include/linux/numa.h                          |   11 +
> >  mm/memory-tiers.c                             | 1009 +++++++++++++++++
> >  mm/mempolicy.c                                |  200 +++-
>
> Are some user-facing Documentation/ updates appropriate?
>
> The Documentation/ABI things are rather dry and information-free.  How
> about some documentation for the operator who is wondering "should I
> use this and if so why and how"?
>

I agree with your point. The current ABI entries only describe the
sysfs files themselves. In the next version, I will strengthen the
documentation content so that it answers exactly those questions for
an operator: whether this feature fits their system, why it helps,
and how to enable and verify it.

>
> The runtime sysfs on/off tunable is interesting.  I hear from google
> operations people that every new feature should have such an "off"
> switch so that if development send them a new thing and they think it's
> problematic, they can disable it in order to quickly get back to the
> old regime.  Perhaps that was your motivation, perhaps not.  Can you
> please describe?
>

You are right that this was one of the purposes. The switch was
provided with two goals in mind. First, as you describe, it is an
"off" switch for the new feature: if it behaves unexpectedly in
production, the operator can disable it at runtime and immediately
return to the old behavior, without a reboot. Second, it is for
users who want to keep using the existing weighted interleave as it
is: the feature is off by default, and nothing changes for them
unless they explicitly turn it on. I will describe this motivation
in the documentation as well.

>
> I see you've been emailed the Sashiko report, which appears substantial.
> 	https://sashiko.dev/#/patchset/20260806080936.421-1-rakie.kim@sk.com
>

Yes, I have received the report, and it seems to provide a lot of
good information. I am reviewing each finding against the code, and
I plan to reflect it in the next version as much as possible.

Thanks again for your time and review.

Rakie Kim

