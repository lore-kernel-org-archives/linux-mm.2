Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B2DEF06E3
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 10:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148396B0089; Sun,  8 Feb 2026 05:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F64B6B0092; Sun,  8 Feb 2026 05:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C6B6B0093; Sun,  8 Feb 2026 05:13:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E37206B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 05:13:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76A0B59308
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 10:13:59 +0000 (UTC)
X-FDA: 84420878598.03.58A6368
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E184740005
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 10:13:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oDTzP6BP;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770545637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6ryApLK4J2yXpg2I9gHvL1T9qRMKGXAUjFAyQ1y3lU=;
	b=XlnABUelzEOt6EbjoOiq+nKa3fAXFY68yz8P62VYVXI6rc6mwhDt2OwSTzp9eOH5xpJE7X
	YEJKFwmiHYw7dbHqo8ZLY6/JPYo00LdyrwmGg29YNt4FYX03Tm02e9S0yxWEoiL8khYJIl
	X9M3CqzMhwNbQkkVLTqHRtU3B0Ivb9U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oDTzP6BP;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770545637; a=rsa-sha256;
	cv=none;
	b=4XzngzaYUPhQ5Nnzm6CrI9Pvf2SgTw2p1BvIsD124PCBWl6U2kLNlI2DLPwEQ8Xwk1wpWT
	oGy3wq2/MrjiT/oMkGFl2Mb8UIYjMtCcLiDoeAp9+VDVWge9opKvjZ7rnGCXB7tMCdaVOJ
	Jg8ayFwPQC5NiLuTjgFqwvAOkTuj36c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B1E9600BB;
	Sun,  8 Feb 2026 10:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452FFC4CEF7;
	Sun,  8 Feb 2026 10:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770545636;
	bh=rkYW3wffwDllivkQDY/e9E5Dft1p+R5H/xiDfhcNYms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oDTzP6BPNWIt4X9LEqYeY++mFhqyUqgyyb3gZTXgf5XK+iESqLl5DDT4GKZafB+38
	 nI8maoISOlRaVMcgVdDWcGeQeMx+m8pKeWkLWyAHsyFIOKjaUDeTY1HwAdf3zxQTBx
	 wJ8t7ZjSHuJwXO82H7aXBzjf3PoUlrM328lMkpsBJ9Qz6BhK484C5xdAwdAxPsAQ0V
	 QkYz/l1Ub/y5po6ywPJBUbtGnLSL57Uai7/HUCoUKq4rKpmcYgYgT6i86PKWN7rNGo
	 3hTCTLLNYKCp+XEyktXyFiIur3gKIhcoT8kKhXz3jfXIoJfvSH9LKIWxBZFiSZoC/+
	 OKvA1YgCjTcCA==
Date: Sun, 8 Feb 2026 12:13:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
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
Message-ID: <aYhh2XzyFsJbohll@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
 <aYEY6PC0Qfu0m5gu@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEY6PC0Qfu0m5gu@x1.local>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E184740005
X-Stat-Signature: ixjzt94wi8zhg8bktf5nxeaqyi6sfb5w
X-Rspam-User: 
X-HE-Tag: 1770545637-299043
X-HE-Meta: U2FsdGVkX186MYZIyyuDyRjEOtytjCZWBAkp6YbpssNgkRmZIy/RC74zClmhuaXR/KZwMTU+szvFWsFpSRWCje2uj38xd3J9aiAobys56JNTh9Gx8M6yJvhlzPL52jVIHQMKnPvE+2RkG3BNckyqQ10UJpBVjqBLBdB+JYUM/XM+QOHH5Ez8ocUXkIyIURFaDQ7dtpdeLBShxqqoH04MPCCHGeaF+OiPGmXclWLyIZefExsqjxtCpd/KJQq1VurPYj0KhGc+fh9lsGJVHmM6x714V/pH75hfgPz1WI65LfXUUEvfcUZi0Ngl1aNWKwUNlJRxGAYPokDt+ngejCe7ibSG6zJRxfnfTj1Wil1t1lNCGQjB1Am6jCtPpDWFByFMmtoRC2tW3inHjA1vK/gGk12Iu7F33cwv2FfTZ6vHuMM3AmrHtsVmW8mwYzkzQu2zJnC+wTjUJyulgfTlLVZwl3jVHiTwZi1+pfkvG2OLEK0mf2j5iAR6a0AhLHhukRg7JgZNZT0XsuCJUK8hwj/80Fl0Rtin4pk4UOaibkrBBSK5LSK5TYyFO7qtr1/awXfPnW1wOP6gHNav/yb+rRuH5VsIGB6IqFrL3Rq1Gt7ebp67XeVTTNkW3PQSoRIRVHGA3n96IHIoIATDOcyFJm0KlIKeFr71yeA5A1NYfAhlg1UN8ZWqs7LdTDUHZkpvUR8i0/IvDgdLVrdai1tmoN+693vBZqqGh6iseAEJRoR4yCXUHzTFzAeszo0PCkAU0yK1DbqzFKCco///ajrWZQEnLBP6sj7XBK0iwMDPSKfetr5ZtUnfkEOorCoeCBDf3AayTcJYm/84nBS2ZFplTTBrgc1SpHQhiV0gNmWt+d6FKHHdss3eqOsJv5ouT0zN/mJw3ZdU/hVatkgPq5+7Ohz+Gvz8vq1xIOZfpYybv6YfTg8t11vuirTQmTPmPKyU1Ps9AbaR21CSQymfpdNqC5p
 0Xp583cV
 YBF1s7pLkg4BC6WQgmWYdvX5FudBGkK4bood1T2UoBTf6VlQ0diIzqKu3LlIWyjX/Bx7YtYGGLT66WWmVD8ZnQ/m6cEH0SRMRJt3067hyFXyjafr5nnsOeamnRbtf4dCDVIjxVT6VfQXkQpfP4x7yLjl9j/oA89Y2y/XscqT4ViKX1Prf546nN+SikDkFUDNt55ZaGmeqUpNTONJ0gkouzwEh7azVN6DpgtQq/FUjaLT4adTcQY3fYwiGwNC/ZXqfNJ1yDESSjmKvSqNjOCTAd4NGOiFtHDLWqSfjHr1upWukiaBmNsZoMHADUOXUIOV57By+9YJ6O4vBACi9We4D5+oN0booGGPZKUpnC9wTx02iVkA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

On Mon, Feb 02, 2026 at 04:36:40PM -0500, Peter Xu wrote:
> On Tue, Jan 27, 2026 at 09:29:26PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Current userfaultfd implementation works only with memory managed by
> > core MM: anonymous, shmem and hugetlb.
> > 
> > First, there is no fundamental reason to limit userfaultfd support only
> > to the core memory types and userfaults can be handled similarly to
> > regular page faults provided a VMA owner implements appropriate
> > callbacks.
> > 
> > Second, historically various code paths were conditioned on
> > vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
> > these conditions can be expressed as operations implemented by a
> > particular memory type.
> > 
> > Introduce vm_uffd_ops extension to vm_operations_struct that will
> > delegate memory type specific operations to a VMA owner.
> > 
> > Operations for anonymous memory are handled internally in userfaultfd
> > using anon_uffd_ops that implicitly assigned to anonymous VMAs.
> > 
> > Start with a single operation, ->can_userfault() that will verify that a
> > VMA meets requirements for userfaultfd support at registration time.
> > 
> > Implement that method for anonymous, shmem and hugetlb and move relevant
> > parts of vma_can_userfault() into the new callbacks.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  include/linux/mm.h            |  5 +++++
> >  include/linux/userfaultfd_k.h |  6 +++++
> >  mm/hugetlb.c                  | 21 ++++++++++++++++++
> >  mm/shmem.c                    | 23 ++++++++++++++++++++
> >  mm/userfaultfd.c              | 41 ++++++++++++++++++++++-------------
> >  5 files changed, 81 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 15076261d0c2..3c2caff646c3 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -732,6 +732,8 @@ struct vm_fault {
> >  					 */
> >  };
> >  
> > +struct vm_uffd_ops;
> > +
> >  /*
> >   * These are the virtual MM functions - opening of an area, closing and
> >   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> > @@ -817,6 +819,9 @@ struct vm_operations_struct {
> >  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
> >  					 unsigned long addr);
> >  #endif /* CONFIG_FIND_NORMAL_PAGE */
> > +#ifdef CONFIG_USERFAULTFD
> > +	const struct vm_uffd_ops *uffd_ops;
> > +#endif
> >  };
> >  
> >  #ifdef CONFIG_NUMA_BALANCING
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index a49cf750e803..56e85ab166c7 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -80,6 +80,12 @@ struct userfaultfd_ctx {
> >  
> >  extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
> >  
> > +/* VMA userfaultfd operations */
> > +struct vm_uffd_ops {
> > +	/* Checks if a VMA can support userfaultfd */
> > +	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
> > +};
> > +
> >  /* A combined operation mode + behavior flags. */
> >  typedef unsigned int __bitwise uffd_flags_t;
> >  
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 51273baec9e5..909131910c43 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -4797,6 +4797,24 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_USERFAULTFD
> > +static bool hugetlb_can_userfault(struct vm_area_struct *vma,
> > +				  vm_flags_t vm_flags)
> > +{
> > +	/*
> > +	 * If user requested uffd-wp but not enabled pte markers for
> > +	 * uffd-wp, then hugetlb is not supported.
> > +	 */
> > +	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
> > +		return false;
> 
> IMHO we don't need to dup this for every vm_uffd_ops driver.  It might be
> unnecessary to even make driver be aware how pte marker plays the role
> here, because pte markers are needed for all page cache file systems
> anyway.  There should have no outliers.  Instead we can just let
> can_userfault() report whether the driver generically supports userfaultfd,
> leaving the detail checks for core mm.
> 
> I understand you wanted to also make anon to be a driver, so this line
> won't apply to anon.  However IMHO anon is special enough so we can still
> make this in the generic path.

Well, the idea is to drop all vma_is*() in can_userfault(). And maybe
eventually in entire mm/userfaultfd.c

If all page cache filesystems need this, something like this should work,
right?

	if (!uffd_supports_wp_marker() && (vma->vm_flags & VM_SHARED) &&
	    (vm_flags & VM_UFFD_WP))
		return false;


-- 
Sincerely yours,
Mike.

