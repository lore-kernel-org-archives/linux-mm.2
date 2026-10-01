Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25778CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3157C6B008C; Thu,  1 Oct 2026 07:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6496B0098; Thu,  1 Oct 2026 07:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DAD6B0099; Thu,  1 Oct 2026 07:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E08E96B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:24:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1D2C1603AD
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:24:58 +0000 (UTC)
X-FDA: 85273825476.07.2B29A47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2164C10000C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:24:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HLd6Zyta;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790853897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEsjZu9pCpcCr8EB0aUturWNWuV7FWxewuwQYtNdc3Q=;
	b=WILI/eSgXV1iKgK0kTojb1ULHbf1i19hNzqFFV1FXn9/HbwuTb/Rnm4JGfLZVjUavwy3Tu
	e0mMqdhQI5rBfKOJMUbYKj1VpZTtDMCIrayzVnYnlrfSXDhV6iZh2Ac0dOZ9WQt9ocyKpL
	W2OoesEF+J+7SxroObzzG2+BaYD/XO0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HLd6Zyta;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790853897;
	b=0CE8d04YhfLL83Wd8a0eCqRH7vsG987XIIsB6FdmCYoDYURhmIwxBd95JJ15P18MQ5DBA6
	PJ1s4mxhxXZPimII18HfXihFUVSmyqRDAIiKdja4tURfsI1teeb2ANkLSUHWVFHiYXA9yc
	/adyfEpt228zUItjMKpW2PoRvmAXZ1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C1C160A55;
	Thu,  1 Oct 2026 11:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6BE1F000FF;
	Thu,  1 Oct 2026 11:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790853896;
	bh=OEsjZu9pCpcCr8EB0aUturWNWuV7FWxewuwQYtNdc3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HLd6ZytaONgcOlSzOhFnlQrczv91JhiZybTmAY3u05iS4ayseO+5Yx2VI45gfH68f
	 mXtnRYNGaqZLs733sKIWSmsT/TbTok+iiekr8NPLYf79nh6ARU02xgvH/ohonwP3eo
	 fETOL6iAjIxGEgoSPQobLYfo/Pzi78di1CBooBn4V2h2MI7S5tztfoznGBKtNplWg4
	 eE+r5b2np7RtR7+yCaYzoZA4Lnf38OWea5/zFEHAYkRHQkMtrW1jiFt5EvED5gS914
	 LqZITTH/DuzuhMUXkjsJtLA+anz87SER33y0MFu+awJN5mNP2XIoerPKjoK2r13Kqz
	 aX2KDjXmrqxoA==
Message-ID: <48123600-5843-4c71-9ca3-1a9f3062af67@kernel.org>
Date: Thu, 1 Oct 2026 13:22:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] xen: use hw_pte_t for PTE range callbacks
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
 <20260922-pte0-v3-9-5670b8cb9059@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922-pte0-v3-9-5670b8cb9059@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2164C10000C
X-Rspam-User: 
X-Stat-Signature: sdagqr3qqxdfdgreyazz1a3cjyuyonao
X-HE-Tag: 1790853896-424804
X-HE-Meta: U2FsdGVkX19Mdn8zFP2kIlbM8WIaokeD3d3szYz/5xMCaviBH8FR5j6XvcxDRyfk+wzEQkfkeOjYb3KPYDuPuQQAYFAuuwOcFfrVqdPfdmeZUqcm4oZdtf3sPFtj8NLnjDv7JUfKHBVTc96Uj0kKw1B87lWNz+UGnXCasOLzTkSbNo/st4VTLwkWQiQSzH1XxBLSLWMXxcnpQ9TR8uNUGNxgqQShu4Xy3nMY9SAjVUlg16vt0gRC4pLaCsUmXX1bBVEqzgUH6oySTeNqHzd2mW5VXq5qtpqIpY0Vz7dv65faDQeL4I+/Td7reLxz4aDjS0IxF9+Jf6ZDj3+WQpEfB4yw7coGxeAgSwp4hIE49zlaA7pCtBZ5S7Jm2T6jV07poSBs7+NzfA0gVqh9JabMaxtTJmIeVZtp+ekm7i3k7Um1xOsikwRtIvk1/djvMUl14iDWvTqQnaf6mKorso86wvf5lcldnEpeV6BpF13FfvTpqpxihrRmoGZB2jfKi8AzjTXPGT7wAomXXouru+PwBd+tIxGUUJCO5y0PeYjW366I/NBYxRd5nPc8Ft9G3cnMKo9e3tFeldKCE1kbAXkulSjQGa7QcDm7jicUNoCONAZVeIk/Rko7ORuyoPIc9fnWN4A0k+S1NjI5rnhUgBr4WX4suNSyEsLtHT8uWLHOY6YSvP1u1XSk0m2B0/VdNaPtZPFepDtUKvAHhHVSktWyvaETqKqfOjYxOpmEaMRbs7wEHpQ9kPx84ptrfJO7Qv8OnPyhkNPaeK3y8Q5TUaODdh4zGWwIiffJZjYr6WcPql24q1/EV/EQevHQAF7zomAaOPWPJ+/Q9AoAV9WC3n0qNErj+xPi9pFRzv/vFQm6W/JN0D4GRz9E05wSZUVxW2CFnMFj33e5N3XVv0KODc91XOYWfqk+R8IyOLeg8ggRa6mMbu4gnKVvZIOYvaXJGit69jt4PlTWrQsIh6zhy38
 ZRmmHcJJ
 rVDKhQw59wDmu9cZK5d88nEiT9uVeYgFrE9eeBC2VLY8TDS5ixMRZwK6LEc233jHiWql50890kztBZJMzaZliySZxOECv6wUCj7g9acD0hrAYA8NL5EAvcbJr+0D1oXYFfiRCEDv5MTyqJ+at8bju7g0uby2jIAcHmfTUCU/DZA7Mo4k1CWwDUS9cNSLVHGPnXldTJHnEEVH8r5K7P/Mn4imtGtV6vyyVsnSoPLKttLQQeS0tpK5rEMhQCklc3nRe+IiVfM9+WST92LFx1OLTHBLULYY5h0jVry/JprrBZFN5CIa3iemUturH2ewvaRTM5ubYEsBXihAiWzRQFoz1SvwaYrFplY9/JFyIQbT4Hd5TFylHe21VUQAhtpDNFfP1fn2Qm1GXrK8/J8fk7lQT+2USQphu7SkGT+cFTawRxq6XdQ3vq6Zq3SLY2I848GupNxegPjmwlY+AOo5X6r2X65ysLKHuhORXvdkeeLW8rqSrvtH25QqnAKbGXBKC5y8JDchOgZN7WgLiTwqcrH++GVCj6iWgCbBypaCLK7JyBbFPs6DAjofIVHC0Y4csxhsmFOnTEfkcY/p56VgD7dBpsORUOyQOQvnHd8iHB4X8a1EAOH6UfFKM92cgd1PrsY/dvmr98ga3zhHRd17PRi7WtRpkl33/lxx2/dF425AFkg+U8uBOgeLE4zNfcPhxjElQEBX3vJf6fBGe00+8Cm4fg4qutds3tIgINEfE8sz0/QMqiKNzmjs48YY8Ysj+NjZo6EKlUrknzK8pZCEoYbkOHUtVBUgxoNcQbGK1di7cP4ZXhzAW6iW1hkRotKUk2/wd7MtDZs1zJt2r9l/NrAZcokPOlcV6/ppUr0bBAVn0YRSsQR+pSDiBpyj7BxQwzfW/nbYGu/zstE6DzyzGyhX6SuLxp/PJHirKdJO0B/IMGiRfJBRDqKn3Y3lrUzP+JL4w4Yd6qrOP9TX4qmZiPl+XTsW9IMaw
 w9ZrpHXT
 BApfYkP859xhE3C+RcobPjxZaSMFh0c/sTineRZ+3/kIF3GQHbYkPiOSoXX5lzrLgzFwxfZ3oGortN5wc6JzVhkkvNSNQBp7BrTPOl32743/GFBuXrC19M7MX2TvaGJc+If/mtm3hIXHtF9q0KybkHEAeeFxAKob1JCLPEhs7Nsd4HmOHBL4kilL8MExOSPZ0vIWuja7M8qzncYJXM7Zu7xLtw76YSUMQrWQsDIxPPu4fPpPX1T5s0klBFqttoO0QfrmG4dDlv+b+tu15dxZJb8fc13RZOPCSvsPMPorWAnWzrwIcedkwB1ckVaybxli6WZjTdayT++j1RB2bpyW3xA1bApIyELm4CbAVOc/hOX/ha+R9Xy38N+tjR9sL5Ju7KzBWf6oIutOmX3x/e7JbxvAHPiF5asFVHrqJHOltDe/I6Bn6wgGKIomcFqejaYo7Vc8FEhEaOnbcaSkCNfF3PhFVBq3Mq7Ri71qm0/ocmgpg9S7IQi4G8hLBse9+g6CUG9K0LKdHq+zG6y86ojF0Zcl54Cuy123ynsdEvtyGRRqSUknlds5qyloyXnWsqoLfdWrNibcT7Kh8T9b5iF+DPH5Py507MeYMIhMcNW+pQDc+/ZVyJQvPTYsAYfx9baLzE8oeC/gsxLJOL48YxRnMkNBa4gPVU7WkqtoCxdYrTG7x4duirMrQUcJFK2TEsCjhCCFPFAKhcrgjgjeLJYD3V8ttqXXrTbsyfXo6roBuvhPVufn765AUsWtbCKareR+O4JN0NlXQ8UqJ/QzxTt6/NKMBkiC2BjtoyupsRDwDZU4mZ631PZdpuhNFEGAlPqNNOHG7T+FkckbBQ0fEANEq0fGO5i8v2S0ErS8y1ag9HJLgLM1jNigodXouUS+7PT44zCIsgreDl4wxavyOjuS4aiYU16tOEsb96K/jDkbDLnFfKCIQfwjK4/O+dInXqh0vSNorrgaMbLVMd9WYSdM9VpDBQGt4
 DZ7tmt33
 XfWFFRFkpbaSH98ypGVCBhzmwM3mjNq0RGPAuOLM6VANWj0IGUT+Ra1y16VyapvDXE2u2cQrZy9f146VMHOJzItxZvG+Sp5sQnR8/dc0dQR9W0TYcOxcu4X6T/VHK8CG+5x5yx2Ciq70Igh6/o71U+23uweotl9zL8axLQRegn6Kbpa7W5rLyvKPJzQzfSdXwGv5ZAoeIVj+76of1CeBe9PggQy3rRzhX7VKjN/ED3o+4J5pzebaXhFNJCDbVrGOYfcFxRNuDhED0wF0YJWCtVG/zXWrkCGLm6h/lZN3vr76nqkkmC07gOcF7Xm4HjbQavxWcgtk/NvSJX0GzGCJWZotthjQCtnEYUdGFc2CvgyroTFlb36v136du6qazt4OZ+6ehh8dCxYaI6FLAkwRcP+CGeVvMiLKTQD4NLzd3vs98W5O1TVviHuPE16q6RkPsTgW76c7Mzxa7DVWH+ZRYBx28YYGXPhTom4f9qjodBK+QUy1FGU4QZHUnvRls+eI7br8/3l1rIzgF5QaPgV/e3rb3kYCfHb7KX/475R1HuhXjYEizjwLKc0a47rbm3xzXuBYYcRstahD/kKLVV2zwbE24jXlfaw11hHaWm6V5dYFDhjbP1+ZQam/Vd1YzcOrUwrz2L/BOsMsh7jSe9Htk9+glC2mAIJk43MkSx7/IW5hPNgN0b+WjcOn49A19kWfyJBOCUzLxPZ7AZM8k8KXYpSNmjupM7hR4bKOU/+IbgudEHVkZPvInaCjbPrWjHxxN0r6VnIp2Jg5whWfRHgNNEzXDlQa3+gbbH6IlQYSaIQget8Yoa/x+Yj6pGb/mERzmNKi274cQ2LUVv4gVd/Y5KCr8R0EhlBWk0wgSW+cfp5OcEplAIRPq8w6mpHOxdfQtHr9O4NwgIrz2F+BET1Wpmy7JWt39YkOwlI8jDAapkar3V+aDImYwH1sbS3y0x158hcSJHKQU7T7cbSY/InEUpfkxIGeG
 CgpQ6LUV
 TT3Tb/2FgS9xiJxGQwv4L1d277UuPqSnRbcFBvjNB9eftNUcuBQZ7UMob0i58MZFzn3oIPum9XG+D+QzuZQUPh2mLroOv8oRBTkLhjFXh16tBKvnJp/Ic6XpTtnRkBR4OhZPkbEc7v+GWrbi1XV7kr36sRo80kZEN5VYFO96NrmBsFKlN0qN0sZ6p2yFfg8r5DP2gEgiMFG4AW9zYVh73oI2kM+weEFQ2NeoT8EDE+tOSJpHPjXLD7ofdnekgoYOX+5k+1jV02pYGg9xV5HaM0SADrVOxgUzAcHh9sblxOHA50UE94GK2tfisySzgPN66BakGoHUjmR4iRooeekg5SwCAf4M0E3cFfDNWFl4kknimKw4npdkc3XwGQN3msNWVh0u28Kd56Y2jxcuy1r60VJmSQaZfaVMhjcZyQRZW0TzCvR8DskYkmmL6TQ4SNvxcgU/Oyh+dY0g/P9GjiNrtm+aCjkwcLSzn3Zb+D9RrUBF6PyIxgAeDKtCVm4vaxoQV2J2ZbUau+lU//xt4wMvVV8YwiitNaKww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 19:12, Muhammad Usama Anjum wrote:
> Generic PTE range and remapping helpers now pass pointers to PTE table
> storage as hw_pte_t *. Update the Xen callbacks to match those interfaces.
> 
> Keep software PTE values as pte_t and continue to access them through the
> existing PTE helpers. This is required when Xen is built for an
> architecture that selects the distinct hw_pte_t wrapper.
> 
> Reviewed-by: Juergen Gross <jgross@suse.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

