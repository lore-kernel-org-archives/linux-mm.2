Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 101ECC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1116B0118; Mon, 29 Jun 2026 11:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA99B6B011A; Mon, 29 Jun 2026 11:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE786B011C; Mon, 29 Jun 2026 11:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6DA96B0118
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:40:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A7B1A01CD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:40:22 +0000 (UTC)
X-FDA: 84933361884.28.4123380
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62BDC140006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:40:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Yjk6ktig;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782747620;
	b=HunxbiNiTEDmbPMVauPCa6S1DuyYV/ZmKzTvMITKFAqoPp6BnURrcKrtvvxKllE2VZNX6+
	lmXqMGD1azdrOSpgzYP+oDc3OLxX2Y+84nrhgJJD1lRL3V7AGi/ORAXORP1pdwxICfLNuH
	qpDYGApqdkjw7ERgJoUm0pjtjwJqWTY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782747620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwgemlAWVZOfyfvrJ+7cyHmQGRLai3JgFnH6EFj5//k=;
	b=ApDj8D0qxEh0ppUxfzEWpWmxtqpidRxrF0c/UqJ8IodjWLlVAlC8lkpNt2Nvd6yMxzC7J+
	CAv7NzDMF1Lia1RTn/fUkLGHtZyUtBy/sz24GatA7yvRjv9PlEGul5ES7dUBzpoyP95yth
	6u4es0yNVrlmGEsrtzQpQ5Qd8liCbQk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Yjk6ktig;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-519eedc30a3so33870481cf.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782747619; x=1783352419; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VwgemlAWVZOfyfvrJ+7cyHmQGRLai3JgFnH6EFj5//k=;
        b=Yjk6ktigkFzCsMFmVwIDbzWWwO+Sx+hRvMISrbSVJqt1GXlmGiEXQ63qgbmzs32cMO
         AjUljR8qjHq1puircIRjUgZqftzPP6/cYns+AcCJ6YMuI9onER/bmWtZQf25TVtdLD1B
         s8b0hK551TUL7ORoUaJfdvKNLfy+3MermfhdrB4+vBRMK5GnseExDrbo9wFFla89cPKq
         n1cU7Q5SWP9xr2NRVg4rsLcl1vZVW0/nQD3Pa82rPu8tWx6Yz4GcKhY2y906oLlYHB8s
         Xa3uMN5LPqMkT90KCOPgNA2lli/mbFsknbgRjU9f4iOQnltSO5hckbjRZFxGwaBQfRXD
         qt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782747619; x=1783352419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VwgemlAWVZOfyfvrJ+7cyHmQGRLai3JgFnH6EFj5//k=;
        b=HsudmWXTKQaIlEtVggGFCCvAzzRUrdU1Use01RIevZiVBX7UiEZdx4+ONCrasvsCoQ
         Irgm15e0XtFHAAw7iPJBUjR68FA0D+w3Ru891l8LnOPWOrI2No84UELKNu4qWO6vFt/t
         fmDLoPtLj3Tv47ozwrOpGV/n0BtBvRenRIcatddwpQ/x5J9B74lK7p1hH7VKXwvVT85A
         Jb4pwgCg6K9QjJ/8309R5w2DvDORhAVakq9019APmYr7oysOY2CqKzWZxABvDr4xGtlq
         wCOXrpYAIsLRlG2+ZRhMTnnAq34XWiJeXwi48qkIeLmSqc9z2gcgyysriKf8bOm6ybv6
         6/3w==
X-Forwarded-Encrypted: i=1; AFNElJ8Ha/v2TxX2pgFybXA4AgZyPfQDpVWQAZPfWJEyuEQy6jGRZFVczl+60Pi0IjzX8EJ43bmkIaL5ZQ==@kvack.org
X-Gm-Message-State: AOJu0YwjnAjihekICa1B7ZsGWiq+SffXl7UAoNly9W/J5POm3//+c5mZ
	TEl7YrEYwWFCTXYqffF5HvRUZsDjbjwhn37Ef2tBIScNCcXHq0xmK6tmOScsAvD9GK4=
X-Gm-Gg: AfdE7cmR1KgclhJP0A1IA8Mvv3JqS/LepNW4GrOoc15RpE+Hq1vqtCERE3/JsHmugcb
	D9+BPuX11/M/qAUbLMYAeJ2er7EUNhE46adQHOSJhD6+q2bawoTk52gzE2RkpGSHmA9/1Hy6QP0
	WYzbyXBDV8Z8i66FHsMctb4t8HNE3hxR1pKIrQe3fu9s7eME7wfbe/18SQ3p8KMWTaA2CY4n1b3
	UJS6KiGgviVSSWWJ95yJP9+EPLBWvFmhaj1i67mH8SXiXmCGMsTKhNsjPKoNzrww66axlmGVXqz
	NxjvIcpRZ3z87tO+V2Ae6uDxS4keVgIKVAtSkA5jxzuRDRu76c0F3TbtzsveBLuAv9YTAWSVh4n
	KhaYDYY8gSRXdqJF1LWTgvQPCxAgLsv+vnKPSK1JKpkQuXW5p9NcV5s00Sp+/uF0omZhBiCSN4p
	keVdJKyuP3V7RVvWilHoYt8iJvT5J4mE428Lkz+hnGCjvKMzZa66vObWukMSzRgbFPefse
X-Received: by 2002:a05:622a:5987:b0:51b:f635:9aa1 with SMTP id d75a77b69052e-51bf6359eadmr68650541cf.48.1782747619393;
        Mon, 29 Jun 2026 08:40:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a876c888bsm78114501cf.9.2026.06.29.08.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:40:18 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:40:13 -0400
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
Subject: Re: [PATCH 03/30] tools/testing/vma: use vma_start_pgoff() in merge
 tests
Message-ID: <akKR3bFV7393yOUs@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62BDC140006
X-Rspam-User: 
X-Stat-Signature: ttpske9pgnyx5xppqfqa5wzxs8hfp74t
X-HE-Tag: 1782747620-892859
X-HE-Meta: U2FsdGVkX18U108bfUZcUlE5s3VK6PAmQc0X7C+ZReX5hMHp1yBpv1t1KP+qnOqrC+qAntKHC/syk14uchvHeg5/WINFUASq6gQrY+8bAD8t+ZPgfkQ98jFvu9psfn6Z9NYoWeA8LAy2sglCMbcI7ARMonvf6Il8d70NywStxVRITL5lJ9nwlgQUt7XN6OwdedtXslbeVqIbfjREHmMUziY3u7dw8if9BqgEiAHRNFRarPaapVWmyd1d821Z9aozfFfHThrDYgLJhBqI7MAtigQ71IW5w+wdthLUvLASrDRopGuDeWzmlUDgZ88M/255+kvs3YLibleo1+mZ6iK4saXbUq1XOfZI+MMjdDwGNS0AEDEzvevayfgqVXhCk/vEwts64fhLTQZvhPxL8SC402GLdqRdZWTdRsVjnVb8oqWUQwaydbrJJjB2yw8NDSSRwdKRILjSlRmYJ9cIX/vp9P268V8ysz+ivoPE9HaV8PEqNSNFyVqzLjFc83Ty3s3fZcLDbubgPCZsN9TFvUV+eMZs6gfxfmCrt+J6G3CABFA9fdIdwSVNlBZpn+uKdMOfIFyTJwb6rR8znspZmODA/0g7CeevgehIw3fxTBnwvYdWDdvkzsAv5PYSp5pMQX8zs93XdMV/t3Ht/QgbW6VEgtVgYbklP5YM+Fv7qcmg4mBU50tkOVH/PbU4oMFo53mfzcldj+osVGf4VmT/lTJcZtglAq2eXZYiu8WB9/+firbjEX4RGg+Y8oprZxUiLH97OvmR0OIe6aXPyEaiiPt2Zrkg/E3JZ+dw9pdyyChBrLfpdOgvE0iTbJeQqLQnpIZARSB8SeC9PUVxiFwfdmOMySBDDPRKuvOOXgtBfGRZAoN4qxhI2C90PI+VSBsoU7ZrPMKzW+a+vB1GTK0kHNTxt2ROR/M078HkStDm9tKcyj9HPUCM9ELX7sA9LCrwzcvXn4xZeG7S1FdzR/w0xff
 UTJKJmrH
 8B1UYy+h2V5NEEr8MOw+hMuO95HHKym/+uH0lwpemBX2oPmYlDdr7t+yE2lM08qglkvzxKcZIpqa0dd+mNoHyHueExhaJQLRf0qDo5ZltuwLQtGNEX0nebz1K9H7ZG57av5opS8gFWJq4blGmPISCru9CayPohwsHESFDZT6XjmGrrJnyy0Wp1AkXt7ZIaIJ3H1bH1tSxFRDZNT4lJbitHsvfM9+DFpXxMr/5fFz86brmpW9jk+HpP2Dt9+obTagiw1uWQ117JZAmJlGuERjRXhWgnaxlSSLj26Al3tBnBPfL13J3O2ezn3c+bw3S6adMY0PNG9ChAgqLX4XQZBGrc3b0m1GnBwKPMtfN4gpvS3QTAPcHT2CZtP20LaDe5K67445lm0/L0cEcuGM9bsJf9RiWIjhx31Fe56Wa1vE6MF6Bh5V1lpsHU1kwLeeA9pGQQjlALY3dD5OKsYk510aIP2sLOVA4QBNWslbWWWZBic1XMvo+STM5K6yPEIBbuyspq32aJN4hdwwDB3O82/BmUfzy9Rqe1SBuRbgb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:14PM +0100, Lorenzo Stoakes wrote:
> Now we have the vma_start_pgoff() helper, update the merge tests to make
> use of it for consistency.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Question: Should we have primitive tests for vma_*_pgoff() since
the behavior changes depending on file/anon?

Nice to have the cleanup and clarity. Maybe worth asserting no
one ever breaks this.

for this patch though

Reviewed-by: Gregory Price <gourry@gourry.net>

