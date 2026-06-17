Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1105CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8D076B00A7; Wed, 17 Jun 2026 11:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3DDC6B00A8; Wed, 17 Jun 2026 11:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CA06B00A9; Wed, 17 Jun 2026 11:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD076B00A7
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:18:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F00EA140478
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:18:35 +0000 (UTC)
X-FDA: 84889761390.23.3452F04
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id F03FFC0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:18:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qFZ30UNr;
	spf=pass (imf10.hostedemail.com: domain of abarnas@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781709514;
	b=nhwMHkRAbp1YdkkXvtbN8L0eUHEb4oVkk7Pzi/MLpYJgQKjFQcHqSFUavMEpt/GogD4e+/
	Wab0t5ahevQrfY2w9ReTuH9LeoCgbTbXHeZlqXyJ3F6ccCMvI1xS2OMz5yitCR/mxNSVVR
	jV2b0g9QyN3kLkHG+YEM9wH15k7leDI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qFZ30UNr;
	spf=pass (imf10.hostedemail.com: domain of abarnas@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781709514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mqWVy0xz5Q5QOdMchs2mpfdZbtXWI7hrs2LNKIi0SA=;
	b=msCG3ydyp/51pitA5FI8O6ng4xkGV5NFCUCvQQxa8kItmXnt5LKhGW0kfuwihqF5okf+yQ
	xQNzhJW3SgeKSwZ+GYJdopdI6vnh68qfvxpGhCuhWomz+jkqmG0OZfy6X6aC2IRWWYqsTL
	ReVvZPH168DufUco0s21yTnK+IPi178=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69583ca0499so1050931a12.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781709512; x=1782314312; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+mqWVy0xz5Q5QOdMchs2mpfdZbtXWI7hrs2LNKIi0SA=;
        b=qFZ30UNrHMiSTouMu+uwEKRxzkG6B1jiD8nmepVoY2O818rKMfjdjVCqbausEozB2G
         WnQ34GFrZ6L4ZT9iFflEoKzYRUetpA0UgKWiwcH+aW3vvpDBc4LOIPly27EoPlZQw57C
         uKXZ75YHAeoWMXR8/tdazLExRc1Adw0mjPOUtXPy6mXy4zoyVYJzHk4iqKNCmd88bRjo
         ECPUt7D+w5tuUZ/2z4ZlBGTwsQDAkPqHiXx5gvtA/GWwFrGRcfJGeptdoX7sKdjO+6Md
         IRyDyf5s1P/RUD1rhAODy7CThe1xXiveZi7ttXttOcyev4dKOYVzb1TmTpkes+b+kKop
         oKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781709512; x=1782314312;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mqWVy0xz5Q5QOdMchs2mpfdZbtXWI7hrs2LNKIi0SA=;
        b=azOPcmkeGV3u3pwDGx7WzB7kYZ2fMDzPb6A+vE1dbIV2sDMnb9w5Uyzr5oZ/06LpIn
         jnIkDIPP5Wod9i2U8z2GLVVETNciG7mNnIZWI+hsQ54JGvIpH/61aZPx++X3r+xyB5gy
         4+6RLAPYsW+TFX/+AmSX5PUb9GDw0qNVm6HuCNk0++4Cy6+KUsGC2atyxz2sGj6YfAxw
         mWitaW+SxeQe1IzM+ll/FtKjUyorr8lGeCyxSbr3V0mWm86+soyQ21t3NGGdoMaKIbih
         0YOaP57TGDObW2p45gAD3mP3O+mzuvuhz0yYr9nHufKXixOh/i7Dr7rxO8/yzEHIzWiS
         C6iA==
X-Forwarded-Encrypted: i=1; AFNElJ+3dvOTbVPQ+RPJO9T4VsJBFnpPNSAxqueaaFcbyL0hlR5S/3aqe9qODk6B6upgEK5lMSPs6TypXQ==@kvack.org
X-Gm-Message-State: AOJu0YzScQj93+njNqUcVMGus8wU0vzUi8HKzqUpjhR4xIjOzDcSL23C
	IqRxVSV1InDtbd4iHdjBx50OyQGKaTW7Xm+Mpgoop5lJs8t4oS9R7nWW30g9gfZGXA==
X-Gm-Gg: AfdE7clShLiT+DYy0Le0yp2Q+SqId8EhaV/Ci0kr+Bx858+r5qRvVVpeodOOCdNzorj
	SMBdZmz89+JZ5UZlEjwMg9bU7wCOGMm+/qvsrkRSLR8eAmqBGltyE8JOeq5Iws6iwrcoQD+vp4z
	ypLpAhRtB00mo5a+b2UnCVTaGrl+WMxdAYkmwN56WTo1nNZ1e+S0BkowUK022qfHX52+VGdLjWR
	tP5i6RVuE9pjN+D/Gs0laXSW8hS92fQhC0DQidrVdyAQHlMfOyZCwG1Ts6mTebpJ7LSZmW391Jx
	Gp/E8YKDGToTZFEGPHPTmRKA1+mqb1yJG7bsC/PLSVOjDASCJhPobTxHtxPFddknnFWbL7+VUxX
	jbVmm1ZadQlUCkIBiX0amIZvyKsXsm3FjZmAxIVGMpNWeJny9CLmuhzeknkLLuxVWxi+Hds9cPt
	yTJ0/LSA+yF2SUK/V+P7nMJ6xosdDHgQChBA+gNRIczWGSG5xbNw==
X-Received: by 2002:a05:6402:528b:b0:68a:ac5e:f4ba with SMTP id 4fb4d7f45d1cf-695476ff271mr2444959a12.24.1781709511761;
        Wed, 17 Jun 2026 08:18:31 -0700 (PDT)
Received: from google.com (78.207.190.35.bc.googleusercontent.com. [35.190.207.78])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6937948dde4sm6692740a12.20.2026.06.17.08.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:18:31 -0700 (PDT)
Date: Wed, 17 Jun 2026 15:18:27 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>, owner-linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Message-ID: <ajK6w3YTFpVaUl3v@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
 <DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev>
 <aiuyoy8Kmr9yU4GM@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aiuyoy8Kmr9yU4GM@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F03FFC0005
X-Rspam-User: 
X-Stat-Signature: ecfstgmucg8ziwds8xrx4xu5rix9ups5
X-HE-Tag: 1781709513-286998
X-HE-Meta: U2FsdGVkX1+nr/8Xy66mGGcw41IwfqmSW+MmyMIky3Ic57ImINAN/ZAxjoZI8BFy/MhZhQIkYkFijrAsD01SKWyjyI4zH6LiUh02fmkQWvVZnNmJofkqZybtEEbYmusdYaoDq99zOlAGirAQ0u0R3pA2ee6mFUt1IVux4lRI0nCiCRRHyYZJQpbdDoG0anXPLbCXMml+f0Yoo4YIUmaz5w8b5qth1R0pRqJ4N0Pq9jxSoouykjFyIMh7+BBmZu8D2OYWkY3KKkvi+Dj/9wPk4OOun78HvL/jq5lYWUlxe0H6DQqnaIvnI2nFJ7AoTHvPR2nunvzkrVnEqdHIKDGsPtS06UcfRV5ZEkyGlWncPWFATNGbjjLGrpCVqhAvp2VbkZG/CEbuNVtzt6Icax4lt1awJIKW1DjG++civC+7cysMC/+SexQdZa9Z4vxYhDKZ1hd8GT0Ra3VuxMJv363wmj9LDH3BiQ5UAvYiRI3U/3SEiST6/tlx1kVVGQWVjGOPN4fOETzuVGc5nj6cUNKTN0wXsu/BEFEq0I3hdGZ7jOchRrqkE+2pgktAjXNkdpebYz9XRyTErOctKFswE8L7yFta9KY98EWHt7KU5X/UcugovDJZM3l2SdlMzvahx4/7QIufACnO814sIg/JU3W3j596L8gQXret8Jt8shKCm/Q2m7/6ZXaDD8FUA+S4P4Uos+mcy1+99wc2fNrffdI0Wx8R2DoaPKzvOTyLJbFoW7aUK1qmIT9b2IEOmtkN3lIpCDxHOTFP21PpmldK/niNulgvfUGpivcyep1voZlD/7rd07g0zFXmD7acCOWFb935z09e74fFgZ+jHJQK31AwVwmDPABPxttNJ+UgHl2bdfvvdXcgWD1kYpLDSZWrSznbdziHWaw0Xnnaanar8LhPXZ/Xa/sYsr1+Js6lSht0Q/vr63m4PDn3IJHP7Yav8mtuWwpfssfMALv1eNpbjFC
 ZO9eR7oI
 BBcZHeKmdVKr+rHB1EsXOUdc9vvX+SXLY2UTcTILYr/dESsBUgHz3EWT7sZds7XxlsZ6M7+QPO3nRtgCGk9fiZiyI3lIFy5TRrSaOMIqv6jh0xLf/wnUUa8wJH9d1kYknp3rm6Exfovk+qzGilpVxfWLNHI6mEzH3Vu7kqCjKeAtfzhnsWMBzKfL3KQqOcijxG5y9rX5XJBtMKfq5nKuIxMtYwz5sYyFIoVFmJBS54vMCcOW33XXlr9dnaEwD8744JfR9YLF24tXjW+coWtrXnmHKjjD2EK3ifTZ8iXh4saO7w1X8OdY/YGDOvXL3FtcnSgpAuP8yoB/d31+lbPofJn0rm+qh3/X4YHMQebb12IMcttzh6LPm/zbGRnMWZS12SqbYB9ExGMjsH9W/4en3SbPxIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 10:17:55AM +0300, Mike Rapoport wrote:
>On Thu, Jun 11, 2026 at 01:54:13PM +0000, Brendan Jackman wrote:
>> On Thu Jun 11, 2026 at 1:01 PM UTC, =?UTF-8?q?Adrian=20Barna=C5=9B?= wrote:
>> > Strip the read-only attribute from the selected memory range when
>> > restoring the linear map after an execmem cache clean.
>> >
>> > An execmem cache clean is performed when a cache block becomes empty
>> > after unloading a module. When making the memory valid again, the linear
>> > memory alias must also have its read-only attribute cleared.
>> >
>> > Without this change, the linear memory alias remains read-only even
>> > after the execmem cache block itself is freed, which prevents subsequent
>> > allocations from writing to that memory.
>> >
>> > Signed-off-by: Adrian Barnaś <abarnas@google.com>
>> > ---
>> >  arch/arm64/mm/pageattr.c | 17 ++++++++++++++++-
>> >  1 file changed, 16 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> > index 88720bbba892..eaefdf90b0d5 100644
>> > --- a/arch/arm64/mm/pageattr.c
>> > +++ b/arch/arm64/mm/pageattr.c
>> > @@ -239,6 +239,13 @@ int set_memory_x(unsigned long addr, int numpages)
>> >  					__pgprot(PTE_PXN));
>> >  }
>> >
>> > +static int set_memory_default(unsigned long addr, int numpages)
>> > +{
>> > +	return __change_memory_common(addr, PAGE_SIZE * numpages,
>> > +				      __pgprot(PTE_VALID),
>> > +				      __pgprot(PTE_RDONLY));
>> > +}
>> > +
>> >  int set_memory_valid(unsigned long addr, int numpages, int enable)
>> >  {
>> >  	if (enable)
>> > @@ -362,7 +369,15 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>> >  	if (!can_set_direct_map())
>> >  		return 0;
>> >
>> > -	return set_memory_valid(addr, nr, valid);
>> > +	/*
>> > +	 * Execmem cache uses this function to reset permissions on linear mapping
>> > +	 * when freeing unused cache block. On x86 it makes memory RW which is
>> > +	 * desirable.
>>
>> Hm, maybe desirable for execmem but that doesn't really mean the x86
>> behaviour is correct. Maybe it makes more sense to change the x86
>> to align with the arm64 behaviour here?
>>
>> BTW we should probably document this API a little bit, I never thought
>> abut what "valid" actually means until now. I had thought of it as "I
>> can access this memory" but that's an unclear concept and now I realise
>> "valid" is a technical concept in Arm that's confusing. And it's extra
>> confusing if the kernel API uses "valid" to mean a _different_ thing.
>
>I've got confused too and that's how set_direct_map_valid() got into x86
>with a different semantics than on arm64.
>
>What execmem really needs is set_direct_map_default() variant that gets
>nr_pages.
>
>AFAIR, set_direct_map_default() has a single 'page' parameter because it
>was added to reset permissions for the direct map alias for vmalloc()'ed
>pages before there was VMALLOC_HUGE and each page had to be reset
>independently anyway.
>
>Maybe it's time to add nr_pages to set_direct_map_valid().
>
>> Also, shouldn't execmem be using set_memory_default_noflush() before
>> freeing anyway? I guess that shoudl even be documented as "if you change
>> anything you need to call this before you free the page".
>
>It does on x86 because there set_direct_map_valid() is the same as
>set_direct_map_default().
>
>> > On ARM64 set_memory_valid() just change valid bit which
>> > +	 * leave direct mapping read-only so use set_memory_default instead.
>> > +	 */
>> > +
>> > +	return valid ? set_memory_default(addr, nr) :
>> > +		       set_memory_valid(addr, nr, false);
>> >  }
>> >
>> >  #ifdef CONFIG_DEBUG_PAGEALLOC
>>
>>
>
>-- 
>Sincerely yours,
>Mike.

Hi Mike, Brendan,

Thanks for taking a look at the RFC.

I was also quite confused by this initially. I spent some time debugging 
until I realized why unloading all the modules was causing the kernel to 
crash.

The reason I took this approach was that I wanted to send out a working 
prototype for arm64 that wouldn't interfere with the existing, working 
implementation on x86.

Following your suggestion, I can put together a preparatory patch series 
to refactor the set_direct_map_* APIs to accept a nr_pages parameter. 
This refactoring would also allow us to drop the redundant 
set_area_direct_map helper. I could then rebase the rox_cache series on 
top of that.

Does this sound like a good path forward?

Thanks,
Adrian

