Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478DDC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4F06B0093; Tue,  8 Sep 2026 04:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C056B0095; Tue,  8 Sep 2026 04:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464186B0096; Tue,  8 Sep 2026 04:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1697E6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:58:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 826A3120469
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:58:05 +0000 (UTC)
X-FDA: 85189992930.23.FE06F92
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id B0B6740009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:58:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i3xOZyLv;
	spf=pass (imf17.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788857883;
	b=vIkImbu82+o0w0UkLlZ2nxq+n4AdcfU8kI3xB2Mc9WlBbG642t++LKnrs9RPbgUJzE5HoS
	Lq66wtIL4Iizsf1TOcRJyCBZh170K5YIDKalO48ROFdyPEyuXhWER5mMu//n74NcCmXF+t
	JoJ3seCuBi54GjMJuqLMpj7hCvK6grk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i3xOZyLv;
	spf=pass (imf17.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788857883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zFe5CkdviVdWpTUjRsL71ghioltrlS4PEP9q+np+JE=;
	b=GAenr5Qn1htXTmDkI8Jytk2DfQMp9qBpyw9AmlH+XJCxBG7tT4t0jgJ+Lw0LVkLz/LsAD8
	6/EHsBNc0EewWlVmqcOKI0m9ax1Q81K/DYadw/BWCKSlNZ2X73YDcCuosiRVMPo+TTIWjb
	llaitOV2chgFN2cLZuSVlj98vkr2y4w=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso41943445e9.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 01:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788857882; x=1789462682; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1zFe5CkdviVdWpTUjRsL71ghioltrlS4PEP9q+np+JE=;
        b=i3xOZyLvlJf+vlJ4lQRLhDtIP/5ZGZInyQFAPdDm+O5Rf22zkHZdFDd3l/pEIpuj1G
         vHSqs8Xl9yMkd+LeR53NDisYZGPXIFVr1I47kPV3lkrrZm16JQ58Ui+93ZqAP9J6XR6E
         heBCGtAvb1qKe7/hL4NTHmy33IQcnuNv97/DqyeGsl+p3cDdm1tTqtVSVDZTpVvEagg4
         lAs7gc9XRf99l/dA4ip3D5M2ycMkgM3Zv3xsCKl11No7eBpFhy9iU6KPcx8VGWlEuFfl
         8442YILLT3vuXL3oaS3UDLXUvLZ3CmcY1/qa1BVLYSD0jD+7a9fOzw2rW8s57p5211o8
         sklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788857882; x=1789462682;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1zFe5CkdviVdWpTUjRsL71ghioltrlS4PEP9q+np+JE=;
        b=lsA5JKIEOn7Pxw7kfQMZxrZlGFFrL78N5UG5Jw8aoEdJTfzOelAqh+PsoLgLYARyR3
         HhmEw9sMzQCTbPr4Momtx5FPH6Wl//c8C1jvbgpvuOo9gdBJZIH9qMNN6ZFKpy2t/GzK
         tlz3UTWzEOh47c6NEHL2nXW+5sS6ISNbNbzKXlDnf9Wp7euuhIEPoLBKBY79YU+zLOwt
         kKViS7WHnFrYxzZx11f80DM3tGBELJxgV57jSJAbODXzPPlqFPGyX7l0JV7KDEBMgCVo
         GuT/2qMf+xUn3ByM0R152ZzOji9aggQoJvt4a16PegzaMz/7O+PeNTM0wgRum2YAvKBf
         +tEw==
X-Forwarded-Encrypted: i=1; AKwUvBwDEdN0uJSyZ1GeruALhRYIOCXIvO23VvdZLv9si5Z3cjbchPJfyaJ1lj6QDeKUhGke4mzMfLcxJQ==@kvack.org
X-Gm-Message-State: AFuF++nIIsrKA2QH+EZhiL64aU0fYAVmXPGkbpD9/ShM3BzAIL9sqStJ
	Kqm3GaRVYOjjNor9x68cSawEokNoC7o50zQ/i/vvt9h1EA9DDH2f2MVzGTlYRzpXrg==
X-Gm-Gg: AYBFou3W87ypLOoA3dE6X0iaJtoT13s78V6SkTX++BF6VOh1K1kFQqXQ9bV+sQGFzeV
	3G5y3FvkfN6LiWFSMSh1n83P0vDl+eMs+n/ynPYOWHREwis7FGUlHtTIlMBmLcg4g1HG6sQqd6c
	NDAwIHGlDNbjwkj7J89iFDukfELHuB5uWWD4BtyOoxDRERfY3p+NsEibMFHPnMUlIzjTyq+I6Ta
	Oe47qG4WVGaG7bUcr4qZtl9avpReZ3RZLksN967GeKo/1a0HKJ3diF2WI0VvWLyjO+1JihQ36Ct
	kQPIc+3cacNIbhCGLhap0FisCTJXrGjsudqjTrrrycEeiNLGnpa90Chc2up+Yj4jbrPmK61ef91
	+uWrRdSmYj1BRZwhv6dqDgz4zs2U56zJL73AvUWpnKZWDPq5rRwLQU4iaxAQfH2HpkP/g3Ga8tR
	RdBBItcRnzP8e4XJXKAZw4nqg+LbssFWyt5b+M5+OwsOnMs68JhrRIP2X/KMfz86BKSrG6eLFGs
	nLOXMbyWfB6qAJw4zrNuZlaS4IlSNHmqA==
X-Received: by 2002:a05:600c:4713:b0:49c:fa20:cc00 with SMTP id 5b1f17b1804b1-49cfa20cd4dmr257500325e9.23.1788857881099;
        Tue, 08 Sep 2026 01:58:01 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm476174585e9.4.2026.09.08.01.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 01:58:00 -0700 (PDT)
Date: Tue, 8 Sep 2026 09:57:57 +0100
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
Message-ID: <ap_OFQepcu26g88u@google.com>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <apquUWgrD9C2jWQ0@willie-the-truck>
 <ap_HzwVp-6aOKEbJ@orome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap_HzwVp-6aOKEbJ@orome>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0B6740009
X-Stat-Signature: ouzyywyx7y4s7u6gap6zec167jgsf8mk
X-HE-Tag: 1788857883-239475
X-HE-Meta: U2FsdGVkX18xX6Cs6H/HzpjT/RgVrGIhgmQ+MTsUZnStXXo0eV2+bidgdQFmcthXSHq7hqf3dAXPS5tOiHI+zCRZCuVC060WkS0Dg1Alq5bt+VFKsFyy/htw2HNO1LgII4p0EJ834WtI7Ia+uRoAiPTJS3yDIiGVULCPG0ePnCigGeFHUyckYTzHPU0BgIMFuy2eoiHpxW4j5agVRKpLeL8FKG8hyFZYWmgU0ym3yb2BdoYjftZL/1nchiizfwJYG+CaUf3bT8JcOhpE+PmN64jU3nNJoUD+x8cf4eP0wF/eZyR79DGZsk+L+fKCj8fGurx8zCOLk4J5ghYUED+vXgWsSOXOT16tUZHg9f1t/+rSHbHJTVqgECP+ERYId8HIRYII1O6f9hUawN7QUzILrwulGyFC7OQUIx/x7BB7sJorJY7V/lOa4xz2kVfPlcuTlLIcwkJ+BWaUPVCuFMxuuKco+Mnmr1B/BCOn4wyZZg2gWtnsT3gwHoBTECAHc7Z3wa9Tp0eNPrqj4kl2SmGn68BQOqSdNIc/hAGdkmhO7lPix0DS0h46O4l9lpUEgJUuFUuhb89hC8pN71z10rPDc/b7tmk7QpGXdCRMzRauIFrkv4vhqY33tIXTQCfBb+WmXSmBDeUQU/MAiP0Tlg484WYhIgfL2FC3JxmEeQz11vdYRrzNL3brcc26gOUDpCg34fQATg9cV+aZmOveTCCTnLfkWb+FWZTlrXBj/hTd+9XJpE+RQkt+IbbQ/YQJdCszTqorKBgN8P1v6d7VXJ55LQSTEPqJBLrSiGyJV3FcDc1BlO5Rl/WBshKXbaLRVc5aFhtht6qMxbukYUffcR5YHWc4G109BkIl4Eoi5RC8qf0hss1RR5OrVf47ISsM5uCXWzfMTDQI3ttY1KDMqCjuqnTctd7yrzlY7y92HtEH3DD3X2Nz4AIHOTTvsAK9lWgeF9xCO8foaa2JG44zRuJ
 VVMNgz0n
 PNtvY5ppCI9MJ659rEEtKYJM1vY1ZN35avqM6RkJCSIp+ie07nlil3EZ4ZL3zNRlUwHfC8Wq+lpazPfAeiu3rr5dq2StRd3avT6c/8PW029cb8szRap2G2Hum2XTZvAkeypNwlfjoASOYnFFwv9Gr+bjmB1ECVCkv6D5wes6FVNWWXE0g1hR4Arze9fSSvbOgazZbTbIVIL62wF2TFWN1XAXkRZZ1+7Vai5GHHSTZ0oNEkz7vWHTeJ7lX+5TAkTetS51PAC5tdbXZaypcaj+1v3U7r1RcAqrgjIPavV2X5oLB7kGvr6qHctBGXf0SWd/y8RNFqEZUvqxnk6fWymmhyHPa/j/gezw9HXWUG+sd656flpP5qewrP2WgD5mDXUOumTO2Y+Gmox2+/UfFi+Xzvksa6hGBiloGZ5suMxJSjlgOeyxs0V8z07yn5+KCGpN76i7SbP0myNHqGvCDFcZryRBnNG+20Eotsj3c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:39:17AM +0200, Thierry Reding wrote:
> On Fri, Sep 04, 2026 at 12:41:05PM +0100, Will Deacon wrote:
> > Hi Thierry,
> > 
> > On Fri, Sep 04, 2026 at 12:44:51PM +0200, Thierry Reding wrote:
> > > This series adds support for the video protection region (VPR) used on
> > > Tegra SoC devices. It's a special region of memory that is protected
> > > from accesses by the CPU and used to store DRM protected content (both
> > > decrypted stream data as well as decoded video frames).
> > > 
> > > Patches 1 through 3 add DT binding documentation for the VPR and add the
> > > VPR to the list of memory-region items for display, host1x and NVDEC.
> > > 
> > > The set_direct_map_*_noflush() functions that will be used later in this
> > > series are exported in patch 4 so that the drivers that use them can be
> > > built as a module.
> > > 
> > > Patch 5 adds bitmap_allocate(), which is like bitmap_allocate_region()
> > > but works on sizes that are not a power of two.
> > > 
> > > The of_node_to_nid() function is exported in patch 6 because it is used
> > > in a later patch adding a driver that can be built as a module.
> > > 
> > > Patch 7 introduces new APIs needed by the Tegra VPR implementation that
> > > allow memory to be allocated at a fixed offset within a CMA area. Tegra
> > > VPR needs this in order to implement its own allocator on top of CMA to
> > > meet the strict hardware requirements. This replaces the dynamic CMA
> > > area creation patch from earlier versions.
> > 
> > Did you get a chance to see how this could work with Vincent's series:
> > 
> > https://lore.kernel.org/r/20260902104712.2399797-1-vdonnefort@google.com
> > 
> > ? I think that should remove your reliance on can_set_direct_map() and
> > mean that you can retain block mappings for most of the linear mapping.
> 
> I'm not sure if it would help all that much. Yes, if we mark the VPR
> region as LLMAP (or PTE_MAP, whichever it ends up being), it should make
> the checks for can_set_direct_map() redundant. However, from what I can
> tell, Vincent's series still forces page-granularity on these regions,
> so it won't retain block mappings at all for them.
> 
> The block mappings can be retained for the non-VPR memory, so that's
> nice. It also reduces the amount of external prerequisites, but I had
> kind of hoped that we could go one step further and keep block mappings
> even for the VPR memory if the region happened to be a multiple of the
> block size.
> 
> The recent addition of page count to the set_direct_map_*() functions
> helps reduce the amount of checks that need to be run, so maybe there's
> not too much to be gained from removing whole block mappings at once
> from the linear map.
> 
> Thierry

I should be able to add PMD_SIZE mapping support to the series. That was
actually my original idea as we can easily force the CMA allocation granule to
be PMD_SIZE too.

I didn't implement it as I thought there were not much interest in the end (and
also as contiguous.c is always using PAGE_SIZE granularity).

But now as I have implemented a specific pool (and do not use contiguous.c as
originally planned), if you believe it is important for the VPR driver, let me
see if I can extend the support in a V2.

-- 
Vincent

