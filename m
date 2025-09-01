Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A44CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2598E0030; Mon,  1 Sep 2025 07:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052BE8E001B; Mon,  1 Sep 2025 07:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C978E0030; Mon,  1 Sep 2025 07:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDB3B8E001B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:15:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 531675B782
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:15:17 +0000 (UTC)
X-FDA: 83840425074.16.AD29C6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A6D81C000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:15:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=biUPHejt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756725315; a=rsa-sha256;
	cv=none;
	b=srOE6WvuA+gsJer3Qj8A0XMPXswe3wqowgF7iom04LROuqUqjtt0Y8DXNvRmPbsGPkvdCW
	V3z2z7QnkthLTSJYGahTpDKIC+puVZxNEZoBNX5lFi2tr95oEo8/qy0NI+6fiIBtfy4vug
	tOeDElSmdM09cVKeN50hdOQdyFHmIGM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=biUPHejt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756725315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yi7Fwi/+6Xe6GmqjrFqnM9yl5saNfH6dnB6Y6Wd5wdM=;
	b=AUfo6wJ3lf9VgzZ6OP1UBk3Gag8YuzTZ0iHfl4RLotxWmbmhL2sBb1khECO+Y48b8L2Osv
	5XV/ngqYxNrUJ/bMnrrTq6YKWUfFYmr5Y++NKSHYdbhJjf7RrwDeM++V3JFQTacqXRTJZm
	GzkPYTcLQMGgg5XgymgZ2+2AVdGhWik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756725314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yi7Fwi/+6Xe6GmqjrFqnM9yl5saNfH6dnB6Y6Wd5wdM=;
	b=biUPHejtf83Jn4gFUUEPq+ydltfveDqLW2r9VOaHhuSI62PJR8UbZPwjuVNE6BkGnTyWuo
	WyY52LqtpQawO6jId2ebMyDynXoUtdiE1fRdpWJ/6y295toiRxan0+vi2amNlq0SDC7AC5
	dBy/E3CH87ppuod8GKdEsYT9elGnWf8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-jULsuwPSNCak_fa76Lo_kg-1; Mon, 01 Sep 2025 07:15:08 -0400
X-MC-Unique: jULsuwPSNCak_fa76Lo_kg-1
X-Mimecast-MFC-AGG-ID: jULsuwPSNCak_fa76Lo_kg_1756725307
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b71fe31ffso25358505e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 04:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756725307; x=1757330107;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yi7Fwi/+6Xe6GmqjrFqnM9yl5saNfH6dnB6Y6Wd5wdM=;
        b=IpLMx5vmqmxow/VmMHadsDBIXydGFIc5YA5oY+G7lPN4MVaqS5KgyFudvzCqAjA8eL
         VlRv7mkAKXA0WPAZ2nVVi7JMKLE8MEd9GG0DsZm0FWrT/1jVK0pEkwgNAAIRGnGMQQpg
         uZyRCeUIg5Iju6/JIWnUNDdQaO8kxTk84Zc6IThyd+EWlt38Tdl18AzaWCVlqSa0qtwC
         meYzVlRFjKEfoheGu86jY6WJOBtGIvkGqn94cHHMc5iwU86PwE6S8APR9bqsxcjtqTsP
         mey+UribmmN55FjNBaI8xeONJ7t6yjSipPqECqcY3wJzJneCMe5ywzB8/39tYVGKJQmk
         Lqpg==
X-Forwarded-Encrypted: i=1; AJvYcCVvxUO+pu5TfbjF5Zt2cqajObsD/P3MfcCPAdMa9PrX8S9nDQNs3RvaLD3xUeKopWt7M5I9fA4MpA==@kvack.org
X-Gm-Message-State: AOJu0YxeUJyhDm3F863CFgous58CupcnoYdh7qhERlqL1h2kIg92gudb
	w76pPRWerEumuOjxfY1fqYc2ldDqG9RZ4h1Mua2kwMi5gQym0X7pCTAFR3OjyJbSPRK+lWxnX9N
	fgHXHNV5BOCHKDxba0L3y7oPltfUcShiuibjMCNe1jtwBqE0sB4Yv
X-Gm-Gg: ASbGnct32ePlCLHMLxjhGH+yqXxh947/50kV+FqsqPifxAUMtT1MuDNwfpvMnQWueKQ
	xvgGV5zP4fNLN+x3UauTWIcAwvJm2akz0il3CQDRX6hcaVKe6h4Ju30TjStD9eVSiFiN1jdlC3F
	CMi8nEXoAbTxHpc4Ogh9m5pGbJpu7ZqMt+9EdVYyRw/Vs7v2QUbUiy8VzAf5Xdn/gGRhXHNfnwE
	WC0jjjRQmg+MkxT4ilhw9evIvw0qDZ07MuE/9Q0lCvMCvlL4PKab1ORgFXEHlObdfnht4JsQEAI
	dVaf/1uX6owVFS6Fh9j5IerMMJ0YP8osoy+9I9YTnsXUrrn1nv2K1RcAJKJj9T1CWaMb3U2HJl6
	Il21WwG/Z2oTQz1PIQ979Hv/I5FkCGebuU4WjsK4zPz+Nn4Z1nkROQouQLjuQ5vFk7Tw=
X-Received: by 2002:a05:6000:2302:b0:3ca:6584:be1e with SMTP id ffacd0b85a97d-3d1df731ca0mr6960294f8f.63.1756725306865;
        Mon, 01 Sep 2025 04:15:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmpXAOfkbo/7ucu8U3sPdowTv1nqSV9h2Hc/DFrooZf0d2o9cUthDbRMo3GY3Vcoa9zmXMdQ==
X-Received: by 2002:a05:6000:2302:b0:3ca:6584:be1e with SMTP id ffacd0b85a97d-3d1df731ca0mr6960216f8f.63.1756725306264;
        Mon, 01 Sep 2025 04:15:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fbd01sm15189382f8f.13.2025.09.01.04.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 04:15:05 -0700 (PDT)
Message-ID: <e42641a8-0f93-4441-9a96-7ed99f4d498d@redhat.com>
Date: Mon, 1 Sep 2025 13:15:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] mm: establish const-correctness for pointer
 parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 willy@infradead.org, hughd@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, conduct@kernel.org
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
 <f065d6ae-c7a7-4b43-9a7d-47b35adf944e@lucifer.local>
 <CAKPOu+9smVnEyiRo=gibtpq7opF80s5XiX=B8+fxEBV7v3-Gyw@mail.gmail.com>
 <76348dd5-3edf-46fc-a531-b577aad1c850@lucifer.local>
 <CAKPOu+-cWED5_KF0BecqxVGKJFWZciJFENxxBSOA+-Ki_4i9zQ@mail.gmail.com>
 <bfe1ae86-981a-4bd5-a96d-2879ef1b3af2@redhat.com>
 <CAKPOu+_jpCE3MuRwKQ7bOhvtNW8XBgV-ZZVd3Qv6J+ULg4GJkw@mail.gmail.com>
 <801c5eb7-33dc-448f-8742-256ac40f357e@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <801c5eb7-33dc-448f-8742-256ac40f357e@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IhWY3IsW2MNsECp7I07yYGl_ZggkdVaTRTnAioTbZ7s_1756725307
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A6D81C000F
X-Stat-Signature: jp98n3kj3pgaemuffcdmk9pdjm1z3jyn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756725314-982945
X-HE-Meta: U2FsdGVkX18gu9CgVGdGyHmRtgh4jFxRJkSM1vZXn6wjqavBsh2j791HLBbJFBoZrLv8J6cdoQgFSd02Bele/4VSEYHd/hQIlGGaoGIjQv2v0oWq6SojzR/zFV3NWq6SiZFLHe6+51e20p6rDtr7YkelH5buejJK3hGfh7vb+9LtD0A6ImYOVo3MeA9qUk0s830xlrVX/miQ8FPtl+3cq3xFlXN2TZ2II46/9WqyLKaV2JR1MsIOip3Nj/AhbTA1wvT+JW9JJOqyS6mMAF3gTDrd6XOkgRtDFzbp8SPnbWWkF8x5Flu7pb7gOB+Wc+xKFcrO1o9zB3sCoAjrbQCEprh1oB7o/rWD+Lf+RakFQ6EVhW12sSOVWNFjBZ2LAViTVgKgLP8Yk1V30Bk847MUErTtb5u0pWPNbCwMEdNQvR5YLb+A8NCjOyh2pw7q2gKLc1H9lFbCr40qDr3JekSm+5cwt2vHyBskQYR0mD5DwjBMQVBMp1eZG82VLFBL5Zg7+R2vaW8dzhIDv7V43+z8nOfVtspoDLYCX1d7p6Vd1DMRL/8C1PzISsDuqBT4CKF1FAkBlC9EqXB5nwoShC/7cehUbq8iMjG+aeuQVyWlOv74sfxfvx9uKQQQxozuRzCFyxcn+va8eDyzkwVEY6XS6IQ4StKofIwjkB+hUrCJgsmv1NOdf+vgw0+uC3Ke6eTJP/FKUirmLDuUumuunniv/TUag3rwQNJsHKE98El2i8a1f/TsLiO0LP3k0Sgg82Y9LoIGyUODckl9MnvymJ0Dw8xwxBV+mDVaTB+uEANTqkMu0r3gA8Ozw9y22eGVEfaRGOqCsiws8c135XPeT8fwmyH8rSx2P/jcCt2gP/MFuFl5zNYFU7NROzwX0GwPU32Q0SWNxd8yejmWqLoVnggpYpjgRlWJ1nU6rCx0u+dzpEEt8e1ecjl8vLIRtKKNAOkX+UOewll/Q9nWK6t/ivn
 5v4aqGRZ
 uq3712GqUJswiQX83RT1Za/ZG97zjhx52hUegWsWSEUnzUp1byRyrkxisQwTarUau2ZvvADyjZJhNcAGcYZWYfcwMXeX7j5tJkRL0FI2JT7Cuq9j7BnSul016hgQk4M4JTRpNNScToSR9glEqlzFK40l8k0Qt9AlfeskKb90n4b8GfKI7KYdKp767Zf/Kxjg2MGr8KbbLdzHy0e8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 13:05, Lorenzo Stoakes wrote:
> On Mon, Sep 01, 2025 at 12:54:40PM +0200, Max Kellermann wrote:
>> On Mon, Sep 1, 2025 at 12:43 PM David Hildenbrand <david@redhat.com> wrote:
>>> Max, I think this series here is valuable, and you can see that from the
>>> engagement from reviewers (this is a *good* thing, I sometimes wish I
>>> would get feedback that would help me improve my submissions).
>>>
>>> So if you don't want to follow-up on this series to polish the patch
>>> descriptions etc,, let me now and I (or someone else around here) can
>>> drag it over the finishing line.
>>
>> Thanks David - I do want to finish this, if there is a constructive
>> path ahead. I know what you want, but I'm not so sure about the
>> others.
>>
>> I can swap all verbose patch messages with the one you suggested.
>> Would everybody agree that David's suggestion was enough text?
> 
> I'm fine with:
> 
> "constify shmem related test functions for improved const-correctness."
> 
> In the summary line, but, as I said on review, with a little more detail as
> to what you're doing in that specific file underneath.
> 
> You don't necessarily have to list every function, but just to give a sense of
> _why_ you chose those.
> 
> For instance:
> 
> 	mm: constify shmem related test functions for improved const-correctness
> 
> 	We select certain test functions which either invoke each other,
> 	functions that are already const-ified, or no further functions.
> 
> 	It is therefore relatively trivial to const-ify them, which
> 	provides a basis for further const-ification further up the call
> 	stack.

Yes, that covers the what/why/why okay. For me something shorter would 
be acceptable as well in this case (as explained, due to "test 
functions" semantics), but as long as we're not in the AI-slop range of 
text, all good with me.

-- 
Cheers

David / dhildenb


