Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACFC6CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD1C8E000D; Tue,  2 Sep 2025 05:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8DC58E0001; Tue,  2 Sep 2025 05:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55728E000D; Tue,  2 Sep 2025 05:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4B408E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:55:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77C3C13B217
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:55:09 +0000 (UTC)
X-FDA: 83843851938.26.ACB477C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21E21C0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:55:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ADsCxEaA;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756806907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4eZCyRyOy/1us8vFre1xbt8cZXKsm7kPVp64LbO26As=;
	b=ArTNbgFzm3tv3eFT3VExGNTHaVmz4Wqf5SVx7DS9rpbFZbGJs05V3ZdUan1JP1zbHicUt8
	eYd/l20EeY+XlcHP8lmJWWzWAEPPTDDXFyfC/UNCsOAap23n0ijylaExmqeiyEodgl/UUD
	DUaRmszLwVL/JmQ+U0sMdZSE1dkBOQY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ADsCxEaA;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756806907; a=rsa-sha256;
	cv=none;
	b=3lyoUXEtVdFOW1+6rRRymXr8A1UBw8sFG2BxiIvpTHdI5ftSPGi31BeLn1DVdIi/2sNxEd
	fMwi3Y6A4TQ8oNIpY+8knnTgwRgBryoxUlLDlOrdC6FoBEOSQMK7MxnxdYpbrmp2WChxxn
	HW+AzST9BYzEIjzoCWn1o7yWC6ugZ/Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756806906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4eZCyRyOy/1us8vFre1xbt8cZXKsm7kPVp64LbO26As=;
	b=ADsCxEaAn5p/Dz291aOUbCCSsbERcplYeGKTcsSQZC8fsABJZVL+VJoDw+36yacmb5XVQ5
	3tpKBhhfY/PWeq80WvQbnRMDGQYrKSgu2PKLt4ZjQE/WWtztnei6bTdru4I0xCIfMYALK8
	czaZmtNztPtBUMuy3HWHxa5R9z2376I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-nVZIBGTiOwOAt-6noXXf0g-1; Tue, 02 Sep 2025 05:55:03 -0400
X-MC-Unique: nVZIBGTiOwOAt-6noXXf0g-1
X-Mimecast-MFC-AGG-ID: nVZIBGTiOwOAt-6noXXf0g_1756806902
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b87609663so14345165e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756806902; x=1757411702;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4eZCyRyOy/1us8vFre1xbt8cZXKsm7kPVp64LbO26As=;
        b=iU7rvGejbto0NWZfrAoRXCz3R2DJfbvjQD1CcMXlCRvPxOO1Oj7dT+9wB+VUFgRKrX
         wCSo0MCtqg32jZAJEO30/iAGyehcFlHYaV3sNfVFQL+xE+c7g3ZvRz3koqKSn5XzsopY
         7ia7ymacVp3FhJr08cOQmvgCsTyZZPRL+d3KVA5HplrdI/8pbCJGOqs0F4FMvX1yOEUj
         a2asfQJBwP9mgr3a1K5baoCyLNkRe09zEmATc3nAHk5Vy3g241mCFgwnig6ALgSE14Vq
         J8ZoCLtx88WPK+zXvg6/FnvLeYXUBvZsb88f31P1uY0CvQiBasvSejAyUrgzoO24bNIW
         wNGA==
X-Forwarded-Encrypted: i=1; AJvYcCWahApXNWiSe3PBUcZyUr4gjNJTnwWWbS3ll1VdFvzji96vJ1MWjZV0g1SrQpPDmUm0GlLV0TlaWQ==@kvack.org
X-Gm-Message-State: AOJu0YybKcAJ2xyQHSmwY49j/8umE6dZAqG0cr05rsEZy82TqLO+KNBq
	G/VP6kVwzo93l47oduJkqKLKk5Llikm/An7gaCS4vTM0WVhSmj4eeX2LlfiKSRfd6JSQXlYbw2M
	Ts7t8PoUGzvyVKkOzbiSu9o9/zRSf6oGeY/0VhLzHjSWHJfkSZt15
X-Gm-Gg: ASbGncuCfS6bnr3+JHsOWmc5x/OWLV2nYq+I19URLnzcsGxrgD17suMRJVUUUoaWCGH
	F3mi4Dz6yi1UxccOGURIk9bYthFnAMRJwUPalLu+jR1464vKJGPuwjmCv8ym2aXUU79f1MUWYi1
	sYW/+MpCc4s7IsXiTivOdd/Jx3AzsEuzvBVMbyqqFiS/MNyw0PdNV75TYKyeiYZagKbMlbLrayl
	d5H/rWm816C2gOmBfrRyy3VHnnG+HZinuSbZ8nW+U5gXBSvAmUlpXxVctf0D8W533O0MWyydJst
	/EKK+zDVWVx9qyhxmngamHpzY2/hHYIVmsAtBmYXCcj9LoAsXVsVmbukYuNs6jToiET2bzvDdAM
	0LaSOFQ6+6dMAPr5g6DEzmVXBscb97FJsZXLOSBWYjlNP6U7qShcRB0GCnvSg0ibWRks=
X-Received: by 2002:a05:600c:4f45:b0:45b:8b3e:9f66 with SMTP id 5b1f17b1804b1-45b8b3ea168mr63251125e9.13.1756806902112;
        Tue, 02 Sep 2025 02:55:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGw9JfwtwC068M3a+d86/hOvR7JxhwCiBJFNzquGsYRrqR/k0m99Ht4VzLz8N6zCOBMmSesxg==
X-Received: by 2002:a05:600c:4f45:b0:45b:8b3e:9f66 with SMTP id 5b1f17b1804b1-45b8b3ea168mr63250885e9.13.1756806901601;
        Tue, 02 Sep 2025 02:55:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d2393sm190896135e9.3.2025.09.02.02.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 02:55:01 -0700 (PDT)
Message-ID: <8f571dc9-f2d4-46c2-a4b4-6854fa31da2e@redhat.com>
Date: Tue, 2 Sep 2025 11:54:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: Fuad Tabba <tabba@google.com>, "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
 <jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "will@kernel.org" <will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
References: <CA+EHjTxymfya75KdOrUsSUhtfmxe180DedhJpLQAGeCjsum_nw@mail.gmail.com>
 <20250902091810.4854-1-roypat@amazon.co.uk>
 <CA+EHjTz1JxOy=E3p=So2q+k=UK3cDG6C8gOUgA9NQEpqRdhW5g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+EHjTz1JxOy=E3p=So2q+k=UK3cDG6C8gOUgA9NQEpqRdhW5g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oZzFaX_nt-dXhNw6OQ4prHYyVLos7yjEaQPuy06PmHs_1756806902
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 21E21C0009
X-Stat-Signature: 9z4nhnh9rqtej49pyznikt8bhhuoqptm
X-Rspam-User: 
X-HE-Tag: 1756806906-727762
X-HE-Meta: U2FsdGVkX1/rMemFVeX09f0iNtiStP0FaBdRsiAr/pAXx42GVJ0CCzS+O8sSM6KyuyfkqWPQJdhAulFqAlVei+M9+JFoEOeLu5hU71pWjooGxWly+iOm0cF7rhNXczHPmeG8TrZMU1Ib2cx1EGNZ7//6RKkbAi7juFD8sT4qoqaV1aKJHocntP970FQnhFlfVgqL1YB5+ceLPtO74giNFBX8WemSGXPKslwNoiLzbXy0KvmXoP3b1GBlUKQQ75X4wdQZcPXB75HvS2AagXS481YW2qYqWwhKt++2fTrT1rSFHwEhSCOLpTxKaYhaKH3hot7ugTLlx+651XVPece433a1hOrPFVuQ8clQdUo3vY2iyM+ycCDshI97mzbMMsn2QN2pUGKXCbo1G/260I/J84hdRrUaFN8ip49OKLF/MFe2a7+SG8M1//1DrCsXB8XBNqvFsaH2APNPWV+6ssJptEpD6uNguQIetcupuvuVCoHR2nu0JbkrX1kVAERx9SxXgQbZDrqLQGWPiD+a5ibZEbqd9rGrxUrw7W/Ij3ZbBwB1WP/dZPEMJIVVENVYgdXWH+PFf2p8SQbb3nK+2kDZrzL05AqM8uEEWesCrN+9+OX4f9r33OGyZ78ZhFAJmYG5XSYEteCbfCLNMDagmF7a4SmFV4IlZOeadrlES5KNQ4ZoheLFK1MZM+jfrqp+g0EK0M3KB8MafmvZpd+dTdjgSC1CQlvJcxBUccopAMKcxyjciC8OfKPTgckJtwwvMUwPrPGKdmL/Bb42OF2CmLPTZ8FB/k/1NiBzeRa58w1lz2J2yN5/0FWwmTG6tc2nAYOK6IrkCg9EGU1DfVftdpeKFo8+RXegJlzI/ub0S+J8T6k5G1JDbg0+u07fUZSnkzLOBW4nUYpxZmh1OIE7j3evYCuS/5DBs4K4Amz1ugU+rJ34Ikrr/J+d37CxljdbbzykOvIBirY8owdnPjlo324
 8h4aPFNM
 GBBqIulxgiO/tXv1lMbMAKR2rFyfeSzKALPCvG/l54tzWcV7D3eSFTjONM8faK60ur6V/kqcJ63NhFlgZIk8Aw9BFh82v9kMRsyyzihLfC8CTfSw6uiuUTQaPENpO5kJDcgPA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 11:21, Fuad Tabba wrote:
> On Tue, 2 Sept 2025 at 10:18, Roy, Patrick <roypat@amazon.co.uk> wrote:
>>
>> On Tue, 2025-09-02 at 09:50 +0100, Fuad Tabba wrote:
>>> On Tue, 2 Sept 2025 at 09:46, David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 02.09.25 09:59, Fuad Tabba wrote:
>>>>> Hi Patrick,
>>>>>
>>>>> On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
>>>>>>
>>>>>> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
>>>>>>>
>>>>>>> Hi Fuad!
>>>>>>>
>>>>>>> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
>>>>>>>> Hi Patrick,
>>>>>>>>
>>>>>>>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
>>>>>>>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>>>>>>>>> index 12a12dae727d..b52b28ae4636 100644
>>>>>>>>> --- a/include/linux/pagemap.h
>>>>>>>>> +++ b/include/linux/pagemap.h
>>>>>>>>> @@ -211,6 +211,7 @@ enum mapping_flags {
>>>>>>>>>                                      folio contents */
>>>>>>>>>           AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
>>>>>>>>>           AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>>>>>>>>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
>>>>>>>>>           /* Bits 16-25 are used for FOLIO_ORDER */
>>>>>>>>>           AS_FOLIO_ORDER_BITS = 5,
>>>>>>>>>           AS_FOLIO_ORDER_MIN = 16,
>>>>>>>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
>>>>>>>>>           return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>>>>>>>>>    }
>>>>>>>>>
>>>>>>>>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
>>>>>>>>> +{
>>>>>>>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
>>>>>>>>> +{
>>>>>>>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
>>>>>>>>> +{
>>>>>>>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>> Any reason vma is const whereas mapping in the function that it calls
>>>>>>>> (defined above it) isn't?
>>>>>>>
>>>>>>> Ah, I cannot say that that was a conscious decision, but rather an artifact of
>>>>>>> the code that I looked at for reference when writing these two simply did it
>>>>>>> this way.  Are you saying both should be const, or neither (in my mind, both
>>>>>>> could be const, but the mapping_*() family of functions further up in this file
>>>>>>> dont take const arguments, so I'm a bit unsure now)?
>>>>>>
>>>>>> Hah, just saw
>>>>>> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
>>>>>> Guess that means "both should be const" then :D
>>>>>
>>>>> I don't have any strong preference regarding which way, as long as
>>>>> it's consistent. The thing that should be avoided is having one
>>>>> function with a parameter marked as const, pass that parameter (or
>>>>> something derived from it), to a non-const function.
>>>>
>>>> I think the compiler will tell you that that is not ok (and you'd have
>>>> to force-cast the const it away).
>>>
>>> Not for the scenario I'm worried about. The compiler didn't complain
>>> about this (from this patch):
>>>
>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
>>> +{
>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
>>> +}
>>> +
>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
>>> +{
>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
>>> +}
>>>
>>> vma_is_no_direct_map() takes a const, but mapping_no_direct_map()
>>> doesn't. For now, mapping_no_direct_map() doesn't modify anything. But
>>> it could, and the compiler wouldn't complain.
>>
>> Wouldn't this only be a problem if vma->vm_file->f_mapping was a 'const struct
>> address_space *const'? I thought const-ness doesn't leak into pointers (e.g.
>> even above, vma_is_no_direct_map isn't allowed to make vma point at something
>> else, but it could modify the pointed-to vm_area_struct).
> 
> That's the thing, constness checks don't carry over to pointers within
> a struct, but a person reading the code would assume that a function
> with a parameter marked as const wouldn't modify anything related to
> that parameter.

Ah, thanks, I forgot that detail, it's only for embedded structs but not 
pointers.

I wonder if something (sparse?) could detect such cases.

-- 
Cheers

David / dhildenb


