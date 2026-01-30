Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B76E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 22:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB3A6B0088; Fri, 30 Jan 2026 17:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698DF6B0089; Fri, 30 Jan 2026 17:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A916B008A; Fri, 30 Jan 2026 17:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46F4D6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:12:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4EA75866F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:12:55 +0000 (UTC)
X-FDA: 84390031110.12.A4E1947
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 29F96C0002
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 22:12:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DFnzWH1D;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769811174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcwIl3uOXu5+/SwXKBFd7tJC/YnUbnTLiMTfGdoJxgA=;
	b=SEUDsFpiALuE2R0Ii1rgv/82kx/uM9xUkR2Qhh6LX3AK9KcSVAC/04Qz4N7FtuZVNGX9VR
	RLVDxhWaN3QL1MZfcbLnjrG2UEJ51qSFj+HMFimqFFEdZ7NZvYLhk3qVxL8Dmv8sAtMT50
	AboSE2Addnh+IJbLZ/iScRdgiAnAa9s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DFnzWH1D;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769811174; a=rsa-sha256;
	cv=none;
	b=auCP6fX68BsfxChYoEOwSxFd0McLcorFTSoeEzmm9BEONJkgyZkDwcl2C6mwX9Pf7jXriA
	XikfsgYGzqcPqZrQMQdKiq20YLSlj9g14veimQbxELr2/I4oETTvXYKqSfV7Yayzo59LEk
	UxZnzuhigxkXMBm9F2hSq57zy0krYiY=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c6b16bd040so297970385a.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769811173; x=1770415973; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WcwIl3uOXu5+/SwXKBFd7tJC/YnUbnTLiMTfGdoJxgA=;
        b=DFnzWH1D4v1Skg3GeBgXKPZoUdf4bLNN62RKXDji/wEfI4Err3PQCJl87+rK4A19Vu
         z3kPeyd+ruN9+ds+KTVVH4l1z9v4X7T+yr1KkLwNQjDBjXFblDbWz9nplJHDepP664+U
         pn7m4izRY1/QIUkUkkGdNmckuM5Z8hIlVPW1rh9tzrLtFIkqg5GSvScoGNC+8YdifDcD
         o7GPBmZi9W9hiaBCiihgo9jcQ5MSghHVZ0dx1ED5mGvo/ioSz+zQ3rYICZ9WdAI+s/pM
         JuJ36GgUiR6DcgO+IYIODTKOj/4wkF0Ae3G0zpfJrlEoQRcgYpmYjPPsY2oZWQ2e//0j
         Ovtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769811173; x=1770415973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WcwIl3uOXu5+/SwXKBFd7tJC/YnUbnTLiMTfGdoJxgA=;
        b=W9kLd6kiBANaylbuDUKGTJIGJFUNzzGpO+lHQPnxrHKHVhgHc0sQugHA0YKjeYemLM
         MeiewMjMyRJFIrj4vLNZCi5pCX0g6ARuNaUDQn8ZHw4OrQomelyKRfaFRfuy55zdEyZN
         T+kFaKoKMDF97DVk4yiJT6hdNhqnIhG10wsaMAwgdCYg8yhiq379TNJ/0m5r/WR0L1nl
         jQO4z1LkRZB2V5r26SPOo4e85DdyIPqgH2s/eGnWmrwjBT0obxOK6hfJ4og+3aA3gn8U
         gGw2l/SnzjfxxDOcX6gex5dgM11liWZCQq1gAxkNmRISmB+h8TC3Bceda0irng5N4gAG
         nHHg==
X-Gm-Message-State: AOJu0YxlCxSrYCl0OMoBrzfJjQeSwS00MhBeLxqL51XB3zEdsW6lYQj4
	obFhN0m+KusCZwVfNnkxwbyDcWfKFoHqrFEDfCbqLYOZxy+w6bT7qSf58yvRlDOBdvo=
X-Gm-Gg: AZuq6aJdXbdH7K+H+KtHM3sivzi5fStbqunpW2RZvcfYAq7f9Wweu4Vn6m/1L6GclDD
	hkQIpLD4OLLCA6UZuYktVniT8F6aN5T2XWlEhTS67Th9XrmOhy9LNIkMRE7A1pYVvyzsVET3rfI
	ys1UmurVyFeHl/SM74xs32O1CLjWF12slTl2o3jtGsd96LeVsASjb/K2Nal7Biprv4cnWcEqYoa
	xI/zztT6NMLQsLi19n0HW5SwB3WAtWTyBAsbw0YQuvdsdoHu94SHeCCuwW0XvU35foX0ebjsN8P
	+bU+xrA7u9GEjZTB8xGaQ35j74lCGujNzCs2U4YUdHzGg+C6CBLJZItzXkMX5O7RUGEi2UzEfg9
	qTzk3C8uFCwpZZhNaENTsGwB/oB/vcc56Vlb41BcxPQZ/7bVwL6IRTydNcRwAYBg9Dc6aDRKOBP
	CwTTBBJ+UX+z8bvfBe4p+uwdOLfdx445F4o55kIC1R48ssXR7NS5jxje63FQ3p5GA93ZgwBei3p
	Cium36Z
X-Received: by 2002:a05:620a:408d:b0:8b5:9fc7:812b with SMTP id af79cd13be357-8c9eb215f79mr587853885a.6.1769811173102;
        Fri, 30 Jan 2026 14:12:53 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36ab208sm66770586d6.1.2026.01.30.14.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 14:12:52 -0800 (PST)
Date: Fri, 30 Jan 2026 17:12:50 -0500
From: Gregory Price <gourry@gourry.net>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <aX0s4i5OqFhHkEUp@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 3hnhyuwa1ramtakhzcm6wsgrhiahwngm
X-Rspam-User: 
X-Rspamd-Queue-Id: 29F96C0002
X-HE-Tag: 1769811173-777880
X-HE-Meta: U2FsdGVkX182keaoG8QoLr6NggtAEg26AAWiMPSCj5uSZ8TOPuKHXaRvFMxLa8x3M7RfA44FziuD4zWPRqqfdpnFzXZ1MNUGPlF/hLajJmZf1/mzG2oToxrr8zUT1BhceHWNYZcD7c2xiawNDi3kfVdiF+DBfU8Z8+OE0huMcFwyRTVCwzJhj5PRwGC+AOw0IcuhL8R3eDUMN+oXTdADle6PtH9yB64E3BK4hZnIONUXtYYMblWk365zFo0PE782f3PIth9kavmuMsleJqqAd4YatxPnGX0MpekMskH7BwFvdKnzY8vMz0NtfYAQjMW3zIVLJOUARUJGDsfMwgQcS0nRT7wa//RPKZexf/PWffzK1mrufs+2Vz9kcphCy6YEGbPFSAVS4VyzyLitGB1gQnX5ivyaY/k26YPRos3nG3m6xPnwtz48NSRxGNDNRiKLetEYg6h8O4zdxSlt/Eokre/3sGsbvZVUdI81HbZ2q7NWh7qlQc1sHSglanIKqhvKZbYqFuDTQx2HAxgWw0NKDPFVJjEzHmUdZ4xseYF8DZj6s5orDJZIq9tiGKMuzWQL/CKuhv+ZjHPFjVgQ2LlBnI9MYpQ015g9LwNUqYlfhfe6AMi70ksLOjiNANXtGiTET6tvhff+sjzkWLvikJ0tPJdWecAvvwEhuaIZ5lkEctR5XXX8tmCyz3ld77syc2qRLkh+/JU7aiZ76Mhk/jwHVFMsqhweA/cDd6UGjS+hSaqKX3DD/P3C8trt944xZINlvnaoHOTh0PKoXS49oJYY6mxL8F2+8qGhmCeCPcHTQqdqemlqE+nxjJdsPbnCLBnWtifX0mTm0DBjGagmijMKBrEfZCrRCO29UgA5s33i6eSsWJZVy6dyGDxFpGGmAH3y/pWAYMINkIF8FbtX914Ewis+BVYjhSKHuSRG7ukTLfjf5v0edLHomkcnp/OMVGtdmrKO91Ca8V3IgQx2Sg8
 VlOm8/fi
 dN7EeQb1G4FQjo7GIHWcPFIuWVhFUmyVqYo+kXHiFYojRXzWxYIXbROCx4odKsTyh4xZj7zdFIAwcLWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 03:27:12PM -0600, Cheatham, Benjamin wrote:
> On 1/29/2026 3:04 PM, Gregory Price wrote:
> > In the current kmem driver binding process, the only way for users
> > to define hotplug policy is via a build-time option, or by not
> > onlining memory by default and setting each individual memory block
> > online after hotplug occurs.  We can solve this with a configuration
> > step between region-probe and dax-probe.
> > 
> > Add the infrastructure for a two-stage driver binding for kmem-mode
> > dax regions. The cxl_dax_kmem_region driver probes cxl_sysram_region
> > devices and creates cxl_dax_region with dax_driver=kmem.
> > 
> > This creates an interposition step where users can configure policy.
> > 
> > Device hierarchy:
> >   region0 -> sysram_region0 -> dax_region0 -> dax0.0
> 
> This technically comes up in the devdax_region driver patch first, but I noticed it here
> so this is where I'm putting it:
> 
> I like the idea here, but the implementation is all off. Firstly, devm_cxl_add_sysram_region()
> is never called outside of sysram_region_driver::probe(), so I'm not sure how they ever get
> added to the system (same with devdax regions).
> 
> Second, there's this weird pattern of adding sub-region (sysram, devdax, etc.) devices being added
> inside of the sub-region driver probe. I would expect the devices are added then the probe function
> is called. 

I originally tried doing with region0/region_driver, but that design
pattern is also confusing - and it creates differently bad patterns.

    echo region0 > decoder0.0/create_ram_region   -> creates region0

    # Current pattern
    echo region > driver/region/probe  /* auto-region behavior */

    # region_driver attribute pattern
    echo "sysram" > region0/region_driver
    echo region0 > driver/region/probe   /* uses sysram region driver */

https://lore.kernel.org/linux-cxl/20260113202138.3021093-1-gourry@gourry.net/

Ira pointed out that this design makes the "implicit" design of the
driver worse.  The user doesn't actually know what driver is being used
under the hood - it just knows something is being used.

This at least makes it explicit which driver is being used - and splits
the uses-case logic up into discrete drivers (dax users don't have to
worry about sysram users breaking their stuff).

If it makes more sense, you could swap the ordering of the names

    echo region0 > region/bind
    echo region0 > region_sysram/bind
    echo region0 > region_daxdev/bind
    echo region0 > region_dax_kmem/bind
    echo region0 > region_pony/bind

--- 

The  underlying issue is that region::probe() is trying to be a
god-function for every possible use case, and hiding the use case
behind an attribute vs a driver is not good.

(also the default behavior for region::probe() in an otherwise
 unconfigured region is required for backwards compatibility)

> What I think should be going on here (and correct me if I'm wrong) is:
> 	1. a cxl_region device is added to the system
> 	2. cxl_region::probe() is called on said device (one in cxl/core/region.c)
> 	3. Said probe function figures out the device is a dax_region or whatever else and creates that type of region device
> 	(i.e. cxl_region::probe() -> device_add(&cxl_sysram_device))
> 	4. if the device's dax driver type is DAXDRV_DEVICE_TYPE it gets sent to the daxdev_region driver
> 	5a. if the device's dax driver type is DAXDRV_KMEM_TYPE it gets sent to the sysram_region driver which holds it until
> 	the online_type is set
> 	5b. Once the online_type is set, the device is forwarded to the dax_kmem_region driver? Not sure on this part
> 
> What seems to be happening is that the cxl_region is added, all of these region drivers try
> to bind to it since they all use the same device id (CXL_DEVICE_REGION) and the correct one is
> figured out by magic? I'm somewhat confused at this point :/.
> 

For auto-regions:
   region_probe() eats it and you get the default behavior.

For non-auto regions:
   create_x_region generates an un-configured region and fails to probe
   until the user commits it and probes it.

auto-regions are evil and should be discouraged.

~Gregory

