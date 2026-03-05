Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91692F3094B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57DA6B008A; Thu,  5 Mar 2026 06:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05BE6B008C; Thu,  5 Mar 2026 06:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C084A6B0093; Thu,  5 Mar 2026 06:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1A956B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:48:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64ACEBB945
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:48:30 +0000 (UTC)
X-FDA: 84511836780.08.7013FB4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id DEDFF140012
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:48:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hjgFz7Hx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AtS9b0ln;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hjgFz7Hx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AtS9b0ln;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAmQS51SRv/YABdhcoSl0Rg6Xd7LyqWnZEWJM21wB9Y=;
	b=rdth60oFNBAeD1w5rQIAYBj8SkyOVL4C0rPFEjGY5QM97LS5Mg1DUNA9OU2dWw3HoA4Upk
	9ebL4bR7zzQA+ZcbdkqHJyshLhltUVs/PQHYPiW5nFk5sa29v80+96zGfO5vnpbhlqlCmt
	jqA8OCFlKbvR20tD08Nco3uz3XBhLZI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hjgFz7Hx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AtS9b0ln;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hjgFz7Hx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AtS9b0ln;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711308; a=rsa-sha256;
	cv=none;
	b=zpXAP9pbbeYothYcU7u5pjKl+LRKK1xc/qoCDObk3szwo7dYnf1zvdvVq3S4rCdKSB5Qa+
	WDl5DaW1tDJtHn3EJ7N9ZQMrbq6U7xgFgvsWyBcJZ11th3cTm8L209GF46POMlrG+e5nIF
	ekux089cU7q95IcekEWrgHzqb+lzxbU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C77B5BCD5;
	Thu,  5 Mar 2026 11:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772711306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAmQS51SRv/YABdhcoSl0Rg6Xd7LyqWnZEWJM21wB9Y=;
	b=hjgFz7Hxw7+7CG9mdNnW1Yrd1s89DNmeaO4AUTbscd5Qf0Vlcy5Ui19Jz05OnHrsY4w/wb
	JpOdPQTSJKZEK0w9TIW9b+C7kbk+FZz4U4uhQQKTz+uFjl6xZN5FA5hV3nPRU2e3FD3yeU
	uE4n9MwFexdo62/idfVcw6Lfg1+tEVg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772711306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAmQS51SRv/YABdhcoSl0Rg6Xd7LyqWnZEWJM21wB9Y=;
	b=AtS9b0lnK3ezXZiDDwleMjFII91JH2ADAxbSbbzw3lLnWs25tKxeLtXUucKZyk/pIvL2To
	hkZQnAyShLl2uIBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772711306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAmQS51SRv/YABdhcoSl0Rg6Xd7LyqWnZEWJM21wB9Y=;
	b=hjgFz7Hxw7+7CG9mdNnW1Yrd1s89DNmeaO4AUTbscd5Qf0Vlcy5Ui19Jz05OnHrsY4w/wb
	JpOdPQTSJKZEK0w9TIW9b+C7kbk+FZz4U4uhQQKTz+uFjl6xZN5FA5hV3nPRU2e3FD3yeU
	uE4n9MwFexdo62/idfVcw6Lfg1+tEVg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772711306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAmQS51SRv/YABdhcoSl0Rg6Xd7LyqWnZEWJM21wB9Y=;
	b=AtS9b0lnK3ezXZiDDwleMjFII91JH2ADAxbSbbzw3lLnWs25tKxeLtXUucKZyk/pIvL2To
	hkZQnAyShLl2uIBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20E5A3EA68;
	Thu,  5 Mar 2026 11:48:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xsICCIptqWm7RQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 11:48:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C526DA0A8D; Thu,  5 Mar 2026 12:48:21 +0100 (CET)
Date: Thu, 5 Mar 2026 12:48:21 +0100
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	lsf-pc@lists.linux-foundation.org, Mateusz Guzik <mjguzik@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Gabriel Krisman Bertazi <krisman@suse.de>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dennis Zhou <dennis@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Hao Li <hao.li@linux.dev>, 
	Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM/BPF TOPIC] Ways to mitigate limitations of percpu memory
 allocator
Message-ID: <z7bjxfk7jah6zgyikhiz6eqxd3xwywxp745bykcr3sm3p525yi@4diwkjsoyckl>
References: <aaE8rkGzxlB6wCTt@hyeyoo>
 <ji4ddtoo7mebygmytprcp5kpnu5y2ddthk5zhacshods37xij2@fs2sizuagdvz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ji4ddtoo7mebygmytprcp5kpnu5y2ddthk5zhacshods37xij2@fs2sizuagdvz>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DEDFF140012
X-Stat-Signature: ktis5zri913wjc5fdrw3mwzzrpio7x5u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772711307-713906
X-HE-Meta: U2FsdGVkX1+vAc3UqWpYDtes2q9kVdEWAM1HbEJwXXnkbuxpgzQl8kgH9CSyOWg5GT5te39RHxFA3pxj+WWalmXoVfkiAImtVxUG/A8ix3QVYDnLvaI5U1R6k6a4E/ctC1y7Q1uD0p/6Xe4F8J3+N2JQbwC2qxz6ratEVg9IR3mo3Z4mqQtQYE4828rUfW99Q9tudgXW0i/0RmYh4rPVsTyouPjX/y3us26u84O5hHtVaj5RNCz6W9CDd5aCUqyC9yO+kIHw67AjqRK+Io9uZO1ZhroMF86PdJNJX6rqMt7s93/IFUOrh4nRROC17o2YEoQ3xSTLCp6IKxMK48vNi0LWCI3F8uLQZu1cUW/z2xCAD0psIn4vsNjNY/JeOPxHD+dI64uiNewcMA8ATkaj/1gSWTLr4wg5LdMO459+ijNP2pK2kZ1vSIbTruVjBMMq5pCJscyjVBesibfZl82s7NGP4vkArvnuzs9IKmTWNZzMBXKkmWrqUhx4vUGehi6Pkr0z8GaQcOEHu3Zd1Sdf/alTacEVj9wFTvrQaQzenFwQrUdnca6G0953IA+qMAGulU2sOA3MPz5G0RWwAO6LAyXqdjNxH+4bgbW2OSslOyGJXNw+FdG1xbsfbznLoeWDoeoKlOcf0cueBiEROAmLRjiy/tiW0pUJesrfxHGIu/4f/2Y1XLnu8zKyarZZ7IbN51fGNuC1G6fKlACPI2rs9G6ydbsO/xfaQdtwQnskkHZ9liv5lZ4HR18Hqe53wyjPRq7OhyEkjyqx5SgKPdzNSsDs7oJoOKZmCN9oSEA8ZVvzcb/F5jbL3QitD+uiuyaN1LEtFMc6C6X1O9mCIsgzAVGu7xtcW6ieVu3MVa8penEo7S8feeche/IlG+CizVlfbLvfwulWkF8oisgyjYsOCxGrxuYPvlbgU5hNeTHHJ5aJRrYeZAsOpaVOc0YIBf7NDG6Y1IZqypAZA0RYgTz
 SujDQ0Je
 WywqFUpK5O/BZ5OOBY4OKHEGef6+537UDXs2A3PQJXfVOSjpv2a2R/Nc8p1H+cSkpGt1mXZzTdxPSEUR8/NRLyp8MpnKUOf6GIhttBkvixoSjTz5LjFBngxvdoghh5K/ayK5d8rlvWBiTzs+N7u8sFg7BVDcsyXkyvLZvcahBMEy+An4unWPJ/cXX+h+gMSttGCDOPvqNVlR8gC64zU+AOxyqinfdFmOH5vALyzyrGjOXDyO/QzJD66cO1MjvI+zNvleJik6uDo9hlTP/FoCOngLH3+DIiMgutEPdbqBofufVsS3rRt+8U0Rjs9UAAYV3p6Wvnxbp5yKyD4DrSHLGD+2AQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 05-03-26 11:33:21, Pedro Falcato wrote:
> On Fri, Feb 27, 2026 at 03:41:50PM +0900, Harry Yoo wrote:
> > Hi folks, I'd like to discuss ways to mitigate limitations of
> > percpu memory allocator. 
> > 
> > While the percpu memory allocator has served its role well,
> > it has a few problems: 1) its global lock contention, and
> > 2) lack of features to avoid high initialization cost of percpu memory.
> > 
> > Global lock contention
> > =======================
> > 
> > Percpu allocator has a global lock when allocating or freeing memory.
> > Of course, caching percpu memory is not always worth it, because
> > it would meaningfully increase memory usage.
> > 
> > However, some users (e.g., fork+exec, tc filter) suffer from
> > the lock contention when many CPUs allocate / free percpu memory
> > concurrently.
> > 
> > That said, we need a way to cache percpu memory per cpu, in a selective
> > way. As an opt-in approach, Mateusz Guzik proposed [1] keeping percpu
> > memory in slab objects and letting slab cache them per cpu,
> > with slab ctor+dtor pair: allocate percpu memory and
> > associate it with slab object in constructor, and free it when
> > deallocating slabs (with resurrecting slab destructor feature).
> > 
> > This only works when percpu memory is associated with slab objects.
> > I would like to hear if anybody thinks it's still worth redesigning
> > percpu memory allocator for better scalability.
> 
> I think this (make alloc_percpu actually scale) is the obvious suggestion.
> Everything else is just papering over the cracks.

I disagree. There are two separate (although related) issues that need
solving. One issue is certainly scalability of the percpu allocator.
Another issue (which is also visible in singlethreaded workloads) is that
a percpu counter creation has a rather large cost even if the allocator is
totally uncontended - this is because of the initialization (and final
summarization) cost. And this is very visible e.g. in the fork() intensive
loads such as shell scripts where we currently allocate several percpu
arrays for each fork() and significant part of the fork() cost is currently
the initialization of percpu arrays on larger machines. Reducing this
overhead is a separate goal.

> > Slab constructor + destructor Pair
> > ----------------------------------
> > 
> > Percpu allocator doesn't distinguish types of objects
> > unlike slab and it doesn't support constructors that could avoid
> > re-initializing them on every allocation.
> > One solution to this is using slab ctor+dtor pair; as long as a certain
> > state is preserved on free (e.g. sum of percpu counter is zero),
> > initialization needs to be done only once on construction.
> 
> As I said way back when, making an object permanently accessible 
> a-la TYPESAFE_BY_RCU) is screwey and messes with the object lifetime
> too much. Not to mention the locking problems that we discussed back-and-forth.

Yeah, I was not enthusiastic about this solution either.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

