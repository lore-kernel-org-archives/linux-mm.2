Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC0E3CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373B08E0071; Wed, 29 Oct 2025 10:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323F48E0045; Wed, 29 Oct 2025 10:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AB28E0071; Wed, 29 Oct 2025 10:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12A628E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:23:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0BB41A0782
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:23:03 +0000 (UTC)
X-FDA: 84051368646.12.9DD7ED3
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id A1651C0006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:23:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W2Lel0Pw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of smostafa@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761747781; a=rsa-sha256;
	cv=none;
	b=cS1XJRAdlBwsTx7SF5n4tZcfr1DG1zvRFrEPFABHrxOG0KxF6N4J1/f1bG7R5H9HZyZFnG
	4chvMAteMaD7G5oXhIRllEZ8IZfKp10Ho8ayNNn+LiilxIghEOlLCUdEtJR4HMHB2aoJ/i
	5FW4jVMsYNb3awvB2PmIA8E4is6MchE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=W2Lel0Pw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of smostafa@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761747781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3X8rEfNOS8L5ftWnixKzPLC44IltEKPSF05+QvLhNoU=;
	b=kvM38qwbWN4vlLZ0pxstEOI/plyxurF3SQOTHmga7xpWqX27BG6qDe51OMi3aC2b6vA9rv
	HtP5g84wgBThlENbTJFlVo0nS7tdgduii8jaiCieTKikcG9luRXO5W+k2bW81TinMMloSj
	WnhjZftnAXwS++wkOFgI9FOFnBgBeTQ=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-587bdad8919so10642e87.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761747780; x=1762352580; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3X8rEfNOS8L5ftWnixKzPLC44IltEKPSF05+QvLhNoU=;
        b=W2Lel0PwpBphnXuOKkxX4DJ3fNdWY6qtg4XMye5l12PH2vlPQYf5qwz4+Yq7EPoRY7
         9d0JVSRHbisuJ/5drMw0fRrhJSt84czXN3aSpfvy9AgNyBj2eC9SG4g5y7XzEdbkOMew
         vCxMy/qOa++4gjm6vt4uHdRebe5l8VNLxzAh4UEsI8luVpwn0Qksx5PkBToTdevOaSnR
         obdXTrykdKzGFK2xBSJmtYKb+HYHQ+oplpd2FefENwWAoJvSlFXiiUTeSwEqNOj/UZlG
         H3lZP8A6n2D+Hi1xK3YKXmEA/5fK410mxULHAoUWwaHyJ2DddIMreSGBw3ZZhsi5YoQw
         Ykow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761747780; x=1762352580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3X8rEfNOS8L5ftWnixKzPLC44IltEKPSF05+QvLhNoU=;
        b=gfL3WypxMQdIZ3cKnRIX4XZHWR6dAF30kFTofdiRdzbhp+H06or1mB6UTSWJZRllwo
         IemtWM3xoObLBjBXk6JAmJhxad0LGDs2J54bmx2KfAZTomWGvtlt//8RDEOCrrgSCRA/
         okBcm/n9By9eRM/S8yfHTcw8BRMww7eS7ivjKZieXaL8cLUI8hQuNpxTJ5rVggiddtXi
         qeEBvfnbAzc/ifAF+aFMASGXEiZxsWXDBpTAgzH2zN4wMdAbH/Z3kLHAvx+HwvzSg5nC
         MdL/8KxTXBb6IRSRzOfyOrX+Qu4mP7ewi7uXdaYsoBg5gvUX38DD4ZNYTgbv1k4eqfgK
         8oFA==
X-Gm-Message-State: AOJu0YxfAKp2BQrNBLnRYwpuaEGB6UunvHR1ii5S7wM48SHD+63I9tjv
	KVG3WG/LDCN5ZaaJstCx9Ekg5tU2rJ7s4liwa3aIyvC7nKAgXHYI5Z9PrLiKMrZKAg==
X-Gm-Gg: ASbGnctCZqpIbGGLyBAWd2KdXk3apfbxDcTysSH8LPy98bGkYeqk8A8ujLVTe2f/HbV
	1b//tnerxVljBhl4r+CdHUGtlzlA5/o7jeFICOWo2SXNAhsurRfhizqr7bEKqsYZCCjnuEJmnNC
	VPibJWICtatXI3TspGk4L0qLKzOwObIaVSPtdjXeFqR0aw+fCV/0of2+jP/e+BHhOq1DSibVskJ
	BxJa7O+KjwTqXQ1pTI0ulRboE5bcSMyZ7jOZNHft14Qydyo/IGVxBLaWhRXYEst5LzIsrGPdUwc
	K0cVJcJJUEoeMbjYWJ6YMbaY/HRaQythQpl0GNVRRaRVKdHbKfAi1UcUVBbaTquGNhMZUeQBB/P
	cRMd8MPDHMNl9UnKXSuUtdIGAoYMVgaBVTr6nB933sQO7wfU6jFPGJ5gT3f5khfGZJxmFYI6PMq
	G9TTWVW4IHzll4tx2oeTlu0b81UmnCh9xsuP3oNfg=
X-Google-Smtp-Source: AGHT+IHqpmvhmNQeMUwlxSx22ePgHZKELB9fYGyYcpwDmvfoTwWjtRpntwXiEd4wY5k8KEzx24Mb0A==
X-Received: by 2002:ac2:5fd0:0:b0:57e:b289:c64a with SMTP id 2adb3069b0e04-59412a39f9emr279787e87.6.1761747779360;
        Wed, 29 Oct 2025 07:22:59 -0700 (PDT)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d5678sm26187265f8f.22.2025.10.29.07.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:22:58 -0700 (PDT)
Date: Wed, 29 Oct 2025 14:22:55 +0000
From: Mostafa Saleh <smostafa@google.com>
To: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org
Subject: Re: [RFC PATCH 2/4] drivers/iommu: Add calls for iommu debug
Message-ID: <aQIjP3jVigyz8t38@google.com>
References: <20251003173229.1533640-1-smostafa@google.com>
 <20251003173229.1533640-3-smostafa@google.com>
 <hu7ozrdn6la24apa4pco5nkhow2dmthahjomjj6hy4nrefx6j4@lcdfbykoafw4>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <hu7ozrdn6la24apa4pco5nkhow2dmthahjomjj6hy4nrefx6j4@lcdfbykoafw4>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A1651C0006
X-Stat-Signature: 5m13d78qge4p1mkiko3q5h36w9kiksof
X-HE-Tag: 1761747781-120715
X-HE-Meta: U2FsdGVkX1+iJi1AmFBbSiHsWiPcZKn6WWS/28Vjeh2e8FXzXgWdMNe2rRWKEyIxWUWWomn/yf0yq1zbUy6sTYkXlgFtjIgC7d9oXFP5q/dyUD7d8LrhmtD7pz/arDdw+w6bpGemsP21Mc3FxibTla4+kFMXnMypDaqyxLpMyFTKLLTZp/MpWIYnop8Mvw1blRtnYNM2uo2nf1zD2bkS8rURpeFzU+x66upFgi5+UpfM1XpY3HGXeJtiw7E3OhTZ9GCpdqyPd9GM9T2KOC88eUGcOIZO0WRrHchAySWFgBeK6UPIjZa4YoyhMVWhIAcLDELnmY/ZCPRkbAmGlntRp48wgx3Ek//sDGygDwRbxjRjQU8iHJRh+gm6/Py/yOEMD9wnTGIceXKp/Iay0HuvsRurNzIcwULAjaHzbZgsxDDrHSHPY/faSL/KsdQCakQWGbrj06VbtbEynbBwAKzCOShwnXZT/7k+L090fRGgwjTWeWUpb1+7NGMA7j0UMRNmTCoHLCTnfHNWGjYrkv2s0GwhyzaQQGZOMIkLWT2V8HSZ9NhP2m9vnIRZJw5msGRonhbI2VkBqBVedOWoZD2yAhfOCE5hcEYMqzRHbWHR0zss585UGEKq2IkMQmobiNLVLPwZNd8V8H4ZH6kRoS7qVheRyDmR5AT5UtQqWqbw5XoV/uT1sx/4vY4mO8xaXoGOHCfdqe11qSG4HlHJ/AZiEJXgF7gUEW7+StZ96QdNekzG9yUWa0MCKqQnBcdn+oSIzMatNdB6XVjMoCbjOu2gPk/XgGxP5iGuhdeU8IfbMWglhpF2uvCnLLsxGJcFkDKEozbBhFe+R+KuzSFuytqzkBau7IRrLYD5SMoaI+K7FiC0b0LGF08oFuCsZlnvlFh/EN+lNBX3mmYfZ217D5m/Ml62lwppoIFdZ+F4UmlqEV8eqn5m1AhLX3RkqqlOsWHN59REUx/ZObnURcseop9
 3Y3ZkRrQ
 q9m22h4xB6vkKnupRSMHHKB4P+NYn9B400k8b3+z8hdZnaa5DU1lx9vecSgaTcpo0w7AvlucvdQLH6c7hDYM57XKcBk9Ywy+LP6IQRDD7iqwKu+YZ1AVvrEApn9+9/UZsu0ls4/xOVjO0iQc+ccrzOoRY9xkdU4IPnK5az5E3sfUEUyOWnB0sfIYCjAG/zzxBA1q7xThO7aKTmaQlouZiPgh+prf35FGuSwGDe0kT4TGD5nuAwtyc1lBsvJTRY2dqzp+r6rrD0ZrPQFI7kBKNhuWVA4BP/SxygqLjCgPNKJ9m3wUgxS/GIKUp77yjbqUZbGP664SJeuzKkS0zuNVOw+TjcGHE4x3xeMndMgu8gwKIvsDxO6dqSbgIFkEG+6XkPqtvcHDk+YvCQnAQ6WTa7c+lUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 12:43:06PM +0100, Jörg Rödel wrote:
> On Fri, Oct 03, 2025 at 05:32:27PM +0000, Mostafa Saleh wrote:
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
> > ---
> >  drivers/iommu/iommu-debug.c | 23 +++++++++++++++++++++++
> >  drivers/iommu/iommu.c       | 21 +++++++++++++++++++--
> >  include/linux/iommu-debug.h |  6 ++++++
> >  3 files changed, 48 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iommu/iommu-debug.c b/drivers/iommu/iommu-debug.c
> > index 297a35137b38..607f1fcf2235 100644
> > --- a/drivers/iommu/iommu-debug.c
> > +++ b/drivers/iommu/iommu-debug.c
> > @@ -5,11 +5,13 @@
> >   * IOMMU API santaizers and debug
> >   */
> >  #include <linux/atomic.h>
> > +#include <linux/iommu.h>
> >  #include <linux/iommu-debug.h>
> >  #include <linux/kernel.h>
> >  #include <linux/page_ext.h>
> >  
> >  static bool needed;
> > +static DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
> >  
> >  struct iommu_debug_metadate {
> >  	atomic_t ref;
> > @@ -25,6 +27,27 @@ struct page_ext_operations page_iommu_debug_ops = {
> >  	.need = need_iommu_debug,
> >  };
> >  
> > +void iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> > +{
> > +}
> > +
> > +void iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
> > +{
> > +}
> > +
> > +void iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
> > +{
> > +}
> > +
> > +void iommu_debug_init(void)
> > +{
> > +	if (!needed)
> > +		return;
> > +
> > +	pr_info("iommu: Debugging page allocations, expect overhead or disable iommu.debug_pagealloc");
> > +	static_branch_enable(&iommu_debug_initialized);
> > +}
> > +
> >  static int __init iommu_debug_pagealloc(char *str)
> >  {
> >  	return kstrtobool(str, &needed);
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index 060ebe330ee1..56c89636a33c 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/errno.h>
> >  #include <linux/host1x_context_bus.h>
> >  #include <linux/iommu.h>
> > +#include <linux/iommu-debug.h>
> >  #include <linux/iommufd.h>
> >  #include <linux/idr.h>
> >  #include <linux/err.h>
> > @@ -231,6 +232,9 @@ static int __init iommu_subsys_init(void)
> >  	if (!nb)
> >  		return -ENOMEM;
> >  
> > +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> > +	iommu_debug_init();
> > +#endif
> >  	for (int i = 0; i < ARRAY_SIZE(iommu_buses); i++) {
> >  		nb[i].notifier_call = iommu_bus_notifier;
> >  		bus_register_notifier(iommu_buses[i], &nb[i]);
> > @@ -2518,10 +2522,14 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> >  	}
> >  
> >  	/* unroll mapping in case something went wrong */
> > -	if (ret)
> > +	if (ret) {
> >  		iommu_unmap(domain, orig_iova, orig_size - size);
> > -	else
> > +	} else {
> >  		trace_map(orig_iova, orig_paddr, orig_size);
> > +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> > +		iommu_debug_map(domain, orig_paddr, orig_size);
> > +#endif
> 
> These #ifdefs need to be in a header file, not the actual source code.

I will fix it in v2.

Thanks,
Mostafa

> 

