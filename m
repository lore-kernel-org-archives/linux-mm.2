Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7BEECFD37A
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4BE6B00A0; Tue, 25 Nov 2025 05:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167286B00A1; Tue, 25 Nov 2025 05:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0551C6B00A2; Tue, 25 Nov 2025 05:03:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1F7D6B00A0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:03:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFEC65B65A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:03:53 +0000 (UTC)
X-FDA: 84148693146.29.894AF16
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id AFB0CA000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:03:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eJ8rSK90;
	spf=pass (imf15.hostedemail.com: domain of smostafa@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764065031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVd5wHAvhsygYJktl9YNIl657UM2lLl+mprE++5Um5Q=;
	b=Yg933bpg8HQSc7ecu10FXTAI+5QtQofmfklytgXQpWQTcVj3fh5XM//B63yh7wPALnbFOa
	a6jqQHtBVbRV5YzFKg95reTXaqTCQ/1yF6aY9NOGPFynp0g76CSgL2KOEFcSCHvb//r41X
	IBQD43zoN4/e3me98o2ajLmFgqAkMDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764065031; a=rsa-sha256;
	cv=none;
	b=ZOm3mx0Iy85gifKXeXM5gYq7o7976dTuufzDcjYl9H3n3q+5xZXFCCB+3undQQo7uwxjlq
	HwywF4Vo8oloUHD8As5cWn0TyboainjiiOo50nDvDW4hmNW6C9a3ecD1cVapinftP0fdcg
	xQ2cWue0h2JlRj3QmPF59dlelYH6yww=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eJ8rSK90;
	spf=pass (imf15.hostedemail.com: domain of smostafa@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso49235e9.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764065030; x=1764669830; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nVd5wHAvhsygYJktl9YNIl657UM2lLl+mprE++5Um5Q=;
        b=eJ8rSK90Rde7wxjWabj8iVegkvvYBIHBhpT6Y8rTSbdG4WNDxMKnCfjSlhYot97b0E
         A/icDJDxSnCzJ9cBOGIL1nqbMhLecy9Z3lKgSDwyg/OWV+KGSwBXoinsf4Sn8eJ4ooqQ
         Xd0jiwzH131/x/5qBZkFfNCnRUSVvqZdtKdFxbLEdRIWKCkH0giQ19Zg41tfqtQIzHUP
         Gxc+TQWV61hxMLfRmOG4qvIuE88+NZfvNjgFMCg4TVD4QVeaE6PiBINLmWBIcX0r/ygo
         2YwYa6MG0yDx5+UfDwO5Rd78YEGAhCT4sNazvgEzAq3W3pQsEwYhMutOUgSG2LG4VuBR
         Fo6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764065030; x=1764669830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nVd5wHAvhsygYJktl9YNIl657UM2lLl+mprE++5Um5Q=;
        b=jBjMj2Odm/fWfpXfuHTTGMHjilfidpteuGwbGXBrY49BHkrLBa1w9uDoW441JHi0M2
         jNI0/+BBwmnT+INmvW0SVMD2D1dO3Y8j5UAw/ixaVEjceOyrJ2otzhvEocSWSbJy1xiH
         7hTiTQGpcRLKCBZIzjBssXqzULc5o2PYeR/gF/xTc0MNge7A8vJB/sJ78n7ZnspEEoxG
         PFK1T20h2cog0jiEzNqMSw87xoaB1X0iv9IIduV7r8P8r7l7yqCE19ohrg+Lo7lWtEmg
         5EJmiLAKDkex7cczWGow/hB5D7sJMsiJF4ZtTkxZ9GFBsXNrVRjEYzzpwLpfBgQsjcxL
         NZng==
X-Gm-Message-State: AOJu0YyjpQiHvCGNGGN/k5gRj8LcUx8AD6AxgEYsTnUlMScpD69M8ZA9
	YjmRfHFfQVO7EJNEgRJ6BnKHuYXUR6V8Ik8b9Dknyynb6KlQxI9d0eRkJAUtMrUSZQ==
X-Gm-Gg: ASbGnctcuHeQvmKO0WG9cJoh17f4xxlJIAbGaPkfdiX/jWVZOXU6dJWsyRFCG0DzaIN
	wtFEyE8Tid+GDtiUpc3Pv8HoBH/IV8dplo0HX1gOO9itBcSPwRNGPHM1i/jqPj3EwJkUAzNDTUy
	yAVT64MG+MJcci1Kv4Ys1WMWfJEi1+sAOZ5575peFsaMBhxyDYG/7Nan0yCsHZ96llaDSNc8d68
	I/Rx/RwSL2AIiiVk/j9izJHzSNMh4EElSHDHHvbipnMxYiiOOq2X0WA4zOnt6A09FPEwTnE/5fE
	zmWBdc4WICwe1wiZRNFITxh2kaqkcA/2Bb0El4h4jy76sSfqzPVYx0F5jPUnctYipRzPdZtUZFr
	zd7wlSHRb3+wEeBHUMRNKs2dD5Q73YH5rc5ipHbiyBmigU7Ulsrd05zvzz47lg4FxUYe9PBin12
	+5JGiPGaV+mJHQJet0rqKHpclXH+ibsJpCCFpJpzXhelzxHK55wQ==
X-Google-Smtp-Source: AGHT+IHGtSW4ZFPm5Ld3MnDEYsj1B4+fTprfbo1S10kQvVjHYAXxPLPTfSswDS2c4HSt3WgH56Nz+A==
X-Received: by 2002:a05:600c:8901:b0:477:772e:9b76 with SMTP id 5b1f17b1804b1-479068ef80fmr299385e9.7.1764065030179;
        Tue, 25 Nov 2025 02:03:50 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e574sm33316474f8f.3.2025.11.25.02.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 02:03:49 -0800 (PST)
Date: Tue, 25 Nov 2025 10:03:46 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com
Subject: Re: [PATCH v3 3/4] drivers/iommu-debug-pagealloc: Track IOMMU pages
Message-ID: <aSV_Ap1RynBULiZM@google.com>
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-4-smostafa@google.com>
 <ae535698-33fc-42a1-8a5a-ed8dd192f697@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae535698-33fc-42a1-8a5a-ed8dd192f697@linux.intel.com>
X-Stat-Signature: fc1a1qxqtxdo3wrmdmoqde4wi6eqm5dj
X-Rspam-User: 
X-Rspamd-Queue-Id: AFB0CA000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1764065031-126948
X-HE-Meta: U2FsdGVkX19g55rbWVHkVG1u73HvoqU1LXS79gM3gvGhZThtrtrhXvLaLZYR1zecd2ZVpAAuSL/zKdOvHzrahOggtYaCiuNh4OG+atvbuB1XLKuOjKEP7hAVHboIih4rK6T7tG/wv54w+ZfpCtTQqh7ov8fsJ+g5URjc6lv+8pVbrBRvviwGQVYi0NxMrPehNeHlbQ2YDeIjJR+VhMc+Nk7HfvqaSvgF6X7okblIp84y+klwPlhtKotgolIfyFbxHE2IOIvsubW144M4vqXVFlVCVEcXswLg119A1OKo5dyMM495kbFlcz2dOkhv8wKLvsmdMFjHQVNJZaiZjWr4XYC/VnSGj8h5Ii7/kI6gWBu3a6Bz0A1i/sqJun1sNYyxjc/4y5UMFre/6DiM0q/jajigwLMs/1X47GxLdhUaRxUd/Vqyn/2qZkWA2imk9VjLLKLQaw6umnSO+xrPvyM9SaSG8yIKtlr18Iqn0GR3jX+Wu+mKOYNZktdjMaKlC6L63sCca5iepFfU29tMZcBGo9MVJq9UnE8WYZjqU4ljIjdRed0qmOGTjK3VElCM+Pm04Q9ZEKseAfHDSR0697iuzPminzHz6C2L2w2T+WVIoI5F3cCdzb6qsFMJkcv0vyADCBhHtwxCr2CJRCSDYNp4Ojvh1XQGLQChP3QwMZOTh0kfa1DjAGGQdd96UMsy8i6ZVzlM+SnvOu0bibUUshIWazJr+28HI9Pm5/N5VK3D1tf9bACVvRaWVVS7be0zPAZlEVdVJwfQN853kIE230xWflIx0ISIcCVusQfGDQ9LNw7YU7niQvD1vucb4mJMRFzABuSMbcuQze5yyedbHnUlHv1hdnM61fmXLESmgEI6gdkiBp4NdoweKzM8TtjW+t8WXgUYRl0WwDg0FRs1nMz2pxzajHlYScNlH82+QZMdn1RJhRvnzIcRaPTtYVIVN0FZqXVznA55FC5sl1FDf3q
 pcwuiQkf
 nJ8jzIMjhvjGJZIOj058qMUTloztRMrn36AgYmGE1m5nywlpKtr2tfO9gTX+upeJMHpwN6RkPZwAYrUcstxbAYD+0O9GvcYwNiBtSkCL0e9b2fwEfrumTDej6Yp+k85oxDDxsTwDkyaEoGa7mWqu3uAYmUxNJLEg3gt73v7aqlaxEtQPQLgkhCjB0t0/vTeaGzgwkenNlemaVsrC163weKfS1JjfQlw0DMyEhlX/JEJFNfAfyVZjvcy6wr8yPEo4m1ZUhO7gFjSP2R5PEnxSJtg/+CEo3S0d6pxgJh6ERowO1KPpftWEmlSV9n0eKoWbplf8t6WNrHMR/y7BqdOJ0UzZ72ygSijXs6jaQO4xKnxPAY5w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 03:54:56PM +0800, Baolu Lu wrote:
> On 11/25/25 04:08, Mostafa Saleh wrote:
> >   void __iommu_debug_unmap_end(struct iommu_domain *domain,
> >   			     unsigned long iova, size_t size,
> >   			     size_t unmapped)
> >   {
> > +	if (unmapped == size)
> > +		return;
> > +
> > +	/*
> > +	 * If unmap failed, re-increment the refcount, but if it unmapped
> > +	 * larger size, decrement the extra part.
> > +	 */
> > +	if (unmapped < size)
> > +		__iommu_debug_update_iova(domain, iova + unmapped,
> > +					  size - unmapped, true);
> > +	else
> > +		__iommu_debug_update_iova(domain, iova + size,
> > +					  unmapped - size, false);
> 
> In any case, could the 'else' branch become a real operation?
> 
> In the __iommu_unmap():
> 
>         /*
>          * Keep iterating until we either unmap 'size' bytes (or more)
>          * or we hit an area that isn't mapped.
>          */
>         while (unmapped < size) {
>                 size_t pgsize, count;
> 
>                 pgsize = iommu_pgsize(domain, iova, iova, size - unmapped,
> &count);
>                 unmapped_page = ops->unmap_pages(domain, iova, pgsize,
> count, iotlb_gather);
>                 if (!unmapped_page)
>                         break;
> 
>                 pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
>                          iova, unmapped_page);
> 
>                 iova += unmapped_page;
>                 unmapped += unmapped_page;
>         }
> 
> The comments say that it is possible to unmap more bytes than 'size',
> but isn't it a bug if this helper unmaps more than the caller desired?

I was wondering also why the core API allows that, I couldn't find
useful information from "git blame". But I vaguely remember that some
IOMMUs can't split blocks so they unmap the whole block when a smaller
size is requested.

Thanks,
Mostafa

> 
> Thanks,
> baolu

