Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 943F8C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5674C6B0092; Fri, 10 Jul 2026 14:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5175E6B0093; Fri, 10 Jul 2026 14:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7FD6B0095; Fri, 10 Jul 2026 14:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 071E06B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:57:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 850CA120557
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:57:29 +0000 (UTC)
X-FDA: 84973775418.07.AF36706
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id B208D20005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:57:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HW9Wg6rV;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783709847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUriDsQ9XZtRyYKZZfoXUueFFJuZPgSg6lCZHNic6sM=;
	b=0WZbikZqhw9a7CoqXI6Csc+GI2iy1W3wQaIvaF5apSCalnEUBSwnAXvm6qv1F4ZKBXD4CP
	dOKGEjTvXfFB04mIAkLNJUb5W6RgTo2tImLLGCAqDyo6FmYrC1gOS106aA6OrmPRxUWVJV
	3agyR+dgF9WghkY6E0k0UNgehiEk0S4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HW9Wg6rV;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783709847;
	b=G1/D791eS7JDnxKsX9r77aSi0uvu9+dlCZQmDwCsXs+H+RwTzqij45WNqkQ91pbzDuI5Wr
	psYnvXffWfkKZkq+pTJ6ISeKQlBha3YWtd1q24X+c5cNKdwTESi+fwuaqCRIAFtOqnMIFJ
	UCam/gDuFWpDldOo0ig8yFyqw8QaRQY=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e5b048375so61563785a.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783709847; x=1784314647; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kUriDsQ9XZtRyYKZZfoXUueFFJuZPgSg6lCZHNic6sM=;
        b=HW9Wg6rV7EGt2xCkmK4STTb11Y/UhMNXMW+8DhiHzkW3ULVqpM4ksj2pCNFUWbuBGY
         WKGH1EpbMNv0RlteTC21z8CpLRll3S5MzDivxHhbCkK+vI5oFJzWP+Sdlx0yk/mKfSGj
         GM94ALK6Xrk4bdWTrE2IYcchi/wUI96XZNKkQ/0tCm3IeHIdgDOJYtECdnMgo12W4LPg
         6R4IJ1t5w1UYLHWfecrtc5en4Cs6Nz2z1e6gkr+RMrh+kKxPa7kf7hklUVIhY+Mh/jOw
         b2p8il++4S8wzQ1dC7tEHLRZMGNrlvWBr0WjuZiHOQoDXekTyszQleIvmaGPrZuJ8tks
         jk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783709847; x=1784314647;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kUriDsQ9XZtRyYKZZfoXUueFFJuZPgSg6lCZHNic6sM=;
        b=Pk4ghwlmo2HqfXLj6cyeEJLD5sDJqALi6VBIVwMZk9Ls927mq5VEH8SXIhw2i6Nzwl
         +widCcvTRi32ihM371Nyjk49NeaCtLSxx7em2IWD6CUoYLrxVXPd5EuFz1YxtCuzoqYg
         IMPuPMDeB3SEJSpfoGi8X8uyXptAlzy+x5LHAAWg2ZSfAr48NTamk0awp9oiZ8XPJ0bF
         /YiFj3TwDvbNfcAqqnDQHrS4Qt4kBcYFzYZgb6LxiADgId2W8vggWCHicbdtUpXuLUHi
         MQ7z0lYJE+nordg7d2WMgNZxm161DpBQMGN7JvNV54An7oN+2irq77wPDdCwGx6f9lZW
         8WTQ==
X-Forwarded-Encrypted: i=1; AHgh+RqF54P5aKLuxu2CxDiHViAVBW0Q09ElFvgp9G31Im0pg3UeuLKA6qfbKJ65IfnjODpFDvG9IrBgIg==@kvack.org
X-Gm-Message-State: AOJu0YzPnH7vUpbeY518Jub3s/PNYXO8DZ9brBwS0kcCn81DVIPkGYSF
	v9NVxfZWfQhDY4qkg2pyAT3EozNjjPfLZHtUAc9NyIhjH5JNBLjRw6ZGoieWNerYwdA=
X-Gm-Gg: AfdE7cn5LRl1Bscm47iQ+7cDULvduUrXohpGMA4p11Y1ccCAamT6zg/X7gjVQjloPQ6
	DzyOUY2cN+vqEnI6k+Hp8lzr/XYC9JoHFLPS0XEjDcLEDXmy8gDhCLdt3E58qs6rN68/3ITmLYY
	ccfD/FpRR1dPOZccQOdT2t4dSJ+UgmOKBE92vj45O3OKkG1p1fezfAZbjOMm9W5FGB7x4gODanR
	iWfLaQ4DRW6A4sXFR0DMrw6DUHg6f98phPPpGWmXDpiX2TA6CulXSkFuM2WL5HmLG9c5ZUA+Ilj
	ODoTvTNxuMUWTok9QR/P2sAeyydOxST0P9dfBsK419Uc2t2foAbyEMrTuq73xeK9XLtlHYNzAEV
	ZzmabcgGSjY+rF0wEP1bXzjVYS007myCEZsZvAwJL74PiJb5cTwBipU5SXwHzOQoAFR47VZNVkC
	TvFi85HGqN5ruGA8j0EYKy4CapuTaPyDxsqfpIC1uEaWAzTDYoWSefCuBBarkE/xzzDm1j
X-Received: by 2002:a05:620a:d8e:b0:92e:9d63:a6f2 with SMTP id af79cd13be357-92ef2c1ab7bmr45629785a.70.1783709846741;
        Fri, 10 Jul 2026 11:57:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cfdf6fsm275995385a.24.2026.07.10.11.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:57:26 -0700 (PDT)
Date: Fri, 10 Jul 2026 14:57:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 23/30] mm/vma: make vma_set_range() static, drop
 insert_vm_struct() decl
Message-ID: <alFAkWCnkYv--Us0@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <62efd70f9f39570724c9552cc7f2aeb5c322b2ff.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62efd70f9f39570724c9552cc7f2aeb5c322b2ff.1782735110.git.ljs@kernel.org>
X-Stat-Signature: u85trqx8r9t3g5qw94eng4u1i9dhn31w
X-Rspamd-Queue-Id: B208D20005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783709847-818987
X-HE-Meta: U2FsdGVkX1+mkHr+K9xvych/CCJ0YV1su9CLFVgviKAz3i2wqPUU2ZZXqrA53p9pYqEsZ11dNL2LnCmndOVwrv2zy9ffe1dC1fVZCJAszlDXsipkZIA9m+XDAKybdoDnISVmVjCGll/aMuW/CHnS32YNREpYz2E2ZqCOIhZyxxMUy7WYcdYZDE5LtqFXjQuRf0/ezXC1k7pDWKVLV3dYREAbZomfcNNqM1tDz6ogyWMcWDZqIfrxtHR5q41MgCN3g67pd1UYOBquGqUwE35dauWRsCZ0hCFVRnUOueMH3HrkYq/s0vAhOvf/lUyceM1i5FezEqLS9a2gxs0fvxib3+P8KjMsdGIGJBBh07+DFBvUijLjp/5u6WK3aVIfPx4ZLhBIgTXa6wEC3tc4Fsw56tAlcq6DdWWBqiTmSP2tXJzwwfKnRY+qCjHA7tjQYQ3saVdWgkkQG9d4qLksItzBxqZCMqkiJD/yaTxZuoPSN5omhrlWDvtjW22BIpzdioEfwZonSnMKDM5rJh0rQy32uMAh+H2nQUpObmB8Juog/DyGZ+Mn78ckVm3RCDMRXNll6GiNnB38V/CmPPQ8yR9EDJQmyGTEi9SF9L36wqHgwt6uuawWPquGlMVtNeJSMQMprTh17yRns5OYQXOu9l4HN0VJCyYLs1MhYhJJtaQflHT28kvVkhL9mRSCJZ1s2Syc+KyL+25DvyhlMAjeRAy1BmQyY88sEvkEf8VPkXjz4oY3mqjaoSP5C4gsQpxDC6aFKd48rzwUdsIGspiuclx54JrMk6J1Kf2boc+wWtjeJVeVZQZytodBWyKXQFJRffqnODdDTvpTkO49XmrArW/p9NoRVWICT/GEw05Y5yFUXmAAIQAoMrWsBM89v4CtSLJa3N9jvsNBidnU42VjZxQf0qagxq5ssVH5gRa+zzaX3BUiNtB+hjy4S94Bfg5XBJ8zvW+w7jtSWoI+EGa/0Uf
 izHhUghn
 IAL9mIBe4gm9kK8o2NTqEUZW24U9D0J4cuowYgn5HJRCm60/9IwNR4BJG536Ib9QFaXrhiG8ZSpP5q/zqSScKKIt476WAW5tEUV2RllVmkF/Jw6y0FK/ao1kkky3OFwjAp1GCJK3THjvVclHjwE7ug3VYKv76SGJCSqfFTt+bBoQaqIwJVBno0NppK3K2rIY27BK2GDQh+5Xc4BNr7DpBhla8DsLQBpnaglPe2M0hsA5oc1Q5xiN+pMD00P7ynBVSqrMpucd/45cYnRRpLB5t9PUT30mCmTTi8kg/EBffss2AckabtbMrPk+eEXNgPi1jkBb2j53nbK7tLpJnhpyDJxOASeEIjSVY2ziUSig28tpL/m8l53LY5FYTQOc65g/mi+o/HOtzrXZIOyO83wZPUAxGfx1IGo06Kpv86bHvFWBI+xl9Dto0Z6D9NPRXuuI3hiIwe8O+CLg9Xuhiv0Ev8676v2m8t+pi8znXAQb8QiJhzUVCXzjpL+z2fqm45C8ELa/aRmonVZZqFJe59PVJWMk5Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:34PM +0100, Lorenzo Stoakes wrote:
> With __install_special_mapping() moved to vma.c, vma_set_range() can be
> made into a static function there and is now completely isolated from the
> rest of mm.
> 
> While we're here, we can also remove the insert_vm_struct() declaration
> from mm.h - the function is implemented in vma.c and already declared in
> vma.h, and has no users outside of mm.
> 
> Also update the VMA userland tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  5 files changed, 8 insertions(+), 24 deletions(-)

Net negative lines of code, the best kind of commit

Reviewed-by: Gregory Price <gourry@gourry.net>

