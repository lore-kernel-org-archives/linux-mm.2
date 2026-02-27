Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657DA1039895
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 21:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497C06B008A; Fri, 27 Feb 2026 16:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444F16B0092; Fri, 27 Feb 2026 16:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343F66B0095; Fri, 27 Feb 2026 16:09:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 218A86B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:09:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C49F71B836F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:09:07 +0000 (UTC)
X-FDA: 84491476734.15.AAC05A5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0EAB51C0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:09:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=R4nGnP1c;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772226546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FuBhsUwwCOInnqB7O2GDaXeBFXb9h+2Obvf7L/ta9E=;
	b=nSpYf5UumOy2s9RDjzgIQFWbOYImM/Q6blrTLgHgOw2tWPMs52bp5/4s69Nw+Jgi5KyV0V
	XPvesWK2e3CALIsA9VwrKnHsxxtHQQ1kFPQNui9Ay9XLZWg4bbbRPK3kBle1twttiELDY5
	beYkYiFJKRZKRLTIC5hK0AyFzCF5FE0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=R4nGnP1c;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772226546; a=rsa-sha256;
	cv=none;
	b=t+t10FKd9doifMyZld8qoMj7gf1oKZOSzFamP0vYtKLHP4QoTprIKA3sSudnwvYQhdMq3y
	xtPlLhYh4eQrroygZP1Z2a7yyRhHAO76jzSgznujtCVLYpF9l6j23nI2LW5bzrb0JGeNyn
	kIoxfaMxb6wKFCbHth1Ux2rB7gqJbNg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=4FuBhsUwwCOInnqB7O2GDaXeBFXb9h+2Obvf7L/ta9E=; b=R4nGnP1cbd2DInksjBWnv/d0gZ
	ddMiXwJQ6PFlTGSrO4IoZMGFmmQIXDaYGedozjGH+yn4XfqDSkk3Jv/s5ir9UPpsNZ41AQfWI07Sm
	BPaRF8DKchzsIFPxz1dfIz6y5nluh+GHF0qVxD6DBS/bsTV/EPpJ+n7dV/La/vzpCqXyKlIwaRlEQ
	DU1I3pxQAzNCEcAysnohMM6ujLMLvuXbsH21wqKxEAczIZ2Y9XrLBT7p0moUXfnhGzWbZeg3VkqhL
	pYwcZes5wDl9MlmKLnO7r1XeNP9XgUXeHaHblD3R/rFKyxxsvcRd+3/Z7uFLH1uQnyTv7h+3nlUSZ
	LOywukdw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vw54u-00000009A1r-3Ob7;
	Fri, 27 Feb 2026 21:08:52 +0000
Message-ID: <7d4ece82-2d92-4e97-851b-822816cfd800@infradead.org>
Date: Fri, 27 Feb 2026 13:08:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 17/18] hugetlb: Update vmemmap_dedup.rst
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-18-kas@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260227194302.274384-18-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0EAB51C0005
X-Stat-Signature: h34jt5a4q1df33pios855c9a78rgm5bt
X-Rspam-User: 
X-HE-Tag: 1772226544-464577
X-HE-Meta: U2FsdGVkX1/4W6bFX3PLjPrWvgVtVTqFiVpOKi0+b9Y0/5wEtXNOTOv/peMze8+1TMZfP8CVk6SygX3t5JMrxe85U6Dpgeh2yAyiC3FkHQR/6svqNMMbEZPSLuQagCc51TM2+OERrEWYKZdI4xwiNvO3ziZj/WQz85LmqRzU4kJ2vyuoXrCz4N0r5t6urzdT4142IUvVRMufUZTb2kGoelAa12jMCaFyYzEBgkZwtHfnQCXXkZ/m+U3JJId9IB3HJos4k0Z+WW+W9TYwrXdjm9SOVg6mg+qpRMSPYlqjYqQaepe9+qpdClDxA6HXs//eqajXqBPOHAdiJdIgenK7FEHRpS0u1Fig5LgjH+oE2NgTr3B5xWMH2PP7q1BIvIAlylEt2jkALPgllL4hlgP/KqhjvH626/u2no5agFfUj+4yODynKxMAXNEW+z99IUvXcLdNqqCERIFwrOYfdYVmtwZGDfd4Gc5bAzE4/0FrUncZxeHOwiOvzF1NmMIl5dkIyKXMAGezhZTt1f450vO2iJLrpd86mR0VM4oae26OSLCTAS/h5rhu4v5JCf3l2rnPJwyRjNv3tIwtrZ0CTvebT0PYpJ5si5gZBIovxI1z34mG4wUqzEVDq/5+4hrmaFLtPGWv7eFC5wADDFoNIFtXEvHQusWEetFgckfLxofkpS0T9TpthYbevRsmqRcAVoEAOLNRQ8PgRNWrMSPZ4yekJDgZizMFkaVgGxF86n06SSuO7hx9gfrOS7iXG0GwECStbhTtdobdpW6DxP31B4MN6jWP1n38Vb5JyPVpGCBlu9fy+UJ77ta1IgYtnl7xtoMVe3QwtFspVBCyMcYv/FjA2ddHlcHyVI8nKdpKK3PvWK//q9GXn7uN6dJN/AwOF7ORaCN6zOpHJP2iZic/1mEc9hDBbTW+2loFnpLfME7R/7Fg3xLZx+yAkpw1bSDRWZbcQ3+tq3NgYNdX3WozI2F
 O6eIJacz
 I7S07yF4oiJrGAOaN+xj+QUfq8QUWMDuo5kyMUxwUXfmczBsLH39EnyYjOoNlKHjGwME8xuUdXDv8WG992hIA34mQgaEkeKqAtSkBoE2CNDNxfLfbzgSFUI9HMw6/qcFQy6JKIBRlKvQD09XW8d/WNa2IFSWTnyw3H6vG/tqUSe3rgx3pW0+nyZADhXcmiPnvzHiDuPDqd1mo5lQgDDKE+XciKMrXoLnKnCYa97MjvpPydhN+sPzWoTla+TIjSicHRy1BNANN2wGvu7PSNKVFxEdnH3Y0y6xVWTuJzUQT1cvhj1I1iBgUop5N1t5Yk4EJtFtvmjZCgXwTr61cOZ0mjd53PyVYR4rRd0Dd314ZOqYiq6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/27/26 11:42 AM, Kiryl Shutsemau (Meta) wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Update the documentation regarding vmemmap optimization for hugetlb to
> reflect the changes in how the kernel maps the tail pages.
> 
> Fake heads no longer exist. Remove their description.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
>  1 file changed, 26 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
> index 1863d88d2dcb..4aaef36d8971 100644
> --- a/Documentation/mm/vmemmap_dedup.rst
> +++ b/Documentation/mm/vmemmap_dedup.rst
> @@ -124,33 +124,35 @@ Here is how things look before optimization::
>   |           |
>   +-----------+
>  
> -The value of page->compound_info is the same for all tail pages. The first
> -page of ``struct page`` (page 0) associated with the HugeTLB page contains the 4
> -``struct page`` necessary to describe the HugeTLB. The only use of the remaining
> -pages of ``struct page`` (page 1 to page 7) is to point to page->compound_info.
> -Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of ``struct page``
> -will be used for each HugeTLB page. This will allow us to free the remaining
> -7 pages to the buddy allocator.
> +The first page of ``struct page`` (page 0) associated with the HugeTLB page
> +contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
> +pages of ``struct page`` (page 1 to page 7) are tail pages.
> +
> +The optimization is only applied when the size of the struct page is a power-of-2

                  end that ^^ sentence with a period                      power of 2.

> +In this case, all tail pages of the same order are identical. See
> +compound_head(). This allows us to remap the tail pages of the vmemmap to a
> +shared, read-only page. The head page is also remapped to a new page. This
> +allows the original vmemmap pages to be freed.


-- 
~Randy


