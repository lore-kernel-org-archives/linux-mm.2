Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343F9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9346B0005; Fri, 10 Jul 2026 16:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43346B0088; Fri, 10 Jul 2026 16:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC2E6B008A; Fri, 10 Jul 2026 16:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCFD6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:17:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAC9C140581
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:17:35 +0000 (UTC)
X-FDA: 84973977270.19.78552D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id F065E80005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:17:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWDb4DQ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JQW6B9yq7rR/bwTqnS+r6OlWEUSb89pRH27/Ug8BeOA=;
	b=3lJ6/eJmbkTyo+I9D1/kmXI4mTH0zTCdekjpUilC2XrPMQh7geSdmfDq1pRRLunqinAfir
	bIBJe9/1oa1kH2xyTS8uzqRJf6j9qRzqiDGSzPJCw/Fk1ZCFd7Z3k8WOLZAllH9qcuxx4A
	jxFOh/6WqUxrELvISgkxpTMQw3+AkdM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWDb4DQ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714654;
	b=VkZPuQxdWmfdG2eZL6i4+PPnDyTITX+iWqfnogpsxy/7ulaBgJWkySNwLX6vmF2WRVAc6a
	tHSaiFhkOHDJbkXrJk7+FBmiNew8J33hLpjPAPvQkFEuAP629IsEpAvmSDMtlZpAW37KlE
	w1mgY5Dq6U/Hq2CiEoDlV4JYZ0VZ/AQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96F3E4156D;
	Fri, 10 Jul 2026 20:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3C61F000E9;
	Fri, 10 Jul 2026 20:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714652;
	bh=JQW6B9yq7rR/bwTqnS+r6OlWEUSb89pRH27/Ug8BeOA=;
	h=From:Subject:Date:To:Cc;
	b=NWDb4DQ7MUeqgbRNqZUG7DgijSzbV62Fy1N9G8AUIWmqoFkWkyON/u0JGsQA6RGjE
	 DAv/3eHtjQ9eNnO8S1+kjMzw2Xjd8DO/bkHNd8Lo57BOpOtPnRi3Y9gtg116qG/JUG
	 AlUXR4P5IcAASHCG2tr0N4tZ1xgE6r8I4/VXRO+fnTBvj9tnCj7W/WVvsbHyoNCMYa
	 KsutgjQ+wLupOjdkccJlxWzHu+dn39dkLU6XNEXXY8uUnf5bRPcP2a1AXJcM3PRL3y
	 aW0ObkfHc/TGiZw/HW2cRlPATx2khiqfRhAlfGNWmcYwHzSAIU339YX9gaXhm9IYJo
	 G+I52oYLhc95w==
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH v2 00/33] mm: make VMA page offset handling more consistent
Date: Fri, 10 Jul 2026 21:16:41 +0100
Message-Id: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAClTUWoC/yWNQQ6CMBBFr0JmbZu2gKgr72FYQBmh2LRmBlFDu
 LsFly95//0FGMkhwyVbgHB27GJIYA4Z2KEJPQrXJQajzFFVWom2EE9CwbbxTetR2PgWpsjVWem
 yQywgLZNwd5+9eqv/zK92RDttqc0YHE+RvvvtrDcPbJyRpK5OpspLrZXs3ST9yNcHUkAvI/VQr
 +v6A3HXvTCzAAAA
X-Change-ID: 20260710-b4-pre-scalable-cow-24309015dee4
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
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>, 
 Ackerley Tng <ackerleytng@google.com>, Kai Huang <kai.huang@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=15609; i=ljs@kernel.org;
 h=from:subject:message-id; bh=C4Yu71lac8pIy3vdGuBGIphs0YWMA1+aDi3eZhDjMUE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg80tWR4+9zuUYB0pFfzLvnj1kgvesn57DAzNOTPrk
 0OOXpncUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIn8vMzwz8KS18Nb49yDM1Hr
 O6fonH4i8/hpm8b86w/Fri4TD3v8bBfDH561m94eXr1k9uwtrU41fT1yb2w3ynduXn5tyQZHucT
 73GwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F065E80005
X-Stat-Signature: w1ykg37ht1ti5zmcd73rr9rnq9htw1jq
X-Rspam-User: 
X-HE-Tag: 1783714653-691647
X-HE-Meta: U2FsdGVkX18i8DLP58GAK4KN4WZmE28XcIdQNPBidSwnftc6xE1h9wAOdo8hsNWCpQZ0Zxq4xF1ttkLtROAnWfJFnMEMGzqcbqpz3HnOuVVIIt4ZRBfURfNkCX+lpQkFv5xIBT0+mCJ91vZxGBSK+StU95LNN+iDuKK2QVz7wjyNEJL65m81YsYIS1z5/2F4kPAA2ZkylIjVGwYR3MZY8QcFVux51h0icSP5+Gs8s/pCq2ycJSyHy/os3drh1AD3p61ju7htYuGqmFjmFsf16zmVCb4QmyOtHvPxIbjza9M5iVHKWKlk2PeFg7N+f4ZqHdfUbYGffKQuFY82K2zcPbcyGpHA/NpHeYZqk9mI5UZwYriI1rXtN2mEimgN3Rgpjuv5XQbKfsLbkSS0czGi01n9whDnx5cdwsbYtpj87LQ8NiNSMM9DzHnF9bqKPih1jicfYsEe0ZHIZWJ58d4XpNMKaYEVJnoIk7CfyhwEvuDZBFBaQjY1gJUFQnvrqVQYRI609T4059jmyyAPXGjPs3QklnDS0E/JGKPcdZgDhnkZbtmLlvNmVRCynY+e8BZc4KaSaFsuo+5YRIal60zjnDanu46nXW7Z/4O8w5izJq0S5sgU5zG7nqtP4btUUX3I726ceDiObNGzGcBW1LC1wpE9FLYKU/vh8ImvKjS30f3fWzozeyjVKGSQ6AWVgwbAH7nP2Manqlk7E552/vvo7aZYi0nzRmxNUapMKK8jFr4jwSEaJK/eNkoKZSQ5DMXWsMj17jCkU/p8D5ELvAPJmnWdpRCFLl/iJ/AyQ9Ts25GL7hUNZ4BPgSAb1xWrRH+codRxUfqu2ZvikCQE0XWKCIxx51G8PxfIhKKEApOvzwt+NT9I38T25IbqU7WZYwDaah1Lwv0bgcITjDCoH2baJIAx1e8urovhctCLFrgPYvx1f/MGX6b+i2skMGILuUMGYuqXqQGwIuI5THrgEzN
 k4H9gscw
 cQ8BkluuAn8DE7k/qZ/0M4YMKnXzs4/d6GNFPbpL3XYVrxRf56VMEZIMmvb9uc7UqYNldUDkoUGL11aEXi7eYe8hHpWiD2vizMu1JdGTJNzPDI+fP5h1bL901T4u2JIYWlD4w7xLlJ9y29oCgBmTrPYEq6FilduH3ddTDva5NUWseo9lgCXu86tWXAHuLcfI9EDCSUKlvdPwLvHmJpabVboVvXKI2RiSj3lHQLv3pE8+Fm9DFz1mg53u0EtjITFpy5QgaplfRFNgL2iX9bhQhNKzQ6U+RerNoAZYoYXkGEO6LZNXzvHAom8Bs5JKqoaXgooNfO2ETr+H1wEAUlsn3iF42/yl8KFxumysYxTr3+7KfwJYdFRGJBGSHtf0rpqJyS/uh8imEmfGp3VyWU/fv95+U0Nd38QO5hlVjF7aJ900rVaCmb5MbtW5+DGEkghRa0XwXjjyqLCMqPOqUqbVlc/gZ1y7Ya48vYKc4C3CksOj6UO/PCbcREHuIZP4FdKz5BPkTFubP31ztD0JHJXZoMWYf6COKXPes1JP63Y3wLg0NlNeCdzHtygQOCoomcORlZFzJGI5FYrl2MI4ZZG+2LpHHvZSlwY33dXsHAExZfgtsRfFIaHnUDrtWcOCHmqd6iKfnamLDJkokmskijA5lUQahg/9+FoRWKNBXC8YA//5zsabycYwg1dJ9tJ3xk7dfaCkxM5BEHxZTEsMmfGqEuprofBdv5S25loyme+NjpBBiribRN4COBunh//8dsYGzfCfEhynR9MGI5F/HGE87HulXzLd1GyS17n7PUB6W87hKSywLS4lbuty0DdRFLGBEBp8U1xSvffA8wzg3COygDvNpQESX3tSgLN7cvF8jGcHMxmMLaiyg/DfF3YJwvYIYZXB2RZW4j69a07CUvYfUV+dyoWb/cWw5yn3mAC+/4h1HwG/X62CUeg4geA76nLoCpW9SJp4BDMqwItvODpUg4bbd/PtW
 9KtULQwF
 uxxEGdfUVZtveqgrtN4aLeqSxhrslNvw0uRZ82+ICLjh83IqnnVZY0txzs+muKRVGzRksY55qr+osWwlXXTsJnCIhmq6Iba4M8nFdXzvWHpGDiDyqHQlgx3RT2rsOKMr89tsyO07x2QZ3QEn1fdepVXtsZR+ALn9hfAyQT4MOOy0trBl7Y4Pa4oaQjY/iJvcmYvUA9VNPA8nTuNWZtD3xDodcnUAcxZ0vLtKI6/ihACTyyHKRGFYDjisSHdoP5scjijF19gv50sE3twnGfk7cZmksNqz+k/YAZqGoxHSIMCRUWbVLNm5J577Wh+HQ4UnYq40dX2aFxOWeVUywJnYoMYHfRs6vCaPEp9zZGzB/9EK/zDMo0s5UQEBPd0IoOGxJe6KkYGSvtk2kz9w6TQ0MjbBEOxkwWBgRtHF4v9S+cUvyHxqgXktZM88lNCA7TkTuD+M01cgIG4ow6h+FPnMACodNftxYVMGaYglAVc8drXwuHj1NPbiBc81SmIyI3qLucCdEylQVoph4qeDnND67QRLFbJ1G/1iotb4hCngcBB1UWK42ovOPokcJmYn3JzLpwZ+CQNw6bfO8PKuFWebFmFfKVbTOUCzIgYR4k4StF2gs+mzhjJ3fqqxOQCVlFM3zB+QqPmWdTZCohYYwwCcK6JNhqEjhswwG6azDvVLEXUGyoZZX7jtTcOv/jwyrx7xMfYxOpA54x4AvuiNIDaZBzACQTihFQMHmHXG7D+DmPNabQOQXNf1qpvhdoJ3/k/0Ln5/5+uwK7XXYqj++9cPv+7FLVDOAFuCQWPvuTWmhtBTmkirLHOUZkE7nIWNfulRrBTtDHVus+boVMJSu8ueM+K8EOaR26G6COGau+DUQ6eMBrcKeiKCixGjCu0Rza1Ds55Xs1C/NTSm0Vh2n/Re/S59atmZjlAhIYe35QDYum9TsIA+yJZB0Ghrlsz6suoiBIg7yj2pjfsavj42/NGp48nMiniJ6
 Q63HIa6S
 OE/SScQ8kgMaSUn0xP5W8i3H494KS+/taL3E5slsgTtvAPha+fJUJXJ/5S+Su0PqkHwUm45w9JSCEzZhAsFzGVVOQjDCY2bqFUZMta87LiOXWNbPURvmQlxN8SO85nDDNngZ2aYytrlBD8yoRfNCcKfD4h1NcG7mVNuW4Q8KjEND22INA9QXyvjto4juuw06Zg7HJb++lAR4b36cA/o04hilPxYPyF+oFtzJbw9IWiQH+0Wdjm2+4wCymrjOmDn+KfyNrqIpxt7vh8Q8ol7S1elIrt8zHaHlE/kKnLRtHKAdG5h92lKoa0wExsDSaekYiwBewlQh+kgrbekUZr4lv6chOh/TWAOI2T5h9f+hKBaxCWuu4EVHq1CPT48Tee6kt35rjHT8rrqbgbPbK86VVv9xGHcOdbr4I39K7D6zQI1NbLOO6fsKrAZ0G4nZmA4o7YGBPbLa65v7u86/9ZfczMIPvTuOt0mysPyjytafFa/24qXVQlw35POY9t02AMA60E3FBfvuqgKy2UrXQiylv2NmBikcNqJBwCY8ddSV+rja/W/Hnmb4gyONSMiEdNDROZlOgN81fF2WePIxjd7FroEid9UlrSKDsSTFKtCUpp2j1KY95ffpKz/3FFxsC1F1iNKS0CGPjauwcj24qOaKsCMNghCU/uLvqPqeCTKKdKri6HHwp0SXJAakXsCW8nFCQ4+53QRmmGj2f/WWw90IqmZNXIaj5bp/q/ojiHaLx5NvgNwGPuoJkeUu2CHBdeJHUCtEcdACKBFq5wgV8NbQSsq779YwHaRGEGoNSj+ip15yUO7OZERkSsx5gopGGVe9uJz8W7lZiS3Qjqma0jHxdBT2h//WFoIft/dbGfFOq4GE6JN98X5bfHj+z1USqtLjvj2VkjO8VLB97HZjtYWx5Zc29XRYFt6UexPJnzvJnJqo1f4fgA+vq1rYjc4Z0Y3TuxO1Ki/nPtqwJhIX/cU/wJSg7QLt/
 bT8cUtaE
 oMrpaMPGgfbVP0l7TzllK4QZlCnmdEfBqOaMSmiSmgcIgipbmUXEDRG6e6dWoidrruWf2Bj/QOeB9vyk7B/LKAYR0gIbvNSvsizInynROWzL4H37H/bpj+jV/FVNBGLmOjRY4BQ8TzEdtMHq9/BRnGZiqNP4Gid35RLo3T/pXd13tz+Q5LAg3a5as+qQkXT2s6Y9TbJqGE8E2ovLdWhaUeaCP7JhLyMWK9ZciB0SULBtMxSEi5gbU0HHDczMnVRFmQgoh6LaRC131Wx7hX57nHXwG9aLoDSxA1yQZUBztmUo3YA1M6JLuNx/AG9Bi9XK8ykVjOe+4hNTI0XpYI2eMCSM9ey8wAzWYZW89wNBTVRnORrdLpVLhJqWIezZHSWswFL6IvuJnduCaCF4zhxQui8l+ZS6SmN0n+Kt8u8GYHUmKaFHMHLDZ9j6xP1+i2+FAOkLq0FBtukKU7sVVypieRnqXttHFSxHprskQU8uJLzWt0TWIl+KgFp+z/vW5y3ESbSwhWXW9DmDUkgBS7Ss4l0sIm9BT6xeTsG4L2QrM1kEqzXnSCy5PeQ7/6ZoBjNabcRWZbWjUUnc//wGx3xPmj5E8yiXkjUu080SrOE0p6o5HIMtH5cpj7SJxFa/t7P5O8mzpAphFJE9H+eLMyk8gqD9BRG+bCg3RZVAHxu3ncVm3vSQc7iD4/LfoAjf+Gg6odXkUrgPW0kyp1aQivc1C/b908/GuPKoWlNE875ez9ZHAKxBJVIbywWNwrny4+7iid+sBulN7037KrjN/3FHTX9r+UonYY487cMnQeVLmYIW5UXU1wCfT1KQG6Z4SXRh+O9hTEYH1PTVK7it2f5fIQxxpbj2AKzvCgkzJ8H0lPWbKewjpwg4i7wH347PMhiPQ/QOilnhQgSMz1kps2pdb4nTeDVBdDkEqThIwvDYNK/9Ajysg8dKjzG5LIyq4Mti6cdDb9PpHIYwySnQ27mI89B5N9Xo7
 klthMbUq
 nIIDwWwUpYtGVP+IO1CnwfDEsv8P0iHRI09mKnh2iiKtGRPOf+wIZey05O3dwxwkDQ9XUKHSnvLa51be5hcy8MDaHLAf71f31onVsb47siU4av4YTMhXMeonJf9vMhTrvqYogvpuiXhde3cnFxGwM7R50FAteQ2szX44RCSku1MzWJ8+sZ/rMQtOJSuY0+AwaqsAfmENtzL6otc03v62zNEpZc7tc6iN/Nt2VZQdVDJuviI8+7krCigDS+UobsRstfNYtTdAY1w+IrYEOhjZoCzefw4aNEX7gr6bzIHih7DR9PY7l25HFXolqHg7bAadbPaOgO5t0RybixqFN7DgsyJPARbolJAfjGEX9AULb26sl5/V8IPGGqGvmeKdJH91+ZDbBOlqBnbqRC7IM+Xms0qnICO/KzvldXz1y02QoGcI2pG6uRwXftkqTFxVyyzjqx35YTPhR8I6VWqbfLoxu2WezT5oHTg6b5vPZKbpsra/inRARn+OsOT6UsTpajEYT5Mt7zzw1ClArCw6z0FBe//jC7twny2KJQ3Rwd62AymFCdYr2cuPubjP2rXavdGC0UidSgknz5EHhLe4pBiTXVuSLJGT0gleWbLsdSobDpifgRPBVQO5J5VjijgWBZO3QjheAl8YUKEPrmZZEUxd2G9XbHYyXWuQyN8by7JuB6s9ZghozkzZ8DvKqOgt0yrHbhoNJ4h3ffHUxhdDOx1ivwmiDal7F3JjsWM7UAeja1a9rdsNAeFGxlV80U03Mm+pVF367EfjDuLc4LV6srkRglmSFukq4RZWsErQaCiGreMiAMST7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series performs a series of cleanups and improvements around how the
vma->vm_pgoff field is used.

Folios belonging to file-backed mappings are simply indexed by the page
offset within the file they map (excepting pfnmap and driver mappings which
sometimes do things different).

However, anonymous folios belonging to pure anonymous mappings are indexed
by their "virtual" page offset, which is equal to addr >> PAGE_SHIFT at the
time at which the VMA was first faulted in.

The page offset of a VMA is stored in vma->vm_pgoff and indicates the page
offset of the start of the VMA range, whether it be file-backed or
anonymous.

The work here both cleans up how we reference this field, as well as laying
the foundations for a future series which addresses the inconsistency of
CoW'd folios in MAP_PRIVATE-file backed mappings, which are indexed as if
they were file-backed but behave as if they were anonymous.

This future series will make it such that all anonymous folios are indexed
by virtual page offset whether belonging to VMAs who satisfy
vma_is_anonymous() or MAP_PRIVATE-mapped file-backed mappings.

This series:

* Exposes vma_start_pgoff() and updates the kernel to use it consistently.
* Adds and uses the useful vma_end_pgoff() helper.
* Parameterises the file-backed mapping helpers vma_interval_tree_*()
  by address_space rather than rb_root_cached.
* Renames: the misleadingly-named vma_interval_tree_*() helpers to
  mapping_rmap_tree_*() to be consistent with the renamed
  anon_rmap_tree_*().
* Parameterises anon_rmap_tree_*() by anon_vma.
* Moves mm/interval_tree.c to the rmap section.
* Adds vmg_*() helpers for page offset.
* Clarifies the confusing vmg_adjust_set_range() function.
* Introduces linear_page_delta() to provide relative pgoff within a VMA.
* Replaces open-coded versions of linear_page_delta() and
  linear_page_index() with invocations of these functions.
* Introduces and uses vma_assert_can_modify() to account for whether a VMA
  can be modified (detached or write locked).
* Adds and uses vma_[add,sub]_pgoff() to adjust VMA page offset.
* Moves __install_special_mapping() to vma.c.
* Makes vma_set_range() static and internal to vma.c.
* Introduces and makes use of vma_set_pgoff().
* Fixes incorrect vma.h header inclusion.
* Defaults VMA userland tests to 64-bit vma flags size.
* Updates VMA userland tests to give better output on failure.
* Various smaller cleanups.
* Updated the vma_set_pgoff() assert to account for MAP_PRIVATE /dev/zero
  correctly.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
v2:
* Rebased on mm-unstable.
* Updated tags (thanks to everyone and b4 trailers -F -u! ;)
* Updated 1/30 to include the vma_start_pgoff() helper in VMA userland tests,
  which was previously causing a bisection hazard on the VMA userland tests.
* Updated 2/30 to reference the pfnmap vma->vm_pgoff PFN abomination as per
  David.
* Updated 4/30 to include vma_end_pgoff() helper in VMA userland tests at the
  appropriate point.
* Updated 8/30 from mapping_interval_tree_*() to mapping_rmap_tree_*() and add
  commit to rename anon_vma_interval-tree_*() to anon_rmap_tree_*()  as per
  Pedro.
* Fixed issue in 8/30 where the internal helpers were still called
  __vma_interval_tree_*() rather than __mapping_rmap_tree_*().
* Updated 9/30 to separate out the rename and change of parameter type for
  clarity as per Gregory.
* Updated 17/30 to put perf_mmap_aux() variables in reverse Christmas tree order
  as per Pedro.
* Updated 19/30 to remove incorrectly placed vma_start_pgoff() invocation as per
  Thomas/Gregory.
* Updated 20/30, 21/30 to put the vma_assert_can_modify() VMA userland test stub
  in the right place as per Pedro.
* Confined the vma_set_pgoff() assert to CONFIG_MMU, as the ever helpful
  nommu of course violates all assumptions in this regard.
* Fixed issue in improved ASSERT_[TRUE, FALSE, EQ, NE] test runners with
  re-evaluation of input expressions.
* Updated the vma_start_pgoff() comment further to discuss the MAP_PRIVATE
  /dev/zero edge case.
* Update the vma_set_pgoff() assert to handle the mmap_region() newly
  established file mapping case.
* Updated the linear_page_index() comment to explicitly defer to
  vma_start_pgoff() to avoid duplicate information and future bitrot.
* Updated vma_shrink() to no longer accept the useless start parameter, as
  it is invoked from relocate_vma_down() only, which has already expanded
  the VMA to cover the range [new_start, old_end) thus always shrinks the
  tail.
* Moved sanity checks from vma_set_pgoff() to new helper
  assert_sane_pgoff() and documented it clearly.
* Fixed issue with nascent file-backed VMAs hitting vma_set_pgoff() assert
  by checking for vma_is_anonymous().
* Moved vma_set_anonymous() earlier so vma_set_pgoff() works with nascent
  anonymous VMAs.
* Updated the VMA userland tests so CONFIG_MMU, CONFIG_PER_VMA_LOCK work
  with IS_ENABLED().

v1:
https://patch.msgid.link/cover.1782735110.git.ljs@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Rik van Riel <riel@surriel.com>
To: Harry Yoo <harry@kernel.org>
To: Jann Horn <jannh@google.com>
To: Lance Yang <lance.yang@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>
To: Russell King <linux@armlinux.org.uk>
To: Dinh Nguyen <dinguyen@kernel.org>
To: Simon Schuster <schuster.simon@siemens-energy.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Dan Williams <djbw@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Jiri Olsa <jolsa@kernel.org>
To: Ian Rogers <irogers@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
To: James Clark <james.clark@linaro.org>
To: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Nico Pache <npache@redhat.com>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Barry Song <baohua@kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Xu Xin <xu.xin16@zte.com.cn>
To: Chengming Zhou <chengming.zhou@linux.dev>
To: SJ Park <sj@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
To: Byungchul Park <byungchul@sk.com>
To: Gregory Price <gourry@gourry.net>
To: Ying Huang <ying.huang@linux.alibaba.com>
To: Alistair Popple <apopple@nvidia.com>
To: Hugh Dickins <hughd@google.com>
To: Peter Xu <peterx@redhat.com>
To: Kees Cook <kees@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
To: Robin Murphy <robin.murphy@arm.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
To: Alexander Potapenko <glider@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: Thomas Gleixner <tglx@kernel.org>
To: Borislav Petkov <bp@alien8.de>
To: x86@kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
To: Ian Abbott <abbotti@mev.co.uk>
To: H Hartley Sweeten <hsweeten@visionengravers.com>
To: Lucas Stach <l.stach@pengutronix.de>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
To: David Airlie <airlied@gmail.com>
To: Simona Vetter <simona@ffwll.ch>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
To: Maxime Ripard <mripard@kernel.org>
To: Thomas Zimmermann <tzimmermann@suse.de>
To: Rob Clark <robin.clark@oss.qualcomm.com>
To: Dmitry Baryshkov <lumag@kernel.org>
To: Abhinav Kumar <abhinav.kumar@linux.dev>
To: Jessica Zhang <jesszhan0024@gmail.com>
To: Sean Paul <sean@poorly.run>
To: Marijn Suijten <marijn.suijten@somainline.org>
To: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
To: Thierry Reding <thierry.reding@kernel.org>
To: Mikko Perttunen <mperttunen@nvidia.com>
To: Jonathan Hunter <jonathanh@nvidia.com>
To: Christian Koenig <christian.koenig@amd.com>
To: Huang Rui <ray.huang@amd.com>
To: Matthew Auld <matthew.auld@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
To: Yishai Hadas <yishaih@nvidia.com>
To: Shameer Kolothum <skolothumtho@nvidia.com>
To: Kevin Tian <kevin.tian@intel.com>
To: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex@shazbot.org>
To: Paolo Bonzini <pbonzini@redhat.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: ljs@kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Cc: linux-perf-users@vger.kernel.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: damon@lists.linux.dev
Cc: iommu@lists.linux.dev
Cc: kasan-dev@googlegroups.com
Cc: linux-sgx@vger.kernel.org
Cc: etnaviv@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org
Cc: freedreno@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: Russell King <linux+etnaviv@armlinux.org.uk>

---
Lorenzo Stoakes (33):
      mm: move vma_start_pgoff() into mm.h and clean up
      mm: add kdoc comments for vma_start/last_pgoff()
      tools/testing/vma: use vma_start_pgoff() in merge tests
      mm: introduce and use vma_end_pgoff()
      mm/rmap: update mm/interval_tree.c comments
      mm/rmap: parameterise vma_interval_tree_*() by address_space
      mm/rmap: elide unnecessary static inline's in interval_tree.c
      mm/rmap: rename vma_interval_tree_*() to mapping_rmap_tree_*()
      mm/rmap: parameterise anon_vma_interval_tree_*() by anon_vma
      mm/rmap: rename anon_vma_interval_tree_*() params and use pgoff_t
      mm/rmap: rename anon_vma_interval_tree_*() to anon_rmap_tree_*()
      MAINTAINERS: Move mm/interval_tree.c to rmap section
      mm/vma: introduce and use vmg_pages(), vmg_[start, end]_pgoff()
      mm/vma: clean up anon_vma_compatible()
      mm/vma: refactor vmg_adjust_set_range() for clarity
      mm/vma: minor cleanup of expand_[upwards, downwards]()
      mm: introduce and use linear_page_delta()
      mm/vma: use vma_start_pgoff(), linear_page_index() in mm code
      mm: prefer vma_[start,end]_pgoff() to vma->vm_pgoff in kernel/
      mm/vma: remove duplicative vma_pgoff_offset() helper
      mm: use linear_page_[index, delta]() consistently
      mm/vma: introduce vma_assert_can_modify()
      mm/vma: add and use vma_[add/sub]_pgoff()
      mm/vma: move __install_special_mapping() to vma.c
      mm/vma: make vma_set_range() static, drop insert_vm_struct() decl
      mm/vma: update vma_shrink() to not pass start, pgoff parameters
      mm/vma: update vmg_adjust_set_range() to offset pgoff instead
      mm/vma: slightly rework the anonymous check in __mmap_new_vma()
      mm/vma: introduce and use vma_set_pgoff()
      mm/vma: correct incorrect vma.h inclusion
      mm/vma: use guard clauses in can_vma_merge_[before, after]()
      tools/testing/vma: default VMA, mm flag bits to 64-bit
      tools/testing/vma: output compared expression on ASSERT_[EQ, NE]()

 MAINTAINERS                           |   2 +-
 arch/arm/mm/fault-armv.c              |   4 +-
 arch/arm/mm/flush.c                   |   2 +-
 arch/nios2/mm/cacheflush.c            |   2 +-
 arch/parisc/kernel/cache.c            |   2 +-
 arch/x86/kernel/cpu/sgx/virt.c        |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c |   3 +-
 drivers/gpu/drm/gma500/gem.c          |   2 +-
 drivers/gpu/drm/msm/msm_gem.c         |   3 +-
 drivers/gpu/drm/omapdrm/omap_gem.c    |   5 +-
 drivers/gpu/drm/tegra/gem.c           |   3 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c       |   7 +-
 drivers/vfio/pci/nvgrace-gpu/main.c   |   3 +-
 drivers/vfio/pci/vfio_pci_core.c      |   3 +-
 fs/dax.c                              |   2 +-
 fs/hugetlbfs/inode.c                  |  15 +-
 include/linux/huge_mm.h               |   1 +
 include/linux/hugetlb.h               |   3 +-
 include/linux/mm.h                    | 118 ++++++++++----
 include/linux/mmap_lock.h             |   8 +
 include/linux/pagemap.h               |  35 +++-
 kernel/dma/coherent.c                 |   7 +-
 kernel/dma/direct.c                   |   6 +-
 kernel/dma/mapping.c                  |   8 +-
 kernel/dma/ops_helpers.c              |   4 +-
 kernel/events/core.c                  |  20 +--
 kernel/events/uprobes.c               |  13 +-
 kernel/kcov.c                         |   2 +-
 kernel/trace/ring_buffer.c            |   3 +-
 mm/damon/vaddr.c                      |   5 +-
 mm/debug.c                            |   2 +-
 mm/filemap.c                          |   7 +-
 mm/huge_memory.c                      |   2 +-
 mm/hugetlb.c                          |  15 +-
 mm/internal.h                         |  33 ++--
 mm/interval_tree.c                    | 111 ++++++++-----
 mm/khugepaged.c                       |   7 +-
 mm/ksm.c                              |   7 +-
 mm/madvise.c                          |   6 +-
 mm/mapping_dirty_helpers.c            |   2 +-
 mm/memory-failure.c                   |  10 +-
 mm/memory.c                           |  33 ++--
 mm/mempolicy.c                        |  13 +-
 mm/mmap.c                             |  41 +----
 mm/mmu_notifier.c                     |   2 +-
 mm/mremap.c                           |  12 +-
 mm/msync.c                            |   4 +-
 mm/nommu.c                            |  22 +--
 mm/pagewalk.c                         |   4 +-
 mm/rmap.c                             |  14 +-
 mm/shmem.c                            |   9 +-
 mm/userfaultfd.c                      |   4 +-
 mm/util.c                             |   4 +-
 mm/vma.c                              | 293 ++++++++++++++++++++++------------
 mm/vma.h                              |  80 ++++++++--
 mm/vma_exec.c                         |  12 +-
 mm/vma_init.c                         |   6 +-
 mm/vma_internal.h                     |   4 +-
 tools/testing/vma/Makefile            |   2 +-
 tools/testing/vma/include/dup.h       |  41 ++++-
 tools/testing/vma/include/stubs.h     |  16 +-
 tools/testing/vma/shared.c            |   9 --
 tools/testing/vma/shared.h            |  43 +++--
 tools/testing/vma/tests/merge.c       |  40 ++---
 tools/testing/vma/vma_internal.h      |   4 +-
 virt/kvm/guest_memfd.c                |   2 +-
 66 files changed, 751 insertions(+), 459 deletions(-)
---
base-commit: 4a6c88e10a0791d9c3b0677ce984365815c2ab4f
change-id: 20260710-b4-pre-scalable-cow-24309015dee4

Cheers,
-- 
Lorenzo Stoakes <ljs@kernel.org>


