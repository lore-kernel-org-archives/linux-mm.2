Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25017C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15DFF6B0096; Fri, 10 Jul 2026 16:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E726B0098; Fri, 10 Jul 2026 16:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B266B0099; Fri, 10 Jul 2026 16:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CACD96B0096
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:19:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 621F61C3D86
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:19:30 +0000 (UTC)
X-FDA: 84973982100.02.F3F0968
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A16CB40004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:19:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pcf2+0VD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRLMqMtx0xVRr5vFgYMRw7ggTvxftRoyLyfFQKrqZ2w=;
	b=qFaoleeqN7Jp7QcG63qFENM0xPQevWpvXjXO/QgDImMTSOjaTMUL4SuDAO3LxQ/agUi8G8
	UW/bZycmk4/6BvbwMx3C66Ma9gAFE4IYHckipYdVMvNqOUJZAwmSORs4441yxO95wz5qWJ
	B3+iaF9FBP+mud+TU3duKqJP5QfyzB0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pcf2+0VD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714768;
	b=QBXM7/u4945Wc/BLB4Au9yW2jfuaEJ3g5XWYbBpj4kCn8azVOKiqUlzkDmTqc659sOvuTM
	nLWE1M5pV6v7KJ3gooTUCeUGLDvB7/L0bF9Pc7+lPkv8AwagcFamfcFimZCJpgWloTB/im
	FvHX479CnansnIvPFvd+i8NVBgSAKHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BD8E60051;
	Fri, 10 Jul 2026 20:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3FE1F00A3A;
	Fri, 10 Jul 2026 20:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714767;
	bh=VRLMqMtx0xVRr5vFgYMRw7ggTvxftRoyLyfFQKrqZ2w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pcf2+0VDkxZNuVa2Cy4lDGhsOB6+enWxg/0/q8e278R+fYuriXovlo2KoDVvNTmXN
	 g4JAhfAyf+/GqazKK2Uv8OXmUynTFSmHR6W6xBEN/66hOOQ9qHTpJNIKcHYkKzMTU2
	 QBJnnCrQ/o681samcU8yVgyk3flhOlPsMk6gdUy3Rdu+/qVKxUkFThaEAuSIX2nFCL
	 4Mdnn84yxyjDLlKeMe+A760I8tmgSy5XzTprH0bZq3boIH+4a4l8yyrMOJmOvYIcFe
	 pLrSEnpqwJ0ANXFpuT30ZIcg11rNlGJ8rauvY6XInvMseP5VWizouKSTmnJLUBPs+E
	 OnWQ3HqWG7HFA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:46 +0100
Subject: [PATCH v2 05/33] mm/rmap: update mm/interval_tree.c comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-5-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1996; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VZjvr3kZlkmGcsP4WgHgMF6CSbykEZdr5f8GmL5Gfpw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg60dcjZeOiBw1zBs0RQu5dke2c4lqtMnRbPMFH73b
 FeeybNPHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIdh8jw0RHC5MPwlHm7AG8
 P7fdMTQJu75b6FP4F0bRMOkHZ69P3svIsM3ac13q3wB972cqVhfOZL1e1ZD0+WSGa4qYHlvxE6W
 rvAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A16CB40004
X-Stat-Signature: r8u8rh9f34ik9gj7wdqjajqa7fb9fyko
X-Rspam-User: 
X-HE-Tag: 1783714768-195193
X-HE-Meta: U2FsdGVkX1/2A/OVJ/73g8143ejFWCt0F3pvLDew1V4LeOSTDTIPp9S+bt5xoOswWcT7f1NS6glNRZveXoIbVNsKufHEP0VfKTy314BF5kCHXZycEFj6ewEvASgefbG06FxyzydE2IbsgkAMTzi3DcbAR/QEvLqjqgnIPA5K47x4LRgslfAzssDv2MTk9iEIOrcyyYytMAAFm4O70uig05HqGuptIx4kG3At8sPylB0y5mq9pieOHjyRDGuxMEc4C7EmTSMSUNQzJOgVy+g49yGuOvWraGAWzV37/05Lhllan7hYwE924PlUyge3ZiWUASEN1a4kz0guVH9qUYXAVzIY+xcrPnP4UVoVDjQAlpDyRn5CJB/JyFlo/MCb/grjHK019qADpO9IkRb1rpYJ5hHIonPMtwlgdcOTOhQ9LM4F+EnhW55yTgRtd81CM0ISBiB7fOwwhK0POa1uPgnrpbFJkaLM79ME8qYbCNsFLE3IN/QgqPgCLNryWSZJWYI/7Hd8izYOoG4lnVqBZb9e7DGwDE5efnvtpUAwioVum9SrfCysdYpqU98wuDRTR7jlnQ0EWnFZ3TRvwjsQIQNRi3Ik5fu5YSacwVdNikgKEBR7BspChVtaS/zQNNe+cVD1aj9P5fBdt98WBdlhke6yPQfFXJX1aTNvB2dEhpvpp354a7uHDjUlM2RtFR0Pm2ETBTdCVX8m+AxUzMWAmLozx6Z0ieN7vmFm1pl1oGO/ndfB9i8Fte9Y5aip1m3m9rt2NJBTq3G2W3PbGhfHg7LbXz1BrRMhR6+j8005ysDw567e/fULGTNpTiojdKfUP5ri1AE5nk9g7gnWu4OJ2x3+JyVSmD4JT7ssP2GGfb1zsVjr8aYsnaZBUcedIDXculfDrcXMNyMyUa/s0Tz1huX/2pqcVMxbd3WWH9SBfM/qhxe38vF/aiN/NRPuBKE6BlxOOj+rwY5b//i8cm2q6oq
 /FDdOa+V
 iWTsbZYLU3CvBmVPDEYqyQYx1ofaHqR/2RpFsINPmqGITbSMKgJcRG6SJpc+SHkrpgHoUKnUUkLppyMK2xUU9s8140RNhS+FXTuPwpnNuqSmdCuZYIdhfwS2VO/mJkGpUDX+DTOj410wXGPZh+e8t88gC/No/4VtTLPR1HWlH2vMGtmNZDxQ97hDfd6n0FkD8G7q8raDrvwv4YZSq3siMUnsKDuc4op15+MUYRnigpvddW7k5bSn2DGTZfj2dtVlD+RnRhoRhd/VD6/LeQyUfV7tUIkyFSjfCj3cYdS2jkwqry4G/Ubh/2/kx1M+4bMkargDqEQrhxM/oFGxIr45QW0E3dJ9Q3H/yrQJYixkpLgUyt8ZbZ/WHcoRaLC55HpuPo/YWm+OD0k2PbLehGOVtOoT2TWS8mQWhLq7ffzRAoDEE1qUqbvNt4gAmJq/jnB/aAn63mUa6YwMk0MbsavFMQKT97j61jJx/VhJ7vdn0bgx6qynO/PpV7G32Jc/y0M1lenC4JhPACy6gambTt42V3Kcic3sJcpOfOzqaqMTk2+DC/eS626Nj/HXxU3ijp8MDoOxQY9BpfIuxP8dfHlvkBpAEN12QNqglKIMd1m9h7FulyqBvhLW3AotlQCShivYgUF8YK9J5Z+MJ02bPwEmd1K0UgWT4lU2u96eXRjWrw5Y89ptramV7lB2nUZbNkjGP97G64qZNcVaUmK26iucZNmMzAaC0fIZ6keE+WzIiUxpDolhevaTcZ6xX1cQCf9NUIm8qW619y7/h2uNLbSCpG2hIVY9W0hkGiBSeYzW2zU4MIhUDfuULQC8r0aNFJ1V9x1R8xpX57kCtUmMWE75Fla4UZLU/Th1ketIsoEabuc8BXriBtaNpHtaf4DDSL3pVVJiKM4FrYpOLWNAL4ouGspG67Egcdo5vI6rbwHPqc68+Ubt6ahL03ZGi3k8StXoIjxGs6cTzVu93mKyyWN3dKWoe45Ia
 /8c+Wi0B
 Sj1nQ53L1MZx3jnEp+t+vBQ7cwe4kJHC47aNATvrVWb5eyhYjnT78HwGLA5U9qFowDH8qQrUoQ02r/Upt/uw3cfVzcWAczcW5I6XtkF///G9OMXXY2eE7hYcA2HifK92VowKexiUQ0gsXVReZdS3gDkir4QZALlLfmdZ1f0XpUX9FUp99Mh1OHTY1tkDMDO/v+ALU2ouJeniZAToOvF3vnQBbGyitIjsQ2Qp32lZ0zu2Kc1lhPpM5XEruezq+BBm1f8WNgDjNy1bL6MYLhMala6RuB+0yXGrR/ONqzAdOhY1jmvbirLz5XxcDdPnoYBFJ/Qd+cYZgLrKzZu5JTCUqFjqCD3Jw27zVd347D04g3F/MpuaAoP5A2f4qjc3U+ymlbm+A+P3JnbC1QElufq+eZJfpSQyaDXmCvIuewUGg+udzNnAzKOV3mC0lqgvIA5Qrj96ap6SkJDR0GmsixTy3fGDMfxvHDrO5FFkpRvSgL7dASfWXUlDwoulp0A1nrXCQDUO1LQ2gh6PPrUU/lkOjexk7Ka2A10xN3KjbdxQ49VEfMdG/VPTuEnvuTZG4hwYlWBAUs/jZ0MhG4HGr+Gl+ZTxYyyE7zqM7PwxmHAHlTaVfoaeuoojE05glogrnwFq4CZY8L9XfHILcN6/IucHYcmCjWwg6iDq+/3jrSqK2NxUIw8YxV9tVLpdCRSDDbOgbIYNzs8jNEDtWUaQOPQ7XyI2y6Z/Cc7zjylwJ6bNinFjtMKdW2jYgg45/Jw98X49ZATqIer+L5V+WGwY/6wzqBN88PKtEvv2lMklcD3CS2U2xnf88UJaemUB/4LyE3Uk7Ip2GLfTZ0QT+kF0EDwFgUC0G4ZH21WMIct842WaG9EooQzZcEnZWsBC8XrjK9SWxi1RiBx25ebzkB4KdQMmnU56GZ0ztIKfiGyllRhtxitPtwea+H6t005v/FNlWg+2NpIBmklnR0qF2ZDC40PQeH/C18GNu
 i4zAn2cy
 goO/Cxv8M50ExFM45ICl/AxLrycgfOQFDwQNqxBv7EYcDx/eie87EWmAXqtFcKiQ/n5zCO1HiJ4KYK7zRJmOW/B5or4Q2UsgjzHUotf4aItqdL9kzFQgbUlnUbzSkEgMd8QsKW73pcIrkqs+DM1fLLUNDOV+MOb4ctvhI9m5LezehhsfYn8yEK97Jl1TpSeKbxgzzXuZfQbJDaAVqBM61c2zG0tXqziAJQG/CUrVtUVQeqRY0T9w7fNtLlXXXUPavT/XgHQyJs5CGwRjECXTmvYGM2uP7l/pugm18NzkcHWMQ86W3JNIMd7HO+VjvO8zFqPrrGYTFR4qdaTKWtm1tNhpse29n9mXzMLeTzVBZkaZJ5GVtj4Z2zvfRQxJbAeHorMnS379XmYwqSbZIZVHTsb9ZPXtV2sRjOtNFZe0lmNiB8kwq6H6E7OGOIa1VCDs14viPL0TybQbKW+cs9LXOHD+OGIBflYF6fT2WKadjWIkYr6juFKpKcpxUNbMrdYcxHhjORZZWCLODwwPb+Q03AQNH7DoUb0PRby9tyB+ccFFohhrQubXEnryGGIeVO9rexeHEASK8Dk5QSevC8d488Jl67bSkqBHU3Gh5rFx3G99zRcJ2mgyuzqPZJLaCVQl9cF+eRvwah3RU+QWGqw9wjRr6P9rQwdi6ra5ZLv6Z+3DoBER4dg0545fgJZtOnwJvVUZIT4DlEOA06KVjpaj9R6J7o2AWo51z0aFqO7DhTEIezA3aL9sjffDojDvFwhj11rJeQ/Wm8k08Z94FjCVMgtHsNmanPmj5iaa+XWtySg/rGvTSRXKsfAeKLodxNrQaAZnwXHJ5ZpsdXYYBgtUOeTfi/yMtqkoT+IHHwqKmBBk2KiatE2dnkwXcFL6DjJe8Q7zoKkrhJskztpwE6pTkukLcYJ3gV8UA6G8bnTP/h8rUlSXWQwpu8GMcH+f17v+GTIhMcXXSr3Jaiu0zJLCJJeTyOWZO
 Qh0h9MOT
 Ta2bBZD9LMzkHYO6MKwKyy+Jh+JzFR2hN4mvf11R2wEQcg6vqf1xnR0Vg8fmbvBrhVEdRb4gqXbPNmZzWPUc7hFVzUhdwiNIoKeEb95JTeWhhceTroVacXW7OVEOT8FrlDhJeYJpILafGJGXF3TbsWj8HDF5cMNncNxp7OC9pv5+572JLPnSfPKwfr7dhdiMtpD8kB1+kRfhe/FvmzniYU5Sc7Us0qswF9nGFTVDB1VGwaMSGSpY1T2y80GL7FeBGBqEbA2bvIewhGVWxTYzLZxyCQ15BkoSq16kwX+0zxSiz9qO1OYPBKHLg2X8rGSYzSDNYnrUC3YZosCAx/hIUo9A9yookuJdoImtfH9Nd5lsQ9ECcCiks3Wr8zX6XmHban61X42TqWwJXL2RcVYi9hvl6Uzk3y8B8PqpMqfK9DC6CoR8MnUdGCjEPZfnojNSSU+q9Kf+zn8ppSY0tmBeFQlTYGSjLEjvBw71jkPVftYcpwh+wHLYZb/mdgmU5Nereb9Up9GAgQ/Kz4pC612bsLT0NLVYw5DNvpa+00Io+i3WHXcGZue6p7qzmHAK3qjF/ghKi4ZmHR4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the file comment to clarify that both file-backed and anonymous
interval trees are provided, referencing the relevant data types for
clarity.

Also add comments to indicate which parts of the file apply to each.

While we're here, convert the VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA().

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/interval_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 344d1f5946c7..2d50bc6228c4 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mm/interval_tree.c - interval tree for mapping->i_mmap
+ * mm/interval_tree.c - interval tree for address_space->i_mmap and
+ * anon_vma->rb_root
  *
  * Copyright (C) 2012, Michel Lespinasse <walken@google.com>
  */
@@ -10,6 +11,8 @@
 #include <linux/rmap.h>
 #include <linux/interval_tree_generic.h>
 
+/* File-backed interval tree (address_space->i_mmap) */
+
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
@@ -23,7 +26,7 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 	struct vm_area_struct *parent;
 	unsigned long last = vma_last_pgoff(node);
 
-	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
+	VM_WARN_ON_ONCE_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
 
 	if (!prev->shared.rb.rb_right) {
 		parent = prev;
@@ -48,6 +51,8 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 			    &vma_interval_tree_augment);
 }
 
+/* Anonymous interval tree (anon_vma->rb_root) */
+
 static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);

-- 
2.55.0


