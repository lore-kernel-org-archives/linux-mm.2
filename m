Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49149E9A04A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71AA16B0005; Thu, 19 Feb 2026 10:33:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C81F6B0089; Thu, 19 Feb 2026 10:33:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA0E6B008A; Thu, 19 Feb 2026 10:33:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43A836B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:33:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D58DA13B599
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:33:53 +0000 (UTC)
X-FDA: 84461601546.20.553AA29
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 95EC820003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:33:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hfct1RPL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZJC2xBTo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hfct1RPL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZJC2xBTo;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771515232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Pr6hzDfB9/6RakOY0WipAvXywzaZBCmQLvgfA2H3Ok=;
	b=U/+NEHiMbczqAR8iJ7BqWa5VRCrbOhRdCuRT32VrIAxc7hrlvAahC7ccdbAGzSpjfHkdxs
	8kuykugckNimaIzg4cp5X4ZudZnNeKW7XrSCmL3YUjiBna9dzJhk5UnkP09zBH4ttkMdeL
	k0LJDg/i7OWlIXXlHrtW92OHvp54vFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771515232; a=rsa-sha256;
	cv=none;
	b=fDoJ34hXcj+i/TJxBdcCYYFzL3GDvbBe1TDYaB0xC1m7OfwWh1NDC2WU2Wn9d08rGa67AO
	ul1npM2ws1K+BDIRDcIL8/FAcL96zgy8yb6jTZpEQOz8/s1t6sdwIfEMAb0k06bth4IZH7
	rpzvptBQd87UbTiMqRKUUEsDeYcJdOI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hfct1RPL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZJC2xBTo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hfct1RPL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZJC2xBTo;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1C9AB5BCEC;
	Thu, 19 Feb 2026 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771515230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Pr6hzDfB9/6RakOY0WipAvXywzaZBCmQLvgfA2H3Ok=;
	b=hfct1RPLAdA6Jtqial8iBYAB2+hq7s9YOwXi9sBGInGrrwywZ+YX5UHSjnbRTZu190xzmW
	PVUB0socdGxmjozLa/JnLaR5Yxcl5PEzsCq6GydPGzaVbLpVq0+jAT+9eFxkbsHVUAl+Sp
	0N/Kqlp6ypMiqGH+tH/CGej8s5yWEj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771515230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Pr6hzDfB9/6RakOY0WipAvXywzaZBCmQLvgfA2H3Ok=;
	b=ZJC2xBTomatk0dDF6oezPEmOIEOF5cCrd6gssAQLsC7vfwScvjWRVN7z+g7ACTNVWFODRP
	Ix/Qoh9s1kkZZJCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771515230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Pr6hzDfB9/6RakOY0WipAvXywzaZBCmQLvgfA2H3Ok=;
	b=hfct1RPLAdA6Jtqial8iBYAB2+hq7s9YOwXi9sBGInGrrwywZ+YX5UHSjnbRTZu190xzmW
	PVUB0socdGxmjozLa/JnLaR5Yxcl5PEzsCq6GydPGzaVbLpVq0+jAT+9eFxkbsHVUAl+Sp
	0N/Kqlp6ypMiqGH+tH/CGej8s5yWEj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771515230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Pr6hzDfB9/6RakOY0WipAvXywzaZBCmQLvgfA2H3Ok=;
	b=ZJC2xBTomatk0dDF6oezPEmOIEOF5cCrd6gssAQLsC7vfwScvjWRVN7z+g7ACTNVWFODRP
	Ix/Qoh9s1kkZZJCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB1833EA65;
	Thu, 19 Feb 2026 15:33:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GwQXNlwtl2m2OgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Feb 2026 15:33:48 +0000
Date: Thu, 19 Feb 2026 15:33:47 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <l5lnb7fvqk2fndlvejibcrxru7i5xwdchl2hcnlk6dzttdfkyc@vtuqkied3mtt>
References: <aZcmlIF4bmG0twkp@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
X-Rspamd-Queue-Id: 95EC820003
X-Stat-Signature: fe8aacnsqqdigaussiezxeg18s6jhzxa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771515231-159924
X-HE-Meta: U2FsdGVkX1+kH30L+BLO6U+P28fVhxzJeil2tHHTLnEpiIl/vIKnbFPzOmInfW25Nl/g6iG4cP7OWP8w2x2gCeUeTSSD19NVj8pFgj8DKFXbBXPtQI6aDNqCEfJ18XFmGRUxIdwnQLib7LAFFSdIeZRBRL2Ro8PgmaV64D1ERMW/wLAkX56FkZllqkkoqfU4aCCMX2ocKFtIXdhV4NOkUPpZM+IenjMh3zJidiHvYwIYO+iDINoOT2uT7R7lWGROtkPiurioO+CLmjqgb5/Ob1q+dGxfW9v1+3TxZORHSicLu8ZazqSHT0G/+FYj8fIsnMiir3MM5E9J/Vxi/2Cg67+xjGLoYHddGYoYnQYFVAFQGMVcAYfGlprd4rCdIa+AN/UcuXXwC0nwoPnklACmwdH31Db62BxC1C/LBMqD9rW7B0crV6qG1jQQDm8Zor/+6E5v2CHEUii59vrZVK1byMAUx3rBkmiF7wPjcEBqlifYWTwXGAFFqbwg2SeeactgfmO3xyDWjL++qnGgqhpXpEgTLTcqErxCpNH25QukX7rf9QVhVgNThAYS9HOUX+NPIIxe+P0qHlkcMOayGXzJ1YgOTK/kTORf8/H+sNclLOEPEXYFKpisP9ZAso0D+5H9GriSKj1d3l1Z6NZUExiyYVZxCSOXAJcftFywSdNltqUoY7Qvrk31DZxZSqfOUpgzcMTeILfnt84bMMR4hc8jF79gNiwL5QQ1SvSODkNkSNI3X0A1t8/emP4UgSYLzh9vkeB8gdux59UMaoZRd4kDxP7jvS9nhyD8Sr82bp52CjorEWZrNvpLz9WlOfYZYEZfAg2vUwFDxnfosPU+t2Pirh/CKB4FM7S2MSFtQPSx10lqx4HSo4edco+iME1vfoZjwxIag0G4nOanci0HoTYe+Cs5GLpnDePpmzT52HxUjjoSjZC9PnxNEBOW0PpF/QK6RZPsBxQ8blYgCYuzkP5
 HKq+uq4F
 63lP2gah9cXGacYxppuI+y6uf7eI7VGf51bh4Kdk3jJu0qjWBQ0Zh7q7BJMQLwL63POz4EONvMYQIQCQaU/7P6gFqoh+QfIVgWqDFDrYrfH4L1yfNWGtzROPk58QaMUqIJHKweM6qm40YOxrcWd4+C46nwnTxS1rM5XEoQZJHv3wiQKmZIYZm0l543DAuIY/vyaU+P6fYyKos3rbepM5f2rtUESy4KCcZU73BbOaHuaw2HmQrhRPryBIGEl7+A3wAWTKJWh4qPHOf/To0MGOxgwVgwGQcAtbsB41wpab372IIW8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> No, there's no new hardware (that I know of). I want to explore what page size
> means.
> 
> The kernel uses the same value - PAGE_SIZE - for two things:
> 
>   - the order-0 buddy allocation size;
> 
>   - the granularity of virtual address space mapping;
> 
> I think we can benefit from separating these two meanings and allowing
> order-0 allocations to be larger than the virtual address space covered by a
> PTE entry.
>

Doesn't this idea make less sense these days, with mTHP? Simply by toggling one
of the entries in /sys/kernel/mm/transparent_hugepage.
 
> The main motivation is scalability. Managing memory on multi-terabyte
> machines in 4k is suboptimal, to say the least.
> 
> Potential benefits of the approach (assuming 64k pages):
> 
>   - The order-0 page size cuts struct page overhead by a factor of 16. From
>     ~1.6% of RAM to ~0.1%;
> 
>   - TLB wins on machines with TLB coalescing as long as mapping is naturally
>     aligned;
> 
>   - Order-5 allocation is 2M, resulting in less pressure on the zone lock;
> 
>   - 1G pages are within possibility for the buddy allocator - order-14
>     allocation. It can open the road to 1G THPs.
> 
>   - As with THP, fewer pages - less pressure on the LRU lock;

We could perhaps add a way to enforce a min_order globally on the page cache,
as a way to address it.

There are some points there which aren't addressed by mTHP work in any way
(1G THPs for one), others which are being addressed separately (memdesc work
trying to cut down on struct page overhead).

(I also don't understand your point about order-5 allocation, AFAIK pcp will
cache up to COSTLY_ORDER (3) and PMD order, but I'm probably not seeing the
full picture)


-- 
Pedro

