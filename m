Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22D0CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 11:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36F56B0088; Fri, 16 Oct 2026 07:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7376B008A; Fri, 16 Oct 2026 07:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6666B008C; Fri, 16 Oct 2026 07:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF1C16B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:55:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5226F160404
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:55:16 +0000 (UTC)
X-FDA: 85328333832.30.5A29AE0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id B8B7E4000A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:55:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FUmK5vIJ;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792151714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OPYvk7hnU/aVH7fHcxffkjZ1fvpOQTxe3B+xRpZY/Q=;
	b=uEhVZf/R/IeEcaDlucK/Bc08g+Toi3wQpS+op+l5N7Mpj1rRwy56ETEsQxioGbv4qzm8me
	EnFx+LYcyxuxxphU1kcdHopPleWglI8aTCfUjBQZG4zOy1DLlrRm7T9ZegavK/2xOwQDKB
	B1SMD44EJImnxbbmsQAsyMIzIBaSSxQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FUmK5vIJ;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792151714;
	b=KjHzoQoN6NvIXoFimvQb5WliINzArA/kMLlZ+f7n8k/SfX6TN9f28vxtuODwPvIVZWhXoi
	3fRpfXkvHujJ2dX9ktFp2t7r5Xo8KdtIqULaghGu/9IJJyuthWWAluuCUiLhquOn/cbnde
	guYCuzbfWj3JzZMvRjuenXXgFDI0adM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3OPYvk7hnU/aVH7fHcxffkjZ1fvpOQTxe3B+xRpZY/Q=; b=FUmK5vIJ1XaOAXqCip22POSGd5
	DPbYeJwNMDFcX3y1eXUbFs9mQKr+MrZOgj3i+/IMSTOjMzcrDApFOmBkoriIw8aN5haFKwIL7GM7T
	My+dtDTKIE4eDOO/QrHjjoE6rJTjkW+OMWzFbS/W2G+8LnCVFLe4OXtseu2m8g3MUZ11vKcxz1oV0
	wptolF3bozjXDPd+KJi4YZgQxfd8h7PS0tqmXNoElH5Lwvj0eP+yv7I0tsCyU4V+SnsK395qh8ayA
	GiZNDqvhjJ/awd39DZM74T6YJzhVRaRcB3eBuyngBj0u1fVfuUM9BgzvoLEe+c/V2pR08rGt/zGT5
	OATBlweA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xHgWX-00000003MMv-2dyK;
	Fri, 16 Oct 2026 11:54:57 +0000
Date: Fri, 16 Oct 2026 12:54:57 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>, Chuck Lever <cel@kernel.org>,
	linux-nfs@vger.kernel.org, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 07/10] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Message-ID: <atIQkYA0AZg_z53_@casper.infradead.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
 <20261015233309.42999-8-snitzer@kernel.org>
 <1299ad92163f2eb8fecc06165b3b52f7904f09e9.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299ad92163f2eb8fecc06165b3b52f7904f09e9.camel@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8B7E4000A
X-Stat-Signature: 9athppet4a49oohm689g73d988fhefst
X-HE-Tag: 1792151713-622822
X-HE-Meta: U2FsdGVkX1+Gaqt4yO4zgwwvntMmQQpjiGGhkhtRoyTqJnL2TmC645QL5IKq7rfbJ8oXIoKG7lPNB2iROfz+134suVhqN3HeZJUWBun4BafqQKnMJ/O77YqhJVSzHOCtOoPYYI954iODJEv9wQwfycqQ/WPLBJi5che/UJuvOcG8zOHF6jo0TJeIUw19OhB5IuqwiiLGDaLww67BTU10PufQlSUqEmrwr66IFiPpImW658v4pw83EyRT9j/KHZIFz0gVdTC4rQUPW4vClnT6U0DIvxeblOl7d6KwTNOFdR4FS94qsF6PXuWNAH8R/G1ONWi31i7EETwlJgYpMFIAvVk0BZQSqTWomnkR978xvKfIe8XGG0lC6HedObcGQSujDq455QZbl6UKvTBjr5Ou/c2Nuknwm9Idwa5pYDja7SuiSZLJluRTQ3JyAQitoHDYCXZggQ2DF6C1uZZBhc6Gsal0JvqfAYNlW2FBRtnIe8n7RiTYKlIfCpKlpz5D5n/Ji4bUqD9vqzg/62pggADl2Ypnky4yvQegF7xmQdgojPblilaHpu9ZOF41CEjM3uBh/dc80u3pYvJiobG/uRdFjki5UX9Km0BXdSBx/MtPXihghP7iSy4MQV2o8hJ8mQBCy5L5leN8RgjpfgXUAROQWmuAiSkAEjPng2rJA+TzTKHp5FRWFHRSNBHDmqdETWHUkycOSj3thTMIxittj+CxXgol0JcYadrDIdVza/MA0enrzEmiAsyx4Kw2kKZFihO8EYDWHHXh3Efbrysu8CEJMtN4S/6alEkRdsq6mgrJfQ6IILDRgFww7cT8guxE5wTzs4GELuMY08Woio8Aa4neuchhO2cb84GfiXCXRYlbC7xp9iKY3TsJi3cZEIob/fZd+Ob4I39vFVfuqyFCLuMvd6106raBawmLyQSGGou0hxWZmLk0L90KV+dbVyfBKO2yjmrM7bsVbWfvt6V51eW
 WgMfJAjO
 3O989yMxWFJ0ESX1JweRFScjcsjmLHud8KCQe1LX7pkdFLYiZjFc0ic1MFs79aPfTbQPhBNXmm4GCOucNJxVzvyT3Jo/005eROGzZAjXdDLP0pvbQWFZDac1YGRKdEvR7y4cpDLGbWlXfrKL/8cUHZyzI/0mpft8Xkc0MayLZAx5zQq8ZIzaVpw50gu2UPPtYH+pJl4gG2YIZi+WrDXxtMieMegpE6YIx0TbLsjfPTrXUE7Zq6e5AoUd2cA9r5E0GLbN3w1DbyI+V98H7xqHTojorLyabM282YOZ+qPrAYP0QKFwcUXm9Daw3WvXXFVEZJZz8HPSvXc2Oi/STm1YLi/4ifPm3sdwzXeJ7VZfT297ZHSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 07:08:41AM -0400, Jeff Layton wrote:
> This patch and #8 need to be split out and merged via the mm tree.
> They're related but the rest of the series doesn't specifically depend
> on them, and I doubt Chuck wants to carry them.

Patch 9 calls folio_mark_dropbehind()

