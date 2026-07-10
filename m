Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78F7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E3C6B00A7; Fri, 10 Jul 2026 11:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4FAF6B00AB; Fri, 10 Jul 2026 11:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17006B00B0; Fri, 10 Jul 2026 11:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A348A6B00A7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:09:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F2501693CB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:09:11 +0000 (UTC)
X-FDA: 84973200102.28.A24CF1C
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D9E74000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:09:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SfubfBEo;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783696149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfeOD7p/qxHHEIV6dN3ojdA17bZ6I64Gd2Z+QpoWxkg=;
	b=DMfez7PzHbIWJ4LHyKOQ5qWYwO4tZ5XLuWnWvLySAmdjDh+RgaECtV8RU3uvOH9XRzRFIt
	4SLEjNZr7kz1FQQ9XwOSgTPOCYvVZ94dz8SHxb6vSnq2yKxM5VE/q6ohzW48e62QNI5yeO
	KVeyhLxaTTFk9BHI8VvQiubI+aezNwc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SfubfBEo;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783696149;
	b=WKZC3RyhToZrv4z5OpbdmIau8tVdLNqauYTJl3OhLcgJ2t399cmNdKgaiNzgFOpGk6Zqlo
	0SP6BO5vLfwUtqimwrtR74eBrZ/VHBu/notL82tsgwm0z31bXDW6uD/yGLxBPfSCQNC8H2
	UzquhAo1wuOe5k+FK1gYTmwIYOYK2KM=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92eafc94c9cso52077485a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783696148; x=1784300948; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kfeOD7p/qxHHEIV6dN3ojdA17bZ6I64Gd2Z+QpoWxkg=;
        b=SfubfBEonIPhYQTkYWufsyetIkRu5eII2dAoF+dcLIQvW1tOaca+QcT1BOHfg8Iyyv
         B9JrpRICcwCxPwUxr1O534cisYESaLeL4gRvWjNDnUa7Mtrtwkevbc+IK7/d89jnAt4k
         bGnRbFvK5DuOhHVWfIqNHFeY4Fmu15nC8/BizhWB3UPfTpXmDH22zqBhWfRQ2WK7xsNN
         y2I8IqJu/BEifzOPEJlAeRTFbWRXE9ekDaRFvkb5k8snU/EDghLbml5MAW2llQr9v5cq
         GaFmAuft/39ZplvbS7QiwWZjZ16wBW1ur9dfNblCqbo4OURau6zaxFpGoVyLOXmm0fVV
         bZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783696148; x=1784300948;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kfeOD7p/qxHHEIV6dN3ojdA17bZ6I64Gd2Z+QpoWxkg=;
        b=qpmXt8mffTAFqX8FIIMfYgoGy+q9aAiJJHZE68KH0KFJWaS99EVsMo0QpOBP319apI
         VFvegc3ZprCO8Isz9vmPpHL3U2MufSoq75YpFhHBAfd13tZIHSrU4kSciny0uzTzGnUz
         T9W/M236c6i3bVqZcMOl8cnqd+LcrkXC83ZwFf2zFZmsSX+Y3+yHaOavd7t5QwxiHHA+
         L276PwyBp0lBjJ/VV+zdmE0zMv2ybHgs3JrOHhOWiCHNe5PIlkMve7TpZEpibqlZUr/e
         9WhJUovHj5qQgHdXzsXSCFhYA3JYbQsorXgZXxrMJ/Y8Lu0k4SeOBBbELq3/xCJdJhX1
         jRtA==
X-Forwarded-Encrypted: i=1; AHgh+RpDp9xK4nCY3/uiO9Wp8yGWA+Z6g+JdSkM31m5QS3YKggKQR6aiK3g233xzc5fgi/BupjqlnlcQZw==@kvack.org
X-Gm-Message-State: AOJu0YzGh+T6RAFBxqvKeq0WiDgWPlq9G0CyLOH6ivocmkIvjzcNjJxI
	yVW8IvnXwNlhu4nP4ZfEsyDmQY4LPi/d3CZUzSiVSO1bNbKnKJQQR5+hWascCtC1AcM=
X-Gm-Gg: AfdE7ckrHJBlLr8/64gvNHIpN2kc2QAP/7EB4SnNPiWUcg09aD5thVMhlEjyvPLFtU0
	nS+Z0HhOdi1ro4mw5WYKcNRSNfAa9XoSGv/xbCGZm/lln0kAPJ8Y25+VS1fsD9H1aRYjlV1xfRW
	xqRe+/pkAtHAXdWPOWavxONsJF/xY7M8NQy/DgmxDUMMgnSV2Vk6VgsgwcfKiKZIArWJ3DzEVFA
	Q8XdOEfW2iPvz3BtKJs6yN0AKa1JRl/hNLvk4PcKwLe5YIo14Fkgj1iCPshiz2RxmpbO3rQaZWj
	AAAYphv1FaGsgClGqduqCxuYmCqhUshoCwVWz7nTbVcVZLDITvI65J3/wS0f6B7EcQyI4TNDmvv
	YLbH8hwcVuXt2ZzTjpPg0GZF8AMCAp+dVXS7xrxs774OIFRh3DiCVvVk34PTC4n9XGunw7yufYp
	cMpwpPqvi5HsBP+oXyJ34S9RQuCVp7c/AuO/gcHM2ovXC76Nk/t4Pf1SAgPHPaQjWYTQG+
X-Received: by 2002:a05:620a:4414:b0:92e:7d53:8e8d with SMTP id af79cd13be357-92ecf55964cmr1359477885a.27.1783696148308;
        Fri, 10 Jul 2026 08:09:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d34f76sm213283985a.35.2026.07.10.08.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 08:09:07 -0700 (PDT)
Date: Fri, 10 Jul 2026 11:09:02 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	damon@lists.linux.dev, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 17/30] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
Message-ID: <alELDgm258nhjk3b@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
 <akZCg73F-oGzDp1a@pedro-suse.lan>
 <akZGqclqQ6gS12Vv@lucifer>
 <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
 <alEHy1raICek7imv@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alEHy1raICek7imv@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6D9E74000B
X-Stat-Signature: r11wj53raaydc5rekdj4ga53ioed4sqd
X-HE-Tag: 1783696149-760963
X-HE-Meta: U2FsdGVkX1+bw0tVtILIi3Nkdk5mjxwvrKn7KLwvPGdCwAFkLVcfVCNwlBWGT20a5ukgp5QF5lgLSFpJYffLwCgX2sRBuSbP2CDQOHzQ7ssy95nmN3wfXpNIKjAT6Fak4Okhq92wya0abLJx5sspanWTtX2iBzalszVYD6ipyCm5s8OTFaLFr7KMDj3k0wmhRPXhrm2t8tdlTjM/xkz51v7VMm/dCWagNWlgjD2Cqq9jig77b9FBBReYDnmLDfBbgmfqZFiv5lWc6ng+kDM++pHWlTXBc80HXF+CQao2cpK3cLx7LlMhhlFdE/VpyKVlkZ0ZEAx57WrDKaKrloWE7dHTx8EvRjOQFACdUYLEHR2OSFuu/RYIvnz9RRANGjrHgCWrhANZtqj/yxQMbDoaD+WJLp041teNDpf+48RnDn4aphMOlD3wTZDH8/WH4ZqqaaqcXQGCMzitZp5DWkwJ4JP761pNE+cm9ntioQUqDKflwHhWfHL3oH5sHrxmAd9tQjQLoXhJbrKjMG+SHs3KeefGdhrB/NInyt0APOymQ8pkEVYNx2XEn0FRt/VxNgVL1fe5MdhnZgYXoe4Ow2RqIi/0K7ezjE222rxGmIfxSwjL1SBR85rpQRZUz7EDs3Bps1/uq2s2D3yDb9YfIaYX/9kPJIw4PobMBoy7FgYfWk3dV6UAQhA2qgQPqlbNLSoHaq3X6PGhm18GTaHqpFfrdfDT4eybabDbMX0+xc5nCuFG7JIRxdG6sKiQ5oGeE2Cmm0mVsWohnzIeS7EAbY3MalxVD3I4kTOIQsypTGKP+gFBGKhz0c3ozfNo1PQ14ZeG9Itcn8nOZfPR4UjNeZUfCmnUtVsGwaztGiSUhlm0sKH/cMRYvyoq6mSAoCcmQq/fccqxFBATVmHQOmQL9VuepdvCuizO3+PvvsHZ2lKYSniTsbcFBpmvawZEynX2RtU4m8yUlO1UgGLQ0f2hIzv
 i/7L8uOM
 5YEqxM+z9RcOpJppewQ/AS40LC7XSdG7gAIXJIwgbtDMFc2kgbipFcOEB2VTr/XYxdsLI8adsYSIX9YcWsb479ViFK2bzPx4aEZmkJDI3ponRUMcNLNq6E4TDEWYxneRKe48UL2FmlMjiD9mK+XzcGZuwNIIcj0eCZjt0acSCb0b7DLGMyi/6OTihhsu0mQUjLWX1T2l/mVGU8cJcgEhTPVET9TaD7gu+UbWu3WiN+2Tw6f5Tq6JFu4kAgU15xLgqO8eokTX7atIRstH5KM2xDCpziP5+tmUk+aYHE4xIOmdsatM9NZLnfxJE2B2XRZ/1OMCcEq7PujWEIfHJpsbH6yDvq/9pTTpZTnIrpf35IViAih6ghoaHrCTmaVNaNOY2uNPp5YOSlRSKQSnF/Z4wgOtHiJMy3iCqlksrkGUK/FVfdnd4u8gyryfttKOtrxoms+Ae9UqF4VFMYVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:56:33PM +0100, Lorenzo Stoakes wrote:
> On Thu, Jul 09, 2026 at 11:49:18AM -0400, Gregory Price wrote:
> >
> > Silly question:
> 
> There's no such thing :)
>

All my questions are silly.  That's my secret :]

> >
> >    What's the purpose of retaining tags in a non-address value?
> 
> Well if you want to reconstitute an address from it later then that'd be the
> intent, but I'm being hand wavey here for sure.
> 
> Main thing is to retain stuff under the page mask
> 

Right, which ... 

vvvvvv
> > That sounds like there's fragility just waiting to be broken.

If that's an actual issue, then our relationship with tags is painful :[

~Gregory

