Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0DBBCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 13:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456516B0006; Fri, 12 Sep 2025 09:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406B16B0012; Fri, 12 Sep 2025 09:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE286B0028; Fri, 12 Sep 2025 09:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1665E6B0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:32:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7F331A082A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:32:51 +0000 (UTC)
X-FDA: 83880688542.12.8A00480
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 023EA100022
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:32:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I5gR+3MH;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757683969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3WySasVKe/ME+w6oNrrZ2gd9OipXbQaPkCZGsmbrHU=;
	b=cuy42nVLg9G/IoZ0s1+fQlF8QJ5bd2aNajJa25pd72A7CRKKpMyV20FF6q7q4KoHtbYTMr
	jXrfOlaLoySsL6xyjfXJfowmRrTjbdY1X9wUNz6ZfKIiwlpppAkB3vp/zXE50BjbkEbe+4
	dpVC/FrDM6iWEhKvRUuPoGUhjGVpDI0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I5gR+3MH;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757683969; a=rsa-sha256;
	cv=none;
	b=LiQsh9WgtaIWk4P+OpkuqjP8xaeujejKfBt48LbY7YNTE3P9+/oKXugz5hPYaNvpemPhUs
	FYLkpYGDzO89JnIoNsLfxJOMRMbZgjYJHG+/90l03yfHMX3m78VGhAsWTR56/TpdJrTL3c
	cJIbgPRto+OGk5YfUOTIJZtindxPVBY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757683968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=d3WySasVKe/ME+w6oNrrZ2gd9OipXbQaPkCZGsmbrHU=;
	b=I5gR+3MHYpI2ZLnWkoa+8Yfwz4pqse3fgAH82lrz9ZENAI7ADcujH4bQWiW+H9EFjnQY8B
	55RQiKXzJkM6Ii6o6LKM02HAN0GE5q4t/ngs7bD/BJaw81pumUC7LzLkaU5K1iMEQm8+BJ
	/sK3vTmthYvPpokB7jMsm0Q0lFhxwxs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-FYJsuwYYPOKaR4js_NFEsA-1; Fri, 12 Sep 2025 09:32:46 -0400
X-MC-Unique: FYJsuwYYPOKaR4js_NFEsA-1
X-Mimecast-MFC-AGG-ID: FYJsuwYYPOKaR4js_NFEsA_1757683965
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3d3d2472b92so1138853f8f.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757683965; x=1758288765;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d3WySasVKe/ME+w6oNrrZ2gd9OipXbQaPkCZGsmbrHU=;
        b=kVMJxeL0hsxNuCPzB6AkWwbNRTqBJT/m6CCNw5lIbAg+nA0xuKKfVqKuhhXRT5UqQw
         et8EcRLDH48IIM6Ai2OC+54XtY0ChSk4rgycBw5e2oe3EWiNO3WD67W8RCZ+dYvtTNLn
         ZQZmib8VicvmzMmZ4RM883OP75hw5jHEnl1QDO068thG2M1en2HOeZwlof/lLtXXpmmX
         eMTnZK0XZbXYcPhLDI64t/BMSBC/s8OPAGaOHnABQmqB8ZeetUbFYM9mpv6i1a+buWi0
         lzhhdlYONcoStxIy2CbbEDB+/gBMMI4dAYf2h6EWBIWn0InI0eNpiNaUziUrkWJy5KVR
         ujlw==
X-Forwarded-Encrypted: i=1; AJvYcCXHCA3WkMWixSClT7DqiIHM3XuRBXkjotMJ/lDqK3WsmMwDnsibDUkq1C/Vke3nzYhzeZ3C/R//qg==@kvack.org
X-Gm-Message-State: AOJu0YwJNLtuaOWt3XoMvhVqMO8Z1E7e4Be2gjGCSPMc3yaQ0zwIGBuI
	jKEdYacNjWVq7Dca6bFjFlzXm44xxSBZ59fM0rEiNoOut+uiiW11s/2f/epSsPEN9lPbwpz8oie
	VDZpuc4D7m8yUza7sNCfd8on2M7Oor3mWVJXkySoFOTtLLAbvY0wW
X-Gm-Gg: ASbGncsdtv7CoCiWc2iqS2DFOlbKoGNDiiS9WwQ88XCRdDVB0qTJc0qVHQvLbt4uaux
	MLdvhrKg0K2zO03RfW/W00MBRghvPHFXw80qVzxAcXlQAKFgyE7xTbspMal+7jhF3+UHIm7hFxw
	PjlJ/cjd4aCN9qJED7jwiCB5NShFACHiiHaXvaXbos8+gEHoNQXHzMzePuZ/vBa8n7bWcJWQzTW
	Z1mk5uH2jFNt94SJ71WXGufYJVSpzMCm97DHRVFdbqW1h3s59Vq1YzSXunFG9cFgnDx7BBywm0P
	zK7W6gj7nV9O8C+rtxCEtjiOGpMsrx6bUoVOf9CHYqkwwEOdsJGv+umzccjxlU2VDsVei1rRZBS
	sxi8+1TpwVnn+0MEzRF90ccxr4uLlGlYwENvVXtXRO8UnaeDrYdRd0ahKrGLMrA8mDZM=
X-Received: by 2002:a05:6000:2584:b0:3d2:208c:45aa with SMTP id ffacd0b85a97d-3e7659eb4damr2923117f8f.29.1757683965354;
        Fri, 12 Sep 2025 06:32:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQvIA7aWaWPgRmM3ibF4CzK7cagNHsOvK16zCwCwknz8tuIMHPgwLUmt6YVpOJeww1hCUbMg==
X-Received: by 2002:a05:6000:2584:b0:3d2:208c:45aa with SMTP id ffacd0b85a97d-3e7659eb4damr2923086f8f.29.1757683964875;
        Fri, 12 Sep 2025 06:32:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760786ceasm6793014f8f.16.2025.09.12.06.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 06:32:44 -0700 (PDT)
Message-ID: <b2334e92-9d04-4d27-aac1-fec91d5ee464@redhat.com>
Date: Fri, 12 Sep 2025 15:32:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/5] mm: softdirty: Add pgtable_soft_dirty_supported()
To: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Deepak Gupta <debug@rivosinc.com>,
 Ved Shanbhogue <ved@rivosinc.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>
References: <20250911095602.1130290-1-zhangchunyan@iscas.ac.cn>
 <20250911095602.1130290-2-zhangchunyan@iscas.ac.cn>
 <9bcaf3ec-c0a1-4ca5-87aa-f84e297d1e42@redhat.com>
 <CAAfSe-sAru+FuhVWRa+i5_sj6m4318pLFrgP0Gsd0DVWzjE-hg@mail.gmail.com>
 <04d2d781-fd5e-4778-b042-d4dbeb8c5d49@redhat.com>
 <CAAfSe-tQgmBm=RS2gCi7VaRW1XZhS_sJ9rHbvqJ0w=KwTf+m3g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAAfSe-tQgmBm=RS2gCi7VaRW1XZhS_sJ9rHbvqJ0w=KwTf+m3g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H_BkOOs7mLgiTE53tvWmrI1eQZ41mphwm-2KS7sUHbU_1757683965
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 023EA100022
X-Stat-Signature: qnpgiq1m5pphbn3wd8gbr61arbqdh5kw
X-HE-Tag: 1757683968-940402
X-HE-Meta: U2FsdGVkX18PO5HiL3KdrR1exFRKn9aWWkT6tH/uMuCglyy3X+6GQwzi+VcSFi/1bwDI0XeQd8iNMVMLvk8V4qCv6W0ZN8JRJCfk9RJHtP2FHEjv/vPz9ovs5v5YctOgWx7BC9LWVTJm494/sfufCoPuA+GzeercKPKeS5VmoEn1/ab2I1f9LWexn4f/OuIoip6CpLkNV7/uWWli0ZOtd33Ub48KkjzLj9ghevDAJ8UTd5wj2iett86Msbs1DFvY+a4xB5oQCEon/vy/xIJsBDgN/Tw5U6xzP6uNc1ryu2McKLWgXc2Z4w/i/Q1kSPE6mh8OGW6hbBMNFOZzdjhGS/NfKsSt4dcZeQWT44nSG38E1SLV5UNOwA3yesWOie2UGSyVdvEizZncKlPbwI0hdrUVZNl4FzkDxRtHlfQBHZHlTycT0QLNw2plyU3wUBV/XsUsAEFI7Vxy0bFRJgjRzgQZVWBiK74E6u8nb/sqE2Q0pzmTfh8mnZg4iYl8aYhRtVkyIH0fjIxx7I5saN6uwuh0hvU4yy2OcuwqklFB+cnkTVXVJ2PjnJG3sQkw/Ppb208lYgc3AwAFVHaKgfupqOUOrgXU1jxgJw2QcAg3y4Aeqj5QtDfPrnyAOQkBtH7xk1Pa/G9H0vx2UjL0CgviGZ+eOGaXPmW0W/cGqHqTiHueNk64U2UGdo2Vcctkqq6wCcw87BeZgTMK3BgfJckh0TQohAl48L62vOHQtkrJOkpVoNaOdNGENltt9kxXdKm8zL62uLgZT7plun2KG+Uk9LQuMRvTK2qCU0yzY77i+JPCt7rT4UlkUlk9HynbHh8W3A5avFNXHqMcXQX21doYKemi+9wld2K3nzHWa4RfZ074taMJGADVUr09Jpn/1JArH3+2TLIaCRGHX7feMn7Uqxkr5ijGEBxyHI4dkWkVKQE0/j9CswWhcUNcoCm5FmVaFwmY/In2pBX3jRnwQAR
 xerh84Ju
 hPYEA+WYivHXbI1Vx/oR1aN0nyQL36NurrPhNWnNECS/HEUOetTV5VFDuZuxc2Ac0xEo53bQ3KMnR9M3QlvbD9rXgI+G9cFsFJzjHqurKGrZWQwU9QkF0aTkpfRfDuX32r8vHfrxVX3khMkGBUF58LW2ffmZGVJDGk3cm9kSIP1rDSkbA5cjn0YQz6J8nmn4hMPqTsUvWgw3VQvnRmcF5PL3oKXnXzp8lSKg0nBrwGKjR7g4vTm099W+ysV4Q6K6zsp/1LkTjw/3QDgwSYiWHrRzIlikaajB32Nm902RYeziJUBnrqpU6JlRidWjl28pmRfD/bhVOu8VWJe8NtnFHzLJRSu+uN1i7bg71P8nQ4t2+2au5/JAgmG8NLw745dsUKIJj6/NFjcDlx/5wFKoAbnivK+50xAP38mqb1+Un3iuit6E/x0MzH5qgEOvb11nPBsMMhMubX/5f9JBl/EHI27XPV+7+5c+HVQWUOCEkCVY4u+2/OPRZNIMCdVa/Cx/Hqss6V8YAnx25QaVNMsG4rPb8U+KIEyl0jFaz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 11:21, Chunyan Zhang wrote:
> On Fri, 12 Sept 2025 at 16:41, David Hildenbrand <david@redhat.com> wrote:
>>
>> [...]
>>
>>>>> +/*
>>>>> + * We should remove the VM_SOFTDIRTY flag if the soft-dirty bit is
>>>>> + * unavailable on which the kernel is running, even if the architecture
>>>>> + * provides the resource and soft-dirty is compiled in.
>>>>> + */
>>>>> +#ifdef CONFIG_MEM_SOFT_DIRTY
>>>>> +     if (!pgtable_soft_dirty_supported())
>>>>> +             mnemonics[ilog2(VM_SOFTDIRTY)][0] = 0;
>>>>> +#endif
>>>>
>>>> You can now drop the ifdef.
>>>
>>> Ok, you mean define VM_SOFTDIRTY 0x08000000 no matter if
>>> MEM_SOFT_DIRTY is compiled in, right?
>>>
>>> Then I need memcpy() to set mnemonics[ilog2(VM_SOFTDIRTY)] here.
>>
>> The whole hunk will not be required when we make sure VM_SOFTDIRTY never
>> gets set, correct?
> 
> Oh no, this hunk code does not set vmflag.
> The mnemonics[ilog2(VM_SOFTDIRTY)] is for show_smap_vma_flags(),
> something like below:
> # cat /proc/1/smaps
> 5555605c7000-555560680000 r-xp 00000000 fe:00 19
>    /bin/busybox
> ...
> VmFlags: rd ex mr mw me sd
> 
> 'sd' is for soft-dirty
> 
> I think this is still needed, right?

If nobody sets VM_SOFTDIRTY in vma->vm_flags, then we will never print it.

So you can just leave the "#ifdef CONFIG_MEM_SOFT_DIRTY" as is to handle 
the VM_SOFTDIRTY=0 case.

So you should not have to change anything in show_smap_vma_flags().

[...]

>>>> That should be handled with the above never-set-VM_SOFTDIRTY.
>>>
>>> We don't need to check if (!pgtable_soft_dirty_supported()) if I
>>> understand correctly.
>> Hm, let me think about that. No, I think this has to stay as the comment
>> says, so this case here is special.
> 
> I will cook a new version and then we can discuss further based on the
> new patch.


Sounds good!


-- 
Cheers

David / dhildenb


