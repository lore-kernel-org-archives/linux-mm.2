Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B96DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8274F6B008A; Fri, 10 Jul 2026 12:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE246B008C; Fri, 10 Jul 2026 12:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEB56B0092; Fri, 10 Jul 2026 12:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3A36B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:38:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C44A98E644
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:38:39 +0000 (UTC)
X-FDA: 84973425558.03.4FF528A
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id A53702000E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:38:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="RJVzQ+/m";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783701517;
	b=bk9hpGDrk0imWu7F+Wje5+Rk7rsAshFVb8Gzx1TnZh2mcSWnXxb1ZP7ap5NmCBA0opcDDt
	7I98wPB7FyQqaFvBoTugMCvQXG9l05xJTcPJEWozdQ4eos0ckdAqthoACd00NQYeVvCZrm
	SLzU/t57Z3Z+tPoZh5bky/9gubAc5Fs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="RJVzQ+/m";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783701517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjPC+dGtl7NWTD2gQsmUUpevrDX1aRJ0R6Q1EEoKDOI=;
	b=gZgHgOCqFnMW1rkM5jQH3axRkweML+P6gbmFy5B3QMosiF69i42arBC0JX7vKuDK430cHE
	kBOoN+jqsmsn9yPdBhbo0aqawaloisK7gbTwpQ2qAjGeCD0yhoSXlmCLgsMFS+DP9sXJeO
	iVZv/6DRCZND+FQ6Np/ltAYGJNn95kI=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so6599476d6.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783701517; x=1784306317; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fjPC+dGtl7NWTD2gQsmUUpevrDX1aRJ0R6Q1EEoKDOI=;
        b=RJVzQ+/mETuFksCrs09ng+a4+EAmLk4hRmZvPiElp+pHjOEEw0FrF/ZnkNLoFUSai/
         5MMNq9leul4X0l/bezwq+PrToinbLTCQcdK2V5vViTgv/j4LntyLYNtOAUM1/ahiUrKs
         ypaqr2Z5WTO/EiTR4C4jLp+DzK0ZaBAvCtk7HOaDUmVax9ToW+4yMaG9w0LpQ1HCox8D
         42jjr/ZFCXM80i52lfzrUyJ7AKM8AGDDe+x6WMtJmp7NIO1KiFdPa+6puL29fpA+70Eb
         1plqm8xKpLTt5jIX51mau1qCNF8Pwo7gJiNb6GrXQQeSPyDICe1rivAkCXpA/cYwCpuh
         0omA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701517; x=1784306317;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fjPC+dGtl7NWTD2gQsmUUpevrDX1aRJ0R6Q1EEoKDOI=;
        b=KaYua/wHzTfm5IPaI9uZ2ltPiu5SazEhvMCazi1NrJ2qhNC/miBOZtc8+0c4ycMZwS
         xpFkpvkm5OWLZBpTiBj/Zjz8+bHVXkf+8xjv//p51EC0jYaWNERW61iW+31KzdTOTUlP
         CFaqt/PcOac6Iy5pJ/R8QAhUfCYcWM2ABShLq3brVg1gWap6B3VJmh4miYrukUbkxRYh
         Ooqd++Nh09DRDWpNKD411esAK4TcAQmqq6XsNPwwqtWsSlzvC4wYB9senyqBR03q9slo
         vGPuFXbh3v4z2A7mQ4113F6UzFbnXrKgx2i0KYQ3UIXCu60/suUJSd1jK5IngqWprTyq
         PmIA==
X-Forwarded-Encrypted: i=1; AHgh+RqgeNlrKgByjQF/EiRpsxVwjVaUiyP4NTHbDIKW/T9DhIlKyY4Nqqh1ujkjlc5DmsPozFvhU5Z72w==@kvack.org
X-Gm-Message-State: AOJu0Ywg9SKW8YIemQaLkIBUm1p6jwFAyuAUG7nr/C0RQ5zNMRy0bfnr
	zB63ACfP1gIryUyXjKXpiU7zPltuXFSuiINpcUK+RlAjasE+t0tOFJOv7pQzGQqH9+E=
X-Gm-Gg: AfdE7cmdS+INERZehVOJjp4n0RCuRHoYmRPJ9tHgEM/A1BX3grr1uQbPU59OgZ0gik6
	oxzy6Ucb8+beJicZMvCTlNJ/la8lq05lPP2eTdfqPhRq6UL1qWEPch0ybi7wTfSC/0Ik57LCnJk
	6dl34wgXm9/x9ew2K+JQXQCWSWPZencL293IxlWUPsnuj62btTSMpdePBueElNhWHcgKVfHH6lZ
	oavFsYYixx/iHzAIJh/T7pFc0qmV4bLzROuXhzwxnqa33/C4Gv8SP9/tHB3Ki0Au4Ps7f7WNrrL
	87ZRXDZMfBvRNjehX85Iq2jcU2SsUTspsTNs+aD5Y3kqU+ZxBNxBik4KHiqM87yRYOrsbrtBAX+
	deG3Xqn3FCDhm3Z0fxbzrSYRQg00DgHdPms6mMDbmOTEdQxTbTZfgNgVObX5N
X-Received: by 2002:a05:6214:19e7:b0:8f1:36c7:497c with SMTP id 6a1803df08f44-8fec217aa9emr148367176d6.33.1783701516760;
        Fri, 10 Jul 2026 09:38:36 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1d8fcsm45350946d6.25.2026.07.10.09.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:38:36 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wiEFH-00000007YQp-17rB;
	Fri, 10 Jul 2026 13:38:35 -0300
Date: Fri, 10 Jul 2026 13:38:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, david@kernel.org,
	decui@microsoft.com, haiyangz@microsoft.com, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v7 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <20260710163835.GR118978@ziepe.ca>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345362182.660027.12809852179204464964.stgit@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178345362182.660027.12809852179204464964.stgit@skinsburskii>
X-Rspamd-Queue-Id: A53702000E
X-Rspam-User: 
X-Stat-Signature: w353wqhj7b7g3gi3s1izagj1pgtkh1xo
X-Rspamd-Server: rspam03
X-HE-Tag: 1783701517-386917
X-HE-Meta: U2FsdGVkX19JvXLk3Td7PWxB+3YbmMdTecoLgMNI3+yOuYDZeaI3peNUYN82G4pUg0vu7m1v4LEZzOaS9zclnZPEZVBqtWmJJ6IHZ0CE2eK+RWjk+IY3Ce3PX76VlvQnkg/El6HTeT8vTjFgf3jE8ZHWURFdhfUzp/SsGqlyZDMPF8lOpVwoN/eE2QgvygPHZ6xPRMfJtooCP2V43PusZtE+ZTd4Ysw8zjxC4CxG6L3UUFWSr8FAPY2JAmerce7FNo2Ls5xTS+tRT+0Gms5DOhV+jmJ3RSzDRVKuc0wv3aknC3QxtNZWfgtkKj9LtfnKc03hBKMoktQdwMBmv1tEh72tJrUN/LUwsJ6+6zh51Onzinn7lUWGJMJh0vXGJJAYERJ6n/tLo0ES34kHMGTOxe5vii12mkvRfj2nRnbyHbRXoM31dRJ9E+Xi7xSR23q5YJ6sD6aNpTEES108pUIFZK1fKJVqbfmymtAfZH8CzyXd4cUHKTEwsTW2gi2+qo/R4wmMAD72l3o+Hykbr75+sXIOiNr/24NLD8cXZQW+LSCXacw1N4SatG2epxUNyJsBD+QVTDi9laU27umijIdueLTqyhmssguVG3HkiHT2IZ1LJVaHgto+yPb2zrVvTP+22AjEF/V9u99PSxzfQomy3fMiBHCn3il67ebznkWL08BrT9t0vYqzjx3Ymwdw3VZMOG81KPz//qZYlKRREiv3yNwox1IAJNcXe4lwuSphBbI/zQ7fRzUfJNl47qMXM9+jtmQWhcWC1RtRGXoaWg81p6DW2i6MKXJgKWbvARN1TDqzMCbo7pNGMP8nCUE2NAg1inCiMCsqdZq/jQICMHn50rMC8hUwTn1KSOUIJphWPQgt/bacmGa0zgjUIV/CgODPmNO0aCfmSA1Oqa4cJZ/RgadqbaBMA0DeUu5V8ci8LOFNMFWSkGFC4CdkdRf53Pn0uLSfNO6VhCM1MR+n0O+
 HGBZAlE0
 bLyUzb784caOCY+uk5mmIqwL+MoXMCkhqK3d5REh1cQtv9Mv7zNxQCzLjWXBicZD6W4PyuiZuAn0+Radeils/krwiUYDXGSxr8i7p/wVzNyQVwyBKuv2QXEjreKC02XgM79HD5HKt2ql2BlMjpS77un9V7+gldoDNdwUeAUP0DjoaPK1VV40xhS8x83iTsBozNz96kZ6wxwTUqmCmseBcbBA+TdPW+YFxhR8QeGsMjjFpvz9ebAs0PqSWjJOQ95TeEKFYmehy0EF1pgcTfOcUtUzOl79xvqoHajI/LBNfCNP7Q9CoofIQcYqEY9j+8CGxZTqlE7gSVy5ZTYno8KycCOFsirGn62z2RIEWy/qyyCgm15hBN/759XujNbizziKPHLp5CUVl2K4B55g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:47:01PM -0700, Stanislav Kinsburskii wrote:
> hmm_range_fault() requires the caller to hold the mmap read lock for the
> duration of the call. This is incompatible with mappings whose fault
> handler may release the mmap lock, notably userfaultfd-managed regions,
> where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
> after dropping the lock. Drivers that need to populate device page tables
> for such mappings have no way to do so today.

sashiko could not apply v7 for some reason but the remarks on v6
seemed meaningful, did you see them were they delt with?

https://sashiko.dev/#/patchset/178336023903.504354.7500950448226027718.stgit%40skinsburskii

> diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
> index 7d61b7a8b65b..70885f153d03 100644
> --- a/Documentation/mm/hmm.rst
> +++ b/Documentation/mm/hmm.rst
> @@ -208,6 +208,69 @@ invalidate() callback. That lock must be held before calling
>  mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
>  update.
>  
> +Dropping the mmap lock during page faults
> +=========================================
> +
> +Some VMAs have fault handlers that need to release the mmap lock while
> +servicing a fault (for example, regions managed by ``userfaultfd``).
> +``hmm_range_fault()`` cannot be used on such mappings because it must hold the
> +mmap lock for the duration of the call. Drivers that need to support them
> +should call::

Given the majority of callers use this API it should probably be the
focus of the documentation and example, regulate the existing API to a
'BTW if you really need the mmap lock, and you really shouldn't, this
exists too'

> @@ -32,6 +32,7 @@
>  
>  struct hmm_vma_walk {
>  	struct hmm_range	*range;
> +	int			*locked;

Let's use bool if you have to respin this

> @@ -651,37 +663,33 @@ static int hmm_do_fault(struct mm_struct *mm,
>  		fault_flags |= FAULT_FLAG_WRITE;
>  	}
>  
> -	for (; addr < end; addr += PAGE_SIZE)
> -		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
> -		    VM_FAULT_ERROR)
> -			return -EFAULT;
> +	for (; addr < end; addr += PAGE_SIZE) {
> +		vm_fault_t ret;
> +
> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> +
> +		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> +			*hmm_vma_walk->locked = 0;
> +			return HMM_FAULT_UNLOCKED;
> +		}
> +
> +		if (ret & VM_FAULT_ERROR) {
> +			int err = vm_fault_to_errno(ret, 0);
> +
> +			if (err)
> +				return err;
> +			BUG();

Linux will be upset if he sees this.  

if (WARN_ON(!err))
   err = -EINVAL

> +/**
> + * hmm_range_fault - try to fault some address in a virtual address range
> + * @range:	argument structure
> + *
> + * Returns 0 on success or one of the following error codes:
> + *
> + * -EINVAL:	Invalid arguments or mm or virtual address is in an invalid vma
> + *		(e.g., device file vma).
> + * -ENOMEM:	Out of memory.
> + * -EPERM:	Invalid permission (e.g., asking for write and range is read
> + *		only).
> + * -EBUSY:	The range has been invalidated and the caller needs to wait for
> + *		the invalidation to finish.
> + * -EFAULT:     A page was requested to be valid and could not be made valid
> + *              ie it has no backing VMA or it is illegal to access
> + *
> + * This is similar to get_user_pages(), except that it can read the page tables
> + * without mutating them (ie causing faults).
> + *
> + * The mmap lock must be held by the caller and will remain held on return.
> + * For a variant that allows the mmap lock to be dropped during faults (e.g.,
> + * for userfaultfd support), see hmm_range_fault_unlocked_timeout().
> + */

Add a comment discourging anyone from using this function and prefer
hmm_range_fault_unlocked_timeout()

Other than the concern about the timeout and minor nits this looks
fine

Jason

