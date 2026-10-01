Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE78CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D36E6B009B; Thu,  1 Oct 2026 07:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784DA6B009D; Thu,  1 Oct 2026 07:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C586B009E; Thu,  1 Oct 2026 07:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB946B009B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:27:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BDDEA6CA6
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:26:59 +0000 (UTC)
X-FDA: 85273830558.26.4A44288
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id AC03220002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:26:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+MQtz7z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790854017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzfEyFhJfYK+uB46vBwebUVJX9+hiREC1XF3fSfGZUA=;
	b=4yxCTC7qEkFftc8T+IhNz8DNlyOul4jSKTgSVhHBMDWe3tNb1mtT0IEVH1yPgKO6HAKsb/
	1f8EgSwm8llLyHj8oJ/wNALJHk6OZ3gniEFEWdAsdqVCRkTitw/l/8Ts9+0tJdNq18zzvx
	dycJcjbc0k8BgHGwttvCUW+onsQArs4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+MQtz7z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790854017;
	b=aqMz3u/sPSoBPWVLfXTglniXSmfrzjaWLZmX4/2rgj/YAw0dtt9SLTol8gY6o7EubrUrY9
	U+jvn6kezhYZ0WwHWrOD+f/CkCyTl0zru/qyL8XewHJ1J9hZg6mc/3PAK0bGQkXuNfy7MS
	GJ2zY9uxs/gZPrfvZCPbIOA1BiqMUr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38FA060A57;
	Thu,  1 Oct 2026 11:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5706D1F00899;
	Thu,  1 Oct 2026 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854016;
	bh=IzfEyFhJfYK+uB46vBwebUVJX9+hiREC1XF3fSfGZUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S+MQtz7zuMo19rFCKE3ytIWk7CFynaGBS50YcTRINWTK/69FE8EU5WXwU4YLcDdeI
	 s9Do6bZlpvwiEVwgtaj9tIS7N18dxNolZ/ZEY2StJqCPVzklnEXLteF1u8hE+6KYAs
	 76CrhAdicKoK7qFzSQ6inMlZtqgwGpP4vuGgEKL0Y9/HGMa27vAhF4L10zPhtXLPmP
	 at8McMfify9jFinUv+Sdadf2Usvs5QzzGKfUxkmoykUDM3RjU/7T2ETtc60aAVnyot
	 kxZGI1ar8zfZG4KRQbayNjm74RVS+RYzqvFsjwaotkhltxiPBfCZ6WHXWFzh5Tiq2g
	 9ag/B8Tf96Twg==
Message-ID: <fc9919bf-b9e2-45c2-bd7c-70b37341b664@kernel.org>
Date: Thu, 1 Oct 2026 13:26:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] mm: use hw_pte_t for generic PTE table storage
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
 <20260922-pte0-v3-3-5670b8cb9059@arm.com>
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
In-Reply-To: <20260922-pte0-v3-3-5670b8cb9059@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bxwj5u8erppt3kdeqkoqxggxafp8w3yu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC03220002
X-HE-Tag: 1790854017-881375
X-HE-Meta: U2FsdGVkX1+9l1ozMd+oABcajnHp0AS7x0YpcwHVfxhFPEq0pY2PzsmF28BaQ1vN9ULz8AZtl4UVdm5JCMMBKnh4G0F0vlDhqr6uO4/tQ/S49dJbf0HbUdPlTjEgCpmjHU9xmFNuKrp1jMtagqatGskeG/4I2b9/OPukvqFX73R0xqCUGAC58qDwXNCy0ncQheyghbghb5D5je4O2cntwcebY4AcmS3I2RmmKlRXrmzDJB90SDvKcNUzX1Kk62rtzjcvylLCh7YTRF4yhPvt7YcCpC26gmgNs6UG2JCPv/6y6+9RXbRkGYuMiqHay03afgf9ioxEuhUMaQWdE9aBSCpk0wowiZPp6TlFXWmWtn39a0fuPcDKqg4FBAr20a+YO7IDurCkqB7wYPWUx6+MfPPOzCgLaqVBg+FByldMjrmhPyOfoC7gVy2p5NJ+WyPYEZtlDteBN2LXQ126AO45QtUKo12Ry0OhELtVAaaQj+B6TXCBV9iC2D49vBjUACBv3U892w04xLI89RP6Rcw1zvkonzHdDUGEwO2xet+wL94MOqXhRbWhhfnnDWJ7vYHGZx+qXF8MFdgcokutpeYyWtPgfecKpBB/G1RSZyL7EckeTEUc8Ql4i2G5MBAUuLVSfILvMJ391X3IIPjY0k0VnOOLoe8yWZ+YgqBor5FDc3ayMZXaVEHCOmRKfYuXgd2+JrAEc4WOfzTtxw6EJBHF0ucNq29eJleeGzI0Gn/G5QmJwBmKJmkuAjB+oHtWiFJDcRpmDzG8x+LE8USQcGv99NKtER4e4HX7yIthrEAlA0l3Q7gVT55JEj1Vud1KJbO1uDsDw2mJK3YhA25mEcz5PWKxhLlxkNlKjNVLcGJFy/uwpT77JBmAUyJzbXUDIdpvU8iGlcOuTSdAqP6+Ypwz2NeAp27Xioc8h/y+cjjEWyqih9TdGjzf+MB+FFeK5CQ4duhh6BKvRz51GKLzQrq
 RWTBTouA
 doGKwtTz46gxAU3EiH1lXhMSjNtT8DmsBYmbNCl7EeQScXosNin18UeXx+BcADYvlqGQdeNKuqUYqPCIr8M2wq7plI/wBJdLLQ3HBHWALaaZENg5Y5Z1gMjY3AGoHeF0L02ZEp22lREGjNe6V7xCXpOG0G60qnW0+DUfpGkNiQ0si4xXBawENVvlX3Tq+oXdYv8ItXa+1DI/xEGSIG5Ciccy6d1iQ8kYJt5IIU7j4BJfCXZ40m31aFS7v/e/Yu/3fZnD6Ug0sY+6bkRchu2GN1hXK+xKT72q1gbny1A1UXl8uNHH8lNku0kLcvcvHaRggMwAezNI+336mbr4IU89e7Br/OBCVMS/qeA12ysx2W0pzhc3tzKtrcSUMlgfAlQOLNrgWluNeUoxhPB0iH3IifX8x1eNiny0Eox6wB8JTEvfXXM+5jvho50aa8ggND1gKyQxuMHKESw7u6yZ/LAOjVKbcHBDyVSCILG4683GF4PUiASz5GaGwbUzSnnOkqE6DkYCQJZATywEC0Db1f8z+SMG+1SPLeCAI137lbzsB5CHp5DvI9BKCmtbT+T0w5UM9vHFHj4BPFcFHWLS3kSkTwvDTDN5XfyLc07Aj7ZMaRnzK/BRR3YcXXTkfUdtzi6PMcDE/Ml7/EHbzVQ7r1IFRaOszlmS60EoYMTJAlgHSvfgK9KzsOGojMoTr+G6u7cTPylabzx4Hv4gwJ5yjkP4ueg9wK+XApRk99Tj50bTN2YfWhfZVvpveQZInRapE6gega1rIt6KpOVP+dyfssUl4B8eXnuS1sL7/8uqpkcPtzqSN3+sW+06GO+EYixzB7KMkz3QfNayN7Wa2YOLWix3aen5mm21K3ggkdO8VFRzJymyLX0aoLpqmEKeO8QKdfG+28EO0Z+4ZiTLesOdVa4cmFMaVG7FJZgKhwdkuANgdaiUjmlNsiTi7aIhhRxnDDRKeAvlMzcp+qE0IFmXIPS6wYgmtzuHu
 lwfSZshG
 V7nKkqClqxwdnr04qoq2JlDazJiaammpLbYXZFlofQcbX+s7XZP03p8/PqmzZOv0897YlXuFHeb6GGPkp+hgBx/L7rHENDjVr+gBe3UtuaDn/Hi9oTsp3UtgAZXQwqwStVrSeRdfNXGEDbkppkGM8XlJW+WVjYFaMRYt0BoLnee1dep4Dk0VO201Dngn1nRBJbVqYyDGGxFWuCg4d6IdXKkMX+bn8ZLKCRwqphFbqTjTX+vsv9kbtU/OEK2+J+EsNCUe6H9Hhye8KxfrAVGA90oDr3XUZ2WstPnoHipONnh9kHjKSU6ZuqliKbp9asIIko/M75yBlXiaTIGHFovspudBZCM6vxxq50IW9083xl7N6QuQ7fu28NqFaqxpab3aFLj53CKcEOhuCJj+A0roU/8d9HAw5bX7NpgllGz0oMhHJVAj9rD7ljNZhyoC1eR6U4Ri3sbIRO6H0K3Wpr+uTwik8XvH8C2MV97xcGL3R36CvHdvXlPbDDxuGyd1WpvhMuommXR2pXVdcNAagCeGJg93JevK0h81faPhwKHre+8CR6UMnRAChTHcwTFBCQ5Z9hoNkhNblc73c9zUuqykYyFtUAAwlrm4gxzlT0BY8QLS2OhbSxl/tMv88kPge6K+naMFGz7IgginEiFYV5FI+kn1sAM0OckrciJ0HVcIYMCro3LGVEl0DRoXFUKobqXlVyvmzWnb5X3FKS+HjW6V8d2f4oSwuYu5VffFB3HL14ROQYYB6ozKLS4yYFkYmtTdam3CUCEaPJGD5GELQhmxZ2AtiF8vtLhcTXF+7v1g9ANRUnOEYUoUDDmwIV2gECgRVJMqZvTzktJD5AT9pVdm5PYMy7nx4FSj9zkeoyHEVmlwffGjef83i5wvhbYqSTJn+KDsZAqfpp9DoFr/eWPn6x66sYmbznxUkvfTbAhMjL5IbjVLro/bEq9ggpFvRcpklZlrqYjpMWm4Q0WE3qds9CpQM3no5
 M38/MpPj
 Shoa//8QRK7TMVsB5Nf6NGFoHkVlLeY7RD/otmhT+Mf/CkNkk0fHoX10TuhWVfZ/8lzbR0feslzEX6ZbQfVQ0GYM/Na0UmKnKnN3AOOgNltgBTnMf9BAnV75CWqWHFQZm1J+4V6M9zw8hsPm4LI7feeaCJe8je+mlRG1jLvjdmn6qvtDQuSeZDWnY2URZwzDk8AyzomECxl4ZrEGsnHpuRNIHnrn+d83nLJCbzaf5VTV0KYtrQxl0gNuJKSMdoUC4dpTGUa0J1ynBPatK9LXimOu9WEVZp+5hOAScGv7yNa3IwBQxyikMlmrtRnq0mgF2pfExVhHHdcft81kqpgtD+b8kp0z1lE2YesHHQDR/Qld4XrbG+6ffKCUNKat/0ltJlUmEL9ej/O/4Jek5oIav8eKbxNjr/7FDYObpOi9nHaWK46Kwy2HlSrPcd+y7z44gdlzjc3Ygxm4jLMYmPa6xHA6MFzUk612u40oPmBbMjD+3KGOuTNpJKp6f6f4OjUKarMeU/UTZ/1ca+8501P2/k0qL6GKWTZNs0tuuk7ueLx5FayS9BoppJNMWXSUuJOFASzvHNpHbOG8ktGBVOE5n9sze/qzjPD//4w90+7T/TLdI+VsJylPBCYfwlkCAqqIo5++YN3Ze98Q+KvffeBvbkNDvwWowqk08YpY/0XMSPPz3XH6m+UfFv6un2SvLCmNh8j5Zh4fwtF6YpiDijbNOsEhmSVNsMbnEz9s7fk24IZC1qCD8AmtpD0nnmbcOLzGKm7Z6q4k9B0ZOT7R9H2ksckgmOzDm9I6zPst1vIZT+LLQ69NLAgE45uLU5e2wj9WwiLEbkpM202zrB7CA6lWyJZssdw2X2cQo6vw9fUbFFfLfY+6puSSHYEfBAwCpz5/iF4Wy6BW6POzY0YJ9F1CbDkVvNNX3D0i3LfQQQ0UzomQqaKHF2kVs4XZWFxUKEKo+K0QrV1ZxUUva7ZApa22WzKkm4jXA
 G5aI+HZj
 UmnJPQWpiMLCkC81U8Z7b9dosJiNpLHdED4SbaoZfT4L4N2wIvjRjXcMHg+8tXErYOUG4OU5pGzi9ClSEWLTVEYIoRpyKY9Zp7L160qph9yHPHCqWEdWKmn6yE0gio7UB46h6XbtmVxEsVh33/1n867ETZX+TNX64/QmMBTl1LgxLszuyAAVGRvokwPfl6JCzS9J4qOni8ZB4h5htx2Hqqov0aphfmaB36F19DGiQh2DYdQcvalQr5scR6IzDkinkxzm/CAyJMuTvSwND+eBGKZHPqdGM50pgL0rexHTZBkbwVATrY+OeAZVTnsl0m4Au/ngQq52Ene0sg80R/Q7cIe24MKShJp0jQOwakCWUH6BP/bzqZapcNKxPngZaUB1KRSqfGL4auHHPW/2Tz529VgRU6BF0GnHasd8X7ZhUFvY01ye/Y/4jecz713ESogJm9ZZTvRlirBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 19:12, Muhammad Usama Anjum wrote:
> Generic page-table interfaces use pte_t * for both pointers to PTE table
> storage and pointers to software PTE values. Convert the generic
> declarations and their MM, fs, and kernel users together so parameters,
> return types, callbacks, and local pointers that designate table storage
> use hw_pte_t *.
> 
> Include linux/pgtable_types.h from headers that expose the converted
> interfaces. It continues to provide pgprot_t to vmalloc.h through
> asm/page.h.
> 
> Keep software PTE values as pte_t and retain pte_t * for value interfaces.
> 
> No architecture selects ARCH_HAS_HW_PTE_T at this point, so hw_pte_t
> remains an alias of pte_t and this changes the interface vocabulary without
> changing representation or behavior.
> 
> Most of this mechanical conversion was generated with the Coccinelle script
> included in the cover letter. The script deliberately ignores pte_t *
> pointers named ptentp because they designate software PTE values. The
> result was then audited, and sites the script could not convert were
> updated by hand.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

