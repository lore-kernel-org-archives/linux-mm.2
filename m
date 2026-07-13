Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73EDC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF806B00E0; Mon, 13 Jul 2026 14:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B875C6B00F3; Mon, 13 Jul 2026 14:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E836B00F9; Mon, 13 Jul 2026 14:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7356B00E0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:19:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBB70140116
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:19:20 +0000 (UTC)
X-FDA: 84984565680.21.04D0AAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1E0D9C0006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:19:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2L0dmvd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783966759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AssdkOWa6aCLAEE7Hh+BmFEVrQ1Ylqr6hgPvApo58RI=;
	b=obC5ze0RF12+7tqnz5iYXvhLawFUmEXKGLYTTjnxk+0bS4UfReO2evXmfxm3vxqVQoI0im
	VUkDFT+r88CHB5FGgVhAggfIoAWyqF7fJhig80sp4YNae0mzOIbA2Ad06+EzdRt10lrfOH
	qiAUHlOuPGUHDn4jxZkl6k+19LgTpOs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2L0dmvd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783966759;
	b=8UdMflFRMD/6lKoA7nMvFspqI1qxGqcqebsvzpI3myU4uvtqmQk9+2H7zGsmeJXB7ZaNpt
	Jh70X1a6TXx7HMrZnnFaGlScbwHUMO2mSqU9CQSEYt2jKHN2RmmA9P7GEnYYirvhtrBv7i
	nupZAM3rEdWvahup0gl7STTxJcNz80o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F355040846;
	Mon, 13 Jul 2026 18:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147BB1F000E9;
	Mon, 13 Jul 2026 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783966757;
	bh=AssdkOWa6aCLAEE7Hh+BmFEVrQ1Ylqr6hgPvApo58RI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m2L0dmvddbtczpkvbIX8Tkam6L4D8umvoWFG8KrC3o6Qlsepc7EIW5CvtlVagnMJ2
	 cLGwEBNC0gVZeRYpPREi/gUkfjfDm17vPk1LcipNVk67ah/tQhBBDmQL9UI2uPDl18
	 7QOC8/vJN7ZZqG3nlVdkqBitQxcg2LEQicp/mREzbRgfHx3gnfESfmR9YG41KqNKA8
	 DHj4rOC7BhkfczlCVe0bb+mcrr147/oxZG1FKSprQwK7LErfu6yf0Py9I9vsmTusaL
	 y1MyO5daAaCmqEmJgd/4IFOhfko3MMneVZif9SP3nfjz+uWMc4N0blvo0yQvveOwWS
	 s8DpRibSHNqDQ==
Message-ID: <5a60f964-3756-42fe-9b03-11eecac9c249@kernel.org>
Date: Mon, 13 Jul 2026 20:18:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/33] mm/vma: clean up anon_vma_compatible()
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
 <20260710-b4-pre-scalable-cow-v2-14-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-14-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1E0D9C0006
X-Stat-Signature: aa1dcp49nhmc8u7ryspq9y84jjmcidkn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783966758-86191
X-HE-Meta: U2FsdGVkX19EVK/nlTHKj1v6GzKTF1a8Kub1Zp8KUKeYGir991KRhDEBzwSrhz+ffryMZYGam6PxyB8Mji+gQ1J68RSEB00NKQEZ5k8d3cf7GbVqh55panmJFKPFD5XxzNhXrPoNVpOdHMVzNwtL+viYHcZZVRMasrOVPaZfN79na5lXZc2eSRpBWepXgQ9d9czDQ1oolRloA6Tdc6Eq+YNCHrP9ngM0BOSmEmY0oP4XUBsbSbfOc/4cBgv1jhpVyk+xAxuLEyba6D7PY4ntbR+ixbplLSrH3/IAU/5ZCphsk8FqIAxyixDn+aKpSPbU5z1N7HvDSdMe45IS2RIcUQFD2RhhH8f1TGvbCre71VXFZmRsMEuE5lj305fiAlgEnVK8rhtU6NslVedAeWLu7y56RZNuTRYya97D1cRX1YEZYbCvEItUNT/h8qDHHUCKrgOcZZ/9HDNTW+2GSYVTyurCDjyNripOVFf9WltWaXRYqawxWT/BSxDd8wi+FaiImgw+dZFZkikIScxE4150kdjlt8vvIzSQERBNGPO9fqIJruoqIWMSKd7Fb+eY237O4ZAqn1F9hnvFVxRK9Aq4gW9IWjABmkgTPFkpT3OgQoKbTbIQWkcAhBBSAY/bn6EXNEcsDuiXsd3i5JISjRIH7xML47Th7jo/bnyEE18DAFnj+W5Ln8MaAFPfguZW+Ew8zwskcaoD8d4+0WsemumJLp+WQxgZfSMuOTADG+D0Fsomc5navufiXX3zdYK+dDOOhxo4/IuJlZGp8IfDDZpP4fpyHDal3OAHHS/D6UqONMZ0MJd6nVEekPijn/qVC7u5JJT/KyderIbojdK9ttmRf86SwVWX7UDxCN+EhgpsXbEVpAxN3hD0Kpf0FGWH0ZZbU4pL2zsg+ZAPGvWZC+oaNVSEg93sf1noRu/CTNkhf+r2MwRSfbe+Suu7Ot98MwaOUTh+bCXACqG2KE7bkUW
 Hif2uJ0K
 gzi+Ky7dnBUSyHGBCFVBczBG6QasrqT6liwBhYfvuthfbxQSN1crStXUEd4zDZLQqZBMHtXd/5oHlk24tfN8B9WYaEVwcRU+R34iNZ/cBkvAcQM5dmMdv3ECBX6VTB/l6ynF6Fu4q0L8e9OKIWeX1uyYS9swKHnMmNKGUHaJ/dhZX6vVa52YIqZbiAqH00/6ndSLKZpC0CViYsXQPFjwPf61VtWsQ7FgwjtD42fogDmy/hP+jc1KCrFcM0Ikuxn/eSJBycjRiiVkY6xFr8w61PPh9q2TbJRn/g56BweHHFnFSBPJPjwEug4o8aS8QtemNIqrii3Mhj9INAiyvIwdvu3Iw0yS1b/WknvbriLKh5ys6eOOD39kjVCajORzraNxL064yumxVtvPMEoljGrlNSo/02o054JUEyhrtsAXiVApmz8Selt5MtbpUNw6jNnVs4deP3XYAnNULbn/iRHsgD53pdmjWvcizQbgLK9xdnXIpeESJ6jjHL0yoeX5A8xyxAyyV9GHAje2ijzXkGDHlH2nBSTvo6EiiAVD/4yzI6Hexk7P11r5hhVKC6A2U2Wp5hRqjjbEXQGbx75pzOeEnXXWORb6LqT+Wetshm52tSecrlplwBaCbo28WWkCMe8uEiGtAc9Rp9x2OsopfY2iWHYzqDqqYp3ET0VUHWgiUOBF2/4RdI3v8Y5qWlWlWFa9qwJqtFVhHh/A9TFXuFZ6iCvF53D2jAzMx9VSRXdEBOc7ACX9Wiuyj7cpA4GBMhlDZVO7xmtMgb9RQeBp/etX3owhNC+nB/cI0MvaC6TxrPBuHRf2ozsFF6oSPCh+w1Pflpcm0OeVSkDP494lsMRiOlGppytxvwLxZ2RE29Lt24II9fSyoqQbTfz19Afe8g7BepzU6Ix4CDqFUWOQrLMKY5lS+Z55dKMxwvyBBpZDIaMGDCOfMToZMsFtT381y9IdyVsiVhuxBOU7vRgeea1PjnhPy9SOG
 nBrCamzZ
 39a52KEdx3a0bemUTZkLy9uBIImTjAQPo8p6bztCz0HwNoEHkuMd2rWicS1LAD1gznbxUML4Vb5Sj1OqI0KkhtKk3vrg0gfm9HiVbY4erxfqnbMMYNweSmiKbnCBed+21hzgNYXKxbXjFs8/2PYkrFu2zdw1CQygiTgvyGOVmJmvuGjZLGRYP6l/isxkbN+7xY0OS6e5uWD+ys/x5k44BUgmqxjEqCbjl8okoaqFSJ90MFUF7JVRM5ma7j61UiieDMea+S5fQOWSDoJR6UlyJQLbUD8TJZBGOH1iMUrXgMtHJW7FUh402yUFKjDj/Ns98+PwC6TYS43NBn/p670rW3S9tXzEnaIVg/kjp3nIntu3pZuCk79S3T7xj4FI2rsumYTitDUW5Awh2NjEdAe+RvgGcN2GtXJ6pR/o4om5yLvKEJxwLe4akSzninY8FqhOl6YH8wnbpuDIaAg2VDRXWdQNKFJPVktXpg/+2mAleE//N6onqiMsseXjEHgcXiREgyl39FpPyIh/nQVGOLErGCSh+5XcrlXf2fsSz520P4jXgS79Gtr3xs3yMsBOjaoRIVyru8rCkyXCtYGimXd0KVifjVStYu2hwvhlRFTpzU1WnlHrf8h/g3GBTjecvy9iL/SPSXxcKH5G1M6PXWLMUnh5Pv/q9wIa6AukdEEVg+pK6Ne1RpuA9joL2xVDCRUM0dfyk3/Ie5bghTzFx0jDt71JKbFERRjTHrBG01SoT6Ay/iDE87exVrOqN8EY3hipZPK2/uamwAoj7+u1CrYQU1CXvy43YRRELRUwvd8NtkAswT+NhVCPrshPcRhpgYe7AzseBefTytDKAr1tOtgqQjlA4uptqRFDjWxY97dBexlDLBiyNckSdxwzr5kPlmhBQM2Ulfm4ErsJYEtadSdW7oHtgbkPLQrKwiX3vKA2FUzH1uX5huDr1k2TPIt+dASl0+y4KWHfD/ItZoK30baxY9NSnRslT
 uKBMZe2s
 oDI938XkCnOEefJOVhlI7cHd6irOtHCDSACHRIMNqjmxSKQWtgFnq3Nv9tbzhi6Kn6OknNuK/PcCTE2hBGKmsq1T/BUX9HJaTqhA52omqSNFuwSHh5sp/+obw0Sa9RdYeaGSWljOzsp471vo+18mNgJjhjPRRMp988NysMeObYInrEtDX2DI/3roSRQCstoosZl5GRnK0bMlwYFRhIDD26/RpXF7jXRhqzq6emkdqa/IyE03tL51DNft6OS23js0hGrHhu3zbQmsJ9PggDa4i07uzK/HXNB0Ws7x6ZY8J77+mpnuNeVMJvZawImTjb6u6OLL2u6plwWKR3SCQdWZPjkv541X85jduLWehH6Wb+/KMFRcSfK2fKQKrJZF7en7GbjfrAMqWvKIyuajVjwQhdhF0hT5LPwxEZjcB6Nnjsu4FgzD8Av244VdgRGJ1SYPtalhs3oRE6+nmHHgFojaDCiBaraUCzhZD1bSOGHvyhRyhv+5hRtaHGefWYLvgQZW/Kg7V9Ppxv4Ks+68XbIB+Md/6T/LbqXalVPXjD7Fz8S7yIZwi+oTGwSv+Lvgdl+OpdPGEy9aKBS7Ot63mGxsWWgkYDqr6r2a1xmUNVcwhMAu8Bw16Ob9r3TNC7Kt4763o48COAwQdfK8TWTAPoCyWsYw9IBoKBi4NPpvrcDhu8YhN77FQaADe4bJpwQv839UfSxltBX+j/n6dhJB70p++8VJZwyBl2YiHsTe536zrFNMORct3aJ7/cHbH+05VC5EG9ghRfSAhj/V95D4zKks7aCC1XtBPsdYTY5iS1ghp3VTiNEpgbgf9SMgHmRdmxsFGk30SXdiETYnZnvNjvI1u7YS3158WHC1dbhkWI/2kJCHUIb5IyfYDfcfAcNMdkpNqOxl5azlfamny3zYyZsu5vL/cvJ8hajWgdOM02hrWOiP/qlWb39PBUOMgpiWEtAb4iiT0gkyp6fiN528RsmBH8rgquf4Z
 nbz6s/9I
 bNIoJVWDTxpNfsX/hAgErlegrFHxY3aLIB4ku3jF8ZdqBQzDho8RlRtvEjOD9sJxYd/C+3xDrRKUp8Ukc+l7YU/02iiFhvRQAKE6A2uarz0hUxlOPl/rlRLcBT9hMqqts0GVmiMcL/YM6XiWGcSIgF52Y4+/Mi2xgRaI/+2F5LFYNOUvzrrOtjiwYAjkvPjZeeIxIJxP9rL1TENgPG2l0WAzZPe1sY/KtYHC67+3RXQ1ZeuvLfQpG8gPDoLrzsf9S1CM18SXaLV4e6Lko2yHAuqP5Y2AZyr4OabDlixfiIHWG/I7pW7J6+hDiLcDR/82GSnjocNgMjii0hqR0zNfUiRU6NCtVoZU5rkHKPbVcx3E8aa0sAbDcM28IW0ILHADQF1kzt8W6TpV0bcwq2EFQEw45ebxGF0k1CKfxv5i+B4reH+w9bUIx12Vu1/k+8Snj60nezu8+J0IVEhAMMxlvq1uIfTpYY/bKfGc4JZcZsUPVM7GmaK0s8VpyarmZJ7fyudQFPm4sIJgzZ3ao2Yu4YZhXPGcRn6/Vd90B0M2pD0ZFL4ho4Qmwu2n+E39YmSi1D9HWxY5kpWxuDOztnyZgd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> Break up the existing very large conditional, add comments and use
> vma_[start/end]_pgoff() to make clearer what we're doing here.
> 
> No functional change intended.
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/vma.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index 995de8198fbb..084afdf37385 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1967,14 +1967,25 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
>  {
>  	vma_flags_t diff = vma_flags_diff_pair(&a->flags, &b->flags);
>  
> +	/* Ignore flags that mprotect() can change. */
>  	vma_flags_clear_mask(&diff, VMA_ACCESS_FLAGS);
> +	/* Ignore flags that do not impact merging. */
>  	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
>  
> -	return a->vm_end == b->vm_start &&
> -		mpol_equal(vma_policy(a), vma_policy(b)) &&
> -		a->vm_file == b->vm_file &&
> -		vma_flags_empty(&diff) &&
> -		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
> +	/* Must be adjacent. */
> +	if (a->vm_end != b->vm_start)
> +		return false;
> +	/* Must have matching policy. */
> +	if (!mpol_equal(vma_policy(a), vma_policy(b)))
> +		return false;
> +	/* Must both be anon or map the same file (MAP_PRIVATE case). */
> +	if (a->vm_file != b->vm_file)
> +		return false;
> +	/* Flags must be equivalent modulo mprotect(). */
> +	if (!vma_flags_empty(&diff))
> +		return false;
> +	/* Page offset must align. */
> +	return vma_end_pgoff(a) == vma_start_pgoff(b);
>  }
>  
>  /*
> 


