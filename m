Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDEBBCA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A2B8E0013; Thu,  4 Sep 2025 14:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B178E000A; Thu,  4 Sep 2025 14:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3618E0013; Thu,  4 Sep 2025 14:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB998E000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:56:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE3F916035E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:56:54 +0000 (UTC)
X-FDA: 83852474748.18.1B18BE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 58F3C40004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:56:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dCFCNbGD;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757012212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//wY+wiCi15t97+fQ+FMBl1p8QkU5s+6Pz+y0f6tnSE=;
	b=lnPmJNtZ0D8TrI+X1AzeBtKOmvnLoQAmvHu0FqJAKN/ekxYxx7WLrn3nND6YccGN5AkQJW
	mn1uVssIZxO/PcwX4Su95mmCXEwvpwNJxdUt5YqtwpYAheaUQolt6CL/dglqdV3Rq8N6yK
	9tQb/nQuvJEzwKL4uT2bMZtzWwU+DkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757012212; a=rsa-sha256;
	cv=none;
	b=msrmc1O3oQEq6LaumiVtc5F//3Bd/8R610XiDrWjneEKo+i3EWbXZ/FhQ59NaGpIfKQWcb
	GSQTHiWPo2bu6hsKcUjcHBb/6l1TZlTeEhM4m14EGwsdHNtPytAWvyb1bLaAJ7z0rY7hB4
	zZBhR/kZyV63F2gYoOmb02COu3Yj41Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dCFCNbGD;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757012211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=//wY+wiCi15t97+fQ+FMBl1p8QkU5s+6Pz+y0f6tnSE=;
	b=dCFCNbGDw8IQR/b2l7hUmhKu0+reHaJ2mCdzCITCB44DBQ9qjvFDvS2iEBDSq25APZ8s4g
	HNsIDXZy9ouda/iyf9i13QNS8w4tuw4zC13o5+gvuzmG1iWxTEqCEiNX0gDqNxfAbL15j0
	gjja3iUtiXxEvGNzl3hWl9LX99tsAXo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-ADt7c3QdM5Cr2o3obdpHhw-1; Thu, 04 Sep 2025 14:56:50 -0400
X-MC-Unique: ADt7c3QdM5Cr2o3obdpHhw-1
X-Mimecast-MFC-AGG-ID: ADt7c3QdM5Cr2o3obdpHhw_1757012209
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b9c1b74d0so7366315e9.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 11:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757012209; x=1757617009;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=//wY+wiCi15t97+fQ+FMBl1p8QkU5s+6Pz+y0f6tnSE=;
        b=nFgDpw3wnb6A/PSihtR2uxCwoQdQhDT++IJC06vuEtCE3yVkpGkQfHmmo6X0is6bV2
         FojDGkTcfUoetxGnachq0F8zGinJpIUOglNlfRFY2IZ9ejfRFMSOrBVMi8UR9dQkCjDc
         6fDhjiLgdkeB6qIE+9oinhflQz+APquG+gpBTdcwS+WzB8GNIh+QVEA3wN3B1yFYWFZG
         N3SERD2rY2Sil9o3Oq796ofQTuYYzNGEgpQ6GZT8RanEWjNzuBru7bGX33LAyGl/RDZC
         OTiwCE/6hln0IdgObfQIPk8eTC592j6nJMtW6IjKccom1KY4fxnerJJA4H6LcA31i36w
         mWzw==
X-Forwarded-Encrypted: i=1; AJvYcCU1sN8wOjARclMbzkgcUorJCdcgDnxoJmEKr+Txnpw6s0QT26dw6yTa9CZwh2NaoD3wxeQCSBh4jQ==@kvack.org
X-Gm-Message-State: AOJu0YyBwRXhhxxHmkufvYE8GtMYMbmfsXnoSB2eOZuCU0LPZVv1eAPY
	VQWwphacDaq2BBBlqhG00u1q+OLAMjVjnsueZ3+W9NhagDvgh4XIMi2py+pIggdH7GLJXT+qfot
	XmFdBAMxhpTD1JQJbixxy/98Y+1nz27Keioc8iS8+pcvmUm8oHHMX
X-Gm-Gg: ASbGncuaujGdG/3EKdpaLWNM7DdOYYOLb8DXQFQunzdAjTpz0xZEJDGS5HLQvZMiPr9
	a8mtLlXjqy6AvOrMkzTph/4Nlt50LfNnHeuuWKl3d/h7kkiDBnWBYQ9TToF5FZVnzf/nlKQt+rN
	V1x6vLN6ue2iDcp060G/rkmFytrcaRS4smgxAjnq5GjezcLwQBu5ZP/on/+OC6G4Smy3NKlxOjD
	O1T14l9QJ2hxzqT61/GA1L4aENKjgpyzcFNaREf0NyJCGc+qyraAbZe68g5HBt3D6MHlJiz/do3
	DHMvt5e8WRC4g70HUMWAIM87xVY2cXQzWBUU7AeOpAx0cSoSGgOrMyxCRxsAL2R9XJMQYEIc0Mp
	5E5HaIz3zLOuOFh12HrFhUZTKsM1VCTFIxJh+1Hoj8H3psuge/Wy6DvbdGB5X0Mab
X-Received: by 2002:a05:600c:1d0c:b0:456:1b93:76b with SMTP id 5b1f17b1804b1-45b85528632mr169110785e9.4.1757012208918;
        Thu, 04 Sep 2025 11:56:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeNuNqOEHJCDLrWhEXGuSOxXZHwBD+OGhZztGaw1PGcxtN9h6/v7McFNFlb90ZhXi09IhDLQ==
X-Received: by 2002:a05:600c:1d0c:b0:456:1b93:76b with SMTP id 5b1f17b1804b1-45b85528632mr169110445e9.4.1757012208416;
        Thu, 04 Sep 2025 11:56:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0d32a2sm415142505e9.9.2025.09.04.11.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 11:56:47 -0700 (PDT)
Message-ID: <26e6828e-78f7-4454-abaa-334257a8f8c2@redhat.com>
Date: Thu, 4 Sep 2025 20:56:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Nico Pache <npache@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <CAA1CXcBVR=L5_6x5FGeR693AB_YqEF=4KAX7_2fRgGNa1j1j9A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcBVR=L5_6x5FGeR693AB_YqEF=4KAX7_2fRgGNa1j1j9A@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FfjNW3E1JUA7wA_AnX21uGqnloK1d72n9kSElxbKqAU_1757012209
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 58F3C40004
X-Stat-Signature: fcfjfkb4tuhhp5mtna6y9qu9z8hhgo8a
X-HE-Tag: 1757012212-884583
X-HE-Meta: U2FsdGVkX18k+FvauaO/5AwrErfovDsNYEZUfPgRivEIE7I4WeQTabD/egHSbbtcrFATDGt53MabxZiCg2xfSQtIaH7tWgH+hDcWipJXU5PWRJloUWS6VByYU02CvU8ceQaR2AXAXHKakWwBTgEO1GxxrlPPWFpxa2yIZtszoEZgAGolZyuxBlnmyiUN9SRPKxZgpENsnWCNR9nLgkLLSpzyr0ARScdWIZtL9yzpe/HUtSNUkYlLS4Dsgu0T3MWfYTy2bVPhmd551L3mFR9XgNwXRL6dyfR0HS1rDlDgiUw6ByF2dejspSmy0lU05BQGjshHvr9mF4hQPEhQqzykwiSMpXculCmwA4+Cgsd0M/lFXXvhKZK00i/REA2GQypi7zqSV7sgrMRX8FOgPDqXJb60JA6/QqQSaXi+8EP2i+pkn4CXhLl2xr2jKlOVH6XENuLdMwRHlygEf9GJQ2l7I+0ejz9gMyUCBKgrdLgA6uc2/O4ETWgmKZycJVGUmUEtSHEJ56Oo7PbDr7urxXxCtJoA2jXQrXsNC2rX0lgA6MulcyF4DEhdpHjQ4Mwci2rMaFsXd5LLBTrS8Y455du7GFfOE8vc4zrimaVTjMXAa6rSbndifS6twe+FjeQ2WliJGwSK431Il1nyF9hPp+IxqKpHeEjk0oRz8awdhSt6jLjGKbNtPCokRy0lDXnYaSyLywSVXjKtk+pKJ0UGxIlnLmAACMnz1jxYWoAUM69xYOsYyBQlqtCRBOjSsguFWKa4vvEfSzLXlggYckcXNxLHOF2PhFyLlxQA3Kn1+0vooowwID2rjEDrcWRWorsnaa5CO142tm5IcSu96yl1IrgXJSPlD0HU4ejNoJ+nZDN+wWrFQbwSg12+/dSCo53uDlD22I9r+IfInRghNzJv+C84SlCDuzrx4YwgZCLYii75FE5WJ+KnVN2Gs7s3MRue+wRBsZL4E1a658R54vDdEjE
 EcuC5Kc0
 J572qZy7OhgY7h3BBh4bGW8k7RUhZu4rctjc15rA438iLd1ZsVimxOT+uuBl4zXnNLv15ja1ELgXOo3MZY55xJB5BmtTsIplGSqPvZHC1w8JJngeIiFWFpixJdcU+Ao1Cq2fo26kntERyA6I8PPAs6CGZXWCoMMzndmWMiOR810kUYZ3fv9GXCnPhwWIC/xlVXkDP01/zGUxII9yo+gn4hIn1huxpH8uDjsPr3q/zzCmhYrZIC9YY4+3cdUE/iMOJn660Lko5uu0VU8lRnnGnWjjjZ9BTr1v8QsP1ygDY1E4l1oIip2M/FuEZkirgL1XcsvjnJnxF7YgvLQmeRNzO7a74ZytWcgopkn/pyYGch33hIg3AAM/C2bgEFWxAwaZznaBEqBA6m+bdmVlwIHhHLVA9OSQBBZ1nW7l0/QLkApSVpWMaUL1ZgUL+XdcvIcSlCZc6kSnc9x9TSQYNlSHtNdjblt+KxIhhXcqqRZ+EIsfdNKNVYKx691F3UzhuaTJRf/7XnTlqMpy2nORVDY/RIQUzGmwmP+nbWrfqFl9SZPGQ40c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 04:44, Nico Pache wrote:
> On Thu, Aug 21, 2025 at 10:55 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> On Thu, Aug 21, 2025 at 10:46:18AM -0600, Nico Pache wrote:
>>>>>>> Thanks and I"ll have a look, but this series is unmergeable with a broken
>>>>>>> default in
>>>>>>> /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio
>>>>>>> sorry.
>>>>>>>
>>>>>>> We need to have a new tunable as far as I can tell. I also find the use of
>>>>>>> this PMD-specific value as an arbitrary way of expressing a ratio pretty
>>>>>>> gross.
>>>>>> The first thing that comes to mind is that we can pin max_ptes_none to
>>>>>> 255 if it exceeds 255. It's worth noting that the issue occurs only
>>>>>> for adjacently enabled mTHP sizes.
>>>>
>>>> No! Presumably the default of 511 (for PMDs with 512 entries) is set for a
>>>> reason, arbitrarily changing this to suit a specific case seems crazy no?
>>> We wouldn't be changing it for PMD collapse, just for the new
>>> behavior. At 511, no mTHP collapses would ever occur anyways, unless
>>> you have 2MB disabled and other mTHP sizes enabled. Technically at 511
>>> only the highest enabled order always gets collapsed.
>>>
>>> Ive also argued in the past that 511 is a terrible default for
>>> anything other than thp.enabled=always, but that's a whole other can
>>> of worms we dont need to discuss now.
>>>
>>> with this cap of 255, the PMD scan/collapse would work as intended,
>>> then in mTHP collapses we would never introduce this undesired
>>> behavior. We've discussed before that this would be a hard problem to
>>> solve without introducing some expensive way of tracking what has
>>> already been through a collapse, and that doesnt even consider what
>>> happens if things change or are unmapped, and rescanning that section
>>> would be helpful. So having a strictly enforced limit of 255 actually
>>> seems like a good idea to me, as it completely avoids the undesired
>>> behavior and does not require the admins to be aware of such an issue.
>>>
>>> Another thought similar to what (IIRC) Dev has mentioned before, if we
>>> have max_ptes_none > 255 then we only consider collapses to the
>>> largest enabled order, that way no creep to the largest enabled order
>>> would occur in the first place, and we would get there straight away.
>>>
>>> To me one of these two solutions seem sane in the context of what we
>>> are dealing with.
>>>>
>>>>>>
>>>>>> ie)
>>>>>> if order!=HPAGE_PMD_ORDER && khugepaged_max_ptes_none > 255
>>>>>>        temp_max_ptes_none = 255;
>>>>> Oh and my second point, introducing a new tunable to control mTHP
>>>>> collapse may become exceedingly complex from a tuning and code
>>>>> management standpoint.
>>>>
>>>> Umm right now you hve a ratio expressed in PTES per mTHP * ((PTEs per PMD) /
>>>> PMD) 'except please don't set to the usual default when using mTHP' and it's
>>>> currently default-broken.
>>>>
>>>> I'm really not sure how that is simpler than a seprate tunable that can be
>>>> expressed as a ratio (e.g. percentage) that actually makes some kind of sense?
>>> I agree that the current tunable wasn't designed for this, but we
>>> tried to come up with something that leverages the tunable we have to
>>> avoid new tunables and added complexity.
>>>>
>>>> And we can make anything workable from a code management point of view by
>>>> refactoring/developing appropriately.
>>> What happens if max_ptes_none = 0 and the ratio is 50% - 1 pte
>>> (ideally the max number)? seems like we would be saying we want no new
>>> none pages, but also to allow new none pages. To me that seems equally
>>> broken and more confusing than just taking a scale of the current
>>> number (now with a cap).
>>>
>>>
>>
>> The one thing we absolutely cannot have is a default that causes this
>> 'creeping' behaviour. This feels like shipping something that is broken and
>> alluding to it in the documentation.
> Ok I've put a lot of thought and time into this and came up with a solution.
> 
> Here is what I currently have tested and would like to proposing:
> 
> - Expand bitmap to HPAGE_PMD_NR (512)*, this increases the accuracy of
> the max_pte_none handling, and removes a lot of inaccuracies caused by
> the compression into 128 bits that was being done. This also makes the
> code a lot easier to understand.

That sounds good to me. Should make the code easier as well.

> 
> - When attempting mTHP level collapses cap max_ptes_none to 255 to
> prevent the creep issue

I guess the documentation would then state something like

* When collapsing smaller THPs, "max_ptes_none" is scaled proportional
   to the THP size.
* When collapsing smaller THPs, "max_ptes_none" may be internally
   capped at 255 if it exceeds 255 but is not set to the default (511).

Not 100% a fan of all of that, but maybe the only option when wanting to 
avoid other toggles.

The only alternative would really be respecting only 0/511 for mTHP, and 
not doing any scaling. That would obviously make the documentation 
easier and would allow us to revisit that later. The documentation would be:

* When collapsing smaller THPs, "max_ptes_none" may be interpreted as
   "0"  when set to a value different to the default (511). This behavior
   might change in the future.

> 
> Ive tested this and found this performs better than my previous
> version, allows for more granular control via max_ptes_none, and
> prevents the creep issue without any admin knowledge needed.

How would this interact with the shrinker once extended to mTHP? Would 
your RFC patch be sufficient for that or would we actually also want to 
cap? I haven't; fully thought this through yet. I'd assume we would not 
want to cap here. Which makes the doc weird as well, lol.

-- 
Cheers

David / dhildenb


