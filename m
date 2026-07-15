Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67ED9C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4073A6B008A; Wed, 15 Jul 2026 10:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8666B0099; Wed, 15 Jul 2026 10:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FC96B009B; Wed, 15 Jul 2026 10:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE5796B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:49:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 767D7A0194
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:49:48 +0000 (UTC)
X-FDA: 84991295256.25.59E0D5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8ECAC1C0003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:49:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fw52mmgr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784126986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87AXpHBd0iv4TTy368Q/Q/UJb9Kqr8Gw4rcYfu4tUzw=;
	b=zMkoYP8GPdADG344lcdurA90Z69UQDOnX4ea2f2v6u4ISAlwSujeLBDUa1NKtKSZTYBnS8
	11HPTUrJN8SDncwkB0xWQRW85lx5VAvWS+QI7HcHWm9AD6MNC3q95Ho8aH8GMrJf3imnpR
	4spR6hLOlBz3ocuJJJPK3ovtlLkZ9dw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fw52mmgr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784126986;
	b=AbPSk4C1KAopMoubsE1b5Tbqm7nuqY1LJCbPdG59l0g73S+wucgh6iOZumfAa83lLJpSRH
	ktlQtrRm9vUkmLYDmR73MjubZFW68GKgu/tyXwxchs+KQ2jom6cGWO5pXcSoU0+E4hw4iI
	h5xB3oi4NF1dw4ALzUjDA8W3WkWQaJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4CFD410A1;
	Wed, 15 Jul 2026 14:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476B91F00A3A;
	Wed, 15 Jul 2026 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784126985;
	bh=87AXpHBd0iv4TTy368Q/Q/UJb9Kqr8Gw4rcYfu4tUzw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fw52mmgrQV0ypMwmPeUbXHs2PV7Q6iuHdZpMDS0WtFeD3OitbvvZjBMj+irKiF3dp
	 PYtDAvEqTN9L/GMvzvNdEfg4kaq7c+zSVA4w5Q0v2iOKQbO1qbzodSHgDLF3CtV+A/
	 sb/1UdFFE6Oqw5YCsxuY1hfXCt5Ei6+8VX6QAudc4ZqUzq9PYAzTuw8s5gUeYv4x3d
	 1v4b29vy5ZzTucemN5P4Zr5HytjLIPdwvJafKlDNMuSWGladOxxqZAORBc9RPPQxhZ
	 vmKp2IpCyLTKLk+1u71RNWu0lCfJCDsa+6+N9R+aOZl5qYBs88adESru+K2p3t9DoR
	 0C9dzb1dLUfRQ==
Message-ID: <c398dd9d-dff8-4af7-8a25-7f10ece442c9@kernel.org>
Date: Wed, 15 Jul 2026 16:49:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/33] mm/vma: refactor vmg_adjust_set_range() for
 clarity
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
 <20260710-b4-pre-scalable-cow-v2-15-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-15-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8ECAC1C0003
X-Stat-Signature: g194387kmffpwd35wo4cdub8zp4skkmd
X-Rspam-User: 
X-HE-Tag: 1784126986-138414
X-HE-Meta: U2FsdGVkX19JA8OjSbOtgazIaVeLPI8/lzL9demT5cXkoORYs+HMPQAYB5WLSbWTAlSj35zIK7J9Do0ZsAlZQarBDrCEvgjztdBWWU8H9R+xb/GSvZayjZmtVm5CJ5UbXJk+TmvneVK806zQLE1CsFP5W2C7704+RX8tkxVN4FEa1AjCjayJH0h1Z6bBc+XT1+NUJM/tPPpozgu2P046bG5glhx6ecVYOrhuOa2m0W6k6GDT189SZDpQWK6Yyb4Yv2Y7gT4LTgMhOg4UqvVMzU8QGNgPHHIlA30KdzmCFcoEIWRrAHBqwXMaqEI7d44mVAaCt6ucg9XlqWiZuHa643x7KZhGD3yXD4Z8Ktjui2ZpnsE4juhlJeSeZnCjDz6dCfG1WBbS0ptR4s6bkZhXY4+Pc3hpskTLaX/iOUNrNyxLBQisaDzFsip6ZE2zWNx0IN1Wnd2IAdmuNFjWmGyIdsib82YHl9Aed4bEkulg6uofYSXcs5JYHsNAEV3ZwtlN4X/v5NoeFp5vUWysZzLim3Y2uxj6ikykpZ1giNgNAKGBjqpQbY02Y+pUv0uYAMpdHyN7rlmVi/RX7YBPHlo5vv5o42Vc8iLbOt0BqwbUDEjM1m+bEu5lr0SbjxONLLGDWjLf8/kJiQOoKY1Gyj38mKeg9DfkXJJuIcjY7VKEkjleUUbG8CsUgVS29lz4gQ5mZfRatR50RALGy5leW9yU9Pv3xoKSD1IyNT9sG1AUz4yRWPxSZOJgwhVkrAwHclvg6osidhQpdtWyAJKrSdmRtbu3dJwTMFCPG4+kGyUgRpZB1LmZsJrK7ZzZIhJB4q6VH/iLSfoNDnXFCMgmv2gCoLdyqsgTngn5MAzyF8Gt0obyZulAHkAKL/rgyrxJ9AXallabmFZ0CK2dzyNdWFCAAv2Yf1pprxvsA+cXc37t0eaoscmYpc/4aB1KmJiOw5RVbOlmSLssDCdpH2yIzHi
 Z7iN5csc
 FWL/Dz4tthNyNspZT8Q9tmB3sgK27iT3VIeDN+zXjK2Cw7RQsr6CdVac5hqy0K/Cx4xdnsjB4dNkq+s04Gbg6h+PQGvIwZgcxn1wEKsJBSfEyzFZY/9XR2jtU/gYC6U4RHyjAJLZ/d0br/T/IZrxDB22VyKfPXIWlfFawIf60Z1o+/BD3VlPmI0K2Omb+BDiqUwqE266s8ow0Uk0wPhpAD5vxdZ0ned4Nkuh4bndZKsT2OZlq7YJo701nusZS+RgcXq0tpiC1oZXoAZcnOCg1+ke7vdAW+T3V4E7fsSmY3VNIBEuJNwJIExwmhxdNdtLgI34SGuNWUcBG0WJ+NFnVJyI1R57jLBD7AXco/LrOHDvW2w6AhqGLa8Iq6875nfb3qhnelYUs8THbSL3MtJ3xG0k0OmHqbDBQSq0iDd6SUS4vnoynkIfD6pDnHcEcD0yBINaTmb7ecKvc7dAiLKy8oNURD59rNQJAy7mey9iuNnV4AAZLNQ9kZtrzPN5ddAhmjIxNErWhcAkPObcSDXTwz2WGTnbFG1wftGzf4oIrDnnWOV37c+1Y+0eOypEk+YjjaxdgwDh/gokyRzV8IHA92w7+IB8StPzciyfLTmH2PCIrSR100uw2+FjnYEVRPXBICzQGY1fdTi7WyDrIk7dHODsH+DWRw9DVZ3TRoUkPaCStz+KCSkts1l/ZEGwTTaymBwYz7BzBy2apQKqyxHr0qYy1M3NoPgEe/ued93soNL78J/qW1h8Ta2W1TUGQ0m6ciM4MVUAlVx8CNrWs0mK367YvFd4qcgg0jKG++l0PQc6DPGrSPI+PfDKjLJqHXViV3ImTiwoqv/qYYBuMmdNsbOYo2ZbJk0mr5E0v17Wbc3yEaT2B8Y1HydVNCvC/Y93STkZ75sJZHD2Lwe176Njzo9uSiD7UrSc+6rIQmd1gwXpY4DD8CAct2ZPH5VJhaBHGZbtI6dsNb5d+cpo9TkJcw+EESWBP
 lV4+9kbb
 pKpeT/FqXd0WozI4WOqML8I49bCWgMoyMYHhcy/DcHVrEq+5+DgbB2gKKnHIntMUROJ2oYdS0T6tZhfprsLAgRvPaAZvqNApa5C4ccVY0Syak+Ngkyxtj99aRDPkpSCQaG1e69RFDQCHLQPUO1l4fDYlOpQRBY4HnDdFwLRx6HebIs7tiFVVEa4K0izu8i/RuXAJ24eqC1dHCKJD0PezhQOdd1W2i7iOBzN749yOcjVrc+2zam1wIPgVfSviu0ykORGLWMmJH5fB2PjMnKQdG03rgHpax03/eqbnKKROtzhvfzKltczSLg8n4H1o2ylfOgLcBjnC5a4fR81RSQilfx2H9/LkIKqnPg3NncE+/8ZeVxZDS5KE6rmfEbEaKfVFRYXzLXV8v8dz9+QCdqN/WT4e+5r2VJATu/tqIbdCAm4TcIcN+oaNprCWAcz3pxOmToTRqYtokoQUtlyjPtNBXXRO66q+r14hvswPdcEnIY3YIHOxiAZSLL27ywB7oqLKbNkPYPQFuphGBPjRA2yAWFbJxuOkmNnPevc0mikQpBuRMchuHEfhU4FRkSqXeNTGgi8DXZ1ZQUaTlSxblcJN4sQpocOIOJcVP1YCwLO7qBT6CmGPlgE6HZTFpHBjO1A/SNc9NyfxZRjxOpnRYCgJpKYp1eMzjV43Lf6OF8uge+YLEVzlKBQdb/IZ3NnlOQ4Zfprrcw+Y5liTcBqW4zCdf+IzYbqFE3yDE9pO7uDOqAnIMl4FqO/mrgB28gPhD4zjE1hbcXXzJJYykNCVdbmgiWRhkLEF2ITW9o5ukwOhCTOGYQ6umReV6jEqZiiVr6pN86u4KPw4O+R+ADAZ/eLvGZdJmdlNWmIHQ9tQzqfkBhS8a4hzRbc51Tx+1tz8f/BwCBN8dO+tR5FMKfIcQqzTEkTNRkdDOuqg4+9yLN6fUfXbsSIgpwX+GzXqxzoUSMR1Zu9b0ByuR2Yh8kxvatf7ByZ59Gg47
 Huj4U+fN
 xa0XPF046zq5BN1mn2VKyi3dAeVOuGDfMJ9puk0c6I8VV9ov0faSdIOlatg1zVyqeuutIflYNim9vdFVskqoKLdgne8bJkQ8nL9wGAiCfMCpLaNnmuPHOI/V4tUr4s8eH8aJWrSH4S5bNcjggxNQCHCgndml8vf0z/mO2sBfEsiO8zKWMBlzEGilBWmotjun4NFq1qFVwgMB+0ik+gIYG8VJvoWtw8YLH8JheO5nj2vtO/FeNkEs+rD6YoHtqA8US5OOA4oDZ5P5XnjfLt7y4NI1w1+t3tU9zVTs+AqndA6tEahPXlEsQdfitcdSfKcIyaI3L+GW0GW3aFZydu0ir6Gm2+5zgKPh6YlEOqKeQr0j21gBNAQlrQypFDcgWOSAQCyc0kHg+m1S9z6TT7oC0Zi/po7x3uABTHvdjukfRAX0cO4phV8srymH9Q+945yeiRW8rhpqeasgoZ+jjB/dkUxm6HPUVX/NjmrMVJoAiyTjjH+rcaATNqq2NBsZNiujSJB0iWZPLUuSwFjQUKN241bGsNdZ+JVZ2HbgCT4HvSMt+r93vKmc28DZG5rdhfqJVg0MVPWn0DN8DkO8i/TchGJroQ3hai57hWrU1Zftgtky62/IBlxMe40gMThjMftW7Cv9JdJGV5TQP17Mc5plg/lEN3GC+9Y+csCbFL9Zjcy1yBqb2k2VBbLkMrlHmECIyyJxHxz34S1ZWu1OdLZ/4VqggxtXrfwQVNSB1h6XRT2DP3tNAE+SWxPDTfR3m2Yx4LLtzQfYpDni1JgHivA8IOZo3CWwn4N8psm3aF2Fe4EdB1Pu6X5qRVjbtDABw9GsB7/El+fNXv2pWCeIF0K3PwShPwpNYp8Ez/WDjG7Z21In3aLPlrACmQSb5pDDa0rxd6VkvNx5wMARfxdBEQf2aYnrr/TCulmU9+LGmrxE7ZM4STqIkKRIV3DYFm38kMc/qPwMkibKWhuDHKGm7RlqXF2uhL7FF
 NpYEHfO5
 Or57Goo5Ax4+wHnhFPdq1ol230AsYTjl5CQ+PZwuLh8vsDzLKSvA3K0/OXjVYrKqVp9t6G+DTlZnhQtl1z56tb/9Ii+j14kVSfrO8QrZJA6s/yu/3wezP2DRN92QKc/iQGitAYVYzy5XtOuaiaizCyCzCwBYvTCABfqgp3ZploQeoRQESan1jgivSsyT2jT7YCK1Lp0ZwNf/dTiD5rHcpOwNo0w0aoZp4z83pVfRT94qYHwmjpha0g5YqQdjSQL3OZtuLX68NmaTpTECeoRuJyJejoRcgtWtFFEjokLq5fACOPgcaoWVEdMOCX3Z2nJCN30r4D6QvxODizEcKE9ze/BvdW17PBWU8euxZYx9/QdDfL5wNYpxAvlrcGx8qBww1vK6pvk055nuuagjVvGNDic31797yW+qOxEyKdcY7B6P13+AWDGmJRr07lNXQTY+76E9sW1ypH28jcS2293/U69g4afDH5mwc0feF61B2HLpEmvrU1qe/CzZ/DZgOs2a972rTIE0ATohQwcAUSnZMtjj1zia7rWAGuWMQBWRxIpr8rkrZ18rPNKOhVLflY/FdPFLVry42QRL2caedANrzQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> Add comments with ASCII diagrams to describe what we're doing, avoid
> dubious use of PHYS_PFN(), and use vma_start_pgoff().
> 
> The most complicated scenario represented here is vmg->__adjust_next_start
> - when this is set, vmg->[start, end] actually indicate the range to be
> retained, so take special care to describe this accurately.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/vma.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 084afdf37385..7265a054cfa3 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -704,11 +704,54 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
>  	pgoff_t pgoff;
>  
>  	if (vmg->__adjust_middle_start) {
> -		adjust = vmg->middle;
> -		pgoff = adjust->vm_pgoff + PHYS_PFN(vmg->end - adjust->vm_start);
> +		/*
> +		 * vmg->start    vmg->end
> +		 * |             |
> +		 * v    merge    v
> +		 * <------------->
> +		 *         delta
> +		 *        <------>
> +		 * |------|----------------|
> +		 * | prev |    middle      |
> +		 * |------|----------------|
> +		 *        ^
> +		 *        |
> +		 *        middle->vm_start
> +		 */
> +		struct vm_area_struct *middle = vmg->middle;
> +		const unsigned long delta = vmg->end - middle->vm_start;
> +
> +		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
> +		adjust = middle;
>  	} else if (vmg->__adjust_next_start) {
> -		adjust = vmg->next;
> -		pgoff = adjust->vm_pgoff - PHYS_PFN(adjust->vm_start - vmg->end);
> +		/*
> +		 *                Originally:
> +		 *
> +		 *            vmg->start   vmg->end
> +		 *            |            |
> +		 *            v    merge   v
> +		 *            <------------>
> +		 *            .            .
> +		 * merge_existing_range() updates to:
> +		 *            .            .
> +		 * vmg->start vmg->end     .
> +		 * |          |            .
> +		 * v  retain  v            .
> +		 * <---------->            .
> +		 *             delta       .
> +		 *            <----->      .
> +		 * |----------------|------|
> +		 * |    middle      | next |
> +		 * |----------------|------|
> +		 *                  ^
> +		 *                  |
> +		 *                  next->vm_start
> +		 */
> +		struct vm_area_struct *next = vmg->next;
> +		const unsigned long delta = next->vm_start - vmg->end;
> +
> +		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
> +		adjust = next;
>  	} else {
>  		return;
>  	}
> 


