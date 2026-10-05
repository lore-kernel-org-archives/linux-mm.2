Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA45CA5FE2
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 04:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F308D6B0095; Mon,  5 Oct 2026 00:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1D36B0096; Mon,  5 Oct 2026 00:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6AE6B0098; Mon,  5 Oct 2026 00:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADC706B0095
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 00:59:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A47321C03A5
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:59:00 +0000 (UTC)
X-FDA: 85287368040.03.5575CED
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id DA6E940006
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:58:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TQRxipQT;
	spf=pass (imf11.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791176338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wh1AxkS8SWKuWWWh7pZFQjWGZF9aNJY94i0CrRQCRF8=;
	b=2XJg870lTI2rMN7bwkEWZf7d8RCYgyIq1dJPDflZPd3EReqATXMXaA6ZVRgyOk5YL1x4I3
	2a052xc+ZTopCuCIRG+AW+DZ2QfnUMfds0e08GCluWV5WjaHiUepZcIscAAZzNF/MedhQl
	EgXa8FFx9cNg1sa0+x/jFdKzyN8Akqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791176338;
	b=xP9QvAwqZpO3UHcVs5Ok+WDBZLg/1iiF7WsmTrofjY4lSWDM+QKZ8z0uF8Xpf7VGoxfzAZ
	Sp16m6yUH2DckoNFLQ5cfN0mNSskDVe+2YtYWcI70bZfQvEuWsspeFRgqw487RBlxxAEs/
	pd5UrnorCPatiz+FQ4pForx6wE1MSzU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TQRxipQT;
	spf=pass (imf11.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e2e4ef20beso59575ad.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 21:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791176338; x=1791781138; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wh1AxkS8SWKuWWWh7pZFQjWGZF9aNJY94i0CrRQCRF8=;
        b=TQRxipQTIT+IoePmfoOMZ+LqSo/Ojwc34p5QFmW5vrDgX+vhyWKxr/NJHHD7Mpk5nP
         7xriShwBQIbDeYG2Ye8KKct2h1BpZRA2344X4smc70CBjwejBkL4z4BxRfQ7yPmf7uSk
         3o3+2LirVpok0y0eF72WCBYeES74WqPANvCQfUhy9PDtLLuLqmqTvXmOKlBn5ZqVDtoT
         2ZJoRe52xis4I4od9zoX63FiBXae5rl8Bcv1WrWu/RcMLezeBForYgKVwtdBLPY3/BL7
         DvvuDCgsmensqD4ZPz4DC2Ck1RsCiqaSZjeNSGXMiGsj6x5eippn1lwBfvG79JvVZ+He
         dyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791176338; x=1791781138;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wh1AxkS8SWKuWWWh7pZFQjWGZF9aNJY94i0CrRQCRF8=;
        b=JcnAAJ4I06lGL4TDSeTO4OXu0SoWG349jQ4fkstAMbyEFCDGRSLaffjT+ijBb8Jrvs
         n+Q7sTVtpRQM0CfsTsezJXnsqLCZgThJm2zHyUm9Z9hIYbHbR4UxkNDOV1DyYfI1yJ5P
         80Qtb7qIuvc18N1/CvRrup3++T/YexEbAyzS+jXoTOtukHu+CkHmaaOaWS6txVaT7fRb
         EZZshEaUth0mk2e/CzHk5pmFv6f+00fAE+djK9DmRFxzx+l28plx+3+gUHRjAeNGFMk8
         AaUqeryP5ifBZWih6iZTuQKDjYHkmeln0w0+vZnQUoJLVkATxUiPsEMPWpo/B5MyFUg6
         cxmw==
X-Forwarded-Encrypted: i=1; AKwUvBwObAJMTUBfdZVzNC9FrF1i2jJGZUYw9RGQV+FWJbzBLY9QLpkXa5LMMbbc2Jz/r+k6Hwv2tGCrXA==@kvack.org
X-Gm-Message-State: AFq9FYLDF2KEG33SHYOHT8QqLF/EWS2u68bc73Rj4Sq3P0PVtJ6YwYZy
	Wket84ffdgas7fO/9qka7tk6JM8+3kyKaUBKWsDpGu3KAzs6XYNrSgkTFPe1F3gzDg==
X-Gm-Gg: AYBFou3px9j6rtn+25BsOaU/j+tbDJkCacO1Z4lcQz7miN6/sfZJv1LA/PI77/HJy5+
	PJrLFYeMCnnMa7XeuT0tzj4C0Gq7FID75st9Ku7QTSWKiwYEoolgWGNtt+1OhBillUvDs0VV7pN
	wpDxUvQKQCvR2mT1UNDeZ5VSlR2ha0CRrR2J6xcNCL/jDG2zMerSIzPEl3RBpoC8s+sG3UskVZT
	tEi1CtmuXAufebtjzMAaTVbi9vXnqNooABt4WH9t58bB4tX0QT+sviOAlS0/Z4rw4c0Kjthlo3+
	Jb7peVidyRmMZHLgUpW46CkHevO1LiRu66UWAS6ss5qCX/D+Q/Fu/0b2lmU8G5camzk3HBJ2rkw
	vE/xSBYXIlsMcAIdca/D7Nr2IktDtbpWNBGnaJvx1hHg4uQKwuDCfnnZeTouDbA6fNX/WQxhymp
	KjHZEX5sm0+wnUC39pN2yOOYe8f84PW36tpKGb1PzuP2w9LDu8AIiGvKBDyLCHIxCnzp/n8kJ48
	bSRPS4bwCftUr4Ez8gjmTteQzS1hpPe9XMD
X-Received: by 2002:a17:902:d987:b0:2d7:1cc3:a69c with SMTP id d9443c01a7336-2e5339b60b6mr5288515ad.7.1791176337084;
        Sun, 04 Oct 2026 21:58:57 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cce6d901a2asm185534a12.17.2026.10.04.21.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 21:58:56 -0700 (PDT)
Date: Mon, 5 Oct 2026 04:58:50 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Mostafa Saleh <smostafa@google.com>,
	Daniel Mentz <danielmentz@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Logan Odell <loganodell@google.com>, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] iommupt: Introduce IO page table shrinker
Message-ID: <asMuigioXmHZmjO2@google.com>
References: <20261001230219.818128-1-praan@google.com>
 <20261002150844.GC3481470@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002150844.GC3481470@ziepe.ca>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA6E940006
X-Stat-Signature: gqpppyesw4jyikpchgwshtuzjnoffx1e
X-Rspam-User: 
X-HE-Tag: 1791176338-577805
X-HE-Meta: U2FsdGVkX1+uXx/vujAJEBlEd4QFmFXes4Ar3N/Aj7VBPu8jZgLw/56bHPnb9BiBa4oeNsZ0YWqJu2a+kjaSSiZPOb5lQRzo3ZRsNjgxwmLyKRHG05I/pVQe+2S9RFv08/+ZQKO0+llrUvk+4zUG7f7vkymexMAgumg3WjJcUv167GOSttKGeRWRiMKAuvniZ7RaSKMwtll1hqE9C8nGWGoUFWmYvgaVe7PU/nb29uldjYbRSI2rfEbdZElJQXLS5K/LUbysaPNRqKq9kyIKZ3vpjXA0eD2yWWJFrNO/xhgnhCX2erq9oQAGOku8AdyaJThRXmHGaovaLjcGKumSAGpnKp6HvCfN0kSsZ2Byru7BWSp0/f1ZhCOFydOtW95RiTHfGqA7nxwUziJIz3iQdgoYqZICoFozdEYm8jcfdPBJp8NgmT5H+G83hOCP0a0q768WVVf+p1kmlNbiVxi5xwf4LrWB4m1Q6d8JaJqDinEUqJ5fzb3Bp/j45qxbsl4hETH+K/31Jo+nf2bJzg2/pn1ClXpZ59SY7ZKeX8gvD7sw8+NRlof2RBnLi2vYvdJUGOOMHbNFAyCed8dVQsTBSTiJmid08POBrs+rodRw7sDbRgPi4gPlPcvRlW7YMP6bpzUDHtFIhk8GR4lIrWsxop9qHmIAXF6JehxrjahrBX6DJr3eoMdlj1kTk75/4btKK8x3+pIUfUyJDXRWH1RfOPqxtpHreD2Fp8wViulIVC0wHFibm1WdttQIzSuhvLe7QoUWseO1IusO19wY5SKKAg0qULbvr2Ue92+sRa+82atjGcFmmRe+33jsbBfFqW72f7cgW1VQml5OyWtdKR1B98BKwLd+IZJlJv6LjtQi8fEMnnlzvjJE3oQDJMlT96eCYKEIZD6hLjMssivXPEya1Tf343tR+Glo+4RtRj2BGpwTwZY9bByFbg0QGCT7O3kA1Fhk5Cq/UkiVyf7MV1v
 ORxIjmAl
 B7NxQho6ygF879mJGFuHoMoUlv7+dgZSQU/BsWMfLTcIwdCC5I7+nslTRW5hXyZtoFrAvgFlQYs4jFV+I/ivkzs+Ih7bQOOCVS+hu6H8jQ2hQ8X/6npIPKsr6HNjOxUk4cyejiN+DJkP3SBj3ab2l7sDFrpFsuokBSjStBSGEZP8a3d80CjZnzsnCuDUNiN2V//QBSQgLfWUPQXyllrLtF00ssHH+JzQ5Im7JTmoG8rYKzCgeGOjVIsNAeGJRgaUNt2rqjDtMolIJRZfRNLXlkCupqUagHzjtnUF+G4rEcDBTvYjPtH+wNxaI4emvS4MZciUuEfZqefScJfWRQDgqpDxRgWbVD2I5PQ6e/lRuriL5PYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 12:08:44PM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 01, 2026 at 11:02:14PM +0000, Pranjal Shrivastava wrote:
> > Introduce a lockless, deferred reclamation framework for IOMMU page tables
> > built on the generic_pt library. As VMMs and userspace drivers map and
> > unmap large, sparse IOVA regions through VFIO and iommufd, page table
> > directories are often left allocated but completely empty. generic_pt
> > frees a table when a single unmap covers it entirely, but tables that
> > empty through a series of partial unmaps stay allocated until the domain
> > is destroyed. Under memory pressure, this *stranded* memory cannot be
> > reclaimed and has resulted in OOMs.
> > 
> > This series refcounts leaf directories natively in struct ioptdesc and
> > registers a domain-aware MM shrinker that prunes empty directories under
> > system memory pressure.
> 
> We had talked about doing it this way
> 
> But I had proposed a different, and possibly simpler, solution that
> addresses *just* the iommufd use case.
> 
> After unmapping something have iommufd compute the gap in IOVA that
> contains what was unmapped and then issue a 'clean(gap)' operation to
> generic_pt.
> 
> This is the same operation as unmap, except we know now that the gap
> has no PTEs so all it does is clean up the table pointers.
> 
> This requires no special refcounting or anything difficult beyond
> some locking in iommufd to hold the gap stable while we clean it.
> 
> Would it work for you? It seems substantially simpler, but I never
> tried to implement it.
> 

I was tempted to use the interval trees too, but I started thinking
about:

a) Locking: For the gap to stay stable while we clean it, we'd need to
add some kind of serialization either through iova_rwsem or a dedicated
gap_lock to prevent a concurrent map to allocate IOVA from that gap. 
Thus, every unmap pays for clean under the lock. I haven't perf-ed it 
yet, but I'm not sure whether users/Guests using virtio-iommu, where any 
guest DMA unmap becomes an unmap on the host, would regress.

b) Other users of IOMMU API (unmanaged domain) like the type 1 (which
was the one hurting our systems) and other in-tree drivers that use an
unmanaged domain and call iommu_map()/iommu_unmap() with their own IOVA
allocator. One of the goals was to avoid enabling the user-space or
in-kernel IOVA allocation (ab)users to cause OOMs via IOPT allocation.

> An alternative version is closer to what you have here, somehow
> connect iommufd to the shrinker and have it lock and walk the gaps
> cleaning them on shrink requests?
> 

I like this one better than cleaning on every unmap, since it keeps
the cost off the map/unmap path and only does work under memory
pressure. Although, it doesn't help type1 or the in-tree iommu_map()
users.

Would you consider those users worth covering, or would you rather
they track their own holes and call clean() themselves? Happy to dig
into this at the LPC session too.

Thanks,
Praan

