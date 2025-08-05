Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D21C87FD2
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 09:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4AFD6B0096; Tue,  5 Aug 2025 05:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB036B0098; Tue,  5 Aug 2025 05:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA786B009A; Tue,  5 Aug 2025 05:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE5E96B0096
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:31:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A0C55700E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:31:06 +0000 (UTC)
X-FDA: 83742184932.18.808D8DC
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4528A40006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:31:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="SXCgT/G0";
	spf=pass (imf27.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754386264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcSz6w8T+qiYKIZHXA0L96GhzkBgLZFE74LcxOMy1nU=;
	b=s27XDwZqch8dIFkJMf+DsUGLMpyAx9yZW1QXlUCHY983u9OFq2xB1mG9WsjYYmmL3nHCu+
	DM5V2mfN0b1fjiNoywP7Lj3UfGUTR8PZHq1uhAadA0/YjnIaDA9bJf2hbBY0BK+qYBfQvQ
	dGurXSeUo59CnXFlHPBtfWisamcOr2w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="SXCgT/G0";
	spf=pass (imf27.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754386264; a=rsa-sha256;
	cv=none;
	b=US1W+N6uzwNJW3hwzQpSWbrcHjoAvDAnCr6k6BcIHiaWSLJz3cwApWdukWoT0q/a65rpib
	8O3BQKqOEi5vD5KJjV/a49I0jC//lLi7dFUiSeZvu52reuc11B8dRp7wSvw8VQi1FqFkyK
	79oMc02fQOLcv7bjIbp5iHeqRxGVWHY=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23c8f179e1bso49525035ad.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 02:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1754386262; x=1754991062; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hcSz6w8T+qiYKIZHXA0L96GhzkBgLZFE74LcxOMy1nU=;
        b=SXCgT/G05G34200swQ7xCeSenzQdxN760GyUQUGGACvG2F0US3p+jM4wrnL3RGcThw
         sS4Oyus+nj/UxP+bQOVurdgmj+I0N/A+lMdDqwlKMrlGnlNu2Nbm/wV+D9abm4+fvpY+
         UYfXd7VUuemWe6R9szPM/8/6j5ysgcQ0pOLi0BvRsjTegs8qK5/4wKqjIL4TLYmN5tov
         gf7dOp4npWifEEhaYmSf9gWvvEzwN9EbtHqS1McO0kdkBrsEY8W1A8r+x7k5lnzSpQBP
         gTY4kNOQ705cw8j0ECYCirOT1diqVwvLnFAzCA9n3XEoTzSeaiLWc+U3MqUzUa18BQW4
         Y90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754386262; x=1754991062;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hcSz6w8T+qiYKIZHXA0L96GhzkBgLZFE74LcxOMy1nU=;
        b=ZSBI2f0lqOQIZn0ucRw1KBnCO0Bmub8dcydv2d3k8DLUcCW1CN3Fz8e+LXesOVUC7H
         wUDwrTm6HnutiyaS0t8/Mc8VK9MmmYgaoZqQanRbblk2l7YqlTfUkRsKfDhj3CQAtOhJ
         ztswZVR9gGh3AgXf27Sc43H3zuz3a4Zf0z2/RswNfDnT1DHlNgRbyzhDVbbCCUhkksSf
         SOuWY/FZ2mgilzbxplv7yZPNY46XAEQZPVW3RdZDMthYGECBPClbWWONNOFB1BsjGjp2
         paXg6Sc0Hcc/79s9d4cTyfHNXL86umFdHV2yRnWl3YS0xXDqsq1f6s2uJUrOHR5HhL/4
         AWtQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4DPtg+y4qZejV0OP631PuPBY1vbeAK2hK4lMw/Yf2JXPeR/oMNZpAfb0y+K8IqQ/MW+av5xO7Ow==@kvack.org
X-Gm-Message-State: AOJu0YwEFF06+Rsn/ITlTWKrkdFVULFFD92VNSSqF1OoDw8k/72N9oud
	ArCoIzsZEXzZQbWvEQlxpqGYb+icWgbvQPiRBEJX9bU1f4kxse4MwOiBXBdOAvyKxxY=
X-Gm-Gg: ASbGncvHZhYTKPIJHxGTB4u5UpR1ZhqTf2EDRY6z9Qv1BVBL2NKgFk8tZlIJRNQF/GI
	WchFEPGf/BqzlfuxK5guq2iM6Hq0H/Evl7NAlGBCHtHS+WTIexqKQtxMWsB3tij/JftGOFH5CM9
	Z4IYz/5nXNW3HNiBLcGcHUmr241LIZ74/U9FOs2wwNqkO7CbvkCWvR0hPMyhcAqqVI/j+FtbpXK
	2rUBGLZkNuGsgN+a3R3JVFQm1z57RToM2xl9tPsKQ1l5pbvRGzWXmtCl/zW87ftQj33GKMMmygh
	jOJiJFwgruos/cHBwAod38Uz/9Ru2mX0ZyIaWy2G7So2OwGrKa8B6afbWXupyEOWavyLhouj1TC
	5j2Bsiwx8hF2KGwa+Q0IFdSytsWVHoKYuJJrLWgYGQd9l
X-Google-Smtp-Source: AGHT+IG1HKRs9XWU020nzVLECpDXa3lJhwfMUaTwx5lJK40D506Do8TSCO+UECOj2zkcTVSvxEqc+Q==
X-Received: by 2002:a17:902:f10c:b0:240:678c:d2b7 with SMTP id d9443c01a7336-24246f599ccmr122175505ad.15.1754386261808;
        Tue, 05 Aug 2025 02:31:01 -0700 (PDT)
Received: from [10.4.54.91] ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6c62sm130288695ad.4.2025.08.05.02.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 02:31:01 -0700 (PDT)
Message-ID: <064cca31-442d-4847-b353-26dc5fd0603c@bytedance.com>
Date: Tue, 5 Aug 2025 17:30:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 Lance Yang <ioworker0@gmail.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>
References: <20250805035447.7958-1-21cnbao@gmail.com>
 <35417160-86bf-4580-8ae9-5cadd4f6401d@bytedance.com>
 <d73213ba-5ca0-451c-b82b-f590d10da6d7@linux.alibaba.com>
 <b594a315-8458-439c-b535-fc7f052a3fae@bytedance.com>
 <c6f9dacf-d520-4cc3-88ac-c5937916aa2c@linux.alibaba.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <c6f9dacf-d520-4cc3-88ac-c5937916aa2c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4528A40006
X-Rspamd-Server: rspam06
X-Stat-Signature: m8rxycd3srp8xmdati9hjksjgdr8bjca
X-HE-Tag: 1754386263-448197
X-HE-Meta: U2FsdGVkX1/2Rju2zPhZBDO3oAKVSQkOQULD2Q4Z+m4HKOqu5rEmNQLEH1oSVFb+c5gE92sHycN/3idrJWOASkYEAYYOeFMhuumw22Q/E+qfzJZJa33m6h+bHvslVZKg1r8lD0LB7LlbdAx65nsKzOeIwjoyToEYYF2ZkATVupzm7gH+ZycuCuWofclzLhCB6DMDwL74oRPDZ6genCqRd1lalSSr8oa/0n8oHV2FccWRNay0V0YNeH3bM5EnsuTFl+awgAiG2yX0XVzBS7hUcWICiTojRxSlXMp3+OJzH1EcN9tcznLFg/MPXqRJtiEjBuzlm2qW5dlwA+szTL5f9rTjfg00WHhwjqoDRhAJ7R5VK9V/E7W7plhJW4F3ClS2ICz3U3Dn6kaT7lgHCt5w5SYta5r2earNjyQc2rxafuJeK5XMQ9vowQuKCh3ooUiTurBr2AaMsnxJUjpgAPOzixYBHGW9rEq871BH6ymKQqKVLUNkXTiV8M+T3TC41vDwsAUzAsVxN703ZN1cLajp2KRfOANi2x10zEfREzdmJMeKOaGt8wxWyrsi9ANtGV1eTprN7a6VvJQ405qbY1Al7BnQbjfIn3zRHHWZSNrPGyLrQzJTP5QjO5itaOJPQ8fVtLyo0rd3RNMsp+iPmPd7ie+sTo+fPXS5mJimD+2wLbgIIep8DsU3ga1z5Q9FmMy7CEBOC9JkDA5Jur68CbWYW3aaLZZgLJ8BSwZs6QULILA8qUjTULVaKzt0pImDlcU76MEXa+vtMOpnmMvRd7xRHNdrI4SDvV436tbs7nS1OvszC1uK1cCSGRMO45mfcQ7w3qk037Gi1LJlFmRybfu3v73864KCMuiAHl15A/gHgmDGeeqDJtpotJvFtiroYNMy6TDxqRFscz5LjwSzzLq3VXJ/gXi//1IRJtn704gZg6XZHWb51bl/zKjNEW+tYDd2nw3aOETjbmqSw+10FN6
 j+n3siEW
 RqYqNXxeJhlZ9TUO6vdQn9vSIwOUyNbWjgblRsvrgwe1akQJar3LJK6I5lxP+Dv/Za6wWIVdyQJeDN0hUkHpI3X/puiBXsPmmTJDTiR+xnwGso3U4O9b/JYQr4rvGEBp80QKOoS9Nz1900s3hx8z8+PH1MX9XD3QqUyNQjjQOJGaNakK0WO05W0CFNslFjr27500N187dImbmsa1xUozCn+PcwoZcPWDJ7N6uGZtHc6a90S+JFJhv//p+Rkfdv77LwcZNRn+b8HmB/MJG/OmC5TQuKIiZNFgHWqUVLzYfuFpZ73U4rd1aLBOjOi+d9zK0wEkGOarQ76UqKLHohFGXWLiIEH2E0AIrvG55pzagOWH6kn8bcq5ALw/VT9kRNPpNg6Nfew4tgPd9DbNnQAYwp3jHuRHr4uews+kTcvWR8IpZ8A0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/25 4:56 PM, Baolin Wang wrote:
> 
> 
> On 2025/8/5 16:17, Qi Zheng wrote:
>> Hi Baolin,
>>
>> On 8/5/25 3:53 PM, Baolin Wang wrote:
>>>
>>>
>>> On 2025/8/5 14:42, Qi Zheng wrote:
>>>> Hi Barry,
>>>>
>>>> On 8/5/25 11:54 AM, Barry Song wrote:
>>>>> From: Barry Song <v-songbaohua@oppo.com>
>>>>>
>>>>> The check_pmd_still_valid() call during collapse is currently only
>>>>> protected by the mmap_lock in write mode, which was sufficient when
>>>>> pt_reclaim always ran under mmap_lock in read mode. However, since
>>>>> madvise_dontneed can now execute under a per-VMA lock, this assumption
>>>>> is no longer valid. As a result, a race condition can occur between
>>>>> collapse and PT_RECLAIM, potentially leading to a kernel panic.
>>>>
>>>> There is indeed a race condition here. And after applying this patch, I
>>>> can no longer reproduce the problem locally (I was able to reproduce it
>>>> stably locally last night).
>>>>
>>>> But I still can't figure out how this race condtion causes the
>>>> following panic:
>>>>
>>>> exit_mmap
>>>> --> mmap_read_lock()
>>>>      unmap_vmas()
>>>>      --> pte_offset_map_lock
>>>>          --> rcu_read_lock()
>>>>              check if the pmd entry is a PTE page
>>>>              ptl = pte_lockptr(mm, &pmdval)  <-- ptl is NULL
>>>>              spin_lock(ptl)                  <-- PANIC!!
>>>>
>>>> If this PTE page is freed by pt_reclaim (via RCU), then the ptl can 
>>>> not be NULL.
>>>>
>>>> The collapse holds mmap write lock, so it is impossible to be 
>>>> concurrent
>>>> with exit_mmap().
>>>>
>>>> Confusing. :(
>>>
>>> IIUC, the issue is not caused by the concurrency between exit_mmap 
>>> and collapse, but rather by the concurrency between pt_reclaim and 
>>> collapse.
>>>
>>> Before this patch, khugepaged might incorrectly restore a PTE 
>>> pagetable that had already been freed.
>>>
>>> pt_reclaim has cleared the pmd entry and freed the PTE page table. 
>>> However, due to the race condition, check_pmd_still_valid() still 
>>> passes and continues to attempt the collapse:
>>>
>>> _pmd = pmdp_collapse_flush(vma, address, pmd); ---> returns a none 
>>> pmd entry (the original pmd entry has been cleared)
>>>
>>> pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl); ---> returns 
>>> pte == NULL
>>>
>>> Then khugepaged will restore the old PTE pagetable with an invalid 
>>> pmd entry:
>>>
>>> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>>>
>>> So when the process exits and trys to free the mapping of the 
>>> process, traversing the invalid pmd table will lead to a crash.
>>
>> CPU0                         CPU1
>> ====                         ====
>>
>> collapse
>> --> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>>      mmap_write_unlock
>>                               exit_mmap
>>                               --> hold mmap lock
>>                                   __pte_offset_map_lock
>>                                   --> pte = __pte_offset_map(pmd, 
>> addr, &pmdval);
>>                                       if (unlikely(!pte))
>>                                           return pte;   <-- will return
> 
> __pte_offset_map() might not return NULL? Because the 'pmd_populate(mm, 
> pmd, pmd_pgtable(_pmd))' could populate a valid page (although the 
> '_pmd' entry is NONE), but it is not the original pagetable page.

CPU0                          CPU1
====                          ====

collapse
--> check_pmd_still_valid
                               vma read lock
                               pt_reclaim clear the pmd entry and will 
free the PTE page (via RCU)
                               vma read unlock

     vma write lock
     _pmd = pmdp_collapse_flush(vma, address, pmd) <-- pmd_none(_pmd)
     pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl); <-- pte is 
NULL
     pmd_populate(mm, pmd, pmd_pgtable(_pmd)); <-- populate a valid page?
     vma write unlock

The above is the concurrent scenario you mentioned, right?

What types of this 'valid page' could be? If __pte_offset_map() returns
non-NULL, then it is a PTE page. Even if it is not the original one, it
should not cause panic. Did I miss some key information? :(

> 
>> IIUC, in this case, if we get an invalid pmd entry, we will retrun
>> directly instead of causing a crash?
>>
>>>
>>> Barry, please correct me if I have misunderstood something.
>>>
>>
> 


