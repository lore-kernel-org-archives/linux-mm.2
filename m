Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67C7C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58826B00A5; Tue, 22 Sep 2026 13:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2FA86B00A6; Tue, 22 Sep 2026 13:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46686B00A7; Tue, 22 Sep 2026 13:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80B26B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:14:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F765805A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:14:10 +0000 (UTC)
X-FDA: 85242046260.30.B799784
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69681A0007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:14:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SBP5DIfa;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HlCEe5txdwHOP3DmTQ8Rmfo0/eFpIIxpudVUesS35E=;
	b=YLhYXpZvWOn0g1caGu+1HZafJ5eWuVHb5ce0XEkk/5EDbTxxOZ9ZkJhHPRcvaK9fxnyrHB
	fFBFWWQe/Bqpudz0fs5RbeFTA74hJHuFFGTItngGbECm7XWbFtOdRqQmhQ05qxZLqSt//L
	PXIySIxSx7P2kazcPe5MW/PA4YXuSWY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SBP5DIfa;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097248;
	b=lGfE01xJ4UEuwXnLoMNPhWNJgnpD+skMSXElAk8T1OzzLmF8Fq0ydVmihHwEVlVIjZnOsL
	fOnMbtHmstIIdyXcAgmkXIFXxwvZWKtKgyJLXNREs8ceC5J03PGSAAbjbnIbKCqaOae3fl
	YmfU0Ig3XfpAEcSPDEq/lMuKDsyPDr8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E2F91576;
	Tue, 22 Sep 2026 10:14:04 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF53A3FA32;
	Tue, 22 Sep 2026 10:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097247; bh=ycUddICsfxEifMnQljPG5LJ+QAfshpGj42pAhJYJWAs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SBP5DIfa3nHM7wg1pyznXr/QOoBKyjohtWTUL8njVjJ2HZJ7Dx+/2lyN5lNkmMRzt
	 MkKJj6bY+fLt8c5gDKfHKPh91F5Et1R0ROJrwOWzqHfSea49QFldK5bBAeUeM9p2Ca
	 sZJWLtBML/JGGl2eO59i8Nq/hvCyVDsIRYBYPmlc=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:33 +0100
Subject: [PATCH v3 5/9] mm: convert PTE table entry to pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-5-5670b8cb9059@arm.com>
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
X-Stat-Signature: antjyyibshnebn71utc3nnnw7r7xeizo
X-Rspamd-Queue-Id: 69681A0007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790097248-246970
X-HE-Meta: U2FsdGVkX19f3LJbIqbjuJr3ReQO5DOqNkWJAP5xAKj4YY5PO276Ki2eQpZi2/xFMGl0r77Gadr5q2aHQs8IFR+DPRfk3PEQipE72T0mdfR8l5bmvQHcpbcijz6q73+gD8rrCQyQd1kD3FXFTyrdVyPY9j8hj42FIcwRS6xOAZT1WyA4RbU9NOPzChmUQijNnGP+2vU7AC5To46nEyU8l3o7KauRGuL7M1ItuVD0JtDyWCDvnr6trIs9O+u5yZy7Xhkuxuujf+3rZhf08lAtwkIlIHPU/Z+VvsIXHtZ0C9jEnPJJh6+4kHuHJMwyDG9h401XTyMKz+zdczSYVocPKPA3IXQXFgOBeIy84kIEjjoJRwvP9Eu1vlRzsa5QAyxmwBqM6zqcIkGEdKgOl+YM89ppyarYnsoxtrPgMtzFkhfLd/sTyh1hbSRM4VwOOZqP7gpfL7GqeHRnZEzyc61ErtbBGIPTEkHODI60iqKdDFEFZEle8gkq2W9LLH3k3eOyhnWuZZk4k5k5Td+lvRMGD9kvvcVbZnRAuFOAqUQ/If1GNUhsIrvmF0DaGZg2UtGsnwNk0w7SJIG5YAifQAjDiTTcy24TdvTPJiV7x0vc6mIDKsz+R8pEzeilUUqYEnj9+xXpbz1b4qY9BJRELFjEPBEheVSDe1EmyCdSz62FItjnOvJD9grnymdmgZk9+X1S6Ed03E2o2TIEd683v40/c8wMCUvHyyNw22KqHgQA81T8NSNxZKjT7mqd4AVkUPgm/IdVePH93Tt2GjXCgQiI3m0v1bvzmipQNmo2bqkzm8huZ1BGRWdc9b2elKhjs2JU2cUti112ygbPq6bth4tTRuxMPchBexsPZblZIT2NgTJxXJyb6WJUkoM8X7HpvTHpm6cAuPxgQfkwugo4+2Pgmfw2OYOpvWbOgdqtPgRUdKSPHqykkRKmwweONXNfmuBz32wGvMAEL/R07kDBf0r
 C58hKFQT
 SzRt4ByDhg+yuETOfRxweNJLDa7l+kqO0M8tOZUqPYx7qaIUBR8bc7sd6+tafPgtrI1hQdxz80DE1aa77+IhxcSqfZuSAYF177zdDLB2dy0cJEi3es3OCmPOaXWa+v2419sUC+8Tos8EZviPenXUQXhdLpbT48eetyDy2aPj8Ej2ms0U87Oy5CWpqmpgraoTOiyP8C3ozxTBn673nqDvAXhqcfwu10BmKZiJ5yOEx++qAuqmm5CoJvkQSptSycJZIk3+q2VIsxXDG4ZU3BzRXtYBKwZ8s+baX/bmFrbSsc2IJ3F6ePnT3vK6xwSdwU5XGwCDMDv/VVqH/7fZWcAZnOgOi9U0HvPk2vpcVa8Bz77mzuQr0w79CzB3axf6Cq4b5NgRwTN04HFobYodqNIJl523ITwhsdjTA31DWwgY7VAQ9Y35CLw0INCtmTqOY9oXeTaOZ5a0Pm4S02EhsRbQDWJxSu5LuYRksBXY7sn5Bzi/g34PQi6iRG03HjIiI6aTdc8A6z6rdgBwN5/ZT91613d7fe8Lj6x6/W6p95Pxm20B37Ai2HXins5E7RFC8fo6SzFrPZCYGettyc1BtnLv3YrKGt4iDkfDhS9hd0rc33rDeLs5p6IcGlSaiVB4z91TggdIxbYi1u6k4D3vdfQ+Tz76tcHcVQ9YEzX9amNLqPgQBrG4wWRoiQxZ6DQ0efepQA7SvuKNNNYIt3bCG9jCvJPnCnDBgAwpIV3iuNsJny18sI98rk6iCggtolc7+FGSK1jTsuwkNLPNNWvj/K4qa8+wN6icLxVS3Fcmtwb8ZeJCuhZPJwn0QZj4sRZ3E+xWpzyDWTCCfc4QConApwSZipYQM5vZn8sIAukZP83XkuoRJiXm79XNRW5328j3QD8Q1/IBjwUBtK1n3z5M+LXU32/FcZes+BURQ0X3YIYcf2c/BqAcKQOzeWhv6MuC9KdDGPjQ5wphlbjJuyjJvZr57vOvRmysR
 ucr2xFU4
 YIWF54Ls6Pv+3D+NIHOpvok0FNyMQgcuxeHclzt0d6w3SQ4sixqA/i+1ZjGkcoIG7GVBoRPG5L1NdO3RypX6uvh1EURHppyC067Hm8A0OVHrJoLOWlapyl4bNtQJcleEr2rmaRE9+68Q/xf13ys3wOlIl3ZHWDpwemKbZPDOIhJmyhuAhe+bD6CVTdHbsrtbapmW1NcgASuyNppmwVG4FAyJ1U3MRoFfPgBdaEaXQCYdm9t7exeyEMb5FJDuVFmOQYUML93UrxAewxcsclaglF9TfYG8L82JGXluS8fMq1GWIz4BKawWuJy/ENG4hqC33kCWKZzo/jYaJT2jIEbPGq+rbWkEtDbKIxcweFSkpZe2bJllmlqHy0Xp0uB65iUYbr4z3ss8SbvW3vxOMECKoJAPejaljF/v7eeKPnhwwB8WWLL+rmToJ3L+G6cPQpUlQmSjbqluKkBTnplxlKmPXjCoYrSHeonDl3JIT5GQzlbd2ROodiseBBD/8mQ69sFGYhHurp38pCrD4kjw2u+oGIgC83mXUPnS2p1iDdO0mmwCZvBVmZ8WWj4c1ICrEN044VYchWUlU9iLcgoDA6LXY2CLzc7dhf/iw45H7NlS7fySlNkVgbvXbY7K8OUDLF9iGgHoy7udvmtjgjhFmVKSc/r5RGcJAg9V46kRle7DOs2Xw7hOivTO8w0fDt6vy42EyR/+u07penEoTwbkuR72CQIo4E57JPwWXOSUyTUQpcCaC2p5K63mIMcY+Gxvh19INfzlM45ClN3TKOzy9zQGZi5yoLh698FoBhZrI/BI8ZWZpokVFSiQ2tiIAl8UyKXO8iGF94jfW3BZb5VixZAzfZRiSBY54zdVNj8Wd9dbs9saqRH7eGxV7oYnJj5VSUooQm8H3CrIe+JYSdUYnW6N3CbyhIxZwZ7lFoOKWcT5NNnP6eQNB3wkHIxWzLAajbdvFI8T7I33skxC3wIJDAJb5kOAqWaLj
 2ZtOcmcD
 YV5Gbm2cKX81jtEm1F76rBd5Q1BN5rbDdozjhZ0dfjMo39ORR1+6gn808X/G4cFQi/6h0KqTnHXFRwuihVMPFog0cy9hnpmTaUWQxPI0e6AFjkwoFbG/poYE3hxu57MrCO2DQAEg55pONGtoLsBwpARS2fDJjT8l3AosYzM+d52mv6iqMN8zV7cA3faT1MVUQFugusPUy8llZxSjJYKkNfnfSyoT6etz1RM/oRv5BoSaBp/i7r1tpnU5vPdhp/zWYKK9arniVdS8T0uCKTDrFkK4vN6ul8Z/4I//jmpCGU91B7NAEA5nB7mJdocwwmrYwLgfJD30aH+w+NcHO+OlXC26z+9i0cBjEUP3Oo/o1wjEGsh7Q7yaN1xEQHjQEetds61fnFIqk24mCiDEDoGDMyznNyDZJl3Yod22DJtYxBqR0E1GRrOJO0HAhBNrliuLGfFa5AnPKoheBrw6aPZiRIIceoSoFjzDBzXJPK3PzZV/Q8LB+MwfEz5qv5pJeVcUh2I9arSyZVxVxrS8d/+nSWd85FcS+qsg67AfDCDc4GWwj4FyiGC0eKDYiMsOpourgrso4EuS74vglcFnfLxjbxnnSx+EQ2hI60qZ+UGqoiNzLCKg1DBuWJ8LaSC2rf/g+lsS8ZFfUK1uX+ICfK36GMWawRGRNKWubH7i/wVU7v+7Lj80vb3INma3nxlCMTWcgJpMa6xxBiNYU0d7685k5BtY2ebTI+0eIUe0QOEu1fvq+5GXNaAC57iVoSUOAtXHoZToqlGNCIYt8pPXjN8/lTdud1DUS8nO/yGsBMveHO6zCINApCNTgahpOZ94AC/qRzkFg/hwe+ZbhLg4EZCzO9cYKabBQ6snDa7gbNTjlp8cT1rdN7ORjHFBfV2zBm6BrFa4dZVoUBQOJO0Rqn/vN2QZIv5pz9b7Ogx6WarjBUDt+gHVWkllIjzN8lbxKkgzGfxf3nbWuN0t7GDKacoq/PZ03/zyu
 2DvjX++S
 gfOG77dHLvbH6dOUzNl4/KR3z/IQXYskb7fnxhwMGVZziZWnXKK1EELR53qKF6Ap4EA1OXtc4d28JyyQfLUJ5HYV2sG4U38N9ZL3N5Mpw8xOGreCt5qq4NeVN3CE3QQmrBmXGg5E86s+oYXBl4uwLK42ajHPcqX5P6ifDEwwzafJTU0u+6VKQHtFY9d5A2BNqFwikNcISa50qtUeD82SmS1WZhfF2+sCmEOiTs4fCLXZ/Rv7cbx3M+FHLgEUFuGDB/Lyuj23m/dmqbeHpy80DltAxxK+m3ElSJbcDp2ayH/D1ngRqGZBz6Nl6N+NK40y0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The non-MMU stub receives hw_pte_t but returns a software PTE value. It
has no attached PTE that requires ptep_get(), so convert only the stored
entry through __pte_from_hw().

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Explain why the NOMMU stub does not use ptep_get().
- Use software PTE value terminology.
---
 include/linux/hugetlb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0d2101facaa50..637fc863d3687 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1278,7 +1278,8 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 #ifdef CONFIG_MMU
 	return ptep_get(ptep);
 #else
-	return *ptep;
+	/* No attached PTE that requires ptep_get(). */
+	return __pte_from_hw(*ptep);
 #endif
 }
 

-- 
2.47.3


