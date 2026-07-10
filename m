Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8694CC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CC26B0093; Fri, 10 Jul 2026 11:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803F46B00AD; Fri, 10 Jul 2026 11:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CF36B00AE; Fri, 10 Jul 2026 11:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E82D6B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:14:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE89B4038C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:14:25 +0000 (UTC)
X-FDA: 84973213290.22.B74F336
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5AF9320005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:14:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jWp/YfV2";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783696464;
	b=23YiILvXW8/xs+wh+g8K7DuAGr+q9Z0HL0Jd+5Yla0fY2HHqlWWK1hfez6nX+BLJW870ek
	aDYSAVVoZL/D8tBxy50weaqfaWMbbuIqqQM2n9fe7S2aWyWrIBFGXn/yu5A/MTRNwJiUGX
	idBbz8ApGkWDmtHzcM4m5sHCsffirFg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jWp/YfV2";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783696464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X27acRwAdtTXFKPxbIFmrw/jC4hzH+Hp8I2QhCUZeG4=;
	b=5gH22F0IZuPAtMbB4hOb4vy7picifHeCEAAmrSR4m48mqspMQM7hyUPppGDhRkddujkpGv
	nvXB8X21J2YfgcsP5cLLSNhn0ZwG9H9byymXKSsCs3ufkULdz7N2IDoTjufSLoC4PQJRRx
	r7e0aK9zOYEBMeWjYWbXZJukqCveWnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C6E4600C3;
	Fri, 10 Jul 2026 15:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E901F000E9;
	Fri, 10 Jul 2026 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783696463;
	bh=X27acRwAdtTXFKPxbIFmrw/jC4hzH+Hp8I2QhCUZeG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jWp/YfV269fwuE/A0DGNv+QkUPkoVUKqSC58r/6dTFMtbAarFJcpkg7eJhEKhOYap
	 t81kzQLW6NrlPB0JMDr7H0UXeyHExQPBmSYxigZJrnSRSbLkruaye9f9wkhzjtq2xU
	 G4lKaQN//gFPfHyUlzpqN6PdzS6B5IpaPmAha+7G6eBCcjyEbo6mnkOdPR5gmcV1zp
	 SeT40ZJE+ZN7mwKT361/xbZwxgR0fnlC/lIRtIa+Nt3raxrbwrfQCAlTLH4fQ6A25x
	 ZE0HtZx8YJmgD3kt1TllDvu1WflSd0c7RpQgtW35wc26F3JTWTwOwmft6JhkOtvQZG
	 Bg78M+rxmr0Tg==
Date: Fri, 10 Jul 2026 16:14:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 28/30] mm/vma: use guard clauses in
 can_vma_merge_[before, after]()
Message-ID: <alEMKRdOLNiNYIGm@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
 <akZOPG6fxr98Ycl_@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZOPG6fxr98Ycl_@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5AF9320005
X-Stat-Signature: uw7zn6owr89esjidwq6f7umxfehkgh1g
X-HE-Tag: 1783696464-314926
X-HE-Meta: U2FsdGVkX18X7z/FhA5uirXpp2N8HmThIkVlESEom49URchwJ2/4VbS6ZvfWbwjNu7E0U8UsafHdApuNJ4L6NfeS+Bn6nCvRSSR++0Edb2tDBMfz37p6VA0IeHAdxQ9cn/EkVWDHBRA6wDxaqb11lX+x6C/9t4CVKq/ubDpK+LQTacVjWw6z9Eo1gzuPAIOadMCA5k8UNfVCZYgI3/i/041f4D/8A19U9s8CG5abXD9gSO8V0lYfGSF7yZxklVzodFvpFTssDmN1hwL1mLHF0oTiQrNOFYEe+Vm11GqS+5IPIvIi4roZWIhdL5lWzsRSjdHIBlfPTlkOy1+++t0zaDq99X2abLO6BkKgu5DZSUXWdpxnYLyV8pmIBjJ8Z6GBVKEkLITBRFgegU8p0sLKdeNHSicv5aZbgd8X/NenL2waLq/ezD9TGVZ8zmaltjq2n5A8wivWRIeze+6bt1rLIEpPH98gbGFXfMHoJ21/syZf+BK6VWZDFuzdZCiMDS0AHMcnX2Pwvv1zmtQfJ0KfLRkgwyZg3koLHSzZVhlbltd46ZjR8HMWe7Tt2fJKYAoWytWb4SuaPUqipit0QOjqsQmCBVfoUw4l/H1BtA2ODWpJZkXZkWnCzv/c9/ls4hlc0ttk1CrvhAuzdugRpVr9OMkExTLvWER3xYbgMTiWuPkzIOUzRFwmCxPxVMq5S5tqcgaczccrjHgW3s1EOhMm34Wh7W5Adi4VitaRa5j0CXCXlogwAlK4xOpHH4DNtnrw1BvPZXXXAo/JJ+ZQEwrlQD9Njso58TWKg+I2NqKH5sUYMsfwwZxRzCvsupEHo9aH8ME5vIm9243l8pm/EiiuGytYOOmPYhxzPLgMOr+lP0zvma/zYCWJmoz209iF+P7A+WLtlx+8QwLvZE0Kmkw9o+Pbmbfiajw886a+aPkFOPC51pkYUjIx8ig/s8XW5VdS1kSYfkdKY1Rjn5Jb1M7
 cp560wPl
 liC8AaPku7i115Xvs6YaZ44cbaJ7rlOF5JxDb2UOY4Bm4H+7waKdfL7e1SB1DdtjBXuftloHewLciE39TVfWc8UPgvDxEbjnfb1aLbkzpc/m8NVKBXZ12Ky3KDNUs6I75pDeyn+BmK6chgrdPAC5GlKQ52bNayQ9apZl1pgGNxj9sxv0d9pjoxOTvvH4bhTun+NBY3zdAXGNuI9Rx+u9M5DmLic3S9+PKO7DhS/Q4txOdKiXZCrVvvZucMR0M1/SKSiMg/lFc8dOe7wmDNvJFZzjbiyNc1puhhQTzhW/kkxHu5soEAF5I1eRgepQRz+ELLYACJdN/8OBv2qwk2DGumvzYlxrel2Rely1KrgO7Apl9JafRGoRrYhmub2qf+VviJ8dAG6csyO6HONgButyIZwl+fIbZ2IoOEVJnKvfwSDIvfOnvVsIAW0U7Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:41:51PM +0100, Pedro Falcato wrote:
> Looks nicer, thanks.

Thanks!

>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Also thanks! :)

>
> --
> Pedro

Cheers, Lorenzo

