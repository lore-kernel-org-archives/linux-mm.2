Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01FFC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22EF6B008C; Mon, 10 Aug 2026 12:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFAD96B0092; Mon, 10 Aug 2026 12:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10356B0093; Mon, 10 Aug 2026 12:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885A26B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:16:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 080371601EC
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:16:11 +0000 (UTC)
X-FDA: 85085861742.10.A9FB0B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E989F100011
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:16:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9NHwTND;
	spf=pass (imf05.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786378567;
	b=rQVZRoOi5plyWWrD3ZrjrKUpz/sxCaP5ckjawwchTVnzpdcpsFRnjDDxrPTXYiJq8Go3ri
	J2kZFp7lbiP/o1hnCwOqgx/rKwMr+jJk8FIExjzVIvMd2ulCtGFlSAOGgduAsViPkVghDI
	Lz1afRu0R4A3bmsFe/IG7qT/PFCxT8Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9NHwTND;
	spf=pass (imf05.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786378567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlVAueKovJSaHcWrWN4BTIc7QYuuIT53QjtjPZuWPck=;
	b=F/5LPOnqM5rI4QW+gbn3yiOQLhP//raPMJSuPmP7Zf6yPkV6vNsnmp/b/3QROGESIo1C0T
	ubMtUHR3qgn7Co4T+XMLIDIZjzA+1tbWlMcVCPthOhkb7OuWf+WGaFb1duLz6C7nlQIPOi
	ZgWgh/fHqA01JbaT5ENOj/hHTINA2H8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A7BD60052;
	Mon, 10 Aug 2026 16:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D851F000E9;
	Mon, 10 Aug 2026 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786378567;
	bh=BlVAueKovJSaHcWrWN4BTIc7QYuuIT53QjtjPZuWPck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S9NHwTNDd9FQ7nrl98XA7oP4Xhhu9sW1p80y37Wvsam2MFSlFDytGjYX3OIkStyo7
	 p/eIxc7hR5jr2cbZSwWmhxbgkjBzYLTO6LvWXTJbV7+snMR67wQ0U1HNS9oFJ32wjw
	 7sU+MOjodVdh2R0vtbjB/aIIOtnk91e8foUNXT4fOlRLv4wg8Ys3wLl485NPfz+0wU
	 Rd7Qb0/MG6//xCyA6jZeM8iCaSWF61OaxIfh64qEzZCouvk9Zx9765Icn/gjxsFDSv
	 1MdwCH+mN0HGa1n0dOoAExjIEb2LBKn48i4fdPQc4BE80KpoCJxc/f8pqA6DlHlBrH
	 etCJDghhLcyTw==
Date: Mon, 10 Aug 2026 09:14:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/3] mm: support fallible mempool_alloc_bulk()
Message-ID: <20260810161404.GA1930@sol>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-3-ebiggers@kernel.org>
 <ann1i5VjTmgChjs7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ann1i5VjTmgChjs7@infradead.org>
X-Rspamd-Queue-Id: E989F100011
X-Stat-Signature: uni65ktcc8jiib1deg1jaqp9jdqrtbmf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786378567-280141
X-HE-Meta: U2FsdGVkX1/WaiArJ4uvY3JN3OvPKzxa9cCoTfXG3dUqxztH65n6EVw/UkZGU6NNprD/0/5rzDect0opChnd2wJFdU5qPYchwcMs5kEv+3o7tBEb1hwBev4eXU5oBqBPPcp2KfcMKo+DxEJuaDZmwgS+05GcfR003pjeHAVf3LeRvbbThEAaVRCCxMcdKgR4AelM+3DTcYXQG5QNQkktah/A1/WAgM7A3Lb8XZYur6IYlInAQuNEND1Gw6nEZEl8SfnADxgGFVdsKf9PJCkbveckgjENY7ZNQmZTVKo6LIlw91ACV+6viuVdTSkKzgrORsFf9ydCYU8to2uuMCNGg6mEJxdXC1PAZCeAo+iGzv2ES1+U2Pxj7jwJHXIz21kpu4qMrMj5MjRjKKgTlJQiHUJfBOdp1BQHN7z+oALfl84Djpot4jRqMQvE900Qz4Prywdm5u76o9AzEveH5eI0WvfrXjh0PXftDtg7FIb/OhOlYWzFVICWYc7k6oopbJuoGd4xW+BwnLNIO3d2k/Eu/TiMhOY+D/QA5mJTy6RpPzlTPCSPeBQCm59r4jtW2wnV6cY33xtim09VbA8nnDR2Y8X6ayJMZZg/AHymOz+E6Q4i718TPv8xAgl+tS948Y255cuBOuoRDtgidOjakHhDCVcGjHcbZwCGNmdAKPw90mY/2GRQPPdP7CgbyHJz5BT1ZaO5afemVLokBUd5blmQZ7JzArL0D4iuS2OKELwmhZAk9D06snPpJUA3tqWYggyhC/Fw7d4dFgyvq/usHyA03LWgERhkFEs3/xBjq5vLA2li9UjWiuAjLwBC69bYFy7Vu1Ko7lhIurGDTReICMwtdkp/TXHvQf3PJkyGWUELiWMDoQAKKC+SfBucKMjC/sMgUcJiNmj5M9lK0R5Ua32CDmTNVZ8Vvi6FG48P5HShP1n7+wMcJFdsTVUqgfTGWU8ZHssfz2nyDYdZ3FfBt0+
 AnVM+Q9H
 6s+zZKhnZAJUzyYawPCNmVEZoxfcDfp6fxYK04UbgF3/2EYdHhGKo64/4Wyw636JF/0gQQVblpTPE7RWUIjjuPVfYpsK3q4ADaW+17Vs0KIfjvrNBjvvw0ikcu7jQAUssGTdGqqm95stpylK0XAH/lF8Xu1Pu0DYnqEAqZ+cAqTTaRVUdrOrrO9lljv6LCvvhQyB2xnfUdf3Zv9h57SVaSuVbfwFnJA4cDmI2djDB9p2if4N9LmdBUP19uPL/sHZxCZomRrQm+l9oVCy3Ohl9Zcb6WufsBKrZxG99aD0HlqEkkiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 09:00:11AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 06, 2026 at 03:10:30PM -0700, Eric Biggers wrote:
> > To fix a deadlock, blk-crypto-fallback needs to be able to make fallible
> > mempool_alloc_bulk() allocations.
> 
> It doesn't.  fallible mempool allocations are a concept that doesn't
> make much sense.  Please just go straight to the backing page allocator
> instead for callers that do not need the mempool guarantees.

It does make sense.  When alloc_pages_bulk() doesn't completely succeed,
there still might be pages available in the mempool.
blk_crypto_alloc_enc_bio() should try to take them before falling back
to scheduling the rescuer kworker.  The rescuer encounters scheduling
overhead and is single-threaded, so it's slow and should be used only
when absolutely necessary.

- Eric

