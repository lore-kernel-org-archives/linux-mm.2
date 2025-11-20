Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83FA7CF6497
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 00:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45836B00A4; Wed, 19 Nov 2025 19:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D5B6B00A6; Wed, 19 Nov 2025 19:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A4C6B00A8; Wed, 19 Nov 2025 19:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5BC96B00A4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:47:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38CA2BADD3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:47:40 +0000 (UTC)
X-FDA: 84129147480.17.255EA0B
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3055520007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:47:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZwOtyzyw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763599658; a=rsa-sha256;
	cv=none;
	b=CwciOP51uh2N++hrmc8tIZAVhUN81MiFwcIzK5EeufHyz3DaYtnKFQT7aHA326UrNBqCeP
	uhSpn9Px1+o6hWvizNHhUptRCWfpwIONuj+/VsW3ATtLSeC+z/Pq8oV6YkS9u3F46ReVIK
	CjUfetlwCBV19RNzmsYVI3B6l9KZslI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZwOtyzyw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763599658;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/P67X+tOkro4N9DxBcXvDCHrMw8zb4DFRG/1PsXQbs=;
	b=vCUTpuZKhVp28OXqoa+87bNtjMztjyvyhf7AhSQTDtOwsFDyeqSgOwVfn+PdVEl3o5+Zwh
	kGJZ5EMQTB9ub2hqibnLBj7Qik8NDQAlhrMATqVdGh3QGc/OEe1EJdrbzRCUEAILrDywqA
	W3r9gn4Hr9nXb6ro8Y6eZuwbgA1awEA=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b73875aa527so54302766b.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763599656; x=1764204456; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/P67X+tOkro4N9DxBcXvDCHrMw8zb4DFRG/1PsXQbs=;
        b=ZwOtyzywE+A6LeibNdBlWVFjj4wX36/2dmdrvfF7J8Um2OA3TIrm/rwqv6l9w3aXZA
         Fy2IFA+x9XyWwiLvgega8jP/4fW1R0/JSeJV9b+VX8ypR/rbFwiBCna+AxS/aKaJimcv
         IbTrJZMfKpuEA+3c+qEsb134BHA6NzvvmneFvIEaO82oXQ2J1ZzlIC2eqg6dz684VG0+
         OEhuwmxAHSxuJlbLerXFAUPI23v2YHEG9yz87Z/jKGQJn9ARGC2c7JYy9+NtzEVL079G
         jEjI+hujUkFoC6BTNCuDwrlKc1cesH8MNMQLkhqKBgvMPuIdgRSBxHRkXG/0lZ1Jbhu4
         /ewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763599656; x=1764204456;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w/P67X+tOkro4N9DxBcXvDCHrMw8zb4DFRG/1PsXQbs=;
        b=uZJJ8dG/wNoNBY6PeMgdthh6cNb+BjgKThvU5Sb30TQi0VF+JtU/NR7R4D5YwXjRJV
         Jy74wviSyZgqPkGY0fGF0SF5YJzPlx9e3wafw6mV2jCmIYoOOtxYM2B7g7CHxxF5/m0g
         kQGmtpbBa+NkNS/x2BwoeME0O3MFwostKk6V463X7uZq4l2tQd0PKmljyjqDcabBowL2
         4rFdQaEY9MYPoJ+sIIsG1bDGsAPA4D8dFiQdeAPzeoPuHKzmDuKMf9X4ceKaw7J7dcg/
         Xq4++rac5jvXCSP1IgOK7HcN/sGrxDFjRo/sSkiJGtoxmzpspxsQmLkmGc7/DyP0qWNK
         cZ8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXJge9A3vOIEIQLjfvjnDD4Av8TvJY5WhZJnZAm0LalxdNeU3rUfB509O32N6lcEHPprn2zd+BCGA==@kvack.org
X-Gm-Message-State: AOJu0YxuyAey2TptfrPIINlLq+jBpZNAxNMKGIaCa348CcKHqmGLtmMj
	VQ1ZAcNkiuG/VqhdOFzIy9PPjA8pe7KIXNT4lJABHrm0r3lD38XoS5nX
X-Gm-Gg: ASbGncuQ6xcGwrG3JnflUhvoNREFCVugE2HEtLy7/D1FNW+SWhptP96HcDwFs+zOQdP
	CdBvf/cWO9phcWiYI2zRGzgXgq4DxUXjzxhqv6CUku8Q5iFnohVt0KUl4iaASr8whFlUKy5+VoK
	KZW4jcQA9iF3tVVPcMKQmTD+n0bD2kgB+0JrsdwhXXvimN6V8YfGV5klprgQO811U4wFFqJr3td
	VjZNYW5a2mvILXy1ciazu/97SamzDPZwrXidjyDf3NMEvuyETlbVQr/0nMsbo9f7xqASUHyB9Pi
	B+MIJXExQeZyDBE1nfS+w7tMwFPe0oVCLjKgfXylN1djaHF7JB0i1BKLovh1PxkgoVWRiueOu6c
	rELR+x8bi8nbh7ubGFkBzBUujTNvWCcfWBNB2bfR0wtTcFxRGyOD6LrGmFmnoMBmLiMfbdq/W3c
	H2H2jvKSxJGbRtWw==
X-Google-Smtp-Source: AGHT+IHN7VWtMO14c9xDQq914ZJx1tXNG2tHafnw8FSgGsDSWuZ/SH5/VJQ/QIuDTYiSsmkR4cRwIA==
X-Received: by 2002:a17:907:2d94:b0:b73:3ced:2f66 with SMTP id a640c23a62f3a-b7655295778mr91038966b.14.1763599656277;
        Wed, 19 Nov 2025 16:47:36 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdd659sm72546466b.7.2025.11.19.16.47.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 16:47:35 -0800 (PST)
Date: Thu, 20 Nov 2025 00:47:35 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when
 splitting shmem folio in swap cache
Message-ID: <20251120004735.52z7r4xmogw7mbsj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
 <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
 <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
 <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3055520007
X-Stat-Signature: 11mwjzepmwg7pryju5ysfcmk3zjr44yb
X-HE-Tag: 1763599657-203265
X-HE-Meta: U2FsdGVkX1+rau97PZT7ZPwZAm8DDv+nv7t7WAIsIGH5sgHqqCmXJGSNqwzr7sMi0UtYIfgpOXlZdOUyrhKUfqNxZ+o2IusWlJ2rO8na6+X6mgocQFyx4LqteSjAkmvVSyW/YD9nvm40bqL+xTRzwmaHmORHqzxcLX3CfMUWGu1uvCE1uT/PiWzAeEa5HJebU23li7LqTQIXYiVDf6XV7KjKN9hFkpsu2tS9oUUKVZdIFjx9KzJsWpZ9qNXYrtid2RwKomnNsELq7WRQmoYCVkBcgvr48SePbXMlHuZRuqf5QVlwZOh2fU1cc5UjJuz+F3ofqhl5lWR1irV82KF+EarLMi3RBVbzrE8roQGxsde8Ty08xTjfhiJsTojBamhD8XptIaXQFmW3ntTXCXUhXSMimhtZei3wg/bKba0n+ecfUfLlSvjvWK7XnLlbycaZlnrRMxT5k49LQHz2e7a28pegroj1KWBJnItXk1ssXHZNOzqN43cBhQMsEGLC+uGYSVXyY0FmTj78rVLxSPOLV55lt2zPARqWoGOd65zgzruB41yIA+WZZ/cJ96P4anYNU24CNHN3Lgt6W5nFcsb7ke4hbuut8AmKUSMZdG0kjgga1wrVYAEeYXMv2eancpAKDYdC/SpuJBi2VOfmVUlDbOt5gqz/8rTdM41X9ABo5YUFKvlLZ9D9O36TKpwArzobmAlfOkTGhwIJeluEQDFB1uVLUgQ3OAd+TwcuC//s80dlpf3xbc4x/Igz5CDqdmCNAUYfwW7hteQKB2nO76WJNLGzyl0zLkTadwwjRxIU42bc8WVoWAE/5mvgHtC9s+jUCdF8fX/XKFys2NWdPfCtnOkmkvX3Ju7R7vptLQ6CBx3F4sIyWqzSEQ3BrkT8SoVYtODxLRF9unjSR/hKwcnIRXEFIcinK5s7P1rEqUEqw7Vztk7mQ3MkU12SIjjzvo5yGCVgB02rfLcYRb865Gx
 aBxNu1iI
 74Y+izUwrmB9MBBNVXjg3vHx2nQdOtKsereRlGVKkX0PeMtG157YWyd+usyruZCTwqY06C7WO68ha2Vlk5XPE6/5LyL+GeeHYgDOXNxWFJQghj2Pas8FUUve3mUftuggvIaAQaHN8DiWv0NX7qEyj4kviS63mH7wewOmlVS/55tEPj9A/9j/L+VWioLRLemnl+FwAsndxkWrf49r73f0HH7L967kXa6hDN3wwFXkkTZ9BZrTAln3fhQn++Hv1aUXcF9JMpyHX3MyMw3DgCnc62xL9/Xqbzz0ff3ZzzgBgLa52fBYo7uoQtgbTPtdVRmlOmE6wBl1NkyKX5DIKXUMoo5VHAShxuVnd7cH9/+G6vQIFKFIDc6O3I1pFSQpfwujil9JEERwHJqX41bpBkqXAG8+Ub6xDsOqjhcIlXIXGIdKzB1SSw9fdnMIls/uc9O8bDeyOgspefPdIyz1pMKmWDMoOfYKTDv3tQnhcBH0irIGYBjU3VtmsQJx0/L31QI6i8OSjpRddOaq+p5UNxJ4qmgKHd49u9ebiUzUmezR01+0sj9btonVOz6JuhPMDcEy9jWioe2rAc1jdyb6qcNzDs0hgOOcxyLOI/Puqaj2Tdio99l5xO/6koyR/bU/sap/bEi/VcOO1SZ4CEkoS6h00+VyE6G2QOcLbe+xH4URmY90QHUIeKSrI8JchE3jp47Ufwp51Ukvbn61FfadH0TDhTOW8eJhW4xTONw+8hBVpwszqiX/YOW1wpqP63VyIGzigq5KVWtTMWFvvE+LA17J6h7+G5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:46:14PM +0100, David Hildenbrand (Red Hat) wrote:
>On 19.11.25 15:37, David Hildenbrand (Red Hat) wrote:
>> > > Given folio_test_swapcache() might have false positives,
>> > > I assume we'd need a
>> > > 
>> > > 	folio_test_swapbacked() && folio_test_swapcache(folio)
>> > > 
>> > > To detect large large shmem folios in the swapcache in all cases here.
>> > > 
>> > > Something like the following would hopefully do:
>> > > 
>> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> > > index 2f2a521e5d683..57aab66bedbea 100644
>> > > --- a/mm/huge_memory.c
>> > > +++ b/mm/huge_memory.c
>> > > @@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>> > >           return ret;
>> > >    }
>> > >    +static bool folio_test_shmem_swapcache(struct folio *folio)
>> > > +{
>> > > +       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
>> > > +       /* These folios do not have folio->mapping set. */
>> > > +       return folio_test_swapbacked(folio) && folio_test_swapcache(folio);
>> > > +}
>> > > +
>> > >    bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> > >                   bool warns)
>> > >    {
>> > > @@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>> > >                                   "Cannot split to order-1 folio");
>> > >                   if (new_order == 1)
>> > >                           return false;
>> > > +       } else if (folio_test_shmem_swapcache(folio)) {
>> > > +               /* TODO: support shmem folios that are in the swapcache. */
>> > > +               return false;
>> > 
>> > With this, truncated shmem returns -EINVALID instead of -EBUSY now.
>> > Can s390_wiggle_split_folio() such folios?
>> 
>> [noting that s390_wiggle_split_folio() was just one caller where I new
>> the return value differs. I suspect there might be more.]
>> 
>> I am still not clear on that one.
>> 
>> s390x obtains the folio while walking the page tables. In case it gets
>> -EBUSY it simply retries to obtain the folio from the page tables.
>> 
>> So assuming there was concurrent truncation and we returned -EBUSY, it
>> would just retry walking the page tables (trigger a fault to map a
>> folio) and retry with that one.
>> 
>> I would assume that the shmem folio in the swapcache could never have
>> worked before, and that there is no way to make progress really.
>> 
>> In other words: do we know how we can end up with a shmem folio that is
>> in the swapcache and does not have folio->mapping set?
>> 
>> Could that think still be mapped into the page tables? (I hope not, but
>> right now I am confused how that can happen )
>> 
>
>Ah, my memory comes back.
>
>vmscan triggers shmem_writeout() after unmapping the folio and after making sure that there are no unexpected folio references.
>
>shmem_writeout() will do the shmem_delete_from_page_cache() where we set folio->mapping = NULL.
>
>So anything walking the page tables (like s390x) could never find it.
>
>
>Such shmem folios really cannot get split right now until we either reclaimed them (-> freed) or until shmem_swapin_folio() re-obtained them from the swapcache to re-add them to the swapcache through shmem_add_to_page_cache().
>
>So maybe we can just make our life easy and just keep returning -EBUSY for this scenario for the time being?
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 2f2a521e5d683..5ce86882b2727 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -3619,6 +3619,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>        if (folio != page_folio(split_at) || folio != page_folio(lock_at))
>                return -EINVAL;
>+       /*
>+        * Folios that just got truncated cannot get split. Signal to the
>+        * caller that there was a race.
>+        *
>+        * TODO: this will also currently refuse shmem folios that are in
>+        * the swapcache.
>+        */
>+       if (!is_anon && !folio->mapping)
>+               return -EBUSY;
>+
>        if (new_order >= folio_order(folio))
>                return -EINVAL;
>@@ -3659,17 +3669,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>                gfp_t gfp;
>                mapping = folio->mapping;
>-
>-               /* Truncated ? */
>-               /*
>-                * TODO: add support for large shmem folio in swap cache.
>-                * When shmem is in swap cache, mapping is NULL and
>-                * folio_test_swapcache() is true.
>-                */
>-               if (!mapping) {
>-                       ret = -EBUSY;
>-                       goto out;
>-               }
>+               VM_WARN_ON_ONCE_FOLIO(!mapping, folio);
>                min_order = mapping_min_folio_order(folio->mapping);
>                if (new_order < min_order) {
>

One more thing come up my mind.

Current folio_split_supported() is used in try_folio_split_to_order().

Here are related commits:

[1] commit 7460b470a131f985a70302a322617121efdd7caa
    Author: Zi Yan <ziy@nvidia.com>
    Date:   Fri Mar 7 12:40:00 2025 -0500

        mm/truncate: use folio_split() in truncate operation

[2] commit 77008e1b2ef73249bceb078a321a3ff6bc087afb
    Author: Zi Yan <ziy@nvidia.com>
    Date:   Thu Oct 16 21:36:30 2025 -0400
    
        mm/huge_memory: do not change split_huge_page*() target order silently

[1] looks fine, because before calling folio_split_supported(),
min_order_for_split() would return negative if !folio->mapping.

But [2] moves min_order_for_split() from try_folio_split_to_order() to it
caller.

Currently it looks good, but not sure it will leave potential misuse.

>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

