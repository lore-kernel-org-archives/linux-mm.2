Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206A1CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9D38E0023; Wed, 22 Oct 2025 21:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A548E001D; Wed, 22 Oct 2025 21:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680508E0023; Wed, 22 Oct 2025 21:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 548A28E001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:49:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2130B12978E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:49:00 +0000 (UTC)
X-FDA: 84027695640.14.D3A608B
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 02448C0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:48:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BEGHT3sl;
	spf=pass (imf28.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761184138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bZE4UA1L0yD1IVoPp18bgdwWZBwc3tJKIS5Era+DNY=;
	b=wNP/SVvA2XqycybCxEda4RdFuBqTGkETWZyKFdAG1HFWtuOleu6wRmpeBYbIJE09B2NGRk
	ukB6EhXHQhGA98fSF4L8eH4G+zylq61j+TMi04v/hpLHpVJqARA65moyZGs67gIeFpdTxP
	eeUPnCBP9sFmty2HXE+KV2inMhla8Uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761184138; a=rsa-sha256;
	cv=none;
	b=gEnsoNrt2+T+gCe942UD+mgRK2+af6Fqc2geII2pvXqXLo477FNfrPdlk65BVDooIf9usu
	W9JmJ9N7GbuGcaZQoOH0TNRbqKhALOXpZmpAbANyrdYcQJH3yK4GP4+sEzUCiUboDdZBgp
	hDgAqGbiPn3DaC4F0E+RO+uW6jJTMAU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BEGHT3sl;
	spf=pass (imf28.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b6a225b7e9eso169806a12.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761184137; x=1761788937; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3bZE4UA1L0yD1IVoPp18bgdwWZBwc3tJKIS5Era+DNY=;
        b=BEGHT3slpDI0wXhnhxETFHOnxQ5iK46HL5sj7tmyc3elnFrwZIxoVlk+DwaSdsL2iv
         471GFRudtUoiZGsI+/C1QHUXt4rLSzrYsUs+UWJr0X4XB3bPpbpeU2qGgYeLdNqDEiEw
         INBhlfw48ZZePXlc4+SAMjB+rDQoaZJ6zxKeWQroWFBVq9FjP+poQgroASXhuW0RZmWU
         KZZ8GYe6gWOyefr+vF19wtfAVN9DwEWPR/a/5C15INWXlyqrn8kwDH0+k2rdKIGVfxXT
         19qXfzsPWUyL5wMaDZefBVfJ8lIIyt9UE1e7FsGDX7zhu1zYb4D5SXJvTq4FKU+Z7yYE
         ++ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761184137; x=1761788937;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3bZE4UA1L0yD1IVoPp18bgdwWZBwc3tJKIS5Era+DNY=;
        b=pZdvmAGT+2WzBh482RI9c6HTQR0j5hyNZSb3NhWSMUwzVfNM12q2Xi2yL3eWWk1K3t
         VyZKUr1qnmEc04bj/W2X3skYtkTk/betfTEiiDt8kOhPF2OlabDqfboXBPK/nheV3aeV
         EYwVIuwQgVH/4/77urYprWrE+4YEcIqcsTC/vFhhvB37IB1d1opuJQMmIdiFIfYFRbSM
         QRTXcIBvp8uiU1noReOe7+gk2pyVzGl8kdAQ9g0bIrBooArwzb5VZCNgLWZm2fvxP18U
         Bv7WkVWI7RjkTK3mg4xgWgbkz6OKVOrfJ9AaeozOcvlKI8gTXJ1XliC9hzmo5K/4r9RN
         1isw==
X-Forwarded-Encrypted: i=1; AJvYcCWIyCCxgYQoeTAKOlr0j45fsHT4s2ATOMdeqx3dr/4OOmGintGlGxoyy+FeVMhlkam44xdnoJQJOA==@kvack.org
X-Gm-Message-State: AOJu0YzcRVvOerbHcQAFW4LRhUm6SS0pQGVwqTBn8frVvwJ4poBbATHG
	6XlZlMgln3+VvfA7J8EdclNyBPB6QJHrXfNjpySOTgxuJBnepr4TVqAS
X-Gm-Gg: ASbGncunCkJ7m99lyPpCVuDfC+0mpcVdAqz/Vil/+MldxsGscO26fNHB5WpCNSEfHyX
	zdR1BUpG3x68ZtwaZ1Vx8tmhL6D8zWdFymEglcQm4GXqb4L/vcHpdVWU4xRloXh8Hfg5tdT4QQg
	zWAVc1w8dqqZaLCFFdB8Mfi0T/Vn4jxKdfqEeqCigvTQqfk5/uSgxNsKv2TkExtzFXS7K/JDrPY
	YsBww4fDxHostBri4xFXuCmJ1DrkucPrK+5C9k1cw5xpUsbtNpIczL316680rcJE+Pe7VMKqp/t
	QBiC2w0A5EXz5AlycCrzK0MjBXxfPRmwWnDBf2pC4FSQGmpc8ugR16ayGBH89flysdTn8ffgNoH
	3Qly6EGAKJUl8vJ/+JHBKj9M00RKcpgW6LTuhkZFsc+fHi6fX5SrvkTFWUw84SYFBdU4D16ARhW
	aKOGTD0JXmG54A6Y17juSETRvbDUdZCXLGD2qttbeSiCbnuCbIrVjDqXJEVwhaV9w=
X-Google-Smtp-Source: AGHT+IEKcWqMd+Ibu+5o3ItMIQKDF2MZdBQkD0wrpJAHT7sKfd2+s1DFgDv6i1HEiqvV30MRG2j1Hw==
X-Received: by 2002:a17:902:f605:b0:26e:62c9:1cc4 with SMTP id d9443c01a7336-290c9c89da2mr253507475ad.4.1761184136681;
        Wed, 22 Oct 2025 18:48:56 -0700 (PDT)
Received: from ?IPV6:2804:14c:5fc8:8033:f287:781:fdff:28fd? ([2804:14c:5fc8:8033:f287:781:fdff:28fd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e0f419csm5126715ad.89.2025.10.22.18.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 18:48:56 -0700 (PDT)
Message-ID: <07cd9c09-2a4f-48d5-845f-0c958b7b45d0@gmail.com>
Date: Wed, 22 Oct 2025 22:48:52 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 craftfever <craftfever@airmail.cc>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251022153059.22763-1-pedrodemargomes@gmail.com>
 <20251022133118.f13f924348e8cdc6d49ef268@linux-foundation.org>
 <f42b7b67-7de4-4a7b-8074-25ca87a952a6@redhat.com>
Content-Language: en-US
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
In-Reply-To: <f42b7b67-7de4-4a7b-8074-25ca87a952a6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 85b9abxzsxtkmifho1189hazh89o59ia
X-Rspam-User: 
X-Rspamd-Queue-Id: 02448C0005
X-HE-Tag: 1761184137-479430
X-HE-Meta: U2FsdGVkX1/PO09C/ToDFv6ayDH9bDbC9PGoSQA7W8+cO8qLSqdoNMkssqoWNlZ7I+ubdFEEUG68xTlpFLDNjT4caF2AdCB7VRZC5lnEU0MaQhBHc6wZ0wZUirL6DHAoi2QrCA854OW36nDS5kN60KtygK6nM5IUbYg5I6Q7osCjiC14nNQCjrslm50DUNgonseGlowuVg6+gxzY2s/+7AVHnYLOMSsqKkH3YBfaREcryd1BszRo+1krrzH2gdefBZszJqR+cbpDCpS6FTV1vHp+FozsuDOAILWOPS5WR5EIGGyqsfXrysD+I0Hfeasx/8lz6Nr3lxU60pu/lOnjRNRQk1QiU3K9WuLgHq6d+5qW3QSO8gKlzZ1j7hy5Np6T7I1CPm+LmQemrGXhg/Con//dUuVfr0y9ECN3qBPwv5LswmpGvSUN5UpN/BPl4uTf9nOfGVRTu5UbTsMAjwXKvJBnoOn+HoFhWiW3TDFEciWDWel7g2CzgIw8HUc5n/WssKxynYz0q27lMiSMVz4/CRQ/c/gFTyH+OzgvOehESG3ZNmDGCYsaULGrJpB/P1mBhmikOOB3XKzoq92InxOKBTSE9ePAqYBdYcqjR/rZe8mtKDhK8MM3t/SACACDpkFmNj4jzTdlTIoiMUhQ9oEj6umRpXOUzLpY1ZbyV8yvQZ+BlNPjd5cVDSIhAXBpNYYEZ8P3CwhxBCM78V79zda3HdxnbARm4d4DGCUomimcG+1d2nzvUcOQg/KAnufh70f1kY5RviUllOcTQpxQJvJ4Ags9KA8Skd88BdXbuJl4YGkzBqvpfdGrQVfbPhgVxxzLNgjDm98aQHlPsQU4nFoAVo9ruoe43TvXCZJhWHaomWjstGgv0nQeK2khN95djSbdBTV3ciuJgUWl9T3jISJ3M1YqlnlsbBzzOo/jrZz4u18Y8T9jF1FRGqLM757YbV/DqC9q9O6XXEgi2tm9hyM
 28lttuTJ
 F8OPbk2Y5D7DbEmSlbOe6eb3k0lvCMqcpg4Ft5PY1ZUcWZFM0AVgYDNKzw2UrbiUAP9ZqchuS/G4pbJUF/pnjua01HlkLlNxOOgfhImIG9TiJDmJ+titj7kR+5x7QZrYR0CXA0QVh0bTvRZKIMxmUjj2ylqpijZrvWasC/d/3+i+G5Y5dkAGB/9GAogF+UpKMxEjnX9TW/E745q1i7gVnQE2IF7QsK3zmTgxgl2SJ1uOvIXP/uPENtlfsqwlnGib9bZ5ahlGSGsG5xy+x4Pj0QqaPdz7xS7a82yToodGs9nQQr3HTJh/bYPKpc7Eeh26PWewMhCLr8T9TN34tNcUfRF+1Fk0gs9FmIqHI8QmOqJ2m98WlGAiv7x/o/HFIBNKSk1ce1j/iJtNI4HtaIre0/qYpgQQ9Ux0UuPB30cTdJzgSBb08cvQ+okAImFPtIgXJFx/WTPIR5SWzWaJX+rB0/I3s/MnypkYsp94klmMAc6DB8nEhEv08NE4AM7Qus6gRoca2IIGukhb0weGtItdjj3x0Yl7lYZtl8w4DprhjdU2bLJw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/22/25 17:52, David Hildenbrand wrote:

> On 22.10.25 22:31, Andrew Morton wrote:
>> On Wed, 22 Oct 2025 12:30:59 -0300 Pedro Demarchi Gomes <pedrodemargomes@gmail.com> wrote:
>>
>>> Currently, scan_get_next_rmap_item() walks every page address in a VMA
>>> to locate mergeable pages. This becomes highly inefficient when scanning
>>> large virtual memory areas that contain mostly unmapped regions.
>>>
>>> This patch replaces the per-address lookup with a range walk using
>>> walk_page_range(). The range walker allows KSM to skip over entire
>>> unmapped holes in a VMA, avoiding unnecessary lookups.
>>> This problem was previously discussed in [1].
>>>
>>> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
>>>
>>
>> Thanks.  It would be helpful of the changelog were to tell people how
>> significant this change is for our users.
>>
>>> Reported-by: craftfever <craftfever@airmail.cc>
>>> Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
>>
>> Buried in here is a claim that large amount of CPU are being used, but
>> nothing quantitative.
>>
>> So is there something we can tell people who are looking at this patch
>> in Feb 2026 and wondering "hm, should I add that to our kernel"?
>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Co-developed-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Fixes: 31dbd01f3143 ("ksm: Kernel SamePage Merging")
>>
>> If the observed runtime problem is bad enough then a cc:stable might be
>> justified.  But a description of that observed runtime behavior would
>> be needed for that, please.
>
> Agreed.
>
> With the following simple program
>
> #include <unistd.h>
> #include <stdio.h>
> #include <sys/mman.h>
>
> /* 32 TiB */
> const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;
>
> int main() {
>         char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
>                           MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);
>
>         if (area == MAP_FAILED) {
>                 perror("mmap() failed\n");
>                 return -1;
>         }
>
>         /* Populate a single page such that we get an anon_vma. */
>         *area = 0;
>
>         /* Enable KSM. */
>         madvise(area, size, MADV_MERGEABLE);
>         pause();
>         return 0;
> }
>
> $ ./ksm-sparse  &
> $ echo 1 > /sys/kernel/mm/ksm/run
>
> ksmd goes to 100% for quite a long time.
>
> Now imagine if a cloud user spins up a couple of these programs.
>
> KSM in the system is essentially deadlocked not able to deduplicate
> anything of value.
>
> @Pedro, can you incorporate all that in the patch description? 

Ok, I will send a v5 with a better changelog and patch description.
Thanks!

