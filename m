Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD740C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFAB6B00A0; Fri, 10 Jul 2026 16:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B00D6B00B6; Fri, 10 Jul 2026 16:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F016B00B8; Fri, 10 Jul 2026 16:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62B046B00A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:29:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9E9512056F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:29:55 +0000 (UTC)
X-FDA: 84974008350.21.B80763B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 407D680004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:29:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rn0Rgzrg;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715394;
	b=FYqMjcBN0qx3iKF4rJlSuNGXIL9zoGDkBbiKw61VloXJ5pA3HTpPidqWlRK9cWouM4oshl
	S413Yt0W8HO0GX4SyylA16eVvaIgtyTrGevPtH4D5aWsa1DGlvBQiQBwXanwMDrg0RyxOH
	s0Hhuz4XaUgri90w+ICX0ZFnfZH0hQQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rn0Rgzrg;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9TL51kQxKXHzSfeISmn1qw+QGG9KCcdgBvdsczJlCQ=;
	b=FHlfMp68LAUFFSF7CEUYidlAQ7uGQNeyHlH0s0ClURkhAFQYzlImQVjRdsawp6TFVc33wu
	fE/XG3iZLiustd/mA2l7wkc2dsVFbkUBK2LIwURjkJy7wXjZLsG6C3g7rcH/x5rMurnb4B
	waiLfbzvb45M4X4KtAaiZbXyE5ZyS18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B722560EEF;
	Fri, 10 Jul 2026 20:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37601F00A3A;
	Fri, 10 Jul 2026 20:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715393;
	bh=h9TL51kQxKXHzSfeISmn1qw+QGG9KCcdgBvdsczJlCQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Rn0Rgzrg1X9P5gZsTrshFOS+gMVue/gsuP7CnzM73czznQcn4F9ItkfgBxrFDuH66
	 94EeIgI5hcr2XIsN3JzPfM7oBQE/vD8l9enMDbVOU8lNTUaYV6fcAL/6vBz7qX6VIq
	 NV817DVIfXpi6wJ/hRvPJWaIpuFGj1/DltiI/mD1dBclCFblMGKiu2Oj5CzNoyCves
	 RnQ7aytJQVF43RBtHHafqZbjIwVNRBtQ8O3PLFYcWa7naE5fgN6Q0oqeQLqBuFn/+5
	 cBxamOvFBWiDSagHuu6Y8tOkVPWaz0YBClxQVn17b8Kz9ZPR1RYz7NH+4ZEm0mLklt
	 x3Y3guK3Ete2A==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:13 +0100
Subject: [PATCH v2 32/33] tools/testing/vma: default VMA, mm flag bits to
 64-bit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-32-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1053; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BSllJJ+2rRUlWzlXkjh5aitKXn0vM/W5l9yfCPbZwkk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg23tbadanfaQzj1y4rvlNcVF9qIRv947JUd902jK7
 TLzq0/oKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwERaNBj+qb36GFjppLrx8Iv8
 qbKmX233/fKVUtoRUPVgwvsv2l762Qz/dFWP/9kU0fePtSxGdTuTmXbp2f3yftdqG2/ekOSalyL
 PCAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 407D680004
X-Stat-Signature: 4humqr1hb8pc767q3c5irxk4cw44suuj
X-HE-Tag: 1783715394-838062
X-HE-Meta: U2FsdGVkX18W2+KJQZk233BNSiauHSyPe26dghBFys/40BAVkspYhItwT+Z3U8SCNUhY7rQizU/IKS5CTZOmWx6aWLCDy2yVZ93kPbkH1OXeDW8RM2AVMMIjocIJ+Qp15uA9Y5tNjMp19BkFzx5Bdr895QHI0ZR/fWHLcFu+rULGfcekjSNm0F3jB3z7FeNaBanqWaftPrdNVVKOhLlemYJ+FL9WBcFuxVCGAdL6sU8M9TB0ohgv1eCjzrIjASeYj5Lk7rKQy/m7qkpU7HrBK84EWJCyJ5q2A2r/YXjwjwRgkEvO0RErN48ACViEiJf/o33MWbQ7+SWpXjTsu4zTdYmek3s4PZW543VghcU/aFQomHbwe12WDiefOsSfXXVWm0xSfcTc5qGLBeMf6FQJx7mG2ejGsGRLjFg2I5pATOZz1Y37NLGPoW8qXoFYFsIs+GRi1lWIDiowfR2bhH13fU/yWfo++pw2m2C5v7uKwoaHponQziKMpSpz/OUvLY4ORZUGaWrqFpZAiQgwmSgnaJgUemIxyFmBSiYjd8Nazaa3KYdmpsnuctVGGWElQ+HdQ+E0YAqAHvf5IoAJWLPrh6DE7f4RtQiHBm6bLIRqBeS9nQ9KnSCmFhh5cpdoKjh5rjHxLSz50dxPSooN+lgjqAPazrQgrKrgQiBJHXx0rjcsCUavacEHtHzpW4B4MWfLcD1ltL9BqkVn5kkm03I66i2dBo23Lma583XvEbUj+AqIs1W/057f+bljvK27JIXBbjQ6tKJ9FMqRSJ/j97blDGmUqhk89EmoysyShZ2dI5ScUwk0OijQJQO1vBKKksiHtENgFRIkGMDtsOq1d6fuRoOxxQ95ZUjyqRdb3EoNDUIjFl9J9chIySdzqrxRWGY3eptdv950ocLXngjX9bTUuY2FcY8JxgeGVxsnAXe6JpZs6myHxo9pvt1RcOuN410JDFkEGMUqRZsQYA7/uRW
 t4wcfWMk
 swNPv1VwZ5NYDxH01l4O+GPZ9ymBFpcLhJ78/FQU5lt7leDodMCABG1y2T+PnCmolw1PpNQ09vc2M8UBbGG1y8QdFPNCZvLevZw1HDAWcQ/XFVwSnyOskiWrjRsFWlt6fA4B7bjd+LE2jH6s5ZmahiNUEk8WnZVPNMKtt5GM80VQYGDh0jtN1z9yPkXnQjA4QgialpGkKiWoafNXqbO54v7RS13hErec21dP1GZ7/paTCVaddF/6ntkiDAE+YZhcrI72L6eQw5rEcpzAPr1ebj0+aUsUx5I8fmmjBd5k45lazrRcqZFhKiFu0sFAEyG265qSykJwvObF5zGmjYqh2D7Ghh7HwUbuYN+8Uj4Y1xsr2ETmwQlybSoMMcX1FCA0cpLEOutQDCk6HQxxZ6CmPfHvqHGiFe/u8MhlbG8qPNve1jsmTGL7p+IeczgCkhwDMlWQezYk1w4CRJMNbbobnON7ILTMI7NXhKXM4u0OzQW3O/ba5HYtZjbbLqSFE4KX9KqAelKoapP30GE6KrnfejFT5/S6YwapDaFCYOUuTIFjTsz9/nlqi74iAkJLtMR87ZZbpuuQmEnx8QhDv4OAEsWDJTrIBe3kgjaZYLP1rbrfZHuofgjlc8qNKh30arv3EoUTyYpmJ6R68dXoxMU5trtRsYTkVX37qz5VlTnXaHyEhD/YLJXamKr7MaTFAIV0PJylL2CAoGSwg4z3btNSOPFa3yxLHiCWLJGvNNv0ulMl0J/P/40TT+1X/WyX1vV+WaMWYl+J+z83h+dtCmZKYD0wciZx11nQW49jDwudkNkh3uWiT+CiPmk8iZY0SSBRKwBJSYinvhLooXKDtFhPUlamf1zglJFS/V7dvyblAb9rHGJHFpgkv4S1QEH98DqdwgDsGT2DqLaXl2XPB7mSrD1bTTzS2f6riqCBYy+KLcu8lHgkseuj9NpPj+K966oSxKwkQWR9g5thTNK7lxDHmwEesMNuh
 nwVQI34m
 S8xHPKKxH6Z/QgAvcamO6az++0S/RV8DOaoeDI8JCXi6ZkLlJTrW60r1z4L/TbiA4E0bMdDwJQBpe9NFP/t1f5JwR54uMS0ovnQSCe8wWB7ImlHXon1o1fjJAjgZYgRD4mbL4MIawckC3oIoTF0pVR/L5/iVDIWTPyKTt0zUYop6A/abGOydbVt3QdJXnc3iXNcvA9DnQVVyivGRyUN2Ur0di9tf+RbA9T7EttxWcqhKyCV2s2t+UDuclH/+NoYCDCVbxw2XoG49JrOkru/J+9pi+6NHjDic8xT4UqdSEowl2DeVZC4wEOsaoso87IdOKrBuotVevvZJE66pze1D4kRzN/FRKNu0o06I8rn+AElmznfe3HhxnPYyKvdGzYE/VpZa0CBFind2RPXrKncwr3TA1Y6dK3H5igkUqg1sA5+cjJNzma+EHJlje8vxu6p4qXIPzq07HC5RsbfXlteNkPHr05xyWT7W+ychdotoBVPFB15I0D0g3wGi2qGEjMcYGFo7mMI0m2ZGYCiyZkq/FpkRAqZrsYP19Wse5+MoVTF6N4S21sCkSj/ad5swK4ZYk8itIQneT53nZ6BSxVgRfUFfWAEaPXBpELRTGv29oqqzaRCF5BMzaf3z/Blzb/E6MydSgJX6UQAdcVMvoOPb/2MT+4Z7H3VIheKYtv6eCftaOaZfVVXIQ6xZELmIwQqcQE/w+3PmyZrRLt0wjo2EZlHNio3KOcg35R/Pv1EZoFutRJlN1s6gMEm8HdW0V3HyvlrlRNE9C+e7sShRtAGnq3NREMLQ5hJmYiJyj0WEnwwnRbbb+z3JsDtyNILqep9Xx6dZO0pQtrZwzQ1ZLFoIYKmsgXWPLPMU534szYI83xdK5rYbFuARiP+p+WTpzV0Zj9cCH/QGeMqzU7T6MqOzcmIReq5UoVyBKiTf6HDurVW7dk+VrT0BuFzqFw8lh0U1plvrAWezo91Da0ZifyXxYlZWMJzKD
 cI7TCilt
 vEVlT8R7fv7BfFFI45bESCIqVhDXN5UXg/FHPXaB0sTRzhSZycPhB+ZXL8mO9oFMLGtXPg/ZzJh1sIjPlTU8vMVGkhIHEnfyAVWUIO4QzAJGmNNh3Z9wb5vwfmopCU8k7f5e989eNK5RgOfz3gA+MqJoKrRzY0cwizkklCrYOnEuqqkF2jzcnns1JWmzJCid9RnHuwGxMNDs/ZawrrZqKsk6hXCBIBAJYtsq5gOPZeYSUkdcOFQ+mlAPZj+/eKNBSUjiaPXYvNWML8uY0ogaZZOXdD79zeQAS53MLgV6Sk3cyetSmbiMyPKlMUhEgnmaSr84oIsPi+NWN+YCuhhQdU5VWq+m9cP0o9DAH24AsID79z5IMK7qHhJCshVOye74+Y/xJTDPCLK1c8FAIyQIcGSlRIbxeO9/jBEEjRCpcSjx/a3VvXSkqoe7GicLYIbT52oPAUUAXzezs4o3WGt3qrM86ZKG9uQiNqV/iD2QEQzm7t2Nmoz9sMS1Wio89mG0HVbVKHuT5LMB79KWbX94U64hcEfe8juow5MCjVUlE38ULre9DMvucSZJov4ZohcN9uE89rmDri2LrlK1gXnxq6Sd0uTpqECUAI51GY0g0kcIORCxe6MDQ6IjjgHShTwEBnD8WD0DuepgP9sgmqiUxQU7039wK6+r0wncRTL5Au7lU8nD+CVJFI2YP4Nc4XyaewyfcV9+ltBRD/lV1ni65PbrqeyzCon29pLmmoh7wGEs3f+FQGzvoOcYCGRy46j+DGOazBGWJfHMWPbnCHYlzvrHn4wMLg9kMqr3xQZZaieuqMwNtZc1dTn49birJx4VlRlsP53jqYlGBw3eC7Ru4eOrQhleu9SKniOnmZXs58JVPQfir2WZqd5Kf5BvAqR/j3D8BTvJ9gOB42nq4Tr9SYEuxtTSEcz7F1GvZYLIZfLlhJD61lj3ez2vchY2GrWPZF0d4qL9q8wySa/URLP4ocCXqzH+m
 XYsldOih
 Zu7V5GVx39Vlht/NEhgj8H0A0q3ypNUvKdz1eklZHUqerepIvE1CSKLFQGHbp4si1go7KpKa1TIFbiLcwqzDkx8QQ7HWWe6WnV1dIu77zt2BYV/2BJJ165dny7uXRJgujAs7ovtzxgjcpQE7St+Rljb/GCbGy0N/pY2ePGxU9MHv+YaNcdUPdiJ693KQxlQziqHrnG7lPl+e5Yr285CdYSpk5/FTcMQvDTw3F9PFzInzl084qZrb5FzBg+vV0rO7tkX9bhYdxQ/+SzSJKmj4jprx1Fc96uZPj699l4/ky0UynxZJnjh2SEAS1Q7CHOmqFrAVThxE0Lp0pEITGk+b6PfDdY9f2CrnLUlIJsnRSibq+BN/kcH76APmghjbRNb0OSTCxp2X8cojvp7uTUCnyTaJoyt0MquCi4T81VE4M5mOQdzO0bJfrqLy1xUUWduJVT+yoG5WrIWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With all of the sanitisers turned on, setting the VMA and mm flag bits
depth to 128 by default results in overly long build times.

Reduce this to 64 - we can always manipulate these later for testing of
larger bitmaps as needed.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 tools/testing/vma/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/vma/Makefile b/tools/testing/vma/Makefile
index e72b45dedda5..ef6cc558afe1 100644
--- a/tools/testing/vma/Makefile
+++ b/tools/testing/vma/Makefile
@@ -10,7 +10,7 @@ OFILES = $(SHARED_OFILES) main.o shared.o maple-shim.o
 TARGETS = vma
 
 # These can be varied to test different sizes.
-CFLAGS += -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128
+CFLAGS += -DNUM_VMA_FLAG_BITS=64 -DNUM_MM_FLAG_BITS=64
 
 main.o: main.c shared.c shared.h vma_internal.h tests/merge.c tests/mmap.c tests/vma.c ../../../mm/vma.c ../../../mm/vma_init.c ../../../mm/vma_exec.c ../../../mm/vma.h include/custom.h include/dup.h include/stubs.h
 

-- 
2.55.0


