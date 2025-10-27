Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1D7CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C7F80069; Mon, 27 Oct 2025 12:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A041D8000A; Mon, 27 Oct 2025 12:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F20F80069; Mon, 27 Oct 2025 12:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 760608000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:06:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12856129BCD
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:06:42 +0000 (UTC)
X-FDA: 84044372244.09.B14588F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7792B40018
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:06:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HA/0OXMd";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761581199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpxdS5ygvVp4sssexZhDityvniMqB9yz0acKtxZ1LBk=;
	b=yF/tpaHIpavyAkUc9My5i5N+1gGYIIY/CY8+fr/tLpKLlVMRZeiGyXjTCB/vSRQxLVKhdj
	W5a/CfMbG6/u5TxaDG2JDBumHjGhewDwe0wA4FL5Rqc/KLCd0cjPTbBnyCumq8gI8WNsB4
	j2LBQDtL3hKTe88QmJYbaKC1F9lKOIk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761581199; a=rsa-sha256;
	cv=none;
	b=WFdgfi5UrIUQjxdRJsvJAwNv+DDUKKLpoZWUuSlbcDATFFgUeb/3wTQUKJSWUSXtnBp29C
	FVX2kU3kkR8fBujgnBNE0OdoA6KVWtQjHT23tXHQ22IhoiFbCRTCpCFb+iFDQdiTBNCE8A
	5E1CooVaHye4WhJSWD6mzumhYDo049g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HA/0OXMd";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761581198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kpxdS5ygvVp4sssexZhDityvniMqB9yz0acKtxZ1LBk=;
	b=HA/0OXMdlw29QT44TH66HnEKUjp/yuTvp+Kij7dAeYc7jn9RcB7hhHFReoQqgUWwhaTVBd
	6W/G7+9riiSuFR7QN5UorADLDNbTJiZd1fxnZyacutyqexIAovVG0PGf2A1NwMc0H/dSj0
	x9yJDgpm+QHyQ+LsOhQbMlrM4pXt++4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-vHk1Zf3JM2G_4hjqsKeyOw-1; Mon, 27 Oct 2025 12:06:37 -0400
X-MC-Unique: vHk1Zf3JM2G_4hjqsKeyOw-1
X-Mimecast-MFC-AGG-ID: vHk1Zf3JM2G_4hjqsKeyOw_1761581196
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47496b3c1dcso36080565e9.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581196; x=1762185996;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kpxdS5ygvVp4sssexZhDityvniMqB9yz0acKtxZ1LBk=;
        b=vw18MH0N03m8MAoeB6xF29oWAS6XZgK+RiNUYvg4CflxUROiASGhyMBu8TpYG28fx+
         DpNYhkRmlC/z3vDzNu6HM6rjkUmTm7Qvn6jo8CsX9NuXfcrBkJZghMIbvfMIXXyPr0JY
         dxsyqiv0O3PngV1Y2M3wcvrMG9vW6RdYnpEXtj9C7lcMjBg3qwv9uq0OBcoYUcz4n1RI
         fhWEGr38BW4c8VlgAVIzsuF9Eh8sdxOYAD19DqctjbXbHCdkXOSlJK/M8S/yUBw9rOGc
         hKz3AxYqbAT8g71vaM/qwcLPiPStbanLD57A5EiHkWXZuY7uYGqLbIfqNfUt4X1zpE6g
         jgHg==
X-Forwarded-Encrypted: i=1; AJvYcCUN3fRuybOSxUnBVR+8dQ4kU1hvofZsoHA6tr52FoQ/g5vpybA0aoYakB7xrZI8/EHeCvxWo7SqGg==@kvack.org
X-Gm-Message-State: AOJu0YzKjZzYSkbNE6a7WprJmzL7AClGTkNwpjNE3NWzWw/eSBlxmgKf
	LuQRQEk9Iuu6bmydt4gLMbWU0wrC0TmQRLIvR4SHQrUK5I020MT0m6sgPAmUETK26VsELQecWt4
	d7iAnfIQc5tfi3qhxRxaR8YRrfSf4KP4dRwYX0ygj8+Njy1DoI1zm
X-Gm-Gg: ASbGncuJE1yPpKdpAOVaVrt2WyQTRR9rhltbqm5AFbDHDUDjSe7+E9jK8RpTPZwoTus
	uzexs/QvzUXzPvRQ4ys0ZCKW8IQJpG9nJXtNPDZHDbTjU5xKRtSaeSUUfL1csPzwExraA6kDw+o
	NTvJl17EBboWTzZNRju6FVNPfUgaBcRzuoj7NbOokC9XY24Aw4OicMzQ1PowNaxmb82QMjs9wcL
	fBoDodMSA+NH9RuVL+/zonGP0/ecrDHIL6o4GYaVOy20UIR60MWW4srmFhCrm0YX32wzpAbpO/3
	5Lg6rfU4BJXOSeoJ7xoTPkiJhf1lm5+C66pOX5LnDAELiQs0jRxlLqRpB4mK0ORYKjWQTZs8pbS
	9qLUTmeFPxmDtySk+2p0nSumtWQSEZFqR4znUV6TYZvixvdgtFvfI7gvV5VZOJvXokqrHDFBG9e
	gUnY+x3ue0SF2/ujMHYh8orDWVc9c=
X-Received: by 2002:a05:600c:4fc4:b0:46f:b327:ecfb with SMTP id 5b1f17b1804b1-47717e03722mr1896975e9.9.1761581196186;
        Mon, 27 Oct 2025 09:06:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHv5M9b4q9OVKGnW+HmaEJg2ucSNwvJY0LUs9zHR8mcSnR+YxmFwPGnp36vYB+8STF/MebLhQ==
X-Received: by 2002:a05:600c:4fc4:b0:46f:b327:ecfb with SMTP id 5b1f17b1804b1-47717e03722mr1896525e9.9.1761581195766;
        Mon, 27 Oct 2025 09:06:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd4cc596sm147684725e9.15.2025.10.27.09.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 09:06:35 -0700 (PDT)
Message-ID: <7bfd0822-5687-4ddc-9637-0cedd404c34e@redhat.com>
Date: Mon, 27 Oct 2025 17:06:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Yang Shi <shy828301@gmail.com>, Dave Chinner <david@fromorbit.com>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
 <CAHbLzkpx7iv40Tt+CDpbSsOupkGXKcix0wfiF6cVGrLFe0dvRQ@mail.gmail.com>
 <b8e56515-3903-068c-e4bd-fc0ca5c30d94@google.com>
 <CAHk-=wiWmTpQwz5FZ_=At_Tw+Nm_5Fcy-9is_jXCMo9T0mshZQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHk-=wiWmTpQwz5FZ_=At_Tw+Nm_5Fcy-9is_jXCMo9T0mshZQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JK_agADzs6xP8iat09mdkQhttiKfHtUBAmHvOl-DJyw_1761581196
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: geu7c8o8q83xeb7znyhqaixyxntq36fk
X-Rspam-User: 
X-Rspamd-Queue-Id: 7792B40018
X-HE-Tag: 1761581199-807710
X-HE-Meta: U2FsdGVkX1/tGARGwqhNNIUjm/SvxSpSHDbk7ejcmhnbO0KpIUZHtObYmCkljzU3/AwjxYm100A+1shwMPdQObNt5ADN3NCj35fIrBLRBQkxgR10AQ1K6MXsUwybVOGvn0TX8ix4DYUn/LDRNBScelZGQdv+0SA7vcOuteqyJ2MyLh4YbTP0pxw1iniYSV55mw5vkaL8tGv7xDLw5BkzzTKEPmOJkB6AURaEXe6fMYrwZgICqdSo0Qs1Kw7ROwcnLb+VwXMdvrDIitrkDhCc6P+e+S6dpukSYYPyvJ/siN+wmik1jdup1bW42UAxNvFt/GrcCIg7xH8w6cjeQBwUsweSM/UFTCdU++0bCSqgdiK7fUe9MEtlJ/mrPAv3Q3iWkWvu6cWDjoKnu1C1UqlgO5o5O9Qcj2LVNOOYQ7vWIjNZ8fshJBrV4tFCTuxZmLxA3+Cgtg6k412FttOQufLKK2TJJNoUpuP8GjB90aQAcgZe2WrqTQDqq9ZvtJaUEAdeueTm2WBotE9Dg10i0xb4OIqAdhDyQjJWLN2cX4EniZ5Huq5GzDVLuSIDnvgD1dcx6k21jCXONz2TL6NUmCGwbklsPDn7zOIy9KGDOYB1kDQPHrA4SLWBwMgY9qL/AZZp+5x4sa5NHs5XaxI0o8vnr3P5AV6cYQ3JzdmT/O9AQxinWw+oulb7LYbfoD5CSB9l1h7W5zGYbZetE52j0j75Ys16PJ1akdBAWztwaGFqSgEnUyrz/kvoeOOCeKHxi22L5banon3rLFrWJrT6DycBRhAgGCQ9jjjBXFpFxB5pB4FQmoi41CsAtEzYkfYTzpWF0FPQJPk6MKTqI0Jc8/oZMp5QG7wT+3m14T5ido2KtG7TVT7ZSgJD19TJwzCd80kkD0nMN2c7heX5CdNYY8ZTpj5pkR0nR0NNFlFgoWQaydyhFD532sQmgKn3KMzcHVoQgw+HUWA6tWVUHJkdWrp
 NX4B1zUh
 LWFALBA9Uemt7jc7jMJ65GjvSuB/2q2aKtYN9ywzgRPKosfwpHNB7U57nFIeTIUGEdbhhQzSm75y9g1ew5zGL1THhRwy+WJodbXULnRqJqVxN3euSG52BcGK9UfJgs9TqhEGDxMNHtgJ7aM0BQ4IoxsYN3LcEPgy1EWNvLJu+AxJjlymxDpkQjOSzZRNOxCZD5svo+MONQPsf/phMKoxSW58QNOik8vYGw8lTX9dW0wiC9xYSp6KgTRHaNY8RIcfj11XcIiUDB1aDplRMcDaL0Ja47sO+JKeYUJ/8WQn99qIWo6m2lMRzgNZ3O4wvw5IgaMvOMcfJEItQo8rq3JdOVKLn/aDdrNjxJvfIsmBCqqeWIZpL+++iYhdqfkJw1aDdDUs5zVaV/iUOAu8XV7HUnD82C7T37R4qb/9n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 16:50, Linus Torvalds wrote:
> On Mon, 27 Oct 2025 at 03:49, Hugh Dickins <hughd@google.com> wrote:
>>
>> This makes a fundamental change to speculative page cache assumptions.
> 
> Yes, but I'm a bit surprised by people who find that scary.
> 
> The page cache does *much* more scary things elsewhere, particularly
> the whole folio_try_get() dance (in filemap_get_entry() and other
> places).
> 
> I suspect you ignore that just because it's been that way forever, so
> you're comfortable with it.
> 
> I'd argue that that is much *much* more subtle because it means that
> somebody may be incrementing the page count of a page that has already
> been re-allocated by somebody else.
> 
> Talk about cognitive load: that code makes you think that "hey, the
> tryget means that if it has been released, we don't get a ref to it",
> because that's how many of our *other* speculative RCU accesses do in
> fact work.
> 
> But that's not how the page cache works, exactly because freeing isn't
> actually RCU-delayed.
> 
> So while the code visually follows the exact same pattern as some
> other "look up speculatively under RCU, skip if it's not there any
> more", it actually does exactly the same thing as the "copy data under
> RCU, then check later if it was ok". Except it does "increment
> refcount under RCU, then check later if it was actually valid".
> 
> That said, I wonder if we might not consider making page cache freeing
> be RCU-delayed. This has come up before (exactly *because* of that
> "folio_try_get()").
> 
> Because while I am pretty sure that filemap_get_entry() is fine (and a
> number of other core users), I'm not convinced that some of the other
> users of folio_try_get() are necessarily aware of just how subtle that
> thing is.
> 
> Anyway, I'm certainly not going to push that patch very hard.

I will sleep better at night if we can guarantee that we are reading 
from a folio that has not been reused in the meantime -- or reading 
random other memory as I raised in my other mail.

So I really wish that we can defer optimizing this to freeing folios 
under RCU instead.

-- 
Cheers

David / dhildenb


