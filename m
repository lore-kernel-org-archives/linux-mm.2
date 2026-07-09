Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD8DDC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CDFC6B0098; Thu,  9 Jul 2026 11:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E506B0099; Thu,  9 Jul 2026 11:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BBF6B009B; Thu,  9 Jul 2026 11:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC8446B0098
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:18:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 337741C1575
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:18:50 +0000 (UTC)
X-FDA: 84969595620.29.13A2936
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 425A6C0007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:18:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CiMrjRrr;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783610328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D66HPeIJnm5ZDnK+VorUOpyiniaZPeUCt2fPIKMnyb4=;
	b=sJRSyCBX7+6EhGvk0lfc2hZxaj8ZGhXJ05UGO/+cCvFgz0C3AeAuX4dd7qhYt7NNHXX14r
	5n2DCPuMs14nbaqvwe/sC6NCziFtaaZH3GzTBaEz5hHzjxjlMfgJMOj1pFFWeGnm4Y86V/
	REC7d4hYQwUW4emnazjOpR1TqMZHLmM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783610328;
	b=lKpeSJigK1lk0UFiAC8h7DhsrfhOoxjpJjUKOk400cUqvwKTGALU59ggzeCmfaIGEPkkGU
	HlXGEW6u522cuF+p+oL4yQCcixy2YdsgtApk0FjnTfFzmpFaImBSnPAYDXbDx0lbHcMmqF
	fIlc8DdPHhqducSxUQOLPRE7IjU/NTw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CiMrjRrr;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c4436d02cso9165151cf.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783610327; x=1784215127; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D66HPeIJnm5ZDnK+VorUOpyiniaZPeUCt2fPIKMnyb4=;
        b=CiMrjRrrmROfY0qDtON6pqzEjLpj+emHUu43zYNd+Ke9nxsFp7dYpxsd54A62n20Ux
         6GhRPmbq8vTEAZEDHzaAaw2F5hew6M2dXmGjbn+4WO3vS8HVXTrGRDBpago1OO6vcWda
         chgp2tVZhRIG/Jj+pJKreSP1Y8ujAIdCwISqDu13DZECelzyFcHTIr7PccM6JEdqIMGZ
         pTVjvw9UFJSnP4nPmiR9glw3+tNXTZlECKt3XilezMIXUv7EOj29+hhTVX10jOjCYY2n
         SNSzaf352k4Y2elZjAn8AuPSh7P5JSN4OIUxxoON3BZO4iPONFMZtbh5A0plOmBH4Gac
         fDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783610327; x=1784215127;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D66HPeIJnm5ZDnK+VorUOpyiniaZPeUCt2fPIKMnyb4=;
        b=KEsjsL3pC+lpiHoLHTKIg3SC1sWXDSYpzPEYYgJRqlGBVqDBopJ8We4iEiVaOB0FUD
         mXMelp9ZG+YSntskmnMiVMzz4HP2LqW/ZQvKnGtV2gXiuQVyz3HdY6NUlwqWD/YiwUDR
         jWQ9+5oJawJZVdDpyFnx/jKvHMBYbZPMMmLTxH/nWBUYOpBDfPrWE4nOo8l+CJOVTgcr
         c7J3BNcvH6+HALQvDeskPQQkw2VsGH42OVqTVBSEOaB+rc9K9NHBbT+AcDnUr7ynnBM5
         rFNK/J1z4E6sfF2SBvdB8f4JgeHdFyo98pwcem6aN4lDY9qDXbDvZBKXORydrGn66wCE
         iIkQ==
X-Forwarded-Encrypted: i=1; AHgh+RrAVwlJhPPZdPjD7OUatum6NoH+og+Hmq/3ZfOwhR4uoKGHjFyvkmTi3Yqq+/5bfEVP+tLQ0G26DQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5hdscrAcV7xwEvS0hzVqOj+tADnxzwUICfP3OTo1j/qavucXG
	3Qw1PNcQAmDxj6wPUuUUTar1iMpPf0QXRPveBjn3Q9/kobnzNTmAfBW7yI/OkLgVMxU=
X-Gm-Gg: AfdE7cnNixoKK/WRi7UmM0r1Csw8A/SWiVsaefNL5foB+Un3y+Pbt6ND+E3bF373Kdd
	RZj0GryEBBS2zhP23yf1Au3wYLSUZSMSRXgiOYGqa+S2AqEELq0AKRciO14KoRgv++wT+vu3Iip
	1vFv1xA3bJ22DxITsQx+VlNPxroZsYV5IGyZ0a8bGrVr0GKO+4oo5zUFVBfjop7KHlt8789X6jc
	xhU2dpn0obvqc2ZQiu9c0Phxs4GC6KjBvnkD5Db6Kkxm2wnqm1hrbtIGmCuSxG/Xx3jtMmQd61m
	W/02JW67glBxNaUGk3JWGjfXyAUC4VxteBUhuE5EFQBRi1GV6pX6LSLFWpttp1N+GXUbHs4RhE/
	Ogc6Go9jjgkzEAYdj1aMrdmUIGp6LJtYS3bN+AuO5mEevCWeUDDWjwml5wrEobQcaNdkkWMZiSI
	1ytr3Yb9UFWSkeGv6fu9evJBR947ie2oh210FLfLKNG2pme44mOUewvtVoPohoczuGo0KYzrDKB
	bN/U+0=
X-Received: by 2002:ac8:5cd4:0:b0:51c:1c2c:a8c9 with SMTP id d75a77b69052e-51c8b3e2e32mr79753441cf.43.1783610327278;
        Thu, 09 Jul 2026 08:18:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c41db4fb5sm158006781cf.25.2026.07.09.08.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:18:45 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:18:40 -0400
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
Subject: Re: [PATCH 13/30] mm/vma: refactor vmg_adjust_set_range() for clarity
Message-ID: <ak-70CHGujkI5jJI@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 425A6C0007
X-Stat-Signature: bjkswa4o3tiw8m9ctox5rrz33oz98xbx
X-HE-Tag: 1783610328-539209
X-HE-Meta: U2FsdGVkX1/7L0dPbPziXJEduGU0mDQejAoB52mpVJwlzcgZjrbVIwvor6imWBTWcJ4A1GvX/NmpudI3WwzSw85qCRJUsQ6gjwrfaGCjNcNJzcluJ4vC//ccjkMypko2nyUeox+ualeUSsiNL9A/QItZ0Qj6OpMyPWEv8GMeyz861DWc8ayaP0EEF0O7wkt4VwqnN0fb7lYKkXjDPBZIEvsE/HAREMAir10RNwheQIeKlCjCNeLg54sWIydX+ba/0Wfswgb2BFlQO9SnUxRodoDtWzgQL6+uJxgpBCgoEHyezjOSZsAVv7HUeo0lsXYNL8Md4OPpxfxajT6LIhv5kmBr5wvHMxSaZtAAIrvP8irqEdo8ySlIcK8/Bhq9xpa7RNZTN5+f4IF1PkMFTnXy3xOhpF87XOX8te5DW1gCaIuskiGtE+KyrQUI+ZAHKIYk/YOHwWHWUCJF04VCIU655M+8WUDMo7sKjxhPVeK7odIaqTUoW9mGG6rt5R09ymWI9Jc80eOAFCD+e4FQES0lpuqq/JLSjTh/lvLWzD4CZcNMsFgptThlZQZB4cqCeNqLiAE32MR+dF1f6AjG6vS3oxFbVi1QecnUvhe+WEQPoSSosicvgxdmvZkZ54g4QnjFnguhG00t1rsYRxvOSg1nkt2ENmZgIGmnSilzi61LFFt9M18+x+axyfXTZwJ87u2LIWvkOvIxmmMOIbBcGU2u3WwGwruO0XhTYRdNmDflJ7fv89+T047Tt1LihUepnf/xwfTWwK1i7fPg2gmYq5lSN9YvugdJ13tLw5iByq72avDq3Ho6CTGqj7s5Q7ikftlkh1G3wtsAyQLB8cdcgSHcFdPAD2N+Kk8x+jxsNL5MWXa5jtSedYS5l9sJqxwrJeFuEDNqHDiQTaWNnBepbYdXpVnpq46/sKtwGMXEgLOF9wd9wVO4MlZa/NMIc0fiFJPQh8QHJteSPDlrzU3lKdP
 6ZIQxehJ
 bs7XfcjBs0AdkqZ58OibjWT3QYojTeVEpsF7BhyHlojzWRhtHkgL7qfVC5IGeqFUxACzxFS8rD9zizUnnyzBVN3uy75xaJQ/sc4PLWkybo2a6TLro/paNB1/FBEP8kPZcw3VEDGfQ7D2rSxzQoixWfGusSUAWBr6MO4OyptNhrSurU0A/XcZhK+RR2P5NYaf/pXwTl8eP0jSqm6fRjxTG2bmtm5jTYRmXNQKOH39xvICVo1I83t1zaxIYmP3v04Y66w60X+YGsxBUsEtKY020UM3NkvkDYzKpMZYJkGlwiCFrHvYVch7jdYCOjFwfupMPLg87yUrRFwkWlJzrUDfWLsGYGQdIQ1lOsvX8z3pd2ocl1sNwllrxSJr21wV8sH0Zzd8NjjX+VdD4+YG3rHZjmizDrWuS1lvQ1bFyFP7KJH5vIlSP5fUpWJOQtjYJQS8A9n14t8mqtqCk5cQ2QDJNBR+xDVZ1bWixow5Nx7pr72xwEyAyAdBpDSXPcwZPsSRIi6wTWV366s1t0d8QfdRZikbU7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:24PM +0100, Lorenzo Stoakes wrote:
> Add comments with ASCII diagrams to describe what we're doing, avoid
> dubious use of PHYS_PFN(), and use vma_start_pgoff().
> 
> The most complicated scenario represented here is vmg->__adjust_next_start
> - when this is set, vmg->[start, end] actually indicate the range to be
> retained, so take special care to describe this accurately.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

> +		/*
> +		 * vmg->start    vmg->end
> +		 * |             |
> +		 * v    merge    v
> +		 * <------------->
> +		 *         delta
> +		 *        <------>
> +		 * |------|----------------|
> +		 * | prev |    middle      |
> +		 * |------|----------------|
> +		 *        ^
> +		 *        |
> +		 *        middle->vm_start
> +		 */

Even with these diagrams, it's a bit difficult to understand what the
actual intent/result of this chunk is (but that may be a limitation of
me not spending enough time reading the surrounding code, not a comment
of your work here).

~Gregory

> +		/*
> +		 *                Originally:
> +		 *
> +		 *            vmg->start   vmg->end
> +		 *            |            |
> +		 *            v    merge   v
> +		 *            <------------>
> +		 *            .            .
> +		 * merge_existing_range() updates to:
> +		 *            .            .
> +		 * vmg->start vmg->end     .
> +		 * |          |            .
> +		 * v  retain  v            .
> +		 * <---------->            .
> +		 *             delta       .
> +		 *            <----->      .
> +		 * |----------------|------|
> +		 * |    middle      | next |
> +		 * |----------------|------|
> +		 *                  ^
> +		 *                  |
> +		 *                  next->vm_start
> +		 */

