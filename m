Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE83C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559D46B011C; Mon, 29 Jun 2026 13:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E50F6B011D; Mon, 29 Jun 2026 13:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386DE6B0121; Mon, 29 Jun 2026 13:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08E9B6B011C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:11:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 878EC1201EB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:11:28 +0000 (UTC)
X-FDA: 84933591456.26.0AEC07B
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id C163D140007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:11:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gZxoXAc1;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782753086;
	b=e4cx+P90W9WIunKwpxmhb3xYLV3ZHg+ser/YbdfdaoSr3RKFtOqkBpBNJMmlgtkTljXvQq
	UGo4UPJ0WFDH76IiJFzTNuN9JbeVOQeJZxeOiP6s8qVXTajrhkxNtfLDXyOaLrFJ6sqgKE
	R1J0tYaTBxx6AQ9T/UnsoRx/M7dKQLo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782753086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6+KY00whvPT5nv3+mPk4rrEbELgRer0MfbyQfoaO+U=;
	b=Ah0e8rIDKt00dKK/oPgm9nzLBcEczs6dMHg9j8ZOpffwx0RFcUPEOYVW16uGYdsiPjGvpK
	b2XHoeCoc+3pCfaKhRTJqgAz8S88eMoM7+bwRNhprbtR4Bf5DxL70pz356bpRkHLHCVyra
	HxAKXn0AaKAOYfnEBxPpcoV5WfAUb90=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gZxoXAc1;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c05dcdf49so9955001cf.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782753086; x=1783357886; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C6+KY00whvPT5nv3+mPk4rrEbELgRer0MfbyQfoaO+U=;
        b=gZxoXAc18iYZxtsCE1MJ8mLfFrpLWXGZWvZjpcQEvQRTvZAs9Y3DQrTrSMa5P+hGBc
         2gmnQoneId+Dk/LSxCcxoYmttMHYiMPCSc3G/fHtLgiqSKkwhoeuLNFJrkJFZzih7nLw
         2H1Rcc5JY64dQ082vJjGi6bj9q3mIvjfXzr91c+4NH90V1basWcLVuUeRabhwILzEdZ6
         SqP1dB5tRn/jAXhJh8lKjnYWFufbFgOiArTlX5tp3sOIbjn2Hr+fqqNqaDVP6UXEVvLb
         NP8lsC8E3PMgsOSd2k+3M2vherLaIf0e4jONwie74BrYmIS0H+dvpU3BMqchGHH6NHFc
         xtcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782753086; x=1783357886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6+KY00whvPT5nv3+mPk4rrEbELgRer0MfbyQfoaO+U=;
        b=T/q2FgxLK3fIC2jt7M3+pXzSWQcgt2fN+6JiCQW4s3RbVmVIUt4wHXy8FFIuEFtjPR
         GmjO97D1gAk7VG2dO3tKwjdTj4dthrO9zdCtPLzFRcBNr0F3vU0oXDwwSFm19BuVb7PX
         SVpajDEH3OssGozvRyP6jA17PnkTVUBUGdauMBvKUe6Hcwc6ShLvO4u6djswSEOxTRFI
         aOvirkotg5QTLhzqtg4GGVgQ5bc+GFuECxMEYIpVqg4eP50hLPsbJuGLEmHC1tJ/u6Gv
         06cYqauhNFpRqaeyqTKG0pwOUJpJEO3sxxxpn6UJaLX6tFtEBZc17FZlr8Oa0Yx5/gy8
         JGdQ==
X-Forwarded-Encrypted: i=1; AFNElJ+jgIQZdVaaRL7mPpS+ktSI2eYtDZCp91kIYelOax6lNy/5T4TiPwoVSKfpVodwHqpI4TOpJ0CVCg==@kvack.org
X-Gm-Message-State: AOJu0YzH1qKq5Sp5/dKyZxYIqKhsMsZ7rf2gq7AKq5TkXoZM5vjTiF0M
	dt+g11ZtAvgSFcEeOlHW4QLxokfp/B3Si8ibzxAROw5RslBwjjDUdC5Tq/KfGx1dd0s=
X-Gm-Gg: AfdE7cnXnlFApLyVUJTCfd4iADvRV6pVxJ2l1m9v4jvLGv+Twq+7a7GyMJPZgANVJyM
	GMSwP8CS7mwCOkAAUELR14XkKAm6jXdowJAGD/5GvkrRCsAJTMtngTEHxNWT9ZhHUOWppGSMEzc
	bNgEYtf8Yqn48yJP2zCzF/s5Y6VykQmtUwkwDRVE4vY+mi+eeG9Ri59RDWHTzxqdKV8jxjr9Mb/
	Gew+aitwd9DgYaTJnvsDgmifeiOu4uryCkB16WosaAV9EG1uQ122+RPy8B3PHaRShkJT4zWP4yt
	7qrdVkJ3yvBYrRrGW/qI/e58jSiADZtGeF3E3wqOKdxfRIYu0bJuZcKBIIQL9zJ09RsB/MN7mD2
	T1OxgpMO7ZfjiRGhVsor4XVMhVQz3rF30Dg8UVbZb8+De/yIwzUBEBLNthBIpUYpVVAdx42/ATA
	6WbOhkT+gCukrHkGl9c8cIPYC8j9jShRsbGwevJ4y1GF3UAPEW2EtOY6yjgMbfuSYPGK27yhg+u
	E9ZSWo=
X-Received: by 2002:a05:622a:420b:b0:517:58f6:29c3 with SMTP id d75a77b69052e-51c107f633bmr2561751cf.32.1782753085667;
        Mon, 29 Jun 2026 10:11:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c1080d4dcsm934601cf.5.2026.06.29.10.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 10:11:25 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:19 -0400
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
Subject: Re: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Message-ID: <akKnNy64lhNqPtLL@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
 <akKWvnU2Ua-8ceSb@gourry-fedora-PF4VCD3F>
 <akKfAl-wdIAbexNR@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKfAl-wdIAbexNR@lucifer>
X-Stat-Signature: rubmdskwazz4j3ipcb9gm4r7g5o477j6
X-Rspam-User: 
X-Rspamd-Queue-Id: C163D140007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782753086-177347
X-HE-Meta: U2FsdGVkX183OW7qlGRBzaX4lw6ewA2/gezMedQobE41CPeNnK1am+1K8gZYPahDhva+CZV+wKQqNGcaxtG8bVT5SxSdTw//M8+sH7jPWB01EjJPrBBJgRTUVJ/vsPvelpZ+o3OnPNdOvKEqydix2X+MZWVi52cl+oQ1EZzyNKg7CyOIpYLP2uWfX+tAIEe1eyks+TjcghCeN3YjOWII/OwSRMnQ/X+d48O0hAxOQvv/9oTsDoGhNBcj8uCt433G1M7uC4MG/SGPdNS1sMKxvfKrwxFM2ubo2b0eL9ONfqnMOsazBbmNQJu8ibv0NjMEsGk5ms/d0d1HyiAwHdtHByxgrb/Cr/BFHBRHxc/jOTc22pA9N4THMJ0tBHtUo2Jace71uWzvm0quVaWHQV08MobW010lOxAi3bw/i+QdG7JROOp2Aayyonq61K+M8xS7qpUoZipv5tZhw+iO54keSfbNyssndnMM1jBSPDjtMp9Kd2De8LNe/S2fBTPYPOiLyPzMXo/9mRV/CAj61DneT4fTxaWAfQ0qMdyHPqx9YLsfvh/241DptzEs6RXHaH/4OygZeB++NuTyTuHJqkeaNHHDbdWgsQNxzR+MwP2mZImP7EEzr4XPXWZsBjl7a2sw2aGBBeQ4vO6AcwbSGXqzTXlD9j9JiDNP1ptEjqfQMZOWzNmauHL75vO6K4c/pqmH26noshNr6LiKQFzojq7fZGl0WD2pMyB3qtpsm9MQ28w1hiKLMCKW8vd/maqE1ky5rIvBFuhikZK7UuvKh5rLCncpOjAyaCXNQ/4Ko6ibnf12oD+rxWv5Lq4+zRvh0zxIERDgW1D3aWAMJ+Z9Gh4ZfQrJcU2Jn4g8lvFvGBBnLBraEHddvCpGPjewjIF/pXQiqAUvje4hviLcr0Cno/0w8BVSZWIxobvBWoE06UI9YaeaiIqEhzB8wA/5THZRFnjDb1wOhDGTb4wogJpGbhW
 kPKtrNZU
 /t1B7JXnTqcWTZI8aRcm/jhSvqHOaCGXdbztJoF/MigLboHGKjUCNxgXTcBpErslYqUS/OGagGn8U5zWsjH3vN6oNykIwSI7Cz8ncN9a2w3wkVOfXe3ZFrZF0zlm93NIYaYwmRFJ4aichd7875fig6blOWJOxzSxDcuLaPkVSWurLSB22dKBSUrxoSuBWaQ6qQAeYLApW25N4rdEeAQvlNcDmrIJw6yfj1pgNK2h4CnLLEHxCCLPtrhZjp2jKgDUfkc4VFJSoARRWBPybS+oyfOo8zjQ7axIf24b0WqXZdD+y9hY3+0aqzphzsMt0ll/cEkLLL8uAOPlKtA89+pHHzU9i6ajtde2ZVJBkCNZf8PHBpFNwXz4NNNCsXFBTxbJbDg5TIhbSCXksei7JbqglStYtOw6B/KFi3IW05Sk1wxrbBk6uZdCIc/Sb+IXGfg/FX/tlbPoOQZt+kweTmm7Wx5jPrcn1rT1sEBzJ4rWfkFmDtIlPMWKwVSyeFV1ns5COZq2f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 05:41:16PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 29, 2026 at 12:01:02PM -0400, Gregory Price wrote:
> > On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> > > Update the file comment to clarify that both file-backed and anonymous
> > > interval trees are provided, referencing the relevant data types for
> > > clarity.
> > >
> >
> > Isn't this self-evident by nature of the function definitions?
> > (one takes a vm_area_struct, the other takes an anon_vma_chain)
> 
> Well you see you're already hitting up on issues there, they both take an
> rb_root_cached and the vma_*() ones do not instantly scream 'file-backed' do
> they? As VMAs are obviously used for buth anon and file-backed...
> 
> But later patches fix this stuff :)
> 
> And I feel it's hard visually to see where one set of definitions end and
> another begins, which was really the motive for this, as trivial as it is!
> 

Fair enough, I scanned the rest initially but trying to wrap my head
around everything as i go through one by one.  Generally this really
screams "fix the apis" not "comment the bad ones" - but i suppose that's
the whole point here.

It's definitely an improvement either way.

Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory

