Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 647D6C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296246B0088; Thu,  9 Jul 2026 11:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E126B008A; Thu,  9 Jul 2026 11:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1353E6B0092; Thu,  9 Jul 2026 11:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D338D6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:20:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52F5C1201FE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:20:54 +0000 (UTC)
X-FDA: 84969600828.27.C0FBC28
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 81B1140004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:20:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PffVcNWa;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783610452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aG5hxu0JYH7EcM/cq6JX5Yef1RoVI9XARU/q8dKmL4=;
	b=sH9cXNfen6XyEXjrbc+DGT7UtbojXtOedS19pFCDMht7dDZBPqUjOFJQla/YrM5mqjgqUd
	LFiI0wOQpIHdAz4KjwFBXxRkrKkIP3NqZHKaA4gi904ZD2tHWOFaqRtNhBhYCPWY+EsUS6
	AlF53Lk1aA/bChwVqCk7loHiZoZzi8I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783610452;
	b=Xy+MTfRqakbVDNwnIJXGLTTa0qq8JKoUBW0gVzs2hSKx4Qr2dz9uoRtxTG9WLjdkqQGnBl
	ndV/vNzRvBPGVFbm82ySMMIXAJOWiEEYvnV2juNdQD9RzWkstO0xCyF2T5Uc3Snk7mZmU+
	mDG4KcSrQz257+N2uEAUA/QWx0r9ks4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PffVcNWa;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e65e18969so79761785a.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783610452; x=1784215252; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3aG5hxu0JYH7EcM/cq6JX5Yef1RoVI9XARU/q8dKmL4=;
        b=PffVcNWaWVhEKU3tOcy8cMg3QKznJ3eFB0R9F4ACjjAhJ3tQVhMbWfn9OFmTOZp5UR
         /3eqNqACBHzYvhg8o8aSH07vaWEJZRAhZDe1CY/Foe0zrQR32EdeSh8mxdfgEvqAJ4v4
         xQhiclravicdB2uFitClJ47/8am++ySD8ertHQRw0aUAZj1v4S0AAbqMU7b7/ECFaE9F
         gmfvkkeGqvG08pL1QgIwfEdi3OvZ1sRX9zA+1qXfX67SUBsNLkM5TMraX0QBfo1W7X2T
         5RWwlAj+fQ6EDWDTwHHiySAKsLUivzYcIMZl7nox3GDJdNv0nRpH59QWjHC4BcpdzNqp
         9jCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783610452; x=1784215252;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3aG5hxu0JYH7EcM/cq6JX5Yef1RoVI9XARU/q8dKmL4=;
        b=VYp3LpYFafXftjZh+rGFWioOfaGlOIVsUyhRb5aA7/U/x6Xd5Qq91Fh/qNMWwz8Thm
         BHDQIwBjWR5tfKZuoSWj3tzSWudYbFWDSPnsVd7Dl2GM8miXhdLO+CKb7BXJAf48ouZT
         gVgazemz+NXf3yqkdbBbhdP3XjLFxAMyF9smZBKVIQ7Ku/6U49/QHhlHrCIHH0ll7Yjm
         Q+kFjSlvWiiXqkeEJWGptQMcyYoHKbnVoEQGas/SrZHhnhAX0qyXHKea8OCSgCxHLJBZ
         GRYeonCkuN5tYfUS4aEdH7g4D1uipbdNUYdr+Bs+11lA6ZR4i/1Swp9GUwCM1lOCQhyP
         TmwA==
X-Forwarded-Encrypted: i=1; AHgh+RoJFxA1PxAAoMByLJsF56us0t5wDoE026rBE1hMoz9mceqqaBWcFGLreojmtTmhW4E9P/LD0eM0gg==@kvack.org
X-Gm-Message-State: AOJu0Yx4Ws01w/p8pbACCjZq6fqlJqf8Zol/5e0AUBnzfLhC3T4UwXnK
	VnNbbHpCrmEhZ/nE2aGPsAdYUZPsTZNyPZW2QDkNj1TsiATooFLkr5PANQUTZz04TEM=
X-Gm-Gg: AfdE7ckyQPoWvJe1zD3spyVr3tbjAy1zcCKY3lMegC1N3a3byXHmzM9BZiiGZGS95Cu
	kAFFB8z/iLB7WKJ4BrGxm6q5dpRc6xls4+HEcTIZPU6VRDvMjQgKrNU8zTMETzhD4rrSuiFhSMM
	2a2TPjwe0FVsgfGVVpV8nqRyQAu59E9+hmrhdm94FWbWfAMXNsOXp6OXmp+Ekh1aiUPU1Ayajrb
	vNX/BoTR0kN1Fp517s0/T3XF/+H2IJj7oE4XYRjFAzr0XZIAzFNIA+C9FA27Q2D4Y99JgfalbTj
	JQr4R8v1jJ683KvKRb6eU4/ub/TTFKZFg+/h6khQuMvyekKNANGDw7njhYrD1jP+yF44EtA9U4m
	RuOVQDCiBlSFGxijw4BuNnuUahckBPRlzmIDa05pRhfDwN4BxoRatRldsohI/Y9xR0aJPlKQ7e4
	EiFfRvodD5gCFFut6HvNrRUuctTPpKwBELchZJ81VrK2KFDdL/Zj9oiZnDIvUn19lf49jw
X-Received: by 2002:a05:620a:179e:b0:92a:f74f:904 with SMTP id af79cd13be357-92edab23ef2mr337298385a.1.1783610451142;
        Thu, 09 Jul 2026 08:20:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90ca90a5sm1652288685a.32.2026.07.09.08.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:20:49 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:20:44 -0400
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
Subject: Re: [PATCH 14/30] mm/vma: minor cleanup of expand_[upwards,
 downwards]()
Message-ID: <ak-8TKDC1GBOeMOM@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <b24f70b72f0a9e2a37b904e5b59d80b88bd42e4a.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b24f70b72f0a9e2a37b904e5b59d80b88bd42e4a.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81B1140004
X-Stat-Signature: n4ae1m6ioshr7nzk3ctom6s8nfwbkrsq
X-HE-Tag: 1783610452-595508
X-HE-Meta: U2FsdGVkX192QJX1mwGIVVZsWdYhdiVPEp4EK/otZ7Hck49K05l86my3L8lJhYO0uTSGi0KwBXrOSUwyMJWEq0/g15gcFzuxoG8XzEAsPyRS0QRx/NC7a+hNHVJWUlEdNExJGJXMq3aymd8t/pmxvWjOX2pLRlMGM+afcKOOHmaNr9uNnNbI45hGvxU27ezP5DozoOSCyNglMa0zoCUok8LZ89XCHYT2LBG0DjZBLcDlNwybGyAlCWf4o5UGW3rJHJibJchb/3/7A8ZDM5uIxRYJgFwWV5DGShVncrKPfrLw3ULtSLkNu5+edSdQcNUrJl0etCDniibvZZzHIHaEgieaAyNWP2iHyqIMHib9VzkfkCLMaYIjzC3hk0CnQXQ/0SRU8aCJQYIdjmUqH/EmwGe0V1bPdnTjU2VSASvbR+5PU4o+/Vh9h+KlP+S8lKYYCI13LS1MZGbU+wVZdANMGzuDMOeq42TWrzdArvjkVMf0y7j93zblqEWG+R4KYd8NyiwuvAoK/lf1i76M9qSrXHElC1rST8jceDnAQUHzUqAjDTizot6ce+7VLBy0H/0Hl4a87sVC5TiHFEU0UFnsMyukKzY15bWP/1J05EWfMpTULPj7xHWsFxfE8iQFMUQiG+j5OdYIecUxUuCM6h6O1k3d3v6xsqd408DeH7tZp/fRGN6cANkpuxpPTw0hW0mdyIjL/G41PoGvU/XUPLdniBBAu0rrzO0c7KRGa+NgdkiuO4dD4kxTGYS/524B5NwVK7T5+PS/xgPa7JCuylNmARenfc8FohF0fDUES4MDqIVSTJOcO8TpRQCO39qoc4jaJFDItz3jT/E/oMMDy/G9z9A0bIUTHl+d/UnZS6hmd6pJk21LwT8i89EthuIlKipaFDlqwqyxXpNTaKa6AtqtgfIIUcFHFwcP3KcllPW3fLPAl/qwlodWDzKlMlZ64mebOUIqHbfcFxZTZ16PpR8
 RLMeeomI
 d36Dxb1WzE+I0J0+jslCEKpRvGOGji6HvlVJBOrKTEkcy7TV1RT9WCP74UEuo1WezkZFr7g7cuiYkAhKKxqZGYwQMgyY94mRAUxpwKqedeydFbT4gzy2ljsZL+ZCo/fsFOy8PSldJdeF19bDBl9oiSswtrW3Xd70uWNg3dr1jNEVIWwSRfuYw2Gdpgmih5QRQN1QK3HiT32qTcG5+5m3QpPUPzmxR8p4Pra9mglIA5hzWScP0yS4BuDuAZEAPrt4N7cG2euJDL6Rymz2GM49lLsqXarLJnZX2xN4V60AuX7Kyl2vpJRtzv8vIuFnecqQ+Ggezl2Qibdv3jbU9+Qm/kjiR71Dx1GEcXZHGb4HLv6Xn0mK1LO2is5o5hZRmLrRSO2+w6xWmELChVN8gsQRgFsiO9zmCjsweSPcIQogqH3vLBtdFaJiXcCktdih3bHP/IXKMj5UU2kyibxatg20reKhX7cp0UqfkuupgR8Mi32RY7IIGWCo6lcvlAUVSFpAwDHcNCf9WWDI1HgWlazd6Gcn7CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:25PM +0100, Lorenzo Stoakes wrote:
> Adjust the stack expansion functions expand_upwards() and
> expand_downwards() such that they are expressed in terms of named constant
> values, and make use of vma_start_pgoff().
> 
> This clearly documents that we are referencing the page offset of the start
> of the VMA.
> 
> Additionally this cleans up the overflow check in expand_upwards().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


