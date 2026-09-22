Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6550C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36D56B00AA; Tue, 22 Sep 2026 13:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E376B00AB; Tue, 22 Sep 2026 13:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6856B00AC; Tue, 22 Sep 2026 13:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9786B00AA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:14:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2687480599
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:14:51 +0000 (UTC)
X-FDA: 85242047982.17.EAC62CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79B0C1A000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:14:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q1VpCxlu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790097289;
	b=CmaKwo5t1Z7v1NwC8FBHzijRsohR3Kx6Fe7x825h686nk4Vdz/Q4INV+B4mPgsOKZUpFnV
	khM3HvDPs6ZX9PlEFXVMdqRbn0pbdb02ezhRBqyEniW+bQ61RipJozwMmT7r7nr3xQeM4U
	pGLXN9J7qNChAjFWnsgMjYTrZIVNM1w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q1VpCxlu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790097289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+v81bgvrxD9mLaVAiqT/ZBgFM0LNmDN9G8eYWFTv35U=;
	b=yY9AM/u+VAwp3t8p+2oDoq8Rh0xv2YmFJrVpAybrZuMjBmiJCzMLUrDwC5VMJepo6oTHet
	5DC1NCWsOqIQiQg51fjBp1d4hd2uQ5rnuQpmBDb37zzLmuJsu6yb77Zlyh+yrlmOPmkzPl
	JgA1NXqwKPtuXGj53r6HM7WEOhfQDR4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33B321576;
	Tue, 22 Sep 2026 10:14:45 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E50C3F86C;
	Tue, 22 Sep 2026 10:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790097288; bh=FzOwmvXA/ZsaFfwRIrSgTUueXbfZi9w1ND4q544oILg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q1VpCxluEzmguxI26Ee7wNqjVLyFcXsyK9/dTWuDEaV5LI432tzfpNULGi1fic9rT
	 Bmjsh3ZnFfh+9S7gpmlxZgPGzuuQpx+nqgYUgF5ZWR3Ua8oDKnB0+1kZHIWXY9gb9N
	 2rdmHfnaacSFRGJxxoea+piZgL6JIpAkwsMHQgwc=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:12:36 +0100
Subject: [PATCH v3 8/9] drm/i915: use hw_pte_t for PTE range callbacks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0-v3-8-5670b8cb9059@arm.com>
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
X-Rspamd-Server: rspam06
X-Stat-Signature: ekckrdb5g5fi6n15asyget859rucyx5q
X-Rspam-User: 
X-Rspamd-Queue-Id: 79B0C1A000B
X-HE-Tag: 1790097289-571830
X-HE-Meta: U2FsdGVkX19LmM2y+B00Vc/wJCO0zN1EiRRrSiJ/uAnLwS8b2rLlI5CbAfZ/I1/4nvxiSDVtDdnSDP9I98/WPt3rS2hVQ/IMbgpIkGmpv6OwxRyiW6S/YDYSfBPoCr/fe+I2SW8c1YVpEeA/80tXSbComjMJKizBDvm5xUGy+dI5ItpncLcag7IQ5XBS0iV19MaWtQ5VJ5XF9nZgDXpqcGRquspCLc+RkHQTFFAlKM2IJRC+Ff6yrlztnpiJ0oryi6SLlxosfC92WNJVx3kiD3nwtvfC4zmV5r40IoATWLJZnVhaWrN0BdAzRokTfTGlVUTQAFcVpTfEj20atKC/R3TtVYGoBanvWXNzF5Ube5WAZ4pg2ToMZu4E2K9DU4U14WTAxV7o0+1tJHBn1IIktMpGQEiOzSrPCr8qK5cEQpl+71fbLHGWf0Kk3QoZkiQ9xC+zhIxPqquMBZ/w9v4jLgugIlo/fbAdYnx3il1kyvpYTnGzPSoR0D7EE24mdSV5gKPj97XYS6JExaI+xaJIln3tZpnL1vMYkqqaFKiinDpI8p6/rSjGc5xLCJC6cQS85S68ilowD4MIS8io6wr35dNx+2wegMLc4RF71E9+njLimU4YQRV6AwUNjZIYDkPNUP4SotzdYz0JKvFEECjPZbweJK/Iezgb38H2IEPZGdlkt9uLCxg1Fm0W1VTKi+4ZLTTItlhLCpTwnovGe38u1HSsKmkuIROM0sRbOj2DMtUqzo1Vc57nevYIJpQ3pF8wcZ81gJA+ZHPrwduw/g/o7aYc910B8UiR6CsHknTjuRJd73sHYrkh2Ja864q3lagwS4ZesCs+rPKvwCwUKrFxZVY9W1AUjC+TDPXG0/fFdDKVgiz70y0t21bebIo+hQs5ZieQbG6RFlU0QxCgEg9xlsVBq0wmlov8aVLR/oM2xgf+JLcfv3aLrwiYynBIfB+uZFkapDs4+/cNIGXFack
 MXRTZh3F
 evlnq0Nq/q19spIibChoI3UuyJv0uuewFRUL4bxxeFne+9aSLh7xCzHMQPAVltZInTqNR9gg2SerKl4/YsIhOV4ReadNPRWV8my1r7uTktrZ/OdY/ab3gqZSgugEhYRimJQAfuWeyEWdynx/XYIUU1qGNYPKWg4Gq749MBq7NzCY0QhfstjNfeqGJGjLZI5vlOATYTxmhM8pfh/zs4UA6X5W/eVMkX0KZHorRX0tfMV2LLe07GSASM3/BzakB9n7+iZYvJPihzoZWVAse+v2bRU0mxtb09LyUgVeikl5pxjco+aE5pvrSAWdmXeDKwZGhWF9754ckwxRmEvdDbdyB9wWKgf9djjKmln94fxfEc8foL68VSFd95cNhB6kyv+B1owZeux6SMcHWoXhoovZDYwleXUx4uO1QT3oaLmF/WgfZjkzsB3msUt1RITAjsc9ybAQMuv1NRfZHh7APFb5LLUUmIeBmFRyDaDOoMSt51NI5bZ/JWoRCqzeU8FilweyJh1KakXyjTYVEn0LXlR3d/bfJSjCnrFi9favVKI/4PhnUU2Y/5IpHkEWJfyA29IBy/B2Jg/WsJsC7OYZORNafqh7VYfl9+JawVtx1b6zTOISVkRJ9/Jkau/8wbvSDo87atPRFNgBw3OomwE+xtAJ+8B4J7AAtAfeg1+BfxaLn3moNS6FGT38l+aN9wbIN8/8AdfxMrkbKbC6a6ywQC/4np1VW0AgVrhPpizRAhsm0Q+Q1PR7uQe2Ie1kek0zn6l1q40Sx19LNYh0p9pYUOsuYEOXxKau6NB/OzNaTikEjPAjR8uPJ1gYUc9UZLtwX1GQVntCr5049jE+xwp+0hPlyauRxFc+9xoGWRkjPnHmgf/c/0xZCd8q2P/01Ou41TWaAgH5PGHnC43nnJrrHtVPSiBVlR4i/r16crTCRWJMViHuoB9p4L94rqStow/5VC+WhFYR3gdio/2VEEEsFfqQqXYUOxj3e
 CCcm981u
 bN/cTvZ65TqNqLcFCNEA2BImhNTUFBYjRw+sKiAMidcE1PUGxeQYEhrLF+EkUEe26VV2uopURaZgtGCaAGZT9zbH09WmFaov8MdvVOqr2khVnP/BEmTYHoPDxOm/r+pYyvd3zQ9EFuPj8NqstylYdmDCvhG1usI7TC3KO3SMKG25uOKHERfR3jTNq8j/lGH6bQPGPJ7w9Hl0AU39oLQrMHhDReIUVfiKfMcKlTdyu8YddgviiuFkDnYMeeMYTzw5ygkP5UNvSUm+w7DxTYCz8D77zEuON60s/cA83wSykGQIePMWLFTQa/WKR/q8jqUU7+FG0ELPUe3OQJ4FOYqgRC41efnCkktahSBNRSPkGo4LgdiqzmN0Xy49tjJjLoCIfbMWdvYPY0B11xg1d76WzEKWLX0jSNnxr/t2I48YjqpmMfIEM5kA6paiIPD2YnfXk6URhd/kEEDMxqAAGJK0GLL43T23ijHd7SxZZzHxOKms24tIvPVecsccoZU23OU6luKWhJRJEKgz4StipeEonJ3jz0920uq5m3dOinFMJluJnNcMGCRkG4GriSMX57d1eWEyIUtDN4+ztmNKVivajvr0kidcCz/HI18zurNT0Ds8RU3k1yjvf/nBs3UM7dJmGsOa2G0F0mYEN4XZugUPDn2AMRm8zsOvTQDipfb35IcX6G0brsHOpL9IbrxxpXv3NCM3v+FvqcxKdwSIBgryh1KSte0CuY6HvgVKRogCZeCzZLEobW23QNt4qPn2YSS1PkjqB1f59XVqa4e3OKiqo19emAzBXi2XE6BwRLrE8gF5uNrLkmO9kg7YcMIyBFXav6EdQiGE9sTQ9eIl9Ndrg28nYXde4VXiDPoJqv8dxkw7xQWARVHzUbd5ELb9gHzl552a8aU40Pbg5deHoI7atQOuxc1ygQ6+0KvoacHGdhbcj1To/Vof3vAypWL+rb2OQECa7UcXwfbMOLOb6Exm+5aoXzECV
 KPj5F10z
 3foCTRAxXfyJqC5MsTxDZbNC/NUzi9yzJ+5vMG4FEnRRosP3kb90lZ7Bl8tIrdGRtaIpOMiWQ+LZ72D99qsn0v23PdKcWBx6T1ZjCdQCUmEv7Clgd+0C04sXexUAizW0652TpnMxjjZISXv+i7TnJGPubSDY12RRFDdiEZoEmqbCEyRgJj+fxW+HGMo0HgAydAoRnfugTxlAK+0plv2jHmRB2jGYMFFrf1YqM1ezsQEWWmH5tqEOcnBWj0Ra4CrelzMDzEJ2HENcgzYAL4QuyN68QuBY8slF80Tmc0UHCpY/Eru7sh8AsXmsYB6xUIvl3Ho2j7WnlQ7sNDvE0l/mI+EbGim4EjvkJ855rZJEmta13J6QZ331Yac/TWTQ3DAj7A4meg/5NX3tdkDYVbsJRcoalpNPvPOGEVh2Hfb1/NHkGpigxwPnww2d7qVwhEcguG5iGGc6fuj8wHra/1Pe3belSGK+a9890bFfctMaRqkgS4JdBSk8tWgsbJFLR4bLIol2C0wobxC9EkChe+cNwBf6ou5M+wD/7SPDEuK6Hx5a+P3daQXroHiv+k4Ri9vsd9JAxcFVVNyDdb/1vStUaF0rKVYP8E+aCJ2mRV7WRrGBgdR6el2tHKjiOBDs+scvudVNTB4JfguI+Hc5DjHpDsn0Sw2QIummTbBh1+K6ZbKBrnvXJM4UvthAEO13wjE4WFxDojsEfkn3ojhuTQbIv8BHgh5JsElEPszpUasx/PfEDo1a5c5nQxqOAHBf3Szh9wfmOKtmU784poXTl0SDRuckBc4lXWYbgHHHLqCIs4wYV7ybi8P/QaXyu+57lqzGhWdMKfNtndQQRejSsxVz4a+cgZ8QNojaWdA34gj+yWUYrkP35WysUj02VrLKSJHvi63EHz2AeL6kS1WAl1phAp+6aBZIqw84FL+l/m8A74g5ojyUIqDq7yYuq6cko+x8YzQRfQVOcFFVf+aM7uxzAGcx+MUp6
 4KwN9kGs
 RxYCi232nhvxW6TzLNbq1ojFLtA40d5Y3ftgFSOhoHSEj1h/ReYdaRlCQZrZ9iGVwdWD8PNaw6LliKk7MQKgFyveDP02A3QqZGhXKL6cGsdxFSG1DNFlo3t4Xsmo0w7F+cPkn1opLGVYtnhNsW6G2AKohTlj+2YZG+Tq/Ou727wkZ3qeuxW84mAbyb5dXuLGnPqUEPoqu0rXIicCT3IMyCAWXdoGcVWzGYiWpPik5JlVKU7Hy02x7n5v9As9YbyUkoWrCu/Ms3291jXD7NdTRFs3qx0on7qiWTJoGzMsq6f8NIojC0NZCwNbo4KtWcKlM6HQSoluWDa8HDLWhrnGcqUi8onQZ7QU8SyzRVnu7+ZPqpaaAHIkWq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_to_page_range() now passes PTE table storage to its callback as
hw_pte_t *. Update the i915 remap and selftest callbacks to match the new
type.

Continue to use ptep_get() for software PTE values and set_pte_at() for
updates.
The type remains an alias of pte_t on x86 until that architecture opts in.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Use software PTE value terminology.

Changes since RFC v1:
- Clarify the effect on architectures that have not opted in.
---
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c | 4 ++--
 drivers/gpu/drm/i915/i915_mm.c                     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
index d01acfb7d93d0..056faf4a3618b 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -1690,7 +1690,7 @@ static int igt_mmap_gpu(void *arg)
 	return 0;
 }
 
-static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
+static int check_present_pte(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	pte_t ptent = ptep_get(pte);
 
@@ -1703,7 +1703,7 @@ static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
 	return 0;
 }
 
-static int check_absent_pte(pte_t *pte, unsigned long addr, void *data)
+static int check_absent_pte(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	pte_t ptent = ptep_get(pte);
 
diff --git a/drivers/gpu/drm/i915/i915_mm.c b/drivers/gpu/drm/i915/i915_mm.c
index fd89e7c7d8d6f..aab88e8edf946 100644
--- a/drivers/gpu/drm/i915/i915_mm.c
+++ b/drivers/gpu/drm/i915/i915_mm.c
@@ -48,7 +48,7 @@ static inline unsigned long sgt_pfn(const struct remap_pfn *r)
 		return r->sgt.pfn + (r->sgt.curr >> PAGE_SHIFT);
 }
 
-static int remap_sg(pte_t *pte, unsigned long addr, void *data)
+static int remap_sg(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct remap_pfn *r = data;
 
@@ -70,7 +70,7 @@ static int remap_sg(pte_t *pte, unsigned long addr, void *data)
 #define EXPECTED_FLAGS (VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
 
 #if IS_ENABLED(CONFIG_X86)
-static int remap_pfn(pte_t *pte, unsigned long addr, void *data)
+static int remap_pfn(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct remap_pfn *r = data;
 

-- 
2.47.3


