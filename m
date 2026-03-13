Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4C48105F781
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3BAA6B0005; Fri, 13 Mar 2026 05:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9536B0088; Fri, 13 Mar 2026 05:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0F96B0089; Fri, 13 Mar 2026 05:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9A886B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:05:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FACF5B7B7
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:05:41 +0000 (UTC)
X-FDA: 84540456882.05.6E3A1F6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07A4FA0004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:05:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wcbg+L8W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qK8O2iOc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wcbg+L8W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qK8O2iOc;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773392739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0m0s5pdVjKHvCJpAEdEeT069Mh8Lg7OybTm79ipwthw=;
	b=vFe7a9owR36rObaFi4yj4zZR0GEgEg+1gOhN31rq2jfc5dkMEcP/VbnpvXbUL0KniNHNFA
	ZwwH91J38DDKRMGWeuIvViW0SMxdvXarGZOUZ2UVpHj0/wYkeqWfsQiZ0zGvLwOxDd0kVH
	PK+lMl8VeA4yALiD4e7Ycpe21EFoxX4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wcbg+L8W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qK8O2iOc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Wcbg+L8W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qK8O2iOc;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773392739; a=rsa-sha256;
	cv=none;
	b=A8vaLBEQ9fNkZA7F3idhkFQZPN4Jf2aM7fGy0zCGw/+fPLujrdEPl32DoiNbt3FU0K6VST
	3P4ho9mEgcXYbPMLCy6Bwpj1bQxYdyUezYidRUFfP6HzdIbVCrnhsoTyG6YjCeTooX8DBm
	nAR+xvvIL7HP7bImAoSicgkU3Tfx9Q4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 71F1C5C01C;
	Fri, 13 Mar 2026 09:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773392737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0m0s5pdVjKHvCJpAEdEeT069Mh8Lg7OybTm79ipwthw=;
	b=Wcbg+L8WeXcaUyHTeI88w9O1WNcG+nA6+ulDzpIu6h8lYfE/N9PwRl2VL0+djPLukk7sdd
	dcHT/eVdZUaSMvHIss4Iz49Yu681lc+AtxBzxoYz4A2NudTYTKEyInkyBZYDbr8Mpn3IT6
	9AO3qlQvGqZzPYq4kuXGx9js0uWvBaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773392737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0m0s5pdVjKHvCJpAEdEeT069Mh8Lg7OybTm79ipwthw=;
	b=qK8O2iOcrj7+WlDp6VUw6H3NozeWa6hqn68jzYO4e9mjop+ibmSHsnhyydeCY0MJyh6M6R
	TW6fzqOF2aH6XtAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773392737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0m0s5pdVjKHvCJpAEdEeT069Mh8Lg7OybTm79ipwthw=;
	b=Wcbg+L8WeXcaUyHTeI88w9O1WNcG+nA6+ulDzpIu6h8lYfE/N9PwRl2VL0+djPLukk7sdd
	dcHT/eVdZUaSMvHIss4Iz49Yu681lc+AtxBzxoYz4A2NudTYTKEyInkyBZYDbr8Mpn3IT6
	9AO3qlQvGqZzPYq4kuXGx9js0uWvBaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773392737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0m0s5pdVjKHvCJpAEdEeT069Mh8Lg7OybTm79ipwthw=;
	b=qK8O2iOcrj7+WlDp6VUw6H3NozeWa6hqn68jzYO4e9mjop+ibmSHsnhyydeCY0MJyh6M6R
	TW6fzqOF2aH6XtAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C96FD40443;
	Fri, 13 Mar 2026 09:05:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V6DcLWDTs2llaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 13 Mar 2026 09:05:36 +0000
Date: Fri, 13 Mar 2026 09:05:35 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Josh Law <objecting@objecting.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
Message-ID: <gtukkafnyhdhxo4eu3a6vxnkfv7w3jponvd5mzljlaosweoslu@lujaedlxhxhg>
References: <20260312184054.23481-1-objecting@objecting.org>
 <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org>
 <i6tmfotangjjtzek5txtvoiav3xrfvwtw6cppooyja5mvywmz6@2c5rnyxqpgu6>
 <d73c8388-bcb5-4a8a-ad3e-da719b09fc40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d73c8388-bcb5-4a8a-ad3e-da719b09fc40@gmail.com>
X-Rspamd-Queue-Id: 07A4FA0004
X-Stat-Signature: 4itmudmaunxobs93t5e1gpq6ft849q71
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773392738-318122
X-HE-Meta: U2FsdGVkX1+xRo/g24hcEEz4Q6W2PoHpK5RSlhdlwjFoAXft9c/0pM7l/c8sZlJ6X0u76BFue2vSijvH7kBmNUcD3JAi0ZDbnBcZOEnOWdFE+Ym5eZxV+9HoTCWvsYIKo+TClKgnV41hhd6dXyw0GSqK9DUhwGUkX2Nql3IOYhhPhH+DryjM4tn3KQ9AX+pf292Ieh1Sg6rU6244MWoBW48zLoqX9h2YUnLogDbgY+rivo68qFVO67+DUfnC+F9tGRlQeuCmrm7L7iM8cztWtxtnVMV23NG2LnmpIlrjWIzSDLH5YmyoZrcJEfrqjg033Xnw1J4I49uKtGgK4bOU9okjcZshW1rqkhlXYNxuOnvbqCBAXWAbXPSKXpWu2FpV0g1XgJMCCf1mnC0Y2e4IYyVKN+grK7uv8z2rHRDy4h1hA0i3Djnvjz6pPjTVGFVn0Uk1hYq7q0SZWsAVWf1IsoR+2xYOtz48i9gXWvPxnuIHCj6kRlfPtTg2HKW/QZIA8wh3ilOQZ1yko3XrAzAkGFHfJ7B7ggAdavzTDIENO8ETN7u8FvtninJ/fyZoQVTERsgqkf+SMvbZPya9W0QWvEsiRAiKFAPveZS5N80so4sd8O6n6znM5aDAU619FgMRMyijQqA/OuDxjAvh5qY8jUneq8IVZqZaFnYwpY0kLDahUnLiCqScXoKzkhXEJcdcR63ISC0W77EYo2PDLxBeWAzyAm2QhY+YeMzKJ0pd7/HuDPhGNmixK5DAbqSXI+0Zh5Kxp0fYfXsl28rgonB9GyyCK+QD+9e+TfJhCeX+gwDnegRaxhAdTvBpuGR7hSZ+oHW5J9huZUm0p9hNxtJfa0Cnth6vweb9HwMk9mSLbeUXqX0ccVrzotOOugawHufeQYCz2sdEZ8SrWXhGSrXbisUYlVszx/s+KH4764j7uhkp3qrtqtYjo7hlhjBFYDXKzkrwBbvUGkaqT6VRdCP
 BVe/ctNJ
 KS+YihTuUOnYGGzdRX2DLU5f83qPc3Had4cwHa8SyLtLOF9hrZu5VkXgbSNWeqPOtVeuSVGaGWmNr2sR+ir5jQQ6sC1wqACIjVJ4EeMQN4pSo+TnGCGyS0cnL8/zqVKpDol8ah7Zdh7HbjO7MNC1q2YPR1OQicfTYkrQe38MsM5R34V1gdMX2Qb8lDQsm+ad4GRufSXkM0aOJHwovQhpb67JOe54/4ENuHrgZkEkxpIrRaOkH0V2JbzEAnqojdHv9ChY8e0EIgisO/8CdqWYjGWbw04DxO/oSbJ7p2E46nh/8oWMa6PNuXH/UmI+86izw4Q4mUj4X7iCfVgy8EsteWGL8l+xKyP3gq4zatH98Jfzvybi5EZJPJL4sgQyHGXG2fziNu8DPkgik8y4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 07:17:17AM +0000, Josh Law wrote:
> 12 Mar 2026 23:22:48 Pedro Falcato <pfalcato@suse.de>:
> 
> > On Thu, Mar 12, 2026 at 01:45:31PM -0700, Andrew Morton wrote:
> >> On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wrote:
> >>
> >>> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
> >>> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
> >>> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
> >>
> >> This is such a glaring bug that I wonder if we're missing something.
> >
> > According to my local copy of lib/maple_tree.c:
> >
> > mas_pop_node() - Get a previously allocated maple node from the maple state.
> >
> > Note the "previously" :) kmem_cache_alloc_from_sheaf() can only fail if you
> > run out of objects in the sheaf.
> >
> > So yeah, this "bug" looks bogus.
> >
> > --
> > Pedro
> 
> Hi Pedro,
> 
> I see the comment regarding 'previously allocated' nodes. However,
> mas_pop_node() explicitly calls kmem_cache_alloc_from_sheaf() with
> GFP_NOWAIT. If there is any path—even an unexpected one—where the
> sheaf is exhausted or the allocator fails, the code immediately
> performs a memset on the NULL pointer.

And? This does not happen, simply. If it does, your maple tree is hosed
and, really, you're not recovering from it.

> 
> Even if this is a 'should never happen' scenario, returning NULL is
> safer than a kernel panic. As Andrew noted, the current structure
> allows a fall-through directly into a dereference. My patch ensures
> we handle that edge case safely.

... and now because none of the mas_pop_node() callers ever checks for NULL
(why would they, they preallocated those same nodes before), you safely
dereference NULL away from mas_pop_node!.

-- 
Pedro

