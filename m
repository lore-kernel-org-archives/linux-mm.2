Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782BFC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F2C6B009D; Fri, 10 Jul 2026 16:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716636B00C0; Fri, 10 Jul 2026 16:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8846B00C7; Fri, 10 Jul 2026 16:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30FD76B009D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:29:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C72DF8FB17
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:29:32 +0000 (UTC)
X-FDA: 84974007384.28.AE149E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06B6D140002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:29:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPSZGvZw;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715371;
	b=LvDkLI5Drps2yrr5iWRMByJs7tlnb9ctkws5e3Y3GDyQfKLFw689O/5FYn7LGJ4ekZ0+iw
	9va+ueNElqmA+u96ifTkIxoToQ68L3qGC64AcrHg4ALRjhPWIEa+lY+GrzNnbO/9F9CSvd
	fTVeRTrLyJnooxPJY08w8NhwerAi2E4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RPSZGvZw;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHI3HtWrClTz694ElWYDKnmNafJcRIPtS6NobkrqaKw=;
	b=UpzXn4UFX6PmGlFST+92GHiXhWTnXXfINV5Aa1TqmPrlTej8iql/1hO7nohxF4bVrDdp7D
	6A+lAaKjsgNoHfszG3pe6D02LGoErolHwWcvhZCaoa+pG0065kI1ohREFQiHcm1mjKgSWi
	ibam6KKvEawuHTgQxbxFAxrPgN3Ho/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CDD060052;
	Fri, 10 Jul 2026 20:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A991E1F000E9;
	Fri, 10 Jul 2026 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715370;
	bh=aHI3HtWrClTz694ElWYDKnmNafJcRIPtS6NobkrqaKw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RPSZGvZwyFoF6ClRKN9BpyNR8hpTZDK48TFpXqSipi37enIb5dUT+EctMObMcHEeV
	 Poej32H984Cm5vZ1zE7duVLeHD7YFi8mfbo6mFJ4FJOXEPXEGfFbv3VcFF00WQ1jLn
	 ci5P3XH7w6VvBnhFwpIJkr1BIv5hune/exyRWAf4inZWPzWlVWUvSq6OdsuSNl2puz
	 vb5dtyH1nVV9TGprKRirNigppE+kAcMcj9yNM+9vchbstpVeQeFueRmccReV6x/9MS
	 /rOKm4zBsOKdlYcPeiG1SaWJiU5ywO100RbwZxu+N6fqHKIukkw5XKszp/AF+Cr13o
	 8grz4e0FS40fg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:12 +0100
Subject: [PATCH v2 31/33] mm/vma: use guard clauses in
 can_vma_merge_[before, after]()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-31-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
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
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
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
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2052; i=ljs@kernel.org;
 h=from:subject:message-id; bh=FCbfUVh/U5U1bRHGVKwt5UwXPlTKD0aFqMH/5ltaMTc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg23zeIx4g070KS4J7SnPZellbdxntl3j/lv3O2c9w
 v49kCntKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwERufGT4Z6zbfDP29beUVLPf
 /n92Zv2YtttYd9U3pvkvz+nZFXIKCTMyrBHkfC6/9G9fO9ff/UuWhPwoNS5edYn3QQfz2ZTDa99
 vYwQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06B6D140002
X-Stat-Signature: 6ouujxpkkbmcpwbz3oxgyj8ijh6y3w9s
X-HE-Tag: 1783715370-854953
X-HE-Meta: U2FsdGVkX18ThZ3bILN/rJEnym2UKDXc7uzIzvOUFKNImZYh7NE2GbJrgOZuIW7yVo/QLXo9oq8LXyzr0ny06VF7B529dn40b7rklqeBDcqJV8N9XfmJxQA09DfR1kNeayMihV90Zg0Xc/rPI4LByIV3kZvZorVFHaIX8+yDBFj4+ptFDqwZBZ9R61QJZwnEQmNcVDwhP/dQLfIHVzgjHdwra8WFjbO4BySeSRv/kCgJCf+OKCW+22/BJLaQ0e2/Iup6xNCJYwfN3Gr1XTf1ExVI65TEbZSrRh95VFIZ3ne6rG8zXlf3OdmXbGIchXtyKwonflOpkuf9E1M9SC4+I7AJQl3ZoTR1RBGlcrJzMKuonJGzqn/d1WC1klyuONxUSTZ7JLiewjmaI+LqvsXa/bjJNXzvC5Hx5P75oqUaso+3SCla7K8gr68LXVHZSENdyPsc5Z5S2+TVPyhOb8jJOywMARxN49usjfT9gKmpKiLSL0v9OLHILPgfq1fpWMumCC59CKgZmPa8xfNb3Cz9ttx7uDx9kVAZCQwJ9jePrP+sr+P79qbfUmabNnmF27texuyvAyfBNTp1je9Nc901enQqoBBBIYB/vom8jSDcNC5squ3FX2lLu0gu4aY0fG/Yo0Il6F15qePz1U0om9QBE8aPmfy90kQR3ONbLRZVtRkLEWwnbNUReqIf90vLF036m/eXBalZJRNFdDInspsDmVQndJSLIAfUgW4yW2p0GCQr1ZPt5iZ7V/rZ20y5m9cY6VbhIjTi1VuoI2202PjZ8yes/yP6E8PMHMF4E2+V80xinEhnlJPsbzxSR3Oy92QB4Sgu+tv1YFY0CFYXfj3vNcss77xfHUpfT3f2m7uimJlc+rmsA2YELgkVVunUBsIWoy9PycKZoGPcmAbIlptY8TwOOQ42zKtA/DBa5y2hn0J1VHjpVUvcPLNeiM7gFCz8S1zXrSX+/rlUBQMOkR9
 1hDBKNYg
 f2KlI36GxYucUAc9PntqKBVA+CERMEo/LTjYmpHHQBlCX0sQxB7gT4o4fOTUj2DiTeQ+qK3olpPAQmNJJGISyfWLvJ/u6cs0uf2t+w/rxx5AT2fY/OYMGm1e5XBN9Ir1bLjoXGPZfbLeJeqLOl4Cr4XjE0+oAzw3k+XRa6tlBRxroeBtpE2CzAkEPkn1GEA3tUalKVPl7RFyBjIZ1usC265tbAcSw3RQKqVbpDfxuUkkG+5KmdInHZUMiJr6T33Y/RDjBWn0Z/KxrC5MY84INCPn9IXXdyBdyZ5S3TrTCnOTerKin74HMEvNysnwAlsfCU5lxVB+0qtDUQ5ps1Zkgq2F7pG/IkE+Y0naxtl1MWNrAQcLv7By528Le+JOcsU48WOs2e2KIcr/XSmH7yuc0cg2ibuXDy+XsxkpF4K0+GBJXB2UiuJyGjgbSduN5yLJ4R3o08uL99C73DbQPdbJGCZ/LSnCnVGhmKnACAP6CH0wLY4pQSwL910q2yzHwEpsaN5MFtUW4x4wSZxvi9ht27hVpyqxnotLHZURpLG+mM3ee7lSz2vsfFBAaiWdN+MXwJ9Zj1s04IEY/b1L6nCBnZEhgyBuYCLR4GK1KjTZW4L1XE7JJDlpf/hRq65HLEfMm45xXDF/At20+Pk9sEUcDrF7qtpBqyxXdHj68iWeFh6iLuZc7ccmTBaApPLT0v46XHsx0UQQQF3rstnyyPk7VQbS0JKS9aZ/1vD3azZXG0gBfhs6AKln5XwmVj61r/zn8eB8T9b2yWV1L5/0oxwJfUWJhITcfuL6/GWk9nMj8utzXpWQr4NZHdLR1RddVWkA2JjtJXkeZL7cRI40x6yJySGIw4nnmZ0lmqOQXoNbbfc4gzrqwkKdtlwrhT2RGQQ0y2fzIfHtu0jjErmewA9sitGlYWF19jgBbhilNKlJopprD4GzWjuLNBwvL+qqX7/XfpoZ2G/JWQNRZX6jfTZEKZzZBbdjy
 dajuwEr+
 7mGldxysVY+QjMw7v6u4ztyLiY1BUIR4v+ASAMJCcuILcaKIxBxr6tux/GDR7KgQ6sgzRtjm7pUUFQf3yUoUdwXMv7Atwt5S9GISBzOdbDk50NB6v+O9//AIXjm4RWQiBp2ejyM6EIetamLQ1TGPTNKNbcdUN7M1qQzij+LxLuPImacEXWqfPbKGS8tI8LlUWDAQXn2ZzpcQRmgkEXBx6o5jW3H2yX3vLcTxalhU/0kCL3HxnaEuC5f9L41lj2Qzhk88ZE4/EM293BEea3TsORP1g1J4gdce0T0ChRSYmAhXBVuHQ4TND+31GRq12GScMos8gLofroMoRGd/Rd7L0awhjMo/fysnav0jPd/lM8Tce/J5TX+FxqCIsAlqoz5jfKOy85sCjE0w8vQSvIaT3sFkon3IMp+8If3iCNUZohyDULe5Qt7sjfzZkp8lOnZwn1O1Q9TzERfsz3nt3s9Cf45k1VohCmZdh2kj120lPuIaDsQqxDsz4hTvCY4MJEAQ9o0WI0cggzEWWBO+6cdNsYwM5Kax2+xGUovRJnUFBWBAnVQX/gp8chtOPsPKBlth0JJCaEiSYQRCrMziY2SuQ9PJF7olUzpjluis/BgLVqQxduTDnulWO3m6Bttgd6PP7abbkTb4xX2rhjuwyOZp2PbADo1+jI6CTM17U1yOKIgKcax4Ha0x5RYAjRKsFKbDq03xNXx9jr/qDowEvQQkAclG5cmM6whripBg6k8P1RaypAY0QLsD8PuqdTzshdkPSet0e/jXeAEdsTtLefY1NA21JkVc64ahdbdhd1waKphQvnMMc3K2XWWB/0x25r4sjHo0mWpwAkW3m5seHprJ/oVjbjEdUY5J52NSSqk9CjrcbDbssaGEzMI3+y6Xntb10oYK6WMFX4bWWhyp5Dy7jjtR4BTvjv9aKMYlAXzT1sIAgB5VJwjYxvCNSM6nkX8quuRIjxpd1cGbC4c5SH+/7g3MNZUPt
 LGU5/SXB
 C8bwQDYeoMisPdzfd46UU3xoPX3Se74TkTNZ7G4oBb8W3IdNoHdVvyV8865FWcQADrXbyyvB8I8gd4DQNb4kPf7JxXq/PXBs+W8TA6En7Y9QDv76rEBekmnty4OvUeeYobBcdZOH5Z1d8T8msbJZ5hgkNzokjov5BSfGRxtioG6ejj5tMSIEh+bHHw65bRxvFB8HhJICtEdKdIW/Je0EsIZzS9aN/b+oG0QnLaeErgDt8NGxq3M2BaiAhbEd4DKrf48dguL949N6vgrv9ZKaag36Glosfbh/FTG5P6rE9wfCEhmQe95XSosTAAcvaEXmZDtrFjOSfsnIsqjtgVb0iJqo41CmVuoVYH3R7uBhP/dcro8teZLKHk+ttgsFtz2qbVSWJcbi5d/t6asoCXO0F393QnHVWEMd6DeJZiDXSQlEhI7bPyRrM+Q5NRvkMj9hs1+jaKieuo9Xb7rc0YeAita9WYdTXCV2IqIXE2DJkccghyw7EGWsn9oJ2r2cz/4nWUjCG94Iar355dZecChhWtrjd+5dxlxUnuoqeZkSJ+uq4JTAhhxHgSj5d4T6FwEKYR0S9pZ0j6I1T4RTx7cITs+e3vGt8hYQ2cVtEsEAOEjikKIYLdjMpP3ok85jo63Udp0Ng3rquzTRFX9ilsUuVvaZXcZAx40Tc/D4SL2uUret6ayinmIn2gfKN239y9stwEJTrUuoxd5fe15H1X/Hp2xUOwr9JzvpRpcpLiPEYUpHBf4fGi/tNQBBPd5JbgnWxMakbO+5kDAb2wTmk0euXIXAJ7sOFZKJAfY974UVCHGhlovHrHh5elAVVc691FAAk7nXNTpKu/f9gf7qXoaowvjOmSklfPO/oXCz7QjjtsVmqqiD4SyZaQYq/ypf0bKi99up4zgV91q+l8/+IirVbPE/yvcT9/yhj5Kzx4rqeF4MTiglfvq57XWdoNhpsOh4Df+fLVYe0Wv3ZtzUfXz3lG0VDnLQi
 +Z2ickFQ
 MZt1+ed5SLbEE9KrkyFkKpIAru8anLZah1n8e+zernu2DdIwVfye9NIFFGCHCeyGBauEls3VVj553deFdVcNCzPAa06KCCmx0dWNSfpchUHMpV3wTtMyHhY/hcsjWd5jEVN2QMSz6yYE+q3+vmlt99W44SEivW0kyWoHChIJM0YrGPYMABLXq2isO2cmuAbHjQ5WogRUTdHz6CqvuR6g6hqqjOpo3aKwZXMvHYHwpzjdA/t3nJ2Y5IHTgzVtUFY2TvBj1IO5IqGvNC3MTUycFs1Z6ITlQGL17l+MKuGavf0E7Mk23UMee8B47ECNL27JbzK0He5sg9PAN36+yyhXyVYJYEPMK1hKHoXsjqynYOK1hqPA6gVNgt0OsADb6pxVvEDEa+cCwGmFgNHbQsjLsGLF7urmDTC8PBB/ehfWwTL5ZqRllBxm1eMzf5VNsLYodxewStNXjWGct3rXZIvnecGMrfa05iL6G97v3MESJpdOWQUJIYQDXKzC0qvIF/64ZkokbMX5hibuWYyIJta3i9R2QladIgA58BMtubOMKr0r/Z3BfKQ2PJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than combining a bunch of conditionals in a single expression,
simplify by inverting the mergeability requirements into guard clauses.

that is - instead of checking what must be true for the conditions to be
met, instead check the inverse of the requirements and return false if any
are true, defaulting to true.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 737f0d692e6b..9d556d33b24b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -215,13 +215,13 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
  */
 static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
-		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
-			return true;
-	}
-
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
+		return false;
+	return true;
 }
 
 /*
@@ -235,12 +235,13 @@ static bool can_vma_merge_before(struct vma_merge_struct *vmg)
  */
 static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
-		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
-			return true;
-	}
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
+		return false;
+	return true;
 }
 
 static void __vma_link_file(struct vm_area_struct *vma,

-- 
2.55.0


