Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8913BFF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEAFE6B0005; Wed, 29 Apr 2026 10:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2576B0099; Wed, 29 Apr 2026 10:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7986B009B; Wed, 29 Apr 2026 10:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDAC66B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:23:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77508401FB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:23:47 +0000 (UTC)
X-FDA: 84711812094.12.4003B37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 87DF01C0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:23:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D+d91KjT;
	spf=pass (imf21.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777472625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eER2GCpD8B7GlhmETIiRKrTfvFHwkGHJ1zYSjhWxsec=;
	b=TQXBeF9fYl5eQzncXCV/lRIH2TXTsTgMjpdba1i5OFmbc/Ilf3+oouf1MlPxsS1FlHZWCv
	3WyTRr082s3XvS3oKLynD0BxHd6fKupd2CNVsgD7p36OO5Wn0u2caoAMQ1Su+VN4Ey8KEu
	eUVIde8AmRPfpssaBviLbpzqLHTZ5Kg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D+d91KjT;
	spf=pass (imf21.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777472625; a=rsa-sha256;
	cv=none;
	b=AJsObqOivsO0ZwVt0w31ScHci6v+YyCwOCNgPigGd7P5DMudkAvAhgFirbBXmgF6Os2nQ7
	/uD1wS5NbacAoPvgkafGY1+D+7riKLGVok9DOKrwS9qJVeKpNGawlyVRArFNM568nu0lND
	WLBB5EK9hdP1AIBjDJcpdsPCxYyH3gQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6FB36024D;
	Wed, 29 Apr 2026 14:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2A3C4AF09;
	Wed, 29 Apr 2026 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472624;
	bh=1DoYAyGOTScVVD3GXpdNNQST/38xq+/hMaqnmr473Bs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=D+d91KjTTrM+lBnQ44Qx5TmdF/ui8FYG7riluu2LEkceRos9M2RXCy/huWD2rHFbk
	 UZ0bxWyoCYJBzLVkVf2ZhXbnpzm/XXLxEYS7qjdAvLnsraGoQZe9UKyJnTuJgT974q
	 j+EkKT6u7bZ4J4CmzpGeolUiepyZgE/zABzHbergVuaLqEVNd6YD96dpQQzMP4Bzju
	 gN2G1YFkAt6HF5fb0NF2fHHdLnzgbb/Eay7BLp+q3r+uTOMXWyP2eFu+ml06IRx4AH
	 LHnKjiw12g7mYF/wPW2KJUDX1yM+xxwO5xeMlajk12CKWQlU2G3bYJsLxLi1zVDZ9R
	 HLwOZtcL0ayew==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C6D6EF40081;
	Wed, 29 Apr 2026 10:23:42 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 29 Apr 2026 10:23:42 -0400
X-ME-Sender: <xms:bhTyaRuedy8IaKVEUb6zYplqea_IyrVJ49HkQ4RUPpdmpAElw4kXEw>
    <xme:bhTyaVRnbbQOqYIc9uQZ-srPlIHJH6Ecz-9CNLTmo6l72SQrfGLC7rXy5RwNoSO5c
    PfLjljA9mfzOFgztLYmln-dyEK2WRsD3kpgdEUY7fyEOc7nsh2YDdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgeeijecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrnhhshhhumhgrnhdrkhhhrghnughurghlsegrrhhmrdgtohhmpdhrtghpthhtoh
    eptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehkvghv
    ihhnrdgsrhhoughskhihsegrrhhmrdgtohhmpdhrtghpthhtohepmhgrrhhkrdhruhhtlh
    grnhgusegrrhhmrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhm
    rdgtohhmpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhlvgdrtghomhdprhgtph
    htthhopehlihiiphhruhgtkhgrsehgohhoghhlvgdrtghomhdprhgtphhtthhopehsvght
    hhhjvghnkhhinhhssehgohhoghhlvgdrtghomhdprhgtphhtthhopegurghvihgusehkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:bhTyaYQqbQnVIvDQGr_EIyoNqMUxhwXG4G4jtXeNWeDmpwZFsfnQFA>
    <xmx:bhTyaZ5UU3sOLPELciR1S3yUNipryJRU-wfpnldnvQeR7ny2GQoX_A>
    <xmx:bhTyaS26ba8LHTkWKJhLTLhqgOLfm1ol0gbWKJiQ7XNXpSI0HVb3_Q>
    <xmx:bhTyaWlPWrFeCV-JEl10S10qMtJqxcSJLGeaFD4PPzxewiMEq2oA5g>
    <xmx:bhTyaYj-PQwy2tOxiSz7NljYKJXKPYJnt1JMl7HQF9Vpthrm4_c5Y-60>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9D519700065; Wed, 29 Apr 2026 10:23:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Wed, 29 Apr 2026 16:23:22 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
Message-Id: <1f9c1ca5-c15c-4a08-aa8c-cbe64f7f205b@app.fastmail.com>
In-Reply-To: <8a315ca2-3754-4a66-990e-55b85191aa6e@arm.com>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-28-ardb+git@google.com>
 <8a315ca2-3754-4a66-990e-55b85191aa6e@arm.com>
Subject: Re: [PATCH v4 11/15] arm64: mm: Don't abuse memblock NOMAP to check for
 overlaps
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: px7xcb8d3ct6bsbhhijpr9x3pmj7fzun
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87DF01C0005
X-Rspam-User: 
X-HE-Tag: 1777472625-612588
X-HE-Meta: U2FsdGVkX1/gnMNz3RAjjZjHCCbz4VBKzoQhQgLiRhtxEifT9dQ4A5Nzeblly85xISQRM8Dn1BJis1qBv3hY1YERsIXWU+OHHw+bDBVqm9WOzu5HH+3G6BmybLsVDKJiszrk0qTJIA4DUxY6NqBKhXTOr4C6CS9mk6zfsVkCC66zMw8phj51VMQ12MyLGlV+/cqSDgtUFCiad2893ZaYSngIo2Ccg5TpllgLxe8rnAV6R6E4ouYctUR9+y1pSOlBeyxyP1ScUzUlYHcBs7Vc3w9Z+fQENED2+pNonyfzgwo4oiuOJbMrlebhvJBZkvQVxaQyBQlxBJvRx+1EZWCa1pbH+fWJPY1YfbYeRNQO5ibosXtg/8D4dt1PpybU+feCJpK0UQB7ALH7lkOCJkD29Zlf7R/2ZLifrxCF8FhdMwM5sVnA/1Pa4NzQTng/aomdibt25m3DnhPn2ZkM345X6M/yx+G/hyqf+gWSDzpviC44bD4DGCmXWx8udtVXR4u9jpRvgdM+R8l7e5Gq+dUQ3wfcGQ1Aa3ukJ4GdJUOxzEA4NUnT2xw8qd2/6rFXkMHHrEsHa8jbSkNAmHiSYSbdwHJSK5Ik5UsbCU1hBoQK/5tFDBVkOYPeywxgA821E+vjPLO2qqyUksefXMf1TrpkhUJAQwYmMJHeOGqiMuApUp7ZlVzv9kYawZyWUNm37NLul1rgYfbeBvNYTIhlsyGDNEsldXWeJpidqEnYQV0/I07gdB5CMuonTXoF85vPX7Q35q1ui6VeRZUeQRfqOy+q3Rl+7jVr/feTO30sMaWa1/raYJL6wLXDO7E3GaLpbyWH7OKUX8orBq9XLob7hAXElyyN4tw5gOgvXZjAnjVGI4t5TMmTTQmHarj7IMEfNUjMLX4aUuJR2cLoEIsvpVyQq+1ISdxEyEGIwczhwmdyCE7IoEddcbBEH3fBzrTrYJxNSiSKpdn7JvZdTtEIAEq
 vZ69Ij9W
 rVXNwE1GQX0POoncgzBXlqtAKuAMkyIOF42LsS69TwMtKJAZiuLe07ipK2Qb3vs63I5n7xFYvd5ktE8DL3+xuCxD8YqoA/DMWw/nXAn5eG8Ibtmgc6XO2luF2Ls8i7gOZjmSuOWRD5oLGotYCsCRokTE0nO3rIMUenHcRV58euzQISdXf2lYPZ3k7DP8ILB0TE8EN1qLOD0eQENp4YTc1L9SB1NERxO2JHtoOhybskWu6dHuU7JYyg/0JJn51zQiCXnsN9ExF2MTzB7FIt+sSoYL5xLx1yswOvRiQ+rek3EAoEhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 29 Apr 2026, at 12:54, Kevin Brodsky wrote:
> On 27/04/2026 17:34, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> Now that the DRAM mapping routines respect existing table mappings and
>> contiguous block and page mappings, it is no longer needed to fiddle
>> with the memblock tables to set and clear the NOMAP attribute in order
>> to omit text and rodata when creating the linear map.
>>
>> Instead, map the kernel text and rodata alias first with the desired
>> attributes, so that they will not be remapped later with different
>> attributes when mapping the memblocks.
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  arch/arm64/mm/mmu.c | 24 +++++++-------------
>>  1 file changed, 8 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 5e2348b15783..1a4b4337d29a 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1148,12 +1148,15 @@ static void __init map_mem(void)
>>  		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>>  
>>  	/*
>> -	 * Take care not to create a writable alias for the
>> -	 * read-only text and rodata sections of the kernel image.
>> -	 * So temporarily mark them as NOMAP to skip mappings in
>> -	 * the following for-loop
>> +	 * Map the linear alias of the [_text, __init_begin) interval
>> +	 * as non-executable now, and remove the write permission in
>> +	 * mark_linear_text_alias_ro() above (which will be called after
>> +	 * alternative patching has completed). This makes the contents
>> +	 * of the region accessible to subsystems such as hibernate,
>> +	 * but protects it from inadvertent modification or execution.
>>  	 */
>> -	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
>> +	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
>
> Is it now necessary for that mapping to be tagged? If so, it should
> probably be called out in the commit message.
>

As you've pointed out, the initial r/w mapping of the linear alias of rodata
will need to be mapped tagged before moving the zero page there. So this patch
will just preserve that, rather than remapping the region tagged explicitly as
it does now.

