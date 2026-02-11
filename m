Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2417ECD6E0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102DF6B0088; Wed, 11 Feb 2026 14:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB9E6B0089; Wed, 11 Feb 2026 14:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29746B008A; Wed, 11 Feb 2026 14:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E30816B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:35:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D858D6CF1
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:35:41 +0000 (UTC)
X-FDA: 84433180482.10.AE419BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13A8180016
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:35:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=baG4KHJq;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770838539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHfswB8BrOCWLJXsVwUk+XHyA8BLSR/huUJvBA9oUpg=;
	b=rd/6Ee28dRBRLs+5irfRGC0OqLO9cprlHYrUy7fe9XCwN7f/XGDFap/N+f8AR4lNf6NrnT
	r4FiZVYxVKUz3B063FWDg0dCv+DaPM8bI4afbIVeSYYDx44kbJiS88SNSmKJXf6vjYOHLS
	lBXMxu34KaZ5bmSu/c61/cy0JzKDY+8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=baG4KHJq;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770838539; a=rsa-sha256;
	cv=none;
	b=xfyMnP/XT3UWCJTh33QSeik5Gly1J2tH2TZE14GHP3a4qZd65x9uXidgLJvJ3DvQ4NOYD+
	e7bFYOsEf7wsiLOreQXVg8htLksEAYnRF0yNvtrZezIA9e9PxNtt/nkKGwXxXA+xjD0gI+
	Rd52ovrAuyC6SAM+fh6iAesqmSI2Jpk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770838538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MHfswB8BrOCWLJXsVwUk+XHyA8BLSR/huUJvBA9oUpg=;
	b=baG4KHJqInD+sIF+F8t0TEtdyb5leB8tDvQ04fXgR8vMXhpBJMOJssxvE5wVKZanDW4cd4
	ZuZfIpAG0visRLJDTUR1ewemqd04+EUx5DTp2rUZlsv+rW1MfrYbxvwc+S1bSglYY3hI7P
	geBMa+inEvOTAGS8/0kghzqwelX94ls=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-KhzZXpzPNMW1--51S9kmBQ-1; Wed, 11 Feb 2026 14:35:36 -0500
X-MC-Unique: KhzZXpzPNMW1--51S9kmBQ-1
X-Mimecast-MFC-AGG-ID: KhzZXpzPNMW1--51S9kmBQ_1770838536
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-896fae4073fso32157796d6.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:35:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770838536; x=1771443336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MHfswB8BrOCWLJXsVwUk+XHyA8BLSR/huUJvBA9oUpg=;
        b=uqkhujj8TG9Q3JY9V2jNDe0/6gX4iVKvbHDSFntbBU1NRr4BYKpaxD1ioF4OAHCn+N
         JQ6s/hU0m2w9WF9H5Q1xMjfBu8gj7Y79OjibZI3aC2fE4wIkfWVV+pSskXr5JIejo3Hd
         uR/xNlXVV0jDOfA1VC1UUD9WSz/jVh/aUIw6nEvCbi+gm80jTxFNorfYHTdi8tJb4Hkl
         yPJAzPT9PFWTC+2BFxhiBDDTfc3crfleh+7nUywYb0ChccEndGXY31/JMlDdbJbJ8V2S
         gNYriGrRKdzHOHE/MKhQX2pSpRrxd1ro/xPOAx1Hjebe36o7l7jTrU8lllHQefdN2D2r
         +Y4g==
X-Gm-Message-State: AOJu0Yyd+USqItdoV1ADV5O+gnIbSRdKkJHqsofEakd3Fv4MbuWbpbrj
	x9tkspEGvxpVh42+3YH9wu7ZxGYkI60syYuuzTGB7aID9XLJ1Nw2sd81S4ClBjvtm0EM80IKjap
	oaxqxC92sAN9nwFnwhEXQhI9Ns34gqlhvfG8uU3f+4Bo8ZoH/gKiC
X-Gm-Gg: AZuq6aKLu3OdsaALdfeht65ILC8PNHM7S9sMSGBm+8KkenXGu2yT/ZcoczcYpdFb5f1
	/YDZwMWyGcglSnGAaeSZHfUkXJZ335Hx/pwv7crmvsr2Ld3+Kb0zzWjp2PY0cU8dDo7CBNovlBp
	segl46CYt0MfQBUtF3zFfgbtnubWaGb3JvSwiTazf5iUE68C5wLonbGcxoguA+G3QZfw1FTpUVS
	5z4jho4LJEEPp8T1xNnjUQ+dMnjrl1yjv2yTq4N6sqz9MKQnzKDO56yWwNjo6qzIQ4iPikaxuGz
	EK+7Zr08J6lD4yj/WT4lZ+IbyIYcn5qHv5oEbcEzPGw225YvUILBb1T52MX0XKRNhAaLkhQAGvi
	SmB4K1oKRz9IFoA==
X-Received: by 2002:a05:6214:e66:b0:896:a692:caba with SMTP id 6a1803df08f44-89727899bdamr10537116d6.31.1770838536107;
        Wed, 11 Feb 2026 11:35:36 -0800 (PST)
X-Received: by 2002:a05:6214:e66:b0:896:a692:caba with SMTP id 6a1803df08f44-89727899bdamr10536576d6.31.1770838535519;
        Wed, 11 Feb 2026 11:35:35 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cdb19b6sm22142416d6.40.2026.02.11.11.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:35:35 -0800 (PST)
Date: Wed, 11 Feb 2026 14:35:23 -0500
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
Message-ID: <aYzZ-zBipYQ2OA_n@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
 <aYEY6PC0Qfu0m5gu@x1.local>
 <aYhh2XzyFsJbohll@kernel.org>
MIME-Version: 1.0
In-Reply-To: <aYhh2XzyFsJbohll@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -T3Hs0SEcLdJAQWFmIG3okgFSGMq74of-yTj1eOKQJU_1770838536
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 13A8180016
X-Stat-Signature: 3syq931nwycckahow46wf7t669py7pb5
X-Rspam-User: 
X-HE-Tag: 1770838538-810258
X-HE-Meta: U2FsdGVkX1/RFyOW+2e5AyBWDC9BAxiHAjLSMeoZiykqi2QYWP2dLZvyB/AkfCDCdFlmI9bTNNYnvsNltxBOPBzy7IP4fhe2XH3KHNX61X+F74fbretCeyfpyURmfWZBbANHCTABZzdlQ+z9q/EfJ3clHTlftuo0BZl87fu89nYo3uTQp1rIxFfEv5mwvyDX9HCv1ctwr/FwhoniJjOqOxAVnY96X6rTFzl48lqGyhKLr9iFABwlKvZqjfTZ9W5LPAKC0vrHeJCFn1IjmJnQ4Z/tnU4xpFaRj91m2YfM8JfjKvQBty4fdVyEMs/cZom4/+J8ShWYjFuA7JxTFHV81edC8nJ8grARGQM8hDDycEhZ3UDshgGFleFH4r27dU6NrUpYYbqyUqGh5M8DYhhKBla/9721OD5arApWC8FzFnWgyh3/CuldpQmXvMtJ79Sm86FjX88E1DoVWJdmcn4q2mqshdybbZYfoeqFg2N0r9tN0+Q4R5XfFOXlBfJck8Q04y8CyagMVNXeTxCgFa+Ii7Rf182m+6VLRh3hoe2RdncJFGoc1GHs+I68l8xlDyDnQZ/fiYG/+EOD/ek09/hoBlCCKMbC25aPi7NyZxz4AxAIg7eK6RtbR00OrsOA4BiT4TAMdB8RuKM/2kGfWlTbWO0Z3BNYJf1l57NBvWFLSrbuRBTEJeGRuM6DyaSZD5syBxjJ7qeNzgeABcF925i/3CKLtW0BRXkrA4b47a2g+HQSrXjZkjadqwplDVeIwl0jbNKdrmcdbJzmWw5Qb93Ttc4CaZvyfmZktApCNUALkK2AmLSMmTl+xOMX9GoBqi4Lw5o8DkksijV4R+HWcgugQ1Z21F5LHdyqpHOlmdlxidD9L3fUDwQgTTX48sJU/UmOciQbQa71MFxDPalsr7+CHRkz2MM9rtXuWyLuScwdcHUdHZGbhBiCJ/nt3nTbVm960+1KvivoJXm1SVkvQpk
 mo6sZ+m+
 J6YaIgrrPOiS5pskTw6y6CMydPEdiCyn7M0Bv8UvlpMbCPIsQM8rcClrA5enOsBgPn40z9oF1cLZZXxcjG2KGDuWmeh5csV+s0CThmpsmPXutR8Ik2++AdURAPVhAHBDQHmnoaOx3MIm9pdI4WYeO6hDlEJP1FVIbcOXt3He44tUfA7hjxglRPVodH0NW3ocmQKsJ1uhRyQ4FHZsAO4GWMb/coCGvb3YJow7EonY9541Hrg9movaq0c4PfMe8WgxqNO4p+swVMlDPEwqELUnxLwMDwWu8ZrpnpDAXK0MM+GwRLPfQK/qKvsOeki56laCjVDblfyZq7q6JMJ20GN650jF7UC9GJUQxjjnC2Rn196etZthbo9Rx8X/EnUWH3jygQIF8fcjPOn6l3OdBfCsw8HEUO5pmIvScJaoQ4syhOcI+Rl2A7nWtTb5AxO46CYzHsERzfYsS9/oCspg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 08, 2026 at 12:13:45PM +0200, Mike Rapoport wrote:
> Hi Peter,
> 
> On Mon, Feb 02, 2026 at 04:36:40PM -0500, Peter Xu wrote:
> > On Tue, Jan 27, 2026 at 09:29:26PM +0200, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > 
> > > Current userfaultfd implementation works only with memory managed by
> > > core MM: anonymous, shmem and hugetlb.
> > > 
> > > First, there is no fundamental reason to limit userfaultfd support only
> > > to the core memory types and userfaults can be handled similarly to
> > > regular page faults provided a VMA owner implements appropriate
> > > callbacks.
> > > 
> > > Second, historically various code paths were conditioned on
> > > vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
> > > these conditions can be expressed as operations implemented by a
> > > particular memory type.
> > > 
> > > Introduce vm_uffd_ops extension to vm_operations_struct that will
> > > delegate memory type specific operations to a VMA owner.
> > > 
> > > Operations for anonymous memory are handled internally in userfaultfd
> > > using anon_uffd_ops that implicitly assigned to anonymous VMAs.
> > > 
> > > Start with a single operation, ->can_userfault() that will verify that a
> > > VMA meets requirements for userfaultfd support at registration time.
> > > 
> > > Implement that method for anonymous, shmem and hugetlb and move relevant
> > > parts of vma_can_userfault() into the new callbacks.
> > > 
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  include/linux/mm.h            |  5 +++++
> > >  include/linux/userfaultfd_k.h |  6 +++++
> > >  mm/hugetlb.c                  | 21 ++++++++++++++++++
> > >  mm/shmem.c                    | 23 ++++++++++++++++++++
> > >  mm/userfaultfd.c              | 41 ++++++++++++++++++++++-------------
> > >  5 files changed, 81 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 15076261d0c2..3c2caff646c3 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -732,6 +732,8 @@ struct vm_fault {
> > >  					 */
> > >  };
> > >  
> > > +struct vm_uffd_ops;
> > > +
> > >  /*
> > >   * These are the virtual MM functions - opening of an area, closing and
> > >   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> > > @@ -817,6 +819,9 @@ struct vm_operations_struct {
> > >  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
> > >  					 unsigned long addr);
> > >  #endif /* CONFIG_FIND_NORMAL_PAGE */
> > > +#ifdef CONFIG_USERFAULTFD
> > > +	const struct vm_uffd_ops *uffd_ops;
> > > +#endif
> > >  };
> > >  
> > >  #ifdef CONFIG_NUMA_BALANCING
> > > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > > index a49cf750e803..56e85ab166c7 100644
> > > --- a/include/linux/userfaultfd_k.h
> > > +++ b/include/linux/userfaultfd_k.h
> > > @@ -80,6 +80,12 @@ struct userfaultfd_ctx {
> > >  
> > >  extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
> > >  
> > > +/* VMA userfaultfd operations */
> > > +struct vm_uffd_ops {
> > > +	/* Checks if a VMA can support userfaultfd */
> > > +	bool (*can_userfault)(struct vm_area_struct *vma, vm_flags_t vm_flags);
> > > +};
> > > +
> > >  /* A combined operation mode + behavior flags. */
> > >  typedef unsigned int __bitwise uffd_flags_t;
> > >  
> > > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > > index 51273baec9e5..909131910c43 100644
> > > --- a/mm/hugetlb.c
> > > +++ b/mm/hugetlb.c
> > > @@ -4797,6 +4797,24 @@ static vm_fault_t hugetlb_vm_op_fault(struct vm_fault *vmf)
> > >  	return 0;
> > >  }
> > >  
> > > +#ifdef CONFIG_USERFAULTFD
> > > +static bool hugetlb_can_userfault(struct vm_area_struct *vma,
> > > +				  vm_flags_t vm_flags)
> > > +{
> > > +	/*
> > > +	 * If user requested uffd-wp but not enabled pte markers for
> > > +	 * uffd-wp, then hugetlb is not supported.
> > > +	 */
> > > +	if (!uffd_supports_wp_marker() && (vm_flags & VM_UFFD_WP))
> > > +		return false;
> > 
> > IMHO we don't need to dup this for every vm_uffd_ops driver.  It might be
> > unnecessary to even make driver be aware how pte marker plays the role
> > here, because pte markers are needed for all page cache file systems
> > anyway.  There should have no outliers.  Instead we can just let
> > can_userfault() report whether the driver generically supports userfaultfd,
> > leaving the detail checks for core mm.
> > 
> > I understand you wanted to also make anon to be a driver, so this line
> > won't apply to anon.  However IMHO anon is special enough so we can still
> > make this in the generic path.
> 
> Well, the idea is to drop all vma_is*() in can_userfault(). And maybe
> eventually in entire mm/userfaultfd.c
> 
> If all page cache filesystems need this, something like this should work,
> right?
> 
> 	if (!uffd_supports_wp_marker() && (vma->vm_flags & VM_SHARED) &&
> 	    (vm_flags & VM_UFFD_WP))
> 		return false;

Sorry for a late response.

IIUC we can't check against VM_SHARED, because we need pte markers also for
MAP_PRIVATE on file mappings.

The need of pte markers come from the fact that the vma has a page cache
backing it, rather than whether it's a shared or private mapping.  Consider
if a file mapping vma + MAP_PRIVATE, if we wr-protect the vma with nothing
populated, we want to still get notified whenever there's a write.

So the original check should be good.

I'm fine with most of the rest comments in this series I left and I'm OK if
you prefer settle things down first.  For this one, I still want to see if
we can move this to uffd core code.

The whole point is I want to have zero info leaked about pte marker into
module ops.

For that, IMHO it'll be fine we use one vma_is_anonymous() is uffd core
code once.

Actually, I don't think uffd core can get rid of handling anon specially.
With this series applied, mfill_atomic_pte_copy() will still need to
hard-code anon processing on MAP_PRIVATE and I don't think it can go away..

mfill_atomic_pte_copy():
	if (!(state->vma->vm_flags & VM_SHARED))
		ops = &anon_uffd_ops;

IMHO using vma_is_anonymous() for one more time should be better than
leaking pte marker whole concept to modules. So the driver should only
report if the driver supports UFFD_WP in general.  It shouldn't care about
anything the core mm would already do otherwise, including this one on
"whether system config / arch has globally enabled pte markers" and the
relation between that config and the WP feature impl details.

Thanks,

-- 
Peter Xu


