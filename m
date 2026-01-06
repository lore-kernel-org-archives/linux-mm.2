Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2EFCCEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226D86B008A; Tue,  6 Jan 2026 16:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3DB6B0092; Tue,  6 Jan 2026 16:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6806B0093; Tue,  6 Jan 2026 16:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1C466B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:18:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8ACABBD637
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:18:09 +0000 (UTC)
X-FDA: 84302801898.29.6925FD9
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 82406C0011
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:18:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JISnysNt;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of skhawaja@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767734287; a=rsa-sha256;
	cv=pass;
	b=vnNMEnFphYPHxIANSXZlCoFAuChbqvsFWXkJEX0OsXl4gp3tYX9vEBa4ZQgx0RpgAWXzye
	vZ6VQ5gHIr5HOgGQJ9ehQkbj8i/HMgqVV/rmQIT5IWPFxrUBGiXkkPSYNizLJdHf8c/nvW
	xkyk9Q9moYMcDKGf0Vh6lYpzmIyCIV8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JISnysNt;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of skhawaja@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xs4wYR5ihtYfkrcnwnzlMK7Ux63wyubPNcFx3ioLljA=;
	b=Fd7T1nlra9AH+JPGTVow1wpBJoXtm7driiDUvthgg6/QSGaPiQR8i7W9yrlWBI8KyYmEe6
	NscS3KzpMCLwOxG7Ub3YXDkx0QUICbq0e+uA/ezgDd8nmbTF2LSdWZTY6jRGrtjGDG/XSe
	HL3ynrOJoFUJE5zYu+shGYJGdlVSU48=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-121adc0f1e5so1957c88.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 13:18:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767734286; cv=none;
        d=google.com; s=arc-20240605;
        b=Hav3V4GEtvswozes2ugH+qaMZU4uLrdC1Ikq23McaHRdGqZ7kGG0Vu57BvHJD8hyXH
         BStqd9yKYj3NQnJxvi0HAmpTv6Ecsa/s7cdmFoARCNZMcwy2JjZVGJUfWOWh4dpzdEJY
         nAnSVRChbjl9I02cIcalaoeXvwM0UbieLEPn26woB2d0QQ3S91icMSAftMwtLjAZsuVp
         7x+v3PegGGS09mqlYeaJDmAO4aZFZJr8vxF0ji2Gk8bwbpL9VgE8G/XJwSdil2dGsmup
         YtOoC6zn2BpX4+g945EZC1jIf2u6pTXpFQtxbTM4i1/KXNcegLJCT8MQnI0VhE+OYBge
         LM/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xs4wYR5ihtYfkrcnwnzlMK7Ux63wyubPNcFx3ioLljA=;
        fh=OQMuTinT6gLvcT0MMsKyU/xx7WbR9+BLBw5abz+qnfM=;
        b=hmtomtISCJQ0aLVJbLnzREXLZt6IeOGBdJUpGFUrLRz5vDf1RygtJoyN4Nan6lhX9c
         qnSjLNH0FzvVv9DNtjp2hgWUqBP7le8UkOb0ysvZd8ZAuMot8uQpUR6/HHNZDp3OWr3A
         YCnugGmB80nX29A1dtpfP6of+I/EiwMndyHMF8XxACC3+FeBl6R2Ko8Iq1ndCcWmMxTs
         3cVIxdnkozUZNfFagWvfLO23XJjWKzZ5awL+D7ztveA5oujj286JA1ng13lJA7okaU1d
         kzq4RTD9tjFkuIQ8MARemwPrzjXkf+eYen3DdC7+n9n23ncdymPZXv+0tWhDudEESu1L
         24ig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767734286; x=1768339086; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xs4wYR5ihtYfkrcnwnzlMK7Ux63wyubPNcFx3ioLljA=;
        b=JISnysNtUl/eDvlF31mijOzVS9CejA/iNWPbJ6OhuTxYgR/hYrmd0KJLlRlyVDI+wE
         qa7k4HqRtnfCV7H3lztlM2YQ7c9Hk6I63d8OhbTe1WlgOQKhogm9of9sz9nmG9nxCBSD
         1MsoG4Q8eRmGzAaUQU2LF3fpCvUK0ySyXRIMI6/eDjHnq/zzQxvo/TcrzP5FejvLuc4Q
         AIYXdGbDTIqHEqsQIMO7U1CLIEdfGNVAOlDpA1Ou0b6vqYKA3dnHJE3/Txj34yvddaZ1
         h5Gj36HDFihxYGQZoo+qDiAYsuNP6OTxr83Sq3XZiCR6DebZx4lRuJc5YMJU1xnwFv7w
         /5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767734286; x=1768339086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xs4wYR5ihtYfkrcnwnzlMK7Ux63wyubPNcFx3ioLljA=;
        b=moeDTKSylQtxFLSCViJoc3ZpqWzZ2aCx/uQzcIG6cShaiMZiEGeA6+gajiOFkNde1R
         +If82l0mFwaMAy7Ir8EPkdN9/zkPEYaer9xxkohLnXe5zdep33aO++0TI5kbX6uVvvGO
         eqLwvBcDjoXvr4+tkR/w2ARE0DtT27dkXKViaF4e4RXVeKmk1NUHEjCx+DitdlVgq201
         RrFLACVLd9rMXiDdfbTTy9mOUtALAGpWFwhW0GPMEeSACAw/swZBeANw0OZ9uE4GbTRA
         QL/At1chLdy0fiXgF6Rr4xGs+fFijXi3KRN/0IaU1nWocT10/aO2VV0a6qgkd5ZN9f76
         zzyg==
X-Gm-Message-State: AOJu0YzOa8WqLjHRKmEO5Sgrio+a3cOd3oFszF3Yd+4jhmyNuAfrU6+B
	P0nMGDdtb0TZ9EY5xkd+B6nNw/nrn2U83ztnfWEkCAUPYWBemByJtOojDRSuvB9llKeEERAURrp
	a16Vg9b3DB28Wl0dvFv0ZyllRSNYi82EIighIvLYG
X-Gm-Gg: AY/fxX6bBxceL8Rck0bmGMIUWgH6vtrGePJQbR/mse8MbmkfQzGkpk/QjO+kwRilUBh
	NplM1u3BLTV9WqCupxBNqLObvOKCtdvL2Rcnsj7/n+QKitnatOiw+4B7LgU7geTFy7TrAG0QHJv
	qyJv7wHGVnVW3j3skkOE3Pb7zPmRU9+L51GdID4wN74Zo22WXxL+P6W6/2N2w170CXma2PSft9W
	/0hMyZlF7ZvtFLQWl7888cs8ZCP1L5ko2vAMLKt5tcUhtel+HW7DxqRmZxZbCVF7/AMrSIkTkdZ
	XQVlXqjCfNGPVBHQJavpgg8=
X-Received: by 2002:a05:7022:11d:b0:119:e56b:c1d5 with SMTP id
 a92af1059eb24-121f85a2c84mr37453c88.0.1767734285772; Tue, 06 Jan 2026
 13:18:05 -0800 (PST)
MIME-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com> <20260106162200.2223655-3-smostafa@google.com>
In-Reply-To: <20260106162200.2223655-3-smostafa@google.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Tue, 6 Jan 2026 13:17:53 -0800
X-Gm-Features: AQt7F2qCrnBg0kXhETMA1MP9KFpVtvxrt0SQO0tr_xkvmJ_R9qPTToDvVX-GwBE
Message-ID: <CAAywjhQ-anM-+nPS=GXpuSf5abCAySA40iuYU-Bgh00hiqbfow@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 82406C0011
X-Rspamd-Server: rspam03
X-Stat-Signature: u8po6cjw1majh31s79wout9w9qtc9u6b
X-Rspam-User: 
X-HE-Tag: 1767734287-715670
X-HE-Meta: U2FsdGVkX1/zHDdmWgBtVaQhXjVM1qLbp7WVIqPi+USeysX+5TfT4BEl31GpCQeBYxO0zDynHKKRdMywOKvsoveQx3WKLkd+ogx6bjcwAhJWUgGd323yTUEl/+bxx5JUXVAMAlv0mymRz7xEeoxlGfWRUE/Q5RObdJWqATZcw6+3kVNT1rcaZD+YDSqg3POyZHcS9vlrAP14bvubP+jQf8R6YT6HY+lhLJAYAYMKcYYXn5QxdXP2Bk9MKLnrBydUrJpanV0ts3lBER5bX0fMlZxZHbkC7I2bPyntRfCPCsBnxQhcmieE3qysOZr65mvz/HEsVrcl8mpN000M0hJIhihHOThVzSCwX4dGm51JVxC+3unq3fYkw5Ws/QBXHjpaEA2F1WWRLpUjp1F4JBNzyt1n4tdXOFyJ6zY//n2iwbExyDK2CcR0L7f696wzKnBaiz46v1xFUx9tws+ge8Ctj006crThNTObhtr8DtJFRSp7FtA66UAteZA63wCY+BcascN+16SLvtqElyIAl7wkLo21X73unWSTsCqz7BFlA9XKtsevhH12qTi00jj3nElp80SE7UPNq2+D7XwlVr7bSiSdjF5JKWvS5qVm380pERYcn0oRJ34Ic7JC5DeaBHZd5dSh5oQQJbynExk2qTOK+iMSxpkC1kXsIksm/VOwlGDLlJBVt8FcDRgwD7NRTv0kW9IyZWFKjJQAJDEaeXq9h5JlVgqmL2qL3aOtRmFQTwOwoEitviOEQuji4YSS4lu/8XNDvhfCfnyL0bLaBtwRJ4O47AXH3iuwQ6MbzOAxY0KGrjWf+2I1TSNCMhSOydbDnAQHThXz9G5MAg9HNwNMq9ZB8DUIgZZgUFweVqmMF78MN/DA6zaCNK2JFKFDwlgBHihfbAY0keu18xsXwJW0Vf/yQTZuVH2TZk4+MFlj4KJgYVH3jBeAc41y/ty2bBNgxoCNREoApawcPDMJBG0
 3ObxhzXl
 gRpUybEI4+uxWD0MHu3i4Z/V1iu6D0kcGmMuEcBla9VcJi0mJb/qrTL34h+mJO+7xQleElrv5mZ5QzvXAn/KwTbmCBK65KMy9ydWHoEXM8o8h+JyGUQVUiPWoTAu6B8savkHDf+Td13CPFQ7xwbJGyLYeMcLtqNqAlP8LDUbP4XmcArtqHsVaJlabyYuIVB5ci+UJh/NLPzUxF/9ZCNCtl+KLBZFFXhicEopvtdBqgT0bBVsu4kc4Fld2M4RvNquKNMyqa8vQMC61NfOHU0+NC6fKIjLHy7X64hjzWQXr5jvBARDDZ22xBM15dcpi+dUwjFuRBWxLOUurSx3kvSjOqudVyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 8:22=E2=80=AFAM Mostafa Saleh <smostafa@google.com> =
wrote:
>
> Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> - iommu_debug_init: Enable the debug mode if configured by the user.
> - iommu_debug_map: Track iommu pages mapped, using physical address.
> - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
>   IOVA and size.
> - iommu_debug_unmap_end: Track the end of unmap operation, passing the
>   actual unmapped size versus the tracked one at unmap_begin.
>
> We have to do the unmap_begin/end as once pages are unmapped we lose
> the information of the physical address.
> This is racy, but the API is racy by construction as it uses refcounts
> and doesn't attempt to lock/synchronize with the IOMMU API as that will
> be costly, meaning that possibility of false negative exists.
>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 28 +++++++++++++
>  drivers/iommu/iommu-priv.h            | 58 +++++++++++++++++++++++++++
>  drivers/iommu/iommu.c                 | 11 ++++-
>  include/linux/iommu-debug-pagealloc.h |  1 +
>  4 files changed, 96 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-=
debug-pagealloc.c
> index 4022e9af7f27..1d343421da98 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -5,11 +5,15 @@
>   * IOMMU API debug page alloc sanitizer
>   */
>  #include <linux/atomic.h>
> +#include <linux/iommu.h>
>  #include <linux/iommu-debug-pagealloc.h>
>  #include <linux/kernel.h>
>  #include <linux/page_ext.h>
>
> +#include "iommu-priv.h"
> +
>  static bool needed;
> +DEFINE_STATIC_KEY_FALSE(iommu_debug_initialized);
>
>  struct iommu_debug_metadata {
>         atomic_t ref;
> @@ -25,6 +29,30 @@ struct page_ext_operations page_iommu_debug_ops =3D {
>         .need =3D need_iommu_debug,
>  };
>
> +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, si=
ze_t size)
> +{
> +}
> +
> +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> +                              unsigned long iova, size_t size)
> +{
> +}
> +
> +void __iommu_debug_unmap_end(struct iommu_domain *domain,
> +                            unsigned long iova, size_t size,
> +                            size_t unmapped)
> +{
> +}
> +
> +void iommu_debug_init(void)
> +{
> +       if (!needed)
> +               return;
> +
> +       pr_info("iommu: Debugging page allocations, expect overhead or di=
sable iommu.debug_pagealloc");
> +       static_branch_enable(&iommu_debug_initialized);
> +}
> +
>  static int __init iommu_debug_pagealloc(char *str)
>  {
>         return kstrtobool(str, &needed);
> diff --git a/drivers/iommu/iommu-priv.h b/drivers/iommu/iommu-priv.h
> index c95394cd03a7..aaffad5854fc 100644
> --- a/drivers/iommu/iommu-priv.h
> +++ b/drivers/iommu/iommu-priv.h
> @@ -5,6 +5,7 @@
>  #define __LINUX_IOMMU_PRIV_H
>
>  #include <linux/iommu.h>
> +#include <linux/iommu-debug-pagealloc.h>
>  #include <linux/msi.h>
>
>  static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
> @@ -65,4 +66,61 @@ static inline int iommufd_sw_msi(struct iommu_domain *=
domain,
>  int iommu_replace_device_pasid(struct iommu_domain *domain,
>                                struct device *dev, ioasid_t pasid,
>                                struct iommu_attach_handle *handle);
> +
> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +
> +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
> +                      size_t size);
> +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> +                              unsigned long iova, size_t size);
> +void __iommu_debug_unmap_end(struct iommu_domain *domain,
> +                            unsigned long iova, size_t size, size_t unma=
pped);
> +
> +static inline void iommu_debug_map(struct iommu_domain *domain,
> +                                  phys_addr_t phys, size_t size)
> +{
> +       if (static_branch_unlikely(&iommu_debug_initialized))
> +               __iommu_debug_map(domain, phys, size);
> +}
> +
> +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
> +                                          unsigned long iova, size_t siz=
e)
> +{
> +       if (static_branch_unlikely(&iommu_debug_initialized))
> +               __iommu_debug_unmap_begin(domain, iova, size);
> +}
> +
> +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
> +                                        unsigned long iova, size_t size,
> +                                        size_t unmapped)
> +{
> +       if (static_branch_unlikely(&iommu_debug_initialized))
> +               __iommu_debug_unmap_end(domain, iova, size, unmapped);
> +}
> +
> +void iommu_debug_init(void);
> +
> +#else
> +static inline void iommu_debug_map(struct iommu_domain *domain,
> +                                  phys_addr_t phys, size_t size)
> +{
> +}
> +
> +static inline void iommu_debug_unmap_begin(struct iommu_domain *domain,
> +                                          unsigned long iova, size_t siz=
e)
> +{
> +}
> +
> +static inline void iommu_debug_unmap_end(struct iommu_domain *domain,
> +                                        unsigned long iova, size_t size,
> +                                        size_t unmapped)
> +{
> +}
> +
> +static inline void iommu_debug_init(void)
> +{
> +}
> +
> +#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
> +
>  #endif /* __LINUX_IOMMU_PRIV_H */
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2ca990dfbb88..01b062575519 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -232,6 +232,8 @@ static int __init iommu_subsys_init(void)
>         if (!nb)
>                 return -ENOMEM;
>
> +       iommu_debug_init();
> +
>         for (int i =3D 0; i < ARRAY_SIZE(iommu_buses); i++) {
>                 nb[i].notifier_call =3D iommu_bus_notifier;
>                 bus_register_notifier(iommu_buses[i], &nb[i]);
> @@ -2562,10 +2564,12 @@ int iommu_map_nosync(struct iommu_domain *domain,=
 unsigned long iova,
>         }
>
>         /* unroll mapping in case something went wrong */
> -       if (ret)
> +       if (ret) {
>                 iommu_unmap(domain, orig_iova, orig_size - size);
> -       else
> +       } else {
>                 trace_map(orig_iova, orig_paddr, orig_size);
> +               iommu_debug_map(domain, orig_paddr, orig_size);
> +       }
>
>         return ret;
>  }
> @@ -2627,6 +2631,8 @@ static size_t __iommu_unmap(struct iommu_domain *do=
main,
>
>         pr_debug("unmap this: iova 0x%lx size 0x%zx\n", iova, size);
>
> +       iommu_debug_unmap_begin(domain, iova, size);
> +
>         /*
>          * Keep iterating until we either unmap 'size' bytes (or more)
>          * or we hit an area that isn't mapped.
> @@ -2647,6 +2653,7 @@ static size_t __iommu_unmap(struct iommu_domain *do=
main,
>         }
>
>         trace_unmap(orig_iova, size, unmapped);
> +       iommu_debug_unmap_end(domain, orig_iova, size, unmapped);
>         return unmapped;
>  }
>
> diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-=
debug-pagealloc.h
> index 83e64d70bf6c..a439d6815ca1 100644
> --- a/include/linux/iommu-debug-pagealloc.h
> +++ b/include/linux/iommu-debug-pagealloc.h
> @@ -9,6 +9,7 @@
>  #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
>
>  #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
>
>  extern struct page_ext_operations page_iommu_debug_ops;
>
> --
> 2.52.0.351.gbe84eed79e-goog
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

