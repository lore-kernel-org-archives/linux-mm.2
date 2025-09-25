Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E2CCAC5B3
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 16:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155818E0007; Thu, 25 Sep 2025 12:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105F08E0001; Thu, 25 Sep 2025 12:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8AA8E0007; Thu, 25 Sep 2025 12:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6F478E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:49:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5EC008601B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:49:00 +0000 (UTC)
X-FDA: 83928357240.08.99F511B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBEEA1C0009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:48:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f82ENUAB;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758818938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjSvoYHIH2UpZoiBo+l7+GcLMTbURxxIhZVNZignwuw=;
	b=aRSTeUkGUBk+9oVTcbjlvlaJVevKKxu6VMrSq5rwClPm8sLsOqVvDdmfO92IP3bQUtX7Pq
	4U5sUDnK7sWNdcewjUQO9ncfqb/LPPkq7RzCrvBJytH6g7ZvUnKJKfdwAjuF/V+6i0R/nQ
	xax9QN6LArLBsffLUlkPTcR7iTmIY7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758818938; a=rsa-sha256;
	cv=none;
	b=wVuebTR1NzEcWQlDHjiDBy2wHPFi87j06L7bxGYKR+PSzM7weUrjlQWbv+4e+aqK0MUbgZ
	4cme20WEK0UVz5wuyrVemS6Dr2OLSRuTcJmc74MbWwKZ+732D2NhurKpRtaI9I6yK2yoTf
	L/t8Owo3OzM+EGOm4/0S9wByoWGDeiU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f82ENUAB;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758818937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MjSvoYHIH2UpZoiBo+l7+GcLMTbURxxIhZVNZignwuw=;
	b=f82ENUAB4pYSD6VRqWvvWQ9Kq5IL4ApGodcpuw5r3runpudV7n1KMPr5/iT/cHxNE/l0Dw
	Cxhm3r4n8KeiymayY0VoC5K6TtHrtzF4/RRQFGJV44LmI4Ei8cW4w8ohZc9f0gXVwnCvVs
	6DV3D1I2OscyxUSgpcEFwUB3PYp7fug=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-ZKSDfesIMk-ziNpPrPvn1w-1; Thu, 25 Sep 2025 12:48:55 -0400
X-MC-Unique: ZKSDfesIMk-ziNpPrPvn1w-1
X-Mimecast-MFC-AGG-ID: ZKSDfesIMk-ziNpPrPvn1w_1758818934
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f28552927so8944705e9.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758818934; x=1759423734;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MjSvoYHIH2UpZoiBo+l7+GcLMTbURxxIhZVNZignwuw=;
        b=L1ws8FRy2EfWroug+TSz9S5ObwE9/rNx9/MHBPDHR1tZQjDJYR3w7HXZ2yRaM0dgHN
         7C6pm5/fggMpiHPPh9IEIpAOHAKHIYylEJHgiL4s5fl0bUxI7wEgaU+XfX+DaVbYAoMT
         T5Eaq7CyJ6z5ZbKNunGJtTd5+O9XlPWoCMlcs1TwYUnX/yrKLV1bWX5nmXahuIOnVEI4
         GuOiJAcUFefvMjFrJFCKCOOPHH6VndHOC6G0q7C5NKzqrBlX/gQikODLZ4G2goLppfzq
         btG+Kq2Zp7I1l/mR9z0sVx/iWxYfcaByWvT7/FBbHpT/L7i++kAhDS4jVUIEvRE0rka7
         tm4A==
X-Forwarded-Encrypted: i=1; AJvYcCURP4baE6VX1hUdf2k01sVlXGvjLEqWcXJNxc9hJYWqeaOQFpTt9iWciR1LGf5zuklD60k37n3JoQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4LrsKZ00OYZuKdWLbfd42KUivZEUmKyDwwQ57wgclJgnlUrr9
	NZ537Hck025+4r2ky12UVTPpMAFzzqm9I+oaKNvd4wjSXPcfWfBYcOxq+qoqRvqK3qrJ6VvlD7w
	bZCwLoiNCpjXrl7qSyrT8zUI/jBo4F7q745WRZuxBJP64t42SBBkm
X-Gm-Gg: ASbGnctCYm4XHyw8dbEcRvO+vkw6Zn4ATq05ogLDX0sSipolf385GzSGbh5uvfcv6RA
	w99ADAFeduMfSj4V2i7rD5flWu1JEPtPw+6sSX86InsqTjWz4CfP7mr+nKhi9b/j+gdxhU9lMT7
	/DOivtpSmCCZzpxdPqpxibtHCb/TkM6pkadkrQSQhKm8GD5f1UWyzMYyqsbbYq31bLYf2khrmn9
	k2xU8iMU3LyDCSwvS5huI0t0SpH0dI4VVT1O/AmCavbYVH1kAzB0JS+H0NlQKge1VqWdmNfivws
	zR6/JwdBOe+XFwfVvWvtVD2++4qViuDoZ94aqtt57vVjg3oCS2zpBvNITQjRs/BbvvwqDcQFIZB
	iBQVcX/EFwI+h5PTl8XOlKrv70V3yEbgh9uOpo6b2hwdDmO5ojLC2C+oolbaW1OIabZCf
X-Received: by 2002:a05:600c:3b9e:b0:45f:2f0f:6649 with SMTP id 5b1f17b1804b1-46e329d474fmr59697475e9.8.1758818934314;
        Thu, 25 Sep 2025 09:48:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGn7Q4TLnsyQFemXW3TSRUkmiBvcmsqkTzlgD8VuFDl1YltrZigpOKq6nqZMBI5FA7WyVb9NQ==
X-Received: by 2002:a05:600c:3b9e:b0:45f:2f0f:6649 with SMTP id 5b1f17b1804b1-46e329d474fmr59697125e9.8.1758818933864;
        Thu, 25 Sep 2025 09:48:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab62233sm84331395e9.21.2025.09.25.09.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 09:48:53 -0700 (PDT)
Message-ID: <ec108aa2-88ae-42bb-a64d-ef12867526c4@redhat.com>
Date: Thu, 25 Sep 2025 18:48:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
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
 <CAHbLzkrstjnEVUzz2==A2Z+CJToOgU6YU2MasdK49o-0-jW2yw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAHbLzkrstjnEVUzz2==A2Z+CJToOgU6YU2MasdK49o-0-jW2yw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x0Zsh-qjgA9nRyb9JaocGsdDCJLLYmlR7BVLotdZ1-4_1758818934
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7wxowdbjosteit6xb8h67uz9jk15yt3x
X-Rspamd-Queue-Id: DBEEA1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758818937-592824
X-HE-Meta: U2FsdGVkX1/eej+TUGu2T3hvY88k5KWR0dhZfHP656TUNPPuKZJAFf2gjl4B4z5htHdFDjiIm5BgfTv7rDgM13s3NF9IlEbmprKVyokR7xKvGiJcay3bYnpoyS8yNnT/MXjq1gpVNoKAZBWOGoLL4qmkfdCsB/LkrzPZh1q6kS6vbYmwY9DK57/zMBcPAJSDANy+h4hzQM4BrgVeL6Q5++cFYfDSvxl7DpSC9M+Y6cUevCQqR7kabtPsBKKfh9aUBRSczWkDIF8JxXZTxbD/Nr/z+xLusIHaABWPwH2ao0T/tUC4vBc3Wu+NvDQnLG6DY0nM+KrNSM4Ij+sZVh6xehWSz21Pc3kcJRA2BuWwWHHvSqQq7bC66CvPJ0guq/oHY0bY1J7yClNus1Yzgith626TiSm/N2rouXXPg98GofUbGlnxD91FE/B72m13M7KTX9VpFFR3szCA+HtTsS1S0yP3sQRPaNDJprySgysNMKeP4A/hZW7+Zp+2V6xzGADa2QC/Kz8G10/JjhvRq25zJYX3VTEuOwDBG3k1rknbL4vWtQxGevOfpV6rxNrfVFou0BtlUKI6QOPd98esZCitGIYWntyiIb4iSViwEhNIeOBnfhvoecgohShepZ2tVkpDjxBhIfitWYySvkvWULqg5w4o23KIsP1CX1NnT8PLlI1TgY4ItWMR/xEt9DMMwNPrrIDt+LD36KLgIhmPJOJSOHa3tipZg1zt1a/v7r+1VMHmRrZX1M+Kx97Cgcze6WpOCsq48SNiHGRVIZ0+S9KyqxSqBuz02nxRY0uFUkLkpZ9xpHJRny6iXSATECL0sXdRcfBM0zzR4YCsFYwEFe2SyK2aQ8uSwuysSR4LCH9EP1rIrAFdEsV0zSD9kJVWvI9ib0fbqz4uK5h8oHqUIzhXwuLYVG9OUnVSZ9xL2w4PdOpz0EpuPekW6ZVUhC2hQAqVzawIrI8L9Utb7ISEFg9
 oTXHrkdI
 OM6zL8SMIoHqcQRPqJoHwyiaeounJEpm7wpnzq93zRjvYR8CB0w3pIVbG03i/6O0yiHheg5nNEQEDLi7VR6ioiuKsnFnkFFlCPGofWcfqL4OKYKJe4LJo3VQrlXbGKfUcgBXfFRukbdjPYT5SJYwVmNTASqF80WXviPHlu7xvVWgSfm6yRK/O/fEP3UXr0sa7GAIRL5vm7oAMtN3pnDypQZJn+x7szXW/pYdwebuiypfsT8TaOQuJuXCu8rjoteJWS3QHUUZcayAMEAwO/k18AOKmg84A5JpEJlEHqEqxMictjga8S+EtgD+p5szQkULB8YcY6U/IXjxekGqDyiOq/vPHwE27E94ybrnGMj0hUST2TTTkaWzipHFXqYF7E/4BQ/tdFFIbrbOgHUr4SvFlzGIgnUotDuC1TLbSaTRrfDFLOhuyQ6LOjFKkPNZjjJ6Te3Kub73qQV0ogQV06ptUkpCYx/Q+1T4l1rzELMLoBt/Ox5PCc9FQhbKFxghJ07r6QajKy2qKCwjlyRQFRpic/spTIjLaOQpdeJPuEFA8z0ZDfwpCjjdeuUF+1Rwq8g8u5lqiNW0Hj1UuZLC0woyY19/hXUmkOTbZNK2DcRfZnGFHGAfw2fX7DwsOkaEKawyEQrMffN4pFFXfOmjsnRDUMcBiDo4AHcVj1GPc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 18:23, Yang Shi wrote:
> On Thu, Sep 25, 2025 at 7:45 AM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 25 Sep 2025, at 8:02, Pankaj Raghav (Samsung) wrote:
>>
>>>>>>
>>>>>> We might just need (a), since there is no caller of (b) in kernel, except
>>>>>> split_folio_to_order() is used for testing. There might be future uses
>>>>>> when kernel wants to convert from THP to mTHP, but it seems that we are
>>>>>> not there yet.
>>>>>>
>>>>>
>>>>> Even better, then maybe selected interfaces could just fail if the min-order contradicts with the request to split to a non-larger (order-0) folio.
>>>>
>>>> Yep. Let’s hear what Luis and Pankaj will say about this.
>>>>
>>>>>
>>>>>>
>>>>>>
>>>>>> +Luis and Pankaj for their opinions on how LBS is going to use split folio
>>>>>> to any order.
>>>>>>
>>>>>> Hi Luis and Pankaj,
>>>>>>
>>>>>> It seems that bumping split folio order from 0 to mapping_min_folio_order()
>>>>>> instead of simply failing the split folio call gives surprises to some
>>>>>> callers and causes issues like the one reported by this email. I cannot think
>>>>>> of any situation where failing a folio split does not work. If LBS code
>>>>>> wants to split, it should supply mapping_min_folio_order(), right? Does
>>>>>> such caller exist?
>>>>>>
>>>
>>> I am not aware of any place in the LBS path where we supply the
>>> min_order. truncate_inode_partial_folio() calls try_folio_split(), which
>>> takes care of splitting in min_order chunks. So we embedded the
>>> min_order in the MM functions that performs the split instead of the
>>> caller passing the min_order. Probably, that is why this problem is
>>> being exposed now where people are surprised by seeing a large folio
>>> even though they asked to split folios to order-0.
>>>
>>> As you concluded, we will not be breaking anything wrt LBS as we
>>> just refuse to split if it doesn't match the min_order. The only issue I
>>> see is we might be exacerbating ENOMEM errors as we are not splitting as
>>> many folios with this change. But the solution for that is simple, add
>>> more RAM to the system ;)
>>>
>>> Just for clarity, are we talking about changing the behaviour just the
>>> try_to_split_thp_page() function or all the split functions in huge_mm.h?
>>
>> I want to change all the split functions in huge_mm.h and provide
>> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_folio().
>>
>> Something like below:
>>
>> 1. no split function will change the given order;
>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
>> is smaller than mapping_min_folio_order().
>>
>> In this way, for an LBS folio that cannot be split to order 0, split
>> functions will return -EINVAL to tell caller that the folio cannot
>> be split. The caller is supposed to handle the split failure.
> 
> Other than making folio split more reliable, it seems like to me this
> bug report shows memory failure doesn't handle LBS folio properly. For
> example, if the block size <= order-0 page size (this should be always
> true before LBS), memory failure should expect the large folio is
> split to order-0, then the poisoned order-0 page should be discarded
> if it is not dirty. The later access to the block will trigger a major
> fault.

Agreed that larger-folio support would be nice in memory-failure code, 
but I recall some other areas we recently touched that are rather hairy. 
(something around unmap_poisoned_folio()).

The BUG at hand is that we changed splitting semantics without taking 
care of the actual users.

-- 
Cheers

David / dhildenb


