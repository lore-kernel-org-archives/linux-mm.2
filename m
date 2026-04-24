Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C80EFFED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4186B008A; Fri, 24 Apr 2026 09:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395846B008C; Fri, 24 Apr 2026 09:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2596B0092; Fri, 24 Apr 2026 09:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE2E6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:38:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB09C160108
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:38:20 +0000 (UTC)
X-FDA: 84693553560.14.D8DB57E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21F29C000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:38:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Np6A/4u3";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777037899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2OzCfdIMABXE1zgNJpkyV3hp5dSktVJkp59EbUunLxo=;
	b=0x7qLD3nrwBlu9AilK13hEP/f8Yzo1IziCyA5qGCtTn7vdlx9yqVpxZ5uTqA3guywQxTTs
	kWayy557VLC7K8UGlqCjUTJvQozGAbWTOZURRg4HOc2x7w6HE5NGEsFix08TC48UTXADU/
	/gQ8iUV/gmv7E1Qm6cuDfyNl4WwrQR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777037899; a=rsa-sha256;
	cv=none;
	b=GoczZp7vxGwYOOi6gV0WUreWPWgupiQXwG9FSx9ra9e9mooxtHhv8dsQCvoAEp2+t6Vf1T
	XxQSeuq4/pU96awRi9Ty90gDUzWO2dqzVhqPcuDNGUdQx0q4VCqEqRN4lN+7UIhGwjWXWq
	EbRu9oyO8IOyRYzrO51GDQKR7Wd6NL4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Np6A/4u3";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C5E6600AE;
	Fri, 24 Apr 2026 13:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15F8C19425;
	Fri, 24 Apr 2026 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777037898;
	bh=tBThDtj2tnEnBMiK83VY10biHSvNlAnlQoF2hPZIIoA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Np6A/4u3QyyNKYAy0Qt2eyfQhCDF5DkSTlTP3L2Dnc1ZLMSjUYd3NoVgdl10cFBpD
	 +kat6UkIGOap2baYde3xR4vJkq2DdWwJvdeV1S/BSB7xxeXxtaYXE87knitidGpRq0
	 0ghkCTiy+YjUl5nqFLQ4ifFIa/7H5tBHYMuCxkRc=
Date: Fri, 24 Apr 2026 06:38:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, David Hildenbrand
 <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-Id: <20260424063817.552a894d4b5bfa4de40792fa@linux-foundation.org>
In-Reply-To: <2026042303-vendor-outright-b9d2@gregkh>
References: <2026042303-vendor-outright-b9d2@gregkh>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aqqinrz4r69i48dpsq5fktcr8gc7qcfm
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21F29C000F
X-Rspam-User: 
X-HE-Tag: 1777037898-286592
X-HE-Meta: U2FsdGVkX19bBGe2VapWzd5f2PpBTmXPi57EHfKnxoCDrTX4JQ6OrFsde8P3dKlBCS5EL5rZ/uxfieI85aKjkRgWEBiyUo7CblXjlfcmpT/9Pro++VW0isvM2+wuzXGCgtEgJO6GZVTxklJlAvnJtzDgLQLicFZSLNwmrFFCdreN9y+KUdXcQXnbn+E9U2MeB3hthtWKzmEM2s+QERPQ2xwSh6FnF1p/z/X3yQI8T5jEdBr/zs0O5U1AAlFL1eO8o0V/9BvH6Im8HLdHCumshHu/gj1FXuBO6DiEKZcdyUpY04OyipQAORgHJQBU7Ic33vo4HCEij9duh5lM1nFoT8nj9KIFICD2UN3P8GRZmjtPxTRrgpAAM3HjbAbJD/KU8iHL4UFqEX9BTKWCpDExR5icMnBfCzqMPOWOvuIuEHW1D6eS0FN0IexUfjQeVy8cjPkKzaEroVJtUhAMjpkpNns/SPI811d0CidXg/3uId6Nuhf31L8NGZ7kdj0i2f713jQnigXGsbqo3sMKJaMj5xRnSFkqzZS31bT4ISoomnfG3vzrSlhKRAWBYEsogk/h0aQw2zL8ux0o9azFONN6PnP3sxqwOI6KxK2k9lTyN2O1SAcdhg4kyqqFzYDxEX70qTP93jssfLJ2btNDo57DPyf2ziB5etU6zII2EUv1sk0h+mt7fhfA5QIypBwATwvB3EbNCZ/bt1fKodrV2vjASt9+0ogIjQl+kojq248ficnesBWkMgXjs4FlkIfFVgvNm4eGlb/TDMvVKjDqLwSCSI3OZgGsyZbcQhhkTyx2V28RnAE9WtQTV+RHydEfsAjj2WEfoI8FUftDesyPzVJQHW1kFX+0Nelc4bTbT6NXmi6QprRRHBkec13u7HDr3MCtC0fjirtInm4oaUvFk8tNJR3hwlfWokQh6Bjz7zI0YEwP76y7y8LawyC1G+f17bu/n6MMIMGREmYGVk2hzau
 pEzRXbcD
 8eM3DAhDp6BGJW7QRZRc1fFIrAL7Q5CY0Lw4AwkV1t+K9v8j/GlcO9k0TZ4jwc63oTFnk83Pzl709bgxc2F3/vu6QgCvG6bMzcqypWx99LGkMZzWZ5k+kn+nMg3PGEvgedwlkPNVr21eA/uF/Q/QlEZ4hXj30+yUCgClnZ7+akpoWAMDzCGjOyUp/3P11v6dxBFTE2OmcqNXnAj4hZcgZ9+cmZQgNASvzrX4wUnCIid5sLvSjW+4Hf4XUWgtyWOmR064nAsbeoHohKJAZr9BoS4DB1Xk+ygdARgHMtLeuAm8WJJ2HQZOj50AH2aX7qQDuh3IvPlqOXfBZxXBtRfjTOIgjdHx6o28/M9XeU+VEkX9aHZWBfmyJPBd6sUb4ZqlfVUb+ehZ2QOkEArv8JBT9ak0NQ0KXWYlRLOML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Apr 2026 16:28:04 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> get_page() reference for each page regardless of foll_flags:
> 	if (pages[i])
> 		get_page(pages[i]);
> 
> This is reached from pin_user_pages*() with FOLL_PIN set.
> unpin_user_page() is shared between MMU and NOMMU configurations and
> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> 
> This means that pin adds 1, and then unpin will subtract 1024.
> 
> If a user maps a page (refcount 1), registers it 1023 times as an
> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> the page is freed and returned to the buddy allocator.  The remaining
> 1022 unpins write into whatever was reallocated, and the user's VMA
> still maps the freed page (NOMMU has no MMU to invalidate it).
> Reallocating the page for an io_uring pbuf_ring then lets userspace
> corrupt the new owner's data through the stale mapping.
> 
> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> symmetric.

Battle of the bots?
	https://sashiko.dev/#/patchset/2026042303-vendor-outright-b9d2@gregkh

