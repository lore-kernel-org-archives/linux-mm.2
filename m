Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF7BCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094C88E000B; Mon, 20 Oct 2025 05:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06BDC8E0002; Mon, 20 Oct 2025 05:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9CA78E000B; Mon, 20 Oct 2025 05:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7C3D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:02:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63B5B140738
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:02:20 +0000 (UTC)
X-FDA: 84017901240.04.F356333
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id D7EAFC0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:02:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Egq8D6Hr;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760950938; a=rsa-sha256;
	cv=none;
	b=A22JbhJKXjvhoKhEIqmDk9UVxxBTOIwFKR2jJvbBR2Xf1xlDu9bGlvnuccJRNpUJ0EpMc2
	Pt5wRwFdyo4gr7lKUs8EpvLExZpERAdmmUME00q91ujtdw6/FLA+w1WQVpnE7S+7RJRIKb
	U7R22knjkFx+AHsBO+8Q2qCkfkrebGY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Egq8D6Hr;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760950938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuekmEGKIc9oAsv4aXr2IF/RaPwPqPMIddn561w2cJ4=;
	b=MQ1FhzOno+eJPGRLHSp5Qz64vJUdChiU6OBrxn0n/4VxQW5yS/kS/+4O6hd4SIB7kQQGTc
	0I07SLSetOszj+Qet8TCf8V0iTuNrh9bU7RUtdKTWBAAUyOz/6WEMcRKqxI/00s/dGnrLP
	2PlBoYpdj9/mPFSiHXxHJMOzQqDITXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760950937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QuekmEGKIc9oAsv4aXr2IF/RaPwPqPMIddn561w2cJ4=;
	b=Egq8D6Hrvi5ZErD0YQhAge1mTxIC53C+UQV7AC9NXJj8PwQx8S6oIRzXJuKAdz4iHbWQgA
	T70wZjgX/Jmf9Irmkz5b1KFkP77goQuQaRN/HqhT/LoyQxYdZtIgrmMm8Zxe13Ms6KM59l
	XdTgapZ3oq6Lch2K+Yr83vuVSHA3+V8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-csWIqbbVM0KqxVT6emDh8w-1; Mon, 20 Oct 2025 05:02:15 -0400
X-MC-Unique: csWIqbbVM0KqxVT6emDh8w-1
X-Mimecast-MFC-AGG-ID: csWIqbbVM0KqxVT6emDh8w_1760950934
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471201dc0e9so33516145e9.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760950934; x=1761555734;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QuekmEGKIc9oAsv4aXr2IF/RaPwPqPMIddn561w2cJ4=;
        b=r+IGkrGobuJHwVgo//hTGX3sHemrPmdy4Dk0VPdHtf5+cORmpj6UcTlntTtySII7mQ
         CuWHkzGcUAv5y6EZF9te9Wd9qVxQf10Pm6U3HTPqC5sew1gmoFRuC68C2eqkscgsc/J1
         +maf5n1zj42Z/ByCSDKWVKE6IuVJvqWibFeN/SlNdxKDqiRfyppp0aUW2AqFW6v9bb9m
         7TmudwQn5kLvwIsPp7WtbJrVJeasYlP91adTCFY6ZqHZRrAEjzRTylDayAedYXGR+LlN
         gh9WKjc72XFYACbUb7JueMej8KrCiS2/u1U3/wToEfqz68Xc234mneQwEIIqUzkGDyEW
         ph2g==
X-Forwarded-Encrypted: i=1; AJvYcCXQmnodqNyqXpAla4NfaS8VPA8Q4Kn8b+XqRzX27ZSvkdq0AbuAWdO6gVRQLmGk3hijqpBbx02B7w==@kvack.org
X-Gm-Message-State: AOJu0YyxF5utTKiKWRF/A8kGezhqfPJgXl7oCrv0YNIZQZe9OaUtsr9Q
	XHMm10PI5Vk4eBefAeQpXiUpsnEmG0gIxKwu7leaCf9F6RiCDADr0oiN5LDIq/8VdNfTt4q6yDg
	NiK9ulBsjk0XaJL8FHHeKgOPXLiIIAVYbQ4SaL1uvojTHNtRmeinV
X-Gm-Gg: ASbGncuiwz/4B8IEkMNmGxCb4Whdnjq1IFqbDBlKlrsnHKFE51/iHHJKGIja7rg9mR/
	ZNsG7Khtg7h1C8Lz/gKX0RS/UeX9q9gkGUfOzRA+e9C8zNb8Og99YctB57I0rJfgXMFZN82a4nw
	vH3lLbbshteuwV4m4h0BkKJCnMQ1O1/lZaEbVmQNUuXMedNNrLeNCtm7P+DgKh965VLQn/KYE0h
	qQALa45478wvimx8Yd8XzwQ4RLhypHD84b/yQ+DVcqV+BiBxIesbbNxGh3e0t+aj1Qp1qejxt0S
	kLpoUCEsoGGv8sQa6kbc7oW2QiPPPjvoKCxUhPa5KM68K9VoJ+aLPgxZkoWBt9kh3vOQ6oaa79Y
	ytHyeseNrdlmr8D9Z+lq8K9y85Qs624T1Hev7zvLat6XCPohefxa0mRD1imQ/7RdDVNXy1wdaE0
	b9pqFhObde87VDi09i4lFIu3UkgJs=
X-Received: by 2002:a05:600c:548d:b0:46e:436c:2191 with SMTP id 5b1f17b1804b1-47117903f96mr96029385e9.25.1760950934412;
        Mon, 20 Oct 2025 02:02:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1DonHpb64xG1WbeBu2Y+NhpauxghOKViVl2XfaV+Qeidr8X4r3P3iJaCt5aZBDZmdVQeU6A==
X-Received: by 2002:a05:600c:548d:b0:46e:436c:2191 with SMTP id 5b1f17b1804b1-47117903f96mr96028945e9.25.1760950933865;
        Mon, 20 Oct 2025 02:02:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711c487dfesm202712265e9.17.2025.10.20.02.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 02:02:13 -0700 (PDT)
Message-ID: <635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com>
Date: Mon, 20 Oct 2025 11:02:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
To: Jiri Slaby <jirislaby@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
 <3e798b9e-4915-404f-9197-ed3c32587141@kernel.org>
 <85707316-3f2b-4e29-b821-a32f9097244e@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <85707316-3f2b-4e29-b821-a32f9097244e@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qwq49h4Nv25v_5jQEADJ3F-H6Nvcl-u57yK5i6lO1q4_1760950934
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: aq476zummcbc67uh5ggxs8t3fw6jn7wf
X-Rspamd-Queue-Id: D7EAFC0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760950937-399953
X-HE-Meta: U2FsdGVkX18ipK6qpbft3COks13XVN2qNbk0SmL/iInC5VEWyRi6iCpoH1rUv+zDyABKU285mz7Z0CJ+/O98MItrWGjdYCP+RKT/YxK9Bpo2SNq/lmTDxZsa4z9Rc/hiEY2zdKj5svxIlY8ld5+IxUlGrlZYjRX8kWo0xZM9TkQ/nVywQx2cuEWb7HVRzwr6GgrfNlRDQxbYlik4XS86Mj6RrpSefFzqgaxCowAhqelPH8ePUlUNKiB/QFTkSk2mIjwgzAlhZqbqQ+X+E9vvIXJMUswNnuv+eY8PD7V+uO0IWqjhLqETtz2Wui+fnKOQB3+fxsds5gDlcSwN1+aBvdElzhvy0O6dDT51kXZGFGUu/5XvwkR2NNzKgnbvtt5tDM/pGBTDZUSnLVQIjvaEMj56sb2qmqwvwewFY2JQqLT7tF0gYYS3ScyAnJSH86j/avykd/11dixSAkiZDAV9BvpmQkymdMuIcMhuTFpWkKoFj8YHsIEFzgrybH2JWexKxmzb8UDRPgRwXOZFcyIexSbpmiIHGKFzzP+pssVHjKXJd5oFimQLaXR7fy9SA9KHXDa3e5bT0o1z8JrLxJArAPXfPbK5tI4QoFzdAj7V63pY6rQ/yQgGbKNnyRADKy1tY9Zdm8ksHm1N7o9jWK70Tq/Iyy25xiQMzpcD2kTTe8Is8SmQLpPd7BKbJbzfvvK2fjAKP7+hiXsh7CCNb0FiITQ/v8GIW+qOpmGjLRl7UwYQIIi3oMgpaUYdmpEjoU/stRUcUr0AXYRatbG8j0IE6CfxtaYXealOxamlGbl1V7fSQ7p7gTVfb3fVTlJ+W/lzhHe6RYWBegIKOCzNdwAku0jzr9ooPSQ8Hb8yynafcNbWGuVd/EkpIYQZBue1X1GgajY4K7QbYuDSkQoGNYxm+DeXZe6hoedCGrv7NjnFJc+X0+EbelBk1TVONUje5O9O5oNXryBGLZwSzIAnHAL
 2acbJmFO
 giRaOhyscoR2wfPO9jalPQfuG8+/sjVfJn2xywDS9xzR1d1hi+g4SRiFUt9EypsEWhyzTpZ1iISI0wnvVRz7942KtcVMwpHTslcbBcllWa+oL078hWyCq6W5Z63tP5qMtIL7nlLavb9zdno6i8BdfXHfoLkJ51dttZZG3UEGxUCWBX/Y3szlFuaClCxiMZeG+FlYf7MplSQkuoJFGJK0F84+DB7GUoks5wnzNoAh5WGc0c6X1mwmjBhKL3pWWhdpTV9kwrIn8u5gs33gagc5V/z78MkV60J5yEuKk4eINFi29sDs0rdmHDx99IzHlfHXmUnS/Y3AcghRBIsqt9RSikeqEALwhQ3tzK5fMQHcjGzBr+BXcteft4E/8kBKMP19sLtPdDfAWcf+z8hmLYz466sF5jwdWqgPq7JGqP4nfWTPI79NIX9HusmD51BXbnrMwABNRo0S2gwsX27G6thihh0NZXLY8+1GQsvUseGxeVUOCM1O/ly+SDM4v0wr1jP+PiCHJkXuW/VIwieOY3TeOXE+M+MryisP9qniWTKPXlryx9WobdhdfMM1HB0LXI746aRFysAQDZCtTOI8UitPD8BIfBBuaJ3MnSRgmAup6wfoxqpVGKWQcOl2NLG7Ad0Als6iMSE6nkoFnWtROXSkSTeNrtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 09:06, Jiri Slaby wrote:
> On 20. 10. 25, 8:58, Jiri Slaby wrote:
>> On 19. 10. 25, 2:30, Matthew Wilcox wrote:
>>> On Sat, Oct 18, 2025 at 12:29:59PM +0300, Mike Rapoport wrote:
>>>> Vast majority of allocations that use get_free_pages() and its
>>>> derivatives
>>>> cast the returned unsigned long to a pointer and then cast it back to
>>>> unsigned long when freeing the memory.
>>>>
>>>> These castings are useless and only obfuscate the code.
>>>>
>>>> Make get_free_pages() and friends return 'void *' and free_pages()
>>>> accept
>>>> 'void *' as its address parameter.
>>>
>>> No.  Linus has rejected this change before.  I can't find it now, it was
>>> a long time ago.  Most of them shouldn't be using get_free_pages() at
>>> all, they should be using kmalloc().
>>
>> I'd be interested in the refusal thread (what was the rejection exactly
>> about). In a need of whole pages, why would I want to alloc more for
>> metadata (using k*alloc)? Or what am I missing?
> 
> OK, AI yielded:
> https://lkml.iu.edu/1512.2/03853.html
> and an LWN summary:
> https://lwn.net/Articles/669015/

Right, the interesting stuff starts here I think:

https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/T/#u

Personally, I was always confused why we are even using "unsigned long" 
in the first place.

Regarding the metadata overhead, in 2015 Linus wrote in that thread:

"Long ago, allocating a page using kmalloc() was a bad idea, because
there was overhead for it in the allocation and the code.

These days, kmalloc() not only doesn't have the allocation overhead,
but may actually scale better too, thanks to percpu caches etc."

What's that status of that 10 years later?

-- 
Cheers

David / dhildenb


