Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB60C9EC95
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314396B008C; Mon, 12 Jan 2026 09:37:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC166B0092; Mon, 12 Jan 2026 09:37:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB226B0093; Mon, 12 Jan 2026 09:37:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDB36B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:37:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1CDF140345
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:37:26 +0000 (UTC)
X-FDA: 84323564892.08.A2F4982
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 11FC320004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:37:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bz9TL5t+;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768228645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePKfg8r3UOwlhimXXZYjI2/ALy+81ziytf6AS2OBizc=;
	b=FBpD9szwvmeELYYz04H3A5BiZtkY4OzKLgT7MKSGh3wOnqur8QBsdSo2AVxeLttNkkDdmI
	ERn4d7PXPlGWARDSW/m2UJdoDGTweRWjDA5x3nbgJlzb06f0/Vlf3HD76MsVA1YG+V0iCN
	lazhGQymZk1HKb4maghmKQCed0t8F1Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bz9TL5t+;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768228645; a=rsa-sha256;
	cv=none;
	b=62htFIl+yxZHQTM8mf6TOa2NK9cx4FxSGpJfQan/iM4Fmb4tEVzHbMlOKO9Ti97icpw1+0
	4hAXGg1HuYQ/NTmWTCJcmMcVCVfTYv5LklFw3UJSdAw5Q3YImgizJuyHKQ3FQTv1GFMq9v
	sQxxA5lb4WOtJooqZiYYKV7u6aqCnFQ=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4edb6e678ddso103086591cf.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768228644; x=1768833444; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ePKfg8r3UOwlhimXXZYjI2/ALy+81ziytf6AS2OBizc=;
        b=bz9TL5t+MkK8rI/Xizwpyq98SuC7mdp1iK+LPnhTb5lJBQWPQeJEcObFCsEbHd66ZQ
         gK5xLlupruJgDEGe08LrRAffJE9d9MXKTgv8BrqRAj/7IE1nKBzd/XM8Mr1cvF6flGtZ
         A2nv0kVp/9addt77zfK53/u2hERv74X8kQKF/KLXc7b+nTZrA97QdmtSledaVK7++1hr
         4wiYwWyXB4erpf3funV6EElXn3eETcPVZV/BSGWaVdpmF+B4bAzpWFPt77HxbHUAGcgC
         KpQUtV1beCjISnokz5nE0s+rFAyp9xQRBWUvCjfQzb/o6NoOBBecNxHNw5NJMgNhAlUF
         CiVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768228644; x=1768833444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ePKfg8r3UOwlhimXXZYjI2/ALy+81ziytf6AS2OBizc=;
        b=fnOZsxhoOZu3XGDWci1Ad1WxqDBiKSNo90xC5kHIegAT/yPyyIIuvR8zWbfMKErgPG
         lC6v3TjtE3mpHe+tbz/ctO/Nrhh7ALMho9GtaaaVpaT750qFJ3kVsAymBPi488VnpHa5
         TtM/oJJ1/gC1UACSTRM5CwENEdfOeejm07+N4pQc2RSXSid207zN/aA2E65htfqQ+Etx
         Gp0VHIFwFTKhFUIO28gr/exYyZYI2Hff6Ycjfd1IrWEG0B8nuk3e6wjtUtqmI8a6nDDo
         R/m0ewHkYAlglB/3XKIWK2ijFq3Od1uY2vB2zw4NAsXMXEtCBzajjsyXtFwYOnjuVHjL
         fANA==
X-Gm-Message-State: AOJu0YwiWABCi8hszP6Quy9hV9mvKAjzgcJxASXqDTSdz81P7ZMxrkkQ
	SkHE+DkH6KkzsbjCCXcN3yHo02ET7vfwjNP8yIXsIbxEN8Uh/SVxA+i4rE/VLsAJCFk=
X-Gm-Gg: AY/fxX5cDQfTMmXbDI48Roiz3UXT1EqebE2ShLlXYRomzawylpK9REyVNbGABE8Y832
	sIFyrDNRHWqg9mDt7pv9OAVA+Rq63QfUDKGqi/aDE9ifdD+22ExSSCfn0NeFdFSIGbFXkwMCuo0
	Pvs/Gr1rKLFnBu9VzdafXQcgZMrxZEwj8OCjwAihatX8XH67WCA4dRl0iWUlR96TgVq6fQqhK5v
	GftgxQ+TQXnAzAJKm4Qrwh8zfoGIrYh3FarlIqHcB77rGks9bFyu0+5/CBl3FQKB2nV450RycQD
	46jNeJdw2z3pYa91y+7oi7gRhzHAJ+SITJtfZ8MPkiDt7DCJoa0NYzavqUR4/m2zlFGdY+5vlsd
	UqHshpwfGU2H+jukmbCACxqGUyx0D2hAiy16sWd0x0iXsUL/C3Ke/vZTeNvFduf7c4b3CoIJfhY
	GK0MU5HaS1KqnscF1qu4W4qE58BfuWPl6jhUCzj3yA2PHiih/k7ZumE3vfv1s3qHdtAtTbIg==
X-Google-Smtp-Source: AGHT+IHXS0x+KAi7JkxeJVuKKA6eSdMX4OQRz9CBqWxcGn/3UsudeSIPdlLgVjLY1N5m+ySFWtfoOg==
X-Received: by 2002:ac8:5a04:0:b0:4f4:d926:d64b with SMTP id d75a77b69052e-4ffb497b9d1mr281980781cf.48.1768228643971;
        Mon, 12 Jan 2026 06:37:23 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8e3629dsm125755621cf.18.2026.01.12.06.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:37:23 -0800 (PST)
Date: Mon, 12 Jan 2026 09:36:49 -0500
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
Message-ID: <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <6604d787-1744-4acf-80c0-e428fee1677e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6604d787-1744-4acf-80c0-e428fee1677e@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 11FC320004
X-Stat-Signature: g71btz4qmjeorxqfhzd8tm6b9mz4xau3
X-HE-Tag: 1768228644-650416
X-HE-Meta: U2FsdGVkX1+lzOiUQdMWv2UCzQDIhdRK1qmIiczU2UTEAcErSwIfPCdNTTPqvcyzONFZ4wBIsF7K7uEx0tIar1QenBFfogvQah/W0FJn3C66sXhvny06yryjBIAeVInLVO/zeIQizVKVJyGxaRX1bEnijID/DHG2I4/564ROWIDpH9IszM7ak11NHFyxJSa3iYbiP9aXYn3riKqXOBDkkcpvwYY6cmev5C9sN4ckimZyhORRll0njFGR+TfQ7ANhoMXhEeJBzAJNDTWadh1KA3S/V6+T4gxfQsISp6LnA6lgguQuZDXisYb6kvpDXCN8O6TyB7NnxGJZoXf8mgPoFhFLi1tpdXHy2aRHtsHAXvscEvUbgV4ZRDPU88+NK1N77kfsOAjha0tmmRo58diFgvcD2EWkVODAAj8OOV19cl6Op7tqfYClGaAhRH0kpbqGZQoEwm0RqT3HkQZBMjcC7tzsxI200al/BXFPQr0BLaCuKv+cYZz5lSEkLUNn9NrCjVzQFonYDz1Ih/e0WgOp9FiBYE3AJnYkyPbl+i2F6MyOXt2Wzi8uYz7G6AJgkT138tEWHG9mPlLeVj8qEu/q5SUy6WsrUWgVOfj70LxjVVAT1zxzEqbcuxK28IGcG7NOoiq693uiLuhdY1m8Bs50GMxWGL7XwfIzVJOdfSB8iEZ9AAcJABL6wlFMqPzfkwNPGJKoF3ii0pv1cm/eiPwyzVv9i3NUrZ7D0tsuTaWRhNYeiuT5fBYlbKT/F5nmPBF6yXKdD47eRl072JmJnEOKBdHHaz6Lq6PzojzmPFSrEnDk3s9L2IYsG0VDGHgykoSlaoYTV9I2+0wc6sqsDnmcC+UAljDud3laM0x/fTaVTDExUVZVoNPjvvDCX5av6EdOGsDA1lGxD6Eju102/mkh6vwDajFbxom/1PQBxsKQh+QfRJIqLEGp9zUwQxJSU66c6O+YyQ9luqjEoJqMS1h
 7X3rH8ZE
 hEEFol2xFd+PdyRYEj1uFqBxptlb15TeAqkasjFDy1ZyYrspLfkz4CLswWlbvawqvvCNm7RXj0b23/buIH6KHoARypQ12qz5eermzKWNbRamv/g+lFCxxfrg8UP1vcPtru5fOqwwC8jheElCVV1xea0AjtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 10:12:23PM +1100, Balbir Singh wrote:
> On 1/9/26 06:37, Gregory Price wrote:
> > This series introduces N_PRIVATE, a new node state for memory nodes 
> > whose memory is not intended for general system consumption.  Today,
> > device drivers (CXL, accelerators, etc.) hotplug their memory to access
> > mm/ services like page allocation and reclaim, but this exposes general
> > workloads to memory with different characteristics and reliability
> > guarantees than system RAM.
> > 
> > N_PRIVATE provides isolation by default while enabling explicit access
> > via __GFP_THISNODE for subsystems that understand how to manage these
> > specialized memory regions.
> > 
> 
> I assume each class of N_PRIVATE is a separate set of NUMA nodes, these
> could be real or virtual memory nodes?
>

This has the the topic of a long, long discussion on the CXL discord -
how do we get extra nodes if we intend to make HPA space flexibly
configurable by "intended use".

tl;dr:  open to discussion.  As of right now, there's no way (that I
know of) to allocate additional NUMA nodes at boot without having some
indication that one is needed in the ACPI table (srat touches a PXM, or
CEDT defines a region not present in SRAT).

Best idea we have right now is to have a build config that reserves some
extra nodes which can be used later (they're in N_POSSIBLE but otherwise
not used by anything).

> > Design
> > ======
> > 
> > The series introduces:
> > 
> >   1. N_PRIVATE node state (mutually exclusive with N_MEMORY)
> 
> We should call it N_PRIVATE_MEMORY
>

Dan Williams convinced me to go with N_PRIVATE, but this is really a
bikeshed topic - we could call it N_BOBERT until we find consensus.

> > 
> >   enum private_memtype {
> >       NODE_MEM_NOTYPE,      /* No type assigned (invalid state) */
> >       NODE_MEM_ZSWAP,       /* Swap compression target */
> >       NODE_MEM_COMPRESSED,  /* General compressed RAM */
> >       NODE_MEM_ACCELERATOR, /* Accelerator-attached memory */
> >       NODE_MEM_DEMOTE_ONLY, /* Memory-tier demotion target only */
> >       NODE_MAX_MEMTYPE,
> >   };
> > 
> > These types serve as policy hints for subsystems:
> > 
> 
> Do these nodes have fallback(s)? Are these nodes prone to OOM when memory is exhausted
> in one class of N_PRIVATE node(s)?
> 

Right now, these nodes do not have fallbacks, and even if they did the
use of __GFP_THISNODE would prevent this.  That's intended.

In theory you could have nodes of similar types fall back to each other,
but that feels like increased complexity for questionable value.  The
service requested __GFP_THISNODE should be aware that it needs to manage
fallback.

> 
> What about page cache allocation form these nodes? Since default allocations
> never use them, a file system would need to do additional work to allocate
> on them, if there was ever a desire to use them. 

Yes, in-fact that is the intent.  Anything requesting memory from these
nodes would need to be aware of how to manage them.

Similar to ZONE_DEVICE memory - which is wholly unmanaged by the page
allocator.  There's potential for re-using some of the ZONE_DEVICE or
HMM callback infrastructure to implement the callbacks for N_PRIVATE
instead of re-inventing it.

> Would memory
> migration would work between N_PRIVATE and N_MEMORY using move_pages()?
> 

N_PRIVATE -> N_MEMORY would probably be easy and trivial, but could also
be a controllable bit.

A side-discussion not present in these notes has been whether memtype
should be an enum or a bitfield.

N_MEMORY -> N_PRIVATE via migrate.c would probably require some changes
to migration_target_control and the alloc callback (in vmscan.c, see
alloc_migrate_folio) would need to be N_PRIVATE aware.


Thanks for taking a look,
~Gregory

