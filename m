Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AEDECCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47308E0009; Mon, 13 Oct 2025 07:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F6B8E0007; Mon, 13 Oct 2025 07:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EA88E0009; Mon, 13 Oct 2025 07:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC7018E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:13:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AB0C8762A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:13:43 +0000 (UTC)
X-FDA: 83992830726.24.BA3E9AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id E34548001F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:13:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zhn2AzhV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760354021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUk2T2O1JALynkNTDXVgTlfmJ0m3TsHCHf1HTqOjalU=;
	b=bqgH5I0mApQsknmTpoMcXEh7UomPBQ57J3h68Uksr/A2dqnfPBW+0O6OYqhXECzLad4inv
	AtDuzjgl1fJr4M9exuPR/9s3PCE6lzxlfoU1FF9LWj4NCI0fmSO0QrlScKbPJXY2kkT5R0
	hnDiL1gNf3Zpz3cmfKpvt+vPzJOkFEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760354021; a=rsa-sha256;
	cv=none;
	b=5bwssNanOmiMGI2MKNGJL2G6qtqEqglid/Vf8oNTmmZJUuu0v1+yCBtnDZmPJrX3Osk3KQ
	oGR06P4vpjU3dRNqsu5MklvX+EOkB78h5L4UNqv5td5kNpVse1snN5Qs06xQOxg1pvkNpN
	Mot3UTFxYCBjJkggHBJuDVFuaTabISE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zhn2AzhV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760354020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XUk2T2O1JALynkNTDXVgTlfmJ0m3TsHCHf1HTqOjalU=;
	b=Zhn2AzhV65yOVEGi+Kl2LKXRGO1ydYheQbwjGeAZbRgP7kOUb5LseYVIkCrl+XA3RKihBd
	W4Fu+9W5NOLZjn+f3/w8kLX+sH7ChkKUvTkK4ua+4MB4kghPZVt2fgER3n62zRLy94edmj
	UMPFoSJnmUrMeZ8KkLAVen5nYJFw8rM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-iVi1TvmqNPifSe1H4Jkp3A-1; Mon, 13 Oct 2025 07:13:37 -0400
X-MC-Unique: iVi1TvmqNPifSe1H4Jkp3A-1
X-Mimecast-MFC-AGG-ID: iVi1TvmqNPifSe1H4Jkp3A_1760354016
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-401dbafbcfaso2899553f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760354016; x=1760958816;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XUk2T2O1JALynkNTDXVgTlfmJ0m3TsHCHf1HTqOjalU=;
        b=CKn+FQUCU7tzc1+aUkjTo02/qbLZJ5LlSo0m3/6hW/08PysQCqJO8Y+RWAw0+IWZDD
         kMy0b8lZkgkeg9THGkAFTGHOQYYy3QRSy/mkOdBkiurRGUGvQJhpae1oHnqhs/2+CAA2
         YXdjUA6lNIFhZYaoeNX4l5wKP/TcWbSpRfWynjUor6NKah0PogjjrSp35bm3yqj9OsjS
         JIsJi4G9KsTLmMJs1YpRDtxw7vC1MgLsO35zP7ysGKt6gKTE6etO4YvCNqbfQ4whLMz+
         cstTm+UtU9LhGYyENIOfnEm1v4dMJdjDyxsU6X6tkK33nONIW3KXdOFfgywdeX1c7Kdc
         XDzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpL3KCT/KHurJVbVvZb6rgFoQHt9Os6mmQ89KRB9FGZJaehY9mQ3oq1JGtCgFb8ppPlNO/SzQdGQ==@kvack.org
X-Gm-Message-State: AOJu0YyYwzl1syI954S9K8j/AjrTsUjNAUvbEwe0QTZf03VloUgedgko
	sbFDUt6q/9gUSR9sZuFoqVVPMtqMo7oI57XWfIKG6JbCZBbDaNcmbIXfqgNgotfkZgJN4LkFOWF
	cG6YbZqSE+FVHnMHc8Ye0nuZrvXAFDpINA7O7KqkVkbvYaV/LYEpe
X-Gm-Gg: ASbGnctArCZ5T3P36QM3xGgPdt3e1Yj9DwKs7BMu56wasGXa8TerVCcMWO2LZ+bpdMH
	mBfmpmSJIrMTo/UgP/EGY80nqx0i1hHTOXJ2XXjlVh0zcvqQFqcTtda14X9zNbUWh3CMw74PKrO
	aG0jfZF18WVo+ATZfbcjt51AuEFuV0iBqS76bjRIN/rQuWFePi1PecB37x9DFCcqcrqtmWKq/bR
	xbizKi2G+C9kP6/iTv4LTNnfU4pAQv182GDuY4tBxWRTyJ9tjGkszqnbTBnKz4EyQe0Vl0WTpHn
	oYHbj+EC9HX/dHqiXMumHqKYX0F4nK2zbtWxJD6tzUdqoVqZ4wkEWj9iLFQLewmljhBlWBJS1ZY
	LGK8=
X-Received: by 2002:a05:6000:1887:b0:3eb:7f7d:aefb with SMTP id ffacd0b85a97d-4266e8de95amr14316186f8f.53.1760354015952;
        Mon, 13 Oct 2025 04:13:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOQfEm07iQajHN7FC2eGJRchtw05CphEkhJOAUM6D7Zv9mdRxcgX3ICCF5NG9k3hni36NFVg==
X-Received: by 2002:a05:6000:1887:b0:3eb:7f7d:aefb with SMTP id ffacd0b85a97d-4266e8de95amr14316170f8f.53.1760354015545;
        Mon, 13 Oct 2025 04:13:35 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e8b31sm17852921f8f.54.2025.10.13.04.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 04:13:34 -0700 (PDT)
Message-ID: <356ec45b-6ec9-4eb4-b5db-ca98964d8f3b@redhat.com>
Date: Mon, 13 Oct 2025 13:13:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
To: Lance Yang <lance.yang@linux.dev>
Cc: Longlong Xia <xialonglong2025@163.com>, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, Miaohe Lin <linmiaohe@huawei.com>, qiuxu.zhuo@intel.com
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
 <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
 <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
 <839b72b8-55dc-4f4e-b1da-6f24ecf9446f@huawei.com>
 <f12dfacb-05dd-4b22-90eb-fcc1a8ed552b@linux.dev>
 <bd374ac3-05a2-41ae-8043-cc3575fb13c0@linux.dev>
 <3e6500dc-723f-4682-9e37-b28bc78a2bdb@redhat.com>
 <c129e522-853e-45c7-a064-34c25e63e610@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c129e522-853e-45c7-a064-34c25e63e610@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1aXqvx2aYmNHV-hbLTLI9AKDgWTQ17ftVnQIV8am-ME_1760354016
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 7x4yznsaii6gm6cf1rcn6t1uz7k8gsh4
X-Rspam-User: 
X-Rspamd-Queue-Id: E34548001F
X-HE-Tag: 1760354020-353801
X-HE-Meta: U2FsdGVkX18MldjryuNpIkjRctsz0kN+9cEGALWxUd2ccAcFZ7KYB0O9dfBHypMB4F/Tsm0OjIBT91byGsJFnIBpmEpU+MK1TLpqtXX5o5j3/+mONk6chT8tFAWUtPQwqH4w4MJ4o6SjlL8cy/iYB8nyxhkp2ueWSmMKC7I6ItwcX2sinCGrEY/TWKb0KjS62Sql8DLWl2uPVv3AGKrzrM4ugDp7gecRFC8W+rVOdmPhTesBP4+6Xr14U0RW1WIA25DKlj+neuM7Q4lKoZ62SM2eQOoncxthNINb18QM5CUbMRRQHQaDUUqz808OLDuE9gN90VzXUGV+wkxxxgZGjmQBvTkepoBp7G3Akd/jy+5quQ1e0fIXbabIb2uaXppI98A2o0Ln4NOYQHOCngDn29OBZ+ppGcE4NFWAFOdQAti2bvoiteYOL1AeHTBG01nfowAZYCVFQuqC3iGqL+fR7njn+qIIeK+lVQGhFNKh93le0/2Uy6BQCnKdKBG0VM6Oa8t1ki8A4Xp4tio37fETzGOaZacV3NAAtCG/S+MjMF8/LtVGxnv12HIHv/5MlzWZ4cW94SGdBl3jfDH5lXwD6X4h3mQhTgSzduwqZhVU2O2njqlszGkSlzkik9n3K7XTgcwPh0UfhNzbA4KltqcCTDKjDIwsSIUF4T9yLzZLifmBiyFBOhk+Hxl3vnngMj2zal5ZyDoTcflhLIfvQDWg4kbtZF60V52gvWdALgZ7HACUmK6X6GbhMOboyn1aWcM/2V0Hx8002On2B4JpD1plnRQY5PzPhAaWkIkD+Brd9rjMrEQ0XdiN9DY6a1QMxrjExpQbUvDshYUJgaSE04vpq3zNgHmIVDt0D7u2yUpWOLBOk+so6JEToBrzA6gM6FZ5xF4Znf8JsNeMeogBmrcCza+ZtyLgHMaAGTxDQQAHbEpMO2a7KL9J2xSgUlBoiMWgw5/pptep83n/ULjPmB9
 uLNuwkza
 R9A8LKT5wiXmvBD1T6Sf3O/LFzo0HZL2ME1zzPuCnSsP72qhDLdY6hKAS1Er3kZm+kFwEbdpg8hdBaGtiaFjSqiKVUSVJf2aWk+fMW4hR7noKmVNkoqEB6uZ6AFmoB8uH8za4g88R3+T7cEturIQ7K/WYazXhU5e9w39NyjFytMcg+k0fzuLl5Gvpen+2PUAtPOLth5E8nqNJHwH5DJ2641SdSYQvKgZf1ANA9VnEWVDKHXrvyIcdevFGQoV7PoyhVu53wLdbCgH6U+d2cmzb3jqStTogYSZFRNNtdc9GoljnlJd7yqhecVs0e5v3HUgsbJHzb+BxqPsKQfGYaXigdIGmWdAHP3Qb7Xf/AFNfkShvANxWMfUSbDSwiJKNnDGQOGMz6yBOfVWyAK7bYpwvFRtEpdCr6fy5y4HoBmn8l7IR3ONKupys/HmT0riXovxcI0bbcW6r7X1pOP8wejY+xf2bzZebmSJ1KDRSPGJWliFXQ0tMMY0s48/ngsEMnMkTFqc/kdO8SFWP0sM+hSrbpFyL7oqjzBFLM6kug3UGsd4zI90=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 13:00, Lance Yang wrote:
> 
> 
> On 2025/10/13 17:25, David Hildenbrand wrote:
>> On 13.10.25 11:15, Lance Yang wrote:
>>> @David
>>>
>>> Cc: MM CORE folks
>>>
>>> On 2025/10/13 12:42, Lance Yang wrote:
>>> [...]
>>>
>>> Cool. Hardware error injection with EINJ was the way to go!
>>>
>>> I just ran some tests on the shared zero page (both regular and huge),
>>> and
>>> found a tricky behavior:
>>>
>>> 1) When a hardware error is injected into the zeropage, the process that
>>> attempts to read from a mapping backed by it is correctly killed with a
>>> SIGBUS.
>>>
>>> 2) However, even after the error is detected, the kernel continues to
>>> install
>>> the known-poisoned zeropage for new anonymous mappings ...
>>>
>>>
>>> For the shared zeropage:
>>> ```
>>> [Mon Oct 13 16:29:02 2025] mce: Uncorrected hardware memory error in
>>> user-access at 29b8cf5000
>>> [Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: Sending SIGBUS to
>>> read_zeropage:13767 due to hardware memory corruption
>>> [Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: recovery action
>>> for already poisoned page: Failed
>>> ```
>>> And for the shared huge zeropage:
>>> ```
>>> [Mon Oct 13 16:35:34 2025] mce: Uncorrected hardware memory error in
>>> user-access at 1e1e00000
>>> [Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: Sending SIGBUS to
>>> read_huge_zerop:13891 due to hardware memory corruption
>>> [Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: recovery action for
>>> already poisoned page: Failed
>>> ```
>>>
>>> Since we've identified an uncorrectable hardware error on such a
>>> critical,
>>> singleton page, should we be doing something more?
>>
>> I mean, regarding the shared zeropage, we could try walking all page
>> tables of all processes and replace it be a fresh shared zeropage.
>>
>> But then, the page might also be used for other things (I/O etc), the
>> shared zeropage is allocated by the architecture, we'd have to make
>> is_zero_pfn() succeed on the old+new page etc ...
>>
>> So a lot of work for little benefit I guess? The question is how often
>> we would see that in practice. I'd assume we'd see it happen on random
>> kernel memory more frequently where we can really just bring down the
>> whole machine.
> 
> Thanks for your thoughts!
> 
> I agree, fixing the regular zeropage is a really mess ...
> 
> But for the huge zeropage, what if we just stop installing it once it's
> poisoned? We could just disable it globally. Something like this:

We now have the static huge zero folio that could silently be used for 
I/O without a reference etc.

So I'm afraid this is all just making corner cases slightly better.

-- 
Cheers

David / dhildenb


