Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC62AC9830E
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 04:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317786B0088; Wed, 30 Sep 2026 00:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1836B008A; Wed, 30 Sep 2026 00:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16AF66B008C; Wed, 30 Sep 2026 00:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA8986B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 00:13:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7FAF1606B3
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:13:44 +0000 (UTC)
X-FDA: 85269109968.03.DD1B2AA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id C2AB1180009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:13:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uUMCfJku;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790741623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzSyv304nNTDrWlmEG0BUkcSorjmJHM36xZnGj7rWvY=;
	b=nNI//HY/NG0NJ5QEw5NL8Cz40LhXX3rOS966SvzBEmlGz5UOVKTfcRmznS7ncdafEMRclM
	/YnUJ0/nHdoRs5F2+FgdFbP/bPEsC57PuK/lui1WN2aLNg8FnoDx7HNaD3110BMt6Wr3bo
	k62YcR344yCUqCrtXsPgZmO4VsLPvXI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uUMCfJku;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790741623;
	b=p4cSyas56kp5eEC1hsBG58Jheh/GTGvgS1f/oW8md2wCyJq37lSW7qhlffKBxbEF1SNYPe
	k/1WXlpVZLZdBJXS4jZactNMxwqiaVAwr2VR8jORjDfxT0Wlocnn9y8AQTJLcDbqm/tT0s
	H6D7WQ6u94+DPc0c26jFSmh3ZqKtzVw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 115331516;
	Tue, 29 Sep 2026 21:13:38 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 068A63F85F;
	Tue, 29 Sep 2026 21:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790741621; bh=Eo9CdH+0TtRSX/QNTJHDXco4iCbdFaKjgbzXmhi+d+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uUMCfJkuCo0kl9BpIml6ya6QFhzuY6ScFyN2rrI9OZskXRGAAufEdzszI/qQTPqg9
	 Iguh/DHAQ4gijcI8is1MZGmQg8kO5mj99Gmt6zNO4sTw9mweCAqyNbvOWOTaW5gjPd
	 8DmLSRkJE2jM29CtfSFlUOWDSiSDxl4euASIJUXk=
Date: Wed, 30 Sep 2026 09:43:37 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, damon@lists.linux.dev, kasan-dev@googlegroups.com, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 1/9] mm: introduce hw_pte_t for PTE table storage
Message-ID: <snzkwnnubrx27tkroyql77iziuws3ku34dkclevfen5edef33b@wc3df3hbeuly>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-1-5670b8cb9059@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-pte0-v3-1-5670b8cb9059@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C2AB1180009
X-Stat-Signature: 3rq3cx4h5kz4jof8ms3n6gtmtynxea1s
X-Rspam-User: 
X-HE-Tag: 1790741622-397383
X-HE-Meta: U2FsdGVkX19FJ8U93WCuWONY0KDWLEl7w8fOntIl/+tfcvsw5wdIS+IJdH9pO0ZDoBKqDOzBvTha4CGhirzpDRRj+VjRAcAMYcDPvHQTTPrrY2TYR8NqwJF2LmGS+QVYBfXTC7X0Y+2dLoZCilm4ISX3nAAbArqhFjC82L6TA91Cgri4IghksMzHLoZf2omlKSvr2+YNNi5MllJ9z7dsLi/SEE1uHuIxHS8rdfw+5rcAh6U/eNbvDCJjzUE6bqD2Wta0LGb+B7dziJ74u862EmHgC17heItbmnQbbP2tA/Y2BozWGnChAKJaMADpSpV/u4pN4VlqYd9eCS/46MEXut5ydRMmqcWgZ1FB4a6bm85UBz4fYuFa86/+hP9vK/RWJlMGOSlApqvYWoPsgnOrtcgh690VJiDWV5KrcDM4qbMNHGRorCg1tswVSlyZpkHgSz6+69xzm8b31W8cBoGpIkN5ca3hFB2c+wF13Nghi6Kn+2cahjWQ23jhaQgW+MNZ+EdISxS6QrgbchN7desA49Upj3lcrcQx3QpabaZKDhvHMVosdF8rLFMauyMGJOAhdWshJiACEYGW89hhMixPvlsjimwYFXkg3qyA/Hzysb7469BSsUJ5TDQVFwpElNPaQ0//tC9TxNRzrCqLr1irZZSGGakyvqvjEm3ZM3tNcBJy49qW5w1krXt0GyOss6RFS2KKM3qIZdIrBPxlwh0J4c112Ysjv2g1FYyowV90OtZQbrjLkH97VJ/zOx2B6x1f4+Mz06s5KDln+YXVnx63KpGUbDoNo4ug8r/lE4rND6oF9jmkXs0hfVkh0QhfoUE9DYeGBLtJfF72zBylaoQmdDESzd2aJIIh53CiV8UsDxOzOh7DYsaUMxx4+0wC1wdJxfwEgiJzVcxNTB0qOiu+PdWEN/Y49mZqcUSAI/wbfvTe7S1zuRHRtVqekWCwJn9BPrmonJ37W2AxgeTE/X+
 4Py3CW42
 DUgGUR/L7aknEf67D0HlNIquCweBPGrOOY+bFJ71GSijW7qDNS+SPdh8p9GakSm3CTv4/gqT2h3Q9zoXBEYULRSIi/gG5+bUfjdO63p+h1t4MXoS9XSElqnZ3dw6D15wr8Z3stN0xsWWyHF397Q06Zvpdj5xktDQOMyb8+A3PVxEnD7NKHkhGJ6eiE4vm0Z7IIM8kTMaQx4dw6bm/tnI+xnV21/IDv3UBE+qXy1Z33LTeJPkTDIEAH8/qfU0/dUsxsl8WPHB2+RQ0nw869Bv/LAHpio4tyY2m988LAzXKeSo1lWJ4W93C4CCmnw02dXSXi9NZ70atIAz2/JXHCLnvIrnEEU68yKFF1BheBzCIeKBK5wjUKSnv2s88t8VfMN1+sst1XVOK7UmJhIAiutZqk8Bg2uQjWAiX/jchJa/xfyosw7nASJ++c77BpmqS/bIcvLV3RM/uWlfK8kRTZUbvDqdkg9WsWXaXAczZ6U6CtkFVQfMLpq6BlMVj4bl3LtRDbx4+oVLD645Ohf5Yn1Q4I+/iysExk9gYXhTaptsDtwTCQz2vfjE2nevzj9G2Ti9I9QpQYJOHjwZ/H9+fTndIS5h8XME9AqfXxjHy/ww4qkrIpp2VjtXqjlr9JhZguuMm8noauj5K1GjRQazJH3webv9sYwrwXE3pMjOACSnfaG3dyoLodiQl3Y9s+G6FWv/ZpRinSBc3Xl2o2s+W6aPOQKqjSjd4zrmqHRSSt4S/JaWstpXcs4mGOOI4PYPU8u85AUF6uyhUINFMmmDVw1w8+F0X3gKheEqOrHed7hTOrepW/SreRVa++mVtkAk8eQvGlkr4hzdeLgdWjw2W34JKeH7Yh2nIGoeYVPDT5enlkLcx0PbcXZ6/Y278wBN8Z4AXmP3AyNKyc/c2O2Hb7K331yr6ZHWTCf9Ews11vdmldmR6z9FRiM3ugc/Zn7WlqqAdhYGrOMfriDDw6Z36BHSlvMc+OqCn
 Q9bdehT7
 qyltEang4XfgZNglFCUXHwh0ptXqBLOeeU3GaowSZldL+06+SG6j8wlkTy+cFUFsWZMXc4rfSrzBNnpZt8OIbIGjc+o1wos2BaijqO3Kt2og5Dm1mCjc7GnlE0zxoVRgDdtlhODcAMOFqLDYEvheKrm7EiLBd5U3ygpcDHLMdn3nJOxCT5ApWglTAP+Kf1FV3sCN6J8AuI47awduaT9V0RPVkj+kW42NlyuAhSCltsd2NAtWTjzZPAllxg8upXEV63oAQWpEgj9C5uzZgLWvZYv6LQb4AtvqidCU/ZgOC/rkLkCail5P7ZyQ7uR4gYq2z+v8lZZ1JTozBgt8Qmy2/0tGAJ+mEyMWOmPdTGOReam0xc1wYYp+15sgVmlF0JPMhKO/DkCLxiQNs3/xF9Rb2nul4/4T2sKF/BpT4H59CMPG0ubPjDLI8+84+cPFwtZw71OnvT9WxzDyULXBWcBnUDCwOLfuZBrk9LCkQX83iihixtZ91uqFDKBN8zkpVREX5+6H6GlSztDWjE1bNOJNNoqmgSFCoxI7c/dTlxlO0f5UaenpEMAgYEsWzRWFx4jwvv0lNQkD0+9Lsh48LwWRwxxpvtr6U9+8AWKlDiMItkVM6N+r3awX6uXMrB8/GVjThLOcOnvH3VQ/WpqQhu1eC/bPt8+nfKWbZt6NpQWHK6xGVC2AFO3KCasQ3jsAKNybLdUvxtLHr4IHLSdRHmO1cUOIk5j6dtsJq/v2PL5GweL8NxKRp8GZdpJMmzfyX2P+esX4EhnNDKcK2+QsuYNxpmYsSh1aElNtufxlkqI0lIuIunYic9RBV9Gmw7YW/e6hkz6P5XV1orOuQKWNAYarglzEFKVZFOTsqx+V+qe+scVJZ4Zivic/BtcLMxD2DuqMeg9mQJhQGsDczAR7YKjFKe4h3wn03McxEA+qjotLQej4Fn9xqc9Jfqg2fL11IRwL/lSVylbucClW8g1BU836f7ffz9tZE
 al9k6k8h
 x2Vwdv2paKI8xG4zNAi2L8Gx3YHIDZ9ydby43LqX8YLO7q5pQT8euS5QQ1bdUgZz/I+9U+7rGfLPQir74qbiP9HIANluTaUCml+Iop445Vfy+TeswLgEXdR2MP+Bi7cS46kC2VY5FnMar/QFFvyshALwamIZSW/I0sTLhiSoRLyAXrmfCkVX3iG/UAhdgjy7mnnJoChfkbfGu8IYANd61IxPp84rCMEpomd8fCQn2B1vtMUAU31wwOtChp7B1TZcFWMO7dGrAoGYyEnda2hG0nqi0fP4jk9+Cga76AeZUXg1uRvqjw8eYkN2N/TanwmMb7ap9/Zoxjq3YXISvJyVSvizS6p1ATuZTRooYXyUIj3PnlFPEayCh3R/lm0aIC71f9peSSNjTRJgQD5ZJPKH2FznRt538rVJw2imp5COBvmldBBNFUHvaoyNPIe2gNbE1xc+AVrCFv6KUXUR5HdHBHhtiL5mxIYWj2MCm0FCvg9bKTcbs8PBwj/XFIDUOhKmdRBMvQcp0RemyN/tVI0MVDO5ACuT8qnUDbx4EaF6/wIJNVzSZmPGZwgJd23EMJeWpe7QEZGQuAcpMGXrnnOOYh8NEQPlC3qiVaYWBZa28m116jlua+iRwNpRkwMDX1q0FfgaFGhVH/2q4oJOiggHF3TaK/80sNp8ZYmpJHzABCcgzd9nXHM5XbsCDXNDAt22x9xMOns29qfkF+hrVPWyh/hcFv+3TNXHbXRDITJQfCZCD6Lm8jvSPYp1bVjzPLMDRYH1a02WY/DDIpK5hpiM+l33cUsma4p4SXFmZ4MQChPr4aNzsZo9MX3ht/HF1R4ljiVUDCVezVr40VwyFmBHfP1hQBvez52kclhkleayYO3QKmGpwMnPTGHzf3rzJfGg9Cgq3CWH/AWQRcr0Azw2Gk9+xBFAJ4IOXhKC51kIaj7Tk6iRwXTki1K79zQgcx5hMS7Fxt/pWB6A6RrWAaX1CV7akyBs3
 0Mm6gGZi
 s/r4KUFn5hiWiucTd/jcjDWrvlo8yKrDYx6AnqGX/LpCeL+0r1GnbkdwM58sGd6qOWDUO2tDhLIuOHkBX8Ogwt+GLhUNadDz9X+Uw9zvfrg6GQ65r/L3Z1nLCB8mY3v3V03sS4LEjshTU9Xhl5CNBwlFLa6uJ3brbn1Nk6TUkP8aTndkrkiUs8bxNZHvLPsLmEhg1XlvlqGrC//qvpGOU4Mhjts0VHdt/TPdjM0WoVSKRl+zWw0OZ+9vARvD8p0i3mYbhJ0Jq+4I2YROSvXmZJuvSuj/uIe5wyF3MfJMprdYSmEr72KiKf+/2XdHcm2gPBtt3CMkcCECFZSQHj38aT8loqWTJZyxfGeR6sAEOSCwtyVQr5ylO4UC6Fou+Aa9tNJl/8RisgSkn0v/iSsRM/k9to+A8XzvipvoCR2EdrcZQgmJOMcwYh6qB47Eq+o1W104W2whF8JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 06:12:29PM +0100, Muhammad Usama Anjum wrote:
> pte_t is used both for software PTE values and for entries stored in a PTE
> table, so pte_t * does not distinguish a pointer to a software PTE
> value from a pointer to table storage.
> 
> Introduce hw_pte_t as the generic name for a PTE table element. Define it
> as a macro alias of pte_t by default. When an architecture selects
> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
> This preserves the representation while allowing converted architectures
> to enforce the distinction at compile time.
> 
> Name the generic wrapper structure __hw_pte_t so architectures can
> forward-declare it when pgtable_t must be defined before the generic
> hw_pte_t typedef is visible. This avoids header-order dependencies.
> 
> Keep the C type definitions behind an __ASSEMBLY__ check because
> architecture assembly sources can include this header indirectly. Include
> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
> they previously obtained from that header.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

LGTM

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> Changes since v1:
> - Name the generic wrapper structure __hw_pte_t so architectures can
>   forward-declare it, and explain why this is required.
> - Use software PTE value terminology.
> 
> Changes since RFC v1:
> - Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
> - Exclude the C type definitions from assembly sources.
> - Update the description for the new opt-in model.
> ---
>  MAINTAINERS                   |  1 +
>  include/linux/pgtable_types.h | 17 +++++++++++++++++
>  mm/Kconfig                    |  3 +++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2133aec4a2004..da60a8bdcddb5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17140,6 +17140,7 @@ F:	include/linux/mmu_notifier.h
>  F:	include/linux/pagewalk.h
>  F:	include/linux/pgalloc.h
>  F:	include/linux/pgtable.h
> +F:	include/linux/pgtable_types.h
>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> new file mode 100644
> index 0000000000000..07da05d375c2c
> --- /dev/null
> +++ b/include/linux/pgtable_types.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PGTABLE_TYPES_H
> +#define _LINUX_PGTABLE_TYPES_H
> +
> +#include <asm/page.h>
> +
> +#ifndef __ASSEMBLY__
> +
> +#ifdef CONFIG_ARCH_HAS_HW_PTE_T
> +typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
> +#else
> +#define hw_pte_t pte_t
> +#endif
> +
> +#endif /* !__ASSEMBLY__ */
> +
> +#endif /* _LINUX_PGTABLE_TYPES_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c1ddf59c0d71a..5f462ec6fa5e5 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1312,6 +1312,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
>  config GUP_GET_PXX_LOW_HIGH
>  	bool
>  
> +config ARCH_HAS_HW_PTE_T
> +	bool
> +
>  config DMAPOOL_TEST
>  	tristate "Enable a module to run time tests on dma_pool"
>  	depends on HAS_DMA
> 
> -- 
> 2.47.3
> 

