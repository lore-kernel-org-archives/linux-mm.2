Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B64ACCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 10:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02BFE8E0011; Thu, 23 Oct 2025 06:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0035E8E0008; Thu, 23 Oct 2025 06:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33E78E0012; Thu, 23 Oct 2025 06:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCBE68E0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:55:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EAEC13C0AC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:55:08 +0000 (UTC)
X-FDA: 84029071896.24.C3555DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 187A9180006
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:55:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pk0Rk2iS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761216906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbLKX68koPI4kruyudw5cKYMlwi7wHT0sON4jcBvqmQ=;
	b=HkiYvFxYRhn54pwCkVKzPSBixyYuF954zofZv8wopg8GWACI/RBswioKSXclinTgDzKaPv
	/YiWKLZoXyy9Ekudb0N1qbjtn9Hs+m3qXnA82dtUWTDEm5gurM6gZ8LqqHIxmxq5Vql+H/
	By0bO1A2BY72NSJ1G9BC45yshcEnMDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761216906; a=rsa-sha256;
	cv=none;
	b=7HuzTQrCFDmlbD3LsGcCmqMLKekVyNgAwqFkh7B3BgrzdiWBlx+BeFAHgq21llHsM0FtZv
	TV5oeOS9HZHz0jS560dtTRwoTj5qXnlBqf22WaeZGvPM/Kjc15uEqUSi9ld8W4nbJgDmp0
	32q5TSuNo1yGt5WTfBBHnfHsieKYWSA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pk0Rk2iS;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761216905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lbLKX68koPI4kruyudw5cKYMlwi7wHT0sON4jcBvqmQ=;
	b=Pk0Rk2iSGw70Mh5AqHj/V2hMyc8B5B29dUkbndqRb0yDdIcSlcUARgbtuecwVEjKWz27sb
	pJWBn8uYkN/EUIilYM/H4nj4EJVPfrK6CN3V97PhCOW3Kwm4gSzYKeaYLezvWHKXgUoB5i
	7Zzrj8FMW2uD0mUxQQqD5bF3xzV0mEE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-6cu5sw8XOUu7rMEG_NzGlA-1; Thu, 23 Oct 2025 06:55:02 -0400
X-MC-Unique: 6cu5sw8XOUu7rMEG_NzGlA-1
X-Mimecast-MFC-AGG-ID: 6cu5sw8XOUu7rMEG_NzGlA_1761216901
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46fa88b5760so2730015e9.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761216901; x=1761821701;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lbLKX68koPI4kruyudw5cKYMlwi7wHT0sON4jcBvqmQ=;
        b=c22oWf27OwiS1s3wB7GU2/AaxGrQNwTakkQPUNjYP+e78pFByw9/teMqiWo3LqV/Zb
         /6RwJaXihoDZDEz6taAZ20xew9Opyphfm5rEjsQ9jAOq/BqgJEtDC0Pe6VDC5DAj7L+L
         f0X+6LLfzNBIaW2YW3YBNjMhRhAGyb2jYqKIHmM5cDKZuuolWNrzZCW70OL33wBqeBdM
         KRhjyfS5VMbdYarRzSGzZF4tbB3ec/9QoDdOwhtLf/Ku75QjEWhTLE0ApE2XklBGYv/g
         WbJTvVDntu6JkAg7Di4cGN2byPxB4HBTJC5BHtn1x3j0cmkRS7TegCwMyhG7Yixg78Mg
         TUsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwoXubV1kDjmjieNhdE76AiWtTQGIm9a6+5sfc2mZGKroxYMH9K3Von3bVc7Xbqp3C7SkxUbde6g==@kvack.org
X-Gm-Message-State: AOJu0YwDXJYp6RJDihgD94qi+FwjgZ64V0uY1DWJ+IJ3lBBqu5aFcKxL
	FGGQr3anG+GK8PTbAOlB6qJ/TcFkjEmzlNoEhmU+/x67ef+DP1rggifSjg3i3OhigOJGLa/ZDK2
	cCBUWOlPW2TWJEouC67/CnUQBxeMZabQpwWKYWdBT6pJyy8X/46YxNQRUK4iV
X-Gm-Gg: ASbGncukP6aFKlXzZEDMAdQGa2GZj2RaulwWI+SlRtKXYSmvjax14FDp9rdbZ10YNB/
	qe60rTE5nOOgWvgPR2eXSQyto3qK65V61tzsHbFUPaF622P+GDV9ChHvPU+31Zr7h6ngtlFEVjH
	jXOIgWzAy57UhIHsuwFLuRP2oUMjb8nWTG7XxyLmbdNK6OCiF6wOCFzmqAHYrjoulKIiKGNFP6T
	ysbiYfEqRwBXdKvZUBzIJUSHPG/Qz0AayzwhqL31PDR6189+cPBwjXdqut1sx+F4bda7vcb/weq
	jna9Q0niEuBFWTeOLZ4Kj4w7FInSxTdwfMF1Xax9ZkdugORu7xLm6aLwZc/ANX4NYk54UNtqpSI
	mNzSai1gGujNk2PP9pMoapLeYQ3l3YDHU2LYurN/5HkO20cOFJiaLTV0WeBfuLZG/+kvYzHM4Vk
	ti1vAkIzXqw3TqJLRpGs2o1Qnm4z8=
X-Received: by 2002:a05:600c:800f:b0:471:700:f281 with SMTP id 5b1f17b1804b1-471179041b6mr175144405e9.25.1761216901491;
        Thu, 23 Oct 2025 03:55:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyUNeHJgwXCbIligtDABnZfmVfKo4xq28X5BL2u+Iw9UgWmk5i0BeHZ0usCgIJViVp2uc3nA==
X-Received: by 2002:a05:600c:800f:b0:471:700:f281 with SMTP id 5b1f17b1804b1-471179041b6mr175144205e9.25.1761216901065;
        Thu, 23 Oct 2025 03:55:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496cf3b51sm55877895e9.9.2025.10.23.03.54.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 03:55:00 -0700 (PDT)
Message-ID: <06333766-fb79-4deb-9b53-5d1230b9d88d@redhat.com>
Date: Thu, 23 Oct 2025 12:54:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
 <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zmWlUbDtb80RUx4bmA4sRsFr7KUUDAPEl-fd7RSBmNI_1761216901
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: o8otgw1dwpfzm888ip1rbaag89geu5nr
X-Rspam-User: 
X-Rspamd-Queue-Id: 187A9180006
X-HE-Tag: 1761216905-695376
X-HE-Meta: U2FsdGVkX1/YjES0EsgcmS1/SRM5jsSYJAgKyfGWIxSkI9uwiZpHyef/Nu7DacpV0jdQY5Ze9YCIKpLqErrz2NkkDa7rOEd36/f0zYILUFC+y4JLCoBkNXYaDiWThAqig46x1ruSl+vzfW8snOD56RBEovh+u2tu9OPKO2tGz2HaG5MoIo2vQNTEdzhKhT/pdr8OFLTFwWB09nr1O8La3nkYsdEIdPdnUiFnSKi4Y3DHJQvr/ryamBniA3xHMaHXmrC3RuEBieo6yrfnBN9sTzWfFulcE+HYxbExGC/jcmbmXOeEabU+cWol6eiX2LMN2Ffy3omo9ZC2bjCIjCJ/1alBOXlEOheZDXDXokqX9wqL6RwS4nEb6BRdvZzwF3RmHVp9rr2WuQI6UdArutcP3/MeUymaQGWfg6ySv1YK+KRqO3goPp/4Ss41C6gneKtqtrqSybFTazZHYlWrtC6XSz9AX823julBOycIDXWrFamO03xm7MVLprwX/R0X6dvxd8Rzv45TD3b3czn5xqTN/Cwk7OF8zRX9DbD9MpQ5xZ+7gPjGGwynvOK+U7Hhuuj4muXaUYuvKnyUTHkLalBq5P9xJnzqWLSws30HRu3YWgljn8yl7rd/9NUk1xyRT8VAm8gx19CuyCKU3bkcx0wVCh6IVbS63uEdREq8XTMbqwjLfrkEXY/DRdEK52q6HP0IPUAly9T4Gyhl7ICBn03x1XDWglAD1p78nEvmLi5d1lQPQfqIQug2GUDR1xLZSmach9xbvECG/PBBmaiUN2j+9l8dVslioAT1tLrIlS7wZ9Z2CASgrnVd+PMeGyGBzcEw7U5jGx8sL/aEt/4VxMF9kjYCu9KwG50dnwdTFn5Bu5PcQNpqgAKsWXl8+P4SRxXNbDyL1nb7Q6yoDkUtav25uh0o6lPWivSXZ19icxJuBWlW5tTYbwO6UH9TVbS4FvF7sPW+bT4AwqduVDAMQGs
 2Ls+InER
 GAaGrcg29Wf0oVWP2oLjkiM+g6H7BBpI/CfhrtWDth5EGw4rLNHhqiFLoRI0aErGFDOogBd3kIJ+5wcQOuqBy5cAwHeyHohX9pbCkjtQdqV3d55hhwyzFlaQPmr+Ktz4gW+hJGp5ONDebFIuvVfujT4DIUc/BHGnlCec+o+Su+E58t7ewzSL5BsGEk3TUdUaYtxo6Qf88H5KwOb9FmzWH6BirD0xHoscqgYY7H4naUfFOY58JhFMRDGmnzidITHvaMMevzHVxvCrkhRmSmJZDuhn4kjJcRzV9wJ0C8nxiCh3MrIo6aRVSOhifLRylVUrU3yLhUDvfhfWllWlaJzIe6xRXlNEDOshBqlV/P4U9g0C+Iv+iL/fh5l47inyx94g5ZV9/dci/meQbXpaGmu8uGNYBIahJdDRewBeWJyU+Eb9Hy4xGJXb4ArDUQgccl6uzdjO4T8i2ZvY4hJcEsHtu4mkGGQ3HKynRoQwwgkFEVhTypizJwpSGHbVTzj4AJAiLu4vZtvW/kmHpxHs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 12:31, Kiryl Shutsemau wrote:
> On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
>> "garbage" as in pointing at something without a direct map, something that's
>> protected differently (MTE? weird CoCo protection?) or even worse MMIO with
>> undesired read-effects.
> 
> Pedro already points to the problem with missing direct mapping.
> _nofault() copy should help with this.

Yeah, we do something similar when reading the kcore for that reason.

> 
> Can direct mapping ever be converted to MMIO? It can be converted to DMA
> buffer (which is fine), but MMIO? I have not seen it even in virtualized
> environments.

I recall discussions in the context of PAT and the adjustment of caching 
attributes of the direct map for MMIO purposes: so I suspect there are 
ways that can happen, but I am not 100% sure.


Thinking about it, in VMs we have the direct map set on balloon inflated 
pages that should not be touched, not even read, otherwise your 
hypervisor might get very angry. That case we could likely handle by 
checking whether the source page actually exists and doesn't have 
PageOffline() set, before accessing it. A bit nasty.

A more obscure cases would probably be reading a page that was poisoned 
by hardware and is not expected to be used anymore. Could also be 
checked by checking the page.

Essentially all cases where we try to avoid reading ordinary memory 
already when creating memory dumps that might have a direct map.


Regarding MTE and load_unaligned_zeropad(): I don't know unfortunately.

On s390x, reading a "protected" page of a CoCo Vm will trigger an 
interrupt, I'd assume _nofault would take care of this.

-- 
Cheers

David / dhildenb


