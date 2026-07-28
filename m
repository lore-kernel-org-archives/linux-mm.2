Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05A0C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596466B00A3; Tue, 28 Jul 2026 11:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546EF6B00A4; Tue, 28 Jul 2026 11:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438866B00A5; Tue, 28 Jul 2026 11:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1DF56B00A3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:54:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6780CA0399
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:54:56 +0000 (UTC)
X-FDA: 85038633792.15.607F11F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B420F140009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:54:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S6fTps3w;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785254094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3L/UrHGl4azu4MImVkoZ8k0h0P1KlNAOyIZj1BowJw=;
	b=319fhDkgo4eAVAIDta0Pd/X0nlU1FuKJRTwIdQ1zQQOAeQ4Z2C4Gb6quE6d+SXwDu4gwH5
	X6fDajcsPnVU3Go75GireMiK4E3UyRQ1WSFcYgt01fv69KxqmfpMu1y2n7awsECZzzKg/e
	lRZ6EcATgpAXDQDUC7YcR7CM8lyCnbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785254094;
	b=jgM30NmLbqxalb5/8+cFDNKDw0fsyk6S9UTcHbCl/IZzsYqXDGsr/tB06SQHTzGF8UMl8e
	01VNxMkHI5l+zeTSUJ8QQc1U6GY2HwDZ5PQIpXNuWONDjBbEz+GmtiICU1iF8RgBgVct/g
	FIv5nXtZa5n6XaGy1kp9d/MhEWwqmF8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S6fTps3w;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA0B7400BF;
	Tue, 28 Jul 2026 15:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788641F000E9;
	Tue, 28 Jul 2026 15:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785254093;
	bh=+3L/UrHGl4azu4MImVkoZ8k0h0P1KlNAOyIZj1BowJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S6fTps3wt94rD7ifH2A+n+pqIqyZAAJaEfzqrgyvrq584ZkqODFDOCKTjjWrJIMMZ
	 d2HlEtS6SfoPAid0E+caCpYj93asu5uOepavwFrlexsxeNyyWUhLcuFasZyXhcOMY9
	 iEgLsWA5HEk7iCo3kqaCm0mpRvGqKivsNHtULIfFLfKtcIljFjl+Gy3n9wWpRkkKa4
	 2hfpNRKK9SDn7W563kbmqpEi5BMBAO8/11ojjpFpRk86vfHnIzHUdYYObQjE5itROg
	 7dVLtUMYBGrHeCmgfIkwhNphdx7vEKfIBNAU1SiFxMSsR8WWWVUIr8YcdBVx0GTpbb
	 c8xsaGsGc8MEg==
Date: Tue, 28 Jul 2026 18:54:42 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <amjQwq0o__j4Lpf_@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
 <amjAxhL-IeeJITEv@kernel.org>
 <20260728145528.GI651302@noisy.programming.kicks-ass.net>
 <20260728150126.GC921102@noisy.programming.kicks-ass.net>
 <amjHQtTRKKkxdaWC@lucifer>
 <20260728153341.GY751831@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728153341.GY751831@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: B420F140009
X-Stat-Signature: bxm5rm4i96caer3x3ccch754qtfdpzfq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785254094-310503
X-HE-Meta: U2FsdGVkX1+gQesJNoK3jmKDx+gevAGWtoq+vy04xeeF2BFOrQSx3Zu61T+oqiHbIzr7TUaQaRWBfPIzRsAukbYLuI6Zr55VzWdLEzjlHAxxNOM38mkpD/DyuwfmdK8fjTQhoUi+t4xhx7HlSLRIperhnK4F3wZTay6kz4dZnSK/pMrFP2RBQDxLTGDyOTiv7+Apglro5VODvkel4I9BfBhweWmIXXnv1uk03hb5v9KwX+2jJiiqM5vjiuYHn88vap12qGjS4hLjMvmaTmDGbFPf8MNHWKBjsc52T1Axye9l+cVZ09rpVNnz0TWMQ1im8T4rzgbT+dxW35mQXqj4i2StmqSBp/6lI+IcpUXDXhpf1x2vs7NLQtrAXWfCFc3oVGKFYFe/dT2KiLFaHDWyTzLPBEdLcJOq2lBtt7ClHoeRhVKsPgNUYjIxd2/1sSaSH3mu8eIeawcwIRMZX+fxBDSjxUagcJ4S76vbnw9sETloeD2KyL8yERPNTnLb/IRtKP9skccHknCReWNXZRXz1HqASWUzswJt2Z3gyWPrTWpbfkejCN5PdxaYM/kv/xuLP1LGpsk0c5h7SmciTpfIicBGJxA+gTYSNp59OW9NVc+Xt5eHOZt86E2k0wDDaDI0bcvhMNy2JTI/N9z/u/dHp3ix16BK0h2Ct1fZwY5UQS+YRDdeofCKSIaNjk837nlT8P4fDV67rDnIdAmbMNYhj0Wcwrl3aaKQfoYAVahPfQ/KsyZRZ08jlipvxRguitfA+A7wbDT98Le7P/QVdLVIR96w7ZJHouc2puVPVLdkwg+OJx2TwnQ9ka/ForYxJizAozD2o0C+vOKS4pyPYm2srNJwcQhyK62tDhOdoEdgDdLXG4WpkgeKdSPBo0g2jlC/r5Nh57IV8oqC4yI4krTK3StBCCAVXbXiV46QA7lQBHAsZodidQZ+JtBxg4CBEgq6bpa5uwuLUKH1AcvBSAz
 9gGOOm5l
 ssjS+t/NbaslEaSk0N30Ja/FQxUYtmAOs6rTDoLS/8l9Koff7bt7Z46l4+n79KM8wlNLVyXp0xJPLqdoXHG+qXIuk0sMazCkDhTqf0HOKaQX3Vop2yd3m1xUxjo3B+AEHaN5BABraCvlza7xUY0UC0aVH4rYRV0Xm9NArRntLFFxMaCMlJGt1eBIy6JW7BIE/LiheC+WOHlfjP+fWE7HRUY+Nq7Jge1Xof8dvnh5skxortsGw8v9nZfvyH3yDDPaJ30FVbx3RbeDu1dnEK0D599AtiJjyCNq6l/+DFEVcVKTwWuEeqYXpVcz1o2Q18w4ok7fKui9+v8/7vVLoHNwhhhKcOLrp2wh+b3cb653ol1OUQ3JelAze/GohU4ju0jX+9Kbn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 05:33:41PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 28, 2026 at 04:20:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Jul 28, 2026 at 05:01:26PM +0200, Peter Zijlstra wrote:
> > > On Tue, Jul 28, 2026 at 04:55:28PM +0200, Peter Zijlstra wrote:
> > > > On Tue, Jul 28, 2026 at 05:46:30PM +0300, Mike Rapoport wrote:
> > > > > On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> > > > > > On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > > > > > > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > > > > > > There was already a patch merged that removed the shole debug_pagealloc
> > > > > > > > exception. Is that not better?
> > > > > > >
> > > > > > > As I'm scanning through email this morning, there's another issue that
> > > > > > > popped up with that patch. It's causing hangs on boot.
> > > > > > >
> > > > > > > It's looking like debug pagealloc not taking the lock is actually
> > > > > > > functional, not an optimization. Although, I hesitate to say
> > > > > > > "functional" and would prefer to use much less nice words to describe it.
> > > > > >
> > > > > > Yeah, lets figure out why that is before we retain this wart ;-)
> > > > >
> > > > > As Lorenzo said:
> > > > >
> > > > >   __kernel_map_pages() can be called from irq context:
> > > > >
> > > > >   < GFP_ATOMIC context >
> > > > >   kfree() or whatever
> > > > >   -> ...
> > > > >   -> __free_pages_prepare()
> > > > >   -> debug_pagealloc_unmap_pages()
> > > > >   -> __kernel_map_pages()
> > > > >   -> __change_page_attr_set_clr()
> > > > >   -> cpa_lock
> > > > >
> > > >
> > > > The TLBI hack in __kernel_map_pages() makes me wonder how any of this is
> > > > correct to begin with. That comment isn't helping.
> > > >
> > >
> > > Also, the 'atomic context' usage hereabout seems confused. In particular
> > > the issue is with IRQ-disabled context, they are not the same thing.
> > 
> > I mean yeah the IRQs being off is the issue with holding the lock over an IPI, a
> > softirq allocating GFP_ATOMIC won't be a problem for that, but I think all the
> > conclusions are still the same.
> 
> preempt_disable() is an 'atomic context', but does not present the
> problem.
>
> Anyway, yes not saying the conclusions are wrong, just that the wording
> is confusing at heck.

How would you like to word this? 

Is this one better?

/*
 * When debug_pagealloc_enabled(), page attributes could be changed in a
 * context with IRQs disabled, so using spin_lock() with debug_pagealloc can
 * cause a deadlock. But since debug_pagealloc always uses 4k pages in the
 * direct map there are no races for splits and collapses and locking can
 * be just skipped altogether.
 */

-- 
Sincerely yours,
Mike.

