Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE8FEA813E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053476B0005; Tue, 10 Feb 2026 10:58:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000E76B0089; Tue, 10 Feb 2026 10:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFAAD6B008A; Tue, 10 Feb 2026 10:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE63C6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:58:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 905F3160615
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:58:00 +0000 (UTC)
X-FDA: 84429003120.25.00CDFF8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16A89180013
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:57:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t3ljFgC/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqn0XRPj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t3ljFgC/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqn0XRPj;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770739078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9/lO/qqaMMm4Dq73M8QNgl6Zi3LDNpEhWBh2+zdw1g=;
	b=QYpJbqowQGyIgCBI2mOgAPt7xuRbPuzWZpBTFwbTe4okNc7CrmQ57V8nDVdT81KYGR1jQw
	aot7e2IzhNv47yIV0STca70BkQFW+N3YYi/dtaoq+OptASF2yzdiKck0dz7Vu+E5RPuJcX
	9W+BJLX/R+1gbcPYDaDohOkyLJuNmes=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t3ljFgC/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqn0XRPj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="t3ljFgC/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqn0XRPj;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770739078; a=rsa-sha256;
	cv=none;
	b=DgpERsciCcNRT6eRO90dRU5CLw93LAMG3UGQ2N82r/b0bVK+sEFLtKaryqBDnpuCGlz3Rf
	EZfyQNzQqYul/JVLTU4zTKaS2EmNnK/slCN+0nZUGR31OzX13wdG7A4BKF5qyBxLxh9RSv
	tK71rRgV0ZC0g0meFx+UlbFbpsmACvQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 46DAC5BD70;
	Tue, 10 Feb 2026 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770739076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z9/lO/qqaMMm4Dq73M8QNgl6Zi3LDNpEhWBh2+zdw1g=;
	b=t3ljFgC/mEXNQ9OSOppz2BbMe3r2vULoRoxGsUAtDhb2ZEWagS4NWvRO3m4g265XGDrLFn
	PG5gY3+RvCFTyrZ9uccGJnf0i4OAkTeusnenEKoOdVLTWDl60F4K+5U7i6lRromWgY7Ta3
	TLp/SS8zed73UoupqU6TQd9a8DiRgDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770739076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z9/lO/qqaMMm4Dq73M8QNgl6Zi3LDNpEhWBh2+zdw1g=;
	b=uqn0XRPjp4MF1EhaPb1p9AlGOU/Pe57Hw4PrCsufsj6/m5U8ih+a7VnWLUj3oXrNEp3YG7
	O8xMjwFLuQP4r7CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770739076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z9/lO/qqaMMm4Dq73M8QNgl6Zi3LDNpEhWBh2+zdw1g=;
	b=t3ljFgC/mEXNQ9OSOppz2BbMe3r2vULoRoxGsUAtDhb2ZEWagS4NWvRO3m4g265XGDrLFn
	PG5gY3+RvCFTyrZ9uccGJnf0i4OAkTeusnenEKoOdVLTWDl60F4K+5U7i6lRromWgY7Ta3
	TLp/SS8zed73UoupqU6TQd9a8DiRgDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770739076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z9/lO/qqaMMm4Dq73M8QNgl6Zi3LDNpEhWBh2+zdw1g=;
	b=uqn0XRPjp4MF1EhaPb1p9AlGOU/Pe57Hw4PrCsufsj6/m5U8ih+a7VnWLUj3oXrNEp3YG7
	O8xMjwFLuQP4r7CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E96DB3EA62;
	Tue, 10 Feb 2026 15:57:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LAOiOINVi2liEwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 15:57:55 +0000
Message-ID: <6afd7334-82e8-4f87-8ed3-6448e89328c2@suse.cz>
Date: Tue, 10 Feb 2026 16:57:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
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
 <20260202155634.650837-9-kas@kernel.org>
 <e5831f0b-88c5-4a20-82b3-6e5952388132@kernel.org>
 <aYnJCnE5vooLROnu@thinkstation>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYnJCnE5vooLROnu@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: ftfeu5h4kx1ohsxiy91o7bg7wo54ficp
X-Rspamd-Queue-Id: 16A89180013
X-Rspam-User: 
X-HE-Tag: 1770739077-302589
X-HE-Meta: U2FsdGVkX18BHIYyq3qSuy4FsTHmS8fb4AANfKi4W7xoKND7s4y68I77R99MHoDFk8vx3L2277oJEftz0QUqwBnb2xUqri4PvV3eeZnlXGBU32hBPiuB9yskCl1pm5IwNXu9ht2pz5kgJ0JZCK1+lkhkHWVk6yzkNjf7c5ERoy0AuqEAZVaCOl6B/mwS5AOOjVJr7uX72cw6LW5vTD/3/1EXUJbI2hYbcJZcVn/nft7hj54X2uqFLxdHDChpmnRSVt2MBaQMnKXwvzUvEo9KB2w9/qy/p5czm8/Mw73du3Y8xi+gxHUg93kmBUPXBZ3i78DIW5kqbmJ7Z1120XMt1KQte9IfXpgaUYyObwyDqxV+k7IHPAXFXszw6i89O5WAtTTwbzUz5sD5qO64vKixsHS8r4wBonfeYXVXXoBdjaDFG0d4j+koSYZwO7SQTTe/YE2c5wD5qMBAqXchoRJG7yOf5AFht4Ejn2nxjMPLHqMrtPMqqGYS+5ElPCBXerihj28s2DrRwSjMYOxgPqY64mV/XzenLgdBw+3v4JexfsQpWcw1upPqfBd+chVdtMsXDpoPVg+AdOJ7BjNPp+H4YrPiAuq8jh76miSdQGUa3hCjKZgoahCj5KBwluGrL9RjMygreYzgJ6cB4+aLi+5XP16GVWACu5E5EpWW2vmpRtTBQSWPXus+/2QZSpdKvNSzozb9If0kwt7VFA2B2fZoJnxNCRSUSq6KhvvyRfrO+KpRfwlsmZjJKkCwlzd2/OznJXz+hYHXi7hRvln1iclSZzhRZHwZhuZr1au1DcBz3wsAnyWwcoN/YjvoKCbMm7I79abwcejJd4W8RfwRnG0ahuNkwnENtiZtk5wB4iIdzbmYdyCuOli65h6tzp4jlM9HXOuhNE+k2pj1Tw1bmV5snlAyYM4OQx3ElfnCNCRh+wy7qBtrk/b+zYQ1aX0eJ6z9AGrWmTD1L6ZwwCk9qT0
 mSCERaiO
 3sYIIx5TRgVqygWDVbMNvQb7SyXNxZzuZTH4MA17s1bjH11wt2iDUcCHVO4YeVx3TVEl033p1/rCcidm2sk53Es+Hs03cf0pBNmFPFNRJMo6u1ESWyh2bsozQd59gXd5cKiQCUi6rHhO90p4du+hHCAnCZHJy0YJ6bVG3qW6+nBkbEVWO6r5M22yLkxBsqhBKPiGCC6kGN2GFkkpJft4+d3BJ6uq6e+3s3hh+Sj6NJiFmg9kZtFZPljsSBVEkan5igQJIDkDV7j8YU1q0VO2VESOoaLMuyaAvu0tKmKAh/Z0rND4Jb1W1+QAtF44YiwTFVffMRJq1B0MQzGkf3LTY0iwvYlyFZEhO5MSH6NySsU0jbGdz6jCY7zS7nUsR2yalI71W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 12:52, Kiryl Shutsemau wrote:
> On Thu, Feb 05, 2026 at 02:10:40PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/2/26 16:56, Kiryl Shutsemau wrote:
>> > With the upcoming changes to HVO, a single page of tail struct pages
>> > will be shared across all huge pages of the same order on a node. Since
>> > huge pages on the same node may belong to different zones, the zone
>> > information stored in shared tail page flags would be incorrect.
>> > 
>> > Always fetch zone information from the head page, which has unique and
>> > correct zone flags for each compound page.
>> > 
>> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>> > Acked-by: Zi Yan <ziy@nvidia.com>
>> > ---
>> >   include/linux/mmzone.h | 1 +
>> >   1 file changed, 1 insertion(+)
>> > 
>> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> > index be8ce40b5638..192143b5cdc0 100644
>> > --- a/include/linux/mmzone.h
>> > +++ b/include/linux/mmzone.h
>> > @@ -1219,6 +1219,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
>> >   static inline enum zone_type page_zonenum(const struct page *page)
>> >   {
>> > +	page = compound_head(page);
>> >   	return memdesc_zonenum(page->flags);
>> 
>> We end up calling page_zonenum() without holding a reference.
>> 
>> Given that _compound_head() does a READ_ONCE(), this should work even if we
>> see concurrent page freeing etc.
>> 
>> However, this change implies that we now perform a compound page lookup for
>> every PageHighMem() [meh], page_zone() [quite some users in the buddy,
>> including for pageblock access and page freeing].
>> 
>> That's a nasty compromise for making HVO better? :)
>> 
>> We should likely limit that special casing to kernels that really rquire it
>> (HVO).
> 
> I will add compound_info_has_mask() check.

Not thrilled by this indeed. Would it be a problem to have the shared tail
pages per node+zone instead of just per node?




