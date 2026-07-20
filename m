Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EFFAC44521
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6386B00A4; Mon, 20 Jul 2026 03:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D246B00A5; Mon, 20 Jul 2026 03:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394B46B00A6; Mon, 20 Jul 2026 03:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC8D6B00A4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:20:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94D8D4073F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:20:43 +0000 (UTC)
X-FDA: 85008307566.22.9562259
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0B94A180007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:20:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q4SQ5H7p;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784532042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gANMU5sOivOjZzaedPM5r16YKmZ48cwI33ZQeohFkKI=;
	b=APafuiPFuIALArtksNC/PlUaCwFbTQ3hoA1NNp4s4uNDfifwzurpHzrUFmI6Z0LU8csFE8
	F7B1qKZgTL1H4kX87izj81UpX/fIP/mSiQE05Qje14PC4CMpOOiFmetHtfhVp/QrrsWfOl
	QUA7mHPK2gdgLwd4KNOtcOByUQpABcI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q4SQ5H7p;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784532042;
	b=mNl7VOzr9URRYRAP9Um4jdNE8IjWByHsgv8aqW+nCVlzQyxEFr+6m77U3wpaq5BN8v06FU
	QweZKdcWl+Ef5/EZpZBnNPavvACezA5GcuPlkzJ9jWa0HYQ8UAmpg+2I/aICcnmrOd9k8m
	qnGLpDlb9C4A0ziEpnKsoDBHyXLNnLk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27D5160A93;
	Mon, 20 Jul 2026 07:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F055C1F00A3A;
	Mon, 20 Jul 2026 07:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784532040;
	bh=gANMU5sOivOjZzaedPM5r16YKmZ48cwI33ZQeohFkKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q4SQ5H7pfr3jaDU2ZnnO+1hHIoXl1iFH5WSqv7jLKEoKzb1W8Q48EBE20IuNZFTUn
	 ixKm0DVIy5OI2nLk58vf2Hjrg7we7B+X4V1GJxyPkSv0+C69K1TUoySPfe3BcFYtS/
	 t7GufXN3+op+50lWLzds22S7AYYtVpeOlcrG/0bZfPer/n9WDDe8GhqIXCV0fWPGUD
	 XmaJPMeyIJugU5z50bBvNZ+bv5B8MYe6yecmFyVa9TEs0150ohb7J9prH1nL+rHsFg
	 Tpa/uQSSoq+PE+oR7BoJwZF5ntDZOzikcQrAbuelm4gJqA+MbVuFWtO9kyaJQf1xJj
	 5Tno9QcBWPfNw==
Date: Mon, 20 Jul 2026 08:20:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
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
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
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
Subject: Re: [PATCH v2 08/33] mm/rmap: rename vma_interval_tree_*() to
 mapping_rmap_tree_*()
Message-ID: <al3LpROyiWEBL1wh@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-8-2a5aa403d977@kernel.org>
 <DK1CWBDK5J60.3VPRP45IS7L7E@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK1CWBDK5J60.3VPRP45IS7L7E@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B94A180007
X-Stat-Signature: phowpco93fx6ddrii8epujj58u1994es
X-HE-Tag: 1784532041-505295
X-HE-Meta: U2FsdGVkX1+SVImNyaA8/76uTXBXoGU8xdypuJP15OWb7VsoMeiaIBMdQwIKBMdjVqJ0EPm01Viq0TOH4Iqm+uYuyWlKWbfLLoFqqn5Q3sevRBP8g2hbvv3k8G0TTc3x12LyCR9ECzr1x/bAAqsJk8fZwMeRuV57gjj3PaQA1sd6TkT/Og8NsDSoRLHXM0vL5L4xxAgg7k23mBPDzl6S9tFHWxtaJTlQsNh3ANkoZS2n6uClk3O78t8jR2Uqc+ts8tSlCVBE6WSOjnolO+SD/hMu3htzepcLH/OA4DOtfMYDJoonqxhQKXRjEypmmb2kSuwmb1R0yH82puSreoX7TuClH6a9sAUfveO7MW3xI/hhwhy1p0t291naaAHTs21ho9TYHBYwgTq51c3Oy2KMn9QNoCJtEKjImTCgMXVobebzSGRqDEuRvnspsE2tTPTwlENYLZP6H5wJT3L7w3MrnmKUJkGgMxK0nzEiGKjCglwHfgjaf3fVYGreGZSj9sabkWKvaOz42sA+4BU56D4dH5sKMEevVCTAlDQccpuSphKLVr2prMZSo9Gv3EUr0z5eWOqa3ZoLTrWOUEDdlvjxvl+LUd67Rtec7/tCkbdvgv3s4pzmv2GNU4SDC69JmblCT0PW5nxg24NoTjCfo/fndhnV8TolbsBKRxOhiBT+Is5Jr7xnOhTNDTp3q2w0ybrAtbHZCSKrm5oZIxiic3FrXyNrMwYByrgofz+VatWKmD9v90+KWMt3utRiy2BE6xczWzPJlu2IzFnJprukRtCfbDA+kAu5YStV9VgsVyUh/O0hFUCs/vAJrdISMzyglPQXAwkYrDIwPdsrDr2+p1XuuKz4xGfCDVb9Aqm4zgAwfqPdWw6d7sQ1Z81tCLKVhYdGSqUeOmwk9UsjC6/tKTO3mayfwh2XOf64twZ2KioSdzBdW3jdOjbPjrAY38wOkvlHMIoSuLz6coVVJaRlVHx
 FHJUoLCO
 OC7wgzZ3W/G3FXP4ltIvVeqnVRWN/xHTAZNoURk3eDZmTcQx1C7jgHTWqUI3I22YHG461rqivp99inlCpiwNobiJaMCSvFTM4CDGi/gy23zipqCXfAfjiugpA8DI4k9mO5tzusacVBR9Hwdrd5qFpfH0tZRIdH2SSEpfILRwftLk40kENEaf1jnvMEKhqj0JCN6HNh/yTxCPNFAsMIfV7bOVUvtDKcAVWiPdFtVRw4A2RbRc2dLDOCMiqVhaO/TK80ENCIzM2JAunPvGLvkTHdHcjf0zSOds22tPSrz5gwl3q/p30jdAukT4JAP6HV8Tf1kcI/H8/1Afp9T15Ceq9PllXKOMaZritm8KNW0/mGkza13rCtz7Z9W87PqIRsALDcG+l9ui6cxF3Aiw1vvZikH3bSgaBr0Hk1/FazwG1cleme8s0VR8p2X/GWExOv4IuUaoQsurUDm30vQwiwoRhvDoK9zAVm20z1DE6ewDWL6Xq/HSz1ELRSeTaTo/ZUkc7HYjbAcbst9t0uNnx75cLMZYM0JyyfrrGHxz+FdioqzAj4NiqtyMmPVS3Gmll7/pR5yuBkoKF9dJA0N+U6NuW83hqp6c69eXgw34tmvXwtZhgEufvd3d4eQ6LO9JrBDiugH6vo3HwJgcy6ofO+R1t7baTv4Ee2qGrSEDRpX181UKhSMlMfVvT7c1DTWKrlR6Hx9fFB5FChEIIul57QthQcZQPDDiuyJGRYCnNF7af4OyyBPSZmO/ChgHlEu1REl/eISCz8qm6U7Tz+syZl4RT/A4lyjNLUQfiOeNonoayrUqFbAQNCsuZAtvCxcKgbkFPdbqd1KvjJPDplFSNipqxpg01IOERZpg+RPKigZLngyL8IH0faE3riE9CUAYU2ROr8R+OLzmnWJSgVk8onUlQnEM58NOc8ClP+Rye2znWsi88a8oO+4+fMYpK0mYqfIZSF+M9qhPj4UhjfWuSmDQA3a73BoVV
 IiEuS4dL
 gjASzgVJARTK0EUMJBz/xmdVfjWMQLP8Ak+BsndBXq+sSN4Tmc2ujOuuQjaUAKrtIpHeIneLzEqVvUUkz9Kczkb6p5Y+CAtugIal7eeNH0gjBGIVBNDMBCAlt/hkkbkuJRU2VYRadpg+Dhd7HaN+s7JKPmivIvDnktk2UW58qw968DJ1+aQwS2CArdK1/t8SSd7YiJGlKkIuYTESMkFglRZunKFsjD2sL63k/LYYBbutmQYnJiaEoxWwHBCdZBz6uNpD6OvD2qekG0/rXk4kVoNJ0J4fS4G45/OJgo2p5JXAyXYsZUATH1PApgHyap1B5HcHgG7kYCfWlJdORrNuHyk2yp8bw7wDGEr9+KajPbEYyla5lpMWzxa8d1dYaZn5qJYbS8ZqDYS77A28awL62KVsIr0UQcMQ1gb9+gXQOsjQsCuc8122gPUrlibTK6yL5NN9iDKFI6zeDSubMUxLJWN6Akg/agVDas3hRRLUiWpmrWuccqV693G6LQNyoN/LSztvSY8eqpQAyKK6Q2Q/tPFpdlRzGUvTm8GxORcAOu+lO998QnQ502I03F+D5rItkC5k02ApJcjjT0pWiSwinNc923Y1jEGo8ytw49ZdZIWwxomfn/SMTvNmF5XXTd37RJPVUx5pWl3I97I6WMJAgZ4oPgRtlC7e9rrOxRaH9zF7IUUTngtSKT5SNxTUXpLI3Bj3TDvPmiS4MdhOVW3CB2p2HNLRdqA++kdTtreU5Y49ZgfoYEt7XT+u9i8yNIqmsppOSfdjbSWMe5pxecfQUsRy1UwTcSSNgLXOkpxWWpsyovWi+JPxjbklMJZ3MjdQtmt8SgaoHAwbC52eVEELT6eZWmdTcHjzgk6EK6o3Ikyoi459LQYkMcM4FTh+NH9iALbiw61dF5rcy0vuAVr8uBFh8Z/DZiYDiW3slpZfJtQ34IGjwxtMhaH2kluUyNV+E4xaGpfqq/6p3xxNR91sG8boiUO/b
 2IBfcAmL
 qpPF1aH77N7cK56PKuGr7ODcEgRhPg+olapdvxHAqSDQZXULYwxfLMjADFh3W5bfIo2oNlJg5DkJqw/ff4Q35QaQTpIyXAKNF/JpvZ9qoz3YYxscGCjlNqfbhesk6iMtKhDvrw3QJDtTSBel2DE8JyzR+nv5I2EZUOD1E5PLl1F3o868PAxPggjVpU1t+HQjF7jDpQvr9R+i4/l1GyEebrBFNQJ3ywl9JslR5NhF78rJPT0KqLpGzcwHspvLB8MV7VRAxsOMGLB8zbl/YvXhQLQ+yah6xkxd5snWR98/+jEbE3k4j8IBINWbeRthGV+cR8PtgHZoQMwXZW3OVBC5Jqu2ebEn+ZtVq9C8q2DuWvtbTVCSwXL2X8jJjpbi7/6LLoGcfDRPBaBzbuikvcM/doPnJmBsfpv9/NppyB6zBbD+uk5yRn8b8jTekmILRq0YZkfm2v+xG5kL2bdlsStdxIUSyasB9/VkgU5IDQSE2wZPb7PDPpJaQXH7i/uE8jEBOvjWfFo9Wkje/YUBeOkTZ+9PoJXZZAP/S0RVYgNJ8RyO/6iut0f7IRXA3SUIi9ZFJlsBR2ZKgjzIGl1OG9iQBJivvnp+CSjvDdSgetf4eoxt2nIb01Ui5/zVSXhojkxWSi39X7YC9L/yj/NXyid/7f4z09LOUUkiD/74ktbIHdp/o1TJDLdK2hOokshfD+gxZkS1UjRe777jdD42WFiqK9VAme7IdDLNISfnxX6UpZxV0XOVTzlIAcIo3fDQvSnkzaPxt0w6X+/kYzCqTpLxs4K4+wflCLIumMR7ZW5cE/01diDNdlVL1nGeEcXQkRzYs8ImhRf+V76FB/+UqeVtqszoY2pFtFUUk/4FXUs83bpvzpy77USxMD1Puk/Btpy/oY+iTvD4WTRnHi2ARXsx47h+MbDuyD7KKu5ILsbJQxzdPew6Kfw69NtqrYEPUChGrU9/qf6T2qcQe8qJeZMngzoKWh31y
 w3l/37Nk
 qwzxDKinBXJCr7WHZd+v60hn19utfgprvgqgVBj8lu7L+06xOOOahVzcnTelJtlyFVWT7pjA7+6bRyNzXvvJWX65D9DUBo9aknm/qhzl2LpqjVZfhmwAcEY8f8w6lNnXsRlUNpQyoef13hPMeks/k41kvB+n9/Ynsrk/67iNzRVtG9tCHvTxR8ptEE68wkyJfkmU2eURF84yDK1IXxpA2GYiJ0vJbCb/mhRjWVv1jc5GRTuiTnXGho5lBMG7Njco/7jNCrXQs/uDL2dJUrhOEGWZVtqPkX0yjyZTrACYzlDE1apNaRsl6Zofw+c3NXSMRl7whNGfbVlxU7tuwdUcxpZyCBhqnswGk3xUOc/vNq4bk5KiQWEaxfAM16po2jj6Dg+grLq1eZNPVCR1FbYxgLMQY4yICC6/Nilwt5HtRrpsK+SvihSMGfzNCU9UvmM8Sd3dcaRqgbMYBxvEpp4j7AgbHTe8Mr3SvIW7Cfa6LdRAoSzAjw27dpsxC4M/bTzr/5Fmu+07JYt5MGtFzsSLHXXOjpsw8mEFpfmvkORjsJHGxl2hWv0hed7GY2d0B8KFFfjJUf8OrBTq2/Bj1dwQn0RDojlQZNy3realdAKhVRTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 10:54:24PM -0400, Zi Yan wrote:
> On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> > The family of vma_interval_tree_() functions manipulate the
> > address_space (which, of course, is generally referred to as 'mapping')
> > reverse mapping, but are named the 'VMA' interval tree.
> >
> > VMAs may be mapped by an anon_vma, an address_space, or both. Therefore
> > calling the mapping interval tree a 'VMA' interval tree is rather
> > confusing.
> >
> > This is also inconsistent with the anon_vma_interval_tree_*() functions
> > which explicitly reference the rmap object to which they pertain.
> >
> > Rename the vma_interval_tree_*() functions to mapping_rmap_tree_*() to
> > correct this.
> >
> > We will rename the anon rmap functions similarly in a subsequent patch.
> >
> > No functional change intended.
> >
> > Reviewed-by: Gregory Price <gourry@gourry.net>
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  arch/arm/mm/fault-armv.c          |  2 +-
> >  arch/arm/mm/flush.c               |  2 +-
> >  arch/nios2/mm/cacheflush.c        |  2 +-
> >  arch/parisc/kernel/cache.c        |  2 +-
> >  fs/dax.c                          |  2 +-
> >  fs/hugetlbfs/inode.c              |  4 ++--
> >  include/linux/mm.h                | 16 ++++++++--------
> >  kernel/events/uprobes.c           |  2 +-
> >  mm/hugetlb.c                      |  4 ++--
> >  mm/interval_tree.c                | 22 +++++++++++-----------
> >  mm/khugepaged.c                   |  4 ++--
> >  mm/memory-failure.c               |  6 +++---
> >  mm/memory.c                       |  2 +-
> >  mm/mmap.c                         |  2 +-
> >  mm/nommu.c                        |  8 ++++----
> >  mm/pagewalk.c                     |  2 +-
> >  mm/rmap.c                         |  2 +-
> >  mm/vma.c                          | 12 ++++++------
> >  tools/testing/vma/include/stubs.h |  4 ++--
> >  19 files changed, 50 insertions(+), 50 deletions(-)
> >
>
> Just curious, why not file_rmap_tree_*()?

Just to avoid any confusion around address_space objects that are ostensibly
'not files' like devices or whatnot, but moreso for consistency with the rest of
the kernel in referring to this stuff as 'mapping'.

Naming is hard IOW :)

>
> One nice part of this renaming is that the length of each function does
> not chagne. That makes the patch easy to review.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
> --
> Best Regards,
> Yan, Zi
>

Cheers, Lorenzo

