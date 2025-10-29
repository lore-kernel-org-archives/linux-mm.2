Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39556CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF4E8E00AC; Wed, 29 Oct 2025 12:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B875D8E0042; Wed, 29 Oct 2025 12:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76218E00AC; Wed, 29 Oct 2025 12:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94FFE8E0042
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:20:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4851914089C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:20:02 +0000 (UTC)
X-FDA: 84051663444.25.9512A97
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A15C840020
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:19:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UlCFdP4z;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761754800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8BU0dkWuvfJEpsUw9sXbhg+WFpR4l8NjkgoHnCY3pc=;
	b=Q5+/kSqiceVZI3neaen4aMJcA/3VIycbAaGNUFExPDX1cyFx1nKiw4kFfGzvkpKfuoyimN
	+2+oGNQlny7pUgcydat+8XE+n1PFkggak0WUzmcl7vyqiHEk2oYLv1hO1O3PqGp5gtW85k
	B7As4OY48JpyVMPh6S2XilRjT35s4wU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UlCFdP4z;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761754800; a=rsa-sha256;
	cv=none;
	b=PewYIb4z884YgSyEjXvRr3veQi3EJPtn2CzGQkj75doT0tPtrV1pwWh1XaD9iFTqAt8B7X
	Tzz64DoLjcUG1ENA6CT80jPXYXoaP6z5oD4MSuXlvHBd1XvOLiwsrrz59ZPia5dxKi4vdy
	xb23eLRGtrtS5f2+2VnodlYfgJPOpTE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761754799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O8BU0dkWuvfJEpsUw9sXbhg+WFpR4l8NjkgoHnCY3pc=;
	b=UlCFdP4zKIhoi9gkzX0H1hWSjV6nDtOKj42g2zFoufh1jRX1TxDEB7m+UWAaxK7qk+CJIM
	EEUCj46pTjhnDFywFyV8WMcbX7O8rP2lWW0Rr0T6YzSv9elIO+7SM+/63aFC8sOuWadF7R
	2wKiC/VF5XTWCyd3fRMReInV/cvkkh4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-ayx2ozAbPlWLsBUahQM-ew-1; Wed, 29 Oct 2025 12:19:57 -0400
X-MC-Unique: ayx2ozAbPlWLsBUahQM-ew-1
X-Mimecast-MFC-AGG-ID: ayx2ozAbPlWLsBUahQM-ew_1761754796
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4770e0910e4so79775e9.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761754796; x=1762359596;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O8BU0dkWuvfJEpsUw9sXbhg+WFpR4l8NjkgoHnCY3pc=;
        b=cHNx3tbCdnXRPodXKozCic2ApcgKEbU80LrXcegGXvtwCJlOjBJMHMRllmIhmB8xMS
         NygYIMLu1aaZhk/1elwMUqihWKYkg96ziZp2OWaXibIGeeZ59KUJhkDSVaV5QOifmD3s
         eQRmbwayBIj7OiLvzSzHkuZh/+V0G5GymnkUY/+4lZZurRZqKoRYFj1GOPKbBuWAWt3r
         9+/MGvaT4aQVBRXxAxFxP4swPNb0lXKZbBgZVr92HdmD080Q2qmDZWbPXwJQjiFAdyaU
         KmrL4iR7wd6fvMaxLBkqAckZ0xOpfQg3mR87PSf4fqHzZwqvJ31TKaKRdFRv4SpfQa0o
         6O/w==
X-Forwarded-Encrypted: i=1; AJvYcCWIpHzmpGmN52VGGePlkXeQnwc+zbGgkhFAzD3CwJo2iem7lbcBKIGwdjZA4E3Q4JmyeL+p/X1XWA==@kvack.org
X-Gm-Message-State: AOJu0Yxevzkewsn4Rn5VKhhNBvnhdBg7R2g/IxMU4Jm/Feslk3JyXhHE
	u3W7rgOHBViRUpVXjBf9qreim0cZocDbau1ZGTamOik2mZ0lk8UzVSuKt/JfrtGlNAoJL3JjzKh
	DVOrVDg+uZadj1gaG1F3FG+EHYDUFQHLtR3//Ax3jatIT0KJllRe8
X-Gm-Gg: ASbGnctLVeetm+wz+O33jAYPZEcRN5iOMIMPjA6aXdKnYGN/UxBDi67z6zg0wM9EdVs
	6YfIsNbghjGs5JN81aPCgKoLF6LXsPbAkiPLUVR4i8rpAdI6Ns2hvbX6RNVaX+vtPsogX7Tgb93
	bsS+oA5SR/7Z9T3KjQXVIYypNpmfPhiKNN+9g1IJzSKH5nCLU/jvLa071GVqVPPWHmkfq3Vfw90
	UTWi9hLtzZ1wxRIWouwxSSQkWEZxYKoGNnvJ/jYgPw9JHd6QlbEOhW7P5lsJyCnycuGU53Q/SkL
	LMdyQROBISuqw1nPlCWIGeg/bss9sOEga07wRI0AdF4YOVxPSqXQyvjlAc6EjTVohZ5rb/Ho4yF
	uEt5uVgj3yd0HYC2m5JHvlQ==
X-Received: by 2002:a05:600d:4348:b0:471:1716:11c4 with SMTP id 5b1f17b1804b1-4771fb455d6mr21112365e9.34.1761754796336;
        Wed, 29 Oct 2025 09:19:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHG1LOv2HbW/PxH7xRD2o0tTI9F7qkhwfuN6a3w5f9qITD5X7KXV+32AM9oHTvhZetC9jSCJw==
X-Received: by 2002:a05:600d:4348:b0:471:1716:11c4 with SMTP id 5b1f17b1804b1-4771fb455d6mr21112055e9.34.1761754795940;
        Wed, 29 Oct 2025 09:19:55 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e387aa9sm53806965e9.4.2025.10.29.09.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 09:19:55 -0700 (PDT)
Message-ID: <2bff49c4-6292-446b-9cd4-1563358fe3b4@redhat.com>
Date: Wed, 29 Oct 2025 17:19:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Jann Horn <jannh@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
 <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
 <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
 <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
 <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ve8nmEbuTri-uI4MAquNqhiyz5SrbBWJIUznTf2Jvn8_1761754796
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A15C840020
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pp6z7rpkjgs38moab6y8c1taoqtrxzfi
X-HE-Tag: 1761754799-194234
X-HE-Meta: U2FsdGVkX19mh0wH4Fg5Kn9juzu3by1xeQ6dKI6JBZg2vN+vOndL/R2bkd1GH3W7wwSGcS7eH/xiI8Zq3BEe3N5+Qa0KkNEjol0oXf2lfmfrB3JIBEBbxRb8S/PgOgiSI57iO4QtUnwNjBnhpDdDe8JEr6llxOGU6+AgXuJ16p7++IXSez7NL0Bh85ZW0gwAkCbD0Plg+2eDIcU/cdRlgBKPc7rKfknBAzcB0Wg2P4FPNK0GZXXxhxEfx1/79DTl6b9dDqBomYuAfIHts7fMG25XpQz7Rz6iI5mnSLccISqedPndUSPL0Hhe23JBklmscvWiNHjAvJIYcJRN685POtNHzS2Ih++Qh7eWSey+dHQ57il6Whk8TTfuS3kuJQsNAuz0B1oDJlA7cQfXjwAbFp+6iKAK73vegJJXrGnRyWc61fxvu23Bx6KSPFnFce7tcr3/dL3vk9B6UYXZ0ItEyCZnenM8xRz5cZpqZEhSVfZpiRMeBOBKEUUaHWlmO2w7ZtVgPMOtT+Ox9kT5oMiE2mf5SPzZrNapr+Xy0iIRmCPTLEcMfGcXgFTWYb6V6CbziALsDfYu0Xpvi6fB8nYL+IAR7tKy3ew32oAZp5Wy7ewJQdjtczHZfIwC5Sgt6EQwCnXB4WuPVjk1fH3SR6ca9x/+ZprynTrUNykVe/r9OKYkCU1SoFxVZO1hgqmsw1NnrGh+9oKIgwqf225UWGwbp43px5X2svTtgUjD2m/FZxqvcrguGjfkURJUe26TvGnl5vLR8FYxbFIPs3I758sIYi0mERuWJl1U0SmCo4jXPZaLMMyuncrEIEGGDc9/rUyoz9RqYAVdEBZxrj/6frFqNJAkiUXNeMgaSgh7OE1ErWwjdvDcfdjt+0zI5DYegGJB9Aes3rNcCmpqxp6hUN2P8z/9YQOVs60/3+jaqOrDfzV+Fit2meb9/rMDrUPhtLb+Zzka8zckmRP2sqAvGV7
 0Wd/S/sO
 111wSVk2zpbZhcDOMSzoN5uhIYr+GV+X/r7BgUOyISIEIHo7+iS20WfmHdKhzjRostAXvVUkw7m/dZiKVCm56e4h4vuMhndnR49udue1sngLUEh1tXG5Rtv4cCMJVKur8r9KEJBshnWfHSo+tKFMYO88cVBJwPmRMpz2nPsBjGWiFBnnkvsE/wAK+BwLYr51wssTn2EzGVZEjIALOpLLiI8czeHIzPiv8mMNVD2u3lp+CPhJhJhT9pzmuvSGX8H/++Rl3iPjajaiL98flYL6JIK7/Q9NeQ/5I0UBH8nOQsYI87hEjYDj/lw2nnu7K1VvVm78LRmLYlD9RsQ9NzOcv2N646BnMhf4XPa9FO/xoRpXiaRuJ03TUTXCT+Xmq9V7Wa6suB9BDH8gGGaBQg8yrm+XKJEvMaYdUJszPfAJoHsh1c91l8Jis4Qu1gjIlt4nHN+iULLLg9xy32vOXwJD9cGjhet5KfKKrSN/A3dHT9Be17JeiZUVCOwmtvnUh6BuR8LGDzedm1bJbhbtXneg8i62gIVlDQ505f1n+IdcyEYWUY9UNv5l40pkw9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>> Why is a tlb_remove_table_sync_one() needed in huge_pmd_unshare()?
>>>
>>> Because nothing else on that path is guaranteed to send any IPIs
>>> before the page table becomes reusable in another process.
>>
>> I feel that David's suggestion of just disallowing the use of shared page
>> tables like this (I mean really does it actually come up that much?) is the
>> right one then.
> 
> Yeah, I also like that suggestion.

I started hacking on this (only found a bit of time this week), and in 
essence, we'll be using the mmu_gather when unsharing to collect the 
pages and handle the TLB flushing etc.

(TLB flushing in that hugetlb area is a mess)

It almost looks like a cleanup.

Having that said, it will take a bit longer to finish it and, of course, 
I first have to test it then to see if it even works.

But it looks doable. :)

-- 
Cheers

David / dhildenb


