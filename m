Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5339DCA5FAB
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 23:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270796B008C; Mon, 28 Sep 2026 19:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 221E96B0092; Mon, 28 Sep 2026 19:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1384A6B0093; Mon, 28 Sep 2026 19:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF15E6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:42:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E6EE12035D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:42:39 +0000 (UTC)
X-FDA: 85264798038.05.6FD8BEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 90CCD4000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:42:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dm6fYjvm;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790638957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/uTPNqgSmBF9rh1jEmI/ycOHBrfDvicp4X6U1S9Cy8=;
	b=XlUU5Umu7fN30jvv431RP2LUaWUx9+H7fEPGcaszkgppPS7b/yG30t3Di9vi/UeF6WLA+Q
	UfswYBGO7iEiUOZInb+JjxLnMIMzBimp7yyB031jR9+KEwFy5D7LIQkOxOOqlkOY7mwO2O
	8WA4Pr5Z1CfgGND2jckmjgIM8Pxfus4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dm6fYjvm;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790638957;
	b=7H2OfTC4Mjg4dwPdQSEhq19/JL+m3vDH9K/3oDiAvCllPqw3UIFSAhwaB4RMHf9kkF7r76
	gA4ilDco35hrPsXca0kAI/VFijaLYYpa64Vtar9N7hUr+v+c1d9VU8l1/ImdoTm0JF9IP+
	2WRKU4ewEjJYDPc5Cobz3wIoY02qgUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBC16600D1;
	Mon, 28 Sep 2026 23:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272BE1F000FF;
	Mon, 28 Sep 2026 23:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790638956;
	bh=N/uTPNqgSmBF9rh1jEmI/ycOHBrfDvicp4X6U1S9Cy8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Dm6fYjvmUaayF6/hcSdccsykXlMd90HLFeAOg7Bm+rRrwkFmeMOFFEPqVhzx1V2eA
	 Gw77w8KXsEHK1EjYWxFNJWHulUSbmLi66gSohUj7CyisqeSnvkBq7/d5AP7ogp4Fd2
	 r/6N2ErCbxyj7fkzPOqSc45jLW1qT5bo/T6Ynq24=
Date: Mon, 28 Sep 2026 16:42:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bill Wendling <morbo@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko
 <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov
 <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees
 Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 thomas.weissschuh@linutronix.de
Subject: Re: [PATCH] kasan: add KUnit tests for __counted_by and
 __counted_by_ptr
Message-Id: <20260928164235.041803152d3f340d4c59e59e@linux-foundation.org>
In-Reply-To: <20260928231737.2092716-1-morbo@google.com>
References: <20260928231737.2092716-1-morbo@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90CCD4000B
X-Rspam-User: 
X-Stat-Signature: b1soixtznfnf47urc3orxdfq6kbdqmw4
X-HE-Tag: 1790638957-540995
X-HE-Meta: U2FsdGVkX1/J/OfnQMlt1kYD8r/ZB8NTHFMk6mPVmxnYMdVfw/s7624dw8EZE8Mj9ZaA0NcUx1z9YklYrZBcPjqunhkOcnyVL9Ce5Hhf7VxppRLN/VbHXhR66O2KYf0fUcdamZn9eVLIy0CwfTOZ+QeqsSuHpeVjE8M+7w/ewJ9ho57x6lskfTj8boSOCnTl0b5WUXnW/tdwDOsQ6z4ZG4b9uwieEZqfAzUgVX1rzGPAOJT6H833iIYmWEMLKX6kCLbjYzQh7fvvMm7NHbntw4DvaFoAX2ftAEX58NPAPlQByXEzQy0xEIMughF0KW/vzt0iJrj8UziTJd8Ea/toQ0QxlTRWY5HD8Ymp5grfkcsWFJSRSjGfZs0WbGqshX303Oh8OPB8P9qjQ0CdUilVFVrXK+ILACVHFVL2nNMkwioCuxIK+MbHSnJT0H/8dkVDg8qPdj61URhettRDuepxt1dWZgzoeAcnz7UVth3URabDAlbOLa48OR28aui1ZcdzaPFOy14xbLycpGf1D1LzBUb+iTGmQ0WcOGFF+EdiLHQW3Qu5eKzFXKxeJZFt4UeTwtOzRO7bNBUige8ijCyn8DEYkFE3054Bj4PNercrtDkYA55Ol6b6ljssNjFRPXDdta0NPBVmRGhZJpmFkDJKfX7FvBkWlrj8DYD3keK93AyugT9qxJz49tdHKGuD1E4HBPo/57lsOl3gO7DhqAnZga1cOv6Ax/hpVWQ4o5fgVObyo/uXcu3vw9uZH+NFlByyGCp9CfiBGDM7y+0idi+r+AgStqhXrmLgAyahNVR+ktptJrXq2Bhb/0oaCpzbYIDOLKSCZkPaz+zeQpoFPm83XD5b0SRDVh9K46+4c/kSHGXSQZVMVQu9I3m51wNRqpT3f72Iua27RXJ72YqEwnGIOv9k0oURdVfDloIA3dWsZUTXmqQSwrz4wv6N5mOGjMhWlJwaaXzarq0yhe5kTIf
 vgKSbc9V
 BHRvR654NgKY3MHV/qjQiZOgyNLjpsRh3CsSu6G/hOE2JzN1mVh/E78JwooWW2fig40Wji1FKsfRKp6O9E5E5mGK1pFb+pfWdeQoJiuS/ttVNzpjx0wWE4fcco6mN6oG6d82d3uhpfd3hPJpIrD/QL8FDSOof/D1jGSxQBiTsntCElOK0t43Nf1J8YufDB6O3YAdx05p3riYA+Uj5ONlGUGDW8WD2ROCkHme3ATVFhTnV1vO7TnfrbPBNJdyxM786LUMNpj8pFVXQm/vpt/+YoR/Rlvi+97hBVRoE6mX9azneim5L6wdpUoEVJWNwyi/du1h1tFk7zHHYyGXIbeS0loNlr6KelA6ek1TjHUp/CQ3mTAZ4CzL/p0mZfUNnUzqO/dZ1zWTYJ+RjHF+jt2vgN5yRxP1SpEaum755Ch+wKmpsDDZjmCIzSIIegZ6y58daD5QD4I6u9E+aCVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 23:17:37 +0000 Bill Wendling <morbo@google.com> wrote:

> The '__counted_by' and '__counted_by_ptr' attributes associate a
> flexible array member or pointer member with a struct field that holds
> its element count. Supporting compilers use these annotations to
> compute dynamic object sizes via '__builtin_dynamic_object_size()' and
> perform runtime bounds checking with KASAN.
> 
> Add KUnit tests ('counted_by_flex_oob_access' and
> 'counted_by_ptr_oob_access', guarded by CONFIG_CC_HAS_COUNTED_BY and
> CONFIG_CC_HAS_COUNTED_BY_PTR respectively) to verify that:
> 
>  - '__builtin_dynamic_object_size()' returns the expected byte size for
>    annotated flexible array and pointer members.
>  - KASAN detects out-of-bounds read and write accesses beyond the
>    annotated count.
> 
> Allocate the test structures in 'noinline' helpers and hide the
> returned pointers with OPTIMIZER_HIDE_VAR() so allocation-size
> attributes and compiler optimizations do not mask the '__counted_by'
> and '__counted_by_ptr' checks.

Thanks.  Are any of Sashiko's comments pertinent?
	https://sashiko.dev/#/patchset/20260928231737.2092716-1-morbo@google.com

