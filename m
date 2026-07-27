Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD2EC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 19:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037586B007B; Mon, 27 Jul 2026 15:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A446B0088; Mon, 27 Jul 2026 15:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F916B008A; Mon, 27 Jul 2026 15:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC5B16B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:40:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5384740194
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:40:48 +0000 (UTC)
X-FDA: 85035574176.28.82A6814
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CB9874000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:40:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="o/mc0v5D";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785181246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nt6DEP0tju5SaHyQIaUeD0xCAwRQILx3XKs/g5W3uW4=;
	b=cn8cKpBbuBOoUiVnPFH1GDz2BYBLlnb8g/ZA+kT+9rbIpVHxijOOfrCFzwOp0UXmT81lbl
	wEqzmXa7M6dYd9AIqfttcCUyhNSNlW3MI8kEBsubLU2kX8KIK+n9VJCIHl3YPS79PJjbTH
	CMA8wNb1LCbJxLdDVKfsA5KG25+76F4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="o/mc0v5D";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785181246;
	b=KDZm9pVm0d5FaWqd0krI/W7VV/PxCgP7eolvfb9jm8EiqgjFgPs2IXiZFL175qlc18E4ic
	rsdSpow3IAp6ke93kyOTsqipSQIrLC6GKWJbRWB1uVUU5Ij8XE5squasSCB3E+zXEb8PLA
	N+pmc1KEJrJV6mhoabF6AHXOXtx1sPQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2219E43228;
	Mon, 27 Jul 2026 19:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E691F000E9;
	Mon, 27 Jul 2026 19:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785181244;
	bh=Nt6DEP0tju5SaHyQIaUeD0xCAwRQILx3XKs/g5W3uW4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=o/mc0v5DzjKdaELjinsIVbJ1Sw/1+L2RHD7lgy9f5kHNZvXfw2+z8cNiUJIEVoSit
	 xCeZqJeU/wWmytDmCtU9FN6Du3D4p7kEK14qh+Yy35jWMf2yptyrwhtKDWFgVC1BFp
	 qbFzvg7WaWACDjTud98doO1WpWjv+/f2fmXkpFn0=
Date: Mon, 27 Jul 2026 12:40:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, stable@vger.kernel.org, Naoya Horiguchi
 <naoya.horiguchi@nec.com>
Subject: Re: [PATCH v5 01/12] memory-failure: Fix hardware poison check in
 unpoison_memory() again
Message-Id: <20260727124043.f7751d0259e78f15db94d4ba@linux-foundation.org>
In-Reply-To: <amduqWdnxeYwToax@casper.infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
	<20260725160042.1557264-2-willy@infradead.org>
	<amduqWdnxeYwToax@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CB9874000B
X-Rspam-User: 
X-Stat-Signature: nruzs985wuir9q8gdqpm7irs5qrowug4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785181245-908221
X-HE-Meta: U2FsdGVkX1+vvW6oBtncD4HfkMKkJ0atj06+Z/7NvLOCjpdmajVJcVwUqWTm6qREBXzJ3Lv/4DV08VU38oV5Y6ugtl0cfqBQrJ6eIHuN8xq+vI2CWPAdY0kUDdt8qSfTtC/gyUdMwibRSVKiJWCbz08PQLLr7rwEQIouK1Ba3nIVaZSvjen9tsD2HK79L6fSUlumugLfS3PE3VDI4DYwdynrgYaqj5lwQMNfmnYFEdPnCk1f27OPGZMInN+PrCdAN9LmWCAEPLi8LdNx6CRfxpoXtO+mcZ+ggJVtnVsrWY+Bm1a93ErcmIoWZszmCG3ZlgWSDF4ZghH7kCMiPmEPZRn1hCmOV0HEwzSchW67bRn9M5uDK2AKmd3LwYDNTKPD1LwLwY4LciJfXmzbOQtjjF0dCIl78BwClFOVVdWVdXqr5b4Xx/pOygjACOsEsCHy2NMjuLqwbF4MG6cfLi0uD4w5prKuOiqPC9+FTEoBMBMPxY/b7NKLFivaU5CEteqlUwJE7EEu88xTBcxVXPOXk9rXSvPbZYeui7V91Zb7tORzHwAVjXlxsd51Auc30oFO0JZzB6Db87IHol4DFJPmX5n6LZvvh8+DRDv2BTRlgn76acSCbSDcmV494T+2ynbtNbcM3SX97LsQ17rIggBzLoLbgFGPpzkHv9Wea9VVtfHBTe8B5kpgymlUEeDGlyg5/Wad0t8l4K1p0UdoEoyk/IwyqqFp6gQeGKmTTwX1EXetlc21gQbKow9UC2u3VpRcxWX41Ayf0io++kJ/xFPaY0MqZDRkQVAEXB5EyRJ7aXVTLV2izaUxkT1f+NQaHPw4sTgEJlsvmTZHmyxYN2gWw4n0HI3+us9t9KytkARlD/MjQ8qH/DHdoM2PcTluvfXDX2GkMh/yWmbmqMyGrITg6sK5pSiGT3ZblgG4OYNqQVj/dK/U7sywo/E7Hi65ys0D0/6jldTl4uswljqtGI5
 DqimnmNn
 O8WwfAkTGH6cYmpVGw8+p8dQvwERL5qTGbAMZhNwQQMMGMKRio2b+ApOY5kFb7+PWSwxX3S1NVPyUwhYACe/zKERX68gauUWSq5gs0Bn5FUQ6hwAS4rk8zJHBN93+ayE7VY3zZo4sBDZsGLbnQK5g8gn+KRqbGyLmzkLf9wus7hjIsDpeLS9o/oQruIpjeKLvZsAyL7hGDqMKy4p9QrWW0Sl2X/WrFuxy5zlNHUD8j5SHbRZxpg+PAzC2FfM3igaihRUswvwQ+4MUbf4yFVWICQZfNv+OHsi1gDDd9jadkTYx0ZFqcSz2VMb/xgQMFEjAJe52OIr4momT6wPO2WKJ5kdrpHBaR0de8/NG3UuHIurlRqnH4h0hrtdzVFvNPIYwlpas2lO0Izze1FWe24BNnhxzkZZstiRmffNJKjoq3m1fkRxPuPL/ijGp8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 15:43:53 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> > If the THP later reaches a state with a single transient reference
> > and no mappings, unpoison_memory() acquires a reference (ghp = 1),
> > calls folio_put(folio) once, and then TestClearPageHWPoison(p) clears
> > the flag and returns true. This triggers the second folio_put(folio),
> > dropping a non-existent poison pin.
> 
> I don't know, and I'm losing patience with the Sashiko rabbit holes.
> This is all getting very far afield from the problem I actually want
> to fix.

That's fair enough - you aren't a memory-failure maintainer.  If you
want to take a shot at the pre-existing things then great, but
otherwise then let's ensure that the relevant maintainers were cc'ed
and move on.

One relatively minor issue here is that if Sashiko's pre-exiting thing
is serious, we may decide to fix it with a cc:stable and such a fix
should be staged ahead of your series for backportability reasons.  If
we end up upstreaming these things in the "wrong" order then the
backportable-fix developers will be asked to prepare a backportable
version of their patch, which is a bit cumbersome, but not the end of the
world.


