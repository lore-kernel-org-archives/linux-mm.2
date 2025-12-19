Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 492B6D78786
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996A66B0088; Fri, 19 Dec 2025 10:12:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BE26B0089; Fri, 19 Dec 2025 10:12:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820176B008A; Fri, 19 Dec 2025 10:12:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7EF6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:12:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 333ED1303D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:12:03 +0000 (UTC)
X-FDA: 84236560926.05.F18A844
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf12.hostedemail.com (Postfix) with ESMTP id 251FA40016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:12:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fm8LUnUO;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf12.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766157121; a=rsa-sha256;
	cv=none;
	b=utmbLfb4AVV2ZnigVUV98wZf5uNScVbxM6IVqaIc6No7DGBbXIQNyYC56aBPQSV6t3wCUQ
	MERe+P0cKXS06xDWab5sZhRgaKzA12yPEigbhpA42aS4707CcCBVvXsOY6t39JsVk8qK4B
	OYKzSURujoTGy6wr5M3QRSNybtbuQ/8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fm8LUnUO;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf12.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766157121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDifhEBRD+OaehkuaqWPLTaYGTDec8iM6CzifJ5l/1A=;
	b=fORofo4J/63eq/lCsbdIuNVqOxuEYKfEDT+k8S5wjxfUj9cdR+UYuaDkpIH+4w0las1lix
	GFgGXrKbCWw/GhtpDB5rIN+3ljUDHGBsk0WkVV0N9r5lpCibb1QBX0CALmSOyCWvo/LuB0
	TODdBzXZ8BQTz/rMZVaLSK+XCR40npY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1766157118;
	bh=hbXC2AdsrfOcablKNwPdrwTw50dVWbz4YA+va0S+KXg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fm8LUnUON6zeA0olAxNc0JU+8h3LF7uwreCv3zmfhIqhq3cZIVfo691ye0odnLRjx
	 ya8cG6pNcSmizToFufznzPsErbNG8+ZH6J8/ihp/tkBL8ElCiWasFSSGZU+do880P2
	 l1a+SXVcQtzwxTEpXy94YKF/UUw7Nqg2rxGb4ZHYKfxrB4W7nnP9lXxKoLyrArRHrq
	 bLgVJFttqPGml0Gd21HOgdDgLOl7Lu7Na2gMtf3T6O8kkpDPcNusGaxq00jP1xhGMJ
	 L5O9f+aakBx+R/WoniuXLojoh1DXotOx7RC24OshSCo1vfg4S4JlfryWWrXkkNUgPV
	 xl+2BLkR5XZSQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 820E817E0CA3;
	Fri, 19 Dec 2025 16:11:57 +0100 (CET)
Date: Fri, 19 Dec 2025 16:11:53 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Miguel Ojeda <ojeda@kernel.org>, Will
 Deacon <will@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
 Robin Murphy <robin.murphy@arm.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, "=?UTF-8?B?QmrDtnJu?= Roy Baron"
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas
 Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Asahi Lina <lina+kernel@asahilina.net>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v4] io: add io_pgtable abstraction
Message-ID: <20251219161153.420d1c46@fedora>
In-Reply-To: <aUVje_QZvJ9rjedp@google.com>
References: <20251219-io-pgtable-v4-1-68aaa7a40380@google.com>
	<20251219140557.GH31492@ziepe.ca>
	<aUVje_QZvJ9rjedp@google.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 251FA40016
X-Stat-Signature: 3w14q39wwri6rta8jej6p4pic3bykhbn
X-HE-Tag: 1766157120-911443
X-HE-Meta: U2FsdGVkX19oNc6lVwj7RKPWI97DIQQHJ7pfEh8ascrYbFYslZj+BrowzJvKznvGK0bnjp9rjKYAX1x4hXBTSOv4Y9aOuCoqqvKkulmI6jySOs/pCnSQA4/BlaQIO0shTC48cb5K95nK0g5m2NKCr3XgYhRfLG23YpBuwbjX4TIx4YGERpdwNyyffyZJlSKagchM2zUagL8df9sbY4Op+YpJQq099ksV9VYEHgaKy+gcEfCDhnjF3U0DbktzF76ERoTiVzZ0uEcsvecA8fAudTFdfJtcfSSGo/9hnhQHmiuuPszgDoACiOO5KxN6FQJZiHJKsnfYno0Io6HhIct29RVCEk8z63RShYGPBRrTH3M0H/8V7Ev9lO1Atqon5WZPe6NhAjK4Ky9b+TQsdvAfQ3m4qyn3scNCs1OdC7qmMhKmHvYa7oUAMivRauKODrtldBW6aeEdRUeQmDd+aSkMWQLRzHUzF0+1kLRSDTq1RJgg2YeDJAVxXafgd/pdiCeui4PXpnVi/n6B7wR4Mb98tJP5VXRmh7Mf7ikJNhGiFAKVT4Omnm2TZUPOdxRTeZwJnM9BFzMm8XDB37WRS9Ke4sB8al4ILyAdKPdh9WmWwDPhxtt4MAmdVnG1Lq0NkfmO5Vb1QzGv+zS0KilKuVM9WTH3+RQtimdQdvPDm3GmarfNdLGUaBOwlGRNsGKcGnUgbtzw3e2D5gqZ9azEB2AaeHUygIda4z5+FB1avfYtWfkAUDyeKhf3CxSeMRs9gS1/1ym7/0HfxUaX0//Ch9I2sKAnVEeRhuHkrmD2h69MIVJjICzkPSDYcPJwP8IxqdnPq3fKrr3ziLMBArv+XaJjXneCm+9UVYjzSU+ot9wdMKIxw1DSdIQp3qqHrUzKhu3gmf2kqwMWMkngWuN0pDDeSrUt1ZPGqboDseY7imS7/Lez0Pc4HqGejK5+o3SibAm4eJNSYXiPfQMhe2+iHjd
 vNjj7uPj
 ZPuT71vqLdXilB4P9rogwrGwHCvO6AHg1fi1cjVmgj3DcoMoSBlWeSC+pMHWAHrT1K/k+B/+uD+4XxoPx65ZFKjCdV3ML7xVHbqqlsUMsUzVy+PCK0RFXiVsqGOORYv0jrF0+QZiXQphed6dKFkyg3FI3HASPrDap+yhoKtPAJKSqrdMSaz5GUB2pu/Runz3Q8MCC69z00Q2kaMKtxhDJ86qS1nT/kSpM9vIpuBfjHl3QiUNhLRvdXWn9NphARu8JUJ+WrN6OGHqhz/SC11FIvXnAUc0/L6aIAEfzm4k2uiQRBpHbhB0vs/Qc4QgN2kV/cvQNn48D05o0S0/nWFDGx4CNJQoeVNji30JyzzbjMkAT8fwTd4wrDTQ2rOrZgBy1Lm7cAMWoCmnkN84Ppz9JShJE4yXCF9awRcvJr21LPK+5lZU9VtTlyDqe6hPgz00Qq2x2e64DZgYRGh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 14:38:51 +0000
Alice Ryhl <aliceryhl@google.com> wrote:

> On Fri, Dec 19, 2025 at 10:05:57AM -0400, Jason Gunthorpe wrote:
> > On Fri, Dec 19, 2025 at 10:50:52AM +0000, Alice Ryhl wrote:  
> > > +// For now, we do not provide the ability to flush the TLB via the built-in callback mechanism.
> > > +// Instead, the `map_pages` function requires the caller to explicitly flush the TLB before the
> > > +// pgtable is used to access the newly created range.
> > > +//
> > > +// This is done because the initial user of this abstraction may perform many calls to `map_pages`
> > > +// in a single batched operation, and wishes to only flush the TLB once after performing the entire
> > > +// batch of mappings. These callbacks would flush too often for that use-case.
> > > +//
> > > +// Support for flushing the TLB in these callbacks may be added in the future.
> > > +static NOOP_FLUSH_OPS: bindings::iommu_flush_ops = bindings::iommu_flush_ops {
> > > +    tlb_flush_all: Some(rust_tlb_flush_all_noop),
> > > +    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
> > > +    tlb_add_page: None,
> > > +};  
> > 
> > This comment seems quite off..
> > 
> > Usually you don't flush on map, you flush on unmap. The TLB should be
> > empty upon mapping and not need flushing - except for the rarer
> > special cases of clearing the walk cache which cannot be detected any
> > other way than using these callbacks. Doing a big flush on map to deal
> > with the walk cache would be worse than implementing these callbacks.
> > 
> > The flush on unmap, at least for ARM style invalidations, needs these
> > callbacks because they provide required information. If the actual HW
> > does not use an ARM style invalidation system then this page table
> > code is not optimal for it.  
> 
> You should not assume that the way I worded something implies that the
> GPU hardware does something weird. It's more likely that I just got
> something wrong.
> 
> It looks like panthor / tyr flush the range that was modified after both
> map and unmap operations.

There's actually a confusion between TLB invalidation and L1/L2 cache
flush/invalidation. The things we can decide to flush/invalidate around
map/unmap ops are L1/L2 caches. The TLB invalidate, we don't have
direct control on: it happens as part of the LOCK+UNLOCK sequence, and
no matter what you execute (map or unmap), you have to surround it with
a LOCK/UNLOCK to provide support for atomic updates (GPU is blocked if
anything accesses the locked range while an update is on-going).

Robin, feel free to correct me if I'm wrong.

