Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3A6C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA0C8E0050; Mon, 11 Aug 2025 09:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681CE8E0045; Mon, 11 Aug 2025 09:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571B08E0050; Mon, 11 Aug 2025 09:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 447D88E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:03:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF0841A01AF
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:03:45 +0000 (UTC)
X-FDA: 83764493610.13.D35EED0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 63CA740005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:03:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h0S+5SxM;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754917423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0BtLxYidZI73LQEwOGP96I9gxCnmhJ4MxHYnaXFggA=;
	b=cSFFHOtjI+Q9FlVbYffGcpByS5VePL2RwSPMhno7zL+C/pdAKqMXcsQ6oMgNBDLBfqT+po
	S6u9OVRHlTBr4SEOoN2aOn2NLoUKU2RU0tN9wKWYIPWwgH80LaW5bp1+Di8IpLb0Z6rqxJ
	ZxpKjrv6pz6Ts+v62Eymh0jkofnGD+I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h0S+5SxM;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754917423; a=rsa-sha256;
	cv=none;
	b=2gCw0RBnMWLh2qxrgoh0gIZxKkVAHxdm+CpvY/FNM/03p/0E90TyJs9ZOXd7KZOzN1k21H
	Zu76ilF2P93zRnb6fFgDiLQlv0YF5E6ubkA41cJnLvymUdNXLYjgMqoXVaA9E8Dyvr/rXq
	DX3PX1UIUo038hIF36TBQIE8hghPuAw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754917422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l0BtLxYidZI73LQEwOGP96I9gxCnmhJ4MxHYnaXFggA=;
	b=h0S+5SxMcKloA6D87PY0YC8cKjxKQNnDkGqWMCmi4LLWwij7JTHLqrAT/xKwmHlGx0VeFh
	sBlN0kG/A29DiOg7CiLm2J08wg0u3Mhf5qGNv7QLQG16qWJQzd6DG/foSF0jnDb0Kr77fe
	q0Be5imIFaDFehWZ5lkVkngf9KBD+no=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-X_cs-xwfMsum91ElKQ7bMg-1; Mon, 11 Aug 2025 09:03:41 -0400
X-MC-Unique: X_cs-xwfMsum91ElKQ7bMg-1
X-Mimecast-MFC-AGG-ID: X_cs-xwfMsum91ElKQ7bMg_1754917419
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d8020b7bso22037675e9.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754917419; x=1755522219;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l0BtLxYidZI73LQEwOGP96I9gxCnmhJ4MxHYnaXFggA=;
        b=MC7/9TQTkum5UFRnc7RYdKVP7JFNCw2zam92SxQc2UQY688MWtM6v0cxpB9jzamiiu
         eBykZdR3Gzm85fv3CPDuG5aVT0ruxnAUUD4T0hLIwQw1ssWw95Mb2GobWHJmQy6/6Sf7
         4HNgD9kQWsjKXCPXBjJQwCFopM/N/UiXPivdBAbYnIDl1Hlu48ZkGf64CifpCEXmUOmr
         SThM7/ocrqkIZKifMhJ838+ZpUqg36LEOpADmCLUTyukPkrxpVmKsFxCtAogOhSc78/y
         EADVdER02el1tGPGNHYOLZwRl6mvrXaHsOh4BNz99gEHrFrX+D5RDWzyMKfYjtLXJrk+
         Qu0A==
X-Forwarded-Encrypted: i=1; AJvYcCVEQYa4qnoJ7z3qUd0ENzqyp2WznJ5cnZOjTBqnj6nbp0F2SJdUq3qTzAobjKOZ0IjO/yn9SnJSew==@kvack.org
X-Gm-Message-State: AOJu0Yw8ENEAas3j5qpUNZ9mOUZoQxVxyK2aOF5aBhhYfXghvlmPYPhU
	Hn0iGFOlG0qUXb7Y6oxbnqdHYlvKgohBgzwNSkN3EDls/LhFqU+7pZapLpTxKRFd5F17EoXnUPU
	T206ZYbzkQoCZ9V62VIxDqm5AXVGI1lHF+zhMbTlOCX1HNKTMAzzf
X-Gm-Gg: ASbGncuwFh1Ykv31yz/zZrYXUerCmhHfIuNCD49tPAvtHPzBTSDDwAIVisHkt4FAebE
	Sn1e9VfXDSRfBw3gAH6ISxZGNuXOA9I1uL9Ji0Hkqh7DbqF5DmBL5riRjesVxaWr1l2HmCDmDR5
	OEmUkPhH6EaDvYiOLgeTlI8DKKtN4Cqsii1XrtcRj8PGbBFnOiDTuZQOttQf/g0HOMyr9f366pZ
	WlMtRbyJAhbG5k0cEexzBocrYB1J4mqvhHMvr5sKMTYJmqvW9xlvMiEDStXAD0Z2D9tiXlG/RFj
	SZXDuLTeEhh0cHvsCYU1s4kWI8qlbuvxEMFdSEIVMyFYL68C/gcnOGnlv38QgwLCLgPwYFGZvTg
	JwsqRJKu6Bvv8tFEzTLJnl+g8zReqNuQ79wmQ1TVHrdCDnbZBMeCsR6VsDpX8YBO7ZZs=
X-Received: by 2002:a05:600c:310e:b0:458:6733:fb43 with SMTP id 5b1f17b1804b1-459f4f0f5c2mr117242565e9.19.1754917419076;
        Mon, 11 Aug 2025 06:03:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1mfWN2Xjl9R7zfCFKVnCaGu1ndRRL4tr/HVjclyc3vwPmExqtNC2qIKBRYzk0XdbpTd8QiQ==
X-Received: by 2002:a05:600c:310e:b0:458:6733:fb43 with SMTP id 5b1f17b1804b1-459f4f0f5c2mr117242125e9.19.1754917418610;
        Mon, 11 Aug 2025 06:03:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e0cd2c90sm302174235e9.17.2025.08.11.06.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 06:03:38 -0700 (PDT)
Message-ID: <9178bf98-2ea7-4ad8-ad43-cdcc02ab863d@redhat.com>
Date: Mon, 11 Aug 2025 15:03:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Charan Teja Kalla <quic_charante@quicinc.com>
Cc: akpm@linux-foundation.org, shikemeng@huaweicloud.com, kasong@tencent.com,
 nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
References: <20250808092156.1918973-1-quic_charante@quicinc.com>
 <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
 <f008107a-2741-476d-9e32-ae9fc0f81838@redhat.com>
 <29e080fd-5f9a-4760-876a-a6ccef33129f@quicinc.com>
 <fec5ad61-7caf-4076-ba81-7b454ec7018d@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <fec5ad61-7caf-4076-ba81-7b454ec7018d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IxdhMq9TAbD9WNURH9q4OglTd71N1ag0iSRlHJPhUX4_1754917419
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63CA740005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rwkxgdabd6wshjzzhtbkz6it6atc63pp
X-HE-Tag: 1754917423-101403
X-HE-Meta: U2FsdGVkX18wYM91B6jIsYjuSlxYnQlwRs2RB0eBqmN+WDXirWsRpf8BvRJ7cf0lWIYyxaUJ8aaX88PIWLUfhVWMaxoFZwoQFcn6SxYJ0naQ+N7pDbORuF4UTtP02MTPglGqPIMY6L8o15MoPnWEsKFnq9FCfF25gekiJmMntAS0Nt/+r380eUcnAQG6CDyNWmSpykegJYQhV/49WtziGu3El4mTg2fSYVZGojPrm0FywsxqKkXogtX29L4DBFxfbzz+BfETxRw+/MQUG7MdM95Kf7qA7pWkjYdK61DHQXwgfgBbaYm3oA9+Jz+Jo6/fSZBdoHDbUwIVx9y2UPuJHGtZUVhdupF569yunk0z5OwmLRhDmi87xiFvtPhDJnn+hkXdOIG+TjRQDCgBSTaVeIUruHGY1gN5qcCCfc3MhBUuSlalBfSxeQGD0R7ruHsWQbFCQ6lK+3g/627KG1yUUYAJ8yEwvGIxC2Bd/xqkWdtOm3V9YAaH/GrrR4Gz+OdL4PqKQuBI3U26shErNl9vaZMgoG6+GTywnVrSToNzf+FQTB261d3k8aAW4UQDrHG2EhpBbRGPAZ7UsKKo1RL6v0iMEB8XPFiyHLxu5LY2/Q9+iUVxPQa3arJsTOh6c5GE3uLprd/HmAxaTRbAWTib08oo6RGPTBUyhsouKyJUXZV2zOstK2qSqrh+QuyVk1X7o0s2/yI8Sn6DCYmDZUGZWt+G7MUdpEWpzzk/MdFRA6QD/30PRi/7lbiJ9voNgPI7gU5TagNI/b9y5LhBFIaVFyIJTDyTziEqJfS8SM5cWco9ZuFykPOQR6sLSmBz3cYRC0d2XCO/WiHwNT2JEuFDcNu2LEoSkSdXIxnEv4gIc3HL12Q2MKdksSSrufPp63JXqfq1znWzwcW8IlB42BJUiy5F7ZWYQQSVfUsO4YVQCUwzqFcQtlWlDuiO+c5turx41girrXpE2OYYLSzSz+j
 vWrM/yE1
 wQz88fmHt3coIgJUcax1T/cunGTTc91WxivnHEpFnW8dQn5V7I8vHy6BsGwdaPkzvnl5aDJhmriMcu2bzoBb99RRkWk7xL4p6K99u+wddkvhp23rDfqTrav6+CKt7hEP7ufQstShMtUhLDeCvzWRP24qs3zcZlwANjwjpv3coS9eaxI4DOyoA6ENS/ZqEhSZSAD1BULXYX37a480YqwTATwIXc9L+wjY7eDpxXXiCjDrFMRiousobw3CKyj1P3a227/dK72qO/8ZClMZIjXLxO48ZsGwSrlHUY7R/evanWOnk6XJM+GaUIT7DZdg71QFQzOH3L5VE/AWOHr4+hfi35CAh0kDq6nkLjbb6onuexVJxDfnDBiU3sHgIB9+IPWr+Dd9YRCeV2v9lyPe1yFuKSIMXXKp/jrE3uQTMDqnlNvft/++dVhJRYdMFSJhpdzHqeH/rDwbDXyfHF9fSPlDH97ZbiK7g2JNG8LJklPKZRf06SXusKfxH/nLFF/WsGc1ZMrMRWaAny/8qlBsFIqbUqY0+sFA0+751QoXy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 14:14, Lorenzo Stoakes wrote:
> On Mon, Aug 11, 2025 at 03:13:14PM +0530, Charan Teja Kalla wrote:
>> Thanks David, for the reply!!
>> On 8/8/2025 5:34 PM, David Hildenbrand wrote:
>>>>          if (mpnt) {
>>>>              mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
>>>>              mas_store(&vmi.mas, XA_ZERO_ENTRY);
>>>>              /* Avoid OOM iterating a broken tree */
>>>>              set_bit(MMF_OOM_SKIP, &mm->flags);
>>>>          }
>>>>          /*
>>>>           * The mm_struct is going to exit, but the locks will be dropped
>>>>           * first.  Set the mm_struct as unstable is advisable as it is
>>>>           * not fully initialised.
>>>>           */
>>>>          set_bit(MMF_UNSTABLE, &mm->flags);
>>>>      }
>>>>
>>>> Shouldn't we just remove anything from the tree here that was not copied
>>>> immediately?
>>>
>>> Another fix would be to just check MMF_UNSTABLE in unuse_mm(). But
>>> having these MMF_UNSTABLE checks all over the place feels a bit like
>>> whack-a-mole.
>>>
>> Seems MMF_UNSTABLE is the expectation per the commit,
>> 64c37e134b12("kernel: be more careful about dup_mmap() failures and
>> uprobe registering"). Excerpt(s) from the commit message:
> 
> This really is whack-a-mole yeah.
> 
>>
>> This patch sets the MMF_OOM_SKIP to avoid the iteration of the vmas on
>> the oom side (even though this is extremely unlikely to be selected as
>> an oom victim in the race window), and __sets MMF_UNSTABLE to avoid
>> other potential users from using a partially initialised mm_struct.
>>
> 
> But... maybe this is better for the _hotfix_ version as a nicer way of
> doing this.

I would prefer using MMF_UNSTABLE as a hotfix.

> 
>> When registering vmas for uprobe, skip the vmas in an mm that is marked
>> unstable.  Modifying a vma in an unstable mm may cause issues if the mm
>> isn't fully initialised.__
>>
>>> Is there anything preventing us from just leaving a proper tree that
>>> reflects reality in place before we drop the write lock?
>>
>> When you mean proper tree, is this about the your previous question? --
>> Shouldn't we just remove anything from the tree here that was not copied
>> immediately?
> 
> Commit d24062914837 (" fork: use __mt_dup() to duplicate maple tree in
> dup_mmap()") did this for efficiency, so it'd be a regression to do this.

We're talking about the case where fork *fails*. That cannot possibly be 
relevant for performance, can it? :)

-- 
Cheers,

David / dhildenb


