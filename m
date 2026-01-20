Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078BAD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 10:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694B06B03B4; Tue, 20 Jan 2026 05:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6357A6B03B6; Tue, 20 Jan 2026 05:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D976B03B7; Tue, 20 Jan 2026 05:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9B76B03B4
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:33:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFE4716046D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:33:01 +0000 (UTC)
X-FDA: 84351979362.10.3640380
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 68F9440009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:32:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ncNBYv1u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mG5hgfYY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ncNBYv1u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mG5hgfYY;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768905179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyrDx1MhY3e+hHISP5xpS3IMhu37A0mWxWGFA4RwEpQ=;
	b=X0c9EbPHcOHc10sM5mtkrqVsDZphixC8v/3I9nPfAx8UfD/7hAfdOo8v4g6y48+NdfWPAn
	7HIbzhFwee+tM6AuCo1uu4iomTZgLf9tiidrarU7okdoA7yGRTJhjRJe+qDDCeSNknvusv
	WUw7Ka60sFqSn66Iwnn2lMg+YsLdnUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768905179; a=rsa-sha256;
	cv=none;
	b=fpMHUae1dKIQg3od+zNWEjIHbfVILuB50LI5OjTjbEid5vvT3eHDFhsO36xwe6Qm80qopb
	50nSH0PGeiCXm0sY4ilVXFishoTZ/FD0epENB7Zq538P4kTRt+6rvlO3xVuedAsfK5rurh
	9TuDKTsfDjjBj5Plhn/qLutYLFn1Hkk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ncNBYv1u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mG5hgfYY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ncNBYv1u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mG5hgfYY;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D30305BCD4;
	Tue, 20 Jan 2026 10:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768905177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XyrDx1MhY3e+hHISP5xpS3IMhu37A0mWxWGFA4RwEpQ=;
	b=ncNBYv1uYVI7iTVuDDYCpDh7Z0KbKWyMrsKVFc8roZI3uZ4vgnVfVOSENXGtEYf0JICIcr
	0vtu5IffI1xRM7m9B7WX/r6uDZFZebqaGrWNrKlgLe7pHpbwvY9+Z3FRq0BxrKMpMRoA38
	g55WsebXmqSBZzIluLQGkn6PUQEACEo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768905177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XyrDx1MhY3e+hHISP5xpS3IMhu37A0mWxWGFA4RwEpQ=;
	b=mG5hgfYYLTULX0CjTEDcnSPZJsgF4JoEa6xtQYgBdMRuZYMY7wvsnlQNWmEnLNbJDV8D+8
	iMQ4IPA13Q4Hv6AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768905177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XyrDx1MhY3e+hHISP5xpS3IMhu37A0mWxWGFA4RwEpQ=;
	b=ncNBYv1uYVI7iTVuDDYCpDh7Z0KbKWyMrsKVFc8roZI3uZ4vgnVfVOSENXGtEYf0JICIcr
	0vtu5IffI1xRM7m9B7WX/r6uDZFZebqaGrWNrKlgLe7pHpbwvY9+Z3FRq0BxrKMpMRoA38
	g55WsebXmqSBZzIluLQGkn6PUQEACEo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768905177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XyrDx1MhY3e+hHISP5xpS3IMhu37A0mWxWGFA4RwEpQ=;
	b=mG5hgfYYLTULX0CjTEDcnSPZJsgF4JoEa6xtQYgBdMRuZYMY7wvsnlQNWmEnLNbJDV8D+8
	iMQ4IPA13Q4Hv6AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A69C43EA63;
	Tue, 20 Jan 2026 10:32:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yYFUKNlZb2kdbwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 20 Jan 2026 10:32:57 +0000
Message-ID: <1390b9ce-0ed1-4cc9-845f-fa4dd5f3ffc8@suse.cz>
Date: Tue, 20 Jan 2026 11:32:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/21] slab: add optimized sheaf refill from partial
 list
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
 <aW7pSzVPvLLbQGxn@hyeyoo> <2232564a-b3f7-4591-abe2-8f1711590e6e@suse.cz>
 <aW9Yl-nqLjAJyBkB@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aW9Yl-nqLjAJyBkB@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68F9440009
X-Rspam-User: 
X-Stat-Signature: ishqa6rbedsu69t6ag36ztbdaio6nr8k
X-HE-Tag: 1768905179-638579
X-HE-Meta: U2FsdGVkX1+o+B+4OODBoJZJWsVSwAUvuJfseX0049s0lpPZqxo4mG1JUESXtP9YAPwkT+doIz8FCLHqrgrF0t0LSipAwnUoIXlYMLRCqmdMdHbhbC7Q49ExosxCZFctDa1q6x26k9QqA2bx7IIzmQ/FNmty++1OSTzQcs4w5RJlGVxpvHNuRbPYgTSXY8dYbXS7UFqI3WKe9x4ntQuq+NOprB87nhOhQaf2kxVn6Jk7H/xnzaOcaogH2ClNIq1FcVXX3fsRg9B7i8eBZ2FeOqdz15+RDAZgVtE8lRzyiE5oGhVhms7sK3FKMnKq/aua5NqUD+LEfhnHXwQIxSaX/2P6dtPsVfGfHNzmF1QCsRihiNyfUSpOF0SFFoEcGnsK6gbZymYn4ppV1T78X6DOsgGxT4iHo0e3QRJ/rg3X70Mb7hUtoP+njumJilVjXemYY05lyG6d6cBL+XXW/QmkqCerYwYbrB07RZGDoUmU3SLG64B6v9GdmsDSpqwljw/8Ui8W4Jl2lR4MH3gwz9kupxDdB1xlmfgqKPfVAvbMUDuPUmPGKeEstBQO02It4SSC02TC+sKggi+1al5kPSaa7T0UjOXtY03qsBuqKEJXIFE32cz2I5+m78tKNjy2cbDQilZtne1r9qBhl/6arbSurLD5d+NSrBfiqtgkJnPaROdzeKdQgHrmDutNtbJkcks6UQMbxBKLkBnvanBFSh/B+d4oguCTMtwSVvDSeLzNxtnGKQxiBqiyGJU3UPI3rrUiytWciHV1tpgaYIlkdlSLwQLWDGjYUTCOTsH8XQ5u8qJi+0oRDTLFLN+STkrEbAndssjlseERyBLlIPFAyWSsIud39a516kL3UNqpvoQ6aBaap1bG2rGebf1hSSCouS6dMzZVTC1jAPhiEI6TSwAWvWPKz+O4DQ8ZdPx1V3Tqji/uAKkrkAbgA8qilBJPqBLdrdrtJirDiO526tADUSN
 VkkpSTnS
 4T6ttc8ujWTTlzXWii51mtDBq2IclEw3hPvoDmyuH68Ek3sYDGQWe4YheiSeFw8Nhcoir6AEgEV4RYxZjHDZqIQS/S4zctWYpNnK0l3CiGZ7b9kplXX7hCVntEsllHJRYS4EMwMkpoHyFVQu+XWJKBJrRcgL8hIil4vwtvyGDBGgzpIOSEV9BlfioOepaKuQEx4tXE2n/kTphZTSbKvVGwX6ZASSCV4fk1uD/19zISa33uMbK/G0nxPhHg4pmlqL8Fyh6kLn2LomuGwWERGeqB0lHxAUGaoq0W+As
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 11:27, Harry Yoo wrote:
> On Tue, Jan 20, 2026 at 07:33:47AM +0100, Vlastimil Babka wrote:
>> 
>> Right, so the plan was to set min to some fraction of max when refilling
>> sheaves, with the goal of maximizing the chance that once we grab a slab
>> from the partial list, we almost certainly fully use it and don't have to
>> return it back.
> 
> Oh, you had a plan!
> 
> I'm having trouble imagining what it would look like though.
> If we fetch more objects than `to_fill`, where do they go?
> Have a larger array and fill multiple sheaves with it?

Ah that wouldn't happen. Rather we would consider sheaf to be full even if
it was filled a bit below its capacity, if trying to reach the full capacity
would mean taking a slab from partial list, not using all objects from it
and having to return it to the list.
Of course this would not apply for a prefilled sheaf request or
kmem_cache_alloc_bulk().

>> But I didn't get to there yet. It seems worthwile to try
>> though so we can leave the implementation prepared for it?
> 
> Yeah that's fine.
> 


