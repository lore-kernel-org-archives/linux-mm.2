Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3342D59D84
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 18:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F496B0007; Fri, 12 Dec 2025 13:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A386B0008; Fri, 12 Dec 2025 13:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8876B000A; Fri, 12 Dec 2025 13:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0E006B0007
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:44:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F548B6E21
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:44:18 +0000 (UTC)
X-FDA: 84211694196.14.0C675AB
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id C9D3310000E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:44:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zQhW9SLM;
	spf=pass (imf14.hostedemail.com: domain of smostafa@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765565056; a=rsa-sha256;
	cv=none;
	b=zpy0EMiVp88nq55IFiGMaMDqA8gBDQrFP4xlDYStqWkY30RqrFa7VpTQ7K7u+tTjvactlG
	cdZAOP1qn/v5Ar2c12qsdqWFEme2iQkTmXypaigs3+48atJUyzCkcH6/1AEY/KfmiCjhkU
	vmX/T1bXTUKsGUkeHaICznPC7b83PPk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zQhW9SLM;
	spf=pass (imf14.hostedemail.com: domain of smostafa@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765565056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZ+zh4+qr/HN6w+u7QW254+tODE+L4KOJGO5KT43g/s=;
	b=grUS7ttHrRyj/WHmeIIXINcrqxFGWODtxDoIwSfmcex3LimdXzWUg1trJ4OeaXvGDoDKJV
	dJ1AnCq67NLvkO9fzebg0R/tmEsR7108WUYeQt3uaF+PmormyvEYhXYip6vyE9Jg7xGzVL
	HKWf99JibK0utMkrFyv8HH8X2sCVefI=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477a1c8cc47so181835e9.0
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765565055; x=1766169855; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tZ+zh4+qr/HN6w+u7QW254+tODE+L4KOJGO5KT43g/s=;
        b=zQhW9SLM1IgbCNNfTxNmahIrtNUGtrUXT0BudBK3gaWtIurSsLI7vqvJ6+7K+z/jfE
         cip3BEVB9F59lSnzl0YRFoBWYKecjvisqA0qao5Pm0DHJPLlQMp4XWYJWV0VBFis+Ykn
         A+xY5ZeBItRxItbJ2bam/3iJbXTVzRpifVfp2p8KkvKCvIvwdlBDm+JVTyOEU01agdiG
         OB1+Neozgo3oZLi9yIyUNBSgd3yC2aGaLiflWED4zBfDXClhKv8KoifFJSzJfPIhdVN8
         7wwbdTkOaxhC7+lT80XgTOVUTf3FU5tlQqY4bXrQUreYQBdZWxYggJtR0iYHSH/qNkz/
         MSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765565055; x=1766169855;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZ+zh4+qr/HN6w+u7QW254+tODE+L4KOJGO5KT43g/s=;
        b=mSQhhXQlRDcUzkB1ILOSJU+5LBCxDVx3vReroudg65pLOSWRpU0IoqjK7XqufLDp+k
         dkjPdyB2QkUiEq7LR0qIStnKVSnBr/urJ9EYNx+ne1thM6/H+s8mN5fuCWigKFmKqNbI
         rY1r0MNZT6DriDIs9uD5M4hJI8O8A1XUVH7Een6GVftgKlubXcf7q+H9npiEObuwF5LP
         kcHE6IlDmFQHUD0PkEFRSyV/60qKPj315H7Sa0J8QJBLYHVLQJ1O9+cy6+aOkjXY1iUW
         yz3pvCNH8n5bHP+ZeB6FmeHzOWMmPf+pKiD+ZGtGQmCVH6JoCWux/1nMsYS8gTFLLtm4
         LePw==
X-Gm-Message-State: AOJu0YzLZYSh9iAAKTZgjKDy7kU7y2MtSB0LmtOETrwKH1xeVG+4pwKk
	W2CerKQekJT6clkd5TGU6rBqMf2jjxpA1Iq0SUskWUEpWYpbTvep/tSezmK4wgYrfA==
X-Gm-Gg: AY/fxX4pMjZ3N/9GNV1qzbcQ9uKumK4T5pVlelnkYayqCpYN10xPCoxbgttTg7eaoOg
	jUtbS0sGASP81CeNGJxc/Qwu2WILzgDsfmMFkdkcJGHVI3PIzgCzIdtjfsY/Shie71eDpEQpzQ2
	IZfq49Q20QshpkJV13ES7ama5EBRd0TM91k+V9dWOV1CD/O3VBqMU3oVUHPWipZhZ9rhHFeBh4V
	+KbFr8MVGb3SoJoxKnVvL+PliN670ub3cLhvXP8kGEyr1XFKFu7Mz+8unTVTbmJZbtNjvYASfCe
	3zZ3ctnIs3Ph1y1tsiacG88wMAjeZOe4NhkkTYRYmRoU7E9yX4qiF2H5kx3d1eWHCd7rpz5sHtz
	9I8USodyc3TS368q10qYYuz7KUnBkZZyUJFp6qc/GScrekXIcvdSR5AAlRRSXrPfhC3jSSZpPyG
	wDSKQU5geRqRPM4d2yYOES/o5k5Ubh8yZS3dh+7SqKIbUYuhC6EA==
X-Google-Smtp-Source: AGHT+IHGvjVZJ6nOuRdDb1gX2OZv9LSRuh0+95/zqQtd/9rPsVw68PVqoRCbVL9lWG9KXK+ZBoktwg==
X-Received: by 2002:a05:600c:2195:b0:477:b358:d7a9 with SMTP id 5b1f17b1804b1-47a948f6e81mr4845e9.17.1765565055030;
        Fri, 12 Dec 2025 10:44:15 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f4b516bsm18335255e9.2.2025.12.12.10.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 10:44:13 -0800 (PST)
Date: Fri, 12 Dec 2025 18:44:09 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	rdunlap@infradead.org
Subject: Re: [PATCH v4 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
Message-ID: <aTxiefxT08hbUPsd@google.com>
References: <20251211125928.3258905-1-smostafa@google.com>
 <20251211125928.3258905-3-smostafa@google.com>
 <20e015d7-cb54-4a2a-bf62-a828e10e3126@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20e015d7-cb54-4a2a-bf62-a828e10e3126@linux.intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C9D3310000E
X-Rspamd-Server: rspam04
X-Stat-Signature: mnws5o378btzn1qk1gaxr6yibq17go4k
X-HE-Tag: 1765565056-275537
X-HE-Meta: U2FsdGVkX1/D0NzF3B1ia4dBL07wAxAW3rLeRZoztanbE1bv5fNfw77sgoYKEC322POYu8ZIp53KmNVRH1B9ovH0l5mKS0vhiZgOrN32HqGYrEPnyw/ZTEvEqsPcIgU/rFcQeXWrNsm2yrnKHe0tusWPz3AD/bPYiUz8MFNE+ESfJup4bErecgOCrkJHWbADiFA38AxMNqwoRxxAW8o1LG6isuEilG9/mYT178EgLbOmHXL0ZP6QNYqyxFb3W+3dRcQuVqF0WOqPRPUF7ztYcVIH1V5TkZ76feT/3e3sraJo4CTiNO0oil2IrY/TAyPA9JSYdSmqeh2IHiphaF8uuFTiq7XG8d6MtB14ATxg3Oe+MbmtFbK767yFF16eJNGjVkI0OuN/zh11C/WeLPNAKcwT+8mk8Jp8W8/fOm3u4P8utYw64EFwohTUqufhdn9YT0u777vEdNR0qSW8IWb5Zop6n1qzrwA3wejmjZZjzjUvKao/zoNoGRCwCkW1lpjPP+4T5ZCdjPzV3hkwUsN/GwvBkK7YEH4b+Ik7ItZr5UnW4435/nalis010JP1x3YBbWF8Opzz2eBcuqxxTsKFzg/fJhtprB4UYFit37IZ/lPpASFh+GIJMp5Jd8q6262GHXIhazKKpbnZmsj+wKIZCsqhOe2EfpPki5prRO2DLD/3uc6MseiIoI0WZi6cHQbjTPJyDBcIA5qS8gNFnBDgOc46JjZG/CkGEUDxfT8r2GY024LD91n9ujw+511LTgVyHPURsEBJGK4hayExEgvdq7lSDpjjdkIvLEaS0ArWk8HnLh5+Qutat7s30W8LUpFdt3nII9C49qeZOhpeShAz6Ajar6A+tIbmGWa6rV543DYVJIlerp7qh/bXIcnGg3a4tuCAka5DrE28EXB9gve8Z1A4q3a5LCuf6qQzZhnBbAEqnSIQiBIA0DVwHlZ/1La07Ahetdm3EeAqMZJNNnK
 UpdMvPQO
 YiqUIMTpU3ldQEK4HUSgAGiS0I16LgZ4asUb6KkzY84015+PsyzDNDnC0QxltFTPwwm7bH870wvUXtzh7zCiUKjoqKExOC9FLU429
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 10:33:20AM +0800, Baolu Lu wrote:
> On 12/11/25 20:59, Mostafa Saleh wrote:
> > Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> > - iommu_debug_init: Enable the debug mode if configured by the user.
> > - iommu_debug_map: Track iommu pages mapped, using physical address.
> > - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
> >    IOVA and size.
> > - iommu_debug_unmap_end: Track the end of unmap operation, passing the
> >    actual unmapped size versus the tracked one at unmap_begin.
> > 
> > We have to do the unmap_begin/end as once pages are unmapped we lose
> > the information of the physical address.
> > This is racy, but the API is racy by construction as it uses refcounts
> > and doesn't attempt to lock/synchronize with the IOMMU API as that will
> > be costly, meaning that possibility of false negative exists.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >   drivers/iommu/iommu-debug-pagealloc.c | 28 +++++++++++++
> >   drivers/iommu/iommu-priv.h            | 58 +++++++++++++++++++++++++++
> >   drivers/iommu/iommu.c                 | 11 ++++-
> >   include/linux/iommu-debug-pagealloc.h |  1 +
> >   4 files changed, 96 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> > index 4022e9af7f27..1d343421da98 100644
> > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > @@ -5,11 +5,15 @@
> >    * IOMMU API debug page alloc sanitizer
> >    */
> >   #include <linux/atomic.h>
> > +#include <linux/iommu.h>
> >   #include <linux/iommu-debug-pagealloc.h>
> >   #include <linux/kernel.h>
> >   #include <linux/page_ext.h>
> > +#include "iommu-priv.h"
> > +
> >   static bool needed;
> > +DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
> >   struct iommu_debug_metadata {
> >   	atomic_t ref;
> > @@ -25,6 +29,30 @@ struct page_ext_operations page_iommu_debug_ops = {
> >   	.need = need_iommu_debug,
> >   };
> > +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> > +{
> > +}
> > +
> > +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> > +			       unsigned long iova, size_t size)
> > +{
> > +}
> > +
> > +void __iommu_debug_unmap_end(struct iommu_domain *domain,
> > +			     unsigned long iova, size_t size,
> > +			     size_t unmapped)
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
> >   static int __init iommu_debug_pagealloc(char *str)
> >   {
> >   	return kstrtobool(str, &needed);
> > diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
> > index c95394cd03a7..aaffad5854fc 100644
> > --- a/drivers/iommu/iommu-priv.h
> > +++ b/drivers/iommu/iommu-priv.h
> > @@ -5,6 +5,7 @@
> >   #define __LINUX_IOMMU_PRIV_H
> >   #include <linux/iommu.h>
> > +#include <linux/iommu-debug-pagealloc.h>
> >   #include <linux/msi.h>
> >   static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
> > @@ -65,4 +66,61 @@ static inline int iommufd_sw_msi(struct iommu_domain *domain,
> >   int iommu_replace_device_pasid(struct iommu_domain *domain,
> >   			       struct device *dev, ioasid_t pasid,
> >   			       struct iommu_attach_handle *handle);
> > +
> > +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> > +
> > +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
> > +		       size_t size);
> > +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> > +			       unsigned long iova, size_t size);
> > +void __iommu_debug_unmap_end(struct iommu_domain *domain,
> > +			     unsigned long iova, size_t size, size_t unmapped);
> > +
> > +static inline void iommu_debug_map(struct iommu_domain *domain,
> > +				   phys_addr_t phys, size_t size)
> > +{
> > +	if (static_branch_unlikely(&iommu_debug_initialized))
> > +		__iommu_debug_map(domain, phys, size);
> > +}
> > +
> > +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
> > +					   unsigned long iova, size_t size)
> > +{
> > +	if (static_branch_unlikely(&iommu_debug_initialized))
> > +		__iommu_debug_unmap_begin(domain, iova, size);
> > +}
> > +
> > +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
> > +					 unsigned long iova, size_t size,
> > +					 size_t unmapped)
> > +{
> > +	if (static_branch_unlikely(&iommu_debug_initialized))
> > +		__iommu_debug_unmap_end(domain, iova, size, unmapped);
> > +}
> 
> I am wondering whether it would be better if we move iommu_debug_map()
> to iommu-debug-pagealloc.c,
> 
> void iommu_debug_map(struct iommu_domain *domain,
> 		     phys_addr_t phys, size_t size)
> {
> 	if (static_branch_likely(&iommu_debug_initialized))
> 		__iommu_debug_map(domain, phys, size);
> }
> 
> (Does it make sense to use static_branch_likely() here? Normally, people
>  who enable CONFIG_IOMMU_DEBUG_PAGEALLOC would want to use this
>  debugging feature. Or not?)
> 
> So that ...

This actually was the v1 implementation [1], but Jörg suggested to move
it to a header file as a function call would have an overhead if this
feautre is disabled.

I believe the priority would be to keep the performance overhead minimal
with CONFIG_IOMMU_DEBUG_PAGEALLOC and the commandline disabled, so people
can run with the config in production and only enable the commandline
it to debug problems, without having overhead on the typical case.

> 
> > +
> > +void iommu_debug_init(void);
> > +
> > +#else
> > +static inline void iommu_debug_map(struct iommu_domain *domain,
> > +				   phys_addr_t phys, size_t size)
> > +{
> > +}
> > +
> > +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
> > +					   unsigned long iova, size_t size)
> > +{
> > +}
> > +
> > +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
> > +					 unsigned long iova, size_t size,
> > +					 size_t unmapped)
> > +{
> > +}
> > +
> > +static inline void iommu_debug_init(void)
> > +{
> > +}
> > +
> > +#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
> > +
> >   #endif /* __LINUX_IOMMU_PRIV_H */
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index 2ca990dfbb88..01b062575519 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -232,6 +232,8 @@ static int __init iommu_subsys_init(void)
> >   	if (!nb)
> >   		return -ENOMEM;
> > +	iommu_debug_init();
> > +
> >   	for (int i = 0; i < ARRAY_SIZE(iommu_buses); i++) {
> >   		nb[i].notifier_call = iommu_bus_notifier;
> >   		bus_register_notifier(iommu_buses[i], &nb[i]);
> > @@ -2562,10 +2564,12 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> >   	}
> >   	/* unroll mapping in case something went wrong */
> > -	if (ret)
> > +	if (ret) {
> >   		iommu_unmap(domain, orig_iova, orig_size - size);
> > -	else
> > +	} else {
> >   		trace_map(orig_iova, orig_paddr, orig_size);
> > +		iommu_debug_map(domain, orig_paddr, orig_size);
> > +	}
> >   	return ret;
> >   }
> > @@ -2627,6 +2631,8 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
> >   	pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
> > +	iommu_debug_unmap_begin(domain, iova, size);
> > +
> >   	/*
> >   	 * Keep iterating until we either unmap 'size' bytes (or more)
> >   	 * or we hit an area that isn't mapped.
> > @@ -2647,6 +2653,7 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
> >   	}
> >   	trace_unmap(orig_iova, size, unmapped);
> > +	iommu_debug_unmap_end(domain, orig_iova, size, unmapped);
> >   	return unmapped;
> >   }
> > diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> > index 83e64d70bf6c..a439d6815ca1 100644
> > --- a/include/linux/iommu-debug-pagealloc.h
> > +++ b/include/linux/iommu-debug-pagealloc.h
> > @@ -9,6 +9,7 @@
> >   #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> >   #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> > +DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
> 
> ... we could make this static?
>

This is not static because of the header usage as mentioned above.

Thanks,
Mostafa

> >   extern struct page_ext_operations page_iommu_debug_ops;

[1] https://lore.kernel.org/linux-iommu/20251003173229.1533640-2-smostafa@google.com/
> 
> Thanks,
> baolu
> 

