Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A3C7CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D008E0021; Tue, 30 Sep 2025 02:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93DB28E0002; Tue, 30 Sep 2025 02:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C148E0021; Tue, 30 Sep 2025 02:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9DD8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:41:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0ED7BC05C0
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:41:39 +0000 (UTC)
X-FDA: 83944970718.30.96B8E43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9354520008
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:41:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=inG81Tjr;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYaoOw8qzwN21ASCyI37EJX6p2H1Y8ERe04KSYlj1rA=;
	b=mdtPdidwAEvZL6RUbvRoIbKNohK04jFMymFpaI3KuBmbtMIhp68RNEL+jnhp72ZOmXZ65c
	EFRT2OSuJ0w1sHXHOgVbMY07CMZrS9eWvBj+faEudPUR7eJZF1eR/T1jb0Xf0mGCl7VPX3
	X3oX4Zd28Xp/PvoVi6BFOVrPI4yJjL4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=inG81Tjr;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214496; a=rsa-sha256;
	cv=none;
	b=DhCMHupZU7VNOj6fz7nsKxyu6U6RBsHYXOcu2Q49PGsg8vW5sZuJTVrnU1myrF+4LolLMV
	GkQJJY9DzK80UWBnHUTS02459YZhqZ+stf/gV0WluAnBL9jgsJXutF3Z/dq1sOkPRDKF6s
	F1vRxfLyqbSOdVpexGoalGcYNta7qAE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759214496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lYaoOw8qzwN21ASCyI37EJX6p2H1Y8ERe04KSYlj1rA=;
	b=inG81Tjr0VKv7VyIjZ6AdzWHcoi6cTV3hpW3JrEwJyTG5V3qIPfkDhUbUcQg1gTw4mTJR0
	7G6Z+KVbNfOyqGtvpExRilrlqOsAiZkQPrbNmqEDLXeh2tQ4H5wznAuphtRv5lVa1mBePK
	jQUb5LpbQr9ufFgrTcJP1Rz6eQYaD7Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-cSoTWclGODaT-RvXq_MoLA-1; Tue, 30 Sep 2025 02:41:34 -0400
X-MC-Unique: cSoTWclGODaT-RvXq_MoLA-1
X-Mimecast-MFC-AGG-ID: cSoTWclGODaT-RvXq_MoLA_1759214493
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3efe4fcc9ccso3396424f8f.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:41:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759214493; x=1759819293;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lYaoOw8qzwN21ASCyI37EJX6p2H1Y8ERe04KSYlj1rA=;
        b=qBL9f7sKfCF8G7C75s/MX7EZGJw1wNXx5ziA8CPsdhuVLv2l25PtvIG3ecjdGLnMdi
         G/tgseR7DvniGC+SRvPEV9mXlSiBuHVM4YnZvZZeveiHM7OM5D1tSKS27mu7O7AE/7x8
         Of4o1KKcukjm6+r2vcMPOyr/2Mj0tCWnS4WmX8HiGd1VvAg0t+bM8J2qC6pz2u9I8j0p
         pQnjzFP+FGXhmmT2eFHxHTKKq1lYyewXsjK5FuRdaNK23e9PTWJxRvkDVpmq/y1aEk1R
         Jf741rNAftYYe5kLRDROXs9SNzg5CfOzetusGyLfRiYG+b2u2bMxmQ+ux33s1wMA/VbO
         vVMw==
X-Forwarded-Encrypted: i=1; AJvYcCU9pLq9R2RaGD8YG5C1JlhJYHztbvDSsHuniyG5n7uwzbnsoMOoIYcGMSvYLbc4xl/XyWXG05A+CQ==@kvack.org
X-Gm-Message-State: AOJu0YzBFz1/zgb5wEsTleCR+bIRA/ENUT0ufnvcRI/jAlg3iiiiTweQ
	IupjxAALnMmBslEHRK6nwXP9eZZKY7eZ0B0BxxQtmh4NnM1gdIoEtFaW2sLX3C0WEmYfSMemDa5
	FxBNJ0XGjYS3SJGO+bA5E7cDmDTBg0NJ/cj7Vdp0XH9FIg4iKYRN276CYn/eBFjo=
X-Gm-Gg: ASbGncudYGWxLIYTAsA/v4E6IuMTEXEqadhizx+VC796Rnkb4pIgtEGQqIzTqf1hmOR
	KuS/9KA23lG5xIhaEloDgxmdqT8mVLCsuJuexmAuAZmBJ34Z0r4Q5ackQ1QTJUipjiZv0vw/CB5
	FW5vEHvPYFKNC61+NUCWKYAK/Sh3o7x7PzXT/xpTXdulwYtNPmdKJdh0XxvvcuuVg8QOGIgMBNf
	IUvgtm6c2CF1KDUYjD4BFzumdM77y9OImTgFVga8JXGriPZBhWhhq51BlmuzNtxZ7v3FpkIIsUh
	FvaDDiR8G0K98LZPWXymUU2jhFhL2TyTQXhJdFVHe14Icta9UC9N7jGqz3znlggEI6W+697ORsE
	JLKHiXkz5
X-Received: by 2002:a05:6000:3105:b0:3ee:15c6:9a60 with SMTP id ffacd0b85a97d-40e497c34a1mr15672033f8f.6.1759214492744;
        Mon, 29 Sep 2025 23:41:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQF9o5qWpBDFJJVt3D2oyXGVYSoEewGDgjfPn6Bd3CFXCSIuBY8r/0k5EG3CenB1jAXiThWQ==
X-Received: by 2002:a05:6000:3105:b0:3ee:15c6:9a60 with SMTP id ffacd0b85a97d-40e497c34a1mr15672008f8f.6.1759214492338;
        Mon, 29 Sep 2025 23:41:32 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31ea3sm253476505e9.12.2025.09.29.23.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 23:41:31 -0700 (PDT)
Message-ID: <f0f0479a-fdab-4f42-9600-5d7b44a73f4e@redhat.com>
Date: Tue, 30 Sep 2025 08:41:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ptdump: Replace READ_ONCE() with standard page table
 accessors
To: Dev Jain <dev.jain@arm.com>, Anshuman Khandual
 <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250930025246.1143340-1-anshuman.khandual@arm.com>
 <9736fd6a-8987-4b10-9b05-e03106463c34@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9736fd6a-8987-4b10-9b05-e03106463c34@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LNCWSBg8rIL3GLuu4-gHhwumrZsZnY2SrwS8ckTrawc_1759214493
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9354520008
X-Stat-Signature: bs9bca9khme6rjy3qhsfg54485py98fu
X-HE-Tag: 1759214496-344672
X-HE-Meta: U2FsdGVkX1/GS3W+fK5Ep6cDsUx7ttsBgDmB95JDPniPYXK0gSnFCtUcQ8h8QNJwCbJNpFFs4jOV+rPn0NMTQ2eAap8BqgiilKE/bP78rUm/soGvnzPOrcKRINGQxccpzFHpevWIMbLGIhM/ne8mUJoXN5pYXBYLIQLZS2NvigvG0XvEFRm6g5p/d6dPeWOO50AP+mElRM4EoOaUGosH5KKGtVTG0j/fs8Ocw6x+83naP0Y2y3CaH8/KJZSlGuTrH3Ip9nkGY7FL62NLxGHCd899gHhWNfwAvLifwlymBwMqLc/Oo4Vwl+zqJl6EjFMdiwqRYuIkcVHdW/ykw+hV4KGEM4JHJqpdDqM2Qs146guriGgwT7P/UNtNSUbsIpK1TjBYnwv6HtVGodygZOLLqs+sIFdLHvPbg9UaaDU1EI6DCo2YMMwCzIdet+oil7qL1Don/stVJOgo1u82PAda4s34qbMvyRRsFKPHFqD57qon20nJKl7X319Afdt9k0g3R15L8AxDibfEbHAhhZqzdlHU3vOcvBOWagmu//jpbii+KL7a+wBc6L5qzNSkL0wyE18fzg+AeWTSvbht/bZUev/spXhiCjbM8DYNiq/+W7JRR9Xrldy8Cr6Pk2xBRFEs/b17TB+IiffzMr6ViWo5XGKLFT3uf+GIlOg5yR80iOvmeIg2mX1zqghZqwzAWflCJrzrTqiDuDFUTs7/sOaDPgztxEq8BeSeAmf/x/FSJSkaai23QxOjJGoPrGS57K+Kx9gfRuJghC4gU+pRTDOD6Mm59eSMa4kpt33dSj4Fn9VjvYG3hbhiA0HSNHWfO0In/zKWwMmt6aOjzWl5ZjyUg7z3PT5teehwk7nFGXdDaG0RpuDaw0iSUT916tZ9wANfHnW6fk+cIHEiwr/Or0wnxcM4ey9tQ7CLZev1xpYFg3+BSH8bOL0BY+AK7irahFNhLLR84U/0d/NRl6nMsgE
 PUYocVtN
 MnzRjOIiE03qz20qO045Wn5bp2CE7pMHFWYXiHXAfzIfXmHc+gp9rMGg/EJ0LdXG+KdV3nfk+f6CBDRg+p23a2ik+TaLT8ZIp4szUwiYpYPgw+UaZ2Bg/JmF1zpzkYZ15pzDmnOojgAjpMQrNEpncPRPJ/VZgp4zvE+Z4i5RDekelnasngEqoxUfwzzcJRndrFdWxfWfv8gNOeY1BfKiA+sEYd/uj9VIHgFG7HvjrQ8xWRM6aQDhoucI/8vWyucuiAOM/T16tAXK0pKulmqa7bzr3TWmvoQ+IBuRVRK0qeOp0kBcUE1lqC2NCGOiwpxTe5PhT3wKkmTRJQ50AdZn0XKx6OEp5ohL2rQNTIJm700OWJMiusRR8WA2LfqVmKWFrUIQGnIC+p7++xJvMj9txWnOSr9m0KSpozeLwtkrCrJgijbjnTP1BFZbOCesmOWHeWkpkxzp9hOKRgzcSPjpPEOfI+45C+j8/RYn/+d9yLDM5EFZfSzm6wY2UhtyuNd/95kodPxHzOgjYnEwN24LFC9EYJ+EbPKkT11QgUY/3XVa0Lo+ZpHyRPtid0xy3EilFnBccfoZxL++KBRJiB+DGmD3s9kex54/VbzmPb275bByeUSn1uhg7QdXdwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 06:37, Dev Jain wrote:
> 
> On 30/09/25 8:22 am, Anshuman Khandual wrote:
>> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
>> anyways default into READ_ONCE() in cases where platform does not override.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>    mm/ptdump.c | 8 ++++----
>>    1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/ptdump.c b/mm/ptdump.c
>> index b600c7f864b8..18861501b533 100644
>> --- a/mm/ptdump.c
>> +++ b/mm/ptdump.c
>> @@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
>>    			    unsigned long next, struct mm_walk *walk)
>>    {
>>    	struct ptdump_state *st = walk->private;
>> -	pgd_t val = READ_ONCE(*pgd);
>> +	pgd_t val = pgdp_get(pgd);
>>    
>>    #if CONFIG_PGTABLE_LEVELS > 4 && \
>>    		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>> @@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long addr,
>>    			    unsigned long next, struct mm_walk *walk)
>>    {
>>    	struct ptdump_state *st = walk->private;
>> -	p4d_t val = READ_ONCE(*p4d);
>> +	p4d_t val = p4dp_get(p4d);
>>    
>>    #if CONFIG_PGTABLE_LEVELS > 3 && \
>>    		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>> @@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long addr,
>>    			    unsigned long next, struct mm_walk *walk)
>>    {
>>    	struct ptdump_state *st = walk->private;
>> -	pud_t val = READ_ONCE(*pud);
>> +	pud_t val = pudp_get(pud);
>>    
>>    #if CONFIG_PGTABLE_LEVELS > 2 && \
>>    		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>> @@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
>>    			    unsigned long next, struct mm_walk *walk)
>>    {
>>    	struct ptdump_state *st = walk->private;
>> -	pmd_t val = READ_ONCE(*pmd);
>> +	pmd_t val = pmdp_get(pmd);
> 
> I believe this should go through pmdp_get_lockless(). I can see in pgtable.h that
> some magic is required on some arches to decode the pmd correctly in case walking
> without locks.

pmdp_get_lockless() is a nasty thingy to handle selected 32bit 
architectures.

But given that we're using ptep_get_lockless() in ptdump_pmd_entry() it 
probably wouldn't hurt to use pmdp_get_lockless() here.

Staring at ARCH_HAS_PTDUMP, I don't think any 32bit arch would actually 
end up compiling ptdump.c.

E.g., on x86 only X86_64 ends up selecting ARCH_HAS_PTDUMP.

-- 
Cheers

David / dhildenb


