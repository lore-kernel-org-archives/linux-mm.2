Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC7DC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3174F6B00C2; Mon, 13 Jul 2026 13:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7E76B00C4; Mon, 13 Jul 2026 13:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168FE6B00C5; Mon, 13 Jul 2026 13:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE72B6B00C2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CFB040145
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:57:20 +0000 (UTC)
X-FDA: 84984510240.10.1C9EAD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78F21120002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:57:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1O+yElX;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783965438;
	b=q8we4ONt/KswK7K42LDdQ0DCMboGL/gZUg6PMCKvwLT6Qlf29neGDU2dO8SQZg61wh71kC
	PYyMTRA1kiA3j7rB8eXIM4O7oCzSqyf+o3r0Tku7SwmGOah1U7wxTML2p/O5rrJTDwuXQU
	0oHKntmYoK+bewWmBSIDV+hWFVDAfSE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1O+yElX;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783965438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pO9VCK4bbjDr/iFXBBe32IJs4DHT4WfrCqDsR2JO1ds=;
	b=pjmRJAyoJ2ob4iySSkMxmfiCvB/fMmeMKOmPet9FCBV8vzCeSIZAoXqxXBA2ObnGxPZbqC
	2GZlACO/qWbqNYp6iX8ywQooZRgoXWcfK+MwazAuPWTE9YY7TYrNEuNDxfhmV1cQ9nC36q
	aquKGGxoh+bXjZ15KVrbuos8+3/DOjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89B1041342;
	Mon, 13 Jul 2026 17:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC8F1F000E9;
	Mon, 13 Jul 2026 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783965437;
	bh=pO9VCK4bbjDr/iFXBBe32IJs4DHT4WfrCqDsR2JO1ds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X1O+yElX0zld1QItxjIAp/yc7z2vmaIPA/t09/JNbxUWZPTgMzSsQ21a1/R+/3SMp
	 E9a1CA+/9+umIQL+HO90uHt+NaXZlLspEOXvJQ8wyiiCIJxIy4irZ9MyYK1uzCBoLb
	 W4WuODTQwX7+Uozt9DisJMQLjV4tz8PgqBbeXTcrCbclLjRaOE02ZcLzHFiSbBhliA
	 31uPjovjwAbHbumZPx2qDvqNRI9rdc1ZuElMLd8H+2P9+WHvjV1sML74DbwQXnHJ+F
	 37C8dHi2/yVpLHr4TULJpSm+4QTnCovaX5pw/Sn5C8HjSZphkJCRDvwtRpi1SZp1Jj
	 l02Cf2xcAprAQ==
Message-ID: <e08fabfb-f3dc-442a-8491-fe4ab1f33b58@kernel.org>
Date: Mon, 13 Jul 2026 19:56:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/33] mm/rmap: parameterise vma_interval_tree_*() by
 address_space
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
 <20260710-b4-pre-scalable-cow-v2-6-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-6-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78F21120002
X-Stat-Signature: us5r9m8m8juhu78tcki653px35mq45ar
X-HE-Tag: 1783965438-465559
X-HE-Meta: U2FsdGVkX19nC3VrAE+v+5DT50v7HfejMDkKJGdrVEbVRW6d/Y1vnQ4xAA80fxbO+z2WQIdmFtAtFfkFaSrR8FoDpl6quXnk7PT1h5Aefe8H5hHq48THGXkU4j4Rstfm9mgLCpZ6yfG3ciJHi9zA0P7AzinqzlnybCbfIXfGqecpp3pTl4udqq+T91hD69SiYSew6t2qN+M448mZOmRfxcjB/hteQSQI+7T/Ggoa4kHXsxgUkebaUIlWhOjazFR7fnEN46WC4RgrTIUJ99CXR8YFEB2PLMH0wMq0TRRokVTL3zlE0wOTQnd0oXzD3EZJFJHn+Q0+rkaXSvnSYD8IZPagHFF78+66sPWYl0EaCastAOVyN0Y8MNreQXIImOe+vnJ9dX6uMRM4RT2r9uPi240pUlI3hX4nqT5u2HWOPQMjW4zlnrOsOBEcGvO0V3TV9dd7LAuEEyYsobnE21BVsJvCimNp5qnaoFUTM6DyZByFN3lmo06biRiI2k1Kaa63rg0tsl15pPDx8M0oZw+MW4cPWk57o+i/S67CuCWA9dxVqtytukdLCzv0G/kHjR+X9ZojmBoGS+Vd0fNBZddLuI6Ewis2joIkyOqlTDjWkGaAAvGp/npoXYc6E0t8XOBeLkSpE33DUE4/yk3b7PAobagJeb6pPwD3pIc1YdqBWv72ecAsWEuyc1qHHrAVFFATDp+feAgqLYeYKZxGWXAKqjFMKJ1eNwHKKDCAsIZivwFF3dJz4xrZjoEdD0aEm6ETwnbUUQsN1h+AjylSGa7rWG5o2s8YyzPqu29aI7ANZwLfJ0puc/bBUKMWJq8xry+lKNonrZpJTP5y90JhZAj8K4nNcC+h+XMoztCqt2OCgLVr3ga5d8fDc8nBZtaMiE8XF2wTvXnIOcoEzFiLXjpZa2wPcCxClg6dTxY6vwfYG3USLboviKYGiw3tqkD7xPRvlVrKB0g8cYkUqpzdcs2
 n7gQgija
 puf0KLnv6gtTvB9P00fDqkuEsvCHqFF1LqJoAmQNNEQJ34T+LVI056Gf/MyG7cVtNWNmsmAfT/NlBZrtn62xYizmd40gJiKPbV+bNWVf1SjV+c5UV4rSpLi2oj+OHl+szcrpV2ZpFoJ4H78N7m7AV5wMuHbpUC4ZGJ2AeRru2IN/hjxo0Xd4lT6Zl2tqZXu7aU17JLrfJ3cP+GGQW4haWlvvCt9f+JivCqfWTlsItlXL4cg/pFvSnPHvLj0jTAGZ1A2ijWxcrjLTrWBgo82WR/JQf9tF4j39KyHe+NEgDrAp3rGyik9Szo3ksf6j+GDjFRko8LIlVri07MmWNv5I6ZLAlto7WRlPnvqsE1YWh6BLk9cZ8S25Jz0sL5EVkaNbbrfIwdNkgebFhGv+X7NgJg9NRRvccJGyCOjhBF8ZwyBe4feHxqoiRy2vX6Vka1L1hC1jeQEyjtF7CPb7mrxP6iU9a0THwMp1Ol9rxzPabB1421jvK4S1rwyy4c5IVVYjj0ghXbjbQ+CIKkfWYoKX9DqtsvpRF1IfIMGMs9qpk2Bsn/Cw4QoLhCyu7z8fFOM80XHRyI5ie4TBaNzUItlEKlaYXTjihi3GzM5TP7bXvB8R027SZuskCsNdq9jh6lE78j/uLT4omrhWJBs0kgp58/x9P7AyI65LBVxFhjpATRQnMkUkoAEiTjUlfwrIFddPcdJ4Gjv+hRLfJOXFj3V9us83jolY8zRcZNIqDZegAj+bl58uNePRlaIq5P5A5OOeT29jUXWPGCS0kB/MsKNWSu3AZ92cT+ox69JaryvuOZHIu7dvmdOT7sYI1696lENN4eizkEyNbme8WN6o/KWPGLAhoj8weRCItGIMk8IeBaUjFyyhfxKobbqPkpUTGNmgoVaiMt1AU0RHnckqtZNvicYCjsn3pdvae/qsy6dckHtlFJMO5Q0gFPbkadvilITHjMyxlK575Xpn8qq1Z/j9y6Jc5+w6f
 DiKVpW9J
 ozAzLV45ImuaLNB6pqo1rkxklSJ5RnU+VnwlWgo9oFPKMAPVBwg8dJi821vpWe50PLCwVe7oX7r0XHWkJCDaqDu0VVs+ubMuNYgf8z4GuFJ96eboN9ofBQLUt/ZMUk8c5Vb9ogu0KgLwG8Wm6kWg5KcfaTOQwcKaXR8AobAcMDnMDyTdUEh1DzAvWbSDCidN6l9nED4wZZj7i6UL2fmCg6z7RpyNLRrSm0WWT2V1lg92jq2i5QmipRFFswgVszI93B2YnIsUGt3+7mcWaVtp4hITen76wn6o8Ca0dz2aqnBC7jgI2GiP+n/X595nbRM1RjKeP21v37+VJgkaIrQdAI+kvKdo0/SwudjDjvf8DoP1cWa+nmR8JjXOJTMzDT48e6mxuBbhc8v/ww1kM1v7Ww45Ti6RYKjJuMzYVbWkXYQwWBYgGS6BA+pC4MeP4bVoF92ekeZlH3y0+BNIkADXoIDfLoechyT2sgG/9Fc3e5cgZWo4itKWalFnt1bnwNGHP2KCewdFls236hOA0TEsjMZdf1GZNQlYDZouU5unFC8LiY0la1UbLMwo35YdbAUtGsn3TpyzBOxFAFMHVsCaKiXEZq86iVVlSHxiZrVxKnGjLq16XPoUukc0FazQGbbXMf57BmIWXOevtPWBmHYMliOkQC6qVH39/6TcpWRUiwed/IxCr3vrB127FsflKh59BTKRmOMA0scxpWN07HUyzjbSVuIeUuZhUEK0+31O8i55/69ckUkm2Bqmv5TLj3JcRg7yoUpggiEDtY/QHmru27m/AIdBGarWPYDbADPWjpKSPmUg9KkjvVC8W9eGixgY9sySKMVuIqGMzWQsjs16e1IRKCLgMKvSB9FcJCzB5A10mEk4m1xKduJ0nUduE9dzbjZmkyD2aELqxAhMJfMnDFg37inH8NRsDJakOs/4ZAs40r1ZoGMDiaB67ShtNa12KzoZrmjlm/r9eJp75yphTIFtkCN70
 PtRI4sCP
 O401b21XTX1kAeUIEqsbwoTuLpk9ec6egnCsLgnHHDIUVtsPKHSMavvXCO05IvMkUTANmN8SJFlIld/gfaMN4O3Y0rb89B7SDrKwDEkg6JgURsAXAsXCEzxvU8kRLK8w92+NEsTWIZP5uQDPpk4YyohTdGPyimJr+hoWVAxw9Vf+ccrHfN42U+fvz8TbIYzoxpO8Sb+AtIGjWFi2OFlvcFtouE/ktDVw+O0nwIHrTJig6SXCjHCRkBH0S7D/esG4lBmp34uzos+LYtxhFCn7+3Ge2VoqHZ0IKZCK1RKUmC5NljT5RGWHYHNZOfoaiKOnaPUM/rHCCWeFLEsM2CwZQqz3FIbavXecOU4aKCvtRPYMzR6EnY9EMXX2tbD1PPU7k1WA8dTvQ1y+NeadQdTwqDCKEbEthiKiO0R/REfN5ZNRaEabGuEYpw7HjEtzeGMeL6KVFx2SwnUII/0vZc3U/VD2YqUyTVUqONqDX66gGNBEbhvHRnYWVUTh+vg+4FChTEFLcVgttSIafWE326iOLzN9Lm3L029+ecRE9qLwn3w6JtOC7BFR1A1gyqEmhTxRJyNykTbLacn/ll5/rP1nk41WLo1owf35fyWJJaDkn4IQmnBZNVr1eTXmsToEQkBKSGZK66sDfiPXiyW2IT9IZQuLu6fBceik2SJahSjOwKqbwu4ITpQOK7bd7k7EIgOBhBpvyKDJM0SMwGpDQiSs69ZsaEu8lDlGeoPVGG+dLmykgSP37QbkdV2E23IBgjr4uwXaNZqUUAFVuFbyXuLVQQDhv7LoGRzzgU3Hy25a2dIgvoFYLilM3/5RQltSi4taRu3K1QeNzvZs84qtcEE5ICY69VCa/RLYt72llWaKTt2nJLwCPZKw2SPIVjDNwmazaUj41yJMXzbnbiU1nUS+wCSjw0a4PiOwQHsX3TXu9l22vFbSOj/FAwaAmc67vXnejfkQglc6XcAs+RGxrtvvzDYNZ74H1
 NJif7Li1
 rpo/9NYW2CZ23OHLY5w8EsT8nAiEPC+ForVxHZZGmiGGlKBwUwyUcqBYtM4176tM4EOkjYKyLHS3BT7s4O1ByPd4GQMyVP3/ljCp4WefnnDzA3dMZ5MbxEK09p0clZqeUVQfvF8SgsmCgnA5u/eXRA3dHDEGIXF1WnN20y+2Dti5aVPljGcG8hvWWGKE22oZKFsp87CCJJWr9jOU1M4ekDA9IEa9qNJV3R9eY1s8cFh6cJw8d2EpG+uGXCbjDfIC2xND5SblnUinF7RD3u1Cjt/ICg7AlAJGDLtZPDnwQ79YFvI/ECWlSe8PUvGOCs/II50VuGIb6sUM1CdhNK01CEUben1OrUwFeXw4SmpJAJBuadX6rzsMbE7069fyhOoRHVFmNIuPy5ApvaN6okc31oWPz7Ybr8xFXqU2OZZYfKub7I5Bg7qsXS/qZh3vI7B3CAb2pRMViJMJ3rCdhLu6zph8KF6QUd2vCtUzffLiUD6A6zpPk/Z/zWgOFjMnSkURzZZAzs3Bo0/Usa/jg6JPHeZsgGwXU53e6/jocfUEhJbW+DIGnL4eF8PS9iEAqhwduCwgOV567UQRGrlteFKyTu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> The file-backed mapping interval tree functions vma_interval_tree_*()
> accept a raw rb_root_cached pointer to determine the tree in which they are
> operating.
> 
> However, in each case, this is always associated with an address_space data
> type.
> 
> So simply pass a pointer to that instead to simplify the code, and more
> clearly differentiate between these operations and those concerning
> anonymous mappings.
> 
> While we're here, make the generated interval tree functions static as they
> do not need to be used externally (any previously existing external users
> have now been removed).
> 
> We also rename VMA parameters from 'node' to 'vma' as calling this a node
> is simply confusing, update the input index types to pgoff_t since they
> reference page offsets and rename the parameters to pgoff_start and
> pgoff_last.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Nice.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


