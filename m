Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F91EC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DE06B0088; Wed, 15 Jul 2026 13:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CEF16B008A; Wed, 15 Jul 2026 13:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723D16B008C; Wed, 15 Jul 2026 13:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3262D6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:33:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BEFC401F1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:33:27 +0000 (UTC)
X-FDA: 84991707654.02.2DECDB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A93C44000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:33:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Plq0sbET;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784136805;
	b=J7SMM1o+KIj9EZS6QzCE+SMQ1wj0LYmkiKFyqDObw8jU2jXwcG1afTip3FmQ3Dfp2Jqozd
	I7HyAGVUwuD3AgUGLfKoCdXAD6+A6d6DJwLlxYgqoePpTSpGk9ZbCmiqxGhtq9tkawjcov
	eHkHyjr7b4OaNJdVvNm0gQnK5MTiWq0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Plq0sbET;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784136805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AbFSf57xlvRU+7oRSFFrOCqwNArP44ynDnY9nIh20AY=;
	b=zZTN3JyflfZYCn5Asr+hHHyf4rPtJR/yXcF8wm8aWzMhWyxZKclgxGU0DdNfoS5Ng31Pjd
	WkYKHB9hON6B3HPYkj1Ufu9GoDi2nWFUfsvMy6/83v2kKsdXgcyEQAimcRR0DQaPQhsFXd
	AhO6TuhA92fSg8XEZfvZTe0gF/XdCY8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F2F24344A;
	Wed, 15 Jul 2026 17:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969781F000E9;
	Wed, 15 Jul 2026 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136804;
	bh=AbFSf57xlvRU+7oRSFFrOCqwNArP44ynDnY9nIh20AY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Plq0sbETLnXdMAnyr13Z7qquALZkI61HIXPlDtbTJXle3KmIPSHsRIwRYmKnpLWlo
	 19eJ5bHwIL3oVOiP8iDflJPmZt6j5Nw6MrL4/VfsyRh9F92YzgyXkq5Lczs8NiSMUN
	 SstWyL1GrOp98wvFI0l0tVtqvON5NCaGqZvAS8cVtNQkvzu+Lm1N2Vmd20/5FL+Jxw
	 KE/82mNtPPptX6Y3tbqbGmoMiIylHvRURsOGhlxwi7dZy3XzZ34mvZ0d/HomYcJgHU
	 iBrea2Oz0LWMg2oxV3xJb5F+NM9SzEsbtXr+EtFE0PGDRHLu1KboOje6+diumQQuqQ
	 LXqmrN3WsVtEg==
Message-ID: <84b0cb24-ceeb-4a8a-ba6b-cba2c9f9c4bf@kernel.org>
Date: Wed, 15 Jul 2026 19:33:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/33] mm/vma: introduce vma_assert_can_modify()
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>,
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A93C44000F
X-Stat-Signature: c8fte9cd6fk1gn8o33rqrqfeanka8rkp
X-HE-Tag: 1784136805-690578
X-HE-Meta: U2FsdGVkX1/pre8Usl/ixL+/glOCR0HpQG+0GQXZMFj/gnZxVOu6mu2Vd350nEI+Do1u9cF8xDAwdBY2m9eQjahsp0K3W13EYf0yPmgHhvUyPILSqFaqXjp3pfBSp96AnB8Bdfui3igClY5/fmg6sqJv0GrpEMl/R9xZvJ5QwzOi+aPXapT0XTFTJuwBhHNgionxaRrZvCDpTrFX0CkXUSGmXJ+vD2I6hMjSQEeoszSSBtaHSnOJD1vZ0SHXoFjnQbZ9UFqbrfuXBmnbIjgJR6LfcoWnnwx8w+JlkctMWIMnhEnyfO+77D109/1eU7914WV44ynzR3w49xVbC5L2kaBpT+2pEac55SwOt9h9Y4V4kZmPiHxUhGp8Vby6x8Yug8LY2yUnkO7X7BmBIbBVa5OAKEt/DzOX0CTRyU2aoShYQek7830gTFjB5LUqjdFmiJx+QHsYDvl7A3kMGVmGktY5LKCUBZMGLMKBc2dQDCJaqAUmWnVDcMFMBrs413DWxyqNzYSYkl5b3bRSSSCmaZN3ghbmLYhbCsNGFLRsQG/8Q4JzwkAz05YfvQXO4CGf+f2clnS7HPMdWlNyBRKBXm7HEO0xFWgTfv6rvqagWnoMUuf066hvXifS0GIgKUyD7WV6jgToLQIS/+A3OIjbNTPXGAqLmrRk101ZpU2kiubx38zK1q03ax1Q44Ea5UGr+ZWE+J17CQz2Bpx+7vaPeSgPWWM2B32H84JNXwGGvaqf6aOtEqKM89cBPqL2B9ZsnAeHoiCf6B9DSCtXf4bgg+e03kixapti4P8sRG1j1YkFK6/w419PUt7IwsfZzpeasOBjsEzA/P5bCtr0qOzmnJ+B/Okh2yEfFdCwDvcwuSeeIkkNG1dj+s3kLLJqt6VT/PGeyOvqEY/1NU+DX/B+yfIcuh8HQEA/QHCNSjaKqO9JQSCoOCNPAu546M0YoU1OrBGTOS2n1UfghvkOM59
 +0lykzZj
 Bb1Qgmij25q3dCfCIcKM34hKlTcRPpnf/SgajHmJX57kz+Alrz3Fe0M/Z8a1qxrb2UvbIZ9SwGM6ih26x/JcTgLhqr+zHmvNKa7ttwD3rSTNiR1h6aSVkj9V532yQElVKSQmrnehChfiq89LwQHpMcBJcRqaAiJdYbVWbqEuKjuqqVXnuYfmB7iK6NRj9mgrpYIg33FiunPMqbb9Jdfm+PDzk+ppGUGecRxiuIog5oqNVN7VxEmuY6fa/56TNaoP/CcF7FZDNqz+Eq/ngWXV1bFalbSEzdxu3FRRP7Hkabn1KTLW91GC8jenzzrSoU8Ufz9Gryp5yJ9GG6u7+KRKDHubIGMi9ccTbi1qLhocRpJ6HzedWcjK4oEZX7BNMvtma4w/PCri13qNFGty/u9ZHVPZ2ApQ13JUyh6KqtOA6UJzFCguJjS6zaFC2grPfEW8t1487tnPSPUq1+6rTMArhJk040r2maeif/R0lt63wwa92Q/RYNTrhXFgunP1tNZE8QoUiSZs1gB0nzwyb5aBJ/b5LTaDFiMK7hdwKbsEuoNM34AQk1vDJF+OCtiogeVpzxUrjYktme8Hbcc3PFoLdlVLkM3i9XrOekLJwmUEHKuMVIEzOJcW83IkrO28VLPcQh8duizxmSlPG4hGgTxe6A0ZMYhcZjIHBK36x08BXM1L4faloeX42CilF+OI5zsHJxSU0xaqeK9mpQsJI5hD7dXC0EB3yCjj8lfKgiGfO88ddLlyY9byjlp9DJ3pG3XxZhC3HN13JQ6LgqIVwnPnPZmk0a09Zq4T+VApEdnE03K3boVRK8kAvCsWnAk3YAhaILmlcu9deIflcFdLOkTCtLsPRZc3q7blS4rZ2n0gMCuKBuOP6JQOISCfcM1anvDS1LrgPv110Ixx/thKSJ1YdfsoN9mlhOxM2RU2Q8GUK05lvMlew+3wslbQ/GS1WSYrS/N5UQoVlIvMEqsKTwXRvZ9FqL7fM
 7dFSHJ8k
 2R3JuCoJ7DDPtVLh0Hy6ZrwmOdZykElqd8o5Qbl7y2hkFhrOyxI9twO6aq5R6CmJngXdA7HOdLx1TLB4S/wnJGV4ZjHgRRuMv1ZRPUT4k2zfGeDbWTAUxeYzRZjz5QzInJdbVRiqtCw3Cmh0eqsZx8YGbKmYIGsIB6GvSensDpVZjSdW0IZxw4nNuwu5MDrHUCruE376E3r9PjMrIFpcxlMQxovm8Mjxuo7Zc9QqugMd+tikmZvBk0G+Yf4q6/t0HU9acs7NnNnSkX8s9w3YWhYIWsvaa+7Hp7TWlgmFe0jZFY/JQ6Tb3JB1yBmoJGhyxN0vyipMUcvADCb+r7mK+iO969XoxQEsiYbZDx+xnFtde+3KhCnP9APlx+qz7q27x4CtoeYTu3aub7wJfvGOXqbzs/rnW5/hIAAKw/uMTZ2PCkpUsTuUw9UQGBFRN+TfSnn/WyxOMXZuli+HM1mzQEXaFbpd/+jsuTkJOp9FoihfH/2ZY/pg78haoXL5i23XGqqJPpRCoBb780WYXW0udcmUoneiXtT5/FXQ7qHTO8Z0L91EaX/iXJibD23ACICYsaPHlgZgoAlFnYpTQqo1QNSMABTFPB2UF/tEpHNJILChxId0lqUw7K6LLh7jqHSH99nPuZ1+M0WxGfN7CRkffYZOezLxllrdTm1E0lK8D7qzqHqKY3XMOk1W3nnDrQidlPU/3WuxrBd1FBwb/ZG23CXlo5DIEWPQ7/1sRJvJwpwgtsMH6OhLSXK7WBG8vhEwmg5yD9KzL6B9MMZv5sb1t8Hu+fx9HXyKETPdHzetHecV3DXpzkPmKY9CumPp4vQ+a4bP3+85+R91UaBR78rn7zLgoiB8ZFQFxupROD0gn8CTaNSVkb94fd/bYoicOISOvuDbuyl+wjyWbsrZMwIfxIX/XiLF0KIIOZgfTqS/AcyeW7m1i/r1XKgDTEBsTxml5kgjQi+vZTZC7pWT7eqHz1L28yT8S
 +XH+KGhZ
 OIyVM0d7Da7+WptCy1NDtOb6AR4aUwaT85g1JEiz+Q+DekTQ33Y8noB67RWgFDI5oSrahGrlLZMi4A+xciZ0EFQL+WNzg7rdfeqH0dM+TzAzEe8qbj/wp3E2vziCFBOmax5bT60SG2C7OInl+/A7jV87L0z7KO3eZ0tmz3AYTrw7hfUMJTbkCyGsLInY1djI40psdesQSMcUOleCK0hBXpJNdbZYmywd0vvK7u6LzE3LxdDh6xFJ2SFwcCdsI+hX5Nf6FlPRylI6SkcZfx/lcHfdDwhHc7oc/kxTWmKj2X4W0K35gsReMIIzWD0NDtf+JtTDSSBkF+caKPZh3HrvXuhjG3SzgKvTTiOJ6ppN/koPubG++O6LGdjcx0tvMCHi+/asScjoEjhBU+6sEiIJ15L/RkTkrxZQfceTtjkJm26HilDKfkQJycNILr0a5/bffMDiao8mEgRtuLggjHfrUE6acoUlmV+IN9bKzRHwWrimQ+sT1OoJzfZ0uVODSiC61LLdn+NKJJM6OSoTz7ToVERGNI/JBQJGDVx0HcFHp+tFbK8kk6lOOryyOL5thaKMFgxr1eQRcbzIk/AJ01EY6IKXy+AepinfFIPsxeYXSgSSbJOMRlCz7hzUtJBAylC40rCjVVVsVhk4CoLZGo8tGwFa54sUiFNLBVSYOScgZ/LS7RPHaJ12OgoocNQOW9iRiLk5beTxUF64Ot36ZkJQCOzE3f1dvaZqiFcdADHEclGsT+s7WzXQPcQhC5meR4pOYbT2bLP6ccNjH8mBYVBgmUsUYKuAeDXyEzSe0GnTOuXWAQMix0dVuFWnRVSa+oO7BM8zVI04qKDcQ2nPBax364Y5qsNJSSspsJn2TXQjXosu86oBeCnujopCiES2YAWhS/py7+HuM4rZSTG4vc+kYGyE7JXuwI9TJOETP3azE8tH0/VYF5sLRJauNm0cQhC1aNgTOtPhAze3fUOseuaw+L/C3StE2
 xXxu72yu
 bWYKxxFnWyvltq7FUSFp+uEAiMbKhmVqhO9Lb25ds5oDQen+1lic53ubKc8APGUgM91VsNMxub0X2c1320d5GqOsqrT4/d1FO1STRF0K1zr7wbLTU0WLmQDXQ22jaXecLTICGH6JvE8VD4iyMMzPqDmj7S54i2kP3sfMehP+4do4to+bFrSySiswLQIbqzNTLv+5KC2iwFDrU1puhXWvv+Ra27b0zYrw9MrSDPdx1YmE6OeCI/SKeszp7H5Dah5HUQUw0gsEU5pJoBwwGeRAIeDHXnsPPrY2/qZnEDMXuVvYyRPitFgNmXjYwH+CuMGABxnKYcQlf9qB9/2v2CMX8eNylfFaRKeaY9M+QH1Ai62ExCN5OsdRyiNLbgjvPpcb3ijilyNJi72rnmGR3/BIvjyX6iRI9IDI6S3/GHeiU9GNRRdPzscOUzpoAQq3myY6ERcVieKEpAuYkEUVQKt32rqYqlXmdKStzxywE5SBf6QfuTTyfPYPGGkMPUDjn2eThckHm2Cb9SI5Pv+zi9awbwvZTFSvQauPQCCcxKtWdjSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:17, Lorenzo Stoakes wrote:
> vma_assert_write_locked() and vma_assert_attached() are useful for their
> own purposes, however VMA code absolutely does allow the modification of
> non-write locked VMAs if they are at that point detached (i.e. unreachable
> from anywhere).
> 
> It's therefore useful to be able to assert that a VMA is either
> detached (modification doesn't matter) or write locked (you're explicitly
> locked for modification).
> 
> Therefore introduce vma_assert_can_modify() for this purpose.
> 
> While we're here, make vma_is_attached() available generally - if
> !CONFIG_PER_VMA_LOCK, then there's no sense in which a VMA is
> detached (vma_mark_detached() is a noop), so have this default to true in
> this case.
> 
> Also update VMA userland tests to reflect this change, correcting the
> previously open-coded vma_assert_[attached,detached]() there.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


