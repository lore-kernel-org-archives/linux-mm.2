Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB1EFCCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D548E0019; Tue, 21 Oct 2025 11:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234638E0002; Tue, 21 Oct 2025 11:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123A78E0019; Tue, 21 Oct 2025 11:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1A038E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:37:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 938E916063A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:37:30 +0000 (UTC)
X-FDA: 84022525860.26.EB4A349
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 28CA220011
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:37:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xx02AEvv;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761061048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4XNx7SmcphwVa2FHvlNJ8vIAO/gR3f+gwX24U6J0nk=;
	b=fGaYTCPz9X/oACwHXNGu25AF9Zok9wcUZXX6cefgQ7iDyC+RKPCQUP9WcaDLWl5h/T+Bfp
	01r32w/brRnrsshI2Gi4R5YYrTJCuO6KErvWZ3gVWaOftDnkUTnrRg5EMxqWATlLwCVDyO
	FAqjbnCail0s519ZnzGTglUYl8knyt4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761061048; a=rsa-sha256;
	cv=none;
	b=NkY0+xjZmLJ9wdqNqLWKQFtMOdYkT63eldnXMNT4dhlbbYxSR2948F52kR9NBMBktiKQdW
	8k5WfXcGzqnVw7oFstCvGNc9KiEc0D293H/NkYdZFb7rTxQhLYQh8ZreeY9O/Oh8qI4f2H
	nLwtsCOTmoyV+HdROQByBxcbp4Pfpzc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xx02AEvv;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761061047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L4XNx7SmcphwVa2FHvlNJ8vIAO/gR3f+gwX24U6J0nk=;
	b=Xx02AEvvbd8qX6+9UySWNT0f/EU3qrmoPbX7W+b78fa6epgO2u+di00r63Kxf7ofR1ecEI
	+buiRXHuXZ7MNzrM+5q+jRq9tfnLt8Dctp5BXkU+Ma3ko8UbXPLczOGa3LoUmQFc4JhU/H
	agKCF6KUHAschV1y5Yf7kKCw66DNw/8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-zmcXF_rAP2ehKN3TE15TVA-1; Tue, 21 Oct 2025 11:37:25 -0400
X-MC-Unique: zmcXF_rAP2ehKN3TE15TVA-1
X-Mimecast-MFC-AGG-ID: zmcXF_rAP2ehKN3TE15TVA_1761061044
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-475c409368aso39055e9.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061044; x=1761665844;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4XNx7SmcphwVa2FHvlNJ8vIAO/gR3f+gwX24U6J0nk=;
        b=awBp8mpJBP2uRsL4COqBdd6Z8Dw4u5lLoTuwy2aGAJuUhzzeio3vmnnh5FxIdED50z
         BtY3k7O45rAoPR/NTTf/nb4XKa2Qc+oNpNMcP42TslXmdQepwvBFLSMdvITmjXGcYi2/
         yLV0cCqoY2StKkC82QltEHAqhGLVKLX29HOwm5QQtqB6sc+MOtoEQcPIwi8BVBClUFx8
         +t95g5RXKg70kQR8wD0tUkrpT/14VdCJlfJAaCw7rr/u/wVRSs5Xjks5b8SLs1fUZjIK
         fvrQIXIpxKmtsIpBaZ4joxSZqlvvT7fyIBDyS+XuJSyHqLNgSMHoBEH7y1uVdYT6oF6C
         yMdg==
X-Forwarded-Encrypted: i=1; AJvYcCUqvJp/j9xynzEFvbVWsuLbfo4rcG61vQqzt1VQAgJjQXk0xjrJT6E+8zAJaES/mj5NjvkP2njZAw==@kvack.org
X-Gm-Message-State: AOJu0YxETcBIYpqNk7xHirZcwtx1srDKbb2bzQW3nDSjceRDrJUne295
	P36aW0kX20uPv6OqYP/mcOBI9QcbIwraRd5nMrkcHf578706IkTv90orKORQA3mgN500oGY/Ak8
	RQLVhk35skm2AkK7aUSh8EujrNscAKcj9gYyYAo14aiPnE8GTvasB
X-Gm-Gg: ASbGncsg64jMaH/tsqwWxXu97POaTFU0V/JNr9Oiw4BWb+x3gmNI/y7K6M+JHeT3lXE
	5Wx33iuLTpL5cGBq8B2Plx6xXyOGsLsbEzyoa2RaW6Ws9AvugJRKKtKfI+6RjkeqgeErU6Kmmzk
	nByn7lpACWtLk1x2k/N3m7v9AjRtaNwdvxJf4cWBVXjjvB1ti2pEOxK452Vvjpi24RvdymtQcjn
	UIJnSA0NjzJfzGer5RS/4nhSOwEMlhUdBNC/rzOnkgeE5Gi89kUEAd4vRbAxSDhWtOJTZKB9D/X
	1uQOOEy6ztKeHkseVvNEw9qc3pYqXctUJkeL+r7SZ620llG647d1hcLEmYO2dW18SV3f2J5Vcqa
	Qbyljn/h/rotSFWY5OpZrDf4SIPWpJ1ilHIfa6ciMPSWXtdw3oCcScHUYNdK+TeaZKLPKsv7e4t
	8+TWmNWhRB3ne+BhEBl0k7rWm8w1c=
X-Received: by 2002:a05:600c:1e1f:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-4711792a2admr124898815e9.40.1761061043897;
        Tue, 21 Oct 2025 08:37:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGC3Ou7fO+S2/Nmjwjz5SUjJ9OhpSFk+6BtYv7TJRJbyItQGBbbudeiO9N85CmNh9nSNHimAQ==
X-Received: by 2002:a05:600c:1e1f:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-4711792a2admr124898525e9.40.1761061043399;
        Tue, 21 Oct 2025 08:37:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496afd459sm19717555e9.1.2025.10.21.08.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:37:22 -0700 (PDT)
Message-ID: <042629f9-f295-494e-8fbd-e8751fcbe7c0@redhat.com>
Date: Tue, 21 Oct 2025 17:37:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
To: Chuck Wolber <chuckwolber@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Gabriele Paoloni <gpaoloni@redhat.com>,
 shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 gregkh@linuxfoundation.org, linux-mm@kvack.org,
 safety-architecture@lists.elisa.tech, acarmina@redhat.com,
 kstewart@linuxfoundation.org, chuck@wolber.net
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <20250910170000.6475-2-gpaoloni@redhat.com> <878qifgxbj.fsf@trenco.lwn.net>
 <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
 <CAB=6tBQP3aCDWch4ZcEYMqFsJ4OKXSyC_hb9V9hA7ZZty7vFeQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAB=6tBQP3aCDWch4ZcEYMqFsJ4OKXSyC_hb9V9hA7ZZty7vFeQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PLtaRj9JjWx427I4fsWiH7ESL1Fy-KHlROxhlYtPzeE_1761061044
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: bugf9f4nz1t486grhc8e4jt9qfbxw6dy
X-Rspam-User: 
X-Rspamd-Queue-Id: 28CA220011
X-HE-Tag: 1761061047-243544
X-HE-Meta: U2FsdGVkX1++rCEiv/Dfoax1UBmkUUw0FzVVsp+4CPs5g0bnGvnSQ+6jq2S7DtSzQoaJAHdp4Y4BHRrMmL5NcOk1hXJyWWXPPXRH16OmqPh2+5flNmOLyrEWGxWJqToWqhn/z9bgW67oq1juo1+p0epQeLCW8KK1hUG+MpEaN2pNYKBewcqrsZZCXsnx8rOnM9ESo67OJgIsVlMOoH4aei7cuOxd4d1bbMaIeptbXrN4vj2e2WrhSKh05TSrLqKKZgjJHesYXfnXtEuaiDxLklGebvKacxZcsdU8Bv6ohFZQgy4jeBTxj3g4sktIXHYW+pMqVZFEhdN8l/WlbrnC2GCzDImd8O9A+HPsp6UgsohbzT76ryfRmfVARY9yjK9YZRwXrdirkggdIOaz+K3oOXuDHs5ZvSgq9Hf2+610XRllS4dKw832VJVGHMGYDa/W14rgbo+KJQfiAuvfuYSnFW4xQz5emVcDOIzoSZNixuBIOzcH1wCf/v1M/5W5IaqBRfnU6PBrgemlKGBRfAtHCe4eKoNILETV9ATlmlFye9Uuezt09JvRmLww39uww3IjPFrzbQBtOJPup4IeQe1PBD9EfTzcmwBRZm2s0XP33lOCUglCa4CrTb3u8fRvrf/mwFldEQ1Shf6c/hsIjcSzUDoGCxNpJS5ZR7l7VcgEqyWM4gn8GSdaZJGlvnjd2zT0gow0+DF8OLndC1PhXHcQxQ7MiK1bhVna91A1lEdRZNdWJ7MAiOkKPsNJ9lxDOIohyAYerITo2KlrPJ8f4DNz2Gw0TV0T1SeAwQyoou5Lw638YXtZ5Ara868GJiNkYm4Dd4ajy9+i6aGiDp2P2MMI4Ur/XjXdaQToaqeLgHc1Pjo5ZRVDhMTtlIYYvOqdjIvhxh/n/up09An0ae6wQSFectcN97fibkEDqse4k1ucbOjmk7gG53/JfCMFo0X2zRKkU42RPhq5ulMBSLPNLaD
 wY/b3Smz
 nX2M0rqreRcum/7/kNvMFIrP4RFxb6XzNoEwjQ+lcjxy3cjad3GudosSPIQR7nThi6qzsKQvi2wfpfP8vPKjhTvRoNhIIyURMj+zx3TbHSYtvMIPAKGgftyRaWwTVrZWZXT2y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 23:02, Chuck Wolber wrote:
> [Reposting with apologies for the dup and those inflicted by the broken Gmail
> defaults. I have migrated away from Gmail, but some threads are still stuck
> there.]
> 
> On Mon, Oct 20, 2025 at 7:35 PM David Hildenbrand <david@redhat.com> wrote:
>>
>>>> +------------
>>>> +The Documentation/doc-guide/kernel-doc.rst chapter describes how to document the code using the kernel-doc format, however it does not specify the criteria to be followed for writing testable specifications; i.e. specifications that can be used to for the semantic description of low level requirements.
>>>
>>> Please, for any future versions, stick to the 80-column limit; this is
>>> especially important for text files that you want humans to read.
>>>
>>> As a nit, you don't need to start by saying what other documents don't
>>> do, just describe the purpose of *this* document.
>>>
>>> More substantially ... I got a way into this document before realizing
>>> that you were describing an addition to the format of kerneldoc
>>> comments.  That would be good to make clear from the outset.
>>>
>>> What I still don't really understand is what is the *purpose* of this
>>> formalized text?  What will be consuming it?  You're asking for a fair
>>> amount of effort to write and maintain these descriptions; what's in it
>>> for the people who do that work?
>>
>> I might be wrong, but sounds to me like someone intends to feed this to
>> AI to generate tests or code.
> 
> Absolutely not the intent. This is about the lossy process of converting human
> ideas to code. Reliably going from code to test requires an understanding of
> what was lost in translation. This project is about filling that gap.

Thanks for clarifying. I rang my alarm bells too early :)

I saw the LPC talk on this topic:

https://lpc.events/event/19/contributions/2085/

With things like "a test case can be derived from the testable 
expectation" one wonders how we get from the the doc to an actual test case.

IIRC, with things like formal verification we usually don't write  in 
natural language, because it's too imprecise. But my formal verification 
knowledge is a bit rusty.

> 
> 
>> In that case, no thanks.
>>
>> I'm pretty sure we don't want this.
> 
> Nor I. If you find any references in our work that amount to a validation of
> your concerns, please bring them to our attention.

I guess, as the discussion with me and Jonathan showed, the cover letter 
is a bit short on the motivation, making people like me speculate a bit 
too much about the intentions.

-- 
Cheers

David / dhildenb


