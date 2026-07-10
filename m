Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E35AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26AA26B0005; Fri, 10 Jul 2026 15:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C0E6B0088; Fri, 10 Jul 2026 15:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3A76B008A; Fri, 10 Jul 2026 15:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C22406B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:05:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27C8514054E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:05:36 +0000 (UTC)
X-FDA: 84973795872.18.5C489F6
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24297C0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:05:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WpXEfdDY;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783710334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Cb4T8zzpAMOVzwqCT+1eDu/jZ6x8Q2fk7Pyrqw1u7c=;
	b=wWREWjqEtdCrLUt6rOBMM/lgbuQVrLCNTZJ4YOsZJvMUc4Sd/zg9GVgyXF4A036hFZNjE5
	52U1XvsOh84HpHCxilDxRuFZWZidPvShuSedHpTGxiQSXP3NzPmaWRJ8sfnvn6yiXbAiX0
	nPWkd3SRwZyEyET5JstqqynCRsHzW/w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WpXEfdDY;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783710334;
	b=Q3tZO/XApefl7MQ1MmaqmF60VAVAmU2IRn4TMl1p9uHavYj7ZmTZ3IPgpUYCjXIM5cpplt
	DUG1iGJmtNk/SLDub5jam6rE4cvoi6hWO43SgmM217vsqgEFOfHt6y53+M5SeNvVrRtVza
	/9ZcRHfZ0e3jQaP0dvciY1NvNW8VmJ4=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e855da580so102269385a.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783710333; x=1784315133; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5Cb4T8zzpAMOVzwqCT+1eDu/jZ6x8Q2fk7Pyrqw1u7c=;
        b=WpXEfdDYuQ96CXbeNkiai8JULtgCEXzH2cQnHWT6ko2fSVzXx6E8oF6nvg27RFHWf4
         nkv7KLX3Zbrlq+wH+Yv9lZkPf4gtuwuB111WCVFZjSQdBedQIxC02k7sCf8dvv+Hama1
         LgKMTO/VkRmJprm5ooATUuUayD8TdSQs2+jaPiUFFKM241Z/pdh8wOlFhoMGpKYqizkB
         Q+3vQ+bmGF558sYT3yHSPx1GQ8xMiyJh7J/ENjeWwTqQqHNYjZTKvFMwEMQmwPRoheNH
         5v1XD0X3Rc8TLsD8SQPID1FP5Pk49wKsi6AC6nW4mOJq82vpI0D2pzMabQZpAKzG7WQ9
         jNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783710333; x=1784315133;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Cb4T8zzpAMOVzwqCT+1eDu/jZ6x8Q2fk7Pyrqw1u7c=;
        b=mDTZ1PGiRrkrEjA5ZHHYXPWgjyws4amt+KuJgETfkuS1Csj2Ayy7Xy7TlyTSnxBw3n
         UUY6qzKX36olP9MKpuDZmYMRDUlhjIw66fvO88UzvkNyOzKrqQOPrVvcTvii96h83CUb
         Rxf0PoAGJ8ZthkGSPwV40SlRKCWfJiEJP/T2wL0FJfOVWX1yqqQxEJQ84iPikMQ4reav
         QPhAUyeRnNjFs0syABuPfTglRj0kqvcKKgzqAtNwRIe926kbM6jEhEQvlG+c6RH7UxUe
         THToaD9/OGZbvuB7lGNRvoBICH05v4zAFvWwFUGArVK4u2Ar2LiGdv/9OOkGkyalxFex
         rbnw==
X-Forwarded-Encrypted: i=1; AHgh+RofSOQwI0pF1llejKNNNyYXlPytqqPIWwyRFFPbMHb/qSECWquEOGIiMxiDlsnBbrwpoHQhm6hM4Q==@kvack.org
X-Gm-Message-State: AOJu0Ywryg4eFcU3BS88v0QroCxNnNSA2kZ4ZwvufYkb4eAgqduPo5cU
	U/oNDU+PsgcKR2PiPDhjCpBXsjSShaigPFh9lIl4YdF5XRHS5O0szg9TfKebT05ClAk=
X-Gm-Gg: AfdE7cn7XkDAuWEyG4m7MMWgEive0L4sG8IpktFugX8ZTaOP0WV2EDKxfENW9MSqwtO
	wOKMPdecJJUjtSJVUNmPLI8xk25nghI+GsSTlzUAw8Rx7bAXeWStyBSg5iEyPHYc8pMv66+r4GL
	uzxYmP2q+NOcisfnyNE2txoNT9GO5eJLQKeBCkHklklRsyMG6hJlBTWX63igH3piiy6ZsxhUzAM
	fkyJFv+lTGPF3FrezW79MvcXpaN9OMeEWQRTCATZiQ3KeM+mrtLdXau9AFsEWAUWEXikqb0qBY2
	5YryTLHEQfH3YgjHFTXiiK7dDJpteb6nfOo58Qgk3rjPTs3WrFVeqezv1SvpveWK4Mq1X1A+kAi
	glrsRfA0IwX7zEN18xps7l2SGLPzb7pQ88sd78pb1U/fl+Ho8gnEakU1ksPIRoVwIAU35QEceic
	4fFEAw5Wklq8+rjoW1L+KIeZliWm/NHJgbiVmq3VoXhSlMRd6Pzz/FmtW5plB9lnki2Km+
X-Received: by 2002:a05:6214:33c5:b0:8f0:65c7:315d with SMTP id 6a1803df08f44-903ff971194mr4994756d6.24.1783710333250;
        Fri, 10 Jul 2026 12:05:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd80fe009sm47940576d6.38.2026.07.10.12.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:05:32 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:05:27 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 20/30] mm/vma: introduce vma_assert_can_modify()
Message-ID: <alFCd1RtttwxKBLc@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <23c7602c58cacc23ef22618a27af9a2d54addf58.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23c7602c58cacc23ef22618a27af9a2d54addf58.1782735110.git.ljs@kernel.org>
X-Stat-Signature: iegei3zbtngtn9hies4m8b93133wc9qf
X-Rspamd-Queue-Id: 24297C0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783710333-303202
X-HE-Meta: U2FsdGVkX1+xog3wI2Me0BkoKeUfsSw682G/0s+N/B2IFEEd+DaLVVap9uzFhoQC18MB2dX+M3j+8lZ/Y3eblos3w2IvKlgPkNukSGU540kQWquUVVH/t2x0fSqksGbeaXt2jjCex68FHzrB6ME+vX8GPY4v/dEdStAqfAhOaljJ5X59fKkn2nCC5amDWMPJenDoHdxy2uwP6n8BlaEGPeSuzLz91UNUTC9JpNl+X67gciqGLT95hjKLwWl185YNzQQWf4CYjiYdOMYpgpdqIwzUFz7o3vmJlZUed+/Jfat85oAF1I3ZZbEv4Sk4qXdQ2bY5nlo/xqZlhcSdhoYCLrWXhcfQkmyvBJqGSwJjRKT83e9SpStrtkq9mGlBR5RGPCij2DvY1IHGUkD+YXyRI22V9IdNV3VLFSpqUSJQ1qQCqGbytRwAagObCKnsECe3XNLnC5/mqth1rD+r//hvYF/Ih+7Xp0FGMMMhTbI6P7D2ns+hbpZE/iAJfdy7rA4vzfv15UPSusO9yHUSB7QHAfomTz2VbD22CgvJ6kheITObVenI01t/vvdpUWI8h3LuRKWVLXSqvmZIejgiYBf3RuBaU0/k5VEcaMwSRwMiGv6y5BiBf70uUkU9r93DKorkHukwd6arXPcCtVRtMzJvjiY0H/Z4jhuIuOySADZQAR2vNQN7xj8M79FjP4K4SlzzeUl0qnxhQpR7Aa1cBjQLnfhuPldRldC0Zt1uaQ5HaB+AB4OYUrsWAPwZKH2rDTbd3+bdXdlnIzzQEZoi4uBqwV5PXH4pShOtmHy+PHFMZJApFWbX2mEzGJOEpzbktAV4Gkcylb5u16FTxSpr+zHEKmifQ3ejyXypNzmbm4SFZMcUUNvjMkpnekbUfBYbBic8W5rYdWN0ajFRHOCJn88gPgRUiPLRB7w9vdvPw6tUtpUIpedA6PMvYTLs+4JRC8EyFLglMTmNOs7BgoZvbWj
 dZ8siOee
 XQiDeNDDkylBjqiJ4PRJoSTSxg5xRwz4Be8e4cT4tyAOuAo7sT/yBQIwVGyKQxXz58BKb5jOLktGYj4ncg7M1xTKoqBNe8b2ADDbWSm+r/27Gl/wmNkSHxdR+i+YfB4X9+5Mzo4joO6Ib7o1lDHF9zN9yd4pVjSjgrk+cbIxMBcSe6NdtThNRyMd0OwcBPK4QVqrjiSRm4teQmttUZ82iAnjQQE2G6bmV4Qmj8gj2Q2Ajp5nn8zOj5QCJxNidcj9HlNLd9NuWnT9hRF0ArGN73tyG3ECjeMVcHBpBrnceMHu6Ezr47wM4kJsLHgVqUZh5ESt5JyqgGAzdhbh3davOeBQb5tZ95OzuoJBqSKlO4+6S4CeqEuU/mF2/SMs6jxzh9Cj0z5Q9t44p+Z84EkxOhnOp5+EXAfA6StVHTsMOQNTg5932zVVoNlYwb0DQtsT2TmAq3Xd3e+VV39svqF7PRPBRk0V/IXvw6JOy3Pa2qBet1Cp6lUu4VySc8FJ9sTV2bjZUye3uxd5joTvTLXoRsUw27cdQZl4w2BP/ENopKIBAOytAcSLqOOQoRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:31PM +0100, Lorenzo Stoakes wrote:
> vma_assert_write_locked() and vma_assert_attached() are useful for their
> own purposes, however VMA code absolutely does allow the modification of
> non-write locked VMAs if they are at that point detached (i.e. unreachable
> from anywhere).
> 

curiosity: I presume this happens mostly during init and/or teardown of
a vma?

> It's therefore useful to be able to assert that a VMA is either
> detached (modification doesn't matter) or write locked (you're explicitly
> locked for modification).
> 
> Therefore introduce vma_assert_can_modify() for this purpose.
> 
> While we're here, make vma_is_attached() available generally - if
> !CONFIG_PER_VMA_LOCKS, then there's no sense in which a VMA is
> detached (vma_mark_detached() is a noop), so have this default to true in
> this case.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


