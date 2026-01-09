Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39EADD26D6F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26C86B008A; Fri,  9 Jan 2026 12:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB396B0092; Fri,  9 Jan 2026 12:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFE86B0093; Fri,  9 Jan 2026 12:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 799186B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:32:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32440140142
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:32:11 +0000 (UTC)
X-FDA: 84313118862.23.F881A4C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id DA43618000E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:32:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0paO9x2M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EoaAnKnY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0paO9x2M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EoaAnKnY;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zCq2OTfcTJVPbD8p+G8IRGuj0yyLL6oHSOSXWHKJZY=;
	b=JKLVOTaKSh3UNS+1rsohpUjfZeGqxVm4LPDaVlqW5CL6EkzqFhODQw6TSoQoXcgVAZtHZB
	qFr8KCK9OW4fRBenXW0a7szfV3KI+Xx5DbbM5EiTMKTwscyTvP4on0SRgMnZA1G98J7Po4
	ojATy7p3ukgtw307J0L+hRXK5imD1cw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0paO9x2M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EoaAnKnY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0paO9x2M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EoaAnKnY;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767979929; a=rsa-sha256;
	cv=none;
	b=pmB3Ya8jhoab0z2S3JU7XbQp7D/NbzD5l56WHs81ZuaATA8g1NxPh/VH8MwyCoVijyCfGh
	l6DtKghiRUFOXGLNraEMVtK9uxyQef5rQZcyZAkBFMWFaLxPwT3+ALa/7uihU8LflS4OW/
	9ETpPFS5S+NY/ZEmr9I4NV8GPIWwQGE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3CE7F5C00A;
	Fri,  9 Jan 2026 17:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767979927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5zCq2OTfcTJVPbD8p+G8IRGuj0yyLL6oHSOSXWHKJZY=;
	b=0paO9x2MbfTZQKPT0KM7RFiiVikh8DHnNFafVHAGjNCOMY6pyPNHGe0sd8SanalbaT+ox3
	bWq0iQKF0gDQsWBseLE/eJzfEdFyhL2vuDzUQ49jMN9RlYOdg6ZTdqP6Cif9VI0x5nxu3J
	oxhGC5SIo6h0jiZUEfFK0/nRh0UCKUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767979927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5zCq2OTfcTJVPbD8p+G8IRGuj0yyLL6oHSOSXWHKJZY=;
	b=EoaAnKnYjQjbkHVAssXPlT6tDOy6kI5QvUZwl6ptoj1GjC3IeD6ysF7bd2fvVnTQzZBpa4
	rIFA/O5TvVuZarDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767979927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5zCq2OTfcTJVPbD8p+G8IRGuj0yyLL6oHSOSXWHKJZY=;
	b=0paO9x2MbfTZQKPT0KM7RFiiVikh8DHnNFafVHAGjNCOMY6pyPNHGe0sd8SanalbaT+ox3
	bWq0iQKF0gDQsWBseLE/eJzfEdFyhL2vuDzUQ49jMN9RlYOdg6ZTdqP6Cif9VI0x5nxu3J
	oxhGC5SIo6h0jiZUEfFK0/nRh0UCKUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767979927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5zCq2OTfcTJVPbD8p+G8IRGuj0yyLL6oHSOSXWHKJZY=;
	b=EoaAnKnYjQjbkHVAssXPlT6tDOy6kI5QvUZwl6ptoj1GjC3IeD6ysF7bd2fvVnTQzZBpa4
	rIFA/O5TvVuZarDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EEC183EA63;
	Fri,  9 Jan 2026 17:32:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n33YOZY7YWm4YQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 09 Jan 2026 17:32:06 +0000
Message-ID: <a144cd1e-8bfc-4380-8f1b-071db0af0b2c@suse.cz>
Date: Fri, 9 Jan 2026 18:32:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] slab: Introduce kmalloc_obj() and family
Content-Language: en-US
To: Kees Cook <kees@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Jann Horn <jannh@google.com>, Przemek Kitszel
 <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
 Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, John Hubbard <jhubbard@nvidia.com>,
 Joe Perches <joe@perches.com>, Vegard Nossum <vegard.nossum@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
 Yafang Shao <laoar.shao@gmail.com>, Tony Ambardar <tony.ambardar@gmail.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-doc@vger.kernel.org, llvm@lists.linux.dev
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-1-kees@kernel.org>
 <960729bb-0746-4709-a40c-2e254f963deb@suse.cz>
 <202601090928.5CFF95F@keescook>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <202601090928.5CFF95F@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DA43618000E
X-Stat-Signature: 4wtxehhza7efy9ndjwee6qyhabhjoqwx
X-HE-Tag: 1767979928-713482
X-HE-Meta: U2FsdGVkX19GI58+1XX7xmsJX3QDdBB8DjJ3Pn3d4Z8GfG+E1xLGQMy7KWUhfN12WQDW+iKbTi1HqHUuLz5c/+uhNqI18GgsmRZdRJm4tN1OKgWeOKU0pXZ0S4IztXjTXM1TmkD6xWcYOHKdI3e5/wIiyp82ZTtNIur3RB6ejGh+mayLzQFFKeL761kk8iNAS/DA4slkYK3avGvOa4TIaJkIG2Cz8NzVCXUvMTMAorh0R/x+i7bwrFw495XzmVRCTsbXexXYYr/Ybo8Ym2CJGJNKkxDF/oHWFrEolP8QqRdrBoRJT1TNGO3haPSgI5YYtcHhzAPQ4zc2nqTyZ2/6IjdQmkSQwMygfrSlBQmsPPNCGT2VXOiz5CIePlMQl7z8IhattoSOt/alc2wB959oTxZlnLZYOk9l7ebHRZN8ylCZaljb0eWgQtzZ/FCdE4sinqri/wVqm8dPfGRUYLWuyICn7LLI++0RbSi36d9ue3wqUCvMSyRUBHrDJBZkxCVEJIVhYtcQzbTWYyqJeqskWLnlprvMEUFvBic7dJZxE/ZfT808QtupnDHUNDs2+qMGhE5KGMg02geK27GjVx+86hntLNMqUCWJU86i1R8+sr5XLtvVmQ4WiwKkkatY8fqbu0ZzessBLDn7wV4aDtLiHoD6oc1YW8yqWuPWO7Jx/oZfPmq18E8PoXvwCwxl5134dGe47f6T6yKoq7WMB8x67vgckaIOVUsjBl6QRNETryn+zJeY0QZSTXB1Qqz+UaLV4Y7D6beA6vMd7vuQJy+aZuHhwWrNZjzij/JiYHmPQ3/FC292reJw6XYW7ndqgtj3Id7nv86dD47dwAoqOrLYdj1IIh9IrxKhBKIi33zjxrpqFYJYDE9uS6q6hLPb6Ww0BS1YYquKqjFmI69ucm96tut8s4WCeIzOaXi1fDI1FR16Ac20bekg29xr+b1T9GefGF3M2IdJcVw41qHr7nD
 YBKs7ywS
 K68foK/6gt+cZq7hvnJz/EbDRbLWIQdaXl/GW7rH5K4WtkVqkUfqA6B3GqEKWGKDQOUu2Qw/kom/T5F18y86LWLzAo0NBeP6cGjuglUTcKX/qux+lfUHksRFpC/6miB4Vprr/cQlE5e61MOpS5EE7Kj0wCp/1Bau/FuhyRUXgR96TmxQrnZpGaqF3ajETYQ9PGUs+Sg5pBBjziHzzFU3hpAMdd8Ic85NpUN8QVcGTE8M1CWu0Ai9n0aLKsGxIBwPb+3VLcg/nXwniBS2OPz8b149luLG2WHZfA6XuH8n5ul2GfluJt4OAY8zLiXWOjMgu4tn8DMNWfkhRc7c/XIUVj7kLGU6/UuA3hb12omyU+Nd7Xt8qkqTkGF2biIf+Nt9nKPDZvqQxBP6uVWVtZZa92X829JqtaPBH60ra
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/9/26 18:31, Kees Cook wrote:
> On Thu, Jan 08, 2026 at 03:01:00PM +0100, Vlastimil Babka wrote:
>> On 12/4/25 00:30, Kees Cook wrote:
>> > [...]
>> > +/**
>> > + * __alloc_objs - Allocate objects of a given type using
>> > + * @KMALLOC: which size-based kmalloc wrapper to allocate with.
>> > + * @GFP: GFP flags for the allocation.
>> > + * @TYPE: type to allocate space for.
>> > + * @COUNT: how many @TYPE objects to allocate.
>> > + *
>> > + * Returns: Newly allocated pointer to (first) @TYPE of @COUNT-many
>> > + * allocated @TYPE objects, or NULL on failure.
>> > + */
>> > +#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
>> > +({									\
>> > +	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
>> 
>> I assume with the hardcoded 1 for COUNT, this size_mul() will be eliminated
>> by the compiler and not add unnecessary runtime overhead? Otherwise we
>> should have two core #define variants.
> 
> You're correct: the compiler completely collapses it with 0 runtime
> overhead; a variant is not needed.
> 
>> I also noted that the existing kmalloc_array() and kvmalloc_array() do
>> check_mul_overflow() and return NULL silently on overflow. This AFAIU will
>> make SIZE_MAX passed to the underlying kmalloc/kvmalloc and thus will cause
>> a warning. That's IMHO a good thing.
> 
> Right -- I prefer seeing the SIZE_MAX yelling from the allocator. Should
> we change how k*malloc_array() behaves?

Yeah it should best behave the same I think.

> -Kees
> 


