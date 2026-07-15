Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB3CC44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 19:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80DEB6B0088; Wed, 15 Jul 2026 15:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7978C6B0092; Wed, 15 Jul 2026 15:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A4C6B0093; Wed, 15 Jul 2026 15:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27CB16B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:54:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BA298024A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:54:10 +0000 (UTC)
X-FDA: 84992062260.16.9BCBAAF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 557E140003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:54:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="G9Ads1/5";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784145249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1xTcKNYwdOUdwgNpbyIzAcPowaOLgUaHPOaAeLqzfg=;
	b=lWKKBYnw0PUga3CwPm+ONqwqcYafweeGM11JOKsJ1lU72VVy0kBTZiMlNdo7uVHaOa6sZ1
	WgXqYHvaVuBSDcl1jKwDVtC4RgriTGS4EdcjBCEBJzX7ZYipJQCaFw/B8WranjZRiN6YdJ
	ZH6VoJEnhk7S7h12HuIBh8gUiAZ5W2k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="G9Ads1/5";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784145249;
	b=M7EX5+QW+zJGBL99sLuBrFdWxYaj4F5gA4DUbxU0DLbCUXlQHsRxVPYLpJdmJfhKNxzh+W
	Jx04OSgl+xUaAEP6aEkfePbt4SrQ7FcnfDzpQur8GQdq88FTKjJSQHBFX1UpV/BIRwjCLf
	jyzeBcSyeyFaI06s6ucMroTc1MJANJw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=u1xTcKNYwdOUdwgNpbyIzAcPowaOLgUaHPOaAeLqzfg=; b=G9Ads1/50L6jZQcaHXYJq/Psc7
	AryEJZcuGxV76jnQvR75aByyQN2+s4KISlfDdk2TV92ezj8Mb4OV3LQF0ZVYbq4Bwq7lXV48A3koM
	4dW7xh0EelhZHZsLKX5Terjo3G/wY4H4bI5wxUs6ArdrtWB1DCY3d3mbi6Xxwegu+cmC0ufKyHXMu
	AqLncMI+gSugHyCRPWyTnaJ8K+c0jt3rkv99sJlwJf7PJ+dQ563sPdXLBXOHRlyBfZi2YB6bdEe6v
	/P14vLsGTAZrR7gY0vy5J00O3llg1vnu5Lm0yJTpk8XtVFADXa9x0/iPQC2akptOn3wrnWTNwWmxS
	CaBTrBPw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk5fh-0000000FpH0-1NIX;
	Wed, 15 Jul 2026 19:53:33 +0000
Date: Wed, 15 Jul 2026 15:53:23 -0400
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
Subject: Re: [PATCH v2 03/33] tools/testing/vma: use vma_start_pgoff() in
 merge tests
Message-ID: <p6bhkbzvrdz6bb4a6cdmd6bmlwuwxfjd3lx5opq334o7nwjhwa@ctqdd3i2daon>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-3-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-3-2a5aa403d977@kernel.org>
X-Stat-Signature: t4bspyf83at9wcn1f1bcg64wf3r13cs1
X-Rspamd-Queue-Id: 557E140003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784145248-555211
X-HE-Meta: U2FsdGVkX18+ISuJd/K1L6ws7r39GlgEaG1iGo+jg/JFfbbzz3yhv9Ihf/lnfqtgi/R6Ya6+mVuI79PhGkw2HYXlKiVqoKmOIadxkyBZv19ptStXo0++WQi33EqReU+zPgMC7qbzBwOWh8gk1yn9KRLxvXwN3slWkMwVzt/I7FWtOtZvEHzHV1Nb3WBmiduCKmgwSl1mcfPwfvAI1ljcqj4UwnszcP1hP+zwWx6prUxNpjqQrLmSqFfjwOK4+CCKHok43yA5zHKutDjhi7G9eBT+6S4YkOrFMj9Gq7J2QrqvnGq1oWexZ+zjY6OqxQgEbY5Zmp/BL4Lhrh4TcfD8zfO2xyZx0UkrMhe/uPnC7K3dh45er37/0V/5yO4PFOBmhvX6d6wVhmnCEcT6u5AF2pQopSfcBkm6gotfFlpUEzAQW5xC+0U1ICQ2bISXiH+KUp34Nfk9jevRQBvU5OKhjWvXdcKYXSK4oq+8CujlvgN4m+THJnL7qKestmrUw2+QA7eo0TSbwgp89s6iipJ0c5gzQe9ocp42y1Nt3laWhmWx388FGv3pMD0puv6DpERVHshfRESuK0yHm5BrtL3EMlvq3sm+kzJYV0YyOxGGM+TQQaM1V5a3mLHhIIJ3HFTnhFgzwojMgbqNb9GpCiL1ytkkQKEKduf0Eb0ZiCXMI5TLqMwl/H8MuOjzjd9oOWqiM6qpx/qt6IGUoyY4ietkEHCi9pauQR0sKDHPsOvJsc8ZUs2CSSzmqSdAAmUCHxA691V6/CVvauMpkj21kqmQJak7ZBLbs6/WuHRfCOC9WQIml9LACZX1yrpGHD7Yd5FwqqP+6MPKSNNfjBoGLAspB1B6cpsPEOSQqtX5E18VeHj75Blg2TQfBRVdExTshiwLrRMJhZ7CqT6eDRALJalk/UXj77pHHp1QupWT3D/dacYRmP82Anx4jQNasNp4oTGe0+KtEIJJ88526HIloYB
 YChXvUR4
 UUx2LUM7gxGQqF4Hpw8tY/TCnLpRaxQ3eiKVai+GglR/HX7u09W6DwtP3ptuNpI9FiDOehEKbfknb6OTjdUMttPvAW9nASIaJBalphZdxH+eIcbtx4MnrhZN91E0cQrAOINEKlO9d5/xupuXXhltKUpnENDSW+pxik75uY49ZZuAIYu1GEJKOgSoXDWplIhIBzkLgHJOLGDFewhT2MGsdYi114xV8O90MrKCrxJEq63LHwLv8yVbPyiQ3frB2mn3uZ2oZDB2B+cP5AZFWfVTmaRoPA65Pibzqa3zsJoF6I+dPsX/zkt4ZOZws0SlUkTuz4PEvFc/9TLU8qE/6bDWg1V6TREsCcSYXjzlFZYmNU6CPaQ6vm29hafq+1mAVskPxGG/23eR2Dq2DW1VIvq/wiomo4BrANDifLKTV21iTIFP7ddZ+qKlfuMmBKvpoY00JPec4dzZNjx8yqKJ4Ae7/f+Qho1pZ95vHXdLjZOgO5PkxdRroYhKOlbCJzy10XZb0j7WemRnzkrBNHRoE4Dgp6iphLuQM53gMfAvPsiKKFVt40w1OoyuBAbaPlaloKKBaTm+XH278QICGf0saDQZcUTNKRBYRXD4ZNVEDnzFeZXMOYkVVUK39wHAvu+4ZngnJNt5ivI2O9vtiXp38yk2iPLGIQCR8Z+6VjSTlvat85IHMl4/IlW6XKiOANwZbyMLJuvmQBavNUj7+3/Yy8nzJGT0gJPbebT4Z2B1J/9rqt2f18i6SjqUiHtbNwzWqgtogkdNlbAvRvO18d+IvqdkzuIgqTy+HJTMr54zIiVbSmZBns4l+Azwkz9b6QAhIhq4JIYv2dB/dPhQdh6FO1sk4NY9yxCGswbpqDfjcT9VTapUNbfowSgNvtWrNGjZ0Le6GYi2MxSWJOf1/z0Ej7muxxNorU73/7Ztb74BRunNMFyp2LKlAyQNdiA8o1JVWnqUjJykuur9FNMN7J45iMAI14q7HWXDk
 kj1o6t6m
 tKj9AJB0GAu1X+foB+LDjnMq7is6gLsEyjO+3JJPx6kER3WOpDT7MvBqRslc5/WUoUyXKTqUF/pdYuXrp4S8nAaJeROtMlZFkKjPErnOQ39JpX4kV8Upr+xAnof7gpLrXVIYBpoLE+RC/IO7Cy0m/dy/OnxlGxntJpBgL/aCCOOsDo6tAhvoxSoeKXHcen7Y1d0Ez1ZujXt5oXIXVUUgH8KhiQRpTyvxaiePWd23wblIkRQbTUmuh3EkRnoHvawT1KPSPB51RknPmXxH0z7JvyPlVhz8WRaK410IBgP5cTTKyfVQrBKF01r+uLVw1ERpU3OLeMeSbtkGWyreQ4hh5zfxu5iL0cL+5d0vN2DFhiy0hPNafR0AErXimq9uZlDCHMPAX1b6kUN0vp4Flp3mxdPWfa+AZewCNXW384CpwvB7Wj5NQjVhp+vOH5sQrh2Jcbcg1kSbCWlv9aQmb1t37Uv28jWDCMgjMEehEGjkdn5pC46q4WWPUdhxbmzd14sXmNvT6tZs23xABHEvanmgOFF8YLTlQrg3bbiR8xaF9zJ/Rtnh/vo2cgCHOgiiLcxXqga5HGu2xVy9cXFJlriH4Y4PtLAj/8ODjhdDGcndF1qTrCrZxvFXHzRgy3XZpTPoK7K61uHpLBor0LqVl2S0DpDR3A3wsQ0hGX5L9/7xKTJvLXHe5TnzY4pPRDMRPeZsSGv4Ebu/f50hGYbtFZOqZS9mUt48NGl0a7C9npSUY0/xtGGXx9om/HFSrPneps7rhr9qrZgUAz0uu5uA9xKMObdWZT5U8u9wp/5oupkElVwCJGXQWt9Ymn9H3MCnNKEEBejDynxZvmMYegGjTCrGfQUDwcUJ0a+hteO6kwNUIKilzOYyOERax7KBwRUpkg2TqeAZbS7Y2YgXik8NIh1fx84+xvs56dVzWBi7z5gWXnquaOoAgvEjcYZIOlu/ZS55Fhoz6gPc/IiEUyyx8a6eESMTpmDyI
 BfANYReP
 b5LTEvWSD9cicZK8KV7nu9aC5AGfObizzK0btGnqcehGUdnUGgKH6gq/8P67IJByJiZ74N62MMtNRXOdS3GSO9Dq9xIPgYFTJMJxF9dZOqZGSaJAWG33kz6ddXa3jrX8T5mOHhI3hLhSqee2sVf6TTbQhzDAWuiiKFn83QcCTfLDTRl0U3SVxHNfP0D1KkMq56IRKnYiNYYYLZ8uLaBX687W60li0PD1yQnby+A1wTyxlVkc79kL2BC0/L5Hyz1qrCWtnlOC3r3f+L0ZRz/xvq88YXVvCn9M9OK3pM/E8HtZ5Qz/5heKplqAwfq5W3Ub+VknnshaliawzWtmaZ2WPHX/b48SJ4SbOeR2yTzks8R91JoTBWn4gkgKhvVHRuAk067Ft9AnaFXzvrQob/CpZqLul529n8eee2/aWZLPHZQjZBZJVHCWIVrGCqqx8IUGODWSNHv+icgoKzcxrP/nNdllhrcAkJf3PF4XQfu8hTlUdPleFHGhn7H3maARVrmLpOrJyF8RiPImqyKKrpSv5WLOJh2jhnu6iS4juyFYDkdE1z9qkbKY/UNaw8Xr3YarU+Rvb+IDV5Gtt/GMYKUgneJQl6g96EyMDCemek1tQulZxOeqc6hzkEWYi3QUlJvnS3QSf79io88RQsE/K21lmgC5S+ife8Lc1frCaRta0j1EVD2CyV02EupWBH6YrMe79KJXYsj+UE3G4wKjAnoTteu+4UlgorBeIB7Y1wUzF02/omZo3s1fpeSfDziZmNRqLEgdtuoasPDiGMrq8may5Sf0uxjIm8rDUxNtEwtsIXbLPKVQzDiUhUEc7K/qJQw1sRpI7ZBqJjFl0Mc4Zw2q0IsvNDJuP9vWyYYM7u9pHWHc5jFSIVM2jW56CLe89Hbu4QS15OwsbvJKLa8h2H0FmiXjYv6sIXCsIY8NjFfLICaCMcVfJesFBa63P+c6Z87XjqmOPBybkR0A4iATDnoV8gC77Hc48
 oTX5CWpx
 /z2keR/8jKfs37QI4kBInBV7TVrJRtJwlvH7txmYJjIJ6juxPNEIEU+NN6HWojF4AazbHPdXIYjiXqh6da+Eg1pqDwcpeMXSpbarRcFKcOIRnoy6pFmEdvDKqmJXdEn+jQwnDD7iY8Fml+NCQTvFsy9XDhe6bE0QvqVMc4hczgxSsOkyR9Sr28Rf9/Zt9z5m1/9llZjuSSwmkEB57UlT/8cl+MsqVUZGOarCnilZ+YC8WbNXfn9N3rKPoRyXddtAgzp2X/ZqFWLg7QWbKRYyFynz5o/I7KNwRxjvnYzx2znM//RX9/oWQYbTLIGY6ClnZHc7INIyr7no2o58v9FMxEgZk8YGLVqqu/f1q2jtVZklArIJLYhuMe6qjuKB8fu6Ld7WxX1pIb7G+LLt/daL/Z0fi5g7XCq5awKz78/FamcOfTnrUF7+YQSutPW7J+OeJkJjScBVA1j+8bwxHKdHO6AdtEoTl+8jwYMZmAfRZmkZ6oKc6RCWii4IKnBGY2BUjvIKl6jZGWycAbWAg9ulIc6yBl4r1Pur+zbhhmTrTRA6Izp1i6jvQ3j4sW1u/r/IHGloR3ih/ZxySZ7CoweO1MaRw352V+FWOBEfVwMWyrXHLSqM3lZacMW3SWDx73UOmAByojDEwkknzMos79mMHfOgKhlqOCXLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/07/10 09:16PM, Lorenzo Stoakes wrote:
> Now we have the vma_start_pgoff() helper, update the merge tests to make
> use of it for consistency.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  tools/testing/vma/tests/merge.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
> index 03b6f9820e0a..f8666a755749 100644
> --- a/tools/testing/vma/tests/merge.c
> +++ b/tools/testing/vma/tests/merge.c
> @@ -118,7 +118,7 @@ static bool test_simple_merge(void)
>  
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x3000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
>  
>  	detach_free_vma(vma);
> @@ -150,7 +150,7 @@ static bool test_simple_modify(void)
>  
>  	ASSERT_EQ(vma->vm_start, 0x1000);
>  	ASSERT_EQ(vma->vm_end, 0x2000);
> -	ASSERT_EQ(vma->vm_pgoff, 1);
> +	ASSERT_EQ(vma_start_pgoff(vma), 1);
>  
>  	/*
>  	 * Now walk through the three split VMAs and make sure they are as
> @@ -162,7 +162,7 @@ static bool test_simple_modify(void)
>  
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x1000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  
>  	detach_free_vma(vma);
>  	vma_iter_clear(&vmi);
> @@ -171,7 +171,7 @@ static bool test_simple_modify(void)
>  
>  	ASSERT_EQ(vma->vm_start, 0x1000);
>  	ASSERT_EQ(vma->vm_end, 0x2000);
> -	ASSERT_EQ(vma->vm_pgoff, 1);
> +	ASSERT_EQ(vma_start_pgoff(vma), 1);
>  
>  	detach_free_vma(vma);
>  	vma_iter_clear(&vmi);
> @@ -180,7 +180,7 @@ static bool test_simple_modify(void)
>  
>  	ASSERT_EQ(vma->vm_start, 0x2000);
>  	ASSERT_EQ(vma->vm_end, 0x3000);
> -	ASSERT_EQ(vma->vm_pgoff, 2);
> +	ASSERT_EQ(vma_start_pgoff(vma), 2);
>  
>  	detach_free_vma(vma);
>  	mtree_destroy(&mm.mm_mt);
> @@ -209,7 +209,7 @@ static bool test_simple_expand(void)
>  
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x3000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  
>  	detach_free_vma(vma);
>  	mtree_destroy(&mm.mm_mt);
> @@ -231,7 +231,7 @@ static bool test_simple_shrink(void)
>  
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x1000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  
>  	detach_free_vma(vma);
>  	mtree_destroy(&mm.mm_mt);
> @@ -324,7 +324,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
>  	ASSERT_TRUE(merged);
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x4000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 3);
> @@ -343,7 +343,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
>  	ASSERT_TRUE(merged);
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x5000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 3);
> @@ -364,7 +364,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
>  	ASSERT_TRUE(merged);
>  	ASSERT_EQ(vma->vm_start, 0x6000);
>  	ASSERT_EQ(vma->vm_end, 0x9000);
> -	ASSERT_EQ(vma->vm_pgoff, 6);
> +	ASSERT_EQ(vma_start_pgoff(vma), 6);
>  	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 3);
> @@ -384,7 +384,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
>  	ASSERT_TRUE(merged);
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x9000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 2);
> @@ -404,7 +404,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
>  	ASSERT_TRUE(merged);
>  	ASSERT_EQ(vma->vm_start, 0xa000);
>  	ASSERT_EQ(vma->vm_end, 0xc000);
> -	ASSERT_EQ(vma->vm_pgoff, 0xa);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
>  	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 2);
> @@ -423,7 +423,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
>  	ASSERT_TRUE(merged);
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0xc000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 1);
> @@ -443,7 +443,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
>  		ASSERT_NE(vma, NULL);
>  		ASSERT_EQ(vma->vm_start, 0);
>  		ASSERT_EQ(vma->vm_end, 0xc000);
> -		ASSERT_EQ(vma->vm_pgoff, 0);
> +		ASSERT_EQ(vma_start_pgoff(vma), 0);
>  		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
>  
>  		detach_free_vma(vma);
> @@ -805,7 +805,7 @@ static bool test_vma_merge_new_with_close(void)
>  	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x5000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  	ASSERT_EQ(vma->vm_ops, &vm_ops);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 2);
> @@ -865,7 +865,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
>  	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
>  	ASSERT_EQ(vma->vm_start, 0x2000);
>  	ASSERT_EQ(vma->vm_end, 0x3000);
> -	ASSERT_EQ(vma->vm_pgoff, 2);
> +	ASSERT_EQ(vma_start_pgoff(vma), 2);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_TRUE(vma_write_started(vma_next));
>  	ASSERT_EQ(mm.map_count, 2);
> @@ -931,7 +931,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
>  	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
>  	ASSERT_EQ(vma->vm_start, 0x6000);
>  	ASSERT_EQ(vma->vm_end, 0x7000);
> -	ASSERT_EQ(vma->vm_pgoff, 6);
> +	ASSERT_EQ(vma_start_pgoff(vma), 6);
>  	ASSERT_TRUE(vma_write_started(vma_prev));
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 2);
> @@ -1416,7 +1416,7 @@ static bool test_merge_extend(void)
>  	ASSERT_EQ(vma_merge_extend(&vmi, vma, 0x2000), vma);
>  	ASSERT_EQ(vma->vm_start, 0);
>  	ASSERT_EQ(vma->vm_end, 0x4000);
> -	ASSERT_EQ(vma->vm_pgoff, 0);
> +	ASSERT_EQ(vma_start_pgoff(vma), 0);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(mm.map_count, 1);
>  
> @@ -1456,7 +1456,7 @@ static bool test_expand_only_mode(void)
>  	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
>  	ASSERT_EQ(vma->vm_start, 0x3000);
>  	ASSERT_EQ(vma->vm_end, 0x9000);
> -	ASSERT_EQ(vma->vm_pgoff, 3);
> +	ASSERT_EQ(vma_start_pgoff(vma), 3);
>  	ASSERT_TRUE(vma_write_started(vma));
>  	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
>  	vma_assert_attached(vma);
> 
> -- 
> 2.55.0
> 

