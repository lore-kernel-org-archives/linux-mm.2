Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD095EA8126
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEF06B0005; Tue, 10 Feb 2026 10:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BDD6B0089; Tue, 10 Feb 2026 10:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AFB6B008A; Tue, 10 Feb 2026 10:01:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07B746B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:01:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2C7D1C596
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:01:40 +0000 (UTC)
X-FDA: 84428861160.21.2AE9E2C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id D521740028
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:01:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XC/9NCnQ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lmci/dhU";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fk8FRDvX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kPnQW0Ly;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770735698; a=rsa-sha256;
	cv=none;
	b=FV7QDrBYj7Wd6uAjdTpq9VwBhdDejaDkRQZ7/3Qsz+W4WxQcmFeFV7IS/YV7g5VDYFsrjH
	mgQIxrBWNGXe7k63/QhI397B2gDJ9GOK4uLZyDgxngXenxyDzvMIyNzn4zrU4cz/6rOHxU
	a3dXENkDlANRqhFNBjAkSXXpF5kxVj0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XC/9NCnQ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lmci/dhU";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fk8FRDvX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kPnQW0Ly;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770735698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enWOYPPHiCLyhXlcbo5nS1X+LVkknsIs3XIgzsK/0vk=;
	b=D/YavxlSQHS4kVIbbA3OXILxRBg8OxbKLQS+jY7FN4wT5WqVo7l1CTjzV2ta1tZu40gm1q
	NHJs33ubdLGRq0IcLc1FSbxUVSAhT0TQIsSkwkO13xPEN6jYBy0icmXhQWqAEvCuLvghcl
	4ffVyG8zRVabLRRZQXYmqHWdJjvf3YM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1BD353E6FE;
	Tue, 10 Feb 2026 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770735691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=enWOYPPHiCLyhXlcbo5nS1X+LVkknsIs3XIgzsK/0vk=;
	b=XC/9NCnQwhNaJYiExqY3UTcMKUdUnF43Sm7do0sPq+Ot4E4axbBll9UN+GszP4NFShF4Yk
	U82v+6rkikz5BqMcHb88G9bRnT/zwTVCcMkSzlSM8iBaqOwnKQNJlcdQyBSZ0lDeHRk2RD
	ZUqhaTgXU0jh8OOb8GARx/1ObdH7gr0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770735691;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=enWOYPPHiCLyhXlcbo5nS1X+LVkknsIs3XIgzsK/0vk=;
	b=lmci/dhUu1V70MmFsaLXKy1fNv9YG+4jc7fBEc6RjW7deQc2JcK7EbpGHopB+FIcuut1kw
	+N5rpYWYELS4wJAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770735686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=enWOYPPHiCLyhXlcbo5nS1X+LVkknsIs3XIgzsK/0vk=;
	b=fk8FRDvXAmxhZ+l1vQXrDiQFpuC69QUTi3NUMtuVWxbxy/L/BVv0kNY3p3aGsEf6QChMi6
	+B7vPAgZKuJWzRU41wp0iUt3htUpwWLnYhdqohVmI4/XaUv8Cd09fmJ79t4T61WXjTpmG9
	xogXzwOTTSnPpeV1f7ful5khrTSVmBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770735686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=enWOYPPHiCLyhXlcbo5nS1X+LVkknsIs3XIgzsK/0vk=;
	b=kPnQW0LyTLA+3pdCtjNPh3D0S8Dqw4DIsERQAKj+Osm3r3pc+Yy0EHGuupSI9SB/zTBLxt
	p2sbPWkWlK4eOQBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D1E1B3EA62;
	Tue, 10 Feb 2026 15:01:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CY/vMkVIi2klCQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 15:01:25 +0000
Message-ID: <ae2be3d3-57a2-44ed-9a3d-c7de2ea79970@suse.cz>
Date: Tue, 10 Feb 2026 16:01:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 01/17] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
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
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-2-kas@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260202155634.650837-2-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D521740028
X-Stat-Signature: g3j3whe8qqjrhz5rasajyb99qgnwaydq
X-HE-Tag: 1770735697-96987
X-HE-Meta: U2FsdGVkX1/u0Ss6XeKSraPlgjvb+ErdmytoeLQM32QtTIFw1e2jYGn91P9ZQv2y9uhNyRMA9s+kzGC7i675NjudgMF7bMEAauP4OUF272Wm5bUV1eEZVvpj22nxNR6cGKSCP+TdIeQpjQFtRjf5msqjLrTOfQoaq9P2V3NaSAD8IHsFRwQPL/Un/qKhwRa6zbE13HWiSeeaDka5sjHHcsi9cKGxbOo+4mSzoxBX8ixHg0SjXrqwLiEGXv2qoiRyMFaJ9+i8u5CUxB2P9lcNGPNUEfcTmKMNSbWIovXf8kcG5Wc+BUFjPoCqA/zl7DK4Qzs/G0VzkCFJVTESY/40EnWKXvHfw/owdQ/0Gjpo43DqUmYKb0E3lBwgK49UT4WSnPipZImmqUDO43URvwaD4vljdsBA7wOlkFSRHe1iuDJNIMU8X0m7IBLpMkA13DjwxUE4iIoJcHwR1KthHGwExhZ8JhOXhWY8MiHS47y76fXUTMV7qIdabDPb8G7mxj9jkI6T8igDGQHgYfmzyIVpoQym3cuxGiO26UisRXs4kOb6EM8/wD1NEYdN5UOoZ9qyNfz2QjzISBjzpK7OV05wBgJi2kqRIPWk89P472BoXA37fdQk1je8RxofLPN/KgE79Kah4tfHgkhRk2QSdtCsaBJax+4KSYjQoft2oWoCKxMr5Aemweriu+wNvr2i4T/h2WG255UTvqLZUNCqMLf/V+4FQw9dM1I0d2xutPp6RV1Br2pWoAVjSv1gAMT/qHKnjyo/DHEfKrtlC9B1FyarzaQZNf3mPFLSS004kTdUgFDjGbQ5nIXcCKn+ZLXiuyU5lIfFHhMXplrMeRJimDPOD3eGR4D33PuSJH1XsZAGkW1gqkQZ7X1kWE7qMXRX/a70YjDyQhmUZjw66yZqd2nVcgRNvjUq1da5X+boMR+dAVCz8q1srPy0B18JLW3GM1cLOBNd1sRpk5wkaMilLHO
 dbbaKAnm
 5Qf5FZ4vwjBeZHBkH3DrnkYQS13JcxEL4t9P3FcYBfGUiDImlXH7aZ+Qgrj48H+pA/8fiFKu8cRN+IZyYugWpg7hpOHo9n92dDqmwIrMZOlUfB6sm7UHz0UaCnuHlN0QoD2KTL7xaxAvOsdSjPv+/SvO0F9jzoTbAh/5LczjAKo3dMP/dyAOaGsWsSxO6v14aJ2h9nNMFfEP8G3/DzyGLOU9O67HZybxQDiS0PyH7Yhkh/nlfSQzOeTUgO5kO8Vx2o0s8YtZRdeRg6Whx9et+OwxHsCGkRw0ztktOn7CIhdG6VVyqHb7FEJ9fJCpZK5C5KlmJlUH4Tks4G3iree2YubpPfWED7jA0WCA4sEHVLNvDSWAaoCJfWom2IGmaFDKDTEwi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.
> 
> This is preparation for adding the vmemmap_tails array to struct
> pglist_data, which requires MAX_FOLIO_ORDER to be available in mmzone.h.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


