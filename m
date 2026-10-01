Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C774CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959636B0098; Thu,  1 Oct 2026 07:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909616B0099; Thu,  1 Oct 2026 07:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1AB6B009B; Thu,  1 Oct 2026 07:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55ACC6B0098
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:26:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E61EDA03B0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:26:25 +0000 (UTC)
X-FDA: 85273829130.29.41C95E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1AB46100008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:26:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVCLDxeT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790853984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gpkw0FkXm2sEcS5oXM/km9M95p6Lr/sv8WQxRY54vDc=;
	b=WE0pInralhzTJ5pyhiSlPqrUZIc7x3Gzb+uVXJERCidN1J94LudlPSjG5DmvRFT+zUqe3/
	IdOgs+q8qmcDe1rRQPEQL3g+2UB7udvWErmkNwOu+se5kVXjMgP50hMmzc8sr8egPzW6ZK
	TB/NVhok2cTYHH55lYxT/gDQrXl29UM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVCLDxeT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790853984;
	b=27kxsJOvbnXT41cNFi9vdUHZe5iyrYN+v6yOvjz9f1/xaQVyDhOzpN5u/GRtlEavwwvG94
	quHXJwXlPCdyX+9Q65WZvH66smvXCjnH2VzATydiJM1YlaqcFqTdifBsQWOLQHR7mY52++
	liv/1BNwVPJJ4wKi1WxsKJydfJfXcNo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32301412BA;
	Thu,  1 Oct 2026 11:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD141F000FF;
	Thu,  1 Oct 2026 11:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790853983;
	bh=Gpkw0FkXm2sEcS5oXM/km9M95p6Lr/sv8WQxRY54vDc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NVCLDxeTK413A0ZVScuOliWCL/BeACZG41ga59YonpVi33x8PdZhsMtn/8oq+ygOX
	 ZKav51j3DB5hvxSALe8T+A85q01eQsw34pLNny1jJJ57fF2idAnltjr0LE9PQl0VtO
	 2EgWIzgB/LmAzc1XT/UYRxAbbgoVPexalg8KVzcWsDnpuRLWtkfE2p7YRoWrQHp6d6
	 Kpr9E/bjHpPeAud/sdVZeQRfNhP7XdrgducvsrOUBbVhR6XxxcX0rYUJMUmE+ipY0X
	 +8tC+AQSxR9a/ZEWQqt9Y7lkR9+EqYVsu+deESVKbABTftQ15M+EZ1nyBJoEfAoSbU
	 mz8vJo6ciRt9w==
Message-ID: <b3e226c7-0cbd-4989-937a-edd28cc62ab2@kernel.org>
Date: Thu, 1 Oct 2026 13:25:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] mm: use hw_pte_t for generic PTE table storage
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
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
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-3-5670b8cb9059@arm.com>
 <xzlxdkrjilskjcagnl33eed7ijxrgfhoalmmmq5ks3wgjmkkhi@zchtxpr2amff>
 <63db3469-82d0-4997-9bcf-31bb3aa59deb@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <63db3469-82d0-4997-9bcf-31bb3aa59deb@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4mt4fzt5bsdc5tadnokuituop443wiso
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1AB46100008
X-HE-Tag: 1790853983-741442
X-HE-Meta: U2FsdGVkX193gmh5z7ZkCvzV3Jx2sBYkzbu5HuX0Rep214GjlvoEzeRRb2AwzMbJu5JhGrBkLQ5jOQ3m1mA1bLnOU7k5b6DM6DGzkJa8IwlNHjJjD8inWDTmsCP8nQ49eHTRZaKXh2LrdRvp13mZDs8bUS5zAm4T8WcIZ9VtTsSqiDsyDy26b5UWV3LK3Ur7sM162WY54BbLVsu12jC4IrmQkFAkdhQh+Z/TuyqFFCcJZQ0W/LRvwdvXgouP4C/PdFas39R0XLjRbgIGhONq5TFDa3nN8huf0fGfjluvUJq/W7sUzldtpD2hRXgqyHI4S5a7lISQIUMG0ZtZtGIeFIjd3fmNiatQCyCGbaTumqStBDfTkpBPPrZGfVa7eKDn/WKChKnGHLoUSsJjdO6iAkZGSdW31XgEVaLKy3VJzrG4h6fsAC8/+iyxyE87/UuA2BOrYqnTlL0ojpMrbEuSdv0dm5bBvnW2UaAYHmU3Jzw8D0uzeC9aAD4hJ7YtO8T24Djz9+MMXI5/A8Kdxa8Yg8J6j2v7DBQ/YOTx1BIK5jwA8D7qDeTY0ZMyXZMvypMKvioi5h1LVYxOJ/i7VBkL2BdwEy3X1fpOM6X350hNsUyzeBvCfWD20/GH+63bS14WAHUrJAU+MjA1ICNSWG03V03Zwerlepbwa37j584hKZ250kkdUSdJ+w0FSr8hTa6RAPPn8itHRrBbQYAVwTpQ51sLNj0tZA7NbtoC8Sf41IQPqexfGwBmuEuqY9AoGkrw2IdwaRqbbJTbbiJ+eBXuXhNzpi/VL3g0fzm1C1OaRV+N2Fp2OWIauAvei54DGddvfepxqTDhL/Io9QGRmNlCFvabAbBBb4McZaye00rIyLjM7GsQHBmTUJsRDn1FeHP5HKP2yjgnsJvULYqXbHMIZKX2a0G1hP42Fw5p+nENJYC0+tzZow+qZTi+VvX0eHaY1QmOkj3G10bEk3ZxwVk
 HvCVgUFT
 sA4K5hBApBnQ4QkWBz6XaFcpVrPBLWICbVPYs/WuqWVpm7ea6KqKOvr+DS6qbBKz9ki5+M9GTJY1FqaiMBLIDyAdRMLU9BHDVXpiocHlIcp/YRWx2qXXyrbgWQplt1jdTucZcgUGLSDQaE0voaQI7UTjaa00XtS/g3v3gdwFaLI8w+J09BzU6MvxF5GFE6CZpGSVJ1KKNXbO/Lc79/EUoKSbQsu2rgZMvK1WyBYomGfdcnkNTO2uio0DgM0l30PVis7Sp1OXFY5qDhL0E9dG6o2mEtVYOUkMEgLroQk3xXdeeE9Ep6GfW96HLT2HUrkUv/GTGeUNPvUeNtkR/XpT7r2nP0tzxNw3rFcarFvMorTn00EnUaqPm9EjXyrx8/EjRlGGZkUD4K1kzrmc39WumsMYVEofS8HYSDgbQBXFk5rX9Woh0H03TGoLLKXlcaRHr3caEUYLBDkdu3yp7aTGTOdLp4yo11CuEuNcNz8rknBuMbR1FW+LyMvvu9cKqOPajfNFp/p5kGvRbojDf94chca29vUt0QSXnLLlMd0VMvaHL43tfw1uaHV230bfs2qe6vuw0U3HJTuQh0ne+WFOlS/0WIHfFnuCKkqVI/PnnD8ASNsTxZuR5nrsyEpljsI4t4ObRmXeS6Vf2NkWQ+BvvSqyIrv3t9Ea4mP+IiuaLTjIvVTMoibkdYQw7ewBMxGxTzQouQCPyf9leWXGMpziVhISSaZKCvyL4rHfCucD5riHQc25jaM+1iVrC1SEOwJ1xcXnYcAAkitLqlY/zpPxvX/PR4TBueKDkUFyVo0a1JYxlwABtmJ7qwF9Tb4Jvv7k7S7/PhA3AWua6SV7i/UIGe9pMP60E1ucW9e6RbeqHunUWjHHBLx++fJJnvG8wJFYeaTaDYSb1yS4c0+tlACOB5pbddDJnvUOvnaObbb90R/EW46DQg0z4RszE90R9VQPYuTpUEi0NISa+fntVqPCyXCHslvHm
 2ryKhVxy
 v8s1C31evtnWoaZE8mAkRxxpclSLHCWBII3iW9aEImq5ptitR30kB7Vv1BD8H4Bio1AbJBzkiijwG5wjn4Z7zpnWGivKvJHDz3B0UmHD0j2NkNBvER95o2wg3Il3pq+NLjtB3jLsmKQNO6ygifWo0cSxucqYUP7fkX0PKhIpbGp4peAoQsLO+jN9fCZ0EUFvuoJE8Bp4i0EjHkPqOUn3YnkbW1QrkgDPNzs7jHnqw7cHuo6crVhCXLf/IRomgcqtYsyI2mxH4dLBtrZtKdcfIfjdkgqcVTKZ1Bgf7bOy/yrzw1Pr83EYOgBzKaoD8zrCMM127lkB0iThKebETb+jok2FlRueMpwHopP5wA4OoozvZ8wqO9soxBHBA9THAiOzA7nM7GJzULyiOu/Op6zuadE217UDLCz5mYoV3soBqRfUuPWQIo/wXZcGoc05d5zzorm4CgGhay3x6d3515B3tFawdR4HN506+/SJnf7XmAXE/P1Ry8WYx7S+DFEGuSR3al7EFHBtaY2lHmO/T1oC5tbZ4S4ooLfM3jZABMO1XfzrS5AsJyVqfwdhy1JTWD2b+LTPrb6VA8jNSOhlEn5y/2HJU/b7SnSAyjbVnb+DqRC/WDqdG48kf3ne3FCrrXdD8EnxvgZeqxIJerx7sCcQzs5ng+RNOKMqb2ACET7zKL8rFdLy7j7rHvuCYfhbMQDfHv24P7uXHU2CJdnw5mLhLr4+z6nk5mLfPIU+WUrV6xG2bbXfPMw3tM2l0HbdiURBv7mat1uz2o3ezKmmLs6A0a6iE0ixmV5+Ip80vBHnIgFVhdCLczFIypG5GtLTb617TIx0PTocWWwrcnKjZr/4TIjkogrFRkjIWo8k2pAW0uOfeMxI3pO/ih6paf1OvkgpN07e4DBwTzeNJtVdCvLh1uDHiPyH5dzn6cbo/6ZYX4rT5fn195sjg8NwTipO0iM1u2PHJv/snukVbtzXwr89nMO8gA3MN
 NuS1oHFY
 P3P16qJo8wNC0rEr5HixJmwy2loq2Z5pDAlfP0aHoYFg5fqGjUXk8uVoIzGqIomi2toAsx4mTnLSnvGUfkt742Z1X9gfcrb6NhKTHeGCXl/5QJ/c/qtSEqg2gYZ39dOAeWS1o8aQjQ1lrRm9SOL1GXcOH2YEbQC+IT2BuggPAYyI+Qbw3MTKMmAbSiDH92lsJ7GS6JGdggyizLndzlXiYLN6VeOubTmomTDhf2xm0Cmdy3BVzJYuYIKuniWH2dLb+k/QJogwz2cFpD4NJ7lzTE3z+PJzpbEv5qh7/Qy7lfcIzI7t9ZWuu5l5OXp+RIgaVuoy0nDZ3lG2Qhx2uyTdpcP94JsOII/KtwWdPczRmW4rKc+gq2sZ3o1xSN5ONueUqS9MRY7ll9aIDRZXRmuL5fnCyTOFpPHC2i6ATFeNXXVe4MWxDQY8vV0a9/27/yC9Iy/EQzenVAWWUiTV8njt73MEEpX8zSEaBT4R67eqkDZviDmvJIbgADmGAdOEDIXuBoeYJEC++Do6yZLEC5R574um8gr5oUDtmYO7H/0SLfTf8pciC2inpF5YfK+tAVpVq8VHfTCzz69XbwbC5eXngGxMxlOqtIHwpXi0pbSx3harpvA5vBPl1/cMzj8kRiQN1cbYRua45XyiTse2/Xj5zYt1q75xXY5hVJgR1sTgoy8XZr5hB2vuOKaeMLst4wEV3nSbdXOzjMwNZhFWTf+rr6HBLeVr3SAG4UWwz60Coa7ROfi1lTKfF2gbQU1N24lRQ9uhDqgDe0cIci9VUeW87sORZhRFY+Vsc4eIc2FuDd7/sWPb9+imGicomjZB3/Xx+WelhEKb2hifFIw1le+KYDJ7JF5y7fJwdc1tGno5jKigRROGD7OXWTMe/V7Hly4I0in4xeKS3+8bkRZ+ziOve4o1SRDyCz9gI9fCQiuguol6FTd6a1goadoPwERuXWZto/dQ1iuw8pjyUfxIuGJed0lQHDqlj
 LXTUcy7v
 +3+mmb1afjDir3XBKfIYJi9oxE8c4ApTh5ehfpw18DJcTnx60LGipJA24N/+uoTqhoJ27QJSGkqXHJZMclGiCZ1ApPxsHVanC5fpu9QWWOPo3rDNLxjA/sqnngE65/zVhuYxu4gUjjzxoxjhagaD912FCHaviNM76d8DaoZ+6Lcr/nxdospBehDNMe9gVqLtIPvIQq4R5pKU0NLPQ3X/rUTQeboUmXmn7bZbtPHM5CHyVB/1kfOxX8uPZ1muYU913ZP/FAvHplv2bHoWGI/umxej4ZAHc+TPEXgAmnN7U5eOcIhTEHoFQBSwHY+sdcG8KOr0+zSp7FSx3ExZ9HRTXYMPkZj2TjAxyHgbddqQzxxlroTEyH9iuJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 19:40, Muhammad Usama Anjum wrote:
> On 30/09/2026 5:35 am, Anshuman Khandual wrote:
>> On Tue, Sep 22, 2026 at 06:12:31PM +0100, Muhammad Usama Anjum wrote:
>>> Generic page-table interfaces use pte_t * for both pointers to PTE table
>>> storage and pointers to software PTE values. Convert the generic
>>> declarations and their MM, fs, and kernel users together so parameters,
>>> return types, callbacks, and local pointers that designate table storage
>>> use hw_pte_t *.
>>>
>>> Include linux/pgtable_types.h from headers that expose the converted
>>> interfaces. It continues to provide pgprot_t to vmalloc.h through
>>> asm/page.h.
>>>
>>> Keep software PTE values as pte_t and retain pte_t * for value interfaces.
>>>
>>> No architecture selects ARCH_HAS_HW_PTE_T at this point, so hw_pte_t
>>> remains an alias of pte_t and this changes the interface vocabulary without
>>> changing representation or behavior.
>>>
>>> Most of this mechanical conversion was generated with the Coccinelle script
>>> included in the cover letter. The script deliberately ignores pte_t *
>>
>> Just wondering - should this Coccinelle script that converted all these
>> instances be saved inside ./scripts/coccinelle/ for future referene.
> 
> Thanks for the suggestion. This script was written for this one-time conversion
> and requires manual review to distinguish HW PTE table pointers from SW PTE
> pointers. After the conversion, it would not be useful.
> (Maybe other arch can use it to do their conversion. But they can always
> copy script from the series)

Agreed, the script is not expected to be reused once merged. Which is different
to other conversions where the old way of doing it can silently sneak in again.

-- 
Cheers,

David

