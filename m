Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A33C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0F486B00A5; Mon, 13 Jul 2026 14:04:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E983C6B00AE; Mon, 13 Jul 2026 14:04:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39656B00C4; Mon, 13 Jul 2026 14:04:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA3C6B00A5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:04:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29CCDA016B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:04:33 +0000 (UTC)
X-FDA: 84984528426.16.D9AD495
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6630310000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:04:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WObRFMeZ;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783965871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVzgcSLpk1lNY4vlJOoUApJQMGMtLRbw+pW7mx+iUt8=;
	b=HkDjo8Yf08yVGZBv15CsUURSDLWdS2YMPSS29pVR1Pyl8d3i3AGKC2XQBhGtv+xSXDGxzS
	DJrtP8duF1M8yDjyW6Ht1zYbokAiAGfR4J8wFqmrze1eTRjLqhacCgoe6EYjLMdIGBjHws
	z1gkYj2IxCOpHrULumcctQvikhWTnYw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WObRFMeZ;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783965871;
	b=WPGtRRZ5L/TZCswUnzfplHXNdJY9quc2ORbjRLfw2v0SdD5uiBOL/XVC3RlSty3HM8gR3u
	xrbd7482GR9FShLQ0zpRKYPUXtBUzylGXIwdJ7SnXaXj5/1B59ccI0AqQkmML9Ks4IF5/1
	7zrtN3tVptT1D01iiPko8JZJGs1z1kI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB8D160103;
	Mon, 13 Jul 2026 18:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2E41F00AC4;
	Mon, 13 Jul 2026 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783965870;
	bh=IVzgcSLpk1lNY4vlJOoUApJQMGMtLRbw+pW7mx+iUt8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WObRFMeZt93YAr3gbRXGBQboaKO6A4Z9t80jsX5xCO67FAxrWa0mFSVDOb8Y59ww/
	 6gma9HEG7FN7s6rwiObe6i5LS1ssmy92x4ZvTADdBh0pcYTa5JorqWlDhuusbpLMIp
	 fJRa4mK5FeXYrp7Wj3Cra08rYseTkjjz9MdOq4prdAagRuGNzvgdVn1QvpI1hVUC7R
	 844Be/VIauKgmZtKz/5+mS3DZRu9b53ulZSJvTlTd7v8UmqDuhfmpCpLX52F449fPJ
	 hX2E6Hpr+zGwq1id6vNXzsLy4c21enQtBG6FPKsdEkkM75J/cIhocSXyScoIIVZTjM
	 6WUUzno9Z6rHA==
Message-ID: <d500b09c-5adf-40fe-be84-36297f449a34@kernel.org>
Date: Mon, 13 Jul 2026 20:04:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/33] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
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
 <20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6630310000B
X-Stat-Signature: dqfrhxz35ehqz3wfmmfkf67zfaha6hdz
X-HE-Tag: 1783965871-781930
X-HE-Meta: U2FsdGVkX1+a83HaUjRqrj1CEbeRKJuUyYLjp8dL4cUqGqD3BIhezdZFoqsHxkmXqeiGTCm8+FNbVYH/VFnyYpY3xW8JeK37u32m9rZVqU4gvWw+Y3hiVM8wXffdai16CeQK7BHQpn5tA+r5s7sQnX/p7kYHVY1wZmXcVvXnfrrbRoWp0nsK1N/3z5e2XCoVvcQHwJTrvDAILO+Xums57rUTWdt9heaZgJmgFcXOSZCwAplO5tGmIFUOG3pgdHh6eQmne/p3gSVmpBsVF7VlUXF4UsFzUr+7XeuJ/BHKN1lNkAGbDYWzmESWagiyzzhdQkRr8RKo8dz/5OGUzxEn64GauqDLzIy2meLY1vkvUVPmmGdj8yKdIjpMNf8nazrVAmGl5JJ+yV8bCGm8YPngUOkdQgGzdWKuNPczc880FwvOljcd8JYGoZwfjsSht2DpjBklPBbzhZZs09xYM4MLkuWcR2NQ8VyeSVIkyEhFd/crpyxambcZhe2oCflgmsQCPpK+qPgNqDo232akHKRKLlPjFqcun1aM9OPSBQLg6yZKLe9TDIfQOKShPO+yk2dv7/n73HsGuWuEXmQZyuJ8NH9/USdPUT4PfNI7m8mKq7uGtyrga/6cDJf84WTVy8bp0jyjq3H5XlIoi8W8vxcwZ5kie/BySqsDq1Oi+TnNLOOxLonDTVD9T9kIqvX/+YVF4o+RAikEAF1DcEa8T/vt8FHAJxleudJJlAcG6NonnU0tI2UtmX71UmOl9H/LzDj/hus5md0TyBY1nBPT/PqNbPQKtEwDP6AeN29c2M5Sdn1epOh/emILLSqJ0GjaMQaFbtZxrKOCifUL7r/8gyB+3q/rRKxW3dDJuDhgac3eNnRSLyrDUY0NSLTC9rgAhvw0IrRRnuwATMTMuWen5lVzLkHM+XKEtSmZFNPf0HgWEzgFTwC2eX9J+lk/9YXAHKMXymOooVNzWV1JB5ErXuO
 Qn6cirI5
 ZW3ZTZKVW86vyl81NcMJi37rMSJeEbsJ4LNdfIJgYe+r4lriz/YDUWWOzf8dad8VR2Ny+tqai6Ue8Y+Y6fFFs2rP9qiwg/x7dOSbJcoQTm2J7dshRsit1fnpXErygxHgCexEYr7Jf87XXiUNnSCzoBl/9SV/rB/utoAf6BOwxfvTA+BB1+Wj33WxhcHlfOTEaQeg5r/IBRlnglKFgQQSwSHw/y9T2VVza6/kMN5s1koHR5eA5BJPbRkg/7mc5aCp7wUrMB5/UWsyNTCXPy8jHU/YXyWmti9Al2JQ+CtoUJolgPBRyvxKfbwQp+zgeRcKwiPrQ12su7FRZiwxv9cp1yh0tPgUDfhklk3bNXU/yCaJO8nT10bsnPhTWDQkfXrIEcLQONKb3uxgOAk59vaHVVXTMi7mlVp5YUU7V6GWPIBbq2E0YDJhgIKdG8i48CXZCOnFquclkKfI5YURoybK9oeOMyIsjvBkBs1VUH5Aymu3Owz54Ed4+YFoSkh2MjZJCUcAtBd7dJ+V2elAIdIPu6e74DtW3CicxH2yqsSlxAjE4xgBUhliw3/dij2e1kWwVtczDz8mX620bxJ8BDLU4r5Z1GUT5tcg8TH851EUJkeV2LBunhFsdh/qmiIvQCDKa1E3V/EtoeUOnn92PGCznnbAT3Bmh68XRF8aE3oljmbSJVGqP6qsoiZ3NZwTUh2YdnWOthYk0GLpvEWiS2bHtLIjZEsd98JlMNcb4CKUW6Zb0VBEQOQpphl4biHZLBHEqSySAXwpHKtQlGjAOi/Xr6Vphkg+MBq8CKJdnCOSRouqVuKh7ZwO/B5KkAZGZ7bHLSevSSOastKTKU3mspHB/ZnRzJbXmXI3KapNpK9t+4Ykoh71CTpG5ffo+5Glj2wa5zw04VYE/wdaGtST5bj9NZ8WTpGzXS1VhhmzqPLadiuL1dDlZj+JLO//xswPTdY/bjmjRxwrsMpAbthQUBik5Tl98cnIv
 Kt9DEpdE
 9m2gySxRwjW7lw9ZuoQFXgNZowrfKSg9PenjCxkUaNtnzpXpclfTvJeQaUIlm7HNwJ801VuqDDZY7MV5p19uPY8F1X9LcRe0h6w3gOmcqrJP2u1QJHeweafzZcSsIb9H9gdf4JI1TOriPiQOjvV4AZwmuqRMWjqg16+62I5FPw4xnGnEdpKPkJ1s8554O3iq1iwt4yiVKx/j7Ay83TKB8YzJqMg0FmZRmTByMc/j2m0497F9Gxgy6qeWYQpjBn2aoq385n2isvHvrCOnlnnfg5fvRReoYoZYgGQgMOqPtmNFfOg96riCO3WHmMXCjIFvLo2KaTKpGuhB3Umdtmn2QDymRiPWaQcTZTL4qWGwzr1X0f9Vsm5JAZXNYp4sKhLCxZKzQXDa2LNg152+FC2dy01s+9fV8iR1Ggo+jmHQZ8uNMIElC5UD/0eY70n16dvdjCrpkuPsgg2lVNSlFo2IeS5btDbm7lFAE1WjFhbgnHHQwtUZQCQEELOa1NaMhVxYUs6rsFHuxwnL1aOJ7Ti3Z55YqeoP5RrGEbrS24oNw4Zs4eT6qPj7A5rmUE+DG5yJ99QRQOg4g96LrEsYyayrXe5Z20cbyIQp7sBOivxzQZ+y9s2pZLNb1ULOGvo4H1IFW6DMK6yKbHp5ndLs8YOJwlBkt3Vn0LkdrGIiXnAhDxFVnfmf+Weu1S8vz6id869LTvTRQJxR0G750+BkfMqh4kpt1+Gtg8itQnUL3GkF3vzZAXAk8k8hGjiWXK9/jc4sDyGNdZQISOy7ZPKwHvbdtS1noroSBSBxiH8CWBJp7GOqE9Vl2oXt8AQWHcGhLFUsRK/90yewiF4J246810qHrSVRQCmNhO5KOTQr77V2wKyRVmSgAd/YhedVvVtXbm9i2OOtdCJGqGpHc57fpb8xajtlg8yaXvmdFmQdoIMjc42qGm69NJ7XPrzZhznwbYRrGUmvHTr5zxUVrH+iMPEVq+u3JrJiM
 nPld69xM
 VVbrQBriCu9/sqyVKp0iKqakQVDhCHvcf+f9GnO3tL7b/coA1SzI0x/RhvRlDScztwrLsH2adgYGoI9of/WWfcvFkZAq9f9THH0FwgRJtAAL4IqJPYOrhDRIRnCXr8AWydUerbEZIz5TfXX/zz5nHJDprmetYLYKAjbrbK7tBZLyR79J0SK47KO4BDctPonmYE4ENgStZWMC0xOU84F8qY09fYbPutpK3xj/H8S+kj4+4ZgmAM6lW5bW//UUl8ukB7uEgPfeVyAVoGVTybvuUcPMF9YqljV01ZiLFZ+AFufh4JDLEB74JtrF8z12lRoB9PdsI25K+BafHtvKbGd0Mi0R1my7Lp9LXL8jExQiaA6fmQGA2fMsT7EinM5D7T+J8LD7dowA/d3UjQXTG0sYfMdqTf0Cj8m6SxGqBuN0HONkoo73SyBIK9rRQxx46Ff6p5o2X4gv6MOJqS5xafG38Vf2g4+WbL2nGg9KYI1KyD99VbYGOaL9bUHwED+HfjB4FOjiLxpkzfUwqHZFL8KcEbKAVu2MGNj7eUev1nX751eaNqZD+gkBoK8LMV8yC7dpL8bG5p81tpdt0b7frekbXaLhCa82M3umfVGtBeJRGRrg9nATP5jMA3pp1xZQ9ENTsgcS0mcHtd/ExtQ6kvFgmSTMc2BZrgHvTzRaXNg1bIQ/qcA9ILum/op7qVTGDG2I9QkyrxfLC4AR+OHd3F5RRXdMuCRl6Vt3oXN7B3kQl8Cj2cdoFxnD9mbxwcD6AD/TKUfo4QUi+YrEeisaFl3tcG6aLH+zHYkUfh31QSUjgoq3uDejEFAQUmV4E40PXwa+fGyBUmPI7oDT41opw+ndDF6s9fygzivPSZwcco3I7J1zOVcIH8si/a4A3fitgI0tOWr44FJu3ZbC+juMBpDoXU9cE6HpyXNHkGXcw4IOJ9zsT6OK3y+dbRvS8LQpVtpbN9RU4u83quPIkykCXm+7ZYClZaYKp
 gPeR2fMi
 cu2VipwVL/jEAZaa1WtzAcXE0jW2aiaopWAGGqFOp4b9pqeqKYQTVG+QesJq1htmMTk3h8qKHgmgRhVKXiEoHpfbKQuB8zGEfLTkfXbohXql/i8kATBvEzhPkRGknUGf2liFYgFdUbgyivizmV+/543MjeL8SoQ7nLo8u86aKlmmT55lAyBB975nawA/QSZmfWScPvV/FceZwnWj5SnoSKWCOJXGnzrQWLINZlc+sg9jc8Xgz/UnEwZMcxaAafTUQTAcXR1gnCe4E9Fy+UF1ZuCLWPgf57XKMyqlLHFx1awbRWMYkJpO8Eg1JIa6qAU9QgxjZC3fDABXpFwiWTveu0Gn1YOxrRjaZKHQXHyMNZHClpvF3v0xRMRANWDiNx76ql6mlmNf3xTn0CTnhFcO9mWz/g5xWARQrkk6MpKIoubjzMXBloTAMMdnPSMUOlk4YkBpDMNVp8gLK9GTMv7NzIrTaMm/SuTFNUZlTAHdBAsYd7AkPcg6fP3efzG5Ds2t8eUHfKcp6GDVApshqkvXFy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> Similar to what we did with mapping_rmap_tree*(), let's declare
> anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> 
> In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> anon_vma and the functions can figure this out themselves.
> 
> Also update the VMA userland tests to reflect the change.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


