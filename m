Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D080CC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0856B00A3; Mon, 14 Sep 2026 11:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70636B00BB; Mon, 14 Sep 2026 11:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39396B00BC; Mon, 14 Sep 2026 11:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0436B00A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:21:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCD3A401A1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:21:57 +0000 (UTC)
X-FDA: 85212733074.20.9397078
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 28426C0011
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:21:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXLwSMkG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbM/6KmbIwqEmYkcORDjoWrwHW3qkC0k639i+OR+Sr8=;
	b=XVVibRfQkijHR461arczmZIha/TNlruXgnoc096hlwSaioWRClAiqlOVZmB5Q0f+x/iSRO
	JxIroqQVdxuXW8Q6Z6Q7Do2dynHdIgi1IyFea+8t2RPAw+5IQl5gOQAhLO6j/SAcA35LEC
	bdkoCp78Z/oUEUb0mK2K0tiJRDh9+Ww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789399316;
	b=sfFlq28DrIE/dDcf24OqM7fByV8msN38+kLE0J0DvZQvbv2XWGzTil66jSLSC9HbLqEWd1
	nKcqB7y//q3Wmb2nzFrQg6+Og5MeTFZmZfU2PwjWow7RNPuR4OT0AeovGMEi5urOrjxi6u
	5fcaPS99N3ulfVfUyaey+gDl7z+QNLE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXLwSMkG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B393415B7;
	Mon, 14 Sep 2026 15:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504B41F000FF;
	Mon, 14 Sep 2026 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399315;
	bh=BbM/6KmbIwqEmYkcORDjoWrwHW3qkC0k639i+OR+Sr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HXLwSMkGUQJpjeB6H3k1gKeb4bQKtfUE3zfkdtxMdHq9prST9T7R7/v1Ujd8ovI0V
	 eCf2nffXt+2XbJScr13PvgAj/Z2DYBBz/fqVuCsPZIjFQqJo2M2oybxC/oiOMfJ9jH
	 /fmFZXd1qlne4zCEQrqK7ruv7BDqvXt5lHRzqkuPYGd3d2W365qPBWLBsrYKSNX4j1
	 DX7yT6W15irI9igbkNqy7AvA6APc3nXFkPzv/KpDjvcWf/lU9mfb3ci4l+X0ixBEW0
	 rrgrUZBXxrzHNG3AYJ5gH2nB/SsjBvhWBNGArrvQkDuFiq8QmaBgF69VSf0+6h4ip6
	 Pacmx3r5tv4xA==
Date: Mon, 14 Sep 2026 16:21:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: Re: [PATCH v2] mm: implement and use vma_anon_tracked(), silence
 KCSAN
Message-ID: <aqgQw6moAuJYCVw8@gremlin>
References: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
 <aqKzUTPbh1qcKs4a@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqKzUTPbh1qcKs4a@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 28426C0011
X-Stat-Signature: n3b1wudqkw4dak9ofg47r3j66uey1n86
X-HE-Tag: 1789399316-871075
X-HE-Meta: U2FsdGVkX19MQtCSeDTJeWGvxcjgZljOeHHCTHObwsfWnrED3hbuoazuF6U+99eJaRlR5pI3lhTml9ulHYDKOjXTEQJgkmVDk3skmQ6RXwK3EoOJwROLMdlk7yY4p1nOhmC8JlZfYBFp3NV9IJ2Wh4tJPx4m0ApvRzvpoXpd/25IxkdoQmd35YlNu92pEYhEydlHbGOqAWbFj8/eGIAVxqjIqSAcnKjzNqJT5DoRZyDYnIf6RH12i/ZvBWTWByt2sSjG2PtVU7yNZTSGw4gDkODRWiRX+teDLpgQpHdEWsPXLCU/wbAdFTrt6dnJgCW6LPxOLAz7ms7tiHKITYcagWW9epaRd5h444dCEdfRwm9xKVyGDNfh1vrc6S4aMUi42XfN/YcrRGIuep2B3IJXiX0qUghZFo5gHHynV8BMiRz7fiODPmRywjegEEzEQXz/Fy+DvkfCixbFeiW8n8K0CW9pZ4ZtYtoSMqHXQoMOwOzQX9tA7020HSBlc1nug1ql/XSSXoD2YE1fSUxWQZElmRLj1VCzdzEZotQywyS4oVkLz1Hm7abZHAz4mDhTPIHXH4PxXQ6wL+DbIxclEJ/qXbtkoWOGASRTwevQvHdcVrZ2c456SkP+X36ykEbk0zGvi1xb+5X42BpKPFpl/QCjOCjXuN5lyTYmPnVk/HDZt51hJTMt6KuXv3U0DYNaPPfJ/Ye886Xb9CPOi7c3k/zpylqVmHZxUTr+EBSPmyMNRxo6rrjERTceFcOBvrhcnA/G9QKJpZVMnaX4apWZB9FKDgkOZmi1wSKKmVFkN4tYCvvZeQ1hJ98zN0QoAL/HorFMdhtDKgKx+6U9xdp6igNud8WFx9aPPlGz8Q0objTj6C0VFr1p4HJFLyR+swBRXu8QSEalJzdIJgIJgRcu34N1uPOIYjLedojc2HJwLR8udq1s1gSzi3Gd3s9NiMcKltpRAJ72eejfBx2qw5NYo9o
 67i1s3+k
 GmYezXST9oHPvr9dL5y5VGt+GPc9UXamFVPjfw1RWEyMMnT7YXR59WmKqH869XLBzHbz+k2rXlse6H9czbZXaAIsUU+nLgsIjdvOlWo/nzGrXnr/bvRh2jiv/A2VwzxQPh8Y3vVU60POEGNGzoKGsrSXZ/zwNS5ZlcWkSJtrRmvUfX+ubQlaN0RInq+AerOIoN88r5mj8FORfCuS9kjojl53DJJ5JVy20DN//ivMX01Dr6ivTLjLpxmSp/GTc7A+M95w0iqmGiIetzxtXZdRNNZ47z/RQ9iMlXC8jMmTOzx3ZepryfXjkk26iFuBVvXsiHixVTek+5vK49X7yaKQwTdRys6CvROSLLqBd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:50:25PM +0100, Kiryl Shutsemau wrote:
> On Thu, Sep 10, 2026 at 02:18:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Provide a function to abstract the common task of checking whether
> > a VMA is faulted in or not.
> >
> > A VMA or mmap lock must be held when calling this function. For an attached
> > VMA the transitions between unfaulted/faulted state are:
> >
> >        Transition        |              VMA/mmap Lock state
> >  ------------------------|-----------------------------------------------
> >    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
> >    faulted to unfaulted  | write lock
> >
> > So vma_anon_tracked() never provides a false positive (the lock precludes
> > it), but if only a read lock is held, a negative result must be re-checked
> > with mm->page_table_lock held.
> >
> > Detached VMAs cannot be concurrently manipulated as they are removed from
> > the maple tree so require no guarantees.
> >
> > Use data_race() to silence KCSAN about non-existent data races between
> > concurrent vma->anon_vma read/write on optimistic fault tests.
> >
> > Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
> > dependants.
>
> If you end up respinning anyway, this would be a natural separate
> prep patch.

Yup will do, Pedro also asked for this!

>
> > Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
> > preparation callers which test vma->anon_vma directly to use
> > vma_anon_tracked() instead.
> >
> > Note that the lockless read in reusable_anon_vma() is doing more than
> > checking whether the VMA is faulted - it is returning the anon_vma to be
> > used on fault, so this check is not altered.
> >
> > There is one odd one out - file_backed_vma_is_retractable() - which holds
> > neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
> >
> > Therefore just add a comment to explain why the direct vma->anon_vma check
> > is required.
> >
> > Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> > Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
> > Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > v2:
> > - Renamed vma_is_faulted() to vma_anon_tracked() as per David.
>
> I don't particularly like vma_anon_tracked(), but naming is hard...

Yeah it was a compromise because David and I disagreed on naming (again ;)

I think vma_has_anon_rmap() is a better compromise?

>
> From quick grep, it seems you missed two cases of direct readers:
>
>   hugepage_vma_revalidate():
>
>       if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
>
>   vma_needs_copy():
>
>       if (src_vma->anon_vma)
>
> Worth fixing? If it is intentional, add a comment why. I don't see it.

Ack will check.

>
> Anyways:
>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Thanks!

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

