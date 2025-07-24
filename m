Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345BFC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A886B0177; Thu, 24 Jul 2025 05:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910CA6B0178; Thu, 24 Jul 2025 05:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826546B017A; Thu, 24 Jul 2025 05:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7427E6B0177
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:52:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 202061A030F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:52:39 +0000 (UTC)
X-FDA: 83698693638.23.3529CF1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id B97F040007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:52:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UnQyh3Xe;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753350756; a=rsa-sha256;
	cv=none;
	b=dMn7Z2qqSy7q8MAszJBHkd+xDTXwYRwYBs4kESe8bJkyLCeAVGw10+n+znupTeMiO0l4k2
	z4dKRVMczQLHg89/gIjeF1ahh9L8mdr8X1KmJ1cBSEEhVR2AmX8zjnHr3P1Co4JKSug7YE
	s191lpVI/WrovhPDC0gbjqOPMCY+FH4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UnQyh3Xe;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753350756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3d1VaRL28+ml7CYd59gxcB8VWqpmtd7xKREjccFb968=;
	b=kH3/UqFW+Rw+MPlhZtTSZyJ0bx25RFwDyO/W6LRqGBxjtzcX6Vn6EmHC8G45W+Hb6Ek76O
	kL4DiWCv64Dxa8q6KKKIAZYFbEd7Bg7V4E/igteAuEdRhKDI39e2F2BxSpVybQ3+gQzQxc
	x5fpHA1Xghuz0PJwWgsY5wgeGuUoy90=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753350756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3d1VaRL28+ml7CYd59gxcB8VWqpmtd7xKREjccFb968=;
	b=UnQyh3XepzbV7JesZpDVXPkS3QiqoBNYLOAmxw1CE3CZgzZnfhwxJHFganCSMvnx5jMQxE
	B1JkmyeBtk5z12gWa6gJ4sYQgQKvkeF5xTbHsaEYP3w95oyN49G8RqkULkXj0WWok2XdPL
	CnCxL3Ijs3gTbc8MqqTI16k7P3pMVxg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-sH6c4W8hNImzcROLXR6eDg-1; Thu, 24 Jul 2025 05:52:34 -0400
X-MC-Unique: sH6c4W8hNImzcROLXR6eDg-1
X-Mimecast-MFC-AGG-ID: sH6c4W8hNImzcROLXR6eDg_1753350753
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-454dee17a91so6040935e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753350753; x=1753955553;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3d1VaRL28+ml7CYd59gxcB8VWqpmtd7xKREjccFb968=;
        b=ddUiMS49HrGERXUtWw2K39l0NKNXlB4+L2GOdEX0eiVQvu8TOOytrXtX6tZ4Mw2XHV
         /buJ7DXX5ZyrDV0Vt0C8uQwGX3uOnOmm+NH1K6F4eYtZitakUzGi72xQ2yTOIX6bz9uY
         21pqFi6huJUpkOa0YihYoOZBrs3UlJVE+N3OrH2pAEvToGYkD3ymnCxM+3lqvzpl4Sr9
         9FLql9RZA0nvlYxOzQY0Yd/e9UluSHfPRlJP5Ffb+8XJ1d6gcMSDGuI4swL2CJ+nIrzM
         MUlVug0z9SnKXoAQObgoZxZ+I72HoWmRCvvmKCgMDykj6e0XUOSUiMgzP/YKZGsS9ZKa
         wzWA==
X-Forwarded-Encrypted: i=1; AJvYcCUGwaQoAPnu8MSEy6oAbS667t+ZYm3vzmWwtDzujgFEgw99QpDPVi6O1j8XsOKUY5UjMorYbaNjcw==@kvack.org
X-Gm-Message-State: AOJu0Ywd8J+ziXz4/4DassfC/dI711RT94cWrhKTthlJcTCLym/0oHLJ
	UfvS3oOBDGzE3n5KNXTTiRLButLMTSLdf7wJqUaYnChl38/5ORmZZqVtrDd2X8za7blkZR/mne8
	4NNBvMjH7QraIlsj/qj7zzLvilasmTdzUMVEZEADGsmupcyHlidFF
X-Gm-Gg: ASbGncsc3AbGWHaNZHnTNcw8RhihuqCDM5sIDqsA/KWVD27GHi2yqWv1xEj0D5lQaEi
	lzBy3tg5V4pZk/4DAcWY1fU8nXsaTYYIP9HW/ftm2h3cnDr8D/ZLiwVVB5zSyE7hJlhCyxlSAH6
	lg60QEnoUSFshid6i/4kpNrWTCHZBj+uxhEzL1Ti9GvZ2uunLflG4ZqLDvOon9K1YIZeWRrE6DX
	szzUk6YIkCxEtNWOq1MhihiqNDvMdhs4kW+wtzJfbUh0k3lSFC3l27IlRimNgXj3TywUCa6IWDB
	nBjuApJNqm1+Qxp3AbWS9aOrnq1lT2588wMBuY29F3NuzhWGINCQr55IthQ8S+Ulf46mFjKteje
	wZRsSfjfzij+KpNPo+sKCcEJHhw+9Wd8s207cWMfW+mQl9nq53suDriuCqa2HGz/X
X-Received: by 2002:a05:600c:1e29:b0:456:1752:2b43 with SMTP id 5b1f17b1804b1-45868cfb59bmr48340495e9.21.1753350753343;
        Thu, 24 Jul 2025 02:52:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZAUXrziIB8EzlJBAqClUneVHNyWDyc5yyca5B2bw+Sp4TnAaoK9coMye25IUT6mVqTfLJrw==
X-Received: by 2002:a05:600c:1e29:b0:456:1752:2b43 with SMTP id 5b1f17b1804b1-45868cfb59bmr48340085e9.21.1753350752846;
        Thu, 24 Jul 2025 02:52:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:5e00:c941:d6fb:3e30:b42? (p200300d82f1f5e00c941d6fb3e300b42.dip0.t-ipconnect.de. [2003:d8:2f1f:5e00:c941:d6fb:3e30:b42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870554457sm15018435e9.18.2025.07.24.02.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 02:52:32 -0700 (PDT)
Message-ID: <67a54f31-e568-427a-8fc8-9791fd34e11b@redhat.com>
Date: Thu, 24 Jul 2025 11:52:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: "akash.tyagi" <akash.tyagi@mediatek.com>, akpm@linux-foundation.org,
 vbabka@suse.cz, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com
References: <20250724075301.1151817-1-akash.tyagi@mediatek.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724075301.1151817-1-akash.tyagi@mediatek.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zxPW_hqt0nGbOTN5JCHXfHsclktNVzfmhuOLkCjhCbc_1753350753
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B97F040007
X-Stat-Signature: 7no635em7dfss8kxaq868f6bqjsr95hb
X-HE-Tag: 1753350756-296194
X-HE-Meta: U2FsdGVkX18FsWdTzi9TrpNOU671FVLmVdIeQ1yUrKp2N+XXZ5dNQi0u1r1Zd8vlAuUJT9zlaZtBuww2MvtzBQabg7mMjgh8QentuGhzklJwFnMftvBPuoccefMUBac4KUhxRmTzooxu5rt39k+z0EwP+PwMVdPASwVa+/Ej9x96q0Twdz3jgH4MhklUB/8LFVV7toBxs9Em+KiABUDcbzSGHrmGlNf9lWH9Gz+/du1WSf/VR+kSYxBg9TbvZMCQImLJ6ki/JIqHbgH/FlTCoY2hTEgcIrqabO3f15hzlGIo3a6HAAMPjDwh4fSQjK0KJT5x6pJ0gWqE/ToXl964LW9EVeECK59xL+nYxPSda4kB++i52/CHTbrwPwCvXfUSQlw/FzqpGrRfg1ZiIR3LSkJPAvoB2gpy/tuMrDXV1hTLuY7KfYr6TF97IXF1pg1ZGWg8FnpqzB2p/flB1+XcDTNMCGGsOzdr22cOf7Xb1olx3rCPoWBTMR9WZPjlRBXQKSUnZVcveIziv3HLuo7ezeUh9EpAkT1ZlI/4+MHPcmOF7sYzOdeiWOLpQYSnJ2oWPyF2cqicobUqQo0fuFK1sihvjJA9XOSfc5SRCEqGvO4bliPBgQCY+jilCTnSyrSVTHLGk+aiFPR1PDIvFROllmrSbr7S1dj+ZtqlihOirSgRbBniUsZs40i4CRDVK5ge2b7dj2f2yA0VnUmR7DlVrHREaBNmu7c70N+tN2hdBihFlc6JSy0hixyIAYCTK2AWToz5R3uExVpAY2Di5RN671l2qQGINLbh5rfhirtLx0zxuaHcSfdkDnHreekuyli19v5lYooXKJwBvMtkYmFGW1Z+Eb/ZkQYAUay6h7CNOK+/QRXRupUV4TVlM6PhwoHI4CTHlEdV/BtlRodOVJYkaTGDHKgcMcXuTPJMVHeVneRSih5fFLhbYkbMhiI6/Q/5Zz2mZN5ey6OV7cYBmJu
 0ado35K1
 2oChfqAEqRlbLVTVVa4ghKTd6YbXtzbI9VCv1EkAIolgbY/84QYY2RUZm46g0NOAF3gme8U/KkW94LKCx5qlVQ3lHYptadmUYiH+CpWGg2cKvKSuILPAR4eJOGe2ToRmR/MkFtfvN+OWm/Vg1xdspcmqDAaWjfbPCtFcJPt7tz2v9QgJ2mH+YLAW1oqaUck7N/efL9s1U1qxC2GopLbHNvaprN9d/n4QYevkFGL1rnBohAmg73kWd1GXoTEfK1mcK+UI+KKmHde+qna5CZAQvzGxeXDf+p/GQRvmh8UpBRE++fT7yLcz19gcWHoNhxGc7cML0XtouKi66KKObwr/RXPvTYmKKSV1ZnKLAYXhIJURqoO4L6D3O60dXEZKDM3SMg20wM3m2yR1Hm8EpqsHHO4lNXixvIu+0hKbif1a8jShrOwURQ5X135jAARzISk2QgN59ut8kkhrLLxagOhqHNRmtfKhkdvvuaSIOvhpe1wLY/64v697z5So6RnrD17KhN7vgpXAV8m1M7pM318S+SCWk66GSLZVxbU6MUXMb9ZmosKM2tPVRdcOf4A9MFpJQwaiJ04zXiAstcCU9Msv6sQFODGjicspwjQfC2uhZE3uUHug7Vxgx5Lu6hczoqDi7z53riBmxH1qJens=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 09:53, akash.tyagi wrote:
> Currently, THP CMA pages share PCP lists with UNMOVABLE and RECLAIMABLE
> pages. This may result in CMA THP pages being allocated from the PCP
> list for other migratetypes. When this occurs, these pages may fail to
> be isolated, leading to CMA allocation failures when drivers request
> them.

Curious, did you run into that in practice?

Having MIGRATE_CMA pages allocated for unmovable allocations would 
indeed be broken.

But, MIGRATE_PCPTYPES does not include MIGRATE_CMA. So there is also no 
dedicated PCP list for VMA?


In free_unref_folios(), we have

"Non-isolated types over MIGRATE_PCPTYPES get added to the 
MIGRATE_MOVABLE pcp list."

	if (unlikely(migratetype >= MIGRATE_PCPTYPES))
		migratetype = MIGRATE_MOVABLE;

So ... shouldn't that safe us here as well for THPs?

> 
> This patch introduces a dedicated PCP list for the THP CMA migratetype,
> ensuring that CMA THP pages are not mixed with other migratetypes and
> remain available for CMA allocations as intended.
> 
> Signed-off-by: akash.tyagi <akash.tyagi@mediatek.com>
> ---
>   include/linux/mmzone.h | 10 ++++++++--
>   mm/page_alloc.c        |  5 +++++
>   2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 283913d42d7b..dd93088ce851 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -696,11 +696,17 @@ enum zone_watermarks {
>   
>   /*
>    * One per migratetype for each PAGE_ALLOC_COSTLY_ORDER. Two additional lists
> - * are added for THP. One PCP list is used by GPF_MOVABLE, and the other PCP list
> - * is used by GFP_UNMOVABLE and GFP_RECLAIMABLE.
> + * are added for THP: one for GFP_MOVABLE, and one for GFP_UNMOVABLE and
> + * GFP_RECLAIMABLE. With CMA enabled, an extra THP PCP list is added for
> + * MIGRATE_CMA, allowing further distinction between MIGRATE_MOVABLE and
> + * MIGRATE_CMA for THP allocations.
>    */
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#ifdef CONFIG_CMA
> +#define NR_PCP_THP 3
> +#else
>   #define NR_PCP_THP 2
> +#endif
>   #else
>   #define NR_PCP_THP 0
>   #endif
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2ef3c07266b3..35f8041afbcc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -519,6 +519,11 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
>   	if (order > PAGE_ALLOC_COSTLY_ORDER) {
>   		VM_BUG_ON(order != HPAGE_PMD_ORDER);
>   
> +#ifdef CONFIG_CMA
> +		if (migratetype == MIGRATE_CMA)
> +			return NR_LOWORDER_PCP_LISTS + 2;
> +#endif
> +
>   		movable = migratetype == MIGRATE_MOVABLE;
>   
>   		return NR_LOWORDER_PCP_LISTS + movable;


-- 
Cheers,

David / dhildenb


