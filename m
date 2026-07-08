Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A19F7C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 525756B0088; Wed,  8 Jul 2026 13:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5F16B008A; Wed,  8 Jul 2026 13:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0036B008C; Wed,  8 Jul 2026 13:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 153FE6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:34:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 773578CB1E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:34:26 +0000 (UTC)
X-FDA: 84966308532.15.6D25529
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D0D3240009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:34:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XicQy6A7;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783532064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlaCm1eMaE8ditGiuMnDuLYETT0AIKL8e3b4PiOGnmA=;
	b=il4gl/1umvXpJjMjkS6Y3VatNnwD+dBtKygJGhVuvm40wLHFkOvkT8Ayk+Jtou0bmil3/w
	BL7NHx48mhDleUQrF8eS5juK9OJdbqhxCLpUNlEDT8EG+i4WQrCUXkNtuWtDsNYbnKOIPb
	xVzrueZ9UJKKGpEpAl81QSjtxtATd7A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XicQy6A7;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783532064;
	b=e83kcy8JOGA4U0+TnBf1ue3k4sTtI6D/9oNp2Yml4uuSwlWUNrNy8+Z3qOETVgNZZOQOhc
	BLG1yC5fYG+7kDcp0Tzm5Lzfquz35uXqUpxyMprMxzpD1oqzvQFIJl7axfK4PwR1nEMU2t
	vkhCMNI5lAU0/Olu4rCHRKMHA21EnsQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D65494139D;
	Wed,  8 Jul 2026 17:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A03E1F000E9;
	Wed,  8 Jul 2026 17:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783532063;
	bh=UlaCm1eMaE8ditGiuMnDuLYETT0AIKL8e3b4PiOGnmA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XicQy6A7R4AMUDvx3D2a/v3RwwR7yjOvvcXyM6rKqs71MtYBs6x72BnrlqujUNx/H
	 S1MBI0BZicZJTtSVN2U+M8NBii4KyomXpSHq9t2xJDlcF29mK0ZdhIqVPv2lDt/2Rp
	 ArUlW4cWaTpxhIgVUyf0xdA7mj1iBlUW3d/gItTVuJj5K0AAQTHjRQUbfF02Z07LNn
	 0gyab97QUfKitk/p0weyh+oNdEfBAJEWrg9swB0CMUYhRZ50JKTXMkxDgEN2gvx17R
	 /0kfVjA4VRKlYw+iH6dKRBSFmYqB/ZOHPO/5HNubcTfbF5p0vcQKOLLZBSJTroi5VC
	 xQj2/QaBexyrQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Samiullah Khawaja <skhawaja@google.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  David
 Matlack <dmatlack@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
In-Reply-To: <ak6DUC7NsIZ20RZD@google.com> (Pranjal Shrivastava's message of
	"Wed, 8 Jul 2026 17:05:20 +0000")
References: <20260703020832.1731864-1-praan@google.com>
	<2vxz7bn5mv0n.fsf@kernel.org> <ak57VeunO8qd4wEh@google.com>
	<ak6DUC7NsIZ20RZD@google.com>
Date: Wed, 08 Jul 2026 19:34:20 +0200
Message-ID: <2vxzy0fll71f.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 7e4889qctxjdw3ssn3sqyhumk3z7kgop
X-Rspamd-Queue-Id: D0D3240009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783532064-583749
X-HE-Meta: U2FsdGVkX19WI5sOfisqwpYueM1Y2CeWgRc0+EWTDDfCvZrpZMwcQg9WnOGibD+DQ+DcUCLHqS3FpmQYJ4QfhXYTh5/2tSFUy7ogrCEMOeoFubCd0o8mUbwupvBARR+MMPCZDw2oeYA0/Px2GTvI9MaSrFINXqSdLiL63cpRp4dLBEKjiT9tIs47wqTy6hk+0+6r5kJut7PXOXGbsemxR9nQcHO/jzK6T/HSiwRbodacFr4JOKQZb8BuDCglphnF+mIQwK33LykIa+7oKSUf0XG8hhziFBsbrzSMle5qbzHNOQrXFwFXvzReqVtDGgzokdrjDKOzQrrQZzU0CU/nJQ8pSwkoBGLhuBr8cpDFI8Per8GJlTbAiGWEOjPFAn6Q67+A62Pin8hKiTQQSME5qCDQOlI2t+KhJevGJvSOrrZwujRELDz3Y/fWME4m/k3dx0yJq40kRy9lz/Kxxe6ViTXaABFxpzDijoamHab5tEOam2ATCO220JNFO2z84AjPBQfVsB+XieyTZpcxE9h/N3pHRVKQPO6cdeZ1OVrptctgDKPM9sabQygJkW19SLkiZ69IrGC/fKHFep5rXbowQGrXbrfgDM5qldNTSeNGSae/Mm8WnOxCyibU/sKBFNxKVhkLFlhi4VeaLwSYKZMXoO8rMAfED1zFXa6usFZJKPmMsof7aVb2NUvzPvQNgw2iCV2JZihgHHP6c+4ZjlCHyqynwVLtG+9z1Kf4taUV4DJ3HG/6urab2yYdiBz/Yx57mhR+4ktLxQ11mvesynUKdQffTnk5QNp0MiHvxKXNDJbrjfqrh3R6zALXa2aHXOR7+d3GvbZsstP7YI0aEN/YpkBtfBsDIIiFQ5C1Z7uQWifv67Wc6KT9+E9Dq0dNR9k7ho212okWc5R7CePgbnsn74yVvxWF45qbf0REcqA1tsRmsGXvtKt/+X7+PIzMHz9iYWQeSGV9cLpDHFyXNef
 /8NHR0UE
 o/NM3zLgdNcBAtw1//UspJ12w00ezlrcHO22pNLolhIJ/OHBGyWJDxX24xoz4D0MyO3d5WWzy3s9mqfl6uD0T6yX8HRNcmA3dIYdXH8gVY1+o5xNyWUKUjBgCQYk1zl8n/Fw7Vh28+UlWBnLlGSDEcf5mChw1D6TwiFihoCVpr+zGqzR5Tlo4FXOhKhf8HFe2DOD2H7lvf4EZq4E03XqOV0Ttpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08 2026, Pranjal Shrivastava wrote:

> On Wed, Jul 08, 2026 at 04:36:46PM +0000, Samiullah Khawaja wrote:
>> On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
>> > On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
>> > 
>> 
>> [snip]
>> > > 
>> > > 3. kho_restore_page() applies the correct refcount pattern based on the
>> > >    preserved metadata.
>> > 
>> > Why do you need to save the type of pages in KHO metadata? For example,
>> > for pages or folios, we don't store any type information and leave it to
>> > the caller choose the right API. So reserve-mem and kho vmalloc need
>> > pages, they can call kho_{preserve,restore}_pages(), and memfd needs
>> > folios so it can call kho_{preserve,restore}_folio(). The radix tree
>> > itself does not hold the information. The caller knows what its memory
>> > is supposed to be so it calls the right restore API.
>> > 
>> > So why can't we add a kho_{preserve,restore}_page_multi() (pick a better
>> > name; we can argue about the naming later)? Then your driver knows it is
>> > restoring DMA buffers so it can call kho_restore_page_multi(), and KHO
>> > takes care of initializing the pages with the right refcounts.
>> > 
>> > You won't have to muck about with the ABI in that case.
>> 
>> +1
>> 
>> I think this makes sense. The mm already relies on the allocator to
>> track the type of pages it has and expectes it to use free_pages or
>> put_page() or free_page(), so it is natural for KHO to rely on the
>> caller to call the right restore API.
>> 
>> Lets add kho_preserve/restore_page_contig|_order|_nonsplit and the dma
>> preservation can use the appropriate one during restore.
>
> Ack. I like kho_restore_contig, I don't think we'll need a preserve for

Dunno, everything is contiguous, folio, 0-order pages, higher order
pages. So not exactly the best name.

Since you'd get these pages via alloc_pages, perhaps
kho_preserve_pages() works better for this kind of allocation, and for
the _current_ kho_preserve_pages(), we can rename it to
kho_preserve_split_pages()? It is a bit too wordy though, so that's a
downside.

Mike, you are better than me at naming things, so do you perhaps have
any better ideas? :-)

> this though? Preserve doesn't seem to be preserving refcounts, I guess
> we could rely on kho_preserve_pages and the caller can use
> kho_restore_pages_contig() to set refcount correctly for unsplit pages?

No, kho_preserve_pages() can split the preservations in unexpected ways.
While for a high order pages the current algorithm _shouldn't_ do it, it
is simpler to just add a new preservation function.

Move things out into helpers if you want to avoid duplication, though at
first glance I don't think there should be much.

-- 
Regards,
Pratyush Yadav

