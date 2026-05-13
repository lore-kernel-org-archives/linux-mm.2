Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 016DCCD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F666B0005; Tue, 12 May 2026 22:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F366B008A; Tue, 12 May 2026 22:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466016B008C; Tue, 12 May 2026 22:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35B426B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:12:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B615B1C0522
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:12:14 +0000 (UTC)
X-FDA: 84760771788.16.2AA6748
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id F245B100013
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:12:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FvqK/RE1";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778638333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdjJWSLheRQ+3GuD9xg1u/bkib2oHeCrXtM/HsiT9hA=;
	b=TG3HE9oPjDkGtPNwYP7lz4pUGE0eCntwV+yQYtX+n+ftzSuhbtFi0mV0HNOC38v/y/H1PT
	V/kqThRf/S38I1il12dc0+WV1pXFBlahMqdZHKDgNSdgfgg8cpKJ7Ux0WikkWJF5KISTiW
	ULExXEqXTLRmNBozHi96ROeMAqkRLEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778638333; a=rsa-sha256;
	cv=none;
	b=jdBqW+RuwshVhjRiip9aksUM3pavZTeeOr0WWf07FfxMKkFXhdODn/ig4l4FGz5mkqHVok
	EcFlqsZgxoPelK1H6TJZd9T27/SO6RrnC3DfXwWogtHeoY3JpPcYPkJA8eKs0Uqpa0qir/
	8NbW+Fx9Bs1Iu1mIqvOKOVul+dXaZHc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FvqK/RE1";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778638329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdjJWSLheRQ+3GuD9xg1u/bkib2oHeCrXtM/HsiT9hA=;
	b=FvqK/RE1HsPP0f+Olp2dZTiI5rOPjZzpmfjMhV4TCxIgrlljmH7uX3cIBO75/yLdaj1TkK
	fwZTR2ctao8DGHXSY/4uBJ9orQKkWJgVytD8f91uGBoXacu3/XNJWE62Bp8Gsz7UYuybaH
	03SZrVpWg5okbuI8VjHVv+E+iz1cRzs=
From: Lance Yang <lance.yang@linux.dev>
To: shy828301@gmail.com,
	jannh@google.com
Cc: lance.yang@linux.dev,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	arnd@arndb.de,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	ardb@kernel.org,
	sethjenkins@google.com
Subject: Re: [PATCH] mm: make zeropage read-only
Date: Wed, 13 May 2026 10:11:48 +0800
Message-Id: <20260513021148.17588-1-lance.yang@linux.dev>
In-Reply-To: <CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com>
References: <CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F245B100013
X-Stat-Signature: atcj6dq1sfqcgpfwffnrbadqrucjyqtc
X-Rspam-User: 
X-HE-Tag: 1778638332-937269
X-HE-Meta: U2FsdGVkX1/FiA3GWPjqw/7N66KSY15Ac2qXUz98H6XKEPmylyS6cNWN8JqcBKdQLv/y6ReWd0KELxwcsAyTxEtvrmp/aYVBRzmZA9vYcOcvnUwtnlF4oCOKE95mXiBcbbJn9HNJtb9X+2ZSAL3snSpVdMsaR6OyraxkWPkGVZnrNjjqsON+kk6zn8PRGTxIRqcpO9H6Sv7D6EGXgRFLUny7kWw3eN0Ro5OxERuf0RJ6dKCVILZIpYhs22sMfulpDs3xHgQMunSnUN5zcwnmdz/B0lTS4LxcDGxGR2dL3VCWvueR5O+NU/cSAmEyop3iC/q4ZVv3e8ItFr8fSWSE4PeAI6fVXxW6YJgJ7qY5TxDAcbOlPQ57rn4ZlCVoap3pWt4BXxesKjBWi5KRh1DJKSR1tnAO3tyQu2CODOZf7IsramtgNVDi9Qk/zx17w9V/ghykGBOn8lWglLAwp6g2iM1e3HCIcnuxJDWSan2Ptyxqr6eaSqaQz3Q/WdbAo6FR280V220ns+/5hLRXHxGWwERUwgB//uDahIjI7Xoqv4NL33lyScauSm8J76vons3ljJR91gWYWahwYjC1r91GxEzUk2cZHTN02YKsAg4rdDedwL3hSe22FPB5EzC/UjiMLy0fA2OEbE2fvnHzMgE6JQxMKNha4NTGW044Bb89vIhxUZIPmo5Oq5lSZUR+hkhul7DtQcTsQsOSoOAZzlOVpiYlimoUgM4q9Y0+hf90r75gfMhvZmmCu/aRH1T2JpbfIdcnK3PlVMSczvJ1WY0ilFam6iBK9zQ006lyC5eKH6eMuGqIqzvIu6r39mXqpjFMUUw7vuTpKnYqtbWG3UbrM2uyy77e0vORXAQ9MWF7aVZNACwRlaU4hgvH3UHzuwqBZ8sZ8c727PTU49xAc/MMlxwuVtUivc42oCT9J8BeQU0t+JHdaFYyEddGkpkorRt8CzfDMtypKiCHkwvFBCh
 Di8EBNLI
 iQhKz6izAhymCButS/2LM+5Sf5TE5AJAX9Reg6rj5QF/xvgyhUORA9Ow7QOIaCJd+LTXDnKfO8Y+ZpGhjrdKoyozLn4S4RtegoMQACutYjkQ1qNMl4lzU2t6Ua8B6e4ifYitB1WO8x8+FCRQbq+Tm5StDzNRMvqxhRGruUFR4ozhBMHfYxF85Fhhczy0n59183SHYEBrvyeErvOTCBgQyjfNNe6pvdnHsjdNg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, May 12, 2026 at 10:14:01AM -0700, Yang Shi wrote:
>On Tue, May 12, 2026 at 6:48 AM Jann Horn <jannh@google.com> wrote:
>>
>> On Tue, May 12, 2026 at 4:31 AM Lance Yang <lance.yang@linux.dev> wrote:
>> > Would it makes sense to apply a similar treatment to huge_zero_folio
>> > as well?
>> >
>> > with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=y, it is allocated at boot and
>> > never freed, so it should never be written after initialization either :)
>>
>> Oh, neat, I didn't realize that that feature exists.
>>
>> I guess there are two aspects of making the huge zero folio RO that
>> could be problematic:
>>
>> 1. If the huge zero folio comes from the page allocator, making it
>> read-only might require splitting a huge PUD, which could have
>> performance implications.
>> 2. I vaguely remember arm64 has rules about how PUD/PMD entries in the
>> linear mapping can't be split at runtime at all depending on hardware
>> capabilities, meaning the entire linear mapping may need to be mapped
>> without any huge PUD/PMD entries - IDK if thp_shrinker_init() runs
>> early enough to be excepted from that. See can_set_direct_map() and
>> force_pte_mapping() in arch/arm64/.
>
>Yes. First of all, this relies rodata mode. If rodata=on (used to be
>called full), the linear mapping may be mapped by PUD/PMD if the
>hardware can support BBML2_NOABORT, otherwise it is mapped at PTE
>level all the time. But how huge zero folio is mapped in linear
>mapping should not matter, you just need to change the linear mapping
>permission to RO anyway.
>
>If the rodata mode is off or noalias (used to be called on), the
>linear mapping may be mapped by PUD/PMD, but basically changing linear
>mapping permission is not expected by kernel.

Ah, right. So for huge_zero_folio the hard part is not just making the
backing memory read-only, but also whether we can change the linear
mapping permission for that range. That depends on the arm64 rodata mode
/ direct-map setup.

Thanks Jann and Yang for the explanations!
Lance

>Thanks,
>Yang
>
>>
>> So making the huge zero folio RO in the linear map would probably
>> require adding a new config flag, connecting that to
>> ARCH_HAS_SET_DIRECT_MAP, and changing one or two places in arm64
>> memory management.
>>
>

