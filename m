Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACED6C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 19:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87EF36B008A; Wed, 15 Jul 2026 15:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E4A6B008C; Wed, 15 Jul 2026 15:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D3B6B0093; Wed, 15 Jul 2026 15:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7F86B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:51:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2254A006F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:51:58 +0000 (UTC)
X-FDA: 84992056716.03.9B7EF0D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9CFDD40008
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:51:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lJgKKfhl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784145117;
	b=I8Sr7yRHUiu8Mfx7kjP9sn4+mQJ/GKErVBD23J0FpzeKmQJeU7I8LssX+U2ESrglHE2Tnn
	NOfgC7aTlrk5wFzS+rGCwoSTH56ZAIxJJ1nHxX0q2D93JVfteDmdxmp40W4rLcB6eUTHtN
	F+cxnkuoL+kkVSNbEVmYMoIpPbtMvEk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=lJgKKfhl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784145117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qECPUV5KWvny4esgaF2Vf7PlyZR+bR1BGzMVUFeolqU=;
	b=WukSX+uhiJtaeF8CTJ10lJOtJ86kZqVNMIgNFB5CflbQo5JbdtIzklZpYJzq00Twj3lM4G
	TJmchnWFCh0o/5bKhckvuAsraV9ghr1M/yFVh6mrHhQEYQl28Sc7e4PdAnqZwCozyymxiX
	cRiMHW4R1QNu0EvG8v+qIgpyZYnpaLE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qECPUV5KWvny4esgaF2Vf7PlyZR+bR1BGzMVUFeolqU=; b=lJgKKfhlIrhdAC1jyT5Hf3uPxE
	l7vnGovceMuPLVWPqgV9wNKl/gQuYIaCna2P59iOxwIjz8TgnSZxKIXp5GeAqkWZQaTeT3+cubzjK
	HGiNQpMygZIeOjVTO50mffhkjlNpKQVqpAAM1eEVW8Hs3fCuJZ+uAhYmyDBNCwh9jTJS9/Q5Y3LVu
	ywLG36QvrGrHdJQUhM57vSlVQ7DI/PmUKWzLTbToYJXiR4beiet5xPyeJKLkIRtK7Wmpn2r5twtYX
	SVWE+upv4jajftjr+NcrbxoQcLUUOncC03VumZY0PwcxCLxWxWB2Ce3O/uWL9GgzwaAmWuf5JkTOn
	i46gZwWQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk5dP-0000000Fp73-3ueX;
	Wed, 15 Jul 2026 19:51:12 +0000
Date: Wed, 15 Jul 2026 15:51:01 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
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
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
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
Subject: Re: [PATCH v2 02/33] mm: add kdoc comments for vma_start/last_pgoff()
Message-ID: <jwtocg3yekest4xrda4fhzck5tcrcib2mmzjztvi3jk6i4oin7@xcvem5gdkwa7>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org>
X-Rspamd-Queue-Id: 9CFDD40008
X-Rspam-User: 
X-Stat-Signature: a8zpfom1yf6fstmb7tdyw3wh968iaod8
X-Rspamd-Server: rspam03
X-HE-Tag: 1784145115-970307
X-HE-Meta: U2FsdGVkX18GWOX8+5UuUxEg6Yl3S7ImHIwlVZsfKyjoZ3DKcG4M9juqsWDjZ5ZmBDRilWFG1pzymakS2ktZVtp2r4ukzp2h+0u8PmyfXZtfTXsZu7zLcwSI7dDWPpR9KIedIESAgbqbvWtrDKGlMLrNrWHrWcGu2DvVS7EuUIlvbQtcou0d7eRxUbSWFIptoXh6VzuIScBJE7Au6Qdzp6oiRF3lxhLpMYuPrW2l+Z0N2Btij8stejMP80ehyGAYSFzMBkpQVLCV9/GnHxDfEgd0+sy89xGNAG0um2wwPW5iDz7tWH6kZgt/tydZMtINcH+hCfBGUaCn8AgT5Ard58oFWm2Y1r/X/rDccO3Z2V/FSegXISCRR8ApuBOm5jUiVYosI+TcRkAnyzb/vaedqr8RAms3koDwgSkvRc37039GWIH0h8qhau3VfJNZFFiR7WtyWpOVDLjHXLIOylUM8jZFo+/ntivOezuAWgAjnwo30207kYLcw2lxpwqp3pVwTG+ocVi+mJwTSNJ3rMFuE80zcjkH0mRfOf5SUHIkgxbo2Idrza6m40hbWsDBEOQJ+RUxuXM6FTQAnDwZuT6izOA8gLDWev2jGuYSH4yqY3kFGN0pY/DdAi1a0uiw7fcxjLDGFuo/IKiBCcjR8kSgTt4Oixz8GmTIC5IohN0owFYpP7rNarVHRrbkKYyiKYp4ffEnk0zWTs9NUcT+8iYc4eMIdl/jOI/uQeHf/vK0glD3qRlnx17QZdHZT54OX0jEhTccxKKwdNcmeS0mNZsKsbaUhC0tEHj0uRP2xpBXjf/+Z29tOCxHMQEREz51XM50W3yd55fFfRKT/BAK4tHhgFB1ImfR0uBtUv2DwOrsDdyyPS1PZEApTqzfzwKczjD6DZ5loUdnqkw6toRSBD/StmMCKgloo5pnMTEe3A5Bo1XQPWfTCnB3t623ub6jG+xZ4iNCCkQ6utqGSWXHCCz
 Fj4u7U7s
 lOJMe4H8ChfjsgrIOS9cP4XE0YSaSoBnB6adBGa2uMQq+qbAESQzMtwUpVnytBn0ETQdC/5IYpjoGHpdZmyZFM+c2ojFDV8+SxWuIRgAL4L7a1BP+AbbcEfFXWNgztME0B3mVDHP9A0XPEs6uhAlYLZ56vtxQrXrL5PoGJhpcHLrbgi+jyTgbbZcQgPgrIXoaa/8O8uMC9RfhmqTbDXIpQPm4oswJ7weg40dIRpnTsrSwg7XK7DL1xo2ptRT3h4Sh9K6wc5Cj2sz7T1LHDBQeEdRUeAsZdSb2NXQpC3QgQ9TS99Lajtg4xjvEDtiPyG5eynoY48EHCUfh+6izgN1eGTHa9ISWpeLrQeg8w4Jn3mSzBD02xxhKptAm9tFLxDp3iPfFy6e7mAeBROVnl/d5awtQRLHk+ixN0dJ1kbdPGXDAQEyeKlhC723cfFNH8JUX7UnA6T/8YoA5uWhEr1P1DLWDrHQrcWl87c8kgpWqQ+uGOYHVQL8Ui52VPd2EgokCjsR+JpnfTf/Z6Hq3z6j+2hverO513c6jI7RPtRiZFQflw9p5PexMKTiUk4SSLxOCuWeisyhaQVcMZjsldwNTUfvRAYaYSoTbjMvRQmz5Gre5UE5f6RNWiHeNHOVPcZQlT3GIzTC1p5jl06uv1t3epM9QE/PtPJZbrRUPU4r7HJJl7fzKIxSkt8fl782mtPITyV3Jq7qeEQuLC51D3FmFqZmmEZMuAUGXzbuoY9MrS/DbHv5Dmm6i3g5wc3Hrv3cua1max5mHBTg8U+HcY1m9epiC/dCknxo7aF7Yz6aAqKQ6ag22NjXpuJNdkxzQ8UPLuPwN83MCsNbT8FE9lBVYj6/ZCMOq6rl8WFVmTRZ9gDDZBChys2ibZpQta0McHVGMyHazFCgOiuR8eduhFHX5JXE3StGPobRt/JiMIQci4Bn0J27rlls62IkEfOuZiCl+DVLXK2JieL8atClT26oIIpcMfh7r
 Dt6FPs2i
 QOuv5MKO5wqa7rcpc7pJkT9QneXH3pq9NZDeKn9+R9D6Mblhc4KQ/JhmJvzZYN3FtEJMv4jcrxfmKzWaSsGQtBysSWjNwlsMc+GJaoMxs4TN0zALy5ay1g7vZ7ivGeXMSuSlxl1iMriNhkkNmQZFE2GxUJZBaetqwAYZB2hWnAA0g8vloGVAhXGmrz4j1ez9GG9Es4uIgw/Lz9J+7MoNHcmIsPkTwrQbHsaq3LQyCwaI3E2Gb3oghWphLgQk7Hjf1zN4P3so/sv49wSFay2xBbD1RVmTc01Kv/uaT0dkdC2tj+L+SKwrl1hnyMPJXu2HThb/F6Tm9yTYrovTPjpc/mvegja9ajdyKMP03bvQRm9kyKlCmDz+PFyiJHcFwDjhXuaB3E8+kBDFhbw3A4q3z3eei6jsDx1TwoQhjRYkd05yXpTHM7LlcNBT81mwhXTmIhcP0y0mcEDos6sHDNqGEsj6Tqc/OiXF0pGzsoBsV+bp1IH2kImn9LXObfnO34+qJ+KEaVk2b2l3vAi2qbzKp5XKQyxsqKhKon0X3EKJH8WbnRbgYQZleX0Uoq5ive510ydOMl2EkXWY1DHxDjLpLbsqijapaEjnbvsAT95SFsvobVAC1iPlTNEV8a0X1NEhQUOUNEl6h4jdQsaTIWdfNEwKsiyLlTHqiSywM7vVZwL/4IlUEq4s99JIBfubbhBpi8i46HX9HbLcSX6arSrMyJc1mT7gu8CsOcCtcDb6FfVAZf8cHHxNCVBns6cN2vSk6MHd0WNY80shtkCrTZh6IlKwsuFLcnjg0AkweXZcvpzgIMegtqwHze/7/ffMi1ounUOlLlpurFpdHIiRs694FdwxLgeIKsVS/Qny8gP5e9uRQCkaYZ+A1Qi0eW7chUInvIQPp5RjIQviOCO0DR0caajpuTZz7kRn/ayfPJPLKYd6KzLDtntPw3iESm1Nc/JeI0LZh1+Yhf+yQ3DGc6DRCaxXbgfvs
 fHwjxZ6c
 Dh0ynNy3oxXA9ntpCs0mgZGMUX3SapRfuKap4MB0kx/FTTocvD43I2BcoAIO86rgxC2G9X7dfu6iG2EqOxY5qLQej0WtGnzK8QAo59HXBIp0KXNX4rcQIspt8Wkl0ZuaXq3+N0/nSkrvcVNMisr7zCSvREFSlDT9ECIk6M2HKmxZQl3yQqun9vJtq9jpV/9r70zkMsH9wt/YdHQy4e1O3vQkB6etS9B+nzpC6GydoRp+rBN2D72Q0SoUF6WCNkk5zuaK3dPli2cuPV/FsBLEXaw8ub55RNPkZ60/97c0nJMC43VdDrMWlhQCZgol7wvJ9qV5hMrojNS2jxtq9zuKVc0xkk9vIL7gUCC9/hTIvmutGiFKv7nxEXXw0Z8VtRzvFE1i9gOEmqpi6U6PwQfcotSfmI4Tx8eMSw9OaaOoYmWGaNDlQ6RVvyR/Fh+y+PrIWSyfTCnwJ7vZLcjbR+aQQ9wnSkfQuOfV/7uI+JJfvFBej8ebFUUWRyDrzyS4pKwxXlIp4k8mh5DWpQAEF646QDFJdIRNDmWAkTCHuW2U4mWCcVwOVa8WgjLuga0W68dmFgp//MNwZJ2MvmsV7rU0CoXzcIbpokaflQKp+vZQstdfIQr0K1c6epNGyAJs9H1T4Czr/4/Q7k8EwvlBGOnRqRZO3O79f52QK5jPyqvz6ckuiDwdsWfmy80KK7vUF7vGYoid/Az1h87ziIMCvJXm15mAzkWQdX6oXA9OESUetngw71xHRwRwVer8w1sERry71JQFPSNStHnXcvHXRKhoU2pUyHoP4l2Wzmt1/y8a/yE4arnjxB5/dA7t6YBYiDHbIkP2z1KUs1NlCZhDa8zqY+Cqqf4mZKmJrepA//HIqY/3B5gyD8z4Ief1wCIte4wZHnJS6E/D0uYDq+cg9jIE89iUicPiQz9k3YeKNlmSOWK7trgmDHcvFi1t8Af9Ba9q60UyomFZqY1q5RtGlN8Vb08Py3JZQ
 3rtbKOTF
 BBm/b/ro7RoAm0KLSBVYTqE/GGFe4JHH8a6bWQS+BMwZjF+eP0n2l+5pGxdydTQCtbCwreVWt307YyjPJhdF05dan6YK49/w9M6XJEWHdvOpCEbo4h5jUILAMVDN5xg4cKku638gvuCoQvze3rGAZ7Mq9tkiGTnn2RPDXf6/DUXwRFq1pUR//4jVbzpbDyD2TvPsoo0pTosxfA45bDoOYFfN/08ICuR/vv1/9gJdeoz34+RTTOluoDrkNRT5YScOFFFySfCwskCxBo1klFSPPH+eYf+QS77mf0KT97Jx+cTjZVeI1oixcUgolFFC6pROGOV6TL22s+qII+Mu7N+W1OCkNz3QXFqPvfBvPdjh6yVRzHbMut/0qXHiWgLd2590XJa06gFiXyGtCyfqwXZ9c4AxhhC3sPnZ9LyazQAvGCpwV3Bsj8rLUaOidONDxN3XLpxzdWdJFejm4Wb99l5FMYz+CNQXg/ZvkYvVk+SEDAUPKFVBzIRIjRjvrJdHxUKDfbNrFuL7OXOPuU1xOe3B1t3rkx6uflxq9f3IvemG3Pn/gm+NZwasJVnaDJtgolG0SFblD9TpJ/Zobdd5Oyxhlz8KFl67318NhARIjewI2EMzI7QkQ/9tgCDcvhVYs6k6vTL2vpnorgTxNBQupzXL/OjXFjv10YXDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/07/10 09:16PM, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
> 
> This is in order that we can differentiate this between functions that will
> be added in a subsequent patch which provide a different page offset.
> 
> We go to lengths to describe the edge cases that can be run into here.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  include/linux/mm.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 09b06d8fea74..abac72785277 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4307,11 +4307,41 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +/**
> + * vma_start_pgoff() - Get the page offset of the start of @vma
> + * @vma: The VMA whose page offset is required.
> + *
> + * If the VMA is file-backed, this is the page offset into the file.
> + *
> + * If @vma is anonymous, this is the virtual page offset of the start of the
> + * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
> + * virtual page offset at the time of first fault.
> + *
> + * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
> + * page offset within the file.
> + *
> + * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
> + * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
> + * regions have their page offset set to the first PFN in the range.
> + *
> + * Returns: The page offset of the start of @vma.
> + */
>  static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
>  {
>  	return vma->vm_pgoff;
>  }
>  
> +/**
> + * vma_last_pgoff() - Get the page offset of the last page in @vma
> + * @vma: The VMA whose last page offset is required.
> + *
> + * This returns the last page offset contained within @vma.
> + *
> + * See the description of vma_start_pgoff() for a description of VMA page
> + * offsets.
> + *
> + * Returns: The last page offset of @vma.
> + */
>  static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
>  {
>  	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
> 
> -- 
> 2.55.0
> 

