Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9FE3C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8DE66B009D; Mon, 13 Jul 2026 14:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D946B00A0; Mon, 13 Jul 2026 14:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF9F6B00BA; Mon, 13 Jul 2026 14:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1E66B009D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:06:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F16E140120
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:06:47 +0000 (UTC)
X-FDA: 84984534054.01.06A5E26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58D2914000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:06:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h0Yb9LAX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783966005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RLaMYvaEZ6QnNNOQ5RKz5D3WUNa/mhzvYyboPZe8p0=;
	b=o7MQ11vpjHu4gOW9Xz/85WXNZEXEG58oMTq4RxudmBn3Zgfdm3QkQaByjHVUyFX97DUJta
	DeE+COfGvkT679kh9wJXfXbM951N9Cwc8TGP5oDqu7+202fO/kl2R18nHaXwRXMMbqPeMJ
	oWZjdm/iZzD4r/PEE+6DpuQftcqKNEw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h0Yb9LAX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783966005;
	b=DIOhsrB+oGfKOuldrx2RtFRUTlyXLKdqJ/j8qUvDPccpHXOyL6ojlrVWlixxj+pcNpSKQR
	Vb12IyOcECIvOaunaj4/rwfZ3BCEVrUxkBhkB8XRbmUhijLKwbMVCx9RHBCkmunzoHiVn1
	sKTIgJPi1OcrXlmP6PPsNt14+u8FV2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4D5460103;
	Mon, 13 Jul 2026 18:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885671F000E9;
	Mon, 13 Jul 2026 18:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783966004;
	bh=3RLaMYvaEZ6QnNNOQ5RKz5D3WUNa/mhzvYyboPZe8p0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h0Yb9LAXeOujn96l8cLyS9mH/iSvd0ZFm49X++VDgksIF19qL9j3vPomORDGY3lRZ
	 IBH8CX/gO5kDDLaz9qdQr91Lrb4crBu0R3rOnHG/JYHW7JqGKoNGLI0OCIQRUf5zq7
	 R+VYdDsBatBzzs4WE0Gwl0qbGzjJLnpE79+seQscQbgnPslB1IqVhEuavZMzRyu1f4
	 ZWb1CaCwSeWlxPvH2HsKrP2D1h4TIHsyUaF5mUxUHMMMChq03vgbmwukKr2m1ROH4R
	 2nlqNXtoZtyqxON4ZV3HpHqtJq8VaRUdO916AYrbhFWXxvVRl7YtNTjIzQJJINRsc2
	 QCHY2kTZaeveQ==
Message-ID: <c9c51ce7-b560-44f3-a50a-75b4538c2642@kernel.org>
Date: Mon, 13 Jul 2026 20:06:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/33] mm/rmap: rename anon_vma_interval_tree_*() to
 anon_rmap_tree_*()
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
 <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x9momntnp7311n6893xuxk1dnf6mt9x7
X-Rspamd-Queue-Id: 58D2914000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783966005-612347
X-HE-Meta: U2FsdGVkX18gR3UES7IPeu/fUw8pF+B+GPE6fsNnwmCvZiOB70KujisaHpZ+nKQ1UPG9aSrHLVvty7TaqWEivX+BLNG/CToESWh98Wm3nlsWYRHtiYxsXWi6DkXxLumuXiV9UCiHAOmPZbw+7/gnoeLMmzALvjssbfkgyrBXn7/W9fPcAf45Z7/KqGSfrh2ryH8o4KTA+F+7Yrkdf/dtREad4Mt8e55hLfOWl9YUUz2j6PMYtvNqJbHqp+sVryrd+pixjR35eGHdC6i1+xRDfc1NqscIa3J8tVoWIG6umwDIxsVIJREifbeqelDsUApqJduXc5z7Ni3aV3vqhyDELlDOfye5JVMh9+eAMMyiAbsIB7Yuw94BciqvW2hzmLl2UCNDH6fkO4KXV0Za1eN5nDxKzc9t39vVDE1UDAjbV758DLIAVjXSNMu37b/CaM2XOBMV704Ld8oCqdx+FYFTmTJppGOrLoemm+eg5rkxx7pC7WGRRYx/lHlxTY1f/a6dj8ttHzJCtdlLbpqcYHwosUDm4MNm0IxdYrd9mpn8cyPFKkdTj5RHYAlAc9KqYgtS2Dn3vygQKqn8CzKUJXdv5qVQw7Ke4yTebHgA8ZzCd7RoZVgIF31ZV78sOV621fo2D1fFLVzWg8uUZwOeGlPoBdVm5E56ZG/rK63n5ZkSFuWGjjjCP0m6WWEPuZQVT2YvOBMZR5+icSWCBtmt6J1JLkUcigDhSQWwEiruOSXeNFNB67GWBdQeFczTQH03T3akH/J3R91A8EUmRl/ukOf3rHLLT1G31InRfMn69vmfXf67v7XKarbbCjXUBaQtKyHpUIJpvPOB8mbPKd4JeG0edfSMcJeSivCWPiaxMykMH4wHRNbW7lIbXJE4lcQTHtsaU53tpuhL89N9oKWCHsEfG7gjDQpStliGf1O0V6c4wRU+GFVJobjm0eT5pGfp/L5J9ppXRXYSy5NlCEB/c0Q
 nrgUtT2C
 KRtIu/yYDvqM08UGrTyr0TDWDjhdnBihi8duLCtUL34V/9v6ognirzMP470rsKt8DQcJMRfsJznz52SIbCbPYn17GnCsLPvlFRgLs34l0bADGb3yC+Yo127nxk9dbBCXDfMPoAQSbl+sqAuYydFrHFEpICZaT3DSmg/6wFzMWOhpJV4s4yHDCJS7quXuGckeTKaRt8qQ3jrMMs7+7YPI2gMOrNZ1ZJLpHE9CRFCwId/r4Y0B7Q6sUx8+luuvd3x1XivjIUuGFqAXi69oHq+O0iHLkhxrOSyt3wm8LMTWfFWw+d4S4ZIsOh1bkefD2FgV/DIyKVowMdR/UqbCZzp9Q9nUfEP1ylU5YQwPma05fPEnN3LMIPpE9I6IuW5NMw17NYdg7ze8TE9qGiIqFWPe9IG0f2g5//PLqnfKIqlfDLhXMOA0cP5eScMBE8RZyHNEN9PvU9GPsTBYAYu8TswKlGxxWPfIRHTM65Gpm4hsT3IJQquwSmI/1Iwn1FCdL6SbM/5GunDHUMk4H3IT8m/5hPvhsgsdKRStBS71XbCspsf6p6UrmEDtPzeC9q/ZttNQSccOUxlE605g1qvjSk5DCyzQDDQ4cwwyipfka2bHyuSGS7iRuRfb7nzl3tkobQFB1LuWY3gZDo9bua4S/HEvL0UfTBOjBOcfxJ2718mKgR7A8xAht6iKWEt1h1R6Pl/YxV8FHU0NvQEeyXweNCN+edSugl5Sr4XRIzQJFgtccGspbYl0KlbUcCN0RN1dB2sjs+cz4uzj68T4b9pyBCNP+jaEE/WEKOEuHRo2f6OS5evOCK1Z6twCPhZ4++Q9Ga+sscFVOU1KixxDZ/+IRuWvxno//EJRBnGEKfU+gl8W6bY/P15HEUO2F8IcCPaTr5JP4ByEr9xxD1ScZQpL+ab5SPD2MG0xI0X/etBSaKOXIXY6GNuG5M5O6sOBVqtQ5wjpiByB9wAsms+ZivVtZ5bP1C5VrrZux
 n8dOwAli
 oLkbCWJoe+wic3P7Itw4inmMVyTiAqk/tNHfJXhJwWRzh1yYOYrkW9PjTXTqTbk4AyGISn+T0zouCm/VreDvcXA6AOLN7nfJJfX8KFK78dgTkU6zW5IafCGTy1wJwP6Nk+F/0YrQj3RdldF2+N2hI1dSV8VGvBTnOfEYZqKd7Xhk0QAWN3G2999XT1iePDyB9AkEpqXx/2BRiD8vQ8vpKcsBTVvp+CMBUZJeR8byv1Jp0OQFU3mK7kG6imift3S0OXImtH1EsB7i2QsFyAGnAIOhZlIBmkrwyCT4PeZKsHOxQdWkjt3clsKpRIKVMi5T9VzgaCojjJ1R+HwC3yMlrXGbzxfgQyS4yzOhQTBiUBlyMCTjStaCiYpvJSJSZUioMane3Xm0JhXqJU8kKNrinL5/FZb9kV4B+tH6/TBKEZvemNvFd8oamY0tmxG4R5NIiMLUS/CGMqJ6duGTpuR1TQMlPzUFOOO9YKWV4NAepI4VwqMblyHdzkn14bdTxu+wngqDbwM8k9kQZ853JiN2oMEiZsdQDyRFDM3Ni3Tlt9295LzFbLWxtxlaJiky7XIHv3tGMZxKrmgwNct7DOVNpiwsMfFN7UWLTZ1cd/JAdTxxLEYSGSRzZK4ddN4vn9cNOpMgRuDAAMG+kGVCubGLMKqoakkQmO/Ms7+AMj6H1GQ60t7OCqqNOVNKDJIgjQdVC1T7BJL2j7zW8r+SKfibh0HQ0PcrDdhwDRFveR/PMAZow3QYIhyTnc5BG6m6sVjswsqR+kXWd09NoxrsjS8Mxj8GZS/o/nqblaGTwedtHTDWW2CGNnmSAcKJeQCBDlsXW6uNCkvLmLdCdVyDJE4ZT7uo07SlG4CwBWka5qXjlbj3rnqdk/5vh9TFYPVR91Zz3BTau5sNjWAjXtkkn+v6vz+tDmUjnOgpRO8tgzD35GN0oW1Jfgtw8NLzWYlEwMsupuJ2nLyE9nsgdNU5RoYwEVGHx1Ffe
 rvWyZTAn
 N+11OIBvJb/ORVARlsFJOGqRJgSsW15TfFXpwN9QXeCCKKA6KFoQV5pRbF6hGgJUNa3hhdSE2p3QY4YlwYZv8Ozkv7lSQUSXz1oTCBVm8JB1NM1B46rZrbbG8dC9yaCe+FZ0eO3bD1/uQZbvlSpGEPraxrfsjoFT1+Jk2ZjmuIjcLQRdQOHFkLDrZGSCzF1yIBIYksZc6TK4FL43lb0iHSJNaIMmz4K6PwkTOx51NkCLnF1izlLWiqxIsfMIa+MmiLgj+KY7jznh/kpFVo3W/hvc4LvCDCQtACrm/GZKp2OMQRZlG6V2YaL7hmZwEJtLjjZCqg5k1wv07U4G5a+tVEXvrnXkQF3jv6HErgB+HBXfsj7KYFK+psw/RouFEyh9T23CAp39KsWBaGKUDnSsu5swjt+71p39dB/UX6KPK6xUnC46bifrhV8+EtHTftUKst14RwE8novlplKByHlUITc1McrhXgRrexMNbvJFqZAJFVZGJwXiuOiNvyrlmFgGYv6Y26JfMaPF0/Felu6HLpK/DICqFfv5+gbSzw2lwlCt8HcB09e4KkR7bt95nYuEK14SmsWfdk7u1viAoMn6TF3+Czy3j47S4jdgTi9Sys93C1FFBxDG4Eg9vCbB4+AFmtehU7/Q6cmRyliBWmQLw6h8QjMhuA7A0PdNKcGE3rRLhuYbi84bbFxG2UAJP6cbVsYMVqwNiLSwpkMH1uAURvr/ha1U57qnhVFRS47aCuGFlW4NDdwkYcRnWZwx+BboGAqEociYq9FeIAU0SQfmBf1JZfBQLJrf8HHunIK2SXPPvB6WqbYRdc0vXcYAOkRrSO1FRsKG1NinBD16PnyhHd1+naHKbhVAYap6PVLIf0yZ8vs6uzx9nBuyuRbwOdI4KzBdAuOKildif8BIWIw8mSu+tGyH4KghXcdLwpMNtx4ljPTmd1ZKRBE//mZjJpU2USeoLxcDvKv79acLx+injPQP9r5II
 CVyz1UWj
 iw5WK66MI30eFIPw+XOeerznGMl1MNhXfVGv7RfSiiXrXJmy0PWBIITuQLROrlT7PBegCbYx1o5dEb4vn020383la7gCGeFi9SsBgiayZiC+A+5XtM/glLRH5SOscXPLIKlpRKF0KhL0GTpvUcrJKafsIVimyCkK8RNtFwxLwFlmiAFa+22wKvn+jwgvjrpIebjh9FsOf0sGqP/wlYQ1ELkp/ufHmIAwQZah3wHRoalY0ZLbvygK6Cce7xTPHqou/jn3cwaSvQPmKez6aH95L746IX6zjbd2JdxRw2Zr0tyKkPRbBMO9ro040Ob2ELi4zdUiH4tXVgvpZun46RbK/+t5kBoInUj5N3MoMD0xaAFg/2eKIZmoQ19pTdZ7CxXigICDrypbXS4ul5SpVi40q7mmwXqDw5tdEVGDGwkUfYtdyzY/hIjea0HfG14Q30YS/Xg6zttQAXyv1kIb12kWtxYRcwVjvtiCgbht2mQjX6FspK2zt8rdykvnxwhY6sL0W7/b1e17dGAkrePSL23nQp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> To be consistent with the newly renamed mapping_rmap_tree_*(), rename the
> anon_vma_interval_tree_*() helpers to anon_rmap_tree_*().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


