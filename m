Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B84CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8C18E0003; Tue, 21 Oct 2025 11:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9AC8E0002; Tue, 21 Oct 2025 11:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7713C8E0003; Tue, 21 Oct 2025 11:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF018E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:25:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6854C0490
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:25:33 +0000 (UTC)
X-FDA: 84022495746.14.AB2998A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54B22C0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:25:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZWvUGmYp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761060331; a=rsa-sha256;
	cv=none;
	b=RUFZCMEL39eLx9Iax3t6p6U6nB8CquA0PC8xoyRR9tjEsOHfTslAx7LlprQRI5TSZeHgG3
	7avGmhKdAimlEha3TjXkWshqE3Wtc+HE8DKDegcCnuCstKkzIS+ZZkhog6P+aRW/UGbfFp
	B3hXMvSU0kI7m5Ql7gl6HEECNqvLqsE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZWvUGmYp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761060331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryq8ZFFn05SNtiRqO+IXV06muSLymOv5LlgDxE1tkJM=;
	b=aD34PC6L/sHCAWhxEWJd5kDAuuOKjUYArUcIdQi+PlaD+nScall7GiEDTqtUfUMJeGhWdC
	5vYHIy1pI8gv6YzGCFTe1A5ZNJA2ZfJgn7m7IFG6FQA/nZCKSKK6BCrnhtYzgux8GUrCGG
	td/t1q78eIVnWPYUDlFVht5sq9Wpp28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761060330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ryq8ZFFn05SNtiRqO+IXV06muSLymOv5LlgDxE1tkJM=;
	b=ZWvUGmYpUAvoYI6MUhAlui504DVq/prrSgRpVaB2fMN498hoS4/+KSF0OspJgQXZJsbapJ
	x8mCE4b45VatLRE8dFfktxa5fe8antPzBCAn3tLSZdTNdeLUxnJ3k17hw+jbKe8PAunaxx
	5CoE7u2ai8axn5JLhoDYn2O/cX7DxiA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-Mlg_kzvZOleZPTKjBzY2oQ-1; Tue, 21 Oct 2025 11:25:29 -0400
X-MC-Unique: Mlg_kzvZOleZPTKjBzY2oQ-1
X-Mimecast-MFC-AGG-ID: Mlg_kzvZOleZPTKjBzY2oQ_1761060327
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4270848ceffso5777585f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:25:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761060327; x=1761665127;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ryq8ZFFn05SNtiRqO+IXV06muSLymOv5LlgDxE1tkJM=;
        b=Jdu5nT/+kchamqsC0I79SeNjlq9rln7QtE2++LKY++gONcauLnRSCZzh1HOaT3XIey
         KL69rVfFL3jYQrHqmxqGQkGNwUA2LyO0PqlEkipCxeQALtxbAzgFvjaoEHK/dJ+gYu0g
         cJ4ItRMAqeGp9E8bAOmgASBpwaMb+5m358f857a1sxR9cIcWTrM53FOOCpj+iA+CGcmy
         QCK13BrzwBHQ1iJbmTgeO9yzlj+iyurWE9NxNZ75AxkldPdG4+QxVGP6S6NgVU7iTYUf
         2bfOmr5ja1vc57r0zUzp7RsCRkMbjV9NWl8MxwmPKkgEQegQYMFZNHA/2CFWRyiZFrw0
         lo3A==
X-Forwarded-Encrypted: i=1; AJvYcCVBmYBUHQcQVIhQrGf26yeTMY17tyk98jb1iv1ZYTBigfrReGkJ5pVmyUdML5Ebyjzo3BffmP7SeQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8c827Nya/Ilz4X7KIQxoKtdTW7JV/LLF+UVxrcQrhywbObM8d
	E3PDJAhmGvErP+ny9BRtfude3YoiHxB3DzRUR3em8uaiK81u9IV9yMPdx68i4Btv1d34fc+/ixh
	cMiM3UcSOtJ8eK8Ez9V9fjuiKzX0lE5u2lFv2VDOG/Z28RRrv4K2k
X-Gm-Gg: ASbGncv87WkDTXf3P45CzDmgLQflNVwhaDhFeEtq1weygjvp9cYUFs9qmBaIUMv2aJW
	6DN0v/8tQWU2lUfFZI9f0E97t2mFJ6zrfTrPMIAJ8QDBv3FpkyNCoM4IzeKYHED5lEfXR8tMj9g
	HfhKHbgsGSmw2gHyVc6AQjMhej4ehgrhp576z4Jnc5f6PRrvsO+M0MH/dYmtfHu+xSMbP4SGJT2
	6H0tMfW8nY/zmkUwnwGQg7R6BWxmE6IuSHlHbbtZQ7UkQubQeW83mTE0+QsbdRoWxwT2iCggs8A
	lhYNJoidMy9oLIVAfhzkNr2hVDVTLgGqu+fhqqGNNOE2xPLqp4mxT+jnCzu7EX5h4Wa2VS3oET4
	H9MQsii6SjFURDfAlK9x7iF7HF+MFCkWON533hu7ShHlPnm+N5+N4ybcqCDNBU3/Xfxpih31CPK
	54ScdhF2BCPixdtG/Ew1L0cZQaREY=
X-Received: by 2002:a05:6000:705:b0:427:603:715 with SMTP id ffacd0b85a97d-42706030721mr8869518f8f.18.1761060326887;
        Tue, 21 Oct 2025 08:25:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiKHKT5n4lxAIXcZezjjomGqsscckAjK3PPu93OYAWQLb8JpaHvdOvGofIdZ4ec/p/eA4hhg==
X-Received: by 2002:a05:6000:705:b0:427:603:715 with SMTP id ffacd0b85a97d-42706030721mr8869502f8f.18.1761060326480;
        Tue, 21 Oct 2025 08:25:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0ec2sm20701088f8f.3.2025.10.21.08.25.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:25:25 -0700 (PDT)
Message-ID: <8f71e65c-a860-40ec-8570-5cf8f0f947d1@redhat.com>
Date: Tue, 21 Oct 2025 17:25:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, craftfever <craftfever@airmail.cc>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251016012236.4189-1-pedrodemargomes@gmail.com>
 <844af749-374e-49b3-91f0-a72e951981c8@redhat.com>
 <2d0cbd23-83e9-460b-a82a-d006a14fa9fb@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2d0cbd23-83e9-460b-a82a-d006a14fa9fb@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I9dDSrSK6uFjosOrp6jnLUYhSOXsZggRJKp3c3iaBig_1761060327
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yxdx3pmhuh9rgzqb79qdng4m9gqai7be
X-Rspamd-Queue-Id: 54B22C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761060331-289001
X-HE-Meta: U2FsdGVkX18Oon3o783foG2zpclEBtW6p3+jy8kvasbu3A7lfrqjvygaFnLCI3FQLj4ft+1iV2vS/87OdqOOqI4o0WfRA2Gccbd73LuaWCCOgDEdh/9xQDD+Ap1bsLTqfnZ3qIHgcoEHMAFTj521tW2/jV8YBAxbbdyjxIFx730mSROlUaV0N3dvDl4MMd7OZHu+3qnF0qG2zfE5Myr5hQb+MpX1AzbGt6c4f3hFBaUYoFIziazlKb014ygIBe8E7q3ff4q36hZdIQZkP36kI+f+o5zR7yI9P0SqqpYFCG95KnYTLBzaXCsrRHFyeAjbug7CiHoEt6y7GBrPrRJORHbP8pEicg3WppHEDDtDQmY5IxxcuVeKc1Y+qRfKEM+d1v90lXAWDMKp9qYrT0InBkmccgMMNA0U09tr2hyK5a86Y+4QigBrFGPAXIqFtKglIDmB68EM5V82xP1JXSiYvqYc0wLe0+YXClFIcWvdnLOG0Lo95TGeGhvI11Lz905xbgBkPs5tc62G2/VniA6bNKc7vyzcVwiBdoaFsNQuJuvIhXo+Oaj83EM2jcrjQ4pcfzvq+B4ItMz2lMhZ3CbQCDAGv0fYJdR0Tte6ez3scqvlGkGoeTqfMbRJsdh2TbG4bLQ082QML94EGa02kgD07z9tSHba0pmOlvF4hKelmMYUzk/VAy24NC1/Qln/qLrghttTZlIq/7+uNZp3+OdWLClFKAeQn55wUxa9UyJhVLW1y7sqf6y0CczpWKL3+XK5Y30XDOdTblpKlPZdjANpkmyH0cypnTajTXZq6G+qH+0RmjboE1F/ujMzwBGFbi6MBe0VyjF09ERYPjC7BGon9+5Bg8nKIOeC6F3uqaRw/SQBe8V5qEZfPZCYIG0lZuGoN23k2jmx7LhlPluTnOnThwh5+urS62GGPkT1P6jwSm9Rg7Klo1OcwSYRvSa253kuX2vXwGbFG5ZkPimlc5m
 CsMl7H7S
 xysjan79Hgomhcg6Gj5CHQb1mcNKcroDuOJ+UcRxsZGVDBFc9rDpBVOL0bEcez11zds3SZYhGAifjPsIws75pUoILYTppQyrusVWg3lEO2Xf6SVuD6ExRFlxwBbZNBv12QqbO6ayZI7buVBecxIUXvRPBroGRBPSwadWQUPpThMcwVh7bqK56JA5Y8NGC2rtIe2oDuw/ZQ/L1w4QSqOYM3HykHkKs6L3+s0R6t2r5sIoWU3tf10mX1fUCfur8ON7QlP/lr3/KkymUOfIUuaTyuMtZoFOQmr/mgNAtghi0+7dGDIMPS6aaFmTMka3OcUedyK2x0tmT2kjog0nRIoEQN/IYUiuOCtBr3Ye1u/YXLiUcRemP0F1jc0iemdl/JIBokr2MQsF/JVwgQKN6XAe8gP+robSWhMh8PiFBG8Aniepw74up2OGgMxlLTU4FVuBgiWBjz2gLDHQquWwViHb5OWD7QJDrxBHJank5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 05:00, Pedro Demarchi Gomes wrote:
> 
> On 10/17/25 19:23, David Hildenbrand wrote:
> 
>> This patch does to much in a single patch which makes it
>> rather hard to review.
>>
>> As a first step, we should focus on leaving most of
>> scan_get_next_rmap_item() alone and only focus on replacing
>> folio_walk by walk_page_range_vma().
>>
>> Follow-up cleanups could try cleaning up scan_get_next_rmap_item()
>> -- and boy oh boy, does that function scream for quite some cleanups.
>>
>> This is something minimal based on your v3. I applied plenty of more
>> cleanups and I wish we could further shrink the pmd_entry function,
>> but I have to give up for today (well, it's already tomorrow :) ).
> 
> Should I send a v4 to be applied on top of your minimal patch? This
> v4 would eliminate the need of the for_each_vma using the test_walk
> callback like the previous versions.

It would be good if you could test the rework I sent and see if you want 
to do any tweaks to it. It was a rather quick rework on my side.


Then resend that as v4, which is then minimal and we can reasonable add 
Fixes: + Cc: stable.

Right from that start we used follow_page() on each individual address.

So likely best to add

	Fixes: 31dbd01f3143 ("ksm: Kernel SamePage Merging")

Once that fix is in you can send further cleanups that are independent 
of the fix itself, like removing the for_each_vma() etc.

-- 
Cheers

David / dhildenb


