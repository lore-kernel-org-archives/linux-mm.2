Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BACC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FBD26B00C7; Mon, 13 Jul 2026 13:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2196B00FB; Mon, 13 Jul 2026 13:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C006B00FC; Mon, 13 Jul 2026 13:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 266D96B00C7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:48:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEA62C15E6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:48:46 +0000 (UTC)
X-FDA: 84984488652.29.584DDB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCB8140002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:48:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=onjxB++n;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783964925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqsaQhz+Tm8HgoxeGaT5sBOLtHmA3ZLHG5CTvOWZ77w=;
	b=dacPt/G78SQeNQS/ZFWW2aAfx5lKDnvPiW3qsRcp5GRabFhRpYQ/Z9yerOxtq3iJ6+KTdA
	haWng1SiJiaBPRjuPJTC9I2ix8dAnC0K0/1+Nhwf76w4tcVbELkrVDSXzmAQgkN1kQ5vMC
	zcTAdbHncxdh8o1XRipjDURITpNe5yg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=onjxB++n;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783964925;
	b=FMsvHgQOfeU3yXF2pXFtlgWxlZeVIZ7IN6szcxX9ZVjtHCT0L6+8N6Gd0/zmbzKiY/GVEF
	4SqC1vqdwh/qE91NJG7kw/PlxZDdiItWpcu9Qrtz2UoJTaXOyG73mb4ks9T3I9Z/Csc9rL
	3VoX8CgW5vDkWOABVgvBrLb0xfx53L0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE66041477;
	Mon, 13 Jul 2026 17:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827251F000E9;
	Mon, 13 Jul 2026 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783964923;
	bh=eqsaQhz+Tm8HgoxeGaT5sBOLtHmA3ZLHG5CTvOWZ77w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=onjxB++nlQDm7gMhTfmaNQDGH/rqBSYbLzfVEPq1lS1OhWdb6CrePXw7aLeTLGo0M
	 pB+hJukV545xwSzfacCs6+xpPSowS++yQcA3kxVja2GEZejGL+Hf0WxMqbxsDeOECk
	 UdHMAgyb07hAwBRvraqJw/dg9AeSA04LDY2AQwPOWSaAv5NIULkVGuWTgoHQOKjcws
	 4tB7saNVwm9kU+nEYLQQmup00N7S4iEjniDnAmshu1Fop9Y+D7SzuW9SN/bp2Dc/iR
	 UQQknMV48nrRokvLe9ipKdqqYp8uAlzqLTw1pQ+E9E6C7IvEIujYOTr3MYFQkIyYDN
	 RQbf9q/HFuDdg==
Message-ID: <8f3c1451-1b49-473a-b060-a8b95b2d44b4@kernel.org>
Date: Mon, 13 Jul 2026 19:48:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/33] mm/rmap: update mm/interval_tree.c comments
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
 <20260710-b4-pre-scalable-cow-v2-5-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-5-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCB8140002
X-Stat-Signature: hx9ucf5fpjmdidar7ownnhus4iibgf88
X-HE-Tag: 1783964924-293971
X-HE-Meta: U2FsdGVkX19vbbizasW5gERCkTyGcDrdG9z/lgArSEvnnBbsLTeIwk0OWrT7snosZDby2KimzSRi3UebIFD7uB/4FQwve1BNAB25wl1VuYVZhfSmUPjbbvow6SJ0eIHQddGpuKOJtPO26KqIAobbYTkOm0fIdr6aeCfSlMQNyeb4OpQsoQ8nnIzpj1M7DoDPgG6x2rOgKmhg7vWmv+BoHy3brg6EgRwJGB3eaSIO8a8PWhDCZK/r9ePi86knYGldB5wcljvo2gk38vqUI/dDuHYzc8/5A4TISJdWUiY0r91Zvm2ixquN36l4aMOQynOpNrfGfHpWdWwwhg1OTP2lzfkrOZ0uJTFuREP8Mn/k4J/KygaGfo3fnhDDXNn5/PrxgvPxipOjbqdZ2W9E9Irt5hk+eCfefSGTdxL06vQEPhb6cWg6mFs/pfNZ1C5uA0suLRsAkGPDOiNdYGaar85nJyollKCJYbGziqMq6PMxV3BoRid/WUqbz8j3oJbpT8LiFULJ2OhP57KcW2EEx6LT253YDMbai6axQgSnTJHxUdypok49dc64Ar4U+Xm7VG79e/J2zA5fzEniagGEMCLT0qMWIbWZwMmAJqR06sJjD+nSc+fXOszs7fhg9Xg6PWfHZSMtb0FFsX+naLc8YJT1GC75P6l3NFLKcQirV/KYa+Hs6bVSbwp+uNKKsS7Br8UoIhvoYxkNbAX8k42YKfWuIgthQErat9YCHRhXcJroUFBT59s2MUqDuL45eSxwevspuzhQEGgdrUOmxAkLAuB+M0eQxvs2GyO1uiXahl9hx6js+9nYPjXiv6dd5uNbEzyNsTLisfjPtW0qMi+TAcU0JS8lHC84pXMPKkgzP0Qo6U+6Qzq7ZQHUE7HBhvTfZR9QT7BpgaLaFRJ4bYOdQPGiJb7KQk4fiE917GYqP5tZ8Jvr4ccrazViBeoOzKwpv5E5uISDeldlF3mvuumDjP4
 fdU66i1u
 TgcnRAohHaLTWJJ4bGfjvkQy+fMT5xg8VHssVjLxW8ZEvkOUeULv+wIx5a4Fs3DUENxY3bTNH7iUUuhOPuRU/hGCgFQsmHLNozXMbpJrcqLH+fwI4EElhFH1LgMjWKiP3YQjO5NzoSUq0Thn06YBYxaqPqwV9qFWv3S9ktUy64Y7dlt3ut+txzcTp6GY09YG70+wR6xbnUF1OhPPrYOEwJHCcE5MEl8TOlMseYieJcWGN68lffBqdBVVfc09fZ66050vTvv8SsTbLSVP+R8KZKx010wAeukMiypa4vrrluqKskLa+K+TblRCHA5t6+hCaZ0srmFUQOsqaqdeG6zZPJR93q6VKjr1F5cQ2Rd8XPhED6t05QZizUADQ8r/JgGyTe78mHPMm0Pbjn2S5qIS3lnrGKEHvEfZ4K3dshZCOBXGg+JH3jt368DnioHF/WNxDCxpFIiu0z8kweuGdcwZlQJRm7/2jAqXL+AIc7ByETG1AErLOMNvFz2MD4pU3wCIDPatApC9KaoD+LlnUNh/GrZ4v7TTDrYYunbkCh9Ml60J8J9pV4hx+3EhVDLpaug1niTC7QOEx7XwJskw+YDPx15N9uc6pjgjvZS2Z2t2DSk9mCz/jnIGkrtpTAolLk78U4wjx2KKmTONxNCA4BDQehHX+iLqvNQe9ZzDoYo2U/Y1Lx3wIvMMLQE/Wu1dR/yhnnuEJ6koHgy+P+KAJOzGLkVegW6mHBm1HxIIoil0A0rgxE+vKbQ/6Ujd4/MX1nfWDG1pmW+BuuwkpybSaPXyDbd2VCDA6p7CZ8dzEBnsBvVd+GPLWRAWYAzq82VWzml7hXre01twXSmspLhcy0rox8qQ5deR2vF05iqA+c6DMBbpR0Ds8HQqnhosF5G9Mod1q7amEoJiZb/dhDAITssOJkuJLABPdEZadlWwYWzuS0ycj2EytTNqL5dy9F+fweBNKPudVTx+9AldopRYjKeqRclyy55gl
 sd2o+lqi
 BDQCLfeIH9lIjCVaKzskeCO90pITHBXZJ8XArYOp7qgbsWd2BcFQ55wqKOc36fgOj/apu5cllopZzY9hWITZfahI5TB+9Qh6GJ4620+Nyz9rLzH/BaIKuWHmgOVRf6BKEjiPuXc2UpQDs7yFEOX8XB8tnRBLsdkNVloGxW0FW9qTysZHZw4seLLV1BGSKwsWfOdIB8pxfRVihvm90x3iyjyPWSNcy0vZg02Dgeiu0LbStj6dD9eD0sB35x8kIRuNZB1Bmjwz2GUBSS4eJmkL9lUEwYZFpu5aISzklP30EwPU0vywRTG3RvbTTyAPWjOiytkhUXlHn2YL5Bbsr8xRuJOBrhtjts3Hn1lXCxJxTqRYz6PW+fvRb8PPHbW50RcQilpdXImNSw2PL2Jt6L7QzYK/wWPe1XyWckkIN1RI0loqK7yD/S+KZ/RnY/D7IWbsQV1m+LEPW4LI1IoO9x7PAVmwFV5OkVrFgg7xwuzv4JNepNWVqZMV7VAOc5YtdvXoNdB7BMUqq3p4+09wIMvY3xRRCX6NMWeoT4yrpjViFxlKDmvy2/pchUqOYWf/kdrxueo5LllRTkk4Jltd9u2r/Gs4mZUxhkRXxHc5Ehx/Pt+ShZGMrzVw16Z9W5I5nvdcNxFFTi1umDXAz9GRHaU9zejhx3oPA7Nv3GYZ0XESCkrvhnaX3PiLMYsBY/qhjR9kDS/syRebqXY8ocav9R/z12KPY1YUpCHjF53syPcYvzC7jOVw8Z3pU768NezufTspNHtxNIBCHy6jPEP/MCCnu6ujWl0WPQVwxt+dcGTUpk+Phz/4X7JbU8E8fY16UwVEXRxMfjmxTdgU7ht+x1jo2tgmyf7ne7jtB+4Z2rZSGGCV6sRhqrOv/s9zSNSdJvr2TmhOcEeBGb7GA7vIsfv5+beDCtwdVJr7DYQG+yVBXOy4hPUsu4gsMxHQXOJNcKXIw2afxmlvPMWrMSkpArsY72aHi9Kzq
 WwrZOvWy
 p4gDm3+T5/HhhFzKin/Nrbof3GXrlEncJwwMp7+rqMJBWdakFGk3pQieWsrko/8LJ6BFzd4+/+l7ISm1iSRBofk0NnxxNJgxaP03x60xRcIGj3SXmNz/Yo4unbU5pGQS7HtwDrT5WmLzEimYQ8TS4pTdUQMu8lbzCi9KMAbbjttkIpIfUefI5wdTyTaZRkIiAb8noN8dBN+3+CA3taiMRAdbkoSsWAlKoAgr0N1qFiC6xCcFxjrIG6B1BFD518aP9fWTwNtAx+g1HGmKPz23+BCfBlo9mt3nT04dTw/g7MteNFdWE58FZekZFR+ZUd1I2QIcQ8JfaF6r3LRkaawD4tjE0EOOgq7hSQEUaRWNaDncWu+f4QBcy+CrFaSpmtZXuNp6lmhKN7GBP7YHizSEccNydjRgLmKwWuJOao1Rw/2a7dsKJDIqk08Pve283zQZii0BHSNtwlhEaTbAgjfXNOusjHM8+DVWzAWzl8SxSQ6voGbrv86l1WE5SA5dgrn/kCue0L5hsQ1VW5EsldkdC4R6Y26ZE3FS2VOmlsbZU8BRhsjQYnMrbnf4GzNrSpUeRHdQkzomsRPlPiw0Jgf4ehb5s+XBUm4afxUB9tWwGSlXDOfz69Wlkc+W2yc5nEIjLL8a684sVVhA6xM+zZxeq4v6s55CIx6ry4QxmYWJxOEPMpCu6N1l3NP9E1KqMRZ29Oa+tIi2k6T69DTXNta/4ONgMFzTVjuHOgCGg/Jy0bxkP27z570yXeBrnE5xMMsW97N8ZFey6gS3COh2xgHJKrfxiwECT5zro5VRwwTTnVZ6Joov8Ne9gD0hP107XjaUYJILlpDLN20BbP6INr+ovL964B6iob2FhEEEBTEOVD4rVCASUSdob2LF8BtUrjJz2LZO/FVdyFtL5zllloI5ZjwMV99Yvvge8NJTDAfjjlVoOkY1S+QHOR4s/QimgMzO/akkrpxwJdeRsL1ZLpvmJWpeiHn2l
 xInP5EL9
 wX2DTxbVryJCujU+TIq4BHnQF1OvQPZRbqLVKItI6cJFH1U9hEc+tofdLJa/taUgP7lZLIHiMQVihUWWSuavDRbQXi7ndOcE3/MJNY2Lj/N/f5rGzq7zzwtgAvwyo/LSmwGIwidrd7lpYehJENg1x1X9iHArxJgdXyPLG8djOpm8w2yANEltW0ZBKOtqeE9hbfRuNyQ/OhtlP/aH0XtsAN02QdNnUpklNvEsa0MtSGRYw4MNk8PiIwSBB/cVWAtE8nCVtiaQDjtwNlj+4DONmacOkNZYXbdMCXDEizDovOKdib/RQIjextcG4Y9BJ9262o6HtRLWyWJqKQBHi8Wrz3GHEvS+KnjcLKQL48cwkPaNVK/Sh2BD0/ZG6rnQS/urUonW1e1c71YF3nsuv7oKkL1P8w3UWVsQ8NgQLUNP3QeT4qxoPmHFWltJ2dRUiZsc1krgWD9oIjRoyNo4L7IieFMoyYtPzj15Yo+FzXLAb8VKsbouuVQaM6cFx3xs52bg6s1qrrHwXuKit/IC5rgCpqfYkBOQ/ok0n6/hbZ61ykc/7thhdjPy7cVUArV2V3jpypIJMHrQzbpARvcrnRBJzcpma8zX+RZpj9OisJwQKuWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> Update the file comment to clarify that both file-backed and anonymous
> interval trees are provided, referencing the relevant data types for
> clarity.
> 
> Also add comments to indicate which parts of the file apply to each.
> 
> While we're here, convert the VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA().
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/interval_tree.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> index 344d1f5946c7..2d50bc6228c4 100644
> --- a/mm/interval_tree.c
> +++ b/mm/interval_tree.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * mm/interval_tree.c - interval tree for mapping->i_mmap
> + * mm/interval_tree.c - interval tree for address_space->i_mmap and
> + * anon_vma->rb_root
>   *
>   * Copyright (C) 2012, Michel Lespinasse <walken@google.com>
>   */
> @@ -10,6 +11,8 @@
>  #include <linux/rmap.h>
>  #include <linux/interval_tree_generic.h>
>  
> +/* File-backed interval tree (address_space->i_mmap) */
> +
>  INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
>  		     unsigned long, shared.rb_subtree_last,
>  		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
> @@ -23,7 +26,7 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
>  	struct vm_area_struct *parent;
>  	unsigned long last = vma_last_pgoff(node);
>  
> -	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
> +	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
>  
>  	if (!prev->shared.rb.rb_right) {
>  		parent = prev;
> @@ -48,6 +51,8 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
>  			    &vma_interval_tree_augment);
>  }
>  
> +/* Anonymous interval tree (anon_vma->rb_root) */
> +
>  static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
>  {
>  	return vma_start_pgoff(avc->vma);
> 


