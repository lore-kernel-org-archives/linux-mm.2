Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925A0FCB625
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041E96B00A9; Fri,  6 Mar 2026 11:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32136B00AA; Fri,  6 Mar 2026 11:53:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13B96B00AC; Fri,  6 Mar 2026 11:53:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD18D6B00A9
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:53:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75F4E1A066A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:53:45 +0000 (UTC)
X-FDA: 84516234810.07.691D637
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 503F41C0008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:53:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MKLhBv2S;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772816023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNQbk83T93bvLw/SSUDUDFDLerXYgajIMOvnuUhX6A8=;
	b=XYmgWv/SoUcYphJTgPF7a+2DawDpdfHlVSGAxJL3yGcwD03T2TJeDp09i/lo0BYC+fA6x8
	cQVXZ7oEmuU3iODEJadDKqe1FA4HevvCvryBIrPSOGGHtXeZUIwPyoHN+YRYT3eJeLHxJC
	gKPg3f6Kzq1Nyb+dQVcstvw0rDRbDgY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MKLhBv2S;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772816023; a=rsa-sha256;
	cv=none;
	b=Zc6etUh94GWQq9Aw3Mv2o4bPc30wYn2p5/nmS43nzqgBV/2nI1hldx2z9Td9Io3n/BAUMJ
	ikAlH6Qlm+lEX3oaRdVVxMniqbkP+B/yXLupMq6k04xk2vPjeTB11efWFotsI6NQd85OZo
	G9pmjx0cVXAAIOqxAZ2aBXeVlGVBYHQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772816022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hNQbk83T93bvLw/SSUDUDFDLerXYgajIMOvnuUhX6A8=;
	b=MKLhBv2SF+KTn1SnNwzpBQmwi954KxzsgSs4L5G3aPC143/MkbaZBRToujFnH3S4/A7rXe
	qQ6mtuAgD6mhHiHjKD2ec5MaPStnqIIFtntn058sTRxqKs1p3+W2WVVvMoRS6xuXcuiUKb
	8jc98ivI18k5ZKB+maM5bACOS4oTNW0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-DUc2QKnhPiKrzzmm-idYVQ-1; Fri, 06 Mar 2026 11:53:39 -0500
X-MC-Unique: DUc2QKnhPiKrzzmm-idYVQ-1
X-Mimecast-MFC-AGG-ID: DUc2QKnhPiKrzzmm-idYVQ_1772816019
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cd7229b5aeso153635885a.2
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 08:53:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772816019; x=1773420819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hNQbk83T93bvLw/SSUDUDFDLerXYgajIMOvnuUhX6A8=;
        b=o04ZX6rL7FfRYx3rYT+PLQMYmiZljMaoMBRxwb3Qu/ECe9yf5qPpwJjdyNSt+iqwIm
         32QGHqJp9t6bLjOcA9+rLx/Y5HK9spOF4uCc7YQjIOA9Si1mbozBL94wY9VP/aEFQ+dT
         B/+kmlKnUWfYtB12GPMM9QqBnDtWabafyLXawrGIa9BvRef9wAFqEmVyK+6bA9T3d8lT
         jFMHvNI4KB6qPfIX1bOGucx6zQsTA5ZG9SEcn9ZhbuyVor7tRZU+Fewi+qwCJG7WwtHJ
         QsjbbuSUtCH5fhaJCrdtJ+KjXr01zvw1ZoGqhvN+PJqeERBXjASHowL1Xa5Xk3q7BK25
         A2lw==
X-Forwarded-Encrypted: i=1; AJvYcCVKabJze2XdqAFZ6Qu8nPOJfD1wqDykBcyUdTeWFBFS9/w48DR4Gcb+cLmRivRf4OrjtefWNFKG0A==@kvack.org
X-Gm-Message-State: AOJu0Yx2KuV3pLIzFIy2Z2GR/8PodiSw2AOCI4eUnuj2gXVjSMEmOewd
	TWZk7HNrYfz8+qJ1/xgXM3D8vmqCq+4h6slGpjNUDwh9aZpyHcwTAkLwvWJHNZnNS8J5QqJNifb
	bfciJIKjeBPPEkAzmixGVMbMXRMqdqkDYnHirY3lhgqotYR0ByBie
X-Gm-Gg: ATEYQzzugoOYEmCfq0InrN8Ra6/8WxP/rUdAChXEud3LPujRr45y7wQykv0p0XNkt/P
	iI2IzT+nLXrmqn6JS5WsvbgFKpYceq3HFOC0QWdegWuIJkau1asmahASq9OS6Jutr+t5AZPUOG9
	ClZO8BuvwwPpGv7qiRwbuQl36P9/9X0U8B5eTAamrJgLAdawYB+CQsOG5GP58Q3qV10BLUfmm00
	sNuyFNvEWutpMPIeTjFy6Kowhqlo0avIDN8YWHDG+W7Muo+ZrWucbvRhAjPfCLZwi24p17T75IB
	yILcV8Q74u1nQ6v70gY69+TCGABzvWFHRA75FxrYNWWid3YtHVuu05+h+uBSOq5Gate8oQnhjPR
	d/zBI2GitfyWU3nxVdwBvcYI8edTFTsWmUMiiUZU1omLEMSSF7fmCs0u6y+hJsOzYbWU8lbAk6u
	vYaXQx4Q==
X-Received: by 2002:a05:620a:31a0:b0:8c0:88f3:fac4 with SMTP id af79cd13be357-8cd6d46fd1bmr344991585a.56.1772816018773;
        Fri, 06 Mar 2026 08:53:38 -0800 (PST)
X-Received: by 2002:a05:620a:31a0:b0:8c0:88f3:fac4 with SMTP id af79cd13be357-8cd6d46fd1bmr344986185a.56.1772816018115;
        Fri, 06 Mar 2026 08:53:38 -0800 (PST)
Received: from x1.local (bras-vprn-aurron9134w-lp130-03-174-91-117-149.dsl.bell.ca. [174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a317187c0sm17735076d6.50.2026.03.06.08.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 08:53:37 -0800 (PST)
Date: Fri, 6 Mar 2026 11:53:36 -0500
From: Peter Xu <peterx@redhat.com>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jonas Zhou <jonaszhou@zhaoxin.com>,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Message-ID: <aasGkA4r56pLqNC3@x1.local>
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6bBSZCsVXWA1qBYzzyAFx_uxHSAefDHmy8uw_Q_RJsI_1772816019
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: o9iqpayd4spj66ukoqfijsofweoc9dnw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 503F41C0008
X-HE-Tag: 1772816023-348918
X-HE-Meta: U2FsdGVkX18HslFtsofAq7Gr2oAKY1Tb6Hm2O3HGGl9QD48NuoHgnwzYqRfPo7Ta4eHSvObpvNCdKyS8qlbhg+kaHmKc4aiDm9L/VMruazIHtiqPA5hDA75gAkCSUA+ObKtuRY2bKib24ClTLaD9HImwUp49kbliXCBqNUO5zkCEqm64rVlmcvJr8gBTVRU0I3FO23Nv1NdlszdgFONuQU1G1LP6azYhWYkD2I2EtNL+v3w/Z5Fjmp48rYjOGjICr8JAVkqHS8yjm4XDpdDm6oV6fG9Tu9cbIrrZapyVfFdJwUYYPZnwhl0Rx3o3BroO+wQbGG2g7+HY44/JZYI56fPKV2E9/sGCJWe8Aiv0qSieYlpp2tu4JncjXDEKNKiYug2waetStZaKK43oQS/9BabKecfeBT55cSQqjQvbe1HmJ0VoGZbvXD/S+UBZFaVztzvHcSDrLXFmH8lxNd98S6rj90LuX4QHvFBYS16uXL7jAff688u+YsBgPdH33Syd/x2wkm9H6+pbXGSy2PiA8eljI4UeNeo6z7pOEgor3D6yzbLnwSTVdM8hegy6vMZalB/2x+qs8cnXUlnf5Ri4o+B9IRRRzYN2neBuMBvCzatZDWSPB52IB8A4WkQR4E84ghwOBxOUXxoOCvuJsy/AbQSHlho/1ZCWNt8Mkv0YFZoA9jAX8/wSbeLf+yoOf9NeFvbCGQI6XHBB937cv3t6/x4p8opX4sAfGYWih6NMsmDfHa9G3PkAzzgzqGU/pq2efd07tYhYnL1hmP/SMGmUsmKPxym4RsG3FfqdpMeFb7sEyyt09WTKSi48bGxKbPnapZzTqrZBX52nzK1A26jQc//o264LqhwUw6FRor2kUQp1a08bUmxd2GO7ITsmOKjWlUTO0lUD4ovvpIt/n+sbGA1FzMShISRDgV/Zn+8AgY+I/alL5joKqEHTaTjnnbhwH/x1Vbpaw8MZwFckTMK
 WD31peQb
 dJXESaGGs5ZrOGh/f2BrwKPaDOjx74NqEB6We4DZCrYdQ4QM3j30ftcn3AyTDOTnug0+fY0lfLmmgyCribt21GHigN8maI3XEiKNqMq5zXGtfyAdOyTRRCoVJpxB8EAgyjZTEhOXcJBfT0yglcpi1lplA25jA56RFaWaSxPDz/+BOQVj1O9zPzZ5N8gx+0AczEy3e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 10:03:32PM +0800, Jianhui Zhou wrote:
> In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
> page index for hugetlb_fault_mutex_hash(). However, linear_page_index()
> returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
> expects the index in huge page units (as calculated by
> vma_hugecache_offset()). This mismatch means that different addresses
> within the same huge page can produce different hash values, leading to
> the use of different mutexes for the same huge page. This can cause
> races between faulting threads, which can corrupt the reservation map
> and trigger the BUG_ON in resv_map_release().
> 
> Fix this by replacing linear_page_index() with vma_hugecache_offset()
> and applying huge_page_mask() to align the address properly. To make
> vma_hugecache_offset() available outside of mm/hugetlb.c, move it to
> include/linux/hugetlb.h as a static inline function.
> 
> Fixes: 60d4d2d2b40e ("userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY")
> Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>

Good catch.. only one trivial comment below.

> ---
>  include/linux/hugetlb.h | 17 +++++++++++++++++
>  mm/hugetlb.c            | 11 -----------
>  mm/userfaultfd.c        |  5 ++++-
>  3 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 65910437be1c..3f994f3e839c 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -796,6 +796,17 @@ static inline unsigned huge_page_shift(struct hstate *h)
>  	return h->order + PAGE_SHIFT;
>  }
>  
> +/*
> + * Convert the address within this vma to the page offset within
> + * the mapping, huge page units here.
> + */
> +static inline pgoff_t vma_hugecache_offset(struct hstate *h,
> +		struct vm_area_struct *vma, unsigned long address)
> +{
> +	return ((address - vma->vm_start) >> huge_page_shift(h)) +
> +		(vma->vm_pgoff >> huge_page_order(h));
> +}
> +
>  static inline bool order_is_gigantic(unsigned int order)
>  {
>  	return order > MAX_PAGE_ORDER;
> @@ -1197,6 +1208,12 @@ static inline unsigned int huge_page_shift(struct hstate *h)
>  	return PAGE_SHIFT;
>  }
>  
> +static inline pgoff_t vma_hugecache_offset(struct hstate *h,
> +		struct vm_area_struct *vma, unsigned long address)
> +{
> +	return linear_page_index(vma, address);
> +}

IIUC we don't need this; the userfaultfd.c reference should only happen
when CONFIG_HUGETLB_PAGE.  Please double check.

Thanks,

> +
>  static inline bool hstate_is_gigantic(struct hstate *h)
>  {
>  	return false;
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 0beb6e22bc26..b87ed652c748 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1006,17 +1006,6 @@ static long region_count(struct resv_map *resv, long f, long t)
>  	return chg;
>  }
>  
> -/*
> - * Convert the address within this vma to the page offset within
> - * the mapping, huge page units here.
> - */
> -static pgoff_t vma_hugecache_offset(struct hstate *h,
> -			struct vm_area_struct *vma, unsigned long address)
> -{
> -	return ((address - vma->vm_start) >> huge_page_shift(h)) +
> -			(vma->vm_pgoff >> huge_page_order(h));
> -}
> -
>  /**
>   * vma_kernel_pagesize - Page size granularity for this VMA.
>   * @vma: The user mapping.
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 927086bb4a3c..8efebc47a410 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -507,6 +507,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
>  	pgoff_t idx;
>  	u32 hash;
>  	struct address_space *mapping;
> +	struct hstate *h;
>  
>  	/*
>  	 * There is no default zero huge page for all huge page sizes as
> @@ -564,6 +565,8 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
>  			goto out_unlock;
>  	}
>  
> +	h = hstate_vma(dst_vma);
> +
>  	while (src_addr < src_start + len) {
>  		VM_WARN_ON_ONCE(dst_addr >= dst_start + len);
>  
> @@ -573,7 +576,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
>  		 * in the case of shared pmds.  fault mutex prevents
>  		 * races with other faulting threads.
>  		 */
> -		idx = linear_page_index(dst_vma, dst_addr);
> +		idx = vma_hugecache_offset(h, dst_vma, dst_addr & huge_page_mask(h));
>  		mapping = dst_vma->vm_file->f_mapping;
>  		hash = hugetlb_fault_mutex_hash(mapping, idx);
>  		mutex_lock(&hugetlb_fault_mutex_table[hash]);
> -- 
> 2.43.0
> 

-- 
Peter Xu


