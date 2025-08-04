Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593ADC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 09:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D729C6B0092; Mon,  4 Aug 2025 05:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD146B0093; Mon,  4 Aug 2025 05:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3716B0095; Mon,  4 Aug 2025 05:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A87566B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:54:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52E491A1053
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:54:07 +0000 (UTC)
X-FDA: 83738614134.09.D5C64CD
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id C4AA740005
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:54:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aCK4jXwl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754301245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bSo3E/6bQlnKLRKGBJ3CbHQxibx0gycUwYvf86x+SNY=;
	b=ohHhXW8IyZV8l8PoND2deUSOLrORuDGZNwQzGUtEjQNaWJIyoqjjBSdMdAc91KZfCO2Uy+
	IPRA13ztYIj5NwBMjNpj9TlOzSt4DbrNlmx7qy/LPG1zRPhkak5ya7ueTTayJn4HBYyL9u
	6FWyxgykZJlnmsx4cW1Zwhl0EKtvquQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754301245; a=rsa-sha256;
	cv=none;
	b=rRC7U9U6YUYhAnSyrSxlohI9o9D7b16dRbQgoAvpw7Y6FsZHFQTq8kB5vXwaoC9ZQlyNs0
	hXyIspqXxy0XfQwLTYEQSgjRttEUcG6XaFXTZWPLpsrMIq0Oq9SvVYP7nr8meQfX048SO4
	W4PVWih8/32jwTk0lsmLvoR3IPTU1xI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aCK4jXwl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4aeea691687so35440081cf.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 02:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754301244; x=1754906044; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSo3E/6bQlnKLRKGBJ3CbHQxibx0gycUwYvf86x+SNY=;
        b=aCK4jXwlygVajPHQTjiRys5v8OBvtY65h1N8wA/GEoXSWc1E+an/msr1SGanscuD4e
         LoK9gNUlRuHXdV/6fnC5J2LQuD03iymjpFe1v8tT6ZhCMwuQ9v7b+kiDFSWicB9NTH5J
         592KBQedjLYbXdOFEJND1wPdDkVah8K8Hv5CX9vdih2OBDXCOmz2M6bTiUQNeujsKgn3
         vYDwm1Flb0B4JcxRQM8Wkge+I8elaLIxBbpJAl0j7qzD+1VTZ1zgBPrbWtlZGumrFhq6
         laG54DC/u/Z7LroZc6wIXfGgMmaGXvi+kgvT6wIujGNzO4PdzThT3bGh8MqCgDV+s8pj
         s9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754301244; x=1754906044;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bSo3E/6bQlnKLRKGBJ3CbHQxibx0gycUwYvf86x+SNY=;
        b=arkV5Wfn/K/KZaxD7na5dq+uQT2d7m7mwXbkmH8wKGhEBGQc0Osb8s8vVRKrxXYDBu
         krQJ0GfwMOzwdVdNmff8eBSLfynvGF7zY7GYqfB48AkvtVdJfNBU0uuyHvQilDrLFnsM
         zDQy0LJPlcePHzqeY6YK6v1dK3adt6uNGlYnzkGGX01OpLd+ojFRPtIMzhSY0ALJ1LgF
         vfSA9wJd2KyM/sh/XtIKG+DJJUEvh6u7cO1P4G74jWlKS25c3wUMZjrITPRT1DZaO9Zj
         TCgEIhMJmdaJR8mpny3XY41N0iw1Ln6QFyvp8lM73qs6qoDJtO1woNpXoIXNG9ESVPVJ
         M/sg==
X-Forwarded-Encrypted: i=1; AJvYcCUeQxuxqtBtSUfgijf/XV7GCxZ/IV5Ryx5hHYVopdq8bN4MPamQGQ07n2mA1GaIfD+eVEf/QDjyTA==@kvack.org
X-Gm-Message-State: AOJu0YyqpfewTRxmghzWHkWWK/cXQDicBAZhqWRvfBQzQQxu7RqXRAso
	fEQZ+kPe+rOZy+XeDHNRsda6emUe8GOheULxjFossuM4YmUOmTXNV5LzlagoqhJJ//k=
X-Gm-Gg: ASbGncvXiD8z2IxBODTgNoZrgAZqAYOmzdh1wvmIog4vwi+kpAlrUkn5isn0RQdJO86
	qm/be7rcXfQrYfJ28CYO/BOCbVVrHbMuF1Sii8zKN+ei7axYY6QlR26Uc36FtPXbYNyDc9QNjFD
	C46BGA46koW5yFmSFunyGeW2H2Y4K+Y34rVbcG7SDkn4mMnrAU5bRzaxCNhioQvxbV/vafDiBLS
	u1rWIpapS2CzKJzYo4sgukaR1IwiXoHj5apMKb3tzU/bo9RUMVuIVDTJEE2m9LbAgRU8j+DJ+21
	JkcaG5u8cfLJdOkUSGcZGKPF4pvNnxgRXowYKdfnYGa1X8CoegftJCa7i2Z/CmUTXcp3hrnBmJV
	9lz2g4meT2aaGd92EQjO9jJeY2607oTUMRgXGEQGZl6uiYg==
X-Google-Smtp-Source: AGHT+IHZ1UdeUoGikf0DmtLNqfIwKAfak4BWKnOryeLRT18SeWreS93dBj4uPC7kn3VpVZP6pAlboA==
X-Received: by 2002:ac8:5a54:0:b0:4af:fee:bb01 with SMTP id d75a77b69052e-4af10a4a5aamr107018941cf.32.1754301243600;
        Mon, 04 Aug 2025 02:54:03 -0700 (PDT)
Received: from [10.68.122.90] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4af0c7b1d08sm30846901cf.3.2025.08.04.02.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 02:54:03 -0700 (PDT)
Message-ID: <ca86203d-89b5-4282-b318-2ac82fd2121f@bytedance.com>
Date: Mon, 4 Aug 2025 17:52:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <v-songbaohua@oppo.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 yi1.lai@intel.com, "Lai, Yi" <yi1.lai@linux.intel.com>
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
 <4fa8f492-c7ef-451c-8dc7-38b031c8a092@bytedance.com>
 <d9d0890e-2837-49dc-9ca8-1d6c28e95a21@redhat.com>
 <aJB0Kdc6cx1lGkdb@ly-workstation>
 <CAGsJ_4yw4Qn7OWmUJeJZYuOHLjJ7L8kov3Th3vFPa3h4y0ur_A@mail.gmail.com>
 <7d92ec18-ff8e-4929-8b9a-f0bf5c6d249f@bytedance.com>
In-Reply-To: <7d92ec18-ff8e-4929-8b9a-f0bf5c6d249f@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4AA740005
X-Stat-Signature: no5zaxi9yowwf3jq4zakq1o97h5wraiz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754301244-920472
X-HE-Meta: U2FsdGVkX19s+avyDJ3eXfnGup9pZlNHXbJpy2oBEW00vqwC8gMHsWjbZv55dkuUwlU4RLE8IAdewA39QedWOSt80RrNVUHwpkP9vohSCtca2/A9MH3Lriq4WyiXy2spyQWjv8k1hDSAoqZMNitjLgoGq8IfIA794xcQxlJBdy5geHRbOSYQ7LIUXmMhGXNxWPFcnCTGi0ebFT6Q+MBP4ohpGWXj1iMMn1Prv5wBJEtnA2XHmY8yfnmyf/eyj1H5YDMpsWaclM+3WbRtw3pK193h3IgKHUq508MxQAnvfYU7EeyqBEGny3tG2xDrqYTOOYyojXhrQ1G+KI7UzXJHf/hOaLOQxGE2wx4tYpxQexQiR+KuszorcSx9VaJf6lp0MKyZbQc7VZvxC2HONMiz6XJMRKmkVww9TTRbBquIA9oX5smvxI3+LBbbO8AoCEZzsyVn1S+oOq4Odnxos40EbKYNKzIxUHmznnlYMfW2FpdCEFdDPKyZavXWcgtgCXtiHWMC64jA9eleCD0ZAYrStPudADudWJmv77ANPXc8GmljEFlEwSlr7dojphjKyCMAYFoy2guHpGVHINOouAzEkM4fZ3agHsYTJ7NPTYPtjjtHnrt2Vv5MRQWEDxOMN50VDD1BGDu0gu1LEyN8grEoGp+NxaKiaipvuA9P/x1cBjrR/qsr4ZF3LybikpTdfrMc/hTr7yIK6qTbOpEDd9XqDFhmbSKJrMb7uM1OCUjy7hQJ6iBe5V0T+466subpRH7i4TcYrPY7OWW4d9zxaevdAscBBFfFUxwV2WOKhIsBRGxR1o5e3d70FXbboJFy37CTCiOIZCvlMEyROlDNcV7Gz3VGm+B8eLwvmC8S5rNPeRnv5eCzjA4+NY3HUVJHMEm5hvO6TIxmEzAybZKIbP8+y8VvrW04kJAoCoMkR4kMe5dHmseDFBZAo4oeu/yVFTq+G8JB/wLVhLqhh3vMsfg
 PQ9NL+K9
 XWs1hP9o2greaoIaXynwcIiQzgTfyI/OIHqzzsdc08mfeue5aIZ0UiuJF0n3jGuKXtAXK0XkWlGqirCDbnIt3Xf/Pt+v0eTiGFrrdsQ+ENgUbMo9o4JvuLS2+jDT9cIS1DYz5Aw3O6W7APEgEDnsGl8yWplz3cXgVuxgCYEZue/PTPXEG73EdcXl4Aw6Z0+dPHQcsX9MJQ6d9Xji7EWwdEFtSTXUq4W7MdCAzW7YxDm6+Hl5QN5LAupyOcV/Nn0Uv1YXIHRKK0MtdiAJH8CTtWgq0P1QeBndMvZ7RuJZTBqJQPyDSGxO0gg5cklLptb25FY16LZ2Bro2lv09AdoFJ+oojKC0bjN5IIB5HHi+zUcUFz0qfPT/mJT2lRHKC0s9kGiLAH6DserBZiSS65aXoQqFp5+5lcKVSl6G7Y4xZUzbSQ5s4FLRO6ylsOLbifhYnJ6Opy+uwvQ8TDRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/25 5:35 PM, Qi Zheng wrote:
> 
> 
> On 8/4/25 5:15 PM, Barry Song wrote:
>> On Mon, Aug 4, 2025 at 8:49 PM Lai, Yi <yi1.lai@linux.intel.com> wrote:
>>>
>>> On Mon, Aug 04, 2025 at 10:30:45AM +0200, David Hildenbrand wrote:
>>>> On 04.08.25 10:26, Qi Zheng wrote:
>>>>>
>>>>>
>>>>> On 8/4/25 3:57 PM, David Hildenbrand wrote:
>>>>>> On 04.08.25 02:58, Lai, Yi wrote:
>>>>>>> Hi Barry Song,
>>>>>>>
>>>>>>> Greetings!
>>>>>>>
>>>>>>> I used Syzkaller and found that there is general protection fault in
>>>>>>> __pte_offset_map_lock in linux-next next-20250801.
>>>>>>>
>>>>>>> After bisection and the first bad commit is:
>>>>>>> "
>>>>>>> a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
>>>>>>> "
>>>>>>>
>>>>>>> All detailed into can be found at:
>>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>>> main/250803_193026___pte_offset_map_lock
>>>>>>> Syzkaller repro code:
>>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>>> main/250803_193026___pte_offset_map_lock/repro.c
>>>>>>> Syzkaller repro syscall steps:
>>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>>> main/250803_193026___pte_offset_map_lock/repro.prog
>>>>>>> Syzkaller report:
>>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>>> main/250803_193026___pte_offset_map_lock/repro.report
>>>>>>> Kconfig(make olddefconfig):
>>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>>> main/250803_193026___pte_offset_map_lock/kconfig_origin
>>>>>>> Bisect info:
>>>>>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>>>>>> main/250803_193026___pte_offset_map_lock/bisect_info.log
>>>>>>> bzImage:
>>>>>>> https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/
>>>>>>> main/250803_193026___pte_offset_map_lock/bzImage_next-20250801
>>>>>>> Issue dmesg:
>>>>>>> https://github.com/laifryiee/syzkaller_logs/blob/
>>>>>>> main/250803_193026___pte_offset_map_lock/next-20250801_dmesg.log
>>>>>>
>>>>>> Skimming over the reproducer, we seem to have racing MADV_DONTNEED 
>>>>>> and
>>>>>> MADV_COLLAPSE on the same anon area, but the problem only shows up 
>>>>>> once
>>>>>> we tear down that MM.
>>>>>>
>>>>>> If I would have to guess, I'd assume it's related to PT_RECLAIM
>>>>>> reclaiming empty page tables during MADV_DONTNEED -- but the kconfig
>>>>>> does not indicate that CONFIG_PT_RECLAIM was set.
>>>>>
>>>>> On the x86_64, if PT_RECLAIM is not manually disabled, PT_RECLAIM 
>>>>> should
>>>>> be enabled
>>>>
>>>> That's what I thought: but I was not able to spot it in the provided 
>>>> config
>>>> [1].
>>>>
>>>> Or is that config *before* "make olfconfig"? confusing. I would want 
>>>> to see
>>>> the actually used config.
>>>>
>>>>
>>>>
>>> My kernel compiling steps:
>>> 1. copy kconfig_origin to kernel_source_folder/.config
>>> 2. make olddefconfig
>>> 3. make bzImage -jx
>>>
>>> I have also uploaded the actual .config during compiling.
>>> [2] https://github.com/laifryiee/syzkaller_logs/blob/ 
>>> main/250803_193026___pte_offset_map_lock/.config
>>> CONFIG_ARCH_SUPPORTS_PT_RECLAIM=y
>>> CONFIG_PT_RECLAIM=y
>>
>> Thanks! I can reproduce the issue within one second.
> 
> I also reproduced it locally.

Hi Barry, can you reproduce this problem stably? I can't reproduce it
again after reproducing it once. :(

> 


