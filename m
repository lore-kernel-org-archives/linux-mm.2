Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC513C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C506B0095; Tue,  8 Sep 2026 07:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04A26B0096; Tue,  8 Sep 2026 07:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C198B6B0098; Tue,  8 Sep 2026 07:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A46086B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:53:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC4AC1A05CC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:53:35 +0000 (UTC)
X-FDA: 85190435190.21.188069D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4934480003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:53:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOvgWczj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788868414;
	b=Ev9Pt0BIbJvFI2UliJHrkFh7MDUbZ6uorJ7twsdC6F0Ruho6nFTgPX3vYU/IuStv3/1Q+H
	gNPyRoKCqLwpZK4yW3Sx0LbDv1b06dz3jsq7ibRxWvEY+mYsWZ1zBRFOlX38DlcRL5RHP3
	kf0z7CwRPNG4Ttc+46DJEAklvdQFdxM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOvgWczj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788868414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgnUvaODkORtnKYaf5ZZjujJr0av+pDqX4ZqIG/SHoI=;
	b=xABzOplG4WKu9iPSL9qR7WhB9cQfzpbNbV/Hc2RBF8H1qpkQ/QDdTTuekecnJuKgtpD48k
	JDZcnhWQ+pMVRfaHUxMU80SlIWiIjmTKDhp/UBQ4e6NAlEdQT3NCyY7BScm3Xed1N7ohnx
	PrRdAtmjyDJ6d8GV/nF3G7EE3r74D/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3113460A99;
	Tue,  8 Sep 2026 11:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A271F00A3A;
	Tue,  8 Sep 2026 11:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788868412;
	bh=TgnUvaODkORtnKYaf5ZZjujJr0av+pDqX4ZqIG/SHoI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FOvgWczjtpAGFlyIM04XPBgIUoYgQRRH9iQaS/fQqiEifiriUQHpKjSKDBjqk5Ie8
	 0oOr0sP4NqKInOziq9sP+fXMPoxBG709B47qFJzEcqfb9gGfAMs4RWeAqLrYDJ2b7j
	 1UFT48gWzZMcLwpoX4kX6BvB2PDJ55w4rNIU1dpiIbmNISjveLAaWpEGjM66hdkq1B
	 8KwxB0pelLRjAa68tHEvtwkXApscMwxQFAfkbhtJYkgDQIL6bKVWQWpQw6PTHjHaft
	 Xf+3/BWJ/iYReJCxPvtUDIGXjw1R+YmPTxpvghklWlpoU1JsKCOM1GmG2xHkxMD++X
	 HQNs7u3zPqTXg==
Message-ID: <71218174-ddc9-49e4-a920-d211c169aa50@kernel.org>
Date: Tue, 8 Sep 2026 13:53:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org>
 <a98df077-3e97-4eea-8bfe-470bad9ff9e0@kernel.org>
 <ap_vkSK_efv7ab90@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ap_vkSK_efv7ab90@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4934480003
X-Stat-Signature: m6w3f4tyaxrof9r9e7j1z1k3fnbwp1zt
X-HE-Tag: 1788868414-384820
X-HE-Meta: U2FsdGVkX19e5XtSFTbcX1fxHbtMjGGf76UC4a1qb9/wi4oCwDnp5L/RtAHAHfviqzD8e7dzALS8Q37qR6Q2Dd4U7g/itJA5lkG27WJojDkfRFNOVsf/8gHBcl3YR9ODH9DfY4BFqCytCQeIx7jsOeWEiANeAekzqqlEfciLpf9zxpMKHCLP56IQVKBwZEiB2sQcD0D/ckd/B7IdBsZpOO9gnC/OFHx9gd3xvZNLqXG8In6QBNDBbW9qr/6E9R5jZmjvG2eWgAnU4oEIs2eONm/7AumzlntSWlPZ2Nl+95YaXrUNAg37wnbvVAuYRtCEC4KiqDvpHZ59OB3OZYAYPVyZH4NVQSr42lbGvd2mlEkkB6GkGQk2N/hvmbx+6jD7E5lzTZ2sV+x3pYUzMvlVkemlOervFGeoZYadB2vDfkXY5MzbTA2JJDcR6nYRvUOQZfFFrBiwAvlToQj5qEvkl6vXK5ImvNpsZXfrdETAewe5m+mU9yjqscQ4gaycxY3j1kq5IdlNEd19jfvIAXbjPZz+TThhn4SWdZB2N2d4FlShGwUGPXkQoTvx9Q6lpYAAWjiJDBbx3VHwExP9EzOKKxpEWweo6/o/XaQfVvy3zLacmKtTrQQ1tN8J6fIPdBn7E/cBEVajfF0WYuoU+FyDlVhsNHoSVbG1EG/kK7nBFPRWYN+6q6J0ZJwfSWEXhX95FZbj+2jEbzXmeSmPLT7GmrsVn6H/Lv1i9m0M1hpS1CZtUF0I/S+OYll5VIY8XzoBCM6tuRaB9ndBuJKXN6uyEchHHsDpzK9hMjL2rMiawuuZ11MC5yt8qHc0w5vgBTLC2AtFniKPkndHspUkAVQ6eGGfnO5hCiwkdZLhL+5k2PlWJmQw3iY5zfLVq4Z+uvN9rlPfPiM29V69y1yS9SazHpzPscSwWuU2taxJaBP612Z3NSZgHhFAJ0/49tYxaroWzb2q3rhzlY90oUEXuJO
 Lv0WBvOa
 WqzmtBwIPhMqmxJQ3N3wl/4fGGoKJ4qesUmn/7ae3dNEeN4BvndWAmtpDgo2pM2RT2FTHT7ww1yWepo2SU+6Jllr54PI8hoByj15Ye++ZLYRJJ81ARYo9TerA6UUa+kaAJ69bmpHDf5j97cwRC4USZq0KOmmXmMA6y0cF/5XnTWtS+FSkiCvaBdueiYXQzLTBQDAC+Ys9G+SqtRV6q4F9Vd3yZWaXFJsc4T9JH08100Rw83Ot29rXtNVjyEhMfe9RyOmzcfpsTdCzxDOCui8pQHz/3BlduA64QGPNmhjFrnOha+pZxCxJpT1v6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I'd assume such a case cannot currently get triggered, but there is no
>> documentation on what's supported and what's not. Or is there?
>>
>> Imagine someone performing an update on an area that partially spans two PMDs.
>> While splitting and updating the first PMD could succeed, splitting the second
>> PMD could fail. What would be the end result? Rollback? Does the caller have to
>> clean up?
> 
> There is no rollback in any of set_memory implementations. It's up to the
> callers to cleanup the mess afterwards.

Good to know, let's document that ;)

>  
>> I'd appreciate if we could add proper documentation with expected semantics.
> 
> I believe it's more in the scope of  "arch, mm: create a generic
> set_memory/change_page_attr core" [1] work than this patchset.
> 
> I can write (or maybe even slop ;) ) a doc about set_memory/set_direct_map,

I prefer well minimal and accurate docs ;) Who knows, maybe we'll even realize
while writing the docs that some semantics are weird and should be changed (some
architecture implementations adjusted to not be weird).

(I'm pretty sure we'll do, so schlop is not a good idea)

> but I wouldn't want to hold this because there's not set_memory
> documentation.

I'm fine with documenting it separately, but we *really* should start
documenting the semantics as we touch+cleanup this mess.

-- 
Cheers,

David

