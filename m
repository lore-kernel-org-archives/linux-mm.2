Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C23BC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE928E0005; Thu,  7 Aug 2025 15:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087C48E0001; Thu,  7 Aug 2025 15:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6AC68E0005; Thu,  7 Aug 2025 15:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D32478E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:56:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87D921A0964
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:56:52 +0000 (UTC)
X-FDA: 83751019464.29.0C88F10
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C779C0011
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:56:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754596611; a=rsa-sha256;
	cv=none;
	b=ET09eSsRo+22q/TxtWa3ZAtNjUJkFDanQq/ts5bRGSkMRx4lsNv1x7SpCysWtUd8qx48tK
	HG8N/ETa5pjoQSUS022coDv0BdOrtxEsBcKKU83lGPutxbYoG5qkfC0C+uSVgbEDliVVZV
	GrJX6ay2rB4WajtoT86ghWq5Jzx7l5I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754596611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m58Pon/1OX9O7JI16stGKkxKXvQK3hwgAeLC92X+anI=;
	b=4EJdzzAeJpTKpH9fGhcN1Yea7Ol/qaR4K26VaiCoYxh/Pa85wbJF1b42CepsfNog8TkbyO
	LBXQxHkR3r3TZ1JytrXgrEgO4AxBFTPbjATICGcpzATbuTVohzncOOvKucrtxC8FD4J7/e
	mun9Zpe11QDLWq06wc/dKl4pEZUAWMU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 244581756;
	Thu,  7 Aug 2025 12:56:41 -0700 (PDT)
Received: from [10.57.87.232] (unknown [10.57.87.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF1EB3F5A1;
	Thu,  7 Aug 2025 12:56:46 -0700 (PDT)
Message-ID: <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
Date: Thu, 7 Aug 2025 20:56:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Content-Language: en-GB
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C779C0011
X-Stat-Signature: noab49jzj9oxjnwfzjirdyfx59d5ee1q
X-HE-Tag: 1754596610-175274
X-HE-Meta: U2FsdGVkX18d1fYrCakHKFvJvVYjQ0GT+EgPAhMp4QFkVHRgB7iBaVStyg6ZT34mE0inTbqg0kxtI6QVVc1DRDF0PZzF4lNve3z650glUJ+bPC45q0xhcjIPxRa2cHjztpm7KuGJBiY4dD4hxB4yrjCayFXsHlmVhnwNicOrREf6h5Mny7zRj15UB/jsDvaVSAehdu2iVexcn93K1Y8qQJC36CwvM6raAtx7WLNxZ57ksgfO5m1Cmb62hUwkPMHKMadV3TtzNtnmH71t7NbMk21G+JwgNSO0kTAUxkEKoc2YcX+biPZLndelhrlbQ5g8akNRR0CCmxnztn5mKvBFoezX3fe1/CNUyFYKutUwTtPNSJKJdlOyZ0YICzA6ALOvDX+ZeSvGK8Y0tMoEtv/XkwV6P1ouQnjS6XQdOEFT0asxFLbtLGqiBs/muf06lcKLJDQudfBuROsSEpj+qOwT8hc4en95lMv55b9Y/qb6nU/USAm1kJDplP6N3c3Ly+PuKaZiuLLwedI0PYWPBuwoSnTcomOKd1l8mJQrZMrzOn1vMKynKBlLiO2Au2wivTma2eCwMaj9t452mx9dC0PlR0jliPtTFVpmA/jqFpvy5OxYvyW04K3HLdTmgcopF/guluw56cNv1wJVs3LxnoBPCGYbz6XGRddIXtuz/0u3bjljnOjoRGEufZZpJX2LOqqzFM1jsa1+IXBNAVefcdeoTYvmlLAuLGTRsR0IxXxt9fAYQyZVaJYbddDHM7ji3KmQvhTsDiaHb7IGmgBptYAHvLGQehJRne3iX5sLMhmXUQH8u+buZj495rik6CfTEOceowugZe++ftGhCBGWtKd0pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/08/2025 20:20, Lorenzo Stoakes wrote:
> +cc Ryan for ContPTE stuff.

Appologies, I was aware of the other thread and on-going issues but haven't had
the bandwidth to follow too closely.

> 
> On Thu, Aug 07, 2025 at 09:10:52PM +0200, David Hildenbrand wrote:
>> Acked-by: David Hildenbrand <david@redhat.com>
> 
> Thanks!
> 
>>
>> Wondering whether we could then just use the patch hint instead of going via
>> the folio.
>>
>> IOW,
>>
>> return pte_batch_hint(ptep, pte);
> 
> Wouldn't that break the A/D stuff? Also this doesn't mean that the PTE won't
> have some conflicting flags potentially. The check is empirical:
> 
> static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
> {
> 	if (!pte_valid_cont(pte))
> 		return 1;
> 
> 	return CONT_PTES - (((unsigned long)ptep >> 3) & (CONT_PTES - 1));
> }
> 
> So it's 'the most number of PTEs that _might_ coalesce'.

No that's not correct; It's "at least this number of ptes _do_ coalesce".
folio_pte_batch() may end up returning a larger batch, but never smaller.

This function is looking to see if ptep is inside a conpte mapping, and if it
is, it's returning the number of ptes to the end of the contpte mapping (which
is of 64K size and alignment on 4K kernels). A contpte mapping will only exist
if the physical memory is appropriately aligned/sized and all belongs to a
single folio.

> 
> (note that a bit grossly we'll call it _again_ in folio_pte_batch_flags()).
> 
> I suppose we could not even bother with checking if same folio and _just_ check
> if PTEs have consecutive PFNs, which is not very likely if different folio
> but... could that break something?

Yes something could break; the batch must *all* belong to the same folio.
Functions like set_ptes() require that in their documentation, and arm64 depends
upon it in order not to screw up the access/dirty bits.

> 
> It seems the 'magic' is in set_ptes() on arm64 where it'll know to do the 'right
> thing' for a contPTE batch (I may be missing something - please correct me if so
> Dev/Ryan).

It will all do the right thing functionally no matter how you call it. But if
you can set_ptes() (and friends) on full contpte mappings, things are more
efficient.

> 
> So actually do we even really care that much about folio?

From arm64's perspective, we're happy enough with batches the size of
pte_batch_hint(). folio_pte_batch() is a bonus, but certainly not a deal-breaker
for this location.

For the record, I'm pretty sure I was the person pushing for protecting
vm_normal_folio() with pte_batch_hint() right at the start of this process :)

Thanks,
Ryan

> 
>>
>>
>> Not sure if that was discussed at some point before we went into the
>> direction of using folios. But there really doesn't seem to be anything
>> gained for other architectures here (as raised by Jann).
> 
> Yup... I wonder about the other instances of this... ruh roh.

IIRC prior to Dev's mprotect and mremap optimizations, I believe all sites
already needed the folio. I haven't actually looked at how mprotect ended up,
but maybe worth checking to see if it should protect with pte_batch_hint() too.

Thanks,
Ryan

> 
>>
>> --
>> Cheers,
>>
>> David / dhildenb
>>
>>
> 
> Cheers, Lorenzo


