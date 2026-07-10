Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EEADC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF7F6B0005; Fri, 10 Jul 2026 15:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFF86B0088; Fri, 10 Jul 2026 15:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17ADC6B008A; Fri, 10 Jul 2026 15:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4D536B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:02:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56EFD4055D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:02:06 +0000 (UTC)
X-FDA: 84973787052.01.D592B79
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7F9D11C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:02:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=V8hW79fe;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783710124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pC/3U7Ftz6dY/QSNTLtw6DNyhuKVUlnEMcNANT8zsUU=;
	b=0z5rlVXu0EJl+0VHesiq1nRzn1Bmf3gatLZ2Mdf/KRfI05CtjbNwrewgZVVQbE0oP83kCu
	IvYEItzxF+5VbwnepRm4eA+k0AN6a1ZEIdOgvL5HrAj9xpl7uRJ9N26Mp4+erhN6Uw2AGj
	elnCWR2QxjUb/QfgsoobeveXZ+CTxU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783710124;
	b=GMpd053SB9WTEHvjdvb8aOgwJRSx/bN8270/2AkH+Kx9QDO+Zw0ubH8w4/CA0xq4orqZXk
	bkgkLMxfRqgYllN068cfJZg4lE0xCvqBAddDDl3oBYVt0ROf4Gvw452IemQJx9CoaMqV+w
	fxVaLZx7MH+d+dTB/fsDvYhjtCvmywU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=V8hW79fe;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-738cdd667ceso370736137.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783710124; x=1784314924; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pC/3U7Ftz6dY/QSNTLtw6DNyhuKVUlnEMcNANT8zsUU=;
        b=V8hW79feIs6epjbnAgUVEoArbZp1llMyVdyd+SinTf9D+mCzaz85IjPy13X0JWCRWv
         qy96+UhRiSxWa88bR9/xLSgqb4C+VuLaTwgV3IbKLfYcgferpoRzQPybKGiipj2vtYBD
         41BdPeUA4cXP6bB0RCgOhyJixB7Orkno5lKuJgSgMVTctD9jiAHbK6YbTAoRNOyExoMO
         zPGplb/klPfqCEO22yxgK43ktL2qYu0ylYZp9e8DrOyp99d1iIlP+2P2/Ygu8rFzvyNN
         s2iLZYMyTYTYmjG52j7HZfeQXwMmuz129fpC8GWoUglaBKZi7DoBsa86Fng2XNRuzng7
         Dirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783710124; x=1784314924;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pC/3U7Ftz6dY/QSNTLtw6DNyhuKVUlnEMcNANT8zsUU=;
        b=GPn1wmjQVFAaiSEIkKk6TmabLrExuiy7uqTqJdRzLXUBdQXLmIMfiaTHQ6uvrz0jwz
         564/PXYr1EffkzYC/hFH+g/PhOcFFIsB0bSCw3Lp8nK0WDWl2uVSSYrI0C1fD+0+OOne
         gEeIh8ZCfK6FgnWBbZM12KX3VCbSLRegYLMxJ8MRxPaPopDU8K8hocpWoC9SbkNzGNeT
         3MQIiE74RIdklpG44ppyqlQKrmtnc78M0DWoIv/oIt69Q2VwBbH/aXNn5dn8ZmrDQc6c
         Hc0XsCHzj6x5tO2CjXmlek7/zuK2qiBBCIFhfhzYdg7XvX1RYUJ3PrSVfGCU1MFzzXga
         GrJg==
X-Forwarded-Encrypted: i=1; AHgh+Ro/lxaV0tgTlQBpqmXrCl4M4ueCWeYNxI5xephomhbytvkPNu74X7IG3ugn1sb4gYRPPp7k6eNowQ==@kvack.org
X-Gm-Message-State: AOJu0YzM4pEWNjQVTvvORokI8i4JxHFntLGHg2dfC5oyltcSv2NoPoYN
	VquiR2k1EvQGv5zC1mobyRXDTbCBZAjEz/p64TKUTic9KseBvHdLrQ6IZIUAFD1FdsI=
X-Gm-Gg: AfdE7ckff0gEX+8It8uKAs68Ob3zXj85ajhOiEDa19d2LShMyMtx1qBB367k2TBSQEp
	YSRqwB8lpMzdmNCvHoRKyUj9HGN5U54pMNWjMG4q/Pzc3yknVAElmploGE/T0oWBEeJ9o9fUvmC
	O1hIjnpTsSgdi2B26WrSP/heqzYaeofhaRcnMJTMhuuNLvRvhJfSc+bhHvgCcKXCdbjmjDQnzOi
	wQ35Kxrd2T6yaW5sOC5J/nTRYrIZoEo25kjwcQtAFp32S51nsj70rIDb1apeqwdcKgat8i9TSbM
	FNzO2Ub5I9wybRYeyX4k85cs+HwQksOKZJ2nqiDu+J3ppstF9P/Me6DQw86RRykxY4wnAaRy732
	/MO94GrVGeFWNG0LfKZyy6/2WStrPGZcKTPg/OtitfDAZRe948VIhhVJLt4DZoMrae8bN7+v0ix
	gzCiuXIfajaneMQHLpdsLECvCYPajtlKycENKbuF4GiXkIS/Wxy0wzvuORFhaCerLnHRRG
X-Received: by 2002:a05:6102:689c:b0:739:5f55:3c3c with SMTP id ada2fe7eead31-74533d66217mr325833137.13.1783710114831;
        Fri, 10 Jul 2026 12:01:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd56c4b91sm48074036d6.19.2026.07.10.12.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:01:54 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:01:49 -0400
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
Subject: Re: [PATCH 21/30] mm/vma: add and use vma_[add/sub]_pgoff()
Message-ID: <alFBnZ8RcRN1hlk5@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <794044881e454fd8ac13e59d5ff5fc86fca08b03.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F9D11C0002
X-Stat-Signature: 3wt1qnisju7ucfcamda8fp6ztm9qdwk3
X-HE-Tag: 1783710124-1993
X-HE-Meta: U2FsdGVkX1+XW3ztdAbUPrYNejQZnCnKDeVcvJMXsWMT5mYea3hX1MoXZyntvQ07w1QwOD8C1Uf3X7FwhZXl84+wg0Yew7BbZggrTRU4Ntx0kDekhh7oFkGS0tn32BOrTlnRS+pxUU7ThIfuV0RjKHLmZIf8qGnmj+cTDokVlT9zBdCRxwvHLrDKFPKf4GN1+fK/UYfJ9efyY7Vtw1QHHL1dfAjcNd88+GtitSRJDa8TewdiJoMD5LRL1q+TQg1GKPe4swcPNis32C/RGlyP5stru3Dla6nHv/xNkSRTPajaliV6C/OFsQ+rxZmAv1ZLsLAyvWB0uaD8xhowDUwsPMpqSmmQFIhBoyx2+jijMvNVpGrdYahyY8Idm1RAMoHYKB3p5ytvTJYR6dsOySiZzFrGf4K+Vktoz4F0RGr7roAMKZu6zuy2KD+raPTPDA2LgZ1k/9we+afPVYKBRlz0aaSp2eywce1OmrBq0yumvqLu5iH1m3tV9GlUXmxEUEUI4dlLZRXjUJOdwwk2NC9iF2sCz4UtJm+2nhNBnilRkQlV8m0er1MId46f72kQuRj2MzX/bmy93m821kX9P+JpH7Dt9pUUZbpx/Hfg4SkWpQ3K3JiCtpqgvijsL0NTvswuMEDiHT4aqv+y5MTBG9gPDB+rynBfgfmFD96Mztlh7ysYqSisEElvqe/biMeJ3Woqr/GkFUIC04KclT+a3EZOIUJJCuFgOw+3dkKv1wm2Ucv41SkM2Cyt3Sv4amhGw9wXhvqO5VmLlr8lCy5GSs4MFgzHmTQGMlgcWW+JHuj8PPdCfvCz37oG7yzyqYWLaS8u9x3MJTx5Pk9MxL/Bl0Iets34xFKrD1rMSfsEl3XtjTShHdkMUDNdNOCk2o5i35FLPv7OTnFf5RMga1P3wzLlp+yrvqxxdze46i3SxAZ87CmGEcDWurf0wCkJr5J3xeoqfemfQa53OekzqChPGNW
 Hus51mWc
 RhJ0H4f9LcV0AEyduWw4dvj4hrh30QJYVyBHReZG05B7F3GICy4BXMIegri3frQcW1KDhAg5y2So6oUfVMed/B8I58XJ+NUcZjdkNgcsgei/aO0eUqiRQTpmUJEGSxXduFTomgNT9gSe6qfYM2nzDYn03GAvLt+MLf9sCXw9PbdQbx15LuiGs8mcu3b/Pb6PAg0gaDVu7PGi1XLFQ3sJXxmUKcsHRiQ1heVJKvnn6/rtbIioCChAWKZ5ZWHcx7eQWemJEf8noD7yYY1IZJ7SQpqYAwhmbr3uuIfsjhI/0uUMApnTQiXik+gnMxAuMeruyF47GzEZvStEC7D6z86llf7j3IrBDdsmMuS7x7ZHxJ8Dg7nNCwk8eJH8exZxph3euIslC4kj3Z5ahTRFulYRg1RfbhfOs27RXYngR0+y1NGgnvBW4RQITiA/tzgyF8P++ng9SBHSpIRLnN8rawEkrBOtn6lBLSlPZD9JQ/XC+KuUe6132erICR3zsAM7X3TAGHWXP4atxrFtVEhNPHWM+WWsMAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:32PM +0100, Lorenzo Stoakes wrote:
> Add helpers for adding or subtracting to a VMA's page offset, exposed
> internally for VMA users within mm in mm/vma.h.
> 
> This is to lay the foundations for tracking anonymous page offset for
> MAP_PRIVATE file-backed mappings, where adding and subtracting from this
> value must be reflected in both the file and anonymous offsets.
> 
> These are used on VMA split and downward stack expansion.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


