Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91672CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1F96B009D; Thu,  1 Oct 2026 07:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92556B009E; Thu,  1 Oct 2026 07:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934406B009F; Thu,  1 Oct 2026 07:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 688496B009D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:27:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05729803B2
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:27:38 +0000 (UTC)
X-FDA: 85273832238.27.B316DFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 32FD0C000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:27:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ky6X3yIy;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790854057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRinFgClxsjCxzXrcM5ZxOKZ/5JIquj5jbimxGiUTO8=;
	b=F7+5CIUAEQU0jwPl4vm0YfUyShsPVq+JEHhvVJOB1N8cX2IFwuhMBD9K0IywT5o/8u+aI6
	RuNow9uboVqZ5v1/BBqZpYeaNf/9YMjqehAQ4Z+SCsYBdeMb0lsvjj537ZXgXZETs9nNWQ
	v09By3KyM2wh+gf1SnlJ+zSPSN5TqYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790854057;
	b=hlqbQraRPr1/FQxeaxCxuIETUv1qOC0AHIe99qXprCz9hrj0C1jVjPxNw2ZYj2rS1o2ic/
	r2gelY2PoHoveIyAh6SukgUYZy2NJgF0zsbzltzRzI8IAszLj4D7RqfRbBs5IhH3QT79QD
	bHbD0AF6V7M6HHIfxEZVJNkoHHYwhs0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ky6X3yIy;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7548C40B7B;
	Thu,  1 Oct 2026 11:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5491F00898;
	Thu,  1 Oct 2026 11:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854056;
	bh=HRinFgClxsjCxzXrcM5ZxOKZ/5JIquj5jbimxGiUTO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ky6X3yIyUjjGya5AZ2z0J7ES0PO1SfluuP77TdLK4cH/5tB7JmDxOx5JmHguHbTS/
	 /b53SZAJrduEMNol+itQc4hUm3oYIqiOIaUDFLDveSfCnkYT0toHIyq63iOl1Bcr0E
	 LFrUwvyQRwIW6C5fp8PbruCBz0hBOSrd465V01o47SLY4K58h3wExxBgZh69KYO5ZH
	 Wu118EUYFVgD1s1YuYtEhU8Vy5dw/GT2t4WKgiJR1s7vPjJz3t/3IedQszccKYRhy2
	 so7DKhpsR4s+A5udrWW8RI/AbcWyEkjbKrIsp9SorRGRzmZoNzvimOYRr+/vcF4jm5
	 3ubv4o7hB0KTg==
Message-ID: <fe7ee974-fb29-43fd-8543-3d9f4e4755fb@kernel.org>
Date: Thu, 1 Oct 2026 13:27:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] mm: convert PTE table entries in ptep_get()
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
 <20260922-pte0-v3-4-5670b8cb9059@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922-pte0-v3-4-5670b8cb9059@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: odjfxrgqey3czn6rnq8qyxuqigdys4r4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32FD0C000A
X-HE-Tag: 1790854057-287968
X-HE-Meta: U2FsdGVkX19SF3FPjhyqFr/FooeAAyHXlzoYxBEJNOxzzUJJXUlL6+PsdGWZbyrvTqJR+pyVnYtOXIzOC5gcBxaxey0qXCAUXnyrY7N9uyfASn36gMZBbZjSscZrD5KXZvzEpIjtOtNIJ7RpfHgzxLEl31zFuJWUgpNu8f68n0Iv4zjECgSE3MX/2Ihr+KvAr56KS+7Vpvz56Tm+xOrEEefxmLnGmnfOCtZUiAuVelykh0p9cbu01XNU7X6vu0JMs3CSXr14oZTzFFXhLS6mSds9vVZRxkdeRu+U3gd/5Jf7CFx13+/lz9TU+y79Tiy6j35uVFmFOsTIeXa0U5FYadzV09RKYBzl9splTuWVJBJTKtz2lHDF2ys0VFfL5a0b5HG8Hp4L9jSZ9W9livzsUiUmU5lvRVZiXMH0J3V2IWK2J/Ur5CMA6FbGhYHLdjnkX4IfmUzB1KJUreaV1Ojb2VMBZV8FvH1If5tp/sQeGGEGxU0z90lR1XuJVB0BjaMJK+j4yvcVyORR1hQBWNfACOSPF9qynLM+0v9QvY+F7biL8jXa2itDtMzpyo88be4jMeqRnDLdzZuXVmFmuXvlNsrlds0rrgyREmvuf3ZagSRBtkvIPMSt2gLZSUg9ETBkJb7jxcUgiol6G24Ki1C0JMfmsR1am4ZNadlr61I/gJdy/MVszq4L9BSsed8D7vu3p9c5qovHplWpGEdw0VdWBfMpMJ5sEvBC+EIyuS1tHm0FTCAUEilGSrXwEjl6sx2lqBvso/nB8ezauc9k+Z1GIGBU5KYwFXKrApmCJuUBhFSRiaDQee4zvddNlXNuDms7KWOanBs/Hj+Da9ZzRgp8PGhsS8wwS7MZZBSYmO2fMegQ4UWVmsmgNBYGAD1RCgE0Rh40e6JAjll6smCsZW7dV34m7Ry2ieFm4gQG66Yantcv9iSFpqEzTjQSXj4HPoibaOraxTFyL+05IXaqyN7
 iMxStnHg
 D03FCszvSYgxSc+F5E6fi0SXZq1oM6A6muiXJmz5MtARpdEkRlV3/1CELIT/JHwKWfj6U1/a0Q/HOcUJarUEQDLEdRzacCRkjl56BnAhooFnKVbKpI9rZ+KB1M3XWm1d+469XUaie6ZnCcmYtwkfGCYA2CYGoXGETK4vXWrsf5L6ydVyWErSPOVHb4UnErthMWESTuImUZbTns5zWSzXsORhxEdIc6SMYbRsUBo3OlBS6gygLy7KsWfJSJNeHblYCKZZmPBK57HempueIZ+nP/r0sz97MykqEvZfpcu/irUAGHzCaBO55bYiP4kUyWp9SKNqD7eRdFB7ZLt71+o+CuW46Y4fIMfmTofsZpdHQEKyPxixil/EnvgCocH9jp708fnDVuFCItFP4jJUAkSn7wB+pRZJ/jgo7x6vEghttwE66Vi/4TOGZEM69l9TL+WoSFH6etQbpOycbuKYwEHpsO+10619nRMBqIAGD8Nm/Dt5ayqpvp7VAz/Bd5cQFh65xAtRRmkAoDrB2xN/U1c+Db16THRuZC7IqJQzlmm/idyAG/Q7emD32VVtqAfAT17eXAZuQNJBXSWEOp308q0nU8WfPHaFKSLB3btUG+rUnzS7bMINRCFWJ+FGzBxxk/nk0ki06X2Ms5fF+T8Pd1We+/Tl+8K76afov5NrTVZ5ITnPf/UcdGoBke6SaAXcd7Udi1w2zdIFGkD8ashcUqOngjEAmJjtE2JfvgPo7BOzNxVDiHknMT8KSiqc8XWhF1gqvhaVSwb4BJYnIo6Ytmb68U3d3wsixETnt4TuWD051C4YKkBU+t2g74EriRHj98/P8h8oy4tqRNHIsadTb38Xfqoj4ccD7vVQuEVR5uvvLFfBwb1Qr91j/zlsyDrkvMH1VhF+oq97J4A53F8L6W50u4it1fy0PY81fDDcg2N/c4QQvPRPPqlUaroeRd7lagQcqJ79hWwUXnhW92wRlRcrztTRwwZK0
 ZeQc+z/c
 6UE8fx+t2E0c4xYsD+qVgPVkLt4TJfgzBVYaEJHcKxDaVuu9sBH9q8tY7S6X7c7c3Fd2Zc6PhJVZlX3pcs8yXyZuPNL1DFLxQR5bm+IYOelwlaK7egXuHpUsFZQgW/gtoestq+R+QUpEEpfDnNC0QcU8n9RGcXgW7oTCQ/6xE36491pgVwlsp27bn94IibcEHEZhZa54tc/ShP5Wuxw1IN4jefPVefatwTgcSnX+vReqkfvS2O8KUDkyRiq/0Q9TXmzT2+rpyqRVaFZYD9jm4Y7LxkJWAhO77/m+ZV4LwEuLiu1+d0vBzTZu+7nv/l/yF+jI71+UuTaZRhXhb3EXnkjEos62I0EHWR1o6SzANKa6OUD9HzeHornCmW0ufZ1hZLusFae2YfUAhukKJy1gwaEUSf2EXuN/WcsaMARHkOTPl5Fnrva19NQG0135YDPTLSMRGscz3rPkBWYZIELl18+roPch13qm1Fnioli+X7NU62IoG2GTdRQEugH5avNDlhl6x7H5e5TwW8r/7rgwgn8MimeWQApfzIMSIKMDXgCJGOKznYlYcizqoX7gOgKVC7uOTwOwljaePmn95rIB2j8647iQd+O2buSZFdettU3IMQLE1yV/rixhHzlBLlJIUVVMxNrCgcH3GsgZpdhQyeJ5suXqHtJvETpGHZ96BUl1odGgNHroY7FUZ/PB3z3YiBtukTIbU40s1bXEnwSIC4WWlYZPvXDK+hKLlktOCspWe+nLyFA5hpmaquXavzO4T7WRKvwPNBOlDQRrv1dQZ6CxgAK4fQ64B4nE68nv6+lC8r0EdonWefRvxfjdGD6xfRWKz+YAqOmAZteBKjfFJfiIY9ama+s5GA1LzcLVHzSlBsVOItlQiPv0fK3jcUnMHWPetjypZ71c7mCHrvO9xJXCPXlkx0M/0myt5omJ+OmdIcNQ79oJx+dkbVL9fAnyANBl2YzS8tKgqGHtJl1p+3FGDGmZU
 +9Wpy1Ku
 icKQQApqgjVAw3Fl6GLcBFziPngaTWHUR5CzECpfdNLfBf+Vu1fvPyBj6s1CLxWFw2179wTW3TW+HbnOOQDNHyrFLwM6FwXNLcvxEYGw2k6HMd5805hOf9r/MJEvgmANT3YPiMS/kjL/6Ao93VgrkyaPk+aHB5LnpsB3mHsoA04A3AB/I65okV8g0Xg0wq7B6AzI5Mw+EiJ0Pu8Rh8wXJqvRu2iiImYc0s8rOh3YnWcWKX1gNyMdYu0D1tF+VbMgLz621hXNjSL4jef+LdijG2UGYsh3MppnXjdehaqf64MMMPljGRO87i7lBp5CBWbvl+jZWe6oDZch0c2i8npX+qJNQ+4BMMvm0VLJVxqo3YQg/ANWBoyG+Ta9QmHJ5OOgf9LfbTorLFRsrpr4fW46ckeCo9Z1iUB4xlmau9eJ4QXa0xF+4BOp6mGzCMqMFa5h284tKJnY1OY0IGQRWflM/+5Vn41ZB4ZnzRyYGHCtDuxrDrcl5GlwmfY5drtOK77uaRG3iYOIPKBIcMTfgMGSYtnj9ZykZ7Aeo3/y8Wepf+4Lgx1pZgOTgVAT+rO8Fc4lwyTqnA5uPzmJOhxA41ppi6HbF+907mQWhj/rnr/BEnBGOPOl9tE3pNz7u4M9HnfBgtD7Zmrlg1291Hxsjy7CKqo7g2P9OAzXP1CKf9vLXH7zizIUjJZDLdenFdjenXC3xnsYqd+AfoXALbBIJb6WiNlm5KByrEBFuz/hT+w/Dyed41TLhSro+PuqYSJq2k/rOkTvp6VcRPtQFmjWf1NAOdEptieo70O9hNz71CN3H5/yvQ8mmaUcpoyVEqhdQE4uIx800eXnjwfK/gTPpeXJXcHrhaFhWw97IN3dbfXO2sFW2VW/TYtoB4HC79ArY5oqegqO1TBQcjFglveYB4nATKAhwe3YlS94Az1Vm0xlsW7/GUJX81Cyj1zEqwxw3hrgRMXdOdZXm5Ttj0Rn0sS24LaCinFnu
 VhlT0R9b
 Gme8SYfutx2gXzzF6EI+VTXXnHzXresDrVZ1wyu/NK58Fa3+j8GCJUUdNAxAO7BQ+12grGNmtjDBQlTa26ZSe9eE1AVo3R++mNPVGk0nR6UQFCQhxxxcx0+p6//dA4TUECLxXo7AlEbFGcHy0maRcrlz0z7bbjkWA8UR63fVygDSSaTLcYkHUHlydHow2pNt4v5yxrFNwqaJ3+SKaFGGQJber7Qs225g/boC7zceAe9m3gSNJKGvhZywEfG5V9zI2y85Rl7oNGGGAgsm0fnpGNxwAZ6y2VaTq1b31cVFoZDRTzfFJrkezkfXLlTMWdsCa/NFshHxDeDXlB9JABLOa0cgytzVExOOPNnI2VhLX47AsAlQC/OBfqLXRpjapb1pYLbDM5pxpvWSIEYX0EzCVii14v7lg/Gyy2LWhVnt3olk1hLh3NK7H0BkN6ccy7CrlF/P9h7xC24w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 19:12, Muhammad Usama Anjum wrote:
> ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
> return a software PTE value. Add __pte_from_hw for both generic hw_pte_t
> definitions. Read the hw_pte_t table element atomically before converting
> it to pte_t.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

