Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1782CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 19:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418FF8E000A; Thu,  4 Sep 2025 15:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2468E0003; Thu,  4 Sep 2025 15:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A6D8E000A; Thu,  4 Sep 2025 15:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F18E8E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:02:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E083B8A53
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:02:38 +0000 (UTC)
X-FDA: 83852489196.10.6FF058A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50BF51C0008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:02:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YAp9xXlK;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757012556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YWDZyeF0BbjxRVALgIyy2T6Wp2Aa5vTrXwhQeMo3Hq8=;
	b=1zg8IlK0Py/e4ECAjtM4JCjUc3w5Fs9ZjudnGlj9IUpqm1K5cVJn74Ooi6dSlam/eX9Mj8
	f66PUPk8fb5MBYZlaVbmSIfNjhm91hr1Spdj4GLQrVd30zzILZ5xSJMUE4NIv0BNNdgLq/
	4bfpwWKuLTIhbnSCSZ1Iazrm3YypwPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757012556; a=rsa-sha256;
	cv=none;
	b=ZszdQGISMCwANMxDHVa8Zi/LuAv53wwPQGlopSnhhtxCjVfPcv3MA4di/z+s8zFjWt2M3m
	ILDOGz8nOCwHx16L5auQORpSuPTLR4yrOLsMMsXm90Rd8RUAcjhre+bbzT3jp04L+rThPS
	3F79FOU9n3b4gzUgaMXTx9NsEwjEgwI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YAp9xXlK;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757012555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YWDZyeF0BbjxRVALgIyy2T6Wp2Aa5vTrXwhQeMo3Hq8=;
	b=YAp9xXlKxcAHDTwMAAftiq38llqquqykK/c6AuvcGEsBl98l87qUgIFrCmhv6i0wmZmuC6
	KBP/0s/FU/lJFwmc8q8ZET46obB3OniEQ4waSRbeZDwaR/JADljfauXSMqgwuCB0JhQDHP
	cCs60xgCVaDVvWjeN06fz2jIdA+baUg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-vQlE3iprMwa_7ioh66DzUg-1; Thu, 04 Sep 2025 15:02:34 -0400
X-MC-Unique: vQlE3iprMwa_7ioh66DzUg-1
X-Mimecast-MFC-AGG-ID: vQlE3iprMwa_7ioh66DzUg_1757012553
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b80aecb97so12034865e9.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 12:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757012553; x=1757617353;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YWDZyeF0BbjxRVALgIyy2T6Wp2Aa5vTrXwhQeMo3Hq8=;
        b=oNjnw+j3crQHYzyrI8eNQxnKv2rbxZTCXzVntHOvQr69xHk9R+5n1udpKlK5uVkWxj
         HI8fI+tTiqd5en9qgS1k1EXpCkzVEnMoprY98FsQuxFa9zSKBVnmQ7c3vdfUUmzs7ohT
         r3hal850NVvt9/KE7jB6nXvsxBvW0mduQAXcD5RXTwsMuTklOYScxycE7ps9oIPeZHJ1
         wL5l0QFbeyG1KFa3sUXSLkJRZPb6j49RELFlzDLspfCfOUsiYop641dvl9V5Ajq/nZnY
         8fOsrZNn+G0q/jjtqN1XPyQa+GNDnWayvLRjETGKlytTWvCW7BDsOWb1A0wbGKwXcZLo
         TA2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUN1yzjHfzyXY86vJyyFaet1zrbwROdSXr93UYL1OwQg19rDM0laGi9koeAA8x/3Ahr0aYgoLRiTA==@kvack.org
X-Gm-Message-State: AOJu0YysIW0N4Yrtjvvn1D563Qt0NrLRuAn2wVxAHdxwzg+MOmXm3Sv8
	prCRWEhAVnSAMR6jDL2hQRWtX3SZaDv9iaT5idcY3OyWvnfUGCstpBOOtPtl2Bh2fAewp2clP6H
	bl5XUxAx3QhiRsYgXM5JAfSCsdjOXGjJRNJ2mDgqAzUaQ/vFseJ55
X-Gm-Gg: ASbGncuXScQnH9Hr+/3D1y/TSY6md5HNwAuGvhSTC4Jeoi2Q9FblLA1bBS/aFzzpGxz
	dBh7BXHVAEKqkemYzzCZfx7JTP6LINZsWkmXbqKmg/ohLSNm1EHyF23O8krjzi6WnfvIghjccXO
	BbjzHo/AZumMhUp4v2qo/4GGqggdWhW9Df2um7jiinlG3Ok16y/LAMVdLlMJn+93QTdINIALY/6
	UY16Kco92WwAUFsf5hwVYl1Tk/AXmwDV9RLC+q+QKJSfazNgxSB/3GxnK3mVtjvo0ykWZRIBQlO
	vuNTbVztRMc1wnrWR2DHnCUZ6KTBT6vKE7gYgDy/Eor777FKGj1lkg++k++IeY1RUw4htJr4AM1
	Cu0lFu43CsgOiAWc7LmQnSlXTnGNmYD774YUozKD600hRIDPwYio1MYkI1R5fJzxw
X-Received: by 2002:a05:600c:c87:b0:45b:9912:9f1e with SMTP id 5b1f17b1804b1-45b99732e41mr94535545e9.3.1757012553199;
        Thu, 04 Sep 2025 12:02:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHO6hTNkTOa99PCxfFMSEdvMjsQNm8Z6EmDgjkyJrk1Q282hJMJh5qxS9ISP4s9BH1ZtQpyFA==
X-Received: by 2002:a05:600c:c87:b0:45b:9912:9f1e with SMTP id 5b1f17b1804b1-45b99732e41mr94535145e9.3.1757012552638;
        Thu, 04 Sep 2025 12:02:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9ab7c7dbsm118390555e9.11.2025.09.04.12.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 12:02:31 -0700 (PDT)
Message-ID: <8e1881b8-3867-4cea-b03e-50c05ed8148d@redhat.com>
Date: Thu, 4 Sep 2025 21:02:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Kalesh Singh <kaleshsingh@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
 minchan@kernel.org, kernel-team@android.com, android-mm@google.com,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
 <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
 <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
 <84aad392-3bff-4f98-b612-5e9a046edb36@redhat.com>
 <CAC_TJvc=5=iS8gCumJWqH5eF4XufFSogqtWHJmiH5WBN1A6gng@mail.gmail.com>
 <4chxl7uxr4exy2z2dcshxla3c5nzzo2tbnelsbbky7pdzrih6a@hzfnpbenfmub>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4chxl7uxr4exy2z2dcshxla3c5nzzo2tbnelsbbky7pdzrih6a@hzfnpbenfmub>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DUQk8KwrI5aEAMyIZE7Ksg6S04fCSUkal6qGOMq50Tg_1757012553
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50BF51C0008
X-Stat-Signature: myj4mhipwtyrfmc1xo7fobqho8cuazuu
X-HE-Tag: 1757012556-249821
X-HE-Meta: U2FsdGVkX19cCp2cLTjjNnGu9XJzztQE36rV61JuOGafUt7cHH8oiAeU4zEU+zLwFmA9iCDeotGE9nLm/BKmZd03MZ70JCHrr10e89g7ETx0WhyOp0opzetBGZte3p9uKdnhh86yKKvoPHuNAzrW9YiB6aHtjuLnG8z6qipauLgfp9UZsFfnWTmgrWGbtHakJb2WvLOWP3exQnSfp9cNzAxz2JTilenl/3vtsQ/DxWjwFScFM1K3ijyGUgXx0Q8rhDTqQ16RNBYxBb8arWV5/szia67A+QGHOl6oLwRk70T3XYcN39ErL5UBXn6eEcL38jeakMQkqf7nwdmKQGe3C0QVz1FAv+8QxBfPY0MYhb52dkRMZSdO0zphfjHI4ZsuCYHXV4nu7F6bRe6qDzQlox+naM0v/fb9u/iReNW5kqxzzHIQUgvS8o2tg8VVBT3hjToR3V1kTx/GL/ZOHKbvwQr9i6ZyQOnEuCabicFXly3kE6K/UnPm/f3Lc6T37AWONN7hj62w0iUHIh6E3Z/1D20wDudNZ5rDaHT9OM56+F5v8sX98J7nqsdWKDepDkKr4vNrTdQHPdXyCuppHJAUWuLYAlO/uLiMl4d5++Twc0WOeh1VEzgqzjvQ413c/SVp6eUIryDdAvpx7tJTZWRWm/YIzMyFmvd2WdRekm1r+yWnfh3MqFsDF0ALzYEgfX4dzmTrlDrivBrtcfpwOavdD+UC5tjkO7HjxIH7uw3gvnWKGpFiUp/yXi3N1dv/dmSzVfOLKMAGJ68QG+caTVyGTO1MhSinuh0hBK+KIIbiggJHhwT43MCDSe2xgTJZJ4jdIl1dNspXEVGmbtMbduxxwn+aCTAMAFmCA2VCG4im5MVSP3eQzqKA5g8DAhnyFfmF+f/93j9haUIp9vjSXdWtGxSbWvw1SRM0hu1KHzNrd5kqB38AbEFecC5LvLm+Lhl0F15IHFBTPvbQFYXQsvg
 qkYpZfKz
 o7fyp6W/kq08PQI4Yu4v6yfs17n73voVYps+ZBXFO90GJRM5Yf3FAv6IULeQHChzaH1zIDbPiDMZma/P8EBcaAS5JnzMHGS2shhTBfmahk1ANe4ytwzrUUJphA1No5SFk7BrG0w2wZu4Rs54y/mPmsorr/EviMY9xs4X+SHI1wV8t6adCuoe+GGB103SoKZTgc6Cygf0V5P/oHuCD5IABR7ztkK32Ne2ZkA33NFmfbwAC07eJ/zqCqvH+g7SfixvtQPAVcSUUwWTXF9ggjVP4M2+8M0V5n4TB1R15JWGmPNyFh1j+ul3hEZPdcQciIw0Q60H2/6JooLnVEZYVF0wGUwx1dfVwfhyXogalIDiLjJ8Kc4RAHcj1bYb552Y/ST5ANyx1e8Ndj+/W/5SV91KxF9mKbLRu81V0vTuSaU3xsfz/bUlH9GZAFAsIMa6uyZusM1ouHTx24/rimRMsNte+JkX2Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 20:49, Liam R. Howlett wrote:
> * Kalesh Singh <kaleshsingh@google.com> [250904 13:51]:
>> On Thu, Sep 4, 2025 at 10:42 AM David Hildenbrand <david@redhat.com> wrote:
>>>
>>> On 04.09.25 19:33, Lorenzo Stoakes wrote:
>>>> On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
>>>>>>> diff --git a/mm/mremap.c b/mm/mremap.c
>>>>>>> index e618a706aff5..793fad58302c 100644
>>>>>>> --- a/mm/mremap.c
>>>>>>> +++ b/mm/mremap.c
>>>>>>> @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
>>>>>>>      * We'd prefer to avoid failure later on in do_munmap:
>>>>>>>      * which may split one vma into three before unmapping.
>>>>>>>      */
>>>>>>> -  if (current->mm->map_count >= sysctl_max_map_count - 3)
>>>>>>> +  if (exceeds_max_map_count(current->mm, 4))
>>>>>>>             return -ENOMEM;
>>>>>>
>>>>>> In my version this would be:
>>>>>>
>>>>>>      if (map_count_capacity(current->mm) < 4)
>>>>>>              return -ENOMEM;
>>>>>>
>>>>>
>>>>> Someone could write map_count_capacity(current->mm) <= 4 and reintroduce
>>>>> what this is trying to solve.  And with the way it is written in this
>>>>> patch, someone could pass in the wrong number.
>>>>
>>>> Right, but I think 'capacity' is pretty clear here, if the caller does something
>>>> silly then that's on them...
>>>>
>>>>>
>>>>> I'm not sure this is worth doing.  There are places we allow the count
>>>>> to go higher.
>>>>
>>>> ...But yeah, it's kinda borderline as to how useful this is.
>>>>
>>>> I _do_ however like the 'put map count in one place statically' rather than
>>>> having a global, so a minimal version of this could be to just have a helper
>>>> function that gets the sysctl_max_map_count, e.g.:
>>>>
>>>> if (current->mm->mmap_count >= max_map_count() - 3)
>>>
>>> I enjoy seeing sysctl_max_map_count hidden. But map_count_capacity() is
>>> even more readable, so I like it.
>>>
>>> I don't complete like the "capacity" term, but I cannot think of
>>> something better right now. Maybe something around "free" or
>>> "remaining", not sure.
>>>
>>> I also don't completely like "map_count" (I know, I know, we call it
>>> like that in structures), because it reminds me of the mapcount ...
>>> talking somehow about "vmas" would be quite clear.
>>
>> Thanks David, my original implementation started with vma_limit() :).
>> Maybe something like vma_count_remaining() ?
> 
> Yes, reducing this confusion would very much be helpful.  In fact, if
> you put it in its own function we could change the actual name with
> lower impact.  map_count vs mapcount is annoying.
> 
> vma_headroom() ?
> additional_vma_space() ?

VMA space might be interpreted as VA space.

I think basing it on "vma_count" would be good.

vma_count_capacity()

vma_count_headroom()

vma_count_remaining()

vma_count_avail()

vma_count_left()

> 
> Maybe David would like:
> remedy_vma_space() which would be !poison_vma_space().. that's pretty
> clear.. :)

:D Careful, sensitive topic; I know that Lorenzo is still crying about 
this late at night when nobody watches, screaming "DAVID, WHYYYYYYY" ;)

-- 
Cheers

David / dhildenb


