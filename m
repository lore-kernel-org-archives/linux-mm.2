Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1CF7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC8C6B00CF; Tue, 30 Jun 2026 12:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D1D6B00D0; Tue, 30 Jun 2026 12:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1ED36B00D1; Tue, 30 Jun 2026 12:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF466B00CF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:28:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C6711C70CB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:28:30 +0000 (UTC)
X-FDA: 84937111980.30.317F8A7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3A28B40011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:28:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YqSSo22m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OjboBIWY;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZgFV4lBo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rKa8cQVC;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836908;
	b=7rhAKMNfdtDl1HLeKT7CWRyeJ8w1hPrNdcKuwvYx1LHP0U4143zd7P0UQfeWW4qB3Ufg1M
	/ZkSE9+9J98T9tkMEDjeSD22tuT5Bm8ZqbBoEQeLNTtxRxLjh/t2pOe1552a+4Ho4UE4+f
	3SQ50EgVPh2LS9MKISzF/BFra9L/+zI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpGfQAlLw3qzT5ysYw+w7SeZRvoxB0S7yzln6WQZvac=;
	b=HRyHpIdovJ0P3+miHPBALOlaqhu1v//7zx183qB0c4+QbaXsjpARB4mzssdf/9Z6TGhM5+
	WO5Xkq+bFKT8N4cYesWF9h8bVnCo/qKbO6VFtNcsXrJqkwaBv360K9BOBZYMudViRV1RW6
	rjbmBDXJyDhQVemjKg/OnZmTogHS2EI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YqSSo22m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OjboBIWY;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZgFV4lBo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rKa8cQVC;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF42375862;
	Tue, 30 Jun 2026 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fpGfQAlLw3qzT5ysYw+w7SeZRvoxB0S7yzln6WQZvac=;
	b=YqSSo22mhojVHr5KaetPiVoKsOWpADcKQk4SCGwzHCD8c91TO93c7qH1Hu/3Iu+C8qEW18
	VBut15wgg3j+TREb3l4ryyZLhMjfVgvJJPfYNovcFJzQIcEEvgSYiOYPF64P5plftbzoOc
	i75gg2QntCUc2dXLmYWRfa0fZtiUR58=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fpGfQAlLw3qzT5ysYw+w7SeZRvoxB0S7yzln6WQZvac=;
	b=OjboBIWYV6zQ1rxvwd5uWsW03NJA0+xMVpxxKl5/JCx9KhJuvl0yKBodabIAdWEdEvS9xh
	9uWMIehk6x4zh3CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836906; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fpGfQAlLw3qzT5ysYw+w7SeZRvoxB0S7yzln6WQZvac=;
	b=ZgFV4lBoUGsQDPFviUEZwCb5BwvFn9qMsh2J0ogEmmwQS+pxrmwiLkr9M9DoShzjh0Zfh/
	DBPpsMG60OIr589X+rITcBxdJnLkKJL4828uid3F84GFeGCB30hiPbc+yKJ/8PKcvVzNYs
	6J/Rz50dxf3wqRpA64eLH4S0f8go2Ww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836906;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fpGfQAlLw3qzT5ysYw+w7SeZRvoxB0S7yzln6WQZvac=;
	b=rKa8cQVC+8ZRtQgsEQclbwO5qC7aomSV+ez16gryVhI/I40x6yq3EpaTh17haLc1Dd6kXE
	dOK0Gmj5eCbIhcCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE806779A8;
	Tue, 30 Jun 2026 16:28:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RLl5NqXuQ2qudgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:28:21 +0000
Date: Tue, 30 Jun 2026 17:28:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
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
Subject: Re: [PATCH 08/30] mm/rmap: rename vma_interval_tree_*() to
 mapping_interval_tree_*()
Message-ID: <akPtjuele4I7iqTQ@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <f95462457025370efd047b9dfb039e76bbddf58b.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f95462457025370efd047b9dfb039e76bbddf58b.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A28B40011
X-Rspam-User: 
X-Stat-Signature: bn5grd4ibac511qjyzsa4dyagwoc49yx
X-HE-Tag: 1782836908-303724
X-HE-Meta: U2FsdGVkX19gYqVjzv06OtT79NwUM5IuFEki9cHfCvvcKTMEwUM1u68lkbZiQ/i6si03ULEV6RP0+nWvi5XJQESK0RizrEkiX1UG7ysHrLG5XjjvhRsnBfxOchphQtnWtqeujk6P+DuS8M0CTiIWmvj+lV4DatZj1126QeEnxYrjzHYT5P59vQeWLRfLsoxyo/eiazAFdawXxTqMBuLk5/+6X5OMkeTO22Q9Pa+edguFQFs/F/h98zGwc4dDaZu7Oc7eP1pVoSsMgSj3AydR+GQc27eGx5Hm8C3gZfilssvh4Lca2VMzOIhO8iP0sNHW4zUXQ1nO+EsMZWavCI7q5rG2DFexqXKDmRSPLrJHnkeDxqh5oJ9kX89j/woqydYzlCuobQmCQVPxbOJCgt0cF5+BzqGvDHhG1Cwf5yrT5yxXSM6ud/9QJFGI9AKK3g4Fc7LLGdYAa2LshZEc5Wq+bvm4NrNmqtEeMzHBV2cqbx9H0JGDiraYE2CJQgFlSRF4zri4h1YZXEpwfnXA4UsDEvkmosSKrrGBugWG0YJcnqEblUA9yW2kL25e41KLZHYoM5yzU9Yr/XR3J3ZAG323CLhQ8NKe+xUpcug7cGDjcqohco9Cm21VC+KEDXfX7V2FesJD1gbeMnglDt25MfErN/97uSvuqpDylSTtlKQhE2BFEPXKMkEwr3Esf0AVlWOZHNQita6Gh0fZEIhZioYg8XC9qNry9zG5mulu3Hwh70rVbKVRUfow5QPjg3kBufeOLIjfOTU8zxKLAmms/SbDxQ7RrV4gsIsUcajv151WwRLvi2t07/qFASDMr3Nhibf0VVIy09y1R7xcAf/XJ4cd0t4HkG+GsyrbfE50Mffhc4lKFJS8kCmh4+cXJy75a1JD2rP0vmOTHeI86n14nsrV0sJiXKTDtsugiMvSGTl5tW9iPa3qlW8ZQS+DH1Gkowu/vFvbvxispFcRvP08jgY
 V0c6RD0e
 NTU8c4zWKbOQzI88/sDW3CdDLIXs7M8Tf596HnbvXh99tglfw4Of/4na2CHmpk2Al/TTLcsNd2T/Y5nMwUe6xnPzRGVdM/iWRgEaH2MR9nJ1HxLcKJdcy1RBfks8T1IGr+ogbY8a5gIEV037sbx9b4OwegihUlbq/RtRC8OgO77HIqIECqZUEegVMbS2SLd5Lfi1EBhWZwrH+nyts8UmyRkqWQalS1yU/Co2zwc/i3R4y4wO/y4mTWcIqEk9R6hTbJQBNEUkVrrAuN1EkivH6s02cc1he+atOtLZmVjWsu49tya02RzY4EJOKcf0uBuBfuuVog53gl5elhVBUD9MnqUVXR2N6ivY+fNZqwLRGpqfFbqA7Lg4MGEGVm154QdWfgtpvMrh/QT2/HdLHuap9hoQfBadruYhuieJ2
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

I'll have to nitpick this and say that I prefer [1] file_rmap_tree_, or
mapping_rmap_tree. Or possibly even better - mapping_ (so
mapping_for_each_vma, mapping_insert_vma, etc).

A bit of bikeshedding never hurts ;)

[1] locally I was naming things file_rmap, but I never actually got to
churn these names away
-- 
Pedro

