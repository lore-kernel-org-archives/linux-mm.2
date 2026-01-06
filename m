Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23C4CEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496E86B0092; Tue,  6 Jan 2026 16:19:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A8F6B0093; Tue,  6 Jan 2026 16:19:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363C06B0095; Tue,  6 Jan 2026 16:19:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 266406B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:19:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2C92160A5A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:19:29 +0000 (UTC)
X-FDA: 84302805258.24.9EC4ABC
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id E72EA40009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:19:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="P7lFYR/E";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of skhawaja@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767734368; a=rsa-sha256;
	cv=pass;
	b=dZg8FN3+Jwmc0bbqdaLLZsY2Fdp4uAQIwal4xJW/ozSY5nKuli4kO+Xj5YhgbVMFIaxOtW
	B67Qwv6WgfGpnez0FKUm3177NiWOv4CZ4MH6vF0PwdmOvP7vsEKylEEdQEYzKssMr6OSR9
	Ojvk+2O5i6IRdvySLrX8aKruLmcx7/A=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="P7lFYR/E";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of skhawaja@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0WDLL1FeM2LN8bxMsxZQjW0E/VVI2Vol2qU0rnzeCI=;
	b=DvFlZlMDzOUCRQzg8Q67SUiaxXHlzMSc4OV/E2ghQL/8CUq65pjJRNNHnF+iIZ5qPDQQEp
	kj0AKYCV1Tpp5mEBRiJ/NrX9TaNmSFhsGZIM1grkga3uXnkDNpPRDhOSYVJE40V2U4A49E
	cQ1asfYZOSM046WxCcAt279YJ0nuey8=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-121b14efcddso578c88.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 13:19:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767734367; cv=none;
        d=google.com; s=arc-20240605;
        b=XG8Cjw8biOD322assE50cqJk7s8z8pKuzIRJQVH+wHtbAoPbc2Z3iBTtyS1DenlZjy
         gFCT/k50Kem3fF4MTB012q2qzjAyFF7JBi4owIjgNtAqadJ25T4uIJAwJw2PQgmzDb0I
         aEcsMK7cVGg1ppjdcl1QDzqohkxpIJ4BkCjIA4DeFRg7FA/qtAHVh38TpxdxwaLHe2yR
         GGkrPA/4SEADfTdToRpNrW6jm6Ht2dX+zsukWZIWt9VLD23454CEOLX5t6D2F6zmBum4
         Qlz1tCZL3gJSyD9CtGRp6kgh1IF+cT03hlIaaNE969Yv4ouuUfCAP9Nbu49H0pNlQIDB
         mz6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v0WDLL1FeM2LN8bxMsxZQjW0E/VVI2Vol2qU0rnzeCI=;
        fh=OQMuTinT6gLvcT0MMsKyU/xx7WbR9+BLBw5abz+qnfM=;
        b=SVijTguK9e2n3D1Hi9aNGUkT2HeILzeCQPWzcS287cfdOATSPS6NiZ2w9UYELE6poP
         Wh6/siEclRLcYGT+re1e/iWANzcCYjC6Jo+qJ8w/W6YBLKGHMTBr0ZAG3KxlT46xMDPo
         C+k2sVnOhGOffLWsOzAeSGgtNkJZuZPPxkCNSt3hjP8p1ZQrZFg8EPWHBfKKHDw2xpfV
         rBKO+qC/Io/yzpgrHR2QbTYGL9gRxABROM/ZpFHhY9e+k6C1mmRHN/+RKQkoQBUcDzSB
         DpD+yqL3NWk5yKZFMjfD0Xy2C/ZWizUDd0DRCqUFxVLcUcO9Nn4vCEWFPwx95b4b6gLr
         bjQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767734367; x=1768339167; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0WDLL1FeM2LN8bxMsxZQjW0E/VVI2Vol2qU0rnzeCI=;
        b=P7lFYR/E3D0hnuJmYZevcR14tpSDo2hEP353X/1k82iGxqYlT4i5HosoaJWor5r188
         7+JvhvIMT5YD1je2Sl2UI4ijKSBZOSUr7MwmU3XsaeE0Q5rziPssSInl+tEZG9er1iMv
         xFMqDVqwvf0flMhcKhZO7kqxmwtw9uWZEQJbL2YRCp7H0gSojGYljTD+GhaWLVv3MiN/
         80IAobI5bNMxLJLPFnvUjrdS0wv9h8QZdYB9DUf9+bNRIewNN8TGKlyIOnVLwLoflQZt
         woX6q+9K/QIXvTtZZAXnvLcP5769EG99/xSEBnjYMIY7ssxilM1lvACIh2N1WoAOUZ1A
         XeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767734367; x=1768339167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v0WDLL1FeM2LN8bxMsxZQjW0E/VVI2Vol2qU0rnzeCI=;
        b=biSohHHUPeybYCjgVyIscC7api+EJOHQvEnDwiWLfmRjrWubcSQML3tNdE8A814GFD
         6+FpBkd92kdMPfXH/DlXGwovGLQxKy/0uHm0dWvrirbQsGNT9JXricVK71a0LYwkTPXI
         w7ULEZ9Cg02wscaRdKnFnCgY6MfbEoU1mgAbUcIc3QRhMO1HCojQQdPsyzYQc64lSSCU
         SIXfGEC5qLjz6rUGMtJegJjdZ76fZDHGMBAP7Xd0nVWTz9+z5tlW03QvV3K/TSWpfIlx
         TqfocWvU65cQgw+lTkPTyyqRQ0Rdu39pY/2f4hXtlLHXX8IGEmSw4FnZ+Bve4ua+dSaT
         seHg==
X-Gm-Message-State: AOJu0Yy64TKNPVADcat4g+r/1qMRcTtJMosvpV8R/1lkHauh9ItXuCF7
	NLe3OspLYP4xUWUs8a4TO2wISVs6gc79DJyFz1szGjGGVH5SqN8OqqYVuQ96jjDendi2y8dmWRt
	czjcJJCEnIFS/DuqbudqsYU+G+4m9gmMDh0JjA5mx
X-Gm-Gg: AY/fxX7zqo1Y1C+6jmXXDyDbyxYOMAH2N7egcjD8Obl2ypaiHUpUYAhxrqm14Urqp9g
	UjbfTl95bA+xG4LSCPCRXzNTrIqZ5RPZbUY2mKNQHMHar14nMzeec424k8VMnDSbziAaAYMY5z7
	x6QmyuA6zh3zcBGD2gEaRHM1SmnbdecQWWYK/qUWW66+Sdsp55g2eKLTE+NFaPGsb432r0IirSN
	g4am3NgpKZEYcnKyVa8jyZq4dGhD6tQneItklJiX6xLz3YnAQumDDrBZOiRdm39KJiS6+bBcv66
	vOfIg52zBJvlq2T7UWTcU4pYL4MONU/9tg==
X-Received: by 2002:a05:7022:2204:b0:11a:4c75:a45b with SMTP id
 a92af1059eb24-121f8690149mr27061c88.10.1767734366229; Tue, 06 Jan 2026
 13:19:26 -0800 (PST)
MIME-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com> <20260106162200.2223655-5-smostafa@google.com>
In-Reply-To: <20260106162200.2223655-5-smostafa@google.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Tue, 6 Jan 2026 13:19:13 -0800
X-Gm-Features: AQt7F2oijAP3GChcEgGLCyF9ausjTQAQE9RZQidHFJzJm2N1jZ-pPamc_b3fK2A
Message-ID: <CAAywjhQ=b504kj7j0sBR4tShkeFcgEZw5nY-SvQDdZoaEEP00g@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] iommu: debug-pagealloc: Check mapped/unmapped
 kernel memory
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
X-Rspam-User: 
X-Rspamd-Queue-Id: E72EA40009
X-Rspamd-Server: rspam10
X-Stat-Signature: asysft7q8jdgj1fop3ubrgu8kzm1g53i
X-HE-Tag: 1767734367-121446
X-HE-Meta: U2FsdGVkX19ih+q14XLz5e0w8tXw3VBWP5IIeL6S1moJ9WXuByF3AQzrwWokdtWQt8yu1QaqcCLE25CRubIwt0eNB7DgdQOu03NKDnQo9cYa0LdkXM5ZdzAUXA+MFX56KMaSTvusv+tHZhRzQr2XntLBymRCJoBMOWIEJunMuNvpYN/CzBsJTgOYpzMFTGiLnvA/C0hqFYQ43M4ZteSzfpzX3my+PpHTnV6daztR/SttSZfJAZMPzOqzPXWdTHw1YVifRHctCl42TW7KIkWiFnThCqHJyz0ekQLZogG7yr5zKBdqzSI1cHFpe64ZdMah5ty12Tqtu8rJHkeaX+xnIUQJYa3a/S/Zy4SIdpevl5gDSRpBtpP+BPBAaCWJ567fCQz2w0hhA5GTKw9RB2csxVDBcb/aYjW5MafQj8wuzal6glEOcTP9S+MiJibfbuOPeYgQg7hKMZmapowXYcn/VLxSgqzbUMZIxkEp1FrAQTnQzwkkSUTnNPN+wtPwhKTvaX/8I5K+5wXcMyBA8PIRDKobKRpMyKC+e6553l1VxUvv67wmBKTwC0xe7/LMfDyM1I2TH32rB3hnQ/3DEL/wpwFpHfTcImDX950M0hXShQUJlzgjAd8dB93pDpMJ2p5FZS92l8yec+88EBIPsYdnXva3kGrWN6dztlC+aOQvu4nkDBFfxLXyN1CrHZlS5cdWMXOUyK3s6HIzFR3t2i+k+Dnk2ZMuf7/L1UaBAr0FHM4oLyIIPlq119L8K0ebT/D3C7Px9k9VGc4kSopXFam/vHF79PmKVCjQVQaOCcVVnYTb3nfyxRP8yOlIzp3Z1LzEUnm7sz2aM9qJDGY8Kd/ukVZdMKrKQReX+U+xf0rTOLuPQHMmZl3WOONTWWsnYiKrLF5hpRlDGtxm1OFdFSn0QJx0rUZfIV5Q6Tw4VMhjmX03zFB/TYqujP0w1FLHuh35JdLRjrK1NSD5BIXUZfa
 cqdv7MP/
 se967+8g3tio6TqUbkym8m8Pt2+x03NsdKEfnD54/barZ7US+FXfmkHqC4WC+WRo+GmlRsFLPFsfw6LAli7XL9dQaI9AjxKKl1BwtBVve+7zfyQPWA84Xq5tCZSg5n49CuM8pg5TjIWmwNU8VrXuYIDizmr1MQ4SaweyMzKXIWf7GAu3xiaRov8qQWZrV0AbNllzFWNYFosQMQR8n5rLbfRH9gas/X0mrfcv6/RBNdKn4rezlphj177vls+44eIgv2H/pFbx71dhCN/1yUnLorFfN3WVDRkIOYIkxHzRKLI9nj9SgZrGpvKUaKGgkhVBkLgmj
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
> Now, as the page_ext holds count of IOMMU mappings, we can use it to
> assert that any page allocated/freed is indeed not in the IOMMU.
>
> The sanitizer doesn=E2=80=99t protect against mapping/unmapping during th=
is
> period. However, that=E2=80=99s less harmful as the page is not used by t=
he
> kernel.
>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 23 +++++++++++++++++++++++
>  include/linux/iommu-debug-pagealloc.h | 14 ++++++++++++++
>  include/linux/mm.h                    |  5 +++++
>  3 files changed, 42 insertions(+)
>
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-=
debug-pagealloc.c
> index 86ccb310a4a8..5353417e64f9 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -9,6 +9,7 @@
>  #include <linux/iommu-debug-pagealloc.h>
>  #include <linux/kernel.h>
>  #include <linux/page_ext.h>
> +#include <linux/page_owner.h>
>
>  #include "iommu-priv.h"
>
> @@ -73,6 +74,28 @@ static size_t iommu_debug_page_size(struct iommu_domai=
n *domain)
>         return 1UL << __ffs(domain->pgsize_bitmap);
>  }
>
> +static bool iommu_debug_page_count(const struct page *page)
> +{
> +       unsigned int ref;
> +       struct page_ext *page_ext =3D page_ext_get(page);
> +       struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
> +
> +       ref =3D atomic_read(&d->ref);
> +       page_ext_put(page_ext);
> +       return ref !=3D 0;
> +}
> +
> +void __iommu_debug_check_unmapped(const struct page *page, int numpages)
> +{
> +       while (numpages--) {
> +               if (WARN_ON(iommu_debug_page_count(page))) {
> +                       pr_warn("iommu: Detected page leak!\n");
> +                       dump_page_owner(page);
> +               }
> +               page++;
> +       }
> +}
> +
>  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, si=
ze_t size)
>  {
>         size_t off, end;
> diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-=
debug-pagealloc.h
> index a439d6815ca1..46c3c1f70150 100644
> --- a/include/linux/iommu-debug-pagealloc.h
> +++ b/include/linux/iommu-debug-pagealloc.h
> @@ -13,6 +13,20 @@ DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
>
>  extern struct page_ext_operations page_iommu_debug_ops;
>
> +void __iommu_debug_check_unmapped(const struct page *page, int numpages)=
;
> +
> +static inline void iommu_debug_check_unmapped(const struct page *page, i=
nt numpages)
> +{
> +       if (static_branch_unlikely(&iommu_debug_initialized))
> +               __iommu_debug_check_unmapped(page, numpages);
> +}
> +
> +#else
> +static inline void iommu_debug_check_unmapped(const struct page *page,
> +                                             int numpages)
> +{
> +}
> +
>  #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
>
>  #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6f959d8ca4b4..32205d2a24b2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -36,6 +36,7 @@
>  #include <linux/rcuwait.h>
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
> +#include <linux/iommu-debug-pagealloc.h>
>
>  struct mempolicy;
>  struct anon_vma;
> @@ -4133,12 +4134,16 @@ extern void __kernel_map_pages(struct page *page,=
 int numpages, int enable);
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  static inline void debug_pagealloc_map_pages(struct page *page, int nump=
ages)
>  {
> +       iommu_debug_check_unmapped(page, numpages);
> +
>         if (debug_pagealloc_enabled_static())
>                 __kernel_map_pages(page, numpages, 1);
>  }
>
>  static inline void debug_pagealloc_unmap_pages(struct page *page, int nu=
mpages)
>  {
> +       iommu_debug_check_unmapped(page, numpages);
> +
>         if (debug_pagealloc_enabled_static())
>                 __kernel_map_pages(page, numpages, 0);
>  }
> --
> 2.52.0.351.gbe84eed79e-goog
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

