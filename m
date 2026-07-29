Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAF1C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD876B008A; Wed, 29 Jul 2026 12:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E786B008C; Wed, 29 Jul 2026 12:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E3D6B0092; Wed, 29 Jul 2026 12:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916506B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:48:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16CE5140775
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:48:17 +0000 (UTC)
X-FDA: 85042397034.06.D50AAD3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5AAD21C0013
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:48:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=RURRz7s4;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5l/3IP2HFVsa8eAqLOCa4UVEPVokMRetreMKGr2fkq8=;
	b=bqCnNcUojTlbul2LyU6xX4XSHIHqT3ExBFWJi+gsB1FSWgzkWwUTZ0GKPeVPxgNLmYrjQG
	E6RsJADde8w+SQKaJp+eMFIjleMTRuflDAcY6boqBoao40nVK8dnFjyMGWsjtzJcYP4Nis
	7AwhbNCLZ3DhPZYwn5PllhmGB1+srGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343695;
	b=YXz5Wfd9JYeO7tWLG0JsnOLt7UhnuELS+4ct/GLs9jq0OuN6FOZJxKjksmk3ywO4baxE6p
	vvCD9KbUxEHVIZ6f4IZh5fnFh7mQoa+m6Izr1HGsio2uzoJutT6wGGXGEbCkfMJLKey7eE
	2vkCGhpmCLZvETb4ZfQSP7HneLt5idE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=RURRz7s4;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5l/3IP2HFVsa8eAqLOCa4UVEPVokMRetreMKGr2fkq8=; b=RURRz7s4klLVjJ1u0nsrHmmDI2
	6huTDWCqNbHC3TPf0/VNEPWfxkndui6XU+JXSJ5DpiG9Qi+EUKSg4YlxYA6+5HjOpyF2NxbmdCB3I
	IfR83VyRoPifX3SADc9MenUDDOtKZw0lYlmnfHMJPbb1HIJIqxoT5aXFs92TE9vl49F6zdifEni7a
	blLi764oJSrTG//yH0piQUMUN/oQIEgokEdkEQvvL2j8jVreJm3kJfX93CpYZFqCRfPDQUmSTN50+
	cLtQzbV2968XW4fGsJqnxrmj9Ybh5aB+R6HC3JPwKPRFxS1e0CN75gFL78YRohH6HKxwQxxhtu/96
	5xvXvn6Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wp7Rj-008amb-2s;
	Wed, 29 Jul 2026 16:47:56 +0000
Date: Wed, 29 Jul 2026 09:47:49 -0700
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, kernel-team@meta.com, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] kexec: keep the next kernel off hardware-poisoned pages
Message-ID: <amogZHzDyp8lvrQG@gmail.com>
References: <20260728-kexec_posioned-v1-1-160c81d180fe@debian.org>
 <2vxz7bme80vm.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz7bme80vm.fsf@kernel.org>
X-Debian-User: leitao
X-Stat-Signature: uk1c4iomg5cxjkmwdqeqr18qfh3km8x4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AAD21C0013
X-HE-Tag: 1785343695-132716
X-HE-Meta: U2FsdGVkX182FdXwkOpYJ/5Dg9lSvHsRV5BLS9Z/yFG2MzbfqY1d4EuLu9hSFUT0Nj2sTh1J3CIvwB1xvUH/b3hICHw5PmUamqdqZ35ZWTxhIHiZBGuW69xLJGyhlLH4v3kpnUeXXksZTDlOqunQ+6Vm24biXBamuuNApx/Tb0+W9lFjlBr0SdAuDArCkVZeXgDzWC3DnjBD80349aQUweFb/l7z2t1s9w+5wqBvpIuLTOgeofFvOVMrkC1BfIDBGnVbWGL599bbaVVUN+UbzU6ONyduW1jk8E+xhNeUrj8lK4S5sJ+V9r+dR0LcnhSod0ke/deZmE4e05eFgpkafbEdOt+GcuYEgB+B/IjwAIgJh2tbICPEZ1Wrqo9/nO4z7e+645V3miPvgNFd74k3YK3jMs/zNgkzm/Mvqj0X1fezfc9B3Bf2JnrjuTReO62RTl+uR69jpEyC4wVgwEVwi+6siBUuCvHcxEsR2aYjBeuWI/bXbscU1RJ22OHaQ6/U5Q7RRoU4OlQ7T/JElYZFk/Dv69sBlUM2tis7pDqGQMK20DDlWXXRWRj3ciBOgn3Z+FsZ/Om69+F6qLDDV6kBvtZMNK4oUZn5K1lGqdGQ4Rcix5jK+CEIxWwn2F6wS9lj1vCsOMc9GLYPbXXYfe0YZ3CKTAicFOt6WxnbEtAGpYhjcjdpwX30VKht1qtqgNSbNs9tvezkK+MdV8BTLSEWxHUHYqk+MELwqQ9EXwdTnlGwAmqhIbZsf56HBKY/+IzXTVg+Gj93JdfbP3DXNkWybUZECTznn7/xLgE64XIUkGAHccN7Rk65jCyttQSJzwmDwAFIK5L2x2RshlpOpOKupSJL1Relz8IvTdZu30AKUq34kl/rb67+uuiI4E6lgRwUZtFPbnW3WDebEu22t76eB48ZrQeFMzinWqmXtn+DJl5eoDVP1ZUmyo8y3wrG/9YSw3bOTKQPLrfgP37TjMX
 dc9wserh
 DIF/y0BH5rqQddsuu15dsLaSn2Nzp6y2H2Vge03o1+a8bvX29DaoQgvERuDB23wl8BdUhCF0RxjUQ0lFwyyKifKXndqIw3zSVlZ3rcC0P8XK+0Pcix+oPed4dQXe+VfS6xZL0BHjsUgGY2XgVWBOGbgKZvs+GDGbipGDns9bXNAFfdPLFEeRLtvwjJy7E/7adukhBy6iApGbxuIe1kXRhDf0vvg6LzRCQxvef1oJsiuz7w1OREAVCp8d6XGTeNn6W85/evkAxOE7Ieb9js9ie+3ZVeoe7M6ZxAVpsLIl6Bw+Ql+vQp8+JMv3cl5dL/0wZfFuVyzOJqD8WyD006nVaGAgzVhfOAQQFh1e9w6lG0glHoAemVyfEXSdRxd7eptgwePkYnFXR3SjPQ10i5eDSDiVghA66cgbd2Oq+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 01:57:01PM +0200, Pratyush Yadav wrote:
> On Tue, Jul 28 2026, Breno Leitao wrote:
> 
> > Memory failures (such as unrecoverable ECCs errors) are getting more and
> > more common. The kernel knows how to handle it while running, marking it
> > as poisoned (and SIGBUS user tasks).
> >
> > Poisoned memory is removed from the buddy allocator, but, not from
> > other places. A current problem is that kexec will load new kernel
> > on top of a bad/poisoned memory, which is undesirable.
> >
> > If the next kernel's image, initrd or purgatory lands on poisoned frame,
> > the relocation copy writes to the bad memory and the machine checks
> > during the kexec.
> >
> > Skip hardware-poisoned frames when placing segments: check them in the
> > kexec_file hole finder so it lays the next kernel down on good memory,
> > and reject a poisoned destination in sanity_check_segment_list() for
> > the kexec_load path, which cannot relocate.
> 
> kexec_locate_mem_hole() uses kexec_alloc_contig() to try to find a
> contiguous range from CMA. If found, it uses that and skips relocation.
> Do you know if CMA tracks poisoned pages and skips allocating them?
> 
> sanity_check_segment_list() will catch these anyway and error out, but
> would be nice if CMA can track poisoned pages in the first place.
> Anyway, that is out of scope for this patch, but something you might
> want to look into.

Good point, I understand CMA already avoids them: alloc_contig_range()
runs in PB_ISOLATE_MODE_CMA_ALLOC, where a HWPoison page counts as
unmovable, so isolation returns -EBUSY and cma_alloc() routes around it,
no?

> > --- a/kernel/kexec_file.c
> > +++ b/kernel/kexec_file.c
> > @@ -504,6 +504,13 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
> >  			continue;
> >  		}
> >  
> > +		/* Avoid placing the next kernel on hardware-poisoned memory */
> > +		if (range_contains_hwpoison(temp_start,
> > +					    temp_end - temp_start + 1)) {
> > +			temp_start = temp_start - PAGE_SIZE;
> 
> Sashiko complains about this
> https://sashiko.dev/#/patchset/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org:
> 
>     If we find a hardware-poisoned page within a large segment, does this loop in
>     locate_mem_hole_top_down() cause a CPU soft lockup?
> 
>     Since temp_start is shifted by only PAGE_SIZE, the next iteration will call
>     range_contains_hwpoison() again. As seen in mm/memory-failure.c, that
>     function does a linear scan from the new start address:
> 
>     	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
>     		if (pfn_valid(pfn) && PageHWPoison(pfn_to_page(pfn)))
>     			return true;
>     	}
> 
>     This means we could rescan almost the entire segment over and over until it
>     finally moves past the poisoned page. For a very large segment like a 512MB
>     initrd, this would iterate billions of times without yielding.
> 
>     Could range_contains_hwpoison() return the address of the poisoned page so
>     the hole finder can skip past it efficiently?
> 
> Which does seem to make sense. Same problem below.

Agreed, that could be a real problem. Returning the poisoned page
address from range_contains_hwpoison() would work but feels awkward
for a predicate function.

Let me think through a cleaner approach.

Thanks for the review,
--breno

