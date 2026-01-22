Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 892C0D3EE96
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3C36B02B6; Thu, 22 Jan 2026 11:56:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CBA6B02B5; Thu, 22 Jan 2026 11:56:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C647B6B02B9; Thu, 22 Jan 2026 11:56:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B02596B02B5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:56:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DEED1A0331
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:56:08 +0000 (UTC)
X-FDA: 84360202416.03.BA6F3E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1FED1C0012;
	Thu, 22 Jan 2026 16:56:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UTEaHcdr;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769100966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Ouuw1KntUWS56pg/PFLpKK95mOBMuhGqPq2jMG5wGw=;
	b=Ni23ybANGvKvRz89I1dqKf8WsrVKYt/DVYwfvEbEqhM095ZsTyWMOGWRkXXDuGE1qmGIYo
	mhJrsPWC92ECc43YYwLxuRRuZS7xzzT0TqyEr49htWqdHA8bHOJKuc641mkOgj78mAo8wZ
	d/mYihkbRj0rqVGagFYHO1R5NhWOLNk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UTEaHcdr;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769100966; a=rsa-sha256;
	cv=none;
	b=YvHa1tI49SCT3DQyTLm0EHWcBpyxgmfZuUtbozroHwyfLPmIbWBNJVssMW0vZzzLTLD8Am
	lb8Wuv9ReQnA7sqzVgvY4cNWv+dAYizlS7z1/OxnZttvz5wHT+yh/wv729pWR9JZ84PsUI
	RKPx7Qyh2voQwqxPFvWE6QjdwnKUABc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2B5A43A88;
	Thu, 22 Jan 2026 16:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C451BC116C6;
	Thu, 22 Jan 2026 16:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769100964;
	bh=jrjPF0WwvPZPRM6P6o/2VJJe4697MQWP7qZdUYFxSHY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UTEaHcdr42aH4+na9j15KfpiqbAYafbC0X2iMUD6k4y/YtdzCCZ1DycwTLHJx0PPt
	 +CS99+ai15VAAJyTlXJod09HI5BHg9DqD+81D8WgglFvTzCgDavAE+Qd9mUxEIoEfe
	 6FnS53cyUDclSITvSvJ4wllykWndkBImnZdCxvZI=
Date: Thu, 22 Jan 2026 08:56:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams
 <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, Christian
 Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Matthew
 Auld <matthew.auld@intel.com>, Matthew Brost <matthew.brost@intel.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise
 <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mike
 Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, James Morse
 <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Carlos Maiolino
 <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh
 Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Zi
 Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, David Howells
 <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>, James Morris
 <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, Yury Norov
 <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org, ntfs3@lists.linux.dev, devel@lists.orangefs.org,
 linux-xfs@vger.kernel.org, keyrings@vger.kernel.org,
 linux-security-module@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 00/13] mm: add bitmap VMA flag helpers and convert
 all mmap_prepare to use them
Message-Id: <20260122085601.4d40447ca2f9a060d3140212@linux-foundation.org>
In-Reply-To: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FED1C0012
X-Rspamd-Server: rspam07
X-Stat-Signature: ra4iozhhcntxntr5brohzbeoqq1xjwb9
X-HE-Tag: 1769100965-597075
X-HE-Meta: U2FsdGVkX19rhH0tJeeB6mLIQ9C2D1Kj4X3VxvOgE1Ct0Ecv8KDQ/QQQ8RhCkvGzgdTXzgr91Y6PmLlGCo+anbiGoT3Z5g/wuMiAtXF1YNm6n0s8PtID2w/cNgPcddnjbhXBTcI/hZjpMyGx8Ty9ZoJrXxt5JS6n/EEI0JtnLL8sLESdqyCEfrK35JMEnYRIqplbvJHUiJdn3ZbwH6xSPakVSv2mzZ6ZDJVMUDTpK1JF0DXuBwKULjN6CDutbaMxOafPWdKADonyZbze1RhX0LDMN8Vppxo3bD50ve91xPt7jjQ4rhFpkn0l9mismSkXWjUh+waEk3w3K7RVSk8XV0QuzSI91UhYJAXTgwgjgzL9iZvt/RVjfc3OGpD8bk8xbMbmGmHncXNfFO3H0XWuql9F2zI/1o37w1bAixzRvxqHUm9WaAdTp/YkU1aDw03NRz3n6d6mjSpoIrAo1C/OipPjAB1cCBAtEd0dFb8T5UXRWxCuRkcBFFz47kFXrEDxyvO5WlLCVOxkmFN0EY/NZKA7Jbd3LDAZoL/PNJYwf3aqMsqHGX6TBtlUEgj1MGqb2FYqzZEwjZkLC1Y3/i3XtHAhuh6TQfq9O5Ao9vwtlpY+AOT3k26JDmHaWJSkthfqjb1w0zdLAxNWUpdpRGIOTJhd97Y6SuuN2deyWg8djS7iltFssmLTmXaq1/wHmSgAGk6ReN4lF0Oh27Fc6sGVaqzaD0PHLMXbJEQDGD3vFhs+cIdPZwR3J1k3Abkq6fy7xRaDaZaVU96fSR8CO8fnJkGNHxXy+vFi4gJE/TOe1NTmE9+fQJaKhX/C10qyONrNXgA+POL/+MC2teMt0xWJIzM0/z0pDCFhApgPGgYv9K0HeatpOVW3ujTXq4RxvJyGwxMmTqSyuL10i1d6fvl3bqSQIxKDGAhwXn1fvzKvZb1PE/nU6WPtD8LfzqSASxaucliXKpgj4PY4A3aVBxQ
 uxNE6JEc
 3eERshzGV+vWI5z8n+j6pRHw7tzMVONH+I9QqQmOCia/b3GF8luXPdia56pLh1Kx/bH9QpLslNUJ2oSB6aGwufy7ajxwx5veCU+/DzEOA3fkG/syVP9vKIZjs2CMX1+DuT2Bwftgfs3C7KjbJpYcbXyccIFHmPG7b9/ZR2wUW9gqKI7Huw/7bgCLn0YmionSAZfhOFPB+suxJfsmU6ATKDhaJ+tGoMNaOKisFburw8NiC/Guiy5d8YKbfhhxUZUxH0rDhkSva6GRCnqM4LGFYiiuSJAy/vHsIKjzhzi9KH8+0MxIAdhcXYFSt6zPi13t3XKEDWnd63gEiXS0WT3wIUzbsOeD04dDr2AY5VpXpU9FHI/kfT44gQmsE68nkf/XUmM3/FDUSG8TEhUr5fhHGs+Bw5AHEF/csY88S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 16:06:09 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> We introduced the bitmap VMA type vma_flags_t in the aptly named commit
> 9ea35a25d51b ("mm: introduce VMA flags bitmap type") in order to permit
> future growth in VMA flags and to prevent the asinine requirement that VMA
> flags be available to 64-bit kernels only if they happened to use a bit
> number about 32-bits.
> 
> This is a long-term project as there are very many users of VMA flags
> within the kernel that need to be updated in order to utilise this new
> type.
> 
> In order to further this aim, this series adds a number of helper functions
> to enable ordinary interactions with VMA flags - that is testing, setting
> and clearing them.

Thanks, I updated mm.git to this version.

I dropped the memfd_luo.c hunk due to today's inclusion of
https://lkml.kernel.org/r/20260122151842.4069702-3-pratyush@kernel.org

`get_maintainer --nogit' wants me to cc 72 people on this patchset.  I
didn't ;)

