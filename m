Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69292606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZ7PzxqK
Received: by kanga.kvack.org (Postfix)
	id 3A64C6B05B9; Tue, 10 Nov 2026 23:25:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DBD6B05BA; Tue, 10 Nov 2026 23:25:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCED6B05BB; Tue, 10 Nov 2026 23:25:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 021C76B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:25:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89060401D4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:25:07 +0000 (UTC)
X-FDA: 85421548254.29.527AAF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01C34C0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:25:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZ7PzxqK;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371106;
	b=2hsJdnH1uEYBLF3VCAOE40qWV3zkx+AKxg1yYuOXmcsLsMYgGQ5JHBy93aD66094GU02d2
	YDOFt8ipEZkPow6RI4WHD8GoA3r/SDwa6GU7Tph5fxAMbzKFt7adU0TbTbLz8j5fYxASUs
	4V4RvtczYzYRod7r72BkX5fVOSBD/bk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZ7PzxqK;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371106;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIGOfIqty5WmF9m/oFG68PzA/sTP+YnuJipwBQIjsAk=;
	b=cFH9m8EfR00bwWwNWEmUuJDEvLs9jC64V7c26ApkMHhQ3pksVSNps7WxjOCXvR3spsIvqU
	+fv0X7sKTtmN5dRmOPipsdikM3McPbZP9RcIdq0pIn3sGVzi04NfAyeANFASJ0YOrvhI8s
	Ofd6yMfENRgnVsviJiwTkXeLZPj20/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 103D461162;
	Wed, 11 Nov 2026 04:25:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A4E1F0089F;
	Wed, 11 Nov 2026 04:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794371104;
	bh=ZIGOfIqty5WmF9m/oFG68PzA/sTP+YnuJipwBQIjsAk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OZ7PzxqKOxlm5xAfzYFww0chMklkLL3FTViiMh8or+Dp2kXFwTOT2RZ9Rd/vB8gzM
	 QjSUbcU1fJY0BcB5ktDGUhra68ZuQbIsvaa0tgu46z+nkvwiGX4dJYjjzjXBkglnJ1
	 cvRl/FkqcK5cu760SAha675YsLPeEG6yCu68DglbVWTpdOZ0iK1eiJtHIcVb8AQTK5
	 La7NLYZNBYRcbEi/WM3I4zmjD+L9yfUjjWV0VfJPIZX8rn1nNr4Q/b/5zsjuYNm6PA
	 jhzkc/qfYyFbXUQlBM5Hr4acckYAwGoQLO1KgRbAZER+CilVh/VOD3YrEAdc0xfyiV
	 PsbwSqUydsviA==
Message-ID: <sashiko-outbox-208280@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 24/25] Documentation: Add PISA architecture
 documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Christoph
 Hellwig" <hch@lst.de>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "David S .
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Willem
 de Bruijn" <willemb@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Alexander
 Lobakin" <aleksander.lobakin@intel.com>, linux-mm@kvack.org
In-Reply-To: <20261109182533.3594984-25-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-25-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 04:24:57 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01C34C0003
X-Stat-Signature: 1gpafjkewjhwxj8iqkaegwu4b8g5hy7a
X-Rspam-User: 
X-HE-Tag: 1794371105-264874
X-HE-Meta: U2FsdGVkX1/x1m0KwDf3oaOpxdSEay7BQKykRTloRdDwjG0WKThkL0sZOKnpso/F95IsdaScGViCMIM8FIpzxpckVoDTBqB51F4Nm3ETlyiTffnaUQI59bJZx1fYW5KVc5YhRXbL6n7oQ+ya9dHFDcHe6X2B04OWN5EbxlCKptv/iHQHzNgL7WhSWzMsLDB5Ej2CEapXvyBJ6JZjAz+tUhhPkJpk6gHwIwpBcEJYOh080/XGosRL/EnvN20Lz9roSPas96wiOD37AJsEHYL/W1l/IKFFqHXnqQF5NVbajyVriMZF0HDHUwp6IbU0cB0i9RFQiER2uaDxXlWldGP2odQ+xOiWgXpGgHD8Q89urQIfPRooqKUPKjFRe1HjSZaPq4YkxlOl7LgBN2AXIQQhze7PS30Zgbl7hHzF3KY3HrOLAb5odPtyacy1J8FFq6t1s6LW0DFjjlzDPTMyrYhmJOyTupBnlABch9QLgAF1qD2lCsY6speYujRK/HOvGzSdD+Xjx44L6WoOgCzml/rLv/hLU8tZm4lFxycSkF0Ez+6mwTvbV8bS8E6Y3sPIbjsuHN+biq3k+ilkRyyiig+ilq3Rs8RA2dvLF9U5eVNNVTkVsQp4Mec6BAmJPoSrnoQHLKkV/YD2M4KxNH7nSclxajEjOXKAg84HPwkQw3eiKaFEwl+Q/i3nQ2ya0dDY8+hlqlMwgUKl4BElveAX91ZwDXv3/P7afsgdZjEW4EU1uae3/qRoDNPBDagOoprLbsmsM95GFrGAjh0cWd+08SwD6FK1Bo1AXgKdfQ+a89P006uTAx+6aYSONlNSe+Ey8qC2zaxjRxBNvOjiR4WNV1dAVtggE7Tso99BnpYO9aQKKdJK+9dhFhnDO/UbGuXXLyGEdmLPVT8nnB1wn1xAdABLPjzxqCZck1Yd+1F71+beD6j+ODgErxuRXAuK0vNfv66xryfTHroKohLag8ZUw72
 gaYC+AJw
 9JgE3E1JvqWPXEg1ECvQKcwK3VRaIsr3dihii9k74HzDM+hA6uJ3wZNepi9RDcYgRdo2rf8WIHaFhPb5Xhd+vjJb4jDPkU2BPL4lMb6klOefeUesiDHifW5xqMLoYGix9TOR3gZfynmyuR/nzRr2DEVKr7/MioX4SJICboSL7P/y2qlts9C2kDLXPRkbaQz4+TGbfUlDlRruPSJRyj2D/xMy+cdxjrSjt7SFuvFb7Ct4OD8Rgw4zTI3KHj/CqhB3DkpfQyApAjR9eGZoRZFxBjEdWRZqN6vlMGmKUUYfxcmrpNrDSEw7Qm9A+JTCsVUhZXvCdQeJVUkeEXk+w6cOWYZlGk9lSYbk0RSKqTYxpCCEJcRVvNilUBLC0EeR4q4y2mYD4jNs/G/ImzLA78XUeudlSNlhKlKIIB1ZYQgw1eNzDpyzaWUwHIvOTn3Z4mYs+W807j4CxnZjD6BddAPmsP2/KHiAWrT5XDDARPnAsPLtIChcYXUoYOLTD5TRNPtXEsfm+Eb2XwFmn/aHLDRrnSygeRzmJ4GVcm7wv6xsV/QD4j8Xe2pyJ1WecDA66f9cpXxtndTw83xefFD7Ebn0/TAlgw6iZgo8onskORTqzON7f8MmOFN9RiYXcB5mptHIszhh42Ohh2wr5bO5J5riyl4S0Nl2qDvoP+dFi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] docs: incomplete pisa.* boot parameter docs and wrong scrub_max
  unit
- [Low] docs: pisa.rst omits block I/O, page-cache folio, and user_pa
  support
--

commit cadce0626ec3fdede5eca92aaf3542cae769fd37
Author: Luigi Rizzo <lrizzo@google.com>

Documentation: Add PISA architecture documentation

This commit adds architecture and runtime control documentation for the
Pre-mapped IOVA Superpage Allocator (PISA) in
Documentation/core-api/pisa.rst and lists the pisa.* kernel parameters in
Documentation/admin-guide/kernel-parameters.txt.

> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentat=
ion/admin-guide/kernel-parameters.txt
> index 0b3c140babd94..cb978469a7df3 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5345,6 +5345,12 @@ Kernel parameters
>  	pirq=3D		[SMP,APIC] Manual mp-table setup
>  			See Documentation/arch/x86/i386/IO-APIC.rst.
> =20
> +	pisa.*=3D		[IOMMU] Pre-mapped IOVA Superpage Allocator (PISA)
> +			tuning parameters (max_bits, max_pages, slots, max_idle,
> +			idle_ms, reservoir_max, scrub_max, compact, wasted_pct,
> +			old_ms, pcp_batch, user_max_4K_pages, scrub_migrate).
> +			See Documentation/core-api/pisa.rst.

[Severity: Low]
Should this entry also include the pisa.decrypt boot parameter defined in
drivers/iommu/pisa-alloc.c, and use [ARM64,X86-64] instead of [IOMMU] (which
is not defined in the restriction tag list in kernel-parameters.txt)?

In addition, this entry defers to Documentation/core-api/pisa.rst, which
does not describe decrypt, max_idle, idle_ms, compact, wasted_pct, old_ms,
pcp_batch, or scrub_migrate, and describes scrub_max as counting idle 2MB
PISA pages even though pisa_scrub_alloc() accounts the budget in 4KB base
pages ((unsigned long)used << order) and scrubs dirty blocks from
partial_dirty and partial pages before idle pages.

> diff --git a/Documentation/core-api/pisa.rst b/Documentation/core-api/pis=
a.rst
> new file mode 100644
> index 0000000000000..6ed4bd9951f8a
> --- /dev/null
> +++ b/Documentation/core-api/pisa.rst

[ ... ]

> +  - ``/sys/devices/*/*/pisa_{coherent,rx_bufs,tx_bufs,tx_skb_heads}``
> +    per-device entries that control whether a device uses PISA for coher=
ent
> +    allocations, RX buffers, TX socket page fragments, and small TX skb =
heads

[ ... ]

> +- **User pages for MSG_ZEROCOPY** (``drivers/iommu/pisa-user.c``):
> +
> +  - ``madvise(MADV_PISA)`` migrates the present private anonymous pages
> +    of a range into blocks of per-node ``DMA_TO_DEVICE`` allocators, so =
that
> +    zerocopy sends from them use the PISA window instead of per-send IOM=
MU
> +    mappings or hypervisor pinning. ``MADV_NOPISA`` migrates them back to
> +    ordinary pages. Both are allowed through ``process_madvise()``.
> +    Freeing the pages (``munmap()``, ``MADV_DONTNEED``, exit, reclaim)
> +    returns the blocks to their allocators.
> +  - ``/sys/module/pisa/parameters/user_max_4K_pages``: Soft cap on user
> +    pages held in PISA blocks, in 4 KB pages (``max_pages`` counts PISA
> +    pages). When non-zero, eligible pages are also migrated on
> +    ``MSG_ZEROCOPY`` sends (best effort, non-blocking, skipping pages st=
ill
> +    referenced by in-flight skbs); 0 (default) disables both.

[Severity: Low]
Should these sections also document how pisa_rx_bufs, pisa_tx_bufs, and
user_max_4K_pages apply to block I/O and page-cache folios?

In drivers/iommu/pisa-user.c, user_pa[] maintains per-node allocators for
DMA_BIDIRECTIONAL, DMA_TO_DEVICE, and DMA_FROM_DEVICE.  When
user_max_4K_pages is non-zero and pisa_rx_bufs or pisa_tx_bufs is enabled on
a block device or its parents, PISA also migrates pinned order-0 user pages
for O_DIRECT bios in bio_iov_iter_get_pages(), allocates or migrates order-0
page-cache folios in __filemap_get_folio_mpol(), ractl_alloc_folio(), and
writeback_get_folio(), and skips blk-mq IOVA allocation for PISA pages in
dma_iova_try_alloc().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D24

