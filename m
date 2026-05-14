Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4EDCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61CD6B0088; Thu, 14 May 2026 10:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C395C6B0092; Thu, 14 May 2026 10:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77766B00B0; Thu, 14 May 2026 10:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB3606B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:23:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34A44A0586
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:23:22 +0000 (UTC)
X-FDA: 84766243044.13.FF080E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E52918000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:23:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BPmI/LVz";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778768600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0mOgu+j6AtD84a1aim+pr7cZtbQOaEETWrTMXJWwSs=;
	b=XNrCOHAs+oPGY17+4VtLCO6J41DIKSVONdj0EUI+gHwssBByAUxbHJ63ZxG9jq4gaNTLXF
	V5A3OjWgIYBZxk9mEvfXzGHclfTOI8vZDvnvak9uvhQNW85jU354TeL4HIBCYAU6qkqpOl
	0ieUCGBB9ae8p/WTRqV4CyYv9E8f2U8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BPmI/LVz";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778768600; a=rsa-sha256;
	cv=none;
	b=41P6uq/Q0SnouTUqAx6/iMJ/bivZK3VRLIRlSIMtznl+RjvJx3U8FdeSAF6eyqz7a3oTKn
	FxdgJJNstvi1kqMlDwkkPyMf6Vupzsn7MHoy1q5gXtVaCMvrZee7uwPkD/fCnjbDqfl6Rh
	nYnfqX815xsbCgrQ6sGF+dT4w/uiy6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E178060132;
	Thu, 14 May 2026 14:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C03C2BCB3;
	Thu, 14 May 2026 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778768599;
	bh=s8/oSNdDzyaW9JgdNEshO1W6QttcoYdTTxOogreW8qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPmI/LVzSIvqPiHRUQXsvZ/EkZwCRxVJZxDPZ2b4C6TUPcD2w7mmiUDN4B57ZBNTN
	 G44ymWA5fZ3RU+DLdAiXX4kLyOGpjYjNjLHVafdcuEF9odj4KV1e0z/vGujscJl4P9
	 l0wQ3t+Up2NebtoZQHR9rvHqHpy0hN8wSATdSaTSbNsxcNSzWINqZ0coHP/cm7mfu1
	 tgFG/5uT42LO1dMbt0xWGm/tfg6hzEdwqChan+3Udy7nQcxZJMPKOyBCerx+3tan4W
	 cW/yttmr5oRlrcfRfgsvUUWErVhKIKUnqDXNbQr66o6YmbhKSak/hxrHQLiTzJi0E2
	 1HPRgBIJxOEfg==
From: SeongJae Park <sj@kernel.org>
To: Steven Rostedt <rostedt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] maple_tree: document that "last" in mtree_insert_range() is inclusive
Date: Thu, 14 May 2026 07:23:11 -0700
Message-ID: <20260514142311.119947-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514100723.4af0d7ba@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E52918000B
X-Rspamd-Server: rspam06
X-Stat-Signature: dsps6rn144ifxd19ebaq3kfo11j4moan
X-HE-Tag: 1778768600-318655
X-HE-Meta: U2FsdGVkX1/ZRznXhfEvgN5WhvVXNSX7vcxKCBWegQfmTIIQIwExBsvnQbZw9laxnDKtxOU9N60gJ56gDuecKCWAVZfZ6rH2LOojqFHghbX6qLw/pxczvdC8LLufItaq74rm2ipi3rCXm+LvsfcLOp9F65raadXqH2encvMWrXDHtVpIMMu3wbKvOAJIpQyBkCPGbhGd+PgLXl+XXMi33ampYR4zHGp4ahiO2Xdcp3+0zuKqBax2a5bD00ezIejeMDcbi4VJMomywqnYK+m7inWG6SsRXwPN26ifZ9/cwGrtusDOHWTKNEGn/mLE8MW2Rg989poT/WvD8O7QzNq0qn3+KGErjMYHA5awSzbLNsxZyRsutrO/TgBagl+tPOvQlKYxBZ7li9no0dL++7ZxHsBHAdAp6MDRC8WXHzbmp/qKRnTYiG0qyOl3K2bLy5+5PB2tqidGxoQ7BknrPCcCxaxEtFcMpYssZ0kfPBUDEIcRfiw9rAoq0c4Qp+D2mF/x2jDG9eVeLOcjrVpWFB8aHKzNHM6le70WQAPdNKytxDh7GIz6UVUBlYM65khQjsYkc+iqHIivkgcIj6Wr7wK357hX7lg8KKkFhoybxi78qnVUCUVlLQQ9XmFkRTTaoSJ0Rbpcbvogxew1GiI28foqA9VJwvfZ6i4u1DuPJXEUaY38zytWw0cO6zZxaVpugcBAe4bONRDbVdZQbwqySh6P2pjTubehycM0g2VIP6A1aRQFa5/JlKbvNHOuHvc8fS6WAjMPvdYza3b41IFRcJ9eDNQj16mfAQwWkSPiYmAoGx+nM7gPQrT9keq702j8VPlnXYBOtfOcx+Orz4ZpSM0VSoghnA1yMpzoDtP6oOXHzAGdW2XiUcjIloWbS4VLQNuUzb/WXYyCT+V3EF9iZD5+68+wdV1xwPGp9KmtT0AqYb71iNBjStC80cyEyF/7V3wCucwwO7oGmHbfshM2X1j
 i6+xe1hG
 pfWFp2GaF07zleCyUofTsh921rbiNZ13GhVz53c8w9QGgXJfAMHe98Y912S0w73aH8VzYXZ/QM1P7PPkrmtwj4XWGMKjBd24GI+mrxDi+X5nTGcsYPS/4ZZGIg4z+oyjIRaNO9jdP7ZFm1OxFpx2xPqjnNSN4rBzuVAdr1iCKVEeLrp1NVUGxe3VH0XM2/0i7ahOi+yw7roKLYlUOqN1slftXYDaspWbclpyMJ+av1f01fHx8sx98+XAzULg0GKRvP+nwaH9iDvhy75YskG79/1u0Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 10:07:23 -0400 Steven Rostedt <rostedt@kernel.org> wrote:

> On Wed, 13 May 2026 18:42:04 -0700
> SeongJae Park <sj@kernel.org> wrote:
> 
> > >  /**
> > > - * mtree_insert_range() - Insert an entry at a given range if there is no value.
> > > + * mtree_insert_range() - Insert an entry from [first, last] at a given range
> > > + *                        if there is no value.  
> > 
> > It feels "at a given range" bit repetitive to me.  s/at a given range// ?
> > 
> 
> I just added what Liam suggested.

Liam's suggestion was very sligtly different.

: Something like this:
:
: mtree_insert_range() - Insert an entry from [first, last] if there isn't
: an entry within that range.

So I assumed you intentionally reworded it, but might forgot erasing 'at a
given range'.  English is never my mother tongue language, but Geminit also
told me dropping 'at a given range' makes it bit easier to read.  Hence I just
wanted to check if this is intentional.

> Should I send a v3?

The current wording works for me.  English is never my mother tongue langauage,
so I cannot judge.  I just wanted to make sure this is the intended change.  So
I will leave the decision to you and others.

If we decide to rewording, I think Andrew could help without asking you to
resned v3 for such a minor change.


Thanks,
SJ

[...]

