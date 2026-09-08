Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6246DC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2006B009B; Tue,  8 Sep 2026 05:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A366B009E; Tue,  8 Sep 2026 05:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FBF6B009F; Tue,  8 Sep 2026 05:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 425006B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:11:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C99501A04A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:11:03 +0000 (UTC)
X-FDA: 85190025606.02.F63C302
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E22914000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:11:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K4kFmr14;
	spf=pass (imf23.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858662;
	b=uQGZKzRSDQmUovPh7NYkiUUNExFQe/yBVPlqLFDOY1pet5Y95iIKBrHT06JMp+s4FKByEs
	IJZIY+GabX8efBI4WDq7Og/lhhmm9PdcQMd4AbjdmpjKeEs6/tSMGitAXibsLQPVCZ2ll5
	FuGd5+Fgqc7zQHsIveGQAoDO42pQ4LU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K4kFmr14;
	spf=pass (imf23.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jO5c4Bt3ZAdytp/EWde+NVli4TynjxjjAsIpB98Fp84=;
	b=QyZ7K0UJPyWqHYDpcGhag9gWx9looN5MDi0fn2nfzY+rCUjnlfqGK3wXy2hC9e+cIOXil5
	QuJjXYTtVgbbLWnFutAzju2dPC8ST5zIfi1kzYbq0he8xpvTitlCklxklkrYM43mFj9Quc
	gPN75fdX5Fe6X+CdaiHDF/+nAGYdM6U=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49d036e0e99so16242395e9.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 02:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788858660; x=1789463460; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jO5c4Bt3ZAdytp/EWde+NVli4TynjxjjAsIpB98Fp84=;
        b=K4kFmr14SIQLMgvnzLuqn9lMKFO/nQkSYALyRYE5Px9IkpG/8DPoVcrLvpJLlaV3RD
         RvAkPL//eBbCVRX2zOHluS8pl12xz6GkR2ie4NBMZjmVvtnFDXmj5X4g4xJ4wshrK9cv
         A4OAye+mEKr0/funSMJprA5zunVLrohA3wOTC0vVQivUpvR+9rnInVaziHL//1aHiFiP
         BBDrOmwPNlujG0FqoWCPsgLdGRHTxNYIwUm/a18SqGISWepTpUtnnQG6H9wcq6wf/rPu
         EXaV3I/3TkyfDUooNh8MLH55IXI/F8vkS9h6M4ROktRXP9+m20jUYo49PpYZitnWrR+g
         g36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788858660; x=1789463460;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jO5c4Bt3ZAdytp/EWde+NVli4TynjxjjAsIpB98Fp84=;
        b=TM5qpLPwwNRo4eioUT3uQ2b9QbHkMGaNUxOWyONRJ3kXVvvVQh7vIfvJyNz531QqDj
         wqlo8oU6DEg6AzNE86DF4ogEcKDXeCCLsYJCn5gvCadzePPZKFi8ZJ1h50F1S8ICuLfg
         +s/2ovtiHlOpqAR89ORsYCwMGNfQUVot4yIhEa+cJP3iXYzWMzomO2RlGLH4xsnaLWxi
         hiKoG1U6RmrEKQoOd8Y+jxFk3KPgtbsu3w292aMyR4WRGVMkhi9Ku0rJELLeaPOkYOsV
         k0E50T+bsxWBOYbLCkTpyCYxw4Y9SBFRq0vGlS8qk2/dZnmCz7Iul7xg/Fw1C/s/W3P7
         W2mw==
X-Forwarded-Encrypted: i=1; AKwUvBwDTA0fHMGS9RVXQs8r8zmCS6mrwJ59+JNPqhNKKDEiFHFYV/IIbE1jrOcfkfZ/Ow1aX8gc51rkjg==@kvack.org
X-Gm-Message-State: AFuF++me7pW6CR6z5b+pjdgvo8Rr3gkiKcEqZLjncWlSDgvrZF2P+AIK
	1o0mpfZ2G2NXDqGkajvlmYL10WtF8uoPkeu37rZBDLmQ6QAiw41ddYNYVy0CPiW4tQ==
X-Gm-Gg: AYBFou3xLHKRdTx2Q6dxEU7E7eCx9Kyv2GHlkszWA1ATcy58ynQ/OLI96tMEqsVQjgN
	7gYcyok6jrISfRmO9yulvmpZLACgxa5QuogArdP0+/ZHEXt7qFJVWJSX47cdejnV286i+I6q6Y3
	k10J/Fj2kgs+dAarDn1pimxQo3jAPuAqTUNcoT9kuzupzOLzuQmWzK+A2u7Q8IRf28aflSHonQt
	kJbf3qnY9HD9azx0ZRLgwDJvCROljhAhQ8ssDmgCv0cVgaO079hxmO+JE7xI/3fJz/SAZptIhu/
	sva2l+LUKEUZfPg9LzyTYW2lxGqgNL/ncEunNamtOcLjC+RWWX874ZTMpu7ZhAOH8MkyDxBm0tU
	0dFEj3armBiwOdeOW5KEjvtBQvu10ighiEUBAczwBoUjiZg/NZx6zWryZg3qw7BHmi4aqD7Johj
	C5luKShR5Rsl9TNhwS6WQCl7IsOGksgNXnXU8LTNmuYyGj6OOLvogyqdtiYa9bIMl1y7vJnhja7
	3MOW6l7TrO7kxuDcH6Ri0q08NuUROWXN7mkNN8r7nw=
X-Received: by 2002:a05:600c:1549:b0:499:a5fc:2087 with SMTP id 5b1f17b1804b1-49cf81f47e6mr290181665e9.6.1788858659472;
        Tue, 08 Sep 2026 02:10:59 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfd3f815bsm279081265e9.4.2026.09.08.02.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 02:10:58 -0700 (PDT)
Date: Tue, 8 Sep 2026 10:10:55 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Will Deacon <will@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <ap_RH4ZDE3XI0rng@google.com>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <apquUWgrD9C2jWQ0@willie-the-truck>
 <ap_HzwVp-6aOKEbJ@orome>
 <ap_OFQepcu26g88u@google.com>
 <ap_QJG8EevX98SXa@orome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap_QJG8EevX98SXa@orome>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E22914000A
X-Stat-Signature: oc6d6egnyjqrkeei71zqqm5emocpbbpe
X-Rspam-User: 
X-HE-Tag: 1788858661-792821
X-HE-Meta: U2FsdGVkX1/qmTHDvqrBgKkpJug0IXNiDr7UktJSFauHUktHKbV9P2qTZQ7o3KmxqnJ/JkIeQYUBM8R2SOSOgbsIrOIzXq6UrvbnJ6yLTwOfOi3Ik/Pt1xurF9kIhEwCy9BRZ5ODKq5OcHduQY8oDmw8jkTlZ2KwOmrOCFM+TQAwGhpcgtQRvK4oe26GbTSqc3aAhmGq2ICOgneliCFiM3UIXmmwphgWhhWn6YvmclYXsIbxE9eACi5Jm3631kJdHHXSce4TLFIisda7+bNoUT66d67bCb2GvRnxaKb7jVeb0lbgGlL3qEoBtO36W2idiRHJWcXzKWftgbmC8QWaKXzig6s73ZU5o4mulNIn+Dze5FaI8z0iH0vvNjqEGFUTU6BdKfLVO7i3yyOHyiDQbmnN/Tu7NXdALuJAjmWXHQ9c7yYnmoIoXk2PRqNSD7X5edWDKs2xGTU2Gv6/zKc/u6CMCScwJ9Tc/1vLcSWUdrJJ6B7RAe/YOV32JenZwJaEjlVks1v97VmDBpNdUqEtZgfYuLz9rYtXBcTXQAnR28soaeZ+fwhdWfd9jJGYaos5bpSVAT4t3qsKiSMmeT2gykIPupW61sLXbhiZSQDuonmQgFBJUPqZuER5bqf7MvauUcyVu/SIn5QVq1xKwY85dIPiwVh/Ijr8LtWBQs/D/YqJra5CfChx9QzoxCBDmODP5S7pBMYXTAcJX6O8w5WOcd3l3FbiiOiRqncxg7ieVGdY4leWwn8zD1ZIETW8SzfuymZSBiUffcJ+IlPH7ZeiTjVyLzZN9gEGDvxwMyNs1X/BPHvaqVjLSNceEKxZjltRcLYT7e77YxBjydIJA2gsPAhl5LqmJDlBZz4V60RtEJRTSz+9IuH6kygXTH3zWw3O9g3kWl5gACUWroX/WYNn5f9Y7m1vXTZMbYJSC4uC8C6rAOcFubWIV2/S5zxmo5nRyUSfq0RTCfNSuaQcUoK
 g2U05Sx+
 LXaccuFJXpXCkNxW+5lRI1WqFMRpwM+52//ImaYGQ73pW5yuxcCwB6goHCA9il0+c0YwoefnYR3P+eOCE7z2kzWpBoIhNtB+M3w9wW4/2QZGMErql2p7MLt7PKsss9Or2/bpP5HHj5YTCSz2cdVpfNfynnVXsK+0ukEujdKut/X4pjsJS8QDJuXdohsrpWKZC6vQuEeFaOpYwlLYdQMUHK0dopycWWLIKapICgj1vT+rB9VYZyWMYgWrY0sIp8191Ki7WORUS+5G33y716XLJdi55vjufDrG8A9ltrAnVi3KuB/h9BQWSe4Uoo8u2ygzDkyq/GeJyWWj8AAzmSK4FH6UoTqtzuafK4s8ukEUgI9x/nI0DgFIyK+i1/wZfGB153Qdhq6KizO4otigEGsb78w2F0GMCsA9uvMb6q+AWADZk6JXtl1N39KOxbBofcruDzgouzlFB9d99uuXdGowUVMZ40dkn7H7g+IqA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 11:08:26AM +0200, Thierry Reding wrote:
> On Tue, Sep 08, 2026 at 09:57:57AM +0100, Vincent Donnefort wrote:
> > On Tue, Sep 08, 2026 at 10:39:17AM +0200, Thierry Reding wrote:
> > > On Fri, Sep 04, 2026 at 12:41:05PM +0100, Will Deacon wrote:
> > > > Hi Thierry,
> > > > 
> > > > On Fri, Sep 04, 2026 at 12:44:51PM +0200, Thierry Reding wrote:
> > > > > This series adds support for the video protection region (VPR) used on
> > > > > Tegra SoC devices. It's a special region of memory that is protected
> > > > > from accesses by the CPU and used to store DRM protected content (both
> > > > > decrypted stream data as well as decoded video frames).
> > > > > 
> > > > > Patches 1 through 3 add DT binding documentation for the VPR and add the
> > > > > VPR to the list of memory-region items for display, host1x and NVDEC.
> > > > > 
> > > > > The set_direct_map_*_noflush() functions that will be used later in this
> > > > > series are exported in patch 4 so that the drivers that use them can be
> > > > > built as a module.
> > > > > 
> > > > > Patch 5 adds bitmap_allocate(), which is like bitmap_allocate_region()
> > > > > but works on sizes that are not a power of two.
> > > > > 
> > > > > The of_node_to_nid() function is exported in patch 6 because it is used
> > > > > in a later patch adding a driver that can be built as a module.
> > > > > 
> > > > > Patch 7 introduces new APIs needed by the Tegra VPR implementation that
> > > > > allow memory to be allocated at a fixed offset within a CMA area. Tegra
> > > > > VPR needs this in order to implement its own allocator on top of CMA to
> > > > > meet the strict hardware requirements. This replaces the dynamic CMA
> > > > > area creation patch from earlier versions.
> > > > 
> > > > Did you get a chance to see how this could work with Vincent's series:
> > > > 
> > > > https://lore.kernel.org/r/20260902104712.2399797-1-vdonnefort@google.com
> > > > 
> > > > ? I think that should remove your reliance on can_set_direct_map() and
> > > > mean that you can retain block mappings for most of the linear mapping.
> > > 
> > > I'm not sure if it would help all that much. Yes, if we mark the VPR
> > > region as LLMAP (or PTE_MAP, whichever it ends up being), it should make
> > > the checks for can_set_direct_map() redundant. However, from what I can
> > > tell, Vincent's series still forces page-granularity on these regions,
> > > so it won't retain block mappings at all for them.
> > > 
> > > The block mappings can be retained for the non-VPR memory, so that's
> > > nice. It also reduces the amount of external prerequisites, but I had
> > > kind of hoped that we could go one step further and keep block mappings
> > > even for the VPR memory if the region happened to be a multiple of the
> > > block size.
> > > 
> > > The recent addition of page count to the set_direct_map_*() functions
> > > helps reduce the amount of checks that need to be run, so maybe there's
> > > not too much to be gained from removing whole block mappings at once
> > > from the linear map.
> > > 
> > > Thierry
> > 
> > I should be able to add PMD_SIZE mapping support to the series. That was
> > actually my original idea as we can easily force the CMA allocation granule to
> > be PMD_SIZE too.
> > 
> > I didn't implement it as I thought there were not much interest in the end (and
> > also as contiguous.c is always using PAGE_SIZE granularity).
> > 
> > But now as I have implemented a specific pool (and do not use contiguous.c as
> > originally planned), if you believe it is important for the VPR driver, let me
> > see if I can extend the support in a V2.
> 
> I don't think it needs to be part of a v2 and can be a follow-up. It
> should be transparent from an API point of view and merely be an
> optimisation for that specific case.
> 
> Eventually it'd be nice to have, though it might also be worth checking
> what the actually gains are.
> 
> Thierry

Ack. I'll keep it as is then and we will see later how to extend it, if it is
necessary.

-- 
Vincent

