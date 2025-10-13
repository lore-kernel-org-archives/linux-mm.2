Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1B9CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33CC78E0048; Mon, 13 Oct 2025 09:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314BC8E000F; Mon, 13 Oct 2025 09:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2030D8E0048; Mon, 13 Oct 2025 09:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6CA8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:11:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B948858DED
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:11:32 +0000 (UTC)
X-FDA: 83993127624.14.C6B357A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3AD9880018
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:11:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y5TltcKy;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760361090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBdgSo6WOTx4EEG5eBWjfkr5h883eL8iwmBSlBrlRfI=;
	b=atLPWSSABGu2oUbGLi8gm7xU+Wm5BtQ5P6VczP8BxgcbcYGnqoE+0j/HY5TDUISvZsHaAW
	eosw/ZuGjIicN2DLx1HrnCZ9JvrMFoxOT4Cs3kmVDqOwVBqfw84s+WJPKxVK3KQ1dSdUtY
	ui9T0COE3rSp2cUunYIYw2I/fcI2UlU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760361090; a=rsa-sha256;
	cv=none;
	b=0ppNDa/TmvWXCvjCRg3X3slPuo/UDttNpX2NBEbYaescC5WMX8+Otv6Tp1G7IPcoTfeU9L
	pe65yHVRV6hqqEIpAPc8Q1/x/rJXsJOeTI33YOih9vX6aTxpqQTML0JuCvyYdLxox1c9ZC
	Yt9GIKlQlqy23xd6T2Svl8tZfrjqtKE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y5TltcKy;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760361089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RBdgSo6WOTx4EEG5eBWjfkr5h883eL8iwmBSlBrlRfI=;
	b=Y5TltcKyMPY49cwZ/G2nTl7Gn6oZRtBJG15Aw2+m/BepMiGy6lc5IgPiO+foMT8WaRey6F
	D6CiMYYMtaoZxxp6Omo0+lhy/ofXiJpi9d9CGKmxY1DzFMgl4uZDctsBryuhnuSTQ6FDsv
	ozRrG3tWbOPsiUcCNft4QbaG/pE9Fmo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-MFMPn_j-N_2ZQayHO4r0eA-1; Mon, 13 Oct 2025 09:11:25 -0400
X-MC-Unique: MFMPn_j-N_2ZQayHO4r0eA-1
X-Mimecast-MFC-AGG-ID: MFMPn_j-N_2ZQayHO4r0eA_1760361084
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3efa77de998so4342340f8f.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:11:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760361084; x=1760965884;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RBdgSo6WOTx4EEG5eBWjfkr5h883eL8iwmBSlBrlRfI=;
        b=SQebkrh63HY/Wp8UuFpnzKKAL5gRKZ8q8v34lLB3FgBj659L+hFX7++qPbscUKbeDr
         yblTmEMjfVX2cTzRHMWCp/50iOI63GeAY15YSflph644RrFhmdM+enpMl25cM62mn2S4
         H1ynXk5e9U0p7zT2WmR8JJImgM476nGEIMgEsgTPcK80sehOcv6Xv5hxFOsKhaInL/LM
         Q5T2vFPyl3JhriN+wNiwM5muWbXD5HbNnWOOw3lr3JAzOcfHu5bxC9aC7ptTEZeza9J6
         7nmCLqds1Q0AeruOz5mv3GmzKIZO+L1Jo7UepFvN3lGJ8BJ1Kjb1dF6BsXb+K0BhE4OF
         vIoA==
X-Forwarded-Encrypted: i=1; AJvYcCWciIrbW3USATuNDHZxd+aOnpnreBWyFCOtrgjdkXZ3aWpqSO4aTxYS7QhXV+rnAakG7BrNB1ktyQ==@kvack.org
X-Gm-Message-State: AOJu0YzlpjR2r6ryVsWoqCy09UtrNS6NvvEiAzCoASGko5yW/34qAH0r
	ZM9M0wBwvJ5C8ztAnTlmjc2qyRbXmKYOTVNHiPpYxnPkcZZtCKiGrHYAcQRD2qdFUonjIxycTVx
	6q0ddXzDsqaKzj++L1PHa8+JCkfsoL2bYOIcbZt22w3x3QK2PV4qa
X-Gm-Gg: ASbGncuCMmyZcCq1oXcvhxRaqUbaB5DibF9PM9f/8S/CQYYGcbiv5Pin8MGI/m2jYz8
	KevVEwYSZHVH5UYC9b11Dsd7/3nkLFKC6DrzpY0WpvjxoXXgpiZpbOblwRNy1rFJdkfQPhmyO4u
	55YNF+kdKnAvqP05XrqJleWxSkPR3Xjo356nJzEGP+DDiAqmfuK6QmeTpOT7+6+p1VHFBvAgr6W
	QXF3LwkGqvxMCnQV+JYbq1J9hAQg9qteKtO3b4Ono40W2IoiQMxuRu2qQeGYkgukqWAg/XNFKet
	KuYv/28CYLGH9s/f1tiMBxCWp+/ZLe8bUsX6gFtplHtWeBZjeqKfS6r9R92IW/YrYxjyogN9S7v
	GziA=
X-Received: by 2002:a05:6000:4901:b0:426:d5bf:aa7 with SMTP id ffacd0b85a97d-426d5bf0c0bmr6413940f8f.63.1760361083923;
        Mon, 13 Oct 2025 06:11:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGb6YozfVgK5IEbuaYmcmf0o016i7X6GI+Ce3y52ZzyWmo1gIg1qS/dRVJW5aUVEBtNQl6juQ==
X-Received: by 2002:a05:6000:4901:b0:426:d5bf:aa7 with SMTP id ffacd0b85a97d-426d5bf0c0bmr6413914f8f.63.1760361083554;
        Mon, 13 Oct 2025 06:11:23 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb55ac08dsm178750975e9.13.2025.10.13.06.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 06:11:23 -0700 (PDT)
Message-ID: <8e9d92c8-b2f6-4178-8a76-a6db935589ca@redhat.com>
Date: Mon, 13 Oct 2025 15:11:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Ye Liu <liuye@kylinos.cn>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
 <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
 <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
 <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
 <fa2d7db5-688c-4d04-abcd-a60f79a6bb7a@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <fa2d7db5-688c-4d04-abcd-a60f79a6bb7a@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: spMotQjT_CALiVna3LaNsz3rP8pysZ8FNKfT415yC7I_1760361084
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: tbbk67w5mtg6ah8xo9uuitpmecqk4qzb
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AD9880018
X-HE-Tag: 1760361090-818447
X-HE-Meta: U2FsdGVkX19h9nhzSbNurALn9KF1i6Vkw7r+3E1fDXk2SaEmSZdOgCKzTQyn7fPy3biKbv12HA2y7icGpnRDoMTdqyP61Qu9bga0gAISgjMcY/Vt10jqGHKzNNfdqU0hlorKGnEeF9NNbdoEteHQTtgbEXAP1FZQIbzvzgxg8CZdq16rkNk7ntBARCczekJHlt0vsfOsPWk9cQKlLbBX1F9l1aOEy4QqNn24ub19nf55sqJR91e5l8y1uoGqM4DyV7YBVpaug2aaV0HxetUjLUat+hddNbM77J2jhmgMfP38txa4TPUyIMeBB7qtKC8XJaWXK9Vb8h8NWb9OMbsEcn0XWQ1+thbdEi3QhXC6kX+wWcq2UoOYcDCmYafz6u/2FFInaj2VKOLqONGO5QIC8+RgULxNyVaxASZiwdCJ2JhzLgFDZkFEznTTO2o/p/wal0dQuvLqYf8serQCily4/auWhctG17i92c2jU/i4M6DxmuCN3N4f6S3F6npu+4trDgKv2bZOSOEEY+fsalhzvfP/8Lp0zVoDeDoEW2n10pI/E7TV8s1OE8xsKMaXAfFuc4TaDlVblphhsgbCu8KDpSW1JZOr/PtY2ztHe2A90RKTAFjHIryG1cQWlNUUriosFUjVavIvi1CrAJwoqQnibpETMeVHWuOXpWY48Y0mijepNjm642g+B+nEUpFyIw0gy8Z6voERPcHgKke5MlvTWXgkZMSFTnrdq6S0Qe3NbtKGd2relZVjT25KX1d3o6G6bI4bZwozJjhROwd6/zasAAtVrhhm1HU4fXU78TMC18/nE2leO4a36wEVDSQV5sxJGjpflXmkwKVC8euDMdLjLUFS1vcbRpxYgyZkLXknUq3wTJcbaG82F/qET1XBPBU6GCskNxb1iLPDAYfbsRSu9OLHxvN1QHmizsqv1GcfV8jknlgM6DfyQvnq5B/6cakKvqKfF9RiLF7Ap/6Sedk
 l8qc4qMn
 bxEMDHcYmv9pWB1dELrRnQH7JMKf1L32TwmxQQSoPfG4qu756J16ibtSMAT06bkuTG6ZmF40IohPHYwYrcQYJXYoLPIzevHoFSnOKpw+apJWXWKLNidudyfmMw0B7E88HKgwyKsmmUvB/jJZM3qteNFC7KWU+m5parxWRoEcchcOorVkGYNFrDPFIL73P3xneuK8oHG0mCn/sdco0WEpPZxrIWp74ipJOCAwiWFUR5ktYQVpMpPpbVM1IAUD5jUxq+T6Bg3glwhxYMkDD/mi4T9oweDP3EDle15I28uDsIoXmtR3lEDTQDBxUFf9jGZrlKMoXfCl8vQ74EerXJJ9Nj20NFXH800GghccPBO8vavpem2FTkT5LmebMRKuCgU0aMifiSqEyR63tZkrIZbHgZs99Qf++Sx5ityhy/g/nLLs/iWvY2xxDfqTPhODNH8YnlcD5CiFNZzl362u8oI1XZzIWg5eAj8GFxIdr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 14:57, Lorenzo Stoakes wrote:
> On Mon, Oct 13, 2025 at 02:31:35PM +0200, David Hildenbrand wrote:
>> On 13.10.25 13:33, Lorenzo Stoakes wrote:
>>> On Mon, Oct 13, 2025 at 01:12:20PM +0200, David Hildenbrand wrote:
>>>> On 13.10.25 13:04, Lorenzo Stoakes wrote:
>>>>> On Sat, Oct 11, 2025 at 05:30:52PM +0800, Ye Liu wrote:
>>>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>>>
>>>>>> Hello MM maintainers and drgn community,
>>>>>>
>>>>>> This RFC proposes to convert VM_* flags from #define macros to enum
>>>>>> vm_flags. The motivation comes from recent drgn development where we
>>>>>> encountered difficulties in implementing VM flag parsing due to the
>>>>>> current macro-based approach.
>>>>>
>>>>> This isn't going to work sorry, it's not valid to have flag values as an enum
>>>>
>>>> I don't follow, can you elaborate? IIRC, the compiler will use an integer
>>>> type to back the enum that will fit all values.
>>>
>>> switch (flags) {
>>> 	case VAL1:
>>> 	case VAL2:
>>> 	etc.
>>> }
>>>
>>> Is broken (compiler will say you cover all cases when you don't...)
>>
>> I assume you mean theoretically, because there is no such code, right?
> 
> Right, it's a general point about why enum's are not such a great idea for this.
> 
>>
>>>
>>> An enum implies independent values that exhaustively describe all state, however
>>> these flag values are not that - they're intended to be bit fields.
>>>
>>
>> Observe how we use an enum for FOLL_* flags, vm_fault_reason, fault_flag and
>> probably other things.
> 
> FOLL_* flags are an anonymous enum, enum fault_flag is not used as a type
> anywhere, nor is vm_fault_reason. So those are both kinda weird as to why we
> even name the type (they're in effect anonymous).

Well, there are of course more, even in MM.

For these cases, we indeed don't declare a type, but I am not really
sure if it makes a big difference here today.

I agree that once the flags are actually an opaque object (what you are
planning on to work on), it will be a different story.

> 
> But also 'we do X in the kernel' doesn't mean doing X is right :)

Right, but it in general works. It's just nasty here in particular.

-- 
Cheers

David / dhildenb


