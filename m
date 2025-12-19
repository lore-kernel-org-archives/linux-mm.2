Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43967D78783
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91B36B0088; Fri, 19 Dec 2025 09:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28726B0089; Fri, 19 Dec 2025 09:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909506B008A; Fri, 19 Dec 2025 09:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 811C16B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:38:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2329DB7A9B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:38:56 +0000 (UTC)
X-FDA: 84236477472.13.9221C5B
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0E621100002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:38:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3KO2MkyS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3fGNFaQkKCKkJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fGNFaQkKCKkJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766155134; a=rsa-sha256;
	cv=none;
	b=Rz9z0nxjHYWKCNSotHlbnvFAaS4AsPVwa/v8VAo/BRu5rEbia8LEUgg3iWWq+jHhFdzWRd
	HCKivmdMEGKxtPM4HqS+yu/wMWlCKtHyuoMRIyLYYnDaJjilJ/05zlvZjrnaUEwjdtU3kK
	iIBWiGmZJOlX+tB9KzouLmx24X2yUyI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3KO2MkyS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3fGNFaQkKCKkJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fGNFaQkKCKkJURLNahQUPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766155134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOmyd9DWvECzG90gfBeqQtyNiAxdrLgSD+wKw6UfL7Y=;
	b=JHu/KJscpIN+F1xrlkKk9+0iIgtrlUPS39HW+nA2qiXecbNKPRdgKj53A3lMAm/Os4V0Xc
	GoVEbtVAKttPagADXEj4lZzsy+oq8PxVyeGVlxpP3fcxB3E95jyT9IltU1bILEtaj4VHkM
	AN1JMJEOlVM8ZTl0soiXznbxLIZ8atE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so10791885e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766155132; x=1766759932; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jOmyd9DWvECzG90gfBeqQtyNiAxdrLgSD+wKw6UfL7Y=;
        b=3KO2MkyS2XeMKQJD/A11zX7F0yVdo068q9lV5Ah8BMYT3j9ltFMUJVTEcA1ipvt7/I
         e4kqzickQsKarQmqMTdCC2BUmXAy0QEmnehCXckYoeN/oi6o7QZgZXIQ0nv8zTVAe64o
         6221ceDitRCz51BLSZxQlykFS61iqux62Kzyj4NiaPDhRE3HzDqZVxFhxAarZG6mLJx1
         jDoTqXc0d0wTmC6qvXbUhzSfeUASzfJ/2/9Urz02mPZ9FYn7sr2dJJTipdK6yY4VmfcM
         v0+U3Z0szXPVCVhI7ewvKM6S6Z/5AGJYLLVEXSdqY2E6BHzuUG5pSDTEvIxTKTBdIARr
         spxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155132; x=1766759932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jOmyd9DWvECzG90gfBeqQtyNiAxdrLgSD+wKw6UfL7Y=;
        b=bnTRFFqvnl5e5it9S/sQb7mA9LGRvc1VIQhHQLvQCbMVCHDUTyfU7m5GBg+31cNY79
         6IXm0bfbmK2NCpnB5kvZ1BgWkJjkJbOzhIDp+gpz2Ztb4fU/s8/DKvznLO8SsLVAuhDF
         kIbaGIlIv97nXnoQyHivG2ZdsYi02gPV5EvWhuz5Ebo/lTIzgF0RQg06gf19wSSFsQSI
         v/55qGuF9IiHSNFodXyMGyl1sHQ8x9EA5DbLTvIJz9/QzqbA6pEBai6PGy9J/LOfgxQm
         xrh8/ErZgn9l0jIaXvBz7bvdz4I1TV9MnMt4CSMw7BQK1Dc+LCHOZJ7pMuMpoiZto7gX
         imog==
X-Forwarded-Encrypted: i=1; AJvYcCVsa9MLKBg51RGWtjAHZrukhv4fTPG+VJHXnsWvfvCNVBtoRbA1r+s1iD/BqjfvtFX79ibf43MYrw==@kvack.org
X-Gm-Message-State: AOJu0YwVGF6cpV51FmkHJJD5of5narpMcltXSM1cIGSlsfc6NNHZAgRW
	xVqHWGrOEr6UFI//kOBw9/Hyjif8qok1XVptfmsLoxxUWiPus+GzyV/F/iHoaKK0P9dUtJdZi3S
	xnv8BX3g4gJkSSqGMsw==
X-Google-Smtp-Source: AGHT+IErMGwUK2SBp0iKRCGeYMRpkaCULx6zVFN8P1+g0RA4ffuZbMddhqUM3GNAvGi3LgVlXFFniESPnoRBsS4=
X-Received: from wmbz6.prod.google.com ([2002:a05:600c:c086:b0:477:9b53:8816])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c174:b0:477:b642:9dc9 with SMTP id 5b1f17b1804b1-47d19582bd6mr30147205e9.28.1766155132493;
 Fri, 19 Dec 2025 06:38:52 -0800 (PST)
Date: Fri, 19 Dec 2025 14:38:51 +0000
In-Reply-To: <20251219140557.GH31492@ziepe.ca>
Mime-Version: 1.0
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com> <20251219140557.GH31492@ziepe.ca>
Message-ID: <aUVje_QZvJ9rjedp@google.com>
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
From: Alice Ryhl <aliceryhl@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Robin Murphy <robin.murphy@arm.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E621100002
X-Stat-Signature: mxt4kbw9yx8mbinraunwe7of8cmkm95o
X-Rspam-User: 
X-HE-Tag: 1766155133-232508
X-HE-Meta: U2FsdGVkX19MYYum4CYFTT/kfCCZzNh3QBZgafK3367336/1Lrs3LUXapKrtajVj8AVNy4eAU5KXNKEES3AtvMv0J7w30JF6Mhmis02YklMv051OaffIc4b4kcfmrzsbavsVyNBwbvNSoRYxLbO2bpUFX6M3l6zjum0t0jmJm8Dxh9LCK0+m1Wm2NJ8e96BFiTCPZ5wA/5W1NEbm8rbk/UAQE3zXT2f8GSd2mhv3ctcIpIez/HxHg5IVgyVrxqn2NZvs3xm+YRsbZYa0dniAXpLz2qcQvGtFRJFfwmSoC1HLQX6iIQaSAvJM7wICWM0hLlBC7ncw0pdO7sKiB05t6KeX3TaGf8OkxDfLS8WUsY6jQgCTbZPRzBUO+TjIlB0id7uxnaMDYebrQecmYfMR7C4kB+/5fCbeSlnVTNfzyY9GHT0EcG622Itisy4n3iMira6WXIS4lpWkmnDgb59HxOWvFRQ/tFSz+hv7pmKRG2g6quPQ8GbrYHU01V78H0cf3wiJt9N9u3WkAOIOpofWnsh6uhLXQryeWe885HKJS7zRbt9bXk13yDgmLWVS8T4K1i5EQy5IQlKLa/+n0u5Z+7qVjxJewsku+12a4nWMiwQk1BaOP8u0dluHKYclcVWoWEg26ggxN2BvEJZFQfziPnBx5vGZM5ptpT99EjWandzMCuzdQj4CK4oxyJxJ1bxKr1mg+0X/4Rnb/CwwJ9llaT77880jhJ1Yl66h3qy70xp6PwBi8TlmVR8tL+j8rx+xcAGkMhaHCXNNXw+5a+CtNIpH8yPQBit1ufD+/LWERW1XYG1wio7Y33w+Y3esK0HT1tvqC4CcbOLwnBF/iCCTSBBaOzakxr+r3m4pXwUEXx2O5IsBRlOnNenFbBULzBhtiJwzQx4fqRAraJ/XQUQjp5ePKiSMrG1ZNDS0ejGx02bylFvgiP99gF2PxWxl3JuuM3Zxjs8F1bNVwu2+QeV
 vAh9Og9N
 mbFXD9AEleikYonW4R2ZpNIjsc2AbMUrUymHtqEr8R61cZaScsnJwEZTsFLsJDV/qji4VmdS/4INSTEZO7meqRNoYCgSoTMroXUFt4kKcrSlghVu/Zey/nrkZUcYN41PCicUwonvK/KPa9ch9Uvgsxz51QIslweIPLCP7fIxR0/zxpoHJTfZpSBCEAp4N05BG7dTDoqwp08rf99eeIj9II23GSR171JUykgYm5ONDIS4BfLR71og0HEheuva5ypxE7Ab7vofypFHH3ZPKD5/RNeit1JPmR1QEhk7tWyqaPkipx8cRjahcTgtymXsjZ9ORikBfpMvHKbc7lRi7TxDWJVVFyVlVkkWedVwF280CTspY9P2FgAOkCdagZK9LiffYwfXgP9LKYGxUHpo07jm6WQampK5ZrhdlTfoLqTfgyc1D1hM27UxoXMzi8S7nQ2CIT86GZy359jbcGwp3nEiQ3dYqYaoi/lkjUjtene/ABCaL8Rz4VgFIYfJDjttK5h2Zs8orrgHchTDtPWovFSgwunF12OctdqsbU8bXwms7m6qj9hVlj+9FFYo3ajnjDVsH0njB7VQP7sCkW9jC3X/TMgDAdfeGGG7PtAVbWLWF0pQnxOVcW3vagn0FZcfOY6wIkQloAyygG6HawyjoNyphWsBJiP73rpem27b/uonGD32Bn9pQfqXl/Vt9VlMMqitQ0r3NH9KWeOy14AA7Xxl6XTY6ldUlNxTbuogLdfGxsPhSqeha53Y/jypR+8wFn6E8SbZHdASW9ZnTwKa9BigTKgZFIDrfGpVq3vm+yd2Nf7uE86NDVOkppnZcMD+FT0lFsrjV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:05:57AM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 19, 2025 at 10:50:52AM +0000, Alice Ryhl wrote:
> > +// For now, we do not provide the ability to flush the TLB via the built-in callback mechanism.
> > +// Instead, the `map_pages` function requires the caller to explicitly flush the TLB before the
> > +// pgtable is used to access the newly created range.
> > +//
> > +// This is done because the initial user of this abstraction may perform many calls to `map_pages`
> > +// in a single batched operation, and wishes to only flush the TLB once after performing the entire
> > +// batch of mappings. These callbacks would flush too often for that use-case.
> > +//
> > +// Support for flushing the TLB in these callbacks may be added in the future.
> > +static NOOP_FLUSH_OPS: bindings::iommu_flush_ops = bindings::iommu_flush_ops {
> > +    tlb_flush_all: Some(rust_tlb_flush_all_noop),
> > +    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
> > +    tlb_add_page: None,
> > +};
> 
> This comment seems quite off..
> 
> Usually you don't flush on map, you flush on unmap. The TLB should be
> empty upon mapping and not need flushing - except for the rarer
> special cases of clearing the walk cache which cannot be detected any
> other way than using these callbacks. Doing a big flush on map to deal
> with the walk cache would be worse than implementing these callbacks.
> 
> The flush on unmap, at least for ARM style invalidations, needs these
> callbacks because they provide required information. If the actual HW
> does not use an ARM style invalidation system then this page table
> code is not optimal for it.

You should not assume that the way I worded something implies that the
GPU hardware does something weird. It's more likely that I just got
something wrong.

It looks like panthor / tyr flush the range that was modified after both
map and unmap operations.

Alice

