Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F66CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F8E6B008A; Mon, 29 Jun 2026 11:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1382B6B0096; Mon, 29 Jun 2026 11:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027026B0098; Mon, 29 Jun 2026 11:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC1396B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:31:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 521788BF98
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:31:20 +0000 (UTC)
X-FDA: 84933339120.21.A8D882C
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6BF77A0010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:31:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IEB1BRQG;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.161.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782747078;
	b=jULw4gPkRm6ONARlpCeFRs+6LrxcMDeuAHcnsPvidriUSR5iUSAspybrLyixip2t7O6eTD
	yhV9KLW8dlPaQ45UJYKOA2pX5Q+ob5S2HPX5/75B3Fg3cKq/wcprdH03IKH6RHYX2xYvKv
	N3WW9KvmCA9abhydoDMCuRzLD92FMZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782747078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TtnRVAeDbe2jCD/DHkmGFKsvQqrt7nLFRBhYCay7qN4=;
	b=5mS6lBu58FLfWMtxGuiifeLxenpekEPdjvMUTO9QUWIQ9S+gver/yBGQYHpPYJp0kRfegl
	4x2uUzlfMw0xwgtSR2w6a/UeA59Izs6PWxA9p3DoXf4aVi4C6h3lAfjg6V1mVvJETLVARq
	yyDq+1kS4/FuG3eS+8E9eAkewJ/XjnI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IEB1BRQG;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.161.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-69de16f5f79so1731155eaf.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782747077; x=1783351877; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TtnRVAeDbe2jCD/DHkmGFKsvQqrt7nLFRBhYCay7qN4=;
        b=IEB1BRQGaZZfeamvfJ9FpJRm724zX1LKqI5Uu9Yxw1sDjzgs1HbWgYTYyxLDMFrinE
         I0twsrJ2g/ey64j9E2QluzHDj+utXLlkNDZDlmtAs3MsOP8HcVDqHtt1aVLHAAmst2GX
         U5Qw1PkD5JvA9cxUWkUDKOmgYmbaWhZXqh47KE+Dl1msAjd4dyC6z3ksGyjR1scx0VtW
         whZFcwIs3WApE++6NsZ9UzeKe/Y9mwDYumg0yJQlqpOEMRfFo0L962OtgREsftg4T2p+
         I37yOd1+hnwRAZwvR8WnKrFx+wIY0l7sk8VmeQ4hr209ubM2I+fjEgUsWtwSxa1Kj53k
         mTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782747077; x=1783351877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtnRVAeDbe2jCD/DHkmGFKsvQqrt7nLFRBhYCay7qN4=;
        b=Ya1gRZyYh5ha1cB0jYeJyzaQKocwFMABdK+oz/pLdI7mIcaiD12aAmDwzjzFgzST+c
         PVeB9Q/gY5WcazQjmZRIB3q9rssXf76+b3th8rhR5olNbG5woIWnnySVh8t9Tv2wYMO5
         o2T3SlmLPwr4JWct0JvI2CA4CDsehcvV+ugkfYmRowK4sUyWcEUw0PT1pCwuxBcb4C+5
         05RgJzjUf6ZxeH1OYwhZ/RB78QVSxIirsCekYMDHQMVduO15mb5VX5Z7/gXLfDanroZa
         /7f8ZV/kaegB/sDVYFPl60fCTi8Oya1qxLsN3UIc8YjGuJWYW4FEuMN6yCoOj6J6jTcf
         N9EQ==
X-Forwarded-Encrypted: i=1; AFNElJ8OLj4siRsq77e45fh5/ej/A5Bt7xL4QtzGoGq0yP9RsWLnsUH3WyvuS/BXrJbgBrlFMH/OzwmU3g==@kvack.org
X-Gm-Message-State: AOJu0YwFNyM/ZjOOetmvjbWq07wWIJaPVLA+LYqO1Jf5Z7MiWfHnq+sc
	PGfrAcuS5pmz7bRFytlgRBdnLmw3gIdACBqfRkPBDH2xWj1yrGLkjo1h0kNdDxS+Oa0=
X-Gm-Gg: AfdE7ck2jBFmZiNEoh1W60RWlNdmoyYwayqgp2lsvCluuxZB8a+gfYSENW2aFhdd3EN
	HqMvDFgpv1IoeVWvHadyzZ8FoM/bcPrR14poZ+zKX5lauV1H3lbpfSDo3JU7JjSzbrPdOuCsqZm
	dRn7V7a2jupEJGV2AND4DiW/dBDMLj/tEkrpQbwRuVQ2LY/rfnTtfvSY/1YfDnf2kZ0hVYNdAhb
	mQ5mbATlMJmEsw58rt5309P3gHF5Qu2NZqNnWYcYZDEGZHvTNFPOFhZkDHykyNLaJoUxt3gdNdo
	da1uqymx2zgiq2/xtZV16GnI8CDGWkIeyEwSCUN5UyXuxVhunrZmTnqe9Xrku2rtvFhqL/m6Avq
	x8Ymqvx2eagPXuqbIFvGcy0EdIDZBnuOQ26C81siEpVxilm0bP1JFUTlinkfqSzfWEPGUoqFMiQ
	IdyfL4HQ6wD1nHYlFmCQhBtc/qbY6wIf4ay80n4z9whm9LYEVIfBK2mXuLZvDOyblfFcbyxnQlA
	92ywAw=
X-Received: by 2002:a4a:e914:0:b0:6a1:524b:1f5 with SMTP id 006d021491bc7-6a1891b6f09mr98038eaf.42.1782747077395;
        Mon, 29 Jun 2026 08:31:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6213b95esm9184285a.5.2026.06.29.08.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:31:16 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:31:11 -0400
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
Subject: Re: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Message-ID: <akKPvwYs-4TwYwKO@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
X-Stat-Signature: ad55jh49ne964m4xye14izc8hyct8teg
X-Rspamd-Queue-Id: 6BF77A0010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782747078-635789
X-HE-Meta: U2FsdGVkX1/7ltoDLe0RDDTUqbZ9d0Jold57VFgNASVv5ax10mdIXRlmpg9byVZnhQ25Xpo0EGIg12qxwTcKuz0EU1kMybtsLzt8e+dE9P27HzXVbOtJDCDf/M1i1EErSk+K5g3YNzCWrr6e7/MVmnODCA/Spnb5A+B0EobDufcxkGGpWx1nN32J0IrEWkST/ehSs8juK7uBwZC3LPyj67YnL828VIzasdNKnfXL+WEG2Ap8NfhUm0DOH4dTJ5nCsWIv3Fv7TM9naznqndEFoBvhXdkt7RrARRpV7O/LqnTEeaFyZ6o7i9NZ7nLOWR1EyvkOwuE0vWjhWbT/dXJDK6nrW/Wdsm1AxhveHbk7vh0x7D+p5Mf+4TCpmugB04kJ+gcfz2GNqs1hwPRNZZDvKNfqzX4cHONCoXQrPa/p9iHL1/EgOk7jzMF8QRbfr0IQmL8riQG3uiJBF+BL/QbTFx3/Nh+m1nHKdEyX+NSKtdLnqbFlJsK7MuTjuKEAc0LF+bNelVJ2EjCdjjJmo8dcO93MsiL4xfjohKFEKyeSH1jGX+oBXSLw4vu1OkThOFTV+beXEGiDEr+RUqdyjEoUVjsz37Z1Bm6/fxce/j+A/+RBw/An3wXkWvFvSZwM74lIfc3ULINzr52u61FB5wzs1FHt3UFb3jCVr61oa91fZTuL8vc7SedFOFedqjky1zv12jW/dbnsU5H2OtmjIhvKVdoY1+ibF+AF5xrPJDCwuRnMBcBBs0IoDNoRKe9pxDR+uGaZdA4erAiwoIWmfj3lGSAeh8lGnD7RaGSH80pOtuRBZ9EZ/QRBigkeZwAnlxSaiR9TeNBJKrCf8dnYbUQS0zeUDrK1b5d4vm48hCubKMbQFSf/w7cvEbp10uMioKjhRwAbhDsYD/cXiZd6/q5eGJkNTG16dXteOQaHNXou4Wm/scd9Brb/tPRMXD6bSWFAUphId5qIK0nt4gKVl+S
 TEnNbePY
 cguUEorxK5vNRIaQMEDsEqizT+bij/P7T5YNa+IqdBI9z+4qDfK+dMVzOFCIi3n+uF5v5r7qsrCxTPOL5iV96stwRhvOc3Oyii8WnH+au5k8KYjnM+iLQ2HtBdnZMGlNlTFCRPU/1SVSnhFHlEiDMU9u9wTSlYEyl3BH4WgEQh2KQvRnLS3WSZUxhqEAZX6NjRepvKALVUfJsCFkCCy1czuCRFspWYoKG9A35tVh7ivjNI6Vviku8qG97yb1LUjHS6ettr9BORzglE9auS5FB7mUwUTRhtr2vQS2VqwRFr+9J/429rutkfDAY69wtBtU/i7/M5wPAX0YvW+H/rafOr5/JiKtU6nI7HdcPGUcJDAo4yeRQ+y8O0CovLrfPZStqQ80uqITjPS6rX9kv5/WAfPUxDiygxI0EvyQKe4yZZu3aBWJnlYVAr8Rvo66J7AdTlBCrd+780MECOD1E8VDtM+s+8OxyPSXEvEdKT5ox6bkid/eQ5xP7aLV1/xFYybk8vhO36vPqwxAevSsawHQ2nRfNcpvuHLm2s47b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:13PM +0100, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
> 
> This is in order that we can differentiate this between functions that will
> be added in a subsequent patch which provide a different page offset.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


