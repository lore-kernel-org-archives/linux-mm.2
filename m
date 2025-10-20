Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A32CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EA88E0026; Mon, 20 Oct 2025 10:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF0C8E0002; Mon, 20 Oct 2025 10:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487F18E0026; Mon, 20 Oct 2025 10:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33A888E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:12:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04B805641D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:12:45 +0000 (UTC)
X-FDA: 84018683532.09.78515FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 92A2C40003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:12:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N1k1w/RT";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1SLWf+q8pqu9k/Xw2FidgUt4uiKg7Qzo/H06ERg2kQ=;
	b=Ipq9ONBmpCw4pMSRQNJlCvwXxQTiR6iR/2XOeNlCqLnnG1FI3oJbLebNzNHQwLn6rH2JhU
	E4LUN00BaOn12VD/1r+E4u6GE1hK4/4/K5CgrktpWxHZEt+sgS2oI0ZHxmZpWPfOkuFDMe
	YASB8F4XJ3SWOSF4m8Y9kao9seJ/NOc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N1k1w/RT";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760969563; a=rsa-sha256;
	cv=none;
	b=0hCnjERvwMmrltUobsqhOsrTTFYL5wzFq3uC37LhXy8wg7e9ffZNI7rwGIgwN3duMiTH2v
	GgXuXp8E68vFunuICnobxpYXr8svMppP7ZWDVYPp7tnUcznDgZD5XhlJV4HciKAbuuyAa1
	yxW7j3D3ocDOkOjdj2bur73Ow0AoPjE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760969563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1SLWf+q8pqu9k/Xw2FidgUt4uiKg7Qzo/H06ERg2kQ=;
	b=N1k1w/RTScwkxltY8Pz3tGTv0koqE59lbZ4u0wdFFkzUGniepavdj4BjFUzc537GxlpOra
	RYzzrrCRpLFM7l7Yau4MpD9hy5xJWQsAswPx0tv29Mr+J8X5dIA9zE+QInjuFR1RBUplk1
	EqGa/vU5we5gheo9qgJhqnuQ1eJ3lOw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-j09QRk6xPqG-6S8ez-FkyQ-1; Mon, 20 Oct 2025 10:12:41 -0400
X-MC-Unique: j09QRk6xPqG-6S8ez-FkyQ-1
X-Mimecast-MFC-AGG-ID: j09QRk6xPqG-6S8ez-FkyQ_1760969561
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-81a8065daf4so81555936d6.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:12:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760969561; x=1761574361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1SLWf+q8pqu9k/Xw2FidgUt4uiKg7Qzo/H06ERg2kQ=;
        b=QyEfSKBW2haWTsZFWT7gTFnG0UNb+N/VgYkDhaY2o3Bbi9w/5dL8tcDbnn04KUbsWw
         P4fd3EWHotNxorJEM3GGFfVDKVWQYSwLcOmz+hgjq43dQ4Cdu59l5ICl6JyIe1dvc9D2
         emgC9443Xtb1+7wMe9to/+pJAcgKiQinf1Kgsf14hN2BU1g4g9ze4KLlVpuyfoxBGunR
         tTms/XwcNg04O2pzhErgC6J7dWmw6/qbKisO1Qz/sXzpu156HZx09by6TMBixt7c6Cvj
         BpDAUABy0eBnMNF3BP1eCw9cnwBfcRF4pM5XDWM0uFCOjhr/8wr9k13udoje/xozvS2H
         gLAw==
X-Forwarded-Encrypted: i=1; AJvYcCUL4/EpnB3aLfWO+8/WFxExh4vZMMGOoLbxE50dnWsmT9j39B48cnyKOx9vba0W7h4eJLe2CbV6ZA==@kvack.org
X-Gm-Message-State: AOJu0YySPTs3mqWPu11mJppnR8fDerrYJ2k+Mj6p7XbSF3wgENvxuuHp
	koX4Uido8udQj4tXy3JTuMy71ZZ6608FNhk0r1yKxcLPn5fvb7OQFp23/RM1mo5IzpbeXDGZhia
	/9DHkRdPiSy8k5/wtDHB1RFo1JnLbEqmSgrCmSSvONGSPSA7LRD7a
X-Gm-Gg: ASbGnctlY5NsYTXVO57HQDVParfK/CX4Nl/fLv4Ksc7R8fUrFLE9NkoNFQdjehZD3v1
	1yacl4cxdI8ZeUBGMfE/u72zoV1m6y5UvSAQsC9/d+wGMqMobvyuC9mmBOLRYZITk/ZPAPLTaki
	pxOhTrIwYLpAv/8aMf2gBaLTeLLEuuq/S5tlMIPFmTib4fIHV/K9mCiO0oixUhmOk03LkWR6yIJ
	GY3iBHcevLpBNqSjOrPkbnVd+fCthBR51pDJaOgFC2TxmRIydq7ELwrIaW+ExvhJI+i7WJ2Gvw0
	OFeGWOHlSiF2F0ubdrTnEwzeLBCgdm5xTm3YMNVqPw/NJlC/ymrqQb4gHJQ8Go6Li7k=
X-Received: by 2002:a05:6214:d8f:b0:87c:43f0:374a with SMTP id 6a1803df08f44-87c43f03a03mr110220716d6.29.1760969561078;
        Mon, 20 Oct 2025 07:12:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPrzPkMbuISrfnHZgsrYNiZtDHPQtpyHP3udmFtcHznS6vhG46dJMdI4kcVza4Yso3LXCMzA==
X-Received: by 2002:a05:6214:d8f:b0:87c:43f0:374a with SMTP id 6a1803df08f44-87c43f03a03mr110220286d6.29.1760969560391;
        Mon, 20 Oct 2025 07:12:40 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf52209cesm51317176d6.23.2025.10.20.07.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 07:12:39 -0700 (PDT)
Date: Mon, 20 Oct 2025 10:12:38 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aPZDVuscFsYSlQjI@x1.local>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
MIME-Version: 1.0
In-Reply-To: <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JULapz-P66h3PmRar3pc8EIWDnv3Za4q1QXYlI3x5zA_1760969561
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 92A2C40003
X-Rspamd-Server: rspam03
X-Stat-Signature: xors5ompzoch7qopbw94441acepi33m4
X-HE-Tag: 1760969563-459941
X-HE-Meta: U2FsdGVkX1/XDWCcbR9koLoJjR6Zdtl7tOMMKxsO+N6qdocYVIOaeNtYs/g+8BDAxp4xeDEz0ELtLIvgJMxWlAfwGLdc4ypmyVA8mdAdLaZOUn2TIsj7uiDgPdfcyHZ+2BhMzRgTiL75YeLh48CaG8pEivc6D7h1wEU99kUUoD/ANQXcwTl5jGADeN5KTgaCbLoiMvgEuqLvvNgP6YdJM53ZEbp2X3kaJSnb6vAd0uFfa0EA0E+/mgefq7BVJo+BUx5I7XtRhzEQXvB4y1Dz9TnURz8O/qOjeEUkoVDi93xARTtSzI/VKdEArxJbcOfqFLaKy2OoMIMPcE2p96YLch4iIWRUAJhWWpyeL8ghGRfy4zdxUdd42/zZ5+GSH6hyd2qZaaFMSr1YTGSxViAt7QuSb1h0pB0L1UuvKJd9IgOMzBHgE0h+z0+eiz5tgQKDwfJCEFc0AL0A6uNXiJYftqDJLgWYkZzeVULSj2O4VW/edQ4iZv6HY+9PRjboF6I1UnRyAF6TrSFIBUHmNXSoWrLYvX/UH0a6gDd3xw1WCDVYNZ2RbK+gISfF0MpZxrJBD1XervH48dyK0wm0wRuG8Mo5Lf5Yp4emq15PfxArvp+TFgMLfeRBEPbhKlbJAjRNMd+W3O7FtavGBfjjaA8wW26nTMmdwBC6LawoaM46fzOD5x/u/Boko3ulzFHJUjZKM/roJnUrUzk11XMKeFpwmYXSd5EvZM3aAfByvWSPujNPlF7GJp4u0xcDY0giXIOQx9fSmrXBvyEHMFhlYxMyJOK8nxtRpMwuTf91sf03R6q8yjpizlKbDAPZKh2+ZYZwn+I7gnDhg23/b60cMyjJx+40h8MM0n1xwPP6fra5crFTALxrbEXf+NMC6mQPAcSThvHFsZ30Yos5ndEBNjzr83iYpzftkTMMI/A5hL29RIH8OIJm7VYW9VQ7Hg8M/50PCx3/NnkAPJBcgfsKnnc
 j7o2QAMa
 FGLXg4s8jdEk0cvyBdGghTrshVrOxUqX7D0GZQ75uXi268UWgRqjKsfgjVeBiJZIbXOiTq/iwft55vielL/gg3F7DRxkf83VB+zpf7uvidCYt6Zd6iaJUIBRraS9oBZoGvGjIHcRBa4GVQsNrmUzdV18joBbuEE2/w38e+Iq1WVQh3xzz3pjgWhaUNWQi7G0/dClpch+iuFDakLHcaXJTzTGlA1qXc5bXUPtcfLIlwjCUPFW9UNH5p00/AiKjZhPZbHup+YkofoiCYj+hcSbkI0cAyMHACC2OYzXlO+xtkOHD4G5iIfsPLq92HpAN0P6wwQLADaYzqM0CvmsbJMN3QBsPq9yY2BR29EkwfwtQzK+o6eGklJfm/X0GPGz+dyV2nTADX5L9PsMjfIT6d6iW5XP2iEQm0FykAJyCecwuQ6rBH4d+zOtGox9oeJolN7etq+PmxfzOAPTYjiBpxwzlFxj0XTJSVgBwac3g1UPB/1tYUJJICnKWoU3WAbzw55B940MD7N3kcS6bl8ndVR0YwJSMLNSXSK76GKy7g3KyMieBEDbRRwbVDJwbraxA6gYV+X6B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 03:34:47PM +0200, David Hildenbrand wrote:
> On 15.10.25 01:14, Peter Xu wrote:
> > [based on latest akpm/mm-new of Oct 14th, commit 36c6c5ce1b275]
> > 
> > v4:
> > - Some cleanups within vma_can_userfault() [David]
> > - Rename uffd_get_folio() to minor_get_folio() [David]
> > - Remove uffd_features in vm_uffd_ops, deduce it from supported ioctls [David]
> > 
> > v1: https://lore.kernel.org/r/20250620190342.1780170-1-peterx@redhat.com
> > v2: https://lore.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com
> > v3: https://lore.kernel.org/r/20250926211650.525109-1-peterx@redhat.com
> > 
> > This series is an alternative proposal of what Nikita proposed here on the
> > initial three patches:
> > 
> >    https://lore.kernel.org/r/20250404154352.23078-1-kalyazin@amazon.com
> > 
> > This is not yet relevant to any guest-memfd support, but paving way for it.
> > Here, the major goal is to make kernel modules be able to opt-in with any
> > form of userfaultfd supports, like guest-memfd.  This alternative option
> > should hopefully be cleaner, and avoid leaking userfault details into
> > vm_ops.fault().
> > 
> > It also means this series does not depend on anything.  It's a pure
> > refactoring of userfaultfd internals to provide a generic API, so that
> > other types of files, especially RAM based, can support userfaultfd without
> > touching mm/ at all.
> > 
> > To achieve it, this series introduced a file operation called vm_uffd_ops.
> > The ops needs to be provided when a file type supports any of userfaultfd.
> > 
> > With that, I moved both hugetlbfs and shmem over, whenever possible.  So
> > far due to concerns on exposing an uffd_copy() API, the MISSING faults are
> > still separately processed and can only be done within mm/.  Hugetlbfs kept
> > its special paths untouched.
> > 
> > An example of shmem uffd_ops:
> > 
> > static const struct vm_uffd_ops shmem_uffd_ops = {
> > 	.supported_ioctls	=	BIT(_UFFDIO_COPY) |
> > 					BIT(_UFFDIO_ZEROPAGE) |
> > 					BIT(_UFFDIO_WRITEPROTECT) |
> > 					BIT(_UFFDIO_CONTINUE) |
> > 					BIT(_UFFDIO_POISON),
> > 	.minor_get_folio	=	shmem_uffd_get_folio,
> > };
> 
> This looks better than the previous version to me.
> 
> Long term the goal should be to move all hugetlb/shmem specific stuff out of
> mm/hugetlb.c and of course, we won't be adding any new ones to
> mm/userfaultfd.c
> 
> I agree with Liam that a better interface could be providing default
> handlers for the separate ioctls [1], but there is always the option to
> evolve this interface into something like that later.

Thanks for accepting this current form.

> 
> 
> [1] https://lkml.kernel.org/r/frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy

I have replied to that, here:

https://lore.kernel.org/all/aOVEDii4HPB6outm@x1.local/

If we ignore hugetlbfs, most of the hooks may not be needed, as explained.

If we introduce hooks only for hugetlbfs, IMHO it's going backwards.  When
we want to get rid of hugetlbfs paths, we will have something more to get
rid of..

We can wait until some use cases to appear, that may help us to better
understand what might be more suitable to be abstracted. Especially, if
there will be any consumer for missing faults.  However if guest-memfd has
it optional, my expectation so far is there'll be no real demand on that
for the foreseeable future.

Thanks,

-- 
Peter Xu


