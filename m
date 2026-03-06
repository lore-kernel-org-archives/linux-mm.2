Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF1BF0183A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7896E6B008C; Fri,  6 Mar 2026 09:13:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733E86B0092; Fri,  6 Mar 2026 09:13:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C116B0093; Fri,  6 Mar 2026 09:13:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 514976B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:13:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85BFC1C7D9
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:13:39 +0000 (UTC)
X-FDA: 84515831358.27.D1B69FE
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67ABAC0007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:13:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f xZZ+mR";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=X0+9sAXX;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772806417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzYG0S3OLle72IwqTl9xNJv1EjXZoWsv+cwzJ5nwMNA=;
	b=D4bqrqf052IW74NEz29xPH3kBtq0Dplj3inx7B1pexD/yrtZwXhC/RhOpNyEKSaMmANlqH
	ZMWfXp/91kS782iXCMH7V2abAeCuz4g2UdZEWSmedmnRL1IjicqLcvkbqXU3kRU6eKnQ0u
	mV9or8weT5NzV4VdlnYakdDSg6Nj4LE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772806417; a=rsa-sha256;
	cv=none;
	b=dv+/Jfs2uLXuwjw7lkj3LZuA3Avw9N+y6ZCUo9ZKSTl5Jqx4UXxgxEMSxpIlmXYAhL3Dpi
	4owTf4aqq1YXudf5dTNQYCJ2Zsf2RycFus3P9t4NdH2JdmAoMumVJm0yUJsc2+oEadD0UP
	qx0gTZIASuLZofx63HNoYmoM3bqj+jA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f xZZ+mR";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=X0+9sAXX;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 21F821D000E1;
	Fri,  6 Mar 2026 09:13:36 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 06 Mar 2026 09:13:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1772806415; x=
	1772892815; bh=lzYG0S3OLle72IwqTl9xNJv1EjXZoWsv+cwzJ5nwMNA=; b=f
	xZZ+mR7+LcRMOzk3UUz4+WotycEzT2UaGotDtZ+4efi4P0Ch0jKMCZZiKTXHQ1ty
	ZJQ3yYTbCdKYXKPFZlglxSGgpFTt4BkqSvqBqj1GF0Q5LVyJ251Xb9C4aHQdfAkd
	X45YrBxPHWlEtWIpxwCCeIL0TwUbs0IfrsaoDrUXhmkbHwPFgsm9bQoeUpOvJ8lR
	mbwLct1CRvzt9KHsBGx0XeGA/v0pQhTVQHIezeVNip3BnCl3lguREW0cizMCtpFH
	jWDyZNa8aJQ2xxfO+gh2+I3mZ7BiM1VO6hNLYzzCR6sWex5YFPALHA+PLvVTfsqQ
	lrzgVyBuI4wFerLWYkTcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1772806415; x=1772892815; bh=lzYG0S3OLle72IwqTl9xNJv1EjXZoWsv+cw
	zJ5nwMNA=; b=X0+9sAXXNjHfZDB+rgGnt7J2/aV+YF9oV0ESEZx5jmuFOUjElzr
	3yBaQQh4kLaeYUu4d5O+i5Eoy6TUBpVmBC82y08x/uwK0y//pMQmlY9MuO1Hnctz
	pxhOInFFjdHZczYmOi16eLjj21KqJrdTGDa8lrCOSA8hczwqv/xZNbCCFyG6eion
	JJaKs4Jsy8jMWFcNCuwF/hn91/TD3jOEUEvHtpjpUltpKTE31oMfzdl0PBOm4mgF
	kS62N5T5CdSLa4U1zN7XhvubX4X8iYPY/KZjYlGBPPduaIOQ/Jg0ZlnIX82YE9Pv
	sID+8ZEembboc7yKsDluwIy5bpLSgTcXtdQ==
X-ME-Sender: <xms:D-GqaWHfztgWLh-jRq4w5-PUcHUngB3g5d3RbTrS9467kUUsXVhOyg>
    <xme:D-GqaV2AuBcFezrBP5GCt3p92K07y0rPm5J-jH1ay6RcVJAz4ds-fH2_sUdVX3fYl
    ArET3csXHzd5zZ6sTljYiEm_TaoV0dWIBRVh1sbOiOXKkrdICGjJ8E>
X-ME-Received: <xmr:D-GqaW9Rmk4_BYqCMxip8pVnCryJvBZn5EuMaOwUluqx9tQNlsA-N7rIt8bdpw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieelhedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopegtrghrghgvshestghlohhuughflhgrrhgvrdgtohhm
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopeifihhllhhirghmrdhkuhgthhgrrhhskhhisehorhgrtghlvgdrtghomhdp
    rhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epkhgvrhhnvghlqdhtvggrmhestghlohhuughflhgrrhgvrdgtohhm
X-ME-Proxy: <xmx:D-GqaQGymEIUStWCZAtCeFts3hFHvuiN3ine-c1kLrMebgFqzCOaJQ>
    <xmx:D-GqaUju21E8t6wABq5p4HMdThzOFpsQshKW4Ia74-TTiBt-PXm_3w>
    <xmx:D-Gqad-iUcnozrL2qmz__kO5ombPYH9WtfEK_oeY2SSfx4QSmutJag>
    <xmx:D-Gqaca4V3aHYvlkp6NSWwlt3J0OaMs2h4bZnPuL9Xwb91NN22l_3Q>
    <xmx:D-GqaZlo3CyXRuhG-JwoQ4OR0qw8ozbFlbzQgATj41gGl74dV9pqL0z9>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Mar 2026 09:13:33 -0500 (EST)
Date: Fri, 6 Mar 2026 14:13:26 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris J Arges <carges@cloudflare.com>, akpm@linux-foundation.org, 
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aarVMrFptdXhHsX1@thinkstation>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aanYdvdJVG6f5WL2@casper.infradead.org>
X-Stat-Signature: s9qtudy4gmwaduoh61e5ctt7iq5qjnbk
X-Rspam-User: 
X-Rspamd-Queue-Id: 67ABAC0007
X-Rspamd-Server: rspam12
X-HE-Tag: 1772806417-498223
X-HE-Meta: U2FsdGVkX1/hck9gLxzjI2dZ7SP+OnCbOXOeZB4qcexzdns5SurTcSikS725+gyEPGQDB4MXgOVyc+Fip1/VICipoVanvmkyOSd7agAD6RYmLc+YwcvkjO3b3iMUICpTRH1TK90QTV4fBDhQqaH5mrLabMNjybLBjZu61J0UBSgklshQnEEl8WJ2Ejds4unp3Q0ZnTbd7zMQ/8jGjC12PtI7YDsFTXht/b4+QFbaEMnqc/C+0IlE2mjLNA8wmBDVhVQZynboDcU1NTaKjcbGklw0qzY0JhYvLoLIp65Sw9w5yK+pgQwMP4yvZDFFDGkLOEYYyL8O0sb+9qI/k1ct7RCK52lNKflVPAo84cRmwg9VTEqVHYyEYbxegvcF+Kt+cK749XYzQpGsuR7Hq10vGeyCssWudj5h7keiULvsQpCXY098VESa9/6vZ+b1gnYLrYbCeB8z4wpjph+r2Sr85WrxIsMg2Ut82kpQHeR7UuJzFWk6PLVxAZ97xzKaJR6y+nicAyh0biAe0PrQGvDwfGMCkqIj6vxSgv2iNoA2IdVNxYtB9tPnlHDU+QgLjgCyvU86W3heSrEPVWsuPQrBfd6jrRe1dcO6cfNWWx+3yvq8hZOE07ahW++U9jB4uthRq5ZUNmPQssiFwwoeh84pfKrOww2qLHiDo7ZDTMAGB+G2+gbRHeuy25yaGxzfTNuOAIyuJwXUZ1trbxiOIrjH19pMi5oFm1lbaqGGE72z1RIFkhAp55xNlFCTdMrNolVWrQywYNUcCJY9J2ntfVfwYIgZ/cbGmGk36AvUxxFeh81dD+WQz16my+npW1Z3ZTPBj1ANw/IlcPuFJgmAdk4Sm5WvTDcWzUaqCTpENJZxcgDQzydvHeAi7jl73EdSUJZFpA9jXuVzMccW4GT5/wlF+VJbuhQUAF2X+F+pXG7Gm0Bt8HWAH+26cEriV2eYXv8BKsUk/EQRidEbXFGOF4z
 7B0vYNyY
 xa/KEg6qfzokvfjm8tVUhadKyofsiKZshoXbqrTXZhQX+Hg2m0uij1wPbapA3EBLdRTzDN8eIptI2npLKcR5eE4NAeSfi14hs8h3e0broBkUmM7aNUEIRoH1AbCF6LrP88njyFArJZmJI+8eH+xUpcR6xtgkWYjCOdbf7EYYV0bfkLTgfkGWzMU8qRgapZeUjDhKCnYOmlQEbOsMOVkBeRnsZ+68vL+Bivq62lKQhgz8+lpvpomJFOtQmA8kBiA3HpY1oOaccgx7tjfrdgOgz50XDcEDEFiyL9p8rWkcnEr1NboU41+dnT4CdpFxSNTalDSUmuQrALdSJNNdFGeRqI93EJOXP1Lv5NsZF5IBwgq/gr6yNxhekkQuHl0i7SOCQiy1EyGmM15VB0ZNJrGTBNQ+wNvytWj1wpdqxc9rqh8VDyNZ3+xhI9pNTTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 07:24:38PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 05, 2026 at 12:34:33PM -0600, Chris J Arges wrote:
> > We have been hitting VM_BUG_ON_FOLIO(!folio_contains(folio, index)) in
> > production environments. These machines are using XFS with large folio
> > support enabled and are under high memory pressure.
> > 
> > >From reading the code it seems plausible that folio splits due to memory
> > reclaim are racing with filemap_fault() serving mmap page faults.
> > 
> > The existing code checks for truncation (folio->mapping != mapping) and
> > retries, but there does not appear to be equivalent handling for the
> > split case. The result is:
> > 
> >   kernel BUG at mm/filemap.c:3519!
> >   VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio)
> 
> This didn't occur to me as a possibility because filemap_get_entry()
> is _supposed_ to take care of it.  But if this patch fixes it, then
> we need to understand why it works.
> 
> folio_split() needs to be sure that it's the only one holding a reference
> to the folio.  To that end, it calculates the expected refcount of the
> folio, and freezes it (sets the refcount to 0 if the refcount is the
> expected value).  Once filemap_get_entry() has incremented the refcount,
> freezing will fail.
> 
> But of course, we can race.  filemap_get_entry() can load a folio first,
> the entire folio_split can happen, then it calls folio_try_get() and
> succeeds, but it no longer covers the index we were looking for.  That's
> what the xas_reload() is trying to prevent -- if the index is for a
> folio which has changed, then the xas_reload() should come back with a
> different folio and we goto repeat.
> 
> So how did we get through this with a reference to the wrong folio?

What would xas_reload() return if we raced with split and index pointed
to a tail page before the split?

Wouldn't it return the folio that was a head and check will pass?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

