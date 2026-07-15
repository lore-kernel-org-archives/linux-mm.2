Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A847C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBF86B00B5; Wed, 15 Jul 2026 14:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D4F6B00B6; Wed, 15 Jul 2026 14:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B606B00B7; Wed, 15 Jul 2026 14:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECA176B00B5
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:06:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8278C140297
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:55 +0000 (UTC)
X-FDA: 84991791990.25.2EEE6A9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id A62C712000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:06:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ep4rwIOo;
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qngtohDCDGKOAZ2UVf9Yg6jMkSiGUEfIvWoLem96Mp4=;
	b=HUJNPjtOfiwzQfplEqCV3gn2NpoF1K3GHxSUtUSLJCgrQ4QgC5NCE2+x1lAHXzO+gAOVTR
	WFlyg9pMV8kKzNUtWgEHc+9dyvGrJpUrdReCvk6ETTqvm7HxOp3LB+a3Vzj6/WI9jVhh8h
	wC8HJ0eGTs/S3XBHMveFg48ZMa3xWTU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ep4rwIOo;
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784138814;
	b=PyPaSOWt0/cbe4XkuMZmpKpxDne9JwxxFsdl90aN1JFkuyj09JfJ8CalF9T2SMK4TLSSuo
	UwcU4Yla3g4BDhKKRPq1dqnwB3kQlNATW2+pnrG5EkSL3Jbxqs0WPoaZriZgxZm2a/Q3R4
	n8xxoh+cM0uCq1kVSTVaqiUl0/cNilE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qngtohDCDGKOAZ2UVf9Yg6jMkSiGUEfIvWoLem96Mp4=; b=ep4rwIOo/ExvDfJmbtyA8cKzMw
	0K/f7VDtaU/DLWnU8uwYuMWewE/dC3S1ac1go5eVbtwF80qPWn5KvA3OvHqfcuRIXpW4OY5odfN5U
	weSzRKDDHCZ2JEhPfQKlDUbJQdhIg5wO+rloHvOBdYg7m1s/mQdTBwtZ0KOy4bDybM+1nE6KlB7Ux
	57bMIakkBMvb4B9//cOXUVMiSdXw67CFBTK9w74YZdPjPkP37w3eKwbO9XcT9HNqvpacpkQaqu1I2
	3hGgEFOXqCguSeUIllYGOWMxmlxPIA4nF3mzmcU+fuz7v4+2Qrd3UJCpm6P357Gsn91/sNfi6dOHa
	ZDhmCkMg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk3zd-0000000FcKu-2dgd;
	Wed, 15 Jul 2026 18:06:01 +0000
Date: Wed, 15 Jul 2026 14:05:42 -0400
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
Subject: Re: [PATCH v2 01/33] mm: move vma_start_pgoff() into mm.h and clean
 up
Message-ID: <uqfnbb7knn5gs2symluouczdbxehpwuubek3ypziavv776jncb@l7r4zlatslxd>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-1-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-1-2a5aa403d977@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A62C712000A
X-Stat-Signature: gzy9fqzd1qx435w4phj1sut76sc3sfkz
X-HE-Tag: 1784138812-328309
X-HE-Meta: U2FsdGVkX18bySgdjPk0FNwD/IETw7NztPd6l9yWadzRjmm8yzWJupWmKyg4MAtp5YHF6EsRhdhIYr8G6GIBzanBifLuDZrX0SayiKmQiJEYQF3vQ7/dPnHX+aCj71ACdYWJhSAPjREkslUERp/CcsMdSuZlbbFdZrwsr4JEv39wyi0phHjpTjLl4IlAySRPZpxz5BIWSWUnk6TSa94yuYb82cIoLDgF0bY8arJ2zHULG5K3svGmpfGuS16zPzASRsGzLxEKIttb6NVatdLTyJ/boLAbRnkGaZWOX1l8dscjnzZuBXJGY0SO6RiylG8tgEQdpENy+hAklxuHrHBURwRogmvsTSPCNey6b2gLmPlqI3Z/MIzswtJYHcXIRXJaMI49LCAccXOu8cVM78qmqzbCrajRhvehj9x9DhK2WbYN/5LEN8jd+iCUVFhKj6aHOUtJEQ6LlRzCSCHcvu1U3ZJo1HUbPoUGNywnhjFKT1cZzfCy67vlLrUo4ZB4lm47nwWm9IxkkzZAzDccW/gHvphyGE8tlXF1hEOWXZT+tUnSC/JXTg+dJQADgaY5RNAWSxf4maISNVGoa495imVJqAoqFopWTOvyvtC/NJnbkluOomB/6KYU3g+udQr3LoslUcYBGp48uGvGmNak65ZnE9XdmQ0n0HGjvy0OTPJTPei+fqH8ZfrOH/Nwd+OxvDG78CpokLbt6veT3KGUWcrMv18banOfci/1WCcinyoELEQvPO3wDlUesn6Un/unJnF1QW17ykL1EnBJ9bKS36xv9HGMA+wQqTSRUjJrmp5fzEGV3ZIgmOZst/Wg+AXuITHWi8Cw9R2N3K+pwSaBv93WG0LRUvygxbpviajHlo3hJPuguhJGQ4vcJ7tyNfGE16s3qHgAZ8tG4IgU5g+SknCFD272P6moiILYPq6gXJIINYGg/7GIJdxLxt9iJ0Rh3p4Yhcxtc263PveUY8IMfx9
 igcWnw3M
 Z7I7mWzmtyTwQ0DS1iOWjQVg0kAYdLcWYYYuDU1d4piLU8/ffMg14HAEMI2OFBpF4WhhAFJx32RtaRgzri5YYj/elBcgpDtAXOEuQmkH5CiNhTKXycMA65pvTVc5dMT6rIJott2kENiJylrRfdpV6uh0BN/Hti4pMbvqOxtOR5TE7Za1QSzG8X2ibJPvwNItrG4raFqgfSwRZvklzgjjxthorrggUyMDQOWMQ9hnTQaH7oSXTtCSynOyDEaofIRPqaWYcA8gDIJYyte4F4JIxj0X5zaBZmQl7DSGBNelcijmJj516ij8qoB0NsGPykF5unT880d4leVTOSXqoY5WmSsoRyMRvvVXfS0a2hlx24nLNBbCXxB9xrCuuEyuLQvhSY/JRRruRUSzNBBf5fVIIfTCSfUQ6mOLZtR6Juuvcmds2WMY9PZ6i44CW5BIuCxFfT3Qb5rhMmuQ9h0TkDd9DeCidCKQCuzMut0+yaMhJkP37f5mtnKyc4YAuzwgUnrZ/4HeQ7FpxmSNAS1dErFUfkPWwObjiX6WLuPqULbBEPTS/BQACE31ENlWKkJuyI89gG0Ii4Abg88Elw51S3LXYgrcM2SYDvgqG+VR57Tm/x2/kxBW1W6Cant2Ku/8sXQNZEZURp+sS1bxwM9z3lIWoxTLWSV5q9Uhm8UUC7tV6tNFhG9e4GmwL5SUB34ZjYyVqTMAQKk7ZzN2Hio/zIS0rEIKUs7MzZcBIX0JEwX0amsimX6g3rQmaTZ7P3KqReWXv/5o9dXoFHlO/ekXx+VYegZrwV9L0gUjITg23iJ4d+Tw8IvN2XUiY3K239qooYGW/Cos2ZpLb/J5STRqe432A4R/ZVYOrYqIkF8tZHR2pg3Xk/GJR65HEA8Arz9bOROO5JySzla7F6qoX5mUibV8d/iwaG2c45R27kWCYeoKvoyAOtqwPxGc9E5BKgpkHA1mk0eJyCAQZMUGEgwK09bJFNPQiGCWd
 f3KMOOaN
 VjesShI88NDA801LKrS1Kh/lm8c1ftvIlHjLtNXFPWpSIufOW7u66LPb5YSZ4XyqurcSAjT380Vfv4d36tZY7HkNwZXZyoXJ2vLhcX54MNzBCLuB2dRlgfqcDxl8qQkIqepxxcYsB1ZYioJgronBti4uOXo6XFRzSfB2Z5EM6FyXjVrxi8+j61mpsDXInLXHbMxx2WNvCvg51H/GQRlxR2JxG0uVvOQVy3F0ajqaxudlwLZ7mnjQbNFZDCrPNXOraJ6wHLRigbhHxtAw8+UBPFYqLZk7c0Lec8JxMhZIfkkWu54ZE7pCkESH+hSwx1/QhHbo3geQ/+6vKlHYHK+7clIBeWgjKJ3Z3RTJM1OGITmGgRNosMXpbAxIG1Pz/TlVdwdQzYhl/AUvqNOwwQ4oT4R+d1JXTOD/647M8sCEAmcxuXeBgB7wvnXPAc0NcibC7csVbSYdAAjaEdS3P8lD8VUAOGLTsc3Jd4QxMvXJfTtVQqyhiDdMRhIfhkAigqApveQVLz5onHninzEPHmcQ7d6v1ItKTcNP7ePTItI96E+Nd7+TDXC6hAaZnsyzS1L8JVrcRHQhoKgRmlW0QjBrVRYCn6BJcwlUDYlv/D/odAH9JO5AM7eEi4LCYlX8+KXSeMsa6A5GVR10vvxWVoadTPjS57SbgwdDQxLn3AgqVjYYKU2lRpTFch06SErbyKa7t6ezzKT6Pc6BjXSePCbC5VpEHG+1+5ggngRMlvuLCiimyCq37Pk7jI96oUWYu20K3Xa2BJv4GtUcLSJXzx8zmas5G2UIBkqW7X+TluqsQrHgl0K+BskeAwvRqwa4LaeCcjpbz3+h9WTvkh5lD/xqMKJ2hzS5pH6+LGAG73tEwcCh6HZp/Hn/+6qRteD84mMcbSAQ2R7GXMRcxQBnSrG9QV00S0qiI1b5fiyXAIcJMc87Ow+Yjr1ctVopI2kXsRxSizFMKy4f6wqlAu0um2DX5DEf8R2Tj
 uKBfT04v
 Kgiy6SZZCsx2LzoQDoKSG2u4FruH8tW7rmP44dbSAbpSrPBGODEcejokC6FQ0a+rHqrBSI0hDMGLmbyvOI/GclhI8ImyOZ8XOVAV7FOtTEyUX+KnazPd3iundkeTplaevLiTejmZGqqT1Jw+SWLOSAH9Uuoh9v2Ym7AEFQCpvmEaBeYD7Qc+UkdEyDXL7hBrYqioJ8KzGgInI8ajgxg/KRpRYVmylk3cauWFLxt/aFMtQDfHvHXUbaScdN+DCfe9NKNeTCPDhKEY655pPsEsf9JkSf2q1np9WOuINBF8sk2hnqM5ohyyfbiTm8MFCP+24q8Pi28/u0tooagFkuesO6dnta93xiXCMsOg/Qe4IGdAm9r+8cywajkMmczqHPklGJp/4rD6uEvm7ERnYZE+YWBnNmuGbolfTlRcpFKQvZMctOXqCYULzrjw62YuaTklL8tehibW0jx2Y9hbv1qGoKTQvk1kql8wnAjq5Qym5lmP/5SgeSL53PJuspAjfuRDjHyMOoQzBZLlq9Nb5KijNNsiRKSeoPyodXc6a2XggsOhJ87oEa/acYDho49ZuvgrzhZ6aStepGiXSqsn45IvShiK63pXHS18aF28WUkfTGpcGlCECiaE/i7GJJYVGqb0nJBZZYuyAH/Kfy0nDooDAaTpaJ94gucXzLtj8UHvEUVIjePjYa5QZQnxSw45FVlAZmXBdC8lApAxQ2MaEnuQf5ay5eaIx/wQYv4SMzzN+4hVYKn8RZTCIqrN9rr43k3qD5Dz61w1MNgcv9DjZPsKKNJelVucjlwgZbEpw/FsKcKJ66Ylq4zsF7dSPaKe59noSSPmU2Aw2PGWnrypfZJrbK0So1sXm75wyJaNdRZNX6LNTUSqHjk00umqro3H8OOWbiCCXRMGzbd6TmG3UyrlDQjRKmcLEyM5ONpcd4oWGFpgfbZIHHQ9QjbcIp3+rbzxceHzJDow7897uIate7+yZeZkRxMRE
 m3UnlT8T
 uTO0QrCoNHYIHy/W/MqZwEmfoIomxfx818JCpzUROHDTP75IdQ3kAZm5f4BAygf4ouiWXLN5tanzl/92PUw8oWhnPorn6Fk+Wc7IJWlwc2LVQ+csld6KME4WcA03nEa64eLrgNgVofhI/ghPRgewy4AwFHkLkPskP47au5TTIqWIeomG0ffEa+Dw6GwVb4WYQXYP4ss7Rk8ybU8zv3ms9pX9JIX2nuBwURgMtOK9zjSQ1QLqVsZ+ATgVufwxmlDNhmSLdDm1DcFY8Atsy0kOXY+o86olpR8NH8KlWKPLzmLAiHt0oIATAyax5z7nlRhjfuypMjnoobesHs1H/qEErj3z4yELI/FvI3cgJ4/ZFrg2I3h/rbpTdPMNVFepOOh7COmcj7HzpnI1wdxFqYN6H9OEC07sAC19EisyrLyGyhtz4zP1xSXJ+bmUQfq98j5ZqMwxTTZxl2htmQMpteD5PIM/D3+kpzKSZo/+E7t7I4JxFMjQAAw4M14nhuRIRqBzb6afwAn8MD1Wr/5ap/hHi9evkSO7aJCwEjfuCPPILLH/Go0s48MIlB+RDv47jLnhIYHw3eBoXPkjHCeceqOG9VwAXX977CmHgtWQ9kz8FuuPPjVS7QpqBRzdlwZu13Gyj44sxeH2qKOoGNIg5UFmMSObK+KyR1EcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/07/10 09:16PM, Lorenzo Stoakes wrote:
> vma_last_pgoff() already lives there, so it's a bit odd to keep
> vma_start_pgoff() in mm/interval_tree.c. Move them together.
> 
> These each return unsigned long, which pgoff_t is typedef'd to. Make this
> consistent and have these functions return pgoff_t instead.
> 
> Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
> we wrap the vma->vm_pgoff access, we may as well use it here.
> 
> Also while we're here, const-ify the VMA and cleanup a bit.
> 
> Also update the VMA userland tests to reflect the change.

This patch could have been 01/35?  Disappointing, but I will try to get
over it.

> 
> No functional change intended.
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  include/linux/mm.h              | 9 +++++++--
>  mm/interval_tree.c              | 5 -----
>  tools/testing/vma/include/dup.h | 5 +++++
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 25e669632d2c..09b06d8fea74 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4307,9 +4307,14 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> -static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
> +static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
>  {
> -	return vma->vm_pgoff + vma_pages(vma) - 1;
> +	return vma->vm_pgoff;
> +}
> +
> +static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
> +{
> +	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
>  }
>  
>  static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
> diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> index 32bcfbfcf15f..344d1f5946c7 100644
> --- a/mm/interval_tree.c
> +++ b/mm/interval_tree.c
> @@ -10,11 +10,6 @@
>  #include <linux/rmap.h>
>  #include <linux/interval_tree_generic.h>
>  
> -static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
> -{
> -	return v->vm_pgoff;
> -}
> -
>  INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
>  		     unsigned long, shared.rb_subtree_last,
>  		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index bf26b3f48d3a..668650067c7c 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1301,6 +1301,11 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
> +{
> +	return vma->vm_pgoff;
> +}
> +
>  static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
>  {
>  	return file->f_op->mmap_prepare(desc);
> 
> -- 
> 2.55.0
> 

