Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0897CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 06:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20DA58E0003; Fri, 26 Sep 2025 02:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7178E0001; Fri, 26 Sep 2025 02:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5CC8E0003; Fri, 26 Sep 2025 02:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E753D8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:57:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A640A1A05C1
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:57:56 +0000 (UTC)
X-FDA: 83930496552.14.8AF96D5
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3EF2218000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:57:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LivlkMkQ;
	spf=pass (imf24.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758869874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vx1itF2fTgxMCrrImdJeroS3R9ZKO1BJn3DX+Hel84=;
	b=qGRz1eH2YL7rpDEc1tsqWue4ksbmY50diKrJF3nMjC5x27IfRkYoyeZ3Qw8QIvSOanhGLv
	5wPBsJHNw1K5EkcLbF+lHT/aU/+6jdEyNwrE0f1mDOEaU71m3Z3ZYybytV+bk9QCGPjIhj
	yICAcw8lRnK6V5KQAobHsjciwp43ork=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758869874; a=rsa-sha256;
	cv=none;
	b=Z3BFqDRH6TkLMBt+RaYvKCuAEcxBcMbqAczIqcWlDNaEqeMIrv1zeJ6nF/ZjciOfq7T9qL
	0Lnz7FZLCGNcOdNkRUcWmvSRTF4tziQqF01M1ogkdXXzHanUM5dKnyx1ruwCiw7OURs8ra
	6YkETLRaItqE9a9XXxa2NKiq+NhfLtk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LivlkMkQ;
	spf=pass (imf24.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b55640a2e33so1451979a12.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758869873; x=1759474673; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vx1itF2fTgxMCrrImdJeroS3R9ZKO1BJn3DX+Hel84=;
        b=LivlkMkQhBj8emwQllawqvILUpTjStrvkX+Cp8QOPBpfpr4Uj4kXGv0eIcV8Wgbx75
         XPg4QMsXl97584hj4nqx4vGCIH2NK98kiiI8KNPQ9hEUgZdZA1TyZX3tJJmG8Mpjrl/X
         tl1WlrHTpmv8fkc61C3hskPBn6jNkFsBljYnBwyv8Td2PEchcSyqeQY3BUoIJq6cWc8h
         ieFFzhIaTLMzekETlKeBmSol6vF4KG/P1/9l1NnNcVlC7f4EiF4KRrI+z/YmZH3ENJsB
         cCpxvAT3n2QqQ1Yd+HyAHtWc4wArOQX0NAkzorL7PJALHNpS/0jKaEgWRUcqJTFZhZev
         3VQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869873; x=1759474673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/vx1itF2fTgxMCrrImdJeroS3R9ZKO1BJn3DX+Hel84=;
        b=rF/BQtgWcDrVzn83t2bE7cFSP5xtj7BLzVTJ6YEbxzcEx/Tlhq1jgtwbmY7UQey4gu
         So4o9rT7W1TTG7PuduqLYPNWZ+ZIZI6H1LA6KZocRj4u2tL4z8QeeDwN1QEi9h24Aaq5
         CPgyL3vT84Uk5ybE2ba2L9x0VvCnlZq/hXr+MXg3Gvf3p2TslXUwEOwJ1LjioJRFxUix
         doaWEu2lOgqfZ8Rwr3GQ8mfNHOe6I/Tu6+3EZe5ZOShrZecTMFgMnqiy1muIn/hPW0q7
         HjXuApCGt0/26R3PoAqSTYU5SCdtZYT5nr+r9lRQt2SbOJ2eDKV7GpbM2P1fL/Oq1nFr
         a3Rw==
X-Forwarded-Encrypted: i=1; AJvYcCWpvCAx9KW4rHUNQaccLk2mQLmxe3We/3i6Hf7c5RuzuUFDc4eL9/s7VjlhQ2vigFBWfkz1Dxmluw==@kvack.org
X-Gm-Message-State: AOJu0YxdOXqJJqj7MUroTWw7LkanND31l+BpWeooLkDiz1qz6V2jDcNR
	NsAnJdKYnZv055E/XzDyAftM/C2IQ+b2KW1GGbd5oc+nk0s5LQIqO9rerXilT3qj7zA=
X-Gm-Gg: ASbGncsEa35OZtuYK1l3G/1yBB0QLCYduGdPHM7FgIAHEfQqyvJ7Wou3fozBpAqBos7
	2NnprekDm9KorGLmdVayUlvl6PE5p8d3qJnS2COKU9BtBLj/G1NvtlB39K2SCgBzlJbVNOZ3bYF
	HJKQJJSYzoxkFN30i8i015LREAdgLh8mJeWGJPFttGNwLyHvyOir2FYV+ay4N7tK7nJXIi/jigS
	+eRD2DkuvajmG+B4gD34VqA2MMqgMZhndPYBNJC3l3xU+i3MGPOFAWo1AycDfoMTNs92y5IbcbH
	W/7y4+vurY9gjfshbYyBTZo5fKRYy48J+1iK0fofdgLkqmhl3dsd1kmcMJRRqKSAUN5mR9tpJiY
	r3VHKdfg4cOZgvCkWTcmQbLZ1/p8vWsJIGJ+YzmeIyJaSZaSW3/gv0hvazfwBufsQLohG
X-Google-Smtp-Source: AGHT+IF5bDf0FkWtdSNimjWM369R4KoAz2kYx41Je3d4j3cldNB8OPUueqbjTUh0a0uZVlv2hvbHNQ==
X-Received: by 2002:a17:902:db02:b0:26c:3e5d:43b6 with SMTP id d9443c01a7336-27ed4a91a32mr59676945ad.32.1758869872599;
        Thu, 25 Sep 2025 23:57:52 -0700 (PDT)
Received: from [100.82.90.25] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27f1c1af2d5sm7102075ad.58.2025.09.25.23.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 23:57:52 -0700 (PDT)
Message-ID: <fc91a0ab-e343-4f7c-8fc3-508ab0644e42@bytedance.com>
Date: Fri, 26 Sep 2025 14:57:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@redhat.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
 <b041b58d-b0e4-4a01-a459-5449c232c437@redhat.com>
 <46da5d33-20d5-4b32-bca5-466474424178@bytedance.com>
 <39f22c1a-705e-4e76-919a-2ca99d1ed7d6@redhat.com>
 <BF7CAAA2-E42B-4D90-8E35-C5936596D4EB@nvidia.com>
 <tyl5nag4exta7mmxejhzd5xduulfy5pjzde4mpklscqoygkaso@zdyadmle3wjj>
 <wlbplybaecktirfzygddbvrerzrozzfudlqavkbmhnmoyt6xmf@64ikayr3fdlo>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <wlbplybaecktirfzygddbvrerzrozzfudlqavkbmhnmoyt6xmf@64ikayr3fdlo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EF2218000C
X-Stat-Signature: 1nzkyb3t9zahp9f1w17qb4supocrnt76
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758869874-482251
X-HE-Meta: U2FsdGVkX1+3obGLPaP9DCgrN/pp3MI7bQ1fm9r8VxGMtvY4pULdcPZrCRlaqaGi6OGK/2MJJMYJ8A7EJQQcP/XoZ9fukwQON0+fL74a6NbiadDP9VElQGWQamb0NRcibXqvZYJ12fwcaxKqHBAE3COQKp2gkKS4c2gbrVVSYiod2U5lJbKUce+bJWdhPYaAPEcUpiV7FUO/0aenDtH7WrvDp735xjjXpp6gk4M0CEB9lhrJlPwQN0Uvu7/3ZhyRzRX+ASn+PPuiSAmizu/SZ6nlCOrYbtxYlzGU0YXD321iVr/tYmfblf1vJMcRlbWKhvZRs3gwDG4dhYGTXlEG8uRMOxMeszr6GPWqHElG4VCjOVU+hI4puOCvzL7I8V0p+3sHMyJyKZ2S/OQ7NDOy6DKmcMWiOOpwnNSjw5ARbM01rBjfhoU3gi+m9/OxxQSB5q/6UoNyyg33IMrBmlD2AQuAvy8smp25hiUpaYe+fXJUpy4Y8ECpRx/JvxMgHU4xOTwzxsKkOpBcbTe4Ase/vAtPEl2J+6KEw16DgjIQvJCNHJnLiWz4h6YUBXor0FMByqHLDJzHq2tnoHky20P7gnxbGRBLt6gOmk7/MwOqoj03sQvzKYKtribsA206r8eh1K0g01WqxdDb8YsNAtr92s+sstWvMwbREDXC3KQl7bNHZX2pgNSS5sO4u/uAjwmDbWnCU+3VtNtp+/QZpW+OpCZDNA8lzeihfFfP61GhvPLCaO24YRpT7C/Phk6n3WMXZtBhcUL8Q0GpGLVedxM9qKq/1TYmHH+rLmKL6il/POuddJNwG4IirjGSgr8A4nudPHNhgxCfWD9u/ubU6Vh6uf07qpBr2FJs3dHoPuNzq93Xcv9+fKvNGM5RJ3oiJdocGzW+cOGU5uHVIwrlP4lOA5pUyVyJgXj8aLCZur8ewASGgBusfieoGwYh9Ha15TJa3rHhR/Pu7+DhnsRG0vj
 EeEYJAVl
 1Oj7gNUeu2Yi7BXF6vCvUgZhtrGs0u8Q16BrHviVGGASuvDs3cuYhmznMvG3f+U2e/K2+5x4y5KrT5ltO4JIgmelP5hm4kFK4OyBuOI58Yv1N6qsMJ0rUFMTcV/41MzvVTfp4wc7UxWx1qNCvUXAzWJK1rNR9m3QHjzPRRwjQBYqWiSENNAe1W2+y5tF96bND/md/EYLHwqnrjLk9iUCiue6T2km5W+56VzIcMZQ1Zq39P/LPv2meunf5Lzmn25xwzvOB04dgwF81LgaHb3wqt3d6ErPUAMdT1iLP17Fx8E+mscKQCrnlONF2Wki3MJCwLfEocqRkLh8HbrBzKco24OAOo4n67lK+y4AVYr0+2l2rLzQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/26/25 6:35 AM, Shakeel Butt wrote:
> On Thu, Sep 25, 2025 at 03:15:26PM -0700, Shakeel Butt wrote:
>> On Thu, Sep 25, 2025 at 03:49:52PM -0400, Zi Yan wrote:
>>> On 25 Sep 2025, at 15:35, David Hildenbrand wrote:
>>>
>>>> On 25.09.25 08:11, Qi Zheng wrote:
>>>>> Hi David,
>>>>
>>>> Hi :)
>>>>
>>>> [...]
>>>>
>>>>>>> +++ b/include/linux/mmzone.h
>>>>>>> @@ -1346,6 +1346,7 @@ struct deferred_split {
>>>>>>>         spinlock_t split_queue_lock;
>>>>>>>         struct list_head split_queue;
>>>>>>>         unsigned long split_queue_len;
>>>>>>> +    bool is_dying;
>>>>>>
>>>>>> It's a bit weird to query whether the "struct deferred_split" is dying.
>>>>>> Shouldn't this be a memcg property? (and in particular, not exist for
>>>>>
>>>>> There is indeed a CSS_DYING flag. But we must modify 'is_dying' under
>>>>> the protection of the split_queue_lock, otherwise the folio may be added
>>>>> back to the deferred_split of child memcg.
>>>>
>>>> Is there no way to reuse the existing mechanisms, and find a way to have the shrinker / queue locking sync against that?
>>>>
>>>> There is also the offline_css() function where we clear CSS_ONLINE. But it happens after calling ss->css_offline(css);
>>>
>>> I see CSS_DYING will be set by kill_css() before offline_css() is called.
>>> Probably the code can check CSS_DYING instead.
>>>
>>>>
>>>> Being able to query "is the memcg going offline" and having a way to sync against that would be probably cleanest.
>>>
>>> So basically, something like:
>>> 1. at folio_split_queue_lock*() time, get folio’s memcg or
>>>     its parent memcg until there is no CSS_DYING set or CSS_ONLINE is set.
>>> 2. return the associated deferred_split_queue.
>>>
>>
>> Yes, css_is_dying() can be used but please note that there is a rcu
>> grace period between setting CSS_DYING and clearing CSS_ONLINE (i.e.
>> reparenting deferred split queue) and during that period the deferred
>> split THPs of the dying memcg will be hidden from shrinkers (which
>> might be fine).

My mistake, now I think using css_is_dying() is safe.

> 
> BTW if this period is not acceptable and we don't want to add is_dying
> to struct deferred_split, we can use something similar to what list_lru
> does in the similar situation i.e. set a special value (LONG_MIN) in its
> nr_items variable. That is make split_queue_len a long and set it to
> LONG_MIN during memcg offlining/reparenting.

I've considered this option, but I am concerned about the risk of
overflow.

So I will try to use css_is_dying() in the next version.

Thanks,
Qi




