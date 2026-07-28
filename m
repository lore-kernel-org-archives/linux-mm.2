Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79B9C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A856B0093; Tue, 28 Jul 2026 11:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13666B0095; Tue, 28 Jul 2026 11:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29376B0096; Tue, 28 Jul 2026 11:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB9C6B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:03:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1522D1C0198
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:03:17 +0000 (UTC)
X-FDA: 85038503634.23.11B1DA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66A2F140012
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:03:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BsT11Mus;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785250995;
	b=SERpA8YS6azowfxKRcXRaUH/QDH5pxpsjroTZfGNpgziq5qgffrdGH8A0T4UPrkEGZx86S
	DwTMvPkCgVMT+rjFZYPJ1HYjwp80kfVJdp2cZeq58X14b/CX/dEEjgiBRjG5JZCHpzOC9L
	OKZU2qiTO+unhpVo+W5eJD3A6mlPTTs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BsT11Mus;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785250995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZYCAEb0HM9rfGd3QRD8GMQog/bF2RXcJS7UIluiZL4=;
	b=8ikhp98a3wttJ4dImHGmDKzWoA/hN7tI93BsfJqeGJYtOqs6Sb0oCw3w+ISmpM8PbNEcGq
	lZqnQg6TQd1kodGZZUfvXUxkIzgo6lKnSoZPDM129CKjzAASBSvkf1TvwfLdWYizXYPT6u
	AiEzW7S3oz3AVTt2o0ruH0i7yzep7Lk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D118860A89;
	Tue, 28 Jul 2026 15:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3221F000E9;
	Tue, 28 Jul 2026 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785250994;
	bh=OZYCAEb0HM9rfGd3QRD8GMQog/bF2RXcJS7UIluiZL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BsT11Musj5q8C0iTcuGYFJ6t+D6ns5bM8zQlELONuV/VX/yrCA018Wh0N7Gwlznfd
	 aotiaq/I6OR8LKclH4M5+e4rAxmJyw3vUQECHwkeFMfQIQ/tFPlCTWglK3b/Tpzdww
	 +bRNamfIQhuehUPoKSWXhm/ZLQvVUAWtUFMzGr+dfkJUvNs5Ryut3TSr4HBqIqxCdV
	 45BanpsTI0eHKnIwuq5OGl4NbtzaGlFQdEx9DUFUydqVDv7DsG4XLVGAH0lz5LJISE
	 muvDh8wTByYOUEi4WYqtLE9IsNM7nj4Y4uHVDKRCrIrLpKMxJrdjaTi8nK3Kwr3pXt
	 8QQmczoQHS6GQ==
Date: Tue, 28 Jul 2026 16:02:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <amjEJ8XcwOCAcxFJ@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
 <amjAxhL-IeeJITEv@kernel.org>
 <20260728145528.GI651302@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728145528.GI651302@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66A2F140012
X-Stat-Signature: gtyxiamp867weezizi3oq5zbbzqt3g5n
X-Rspam-User: 
X-HE-Tag: 1785250995-541548
X-HE-Meta: U2FsdGVkX18gyurDj0mTC13ISpELTa/scAd2SdbwJOyQ+WMngnZV1MjzifCprqaUmNtRTmq6RFPHnPasaqfOAXJU0BzetvHpTYiG3SHH43go5EKksvxHx4elnWAUrmErF2YecYxVxoGsFJNVCOAx11WWh39Rz4o95ZQisBdCTL7lEqIOC2cig8tvgXPfJdjjLKsiQuXTPGBYamdwUVzmTOiQSUdxxb2k6DblJN2+q1f7HnW8D4jIja2w5qR7zWFz+pIJJMePBvu+jFf+dAN90DUtsKZ/eBvnrRlVaJzqgGsa0NnTwCBOaO7yTakCnsxHUjbEq3KTp249bbK1sXXw2cIN+N7HE0GeDjFp4Smz3YnuglU2pKp5/elCpeMUq5baRgcSzu6//3oyqjAnSMkVPBN/zumKpLx/tWr5eRxN/2tWSUAW6yJO4H+PY2VJBP2oDqT68QwLptPowaXPAr4spsbLHghnSweheye7UWlPmZH81UhmzkO3GbokkH6WbjxojlfM23m9mFCyuI2dqP/dR8OGU16bdYOmXYj47p2725K/q8HiO8uzHQ55jwrc0cIXDQQ6qNYLZ6sqDUp8GUHeQRTQjw+BeIJmW4QN17Axl7GnA07ycRHOgApRDmJgh0X7SlC9o9WxOw90HXHTjfTU3bwg49a8PXZ2/F5qC6gHmmubUk4geHyHHpQK/Z/JqsXJ4tJkSrUan6jlo4fBsN3+k2dGrM9gJ2vovZ5luj9IXgp3JxoDuBGlYWM8+XEjBuWmKKf5AVMICwnWQf076BwxVxukKzpK88zsYsZ4RSJiP4hunYpMHIcEk59/VvHWQPRfiM2InLZ39OFbjCe5V9udmCoz1Fn5Y+H2bcbgAQroO4RTTlwWDX2YSneY4z+E8D2sswzI4Izoxwlq9gz0Si7inisjMsXD5vVGBMPVbSuRDR3rAmC8bRFWJYuIEKoykLuxXS4sez1Jg1LKrtLjtfH
 VVA9OUuZ
 V6xmr/C1WbcDq0WTUH6/DLcxFizfTmYBiaO7qKVjy+XJFpx3aG28Obdkyz9rbqoh5O+IEk0C9+PoCDFO4/9Le9SuC0UzuLznoWost4eRjE+joy9SoD9XL6KqCz1/2oe6guxRdJ8h8CxogLnzv5D9Z7Y1w8Lr/uoR7cltZzT1AJiFJKauQB7TbjUWfQbXfTOHThsFVLHjJDuzwvoaw7NgX/lyZiJyqIb/Gn2ypzKKrDeJykGckOI8TfWWbtXTjr2UUVtot2iuycnwRQ6BPaQSH3WucGsrtS536BA90WgqrZIK9t8Xg3A8KEZ9rwGZ+VxpWt7upMP+N0sBur1rL3C2tQaRvV2xdSV4Xxgx6Thwi3EIeGBXgz4o07HXbLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:55:28PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 28, 2026 at 05:46:30PM +0300, Mike Rapoport wrote:
> > On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> > > On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > > > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > > > There was already a patch merged that removed the shole debug_pagealloc
> > > > > exception. Is that not better?
> > > >
> > > > As I'm scanning through email this morning, there's another issue that
> > > > popped up with that patch. It's causing hangs on boot.
> > > >
> > > > It's looking like debug pagealloc not taking the lock is actually
> > > > functional, not an optimization. Although, I hesitate to say
> > > > "functional" and would prefer to use much less nice words to describe it.
> > >
> > > Yeah, lets figure out why that is before we retain this wart ;-)
> >
> > As Lorenzo said:
> >
> >   __kernel_map_pages() can be called from irq context:
> >
> >   < GFP_ATOMIC context >
> >   kfree() or whatever
> >   -> ...
> >   -> __free_pages_prepare()
> >   -> debug_pagealloc_unmap_pages()
> >   -> __kernel_map_pages()
> >   -> __change_page_attr_set_clr()
> >   -> cpa_lock
> >
>
> The TLBI hack in __kernel_map_pages() makes me wonder how any of this is
> correct to begin with. That comment isn't helping.
>

I think there's probably more horror shows there, it's a case of put out the
most immediate fires, leave the probably remaining flaming trash pile for later
;)

I thought x86 allowing arbitrary mm ptdump walks was crazy enough but this debug
pagealloc stuff kinda pushes things further crazy-wise...

