Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB916C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD096B008A; Fri, 10 Jul 2026 15:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87DB6B008C; Fri, 10 Jul 2026 15:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926CC6B0092; Fri, 10 Jul 2026 15:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63F3B6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:26:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5488120566
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:26:07 +0000 (UTC)
X-FDA: 84973847574.20.A209DF6
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 042FA1A0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:26:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KRCOGcQX;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783711566;
	b=ZyCtc2gaEag+DBIVAS66I1IAtwZoUq985wo6tlEGagtp43wqJQUN6/29/onp3O5ivT1jjX
	loZBv8wUVU8eIXyoD6MtIWEtF3JousHCmShc2EG3Hvdu1XienqakyvnxuV8cz0A9x2FU8c
	8hvpkBX3/ex3dwpDEH7ReQar6UU9LHU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KRCOGcQX;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783711566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHwFumUUjp1dZn3azv3jRxV2z4/4b2Y11BxxEMyANyA=;
	b=GOtpKv4vgld7YfLeKTTvoIcNjbKhF3UhAB2vIkJ2NAqFQCNPq2So6VzfAcujmdqEnF/D4w
	jWilwe/NhNdghqNq3hVftPV7l1/iPDKaQgoRmpyJbfY4UeRZ625mNajKUqvdSvcrgodytG
	uFU1yFS4d9mry5UFadmMGvnsB+6FrJo=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-920f33347f5so69157485a.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783711565; x=1784316365; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aHwFumUUjp1dZn3azv3jRxV2z4/4b2Y11BxxEMyANyA=;
        b=KRCOGcQXxarSDSa86H1Y8CMdsXMnagrLUKLyWGXzTWS+Zy/5uz4b7CRo/Sg2+k05kO
         HsA0WFpPVa7SAMj3RpkGRXUGK94WQAxl6mvh3aKI3yV38NaRuhSQtRkVRb/8WMcJfVUA
         ASSfcnCYAEPttSerDBnwKikWxIRD11M7Q9ZiFiLsjrZ3F86ukFPLevvJSoX4CgIverZN
         1J6r3CAuwcSljOZQviloWGjtRYOdGEK87+Bw0e7FMy80VoHgx1mOw7tpjpi0L1zVKEx3
         K47Mwb8AhdYzsYEKSmY/DqJDeo3i4FASKPgyuyq2Uc6jUhg6A0tDOQnfLN+qVGWSjV3w
         JOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783711565; x=1784316365;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aHwFumUUjp1dZn3azv3jRxV2z4/4b2Y11BxxEMyANyA=;
        b=Ni6M0voGRyrhFJKRYhdthGEl7oYY5hfMIDjQj6INgtCHC7eQ9IsAYx/j5Ta12suGRy
         Ao3Cj8KjtWFrUYDtWYDzLUt+tTbHZ6sdREC+wixQnMewUinNlNcTUSBD9MnK/Q7R8XKW
         Y4vHKJFKCdfCFPsKZ0P3iG4cdLu0bglvthlopbWQYe06sYAlFWxpP5jOo5OQdTKjS5E2
         tKT72/WpvBiVz4qVkONXX1+t/Rgt47R4+T2uwMSnzGUXLCSdHA6wlbzmRRlfDlLlYcxb
         EK9aw/5yuxvjnksKg09YYAs/snRlNYTEqgktb3NlwTHLKmcRobc1lFwXYcli/k98OQ/M
         GPCA==
X-Forwarded-Encrypted: i=1; AHgh+RoJ8DC4sW1jI+WHOj3UVfJ/N3T6d/g0bDWro875G3hqXC92irmhMAg6iTPmR9tk5wXGoXnWIizaCw==@kvack.org
X-Gm-Message-State: AOJu0YwZhkG3N5AsNRmI/qVltGkhnqAGtY/XF7CiWXHTm+panm+eXqPm
	UApvZ5RosL91d7tq+rVC2mBkTIPEIE+9Zj5qAxjVEi8wCvfZBxBgl+8olANXJNOCxSs=
X-Gm-Gg: AfdE7cmw6toknpqyRlE1ioEBePY77gb7szpI2cHUd+2pWka5q58VWDr/N+A9MsP3qOl
	KkKCNJ9e/C7jOjZ+c7Mrn+ihICfUlVjiDT3QeVxVvCr50xPPFIgtEK7LPHDmBoN8m3TGSvdVT1a
	xGEoBYC6q+IzyGEoix7XwJVQchiHRESinoaGjY8Bu1+cCiLq6MTO26oOusla41hxUv3WEi7V2LQ
	obBGWey9JuPYY0DuG/juMzeQH4AlZfB9zBZk/CBqokR/A/8jsod5YZQWL7q+j5ktwf/8Dyyu2iq
	JevZdubbdf06OihO+2u5crSxMCOgTqPRlxaQNDRrP6+/Qdxrdvz+WPyjt/492/NQ/MesHPE+aa5
	8AUxEp6kN1yGrjAp6+TUB0THF8+xIw7ed3kKoHVQoj6Ps77A5DV136RQO29NsniVUH+EcCge3oH
	unGIdPrqKZX7L5r+Xkq9yjcll0tMGRd9VuMoPNrBrWp/bd84qN5P1DHhv1aH8UWUDm6dV1jj5Zm
	t59L2w=
X-Received: by 2002:a05:620a:2993:b0:915:8502:f7f6 with SMTP id af79cd13be357-92ef2b575e8mr66564685a.35.1783711565033;
        Fri, 10 Jul 2026 12:26:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d37540sm265182485a.38.2026.07.10.12.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:26:04 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:25:59 -0400
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
Message-ID: <alFHR3fg8K1-SITK@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d0f4e3fe11f6fd1312734e242d008267ad142c.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 042FA1A0009
X-Stat-Signature: ftdmgoyfoshn11si17czsf6qg6ui4rh4
X-HE-Tag: 1783711565-236975
X-HE-Meta: U2FsdGVkX1/0Fo97ncM3ADTUkJLKa9Sijjb4reMCgd19YoQrseIxvr2fLqD+ZYM3I7gSHEeH+CyIHBJOVPYjJPRuLwM0yvWg3oKWl8iprgC0MWFIKoZqxmog+2L1u1gsTuga0o5zYhjtEuwyvToDJDvdGQIRhilvgD8/eDGylB4bNSs/H+aARHMcBDUUpzkj3hzClmRkC4TubMKbzrDjqpxw5N8f/Xlp1Lc1R4o1DowO8Vj8ncCCtNh05rbUYZ/ICJKBYBM87MCMSNAiKKhwEFzt7efdGU3vEOYNSKaUo8tFxm/g3Zu7ahlinZUrPwPjtbYqJBU7QujWgjO4DUXpTtgUUTnulNA62TUunEqlAqdpHPhfwYATpKk7LHN19ZL+Hb1THMLo8S8fvgBD2k/YGc8V5cK8gNRqFb5Xu9z+wZoADuDx8V5tOmofBwDL/JaAGCU1dx3vRnSMnoBYq0sHWLAUIjdYNB9VhfKUPuLegdyBspHFYPzQJsyg0rx0okqoWt+aRMJl4Qo137+JQNqb7uohakRIqJvQyKdlWbY1CQ0pwye6SSx2BZr2qJrvqLRYwOc+DNFP991nIcUsd6dpZEfqBdbAI5sdfaVIHjmH6TFhjMxJX2g4E8NFkaHQfdwqPf7X3C9KagQzv3hwZjakaB6qUPSjIZxWj58eRR7RSh0ayK/ezHw9c1QWHcwQ535ftUKVd4fsGRNmhWryfZjyATeegtW6+BX14WqETieKnyrJi2fEbX0tv59ojqvh23ja74gdr94IFK34xe9ZC9WhshaM5FS3cvJIUwmtXVUMMhi545yNxQzxVpM0sptuhTRlpnhATSyT6RvbfDn5D8Fyk0cpB6vrkQPUZkFzk6NEb2nfxl1VwGFZ0gGulf/Fvc12lZQKWoQQ1IscdR2JeCb7YdsJWtVwu4TBhCuacAyyg5+n948LkwJRmyLyHViZL5VaimCjZ19y4Br58b5TpzC
 NRw+0WIa
 IDhwmqqz78RSi18VWbG5SaFsxDpuR5ZIKwtKDRavWRu3a1WGfTwAoEs3n7o0zKfkcr0wX/iVVemIJ2gIhoCObC8UPBFK/1hkvUub6sUBU3jRG2zAyLGIP745lwMH0cjhK6qI5mA57JrsGA8+PHI6MsI5x9LZG5DeHnrF9PXa6PqLMMXHOUPysWu1Tpqo9HhVjdVRmgQKPYdYaCnb6TReRtcQfJUltPSbNvs9NSeM3/DLdbKhhTuGodjf5YkVjuwz2fCcOY7PDDqpbKerLBHqnQRFK5KUOUqbpSt43ypbSGkZy5lJkGEgze/OwtUr6UiYmxdmu/a7DbekdZ0RCA34M8Ya4bmOr0Mo9/EgiXd0c2rAkrjbSixNDTOBeETSbVM5pt+3hBkui32IfKz3Te8SNxqjtqXDNCWE195V7rNHBxmVzCN9B0RcJ9aTq24nLpxSmkc8ALM97oGszNF9o2fWwlIoaXFxNjpBxUg38wReArdsHcds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:38PM +0100, Lorenzo Stoakes wrote:
> The only files which should be including vma.h are the implementation files
> for the core VMA logic - vma.c, vma_init.c, and vma_exec.c.
> 
> This is in order to allow for userland testing of core VMA logic. In this
> cases, vma_internal.h and vma.h are included, providing both the
> dependencies upon which the core VMA logic requires and its declarations.
> 
> Userland testable VMA logic is achieved by having separate vma_internal.h
> implementations for userland and kernel.
> 
> Callers other than the core VMA implementation should include internal.h
> instead. This header does not need to include vma_internal.h as it only
> contains the vma.h declarations, for which the includes already present
> suffice.
> 
> Update code to reflect this, update comments to reflect the fact there are
> 3 VMA implementation files and document things more clearly.
> 
> While we're here, slightly improve the language of the comment describing
> vma_exec.c.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

> +/*
> + * To allow for userland testing we place internal dependencies in
> + * vma_internal.h and external VMA API declarations in vma.h.
> + */
...
> +/*
> + * To allow for userland testing we place internal dependencies in
> + * vma_internal.h and external VMA API declarations in vma.h.
> + */
...
> +/*
> + * To allow for userland testing we place internal dependencies in
> + * vma_internal.h and external VMA API declarations in vma.h.
> + */

Do you actually need 3 copies of this comment or just one copy in
vma_internal.h?

