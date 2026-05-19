Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B612CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 02:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8B26B008C; Mon, 18 May 2026 22:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52AB6B0092; Mon, 18 May 2026 22:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A4F6B0093; Mon, 18 May 2026 22:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89C0A6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:56:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFD3E1603C3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:56:43 +0000 (UTC)
X-FDA: 84782656686.13.5D2077D
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3D8B81C0008
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:56:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nchkEYj8;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779159402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZEPDE0JhFiHBzsJZnEnOmNR0XlNNMR93C5REwadzXo=;
	b=z0zhClTFqleBVB4t+ReZ6rnVBx5Z6TLPRjqDkT0PjSZXayc8tMD426TDIUl/dqyZF5pShK
	/U9QJoO66EgsUyAPmL2vCS6ai6YUYpnHPpgs4W7U2JFE0OeD1IXBbMS21nSEDpyonWIypz
	IwgyjaqQdfpOZBhhyQIZUNO5bM55ScE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nchkEYj8;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779159402; a=rsa-sha256;
	cv=none;
	b=3KIjbVz9QJC7IfMEXUoQl8SWh6X4F1y/lswHbF/gmntG6EhVpSqBiZXtXxVk4CZVKT/Z25
	fxn1jLmiRAPqC4xRr5hUUyTRVJXNULFwA7acQ+5KNgmjOieQe2qUGqhLXxK6Q2ygSCnI7Y
	WYqKLA7pIoA0KT5JdEARrJ5IIrpMZBY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779159399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZEPDE0JhFiHBzsJZnEnOmNR0XlNNMR93C5REwadzXo=;
	b=nchkEYj83AaVfsUXxCl0AvZUaid1ISLjmEkYTd42iifdpzigk+RxNSzNQL1fmc2Ovg+CLs
	YCNmlMQHYag98UVdCm749EKUrnTkj4xmfprGZEpQ0YK2u4pxGj2UrZMgCdcEuVc9k/mZak
	7n1ZXHcwCLSVdvfIS5AVfaO+KMbAozc=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 3/8] mm/bootmem_info: stop using PG_private
Date: Tue, 19 May 2026 10:56:31 +0800
Message-Id: <20260519025631.71942-1-lance.yang@linux.dev>
In-Reply-To: <20260511-bootmem_info_prep-v1-3-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-3-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 83nf98p1yqsybka8ogupd7eauaaz91h1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D8B81C0008
X-Rspam-User: 
X-HE-Tag: 1779159402-847264
X-HE-Meta: U2FsdGVkX1/NPCO/cIYwgH7NruO7NgjwyvNZR8/p01DmOslUIUtkIuczkqAMn+1eyanb+zm6tTuU7/aYGpZk/yk5ejFXcmYUkDj+fhVUA9+LUtH+8NaCDZlvEo9s9mVDa16uQ8Q/BK4/wnFZIBU6Kl0eVQJfuIHSDxe0YNDHRKwCbiBzj4dHTokbIkWXN+9tfSHd7r++ITtp7w9yTc1kLJ7YkJ5TpWUxEzgrPVY9aGl+UUKqOwo4dxntQtHyiKJHyeZTUgKcfTqpApRLH9T28dfi5+ZwtZGiCR0zX8vayomWH+NsP+QDYz2nlFjlhzIV+24S0rGGpc/vEjJSnFLM7qZzAQBBx5AAWbn6esC+OrzztCGTiZ3eJNwz9CllIQMSDcI0Js1OH3gpPJb9ZwDcHdRS2+MDUnHJ1z84eQtk39B9eelvpMasFiyqQY+DC5zNdNqIH002NIBDjFoQuyl9zaleL2/+ycYAGoaczTclwuDegPygYBU//FJ1nfPJsFt4PHPaVuECb9rv6MAo8bpDmTx1q76QtfNBQ7oQ7cMxQYSWLN02iW3ftii4ozV0tbTfvIt741YaWBvLTFhOQGMwpSCGlYzl/LvKG8bDTGsFRm+mQ2YuKYJEFf5DQXU1+tlgB/69Hjwf3H3Vx4JLmSlhY1UmwTDmEftbh/u2F01K1lak2WzUt5o6hAIliaKuUxm2XWOmW02FVmjyOTQkaZa0RHnGWY5TRD8/DGVYPganQ0h+9T33YgTWk6myaNTJaTvbaf9wqN/E42gXkYEhp9h3XbIRThXSsld1rJWLeBcGft2PrLJNzIdm8NJm4/lSSiK5uAA5OCbn6M3+zMF1O2SMSC3FjAbL9D7hAD12AT56rb07gROo1hedA6K/2fX9wgLb3G6GrVXhIHccaYD2ETEx4bvP60MhfV4BM++Zti/Z/Hr5/zX9+0LpkrF8ZT1LIqYolonrMvUYQDpKd0h/Sfi
 jiS56ZQB
 vL1m16eeJoSPK9mqOPnOcVNX5jc7G8AyKcAM/Rz5T21tSPyyXopzuX5oGgp5nEvBSSYTBv1TlMD1xbn1LjoHPbGeE2JgEMmk0vZIDuvpUSea4FC7Gph5ZRv8HaAoanGaSev0KdSnkNyxrOdpgMZuELp8VxIUlM3laOVLmsFCn8/RGpNKfRT3yZy6L9X/f33UHLiJK89dZEfsuwcRpX7bBEStxt/5cMR+kOX2HHx6cVAuvjGPohe2Ps3oQSAwf7TNScQJey5yZ7YBzJrCegWy4ghgPnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 11, 2026 at 04:05:31PM +0200, David Hildenbrand (Arm) wrote:
>Nobody checks PG_private for these pages, and we can happily use
>set_page_private() without setting PG_private. So let's just stop
>setting/clearing PG_private.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/bootmem_info.c | 2 --
> 1 file changed, 2 deletions(-)
>
>diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
>index a0a1ecdec8d0..6e2aaab3dca9 100644
>--- a/mm/bootmem_info.c
>+++ b/mm/bootmem_info.c
>@@ -19,7 +19,6 @@ void get_page_bootmem(unsigned long info, struct page *page,
> {
> 	BUG_ON(type > 0xf);
> 	BUG_ON(info > (ULONG_MAX >> 4));
>-	SetPagePrivate(page);

Right, the users classify these pages via PageReserved()/bootmem_type(),
not PagePrivate().

So makes sense to not set PG_private in the first place.

> 	set_page_private(page, info << 4 | type);
> 	page_ref_inc(page);
> }
>@@ -32,7 +31,6 @@ void put_page_bootmem(struct page *page)
> 	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
> 
> 	if (page_ref_dec_return(page) == 1) {
>-		ClearPagePrivate(page);

Nothing sets it anymore, so there is nothing to clear here.

LGTM, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

> 		set_page_private(page, 0);
> 		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
> 		free_reserved_page(page);
>
>-- 
>2.43.0
>
>

