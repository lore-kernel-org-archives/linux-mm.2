Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B49BC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86BC36B00B0; Fri, 10 Jul 2026 16:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C336B00B1; Fri, 10 Jul 2026 16:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4386B00B2; Fri, 10 Jul 2026 16:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE086B00B0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:23:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0F4C1697E0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:23:44 +0000 (UTC)
X-FDA: 84973992768.14.CC7C0B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id EF5B1160006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:23:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d3dTLtbw;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aND6ZTrK5aCnF0vB/hvCQzWPNkI/PGqvLHzAGyQuss=;
	b=641P7Jb+RtRxqE/hf6uUTxjvXmf7zI+w9+v7nSzpfmvh2RlL+w1HSkYdJ3JLDxYGIPm2lB
	mF4ZIiYFgc4iBl5t1+y+u7G1VP0Aidwu4ZvQf+VPnGItr+G5Fx/DsIKmwZVta6vqG5peYq
	UyPmhwhY2XG9Lgb1G74nMFpDGdAYoqk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715023;
	b=5Th2ibKNNXieoqG3ujdpvZQDVkYIEhgC/fQRG/LRBPQnX3OIbo3TeIZTKI3/NyVnlUZePM
	0G+bM9KcIpUQAhchb8tQM6GPCowN85j3mZD/0D2CDMkkf/M5GJaAU/LwTtIgjVObckR3ML
	BX+Ex79hv6Mj8AIKdFVL+TUHmIkT96c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d3dTLtbw;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D8776111A;
	Fri, 10 Jul 2026 20:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A19E1F000E9;
	Fri, 10 Jul 2026 20:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715022;
	bh=2aND6ZTrK5aCnF0vB/hvCQzWPNkI/PGqvLHzAGyQuss=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d3dTLtbwHpud6iwAczcr/G9qOssm4UAuvj4AITz+zWpoo3DzOVp4gv/8j/t3INWRl
	 h2iqumoE+G4TsrZXl0JhrXm1DZwp+Xg3/+wksbc2t0H/PLF/RGB/5vKhFzP677NytU
	 q6MV3RVJSQRNxvQnBeZzwMXbXmKkia3AIRewaLGVCnf5X62tPiyvXhyTzEoOmXSEGC
	 7JJiwAJmtNQpNHVWkspiwndBidkwdss3Ra2oN97KJrOwhYLngF5H0St0YiV3hmYCXT
	 mfa+HnPzm/yNr4CqvgKrXrsT0Jsexbb8zALJKBx2Z3Z8c8MYQaM3JxOThN0dU2Lcc2
	 ZnfBU5TdzppUw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:57 +0100
Subject: [PATCH v2 16/33] mm/vma: minor cleanup of expand_[upwards,
 downwards]()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-16-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2119; i=ljs@kernel.org;
 h=from:subject:message-id; bh=fynty0cOXQIbsI8Im1dMU82VMgwlvpXxQo8CNb014Ng=;
 b=kA0DAAoWz53NioHifxQByyZiAGpRUzzIuaLaCaR4CfWWXA/TVMCwmdk5sAWWI2+fuF7yBKZGo
 4h1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmpRUzwACgkQz53NioHifxSSHwEA7mlE
 x52NRnGbJn2diesM85ALQpE3tCi1SqD0qgxp4fkBAMrSm0IQy3xvIXv/5PUxUHYQwVkEyzhhVNm
 YRBxFnqAF
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF5B1160006
X-Stat-Signature: p3bdj668jjce63gji1ssabu5ytg1j3px
X-HE-Tag: 1783715022-490853
X-HE-Meta: U2FsdGVkX19xinfHZWysUqkALRjmS54IB39NUodg7Qq4KwBVgS3o7YNS+xu5OTGZMKlO3NIpNt3G4oc7V7hTRJEHIsmlUSmwfe0qR8e9DTuZOABo77rnwLVu60UIFsxR0tDLSI1GxI/yabF2EDftM5Y4FIcPvM3DqDcnC6K3klBxPYqTVM1Hd9joN+ml/Bk4XXll0mIkKJRFsFePMVRAxskeZqpDo/W5PUPKF8p3sUffVEznFiz7pMTFBvfzhMwA8f3Bvcvu/ZsPfZaJmTe/DxSqVRaPvKEj3hnqhxPzWkyF6Nbd9hZzYxb1BrCHbgBvcWsLWc4EIF/d+9b2mxYwxmBmjXinuYVvSvU7mpAzF0BzLKaQffsMuWyMiAkTFecsGgKvCf2OwqeGTvqcuf5xy0/+HcOTpQ2o9c2WzwzJlHlR2oqeI7dxpZtJ7yFC6zVvwW03RX3Vd88RR3WE6ZSbe1ERvo3/s9S1Zx4A25xeRmT8oS8ACp9xQfp5wuPVs5cFngY3D5CS8PIix2QeQdj9QgU460/bFKgNnjEjuJuPqhXVobkhJVtQjmOA13OWYc5bp510GGzojVsy2uCUp8c+dxaYIFciHN+DWXt2kRmkqz3zxAO4ITVyJut91J4ILsvBRz2jS7XbKJ3OW7R2gSCQ/Zw0d9UJ9UiWXPkmz78rA05uFM9EuDAJYs/1B2BFPTjsuPwTph07rU2mZtWmT4obQxgCpTgfDhgXkEdmu2tIipHAGPSJ7TpBhbZlWH6Dt6/HDP7ysMiw2jPL6IhFbBnOKzYyNs4g+dKVOM0ZNTvXvpBhicc7T73Sx95JrwFO/ShPgKZM0cxKCsuz8cs944JCh4c9U7iVj58azCDP+x1DdCmcT/8iQJeyF3gBf6Mz2W3ArReznHDwPh2hr9fm/EuOGaoh3zyutMwbZqkTkUbFvu7hyFx3iSaAgzcMWO01TkDqXJMDmG6ikDtV2a7uDOj
 wnkxEdhD
 Nfnkd/LiOKjey1KGV++8KRSV3fSFufqtpX/KNQaj5D2Z028S+MAkJobkcXxUO+CcO/6Xfv11gPMjPqBuJRrOZ3Wo3AXPI2yy7VgDYbcO5feKMCqYyVK9BHOWNP1UG+dcHXS0SjU+tsvjkotamp92HvcNRhBzkjjj/sZn1hxHX1iy6PrVqs/cau4Kg+7FVv4ccju/I4QwPT2u90d9cF5XnRHW1MVWI9v03AUyKCdXD7kYWFZ60HX+TRxIzptfEP1SmyWBNotMLLn0xR2wOARh05vLxf61p1RlxGhOHLbGqt+TScoQiujteqbrHrWdSYJazOrOF5kCcWDTnL6v3ujdmsMwZJa1UoQLpIz+6pwTPOXpcUEl9W96o817UTHEjuiclxpn6RyzKsBKctybNOzD+LxgNAd145qjRHNyiZ2eiT3hU8GohQdLBI1RcB6mJZipvJ4cmZTQcGIUKF5xWwnWg48cWY6BUUZwmZgJJj81MwpKky5E4Hc+mMBKVfTZwaC3yK+RozQOKmE9EkpnXfXbWC1RAO6/JQ1wEWKugYArm4dPpgFK6j+1H/u32Lu6hpEeEWIJFHbJ9FWODFZAamv1kK0BdNCpQMMnDNJr+/i1U3AcfcD970vYvaKLz0hkTFkuWabliSAofMYaf6tS2rynQt055inmPVMXNiOMybiplX07b33QkNym0WAxMkTge5qVBJZp/rHFdW3fsYjuoRulzELijcmQIRSRR5tcrQiNQ5XY39jjb9USBrSQc4QNjzMYa6UbctAkF9YihpJ+DEqeZoImJr8D0FPT3c96ExP5b4x/halQU4TicO0f+wCDd/UElWs8+avDygdWDeB1gMGkpDkueQLIrTu/Z4sVN66OsEezF3MJlB0Q4BPVyQhCkkGq00lDXoWOvXwVR/8qxtkvJok2KIudRPrscZoUc1t9bW5fTfP+4ZuRRNjLogRVn8rkXusGNO10C5QmXBcCDun+YVgae5APh
 nVVuSNWR
 ukPHqnlegrjAEFbaGPn0eeCy6h/+xVv1v3ZgXh7M/+2tJiTY62ajXSuZahzZD0qjv8KTaIIAoMMwzak9sRqe8Xf7GxMOE+jhnMFl9jGc0W9Z2vzZgjybacrvvEvcOoUW04c1dussJfv1F/agG9Ta3w6jeWxFqpDvBDmTSO7OwC3J1QEuQikKcIIRpbVdivw3AeAdUcWEWBvNCgxX4ca9GlKdbc7HFDLoeHIiee0l+57x255x6S3Zj3JvCMUdssvSz9huGBKVoraKoAQYBRdPOqezFZtt/uuoF0KZxGh5vHz33/TUq7NddAgWjvBSssANF2hO32zoT32ucHA/X74nAsUDWJxl3ZVNepdCqZW9zjrPHHIjdciYWaqD3cgR7jDqdAR0eyFoQTJXgnXYWzk+6tiQpb+iSc/Kidm5LDwVnaNBe6Zj2F6nVet8YAgtOEH9HfMbSCCkQvWarEjvFjb/V+vr++VgeftuONQE/+3BB/yF9rDV18qgya0qxGtwRDy2PSN8VQucfD+uPR7HjibSaCE1TvyP0PZsw56iwuH3VnkOiKVTZUqJEFiWoZ9EjNveDHcVsQX7LPUYw0NjBzYXzua4mrGHIAwBZSjmoPJRv61qbb7Vf2dw88Fy/cKqWe3TH15dZMBXTJsG7PltooV5S1DhNlsy+jQaOPzYxhRhfLc9jX7Qdjx3A9pExsMHC17QcRW30mWCuHik/SPTv3Mgn6Qzlpm1K7M+nhgF55CE3mn/KD1fyA9oovdwEiPmv1C8Um0EfrhVj1E0MitKY5nF7xyAMn81Lx9BMauxJfCoYBMQctDK3ueD+M3m3mN/yw0+217LwGkQhTAuMAr1m84TnTIXrV7hNOB0D0EeGQscl/FVrx2bC/p3LsmoZrEBB3uwlIvY0ydSB12KENcHaRe5aVOCXOAp9bvjG2CSpLDZOXl9RxzzjzquQ7Ko4wkykaVg42LxSUBa1yWkYr4V/rKocqyW9+8xb
 dgvTxa5p
 CV5X4T5ZCUk7M7nAIpA3vG6bYgnqyM2fPvHf9xJuRLIcdoJm/wk+M76cCvz5m49dZ9y9dz1kHzno9mJA38z4m1+qHXknh3iOshPlLFIc9H2P7Pu0N9Ez+3/xHwLWYQOjV+oXRcrnDc+KjiNVlcul6nYi+J35RD3RC9owvne0CPkGKZh3ABR4cotyoDA5CvjjVYDogXO3G4MLEvARcJh0g1JUBVBoVJc31Y+FeG5dQz+0TodrwRoULbwDAciVgtaEu/2DGAW7jI3MwkmovaxX1S7gpUhTSudIzGb3v2o/uG3FEaLu8JETAYkF8HHHQTANkZzuBzXuBO5LTpgCtcaczJaNa5sT8b82X3SRBuo1MsByrqgpZ2PkgHLdBmxU+QjJ27CSaqy9stSOC7X1B5NlUxPp9s5kIocDNzxFJzwzk+guPafHRcDU9kWTPczIccZON69P04Wzwqae9Q273vA1d3DM/Vp88f+eyNJgozQGiHGaWchOxCHlwXYMJ7jxYAuWqS6NjF7vtbMtxgZPVMrQyN4rQAGEjj1XAAJolMhwbynM23X/AfzKw3kKcSDLUuosKYjHcukhh2ajczS5yntxF4NBHMyhBdAgYBNV3Ze9aUbdPVn15rnHrySAQQDoXpajY0UP+gmUBIpSODNsHulI/9X44R9EGo4AgVrqRfXzbsUuurwygQgER/mcpJ32ngCylQCIn0qcNKX8xKdr31HFykGidXW2YkCF1q5DjQzA4DOkGITD+YPFaqnQqYXfn3rvNkUeGnUA3MPeoE3YePRSEObYADkzwOWlfZfAwOLEFNTK0vKAzV8pykUJSFw2SJ0LRtrZ03kQKnn10BoQaJ03QDnxyb0M7kCuISerdBq6cmDLlY/QDoNy2eKdadgkmaZfVQLKFCMEGxqX+iglBH0weoxgYBsspMQ5hQ/K5aI1/47+wsrLoO8Qq6f5DUa7XrUVHUNMvOTJ2AEqdT8QJwo4DROnrNdeU
 LxE3tA4c
 YY/gip2bOIKkIvpiTPfEvUvpUgBuKGdr9NPP+dXDS5T9O4OdVeczr4vBOoAkQj0ypZQNguFUHqFGcwjgR8yEaojinSaHT9+a9rGOOUWc6pHKR2+pYDKW0enYJwTMR+2pNmpbpfJ4WACESUHIP2WT6/id1LKwkVZwXpCV7auCHByHig35vVNnEpNs7HRTDiyEUxt1nzJZWmZF1FIpGdZ3TujP8f5lruaA0TV6WZ2QETvrfWvLU/Pn1tfSfUQHDBkt3skuqzbtdfJZH+wDo+CpLyCfMqbUyELTR/6THWWCLX4mcG+a68CVOO6DfYMlh2JDIyJl32ZvkehLqcGJ4V+tT32TVHeeWlNxqEr9lhmMUkHM0QOQ+g1ONqhk+Fht6L7SnRGz0sgfDiPKdlRva4DM1RnPsqzsuy4IZ8SfZBo1ZO/5wi+ixPbSYI1PagHnchvgQWBNLCSVwvi27+/CDkxCeUhJVMcAu4+ceZF7FQMqh2JLHghtF0uDnXRlVBWDruVn/iKlZsWULVConrGYCjmfFgHCWhO5NypTDbSv/YiQZyaPfbSiscNTqQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adjust the stack expansion functions expand_upwards() and
expand_downwards() such that they are expressed in terms of named constant
values, and make use of vma_start_pgoff().

This clearly documents that we are referencing the page offset of the start
of the VMA.

Additionally this cleans up the overflow check in expand_upwards().

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 7265a054cfa3..5d5e60ea8a25 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3216,13 +3216,12 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* Somebody else might have raced and expanded it already */
 	if (address > vma->vm_end) {
-		unsigned long size, grow;
-
-		size = address - vma->vm_start;
-		grow = (address - vma->vm_end) >> PAGE_SHIFT;
+		const unsigned long size = address - vma->vm_start;
+		const unsigned long grow = (address - vma->vm_end) >> PAGE_SHIFT;
+		const pgoff_t pgoff = vma_start_pgoff(vma);
 
 		error = -ENOMEM;
-		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
+		if (pgoff + (size >> PAGE_SHIFT) >= pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
 				if (vma_test(vma, VMA_LOCKED_BIT))
@@ -3295,13 +3294,11 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* Somebody else might have raced and expanded it already */
 	if (address < vma->vm_start) {
-		unsigned long size, grow;
-
-		size = vma->vm_end - address;
-		grow = (vma->vm_start - address) >> PAGE_SHIFT;
+		const unsigned long size = vma->vm_end - address;
+		const unsigned long grow = (vma->vm_start - address) >> PAGE_SHIFT;
 
 		error = -ENOMEM;
-		if (grow <= vma->vm_pgoff) {
+		if (grow <= vma_start_pgoff(vma)) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
 				if (vma_test(vma, VMA_LOCKED_BIT))

-- 
2.55.0


