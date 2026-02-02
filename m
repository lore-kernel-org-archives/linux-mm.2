Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D7CE7FDEE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 21:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE19C6B0005; Mon,  2 Feb 2026 16:36:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FCE6B0088; Mon,  2 Feb 2026 16:36:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D468C6B0089; Mon,  2 Feb 2026 16:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4FFA6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:36:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6FFB41A02D5
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:36:50 +0000 (UTC)
X-FDA: 84400826580.17.3079007
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 296CCA0006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:36:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dZ+r02Yo;
	spf=pass (imf15.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770068208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tzs5uA52PlIRNKdYJ64VWzNZOW1AOPr7kIlD0JLXrwM=;
	b=hc0YsuuE//SUNqsNxtAdjPC4iT2c8wOA61p4KIjruvAyhJLNMehzw/FVsDTZ+UR1H3jz38
	463oGll4rhNU0AtNx9nHGRXHMH7I8nY37CKRnPh1Dg5G/enhX8tjIoIivWPt333fiUrMRN
	psVU7PUI3uD4unq6NMLcPWVmvP2Vu3M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dZ+r02Yo;
	spf=pass (imf15.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770068208; a=rsa-sha256;
	cv=none;
	b=u8Y5B/81pjTDyziXX6CFIcEmLNuubipnGdac39KuMMqq0VUUhamweNCRctlb0UysNh67w5
	LR+JUNGZQHGws7Bd10sRjS7KxSSgvaDnG9S56XQDlKS7NdYi4PjZs297jysR61qeLwzvpP
	qnCo/nqKCo3u78vVgmoPHpayNq/u1ZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770068207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzs5uA52PlIRNKdYJ64VWzNZOW1AOPr7kIlD0JLXrwM=;
	b=dZ+r02YoIDglMRgZC1dctmLhq4v9+8GoMkxP0Z73Vh0KmwQp/BND0t48UPUsy4QNJOb3by
	HcYU6sZB3TtRCDkc3RiZtJhM2MaFji/eGHI0v3HtS8tdMxDXXEP7mF/R+LpvVgseO5ETss
	nJPVKY5r4bkKtMIG49WQ58nba9KkPyo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-C2zF825XPMCsNYUTDdnWAw-1; Mon, 02 Feb 2026 16:36:44 -0500
X-MC-Unique: C2zF825XPMCsNYUTDdnWAw-1
X-Mimecast-MFC-AGG-ID: C2zF825XPMCsNYUTDdnWAw_1770068204
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88a360b8096so168540136d6.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 13:36:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770068204; x=1770673004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tzs5uA52PlIRNKdYJ64VWzNZOW1AOPr7kIlD0JLXrwM=;
        b=Mgb9fklIl+MBnK932Oh4MS7w680iAQWFa8XmnOQ9umJTYBSIFZbG6ZrAGYbM4ItJ3f
         05/4LUg1H5x/bLwTTjuIFwjVAAafgUHkwmoqkQGaKqPH4EpKvu2p6WGQ3SQ7iPbzDB/X
         DIVuf5HAkQSZSavUkoHL1kylwqW/aS80ANasOYtBOxTjHDgHqS/67hUZOOa4BK31bD/Y
         gtVpwN/872iRWZVafRTEYIChTiDLlyQ9ZL9ODJKt7pmsfp+pEza4rr22UF4qg8lQ5jzp
         twL0pRcT6sRzSEf1m94QnzDTn2YwjOX7dF5cGHKRaHltOwJV/DqE1ilHwcOMfJnMQOjc
         vEeg==
X-Gm-Message-State: AOJu0YyzNujgMlsx+Gn9pKg1nHQweD1Bg+VGeQYARNWl+if6qvjhCMDD
	/F7AY/4eLfT9QdeDAfg3E+4pwlwKg8RL3qNcGGr+2JjV+bvYJEpoO6XSZ7ZQ34XfhSztZ7bSUAs
	5ONGnzcc2TDgYSwanDDH7I0/Z0e6RAO6CW7LFExL3dutH5r2hcBq4
X-Gm-Gg: AZuq6aLh5F/N7U4vGhIsqPcdVUcBqAwRZMCL3eH0Q3vjXxNexEquuldDC/dBk7kQBmv
	lk4Fp6XT/13OVtyS2HOnAdu50oaOpNfb/pw8jdWpcx+vSj2R/yKYqz08PUihihObh786vkX3os7
	KRwqTuU5XUrw5vgFKfwZiD/3FvW14V8V/iJWsJ2jSe/dqv88q1tIznOrFkfrPlN5TBmvpj/e75a
	5vmM6Bx/NPmndFoWPtREKv/1C4AZh3bJE4+qLfdN5vUPqXkgNNne04oH/wt9JjmvJNHPcny37SB
	gZOtlx+Dhbhh+lXxZNdfmSvi52iTpG+DGl2sRnhgFXB3LMhYknRys9bTVwAzkm2DqLvZB2SyWkc
	24TQ=
X-Received: by 2002:a05:620a:2550:b0:8c6:e20b:e6c6 with SMTP id af79cd13be357-8c9eb2e0cbcmr1754505685a.52.1770068203742;
        Mon, 02 Feb 2026 13:36:43 -0800 (PST)
X-Received: by 2002:a05:620a:2550:b0:8c6:e20b:e6c6 with SMTP id af79cd13be357-8c9eb2e0cbcmr1754500585a.52.1770068203138;
        Mon, 02 Feb 2026 13:36:43 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d2889asm1276000185a.27.2026.02.02.13.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 13:36:42 -0800 (PST)
Date: Mon, 2 Feb 2026 16:36:40 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 07/17] userfaultfd: introduce vm_uffd_ops
Message-ID: <aYEY6PC0Qfu0m5gu@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260127192936.1250096-8-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _udDJX9PTWDfsLirAdFRqcBhmNB_aIw_nxlu6UJuZZE_1770068204
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: eqxryeg85i3fh4hi8149s1buktc1nkru
X-Rspamd-Queue-Id: 296CCA0006
X-Rspam-User: 
X-HE-Tag: 1770068208-138719
X-HE-Meta: U2FsdGVkX197xwTPTl0dNwNy+UlLHYwtPcwUJzbDhMPItJgrbwKGKJEbm77Uz0mO032zUcc5IMWMYhPga7jsoNVM7uQ6CcdPF9leY48xlT8um6xJrVRKQkEoc+jz1EG7fYpyJGmFfaUUG6Ng1dj8D1B0X/LM/Xg1QcXzOc9iTTsCViyoW77yIWJwB0WucjuZdMn1k+QTAzZhEruLdxfGHakZWNWVaHYLUE40UigIUIgo4/YsKyHG0jQqzYQJujXLanOdPCIGGSesyGSRaTMosAHrXFiQyg5JZqMUukR0lANaKhWb9B6DW5pL2TbrBCT/obcjkaxqp7cfr1E+28c8A82rcM1aFDSibONx8yO9edJXFp3J/89XUvpz3YirQZpk+sZAkh9cVbC4TI3n8dddTrJJtGJZFCl1d9I7eMgGp4Ec7/sKOroWXO5Hl6B8rgvdx8IGSEMPmumsoRuqMdpZdFwfRx29lh6/Zph+jlP7FAUAr5D/MLR5FFT/mCOWFIzkmoR7CUro5cjXRrIHP1utJpd5GhVbK8VSRpGBvMwQJyciNpGPhjbvNdvJEVJhFlv85LJWdVMiqZTO47a9yVn7Kt82qnLyfPrXcWz1nrHzNAg8gw4+Imazb65wiXZSDjL0jxLYrmnPHtPlE9VAayo7t0z2ZNi6gBH7IIpljOV4CoTOxMwANiCQS/PyGPufvT8ha0n8n6O2nVeqHChGPmxl18Bf/SO6a4Nb4hxvEWhUoOExk0PTAqrWF4UYTPJbE+OrvsPcXLyAfmpjjsAjTEzTstmhdPCu40a9lzQFJ8flO9G+TVr2l7jgC8Xl6JGo31q4tNKPJpDKxYFg6FUx93IvvXpmpIM/7PQlaUariS7p0SG8+vBzQjutEGT6vteSGEraNJuesRIEcUxIL30xxtxjHwaZj+Icm5Op5iMoTikd7XDysvOG5mpY1wPeORJwXbMueSt0EcnMjzdRzaAEUAm
 Cq3YcLsR
 Teu8kNMBjsVUuK4SLzrHYSQOTJwyj2USKJdkDJKYJNijkA4Q7FKc6WrcnDDblnNfP+yQcDNlsLmghOsPkwwoXEZG2En8qyrbVCAcpMDfXm0cxAxGkdMnxplIVOYsxZjn+fueES4xdWJj77d9kRNaEV4GewEQOFGBFoeLgxtWcFEk635h+IrXvknGk8+RmcqULIhIyCZG0/+DrAal3Wmk9Kq2yJg5eDmfTrZN/1+jaA6HW/AtMp6K3ZM9dSm7kCVqAKH1eV/L1d5t6bFVSyBVegcWUZy5viF/LXPb/0AZBvQUaWuNeJzYrQwNakPbLCQJsfEebmcpD0Hmvyzk7dyqa1Y7tzfOE78ZKWxb69W9FSMsjRZQMO0hskG7vCLmN4KlCWD63l3ux7Htc9xpvSU+q5ov8F75KOhvQsQs8pEAmLNhPuWIJXr5UQcnYDvImfLDFspReKv3z+V7S3pE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 09:29:26PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Current userfaultfd implementation works only with memory managed by
> core MM: anonymous, shmem and hugetlb.
> 
> First, there is no fundamental reason to limit userfaultfd support only
> to the core memory types and userfaults can be handled similarly to
> regular page faults provided a VMA owner implements appropriate
> callbacks.
> 
> Second, historically various code paths were conditioned on
> vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
> these conditions can be expressed as operations implemented by a
> particular memory type.
> 
> Introduce vm_uffd_ops extension to vm_operations_struct that will
> delegate memory type specific operations to a VMA owner.
> 
> Operations for anonymous memory are handled internally in userfaultfd
> using anon_uffd_ops that implicitly assigned to anonymous VMAs.
> 
> Start with a single operation, ->can_userfault() that will verify that a
> VMA meets requirements for userfaultfd support at registration time.
> 
> Implement that method for anonymous, shmem and hugetlb and move relevant
> parts of vma_can_userfault() into the new callbacks.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/mm.h            |  5 +++++
>  include/linux/userfaultfd_k.h |  6 +++++
>  mm/hugetlb.c                  | 21 ++++++++++++++++++
>  mm/shmem.c                    | 23 ++++++++++++++++++++
>  mm/userfaultfd.c              | 41 ++++++++++++++++++++++-------------
>  5 files changed, 81 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..3c2caff646c3 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -732,6 +732,8 @@ struct vm_fault {
>  					 */
>  };
>  
> +struct vm_uffd_ops;
> +
>  /*
>   * These are the virtual MM functions - opening of an area, closing and
>   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> @@ -817,6 +819,9 @@ struct vm_operations_struct {
>  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
>  					 unsigned long addr);
>  #endif /* CONFIG_FIND_NORMAL_PAGE */
> +#ifdef CONFIG_USERFAULTFD
> +	const struct vm_uffd_ops *uffd_ops;
> +#endif
>  };
>  
>  #ifdef CONFIG_NUMA_BALANCING
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index a49cf750e803..56e85ab166c7 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -80,6 +80,12 @@ struct userfaultfd_ctx {
>  
>  extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
>  
> +/* VMA userfaultfd operations */
> +struct vm_uffd_ops {
> +	/* Checks if a VMA can support userfaultfd */
> +	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
> +};
> +
>  /* A combined operation mode + behavior flags. */
>  typedef unsigned int __bitwise uffd_flags_t;
>  
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 51273baec9e5..909131910c43 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4797,6 +4797,24 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_USERFAULTFD
> +static bool hugetlb_can_userfault(struct vm_area_struct *vma,
> +				  vm_flags_t vm_flags)
> +{
> +	/*
> +	 * If user requested uffd-wp but not enabled pte markers for
> +	 * uffd-wp, then hugetlb is not supported.
> +	 */
> +	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
> +		return false;

IMHO we don't need to dup this for every vm_uffd_ops driver.  It might be
unnecessary to even make driver be aware how pte marker plays the role
here, because pte markers are needed for all page cache file systems
anyway.  There should have no outliers.  Instead we can just let
can_userfault() report whether the driver generically supports userfaultfd,
leaving the detail checks for core mm.

I understand you wanted to also make anon to be a driver, so this line
won't apply to anon.  However IMHO anon is special enough so we can still
make this in the generic path.

> +	return true;
> +}
> +
> +static const struct vm_uffd_ops hugetlb_uffd_ops = {
> +	.can_userfault = hugetlb_can_userfault,
> +};
> +#endif
> +
>  /*
>   * When a new function is introduced to vm_operations_struct and added
>   * to hugetlb_vm_ops, please consider adding the function to shm_vm_ops.
> @@ -4810,6 +4828,9 @@ const struct vm_operations_struct hugetlb_vm_ops = {
>  	.close = hugetlb_vm_op_close,
>  	.may_split = hugetlb_vm_op_split,
>  	.pagesize = hugetlb_vm_op_pagesize,
> +#ifdef CONFIG_USERFAULTFD
> +	.uffd_ops = &hugetlb_uffd_ops,
> +#endif
>  };
>  
>  static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..9b82cda271c4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5290,6 +5290,23 @@ static const struct super_operations shmem_ops = {
>  #endif
>  };
>  
> +#ifdef CONFIG_USERFAULTFD
> +static bool shmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
> +{
> +	/*
> +	 * If user requested uffd-wp but not enabled pte markers for
> +	 * uffd-wp, then shmem is not supported.
> +	 */
> +	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
> +		return false;
> +	return true;
> +}
> +
> +static const struct vm_uffd_ops shmem_uffd_ops = {
> +	.can_userfault	= shmem_can_userfault,
> +};
> +#endif
> +
>  static const struct vm_operations_struct shmem_vm_ops = {
>  	.fault		= shmem_fault,
>  	.map_pages	= filemap_map_pages,
> @@ -5297,6 +5314,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
>  	.set_policy     = shmem_set_policy,
>  	.get_policy     = shmem_get_policy,
>  #endif
> +#ifdef CONFIG_USERFAULTFD
> +	.uffd_ops	= &shmem_uffd_ops,
> +#endif
>  };
>  
>  static const struct vm_operations_struct shmem_anon_vm_ops = {
> @@ -5306,6 +5326,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
>  	.set_policy     = shmem_set_policy,
>  	.get_policy     = shmem_get_policy,
>  #endif
> +#ifdef CONFIG_USERFAULTFD
> +	.uffd_ops	= &shmem_uffd_ops,
> +#endif
>  };
>  
>  int shmem_init_fs_context(struct fs_context *fc)
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 786f0a245675..d035f5e17f07 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -34,6 +34,25 @@ struct mfill_state {
>  	pmd_t *pmd;
>  };
>  
> +static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
> +{
> +	/* anonymous memory does not support MINOR mode */
> +	if (vm_flags & VM_UFFD_MINOR)
> +		return false;
> +	return true;
> +}
> +
> +static const struct vm_uffd_ops anon_uffd_ops = {
> +	.can_userfault	= anon_can_userfault,
> +};
> +
> +static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
> +{
> +	if (vma_is_anonymous(vma))
> +		return &anon_uffd_ops;
> +	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
> +}
> +
>  static __always_inline
>  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
>  {
> @@ -2019,13 +2038,15 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  		       bool wp_async)
>  {
> -	vm_flags &= __VM_UFFD_FLAGS;
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>  
> -	if (vma->vm_flags & VM_DROPPABLE)
> +	/* only VMAs that implement vm_uffd_ops are supported */
> +	if (!ops)
>  		return false;
>  
> -	if ((vm_flags & VM_UFFD_MINOR) &&
> -	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
> +	vm_flags &= __VM_UFFD_FLAGS;
> +
> +	if (vma->vm_flags & VM_DROPPABLE)
>  		return false;
>  
>  	/*
> @@ -2035,18 +2056,8 @@ bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  	if (wp_async && (vm_flags == VM_UFFD_WP))
>  		return true;
>  
> -	/*
> -	 * If user requested uffd-wp but not enabled pte markers for
> -	 * uffd-wp, then shmem & hugetlbfs are not supported but only
> -	 * anonymous.
> -	 */
> -	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP) &&
> -	    !vma_is_anonymous(vma))
> -		return false;
> -
>  	/* By default, allow any of anon|shmem|hugetlb */
> -	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
> -	    vma_is_shmem(vma);
> +	return ops->can_userfault(vma, vm_flags);
>  }
>  
>  static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
> -- 
> 2.51.0
> 

-- 
Peter Xu


