Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF429C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF366B00A1; Tue, 22 Sep 2026 13:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FBF6B00A2; Tue, 22 Sep 2026 13:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B596B00A4; Tue, 22 Sep 2026 13:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 438036B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:13:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94D9E80599
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:44 +0000 (UTC)
X-FDA: 85242045168.22.A6EC9DC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 596BB20003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rlnn6dN8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BUnhdOOe6jTG6aBGj7HgRLlnRN28zR51cwYEfOfrbA=;
	b=hqE+zqSAGVjNU+K5NSgeATmt1g1/nQ6FHw2uurvOzQlUodlMs5FJjdvY+9PHg4k2dkrW8K
	v+G5oSKi9cV5+WixWiHDVt9Pl0YfD1S9P9FVkV2EXCp1twTklcx1pCs7APr40uf/fO3VHc
	czfP/nEIu4k6UUCKXWJjDS/EpqHtzRI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rlnn6dN8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097222;
	b=sbMrKaXpPTNbLMudSn3d3hOSG9AB0Y5zBFN2lzLrwgbBlPRMuVYTOQJqw7UnlmNMvDFp8o
	Sul2ZPY69DXMM5Grmp9OXPnoIYmy8ZN9hVpvCekBeNGyeqNaUpHbGyTSgidu9bo3pVwfof
	kvm0BYL6Xx0TNcNZFLDNm4UlOdU3BEs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0295A1BF7;
	Tue, 22 Sep 2026 10:13:38 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 804793F86C;
	Tue, 22 Sep 2026 10:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097221; bh=hbwpI1dfxzJNivW5/jfGidrrhQka72LMuk6he+tRNFY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rlnn6dN81q5UsLnf0ndk9eP+OGv+uyvqliAMX/KrwbrZBWlSh+5kBxFv4qrSN3CbE
	 peraBVOlk2zYlQZssADeevlNFjj8cVmRfWLPOcsLCB1B32kuHpvd4k0G8nTXKVzyzy
	 EONfL4uyPEHRLzBGtiBjkloydqkhhe5hD3CplMO0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:31 +0100
Subject: [PATCH v3 3/9] mm: use hw_pte_t for generic PTE table storage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-3-5670b8cb9059@arm.com>
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
X-Rspamd-Queue-Id: 596BB20003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sjdrk4ne63jg8qmbm79qfecz7u8z4eap
X-HE-Tag: 1790097222-290792
X-HE-Meta: U2FsdGVkX1+0s+OiOkJoeDC63cOLUlk+D8kxATlKMSKpQ+trl/xCSAG0+T3pPFrwVsNZePsuy46kE6fnefVrYnltYf00NdER/3aDQLWsQ/1iKR32EcheYVExDaw0/rpBEHAYR/Um4IDq6iVCwGKlJRwz8cvobXBAP3KIEg1HpuT6vq4EFG5NIvynM1hwcbbggtPRBH5ZdKcJ7MyIRWWIchBRzTfxeUke5keLpO9RPFprNNRZqRWTOtUEm9QPIij139h3QI+x+0YekEQv35En4fkw2V6A5gRGdUlEUt6V8RYjjNM82dxYOG/uO7HWX5ecHpoLhiw8WEjmesIrRSJJWcOoLsfO9FhlDBokjZB/fC+SK5bNmS2KVS2sO0aMUPtRUHUqaRnuScsHE3faKb42EHhFTOsp/nz0oC1YJTFSERIfJ5pc1uOoNXEeQTl+6W/9m3XFp6JrcSc4VZVSyHMk9Btx/RwVahpFedaG3IzVVIDYfjpP19t1jyyhLTn0GB3rcALMxriF7EjdelUKDKlQtVkCZciYIkbt9Tb9QFbdRxbxkgMVvczmnfYTS5ER3xlY3+JWVPFOjgfM+I+LkncfhgV7/dU1+Jr8rhzSbL/7KFPpv2+kN22TZZU9xRYsey8rJhtD5188k3JJHHbQ0oEhwxOhdh/zyM94g6UGXHvFGqdbw2zkRhtUpT++wvz3vqc/QI663yD+IVOmqYMxL02PVARwwtQq/NIc0Lq/0ArAumBwqz3w/RPiPt16M2nIQJVFDU/UEDZOqjlFdfr/Mx7qrRms/R5iTwEmE0ddj/Oy7IkBZpZxAE98rvSTtYInma14Jv0fL2AieMFKU33+cvu3iTK7ZzGhDPfRwDmVtrW192jl4CwiB7YOUWCWw5sPJr3r/hNgdSMhVe4mcX6l5hHeEio2hx1zoY8chA86VoYot0E4XImXdG590ewoZw/29bcBpbJyI9Mz+QCSr0XB18D
 cWNMARrB
 zyfi8NeXMYIg/PWAR+vQzrg/2torQuwlenVJgmD4Tdr75s9emIhz5u9Mf6x4isJXN2oyV7HWVQIOvg0teEgbU63vZr6msXQWOUYvwzkvubc0hHtWI5al+ja4eCRFKfXIyt8mStjGBbKLGFT2ooiz2ik4hLbSvvI/QImbhjVRiJwauaUiF/qz7pBjWPINb1jBPIW/3pH3Z+b2NRfX4fV0P8wprhS2/A3cqqFzfRXX/KCL8I7QMFbO8ZX+E5vjFGioNVUW/NKmnt46fbUtyAmlN3LelGeqslUI7LhwJd/1F1zjT+oixhAROuu8vLfZGYJ+8hDZzvyZkABMTQXkn4jcoIJtA0/T9lNGzGDHcMSTU/lvSJlaoSsCjpc9M9N3jruxuo8JBL+QDkPRlmDwKrHGA1aKD5wZa/H/mZS4FNzEzoLFmaV3PMf9hapyQ6Gym4aPI/9tBmgshgXkur7m3QdllQAGhxkFQPboDBlDWsgsXcBWAQumAtR4DKtcf8MPe8ZWxM+9HFbMo9OmNeYumagbc+kg3qcNA6s9OezLOScda4/FaQO35DdFT0kK1oOAruM+2k1PP9xSFFOY6T3oFBZJwxqeAVFMJMYCf56pVh2zViDv/khB8a3IHyzwXMNSJ2v/z9LNNQI4tVFFAFs2zNCL6NKPzNXEFexAqR80/BEYdWiQwvE2eD0p4GGkgD1zWuuoi1N1+4cCgYBw3DndP4j+EjFyzDifWZtnRvszr86SvAvpSFizcZKT+CdndDO7JCi+kVC3p7ABk1ntljMfBQpN+cY9yMbxkIh4eNbl04agazhmuUOurNRoNlP4jfXsHgB+hzRPOIMxIfPuW+BeJzn9h55mu+apk/dz5irIEMtmTA5uflf+X9ateoKgg33UftwjqewgGr9xtW4ksBLQ9QxQphsQa2/wB9Fojd6/sPLdQDMNUJnW8VfZV0dPWsmjJvqXXUzIL6GLJEAcd8nLA2gAQZYq51m0c
 YD0+6lOJ
 dvxak/Z9GnYtciVJy5XrLrwfL7o6JwlDEoj9nFKrM/L+txpmCygiidLzMUqZvVlSGFqM7ygd7kML1zfdiUUZxsq5RsGU7oTnanV4rCEFncna/4UX04yPEM2grkJXaUapPrVJfksn37jsH/hwk4n55Tn/wNiE0u7uYNjahm6wllheLiOtV699TAv6FcNb3uldKHDC9n2UHHQml2x0tVreM2CTGRexyk1ajwwq/OovFcNVRJsWSGE4mKLnVqEB5st0en1G68lxJ8NY+XTaRDcn7dp43fY/fYBoZdoGzzRxXApxrcr/2mVmAKJbvBVADUQAIRiZ7VAIdlb/Gd1HpHZM47kuW461H1DGLUNDCAPKEYyR0k/eGd8m9i+tJvjqsLhEDeLqtjb31x1UEWaCUeIxSk0iQnmxpuHDF/i6/6a2oTghz6x22EJkqS2gJhUtgcyEjRzWpPetzdKG2lAXTWWSMo569bK3MuIxPMJfaH7Agm1CT+9lSfCvbD7RagWmJtw6EyBA8Qav1IBXtyxkIciRP0UofHb7Tdr3IT/uRLCdHjP66ESZo/4NRZGYxfeF9p6HpPOmK7Kvj9/i4/PZk1fvZpKu1219n+jhnTtzsslQIw4MuP2cUwgnSvJgwR/RN1dWxYjPtflWFhrNLJmWgSsSVh7N9PBiIBL3GjHIFh6yuqpk1AWDJw7zbBsWu09/r6QLbYMtzrFt9edr3O0iGiaaSN5OU8QMjhyzX3Z4HSVzYi+kdtS+MeyJYoosHeC9iUT2Ac4HZDbS18+JmbGNF1/9NDCx/POvZZ7S40t/xndhIkbjaMGz3zZIW/xuo5h08++f0bGMT8NkS+qHteRWFiqcJh5Z9wdVj4xxJ+oFAMI71jbNbKw19VhKqhGW9bI8tjTw1GDsMw2/PSACmy99xTv1acgu2rbNKPXrNq8KfOtPu6XLl5IPamchI4y9cZ+3m8aGzgWu92Sbi5tQFa58ERbjqqRUYz8ob
 XAwSeW8Y
 7OLlgzNelppe6tOOQ5v+PtrdrJlDDguqoH3pcj7BWisSu3inh8WaeNVBeO/JsNCwMoqATEvxY/PTdBe4c0zt3Y3oPBB2RPFo7Em5cnVRsmdszsUJbs1BG5GVn58Sx2OXvhUvf28rghgbzcrJDzZa2a4XF2pYQ7eibRUYop8iU525SnGHyaRmES0T4efmFtSwp63irO+lZmSQLG11M0VZjdZNi8XEYNxib7xR0aAhwPzjeJYNgnNoMlc9Wrod32Dav4e/DwC6Y8JskgwqPyaj6r/7vmCpWuUuvdTxhKrc5J/mqp5qVwcTG4mQVT6mUGJQgnuWkUIfhb1cFWuodaxowvu2e57arpsQiL0VgGVgvB2YmfLcysv+7firLCnkDBdPtnXs0Gre03YqctDJKjFQUBE6WUh+IO3JGptZJIXeUYt98iLwivpRsUoawYu0JrCR/UXqTdWsIYR773KdBAUCoT2cTy/c1R3UhXKqIicFZwRdabyoV8L5IviLGB+U8WJjEvKDyYXyl+7iTavQzfAvuza6yn3rP3UyyFD8GWcHRYfIwF6oNTvxlJNxkUhi1cUkhsskm9xThkDUOsmzxubMGZO4U0ObrPLZOXwTqqj3z3ghoYist3nhLacg8ILLn1WIl0tMM6DehEa8aUNbiKVb5yp+1x8B3VDGYIGDWIQkgbrkjnxoWsPMMEbLcx0QOWa6ZkAsld4Xg9WuDY1i/tCKLZDEJJQhsuEUmtHPiYvIm5y+vBvb1CUVR+PGC32zNUJSiOWKAgNJtUdlo4fwG46y2PbhB4KyQF+bFPnLhmfvuBP0BBf40biNjQ/S4Zp1buN1snyYyOVMzDOKOA4FH17iQw4JcXXejm3vBFMWfBvRd/PCc/ru1sXS0WXE4VmuBNUvNRQ/Z9x6STQKQZv2bR2Ok1aZWPvJ2hpzcAKYUPOG9Vv5K773ex3i16c8sOOpW1ahduYysaPP2VdFwudpVNfoPjXHAlhG2
 fRghhg3d
 zLNG4zwCxGdZ7W+YH/Ukd7QXf4LmofcSs5rx+pN/VnFMXL4e1yq4FveAssXsVrp04Rsf2YBMCljb0RlIAXSmmLffl4I0W0o4MY00Sfsw+KObg7fUo3rz4a/70ak4J5wd4qzzB+VdqkP/qPlXyhxZipSloZx9CsSHj8mxy3HaqMuTQgfC3k92wnKK5xYFgDxcETY395ltnB/vh4XhQ/t10UEUhznvgPceSxTrG+tJhC7WFun7/cNghyqHLL+K/Joi1vg6MMY0SGKa/9xnfG6LA2Lbr/iK9pvBl1BasQ/6uOVEpEBe1/MToi0AtUeirINIssauYGjDou8t42JowgNr8hL7P/YA30RZmPu9T2SOMmCaRuKr06iO0F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generic page-table interfaces use pte_t * for both pointers to PTE table
storage and pointers to software PTE values. Convert the generic
declarations and their MM, fs, and kernel users together so parameters,
return types, callbacks, and local pointers that designate table storage
use hw_pte_t *.

Include linux/pgtable_types.h from headers that expose the converted
interfaces. It continues to provide pgprot_t to vmalloc.h through
asm/page.h.

Keep software PTE values as pte_t and retain pte_t * for value interfaces.

No architecture selects ARCH_HAS_HW_PTE_T at this point, so hw_pte_t
remains an alias of pte_t and this changes the interface vocabulary without
changing representation or behavior.

Most of this mechanical conversion was generated with the Coccinelle script
included in the cover letter. The script deliberately ignores pte_t *
pointers named ptentp because they designate software PTE values. The
result was then audited, and sites the script could not convert were
updated by hand.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Fold the header includes into their first user instead of keeping a
  stand-alone preparation patch.
- Rebase onto mm-new and rerun the Coccinelle script.
- Use software PTE value terminology.

Changes since RFC v1:
- Clarify that linux/pgtable_types.h provides both generic hw_pte_t
  definitions.
- Clarify that the distinct generic definition is activated by an
  architecture opt-in.
---
 fs/hugetlbfs/inode.c             |  3 ++-
 fs/proc/task_mmu.c               | 33 ++++++++++++++--------------
 include/asm-generic/hugetlb.h    | 15 +++++++------
 include/asm-generic/pgalloc.h    |  6 ++---
 include/asm-generic/tlb.h        |  5 +++--
 include/linux/hugetlb.h          | 50 +++++++++++++++++++++++-------------------
 include/linux/mm.h               | 26 +++++++++++-----------
 include/linux/page_table_check.h | 10 ++++++---
 include/linux/pagewalk.h         |  8 +++----
 include/linux/pgtable.h          | 79 +++++++++++++++++++++++++++++++++++-------------------------------
 include/linux/rmap.h             |  2 +-
 include/linux/swapops.h          |  6 +++--
 include/linux/vmalloc.h          |  4 ++--
 include/trace/events/xen.h       | 10 ++++-----
 kernel/bpf/arena.c               |  9 ++++----
 kernel/events/core.c             |  3 ++-
 mm/damon/ops-common.c            |  2 +-
 mm/damon/ops-common.h            |  2 +-
 mm/damon/vaddr.c                 | 20 +++++++++--------
 mm/debug_vm_pgtable.c            |  2 +-
 mm/filemap.c                     |  4 ++--
 mm/gup.c                         |  9 ++++----
 mm/highmem.c                     | 15 +++++++------
 mm/hmm.c                         |  6 ++---
 mm/huge_memory.c                 |  4 ++--
 mm/hugetlb.c                     | 60 ++++++++++++++++++++++++++------------------------
 mm/hugetlb_vmemmap.c             | 13 ++++++-----
 mm/internal.h                    | 16 +++++++-------
 mm/kasan/init.c                  | 12 +++++-----
 mm/kasan/shadow.c                |  6 ++---
 mm/khugepaged.c                  | 50 +++++++++++++++++++++++++-----------------
 mm/ksm.c                         |  7 +++---
 mm/madvise.c                     | 14 +++++++-----
 mm/mapping_dirty_helpers.c       |  4 ++--
 mm/memory-failure.c              |  6 ++---
 mm/memory.c                      | 78 +++++++++++++++++++++++++++++++++--------------------------------
 mm/mempolicy.c                   |  4 ++--
 mm/migrate.c                     |  4 ++--
 mm/migrate_device.c              |  4 ++--
 mm/mincore.c                     |  4 ++--
 mm/mlock.c                       |  4 ++--
 mm/mprotect.c                    | 19 ++++++++--------
 mm/mremap.c                      |  4 ++--
 mm/page_table_check.c            |  4 ++--
 mm/pagewalk.c                    |  9 ++++----
 mm/percpu.c                      |  2 +-
 mm/pgtable-generic.c             | 20 ++++++++---------
 mm/ptdump.c                      |  2 +-
 mm/rmap.c                        |  6 ++---
 mm/sparse-vmemmap.c              | 22 +++++++++----------
 mm/swap_state.c                  |  3 ++-
 mm/swapfile.c                    |  5 +++--
 mm/userfaultfd.c                 | 32 +++++++++++++++------------
 mm/util.c                        |  2 +-
 mm/vmalloc.c                     | 11 +++++-----
 mm/vmscan.c                      |  6 ++---
 56 files changed, 410 insertions(+), 356 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a8470ea26..ddaab714c3e02 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -328,7 +328,8 @@ static void hugetlb_delete_from_page_cache(struct folio *folio)
 static bool hugetlb_vma_maps_pfn(struct vm_area_struct *vma,
 				unsigned long addr, unsigned long pfn)
 {
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 
 	ptep = hugetlb_walk(vma, addr, huge_page_size(hstate_vma(vma)));
 	if (!ptep)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e671b4fd8dedd..4211c33b06491 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -982,7 +982,7 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
 #endif
 }
 
-static void smaps_pte_entry(pte_t *pte, unsigned long addr,
+static void smaps_pte_entry(hw_pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
@@ -1076,7 +1076,7 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *pte;
+	hw_pte_t *pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
@@ -1199,7 +1199,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
+static int smaps_hugetlb_range(hw_pte_t *pte, unsigned long hmask,
 				 unsigned long addr, unsigned long end,
 				 struct mm_walk *walk)
 {
@@ -1622,7 +1622,7 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
 }
 
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *pte)
+		unsigned long addr, hw_pte_t *pte)
 {
 	if (!pgtable_supports_soft_dirty())
 		return;
@@ -1690,7 +1690,8 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 {
 	struct clear_refs_private *cp = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *pte, ptent;
+	hw_pte_t *pte;
+	pte_t ptent;
 	spinlock_t *ptl;
 	struct folio *folio;
 
@@ -2090,7 +2091,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	struct vm_area_struct *vma = walk->vma;
 	struct pagemapread *pm = walk->private;
 	spinlock_t *ptl;
-	pte_t *pte, *orig_pte;
+	hw_pte_t *pte, *orig_pte;
 	int err = 0;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -2128,7 +2129,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 #ifdef CONFIG_HUGETLB_PAGE
 /* This function walks within one hugetlb entry in the single call */
-static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
+static int pagemap_hugetlb_range(hw_pte_t *ptep, unsigned long hmask,
 				 unsigned long addr, unsigned long end,
 				 struct mm_walk *walk)
 {
@@ -2419,7 +2420,7 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 }
 
 static void make_uffd_wp_pte(struct vm_area_struct *vma,
-			     unsigned long addr, pte_t *pte, pte_t ptent)
+			     unsigned long addr, hw_pte_t *pte, pte_t ptent)
 {
 	if (pte_present(ptent)) {
 		pte_t old_pte;
@@ -2552,7 +2553,7 @@ static unsigned long pagemap_hugetlb_category(struct vm_area_struct *vma,
 }
 
 static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
-				  unsigned long addr, pte_t *ptep,
+				  unsigned long addr, hw_pte_t *ptep,
 				  pte_t ptent)
 {
 	const unsigned long psize = huge_page_size(hstate_vma(vma));
@@ -2786,7 +2787,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 	struct pagemap_scan_private *p = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	unsigned long addr, flush_end = 0;
-	pte_t *pte, *start_pte;
+	hw_pte_t *pte, *start_pte;
 	spinlock_t *ptl;
 	int ret;
 
@@ -2880,7 +2881,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
+static int pagemap_scan_hugetlb_entry(hw_pte_t *ptep, unsigned long hmask,
 				      unsigned long start, unsigned long end,
 				      struct mm_walk *walk)
 {
@@ -2961,7 +2962,7 @@ static int pagemap_scan_hugetlb_hole_wp(struct vm_area_struct *vma,
 	unsigned long psize = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	pte_t pte;
 
 	for (addr = ALIGN_DOWN(addr, psize); addr < end; addr += psize) {
@@ -3345,8 +3346,8 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 	struct numa_maps *md = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
-	pte_t *orig_pte;
-	pte_t *pte;
+	hw_pte_t *orig_pte;
+	hw_pte_t *pte;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmd, vma);
@@ -3379,7 +3380,7 @@ static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
+static int gather_hugetlb_stats(hw_pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
 	pte_t huge_pte;
@@ -3402,7 +3403,7 @@ static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 }
 
 #else
-static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
+static int gather_hugetlb_stats(hw_pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
 	return 0;
diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetlb.h
index 635c41cc34797..3bfad4a99b64d 100644
--- a/include/asm-generic/hugetlb.h
+++ b/include/asm-generic/hugetlb.h
@@ -60,7 +60,7 @@ static inline int huge_pte_uffd(pte_t pte)
 
 #ifndef __HAVE_ARCH_HUGE_PTE_CLEAR
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
-		    pte_t *ptep, unsigned long sz)
+		    hw_pte_t *ptep, unsigned long sz)
 {
 	pte_clear(mm, addr, ptep);
 }
@@ -68,7 +68,7 @@ static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 
 #ifndef __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
 static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, pte_t pte, unsigned long sz)
+		hw_pte_t *ptep, pte_t pte, unsigned long sz)
 {
 	set_pte_at(mm, addr, ptep, pte);
 }
@@ -76,7 +76,7 @@ static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 
 #ifndef __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
 static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
-		unsigned long addr, pte_t *ptep, unsigned long sz)
+		unsigned long addr, hw_pte_t *ptep, unsigned long sz)
 {
 	return ptep_get_and_clear(mm, addr, ptep);
 }
@@ -84,7 +84,7 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 
 #ifndef __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
+		unsigned long addr, hw_pte_t *ptep)
 {
 	return ptep_clear_flush(vma, addr, ptep);
 }
@@ -99,7 +99,7 @@ static inline int huge_pte_none(pte_t pte)
 
 #ifndef __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
-		unsigned long addr, pte_t *ptep)
+		unsigned long addr, hw_pte_t *ptep)
 {
 	ptep_set_wrprotect(mm, addr, ptep);
 }
@@ -107,7 +107,7 @@ static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 
 #ifndef __HAVE_ARCH_HUGE_PTEP_SET_ACCESS_FLAGS
 static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep,
+		unsigned long addr, hw_pte_t *ptep,
 		pte_t pte, int dirty)
 {
 	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
@@ -115,7 +115,8 @@ static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 #endif
 
 #ifndef __HAVE_ARCH_HUGE_PTEP_GET
-static inline pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+static inline pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
+		hw_pte_t *ptep)
 {
 	return ptep_get(ptep);
 }
diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 051aa1331051c..b35e5a2158ada 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -16,7 +16,7 @@
  *
  * Return: pointer to the allocated memory or %NULL on error
  */
-static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
+static inline hw_pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 {
 	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
 
@@ -40,7 +40,7 @@ static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
  *
  * Return: pointer to the allocated memory or %NULL on error
  */
-static inline pte_t *pte_alloc_one_kernel_noprof(struct mm_struct *mm)
+static inline hw_pte_t *pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 {
 	return __pte_alloc_one_kernel_noprof(mm);
 }
@@ -52,7 +52,7 @@ static inline pte_t *pte_alloc_one_kernel_noprof(struct mm_struct *mm)
  * @mm: the mm_struct of the current context
  * @pte: pointer to the memory containing the page table
  */
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+static inline void pte_free_kernel(struct mm_struct *mm, hw_pte_t *pte)
 {
 	pagetable_dtor_free(virt_to_ptdesc(pte));
 }
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index bdcc2778ac64f..2c3517800a9a8 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -644,7 +644,8 @@ static inline void tlb_flush_p4d_range(struct mmu_gather *tlb,
 }
 
 #ifndef __tlb_remove_tlb_entry
-static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, unsigned long address)
+static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb,
+		hw_pte_t *ptep, unsigned long address)
 {
 }
 #endif
@@ -670,7 +671,7 @@ static inline void __tlb_remove_tlb_entry(struct mmu_gather *tlb, pte_t *ptep, u
  * consecutive ptes instead of only a single one.
  */
 static inline void tlb_remove_tlb_entries(struct mmu_gather *tlb,
-		pte_t *ptep, unsigned int nr, unsigned long address)
+		hw_pte_t *ptep, unsigned int nr, unsigned long address)
 {
 	tlb_flush_pte_range(tlb, address, PAGE_SIZE * nr);
 	for (;;) {
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 900c95e346b2e..0d2101facaa50 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -141,7 +141,7 @@ unsigned long hugetlb_total_pages(void);
 vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
 #ifdef CONFIG_USERFAULTFD
-int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
+int hugetlb_mfill_atomic_pte(hw_pte_t *dst_pte,
 			     struct vm_area_struct *dst_vma,
 			     unsigned long dst_addr,
 			     unsigned long src_addr,
@@ -161,7 +161,7 @@ void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
 
-pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
+hw_pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud);
 bool hugetlbfs_pagecache_present(struct hstate *h,
 				 struct vm_area_struct *vma,
@@ -185,22 +185,22 @@ void hugetlb_bootmem_set_nodes(void);
  * which may go down to the lowest PTE level in their huge_pte_offset() and
  * huge_pte_alloc(): to avoid reliance on pte_offset_map() without pte_unmap().
  */
-static inline pte_t *pte_offset_huge(pmd_t *pmd, unsigned long address)
+static inline hw_pte_t *pte_offset_huge(pmd_t *pmd, unsigned long address)
 {
 	return pte_offset_kernel(pmd, address);
 }
-static inline pte_t *pte_alloc_huge(struct mm_struct *mm, pmd_t *pmd,
+static inline hw_pte_t *pte_alloc_huge(struct mm_struct *mm, pmd_t *pmd,
 				    unsigned long address)
 {
 	return pte_alloc(mm, pmd) ? NULL : pte_offset_huge(pmd, address);
 }
 #endif
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+hw_pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz);
 /*
  * huge_pte_offset(): Walk the hugetlb pgtable until the last level PTE.
- * Returns the pte_t* if found, or NULL if the address is not mapped.
+ * Returns the hw_pte_t* if found, or NULL if the address is not mapped.
  *
  * IMPORTANT: we should normally not directly call this function, instead
  * this is only a common interface to implement arch-specific
@@ -235,11 +235,11 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
  * a concurrent pmd unshare, but it makes sure the pgtable page is safe to
  * access.
  */
-pte_t *huge_pte_offset(struct mm_struct *mm,
+hw_pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
 unsigned long hugetlb_mask_last_page(struct hstate *h);
 int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep);
+		unsigned long addr, hw_pte_t *ptep);
 void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
@@ -301,7 +301,8 @@ static inline struct address_space *hugetlb_folio_mapping_lock_write(
 }
 
 static inline int huge_pmd_unshare(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+		struct vm_area_struct *vma, unsigned long addr,
+		hw_pte_t *ptep)
 {
 	return 0;
 }
@@ -393,7 +394,7 @@ static inline int is_hugepage_only_range(struct mm_struct *mm,
 }
 
 #ifdef CONFIG_USERFAULTFD
-static inline int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
+static inline int hugetlb_mfill_atomic_pte(hw_pte_t *dst_pte,
 					   struct vm_area_struct *dst_vma,
 					   unsigned long dst_addr,
 					   unsigned long src_addr,
@@ -405,7 +406,7 @@ static inline int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 }
 #endif /* CONFIG_USERFAULTFD */
 
-static inline pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr,
+static inline hw_pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr,
 					unsigned long sz)
 {
 	return NULL;
@@ -984,7 +985,8 @@ static inline bool htlb_allow_alloc_fallback(enum migrate_reason reason)
 }
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
-					   struct mm_struct *mm, pte_t *pte)
+					   struct mm_struct *mm,
+					   hw_pte_t *pte)
 {
 	const unsigned long size = huge_page_size(h);
 
@@ -1048,7 +1050,8 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 #ifndef huge_ptep_modify_prot_start
 #define huge_ptep_modify_prot_start huge_ptep_modify_prot_start
 static inline pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma,
-						unsigned long addr, pte_t *ptep)
+						unsigned long addr,
+						hw_pte_t *ptep)
 {
 	unsigned long psize = huge_page_size(hstate_vma(vma));
 
@@ -1059,7 +1062,8 @@ static inline pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma,
 #ifndef huge_ptep_modify_prot_commit
 #define huge_ptep_modify_prot_commit huge_ptep_modify_prot_commit
 static inline void huge_ptep_modify_prot_commit(struct vm_area_struct *vma,
-						unsigned long addr, pte_t *ptep,
+						unsigned long addr,
+						hw_pte_t *ptep,
 						pte_t old_pte, pte_t pte)
 {
 	unsigned long psize = huge_page_size(hstate_vma(vma));
@@ -1247,7 +1251,8 @@ static inline bool htlb_allow_alloc_fallback(enum migrate_reason reason)
 }
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
-					   struct mm_struct *mm, pte_t *pte)
+					   struct mm_struct *mm,
+					   hw_pte_t *pte)
 {
 	return &mm->page_table_lock;
 }
@@ -1264,11 +1269,11 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }
 
-pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, hw_pte_t *ptep);
 unsigned long huge_pte_dirty(pte_t pte);
 
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-					  unsigned long addr, pte_t *ptep)
+					  unsigned long addr, hw_pte_t *ptep)
 {
 #ifdef CONFIG_MMU
 	return ptep_get(ptep);
@@ -1278,7 +1283,8 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 }
 
 static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte, unsigned long sz)
+				   hw_pte_t *ptep, pte_t pte,
+				   unsigned long sz)
 {
 }
 
@@ -1306,7 +1312,7 @@ static inline void hugetlb_bootmem_struct_page_init(void)
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
-					struct mm_struct *mm, pte_t *pte)
+					struct mm_struct *mm, hw_pte_t *pte)
 {
 	spinlock_t *ptl;
 
@@ -1324,12 +1330,12 @@ static inline __init void hugetlb_cma_reserve(void)
 #endif
 
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
-static inline bool hugetlb_pmd_shared(pte_t *pte)
+static inline bool hugetlb_pmd_shared(hw_pte_t *pte)
 {
 	return ptdesc_pmd_is_shared(virt_to_ptdesc(pte));
 }
 #else
-static inline bool hugetlb_pmd_shared(pte_t *pte)
+static inline bool hugetlb_pmd_shared(hw_pte_t *pte)
 {
 	return false;
 }
@@ -1356,7 +1362,7 @@ bool __vma_private_lock(struct vm_area_struct *vma);
  * Safe version of huge_pte_offset() to check the locks.  See comments
  * above huge_pte_offset().
  */
-static inline pte_t *
+static inline hw_pte_t *
 hugetlb_walk(struct vm_area_struct *vma, unsigned long addr, unsigned long sz)
 {
 #if defined(CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING) && defined(CONFIG_LOCKDEP)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1b28e6fc8d5dd..7d7344b9dbe19 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -779,7 +779,7 @@ struct vm_fault {
 					 * VM_FAULT_ERROR).
 					 */
 	/* These three entries are valid only while holding ptl lock */
-	pte_t *pte;			/* Pointer to pte entry matching
+	hw_pte_t *pte;			/* Pointer to pte entry matching
 					 * the 'address'. NULL if the page
 					 * table hasn't been allocated.
 					 */
@@ -3246,7 +3246,7 @@ struct follow_pfnmap_args {
 	 * The caller shouldn't touch any of these.
 	 */
 	spinlock_t *lock;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	/**
 	 * Outputs:
 	 *
@@ -3583,7 +3583,7 @@ static inline pud_t pud_mkspecial(pud_t pud)
 }
 #endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
 
-extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+extern hw_pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			     spinlock_t **ptl);
 
 #ifdef __PAGETABLE_P4D_FOLDED
@@ -3861,7 +3861,7 @@ static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
 	return ptlock_ptr(page_ptdesc(pmd_page(*pmd)));
 }
 
-static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, pte_t *pte)
+static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, hw_pte_t *pte)
 {
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHPTE));
 	BUILD_BUG_ON(MAX_PTRS_PER_PTE * sizeof(pte_t) > PAGE_SIZE);
@@ -3892,7 +3892,7 @@ static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
 	return &mm->page_table_lock;
 }
-static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, pte_t *pte)
+static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, hw_pte_t *pte)
 {
 	return &mm->page_table_lock;
 }
@@ -3933,19 +3933,19 @@ static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 	return true;
 }
 
-pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
+hw_pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
 
-static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
+static inline hw_pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 {
 	return __pte_offset_map(pmd, addr, NULL);
 }
 
-pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
+hw_pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 			   unsigned long addr, spinlock_t **ptlp);
 
-pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
+hw_pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, spinlock_t **ptlp);
-pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
+hw_pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, pmd_t *pmdvalp,
 				spinlock_t **ptlp);
 
@@ -4895,7 +4895,7 @@ static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 	return !vma_is_accessible(vma);
 }
 
-typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
+typedef int (*pte_fn_t)(hw_pte_t *pte, unsigned long addr, void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
 extern int apply_to_existing_page_range(struct mm_struct *mm,
@@ -5144,7 +5144,7 @@ void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
 			      struct vmem_altmap *altmap);
-void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
+void vmemmap_verify(hw_pte_t *, int, unsigned long, unsigned long);
 void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 		     unsigned long addr, unsigned long next);
 int vmemmap_check_pmd(pmd_t *pmd, int node,
@@ -5509,7 +5509,7 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
 
 void snapshot_page(struct page_snapshot *ps, const struct page *page);
 
-void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+void map_anon_folio_pte_nopf(struct folio *folio, hw_pte_t *pte,
 		struct vm_area_struct *vma, unsigned long addr,
 		bool uffd_wp);
 
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 12268a32e8be1..933c1028c2232 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -7,6 +7,8 @@
 #ifndef __LINUX_PAGE_TABLE_CHECK_H
 #define __LINUX_PAGE_TABLE_CHECK_H
 
+#include <linux/pgtable_types.h>
+
 #ifdef CONFIG_PAGE_TABLE_CHECK
 #include <linux/jump_label.h>
 
@@ -21,7 +23,7 @@ void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 				  pud_t pud);
 void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, pte_t pte, unsigned int nr);
+		hw_pte_t *ptep, pte_t pte, unsigned int nr);
 void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 		pmd_t *pmdp, pmd_t pmd, unsigned int nr);
 void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
@@ -74,7 +76,8 @@ static inline void page_table_check_pud_clear(struct mm_struct *mm,
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
-					     unsigned long addr, pte_t *ptep,
+					     unsigned long addr,
+					     hw_pte_t *ptep,
 					     pte_t pte, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
@@ -137,7 +140,8 @@ static inline void page_table_check_pud_clear(struct mm_struct *mm,
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
-					     unsigned long addr, pte_t *ptep,
+					     unsigned long addr,
+					     hw_pte_t *ptep,
 					     pte_t pte, unsigned int nr)
 {
 }
diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index c34d826c5e4a2..7ab2eb39e02c0 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -38,7 +38,7 @@ enum page_walk_lock {
  *			not trigger for any populated ranges.
  * @hugetlb_entry:	if set, called for each hugetlb entry. This hook
  *			function is called with the vma lock held, in order to
- *			protect against a concurrent freeing of the pte_t* or
+ *			protect against a concurrent freeing of the hw_pte_t* or
  *			the ptl. In some cases, the hook function needs to drop
  *			and retake the vma lock in order to avoid deadlocks
  *			while calling other functions. In such cases the hook
@@ -76,11 +76,11 @@ struct mm_walk_ops {
 			 unsigned long next, struct mm_walk *walk);
 	int (*pmd_entry)(pmd_t *pmd, unsigned long addr,
 			 unsigned long next, struct mm_walk *walk);
-	int (*pte_entry)(pte_t *pte, unsigned long addr,
+	int (*pte_entry)(hw_pte_t *pte, unsigned long addr,
 			 unsigned long next, struct mm_walk *walk);
 	int (*pte_hole)(unsigned long addr, unsigned long next,
 			int depth, struct mm_walk *walk);
-	int (*hugetlb_entry)(pte_t *pte, unsigned long hmask,
+	int (*hugetlb_entry)(hw_pte_t *pte, unsigned long hmask,
 			     unsigned long addr, unsigned long next,
 			     struct mm_walk *walk);
 	int (*test_walk)(unsigned long addr, unsigned long next,
@@ -173,7 +173,7 @@ struct folio_walk {
 	struct page *page;
 	enum folio_walk_level level;
 	union {
-		pte_t *ptep;
+		hw_pte_t *ptep;
 		pud_t *pudp;
 		pmd_t *pmdp;
 	};
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c5..19098e302b75a 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -4,6 +4,7 @@
 
 #include <linux/pfn.h>
 #include <asm/pgtable.h>
+#include <linux/pgtable_types.h>
 
 #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
 #define PUD_ORDER	(PUD_SHIFT - PAGE_SHIFT)
@@ -93,26 +94,26 @@ static inline void pud_init(void *addr)
 #endif
 
 #ifndef pte_offset_kernel
-static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
+static inline hw_pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
 {
-	return (pte_t *)pmd_page_vaddr(*pmd) + pte_index(address);
+	return (hw_pte_t *)pmd_page_vaddr(*pmd) + pte_index(address);
 }
 #define pte_offset_kernel pte_offset_kernel
 #endif
 
 #ifdef CONFIG_HIGHPTE
 #define __pte_map(pmd, address) \
-	((pte_t *)kmap_local_page(pmd_page(*(pmd))) + pte_index((address)))
+	((hw_pte_t *)kmap_local_page(pmd_page(*(pmd))) + pte_index((address)))
 #define pte_unmap(pte)	do {	\
 	kunmap_local((pte));	\
 	rcu_read_unlock();	\
 } while (0)
 #else
-static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
+static inline hw_pte_t *__pte_map(pmd_t *pmd, unsigned long address)
 {
 	return pte_offset_kernel(pmd, address);
 }
-static inline void pte_unmap(pte_t *pte)
+static inline void pte_unmap(hw_pte_t *pte)
 {
 	rcu_read_unlock();
 }
@@ -172,7 +173,7 @@ static inline pmd_t *pmd_off_k(unsigned long va)
 	return pmd_offset(pud_offset(p4d_offset(pgd_offset_k(va), va), va), va);
 }
 
-static inline pte_t *virt_to_kpte(unsigned long vaddr)
+static inline hw_pte_t *virt_to_kpte(unsigned long vaddr)
 {
 	pmd_t *pmd = pmd_off_k(vaddr);
 
@@ -407,7 +408,7 @@ static inline void lazy_mmu_mode_resume(void) {}
  *
  * May be overridden by the architecture, else pte_batch_hint is always 1.
  */
-static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
+static inline unsigned int pte_batch_hint(hw_pte_t *ptep, pte_t pte)
 {
 	return 1;
 }
@@ -442,7 +443,7 @@ static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
  * to the same folio.  The PTEs are all in the same PMD.
  */
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, pte_t pte, unsigned int nr)
+		hw_pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 
@@ -459,7 +460,7 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
-				 unsigned long address, pte_t *ptep,
+				 unsigned long address, hw_pte_t *ptep,
 				 pte_t entry, int dirty);
 #endif
 
@@ -490,7 +491,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #endif
 
 #ifndef ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(hw_pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
@@ -526,7 +527,7 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+		unsigned long address, hw_pte_t *ptep)
 {
 	pte_t pte = ptep_get(ptep);
 	bool young = true;
@@ -565,7 +566,7 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 bool ptep_clear_flush_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep);
+		unsigned long address, hw_pte_t *ptep);
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
@@ -644,7 +645,7 @@ static inline void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
-				       pte_t *ptep)
+				       hw_pte_t *ptep)
 {
 	pte_t pte = ptep_get(ptep);
 	pte_clear(mm, address, ptep);
@@ -673,7 +674,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
 static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
-					  unsigned long addr, pte_t *ptep,
+					  unsigned long addr, hw_pte_t *ptep,
 					  unsigned int nr, cydp_t flags)
 {
 	pte_t pte;
@@ -698,7 +699,7 @@ static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
 #endif
 
 static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep)
+			      hw_pte_t *ptep)
 {
 	pte_t pte = ptep_get(ptep);
 
@@ -739,7 +740,7 @@ static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
  * present bit set *unless* it is 'l'. Because get_user_pages_fast() only
  * operates on present ptes we're safe.
  */
-static inline pte_t ptep_get_lockless(pte_t *ptep)
+static inline pte_t ptep_get_lockless(hw_pte_t *ptep)
 {
 	pte_t pte;
 
@@ -777,7 +778,7 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
  * We require that the PTE can be read atomically.
  */
 #ifndef ptep_get_lockless
-static inline pte_t ptep_get_lockless(pte_t *ptep)
+static inline pte_t ptep_get_lockless(hw_pte_t *ptep)
 {
 	return ptep_get(ptep);
 }
@@ -844,7 +845,8 @@ static inline pud_t pudp_huge_get_and_clear_full(struct vm_area_struct *vma,
 
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
 static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
-					    unsigned long address, pte_t *ptep,
+					    unsigned long address,
+					    hw_pte_t *ptep,
 					    int full)
 {
 	return ptep_get_and_clear(mm, address, ptep);
@@ -872,7 +874,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
 static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
-		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr, int full)
 {
 	pte_t pte, tmp_pte;
 
@@ -908,7 +910,7 @@ static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
 static inline pte_t get_and_clear_ptes(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, unsigned int nr)
+		hw_pte_t *ptep, unsigned int nr)
 {
 	return get_and_clear_full_ptes(mm, addr, ptep, nr, 0);
 }
@@ -933,7 +935,7 @@ static inline pte_t get_and_clear_ptes(struct mm_struct *mm, unsigned long addr,
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
 static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, unsigned int nr, int full)
+		hw_pte_t *ptep, unsigned int nr, int full)
 {
 	for (;;) {
 		ptep_get_and_clear_full(mm, addr, ptep, full);
@@ -962,7 +964,7 @@ static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
 static inline void clear_ptes(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, unsigned int nr)
+		hw_pte_t *ptep, unsigned int nr)
 {
 	clear_full_ptes(mm, addr, ptep, nr, 0);
 }
@@ -977,13 +979,14 @@ static inline void clear_ptes(struct mm_struct *mm, unsigned long addr,
  */
 #ifndef update_mmu_tlb_range
 static inline void update_mmu_tlb_range(struct vm_area_struct *vma,
-				unsigned long address, pte_t *ptep, unsigned int nr)
+				unsigned long address, hw_pte_t *ptep,
+				unsigned int nr)
 {
 }
 #endif
 
 static inline void update_mmu_tlb(struct vm_area_struct *vma,
-				unsigned long address, pte_t *ptep)
+				unsigned long address, hw_pte_t *ptep)
 {
 	update_mmu_tlb_range(vma, address, ptep, 1);
 }
@@ -1000,7 +1003,7 @@ static inline void update_mmu_tlb(struct vm_area_struct *vma,
  * The PTEs are all in the same PMD.
  */
 static inline void clear_nonpresent_ptes(struct mm_struct *mm,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	(void)addr;
 
@@ -1016,7 +1019,7 @@ static inline void clear_nonpresent_ptes(struct mm_struct *mm,
 #ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
 extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
 			      unsigned long address,
-			      pte_t *ptep);
+			      hw_pte_t *ptep);
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
@@ -1044,7 +1047,8 @@ static inline pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 
 #ifndef __HAVE_ARCH_PTEP_SET_WRPROTECT
 struct mm_struct;
-static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long address, pte_t *ptep)
+static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long address,
+				      hw_pte_t *ptep)
 {
 	pte_t old_pte = ptep_get(ptep);
 	set_pte_at(mm, address, ptep, pte_wrprotect(old_pte));
@@ -1070,7 +1074,7 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
  * ptep_try_set as an identity macro. The generic stub returns false, which is
  * correct for callers that fall through to oops on failure.
  */
-static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
+static inline bool ptep_try_set(hw_pte_t *ptep, pte_t new_pte)
 {
 	return false;
 }
@@ -1113,7 +1117,7 @@ static inline void flush_tlb_before_set(unsigned long addr)
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
 static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, unsigned int nr)
+		hw_pte_t *ptep, unsigned int nr)
 {
 	for (;;) {
 		ptep_set_wrprotect(mm, addr, ptep);
@@ -1144,7 +1148,7 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
 static inline bool clear_flush_young_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	bool young = false;
 
@@ -1181,7 +1185,7 @@ static inline bool clear_flush_young_ptes(struct vm_area_struct *vma,
  * Returns: whether any PTE was young.
  */
 static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	bool young = false;
 
@@ -1585,7 +1589,7 @@ static inline int pmd_none_or_clear_bad(pmd_t *pmd)
 
 static inline pte_t __ptep_modify_prot_start(struct vm_area_struct *vma,
 					     unsigned long addr,
-					     pte_t *ptep)
+					     hw_pte_t *ptep)
 {
 	/*
 	 * Get the current pte state, but zero it out to make it
@@ -1597,7 +1601,7 @@ static inline pte_t __ptep_modify_prot_start(struct vm_area_struct *vma,
 
 static inline void __ptep_modify_prot_commit(struct vm_area_struct *vma,
 					     unsigned long addr,
-					     pte_t *ptep, pte_t pte)
+					     hw_pte_t *ptep, pte_t pte)
 {
 	/*
 	 * The pte is non-present, so there's no hardware state to
@@ -1623,7 +1627,7 @@ static inline void __ptep_modify_prot_commit(struct vm_area_struct *vma,
  */
 static inline pte_t ptep_modify_prot_start(struct vm_area_struct *vma,
 					   unsigned long addr,
-					   pte_t *ptep)
+					   hw_pte_t *ptep)
 {
 	return __ptep_modify_prot_start(vma, addr, ptep);
 }
@@ -1636,7 +1640,8 @@ static inline pte_t ptep_modify_prot_start(struct vm_area_struct *vma,
  */
 static inline void ptep_modify_prot_commit(struct vm_area_struct *vma,
 					   unsigned long addr,
-					   pte_t *ptep, pte_t old_pte, pte_t pte)
+					   hw_pte_t *ptep, pte_t old_pte,
+					   pte_t pte)
 {
 	__ptep_modify_prot_commit(vma, addr, ptep, pte);
 }
@@ -1667,7 +1672,7 @@ static inline void ptep_modify_prot_commit(struct vm_area_struct *vma,
  */
 #ifndef modify_prot_start_ptes
 static inline pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	pte_t pte, tmp_pte;
 
@@ -1707,7 +1712,7 @@ static inline pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
  */
 #ifndef modify_prot_commit_ptes
 static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pte_t old_pte, pte_t pte, unsigned int nr)
+		hw_pte_t *ptep, pte_t old_pte, pte_t pte, unsigned int nr)
 {
 	int i;
 
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 0b332770abeed..d28a7fb6f2c0e 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -868,7 +868,7 @@ struct page_vma_mapped_walk {
 	struct vm_area_struct *vma;
 	unsigned long address;
 	pmd_t *pmd;
-	pte_t *pte;
+	hw_pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
 	bool pgoff_is_anon : 1;
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index e7d0d529f3e0f..40d2fd920558f 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -216,7 +216,8 @@ static inline swp_entry_t make_migration_entry_dirty(swp_entry_t entry)
 
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
-extern void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr, pte_t *pte);
+extern void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr,
+				      hw_pte_t *pte);
 #else  /* CONFIG_MIGRATION */
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
@@ -236,7 +237,8 @@ static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address) { }
 static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
-					     unsigned long addr, pte_t *pte) { }
+					     unsigned long addr,
+					     hw_pte_t *pte) { }
 
 static inline swp_entry_t make_migration_entry_young(swp_entry_t entry)
 {
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index aed121d729b01..666ff2b3741da 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -8,7 +8,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/llist.h>
-#include <asm/page.h>		/* pgprot_t */
+#include <linux/pgtable_types.h>	/* pgprot_t, hw_pte_t */
 #include <linux/rbtree.h>
 #include <linux/overflow.h>
 
@@ -120,7 +120,7 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr, uns
 
 #ifndef arch_vmap_pte_range_unmap_size
 static inline unsigned long arch_vmap_pte_range_unmap_size(unsigned long addr,
-							   pte_t *ptep)
+							   hw_pte_t *ptep)
 {
 	return PAGE_SIZE;
 }
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index ad384969e2cb2..1972d50b043a5 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -138,10 +138,10 @@ TRACE_EVENT(xen_mc_extend_args,
 TRACE_DEFINE_SIZEOF(pteval_t);
 
 TRACE_EVENT(xen_mmu_set_pte,
-	    TP_PROTO(pte_t *ptep, pte_t pteval),
+	    TP_PROTO(hw_pte_t *ptep, pte_t pteval),
 	    TP_ARGS(ptep, pteval),
 	    TP_STRUCT__entry(
-		    __field(pte_t *, ptep)
+		    __field(hw_pte_t *, ptep)
 		    __field(pteval_t, pteval)
 		    ),
 	    TP_fast_assign(__entry->ptep = ptep;
@@ -207,12 +207,12 @@ TRACE_EVENT(xen_mmu_set_p4d,
 
 DECLARE_EVENT_CLASS(xen_mmu_ptep_modify_prot,
 	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
-		     pte_t *ptep, pte_t pteval),
+		     hw_pte_t *ptep, pte_t pteval),
 	    TP_ARGS(mm, addr, ptep, pteval),
 	    TP_STRUCT__entry(
 		    __field(struct mm_struct *, mm)
 		    __field(unsigned long, addr)
-		    __field(pte_t *, ptep)
+		    __field(hw_pte_t *, ptep)
 		    __field(pteval_t, pteval)
 		    ),
 	    TP_fast_assign(__entry->mm = mm;
@@ -227,7 +227,7 @@ DECLARE_EVENT_CLASS(xen_mmu_ptep_modify_prot,
 #define DEFINE_XEN_MMU_PTEP_MODIFY_PROT(name)				\
 	DEFINE_EVENT(xen_mmu_ptep_modify_prot, name,			\
 		     TP_PROTO(struct mm_struct *mm, unsigned long addr,	\
-			      pte_t *ptep, pte_t pteval),		\
+			      hw_pte_t *ptep, pte_t pteval),		\
 		     TP_ARGS(mm, addr, ptep, pteval))
 
 DEFINE_XEN_MMU_PTEP_MODIFY_PROT(xen_mmu_ptep_modify_prot_start);
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 7b6847200b431..62005229b2e94 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -155,7 +155,7 @@ struct clear_range_data {
 	struct llist_head *free_pages;
 };
 
-static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data)
+static int apply_range_set_cb(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct apply_range_data *d = data;
 	struct page *page;
@@ -207,7 +207,7 @@ static void flush_vmap_cache(unsigned long start, unsigned long size)
 	flush_cache_vmap(start, start + size);
 }
 
-static int apply_range_clear_cb(pte_t *pte, unsigned long addr, void *data)
+static int apply_range_clear_cb(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct clear_range_data *d = data;
 	pte_t old_pte;
@@ -238,7 +238,8 @@ static int apply_range_clear_cb(pte_t *pte, unsigned long addr, void *data)
 	return 0;
 }
 
-static int apply_range_set_scratch_cb(pte_t *pte, unsigned long addr, void *data)
+static int apply_range_set_scratch_cb(hw_pte_t *pte, unsigned long addr,
+				      void *data)
 {
 	struct page *scratch_page = data;
 
@@ -340,7 +341,7 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
 	return ERR_PTR(err);
 }
 
-static int existing_page_cb(pte_t *ptep, unsigned long addr, void *data)
+static int existing_page_cb(hw_pte_t *ptep, unsigned long addr, void *data)
 {
 	struct bpf_arena *arena = data;
 	struct page *page;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6c8e38a31104..0369f6c95ba7d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8517,7 +8517,8 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 	p4d_t *p4dp, p4d;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 
 	pgdp = pgd_offset(mm, addr);
 	pgd = pgdp_get(pgdp);
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 7a2e40bc7baed..f844a44752a81 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -39,7 +39,7 @@ struct folio *damon_get_folio(unsigned long pfn)
 	return folio;
 }
 
-void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
+void damon_ptep_mkold(hw_pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
 {
 	pte_t pteval = ptep_get(pte);
 	struct folio *folio;
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 38d295488fa18..34b7e5715fcf9 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -7,7 +7,7 @@
 
 struct folio *damon_get_folio(unsigned long pfn);
 
-void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
+void damon_ptep_mkold(hw_pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
 void damon_folio_mkold(struct folio *folio);
 bool damon_folio_young(struct folio *folio);
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 0648400b2d65b..e32b914720d5c 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -268,7 +268,7 @@ static void damon_va_walk_page_range(struct mm_struct *mm, unsigned long start,
 static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
-	pte_t *pte;
+	hw_pte_t *pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmd, walk->vma);
@@ -293,7 +293,7 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
+static void damon_hugetlb_mkold(hw_pte_t *pte, struct mm_struct *mm,
 				struct vm_area_struct *vma, unsigned long addr)
 {
 	bool referenced = false;
@@ -320,7 +320,7 @@ static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
 	folio_put(folio);
 }
 
-static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
+static int damon_mkold_hugetlb_entry(hw_pte_t *pte, unsigned long hmask,
 				     unsigned long addr, unsigned long end,
 				     struct mm_walk *walk)
 {
@@ -389,7 +389,7 @@ struct damon_young_walk_private {
 static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
-	pte_t *pte;
+	hw_pte_t *pte;
 	pte_t ptent;
 	spinlock_t *ptl;
 	struct folio *folio;
@@ -433,7 +433,7 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
+static int damon_young_hugetlb_entry(hw_pte_t *pte, unsigned long hmask,
 				     unsigned long addr, unsigned long end,
 				     struct mm_walk *walk)
 {
@@ -522,7 +522,7 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 
 static bool damos_va_filter_young_match(struct damos_filter *filter,
 		struct folio *folio, struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pmd_t *pmdp)
+		unsigned long addr, hw_pte_t *ptep, pmd_t *pmdp)
 {
 	bool young = false;
 
@@ -544,7 +544,7 @@ static bool damos_va_filter_young_match(struct damos_filter *filter,
 
 static bool damos_va_filter_out(struct damos *scheme, struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pmd_t *pmdp)
+		hw_pte_t *ptep, pmd_t *pmdp)
 {
 	struct damos_filter *filter;
 	bool matched;
@@ -641,7 +641,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	spinlock_t *ptl;
-	pte_t *start_pte, *pte, ptent;
+	hw_pte_t *start_pte, *pte;
+	pte_t ptent;
 	int nr;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -801,7 +802,8 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	struct folio *folio;
 	spinlock_t *ptl;
-	pte_t *start_pte, *pte, ptent;
+	hw_pte_t *start_pte, *pte;
+	pte_t ptent;
 	int nr;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 2875fd22d7bb0..54e194d2a5854 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -50,7 +50,7 @@ struct pgtable_debug_args {
 	p4d_t			*p4dp;
 	pud_t			*pudp;
 	pmd_t			*pmdp;
-	pte_t			*ptep;
+	hw_pte_t		*ptep;
 
 	p4d_t			*start_p4dp;
 	pud_t			*start_pudp;
diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f550..98f89dcc55603 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3490,7 +3490,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 
 	/*
 	 * We might have COW'ed a pagecache folio and might now have an mlocked
@@ -3796,7 +3796,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	vm_fault_t ret = 0;
 	struct page *page = folio_page(folio, start);
 	unsigned int count = 0;
-	pte_t *old_ptep = vmf->pte;
+	hw_pte_t *old_ptep = vmf->pte;
 	unsigned long addr0;
 
 	/*
diff --git a/mm/gup.c b/mm/gup.c
index d1ba59da94e9a..549f462a23b2f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -761,7 +761,7 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 #endif	/* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 
 static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
-		pte_t *pte, unsigned int flags)
+		hw_pte_t *pte, unsigned int flags)
 {
 	if (flags & FOLL_TOUCH) {
 		pte_t orig_entry = ptep_get(pte);
@@ -806,7 +806,8 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	struct folio *folio;
 	struct page *page;
 	spinlock_t *ptl;
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 	int ret;
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
@@ -1035,7 +1036,7 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
+	hw_pte_t *pte;
 	pte_t entry;
 	int ret = -EFAULT;
 
@@ -2838,7 +2839,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		unsigned int flags, struct page **pages)
 {
 	unsigned long nr_pages = 0;
-	pte_t *ptep, *ptem;
+	hw_pte_t *ptep, *ptem;
 
 	ptem = ptep = pte_offset_map(&pmd, addr);
 	if (!ptep)
diff --git a/mm/highmem.c b/mm/highmem.c
index a33e411839517..87f94cac6106b 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -141,7 +141,7 @@ EXPORT_SYMBOL(__totalhigh_pages);
 static int pkmap_count[LAST_PKMAP];
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
 
-pte_t *pkmap_page_table;
+hw_pte_t *pkmap_page_table;
 
 /*
  * Most architectures have no use for kmap_high_get(), so let's abstract
@@ -532,9 +532,9 @@ static inline bool kmap_high_unmap_local(unsigned long vaddr)
 	return false;
 }
 
-static pte_t *__kmap_pte;
+static hw_pte_t *__kmap_pte;
 
-static pte_t *kmap_get_pte(unsigned long vaddr, int idx)
+static hw_pte_t *kmap_get_pte(unsigned long vaddr, int idx)
 {
 	if (IS_ENABLED(CONFIG_KMAP_LOCAL_NON_LINEAR_PTE_ARRAY))
 		/*
@@ -549,8 +549,9 @@ static pte_t *kmap_get_pte(unsigned long vaddr, int idx)
 
 void *__kmap_local_pfn_prot(unsigned long pfn, pgprot_t prot)
 {
-	pte_t pteval, *kmap_pte;
 	unsigned long vaddr;
+	hw_pte_t *kmap_pte;
+	pte_t pteval;
 	int idx;
 
 	/*
@@ -597,7 +598,7 @@ EXPORT_SYMBOL(__kmap_local_page_prot);
 void kunmap_local_indexed(const void *vaddr)
 {
 	unsigned long addr = (unsigned long) vaddr & PAGE_MASK;
-	pte_t *kmap_pte;
+	hw_pte_t *kmap_pte;
 	int idx;
 
 	if (addr < __fix_to_virt(FIX_KMAP_END) ||
@@ -646,7 +647,7 @@ EXPORT_SYMBOL(kunmap_local_indexed);
 void __kmap_local_sched_out(void)
 {
 	struct task_struct *tsk = current;
-	pte_t *kmap_pte;
+	hw_pte_t *kmap_pte;
 	int i;
 
 	/* Clear kmaps */
@@ -683,7 +684,7 @@ void __kmap_local_sched_out(void)
 void __kmap_local_sched_in(void)
 {
 	struct task_struct *tsk = current;
-	pte_t *kmap_pte;
+	hw_pte_t *kmap_pte;
 	int i;
 
 	/* Restore kmaps */
diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b6440..0c959611eda01 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -240,7 +240,7 @@ static inline unsigned long pte_to_hmm_pfn_flags(struct hmm_range *range,
 }
 
 static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
-			      unsigned long end, pmd_t *pmdp, pte_t *ptep,
+			      unsigned long end, pmd_t *pmdp, hw_pte_t *ptep,
 			      unsigned long *hmm_pfn)
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
@@ -411,7 +411,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
 	unsigned long npages = (end - start) >> PAGE_SHIFT;
 	unsigned long addr = start;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	pmd_t pmd;
 
 again:
@@ -547,7 +547,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 #endif
 
 #ifdef CONFIG_HUGETLB_PAGE
-static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
+static int hmm_vma_walk_hugetlb_entry(hw_pte_t *pte, unsigned long hmask,
 				      unsigned long start, unsigned long end,
 				      struct mm_walk *walk)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c5d11147b69ae..8466a52381991 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3146,7 +3146,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	pgtable_t pgtable;
 	pmd_t _pmd, old_pmd;
 	unsigned long addr;
-	pte_t *pte;
+	hw_pte_t *pte;
 	int i;
 
 	/*
@@ -3196,7 +3196,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	bool soft_dirty, uffd_wp = false, young = false, write = false;
 	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;
-	pte_t *pte;
+	hw_pte_t *pte;
 	int i;
 
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bfc0184ed95c7..c30e7584f1a5c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -129,7 +129,7 @@ static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static int __huge_pmd_unshare(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		struct vm_area_struct *vma, unsigned long addr, hw_pte_t *ptep,
 		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
@@ -4878,7 +4878,7 @@ static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
 }
 
 static void set_huge_ptep_writable(struct vm_area_struct *vma,
-				   unsigned long address, pte_t *ptep)
+				   unsigned long address, hw_pte_t *ptep)
 {
 	pte_t entry;
 
@@ -4888,14 +4888,14 @@ static void set_huge_ptep_writable(struct vm_area_struct *vma,
 }
 
 static void set_huge_ptep_maybe_writable(struct vm_area_struct *vma,
-					 unsigned long address, pte_t *ptep)
+					 unsigned long address, hw_pte_t *ptep)
 {
 	if (vma->vm_flags & VM_WRITE)
 		set_huge_ptep_writable(vma, address, ptep);
 }
 
 static void
-hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
+hugetlb_install_folio(struct vm_area_struct *vma, hw_pte_t *ptep, unsigned long addr,
 		      struct folio *new_folio, pte_t old, unsigned long sz)
 {
 	pte_t newpte = make_huge_pte(vma, new_folio, true);
@@ -4921,7 +4921,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *dst_vma,
 			    struct vm_area_struct *src_vma)
 {
-	pte_t *src_pte, *dst_pte, entry;
+	hw_pte_t *src_pte, *dst_pte;
+	pte_t entry;
 	struct folio *pte_folio;
 	unsigned long addr;
 	bool cow = vma_is_cow_mapping(src_vma);
@@ -5113,7 +5114,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 }
 
 static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
-			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
+			  unsigned long new_addr, hw_pte_t *src_pte,
+			  hw_pte_t *dst_pte,
 			  unsigned long sz)
 {
 	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
@@ -5175,7 +5177,7 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long old_end = old_addr + len;
 	unsigned long last_addr_mask;
-	pte_t *src_pte, *dst_pte;
+	hw_pte_t *src_pte, *dst_pte;
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
@@ -5236,7 +5238,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 	const bool folio_provided = !!folio;
 	unsigned long address;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	pte_t pte;
 	spinlock_t *ptl;
 	struct hstate *h = hstate_vma(vma);
@@ -5770,7 +5772,7 @@ static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
  * false if pte changed or is changing.
  */
 static bool hugetlb_pte_stable(struct hstate *h, struct mm_struct *mm, unsigned long addr,
-			       pte_t *ptep, pte_t old_pte)
+			       hw_pte_t *ptep, pte_t old_pte)
 {
 	spinlock_t *ptl;
 	bool same;
@@ -6295,7 +6297,7 @@ static struct folio *alloc_hugetlb_folio_vma(struct hstate *h,
  * Used by userfaultfd UFFDIO_* ioctls. Based on userfaultfd's mfill_atomic_pte
  * with modifications for hugetlb pages.
  */
-int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
+int hugetlb_mfill_atomic_pte(hw_pte_t *dst_pte,
 			     struct vm_area_struct *dst_vma,
 			     unsigned long dst_addr,
 			     unsigned long src_addr,
@@ -6354,7 +6356,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 
 		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
-			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
+			hw_pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
 			if (actual_pte) {
 				ret = -EEXIST;
 				goto out;
@@ -6522,7 +6524,7 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long start = address;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
 	long pages = 0, psize = huge_page_size(h);
@@ -7007,15 +7009,15 @@ void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
  * racing tasks could either miss the sharing (see huge_pte_offset) or select a
  * bad pmd for sharing.
  */
-pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
+hw_pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	const pgoff_t idx = linear_page_index(vma, addr);
 	struct vm_area_struct *svma;
 	unsigned long saddr;
-	pte_t *spte = NULL;
-	pte_t *pte;
+	hw_pte_t *spte = NULL;
+	hw_pte_t *pte;
 
 	i_mmap_lock_read(mapping);
 	mapping_rmap_tree_foreach(svma, mapping, idx, idx) {
@@ -7046,13 +7048,13 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 	spin_unlock(&mm->page_table_lock);
 out:
-	pte = (pte_t *)pmd_alloc(mm, pud, addr);
+	pte = (hw_pte_t *)pmd_alloc(mm, pud, addr);
 	i_mmap_unlock_read(mapping);
 	return pte;
 }
 
 static int __huge_pmd_unshare(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		struct vm_area_struct *vma, unsigned long addr, hw_pte_t *ptep,
 		bool check_locks)
 {
 	unsigned long sz = huge_page_size(hstate_vma(vma));
@@ -7093,7 +7095,7 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
  *	    was not a shared PMD table.
  */
 int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
+		unsigned long addr, hw_pte_t *ptep)
 {
 	return __huge_pmd_unshare(tlb, vma, addr, ptep, /*check_locks=*/true);
 }
@@ -7123,21 +7125,21 @@ void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma)
 
 #else /* !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
 
-pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
+hw_pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
 	return NULL;
 }
 
 static int __huge_pmd_unshare(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		struct vm_area_struct *vma, unsigned long addr, hw_pte_t *ptep,
 		bool check_locks)
 {
 	return 0;
 }
 
 int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
+		unsigned long addr, hw_pte_t *ptep)
 {
 	return 0;
 }
@@ -7158,13 +7160,13 @@ bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
 #endif /* CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
 
 #ifdef CONFIG_ARCH_WANT_GENERAL_HUGETLB
-pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+hw_pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
-	pte_t *pte = NULL;
+	hw_pte_t *pte = NULL;
 
 	pgd = pgd_offset(mm, addr);
 	p4d = p4d_alloc(mm, pgd, addr);
@@ -7173,13 +7175,13 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 	pud = pud_alloc(mm, p4d, addr);
 	if (pud) {
 		if (sz == PUD_SIZE) {
-			pte = (pte_t *)pud;
+			pte = (hw_pte_t *)pud;
 		} else {
 			BUG_ON(sz != PMD_SIZE);
 			if (want_pmd_share(vma, addr) && pud_none(*pud))
 				pte = huge_pmd_share(mm, vma, addr, pud);
 			else
-				pte = (pte_t *)pmd_alloc(mm, pud, addr);
+				pte = (hw_pte_t *)pmd_alloc(mm, pud, addr);
 		}
 	}
 
@@ -7201,7 +7203,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
  * size @sz doesn't match the hugepage size at this level of the page
  * table.
  */
-pte_t *huge_pte_offset(struct mm_struct *mm,
+hw_pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
@@ -7219,14 +7221,14 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 	pud = pud_offset(p4d, addr);
 	if (sz == PUD_SIZE)
 		/* must be pud huge, non-present or none */
-		return (pte_t *)pud;
+		return (hw_pte_t *)pud;
 	if (!pud_present(*pud))
 		return NULL;
 	/* must have a valid entry and size to go further */
 
 	pmd = pmd_offset(pud, addr);
 	/* must be pmd huge, non-present or none */
-	return (pte_t *)pmd;
+	return (hw_pte_t *)pmd;
 }
 
 /*
@@ -7405,7 +7407,7 @@ static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 	struct mmu_gather tlb;
 	unsigned long address;
 	spinlock_t *ptl;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index eb339c4a71f40..bf85d82c29b96 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -34,7 +34,7 @@
  *			operations.
  */
 struct vmemmap_remap_walk {
-	void			(*remap_pte)(pte_t *pte, unsigned long addr,
+	void			(*remap_pte)(hw_pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
 
 	unsigned long		nr_walked;
@@ -56,7 +56,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 	pmd_t __pmd;
 	int i;
 	unsigned long addr = start;
-	pte_t *pgtable;
+	hw_pte_t *pgtable;
 
 	pgtable = pte_alloc_one_kernel(&init_mm);
 	if (!pgtable)
@@ -65,7 +65,8 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 	pmd_populate_kernel(&init_mm, &__pmd, pgtable);
 
 	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE) {
-		pte_t entry, *pte;
+		pte_t entry;
+		hw_pte_t *pte;
 		pgprot_t pgprot = PAGE_KERNEL;
 
 		entry = mk_pte(head + i, pgprot);
@@ -137,7 +138,7 @@ static int vmemmap_pmd_entry(pmd_t *pmd, unsigned long addr,
 	return vmemmap_split_pmd(pmd, head, addr & PMD_MASK, vmemmap_walk);
 }
 
-static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
+static int vmemmap_pte_entry(hw_pte_t *pte, unsigned long addr,
 			     unsigned long next, struct mm_walk *walk)
 {
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
@@ -199,7 +200,7 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
+static void vmemmap_remap_pte(hw_pte_t *pte, unsigned long addr,
 			      struct vmemmap_remap_walk *walk)
 {
 	struct page *page = pte_page(ptep_get(pte));
@@ -233,7 +234,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 	set_pte_at(&init_mm, addr, pte, entry);
 }
 
-static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
+static void vmemmap_restore_pte(hw_pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
 	struct page *src = pte_page(ptep_get(pte)), *dst;
diff --git a/mm/internal.h b/mm/internal.h
index e16f1250b25c8..54efddc4536f4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -263,7 +263,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
 #ifdef CONFIG_MMU
 
 bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long addr, hw_pte_t *ptep, pte_t pte,
 		unsigned long nr_ptes);
 
 static inline void get_anon_vma(struct anon_vma *anon_vma)
@@ -394,7 +394,7 @@ static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
  * Return: the number of table entries in the batch.
  */
 static inline unsigned int folio_pte_batch_flags(struct folio *folio,
-		struct vm_area_struct *vma, pte_t *ptep, pte_t *ptentp,
+		struct vm_area_struct *vma, hw_pte_t *ptep, pte_t *ptentp,
 		unsigned int max_nr, fpb_t flags)
 {
 	bool any_writable = false, any_young = false, any_dirty = false;
@@ -448,7 +448,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 	return min(nr, max_nr);
 }
 
-unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
+unsigned int folio_pte_batch(struct folio *folio, hw_pte_t *ptep, pte_t pte,
 		unsigned int max_nr);
 
 /**
@@ -505,11 +505,11 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
  *
  * Return: the number of table entries in the batch.
  */
-static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
+static inline int swap_pte_batch(hw_pte_t *start_ptep, int max_nr, pte_t pte)
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
-	const pte_t *end_ptep = start_ptep + max_nr;
-	pte_t *ptep = start_ptep + 1;
+	const hw_pte_t *end_ptep = start_ptep + max_nr;
+	hw_pte_t *ptep = start_ptep + 1;
 
 	VM_WARN_ON(max_nr < 1);
 	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
@@ -1547,7 +1547,7 @@ static inline void maybe_rmap_unlock_action(struct vm_area_struct *vma,
 
 #ifdef CONFIG_MMU_NOTIFIER
 static inline bool clear_flush_young_ptes_notify(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	bool young;
 
@@ -1568,7 +1568,7 @@ static inline bool pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
 }
 
 static inline bool test_and_clear_young_ptes_notify(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	bool young;
 
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index 66a8838879876..30c5266eaf37e 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -92,7 +92,7 @@ static __init void *early_alloc(size_t size, int node)
 static void __ref zero_pte_populate(pmd_t *pmd, unsigned long addr,
 				unsigned long end)
 {
-	pte_t *pte = pte_offset_kernel(pmd, addr);
+	hw_pte_t *pte = pte_offset_kernel(pmd, addr);
 	pte_t zero_pte;
 
 	zero_pte = pfn_pte(PFN_DOWN(__pa_symbol(kasan_early_shadow_page)),
@@ -122,7 +122,7 @@ static int __ref zero_pmd_populate(pud_t *pud, unsigned long addr,
 		}
 
 		if (pmd_none(*pmd)) {
-			pte_t *p;
+			hw_pte_t *p;
 
 			if (slab_is_available())
 				p = pte_alloc_one_kernel(&init_mm);
@@ -281,9 +281,9 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
 	return 0;
 }
 
-static void kasan_free_pte(pte_t *pte_start, pmd_t *pmd)
+static void kasan_free_pte(hw_pte_t *pte_start, pmd_t *pmd)
 {
-	pte_t *pte;
+	hw_pte_t *pte;
 	int i;
 
 	for (i = 0; i < PTRS_PER_PTE; i++) {
@@ -341,7 +341,7 @@ static void kasan_free_p4d(p4d_t *p4d_start, pgd_t *pgd)
 	pgd_clear(pgd);
 }
 
-static void kasan_remove_pte_table(pte_t *pte, unsigned long addr,
+static void kasan_remove_pte_table(hw_pte_t *pte, unsigned long addr,
 				unsigned long end)
 {
 	unsigned long next;
@@ -369,7 +369,7 @@ static void kasan_remove_pmd_table(pmd_t *pmd, unsigned long addr,
 	unsigned long next;
 
 	for (; addr < end; addr = next, pmd++) {
-		pte_t *pte;
+		hw_pte_t *pte;
 
 		next = pmd_addr_end(addr, end);
 
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d286e0a045437..86fc7ed45dcd0 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -189,7 +189,7 @@ static bool shadow_mapped(unsigned long addr)
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
+	hw_pte_t *pte;
 
 	if (pgd_none(*pgd))
 		return false;
@@ -297,7 +297,7 @@ struct vmalloc_populate_data {
 	struct page **pages;
 };
 
-static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
+static int kasan_populate_vmalloc_pte(hw_pte_t *ptep, unsigned long addr,
 				      void *_data)
 {
 	struct vmalloc_populate_data *data = _data;
@@ -465,7 +465,7 @@ int __kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_m
 	return 0;
 }
 
-static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
+static int kasan_depopulate_vmalloc_pte(hw_pte_t *ptep, unsigned long addr,
 					void *unused)
 {
 	pte_t pte;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f49a6710933b1..4a7074f58b55d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -639,8 +639,8 @@ static void release_pte_folio(struct folio *folio)
 	folio_putback_lru(folio);
 }
 
-static void release_pte_pages(pte_t *pte, pte_t *_pte,
-		struct list_head *compound_pagelist)
+static void release_pte_pages(hw_pte_t *pte, hw_pte_t *_pte,
+			      struct list_head *compound_pagelist)
 {
 	struct folio *folio, *tmp;
 
@@ -685,7 +685,8 @@ static void count_collapse_event(unsigned int order, enum vm_event_item vm_event
 }
 
 static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
-		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
+		unsigned long start_addr, hw_pte_t *pte,
+		struct collapse_control *cc,
 		unsigned int order, struct list_head *compound_pagelist)
 {
 	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
@@ -694,7 +695,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
-	pte_t *_pte;
+	hw_pte_t *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 
@@ -840,16 +841,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	return result;
 }
 
-static void __collapse_huge_page_copy_succeeded(pte_t *pte,
-		struct vm_area_struct *vma, unsigned long address,
-		spinlock_t *ptl, unsigned int order,
-		struct list_head *compound_pagelist)
+static void __collapse_huge_page_copy_succeeded(hw_pte_t *pte,
+						struct vm_area_struct *vma,
+						unsigned long address,
+						spinlock_t *ptl,
+						unsigned int order,
+						struct list_head *compound_pagelist)
 {
 	const unsigned long nr_pages = 1UL << order;
 	unsigned long end = address + (PAGE_SIZE * nr_pages);
 	struct folio *src, *tmp;
 	pte_t pteval;
-	pte_t *_pte;
+	hw_pte_t *_pte;
 	unsigned int nr_ptes;
 
 	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
@@ -904,9 +907,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 	}
 }
 
-static void __collapse_huge_page_copy_failed(pte_t *pte,
-		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned int order, struct list_head *compound_pagelist)
+static void __collapse_huge_page_copy_failed(hw_pte_t *pte,
+					     pmd_t *pmd, pmd_t orig_pmd,
+					     struct vm_area_struct *vma,
+					     unsigned int order,
+					     struct list_head *compound_pagelist)
 {
 	const unsigned long nr_pages = 1UL << order;
 	spinlock_t *pmd_ptl;
@@ -942,10 +947,14 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
  * @ptl: lock on raw pages' PTEs
  * @compound_pagelist: list that stores compound pages
  */
-static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
-		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned long address, spinlock_t *ptl, unsigned int order,
-		struct list_head *compound_pagelist)
+static enum scan_result __collapse_huge_page_copy(hw_pte_t *pte,
+						  struct folio *folio,
+						  pmd_t *pmd, pmd_t orig_pmd,
+						  struct vm_area_struct *vma,
+						  unsigned long address,
+						  spinlock_t *ptl,
+						  unsigned int order,
+						  struct list_head *compound_pagelist)
 {
 	const unsigned long nr_pages = 1UL << order;
 	unsigned int i;
@@ -1164,7 +1173,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 	vm_fault_t ret = 0;
 	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
 	enum scan_result result;
-	pte_t *pte = NULL;
+	hw_pte_t *pte = NULL;
 	spinlock_t *ptl;
 
 	for (addr = start_addr; addr < end; addr += PAGE_SIZE) {
@@ -1292,7 +1301,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
-	pte_t *pte = NULL;
+	hw_pte_t *pte = NULL;
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
@@ -1606,7 +1615,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	pmd_t *pmd;
-	pte_t *pte, *_pte, pteval;
+	hw_pte_t *pte, *_pte;
+	pte_t pteval;
 	int i;
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
@@ -1871,7 +1881,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	unsigned long end = haddr + HPAGE_PMD_SIZE;
 	struct vm_area_struct *vma = vma_lookup(mm, haddr);
 	struct folio *folio;
-	pte_t *start_pte, *pte;
+	hw_pte_t *start_pte, *pte;
 	pmd_t *pmd, pgt_pmd;
 	spinlock_t *pml = NULL, *ptl;
 	int i;
diff --git a/mm/ksm.c b/mm/ksm.c
index 2a4f19fe0f696..3882d8916efa4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -618,7 +618,7 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
 {
 	unsigned long *found_addr = (unsigned long *) walk->private;
 	struct mm_struct *mm = walk->mm;
-	pte_t *start_ptep, *ptep;
+	hw_pte_t *start_ptep, *ptep;
 	spinlock_t *ptl;
 	int found = 0;
 
@@ -1399,7 +1399,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 	struct folio *folio = page_folio(page);
 	pmd_t *pmd;
 	pmd_t pmde;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	pte_t newpte;
 	spinlock_t *ptl;
 	unsigned long addr;
@@ -2530,7 +2530,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 {
 	struct ksm_next_page_arg *private = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *start_ptep = NULL, *ptep, pte;
+	hw_pte_t *start_ptep = NULL, *ptep;
+	pte_t pte;
 	struct mm_struct *mm = walk->mm;
 	struct folio *folio;
 	struct page *page;
diff --git a/mm/madvise.c b/mm/madvise.c
index dd75a673e108f..a08270c9f7610 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -198,7 +198,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 {
 	struct vm_area_struct *vma = walk->private;
 	struct swap_io_ctx ctx = {};
-	pte_t *ptep = NULL;
+	hw_pte_t *ptep = NULL;
 	spinlock_t *ptl;
 	unsigned long addr;
 
@@ -350,7 +350,7 @@ static inline bool can_do_file_pageout(struct vm_area_struct *vma)
 }
 
 static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
-					  struct folio *folio, pte_t *ptep,
+					  struct folio *folio, hw_pte_t *ptep,
 					  pte_t *ptentp)
 {
 	int max_nr = (end - addr) / PAGE_SIZE;
@@ -368,7 +368,8 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 	bool pageout = private->pageout;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *start_pte, *pte, ptent;
+	hw_pte_t *start_pte, *pte;
+	pte_t ptent;
 	spinlock_t *ptl;
 	struct folio *folio = NULL;
 	LIST_HEAD(folio_list);
@@ -670,7 +671,8 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
-	pte_t *start_pte, *pte, ptent;
+	hw_pte_t *start_pte, *pte;
+	pte_t ptent;
 	struct folio *folio;
 	int nr_swap = 0;
 	unsigned long next;
@@ -1095,7 +1097,7 @@ static int guard_install_pmd_entry(pmd_t *pmd, unsigned long addr,
 	return pmd_trans_huge(pmdval);
 }
 
-static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
+static int guard_install_pte_entry(hw_pte_t *pte, unsigned long addr,
 				   unsigned long next, struct mm_walk *walk)
 {
 	pte_t pteval = ptep_get(pte);
@@ -1238,7 +1240,7 @@ static int guard_remove_pmd_entry(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
-static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
+static int guard_remove_pte_entry(hw_pte_t *pte, unsigned long addr,
 				  unsigned long next, struct mm_walk *walk)
 {
 	pte_t ptent = ptep_get(pte);
diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
index e0efa36e0a076..dcbd39912f819 100644
--- a/mm/mapping_dirty_helpers.c
+++ b/mm/mapping_dirty_helpers.c
@@ -31,7 +31,7 @@ struct wp_walk {
  * The function write-protects a pte and records the range in
  * virtual address space of touched ptes for efficient range TLB flushes.
  */
-static int wp_pte(pte_t *pte, unsigned long addr, unsigned long end,
+static int wp_pte(hw_pte_t *pte, unsigned long addr, unsigned long end,
 		  struct mm_walk *walk)
 {
 	struct wp_walk *wpwalk = walk->private;
@@ -86,7 +86,7 @@ struct clean_walk {
  * in the address_space, as well as the first and last of the bits
  * touched.
  */
-static int clean_record_pte(pte_t *pte, unsigned long addr,
+static int clean_record_pte(hw_pte_t *pte, unsigned long addr,
 			    unsigned long end, struct mm_walk *walk)
 {
 	struct wp_walk *wpwalk = walk->private;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba8..a89f3fde47a5d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -342,7 +342,7 @@ static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
+	hw_pte_t *pte;
 	pte_t ptent;
 
 	VM_BUG_ON_VMA(address == -EFAULT, vma);
@@ -742,7 +742,7 @@ static int hwpoison_pte_range(pmd_t *pmdp, unsigned long addr,
 {
 	struct hwpoison_walk *hwp = walk->private;
 	int ret = 0;
-	pte_t *ptep, *mapped_pte;
+	hw_pte_t *ptep, *mapped_pte;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmdp, walk->vma);
@@ -770,7 +770,7 @@ static int hwpoison_pte_range(pmd_t *pmdp, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
+static int hwpoison_hugetlb_range(hw_pte_t *ptep, unsigned long hmask,
 			    unsigned long addr, unsigned long end,
 			    struct mm_walk *walk)
 {
diff --git a/mm/memory.c b/mm/memory.c
index ec63dd6212ac5..7fc8ce10503c3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -462,7 +462,7 @@ int __pte_alloc(struct mm_struct *mm, pmd_t *pmd)
 
 int __pte_alloc_kernel(pmd_t *pmd)
 {
-	pte_t *new = pte_alloc_one_kernel(&init_mm);
+	hw_pte_t *new = pte_alloc_one_kernel(&init_mm);
 	if (!new)
 		return -ENOMEM;
 
@@ -909,7 +909,7 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma,
  */
 static void restore_exclusive_pte(struct vm_area_struct *vma,
 		struct folio *folio, struct page *page, unsigned long address,
-		pte_t *ptep, pte_t orig_pte)
+		hw_pte_t *ptep, pte_t orig_pte)
 {
 	pte_t pte;
 
@@ -946,7 +946,7 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
  * sleeping.
  */
 static int try_restore_exclusive_pte(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t orig_pte)
+		unsigned long addr, hw_pte_t *ptep, pte_t orig_pte)
 {
 	const softleaf_t entry = softleaf_from_pte(orig_pte);
 	struct page *page = softleaf_to_page(entry);
@@ -969,7 +969,7 @@ static int try_restore_exclusive_pte(struct vm_area_struct *vma,
 
 static unsigned long
 copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *dst_vma,
+		hw_pte_t *dst_pte, hw_pte_t *src_pte, struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, unsigned long addr, int *rss)
 {
 	pte_t orig_pte = ptep_get(src_pte);
@@ -1083,7 +1083,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
  */
 static inline int
 copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
-		  pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
+		  hw_pte_t *dst_pte, hw_pte_t *src_pte, unsigned long addr, int *rss,
 		  struct folio **prealloc, struct page *page)
 {
 	struct folio *new_folio;
@@ -1122,7 +1122,7 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 }
 
 static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
-		struct vm_area_struct *src_vma, pte_t *dst_pte, pte_t *src_pte,
+		struct vm_area_struct *src_vma, hw_pte_t *dst_pte, hw_pte_t *src_pte,
 		pte_t pte, unsigned long addr, int nr)
 {
 	struct mm_struct *src_mm = src_vma->vm_mm;
@@ -1172,7 +1172,7 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
  */
 static inline int
 copy_present_ptes(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
-		 pte_t *dst_pte, pte_t *src_pte, pte_t pte, unsigned long addr,
+		 hw_pte_t *dst_pte, hw_pte_t *src_pte, pte_t pte, unsigned long addr,
 		 int max_nr, int *rss, struct folio **prealloc)
 {
 	fpb_t flags = FPB_MERGE_WRITE;
@@ -1272,8 +1272,8 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	struct mm_struct *src_mm = src_vma->vm_mm;
-	pte_t *orig_src_pte, *orig_dst_pte;
-	pte_t *src_pte, *dst_pte;
+	hw_pte_t *orig_src_pte, *orig_dst_pte;
+	hw_pte_t *src_pte, *dst_pte;
 	pmd_t dummy_pmdval;
 	pte_t ptent;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -1666,7 +1666,7 @@ static inline bool zap_drop_markers(struct zap_details *details)
  * Returns true if uffd-wp PTEs were installed, false otherwise.
  */
 bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t pte,
+		unsigned long addr, hw_pte_t *ptep, pte_t pte,
 		unsigned long nr_ptes)
 {
 	bool arm_uffd_pte = false;
@@ -1720,7 +1720,7 @@ bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
  */
 static inline bool
 zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
-			      unsigned long addr, pte_t *pte, int nr,
+			      unsigned long addr, hw_pte_t *pte, int nr,
 			      struct zap_details *details, pte_t pteval)
 {
 	if (zap_drop_markers(details))
@@ -1731,7 +1731,7 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
 
 static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, struct folio *folio,
-		struct page *page, pte_t *pte, pte_t ptent, unsigned int nr,
+		struct page *page, hw_pte_t *pte, pte_t ptent, unsigned int nr,
 		unsigned long addr, struct zap_details *details, int *rss,
 		bool *force_flush, bool *force_break, bool *any_skipped)
 {
@@ -1781,7 +1781,7 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
  * Returns the number of processed (skipped or zapped) PTEs (at least 1).
  */
 static inline int zap_present_ptes(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
+		struct vm_area_struct *vma, hw_pte_t *pte, pte_t ptent,
 		unsigned int max_nr, unsigned long addr,
 		struct zap_details *details, int *rss, bool *force_flush,
 		bool *force_break, bool *any_skipped)
@@ -1827,7 +1827,7 @@ static inline int zap_present_ptes(struct mmu_gather *tlb,
 }
 
 static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, pte_t *pte, pte_t ptent,
+		struct vm_area_struct *vma, hw_pte_t *pte, pte_t ptent,
 		unsigned int max_nr, unsigned long addr,
 		struct zap_details *details, int *rss, bool *any_skipped)
 {
@@ -1898,7 +1898,7 @@ static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
 }
 
 static inline int do_zap_pte_range(struct mmu_gather *tlb,
-				   struct vm_area_struct *vma, pte_t *pte,
+				   struct vm_area_struct *vma, hw_pte_t *pte,
 				   unsigned long addr, unsigned long end,
 				   struct zap_details *details, int *rss,
 				   bool *force_flush, bool *force_break,
@@ -1961,7 +1961,7 @@ static bool zap_pte_table_if_empty(struct mm_struct *mm, pmd_t *pmd,
 		unsigned long addr, pmd_t *pmdval)
 {
 	spinlock_t *pml, *ptl = NULL;
-	pte_t *start_pte, *pte;
+	hw_pte_t *start_pte, *pte;
 	int i;
 
 	pml = pmd_lock(mm, pmd);
@@ -2001,8 +2001,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	struct mm_struct *mm = tlb->mm;
 	int rss[NR_MM_COUNTERS];
 	spinlock_t *ptl;
-	pte_t *start_pte;
-	pte_t *pte;
+	hw_pte_t *start_pte;
+	hw_pte_t *pte;
 	pmd_t pmdval;
 	unsigned long start = addr;
 	bool direct_reclaim = true;
@@ -2384,7 +2384,7 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	return pmd;
 }
 
-pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
+hw_pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 		      spinlock_t **ptl)
 {
 	pmd_t *pmd = walk_to_pmd(mm, addr);
@@ -2442,7 +2442,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
 	return 0;
 }
 
-static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
+static int insert_page_into_pte_locked(struct vm_area_struct *vma, hw_pte_t *pte,
 				unsigned long addr, struct page *page,
 				pgprot_t prot, bool mkwrite)
 {
@@ -2487,7 +2487,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 			struct page *page, pgprot_t prot, bool mkwrite)
 {
 	int retval;
-	pte_t *pte;
+	hw_pte_t *pte;
 	spinlock_t *ptl;
 
 	retval = validate_page_before_insert(vma, page);
@@ -2504,7 +2504,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 	return retval;
 }
 
-static int insert_page_in_batch_locked(struct vm_area_struct *vma, pte_t *pte,
+static int insert_page_in_batch_locked(struct vm_area_struct *vma, hw_pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
 	int err;
@@ -2522,7 +2522,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num, pgprot_t prot)
 {
 	pmd_t *pmd = NULL;
-	pte_t *start_pte, *pte;
+	hw_pte_t *start_pte, *pte;
 	spinlock_t *pte_lock;
 	struct mm_struct *const mm = vma->vm_mm;
 	unsigned long curr_page_idx = 0;
@@ -2765,7 +2765,8 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn, pgprot_t prot, bool mkwrite)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pte_t *pte, entry;
+	hw_pte_t *pte;
+	pte_t entry;
 	spinlock_t *ptl;
 
 	pte = get_locked_pte(mm, addr, &ptl);
@@ -3006,7 +3007,7 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
 			unsigned long pfn, pgprot_t prot)
 {
-	pte_t *pte, *mapped_pte;
+	hw_pte_t *pte, *mapped_pte;
 	spinlock_t *ptl;
 	int err = 0;
 
@@ -3407,7 +3408,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     pte_fn_t fn, void *data, bool create,
 				     pgtbl_mod_mask *mask)
 {
-	pte_t *pte, *mapped_pte;
+	hw_pte_t *pte, *mapped_pte;
 	int err = 0;
 	spinlock_t *ptl;
 
@@ -4710,7 +4711,7 @@ static vm_fault_t handle_pte_marker(struct vm_fault *vmf)
 /*
  * Check if the PTEs within a range are contiguous swap entries.
  */
-static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
+static bool can_swapin_thp(struct vm_fault *vmf, hw_pte_t *ptep, int nr_pages)
 {
 	unsigned long addr;
 	int idx;
@@ -4762,7 +4763,7 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	unsigned long addr;
 	softleaf_t entry;
 	spinlock_t *ptl;
-	pte_t *pte;
+	hw_pte_t *pte;
 	int order;
 
 	/*
@@ -4856,7 +4857,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	int nr_pages;
 	unsigned long page_idx;
 	unsigned long address;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 
 	if (!pte_unmap_same(vmf))
 		goto out;
@@ -5025,7 +5026,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		unsigned long idx = folio_page_idx(folio, page);
 		unsigned long folio_start = address - idx * PAGE_SIZE;
 		unsigned long folio_end = folio_start + nr * PAGE_SIZE;
-		pte_t *folio_ptep;
+		hw_pte_t *folio_ptep;
 		pte_t folio_pte;
 
 		if (unlikely(folio_start < max(address & PMD_MASK, vma->vm_start)))
@@ -5255,7 +5256,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	return ret;
 }
 
-static bool pte_range_none(pte_t *pte, int nr_pages)
+static bool pte_range_none(hw_pte_t *pte, int nr_pages)
 {
 	int i;
 
@@ -5274,7 +5275,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	unsigned long orders;
 	struct folio *folio;
 	unsigned long addr;
-	pte_t *pte;
+	hw_pte_t *pte;
 	gfp_t gfp;
 	int order;
 
@@ -5356,7 +5357,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
 }
 
-void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
+void map_anon_folio_pte_nopf(struct folio *folio, hw_pte_t *pte,
 		struct vm_area_struct *vma, unsigned long addr,
 		bool uffd_wp)
 {
@@ -5377,7 +5378,7 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
 }
 
-static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
+static void map_anon_folio_pte_pf(struct folio *folio, hw_pte_t *pte,
 		struct vm_area_struct *vma, unsigned long addr, bool uffd_wp)
 {
 	const unsigned int order = folio_order(folio);
@@ -6162,7 +6163,7 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 }
 
 static void numa_rebuild_single_mapping(struct vm_fault *vmf, struct vm_area_struct *vma,
-					unsigned long fault_addr, pte_t *fault_pte,
+					unsigned long fault_addr, hw_pte_t *fault_pte,
 					bool writable)
 {
 	pte_t pte, old_pte;
@@ -6184,7 +6185,7 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 	unsigned long start, end, addr = vmf->address;
 	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
 	unsigned long pt_start = ALIGN_DOWN(addr, PMD_SIZE);
-	pte_t *start_ptep;
+	hw_pte_t *start_ptep;
 
 	/* Stay within the VMA and within the page table. */
 	start = max3(addr_start, pt_start, vma->vm_start);
@@ -6944,7 +6945,7 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
-				     spinlock_t *lock, pte_t *ptep,
+				     spinlock_t *lock, hw_pte_t *ptep,
 				     pgprot_t pgprot, unsigned long pfn_base,
 				     unsigned long addr_mask, bool writable,
 				     bool special)
@@ -7013,7 +7014,8 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
 	p4d_t *p4dp, p4d;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 
 	pfnmap_lockdep_assert(vma);
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2ad0a5f18280a..51ab12fa4cb61 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -710,7 +710,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
-	pte_t *pte, *mapped_pte;
+	hw_pte_t *pte, *mapped_pte;
 	pte_t ptent;
 	spinlock_t *ptl;
 	int max_nr, nr;
@@ -790,7 +790,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
-static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
+static int queue_folios_hugetlb(hw_pte_t *pte, unsigned long hmask,
 			       unsigned long addr, unsigned long end,
 			       struct mm_walk *walk)
 {
diff --git a/mm/migrate.c b/mm/migrate.c
index a369d0c95c386..75b4b637290c2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -494,7 +494,7 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 			  unsigned long address)
 {
 	spinlock_t *ptl;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	pte_t pte;
 	softleaf_t entry;
 
@@ -525,7 +525,7 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
  *
  * This function will release the vma lock before returning.
  */
-void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr, hw_pte_t *ptep)
 {
 	spinlock_t *ptl = huge_pte_lockptr(hstate_vma(vma), vma->vm_mm, ptep);
 	softleaf_t entry;
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d5..6138833fa902b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -254,7 +254,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	spinlock_t *ptl;
 	struct folio *fault_folio = migrate->fault_page ?
 		page_folio(migrate->fault_page) : NULL;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 
 again:
 	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
@@ -989,7 +989,7 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 	p4d_t *p4dp;
 	pud_t *pudp;
 	pmd_t *pmdp;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	pte_t orig_pte;
 
 	/* Only allow populating anonymous memory */
diff --git a/mm/mincore.c b/mm/mincore.c
index c086836bc4bcc..65cc43c85d03f 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -24,7 +24,7 @@
 #include "swap.h"
 #include "internal.h"
 
-static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
+static int mincore_hugetlb(hw_pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
 #ifdef CONFIG_HUGETLB_PAGE
@@ -164,7 +164,7 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 {
 	spinlock_t *ptl;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	unsigned char *vec = walk->private;
 	int nr = (end - addr) >> PAGE_SHIFT;
 	int step, i;
diff --git a/mm/mlock.c b/mm/mlock.c
index efa6716e4dfbd..36002b80382a9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -305,7 +305,7 @@ void munlock_folio(struct folio *folio)
 }
 
 static inline unsigned int folio_mlock_step(struct folio *folio,
-		pte_t *pte, unsigned long addr, unsigned long end)
+		hw_pte_t *pte, unsigned long addr, unsigned long end)
 {
 	unsigned int count = (end - addr) >> PAGE_SHIFT;
 	pte_t ptent = ptep_get(pte);
@@ -353,7 +353,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 {
 	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
-	pte_t *start_pte, *pte;
+	hw_pte_t *start_pte, *pte;
 	pte_t ptent;
 	struct folio *folio;
 	unsigned int step = 1;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d872..1d23475e0bb76 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 	return can_change_shared_pte_writable(vma, pte);
 }
 
-static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
+static int mprotect_folio_pte_batch(struct folio *folio, hw_pte_t *ptep,
 				    pte_t pte, int max_nr_ptes, fpb_t flags)
 {
 	/* No underlying folio, so cannot batch */
@@ -118,7 +118,7 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 
 /* Set nr_ptes number of ptes, starting from idx */
 static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
+		unsigned long addr, hw_pte_t *ptep, pte_t oldpte, pte_t ptent,
 		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
 {
 	/*
@@ -170,7 +170,7 @@ static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
  * retrieve sub-batches.
  */
 static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
-		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *first_page, unsigned long addr, hw_pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
 	bool expected_anon_exclusive;
@@ -189,7 +189,7 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 }
 
 static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
-		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
+		struct folio *folio, struct page *page, unsigned long addr, hw_pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
 	bool set_write;
@@ -212,7 +212,7 @@ static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_stru
 }
 
 static long change_softleaf_pte(struct vm_area_struct *vma,
-	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
+	unsigned long addr, hw_pte_t *pte, pte_t oldpte, unsigned long cp_flags)
 {
 	const bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);
 	const bool uffd_prot_resolve = cp_flags &
@@ -279,7 +279,7 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 }
 
 static __always_inline void change_present_ptes(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		struct vm_area_struct *vma, unsigned long addr, hw_pte_t *ptep,
 		int nr_ptes, unsigned long end, pgprot_t newprot,
 		struct folio *folio, struct page *page, unsigned long cp_flags)
 {
@@ -332,7 +332,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
-	pte_t *pte, oldpte;
+	hw_pte_t *pte;
+	pte_t oldpte;
 	spinlock_t *ptl;
 	long pages = 0;
 	bool is_private_single_threaded;
@@ -727,7 +728,7 @@ long change_protection(struct mmu_gather *tlb,
 	return pages;
 }
 
-static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
+static int prot_none_pte_entry(hw_pte_t *pte, unsigned long addr,
 			       unsigned long next, struct mm_walk *walk)
 {
 	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
@@ -736,7 +737,7 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
+static int prot_none_hugetlb_entry(hw_pte_t *pte, unsigned long hmask,
 				   unsigned long addr, unsigned long next,
 				   struct mm_walk *walk)
 {
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe2..5272cea12f80e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -176,7 +176,7 @@ static pte_t move_soft_dirty_pte(pte_t pte)
 }
 
 static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pte_t pte, int max_nr)
+		hw_pte_t *ptep, pte_t pte, int max_nr)
 {
 	struct folio *folio;
 
@@ -200,7 +200,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 	struct vm_area_struct *vma = pmc->old;
 	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
-	pte_t *old_ptep, *new_ptep;
+	hw_pte_t *old_ptep, *new_ptep;
 	pte_t old_pte, pte;
 	pmd_t dummy_pmdval;
 	spinlock_t *old_ptl, *new_ptl;
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 143a918c0bde2..705794a817bad 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -208,7 +208,7 @@ static void page_table_check_pte_flags(pte_t pte)
 }
 
 void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
-				 pte_t *ptep, pte_t pte, unsigned int nr)
+				 hw_pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	unsigned int i;
 
@@ -279,7 +279,7 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 		return;
 
 	if (!pmd_none(pmd) && !pmd_bad(pmd) && !pmd_leaf(pmd)) {
-		pte_t *ptep = pte_offset_map(&pmd, addr);
+		hw_pte_t *ptep = pte_offset_map(&pmd, addr);
 		unsigned long i;
 
 		if (WARN_ON(!ptep))
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 7411702a37f58..b6a29a06a19bc 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -26,7 +26,7 @@ static int real_depth(int depth)
 	return depth;
 }
 
-static int walk_pte_range_inner(pte_t *pte, unsigned long addr,
+static int walk_pte_range_inner(hw_pte_t *pte, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
 	const struct mm_walk_ops *ops = walk->ops;
@@ -61,7 +61,7 @@ static int walk_pte_range_inner(pte_t *pte, unsigned long addr,
 static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
 {
-	pte_t *pte;
+	hw_pte_t *pte;
 	int err = 0;
 	spinlock_t *ptl;
 
@@ -341,7 +341,7 @@ static int walk_hugetlb_range(unsigned long addr, unsigned long end,
 	unsigned long next;
 	unsigned long hmask = huge_page_mask(h);
 	unsigned long sz = huge_page_size(h);
-	pte_t *pte;
+	hw_pte_t *pte;
 	const struct mm_walk_ops *ops = walk->ops;
 	int err = 0;
 
@@ -905,7 +905,8 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	struct page *page;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 	spinlock_t *ptl;
 	pgd_t *pgdp;
 	p4d_t *p4dp;
diff --git a/mm/percpu.c b/mm/percpu.c
index 47a903fe3b512..197a786e1c5cf 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3176,7 +3176,7 @@ void __init __weak pcpu_populate_pte(unsigned long addr)
 
 	pmd = pmd_offset(pud, addr);
 	if (!pmd_present(*pmd)) {
-		pte_t *new;
+		hw_pte_t *new;
 
 		new = memblock_alloc_or_panic(PTE_TABLE_SIZE, PTE_TABLE_SIZE);
 		pmd_populate_kernel(&init_mm, pmd, new);
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 224c444cf45d9..df548ad3d9a54 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -80,7 +80,7 @@ void pmd_clear_bad(pmd_t *pmd)
  * force that call on sun4c so we changed this macro slightly
  */
 int ptep_set_access_flags(struct vm_area_struct *vma,
-			  unsigned long address, pte_t *ptep,
+			  unsigned long address, hw_pte_t *ptep,
 			  pte_t entry, int dirty)
 {
 	int changed = !pte_same(ptep_get(ptep), entry);
@@ -94,7 +94,7 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 bool ptep_clear_flush_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+		unsigned long address, hw_pte_t *ptep)
 {
 	bool young;
 
@@ -107,7 +107,7 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
 pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
-		       pte_t *ptep)
+		       hw_pte_t *ptep)
 {
 	struct mm_struct *mm = (vma)->vm_mm;
 	pte_t pte;
@@ -294,7 +294,7 @@ static unsigned long pmdp_get_lockless_start(void) { return 0; }
 static void pmdp_get_lockless_end(unsigned long irqflags) { }
 #endif
 
-pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
+hw_pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 {
 	unsigned long irqflags;
 	pmd_t pmdval;
@@ -320,11 +320,11 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 	return NULL;
 }
 
-pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
+hw_pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, spinlock_t **ptlp)
 {
 	pmd_t pmdval;
-	pte_t *pte;
+	hw_pte_t *pte;
 
 	pte = __pte_offset_map(pmd, addr, &pmdval);
 	if (likely(pte))
@@ -332,11 +332,11 @@ pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
 	return pte;
 }
 
-pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
+hw_pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, pmd_t *pmdvalp,
 				spinlock_t **ptlp)
 {
-	pte_t *pte;
+	hw_pte_t *pte;
 
 	VM_WARN_ON_ONCE(!pmdvalp);
 	pte = __pte_offset_map(pmd, addr, pmdvalp);
@@ -402,12 +402,12 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
  * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
  * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
  */
-pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
+hw_pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 			   unsigned long addr, spinlock_t **ptlp)
 {
 	spinlock_t *ptl;
 	pmd_t pmdval;
-	pte_t *pte;
+	hw_pte_t *pte;
 again:
 	pte = __pte_offset_map(pmd, addr, &pmdval);
 	if (unlikely(!pte))
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 5851096e6f656..376880071ca2a 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -117,7 +117,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
-static int ptdump_pte_entry(pte_t *pte, unsigned long addr,
+static int ptdump_pte_entry(hw_pte_t *pte, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
diff --git a/mm/rmap.c b/mm/rmap.c
index b5cc9273fe5a4..0223c4ab0b361 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1122,7 +1122,7 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 
 		address = pvmw->address;
 		if (pvmw->pte) {
-			pte_t *pte = pvmw->pte;
+			hw_pte_t *pte = pvmw->pte;
 			pte_t entry = ptep_get(pte);
 
 			/*
@@ -2139,7 +2139,7 @@ static pte_t swp_pte_prepare(swp_entry_t entry, pte_t old_pte,
 
 static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 		struct folio *folio, struct page *page, unsigned long address,
-		pte_t *ptep, pte_t pteval)
+		hw_pte_t *ptep, pte_t pteval)
 {
 	const bool anon_exclusive = folio_test_anon(folio) &&
 				    PageAnonExclusive(page);
@@ -2174,7 +2174,7 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 }
 
 static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
-		struct page *page, unsigned long address, pte_t *ptep,
+		struct page *page, unsigned long address, hw_pte_t *ptep,
 		pte_t pteval, unsigned long nr_pages)
 {
 	/*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e62e6aa07f126..77eb1749e123f 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -135,7 +135,7 @@ static void * __meminit altmap_alloc_block_buf(unsigned long size,
 	return __va(__pfn_to_phys(pfn));
 }
 
-void __meminit vmemmap_verify(pte_t *pte, int node,
+void __meminit vmemmap_verify(hw_pte_t *pte, int node,
 				unsigned long start, unsigned long end)
 {
 	unsigned long pfn = pte_pfn(ptep_get(pte));
@@ -236,11 +236,11 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
 	return page_address(page);
 }
 
-static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
+static hw_pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
 {
-	pte_t *pte = pte_offset_kernel(pmd, addr);
+	hw_pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
 
 	if (pte_none(ptep_get(pte))) {
@@ -323,7 +323,7 @@ static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	return pgd;
 }
 
-static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
+static hw_pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
 					      unsigned long ptpfn,
 					      unsigned long flags)
@@ -332,7 +332,7 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
+	hw_pte_t *pte;
 
 	pgd = vmemmap_pgd_populate(addr, node);
 	if (!pgd)
@@ -361,7 +361,7 @@ static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long flags)
 {
 	unsigned long addr = start;
-	pte_t *pte;
+	hw_pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
 		pte = vmemmap_populate_address(addr, node, altmap,
@@ -394,7 +394,7 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 				    int node, unsigned long headsize)
 {
 	unsigned long maddr;
-	pte_t *pte;
+	hw_pte_t *pte;
 
 	for (maddr = addr + headsize; maddr < end; maddr += PAGE_SIZE) {
 		pte = virt_to_kpte(maddr);
@@ -413,7 +413,7 @@ int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 {
 	if (!pmd_leaf(pmdp_get(pmd)))
 		return 0;
-	vmemmap_verify((pte_t *)pmd, node, addr, next);
+	vmemmap_verify((hw_pte_t *)pmd, node, addr, next);
 
 	return 1;
 }
@@ -497,9 +497,9 @@ static bool __meminit reuse_compound_section(unsigned long start_pfn,
 	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
 }
 
-static pte_t * __meminit compound_section_tail_page(unsigned long addr)
+static hw_pte_t * __meminit compound_section_tail_page(unsigned long addr)
 {
-	pte_t *pte;
+	hw_pte_t *pte;
 
 	addr -= PAGE_SIZE;
 
@@ -520,7 +520,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     struct dev_pagemap *pgmap)
 {
 	unsigned long size, addr;
-	pte_t *pte;
+	hw_pte_t *pte;
 	int rc;
 
 	if (reuse_compound_section(start_pfn, pgmap)) {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 305877e1f4d7b..d654449f393e8 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -918,7 +918,8 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	struct swap_io_ctx ctx = {};
 	struct blk_plug plug;
 	struct folio *folio;
-	pte_t *pte = NULL, pentry;
+	hw_pte_t *pte = NULL;
+	pte_t pentry;
 	int win;
 	unsigned long start, end, addr;
 	pgoff_t ilx = targ_ilx;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 869a918b18e8e..2f6aa8dc2f5bb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2500,7 +2500,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	struct page *page;
 	struct folio *swapcache;
 	spinlock_t *ptl;
-	pte_t *pte, new_pte, old_pte;
+	hw_pte_t *pte;
+	pte_t new_pte, old_pte;
 	bool hwpoisoned = false;
 	int ret = 1;
 
@@ -2611,7 +2612,7 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
 			unsigned int type)
 {
-	pte_t *pte = NULL;
+	hw_pte_t *pte = NULL;
 
 	do {
 		struct folio *folio;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 79cc7b546f130..8281796638c0a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -334,13 +334,13 @@ static int mfill_atomic_install_pte(pmd_t *dst_pmd,
 {
 	int ret;
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
-	pte_t _dst_pte, *dst_pte;
+	hw_pte_t *dst_pte;
 	bool writable = dst_vma->vm_flags & VM_WRITE;
 	bool vm_shared = dst_vma->vm_flags & VM_SHARED;
 	spinlock_t *ptl;
 	struct folio *folio = page_folio(page);
 	bool page_in_cache = folio_mapping(folio);
-	pte_t dst_ptep;
+	pte_t _dst_pte, dst_ptep;
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
 	_dst_pte = pte_mkdirty(_dst_pte);
@@ -629,7 +629,8 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 	struct vm_area_struct *dst_vma = state->vma;
 	unsigned long dst_addr = state->dst_addr;
 	pmd_t *dst_pmd = state->pmd;
-	pte_t _dst_pte, *dst_pte;
+	hw_pte_t *dst_pte;
+	pte_t _dst_pte;
 	spinlock_t *ptl;
 	int ret;
 
@@ -710,7 +711,8 @@ static int mfill_atomic_pte_poison(struct mfill_state *state)
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	unsigned long dst_addr = state->dst_addr;
 	pmd_t *dst_pmd = state->pmd;
-	pte_t _dst_pte, *dst_pte;
+	hw_pte_t *dst_pte;
+	pte_t _dst_pte;
 	spinlock_t *ptl;
 	int ret;
 
@@ -757,7 +759,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
 	ssize_t err;
-	pte_t *dst_pte;
+	hw_pte_t *dst_pte;
 	unsigned long src_addr, dst_addr;
 	long copied;
 	struct folio *folio;
@@ -1234,7 +1236,7 @@ void double_pt_unlock(spinlock_t *ptl1,
 		__release(ptl2);
 }
 
-static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
+static inline bool is_pte_pages_stable(hw_pte_t *dst_pte, hw_pte_t *src_pte,
 				       pte_t orig_dst_pte, pte_t orig_src_pte,
 				       pmd_t *dst_pmd, pmd_t dst_pmdval)
 {
@@ -1252,7 +1254,8 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
  */
 static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
 						 unsigned long src_addr,
-						 pte_t *src_pte, pte_t *dst_pte)
+						 hw_pte_t *src_pte,
+						 hw_pte_t *dst_pte)
 {
 	pte_t orig_dst_pte, orig_src_pte;
 	struct folio *folio;
@@ -1283,7 +1286,7 @@ static long move_present_ptes(struct mm_struct *mm,
 			      struct vm_area_struct *dst_vma,
 			      struct vm_area_struct *src_vma,
 			      unsigned long dst_addr, unsigned long src_addr,
-			      pte_t *dst_pte, pte_t *src_pte,
+			      hw_pte_t *dst_pte, hw_pte_t *src_pte,
 			      pte_t orig_dst_pte, pte_t orig_src_pte,
 			      pmd_t *dst_pmd, pmd_t dst_pmdval,
 			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
@@ -1370,7 +1373,7 @@ static long move_present_ptes(struct mm_struct *mm,
 
 static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 			 unsigned long dst_addr, unsigned long src_addr,
-			 pte_t *dst_pte, pte_t *src_pte,
+			 hw_pte_t *dst_pte, hw_pte_t *src_pte,
 			 pte_t orig_dst_pte, pte_t orig_src_pte,
 			 pmd_t *dst_pmd, pmd_t dst_pmdval,
 			 spinlock_t *dst_ptl, spinlock_t *src_ptl,
@@ -1435,7 +1438,7 @@ static int move_zeropage_pte(struct mm_struct *mm,
 			     struct vm_area_struct *dst_vma,
 			     struct vm_area_struct *src_vma,
 			     unsigned long dst_addr, unsigned long src_addr,
-			     pte_t *dst_pte, pte_t *src_pte,
+			     hw_pte_t *dst_pte, hw_pte_t *src_pte,
 			     pte_t orig_dst_pte, pte_t orig_src_pte,
 			     pmd_t *dst_pmd, pmd_t dst_pmdval,
 			     spinlock_t *dst_ptl, spinlock_t *src_ptl)
@@ -1481,8 +1484,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 	pte_t orig_src_pte, orig_dst_pte;
 	pte_t src_folio_pte;
 	spinlock_t *src_ptl, *dst_ptl;
-	pte_t *src_pte = NULL;
-	pte_t *dst_pte = NULL;
+	hw_pte_t *src_pte = NULL;
+	hw_pte_t *dst_pte = NULL;
 	pmd_t dummy_pmdval;
 	pmd_t dst_pmdval;
 	struct folio *src_folio = NULL;
@@ -2597,7 +2600,8 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 					      unsigned long reason)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 
 	assert_fault_locked(vmf);
 
@@ -2670,7 +2674,7 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd, _pmd;
-	pte_t *pte;
+	hw_pte_t *pte;
 	pte_t ptent;
 	bool ret;
 
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d08..cc253050f6892 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1564,7 +1564,7 @@ EXPORT_SYMBOL(mmap_action_complete);
  *
  * Return: the number of table entries in the batch.
  */
-unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
+unsigned int folio_pte_batch(struct folio *folio, hw_pte_t *ptep, pte_t pte,
 		unsigned int max_nr)
 {
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6ed6c160abed7..60ba46838bbeb 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -97,7 +97,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
 {
-	pte_t *pte;
+	hw_pte_t *pte;
 	u64 pfn;
 	struct page *page;
 	unsigned long size = PAGE_SIZE;
@@ -389,7 +389,7 @@ int ioremap_page_range(unsigned long addr, unsigned long end,
 static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     pgtbl_mod_mask *mask)
 {
-	pte_t *pte;
+	hw_pte_t *pte;
 	pte_t ptent;
 	unsigned long size = PAGE_SIZE;
 
@@ -550,7 +550,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		pgtbl_mod_mask *mask)
 {
 	int err = 0;
-	pte_t *pte;
+	hw_pte_t *pte;
 
 	/*
 	 * nr is a running index into the array which helps higher level
@@ -827,7 +827,8 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 
 	/*
 	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
@@ -3615,7 +3616,7 @@ struct vmap_pfn_data {
 	unsigned int	idx;
 };
 
-static int vmap_pfn_apply(pte_t *pte, unsigned long addr, void *private)
+static int vmap_pfn_apply(hw_pte_t *pte, unsigned long addr, void *private)
 {
 	struct vmap_pfn_data *data = private;
 	unsigned long pfn = data->pfns[data->idx];
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 07ba86634b840..5f0ac5f647425 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3553,7 +3553,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 {
 	int i;
 	bool dirty;
-	pte_t *pte;
+	hw_pte_t *pte;
 	spinlock_t *ptl;
 	unsigned long addr;
 	int total = 0;
@@ -3584,7 +3584,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	for (i = pte_index(start), addr = start; addr != end; i += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
 		struct folio *folio;
-		pte_t *cur_pte = pte + i;
+		hw_pte_t *cur_pte = pte + i;
 		pte_t ptent = ptep_get(cur_pte);
 
 		nr = 1;
@@ -4271,7 +4271,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	struct lru_gen_mm_walk *walk;
 	struct folio *last = NULL;
 	int young = nr;
-	pte_t *pte = pvmw->pte;
+	hw_pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
 	struct folio *folio = pfn_folio(pvmw->pfn);

-- 
2.47.3


