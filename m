Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374A2C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E336B00A2; Tue, 22 Sep 2026 13:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DC16B00A4; Tue, 22 Sep 2026 13:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5896B00A5; Tue, 22 Sep 2026 13:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 079FC6B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:13:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D3E8C0561
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:57 +0000 (UTC)
X-FDA: 85242045714.29.4423536
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 97F09100009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:13:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FVt56hju;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tot1Zv3M2YyLuWhkbvO9DmFuY1UYvgHB8K11zkXdMw4=;
	b=CD5k4VBt3om6cRhsPOC4OJGTaJA7S44QKTsEM0DuZ8cvdYysk62UFCGKHQmn3OYAV6Krlh
	jinG+3sJxXB22KJwKMFIxnbgOeWSoeGRFBUSidqDtzL3qw9GqaTCiGsG0R8W17mIV0EDU3
	elRtnA1H4ApGduKyFvvo8xKpG2kyf3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097235;
	b=3qyQuYqBvGET7bSqSCEhul4aubaWPLZFVt2TK2CL3uJ0E+mTp9yZDzGTOT6EPUgs1Bes2R
	j1RdE+tCW4PD0Q3EQENyCRphhTd0BJaPZ5sf03XkDgas/eo14WO7Cgo6SD2tT2WoqKhrhh
	AeZEfN5+pXWBEZ1sfAzlGswA5gyQ7us=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FVt56hju;
	spf=pass (imf14.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 094B31595;
	Tue, 22 Sep 2026 10:13:51 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C46153F86C;
	Tue, 22 Sep 2026 10:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097234; bh=VSAJHWUAe7NS76HVRAMjNd0GQzrtewrgnfoeWDUMlnY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FVt56hjuBPaMyg/BnFKqE4fzU1cEu6NBRc7MPH68RUYG/CCz6y6YC9RG6hPWhN96x
	 x9hwL9qrWyGY3gHSBta6j4l7PueQkx2vM6HZNIWXJTPqHrodyx2R2jU4yzc9rQNtJ/
	 1suYvsUR4FuoJM/twYHmYXuJo99AkA0nApGsDh9M=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:32 +0100
Subject: [PATCH v3 4/9] mm: convert PTE table entries in ptep_get()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-4-5670b8cb9059@arm.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 97F09100009
X-Stat-Signature: 54tepa7qc4y38x1ucfbbsjor6i49xhf1
X-Rspam-User: 
X-HE-Tag: 1790097235-628858
X-HE-Meta: U2FsdGVkX19QVzIhSaA6nZBt35EciAE3fKHI2tmy74lFCskSUgxuNnrvdjlHZ1UekA/KD+dh9BJqvmRLYgw5dyS938YfVLnWjW5hBhCQkPpKEMCdtvXBWtxMb7qv5mHdPwMnRkRRNepmdWmctJwa864CfC0yV3kFl3GZUhmO6tcA1WjOtPTP6SFh8ftroTXQyhGtG2ukMPQT0ZcE1daisUM4+Rphk8eabF4olOgVp6ieJFJWQokAeQ/7BvjQJNc2FJ5WxOxT27Fxq2k5Ibr2QbaTqGyXVxWN1FptDRPyaSdCm8tUcG7ohlj8fhqJRNDUNfH6RRVs9C04MQf01Ce/u+yFQ7smTCutelmp3nGmeBkT4V58wZ/6NlxbTE+8v09wNV7RxAHkImVcv8Nh7ZTAd2Js2wz33skOeeNoP/+/pllSSRGwC6a32HF3/iYJDialcXj2hdu9xSnrqdhFjkNRtw2XR8wkQHwVJKCanO9TXsj46BG2yUObzo+fmZQdeUJiurO830WhqAV69+X3B8SLOM/WzRFKamnAPp/Zlm/6edDLXXOyhEHn9n68uue668SlRw0mvaSqIlWfpsPlvVjr8K0WX1YJFU2I4XUeLSTEJoisklA6x1F9LKENv6GIapVh4DXRnz9QYX1/pzfedQNEcbNgzr6iKEcojWRZWR9zt2zrsVgZNp87Hcwl813re9xN3RdR3ts5Fn9ojJ+06f9Z/CE2eoeKJ6IbKRIetcmKMfkGZVNIcLtbgQtzz47gQy2B6yCGz3DH3iI9xnsKgpzyuhty7DpY6LdKN7ZBtT2YV77es0vYAGuGSb0OxzF+2dFwONYGiHqHi6+Aqz07c89+jk2I7wWu1H1a0wJUjmz07TBhBgFbFt37Q2WJc2MMuK45vSzJt0P8Xmerlq/kmh8lcTTEF4TcjYx16d2gdLA0mkIfTjO5ahlofB+ATUg6wRgME7YOcn+8lfw9BBKBwF0
 J1wqk8f5
 vLL4nKgB2kjAqPwbf9Rm1l480QPp2DMmSHEisvDzM3tlPWrN+vEjYPEnrEcG3ujeR49wYHmeQyC7iMzWpcw1Xwmu7jaXNFxnhxPwFYkZWzijRSgAJGru37XRsIU8FBGmR94lidhwqzJLQmTXS89uNg8bYEriKQvzqzm+voE1CNiAKc6kIjl7yuJ3vz5b4J14CelTtW4WhMzNaw9abke+376LG36UOSwvJviLnLmZSRrqOHAisdveCCU6j0QXDoB+h9Lvc83S2dKUcNlQjeWAo0x2tXkbUjU/S5vkUS3pJnTADTBr+yjKDeaZDVH7bKZ5eCifvyDHkm/RBMLdXRFErugLizdHXfTmufREMVZXUywvVggJBPLV8yiq8S2/rvvAp1zL8GbxvRc6vlJ2XTQGCF5CkPWD2eSYL7QwDkNrXn8bnOzzphIB2xaTyWaqZVvd3+xp3sg3M1Pgu2Zbe8oMoSLvkilKZdBAlDGHK9m8wMH8Ly91ENb4sJG0LBJyW1P2xsbwaqEerDT7UrQJKIZdnQvHs1hgegNkdvlDFkrwMsuZUTmTCfgFHTKFbWcXlRrOxnAVmcgmr4SY97hFkX3Wcg4Qzbwi9R/v+6y7qDk0coQ5tqEm4qvMrXKrxI0Zw2oU1ZH0PfXRc2nboyTTwgRNPuiuC2fR6mgqg0qg9QSX0hYND925g9hTfLO5n9NuUMBHS+g/EW3PjiSB5e7hQCGWmzcWc8C2TSGBGVDc+7mZVLVcHaZvOQ4Fzw/fRBRFQlQamaTS95ft/3c+QE68W/PTYorDtEPIS2QeeBei7Zlh2kOoPdO31rl5XFEOnViSiD7A7f4J5GBDn5qtSlXg2Okh58vFtm+UAmM1SIw8co+8mFCJozXNnPEVHaZHBp/DaooGFDqm8Xd83IMfkm/0jQKJu9YPl28cF/qDwvx23Qgbxv5Xe+0W1H7SqIwa9lBedcTB+Yi51+mmmlEVbRvtKD/NA4nDS6SYO
 xrKKOam/
 66wEHMQEmOcRSYunkvjqosavOLUU8vFNBx5ctTsAj4ONPKzIWxr6MenE8U3NbgcSREEcVTys5Bz5LbkYh+Bpu0As2VGxKHIN0nh8esUQw9ZD2kpsdWHnnFa/8JK5Vm7GNySeWlZXii6V0TIewnZojUJHEC/Fo9RvZhK9B1P5BcgSs0A8uUyymGgtHiy+V0/XcyTwkedWq4WH74iYJ7c3kcOghnnLAGv/i8/X7Nh5oYBQvYRZIzQ70/r3kk28+1IJYQwbHfFvX6Uw28f0rfrQnJXIPjX51X9BnYqVLuRbwcMoGs2yZMJ/ZwF5o0ufCEzuDaazJM5x9lBDz3mNT3diAD8vBndCLxM6IasgJkNH9eERwlvqWX12mn+rrhGq2iW60wQIfgcqvD+xEztCYQgHRSA0h1dOGASlavUtdoTil2g3Lab8jfvmMI00JFK4ssBsYpSDaDx7OWzlc9bJEnjjMcw4p79E5Zzv2qjSAFohxjdzXRkcE02Us+OTFS+sHErgK62znjG62UCzMx1MGIr7IC5/xxJ9jBV4jQKzqAPA3hWYflEfUr9NqFIEv8N/KZ21Ir9vKEChigpAwyF6IjrOsWEPbi42/zVBglyrXh6tpXRQrmih2R3cF99Fdx8FICLe5EV3SUUlZP3dDwTC/fvwm/h9llPrhNirqg3zFlSb+9t2eXLnB9VGC3BBhmmDe5scJSpNkBgy0mwCjl+AZYuAfTCF+kto4IXEuN5vIzfVyhrkaQSDF44GQ9Iww6dV65bVO2NBgWtRouOD074WrtxCO023XJI4zlgAXWbrqUerfa1h8FEkZkZQqTazH0jV+ek4n++zdO4GkOcyw8MFpHYlwt4P69VkunCDhoXG7+TbznfV6Rw2/k+xjHkZl9QH2Gn03EBJF/LnHYtP+pCpp7OovvlHtsGCANBqMVkR8SOsLIcwxnwfrrtRs45pxYrkjx9hekyVWtKt0Y9DYENcjq5GQoAglosTw
 x8yhhHV5
 C9Xsdd/aYh1zVQZrJjDz2Mj950zWQSOgpvViMFDMyY/FEUb1DRyDHhBewhqxqoN8cineajUHggRIuNeLYZ5KkB2jYGZdC4QzITA7/+uLsijUsFl6x4YXRVERQX8OIXie2EkSa96LoCRUcWjiQxIOIb9V+Yur4KaQoa6cm4hRkXmbphF2THW/yiEJE3aQIUb61VSGZ1lGAsf2aoDCTe5yyMxk9rlDHMBDVjJrXtLy4I9Fz35J1uY5aHb+TbAW5ClfYKsV8fcI9GhDtzDoYn72hgWLOlrRcUcfEOOFV6cy5+0JiUQ0uzU3LJpV1qfmYkSxR8nsJMCYV3/6thQil6SDjGHWCpKQvZTGaWL5xRlCEU9y0YBsy7jQKc5AQULCwKo9/Y83rqsvI578yIph3kOUiFZakUxqj6MigLcKeOZfHTPOrJN+P1h86a6e/qvzJ6TqVNyjXDx9203XsKaN53KDTTh7YtNLI4RX6ZxEsZ9yQeL3ZAtd+avhJSd/mxLnuOO/7PeAND7kxPTYnBJnYKwMbHTkU6RRAKkjDFK0rDk53/y3QqmPH2xlOwap2kWGk/JZLaG1i6EgZ2SgzXD6KTislboh1zJ5Mpgl2gThBtuI+CNkMlSyQt/Nd7Xak9VOOWLZDgoPbFHLSICRofbciMyra1wi1pcvmPGjgZ5LkcOs7KFYmzXX4X/9BjynTtszB6ZJgh4VH6Zg2IDlutkv7I15V/JI5uLrEkeFghkf0MZYtrEotxmDOTBW5WJi3ZXmEtgVbA12KzHQcr1imLv5GUG40pDe56RfaDsuYKa21TwJ0fy36ueeZ2Ct1fgEeZoc72eQth0nh+KTPNpUlvrDt+es7dEp6gIsQN+k//7URcgNizwt9YcHxfPoB0QRgvA/SD9MHKnEjgtk2j5RBhj7u4lPno2vztranDzM2WkKD+jzacmzxYoUHaFSdPU22WlINeInQhGNg7RM8koShGCcPSn1z+nPl3ZcO
 RSjTV4kc
 cKZcYdL227THgHFDbC2rgzQYVP+AVktis6UiwAlXW0Gyh1kEet9pcgRkJC+mG1Cm5dM8/In/9ru/UKkqx+SjM29xjAqEQ306zCBSteN1ZKHCtmOb6dXgrJXnIO0Frl2Wio1QMTMwPbPhAjmmnfQ+J4ulmZSdF0ur8wxOrICc/Lxu+P3bkGb/BJ7CHtK7QJEMBd/akBTO9AjgAyUz1LmMHKsWrxov2EMj+KfiTc7KZclv4cUEnNHd7F6JBgoayKaB5OSeuIyPRXwsUHgTFJPFTGYgHkEr9+2cHlADkA7VKcz1e9sgJX3uaDZMiFMMQOEQ0FunkQhcCnZwBHyF6FgmZhDgQ6UxBpc7f0a/q3eg562grbD+MWdYKm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
return a software PTE value. Add __pte_from_hw for both generic hw_pte_t
definitions. Read the hw_pte_t table element atomically before converting
it to pte_t.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Use software PTE value terminology.

Changes since RFC v1:
- Define __pte_from_hw for the opted-in generic wrapper.
- Apply READ_ONCE() to hw_pte_t before converting it to pte_t.
---
 include/linux/pgtable.h       | 2 +-
 include/linux/pgtable_types.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 19098e302b75a..41337da0d65aa 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #ifndef ptep_get
 static inline pte_t ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return __pte_from_hw(READ_ONCE(*ptep));
 }
 #endif
 
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index 07da05d375c2c..d6c5a7548550b 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -8,8 +8,10 @@
 
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
 typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
+#define __pte_from_hw(pte)	((pte).__pte)
 #else
 #define hw_pte_t pte_t
+#define __pte_from_hw(pte)	(pte)
 #endif
 
 #endif /* !__ASSEMBLY__ */

-- 
2.47.3


