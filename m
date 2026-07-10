Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D87AC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938806B00BA; Fri, 10 Jul 2026 16:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8486B00C3; Fri, 10 Jul 2026 16:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B03F6B00C6; Fri, 10 Jul 2026 16:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF996B00BA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:28:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E382C1C8CD5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:27:59 +0000 (UTC)
X-FDA: 84974003478.02.B56B405
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1EC7A10000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:27:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGt3vnHS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715278;
	b=CvUW0XKqF3qgrivBcZ4cXMCCZvI51Af3P7NgbNEwCBhZpUnp0dV1Q92IF9sDvg6z/zNfDf
	VjJvUjqxJDM5rgrEAYhLceOmAtVcW4IW2vmacUE8eKaqnF7LTkjIvPMw/Njyk/DrXiT9vy
	L+TzDEb4pediv2jTxo2RAv6SC+V/V54=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGt3vnHS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5LRkx2oSsXHgqG+QA5RqRp0DDiyW95JFEnIgiYl+Iw=;
	b=Xe31o/9zlly6qqXqdvkXRTfKxIvwFY+Xy9tq83TIMMX4bGv2N1VkaqmQWbO+9JWLzRf1Qr
	qm0XIZwuIIySbxSl1boZBJY7X2iJL3l6Q+8Qe4dIJeIgI6IOEqCfSUvJBYMmsCSQr4Okud
	it1N2YHjVSlbz2g7Z7Z4ybM/RtLoevs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 604AF41159;
	Fri, 10 Jul 2026 20:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9973B1F00A3A;
	Fri, 10 Jul 2026 20:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715277;
	bh=T5LRkx2oSsXHgqG+QA5RqRp0DDiyW95JFEnIgiYl+Iw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EGt3vnHS2l489cc2SwVMiTWcS7m0rdltlhOLjOvy3rgfXckeCDhdA5ceUssdznsRc
	 nkxPkRycoucmHp9zHNlY/hOHocAN5KVW/9ngUkSiYI0yFBzSuOoPJUTD/OqjLVkxUv
	 VYPH32pC3qkMkVN1wCmJChPEY3pTRPJBeMMvsUNAFVF9pqAnfyag/WVxSKIBv5REV3
	 eq8D4+m0P1N1K7inlnc45k1cHMBe8ipJUAH3qdar+GAecqDRO/s2lUwQYhPY7AFMJP
	 QD+aAVoLxwZ2LtSjZZWPD47ZHq4s1HQjihgJFOaxB69qwAnxvd+GdDtUydhpOgvpnr
	 O9dUkjiE5k81g==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:08 +0100
Subject: [PATCH v2 27/33] mm/vma: update vmg_adjust_set_range() to offset
 pgoff instead
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-27-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2193; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ot5zow28e72938cIXA7tWk6DLYEYYQs28nPPrOSDw0c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg2235r5P1it+4X64xHSKz7r/+t33IllWPnraGvLOS
 +F/zbT5HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgI71mGf3b7Nn5z2M0ss+yh
 woLVdi4s6VfP2xjdzNbznP1/+lbfO+cZ/mkVRX9h2vKdIdje21780vk5PB8VfTpzT73ztZs7o0i
 SlQEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 1EC7A10000A
X-Rspam-User: 
X-Stat-Signature: 7g5j6ariwxgj8emnqity9kjerb5fteyp
X-Rspamd-Server: rspam03
X-HE-Tag: 1783715277-774921
X-HE-Meta: U2FsdGVkX19nvSkmC0TfdPSG9cqCC2vCRzCxnZ2K2ogaA240rqgXJdwwm03wZMAQkB3LTNpVvVHJk4uluJChghOK9N/5he606dDBmv0j1yaMwsfuSOUA8n7u6kZz8grwQsJE+9PJ50kdHbZmpVXcgJ0Dn0sDz46sFAugs0eyhzmm1OYOwTfydNRKMs4pXsFYRAfihhaRD5vGTlomq2J5FgjChp6b2zLG62GVAsjXBDB71eIzVBzC7k0z9XrN5945a93noRfhzo6dfy2tNRs4PPwnpR91pxN3GYk48e2V/nisLZfhc7+kgMe7DHuC6cUosKSLZ6nYy6DFTaDycCXqi6jxlDcG8Ptd/6OCmSjq8G+SEm0rYwiO4IEeZ4zwzij1A2tS5OXUPX31D7/zlNoPMN7agot/Iz+lFPb2ObFQOkKMLQqRyWNnweYdoHWhGo7XeuH1fcBDmV7hzPOLtkyM3xkV/F2vYiwlKvsCA5wSpXwy7tMYvB3AjyTf/owgrbaCjCEizkJYjq9LNe/2/toQoqBB/qhHLtr1i9/8A/Dbl/bhkU3pg/6tpLqyeHOx2XTWl9Mr/OX6WBApE+ddlVeApzpuBkR7JsbKBLJV0H3essXK7QWUV2yELFvYEOpyfjgjiJjviThqGgXnHSnJf1+0Uu4FKoTs+KWN5DN7FUR/r4CIoO0RJwhhaRx6lVsDTbei/Ag0szJRbbqlBLlbxsjXMDMn4Z6NE1InlM1Nq6Qb885lMabsvbqAMICmcb7dXKySArVL+2xiMJmMF9WSzv3fiMvvnuwQLx8xI93vnNJ6NdyR/838CFwSObQWcuXxsx1zn0oGHzEVfOQkCj4wKP6X5TwbmnuOMES+i1jj4Zr9yOMJCkln0YYQ2VHMiYi2hN8xQpRsfsJdNvCBvS0zeek6yjZIvI5UAMq/7wScoYd/CxerBAViAF5zKPSNRjMschdqbAEY8RXRjFHiKwD3uCp
 ty+jfppj
 e5gwyFPNVqnxzP2+n63pzh7sbWd/EnMAy7j43QWEi00VURTkEMgYqXxYPLkxPue2RLo4Px9/YYxS2LBu+hHTEZBk8me0FL3H0z6B1k1ygGrVfnk8XcgnyjD40QwvAtsaoXUnlWHDCefQc/yNMSmWYa/s+tXWCcGplae1auHlbho+pDhu1O333q4JHmKUWT+T1AKo8GtJYM9jZksCuvOPWeoLPGXPr0ars4oAEbaLc1dZp70xa+nEVp/3ZQQ4O4RgCJUtDJcl7vU6S6/0f7k0/EpOuAxzrHaMxEmFE6J1p1M18J6yCaoy40TNWjTu7X7PoFk/pJi0nJc4q0nIAtNCVJoCKEKezWiox6ytAF/rAQ4BjaFSs7rBtnfVKzFa63N1IGMWLR0TO5PbS9Zj2TLLSTg5t+QWNBv9zGwW8H9LNp6ukAHeJ1beoVs7J9Kw6SgSwjE87LyyYGMgHWpb9v6BhGNLU2NQzGQbVLbX19TX0S7U4rRqlET6Jyv2oenQrAMh8dSyt/tJ2bfDhsIv17Enlas72xHBcXLwZGAUZuVgrHj3KkPXAmjGPMvlilAUDheRFPz7sORiMUjO0d+8cP9fi++y1rBtHf6oU+0/8oJzkw9OR1v1L4DKtnYwzoIc+1v4IVyqb6gJEcxYpR+EpBn84m1FxT5caHLAk4JNj9PL7QqigMDUdHg/6EcH/ICoeSq7EtPYm1qDqBs4VRo5E2quU3lK+yut4a0UAoKlGuGtwJz4BVtPcAlJFciuJZa6d4o4+PBssNEt607bNQndHuDSWq7aJebLWCi61khTqHhJwHV+oyVc5tolOoA1j+F5fB4UiIr5ImlOoxLloaJvarBDAi5WSmlp7k60khkrqZExeQN1npSDkvVJCzvC6mLT14QL9Ogx0X83muRFSinag5D65jvrAblCLfjy79DHjr1nSBb1mYKY5zyMgIi9+sb2z99ywHaXu6Gd6rVYbqA4TkY85YEdyGwdp
 b2wWGUUJ
 WxoOh6I2O6s3HZ0HxQc147IaxlkbjFpMfeYAcI8J3m4TrW8DI8vi3OyGFTsHSrjUPSxRewppeHVaEkZo+NLNrnvgPsjROvwxBc0BCOXV7tYSe8wrgCgGl2ugIMhR7zPMVhE1KoOQJRMXygtjRlQqJ2/Np2vKkuCZXd/1kUcZ8QiFTTyExfKjJWHYx/m/c2itrp3zmusyVhOgLfaY1HjXnjbz/fULON1RaO5vAxD0dvUSWG+Xo0rZZ3k+hUxAaTBqDf1l4bg4360DAfmRGPXrQ98NnjACcnSx1evH+3DRxY13pnSGeFIB+Q2Bvy1EZrFlhGQuPId3PM2i9CMfbpvWzplR4pt99bUCeS9Z7H4m7HKGW+ZtqZNTpPruvhqnLZ2oZs6pawcSLJv4jEhyKN4dWO9MSFbjXFPvy9Dn9xq7nOMW/THD63ud360w2awOj/szJclpTypbWZvyxfcZ428WUAZO3u2yMh/RmE+mr/z+wyyoJVJZNNqkedojYOR8QuDHBkSe2Mwp+dhPchjG0xOEqeNxEgEBgrshUs8wwzhDsWdIM7WbibTAnoRrjza0ZtCdcB933ru1VsWMBE8X1BhLLu4XULUKkurQnLCCiTg4ubP/1XPs7U25Jg08CK5/Zrt9dAZxMEe0w2m7G9087zRZrvyYI3S/kQjndJiDV5ou2WLyfROhhyy/r5UUq5px1DsvSM9mAMclD1dhjdU7Cp6h0bm5ehsegzENQOx1Q3+W2cenGTrV5jNh6LgRX4GsZBHKEB3IYLs+6FvTJuK3PD/2TsVepPU1TYiajFFyPc1zxygRhAkALutYh7INLEJbyBAgLQWZ6dvFc7IY2TDUpm1rggIpPLBiMnNe5bPcLpoYj7S4rrhqWNpjbGwbyR8qfARLYKGBBrRF3LYCFxsFpykvI+hM/I7Xg/rXhKnO5JOIS6vIAVQfXJcAOUz5LVKbivN/SVF14MAjNAR8CJL4SDWXspIfg2Qzg
 GbkQ1T2w
 jsKPp+CxlGC1UsNTg8kpihrY2j5QjihVx30Ll0seKkCVxalijT1EEdqs1gqCQPJwC/m2u8cXrRAQSTPy0U6spBh1dtMswQapKiOXxOjIUpb8i9aECnaeCSBboYjKte3Mjcsv0ekd7hryAIbS1cucn9jk7ng+shjq6RcHdkTML09pZnqPeryqI5G6uw2gI6b9mmUQCZWYzSML8PhxBzH0dsjj/WUjtRR4327k64S99Ue5snKJ0CtAAn30+LmytUpiyy76KuWxCbzc28mVOXnyHzwKHWej81BgbdO+hO9J7ZFBENzzlDrtysJNTCkol+x9IRzNCdLPg578vePWGi6EgKSmnhus/cXNILb8Y/wSgl8ptWWSTEGDF16B2vHzDdURbN6R+2evejcc0hrS9pYoaXRTrxixBZHXNPVAfh8bpohVQjZAduzR6EllH57/kiI1IFGxY5FBzKDsCA0sl2Lv9ErhFQSLWnfz30gZM2IBiaDl+ea4TYwG/clqTNgSObeq7DVxWEknzdndBQqY/2nQwhPYCyYlxfTVHxzuE7RqS27ILDYzDKOubzY4lm0mT4tr/Z7jyh76UFg09fPBkjVOaZGXSEtlu6hBI2phOhAfVAqaODQaeUlBhe1LT6yQE1C+QlSlnB6q2qRgTAKPVGJlUnUxUduoXOKt8WEDaFCYlCn6IdI5/jqyTznOgvh9pAcigt9MRavFz5Z1FeBYL1WnH475CgVsooZhOWNOcQ4eE6F+IGkjLjMYcl5FCYkUBG8Z2/68gQLoeIE15aZWxm5EkOqujm+rLqfSJup55ayzQ4nJ519YbKet/be/Ifh/PWfd2Ra9eix/xG0fu83veBgUSwd639ZxmzJUM8HBJckWYdtm7TvUU9w+SdzAkyUlU8MeK7tACB3OhMG4HoTNcMALY8RmWbwJr8KYD53HCRsezUHApCzpUkHr5iwPepv8TED+H6B8S4bF0t4TBAJMBsAvY0R72Aafj
 7uXky8iE
 Cz4l8MoJ/lpdkD3j4TCzDgpw+LvzaxBizrtiIYYKhxkI3XXsR09UTvEeWcG8j5+cJJ91/63UAYCIBJucRgf6K6lU+vDUHw6byy9gL5VtlHmzfalmTbLO73SgXtHZ+CURkf2bOn9yBc7E0oWXGjPT4qiRRjBsn+3WbhCkr8c4+Ui1wMOJKPiDC3B5Z9wnqwiRNeu/xORAfSZOAckguwA2BRjB8TzheLkoIHxestgEqNY30IxEgRknjHcV9ahLJ7QV1Jnd9xTPTW1Y1Q5/hRxJXrqRJozSVlyxM+X411RyNyuo3bFZZ/Z+lnT7ftgX79HI9ZfVAI8BY7NnZ5BhtStmjRUU3/qQinjlzpGxtp6QkZ5wivVadWnAwmxpsU5Z1m9OXZj27+iN4psgYFN4lZl5tPOSZD742MhW5o8STBXLuqc7T2I4bi0LKR4p7p6DqXgGRJG1hvLZ8puxEvQQTqz+MKwoQ5vy8JARVszS8QxBGRHPqkcymJu/zEr8lfUQ8h30EnDhwVDkH06OBZJUJFVhGxGjlvDx70YSV8MUY7wYFKTmGhQ81ODrOj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are calculating the pgoff as an offset, since we have vma_add_pgoff()
and vma_sub_pgoff() available, just offset this value directly and use
__vma_set_range() for vma->vm_[start, end] values.

We take care to update the range before offsetting the page offset, so the
adjusted VMA's vm_start and vm_pgoff are mutually consistent at the point
the page offset helpers operate - this matters once vma_set_pgoff() comes
to assert invariants which relate the two.

Doing so lays the foundation for future work which allows for use of
virtual page offsets for MAP_PRIVATE-file backed mappings.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index a474920a25b3..0699fa07c40f 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -714,9 +714,6 @@ void validate_mm(struct mm_struct *mm)
  */
 static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 {
-	struct vm_area_struct *adjust;
-	pgoff_t pgoff;
-
 	if (vmg->__adjust_middle_start) {
 		/*
 		 * vmg->start    vmg->end
@@ -735,8 +732,8 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 		struct vm_area_struct *middle = vmg->middle;
 		const unsigned long delta = vmg->end - middle->vm_start;
 
-		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
-		adjust = middle;
+		__vma_set_range(middle, vmg->end, middle->vm_end);
+		vma_add_pgoff(middle, delta >> PAGE_SHIFT);
 	} else if (vmg->__adjust_next_start) {
 		/*
 		 *                Originally:
@@ -764,13 +761,9 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 		struct vm_area_struct *next = vmg->next;
 		const unsigned long delta = next->vm_start - vmg->end;
 
-		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
-		adjust = next;
-	} else {
-		return;
+		__vma_set_range(next, vmg->end, next->vm_end);
+		vma_sub_pgoff(next, delta >> PAGE_SHIFT);
 	}
-
-	vma_set_range(adjust, vmg->end, adjust->vm_end, pgoff);
 }
 
 /*

-- 
2.55.0


