Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56F5EA812A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8446B0092; Tue, 10 Feb 2026 10:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E763F6B0093; Tue, 10 Feb 2026 10:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23E06B0095; Tue, 10 Feb 2026 10:09:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEC116B0092
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:09:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FD7B59587
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:09:32 +0000 (UTC)
X-FDA: 84428880984.18.1C75344
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id C2D22180005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:09:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1C7xlhQK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8gQWVEsV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jIHa2c9+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9ThbakaP;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770736170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dh/SkB6K+2F6srPauh4mzBXd5IUTSjCSGGF/slSWQO8=;
	b=1Za+qPFDK4RyCktt/X9YeFDcgi2CvhgmzxkZORApTpTbkqdIgvuWcvY804XTAzDoI0BYYq
	jVbwN+Jcq2OgBWmwaTZqzWfc0KvcMq3+SqiIuQSE0Lsd/JcGRLmmz5+ayGgBpwk+O2OQdR
	9+rmrer1sMKv4XoI6DCZ6MRqlWw6p0Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1C7xlhQK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8gQWVEsV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jIHa2c9+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9ThbakaP;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770736170; a=rsa-sha256;
	cv=none;
	b=qKDkfClaOA8KNxH6Bviy4ExMOxGu1C+hwAsjNSsNY8ZFCWE3zdXM+AsMKUNZQT/bXQgNw0
	R+AECzpc2TPTsiAEe7af+vXNM2UKNdBGPHydlNo3eTotK8Gio6y8qRt+RewR/94q01i3wM
	pPSm0v1kK2Bg/gMCxBFJiPqLwC6ZaU4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E6FAC5BD75;
	Tue, 10 Feb 2026 15:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770736168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Dh/SkB6K+2F6srPauh4mzBXd5IUTSjCSGGF/slSWQO8=;
	b=1C7xlhQK6LohxRpvNywcw8gE77M1jyRys2bHce7NrDNXCb08rHB/mEHWcPy15l6BhwqNQx
	5LmqgG2+PAn7oFRn5fynGRBSWuriizPYNwQe6rc+H124mNyUBohP4Ovg9vzvPfn4vl0CQq
	3RhpFOkCYk9FGHHgVz+6bx04nvsWDmI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770736168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Dh/SkB6K+2F6srPauh4mzBXd5IUTSjCSGGF/slSWQO8=;
	b=8gQWVEsV77R6VsoiZXh6XfL+xssusdyPR734YfRprWyOtJ2LIs3xxoFqVrVJhnmkXB+6r8
	DYfLfE6B5CnGFZCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770736167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Dh/SkB6K+2F6srPauh4mzBXd5IUTSjCSGGF/slSWQO8=;
	b=jIHa2c9+Rbpq2/5b7bTpTgYOHWQyAp1T3q8iP30ud3H0LyooOK4/n77GqZG9YHLhglrS/f
	cmamPqsc8l8OA9wRS6EOKww+kpTmB5XaaedR8VTfN46zuAogaNO725PFXQbZrl3wt3EQit
	XE3rZHtA3QPOsL5jL3UxwOMwWDJnjpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770736167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Dh/SkB6K+2F6srPauh4mzBXd5IUTSjCSGGF/slSWQO8=;
	b=9ThbakaP/bfyin/ui2dskjnvAKBvQwwuwg/gHbKvXwvdhSuqO42OfHX5I4ZR+ngSDmyJSv
	npBYorJfD9GStLCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA2743EA62;
	Tue, 10 Feb 2026 15:09:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lgjHJydKi2kHCQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 15:09:27 +0000
Message-ID: <763984ad-1fd3-4264-8f11-509d6e1eeb0b@suse.cz>
Date: Tue, 10 Feb 2026 16:09:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 03/17] mm: Rename the 'compound_head' field in the
 'struct page' to 'compound_info'
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-4-kas@kernel.org>
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
In-Reply-To: <20260202155634.650837-4-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: pfyramf5gnurhgn3pz8wxmx1r78fos97
X-Rspamd-Queue-Id: C2D22180005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770736169-65493
X-HE-Meta: U2FsdGVkX1+aYURr45nWkzGhJpzNKJOdAdK17MYzMR7v30k/RTZqib4K+cbae//nauNY8wPXMSGF9X8QXLsZvKr2qUlOq+suIIVXGRgV9p/Rm5v9F4XsjkerYQZy0CUUjHC025NLkPC0Qhg4pgvDSEhQi+NjB+YmKHyyVfOifh5LjRiFh6ZgTQSvFhzfDxZJ9wFE2N13QSk+sy+z0IQ1kuiRQqUAGlIwJh1kpzoNIrtypgPQjQQ++vsTo2GztIaCKi74gwEUdCfH75A3uOoZw7kxLVxmBJJ9aCEbcnHJEZCYZXWqYUCAQ/Bh9iYogugUG/cTNIM6VgjVuyy59SzYF4BtDxABVT1dxc0bfWxaL6fKJkgWECid2+ImM8rLEehNlR+kGPtOJmDCE+Kc7A2jfO2Kb2+CDpbtmw9seozFxPhNr4moOMEzFQMxo+5diI29txFpE0gpWeMfIRsp23zazo5f5BeBH3bk6qhE3YiQMRmjKqQnWrQZcPg/PomiScOPd1/AzhZ7FliBOJckyzQFCQRAv+DUBqUp8AxiwAlyv1i4PTID4Gbtsr7F4vbyUhtlMQtOUKihJAhbqK9y8ygya/0ybeEEy/P71W0RJCbgTVOWv16MF9N8fJkMWtpOm1xSrqo/ZrcW79IFuYRm7yz+4vCKG1B3Lnhqz5ZfdsO4YeM9SOcvezoBfK+W4v2mO9HqG56WDs++CRX4pGch90fzdKwPSKWEuTyQ9q7R/xsNDJbtDHXR3zpaOAeApf9p8Q6PIB/DErbygyUAe+LgB9QCW8CToofn/jO+381OChNicAmFYLFwhUu1qGXx6B0SCWM4n4FPxDrzN5rBL7KRqTKKT7/aHxy84CfmZAY3b9WS219Ej8ZZLPnmGwV80SsyJevBDNNxTiiBFC1UfQCjZeM9nRlanBVvGWi2bpO1YQhWz/x2tE3PjoQzjMoERNYHKrbz28ygrg21b2gAlNzxrUy
 F4lP8DH1
 GDRP8T6e3+szApDPHGgOYfzINWJommi/c6JRROmGfkF5nSMrqmVBPN8eGLe5TbOa2dc5ioSHGJEk9sfe1PZefRxc5bvpqoCPgTsYil69QtPj1N57CD1qFNCO5TvynDLgaLjD7YJKJ1WVd2eYS+SY3w0ysj4mtaN/m99VhfeB1mi1GfBvumCIXFtAoOo5CCnh7s3Q+jZCZk+m3IQWUfPANvk+eYWAe3ZA/s+UQKtxkqAP3CSjY+BEbXRFbTpjvpzwPuLfrPcLc687AX9SRlJqoLcQkULO+vrPKgkpl86qwrnzqcxkGwJQosv0mLW6tN7IZeGRb9a0n2w56DG0uu/4QOljxJT6n7x1VMvYwXlI2Eb7MngHmlvioE/MPXqhP7834eB6b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> The 'compound_head' field in the 'struct page' encodes whether the page
> is a tail and where to locate the head page. Bit 0 is set if the page is
> a tail, and the remaining bits in the field point to the head page.
> 
> As preparation for changing how the field encodes information about the
> head page, rename the field to 'compound_info'.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


