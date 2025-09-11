Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E28CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 07:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1768E0005; Thu, 11 Sep 2025 03:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281E68E0001; Thu, 11 Sep 2025 03:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170CC8E0005; Thu, 11 Sep 2025 03:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 053DB8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:10:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 971ED57980
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:10:54 +0000 (UTC)
X-FDA: 83876097228.23.857549A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id ED662180006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:10:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Se2S42uc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/VSiFnnS";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Se2S42uc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/VSiFnnS";
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757574652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQRxDM1Yl84iUwGvJ9O4Mg2SwakKKFAMzLiyyZoNrtI=;
	b=bziKlhXTlFQaKoRpo8F/07ULcbMHp273VGGcLhjaFlNqgqMYf0IbQHRg3rk92DVn2MLVyE
	QyN9XeF6GPflnzUiZYjtDTvnqzf1C5FyE2gzSqhPTcZEe56kfMCMmEpqMQhlPr7DsAkKwE
	4ionJNA/+5fQuwprtVcEwHsOVZoM8+g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Se2S42uc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/VSiFnnS";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Se2S42uc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/VSiFnnS";
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757574652; a=rsa-sha256;
	cv=none;
	b=uYRyMqNxbp+cbPGAldWG00ctl4eJLkJZFQsapKIvU+vVznc3J7Dr59noSCSeShqF9LPYiA
	tyvGW91Nkm15u0zso+DEWkI1gOE8mTG1wAJQ8TAhvnxFlXeZsJ0s2nzABUZCS6R/125uJ1
	rMzlwgpA8Bnr4ZBa7xtIK93LC4nalcw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 286836846E;
	Thu, 11 Sep 2025 07:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757574649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZQRxDM1Yl84iUwGvJ9O4Mg2SwakKKFAMzLiyyZoNrtI=;
	b=Se2S42ucmZuprxqpN9GDE5EKJugRBAMDDYX6eGasiPx6l7BgZT4lIiFrBIDFomajp6fWbg
	GK4d/MKkoLkXZDYw93tPXTl0sezcEkFH3R8WwpplbzC0viHokdnsmr4TdmZ5i96KqXSFlz
	9w3byFcs5OER7tJth5izotv3ujbdVxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757574649;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZQRxDM1Yl84iUwGvJ9O4Mg2SwakKKFAMzLiyyZoNrtI=;
	b=/VSiFnnSoVgjSVrSGurp2kpd7CdidjbfcB5hkql/dCfQcUQWmAi3Y7jH0ysH0lIKZLvG+0
	v4uP4HCCLHniEaCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757574649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZQRxDM1Yl84iUwGvJ9O4Mg2SwakKKFAMzLiyyZoNrtI=;
	b=Se2S42ucmZuprxqpN9GDE5EKJugRBAMDDYX6eGasiPx6l7BgZT4lIiFrBIDFomajp6fWbg
	GK4d/MKkoLkXZDYw93tPXTl0sezcEkFH3R8WwpplbzC0viHokdnsmr4TdmZ5i96KqXSFlz
	9w3byFcs5OER7tJth5izotv3ujbdVxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757574649;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZQRxDM1Yl84iUwGvJ9O4Mg2SwakKKFAMzLiyyZoNrtI=;
	b=/VSiFnnSoVgjSVrSGurp2kpd7CdidjbfcB5hkql/dCfQcUQWmAi3Y7jH0ysH0lIKZLvG+0
	v4uP4HCCLHniEaCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1231413301;
	Thu, 11 Sep 2025 07:10:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uC4gA/l1wmghVwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 07:10:49 +0000
Message-ID: <08e7cac0-704e-48c4-ba13-c857dc1d11f0@suse.cz>
Date: Thu, 11 Sep 2025 09:10:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/22] slab: Reimplement page_slab()
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20250910115507.1991829-1-willy@infradead.org>
 <20250910115507.1991829-7-willy@infradead.org>
 <8eefb8ca-e310-48d4-0c3a-fa80665cab87@gentwo.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <8eefb8ca-e310-48d4-0c3a-fa80665cab87@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: ED662180006
X-Rspamd-Server: rspam05
X-Stat-Signature: t4h1edawu68ms1mbf7sbkyiub4n7xgau
X-Rspam-User: 
X-HE-Tag: 1757574650-827470
X-HE-Meta: U2FsdGVkX19ZgSPOFnGJt1e+DwAr5iIal/Kkr66LeOiZlxnBogFlf68hrwW7+naUPMggd5nxChz0SkLOWNCBgnZRGJfl+aCqSQbSLNkM2dYXJLhLGXr2xSmWSbmdNILgyrK0bhv7tTh3PtxLmuB0FMwDzDtKHG9q59dR5XN5pbyfV7ku6/UW1/qrvNDaAVaaq9br2+mG62VhA4AGk4dHm7HmGCKrruiYqT5/EBipIsHGzPgR3EAQxyB84OifXj2YyiDsl2ibe8CGfLWk8GYA70NSjlinuERi+HZIGA7PpVvJbgYmToo9dhTwlaEaj0jZMiza3ftgRf4c4jY4Jazz7ejAIYIxs6vwp183Jc5PWUb/fR8+YSxOlbbhnqMmU4GVC9kK6S0cOVubGKVO71IJik1MJs5VbYB50R4e+wg3i3AlJ5Xyyh+xyBXYZRvNSzWQkIUsvY50FeJD50OHALcL9iiHZG9OMH6q04p88iJyEvdDfsxwaCy4vB5qpsfe5moVTw4tDI2xCXjy170V7F18xXFNku0ugFzIkuf1L1FlmUQYerisfFr5A9fjeo8hKquIm4iLiylUzs4U7Pyl9lbpUTznG0XlnARj+RVn1qROSVRGHAJRcMhaIyDH9XNQWtG7ehd12NVcOWr0mzElZ8RHtCB9XKvPQYHs5v5KscmrUpDx0yuhIF/r6cNq5Jb4Bs9u+iDbWc2ED2SRRe0DUz7bxzvakJjGXx74q2tPLSBThrpv+z46aLtZ2oKJ6KmTh3GYAtCXlPFCwCvzLYG21E3MUgU6HRIWHSw0KvJ53d1vKNjP07n4Q8dfD/rWypjEs7qpgTYtKljuSfBfIIIQgGKq3RbF2PRN3XRl+83G+rfHpud39JR8xv9UoCl5Dnxwno2uf0VsPx5BWNjgrCYSjQ3fq9pIfCUIlj7yuVeG0ReeGEJ/XLD5swNRHe6O+w1TvCZH0djUtB8d9z9wKJNBVXN
 rAHrMnuz
 nd36aovtp6NFfSWGD/l683vD584uWbWbCQx0JtPmI+MT7z/7r5KIfZA4Rf28rXqrmcdu7gSBesYiEaRs72aJa03ffIBy6QouUB8k6nnfyEjCNEFrb7ypgEE1AcYjH2iomWDl8QVNM74Tw8xBScor0MhclA5A9fAIgEu98bmqfairMUkLt3e3BIUtnqRygiGfrq8aFpK99QIoIk97VXQ88+EPHxx5x5MyL53qQ591ZVpKadhmzOlwqTzqeL3H+dACRcd3qebAgEsF74SoCHl2o+Bbo0PFa2xzkwrHRU0SZRHrBCXxHH+Zr1lXriVpJgXTAQSlImkBFhE+vLGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/25 00:46, Christoph Lameter (Ampere) wrote:
> On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:
> 
>> In order to separate slabs from folios, we need to convert from any page
>> in a slab to the slab directly without going through a page to folio
>> conversion first.  page_slab() is a little different from other memdesc
>> converters we have in that it will return NULL if the page is not part
>> of a slab.  This will be the normal style for memdesc converters in
>> the future.
> 
> We are looking forward to another level of indirection in order
> to get to struct slab?
> 
>> -#define page_slab(p)		(_Generic((p),				\
>> -	const struct page *:	(const struct slab *)(p),		\
>> -	struct page *:		(struct slab *)(p)))
>> +static inline struct slab *page_slab(const struct page *page)
>> +{
>> +	unsigned long head;
>> +
>> +	head = READ_ONCE(page->compound_head);
>> +	if (head & 1)
>> +		page = (struct page *)(head - 1);
>> +	if (data_race(page->page_type >> 24) != PGTY_slab)
>> +		page = NULL;
>> +
>> +	return (struct slab *)page;
>> +}
> 
> compound_head() is open coded in there.

But since this is replacing going through page_folio() (in the following
patches) that does compound_head() itself, we're not really adding a new
indirection, no? Except to kfence here which knows the page pointer is head
already and now we're adding an unnecessary compound_head(). But it affects
only kfence_init_pool() and not any fastpaths, AFAICS.

I guess later with memdescs we can have a scheme where all head and tail
memdescs could contain the struct slab pointer so we don't have go through
the head one first? Which would replace one indirection with another and not
add a new one either.

