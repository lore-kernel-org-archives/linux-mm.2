Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3E56CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497CD8E0011; Wed, 24 Sep 2025 07:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449098E0001; Wed, 24 Sep 2025 07:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337CB8E0011; Wed, 24 Sep 2025 07:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1498E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:05:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A985B876E2
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:05:51 +0000 (UTC)
X-FDA: 83923863702.20.C3D05DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3946B40019
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:05:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dT7yiylI;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758711949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJfstQJzF7vQWtME8nc3e37MPEdGJfdg+SENn3HGjjw=;
	b=yar6pDPgs/GOE9HeKLxSGzHEt3amR+9stnnJ9FBp61z7gQKCJAL4CJPqyYA6ZmaMDSdTEU
	nnLoPrHzIoTzQjmPr0vLIBfWp0fi+yhKAhFG2zvn5HkGCYCRlp51fyRE7oNnkcWqQgsqKt
	z18BbobZdvy3N24lnvk1o0GXRFhvbLU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dT7yiylI;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758711949; a=rsa-sha256;
	cv=none;
	b=7g++hFr8jY7a7IbSheCoidpOCQ+nlLEJ8wn9RNXAJD7T22qTRWV1yeYglGskMSXiHXxW7M
	9Hv3Q649BKgZH1aMeUrS/mLrYykHRDKdAc87Z3wSOQ1XQ6GXCSr5Vj6kGwp9wWghUQv/X/
	RaGArxqLa/g+JkvjOS354L6tJB7MXOM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758711948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pJfstQJzF7vQWtME8nc3e37MPEdGJfdg+SENn3HGjjw=;
	b=dT7yiylIJrBfLUptE3Bv9xggagrRl7wY84nGwWX1uXRvKpQqo/vZDiRurbFN/FBDI1fT5m
	Kn2c58j0aAkmOxnXWcxqoRhdEQ3ESleQ4J4CzU8+5q2f9vgSNWW6JNH6w8nE0nf4FLUz8g
	IXLM/Gyh2Lsnx5duGXoW6y0OTDsfvvI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-vWVcpXy5OgWmIshSPl48BQ-1; Wed, 24 Sep 2025 07:05:46 -0400
X-MC-Unique: vWVcpXy5OgWmIshSPl48BQ-1
X-Mimecast-MFC-AGG-ID: vWVcpXy5OgWmIshSPl48BQ_1758711945
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e31191379so747925e9.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758711945; x=1759316745;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pJfstQJzF7vQWtME8nc3e37MPEdGJfdg+SENn3HGjjw=;
        b=hByn88aup1CPciICk+BE/29HGNDTQsJ9XN5BsPTrOpmBTLNO3V2gFX+/8XdJjMzhX2
         ITJGPgvVf8DptQ7bJmkDK2PNNnAJFZvwcd6ONnojnfHRf6zYpPsVe10SM8I7aFPCnKXM
         5YrkHlcZ//8L6pUX0AqU3uYK56Om3j6cV9LR6QN67VLeWN0YbEWvpatDqyoomwxb07ig
         1MNFLPokmZ8e7k4p0CA3/HiyVxNxYoP/NnoiNxQYw73KKJDd4BzNM8j4wYvwXmZEnHv9
         IsETd1vsp9t6MtOOygGGInwaxurnzYIN+uhY0/tt2C9Y86nUe5dXyTIvMDkGXCxxKtDl
         OtKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd676dP20B+RSm/bcFxp6hPaTUanJOu78+UGawNwKQhdhpp8OEz6cNqZOUhB2ci4FgS9NzieaKVg==@kvack.org
X-Gm-Message-State: AOJu0YytHiL3eczWedjTIcLrbxGE0c8lClKimTUjnhFps8kdgTHmmhCv
	pPw2iqYEWODFhDUCLVJSCwcW+JFWqtdJVdi6xariZGzqf67lexK5D9Jyy4aNuBi/7ob14sTBcDI
	s1HKXI0DPFVBEvWer6s385nHsfojY4VYWM+pYKBWMDSxkV0sCULEi
X-Gm-Gg: ASbGncugZxxwlihPgnKCUA0w25Yr/fDsoYVZcivEiyzXfyM1c83ZfISgqQlNIteDGp2
	8cw3kMgoDCHR6vK0TRQAQan6d1JFOfCFNZrYr3fsQTZlu1TF+FBRrJpWtpI2F2/+qrwHiCnrhPe
	O7Go6IyTIP65lHC0FJ3IYw8o6/Is91U7yCAJDo1d2kk9KKqzOWtzxUqiCAtCHhcOTWMzd/Wc5KS
	gWhI3Abw/s5ZWJ4y2iSM8lM6siMa7pV9BINQWp0G3FtIdHw1k+uhH7R3+x5B36vCYb1eeXoklGu
	09sjAYkLdH3LUkS4+rxZakJlvrf2D6sLaKGbfxgPrYfi+dSiB3H3ABaB0P//rSqdyK7EfpMXp12
	MRJrBk/BxX8cTm1ki96ee0XftmznDoebUugeqNEhE/yo7Mc1moRXcgE2FOUUO+oSjUQ==
X-Received: by 2002:a05:600c:4703:b0:45d:cfee:7058 with SMTP id 5b1f17b1804b1-46e1dad1bcemr54121195e9.22.1758711945447;
        Wed, 24 Sep 2025 04:05:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbaeHw9ntX1+d3BLrDR31uBudOw3xXPWA7XtzGS71JBGdZjAGfyJ4Rw0XfiWGDvgzwltJ3qw==
X-Received: by 2002:a05:600c:4703:b0:45d:cfee:7058 with SMTP id 5b1f17b1804b1-46e1dad1bcemr54120805e9.22.1758711944957;
        Wed, 24 Sep 2025 04:05:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9af289sm28426105e9.6.2025.09.24.04.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 04:05:44 -0700 (PDT)
Message-ID: <6743ead5-4d61-4274-a24f-13a8a8265aee@redhat.com>
Date: Wed, 24 Sep 2025 13:05:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/16] mm: define clear_pages(), clear_user_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-11-ankur.a.arora@oracle.com>
 <5ec85b0b-9848-4cee-98f4-37953d504773@redhat.com> <87y0q4ewzf.fsf@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <87y0q4ewzf.fsf@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QOlOWHFp8Z9mA-TnY2bh5Lqpl597cWn3jvko0q2sEsM_1758711945
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3946B40019
X-Stat-Signature: tudzr9no4u5wr376qiawfdepsqgohxgn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758711949-758978
X-HE-Meta: U2FsdGVkX1+zT6T3XRpn/NeNkPiKFK55EccG1ZxXyDW8pvQhN6a4a0O+0jyORGf7IHflffPxlDn/kzXe/jm604PLYvOzcMOkvh5xMa4qUmTlKaFLFdFaNylKGMFBmWOpNmEdJF/FRkGVEos48d8Fv/UZv1OgnQjff4OHTK3/WFyczf1gF0ca04dLyfyHGvQpCjcl1YedcN8+RTcgIBxuQ5T+j+IraS8BTFX3up0iSk3ii7YQpM3iTGNiLTx2pUvxXjUw3dpXqSAKjwXBcz8sBQYQaO42IPDQhVVoJRJ5PayD42CTQWcRUXNZIhG1deubXSiqV0QVUnvSW64ZgNmKpTly2yZ4cvrj0oBOrcVtBi6XtDWkfUXSdZEdwu/WWXwlBhvdPn5rSWr/K0ouE1p/aA+VwLZRSagNCET4I5J1UCJ3BtP41+66DUusU4rfA1LEbvBB6Oa7JheIhUId6agkE5zvKyEOkI8v7zXX28Jsi9lVPN52u+bOe8seJQ+IXz3z6InONrz1zMzeZIfzkCH28lLr4hO+7k4Vrw/BBfIsm80ZoVI56sq5VQl4hpNLut4jZXAUtEfhHpCowr0u7Zu8x4xOhy4t3PRd6bjCkzGb9qlYExjZv+WTC/5+ItYpojizpK5f0amUlvBJ/2xfIz2R3E/YJ45rx89F3y/50/HUadpM7IEsENelTfMYJFd4HCzgqE9IlvzTpCIsKuMjQCdzWMfEJwro2ba6j1DTVMlwAJNRMxecGRv1gKjGQIC1rtvEqSDS0krNFNQAQZ/IVkwsL5ksGTPGpGaOjFXLRN0Ky2NUVqKUkcvgLVhRD4YEjw8tLsw3Xaznn2ezPJVkZV9Nf5vIFb8uDFB6JVgbZ8SujPZxbkpbwZ0a/C2Y8om30sdNfV9BQuBiuvZdFCUHzSi7JxDA/yUAYLWxWhHroQpHcdJBpnolDAulP9X0UAFNarUvAzxcn+SqwGcSwNlycaT
 qBVBcAYl
 9i5zpq17xlvgFc5sZ1JbIqPgaso2Hw1vKx04gar3yo4fCLMvFinkQzcwkCvB85pr57h7HBtJtmDYimyKOs4F0VuDD0KplE2x6SQ9CvSzUMYiPxQ8QGwEadDJQei0wb4Zrbh834Ku1yFpWHzvfON89qR6P/4ya1TPKLkPICYqsiNWaQ98V50kwyragNyX2hbRv5u38GM06HMnllVZ+chxPdUJjh5XbJf3zOqyAVUDpYnNn5ypxSV/aL5YmUiyrioRSkhZnKaEiS5uZSxPfJvPMC+YRkcKeuumeqcBTpanM3uX2wMb5zEaR9FrS3YkfV5fpsJeOCY00ZuMwj+NTUfdGcQnZUBWoaRZyGGW9fcmPgdG2eRA5Kf45VeQtaF0K9Avwj2UNbUW9yR7CcHMoyepZ/23lCj+funDtcyut0xhkAEtWfRuxuhuOAWBVjBLdDi50HTILn0mzRWcdBCmjwrUnXPVDYuTrj5qvp07gaV+MHQWDQTB913mQ9K1qVlwSiIQ2V9WCR1stpedPfbeAe6AmqBGPqyNCe3qEsyLEIfCmiF1UZHASr0gcUSFBPgSpbX+/3VdK2jMwHq7Zj0AaPAjdJAJR0u7bgpDGLYqQ8rpPJTNDlnxQ28RV7V2lMOe0IGp6LJcCFe3gMZQ8pnLH5uoxxJy/KA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 22:26, Ankur Arora wrote:
> 
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 17.09.25 17:24, Ankur Arora wrote:
>>> Define fallback versions of clear_pages(), clear_user_pages().
>>> In absence of architectural primitives, we just clear pages
>>> sequentially.
>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>> ---
>>>    include/linux/mm.h | 38 ++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 38 insertions(+)
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 1ae97a0b8ec7..0cde9b01da5e 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -3768,6 +3768,44 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>>    				unsigned int order) {}
>>>    #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>    +#ifndef clear_pages
>>> +/**
>>> + * clear_pages() - clear a page range using a kernel virtual address.
>>
>> I'd just call this "clear a page range for kernel-internal use"
>>
>>> + * @addr: start address
>>> + * @npages: number of pages
>>> + *
>>> + * Assumes that (@addr, +@npages) references a kernel region.
>>
>> And say here simply that "Use clear_user_pages() instead for clearing a page
>> range to be mapped to user space".
> 
> So, comments that actually speak to the use instead of technically
> correct but unhelpful generalities :). Thanks, good lesson.
> 
>>> + * Does absolutely no exception handling.
>>> + */
>>> +static inline void clear_pages(void *addr, unsigned int npages)
>>> +{
>>> +	do {
>>> +		clear_page(addr);
>>> +		addr += PAGE_SIZE;
>>> +	} while (--npages);
>>> +}
>>> +#endif
>>> +
>>> +#ifndef clear_user_pages
>>> +/**
>>> + * clear_user_pages() - clear a page range mapped by the user.
>>
>> I'd call this then "clear a page range to be mapped to user space"
>>
>> Because it's usually called before we actually map it and it will properly flush
>> the dcache if required.
> 
> Makes sense.
> 
>>> + * @addr: kernel mapped address
>>
>> "start address"
>>
>>> + * @vaddr: user mapped address
>>
>> "start address of the user mapping" ?
>>
>>> + * @pg: start page
>>
>> Please just call it "page". I know, clear_user_page() has this weird page vs. pg
>> thingy, but let's do it better here.
>>
>>> + * @npages: number of pages
>>> + *
>>> + * Assumes that the region (@addr, +@npages) has been validated
>>> + * already so this does no exception handling.
>>> + */
>>> +#define clear_user_pages(addr, vaddr, pg, npages)	\
>>> +do {							\
>>> +	clear_user_page(addr, vaddr, pg);		\
>>> +	addr += PAGE_SIZE;				\
>>> +	vaddr += PAGE_SIZE;				\
>>> +	pg++;						\
>>> +} while (--npages)
>>> +#endif
>>
>> Should indent with one tab.
> 
> Will do. Also acking to the ones above.
> 
>> Any reason this is not a static inline function?
> 
> Alas yes. Most architecture code defines clear_user_page() as a macro
> where, if they need a to flush the dcache or otherwise do something
> special, they need access to some external primitive. And this primitive
> which might not be visible in contexts that we include this header.
> 
> For instance this one on sparc:
>    https://lore.kernel.org/lkml/202509030338.DlQJTxIk-lkp@intel.com/
> 
> Defining as a macro to get around that. But maybe there's a better
> way?

Can we just move it to mm/utils.c and not have it be an inline function?


-- 
Cheers

David / dhildenb


