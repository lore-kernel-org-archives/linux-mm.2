Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436DFC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447276B00A6; Tue, 22 Sep 2026 13:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7A66B00A7; Tue, 22 Sep 2026 13:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0116B00A9; Tue, 22 Sep 2026 13:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F22246B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:14:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80A68A056E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:14:23 +0000 (UTC)
X-FDA: 85242046806.29.0DD35F7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id C9F7E80005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:14:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uyMUOZj6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NX/zBbYiidjPJrEoQH58NYVpJt9+159e/6s5cGOc9bc=;
	b=Ilv7Me33NpRQK2M12dxvMsxnO+/R3QqrdRpqNtnGcBtW++DTPO8M3IRGb+QzOH1zCyJh3k
	+gmnFRWwFVBP1UKPJ7uxcNAi/ZJE1p5cK2k8JCUEgtsVGlXw8y5k5S20+OHBdx4hkqqRTa
	Qyv3BdUl2Ui8wpY8ZX3tK81SjMYycz4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uyMUOZj6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097261;
	b=zdi4iOIDcPJ/Sj23xzeRWTveKWCNPoaqb80jOgC//R1yLl+mSo+5pxeLdivYs/PqDY3bG2
	6nY3PSUTZVsZIkapo/38SixjpfBN2xBUvvJ3UFmoVHpO7xS2xe2bAObCpzfEph0otuaUmH
	BbFKTgbu+OX1mi3icX18jhXMqBFDMqM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B61A1576;
	Tue, 22 Sep 2026 10:14:17 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D30003F86C;
	Tue, 22 Sep 2026 10:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097261; bh=m1/Zj1kl1r4NT70p2V5vARYiyafZNwoUEY016kfXI6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uyMUOZj6R5njDUnUE0WViDRG203+0ImQf8L3e4R3tvNeiQX8hthSWT3MmAozquZCC
	 MtaevHRyysWE/QOR2DnQlqNWb2SZ0tKdXvT/wq71vEr+9CY6J3c/VDmp9lE+PtmgLq
	 I6LApZTWohZd2n0AKddZqBwhz/kVnU82kKMdtcjU=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:34 +0100
Subject: [PATCH v3 6/9] mm: add hw_pte_val for HW PTE storage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-6-5670b8cb9059@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
In-Reply-To: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
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
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
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
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
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
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev, 
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: sd3nr7p1htz7n1x658wyzg6oj3up8m79
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9F7E80005
X-HE-Tag: 1790097261-533462
X-HE-Meta: U2FsdGVkX19CGx7psd5AVy9t9UTXYOdR+e1hjFu1VBYl5MvCxREGV3oQOBzz6LTxUL3iurWrZRCRswJwKYUY9Uyop0imnqZwY1eWBiofTkwk3xgDZL2JPRXD/qXvkmSftwNK+uVXLqIMLJeYZbN5/1FLOIE+r8Lq3b+GOSbuCA4uF4WO2iIliLRex1vm3RpOKjBL8t7ERWQHX9WcRwG+jaL2jtRczXY5uNEkOl4fSdHtUFsvq42LlBDT7zAFz2K3LK0U1TDmt5fQIieHNHMNdaKN+V2nNry5qsGPD/hG+C6OmH/Xk8XRTiA21h5lc33fcem3Ci1hWHAYTOTPgLnzEP8aJubhnOuOMwOcuQqpUyWT1QRdMnLdnhjgMaQVcTfok4qxjXDnXuXc3WSi8IZownSX4WYhUdJRYcrpx3U18aOFog8KGkB0avezRgy/elNkGhqqeOuqjJ+5jXroLoaPEW5oywDKlPs5ogbGL4aDgPgZOnB5lbK4O4h4uLsCEgwC8zYj05qIYmzacI0G7pgBBQ+nLIdv7utnR8zkk/qRVO3b0lyZqstw/pTWN9M2VgXs0+vXdYcYAa398aUtS5MFKakvy5b7h3HJDW1TPlk7nnJTtflcRShEhowgQhkr1IRLONMUPZWz/+2y69Sl5fPVqHipkLq58K0GjjBEF7dDMacOo0KBpD6HksJ9bi/pXpKXn9moNGU8WvNz9L9OzJUxhKT2uOQlOUUdhXhuDFCRb0UN98LPDIxfzNf4+L4A0MyvfJjAfUuuIiuOM5nBUvzV/i6wGrgeWI8nwbk6xYsDj4bH8zAzVhPNatRkjZkHvZSbQS9s+YUwV29RiJ7RXUhfJzEDSw3AOx2nVLpWUtF4fPLqreVUbDKunE2xq8mPX+Hzgw8tV6ApHGuqqJWD9vsIf85/7Bqst3Y0aysZtpeFcvlmy/9stspXORz/gOlQuMG+Hw+nxhSvt515ps1mwcJ
 1IIiqF75
 4zZW/zH/ULzkfkA2r0mSnWi+tTYpOemVTqRVpTLctIUarP8rEj0ACmmYtjNxNJN+zbTm31Jbp4Grg2z7ZEUsqkN3HdcyilDp371Y9w3Dzp7txvoGMgDWGfy4RiCEuFuIAIaRMGCUgEvsL+0yQf8UL/kRFVGBX1PyydvngUpgkVCfjkUDlCVLbxe/1upYxMmtDiS2Ufr8IM5CXlAScHyMIJdTHb6iC9yp/Cu7c8iqNMAa60lWUUaPKhsSM1NGB99XwHSwHSc2/hshOUH2bmat4wXPAYE17d+OayKtvPFxJgJN+zHfj4NLHt++zAixcVze1jZXofQ64hnaoLYbDsdSrH7ygynF7n55K5prmXWbylGfeA9S9JadY2pIxCyW089t6ies1tfuAN0wT85ABP4tnCT889rJPJ4lV21BblQfr9eAaHrbCqyhb5UAUhKzW0CpxGWoDfVDNuufQwkLCvSuUpEHnfTYsN0GHUc1JLLqDRhoF7dtB3Hkhd9deQvrAWDiyWbsIZ1MQCweijBAgxp86kmkIsm3gPNsKEyo+9ryiHhhOT9Xh/KjaS9ZcnQFmUNAd39Ou4OZh/clj/y/pvLjf+VqtB294nzgNMl7Ov0YhnSQ6nSs1hXPuj1wp5agFJns5TEdMTdKhleShbVd2gjm/xVy87NuSv4UlhdvuJipWUPAU9rOjpTDbCWtIWNAZfo11G1Y4Qg3/QuNtimGTFWTS6GDuvV4AevkMG5AspTeuNKE/aPrdjaAPIIzbkRg74ASHkis6I1siSca17oc2tqLmoAQMHIwaKrYpDoj3ggYdqO63XNeXqW3ynzg4AFCgssp1WYLZKxPBxdSduUD95eXJPvVBWO33GwPfrzgeZCKXpxzoXdhrF1aagJS7jc9tfbafqhObIOhlA2yRwdjLXWERvUv6vzUz155YJvdLRsBFxD2zWmPapNy7P5U4EwUoTy4DdCwBZRzTNhbQ2fwm6njHflqEQ6U9
 BZYzJh3F
 Cewug/gEFQgiZp/TF3SsaNi2MOghSfYbTFYSlNOus6KkHn7igkePd981jVRLJNGuXrs1sDGL/aJXbwhRVPzg969HaaqqMFX149DwNgYpETTQ3egOwKZt9ZRNloj+h0UOwJOd7zUAzfxOiBEnQnWVnqoViQyiq5KgvvzBgPQnR8dWsNsA572OvVfaoCy8aYFkqmyOnwp02yoHTOFX5KvVcad3HZQZif9yXd8B979m17Ry0f2ToBJVbdz0LpM0oKaerjaDqR4m11+kG0j4r3t8UZ/CfBImqR5/wV+I0WnScL3CzrSm9qijSmdIeW2Cdjhc6yA5pkOJy48q3UG35fpRBg8CHftMX1blXi/quHAPA2V4XLG3k2YqfTLO/TBh37wHDodIfG6HV55idVszG1dYtAUhEZBBK9b8YRTO8KaXvo/+R0EoPHtISmpCZWF9bWRtFy6lCa0DDGQJhzjjK9va7b/7aOJNfrf4BmXoeLTwOMpJMfjtfN96FkUyqwc9vWtf1UuSaH3GEaE5fOonZ2ki1XnCw0nHUoeqVlHnqh8bu8oSOxTk+OP90jBTk2kpyfcw2ioa1CrnvXqqMYluBL0DnWQmyVgtIKNiP9PvEymkmPqljR193FP7Tt5oiE5hvod8uQT5o+7d1AixVtBfP3wVIeHczLF7kB64TRxOXcK+doxAyYMdI83kVapiZwA9h/BpNOJpK5Eb375VNZWGZkjkgheaVHl7xnrq0le9CAtcV0w0edc032EwL7fi38RiAr9gNt7vhOtf9xnBlHHSdZLqGxzrD9SwfZqsmJA5ifiS9URzSTFi9RkGl0YdwwJdqh2iyDO7stM5KHt/MKLA7DejaaiDOBnFBVpb1eDuFaK87EGVKl767zgDOlE3PrIbGIeE55m6uPgLsstz7K8UBHzIUq9V2WBcDe+rMu9jrobK/qXBTqSrkoASBz8rbXrbsy6MOW9a2lJOhGpGHBdwqzhg0wPuS+WCg
 kxmdKbHJ
 s7TdsVK3k9LXCCCIAjbRv+1kwT37llsUi2YCBLh/mh1zOR5I9opfB47CCQE+KeV0xHKRUMLCcAdVrsf2iXrCGy5b8MBC0NvW3xU069cR4DAlFGVlOzryomh3kOi5T+bNy6KPU0vt22lP8rp0VhICE73+83/+TCHtJQ+UI45B7Pn0Tp+EAvHlgKeIXzp/Z2qtO9eEEftT8o/eL+WGEvBfe5/G/muw7D6RHghRskjkSBATREcJX8lpRRRg4Czo3YFBfZcYDZxEv4dEnCjivLibMgwGdiDs8TeaG8jnmRgihzG2SsVK15HoCytFT/qW1hGfVIpv3fUp6k0RsBOIj808L7xadIXwpL8zCaxtFJsm+ACqH1XwOawy/DEG7qAGHjRkdCTmBlQnMT+Q7AD6KyzQiIcu53ZyYc9reOPLQMJweJVThiH2sLwGSRqVkF9SatukhQ7gsIjz9qWUfcnvS3LlLIQTfMsJ6ST6QKQg/vSuY6gGnLvT2iHQgpNc+CZecCgyF7ag8C0VaNnyuq7hJIvMqGe8W4k7MPncopcoFyfg27S81uqG8BDVjPyKtMT18OewgHBM9p3BFOKldJpnZrsrrUS3zGcBKcbXGrzKVmFUp9io6sNmS01Majx1aou1vJy2Z32ha+LIBM/p7zG1OcVTmn1U+Use5A0xefFm69WHDzwpWpfNT/3A0+RUjj20B7+ONI2kEm+4LXEuzKf/g5NdSgHEHpPq/IjO4daeHg+dOgJ5gFlvyCw599ZrMEGcapjm0+2RYZajr0z0N8SCAfg3o9OXSy27/Htkj/RZI+irLjlRBQtBZbnyfq29he4KkB4wlQF5BgprCz6x72Wy/6XL9s6MpV5bfJtq0tsO7gebKWLjNcJlKMZKa1lphdtagPR9TUidL7fOVE3rh8XRaexsYI3kPvG3aUKwdMAFZLE1xzze6e3Fd7PcTkNYOxwtfAvjYmCUNFCT8aUAtTywga/6BFiJLehcx
 lW4U1oWH
 ZSmttfDTzR+PwOCXzUkwq0uPd/SSCLiEVTFVe01o/9n1SbKhAwt+cWZqNCsTKcWNxd7m7CP6K1LeFRw1DosM+QfcFFx4FE6eSpqHZuLcHizJDyDqSRPxcCseE+29Mc+JoEE8maz6eXOObM2iINnE2z3yXsEyTL30PCi5AUpNc9muNcm1niEADLYi40VSf5rI8VCzt13O4jPS6NNxwE0BdtnDQiGP+7MGlmRUNNGz2DPrVwNV/gBUvkQKaNzifut/JA0pVTbp+ezTvw9yU+E9J19//s55QvXkGqOcAvsi88xu19Pl+BpHirBP0cSq7NBShRKSNq4j+S75HBvBx37DPHqhccrWJmUSirG8U5f9fZtZDWKxKg0jRK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic PTE updates need an lvalue for the bits stored in an HW PTE.
pte_val() only accepts a SW PTE value, so it cannot operate directly on
a distinct hw_pte_t.

Add hw_pte_val() to expose the underlying pte_val() lvalue. Access the
wrapper's __pte member when hw_pte_t is distinct, and use pte_val()
directly when it remains an alias of pte_t.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes in v3:
- Moved from the arm64 series to generic series as it makes more sense
  to add this in generic with all other changes. Usually we only add
  code where its get used. But this whole series wouldn't get used
  until an arch started using HW PTEs.
---
 include/linux/pgtable_types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index d6c5a7548550b..ee4eace5c3e1c 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -9,9 +9,13 @@
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
 typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
 #define __pte_from_hw(pte)	((pte).__pte)
+
+#define hw_pte_val(x)  pte_val((x).__pte)
 #else
 #define hw_pte_t pte_t
 #define __pte_from_hw(pte)	(pte)
+
+#define hw_pte_val(x)  pte_val(x)
 #endif
 
 #endif /* !__ASSEMBLY__ */

-- 
2.47.3


