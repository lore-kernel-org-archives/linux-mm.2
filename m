Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27662CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733A78E000B; Tue, 30 Sep 2025 05:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AD28E0002; Tue, 30 Sep 2025 05:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9DF8E000B; Tue, 30 Sep 2025 05:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 489318E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:44:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E56845A0F0
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:44:25 +0000 (UTC)
X-FDA: 83945431290.14.1291A34
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9CDDD80012
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:44:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QxqMD+Op;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759225463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTKsiV+MwvU3A+CTYo66BfK7kCyj0E0ejJPRqjGwaM0=;
	b=7dfL1lX2qS8AdWQTp54+tNjttLXEeJGl6hSPkKjnut8QXoJJP8FgBQSWJTTjZsAjJppaMC
	D16OwDUvCJWqKaUr9rmcjQW0jplaE8+wNPQ7EnvPUBFP8W00ZVyumyutu2RkYphcvCl4C8
	N3WGFmNtEvq8C1tO176rrbFQDOskKpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759225463; a=rsa-sha256;
	cv=none;
	b=iE+sTce7yTNJ4Hd6kU0uANOrBzqyVdekH7kes49bge2nTF1E+qW+yTpEO6bbskbktO9U/k
	FqpnASmZ+oOPjrUayRI8K4D4L7y5FT2hbfGGdPPo8LyMQGtXzAEQrkKq1ouoalYYmtpJmB
	efOo1L/1nhaT0/UmgG2A0ukDwu6sOgs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QxqMD+Op;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759225463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zTKsiV+MwvU3A+CTYo66BfK7kCyj0E0ejJPRqjGwaM0=;
	b=QxqMD+Oprfw4BtJnfBt3q7dgduxV2IPZIVtbRykd0Vo0/A9vXpuvSW0HdcFx6GGlBIQ6mK
	vtmSmzcUTcBSRVVMGLGBhQlUomk44r8anQ3LiWd4Kzznmcit+iuiUlHtD1BTpta05tKTU0
	5Vp2sK7Ah7il+2YroFI0STqNLJbOXVo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253--Xp129NdNWSMu5EQV9T3QQ-1; Tue, 30 Sep 2025 05:44:21 -0400
X-MC-Unique: -Xp129NdNWSMu5EQV9T3QQ-1
X-Mimecast-MFC-AGG-ID: -Xp129NdNWSMu5EQV9T3QQ_1759225460
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f44000639fso4236824f8f.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759225460; x=1759830260;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zTKsiV+MwvU3A+CTYo66BfK7kCyj0E0ejJPRqjGwaM0=;
        b=w5NXACK+XwCpyTJT5tgkk0+qBQAApp3wmgSq8UNglmkdEDIb/DB74mhTcFghpwaYVf
         l5f8owzJgWh87DWNJqzk4TWRWflBD+9SxGLch1NPkGimrgKWCVNY3skUUW/CLyhzCDsl
         RuB1+E9vb4LggItiG6F+NBJ59uddR0N49iUI8AkpZTBDJgwhKeGlKLUkI+h42QuwankF
         2yRCgec+RRSPhye9hk+xWTFaOemb2s4QweR5BlmH1ULT+ZJv7mnI+gq41rxNP+G3OCBp
         YqYOzzCVDjaw0V6PdRw9Ugk0kfPlzryvMf7NjqLP0LtrckUJiaHRNTDS5bLrnesY7+3c
         hrTg==
X-Forwarded-Encrypted: i=1; AJvYcCWEBbly3jlwqLEdOapsjuMzDmqdc0h/2UVv5674LvvzS3IyERExoZAEl4pYAezVujll67P0ddYzxQ==@kvack.org
X-Gm-Message-State: AOJu0YzRz9+e969asmFd0f+t7FzZ8fW6hXiVPhOGBh7LFloJZWsPO/Xx
	NimA4SkZ5/OqmyMS2HNIFI1g3zTsmbVBMnsmPJP9SavkfHFTU1R8Ud03ajfrkJ7+VSECbpKYkdy
	mz/Cor3GuMnAgMx57qZPz32XLRHH4jo/qHhyWmVzGux1WkWtXC0k+
X-Gm-Gg: ASbGncsIoOE3oe29AVLbrmFPPKSQMFJb3FPTZAeVA9tJjDUkfGiwanQ6mTmASQt9zvz
	QJF+l4xIvdiogvE1CO5ppO7Fek2Mrh+lpzV5SLqoSKdWlQlfQc8wSemAPcqGoVmeszxbgyNEg1F
	fg6HCqJ0UB1tJQPkJETsuE7nHNvDO4EYw6STrIjvHLD/1Wih3q1Ouj4852DLjTYSMnQeO2BfOvv
	ihdzO2OS89zgsVG6kSPIHeV8nIXxarhZK2hSzqlXEx4I8lpx57XQva84Hb4+Zebuj/8ClJA4VKX
	B/0VJ1XKhFgfEJLxqwKhehtEAgp/EN20jLGWgptD5ANflimc8W0LGeZcE/BZdMtNa/B3e2uwPNM
	LKgHvDyzB
X-Received: by 2002:a5d:5f45:0:b0:3ea:a496:9ba8 with SMTP id ffacd0b85a97d-40e480ca410mr18059626f8f.29.1759225460270;
        Tue, 30 Sep 2025 02:44:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+VXBV2ldPpYoazSy8gSggmZyFPsDv2dwFEenIOlqVRHhIY/sSwP8s9VAR+ET95zAfD7AiAw==
X-Received: by 2002:a5d:5f45:0:b0:3ea:a496:9ba8 with SMTP id ffacd0b85a97d-40e480ca410mr18059594f8f.29.1759225459801;
        Tue, 30 Sep 2025 02:44:19 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb711sm21683292f8f.11.2025.09.30.02.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 02:44:19 -0700 (PDT)
Message-ID: <c1cf2254-2449-48b4-b1db-0d92595567df@redhat.com>
Date: Tue, 30 Sep 2025 11:44:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/16] mm/highmem: introduce clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-12-ankur.a.arora@oracle.com>
 <6626d497-4c27-4263-9be1-1c05d2672019@redhat.com> <87ecrwewn3.fsf@oracle.com>
 <4e061f4f-cd57-4df4-a001-9eba80d1ded9@redhat.com> <877bxnayrc.fsf@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <877bxnayrc.fsf@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wa6eFOWzsY08wXNTRmadg2wnGdVM6U9jnx0L3WCE8JA_1759225460
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CDDD80012
X-Stat-Signature: 3a3713onac9q95ib1mch7bsn4xkdn9q7
X-Rspam-User: 
X-HE-Tag: 1759225463-695655
X-HE-Meta: U2FsdGVkX19E0EvUNsWENDM3dS766l4lBpbvI2ZRxj7M80sjuxiZjamCOEKl6NVxJew+kS1cfJIb28xIqFKYLf+zwu551dhK9AT3NPVUK6c4WeP9FEO2bg0Zr38dPvqxq77kHl/SgAPJtG7Tvk5LCtMnCjNRjvYV7QHOnWWcETFr0YwT/m//KnndCi4j1OueNL7Q+EQ44uPbNYk6IhPS1B4DDs5X4acj3SC18YlPzQHCbz2VThJGh7Lypj6o8+P0qtCzHhWJcEnrFDZhmmQdl22p9bQZMuCZ/J0YOwIB2mW2QSBKyVetURNtJa6ZBEUXmWf2w71mJ4WzgZlWqJCiyeNxDK4zg8D9zR8vTqvixyC8+vOQNBdK1sB5t8WNew5S0/8iplxn2jYdKVGfPMJLzAfixeVHEgUuM00JgUTyy3mk8KGkUloWlrI3450bK/p+kBO5hi7rQgt7DP9XldpDq8rdYp+ITHEIxvlZi+vwlSm9KC4Pxj523yRp06J9A0DAXbFNQ8hKPuVlXpNjOIpf5CotX2ldZ2LbOsYDPxoRBXhJ0b2yGfmm3NxCgArR1LiSFLWlXsuJev+ZDKpk8IkZ6xfkJ9a2pk2ztxHErY65aPqlxbKNTMY7ZroYavrdyI1z2qXNvIwa/XDf+7AiLat89Qg1as+xDnng9q3DzteMIXtj3qtNciFMqRlMpy39+LG4AuZIuAE6nysvEcQ9rld4koWjMuC6DECz+YHJehYcRTd2UIxB5ntUBd3A9ywFd7883lZ9uYLyYCKzNaaZmVmYo4q44LOJj4GD5gLZXagpzdBveBUC14UmlaIVPgbAcoBf23GTwowGDB960VYDKSfGOLuOTPPKRCIVGqE5sNv3NvOZ2cL8qZsTME1A9RMs5Vgv4sE3sNMgwhWQfdkIcbqKg5ShKp8FvGC0WfVqp4cIaaSnCbe94RN8jWUFBfxLUfnV1riN/8uDVBi+25g/PLB
 SoAbcf1L
 KORI7o/dv8LtoxkcARJj7mtKTkTqwctnQUkD6mv3NtgP9ckJpFuXwVTKsm5tEQU71wLElAJxr/GhH4UAsw7xdQsWW09d6Zyj0xe7x+LX/R/wdaqBdOGgZfj3bQ+nC2WkhWXX4hn1ZGMPUkxJ7OegKgT25AlLKEzXCY1R+B8bZjPLPdYVe1SvtdNn4tZ0QwsRtSOyVyGSgHPqlK4UXC+EFY0rtkQLbXXmv0r+Vc2qLwxq/926wIiGCfDvQojRAP0ZwV8U038IggrA83L16PoBpvW2tTKU7V4rQ1L+FTTtl1A89uXOV2jWJZbm/2uD26FsJJI2434Xv6Ij33Ysc85AYqWDAYAz4kP7DMl7NpOeUy2MrLwfbXdX/9v4Oikxg8VEho/YjhCzno7/AjULE7qmCnOjdqwLxXaWDFlJiNfZVH+fUuS4oply0nELVBhUqGKYFCAHSXCmZvqXjeHy/kCle6qrozkmrtU5goL5ytDQ0yqQm5tNcuAG10mFb+IHTXPqEzRMf/X1N+WwbuK0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 07:26, Ankur Arora wrote:
> 
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 23.09.25 22:34, Ankur Arora wrote:
>>> David Hildenbrand <david@redhat.com> writes:
>>>
>>>> On 17.09.25 17:24, Ankur Arora wrote:
>>>>> Define clear_user_highpages() which clears pages sequentially using
>>>>> the single page variant.
>>>>> With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
>>>>> primitive clear_user_pages().
>>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>>> ---
>>>>>     include/linux/highmem.h | 18 ++++++++++++++++++
>>>>>     1 file changed, 18 insertions(+)
>>>>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>>>>> index 6234f316468c..ed609987e24d 100644
>>>>> --- a/include/linux/highmem.h
>>>>> +++ b/include/linux/highmem.h
>>>>> @@ -207,6 +207,24 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>>>>>     }
>>>>>     #endif
>>>>>     +#ifndef clear_user_highpages
>>>>
>>>> Maybe we can add a simple kernel doc that points at the doc of clear_user_pages,
>>>> but makes it clear that this for pages that might reside in highmem.
>>> Didn't add one because clear_user_highpage() didn't have one. Will add
>>> for both.
>>>
>>
>> Doesn't have to be excessive. But even I have to keep reminding myself when to
>> use clear_page(), clear_user_page(), clear_user_highpage() ...
> 
> And now all the multi-page variants. Really motivates the removal of
> the HIGHMEM stuff.

:) I'm afraid it will stick around for a couple of years to come.

-- 
Cheers

David / dhildenb


