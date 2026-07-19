Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE4CC44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 23:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA5F6B0088; Sun, 19 Jul 2026 19:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44996B008A; Sun, 19 Jul 2026 19:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BEA6B008C; Sun, 19 Jul 2026 19:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 693CF6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 19:28:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA7371A06DB
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:28:07 +0000 (UTC)
X-FDA: 85007116614.27.6EAE533
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79D932000B
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:28:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=M7RZagub;
	spf=pass (imf13.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784503686;
	b=RKLZG9K5q/4QdgKALP3sqfgIurvUwXvzepmyoJBUwhS273Md76rCyNJto3h20ZyFQZp36Q
	/8rOZ6gvUKHUKe4avcsnxpiVuHj3sg5YdiKFkVZ8hwoLXQZAsMSCeTwoUVo6gJ90FvU7X2
	e4BTzAiIKQ23t0uRUSTGLrvP4tKSRRY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=M7RZagub;
	spf=pass (imf13.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784503686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfmxZTRHizk/vTuU52QMn9mhqbO5m9+SAMKuRmAvyaA=;
	b=6mpIRi+OQ7k7BIxx7dXSTw58DMr2mZXWOfEyjbIEjCu0Lx5pnRYf3h7eoiyjjCEF+Sdrt7
	gVa2PKk8tOXLIk9avIyGiNwzA0kt3XHWylENAs8LwuJmC2xdkaJLebMwfq/U7XoLhfypeL
	PRpIwoNrYiHXVHm7cjLNPGveWEpTgPU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cfmxZTRHizk/vTuU52QMn9mhqbO5m9+SAMKuRmAvyaA=; b=M7RZagubyQWneyf8CpO11T6zkH
	oSEX2sg4tYx/HH+bDKBj2UwtwOIoy4Qcp5uZ6nYeyaoyXQrEH3V895vr6Au+G2qgO/l5eF2l7U3FP
	/HcFv01XhCQqu4dxKCI9BQklKawGn1zJjFozWAp3kHOy0jiELXl/9/3sCrJOOAsVuXUqU/mU8h0+y
	tIMU4RSp02Rrr/jnRMoh8E9A1nLnOw/ykVqRYP7ZG3wfp0woLPMwwX9EC2linQM6EQvkNisSHtB9x
	ERx+rUXNT8fypC7kYytE99HPdXm/gE/9CaGr+ws6gYgC9JIuXcXrWKUClClmNzVJeFsVur36mWSCU
	LrGYScvA==;
Received: from [12.151.47.154] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlaur-00000005WHA-1D0p;
	Sun, 19 Jul 2026 23:27:25 +0000
Date: Sun, 19 Jul 2026 19:27:23 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	SJ Park <sj@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>, 
	Kees Cook <kees@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	Christian Gmeiner <christian.gmeiner@gmail.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>, 
	Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
	Marijn Suijten <marijn.suijten@somainline.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, iommu@lists.linux.dev, 
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 12/33] MAINTAINERS: Move mm/interval_tree.c to rmap
 section
Message-ID: <qkzthzitcsa3ckb2c75t374ceggewbdzmrzmuq75p4c5qugq3v@6jodi5cilthv>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-12-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-12-2a5aa403d977@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79D932000B
X-Stat-Signature: q6obfux5o9xncp37715ix8ebbwj85brh
X-HE-Tag: 1784503685-617026
X-HE-Meta: U2FsdGVkX1+l1XVDT2amSiWlSvWH3/MsPVFE0Xs42w4ogQtmHaSC/n8XReYJwC4fW0Cin73uYdjhERr3lkrkjIoh2+TODS+R2X6TfA8mSqqBUnSissRBkDiJ/w4vUM6uSinb7KX5zo8AwrdpWe/5y7F5D73Xy6BEKMhZ1HZLlK4DCAH5HFnRNYLzInDSwu6qb9PotZRmXYZJCnIWMnsbk0o87WzwxU6rI2u7qW0WUE1HZuLBxeE++fbi6PnY2x7aKZsfSMtgXct5iRiDBPZlQwiuncPSdkVP/FPk205gJbObflOH3Fet1XWJxozw8wkrTUCyYkHTYSJpTs0YOKyfbLwX9ycwm6H9Eeek7Y8xa44bjzOWW2b8oAkkqIruGSILhK5hC8baLJT4KX22FBzX+GYUQp5zZJTNirf6vrS8SxcS52UMn1HGBZuw/w6XM5897WsXkaUQGn5HWhjXWriXts3LfTgnVN/eQ+qJ5Z41X7/Mhs2OwNo+qdYrUDUQjVncJUjSvSqRARfUqc6S+Idb5Q9GwLyYZOOGdNJikrUOKO22hkrxFihQ55aSiUUQ0iECcqJRgZMY5HqHUZ3/WwuZsgM6OEFE9IHAKZp36qTVRSplRA50H0cvpa9WJFCpp+xqSkGr3cFaHc0aDTIzc1ynLa5Ofgab0MOZ9xeuYfPD0zO4PFr1jYjz6kwA3Kd6JI0jrJ1b6R4r4H0AWTFz2hNVg4XbipGwNFzv0GnfCiAV7zFoVc72k4O/Rm/f0hH857icPomYIu4kB2PGkDJzhXsof0Fl70vmoXHZRSNu3ccfWvbohOnO+TbzLEKj8/xuLd55uSTSWZKRBOe7JYlSnn2lmF3D93WEbEyBP3oC56ovk6IEP9k2yANSgG+FP70AzEITGAF8cbb+vhuUe/ICa7R2+eaL3oXR4NTaIsZdHRbdnIxNxd8p9L8iVvksdGZu9duX0seBgM+Cbu7FtfUQPUD
 yNbFHMHk
 F3OMRKwUd8zuMPed6jJ4eUgTZEAcHD7ylgf8YzLyG1nyheIMtLHS3SFJl2YW4LZqZn7reGcVZY++KWWECtwdhNKxxjRAx6N53jZjxIK04k1njeFEr5coGULCTklTlSTJ8nErqvXU1E9lm4i7IM+dgQnSy13t76PjmHtNuwxwlULp0C1O2LPCPoObYLpkAJq8zSLFsB3Jet4TcQkfDsEGSknve6ZPMbWVG4mpF/wWzpE4sg94lCDSsBTliBsnLQu+Bt/U+T6tvyem+SgLaeTVZpk5MVTW3vqmQ0jtFoCqHH0+C8j5JgGYFXBTUIe/txtmTkkNBwCKLU0iDfndkTNFJEUp+Sn/7+jy+Br8YPvt74m9gf69Av7TPnNRXUz1xQT/PXq+HF2PuBZ4f2E5eHPkpmWrPezpLJNtHNEjG6CwYUFpOQ4pYSI4GJJGlFA/aezuE8FIpXhfx3FHrTaz4Al1hPZqDK66Wdlq85aKBlG+zZDTa4A6B6VOk+SSdslUY6TYnpRK4ll2R/WtnJQp4yznmcw208po1Bl2YGQGxXKCTV3Ner0EqT5xAoBHccsCEPPI48wcoroo/dwCzjmotpjQZsOQ+lWqeoCtbiDmwf2rMOAfWdApBoK1Hpk/GqVXzyYIIPMly4px6z+TjZf3CljwI3TjbK9DRTKM/1QiwD89be1eRwNNir+rYTBSnlKcK/jyF9ABEz8t8ft0/r0Ud2KUr9GCc0hrBrK9Sm7nHs3W3EqAFHktMxoM5vX9fu/Y0/76vzH2BoU7Com/FJhUDlQkRGoHr5I9HMlal8K7tUQ+Di+n70Bv9ga7GIUxd3JjqZkAk65p+bj/3BcihAhwRHMkNmZTiLj2P45D6cDJdMTzmbjANo35+Qf+c3RNHv1Ohlo3DFTaOmYxz7KFdrrYg+N3/CEr6ub1YItok4IGwutdG39FI7cVbHdjD8lfX+tp8MSxXR3uNkmtXfX/K/t8kIKaw8eYE/S6j
 38Lf9lPQ
 ASyMlXlwWTYxPAlZy7CkHGEmf0qnmeVKFl3uw/fLfgD3z3YI/Qd98+LuEwz34/1UfdKAI3QqArJHPTKt+7EeYDAmMcTU02SePbZiT9AedILVgz9Vkt/mHct92sPMWyrU/IVtfjDZx1qKjgy+tdFVXvi4Y2jqO1zL2hwuRgwm0cVFvbNKHkUBfUqDz9RkZOgizScAa0FLKbzpjRLEeZ9KmVUl0NJ470xVZoHdoCVswFvYxpOsulty0/V/bl50ZALUEHpDIe+Vj1ojNMEQcRy09JrHs5Hhtsp7wvgn9iTq1b9xQJ20Rops/H90Zvqac8kScMFeC+R3aO0weR/DekpiPLwnslIsseWtSWVfgCCCDhclTmZS84gprEOy+pg0djlwJ/czD/5FcA5Re2jzGUPoiGQ6j1PLGhxhxdjMKtpnr/x4DnUJqOHbH03aX7CW+ds/yb6WWAYDNuXrLx+KDqfvTLWDZDkU568SKiHoL4L96z5DEEQ6wYNqdGPO5YZ0elLnrEGQIlm3Ypi/JxWI4mgEfrO+ZSsqPZ+yS47R6bGTSzSr/+/fbIPYgKorvf5M4wIVE3cy5Eof/VAxTmRj5tX61XY2CFTcTgzi7KMe7KAy+nLglCbIM+BNsfHUJ1BYpsk12G22ECq2TAZhh1pSjt4ukDSj8xl9T9GD0fYmeYJfm9Dk13NgL6V9VSKTUkwsFhUU1vHwBsIOBV2Ys1K18W6JcKAlxoN/vXVqc0Ut0NR7xWsPHq2YcoE1IZxLlTJ/Zdn7h+HopKIJ7Xo0tRs+q36qzlA5rXRHseulFjgsmC279N7WQx6hUFdfMCCNwrMyQZtyEiwXYVsGilJrFY7LtGSiQq9s5iSGZENwIxHDivyWBF+7lA7CuOtjpvlys+ulMr2iLA8gW/ykMIap1WmJLDlYyMT9BiQ6og6OjeTLZToj2QbSXuXelCDxQ8MiGyTRjCiNCYtB0cBUhzRJKjFpOBIc6Ch4CD5kB
 BUPgOo3N
 ejPmbjo04tcq9CBU57Gj0+HtHYhTGuICidPNJE3+OjUjHm6nXQ3kXI78hGmdkyHp7i6kJ7RM/FicbjkEfFg5S66JTW4/2vXApjvTTc9eicR8i0BHbCQSgD4egnIq07dU87lABtUAj2+k4IJtaPlU1VFBfH2ehc/T8yalGpT4WqQd+b7nWunFIJBdNEkL52kqDb7Ffl4nwgzL1HjBCHjxDDJKmQjaSvMum43KkaN2bf2SmHMJNCT/gCBns74WBoxUvPRzr4nSzbmKQKHqqrR7It6C5DtAAY589hb5k8fvuE8OdIY6XSjx/RAKj8b1femsjRlTLt51jQP018ooI0yLVJpviOw/PeVPdbmT0F7mHBwHkSSJm7Xlw8x5EdWHd/i0szA8op+MKu9a1LDKt3j0OuyyLZ17yZmAbbmXXmoMWo0bYiKVCMXvBpdeKs2HiSITKU/8BLItlh8d5JRK36730z8RwbzMVDF23TuDrMtKGBahQLOqhudOA3iq9l8VygXFRguGHsx1FlUjUMn11OvuQcc1T4qWrWAN2CkMA6SnXTpMg1oo2mI/o006ZnxR3ddePMsg1H3yGVkBZWdx7QwPTZw1LCGXJk90CBs9nO/+W3yP3xmFtLb2HtiXrA5jDqd7XfSDVqEK1HYRHI+STvHHxP5oO1T4ixjq/fR8LCk4iz4ELNvgJu9HlfTqLKuG8PnbEFAPhydZZKaHS2o9qTUNTGz0fhxu9A7bWiQI1veUyVwuoy10wVyuNYL+aXSyAj1cMM7MuZuxdKTOLeVilQBveNTIYKA4b8Azz8NQ1qUQvI6DegR6xlCQBWGtGYWz8Sp1zWw4mJpf8jJmeMDB/UTOnibWrt6zuwuscvxkChsv8dfRZOsoHbQihmWla1x6KwWov4TmTMs2bn/ToZqhE+50YTYOWnmzssokkYfVGy4SkcPTwUrAohMwlhFZ7A2nSgt9A7w9PGxHi7ZycAZWbXuT08Z55v+f0
 bBFYZBDD
 vcnVZMoJGjI2mRCzckm6s4UwMx1EPGKwb2/CdoXZPCTm+AYmzsf8D60BoCvRUZlVGV6kC0Uy8Lr5ia7bpQSqBJKcrhu3HXNiCdWYRVASjzRVJ/uuPvzvSqHY5wsTTYaUiEZSX0LjjsmDkhQ/cyqyjiX5fvRaah0+dpKY7WTkZVoKbUqwbtYtcAN+hcw5SXqnGoPVheyBK3HHAlta6MWOYw5f+mIfRdSnqmXf+fdmqMLbARiL/V/bjPEj4gs2vs7d+alXs0fP3BkgAC601N/8GtFN2oPinBtA1cQdkPQV+1VUSd4NIjXJsp82uvK01zuRA8WVaS037VjI+Tn4WQOy8Z/hNkkjQX++5oo3BNg+0uOWc8Cyn4TSCROstm6EhaC37nEk4GtlOGFmzJL/MjsQdmLUTj3WrrqOgvET+nc34A/PY0toEi3YJAfQ+3pJdWeuseZVh5fmpofTG2YCxzJyCUMnPS7pxGfnWJuHLWZhHX3kYm/U3Z6/TPOemBel/CiUSxCGrKdRYWWsc3RVQwzvaQ0yvvfa74OdQBm+FNxNiydYjgLq3GcIHujwoRPj0jUoiYbE3/i4bPKSWGu9SKjLXEpjTPb+P/dUDOAIBS5r2BDvvonJG5SGGIZT1KmfOz+KHMBXWMfyqQv1M3wfSo9gSAVw3s1qdbSOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/07/10 09:16PM, Lorenzo Stoakes wrote:
> This file implements code for the interval trees used by the file and anon
> rmap implementation, so belongs in the rmap section.
> 
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by:  Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3e535ca4bef..ef168b583325 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17208,6 +17208,7 @@ R:	Lance Yang <lance.yang@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/rmap.h
> +F:	mm/interval_tree.c
>  F:	mm/page_vma_mapped.c
>  F:	mm/rmap.c
>  F:	tools/testing/selftests/mm/rmap.c
> @@ -17313,7 +17314,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/trace/events/mmap.h
>  F:	fs/proc/task_mmu.c
>  F:	fs/proc/task_nommu.c
> -F:	mm/interval_tree.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
>  F:	mm/mmap.c
> 
> -- 
> 2.55.0
> 

