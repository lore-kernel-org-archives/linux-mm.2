Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA2D4CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447988E0006; Mon,  1 Sep 2025 11:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F81B8E0003; Mon,  1 Sep 2025 11:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0168E0006; Mon,  1 Sep 2025 11:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1778B8E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:31:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C57EA5BC94
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:31:12 +0000 (UTC)
X-FDA: 83841069984.30.A889A8B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4AD6DA0014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:31:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="AuH7Z+U/";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756740670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YTT8+1IeuyKjTNBNgyuW533+ZZMqmvm3Kt72V4BMjc=;
	b=pFzPBu33A4WtMZgt4SDeGLABqIqdqUPoAWBcwDZb1eS7gmEGnREAip8K3MWndkpJSfdf69
	WPysWK3L+lZFcAP/QCpJaEi8vCThYcOqDimxjAdJQOSaU1M6fBUZNUTx+VZMNUBvftouef
	MYBh7hXvWqc1qHx7LQXF0rIKHj3B3e8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="AuH7Z+U/";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756740670; a=rsa-sha256;
	cv=none;
	b=ejWnXsY/apF69Ug6bY9w36dxm5bUvgi58WL4ocke1G34piz86NT1VIrNx+/nlJJgAAzn1J
	S4CrvBl1UWSVHEB2u1cdgqZNROwB9lDFKHPI4w3BiB4i9Iq00L0SWvlldEgJK1XeCKpxc6
	b2rJPIFxQSAoQtztXji8fpAG+zUuQXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756740669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8YTT8+1IeuyKjTNBNgyuW533+ZZMqmvm3Kt72V4BMjc=;
	b=AuH7Z+U/yQl2C2xFC+m7kGs/hQar2jQaeFbb4wTV6D2u52wLDFrH0Junxvg+Q1iSAj251M
	Mo2UVvlbF++jcNpgXQLPpySL4n+VuoTYz4pESWAKOtTvfieFjBcOCswwNrObzBxYEGrSAV
	zGIMLHi+4OpV4NuIvGqiR/acyKhmo4U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-33n1d0MMPyWjDNIVfvUBmA-1; Mon, 01 Sep 2025 11:31:07 -0400
X-MC-Unique: 33n1d0MMPyWjDNIVfvUBmA-1
X-Mimecast-MFC-AGG-ID: 33n1d0MMPyWjDNIVfvUBmA_1756740666
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ce65accfc7so4044900f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756740666; x=1757345466;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8YTT8+1IeuyKjTNBNgyuW533+ZZMqmvm3Kt72V4BMjc=;
        b=CosNAPmS8sFGNwKgahP+UydakrzunqazuzXKPwSJaDyQEMaAnRy6UsXERXcKw7L8ZS
         jPJuQafZTClBEX07IZch6dRN+MAxePJbCwktEb0lmwPhe1OPkKGu3uV5zD/07iXJUnJF
         lxFP2KXtx8VHN19xflqEXbCkDnp3CjbHHUOLtFPtkfpQgSoJXCQ9WKd1M3Y5/Qx0qVU0
         yMK+phT6n7VGtOGJUJf58wAjGEHG3DSQsJwsDFgHjGHifgE95xzs9wDBMm+vlm8HIzQx
         fyD3Rdw5QEgvtdWvDSXMIwAIhrpW7Dy6CQp7ZdzE7eUpnwa5abMA9YD4WLFuarzmWZ9g
         PHuw==
X-Forwarded-Encrypted: i=1; AJvYcCVCfZo4qozW/Wa3FYL++iMcrGw8S99ltRRuu0w0B5ZreZlClHCFGo80KD9/vMCSdJObOJwphyTL/Q==@kvack.org
X-Gm-Message-State: AOJu0YyYhDUYvgBDX2nPLNt98iFzEZCF1FVBy2vdHOmvCkRGECZUL/Kf
	+g5UXDfrwWbZmolatNLR4d+S+0jCnIomJ+Dbx8WG74bgRwFUAkFIj4S2aNuk6SoDd74fGs2cvdz
	WJ8aym8YJSUo7mDh9Z+T1kIJ/caLQxvTNhFsSI8IRyn1dOt4LRJ4m
X-Gm-Gg: ASbGncuzBYt4r0ePRl6qTyfuitN6XJHpJXY310XIdLNG0nyCQuayDu5PGghog4P4PJl
	2jdlwLJHjYNx6IEqYoeO8yLML/qmEBoBCuVcqGtVYPRbLcVma7gtiF9/oLT3Wg+LaBMYH1SFLB9
	xPfk7hwrGarPEHT5KJnixi2u0bMl1PX0EdkZh4G6P4I1AQIalb3ikOKgW/vkxJF+AIyBqQISRNL
	pIWkqrh4qGfIppNGLrtV+SAkxAOW4nZvCu06PoQaQX7mPw6N4+kiah8k0zAPAXkefeHSN/cJ2JY
	hgJGGRSE1yAsNCcmf7BmBQbZDhbHa8YlrQju/J2KV4uNuq0J0XMBvL5C1IfIUmuFVwg7+5pvtX2
	BCukJfT6stJHJMHopCiCzoSm6k2SArRT2AUaw0+kj0HCYgbhppRo9wT4+Y0FcePET5sE=
X-Received: by 2002:a05:6000:26c6:b0:3c9:fc3c:3aa3 with SMTP id ffacd0b85a97d-3d1dfc07101mr7979310f8f.40.1756740666142;
        Mon, 01 Sep 2025 08:31:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKlIIY39+g2NinA80se2q6FMUup0twhlH6ge5YEtWwcm43BDQMJ3/bW/VElP4ZEtqi2ehfyw==
X-Received: by 2002:a05:6000:26c6:b0:3c9:fc3c:3aa3 with SMTP id ffacd0b85a97d-3d1dfc07101mr7979248f8f.40.1756740665572;
        Mon, 01 Sep 2025 08:31:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d690f2ebb9sm5229370f8f.20.2025.09.01.08.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:31:04 -0700 (PDT)
Message-ID: <4597944e-a8f5-44df-adf3-558940e88598@redhat.com>
Date: Mon, 1 Sep 2025 17:31:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/12] mm, s390: constify mapping related test
 functions for improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 willy@infradead.org, hughd@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
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
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-7-max.kellermann@ionos.com>
 <ce720df8-cdf2-492a-9eeb-e7b643bffa91@redhat.com>
 <CAKPOu+-_E6qKmRo8UXg+5wy9fACX5JHwqjV6uou6aueA_Y7iRA@mail.gmail.com>
 <0bcb2d4d-9fb5-40c0-ab61-e021277a6ba3@redhat.com>
 <CAKPOu+8SdvDAcNS12TjHWq_QL6pXnw4Pnhrq2_4DgJg8ASc67A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+8SdvDAcNS12TjHWq_QL6pXnw4Pnhrq2_4DgJg8ASc67A@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K43v2kNq94rRAW5i6XKPZhBgIY5tEFdv8Yo8vorJ6OQ_1756740666
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4AD6DA0014
X-Stat-Signature: u5t6koeusia1u4y6tom5uuaudkk3rawx
X-Rspam-User: 
X-HE-Tag: 1756740670-394735
X-HE-Meta: U2FsdGVkX1+M3gQ4iZQcRtacbJenGXv3byzf7iEVx+0NxEAxDnby2xBdwCSjxdCqsKvgOBqTQB8ZLsdRqCgoo5PXRPXG/gatkE5cKo6CHbd4y05Zd/BmtlrziwhFQjdSJoT9luiLpX2j8AsSCBUmsDDFKxZU3GQAzJNl/RC3mQRt7pimLL8qxHjpUZqEadvGDTWQ+svh47rwDB9YEqdNwsqZt6cn68hwitvBg0I6sTOXF4sgaC4emEa2HJbAcA8qxYjtDJdyBIQ5kx2bMSzEWIg8Uj8srbO5FbeI3w9KB97eH1Ve+0RDAlN3VQQI6HHiC6ATvlKQWQRAn3noc549vPC3Y55MW8IJQKHdUZGU58h3SHILlanwbC3fdufVNotf5mXSSUqe4XUrQruNYSoad/7J2g2EkRrxLoG/FcoBBlN6fILBFisTY9643wUyVGX2ZkRNlch4QCToy+5QacOM2P6i6ehjwac/T/VPMS5qYIl/XdddKdO0Bu/ftKs5ltV9SJ4cZ3R3QJLAlwcbxiqan96DTDAsgAJioKfrXqrqcpf1jAS8v0YX3VYt/sobiLL18UN4PkQq0O4HCNBKELII5O4iL6wQg+VD3EQ4X/y//KDtUBt0E/Nu2BA6ug3w4Sed8bZiFdvd3RX6iDsCQSjGuF3degEp1erljQ7ilRO7pvmWoMTGFVWzeF5Q3OhytL8pmpKwYVhyESawibKY+qIrwnfZowRHf4X2REx9d+lGOVeEYpipaD1hAZLROdscbXAeY4CWV/G4EwU6TQpZ6FJ1VJUd07+C6jlY8JPbvQi6P4Gh8J4YwP15JWKp5MM34kN4l8eizaiZvtR/suuZFvG+7RDsevkp+9mCdXnnLhDSr9kuAURq/30k30nbBa7HASxagMV0RogTbVb+f8Uyu87FWIxpzfIfyVC+7e5E3eCOMZzbBa4hmtOfFjuJaNWVTq6YXH32F2LIgffaVenEQYG
 p8P1WB/w
 x6pB+vOBuOmG63D68+XBcXGB4Yfua7fmJLNlwUva9uhwuw4oB7jpzZAHi0Pgc1jezWibCueRAsCI1FqANvhEpt1dquJOwHPZZkn4QmZeulO9VM8s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 17:22, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 5:11 PM David Hildenbrand <david@redhat.com> wrote:
>>>> Should this also be *const ?
>>>
>>> No. These are function protoypes. A "const" on a parameter value
>>> (pointer address, not pointed-to memory) makes no sense on a
>>> prototype.
>>
>> But couldn't you argue the same about variable names? In most (not all
>> :) ) we keep declaration + definition in sync. So thus my confusion.
> 
> Variable names in the prototypes have no effect either, but they serve
> as useful documentation.
> 
> Whereas the "const" on a parameter value documents nothing - it's an
> implementation detail whether the function would like to modify
> parameter values. That implementation detail has no effect for the
> caller.
> 
> Of course, we could have "const" in the prototype as well. This boils
> down to personal taste. It's not my taste (has no use, has no effect,
> documents nothing, only adds noise for no gain), so I didn't add it.
> If you prefer to have that, I'll leave my taste and home and add it,
> but only after you guys make up your minds about whether you want to
> have const parameters at all.

Valid points. The problem is that it could very soon become inconsistent.

For example, when I write a new function I usually just copy what I have
from the definition into the declaration.

For example, checkpatch complains about missing variable names and I 
think it complains when "extern" is used for functions.

If we were to decide to go that route (not keep them in perfect sync), I 
guess it would be reasonable to extend checkpatch to warn if "*const" is 
used in a declaration. (perl magic, no idea how hard that would be)

I'm sure there are false positives in the following:

$ git grep "\*const" *.h | grep -v inline | wc -l
403

-- 
Cheers

David / dhildenb


