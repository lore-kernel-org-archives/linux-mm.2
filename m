Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D942CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A9C6B0095; Thu,  1 Oct 2026 07:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB2C6B0096; Thu,  1 Oct 2026 07:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C296B0098; Thu,  1 Oct 2026 07:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27F7F6B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:23:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 931191403A6
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:23:52 +0000 (UTC)
X-FDA: 85273822704.14.8933F07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB20340011
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:23:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4CPFslt;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790853830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kf6DGNVTAfNJlmV6n1mnXsg4ktNEvr3LbpOB3nxPaDE=;
	b=vprpzuOOYWiCLnka13ogmPdJj1naxbeEgmXTg9AKEgISe/BAu81TfyiPe4VVWxMyd6MeiW
	SFiYdMXB1HmATdGfL19noQAY9XpE7YtAm+wTr/UwQC83N0XTqMB85xlH/8znFBgQCW8R5c
	2vJMOGtkK44ZK3T6puwlH8RBBa9kR4Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4CPFslt;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790853830;
	b=EOj1tv1gTVSy5HKlQiURk/GNh+ZuPLNMb6PGqT0Xv5cpjwhOGQk1BRFq1ndlLpl2Oo6b9t
	bs2WC9hLgpA5oKSPMmBax4x3dQLgKFcT25DlJ8kWZ4/e4drSKHjqFBqaTlUn36pRaJHzTU
	cfY9Z5ZcCFn+dWRb7v3YCy9uZqlADzI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FAAF4062D;
	Thu,  1 Oct 2026 11:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA3E1F000FF;
	Thu,  1 Oct 2026 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790853829;
	bh=kf6DGNVTAfNJlmV6n1mnXsg4ktNEvr3LbpOB3nxPaDE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h4CPFsltJBUoB1HezA4bvarNWaCYFqBa9hBNxc+xCNO9nmfmhUT/wWKO5h1TlPXIc
	 GDcAHYvPrvXUUAdbanMCx0eH+gZVlMuBMNeu1sx6Mkedl4IpqYJoXRAvrhcsyv+r6m
	 RMOwLgwZt2tR6GpLFOAQOaF+G9JYEPfVrthsR+29KjdXDX9BD0jIpGaVMsh4wshd8/
	 1V9HgLQZNdCr5wRgqJ8ZKr2TgosbMOG52qE9tjBdGDKvkUBI6BT95ilyElZCxT2gq2
	 sTZn6z41rW5NtndnGGja5mbMNd0FQbRt4rsUAYkIglECZ5nHiJQcrjE0Gm51PZvf3T
	 wzXZdyJs8fI4A==
Message-ID: <f61c0ee3-0eb4-47c4-ac52-66b72764e242@kernel.org>
Date: Thu, 1 Oct 2026 13:20:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/9] mm/kasan: use hw_pte_t for the early shadow PTE
 table
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-7-5670b8cb9059@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922-pte0-v3-7-5670b8cb9059@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q5c57x88r5zm9d4cjk6cdo5jet3xr4ua
X-Rspamd-Queue-Id: BB20340011
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790853830-157227
X-HE-Meta: U2FsdGVkX1+s2KtrwXOOtDKSjnYa59sUsIdlRZHWvPhNjLf+rDlZUdV3uZvSXSdJiDQhEioN+LhRwog+TEM/x8YfpxEiiWRMEnkzEm95jmIPgKdKIQSoyr+DaAEgP3pQQ0EhRlAib51j1wWUi/tVD7m1hZOkTCE3RKu+x8rO+IWPGEtH4rjRaX8r4EainXScGnnPK0u7helUAWnjoVgwlRisJMfB1BGskadJfVEBgwKeWlqIH38tomBZfP7W0tu4l2ipnqTPphQTPSvHYuYOPJpw+/tWPyUNaBCVqXt7Yz9LiAE9C4kAPQGQS6wFZh57n3jM+ucHbh7rmOsty55ryytfQM8hmZKqbGR8r0pwGeRRV+XQQIdljz4bMFx+tYIOk0svsjRUbUoncWI6crFb+TBiX+pYVPM5lf53pFTQzXVKrOz3Fxih+2dWrabEh1XlSYYKy1naix2k0fG92Fae+Z8++pbBc772zBYcr0fbQSDYt6LP7suAtjMxn6m93cQb0/9Stj41r5jv7YRjrWlBAgv7pkQpMZmbiElgRYHNfhLU4c1AMig3IkCG3MgBjyNJHE5rQrmyBIbbglw/7wS3pUU7nwpr33M3A6ychpyRi+9LKCoPMxG/ss6GMRsLQ31mOGlKP0S5x+lY12ZYsWJCzSi1H48wewvUEHmMt0WHaxq3Dg8lvFfp7zq8xfdwLgfccnUmUTJ7pXXFyfHpXvKrfudckfz6Et8Zq03+cVVvm0N5DJve1+OI1Fol4TksValhf9pcLkAp0bDx72Ab4C12yx21dF1+A2j9XYuNlRWWhgp999TNdfR0IaPdnGZRdq3UAU5tBsVuh1g/XgrdAFlS3KqhUFkqz/J+rguzkFtpFi+NFo5vD8fhgGU7DokDhVsY/6LZCWbnUwybBYDvThnLWJWf2l3fTOg69AK23zh1RUkmvKW+WZz96WTu6vbw/RW4dCqimxn2bOHqasx2L6+
 4cdnZyH3
 RoWoa705dtKYB3LPGBkaJqZwJfbn88CUk5FA61xBmEkUKoyLJV8b3axrFRd9Kao71cXi4FPEs0ZaDp1Nu9xFGYhusV8mnLH24xUqLu3uEvGmz2UEB3x8ZZDfuYmpQ3Vs41AI4Xui1PNg5AAzVa/rORnoStxVHEG3/zxFwYJNLvKK+Os/cLyHlvTQoPd67BdnwJydUcxr4sCbGx1ZYd8rZnEZ9lPULQhqbj6EUIGZQJihi+tj7JtvrDj/FzkQiGC7UoqP7e2vzCHQFcxdpP/sdAHBieItNMnhHMxPAN8BpVbDlMh2Jp7XxP7wYnudAdZFI/I8h7f0JIBRUdqeHHGnuTqOaSnmY/jFqhLSH+BZpnWF14cL+GK4Pse8xgtG+ZuFnJTAgAL3mtyJD+ljMA/X8EnKBXrDvRtr/Z/efZG0LwXbZJnjBlgCsEpRfdPJuJizEl2SITJ2PtgIGdPQszr/DdUIZMsyXPMxgtm1xNA5wOXyTN+h7L94YCwkyGtopZ2RW4+wW83yTDhkoxYR70KqdnCV+gvtDsTnqaZ6oEWG1dk+wwhmU84gpNY9Uq8wNvPC3KwATH+iWf6d132gv4bWSU788wSMkPmwRdJLxfif8IJ5EmbNc3uYBte/yoWj03ZvcUGkTbaedt1QBcOycnf80031qE2lK3ilj5kJamLo+7OD+DjXwMvwZ3L0RyHQQ0NMNqHedIxJiowYFaFtPjKuJXScE4Pq13LWkC5PcJqHolrzs7CVkejgzAB14OTEVCWlZEJ2BLQr10M3B9VO5slZ4xYXIu+OQ+AEGEVU7Xqj8RY7Fbbvo6j4uXJphNzJQW45aFoCMnZZXtsbYfIKhfPYtVevzgx/kT8TvJxUI5c2NsIkHJ4A/qp8R5+CjhNj21PRMfkTvyNNsCkfOnSE3TK8EbnwmEprAvXJWOhhaed2h9hM0Bp5ofwtShyCvpByfXlmgwo4lIN0AuCmlcmvUnTPzJfxtmpe2
 oZFiOIgD
 mmIjB+Lc7QR2ituKe4wNcCYP4cYTX7a+zxfKssUM9idPqZTLvwUJ/hcyJC81lLyQi1SS2/UnXD6eIlFGrSzYmdrlvI4EvzrMI9WjZHY7AQick3QCdANXD1V92Ox+YzzeHM40DhHasZBUZ55naZmQSzvi/NCZnYPV1zfkniPiiUac5t4dtGJJ/NSGuwA8OIOHcPXZdd9bBQogMAs2Jq27DrXXnHVwAN8mJL4ZulgKCStMsZnQtf6RofdXneD9IFK6HNSlV7nq+0mnkBIya3uD/cFYXCVR3xUJ/nwF+7DhmSLQ9VybYanSeRBJjfiZGTzkMm7C81TayV7Z7W32b3IkJXyOBPsLyshJVm5tYvxy3A7henDjHcou+vIbN0TBJeT7QOupkx8U8N4jMogd+ZH5do3n/x7WpL9fn1cxZJg/0kKbwTaBxhH6MSF0HRYqEyTFgrrygpzU3RU12xeYilm0B20D+t2sgbMuwwsg4NRcdGY3sN3IXGrVOF2tMMlJXO1QpudiQoj3shPMOKUutjMaWm994nE6c5rue9WPWbhbcEJMNUOCupB3kkVx5MJZrKzLVD4INSGBJXp3vNgRobtsGQkhe/jipHDPiF7tutzpFc+hHm53N3/cZrlwixjowcpLtzzrHnfSfEoxdnh6ya5aY8GcBuWkT6sY8MteRcEILwNQfHyhx5YQ4iluW/8bAPkrHsd1jz9L3t+/lCip5Abv29JUARWQuqWBp75wFnBL4YTVhNM/waSVYlyrIo4CLaENFYOdHm5or3Dvcbw/x836h16PnCs69VzG/A/rCMpDzkNI1ICGmWUUNkrOekYeDiz0fLYYMLXlpe3/h3i4KNfLMNLiiLWmAMnCXCy0PteeagpZqRpty56CC/XVSU7WwHx79WyeFS823fiUW62KsQ07THJlHJMRk+EcGaC3rbdPVx9DMQQDn5oV99ywFdSWZ5BdCgBW7WVvm6kVC/iVvQpPmIEg5oncH
 UeC+OXfB
 45kFyEQqccJNaJ6T43ffx/3N3og7NndX3iV9M2AKNV9yt3P4tnZbZSd1hvu01+/Ul90zZQD+OcVLEf4JhgQ/g/itOtfAFjT8JRLBg1O1kJVeq7/Dj8FDIttWFHy5tINnm6sxRhh9iIugg7AK1e9NQOGJzHqzxEAtSrHKUtAEN+7J5jqa934QVxR3XiWxDyXc0lVkAem81pPpLkORg08DTdwOzPtJQ46V0bXQX6a/yglf+IlsL2ngnOGz2Cp/RMzwxC1nRrtFkTLGHLLfu+locNyK6a9QtzP4/TQYLkfvshIV+4IhcTB0RT4EsAsr7Xiuoj4czAoH675abggYSPiyvS+TWJ15fn1I7K6/rl2a4zIPKiViUpX2XjKF27Z8OcJ+gtA9cltcaYt2KgwwmXevQfCSBKnhGeeRTtOa4OOXG2ftN6k7ergbwUpxVJ/3tDZYrYxjmqI3kb1ORhi7Cnj8dWPNkrFYb/qvTy2ko2JB4VjJjOZ9rldwTee8aVS2e6cuIhZu+h1FMT44vg5w8jRLXFGzqdLO/JvHnvYJLnnhBOaHZ4hBOJyhNvhrN18T7bZytXKt0GvXrMsy23sU+eaiWlSt7RkTxDWGd5OncMz56XfDaILYUP2ZOaSPT8lS4kSoJP6uKDRWsVyZkuzwRX2Zpf0u6CKBoMUUPmDr9VhYeEOYbLphpb19tm05sMDyIi8X/D2xwftXEWd7FQ855IXYqH+oVDge4swpqprlsSMfC/p/yqYXLmHwyA3rcKiDi57BODm5MZ5vbD0LQQ4baCO3eDpbnIZ6ci3hWe737WGTMndHF+zMp99xivC7u9ApdUc6sZSKT+sw/OwaDQLUrEra8Q95iNDjrcOT23JqlP6jYE4azkmsSXhxTYuYGUWiIPHVi+KOeMGtny3bYHB+Hz5c0R2t4vy25JiWr5kmlGYnjXUtjdrenPCOAHp3grRwmrryAqhvvV0ioEhu9wcIUlTx2CI5hqZu6
 9rWawu9b
 ETFHTDJDF6U5PsAA0shumcLC6F6DP+VWCDOwshXyOVPbL1Eh52dgEDS6gxk5IsuSsD0QpMLH/RF6Tb2LL3GfJVqaF3IvRpAvfdwONcgeSVX7TcViouUFm7oKy+l5YLVFdDzor8nwmBpKjQ9upVuZ4ZD1zAnXO6T6ITJB9vnjPSg4f1h8EoxX6a2Xkl6Xc0xloxhJCObQMaHy/h9EaML3/CbnNOD/hLVo4jtT0gY/jx/kRmbGBEDppIo1rLA2FnXjAe2hE6oFsi2GQuG0hGiKP1Szg/gQUWgTwJSHdYMwQCvOINRl0MMHXUzGIUxhhZHr3XO2Sn1uXebAAqeh1+iVCkEnT6KGQ4iP8IW+iaUCHkk9f3se8wWQ1hBGWbs/V0BQ750XLjoIZOXBJMoYKJZAaAplHOSUHVECRRUphjazL9p5tH52eaoh4UUgaAaFxTBEBA2FfTrAagOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 19:12, Muhammad Usama Anjum wrote:
> kasan_early_shadow_pte is a complete PTE table rather than a software
> PTE value. Declare and define its elements as hw_pte_t so the object uses
> the PTE table storage type.
> 
> Read the first element through ptep_get(), which returns the software PTE
> value expected by note_page_pte(), instead of accessing hw_pte_t storage
> directly. This also uses the accessor selected by the architecture.
> 
> No architecture selects ARCH_HAS_HW_PTE_T at this point, so the storage
> representation remains unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

