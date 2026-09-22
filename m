Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C72C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5573E6B009E; Tue, 22 Sep 2026 13:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507226B009F; Tue, 22 Sep 2026 13:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF7E6B00A0; Tue, 22 Sep 2026 13:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15D186B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:13:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB30C1605D8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:17 +0000 (UTC)
X-FDA: 85242044034.03.9D60A2F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0F203160004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pCTPM03m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/D8stMDM1jci6xr5VFuemNvKdV0P9MgsQ6v0FQ9TC0=;
	b=yN9Pp1eJDbAG0epcxNUU6lnd7oVKzoHFE4uj/yebFItDkoqWqq5KGDZnx31cjQ5i0gC4/i
	AGfG6X3HX5paY27fww7cfWXZ7RxNe+7MVIA62gSQwtkqjfepe1pxQ9slCADlhtJkYYIrUf
	5zwKR4okWiOWQrQ5BG/hT1w9GO+3GsI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pCTPM03m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097196;
	b=iiucPu7Vk7V8iBDM37KJ4zgh38a3ZhMHAVFVP2J/r4P+MBq+uBUqxYJaN6tTaG37R3hKPy
	ajjROO7Hf0YdtYdaSAaQoxBzqu8tWytj0iWx1EILTlkZ6VIFila70gip7kuhCbySfynlZx
	P0+SFJ6OYMI7T77AhluJ3SzOxgkUZbI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E8A51595;
	Tue, 22 Sep 2026 10:13:11 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 479AD3F86C;
	Tue, 22 Sep 2026 10:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097195; bh=6PW1tkj08QGo8QdckrPX0ODHoxUb6pqu2veO+kTTZ/k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pCTPM03mJphkPxfc35zeUUsQF8Wf+c8WL4VK71wDLX28hB9HGW7S8BbVsmZ2JQk5T
	 Yo0zY8RCJu6/8P4pPe9u2C/m6SJk9j0y0fparJfvZTMlzq4fTIbQBDrgjycGf2yHZq
	 HemyfHlHgY+jLXxIgf46qiftTUNRZqsbU5Uy10Sg=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:29 +0100
Subject: [PATCH v3 1/9] mm: introduce hw_pte_t for PTE table storage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-1-5670b8cb9059@arm.com>
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
X-Stat-Signature: 669o4pfa9uxt66jwsiftndwpsb3hhcx5
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F203160004
X-HE-Tag: 1790097195-347200
X-HE-Meta: U2FsdGVkX1+Wo0nPTKuCd2oBq3OFmS3dlprU1tZe6gBT2VkX8MZbOpbPTcxRYMMQibyLiRPEpVlbD+GRgXp8GtQGUX/7Bfq7x8kv6ryh10zkSLO4UXdf7+VEgRDtwRzphAleaOCV5WMSq1AYhiJWAYykpqRfoPaViCS/YdPZs/gEJ+oUGVjq1LmrhiuV0dHxSO342U6nv4MfRh7k6dPzS6G/WxjRx51POMqCVnAOITUKAHspj5noj1iuKWUUM0Lb/AbVD5zz4V8QAPEJjTVsGM8Qlcs292O7hDed8ovN1tXzCdtV2K+4x/YfuI/w5CMLDlLlLUMpTyCYHpCpGR+57drM7xRcja9qN3Gks5MouksG1IQnRTLKYhGqP/Tg9kr7Oc1asWv+ie/AvOnTYlY+4khPZTNJVQIkpqRY5T5phGUNriAFpwpho8a0PfZNthClCTMnshzoYJpu0Jbrc3lYIH3enbMqjr2YTwsjQgB6DPyS2gJtHuY2jU5Wig2tij+zIZ3TFwrZbyRZjf1Uiz3uhuYEGIYstBK5iJlMc6K89CIQGdxjUyyAQzttJyRmwqFWLff7kBwj+9x1rjfJ1QRUK3zpeCE0PpvupM74fTfXuI7LbdXlpOGmKhtw3DGHZNyAtRHheZ/6tBZphwSUPE5goU98I19s9T5JKVcFqGEiaiPLRZGKZaNmRfGF9re+iOdnFXaFPVSpLXtdG2einiciA7M0k3wuspN3JsolWMHyCUDwI6aUaW4HE4IC6bBalSuB5wYUQtxa1x7wOG+ewmd6JoBXkmJAJMx2APo3Zr+VQ0d2CTjpy8u3mPL5+4Vn/O7L1DM0vneMLzRA/g1L06ixmR1411zQQzysyWXzm/sjVhSN24+JuFnFUB/t790x7o+dTEbESXXNhPeUnj4ZBT8S3VkqMqkTIIb9qejwsnPFU+bzrqGFefyflrhG1YT5Sxh0G7DG9HCuHBCMsAn7phO
 5o2DZKJ6
 GWpHiZUiqr0d0u0zwwN13VCxv5s2cOI8Mqq3Q9SxNTUtIfLefgbQ6LuadSZSzEjKfsKUha1eddqSyX6DguSaAnv6CPqc2h0kfpiz3bVQN6TWfh7zURdyjeqa/CG3W6ErYoe/GSc36wpkCBDaeP+iT9svTjpC3hYYD5/p0IKkcH+cxYISI4AvRAUlizcbAsK7w5tEviSl/xUwF5k1MDhCWTMUBzEvpLh+pxSsx004QxLl2HrEFDVU/GiH4NI2Uah/mx1JU5CXz2vKYaSo9AowNeWPv4XynFfUA46qY27CXzSS4DlbC4w+L1cnv1/qp/hdMmLh0o/YZJSq0yyZWZIAmCj/+15u+M3cGEd5uuXq0tVC9HJfu5R40V1PyGVT5j2A48yxBjMyq0DOWFl1t81LLQmVzXgXOzyFkcDUMoDzzODM+Z4u8BkmeD0jqiTJr8+cxdxiurZrznfJ38wXp5+7wkKYrdfDnMGuYVsJgNC3prbeob+16UvEfLa7ziHxFjW24/EqAHh6llW/G0v90d3wsNnH+CarXooP5yXiZM1AA9vVdaY6UrPY84Pk8b7EkCIjJqTMdtJ87jbOU82nfE9kqrRWve1L/uUZA3Wc6sJIkvDfPPOmy5IJrD6Itpn8ImOLCalOjIc8ultxE4DCucuUSaxK4MIkfkcpPTqXFMSkco2jAmRd7/2gInzP04zcwBZ3Jp93zeKyClW9frLKuOn3vn0pX28sKQsxdxrc6vsg95vEsT5opQM1TIq6eTRCzZ///AwnDAaHgRKLibPHSK8A3wcKCbn4DlyXPmj3R+BhN/JhWcYCUIpZRswCsXj8ITkV9JYWB2fFqYuZoIHrrUIi3eg8+PdTiprGRkoVQ0v8XeFJMlsQcdNggftvq9F8XZe1FHuLCuzzYOvFR0GOL/R6WEveX9kR2/5dsHIdYC8SlTHRTN7smv4WoocOgYos76nQVWHET0gLc38U/3jVWTjepiNN+v6Bq
 RN3MF6/W
 70YwCw3KYmXS3D2iPm7N/PV9MIAWL+N6QCqyNzf+zgADb9/Xj2uZBkCoCWm+m8PWuSs+htSYv6lTp+rrOe7Yil7xJkE2I2CHHZ/xxODjm9tznGFzASSXYRaethhni6oOyTiQl0R0YSuyWTeG944JZfZVDl9Q76Z1/b5SJfo5IFfE1HleV13VaC7Dos02uv0YIoKmUWbXrmH0ijjP6oVH6ucGSN/zSa+pEsP79+fn3eW0DOLvvssGUyWZhqjgFlsR4xGEPaD3RpqnCPFaHAfFM+wGDxyXSqT/w+BgIfdfO+Ojo7XVrSwbHFsScD07FR0CcNFmT2ssMFSOLHzPSxtjmNN7D3iRz6QMKbbRRjCzcWSvtcaMdr13U3u9wCHOLIp3t3c49zp7dVc9FwuUfoMHtmAAfA9ysxaU1o7Qdx8KMAri1xtd8NkbrehllJ3vMlIJW20xdG5VeGvRGqMETdyEpq0eW26n55zJdbm851UWTUFZOpsHQR2VD6m4+3oezbJI3JIpq7FXX8wFTesMp5arY+Tl84B8gZtq1dJ6KXV55EJW+iiwmmZkDXOO0oqzw/fFe4C7XPO4ib6UiWhNMI1hjhkpJa9Snxrq+7M4GhctPUO3u7BlJjDZefJKR+eSxPuZO1sSDqZRkTniAKMyKKf11DeuARZphQX/FfIxlxSXfVqXeIh2eQEu+JJXtUcxPhmHKz8rdzneAq8oquTEiDE1qfWvYoCkEMyLkFXCB1GZdbIpZNYifc6kxDDwPrMZ/WbKVO+aHzirTW9qzOP7xXDaf1HJ20i4/KQd06fQ0Y3ICNGgjQ3Otxv+hNemVDP0/a8b/qNQ0f7Mq2InNV/UDYg7VMPVNv8E9/PtWW8AIeFZrndU2zq9s/ddsI8XafttIECdXKYDR6oD2doCk6iDoMevmlFDimpmaop+NfHbG6EdrUW8gXC85MdPcdPO5L7NObWyxcKRiaBkwCNjPGywEFiPo41srFtWi
 tFjocnfR
 Dj8iUIlMT0GC4rH4ZhL+3KuX61f2xR6eib6Mxpr1Vqjp8TCYedNQ/XmOqECGOrZ/z1lr43PA3fsOA9SZjh8rKEOqSKdRbNjdorQFPfBKRlk7vcyMrcsS5Pia9a1C2sybVj/Aa0syDOaPZBYGSLW0ONlUxB9zuQ76Lamd54wocRc5quRsdeZBc0Adnw1P0zgU1aVMQGPW/SD+mfAeVk/yFbBdoIr98m8Gg7PFP5WjPjLIamycc95HTlKKtfg6KQ01xOoPk5A2rhIOJ66IrrIW+H16NmG1M9OrQX7v8MFr/YybFovm+Pj+A5f47m7OLmMk707X/9iNTTCuroYn5JzjBpTux/+W37G7JyhntfqGMoT1RXpdQXLTZyQGv14+Ydhpp003dWuFYA+HFup46YdLqEUADCIIX2Zk0I3L6C9KrYe6WTKNbLL8i11G3Yx6MzT2XMKgr9s9unY5Tpxeu+MQ/n4I2vEACUZYVmIGo9ydG24j/A2eAp3NCog32HUNCtHcZAthrYd9ucg9WZhoZ83wuNw9tzApfqhopQO3JwQxdwKvpXjulm297BqhnI8ih6nty9WDsPfIPrzcvnwpZ2mDh+sd/22VqD1WFIPb2+pKrSq30zxz9ZstSiEF1m+vuAxN/gHrgaiw3n03IE+mHa2V+hVonQy7xyMLJNbHcJGnYtGWWvEFXqCzXDfcXrUvmma6oPOKclD6bMKKewoeGF79Rf1uMgtPZ9q0ZIFLyXOihYk4f9HP4b6IDEHXip1GXejy5l8DmGRp9Ew4FF33I9GtDcWSvsKyDdGPVIZQEK3y0G0t2AKE6ZdTj/QSHm6KtdhDZcjyY9+w8wmNr0Lkj9N0Ig9NPqObFFAZeZSb/j6uYV64YHo9uk8O6dFtfPGe0FzQ9tYlOh0cT+BCZZUPf9eM8gvTV8LNpvaim/zUlq9NjJAmKbUqRwYwF7gBkWVZOT4JdO9obKlzLAliTINbgBm04S2kTkanH
 Agh0Y3uq
 7H633MN2t/A8RufQF0h7V46wVzl4YRnointrzyoetSTU3Y55NSu8dPNtDpcOrr2vF0yTKFJwyydxW0FN9Cj9JSYoytgjvR1JUJfjlL3BdsEjt+HuPJaobtNssUCeQUSUyL+GkqoshPo1x3E5a0bEs935KxsQCUNNFCneEktAolOHA2BcsCp1NXP4NHeZj5hAlFH+52p/7DB+TZMeou/P4R6HcxYq3PZYTu/4e6HUw7rF6Oqy/Eo2IbTAxiiZqKeFrngyYTiOeHPKrJEep2d83xXHLfKgZaapJdE21ywh3NagPefvKwTpQzKYTjfUoyKYVv6D5Dw5Qs4NIiupZq3BOzmsvhV2kFWLyz79CLQk8ZOCOovW+HNpJd2ayUZvpK8cGW5cZ7t65Ucw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_t is used both for software PTE values and for entries stored in a PTE
table, so pte_t * does not distinguish a pointer to a software PTE
value from a pointer to table storage.

Introduce hw_pte_t as the generic name for a PTE table element. Define it
as a macro alias of pte_t by default. When an architecture selects
ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
This preserves the representation while allowing converted architectures
to enforce the distinction at compile time.

Name the generic wrapper structure __hw_pte_t so architectures can
forward-declare it when pgtable_t must be defined before the generic
hw_pte_t typedef is visible. This avoids header-order dependencies.

Keep the C type definitions behind an __ASSEMBLY__ check because
architecture assembly sources can include this header indirectly. Include
asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
they previously obtained from that header.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Name the generic wrapper structure __hw_pte_t so architectures can
  forward-declare it, and explain why this is required.
- Use software PTE value terminology.

Changes since RFC v1:
- Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
- Exclude the C type definitions from assembly sources.
- Update the description for the new opt-in model.
---
 MAINTAINERS                   |  1 +
 include/linux/pgtable_types.h | 17 +++++++++++++++++
 mm/Kconfig                    |  3 +++
 3 files changed, 21 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2133aec4a2004..da60a8bdcddb5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17140,6 +17140,7 @@ F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
+F:	include/linux/pgtable_types.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
new file mode 100644
index 0000000000000..07da05d375c2c
--- /dev/null
+++ b/include/linux/pgtable_types.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGTABLE_TYPES_H
+#define _LINUX_PGTABLE_TYPES_H
+
+#include <asm/page.h>
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_ARCH_HAS_HW_PTE_T
+typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
+#else
+#define hw_pte_t pte_t
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _LINUX_PGTABLE_TYPES_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index c1ddf59c0d71a..5f462ec6fa5e5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1312,6 +1312,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
 config GUP_GET_PXX_LOW_HIGH
 	bool
 
+config ARCH_HAS_HW_PTE_T
+	bool
+
 config DMAPOOL_TEST
 	tristate "Enable a module to run time tests on dma_pool"
 	depends on HAS_DMA

-- 
2.47.3


