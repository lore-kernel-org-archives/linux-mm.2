Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42733CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 10:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744BD8E0018; Fri, 10 Oct 2025 06:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BE58E0016; Fri, 10 Oct 2025 06:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A748E0018; Fri, 10 Oct 2025 06:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6628E0016
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:37:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E37CE119227
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:37:44 +0000 (UTC)
X-FDA: 83981853648.16.8ECF47A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 592934000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:37:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cQ10vAb6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760092662; a=rsa-sha256;
	cv=none;
	b=aMfhrOBqK5b4Y9Bn4hnF1qlTqrG8O1gj9ijgOGF7xIiZ3tYxiikfKfaiSfsZkLS0kWZHPb
	u4C0P0rJvNWUWQIkHvYm2wSbhNKw4IrUjRIBK9k2xjrJwcFv5+dm/bTc1rtVVZaHCp9J5Z
	l/P/4PRxbCC8EI+pDP+SXx/dU/I5iw0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cQ10vAb6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760092662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZcLT3+Hhy81+40lcv+ohV8TGpRZt73dTXjEdUTm2l80=;
	b=gKUnBLJA7O1zgpJm9h3d3BcQpsk+o4NQy/mt2L3xK7Ye6LJEwNcvEFCk/7e2XeJXl24SLZ
	YEQWIHnXqrg9N053UQEPQA0Lxu07BBAVn3I0NiLzF2RezusMev26kj4EbkqTlFUXR+jEcY
	nE0uS1Er5CeACBGZgh38Vt/G2Z9kPXs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760092661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZcLT3+Hhy81+40lcv+ohV8TGpRZt73dTXjEdUTm2l80=;
	b=cQ10vAb6w2hMECwgwA9yE3MjTGDBjB2BxnNRvsY0O1CeMFB8t4hPvGVkMRIQwfmvHgS8eq
	e+llWEqdpXHCaI1Fz2BNVOfe7lt7dybCop13pKvsomWPX4hoo6/pKBVgGT2E6q6myODSbV
	N3uzSjWrCKRw4Pmyk67x3GHXS6R5ICY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-4YtrJE-PODW25oqzogy8hA-1; Fri, 10 Oct 2025 06:37:40 -0400
X-MC-Unique: 4YtrJE-PODW25oqzogy8hA-1
X-Mimecast-MFC-AGG-ID: 4YtrJE-PODW25oqzogy8hA_1760092659
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ef9218daf5so1768037f8f.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 03:37:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760092659; x=1760697459;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZcLT3+Hhy81+40lcv+ohV8TGpRZt73dTXjEdUTm2l80=;
        b=wKT1xWS8rge6kO298ARc+uACpUqyUAmSXaMGVTZ6wfphe68XW36iOw2ACODwVNDc7g
         BxgP2ZAS9RThDXSAkh9AXXYxFMDScv9wr17/TkBj6JNDahtYsor/SpRKeiJp81aWPfJD
         zYQvt7f6eog22KrtLm4/5ErJRVKag37x7uH2gRZeqX5D3iBpWvKkMraov+0KrqmONM3U
         ErtF2ERgc8d5himHlLBDJBbfHBv579lBl0opymtovrEicHAxSgYUL55SliH8rRG2TXQJ
         txCvIhbJzcecZY+vTxa6wfu7uenvACgbIOyAjrSmKy27mXHfe4UKDwGNIsWMQv2FlLoE
         XELw==
X-Forwarded-Encrypted: i=1; AJvYcCV0v5SUp76PsYuAeVI0CowAbTq6ziZw+Idpv9Xi0PNNf7nq8ovklLjswcJVEEt36YNg5BkW+xXAiw==@kvack.org
X-Gm-Message-State: AOJu0YxaFmVAAdXWL12tHKglIzCiL9MAltou4YUfY17MGyj6tygOF6Qg
	opdILOlIhb37iLp/k+AZztw+hpMztBW/NgpukTRINcOKGpt5lgtKItuiz/3dqplnlK1HQqh1Fk3
	j6WzlbzsHlZwg/rANKvMWrK4DmjxVADwhaNHe9hGaQs6G83W5JFQM
X-Gm-Gg: ASbGncuv+ZhOKarP3JlxqbwC/SgSGm0gyiAS+yvFha+CMxVC4is+1KWCypUk9LsUFXW
	aS/uthXG5Rtzr5AwXpVtYnY1FXdbpO3HE4mtYfCn37Gh5jdAEBMNjkuCAJyVmIKxCFRvWXGK1El
	tpM3XiHw8Q7hnSo14HOCtFb07wqr/QnlqhKPJZPLcIuQtsDcRZfUPtqp2J7nM1OXOwnQwRH/OW/
	p0OS2iIE6M8qnX2mFTJ5fdDscDEnIs5KsMzCyg/xbB5lU3jtgJ8+s3oh3tVNAflDIBfuOqFo+2l
	X/O6CYzfpOvvvidmv1OAQEqYdLz2T8cihSbluP16jHXnf2H8tUa0WnDICWD6kl9UBuvVeXkV4xK
	aIUM=
X-Received: by 2002:a05:600c:c083:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-46fb32e5338mr26486435e9.8.1760092658883;
        Fri, 10 Oct 2025 03:37:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1nqiOJw5fC2cox3JVcalYsCVeMv7KovRWoYlc+4Y8rcU5ZCJxGEdQpVq3k/yGLKxM4x7vww==
X-Received: by 2002:a05:600c:c083:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-46fb32e5338mr26486215e9.8.1760092658417;
        Fri, 10 Oct 2025 03:37:38 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3cd658sm59223625e9.1.2025.10.10.03.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 03:37:37 -0700 (PDT)
Message-ID: <1b4e3a1a-eeff-4d48-9b1b-d20af1d94be2@redhat.com>
Date: Fri, 10 Oct 2025 12:37:35 +0200
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
 <6743ead5-4d61-4274-a24f-13a8a8265aee@redhat.com> <87frcbayt2.fsf@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <87frcbayt2.fsf@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xCzB8mV9QuEPEDnNVszSPKk1r16oEX6JlOWIEaUGu_A_1760092659
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 592934000C
X-Stat-Signature: bte9owcmjugry9ft8b1wjqsh1xf8adq4
X-HE-Tag: 1760092662-403390
X-HE-Meta: U2FsdGVkX18jYp/IAQhVtoeFTvdNiqi35erDwjkCkQ9Wnt3uDupLpO6OZV+dQARP7DgG8xHHt7pnPoeHZbEpyrTdUlrZtdcTExSt8ocHtc4ymtSU3AgfXDkpAxakha0e328/snXje/Ac5XBv8XPIjpiH+7s7nOi2ZQgqHSVLEZttSDrkSTsl+u5eJQ11mLUWp/p7caodYlLGG1ODv5fWVRvi/0rUZoewSvebVYSwWWu9T4XHiGg7f59NycSqhj8d3ZuqonnZWOhpbZjsVruIGo+2FY8kz1cd5VsqLd4GxiscBpZP/GMiaUnlcxKNlI035gbnUKAQgh3xXMLD5Ck6jMIc8Ie4wFQarcFRA7VUm/H7BHAqx8HgFwdVYjbO8hItuP2rnKFFyOgduBLgHOTuQvZhyPCYCOFzY4jbMxmfBmx2DGo/GPDyAOsH8rwxanKo6q6Ik8jYaS7DxW1oOV44f0+wxDyUrvPWMaiIxwbhzVI699b/pX6RfSngDO/aBWhsFkg45eQRe8BdAK8u26lZfMXV7NloPTH0KlD5p7G6c7JCqumlB88tfMmV2M12CzL+OjLSS7G7vzJ6wWKiykpO+76q9jUtrYi1EXOBaIsZZm8DR7D0rISqosqpdTsYiJfUi1X6XnoWUyofJma8c1o3Ve9oxc5Uy57TrkEUhYxY/kbaktVIihy6dS/r8ono37eDcqjdwDHWHhbbJ5ACEB8UWkUX4JZ7+OAPl4zjgY/2Z56xg0KWjkk/oLEzHzDBmUlFwWN0id6vXG6XaLonQS3EApFGlPcnkwDKG2td1NQEIik46tYCasY7l8H/0qt8hYyjqNAj9drs4UbIch6CTh587wnimU7eSD08iS+4QxkI0axvFlaU1gX1ZY5+3TiMxWOtW0cG4TwITnaohbMAwsK6R8nk9CXrskluz4lr/uu0QMx0TfxnzHiKV92mPo8I+d+aW5GeQSJWM9keTHceeLG
 sUEXS6xo
 /gK57jW0zMu2wS6Np9fgfZarEnnSAfA8vKZRC9XwfTbuYZOOeVHD0xqPi+s9uzav6GFdxSNzoFbXT+OLF+UVEHE5pKEK2ljtMrO7AKNlkC5/E3q+sCacIixozoUmMQ3Cu2ptIkHE5JDzo0xjAgWGmZcChJUIfukaxMZQchEp12G7MgTDt7VX3A2sFYqE1Sf8sUq+jiSg7ylIXn0csjg8IPgrMgmD6oK2S6S3HszJthmsBeSXhKYMjyeNbtoV6tqymVNhh5qxVQuV5uDrkG7Xmq4f5hiEbTwWZjZm8uvAIr0BSgkXciAikR1oJfpV9N0A54A/BTuvvPPjDpFpZ8PR5VctNepNGnPX0Gwzcy3MG33/qFHvFxhcof4yaKSvyRJQ+qGpU1bP5pLC1QrAlf3bosAEmHxl4R+HQs2/5tsUtFOFPZyo8HTOfFKy9gdjmfHt0XbZb8cZtm/TaQBAYOlr9cN+5TmF9xvkoUlLQldQJ8vHnvpdK+shuiRXoYBgzdyAbybsHGmXbAfxmsEZ4NUW05y1ESrgfkl8GBHSNeHjlJsJTguSMaam+dpnP6mLXoKcdaZanfMsO3gGGUqz+DcUOpFJ5kzTiPAk8gXHY3KsZpcapPxAabBYb4HnpRzHMwJ9WHys/fAqVdMPl/zS9ZlwSAG8JGRB8NgXTQpDR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 07:25, Ankur Arora wrote:
> 
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 23.09.25 22:26, Ankur Arora wrote:
>>> David Hildenbrand <david@redhat.com> writes:
>>>
>>>> On 17.09.25 17:24, Ankur Arora wrote:
>>>>> Define fallback versions of clear_pages(), clear_user_pages().
>>>>> In absence of architectural primitives, we just clear pages
>>>>> sequentially.
>>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>>> ---
>>>>>     include/linux/mm.h | 38 ++++++++++++++++++++++++++++++++++++++
>>>>>     1 file changed, 38 insertions(+)
>>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>>> index 1ae97a0b8ec7..0cde9b01da5e 100644
>>>>> --- a/include/linux/mm.h
>>>>> +++ b/include/linux/mm.h
>>>>> @@ -3768,6 +3768,44 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>>>>     				unsigned int order) {}
>>>>>     #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>>>>     +#ifndef clear_pages
>>>>> +/**
>>>>> + * clear_pages() - clear a page range using a kernel virtual address.
>>>>
>>>> I'd just call this "clear a page range for kernel-internal use"
>>>>
>>>>> + * @addr: start address
>>>>> + * @npages: number of pages
>>>>> + *
>>>>> + * Assumes that (@addr, +@npages) references a kernel region.
>>>>
>>>> And say here simply that "Use clear_user_pages() instead for clearing a page
>>>> range to be mapped to user space".
>>> So, comments that actually speak to the use instead of technically
>>> correct but unhelpful generalities :). Thanks, good lesson.
>>>
>>>>> + * Does absolutely no exception handling.
>>>>> + */
>>>>> +static inline void clear_pages(void *addr, unsigned int npages)
>>>>> +{
>>>>> +	do {
>>>>> +		clear_page(addr);
>>>>> +		addr += PAGE_SIZE;
>>>>> +	} while (--npages);
>>>>> +}
>>>>> +#endif
>>>>> +
>>>>> +#ifndef clear_user_pages
>>>>> +/**
>>>>> + * clear_user_pages() - clear a page range mapped by the user.
>>>>
>>>> I'd call this then "clear a page range to be mapped to user space"
>>>>
>>>> Because it's usually called before we actually map it and it will properly flush
>>>> the dcache if required.
>>> Makes sense.
>>>
>>>>> + * @addr: kernel mapped address
>>>>
>>>> "start address"
>>>>
>>>>> + * @vaddr: user mapped address
>>>>
>>>> "start address of the user mapping" ?
>>>>
>>>>> + * @pg: start page
>>>>
>>>> Please just call it "page". I know, clear_user_page() has this weird page vs. pg
>>>> thingy, but let's do it better here.
>>>>
>>>>> + * @npages: number of pages
>>>>> + *
>>>>> + * Assumes that the region (@addr, +@npages) has been validated
>>>>> + * already so this does no exception handling.
>>>>> + */
>>>>> +#define clear_user_pages(addr, vaddr, pg, npages)	\
>>>>> +do {							\
>>>>> +	clear_user_page(addr, vaddr, pg);		\
>>>>> +	addr += PAGE_SIZE;				\
>>>>> +	vaddr += PAGE_SIZE;				\
>>>>> +	pg++;						\
>>>>> +} while (--npages)
>>>>> +#endif
>>>>
>>>> Should indent with one tab.
>>> Will do. Also acking to the ones above.
>>>
>>>> Any reason this is not a static inline function?
>>> Alas yes. Most architecture code defines clear_user_page() as a macro
>>> where, if they need a to flush the dcache or otherwise do something
>>> special, they need access to some external primitive. And this primitive
>>> which might not be visible in contexts that we include this header.
>>> For instance this one on sparc:
>>>     https://lore.kernel.org/lkml/202509030338.DlQJTxIk-lkp@intel.com/
>>> Defining as a macro to get around that. But maybe there's a better
>>> way?
>>
>> Can we just move it to mm/utils.c and not have it be an inline function?
> 
> Thanks. Yeah, that's a good place for it.

So, I'm looking into this and I think we should fixup the arch if possible.

I now have

commit 0f90e18abec6b6080af9ee5583cbba28d483a87d (HEAD)
Author: David Hildenbrand <david@redhat.com>
Date:   Fri Oct 10 06:09:51 2025 -0400

     treewide: provide a generic clear_user_page() variant

     Let's drop all variants that effectively map to clear_page() and
     provide it in a generic variant instead.

     We'll use __HAVE_ARCH_CLEAR_USER_PAGE, similar to
     __HAVE_ARCH_COPY_USER_HIGHPAGE, to indicate whether an architecture
     provides it's own variant.

     Maybe at some point these should be CONFIG_ options.

     Signed-off-by: David Hildenbrand <david@redhat.com>


To get started. Did you only run into the issue with sparc or was there 
another one problematic?

-- 
Cheers

David / dhildenb


