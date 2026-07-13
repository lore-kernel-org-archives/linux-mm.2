Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78DEEC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6969E6B00B4; Mon, 13 Jul 2026 14:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66DFE6B00B6; Mon, 13 Jul 2026 14:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D726B00B7; Mon, 13 Jul 2026 14:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26B456B00B4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:12:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEA2B1C0080
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:12:50 +0000 (UTC)
X-FDA: 84984549300.13.CC839BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id CE4B42000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:12:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+dTcR3m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783966369;
	b=XSSoh5mrfMrijsT5RPQuiAIo9XiOJYVEKby9r9qB61HJ/RwEKS1A8HpmmexsMU3AnwZzYU
	oZUpCE3yeZMAzyTSlzzDS9jdVLr2+9avTvVZ0GUfDA6HqU8vxXhCfFLJJjfoMzyK2VcVKK
	ttraGUt2yxUq92pPFXFGjV4v+5oCTGw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+dTcR3m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783966369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vz1aumqsT0b6f336r0aYehoTvpo8WfxfycSLqp4UaWQ=;
	b=BUnKi3nfjBaSlsI63ic2OLETuBrghMXUS23LzotyBiAi4c75qzPt6UM+AhgF86GUWwOBUm
	jAVwVew2I/Rwuvm5aOyfdW06tnKjooAqylc+0W1NxZx9y5RJpOTTkSrAxMaPnGnTXR569M
	C1G8y5MC2/qo1N0qTLQ8tZiN2uTDdcw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68EBA414A9;
	Mon, 13 Jul 2026 18:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9981F000E9;
	Mon, 13 Jul 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783966367;
	bh=Vz1aumqsT0b6f336r0aYehoTvpo8WfxfycSLqp4UaWQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L+dTcR3mLBKUAyeuAPNAmmTZgYLKhxdgRU7fgk/CZX8rtGYQHFGBNuvzOHW+8J5/N
	 h4Y5NyOqrJywCWN9KORJieMrGlECHA/FzhDVGIyzGPq0wR/M+2BuPs1Si3NFpqzTU1
	 rOHidmcl6Qi22RveSlyjiOik4B5o4h5U1iC+01HSJFgW61QY3qQcUvpN8L0SuwFp7W
	 XIQ/6rsy80spgSBLHqHEBJxKscfwj/07cV5k7TYTLba+ujWjsvrAvfMAhFckm8sEUq
	 v+n5RpW267LaUqUkTF4I8gnuoL2knURw0tFUL0aTBulsMqD5AWu/KxIKZOkuYOUNbi
	 BNiYAZXuIRDTQ==
Message-ID: <508301c5-5460-40e8-bc34-6410be5be40a@kernel.org>
Date: Mon, 13 Jul 2026 20:12:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/33] mm/vma: introduce and use vmg_pages(),
 vmg_[start, end]_pgoff()
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
 <20260710-b4-pre-scalable-cow-v2-13-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-13-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CE4B42000A
X-Rspam-User: 
X-Stat-Signature: shhbqrxxyn1g4y8fwwx9jhfja6tuj8r1
X-Rspamd-Server: rspam03
X-HE-Tag: 1783966368-812145
X-HE-Meta: U2FsdGVkX18QDKVsWUvl6BQw13MynFhf+PhVJwR5Q/P0qJ7Vpt/KVFFVvee3jcAVyFnrvPjk2eH2F8euWv/x/YbB6otk1goSRjTeB8JX8WsFO8SCWCgzb9/pPnrZ1guuWQUJ2yJ7Y3psPVy7PsaX+tnykzuZf9Wk6Lj/cIsAzO2YG0oBvVxBfxGIPvO6XQcNGjPoRL9mY5ktpuAy1iFDhd0fImvRh1N1qpRwulwt5q5s7JrEg+lZO8P/1MUhFwBsyQrFVXFJmjYCKBTcyRGG2ZMZU0H85etFX/0S/yHkb5RkVzy2n8EfP6Hh+b8pw24QXkm7EH3CfvYuBitzD0BlZPLipdcG+AlTHYBH3G5IO7d/ZJ1dtkHCF1COnhVg38P3Dy2G/L0aqlJ/faJIEWCiqbNwvHtabP62TOqLgSxWfg6FvPRZNbSvrwl0Gp3VJYk1pz+gjBCAtQO7Ic3TmkgTswY1vR1nzIruZf26tzbCJ6WX+maA8smrxbOg5OMsxYV/TCcxULBEb2oA8cOtB7xyB48ZCB3JkpbgvtB6X9YRh2ofA7d0MCpHKTJaaKx8i/K8gu4hpYhenOcCip1rWxedykJ8+N/z5hacU+nBFINePenWwuiDlk1qCdiGFIVD9Hjs86riVDzCRswiO0uIZvfaKDs8fX9364tuu+bN3E0qST3FUTfQwC+OI2PV/4mBPdkXwoU4Ir/vWmnA9ZUjAx81vgO9DI3a4NPMYqDXLVAtk097oXIikPPYk54ka7AiNcad5RotJQRvY+47iop9USg99i5Z5YI7qImRPzHA4IJeMS5nPa6JvTIsKdphTP6w58GGa3TnIO31mUQGjUeoTRhgXXg4ugFelM2dJKlQAdwKfNOj3azEnTZo3aGL8gK08/u7vqO3aic64t5VkUanIHHTGwM9V1+AXhHc7ozRILhUKCoxp3VCaNPvfnBh5exCkRN7mu7JX3iErzoPEkW810I
 SdV8MhKJ
 WBnHqlDkZOenCzxcsAh3FURAafoiu+YCPBEWvd2ohayF9Ub6eW0XSBj1lUJgzsosdEqHKl+7EqiEzMTjGSEdIhI551aIZzZYc8OP6FnqtSs10LZMUN9AwMWWf+VJ8aLBS4IOGxX/UBh0vCODW249hIHpSIf4Nba2mtzGyAWVkTigCj8PQy7fmST4rIhdUNBmbdoZ/9F/YIdLIRiOhQY6YiT/tiiKr79rW6mUqEe9mMFkyZI+ks/0YxjSWwn2O0dzdrI8d7ZEIkBprqWyHpzPsCc5xwNeT6AqGyRcCWm3XjK9VdhD42CSVZwHWwdBUfz8E1bfi0H1b643NZCsFEe7lIBBkThkA0CHyYljS1dB2QTZkROa6T7PaLHQkhLpGGzpd1lZDSef+fH2dpiBnTTYN9FG+4Z0tbqNw7b6xsvcgmT75h2mfMpThmiKWyIxf3X/MX0OmGCLXmkDsBFM0GBhEjyA0Ejuv69sf8D2ePfnaWoiJko+T8mHd9Qem40td4k1ckF0LJrcXu/9dLGilqV7r5ikL7tOKTOOjGJPOax0aEAjU+wzTx2tsGYRAXVRr/6h46SOK89cXMY6GKvbPyy9mC+o3o/aT2A1aqwR+wI49wGhXI3QYocecWpBvpfdiOrk720SUfrfa4NKwzJkewlnkrh/0ajy43W1cGDim+TN0vEH3K3aQ8ZrpPVZ65Wn3ZpNxS3b1TlnMqW6nIkzXcAuBgT1XtVSgjG+IsXtXTk8paURkwddPaNsdrkekICs8unmMX+Nthau+bR5O4JCoUwJw75G/joWtGLmvDi+mp9gLiZhYSkQHX2N/byHq2pgqQGHX9eRjLrWjwspsm15kM+RTfMgNEtMlVoq9AJS/qtZQqIYDYSygIrCntmrZ1F8/NG7pzfSHGovcocYfpTOUII9c5/vmD0/qmlOPwLURHoalCK68fwnZGALAeR62SBCaRg40HTF4o5Tj1RX7uJNfGDXdbOFCBwGK
 w9/md8g4
 VmYfM718NK1s0wzwp5p2Xg1s4R42780yAzI4W5CsgcJny00qtey/ntvql5jaEWFV6docdUmutimzah44z8QcAE9XmANh8Gh8IofQGNL3BzADk9E/AVDXi5WJO/yhZrsIeJaMw3tneFqeEZ8MUbFr2JWYicU/J7lgVAMaT8mpoKXseSa+YFwHPb4+TTOfkFYt4pmvNjPcapa1hq6GPVNZr6ZCgFsrVRaWiLLKoIGCTXe8Kj5ZuGR8A+IszpM/NBl56GPokQz0khP6LQSXk2j/JxmiEPe1eD/Ywb1V+VZjAp6vQ2cLrnKibxJiuOwr/1xGHwxX9dW337eFZ1iRrghnprtoe2Xex3CjWD3AAkfIbEsXoCzfmbkSzVQKEgrlK9dALfV2UWGZbtXPj7Gc4k0tgUl8qvi6/WELVzdaXIeJm0EWnAOj7zQ6J1IUYlMLumjMRkRP4C8pyF/VPJoTj6lSMfEy1B6LVdcgu/KKLGfqoAlgIF4H6oN9x4oyKTe+5Aj8ogNB5vVG3X3UbmW7nkWkndC86lkfq3Aqu6FN2A/4FnUyUS7QxpHiN12zexbErjPLU0lCGLCqgHX6IIIyY4d4f7TrV4u2yhV0/RA89QAXF2xvj7xJ24CgArao/SZG4QjVcSeXivTIEYsXX282ouH4NFVC8rVMPxeiRskPy1oBcaQjkVBj0lQv5dJEk0KgtmtkMfk+cVAFwaAETAQH67dSJ5K0fS45HqntmdEbBmxi1Zq79V+vdtrFE3zIP0R+bHJcHfEK3HqlzV2m4u5iR41HYeM2jrc5l+p3RyU5dr+VsXXIJaU7r7b7KBjJA0pQOKqJaIbIo/L203KuxnJ0zAUaterNjqNdTe3t6g0C6Z5m6URIVovnDuTzCXuTj2uhOVzFhRDestT7XTMydj8UEXLCKAq/TxfcVql6YNgdpXSjdpBZgq4L30I1LnbJhGe9TvnOSHEDLGF6R/PPusDLzVtX/L++ZnHMM
 Otb4b3On
 4rKY1ZS6G8gVdlGmaT/NODv1WhsXT5AHyzd1pe/w81t1gg8uhjXQYaDRvEyqxRQKYEYSN1F4oS+50krKgXpF7ZMYpiVOoXLiBWSUNstarxiy+pGPiN1KCk7EEDuxxzn9CuAjnqgSU4ZRYQ5ok8BcEDqE94GSGw10Y+gzxac02DK2B25rQ9LbfakrDxijQjNz4eGlDnj9xHp0R+KJYXzaP2MrPfJvaBUfC/NOVnCV1WU6/yw7sqenG4JoqmuF+26AbgpWffrRHE29jkzW0uKRLWVBzJ65gwjfDryLRPlmI8nxN1jhHIUAoFeMlPeWt21AHck3mbhf41Uc704TdRUtthSsj922KdQ7bMffCWupGGoFn2PrpzCV1W2xNQ88V1Zd/xq90cqdK5AwAtzBtas/ZZQRV5e1rewuopf/JEBS0bzgjCKwtowbvQerMWdt9NHFD1FXQfp9L47BXtQIbK5mjZP8hSHE1zuXIMwnOxFRGvMJpFGVXdxaAZsCq3xX4GfFvWLrtPuZkaCRjUvvoBcE+dxZ91t/RNH/ZovFZV9gaMFjZi5dGNt+Dw7db2qY/NSOGFjSNZ8zafKg0XL666detDnnHQ5zHzZTsPxMfz/G3mYj+RAeyEcO3HulUUnYzMNFbcxhmgJLbl/WlEf2o86OulPcxinbRW3FHtNd0MKSbuXVDQMGJWACYQOAhMbIGcPOtSKlMUGaaTrZDd0WzPLwNJ/Z3yyzFJAb6Wlf2VKnjB2uSiqNyGb59gFn7ApdSF+z/v1gsCC4+avFNNHEqbe5BtX89OVI8FMBqiyW1G6mLO9ZQj5l5hRNwkS5PU8yOWCxi4QALRxu/+G/qg5cSpNzl04uzfN8wr5+SvvwPPp/AQzCSOgW/oEoXmKEMv9xxwyZCdSdCWQPy3BJWjD+5F0TaEmau2O2ujDMCUz2JqjhphW4t15QLAfWAmiAb163enmOjzHTwcgYJ/MRXE7b/6UxWZolhplUz
 qe88gS2q
 gEvgl00Z1tmX2X+Ao8+u+Lbd+9Fa/nlKzSOp6K6NHHugO84XB80KHs0sWZJKsVSifQt9dJqIs7lntoFqiN1zzQpIULDJUY3ethLJ7FWqpuOJFsm/gTiUqAcLjCgLUEmfmGBdUmEgxfd4wd5MdtSDr6+NStuK03NXzPvJh4ClBbgW4Y0hNtd5Qm7HmUtZEzUn6q0kc1IqlNfQjEIFNGifisJ3mJt6o5b/oWQlZpcLEczEXuqfolWctoSf8kVbzRs328SZ328cjaojJLfPP8A8Q+L4rEkaZ3FeEAykhoIkRMJqLIqreSIYH9i7ENq/nDGyYOBluI2lbLz+TCugNBcpENB2No1oc0wt9dVAqNT3MFSXkd67ZMrSmoNpjoeEPdvJJSzPXn08Y4Ht14kMywyxnSuccKgaM9+Cx7F1qWBtaBXn893iFADb9OP0GhdwayXd/H4g9SDNRXk5PvdPDa4sIiDszjiLzXub7N8aI3Cuy5xNTXAk4hMTDAay1gUA3I874fjz/0lWfySQdfXHSZRRxS6W42il9Tyn6ua+rOeKHMtLThTDGVahoNyd7BLEVNDXRhpHoI2BpA0afqHMOhgqFZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> In the VMA logic we often need to determine the number of pages in the
> specified merge range, as well as the start and end page offsets of that
> range.
> 
> Introduce and use helpers for these purposes.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Uh, the PHYS_PFN() usage here was quite an abuse. Good riddance.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/vma.c | 11 ++++-------
>  mm/vma.h | 17 +++++++++++++++++
>  2 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 35ba3475128f..995de8198fbb 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -197,11 +197,9 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
>   */
>  static bool can_vma_merge_before(struct vma_merge_struct *vmg)
>  {
> -	pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
> -
>  	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
>  	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
> -		if (vmg->next->vm_pgoff == vmg->pgoff + pglen)
> +		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
>  			return true;
>  	}
>  
> @@ -221,7 +219,7 @@ static bool can_vma_merge_after(struct vma_merge_struct *vmg)
>  {
>  	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
>  	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
> -		if (vmg->prev->vm_pgoff + vma_pages(vmg->prev) == vmg->pgoff)
> +		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
>  			return true;
>  	}
>  	return false;
> @@ -759,7 +757,7 @@ static int commit_merge(struct vma_merge_struct *vmg)
>  	 */
>  	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
>  			      vmg->__adjust_middle_start ? vmg->middle : NULL);
> -	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
> +	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg));
>  	vmg_adjust_set_range(vmg);
>  	vma_iter_store_overwrite(vmg->vmi, vmg->target);
>  
> @@ -962,8 +960,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  		 *    middle     next
>  		 * shrink/delete extend
>  		 */
> -
> -		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
> +		const pgoff_t pglen = vmg_pages(vmg);
>  
>  		VM_WARN_ON_VMG(!merge_right, vmg);
>  		/* If we are offset into a VMA, then prev must be middle. */
> diff --git a/mm/vma.h b/mm/vma.h
> index 8e4b61a7304c..527716c8739d 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -230,6 +230,23 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
>  	return vmg->state == VMA_MERGE_ERROR_NOMEM;
>  }
>  
> +static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
> +{
> +	return vmg->pgoff;
> +}
> +
> +static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
> +{
> +	const unsigned long size = vmg->end - vmg->start;
> +
> +	return size >> PAGE_SHIFT;
> +}
> +
> +static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
> +{
> +	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
> +}
> +
>  /* Assumes addr >= vma->vm_start. */
>  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
>  				       unsigned long addr)
> 


