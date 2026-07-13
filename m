Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99CB5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2496B013D; Mon, 13 Jul 2026 14:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81D26B0141; Mon, 13 Jul 2026 14:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922DA6B0142; Mon, 13 Jul 2026 14:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64D676B013D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:07:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E10B2120151
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:07:51 +0000 (UTC)
X-FDA: 84984536742.05.A0599BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0B35D10000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:07:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TKnYTlap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783966070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SpufigZiou4genEc90Cxe+OObzBvXak/bm6Su5s66V8=;
	b=xoEmynWUGfW/NX9uNPbodxQUo7rebVz8+/FjwYdI642qiKIAYqvJTmEpIASqeqfKd5mk1h
	jFWkuwlz8XZBXJYRUDCAqmrJQdZBXVATKoyN+iouWS9EEOE9iwoFpBE9ojP2+jXBG/iean
	oBnVLZvjPgdzGj4RgHozuKUy9aIsdMw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TKnYTlap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783966070;
	b=H9qyrC1GBzZS9UzyfzWeUpE/FYuN2J7urDaxAz+0zUvmp5gXprRTW1zvZhVgJVY+cgzmgI
	VmXuxDuyCGUgxZkZeY2wrJXIUMbD+1aIlKabbZHPRNgrHmXmdKe20ilrJoekrJqbbZVx4D
	3mdKh3v3LFENOHbOCKHtzVpHMz+CuOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A181434AE;
	Mon, 13 Jul 2026 18:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3317E1F000E9;
	Mon, 13 Jul 2026 18:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783966068;
	bh=SpufigZiou4genEc90Cxe+OObzBvXak/bm6Su5s66V8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TKnYTlap9Jze+m1JhDyZAfUWuEQo4R01QRzf4HVTsI9jH+VXtcETN7kf3E2znyhoo
	 +/D9mc4X44fTUeLCZlxDRZ4P/N81fvrv9kRNz0n835PLouKiL7sYt2BOs8Z9eO5tD8
	 eLGnHQKBwW0COHfVGSwCP9E3e538+EaerwoldgtcFFhu240nyL2tvKTWWfmqZsBbzE
	 fsvB+Bqa9m6ZqBbQMfYDSIs5sLQ0+KpwyOTLPjEIkMmC7MDBKQlCbW45xzmhGgsRgR
	 v4j83nfST8o0aIiPwzAgAYh3tFC/9m/qFgZRtK5ZP6UjUurPBAHN/PCpjwoIpVJNha
	 xHovJK3h0cu2A==
Message-ID: <3436832b-839b-41cc-9361-95dc4e26513b@kernel.org>
Date: Mon, 13 Jul 2026 20:07:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/33] MAINTAINERS: Move mm/interval_tree.c to rmap
 section
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
 <20260710-b4-pre-scalable-cow-v2-12-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-12-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B35D10000A
X-Stat-Signature: b1b7x1hczgak4cy75widbu4i4en3818y
X-HE-Tag: 1783966069-100258
X-HE-Meta: U2FsdGVkX1+TYBWS9i5WOt8IysMmSg+SSjOYBEzmgio+s5GmCJHw01Lzea0+CdGVZuzQZoYZhHoY3qJhPbo6QbjOMD84m7ZMO3FZTDXetzgIvUFfKPZp21WzS/RlRi7uqrU1J6sMu5LLisaCNNLRPEX9q1p8vFockSc9RQ6H5Pc0kOEaj7kmTfEoPrmqLUciP6tKlTPztOEf/ZiaCsgQdlWbahcIk6Yup0vAOnHJI20UjPs/kvdKIjKtZiUedkKj9ulr6lQugfPkJYod5u5mGtaPBwNvKrxXXYja+pn0wSYWUyf5Kg4PGRV1IxDeMrwFioxEgRio7OM/m5v1rZuswXMjPyBrC6jEqgLjnUv7FyCvdZraaoodRJyJKmLBxTWoXU/lu2SeLUUN0zfFcmNYMj6wiFGxDAhmQDiuKzZqVlrLq/ERCfUaAw19cmJBuCNkABoKMyWTiLNBOleBJvU/mG23WhDIvK2Q9gwgK+Ut0k5KtYgpElIVFQJC56N/PzCru9Gc+WQXOWuQDt01M3tTnD9d6buijMGYWGUCx56CMW6SkgbaDGGo2qSvtrHeDn/u5263kRbsPP1YONCvvo5KES5aTb0NxutH3Znf0dRf5sh494BVqLj5P+ja2rvGziO3jdUkQd59Zdeq+ul5UsX9vLvvGN2AXgWI0jXr1AEoU9vIt82y/Je6/k50Yhk/LQRulsQMdQeZLdTwsNA4TX3dwqGS6i1oNSnswpZaCa9TE8zAKMAlcUyXs8PJNAiUJ+/mwpJQ5m9V85WtOdYyuqdISfj3k72TVszDtjBvVhAJKstXuOvNrZUf3h46yjfRj65aK0iP2gatdKfEapMbQzS/OkGtS3PUa/Z0NoHgt3O2EdIdRyzEbglXVuS7cYW6yBMo/g4Ni6rQUClR+A97JLRtjW3dER1Q/2ObY2gYqEdySbq0omSAvXADuEbrZei/yY8UVBFFNW+CHAzySL5vWUN
 8uDrieZO
 FndG5bLMofs4Fbf8pTt1753h8tpobKMcdCqQfRyatWKwjVjaVepkNkPPk3Cq+ac8tsWmvaxK0F/VWu0cMR5YxzN7XDcyEM87Qn8BYYcyUHreGpyd4IK9Hf2cYqqNJnNe/gLIdwKHdmyasG3husBnRmlwWk9+7rlVnFzbGcw/G69kP2Slpkn9+8kc60B7ZtSajTfKJA4Rmb8eavcBDuiYv7CFoz9mCnq40UUcxWYSdoZJtB7oP6SQjDIh08t/DlUUx/MRIN3XFKZz/Iw4QstWxXCNDxDC+GlKYc73CJ8U57yjy76ddRNhMle/YtGnY+jjcgPFp6GjzxXynCTsB+rlsfT+Yvuz+LkMvPuz3y9aZYPq64fnwr2k1E17n6zjFg4y1qolck/UddAZM7qxZ60oxon64eVjx4un12cSQ4/OofBl73Ac3VumfiJ8XXgNkgpC7EHY8HhFOEceOmzmJPEtE288ZuPpwLh+LRGM9qs/gXshvasyIYi8pRYEkI2quPd2GhFUOVi6pocRGtvG/AzotIs7lCOlnfm6TSvUcwlMAmqKRT7o8FsQfwzN7Gdx/Ax4sdCDjhHKIvqhDWbzPxDD54KmxKHckXfsIBVeuFUIITb3YJY69YI1CO7C0z5X/MoEkBshuh7ShLVMCT9PkwXSM7ATTduGEZAjBuP/wzkbMmrO54U4HPq7H04EEObSyVLoMPa9I+LBEs5HbEcviMNNgM3LvaCCDIblRP+QIOTrFRZaTcFjlptbPyajwagdfTWBB48QMXVNQi1+D16FGRWSK3f/s5L8Dw8Xht42S0/DFw5BDjVdHNv8okqobUsqx+57F4hzqR2QKfswWzJYPJgq+lJx0Em1tmeGOaN9CjPO37cz8Epcu6LUO0ILidem9pqQYCc5EsebDPUbxuEYDjFnljS+5ueIVB7mKqTJPOPHVLpmHxpO/EnJEuEZY0nZyv8Rb28LgL1A+b3FJ7Xf8widUffE4qm6Y
 h9bbFcsb
 UJYZxmuQUoVaKyNA7kUyipB6z8BopUziuNCvT8wlgkdAU6eNpZtEfYmEkYfMpSQyknu2C63c2KxoLPAmFzumjVdaE7e1gPSdf2eM036XD4k5TMYjQA/8EFWxKqhvVQWYS8Qhkw6Ys2dvW/3HfwQI8jSwAHxfXM8U2u/Cpp1IMsHH3jDae+pQgfhhltXRbC+1R/pz+VdGP7Xf33sjMnuZc2m1pQ4IWWYYSHp2SZVYWlYdwtWs5QfXj7At+TOw5okRDJj/bRSN4eouvK8wqz21t/MD8HP6bIGaSnofrMTGlilAppM0+hMc52NVq6vhRfOgIuOQ3iGPFCsNcB47Fw9vDstnPdrM0Do0zoNC1m+YJRbAmuRxTA/fCXL0H1Qa/BM6crLR0yxIrs1XaV0uGe+nKx0t5KOqXkMRaly3EmYhmabi1mK/9SoG8+CeLT6+qPmyhFoAVlgf5ESUi3UYyvymdNczb9d2lNf7dqOBlfsE0XCcRbpV7c6Tz+IDyKKH6KVyZLPiBmNlLBvzwODV+Fs2pJyRt5hu5IBKTHgBNMK55Cq+x7hHz5DJsu3MMTXe4xCpM9quKtmSnikhbKG4VTtwA6Kh0l8hcQ88F4vWs/25L90xA4x/uRkTp7KPFIm8FlPQ8ozoLj4kiZ7AJpYvVbd0SMB5UV6DnJNyt/Jh30U2YKJtsa1YvvrTGvhNfGJEkBV7+3R9QXgoOHQmBSwM8ksfIKaGbYC0evNaRaOWOdSGv+9q9NV9yMwoC3523yo78afXd4Of0Qq0zOBannl2pivXcNpAxwPpnaDKdHLg0YtpEv8a7KUZpug3JdHVoxOBBG0cYGML4s+C9dm/d0hvJMFEEH3j+9yQ+OWcn3ZNni/J36gCPBazUdus2mwsIMXVVheI+FB2a6XRwkSiyg3yrz1Ogf7vYv9FL+3jv1BCd43F53qwJG1RGq8Yp1XZNp6x/IcJYx/kmyJOO2Vt8kXbHfCCeBcQCndly
 BfkenWNi
 Rq+Pvc3RFmx1EzmdXlgJMSY0OHpREqFOydm8NZ5ILcjcCrM2o4n0WHyRhjx4goE3qfkuyBoB3oH3u1zZI8AFuZ41Rjy7GqJ3a0d2cr26DEspi6Ev0ULkLv4FOttIxOKg6ma/jrwLhXmj12AFco1bdsDIfIxPWxL1ocWrN2qFxESQXgP+gEzxKomOgE1xRMQaoTpO/qmNsZ8xWa4gQo+i2frb3NYH35KLXP2mB9gjQQRU5OvPT6tapiHtvojGIZy3txpzlXd12FMMVAYgXrI4KsvdvzMjJ2g+cMZY6BbvsoVIH85WxIQ+JGUUZNDBdXrBjjIi8Bkg3hThrNmepxavlrhU/RjM4+e2ZFOKWomoBJw3KldSTZ1XV22xlHzrNFiRD2yKQXy5gEVFL1HELYrinR56PR+e21DLkHYubJEEJlsk2UzBBrleQlF5l8awH6sVLcIGoLCRfqzvzSH8i7MdXJo53st6sDOiH9kkQ1/MXWohhEqhLZPqO4HiroCFOUGt+FdNyQlapnDVoX6SdzuG2uM1Tv34j5q39TKlzWPgXXoqnzppNfyTWacB4AXwdEsTUPy6M1jrYDmSyfPUSsTDHA9jveuiERqZe8PFqtKzEwAorJYeZF+80C2T5RTNRMOKho4jntpP/1rBXSs78GMEOBdIODA0hclD4ugvYUjiXak+Ibp2qyRL+yTkAdGaMsavs2dxIKV4azbyD+nKtsVjoGhQdUsOzB9WESRrXKkc6NGcTpn7uIxhH8otr29JgixAxZr7/fxe6/2xY3GbDqlr+Wj47Zw9FQIMTVumrn6migB6EJEYvC28gRd7rkd7avyrBe3suSTyxb4dugIuJarSvcMKEqJr6WIuevUojoKYuFbp/cZgQd1aH6HrI65Ch71KM0pTvtAzXlHym+dPQg9ObqzkOVJ2C7tlVJhzgvhlVXBjsclsYoux45TB0LsLrJiX9G/A4ysS8OiBdNwA0cM87YdHFxGhp
 UBRKQZ6Q
 P6RfvRfiAioR2tm/vfmOc7JtpgL4jLG42a1TQ8IisMjcRFLoe9SpMzbqdN+Zr5s4uYZpdhnA/qd0ioRuwkfIvuGCVcnPoY068xMV1Xg6UWzudFys+XMuCKt2HZzsRbqBOwyTR9mbxo9rkO0pUpyM5ir7+5Pebn6q1T758JzGXy+9SWmliPfL6KXBYVFTl0sW8opy6Tj869eOXOutTeutCLiyAdPmmyXBNA3ulIlL1G1O4J1E303/Fi+bS0lqPR03AoZoH6kovL9nly1jf43BQZ4UbIIB6MQtJVUW/O+iHnLEa0VMhPmtf/1PYE5+MPFw10tf3mfk3cR4uwT5UiQoN6P/B9sJehFE7Z/Y90vzNHmsEKBCE/5mjkd3OrE/QPqfDCJr4tQ62aRdYM47dGFkjqV6/9c/QhobUXFW3jE0CjTdapuqNBhI8fRfamSwzMDv9xOk8Y6M+rjM3AQiLGu08Q5uAK39z+nrFXGbRRhqk/rFPy6WTiWT4ljD/Ua+OK0j4s2j3NQ0q4YhvKTxqLlAkBv3Xgl5OwDJv4rcp0JYjggzUUmP7fleZWLSgMHfaTdSz1TUS1wiMWoUFWpW06qo7f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> This file implements code for the interval trees used by the file and anon
> rmap implementation, so belongs in the rmap section.
> 
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3e535ca4bef..ef168b583325 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17208,6 +17208,7 @@ R:	Lance Yang <lance.yang@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/rmap.h
> +F:	mm/interval_tree.c
>  F:	mm/page_vma_mapped.c
>  F:	mm/rmap.c
>  F:	tools/testing/selftests/mm/rmap.c
> @@ -17313,7 +17314,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/trace/events/mmap.h
>  F:	fs/proc/task_mmu.c
>  F:	fs/proc/task_nommu.c
> -F:	mm/interval_tree.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
>  F:	mm/mmap.c
> 


