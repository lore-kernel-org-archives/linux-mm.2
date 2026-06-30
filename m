Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F347C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB1E6B00B7; Tue, 30 Jun 2026 11:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BE46B00B9; Tue, 30 Jun 2026 11:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134E66B00BD; Tue, 30 Jun 2026 11:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDAC86B00B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:55:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F4E28F200
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:55:21 +0000 (UTC)
X-FDA: 84937028442.03.A13FC30
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5D1FE100007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:55:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UAumfn9d;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782834919;
	b=wreE0AZOJWH7HcqFHFg33FWX1eNgA97wP8SYn5No0iIFAtg+TWtganHjAGW//K+PFPd5ay
	Ia3BEQiIle4QSx+h00BBABr02PzEb9L8PJZlWPqA/sprQuZcuypCvx3jD1woxfK83EC9sZ
	sHlb1locAKtvhdYoZicno8MCUsA3gcA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782834919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHpENWZilS5aqo8aP9kraE35F/fs2tmonTK7cFttpS4=;
	b=Wa0bISnlcdypS/6oOXs5yzGU/oEakNS9++Fibt2+PJdIuP1MyxbHxfvAe1fE5cdKURSe4i
	sCwloRGJQbUPmrpDXAB0iiCL0Bcbzdptj+Nyc+6Cy3mtLLIjaHE8H9mB1YRdB4NUBVPr6P
	QG3/e5BHdFCLAHclMRXtfTw1VkrCCQ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UAumfn9d;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51af8fda431so35018131cf.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782834918; x=1783439718; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BHpENWZilS5aqo8aP9kraE35F/fs2tmonTK7cFttpS4=;
        b=UAumfn9d6g2x71+tONDjshrmjHy3KS8Bvxno8uad++9xyQJ1PGJCMDFoLeS0ajEpMv
         pIUU0XDrkiTHUEIC8eSj9qxgtkRXJllFgoY52OUSsuCu8RvMHoAjMM6eZCcBfipscfmz
         UI6dye585GUKC69Ebd8d5r4k6luChGUtmhrofkbeWThUAY8DivUVTngQVUUXQiCnbLOt
         77/C1HZE1SkeL8EAledVS5bh0vZ1+EjBjLyqo0K6lUZx/JJVq2D2KJuOXe+wxEKeBH4K
         TCClkdwiYHV0X+3jEmq1rOSsopHJkQMsNzgJySVKv6dvvkSBhnhAjmJrYsIRsre8UHR2
         xtsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782834918; x=1783439718;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHpENWZilS5aqo8aP9kraE35F/fs2tmonTK7cFttpS4=;
        b=pbsrxeQcUV8RAAOFtZxGxW/6AqWS50/3WMckPm40xvKKL4omS8m6F0r+pL2L0rRMqa
         2O5D2rp8n6tNCWrJVj+Ksw0tPSIF4GPh3NYekSPWBDCP0W/66w6J44RP5iKv09AjaaPJ
         W2F2+KLCRHeWnaUILnt4I0XOHVJY2al2ndPTBhNp2t64+GLDTI5Njjj1JkGdc3n0E0CF
         A11sFnkbmkw9rYysBxs/RY3F3a5Ru0B6OP+FN8/9zBLSNSCHGsd1vzqMgq5mGtGvxAk9
         +5cAlU9z2lZvwHGOpLiMcgpc2k9KW5NRhiJYjrpoi1kqLUmZkyB+D6y+Cj3ATOtwUCFI
         cClw==
X-Forwarded-Encrypted: i=1; AFNElJ9moqHHSLJ1lbD0FUGq7TE+S9f0F1SRBGbvZynILY1pFUVXkE4XNl4mVEcfP5nUUHcgIASPl7Ndww==@kvack.org
X-Gm-Message-State: AOJu0YxSt7/7LRFVrZcRvNoS2SktSY2Ml67dFaVuI63Jvpmxl8PZoegY
	ukHHim8Ox0yT/mow5XJ2by2Z48tRTUsJpB7XB6o1EeUaUGdA81z/LQnlCpW217FPnHY=
X-Gm-Gg: AfdE7ckiN7D+ZSMN6q5zdpx1/sNvYfv2WEDpHao5tVTSntAosZAdx6pQxeqy1kTtlU7
	SdROiFyGcIfsaFHs3NS7cR1G8K6tvUBm2CESMp6NEceetWU4qlkRJ0COsCiurV3PVs5SsQYaYAy
	UFTZYX8/eI1ylvrEAsa+KSCbXVNY812cvxHd3mSaWqYJZ2NPUzW6BzwthnhZIvIwKAljU4pFDKg
	wzNxkEBKUAnKAw9ELKDSJt3kifxfQhFpLDoa10bKYwYvIjorn6yTDP0vyb7THU+TVw6on5d2bI8
	BtpY/cZ/KVxXgKZEmwsBqjNyj05t/12+XGPd5SoyOkDEswRYyzuyERac/erBlNyYzdDMbZtNfpJ
	3qANBt1ahW6jUD1ANam4BKQBe1jn9sqhXAj0zYBFXCXR3TLWAdlUdzgmZfXjc49LkF1aald6Mis
	3Duy12H/+xGUsSkh+3qJU138bGkT7Zf5BHJWWkLBpvdfrfS24I6d1mQYQTKyMrCspitpTc
X-Received: by 2002:a05:622a:586:b0:51a:8c97:fb94 with SMTP id d75a77b69052e-51c10911601mr53620781cf.61.1782834918282;
        Tue, 30 Jun 2026 08:55:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c1080d149sm23102481cf.1.2026.06.30.08.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:55:17 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:55:12 -0400
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
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akPm4FlwTj0FsZU9@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
 <akPlUrNWzl1ZPw1S@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPlUrNWzl1ZPw1S@lucifer>
X-Rspam-User: 
X-Stat-Signature: y8okmdga41eurt5r1dz8mn38nd7j84tq
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D1FE100007
X-HE-Tag: 1782834919-707993
X-HE-Meta: U2FsdGVkX18G6/2qLCGKMg1wnBgm8+fmQeKN3LSEz9F7OKB0SrV3lTyz0lQh8UHFoTQEGoadi+LUwA6gi89PDrKPaHQNrlriQ4fmGeCZR3a/ozLutDUOOirmBtGdrCtyWAYS/ZKOwKWSoCmJrUR0tdvIufIx+ML9c4KWjNFYDG0cTDlMZl3UG0QbVAzjF0OZWYTZQwKuXaz1kprd7elXep2nCrS4iDXgCC9RRPJ4zf1SLemlNL99JWRBcePXmSxvPFUSwQBvffNYQ7dcj6QRehu4iz7UhEKKjHt27NBQ5KX01CgEZWt7bM1fI2GMo36m3k6YB4LcjfBYnvE32/VtD7LdYwtVLmIJpy+TdJIN1pYBqUIZB8kbWoauwsQAr80IXLwkjHxyCuX4tnC15955NvnU5wSiqT5fEG0hZndm+xyQeSXHaMql1Udr6TRfGYSvDw8fxlrJZqSkuedZDrKR5kaARzSDII9rDxNA93xNjAWEwGvDKmzjN+p2rjfO+ZH4vKadYbwzoMvoPsy/GPo/xkG9ecdmwpmRvtBIeDNiOsl82m7m7sc8sye12Rdnedq+JPud7qwc/fRFxjDnO4049U7c2N+b5AzgGytWH98u5QNcse2hgrsICOWbFtuNJ21jUAsqsqnuXpR22wMwOIIeharTv9VP8nAUv1yBmTl1+p10sBsxdHDv3izRMcSGSNPJrCTS7RUML1wvRKs0LsPp2xBXIrZM/ktISea2a1cihLmquq20/gtGaz4lI+odcvhFHbpR0x1EdFWo9CA6QX+6BFvbKBqgaMYDqu/9mYoYdkyjARdX9fbokY1YoJZ9u7/rKbk0mloW8pzbqE5KNucMFdPTwmxscKbjpBTmhf8FD5qfSaXL/LaNhpbCwZhHuX1SYs31JgtDQOj8fkfr+dee/C6FtprlXQwuWoCGzHYWyTIyP2CrSE/5lbH/FPllMAE0zgaARKWziuKmJspdc97
 DW0eqAsa
 F1XH5hKB1dyTblyOyU9cMINarlTbFh4JSC4rX57E4biU7ipdeVFTI2C+06EDLn4n0Kzg2OMkvn+I6NHVH4flVS16AX4Xj+J81IQq4AK7Jx3b/6FPyf0xOGK9ipUiG6dj4sOr+WBBMItfiCFTH7uvH+mKLRRifuhWB+uggVQ2aBKwbmRMXWNM2BOgywKXGfYRpA8Xh/b707qTL2WragzzvovbWCVguqEx4NUNw/3rn8zi8GbWf0vIG2/4QAmPlFOVXVh3B0EDneLaKn7+cuDpGEp/cDT8JBpSDRvsD08o7slyxikL5V9k9N6v79BS7s7z6tkVguXt0rWkTnh9mvIDuSi7hB74JZD/OhV+QDxSH4sYnOoBJ3/ibtL3Tw2eRZds14m0pWwqQPgt0zSKbUjCHPg3v5X5Du24E+OIlny+wTHjqcVLmBEezDeXlM2lyZlNF3sCLZ16d4GwC5Gk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 04:49:45PM +0100, Lorenzo Stoakes wrote:
> On Tue, Jun 30, 2026 at 11:46:46AM -0400, Gregory Price wrote:
> > On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > > Similar to what we did with mapping_interval_tree*(), let's declare
> > > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> > >
> > > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > > anon_vma and the functions can figure this out themselves.
> > >
> > > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > > to 'pgoff_last' to make clear what is being passed.
> > >
> >
> > would it be possible to split the pure rename changes out from the
> > changed function declarations?  It's hard to pick out this as something
> > that needs to be looked at as more than just a %s/x/y/
> 
> Hmmm do I have to? :P 

I mean, no :]

> I mean sure I can on a respin potentially, but it is a
> pretty trivial change? Just mechnically as above.
> 

And yeah certainly not worth a respin.  Just learning some of the
friction points of reviewing as I spend a little more time doing it
every day.

~Gregory

