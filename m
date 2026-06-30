Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468BEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EFB6B0102; Tue, 30 Jun 2026 11:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF7E6B010E; Tue, 30 Jun 2026 11:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9BF6B0110; Tue, 30 Jun 2026 11:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1AC36B0102
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:42:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFEF5168221
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:42:26 +0000 (UTC)
X-FDA: 84936995892.22.BBD7354
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7941120003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:42:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HYXGSs8W;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782834144;
	b=PeGk0Fc+SWbw8cDRqCnbyh1Dw8+e6PTq3vl7O8Epq+kh/NUueAFcK56mPC2om3lVJ6jmUM
	McAs0t0PtVg1Evq8CJ7U8krkDp3EBojjQDD+vpseDx61UMaqZH96QAmN6k1Y6FeNEeY0/Q
	f0HjQHTvRbeK/o3OdagcD4RYpphxzkE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782834144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QB3LlP562wM9vhAInyZtqjaYedctMNHlJgLHcqpXNiE=;
	b=e/WS4L05q++24E9u4Kj0XJCTWdvU6LBIdxMJMi++C4c4hoM2vHUqvG2Ee73/RSJXcOGGQk
	qn6h1j7JusGhv5KB60iaRmSoJ2rxGi/LwYsL3ybGeHwIzsWI3EHiLrGIVlNMGBQG4Whl1w
	ZkOIOsIHn85fAwxfLoVSuBgaTcqxHdA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HYXGSs8W;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e65e18969so87344585a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782834144; x=1783438944; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QB3LlP562wM9vhAInyZtqjaYedctMNHlJgLHcqpXNiE=;
        b=HYXGSs8WahopVFqfzTNWL4tmrj0fYhSkjzae2XDh+8kBwdkmDm1pHD1ECOshf8U/xd
         p1AMP3gz8vIsCLfYvZIzvnh8c4oW4MikvUgLpdQd/cnVeiqyzBga72NnPd6UFkMkjuwc
         +pEUrYdAvqbHrv8lkGL977+0fWBi/nPT8U/R0QXAZPn/eQolElqUL7abzx1eUYIa5LVI
         c81wWe86GV0f2eD2sh+SA2WzaKfAp6eJkvkuxwU7MMX2CNJHvy3e1GkgXK/EVs4rk9Ug
         hmBsAl7eN9Iu9CS18tOfVupoyeYRNVOKAaiCFsFzaVKyDnoGtLzJ5wLmPxGkgqSGAv7O
         NZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782834144; x=1783438944;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QB3LlP562wM9vhAInyZtqjaYedctMNHlJgLHcqpXNiE=;
        b=Hb/fWiJCjhbvWXO2NSX+o8XACIPIdEahAODmrU0v74i1qnhG/E6lbWFbSb3h3LMD7X
         I99mPMd/IgzY5du4kj6hc+Ri/VVNybrLF1+KIsZlz+2aXLzJyJVUP/nZVAyFwoh0T4E9
         ZZvN5DVG/TO2vYF1/15qb9ByHLWAx6bo6WyoZtw7JOM8tl5WZZtq+7rg+kSyX9zaIPW/
         eruOfIbZZWP3dGCnlJVHg5BwZ9RXeVEWHlaDPjLdLQ4YLPLDAp0IS2zyE01jpvsRKeo9
         VtgHxPKrXYb9kulVm8BkDeoXU12TMwmQQE/xEkvLevti88pPZVkOEteO70jRg9m/2n0E
         n5dA==
X-Forwarded-Encrypted: i=1; AFNElJ98cumZf30lDzW7AdGuxyXoi5r5UAGKMAhVNPoVhy9tAEfN+cFOk3VkAhqwWqMZ8Oe/KYhohpFL4g==@kvack.org
X-Gm-Message-State: AOJu0Yw85DCBsCAvO2ZAa3YJFJ90ZnsGdcl9XyfkiYGwekZsk4ubVk06
	CNgE9hDs2KL4viFiHLu+iX6iruGZlBFackzkZMKFAMNxxXkJQoj1xcw9JKctjlw4xCk=
X-Gm-Gg: AfdE7clyq44/tQNZky7ePnHpnmlENjuq/cXZjre50b5AFWFmcmqTX6jAv/itFoUS4nF
	RfPWa8fKjts/jgX9Xus+3Mt9acAtkJxNqz/MA5ZF21tjs9nFOCVq4rNhtE1ANFABlyLh/EkhP6v
	3iAoKd31OIU3OmFmpkt96r6ydRCrmnVS7OuhZZM1gB1JNGB/iEDQdrDsngNXUHU3VkNr5zRCYBd
	GsMH3rd0Z5Vb+RtSLzlZQnKiTARqsh3FtWVyLUj3z3EEZIis5yDS152M5F+zrkAiwJ7apCqbFyE
	b9HN989mXUFJHPHUsrJndTFDhEKdm9iMaFMrJWw3B9+jMONFRxGIDOo5Ugl41SamNDba2/zBn5c
	xwmEwZNUwmzcCRDneyXxmmsGtESkv0zeiQSZSMCxZ6SOfp+liwzUkLokp7xjvgeB6JSf8dloIo4
	QHL/VClt3b6Y6XaZyr6m2N2dtTXhsur1/ckXc3mvb+P/fPQmdxp/dHffwcA5aEagXcLJBD
X-Received: by 2002:a05:620a:271d:b0:91e:712d:f79d with SMTP id af79cd13be357-92e6984d3d1mr270456885a.40.1782834143842;
        Tue, 30 Jun 2026 08:42:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6234dc50sm263249085a.39.2026.06.30.08.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:42:23 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:42:18 -0400
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
Subject: Re: [PATCH 08/30] mm/rmap: rename vma_interval_tree_*() to
 mapping_interval_tree_*()
Message-ID: <akPj2snngOp5nOYq@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <f95462457025370efd047b9dfb039e76bbddf58b.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f95462457025370efd047b9dfb039e76bbddf58b.1782735110.git.ljs@kernel.org>
X-Stat-Signature: wzq1uck68zf1om1j3y1hqaikbgimrf51
X-Rspamd-Queue-Id: C7941120003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782834144-809571
X-HE-Meta: U2FsdGVkX1+vUAx7S/lqTw5Lzm5OV8KuVxldZRGlFgZT8oXmgPVGalEE2LuhrzerrXIJyu9PCkZgQUhwQN3f1gvXgj27lHx9cyAbFBcVsdJggEJP3NMoUBas8KliDwIdLsRnGrXm9HQRCXywqduPwco8j8fgAZsKdlm2YnEef2w1FptT3GUa1YSZcAf+zBVDut5yDvzuprpYP8iYfRJJ1Q0I+MsFSyZGXRI+4D3okmyvicRlVsEn6XzzqoL04urUmqOcX62att2IPfYU+4tpDvTMlNNpX8k/cL9uH8N+2BhnclJEFdu2hJL14PsQHWvzyjcbkh2Yt4r9mUHFf3DKFGs1oEaiJIKUOCA8YyJKEeIabaD3w7BV4D8EBI9Ka1VPKyx6AjN+dRgr/VbfRvPDQwCX/OWdveuXCV7qffy20hRVdzafRzCM4FTFOeixWucmXtuUIo/+3PQhs9xOf4EWyDEVFM+AcU4kuJHiobCqM5HrGkFKMl43EUa0+mgEh5lIMOih9ywxwv1K6lEYtjMdWfny5AzYQ3lr5/TTSGuUi/5zWLtitxzFH2sxNCzac6Ud4KttnHSgNBWQhnR3pdwVq9pVDJVyu1Q5bY/bWUQt7VXAiBdtBBMno4FoKLkxMQ9ljnr2hQTQCgdQYnJoQiAWEqVuQZkOpFAeYqsa2nUepqlUAU0NFa5sG15x6Ek1bWgw0KYxBK/ux1UodGy6sBNRI1TrZNwBBOSah6tsDaBhX2u7/OBkpH/hUgMq18SGKWwU5LR48XEPs+gs1w9R/m1BiOrfPs4vYBGP1Aql0Mrht1AjlhTUOiK6X1tFqER8ABKbvpFhZaC4RdlcMmttOoeMSqx+YAR6ideb1LnAQLuwKH8cm78buXlh6oFwh5RxTVnaHnkytDoy5ddRgdlIWejniL3e9LF2OKMiVkmjaUZYnixwiKZ5ssQI7XVWc43bmKyZYMOxNQdSfCn4+YCZ3dK
 6qwUQ4gc
 2IMK9Xlzo1DwrE5Zjpbt1/h8HpsYR31FFAUfWrb5h9TIZ6CasAUaet1VxQ7MnKGLyuvyiact8a+BpdIC/6bbU2YZW0svfbqwjFbpkIMCLZGL6soMK5p2KqpFiPN8gt7LxpCdJYNw5T/A/WYz4nyA7vcszSh6IEXJ618vZYZLF3d1VReUkqEfSQxrczUNbRWXPTwmOyPayf+vCiAPMDgdzReO0/dEYHSjaxiPI99CQdnqouzGq0Ug66TmvR0J8nyd8XurdAyOrCkZVnOcErL/wNUecp3TjpipUKxwvjAuxTU3ulp/k5ZO2WiuoGlzWPuNs07KUWplXbX0l5alKSudACUmqV0kPRpq9VK43XprY5pTdkF2kGp8z4OtahzBZu2coBmEfRt5O9TdGN8ViCrm5W02WvnwvciQx3EDo4/ZfLf482hZs26wrP9lLBEk0JnMFxBQ2cw8LT7kR+voWyQL1G94KHum942D6kCziCf9tfpk0ocovOaoM4a/3BzGpNZQkvEgc2IlOcY8Dtd9VpSXok08iHk8UWJqGRKd/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:19PM +0100, Lorenzo Stoakes wrote:
> The family of vma_interval_tree_() functions manipulate the
> address_space (which, of course, is generally referred to as 'mapping')
> reverse mapping, but are named the 'VMA' interval tree.
> 
> VMAs may be mapped by an anon_vma, an address_space, or both. Therefore
> calling the mapping interval tree a 'VMA' interval tree is rather
> confusing.
> 
> This is also inconsistent with the anon_vma_interval_tree_*() functions
> which explicitly reference the rmap object to which they pertain.
> 
> Rename the vma_interval_tree_*() functions to mapping_interval_tree_*() to
> correct this.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

obligatory "naming is hard", this patch helps, thank you.

Reviewed-by: Gregory Price <gourry@gourry.net>

