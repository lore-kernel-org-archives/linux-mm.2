Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BA7CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EED48E0009; Thu,  4 Sep 2025 13:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F298E0006; Thu,  4 Sep 2025 13:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166568E0009; Thu,  4 Sep 2025 13:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 011748E0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:42:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 941275864D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:42:05 +0000 (UTC)
X-FDA: 83852286210.13.7ED452C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 237C62000B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:42:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bpD7tNdp;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757007723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3N6crPoAdBKvfRXAZf0tsFM2t5csRFa36K9pgtReHE=;
	b=xXteI2rR2bV5rgXS6oWlCNQp9RWjx2RDS2qicJDR/2I3QRH21wC4RbFitQKFm2AgrF2dtF
	wQpbm49k36hRGMgy3aXSEGf1bkRz2zNRar3fI4OD5vQytuQT6iOygtZSuN1g7w4e9NgKLI
	IgUpstxmMvJ58DjLzKHg4bOb55ezukw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757007723; a=rsa-sha256;
	cv=none;
	b=xBl5rKw3dng4l9Wi0cMPumdH0BnqHaJONbbM+9GA40TSH3IIvnuLo0E7s/zA+AG+32e5ix
	3f/2X159ftqBreWP/wb2qV4Sx7DBgdbqtln/0XUGAtrQrGiewOrdQiM29PmJGB1PsyHg4o
	iztrS82sNbH/yGhfp4XkniDeUtr7T/Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bpD7tNdp;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757007722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f3N6crPoAdBKvfRXAZf0tsFM2t5csRFa36K9pgtReHE=;
	b=bpD7tNdpbvD/unRkJmZqn5ZfHZJnVwlBxG6RLrR6uKQDkMPRZVe+sxJRiQ4833ZJDUiIsN
	IC85BoER4pX/Ll2H103nUSJFiKpvFwnDSV+5wgw2f0hPSAw6g4mu5qwHAvtfx2uwPMRUPo
	GrvLyJ/PzOrvQna+TNVNRZzZyfQ9JCg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-bruQaP8hNwukk4fmXJqo7g-1; Thu, 04 Sep 2025 13:41:59 -0400
X-MC-Unique: bruQaP8hNwukk4fmXJqo7g-1
X-Mimecast-MFC-AGG-ID: bruQaP8hNwukk4fmXJqo7g_1757007719
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e014bf8ebfso837278f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 10:41:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757007718; x=1757612518;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f3N6crPoAdBKvfRXAZf0tsFM2t5csRFa36K9pgtReHE=;
        b=G7TzyO006DOaFMqOY8hiU+czvuwA2NXAWHFi5/vL5z2+xuJz4x+LiLDA81yPQ7NMmX
         41s8vcKjj4m60ZwXveq3r3mIVl3U+23ifwGZVcWhnkxrK8T8RS9Tl76M29HN3aKCgfNS
         9opY3kZlmRuJhL/VndXOLtNhSeeyZoh+Xpn7+EVMEXe1rVMbq3066q3hZXTObTHzN5vS
         GLL4EbHkoqYNEXgxbpG5tm19kXMJcw/P4W3frnaYirqity6qKjPbNcjrCMg/Qrr2ZDrt
         8xsdUTS1x59a9F4MjdR+foL2Em5ZjWQNcL/iay0nXQh86FN+U6LHzKjRyawd/0reI9QU
         rHJA==
X-Forwarded-Encrypted: i=1; AJvYcCWFIUDJi1lKik5WvDLE7t+aevP0OiK89QvhW3+DPXSCXX+4wemPZApShbNmOaR3HBxgc73t8+TnOg==@kvack.org
X-Gm-Message-State: AOJu0YyADJcRDb4WoqnlBJ6QfCcPksiS45EWLCzpVkx4FDf+7RqNM3hV
	EFRo7ZxHl+5soRiXcrAttNV0hIX/oByb4RctRB0UUH02Lh91wPeFs2Hwq/0g63VmurozsmODnM4
	p5rIPRLGslLdjCvB+Pa/u4nXtoHkW/s+7+E2Pw2Uo8vR/+DL5jCKb
X-Gm-Gg: ASbGncu14cOB4MWhWxvUatPOcopFjgqZpQL8nJtE+Os9LWdhJ2YGRQSsSjZGLiYjrJ9
	oU0xUBzudO0W9tHPcnuLQ5J7Z01nVt/1E+QzvLzoPElP3O2QPyy9yAwEYaaub4Rcn5gBR5ma2sC
	EVMES1kAF2R6g6yn/tW2EgiOKmvu0bPdQk9D2ika/ri4qnrT9KM7WErLTywcDltYSDlibkYJw92
	CIk8CCmvFhIto7Xa41uaX0+rtqACWupGKLORJEoKywgiU/uU2H5WdbYw8YdjB5t1WdlSGnOg+MF
	Bwx4+Y7mcrrLGpJrhe1Pk0aH+qotLmY8SHTzeTXidebXrICdGwNSzyqbyCBZstCfnEpsmja+Yz8
	bhYvtT5KUdejEV/fbkhkSKJgWXckwSryRWXE4kBE9DuQD5xOT2rEp18g0uVRJkA7x
X-Received: by 2002:a05:6000:40da:b0:3d1:8458:cfcc with SMTP id ffacd0b85a97d-3e303ac3113mr462784f8f.25.1757007718527;
        Thu, 04 Sep 2025 10:41:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhWxQ1e1FnlVyPFce58Z4egeuSg2pUvGK0fSYueuygdNQHvj/viR3FYzF08UC1nbW9K9KX5w==
X-Received: by 2002:a05:6000:40da:b0:3d1:8458:cfcc with SMTP id ffacd0b85a97d-3e303ac3113mr462756f8f.25.1757007718024;
        Thu, 04 Sep 2025 10:41:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fc3fasm27988583f8f.5.2025.09.04.10.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 10:41:57 -0700 (PDT)
Message-ID: <84aad392-3bff-4f98-b612-5e9a046edb36@redhat.com>
Date: Thu, 4 Sep 2025 19:41:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, kernel-team@android.com, android-mm@google.com,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
 <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
 <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LIkfT_73wFsfOH2IvWx7Ui-IHmfiACI2pUYC1NcXvug_1757007719
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 237C62000B
X-Stat-Signature: 1ueoma1dgyqma5cxzhzbmqns8umj5pam
X-HE-Tag: 1757007722-111144
X-HE-Meta: U2FsdGVkX1+aBBQk0e1V8BwBkfKFXETZprvd5Z3OmbVpbonVJniwj3b2NGqOddugQhB25xSFIJazS8VSw7tTlKU1C8fuy8qVMPqmrAxdWLW8K9sDOk3njRmFOP6SUrsRdDIvje+4seHCaaZHGuXZ8mm3v+9H1RAQd6ny6aghp2JQbF6l9gf4jHDg883+Z6Kciv9RpiSs6EIVcZ6VjOeyxt90EgNsSwTcv2ZxP5AQJSeJECnLJEWs+DLRgz7ZocikyHQ5l84Dldaf7/rIIuF8Q4pHBfsSv3/i/gDOlxf0fQSAthQTqiQcb+kdTS8kEvddBCSjaTHI04f3F5ZHon0lONB83s0/oj8dVqDCFP8raSlFY+2ZE+KU+3px10CwvRW+PCD3Yx9EGjDKFqZs+rCARjy4x0EqotdgiF4M0iIB+ISSGoNYfoGfQVTm67Ou1H19OmvU1ucpbfnHvdaFv5gkH+rO0IxmtMwj8OFIL+/Cnr7+EXIvWEoizXf6XDIsApi1n7IEvvJbpWeszIq6PhQxe8qUw2FtVmEgTBjo5P1VigY33Q+sl87IZ18WdgmObHosL7acSc/u1rD9UdVI/ljitq0K1rI7/cIiEIIG+lwjHTGH3l5M9Li0pulyrXDBtIpQuG7+wX4e+PM4DZr3bHrB8fVtY6ViSLKEreofma2/m8mpvEX0aKAWl/wk9TmJe1wKYI5qAMxWLSixzyFz3BGqb/6t9cPWk1jIlgSYOWLw67rHazszeD/FvvFhqt3NQPgGOgzPhpVoYbqnPVOh73gAJU9bmzgow+uK9TxKg2hpBTNqPaMpjOk/dEs3CMZWlfOWjH0Ln2yK4d4AqxUGNI/+1mtiMW1zER+L3UC5ZwMWqJk6G8OX8Ir/oeLADi6WC7TvpEyUc+pd8828S780a2uoeU/LaVip5VRazWxf/122ISKH7jexYp6uBn0DWfDOybPAqKwLDi23U/nHQWvfgOk
 UYCQiui3
 sxATw2ar0v/dv5irJSHWaq0TV/b0V7zg+silk5mvQFfBjoxAdxh5HrIm4dQu+1Rysu/XFzFxffDQ+xn9bKdxh1VI0gVpLlweFn8qaNcVfyPDNBdN7HXM9X4FZqW7UjmcpPg2VDCO6jTZsEEtcx3VENHmJi2bVi0CyEvH+vsvylcCpxoN1jUY5qAoFFoOgtg+4ldtcR608uopNfbpwAzD/+pO0fOxba0GnLRmkRA6tJ2G490F4Mik0fLGUDV7auO07QXYYe6ISCGI9LcFE0ypo7qSE5VMcElow3xshMK62ZzBm7VeYYA0OjYc1VCKpHJIdJbcDochuP/BdyVWhN5kr/aDxDWY3iBFLLuVVJDqqvfLbmiHRpxIjihNC07Rlj1bubEGzuMlgZNXNekrKWUL19z+48r31PO7OOUY9j3Kvy4UQ3LUUTNsZU/hBug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 19:33, Lorenzo Stoakes wrote:
> On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
>>>> diff --git a/mm/mremap.c b/mm/mremap.c
>>>> index e618a706aff5..793fad58302c 100644
>>>> --- a/mm/mremap.c
>>>> +++ b/mm/mremap.c
>>>> @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
>>>>   	 * We'd prefer to avoid failure later on in do_munmap:
>>>>   	 * which may split one vma into three before unmapping.
>>>>   	 */
>>>> -	if (current->mm->map_count >= sysctl_max_map_count - 3)
>>>> +	if (exceeds_max_map_count(current->mm, 4))
>>>>   		return -ENOMEM;
>>>
>>> In my version this would be:
>>>
>>> 	if (map_count_capacity(current->mm) < 4)
>>> 		return -ENOMEM;
>>>
>>
>> Someone could write map_count_capacity(current->mm) <= 4 and reintroduce
>> what this is trying to solve.  And with the way it is written in this
>> patch, someone could pass in the wrong number.
> 
> Right, but I think 'capacity' is pretty clear here, if the caller does something
> silly then that's on them...
> 
>>
>> I'm not sure this is worth doing.  There are places we allow the count
>> to go higher.
> 
> ...But yeah, it's kinda borderline as to how useful this is.
> 
> I _do_ however like the 'put map count in one place statically' rather than
> having a global, so a minimal version of this could be to just have a helper
> function that gets the sysctl_max_map_count, e.g.:
> 
> if (current->mm->mmap_count >= max_map_count() - 3)

I enjoy seeing sysctl_max_map_count hidden. But map_count_capacity() is 
even more readable, so I like it.

I don't complete like the "capacity" term, but I cannot think of 
something better right now. Maybe something around "free" or 
"remaining", not sure.

I also don't completely like "map_count" (I know, I know, we call it 
like that in structures), because it reminds me of the mapcount ... 
talking somehow about "vmas" would be quite clear.

Anyhow, just as an inspiration my 2 cents ...

-- 
Cheers

David / dhildenb


