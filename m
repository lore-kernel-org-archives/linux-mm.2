Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49235CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57468E0005; Tue, 30 Sep 2025 05:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2ECC8E0002; Tue, 30 Sep 2025 05:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944A98E0005; Tue, 30 Sep 2025 05:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC678E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:37:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21B9413B782
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:37:06 +0000 (UTC)
X-FDA: 83945412852.08.0CEB35C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id ADCCD4000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:37:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dMaQGLa6;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759225023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sriyjezazUL36Fd5zaQH3Go6JHJr+H5glZUzh05N9l8=;
	b=IzFCbPmUt3ilg+SL48vs91s5njO/+O0EQ+JNjtop1uLob/d/EYN46kj2Ql2vg7SrC2AHC5
	uETUK3WkK3nGHXYnfaDyI8+1WNjMe3hNR0ZnYjM6Hi1LR64hZ6Nlj/zANfvTWx5XyHX4Yp
	P/pv0nZuQ0rp19IwBVumEK5YrKtOvx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759225023; a=rsa-sha256;
	cv=none;
	b=E7fwLf3IBQxaUEfaVV8lWB3ePWRIla6JQWAcaJs12GI9CNd23wLp3CisUY7NlNqeBzEAYQ
	JOdkfMuVtz+N5uA+wcpjTccnvkqdpPlKyC+VtF3Iv9MuyTY3+ldBxgiHGG4Y8vwjcoAWxu
	0B9riNln7k/xzTC/rPNMrYEEoJopqK8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dMaQGLa6;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759225023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sriyjezazUL36Fd5zaQH3Go6JHJr+H5glZUzh05N9l8=;
	b=dMaQGLa63smzTbp2PYti3rll6RntV/0tzY+Sd/b/uSvwj8voBMx/t4iMgApBA+4RD6CHWR
	6r1btC8uTjE+D/n0xxuASlf7DALokQDviPq3DdP/lZwJyzWpVeSHcdACzWe/gmkNx7oYtS
	2PyzvyEEz2UOziQWrbU6LHNgQ4fqxVs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-5wIBw4ydNHSpNq4xhoZ2sQ-1; Tue, 30 Sep 2025 05:36:59 -0400
X-MC-Unique: 5wIBw4ydNHSpNq4xhoZ2sQ-1
X-Mimecast-MFC-AGG-ID: 5wIBw4ydNHSpNq4xhoZ2sQ_1759225018
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e3ed6540fso20753685e9.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759225018; x=1759829818;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sriyjezazUL36Fd5zaQH3Go6JHJr+H5glZUzh05N9l8=;
        b=ZGs21u/M61K9xNduOnVxiEa9cKyFpIVnAvZFwBLs5BI3v3CvlYh1ApRnB0gQoBr8bY
         GtqMV6wN6rYKlyZl+ha5bNmEMS54DQv/Mw/gZmF6PbrR7B3wQOb0v8C0kxuty5QgYPRP
         XVMby800SUCiww2mr11mxGk/QZc1TxnqjU45rLe6elF16pljrB4g2nhEjHJ9s8ro0iV0
         U5SrgxqASuuysezlM5bPgER7ckUAxGOHOkKA4bsDWfkWlRawnz1L38ASywVu+YGqGnxh
         D3k7K9yaf9vyC8o6xv29ZONtJvruX+nP512TJHVoHWZy838f6NwLMhiCT5aSY6Y8vUPi
         vZyA==
X-Forwarded-Encrypted: i=1; AJvYcCWekrxFY80kQxoo8EuPm3V18KRmiEnBAwkkIurYgwOHl328zHkblkVdo3Owd3oAor0ym4/5whAe3w==@kvack.org
X-Gm-Message-State: AOJu0YyHqq5ttYXQokzqgq2ga8EPysXdYnTNNebZQG8QMpFxGJD1UolM
	2IFAUJ+ODBea902FGRf7KSVQHqcPscYNfZxqh2VQh1ZFbu919Wnx1G5YfvbmAxtsLrGSAbnk3YL
	csxIzc2Fwoiv7mZSmqbGAOz7i8XAyO63OjCpuO4DJMge9NcqNuyJF
X-Gm-Gg: ASbGnctX03AV2IiIo4lOu8RU2FfoJscQGL5NSkRlm34c6b6LmI0trR+8PaGuvO6M82i
	ApIoFaY/OaYmyBS6VjWhFvnvh1uR9mDTTm7+3yYH3gD/VLMY04k28MH5rD7cMEVaubGxwMc1rhe
	PzM2n/u6KxGE6597LhuVpvMciplzCqqkx04QM8dD1vOviBKJP6pdmSYXKbWbhl3jDTqVostqeL0
	DJ2h9373/UHlVK873SgwD7BlKwD4hbPZoL35dzZhHLUaFdYO6JC1cQfDuptIbyII3YckSN1Fu5f
	RdvXJnkgME4mw1mNlJd2qoDfu+kh2Sf1C2mEq0kDAh9KFAD8C6wUrWz7kr4tD0Xftl4/qm5mKTo
	PFVh2yv8p
X-Received: by 2002:a05:600c:4510:b0:46d:1a9b:6d35 with SMTP id 5b1f17b1804b1-46e58ac9c36mr37612515e9.14.1759225018321;
        Tue, 30 Sep 2025 02:36:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsPJzHmF8DkpwxtlmdmhxGs2aUnDwUWraLDaT6N40+ieEDyQubMcJS5ZryUo4Ugs9z5ZSCKg==
X-Received: by 2002:a05:600c:4510:b0:46d:1a9b:6d35 with SMTP id 5b1f17b1804b1-46e58ac9c36mr37612135e9.14.1759225017777;
        Tue, 30 Sep 2025 02:36:57 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e4ab0bf62sm109304255e9.9.2025.09.30.02.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 02:36:57 -0700 (PDT)
Message-ID: <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
Date: Tue, 30 Sep 2025 11:36:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Axel Rasmussen <axelrasmussen@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, James Houghton <jthoughton@google.com>,
 Nikita Kalyazin <kalyazin@amazon.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
 Suren Baghdasaryan <surenb@google.com>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926211650.525109-2-peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EpreA-ZLPUFhF9EJZEMfCaYlz_yYpJZYIDLDpvJHqR0_1759225018
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hke8brdb8z648m9wu9hhpwqjzst36ggr
X-Rspamd-Queue-Id: ADCCD4000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759225023-528451
X-HE-Meta: U2FsdGVkX19jgYmVkwsxRE5MGfCipFTtB5+vtRN+tYgIG9c7HREgGhlxwHGTxMHH+l44nE3fvxqZxXIDP6k+S0zFOGRQQbGYWHuEN9gHYnw1AP01+n0/pYg3en6LDntyZjgAUBG9ww41RfcFNbX74GLliH8eZizONri6VxFj6ChEPIhiB7s4xOqa5TcsN4MeAnxl3KyFCPVSxJiBLXYUW367SRIrSeqWg48RbsBk9F3Tie863mgMOPbSXX4jKZlFMX8hjZeaWmZrc/Kjy2DJgUS2HshiF4KNbdtNiKlZvNp952fZOdarHHM0mebksbH+YSMfuUiuqN78fQgSuj3HsR0xpmk4yV2fIaXYNucHQCiCiXuPTarqXCyaBXye+7ZFOE/qXl7W/y9yT6weJ4pY16x2qQGqsMTzcfiXnma40MkpYSndxTD4wJyKJQyxRDVlmtfuF1+IQRJf6hzBWep9i2mH9D17mAGHTX5HRhKN1p80fZ/ne+K4dmPzfjVCHKer6Wr2Sa/Iquwhc6OXvlEaq97U9cBJZjEtcS5/YyD69cmMeE1BeEp/07vriSnhPQ85HjBQRV0u2GfM5Wo36zwS97IQPIDOSEnF5+FnxnJhVydUDk+IuJv+OCdj6nnz1MWp4r0zMg6kgLL1t4XSxkJwn53147TNYY99j6LvLRtkLENKDsG5QjKd8NR5sujlujP7ihfjBFZ1LMPUIxH+MebMoexdEM55Y1pScqYlzCOktsydYOt7piU6q7dQnJPVyjYSyUzrJo6ja+zj3Ic/YeO28qifmb5nEUc/+l9SNh2YEX/DHlszfIcSs+sjRvQON1IQ7R8OJRSky8YDdPTi1lKKjpqBRAhk2KizV/ZAZIVX/CT0jjsEgwcAs1a1N3KeetCEfyfevWPXi2wvbvJSwYKFWlZK9kVip6ga+cx0Etvz2L1/mRSMiDOQ0oLZQRU9RIZOMIiwdVtFoVB07lzUO7M
 C6yv2nYB
 T8P5HxfrVkFNX9nc/eh8szMaLda1aquQp8pIJT0Z2ldM2KqixsbzMwU5wUChqnaVYLtyf13uI64b37PvtxLZ356UjR4DNXa3sllLzgOp8uLZ7RksIOnhdqO/uZKPJNBjevyFs1qfaRdJkmH3LZ0JbM8+O/rC8ttRH2AQ6h0iCyRILuK1Ny2cxDj7Il6v2cqVinPJyV+8zuyLVME2+VMAIAVGHAGZnsMfpHgQ8lz1Cxf+QegTnnRx6P3ktVUGadadh6eelBGjKbhbDeqYTywFQrUJxu/r4X0gI9YWL9pK49a6o7YAMLM6OUltNkgi3zP40lgVEcPh8/OognOSjL5Q9A8jyr/FKC4eMPjCw34EgYdRjuX8apKRHT3QX48ZZ4o9rC0m/5tVw+gK57QVjg51iXJE2KjTESFgNfqSN6dbuq7Nhr4hJmdG6a9zvwaiO2pbkrgET1VxWtdkddPy+Gz4bVMeSxKadiPCob2qYSJ6h5VOmMHq5hbq2KJcQITVE/HaJBO96Ml51E6/ue353WBLleq8rgZtQSHO+XNWB1Qgv4sgTOco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.09.25 23:16, Peter Xu wrote:
> Currently, most of the userfaultfd features are implemented directly in the
> core mm.  It will invoke VMA specific functions whenever necessary.  So far
> it is fine because it almost only interacts with shmem and hugetlbfs.
> 
> Introduce a generic userfaultfd API extension for vm_operations_struct,
> so that any code that implements vm_operations_struct (including kernel
> modules that can be compiled separately from the kernel core) can support
> userfaults without modifying the core files.
> 
> With this API applied, if a module wants to support userfaultfd, the
> module should only need to properly define vm_uffd_ops and hook it to
> vm_operations_struct, instead of changing anything in core mm.
> 
> This API will not work for anonymous memory. Handling of userfault
> operations for anonymous memory remains unchanged in core mm.
> 
> Due to a security concern while reviewing older versions of this series
> [1], uffd_copy() will be temprorarily removed.  IOW, so far MISSING-capable
> memory types can only be hard-coded and implemented in mm/.  It would also
> affect UFFDIO_COPY and UFFDIO_ZEROPAGE.  Other functions should still be
> able to be provided from vm_uffd_ops.
> 
> Introduces the API only so that existing userfaultfd users can be moved
> over without breaking them.
> 
> [1] https://lore.kernel.org/all/20250627154655.2085903-1-peterx@redhat.com/
> 

Looks much better with the uffdio_copy stuff removed for now.

> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   include/linux/mm.h            |  9 +++++++++
>   include/linux/userfaultfd_k.h | 37 +++++++++++++++++++++++++++++++++++
>   2 files changed, 46 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6b6c6980f46c2..8afb93387e2c6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -620,6 +620,8 @@ struct vm_fault {
>   					 */
>   };
>   
> +struct vm_uffd_ops;
> +
>   /*
>    * These are the virtual MM functions - opening of an area, closing and
>    * unmapping it (needed to keep files on disk up-to-date etc), pointer
> @@ -705,6 +707,13 @@ struct vm_operations_struct {
>   	struct page *(*find_normal_page)(struct vm_area_struct *vma,
>   					 unsigned long addr);
>   #endif /* CONFIG_FIND_NORMAL_PAGE */
> +#ifdef CONFIG_USERFAULTFD
> +	/*
> +	 * Userfaultfd related ops.  Modules need to define this to support
> +	 * userfaultfd.
> +	 */
> +	const struct vm_uffd_ops *userfaultfd_ops;
> +#endif
>   };
>   
>   #ifdef CONFIG_NUMA_BALANCING
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index c0e716aec26aa..b1949d8611238 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -92,6 +92,43 @@ enum mfill_atomic_mode {
>   	NR_MFILL_ATOMIC_MODES,
>   };
>   
> +/* VMA userfaultfd operations */
> +struct vm_uffd_ops {
> +	/**
> +	 * @uffd_features: features supported in bitmask.
> +	 *
> +	 * When the ops is defined, the driver must set non-zero features
> +	 * to be a subset (or all) of: VM_UFFD_MISSING|WP|MINOR.
> +	 *
> +	 * NOTE: VM_UFFD_MISSING is still only supported under mm/ so far.
> +	 */
> +	unsigned long uffd_features;

This variable name is a bit confusing , because it's all about vma 
flags, not uffd features. Just reading the variable, I would rather 
connect it to things like UFFD_FEATURE_WP_UNPOPULATED.

As currently used for VM flags, maybe you should call this

	unsigned long uffd_vm_flags;

or sth like that.

I briefly wondered whether we could use actual UFFD_FEATURE_* here, but 
they are rather unsuited for this case here (e.g., different feature 
flags for hugetlb support/shmem support etc).

But reading "uffd_ioctls" below, can't we derive the suitable vma flags 
from the supported ioctls?

_UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
_UFFDIO_WRITEPROTECT -> VM_UFFD_WP
_UFFDIO_CONTINUE -> VM_UFFD_MINOR

> +	/**
> +	 * @uffd_ioctls: ioctls supported in bitmask.
> +	 *
> +	 * Userfaultfd ioctls supported by the module.  Below will always
> +	 * be supported by default whenever a module provides vm_uffd_ops:
> +	 *
> +	 *   _UFFDIO_API, _UFFDIO_REGISTER, _UFFDIO_UNREGISTER, _UFFDIO_WAKE
> +	 *
> +	 * The module needs to provide all the rest optionally supported
> +	 * ioctls.  For example, when VM_UFFD_MINOR is supported,
> +	 * _UFFDIO_CONTINUE must be supported as an ioctl.
> +	 */
> +	unsigned long uffd_ioctls;
> +	/**
> +	 * uffd_get_folio: Handler to resolve UFFDIO_CONTINUE request.

Just wondering if we could incorporate the "continue" / "minor" aspect 
into the callback name.

uffd_minor_get_folio / uffd_continue_get_folio

Or do you see use of that callback in the context of other uffd features?

-- 
Cheers

David / dhildenb


