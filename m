Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E852C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285066B008A; Fri, 10 Jul 2026 14:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235586B008C; Fri, 10 Jul 2026 14:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100326B0095; Fri, 10 Jul 2026 14:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE4E76B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:59:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58E1E8F803
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:59:24 +0000 (UTC)
X-FDA: 84973780248.30.7B57F85
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D5841C0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:59:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eILQZwnM;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783709962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74B4rm3uR5k1lRSPUh5wFwkcdLxEy4GniWsMlOdHPw0=;
	b=6tibW9Av5pMJhLiwIstPLS3jfXlyZcY0aZ7NZdwXwUIpyTOaReZur0VaBvwQEQCNB8iyDO
	4XQ6vgMyizy+hCNOSOzXazNzkSsxgGh+a397K5lnbn65aNjigz3lOpXnnJ/YoaT5L4maOg
	bx+AJ0NSx/KNrwtNuPIItFXgcL8LdlU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eILQZwnM;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783709962;
	b=76PwP+8bzF02tH8RvCh2w+5VHMN44P1YeLWUl3KajSjAZurz5iRYTiHlFg/2a4fXz0TcGA
	AdJoViFnbFEC7YQwRF2JuNAKfnRhJYbB/2BXI0GMBCyjACVYkvV37Yxk+yZsBMyzVanAL0
	QPB9VJ0Aw3s1Xp5PZ0eG2FNFC8Dje7g=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c21495722so6151531cf.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783709962; x=1784314762; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=74B4rm3uR5k1lRSPUh5wFwkcdLxEy4GniWsMlOdHPw0=;
        b=eILQZwnMIq/TFFhjdLwkJ7n+Ke9XuMR0unMO/mKA8R0TZ16bC9rnNa6B2Ke8+faQl9
         LeyPWWgDmSom4fB51T9AHqYO2YUA2XunK5gYx0lu1ChX2p3sJ7FetNBX0wtIkWEhw9Yg
         aTeyD3NecHzUExjaz/j8eysqTAgHipZ9QOiWvgBf4Q7Ka34I4vd85+FIFufFVDkniRUh
         ppyvHuzKKMrhimm2pa4YIx/P9LlnFtJ7f9Ay04GVpTWkqCT3z5KxjGthuDZwrs/I2h3x
         ipSy4Ly7zAL2XeKgo00F/kJ0nRB+f9dsOscAiByKRRBaMF65srhll1t9bCsgKQaKcX/1
         u8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783709962; x=1784314762;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=74B4rm3uR5k1lRSPUh5wFwkcdLxEy4GniWsMlOdHPw0=;
        b=VwNJQjbkC/oIo/oowjGfjrL+fqxYGNBqQuvBcrvV5y01RdDQMvP8TIHYIoWYe0afC0
         9gdqEGvUwA117BABcjzgUzxK+BBoPn8r9JjzrzopkWD7TAoC4+HIrcUa/gd1gIdxYGo/
         NjLdbwBxL76dyRc1QdI+PenP0PI3w7agiv6EjSmFiN36ItnSJWlgwbTRf9hceLu6hT3J
         poEOqYo9CU9npkNk3JdgetuspQ486aDwts7/X9QhAPt+P6l2lOJ895mV71Mlg4YV3Qie
         hXpJaEdmZohlAMwEXJnrzAztB30mmchSMyeLgkbsR34FONcYwTvbxQut5ZCOjb69oY/0
         TzOg==
X-Forwarded-Encrypted: i=1; AHgh+RqXKyqZ0X8DuV2EARPMHHW6ZG8C+FGN/idR/WNaIY2eQWeAllx9mzaKgWvLUBKHsZgqMvzSwN+eQQ==@kvack.org
X-Gm-Message-State: AOJu0YwmYV5z1PfG2g68DDbBsMEz3O7656Gp5I4zzjQi3LiYkdS2zCM2
	wrQe/wyqsHML7h7OWoioQWNN3w1iMn6HB4WUI1rwjft6ePcvxGGAGGbC/UyqeSkHn70=
X-Gm-Gg: AfdE7clPWAr5J9uHMxZRKr9uG9y1rhM0DDTUfXjfMWg/xeIWORZ3NoHgiytXSFkRy7d
	4twNd7p7NBaW7z5L64porKg9rUnmGlQ8mOGthx95naYlzkMaH9AV3rO51B4XUDvaoqEBK9R1dO+
	ivOeC6m2O9z9R0i19RHZTHhvOL9KdLtPGoSvTmTUKgIeXNy4cmTP4rLjsETYTYQZ5/fJDiY1uKT
	BqVAOmcREztfzPmadUbNNk0VAITZtlwvXDBaEP385OVHFR32fOpdZ7LAvWGwWtGLt735Pi526Mi
	4v15EyNIujVXG15qXk13qONR3//vlnkbjmZA0PAasNF5vOGKx22kCKk1aT77xB+T+HqbT9cZynq
	k/oDle7GAs2wlU2Xus1PLfEWTSaWyq2wonegjgdRebRh0zVavUa0eVO2BBacfLStlJjc8QkRrwM
	QUIDgTOn7BT+bJSGxub8hBpcjDMbiZbDc9OnHYWN+dywOqRaNjS3fdUkPdeZqtxfxJcoNr
X-Received: by 2002:a05:622a:1b17:b0:51c:2101:ef with SMTP id d75a77b69052e-51cbf156814mr1787851cf.19.1783709961653;
        Fri, 10 Jul 2026 11:59:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51cb884e0cfsm12321961cf.29.2026.07.10.11.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:59:21 -0700 (PDT)
Date: Fri, 10 Jul 2026 14:59:16 -0400
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
Subject: Re: [PATCH 24/30] mm/vma: update vma_shrink() to not pass
 unnecessary pgoff parameter
Message-ID: <alFBBGN6a30A3bQ9@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <6dd744d57d778f94d2fef8fd623d7c4ed8010d93.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dd744d57d778f94d2fef8fd623d7c4ed8010d93.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D5841C0005
X-Stat-Signature: wjhbjfxkgmueyf1atb3eana3u7q9ckzu
X-HE-Tag: 1783709962-198999
X-HE-Meta: U2FsdGVkX19zDnQPEShVwwgJ06/a62cTFsD1z5/5Hr7mh5jHLGLOlAClBTRPsAZIDNcn3MYhKxAz670HTZaImbGccpZmoep2HhaYJz1YhAY+Fo+Cq/XhJRCg4jQM1w8EVLBkKQc3zUeHPOKAfly3S+MQ90mu4WPBBInARwRgHpNOkcfS6wKB6ll5jCxpURoQcFfhDMFhqDqlfMnsl76syTvjc6f1LrPFez0OkH7T4LJr4zecI84UNDU5jaScU2IqbqXTGgrqJDQDnfhiHv2c3rP2V4IDUnG5PTF2GH1IwwWGb3sGJ/OjYA6vvzICLU+vmP3zunJmw+mhNC9oH6ShEbUJSTawEiwVMiis/3xoKMb//s6Td1B3cR2wt2PI9g1L/+g07hWDi6c/xzPgyIX+aw/yNpe5IRJSHECM1mLF+8qtglR6/Ys7PyNIKux/xsZAKA1v4WBt8UAelepU3DqahyZBLP1cTbKi621JF5XFrseyKpX9FDtNfnbyxi/bJ505KbTL4ZCyYvsN8gEyEirBvDVVS24eGGjAgcQHcp9lfg/8GqS5Nu3mbzPtbOh9mLuK441DGphUnj44hQ083LH9F0mINrOviLFkD0cmxUTGv/f2pmCjOoDPmfC5UO4ssBxSPZMrTWMqih0R37jn7zz0Nb8y6ZHt6uUK7cbb5leSwVyTj8IyUnBOuyia8VWiTQyHU03e0b1NYEsGPqGkeZ/Q/SR11kSfU03K/k8rFDwrCyKxbL8XdyQtu17AgAbL3H8B22bY1Qo+r8caR6Jn6Lo8OSPmdzHAp0IYbQXePESIV9eGsBiEyqTt7n3Cby5lIF3qDr7BKHoLFsbjDIs9CePmpCgzsIz4X30uLrXjR8UA1GoYvD7cbi65cypJde1/sfS78WX0fWp5ZpiCmkPanSYhutn+b2g7+NLafAdNSxSM6KWi088EDdYuPuiLqIJd3ViLBU8635NRkx3+01Nbv90
 ZjFvsbhx
 ou4+tWEnSe/YKShNSOC52u0wN64pgDVsHlZlPz8oOBkTPAckAPOtj6cRXcjKJRsYIgw7BzqAnx9AJXhOnUMhlEEUBQFyvzT0v09vjmQWbcIA1STQ+Ck56aAkip0Eh5CGbwsjLJjmsLXOQpAvd3F0Be9xDpCqB8noyL3yEJ74eK9xqcQOHtbuRV4aUDGR9KGaM0paeCIqoJeHlZ5KyGbI4l64COSTE8fpOV08w40bdzHgzN7mLy8qZmzkZ0z0k1qnWHZzD8rmOpsx5lcbXIl749eOJLcqY3jAWnrNobqLdIpPpGGEBK3vRwVb3BGz3y3fzNq5pBGgBcE1D5j1D6c9ORPx7JPKYAkEBPPemlt5Rf/OrBSgm/Db3qbEEfxfVyqPMPWD3WbDdIchHcm8H2eIbb27dq4foO5IncZdn8IqI5WXgCQ1hqTRazOjaBqZo1z/KfHaewh3VRdL5IXfpJo2XbGWOwIbkRmmDedKKJ2Dq9yfcaWmvX+CdzGCKShtWjd8w7BUi7cguDp6afVI3pjYzFO4dtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:35PM +0100, Lorenzo Stoakes wrote:
> vma_shrink() does not need to adjust vma->vm_pgoff, we were passing this
> parameter solely to satisfy vma_set_range()'s requirement for pgoff being
> specified.
> 
> Since vma_set_range() is now isolated to vma.c, we can simply introduce
> __vma_set_range() which sets only vma->vm_[start, end], and invoke this
> instead, removing pgoff from vma_shrink() altogether.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


