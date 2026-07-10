Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D02FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7396B008A; Fri, 10 Jul 2026 16:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58016B008C; Fri, 10 Jul 2026 16:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D205A6B00A0; Fri, 10 Jul 2026 16:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9296B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:21:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08BB78FAE2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:21:03 +0000 (UTC)
X-FDA: 84973986006.06.B95715B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 323B4A0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:21:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+OB8juR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0tTV3BrWU6tIJ5l/Y9xEK4eNmbUwb9R0gFk9DgeDT4=;
	b=lVRrJamI+DwkkngW34hGDdVj2nk1pajTmCZYc/Zd9bOqIwc4Bi+0O2IL75IQ87tYQI9p03
	SCMMyPwC8dRQz7cIQy6TJXuPU3hmpYu9JWmXUtLa8SfhtgKMc1Us0bUFJjU6ENwkK9NoSv
	1AIE1nf6bmX8/l4Q9fTWMd7DhPC80KA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j+OB8juR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714861;
	b=phx+AsOMY+LmoqEq3G+nrJVRXv9QQSvn4SD3AK9ccptH1ycNbp0Agx+EoaNbTsYDP2peR2
	sdHZYrWxw0m5Qw6Zhb6nZoQPt5RG3Iafq1LhSGm0+qnRQLb9rnqfe7izi4RE5YJXemNiU8
	Wm3TAOaCdGzDstUl9eD9efjihdO7pSc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81CC643AD4;
	Fri, 10 Jul 2026 20:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EF31F00A3A;
	Fri, 10 Jul 2026 20:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714860;
	bh=R0tTV3BrWU6tIJ5l/Y9xEK4eNmbUwb9R0gFk9DgeDT4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j+OB8juROnaYGwXLfZwFoBlv1YPzENHjDtEQkcu6v7D6M5XCrlouzYfKBbNPTK57l
	 cvMVR7x9p01YpTlj2sD7SYouV5KI3q5N8JqZ3t9uP7cbPHtgoV6F2pS496toVu9qjS
	 lZ+nD/bFg0kUcCh4cIhFV/vzZR3W0GQQZMOQiCoqLBXASzmRI6FZS3+1RKf8r/agma
	 y9qTR4W3TcNfjYX2rfIw4Pbk0yLLw1PTsPgeqKxpXoAB69AXAEsyqP4jQ9SW9aXp4U
	 ucid0ZBJvLx2AZIB48G5FV70lMXpTGTs8SO5iH5G6rkUHQBP97XHnI17hWc5f1RIPu
	 txMAUAjdf1xLQ==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:50 +0100
Subject: [PATCH v2 09/33] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-9-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8188; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wi2G0r+Tf1SXo7NAyf6w+thcPpRxIn45P/FeJkvlXvk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg61nzf1xcNZvTSezhx0laz3SFlw5+/6jqXrH0eVVH
 777WNhN6yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBErpoyMnR+fSF54xTX95Z9
 D1abHLWVjdpcM0dZjL9w38PNaoZ6Nb4M//0ZeGwMe6a3c22SdX/vcWZFmJ6B9j+/j8mSBxI/S3X
 v5AIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: uy4c8wzq4u7ftmsnm3ddrkrgxcrtb1ho
X-Rspamd-Queue-Id: 323B4A0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783714861-244078
X-HE-Meta: U2FsdGVkX19bmvgTAb39PLTFGbQSOpC9GNhIejiTv/63joNJAh3M5tiRJUaGedVAPDGdUPQSBlEliNnZSSVDryzs/Sr567M+43x+ewKRfwPDUgCmnZvkqwoYTQ55s9CseZ6XHl8/luEH7X/a05z0PUoO4Kt4aBf7Eln6ntXhnkaX2OptYOw08JYdkoINaXSMw89jyaOUSRxpTxHEnuAVd6CPhAZk4rpTk4D6lV+55QtEnjaMRBcF/PBYigCktIQBIsuk1oW0FE9MQK3BZx4I833HSbZJHlAUOLDfudm0Qh83MET7Av/lNaSGXWoxS8bxuS8oitQ4GamoPvpnneMDUpXDlHwtvh8hk6WOIHTxOIP02Kj/meNv8zfdKH4CTlkNIzfEiIbMKpXqe4JTNqWNmyhWJ5myVtWvrFdbDlivfAzbFIc0hFhgl1V74OSweNzXjAlTg2Ql3kF+ErMGmYHlcF4Lhu9NmSqybwBbBllZKsVKpLyEiezMINFQ7SGMfzGuAlKWf6NMdj/ogAPKE3ZvwsgY9DV9nS0q6OnXtjRgs3atTnvY0GxJV9ZlLVuhgGGwJpG2K1HEpywIL0qc1lBmVvMSA9CdGxE0Lp8T1dYhJ7w9Tt/7sz96kkaeeaU6L1xGSuOW6xbvRfGnD6hrBLhxl9kLDob2/iHJMgH15xpDJ0eOG0WiBs3r9falht1iukiGs8j60KdA1IdfJV/qviYcx75ceTlKTf9jiA60hVCMIufjoLo0uhYPrhu5nGuu4jhfs2+3jdMSSxKi93TrwA5UsfGC5+kONv3Bp7/UigiwMkX3RIOtVzCky1h8juyLAXPMGaHTTaoF01JGETeijLv/Hqvze9IsM650dunD7Ag6B5pjrdIAhKFFCUfthu9B1Fb1bgaV6vh14yP/YClWlnhZHnbQl1jpgevJ+g+Tm4e0mJPRT4t8UXLx5LpJ0XL/Cf7eBnOVuIq4mv8OmmlhKVg
 0Ms7HgQH
 y9ItjAFp5Pwtvxejmlf4M9smFR4K3MYHLaxLnfUvwn0cnaX2v2yZtWb77ggJO+/GTENJEzmL5zfBsZ8Qwccm2XAyMgtYPwVPlF0SEtWgxggMqXPc5zXyDRGkCc2WCKg2BU1uNF2dBbWSPUJ5BdnGMT7W+3hQ/k+BngIUOBg+NnAcfIuV8EyD5B1GUCGaKhokU2ZT81oLNvBMIWREUsZXDj3ULoQM8CTPEFwH6bv6IvxCqTbhNcyU3Byh2YLvGtPluaUdEdB9n1UKrd4YV7xeA05LGzXsMOaI+GGUvo+g+YJ4T91tcKDXs0rp7XZOM8et4CCqJFAUbd3XT7jJKrf0XROOl7gr0K5/xSE6pwDGWPbQXyYCuj2cM/INnLSLLAYh4BwQQAw7pIbfeHaAywbt2wCvb0CrkvqrjlxS0NQGdi6YZq6D3Y9WNH5BGiKXTKLgeVeFrWRKS9BU1bwt/RrhD1n2XrgbNj2WlvUfO8tXl21dPF1FhFtmtQaZgIN7NkV6liOWMABL06TcpukigHBVoTwOqCe2en3S22doSIoiB1NfPPnt6sc5O2urfGX3Kb9utLwiu+47LSToq3f+jt4UXxtFJ7OYXbNZNas0Hx6X6TVCuW36I0nEhxTWbpj89LQTDTh7LSbAPgJWZxIgKsUO83JtEdIhlH8lMsWuzcjvJEV+0ynvF55ZUlSHkt2TkBUa25jb+Ha0JyaGjQiKne7uJMOsPU9hWP8gzlRz5WRFmoFDZasoWr/f2rGAESzXrZifcl0wsQ1rdUXbW5Yrz3R3GNYRNQBaCWESfo6izBMUJKe9z+3UxP1BvpBf8gNBoHTgvzuQ6xM60X6CLSe1BFmVPiZ5lpSR23HA4bgdc71fK0dGkKROpZ0+eMBWvR9aF5FAYO1N63pDG8ETbVjigAdWMeCpJmhuCpnTsEp6qCqrRvFBUTcEi37a8pvkwq5IFt1Aey6Cn4dSHmGqp+nLCZWjBwBLIjPVC
 KTDA6Kpy
 0xwxoSeSBPG7DmLNaaVQ4xmn3ErQ5hRcNdbhFzq6gDr+E6PcmlmuffowLJ5gNZyp+jofF2HG63VmEKMm4Ai8XnRBSPvJ/TC9GXMhpfv0HNRYPIVccaahjPIdXyasGJOiaAu9Mx28jd6OpNNNImJNobMsSDJ5FkyOFNrTrP1ggex4HUnrMgbdgRHKEjtwMqXboXyxEbZ+dwixz4D8Uy5zgwEoXysoW6XJu57WRRVrPJ935onk/iXVq9XLtti1rjuMnxSiRQugeArvuKYJS66KTXOuUwLM5jZpUC4IBGQCiLT5A5I/5i4cOSWtli1v6qEfBsmNvxM8cXJirbyFObWiK6cDsnPhRDLE+Cw57945y3vUD8Iru3UjnK4a6Y45yeWBqX2KsXwc25xJzoe04SQQQxpahIowHU8ssp/QzYtM3uHiKVqSK3W1D1EhEzxhP/MZ+ZMXA26+lJW4dyBz8LCdlyNmfiFGpLOn7/Tnxn7lDGCVPkOMEM+SItKICaiJbFuxJn7DBtaLNd7gd+1rDV+fcG1/BY1IqFqSjRUxtuwjDbA+rAi8uS2Vd71RA8HY728GksBauAhciMAgWfkzpaO4q/TRltx9SAg5mURtGFiD5nGnW3PNguGZO/o0GNSAHzJQzZd2JDJ/GS/Ka1lDglwXf0uVn3g3pWifmCfL9abGFglSvsZgWKbceNCB802ssazvm4xvi2cywylh/3RJgcsay9GpW2ZhhN67kZyvwFyhN14+ET3FN6rGCBF3kZZx2aY2X6Xrs4Z7P67d90CnmbFaz7PF1nZOQMvdwGT3fMvWg8/SayMyUfKbnq6AzZu0pUmnaJDXO7zhDkhlD1Uv/x4VONgfJ8RMVwg7dMB09H8n3D3KG92rOlE4h5dKx9Qd7cZ73ZWN4xeiQI9wQ44qrrQAuHKzXRc+iftlcY01Y4uFBHEEF9gfkjX5aEcr8zw78zuxRu8HU4Mge9DIP6LpmSKeD1O6J+DMQ
 r4ync9X9
 v6ZiU/nRbyZ1mh+KiDUusYi19W0Zg5/sT1LYb/Z1H+U3rZIceQc+EuVRSxvjwclm8oafXaivEy6sWZ4E9Uj+C5X/QoQc9fx5+jkDWfYrcwF+hN0ya3kj22FW0GbuBJ55AqIMU4VD2wBryCUxxppvaHz1JuZHFTgiI1dEkj6ltraT8nUiFKEAhNxKvXd1X2U4jUvhlM+KZbNb7M1O38wEg7qZK03SSi31GH7FtxKjG1Jk9oHZyp5rR+oiho85mq1nTCFMh0RaP0X/ZSJowZFG9/q/bAk6HR9jA6Zf+rFtMhrui6ENIhopX6VSFhhGnwqH5T2ZR67a9uYAVKg1topEKRGQulZUweH8f3YN3n9VLFakoOAdmvpjFr53WU0PKYK7QWanQ50zlYKykFO4HleOqPkhZ8ukMraXvLG74PIvg5jCSoVHh2uhBS76HDHDW/h1RE36cnn0AwoRFD0zOOHdyq2ianSBiq9xflseS2LK/Whd/topnoagT7M6NgMxa3T609/N04XerDnyTa1Asjn/INOrzmAupyFf9RPMq9l1yX80lAxFg9lpXezQmVwETzfEcnRmaQNwgPWLQBwndZqlY1p0e9W1fGehiDCdb7ulFUcXVu7G244FTKpzLggC8lezvCZJpyqzWmBGy1ekHjWgH/xludlTQRChjA2xYn4xeETVxRhw5GKJbz9p6iNMBkAuNmaNuV4FJhk47Q2t+PLEXzLMHonT5YFe9hNRuLL5srWjnt8BGK2ph4KUyyd/ogvi9XDpxaD7SRi+7zNruv22EW62hpbzZqhYhGG9VBNFodIlN7hIMKHZU6b1tpXflKR1PdzreU9KY7Pz61IjXpyDmUj6bJbhGkLIZB9eCddR1thJepB7371we9idFi3ZbdO5uSAupzy/BKKLu5Q5DTaBnLZaZy1wEQHL1NyP4FoY0po4jQ77WtdLzrZ/+Te3yoGO+tNtNAz3cBMTil+sgyTQqyHNgLnzi
 RJSh4fK8
 mk5O948ejLZxmxMuBo/955nxoO2rgIBJXkHRX9CdtjwGPjtFgjEbK+NVpMudYlQBxQx7XtSifTQhGgKB4vKxA7T7a4vtdF9ThFrDy0QCdxvUs6xhVlnSpGMln6D6WWdOHZBzg27hT0rxaqYUKNSf5NuOg6h725s2H2oxwaX1V/iH2h34Pzm8mCAU1OIBLqwCbzEtU43agAzg5TK8jQ3CLXDV6aD0jtO767sORlBT/JuDmI3lAk/Vf4FfS0ay39FAMcuEekrvrS8QWVmND9arWhE97k5es4gq3Z5GhMXnyAmFEnxzouP2bGemdiZJp6zaIhB1mMQZdCcU7NWYP+ND9f4G/cxkkuR4XyiofyYbBf8wInoStISAi6ocuxrjdZerZj0/Vo3pHtQEdt5pRUT4t5WfVWzth/qOqPcTfLg5XPNuJO1JPQVqQJyJb2EnPSMBXIrbNZLNLa0V9u8sNc7ZNOfqS8fNHXIWBWdOBjOKjY1yqB6T4VWrQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to what we did with mapping_rmap_tree*(), let's declare
anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.

In each case the rb tree referenced is &anon_vma->rb_root, so just pass
anon_vma and the functions can figure this out themselves.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h                | 11 ++++++-----
 mm/interval_tree.c                | 13 +++++++------
 mm/ksm.c                          |  7 ++-----
 mm/memory-failure.c               |  3 +--
 mm/rmap.c                         | 11 +++++------
 mm/vma.c                          |  4 ++--
 tools/testing/vma/include/stubs.h |  4 ++--
 7 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d4ac9dc83ddd..5d825824f7e4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4111,14 +4111,15 @@ mapping_rmap_tree_iter_next(struct vm_area_struct *vma,
 						    pgoff_last))
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root_cached *root);
+				   struct anon_vma *anon_vma);
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root_cached *root);
+				   struct anon_vma *anon_vma);
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
+anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
 				  unsigned long start, unsigned long last);
-struct anon_vma_chain *anon_vma_interval_tree_iter_next(
-	struct anon_vma_chain *node, unsigned long start, unsigned long last);
+struct anon_vma_chain *
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
+				 unsigned long start, unsigned long last);
 #ifdef CONFIG_DEBUG_VM_RB
 void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
 #endif
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 39e020555910..b82d2a0d9c4e 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -96,26 +96,27 @@ INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
 		     static, __anon_vma_interval_tree)
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root_cached *root)
+				   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
 	node->cached_vma_start = avc_start_pgoff(node);
 	node->cached_vma_last = avc_last_pgoff(node);
 #endif
-	__anon_vma_interval_tree_insert(node, root);
+	__anon_vma_interval_tree_insert(node, &anon_vma->rb_root);
 }
 
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root_cached *root)
+				   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(node, root);
+	__anon_vma_interval_tree_remove(node, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
+anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
 				  unsigned long first, unsigned long last)
 {
-	return __anon_vma_interval_tree_iter_first(root, first, last);
+	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
+						   first, last);
 }
 
 struct anon_vma_chain *
diff --git a/mm/ksm.c b/mm/ksm.c
index 41ab25aa2a82..10fccc22e5f3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3187,8 +3187,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}
 
-		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
+		anon_vma_interval_tree_foreach(vmac, anon_vma, 0, ULONG_MAX) {
 
 			cond_resched();
 			vma = vmac->vma;
@@ -3249,9 +3248,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 				task_early_kill(tsk, force_early);
 			if (!t)
 				continue;
-			anon_vma_interval_tree_foreach(vmac, &av->rb_root, 0,
-						       ULONG_MAX)
-			{
+			anon_vma_interval_tree_foreach(vmac, av, 0, ULONG_MAX) {
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
 					addr = rmap_item->address & PAGE_MASK;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 66ae93c6d4b2..24d660c32058 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -564,8 +564,7 @@ static void collect_procs_anon(const struct folio *folio,
 
 		if (!t)
 			continue;
-		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
-					       pgoff, pgoff) {
+		anon_vma_interval_tree_foreach(vmac, av, pgoff, pgoff) {
 			vma = vmac->vma;
 			if (vma->vm_mm != t->mm)
 				continue;
diff --git a/mm/rmap.c b/mm/rmap.c
index d3d3d6cb17b8..6d4423a16c8b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -211,7 +211,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
 		anon_vma_chain_assign(vma, avc, anon_vma);
-		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -354,7 +354,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, anon_vma);
 		if (operation == VMA_OP_FORK)
 			maybe_reuse_anon_vma(dst, anon_vma);
 	}
@@ -434,7 +434,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	anon_vma_chain_assign(vma, avc, anon_vma);
 	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
+	anon_vma_interval_tree_insert(avc, anon_vma);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -499,7 +499,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		anon_vma_interval_tree_remove(avc, anon_vma);
 
 		/*
 		 * Leave empty anon_vmas on the list - we'll need
@@ -2988,8 +2988,7 @@ static void rmap_walk_anon(struct folio *folio,
 
 	pgoff_start = folio_pgoff(folio);
 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
-			pgoff_start, pgoff_end) {
+	anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(vma, pgoff_start,
 				folio_nr_pages(folio));
diff --git a/mm/vma.c b/mm/vma.c
index d99e2088de4e..2cd70f1d4db7 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -272,7 +272,7 @@ anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
+		anon_vma_interval_tree_remove(avc, avc->anon_vma);
 }
 
 static void
@@ -281,7 +281,7 @@ anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
 	struct anon_vma_chain *avc;
 
 	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
-		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
+		anon_vma_interval_tree_insert(avc, avc->anon_vma);
 }
 
 /*
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 37f81b11e8b7..3a11547b5bd1 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -272,12 +272,12 @@ static inline void flush_dcache_mmap_unlock(struct address_space *mapping)
 }
 
 static inline void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
-						 struct rb_root_cached *rb)
+						 struct anon_vma *anon_vma)
 {
 }
 
 static inline void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
-						 struct rb_root_cached *rb)
+						 struct anon_vma *anon_vma)
 {
 }
 

-- 
2.55.0


