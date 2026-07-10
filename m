Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F4EC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FCBA6B0005; Fri, 10 Jul 2026 15:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4CF6B0088; Fri, 10 Jul 2026 15:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C38A6B008A; Fri, 10 Jul 2026 15:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF7B36B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:08:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27D331695EB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:08:40 +0000 (UTC)
X-FDA: 84973803600.06.3951B3A
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5FC57100006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:08:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qryUKfkv;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783710518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFtVuusRSG4YUFzvnh+nyLwKm1T7E76ZywXpwPdPfD8=;
	b=VWAopYvTmx1IcD0CCifJ3yy3Rs7dQSSKj39LHiolJ212TeKiw+LCDppT45LAdKgatWRlwh
	jdgkI2o+L4m4z+x1DKDy/NOrXE/SihMfagVZ6lv5j9nxLO30d+riF9iyc5leweU8pZWqnK
	vJWJVjnvreeXVL4tYaKKsnycSUJm7Fs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qryUKfkv;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783710518;
	b=2CbHmJvXy2DtyaJHtBBn/tg/rUnp4ZYYHEEnimqWxvUMR3qslK8fa4FKLp3Omw5hsvbBVv
	zKm6vbWRgFLS7guV/cJvfScou5Z529QZjKItiTTYkFHYgMjnm2474Aw/W+FwuAcpxV5bbk
	5E2ogqbFRUYiH3kQbF8/JdZL6dKw0M8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c21495722so6193321cf.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783710517; x=1784315317; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iFtVuusRSG4YUFzvnh+nyLwKm1T7E76ZywXpwPdPfD8=;
        b=qryUKfkvWEwoMuIo9arf5SEnqppQIfaQ9C4IGSIWqN4rX+zbtUBVpysm/0I+K/zg48
         kcyftDRwzocKFnxx7ICazbqvo0b12JHoHzXuCE0e4f7ExXqBKlji0ozu5t7nIv06g1fj
         UTU3N2G8E4YKkD5ObFABVtxJG8bHQBCeNZh/0RxqUwgDP4h2Tiw7O+USJ2t+w1uLXOb7
         C1bhd+/A7CCjKKx0zLAhybec/QU5goA4t4icEp4sm3CNucM9ejuhNIxgRP7PErMfUbMl
         bf1GX4WGPYZy+6RXIYKPPc+AIUM1NJolagdpbSPxC1GJwydQydOXpf0b1BTyr4BQmEig
         4FGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783710517; x=1784315317;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iFtVuusRSG4YUFzvnh+nyLwKm1T7E76ZywXpwPdPfD8=;
        b=FkKWidMPrLrdzqb4STUaIMzuxYjTh8OBV3JvbeyKY1R5xbMLO05xeAYuzaotcFS+9+
         lyMgJOQnsxnK3UkAvnxLZg55Qy7IgpB7AXqbz30vwhMTZ5Gm4zwwAHqLcBTAQ63I5LMc
         gS/Htd2VJm8r2fbLpgzTOwVu+c6DFm9Ysqmgo3k14po3+3V/zGHm/KA3d3+09a3OEcm7
         XbHPgv0s2bGJTRM0zs/NnR4CHFCSbyySWcetEFGiFlhDzJUpxhG0rMlTLZhPH9GQ5d76
         0izakLPKRpHnsrZobVPiUl44JVr6R+iTdZLwh1zluvb3rw/X1EcwGks9KGKkvB30vnFU
         PIzg==
X-Forwarded-Encrypted: i=1; AHgh+RoWjLRuNTlA6P9hVb3RgV3r4cHIbk4MQMbQWG7CJQs+adbeXk1L1FEG7qPvTyELYI3bU1YG/dPDXw==@kvack.org
X-Gm-Message-State: AOJu0YwoPqFNLbFozGPgr8arnOKzRq8H/COi+5deCB0Evq35p00OvuXX
	0WO3ZRMXKQrbJIbAoXNVRosAupIC3kcwW15G1R3YGWsrZ5z5Pqx6SCeZlG5H3am1Qpk=
X-Gm-Gg: AfdE7ck5dz6CJ8Hu7DsaSBWRGu1EG7qy/jc8A8SV6HEcVzcTBUVslJZx6L8253vTQnP
	kKaL7Z0YbNcV21lUheLTmpARgvU/EIsUF/6mQcP/hP6eqwkG3L2U5Bt0OSWAFcDXhMuBOuwCA5T
	dABQ6KjeBIuHaYu5gIUDmqR/oz/jbVAdeEGCN2mZG+Czi19sv1lqVjL9zAHdsdjJYmTY/fZzCaY
	wnvVtrJXuw6dbwqwZa+apBehG7Ch3zKpkUQ6RnfQkVOSRpYtNGxxGvIQJS7fXxwF7AOx040YTsU
	NLDFtazAxXhiTEI3VfTvAX4UnqvmpvKFKOJwWpTYiwp1GfjCHlDh6CWwIBGLvX4/gFZKLSgl1Uv
	dcjU/dECir1y9o785nBGG4Dtztkf5bng5QNy9telPTSXIaEmUD/BgzNC5709rUDFUPtdxkMEypK
	vqfFqgd+RCFt8BFvivN4Hxz/JVhg+OVa+LjQIfkY/uZG4y638XyVwfiOwVqSME52oefrCq
X-Received: by 2002:a05:622a:1818:b0:51c:b900:513d with SMTP id d75a77b69052e-51cbf280a8amr2226311cf.53.1783710517321;
        Fri, 10 Jul 2026 12:08:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1da1bsm47847566d6.30.2026.07.10.12.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:08:36 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:08:31 -0400
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
Subject: Re: [PATCH 22/30] mm/vma: move __install_special_mapping() to vma.c
Message-ID: <alFDLz9_oSSvHTuJ@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <b3254231831037ca3e9757e3e05c90072e04a6aa.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3254231831037ca3e9757e3e05c90072e04a6aa.1782735110.git.ljs@kernel.org>
X-Stat-Signature: ti8cougsqa5ahaf4ppa5g5d4h8n9edc6
X-Rspamd-Queue-Id: 5FC57100006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783710518-959099
X-HE-Meta: U2FsdGVkX19v+NdpFITKLXCUxhzv4aR2AKOw4EV8j55BkHGi/vqgZTfMAiS1oaw8wqhAB/RWdA4LiUxTODQwFtz788PR0GPUNxTCFnx5IWPVpCs8ZHXgjboaNH2iluEjjwavqRssST6Mdnl0sqb5FS9Y0rmwdIwq5lukcviHdPPccGQ1+q5JyPQ3oOU0IB2sQFNf+wvl84moE4aN4TnAbIersPMBS5IENqQkWbc09HEP/Hc84hPoPZdSIPL8X9Y0pt7P2//oi1cqKiV1OVn3OZT1CovIE+1HAJxkEsSBLO2XSkFlSoEtCGG0ECqwS2jmYKijJRVNvE/j9SOMDkIGJqYfwH6HyF+D2qYHVNWQdB4SXbeTtfl4sUCOEhwjv7xZtGNyfUIHxAGOBrSm9jroS9UxrLfU1ycmxrHNJ/7F+4AcDx/TrydA4l159yjY2IPPVJ1NyoymVZ49OUVkCeuxLtyuTV2+iAzDvixeQ8pSjsgg4t47MBi9pfMQZUkdOK6rdKiIFNXF1Lnc5a2svQHIIr6SZKeeZG/x3YldzRIJ1+GFVbwvJo50NulUyVp3v97rXltIjP+jkc9fNkkbHpFvHXbHfY1tGkSVCdBvq6ezU4wb6NZ8HP0mAgG0im0sLpp1bOwjt6E+XbXlDW1aKhGxAKflG8Os6L2pt00uLpIVPT0vUjl/to2onRJdnzFCNoXpvp62BDc42Ei+bVrhcxQm/1dWhTFyIsMnyehfFW5HNXWEHljySZ74aEau/+yAvG3ve2f1ohMznKTqhmXG2iy3Wq1x3jOKylxSgnm0zANbhH+Yjuqu/UlkF7okZFHUQXDtJanQcpvQFuEPtj4AH84Q+7ID/W/n/UmZzY6mrgrMh1RNp3RsuRyOwUKoxNy00v23luRdSOA6n9zd7b4OGA+ojvbxQXTtVeIpgyVuvF+VM5bzVO9nOX55Rn90IfdkEs8T5DPOj2SBV+HjfeNTj3D
 1dxpsZn5
 B8MVQzKRoUnHrkzy3sJyePovsHhbE2c29LU7e0tL90CmsLrL6YP6/GLX36VEtMpFsuvne6fiFScnuYPjWl7mNpcJmdSANJ+GqXLazCJs0q1Pk06QcHno1pZpkN2/WmggeN5rHfbOm9/5Yt6pMNplzO+z/MW3+LTj5fEYp1B0BQ7kOdUk5Nd8eGFNiuU8jH0GskykBuHvNF+MihPEHdMZUWv2SsD/uhATSZpPMpZKfnjuvEuupLo+Bk8j9q32GF6gVnjwdnmeePOyJnxxrc3QtNR+/OMKvhgsRxWzZaczhen5MwthPA5bDMiFr9CrAQePLxlpDjy2U3hHWMkQN85bBqsDvbkqLzCtXBqW2i9046F8GQlNA/PalXN2Ahq9ibwIQk6LsUWxVCdBC3mILDJdA1aNrfk4wYPe/aPswtd8WrRqnEYohInU3T18eG6T9EFZVAVASuuIHvv+eQjzbFs9q99ZH4qnBesIIkpfEj76k9oLmTTYpYKzUnCpbyQpqCDKMbguds8lN3LqffCVteSDfoIAb9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:33PM +0100, Lorenzo Stoakes wrote:
> This function is operating on VMAs and rightly belongs in vma.c, where it
> can be subject to VMA userland testing and allows us to isolate it from the
> rest of mm.
> 
> The _install_special_mapping() function will remain in mmap.c as a wrapper,
> since this is used by architecture-specific code.
> 
> Doing so allows us to isolate more functions in vma.c for the same reasons.
> 
> This forms part of work to allow for tracking MAP_PRIVATE file-backed
> mappings by their anonymous virtual page offset, as doing so allows us to
> isolate and keep code that interacts with this together.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

