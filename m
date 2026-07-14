Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFFFC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1592E6B0005; Tue, 14 Jul 2026 06:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3916B0088; Tue, 14 Jul 2026 06:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8786B0093; Tue, 14 Jul 2026 06:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A676D6B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:17:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 087934035D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:17:50 +0000 (UTC)
X-FDA: 84986981100.25.FDB5B09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F68640005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:17:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fy6x3ScG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784024268;
	b=v/N/7VrHnNBJWF+0zJSqeh6fP6XTBCxq8LhboOmv0Kq0/fcRympLAtILrGLzq7mHoR1N7J
	gKqyAKUD1G0/2HqeHTXr+eeFVA585hn/skgQgjQixvKvQ5zAI16n4szY3hm21L9rGsa074
	igd4DjzzdCTT6+6mkO7Oa6lpFkJ6lqE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fy6x3ScG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784024268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1KwIxFOjH59vMqkPqvNJy2V0MLfN207LfncRH5TxDo=;
	b=4Zskr6ES4QG1y19HSW2gKDgKptNpTbs0RwG3M+2ht7wipN8fzcIRyZQoooA0Umzr1MGY8S
	N3KZMugyhcJr8hmdQXm+x/+IUjyYl0em2BZo2ng6PiagxUa/fzB1hK3vEcyf+GystJy/8+
	WvHrB1S1ktIjsT5CGpPlEEG01ZklGFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FD2A41843;
	Tue, 14 Jul 2026 10:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4FE1F00A3A;
	Tue, 14 Jul 2026 10:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784024267;
	bh=m1KwIxFOjH59vMqkPqvNJy2V0MLfN207LfncRH5TxDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Fy6x3ScGp4SvjcLCb2EYasEF7Bg+N3JfXA1S2rYhDdGa8fr4+6eT9Z5sUIb80sT2r
	 12V6KN+91XeSPeyZyRfBCNnMtsE0Z3zX1AfM0d9+BaPvnE/m8+pkUwQTaWwez7DEAX
	 40QuoDzKqfzY1GCwuoG58CjBJE29XwBLRxM4TLNdmwQj8Blhck0AkxR92okiojzvMx
	 WvMiVcF3zrA3KFpoksv9rfWx4gssKNluZWhtd5duC3QeTgeKUloBSHGktJzF0RJITM
	 VrXH2ihLGQi0Xivwew6+5RuBX85r1ZYghiUkt5mTAu6e5JRNfb657XTWVfzpRGcHfX
	 762G6nWtq/nvw==
Date: Tue, 14 Jul 2026 11:17:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	SJ Park <sj@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>, 
	Kees Cook <kees@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	Christian Gmeiner <christian.gmeiner@gmail.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>, 
	Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
	Marijn Suijten <marijn.suijten@somainline.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, iommu@lists.linux.dev, 
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 13/33] mm/vma: introduce and use vmg_pages(),
 vmg_[start, end]_pgoff()
Message-ID: <alYMZkJKJABhPsa6@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-13-2a5aa403d977@kernel.org>
 <508301c5-5460-40e8-bc34-6410be5be40a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508301c5-5460-40e8-bc34-6410be5be40a@kernel.org>
X-Rspamd-Queue-Id: 3F68640005
X-Rspam-User: 
X-Stat-Signature: gmyzeiprgry3yh9dpdb5ich8z61fn165
X-Rspamd-Server: rspam03
X-HE-Tag: 1784024268-60052
X-HE-Meta: U2FsdGVkX1+VBAAxIvwWf7E7mzIegGsvfSySMsvtCaiAxHtl2ru2cu5di3Pev0IWDUrh0LxNlAZBcjUsXP9PGXa04nGNyRwZR1z8vFsdQ5lnP7ov+iaQfs6Rhxvb26mPX83hIIeS0R3e08ik6CVOkU0YYDYgcJoQ6pNZhTXkcSgaEAfJ14L0TD/PNgjitDInhjCs3zeSxCITx7QzTwPTymupjWk4yyH3jGpOoa89ALZbA9tRAFAhrslWg2OY81qnzHqRMsf8wYvkcHX8nd8/JFvz0STNXfu0owD4nMHgIk777sHiZMGC72qxAkfUGNU9xhHrQb3dBBAh2K0yD5xJjeIO1fHqbQtY6nto4oNnKSy4B63kwhQJ3HRI8Gg4SrRkBppUokZaxAgVdBqXaE+XXrx7RMoeGRi9wpWS32RvQwL14ozFQzrAng0mh47iipP4Ou6kyBjU83xcF461q8obCjX0tB9bw2iA26qODk/1Bds1IvCt3ZIDvzQ+qHA6qsXiM4JMSci1sbzvRgTJYuiyiVdmGdBKPNLyhBISyvCQKDYzKi2ncItcys2TnTSfXOPf6/w3tE/utcsqEQL7E9t7hr/LeifJUv9OEJvvSnjrMfYRpTET/zECwS0bStBHOPKQl5DJFiAjEdFSonEWr2XP7x8cGwCRmrQ2VaEIYjaSzWidiRWl52tGl8Zc9eOKJLHFJhlg/HDQgEP7SpV2ifn3FD/Qf+szTLQFtLU3/sjjPaBMIiXhIEOEpsMOEoY30d46t7Nuc3jakPTIYxjtGlaE/Hd+FDJAGcnKbWJgaLsUjCShlkF7a5rSJfNm44n/B8kovvysJmyCNzIsRT6WBadCps0cDuNrP6kHNCnsFmGM4sb3x5egrbkKCcJm/ojDjJvrBpIWGeYXlVN0hRNOUrqxM/v9/g24enifESGuy94gGGXacv/DIsOVt/3t3sHWKyOhJdk5ArrhdrVuCt2BSEW
 znabE/Al
 xfVsqYaRUsBfCzvWbQ3DRQ3gb0Foa0i4wnyRxv79v/fwsimbXVB/XCCGpQozTg0ab6y7+mjpaKRTD4+1vHtDHkbn8eyKeZrf2qP0tT2mNGhLFYtWV6jGMOJdrTzvH3cT5k2c+IpyYlFBVQ8gxGlExkV8ft7cHtZCn/tY+YIP4cII/K2A7/lFskQ0JBe9Hk6T+NgVzK4IeIVtl8lpzZpi+TKrHeZr8iUWq+ikP3p0F0+wrA9jjQXlBVnYsa01kH8cCW6HkPpYGSARaJoAuqtQ5fz6uLougsUDy6mY9QnKpZ5DlryEWZ0C+Fg6ETHihZwoqBubMSZyaj9z3Ag4/ttT8A9T34na55+gdrOyVqfYNGKEDWRj8QzC5Upzm1wZwiHHYXCwVHkpPYYJCARqZSfNZif++iMwWfv8IyZLoTVTELFkzjWqiCglEg/NADaw2Vyh/DlD5KBtR392PoRdSob51+OjZ59VsQx1yuqPUm+4b/ib5mZZjtVdy1ZpIS+FDwv9nZ72nzLZaQg/v+4DVbWI0kRQlDiblx5+vU+wp0v7kKniVEawA5+jp/y4qgrFFZTe19ES0dVuY/o3JdbOHT3pr1NYCe4SG4K5X+54v90d+TJ1vKt7xzKrASjObMVamsSgkztNBHteFZi+jSVPrOeVYkH8nOoe8tMnW3553u/e2zpBrNRLKfsq1OzRIzhuhpmqMZIPBM88BGjN6JvFi1hNnEmxUXD865wCB/KXnKlxCr2eLSNOyP0dOkeQASjB4aeR3fi6X0jkq38aow3Gd78zDbxEIvEmGmrVesf0IL61iX8Y7bVxS+YusFuAJzlNuApl50+CYGI2naB8UtYSYWDGyK+ye2E2Pc6AlFzvNyikmc9aUB+W7AOJiVlLYV88hfJ++iYyxDIH1VPwO7ZDJuFkg3HhNs2Cd1U378jJ1aCSZw1U1mHf/WlDQUW+2Bmx7IYlsNg6bTSq98LJy7+tmqfJFnaqvxNXJ
 KLGYLRDp
 Z0XenydlFG92Po4iZKYlNo4hgYc6XPTJRXoieiB9mWJJMXsn/k3U6iL7qN859TXtp6suCz/sgWNfuh8TrQXf8J4vN+8+7Xto2yNF2kdPh5j5DuCmBoTtXCvRQ98/zicqEfJ6iZfAl/wjPEWLLSRzKWqJFozYBartjvwVq3vHzVb56QgfN/aJlRqWEuRSeKjjzVfxCNFdqCqTrWH7oKGhaPXveNkdPfaF9wk96nxxFXWy/djZb6MRBgFSQlUv7aiul2LoWZ7Va2QXQjW/lOtVioqQnvY/OaLwMfB/KR1FuZBJ7sUju6L6qkBDLMhQndobL+aGHE16QlxuI+E0m3wjKK/By8Cq+72kCzyJ6CFelZSqfLrvDZwsHxXgdBvVeB344ebeYS4B2kCFFoawgWQ5MEesnDMIHTm2H2PBzok4wuqixjgTzUParFtF2Bsh4nKuSuLls4ef/n0doOXDDsB1Sc+8JNIX5w32Z8PeMjAbkVjy8Y3nlejzRWbUyGR0F3x2xlGFDC2/1g16Ff3ECn7xWcFiAd3ClP25fe/2e35Vqpp7MbjdPqfAP4RSjFQCPz+yJtOO5yglkmWt7QHmJfPgdGlGvIPOl4GmJ5igWr06Pmy81gjMUSH5AGFWjf0LY4NIHPpNkuvjfsXPZ7Mno3TS+xDKwMXekeYpqMnJ8QbKE6lPlXRRv/Om8A8/TCPkbkT9khXojVzzPsvF/dGhDw5+wAoYyPQrXlxRAhknuLVaBLr0QctYS7qzO6nncTr1colnd0kBBty78s1/Jg9SY6TXR1HXaQRLEChDY07NceTxALP9a4oqaHksrYmNPuDuKD9UYPGz5UFfvG9emfAa8rE39gpFfXEiYymZwOf0FJhRumZuPGjZJ3enEJTVn3yyVjVv304td1uVp0rt4wiammgE54TCA2MJSnjkxM4Fz4GWnG4GIAFwJ7Pr5EQU0dwnKNwu4oR+8ml988H6T1z0Bx5GXLAhYpqZL
 uPoqr6Ef
 d5ZnmG8Cp/xVL81Sv55mlLKSturVVXlyqZpidtp+FOpvwYIoBJiv8GvM5PR9tSHFpGah2xT58R0MopgAgysxdKvoXJwCzsYloRfYnPVLszKQEbp2MRerXGBAnW/DDgaPryvQspzFAIH3J9gFTmZ7Ae8qRTh7Xqy5WZXZYlrgYLSeXDu44/mQypQ1FX1Vr1wCkOK21BOZ9tO61p5Ymmq2g9NYtaFwEy57ex0/kM6eKUL5fIzB8x5assrS8wYGifl0Ns2cW0rk/H+kZwUewhJIN58tignJJS+Xlo7kzsMwNH77JMHqbbCm4ug6R3YArb1w5SgyxCDpFckRnkC21i6FUM+NtK+fR1Fnwr286zyBymhvEAfakgFpGL9xmiosF3dN2sJKrhYmrE1mF5uksQTob56dyRRsW3u16U2s90Mj5nvYfY1TbYN27rqk5/t6kUMLnVxshXMnlf/ialym++a1sJK3rRiiXUHPwwLodjUv9AZGj9qijkEvSCnyBl4z8bpxFqdSPp0xUT1357qk/d7Bt6w8+dhpDDZxxXcVm3a+7r5rdflpIIorCCSNdyp1siRBzhvDr73I3gL9P3SQAQAU6nxVKJEtliMfhTXQmMsIV7f2+rKtLZFzkANHGYbCT6BIwtjIp0n/3oMQhpWKcI3hYpwqC10LcyObQzlORvhLRf9CIqPBBKZgfe09vPkTUCg+ZTGBTylBTo3X7s0M0X/WdlskFWHl/l6R1e5b0ObPglRywgdyWSX1juwIWLC12+0yf6I8A7uE3OnDrCJs6YXKnKbpstyjSw2wdSDRlwrwhtZLhpaU/2d/Fv/HN5jFUxVzAh4kPjeLWa8EPjrRZ6j84ODw5KF9RK/sPPxJoiZ7j2zVyent9PMSBdsSUB1WLOT7lvlHxq6JXHa+vfqVJ9cPnfFWrfmpB6toqC5MFEmvz1FH9NCzGct33oKQ8cnO5XqK6LzL8B0fHt13S81qwZjoyk6Xuq7MP
 oNC2MGjz
 Vhr9O8+t3gZF/ijrLduku30Wxn/afHGjcBZ6z2PVQt4AqNCScycpB852NRUhh35fWhIW+ZxVqZbNhN87ZGPQug/wr37181Pjz5+Ld1JECyJzeZP8cic4Ub6XyhGKF6QUuVkP0OnQR/Y0j/LJ5C+vWTgNLXdp1ofz5gH1HTIdnHz6tc7BGkJUQlh9j/lAB7hWLn4FGn6xBU8Nme7SiuZbrUhrKlu8ZG7PFVaaCfp4bvgxFYXV5F4or6ZqMr92mfhIkGGQ9m12e0ZLBx6vLOU9NlvlG+V1WT4P/xAH5SndDSl/sChUnncZqLsvrBk7EuRePmsJuePPcJjYsGzYrIktWoR3d1gLAcAEPkYwNeiQ3yJf7Cm1pgnw0hTLPac9KkzVasgDstMh8cyISvJTMcz9OeqDx2FD8O96r3Wk0QqRxcXr5wZHKSZKxJJ3aqKrA27mlZ2w8SKKbFNoCR1bbKidlXsPeSDa0cuYGVayQYvRRAE5l7Ekx4aWIldQB5v5fV/d3230GwJjFv60kZDWssPvq+uOzbdbhH+t2XtMkAL7xE1YulA8h1w+hlpY2D/PPe+JHPyVTBI6Gn0vMaSEoOkmlD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 08:12:24PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/10/26 22:16, Lorenzo Stoakes wrote:
> > In the VMA logic we often need to determine the number of pages in the
> > specified merge range, as well as the start and end page offsets of that
> > range.
> >
> > Introduce and use helpers for these purposes.
> >
> > No functional change intended.
> >
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > Reviewed-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> Uh, the PHYS_PFN() usage here was quite an abuse. Good riddance.

Yeah and mine :)) but absolutely agree it was wrong and glad to fix my own
mistake in using that ;)

> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

>
> > ---
> >  mm/vma.c | 11 ++++-------
> >  mm/vma.h | 17 +++++++++++++++++
> >  2 files changed, 21 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 35ba3475128f..995de8198fbb 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -197,11 +197,9 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
> >   */
> >  static bool can_vma_merge_before(struct vma_merge_struct *vmg)
> >  {
> > -	pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
> > -
> >  	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
> >  	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
> > -		if (vmg->next->vm_pgoff == vmg->pgoff + pglen)
> > +		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
> >  			return true;
> >  	}
> >
> > @@ -221,7 +219,7 @@ static bool can_vma_merge_after(struct vma_merge_struct *vmg)
> >  {
> >  	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
> >  	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
> > -		if (vmg->prev->vm_pgoff + vma_pages(vmg->prev) == vmg->pgoff)
> > +		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
> >  			return true;
> >  	}
> >  	return false;
> > @@ -759,7 +757,7 @@ static int commit_merge(struct vma_merge_struct *vmg)
> >  	 */
> >  	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
> >  			      vmg->__adjust_middle_start ? vmg->middle : NULL);
> > -	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
> > +	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg));
> >  	vmg_adjust_set_range(vmg);
> >  	vma_iter_store_overwrite(vmg->vmi, vmg->target);
> >
> > @@ -962,8 +960,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
> >  		 *    middle     next
> >  		 * shrink/delete extend
> >  		 */
> > -
> > -		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
> > +		const pgoff_t pglen = vmg_pages(vmg);
> >
> >  		VM_WARN_ON_VMG(!merge_right, vmg);
> >  		/* If we are offset into a VMA, then prev must be middle. */
> > diff --git a/mm/vma.h b/mm/vma.h
> > index 8e4b61a7304c..527716c8739d 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -230,6 +230,23 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
> >  	return vmg->state == VMA_MERGE_ERROR_NOMEM;
> >  }
> >
> > +static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
> > +{
> > +	return vmg->pgoff;
> > +}
> > +
> > +static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
> > +{
> > +	const unsigned long size = vmg->end - vmg->start;
> > +
> > +	return size >> PAGE_SHIFT;
> > +}
> > +
> > +static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
> > +{
> > +	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
> > +}
> > +
> >  /* Assumes addr >= vma->vm_start. */
> >  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
> >  				       unsigned long addr)
> >
>

Cheers, Lorenzo

