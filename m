Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A9AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629DD6B008C; Fri, 10 Jul 2026 16:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA0D6B00C3; Fri, 10 Jul 2026 16:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2826B00C5; Fri, 10 Jul 2026 16:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5836B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:27:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A49628FA87
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:27:36 +0000 (UTC)
X-FDA: 84974002512.19.26B8658
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EA7FB1A000C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:27:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JBGjC0JG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwHLf7niWPUb+EByGfZPa1IGezWCh6hKiz5/kPjeOK4=;
	b=8Bam0whXvSklo1QvKrwfouCkPEIJq2RL3Jb+V4p6YwXjwL15IBV+k6XjCWmYWneg208p2c
	J33dfB1cs5FKY864ThA6/Yfs8XODE20rt+1McZ12N4uazb7K9JS6aRdGxpL16TIXU1Lt7k
	mDD9YEsRhLsmDDuCI41NFokPAkxEfKA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JBGjC0JG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715254;
	b=VkKKznkhH1f96wdIdyuYGSz5uIF1BKZL1mBZsnJqgnfvFZgMFRl4Zz5VL/yOQjcWDk1Ivm
	A4jHXybm3jW5cReNg7PVuwrnuW7Ce/SX0Jyee/kKQycDZ+PYZXjoydWLDUTTEvbRKCX+PN
	yBAKoB3GdESAJpb0A7QJiVTvN1tMnzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 728AD60051;
	Fri, 10 Jul 2026 20:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534F11F000E9;
	Fri, 10 Jul 2026 20:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715254;
	bh=nwHLf7niWPUb+EByGfZPa1IGezWCh6hKiz5/kPjeOK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JBGjC0JG6taRh6W76fZOLNsjNinAKtLEZdyZf56hkpmD1SsPyspbJgP79fA97RNFu
	 rInXrcVoyDKxluHVIscUJlMQmCqhyn5vwU71G1ydzkj06R3KS8xqkqBGEHAwFFX5/0
	 oLU/CAkX/h1Gzz1GS/ZeKTBmtJF2fpl8ljFKwZRglGHj0rtfQ8ndwlo5G5KRsMycDE
	 nxh7CmmMG6beLYOuSIkOMMaLZ1yeaXbdG7b7alCjP4UkqQg8wtUK6yOWoFCJZKQTpC
	 o0a+qybijiTRUl268p65PJiHOM6drgF6XspLNQuwd7bBhft3/7HTnnjHqcGpREBH1/
	 t6TG2qcQpKTOw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:07 +0100
Subject: [PATCH v2 26/33] mm/vma: update vma_shrink() to not pass start,
 pgoff parameters
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-26-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4413; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0LxPiqBxAD9IhreoUXWjHFUoHlm6qZINpaBU8bU6qMA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg23LjgYW8Qj8SmXmjwgOjpPi2iF7zC5wcn+95fs7l
 iaOVf86SlkYxLgYZMUUWZ5/Ed8fJBI2r/OCvxvMHFYmkCEMXJwCMBFxP0aGV36b2hPsZB4I79HY
 so+HedmSLrH9my+69IdZeCZd5ouYx8iwVvT+y+n/804y/Dn3tjAuJ/T0sU1CtjziL09p1mW378z
 nAAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA7FB1A000C
X-Stat-Signature: obmqrosc6frydmckgqbxcyexqfzhpcpe
X-HE-Tag: 1783715254-779577
X-HE-Meta: U2FsdGVkX1/IGDhY/YaQp+YGWag7fC6VC26vwVqCtpKDmd/kveQnEVX9Fykga6vjpg+WEM73Z/GEMuRBiXogv0wjMxyjfY3bsQV42BEtOTEJW2p7J6As0qOyQuhNXpmUU5+Z8ciOA/RYkGDApn8TvCmoADlYJOeeXD/zhAWIXBOHLQFJE/1xkgfSLICVAak5SnNJ1v2a1r2ifeHCybPyZWfRm4Q3XCKiuAiBl+idQnnmhOoZ/bHzZr1OeFXF5oEUYVnP5xxEgn3cuFj+ugDyhLt5loP74K9ZcAufVclaCDyxUS3QN9nDsOF+g5rDQQrVo9mkG4H6OhsQeSxB1SLKL3ofOWftPDSINnb5m/RKx23kzD0tkl98cRCwiyX4mnoNtbyK+ICwO7DxYXNYlny35EkBazS9fjxShIAB2tQlQqagNW+lTw27KQKQR1YYfWKqlOTpHiYaGa14feC4bEwrC5qwq0c5VYoSWdtnSJ439VZCNgV/Gptxk3eG5BsQA/mHmVeR3/sjYCXMesTPTu4VaMjDfvcV0UdjvXqSwgEgkbsxYolaLRZZGywN9iYI6oksHKlDQKbUstpQSFfhaDBVx0ngAiGbzws5YBQ57NSrggtvNNlP2N/UA483X6Sz1ypP/lXOJttypWnh1QGBoL8OJoIhrBwXOa+kqTI2tROC8CkErPIQ8o4oPIqlzICmuanj3i6ylZE9yci9bHGvRX6p2r8HVXLjqJuraYFBXlgIJji5qgAbWOcsUFIFOOJkrXbDia0jhDC5bwg0BW/VcnKC8QzLYgVgMrt1hPe+68qiVc86FzYtNcnafZVIs3tO9BHUzvNRo7vzkTdWSuwcFd9ae+98JKfVDmWNMQvCzTyewkSxhWxDYbH1qRN8Rbo1Ft7u81Q7WVJN9vDGKYpmYi+HSiaKgo/Agtd+xOqTu65s4Hg5343N3YsF7dD5IQa4txCmlVliBKhKbA0Zn9bik7A
 2oUvwP8C
 LSQ3wKsM+kHOmWzQ5spJPD32GW/NTQF/cYNfNHAhiJv6ETpd2HQf/pxmhrnTKGlOpxu5Asd8ccqTsBinjdy/41Mmjn0JIDRzxbaYYCdEhCCDBjR85o4uf6H1NqZDacHyG+p3nxuOxxN8dFXGkCCTYy1lSO5z/TOi1gqnwAXXnpLvnGO8Dun6LYOYtc6jmWxacMvkb1Ax0hnBjtXHY07CibNOd3Rqy2xSAZDT88xkBU1GQxcW4z+gGQUc2K+7tNK2hgEmZSkwTbDY8zyYs7PwtqaBKGeBJGdR6AIljboRiHmGOEWit0yCoGYH6jYkRUWqIjD8+/uUTK/685SEJfryH7zDN2CseVhurp6Vzmi4EVbp6CMImBVuiFAsCjz6jQ72DgEq5KdPqda+hTS/aJPqPzxtt6Jc77fhau0qldE+SmdyabGAZGeN4v1NgugxPm+dFzyNL5NKVHEWoOfXsLG2VgpAIF9nIaxlaD7uDxrFL9zZvqI+LL4EK2Xq1X1XE6722/2ooIp7xbt4T3eprTxDQdISyYp5GXexlT6SwHepQ+JGwNawsUhcVLA4f6xt9f1vb8nJkfXMqu0SEsaiK58bHIdyKpQLyT6JATVY//9EwyBiIAs19+sWV9J6ElUARidrfSwMRWlVhHDuTauS0VYmNSSZ6J3w0YJcZfgTswi/QDPWfUUcGutZ4kTSI8yYhRENnb+GscrZKDMyenFMTCq1F332Xeua3PHAw/Yz2Ydu6Dyg0BsTk/BgfzUH/eOAzoBbK8gkeosIusJ1/gyedg5XMhxwEqG3w7CtKEv7svvb83ItyOJnoCsdaWmfsmdLPRNmTqzJXiOHcZ5tklJdMcgrVx+RYNoV+yJvi8PqN4Fy8kgOmqjRKD1nGGKxVPwXpA5K6kfbQbAFJDxSz65IaWYQ6UhOfE6f+x06A54j9qKncmR2Faz3FuuAaI1pYQMKz/ZdbsCanid+bDK3x/F1+80NBT0edaANJ
 iUsMwk67
 WoZXLTlEkULeyrdxRRsD4RcsOsjFli6sUYALdxo2iFTmNmvggVyehZYHFpbtrFATeqmhUwjaTw6OZgcvSziIxVpqFk/tCyP8lXNILx9rDgzBUeoGFfu30yH991+drgnQM9rnGSW/18aDdYqrhjk4emP2+fhwoNFzScqkvtblFsjxhY7w6R/rs68wQoLa+dGjAgNJELrU3lvRV5Xe0Z+v+LFCsMWO71/0hlUoAH1u29pcZx8lgIb/eYkEV2rc6IzCB9RH8x/T3HDfbUwS934NDUUz6hrQjEakOreBu/hlTRnRg2Y5sOA7lvckCv5TFIYeOy/NBgVX2KN/K7LzGv5xmS4czMSlMOTFHneBxSNmWq12DG/UZPYtrzFfv1Rza/pMME+7Onk+HG5v7rEkAD4+kyheAx6iBpZnJij+rjZoxzLvM6TKLS5mU58LCvGwqCyzREeULSGc2d4PMbbNgAw0xvGgQzCIDXsX4KuKZI6zb+T90AEL+zZGZRTxfg901ZoDq2LOX1ALuVmVSt/YvVGM+RoKKij6DZyc+R3hoWESJhRORKkyZr8nC93ia0Mu7tcoRn5Vo8Jbel9z5GbOuacWT5LTR4MjHll1kvj7d9Zl+HrilEM4UWIl4MoOdeu5EU5L/qFgKAIxRdQAE2luOD6dD5ilwJ9O+S8F4MoJZblkeLoSHbemOHvNtckMGyfzINCgL9jydWdl/XJ0e04Ekxw/aY27cIdFjtv4A4YfR6fdGEhySETUQZGVsqmFfoGOH/363uacWjHbptrh1KnpgXCOFlqHHXoK2Y+zkv/mwoFmMmi02Rrc0MBanJnZ9HFX7JvZm1ZkU1X4jHZL1XYTQXwVuFIx4cqFDJqBC8XlILQWVTBPSu0JKD7wO0V90+30piYzdJ7I9z265D6ngOXm16a93Rdwpz506ehu31Lvz2HgUz4kvkSygmJy88v89m0QFCcScy1Ydy4gFtWEQrF8vNFL935KjAOqz
 NZuQwC0P
 p7060C12JupCPSCGFcpxgpQmC9kTsmSYCcW5aPkVURGO3QOJ1K9mifUwloexhRkBOThJetQPbLEEGSHvt26/ar/9CU8NGESFRwrdcMGOQm0aIcsC31QQWdmfG+xR4sajgQdIuFmmXbO4YU17Q17fwu+uE+1fpTBqoHQ/wFl0pBSpGKoEPERrFEMbqGHXilPki88OfK8TIO5mEXt/tu7CrYTAMmF3PJPsH2mwNhJMmgbnjuM5V3KQIA0pUfzl1kMikTN4OQfyuLw6cm0hwh0IQogWt+vaOXj0IjoYxH5Co3ebtS+69LTQOXcLTmMggIk28K8XlmvXaAiiFs4f64sFmTTtE/e4lSbAqOkOyA9pCH/bqwK9f37bCNvOKz4yF9reI7UdP5hJUaAljQ1CbFb+h3n/KbNaC1nv4MQAKHw/c269nswwgo1MQecn7hKnCRObfG6dtbuneGOqVgnVzotgDzChC3GhB05J05TE0bcxGeSOBpALj7czt56QVMObCYdA1ixNuLwmU4doCNqcgyBj13w26ef7/2msVfvSCrOJ2gZaAeNUXTjKK89K/0ix6/0qZWA9DMP2WIsy45vrdwTTpQxU1AOoH/Z3YLPqUWm0yFvQHKWbhQ659KFe3Qn0YI2rxCQVufypazRI6ggsL+AEd2xLWExMPh1su+XzX3rNjT4JQDIhQ9j7DV+P3c7simtepvr2zIo8E5ZKdbIMzR7CjNFgP+XXvza74CTI2/LicXaKcH3s7NOei/r7+DXeD6FRoV83W35XhI2c1VPd8LEjhHDSkYc/nkSMCNKOu3vljq5OCiLwvQVL+iQ7dcvMdfYTdRVb29/1T1WuvnO2Zxxo69Igs/HoihGG3lsFPtrNGl/UZRUPiaoUsf+JdqzfjKw0qaCjcFUk0JJEZCbu1yVPYCgHSZHfvyZuwVmnfaWTiMoCGKH60RPSQ3TirlsczacTDxTW0eAJHMxS7huolXjnmDq88PvOM
 kKdTYFUP
 1/REUeAbgK+TApKCn5Br0sP3Sj+Naa2UrS3cBZ+RTXa/Z3qdlqYNsShlTWUxynbqC6+Kwi/Dw5/ky5myby+cmww0NC19eiTQEI+FXaeUiZr7Lv2I3sbNZ3TZwe2SdIfXd5Ysni8mqjqU8RQFbRPRb1griqz6ZgVZ32AIRGLT7em/00hzJMoNbaoRC0fCbAvEzLsKQb7JWuvunqT0iwQn0hsRyftQG7y9dBIEor3K1Owlc1wiCEhK7bKSuaLr+52D0bO393rtLhfsQ4Q2kfM+sMBeHjktrvNnQVIk4SvR0O4K8Dszg3NuV44C4OIrDXjuqw4JNXQoDcF3xvQXk931w2VCKfBaIu6f53zacM62R1R1jebnB/SPYBbpdZnauoPLr3Qnl4fzxSOuNZN//GfNnzAi42vtc5qsqy1uQnWt6nAaFvtnioh7dsCEAMvfu5j6Uda+e5ps6brlJyOc0irPtN4LyaZoR57/0+YLX6yobPwzKziZjF4ROV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_shrink() is only used by relocate_vma_down() to shrink the tail of a
VMA. Therefore neither the start nor the pgoff parameters make any sense.

It seemed we were passing the pgoff parameter solely to satisfy
vma_set_range()'s requirement for pgoff being specified.

Since vma_set_range() is now isolated to vma.c, we can simply introduce
__vma_set_range() which sets only vma->vm_[start, end], and invoke this
instead, removing start and pgoff from vma_shrink() altogether.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c                        | 31 +++++++++++++++++--------------
 mm/vma.h                        |  3 +--
 mm/vma_exec.c                   |  2 +-
 tools/testing/vma/tests/merge.c |  2 +-
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index cc0e449ad0be..a474920a25b3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -70,11 +70,17 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, pgoff_t pgoff)
+static void __vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end)
 {
 	vma->vm_start = start;
 	vma->vm_end = end;
+}
+
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	__vma_set_range(vma, start, end);
 	vma->vm_pgoff = pgoff;
 }
 
@@ -1279,27 +1285,24 @@ int vma_expand(struct vma_merge_struct *vmg)
 	return -ENOMEM;
 }
 
-/*
- * vma_shrink() - Reduce an existing VMAs memory area
+/**
+ * vma_shrink() - Shrink the end of a VMA
  * @vmi: The vma iterator
  * @vma: The VMA to modify
- * @start: The new start
  * @end: The new end
  *
+ * Note that the caller may only shrink the end of the VMA.
+ *
  * Returns: 0 on success, -ENOMEM otherwise
  */
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	       unsigned long start, unsigned long end, pgoff_t pgoff)
+	       unsigned long end)
 {
 	struct vma_prepare vp;
 
-	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
-
-	if (vma->vm_start < start)
-		vma_iter_config(vmi, vma->vm_start, start);
-	else
-		vma_iter_config(vmi, end, vma->vm_end);
+	VM_WARN_ON_ONCE(end > vma->vm_end);
 
+	vma_iter_config(vmi, end, vma->vm_end);
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
@@ -1307,10 +1310,10 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, start, end, NULL);
+	vma_adjust_trans_huge(vma, vma->vm_start, end, NULL);
 
 	vma_iter_clear(vmi);
-	vma_set_range(vma, start, end, pgoff);
+	__vma_set_range(vma, vma->vm_start, end);
 	vma_complete(&vp, vmi, vma->vm_mm);
 	validate_mm(vma->vm_mm);
 	return 0;
diff --git a/mm/vma.h b/mm/vma.h
index 14f026bf3be4..40effaa3ebe4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -297,8 +297,7 @@ void validate_mm(struct mm_struct *mm);
 
 __must_check int vma_expand(struct vma_merge_struct *vmg);
 __must_check int vma_shrink(struct vma_iterator *vmi,
-		struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, pgoff_t pgoff);
+		struct vm_area_struct *vma, unsigned long end);
 
 static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
 			struct vm_area_struct *vma, gfp_t gfp)
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index e3644a3042e2..13a05e041195 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -89,7 +89,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_start, new_end, vma_start_pgoff(vma));
+	return vma_shrink(&vmi, vma, new_end);
 }
 
 /*
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index f8666a755749..e357accc8499 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -227,7 +227,7 @@ static bool test_simple_shrink(void)
 
 	ASSERT_FALSE(attach_vma(&mm, vma));
 
-	ASSERT_FALSE(vma_shrink(&vmi, vma, 0, 0x1000, 0));
+	ASSERT_FALSE(vma_shrink(&vmi, vma, 0x1000));
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);

-- 
2.55.0


