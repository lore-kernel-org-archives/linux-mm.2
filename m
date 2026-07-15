Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB6BC4450F
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465DA6B00AF; Wed, 15 Jul 2026 10:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF246B00B0; Wed, 15 Jul 2026 10:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242656B00B2; Wed, 15 Jul 2026 10:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D41E76B00AF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:57:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5432912019F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:57:57 +0000 (UTC)
X-FDA: 84991315794.24.63D4D0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9B39C80009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:57:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPH7HtDg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784127475;
	b=XlTryhoPhh4vqs3WkMJ6YDnmgAqknVuSA5TKk3wwaWkJ8GTkfFyQiry2NVWiZr0EOz8rJk
	nmT6M9LOLQK/+DZgYRraA13BRhFpHVSFu/rVcTW2jcW8m0tEo52E0T4oTZlZhfOOZgy3mg
	QY0BaySdKSODgmxzngCXgZgn39rXt5k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPH7HtDg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784127475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+WsmMVZ0fijyeATWav3FVb2hBbQqIKn5lxc8dFuRgY=;
	b=s06KMjhQki/0ogh4YSlLvgZO+cmxEYUEWPUSO8J3XGhkOWb0KMn54rnTF5sTH1bJ19NmKA
	+Uryy9RGx9CvaEDxmXbcd/wRbdWzJWUEF699JEQGxRO66pE+5ii63+RZ+ScRpyZlecOqSx
	4SY3erjYp+csYpwDueaNV7rdwQBR5SA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C2646138A;
	Wed, 15 Jul 2026 14:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA301F000E9;
	Wed, 15 Jul 2026 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784127474;
	bh=z+WsmMVZ0fijyeATWav3FVb2hBbQqIKn5lxc8dFuRgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cPH7HtDgs6cyYjA7uPw3ObONQWW0lg1fg4SZgc3/CVufpkG9c0IVzYYGe9hXpJnBM
	 EciYHh3CSE7MsJrRxFvgeaYvVVnyILFYrvi/K/lkgNkbDtTyzGT9fTt8evuEFCYNKJ
	 /6Q1cuzJWTgyEGbjV+4NTGMIIJQCdHaCzseCZF6+XN/OuEWTRyQp0SKjbilU0YyYVI
	 KJtH/kE43WeJygbG8X1i1uYX0DFToUTqRXR85bojPJPv5c5DdI0FMc6v6EjYbL3/yj
	 qOBAJ6EwOOA7jl4ITRmK6tGfFqVRS+PJHWo5bm2GfnQezZhI9NSeNqI7I+FBExuksu
	 LjiPFApKHUjLA==
Message-ID: <67242b7a-d913-48f0-a2fd-56709e474b55@kernel.org>
Date: Wed, 15 Jul 2026 16:57:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/33] mm: introduce and use linear_page_delta()
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
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>,
 Ackerley Tng <ackerleytng@google.com>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-17-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-17-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9B39C80009
X-Rspam-User: 
X-Stat-Signature: dukr31qyiacsibgc4tghct4oqj97aag9
X-Rspamd-Server: rspam03
X-HE-Tag: 1784127475-484102
X-HE-Meta: U2FsdGVkX19OyRbhrMvDmSekQQHvFaSLs2Zu/jiTW75t/scfbZS+I9fdVZtsf/1JpvLdVfqEiBgSwd0ay8pN7AC3QdaFejj0/D7ToD53qXF6U+Lg+fquKxxVd2my5uRIE0P0Qh4w28D+5M/UY8dEgy0Ukyd4MTcZKUdKiVjTuouvYeYeZG9pC0HtsrWZk9Oosc4ExxuGZJeIQsbB8Si5JVwmJVcNNBW1szmSRMs0bovb8JVg6kAIa7qRBOLjHfcZqEd52rXAygT+g0epb8flPt3PeCp2lQINTM4R6HCcUcVcfWl9FEGah0ox/TufOMdsOPDCXiiembjiz73xATgobsm3/K7XrgycSRdwue3i7kRLnjXtZHBULZcXvMgLxsL+uADDc0yolzKQWCP0XfG1Ne6qzYNu80EK/7Hjt6RDtu3iWm64Ug017ui7AGLFMW88pxjGF/j19YB6bGV6SHvIYqN/AariHNxLY+rUfaOsyPooVTe+NuJO5QmnTZikv0Os+2I4yy0ITDYK/0BhU/r9ne5VIHe2YRAEwD1KKpHLvvlHtx5LmI0tye28BoufoBBVSOZz6CAPp/5M5pleVH/c/UfkDuUedNGuvMFGvniK5r0E3thvMyESrKtqvh1w67u1117TRWlmpSopZKHHXgQrX1bqfzygjfIkGFyD5T8F/m++DhDXaf0ZTrXoT/yaTt6D2kbRACbkecxun2ZtPGEtcFurtieQpqdVDG0XbIONjEDf82wauxpIf+vXP/qQyDg+xvi1zf5SmJydWE11Jmlu3GOCp53dyw/iAOZKSTxp9J5C9QiTPChAwz+kHc9v4ci+lx3ih0U8hJCvQF49VMjxv9B/Su0g+HlYnljWILAY7yd0WKe10j+s97a2uUp5jaunyVkNyos8S/FtKqjeTO3La/Q5Dx1eVNorAceguG6cGJPc86nwVqBgd014Ql46gSB3mIswujpckbmzBGhbHsn
 HKP5KfFY
 7Qc+9fcmo6W80x4HRSSwJpgsBvWKEJKdA/Z71OC+gwIXrnbv+rKEHuYFVHp/mLmGmCP4zEpsuMSfff3vmw6+vE7pkqC3XIASSRiQoewvtf41LyAk5yD5Df1KS9t+z4UxPjJssZlewRJ/QVplpX+O+k/cXp52LLros6ZeBBUuOlRSBF0scnQYfgi1urvoVkl6eK+LIoBroDOz+fq/JZIrt3u9dNDHQlDmnmPrjvlltuDUMpVVwJ1UNVFAfOPdYAtL/Fdnsm8hGw0vP9zyeMuCc6Vzp0XpkjM7sYCpt6wUa/oISz+Ru8pe7lclW9iepUPqqbCgKdGc8UgWOqwvWCG60g8Y4dr8e+eow6373OHCmCwmXceh9W5+8ffyGc3IhV89DRFiSnmLKzm2C2as17RllgT0jfR/f8NA7x8w9nYKF89thepVLTxSr95qIzi8f2Ml1eIdNYAqhHYQEfxGv1uqF6I1bDZg2JCCxIW4wR5o3AGuyeJyicWLj3ocLiBLNBpEzt5YS44/BKeQzzsrdFbuMWTBC3pD+oIq4I6/W5mRlJt4b+FoqlHmPseYqDJ4YPV69JtyJRY1ZJZmYzhuShRj1Qq1Q5hG3jno4s+KDVg+A+beaegSCe5Hb0p3ge4ys43FHoSyMcJLRdT710qNhzZUdBZ62asjoT82CdU8sZq9T3zZjiyXvGg3H0m4SRW5Tjwx5WXzLTmaCE6W0Ks1iygGw+UQ+8KIpyX1sUoGIB0RivOwp7uAKMpjQqJ9mz0m7jzG0zvZ53qqEq8cA0guP57e3/HwVTuznAYljWPzbTNnORgXH6bi0pcyjoICVQl2YfqUGrtQJdWmClEVVic0qsKxuhnePH/LR7yFeOT+xKI9MnESVuWK1UqbOcFcy1LInjXwatvPjVTw9kbPo04mwSzt5EQipdEszU4rMA5T4xf5dKIYDbT+4A2MFlbPCLP3sXpqinljA5JJGlBiTgf0sZgZy4yh5BCLS
 dtcsNiGQ
 vb8NMFQYVTe81eR6SdYvJbxRK3a4fLxO/7njicigf0p6nZ2PN8SFsjfDciUxaHRO0DhqmAZCJ/Y19Jjm4NAUVyVBu5kN/0K+uIE04+vuQHKEW0MMvVsr8Rurf7Bj64uC7ZEEgbAPhlyf+Wgw1E8si7KnbkoT1+7RpZJ46uPS5oQv2zdNL3KKGYn5YaG0f54+wPNhuDhFrs8OIhnqHSK2UDPWAWuw8vOy5f+dat/yK0CSQ4/Zc1J0bmK67IA94NRtvz0hPwN8AbMF8p7zKVOsnYRTzxLumc5clszS9uUdOGLe+GdsTvFDE/cUZzqLiPk0E4swolZ7a/RZcOLftpGo9iUYzjVkkFulCVHYlS+kNJnxxB6XW8ElJ8KwuxSAKOa3cTMixmzp2NhZil4QyV0JezcjkpDmrUfXIS3rs+pkA0lx9+a7B3VZbzUd5dnAi8NszWyUKw0drXpEEjdEtc/5kn4T/RCtFoPNTHzrBmS7iFEeJg+UfFmkD7gd2seALWaPyq/GPsqXNUXC7pHRjMckJkIuzHEP1bXnjLLCidjvlJwZ7IHW1Kn6EFTrwkiaqm1+7PXE5f9fyegsYKckX1FgGjHovuWLbFb4gaApCqfFBu9/Fou+rwZoyF5yztWpV/WkSo/bVzJ5FHou3I13bi/8QjtvwQEFQPwsAFmh1Wt5rBI/RbxB7cFuPlp+y8WvxHy6bkpEe6yTBS3yQbPkHI/8C6uUQye43yVKQS5peJc2VzjnxxjfvQxOH2+pN1NG6mTAju+Up/av9gZ7XJA48sL2mJazfbXH/acOphrALZv+tiUe7ZXy1ulFHYbeLr0Ij0koQ20CWG9m4Q/fm+VTbB0heah+M/cVA367yvbH2r5mBeQ40X72HkZzUCxGOFMT8qPi8oIbj8fImHYjp+nvtUR6clMdgu53pU/dltijLt9FXwt0kyBV/S0ZEcMM9PZ+PsKrfpJ37fjwhHicDdXmNibjB+8i26mFd
 pAj7n1rc
 e32HlbZJtljrbUaVr7wTTjTpmyxHeSPrQOdM5Vk3KLnDcZTkfjfFmHIPlkZUXQRRd4CiratjbqzYaZid08647GbKgSx5Fu8MCiHFCN2Iw/NHHdS0BldfchdHYzgB0/FN7lcv7Riy9jd9M9ruVj9f6W9wJcTbzk7KBEvj/8sYQoxtewDA4LQtnHPf6kpwB9disC33OM00tBA15e5bSWkohWjVAl8ru8STl+m3/VTtAWbl4EAFG8o5lPSG9E/tdui5OUM6af/t1PoJ2UKcTqa0Fh0zK1j/qvvwP9qRgPDPR2dSfWZhrW7F8IrcnwEX3nqPDTd3f+8PaQiwXIvOv0f6kuPwoo7EL/ArJVMHz6tlTOGWdNrdTzeaMIF4cuPLKucMW3qm6/p5NNHdKcymm8r2O7UGaGxDiDt2+Aq9VaUOFzY6qnh8Kq030exmEyXRv87hnhhBTYikcX42PGWTR+rKgHGCnd3JbryU7YTWEyOyi/7LWkE7dehX9e14qmJcULyk+hY65/uWI6rQOcjN+vqjWfjkNHJX1mq7LTqknCDoJ37GBBD0o1vJBXrCBRHF4KVDhG2jafDLpuVSQGpKun8/LTSuIOaqmCEnqsoLsZguS2MCQ8ON/6Z/7SSj5qdNISIpy3RhTr8DTaJuJQw72nJRR/Do/qHQ269nfpVaSu2PUfFPHbI75syBAb23SPaA57bCJsCw922gq2l5JE4rJ/GTvAjUnA1amHwKVnXNjIJ6Axc7LRaHaKvqRtAgM5OU3Pjh8hlIot0aYPaiqkm83WL5qO3go1oxub5MduDApFdSxMkw3w3jEne1qj544zbnd2NBZe7TmDvzJgHevdqcdjmC3uMSckjkgJkPZbVWUHMfuxCZ543RQlxRuumvHzzsq5NCg80bHHvpcQuVgfM5iN0cduMw9yCXMoldI+fjQijI/PrhZwTV5ALt72Rg7aSpSZ62GRWZm5UNhFr2q0WEoK8HGTf571Cdp
 LYws1XmC
 /Pau76RlS3LdXi41K2ufP+fCCNNAAEr47HY2cW/IBaa2q7IUwj0evaSqcH7ZmdZA2WgEzA2I+w+ipYVhOY6Z3AdjvnDaBXs5RnaHvPq0Ax3cnzmjysPG54zvOTEJ7OHcBnMWktIvvi4GstqOIJCvHleIA/fRQZRJ0B2EmZTpqaUlTc91MGTQdcjI9FijMFb8ntoS3pXJLqQ1EKRJYVy6M2on6gWRJ17N/Yp7M3M1LmZDenicScFvKmI6y9DkL9NFZoHLIQdC7e5DIlD7NCoUeBCypZOqMt9H8n/PL172mRYUF+6UR/MjrXJfZPWzyVQfPlnJC4NIRralx+BOzI122Uc581X1cvVwQbSC8T1vj7xXHa4Q2dAtUIelLHqy+wCgZ5Xjj2uYiLpCojzqWv47NTrMLkF63ZWFifLmVbzeE1zIxrXNU+NIpPetwjIUzZ6lIhB0p8LJ7oIIaJSngm1vWkcK9jalbmf84ZsUAWezQuD6SQCOdKZtP5Cqb6Apb3bo4KZ5xOMlt2+kpfCIGC/X3gl5OAtvSpj0raExdG+d2ulO3QBnYC8I4lVR+z076xOZo5Wsbr4gdfbgL4Ha0n+4UjYwTtgK7AiiQsAdH9bVSdOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> It's often useful to obtain the number of pages a given address lies at
> within a VMA.
> 
> Add linear_page_delta() to determine this and update linear_page_index() to
> make use of it.
> 
> Add comments to describe both linear_page_delta() and linear_page_index().
> 
> We refer the reader to the comment for vma_start_pgoff() so we don't
> duplicate information about the meaning of a VMA's page offset, which is
> also less likely to result in bitrot.
> 
> No functional change intended.
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/pagemap.h | 33 +++++++++++++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 2c3718d592d6..a950070b045f 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1063,11 +1063,40 @@ static inline pgoff_t folio_pgoff(const struct folio *folio)
>  	return folio->index;
>  }
>  
> +/**
> + * linear_page_delta() - Determine the relative page offset of @address within
> + * @vma.
> + * @vma: The VMA in which @address resides.
> + * @address: The address whose relative page offset is required.
> + *
> + * The result is identical for both file-backed and anonymous mappings and
> + * simply determines how many pages @address lies from @vma->vm_start.
> + *
> + * Returns: The number of pages @address is offset by within @vma.
> + */
> +static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
> +					const unsigned long address)
> +{
> +	return (address - vma->vm_start) >> PAGE_SHIFT;
> +}
> +
> +/**
> + * linear_page_index() - Determine the absolute page offset of @address within
> + * @vma.
> + * @vma: The VMA in which @address resides.
> + * @address: The address whose absolute page offset is required.
> + *
> + * See the comment for vma_start_pgoff() for a description of what the page
> + * offset signifies.
> + *
> + * Returns: The absolute page offset of @address within @vma.
> + */
>  static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
>  					const unsigned long address)
>  {
>  	pgoff_t pgoff;
> -	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
> +
> +	pgoff = linear_page_delta(vma, address);
>  	pgoff += vma->vm_pgoff;
>  	return pgoff;
>  }
> @@ -1219,7 +1248,7 @@ static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
>  void folio_wait_bit(struct folio *folio, int bit_nr);
>  int folio_wait_bit_killable(struct folio *folio, int bit_nr);
>  
> -/* 
> +/*
>   * Wait for a folio to be unlocked.
>   *
>   * This must be called with the caller "holding" the folio,
> 


