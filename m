Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC2CCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 10:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F658E0008; Thu, 23 Oct 2025 06:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940238E0002; Thu, 23 Oct 2025 06:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808108E0008; Thu, 23 Oct 2025 06:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF378E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:14:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AE175C5CC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:14:05 +0000 (UTC)
X-FDA: 84028968450.03.290B601
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC1892000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:14:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b1OVCEMw;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761214442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYRDFMsX7IhpWRX+3N1D8BCmUrjohjYlAA5w2Y8gVM8=;
	b=YkQIW3NLJh9FCnJ5Zm+vZNmTAA96e21wO7h+IFzwwoEIdKtBWQU3jFwVF4GM7YERGlmEQ2
	lk4/AlmTVlFVo2bbS1Z6X/rgu7R4TefWE3O3CCuaayqLBZcONsqGllDh7ut0nJbMmX3sWb
	dr8sl79gFRVYdnluh9gp7vVb27iR8Ao=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b1OVCEMw;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761214442; a=rsa-sha256;
	cv=none;
	b=tsAmI+dT+HUUNti+6Fjej7ogkulkgcuJv6Mzx92xv5y8RNfPi+BbLEHU+gLeyQmnIQduBi
	NhpGXJsIbe3FrZ42QMtjtUvc2zikgAxKj0lGF8OJpeEBjeAgPz6uq2+kNkq84Rwo1EwSks
	K72do4SnZJ+3j0PUqF69wPTyLNtpz1Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761214442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FYRDFMsX7IhpWRX+3N1D8BCmUrjohjYlAA5w2Y8gVM8=;
	b=b1OVCEMwiR63RqCzGzoJ1CU/sfCpuOmy2g/wUzuohmECKJqp32PcPMtW7SN/RRgYx+rISy
	heegx3PlzlpjZlin2Wz25/Sz5Uw7XjzL32QI48Ts7Qypi4JCW9AWUqFdfYDOrBtloqmdwe
	Pnaruz4V+MEsV+gQVnnprILs+JFHW1Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-p3tgRLBTOZWbShVBgM8cUQ-1; Thu, 23 Oct 2025 06:14:00 -0400
X-MC-Unique: p3tgRLBTOZWbShVBgM8cUQ-1
X-Mimecast-MFC-AGG-ID: p3tgRLBTOZWbShVBgM8cUQ_1761214439
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-40fd1b17d2bso219854f8f.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761214439; x=1761819239;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYRDFMsX7IhpWRX+3N1D8BCmUrjohjYlAA5w2Y8gVM8=;
        b=AYr1NepjfqUNLXm9zFien6WY36J3XGs4EclI2d10tvTwi2LOEOA7HbuJBcweD6BC60
         f/UjvMC3yIFhbiWZCbffvo+DuDd0J+tlzjWLqWNOdncjDhVpt3O+ut0qAfzbHrkN9TZq
         +3C/k1yFFpztgHEK0K73jq+wybgDViVwkZotGILjjbofRGIpz3d8PX7ypwHZjpK2WGrV
         NmzD4PWtYcu/jaMzBtV7p9Sm9ZzG4t8kQkAVtJFgVOHvrroqIHtggj8QFaGlibVnkq0p
         /ZX+l/l2YBbyUDjq01wZyylsLeTy9Ret9yTbtMdnvf+RfKW9x6wHzxQO9W8tHl2MG2JR
         V8Tg==
X-Forwarded-Encrypted: i=1; AJvYcCUYL2EmLCAhW34/nHUdNNUja2uNXzyViWsHA0lur0qmKQI3v9DQPpnf0mFqaEgq7qjlGuOboE0bGg==@kvack.org
X-Gm-Message-State: AOJu0YxUXfodIUmVs6e0yx31/v1yC/9wvx/hVa0P97SDc1RI86yCrspm
	s4dybzFQQr4rqpDTXgT4ODjkpVZs09lfkOn5hKFQXBBic5PUYcLQ6io3HTFn+qUe8dmvkQP7Vnn
	PqqX9dEe2ZQWi7CkFRMakEMbEfYBQNm+pBaSYlDNr8+19BM0skGJM
X-Gm-Gg: ASbGncvRpYeATBNLWcFWNHKtggukEZsAt6GnsgyGRrykoXgD/CTNKEi6PFUtrxSIyxP
	n4zn4TpNpVhgGWUEdd9ihxQ7fzuuYt6PSwmYhZ0ahq60ivH0DhDT2w6MbwJ/oWa2M5EBaVcjjO5
	rm+QtXRbH0fo7EVmMQztE42LVuACHqOjRKzJ0/JQArtvcmH5QsPXls2kCWtBB4QDurORCRLWZkq
	zwADgBO7991JB77sY0nUmjJUvtvG2zuALSKYdwJ0Aj1FVnuC8ZFp0/PcB8w88SWB1bBxEOjB8bu
	QQNGiJMQP4nWnPoU1aM6ZSQ3VBqa1qUrJFXsdMDffFHMIMNDM7qhzVnTxFDh/noCvBMwy5whKtx
	fiJtpl8Ud/6JQAPc08qgpKFchOAOeNl49Tt6OlFWQMdhWLAoDusvugAVGcbdLmH/fNjYmH95iX7
	w7bfzRRnyQhwR7r9glv4QiPmrSPQE=
X-Received: by 2002:a05:6000:2406:b0:427:9d7:870f with SMTP id ffacd0b85a97d-42709d78818mr15466052f8f.5.1761214439068;
        Thu, 23 Oct 2025 03:13:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2y9ddCN514f4jZlZAuanJWD21VLCxDfJQeDN3Ku52N38WwDLlzbHP04E/FyV2cjTALX+UKQ==
X-Received: by 2002:a05:6000:2406:b0:427:9d7:870f with SMTP id ffacd0b85a97d-42709d78818mr15466039f8f.5.1761214438691;
        Thu, 23 Oct 2025 03:13:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897e76b8sm3377847f8f.1.2025.10.23.03.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 03:13:58 -0700 (PDT)
Message-ID: <33e299b9-8596-4ae2-b291-4b067dc32001@redhat.com>
Date: Thu, 23 Oct 2025 12:13:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: craftfever <craftfever@airmail.cc>,
 Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251023035841.41406-1-pedrodemargomes@gmail.com>
 <d06f4c9d-cf63-4bc4-859d-8256e16dd68d@airmail.cc>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d06f4c9d-cf63-4bc4-859d-8256e16dd68d@airmail.cc>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cS01ZmzlsxLoQrECGVZa69NEutq5D0uP54qEWiPfh0Q_1761214439
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BC1892000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y87armqrxparsuncpo11s646u5k7mudt
X-HE-Tag: 1761214442-647497
X-HE-Meta: U2FsdGVkX1+mlRAiPfsl0Fv8ShIsmQ27yhafyXbukK7nnPey47noopBVK5Ofou8/3d1p3snkgFTQBK20B4Zk7zI6Qw4awrej+i5LYTpkMEBiJCyRKpNawzDAaT99wNJFww1Qbuqxa7ZVc1Gf9meTsbhjoXWQhxg99d9O2OokCNAl4x9oGwTCBd1cRn/4xZc2hvbYMPLeyT8aTh4ksW4qEmuqJP1ZczXIqQ0ehPkPKw1iWPq2wQyjecwfYEsWrcpLn7TLUIsPWVpzLAKr5GMRHXdZpCjk1qaLVmQboZMAbWIGGHMCItCn90nhjWESi+jAcauS6IACkHLgW+lYTVJL05lnJ1Xp28kqWzLTH3Kod5k5iHgRunDYzGROQAr/vhzPht3Ic9ITwvQPftrwilrX4HWYPMgK7EYPv+VK4rLL6RKHgHqaMO6pMcVoamoVwJpMGQqQAtSiN8HNiGkbfhOVN2ilSd7FW9B3OQP6y2S5oEVojb73nsgOxa7Atcu1icDyWE2CB3p2EagkIftCgYDfLZHLMBvjx4r2o8x//G2XsgksICy/ASQCkNcho14hMiUqqoZYIjwGEOGbDzBti9zRAPIKRHYpFQNXXNOeSrtUPhlrUJfm7pWUYGPGPdX8VhwyMWWo1urbeEkzIJIL+SuVkfZxpkv6U4sXqvqaFD+TqiA5lgV3fg7aghSXguC2CabWvtJ+S1RllPQ5QmkZeDimrWsujkXSE2BeC2ylsZJ9IW/sZsC4BFF/FAlTRog6K5dob8XwdHaduXHxwJTvfkmtU3qABeXLsr5MGSSYJRibZZtCKgWo4zv5gj8oiA8ubcuVZKjq+oAdsdyDc4CbxHd29riCHbiz44xqnAUgvmctLrrgb5/CW3wPIPTlzuRTo2aNqov+h69xcIT0I9v2ykW5vY3JIyKXJWUzAdY33/zeQRC4iFgQbNVQYcXmb51opPM6quOjGqD2BrKeCWPpNpF
 TqT7g7Ug
 Przoti2TIDM9iJqSKpejH9/wwi6m2iuFs+VS7H4qbMad9/VLwgM7nif8VT4QoEEXs3bThUF2EEUktEP2qVbQKFm1vojtC1Le85Q8T71FSKFfszu+zeOE7ObetR+gBKlJUs8grS0RhPFis9kkJNdJ4lcDgN6lp4ysMxln8Dt1ZMe8RwiIF5nqULxyMUp9tMrI4HKAawjOmCJbui3craqBcU1bkDEydsrgNoR+qEz4Fw08ko0ZG4NwFf3nX3MpSWFrKxpImAzMjLIK5PwOwFY6ELEdONOM61/sYY4qKpSAwFBomICLx8BqjoVkPUMXpKhYJP7k4Ss6FMLHg4PwtNXVb3A0GG8CTwzkMez0ctqED++/m/7MnHQ/38lXKLfmOQrnPuefxpazY7tNET7i04MWvjaAseDe45LhRGYLTwzuIeaWpXsfLmrmUvdLrrSJLkQvFutyp6loYO7P7aA9WtxiwRsFP5Ey8MbeY85adU/HJq8KpgCunXKirBeFiQGI0pb5EnUtELtsgs9W7fhiwHfSY3o1hE/zReYvrRSaVsuqWwb95Z3mSHsHT2/pvv86YpqQbwMHusaqjWT97Kb4rVH7Lc4xeXBXIYirA0ydX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>    				break;
>>    
>> -			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
>> -			if (folio) {
>> -				if (!folio_is_zone_device(folio) &&
>> -				     folio_test_anon(folio)) {
>> -					folio_get(folio);
>> -					tmp_page = fw.page;
>> -				}
>> -				folio_walk_end(&fw, vma);
>> +			int found;
>> +
>> +			found = walk_page_range_vma(vma, ksm_scan.address,
>> +						    vma->vm_end,
>> +						    &ksm_next_page_ops,
>> +						    &ksm_next_page_arg);
>> +
>> +			if (found > 0) {
>> +				folio = ksm_next_page_arg.folio;
>> +				tmp_page = ksm_next_page_arg.page;
>> +				ksm_scan.address = ksm_next_page_arg.addr;
>> +			} else {
>> +				VM_WARN_ON_ONCE(found < 0);
>> +				ksm_scan.address = vma->vm_end - PAGE_SIZE;
>>    			}
>>    
>>    			if (tmp_page) {
> 
> Thank you, it works magnificently, very pleasent. Very low CPU-consuming
> and effective, no crashes. Is this a final version?

If there is no further feedback, yes.

-- 
Cheers

David / dhildenb


