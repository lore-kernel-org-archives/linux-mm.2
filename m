Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12446C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36E66B0092; Wed, 15 Jul 2026 13:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7586B0093; Wed, 15 Jul 2026 13:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF816B0098; Wed, 15 Jul 2026 13:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 945006B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:40:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E64A120271
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:40:21 +0000 (UTC)
X-FDA: 84991725042.03.AB5F40D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 07FAF4000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:40:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GA0+FLfe;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784137219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tH4QyDNP0efpSTBbWpcQuJMGvW7RLC8yuTK2WVW/q3U=;
	b=t9T6vIethnjcvNl5s2/yfKqRzJrjBLzmb0MvszAgemp/D5UTeru8mkod+OxMMtRcbXfT8f
	Vt8EqFl8jGoMdJoz4NImU0AbRaK/bQPqZqMFYPqg2fLnsVPUzl42PsbtfoLDJ8TvWIXjSL
	QQm3gdEwYk3eegAB7eoFdfGkZnIXfpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784137219;
	b=Wc1UlTrhVdjHfq4t31gWFG1oiL5xAmS02qsaVdqT2u4IoUAQJKk2CChQcEwuREdthDb8fQ
	p4L0oq87/CkmpaM13vyQ+Ieq37teHzqpddozbG6R9s4cfSpFh9/qLzRoI67OQL3OfhKkAs
	Uqm4vtA//Rayigsh657JR0iKSw/z9+Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GA0+FLfe;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DEAE40672;
	Wed, 15 Jul 2026 17:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1CD1F000E9;
	Wed, 15 Jul 2026 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784137218;
	bh=tH4QyDNP0efpSTBbWpcQuJMGvW7RLC8yuTK2WVW/q3U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GA0+FLfepgKGsqfA851a3z/LBMqjNvN7mlxIZadRUM1CQ31syIV69n+3dBWRo/wp1
	 fJUduYImYES3PnHo2TdgTzhpdpkEUIFUX6NB8XvGrMhPgzcSqV1W6XUbdCo5iug2no
	 IdjQNOsEYydF6h4M0TiG0qei9Y0DJcVDuF0swmZ588A1y1UkMZ3oIAhSrnsOi6In+v
	 RsO/Z7TAh1/wV97q57f/nNooWy1GN3foCaP7j/ZbLLzTa9vJSIzN9ivMFGs2IXYXAP
	 f4rr087CYj2fwrWuOva4EjDNOYMBshVbZ2amcUZakPRusysh8mUltZl9STn+gyKYpY
	 NZezqYRSbhmRg==
Message-ID: <cfd512d8-4c2b-4359-9255-a18b2f2f91bf@kernel.org>
Date: Wed, 15 Jul 2026 19:39:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/33] mm/vma: move __install_special_mapping() to
 vma.c
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
 <20260710-b4-pre-scalable-cow-v2-24-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-24-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07FAF4000C
X-Stat-Signature: t4jjd6dnk9zz4bqj79udbna439dtprqz
X-HE-Tag: 1784137218-866872
X-HE-Meta: U2FsdGVkX19vyDnoyoFGx7DBujXhJ3fDXM7V6zATPmB87rp3HzQz7j+HrjvnzoQjtgT+ktLcnI/bqJf8PuOq2hZeCEDwMBJFKTlBPRiHJyPEurQfaBLWNiHbBYyxJtZs2h1WXBPpRhOEvFxIEPBQVbpYSVAISeXIyRROYxC9ghtLofaTLkLOZtrYxZHPy77Bv1HfNNPR5utrYdg9Tw1Vvf49gCztUlW64BoyRp3Ti50bCFf3hjcDX1sMUFM3GrDgMCydCDuHkFmY6rH2XiKAvIowZ/jb4F4DaxfAe3lNolgW4F8ArNSwt0yxZwgsizssyAkRhB3RNnXboetLBHX4pOkoQvAK4VzxnnUSCCQDOlnQBLTu+t+B/Tk8XVqedLESZFMhHVQKu+9JQE6tw4JTXjwXblsJYDTI0jTAYdJUZxKyLW3zqsypWMznWH/lchnbQg4LHCY60q37q77tj+XTNnWmiQbdLUp1Ulkw1Pz2hRgp2qa6KGSHp6WqOm7WwvsG3iS7rcASeWvb8u/K6Eyj7w+xxPGJNMgVWiG3ZWUkQ2zsOGRYPljmTeen+O4Thu6UDsR+s1er4NP0pTsdMPkpPNmRj4WNA5OksYfWCD6eKtAyIdbk27BxCvjj0Kbaq+c5uYwG/mGECNaAm+17Doix6jV/8GUj6Dq+lDI0FCY6ZPu1S79PenSSj7uoJ2TK2gLb3XZzo4lpaIeY31WcfiQfhJyRG0xu9jn4xXKmTEiEHE67Xz+GKLj6CbLWHGzQyy4S8uQ2+dcW6Lgfqa3R6T9BABkCqxBDR82MhXddw/pi0VyNllbMnPC8JBiJ4f/RaDckj7IeDZz1M4ro6WAKcehfa2uEoTHSkhZeXBrmLjSU+bm5fWdFDpg+eBLhhWIriHDVWSsqqlK2wWvWs3YsyAp3O6bmpdMB4hbo1ovL1X8ZV0po9kGwqlKzm/tpm0PQPcGQhByWyVK82+jfsFknR+N
 LbryTSxc
 CBnfoicqfSMJcIjyiZBK3JjrU0wWCBlMRq7bZqh2aoHxICG3d/2IpxSbxEIm1USDCVR3cnSdV+56lvHoTGkQ4ypu5JU+ho4Hm07I0Fq1oXtl+FFSgmACGOI7HPPjSkE1i14uiJj+bhMZ4v7sZbIyFC51hOnZR4/adbC1NdvfCpLaJSYabI+QxF7I8wKt2TAGdOiZzshw+qFjZEdqekQDycbPx3YFXxorkpnkyBrEJ2zx82bplky5ZECGif3kt49qu/YP+e9hxRq6hovRY3qv1Oo4Y6VhQXlOZaImy+m2fRzgJErB7zIfJunMO/JM77WiY2/PPVzr+zzm3xZsy4QQ5MhKHeMk+Q9M8Cyc2vTL8Zb1KaZMCXh5NdD2SJEsZuMOePZjL+itiVIr8TPSiaPjrIKnUf9SwOtt/E7q+KNXAVwveg11MUo4dPQH63ilcAR27JeeWctWLOye2DmtrULp6AYkdtf+fYJTW0wWxZnhN4noEHQfK3Kc9GKcjpmn5jz/zdpOhdUTgILPMZRYeFETKHdZDinULQ90XVqXuwLRNhZU8XmNJXlmcl+saReSU71S/bGGb38CM41t1E9Z8E79esGQsZ4dthuwBoiwcHwJT+QM+WSRU8grc8g0b1eqkikalxtQPUrrbjeh6AXa2CwqMvPtStcOYfAYv8bDny/3p2Q8MyQ+DnxZqqbY5owIVn4/JUw1yqvADV+FxQk//WESsal+vMfnlkGU0cth8VbbKXCe9o6cyF1mU2e2too5zk35cyI3FJpnkcT4Q5cG8yNMzOwaevoBDN1JI0rZ542gZ5Nun7c4iLUKYUEaCUjv/sxAO/Bdmyai28JMvO6zRauB8HoRJAfm02pxDnYx8DPdh+rg8K+dMg/MqwkJke0wYq52KqR/I3ifiyo3WQ4BKCPKWtpWKIn9VVyePtOPfeLqsk2sv0K5a7ug7QOwSKIqVxR/U2P+FyXGkCK5p2Xef1WWjGUMButAS
 izRJltLE
 rMmo9VqiUEcseG1pysus1M3DUR7k8MMyXAXPPl9uv0kJD8ef5tnYBRcDzf1qJ8XMaFtMV33rNXrOp2tzdCNdwX7PUFbmRk3KXKzV0jAKMAtT7af3tB8HuJWyG3Ws+/BySC4zaQ+Q1CLdub3ZuaVT+3eqocaEYmUGL0i2hB0yoCpX1vAnIt+r/I3oyqavmPOwSZBX655Voc6323wiK9ZdWBNuHnNWXcD9kZASnjmRboQ0AmJ+vWLcCdIHgd+7ExvhXtr88O5vH+DEN9uNkycfq1bieBx4MeUDfy6HENavDv/9mHttaDcCmOK/GWJw/YRO5xyEJVwp+qeo8yu9OQySrPelyj6QGKREtvwnzb8CgYFmNJkhFNPpmQOC1/7thnyt9W0eMa1H8M/8wuoxzkUTdAxSzW+MZksi21DNXXJFL/xr/KMHjKp6yq82jOBJ3mN34qwhnKGm6pXSyAv45Q2eDd/6d5hsKvoodRLvqfE714BBlokMS2iQk4pvEpcuaDSiOHfmoDUwHTmxYr2n0RtrZVxc0F3P3NDHNpH1qvTkOkHmZCk/UxvzlLii8Np25CrU6HzTGQamxElzhJ4S9yFFw0ku1ZTkD6rsvamJ1WWAPPxImJdeUzCn311ZvfQYhEh7xZyhIytIMNsL4KgMzP17NIFXtZmk72RtGqCpqLkBN3lrpw5bMWZrl1uQlOieiQBuFHvFXXcSEGsUthnhqmasF5iODtQYT5VHaykB1xEeADbf40O2xN9BJYmaErq+vcfH8ccOrURS49XZBbRRpJe1AyGRMzmlQACzDSIwiTyc5ptR4mSM4PhBdv1iJe36tC6nq4laXJ1tHOqeUt/u81VHmlPOsdg85w/D67k8X2BlcMKMyBOLtUiRLX5zcASF6LFSiYi4+SxnpyzmaueBuzR8rOjSCLAEumjXf577OXCwV9C9hj6ppUof0dDL8pS6op2qzfMrYc4XlF8GD51EAmfD84Ekifm7M
 UzmQ4hlN
 LLyl1ono6M7gWaDQLBQA4MGM8JG/UBHd9G6QArfxmLcvfeiO4lLY9x/hKHKdWpgA/XhIyHAlRBquqN2GXnGhP+JRyd+psQXkRMLYm0rabSgmhVHNvzLZn7gk7JbaUiItQXIkUxVoJRMvZKG2oLmZg86A+Afr3pSYRt1aV5FixVGp/Be1GCd7n5hHSgqHgfnRLTdgRqUcGRmROS3d7XYUYyBhBgOnJCuD2kK6H+p/UeiiYgPUJbmmH5q/tXK0DwrOGMTxmLXLoz0qpiya/MofvxkAfHHUbzyys6ycC1Io4nBKWieJ1+tVRzBvyXLWmFcq5ORVxMb6sQwxdl8hU37hLZ4BjJuUBHSLfGqZjoxmGXY44E7CsC54UlN7dGI6LB6woYzrkyHoKhgOlDInHJqnAxujTzFUnnbYNA8FiYb14A9/9KBVWK3Kg8yFxIIBXpdA3QqhGjqYFKFzDPZ06K84hVCB9FH/OkZgBKVUtzyDULMlZgS+U8KH/NwXe0tKqiqIGhWkpAzX6XYnBIooBcjCGLWZKobK2LvPvWNue/hJNn7JT9lCeBf5B2sVFFs3/ZsjrRknvbqL/nh1Bv3j4P6mo61coUgobwZL37swIiFHcXwUcFfiHH91mfbhPRJAVEiPQSdUU+wvCy1Vs/qRfP3Don7R2b+36miaVdfcU4Cg5pIJJT8+QCPsbszokJZMxjL6Y57NcTop5w8lzAUpvylr22b0REtn4YgpVb1I045/uB4jM77It1r23fqJCXS2lv1xneEvj1UsjEo7oPjCi16hEeccKAtx226ZjS/cz67GrtacN9OCHV0ewWcxT0Dg7xnepwU5kVWfZtaw8NyAYFca5eBbT2XX/jP8DMVHLAOGH8OUxSloDQWCrAc/9NL32OEAvswXS1nubfFBA8SPoIqeIKG2vw/5bG/jk/wAnX/Wd6LcHzoM1wW1Fqtk/XYZxWHcFdsRhvav5OaUiahn23VnJXmA5J4k1
 UUiNw5rf
 TQVichrKvSgEuJUHBTlSeUicscY/D8WD5nrzjrlIUlflaSWiMwKYjCgygVQHCjD3DHVxUwEQE6OqdUw66UqokA+hwVb2ewcfddTazAsC5sGj2RJH4fkC83OGpQGWxELh57t4ImLfc7ZNqPwSQ8dJITe/+YyFbTS1jIFowxJZFMxJdFyf1DKCy11b7NWWIlIkonr8nLC2XizEnNJoZL6cu6qEa+RtbAKScXB/jQYD1HBTyvmQY9ktH85W/wvi6w07b62ZGpiiUFl2htaZEqSTjODwj40790F8dKqiHaext49n/WI3S4aXnqCgeLZc62uKHXTr65AHZZtSY8Q3rK2PhomVYYnka3wDtVHPrfsjWkve/G/vjgL95KmVD9SeraYAJTde5KqrS9Yk7QHyWctkP7gpPiNNglHEQqWOQpf8SRthVCF0IrginNQ3QxBRtPBVnFwQKK5Wc8IPTwkibXk9WypuW1Xxyjowi6GcXiVwKoIBcuwOQm8ylDJotYkyPgoygMF30h1So7xXTeFrUWMGW8vXduXtqys5RPoiWPrsvTNXP58z/Bathg8v+X1ky1gw+hJeC0jtcP+IMvlYXn7Qr9jdSHDeiX74Lh5av5/O5qfbNWRRit4wESVR5b+yaY2SmmFn2YBkRkL2ln3XzTbeKRWfdftotywdz1ehfzIQe3oGI0bIq3mF/VbSZBJeiQoLrAY44XxacTSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:17, Lorenzo Stoakes wrote:
> This function is operating on VMAs and rightly belongs in vma.c, where it
> can be subject to VMA userland testing and allows us to isolate it from the
> rest of mm.
> 
> The _install_special_mapping() function will remain in mmap.c as a wrapper,
> since this is used by architecture-specific code.
> 
> Doing so allows us to isolate more functions in vma.c for the same reasons.
> 
> This forms part of work to allow for tracking MAP_PRIVATE file-backed
> mappings by their anonymous virtual page offset, as doing so allows us to
> isolate and keep code that interacts with this together.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


