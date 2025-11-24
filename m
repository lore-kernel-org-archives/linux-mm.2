Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81972CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 11:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7D36B0026; Mon, 24 Nov 2025 06:23:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E836B009E; Mon, 24 Nov 2025 06:23:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB1D6B009F; Mon, 24 Nov 2025 06:23:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABFD96B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:23:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD4BA58615
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:23:45 +0000 (UTC)
X-FDA: 84145265610.22.D159B15
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06CE0C0002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:23:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Poa1wR6e;
	spf=pass (imf10.hostedemail.com: domain of smostafa@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763983424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/9qmpcn6sF8ptPObBDBMptCfIXtJ3l0IrBw1r6Q5lI=;
	b=4tLI8leLS4/f1Oo49Z/ICF6fGqdFkQiSzSZpDLmaRWr0K0zAHe2GFGqSEPECBgojcZHaC1
	Kv16wOAIbmf+zw9nGztwmdmUGjpW7SZ1mX4kBAX277FJpvxnj0F2EXxjGdReswAhaePy0R
	iod6tp5Yo8+FI6FRKyH5CZ/7/EjRsXc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Poa1wR6e;
	spf=pass (imf10.hostedemail.com: domain of smostafa@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763983424; a=rsa-sha256;
	cv=none;
	b=k7GGn4uO2/+xFG0IIKVPuNU7YNDbmYYmNOyd7T2Izu15bEdZjDUNcGtEVPc7bPzHRkXoKA
	TklciCF0sKiaejoQsDTCtcFwJUO13Cwj+LbEr2m9DxgD6WZKg5nuaECRwUjoIan8mbiRL3
	ce8uzmPKe84OZpk++enPf7bMnFA9U4g=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so95075e9.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763983422; x=1764588222; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A/9qmpcn6sF8ptPObBDBMptCfIXtJ3l0IrBw1r6Q5lI=;
        b=Poa1wR6e1xhEp4eorXhJpcaTdgIyEN9YWUUaOv+QqrGJFDDZZoiSTQ0Nh5sWvtZ5Rc
         jScCwyalQHs+MNwkYkOhDOTafgUFGLkyryxOikXc6OIhOBlDav0T+X2pSsk9v1ysCAD5
         AXRaZIo7kjFETT3CNwuK+FIH2WrGQnQ1eFI8myBt/1u/Y5Ndh2+PE0Cx/0i2NU5+LiWP
         z7oxl5XkQfbuiLToRQRNX+5hQ7oW4PeGq3WaM7MgS5tWqJ67m/cE+6SUM94YKVLZE+BL
         71PIkO/Vc01DNASD8XciQpHkOpuCtXlFjdpv612X5gRr5TAqtk0h7NqkI8LaPxPSB0Km
         FTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763983422; x=1764588222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A/9qmpcn6sF8ptPObBDBMptCfIXtJ3l0IrBw1r6Q5lI=;
        b=i3LP3fUxCImHLvcxXtB060LwNP9cYPRsMSmBxisDFOaeY4QbS+V8FZzbOmv/eksMgT
         k5+RSrBsiFy8Em138IVJEULYQz2icMhMURS7y0ym32QwU4bzC6S02Y3rQKI7mDEaGV4Q
         6Nbi23v7mxt4woap79GWfirp1TulIL73ep3qjaKp5uO3L3yNl3sBjEC10WqaLelP1Q51
         trk4pLqqTR96Cef8UWa53J2tWFZgil50vYfpHFs1AJEup4Hr67Ynhug7V4vV/8dfy+7b
         7061NB5+vGTgfcVUX8RZP11H3zf+/GX4gyklRPDdaCJ865k89xoyfzZt97jA8JRbgwou
         aB1w==
X-Gm-Message-State: AOJu0YyDCc8IYGnK37R/Tjsl5sUcHouwoBB+tk939BWBY2D0xO0iSLKv
	4spHgT1O8MQBr62mTj3VwZBU38UHGbAyE2MPmavsxHCxlH5JX4AUR/aZBx8sPq0BYQ==
X-Gm-Gg: ASbGnct49QoPR7NzKQeOVgb5vEYS+83fS0tvI7S6eVqKpssPCtUrJIyeDY7SXDSVqk2
	I/xgZEx9glsCGhY7aNdKkgOoVT5xJfQg6WYDMNCbkf73BsHm7H0qccm36Gwv0hD/uesO0l7eZyW
	2LsLf3J//uhBuPEyPHlXp0Rsyr8ie33pVOHbvo1mfQawKtMC0I17npyPDnirv/od6hR+EiMuEaf
	5p/qA5Ch3MpF0fMel8KzzBfTkYWCa5QRCyLFZjS3uMDOMfFMO6O3nlzrKxpdJSo+VCIRLK27L8P
	PHiN04GjkiClBlxpc5vs106RymJtRs8n34CYS2Z/1riXF6RAd3d1xIQqzTMnUFMgZy0f8nS+FMq
	nDg8/skYCljxv93KCFEKSV3oCdh/Rm/en7+DfiSZBRYFPGSHRkjate2WxHDkPKgx09bF5IeZ4hr
	dPBGMZCeHL8DDNkOJ1xvdiQdTjH978CZHINRTJzyu3UE6ZzMwpEQ==
X-Google-Smtp-Source: AGHT+IHPjRoPkJts63WSW1KmhvXOZnj4KJdKdrrFOfPPYFwb16nEkLhtHX2sQ0Em7vKdjEkEynh8tg==
X-Received: by 2002:a05:600c:3b94:b0:477:1afe:b962 with SMTP id 5b1f17b1804b1-477c5ea32a2mr1726485e9.1.1763983422303;
        Mon, 24 Nov 2025 03:23:42 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf198a67sm200937725e9.0.2025.11.24.03.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 03:23:41 -0800 (PST)
Date: Mon, 24 Nov 2025 11:23:38 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 2/4] drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aSRAOv6WqFTxzy_C@google.com>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-3-smostafa@google.com>
 <aRW6P7vhTIZvm2Qf@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRW6P7vhTIZvm2Qf@willie-the-truck>
X-Rspamd-Queue-Id: 06CE0C0002
X-Stat-Signature: 797rzzyyxxuem1jumgos7ikwt4ekzhxu
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763983423-168982
X-HE-Meta: U2FsdGVkX18PcpQbjn4CBF1IzlJt8Q49Ip6QObM6Hzfj+/XGfThxPTcXknfd1auXetMgZKTCrhaXxXgQCVeloxvZjxvb5AIhPA/Hjwek6t9L00XQ/VScHuVtlg7r0hcXaktWF6pAW2GOBDNmpGq7i3apSFZpvpCiDfXcSV1U/42J4iSptUwQiyINJitKFSQfR3nESepjexdQG0WmjU+KRogeG9OinNy95Gv5OjRXESIMy77oxyekrfBBxapeX8Dr9rq6yFPaCDAxt0sgHlz+JBKsgtMZ0xtR/BDM6u/fqb84uV2mMGR0Jtm7pHBoIwfBgqMGoSDYFY2Qww7bU8oHmrXfz+BNuWlZkebmMnus1M64BBFRVuCI57T0iVKlR+oz6jqSV2OOLsjZ2jYrqsedTD3PlNSiYPD8xIdXYDs7gtIoVVc9ru9X+UXq/lYveUgzHpf6iEIhf5p/i1Wl690qpR9K/qZ79dFS7c+u3U76Hy4EnRKxLQpN9aKrzOmvpf7/K3QARQ7SG0VjogKQFWOhtzxwwbdN5BqDraIfLEFWibeD/TV9oQi2PgoECDYkegYZu0g9LhCwND9bzSScQudo1CfUD8oQGh2KtRckLJbdnElg4B9O4Yrh+cefAaDZft/21l1FBlbqKFiCRsvkBpmKqp/qkJi7mopBfHcMOLfTidKVR27HeL1O9VyPBE99/V/AVN32746z//EuD3VarGnj/0DGsUVumEofvZJtz9ZIWnNXE7yDq3LibN6zHFdINPuG1YVow0A2RpVHhqskI7IyHAbkh+4khvHoGxIwJ/pSqACAUjwT5ryU6+BbFXEdwDuHLWGsDrJpNDjdETDso/rWV2bpAsdEDE3nZxq4sqHZVitiYYlKh3YiiKjlyVvAxewdbIiGCP+wXNiklHJzryQRPMg+yALZC1jMrDg2Ny/bVBsdrKK4b+zq33rO6IwD2R4IWYGDzp+MFY04kUjRbRp
 oi1QAOSz
 USsaG55IcFnJtSbse9a1Rx1v7NXglIvSmTCPPYNOzA7TKthx3yeEGdoOcHC5zsYEeRgRYkj/wu14OaJrRdY/l7oGRP+lYhGaKZMyRInKSZLugfvuhAc8W4kQAEXt65gPTmNQ8imekVFzW9HBfyKbDcj7XGmJ2gRKmAq3MflWa4O6vpLMJrTxmfQRsPQNZi+KRlwzSf5K4C3Meq+0YcGevGODEIYt9HftzphzBSSbumBe4mOGHngIMnkkPxFTaGfC7447wnAGuuwcDOYHHSWkcevWfkqRTHC8atHcfenCTaIm192wwqd+Zyr9kEh1swGzD/R2rUNHhwRv3GR1FmmvLlYTR8DlFOCYKY/kNlMc0CUPnFie4PlC6w8tdNpwCQEaKf5Lb+NI6o9EkKOSzfrlLUAbSqAFuj+NwZgRl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:00:15AM +0000, Will Deacon wrote:
> On Thu, Nov 06, 2025 at 04:39:51PM +0000, Mostafa Saleh wrote:
> > Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> > - iommu_debug_init: Enable the debug mode if configured by the user.
> > - iommu_debug_map: Track iommu pages mapped, using physical address.
> > - iommu_debug_unmap: Track iommu pages unmapped, using IO virtual
> >   address.
> > - iommu_debug_remap: Track iommu pages, already mapped using IOVA.
> > 
> > We have to do the unmap/remap as once pages are unmapped we lose the
> > information of the physical address.
> > This is racy, but the API is racy by construction as it uses refcounts
> > and doesn't attempt to lock/synchronize with the IOMMU API as that will
> > be costly, meaning that possibility of false negative exists.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> > ---
> >  drivers/iommu/iommu-debug-pagealloc.c | 23 ++++++++++++
> >  drivers/iommu/iommu.c                 | 14 ++++++-
> >  include/linux/iommu-debug-pagealloc.h | 54 +++++++++++++++++++++++++++
> >  3 files changed, 89 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> > index 385c8bfae02b..a6a2f844b09d 100644
> > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > @@ -5,11 +5,13 @@
> >   * IOMMU API debug page alloc sanitizer
> >   */
> >  #include <linux/atomic.h>
> > +#include <linux/iommu.h>
> >  #include <linux/iommu-debug-pagealloc.h>
> >  #include <linux/kernel.h>
> >  #include <linux/page_ext.h>
> >  
> >  static bool needed;
> > +DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
> >  
> >  struct iommu_debug_metadate {
> >  	atomic_t ref;
> > @@ -25,6 +27,27 @@ struct page_ext_operations page_iommu_debug_ops = {
> >  	.need = need_iommu_debug,
> >  };
> >  
> > +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> > +{
> > +}
> > +
> > +void __iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
> > +{
> > +}
> > +
> > +void __iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
> > +{
> > +}
> 
> Since the IOMMU API doesn't really have a "remap" operation, I wonder
> whether it would be clearer to have unmap_begin() and unmap_end()
> functions instead? You'd probably want to call them as a pair, so the
> check for unmapped < size would move into unmap_end().

I guess that would be cleaner, but we have to pass both size and
unmapped to unmap_end, I will give it a try.

Thanks,
Mostafa

> 
> Will

