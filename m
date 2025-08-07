Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A917FC87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1E38E0002; Thu,  7 Aug 2025 14:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9738E0001; Thu,  7 Aug 2025 14:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371D38E0002; Thu,  7 Aug 2025 14:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 246078E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:13:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8493137747
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:13:26 +0000 (UTC)
X-FDA: 83750758812.19.86F7CBD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 30F491C0013
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:13:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DjYYPYcJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754590404; a=rsa-sha256;
	cv=none;
	b=cfbh5RfC1fNYLQr3ujqvrqfP5ayv9jY92SdPXUPT9d3EbVS/lIj/K/T3Xzwfuf7Z3x78sK
	zrXw19dmGOQ8vEzq8mrTKsZ7U9tCzhHhfwx56c2+GicSi7GeYCkXRB1CuubpQF/fNk08z9
	kjKvJgafYuN9f8DdukGJMcSpG59PH8I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DjYYPYcJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754590404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZ4qf63/4d76saBrOUo5cTb52Cq5w2s1M6dqccUekpo=;
	b=e2yZyvEYvxU7hW1WQUXNV6ZIIPM2kdUUOPrNeMeRRGg8ZRCBhmPsAz09LDTU6oS9+QAdu+
	ORGkZLpqq+WqvnxCwA//+bANx2Bs6Zmi/bjDiQOg3GQSc0SZBg60EHmCSI/GBwWuBCsTv7
	6fUlbxDoMU4fQaqyb4+MPYE3Vx/xaxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754590403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vZ4qf63/4d76saBrOUo5cTb52Cq5w2s1M6dqccUekpo=;
	b=DjYYPYcJZ5kcfXmRbNkSeS5hcBXo0rulIVEMjOYGobqnFMjGDSqoxKh95E2nSpKI7O0yz6
	ij+L9e2iRO8GnbwHp3G7ct2xihOChdtpSmOHIo06ARbGFFwG8Hfw8y5JUjbWV6vHslWG+u
	+ouVSCpePXODrGlnlrkTTLnN4lzzUxA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-9yV1jPzNOWOBD-7stsvVpQ-1; Thu, 07 Aug 2025 14:13:22 -0400
X-MC-Unique: 9yV1jPzNOWOBD-7stsvVpQ-1
X-Mimecast-MFC-AGG-ID: 9yV1jPzNOWOBD-7stsvVpQ_1754590401
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459d7ed90baso9430025e9.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 11:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754590401; x=1755195201;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vZ4qf63/4d76saBrOUo5cTb52Cq5w2s1M6dqccUekpo=;
        b=bKUJFIP+elw6JhIqRyRVSC0uhEq4IX7oc3Adgkp9Jj7xFdaY56nK7MMIAGH5iaZr3G
         Un+7A/sakS9+LjeOUoXj0h2MuFfFtJWMfzLXa03kk5AeauES/vXV8rkJG48gnYnfsOJu
         idRxfrGu+b5fZi7bjQN7cUugCL1Dd6iibq5TB8LX0CMZmGMrzBkd1buoY5X8clLKtGV8
         mGQbwBpKpu5/9aPlyZbkRWasOWtmjdJm97jEUVjGCY2duz6nC7CbY25DtDiHjIzp5Dvr
         RP68agOQodMyCcbUavcWbH7YCX/dA8napPn4HbeC3twUgarnis3yz0uC3tAFOdf2lC+d
         yeCA==
X-Forwarded-Encrypted: i=1; AJvYcCW14UoFwx9T839YgtT4LzNrYTuXIqK644OabGuFgSoncsyzwzE4nz22dCfUZAx4WDaTLO4sJc8ZTg==@kvack.org
X-Gm-Message-State: AOJu0YxVIdgWzjhqCa+EeobwUTKKNyihX01s4wej624Bj58nfacgfeK9
	BhIcmf5hvfOJqhwy4uxl+XmOh0bHLxYRbMUbvYC0woGk6LX9fYMbNYO126HmcXRy8lJhYPJ20N9
	e10jbT40qM7fqfY+3d+DMUEz8ZSPLaJkCMwtCMVB/bfN9PrKq1qoR
X-Gm-Gg: ASbGncsXaQTSkGJMbBntuGES3kz+1BgtBUgxnaD9CYsL1IV8cQAJEYFfVho9vlMlQCi
	6Iu2OB9lY5t762dtIbRG7+qugQMBoST1MN+rXzrUV1R0cIbstts9flOUMY3l5gGk5LP47k4fcPV
	xnA4Bhot26wqub/fo9c6Z2vVhcidToMPLw6Dmo5xz9Tsr3sLdGDk01RoljgBbXCiD9gtSynI7wx
	o1apWMiXEdq7Zx08hSFGXj3hgh0tImMysYqpWht8KlSRuMVnXtajlYHmcKFpYJbE/v3c2mzwIra
	zid5aNOPJZbmC2kZZi27HGf812fYOhxa0RJ4jcY7DOPUh+6EBEajSPOorvIwjWbKn4ij65Nr/Xj
	ZGCBOckkCNpIl28YIakKF7Ad8eVnP0GwBs2OIxcskqk6UP4LwCrD5kQn4UvKPVomQis0=
X-Received: by 2002:a05:600c:4707:b0:459:e094:92c2 with SMTP id 5b1f17b1804b1-459e74a861fmr66147885e9.27.1754590400558;
        Thu, 07 Aug 2025 11:13:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3yhDF4k6z9/RJJDjl6ABCdlp8A+KepCRdH1HEc4EW/M3PvJTf74RIoantFL5NB5UUVs3YmQ==
X-Received: by 2002:a05:600c:4707:b0:459:e094:92c2 with SMTP id 5b1f17b1804b1-459e74a861fmr66147545e9.27.1754590400015;
        Thu, 07 Aug 2025 11:13:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e58554f2sm100987285e9.12.2025.08.07.11.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 11:13:19 -0700 (PDT)
Message-ID: <41bdce39-f731-4a93-a91c-34035f2d2814@redhat.com>
Date: Thu, 7 Aug 2025 20:13:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>, kernel test robot <oliver.sang@intel.com>,
 Dev Jain <dev.jain@arm.com>, oe-lkp@lists.linux.dev, lkp@intel.com,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
 Lance Yang <ioworker0@gmail.com>, Liam Howlett <liam.howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
 <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
 <e4f5faea-ccec-4cc7-83de-1a3c7013b81b@lucifer.local>
 <cbc2e23d-69ab-4820-9942-c7abf2066ff7@redhat.com>
 <2f0fef16-14ba-4195-b2ec-aabc69f445b1@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <2f0fef16-14ba-4195-b2ec-aabc69f445b1@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vt9YYxiHicwaEqqL_V93xks5VdEiYViDgLSS6Pnt2i0_1754590401
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30F491C0013
X-Stat-Signature: jsjmcbcj43ewiut7jx3itigjbumwj7xj
X-HE-Tag: 1754590404-270334
X-HE-Meta: U2FsdGVkX1/Fow6DXxsYWT257bu4bSVsq7ZlK1C9+xOV9ctRn7Mh7w5npd8cukIRkswgModTF1kY09WwsOb+0/UxGbLqmcNvIhVbeq4e3uL6+2Cnq8Fvhf+/xUx/oriL3QO7eBbqy9KsPw+7jRvWfXLMbJMg1YMruWyoipZ+YgorFDu3xeomyfWgXYHZ3vObZyT4kR4lu/wtlmvlQBkIcbHtTaAP9SNalnrTTnyNsGtFDTL2E0M92mjswULC31XCFPa0Ablb9TWIF6cSCOR7YK4MONONwnlKgc0GHI2nQ6tT0aSBBMaO9mcmwiuF6dMamdyDVqSwVyxb3XaTNVQhoCx+RmGKoiIumWB7sdqddx7ysJ5sHv6jXr/i1fiPt/LdqpHtTFvu6hp7ta/8YucqokI3lL3jOub+5/khz0mjzrS/iom+wC/j9gvt/4CCWFUKmNLPJu70TcaNauLEMWrM4NBUL9QNmA9kv5D2xnoa5oWrmsfM3paW7Iolm7XyrOokCzENMHXPONM71W7u/CjkqU7cniLFawKV9tm7nmOw3//H3ZADSHOlPx28ek22Y0KFf3z5KbTqfR/hWWZ9qCWjKQF3/jgQKEnuPG+qAceG/BfrIsOnNT0VkAuZv7gSUE+kK8amV3T3ckbNrZzI0isC5lerzugPAplNYZVsgBKEVeNKK6++5csiqSXm+86usbqSgU5rN03Ybdr+J+vqb1IMWkOgpnHfs8Ku7YP5n7NMtkCVQNz0Er2qIkGiy53iFec7rC6BHRzk+nRqRFVk0fhXDI6aEPaC335D186jCDEsYjPPZXTSZNKOR+j5hAaHHR+VYREDXZyYOHNDTuV5gT0YL/VxqfTkVwtShasaWdEJapjMJI0nthXvAxlmfDQwdGdsKmVfsbY9BTmcAQYmBeqEovr5OPExMMbSQsj70o+GjywDXlAr+2/O7XoGAamBBChlSWi5gkFATU7oypdoHHI
 E6m7HBub
 9G/Bt77J/39tLe1kqfvlqzRX/jFHymHW0SDvs4osLv+UK671HwIOUJrogcN0nH1cgA08HCTyFjQUbOX5g/3Zl1QlhEEZ6XNKrojAnBGEVvPlekDnbl9FOtUZyx4ev6m4jMc7CqgwK/m7k57N6v4BxfUOI0f1HDTEJrod8pqgVfaGMLPi3f1H/d77OOWnit3+UvwdAgL1sp7zAEHY5GUGETfEtBecCxAQ8bb0QpLm9kcX33Bbh1zQzjOhS3WGROAiNmT/tLCmSv8ExC+UD4PdlnMZV8AnmS1exbLXI5ObEVO/mDdvtz0z0BGYFK+K1X9J/afniusNcvTDqQv36fp2KpQqb0FPzcmqoouUk912iSmVt2m2h/vNoyT4bSGPiJwx+wKEFNqmI/dkUigkK4lyK0YEh6ZhrWDDIJpgkn2rLVk2EXAJeZX2Id+E7p7xgxoxzrMGv7piKhDwFA+qhHkF6wEYutlsJ0ewGFC/CHouoRDrc0jc3FVSMOwruUULByH7DYisFk7N06ZjiXQbSJmF3LVsEXk3FMBrY2KkS3mcuupfcYTL7LwbiJ/gCwb1YW1R2zCN3n0C2K67OP/4J9p3kk4rmwibYrYZutCTTXm5z/YPiXis=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 20:04, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 08:01:51PM +0200, David Hildenbrand wrote:
>> On 07.08.25 19:51, Lorenzo Stoakes wrote:
>>> On Thu, Aug 07, 2025 at 07:46:39PM +0200, Jann Horn wrote:
>>>> On Thu, Aug 7, 2025 at 7:41 PM Lorenzo Stoakes
>>>> <lorenzo.stoakes@oracle.com> wrote:
>>>>> On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
>>>>>> On Thu, Aug 7, 2025 at 10:28 AM Lorenzo Stoakes
>>>>>> <lorenzo.stoakes@oracle.com> wrote:
>>>>>>> On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
>>>>>>>> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
>>>>>>>> ---------------- ---------------------------
>>>>>>>>            %stddev     %change         %stddev
>>>>>>>>                \          |                \
>>>>>>>>        13777 ą 37%     +45.0%      19979 ą 27%  numa-vmstat.node1.nr_slab_reclaimable
>>>>>>>>       367205            +2.3%     375703        vmstat.system.in
>>>>>>>>        55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.KReclaimable
>>>>>>>>        55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.SReclaimable
>>>>>>>>       559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
>>>>>>>>        11468            +1.2%      11603        stress-ng.time.system_time
>>>>>>>>       296.25            +4.5%     309.70        stress-ng.time.user_time
>>>>>>>>         0.81 ą187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>>>         9.36 ą165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>>>         0.81 ą187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>>>         9.36 ą165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>>>         5.50 ą 17%    +390.9%      27.00 ą 56%  perf-c2c.DRAM.local
>>>>>>>>       388.50 ą 10%    +114.7%     834.17 ą 33%  perf-c2c.DRAM.remote
>>>>>>>>         1214 ą 13%    +107.3%       2517 ą 31%  perf-c2c.HITM.local
>>>>>>>>       135.00 ą 19%    +130.9%     311.67 ą 32%  perf-c2c.HITM.remote
>>>>>>>>         1349 ą 13%    +109.6%       2829 ą 31%  perf-c2c.HITM.total
>>>>>>>
>>>>>>> Yeah this also looks pretty consistent too...
>>>>>>
>>>>>> FWIW, HITM hat different meanings depending on exactly which
>>>>>> microarchitecture that test happened on; the message says it is from
>>>>>> Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
>>>>>> meaningful than if it came from a pre-IceLake system (see
>>>>>> https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7Xr-w@mail.gmail.com/).
>>>>>>
>>>>>> To me those numbers mainly look like you're accessing a lot more
>>>>>> cache-cold data. (On pre-IceLake they would indicate cacheline
>>>>>> bouncing, but I guess here they probably don't.) And that makes sense,
>>>>>> since before the patch, this path was just moving PTEs around without
>>>>>> looking at the associated pages/folios; basically more or less like a
>>>>>> memcpy() on x86-64. But after the patch, for every 8 bytes that you
>>>>>> copy, you have to load a cacheline from the vmemmap to get the page.
>>>>>
>>>>> Yup this is representative of what my investigation is showing.
>>>>>
>>>>> I've narrowed it down but want to wait to report until I'm sure...
>>>>>
>>>>> But yeah we're doing a _lot_ more work.
>>>>>
>>>>> I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
>>>>> especially sensitive to this (I found issues with this with my abortive mremap
>>>>> anon merging stuff too, but really expected it there...)
>>>>
>>>> Another approach would be to always read and write PTEs in
>>>> contpte-sized chunks here, without caring whether they're actually
>>>> contiguous or whatever, or something along those lines.
>>>
>>> Not sure I love that, you'd have to figure out offset without cont pte batch and
>>> can it vary? And we're doing this on non-arm64 arches for what reason?
>>>
>>> And would it solve anything really? We'd still be looking at folio, yes less
>>> than now, but uselessly for arches that don't benefit?
>>>
>>> The basis of this series was (and I did explicitly ask) that it wouldn't harm
>>> other arches.
>>
>> We'd need some hint to detect "this is either small" or "this is
>> unbatchable".
>>
>> Sure, we could use pte_batch_hint(), but I'm curious if x86 would also
>> benefit with larger folios (e.g., 64K, 128K) with this patch.
> 
> For the record I did think of using this prior to being mentioned, product of
> actually trying to get the data to back this up instead of talking...
> 
> Anyway, isn't that chicken and egg? We'd have to go get the folio to find out if
> large folio and incur the cost before we knew?
> 
> So how could we make that workable?

E.g., a best-effort check if the next pte likely points at the next PFN.

But as Jann mentioned, there might actually be no benefit on other 
architectures (benchmarking would probably tell us the real story).

-- 
Cheers,

David / dhildenb


