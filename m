Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E70C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BFC56B0005; Fri, 10 Jul 2026 13:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270B66B0088; Fri, 10 Jul 2026 13:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160CE6B0092; Fri, 10 Jul 2026 13:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E15276B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:06:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E09E1C3904
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:06:50 +0000 (UTC)
X-FDA: 84973496580.02.142558B
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id A8D5F1A0008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:06:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KUS4CR7q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783703208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SpFBfA7wdgGokfuzCR83lopKSZdMUZgccIdXLTCA/gs=;
	b=QYOTa1RGuVeq1DA7f8EQoC+eJ97g1G30/B/9EIIxvCOFU7gzl6vaJt8wjPXoD8QK+/mvW+
	1r7l+/vpCmq5y4sPqYhtFDyVOH7oHpAp6oUHyvd3D6cv0VY/xDO3scOUCsvhFn4ccn809R
	a2AUYDscQfyD3SiKOanLe0NiGzI/KuU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KUS4CR7q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783703208;
	b=d5eA5tJnDnvfK9SXxanonT0hdnZj+Q0a6xpxqPTArHYeI3+Dz0S5vHU8OdLLT1W99HDgoK
	Z0cfE+ZyGuoP9fADkSEWXuLwriuFA9QcYQ7Ldmd/K5oFniePxcnv7Z3E3Libh7DyxKZDGv
	XMiAkeFogpjoIXJbO/LrZJ/Vc+DJZt0=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84847f60deeso2034037b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783703208; x=1784308008; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SpFBfA7wdgGokfuzCR83lopKSZdMUZgccIdXLTCA/gs=;
        b=KUS4CR7qX5tVpcOqFzMqJiV/t02vD4JHf3qKjE34JIPOrJFKAKQ3T6zgmXGcxJgMm6
         NZfuNqJuk81v/lqi+psIyOF/ACtg8vI2WevjVsp7C+7EWK54s2gg7wCV5ErsCuq10cBX
         jn0Lf6NWApFvGa/z0QwGEXcksoTW0Om3jZQokjki1gSKU5ncLRrsZKT7TiPV0ywt1URB
         gW7qrHagPzCdbi+rl+V/lY0uDptA2Uk3nFRicBwZOjPshh1TM4ykMebqTeOFSxwRHa41
         fU6tGEv85mSp/maNfCRkOAYqV7wAfPKhnWd36mysXHxBFW6Lflsr8c/TUcGfmDd1lsVl
         SE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783703208; x=1784308008;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SpFBfA7wdgGokfuzCR83lopKSZdMUZgccIdXLTCA/gs=;
        b=hc+XJEs0u+kjdaEpmIyRf2LXxaq463KKzsDTow3Csaq3csioZ+PKaTZ9VuNDZ19NXr
         jQpHwIyEutiwCsmeoCix1jLvShnNJGm03xfSqeMT7191XG/5U3J2udCqpAyCiqPs0BaB
         6gc5ef2+gpIc5h9kXQrmgO81e8ztlyV9YIs2DRf9es3xdc/5Th7SPyN0a9/n3iipK7Z8
         LbmumLigQdWEl+ABssibO80doLfiwkNfzGEBK4IMUFlGThEX5+4JpvqVt9oThOBRJt60
         QkrMKN9uAbIXv7k0sDxxmCMlpUb/DoKN/LyYMlZSe2Ug69CaDjBkunezuktuoy+XO0oq
         f1WQ==
X-Forwarded-Encrypted: i=1; AHgh+RoYXROgHZxf93tLbQmba8UU9YG7taeoF7KH3OtPQSkPFlnS63J6N26+1iIqp54xY6+R3QumijCXfQ==@kvack.org
X-Gm-Message-State: AOJu0YzjKOfVAX2zoho+WGEQZl5ktzxwcP7kzTCHIjcPzSfBcpsT6Wad
	1svtAzgLTRNJvPijw+zq7mD9nGmYwFgV6705a/gF/f3aHSRYKx8KoLpH
X-Gm-Gg: AfdE7clP5KDstAJaGDhOOsHGoKB1qF4xOiOiKJYryVvI8E1iBI9qcETTmix7RCqxdZC
	728RElKrPEGuLdkXfUsGuP4o9QKdjnHBjFDUL4cA648e3lt+ETag8HazAVZA8hHXkrg/aBpLGxh
	Rib9Y3aP41xigIG6pE85g6W57SAbUjsoawXsXFChQjzFLQgo30rZoIznZtOmHo6WWZmJEvgwJHJ
	+CqlhCkmwCUJErl0pu0mkKGSCuKSVhGW62G5rppUb0omFXwgAMpsV4nbQ5i79JEDVin+zupy7Yl
	o0S9aDicJINn49dgo+rW4Qlgh5+shDow71uRMy9uSrZUQxE9D+icmRFbYRt4JcYKR64BFmO3JB6
	Qwek7rSyo3crSya+A1fSJWpfKuxqaFy0keF0PJPR7rFKgqKvizYAYvES6CGd3Ds3Ppaxiq37o7I
	9Z3sLJ09nyz0oVn9NVkF1hBvcRDFvYpZ9d9MT0939tWeq47CvRxNkH5QM=
X-Received: by 2002:a05:6a20:d494:b0:3c0:9acb:400 with SMTP id adf61e73a8af0-3c0f13a6583mr4025578637.37.1783703207546;
        Fri, 10 Jul 2026 10:06:47 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3a2e42bsm5458929a12.30.2026.07.10.10.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 10:06:46 -0700 (PDT)
Date: Fri, 10 Jul 2026 10:06:44 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <alEmpEv-Q_bQFzNu@skinsburskii>
References: <178345345668.660027.2952911919681614557.stgit@skinsburskii>
 <178345362182.660027.12809852179204464964.stgit@skinsburskii>
 <20260710163835.GR118978@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710163835.GR118978@ziepe.ca>
X-Stat-Signature: 34dtybxfq5znspagkpjs55ra1fdc8g9p
X-Rspamd-Queue-Id: A8D5F1A0008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783703208-894610
X-HE-Meta: U2FsdGVkX1/21AnvoVhqwX3zyXKg51ik1i/C5kUpw5nxCvaE/IzT8kuD0kA0pxexUEo+G0SuAYm4DfmEFfBk67rI1nPOFKkZmQvIUQZAgL2cGPZUfkEujbTlePJF8N48tcdD9fRa5Zm/7LGB4zt3iPUJrZGtzOH5slOXCGH49sZKx0/O1G0oaXBsRbzwCHiGVo0odgWi6Gci/gqJNKf2b7Gmj5vrCiPqM9vq+L/Ta1BzY625Xc8M2Kwrb7rivjXVLBxEd7oR5APDJaAZrUdeEwNtUkQrnReDYKiV31ZF3HAh5Ju9BE97HpnByaSez52w+2/IVmibff81TCiPcwcYxUlR116jUKRqfnAiYBJiztnhxMQQm/jiDDeOQGSm4eR4/eBn0CJRJQ6JSzTPMJY8xAk4fF90ITco6w8Fm4USZtq4FxtcmGxOIksamhNRKGLx3UaBmYGWud4zpGX1Uf3ZnqkWDZmuvZVVNxAzI8c6Fpc89HUmqStN6arBfP39xIAPUkaPq5QDkiLKXmGXn32VJJ903n030q1mEM37NfmwLPAS7HbZJ7hdkEsDD0157l1cUX+VOEB5kpODjv2pLVE+TA/9g+EBNQrT3Qat7vjQeKwT3IdHbRX0qwqY1Autr/6KVVDnKWnk+BkZyNgLXX0LeGRS7wEdpwNnjtk85ss0cjFEKJqQ5HAsrRdUSgliYPliTdS0dQ0zPaWaNfNy5ELxz8JRD4qti1uZafnc/Ukssh6V4YuP48hurymVQNs4X8LLE84SvAld2LuvL3u2VMDBiFb1bu2RHsuHrSwVBbIoAoQRr+EZxh9pWg2vlDNXf8FJ/ddZ9CuMt8Sjoy2YLGojWSlp4X0mNxS7tnJQhU5Kye4vr+kXruMuUx+TIp3emsHkCJiDRDf5RfmChssQhLzC9rrZ61hFflOiWdKnEZAejPTGLxQgD1PgpD1PtTJ3E6/5qI8lv8QRtox+NdTwV+w
 4W0U0wGU
 zb+3R4kwM1nAFNljHPDgb1qCd8v2Qt1GqSoReOGGTVWfBO8e/WpuyBoaapUfPbVlgOAqBXT8YLXfg1l8uR7sbsiLzwJIwrAlacziMWCfNTLwXoGH8Q2+x/tkeReGfzjyyBVP46gd4OV6X3Q6SKEOXzdsaZUgK5yGL4Bw99+Ij4HlTfbL5ms+3oAu6eRW+itrCADeGF2BWt2LsUkExs0VRNisNmcfwVqRYrmmWFTrjJHZxG8TUdCXTDZezEwq8v6oL0xGP5xI8tp9sa0om4J6PmLmR7N1Xo7q85nU1wycWChr0NtLXtBpyX1nrme/EP2qbKbqNqvX6fkyp0ZR+AbY571DAEjUnEoxnDAjJr/kZVwp2ruxXogtSgXFLzmEcqJEpdkjtnsl7qdD9jyMZdrwd6mt3y4rAvW6biJ+96wPccJ2vqgYksunYOSN8uAFNVhUkluDDqZNjX2j0ObGtgfa0LkYUR+d3/FEKWU2we4kqBUgfUFjCa3Jm5QgZwRPXPr76Q6TmGXX8MJfkLMIHTC48gvwvMpOIonHln0EiKkuY7N0S9wViEBCa68iJ7kmaSs8GEyjsRC/to3wlhJIydzchdKarGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 01:38:35PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 07, 2026 at 12:47:01PM -0700, Stanislav Kinsburskii wrote:
> > hmm_range_fault() requires the caller to hold the mmap read lock for the
> > duration of the call. This is incompatible with mappings whose fault
> > handler may release the mmap lock, notably userfaultfd-managed regions,
> > where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
> > after dropping the lock. Drivers that need to populate device page tables
> > for such mappings have no way to do so today.
> 
> sashiko could not apply v7 for some reason but the remarks on v6
> seemed meaningful, did you see them were they delt with?
> 

Yes, I dealt with them.

> https://sashiko.dev/#/patchset/178336023903.504354.7500950448226027718.stgit%40skinsburskii
> 
> > diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
> > index 7d61b7a8b65b..70885f153d03 100644
> > --- a/Documentation/mm/hmm.rst
> > +++ b/Documentation/mm/hmm.rst
> > @@ -208,6 +208,69 @@ invalidate() callback. That lock must be held before calling
> >  mmu_interval_read_retry() to avoid any race with a concurrent CPU page table
> >  update.
> >  
> > +Dropping the mmap lock during page faults
> > +=========================================
> > +
> > +Some VMAs have fault handlers that need to release the mmap lock while
> > +servicing a fault (for example, regions managed by ``userfaultfd``).
> > +``hmm_range_fault()`` cannot be used on such mappings because it must hold the
> > +mmap lock for the duration of the call. Drivers that need to support them
> > +should call::
> 
> Given the majority of callers use this API it should probably be the
> focus of the documentation and example, regulate the existing API to a
> 'BTW if you really need the mmap lock, and you really shouldn't, this
> exists too'
> 

Sure, I'll update the doc to reflect it this way.

> > @@ -32,6 +32,7 @@
> >  
> >  struct hmm_vma_walk {
> >  	struct hmm_range	*range;
> > +	int			*locked;
> 
> Let's use bool if you have to respin this
> 

Sure.

> > @@ -651,37 +663,33 @@ static int hmm_do_fault(struct mm_struct *mm,
> >  		fault_flags |= FAULT_FLAG_WRITE;
> >  	}
> >  
> > -	for (; addr < end; addr += PAGE_SIZE)
> > -		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
> > -		    VM_FAULT_ERROR)
> > -			return -EFAULT;
> > +	for (; addr < end; addr += PAGE_SIZE) {
> > +		vm_fault_t ret;
> > +
> > +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> > +
> > +		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> > +			*hmm_vma_walk->locked = 0;
> > +			return HMM_FAULT_UNLOCKED;
> > +		}
> > +
> > +		if (ret & VM_FAULT_ERROR) {
> > +			int err = vm_fault_to_errno(ret, 0);
> > +
> > +			if (err)
> > +				return err;
> > +			BUG();
> 
> Linux will be upset if he sees this.  
> 
> if (WARN_ON(!err))
>    err = -EINVAL
> 

It will. I copied it from GUP.
I'll change it the way you propose it.

> > +/**
> > + * hmm_range_fault - try to fault some address in a virtual address range
> > + * @range:	argument structure
> > + *
> > + * Returns 0 on success or one of the following error codes:
> > + *
> > + * -EINVAL:	Invalid arguments or mm or virtual address is in an invalid vma
> > + *		(e.g., device file vma).
> > + * -ENOMEM:	Out of memory.
> > + * -EPERM:	Invalid permission (e.g., asking for write and range is read
> > + *		only).
> > + * -EBUSY:	The range has been invalidated and the caller needs to wait for
> > + *		the invalidation to finish.
> > + * -EFAULT:     A page was requested to be valid and could not be made valid
> > + *              ie it has no backing VMA or it is illegal to access
> > + *
> > + * This is similar to get_user_pages(), except that it can read the page tables
> > + * without mutating them (ie causing faults).
> > + *
> > + * The mmap lock must be held by the caller and will remain held on return.
> > + * For a variant that allows the mmap lock to be dropped during faults (e.g.,
> > + * for userfaultfd support), see hmm_range_fault_unlocked_timeout().
> > + */
> 
> Add a comment discourging anyone from using this function and prefer
> hmm_range_fault_unlocked_timeout()
> 

Will do.

Thanks,
Stanislav

> Other than the concern about the timeout and minor nits this looks
> fine
> 
> Jason

