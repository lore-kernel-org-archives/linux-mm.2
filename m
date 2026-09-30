Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653ACCA5FAB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 04:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373166B0088; Wed, 30 Sep 2026 00:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324146B008A; Wed, 30 Sep 2026 00:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214326B008C; Wed, 30 Sep 2026 00:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 007646B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 00:21:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74FD41C35B3
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:21:02 +0000 (UTC)
X-FDA: 85269128364.15.C35C17C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67135A0009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:21:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iiXj3sGk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790742060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2RPfhCjNlALyua9QpRHDl+ZkSpamWE69sPFTq6H6Ig=;
	b=ljVG3QBPZhcjcB871Yh1s68aY2rZvojtZBLZdZIHgz5V0gofb3e8FDd58hq7pQ60/WqVgI
	gMY31NsDF64iAfMV6/eo0uplLzuN+kG4z+1GVWNDi2c9cpe9m7VraNCyRPXfbTtCz6vUcT
	6DKZLP63recYenwP1jjDtxAa0OZWNdA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iiXj3sGk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790742060;
	b=IM9FCQTD5yfQakMh/ga1/uA8cH3/7LLxvBpeU46CRBvgAN9JE9QQoL0b+UOZNdH7iTUukt
	HO5C6B//3ponhWxfPUpuV+9L0n7fjzpXG5tav8CgXDGF9zLBZFHNO9h/fx2di1pLCeXrwx
	BrATvsvj34n4oDxsC7rxANhHwkhHrbo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8D941516;
	Tue, 29 Sep 2026 21:20:55 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D13163F85F;
	Tue, 29 Sep 2026 21:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790742059; bh=UxlHUYv22rgyq7ZVxruY0QE2y0GtfTw2R9yOES+jmXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iiXj3sGkrhMAurjVuvisN1wyrF4L5DGjA9KvALcFVE4OmoxhVrf+/REwA/xaRN5Yk
	 5me6wieFhJOwAoyLIoLbXtSHLf2oRy3WVoldA0+46lHll1bRbjR+OrUDdKJOwbDcUR
	 LpuyMIJJwxFQf9usQsgGIu9RHfEsZZyZAGi0LfSg=
Date: Wed, 30 Sep 2026 09:50:55 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, damon@lists.linux.dev, kasan-dev@googlegroups.com, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 2/9] mm: rename pointers to software PTE values as
 ptentp
Message-ID: <ch63uaxr36anablz2sra57huiud2gxjtpmilwk4je2qkm5hb7j@eiun5t4erg2l>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-2-5670b8cb9059@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-pte0-v3-2-5670b8cb9059@arm.com>
X-Rspam-User: 
X-Stat-Signature: rxdbn334ujq9runcnedi3pz9yujwht5p
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67135A0009
X-HE-Tag: 1790742060-469380
X-HE-Meta: U2FsdGVkX18IfeGpOHztxWo6lNN3Sm3AxtFIXLakr89Z6JpGI82TDRCVTy2vciLsivTOPbrSlRkNAUgpiVCbIJzOea04klxeSuZV0aTcuXZfqPKWMI/gB7pHOctvwhVxH0WZONlqAiyOdpttAHNMrHPeLX2MQXukHfz7N/vks2OemJktUlyOQVUEjYXm9A/JD5kE66alr/8sNHiQ/yDpMww0SkOYXGz7Is7fnh2fYX3DTmKkGY781R1Ekr+LoVBrbcIdSTgH4ja7p35hTfPL7JwwqEiLuqKvLwBXpjZynZRSiedIS4+1qeLUkGlvL8QSyOdRvYYl0TDa1xmHa0l1lYnZBH4MIkY4yrF3YiaAcM6Ol4s/4e3nCyzmtc1PcJjuaVhRx3aroQHUjbNEqjINuSa1gw1xNFR0BfJ1s5UM9VsddS93HlWinD7I7rFrXF48DuuJm+HFw4GMAW7PRK0fI+E2s1dMaukHSUVLJlS6hzaoi2DPb2b9CAZe7u8C5b+OHaT9mNpRPRzaUW4fedWjXNkg1fYGTwyBHw1r/LuaJl9PpiiuQ7Zg7Xm+uEyHaD+XXjd4idDrGmr2JzH+qC8qYOsFWYc4LKt5tAfCdsVFXHPPeRuMwNBbzrnhmKmDZ9F6ECtyfhkzpH6DwEoYuhnoqUjN4ICI092gFpBE9J1ajrwSCqq83XgnDvIfC1388FZkR4090LDEXfTTXP1SRjqvO8j1LijuxNkDvg6r8YPFanxJCugiIod5iGSUENrZYqLV27iEtYueYYcRUgc+QHifG/v2wqcc1TtZ28JPt/X/HCY22I7xiOJE3e4Mhz0635xVPfEL3cq45CPgt3sBfkeq63EwL+kSfZWFdEl18Z0ApOg4Fp31n3+eOiJPSETgHZ7id6BloS08iSXCVIRaPzNgdwAlnPpoZQ3g1t0gkoWyXVCEd3vMtGvEcNOWiDXVBU2EvXEFe/ZL6jwzerVtetZ
 Gzupz/PW
 Hy/Tk5X1YRpF5qHp8OGcbDZPDesTLBSXXHS1YY7Ko18rNSCW2xBe3BWtzitDTHPJyJK9e1xmgZ+kQHTfwdEK4276PfNHvn/TNHcWa8OkN1TFBrgJJH+v6BtME56s5YDgGpdaQHcJEiG0hExz8xRVLtm8vFKbv+1+vGKaDnNDMKpY7F3e8UeqbcDISCnYBSCFe4LEYb9fPhKxqt8K5PSJF/faYZIez+Q6IgABcMQxuhGNckBgngfKdfSeIFUnBfiPmX3FvtQukBNnr8LI2gKgDheth0qJnWnKzdIqHg6nQsDqoyhUgzYKSYxSKT2uLaR8zrIWAk8dlQdhQxf5emMixbhnOBA2YgXw7N5WA2p6IGLTovOIvMK4RGF5Jniiy7/NMbmY2YsVUy9kEEpbcPFeNSvbNIlpyojxbQLphA3wAlyJNcxQW4CMkZJ6u2yXLtW/eDkZ9UKRCEZnRaERdtSZiF5a+T1PK0OGCtAFKMMkHO+w7jHllljK2KRS0ONXAoqDyivMD5iZlWiIEGpZp5PoEY5gqekHy9hpY30BvlIXdxJg37RyaZtD7DPDop3poY4T5wY2nHUxujV/HL1d+GiKm9YYRxj0iHTT3ddNnWQ/xyGUxYKvBPuBpv6Ja56zJc6Fu6f/P3VzAsSRWdVUOJ1DiqIBya/tU9BXEGca91wmNnB3c4hx2iVuQDXy6lOfO8OZsLxamzLNEzrH+iDzd62QQaBUKqnz4hk5043zizs255lwPkg6XDAyoUg+Qz0JCBnYLGW4BLxwsuWVEp/a8FSFDQWpU+0rpPYnowpWEOQrp7a2BrMfzVeXMFd1Wq61c6fLVdYS+G6Jpgi6ctF0lefonBN4QibBIAFkiob1lceEeYaXj+Jn2Z5xY+s4/mQRQt1gwKp5EOxMKv491M8JK55NUAU8+p5pbrEnozXGMs6HX4GH+PCGlU0Ib0TcL27mqBFjzSOc9jk99HSeKx8RPusw39E/O1xjL
 Bm8Id2BW
 1JNQHwkyaBCTZQvJhEI5cIVEuKBxwK+bcF3jYzzL6VJhuglt1Xya9Ayv9Sts7CTbjU6jxbpUz7mLOt6P2+iKuXqMYopdvHbSC0HTOa0XDYBd7QbrYzJeK696WN/4A3kOqy8kubXDrXJMCSWAt9ILjaVUqHHd0pbjJQW8ba0dODp7wReEqS3EWy1QewFd93oML/y/EGJHx8m0jwPtscDZ/qKSzsYrBkwA10UXtmuZqa9HQbXXYzXmRQqa5bgyY5/rk30wLyNgv+qHd6bOTXSA7uPuIdz1/3jHF7uCkZ3jKy048TydUVJ5oOS3LMU0fUZZG3mIUuceQBdHQsBT1sO5TqJ89tD6gTo5ee2Hl9bMaajFO8jVUrS0l8M9KN+A5iCEG6GyLqMwIgf8B8hwDgZPXU9Xsz7tly+MKC2DkbXuhnYeK9G3X2dqBVF5wuFKq1xRgV7JPugC24KBxHkb3Vrb3EvzcQL9s6eyCkM1IXXf9Y2sLx5Tfor7A9aSdRObJ9m5RBIgVcTsew2dbMkCc85aYrEjR71QsOgpfskDGl3dMyZzfzaVv40JpGkITc8XLVo0vIe++qGrvRf0z0F5vAb57qlPOOXFvrOfVmNYQzH0a5JDmdqWE+80k+Lbmkbn/dqdLbigr1Sx0/AFBGYwKadmgDgzNanNoZ9Pfb1V0IgBzBKMGluwg93+NHSDWwCudcPgjTOHWaFqghx6CipvCmO3y0LB/eMRDPHimoVUN2gY1nHEyPb9ODupGn3cKZcNJVU+v+lgnxzEpWglQk6rFgKImhWCFQqDt3Gk4JiA5XaP43DOUtzF/e6l+4W/wZP5sYOzUL9fRAJunxN0lfGCCtgZ7zlV64LpORjTyhbnmGiTusSvMfEGe/zosBiJDAGWbgr/tjmxhWJTYEJXjG+KSnpMK3WYUKuN/tFGH1fqd9TG4V4ILg8pLc/xyyVYw8s+HCZ1F0DD8iUrf0cCKzTn0sEIxrwqCi6aP
 Z6JA6ltV
 BlZ1CoZp7Ups/cec7v+BHlxy2Lloy+ZpUp2AKKvPLTjHN9f6x5fk1JQxjzM0OIKQMJeH3iZC0vnqtuq/LQrlaE7EmVaaRPlzbt2RrQTpFC2nG/4NOHkyup662aoS2NUyEE2PAX1wfknBqvYDAgtqfK5KkkiRODn10LM39hSvqk67lmt7phKP0vlmRHK/8Rw2bWSu1q5bYSE2wXr23xK4nTvdl2zyDkHB/zqsZvlfj6gC4Y7p+eplsQl+IyKbx2HLOxGlpJmVkEZU3oMyGw9icHGcDKJKkUe3UrI86PEEQk4A82Fxir8Vx6kFbR1FJGA7yFDR9QGGPB2U2Gw/oE+0nMcGi8lbeQv2eWMYM8EqNTz4sSRfWrY07mTESE/75DJmFChvjAV1r53rK5PDYEecUU4fh3gkYTyMDqg6xNrN09XMuFvGVKbC21lpOY28g8r04S4nETbu8fyVsZUARhkawGhWtnfwyrln12f2p84mIERrRWEB4sPMgsrppqEKvyhRBO94gNqBFLWNodn/hhQ/x23S+adTRA4TorQW6cR3pUukrnNzCZ1QbZyc+SgTjHpgkb6jaw1BMatthi42UkBX5J4WjiZY/VS4WCp6KZetyTMkepJv4Njbb9D9QCp9r4jMtwWjenxs++4TS+tWv3+ztdEiVexDDrlR+Rfl2NI+70BW9x1N+/Ag7DJf8+vPv9cvt3/XcV+zRX0462meNX3UA78VqfscXcAAmONOrA8Jwhl/VBYaOhneiMrgrpgdnWGnC5tZVcZLC2C6G2gcT/ZsZrauUG6+PY4jOVWqsF++6sklFmRwEWFQizC79aP+bJWWxwbTF9R202HMoHydHtOYg+Pv2v72x5JFIeTg7veN1B9C5kzxUzGHbr93/9+amdjq/pp0YP3nZets/cfAIE58lq7DMVr3Illcx7ESzh+jXXvtNhazL0iwEkboup+b6munswcDKCWwsd2cG2iyg0c11xykGWkei
 bDPDBhxO
 aNbv3jXrUaHs6WqoRg/FOADpwfptGAyxrEd5u8+rjcJSU8NkKeVzMy+EZVYo/sjAc8wvnkvRBSUGMdX5Rno30vndYj8qXw1ugsjcRx5tl5kFP6bZnhZLpyI7L3gQ2Ou5l9stFFDvbdunzQXke/bnzQ2A3jquEcXEmEACVDBmj9A2DpPtxD7Ul2W29gpvwwNmXnnj4wLaTmDIFHbfBrndgYZjY1HOLvK0CnLwYzX85Z5ao3ZJP7i+6wVoSaL8mkw0+RV7OL2fKaot3ETLqI8z0nRqL7WMBPPEBccUNFNkDQnMvk2nrcVlxD8FOqv3FEOzVkkqZrmYtxjZqmtNukcRDZYIDjS9QQXyEh+Gvy3UYOaAQjlK5Zsl/WWZ0ltPxqxsOgZU1lhcj8OpPpsIhd16ecyMog5ENCwIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 06:12:30PM +0100, Muhammad Usama Anjum wrote:
> Some interfaces use pte_t * for a software PTE value rather than for an
> entry stored in a PTE table. These pointers must remain pte_t * when
> pointers to PTE table storage are converted to hw_pte_t *.
> 
> Rename these parameters in the install_pte callback,
> write_protect_page(), and guard_install_set_pte() to ptentp. The later
> Coccinelle conversion skips pointers named ptentp, allowing it to convert
> the remaining PTE table pointers without changing these interfaces.
> 
> Some functions already use ptentp for such pointers, including:
> - madvise_folio_pte_batch()
> - folio_pte_batch_flags()
> No need to rename them.
> 
> This patch only renames parameters and makes no functional change.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> Changes since v1:
> - Rewrite the subject and description to distinguish software PTE
>   values from PTE table storage.
> 
> Changes since RFC v1:
> - Update the description for the architecture opt-in conversion.
> ---
>  include/linux/pagewalk.h | 2 +-
>  mm/ksm.c                 | 4 ++--
>  mm/madvise.c             | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index b41d7265c01bc..c34d826c5e4a2 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -89,7 +89,7 @@ struct mm_walk_ops {
>  		       struct mm_walk *walk);
>  	void (*post_vma)(struct mm_walk *walk);
>  	int (*install_pte)(unsigned long addr, unsigned long next,
> -			   pte_t *ptep, struct mm_walk *walk);
> +			   pte_t *ptentp, struct mm_walk *walk);
>  	enum page_walk_lock walk_lock;
>  };
>  
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 624f37975e129..2a4f19fe0f696 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1292,7 +1292,7 @@ static u32 calc_checksum(struct page *page)
>  }
>  
>  static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
> -			      pte_t *orig_pte)
> +			      pte_t *ptentp)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
> @@ -1371,7 +1371,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
>  
>  		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
>  	}
> -	*orig_pte = entry;
> +	*ptentp = entry;
>  	err = 0;
>  
>  out_unlock:
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 73c2901b9adbf..dd75a673e108f 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1113,12 +1113,12 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
>  }
>  
>  static int guard_install_set_pte(unsigned long addr, unsigned long next,
> -				 pte_t *ptep, struct mm_walk *walk)
> +				 pte_t *ptentp, struct mm_walk *walk)
>  {
>  	unsigned long *nr_pages = (unsigned long *)walk->private;
>  
>  	/* Simply install a PTE marker, this causes segfault on access. */
> -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
> +	*ptentp = make_pte_marker(PTE_MARKER_GUARD);
>  	(*nr_pages)++;
>  
>  	return 0;
> 
> -- 
> 2.47.3
> 

