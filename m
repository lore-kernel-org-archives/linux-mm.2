Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F769FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163F16B00AF; Fri, 24 Apr 2026 10:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F0C6B00B1; Fri, 24 Apr 2026 10:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECFF56B00B2; Fri, 24 Apr 2026 10:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5A8C6B00AF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:19:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1CCBA0172
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:19:38 +0000 (UTC)
X-FDA: 84693657636.20.D76AD9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id F00C3C000A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:19:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GrdIEGT5;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777040377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEneAfJWsUMVLNfN8zo5gCn1CY9r5Vq4Tp2VkL6dJlk=;
	b=CdtkK/ME3cLDVEQ8zc+tGmhPYtZoDnfMq/5q+G63LGmuGxUNRS+UZgOhE36kK2tBAavEpS
	VeuUUdOiHtmECI8tvS0kL4uw/phi6Qgv0xL7/+jq42gR43uQbU1VRhyjDneAjH6O9y0NOt
	GRY2om2Jy1jSZd1hIS1R9hJGsG310zc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GrdIEGT5;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777040377; a=rsa-sha256;
	cv=none;
	b=qCwodyJdS+FKUWSJ1HdvKpZH4b/SFVjQ+pusn46YoZWTelyEJLmKT5iWgQOnfC1N21Sz5z
	KaQAcuMY2lnFAKiLscME/lEyygKcVNpmzN2/9BZYs12GRASsEZ9kR0Gl6USH5YnuNCN16s
	JCGhF6Oja0qvrBftwkawkzdO4miy3DA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F52460128;
	Fri, 24 Apr 2026 14:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D526FC2BCB2;
	Fri, 24 Apr 2026 14:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777040376;
	bh=CxHM58NpmQrbLpCcUPXfUThwYQpzZAqUhNDe2CK5d54=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GrdIEGT5dd29aeRSp9p9Xj/eqqtbMHDNGU3SqHHSNemLYtVxmK/iokYP3Xk+RTCcC
	 OyrtHWW9npnZScQ958cViCG6tx7M/zz/bj5LwaXeUzhs5rMmAUC6fKinkMLeZbxbv4
	 zs19Cpf6pvfYqFQQ79DJyG0mP1YE5VpAPtB/DSb5CTWQ05zVVyJvUoCp3C+L5zYyN2
	 PoMfFRXHPJWFBjRMVEPacWU1d3vaB2MxyQY1Pv2jdbW+90z7A/2nwWt/764WOA7MIN
	 9x1MZCjjyx8JxlWTh3K49J7IUP9EcHx0eJALHygs/tizIuycfm9LB3KUbXCm9fMH7z
	 qmJIyTgr/IQqw==
Message-ID: <d17188e3-a710-44a5-984e-689a127d4c1d@kernel.org>
Date: Fri, 24 Apr 2026 16:19:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <2026042303-vendor-outright-b9d2@gregkh>
 <20260424063817.552a894d4b5bfa4de40792fa@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424063817.552a894d4b5bfa4de40792fa@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qd8hgaemuc8kcp7xun5t9rfapb37zsnm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F00C3C000A
X-HE-Tag: 1777040376-105434
X-HE-Meta: U2FsdGVkX1+Oh4AKt3mcTpkvrMh9hQdg8Gw7OMBXopjD1OKYe5V+lUUSoqX5QEJhaV5xcK642n0zyauCQ0ohu8IVCwjdVGG1HsF/zx2jnEsGTY1+PakWawhbYabv07d62zfojfGGtTZqraRtBNabnGBvEL63xroGQH+VHr39CL+ZQK4hc7O0xdp4QReN8iYsTtwdp8B2G1BogloFnN8iEM9PVzwvIH/F1HPZznTqpGB6YJmY+iwgzDNKEQXX+oEjBqCWcIXrrp8HCoAjbkzbEucEJcKmTLgGv6kgxavOPg564jUlRegNYIy/pA6//u4WcsvMYp5gQGDtCPdn+07YNAmtBLRbLUyKMuKFN6ijMdUwoVHOZbvf60bT4a0PD0Wp//yLoDEK2gkuNxYyXJ9DXWzb8Ari3FvoQmNWn9NeOHgsfI1BUP8xFvb12nBH8LcGgiBI4Zcqxi3tHP3K5QUD26xQkAY5VM0CeFJ5YVNR1f/b+o/ewi4vde9voOgeyQfM9f/D54vj1PPl0yQ24+bnW6PTx4IFp2u+jZLwmRn81sflEwmBN7QCF4jxowSGWkF8OsWyroDXaVFhnHfPPZnZMW+3lbbl5vRblNvB3cHYKnkk1MyqkWkZsUNVjQ488j8FjMGowFkbreOJggSMrDtZtC5eBmslZ6FjCxam23nC1I8eawlT/kN3olenx7NILROjJDbJAiRVR+Tt28PwMX8NVqXFy4ceAHgvSkONHrzTNLz337BD2ctLQP1SszYJeH5U0NkH98eKzhyoseBUx9PlA9UnggWrUVtV44gP1nAXOZ/WOg91ddttaOAWb0DZMhjebh17/PE/O5aIGqJwXdyKJFDW5t3x6wCHNWjgDb6LT+OvsnCvXi7e7sjR/Enl0ZUQvjBvQvv9Hk4mKyPv8TURgFyUwFS5yzCr4viobr83lxiT3H5Ya1Ew5753y/iKMLkAixap7i0TEVwGkgv525h
 axGSx0Ak
 dvDqSdQrlUeSj9j0mleTZiojZ3Ag+lj//L0VtKSt9A0vQ3871Lf7lxTvdQdNUKacYkCgvtPc9/4lxfMbJvg5re5PqLGh4x9rithvpfNyRHZFsLDKGgQgt/p+35LvJmtxCtOVfxtnLoNzxjxu/jxII8d0q93e8eTStYTvSwhUBnCIdiqZYHnOSjq30CDt1sfSQ8MbvOTeBErc1G5danXd536ZgGHGpyJhYFmitHUT9cuyWVYfO4t7/sK64BBcvYYeQteIILanx0/vDPB2c7YrTouadmFpXlECNkz67iPdcIqnihxoRyIirP5wJ6pBb2cn34pUmqnuKUiR/HoFQtboKsmuLn2K8O1HfwmDNnM0Hm7+WWjRpOBLJtQ34316DHLv2ZeD6xQ8eaEwaGKgEM+m8cBDJ9X3aADRPAdm94X5QTPG8DLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 15:38, Andrew Morton wrote:
> On Thu, 23 Apr 2026 16:28:04 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
>> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
>> get_page() reference for each page regardless of foll_flags:
>> 	if (pages[i])
>> 		get_page(pages[i]);
>>
>> This is reached from pin_user_pages*() with FOLL_PIN set.
>> unpin_user_page() is shared between MMU and NOMMU configurations and
>> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
>> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
>>
>> This means that pin adds 1, and then unpin will subtract 1024.
>>
>> If a user maps a page (refcount 1), registers it 1023 times as an
>> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
>> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
>> the page is freed and returned to the buddy allocator.  The remaining
>> 1022 unpins write into whatever was reallocated, and the user's VMA
>> still maps the freed page (NOMMU has no MMU to invalidate it).
>> Reallocating the page for an io_uring pbuf_ring then lets userspace
>> corrupt the new owner's data through the stale mapping.
>>
>> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
>> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
>> symmetric.
> 
> Battle of the bots?
> 	https://sashiko.dev/#/patchset/2026042303-vendor-outright-b9d2@gregkh

It references the

	if (pages && !(flags & FOLL_PIN))
		flags |= FOLL_GET;

I'm not sure if there is actual NOMMU code that triggers it. For example,
uprobes uses that pattern, but I suspect that that's not a thing on NOMMU.


Probably best to just squash:

diff --git a/mm/gup.c b/mm/gup.c
index ad9ded39609c..44bd28cf6e00 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1988,6 +1988,9 @@ static long __get_user_pages_locked(struct mm_struct *mm,
unsigned long start,
        if (!nr_pages)
                return 0;

+       if (pages && !(foll_flags & FOLL_PIN))
+               foll_flags |= FOLL_GET;
+
        /*
         * The internal caller expects GUP to manage the lock internally and the
         * lock must be released when this returns.


-- 
Cheers,

David

