Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF5EEC44508
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DD916B0088; Fri, 10 Jul 2026 17:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5616B008A; Fri, 10 Jul 2026 17:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4676B008C; Fri, 10 Jul 2026 17:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD446B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:04:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D04AA1405A8
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:04:06 +0000 (UTC)
X-FDA: 84974094492.06.96D3CA6
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 11D3C100011
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:04:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gv9cD8v5;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783717445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhI7UcJVN9EaMSo9cM31eWAmb7Tf3pcvHFHtAkV4RLE=;
	b=3hKJJ1cVwphVCmx6qn8hGzzubzvv9Oy9lRoc2I2D0DsxEB8I2PAljhQoMUb4n++oTS4q3x
	k4f3JpkeSI69sh2iARnug2gOanrnPtXikaMqnoDHaY/uHGDlNOA7H6yBz96/uhb68qKOYz
	pM1pNTk3Qo5CUGhubw8UFYh1dU23Ogo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gv9cD8v5;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783717445;
	b=SMgALxH9Kht5Wh1MKAZH7/R5HD5gCsJ1KqJt2yVNPhMjai+lcmXFew9kp5Z9cxhmAlREJd
	0QvHISzLY5XjCXtRDd8mawYipSN27cxMTQUrisXVOtnakHFLEMdQLihuAx6Op9ZIPm7mPr
	0LejYIYNWCPW07td2BbXjsq+LmjojH8=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8efb708b1a0so12023466d6.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783717444; x=1784322244; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OhI7UcJVN9EaMSo9cM31eWAmb7Tf3pcvHFHtAkV4RLE=;
        b=gv9cD8v5tNfJZ5g41+rOZS+ZeCPGVFkaqzfDmPtbIltzUE/1iGBHneOpYjcFcN2xqT
         N2Rzd/X5Xpdb7fNtRuIoUUlpQ2mXJtFC6tDD5UhmZiK3KixltXIMWYpgm3lJw8TE6ltu
         fhv5+N5zGwFsf2jWgrlukTI8UXQXEmxVw2h5pY4BRNBd4EVL+k/MjjnB4Ax23060Ax6i
         UTX2fN0C3Vm1pIQ47XWz6is4UQuJBm4a4jr4pARawMlNUhcbSz7jOWS9KjfiLoRi46Gk
         WIw4J0tUOj6COxA/EWp1AA5qg+gP+gvD2B6j8slKjoLAQv4s2XaE+hOJc1uT2cQEVTWN
         8HIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783717444; x=1784322244;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OhI7UcJVN9EaMSo9cM31eWAmb7Tf3pcvHFHtAkV4RLE=;
        b=hOtdozgQh+1A81Dj0ZmwioLnsLyHmC1gEtWKzASn8GaHpco34acBBhm53EJ0tLn0wT
         U8B8YZ40COgkM8661231jbCnktnmxbOn/iseWN4bdVr8pAWYfqswErtDq67PmaTLIT/U
         3LcP0LC/vpopp++pPyCHZZtbVQwncxSgswxebCp3F/8kAX+3xtx9pOT8HweIsJJKNNM1
         MGfhic4Mdrf1YWBS2Gu8jVuwVtmRu2NvAjr26++tUEw0eov10r6qfODNLWS14EcsgqSu
         FN+c6KR7kLOyDn5zsa46Z76+vxuuwJDKfcSTqveZfZdncL9OgUvg0V+wOUsF7ZHAr0M4
         mQOA==
X-Forwarded-Encrypted: i=1; AHgh+Roz1bxXenQpQCLbzyTG6RCFjn8s62vo+kA5H9GPfx2rR7+o7XnoStjiaTNFM0U/yFQSA31rZx7Z2A==@kvack.org
X-Gm-Message-State: AOJu0Ywz1nyHUav8vn1WoaNO8Dt6bcnC8KhXqk4fG8WqgHeEhiafKfVj
	ApkTXVtTvfgdSu7OyWPfrBWw/z8VdzBTzHIWo17Ivye2JSBA6YSoNWpNwpszLVATDCg=
X-Gm-Gg: AfdE7cmfwjNL1iqvkJqJD+R3TOzszNrpjE9+EPQ1TrgOk3Z92mOwvvFQdPFiRj7xj8H
	auQgEQUptcEIEPkP4xEr2c2HlP0s5yPJPbbDdMPucgFEQfTA17LrF11zYBFcTd91jsCkG/fmfuz
	P5f4RBKF9aXFxHlwORvHnSE6rNokNT8JpAcIA8k+wci8WekxCc5fXNWIGqD7P6qXbp9qrWnjADj
	0YZCZsFo+lRz0BEhng1ZxH78ZAMF13VBHtxz6d26GIEa9bpaVv6IsrfQFAqbwd04wkQOmahoIXB
	3koMKjNNwApI4iQ3q7HU+7uQV/vAYTnEIr46oINJynFDoMgJNCg5YheBIuOfhdfYoJisGChlUzH
	I3eRt01o8DBY8fgQJAfQR1gKAOStMiAS8FYJcukqCjQ/tYJIUXyRRC2vEaybC6XDS5eZGqsnyKH
	4bObEfgwlAR5R7k11JOVy5hldwn1KsN08L0pjUocqprBRxYRn8afFB09vkv1jn7iv9I58A
X-Received: by 2002:a05:6214:3bc7:b0:8ea:10f8:ae87 with SMTP id 6a1803df08f44-903fe450f77mr10485176d6.11.1783717444207;
        Fri, 10 Jul 2026 14:04:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50df5e2sm50655596d6.4.2026.07.10.14.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:04:03 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:03:58 -0400
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
Subject: Re: [PATCH 27/30] mm/vma: correct incorrect vma.h inclusion
Message-ID: <alFePgFUR52GgBS7@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
 <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>
 <alFJUfaGHVnKd-Nb@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFJUfaGHVnKd-Nb@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11D3C100011
X-Stat-Signature: 6oa7touxgnubpythoubkmknm45ug98xu
X-HE-Tag: 1783717444-872005
X-HE-Meta: U2FsdGVkX18oj7YJkAAc2+9qgulXoce71rRGpUJs96p+Nd/dPdcQt+Cq8MqbBrY3fSpbA8zfAimXc7JnIAbPZuPaOJDXGP9DY8Tozf9fS1w2l7SbqRGUwSQL801XT59jkrYVkWDm62epz9RIfgRY5LcjRXsZbSSN4nHre8VGnbnLPvJrQN+IdNKxIMNi9zuSWTH1baN+ce1UkvqreqZyvUh98oBXHMi9YmVWiOOCVq7wpKcTQedd2DHzjim7dZDGijoOmZH9euULpYMaBc2VRycvaVDX7jEL8Hs1ekBMNkLdQYgEkhA+UPZigzGtTVB804U5pnvf/G3jOG83XqHNAA+H9FeZjN7+XY4Miexumk4KHlBxRALHt+GXHaIQTzDUxbQc9hNyZYgGOz7jglsgdB5FUr0Abj5H827COo/1CrgeXzY8YNKpn4E+Ua5y5VLAOkIE6Sxp9/01ZJSaOXMiAMaJhTZrr4S4PF7dg0vydZu05Qhnc6PuAeJIG/bv4FfYPVueqgsQk1FWZLbYeC90weNJ+W4Plm5AM5gP+KhC5HO4vpYDLW9F3glybVW/N4L1xgilCmV3cnEL6fYpI5xEv7Fdpk5GunO/cCYJpcZgiRZ+dQNwgL4/HKD7DtAttSytVtDErf5ZHmF8fZ2xbdZrxAt2XzpMgo6/5vKAar4JkxeaPpXEVDt57MADA/6/315jjQUnDc8Sxk5NHZZgS+oGlDbdN7A1tVrirTHhTjgsdZNaRKJIWNnmCXMMhQUDN0aEGy+XNkv3ORJB1ngl6nk4H6jJhVdtdfY/MosIEdd1cRGtISKFqggXuaTv67qu38PZuaXuv1fFc0/EIlTFg4+n70ojUnOSObRPedfu8zKutAsqLbxOVCVS8/YckH+7AtBJeTLP4OrqFUaPwzm6L6QM1wuOzTxT5xnKflDbwIPFI3k+A7T0b5Yoxq4/iQQefBnjMT1doGvqTZONHJK/dW3
 SvVkjbgp
 XZvKcRo3DP6mvFcs1Pn6USRatue/5PRjiGPBNq9nejGq2yDnYs79PK4JV9L+igKLKboaJOe3cjDdZ35p4v0D+vWGmskf/dxbd7kI02SUHrUVGggb9qCsg2WtQ/e7cm9UxqOQ65i2Mxs9lsYYU13YGFTgrvABJ7+zb/p2Hl2lbJwYVYbFdwWfNVKlYsC7VVVb41USSSP0XEP87aP43ou1VmhyAPNdsGKi9Ku86LQdUvOqXFDtC1ta2UZQy9k/kYjC0PHNo3WO8QG+7iKlYPaFF+C20JfZeylzwS3jMUNuddPUKZgHCzs9t0xLy5RqMLTFoXoVBJMoYzazEcOKeSybPFGjQlyhitqC1kb4s01Hbr3/QV7o/zZQPsduVg31FCYKQC+rqbCtVXhGCSqE6daXrQ/lVjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 08:35:43PM +0100, Lorenzo Stoakes wrote:
> >
> > Do you actually need 3 copies of this comment or just one copy in
> > vma_internal.h?
> 
> I'd rather have it at a glance, it's a bit silly but C headers are silly :P
> 
> BTW you're kinda racing against time here as I'm on the verge of sending v2
> :P

:[ i don't refresh my inbox when i get hyperfocused and now i am sad

