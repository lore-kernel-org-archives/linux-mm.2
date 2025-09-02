Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5E7CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3F18E000A; Tue,  2 Sep 2025 04:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394498E0005; Tue,  2 Sep 2025 04:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C0A8E000A; Tue,  2 Sep 2025 04:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9A78E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:47:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9F0D160B47
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:47:02 +0000 (UTC)
X-FDA: 83843680284.15.45CF40D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3389E18000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:47:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NpYUeevo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756802820; a=rsa-sha256;
	cv=none;
	b=WMqGZrGtRmUuuF6vBTikEe9My0RYFXNnsJhzKS7Nv9tm7LLvAVWUAZwYQRuyla4zHhViZf
	e5pVfto/Fvh2i7Tao6H4aYao+K5bGp4jkdmBd5hNbHQ3mi8MkOuPlIqgfsEvXvtebT/ufW
	EZqWe5o06Udb0JIqbKYaGpXfjNtE4Aw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NpYUeevo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756802820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0ildYJgSjzsvQVF/cS7GkKEO/r15LnxYiCt2Un6VX0=;
	b=zW7I+ieh2/ysNIcVkjx2o+yjGHpfbrIMZGl09KX/QZnBvEXV8rm6WUtK5ckEwvG9NTH6Rr
	HYeYtA9N78rWeOhrEyg2KKUPBuJkGRlARSNzIIbRnsdz7NlnU2SL9XUMh+3fKW26nYb4GW
	N7LWVhoQxlQA7tYWLPayjOiNL3jN4BY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756802819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u0ildYJgSjzsvQVF/cS7GkKEO/r15LnxYiCt2Un6VX0=;
	b=NpYUeevo29eiclQqyOQjoqUFaDBIZMtVq1FuRX8Mu+//8ylh7e6NXoUL9FBKuFxwu5m9rA
	mvXhUQPaqf5v+TPdjxavRcLs1jAZq1OmsnqWFFSxqzEFsIttzeJkdUP0NVRGr3gfEWE2t5
	31YKg80NgDJcwQscYQ315mX31Uzif5I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-HwFfhoIEP6a8EgX70rbtkw-1; Tue, 02 Sep 2025 04:46:56 -0400
X-MC-Unique: HwFfhoIEP6a8EgX70rbtkw-1
X-Mimecast-MFC-AGG-ID: HwFfhoIEP6a8EgX70rbtkw_1756802815
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3d1114879a4so1722909f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802815; x=1757407615;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u0ildYJgSjzsvQVF/cS7GkKEO/r15LnxYiCt2Un6VX0=;
        b=jOj6JxnHLLPmJ1JcEt3XRKAzas5ghI0Xqx+JRLa7wN/iQphA5h/zi6J0X6sefAQkEc
         sNDnikXAc3qJqEUI7Eflgt7hXyuGsKy13gjlKZYxzTE7KXvZ8XnpdIfbskKGNWiByPc/
         Jdd7NzcC1wPUU5Lu4d8EcOO8laFHk/8bW+UNdO95q5YSorsL1BUYf7tcf6joh8jZyGOH
         xXKY+QpSl9WLnvGPio6WDl+PbEtIQ84cRtLIiKHeXRpJV7Paon4jzSswXiAdG70AHxLi
         1UBdGMrn2HhpqCxcVwfZjAqJ0Q7Mh4iWGlNZPP67gHChlAhTjixCZHP5TVr9gKsM9j7T
         DbLg==
X-Forwarded-Encrypted: i=1; AJvYcCUDOq0GBJ9UOtzHyDTyGayrHySWmP4xK0FuXJWj7Qti823H7ix1nbw4ZGsM2RJbfynAl70jWubDLg==@kvack.org
X-Gm-Message-State: AOJu0YwbPZBkamXOpUp1BhcniNgWCjkUkPAlT2qkOQK87MluzepiL5i4
	UZoH2jXPjzUqdhmsq3+6EBgtWL+pGz9IKidSxRzdMWYO9um7N6uDQzRP4aORJHsuwWBbh27ANf1
	EmMTd1mt5rxXbtO7JLyx4vsfyq3liX4I8tMx+qcMJKmPwyaSf3Cl9
X-Gm-Gg: ASbGncsKilFU1/QW41gAHVvq4hOpfiM+baoTiAAvRrTLFxKlL3DmTOHxMVWSwwLEFJp
	SdqTHjtdXNKyMMZuKAUDzeSOcLg59T0BTlL7LB4qINHdgGr+aw5qFKsvx+H1xqm4e5uTkwekFue
	Qj0JlpJStmSNS6RabXVyR0hNwQe1WWaL/Q6JxWYmFNQdOO0IlOdMJsibRwm6b1G221T1fk0mIvI
	NzK6z8tjXo2tUuUUXpImU9rxsm3zMSubGpx045ycbxh6CPzUjsg6zSNpv+QYHY8cPQFiloLamnu
	Ykr0HEfrJrewZ64F3dvIQkBgdQ+Hufjq2HOP3QYbOp6aRWobSGiYexprLHwZb/EvWP3q2AygWUC
	qmQ3GctUZmjuyzDuNBejsvE95VdAL1LpOoFqtW4cv9WQ6RGPHSk2pEavuTnLc1eRxwoQ=
X-Received: by 2002:a05:6000:2408:b0:3d1:61f0:d264 with SMTP id ffacd0b85a97d-3d1e05b8de7mr8709541f8f.54.1756802815271;
        Tue, 02 Sep 2025 01:46:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAxtz/BYe/cYAZtE852NxATwpu55AGTQTFxDVLnuiVmcal5pzbOsGcXV5au5rGMMQW9CWCfw==
X-Received: by 2002:a05:6000:2408:b0:3d1:61f0:d264 with SMTP id ffacd0b85a97d-3d1e05b8de7mr8709512f8f.54.1756802814776;
        Tue, 02 Sep 2025 01:46:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b98c95c77sm11228115e9.7.2025.09.02.01.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:46:54 -0700 (PDT)
Message-ID: <862475d8-5a4f-44c3-9b3f-56319f70192d@redhat.com>
Date: Tue, 2 Sep 2025 10:46:52 +0200
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
References: <20250901135408.5965-1-roypat@amazon.co.uk>
 <20250901145632.28172-1-roypat@amazon.co.uk>
 <CA+EHjTxPfzDk=XmwS0uAtjwsYB829s1uZSMC6x3R6KGQ-SqjtQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+EHjTxPfzDk=XmwS0uAtjwsYB829s1uZSMC6x3R6KGQ-SqjtQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n0zKwvjV35USonMfeD-4hbooArTWv32KWqGFq5Msz-o_1756802815
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3389E18000D
X-Stat-Signature: 15drm9nht7tqpinku5cyzfymqm7itqta
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756802820-940389
X-HE-Meta: U2FsdGVkX19p1NKtRS3q95HcqsFRxZxB0XRrdX3ioKk41nP/4w+wqpgXf4N3nOmRf86Z4n1mxE1W2kbDnLGWuSLT0y4VlxQ2AcSeOmcRr3DFRYUidoovP6JUb8T7QwJfXXH8r0GNdpodd+1i4zvso/d6flpmrIdlb3yqNFUdPGKH/QpCADm+cDQEGPvRj077SSZvbC1EQqygPwCwwORSLnBfxk5yMpaJy3JLg8uActuqQYZpgVBPOn3Ua6eer8EIYwe18dRWxX/tOytyKWxAsGIs+19MUkyzlUqm8u/Zw6OYUFHk30MW/rk38hicyCxw9CsoZxsi8VuETcaxufj0Xm9+XWfiNvnVBT9adrcMHvIdRP0ylsbPEhET3aDUZoOavrMVWlMu/1beyDt9N8YAi7VAjlZbHf1Wbzm6uP0+/IQGM9n7inWO1LimVUR+VSouaCfW3eX0skDRECXojFgeR8W1TQd5Sy2FLuAwUqUEdR9/aEfuB+ls8k0rogqYiWmcDY1qB8Fygw4E/soAYKgUeLhZFTpHY+fgyTV0nIUuBv3FNxeuJ4dozk4ELC1Zxwl8FRjBn23Zc8ZcWilsH6SU0rUgFO2UmNXmJqv39bIVyan2JkmukGuQ+cBsYP1wQxyw+CRzon8Rdif63vIMLZsiWKT7g/WKCqKuH98jhpcyEZOhFwvauHsKaFplEXha8bJ1Lww30/Ft/hxw1n8+Y3mCQNR4uG9VuPq96UHDncfLHrGG0JLvPx065lIWvLFKmxQuR+KP/FUs20bI0mPGO0HFpwkg0JL0zo6SZHmqWkbEsiazjL9wyheZgspxIunsJ6Iu5W2CTdBmt84L1C/89cX1tRnYAarDkPv4AUR3vaHOCZfDuXu0EmVd6EuOoyREaEls1esauy1Ac08SFWGZZrwascdHdAhzgLN4mHZQaBpkKyEyddFIUBcmnzOBaQATlHHwWCYE6EFxIQbMkwlAMtI
 DwCGP3Yy
 R8/f459rPwVwAntOyxXfYytivOFVSzYStQ7/0TvZmFd09KrJT83kYPfpXpbWPc57KCa+PuSHOj+gbo+oHE6sN7ZJILcRgVSInUr53XJ9fgJioTiVmfQjWCGELdZcpy6wA6BaNF9ol76QHFZhf4BjhznKV2+Vobmi0H9nHA+RjoYu/8bIKzaldBAGyIKtIBmKBtbJQ0CwDz81xQCVwS/8V01ygrd+t1eD24KatF+FNVgy1MYWgELUfVCWlM4UmLjhJo7Y1p0oEcJZrgRDkD+21n+2YL2um506wW7fcmZDcFrxQ/cgbJn1KQlHkmZXB2j6wKzEp8BIdbcIDzC1PE6iRfjsC3xVmLsK8ii9xBidrpfeGp8XLxUpvb20aqU4prW29CJk8wimy+QFXG6XZ2id01syyJVM4l+g/0vH+OhWE6kVpgrYIVBWUmi8wOxWozV2dYNStKCKQdr0EZPAUNWKF9cZPfvJkp/uOxh3pGO/zydVzE1kCESPBqSL5sopxHhuU3E0eczZnB6B/jWCXBlIRDDK4vfxvaKUnUEy/pSEKbTN9tOMEpcpaDFAO93cKBoHwFnpqI9VxVqimisc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 09:59, Fuad Tabba wrote:
> Hi Patrick,
> 
> On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
>>
>> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
>>>
>>> Hi Fuad!
>>>
>>> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
>>>> Hi Patrick,
>>>>
>>>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
>>>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>>>>> index 12a12dae727d..b52b28ae4636 100644
>>>>> --- a/include/linux/pagemap.h
>>>>> +++ b/include/linux/pagemap.h
>>>>> @@ -211,6 +211,7 @@ enum mapping_flags {
>>>>>                                     folio contents */
>>>>>          AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
>>>>>          AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>>>>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
>>>>>          /* Bits 16-25 are used for FOLIO_ORDER */
>>>>>          AS_FOLIO_ORDER_BITS = 5,
>>>>>          AS_FOLIO_ORDER_MIN = 16,
>>>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
>>>>>          return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>>>>>   }
>>>>>
>>>>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
>>>>> +{
>>>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
>>>>> +}
>>>>> +
>>>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
>>>>> +{
>>>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
>>>>> +}
>>>>> +
>>>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
>>>>> +{
>>>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
>>>>> +}
>>>>> +
>>>> Any reason vma is const whereas mapping in the function that it calls
>>>> (defined above it) isn't?
>>>
>>> Ah, I cannot say that that was a conscious decision, but rather an artifact of
>>> the code that I looked at for reference when writing these two simply did it
>>> this way.  Are you saying both should be const, or neither (in my mind, both
>>> could be const, but the mapping_*() family of functions further up in this file
>>> dont take const arguments, so I'm a bit unsure now)?
>>
>> Hah, just saw
>> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
>> Guess that means "both should be const" then :D
> 
> I don't have any strong preference regarding which way, as long as
> it's consistent. The thing that should be avoided is having one
> function with a parameter marked as const, pass that parameter (or
> something derived from it), to a non-const function. 

I think the compiler will tell you that that is not ok (and you'd have 
to force-cast the const it away).

Agreed that we should be using const * for these simple getter/test 
functions.

-- 
Cheers

David / dhildenb


