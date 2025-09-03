Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41271CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1AB58E0009; Wed,  3 Sep 2025 05:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2658E0001; Wed,  3 Sep 2025 05:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1638E0009; Wed,  3 Sep 2025 05:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 785998E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:34:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CBB08603C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:34:07 +0000 (UTC)
X-FDA: 83847427734.09.DD3A72F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id A30C6C0015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:34:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BK3yCZJX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756892044; a=rsa-sha256;
	cv=none;
	b=PtKIM9pFIChlY9VKTOm79sG1hNmNHiQF6kRdLCeQORXgKj/LT5P1ncoRqR0pSkbnypfJJ4
	cdwCAuyXBeaJYoVgGmWhuVhNJ+x00mjddhNYi6XDTBcmTIIcbmdZGLDX1vO8QBktT4+XuH
	rfd48ktHyJCQdNIXSHcCLedrvKW9uKg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BK3yCZJX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756892044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62bXuPvp9QS1Qrw5JNj0rH3dpztoKcuDRvY+keYGksI=;
	b=IOadkXOc3QWi5V16+Z/vv2JWxA+q7M/DQ/e7KeGPp2DYJ1tesN83tKivibugOByVe6KGo6
	s17cZD1iUt9pLyr8KOYNN9AuPe1VmgRsvRGqbMQgzgtj11p6cpiNXXhXd5VYUmt4rxn5cI
	GdYK5sXpFonMzKsnbC1zyP5h8owVbGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756892044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=62bXuPvp9QS1Qrw5JNj0rH3dpztoKcuDRvY+keYGksI=;
	b=BK3yCZJXC7CNpfqUM/N5WruC2jAOzEPzdhQdmDwaksn6wTrD2M8Y/iaXBrpPNr4961d/Mr
	pEViS33R2wzvTmPqP0mIaMSsHwhSmV310A5gk8Nawg7vXe9e/BU472dQSBZaK9JvbSJMFw
	YZH+w/sPBVNF1IOkMSp5wtXT10DsOY4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-uTUfO3_MP92AdsQA78KI1A-1; Wed, 03 Sep 2025 05:34:03 -0400
X-MC-Unique: uTUfO3_MP92AdsQA78KI1A-1
X-Mimecast-MFC-AGG-ID: uTUfO3_MP92AdsQA78KI1A_1756892042
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b8dde54c1so18995195e9.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756892042; x=1757496842;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=62bXuPvp9QS1Qrw5JNj0rH3dpztoKcuDRvY+keYGksI=;
        b=eqiBcrrG/atRPXtMBqI2EtOYuaGOKaZEf7An8FTRc4vp5e71bmQ3uAEP8N1pmyzGP/
         7On52W0+J+RngMwQSf0zEm69RLhw9/3e26+A6Q2TRCvEekb/17a6aUJx0i86Ez5tlW3y
         gTbeVb7XupVqbPhWwvC3FKG/k1ndc9lAVNmtPbzgOaZkeAHjVg16UlEtKCfuGS+chk8g
         5EUmIAuoUUvV/NQWt623Qa7OAT0UPeS7HlXI8f03RKn4BnxFfvzIycHTxhdfG37DN1gM
         IbhuKDte9SQJxYvdmfcCpsNzHBuPFwUORZtIcPob6tiuZIZwdHOwE7hIIOgEv3/wdhSD
         T7aw==
X-Gm-Message-State: AOJu0Yw0ckXDGsFeUEBOW/ycYWVjxFCO/zNrQZanfypKTb2JcaVvJOKy
	gA0UCPrthBFhZL35lBmsRTrd01pUkm0CLFEs34vvMhwYWQEBDn5WEK8PkQVjQ4p20JSHmlIRzLo
	fRD9IC4tr0Otx6gB20wM+yFdRFeUrIU4JdG34z6w2Lt5pjEUUp4VC
X-Gm-Gg: ASbGnct+iOdifQUvAkxBk6YxZH+GhKIMxvNxH7jgqU2yRvGKBcYHfCl/ejCPU/Fp7zy
	Ei3NLz9hPRB/5og+RYRE8AaDS4BwM7Fde0fJqzpkZxqZOJIMwPmnzpG3NZe168Ad0/zGtKBcwCj
	dx0jWhM/jENTtQp9Elhcxuz4QyHVT6XIFLbsLDMqynxdUTCuR0sPwMm+LZhryNXIzaAgXMhEcZB
	LwaMHQvngJv3QRxJQKs/V2C6mdHBttLs3tGSdoAryKvfcm/iDdhUZGJ1eN9Fnm85yOb1hZByvI8
	soZ60kaifaeFYw/nbBZpvD04En7p+dFnwg5Wm6d+XsnQBmFg4WI+WAyQWSzwBd2Nv6SuvA5c1fb
	+8ppCRZOe5wnKf8uUs2EnZhAcOGCvJYqk33mlDNjSFeji4nznUrWgoArKtkAI9j2hayI=
X-Received: by 2002:a05:600c:548b:b0:459:d8c2:80b2 with SMTP id 5b1f17b1804b1-45b85526618mr120348505e9.7.1756892041695;
        Wed, 03 Sep 2025 02:34:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIB8MUXfWeryR85gNwolfPCgdvhNsdHM7EaNVBRXwyIk4X32nsBrQ2ihXheOmTBp3W3qWpNA==
X-Received: by 2002:a05:600c:548b:b0:459:d8c2:80b2 with SMTP id 5b1f17b1804b1-45b85526618mr120348275e9.7.1756892041204;
        Wed, 03 Sep 2025 02:34:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7f14bbsm237407345e9.8.2025.09.03.02.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 02:34:00 -0700 (PDT)
Message-ID: <d460b91d-3be7-4515-a9a3-468909aaf769@redhat.com>
Date: Wed, 3 Sep 2025 11:33:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Where to put page->memdesc initially
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@nvidia.com>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
 <aLdcPeb8zrfDwd2p@casper.infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLdcPeb8zrfDwd2p@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5DdkT2xEVgAxsxeB3buXRJTqb4jF3ZG_lZVleyRbEoc_1756892042
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A30C6C0015
X-Stat-Signature: xny5r73ekhejcydmjjdhiqmxunwiwe5j
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756892044-677100
X-HE-Meta: U2FsdGVkX1+HjJnfK3b91WEekCxYa1u3ZdSE0f7gNjqQQqG81UXWMrTn52FsDov3ULTE67vii6CjKXX5aTNWrBwCcvOucn/HqRJtTiWpRxdm8hrpq15H4Xr8iMl2LJBASkDzMy51t8JNML0LA890cWUl6yYl9Mz16GbLn7qnw/vmZVHR6GuahveONjkOntpGjWD6CfphZot/ERL1+jz0q1tUEDjinR4D7zZwMDF0luzQ1FVyvjzs1sEvgAQLFUppHN5l64wJpZetRbgxfltIbzcGIoRu19Ho+3DmBR79lCdSwaR55v4NMHjWaRKrnUn7LOquwzLTeWioVxYRIU7O417VA5XmgrSIw/7DqNl/44f8c8r2HuZtDtktvTHipZqG0td6OYyFolX7QH2+HC9f87ywno6LcISRUIR4Ywa+2IEC9h2J0gJXA8ojdzE13p3lTBByNILYkXZgWMwQ9uuBl9Lnq1QSAJrPrryLwDjZDw5odnBEsw4G9PnvjezSIOccwm2Gm9WvHyZf6riQarznmZM+I4yB1V+5yc+YfHqllLvipHLJY1KW41bzvwN7UyHhDOe1F/42aq93I1VHSQciwlAEZnnzoRTY/yZ3HV9KipGfLiN0uJPJkqHzzHP9H86RwGI57PL/Kgo6x6zsryFNC7uz95G2o/jjuNb89vi/UEf+ZfovbixdSWdwS7JjusrsGu/FsonLZK/H2a2pZBqFmrfjMPNPsu33adYAWcIEFZifU2FP7wRPoWCVq6TuhkWQEpMSd8IX2YhxV2yx3PjGaY29yxCyE+yEIYURisCsHiK3z/+HEyFKJKuIL3wO731xkctVHBb8ec5YSKgQvL+aViPWoLpnHwRXMphaZA6eqmTcvPlC1oNbgX0Ow/x7QQ63/6bf9U1ujuOzwP2Jg4Ebd8boyW25/9EHer9TNjuALqqkWeTYPLRL1juTfpNSd2vDuANkUfkfZCvs/DrXi8L
 gYDZ0uXc
 50L5e/tGnRWU51Xd178tmWzurVEiEAWKn21FCj0XbQuo25r+TtK7YXHFvKQrUEgPemV5YGkHxPnsL//97R3h62YfhKJd1krJo378teFPPh2raEf4aw6/hdN0WLxVy0+KUHwoELEKLhMCUnebFBQ6maG9rGNB0Dw9G7mUNQtzeqZiWQidsw48/Ag4CKJRmjS/1V/3e97apktGoyt2gWoEoxAeaIRGgyYrwi/JTe1SZU9Jvocl/bSGzhgqt0p0fA/qd0CqcZot3p2HjJWNo4RVEsXsvvHSkn9eAovjW9xmWRpTIZpmM+6YtNj6HAiRrFDi/dyechdQlk0wO3/3eTCV7R1sWHQbKsX0AGoUFAlyfuKkxMIvyAm9CEArxkBjHZ4pAW/6S8ulLnDvgaVdx2r8q7GsKZ9FKrkwmZwKlKqjF+JTEJ5M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 23:06, Matthew Wilcox wrote:
> On Tue, Sep 02, 2025 at 10:09:49PM +0200, David Hildenbrand wrote:
>> Would you want to move the page type already from the mapcount into the
>> memdesc? That sounds challenging, because for any typed folios we would
>> not be allowed to reuse a field we want to use for the memdesc. IIRC<
>> hugetlb pretty much uses all of it.
> 
> That would definitely be part of the same series.  But possibly not the
> same patch.  I think the series has to include separate allocations for
> slab, folio and whichever other memdescs won't fit into 32 bytes.

I was wondering whether there could be a single patch where we do this 
change (separate allocations), and just prepare the code in previous 
patches for that accordingly, such that the resulting patch is still 
reasonable small.

I feel like this way of splitting patches might cause unnecessary 
headaches :)

> 
>> The easy way out for now would be making this page type specific: Only
>> selected typed pages will store the memdesc (here: slab pointer) e.g.,
>> in the old page->mapping place.
>>
>> So PageSlab() still checks the existing page type, put page_slab() would
>> simply lookup the pointer in the old page->mapping place.
> 
> I *think* that's roughly the same as what I'm proposing, except
> that we already have a meaning for "the bottom two bits of
> folio->mapping are set", so there's potential confusion for
> folio_test_anon() & friends.

IIRC, we must always make sure to never call folio_test_anon() on 
something that is a slab already.

But if in doubt, we could use bit[2] in ->mapping, which should still be 
unussed IIRC.

>>
>>> There are a few overlapping uses of these bits in struct page, so if we do
>>> nothing we may get confused.  We can deal with mlock_count and order (for
>>> pcp_llist).  But the biggest problem is the first tail page of a folio.
>>> Depending on word size and endianness, there are four different atomic_t
>>> fields that overlap with page->lru.prev.  That can't be solved by using
>>> a different field in struct page; the first tail page is jam-packed.
>>>
>>> So, page_slab() will first load page->memdesc (the same bits as
>>> page->lru.prev), check the bottom four bits match the slab memdesc, and
>>> also check page->page_type matches PGTY_slab.  I don't like this a lot,
>>> because it's two loads rather than one atomic load, but it should only
>>> be present for one commit.
>>
>> As a first step, I would really not use the bottom four bits. Why
>> perform two type checks initially?
> 
> I'm concerned by things like compaction that are executing
> asynchronously and might see a page mid-transition.  Or something like
> GUP or lockless pagecache lookup that might get a stale page pointer.
> It's a lot easier to reason about if we can do a single load and treat
> that as a source of truth (with the appropriate reloads to make sure
> nothing changed after we got a refcount).  Doing two loads makes
> my brain hurt a bit because it introduces more possibilities for
> inconsistency.  I'll need to write it up pretty carefully (which
> annoys me because we're going to need it for a single or very
> few commits ...)

Makes sense, but maybe we can avoid all that by just structuring the 
patches differently :)

-- 
Cheers

David / dhildenb


