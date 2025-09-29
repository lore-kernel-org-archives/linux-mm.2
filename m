Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77109CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 16:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66B58E0016; Mon, 29 Sep 2025 12:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3DAC8E0002; Mon, 29 Sep 2025 12:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C9A8E0016; Mon, 29 Sep 2025 12:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2CDF8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:13:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79F5558EE5
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:13:58 +0000 (UTC)
X-FDA: 83942784156.06.DC2FDA9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 010001A0015
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:13:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dOFqC+nD;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759162436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMjKy42+gbCbyaTX2+DnN1ff8sLEDP8LC/4AUZpgyCM=;
	b=SCH2vAWvL4DLBQmiYik4nf2HsOh33T1pbY6SCzfVYpqu50DArFVjdW7lHotVW4nFL5CFyK
	vW2mR4IUgKAut6Gd6W2Q91voV1BtcEmJgCV7o2AT75McHrew1TLnytWxfM2OM1HdEpYzhr
	kvkvBJNEq64yhruqmsrpCYeY+Zuv108=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dOFqC+nD;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759162436; a=rsa-sha256;
	cv=none;
	b=r0bg7AKZbGBSunQaL7mXK/BDueu6wJWkBK/KfcwARryjo6LrDK04V1FYv2ZISe7bPF1d4M
	goBsIlh4H9HeivIVAq1wzkJuixqqA+uoMqk0VYljPvbFZTlxdBXgY0HfDQJUgaUGSTJwUs
	2Rszs/4sCpoDLgfNH4V94Aey7X/z5b8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759162435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CMjKy42+gbCbyaTX2+DnN1ff8sLEDP8LC/4AUZpgyCM=;
	b=dOFqC+nDYABPzHMXzkV6FgDKYDwLKgQhwXeVwuOP9u8kxir0e6B9OlPQNudMuzqfmL4Tw4
	pOAJhs+67zYkg0RlbT6hnvV8F4k/HqBHFlq4OASM0EAvMUSqEVyDjhgFT13ZIKSclFR5Lp
	K5j12Xx5zWaFFpQW0jZHKz2WJdPhdpc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-2-87p3kkMXy-3u-96KXM3Q-1; Mon, 29 Sep 2025 12:13:53 -0400
X-MC-Unique: 2-87p3kkMXy-3u-96KXM3Q-1
X-Mimecast-MFC-AGG-ID: 2-87p3kkMXy-3u-96KXM3Q_1759162432
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e31191379so31035855e9.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759162432; x=1759767232;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CMjKy42+gbCbyaTX2+DnN1ff8sLEDP8LC/4AUZpgyCM=;
        b=r+AACpB/5AXzHyIN1RT14jA/wtGi8TaNXJZY+M/Wxxnq3YToiGVTj4F9iO42ennI33
         4mPG9QR66femlywUN4KHTgusKp0gJsbz6VHz/xMQplM0elGRl8TgXqoWw3cjnW6MAoPM
         ZNBIO+k+qfPb/6GV0pQs25XGhJbvd6rKc9Uhm3f8ZltAJA+1LqMyxkdzKfJkxrG+pTRA
         xjHlR8XrPD9mg03y5fmewaZvCB+xVFLUOWcYh6CbFeevXLW7ZyuX47aXMvfPkiBLGkYy
         sa2tXURyxjm4aI/5b7GoDg2Q9cVtZWyrqD2XeceN4P33DcHV5Ey6bUdoCOGYLO7+/Ae7
         zMzA==
X-Forwarded-Encrypted: i=1; AJvYcCVZfdH3UMOaE5hog/7gUohoRMcw2cWIypmC/lC2R/x/9QWTWDQSQjBp42/TqywkRqVHIxAsnSUNIA==@kvack.org
X-Gm-Message-State: AOJu0YzWbf3JkHPxPleRjpuJZQ2Ep8MR0ox9Q1E7lD8gEO8/zmXA+7w+
	qvGs6VI/nhlGQEbG0EBfCy4c/OdMSb+xkIuy9t/Xq79bD17rpVPVo2STDk5KXwxcNIfAI6ReyKR
	WYM9pPDPpG+UDL3YPIXkQ2gN/dBz3anZTi2fUjVKb3M1G6EAEuYUi
X-Gm-Gg: ASbGnctyYxH+NhbJY9qk9dTjHw72v+IQFdfGYnXmnD+4QGrp5g5ETqRXmqhmGnujT7a
	xW6XvhKECOyFGzFn+ccFNqkQZA4hMAgycyuuyZtPptibXK/V1Hl0RmttnP68cnriTgXJM0pRfu0
	AUNbPqTmqgWkFrNxW7dchBBVPhcO6d/4b0loeE9D/SI3xRnDvgET79lZFmFCqN7ErToPM4rwAY8
	NoURMdgMS9VvisGUDX+0Eot/LGdRIznSw3c3n8VK7nSgKZTor8t/t8RaxJqKx+k7cclkFXOLptO
	K2IqEtArF3RyRN+FOkOaRGKkn0N2hd1EEPgDSkeSgJ4KVcUU/5p9De9gV6LJMob13oFs3lUjx6H
	uZzc=
X-Received: by 2002:a05:600c:4e4a:b0:46e:4b79:551 with SMTP id 5b1f17b1804b1-46e4b7906ecmr83712675e9.31.1759162432346;
        Mon, 29 Sep 2025 09:13:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoFc8xuMuPIzOs6RnpSitU5twwvIzI1pUCORRMzQfKguRrIHl6sk9Twc5C6wBlCIFOmhcdpQ==
X-Received: by 2002:a05:600c:4e4a:b0:46e:4b79:551 with SMTP id 5b1f17b1804b1-46e4b7906ecmr83710625e9.31.1759162429891;
        Mon, 29 Sep 2025 09:13:49 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb2eesm19397965f8f.12.2025.09.29.09.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 09:13:49 -0700 (PDT)
Message-ID: <06874ec1-5e92-4988-95ed-e4fdbb041845@redhat.com>
Date: Mon, 29 Sep 2025 18:13:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Zi Yan <ziy@nvidia.com>, "Pankaj Raghav (Samsung)"
 <kernel@pankajraghav.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
 syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, linmiaohe@huawei.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 syzkaller-bugs@googlegroups.com
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
 <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
 <CB2E9455-480C-438F-982A-AFCA1051BBDF@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CB2E9455-480C-438F-982A-AFCA1051BBDF@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D_l9tZ3e1oNDia0S5kjvpoILj9L7vaGIXhXyk9DkJvQ_1759162432
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 010001A0015
X-Stat-Signature: 44bp6kxbjtkbpczw99n3um45ypy9wm9k
X-HE-Tag: 1759162435-619069
X-HE-Meta: U2FsdGVkX19tzgOo+v6sXA+pubkMKpqqb4gZnUOrAYjeSqYgUt61Aj62oQ15154gG3GPG7IG7XvR4r6EHioJ/F4UFog9bmoggcBwknv8rt69lKbqfvigqTiPxCGZKHR1pIH8WhH6Ukgi7Z5ZFjqXj18RW6c4S9Su/QCAcKh5VyLr0/JFp8iPhFHsyPis8Z9pSNz9w3zT0lzmURMJoqN9qHyvnqYpRFBAXrKTWn5PUZI7aQ9wZx+XqYvrUnYzwjOwxQS+DGSij65B6XXMPxJKXu4L1mERqLtwtvYH97oH2N4+g2BflEcpfsi+EQDom89YPeN54eni/sZETQfX0m3dlXRLHeKKKP0dHlYhecjzvpAoax/ZFaPqo2eiZin47j0VNwo4hhHB/D6WcXCSuw/Z6K0fqHpm2oNXDol+nwmDbJPwDN6hvX8cqedA3tKtApnexWht6Ks7M4FQG2f/4CTZsi0u4A6u/b7X3kow8yywif22ug4L3uGdLyAQhTEh8l2qp9Wt0te0a3pNqL0zbbxpyfrQel96QUJWKpSY8fbA9mt0R4YwlIQBXCMzM3pxKu91m2NoXC9EPbYCA3coo0Bhl3ubT0lSI66uWLQ7A/8hbbELYO1jv5cuxo7a8M54xDc+7FkcwuY4g9tfN2pyHZv2J6aK8HZiYprwrq4bpxbM0kGVxnbg2Y0wAkTiloy1Iufac6JdKlCGmtatIfjrmlFVJhxX93HNphyv0L6DAx1/Y40pGTJBupiHVV4/jMmW6Om9xU69tHRZsLeV2ZRLkbaeujQSTjmTQ/U0ONfoC1iO8oWEbi0S7wJsA1Px7p8ZbOKnGF90bgy2In9fjaxnmpX9UZxg47L+khCT+rJZfM10c/koaJdFydeLAwzKw0hRwVwhYzET60AFn77ePA9zN8G54oDvcfMw55IC39kg4xpusfdqRRmoWiENcXD5ORVy8+CWyrTxqR6VuhiNVC/bGN4
 F1ZHbGo5
 LoQUT0aZh3CP6FWqlKqLoA6+P+EO4kqSiJTrAdCegzDRCojnzTm/oKmOMUykkkDhfle1SY4sh46e7RS4BTb93MPfC1pdX2uCqpqViQo53rLIK6krtLTj+0/pMzsfC42Xhooqiry32YRbCV2obK0AqncCYOzbWwPnQeQCC6oUHbA7h36AfEUBH4F7pR3CFoFn1IkD0hc5MMMApPs5FRka+yk9/N8vCXMkLYRlCGGisidjMmWF5CKfgY0p5jQNdYO84m02V8q6v5HxnX0bqUY05rKmF3dE9nWBHDixHuUKKumWg2KYTrtNsZAX6FB9Hgua08wAgdP2ZHaoyQTPRZWlS7l3tydwdva7VpE16sJORopH49h2WHoLUjCvBRDXZvYAD6K1JlM4B6rJlR5o7aU4GjzK4/f8v+6D8m+6GOElsQiKA6us9UV3B8tCXWyf6hYbk0L0W3r+gERQLGLgrF4b4+X+dLZNhlsXvRVEoFvprAUZ+LNTr+BM+E16oeyzuNUvaBHBYWXD4jDX/1yJH1bfkLZ+WNJ1w3PwbD8ClVO9VAktKOrUdMGsYMuwmIfTuk9NMzDJtA9ogpGUoPbUEH3rEoaIlL8HkGQeDV9cz1AR1raZAKeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.09.25 17:20, Zi Yan wrote:
> On 29 Sep 2025, at 7:08, Pankaj Raghav (Samsung) wrote:
> 
>>>
>>> I want to change all the split functions in huge_mm.h and provide
>>> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_folio().
>>>
>>> Something like below:
>>>
>>> 1. no split function will change the given order;
>>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
>>> is smaller than mapping_min_folio_order().
>>>
>>> In this way, for an LBS folio that cannot be split to order 0, split
>>> functions will return -EINVAL to tell caller that the folio cannot
>>> be split. The caller is supposed to handle the split failure.
>>
>> IIUC, we will remove warn on once but just return -EINVAL in __folio_split()
>> function if new_order < min_order like this:
>> ...
>> 		min_order = mapping_min_folio_order(folio->mapping);
>> 		if (new_order < min_order) {
>> -			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
>> -				     min_order);
>> 			ret = -EINVAL;
>> 			goto out;
>> 		}
>> ...
>>>
>>> WDYT?
>>>
>> I think it should be fine as along as we return an error if someone is
>> trying to split < min_order for file-backed folios.
>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index f327d62fc985..e15c3ca07e33 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -387,34 +387,16 @@ int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>>    * Return: 0: split is successful, otherwise split failed.
>>>    */
>>>   static inline int try_folio_split(struct folio *folio, struct page *page,
>>> -		struct list_head *list)
>>> +		struct list_head *list, unsigned int order)
>>>   {
> 
> OK, I will send a proper patch to fix this. Thanks.

Thanks!

-- 
Cheers

David / dhildenb


