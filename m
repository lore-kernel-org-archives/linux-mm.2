Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF3AC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978FE6B008A; Wed, 15 Jul 2026 13:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902A06B008C; Wed, 15 Jul 2026 13:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CE36B0092; Wed, 15 Jul 2026 13:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 442E06B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:39:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C271C4026E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:39:05 +0000 (UTC)
X-FDA: 84991721850.12.4FDD122
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id ECEF4C0002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:39:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+l4Gk5g;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784137144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIVkPfvxeJwmFsRzcsFULZGgDP6nk/t1TXi4jFC/9ps=;
	b=oumqjzCdunqZ0Rr7sqPzvahBLlMh02jzh2AboG60qraTxacGELNMvQUl9Y2zvMSrOb6H4l
	Oh+ztfK+JaqIJBILj7Mimdv/ZS5Dxn4rJ13IIX+f4y5fTB5H/DERWTsxRR2EARcQWO28FN
	CTaI806DzNvXX6Va6NtO/HfAesXQfwE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+l4Gk5g;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784137144;
	b=gcOtsKo9f9vqeMnF51J3KOqSH3Ik+8h3AJ0SPClvF75tWvcKwOExmlPadnflpS39Fr6fKt
	MJkkWaMEGwHiFQW0ihMB+erlBAkaOMMyaLLBfIA+r+9jJOQCCV8hf3EtOigl3brFqEdwX1
	lSiK1BDUFbOIwa9GNxwShR5pS2vANVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C73261878;
	Wed, 15 Jul 2026 17:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E342B1F000E9;
	Wed, 15 Jul 2026 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784137142;
	bh=FIVkPfvxeJwmFsRzcsFULZGgDP6nk/t1TXi4jFC/9ps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H+l4Gk5gMH0FmUaSgBbfUPPpEpu/cj1Doq8pMoy/Tdh/nysr2VPDoTBkxZqSlqjKf
	 Jmr36Iuk83frIZqFUemo0sFrNNDyrM9rQZV9vhmKsJ0j/swnTjVsf0mxRD/XbZD1Ux
	 QwVMKB+0NqfThWqItxcHlWnQLBH+bVu4njeC5WPpUpK7CCi0GEESuHNILJMIlF7IOW
	 2PxhotQ3zR1S+GjK3EUCMcRRWhyoithUpbnpXUpzyyoCcbEKbnnpjFOFAuyfprRnzd
	 j67UClRU4OTWC/PzZAkL0kxXCsSxET+OTjnmu9WYYlbAJ+0W8eAySESShGyplCR3T3
	 o6vl7tIqtmMhg==
Message-ID: <fb8d7fbb-1b4f-4fec-a087-8b1b9f55a167@kernel.org>
Date: Wed, 15 Jul 2026 19:38:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/33] mm/vma: add and use vma_[add/sub]_pgoff()
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>,
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-23-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-23-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j1c6umgco7a38jdqhi33m7udfkkmkyj9
X-Rspamd-Queue-Id: ECEF4C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784137143-693775
X-HE-Meta: U2FsdGVkX1/nXxXBHyOVkwxyaOZiBQlOZeJe18bjv98XBlraf0BPOFDSH6JI0SMbddKwZjd2tiYR5CZ5fRL2rVWn05WzMVuI6txq9dCIIeE98cvuX3BnRJDRhAFVOMDkrEtlmLPUAZM8W7forZnWbGPOpdpAWj1lYju5MR0sl3NW7chAOO7vE8hjgdmnI9DWDcMtePmKol44esib/97GqwfjUODpShQpQuLvEDxzDPzstgZww16962+VkRWC7pRhPpvy1GAZN9rsbLr8Yg5vss/v9eI9cQ9HxdAKm8TKFHf71yr5Q5ErTKGQzDBFGyvIZOMuA291948USaV319qOgcNX2i0/h+MN28L1QpeAWsrYmljbqtsaKj4WYcidhzWlhFvEJ0y7yuYLeIcR83+/2A4cp4W8jPyjctXIOR/mehwWdFiUmp7ac0wzz65wmHIqJOPXHLmRVGfSzbGHsYMOm/P55QvBfWn66euMxwObNfN/n710+bOZAl2sW7AghlLiQgqHs23Oyhm6Fw0G9vu442sS7XhE87J5c0kWFxq+2oNW5E1t/1DMOnrV4OAbExdWGEd97QOrpkuMxN8GX40e4EP3t5KD2ZF9rnIuUzavPZevBj0FxWeHX0WqRTJP7BzC765XGpXTkCmDRVa/YGBmgnaw+24LPZ5MOD0rp7XkxVjZUz/fyo5BUm1lJY2KcsWjQG3y5tcKseCdyBBIEiwhzuJvswh6vNkegaKOkZblZldokl0EhZRSPBO0u+KwfmUFn5SE2HCWbtwYAGjOwNSawyuK6e4abaPeyLzbAcGonUtFUyh7idpHhgS7FehxYigitadeYxmaXs3ETzTqxMVrwcmIwSsk1xSPEkIMyLYbdQTN2OuSJom5ZPm4OwCWDhN5OtCDJ1MdoyfePDIA12BgxwbZthKv7Cqjy9Xh80Y0CoLskqsVTzQu5+AMBjlMj7Ucph7W/+pSiYjwBHhbdlI
 6WwTgbiR
 MIZMIHwJsIRiR+OiXaperwiiwnYe0NKaC+35eTRnJYq1incc0JYd3ViVZFG6sWY7f8y0MObelu0Gcid/cO70G+pjMTjW3Jvlqef/Sr/JlfSEoFEke9N9g7Sazv2nytp6Gib3HWK2I9IYX4ZF79WoByxdD9WSn7dxmpNGUU3fNzR1GPbziBbDRlmXnPthAq93/xOv0O3k/3YlR9qEVBUBEBU7/7jol9++L/emIeh4m3E8e7Kts6EPDpBTHzFxLvte95pNC1m0UwyXJ8JvDLSFtF93CldpDBu8RaEau4gUOnrABxiudaBGiUPPeGW5BzsN5zpd1ZZye/c81byLQqxW7ztOH18RqvDiibGLTzVRiNE2fgA58vacqpAaTpH0qNst/svTL3wFTUpPj6ZWIuXTi3N3DPYnnUcS56cU2l0ZzsTO6WqO8nmjyUptd8Gw9P3PE3VdgyJk/6Y+e2hPZIMhoB+VCTyewqxls4TgOAF3g+ZI4tD0Jo4KvbiL2vXNLKOPFTTX6UL6LvHgj+qABvuGC1FEMLUTvQ0nNBaM4hD2CvzL486nvbmLWgOhwzMEOb4RgzuLd1ZwF2HhmtUskXC+zfKeQ7t2exBl3UZ2yQWwEFO6hZMEz0IOJvKMIUx0HIV/F5HsHcPHKOxSzcxRmfpyt/h/An58/TwIBw/F37ht06VVXMjbTm/tgvG20291HLf2LbznFir19zhWUjk7ITRSz/WDvMLSLAfDYRlxdQGt5K/RDTDcykLOHheLUSNhB9C0/PLcqjrCha2tg0mvHi/lsUhcthcGjkHiAYTqjLwViQWh6ib1f/M3VqoJQqaJXO2jKCT8pYiCsnUZkJbkl9sJzOTZJXRTSDjpW8yxf1p1digUaZI3q5S3e2asMAjJGNiMWdrf/NKj4mKccFkw65LCjWmLX1pplqnxAq6ElvrmFbUJa229HIMWsPd2NOLCPIKK//1twG46FJs582ZnopEy2AW2D5qlG
 IORyNx7h
 u/Xd43Vi7SpFpaaxNw47+tQjWoklEd5Yt0ZRFOUKVVaYd+VhBtKllqSc91Mq7cSKgNd0bW+4wpzfpYLcWR4aQIj4sA2H6dFkyPq1lYWHlHrYH5qHqxjEM0ePgGcxkw+p7izvLfdrX2Xi3nxHwfjtVYQfJ4eRT0PwwvKPsh26W0p+zL69DG2EIyAZU8Kt/4z5O0T8UhqYHsifCPK7E0dFd0E49KQH80nyKbru+LIIj66bYFFUMfK4vhPXGNo6rScpOVaUSyYBaOyFhhf/LaVNxwsqJ7Z5gk1orjwiFE925jq9BYaCI/8+Vd5NX+u+ff1y0BqRxvJOEEcmu7wDVNOsHlsqKn8G7baoEtCwX4OQ7kjYNbqv3aY8RsBQhKAEmSwXn0MYwSn73Nklz4k0Rtxm2nJ5CCCYdp3xRJ7N3CbAhW/9sDrkkKSCHSui9Cq3CBE8Ar6cXLmvOIO/piZCCjMKYS+0OoAVheqlckqgszzZXYSTMFMmluGnZxU992zWMrSfGNhVQ/ko16md/hQhGTprm3J8AiLn9t2PW1T/tOga+SWapj30CdhZSOh+lHXcxw8Nz/JmD0qdwSh9mUezF9sDXk9XBgy9UC9cO24pKrkTfuf/KBH8ZjE/M4D7VVYxi7Ah4cEvJtrltuYX3spLaO65RTZkJzlwDw9UwW4OA6tiCbsYrxJqW/VL7zpXC0nQcKR3RSiVULwYEUfyjsUdVBOs0jcJ3KTh6gS4qC2f8v9lsfP5HY4Cru3kn0ARTEJtHJUN3C2MmZLYYXe14hsY9lA4HGISCL8GDCBAFnfCjrZESnBL9t3UV+T5/1u14EOpKTGIy4dmxP2FOUyAH6Q8tor9Ka9imVVJpPqbU9SFzDDwgur9uwyUtZZ7IusF6sB+77Su05QJW9Sy9X7HwDlEsiPeZibaLYh+/36w7gTthd8+eCFPudTm7xwgrnJ2RXVXzdcIZwM9luASRaztvuXWHxfdZsS/b88d7
 NebX8qgA
 mNtKBYvwEs1vuqFQjubuxCYGdwEIcCH5oCkncaW/n5msHI3eQsS9RrYUvGFC3DfQqkw3Z3sNKPendU/2MbR4hIVBvFyL9asWBl1tUSWfMKudZ4fx/P37xUQaXj87G2jafnaHg3ifyeUmYhKdzRFNTjgDj03QqyCTlwlc3ildehksOlyZ9UOR84ZPIX62pYsFD2Pv+UH4SxYkf3fBwzXDRmc4PuxwcU/8txdPxGK655RbpEv2Tm6iXRPziToiS8Lv/LUesyem0I9Gmz86QD0MeVt6GmFJdJtfsZoxu0JExCSQkRaxTZs4i5uq85yOASYFvHyqdnWCGI5/QwIzUfEFpkGU1S4NydOlaJOFFTZgjXCumaQ/cYeyiQLJxvhc4IEzQL9H5SMS2m7a/+su6Ia9Ar9qGhGHYgnHuQ88PvLQ+6KK9Pwof8gMGMSTlFGsT+mqvsUgcszLkpjjKkjQ+nNze5Ua8JKn/LWJV/eMYoeFR4Bg5ngP4fNfNNhUmUxE9OZYNd0jnDi4wghmCrpLom1iJ6Buhe1NwPcU+qQHSDywzfMff+oBSSdWz0jYuWtYX0hPHWaUQLQ/okaNiEA9XFV+VuXvQ6dXc1SO8DxMISXqDv6p9vF//Gdef/ayGQWmJbLd8jOWVK4u892RnoqCrxIevxZ77O3jadgkC8+s5MfF8gcWOxS/kOrAjboOTbsJio1XLif4W9P17GAShQl493xxE1J5rIdQhEWV7GpQYmVCzqq/KAg714clwLtP0s3pknZXo3BgkRNto1gy2Mr2YoFDHtCvBFxk+uWsBzY+8ERonlxsaNIWQGTL0NP0Djl7wBOQcHB97DBE09WdoOliFArQNA2EXS/Nd+UOtkVZqgdlFos+HwVhlihJN3rQAhEI1A1fgO6QXbgI5HxfAoasZNyk90EK7KuEwe/4uqbYGg6GyGr1+ydaNDWry2mPjW51pevSJWuNP7mLr1b0T9h70TvW0+H0miJ3X
 syCS4tVr
 TspMj1HK+jpO2x16J8r+HdrRuYHBJxjudG66W2K9qElAQIHi1Cen+3VQwuouIX338SMiHKfJj5/Uddfbn8dmReSSDYmfRopRJSP1oBUZlqdgp6F0vG9fEENAFTnvFZqYJ+trKgt1iTTC1LzxzXivnS+ecSOb6eyaYNk28pI/1PzGictDANNZEvnha4Cuqi0EG6RY2aKyfEIxi+8L81dcfLhPb45gZz6jv03mfeFu0c+MT1iVO4JLkMGHzSjomYoJzn1Afsf7LXjUmCGhA+ZjfSbUn7zem/PQyMR8Mz4l5XBpDcQuw5vXbu9+vLoHyN+TD0irBfakwTgtzLR44rzqXZaffi6QxXCcT8SdhkW7gnnwo8gLDVcjr8e+Uh/yMw9MHuDSI05/lylc+w5dmt8pD3W3cxkSr/XWpLowjgbMIhdv35pbcXP0Xp+Y6kled+wsrehmTaLmSgviOI3TVWOKoRpN0lSD3DLh0gFceHOjE4utuIN/HG0iqvg5dGLbcXlLdIfugu6tQVdsLZL2VNXuuKbMjYoOp4D5wH1LewIJIDPigSf1Tm3eyL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:17, Lorenzo Stoakes wrote:
> Add helpers for adding or subtracting to a VMA's page offset, exposed
> internally for VMA users within mm in mm/vma.h.
> 
> This is to lay the foundations for tracking anonymous page offset for
> MAP_PRIVATE file-backed mappings, where adding and subtracting from this
> value must be reflected in both the file and anonymous offsets.
> 
> These are used on VMA split and downward stack expansion.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nits:

> ---
>  mm/nommu.c |  6 ++++--
>  mm/vma.c   |  6 +++---
>  mm/vma.h   | 12 ++++++++++++
>  3 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index c0a0869cd0d6..2a0136f6081d 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -41,6 +41,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
>  #include "internal.h"
> +#include "vma.h"
>  
>  unsigned long highest_memmap_pfn;
>  int heap_stack_gap = 0;
> @@ -1361,7 +1362,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		region->vm_top = region->vm_end = new->vm_end = addr;
>  	} else {
>  		region->vm_start = new->vm_start = addr;
> -		region->vm_pgoff = new->vm_pgoff += npages;

Ah that takes care of the other case of ugliness I noticed earlier, good.

> +		vma_add_pgoff(new, npages);
> +		region->vm_pgoff = vma_start_pgoff(new);
>  	}
>  
>  	vma_iter_config(vmi, new->vm_start, new->vm_end);
> @@ -1378,7 +1380,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	delete_nommu_region(vma->vm_region);
>  	if (new_below) {
>  		vma->vm_region->vm_start = vma->vm_start = addr;
> -		vma->vm_pgoff += npages;
> +		vma_add_pgoff(vma, npages);
>  		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
>  	} else {
>  		vma->vm_region->vm_end = vma->vm_end = addr;
> diff --git a/mm/vma.c b/mm/vma.c
> index 7aa0149f076c..bdd99ba56b4d 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -517,7 +517,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		new->vm_end = addr;
>  	} else {
>  		new->vm_start = addr;
> -		new->vm_pgoff += linear_page_delta(vma, addr);
> +		vma_add_pgoff(new, linear_page_delta(vma, addr));
>  	}
>  
>  	err = -ENOMEM;
> @@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  
>  	if (new_below) {
>  		vma->vm_start = addr;
> -		vma->vm_pgoff += (addr - new->vm_start) >> PAGE_SHIFT;
> +		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);

Hm isn't this also a case for using linear_page_delta(addr, new)?
(I guess in patch 21/33)
Would be like the hunk above.

>  	} else {
>  		vma->vm_end = addr;
>  	}
> @@ -3305,7 +3305,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
>  				vm_stat_account(mm, vma->vm_flags, grow);
>  				anon_rmap_tree_pre_update_vma(vma);
>  				vma->vm_start = address;
> -				vma->vm_pgoff -= grow;
> +				vma_sub_pgoff(vma, grow);
>  				/* Overwrite old entry in mtree. */
>  				vma_iter_store_overwrite(&vmi, vma);
>  				anon_rmap_tree_post_update_vma(vma);
> diff --git a/mm/vma.h b/mm/vma.h
> index 2342516ce00e..47fe35e5307e 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -247,6 +247,18 @@ static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
>  	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
>  }
>  
> +static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> +{
> +	vma_assert_can_modify(vma);
> +	vma->vm_pgoff += delta;
> +}
> +
> +static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
> +{
> +	vma_assert_can_modify(vma);
> +	vma->vm_pgoff -= delta;
> +}
> +
>  #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
>  	struct vma_merge_struct name = {				\
>  		.mm = mm_,						\
> 


