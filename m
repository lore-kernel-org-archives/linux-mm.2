Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99569CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBD16B0096; Thu,  1 Oct 2026 07:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D446B0098; Thu,  1 Oct 2026 07:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D8B6B0099; Thu,  1 Oct 2026 07:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C42D6B0096
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:24:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4DED1403A5
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:24:24 +0000 (UTC)
X-FDA: 85273824048.20.C67706E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2F74040002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:24:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iSG5PXXs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790853863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2dd2FaoT8IGI/PmgsNFfX51uTun/lYmybhUFgOLuQg=;
	b=xlirAI/EvHv0cVnxM9LCMChkeq0dLzmHno/nTuvz47g1iQShGJ+O7k3bKwbQJYnNsxpmwn
	TrFXvNH5rRpXXByYjAzJNqBW0g07To3lONS2wao1hi/gEbiZgIhw4vgz+s72MckNjwRoHO
	JPLTFDL2XZNmGpPd+BXDGRoe/nPWfOI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iSG5PXXs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790853863;
	b=EIbEVPhR5l/CxNFVmoKvsMtMHR06m3whBVdGeC4+R/JiLWec6c0df7l9KQeR2Auv7q8Xy9
	EJw7Usg8FgoswW91p91qOM9bs6LWIwdWIzHYRwtYE26B6YGOK0ZEwbT4I5GDzveaC5+639
	B462jozCUYlKa9gwx24P2kDgBe7gDYE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97518601E4;
	Thu,  1 Oct 2026 11:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9C91F000FF;
	Thu,  1 Oct 2026 11:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790853862;
	bh=E2dd2FaoT8IGI/PmgsNFfX51uTun/lYmybhUFgOLuQg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iSG5PXXsSQzGXjfn20lgjsoWKzQYmPp7ZZXFI6SGrx91yr02VUHV298N5BBJlMHaP
	 M9ZYf/JJLZ9V8qfBwvqO39KJ8+pNUBetBcscChkH+0df5TkZ2sUcFBudzEgRioe8yb
	 SSkRXj8/C/QKoSKPE6PW6Q2KDh9nZ+k4kuF1lqoDkQ0AIPD3Wb5f0fv4N/DCMAQq4z
	 R7kwBsOJxrzykRLowKMFHGd4yy52IjUUPzYvPJjS5LMo0p5dAUpW9qrXPHDQCcdIJT
	 g69Nx3deHliOYXzfa8TMAC4jPCvHeac6QoZcwkh6WGoSh+fwx0mvq3d2tEJx9NgDLq
	 bPMwFw16qyx8Q==
Message-ID: <28b5590b-e2e2-4eee-ac7b-c5c402822a24@kernel.org>
Date: Thu, 1 Oct 2026 13:21:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] drm/i915: use hw_pte_t for PTE range callbacks
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
 <20260922-pte0-v3-8-5670b8cb9059@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260922-pte0-v3-8-5670b8cb9059@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5twwxed33nt55zo5rm6dx6m8ntrsn7jb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F74040002
X-HE-Tag: 1790853862-851458
X-HE-Meta: U2FsdGVkX1+Lpv0AMwdNVqqrxNM+2Mr8Ddm9JMaw+yMtVXNuDa3qN/qfuioINTWNikx+0UQqC16Eu3Lf/66UbeQ2SORCxcZNuUAjQEajRYYUcdvU1X+9mOB1I9AUBmSNxtOlzlOuO87vt1JeBM/qwgvY2NHWEP+iJHrHqF6MDlk952Yk736wTSroKBj2A9BAlXJR1mRtUwzYQ10Mo6Tmof+SdkDaWW7zdpDFmd9Mw+zM+Gci/CTSAq3fYEAoUqzn7vmnGAZe5ZozA8PzdmAEzgQr/yu1zuqykN1wRJRNNXTYk1Arif6yAPn5tyCwmDdaSE/BOS3aqvK/5bCSJBMidQWaTwu9utg5JZGMIPbnAyRA1Y9/0ZrQFpmDWBc0RaIXl7qU1b4QzLvmKJ/wIc118OeWAcUC+s0f6oEdkpcKJkol1JSaSssMoC0z58JhvBmw9ZlB9iHuGm6RwhHh/oWATYjIjQ+4GGrBtvS+P/d4tHY/M6nMDmB9yxR42bWSoq/cD1FquyJkvSH5HdfgBt2oZp35W7ObrTMXgJcWruUI9vOfWHAiy14nt3bFKrsRHql5aAUTj6FYg5fMGYuFFhGv34FkMzyCHm7WGOhhCcP/HFHblR5J2ACNNAXJiUxmVW5BZoDDH82lbGfx2OYX8n7kg7KPGlW3Wc3LU+Vk0aiMAKW6bh0nCF2XPZID6NrrK41oBODSWT3ebo2ancAbJpBxdrS8S7Lig1byixjxNsJroJp+xq6tJVeOZJv4K32R3R7YCWE4DIglbxPk9I4kqv8PX+vGDH7iyazadGRNkK7KBJyTakk7uRgYsHfu5LovyzJ6A+E3cvzliiJwiMabEvdQu/R8oQp28Js1FS7nLjVYemmDLy94q7CsufHmwpYmyon1qeRi8OWHq4c54yia4qs3NYZlPM/VURraseyEzvkxNToeM+blpQn3NSUEsRJzkEHMolq6ErAcQgTxFE1PKfb
 QZbdbysz
 goiKTRTuUmfPwZYI+amz4q8k66KJwQN9Ui+2bKNGrlcCXhwIIIrC61Sq8ZWS/01KU/S2/wfarbHm6LWmD3E4NSv5HnK+u4BqOomuGyUBTjXd+sm2WUadjefaP+x3nW2g1fmCcdSufnyFO13+O0WdyXDWUtYWU0WaMT+1To24PlttceQRSAgnIn/am5pMah/BCK+TAGQHVjXAoSxh1Anm9tVL2NOvyVRPivtPUTS12bIe3AiG126gdCTOJpne1riobpYGmKupq33HIWReLbP3nYl6nt2+YndtXd3fTW0wTwPsOfn7bwC4d1/qQ3Zyt2SiJESoofJO6d550/6PCAvX/7qK3Ah7ABHCD63lsl7sTDKiWc1TjE016Kq0GYVU/ltctQYHB+pzy08yCVZKGZkw3M8CFnCTW1FTWnfOlJT1PmvLPivLGTCtnPtaPbGhJPDGOm/25TKu4A5xdzQYfOtRqJRNisNKb8Ou3bT7QjDV5mPiBKkLqHBxNwu2rKlRFj37zr8lGPADMNDa+hQpkZdtvzz578PchXvSe2Hzwn6Fr8snGZamu9YEtqnDHlBJIWhL4dLw1w3EHYrqaEj5OGU6YYXfOQNg/N3qYEUTEhOhUVVLgFhYgFw3mWM5rWulFnFFwMq6Iy7SNRN3L+A8l6k4rAqyzv1OwrTJd4ZXNL+MPtNqpHp5QOhIN5eqb2sHlHDozklHIzmZbqjI+g4emkjPL3+FmX/DVNM0NWA2HgaqdfAVpG8usfeqpErSQ4IESK5N2ujjOWviq3lw/qVEiKSq3xTe1Vib+NxsUXAhee6eZgfGMDS4T1HYaQkQSuC6O8Kf4zNoHfn3IksJy37w8HrbxIYteNePnRMShWb5ULL1LCXZ5erhp2JwFDvucRElBFwNaBT6rbYbGojrXXa0O7IUEWtrhRUYmmI9ZNwxynMTsCM2Iq36On9OHjVgCLSKX/++fKnIwaLCU/q1HIY+n60UxWOCCM2FE
 q2RA/BQ4
 Lm0r/XSvwVDmnHO/60YVKFO8WSmftoKkU6m73mnhnAUWcn1M6G+oAoWAQHRuEBv76ujaYdoe2XUU2AegDwgvv7FTYpVKJk2WvIPGcNgdl/dQInnSSFkSVvVlhj3s3+ZFpbUkUolkWbM/oj5TUSD3QRAMJxGsEVwNjDw7jdt70zxbZNej4PKagDVyvMd8hDuEfgUM9u9CBnQ2AFCAIf83Ci+CFUCQMktNG9ZLgLZ54lVqN0bme4v0YUNGPBZPIOU0TxBXo7JPxmHANjLN8aFZEih7CyJz55hrCWEs2NEmCEwl0onZnbxAK5cLAaT5XQzZu1byvAPS1fBZIp9atFefl3GNjHLF0oYjFF/mqhtZKDdopj8bnDf8qlrjYJXJ1Vtsa9yfeDfNL7R+EpK3sZfNaV5ykLqMTMvb/uHhnH+AnRkWJYBz+n2UEgKVs2XRJOuernjtneG6D4iMihahwkKg6VjtPhmwB5PsjI4wCPoGM3N3hgc3P5fTiHCZFTbp4Ok9nsNYSxACSRS0P/3q/njErq4WBMA3pwTrBfBXoPdpdqHjdKX/tGI7bghpocxigI9yLvjmyfa8/WCA/f3hH7gz9eZJ16YWcwkVy9q7fVGVpnBnRee6Zeu5TDvKu6JnUvRsbjwPvfbjXJlC8D9+u1a/xc+hEXj4opygUO3QRTA1SZzlHZyih9qgKalCo/ZZGy+PMVIIXMCmJ18COH/YtAFTLGhBYCt+mFypxZME3pfijS7jm7UzRDiOBqf2Jc7fq9pKIKNtwdk0B3NSviRHuE2ucIG0Pi25PISp1HOy3u4Z/5hpT6FmqWq4kpYcZiWX/MGjQRw2FEktJfQAOjf2DbLNtM4aqA6hvkVjNpcvSca9uwCJP2vmlLfLr98AOoWWE+xTvnQN4u7UrPNTMm7bvJwAsRBmzxeBFXdlukHHEPfe2t2xgRXG8sSg9tyPRsBx2DA8RBT/MHoQfT23daDXbY876zOsJ+AKV
 FRSHo6HQ
 Fw0xp9bfq9ui6AMGpJlN9ZrwCzIlSqX1t0UJyB6SQyGmQq4A8a2It2qfXA5Mte0eBGzl6idsEz44aY5p1VnqBEHXttCaQ7zP1ZEmRfscG60bZXwEGnzWiuRafd1ZxBCGy+6JJoP8E258mS3I1jghJLThmH06AlWxvxP0edAa43+mYUweO2AP5TIz5Ul970iD0+txZ/c+XgtwXUXIXsyzuwHjVgLEO0OfMRk0MFQiqwfke/4S0gPs1nDF3w8I+hiRNHFnjjhCJ3fnF5vWIVE2lum9ipxEyM6m5yFmIfwAwmaTHxlqnLEvUz+i9x/VKcPHkRQxnQLtyX9NLbxepZFHfPXbHlDKGAyDtWSG9H58KqkwajE+2LAmsAk4ZpX/BE6mUkdn+eycQMZoJg4kqddMfTiCHWLjblUkIyM3uZdvCedUomEAJ6GILk2Osqxrkyd9JeX2x7xUBZqccmBK1FRgdSWHCH3Q3Ytt4SwZwzbZTZ8JSu+MS/xSre17o9XNDdb5YfmaVIgbtsNNEPzzNeSBQVpbXUShD0WM4mi02pAnvh2zY96L7kKQjFXBH+uPqG8YrnQr1maLDMN/fBe60PtXCJ88pdoIeRtH5ta60Z5y3NlbQJQBN1k7dn1+SN16GkbFnwwHd5h3bXCDIiv2BcYKXdM9cloVqw79w2NLWXA35EMNYc1WsI7Ezn829alhBQYSnqxwiR+QaekgN371W2U7PqFw+nKPfdRAOfvC0CAfUm6JYS8jBHIjvPlG2F5xMjHj7lSpvy/VuvN7ptfJ1020YXmFUiXCIk8dUtaEjIk5bYc9N2cM2waqYKqD0oSDX0s1wajqAUNwlmlOH50E19OEO/cv2Ublo+cUAd3L95C7JFYQQex86wW9ZlwaaEWSLW3MZhC7us/SwbAQ8h2ZOavge9R6nyTzcR7OI4ALfVJX1M0gyZmuxs9GOpfUOZm/hC6lXjV/X1CeMatO/bB41GK9dqIkFF84w
 rp2TkwJu
 ZwBpqxA2iv82YdTW3DG41f4NAWU8yCL+Zw+y3s4kxERG3GEsdBdXV1mEeA1HlXcEynH2oqSJcVjIyIVLDxWCk8YQjV/fbbwGsSOWIwS4QOhr+stTIB4DP/cIypKf/HoJgV2XjMvYWqADpeLz/E0SO1oK3H7EXV9J5ZcW2q0Nobc/rwMw4UGO7dlPiu/BfEo2KqoP8Hx8sZ9qL6oMKNhYdIPOWBoz9dzBdv3B+jChOiaDwGYplncw3gZ6elycHlAVe93f1V6YOtMUou1fr4tm6+0i9mpzDXYQWO0Tz7OTnPk/3aL6RT3oFMmx4TVbjte3mHI3Bhy7sJV5z0Q3BJAS3PGTsJqpBjDzekLXMytB0Q/pYMPyBH9jMfVNy31ROtUADplqGufWpIasdkwbdt+8SE3tpfn6XViS6MZtwCFjH2cQ2tvaF1FOtRmfU58/bUk7ZIql+Q7SSDGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 19:12, Muhammad Usama Anjum wrote:
> apply_to_page_range() now passes PTE table storage to its callback as
> hw_pte_t *. Update the i915 remap and selftest callbacks to match the new
> type.
> 
> Continue to use ptep_get() for software PTE values and set_pte_at() for
> updates.
> The type remains an alias of pte_t on x86 until that architecture opts in.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Use software PTE value terminology.
> 
> Changes since RFC v1:
> - Clarify the effect on architectures that have not opted in.
> ---
>  drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c | 4 ++--
>  drivers/gpu/drm/i915/i915_mm.c                     | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> index d01acfb7d93d0..056faf4a3618b 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
> @@ -1690,7 +1690,7 @@ static int igt_mmap_gpu(void *arg)
>  	return 0;
>  }
>  
> -static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
> +static int check_present_pte(hw_pte_t *pte, unsigned long addr, void *data)
>  {
>  	pte_t ptent = ptep_get(pte);
>  
> @@ -1703,7 +1703,7 @@ static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
>  	return 0;
>  }
>  
> -static int check_absent_pte(pte_t *pte, unsigned long addr, void *data)
> +static int check_absent_pte(hw_pte_t *pte, unsigned long addr, void *data)
>  {
>  	pte_t ptent = ptep_get(pte);
>  
> diff --git a/drivers/gpu/drm/i915/i915_mm.c b/drivers/gpu/drm/i915/i915_mm.c
> index fd89e7c7d8d6f..aab88e8edf946 100644
> --- a/drivers/gpu/drm/i915/i915_mm.c
> +++ b/drivers/gpu/drm/i915/i915_mm.c
> @@ -48,7 +48,7 @@ static inline unsigned long sgt_pfn(const struct remap_pfn *r)
>  		return r->sgt.pfn + (r->sgt.curr >> PAGE_SHIFT);
>  }
>  
> -static int remap_sg(pte_t *pte, unsigned long addr, void *data)
> +static int remap_sg(hw_pte_t *pte, unsigned long addr, void *data)
>  {
>  	struct remap_pfn *r = data;
>  
> @@ -70,7 +70,7 @@ static int remap_sg(pte_t *pte, unsigned long addr, void *data)
>  #define EXPECTED_FLAGS (VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
>  
>  #if IS_ENABLED(CONFIG_X86)
> -static int remap_pfn(pte_t *pte, unsigned long addr, void *data)
> +static int remap_pfn(hw_pte_t *pte, unsigned long addr, void *data)
>  {
>  	struct remap_pfn *r = data;
>  
> 

We really have to get rid of apply_to_page_range(). A horrible interface for
drivers to hack around stuff.

For the time being

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

