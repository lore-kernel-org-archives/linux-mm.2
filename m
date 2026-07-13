Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23EEC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC396B008C; Mon, 13 Jul 2026 14:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D6E6B0092; Mon, 13 Jul 2026 14:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25916B0095; Mon, 13 Jul 2026 14:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4116B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:03:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F079CA0151
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:03:28 +0000 (UTC)
X-FDA: 84984525696.29.4AF8729
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35843C0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:03:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ufuflhr4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783965807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnOQHMd1q2gBvrGcRAVJ7qgBmhQ295/ZKWHRuFjKzK8=;
	b=ywWN956FvoWgSRJJbG3oa++yzM3Q0epJmD0TyZow8QL5mXmrSVYN+p/gww37mLWkDaUrOW
	v6KrkfQz1ypbsLQIdTTU4CZCVCGY2n0Qjjcbwy1rIAP3+Ki00kUTD1oIyUUE2qwZXsIvTF
	Cj4X1/mUWBpQ82w2QECTxVw41Z0pIBE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ufuflhr4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783965807;
	b=c4jSSD0u1OGCt8jDezo1Nn3No5QNivqpnPzNRd+eeK2wyo9kwj94+uOFKq9nHbquhn1Ieu
	OofA9NuxKspnZ//h+bmvOo8KUHCfkcQN+Ug018pzRhXeRK/86xHAIFsd8YLTljw2LqdPhE
	fJHWqq1LjKFgCKWArWTNCY/9DwNgDYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A085760120;
	Mon, 13 Jul 2026 18:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8081F000E9;
	Mon, 13 Jul 2026 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783965806;
	bh=HnOQHMd1q2gBvrGcRAVJ7qgBmhQ295/ZKWHRuFjKzK8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ufuflhr4mkff5rR70hwjRD3ujGc2B7bbJMEUQKk1nPLZrVVw/VZxsCVIBPEa1uqwa
	 n4fXm1r7IwT1igW1zS91UJAEXWW1bEdN9xo9W2fRw2R/XpmmoesHRb7qaqKhL7g+NJ
	 ERyHz61/ZqG9hnt7PuXg5swBg7oikC0PZsQVeMl1WYeaLdjAZrojY7I8+i3kJHCu3K
	 /s1zFdEwfI39wpFqBY3Ppfyiy8OS6t5WUoTotJikCgimW2gCxYTT2+qfjmqOGuUHHT
	 SnpaEwy0PULahojeEPKgv9wUrKLKsb2gm+rYzUwZyLMTkQkti1Yta7n0+DK+iR8j61
	 MKq3vptKlBlrw==
Message-ID: <b970d3fd-8528-4dfb-8428-1ecd9db5fcc2@kernel.org>
Date: Mon, 13 Jul 2026 20:03:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/33] mm/rmap: rename vma_interval_tree_*() to
 mapping_rmap_tree_*()
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
 <20260710-b4-pre-scalable-cow-v2-8-2a5aa403d977@kernel.org>
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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-8-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 35843C0007
X-Stat-Signature: j7szkdsm5jqjo7hm66cpgbwm4kwi9zjf
X-Rspam-User: 
X-HE-Tag: 1783965807-463986
X-HE-Meta: U2FsdGVkX18o1R4bZljm9jEuew/eo1D/WubavRZBM1cUWJ+nIYb1WZLKEvmMek41ptUsndwoqcy/WunejzSp7HrisjLontstQHjjE7LjUhkORwZVT7N7MPHcYhXUsqEgAsbdFGnOK/vPAThN5SzIs9d9sNKOA4P63s57P0GTNBcu/9OgSrHPoG8066HF2mKF8liY1v/w8PcavCv1NOnM/0N8m4e8VjvJWg/R/DmR5sk/R7rNEoaLPHaco/0yVx83joTFNheXHgjU62I3iPhJndCxApEPMOL0Y9jb+R2YXpC616ONP5b0klr+jpOXhYpzFnfhpXyi27WWpe5OkVZgSQY2FDpmrUuSAhClZQGC3rjhgnOMHzIoacJ5DEOlxdTx5l7he2Zn9/YLfhBnO8Tw7AzBZTqldrcCoTA7uoWTMprWLcHs+8HOfFWWEEZ/ju0Qj4oJ0MpUVSufkCSYLWB5CA5uAFhyZfYUmq6P0P6u4KqAX1WhG7IcxRN6iF+tII269EYdd2pIjIC3+4faO6/xwsMqnvqnBr/M6P6W7j698bMMOYosXeLYY/Nl/Sr5a9K/+ENH56PfDROQKQ9ArqafHWJB0hhVFu1cY9cWV33YaKq90ZqShr5vDA1zFvYcZ722kPNTeya2xAoJSNUNcl7fwtH7qm4TZXKS2b4Epvakv8DBRU8c/tPG1MDvlJSxP3MNMn2u5oMZXZMFDi1FwPqQ/eXLg88hzgmB4IjHWahKyYxnxJREH6fR6Y2LkZiFibvvrlVdWi5c5NskCbjlMUCMpiUkWQCTOwmnAKeN4iaJbUWxRhXpHIttpyUfd0nF+cAJ2zAA5f5hazC8Lwbwd6MHXrjkfAIfZb6GcW8vyJ4qf02LTwnBGYpPj7gx2TICMWygk93RM72Mw/QE/YL7JPFquK+iOnhDHw5MNIMSA1ewIleEEw/8cdrGGmNXyWJ2wgA+sX+RstV65kytW2SlraJ
 sP7q6e3z
 1IrJXv2/Q5QaC2uEqkAgIRaud/JzSWxvRwW4qggQ8iSdNr/IsELe/ysxyADJnGKpZqtk2/Mb3dw+a79izm5+MREPZoufXXy2ZVMmFIyh8JceV1ycUduHu0X1Vd84qZKjMB01zSmsVQt/tXOA8bGEpbdPEVkmKR9TKgAhkZE7A9UUVKEaiICe+Yv2ejNYSGvonnSKd6V8Tt+yuDkxFt81Gm/L6OhIeAh235D8oCPdbEHqoDBbD5NwCSr8+GDv3ew+0H+mRvG+5tKSY3pENw7jnlqT/E8W4QDtB0ddJnqgSQThx8zzzkzFduFF0zplCn2orp6uCQJifGAMAbO18dLSR7/RvtzZGcfkG3THzAyiJ8ClMMDJ86FXYv/ZCFenCuR/9Ca0prUeWHelST8A39FvG4nJ2uWpU2dkGqzSfXJWow8/SEe+xzt+nOwKLUWWT9lzGKOVW00/vqyow2IBUaKibhRJECPmhgxhkyGu0y6koaDOWfoT7+mjxKd2yg6HPr3TwFO3fD/lEQWxGWFahvddHNyAIazNJSKRDUibQ5KU/EVw2P0xK1lUSnc45xGqgu8BiqDXE5oqcAvgs3k+Gzc5ZWp0IYpXymSxwU+y//091FWQWUshHaCivDCk7QmHipajtBAxJ45I2JKk4Z+ojWMepiNjopGA8nVLNSnr9yq8d+z+QVcZNiPJ9/xDVNhqp11Jol3eWLpqIcws0/kGy1H+EWdpeiESBLmbMNvzs8YIIw4gx61hBvzIbV3EhHrIn+pPLnSh9hKWZLhaQzYFGqFkaByXncn902lSJfJPlJEsdESIa3U/4qS7wuvF+dzNHnEZ0zpTPdQVkFnUn5eoFLoWg4bv2lZy/OJCPMYCEXeVG6nATG2cFTq/tWmZ1Q8R9OW+Okbm2TiKerIq4ZqhLsoYqmWvUPXUtdGH/VlCpZPb/QVG/7ixEs4QmSb2cEejBSdkqyRpWS60CtYXJJRxnOhm5PJksHvHH
 321Z6uWW
 Q3Nuuq3el0e+oUgd1+Edb9tXuYHGwdcVInsRguA9hMzsTyj70NK6f77q9cx5ofMcuZyucDt/dc048jC+skegwrZ/9PUvA8N7yFrZvnfOioDQeBByMlPBIuZs7uVrKhNEPpa833eNnr3PnRyIZTsTr//sBLVP2xns8jxp289HC+lTc8J16gTfARRql4Ok2Z5msoY2IsnB8F8r2g9KyZW5X4lKjV0KKrHKpLGkz/GTBaGNuDeAb9MkTlTmaD5DiD4koe2otteaS0UeWyup98ugwqjHKOOMzsqews3IAF7r2jcQuc3q1b79fZ95cVvsd1Tk80v5afETD0TsoR53capnJFg6Dq7taKCJh7k2YI+OCwXvAKRCC/RqhNpZV9C7zd+fWUQnDbSNqM/Pe9k7JPuFHrHFmY2RvEQTu3fIjy8VO69reCWiKb/kvopC4b+5M/ao+KbK1CHmgRAm7AR/VXI0fgJbDF5A+JLTQoI5dUaa7VpNxWnVnjZmwS9ps7PbHAHaMO6j+grHqzxBxWW6y1VQpSOjgRi1LwBp9y2Iom3WwCmTMdbXZEKNEtaBOma1OZCFOZOgfdOgtJawyKxReh7Wjkt11cqLo5mM5DUnKv+DaKSX2HvcHw6fK7TGXQ//5sDmrWLlR9ROsIUVGxu/lkxaN0li+4F/V9FRWmOibPZ3ZCyygAR4CcQcC654nwVEFV7Ad19saJJtqd4YAqOgTIxZeiE+mxuouTz4euXf1/7L/9VLx2yUrldTlPbIO3YfXZeK+ntH6Q5hDQ0s0OmS2eDoHFdAnqTAFf23TBwfN2+1WD8Cfv2zJGnkiBTNvy6INMuUxHv8dxXe+SKWz68dlqnQKdvyH9X9ZpkgZuRH1b9TTHB09cHH0KjsDzKO3GisXXpp0ACBxPk9ZY8ddc5bNSr5CKcSH+XHe11n+3/M1d88lOyMO+Z3m7cLv0tVrmJBuSC35Ztmblo3KEl1kj5pByZH6NKY7JV3x
 cyTswJm0
 Ey7RcWLjbvAqGdRLlIOXOZsJCaeoHgcPboM5Y1kC3b/kclPzqvpQUfSmbbZ7tdYbDYOBmLCFUNUnbWhX2JCu7Glztp/ydwP51nDJ4ga369NBHVm3iSVEXqkLzbq9yI74QeF/EsSchZsRMb7ocIGVMjhuWK/3XgUQ9rO67+XyxP9tCEAEa8ctEeOaMILrGmrBuwAuJVrPhTTmQjQuTirhRbbqO7yTTScLioQTITKkvCwWQJnjp8oR7y6NPQ+r+aA057DfmYPZDhrVeCv57ZmgPvoqOiMmAkC/Oe2WaJyUgD5Yepl9NNPmljFOhBgD0aABa2gEF9sLQRYtMjDhoM1I3X8m895uA9jYXPoJOnuiASRsARGC4fEZm1taX9YtMGSckWX/L3Q20JKqQM2uz2HW8vdGluKSN1qPp7Xd/y7Ncb2/qhDiw64nAk3utr1VY5KAmv0VsANvttz4McUiJwgdVkY2q8aLdI+FMfqcx0IlutHOELamPI6IW8hgSM+C+myG9MIuiG2WaHLZ3TTlXvMNaiR4xjqThpZl4k1mj3YUAaGOUl6+pAiYlWqkx7yo0EP5z2sYaDOiY0Y/ai8L3L3+WJBQdd+U+7crijE1uPiz/GddI/nYZ50dI/pKGFRS0Z7XrAb301TW8/8y1pPdhLBZUZv1LPa1ZilFZ9s9SXo2jJwExYrmzzKP0PQAVO6J4Be+p8yDCB4ML1etfLTgZBDLfprtl/6xs0ieunzWYYOFMhXgQPM4O859M63l8uXIvFlMMLJU/P8n4lxjNAVLGX2W2xJKyP9sTffo5uN345tJrwc/8DqDSV24JVSMhA+Zp2xpKsDtN6lq13mHyWVLtEvmc9ZcmFkxyoIr7BV89lySSXdReuW9lkOGxHnO99OzJ51DfgaMtuwXZoYkY4CRr/lZivdBEJaXzm2HtFwm4yRcuj9968U/7JRoJpM6QDSDjkniqK0Bhbgbg/ba/VF49s8I2KeEhplK6
 NmWySpra
 AwAiNA210eZidl8t9jlxpjt7G+Tii3P6gEQpk1JUdQWisBDCMA2uvvUPJ42Im+bpNXxY+bwLm+iIGj539t5Kt0O1aYM1pOwmtGpmYGhNm399OZKpheqwpITYBakiBRaC1VEf5Z41kVqm60icCrWFCj0UJSMOp0QJ24+LCi+Scj3zhefnz3SNufUcrBdaS29t3Jb+O6nvvcdgoPPLpFHyMjTwy0s5bd4p5nTuYgusazCUxAEdSAXt3ijWC8XfcV+stjHVjwpZQO4GT7g8mtj9wUG5vh7IU67WZ9SiD2P7SecCbhZl3n1L5r6QpRsRBsJsnhrAPp8471BGOISFyz+/qyqYHPOAg/3ZEyW11hQqERMvMmJUqiOJIyLig6JlGCcQEvzNfeRiEGmTavxJV2HJzi+bxsZ1+WPOjXjiFo70nF74MGTKj0MlnZ87Q+13fiHK4yyTqUgoYurgXnQm2zHXR417Ly9XBbJELjSgfLyBCUEaqIJvKq5M4w8RXDA2HwSbk4m2E/IGtaBcfq5jiCGAWdnAsAZcToeplWEuQ3N+mNKdhre0kMhUnfwCmfGDIZooZ+n0n7XcL0lZZVL8QvPXZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> The family of vma_interval_tree_() functions manipulate the
> address_space (which, of course, is generally referred to as 'mapping')
> reverse mapping, but are named the 'VMA' interval tree.
> 
> VMAs may be mapped by an anon_vma, an address_space, or both. Therefore
> calling the mapping interval tree a 'VMA' interval tree is rather
> confusing.
> 
> This is also inconsistent with the anon_vma_interval_tree_*() functions
> which explicitly reference the rmap object to which they pertain.
> 
> Rename the vma_interval_tree_*() functions to mapping_rmap_tree_*() to
> correct this.
> 
> We will rename the anon rmap functions similarly in a subsequent patch.
> 
> No functional change intended.
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


