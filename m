Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F83DC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D886B00A9; Tue, 22 Sep 2026 13:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC486B00AA; Tue, 22 Sep 2026 13:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BBAB6B00AB; Tue, 22 Sep 2026 13:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22DB36B00A9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:14:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B2EFA05A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:14:37 +0000 (UTC)
X-FDA: 85242047394.25.26D6C09
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id CBA5C180011
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:14:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iARAx8Qy;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwHPtv+G9sPU/JOKCHw0suztSDcVFeRdH6VPHXGQUXw=;
	b=Cv1JRTqucZs9feZ3yFHwNUJJXNGJxmAM7LXllIb8p7uFNuNV0RSkgnPKremTUkHbxaDNTf
	Odpsav497Ba0LQGF3yQqQQ45w3HD+KthV85ek3lVuLamVaoE0kc6cYCGCpI4QMzZXQloiO
	DwHBh+nUyiku+M+qwiDdgLqJBi3uDR4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iARAx8Qy;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097275;
	b=sqpYYM1mpig9w1/Z9JUXSxRWmLxWHihyhuL0m3+bX+alJ/WTd0fkTGbqZ3DVuXG4UU/Cq3
	4C1+XAId+e5l6W/9v1767jYiE6K+D0bvwbmO/gTveC0lo+iXPJq3qK9EiEtvJeSVWjZLX7
	YMAtSlggvopqGit+82wRWtPkOm8rVlM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78D071595;
	Tue, 22 Sep 2026 10:14:31 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50FAF3FA32;
	Tue, 22 Sep 2026 10:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097275; bh=SNK4rrwFvjnxcdknL2hsc20bUzMvwr6CIipWYMszSzs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iARAx8Qyk1413VBr4PC7dGwIhlrToaTnagZ6dPlvezmqEddDjaVkHLgBTgS5wWhxt
	 NG3MjS+xmLq1vZyn83oVsYzSt8u9iMTTXB3k+0eeRFDj4F3gou8popZy7lpyXeDKr4
	 SHUdvtaZmDDnMdNPXUZnhs8extIVv21cyFM4/8oM=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:35 +0100
Subject: [PATCH v3 7/9] mm/kasan: use hw_pte_t for the early shadow PTE
 table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-7-5670b8cb9059@arm.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBA5C180011
X-Stat-Signature: 3afcjuu9rmptuzr31j8bij85b3byam9n
X-HE-Tag: 1790097275-566791
X-HE-Meta: U2FsdGVkX1/+4Z6QPeKwVgtAx9uiGyuYvROr2/W6gfxkJuiRrxNDm7FR0ohahy6WtP5D3KRa/QBFyN0eUA+rjLgfs8MMxfL0XzLh+R/Gfx09n+RZwGZzz5DYnUHeWjbT9oDXwhjdNocXtCWRIGuazKxVIMcX/x2VFmLBHhdF0L3pCMpykuY9uCXiZtyFBQFA1aG7SqxyhMPc2Rh5gk8NajxF0UUEnuQNXlo6qU9sHKytZcQ8ElFrl0cxyoZn2FOWLtt6/bKKUr6IMqgMrsoCwk8u24LmrghrcE5PigwpDS+YFwKKfWIAZhOB7h60812rdIe5DCUQpe2oVlNRjpJV5oLIs0NlSx9jxa5E+QoSlCe3h5Kdo72tFFYE+K3kisn3EfOLISuu74WNnq4ZCkHizKBxZBU6BefY3HjqjONmNwfTisv6B8fzlORCvC787YefMC2MdoeBRGCx4AiaEr3q5xa6QJUfDtnS4vdIkiFQK8oOCmLOQipkm4vC9OtqxUG8Mj+yP9deusVMX0XhirZgmeT+WsGShddQLDlfiPjAZ8jyp9O2rM3PQAr8vkwTomsv8BaL5p4j9J0GQBTFYOflpxmoVIrCCNNeCNehCc+Go5eJjPCKKAmpLlEfzGJ1/86TOghYRnlLcGXmLJ1639SCKABHnHy6ALJPK/kmqKAYVX7wc1Hc9nUZA8g5germBvNjRqzJOY5Ad+xcp9J5YpAUNOtA9a6Y/5Kl0+kbSHOzqVPVhMVBXoVc4E3Wij/3g05KmAs5ZL4McIvfhi9yf+SHqhNN26NNOVlbV90J5rJDwWiEtguPQVWusYlYL2Lt30In20BhzT+X+3FRaFV4/q96d8G2ApSCgjrJBDdNBrZcrLXWJa+QUkKhdCo0la7P30DDxSArqQ6nwf3EZXQU/guOsvuFycBRR74lxGoTGLf/GWCzjBRvI2cu6jLbCG3JZpVQSHC8skBefkiX1KNKpZg
 5NpRoHS7
 mjNaZwNM4rkn2bGVUWovzlpcMKdgD3qos+7hY1EyH8CIuHpMQgMlRxZl26JlW0WqMy8pmunWdKx7+KHXmpVRdSlZEEV/9e+qp0u6K4IB3hwi9fhMotmjme0Fwk9F1tsG9kxiw7Q6D7qysf1inucIbQsYDT/PIsjQ6+G84XIco46KDWO6qZLUfShdOyLKelirGbOVKeh437kyx/piV4LZwuzBBSoO+HbJMVOKbrgjkloIt9xnROLy2L6PmXptiwNeai+yhBh5Ep8fo+hFCVVbg6wGtvx1B0okhrXlX+tewaW+Mwrgseky/7nwTtAatCGgq5A7KEvQbjbOhU/WlIR7MtkugazVjUH1dw5b/B6n6V2XOcIW9qVKOPDmwtBQJtykTs9FlqSh+JdZ4HnTMi6q6LNq5CyrjzJ/LjJafBFhKm/BFmiKBu6+pbzguDpn25SqW7/nT4TEH5kxie7oVZB9Z42tpRCqyON2E2clWrpFFP1Wm6QVXI27tLD5jiogWbDyOaF4NqSylfMBRlo9r2+HcQ/cKaHJpf09dpt0cprTL2bL3KMdDbdj7nILEd6fMHWyTwS9H1Cf9rSiSi6ZYsA6NeHUaUb8cW2vAFDyiotrgqD4CuTxIx5cv9yFTQPrDRHfZSPcVi2KUuWt6oqeZf7B+MgbkF/H0wo9Pa3IFW+QqBoh4UAhPUai6aas0aITfZ42Kv9C7XRbHgkN+7lIb5kBH6MJ0+H2ExqyC7mxBiNLcwCHgZdtt0/PweSnbYrQt+AtjQDjJp0GX1m3AsVlRLm00Z4YifK1PJzvY2t+IFVTYV45t3JHGxqJjN6HrE9TUlq4tZY+4VEzE4ecK/e3TCqlcuj4uXAnjt+O+8B8SZs3GCi8KXhI2sNU6oESYCYwg20rkeJ00IUDj22uaqPHEIGYaj1G0OWWyk7L9JhhGKvqspa07OFD7++Bv/IchXJQscbSWErGtjwpIXZ4KWGdk9DMvqTgDQ6uy
 /mvWeGKH
 B3USJ0xBrfD7wz1nwk6j0f9FinOxAYGhG0i/1r7QF8wriurkWrwKioRb9gyMMeSt6pMophraWWHddRMhWERGGjlzZVmG1WkTU0wxP+spiS/w18JA6QPyIjWLPAWm6zQZ2W+ACCNZapJKig5uxhK0pJ+kv8rKUY1ZqxqgeI97eBC+1BCQRRf3bivJutcF8mn+9mT85kQstDuPqlE9Jw+tJlUvao0k7NdX4/tZ/gZXmZAFgsHCwp7C15Kj/cBbzvxdCYHY0/CT2LTE1TgEgcSg5o7TYivgRQN1r2TcPi0ZBH99UKMEq2OYEAoI0bM1oROdg5iHPUbuON0gKE8gqAU5qmIf6gqHvZGtpp4t/nL0MJh7ScpbbkeZ9z9C6XrFZLHzI5KcWP7OulfVKZga5Iin7Pi3Ky1H0kMVX5SNGTxzzf8LTE8N9RwlnosstCpbkpUrO68HyTL5auYHXgV4Z9iuvbWoGmP6NnkoB5B7Wl3I7pv5Yie4NxSRrr7E2isR4CrXy6Joo/ON3vizoNzco9aE5+eA18GvbwXn0ies4m5smAntiwDAKtbj2oasUVeZzR01z94EkmkiBDP3yy/vLL18+RA2+WLU+3cU0m6S+/ULnEnZmto6xpfoyOjdq9QBX5jPCutZJ97SW2QRfGj6ITNdKXx1wiJ31oEpUqkWTrvQt7eI5aTG/5JGUw6eSKzZQLVudX2SdOxRIEEXfzkW9NADvwxwhEwlOnYU9R4sREardMnybc/TRMl6muv6CMecP3A/ig0o/WbWkcMNG9cbYW9yMEseMKpXRxO/KFYWFkmG73+rrJPx5NMi5Ie7p39SN806VdXIMW/u0p1a7lj4v+2cdcMyrs3caO0jKesw8pPQ+tuUp1UtAnYgPjUSQAFk32JZFncRI3RulY1a1NQjXJ8cj32dWCbWyKV0Hx9J2DonmhWMcVSsu3jJnBxr/DYn+IghTWudv365vNNgFSyXAFbxjwXu1kp7u
 L0ZnZHPu
 /ffD+QY/USomQIReVq1v833evNT+4rwMihsXon9rqfW01pFVtzKV8UADsToF6jNUcTrQz+3hthqSjsrKHrstmWLRLmWVgVYAVXFB0NvY/WYwfcqSBNsmv3Vw3nmOax2CR4x1kfpTlrIZJkFja/JCpyOykaiFhzIS07lJXABupe0hofdfoQzdQkqxA8FGYtIBme9Dytldd1rJosBcHLBK6e4Z9D3V82jMENmBCat2co03dTnwawitOUG+C1EtYk9mgFgIWhFUeypBBV0ZSw4rF7X5ePqFm4cx9mQuoxI95t7IT1UNOTzDvuO1wWpK0fU7XrByDkBCw6M+V/3gJ6Wag4rW6k0N6mj7NRBqILS0N2JBiKy3affl5x8re0DNk2+ex3P8/el9AAGOuVaVw8gPqcnhe/wlcFjaQVeJYeRBI5W9O5PPh0uAvGt/FS0zmi3TZFC9JycL4O5j4at0RnVlIjehzN+AodsFJwONVIWdna/waZs7yaz1zFpZ5Ax92o+QbIiKBXmyoYHJT/5JbG0v/o6wd/VoPgThTO1gBAtRs2m5qy67raAqg1l6hcLHCWjt4TtH2+LXVXW4w8yxpYNEt+jKOg7qwi0yzhID72RPt0z6RiNsZLifGnRmIgIwR3mcu0bb1VWCF2uxmmQrAp0VLtKK9ZCZ7opDevlQ//4dRVvUZqGiRG3OVbIR8pXp4s05l3QtaYyWMW5ehkrToclnquEQVx8tD/Hq4T4DpjMzPO/ZFUOJfVs7t5Dl9Myv+IrzJ1XScTOc0sZVP1s0qcAS4/ACv9URjeJqswJYufAEpE4K8oiwfa/GyAQ/47WxShCzpWmiAU0vXTivO52i/RksjhbtZU3snr8YDJhLP72ksbeq0e2jvbI/0Bt9/3QPJsL+nlL5/MhXgy11IzqzA2/Hy09pROV7gq2eQwvj4iCX8RnWpEeD/Q7APQQgFRK0Iw1UROI4ru12ihEdoH+7Z+j69MMjQD9mP
 FOjhQAVO
 /6yUwHSluXQqO+SC/KUvtl/9iT9VC6cW5oaXFm27HB6/ogPiFlZ9O8Ws3ZhMWunp2LXAqMUvh8I0vkrk0hCQ72WR0HE2d4ao9hrXBxBDAiy+ajNEcMFOjq97PYeSo9tNXcvM10H8ZnABjnPtdyk+FKQ9mxpp7DazEF7Thx6X73n5mv4NWR8a85mQ6MPLnjlhIdDG0qBzpyxmi+YF/zHPtOdQ9iHC7nxgUrkgbyZi1qniKihuYXw6Aoc+It2FPq8Dnv6Ka4BzxDkR8/ErUQ+4xR105x7QJT/nWSaA5yl9rUEkHrHb0HdYrF3xXfSakwHFGnG7eyH+T57A6fzGsrcXm2/AARzwXQsAcsC0QvivogCEb6fe9MBjGN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_early_shadow_pte is a complete PTE table rather than a software
PTE value. Declare and define its elements as hw_pte_t so the object uses
the PTE table storage type.

Read the first element through ptep_get(), which returns the software PTE
value expected by note_page_pte(), instead of accessing hw_pte_t storage
directly. This also uses the accessor selected by the architecture.

No architecture selects ARCH_HAS_HW_PTE_T at this point, so the storage
representation remains unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Use software PTE value terminology.

Changes since RFC v1:
- Update the description for the architecture opt-in model.
---
 include/linux/kasan.h | 2 +-
 mm/kasan/init.c       | 2 +-
 mm/ptdump.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7e..ff41949c0ac08 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -51,7 +51,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 #endif
 
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
-extern pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS];
+extern hw_pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS];
 extern pmd_t kasan_early_shadow_pmd[MAX_PTRS_PER_PMD];
 extern pud_t kasan_early_shadow_pud[MAX_PTRS_PER_PUD];
 extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index 30c5266eaf37e..9bbc2a41d23f0 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -64,7 +64,7 @@ static inline bool kasan_pmd_table(pud_t pud)
 	return false;
 }
 #endif
-pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
+hw_pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
 	__bss_pgtbl;
 
 static inline bool kasan_pte_table(pmd_t pmd)
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 376880071ca2a..8f19f20be3c44 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -19,7 +19,7 @@ static inline int note_kasan_page_table(struct mm_walk *walk,
 {
 	struct ptdump_state *st = walk->private;
 
-	st->note_page_pte(st, addr, kasan_early_shadow_pte[0]);
+	st->note_page_pte(st, addr, ptep_get(kasan_early_shadow_pte));
 
 	walk->action = ACTION_CONTINUE;
 

-- 
2.47.3


