Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A231FC9EC92
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19966B0088; Mon, 12 Jan 2026 08:52:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1956B0089; Mon, 12 Jan 2026 08:52:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2E16B008A; Mon, 12 Jan 2026 08:52:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD56E6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:52:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D8CDB75AF
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:52:12 +0000 (UTC)
X-FDA: 84323450904.10.7AFF254
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8782220004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:52:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=mAEtQ5WI;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768225930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhCKPm7VYMhHUNH30pLlSTekzRTr8ph+K4EroJm99dI=;
	b=3eTYo+PB9m6aR4QPoKSPZSab08+izPRGZcd4qPr7d3uSgTDXSf8lvBtfm9dtCK9PLBy/0/
	F9GOW7SBPbC5XJGMJzYpYgXK4B3LcwWtEoSrZO4hZRpsIZDmWdGHPb3LhgjMGU9et+/syX
	t5Bh+z5UAPUakcfbBQWMEo6xNJw9/Dk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=mAEtQ5WI;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768225930; a=rsa-sha256;
	cv=none;
	b=rG1P2S6ULkza8zXg1ooFL96R68kSz/6SIafyiD3pGPv/8Fog0MBn4OLUdYMhRcMIGBW+sc
	83FsaidJBBsvaEhqbM5rhzu+oy89/mZqlN1vozsafF4kB6iQSfeLHHIIa5/Rrcdq2JDykj
	pmlG/jKI0796pegzLsdpIzGiGrTCN2Q=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ffc0ddefc4so69621991cf.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768225929; x=1768830729; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OhCKPm7VYMhHUNH30pLlSTekzRTr8ph+K4EroJm99dI=;
        b=mAEtQ5WIAUxL2rCH5pc6vkaVHyAZqRAoyaL5XyTk0Jff5j2U7ky2X5PJwNJ7Xt9crp
         g/pj9V6Ca6HDM6kRiEGNCRJGQJU95AdPZyfxD5t5R/QpuEY5wrGCMKrrdv4ftYEduxsn
         KDZleGV+Mkn/2WJjj8j57i8gBRKKeZXv23FJyX7hsTYdVU/9ne0rzmgcho3sqydb0Tyh
         S8Mq2NKVjvTyVt7931Qoz0YQgZdOqfEQwDZndkOQjQKkvdZpCRyWgS1i0iTbJ4tl/lAn
         R6NlL5Ketj+fP57WaYxUEqmDnedcZigmd43kXyujQaqBfrFZlqqf8J0EAz+ZT5j/ejFN
         WFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225929; x=1768830729;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OhCKPm7VYMhHUNH30pLlSTekzRTr8ph+K4EroJm99dI=;
        b=fqFVD7v/q6fsofE2+N/SvPcrFCUW4ITOSjhAyAKyKDrlZTEUTb9k3hcOUWBP8WPls6
         zsk5pVs9Ch2OEmyKrQdKboHB4UKZzI3ONWLsTSCZ/quNbXHqEwuJXC5AsLDk7vFldPLQ
         7dWpPyjCiFtOveAHeBnwEOLCgtkK2j6RVoxxxTPC5plW8yN9U95TsOMRz91LFTar7mMO
         ZBADYo24DG9JmP/AeAie1ZD9hb2RSuhXdcGgoaZ+hRAyrko1Jh2ziZY+U7OFQW+M5HuJ
         7E058gL9pEIXwCXmXW5H4nFzKZGXL6upzhbMgqIdukhgpWihOrFN2uv6kJwF9AJBdvKI
         cgNw==
X-Gm-Message-State: AOJu0YyIZydfpnFVknK/P9c2RNURsG3Oo9B9jL/vZemJ3llbzlDVb39J
	HmepGjxkmHXmvwpH1ng4jYiLeFFMvbC7a4yFqaxmo/aucCIjK7aqRY4Pr9LxXIfc2+g=
X-Gm-Gg: AY/fxX7uGa/yiwNRX9wCoVlnKuUDl4KwiUcUnGL340xGwP70akA/FaUaPQ/9I5FA2gd
	MAgYl56fp6pkZaGTWADSafPVH3hkvgpifjisI6vsGy7E3+oiRQQyi/MoOhFaF207o1Kcoq9zcWK
	WBqgpp6FwBDd3U+MjWMcoGq5OcXqEJ+IoZf6B/c7cVMJ6IW0645HgMrCh7r7cCBSTmxcfao+HIh
	YWjLFgb5kea8whQhkWkL7SWYR2hSPX8xHqnpLTYg5HeDogbI+CilLBjtrD33CKyU0EEhpzqejWV
	ygbql2wOzYIcpU++Fry6tj1Zj9D8NOjuaT+PO6xg/PgSJWch8eV0fGlpGtA2eSbdIO1xqPk5yED
	ydAXDTMWWNBOKaHO+c9eG3bzrr5nLQNON1BS9PLphHiLvVgD0ozRMjInLi/HCAgY5kcOg3Its8B
	p3nF3OxJnKinni06iemVaZFb0TmOt3mfYvCvn0jKD3eVtHUi9VJ3mz8WuXSmd2HogBRAQ=
X-Google-Smtp-Source: AGHT+IHqj1rZAaLOtZCDsdzXVUTGgkS4VFYt/v/ed+Pf3/EF8sQyP07+6+eSH3qW3iq/2/72eoUoYQ==
X-Received: by 2002:ac8:7f88:0:b0:4eb:a1cb:7c with SMTP id d75a77b69052e-4ffb49c7d54mr248147041cf.64.1768225929518;
        Mon, 12 Jan 2026 05:52:09 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e20bcsm137210676d6.15.2026.01.12.05.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:52:09 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfIL2-00000003Q6R-221D;
	Mon, 12 Jan 2026 09:52:08 -0400
Date: Mon, 12 Jan 2026 09:52:08 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <20260112135208.GD745888@ziepe.ca>
References: <20260109171805.901995-1-smostafa@google.com>
 <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca>
 <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca>
 <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
X-Rspamd-Queue-Id: 8782220004
X-Stat-Signature: f1ow8ndcdrrdqpid3txg1eguikx6bmn5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768225930-759322
X-HE-Meta: U2FsdGVkX1+ROCyW8IEmlsc2739y5WVr3OOStYEIwonv0SYdsCqSs2JJvI4s9VNY/M+San9+OI1SdB4iSkrt+Ko74zkagYizBke9PMnhjk1abccGqdL5lT1xdVQBhgmuD8bzsONjV39kAAWjZ72XTsXc7XCIB/zR/5n/i1mbsLIA+gHG0lTCbKpu46z6qm+BfRnuXHfzWgV4teZm1Krc7kANrBM27XjWHGJ2ZohQZfrUw5OaOG5VIB64gU9ZGkNXPQC/NymGFH1Qh7ZQouZwhqin/EIo+VNJ5OsJ4wJeBqLZkeWTiN0nNIyn236W0m9URadBzNPQfd/GNl1iHGd8yOBFhwKz2EW4ekpNpNYGiWufnswluQ1B/OJBr68TmrCLl37bBRamWdbZoK6Xe0VXKXF46azbBKfRW5B8J5xMYDXAorNdVJ8cJWJnnPjwCWLATWK6Fo+gfVWUS0ea7GNoLKgoW8pAxoosN/7q5rsKbbUmLje067YCT1F4BnviIvlGoogZRswx83fW+uZ00WE10nqBOUUkfxWBWtH1NWFGRW8nCz05PHGUCLLUIr5yeDM5ywakVKjDTEEKF5rd34Evlzru/x30UGEI6O288PGAze9d5PnC0Mb7AlawOamofFrZ1b4mHR7474IzJVWV4+jJLcemPlqRDLpGZ2QShp4uFS1olOV2BNVlukhXplHmzOgSVP9EZOq9DKmrUxHFIt4+G6GmpUZvz2hVbgTmKsEBa1hk4HMOpoSLepfD6M4Uxb6pMjGYlOLshjh3FI+wHtQTnUOFOL6vkv5mEAEd+rhmtCEV1qtjAtX9dRqSX6JXNAnFBbRsIX56+/2lXP7Xe/OCU3n9X6UqCUNCWBPw2RBNjZIVj6j+rY5UTiDpoNDFmIM9Xfu15YdZ6rG3JNZc4yj8nMj3PBcGW/4iYu6FRXUV2lHCb/CVyT/f8nmBlzW4HiBqw/L6u+09GX0htBqHtKY
 OxVffOW6
 eGXX2HuGxORdr+Kc913/2e+lNnzyzSBiPjQfFmtb3w9QYqkPzR2THhkK4qa664pa9/2vxtoY+T6fr6WdNwMEVlk+Vtz6hmt8tcYVz2YQmKSqsAshGwgKQ13kxcM02wa2Do4XaJoXKRpzwmyuwAEz90XNFX+h06Ls56F6iVqgMOql68dm3qsbkspugJdp14HsVTiiuk2kQAZJii0R65vcntmIVYVLlXOohB72BzN9vBYE31D+WJl6/WGqY4InPZiJaMIuFcyi2uqMXMLLdxWZM2zzm56HYxJq1U3bEYFOHFt0ANgG7WruXKLdg5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 01:43:41PM +0000, Mostafa Saleh wrote:
> But I don’t see why not. from the documentation:
> /**
>  * pfn_valid - check if there is a valid memory map entry for a PFN
>  * @pfn: the page frame number to check
>  *
>  * Check if there is a valid memory map entry aka struct page for the @pfn.
>  * Note, that availability of the memory map entry does not imply that
>  * there is actual usable memory at that @pfn. The struct page may
>  * represent a hole or an unusable page frame.
> …
> 
> That means that struct page exists, which is all what we need here.

A struct page that has never been initialize shouldn't ever be read. I
don't know how that relates to page_ext, but are you really sure that
is all you need?

> I can see many places have the same pattern in the kernel already, for example:
> - vfio_iommu_type1.c, is_invalid_reserved_pfn() which does the same
> check which can include MMIO and then get the page struct.

This whole flow is nonsensical and wrong though, I wouldn't point to
it as something reliable.

> - kvm_main.c: in __kvm_vcpu_map(), it distinguishes MMIO from memory
> and then accesses the page struct.

That's sure looks sketchy to me.. Eg if CONFIG_WANT_PAGE_VIRTUAL is
set and you try to feed a MMIO through through that kmap() it will
explode.

KVM can argue that it doesn't work with CONFIG_WANT_PAGE_VIRTUAL but
iommu cannot.

So, again, IDK, we are trying not to use pfn_valid() in the DMA code.

Jason

