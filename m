Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C917FCA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F318E0087; Mon,  1 Sep 2025 11:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF968E0084; Mon,  1 Sep 2025 11:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0768E0087; Mon,  1 Sep 2025 11:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42F4A8E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:11:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E880585ECE
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:08 +0000 (UTC)
X-FDA: 83841019416.16.0E69BC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 888E880006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WhtDTMzj;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMxdRy5rmNFmudF6fK3kGDCxNJBEq1WURzElFRewt34=;
	b=phffg5DddGQtkFZTVIwpi9v6CwtpsviMoBx0Fo7mxfpUDdMNhge9u9H1hfLMyMKm3pv82g
	gBxBexcIi0qZeinT39y11FFO0Kzc4WgOvhNIhkjKSpDlInw/3XkkLX3aajQRk8qHaR2kKQ
	nsa7vpPfpHj2ldR/QHDHonvG59PJnVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739466; a=rsa-sha256;
	cv=none;
	b=lzCVHBnvLy6igPGKMwBP3mOLcMVpk7wdPw+RurWdqXVlZGVc1zBVmKA8XhpWqiEPpiGpRY
	RzODPkHKuKAQox602g4QDGCoFDWwcP3ehIRQ/rvv09NVP4aeugNvueSqp4fdNC3IheBS98
	aRWi5IutnzobpNAJadDVRBNoF4x2kR0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WhtDTMzj;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VMxdRy5rmNFmudF6fK3kGDCxNJBEq1WURzElFRewt34=;
	b=WhtDTMzjCLQnziGezY/73U6GuzN9dIEkoMWBKWKG+f20gOlElqQrjBBc3w0tS6ZLEPx2lC
	8ZbQjbsf1+790XNgJNbc4PyQp9Uqd2W8qmNLnn6p0XrFFR2hi77oEdevtidAhmLDmz+/7s
	eeCaqI4L13WaPv9KEn5xNu7l2YTqUrM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-TO53Shf4OJKAe147whlueA-1; Mon, 01 Sep 2025 11:11:04 -0400
X-MC-Unique: TO53Shf4OJKAe147whlueA-1
X-Mimecast-MFC-AGG-ID: TO53Shf4OJKAe147whlueA_1756739464
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8dde54c1so6147015e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756739464; x=1757344264;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VMxdRy5rmNFmudF6fK3kGDCxNJBEq1WURzElFRewt34=;
        b=exzGvjx1J4rXzdkFpEltd64cqZxsYcUVqnd4z2bGqSllaa0fZ1EMQxICejhbv1krCP
         zY3063USHXIEoDaxlDJACVaFFQtP2a1FqW8b3rJyrSk5CN9vLsvap3G2smdlUDlMTB32
         YPyCzx7WY6uSa+8FgIWFgmZGBI3eWIGdgzhZ0TyYnaCsbR6ztXBzX2xBxne2LWKZXizh
         0R/u/9Q1l0Gc1WtVnaKSxMkV/Fs2ZcJ2CHJWMke2lPnq/Gjo/ck8nh8W2NBNJdC7D9cl
         yH/J13Sue8aMeIJi3amUCqU/2dzrUHONNlLI1lRCBcZP1Fmhgo+oOClB7Yz+p+l5Ogtw
         jMIg==
X-Forwarded-Encrypted: i=1; AJvYcCX7+rfdzMWLp+fkKNrP1fGjw6OT0SVsvdswOMk18OPdt3EkhFXAE5qaRO7lfays/c+oa8Cqrk9Ebg==@kvack.org
X-Gm-Message-State: AOJu0Ywo80G2cdqGuDIb3irF5QkKaZRLGUIPOy+FLA4GKjqlwaRFfiSo
	5DCAly5xFS6Q1mSxgdVgeJttJXo5eWJlO2xwEf1dSSFP8nkZnoW5k9x9pbzJ90tbPza5mdTNHr1
	fZuC122I2OklNOFY5jBSISDVug9LDapFJEYjz9wsAnhVksf8zbSig
X-Gm-Gg: ASbGncsR4lCMwDW+KdXxym4ALk8lKd23bJ8n3A3Mp3SPLs2oTJeNi1m2Kk064Fy1CgH
	uHbY6khraq8fDXrLUYBsRKqmgzO6Nct7s9P3EeTpJmb18VLXOoK31ZSwZP5HMx81iPZUMy2uC+Y
	54DaYbwZJBs622LZwqrdjz7pTW/CM6wz+NYpDrQfwU773yI+e6/w982OkIGzDX/Wl88ufukwip0
	UqM+TnKJe4bur63MLtBXZTzwCzDiurqjJS/ldUv9Cv7t94n4ZsVuDCnyKfPiRy5kgrz7loG5XFZ
	i8pjBoffeXpiZ1q0DKX8rT6ja2cInJ3Bylc1l2nE2NXW/rqyfklkLk3ZgKvBAXNojnhkBtTbxME
	GQ1Zqeueu8re2a69HYwobjvmDpFE+rTvSaAC+wBplPne1TObhnCel+D8XrppjuQ6ZpQw=
X-Received: by 2002:a05:600c:3b99:b0:45b:88b1:373f with SMTP id 5b1f17b1804b1-45b88b138cfmr49843695e9.19.1756739463527;
        Mon, 01 Sep 2025 08:11:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGf6Rd6PfORW/LyvT41zVzRuA2itBBI/jcr5+K/tI5o0lZ645Xd5UGGPJrfen/4NaJ0FQpwRw==
X-Received: by 2002:a05:600c:3b99:b0:45b:88b1:373f with SMTP id 5b1f17b1804b1-45b88b138cfmr49842935e9.19.1756739462931;
        Mon, 01 Sep 2025 08:11:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8ab832sm159807805e9.23.2025.09.01.08.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:11:02 -0700 (PDT)
Message-ID: <0bcb2d4d-9fb5-40c0-ab61-e021277a6ba3@redhat.com>
Date: Mon, 1 Sep 2025 17:11:00 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+-_E6qKmRo8UXg+5wy9fACX5JHwqjV6uou6aueA_Y7iRA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zGiI44DVo-eVh2-7SKE53FUVh3xsT2ltPS8JBtxqsdE_1756739464
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 888E880006
X-Stat-Signature: 596i9r5zzdenux794i4ricdx4azc1rmy
X-Rspam-User: 
X-HE-Tag: 1756739466-175397
X-HE-Meta: U2FsdGVkX19KX5YXFoR0OmSINbxC2QrcKQcG00v5LTyxAV+GK6c0sKa47TrgtsUmpboXBSvlO+Ihkuut2izHIjEAzhZe5gbW5aD5ewqyH2y64w7CcMGjhadKyMMYJrFdRJHTq0Mr63qWQTyBAbbBIemWfE/wax+adg/35iZFLk/2v1jdDK/ZswHskRbKPCUDc6fCz40ktzUlV+117eml6CtThRnAl2DifXq48Ksu2j6OAvb2L0PtK06IFEpkxlHZaIA9SaOtDWQem3Zlr3Hvb86UIKrmBAL2rObsPAiQhzMCqpqLaGvOJ0QRcYtGnxuCieFCgdCgQlawNdv2qgFEiso72V6XBYk4beChHFQZ7caoYbcMubuLg97YEH+19AOTuX118tOkEgI2sKiz3VACyn8Mtw8Gf4ZEutko3X2G7HN+dSclaFxRpDKmu/6AG7l3pRZKCittgR206eJSEmMYXkwlw+gE7OoTI5lGSH9hv5OE3M9sa/+TO3VujJZmlDSadFQGxgyWaYszpVNgfnKz19Miyu8ISbqm0schyTRrSqwV27ul5QYzIhfGjlJituJs8ZRThRO2I3qzT6OYPzdtVgEd3glFxkCVkfUaksXRQvZSkEYmEmbxZgHP2TnSjHuq66KiVp4X2XlCtDbZ3W0HLvhi4umb1GAWuhlc9afbdDiHVit02i/l5PQRxG5PsALnsS93BljJeyT8ZOQA1zg+6WoPea5gUsqosuBReuMUq2iA0WkcuTzU74889SCq/Q+zx1wzCcYyEs2jno6MCJm/aMpaYsIrGeErBQRso7ckDpnXiSHx/d69xUBG0kqlph3SZQFm7+RsDw6M6E4K/k9vlQ7WrCC57B06rrpIXc2vnUgcCtWQ/ftXydm/dhFqd2FBMjVOEplsLAAfzkItaEI1wDtF9uyIGpwqdR2p+IIJ25qwzIOdHK12W5TEunEzJrDPUipCKF4R10Z8LlPacel
 friSBR4k
 cwlMpW6Oe3uR8jLnohG3H4nJyhWwTRabStVT7xDyFBU3T2xmccsEib+Rm5gTwXsxix3xuVMH3YDgW8Tpiif1cArzK/5aEGRWnmx8OGpFs9dWyEkhXIfXfvrdSldeijW6XLTDMo2aOh11Wm1pQFXglFEWuC3WJPf7lWFxqWpEVRsl4WLTCINqjoGEnmh2GZazp+SNvlG/2vNU+P3M7zJsTA9pHRS+Jmzr91p2K1t0cRPGnFejuOFOSx+Ot/Z8AB7fFy8jNkAStCw9+WhzfQNM2QcSPAfX/Sh4+yixJJbdEZDnKygG8tOaJqo0+G5roKoGqoGgp1abgvBW5Puu/1Tz1wlGpsF+ejZ0818Yph91x7r2kow7xYiVj+b11/bWgiFBO5YLZ2jkRD2IDD3ZZveXZ+MvMxa8fogcGGMsMs0b8Nj714t4SYmyTT5YcXcO5P4CzoJbCOZJIUO5Gq3/GCEtiicj0nO/BAQDgzbS9hYxQHqhDIx8Xls7hjvyXAcxFOOika8npxTI17NNYgRrM2y2J3XDEaaEbQHegj1kTRyVvbQU3PhmmZ/EHNxjdvckzEgi74cYZ9/Em4DtuMbotIeSd9Rkc+XDjKXtNFbbc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 17:02, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 3:54 PM David Hildenbrand <david@redhat.com> wrote:
>>> -int vma_is_stack_for_current(struct vm_area_struct *vma);
>>> +int vma_is_stack_for_current(const struct vm_area_struct *vma);
>>
>> Should this also be *const ?
> 
> No. These are function protoypes. A "const" on a parameter value
> (pointer address, not pointed-to memory) makes no sense on a
> prototype.

But couldn't you argue the same about variable names? In most (not all 
:) ) we keep declaration + definition in sync. So thus my confusion.

-- 
Cheers

David / dhildenb


