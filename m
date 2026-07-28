Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4A4C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2381D6B0098; Tue, 28 Jul 2026 10:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C29F6B0099; Tue, 28 Jul 2026 10:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016D76B009B; Tue, 28 Jul 2026 10:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9C996B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:50:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03B2D1A03D1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:50:51 +0000 (UTC)
X-FDA: 85038472344.04.95BC6B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55497120002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:50:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AzGVKV1O;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785250250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8aX8+NOKX/9GpYKQyqHDW9REYVeXE4o7JCL3uD1BMs=;
	b=VVe5zOSQVXEGmJ8zgLYzLjyMy5ZMGInMnZOWEsdHzkPlehuznY9sdQCPiy1EBzdxKFMtlQ
	9di5porQLClnlDSyFj5CWnA8UaTFsGkgmJB3vkqzhn3FoEYpSvEl0QuBeRDQJ4kujQ4RuV
	RS/R//haQZAtArEjPMrVH3nR+H0PRhA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AzGVKV1O;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785250250;
	b=0RZ5nJKvJ72K0uq01dRwEBnB4kLbBWFv+hxnTpea1j/cN+v2FV7Ld0w5z3LnP4YUmtafbh
	Gajplq9qwRTJFHngez8EgJspAGKhFQD35Q6NRYPSJavTn0oqkiQpPeMABkZOdgYOn3fVPc
	flp7MeMcD/m9uLaSI74rCnPrdO22Ev4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 418BC60A97;
	Tue, 28 Jul 2026 14:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23D81F00A3A;
	Tue, 28 Jul 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785250249;
	bh=d8aX8+NOKX/9GpYKQyqHDW9REYVeXE4o7JCL3uD1BMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AzGVKV1O6jDCe07R/2Flut5AvRNLGCJJBd1ulPSe/37OmJu20kbCCL9zQsA+hxx1h
	 CUAM7UFq4p2pyNuyJGP7cMnhZQfTYLYJR3tB4pJ/wXuhIPCfz+baLerC6FjIfdb4FI
	 FCdoHLG6jobXHbwWHp91U3am0o9As+OGJwkE8aT2MBUMMOSv4HQsRMRNiIG9CqTek7
	 IGoqQUHVnhtD7ydoT3mY+wbvkzzjXodEYEcTs5urWxgcyizpRL80Vex6QCYnliWrNc
	 4GUrtivP3Unhe6hKxxw001iubuBvu1x1yol/x2PvIkam9r8w05ux8inyMutradFQ4+
	 cLcp1Inz8taIg==
Date: Tue, 28 Jul 2026 15:50:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	Dave Hansen <dave.hansen@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, David CARLIER <devnexen@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>, 
	Vishal Moola <vishal.moola@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <amjBb7djBkzaxcqR@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
 <amjAxhL-IeeJITEv@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amjAxhL-IeeJITEv@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55497120002
X-Stat-Signature: 4r1pwzznx1i1ecdd67ssj9fwu6m5meoo
X-HE-Tag: 1785250250-408961
X-HE-Meta: U2FsdGVkX1+4KOtYtXEadtrOE1/e1WOCDVtEUnE4crgInxZAmftMjpwfwTpyPFr/ZRO0Lj/mnhkrzi+zXePkyuei9yo4mUiJxFpfnOegA4+4QQYT8ZXgLdxVSiQtARoIW14YBSMm3LSYlz0hcrl4oThbL37JoI4rb0/SvKjV2lyOpSNa3cjuCck14Bukw7WELDQjpDYZzYrF42sJKC0Nz3Yz20oAIUy+SAnwaGoZtFRPTM+/LJLYA3GJyBON6Uj4Ktr1+/DJTyAxo5fz4UtO+3q0a0JcTRZLk1IYYcTqY378kYdEJxypwHZwVt8CeSY7Zt4Lye7DIwSP2ah4TMRNdPT45EiYx7cZUHv20Aof6rBhKP7+nvrYzwOlrBscD6hxVXrF29kA8WwkN2JdgQVzMJKxHGjMnpHsbI8qCe0EqXPYj0cqq6yt5xGT5QaHa8C+Ek9JCNd0aYN+9ssYQH9l7w841MaFkI04nysRkL6Mx2JcELTssfJz4iC4+I/RpiJKXcoJ2MYo1A7qsC6sG5yEBSGDaxxDpixvxncPht6Y7Ymzv+LrHXadLaIY25dDHHn0ftF/Dxm/bkmb0xO/Plqu6q8cgS+yfQqjgiDyGwtcDK4fTdXZ3rfB1UgAHCiw2igwpOf9qrcsTD8BqBovI2POKP/IlLucKvidRDE8IO59cA3XjHzhA/8Z4G+hYtSoLtbFygiBNT0QHvFZknGd7OHwsWcWp5fk+uHhNzoFGnuuwWsFMKvbdNWxFXIeZN87FJrBVTCD58r1Ep6dXpz0Gbmj6NRdjjbXTWB0G3O7yVH7CVmvW7Ukg3jsFyJnPIFMtYvhyLgXIV5gjJYyTOFG2+tB1Vct8Jf3/Dv5YQdthk+hPBgAkxGM57nsdQoTAPXSj1joCwbH01EPnKcTTv2dzuI8lNEVsCIvL6Y9Pc2/+cwokuZ5fhfhqCregR29kXE0Tu2SJnClpHl+eiFsrKgVD/x
 WNZ8Ib1Q
 raY5Qih6rrb6ysm3ubo8utIbRm5WfpfWhn0jSEpEP4TVMjxQL/ZQ88jD9Fuld9u2NExQ3saSgieaDhyJfasEr9ZoXxAdtEvqBgJ9l2eyXkHzc3LcZlqCJlS9O9jtPFpTkKk+jTP/eLSwywV0jg0x+PojLS6++bl7GUBrS3R6K51MNqRrwcoC8PVlrhfbgi/2depdLoJI41ti32SIs/Z8XbYNNcpaAnGWmh8RulPcHW9LimI6EGfQzvIDhmQeDmTUgjJscy5lMY0/Yb2F8s+EGrIhweLd68kmBXqaKgNpJEwajHrYb/ZkBPZ1A9VcJl0jTiu9tN/iOUa9YywStSy2OFEOfS6I4lQLSbSEvfrVJfHA/ErCzIxW+KX+CYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 05:46:30PM +0300, Mike Rapoport wrote:
> On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > > There was already a patch merged that removed the shole debug_pagealloc
> > > > exception. Is that not better?
> > >
> > > As I'm scanning through email this morning, there's another issue that
> > > popped up with that patch. It's causing hangs on boot.
> > >
> > > It's looking like debug pagealloc not taking the lock is actually
> > > functional, not an optimization. Although, I hesitate to say
> > > "functional" and would prefer to use much less nice words to describe it.
> >
> > Yeah, lets figure out why that is before we retain this wart ;-)
>
> As Lorenzo said:
>
>   __kernel_map_pages() can be called from irq context:
>
>   < GFP_ATOMIC context >
>   kfree() or whatever
>   -> ...
>   -> __free_pages_prepare()
>   -> debug_pagealloc_unmap_pages()
>   -> __kernel_map_pages()
>   -> __change_page_attr_set_clr()
>   -> cpa_lock

Yup :)

Without the debug stuff you have this issue.

With it you don't...

Also without it Denis's patch is broken.

This series Mike's providing is fairly exhuastively the best way to fix the
various issues, grouped together and parted from mm to make everybody's life a
little easier...

>
>
> --
> Sincerely yours,
> Mike.

Cheers, Lorenzo

