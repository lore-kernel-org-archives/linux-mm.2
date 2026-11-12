Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D678F606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fby67aXm
Received: by kanga.kvack.org (Postfix)
	id CF9616B05CC; Thu, 12 Nov 2026 09:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9EB6B05CD; Thu, 12 Nov 2026 09:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0936B05CE; Thu, 12 Nov 2026 09:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97DA36B05CC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:29:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2ACDB1205D2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:29:14 +0000 (UTC)
X-FDA: 85426699428.26.A1F083A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0EAB64000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:29:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fby67aXm;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493752;
	b=CTRv5gNTjRxovPxT657eJcYLQ67JcCQCBfVFslAkpUS7gOSe9JoodAkhKSwOk6yFWJNyFB
	MtUtpdxmoGEdaO/lF2aC6uY63dTozMMjaap7x30MajpxP4zlO6n9GeTNlqwPzJFsfKbWQ+
	FbsXgVtFdJFh1TOWzXj5JEYMUvhgqXw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fby67aXm;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRazLDIEc7CMUp/9vgq2YR+tcffN4fGN/wRdKhy4qfE=;
	b=YYnl4+4KQOMBEuyRWdV63kc/ru5m5w0vdlUJ01PyZ07P/KNswNnlaxZVVStpraQ/7uTiiU
	nNfMiJL0yejZotfOTzHyQ3vMssPB/X1NKkLvijpOODyP4XUEeU+YhHYQ8sEaIFLabMHwQR
	HsMdHKyPst+iBIS/jCv86iLai+ZtdCY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E07A61477;
	Thu, 12 Nov 2026 06:29:07 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D93B83F673;
	Thu, 12 Nov 2026 06:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794493750; bh=XiaNpbbvxm6cKE/zgmNwmyN9+sHlHIuKTGnW432EXr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fby67aXmxYqsYQ+cJC3GcBthEnnJJfdGSIYm40Lcu20zGsDk9qauSSN3TVDH36s+A
	 aizxncjEclC0Gap/jNtf43T4IKOjBghSsjwIFWshSDsu1J7xkfVFbrN8L9ZwyHuEn+
	 GCODgR3flC+q2PeYAw8JU5AHNQWkEmCxf053CvKo=
Date: Thu, 12 Nov 2026 14:29:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Mark Rutland <mark.rutland@arm.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] arm64: hugetlb: Prevent write fault livelocks on stale
 TLB entries
Message-ID: <avXNMuvCNyLwk7wt@arm.com>
References: <avPxZjjdBIlM_8_g@chrisdown.name>
 <avQvk0oxEHTLFacU@localhost.localdomain>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avQvk0oxEHTLFacU@localhost.localdomain>
X-Stat-Signature: ue79qrgy98zmyf1g5oj5pqtfodgqr8c9
X-Rspamd-Queue-Id: 0EAB64000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794493751-312141
X-HE-Meta: U2FsdGVkX1/766qiIG0PiSIdBAcUXmzdx4gWkG3df+jT8oCRgeNdnClaJR6fTwaDHoQFEjDDYU2P00xIoTpnR8vc4Jehz2/9cJT5MMacgGPowpxMQnC1ZGH0EEbIoUVkvL0P95XX1fDPXUbOne82HKm8YDLx0CeOoxpfRz8jIvO0W313Inr/5XvRnWwb3JNaQThH0c7C7HZmddYm4NP1mqTAtP6N1yW/UxI9jXjOXFP+ztV4yz1ZIuvZoXcCw7+MjgN7b1LYW0yAIL/DfyazCf2D5uVwl4FkFQmoKXZJGmDMHWDyaO7rpARWuoI2rLcTrPYFNjZssFnD+C5lqNyTowlD1yebCHaHkl7rFNNkc53S/9IQ3n1MJ7cuiS76bpBJ6aUMLXAa4uVdYrFn2rQJIaLYbuWYP8rYqMkDgmizMEZtqCLDBuyeSzJRsOhU3KESA+F3HXHLItfCVO38IwK4Xuy6D6H5QqW91iqkCsSFZqkm1IeGamMljFJSCFgzsLGhmBsbfissXMOXgxAxShnhuRsfR4N+qBqczJOPZLP11MB9Eqp5C4tYRue8jyetKi6zZTr9dQIB1C0VcSoERV8p8rbkBnoPbSxFCfjrRj0O7D3YJcU05Ua/2Wo/gR5P59CyLMuTXXPHlgn4Zw+TUCDo/Ua04xVOv5e4M1VjmdT0YxiVFUn1T6RSBsFk5/BtT0+YpfquFkk/yU+5KrMYc/ZPZD+a6rKvImeOyQ5p+iBmavVkTefb3QE4lUURHbLm3POVsgvgLNyrvhhvMb8ZiJUlPWEimjd+wRc9rfR2IJvhRxCpOpzMm9T35jzIE5SEg0JUWqPIzjYbJQrr7qe7AlgfrACoSpZqdue9sacfSGB5AY2lK92l44XE11CwGspeBJw6dmEqYdUTd83g9O7As1Q0HvYyJNsj57vm2Vom308lIeJC+lujKTJ9UgxfiwBvCqhrMtiLARX8LebMvnYEiTF
 TzFoSgCZ
 V7rBUo7fALNo/i3/wegQDY098NYXYTL1zY18fWCGX02OGXUvP8rjyFNlfmYmYvdOV6HaxRTEySI6QC/1F3ZwecmnNRYrB4anC+z83xuSJT13m3elcrnWPzB1wtNtnyelGXZGz7o6yBFaz8Glvn/jiH6NslDpt3tzh0V5Szv4FrsiFhBeuFC6DhEoWU1vIN77CL8SdZm3qvsFbksVsVf2cS8en7tTHckNz8yJC7DYeYSAUKS3oU8mIbdwoQX0Haj5a63/T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:04:19AM +0100, Oscar Salvador (SUSE) wrote:
> On Tue, Nov 10, 2026 at 08:39:02PM -0800, Chris Down wrote:
> > In Meta production, we have had tasks get stuck in a fault loop while
> > using hugetlb on arm64. During my investigations I found that affected
> > tasks share a private hugetlb page.
> > 
> > Looking at the stuck task states, I found the following ordering:
> > 
> >   CPU0                                 CPU1
> >   ----                                 ----
> >   read page
> >   [read only entry cached in TLB]
> >                                        write page
> >                                        hugetlb_fault()
> >                                          hugetlb_wp()
> >                                          [reuse folio]
> >                                          set_huge_ptep_maybe_writable()
> >                                            set_huge_ptep_writable()
> >                                          [flush local TLB only]
> > 
> >   write page using stale entry
> >   hugetlb_fault()
> >     huge_ptep_set_access_flags()
> >     [entry already writable, no flush]
> >   retry write using stale entry
> >   [fault indefinitely. well, that's not ideal!]
> > 
> > The reason is that when a write fault makes a non-contiguous hugetlb
> > entry writable, it only invalidates the local TLB. However, another CPU
> > can keep the old read-only entry, so its write will fault even though
> > the page table already permits it. hugetlb_fault() then finds nothing to
> > change and leaves the stale entry in place, so the same write keeps
> > going round in circles.
> > 
> > This is particularly bad because, if the kernel is copying to user
> > memory, the retry stays inside the kernel and the task can't act on the
> > pending signal.
> > 
> > It can even remain unkillable while holding locks across the copy,
> > resulting in further failures. For example, a read into a hugetlb
> > buffer can hold the pipe mutex and block other users of the pipe until
> > the loop ends, causing cascading lockups across the machine.
> > 
> > To fix this, when a write fault finds nothing to change in a
> > non-contiguous hugetlb entry, let's invalidate the local entry.
> > 
> > Fixes: cb1fa2e99955 ("arm64, tlbflush: don't TLBI broadcast if page reused in write fault")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Chris Down <chris@chrisdown.name>
> 
> This makes sense to me, and I see that commit cb1fa2e99955 ("arm64, tlbflush:
> don't TLBI broadcast if page reused in write fault") only invalidated local tlb
> for cont-hugetlb.
> Reading the changelog, I guess that was an oversight because I could not find
> the reason behind.

I think you mean non-contiguous hugetlb here? cb1fa2e99955 switched
__ptep_set_access_flags() to local invalidation, used on the
non-contiguous hugetlb path. Contiguous hugetlb updates still broadcast
through get_clear_contig_flush().

Ordinary contpte mappings also switched to local invalidation but those
go through the generic fault handler and its fix_spurious_fault()
fallback. That fallback is what the hugetlb path was missing.

-- 
Catalin

