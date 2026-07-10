Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D462C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6C86B00A9; Fri, 10 Jul 2026 16:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7567A6B00AB; Fri, 10 Jul 2026 16:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E8E6B00AC; Fri, 10 Jul 2026 16:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 338476B00A9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:22:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B944812057A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:22:35 +0000 (UTC)
X-FDA: 84973989870.10.2740A03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DD54E40007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:22:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmnlAT5w;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXMh/gI7Ejl6sQaq6pNCmizKlHMxVh3sNzK86kWl2h4=;
	b=lY+K8D4Iz18zrcmAnZMH2Qq1lO2/xuclrdSA3GA184c70vCFmoHhZTsZutr1JQGydcyPGV
	yRzyvJvYydtwJjL5e4kuVKaL06BRUJyUH7V+mL+vKzKBJpiKokEYx12SUl3H78m+/rjCED
	wS8Q5Jq87PHW8FiwW1Y6HED0CGi7t9c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmnlAT5w;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714954;
	b=WE0OYIRKr4LbwmeYAcHOJ/N+kkXGKKM9+3HHkJPdv9U6/xWPZcsEOcY9wk6osi+gFbJCXJ
	XJpd77vKshwSu8It+JPCemNhA6dOQ5EtRruznzhesIcX+RHQXNs8yiralEY0otXPwyNoDN
	8qPMQHrzD0k2eKgPI+ldXnr5wU6frBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C10D40229;
	Fri, 10 Jul 2026 20:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A311F00A3A;
	Fri, 10 Jul 2026 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714952;
	bh=pXMh/gI7Ejl6sQaq6pNCmizKlHMxVh3sNzK86kWl2h4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cmnlAT5wzlYt3brmt40tysj0J5B1gKaWPdvxMOyfuvulZ+5sH8m2RssNtYd7kJ9hM
	 3JEic/R7P0blm57mcQ0VabhZOtCOAB4dhCKn5vcEPWkjCnXEjOckc/MFsTHkCovBo4
	 dEg/4zgFADMecv/GyNsJqD96QSHp1WhhbtMbrSCjAIUGp0fIoob9V7aAjMbXb5Yjae
	 iBWFOm0BbeaaXFduRQLeC1gA41fycIKRojdC7cmdk7PU3JZWYDX4zaGQz3M2yYKf1w
	 SU3WfX6qJrW400SI9+5KSdVXY3Bp5Pl2jDAeKWzdIH9ZClW5J9NYnrxx0HvA7R6dwl
	 m3LRjk41KWVYQ==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:54 +0100
Subject: [PATCH v2 13/33] mm/vma: introduce and use vmg_pages(),
 vmg_[start, end]_pgoff()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-13-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
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
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
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
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3014; i=ljs@kernel.org;
 h=from:subject:message-id; bh=9w7HTwMbIR3XlC1PY7gTQx5p4l7ISN45M8ruExx6jwU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg61/Za29l6e37xfjD8NZsUc+LmZ86SXA+JLr6YcvJ
 poWjBckOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARbUmG/9VbDidYv8s915f2
 n5N9N+szsfC93vKXTXQ3b1lYeO7JPxtGhmm3bFJOBQZ+EvJqXVpxqdBDXn1u0dxHp0v5fk/fOXu
 jNCcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD54E40007
X-Stat-Signature: 3d9bddk3dcwwmuz1op35izmwc9c9omxc
X-HE-Tag: 1783714953-685108
X-HE-Meta: U2FsdGVkX18Dq5d0hLKqY9wqITwn7P7ztRZE7F4hFB5/Oc55OK5jafLPhliByDxmZzPugGqXKggZCTNphaZGXMs7wJVwf5kVc7fzj2KZ/GT8gPx+v2nhzyDOCmg/PxzTMn+jDySQhCN+UkM/PqExnD8LioJtWlnX7nobtyTNb8AyhArcJLS62KxnJUqeckOQNHfTzw1fDonQqK0z3yuatjdhSqSGM8Kr9VueD9vwshI2GyGBzSrCGBM7ul1sqI/VBZSjadte0QRxEi6CC2yp/gLP2/pdiah5t6eTwrj5REexfa59sb2jqsi0FRjSkP1MUmPpLkhu9oiM/D3TOFMwCmiOpDan6cdBNGmMuTDLBfY2MKXa6eAqtH+0l5iylUe2zF7oZlhZsOxjzpg0vaIGJ+B3JAiyNsTC3o+05Ildo2L7NuCGX+OzJff2fiSgkjYS2IoWJURdTrPCDqn89BA/dsCkTA3LEH13Fx4VUqwsGdiy49Bhbg0WD0xhNaEYBRJOrPPNB6aE7ALpYCqnMCAex6Cat8Qyz/dUJwKgoxD4kmaQXn1w/d0fdKj556kWB2AYezJSl0WlvQK4uJ7g1SmIpEY7pM3k0tQk0X6/8B1uAAOYIE5bt2X55SjYIs3oXoWVxg7vd7svIw7cmB28glQf21KduIvcAiH4ozk2nqhAyp2emwHvL069NdcaBeeFsLCFMb7SKslnTJtYGGJaveAcxvyezBJQoHVyzK0v4CXuhMCH8GguA1aFWG5GZLG3AJ0mRT87khGx3BcTDaJUUtjhonTNvBJEo6n39hxcR94JvcbJCsvwTpFk7BPGz8czN+gBQXiPnFTanr5QXQpLNHcvMrFmfiF3PQUlLRY3NAQg46oepio19fn6TsMBftiwODA4ouNtpxgKUVFKhWktMqdHlVHz6NodiNZAvgiPqm9oyn6uR4Mj0qrhZVg9xnVn4xeFAjoeUZdbJoyZBVdL7VF
 ZHhmAp+3
 4am9FPWHnte6qIoy/MC61E7sO+eL8L2Gql3DALaV3Lp2Jk6KezOBHaBfdrJkSvq0LSHUwF16U91y+hvJLYF2CqmoQf5rkOaXQ6/3x8twWTcio8zg46Ttw50wew4KZBgM4av60PL4u1JrOXLVb+o1CdZ2r40KCAHo1DYtZ6ZM7+2/NisuF/RPnHiYK3GSVchJ7Cb+EvtZ5Pg+fZ5B8ujkMfBZxbEtRDknTvGFDcrEfBfPd3cGrkfJ16zCzEcJ3Q4r8Q50K/VX2cwYNAbd4DXM9cVhMGOF4DsTtyDoqO9vQfqeAB2gOiqry3xZi8xybEFTi1WW6DlCoZSsxWyhJPtGsR/MgYq3BCYHSmvfXi/K2ZH73Hz6DIN/0KsO8hl2Nt7td8+Z6uGXAQCHh7iyyrSwQ6W9/kBKDDuiTGwx+EnoDsL/xKQB59QuWn9Y03ud76EGy2NeIgV4WsdwNQigqgfeisnOfkUteyxvcfrQs1QOFntrjsLY1a0uRLq83aVKqozyTwt5G1CUX6llZWHJX9RqpIgkz4hTlOH11WJToB5JITbPbsRNjiTkBlG/UoTMQSwv2QWFFB+ZAmHjRontlY+HYjLSyOywoB/ygIfpAb+h5C4mEWsRLfHueGh/e3uq2QAXx3cNtuvRl15PPIO/tTdk6NK7DURpUvjjklg7/9o50osdN0/XxwPBPtxgnicEW3arYP4q8tfRgpwnezJlB5HboIY9KELcgiEhp4Wx/G2FWAYgdHw43XeMmPQaEihpk9sknLx/MhgZFWvA9A7LB5Ic8NiTXzYx7H042oLLvHW31GQk+iJQ9duxBEUhj9wkrP3JmrTMzW2jSd0c51GGp4F6YlOW8IMt5C6hUmQLUG+aGQ8XFPE7biGQXAOPsMEThve8I9lBZmHx0zLphQ7pjp3tM9/FJMnBFP8P7v2mr63jrVw9bWU5HtO6bJnEWANHdEksboOnxCQc+JKIF2vvjhFY3xq47P+MP
 S89kxR2V
 hvj3Vys0zxCZfzcd9zZj4k0fVKflhcpdJoWdoQI0ZPEVjlcP0lgpaCDPVNBvLdoJyD7nddeUPl4rmMY+4cgwQ7IitRQ5VV8DfrVppgHzmvP2LBermMRdnC56j26YWF78a3Jzs+s+kVCw6JTjxs5VWEa8/3NMeO6sBkfchU+JrnKpyqYpNWfznXqw9siQVJIrChd7lurBEFCuNArdL9zv/ZURnByk6WSSNDXIc1fOQJAh2EG25lPnQK1rEZzYos7gfZ7jczCIptiYWwn9FQoYOiUdzhSj2+H5uB25CqI7VfInl+3te0oAAiS2r6y5nbC9PnWLozGsY6gVWS66Xq7oHtOw5/i6R0jqGnbKMJ6JvUHtGBCr1MfBRwV0HxjBYZ9gMeYQJRyoCQHLtX03xSqjS0UU599PbIELYfQTIQBJeIX6ZgBgWqRrNbsYSKExx6i3wU3lbPrKpa5OZQqg3BAXoRpvS17tKmCSjc1k8QvZBEtXMcTYwWArggwD9eGMWBS/wDGRptPI5S1L5P5Ue8U2TeDqEnCzivWICUgE2yvD7qr4aVH3ItYhWfGH0BxrFbN/YcTj3yYSUiuWVWIqUSJqekxonMKTJmOmRQgDbqZBRJ8tHJBOaAvDQJF/hcyKzWkUEmg73FcqeUxAB5qHHzF8iZMMBESPZWLIQ6Sx7C1u2iPA2LDHOT4ydhZT2F71tjgQBJ8PfbRCRgXPfUFHxvy4W51rfwpyoAEPp6VsTTGkgZSST/Cp6ZDHUo0R6KIxJkeDzZev+UR/eTLktSxKh0D64m/S/fhnGIEks6pVwdJ0DG5FisunIHLDvEF5/1Yax/It6UtoauALH5/kFCZW//9G2a7XtLCER8WDRHGpK5vUFRx6chEMoQS4Y77iNCocf9go6DLW6xOV8ysUWatFZeDtAuqmLgZXpvkpcDyGUcYTjnRtnu1uszA13ACABCkeGceTZLJtgTuCJ/wQTTrin6Q1BsvtWe4jE
 dKdkrVh6
 cmvdKiAY2nVHuetWiOAAJRbTkuT527GV4lo24C+ajt/WWOzFKGNC1oeQiAw4SZK4QslIJh/NGfqFBvBVgPW5yJ69h97ZsbFxYAWfgyvxMdoI0SPMhtJk4prYntPZONxUc8Vzv34wtFmFXWBlp3Zu3SWoNKyPb+MK8OS352tlryM+OUbo2etrntuoTggWR9MZBvikgJW4jBdciMZDwXQuTzZjk8DmhR5db/B86XW30rc/CdyGSQr0xCw9hJ7T9i6HWYpxS/D+0Ae5+Afsp16t7MdjS4ILAS5RYWbhfoTPHr58cz3CN/KuPoAoUNRbQ9rko68HBxrHK/AkhNCpwW6S9V4S7rXh1C4tBbGHPOVlf7Mrjva5A6PuqoY3CIdc5uaxOmKmDaKd4IjLPkhv9J9zqVcNGlk0KpCEcs7C4oPkI38TIy9/WT6EkVPvO5xLGmtueFoFOSmzjaTEfzx2c0J3Yb6J5jfVOW/n2WAXDhzfIWqKsN7Pgj9Pgy13BsJSPaFxz29yV/R9ycxvK57UQ+sFdYR1usFYoA2iYP8RBDkVC4RLwbrrHWY9rSTg48EYHytefqu+PMgGha4vJoGbgzTpy1OrkMGxAsMUH92GxYcER7XzAhmgwXeX1gWX2+ilp+yw+bO8PKbncjCywDbGqv5ypU0bDlD/pSTMJ77sl5i/VFSf+pj4sVxLVAf9pAhZml3UxL08zCFm7TKGA63dY/LpIp82oV7P/YSJQdIjDlT2aVy8TfY7VSPM2Oo60Vo5xa3k+cvIXmfFBJjr0epI4LWBYWGM+vlPMR56ioiOgsKVyrvFPRL73zhMd7Jufoy0oHI7lu1yqZ8aDQutgG600TCYWlAwAlkdNWtA8MJ5B14jjLR1v5O/69Q/qPbXJl7nZLta5U1+U1fvW2MdKr8m9dAaOpVuz2yP4VoLMOGtp8I83ddCLlS+h6c+mlr1wfhC8UcP7pAH17cgfbuGrnzEwqDqmFC/Hqp1k
 pFCigRrX
 Nk1wPTQeufISN2SflHl3FtdXmNPugkuUdS+QQchdXboYGCtEnMDW9NepuODi3/MqLixXZWHTlJn9j8WB+b3jlvEeBRaSbAvQmTKUpARkvJRQIRExS0UAqOiw420bxZKB/tgqlECW8rhp8ADUwdVYURU0fIFEjTKtgp+kp8pIapHibSB6bGpxo4k+klwLXx6kXEON6BVADhssx8py8q7wnulgtMR+RvelfdwyMzVKvtJspr1+w0NOvG0bSuaKI266IO6ts2piauvNs3Y9IQh8Oq8E05HGGyV4cq3hVshmHEiaFQZvN3cOzY4xfCn8P8DKhOwvtm+qR4vG5+0MebkDoqjN7WTCYh56ln6p33Kj9KbCEW8cEgxjjC+UcVD32JYW6hoZgeyKoeMfuHXeYStWok2MExI1P6rX5AAfvIYn6Tv56fCto03EEZ6UlZgPqCt5S9WgOu9lvHiANn+0LCqWiFfdQrKydg6xVSRCtOJLToH+a6qtmQAmEwG+uBDUvywzzsMrFdE6tCNlJiyfewzW+LrOEV2SnIhchMxUxOYnqHES33Vjp34gLQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the VMA logic we often need to determine the number of pages in the
specified merge range, as well as the start and end page offsets of that
range.

Introduce and use helpers for these purposes.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 11 ++++-------
 mm/vma.h | 17 +++++++++++++++++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 35ba3475128f..995de8198fbb 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -197,11 +197,9 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
  */
 static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 {
-	pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
-
 	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
 	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
-		if (vmg->next->vm_pgoff == vmg->pgoff + pglen)
+		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
 			return true;
 	}
 
@@ -221,7 +219,7 @@ static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 {
 	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
 	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
-		if (vmg->prev->vm_pgoff + vma_pages(vmg->prev) == vmg->pgoff)
+		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
 			return true;
 	}
 	return false;
@@ -759,7 +757,7 @@ static int commit_merge(struct vma_merge_struct *vmg)
 	 */
 	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
 			      vmg->__adjust_middle_start ? vmg->middle : NULL);
-	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
+	vma_set_range(vma, vmg->start, vmg->end, vmg_start_pgoff(vmg));
 	vmg_adjust_set_range(vmg);
 	vma_iter_store_overwrite(vmg->vmi, vmg->target);
 
@@ -962,8 +960,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		 *    middle     next
 		 * shrink/delete extend
 		 */
-
-		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
+		const pgoff_t pglen = vmg_pages(vmg);
 
 		VM_WARN_ON_VMG(!merge_right, vmg);
 		/* If we are offset into a VMA, then prev must be middle. */
diff --git a/mm/vma.h b/mm/vma.h
index 8e4b61a7304c..527716c8739d 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -230,6 +230,23 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
 }
 
+static inline pgoff_t vmg_start_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg->pgoff;
+}
+
+static inline pgoff_t vmg_pages(const struct vma_merge_struct *vmg)
+{
+	const unsigned long size = vmg->end - vmg->start;
+
+	return size >> PAGE_SHIFT;
+}
+
+static inline pgoff_t vmg_end_pgoff(const struct vma_merge_struct *vmg)
+{
+	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
+}
+
 /* Assumes addr >= vma->vm_start. */
 static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
 				       unsigned long addr)

-- 
2.55.0


