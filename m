Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0749CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 09:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1886B00AD; Mon,  8 Jun 2026 05:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78BE6B00AF; Mon,  8 Jun 2026 05:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6316B00B0; Mon,  8 Jun 2026 05:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDB516B00AD
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 05:44:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F8EEC32B0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:44:13 +0000 (UTC)
X-FDA: 84856259586.25.D8EA30F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E00621C000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:44:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMvyeZW5;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780911851;
	b=Co3Jr0TQ8B5mpirh33Y+XEXNBlH2m1zff6VF8XRs2QgUcupF3Z+Sv7N9r5R6pkDL5NLTWt
	DvxJ866btLXoxOD7yODABH4ta8V36dqWez/gw0rsOSU9i29+vJgJL87A1mSseU5nesOWB4
	5a6D+YAmlmBIU/uMMhfnIWCNcqj+49o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMvyeZW5;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780911851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17m8mwsfA3GCBclFS0NKJ16jnmOTO1fnZAeW+abmcCY=;
	b=0SJcDud8y2ARDEkqw2/Gr7BW/pqBCGq85fCTihchqnT1xl9NGgGIQCnBUeqoAAr15FRVJz
	1m8Fre2XVMqVd+5GRnsFwSyziSaXLr3RQFH21hy6Kc6c3QLSDXkZ/skWa/kztUYtPB3zkY
	I5WWSnXwQ90LqJ70HiheFiXLph7eims=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52FC2601D8;
	Mon,  8 Jun 2026 09:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535101F00893;
	Mon,  8 Jun 2026 09:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780911851;
	bh=17m8mwsfA3GCBclFS0NKJ16jnmOTO1fnZAeW+abmcCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AMvyeZW5thkSCuPZGUdZYSNC2hm5d3bonc7xsD0+/P9v89ByLDRGzdevN0P96qemF
	 kyMJVco52PvR1bRNqX+K9x6Ue3uLGss+4arXKeJHILVAe+oOy9JlGNRuM1P4/iyb6V
	 /fv5pm1zatWy/yY/Rxkt8lElYDg/AfnH23/XgvexjWWOns52opKebab4yacK5qudy8
	 JUnir+CNDx5FbkciMHezSim9iwtJDb/S5XZGMXHMe5+hXzcSBAI8wdUJ8zbZGa9uV3
	 uh0siT5xbopvDcEFFeSNTAQ5fceK54Szx5OJQSqfdckrVt5Cf3aSA7Z/eZ9Ybv0lYs
	 vQjDiJZr6npbA==
Date: Mon, 8 Jun 2026 10:43:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 01/37] mm: mempolicy: fix interleave index calculation
Message-ID: <aiaI4Of97oH5YTbi@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <f5b1dcc97baae7183e96743873b943315d93cdb6.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b1dcc97baae7183e96743873b943315d93cdb6.1780906288.git.mst@redhat.com>
X-Rspamd-Queue-Id: E00621C000C
X-Stat-Signature: 35gzuctsah1wuwyq4ix59r9wrix69os3
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780911851-111292
X-HE-Meta: U2FsdGVkX194f/za4bX5z51Y0AXmixumqrrJUDJwP9O0+CRICSfXptSJ+JpsESQe4XbBSTi+QTa1AKsp5DcsW/lMtNYvENjo5d/2kOf7tme6Y4tAOnLuw9HGAfaXbt9+5Xep6XnLN3zValjCQWIoERAoK1bNLrSZmmoII8fgYqqI6CzOhmmqrQvtS2ARz2556632G3kr9OzsbTk0iFTRGJ8GPSEfpwFbYbR82YJBpHJz3AM9CbN9Mq09yyJFlaQCzzIny0lQAqkjS47y0+DGKuN5Ks3EmPJ1k9zXvXenpQ2sUikVFMXqGnQ28GA/qYptxrSQQ/QYeBECDyW7uYRar0QRJ5n/t0tTvtYAE9wuozDvmVOXpYHOjF1KJDrMUULV01u1biWu2GDxZy0IeFaRatLgDbcU5k/RJNXdh1adxc1vuMn5C8sOWLNZniim2tIDMG+jPv9j1SBGpv8AXFGqNWFQR/IIWtQ4Izz5fjimrw4LF48/A2yfLuLUgFnON/rKqn14hmYlKdumH0g3FTw+DH+tXtHv+io1DCT6Hdx1bjkQkQg32imvXnpH5Cxe4SaHA07AMY0+2OCJD/TVlSIU3yQmpC+zHSBUB6dMiOIxAMQi4qC5zWMgwc5RPqqS2p7goEbJ+SO7NPoYyoLiuDfiU2zLKoDcqoF6Mt+IcjG8BPm8/DRhgGOAkZaPIW2nqBGeKyqwkk4ntG0oB/FW5i2A4tb23mNeJGWjbl5V27TfuSigCsVTiY+WQF4tXOwuso5j+dnZqiOnvcsqS0A7wMIBSwSJAxYGfM8dZczvRSqL9YDe1jNuseBAxnCZJ3bAt9w2x1Kmyal+178NZK73kj5g0N64sY2jfxZlDGIvynFhVNQdcUltKKXe56qR1vvuWG34JEzhHDnod1oY02KnzkjniiZs/ETxZDJk2nUzGoG499YKx1Jyi8kGFahPAwCBtszJ3ReHHDg3sxEzLNjdUeZ
 3AiWvU+N
 Vw1zRXZuAmn0+hUzAh1BKWPhN1sMSk3/N/2+tNURbpK0WeOPYdwpZzhGusWafy0FNqOaru4hbvvXx1EtuM1W1YDojUA7QLKxu5k0q3jM2bLt2ELhv9SY7EeQPLPIXpqit/kP05Y528JbobrwTGXFjN/2GPPY7D7Tit5zcronUuPyrJR9EiGGm9CrZKCc2JZ7tRl/zil0uKVIhPEgl+5hypiJdnM8ZNUSN/Vwf5Fk2bOxef8oS17nDcCQHt+pIbQBWGF3LaIYGF/LQTilcVc9RWGz4FNr8kAf8en2LHmakZtE6RpqbB2nyQ3wCa4Rxf710Hl+SieazMjAnzyN2PcxlfbtU5+sSVxYriRAKDVmLTNSmzgzbikUtNDy/Bs6Qh3FIq93cMXOfh2m719sqVHFcW6SpJVRtTtiVRx8X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:34:06AM -0400, Michael S. Tsirkin wrote:
> The NUMA interleave index was computed as two separate terms:
>
>     *ilx += vma->vm_pgoff >> order;
>     *ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
>
> This has two problems:
>
> 1. When vm_start is not aligned to the folio size, the
>    subtraction before the shift lets low bits affect the
>    result via borrows.

This feels really vague. Do you have examples of where the calculation has
been impacted like this?

How is this a problem that affects things in practice?

>
> 2. For file-backed VMAs, shifting vm_pgoff and the VMA
>    offset independently loses carries between them, giving
>    wrong chunk indices when vm_pgoff is not aligned to order.

Similar comments to the above. An example would be helpful here.

>
> Combine into a single expression that adds vm_pgoff and

Combining this kind of thing into a single expression is the complete
opposite of what we want to do when refactoring code. No thanks.

> the page-granularity VMA offset first, then shifts once:
>
>     *ilx += (vma->vm_pgoff +
>             (addr >> PAGE_SHIFT) -
>             (vma->vm_start >> PAGE_SHIFT)) >> order;
>
> For anonymous VMAs, vm_pgoff equals vm_start >> PAGE_SHIFT,

This is completely incorrect.

For anonymous VMAs:

vm_pgoff = vm_start_at_first_fault >> PAGE_SHIFT.

So if you remap a _faulted_ VMA, the vm_start changes, vm_pgoff does
not. The two terms can be COMPLETELY independent.

> so the vm_pgoff and vm_start terms cancel and the result

No, they do not.

> reduces to addr >> (PAGE_SHIFT + order), same as before.

No, it doesn't.

>
> For file-backed VMAs, the sum vm_pgoff + (addr >> PAGE_SHIFT)
> - (vm_start >> PAGE_SHIFT) gives the file page offset of addr.

That's the page offset in a VMA for both anon and file-backed?

(addr - vm_start) >> PAGE_SHIFT is the page offset into a VMA (canonically
determined by linear_page_index())

> Shifting by order gives the correct file chunk index.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

You're claiming we have an incorrect calculation here, but are not
providing a Fixes patch or Cc: stable or sending this separately as a fix?

> Assisted-by: Claude:claude-opus-4-6
> Reviewed-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4e4421b22b59..d139b074a599 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2048,8 +2048,9 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
>  		pol = get_task_policy(current);
>  	if (pol->mode == MPOL_INTERLEAVE ||
>  	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
> -		*ilx += vma->vm_pgoff >> order;
> -		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
> +		*ilx += (vma->vm_pgoff +
> +			(addr >> PAGE_SHIFT) -
> +			(vma->vm_start >> PAGE_SHIFT)) >> order;

This is horrible code. Not only are you doing everything in a single
expression for some reason, you're also making the parens confusing and not
explaining what you're doing here at all.

The code before was at least tractable, this is objectively making it
worse.

And anyway, the canonical way to find the page offset into a VMA is
linear_page_index():

static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
					const unsigned long address)
{
	pgoff_t pgoff;
	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
	pgoff += vma->vm_pgoff;
	return pgoff;
}

So isn't a far better solution therefore:

	const pgoff_t index = linear_page_index(vma, addr);

	*ilx += index >> order;

Which has the benefit of being readable, uses the canonical method for
determining page offset in the VMA + eliminates the open-coded stuff?

>  	}
>  	return pol;
>  }
> --
> MST
>

Thanks, Lorenzo

