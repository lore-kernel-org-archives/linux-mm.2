Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3404C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E670D6B00F9; Wed, 29 Jul 2026 10:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17016B00FB; Wed, 29 Jul 2026 10:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2CE76B00FC; Wed, 29 Jul 2026 10:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B530E6B00F9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:20:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B76E806D4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:20:07 +0000 (UTC)
X-FDA: 85042023654.08.BAD0BC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A1719140002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:20:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qbnf2thC;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785334805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ToiJoF4NcsxRlbsxS2U0VQ57R0XjAeQgD4aiE3GQTgU=;
	b=zoPDeuYWM+wXllbRuUWQ3SUdRT/wkq72irtAW85Av6x9QUE+Zt6HMaROx5upH2xQu3XDPH
	IdLYddUenBeOZNQF/mqPBRxWRgbmeUOXFCmppexy3M0yJW6feg2EyA4S9XcADP4SSnM1/H
	rT+yb3C0QqaRlvVXWGdoLupf5d+58jw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785334805;
	b=O9bDyOUE51RbdBg9uKhmsCt1WHjk9OVEDFprmzktkQTb3kJp77/R/dnFktyadO3ph+1kCb
	Q2eb0TMXcXY/bup4I8Z5bsFXoRi65SQWRfqpNj+ieZ+4YauEPra5ViOzwddOVbNoLEtdxw
	K1neTjCYJCXloiY2Sidv0TaNTdG45FA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qbnf2thC;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD51E4357B;
	Wed, 29 Jul 2026 14:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7484E1F000E9;
	Wed, 29 Jul 2026 14:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785334804;
	bh=ToiJoF4NcsxRlbsxS2U0VQ57R0XjAeQgD4aiE3GQTgU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Qbnf2thCmDftHpU293Cjw8f+lvQqn3HXrlqAxa+6XB7oBenqHteYwSX88ZeqJZJ3x
	 xcOYql4hyNOsX7Go1UZO9BQIFfeyGo9BOyt0M5W8+BiTH2aSK6V5QA41+g1q8SWpLS
	 IOnJJzNYleeMxT5+if5EdiAX38V+rB7wFMtDMZlUcP/aLjrIFqorv/heZaOrbndoif
	 gxtdY6a/n4/fRt2tcEsuf2XuLXQQMyxJnMQgv2O12AUkbzP2mZlhhpJlfQd/8y3xXV
	 t2KDAoIQMcPKqkZi28muGaVdiRqw/V+EF7w406MnK/VV+0a05+iLaTGDX6LWPetjG0
	 iOPMTmp00QMgQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 19/21] memblock: make HugeTLB bootmem allocation work
 with KHO
In-Reply-To: <amjqwKoF0XrvYw9N@kernel.org> (Mike Rapoport's message of "Tue,
	28 Jul 2026 20:45:36 +0300")
References: <20260725172133.4018491-1-pratyush@kernel.org>
	<20260725172133.4018491-20-pratyush@kernel.org>
	<amjqwKoF0XrvYw9N@kernel.org>
Date: Wed, 29 Jul 2026 16:20:01 +0200
Message-ID: <2vxz33x198tq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1719140002
X-Stat-Signature: gue4p49m5ifrxwpfdb7ccqde4m71eikg
X-HE-Tag: 1785334805-272812
X-HE-Meta: U2FsdGVkX19hgP/Nw9PexrkTuh7iASSMF9RSGvu0BMycxohKoAO//TTNUEmAEs60YUylcvMCmK6z9tb7vwaYC0mYTvkJCxFxY7UllZpYcFSotODerG7NMGgoVsor/A98JlOuB75IjbbRKRZhxIDs2d67NSVcLdqne8XEHfbaXzMTTTqP2ky2fzJC396KyrmCK/LdyiUzrYXlp5ezyGPjTYoHKjE9OGqCxQw2LfDAHAA8pEu9pGw0sR/m02TmR5GUIiAJyNIpfCQcHEMpC1vUephr5qYY6D7IS0KD6c4K0qw/1OIW82CbI0Zp0MbfTwTF+sEVCXoLKXGnbpjJ1K+fKHDbUkg2lnqmxSSNAhiNjgf8S9X6xaqYGDpyo6uGkTWkPszs7NikVRGzNv5DCzFe63HyWEn66U6BlUDOeDZmkc+/Q6VnzaB4H8Bf+mOQYXVOpuWb+8T41ThwLjBVtLTbmyC3FKOuGnq6JjYY0Z3kwdQmSuUquklOQ5ffw/YPAEj2cJkqFqaWLKll76r1s/JdH17rW0ECE43l6Q7FUqSX1jnqA+WiuZUSuHvvTMj9mXq2P0n0ttE4cS/+iCeqVgdDBy1ENe7aiG3ebNuSMWEGUNODl7oLPBEAWKMZfAUFoZ3KIKTXDHMdvU5uP8PSeLf24NLVQfW7y/YQLMLRkPSjPc3Q/i3luWEMknM0+mfI09a9SVqmoQO40tIma0PycZXpHOKnV1mNqxn8jX7aOHo5j83U0SGp33hKoUyhwFAPlvevYga+Im8fjNULJwx4sBGesZBQbAPMHqcY9SNCveFTQiYW/4I8iIhaLN8To9s5ChBum1RLTSQOdKWi5uAa4ROsKSKKMTFlbIqSXCqeTSMSX7wxjnTLCKY4W45vWF1w859SeBzZfaIVY6nbEBoCK4FRiZrksxfanfnZjFeuV1Et7WlSWoReOu5q+ueJfr4EQHrMR576mIqzf7X/WtNl2Qi
 3uXIMXad
 S5ftNUERRHgQS40gLz/8mkMW6s/vYUUO9H8SK1NJymlX6myYUnDKWUQA0kOcTV7IwNTjn268AOwfO/WcCN121v0QVUj19YxdG2/wpPQcr95Tf7zf5qYi8ShhrYvLPuojbufd1rMM/4xJldRoMWS9sESvFS3t8pp+hiZG7EkFwsVn7e826ocsQp2BKMrf12h/g+kxhqUKpZhdXUPueyX2JQgjJOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28 2026, Mike Rapoport wrote:

> On Sat, Jul 25, 2026 at 07:21:19PM +0200, Pratyush Yadav wrote:
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 8b2e551435ae..ff470fd0fd10 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -19,11 +19,9 @@
>>  #include <linux/mutex.h>
>>  #include <linux/string_helpers.h>
>>  
>> -#ifdef CONFIG_KEXEC_HANDOVER
>>  #include <linux/libfdt.h>
>>  #include <linux/kexec_handover.h>
>>  #include <linux/kho/abi/memblock.h>
>> -#endif /* CONFIG_KEXEC_HANDOVER */
>
> This breaks memblock tests, can you please add stubs for these in
> tools/testing/memblock?

I swear I tried building memblock tests but somehow still missed this :-(.

I think it is because the very last thing I tested was a boot with KHO
disabled, and that's when I discovered this.

Anyway, will fix in next version.

-- 
Regards,
Pratyush Yadav

