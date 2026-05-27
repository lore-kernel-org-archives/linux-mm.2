Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAAAECD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 10:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A5F6B008C; Wed, 27 May 2026 06:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2346B0092; Wed, 27 May 2026 06:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9CA6B0093; Wed, 27 May 2026 06:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEB1B6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:06:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99150A0586
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:06:14 +0000 (UTC)
X-FDA: 84812769468.11.20C1DB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id DE5F740006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:06:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BCbVNamC;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779876372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ED1wg3AcoDdFGNLgLheoY54/sZmjqAMcBOPJMgMobtc=;
	b=Xta/cA2vGr89ex92SR9Zxbr9QVNv8av0xQScGjFLneYG/WQadtdlkUWcg5bCWjiXaQopRv
	l8dHwSNUMR1f/YsMfO38Zy18hxd30O3QBbbAQkyaEKcmq7eH2sJZSIKdrPcN+rU6oVhrr2
	ugwk/eI0+/gGKM8l2M2eLqYpwnwJh+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779876372; a=rsa-sha256;
	cv=none;
	b=NzhSzd+8AIZKzhCQpwS3WsTYCRofzJ0NXf/V6F51MjARdk/q0zD8lKLDboSsdCGGJ8xywg
	5ohInqBM1oyJunTnNspToPaXgw9yjy7AxmSzQpVFKPebp0M3YrUJ0uZDnTueymPsBDiGp1
	AjwFMQvetZaLqlAk7EkiDprU2czmOZA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BCbVNamC;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55F7B600B0;
	Wed, 27 May 2026 10:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBFA1F000E9;
	Wed, 27 May 2026 10:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779876372;
	bh=ED1wg3AcoDdFGNLgLheoY54/sZmjqAMcBOPJMgMobtc=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=BCbVNamCBtDDV+DyXMTTmxDEuzH9lwqSb0CMP3Y7MWsBH36Gs/G7XLQ9uEOcdQmij
	 t/TBBohYWqdqmSeu2VqqEmA4RPu+6kC7TrdEdBbzfZoBdwHJn6ULvhaVY7OGlPYNbM
	 D10Pa0z2GxWqwl53GKE6UXBrMDTW7vKJF8cnVjD5EzkTOnbX0+4xIp6i2Rmz6gdxY3
	 3YKuXnipdKKnr3wMfSQaF3y8mUzz+s99J5PQePKwy8uz15dL75m74PtnwbUfylfqdB
	 Py1/i76/Xxv5R4HaYundlN4Mogm8d6AnmQ0QNzUWfjoITd8kUgBOORyR+S6+hqtMzo
	 9v9AeYoDwl2Rw==
Message-ID: <df21e8b0-a67b-4b71-8178-91221b596949@kernel.org>
Date: Wed, 27 May 2026 12:06:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: revisiting alloc_pages_bulks semantics?
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chuck Lever <chuck.lever@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-nfs@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260527071816.GA17632@lst.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260527071816.GA17632@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DE5F740006
X-Stat-Signature: oeadi7a6ay4shgt7earshsmwhewj4cpo
X-Rspamd-Server: rspam06
X-HE-Tag: 1779876372-401000
X-HE-Meta: U2FsdGVkX18R+YOp8Ggz88waQz/YhqhITcYzEGz5gj1yUQP9AxrmcarJFuzrU2oEJlh+IvJb3slBkGIFOGe93OSdvRAZf+4M9F4tI2sIACOiAaag19bM6sjMebdpS5L1PVTTQ5NsDl58uHnMTi7enouXuy/CiValpozb4KqgsYd8Cq02mfZvRln1KVd2MnpjGWe776U27CyVVjgE3oji6DuDIdwOulzlQN2lYjXBlc1FgQqmORmrd2g+5vxzGM5gqEHcyAYNSm+8/hFs74y1FbAd4XR3vubikWIwPbJRLwgrolWnuw37wZwNBwDgIBqwaV7dAjp7aTyJ821qo5bEUD6/TNN18a0DiKDRowLFRHJY038v0F0OeR2rTikrwxWlnjrblNAACEbs6Ov9z6nRrohQlpbHxV/LeLTYnh0UngPHz26IkbrJCTw3yzzQFGG38qnQMqjvzCJac3FdtWW/WUsColTXiajw1pVoHfJbHt1ybrciGehK3K/ooJmEC0knDS4uTtX0e3DXODtxe4vQThM8AvsDRbs3VVh+rUonTk453Fg3aOygK82W4EyHD6HTBUoztLUqg9KWe41wW2rtCfqub5HlJISrwkiZwHibiwYCd/n8ExPEFeAqT99iJgLH/z0Nbh+uhOsEguWgF5y/tbYblpxCX1Y+KH42TEXi+vPmRunh6a9mMEmo8APBxohm/om6ypNxiAuGu1b/anUhe3ub68sLGbxSeFhZJbRm6ClPlmUIeaHbmNuSZPlbxwvFYfVQZXJmy4fhlyuJzeJgM6VnyRPcudYYHr7IaxMrmg+1bB3a4HoE9LlyN1dVFjUZIFNDIpT69F6i1F8RPy7742nNaORnYfqC502G6jOFr5ki87FFGrslEqGTMruyWOMuzY3xhuRxGHMLQ5vRCdfRiOhYSOMBtayagoEtQt5/LP2C2RUrzCoSJFY4GJBcjOdn2eYCS4INXNG5yWebI1w
 1wYw6N3W
 nW5N3B1ukQLWOG8cUFMRAXxUeyCM0mIDvRFnoYx1iKl+h6DdzldlTtC/Ex7Uml21sBe/aZXeNVspBmGgHD3doGE/yimpLkEDsNSc6xqj9cj4T5wKr4ga59oSc+oIrrtv34qp1loTEt57nehJJh/WnJm80fh/+PsXVT1aIPwEVzJFV/u9Y6D3aPCHCMLC/cEBEvpheQlrtRIE+6gc0mXxzdNjaufZPlIeBE9i+2wOQ04LAnAZwrdOGTh7nnY3AjP7q5aKCdV+FW4Y6otTmDzmNX8RD5oaa1IJzbsFPLsi759grjtCCtEEywbPC6ZggYSFYi8tAW++Op0pqgcD8qlFWdk3wMaq8vRm0CQay
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 09:18, Christoph Hellwig wrote:
> Hi all,
> 
> I've been looking into using alloc_pages_bulks in a few places lately,
> and have run into issues with the API.  Here is my suggestions for how
> to make this more useful, although only some of them are something
> I'd feel comfortable to do myself:
> 
> 1) early fail semantics
> 
> alloc_pages_bulks can do partial allocations for some reasons, and
> users usually have a fallback by either looping and calling it again
> or falling back to single page allocations.  This sucks!  Why can't
> we get our usual try as hard as you can semantics, requiring
> GFP_NORETRY or similar to relax it?

If we do that, do we keep the possibility of partial success, i.e. return
how many were allocated? Seems wasteful to suceed N-1 and then throw all
away, if the caller can use a fallback only for the last one.
Do some callers need all-or-nothing semantics? Should a flag indicate which
one to use?

> 2) pre-zeroed page array 
> 
> There is one single user (svc_fill_pages in sunrpc) that relies on it.
> For everyone else it creates extra burden and is very error prone
> (speaking from experience).

Sounds good to me. Will sunrpc be easy to convert, or should it be another
flag to opt-in to the current behavior, that it would use?

> 3) page instead of folio
> 
> We're allocating folios, so we should have a folio API.

Hm, folios initially started as "base or compound page" but then the
semantics shifted and now they are also rmappable. See how
folio_alloc_noprof() does page_rmappable_folio(). The differences might grow
further with memdesc conversion I think.
So do all the callers actually want folios? If not, we could have both
alloc_pages_bulk() and folio_alloc_bulk()?

> 4) > order 0 support
> 
> The bulk allocator is limited to order 0 which limits it's usefulness
> these days.  It would be really helpful to do bulk allocations for
> the pagecache or bounce buffering.

Fine, with implications for the comment for 1)

