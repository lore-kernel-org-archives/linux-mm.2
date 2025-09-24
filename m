Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D47CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7588E000C; Wed, 24 Sep 2025 13:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF4C8E0001; Wed, 24 Sep 2025 13:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BDDA8E000C; Wed, 24 Sep 2025 13:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86B078E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:06:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F5685BA50
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:06:02 +0000 (UTC)
X-FDA: 83924771364.22.B9F6889
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C7601160009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:05:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kuh2v4Fa;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758733559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDng6eTC/50ODCGQBWOqYwAMIQif6a+HS5dFEqQoJ4Q=;
	b=5dUSK35K3RoEBqghLYAmgDEjlpbjpqR8KAY2MdIuRifGshHSV7nLWoR9Q9Tj0juBM8TQfn
	MWOIgZ+DS5IH4kp1g6eDfC4KCXBQvkK+VQWxOt3kW347zw2WB+UFGgpqq4PCHOcrOvkIeE
	QXO4DW0EBN/naE7gSQ9rN778d7mnbj8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kuh2v4Fa;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758733559; a=rsa-sha256;
	cv=none;
	b=sbtlSyA0PAN4yE06EBSSDOrqKPJCJ2jo3p+YAXteR4ooixXodTiHlN0wstB20LO3PypOBh
	+MacpKPuoir2JK8AnkstLBkhMJSR1bxtZC5z9/BLbWg3qpaiPsoOBoVAfPrCYNosBtShDu
	S4pww2twg06DA9jK/VnaIELCra1CAkU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758733559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gDng6eTC/50ODCGQBWOqYwAMIQif6a+HS5dFEqQoJ4Q=;
	b=Kuh2v4Fadov0VnVjY6GpOcCNovcut3oygAOBr4l1WEPEY3hQkgXqsbiBxg00X/FNEuzW3p
	KOPAPixe/fnZKZLbIjAQtllsBChFkmFtndehF8GTzNm+NCTsNn70/GtnHb5itW5H5Flk2p
	igZTkMJ/i2Y+9JOCLuo2jQ6LwGjjoBo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-gp1D49beORm9XDkOSfhmRw-1; Wed, 24 Sep 2025 13:05:57 -0400
X-MC-Unique: gp1D49beORm9XDkOSfhmRw-1
X-Mimecast-MFC-AGG-ID: gp1D49beORm9XDkOSfhmRw_1758733557
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb604427fso152515e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758733556; x=1759338356;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gDng6eTC/50ODCGQBWOqYwAMIQif6a+HS5dFEqQoJ4Q=;
        b=SIBNALc0Q61KWJis9pd3h/5Uvuigu9tTUG3GFyolK6PWz6D5e+8xZI38ynEouJDfxf
         pq3fgzwJtvw7GM65B3MGsGtXq9QeBBCtPkpMGTNlvmwzlYAuaGYx5exhizHTtmwoGJGC
         9n1cK93fCvr8hZfZsVy10yYdDoxsRY3HxwPjyDZV30cf/WzNNkmNkHpbwn2llO8rXsT8
         FUMdo44asmsGIChv3eAZwGuUSO9GxumFBzn4Zx8JYCO/ZMbxioQ5lUB65Sj4S1A1faX1
         e7ojvlqff+FCCGRDs97V94v4mwkJ/l9fnJbPPjM6uVimNH0snk/DIWcvDFbo5G3aCU6N
         3qLA==
X-Forwarded-Encrypted: i=1; AJvYcCXZGQ4rtxSiXx/lPOa5Sd9H1VgNGTG+BcrCr3s+23pn7tP3dJkC/kGSM7Gw910FJWEKwDUEeADaaA==@kvack.org
X-Gm-Message-State: AOJu0Yy8Z7ZPdr30Yo99Xg/wIPF6p8aGlDvVFtJq0kzrcTewek/KWWNh
	KW/ecrGEn+4EOMSpp7EuGt4Cr4elOegJTYLSv7y7CjxMP1HcotHHWoZCqFImgK/DwnsweZJdgW5
	GQ9oyjmNXTBkpP2mJiHpbQhqMY/OwO5j92Oh66k2/IGgHTJ1UFdI2
X-Gm-Gg: ASbGncs0tkkkwI+8TWMDZDUiz0dBMDgCl5SoyQ+Je3fUi9bWSpigRLorDTk68ouA5/h
	rSC+nsaWuD4M09w/bF7NlV42DBjhqIM5QUkB/RSN2RT6bHvzD78ZfGWjvYi+PA6GMI0raXHnJ6u
	gYmRGvyCc6+s3TDtKdYFbLuRYL6nMPekYwZPsadIES0QOdo6DSrS5GNDbR8/7K2/AASS77rh1d3
	aLICS3gM3mR5X9slO3GysnPQDahEw0iftFNJ5sSYi8cmUdwc1wnRfVNtYVyTcALCnq0dBShVGzg
	YBjAv1HAgqhUeT4FCKfRsSirPbfe4GmF72wvh4IxiVyy/nELarret5FqlnW1rxtCbRkBFVEsVW+
	m/1hJfLPWt8fa5xtD3DXUfQE492j6c8N+CXxkw6inVNRHFN2EnJX9U9dPiaUcz37n0A==
X-Received: by 2002:a05:600c:a01:b0:45b:7ce0:fb98 with SMTP id 5b1f17b1804b1-46e3299ed75mr7553955e9.5.1758733556571;
        Wed, 24 Sep 2025 10:05:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQQ/c5CHHYeXnXbXM85BLoItT272YRWfgKDNPvYG9xrftCMnPW5ERT86Mv9UcXuEUMFv/tEw==
X-Received: by 2002:a05:600c:a01:b0:45b:7ce0:fb98 with SMTP id 5b1f17b1804b1-46e3299ed75mr7553545e9.5.1758733556170;
        Wed, 24 Sep 2025 10:05:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32c10823sm1255775e9.3.2025.09.24.10.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 10:05:55 -0700 (PDT)
Message-ID: <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
Date: Wed, 24 Sep 2025 19:05:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Zi Yan <ziy@nvidia.com>, Luis Chamberlain <mcgrof@kernel.org>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, linmiaohe@huawei.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 syzkaller-bugs@googlegroups.com
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9wEJzVMw1Ra4TSSV4iMfm0Ms0M5K9DUOxRv3EtchVGA_1758733557
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C7601160009
X-Stat-Signature: y7fzzrkog5yif1o7bxrqt9ea3ftmybin
X-HE-Tag: 1758733559-354836
X-HE-Meta: U2FsdGVkX19xyMNTG0W1RG/HxFFwA1kI38uuDiHXVJ/rrAoipwTX/mtx0HaCywXbG94hpT71zsPAeaZFziSiAljY6EAJFUw9I0uyH+GYdsWgg2gZGwYkeVvb6hgHotqKhF/r1myQCugmIusAryFS/Ny/ZV56bAjDi3VbFh9jnX1dDVDc+FyrO7onhhGSxLS+gWckq7niARLpdWQDx4qNAyTwTDGQaYXphGBL9Zco6Z7RVt2YkWqrLMIo8jXzqIDY0eDgtS+/3eoAUdV6ceYDqbpS8KcuYbUn30znXRnTp41OqtrqwZIX2qP+VgujytYEpzDdlwhwV7Px8Mlh15K4R3624vPjO4y0rtoOwGxGqq8HW0jLit3uKezqfP2I9NN4WQIFSPby9hA3pg8Dkw6+36cyu+1pyhCEd7DZLiJRsXA3H9wLPB1HKzbI7r/VaNA8bXB7rU5N0SJInxZg48p+jeBLLPq6fF4rUdYGpQF1GQVe1CnewKzTXQHz16/h16WQm5GeR/SHl/6+lEtjdVjt3r6s7b0+1fRdR7QmR9tkuh1DPfYrNYqfKb6UDCQD1ltyCHAoDZKPAPym3VWfpRZCblXyyPl1IEMkTQ/GSKzx6/J9BKX+SDmLmlfcYLm1BWrSPnZthHbfgCK6JRRnrSTtrgCAXlKHFAhiuvKstvGEJjT75YTk/B4kEWbUkvonV+lRe7OBQEUrIXNgE8l/1FEZTjRBhvvMjwYp5kGfgaV/XvKmcUukRFzKLCrbhiwnPwGwgc4upvxroMNVpP/PAYkOaANJuhUKFTWKY03o7SsqXy+FfM1k+UyGpSx/oeLqq9liEnxGzZeZvF//utQVPnXVSpBmE/1vnAT5r+Nih/ZkvvakI9HFgM+R2SDGvHT+EsYi8n/GvoINApEvdAgdKruYbfK8lKsdE7QEIn8PL/zFTN0XhlO6pV+hW/LQiAdPRBNMg3F4gvIwupgBpsxRqQD
 8vfLCEjm
 Grl3X6hM5zfm4mYdFvvKDHyAaHcvZwuh4DloUsnTk7BZZb4rwIF6EpGQcLVFa14IIIM7qJdDXCqL8gOsGEkGGW2f4YBSm6YvdwfRkVRXI6QyN9exwyDOSXy/4T4zrUGVwow38eA0c08FYVeg8tKVbQQZdh5jWwrpW3LMvhpZiHxXKmDTjtfM9p6RYgZx06SoOcKl+Rwrt+biiYyQY6hULTlW3QKgy6KijE8pKJ1JhMsx5XY9bKthM0T+tGZBmYSvNk/Y16tRp3KUCQr7zLtyY3FwbhODVw4N4o3CL0Hc/HfhV2xPBIi30lyfRPINuTGcoV2QeItFBi86JGulXYp7gZX39WUmhD33mgJtT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>>
>>> What I can think of is:
>>> 0. split code always does a split to allowed minimal order,
>>>      namely max(fs_min_order, order_from_caller);
>>
>> Wouldn't max mean "allowed maximum order" ?
>>
>> I guess what you mean is "split to this order or smaller" -- min?
> 
> But LBS imposes a fs_min_order that is not 0. When a caller asks
> to split to 0, folio split code needs to use fs_min_order instead of 0.
> Thus the max.

I'd say, the point is that if someone wants to split to 0 but that is 
impossible, then we should fail :)

> 
>>
>>> 1. if split order cannot reach to order_from_caller, it just return fails,
>>>      so most of the caller will know about it;
>>
>> Yes, I think this would be the case here: if we cannot split to order-0, we can just fail right away.
>>
>>> 2. for LBS code, when it sees a split failure, it should check the resulting
>>>      folio order against fs min_order. If the orders match, it regards it as
>>>      a success.
>>>
>>> At least, most of the code does not need to be LBS aware. WDYT?
>>
>> Is my understand correct that it's either that the caller wants to
>>
>> (a) Split to order-0 -- no larger folio afterwards.
>>
>> (b) Split to smallest order possible, which might be the mapping min order.
> 
> Right. IIRC, most of callers are (a), since folio split was originally
> called by code that cannot handle THPs (now large folios). For (b),
> I actually wonder if there exists such a caller.
> 
>> If so, we could keep the interface simpler than allowing to specify arbitrary orders as request.
> 
> We might just need (a), since there is no caller of (b) in kernel, except
> split_folio_to_order() is used for testing. There might be future uses
> when kernel wants to convert from THP to mTHP, but it seems that we are
> not there yet.
> 

Even better, then maybe selected interfaces could just fail if the 
min-order contradicts with the request to split to a non-larger 
(order-0) folio.

> 
> 
> +Luis and Pankaj for their opinions on how LBS is going to use split folio
> to any order.
> 
> Hi Luis and Pankaj,
> 
> It seems that bumping split folio order from 0 to mapping_min_folio_order()
> instead of simply failing the split folio call gives surprises to some
> callers and causes issues like the one reported by this email. I cannot think
> of any situation where failing a folio split does not work. If LBS code
> wants to split, it should supply mapping_min_folio_order(), right? Does
> such caller exist?
> 
> Thanks.
> 
> 
> Best Regards,
> Yan, Zi
> 


-- 
Cheers

David / dhildenb


