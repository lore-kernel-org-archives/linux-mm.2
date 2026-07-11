Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28DB0C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 06:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144B86B008A; Sat, 11 Jul 2026 02:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6606B008C; Sat, 11 Jul 2026 02:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CF66B0092; Sat, 11 Jul 2026 02:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D13526B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:43:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BDEB1206A3
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:43:54 +0000 (UTC)
X-FDA: 84975555588.07.3F9E941
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AA45C40007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:43:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kyjEDrRZ;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783752232;
	b=OCxY9LxUvynLr8T6raEEc2fr3SRwtgoVXm4l2GUFS1spbyV68/N7/lZUmhP8w9QQ5T8nXf
	00LyH3pfP6nHsnbY3X81rxoDMbi8+iiLJN227Zsbc1hcSAdN1NiuPbUJ9OPKkYIRPjBmLe
	QH5ygxSAykU2AbMq75ggk0tmntinKiI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kyjEDrRZ;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783752232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CucO9Dqyb3VrMc9+4nXcYsoF/W36DcjcAnqAMOVRe9s=;
	b=Fwj85E5MD934b8ogwWS84gLV8NHSYdmCDbzBJJDXC5oE/5mxviupAd01DlN9Un4WH35MJj
	8HON+GqNflmzXKtUvTJ6EJ6ZVTQqnVZmyAeZZVvCTLJvdLDZ4ZUkiKJ2dnKKdvBPRWG18Q
	7l8JlL4dxKSrMisp2bpT+GLZhWRVPV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90AF043824;
	Sat, 11 Jul 2026 06:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAD41F000E9;
	Sat, 11 Jul 2026 06:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783752231;
	bh=CucO9Dqyb3VrMc9+4nXcYsoF/W36DcjcAnqAMOVRe9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kyjEDrRZbnsq6EmErAohHKx0a/rriFw3B5N1ibhCjSNx8H21OIRm+q3V900WWGh0l
	 JqWTXxrqiX4dLNe8nf2dzEjpz6ZD85jh+ejyXbN3AdzGllPOCFmOQ6mStXGasDd57W
	 fvgruQPeKnNXuG0IvvWCDMGGKlyv03JwfCTLtjnwN6TZwCKqr6vdJqHXt86/0cjUbW
	 nbLvLdj/8P90vzMPDSKzMRv//E7aB8JELHDpxZtygvdcLTCB/s1/LOkBzMOYAQzBVp
	 BWf8QSOKg57YH6S0MVIQ8OzpRWuXAHQCmQsmhKZIm6Uz3HyArtBPYjzUUbqNb9n5IW
	 VcwPjp61e0vpg==
Date: Sat, 11 Jul 2026 07:43:38 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	liaohua4@huawei.com, lilinjie8@huawei.com, linusw@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux@armlinux.org.uk, mhocko@suse.com, rppt@kernel.org, sunnanyong@huawei.com, 
	surenb@google.com, vbabka@kernel.org, xiqi2@huawei.com
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
Message-ID: <alHl8C1gva6jrAV3@lucifer>
References: <akzgsZi6aKCFWg_U@lucifer>
 <20260707133527.81833-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707133527.81833-1-xieyuanbin1@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA45C40007
X-Stat-Signature: 8wo3bm8b1baqjhdr1154bqtu31forheg
X-HE-Tag: 1783752232-719705
X-HE-Meta: U2FsdGVkX18co6IShEdRpVIywRw86uwuq7CUHArnwJMi0BTc0cVxO2zpVDw8EGzEbpxnoGoPyHdFlyLYYskzYax2ImCGeLRbUw8kRHFMZ1+8asWogEvN/s/L/Rb8eMG3Yboz5Dglw5yvSfzo41V52mwyDwDvor6Mqt/8JUgjQfgsJ2RDNQodMBRXXdqBdmANw/1XnTXyl4IBp2jL5lg0mNxXYiPr+uLrVX2FkcXivS3FiOL+XD4mrPuSQJGCrRKMxgXtZE6JyL/IwfqCHl5ScrPX1aHJ+pr+DTDfKi2VPtDDLRlBRaOhzK7+c/6E2khAJ6UdIR7ulzgkScQMUeKWWrF52nMGz/0apU7vl0c+KLvd8GvvtnYICZNg/rRnXekbEJ2uOedbTvUub2OIeR2GXZ9CsklzsY9kcGDialCvn5m6sc3RIQDLVddVZywxKXr+nnGgb9VLI1k04a2Nlu9OWGu2GRlILTTaLltESf7ooSTMh1DyPwfXgBwQ72RTWdYKOQ0elmkFDlHfBEAidZKusYhxiPTEhngOfuODiy2UJRY8azeUREqducM5nGLjIk3HQ/oeFz76+5cr9p1wcB25tK12pSltFExpmGX79Zw8ibKjvoeHeLNDOCYxgiQhzwEvRRcK1Wq9GfsIE7lR51H3jm0FI1zCU7JWL6uohZQWLg5TffTikaMlap7K1LZywzr7QsllWexrGmByvchQgl5JlwMvsVQ1BlFJTj2/lsb5VC9S7s5yyTDc/A1Rv++f+TPKZcjznPrbl/o0bqK7uuww4Yz+BPMkglQhdZ64xmUpcQHSvq5T4Or8b9MWBy00tDHEFx/9rjmPsnbL0y+K2+uBf3YOPLvZYC/CaVU79fu5BGeYTU4RyOBQLkki3+Ye/SJsARH9isahXOfA0jbBkeFxLlQot2/fmjfmNvE7dFFRaIkpNIeoC23zyC1yHv/XeCwIHnrduXYLHbVVYV1L66Y
 YZMedM2S
 7p71EDY5TYVKDA+/Rgn3EXd9cNXC3heCkxnB1hnf+vjZi/lYBroHCeFMJNvCsKTKjb+EDnGOCVF1LQSnxNVO8F8ib54PLR94t7QTSLbl7pnaVOt9b+GkTOe83MCUbNtRaE9Mo1Nl9jxSRodneR1CAqozfIosgvUCTaNSP6R2AeGsyTFW1pLrt+2P/HCjCgBXQvTHr0jCuj+IP9a2fSZ6qB6jox/mICj7yP4HNioWa+fpfFQK+xSzEra7psDwZ/GhfycUtNLbQCPBsoBvcu86qa+Dr+o5v5Rqh4kgq78pBHVnyV2DJj2WcRsdmVbPtde2vSXxB5UY/ydzSmwnkYRJQE17wpfjhcxPLERtz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 09:35:27PM +0800, Xie Yuanbin wrote:
> On Tue, 7 Jul 2026 13:46:19 +0100, Lorenzo Stoakes wrote:
> > On Mon, Jul 06, 2026 at 09:32:47PM +0800, Xie Yuanbin wrote:
> >> I have read this article:
> >> Link: https://docs.kernel.org/mm/process_addrs.html
> >> `mmap_read_lock(&init_mm)` should be able to ensure that the kernel
> >> address's page tables can be traversed. But I'm not quite sure if
> >
> > I added a section specifically about this -
> >
> > https://docs.kernel.org/mm/process_addrs.html#traversing-non-vma-page-tables
> >
> > But note:
> >
> > "Since, aside from vmalloc and memory hot plug, kernel page tables are not torn
> > down all that often - this usually suffices, however any caller of this
> > functionality must ensure that any additionally required locks are acquired in
> > advance."
> >
> > With the latter part being particularly important - you really need to be sure
> > you aren't going to be raced on page table teardown by anything.
> >
> > However:
> >
> > 	* You're safe from vmalloc trying to install a huge page table (only way
> >	  it removes intermediate page tables) since !HAVE_ARCH_HUGE_VMAP.
> >
> >	* And since arm32 !ARCH_ENABLE_MEMORY_HOTPLUG you're safe from that too
> >          :)
> >
> > (Really I think you should be using walk_page_range_debug() here ultimately but
> > that's a future refactor).
> >
> > BUT see below:
> >
> >> `mmap_read_lock(&current->mm)` provides protection for user-space non-VMA
> >> addresses?
> >
> > OK so this _does_ need addressing, and I covered it in the document:
> >
> >	We also permit a truly unusual case is the traversal of non-VMA ranges
> >	in userland ranges, as provided for by walk_page_range_debug().
> >
> >	We must take great care in this case, as the munmap() implementation
> >	detaches VMAs under an mmap write lock before tearing down page tables
> >	under a downgraded mmap read lock.
> >
> >	This means such an operation could race with this, and thus an mmap
> >	write lock is required.
> >
> > I.e. you need a write lock.
>
> Thank you very much for your reply. Now I fully understand: to traverse
> the page tables of non-VMA addr in user address space, the mmap write
> lock is required.

You're welcome! :)

>
> But I still want like to ask a question:
> > However:
> >
> > 	* You're safe from vmalloc trying to install a huge page table (only way
> > 	  it removes intermediate page tables) since !HAVE_ARCH_HUGE_VMAP.
> >
> >	* And since arm32 !ARCH_ENABLE_MEMORY_HOTPLUG you're safe from that too
> >          :)
>
> If (just hypothetically), the ARM32 architecture supports huge pages
> and memory hotplug, what kind of lock do I need to safely traverse the
> page tables of non-VMA addr in kernel space?

hotplug lock, mmap write lock.

>
> Thanks again.

Cheers, Lorenzo

