Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A50AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162A16B00A4; Fri, 10 Jul 2026 16:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114636B00A6; Fri, 10 Jul 2026 16:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D8B6B00A7; Fri, 10 Jul 2026 16:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE4A96B00A4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:21:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B8AB1C3C33
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:21:49 +0000 (UTC)
X-FDA: 84973987938.30.ABD7A28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8353E4000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:21:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RwSqHlF5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ADg/hEbWmy/12b61reEQKb2Q6dpfi0RDajVlCkBx9A=;
	b=zM066COVJQrK8Gi5lvKvHQIbfsSxFMNJTAAfm4+XRWAfHRWYxTtUX45KhreZxw5jkgVe9P
	H8S3AwDQvGHO34ldaAvocc0gVxcc10m7HYqz6fy/x2iiwsikadJmeLwZtzbYKXUtCy6g8x
	IcPiCANnLpg3//ctZjsfQo4S1xLIIVM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RwSqHlF5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714907;
	b=y+jBYv288m9+Z/KQE/+jp4pPhykQJCHvMzrqGWsZRBlKWIxnRViEUqL/wB6UInFY36Rxcp
	byOYu5NMTI1Sm/2V8RqXQSVViZwfYjPb3dHOh6BzuavRA9c71nq7Vl6FanpeYhGT0LGcmL
	GEhDxrhu/K5xTTlbs9N9Z61q/IuZbyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9CF7419BE;
	Fri, 10 Jul 2026 20:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BBF1F00A3A;
	Fri, 10 Jul 2026 20:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714906;
	bh=6ADg/hEbWmy/12b61reEQKb2Q6dpfi0RDajVlCkBx9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RwSqHlF5RvJEEn4ErgWmKYOk3ZNA/NYs5iVUHanpU0fENasllQUkcW9jyApuwPJUj
	 a7eN9NLCu0Ex40SgOC5Ag9dwZYp5JwadBsKdnIjIVVwzeZspTkROWs7QVeMFZz1mWO
	 hqbxrwH6VSB6kjD1KbfafnfAZjTH35xRIjD2wl9XlX0sHE9H/MpiCs2YTpkCNQ6Ud5
	 ZkLqfA1kVv4k2FJ2Zq63YpAwgUQJzKyU02SjWFjZAvR9kBXwvtaLKtdvbq9aMQe7Rr
	 aAdi7K9V3jayk8hMKG/qxFbOcOJLwhTs28jRl/n/kTh025kbHDI8CVvk0Tzb/sgyMd
	 XUZVvVRrktafA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:52 +0100
Subject: [PATCH v2 11/33] mm/rmap: rename anon_vma_interval_tree_*() to
 anon_rmap_tree_*()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-11-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12674; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QIh/wHED/x3vUIojrTapMUaEqiLB6lsiBuz6hviQqKk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg613Kvj0Tr805Y/Xh4rOO3+1f705tfZh9qG2VVk5t
 VemTC2r6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEiqUZ/vs37Vacemxfzzrm
 6T/Lfz6Oe8A7ScOt3yXny/Gd75l+TghnZFj+cFFc/HN+7gsK87a/nZDv+dvTXND9o8d81k1TdnL
 bBfABAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8353E4000A
X-Stat-Signature: jrsisqo9af9n1erfnggignp9bira6axg
X-Rspam-User: 
X-HE-Tag: 1783714907-294641
X-HE-Meta: U2FsdGVkX18AgmVgrzz6vX/CPEkvLBIV9nEIQtIUKss+1E+Sxu1sBhwMUYTIp2r+PvfrXxMthfO4+U99ZvxWz2MmfPjw39jFXcD/1tS7Om9aTOj+/xpZ28lO6QVyX1uix7gXOsCwABTmRGk3Mg10b1ytlPtXiPY5bYhpm6TRpZHI4usvlTDca1FqZJ7hhQk+OIgkobiBGcbqcW3tZ+e4gIed23i37yZMk6K8mmi7zZHdp4NWw0TOE2Z+FrSjIFEEVvo/ZlS5VneyXCCMfnn+l1q/9uwrNHHfzdC6eLfKfqwzWxnq2TKtlCq43rYgUTvKAxaB4z44xxASl8JU8t07AO2JICc/ii0SBID7dLGGzi22pzTAD6kxO/PJ5PmNaHBRTUfaNRUQj88+IkGex8gLs3Pkh0Te37pbRk0f8UOCDOVzW4IEyhNE6v41YVDxjN6prk/XniPFaL/b5MzHRcIfp7C3+kmPI+YUL9sy8efHaQbJZ2pU68/vkuzp58jB+A4BidxN48KhWcw/FMe/zZRq+V/EILoCTOb5M5v+JH3TNwACF2jJyMWOfxP7C+CGWkPYWWtjLnTNq/uUM+DYLMVONMZKqoB0v3t6Nfyf2G/ym9XrVjWXjbf6FEv5P4GXkzKWJdVxdRkqu/6VzCNBuILubPguT6ejx53+Ce3wuvbiX1bbYxND0eVAbSFQLys+kQ5JlKcM6lJe9A2fjL8YBSWPlNE7aKINCB6vinGHd6dOpO9WRqum8OWgOUtXtYYjVtDHbnekQ10KIhrtYrbpm0agViO0OfHCUuEDj4S6Fu7iBEKK6iZqSgNp72DSsWqE/JgCWiqoY8/IQh6Z75aq7ufxV5SLXqD2nS4nUXjUY4BlQWV9olrwfdmz7qfQ82q8GvGl8804qislOAzFzwQRq1iH5W1tRQLivMc0GWtHExlIkwsLsbuloSPg1ftsceySnbBtpEpKMoFIFL3XUN1E6DS
 ZpZk0IFc
 EKBy62hPq0dSs5NDWv0jckzJ0tsnOs2ZPMC2atggbhzj7AETCtNVp700LSi3/Tm7g6LZC2Ac1F90pPptzW1+/2IkpTv6NHQJCgYDITx2ZjiiPBC3a03qLdlX6tnYGEdNtFRmcFVlzVA/zbf1QCIKCKki/uBK1TC0gDVpK1gGUJmmIYcLua+DK0VmYvphvP2vuLdLYuRjsT9E8Ldfm12gdOK2+X6Ci7O9NVKcqqONjwK3YdAM3b3kugg3WtXRe09Hu0ECj1iWp8eznEiQLbd2vb2OFKQhpLjITtvD2S7tEVLRmYlwWXlUqZJDOLQy4h1GV0gpgXNQGyZPpqBK8E5cJEDJUFNziRxbgfdiKYyzOhXo/awfIBCUD6+O7mSKz0VEwEK4UU3NsWiNjzKT0XChzNfYTMcxJ/kZXBAO/bqQi97jnW8y7K3E+MmD4EtwDaBGgNTxL5sW5n+qUfKT6TQN0nRDmM1kDBSCtkuL8BqbIXkBfXXHqeEI1tvTIOQ8845uDtSH77RnCYYjS58NhrhoTuJ6akq2fUXWg6DJAyxNWB/mhZOVLI4ctPjQhfivtpaJFm+XGfnKdovwWbnZwuI/SDyaDXSC/tPOe0Ttms24LXbclem10XAW/8Fa4EDbe2xtZyoNoDN+/jzW0d5GvqnyU7/eRz59QIxEnRzedcDKA4Q2Xu5dLQsO2hqWyqbMrNuDawIiGG9VjbpEJG3dnf/jnZxNHIcn6JPAEJVl8WEZcr3f6IHH1aY3rKjVuXs1LgmpaJmdjf0fIoYT9sBjS/ipGwdIImX8aYmkiXbQKTh+sI1yAtsh/srAFr5RuDUk4NwPbuBESEYQnKTZfgk+bqV3lRWI49oZzF7cpSozRI+OwoBSgixRySdcoUSUzMYLYpE3BrKVzsFecYPbSqSYdtPpWocGpti44lHixP15aQO9EIRNbY4NLXZ+AArM5KyaTzubiFk/qER4XQT2Jm+SH/LRB5UmJqtqZ
 CJGhNK/T
 q8SiL5uIQ2Q0WGjt57nAPEMCJi27a2s7kcH22PFgSZP9v8kf+TJKw9gcP5DGGtcK/h34yCPPj/a7yWoBM+aQRxqyST5p+YWQyt3xGqRRBFjFxFRcAsKMeAM1L/dMnQWvhwKg+NsUgafYVQd1K5CDIW46sOLmLGG38oT7jc65Hks+D2vhh4xYlepFuf7qd7hOilMr1Pj2bi0ClfvnMI9MhkRuE6lIUUmSl+Wj39v+RMbFaRTICvLR8WtN22TKMGKRPy6L9uNcwX1eki/xr0CFg27icQNNuNceLjEeXvChJMoQ58fA6qhksormWnEGX2pta8bIc8lr+nmDBhYgB+NhCkPNr6eP0G2iFkJM0LwfQh6EjRHhSZsrKEBkakeAswy4LRwFURrAAfWymeAUMJ8EMJrs1UZbkJjXoPJKIVMpVUSZcXy3Nzcmp2v2pMlE2p4RAyteGg9RN4WG3Wzh6V63HKMzs4APDNr/prY/chgbLUQ9aCIcPOdadPPK8qEHXyXuZO8twpS7LSPJqriQzu17PEVtngfFFMGeyFeMV6aJbSDz6BjMkYw15suzN4rDU33pUdt1AXhhTOagAzSzplQt/9/4ZbiGZrerBukI6JsgkA+cq7VA5OMyjkGxMPQNBDB1AkSLK4AICVQ4d5FTKSXM105NGXBbXDQywhs4Umftwb7GRbPmzXKSO04hkB005wsf4Dz4N+O8IPGPKJyuVctCOrwFz7RPzCR2Ze5hyDONxd307diy1x2vHZc7Gi3FGxaj9A8gMsfKYDuMEQ/kpW3HbrsMlRobsV2rxWdsduvNoA/Quz72j/C5yNqmNnZC1DcWt93yr7kOR8M2aD7m07P0DdoE9miKCZSQFk+Va8vM37Xr/J7IJKAPH0gGJNje9vK5ipcbTVY7Vq7m4kuhb9rSFkR3jlLn/qESuxxkqeuQeDNL3zQZFiaJ2TLyIlyrbyCra2iBTexH3+vusnLivSmCL64CLnr4C
 vTCAxmmi
 hdYlrcT5BAPVsZyvVNy102sY0h2TU/dsaCI2fCfC4ZobMS6JwuJNrxel2k9eOM+xnAx0Jq76EfSettXDPH6HVxpyan+fK8CP4kZulqsw9ZrLmUgv/zTz5nU/AiWiGsXXdD44728Mph9B/wZPvqKrtzo8SkU31V4VCPgIAi3ibmBlEn4QAlwScrzLUMb5Wphrq8O0/VcatOgh9qcMMsernl9KU9408IE0s0VoWf1qdJOUHgTve1tpwqpoTWhEGlljOZ9VEIRlfubKOBNMrMdls0Z6iN9fGwG0k1/sCqpxEnZuLsc+LAfQw4hTsR08wcmv36suudKTh1l4/QKRHXPnrGWKCmPrZYAKgBh/kaheoTr0vJkxZ8O/Sx6gK5MkWf1cNLNhvp+RkJsgdhKB2sGcLHby0NdSW2bsebiRCNXwU+Cj0j0jERUZVO6Bjx6rMzUyzaEsfSfTIKUZbGJ+c3ruWX5ql3RsKYuRVOikh+AF4RRI5HGLDxilnCE5847iI6N3yST/wexAe6214AibWcO96WvYVayhqpGR28yum89sJwfqzGPITDCU1jMYrJZRJ82D+YHDL4Bja1bVFlkbmd9Lrnog4brFc/vmVPh9W0jZ/K0z9BfG4IbnTSzu7/JZKTuQOal0ttmI4CuZfVeku44lWpAplMJsuhb5l3pZJgx+s+ZsTGka9dj62nns1b6p2oRnTS8CN5hdZdRd16Tr2AxKdhmac5/nQlXTJOM67v4PQrPo92cb55So7aW/sx28SdZTyw/8u3M/ofIZnY5S3iQODqXAFhaEZPpAJrH0Bdh2oR2ihpaigWDUu2buFcNmo9uj5aWau4NXOLPYhQGUc7kpIVUFmwNLCgU4UzFMH3qYbBMVuYbgNq/TeQiMmnEGGv9IxAaIMTMRpfIXuHiT+G2NYZUlThQrj1c8Wn2/LMPf/pgvrfXI+apG5dEebioCBIAmXwWzn1fGRsIB5zYeCDq9RD6icmPzk
 IjU9UwOB
 NOIFX+F7r4s8xOINdDXx7WOcJRbXqa2dG24BkiWqNXKx940HJWpRhHY8GKXXS14x9aQpum9sfI/JtZsfj21x8niXOvwIMdaWA6uK/LGhsIHUq3XZol7XDCLQ75rqXOQhMYw7+Qxm7tkmWJIQh9FKh/iSisdX2+7+PMAftLVQBu5WY+MgYiQGINMiiXqdqOOlK169PafLLYHIQoKxv1klWmy/Mi4elB3ppwB2aw7ooTWpV1JcHKRZiAPlFR1xFOSh2OEb931klE999Paih9H8rKT/rplIM3Ae8OIn8dGVMcJy2Ucbu9LR6omM8M67elhSbgdkyA7Jc95GZnkcCuHoljihgACyZDXVOhYUr1izGj225ic6NHSb7zZXh5CQPngo2rhQxmVxPHgADsLY0znausw7tho8+t2w9ZA5vIr5p6mi2RwgPQEPfebeQ0e3j5LwWr3ewaNudriTNXewQB4ot8lEC8TOnhAtSXYBbCsmjtgY2PMyBtl3xl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To be consistent with the newly renamed mapping_rmap_tree_*(), rename the
anon_vma_interval_tree_*() helpers to anon_rmap_tree_*().

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h                | 27 ++++++++++++---------------
 mm/interval_tree.c                | 30 +++++++++++++++---------------
 mm/ksm.c                          |  4 ++--
 mm/memory-failure.c               |  2 +-
 mm/rmap.c                         | 10 +++++-----
 mm/vma.c                          | 30 +++++++++++++++---------------
 tools/testing/vma/include/stubs.h |  8 ++++----
 7 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ae7c976b516a..3d69b597b9b1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4110,26 +4110,23 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 	     vma; vma = mapping_rmap_tree_iter_next(vma, pgoff_start,	 \
 						    pgoff_last))
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-				   struct anon_vma *anon_vma);
-void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-				   struct anon_vma *anon_vma);
-
+void anon_rmap_tree_insert(struct anon_vma_chain *avc,
+			   struct anon_vma *anon_vma);
+void anon_rmap_tree_remove(struct anon_vma_chain *avc,
+			   struct anon_vma *anon_vma);
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  pgoff_t pgoff_start, pgoff_t pgoff_last);
+anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
+			  pgoff_t pgoff_start, pgoff_t pgoff_last);
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
-				 pgoff_t pgoff_start, pgoff_t pgoff_last);
+anon_rmap_tree_iter_next(struct anon_vma_chain *avc,
+			 pgoff_t pgoff_start, pgoff_t pgoff_last);
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *avc);
+void anon_rmap_tree_verify(struct anon_vma_chain *avc);
 #endif
 
-#define anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last) \
-	for (avc = anon_vma_interval_tree_iter_first(anon_vma, pgoff_start,    \
-						     pgoff_last);	       \
-	     avc; avc = anon_vma_interval_tree_iter_next(avc, pgoff_start,     \
-							 pgoff_last))
+#define anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last)		 \
+	for (avc = anon_rmap_tree_iter_first(anon_vma, pgoff_start, pgoff_last); \
+	     avc; avc = anon_rmap_tree_iter_next(avc, pgoff_start, pgoff_last))
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 5bfe95b5cd28..3ae9e106d3af 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -93,41 +93,41 @@ static pgoff_t avc_last_pgoff(struct anon_vma_chain *avc)
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
-		     static, __anon_vma_interval_tree)
+		     static, __anon_rmap_tree)
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-				   struct anon_vma *anon_vma)
+void anon_rmap_tree_insert(struct anon_vma_chain *avc,
+			   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
 	avc->cached_vma_start = avc_start_pgoff(avc);
 	avc->cached_vma_last = avc_last_pgoff(avc);
 #endif
-	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+	__anon_rmap_tree_insert(avc, &anon_vma->rb_root);
 }
 
-void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-				   struct anon_vma *anon_vma)
+void anon_rmap_tree_remove(struct anon_vma_chain *avc,
+			   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+	__anon_rmap_tree_remove(avc, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  pgoff_t pgoff_start, pgoff_t pgoff_last)
+anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
+			  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
-						   pgoff_start, pgoff_last);
+	return __anon_rmap_tree_iter_first(&anon_vma->rb_root,
+					   pgoff_start, pgoff_last);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
-				  pgoff_t pgoff_start, pgoff_t pgoff_last)
+anon_rmap_tree_iter_next(struct anon_vma_chain *avc,
+			 pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_next(avc, pgoff_start, pgoff_last);
+	return __anon_rmap_tree_iter_next(avc, pgoff_start, pgoff_last);
 }
 
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *avc)
+void anon_rmap_tree_verify(struct anon_vma_chain *avc)
 {
 	WARN_ON_ONCE(avc->cached_vma_start != avc_start_pgoff(avc));
 	WARN_ON_ONCE(avc->cached_vma_last != avc_last_pgoff(avc));
diff --git a/mm/ksm.c b/mm/ksm.c
index 10fccc22e5f3..b3fb59a0e0d1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3187,7 +3187,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}
 
-		anon_vma_interval_tree_foreach(vmac, anon_vma, 0, ULONG_MAX) {
+		anon_rmap_tree_foreach(vmac, anon_vma, 0, ULONG_MAX) {
 
 			cond_resched();
 			vma = vmac->vma;
@@ -3248,7 +3248,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, av, 0, ULONG_MAX) {
+			anon_rmap_tree_foreach(vmac, av, 0, ULONG_MAX) {
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
 					addr = rmap_item->address & PAGE_MASK;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 24d660c32058..aaf14608b30e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -564,7 +564,7 @@ static void collect_procs_anon(const struct folio *folio,
 
 		if (!t)
 			continue;
-		anon_vma_interval_tree_foreach(vmac, av, pgoff, pgoff) {
+		anon_rmap_tree_foreach(vmac, av, pgoff, pgoff) {
 			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
diff --git a/mm/rmap.c b/mm/rmap.c
index 6d4423a16c8b..e854679553b9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -211,7 +211,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_assign(vma, avc, anon_vma);
-		anon_vma_interval_tree_insert(avc, anon_vma);
+		anon_rmap_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -354,7 +354,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_insert(avc, anon_vma);
+		anon_rmap_tree_insert(avc, anon_vma);
 		if (operation == VMA_OP_FORK)
 			maybe_reuse_anon_vma(dst, anon_vma);
 	}
@@ -434,7 +434,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	anon_vma_chain_assign(vma, avc, anon_vma);
 	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_interval_tree_insert(avc, anon_vma);
+	anon_rmap_tree_insert(avc, anon_vma);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -499,7 +499,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_remove(avc, anon_vma);
+		anon_rmap_tree_remove(avc, anon_vma);
 
 		/*
 		 * Leave empty anon_vmas on the list - we'll need
@@ -2988,7 +2988,7 @@ static void rmap_walk_anon(struct folio *folio,
 
 	pgoff_start = folio_pgoff(folio);
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-	anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
+	anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(vma, pgoff_start,
 				folio_nr_pages(folio));
diff --git a/mm/vma.c b/mm/vma.c
index 2cd70f1d4db7..35ba3475128f 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -258,30 +258,30 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
  *
  * Before updating the vma's vm_start / vm_end / vm_pgoff fields, the
  * vma must be removed from the anon_vma's interval trees using
- * anon_vma_interval_tree_pre_update_vma().
+ * anon_rmap_tree_pre_update_vma().
  *
  * After the update, the vma will be reinserted using
- * anon_vma_interval_tree_post_update_vma().
+ * anon_rmap_tree_post_update_vma().
  *
  * The entire update must be protected by exclusive mmap_lock and by
  * the root anon_vma's mutex.
  */
 static void
-anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
+anon_rmap_tree_pre_update_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_remove(avc, avc->anon_vma);
+		anon_rmap_tree_remove(avc, avc->anon_vma);
 }
 
 static void
-anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
+anon_rmap_tree_post_update_vma(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_insert(avc, avc->anon_vma);
+		anon_rmap_tree_insert(avc, avc->anon_vma);
 }
 
 /*
@@ -312,9 +312,9 @@ static void vma_prepare(struct vma_prepare *vp)
 
 	if (vp->anon_vma) {
 		anon_vma_lock_write(vp->anon_vma);
-		anon_vma_interval_tree_pre_update_vma(vp->vma);
+		anon_rmap_tree_pre_update_vma(vp->vma);
 		if (vp->adj_next)
-			anon_vma_interval_tree_pre_update_vma(vp->adj_next);
+			anon_rmap_tree_pre_update_vma(vp->adj_next);
 	}
 
 	if (vp->file) {
@@ -359,9 +359,9 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 	}
 
 	if (vp->anon_vma) {
-		anon_vma_interval_tree_post_update_vma(vp->vma);
+		anon_rmap_tree_post_update_vma(vp->vma);
 		if (vp->adj_next)
-			anon_vma_interval_tree_post_update_vma(vp->adj_next);
+			anon_rmap_tree_post_update_vma(vp->adj_next);
 		anon_vma_unlock_write(vp->anon_vma);
 	}
 
@@ -677,7 +677,7 @@ void validate_mm(struct mm_struct *mm)
 		if (anon_vma) {
 			anon_vma_lock_read(anon_vma);
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-				anon_vma_interval_tree_verify(avc);
+				anon_rmap_tree_verify(avc);
 			anon_vma_unlock_read(anon_vma);
 		}
 #endif
@@ -3177,11 +3177,11 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_vma_interval_tree_pre_update_vma(vma);
+				anon_rmap_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
-				anon_vma_interval_tree_post_update_vma(vma);
+				anon_rmap_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
 			}
@@ -3256,12 +3256,12 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
-				anon_vma_interval_tree_pre_update_vma(vma);
+				anon_rmap_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				/* Overwrite old entry in mtree. */
 				vma_iter_store_overwrite(&vmi, vma);
-				anon_vma_interval_tree_post_update_vma(vma);
+				anon_rmap_tree_post_update_vma(vma);
 
 				perf_event_mmap(vma);
 			}
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 3a11547b5bd1..d6136e19a8af 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -271,13 +271,13 @@ static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 {
 }
 
-static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-						 struct anon_vma *anon_vma)
+static inline void anon_rmap_tree_insert(struct anon_vma_chain *avc,
+					 struct anon_vma *anon_vma)
 {
 }
 
-static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-						 struct anon_vma *anon_vma)
+static inline void anon_rmap_tree_remove(struct anon_vma_chain *avc,
+					 struct anon_vma *anon_vma)
 {
 }
 

-- 
2.55.0


